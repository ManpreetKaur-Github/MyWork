$publicIp = ""
$username = ""
$password = ""     	
$sModuleName = ""       
$RMTemplatePath = ""
$RMFileName= ""
$DSFileName = ""
$S3FileName = ""
$DATemplatePath = ""
$sUsername = ""
$sPassword = "" 
$sServername = ""
$sDatabaseName = ""        
$sJobServerName = ""
$sJSPort= ""
$sRMDBPwd = ""
$sRMDBName = ""
$sRMDBUser = ""
$sSecPwd = ""
$sSecDBName = ""
$sSecUser = "" 
$sStagPwd= ""
$sStagDBName = ""
$sStagUser = "" 
$sRMXStagDBName = ""
$sRMXStagUser = ""
$BucketName = ""
$S3AccessKey= ""
$S3SecretKey= ""







try
{

    
Function DASetup()
{

echo "DA setup initaited."



#Enable-PSRemoting
#winrm quickconfig
#Remote to the created instance through powershell
Set-Item WSMan:\localhost\Client\TrustedHosts "*" -Force
#set-item wsman:\localhost\shell\maxshellsperuser 50

#$username = "ASIAPAC\udoni"
#$password = "Utk@rsh02"


$securepassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securepassword)


#Enter-PSSession -ComputerName $privateIp -Credential $creds
#Wait until PSSession is available
while ($true)
{

#$publicDNS can be replaced with private ipcls 
$s = New-PSSession $publicIp  -Credential $creds 2>$null
       
if ($s -ne $null)
{
"Session connected!"                  
break
}
#might be server was force restarted
"$(Get-Date) Waiting for remote PS connection"
Sleep -Seconds 30        
}

if($s -ne $null)    {	      
"Now your are in the instance session"
}
#enter the session instance and fire the powershell scripts
#enter-pssession $s
#Sleep -Seconds 20


############################# Create Directory If not exists already Starts ##########################

#echo "Create Directory If not exists already Starts"
#$dir = $DATemplatePath

#if(!(Test-Path -Path $dir )){
#    New-Item -ItemType directory -Path $dir
#    Echo "$DATemplatePath created"
#}
#else
#{
#  echo "Folder $DATemplatePath already exists"
#}

echo "Create Directory If not exists already Starts"
$dir = $RMFilepath

echo $RMFilepath

if(!(Test-Path -Path $dir )){
     
                
   $scriptBlock = {    
         echo $args[0]
             $setupFolder = $args[0]
             echo  $setupFolder
             Write-Host "Creating SetupSoftwareAndFiles Folder"
             New-Item -Path $setupFolder -type directory -Force 
             Write-Host "Folder creation complete"
         }  
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $RMFilepath 

    Echo "$RMFilepath created"
}
else
{
  echo "Folder $DATemplatePath already exists"
}

echo "Create Directory If not exists already Starts"
$dir = $DATemplatePath

if(!(Test-Path -Path $dir )){
 
   $scriptBlock = {    
         
             $setupFolder = $args[0]
             
             Write-Host "Creating SetupSoftwareAndFiles Folder"
             New-Item -Path $setupFolder -type directory -Force 
             Write-Host "Folder creation complete"
         }  
Invoke-Command -Session $s -ScriptBlock $scriptBlock -ArgumentList $DATemplatePath 



    Echo "$DATemplatePath created"
}
else
{
  echo "Folder $DATemplatePath already exists"
}





############################ Create Directory If not exists already Ends ##########################

######################################### First: Copy Required files to DA server Starts ############################

$sAmazonS3File = "{0}{1}" -f $RMTemplatePath, $S3FileName
$sDSFile = "{0}{1}" -f $RMTemplatePath, $DSFileName
$sATLFile ="{0}{1}" -f $RMTemplatePath, $RMFileName
$sJobNamexml ="{0}{1}" -f $RMTemplatePath, $DSJobFileName

Copy-Item -Path $sATLFile -Destination $DATemplatePath –ToSession $s
echo "Copied Atl file from" $sATLFile "to" $DATemplatePath     
     
Copy-Item -Path $sAmazonS3File -Destination $DATemplatePath –ToSession $s
echo "Copied S3 from" $sAmazonS3File "to" $DATemplatePath
     
Copy-Item -Path $sDSFile -Destination $DATemplatePath –ToSession $s
echo "Copied Datastores from" $sDSFile "to" $DATemplatePath

Copy-Item -Path $sJobNamexml -Destination $DATemplatePath –ToSession $s
echo "Copied JOB from" $sJobNamexml "to" $DATemplatePath
##########################################Copy Required files to DA server Ends ############################




#########################################Copy Required files to DA server Ends ############################



$scriptBlock = {

$sAtlPath = "{0}{1}{2}" -f "-f" , $args[6], $args[7]
$sWPassword ="{0}{1}" -f "-W", $args[1]
$sPPassword= "{0}{1}" -f "-P", $args[1]
$sSServername="{0}{1}" -f "-S", $args[2]
$sUUsername= "{0}{1}" -f "-U", $args[0] 
$sQDatabaseName= "{0}{1}" -f "-Q", $args[3]
$sJJobServerName ="{0}{1}" -f "-J", $args[4]
$sPJSPort="{0}{1}" -f "-P", $args[5]
$sPassphrase = "{0}{1}" -f "-p ", "mk"
$seRMDBPwd = "{0}{1}" -f "-e ", $args[8]
$seSecPwd = "{0}{1}" -f "-e ", $args[9]
$seStagPwd = "{0}{1}" -f "-e ", $args[10]
$seRMXStagPwd = "{0}{1}" -f "-e ", $args[11]

$eS3AccessKey =   "{0}{1}" -f "-e ", $args[12]
$eS3SecretKey= "{0}{1}" -f "-e ", $args[13]
$BucketName = $args[14]

$sAmazonS3FileDA = "{0}{1}" -f $args[6], $args[16]
$sDSFileDA = "{0}{1}" -f $args[6], $args[17]
$sATLFileDA ="{0}{1}" -f $args[6], $args[18]
$DATemplatePath =$args[6]
$sJobNamexmlDA ="{0}{1}" -f $args[6], $args[22]
$sJobName=$args[23]

 
$sRMDBName =$args[19]
$sSecDBName =$args[20]
$sStagDBName =$args[21]
$sServername =$args[2]
$sUsername=$args[0] 

echo "sJJobServerName" $sJJobServerName
echo "sQDatabaseName" $sQDatabaseName

#$sEncryptpswd="+0400000000120303000803E85B4DA745C9BFEC61984718E620A3EDE722DD296C83178DAEBA69FB8BE552329AA3FC518B903D82B97BD0BC3CB65A518E85"
#$sEncryptpswd= powershell cmd /c "'C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_encrypt.exe' $seRMDBPwd $sPassphrase" 
#echo  $sEncryptpswd
#echo  "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\RepoManbatch" $sUUsername $sPPassword $sSServername $sQDatabaseName 

echo "mkaur24 satrt again"
echo  powershell cmd /c "'C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_encrypt.exe' $seRMDBPwd $sPassphrase"
if($args[8]){
$sEncRMDBpwd= powershell cmd /c "'C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_encrypt.exe' $seRMDBPwd $sPassphrase"
echo  "RMDB Encrypted Password $sEncRMDBpwd"
echo "Rmdb pswd $seRMDBPwd"
}
if($args[12]){
$sEncS3AccessKey=  powershell cmd /c "'C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_encrypt.exe' $eS3AccessKey $sPassphrase"  
#$EncS3AccessKey ="$sEncS3AccessKey"
echo  "S3 Access Key Encrypted Password $sEncS3AccessKey"
}
if($args[13]){
$sEncS3SecretKey=  powershell cmd /c "'C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_encrypt.exe' $eS3SecretKey $sPassphrase" 
echo  "S3 Secret Key Encrypted Password $sEncS3SecretKey" 
}


echo "Repo Creation started"
echo "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\RepoManbatch" $sUUsername  $sPPassword $sSServername $sQDatabaseName 
$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\RepoManbatch" $sUUsername -o $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER
$remoteresult

echo  "Repo Created " $remoteresult

echo "Atl export started"

$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $sAtlPath
$remoteresult
echo  "Atl exported " $remoteresult

echo "Job Server Creation started"
echo "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\AWServerConfig.exe"  $sJJobServerName $sPJSPort  $sUUsername $sWPassword  $sSServername $sQDatabaseName
$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\AWServerConfig.exe" -n $sJJobServerName $sPJSPort -d $sUUsername $sWPassword -NMicrosoft_SQL_Server $sSServername $sQDatabaseName
$remoteresult  


echo  "Job Server Created " $remoteresult

net stop DI_JOBSERVICE

net start DI_JOBSERVICE  

################################## Setup Commands Complteted #############################
#
#
#
################################# S3 XML manipulation starts #########################################

echo "S3 XML manipulation starts"
$builxmlpath = $sAmazonS3FileDA;
echo "sAmazonS3FileDA $sAmazonS3FileDA "

#$builxmlpath = "E:\rmcode6\Riskmaster\WCFService\bin\DA_SCRIPTS\MMSEA\AmazonS3.xml";
if(Test-Path $builxmlpath -PathType Leaf)
{
$xml = [xml](Get-Content $builxmlpath)


$value = $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_bucket
echo $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_bucket
if ($value -eq "%bucketname%")
{
$xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_bucket=$BucketName
echo $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_bucket
}

$value = $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_accesskey
if ($value -eq "")
{
$xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_accesskey= "$sEncS3AccessKey"
echo $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_accesskey
}

$value = $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_secretkey
if ($value -eq "")
{
$xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_secretkey="$sEncS3SecretKey"
echo $xml.DataIntegratorExport.DIFileLocationDatastore.DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration.fl_s3_secretkey
   
}
$xml.Save($builxmlpath)

}
################################ S3 XML manipulation Ends #########################################

################################ Job XML manipulation Starts #########################################


echo "JOB XML manipulation starts"

$builxmlpath =$sJobNamexmlDA
echo "JOB XML $sJobNamexmlDA "
$DIJobName =$sJobName
echo "sJobName $sJobName"

$xml = [xml](Get-Content $builxmlpath)


$count =$xml.DataIntegratorExport.DIJob.DIAttributes.DIAttribute.Count
 For ($i=0; $i -lt $count; $i++) {

     if($xml.DataIntegratorExport.DIJob.DIAttributes.DIAttribute.name[$i] -eq "job_name")
     {
        $value=   $xml.DataIntegratorExport.DIJob.DIAttributes.DIAttribute.value[$i]
        echo "i is $i"
        echo "DIAttribute Orignal value $value" 
        $xml.DataIntegratorExport.DIJob.DIAttributes.DIAttribute[$i].value=$DIJobName
        $value=   $xml.DataIntegratorExport.DIJob.DIAttributes.DIAttribute.value[$i]
        echo "DIAttribute Modified value $value" 
        break
     }
 }

$value =$xml.DataIntegratorExport.DIProject.DIJobRef.name
echo "DIProject Orignal value $value"
$xml.DataIntegratorExport.DIProject.DIJobRef.name=$DIJobName

$value =$xml.DataIntegratorExport.DIJob.name
echo "DIJob Orignal value $value"
$xml.DataIntegratorExport.DIJob.name = $DIJobName

$xml.Save($builxmlpath)



################################ Job XML manipulation Ends #########################################

################################ DATASTORES manipulation Ends #########################################

#$sDSFileDA = 'C:\Users\rmde\Desktop\MK\SICS\SICS_Datastores.xml'
#$sRMDBName = "RMMain";
#$sServername ='rmdevdb.czzs5ufirit6.us-west-2.rds.amazonaws.com';
#$sUsername= 'rmuser'
#$sStagDBName ='MMSEA_STAG_2'
#$sEncRMDBpwd ="+0400000000120303000803E8A8E1A4C555CF4546322EA51B915AC0112B7676E62FE034E0107D10043D89F73228E32AD55F38AE55E19228E01FAF1BE1BB"

echo "DataStores XML manipulation Starts"
echo $sDSFileDA
$builxmlpath =$sDSFileDA ;

if (Test-Path $builxmlpath -PathType Leaf)
{
$xml = [xml](Get-Content $builxmlpath)

$DatabaseDatastorecount = $xml.DataIntegratorExport.DIDatabaseDatastore.Count

for ($j=0; $j -lt $DatabaseDatastorecount; $j++)
{

For ($i=0; $i -le 5; $i++) {

$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database 
         
if ($value -eq "RISKMASTER DB" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sRMDBName
}
elseif ($value -eq "SECURITYDB" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sSecDBName
}
elseif ($value -eq "Staging DB Name" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sStagDBName
}
elseif ($value -eq "STAGING DB" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sStagDBName
}
elseif ($value -eq "RMX Statging Database" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sStagDBName
}

if ($value -eq "SQL Database Name" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_database  =$sRMDBName
}

}
     
For ($i=0; $i -le 5; $i++) {

$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_dataserver 
         
if ($value -eq "SQL Server Name" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].sql_server_dataserver  =$sServername 
}       
}

For ($i=0; $i -le 5; $i++) {

$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].user 
         
if ($value -eq "RMDBUSER" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].user  =$sUsername
}
elseif ($value -eq "SECURITYDBUser" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].user  =$sUsername
}
elseif ($value -eq "STAGINGDBUser" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].user  =$sUsername
} 
elseif ($value -eq "RMXStagingDBUser" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].user  =$sUsername
}       
}

