using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Configuration;


namespace rmx.DA2.At
{
    [CLSCompliant(true)]
    public class ATTemplate
    {
        private string[] jobTemplate;
        private string templatePath;
        private ATLog objATLog;

        public ATTemplate() { }

        public void setTemplateFileInfo(string templateDirectory, string templateFileName)
        {        
            templatePath = templateDirectory.Replace(" ", "").Trim() + "\\" + templateFileName.Replace(" ", "").Trim();
        }
        
        public void setLog(ATLog obj)
        {

            objATLog = obj;

        }

        public string[] getXMLTemplate()

        {
            try
            {
                
               
                objATLog.writeDebug("Path Template: " + templatePath);

                jobTemplate = File.ReadAllLines(templatePath);
                objATLog.writeDebug("The template was loaded sucessfully.");

                return jobTemplate;
            }

            catch (Exception e)
            {
                objATLog.writeDebug("The template could not be loaded, check the file path and the given permissions.");
                throw e;
            }
          
        }
                
    }
}
