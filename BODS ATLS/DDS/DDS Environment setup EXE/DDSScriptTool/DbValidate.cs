using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Riskmaster.Common;
using Riskmaster.Db;
using System.IO;
using System.Data.SqlClient;
using Riskmaster.Db;


namespace DDSScriptTool
{


    class DbValidate
    {

        static protected string m_ErrMsg = string.Empty;
        static protected bool c_flag = true;

        public static void RunScripts(string p_Connectionstring, int p_clientID, string p_Taskmanager, string p_Folderpath, string p_Outputpath,string pathnew)

        {
           
                    
                    string createQuery = string.Empty;
                    string filename = string.Empty;
                    List<string> list = new List<string>();
                    //Retreiving the .config file from the path to read the sequence in which scripts have to be executed.
                    string[] files = System.IO.Directory.GetFiles(p_Folderpath, "DDS_SCRIPT_SEQUENCE.config");
                    if (files == null)
                    {
                        ErrorMessage = "Configuration file not found under path" + p_Folderpath + "\".";
                        c_flag = false;
                        writeLog(ErrorMessage, p_Outputpath);
                        
                    }


                    //Reading the file names from config file and adding the names in list.
                    if (c_flag == true)
                    {
                        foreach (string file in files)
                        {

                            filename = file;
                            using (StreamReader reader = new StreamReader(filename))
                            {
                                string line;
                                while ((line = reader.ReadLine()) != null)
                                {
                                    list.Add(line);
                                    if (DbFactory.IsOracleDatabase(p_Connectionstring) && line.Contains("_SQL"))
                                    {
                                        list.Remove(line);
                                    }
                                    else if (!DbFactory.IsOracleDatabase(p_Connectionstring) && line.Contains("_ORACLE"))
                                    {
                                        list.Remove(line);
                                    }
                                }

                            }
                        }

                        if (list == null)
                        {
                            ErrorMessage = "No sql file is present under path" + p_Folderpath + "\".";
                            goto found;
                        }

                        StringBuilder sbScriptToRun = new StringBuilder();
                        //Opens each file name present in list and executes it on the staging database.
                        foreach (string fname in list)
                        {
                            string[] sqlfiles = System.IO.Directory.GetFiles(p_Folderpath, fname);
                            if (sqlfiles.Length == 0)
                            {
                                ErrorMessage = "Script " + fname + " not found under path " + p_Folderpath + "\".";
                                goto found;
                            }
                            else
                            {
                                try
                                {
                                    FileInfo file = new FileInfo(sqlfiles[0]);
                                    string script = file.OpenText().ReadToEnd();
                                    script = script.Replace("\r\nGO\r\n", "");
                                    script = Regex.Replace(script, "create procedure", "CREATE PROCEDURE");
                                    script = Regex.Replace(script, "create function", "CREATE FUNCTION");
                                    //executes the task manager script on tm database.
                                    if (fname.Contains("_Task"))
                                    {
                                        DbFactory.ExecuteNonQuery(p_Taskmanager, Convert.ToString(script));

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
                                            }

                                        }
                                    }


                                }
                                catch (Exception e)
                                {
                                    ErrorMessage = e.Message + "  This error is found in script  "+ fname;
                                    writeLog(ErrorMessage, pathnew);
                                    //goto found;

                                }
                            }
                        }
                    }
                found:
                    writeLog(ErrorMessage, pathnew);
                       
        }
          
           

        static public string ErrorMessage
        {
            get { return m_ErrMsg; }
            set { m_ErrMsg += value + "\r\n"; }
        }

        //function to create DDSScriptsError_log.txt
        public static void writeLog(string p_strLogText, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            
            
                string sMessage = string.Format("[{0}] {1}", System.DateTime.Now.ToString(), p_strLogText);
                string sNoerror="No error found in scripts.All scripts executed successfully";
                try
                {
                    if (string.IsNullOrEmpty(p_strLogText))
                    {
                        File.WriteAllText(path, sNoerror);
                    }
                    else
                    {
                        File.WriteAllText(path, sMessage);
                    }

                                    }
                catch (Exception exp)
                {
                    throw new Exception("Error Logging Exception :" + exp.Message.ToString(), exp.InnerException);
                }


            

        }

        public static int getdsnid(string dsnname,string connstring)
        {
            int dsind = 0;
            DbConnection objConn = null;
            objConn = DbFactory.GetDbConnection(connstring);
            objConn.Open();
            string sSec = "select DSNID from data_source_table where DSN='" + dsnname +"'";
            dsind=Convert.ToInt32(objConn.ExecuteScalar(sSec));
            return dsind;
        }

        public static string checktable(string taskmgr,int p_clientID,string p_Folderpath, string p_Outputpath)
        {
            int count = 0;
            string sStagingCon = string.Empty;
            DbConnection objConn = null;
            objConn = DbFactory.GetDbConnection(taskmgr);
            string sSecuritDSN = RMConfigurationManager.GetConnectionString("RMXSecurity", p_clientID);
            string sdsnname = RMConfigurationManager.GetAppSetting("DSNName");//sdesai31 JIRA 35996
            objConn.Open();
            string tcheck = string.Empty;
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
                if (!string.IsNullOrEmpty(sdsnname))
                {
                    int dsnid = DbValidate.getdsnid(sdsnname, sSecuritDSN);

                    string sSQL = "SELECT RMXStagingDataSource FROM DA_CONFIG WHERE DSNID = " + dsnid;
                    sStagingCon = (String)DbFactory.ExecuteScalar(taskmgr, sSQL);
                }
                else
                {
                    ErrorMessage = "Please provide the DSN name in exe.config.";
                    c_flag = false;
                    writeLog(ErrorMessage, p_Outputpath);
                }
            }
            else
            {
                sStagingCon = RMConfigurationManager.GetConnectionString("RMXStagingDataSource", p_clientID);
            }
            return sStagingCon;
        }
    }

}         
            
            


         
    


