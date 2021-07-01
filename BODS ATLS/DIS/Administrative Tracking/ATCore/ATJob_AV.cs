using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using rmx.da2.at;
using System.Configuration;
using System.IO;

namespace rmx.da2.at
{
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
        private ArrayList _fieldSystemTable; // Position 5 of _masterArrayList
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

        private const string TagPrimaryKey = "BOND_ABS_ID";
        private const string TagGeneric = "BOND_ABS";
        private const string TagTableStaging = "GenTableStaging";                                                
        private const string TagTableRMX = "GenTableRMX";
        private const string TagTableMDB = "GenTableMDB";
        private const string TagGenDFRead_QReadAT_Schema = "GenDFRead_QReadAT_schema";
        private const string TagGenDFRead_QReadAT_select = "GenDFRead_QReadAT_select";
        private const string TagGenDFRead_QAT_schema = "GenDFRead_QAT_schema";
        private const string TagGenDFRead_QAT_select = "GenDFRead_QAT_select";
        private const string TagGenDFValidate_QAlwaysAdd_schema = "GenDFValidate_QAlwaysAdd_schema";        
        private const string TagReplaceDfDisValidateSelect = "ReplaceDfDisValidateSelect";
        private const string TagGenDFValidate_QAddUpdate_schema = "GenDFValidate_QAddUpdate_schema";
        private const string TagGenDFValidate_QAddUpdate_select = "GenDFValidate_QAddUpdate_select";
        private const string TagGenDFImport_QJobValidRecords_schema = "GenDFImport_QJobValidRecords_schema";
        private const string TagGenDFImport_QJobValidRecords_select = "GenDFImport_QJobValidRecords_select";
        private const string TagGenDFImport_QInsertRows_schema = "GenDFImport_QInsertRows_schema";
        private const string TagGenDFImport_QInsertRows_select = "GenDFImport_QInsertRows_select";
        private const string TagGenDFImport_QUpdateRows_schema = "GenDFImport_QUpdateRows_schema";
        private const string TagGenDFImport_QUpdateRows_select = "GenDFImport_QUpdateRows_select";
        private const string TagGenDFImport_QAssignId_schema = "GenDFImport_QAssignId_schema";
        private const string TagGenDFImport_QAssignId_select = "GenDFImport_QAssignId_select";
             
        private int[] _tagIndex = new int[21];
        private string[] _tagDescription = new string[21];     
        private string[] _fieldCodeDesc = new string[16] { "varchar", "int", "double", "Datetime", "Timetime", "varchar", "varchar", "int", "varchar", "varchar", "varchar", "varchar", "varchar", "varchar", "varchar", "varchar" };

        private ATTemplate objATTemplate;
        private ATLog objATLog;      
        private ATDB objATDB;
        private string[] newJob;
        private string uniqueId;
        private StreamWriter jobFile;
        private string jobFileName;
        private string jobDirectory = "jobs";
        private string jobFileNamePrefix = "J_DIS_AT";
        private string jobFileFullPath;
        private string newLinePattern;

        

        public void setJobFileInfo (string jobDirectory,string jobFileNamePrefix)
        {
            this.jobFileNamePrefix = jobFileNamePrefix.Replace(" ", "").Trim();;
            this.jobDirectory = jobDirectory.Replace(" ", "").Trim();


        }

        public void setTemplateFileInfo(string templateDirectory,string templateFileName)
        {
            objATTemplate.setTemplateFileInfo(templateDirectory, templateFileName);
        }


        public ATJob(string uniqueId, string tableName, string friendlyTableName, string primaryFieldKey, string matchingField){

            this._tableName = tableName;
            this._friendlyTableName = friendlyTableName;
            this._primaryFieldKey = primaryFieldKey;
            this._matchingField = matchingField;
            this.uniqueId = uniqueId;
            
            objATTemplate = new ATTemplate();
            
            
        }

        public void setLog(ATLog obj)
        {
            objATLog = obj;

            objATLog.writeDebug("ATLog object loaded in ATJob class.");
            
            objATTemplate.setLog(obj);

            
        }

        public void setDB(ATDB obj)
        {
            objATDB = obj;

            objATLog.writeDebug("ATDB object loaded in ATJob class.");

        }

