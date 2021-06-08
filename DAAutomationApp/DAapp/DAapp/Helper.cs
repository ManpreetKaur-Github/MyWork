using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Threading;
using System.Diagnostics;
using System.Configuration;
using Riskmaster.Db;
using System.Text.RegularExpressions;
using Amazon;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.EC2.Model;
using System.Net;
using System.Data;
using System.Data.SqlClient;
using Riskmaster.Security.Encryption;
using Microsoft.Win32;
using System.Windows.Forms;

namespace DAapp
{
    class Helper
    {
        static protected string m_EncryptRMDBPwd = string.Empty;
        static protected string m_EncryptSecPwd = string.Empty;
        static protected string m_EncryptStagPwd = string.Empty;
        static protected string m_XMLFilePathMod = string.Empty;
        static protected string m_XMLFilePath = string.Empty;
        static protected string m_S3XMLFilePath = string.Empty;
        static protected string m_S3XMLFilePathMod = string.Empty;
        static protected string m_EncryptS3AccessKey = string.Empty;
        static protected string m_EncryptS3SecretKey = string.Empty;
        public static Dictionary<string, List<string>> dictSelectedItems = null;
        public static string db = string.Empty;
        public static bool m_bModuleExist = false;
        public static bool m_bStagTablesforDSN = false;
        public static int m_iTaskTypeID = 0;
        public static bool m_bErrorEnc = false;
        public static List<string> m_sDBList;
        public static string dsnpwd = string.Empty;
        public static string userid = string.Empty;

        static public int TaskTypeID
        {
            get { return m_iTaskTypeID; }
            set { m_iTaskTypeID = value; }
        }

        static public List<string> DBList
        {
            get { return m_sDBList; }
            set { m_sDBList = value; }
        }
        static public bool ModuleExist
        {
            get { return m_bModuleExist; }
            set { m_bModuleExist = value; }
        }

        static public bool StagTablesforDSN
        {
            get { return m_bStagTablesforDSN; }
            set { m_bStagTablesforDSN = value; }
        }
        static public bool ErrorEnc
        {
            get { return m_bErrorEnc; }
            set { m_bErrorEnc = value; }
        }


        static public string EncryptRMDBPwd
        {
            get { return m_EncryptRMDBPwd; }
            set { m_EncryptRMDBPwd = value; }
        }

        static public string EncryptSecPwd
        {
            get { return m_EncryptSecPwd; }
            set { m_EncryptSecPwd = value; }
        }

        static public string EncryptStagPwd
        {
            get { return m_EncryptStagPwd; }
            set { m_EncryptStagPwd = value; }
        }

        static public string XMLFilePathMod
        {
            get { return m_XMLFilePathMod; }
            set { m_XMLFilePathMod = value; }
        }

        static public string S3XMLFilePath
        {
            get { return m_S3XMLFilePath; }
            set { m_S3XMLFilePath = value; }
        }

        static public string S3XMLFilePathMod
        {
            get { return m_S3XMLFilePathMod; }
            set { m_S3XMLFilePathMod = value; }
        }

        static public string XMLFilePath
        {
            get { return m_XMLFilePath; }
            set { m_XMLFilePath = value; }
        }

        static public string S3AccessKey
        {
            get { return m_EncryptS3AccessKey; }
            set { m_EncryptS3AccessKey = value; }
        }

        static public string S3SecretKey
        {
            get { return m_EncryptS3SecretKey; }
            set { m_EncryptS3SecretKey = value; }
        }



        public void ExectueAutomationCommands(string sType, string sUsername, string sPassword, string sServername, string sDatabaseName, string sATLFilePath, string sJobServerName, string sJSPort, string sRMDBPwd, string sSecurityDBPwd, string sStagingDBPwd, string sAccesskey, string sSecretKey)
        {
            string strCmdText = string.Empty;
            //System.Diagnostics.Process.Start("CMD.exe", strCmdText);

            if (sType == "R")
                strCmdText = " /c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\RepoManbatch\"" + " -U" + sUsername + " -o" + " -P" + sPassword + " -S" + sServername + " -Q" + sDatabaseName + " -tlocal" + " -c -d -NMicrosoft_SQL_SERVER";
            else if (sType == "A")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_engine\"" + " -U" + sUsername + " -P" + sPassword + " -S" + sServername + " -Q" + sDatabaseName + " -tlocal -c -d -NMicrosoft_SQL_SERVER" + " -f" + sATLFilePath;
            else if (sType == "J")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\AWServerConfig.exe\"" + " -n" + " -J" + sJobServerName + " -P" + sJSPort + " -d" + " -U" + sUsername + " -W" + sPassword + " -NMicrosoft_SQL_Server" + " -S" + sServername + " -Q" + sDatabaseName;
            else if (sType == "Stop")
                strCmdText = "/c net stop DI_JOBSERVICE";
            else if (sType == "Start")
                strCmdText = "/c net start DI_JOBSERVICE";
            else if (sType == "RMDBPWD")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_encrypt\"" + " -e " + sRMDBPwd + " -p mk";
            else if (sType == "StagPWD")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_encrypt\"" + " -e " + sStagingDBPwd + " -p mk";
            else if (sType == "SecPWD")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_encrypt\"" + " -e " + sSecurityDBPwd + " -p mk";
            else if (sType == "X")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_engine\"" + " -U" + sUsername + " -P" + sPassword + " -S" + sServername + " -Q" + sDatabaseName + " -tlocal -c -d -NMicrosoft_SQL_SERVER" + " -XI" + sATLFilePath + " -passphrasemk";
            else if (sType == "S3AccessKey")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_encrypt\"" + " -e " + sAccesskey + " -p mk";
            else if (sType == "S3SecretKey")
                strCmdText = "/c \"C:\\Program Files (x86)\\SAP BusinessObjects\\Data Services\\bin\\al_encrypt\"" + " -e " + sSecretKey + " -p mk";



            if (sType == "RMDBPWD" || sType == "StagPWD" || sType == "SecPWD" || sType == "S3AccessKey" || sType == "S3SecretKey")
            {
                System.Diagnostics.ProcessStartInfo procStartInfo = new System.Diagnostics.ProcessStartInfo("cmd", strCmdText);
                procStartInfo.RedirectStandardOutput = true;
                procStartInfo.UseShellExecute = false;
                procStartInfo.CreateNoWindow = false;
                System.Diagnostics.Process proc = new System.Diagnostics.Process();
                proc.StartInfo = procStartInfo;
                proc.Start();
                string result = proc.StandardOutput.ReadToEnd();
                if (sType == "RMDBPWD")
                    m_EncryptRMDBPwd = result.Replace(System.Environment.NewLine, string.Empty);
                else if (sType == "StagPWD")
                    m_EncryptStagPwd = result.Replace(System.Environment.NewLine, string.Empty);
                else if (sType == "SecPWD")
                    m_EncryptSecPwd = result.Replace(System.Environment.NewLine, string.Empty);
                else if (sType == "S3AccessKey")
                    m_EncryptS3AccessKey = result.Replace(System.Environment.NewLine, string.Empty);
                else if (sType == "S3SecretKey")
                    m_EncryptS3SecretKey = result.Replace(System.Environment.NewLine, string.Empty);
            }
            else
            {
                using (Process exeProcess = System.Diagnostics.Process.Start("CMD.exe", strCmdText))
                {
                    exeProcess.WaitForExit();
                }
            }
        }