For ($i=0; $i -le 5; $i++)
{
        
$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].password 
         
if ($value -eq "" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].password  ="$sEncRMDBpwd"
echo "$sEncRMDBpwd"
}              
}

For ($i=0; $i -le 5; $i++) {
        
$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].case_sensitive 
         
if ($value -eq "no" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].case_sensitive  ="yes"
}              
}

For ($i=0; $i -le 5; $i++) {
        
$value = $xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].db_alias_user1 
         
if ($value -eq "RMDBUSER" )
{
$xml.DataIntegratorExport.DIDatabaseDatastore[$j].DIAttributes.DIAttribute[6].DSConfigurations.DSConfiguration[$i].db_alias_user1  =$sUsername
}              
}
}


$DITableCount=  $xml.DataIntegratorExport.DITable.Count

for ($j=0; $j -lt $DITableCount; $j++)
{
echo $J
$value =  $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value 
echo $value
if ($value -eq "RISKMASTER DB" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value   =$sRMDBName
echo $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value 
} 
if ($value -eq "SQL Database Name" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value   =$sRMDBName
echo $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value 
} 
elseif ($value -eq "SECURITYDB" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value  =$sSecDBName
echo $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value
} 
elseif ($value -eq "Staging DB Name" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value  =$sStagDBName
echo $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value
}
elseif ($value -eq "RMX Statging Database" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value  =$sStagDBName
}
elseif ($value -eq "STAGING DB" )
{
$xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value  =$sStagDBName
echo $xml.DataIntegratorExport.DITable[$j].Attributes["database"].Value
}
}