        public bool GenXMLJob()
        {

            try
            {
                newJob = objATTemplate.getXMLTemplate();
                restoreDataDefinitionFromDB();
                customizeXml();
                saveJob();

                return true;
            }
            catch (Exception e)
            {

                throw e;
                
            }
            finally
            {
                objATDB = null;
                objATTemplate = null;

            }
        }

        
        private void saveJob() 
         
         {

            try {

                
                jobFileName = jobFileNamePrefix + "_" + _tableName.ToUpper() + "_" + uniqueId + ".xml";
                jobFileFullPath = Directory.GetCurrentDirectory() + "\\" + jobDirectory + "\\" + jobFileName;

                objATLog.writeDebug("Job File Path: " + jobFileFullPath);


                jobDirectory = Directory.GetCurrentDirectory() +  "\\" + jobDirectory;

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


            /* Show all elements of an ArrayList
            for (int i = 0; i < _fieldName.Count;i++ )
            { objATLog.writeDebug("fieldName: " + _fieldName[i].ToString()); }
            */


        }

        private void customizeXml()
        {

            // Customize XML here
            indexTag();
            objATLog.writeDebug("indexTag");
            ReplacePrimaryKeyTags();
            objATLog.writeDebug("ReplacePrimaryKeyTags");
            ReplaceGenericTags();
            objATLog.writeDebug("ReplaceGenericTags");
            GenTableStaging();
            objATLog.writeDebug("GenTableStaging");
            GenTableRMX();
            objATLog.writeDebug("GenTableRMX");
            GenTableMDB();
            objATLog.writeDebug("GenTableMDB");
            GenDFRead_QReadAT_schema();
            objATLog.writeDebug("GenDFRead_QReadAT_schema");
            GenDFRead_QReadAT_select();
            objATLog.writeDebug("GenDFRead_QReadAT_select");
            GenDFRead_QAT_schema();
            objATLog.writeDebug("GenDFRead_QAT_schema");
            GenDFRead_QAT_select();
            objATLog.writeDebug("GenDFRead_QAT_select");
            GenDFValidate_QAlwaysAdd_schema();
            objATLog.writeDebug("GenDFValidate_QAlwaysAdd_schema");
            GenDFValidate_QAlwaysAdd_select();
            objATLog.writeDebug("GenDFValidate_QAlwaysAdd_select");
            GenDFValidate_QAddUpdate_schema();
            objATLog.writeDebug("GenDFValidate_QAddUpdate_schema");
            GenDFValidate_QAddUpdate_select();
            objATLog.writeDebug("GenDFValidate_QAddUpdate_select");
            GenDFImport_QJobValidRecords_schema();
            objATLog.writeDebug("GenDFImport_QJobValidRecords_schema");
            GenDFImport_QJobValidRecords_select();
            objATLog.writeDebug("GenDFImport_QJobValidRecords_select");
            GenDFImport_QInsertRows_schema();
            objATLog.writeDebug("GenDFImport_QInsertRows_schema");
            GenDFImport_QInsertRows_select();
            objATLog.writeDebug("GenDFImport_QInsertRows_select");
            GenDFImport_QUpdateRows_schema();
            objATLog.writeDebug("GenDFImport_QUpdateRows_schema");
            GenDFImport_QUpdateRows_select();
            objATLog.writeDebug("GenDFImport_QUpdateRows_select");
            GenDFImport_QAssignId_schema();
            objATLog.writeDebug("GenDFImport_QAssignId_schema");
            GenDFImport_QAssignId_select();
            objATLog.writeDebug("GenDFImport_QAssignId_select");

        }

        private void indexTag()
        {
            int i = 0; 
            for (int index = 0; index < newJob.Length; index++)
            {
                
                if (newJob[index].Contains("WILDCARD"))
                {
                    _tagIndex[i] = index;
                    _tagDescription[i] = newJob[index];
                    ++i;
                }
            }            
        }

        private void ReplaceSimpleText(string searchedString, string content)
        {
            for (int index = 0; index < _tagDescription.Length ; index++)
            {
                if (_tagDescription[index].Contains(searchedString))
                {
                   newJob[_tagIndex[index]] = content;                   
                   break;
                }

            }

        }

        private void ReplacePrimaryKeyTags()
        {
            for (int index = 0; index < newJob.Length; index++)
            {
                if (newJob[index].Contains(TagPrimaryKey))
                {
                    newJob[index] = newJob[index].Replace(TagPrimaryKey, _primaryFieldKey);
                }
            }
        }

        private void ReplaceGenericTags()
        {
            for (int index = 0; index < newJob.Length; index++)
            {
                if (newJob[index].Contains(TagGeneric))
                {
                    newJob[index] = newJob[index].Replace(TagGeneric, _tableName );
                }
            }
        }

        private void GenTableStaging()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIColumn name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += "nullable=\"true\" > \n</DIColumn>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagTableStaging, newLinePattern);
           
        }

