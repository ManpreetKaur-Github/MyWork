
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PerformaceTestAutomation
{
    class Program : Helper
    {
        public static string commonProcName;
        public static string oldTable;
        public static string newtable;
        public static bool testCafeerrorFlag = false;
        public static int count = 0;



        static void Main(string[] args)
        {
            Debugger.Launch();
            ReadConfig();

            Console.WriteLine("Automation Process started at " + DateTime.Now.ToString());
            processlog = "Automation Process started at " + DateTime.Now.ToString();

            Console.WriteLine();
            processlog = processlog + "\n";

            CreateRequiredFolders();

            List<string> procName = ConfigurationManager.AppSettings["procName"].Split('|').ToList();
            foreach (string procname in procName)
            {
                ExecuteStoredProcs(procname); // only one time Common procedure will be executed.
            }

         

            List<string> ConfigValues = ConfigurationManager.AppSettings["testCaseName"].Split('|').ToList();
            count = 0;

            Console.WriteLine();
            processlog = processlog + "\n";

            foreach (string testCaseName in ConfigValues)
            {
                oldTable = "";
                newtable = "";
                Program.testCafeerrorFlag = false;
                Console.WriteLine();
                processlog = processlog + "\n";

                Console.WriteLine((count+1) + " Process started for test case name:'" + testCaseName + "' at " + DateTime.Now.ToString());
                processlog = processlog + "\n" + (count+1) + " Process started for test case name:'" + testCaseName + "' at " + DateTime.Now.ToString();

                if (testCaseName == "CreateDiary")
                {
                    //oldTable = "CL_CreateDiary";
                    //newtable = "NewCreateDiary1";

                    oldTable = "BL_CreateDiary";
                    newtable = "CL_CreateDiary";
                }
                else if (testCaseName == "Event")
                {
                    //oldTable = "CL_CreateDiary";
                    //newtable = "NewCreateDiary2";

                    oldTable = "BL_EventSave";
                    newtable = "CL_EventSave";
                }
                else if (testCaseName == "GCCarrier")
                {
                    oldTable = "BL_CarrierGCSave";
                    newtable = "CL_CarrierGCSave";
                }
                else if (testCaseName == "GeneralClaim_EnhNotes")
                {
                    oldTable = "BL_EnhNotes";
                    newtable = "CL_EnhNotes";
                }
                else if (testCaseName == "GeneralClaim_Pay")
                {
                    oldTable = "BL_PaymentSave";
                    newtable = "CL_PaymentSave";
                }
                else if (testCaseName == "Maintenance")
                {
                    oldTable = "BL_OrgHier";
                    newtable = "CL_OrgHier";
                }
                else if (testCaseName == "Maintenance_Employee")
                {
                    oldTable = "BL_EmployeeSave";
                    newtable = "CL_EmployeeSave";
                }
                else if (testCaseName == "Maintenance_Entity")
                {
                    oldTable = "BL_EntitySave";
                    newtable = "CL_EntitySave";
                }
                else if (testCaseName == "Search")
                {
                    oldTable = "BL_SearchClaim";
                    newtable = "CL_SearchClaim";
                }
                else if (testCaseName == "Utilities")
                {
                    oldTable = "BL_Utilities";
                    newtable = "CL_Utilities";
                }
                else if (testCaseName == "WCAutoCheck")
                {
                    oldTable = "BL_WCAutoCheck";
                    newtable = "CL_WCAutoCheck";
                }

                ///CreateBLfromCLtable(oldTable, newtable); // the db back up which is restored will have CL and BL tables. From that db -delete old BL tables and create BL table from previous CL tables.

                Dropiftableexists(newtable); /// delete existing CL table so that we can have new CL tables from trace file.

                ExecuteCMDCommand(testCaseName, count); //Step 1.  Start SQL Profiler

                if (!Program.testCafeerrorFlag)
                {
                    ConvertTracefiletotracetbl(newtable);

                    GetDataintoExcel(commonProcName, oldTable, newtable, count, testCaseName,reportType);

                    Console.WriteLine("Process completed for test case name:" + testCaseName + " at " + DateTime.Now.ToString());
                    processlog = processlog + "\n" + "Process completed for test case name:" + testCaseName + " at " + DateTime.Now.ToString();
                    processlog = processlog + "\n" + "****************************************************************************************";
                }

                count++;


            }
            GetDataintoExcel(commonProcName, oldTable, newtable, 12, null, reportType);

            Console.WriteLine("Automation Process completed at " + DateTime.Now.ToString());
            processlog = processlog + "\n" + "Automation Process completed at " + DateTime.Now.ToString();

            createprocesslog(processlog);
        }
    }
}
