using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;
using System.Management.Automation;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Windows.Forms;

namespace DAapp
{
    class Program : Helper
    {

        public static string sRepoUsername = string.Empty;
        public static string sRepoPassword = string.Empty;
        public static string sRepoServername = string.Empty;
        public static string sRepoDatabaseName = string.Empty;
        public static string sTemplatePath = string.Empty;

        public static string sJobServerName = string.Empty;
        public static string sJSPort = string.Empty;

        /// Inputs Required for DataStores Configuration

        public static string sRiskMasterDB = string.Empty;
        public static string sRMDBServer = string.Empty;
        public static string sRMDBUser = string.Empty;
        public static string sRMDBPwd = string.Empty;


        public static string sStagingDB = string.Empty;
        public static string sAccessStagingDB = string.Empty;
        public static string sRMXStagingDB = string.Empty;

        public static string sDataStoreFileName = string.Empty;
        public static string sATLFileName = string.Empty;
        public static string sS3XMLFileName = string.Empty;
        public static string sJOBxmlFileName = string.Empty;

        public static string sBucketName = string.Empty;
        public static string sAccessKey = string.Empty;
        public static string sSecretKey = string.Empty;
        public static string sRegion = string.Empty;

        public static string sATLFilePath = string.Empty;
        public static int sClientID = 0;


        //not used as of now

        public static string sStagingDBServer = string.Empty;
        public static string sStagingDBUser = string.Empty;
        public static string sStagingDBPwd = string.Empty;

        public static string sRMXStagingDBServer = string.Empty;
        public static string sRMXStagingDBUser = string.Empty;
        public static string sRMXStagingDBPwd = string.Empty;

        public static string module = string.Empty;
        public static string rmexpress = string.Empty;
        public static string spath = string.Empty;

        public static string xmlval = string.Empty;
        public static string sChildElement = string.Empty;
        public static XmlNode xmlDecryptedData;
        public static DateTime dd = DateTime.Now;
        public static string conStr = string.Empty;
        public static string assemblyver = string.Empty;
        public static string stagingdb = string.Empty;
        public static string accessdb = string.Empty;
        public static string rmxstagingdb = string.Empty;
        public static string Setrmexpress = string.Empty;
        public static string sqlconn = string.Empty;
        public static string orclconn = string.Empty;

        public static string sTaskManagerDB = string.Empty;
        public static string sTaskManagerDBUserName = string.Empty;
        public static string sTaskManagerDBPwD = string.Empty;
        public static string TaskManagerConnc = string.Empty;
        public static string sTaskManagerDBServer = string.Empty;
        public static string sSecurityDB = string.Empty;
        public static string sSecurityDBServer = string.Empty;
        public static string sSecurityDBUser = string.Empty;
        public static string sSecurityDBPwd = string.Empty;
        public static string logfilepath = string.Empty;  //exe start up path. 
        public static string processlogPath = string.Empty;  //exe start up path. 

        public static string sqldriver = string.Empty;
        public static string orcldriver = string.Empty;
        public static int iDSNID = 0;
        public static string sStagingDBconn = string.Empty;
        public static string sAccessStagingDBconn = string.Empty;
        public static string sRMXStagingDBconn = string.Empty;
        public static string sSecurityDBconn = string.Empty;
        public static string sDsnName = string.Empty;
        public static string sDAServerUserName = string.Empty;
        public static string sDAServerPwd = string.Empty;

        public static string sRMXLoginName = string.Empty;
        public static string sFilePath = string.Empty;
        public static string sDocAttachNameDelimeter = string.Empty;
        public static string sjobname = string.Empty;
        public static string sDocumentManagementEnabled = string.Empty;
        public static string srmADocumentPoolPath = string.Empty;
        public static string sKeepJobFilesOnSuccess = string.Empty;
        public static string sSUB_JOB_NAME = string.Empty;
        public static string sTaskname = string.Empty;

