using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using Riskmaster.Common;
using System.IO;


namespace DDSScriptTool
{
    class Program
    {
        
        static protected string m_StagingDBSourceName = "RMXStagingDataSource";
        static protected string m_TaskDBSourceName = "TaskManagerDataSource";
        static protected string     m_ErrMsg = string.Empty;
       static protected bool c_flag = true;
        
        static void Main(string[] args)
        {
             
            int m_iclientId = int.Parse(RMConfigurationManager.GetAppSetting("ClientId"));//sdesai31 JIRA 35996
            string sStagingCon = string.Empty;
            string sTaskmgrCon = string.Empty;
            string sSecuritDSN = string.Empty;

            
            sTaskmgrCon = RMConfigurationManager.GetConnectionString("TaskManagerDataSource", m_iclientId);


            //kkaur25-Retrieving the path from app settings where scripts are placed.
            string sfolderpath = string.Empty;
            string soutputpath = string.Empty;
            //sfolderpath = RMConfigurationManager.GetAppSetting("DDSScriptFolder", sStagingCon, m_iclientId);
            sfolderpath = RMConfigurationManager.GetAppSetting("DDSScriptFolder");//sdesai31 JIRA 35996
            //soutputpath = RMConfigurationManager.GetAppSetting("DDSScriptOutputPath", sStagingCon, m_iclientId);
            soutputpath = RMConfigurationManager.GetAppSetting("DDSScriptOutputPath");//sdesai31 JIRA 35996
            sStagingCon = DbValidate.checktable(sTaskmgrCon, m_iclientId, sfolderpath,soutputpath);
            
            
            if (string.IsNullOrEmpty(sfolderpath) || string.IsNullOrEmpty(soutputpath))
            {
                Console.Write("Please specify the script paths in app.config.");
                Console.ReadKey();
                c_flag = false;               
            }
            if (!Directory.Exists(sfolderpath)||!Directory.Exists(soutputpath))
            {
                Console.Write("Please check the scripts path mentioned in app.config as it doesnt exists.");
                Console.ReadKey();
                c_flag = false;   
            }

            if (c_flag == true)
            {
                string pathnew = Path.Combine(soutputpath, "DDSScriptsErrorLog.txt");

                if (string.IsNullOrEmpty(sTaskmgrCon))
                {
                    ErrorMessage = " No Taskmanager database connection string found under key \"" + m_TaskDBSourceName + "\".";
                    DbValidate.writeLog(ErrorMessage, pathnew);
                }
                if (string.IsNullOrEmpty(sStagingCon))
                {
                    ErrorMessage = "No staging database connection string found under key \"" + m_StagingDBSourceName + "\".";
                    DbValidate.writeLog(ErrorMessage, pathnew);
                }
                if (!string.IsNullOrEmpty(sStagingCon) && !string.IsNullOrEmpty(sTaskmgrCon))
                {
                    DbValidate.RunScripts(sStagingCon, m_iclientId, sTaskmgrCon, sfolderpath, soutputpath, pathnew);
                }
            }
        }
        static public string ErrorMessage
        {
            get { return m_ErrMsg; }
            set { m_ErrMsg += value + "\r\n"; }
        }
        
        }
    }

