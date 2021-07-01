using System;

using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Security.Permissions;
using rmx.DA2.At;

[assembly: CLSCompliant(true)]
[assembly: SecurityPermission(
   SecurityAction.RequestMinimum, Execution = true)]

namespace rmx.DA2.At

{
    [CLSCompliant(true)]

    public class ATCore
    {
        private string uniqueId;
        private bool _isSuccess;

        private DateTime currentDateTime;
        private ATLog objATLog;
        private ATJob objATJob;
        private ATDB objATDB;
        private ATTemplate objATTemplate;
       
        public ATCore()
        {

            generateUid();

            objATJob = new ATJob(uniqueId);
            objATLog = new ATLog();        
            objATDB = new ATDB();
            objATTemplate = new ATTemplate();
    

        }

        public void setRmxTableInfo(string tableName, string friendlyTableName, string primaryFieldKey, string matchingField, string databaseOwner)
        {
            objATJob.setRmxTableInfo(tableName, friendlyTableName, primaryFieldKey, matchingField, databaseOwner);
        }

        public void setLogInfo(bool debugOnConsole, bool debugInLogFile, string logDir)
        {

            
            objATLog.setConfig(uniqueId, debugOnConsole, debugInLogFile, logDir);
            objATLog.writeDebug("Job generation Id: " + uniqueId);

            // Set the Log object
            objATJob.setLog(objATLog);
            objATDB.setLog(objATLog);
            objATTemplate.setLog(objATLog);

        }

        public void setJobInfo(string jobDirectory, string jobFileNamePrefix)
        {
            objATJob.setJobFileInfo(jobDirectory, jobFileNamePrefix);        
        }

        public void setTemplateInfo(string templateDirectory, string templateFileName)
        {           
            objATTemplate.setTemplateFileInfo(templateDirectory, templateFileName);
        }

        public void setRmxDbConfig(string rmxConnection)
        {

            objATDB.setRmxDBConfig(rmxConnection);
            objATJob.setDB(objATDB);
        }

        public bool generateJob()

        {

            try
            {
                objATJob.setTemplate(objATTemplate.getXMLTemplate());
                _isSuccess = objATJob.genXMLJob();
                return _isSuccess;
            }
            catch (Exception e)
            {
                objATLog.displayError(e);
                return false; 
            }

        
        }

        private void generateUid()
        {         

            currentDateTime = DateTime.Now;
            uniqueId = currentDateTime.Year + "_" + currentDateTime.Month + "_" + currentDateTime.Day + "_";
            uniqueId += currentDateTime.Hour + "_" + currentDateTime.Minute + "_" + currentDateTime.Second + "_" + currentDateTime.Millisecond;

        }


    }
}
