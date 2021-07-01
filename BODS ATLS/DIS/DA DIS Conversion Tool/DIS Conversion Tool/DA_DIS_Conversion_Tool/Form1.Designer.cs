namespace DA_DIS_Conversion_Tool
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        /// 
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.FormatDefinitionFileBox = new System.Windows.Forms.TextBox();
            this.SourceFileBox = new System.Windows.Forms.TextBox();
            this.DISAccessDatabaseBox = new System.Windows.Forms.TextBox();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.Execute = new System.Windows.Forms.Button();
            this.Halt_Processing = new System.Windows.Forms.CheckBox();
            this.button5 = new System.Windows.Forms.Button();
            this.Save = new System.Windows.Forms.Button();
            this.pageSetupDialog1 = new System.Windows.Forms.PageSetupDialog();
            this.pageSetupDialog2 = new System.Windows.Forms.PageSetupDialog();
            this.ProcessLog = new System.Windows.Forms.RichTextBox();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.progressBar1 = new System.Windows.Forms.ProgressBar();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(11, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(105, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Format Definition File";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(429, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 1;
            this.button1.Text = "Browse";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // FormatDefinitionFileBox
            // 
            this.FormatDefinitionFileBox.Location = new System.Drawing.Point(129, 13);
            this.FormatDefinitionFileBox.Name = "FormatDefinitionFileBox";
            this.FormatDefinitionFileBox.Size = new System.Drawing.Size(285, 20);
            this.FormatDefinitionFileBox.TabIndex = 2;
            // 
            // SourceFileBox
            // 
            this.SourceFileBox.Location = new System.Drawing.Point(129, 39);
            this.SourceFileBox.Name = "SourceFileBox";
            this.SourceFileBox.Size = new System.Drawing.Size(285, 20);
            this.SourceFileBox.TabIndex = 3;
            // 
            // DISAccessDatabaseBox
            // 
            this.DISAccessDatabaseBox.Location = new System.Drawing.Point(129, 65);
            this.DISAccessDatabaseBox.Name = "DISAccessDatabaseBox";
            this.DISAccessDatabaseBox.Size = new System.Drawing.Size(285, 20);
            this.DISAccessDatabaseBox.TabIndex = 4;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(429, 38);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 5;
            this.button2.Text = "Browse";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(429, 64);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 6;
            this.button3.Text = "Browse";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(11, 41);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Data File";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 69);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(112, 13);
            this.label3.TabIndex = 8;
            this.label3.Text = "DIS Access Database";
            // 
            // Execute
            // 
            this.Execute.Location = new System.Drawing.Point(519, 11);
            this.Execute.Name = "Execute";
            this.Execute.Size = new System.Drawing.Size(77, 78);
            this.Execute.TabIndex = 9;
            this.Execute.Text = "Execute";
            this.Execute.UseVisualStyleBackColor = true;
            this.Execute.Click += new System.EventHandler(this.Execute_Click);
            // 
            // Halt_Processing
            // 
            this.Halt_Processing.AutoSize = true;
            this.Halt_Processing.Location = new System.Drawing.Point(12, 255);
            this.Halt_Processing.Name = "Halt_Processing";
            this.Halt_Processing.Size = new System.Drawing.Size(227, 17);
            this.Halt_Processing.TabIndex = 10;
            this.Halt_Processing.Text = "Halt Processing on Data Conversion Errors";
            this.Halt_Processing.UseVisualStyleBackColor = true;
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(430, 252);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(53, 25);
            this.button5.TabIndex = 11;
            this.button5.Text = "Clear";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // Save
            // 
            this.Save.Location = new System.Drawing.Point(489, 252);
            this.Save.Name = "Save";
            this.Save.Size = new System.Drawing.Size(109, 25);
            this.Save.TabIndex = 12;
            this.Save.Text = "View Log";
            this.Save.UseVisualStyleBackColor = true;
            this.Save.Click += new System.EventHandler(this.Save_Click);
            // 
            // ProcessLog
            // 
            this.ProcessLog.Location = new System.Drawing.Point(15, 96);
            this.ProcessLog.Name = "ProcessLog";
            this.ProcessLog.ReadOnly = true;
            this.ProcessLog.Size = new System.Drawing.Size(583, 146);
            this.ProcessLog.TabIndex = 13;
            this.ProcessLog.Text = "";
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.WorkerReportsProgress = true;
            this.backgroundWorker1.WorkerSupportsCancellation = true;
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.backgroundWorker1_ProgressChanged);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // progressBar1
            // 
            this.progressBar1.Location = new System.Drawing.Point(245, 252);
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Size = new System.Drawing.Size(170, 25);
            this.progressBar1.TabIndex = 16;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(612, 285);
            this.Controls.Add(this.progressBar1);
            this.Controls.Add(this.Save);
            this.Controls.Add(this.button5);
            this.Controls.Add(this.Halt_Processing);
            this.Controls.Add(this.ProcessLog);
            this.Controls.Add(this.Execute);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.DISAccessDatabaseBox);
            this.Controls.Add(this.SourceFileBox);
            this.Controls.Add(this.FormatDefinitionFileBox);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "DA DIS Conversion Tool";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox FormatDefinitionFileBox;
        private System.Windows.Forms.TextBox SourceFileBox;
        private System.Windows.Forms.TextBox DISAccessDatabaseBox;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button Execute;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Button Save;
        private System.Windows.Forms.PageSetupDialog pageSetupDialog1;
        private System.Windows.Forms.PageSetupDialog pageSetupDialog2;
        public System.Windows.Forms.CheckBox Halt_Processing;
        public System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.ProgressBar progressBar1;
        public System.Windows.Forms.RichTextBox ProcessLog;
    }
}

