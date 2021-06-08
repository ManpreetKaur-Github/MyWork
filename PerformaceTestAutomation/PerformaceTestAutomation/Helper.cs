
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Office.Interop.Excel;
using System.Configuration;
using System.Threading;
using System.Globalization;
using System.Security.AccessControl;
using System.Security.Principal;

namespace PerformaceTestAutomation
{
    class Helper
    {
        public static string connectionString;
        public static string procPath;
        public static string procPathfinal;
        private static String ErrorlineNo, Errormsg, extype, ErrorLocation, exurl, hostIp;
        public static ExcelPackage package = new ExcelPackage();
        public static string finalReportPath;

        public static string sqlProfilerPath;
        public static string profilername;
        public static string sqlServerName;
        public static string sqlUserName;
        public static string sqlPwd;
        public static string sqltemplateName;
        public static string traceFilepath;
        public static string testCafecriptspath;
        public static string processlog;
        public static string processlogpath;
        public static string traceFilepathgen;
        public static int minutesfrTCScript;
        public static int reportType;
        public static string testCafeReportpath;
        public static void ExecuteStoredProcs(string commonProcName)
        {
            //connectionString = @"Data Source=LAPTOP-DA25O9IG;Initial Catalog=Mydb;User ID=sa;Password=Enter@789";
            // procPath = @"C:\officework\systemteam\TestCases\" +  "CommonProcedure.txt";

            procPathfinal = procPath + @"\" + commonProcName + ".txt";
            if (File.Exists(procPathfinal))
            {
                FileInfo file = new FileInfo(procPathfinal);
                string script = file.OpenText().ReadToEnd();
                script = script.Replace("\r\nGO\r\n", "");
                script = Regex.Replace(script, "create procedure", "CREATE PROCEDURE");

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(Convert.ToString(script), con);
                    con.Open();
                    try
                    {

                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        //SendErrorToText(e);

                    }
                    cmd.Dispose();
                    con.Close();

                }
            }
        }

        public static void GetDataintoExcel(string commonProcName, string oldTable, string newtable, int count, string testCaseName, int reportType)
        {

            //connectionString = @"Data Source=LAPTOP-DA25O9IG;Initial Catalog=Mydb;User ID=sa;Password=Enter@789";
            //finalReportPath = @"C:\officework\systemteam\sqlprofiler\SPReport.xlsx";           

            if (count < 12)
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("CommonProcedure", con);
                    //SqlCommand cmd = new SqlCommand("CommonProcedure", con);
                    con.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@OLD_TABLE", SqlDbType.VarChar).Value = oldTable;
                    cmd.Parameters.Add("@NEW_TABLE", SqlDbType.VarChar).Value = newtable;
                    if (reportType == 2)
                        cmd.Parameters.Add("@setting ", SqlDbType.VarChar).Value = '1';
                    else
                        cmd.Parameters.Add("@setting ", SqlDbType.VarChar).Value = '0';
                    //cmd.Parameters.Add("@OLD_TABLE", SqlDbType.VarChar).Value = "CL_CreateDiary";
                    //cmd.Parameters.Add("@NEW_TABLE", SqlDbType.VarChar).Value = "NewCreateDiary";

                    cmd.ExecuteNonQuery();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);


                    System.Data.DataTable dt1 = new System.Data.DataTable();
                    DataSet ds = new DataSet();
                    da.Fill(dt1);
                    ds.Tables.Add(dt1);

