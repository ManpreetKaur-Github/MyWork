using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DA_DIS_Conversion_Tool;
using System.Windows.Forms;
using System.Collections;

namespace DA_DIS_Conversion_Tool
{
    class Log
    {
        delegate void WriteLog1(string message);
        public static Form1 GetMainForm()
        {
            foreach (Form form in Application.OpenForms)
                if (form is Form1)
                    return (Form1)form;
            return null;
        }
        public static void WriteLog(string message)
        {            
            Form1 frm = GetMainForm();
            if (frm == null)
            {
                //Application.Run(new Form1());
            }
            if (frm.ProcessLog.InvokeRequired)
            {
                WriteLog1 d = new WriteLog1(WriteLog);
                frm.Invoke(d, new object[] { message });
            }
            else
            {
                frm.ProcessLog.Text = frm.ProcessLog.Text + message + "\n";
            }
            
            }
           
            
}
    }