        private void GenTableRMX()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIColumn name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";                
                newLinePattern += "nullable=\"true\" > \n</DIColumn>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagTableRMX, newLinePattern);

        }

        private void GenTableMDB()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                {
                    // For Long String field type
                    newLinePattern += "<DIColumn name=\"" + _fieldName[index] + "\" ";
                    newLinePattern += "datatype=\"varchar\" " ;
                    newLinePattern += "size=\"8000\" " ;
                    newLinePattern += "nullable=\"true\" >\n";
                    newLinePattern += "<DIProperties>\n";
                    newLinePattern += "<DIAttribute name=\"Native Type\" value=\"LONGCHAR\"/>\n";
                    newLinePattern += "</DIProperties>\n";
                    newLinePattern += "</DIColumn>";
                }
                else
                {
                    newLinePattern += "<DIColumn name=\"" + _fieldName[index] + "\" ";
                    newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                    if (Convert.ToInt16(_fieldType[index]) == TypeString)
                        newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                    if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                        newLinePattern += "size=\"8000\" ";
                    newLinePattern += "nullable=\"true\" > \n</DIColumn>";                   
                }
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagTableMDB, newLinePattern);


        }

        private void GenDFRead_QReadAT_schema()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToInt16(_fieldType[index]) == TypeCodes)
                {
                    // For code field type
                    newLinePattern += "<DIElement name=\"lookup_ext\" hasNestedSchema=\"true\">\n";
                    newLinePattern += "<DINestedSchema type=\"RFCSchema\">\n";
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"INT\" >\n";
                    newLinePattern += "</DIElement>\n";
                    newLinePattern += "</DINestedSchema>\n";
                }
                else
                {
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                    newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                    if (Convert.ToInt16(_fieldType[index]) == TypeString)
                        newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                    if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                        newLinePattern += "size=\"8000\" ";
                    newLinePattern += "> \n";
                    newLinePattern += "<DIAttributes>\n";
                    newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"" + _tableName + "." + _fieldName[index] + "\" /> \n";
                    newLinePattern += "</DIAttributes> \n";
                    newLinePattern += "</DIElement>";
                }
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFRead_QReadAT_Schema, newLinePattern);


        }

        private void GenDFRead_QReadAT_select()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                // For fields belonging to CODE field type
                if (Convert.ToInt16(_fieldType[index]) == TypeCodes)
                {
                    // For code field type
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"__AL_LOOKUPEX_TRAN ";
                    newLinePattern += "lookup_ext([DS_RMX_STAGING.DBO.UNIQUE_CODE, 'PRE_LOAD_CACHE', 'MAX'], [ ";
                    newLinePattern += "CODE_ID ], [  NULL  ], [ JOBID, '=', $gJobID, CODE_TABLE_NAME, '=', ";
                    newLinePattern += "'" + _fieldSystemTable[index] + "', LINE_OF_BUS_CODE, '=', 0, SHORT_CODE, '=', ";
                    newLinePattern += _tableName + "." + _fieldName[index] + "]) &#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml ";
                    newLinePattern += "version=&quot;1.0&quot; encoding=&quot;UTF- ";
                    newLinePattern += "8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; ";
                    newLinePattern += "expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;', ";
                    newLinePattern += "&quot;run_as_separate_process&quot; = 'no')&#xA;\" > ";
                    newLinePattern += "<FUNCTION_CALL name=\"lookup_ext\"  type=\"DI\" tableDatastore=\"DS_RMX_STAGING\" ";
                    newLinePattern += "tableOwner=\"DBO\" tableName=\"UNIQUE_CODE\" > ";
                    newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" /> ";
                    newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" /> ";
                    newLinePattern += "<VARIABLE_REFERENCE name=\"$gJobID\" /> ";
                    newLinePattern += "<CONSTANT value=\"" + _fieldSystemTable[index] + "\" datatype=\"VARCHAR\" size=\"10\" /> ";
                    newLinePattern += "<CONSTANT value=\"0\" datatype=\"INT\" /> ";
                    newLinePattern += "<COLUMN_REFERENCE qualifier1=\"" + _tableName + "\" column=\"" + _fieldName[index] + "\" /> ";
                    newLinePattern += "<CONSTANT_NULL /><VARIABLE_REFERENCE name=\"dummyname\" /> ";
                    newLinePattern += "<DIAttributes> ";
                    newLinePattern += "<DIAttribute name=\"output_cols_info\" value=\"&lt;?xml version=&quot;1.0&quot; ";
                    newLinePattern += "encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col ";
                    newLinePattern += "index=&quot;1&quot; ";
                    newLinePattern += "expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;\"/> ";
                    newLinePattern += "<DIAttribute name=\"run_as_separate_process\" value=\"no\"/> ";
                    newLinePattern += "</DIAttributes> ";
                    newLinePattern += "</FUNCTION_CALL> ";
                    newLinePattern += "</DIExpression> ";
                }
                else
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"" + _tableName + "." + _fieldName[index] + "\" >\n";
                    newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"" + _tableName + "\" column=\"" + _fieldName[index] + "\" />\n";
                    newLinePattern += "</DIExpression>";                   
                }
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFRead_QReadAT_select, newLinePattern);


        }

        private void GenDFRead_QAT_schema()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += "> \n";
                newLinePattern += "<DIAttributes> \n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/> \n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"KG_DA_ROW_ID." + _fieldName[index] + "\"/> \n";
                newLinePattern += "</DIAttributes> \n";
                newLinePattern += "</DIElement>";
                                
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFRead_QAT_schema, newLinePattern);
           

        }

        private void GenDFRead_QAT_select()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIExpression isString=\"true\" expr=\"KG_DA_ROW_ID." + _fieldName[index] + "\" > \n";
                newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"KG_DA_ROW_ID\" column=\"" + _fieldName[index] + "\" /> \n";
                newLinePattern += "</DIExpression>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFRead_QAT_select, newLinePattern);
           

        }

        private void GenDFValidate_QAlwaysAdd_schema()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {               
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" " ;
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\"  ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += "> \n";
                newLinePattern += "<DIAttributes> \n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/> \n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" ";
                newLinePattern += "value=\"CASE_OPTION_ALWAYS_ADD_YES." + _fieldName[index] + "\"/> \n";
                newLinePattern += "</DIAttributes> \n";
                newLinePattern += "</DIElement> ";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFValidate_QAlwaysAdd_schema, newLinePattern);

        }

        private void GenDFValidate_QAlwaysAdd_select()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIExpression isString=\"true\" ";
                newLinePattern += "expr=\"CASE_OPTION_ALWAYS_ADD_YES." + _fieldName[index] + "\"> \n";
                newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"CASE_OPTION_ALWAYS_ADD_YES\" ";
                newLinePattern += "column=\"" + _fieldName[index] + "\" /> \n";
                newLinePattern += "</DIExpression>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagReplaceDfDisValidateSelect, newLinePattern);

        }

        private void GenDFValidate_QAddUpdate_schema()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += "> \n";
                newLinePattern += "<DIAttributes> \n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/> \n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" ";
                newLinePattern += "value=\"CASE_OPTION_ALWAYS_ADD_NO." + _fieldName[index] + "\"/> \n";
                newLinePattern += "</DIAttributes> \n";
                newLinePattern += "</DIElement>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFValidate_QAddUpdate_schema, newLinePattern);
            

        }


        private void GenDFValidate_QAddUpdate_select()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIExpression isString=\"true\" expr=\"CASE_OPTION_ALWAYS_ADD_NO." + _fieldName[index] + "\"> \n";
                newLinePattern += "<COLUMN_REFERENCE qualifier1=\"CASE_OPTION_ALWAYS_ADD_NO\" ";
                newLinePattern += "column=\"" + _fieldName[index] + "\"/> \n";
                newLinePattern += "</DIExpression>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFValidate_QAddUpdate_select, newLinePattern);
            

        }

        private void GenDFImport_QJobValidRecords_schema()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += ">\n";
                newLinePattern += "<DIAttributes>\n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"" + _tableName + "." + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIAttributes>\n";
                newLinePattern += "</DIElement>";

                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }
            ReplaceSimpleText(TagGenDFImport_QJobValidRecords_schema, newLinePattern);
        }

        private void GenDFImport_QJobValidRecords_select()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIExpression isString=\"true\" expr=\"" + _tableName + "." + _fieldName[index] + "\">\n";
                newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"" + _tableName + "\" column=\"" + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIExpression>";

                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }
            ReplaceSimpleText(TagGenDFImport_QJobValidRecords_select, newLinePattern);
        }

        private void GenDFImport_QInsertRows_schema()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += ">\n";
                newLinePattern += "<DIAttributes>\n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"CASE_UPDATE_RECORDS_NO." + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIAttributes>\n";
                newLinePattern += "</DIElement>";

                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }
            ReplaceSimpleText(TagGenDFImport_QInsertRows_schema, newLinePattern);
        }

        private void GenDFImport_QInsertRows_select()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToString(_fieldName[index]) != _primaryFieldKey) 
                {
                newLinePattern += "<DIExpression isString=\"true\" expr=\"CASE_UPDATE_RECORDS_NO." + _fieldName[index] + "\">\n";
                newLinePattern += "<COLUMN_REFERENCE qualifier1=\"CASE_UPDATE_RECORDS_NO\" column=\"" + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIExpression>";

                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
                }
            }

            ReplaceSimpleText(TagGenDFImport_QInsertRows_select, newLinePattern);
        }


        private void GenDFImport_QUpdateRows_schema()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToString(_fieldName[index]) != _primaryFieldKey)
                {
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                    if (Convert.ToInt16(_fieldType[index]) == TypeString)
                        newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                    if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                        newLinePattern += "size=\"8000\" ";
                    newLinePattern += ">\n";
                    newLinePattern += "<DIAttributes>\n";
                    newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"CASE_UPDATE_RECORDS_YES." + _fieldName[index] + "\"/>\n";
                    newLinePattern += "</DIAttributes>\n";
                    newLinePattern += "</DIElement>";

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
                }
            }

            ReplaceSimpleText(TagGenDFImport_QUpdateRows_schema, newLinePattern);
        }


        private void GenDFImport_QUpdateRows_select()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToString(_fieldName[index]) != _primaryFieldKey)
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"CASE_UPDATE_RECORDS_YES." + _fieldName[index] + "\">\n";
                    newLinePattern += "<COLUMN_REFERENCE qualifier1=\"CASE_UPDATE_RECORDS_YES\" column=\"" + _fieldName[index] + "\"/>\n";
                    newLinePattern += "</DIExpression>";

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
                }
            }

            ReplaceSimpleText(TagGenDFImport_QUpdateRows_select, newLinePattern);
        }


        private void GenDFImport_QAssignId_schema()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"" + _fieldCodeDesc[Convert.ToInt16(_fieldType[index])] + "\" ";
                if (Convert.ToInt16(_fieldType[index]) == TypeString)
                    newLinePattern += "size=\"" + _fieldSize[index] + "\" ";
                if ((Convert.ToInt16(_fieldType[index]) >= 5) && (Convert.ToInt16(_fieldType[index]) <= 15) && (Convert.ToInt16(_fieldType[index]) != 7)) 
                    newLinePattern += "size=\"8000\" ";
                newLinePattern += ">\n";
                newLinePattern += "<DIAttributes>\n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"Q_INSERT_ROWS." + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIAttributes>\n";
                newLinePattern += "</DIElement>";

                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFImport_QAssignId_schema, newLinePattern);
        }


        private void GenDFImport_QAssignId_select()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToString(_fieldName[index]) != _primaryFieldKey)
                {

                    newLinePattern += "<DIExpression isString=\"true\" expr=\"Q_INSERT_ROWS." + _fieldName[index] + "\">\n";
                    newLinePattern += "<COLUMN_REFERENCE qualifier1=\"Q_INSERT_ROWS.\" column=\"" + _fieldName[index] + "\"/>\n";
                    newLinePattern += "</DIExpression>";

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
                }
            }

            ReplaceSimpleText(TagGenDFImport_QAssignId_select, newLinePattern);
        }


    }



              


   


}






    


          