using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.OleDb;
using System.Data.SqlClient;
using DA_DIS_Conversion_Tool;
using System.IO;

namespace DA_DIS_Conversion_Tool
{
    public partial class Form1 : Form
    {
        //public static int Count = 0;
        public Form1(string[] arg)
        {
            InitializeComponent();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog browseFile = new OpenFileDialog();
            browseFile.Filter = "XML Files (*.xml)|*.xml";
            browseFile.Title = "Browse XML file";
            if (browseFile.ShowDialog() == DialogResult.Cancel)
                return;
            try
            {
                FormatDefinitionFileBox.Text = browseFile.FileName;
            }
            catch (Exception)
            {
                MessageBox.Show("Error opening file", "File Error",
                MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
        private void button2_Click(object sender, EventArgs e)
        {
            OpenFileDialog browseFile = new OpenFileDialog();
            browseFile.Filter = "Text Files (*.txt)|*.txt";
            browseFile.Title = "Browse Text file";
            if (browseFile.ShowDialog() == DialogResult.Cancel)
                return;
            try
            {
                SourceFileBox.Text = browseFile.FileName;
            }
            catch (Exception)
            {
                MessageBox.Show("Error opening file", "File Error",
                MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
        private void button3_Click(object sender, EventArgs e)
        {
            OpenFileDialog browseFile = new OpenFileDialog();
            browseFile.Filter = "Access Files (.mdb .accdb)|*.mdb;*.accdb";
            browseFile.Title = "Browse Access file";
            if (browseFile.ShowDialog() == DialogResult.Cancel)
                return;
            try
            {
                DISAccessDatabaseBox.Text = browseFile.FileName;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error opening file" + ex, "File Error",
                MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
        private void button5_Click(object sender, EventArgs e)
        {
            ProcessLog.ResetText();
        }
        private void Save_Click(object sender, EventArgs e)
        {
            string sFilename = Convert.ToString(Path.GetDirectoryName(Application.ExecutablePath) + "\\DISConversion_Log.txt");
            try
            {
                System.Diagnostics.Process.Start("notepad.exe", sFilename);
            }
            catch (Exception)
            {
                MessageBox.Show("Error Occured while opening the file", "Synchronize Conversion tool", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        private void Execute_Click(object sender, EventArgs e)
        {
            
                if (String.IsNullOrEmpty(FormatDefinitionFileBox.Text) || (String.IsNullOrEmpty(SourceFileBox.Text)) || (String.IsNullOrEmpty(DISAccessDatabaseBox.Text)))
                {
                    MessageBox.Show("Please select the required files", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                bool isValid = XPathValidation.Validate(FormatDefinitionFileBox.Text);
                if (isValid == false)
                {
                    MessageBox.Show("The Format Definition File contains errors. Please provide a correct file", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                if (Execute.Text == "Execute")
                {
                    DateTime time = DateTime.Now;
                    string sCurDir = Directory.GetCurrentDirectory();
                    this.BeginInvoke(new MethodInvoker(delegate()
                    {
                        this.ProcessLog.Text = this.ProcessLog.Text + " \n Application started at: " + time.ToString();
                    }));
                    Execute.Text = "Stop Processing";
                    progressBar1.Value = 0;
                    button1.Enabled = false;
                    button2.Enabled = false;
                    button3.Enabled = false;
                    button5.Enabled = false;
                    Save.Enabled = false;
                    Halt_Processing.Enabled = false;
                    FormatDefinitionFileBox.Enabled = false;
                    SourceFileBox.Enabled = false;
                    DISAccessDatabaseBox.Enabled = false;
                    if (backgroundWorker1.IsBusy != true)
                    {
                        // Start the asynchronous operation.
                        backgroundWorker1.RunWorkerAsync();
                    }
                }
                else if (Execute.Text == "Stop Processing")
                {
                    if (backgroundWorker1.WorkerSupportsCancellation == true)
                    {
                        // Cancel the asynchronous operation.
                        backgroundWorker1.CancelAsync();
                        //backgroundWorker1.Dispose();
                    }
                    Execute.Text = "Execute";
                }
            
           
      }
        // This event handler is where the time-consuming work is done.
        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;
            //CommandLineProcessing cmdProcess = new CommandLineProcessing();
                if (worker.CancellationPending == true)
                {
                    e.Cancel = true;
                    return;
                }
                else
                {
                    //ReadFile read_import_file = new ReadFile();
                    try
                    {
                        //ReadXML read = new ReadXML();
                        int b;
                        DataSet XMLDataset = ReadXMLFile(FormatDefinitionFileBox.Text, 0, out b);
                        if (b !=1)
                        {
                        //LoadTables load = new LoadTables();
                        int a;
                        DataSet target = LoadAccessTables(XMLDataset, DISAccessDatabaseBox.Text, 0, out a);
                        if (a != 1)
                        {
                            int rows = ReadTextFile(SourceFileBox.Text, DISAccessDatabaseBox.Text, XMLDataset, target, 0);
                            if (rows == -1)
                            {
                                //cmdProcess.//sw.WriteLine"Processing Halted. Please check the process log ");
                                this.BeginInvoke(new MethodInvoker(delegate()
                                    {
                                        this.ProcessLog.Text = this.ProcessLog.Text + "\nProcessing Halted. Please check the process log ";
                                    }));
                                //cmdProcess.//sw.WriteLine"User exited application at: " + DateTime.Now.ToString());
                                this.BeginInvoke(new MethodInvoker(delegate()
                                    {
                                        this.ProcessLog.Text = this.ProcessLog.Text + "\n User exited application at: " + DateTime.Now.ToString();
                                    }));
                            }
                            else
                            {
                                ////cmdProcess.//sw.WriteLine"Processing Completed. Records added to Access DB: " + rows);
                                //if (Count > 0)
                                //{
                                //    this.BeginInvoke(new MethodInvoker(delegate()
                                //    {
                                //        this.ProcessLog.Text = this.ProcessLog.Text + "\n Data truncated as it exceeded the maximum size allowed. Total Number of Data Truncated: " + Count;
                                //    }));
                                //}    
                                this.BeginInvoke(new MethodInvoker(delegate()
                                   {
                                       this.ProcessLog.Text = this.ProcessLog.Text + "\n Processing Completed. Records added to Access DB: " + rows;
                                   }));
                                    ////cmdProcess.//sw.WriteLine"User exited application at: " + DateTime.Now.ToString());
                                    this.BeginInvoke(new MethodInvoker(delegate()
                                   {
                                       this.ProcessLog.Text = this.ProcessLog.Text + "\n User exited application at: " + DateTime.Now.ToString();
                                   }));
                                 
                                //progressBar1.Value = 0;
                            }
                            string sFilename = Convert.ToString(Path.GetDirectoryName(Application.ExecutablePath) + "\\DISConversion_Log.txt");
                            try
                            {

                                if (!File.Exists(sFilename))
                                {
                                    FileStream fs = new FileStream(sFilename, FileMode.Create);
                                    fs.Close();
                                }
                                //System.Diagnostics.Process.Start("notepad.exe", sFilename);
                                this.BeginInvoke(new MethodInvoker(delegate()
                                    {
                                        File.WriteAllLines(sFilename, this.ProcessLog.Lines);
                                    }));
                            }
                            catch (Exception)
                            {
                                MessageBox.Show("Error Occured while opening the file", "Synchronize Conversion tool", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            }
                         }
                       }
                    }
                    catch (Exception ex)
                    {
                        //cmdProcess.//sw.WriteLine"Processing Halted.\nPlease check if all the selected files are valid");
                        this.BeginInvoke(new MethodInvoker(delegate()
                               {
                                   this.ProcessLog.Text = this.ProcessLog.Text + "\n Processing Halted.\nPlease check if all the selected files are valid";
                               }));
                    }
                    finally
                    {
                        
                        //Execute.Text = "Execute";
                    }

                }
        }
        // This event handler updates the progress.
        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {

            // Change the value of the ProgressBar to the BackgroundWorker progress.
            if (progressBar1.Value >= 100)
            {
                progressBar1.Value = 0;
                return;
            }
            this.Cursor = Cursors.WaitCursor;
            progressBar1.Value = e.ProgressPercentage;
            //progressBar1.Value  += 10;
        }
        
        // This event handler deals with the results of the background operation.
        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            progressBar1.Value = 100;
            button1.Enabled = true;
            button2.Enabled = true;
            button3.Enabled = true;
            button5.Enabled = true;
            Save.Enabled = true;
            Halt_Processing.Enabled = true;
            FormatDefinitionFileBox.Enabled = true;
            SourceFileBox.Enabled = true;
            DISAccessDatabaseBox.Enabled = true;
            this.Cursor = Cursors.Default;
            if (e.Cancelled == true)
            {
                //resultLabel.Text = "Canceled!";
            }
            else if (e.Error != null)
            {
                //resultLabel.Text = "Error: " + e.Error.Message;
            }
            else
            {
                //resultLabel.Text = "Completed!";
                Execute.Text = "Execute";
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
                this.BeginInvoke(new MethodInvoker(delegate()
                  {
                      this.ProcessLog.Text = this.ProcessLog.Text + "\n Invalid data File Path. Please correct and try again";
                  }));
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
                this.BeginInvoke(new MethodInvoker(delegate()
                 {
                     this.ProcessLog.Text = this.ProcessLog.Text + "\n Data file processing in progress...";
                 }));
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
                                int start_position = Convert.ToInt32(row1["Start"])-1;
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
                                    this.BeginInvoke(new MethodInvoker(delegate()
                               {
                                   this.ProcessLog.Text = this.ProcessLog.Text + "\n Target value could not be read for " + target_table + "." + target_column + ". Record position in source data file: " + source_file_position_new + ". Please check the validity of selected files";

                               }));
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
                                    this.BeginInvoke(new MethodInvoker(delegate()
                               {
                                   this.ProcessLog.Text = this.ProcessLog.Text + "\n Error occured while reading from " + target_table + "." + target_column + ". Please check the validity of selected files";
                               }));
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
                                            //Count++;
                                            if( sColNames.Length == 0 || sColNames.IndexOf("|"+target_column+"|") == -1)
                                            {
                                                this.BeginInvoke(new MethodInvoker(delegate()
                                                {
                                                    this.ProcessLog.Text = this.ProcessLog.Text + "\n'" + target_column + "' in " + target_table + " table has improper length." + " Data may be truncated.";
                                                }));
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
                                    case "System.Double": conversion_type = "Double";
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
                                            else if (conversion_type == "Double")
                                            { newRow[target_column] = Convert.ToDouble(target_value); }
                                        }
                                        catch (Exception e)
                                        {
                                            if (Halt_Processing.Checked)
                                            {
                                                this.BeginInvoke(new MethodInvoker(delegate()
                                                   {
                                                     this.ProcessLog.Text = this.ProcessLog.Text + "\n'" + target_value + "' failed to convert to required data type for " + target_table_xml + "." + target_column + ". Record position in source data file: " + source_file_position_new;
                                                    }));
                                                return -1;
                                            }
                                            else
                                            {
                                                newRow[target_column] = System.DBNull.Value;
                                                this.BeginInvoke(new MethodInvoker(delegate()
                                                    {
                                                        this.ProcessLog.Text = this.ProcessLog.Text + "\n'" + target_value + "' failed to convert to required data type for " + target_table_xml + "." + target_column + ". Record position in source data file: " + source_file_position_new + ". NULL value inserted";
                                                    }));
                                            }

                                        } // place null in column or stop execution based on Halt Processing option
                                    }
                                }

                            }
                            target.Tables[target_table_xml].Rows.Add(newRow); // add the populated row to target table
                        }
                        if (line_count % 1000 == 0)
                        {
                            string Count = line_count.ToString();
                                this.BeginInvoke(new MethodInvoker(delegate()
                                    {
                                    //this.ProcessLog.Text = this.ProcessLog.Text +  "\n LineCount:" +line_count ;
                                    this.ProcessLog.Text = this.ProcessLog.Text + "\n Records added to Access DB: " + Count + "/" + total_records;
                                }));
                            }
                       // }
                        int percentage = (Int32)((line_count * 100) / total_records);
                        if (percentage <= 100)
                        {
                            backgroundWorker1.ReportProgress(percentage);
                        }
                        if (backgroundWorker1.CancellationPending == true)
                        {
                            //e.Cancel = true;
                            this.BeginInvoke(new MethodInvoker(delegate()
                            {
                                this.ProcessLog.Text = this.ProcessLog.Text + "\n User selected to Stop Processing";
                            }));
                            return -1;
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
                if (backgroundWorker1.CancellationPending == true)
                {
                   // e.Cancel = true;
                    this.BeginInvoke(new MethodInvoker(delegate()
                    {
                        this.ProcessLog.Text = this.ProcessLog.Text + "\n User selected to Stop Processing";
                    }));
                    return -1;
                }
                try
                {
                    adapter.Update(target, target_table_xml);
                }
                catch (Exception e)
                {
                    this.BeginInvoke(new MethodInvoker(delegate()
                        {
                            this.ProcessLog.Text = this.ProcessLog.Text + "\nDatabase Upload Error (" + e.Message + ") Please check your target database and try again";
                        }));
                    return -1;
                }
                adapter.Dispose();
                if (backgroundWorker1.CancellationPending == true)
                {
                    //e.Cancel = true;
                    //DataSet target1;          
                    DataTable dt = ds.Tables["Table"];
                    OleDbDataAdapter adapter1;
                    foreach (DataRow row1 in dt.Rows)
                    {
                        DataSet target1 = new DataSet();
                        string target_table = Convert.ToString(row1["Table_Text"]);
                        if (conn.State == ConnectionState.Closed)
                        {
                            conn.Open();
                        }
                        string queryString1 = "select * from " + target_table;
                        adapter1 = new OleDbDataAdapter(queryString1, conn);
                        adapter1.MissingSchemaAction = MissingSchemaAction.Add;
                        target1.Tables.Add(target_table);
                        try
                        {
                            adapter1.Fill(target1, target_table);
                        }
                        catch (Exception e)
                        {
                            return -1;
                        }
                        if (target1.Tables[target_table].Rows.Count != 0)
                        {
                            for (int j = 0; j < target1.Tables[target_table].Rows.Count; j++)
                            {
                                target1.Tables[target_table].Rows[j].Delete();
                            }
                            OleDbCommandBuilder builder1 = new OleDbCommandBuilder(adapter1);
                            adapter1.UpdateCommand = builder1.GetUpdateCommand();
                            adapter1.Update(target1, target_table);
                        }
                    }
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                    return -1;
                }
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
            backgroundWorker1.ReportProgress(100);
            return line_count;
        } // method

        public DataSet LoadAccessTables(DataSet ds, string AccessPath, int iCommandLine, out int a)
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
                ////sw.WriteLine"Invalid Access File Path. Please correct and try again. Processing Halted");
                this.BeginInvoke(new MethodInvoker(delegate()
                    {
                        this.ProcessLog.Text = this.ProcessLog.Text + "\n Invalid Access File Path. Please correct and try again. Processing Halted";
                    }));
                a = 1;
                return target;
            }
            //DataTable dt = ds.Tables[2];
            DataTable dt = ds.Tables["Table"];
            OleDbDataAdapter adapter;
             if (dt != null)
            {
                DialogResult result1 = DialogResult.No;
                string msg1 = "Select Yes to empty the associated tables.\nSelect No to halt the conversion process. Please verify the data in DIS Access database and take a backup of the file if required.";
                result1 = MessageBox.Show(msg1, "Clear Target Tables?", MessageBoxButtons.YesNo);
                if (result1 == DialogResult.Yes)
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
                            this.BeginInvoke(new MethodInvoker(delegate()
                                {
                                    this.ProcessLog.Text = this.ProcessLog.Text + "\n Error occured while reading data from Access DB for target table: " + target_table + ". Please check the validity of selected files. \nProcessing Halted.";
                                }));
                            a = 1;
                            return target;
                        }
                        if (target.Tables[target_table].Rows.Count != 0)
                        {
                                this.BeginInvoke(new MethodInvoker(delegate()
                                {
                                    this.ProcessLog.Text += "\n Clearing records from " + target_table + " Table ...";
                                }));
                            for (int j = 0; j < target.Tables[target_table].Rows.Count; j++)
                            {
                                backgroundWorker1.ReportProgress(100);
                                target.Tables[target_table].Rows[j].Delete();
                            }
                            OleDbCommandBuilder builder = new OleDbCommandBuilder(adapter);
                            adapter.UpdateCommand = builder.GetUpdateCommand();
                            adapter.Update(target, target_table);

                        }
                        else if (target.Tables[target_table].Rows.Count == 0)
                        {
                                this.BeginInvoke(new MethodInvoker(delegate()
                                {
                                    this.ProcessLog.Text = this.ProcessLog.Text + "\n Target Table " + target_table + " is empty.";
                                }));
                        }
                        adapter.FillSchema(target, SchemaType.Source, target_table);
                        adapter.Dispose();
                        if (backgroundWorker1.CancellationPending == true)
                        {
                            //e.Cancel = true;
                            this.BeginInvoke(new MethodInvoker(delegate()
                           {
                               this.ProcessLog.Text = this.ProcessLog.Text + "\n User selected to Stop Processing";
                           }));
                            this.BeginInvoke(new MethodInvoker(delegate()
                            {
                                this.ProcessLog.Text = this.ProcessLog.Text + "\n User exited application at: " + DateTime.Now.ToString();
                            }));
                            a = 1;
                            return target;
                        }                
                    }
                }
                else if (result1 == DialogResult.No)
                {
                    this.BeginInvoke(new MethodInvoker(delegate()
                        {
                            this.ProcessLog.Text = this.ProcessLog.Text + "\n Processing Halted - please verify/backup the DIS Access database.  Select Execute to continue the conversion process";
                        }));
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
                this.BeginInvoke(new MethodInvoker(delegate()
                    {
                        this.ProcessLog.Text = this.ProcessLog.Text + "\n Invalid Format Definition File Path. Please correct and try again. Processing Halted";
                    }));
                b = 1;
                return ds;
            }
            b = 0;
            return ds;
        }
        protected override void OnFormClosing(FormClosingEventArgs e)
          {
	          base.OnFormClosing(e);
	         if (e.CloseReason == CloseReason.WindowsShutDown) return;       
	          //Confirm user wants to close 
	         switch (MessageBox.Show(this, "Are you sure you want to Exit?", "Exit", MessageBoxButtons.YesNo)) 
	             {   
	               case DialogResult.No: 
	               e.Cancel = true; 
	               break;  
	               default:         break;  
	             }      
          }

        

    }
}
