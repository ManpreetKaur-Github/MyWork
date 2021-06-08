using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows.Forms;
using System.Data;
using Microsoft.VisualBasic.FileIO;
using System.Dynamic;
using System.Diagnostics;

namespace DAGitHUb_Interface
{       // mkaur24 12/14/2017  RMA-44257 Start
    public partial class GitHUbBase
    {
        static protected string mExcludeFiles;
        static protected string[] mDATemplates;
        static protected string[] ModuleList;
        static protected string[] fExcludeFiles;
        static protected string m_InfoMsg = string.Empty;
        static protected string m_WarnMsg = string.Empty;
        static protected string mStartupPath = string.Empty;
        static protected string sBasepath = string.Empty;
        static protected string sURL = string.Empty;
        static protected string sTokenKey = string.Empty;
        static protected string sDAinstaller = string.Empty;
        static protected string sRepoName = string.Empty;
        static protected string sQALocation = string.Empty;
        static protected string sFolderName = string.Empty;
        static protected List<string> ModuleNameList12;
        static protected List<string> ExteList2;
        static bool Err = false;



        public static string StartupPath
        {
            get { return mStartupPath; }
        }
        public static bool Error
        {
            get { return Err; }
        }
        public static string FileNameCom
        {
            get { return sFileNameCom; }

        }

        public static string CommitNo
        {
            get { return sCommitNo; }
        }
        public static string QALocation
        {

            get { return sQALocation; }
        }

        static public string Message
        {
            get { return m_WarnMsg; }
            set { m_WarnMsg += value + "\r\n"; }
        }

        static public string RepoName
        {
            get { return sRepoName; }

        }

        static public string FolderName
        {
            get { return sFolderName; }

        }

        static public string InfoMessage
        {
            get { return m_InfoMsg; }
            set { m_InfoMsg += value + "\r\n"; }
        }

        static public List<string> ExtList
        {
            get { return ExteList2; }

        }
        static public string[] DAModules
        {
            get { return mDATemplates; }
        }

        static public string Basepath
        {
            get { return sBasepath; }
        }

        static public string sToken
        {
            get { return sTokenKey; }
        }

        static public string DAinstaller
        {
            get { return sDAinstaller; }
        }

        static public List<string> ModuleNameList
        {
            get { return ModuleNameList12; }
        }

        static public string URL
        {
            get { return sURL; }
        }

        static public string[] ExcludeFiles
        {
            get { return fExcludeFiles; }
        }

        static public void ReadConfig()
        {
            Message = "Hello! Starting with GitHub File Download at : " + DateTime.Now + ".";
            Console.WriteLine("Hello! Starting with GitHub File Download at : " + DateTime.Now + ".");

            char[] delimiters = { '|', ',', '\t' };
            bool flag = false;

            sBasepath = GetConfigKey("LocalBasepath");   //Basepath           
            Message = AppConfigError(sBasepath, "LocalBasepath");

            sURL = GetConfigKey("GitHubURL");  // URL
            Message = AppConfigError(sURL, "GitHubURL");

            sTokenKey = GetConfigKey("GitHubToken"); // sToken
            Message = AppConfigError(sTokenKey, "GitHubToken");

            sDAinstaller = GetConfigKey("DAinstallerConfig"); // DAinstaller
            Message = AppConfigError(sDAinstaller, "DAinstallerConfig");

            sFolderName = GetConfigKey("GitHubDIFolder"); // GitHubDIFolder 
            Message = AppConfigError(sFolderName, "GitHubDIFolder");

            sRepoName = GetConfigKey("GitHubRepoName");  //  RepoName
            Message = AppConfigError(sRepoName, "GitHubRepoName");

            sQALocation = GetConfigKey("QALocation");  //  QALocation
            Message = AppConfigError(sRepoName, "QALocation");

            List<string> ModuleNameList1 = new List<string>();
            ModuleNameList1.Add("MBR");
            ModuleNameList1.Add("MMSEA Medicare");
            ModuleNameList1.Add("ISO");
            ModuleNameList1.Add("1099 MISC Export");
            ModuleNameList1.Add("Positive Pay");
            ModuleNameList1.Add("PSO");
            ModuleNameList1.Add("DIS");
            ModuleNameList1.Add("DDS");
            ModuleNameList1.Add("SICS");
            ModuleNameList1.Add("EDI");
            ModuleNameList1.Add("MEDICAL_EDI");
            ModuleNameList1.Add("ACH");
            ModuleNameList1.Add("HR_Interface");
            ModuleNameList1.Add("PUS");
            ModuleNameList12 = ModuleNameList1.ToList<string>();

            DataTable ConfigData = new DataTable();
            ConfigData = GetDataTabletFromFile(sDAinstaller, 4);

            List<string> ModuleList = new List<string>();
            String ExcludeList = string.Empty;
            int i = 0;
            foreach (DataRow dr in ConfigData.Rows)
            {
                if (dr[0].ToString() == "DA_EXE" || dr[0].ToString() == "DDS" || dr[0].ToString() == "Image" || dr[0].ToString() == "License_Key" || dr[0].ToString() == "XMLToolkit" || dr[0].ToString() == "C#_Exe")
                {
                    flag = true;
                }
                else
                {
                    flag = false;
                }

                if (!flag)
                {
                    if (dr[2].ToString() == "ExcludeFiles")
                    {
                        ExcludeList = dr[3].ToString();
                    }
                    else
                    {
                        ModuleList.Add(dr[2].ToString() + "/" + dr[3].ToString());
                    }
                }

                i++;
                flag = false;
            }

            mDATemplates = ModuleList.ToArray();
            fExcludeFiles = ExcludeList.Split(delimiters);

            List<string> ExteList = new List<string>();
            ExteList.Add(".txt");
            ExteList.Add(".sql");
            ExteList.Add(".wse");
            ExteList.Add(".xls");
            ExteList.Add(".atl");
            ExteList.Add(".accdb");
            ExteList.Add(".pdf");
            ExteList.Add(".doc");
            ExteList.Add(".bmp");
            ExteList.Add(".exe");
            ExteList.Add(".config");
            ExteList.Add(".exe.config");
            ExteList.Add(".dll");
            ExteList2 = ExteList.ToList<string>();
        }