        public virtual void Parse(string[] args)
        {



            if (args.Length > 0)
            {
                DAapp.Generic.ProcessMessage = "Read Config Started.";

                DAapp.Program.sDsnName = args[0]; //GetConfigKey("DSN");
                DAapp.Program.module = args[1]; //GetConfigKey("ModuleName");
                DAapp.Program.sqlconn = args[2]; //GetConfigKey("sqlconn"); //hardcoded appconfig
                DAapp.Program.orclconn = args[3]; // GetConfigKey("orclconn");//no
                DAapp.Program.sBucketName = args[4]; //GetConfigKey("BucketName");
                DAapp.Program.sAccessKey = args[5]; //GetConfigKey("AccessKey");
                DAapp.Program.sSecretKey = args[6]; //GetConfigKey("SecretKey");
                DAapp.Program.sRegion = args[7]; //GetConfigKey("Region");
                DAapp.Program.sUnsecuressl = args[8]; //GetConfigKey("Unsecuressl");
                DAapp.Program.sClientID = Convert.ToInt32(args[9]);
                DAapp.Program.sRMXLoginName = args[10]; // GetConfigKey("RMXLoginName");
                DAapp.Program.sFilePath = args[11]; //GetConfigKey("sFilePath");//no                
                DAapp.Program.sDAServer = args[12]; //GetConfigKey("DAServer");               
                DAapp.Program.sDAServerUserName = args[13]; //GetConfigKey("DAServerUserName");
                DAapp.Program.sDAServerPwd = args[14]; // GetConfigKey("DAServerPwd");
                DAapp.Program.sDAServerPort = args[15]; //GetConfigKey("DAServerPort");
                DAapp.Program.sDAScriptsPath = args[16]; // GetConfigKey("DAScriptsPath");// hardcodedappconfig 

                DAapp.Generic.ProcessMessage = "Read Config Ended.";

            }
        }
        public void AddDataStoreConfiguration(string sTemplatePath, string sXMLFileName, string sRiskMasterDB, string sRMDBServer, string sRMDAappser, string sRMDBPwd,
          string sSecurityDB, string sSecurityDBServer, string sSecurityDAappser, string sSecurityDBPwd, string sStagingDB, string sStagingDBServer, string sStagingDAappser, string sStagingDBPwd)
        {
            XmlDocument doc = null;
            XmlNodeList elemList = null;
            doc = new XmlDocument();

            var xmlDoc = new XmlDocument();
            m_XMLFilePath = sTemplatePath + @"\" + sXMLFileName;
            m_XMLFilePathMod = sTemplatePath + @"\" + "modifiedmk.xml";


            if (File.Exists(m_XMLFilePath))
            {
                xmlDoc.Load(m_XMLFilePath);

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("sql_server_database"))
                {

                    //if (node.InnerText == "RISKMASTER DB")
                    //    node.InnerText = "EDI_Florida_DD";
                    //else if (node.InnerText == "SECURITYDB")
                    //    node.InnerText = "DD_SESSION_181";
                    //else if (node.InnerText == "Staging DB Name")
                    //    node.InnerText = "DD_RMX_STAGING";

                    if (node.InnerText == "RISKMASTER DB")
                        node.InnerText = sRiskMasterDB;
                    else if (node.InnerText == "SECURITYDB")
                        node.InnerText = sSecurityDB;
                    else if (node.InnerText == "Staging DB Name")
                        node.InnerText = sStagingDB;
                }


                foreach (XmlNode node in xmlDoc.GetElementsByTagName("sql_server_dataserver"))
                {

                    //if (node.InnerText == "SQL Server Name")
                    //    node.InnerText = "20.198.154.156";

                    if (node.InnerText == "SQL Server Name")
                        node.InnerText = sRMDBServer;

                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("user"))
                {

                    //if (node.InnerText == "RMDAappSER")
                    //    node.InnerText = "sa";
                    //if (node.InnerText == "SECURITYDAappser")
                    //    node.InnerText = "sa";
                    //if (node.InnerText == "STAGINGDAappser")
                    //    node.InnerText = "sa";

                    if (node.InnerText == "RMDAappSER")
                        node.InnerText = sRMDAappser;
                    if (node.InnerText == "SECURITYDAappser")
                        node.InnerText = sRMDAappser;
                    if (node.InnerText == "STAGINGDAappser")
                        node.InnerText = sRMDAappser;


                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("password"))
                {

                    //if (node.InnerText == "")
                    //    node.InnerText = "+0400000000120303000803E8ED47338367C0724CCB7A8A4315C29C9985A214EE2A1DECC9C2D70CE60C67A89C63B0DE0FC39B6C80B37888C38D9EADE46B";

                    if (node.InnerText == "")
                        node.InnerText = EncryptRMDBPwd;
                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("case_sensitive"))
                {

                    if (node.InnerText == "no")
                        node.InnerText = "yes";

                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("db_alias_user1"))
                {

                    //if (node.InnerText == "RMDAappSER")
                    //    node.InnerText = "sa";

                    if (node.InnerText == "RMDAappSER")
                        node.InnerText = sRMDAappser;

                }

                int count = xmlDoc.GetElementsByTagName("DITable").Count;
                elemList = xmlDoc.GetElementsByTagName("DITable");
                for (int i = 0; i < count; i++)
                {
                    //if (elemList[i].Attributes["database"].Value == "RISKMASTER DB")
                    //    elemList[i].Attributes["database"].Value = "EDI_Florida_DD";
                    //else if (elemList[i].Attributes["database"].Value == "SECURITYDB")
                    //    elemList[i].Attributes["database"].Value = "DD_SESSION_181";
                    //else if (elemList[i].Attributes["database"].Value == "Staging DB Name")
                    //    elemList[i].Attributes["database"].Value = "DD_RMX_STAGING";

                    if (elemList[i].Attributes["database"].Value == "RISKMASTER DB")
                        elemList[i].Attributes["database"].Value = sRiskMasterDB;
                    else if (elemList[i].Attributes["database"].Value == "SECURITYDB")
                        elemList[i].Attributes["database"].Value = sSecurityDB;
                    else if (elemList[i].Attributes["database"].Value == "Staging DB Name")
                        elemList[i].Attributes["database"].Value = sStagingDB;
                }


                xmlDoc.Save(XMLFilePathMod);
            }
            else { }

        }


        public void AddS3FileLocation(string TemplatePath, string S3XMLFileName, string BucketName, string S3SecretKey, string S3AccessKey)
        {
            XmlDocument doc = null;
            XmlNodeList elemList = null;
            doc = new XmlDocument();

            var xmlDoc = new XmlDocument();
            m_S3XMLFilePath = TemplatePath + @"\" + S3XMLFileName;
            m_S3XMLFilePathMod = TemplatePath + @"\" + "AmazonS3Mod.xml";


            if (File.Exists(m_S3XMLFilePath))
            {
                xmlDoc.Load(m_S3XMLFilePath);



                foreach (XmlNode node in xmlDoc.GetElementsByTagName("fl_bucket"))
                {

                    if (node.InnerText == "%bucketname%")
                        node.InnerText = BucketName;

                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("fl_s3_accesskey"))
                {

                    if (node.InnerText == "")
                        node.InnerText = S3AccessKey;

                }

                foreach (XmlNode node in xmlDoc.GetElementsByTagName("fl_s3_secretkey"))
                {

                    if (node.InnerText == "")
                        node.InnerText = S3SecretKey;

                }

                //int count = xmlDoc.GetElementsByTagName("DITable").Count;
                //elemList = xmlDoc.GetElementsByTagName("DITable");
                //for (int i = 0; i < count; i++)
                //{
                //    //if (elemList[i].Attributes["database"].Value == "RISKMASTER DB")
                //    //    elemList[i].Attributes["database"].Value = "EDI_Florida_DD";
                //    //else if (elemList[i].Attributes["database"].Value == "SECURITYDB")
                //    //    elemList[i].Attributes["database"].Value = "DD_SESSION_181";
                //    //else if (elemList[i].Attributes["database"].Value == "Staging DB Name")
                //    //    elemList[i].Attributes["database"].Value = "DD_RMX_STAGING";

                //    if (elemList[i].Attributes["database"].Value == "RISKMASTER DB")
                //        elemList[i].Attributes["database"].Value = sRiskMasterDB;
                //    else if (elemList[i].Attributes["database"].Value == "SECURITYDB")
                //        elemList[i].Attributes["database"].Value = sSecurityDB;
                //    else if (elemList[i].Attributes["database"].Value == "Staging DB Name")
                //        elemList[i].Attributes["database"].Value = sStagingDB;
                //}


                xmlDoc.Save(S3XMLFilePathMod);
            }
            else { }

        }


        static public string GetConfigKey(string keyName)
        {
            string DAMod = System.Configuration.ConfigurationManager.AppSettings[keyName];
            return (DAMod == null ? string.Empty : DAMod);
        }





        public static void CreateWSDURL()
        {
            if (DAapp.Program.sUnsecuressl == "true")
                DAapp.Program.endpoints = "https://" + DAapp.Program.sDAServer + ":" + DAapp.Program.sDAServerPort + "/DataServices";
            else
                DAapp.Program.endpoints = "http://" + DAapp.Program.sDAServer + ":" + DAapp.Program.sDAServerPort + "/DataServices";
            ///servlet/webservices?ver=2.1
            try
            {
                HttpWebRequest request = WebRequest.Create(DAapp.Program.endpoints) as HttpWebRequest;
                //Setting the Request method HEAD, you can also use GET too.
                request.Method = "HEAD";
                //Getting the Web Response.

                HttpWebResponse response = request.GetResponse() as HttpWebResponse;
                //Returns TRUE if the Status code == 200
                response.Close();
                if (response.StatusCode == HttpStatusCode.OK)
                {

                }
                else
                {
                    DAapp.Generic.OutputMessage = "Given information for Data Analytics server is not valid";
                    DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                    return;

                }
            }
            catch (Exception ex)
            {
                DAapp.Generic.OutputMessage = "Given information for Data Analytics server is not valid";
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                ErrorEnc = true;
                return;
            }
        }

        public static void GetExeConfigFiles()
        {
            string sFileName = "assemblies.config|bindings.config|dataintegrator.config|endpoints.config|RMEXPRESS_TASK_MGR_SCRIPT_SQL.SQL|RMEXPRESS_TASK_MGR_SCRIPT_ORACLE.SQL|";
            sFileName = sFileName + "SharedInterfaces.dll|";
            sFileName = sFileName + "DA_" + DAapp.Program.module + ".exe" + "|" + "DA_" + DAapp.Program.module + ".exe.config" + "|";
            string fileName = string.Empty;

            string[] files;
            char[] delimiters = { '|', ',', '\t' };
            files = sFileName.Split(delimiters);


            if (System.IO.Directory.Exists(DAapp.Program.sExePath))
            {

                foreach (string s in files)
                {
                    string destFile = string.Empty;
                    string sourceFile = string.Empty;
                    sourceFile = System.IO.Path.Combine(DAapp.Program.sExePath, s);
                    destFile = System.IO.Path.Combine(DAapp.Program.sBinpath, s);
                    try
                    {
                        File.Copy(sourceFile, destFile);
                    }
                    catch (Exception ex)
                    {
                        if (ex.ToString().Contains("already exists"))
                            System.IO.File.Copy(sourceFile, destFile, true);
                    }

                }
            }
            else
            {
                DAapp.Generic.OutputMessage = "File " + fileName + "Does not exists at:" + DAapp.Program.sExePath;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                return;
            }
        }

