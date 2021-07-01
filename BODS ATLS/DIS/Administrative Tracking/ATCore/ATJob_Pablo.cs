using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using rmx.DA2.At;
using System.Configuration;
using System.IO;



namespace rmx.DA2.At
{
    [CLSCompliant(true)]
    public class ATJob
    {
           // Private fields
        private string _tableName;
        private string _friendlyTableName;
        private string _primaryFieldKey;
        private string _matchingField;
        

        // Following private arrays represent the Internal Data Definition Structure
        private ArrayList _fieldName; // Position 0 of _masterArrayList
        private ArrayList _fieldDesc; // Position 1 of _masterArrayList
        private ArrayList _fieldType; // Position 2 of _masterArrayList
        private ArrayList _fieldSize; // Position 3 of _masterArrayList
        private ArrayList _fieldPattern; // Position 4 of _masterArrayList
        private ArrayList _fieldSystemTable;// Position 5 of _masterArrayList
        private ArrayList[] _masterArrayList;

        // Private constants
        private const int TypeString = 0;
        private const int TypeInt = 1;
        private const int TypeFloat = 2;
        private const int TypeDate = 3;
        private const int TypeTime = 4;
        private const int TypeLongString = 5;
        private const int TypeCodes = 6;
        private const int TypeIntId = 7;
        private const int TypeEntities = 8;
        private const int TypeStates = 9;

        private const int _GlossaryTypeCode = 468;
        private const int _GlossaryTextLanguageCode = 1033;    
      
        
        private ATLog objATLog;      
        private ATDB objATDB;
        private string[] newJob;
        private string uniqueId;
        private StreamWriter jobFile;
        private string jobFileName;
        private string jobDirectory;
        private string jobFileNamePrefix;
        private string jobFileFullPath;

        public ATJob(string uniqueId)
        {
            this.uniqueId = uniqueId;        
        }


        public void setRmxTableInfo(string tableName, string friendlyTableName, string primaryFieldKey, string matchingField)
        {
            this._tableName = tableName;
            this._friendlyTableName = friendlyTableName;
            this._primaryFieldKey = primaryFieldKey;
            this._matchingField = matchingField;
            
        }


        public void setJobFileInfo (string jobDirectory,string jobFileNamePrefix)
        {
            this.jobFileNamePrefix = jobFileNamePrefix.Replace(" ", "").Trim();;
            this.jobDirectory = jobDirectory.Replace(" ", "").Trim();
        }

        public void setTemplate(string[] template)
        {
            newJob = template;
        }

        public void setLog(ATLog obj)
        {
            objATLog = obj;                      
        }

        public void setDB(ATDB obj)
        {
            objATDB = obj;
            
        }

        public bool genXMLJob()
        {

     
            objATLog.writeDebug("ATJob - genXMLJob: starting...");

            objATLog.writeDebug("ATJob - genXMLJob: restoring data definition from RMX database...");
            restoreDataDefinitionFromDB();

            objATLog.writeDebug("ATJob - genXMLJob: customizing XML Job...");
            customizeXml();

            objATLog.writeDebug("ATJob - genXMLJob: saving Job...");
            saveJob();

            return true;
        
          
        }

        private void saveJob() 
         
         {

            try {

                    jobFileName = jobFileNamePrefix + "_" + _tableName.ToUpper(new System.Globalization.CultureInfo("en-US")) + "_" + uniqueId + ".xml";
                    jobFileFullPath = jobDirectory + "\\" + jobFileName;        

                    objATLog.writeDebug("Job File Path: " + jobFileFullPath);
                   
                    if (!Directory.Exists(jobDirectory))
                    { Directory.CreateDirectory(jobDirectory); }

                    jobFile = new StreamWriter(jobFileFullPath);

                    for (int i = 0; i < newJob.Length;i++)
                    {
                        jobFile.WriteLine(newJob[i]);
                    }

                    jobFile.Close();
            }

            catch (Exception e) {

                objATLog.writeDebug("The job file could not be saved, check the file path and the given permissions.");
                throw e;
                
            }
             finally 
             {
                 
                 jobFile = null;
             }

        }

        private void restoreDataDefinitionFromDB()
        {

            _masterArrayList = objATDB.getRMXDataDefinition(_tableName);

            _fieldName = _masterArrayList[0];
            _fieldDesc = _masterArrayList[1];
            _fieldType = _masterArrayList[2];
            _fieldSize = _masterArrayList[3];
            _fieldPattern  = _masterArrayList[4];
            _fieldSystemTable = _masterArrayList[5];


        }

        private void customizeXml()
        {

           

        }

    }



}