$xml.Save($builxmlpath)
echo "DataStores XML manipulation Ends"
}


################################# DataStores XML manipulation Ends #########################################
#
#
#### Import S3 XML into Repo
echo "Importing of XML starts"




$DSFileDA ="{0}{1}" -f  "-XI", $sDSFileDA 
echo "DSFileDA $DSFileDA  for sDSFileDA $sDSFileDA  "

$AmazonS3FileDA = "{0}{1}" -f  "-XI", $sAmazonS3FileDA
echo "AmazonS3FileDA  $AmazonS3FileDA   for sAmazonS3FileDA $sAmazonS3FileDA  "

$passphrasexml = "{0}{1}" -f  "-passphrase", "mk"
echo "passphrasexml  $passphrasexml  "

$JobFileDA ="{0}{1}" -f  "-XI", $sJobNamexmlDA
echo "DSFileDA JobFileDA  for sDSFileDA $JobFileDA  "
  

echo "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $DSFileDA $passphrasexml 
echo "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $AmazonS3FileDA $passphrasexml  
echo "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $JobFileDA $passphrasexml
#"C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" -Usa -PEnter@789 -S20.198.156.132 -QRepomk21 -tlocal -c -d -NMicrosoft_SQL_SERVER -XIC:\DA_SCRIPTS\MMSEA_Datastores.xml -passphrasemk