        static public string GetConfigKey(string keyName)
        {
            string DAMod = System.Configuration.ConfigurationManager.AppSettings[keyName];
            return (DAMod == null ? string.Empty : DAMod);
        }

        static public string AppConfigError(string KeyValue, string keyName)
        {
            string ErrorMessage = string.Empty;
            if (string.IsNullOrEmpty(KeyValue))
            {
                ErrorMessage = "Please provide the key : " + keyName + " in GitHubInstaller.exe.config .";
                Console.WriteLine("Please provide the key : " + keyName + " in GitHubInstaller.exe.config .");
            }

            return (ErrorMessage == null ? string.Empty : ErrorMessage);
        }

        static public void WriteWarningFile()
        {
            StreamWriter outFile;
            if (Message.Length > 0)
            {
                try
                {
                    string path = "\\GitHubInstsallerLog" + DateTime.Now.ToString("MMddyyyyHHmmss") + ".txt";
                    outFile = File.CreateText(Application.StartupPath + path);
                    outFile.Write(Message);
                    outFile.Close();
                }
                catch (System.Exception e)
                {
                    Console.WriteLine("Error encountered while writing GitHubInstallerLog file. ( " + e.Message + " )");
                }
            }
        }

        static public void CopyFile(string ConfigKey)
        {
            try
            {
                string TemplatePath = ConfigKey.Replace("/", "\\");
                string OutputPath = ConfigKey;
                string SourceFolder = string.Empty;
                string fileNameDDS = string.Empty;
                string fileNameSupp = "generic.sql";
                string[] fileName = { "DI Base_SQL.sql", "DI Base_Oracle.sql" };
                int i = 0;

                string sourcePath = (Basepath + @"RISKMASTER_DataExchange\" + FolderName + @"\Common\DA_Scripts");
                string targetPath = (Basepath + @"RISKMASTER_DataExchange\" + FolderName + @"\" + TemplatePath);


                if (TemplatePath.Contains("DDS\\Template\\Oracle"))
                {
                    fileNameDDS = "DI Base_Oracle.sql";
                }
                else if (TemplatePath.Contains("DDS\\Template\\SQL"))
                {
                    fileNameDDS = "DI Base_SQL.sql";
                }
                else if (TemplatePath.Contains("DDS\\Template"))
                {
                    //DO NOTHING ;
                }
                else
                {
                    foreach (string item in fileName)
                    {
                        string sourceFile = System.IO.Path.Combine(sourcePath, fileName[i]);
                        string destFile = System.IO.Path.Combine(targetPath, fileName[i]);
                        try
                        {
                            System.IO.File.Copy(sourceFile, destFile, true);
                            Message = " File : " + fileName[i] + " Copied to folder " + OutputPath + ".";
                            i++;
                        }
                        catch (Exception e)
                        {
                            Err = true;
                            Message = " Error encountered while coping of files the the folder " + destFile + "from folder " + sourceFile + ".";
                            Console.WriteLine("Error encountered while coping of files in the folder " + ConfigKey + " ( " + e.Message + " )");

                        }

                    }

                }

                if (!string.IsNullOrEmpty(fileNameDDS))
                {
                    string sourceFileDDS = System.IO.Path.Combine(sourcePath, fileNameDDS);
                    string destFileDDS = System.IO.Path.Combine(targetPath, fileNameDDS);
                    System.IO.File.Copy(sourceFileDDS, destFileDDS, true);
                    Message = " File : " + fileNameDDS + " Copied to folder " + OutputPath + ".";
                }

                if (TemplatePath.Contains("EDI\\Template"))
                {
                    SourceFolder = @"\EDI\EDI SuppFields DbUpgrade";
                }
                else if (TemplatePath.Contains("MBR\\Template"))
                {
                    SourceFolder = @"\MBR\MBR SuppFields DBUpgrade";
                }
                else if (TemplatePath.Contains("MEDICAL_EDI\\Template"))
                {
                    SourceFolder = @"\MEDICAL_EDI\MEDI SuppFields DbUpgrade";
                }

                if (!string.IsNullOrEmpty(SourceFolder))
                {
                    string sourcePathE = (Basepath + @"RISKMASTER_DataExchange\" + FolderName + SourceFolder);
                    string targetPathE = (Basepath + @"RISKMASTER_DataExchange\" + FolderName + @"\" + TemplatePath);
                    string sourceFileSupp = System.IO.Path.Combine(sourcePathE, fileNameSupp);
                    string destFileSupp = System.IO.Path.Combine(targetPathE, fileNameSupp);
                    try
                    {
                        System.IO.File.Copy(sourceFileSupp, destFileSupp, true);
                        Message = " File : " + fileNameSupp + " Copied to folder " + OutputPath + " .";
                    }
                    catch (Exception e)
                    {
                        Err = true;
                        Message = " Error encountered while coping of files the the folder " + sourceFileSupp + "from folder " + destFileSupp + ".";
                        Console.WriteLine("Error encountered while coping of files in the folder " + ConfigKey + " ( " + e.Message + " )");

                    }

                }
                if (!System.IO.Directory.Exists(targetPath))
                {
                    Message = "The provided path does not exists. Path : " + targetPath + ".";
                    Console.WriteLine("The provided path does not exists. Path :" + targetPath + ".");
                }
                //Console.WriteLine("Press any key to exit.");
                //Console.ReadKey();
            }
            catch (Exception e)
            {
                Err = true;
                Message = " Error encountered while coping of files in the folder " + ConfigKey + DateTime.Now + ".";
                Console.WriteLine("Error encountered while coping of files in the folder " + ConfigKey + " ( " + e.Message + " )");

            }

        }

        static public void ProcessInstaller(string InstallerName)
        {
            try
            {
                if (!Err)
                {
                    Message = "Started with " + InstallerName + ".wse" + " Compilation at " + DateTime.Now + ".";
                    Console.WriteLine("Started with " + InstallerName + ".wse" + " Compilation at " + DateTime.Now + ".");

                    string WisePath = Basepath + "RISKMASTER_DataExchange\\Data Integrator\\DA Installer\\Wise\\Code\\";

                    var di = new DirectoryInfo(WisePath + InstallerName + ".wse");
                    di.Attributes &= ~FileAttributes.ReadOnly;

                    ProcessStartInfo ProcessInfo;
                    Process Process;


                    if (Environment.Is64BitOperatingSystem)
                    {
                        ProcessInfo = new ProcessStartInfo("C:\\Program Files (x86)\\Wise Installation System\\Wise32.exe", " /c /s /Yes " + "\"" + WisePath + InstallerName + ".wse" + "\"");
                    }
                    else
                    {
                        ProcessInfo = new ProcessStartInfo("C:\\Program Files\\Wise Installation System\\Wise32.exe", " /c /s /Yes " + "\"" + WisePath + InstallerName + ".wse" + "\"");

                    }


                    //  ProcessInfo = new ProcessStartInfo("C:\\Program Files\\Wise Installation System\\Wise32.exe", " /c /s /Yes " + "\"D:\\GITHUB\\RISKMASTER_DataExchange\\Data Integrator\\DA Installer\\Wise\\Code\\DALicenseKey.wse\"");
                    ProcessInfo.CreateNoWindow = false;
                    ProcessInfo.UseShellExecute = false;

                    Process = Process.Start(ProcessInfo);
                    Process.WaitForExit();
                    Process.Close();

                    FileInfo file = new FileInfo(WisePath);
                    if (InstallerName == "DAInstaller")
                    {
                        string PathNew = WisePath + "DEProductInstaller_CMD_" + DateTime.Now.ToString("yyyyMM") + ".exe";
                        if (File.Exists(PathNew))
                        {
                            File.Delete(PathNew);
                        }

                        File.Move(WisePath + "DAInstaller.exe", PathNew);
                    }
                    if (InstallerName == "DELicenseKey")
                    {
                        string PathNew = WisePath + "DELicenseKey_CMD_" + DateTime.Now.ToString("yyyyMM") + ".exe";
                        if (File.Exists(PathNew))
                        {
                            File.Delete(PathNew);
                        }

                        File.Move(WisePath + "DELicenseKey.exe", PathNew);
                    }

                }
            }
            catch (Exception e)
            {
                Err = true;
                Message = "Error encountered while compilation of  " + InstallerName + ".wse " + "at " + DateTime.Now + ".";
                Console.WriteLine("Error encountered while compilation of  " + InstallerName + ".wse " + " at " + DateTime.Now + ". ( " + e.Message + " )");
            }
        }

        static public void QADeliverable()
        {
            try
            {
                if (!Err)
                {
                    Message = "QA Deliverable processing started at " + DateTime.Now + ".";
                    Console.WriteLine("QA Deliverable processing started at " + DateTime.Now + ".");
                    int i = 0;

                    string[] fileName = { "DELicenseKey.EXE", "DEProductInstaller_CMD_" + DateTime.Now.ToString("yyyyMM") + ".EXE", "Data Exchange Product Installer User Guide.pdf" };
                    string WisePath = Basepath + "RISKMASTER_DataExchange\\Data Integrator\\DA Installer\\Wise\\Code\\";
                    string PDFpath = Basepath + "RISKMASTER_DataExchange\\Data Integrator\\DA Installer\\Documentation\\";
                    string QALoc = QALocation + DateTime.Now.ToString("yyyyMM") + @"\DE_PRODUCT_INSTALLER_GITHUB_CMD_" + DateTime.Now.ToString("yyyyMM");
                    //string QALoc = @"\\cscfilnor002\riskmaster\development\QA\data exchange\" + DateTime.Now.ToString("yyyyMM") + "\DA_INSTALLER_CMD_" + DateTime.Now.ToString("yyyyMM");
                    ///string QALoc = @"\\cscfilnor002\riskmaster\development\QA\data exchange\201803\DA_INSTALLER_CMD_" + DateTime.Now.ToString("yyyyMM");
                    if (!Directory.Exists(QALoc))
                    {
                        Directory.CreateDirectory(QALoc);
                    }

                    foreach (string item in fileName)
                    {
                        Message = "Started copying file " + item + "at :" + DateTime.Now + ".";
                        Console.WriteLine("Started copying file " + item + "at :" + DateTime.Now + ".");


                        if (item.Contains(".pdf"))
                        {
                            WisePath = PDFpath;
                        }

                        string sourceFile = System.IO.Path.Combine(WisePath, fileName[i]);
                        string destFile = System.IO.Path.Combine(QALoc, fileName[i]);
                        if (File.Exists(destFile))
                        {
                            var di = new DirectoryInfo(destFile);
                            di.Attributes &= ~FileAttributes.ReadOnly;
                            File.Delete(destFile);
                        }
                        System.IO.File.Copy(sourceFile, destFile, true);
                        Message = " File :  " + fileName[i] + " has been placed at QA location :  " + QALoc + ".";
                        i++;
                    }
                }
            }
            catch (Exception e)
            {
                Message = "Error Encountered while QA Deliverable processing  at " + DateTime.Now + ".";
                Console.WriteLine("Error Encountered while QA Deliverable processing  at " + DateTime.Now + ". ( " + e.Message + " )");
            }
        }

        public static DataTable GetDataTabletFromFile(string filepath, int iCount)
        {
            DataTable ConfigData = new DataTable();
            try
            {
                using (TextFieldParser csvReader = new TextFieldParser(filepath))
                {
                    string sColumnName = "HEADER";
                    int iIncrement = 1;

                    csvReader.SetDelimiters(new string[] { "|" });

                    while (!csvReader.EndOfData)
                    {
                        string[] fieldData = csvReader.ReadFields();
                        if (iIncrement == 1)
                        {
                            for (int i = 0; i < iCount; i++)
                            {
                                ConfigData.Columns.Add(sColumnName + "_" + iIncrement.ToString());
                                iIncrement = iIncrement + 1;
                            }
                        }

                        ConfigData.Rows.Add(fieldData);
                    }
                }
            }
            catch (Exception e)
            {
                Message = "Error encountered while getting data from DAinstaller Config file at " + DateTime.Now + ". ( " + e.Message + " )";
                Console.WriteLine("Error encountered while getting data from DAinstaller Config file   ( " + e.Message + " )");
                Environment.Exit(0);
            }
            return ConfigData;
        }
    }
    // mkaur24 12/14/2017  RMA-44257 End
}