        public static void UpdateConfigFiles()
        {
            bool unsecuressl = false;
            string key = string.Empty;
            string rmaurl = "http://";
            string wsdl = string.Empty;

            try
            {


                XmlDocument doc2 = new XmlDocument();
                string wcfpath = DAapp.Program.sWCFPath;
                doc2.Load(Path.Combine(wcfpath, "web.config"));
                XmlNamespaceManager manager1 = new XmlNamespaceManager(doc2.NameTable);
                manager1.AddNamespace("bindings", "urn:schemas-microsoft-com:asm.v1");
                foreach (XmlNode item in doc2.SelectNodes("//binding/security", manager1))
                {
                    if (item.Attributes["mode"].Value == "Transport")
                    {
                        unsecuressl = true;
                    }

                }

                XmlDocument docappsettings = new XmlDocument();
                wcfpath = DAapp.Program.sWCFPath;
                docappsettings.Load(Path.Combine(wcfpath, "appSettings.config"));
                XmlNamespaceManager managerappsettings = new XmlNamespaceManager(docappsettings.NameTable);
                managerappsettings.AddNamespace("bindings", "urn:schemas-microsoft-com:asm.v1");
                foreach (XmlNode item in docappsettings.SelectNodes("//appSettings/add", managerappsettings))
                {
                    if (item.Attributes["key"].Value == "BaseServiceUrl")
                    {

                        key = item.Attributes["value"].Value;
                    }
                }

                // if DA server is secured then set its trabsport mode in bindings.
                if ((DAapp.Program.endpoints.Contains("https")))
                {
                    XmlDocument doc4 = new XmlDocument();
                    doc4.Load(Path.Combine(DAapp.Program.sBinpath, "bindings.config"));
                    foreach (XmlNode item in doc4.SelectNodes("//binding"))
                    {
                        if (item.Attributes["name"].Value == "Connection_Operations" || item.Attributes["name"].Value == "Batch_Jobs" || item.Attributes["name"].Value == "Real-time_Services" || item.Attributes["name"].Value == "Batch_Job_Admin" || item.Attributes["name"].Value == "Profiling")
                        {

                            item.SelectSingleNode("security").Attributes["mode"].Value = "Transport";

                        }

                    }
                    FileInfo file5 = new FileInfo(DAapp.Program.sBinpath + "\\bindings.config");
                    file5.Attributes = FileAttributes.Normal;
                    doc4.Save(Path.Combine(DAapp.Program.sBinpath, "bindings.config"));

                }

                rmaurl = rmaurl + Environment.MachineName;
                if (unsecuressl == true)
                {
                    rmaurl = rmaurl.Replace("http", "https");
                }

                wsdl = DAapp.Program.endpoints + "/servlet/webservices?ver=2.1";
                FileInfo file = new FileInfo(DAapp.Program.sBinpath + "\\endpoints.config");
                string text1 = File.ReadAllText(DAapp.Program.sBinpath + "\\endpoints.config");
                text1 = text1.Replace("%WSDLURI%", wsdl);
                file.Attributes = FileAttributes.Normal;
                File.WriteAllText(DAapp.Program.sBinpath + "\\endpoints.config", text1);


                ////now updating selected modules exe config
                XmlDocument doc1 = new XmlDocument();
                doc1.Load(Path.Combine(DAapp.Program.sBinpath, "DA_" + DAapp.Program.module + ".exe.config"));
                XmlNamespaceManager manager = new XmlNamespaceManager(doc1.NameTable);
                manager.AddNamespace("bindings", "urn:schemas-microsoft-com:asm.v1");
                foreach (XmlNode item in doc1.SelectNodes("//appSettings/add", manager))
                {
                    if (item.Attributes["key"].Value == "UseUnsecureSSL")
                    {
                        item.Attributes["value"].Value = unsecuressl.ToString();
                    }


                    if (File.Exists(Path.Combine(DAapp.Program.sBinpath, "DA_" + DAapp.Program.module + ".exe.config")))
                    {
                        FileInfo file1 = new FileInfo(DAapp.Program.sBinpath + "\\DA_" + DAapp.Program.module + ".exe.config");
                        file1.Attributes = FileAttributes.Normal;
                    }
                    doc1.Save(Path.Combine(DAapp.Program.sBinpath, "DA_" + DAapp.Program.module + ".exe.config"));
                }

                {
                    FileInfo file2 = new FileInfo(DAapp.Program.sBinpath + "\\DA_" + DAapp.Program.module + ".exe.config");
                    string text = File.ReadAllText(DAapp.Program.sBinpath + "\\DA_" + DAapp.Program.module + ".exe.config");
                    int count = DAapp.Program.sBinpath.LastIndexOf('\\');
                    string sInstallpath = DAapp.Program.sBinpath.Substring(0, count);
                    text = text.Replace("%InstallPath%", sInstallpath);
                    text = text.Replace("%WSDLURIEndpoint%", wsdl);
                    file2.Attributes = FileAttributes.Normal;
                    File.WriteAllText(DAapp.Program.sBinpath + "\\DA_" + DAapp.Program.module + ".exe.config", text);
                }

                //create data analytics folder and update dataIntegrator.config        


                string temppath = "\\\\" + Environment.MachineName + "\\temp";

                string uipath = DAapp.Program.sRmxinstallpath + "\\temp";
                /// uipath = DAapp.Program.sRmxinstallpath + "\\Riskmaster\\temp";

                if (Directory.Exists(uipath))
                {
                    if (!Directory.Exists(uipath + "\\DataAnalytics")) //assuming if directory is already created then full permissions are also there
                    {
                        Directory.CreateDirectory(uipath + "\\DataAnalytics");

                    }
                }

                XmlDocument docaws = new XmlDocument();
                docaws.Load(Path.Combine(DAapp.Program.sBinpath, "dataintegrator.config"));
                XmlNamespaceManager manageraws = new XmlNamespaceManager(docaws.NameTable);
                manageraws.AddNamespace("bindings", "urn:schemas-microsoft-com:asm.v1");
                foreach (XmlNode item in docaws.SelectNodes("//appSettings/add", manageraws))
                {

                    if (item.Attributes["key"].Value == "AWSAccessKey")
                    {
                        item.Attributes["value"].Value = DAapp.Program.sAccessKey;

                    }
                    if (item.Attributes["key"].Value == "AWSSecretKey")
                    {
                        item.Attributes["value"].Value = DAapp.Program.sSecretKey;

                    }
                    if (item.Attributes["key"].Value == "Region")
                    {
                        item.Attributes["value"].Value = DAapp.Program.sRegion;

                    }
                    if (item.Attributes["key"].Value == "S3BucketOnCloud")
                    {
                        item.Attributes["value"].Value = DAapp.Program.sBucketName; ;

                    }

                }
                if (File.Exists(DAapp.Program.sBinpath + "\\dataintegrator.config"))
                {
                    FileInfo file1 = new FileInfo(DAapp.Program.sBinpath + "\\dataintegrator.config");
                    file1.Attributes = FileAttributes.Normal;
                }
                docaws.Save(DAapp.Program.sBinpath + "\\dataintegrator.config");

                XmlDocument docaws1 = new XmlDocument();
                docaws1.Load(Path.Combine(DAapp.Program.sBinpath, "dataintegrator.config"));
                XmlNamespaceManager manageraws1 = new XmlNamespaceManager(docaws1.NameTable);
                manageraws1.AddNamespace("bindings", "urn:schemas-microsoft-com:asm.v1");
                foreach (XmlNode item in docaws1.SelectNodes("//appSettings/add", manageraws1))
                {

                    if (item.Attributes["key"].Value == "BaseServiceUrl")
                    {
                        item.Attributes["value"].Value = key;

                    }
                }
                docaws1.Save(DAapp.Program.sBinpath + "\\dataintegrator.config");
                FileInfo files = new FileInfo(DAapp.Program.sBinpath + "\\dataintegrator.config");
                string text2 = File.ReadAllText(DAapp.Program.sBinpath + "\\dataintegrator.config");

                text2 = text2.Replace("%RMXInstallPath%", DAapp.Program.sRmxinstallpath);
                text2 = text2.Replace("%TempUNC%", temppath);
                text2 = text2.Replace("%TempLocal%", temppath);

                files.Attributes = FileAttributes.Normal;
                File.WriteAllText(DAapp.Program.sBinpath + "\\dataintegrator.config", text2);



                FileInfo fil = new FileInfo(DAapp.Program.sBinpath + "\\dataintegrator.config");
                string destDirapi = DAapp.Program.sRmxinstallpath + "\\RiskmasterAPI\\bin";
                if (Directory.Exists(destDirapi))
                {
                    FileInfo destFileapi = new FileInfo(Path.Combine(destDirapi, fil.Name));
                    if (destFileapi.Exists)
                    {

                        // now you can safely overwrite it
                        fil.CopyTo(destFileapi.FullName, true);

                    }
                    else
                    {
                        File.Copy(DAapp.Program.sBinpath + "\\dataintegrator.config", destDirapi + "\\dataintegrator.config");

                    }


                    FileInfo file3 = new FileInfo(DAapp.Program.sBinpath + "\\connectionStrings.config");
                    string destDir = wcfpath;
                    FileInfo destFile = new FileInfo(Path.Combine(destDir, file3.Name));
                    if (destFile.Exists)
                    {

                        // now you can safely overwrite it
                        file3.CopyTo(destFile.FullName, true);

                    }
                }
            }
            catch (Exception ex)
            {
                DAapp.Generic.OutputMessage = ex.Message;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                ErrorEnc = true;
                throw;

            }
        }
        static public void CheckDBConnection()
        {
            DAapp.Generic.ProcessMessage = "Check DB Connection started.";
            DAapp.Program.logfilepath = Path.Combine(DAapp.Program.sDAScriptsPath, "DAappLogs.log");
            DAapp.Program.processlogPath = Path.Combine(DAapp.Program.sDAScriptsPath, "DAappProcessLog.log");
            DAapp.Generic.ProcessMessage = "Check DB connection for TaskManagerDB " + DateTime.Now + ".";
            ///DAapp.Program.TaskManagerConnc = "Driver={SQL Server};Server=" + DAapp.Program.sTaskManagerDBServer + ";Database=" + DAapp.Program.sTaskManagerDB + ";UID=" + DAapp.Program.sTaskManagerDBUserName + ";PWD=" + DAapp.Program.sTaskManagerDBPwD + ";";
            DAapp.Generic.VerifyConnection(DAapp.Program.TaskManagerConnc);

            /// DAapp.Program.sSecurityDBconn = "Driver={SQL Server};Server=" + DAapp.Program.sSecurityDBServer + ";Database=" + DAapp.Program.sSecurityDB + ";UID=" + DAapp.Program.sSecurityDBUser + ";PWD=" + DAapp.Program.sSecurityDBPwd + ";";
            DAapp.Generic.VerifyConnection(DAapp.Program.sSecurityDBconn);



            DAapp.Program.logfilepath = Path.Combine(DAapp.Program.sDAScriptsPath, "DAappLogs");
            // DAapp.Program.stagingdb = "Driver={SQL Server};Server=20.198.139.136;Database=SECURITY_mk;UID=sa;PWD=Enter@789;";
        }