#$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $JobFileDA $passphrasexml
#$remoteresult
#echo  "JOB XML Imported " 
#echo $JobFileDA


$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $AmazonS3FileDA $passphrasexml
$remoteresult
echo  "Amazon S3 XML Imported " 
echo $AmazonS3FileDA 

$remoteresult = & cmd /c "C:\Program Files (x86)\SAP BusinessObjects\Data Services\bin\al_engine" $sUUsername $sPPassword $sSServername $sQDatabaseName -tlocal -c -d -NMicrosoft_SQL_SERVER $DSFileDA $passphrasexml 
$remoteresult
echo  " Datastores XML Imported " 
echo $DSFileDA 



}
Invoke-Command -session $s -ScriptBlock $scriptBlock -ArgumentList $sUsername, $sPassword, $sServername, $sDatabaseName ,$sJobServerName ,$sJSPort, $DATemplatePath,$RMFileName,$sRMDBPwd,$sSecPwd, $sStagPwd, $sRMXStagPwd ,$S3AccessKey,$S3SecretKey,$BucketName,$RMTemplatePath, $S3FileName,$DSFileName,$RMFileName,$sRMDBName,$sSecDBName,$sStagDBName, $DSJobFileName,$JobName

Remove-PSSession $s

}

Function GetParameter($arr)
#Function GetParameter()
{
 #[hashtable]$Return = @{} 
#  $Return.ReturnCode = [int]1 
#  $Return.Add("ReturnString", $arr[0]); 
#   $Return.Add("publicIp",  $publicIp);
#  Return $Return 
           
$publicIp = $arr[0]
$username = $arr[1]
$password =$arr[2]           	
$sModuleName = $arr[3]          
$RMTemplatePath = $arr[4]   
$RMFileName=  $arr[5] 
$DSFileName = $arr[6] 
$S3FileName = $arr[7] 
$DATemplatePath = $arr[8] 
$sUsername =  $arr[9] 
$sPassword = $arr[10] 
$sServername =  $arr[11] 
$sDatabaseName = $arr[12]           
$sJobServerName =  $arr[13] 
$sJSPort=  $arr[14] 
$sRMDBPwd =  $arr[15] 
$sRMDBName =  $arr[16] 
$sRMDBUser = $arr[17] 
$sSecPwd = $arr[18] 
$sSecDBName =  $arr[19] 
$sSecUser =  $arr[20] 
$sStagPwd = $arr[21] 
$sStagDBName = $arr[22] 
$sStagUser = $arr[23] 
$sRMXStagPwd = $arr[24] 
$sRMXStagDBName = $arr[25] 
$sRMXStagUser =  $arr[26] 
$BucketName =  $arr[27] 
$S3AccessKey= $arr[28] 
$S3SecretKey= $arr[29] 
$sSecServer= $arr[30]
$DSJobFileName= $arr[31]
$JobName= $arr[32]
$RMFilepath=$arr[33]



"The publicIp is $publicIp "
"The username is $username "
"The password is $password "      	
"The sModuleName is $sModuleName "
"The RMTemplatePath is $RMTemplatePath "
"The RMFileName is $RMFileName "
"The DSFileName is $DSFileName "      	
"The S3FileName is $S3FileName "
"The DATemplatePath is $DATemplatePath "
"The sUsername is  $sUsername "
"The sPassword is $sPassword "      	
"The sServername is $sServername "
"The sDatabaseName is $sDatabaseName "
"The sJobServerName is $sJobServerName "
"The sJSPort is $sJSPort "      	
"The sRMDBPwd is $sRMDBPwd "
"The sRMDBName is $sRMDBName "
"The sRMDBUser is  $sRMDBUser "
"The sSecPwd is $sSecPwd "      	
"The sSecDBName  is $sSecDBName  "
"The sSecUser is $sSecUser "
"The sStagPwd is $sStagPwd "
"The sStagDBName is $sStagDBName "      	
"The sStagUser is $sStagUser "
"The sRMXStagPwd is $sRMXStagPwd "
"The sRMXStagDBName is $sRMXStagDBName"
"The sRMXStagUser is  $sRMXStagUser "
"The BucketName is $BucketName "      	
"The S3AccessKey  is $S3AccessKey  "
"The S3SecretKey is  $S3SecretKey "
"The sSecServer is  $sSecServer "
"The DSJobFileName is  $DSJobFileName"
"The JobName is $JobName"
"The Filepath is $RMFilepath"

DASetup

}

GetParameter

}
catch
{
[hashtable]$Return = @{} 
$Return.ReturnCode = [int]5
$Return.Add("ReturnString", $_); 
Return $Return 

}