        public static string sWCFPath = string.Empty;
        public static string smodulePath = string.Empty;
        public static string sDAServer = string.Empty;
        public static string sDAServerPort = string.Empty;
        public static string sUnsecuressl = string.Empty;
        public static string endpoints = string.Empty;
        public static string sExePath = string.Empty;
        public static string sDAScriptsPath = string.Empty;
        public static string sBinpath = string.Empty;
        public static string sRmxinstallpath = string.Empty;
        public static string sDsndb = string.Empty;
        public static bool DSNValidated = false;
        public static Helper arguments = null;

        static void Main(string[] args)
        {
            ///System.Diagnostics.Debugger.Launch();
            DAapp.Generic.ProcessMessage = "DA Setup Started at:" + DateTime.Now + ".";

            //DAapp.Program.module = args[0]; 

            //arguments = new Helper();
            //arguments.Parse(args);
            DAapp.Generic.OutputMessage = "step1";
            ReadConfig();
            DAapp.Generic.OutputMessage = "step12";
            int count = 0;
            if (DAapp.Program.sDAScriptsPath.Contains('\"'))
            {
                DAapp.Generic.OutputMessage = "step3";
                count = DAapp.Program.sDAScriptsPath.LastIndexOf('\"');
                /// count = DAapp.Program.sDAScriptsPath.LastIndexOf('\\');
                DAapp.Program.sBinpath = DAapp.Program.sDAScriptsPath.Substring(0, count);
                DAapp.Program.sDAScriptsPath = DAapp.Program.sDAScriptsPath.Replace('"', '\\');
            }
            else
            {
                DAapp.Generic.OutputMessage = "step4";
                count = DAapp.Program.sDAScriptsPath.LastIndexOf('\\');
                DAapp.Program.sBinpath = DAapp.Program.sDAScriptsPath.Substring(0, count);
            }
            int count2 = DAapp.Program.sBinpath.LastIndexOf('\\');
            DAapp.Program.sBinpath = DAapp.Program.sBinpath.Substring(0, count2) + "\\";

            DAapp.Program.smodulePath = DAapp.Program.sDAScriptsPath + DAapp.Program.module + "\\";
            DAapp.Program.sExePath = DAapp.Program.sDAScriptsPath + "DA_EXE'S\\";

            count = DAapp.Program.sBinpath.LastIndexOf('\\');
            DAapp.Program.sWCFPath = DAapp.Program.sBinpath.Substring(0, count);
            count2 = DAapp.Program.sWCFPath.LastIndexOf('\\');
            DAapp.Program.sWCFPath = DAapp.Program.sWCFPath.Substring(0, count2) + "\\";

            count = DAapp.Program.sWCFPath.LastIndexOf('\\');
            DAapp.Program.sRmxinstallpath = DAapp.Program.sWCFPath.Substring(0, count);
            count2 = DAapp.Program.sRmxinstallpath.LastIndexOf('\\');
            DAapp.Program.sRmxinstallpath = DAapp.Program.sRmxinstallpath.Substring(0, count2);

            DAapp.Program.orcldriver = string.Empty;  // If connection is sql mark this as empty;

            GetConnectionStringInfo();

            try
            {


                if (DAapp.Program.module == "MMSEA")
                {
                    sATLFileName = "MMSEA_Medicare.atl";
                    sDataStoreFileName = "MMSEA_Datastores.xml";
                    sJOBxmlFileName = "MMSEAJOB.xml";
                    sSUB_JOB_NAME = "MMSEA";
                    sTaskname = "MMSEA";
                    sjobname = "J_MMSEA";
                }
                else if (DAapp.Program.module == "PPY")
                {
                    sATLFileName = "PositivePay.atl";
                    sDataStoreFileName = "PPY_Datastores.xml";
                    sJOBxmlFileName = "PPYJOB.xml";
                    sSUB_JOB_NAME = "PPY";
                    sTaskname = "PositivePay";
                    sjobname = "J_POSITVE_PAY";
                }
                else if (DAapp.Program.module == "1099")
                {
                    sATLFileName = "RM1099.atl";
                    sDataStoreFileName = "1099_Datastores.xml";
                    sJOBxmlFileName = "1099JOB.xml";
                    sSUB_JOB_NAME = "1099";
                    sTaskname = "1099-MISC";
                    sjobname = "J_1099";
                }
                else if (DAapp.Program.module == "SICS")
                {
                    sATLFileName = "DA_SICS.atl";
                    sDataStoreFileName = "SICS_Datastores.xml";
                    sJOBxmlFileName = "SICSJOB.xml";
                    sSUB_JOB_NAME = "SICS";
                    sTaskname = "SICS";
                    sjobname = "J_SICS";
                }
                else if (DAapp.Program.module == "ACH")
                {
                    sATLFileName = "ACH.atl";
                    sDataStoreFileName = "ACH_Datastores.xml";
                    sJOBxmlFileName = "ACHJOB.xml";
                    sSUB_JOB_NAME = "ACH";
                    sTaskname = "ACH";
                    sjobname = "J_ACH";
                }

                bool bRMlocVal = false;
                bool blnS3locval = false;
                // mkaur24 RM WCF/Bin setup starts 
                CheckDBConnection(); // Check taskmanager connection  and security db connection      
                int[] DSNDetails = new int[2];
                iDSNID = docpathtype(sDsnName, sSecurityDBconn)[0];
                DSNValidated = checkconnfordsn(DAapp.Program.sDsnName);
                DAapp.Generic.ProcessMessage = "DSNValidated:" + DSNValidated + ".";
                // sjobname = "J_" + module + "_" + iDSNID;


                ///// mkaur24 createdb function commented isliye start
                //DAapp.Program.sDsndb = "Driver={SQL Server};Server=20.198.139.104;Database=RM19_mk;UID=sa;PWD=Enter@789;";
                //DAapp.Program.sRMDBServer = "20.198.139.104";
                //DAapp.Program.sRepoDatabaseName = "Repo_MMSEA_12";
                //DAapp.Program.sStagingDB = "MMSEA_STAG_12";
                //DAapp.Program.sStagingDBconn = "Driver={SQL Server};Server=20.198.139.104;Database=MMSEA_STAG_12;UID=sa;pwd=Enter@789;";
                //DAapp.Program.sRepoServername = "20.198.139.104";
                //DAapp.Program.sRepoUsername = "sa";
                //DAapp.Program.sRepoPassword = "Enter@789";
                //DAapp.Program.sStagingDBServer = "20.198.139.104";
                //DAapp.Program.sStagingDBUser = "sa";
                //DAapp.Program.sStagingDBPwd = "Enter@789";
                //DAapp.Program.sRMXStagingDBServer = "20.198.139.104";
                //DAapp.Program.sRMXStagingDBUser = "sa";
                //DAapp.Program.sRMXStagingDBPwd = "Enter@789";
                ///// mkaur24 createdb function commented isliye endsv (remove this)



                // RM Setup commented as of now starts

                sDocAttachNameDelimeter = "/";//hardcoded rahega;
                /// sDocumentManagementEnabled = "true";//this should not be given in case of mmsea. The job is faLLING DOWN
                srmADocumentPoolPath = DAapp.Program.sFilePath; //this is mandatory. Has to be on rmserver
                sKeepJobFilesOnSuccess = "true";





                bRMlocVal = CheckRMloc(DAapp.Program.sDAScriptsPath);

                blnS3locval = CheckS3loc(); // check if s3 location is accessible.                
                CreateWSDURL();

                //if (blnS3locval || bRMlocVal)
                //    ErrorEnc = true;
                RMExpressSetup();
                GetExeConfigFiles();
                UpdateConfigFiles();


                if (!ModuleExist)
                {


                    // FUNCTION TO DELETE DB IF ANY ERROR OCCURS       

                    Helper objHelper = new Helper();

                    /// DA Setup Starts


                    sS3XMLFileName = "AmazonS3.xml";
                    sTemplatePath = DAapp.Program.sDAScriptsPath + module;
                    sATLFilePath = sTemplatePath + sATLFileName;       /// not used  

                    int sJobServerapp = Convert.ToInt32(GetConfigKey("JobserverLastused"));
                    sJobServerapp = sJobServerapp + 1;
                    string appPath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
                    string configFile = System.IO.Path.Combine(appPath, "DAapp.EXE.config");
                    ExeConfigurationFileMap configFileMap = new ExeConfigurationFileMap();
                    configFileMap.ExeConfigFilename = configFile;
                    System.Configuration.Configuration config = ConfigurationManager.OpenMappedExeConfiguration(configFileMap, ConfigurationUserLevel.None);
                    config.AppSettings.Settings["JobserverLastused"].Value = sJobServerapp.ToString();
                    config.Save();
                    sJSPort = sJobServerapp.ToString();     // job server -1025 to 32766  ///49151
                    sJobServerName = "JS_" + module + "_" + sJSPort;
                    DAapp.Generic.ProcessMessage = "JobServerName Created" + sJobServerName + ".";

                    /// If password has $ in it. Handling for powershell start
                    if(DAapp.Program.sRMDBPwd.Contains("$"))
                    {
                        DAapp.Program.sRMDBPwd=DAapp.Program.sRMDBPwd.Replace("$","`$");
                    }
                    if (DAapp.Program.sSecurityDBPwd.Contains("$"))
                    {
                        DAapp.Program.sSecurityDBPwd=DAapp.Program.sSecurityDBPwd.Replace("$", "`$");
                    }
                    if (DAapp.Program.sStagingDBPwd.Contains("$"))
                    {
                        DAapp.Program.sStagingDBPwd= DAapp.Program.sStagingDBPwd.Replace("$", "`$");
                    }
                    if (DAapp.Program.sRMXStagingDBPwd.Contains("$"))
                    {
                        DAapp.Program.sRMXStagingDBPwd=DAapp.Program.sRMXStagingDBPwd.Replace("$", "`$");
                    }



                    /// If password has $ in it. Handling for powershell startends



                    string DAServer = DAapp.Program.sDAServer;
                    string username = DAapp.Program.sDAServerUserName;
                    string password = DAapp.Program.sDAServerPwd;
                    string sModuleName = DAapp.Program.module;
                    string RMTemplatePath = DAapp.Program.smodulePath;
                    string RMFileName = sATLFileName;
                    string DSFileName = sDataStoreFileName;
                    string S3FileName = sS3XMLFileName;
                    string DATemplatePath = @"C:\DA_SCRIPTS\";
                    string sUsername = DAapp.Program.sRepoUsername; // use yhi horhe hain.  username pwd and servername. As per real time everything will be on same server so we can use this.has to be becuase servname seggregation is not done in atl ds
                    string sPassword = DAapp.Program.sRepoPassword;
                    string sServername = DAapp.Program.sRepoServername;
                    string sDatabaseName = DAapp.Program.sRepoDatabaseName;
                    string sRMDBPwd = DAapp.Program.sRMDBPwd;  // see this ye kaha se ayega
                    string sRMDBName = DAapp.Program.sRiskMasterDB;
                    string sRMDBUser = DAapp.Program.sRMDBUser;
                    string sSecPwd = DAapp.Program.sSecurityDBPwd;
                    string sSecDBName = DAapp.Program.sSecurityDB;
                    string sSecUser = DAapp.Program.sSecurityDBUser;
                    string sSecServer = DAapp.Program.sSecurityDBServer;
                    string sStagPwd = DAapp.Program.sStagingDBPwd;
                    string sStagDBName = DAapp.Program.sStagingDB;
                    string sStagUser = DAapp.Program.sStagingDBUser;
                    string sRMXStagPwd = DAapp.Program.sRMXStagingDBPwd;
                    string sRMXStagDBName = DAapp.Program.sRMXStagingDB;
                    string sRMXStagUser = DAapp.Program.sRMXStagingDBUser;
                    string BucketName = DAapp.Program.sBucketName;
                    string S3AccessKey = DAapp.Program.sAccessKey;
                    string S3SecretKey = DAapp.Program.sSecretKey;
                    string DSJobFileName = sJOBxmlFileName;
                    string JobName = sjobname;
                    string FilePath = sFilePath;


                    // as of now code because 172.31.43.96 IS PRIVATE IP AND IT WILL NOT BE ACCESSED FROM 232 DA SERVER SO REPLACEING IT WITH public ip
                    if (DAapp.Program.sRMDBServer == "172.31.37.15")
                    {
                        sSecServer = sServername = GetConfigKey("rmdbseverasofnow");

                    }
                    //string publicIp = "20.198.154.160";
                    //string username = @"Asiapac\mkaur24";
                    //string password = "Welcome@1";
                    //string sModuleName = "MMSEA";
                    //string RMTemplatePath = @"E:\rmcode6\Riskmaster\WCFService\bin\DA_SCRIPTS\MMSEA\";
                    //string RMFileName = "MMSEA_Medicare.atl";
                    //string DSFileName = "MMSEA_Datastores.xml";
                    //string S3FileName = "AmazonS3.xml";
                    //string DATemplatePath = @"C:\DA_SCRIPTS\";
                    //string sUsername = "sa";
                    //string sPassword = "Enter@789";
                    //string sServername = "20.198.139.11";
                    //string sDatabaseName = "Repomk21";
                    //string sJobServerName = "JSmeamk213";
                    //string sJSPort = "4594";
                    //string sRMDBPwd = "Enter@789";
                    //string sRMDBName = "RM19_mk";
                    //string sRMDBUser = "sa";
                    //string sSecPwd = "Enter@789";
                    //string sSecDBName = "Security_mk";
                    //string sSecUser = "sa";
                    //string sStagPwd = "Enter@789";
                    //string sStagDBName = "MMSEA_STAG_12";
                    //string sStagUser = "sa";
                    //string sRMXStagPwd = "Enter@789";
                    //string sRMXStagDBName = "MMSEA_STAG_12";
                    //string sRMXStagUser = "sa";
                    //string BucketName = "rmadebucket1";
                    //string S3AccessKey = "AKIA4IBYFUZMUHMMKYT6";
                    //string S3SecretKey = "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";
                    //string FilePath="C:\Filepath"

                    if (DAapp.Program.module == "SICS")
                    {
                        sStagDBName = DAapp.Program.sRMXStagingDB;

                    }

                    string[] test = { DAServer, username, password, sModuleName, RMTemplatePath, RMFileName, DSFileName, S3FileName, DATemplatePath,
                sUsername,sPassword,sServername ,sDatabaseName,sJobServerName,sJSPort,sRMDBPwd,sRMDBName,sRMDBUser,sSecPwd,sSecDBName,sSecUser,
            sStagPwd,sStagDBName,sStagUser,sRMXStagPwd,sRMXStagDBName,sRMXStagUser,BucketName,S3AccessKey,S3SecretKey,sSecServer,DSJobFileName,JobName,FilePath};

                    // mkaur24 start powershell exexcution starts

                    DAapp.Generic.ProcessMessage = DAServer + " , " + username + " , " + password + " , " + sModuleName + " , " + RMTemplatePath + " , " + RMFileName + " , " + DSFileName + " , " + S3FileName + " , " + DATemplatePath + " , " +
                    sUsername + " , " + sPassword + " , " + sServername + " , " + sDatabaseName + " , " + sJobServerName + " , " + sJSPort + " , " + sRMDBPwd + " , " + sRMDBName + " , " + sRMDBUser + " , " + sSecPwd + " , " + sSecDBName + " , " + sSecUser + " , " +
                sStagPwd + " , " + sStagDBName + " , " + sStagUser + " , " + sRMXStagPwd + " , " + sRMXStagDBName + " , " + sRMXStagUser + " , " + BucketName + " , " + S3AccessKey + " , " + S3SecretKey + " , " + sSecServer;
                    var scriptfile = DAapp.Program.sDAScriptsPath + "DASetupScript.ps1";

                    String line = string.Empty;
                    Collection<PSObject> results = null;
                    using (StreamReader sr = new StreamReader(scriptfile))
                    {
                        line = sr.ReadToEnd();
                    }
                    using (var powershell = PowerShell.Create())
                    {
                        powershell.AddScript(line, false);
                        powershell.Invoke();
                        powershell.Commands.Clear();
                        ////  powershell.AddCommand("GetParams").AddParameter("password", "foo");
                        powershell.AddCommand("GetParameter").AddParameter("arr", test);
                        results = powershell.Invoke();
                    }
                    DAapp.Generic.ProcessMessage = "DA setup ends.";

                    //StringBuilder stringBuilder = new StringBuilder();
                    //foreach (PSObject obj in results)
                    //{
                    //    try
                    //    {
                    //        if (!string.IsNullOrEmpty(obj.ToString()))
                    //            stringBuilder.AppendLine(obj.ToString());
                    //    }
                    //    catch (Exception ex)
                    //    {

                    //    }

                    //}

                    //  WriteDAProcessLog(stringBuilder.ToString());



                    ///// Now moved this work to Power Shell Start


                    ///// Create DA Repository           
                    //objHelper.ExectueAutomationCommands("R", sRepoUsername, sRepoPassword, sRepoServername, sRepoDatabaseName, null, null, null, null, null, null, null, null);
                    //Console.WriteLine("DA Repo Created.Successful.");

                    ///// Import ATL
                    //objHelper.ExectueAutomationCommands("A", sRepoUsername, sRepoPassword, sRepoServername, sRepoDatabaseName, sATLFilePath, null, null, null, null, null, null, null);
                    //Console.WriteLine("ATL Imported.Successful");

                    /////Create Job Server 
                    //objHelper.ExectueAutomationCommands("J", sRepoUsername, sRepoPassword, sRepoServername, sRepoDatabaseName, sATLFilePath, sJobServerName, sJSPort, null, null, null, null, null);
                    //Console.WriteLine("Job Server Created.Successful");

                    ///// Stop Services 
                    //objHelper.ExectueAutomationCommands("Stop", null, null, null, null, null, null, null, null, null, null, null, null);
                    //Console.WriteLine("SAP Services Stopped.");

                    ///// Start Services 
                    //objHelper.ExectueAutomationCommands("Start", null, null, null, null, null, null, null, null, null, null, null, null);
                    //Console.WriteLine("SAP Services Started.");

                    ///// Get SAP Encrypted Password for RMDB
                    //objHelper.ExectueAutomationCommands("RMDBPWD", null, null, null, null, null, null, null, sRMDBPwd, null, null, null, null);

                    //// Get SAP Encrypted Password for StagingDB
                    //objHelper.ExectueAutomationCommands("StagPWD", null, null, null, null, null, null, null, null, null, sStagingDBPwd, null, null);
                    //// Get SAP Encrypted Password for SecurityDB
                    //objHelper.ExectueAutomationCommands("SecPWD", null, null, null, null, null, null, null, null, sSecurityDBPwd, null, null, null);


                    ///// Update DataStore Configuration
                    //objHelper.AddDataStoreConfiguration(sTemplatePath, sDataStoreFileName, sRiskMasterDB, sRMDBServer, sRMDBUser, EncryptRMDBPwd, sSecurityDB, sSecurityDBServer, sSecurityDBUser, EncryptSecPwd, sStagingDB, sStagingDBServer, sStagingDBUser, EncryptStagPwd);

                    ///// Import DataStore XML
                    //objHelper.ExectueAutomationCommands("X", sRepoUsername, sRepoPassword, sRepoServername, sRepoDatabaseName, XMLFilePathMod, null, null, null, null, null, null, null);
                    //Console.WriteLine("DataStore Configuration.Successful");

                    ///// Get SAP Encrypted Password for S3AccessKey
                    //objHelper.ExectueAutomationCommands("S3AccessKey", null, null, null, null, null, null, null, null, null, null, sAccessKey, null);

                    ///// Get SAP Encrypted Password for S3SecretKey
                    //objHelper.ExectueAutomationCommands("S3SecretKey", null, null, null, null, null, null, null, null, null, null, null, sSecretKey);

                    ///// Update Amazon S3 XML
                    //objHelper.AddS3FileLocation(sTemplatePath, sS3XMLFileName, sBucketName, S3SecretKey, S3AccessKey);

                    ///// Import Amazon S3 XML
                    //objHelper.ExectueAutomationCommands("X", sRepoUsername, sRepoPassword, sRepoServername, sRepoDatabaseName, S3XMLFilePathMod, null, null, null, null, null, null, null);
                    //Console.WriteLine("Amazon S3 Configuration.Successful");

                    ///// Now moved this work to Power Shell Ends



                    //            }
                    //catch (Exception ex)
                    //{
                    //    if (ErrorEnc)
                    //        CreateDB("", "Drop");
                    //}
                    //finally
                    //{

                    //}
                }
                else

                {
                    DAapp.Generic.OutputMessage = "The module already exists." + DAapp.Program.module;
                    DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                    /// CreateDB(module, "Drop");
                    Environment.Exit(0);
                }
            }
            catch (Exception e)
            {
                DAapp.Generic.OutputMessage = "Exe completed with error.Error Message:" + e.Message;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                //Environment.Exit(0);
            }
            finally
            {
                if (ErrorEnc)
                {
                    CreateDB(module, "Drop");
                    Environment.Exit(0);
                }
                DAapp.Generic.writeLog(DAapp.Generic.ProcessMessage, Path.Combine(DAapp.Program.processlogPath));

            }
        }