        public static bool CheckS3loc()
        {
            bool blnS3locval = false;
            AmazonS3Config asc = new AmazonS3Config
            {
                RegionEndpoint = RegionEndpoint.GetBySystemName(DAapp.Program.sRegion)
            };
            using (AmazonS3Client client1 = new AmazonS3Client(DAapp.Program.sAccessKey, DAapp.Program.sSecretKey, asc))
            {
                GetObjectRequest request = new GetObjectRequest();
                request.BucketName = DAapp.Program.sBucketName;


                try
                {
                    GetObjectResponse response = client1.GetObject(request);
                    if (response.ResponseStream != null)
                    {
                        blnS3locval = true;
                    }
                }
                catch (AmazonS3Exception amazonS3Exception)
                {

                    if (amazonS3Exception.Message.Contains("signature"))
                        DAapp.Generic.OutputMessage = "Secret Key you provided does not match the signature";
                    else
                        DAapp.Generic.OutputMessage = amazonS3Exception.Message;
                    DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                    ErrorEnc = true;
                    throw;
                }

                return blnS3locval;
            }
        }

        public static bool CheckRMloc(string path)
        {
            bool bRMlocVal = false;
            if (Directory.Exists(path))
                bRMlocVal = true;
            else
            {
                DAapp.Generic.OutputMessage = "Path is inaccessible: " + path;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                ErrorEnc = true;

            }
            return bRMlocVal;

        }
        public static void RMExpressSetup()
        {
            int count = 0;
            try
            {
                DbConnection objConn = null;
                objConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc);
                objConn.Open();
                string tcheck = String.Empty;
                if (objConn.DatabaseType.ToString() == "DBMS_IS_ORACLE")
                {
                    tcheck = "select count(*) from user_tables where table_name='DA_CONFIG'";

                }
                else
                {
                    tcheck = "select count (*) from information_schema.tables where table_name ='DA_CONFIG'";
                }
                count = Convert.ToInt32(objConn.ExecuteScalar(tcheck));
                if (count > 0)
                {
                    DAapp.Generic.OutputMessage = "DA is already set as RM express.";
                    DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                    CheckModuleExist();                    
                    if (!ModuleExist)
                    {
                        StagDetailsForDSNID();
                        CreateDB(DAapp.Program.module, "");
                        ModuleScripts();
                    }
                }
                else
                {

                    CreateDB(DAapp.Program.module, "");
                    // Create DA Config Table run related scripts.
                    DAapp.Generic.OutputMessage = "Executing the RM express scripts on Task Manager Database...";
                    char[] strDelimiters1 = new[] { '|' };
                    string[] arrRmExpressScript = new[] { String.Empty };
                    List<string> lstScrpt = new List<string>();
                    string strRmExpressScript = ConfigurationManager.AppSettings["RmExpressScript"];
                    arrRmExpressScript = strRmExpressScript.Split(strDelimiters1, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string script in arrRmExpressScript)
                    {

                        //lstScrpt.Add(Path.Combine(DAapp.Program.sBinpath, script));      //template path     //mkaur24 i am chaing this to daexe's path because files is not found neither copied here             
                        lstScrpt.Add(Path.Combine(DAapp.Program.sExePath, script));
                    }
                    foreach (string fname in lstScrpt)
                    {


                        if (!string.IsNullOrEmpty(DAapp.Program.orclconn) && Path.GetFileName(fname).ToUpper().Contains("SQL."))
                        {
                            continue;
                        }
                        if (!string.IsNullOrEmpty(DAapp.Program.sqlconn) && Path.GetFileName(fname).ToUpper().Contains("ORACLE."))
                        {
                            continue;
                        }

                        if (File.Exists(fname))
                        {
                            FileInfo file4 = new FileInfo(fname);
                            string script1 = file4.OpenText().ReadToEnd();
                            script1 = script1.Replace("\r\nGO\r\n", "");
                            DbFactory.ExecuteNonQuery(DAapp.Program.TaskManagerConnc, Convert.ToString(script1));
                        }
                        else
                        {
                            DAapp.Generic.OutputMessage = "File not found at path " + fname;
                            Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                        }

                        // System.Configuration.Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);

                        //config.AppSettings.Settings["RmExpressToExecute"].Value = "No";//if script is executed it will set RmExpressToExecute node to NO at runtime
                        //config.Save(ConfigurationSaveMode.Modified);                      
                    }
                    ModuleScripts();
                }
            }
            catch (Exception e)
            {
                DAapp.Generic.OutputMessage = "Unable to connect to TaskManagerDatabase of connection string:" + DAapp.Program.TaskManagerConnc;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                ErrorEnc = true;
            }
        }

        public static void CheckModuleExist()
        {

            int iDSNID = 0;
            string ssql = "SELECT TASK_TYPE_ID FROM TM_TASK_TYPE WHERE NAME ='" + DAapp.Program.sTaskname + "'";
            using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
            {
                dbConn.Open();
                m_iTaskTypeID = Convert.ToInt32(dbConn.ExecuteScalar(ssql));
                dbConn.Close();
            }

            ssql = string.Empty;
            ssql = "SELECT DC.DSNID FROM DA_CONFIG DC INNER JOIN DA_JOB_NAMES DJN ON DC.DSNID = DJN.DSNID WHERE DJN.TASK_TYPE_ID=" + TaskTypeID + " AND DJN.DSNID = " + DAapp.Program.iDSNID;
            using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
            {
                dbConn.Open();
                iDSNID = Convert.ToInt32(dbConn.ExecuteScalar(ssql));
                dbConn.Close();
            }
            if (iDSNID > 0)
                ModuleExist = true;


        }
        public static void ModuleScripts()
        {
            switch (DAapp.Program.module.ToUpper())
            {
                case "MMSEA":

                    MProcess("MMSEA", DAapp.Program.spath, "MMSEASTAGINGSCRIPTS", "", "MMSEATASKMANAGERSCRIPTS", "MMSEARMDBSCRIPTS", "");
                    break;
                case "PPY":
                    MProcess("PPY", DAapp.Program.spath, "PPYSTAGINGSCRIPTS", "", "PPYTASKMANAGERSCRIPTS", "PPYRMDBSCRIPTS", "");
                    break;
                case "SICS":
                    MProcess("SICS", DAapp.Program.spath, "SICSSTAGINGSCRIPTS", "", "SICSTASKMANAGERSCRIPTS", "SICSRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    break;
                case "1099":

                    MProcess("1099", DAapp.Program.spath, "RM1099STAGINGSCRIPTS", "", "RM1099TASKMANAGERSCRIPTS", "RM1099RMDBSCRIPTS", "");
                    break;
                case "ACH":
                    MProcess("ACH", DAapp.Program.spath, "ACHSTAGINGSCRIPTS", "", "ACHTASKMANAGERSCRIPTS", "ACHRMDBSCRIPTS", "");
                    break;
                    //case "MBR":

                    //    MProcess("MBR", spath1, "MBRSTAGINGSCRIPTS", "MBRACCESSSTAGINGSCRIPTS", "MBRTASKMANAGERSCRIPTS", "MBRRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;
                    //case "DIS":

                    //    MProcess("DIS", spath1, "DISRMXSTAGINGSCRIPTS", "DISACCESSSTAGINGSCRIPTS", "DISTASKMANAGERSCRIPTS", "DISRMDBSCRIPTS", "");
                    //    break;
                    //case "DDS":

                    //    MProcess("DDS", spath1, "DDSRMXSTAGINGSCRIPTS", "", "DDSTASKMANAGERSCRIPTS", "DDSRMDBSCRIPTS", "");
                    //    break;
                    //case "ISO":

                    //    MProcess("ISO", spath1, "ISOSTAGINGSCRIPTS", "", "ISOTASKMANAGERSCRIPTS", "ISORMDBSCRIPTS", "");
                    //    break;
                    //case "PSO":

                    //    MProcess("PSO", spath1, "PSOSTAGINGSCRIPTS", "", "PSOTASKMANAGERSCRIPTS", "PSORMDBSCRIPTS", "");
                    //    break;
                    //case "PPY":

                    //    MProcess("PPY", spath1, "PPYSTAGINGSCRIPTS", "", "PPYTASKMANAGERSCRIPTS", "PPYRMDBSCRIPTS", "");
                    //    break;               
                    //case "EDI_FMB":

                    //    MProcess("EDI_FMB", spath1, "EDISTAGINGSCRIPTS", "", "EDITASKMANAGERSCRIPTS", "EDIRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;               
                    //case "MED_EDI":
                    //    MProcess("MED_EDI", spath1, "MEDEDISTAGINGSCRIPTS", "", "MEDEDITASKMANAGERSCRIPTS", "MEDEDIRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;               
                    //case "PUS":
                    //    MProcess("PUS", spath1, "", "", "PUSTASKMANAGERSCRIPTS", "PUSRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;
                    //case "HR_INTERFACE":
                    //    MProcess("HR_INTERFACE", spath1, "", "", "HRTASKMANAGERSCRIPTS", "HRRMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;
                    //case "ACH":
                    //    MProcess("ACH", spath1, "ACHSTAGINGSCRIPTS", "", "ACHTASKMANAGERSCRIPTS", "ACHRMDBSCRIPTS", "");
                    //    break;
                    //case "CLUE":

                    //    MProcess("CLUE", spath1, "CLUESTAGINGSCRIPTS", "", "CLUETASKMANAGERSCRIPTS", "CLUERMDBSCRIPTS", "OTHERRMDBSCRIPTS");
                    //    break;
            }

            executeScripts(DAapp.Program.module);
            DAConfigtableInsert();



        }

        public static void DAConfigtableInsert()
        {
            int docpathtypeID = 0;
            bool useS3 = true;
            docpathtypeID = docpathtype(DAapp.Program.sDsnName, DAapp.Program.sSecurityDBconn)[1];
            string bucketname = string.Empty;
            if (docpathtypeID == 2 || useS3 == true)
            {

                AmazonS3Config asc = new AmazonS3Config
                {
                    RegionEndpoint = RegionEndpoint.GetBySystemName(DAapp.Program.sRegion)
                };
                using (AmazonS3Client client1 = new AmazonS3Client(DAapp.Program.sAccessKey, DAapp.Program.sSecretKey, asc))
                {

                    bucketname = DAapp.Program.sBucketName;

                    S3Bucket objS3bk = new S3Bucket();
                    objS3bk.BucketName = bucketname;
                    ListBucketsResponse responsebucket = client1.ListBuckets();
                    if (responsebucket.Buckets.Contains(objS3bk))
                    {
                        PutBucketRequest request = new PutBucketRequest();
                        request.BucketName = bucketname;
                        client1.PutBucket(request);
                    }
                }
            }

            /// Insert into DA Config Table

            DAapp.Generic.OutputMessage = "Modifying values in DA CONFIG nd DA JOB name table for selected modules...";

            try
            {
                CheckModuleExist();
                if (!ModuleExist)
                {
                    string sql = string.Empty;
                    string sql2 = string.Empty;
                    if (!StagTablesforDSN)
                    {
                        sql = sql + "insert into DA_CONFIG (DSNID,AccessStagingDataSource,RMXStagingDataSource,StagingDataSource,RMXLoginName,RMXDataSourceName,FilePath,DocAttachNameDelimeter,S3BucketOnCloud) values('"
                                                    + DAapp.Program.iDSNID.ToString().Trim() + "','"
                                                    + DAapp.Program.sAccessStagingDBconn.Trim() + "','"
                                                    + DAapp.Program.sRMXStagingDBconn.Trim() + "','"
                                                    + DAapp.Program.sStagingDBconn.Trim() + "','";

                        sql2 = sql2 + DAapp.Program.sRMXLoginName.Trim() + "','"
                            + DAapp.Program.sDsnName.ToString().Trim() + "','"
                            + DAapp.Program.sFilePath.Trim() + "','"
                            + DAapp.Program.sDocAttachNameDelimeter.Trim().Replace("\0", "") + "','"
                            + DAapp.Program.sBucketName.Trim() + "')";
                        sql = sql + sql2;

                        using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
                        {
                            dbConn.Open();
                            dbConn.ExecuteNonQuery(sql);
                            dbConn.Close();
                        }

                        sql = string.Empty;
                    }
                  
                    sql = sql + "insert into DA_JOB_NAMES (DSNID,TASK_TYPE_ID,JOB_NAME,SUB_JOB_NAME,DocumentManagementEnabled,rmADocumentPoolPath,KeepJobFilesOnSuccess) values('"
                         + DAapp.Program.iDSNID.ToString().Trim() + "','"
                         + TaskTypeID.ToString().Trim() + "','"
                         + DAapp.Program.sjobname.Trim() + "','"
                         + DAapp.Program.sSUB_JOB_NAME.Trim() + "','"
                         + DAapp.Program.sDocumentManagementEnabled.Trim() + "','"
                         + DAapp.Program.srmADocumentPoolPath.Trim() + "','"
                         + DAapp.Program.sKeepJobFilesOnSuccess.Trim() + "')";

                    using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
                    {
                        dbConn.Open();
                        dbConn.ExecuteNonQuery(sql);
                        dbConn.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                DAapp.Generic.OutputMessage = ex.Message;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                ErrorEnc = true;
            }
        }

        public static int[] docpathtype(string dsnval, string security)
        {

            //string RMXSecurity = GetConnectionString("RMXSecurity", ClientId);
            DbConnection objConn = null;
            objConn = DbFactory.GetDbConnection(security);
            objConn.Open();
            int[] DSNDetails = new int[2];
            string SCDSN = "SELECT DSNID , DOC_PATH_TYPE  from DATA_SOURCE_TABLE where DSN='" + dsnval + "'";
            using (DbReader reader = DbFactory.ExecuteReader(security, SCDSN))
            {
                while (reader.Read())
                {
                    DSNDetails[0] = Convert.ToInt32(reader.GetValue("DSNID"));
                    DSNDetails[1] = Convert.ToChar(reader.GetValue("DOC_PATH_TYPE"));
                }
            }
            //int dsnid = Convert.ToInt32(objConn.ExecuteScalar(SCDSN));
            //string tcheck = string.Empty;
            //int doc_path_type;

            //tcheck = "select DOC_PATH_TYPE from data_source_table where DSNID =" + dsnid;

            //doc_path_type = Convert.ToChar(objConn.ExecuteScalar(tcheck));
            return DSNDetails;
        }

        public static void executeScripts(string modulename)
        {
            DAapp.Generic.OutputMessage = "Executing the module specific scripts.";
            string conn = string.Empty;

            try
            {
                if (DAapp.Program.DSNValidated)
                {
                    foreach (KeyValuePair<string, List<string>> Type in dictSelectedItems)
                    {
                        switch (Type.Key.ToUpper())
                        {
                            case "STAGING":

                                conn = DAapp.Program.sStagingDBconn;
                                RunScripts(conn, Type.Value, modulename);
                                break;
                            case "TASKMANAGER":
                                conn = DAapp.Program.TaskManagerConnc;
                                RunScripts(conn, Type.Value, modulename);
                                break;
                            case "RMXSTAGING":
                                conn = DAapp.Program.sRMXStagingDBconn;
                                RunScripts(conn, Type.Value, modulename);
                                break;
                            //case "ACCESSSTAGING":

                            //    conn =
                            //    RunScripts(conn, Type.Value, modulename);
                            //    break;
                            default:

                                RunScripts(DAapp.Program.sDsndb, Type.Value, modulename);
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                DAapp.Generic.OutputMessage = "Error Message: " + ex.Message;
                DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                throw ex;
            }
        }


        public static void RunScripts(string p_Connectionstring, List<string> p_ScrptLst, string modulename)
        {
            string createQuery = string.Empty;
            string set = string.Empty;
            string filename = string.Empty;

            StringBuilder sbScriptToRun = new StringBuilder();
            //Opens each file name present in list and executes it on the staging database.

            foreach (string fname in p_ScrptLst)
            {
                if (modulename == "MMSEA" && !DbFactory.IsOracleDatabase(p_Connectionstring))
                {
                    FileInfo file2 = new FileInfo(Path.Combine(DAapp.Program.sDAScriptsPath, modulename, "MMSEA Oracle Database Grants.txt"));
                    if (File.Exists(file2.FullName))
                    {
                        file2.Attributes = FileAttributes.Normal;
                        file2.Delete();
                    }
                }
                if (DbFactory.IsOracleDatabase(p_Connectionstring) && (Path.GetFileName(fname).ToUpper().Contains("SQL.") || Path.GetFileName(fname).ToUpper().Contains("TASKMANAGER.SQL")))
                {

                    if (File.Exists(fname))
                    {
                        File.SetAttributes(fname, FileAttributes.Normal);
                        File.Delete(fname);
                    }
                    continue;
                }
                else if (!DbFactory.IsOracleDatabase(p_Connectionstring) && Path.GetFileName(fname).ToUpper().Contains("ORACLE."))
                {
                    if (File.Exists(fname))
                    {
                        File.SetAttributes(fname, FileAttributes.Normal);
                        File.Delete(fname);
                    }
                    continue;

                }
                else if (DbFactory.IsOracleDatabase(p_Connectionstring) && Path.GetFileName(fname).ToUpper().Contains("_TASK") && Path.GetFileName(fname).ToUpper().Contains("ORACLE."))
                {
                    set = "proceed";

                }

                //   if (!File.Exists(Path.Combine(DAapp.Program.spath, modulename, fname)))
                if (!File.Exists(Path.Combine(fname)))
                {
                    DAapp.Generic.OutputMessage = "Could not find " + '"' + fname + '"' + " script";
                    DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                }
                if (File.Exists(Path.Combine(DAapp.Program.sDAScriptsPath, modulename, fname)))
                {
                    try
                    {
                        FileInfo file = new FileInfo(fname);
                        string script = file.OpenText().ReadToEnd();
                        script = script.Replace("\r\nGO\r\n", "");
                        script = Regex.Replace(script, "create procedure", "CREATE PROCEDURE");
                        script = Regex.Replace(script, "create function", "CREATE FUNCTION");
                        //executes the task manager script on tm database.
                        if (fname.Contains("_Task"))
                        {
                            if (set == "proceed" || !DbFactory.IsOracleDatabase(p_Connectionstring))
                            {
                                DbFactory.ExecuteNonQuery(DAapp.Program.TaskManagerConnc, Convert.ToString(script));
                                var t = fname.Split('\\');
                                var x = t[t.Length - 1];
                                DAapp.Generic.OutputMessage = " No error found in " + x + " script.Script executed successfully";
                                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                                //if (modulename == "MBR" || modulename == "PSO" || modulename == "PPY" || modulename == "1099" || modulename == "CLUE" || modulename == "DDS" || modulename == "DIS" || modulename == "MMSEA" || modulename == "SICS" || modulename == "ACH" || modulename == "EDI" || modulename == "MED_FMB_EDI")
                                //   {
                                string val = modulename;
                                int count = 0;
                                if (val == "PPY")
                                {
                                    val = "PositivePay";
                                }
                                else if (val == "1099")
                                {
                                    val = "1099-MISC";
                                }
                                else if (val == "MED_EDI" || val == "EDI_FMB")
                                {
                                    val = "EDI";
                                }
                                else if (val == "DDS\\SQL" || val == "DDS\\Oracle")
                                {
                                    val = val.Substring(0, 3);

                                }
                                string sql = "UPDATE TM_TASK_TYPE SET SYSTEM_MODULE_NAME='DAPageAPIRedirection' where NAME='" + val + "'";
                                DbFactory.ExecuteNonQuery(DAapp.Program.TaskManagerConnc, sql);
                            }
                        }
                        else
                        {
                            //replace two or more spaces with a single space.
                            //This will help in splitting by "CREATE PROCEDURE"
                            script = Regex.Replace(script, @"[ \t]{2,}", " ", RegexOptions.Compiled);

                            bool bFirst = true;
                            var allScripts = script.Split(new string[] { "CREATE PROCEDURE" }, StringSplitOptions.None);
                            if (allScripts.Length != 2)
                            {
                                allScripts = script.Split(new string[] { "CREATE FUNCTION" }, StringSplitOptions.None);
                            }
                            foreach (var scriptToRun in allScripts)
                            {
                                sbScriptToRun.Length = 0;
                                var t = fname.Split('\\');
                                var x = t[t.Length - 1];
                                DAapp.Generic.OutputMessage = "Executing script " + x;
                                if (!bFirst)
                                {
                                    if (script.Contains("CREATE PROCEDURE"))
                                    {
                                        sbScriptToRun.Append("CREATE PROCEDURE ").Append(scriptToRun);
                                    }
                                    if (script.Contains("CREATE FUNCTION"))
                                    {
                                        sbScriptToRun.Append("CREATE FUNCTION ").Append(scriptToRun);
                                    }
                                }
                                else
                                {
                                    sbScriptToRun.Append(scriptToRun);
                                    bFirst = false;
                                }

                                if (!string.IsNullOrWhiteSpace(Convert.ToString(sbScriptToRun)))
                                {
                                    if (DbFactory.IsOracleDatabase(p_Connectionstring))
                                    {
                                        sbScriptToRun.Replace('\r', ' ');
                                    }
                                    DbFactory.ExecuteNonQuery(p_Connectionstring, Convert.ToString(sbScriptToRun));


                                    DAapp.Generic.OutputMessage = " No error found in " + x + " script.Script executed successfully.";
                                    DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, ""));

                                }
                            }
                        }

                    }//try

                    catch (Exception e)
                    {
                        var t = fname.Split('\\');
                        var x = t[t.Length - 1];

                        DAapp.Generic.ProcessMessage = e.Message + "  This error is found in script  " + x;
                        //DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, ""));
                        DAapp.Generic.writeLog(DAapp.Generic.ProcessMessage, Path.Combine(DAapp.Program.processlogPath));
                        ErrorEnc = true;

                    }
                }

            }

        }
        public static void QueryTaskMgr(string query, ref object[] parms, string conn)
        {

            try
            {
                using (DbReader oDbReader = DbFactory.GetDbReader(conn, query))
                {
                    if (oDbReader.Read())
                    {
                        for (int i = 0; i < parms.Length; i++)
                        {
                            parms[i] = oDbReader.GetValue(i);
                        }
                    }
                }

            }
            catch (System.Exception e)
            {
                DAapp.Generic.OutputMessage = "Query (" + query + ") failed. (" + e.Message + ") Int";
                DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                Environment.Exit(0);
            }


        }
        public static string BuildConnectionString(string strDbConnStr, string strUID, string strPW)
        {
            const string DELIMITER = ";";

            var objConnStr = new StringBuilder();

            if (string.IsNullOrEmpty(strDbConnStr))
            {
                objConnStr.AppendFormat("DSN={0}{1}{0}{2}{0}", DELIMITER, strUID, strPW);
            }
            else
            {
                objConnStr.Append(strDbConnStr);

                if (strDbConnStr.LastIndexOf(";") != strDbConnStr.Length - 1)
                {
                    objConnStr.Append(DELIMITER);
                }

                objConnStr.AppendFormat("UID={0}{1}PWD={2}{1}", strUID, DELIMITER, strPW);
            }

            DAapp.Program.sRMDBUser = strUID;
            DAapp.Program.sRMDBPwd = strPW;

            return objConnStr.ToString();
        }
        public static bool checkconnfordsn(string dsntocheck)
        {
            bool blnValidated = false;
            string strSQL = "SELECT CONNECTION_STRING,RM_PASSWORD , RM_USERID FROM DATA_SOURCE_TABLE WHERE DSN='" + dsntocheck + "'";
            DbConnection objConn1 = null;
            objConn1 = DbFactory.GetDbConnection(DAapp.Program.sSecurityDBconn);
            objConn1.Open();

            object[] oArr1 = new object[] { DAapp.Program.sDsndb, dsnpwd, userid };

            QueryTaskMgr(strSQL, ref oArr1, DAapp.Program.sSecurityDBconn);
            if (oArr1 != null)
            {
                DAapp.Program.sDsndb = oArr1[0].ToString();
               // DAapp.Generic.OutputMessage = "No DSN found corresponding to  " + dsntocheck;
                dsnpwd = oArr1[1].ToString();
                userid = oArr1[2].ToString();

                // RMDB Details starts
                string sDSNName = DAapp.Program.sDsndb.Substring(DAapp.Program.sDsndb.LastIndexOf("Database=")).Substring(DAapp.Program.sDsndb.Substring(DAapp.Program.sDsndb.LastIndexOf("Database=")).LastIndexOf("=") + 1);
                DAapp.Program.sRiskMasterDB = sDSNName.Substring(0, sDSNName.IndexOf(";"));
                string servername = (DAapp.Program.sDsndb.Split(';'))[1];
                DAapp.Program.sRMDBServer = servername.Substring(7);
                // RMDB Details ends

                // Security DB Details starts               
                DAapp.Program.sSecurityDB = (DAapp.Program.sSecurityDBconn.Split(';'))[2].Substring((DAapp.Program.sSecurityDBconn.Split(';'))[2].IndexOf("=") + 1);
                string secservername = (DAapp.Program.sSecurityDBconn.Split(';'))[1];
                DAapp.Program.sSecurityDBServer = secservername.Substring(7);
                // Security DB Details ends

            }
            objConn1.Close();

            objConn1 = DbFactory.GetDbConnection(DAapp.Program.sDsndb);
            if (!string.IsNullOrEmpty(DAapp.Program.sqlconn))
            {
                if (objConn1.DatabaseType.ToString() == "DBMS_IS_ORACLE")
                {
                    DAapp.Generic.OutputMessage = "Selected is not SQL DSN: " + dsntocheck;
                    DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                    return false;
                }
            }
            else
            {
                if (objConn1.DatabaseType.ToString() != "DBMS_IS_ORACLE")
                {
                    DAapp.Generic.OutputMessage = "Selected is not ORACLE DSN: " + dsntocheck;
                    DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                    return false;
                }
            }
            try
            {
                DAapp.Program.sDsndb = BuildConnectionString(DAapp.Program.sDsndb, RMCryptography.DecryptString(userid), RMCryptography.DecryptString(dsnpwd));
                CheckForOracleString(ref DAapp.Program.sDsndb);
                objConn1 = DbFactory.GetDbConnection(DAapp.Program.sDsndb);

                objConn1.Open();
                DAapp.Generic.OutputMessage = " Selected DSN db verified.";
                //DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath, "DAappLogs"));
                blnValidated = true;


            }
            catch (Exception e)
            {

                if (e.Message.Contains("A network-related"))
                    DAapp.Generic.OutputMessage = "Could not open a connection to database for DSN: " + dsntocheck;

                else if (e.Message.Contains("locked"))
                    DAapp.Generic.OutputMessage = "Account is currently locked out for DSN: " + dsntocheck;
                else
                    DAapp.Generic.OutputMessage = e.Message.ToString() + " for DSN: " + dsntocheck;

                DAapp.Generic.OutputMessage = "Error Message: " + e.Message;
                DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath));
                throw e;
            }
            return blnValidated;
        }

        public static void CheckForOracleString(ref string g_sConnectString)
        {
            bool bOracleVer = true;
            string sOracleDriver = String.Empty;
            Regex regex = new Regex(@"^(?<start>.*){(?<driver>Oracle.*)}(?<end>.*)$", RegexOptions.IgnoreCase);
            Match match = regex.Match(g_sConnectString);

            if (match.Success)
            {
                string[] arrDrivers = DAapp.Generic.GetODBCDrivers();

                foreach (string driver in arrDrivers)
                {
                    if (driver.Contains("Oracle"))
                    {

                        bOracleVer = true;// CheckOracleClientVersion();

                        if (!bOracleVer)
                        {
                            g_sConnectString = String.Empty;
                        }
                        else
                        {

                            sOracleDriver = match.Groups["driver"].Value;
                        }

                        break;
                    }
                }

                DAapp.Program.sDsndb = String.Format("{0}{{{1}}}{2}", match.Groups["start"].Value, sOracleDriver, match.Groups["end"].Value);
            }
        }

        public static void StagDetailsForDSNID()
        {
            int iDSNID = 0;
            string ssql = string.Empty;
            DataSet objResult = new DataSet("objResult");
            ssql = "SELECT * FROM DA_CONFIG DC WHERE  DC.DSNID = " + DAapp.Program.iDSNID;
            using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
            {
                dbConn.Open();
                iDSNID = Convert.ToInt32(dbConn.ExecuteScalar(ssql));             
                dbConn.Close();
            }
            if (iDSNID > 0)
            {
                StagTablesforDSN = true;
                ssql = string.Empty;
                ssql = "SELECT * FROM DA_CONFIG DC WHERE  DC.DSNID = " + DAapp.Program.iDSNID;
                using (DbConnection dbConn = DbFactory.GetDbConnection(DAapp.Program.TaskManagerConnc))
                {
                    dbConn.Open();
                    objResult = DbFactory.GetDataSet(DAapp.Program.TaskManagerConnc, ssql,0);
                    DAapp.Program.sRMXStagingDBconn = objResult.Tables[0].Rows[0]["RMXStagingDataSource"].ToString();
                    DAapp.Program.sRMXStagingDB= (DAapp.Program.sRMXStagingDBconn.Split(';'))[2].Substring((DAapp.Program.sRMXStagingDBconn.Split(';'))[2].IndexOf("=") + 1);
                    DAapp.Generic.ProcessMessage = "RMXStagingDB" + DAapp.Program.sRMXStagingDB + ".";
                    DAapp.Program.sStagingDBconn = objResult.Tables[0].Rows[0]["StagingDataSource"].ToString();
                    DAapp.Program.sStagingDB = (DAapp.Program.sStagingDBconn.Split(';'))[2].Substring((DAapp.Program.sStagingDBconn.Split(';'))[2].IndexOf("=") + 1);
                    DAapp.Generic.ProcessMessage = "tagingDB" + DAapp.Program.sStagingDB + ".";
                    DAapp.Program.sAccessStagingDBconn = objResult.Tables[0].Rows[0]["AccessStagingDataSource"].ToString();
                    DAapp.Program.sAccessStagingDB = (DAapp.Program.sAccessStagingDBconn.Split(';'))[2].Substring((DAapp.Program.sAccessStagingDBconn.Split(';'))[2].IndexOf("=") + 1);
                    DAapp.Generic.ProcessMessage = "AccessStagingDB" + DAapp.Program.sAccessStagingDB + ".";
                    dbConn.Close();

                }               

            }
        }


        public static void CreateDB(string modulename, string type )
        {
            // your connection string
            //  string connectionString = "Server=cscindae749949;uid=sa;pwd=rmserver@123;database=master";
            DAapp.Generic.ProcessMessage = "Started for Module" + modulename + ".";
            string connectionString = string.Empty;
            var query = string.Empty;
            DBList = new List<string>();
            int iCount = 0;

            string sServerName = DAapp.Program.sRMDBServer;
            string sServerPwd = DAapp.Program.sRMDBPwd;
            string sServerUsername = DAapp.Program.sRMDBUser;

            DAapp.Program.sRepoServername = sServerName;
            DAapp.Program.sRepoUsername = sServerUsername;
            DAapp.Program.sRepoPassword = sServerPwd;

            DAapp.Program.sStagingDBServer = sServerName;
            DAapp.Program.sStagingDBUser = sServerUsername;
            DAapp.Program.sStagingDBPwd = sServerPwd;

            DAapp.Program.sRMXStagingDBServer = sServerName;
            DAapp.Program.sRMXStagingDBUser = sServerUsername;
            DAapp.Program.sRMXStagingDBPwd = sServerPwd;



            if (type == "Drop")
            {
                foreach (var item in DBList)
                {

                    query = "DROP DATABASE " + item;
                    DAapp.Generic.ProcessMessage = "Database drop" + item + ".";
                }
            }
            else
            {
                switch (modulename.ToUpper())
                {
                    case "MMSEA":
                        DAapp.Program.sRepoDatabaseName = "Repo_" + "MMSEA_" + DAapp.Program.iDSNID;
                        DBList.Add(DAapp.Program.sRepoDatabaseName);
                        break;

                    case "PPY":
                        DAapp.Program.sRepoDatabaseName = "Repo_" + "PPY_" + DAapp.Program.iDSNID;
                        DBList.Add(DAapp.Program.sRepoDatabaseName);
                        break;
                    case "1099":
                        DAapp.Program.sRepoDatabaseName = "Repo_" + "RM1099_" + DAapp.Program.iDSNID;
                        DBList.Add(DAapp.Program.sRepoDatabaseName);
                        break;

                    case "SICS":
                        DAapp.Program.sRepoDatabaseName = "Repo_" + "SICS_" + DAapp.Program.iDSNID;
                        DBList.Add(DAapp.Program.sRepoDatabaseName);
                        break;
                    case "ACH":
                        DAapp.Program.sRepoDatabaseName = "Repo_" + "ACH_" + DAapp.Program.iDSNID;
                        DBList.Add(DAapp.Program.sRepoDatabaseName);
                        break;
                }

                if (!StagTablesforDSN)
                {
                    DAapp.Program.sStagingDB = "DA_Stag_" + DAapp.Program.iDSNID;
                    DBList.Add(DAapp.Program.sStagingDB);
                    DAapp.Program.sRMXStagingDB = "DA_RMXStag_" + DAapp.Program.iDSNID;
                    DBList.Add(DAapp.Program.sRMXStagingDB);
                    DAapp.Program.sAccessStagingDB = "DA_AccessStag_" + DAapp.Program.iDSNID;
                    DBList.Add(DAapp.Program.sAccessStagingDB);
                    iCount = DBList.Count;

                }
                foreach (var item in DBList)
                {

                    connectionString = "Driver={SQL Server};Server=" + sServerName + ";Database=master;UID=" + sServerUsername + ";pwd=" + sServerPwd + ";";
                    query = "CREATE DATABASE " + item;

                    try
                    {
                        using (DbConnection dbConn = DbFactory.GetDbConnection(connectionString))
                        {
                            dbConn.Open();
                            dbConn.ExecuteScalar(query);
                            dbConn.Close();
                            DAapp.Generic.ProcessMessage = "Database Created" + item + ".";
                        }
                    }
                    catch (Exception ex)
                    {
                        DAapp.Generic.OutputMessage = "Error Message: " + ex.Message;
                        DAapp.Generic.writeLog(DAapp.Generic.ErrorMessage, Path.Combine(DAapp.Program.logfilepath));
                        ErrorEnc = true;
                        throw ex;
                    }
                    if (!StagTablesforDSN)
                    {
                        DAapp.Program.sRMXStagingDBconn = "Driver={SQL Server};Server=" + sServerName + ";Database=" + DAapp.Program.sRMXStagingDB + ";UID=" + sServerUsername + ";pwd=" + sServerPwd + ";";
                        DAapp.Program.sStagingDBconn = "Driver={SQL Server};Server=" + sServerName + ";Database=" + DAapp.Program.sStagingDB + ";UID=" + sServerUsername + ";pwd=" + sServerPwd + ";";
                        DAapp.Program.sAccessStagingDBconn = "Driver={SQL Server};Server=" + sServerName + ";Database=" + DAapp.Program.sAccessStagingDB + ";UID=" + sServerUsername + ";pwd=" + sServerPwd + ";";


                    }

                }


            }
        }
        public static void MProcess(string ModName, string p_BasePath, string StagScript, string AccessScript, string TaskmgrScript, string RmdbScript, string DAapppScript)
        {
            string STAGINGSCRIPTS = string.Empty;
            string ACCESSSTAGINGSCRIPTS = string.Empty;
            string TASKMANAGERSCRIPTS = string.Empty;
            string RMDBSCRIPTS = string.Empty;
            string DAapppSCRIPTS = string.Empty;

            string path = string.Empty;
            List<string> lstScrptNam = new List<string>();

            if (Directory.Exists(DAapp.Program.sExePath))
            {
                dictSelectedItems = new Dictionary<string, List<string>>();
                if (StagScript != "")
                {
                    lstScrptNam = new List<string>();
                    STAGINGSCRIPTS = ConfigurationManager.AppSettings[StagScript];
                    foreach (string sName in STAGINGSCRIPTS.Split('|'))
                    {
                        lstScrptNam.Add(Path.Combine(DAapp.Program.sDAScriptsPath, ModName, sName));


                    }
                    if (DAapp.Program.module == "DDS" || DAapp.Program.module == "DIS" || DAapp.Program.module == "SICS")
                    {
                        dictSelectedItems.Add("RMXStaging", lstScrptNam);
                    }
                    else
                    {
                        dictSelectedItems.Add("Staging", lstScrptNam);
                    }

                }

                if (AccessScript != "")
                {
                    lstScrptNam = new List<string>();
                    ACCESSSTAGINGSCRIPTS = ConfigurationManager.AppSettings[AccessScript];

                    foreach (string sName in ACCESSSTAGINGSCRIPTS.Split('|'))
                    {

                        lstScrptNam.Add(Path.Combine(DAapp.Program.sDAScriptsPath, ModName, sName));

                    }
                    dictSelectedItems.Add("AccessStaging", lstScrptNam);

                }


                if (TaskmgrScript != "")
                {
                    lstScrptNam = new List<string>();
                    TASKMANAGERSCRIPTS = ConfigurationManager.AppSettings[TaskmgrScript];
                    foreach (string sName in TASKMANAGERSCRIPTS.Split('|'))
                    {
                        lstScrptNam.Add(Path.Combine(DAapp.Program.sDAScriptsPath, ModName, sName));
                    }
                    dictSelectedItems.Add("TaskManager", lstScrptNam);
                }

                if (RmdbScript != "")
                {
                    lstScrptNam = new List<string>();
                    RMDBSCRIPTS = ConfigurationManager.AppSettings[RmdbScript];
                    foreach (string sName in RMDBSCRIPTS.Split('|'))
                    {
                        lstScrptNam.Add(Path.Combine(DAapp.Program.sDAScriptsPath, ModName, sName));

                    }
                    dictSelectedItems.Add("RMDB", lstScrptNam);
                }
                else if (DAapppScript != "")
                {
                    lstScrptNam = new List<string>();
                    DAapppSCRIPTS = ConfigurationManager.AppSettings[DAapppScript];
                    foreach (string sName in DAapppSCRIPTS.Split('|'))
                    {
                        lstScrptNam.Add(Path.Combine(DAapp.Program.sDAScriptsPath, ModName, sName));
                    }
                    dictSelectedItems.Add("OTHERRMDBSCRIPTS", lstScrptNam);
                }
            }

        }

        public static void GetConnectionStringInfo()
        {
            bool isnecryp = false;
            string isMT = string.Empty;
            try
            {
                FileInfo filcon = new FileInfo(DAapp.Program.sBinpath + "connectionStrings.config");
                string destDirapipath = DAapp.Program.sBinpath;
                if (Directory.Exists(destDirapipath))
                {
                    FileInfo destFileapicopy = new FileInfo(Path.Combine(destDirapipath, filcon.Name));
                    if (destFileapicopy.Exists)
                    {
                        // now you can safely overwrite it
                        //filcon.CopyTo(destFileapicopy.FullName, true);
                        File.Delete(DAapp.Program.sBinpath + "connectionStrings.config");
                    }
                    File.Copy(DAapp.Program.sWCFPath + "connectionStrings.config", DAapp.Program.sBinpath + "connectionStrings.config");
                }

                //reading the connection strings.config file


                //XmlDocument doc = new XmlDocument();
                //doc.Load(Path.Combine(DAapp.Program.sDAScriptsPath + "connectionStrings.config"));
                XmlTextReader reader = new XmlTextReader("connectionStrings.config");
                XmlDocument doc = new XmlDocument();
                doc.Load(reader);
                reader.Close();

                reader.Dispose();
                XmlElement root = doc.DocumentElement;
                XmlNodeList xnList = doc.SelectNodes("/connectionStrings");
                XmlNode xmlEncryptedNode = xnList[0];
                DAapp.Program.xmlval = xmlEncryptedNode.InnerXml.ToString();
                DAapp.Program.sChildElement = xmlEncryptedNode.FirstChild.Name;
                if (DAapp.Program.sChildElement.ToLower() == "encrypteddata")
                {
                    isnecryp = true;
                    XmlNode xmlEncryptedData = xmlEncryptedNode.SelectSingleNode("EncryptedData");
                    DpapiProtectedConfigurationProvider objDpapi = new DpapiProtectedConfigurationProvider();
                    DAapp.Program.xmlDecryptedData = objDpapi.Decrypt(xmlEncryptedData);
                    foreach (XmlNode chldNode in DAapp.Program.xmlDecryptedData.ChildNodes)
                    {
                        if (!(chldNode.Attributes == null))
                        {
                            if (chldNode.Attributes["name"].Value == "rmATenantSecurity")
                            {
                                isMT = "Yes";
                                DAapp.Program.Setrmexpress = "Yes";
                                DAapp.Program.conStr = chldNode.Attributes["connectionString"].Value;


                            }
                            if (chldNode.Attributes["name"].Value == "TaskManagerDataSource")
                            {


                                DAapp.Program.TaskManagerConnc = chldNode.Attributes["connectionString"].Value;


                            }
                            if (chldNode.Attributes["name"].Value == "RMXSecurity")
                            {


                                DAapp.Program.sSecurityDBconn = chldNode.Attributes["connectionString"].Value;
                                System.Data.Common.DbConnectionStringBuilder builder = new System.Data.Common.DbConnectionStringBuilder();

                                if (DAapp.Program.sSecurityDBconn.Contains("Database"))
                                {
                                    builder.ConnectionString = DAapp.Program.sSecurityDBconn;
                                    DAapp.Program.sqlconn = builder["Driver"] as string;

                                }
                                else if (DAapp.Program.sSecurityDBconn.Contains("DBQ"))
                                {
                                    builder.ConnectionString = DAapp.Program.sSecurityDBconn;
                                    DAapp.Program.orclconn = builder["Driver"] as string;

                                }
                            }
                            if (chldNode.Attributes["name"].Value == "StagingDataSource")
                            {


                                DAapp.Program.stagingdb = chldNode.Attributes["connectionString"].Value;

                            }
                            if (chldNode.Attributes["name"].Value == "AccessStagingDataSource")
                            {


                                DAapp.Program.accessdb = chldNode.Attributes["connectionString"].Value;

                            }
                            if (chldNode.Attributes["name"].Value == "RMXStagingDataSource")
                            {
                                DAapp.Program.rmxstagingdb = chldNode.Attributes["connectionString"].Value;

                            }
                        }
                    }
                }

                else if (DAapp.Program.xmlval.Contains("rmATenantSecurity"))
                {
                    isMT = "Yes";
                    reader = new XmlTextReader("connectionStrings.config");
                    while (reader.Read())
                    {
                        if (reader.GetAttribute("name") == "rmATenantSecurity")
                            DAapp.Program.conStr = reader.GetAttribute("connectionString");

                    }
                    reader.Close();
                    reader.Dispose();

                }

                else if (DAapp.Program.xmlval.Contains("TaskManagerDataSource"))
                {

                    reader = new XmlTextReader("connectionStrings.config");
                    while (reader.Read())
                    {
                        if (reader.GetAttribute("name") == "TaskManagerDataSource")
                            DAapp.Program.TaskManagerConnc = reader.GetAttribute("connectionString");
                        if (reader.GetAttribute("name") == "RMXSecurity")
                        {
                            DAapp.Program.sSecurityDBconn = reader.GetAttribute("connectionString");
                            System.Data.Common.DbConnectionStringBuilder builder = new System.Data.Common.DbConnectionStringBuilder();

                            if (DAapp.Program.sSecurityDBconn.Contains("Database"))
                            {
                                builder.ConnectionString = DAapp.Program.sSecurityDBconn;
                                DAapp.Program.sqlconn = builder["Driver"] as string;

                            }
                            else if (DAapp.Program.sSecurityDBconn.Contains("DBQ"))
                            {
                                builder.ConnectionString = DAapp.Program.sSecurityDBconn;
                                DAapp.Program.orclconn = builder["Driver"] as string;

                            }
                        }
                        if (reader.GetAttribute("name") == "StagingDataSource")
                            DAapp.Program.stagingdb = reader.GetAttribute("connectionString");
                        if (reader.GetAttribute("name") == "RMXStagingDataSource")
                            DAapp.Program.rmxstagingdb = reader.GetAttribute("connectionString");
                        if (reader.GetAttribute("name") == "AccessStagingDataSource")
                            DAapp.Program.accessdb = reader.GetAttribute("connectionString");

                    }
                    reader.Close();

                    reader.Dispose();

                }
                if (isnecryp)
                {
                    DAapp.Generic.OutputMessage = " Connection Strings file read and is present in encrypted format.";
                }
                else
                {
                    DAapp.Generic.OutputMessage = " Connection Strings file read and is present in non encrypted format";
                }
                if (isMT == "Yes")
                {
                    DAapp.Generic.OutputMessage = " rmA environment is Multitenant.";
                }
                else
                {
                    DAapp.Generic.OutputMessage = " rmA environment is non Multitenant.";
                }

            }
            catch (Exception ex)
            {
                DAapp.Generic.OutputMessage = "Error Message: " + ex.Message;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));

            }

        }

        static public void WriteDAProcessLog(string message)
        {
            StreamWriter outFile;
            if (message.Length > 0)
            {
                try
                {
                    string path = "\\DASetupProcessLog" + DateTime.Now.ToString("MMddyyyyHHmmss") + ".txt";
                    outFile = File.CreateText(Application.StartupPath + path);
                    outFile.Write(message);
                    outFile.Close();
                }
                catch (System.Exception e)
                {
                    //Console.WriteLine("Error encountered while writing GitHubInstallerLog file. ( " + e.Message + " )");
                }
            }
        }

    }
}