                    if (count == 0)
                    {
                        var worksheet = package.Workbook.Worksheets.Add(testCaseName);
                        int z = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 1)
                    {
                        var worksheet1 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet1.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet1.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 2)
                    {
                        var worksheet2 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet2.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet2.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 3)
                    {
                        var worksheet3 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet3.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet3.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 4)
                    {
                        var worksheet4 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet4.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet4.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 5)
                    {
                        var worksheet5 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet5.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet5.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 6)
                    {
                        var worksheet6 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet6.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet6.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 7)
                    {
                        var worksheet7 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet7.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet7.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 8)
                    {
                        var worksheet8 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet8.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet8.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 9)
                    {
                        var worksheet9 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet9.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet9.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    else if (count == 10)
                    {
                        var worksheet10 = package.Workbook.Worksheets.Add(testCaseName);
                        int z1 = 1;
                        for (int x = 0; x < ds.Tables.Count; x++)
                        {
                            int r = z1;
                            int t = r + 1;
                            for (int i = 1; i < ds.Tables[x].Columns.Count + 1; i++)
                            {
                                worksheet10.Cells[r, i].Value = ds.Tables[x].Columns[i - 1].ToString();
                            }
                            for (int i = 0; i < ds.Tables[x].Rows.Count; i++)
                            {
                                for (int j = 0; j < ds.Tables[x].Columns.Count; j++)
                                {
                                    worksheet10.Cells[i + t, j + 1].Value = ds.Tables[x].Rows[i]
                                    [j].ToString();
                                }
                            }
                            z1 = ds.Tables[x].Rows.Count + 4;
                        }
                    }
                    cmd.Dispose();
                    con.Close();
                }
            }
            else
            {
                if (package.Workbook.Worksheets.Count > 0)
                {

                    package.SaveAs(new FileInfo(finalReportPath));

                    processlog = processlog + "\n";
                    Console.WriteLine("Final Report generated at: '" + finalReportPath + "'");
                    processlog = processlog + "\n" + "Final Report generated at: '" + finalReportPath + "'";
                }
                else
                {
                    processlog = processlog + "\n";
                    Console.WriteLine("No Final Report generated as No successfull test case achieved.");
                    processlog = processlog + "\n" + "No Final Report generated as No successfull test case achieved.";
                }


            }

            //package.SaveAs(new FileInfo(@"C:\officework\systemteam\sqlprofiler\SPReport.xlsx"));
        }

        public static void SendErrorToText(Exception ex)
        {
            var line = Environment.NewLine + Environment.NewLine;

            ErrorlineNo = ex.StackTrace.Substring(ex.StackTrace.Length - 7, 7);
            Errormsg = ex.GetType().Name.ToString();
            extype = ex.GetType().ToString();
            ErrorLocation = ex.Message.ToString();

            try
            {
                string filepath = System.IO.Directory.GetCurrentDirectory();  //Text File Path

                if (!Directory.Exists(filepath))
                {
                    Directory.CreateDirectory(filepath);

                }
                filepath = filepath + DateTime.Today.ToString("dd-MM-yy") + ".txt";   //Text File Name
                if (!File.Exists(filepath))
                {
                    File.Create(filepath).Dispose();
                }
                using (StreamWriter sw = File.AppendText(filepath))
                {
                    string error = "Log Written Date:" + " " + DateTime.Now.ToString() + line + "Error Line No :" + " " + ErrorlineNo + line + "Error Message:" + " " + Errormsg + line + "Exception Type:" + " " + extype + line + "Error Location :" + " " + ErrorLocation + line + " Error Page Url:" + " " + exurl + line + "User Host IP:" + " " + hostIp + line;
                    sw.WriteLine("-----------Exception Details on " + " " + DateTime.Now.ToString() + "-----------------");
                    sw.WriteLine("-------------------------------------------------------------------------------------");
                    sw.WriteLine(line);
                    sw.WriteLine(error);
                    sw.WriteLine("--------------------------------*End*------------------------------------------");
                    sw.WriteLine(line);
                    sw.Flush();
                    sw.Close();
                }

            }
            catch (Exception e)
            {
                e.ToString();

            }
        }

        public static void ReadConfig()
        {

            connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ToString();


            sqlProfilerPath = ConfigurationManager.AppSettings["sqlProfilerPath"];
            profilername = ConfigurationManager.AppSettings["profilername"];
            sqlServerName = ConfigurationManager.AppSettings["sqlServerName"];
            sqlUserName = ConfigurationManager.AppSettings["sqlUserName"];
            sqlPwd = ConfigurationManager.AppSettings["sqlPwd"];
            sqltemplateName = ConfigurationManager.AppSettings["sqltemplateName"];
            minutesfrTCScript = Convert.ToInt32(ConfigurationManager.AppSettings["minutesfrTCScript"]);
            reportType = Convert.ToInt32(ConfigurationManager.AppSettings["reportType"]);

        }

        public static void ExecuteCMDCommand(string testCaseName, int count)
        {
            //string sqlProfilerPath = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server Tools 17\Performance Tools";
            //string profilername = "SQL Server Profiler 17.lnk";
            //string sqlServerName = "LAPTOP-DA25O9IG";
            //string sqlUserName = "sa";
            //string sqlPwd = "Enter@123";
            //string sqltemplateName = "Mydb";        
            //string traceFilepath = "C:\\officework\\systemteam\\Test1.trc";


            traceFilepathgen = traceFilepath + "\\" + testCaseName + ".trc";

            if (File.Exists(traceFilepathgen))
            {
                File.Delete(traceFilepathgen);
            }
            DateTime now = DateTime.Now;
            DateTime timeforTestCase = now.AddMinutes(minutesfrTCScript);

            Console.WriteLine("timeforTestCase: " + timeforTestCase);
            processlog = processlog + "\n" + "timeforTestCase " + timeforTestCase;

            string stimeforTestCase = timeforTestCase.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);

            System.Diagnostics.Process process = new System.Diagnostics.Process();
            System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
            startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            startInfo.FileName = "cmd.exe";
            //startInfo.WorkingDirectory = @"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server Tools 17\Performance Tools";
            //startInfo.Arguments = "/c \"\"SQL Server Profiler 17.lnk\" /S LAPTOP-DA25O9IG /U sa /P Enter@123 /T \"Mydb\" /M  \"2021-04-12 02:50:00\" /O \"C:\\officework\\systemteam\\Test1.trc\"\"";

            startInfo.WorkingDirectory = sqlProfilerPath;


            startInfo.Arguments = " /c \"\"" + profilername + "\"" + " /S " + sqlServerName + " /U " + sqlUserName + " /P " + sqlPwd + " /T \"" + sqltemplateName + "\" /M \"" + stimeforTestCase + "\" /O \"" + traceFilepathgen + "\"\"";

            process.StartInfo = startInfo;

            process.Start();

            ExecuteTestCafeScript(testCaseName);

            /// Thread.Sleep(1000 * 60 * 4);
            if (!Program.testCafeerrorFlag)
            {
                Console.WriteLine("Trace file '" + testCaseName + ".trc" + "' generated at " + DateTime.Now.ToString());
                processlog = processlog + "\n" + "Trace file '" + testCaseName + ".trc" + "' generated at " + DateTime.Now.ToString();
                Console.WriteLine();
            }


        }

        public static void ExecuteTestCafeScript(string testCaseName)
        {


            System.Diagnostics.Process process = new System.Diagnostics.Process();
            System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
            //startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            startInfo.FileName = "cmd.exe";
            startInfo.WorkingDirectory = testCafecriptspath;
            startInfo.Arguments = " /c testcafe chrome " + testCaseName + ".js" + " --reporter html:" + testCafeReportpath + "\\" + testCaseName + ".html";
            //--reporter html:C:\SmokeTest_IUTSQL\smokeresults\Results.html
            process.StartInfo = startInfo;
            process.StartInfo.UseShellExecute = false;
            //process.StartInfo.RedirectStandardInput = true;
            process.StartInfo.RedirectStandardOutput = true;
            process.Start();

            Thread.Sleep(1000 * 60 * (minutesfrTCScript + 1));
            string output = process.StandardOutput.ReadToEnd();
            if (output.Contains("Testcase Successful"))
            {

                Console.WriteLine("Execution of testcafe script is successfull for '" + testCaseName + "'");
                processlog = processlog + "\n" + "Execution of testcafe script is successfull for '" + testCaseName + "'";

            }
            else
            {
                Program.testCafeerrorFlag = true;
                Console.WriteLine("Execution of testcafe script gave error for test case name:'" + testCaseName + "'. Therefore, Skipping the test case.");
                processlog = processlog + "\n" + "Execution of testcafe script gave error for test case name:'" + testCaseName + "'. Therefore, Skipping the test case.";
                processlog = processlog + "\n" + "****************************************************************************************";
                Console.WriteLine("****************************************************************************************");
            }
            //while (!process.StandardOutput.EndOfStream)
            //{
            //    var line = process.StandardOutput.ReadLine();
            //    Console.WriteLine(line);
            //}
        }

        public static void CreateRequiredFolders()
        {
            var GetDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            string path = GetDirectory.Substring(0, GetDirectory.LastIndexOf('\\'));
            processlogpath = path;
            Directory.CreateDirectory(path + "\\FinalReportGenerated");
            finalReportPath = path + "\\FinalReportGenerated";

            if (reportType == 2)
                finalReportPath = finalReportPath + @"\Type2DuplicateQueriesReport" + DateTime.Now.ToString("yyyy-MM-dd-HHmmss") + ".xlsx";
            else
                finalReportPath = finalReportPath + @"\Type1PerformanceTestingReport" + DateTime.Now.ToString("yyyy-MM-dd-HHmmss") + ".xlsx";

            Console.WriteLine("FinalReportGenerated folder created at " + path);
            processlog = processlog + "\n" + "FinalReportGenerated folder created at " + path;

            Directory.CreateDirectory("C:\\TraceFiles");
            traceFilepath = "C:\\TraceFiles";

            Console.WriteLine("TraceFiles folder created at C:\\TraceFiles");
            processlog = processlog + "\n" + "TraceFiles folder created at C:\\TraceFiles";

            procPath = path + "\\TestCaseProcedures";

            testCafecriptspath = path + "\\TestCafeCode";

            Directory.CreateDirectory(path + "\\TestCafeReports");
            // Delete all files in a TestCafeReports directory.
            string[] files = Directory.GetFiles(path + "\\TestCafeReports");
            foreach (string file in files)
            {
                File.Delete(file);
                Console.WriteLine($"{file} is deleted.");
            }
            testCafeReportpath = path + "\\TestCafeReports";

            Console.WriteLine("Required folder created at location:'" + path + "'");

        }

        public static void ConvertTracefiletotracetbl(string newtable)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("LoadTraceFileToTable", con);
                con.Open();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@traceFileName", SqlDbType.VarChar).Value = traceFilepathgen;
                cmd.Parameters.Add("@newTraceTableName", SqlDbType.VarChar).Value = newtable;
                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (Exception e)
                {
                    SendErrorToText(e);
                }
                cmd.Dispose();
                con.Close();
            }
            Console.WriteLine("TraceFile converted to trace table named " + newtable);
            processlog = processlog + "\n" + "TraceFile converted to trace table named " + newtable;
        }

        public static void createprocesslog(string processlog)
        {
            processlogpath = processlogpath + "\\PerfTestAutomationProcesslog_" + DateTime.Now.ToString("yyyy-MM-dd-HHmmss") + ".txt";
            File.WriteAllText(processlogpath, processlog);


        }


        public static void Dropiftableexists(string newtable)
        {
            int value = 0;
            string sSql = "SELECT 1 as output FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'  AND TABLE_NAME='" + newtable + "'"; ;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sSql, connection);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        value = Convert.ToInt32(reader[0]);
                    }
                }
                finally
                {

                    reader.Close();
                }
            }

            if (value > 0)
            {
                sSql = "Drop table " + newtable;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(sSql, connection);
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    reader.Close();
                }
            }
        }

        public static void CreateBLfromCLtable(string oldtable, string newtable)
        {
            int value = 0;
            string sSql = "SELECT 1 as output FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'  AND TABLE_NAME='" + oldtable + "'"; ;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(sSql, connection);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        value = Convert.ToInt32(reader[0]);
                    }
                }
                finally
                {

                    reader.Close();
                }
            }

            if (value > 0)
            {
                sSql = "Drop table " + oldtable; // Delete Old BL tables if exists. 
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand(sSql, connection);
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    reader.Close();
                }
                // Create BL tables from CL tables 
                sSql = "Drop table " + oldtable;
            }
        }
    }
}
