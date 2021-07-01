using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.OleDb;
using DA_DIS_Conversion_Tool;
using System.Windows.Forms;
using System.IO;
using Microsoft.Win32;

namespace DA_DIS_Conversion_Tool
{
    public class CommandLineProcessing : Form
    {
        public StreamWriter sw;
        //public int iCounter;
        public CommandLineProcessing()
        {
            sw = new StreamWriter(Path.GetDirectoryName(Application.ExecutablePath) + "\\DISCommandConversion_Log.txt");
            sw.AutoFlush = true;
            //iCounter = 0;
        }

        ~CommandLineProcessing()
        {
            //sw.Flush();
            //sw.Close();
        }

        // This event handler is where the time-consuming work is done.
        public void DoWork(string[] args)
        {
            
                if (String.IsNullOrEmpty(args[0]) || (String.IsNullOrEmpty(args[1])) || (String.IsNullOrEmpty(args[2])))
                {

                    sw.WriteLine("Please select the required files");
                    sw.Flush();
                    sw.Close();
                    return;
                }
                bool isValid = XPathValidation.Validate(args[0]);
                if (isValid == false)
                {
                    sw.WriteLine("The Format Definition File contains errors. Please provide a correct file");
                    sw.Flush();
                    sw.Close();
                    return;
                }
                //ReadFile read_import_file = new ReadFile();
                try
                {
                    //ReadXML read = new ReadXML();
                    int b;
                    DataSet XMLDataset = ReadXMLFile(args[0], 1, out b);

                    if (b != 1)
                    {
                        //LoadTables load = new LoadTables();
                        int a;
                        DataSet target = LoadAccessTables(XMLDataset, args[2], args[3], 1, out a);
                        if (a != 1)
                        {
                            int rows = ReadTextFile(args[1], args[2], XMLDataset, target, 1);
                            if (rows == -1)
                            {
                                sw.WriteLine("Processing Halted. Please check the process log");
                            }
                            else
                            {
                                //if (iCounter > 0)
                                //{
                                //    sw.WriteLine("\n Data truncated as it exceeded the maximum size allowed. Total Number of Data Truncated:" + iCounter);
                                //}
                                sw.WriteLine("Processing Completed. Records added to Access DB: " + rows);
                                sw.WriteLine("Application exited at: " + DateTime.Now.ToString());
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    sw.WriteLine("Processing Halted.\nPlease check if all the selected files are valid");
                }
                finally
                {
                    sw.Flush();
                    sw.Close();
                    //Execute.Text = "Execute";
                }
        }
        public int ReadTextFile(string TextPath, string AccessPath, DataSet ds, DataSet target, int iCommandLine)
        {
            string sColNames = string.Empty;
            string fileContent;
            StreamReader filestream;
            try
            {
                filestream = new System.IO.StreamReader(TextPath);
            }
            catch (Exception e)
            {
                sw.WriteLine("Invalid data File Path. Please correct and try again");
                return -1;
            }
            int total_records = 0;
            while (((fileContent = filestream.ReadLine()) != null) && (fileContent != ""))
            {
                total_records++;
            }
            filestream.Close();
            filestream = new System.IO.StreamReader(TextPath);
            DataRow FmtDefRow = ds.Tables["FmtDef"].Rows[0];
            string skip_lines = Convert.ToString(FmtDefRow["SkipLines"]);
            int skipLines_count = 0;
           // int Count = 0;
            if (skip_lines != "")
            {
                skipLines_count = Convert.ToInt32(FmtDefRow["SkipLines"]);
            }
            total_records = total_records - skipLines_count;
            int source_file_position = 0;
            int source_file_position_new = 0;
            for (int i = 0; i < skipLines_count; i++)
            {
                filestream.ReadLine();
            }
            source_file_position = source_file_position + skipLines_count;
            string comment_string = Convert.ToString(FmtDefRow["CommentString"]);
            int comment_string_length = comment_string.Length;
            int line_count = 0;

            sw.WriteLine("Data file processing in progress...");
            while (((fileContent = filestream.ReadLine()) != null) && (fileContent != "") && (source_file_position++ != -1))  // loop 1
                if (fileContent.Substring(0, comment_string_length) != comment_string) // skip comments
                {
                    {
                        line_count = line_count + 1;
                        DataTable dt = ds.Tables["Table"];
                        foreach (DataRow row in dt.Rows)       // loop 2
                        {
                            string target_table_xml = Convert.ToString(row["Table_Text"]);
                            string target_table_primary_key = Convert.ToString(row["PK"]);
                            DataRow newRow = target.Tables[target_table_xml].NewRow();
                            if ((target_table_primary_key != null) & (target_table_primary_key != ""))
                            {
                                newRow[target_table_primary_key] = line_count;
                            }
                            DataTable field = ds.Tables["Field"];
                            foreach (DataRow row1 in field.Rows)  // loop 3
                            {
                                int field_id = Convert.ToInt32(row1["Field_ID"]);   // field id captured to get mapping values
                                string target_table = Convert.ToString(row1["Table"]);
                                string target_column = Convert.ToString(row1["Column"]);
                                int start_position = Convert.ToInt32(row1["Start"]);
                                int var_length = Convert.ToInt32(row1["Length"]);
                                source_file_position_new = source_file_position - skipLines_count;
                                string target_value;
                                try
                                {
                                    target_value = fileContent.Substring(start_position, var_length);
                                    target_value = target_value.Trim();
                                }
                                catch (Exception e)
                                {
                                    sw.WriteLine("Target value could not be read for " + target_table + "." + target_column + ". Record position in source data file: " + source_file_position_new + ". Please check the validity of selected files");
                                    target_value = string.Empty;
                                }
                                DataTable Mapping = ds.Tables["Mapping"];
                                foreach (DataRow row2 in Mapping.Rows)   // loop thru mapping table
                                {
                                    int mapping_id = Convert.ToInt32(row2["Mapping_ID"]);
                                    string default_value = Convert.ToString(row2["Default"]);
                                    int field_id_mapping_table = Convert.ToInt32(row2["Field_ID"]);
                                    if (field_id == field_id_mapping_table)
                                    {
                                        DataTable Map = ds.Tables["Map"];
                                        string match = string.Empty;
                                        foreach (DataRow row3 in Map.Rows)
                                        {
                                            string from_value = Convert.ToString(row3["From"]);
                                            string to_value = Convert.ToString(row3["To"]);
                                            int mapping_id_map_table = Convert.ToInt32(row3["Mapping_ID"]);
                                            if (mapping_id == mapping_id_map_table)
                                            {
                                                if (from_value == target_value)
                                                {
                                                    target_value = to_value;
                                                    match = "yes";
                                                }
                                            }
                                        }
                                        if (match != "yes")
                                            target_value = default_value;
                                    }
                                }
                                int target_value_size = target_value.Length;
                                string conversion_type;
                                string target_data_type;
                                int target_column_size;
                                try
                                {
                                    target_data_type = Convert.ToString(target.Tables[target_table].Columns[target_column].DataType);
                                    target_column_size = target.Tables[target_table].Columns[target_column].MaxLength;
                                }
                                catch (Exception e)
                                {
                                    sw.WriteLine("Error occured while reading from " + target_table + "." + target_column + ". Please check the validity of selected files");
                                    target_data_type = string.Empty;
                                    target_column_size = -1;
                                    return -1;
                                }
                                if (target_column_size != -1)  // If the column has no maximum length, the value is -1
                                {
                                    if (target_column_size < target_value_size)
                                    {
                                        string initial_target_value = target_value;  // store the value before truncation
                                        target_value = target_value.Substring(0, target_column_size);
                                        if (target_table == target_table_xml)
                                        {
                                            //iCounter++;                                            
                                            if (sColNames.Length == 0 || sColNames.IndexOf("|" + target_column + "|") == -1)
                                            {
                                                sw.WriteLine("\n'" + target_column + "' in " + target_table + " table has improper length." + " Data may be truncated.");
                                                sColNames = sColNames + "|" + target_column + "|";
                                            }
                                        }
                                    }
                                }
                                switch (target_data_type)
                                {
                                    case "System.String": conversion_type = "String";
                                        break;
                                    case "System.Int32": conversion_type = "Integer";
                                        break;
                                    default: conversion_type = "";
                                        break;
                                }
                                if (target_table == target_table_xml) //if field points to current target table from loop 2
                                {
                                    if (target_value != "")
                                    {
                                        try
                                        {
                                            if (conversion_type == "String")
                                            { newRow[target_column] = target_value; }
                                            else if (conversion_type == "Integer")
                                            { newRow[target_column] = Convert.ToInt32(target_value); }
                                        }
                                        catch (Exception e)
                                        {
                                            Form1 frm2 = Log.GetMainForm();
                                            if (frm2.Halt_Processing.Checked)
                                            {
                                                sw.WriteLine("'" + target_value + "' failed to convert to required data type for " + target_table_xml + "." + target_column + ". Record position in source data file: " + source_file_position_new);
                                                return -1;
                                            }
                                            else
                                            {
                                                newRow[target_column] = System.DBNull.Value;
                                                sw.WriteLine("'" + target_value + "' failed to convert to required data type for " + target_table_xml + "." + target_column + ". Record position in source data file: " + source_file_position_new + ". NULL value inserted");
                                            }

                                        } // place null in column or stop execution based on Halt Processing option
                                    }
                                }

                            }
                            target.Tables[target_table_xml].Rows.Add(newRow); // add the populated row to target table
                        }
                        
                    }
                }
            filestream.Close();
            DataTable dt1 = ds.Tables["Table"];
            OleDbDataAdapter adapter;
            foreach (DataRow row in dt1.Rows)    // loop to update target tables
            {
                string target_table_xml = Convert.ToString(row["Table_Text"]);
                string file_name = System.IO.Path.GetFileName(AccessPath);
                string file_ext = System.IO.Path.GetExtension(AccessPath);
                OleDbConnection conn;
                if (file_ext == ".accdb")
                {
                    conn =
                       new OleDbConnection(
                           "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + AccessPath + ";");
                }
                else
                {
                    conn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + AccessPath + ";");
                }
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }
                string queryString = "select * from " + target_table_xml;
                adapter = new OleDbDataAdapter(queryString, conn);
                OleDbCommandBuilder builder = new OleDbCommandBuilder(adapter);
                adapter.UpdateCommand = builder.GetUpdateCommand();
                try
                {
                    adapter.Update(target, target_table_xml);
                }
                catch (Exception e)
                {
                    sw.WriteLine("Database Upload Error. Please check your target database and try again");
                    return -1;
                }
                adapter.Dispose();
                
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            return line_count;
        } // method

        public DataSet LoadAccessTables(DataSet ds, string AccessPath, string Flag,int iCommandLine, out int a)
        {
            DataSet target = new DataSet();
            OleDbConnection conn;
            try
            {
                string file_name = System.IO.Path.GetFileName(AccessPath);
                string file_ext = System.IO.Path.GetExtension(AccessPath);
                if (file_ext == ".accdb")
                {
                    conn =
                      new OleDbConnection(
                          "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + AccessPath + ";");
                }
                else
                {
                    conn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + AccessPath + ";");
                }
            }
            catch (Exception e)
            {
                sw.WriteLine("Invalid Access File Path. Please correct and try again. Processing Halted");
                a = 1;
                return target;
            }
            //DataTable dt = ds.Tables[2];
            DataTable dt = ds.Tables["Table"];
            OleDbDataAdapter adapter;
                DateTime time = DateTime.Now;
                string sCurDir = Path.GetDirectoryName(Application.ExecutablePath);
                sw.WriteLine("Application started at: " + time.ToString());
            if (dt != null)
            {
                if (Flag.ToUpper() == "YES")
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        string target_table = Convert.ToString(row["Table_Text"]);
                        if (conn.State == ConnectionState.Closed)
                        {
                            conn.Open();
                        }
                        string queryString = "select * from " + target_table;
                        adapter = new OleDbDataAdapter();
                        adapter = new OleDbDataAdapter(queryString, conn);
                        adapter.MissingSchemaAction = MissingSchemaAction.Add;
                        target.Tables.Add(target_table);
                        try
                        {
                            adapter.Fill(target, target_table);
                        }
                        catch (Exception e)
                        {
                            sw.WriteLine("Error occured while reading data from Access DB for target table: " + target_table + ". Please check the validity of selected files. \nProcessing Halted.");
                            a = 1;
                            return target;
                        }
                        if (target.Tables[target_table].Rows.Count != 0)
                        {
                            sw.WriteLine("Clearing records from " + target_table + " Table ...");
                            for (int j = 0; j < target.Tables[target_table].Rows.Count; j++)
                            {
                                target.Tables[target_table].Rows[j].Delete();
                            }
                            OleDbCommandBuilder builder = new OleDbCommandBuilder(adapter);
                            adapter.UpdateCommand = builder.GetUpdateCommand();
                            adapter.Update(target, target_table);

                        }
                        else if (target.Tables[target_table].Rows.Count == 0)
                        {
                            sw.WriteLine("Target Table " + target_table + " is empty.");
                        }
                        adapter.FillSchema(target, SchemaType.Source, target_table);
                        adapter.Dispose();
                    }
                }
                else if (Flag.ToUpper() == "NO")
                {
                    sw.WriteLine("Processing Halted - please verify/backup the DIS Access database.Re-run to continue the conversion process");
                    sw.WriteLine("Application exited at: " + DateTime.Now.ToString());
                    a = 1;
                    return target;
                }
                else if (Flag.ToUpper() != "YES" || Flag.ToUpper() != "NO")
                {
                    sw.WriteLine("Please check for the argument passed : Yes/No");
                    sw.WriteLine("Application exited at: " + DateTime.Now.ToString());
                    a = 1;
                    return target;
                }
            }
            conn.Close();
            a = 0;
            return target;

        }  // method

        public DataSet ReadXMLFile(string Path, int iCommandLine, out int b)
        {
            DataSet ds = new DataSet();
            try
            {
                ds.ReadXml(Path);
            }
            catch (Exception e)
            {
                sw.WriteLine("Invalid Format Definition File Path. Please correct and try again. Processing Halted");
                sw.WriteLine("Application exited at: " + DateTime.Now.ToString());
                b = 1;
                return ds;
            }
            b = 0;
            return ds;
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            // 
            // CommandLineProcessing
            // 
            this.ClientSize = new System.Drawing.Size(292, 266);
            this.Name = "CommandLineProcessing";
            this.Load += new System.EventHandler(this.CommandLineProcessing_Load);
            this.ResumeLayout(false);

        }

        private void CommandLineProcessing_Load(object sender, EventArgs e)
        {

        }

    }

    public static class GlobalVar
    {
        [STAThread]
        public static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            if (args.Length > 0)
            {
                CommandLineProcessing cmdprocess = new CommandLineProcessing();
                if (args.Length == 4)
                {
                    cmdprocess.DoWork(args);
                }
                else
                {
                    cmdprocess.sw.WriteLine("Number of arguments to the command line are missing, Please provide correct number of arguments");
                    cmdprocess.sw.WriteLine("Application exited at: " + DateTime.Now.ToString());
                    cmdprocess.sw.Flush();
                    cmdprocess.sw.Close();
                }
            }
            else
            {
                Application.Run(new Form1(args));
            }
        }
    }

    class ReadXML
    {
        //[STAThread]
    }

    class LoadTables
    {
    } // class

    class ReadFile
    {
        public System.IO.StreamReader filestream;
    } // class


}  // namespace