        //DA Setup Ends

        static public void ReadConfig()
        {
            DAapp.Generic.ProcessMessage = "Read Config Started.";

            DAapp.Program.module = GetConfigKey("ModuleName");
            DAapp.Program.sDAScriptsPath = GetConfigKey("DAScriptsPath");// hardcodedappconfig
            DAapp.Program.sBucketName = GetConfigKey("BucketName");
            DAapp.Program.sAccessKey = GetConfigKey("AccessKey");
            DAapp.Program.sSecretKey = GetConfigKey("SecretKey");
            DAapp.Program.sRegion = GetConfigKey("Region");
            DAapp.Program.sRMXLoginName = GetConfigKey("RMXLoginName");
            DAapp.Program.sDAServer = GetConfigKey("DAServer");
            DAapp.Program.sDAServerPort = GetConfigKey("DAServerPort");
            DAapp.Program.sUnsecuressl = GetConfigKey("Unsecuressl");
            DAapp.Program.sDsnName = GetConfigKey("DSN");
            DAapp.Program.sDAServerUserName = GetConfigKey("DAServerUserName");
            DAapp.Program.sDAServerPwd = GetConfigKey("DAServerPwd");

            DAapp.Program.sqlconn = GetConfigKey("sqlconn"); //hardcoded appconfig
            DAapp.Program.orclconn = GetConfigKey("orclconn");//no
            DAapp.Program.sFilePath = GetConfigKey("sFilePath");//no
            DAapp.Generic.ProcessMessage = "Read Config Ended.";

            ///   DAapp.Program.sDsnName = "MK_RMA2";


        }
        private string LoadScript(string filename)
        {

            try
            {
                // Create an instance of StreamReader to read from our file. 
                // The using statement also closes the StreamReader. 
                using (StreamReader sr = new StreamReader(filename))
                {

                    // use a string builder to get all our lines from the file 
                    StringBuilder fileContents = new StringBuilder();

                    // string to hold the current line 
                    string curLine;

                    // loop through our file and read each line into our 
                    // stringbuilder as we go along 
                    while ((curLine = sr.ReadLine()) != null)
                    {
                        // read each line and MAKE SURE YOU ADD BACK THE 
                        // LINEFEED THAT IT THE ReadLine() METHOD STRIPS OFF 
                        fileContents.Append(curLine + "\n");
                    }

                    // call RunScript and pass in our file contents 
                    // converted to a string 
                    return fileContents.ToString();
                }
            }
            catch (Exception e)
            {
                // Let the user know what went wrong. 
                string errorText = "The file could not be read:";
                errorText += e.Message + "\n";
                return errorText;
            }
        }
    }
}


