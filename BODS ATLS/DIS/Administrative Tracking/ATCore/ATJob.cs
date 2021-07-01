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
        private string _databaseOwner;
        

        // Following private arrays represent the Internal Data Definition Structure
        private ArrayList _fieldName; // Position 0 of _masterArrayList
        private ArrayList _fieldDesc; // Position 1 of _masterArrayList
        private ArrayList _fieldType; // Position 2 of _masterArrayList
        private ArrayList _fieldSize; // Position 3 of _masterArrayList
        private ArrayList _fieldPattern; // Position 4 of _masterArrayList
        private ArrayList _fieldSystemTable;// Position 5 of _masterArrayList
        private ArrayList _fieldCodeTable; //Position 6 of _masterArrayList
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

        private enum DBFormat
        {
            AccessStaging = 0,
            RMXStaging = 1,
            RMXBase = 2
        }

        private const int _GlossaryTypeCode = 468;
        private const int _GlossaryTextLanguageCode = 1033;

        private const string TagPrimaryKey = "BOND_ABS_ID";
        private const string TagGeneric = "BOND_ABS";
        private const string TagGenericParent = "SUPP_PARENT";
        private const string TagParentKey = "PARENT_ID";
        private const string TagTableStaging = "GenTableStaging";
        private const string TagMatchField = "TagMatchField";
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
        private const string TagGenWFRead_Conditions = "GenWFRead_Conditions";
        private const string TagGenWFValidation_Conditions = "GenWFValidation_Conditions";
        private const string TagGenWFImport_Conditions = "GenWFImport_Conditions";

        private int[] _tagIndex = new int[24];
        private string[] _tagDescription = new string[24];
        private string[] _fieldCodeDesc = new string[16] { "VARCHAR", "INT", "DOUBLE", "DATETIME", "DATETIME", "VARCHAR", "VARCHAR", "INT", "VARCHAR", "VARCHAR", "VARCHAR", "VARCHAR", "VARCHAR", "VARCHAR", "VARCHAR", "VARCHAR" };

        private ATTemplate objATTemplate;
        
        private ATLog objATLog;      
        private ATDB objATDB;
        private string[] newJob;
        private string uniqueId;
        private StreamWriter jobFile;
        private string jobFileName;
        private string jobDirectory;
        private string jobFileNamePrefix;
        private string jobFileFullPath;
        private string newLinePattern;

        public ATJob(string uniqueId)
        {
            this.uniqueId = uniqueId;        
        }

        private string GetDataTypeString(int index, DBFormat format)
        {
            string buf = null;
            switch (format)
            {
                case DBFormat.AccessStaging:
                    switch (Convert.ToInt32(_fieldType[index]))
                    {
                        case 0:
                        case 3:
                        case 4:
                        case 10:
                        case 12:
                        case 13:
                            buf = "VARCHAR\" size=\"" + _fieldSize[index] + "";
                            break;
                        case 1:
                        case 7:
                            buf = "INT";
                            break;
                        case 2:
                            buf = "DOUBLE";
                            break;
                        case 5:
                        case 11:
                            buf = "VARCHAR\" size=\"8000";
                            break;
                        case 6:
                        case 9:
                            buf = "VARCHAR\" size=\"25";
                            break;
                        case 8:
                            buf = "VARCHAR\" size=\"50";
                            break;
                        case 14:
                        case 15:
                        case 16:
                        case 17:
                            buf = "VARCHAR\" size=\"8000";
                            break;
                    }
                    break;

                case DBFormat.RMXStaging:
                    switch (Convert.ToInt32(_fieldType[index]))
                    {
                        case 0:
                        case 3:
                        case 4:
                        case 10:
                        case 12:
                        case 13:
                            buf = "VARCHAR\" size=\"" + _fieldSize[index] + "";
                            break;
                        case 1:
                        case 6:
                        case 7:
                        case 9:
                            buf = "INT";
                            break;
                        case 2:
                            buf = "DOUBLE";
                            break;
                        case 5:
                        case 11:
                            buf = "VARCHAR\" size=\"8000";
                            break;
                        case 8:
                            buf = "VARCHAR\" size=\"50";
                            break;
                        case 14:
                        case 15:
                        case 16:
                        case 17:
                            buf = "VARCHAR\" size=\"8000";
                            break;
                    }
                    break;

                case DBFormat.RMXBase:
                    switch (Convert.ToInt32(_fieldType[index]))
                    {
                        case 0:
                        case 3:
                        case 4:
                        case 10:
                        case 12:
                        case 13:
                            buf = "VARCHAR\" size=\"" + _fieldSize[index] + "";
                            break;
                        case 1:
                        case 6:
                        case 7:
                        case 8:
                        case 9:
                            buf = "INT";
                            break;
                        case 2:
                            buf = "DOUBLE";
                            break;
                        case 5:
                        case 11:
                            buf = "LONG";
                            //buf = "VARCHAR\" size=\"8000";
                            break;
                        case 14:
                        case 15:
                        case 16:
                        case 17:
                            buf = "VARCHAR\" size=\"8000";
                            break;
                    }
                    break;
            }
            return buf;
        }

        public void setRmxTableInfo(string tableName, string friendlyTableName, string primaryFieldKey, string matchingField, string databaseOwner)
        {
            this._tableName = tableName;
            this._friendlyTableName = friendlyTableName;
            this._primaryFieldKey = primaryFieldKey;
            this._matchingField = matchingField;
            this._databaseOwner = databaseOwner;            
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
            _fieldCodeTable = _masterArrayList[6];


        }

        private void customizeXml()
        {

            // Customize XML here
            //Supplemental tables.
            indexTag();          
            ReplacePrimaryKeyTags();
            ReplaceGenericTags();
            ReplaceParentKeyTags();
            ReplaceGenericParentTags();
            GenTableStaging();
            GenTableRMX();
            GenTableMDB();
            GenDIElement_schema(_tableName, "ReadQueryElements", DBFormat.AccessStaging , false, false, true);
            GenDIExpression_schema(_tableName, "ReadQueryExpressions", false, false, true);

            GenDIElement_schema(_tableName, "ValidateQueryElements", DBFormat.RMXStaging, false, false, false);
            GenDIExpression_schema(_tableName, "ValidateQueryExpressions", false, false, false);

            GenDIElement_schema(_tableName, "ValidQueryElements", DBFormat.RMXStaging, true, false, false);
            GenDIExpression_schema(_tableName, "ValidQueryExpressions", true, false, false);
            GenDIElement_schema("CASE_UPDATE_RECORDS_NO", "InsertQueryElements", DBFormat.RMXBase, false, true, false);
            GenDIExpression_schema("CASE_UPDATE_RECORDS_NO", "InsertQueryExpressions", false, true, false);
            GenDIElement_schema("CASE_UPDATE_RECORDS_YES", "UpdateQueryElements", DBFormat.RMXBase, false, true, false);
            GenDIExpression_schema("CASE_UPDATE_RECORDS_YES", "UpdateQueryExpressions", false, true, false);


            // Customize XML here
            //Admin Tracking 
            
            indexTag();          
            ReplacePrimaryKeyTags();
            ReplaceGenericTags();
            GenTableStaging();
            GenTableRMX();
            GenTableMDB();
            GenDFRead_QReadAT_schema();
            GenDFRead_QReadAT_select();
            GenDFRead_QAT_schema();
            GenDFRead_QAT_select();
            GenDFValidate_QAlwaysAdd_schema();
            TagMatchingField();
            GenDFValidate_QAlwaysAdd_select();
            GenDFValidate_QAddUpdate_schema();
            GenDFValidate_QAddUpdate_select();
            GenDFImport_QJobValidRecords_schema();
            GenDFImport_QJobValidRecords_select();
            GenDFImport_QInsertRows_schema();
            GenDFImport_QInsertRows_select();
            GenDFImport_QUpdateRows_schema();
            GenDFImport_QUpdateRows_select();
            GenDFImport_QAssignId_schema();
            GenDFImport_QAssignId_select();

            GenWFRead_Conditions();
            GenWFValidation_Conditions();
            GenWFImport_Conditions();
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
            for (int index = 0; index < _tagDescription.Length; index++)
            {
                try
                {
                    if (_tagDescription[index].Contains(searchedString))
                    {
                        newJob[_tagIndex[index]] = content;
                        break;
                    }
                }
                catch (Exception e)
                {
                    objATLog.writeDebug("Tag \"" + searchedString + "\" is not present in the template document");
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
                    newJob[index] = newJob[index].Replace(TagGeneric, _tableName);
                }
            }
        }

        private void ReplaceParentKeyTags()
        {
            for (int index = 0; index < newJob.Length; index++)
            {
                if (newJob[index].Contains(TagParentKey))
                {
                    newJob[index] = newJob[index].Replace(TagParentKey, _matchingField);
                }
            }
        }

        private void ReplaceGenericParentTags()
        {
            for (int index = 0; index < newJob.Length; index++)
            {
                if (newJob[index].Contains(TagGenericParent))
                {
                    newJob[index] = newJob[index].Replace(TagGenericParent, _friendlyTableName);
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
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
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
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXBase) + "\" ";
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
                newLinePattern += "<DIColumn name=\"" + _fieldName[index] + "\" ";
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.AccessStaging) + "\" ";
                newLinePattern += "nullable=\"true\" > \n</DIColumn>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagTableMDB, newLinePattern);


        }

        private void GenDFRead_QReadAT_schema()
        {
            // Initialize newLinePattern;
            int seq = 1;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToInt16(_fieldType[index]) == TypeCodes || Convert.ToInt16(_fieldType[index]) == TypeStates)
                {
                    // For code field type
                    newLinePattern += "<DIElement name=\"lookup_ext_" + seq;  
                    newLinePattern += "\" hasNestedSchema=\"true\">\n";
                    newLinePattern += "<DINestedSchema type=\"RFCSchema\">\n";
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"INT\" >\n";
                    newLinePattern += "</DIElement>\n";
                    newLinePattern += "</DINestedSchema>\n";
                    newLinePattern += "</DIElement>\n";
                    seq++;
                }
                else
                {
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                    newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.AccessStaging) + "\" ";
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
                // For fields belonging to CODE/STATES field type
                if (Convert.ToInt16(_fieldType[index]) == TypeCodes || Convert.ToInt16(_fieldType[index]) == TypeStates)
                {
                    // For code field type
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"__AL_LOOKUPEX_TRAN ";
                    if (Convert.ToInt16(_fieldType[index]) == TypeCodes)
                    {
                        newLinePattern += "lookup_ext([DS_RMDB.DBO.CODES, 'PRE_LOAD_CACHE', 'MAX'], [ ";
                        newLinePattern += "CODE_ID ], [  NULL  ], [ SHORT_CODE, '=', " + _fieldName[index] + ",";
                        newLinePattern += "TABLE_ID, '=', " + _fieldCodeTable[index] + "]) &#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml ";
                    }
                    if (Convert.ToInt16(_fieldType[index]) == TypeStates )
                    {
                        newLinePattern += "lookup_ext([DS_RMDB.DBO.STATES, 'PRE_LOAD_CACHE', 'MAX'], [ ";
                        newLinePattern += "STATE_ROW_ID ], [  NULL  ], [ STATE_ID, '=', " + _fieldName[index] + "]) &#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml ";
                    }
                
                    newLinePattern += "version=&quot;1.0&quot; encoding=&quot;UTF-";
                    newLinePattern += "8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; ";
                    newLinePattern += "expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;', ";
                    newLinePattern += "&quot;run_as_separate_process&quot; = 'no')&#xA;\" > ";
                    newLinePattern += "<FUNCTION_CALL name=\"lookup_ext\"  type=\"DI\" tableDatastore=\"DS_RMDB\" ";
                    if (Convert.ToInt16(_fieldType[index]) == TypeCodes)
                    {
                        newLinePattern += "tableOwner=\"DBO\" tableName=\"CODES\" > ";
                        newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" /> ";
                        newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" /> ";
                        newLinePattern += "<COLUMN_REFERENCE qualifier1=\"" + _tableName + "\" column=\"" + _fieldName[index] + "\" /> ";
                        newLinePattern += "<CONSTANT value=\"" + _fieldCodeTable[index] + "\" datatype=\"INT\" /> ";
                    }

                    if (Convert.ToInt16(_fieldType[index]) == TypeStates)
                    {
                        newLinePattern += "tableOwner=\"DBO\" tableName=\"STATES\" > ";
                        newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" /> ";
                        newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" /> ";
                        newLinePattern += "<COLUMN_REFERENCE qualifier1=\"" + _tableName + "\" column=\"" + _fieldName[index] + "\" /> ";
                    }
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
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
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
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
                newLinePattern += "> \n";
                newLinePattern += "<DIAttributes> \n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/> \n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" ";
                newLinePattern += "value=\"CASE_OPTION_ALWAYS_ADD_NO." + _fieldName[index] + "\"/> \n";
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
                newLinePattern += "expr=\"CASE_OPTION_ALWAYS_ADD_NO." + _fieldName[index] + "\"> \n";
                newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"CASE_OPTION_ALWAYS_ADD_NO\" ";
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
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
                newLinePattern += "> \n";
                newLinePattern += "<DIAttributes> \n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/> \n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" ";
                newLinePattern += "value=\"CASE_OPTION_ALWAYS_ADD_YES." + _fieldName[index] + "\"/> \n";
                newLinePattern += "</DIAttributes> \n";
                newLinePattern += "</DIElement>";
                if (index < _fieldName.Count - 1)
                    newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFValidate_QAddUpdate_schema, newLinePattern);


        }
        private void TagMatchingField()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            newLinePattern += "<DIExpression isString=\"true\" expr=\"__AL_LOOKUPEX_TRAN ";
            newLinePattern += "lookup_ext([DS_RMDB.DBO." + _tableName + ", 'PRE_LOAD_CACHE', 'MAX'], ";
            newLinePattern += "[" + _primaryFieldKey + "], [ 0 ], [" + _matchingField + ", '=', ";
            newLinePattern += "CASE_OPTION_ALWAYS_ADD_YES." + _matchingField + "]) ";
            newLinePattern += "&#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml version=&quot;1.0&quot; ";
            newLinePattern += "encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; ";
            newLinePattern += "expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;', ";
            newLinePattern += "&quot;run_as_separate_process&quot; = 'no')&#xA;\" > \n";
            newLinePattern += "<FUNCTION_CALL name=\"lookup_ext\"  type=\"DI\" tableDatastore=\"DS_RMDB\" ";
            newLinePattern += "tableOwner=\"DBO\" tableName=\"" + _tableName + "\" > \n";
            newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" /> \n";
            newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" /> \n";
            newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"CASE_OPTION_ALWAYS_ADD_YES\" column=\"" ;
            newLinePattern += _matchingField + "\" /> \n";
            newLinePattern += "<CONSTANT value=\"0\" datatype=\"INT\" /> \n";
            newLinePattern += "<VARIABLE_REFERENCE name=\"dummyname\" /> \n";
            newLinePattern += "<DIAttributes> \n";
            newLinePattern += "<DIAttribute name=\"output_cols_info\" value=\"&lt;?xml version=&quot;1.0&quot; ";
            newLinePattern += " encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; ";
            newLinePattern += "expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;\"/> \n";
            newLinePattern += "<DIAttribute name=\"run_as_separate_process\" value=\"no\"/> \n";
            newLinePattern += "</DIAttributes> \n";
            newLinePattern += "</FUNCTION_CALL> \n";
            newLinePattern += "</DIExpression>\n";

            ReplaceSimpleText(TagMatchField, newLinePattern);

        }



        private void GenDFValidate_QAddUpdate_select()
        {
            // Initialize newLinePattern;

            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIExpression isString=\"true\" expr=\"CASE_OPTION_ALWAYS_ADD_YES." + _fieldName[index] + "\"> \n";
                newLinePattern += "<COLUMN_REFERENCE qualifier1=\"CASE_OPTION_ALWAYS_ADD_YES\" ";
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
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
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
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXStaging) + "\" ";
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
                    newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                    /* Fix the issue with wrong data type for type codes */
                    newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXBase) + "\" ";
                    newLinePattern += (Convert.ToString(_fieldName[index]) == _primaryFieldKey ? " key=\"true\"" : ""); 
                    newLinePattern += " >\n";
                    newLinePattern += "<DIAttributes>\n";
                    newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";

                if ( Convert.ToInt32(_fieldType[index]) == 5 || Convert.ToInt32(_fieldType[index]) == 11)
                {
                    newLinePattern += "<DIAttribute name=\"Long Type\" value=\"CLOB\"/>";
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"varchar_to_long(CASE_UPDATE_RECORDS_YES." + _fieldName[index] + ")\"/>";
                }
                else
                {
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"CASE_UPDATE_RECORDS_YES." + _fieldName[index] + "\"/>\n";
                }
                    newLinePattern += "</DIAttributes>\n";
                    newLinePattern += "</DIElement>";

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFImport_QUpdateRows_schema, newLinePattern);
        }


        private void GenDFImport_QUpdateRows_select()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToInt32(_fieldType[index]) == 5 || Convert.ToInt32(_fieldType[index]) == 11)
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"varchar_to_long(CASE_UPDATE_RECORDS_YES." + _fieldName[index] + ")\" >";
                    newLinePattern += "<FUNCTION_CALL name=\"varchar_to_long\"  type=\"DI\" >";
                    newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"CASE_UPDATE_RECORDS_YES\" column=\"" + _fieldName[index] + "\" />";
                    newLinePattern += "</FUNCTION_CALL>";
                    newLinePattern += "</DIExpression>";
                }
                else
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"CASE_UPDATE_RECORDS_YES." + _fieldName[index] + "\">\n";
                    newLinePattern += "<COLUMN_REFERENCE qualifier1=\"CASE_UPDATE_RECORDS_YES\" column=\"" + _fieldName[index] + "\"/>\n";
                    newLinePattern += "</DIExpression>";
                }

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
                }
            ReplaceSimpleText(TagGenDFImport_QUpdateRows_select, newLinePattern);
        }

        private void GenDIExpression_schema( string sSchema, string sReplaceField, bool bKeyLookup, bool bKeyIsFlagged, bool bLookupCodes)
        {
            newLinePattern = null;
            for (int index = 0; index < _fieldName.Count; index++)
            {
                if (Convert.ToString(_fieldName[index]) == _primaryFieldKey)
                {
                    if (bKeyLookup)
                    {
                        newLinePattern += "<DIExpression isString=\"true\" expr=\"__AL_LOOKUPEX_TRAN lookup_ext([DS_RMX_STAGING." + _databaseOwner + "." + _friendlyTableName + ", 'PRE_LOAD_CACHE', 'MAX'], [ " + _primaryFieldKey + " ], [  NULL  ], [ DA_ROW_ID, '=', " + _tableName + ".DA_ROW_ID ]) &#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;', &quot;run_as_separate_process&quot; = 'no')&#xA;\" >\n";
                        newLinePattern += "<FUNCTION_CALL name=\"lookup_ext\"  type=\"DI\" tableDatastore=\"DS_RMX_STAGING\" tableOwner=\"" + _databaseOwner + "\" tableName=\"" + _friendlyTableName + "\" >\n";
                        newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" />\n";
                        newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" />\n";
                        newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"" + _tableName + "\" column=\"DA_ROW_ID\" />\n";
                        newLinePattern += "<CONSTANT_NULL /><VARIABLE_REFERENCE name=\"dummyname\" />\n";
                        newLinePattern += "<DIAttributes>\n";
                        newLinePattern += "<DIAttribute name=\"output_cols_info\" value=\"&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;\"/>\n";
                        newLinePattern += "<DIAttribute name=\"run_as_separate_process\" value=\"no\"/>\n";
                        newLinePattern += "</DIAttributes>\n";
                        newLinePattern += "</FUNCTION_CALL>\n";
                        newLinePattern += "</DIExpression>\n";
                    }
                    else
                    {
                        newLinePattern += "<DIExpression isString=\"true\" expr=\"" + sSchema + "." + _fieldName[index] + "\" >\n";
                        newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"" + sSchema + " \" column=\"" + _fieldName[index] + "\" />\n";
                        newLinePattern += "</DIExpression>\n";
                    }
                }
                else
                {
                    if (Convert.ToInt32(_fieldType[index]) == 6 && bLookupCodes)
                    {
                        newLinePattern += "<DIExpression isString=\"true\" expr=\"__AL_LOOKUPEX_TRAN lookup_ext([DS_RMDB.dbo.CODES, 'PRE_LOAD_CACHE', 'MAX'], [ CODE_ID ], [  NULL  ], [ SHORT_CODE, '=', '" + _fieldName[index] + "', TABLE_ID, '=', " + _fieldCodeTable[index] + " ]) &#xA;SET(&quot;output_cols_info&quot; = '&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;', &quot;run_as_separate_process&quot; = 'no')&#xA;\" >";
                        newLinePattern += "<FUNCTION_CALL name=\"lookup_ext\"  type=\"DI\" tableDatastore=\"DS_RMDB\" tableOwner=\"dbo\" tableName=\"CODES\" >";
                        newLinePattern += "<CONSTANT value=\"PRE_LOAD_CACHE\" datatype=\"VARCHAR\" size=\"14\" />";
                        newLinePattern += "<CONSTANT value=\"MAX\" datatype=\"VARCHAR\" size=\"3\" />";
                        newLinePattern += "<CONSTANT value=\"" + _fieldCodeTable[index] + "\" datatype=\"INT\" />";
                        newLinePattern += "<CONSTANT_NULL /><VARIABLE_REFERENCE name=\"dummyname\" />";
                        newLinePattern += "<DIAttributes>";
                        newLinePattern += "<DIAttribute name=\"output_cols_info\" value=\"&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&lt;output_cols_info&gt;&lt;col index=&quot;1&quot; expression=&quot;no&quot;/&gt;&#xA;&lt;/output_cols_info&gt;\"/>";
                        newLinePattern += "<DIAttribute name=\"run_as_separate_process\" value=\"no\"/>";
                        newLinePattern += "</DIAttributes>";
                        newLinePattern += "</FUNCTION_CALL>";
                        newLinePattern += "</DIExpression>";
                    }
                    else
                    {
                        newLinePattern += "<DIExpression isString=\"true\" expr=\"" + sSchema + "." + _fieldName[index] + "\" >\n";
                        newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"" + sSchema + " \" column=\"" + _fieldName[index] + "\" />\n";
                        newLinePattern += "</DIExpression>\n";
                    }
                }
            }
            ReplaceSimpleText(sReplaceField, newLinePattern);
        }
        private void GenDIElement_schema( string sSchema, string sReplaceField, DBFormat eFormat, bool bKeyLookup, bool bKeyIsFlagged, bool bLookupCodes )
        {
            int c = 0;

            newLinePattern = null;
            for (int index = 0; index < _fieldName.Count; index++)
            {
                if ( Convert.ToString(_fieldName[index]) == _primaryFieldKey )
                {
                    if (bKeyLookup)
                    {
                        newLinePattern += "<DIElement name=\"lookup_ext\" hasNestedSchema=\"true\">\n";
                        newLinePattern += "<DINestedSchema type=\"RFCSchema\">\n";
                        newLinePattern += "<DIElement name=\""+ _fieldName[index] + "\" datatype=\"INT\" >\n";
                        newLinePattern += "</DIElement>\n";
                        newLinePattern += "</DINestedSchema>\n";
                        newLinePattern += "</DIElement>\n";
                        continue;                        
                    }
                    else if (bKeyIsFlagged)
                    {
                        newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"INT\" key=\"true\" >\n";
                    }
                    else
                    {
                        newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"INT\" >\n";
                    }
                }
                else
                {
                    //codes
                    if (Convert.ToInt32(_fieldType[index]) == 6 && bLookupCodes)
                    {
                        newLinePattern += "<DIElement name=\"lookup_ext" + (c>=1?"_"+c:"") + "\" hasNestedSchema=\"true\">";
                        newLinePattern += "<DINestedSchema type=\"RFCSchema\">";
                        newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=\"INT\" >";
                        newLinePattern += "</DIElement>";
                        newLinePattern += "</DINestedSchema>";
                        newLinePattern += "</DIElement>";

                        c++;
                        continue;
                    }
                    else
                    {
                        newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" datatype=";
                        newLinePattern += GetDataTypeString(index, eFormat);
                        newLinePattern += " >\n";
                    }                    
                }
                newLinePattern += "<DIAttributes>\n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"" + sSchema + "." + _fieldName[index] + "\"/>\n";
                newLinePattern += "</DIAttributes>\n";
                newLinePattern += "</DIElement>\n";                 
            }
            ReplaceSimpleText(sReplaceField, newLinePattern);
        }


        private void GenDFImport_QAssignId_schema()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            for (int index = 0; index < _fieldName.Count; index++)
            {
                newLinePattern += "<DIElement name=\"" + _fieldName[index] + "\" ";
                /* Fix the issue with wrong data type for type codes */
                newLinePattern += "datatype=\"" + GetDataTypeString(index, DBFormat.RMXBase) + "\" ";
                newLinePattern += (Convert.ToString(_fieldName[index]) == _primaryFieldKey ? " key=\"true\"" : ""); 
                newLinePattern += " >\n";
                newLinePattern += "<DIAttributes>\n";
                newLinePattern += "<DIAttribute name=\"Description\" value=\"\"/>\n";
                if (Convert.ToInt32(_fieldType[index]) == 5 || Convert.ToInt32(_fieldType[index]) == 11)
                {
                    newLinePattern += "<DIAttribute name=\"Long Type\" value=\"CLOB\"/>";
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"varchar_to_long(Q_INSERT_ROWS." + _fieldName[index] + ")\"/>";
                }
                else if (Convert.ToString(_fieldName[index]) == _primaryFieldKey)
                {
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\" ((gen_row_num()  + Q_AT_" + _tableName + "_RESERVE_UIDs.NEXT_UNIQUE_ID) - 1) \"/>\n";
                }
                else
                {
                    newLinePattern += "<DIAttribute name=\"ui_mapping_text\" value=\"Q_INSERT_ROWS." + _fieldName[index] + "\"/>\n";
                }
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
                if (Convert.ToInt32(_fieldType[index]) == 5 || Convert.ToInt32(_fieldType[index]) == 11)
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"varchar_to_long(Q_INSERT_ROWS." + _fieldName[index] + ")\" >";
                    newLinePattern += "<FUNCTION_CALL name=\"varchar_to_long\"  type=\"DI\" >";
                    newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"Q_INSERT_ROWS\" column=\"" + _fieldName[index] + "\" />";
                    newLinePattern += "</FUNCTION_CALL>";
                    newLinePattern += "</DIExpression>";
                }
                else if (Convert.ToString(_fieldName[index]) == _primaryFieldKey)
                {
                    newLinePattern += "<DIExpression isString=\"true\" expr=\"((gen_row_num() + Q_AT_" + _tableName + "_RESERVE_UIDs.NEXT_UNIQUE_ID) - 1)\" >";
                    newLinePattern += "<SUBTRACT>";
                    newLinePattern += "<ADD>";
                    newLinePattern += "<FUNCTION_CALL name=\"gen_row_num\"  type=\"DI\" />";
                    newLinePattern += "<COLUMN_REFERENCE  qualifier1=\"Q_AT_" + _tableName + "_RESERVE_UIDs\" column=\"NEXT_UNIQUE_ID\" />";
                    newLinePattern += "</ADD>";
                    newLinePattern += "<CONSTANT value=\"1\" datatype=\"INT\" />";
                    newLinePattern += "</SUBTRACT>";
                    newLinePattern += "</DIExpression>";
                }
                else
                {

                    newLinePattern += "<DIExpression isString=\"true\" expr=\"Q_INSERT_ROWS." + _fieldName[index] + "\">\n";
                    newLinePattern += "<COLUMN_REFERENCE qualifier1=\"Q_INSERT_ROWS.\" column=\"" + _fieldName[index] + "\"/>\n";
                    newLinePattern += "</DIExpression>";
                }

                    if (index < _fieldName.Count - 1)
                        newLinePattern += "\n";
            }

            ReplaceSimpleText(TagGenDFImport_QAssignId_select, newLinePattern);
        }


        private void GenWFRead_Conditions()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            newLinePattern += "<DIIfStep typeId=\"2\" >";
            newLinePattern += "<DIUIOptions>";
            newLinePattern += "<DIAttribute name=\"If_condition\" value=\"$gAdminTrack_Area = '" + _tableName + "'\"/>";
            newLinePattern += "<DIAttribute name=\"ui_display_name\" value=\"C_" + _tableName + "\"/>";
            newLinePattern += "</DIUIOptions>";
            newLinePattern += "<DIExpression isString=\"true\" expr=\"($gAdminTrack_Area = '" + _tableName + "')\" >";
            newLinePattern += "<LOGICAL_OP op=\"EQ\">";
            newLinePattern += "<VARIABLE_REFERENCE name=\"$gAdminTrack_Area\" />";
            newLinePattern += "<CONSTANT value=\"" + _tableName + "\" datatype=\"VARCHAR\" size=\"8\" />";
            newLinePattern += "</LOGICAL_OP>";
            newLinePattern += "</DIExpression>";
            newLinePattern += "<DIIf>";
            newLinePattern += "<DICallStep typeId=\"0\"  calledObjectType=\"Workflow\" name=\"WF_DIS_READ_AT_" + _tableName + "\" >";
            newLinePattern += "</DICallStep>";
            newLinePattern += "</DIIf>";
            newLinePattern += "</DIIfStep>";

            ReplaceSimpleText(TagGenWFRead_Conditions, newLinePattern);
        }

        private void GenWFValidation_Conditions()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            newLinePattern += "<DIIfStep typeId=\"2\" >";
            newLinePattern += "<DIUIOptions>";
            newLinePattern += "<DIAttribute name=\"If_condition\" value=\"$gAdminTrack_Area = '" + _tableName + "'\"/>";
            newLinePattern += "<DIAttribute name=\"ui_display_name\" value=\"C_" + _tableName + "\"/>";
            newLinePattern += "</DIUIOptions>";
            newLinePattern += "<DIExpression isString=\"true\" expr=\"($gAdminTrack_Area = '" + _tableName + "')\" >";
            newLinePattern += "<LOGICAL_OP op=\"EQ\">";
            newLinePattern += "<VARIABLE_REFERENCE name=\"$gAdminTrack_Area\" />";
            newLinePattern += "<CONSTANT value=\"" + _tableName + "\" datatype=\"VARCHAR\" size=\"8\" />";
            newLinePattern += "</LOGICAL_OP>";
            newLinePattern += "</DIExpression>";
            newLinePattern += "<DIIf>";
            newLinePattern += "<DICallStep typeId=\"0\"  calledObjectType=\"Workflow\" name=\"WF_DIS_VALIDATION_AT_" + _tableName + "\" >";
            newLinePattern += "</DICallStep>";
            newLinePattern += "</DIIf>";
            newLinePattern += "</DIIfStep>";

            ReplaceSimpleText(TagGenWFValidation_Conditions, newLinePattern);
        }

        private void GenWFImport_Conditions()
        {
            // Initialize newLinePattern;
            newLinePattern = null;

            newLinePattern += "<DIIfStep typeId=\"2\" >";
            newLinePattern += "<DIUIOptions>";
            newLinePattern += "<DIAttribute name=\"If_condition\" value=\"$gAdminTrack_Area = '" + _tableName + "'\"/>";
            newLinePattern += "<DIAttribute name=\"ui_display_name\" value=\"C_" + _tableName + "\"/>";
            newLinePattern += "</DIUIOptions>";
            newLinePattern += "<DIExpression isString=\"true\" expr=\"($gAdminTrack_Area = '" + _tableName + "')\" >";
            newLinePattern += "<LOGICAL_OP op=\"EQ\">";
            newLinePattern += "<VARIABLE_REFERENCE name=\"$gAdminTrack_Area\" />";
            newLinePattern += "<CONSTANT value=\"" + _tableName + "\" datatype=\"VARCHAR\" size=\"8\" />";
            newLinePattern += "</LOGICAL_OP>";
            newLinePattern += "</DIExpression>";
            newLinePattern += "<DIIf>";
            newLinePattern += "<DICallStep typeId=\"0\"  calledObjectType=\"Workflow\" name=\"WF_DIS_Import_AT_" + _tableName + "\" >";
            newLinePattern += "</DICallStep>";
            newLinePattern += "</DIIf>";
            newLinePattern += "</DIIfStep>";

            ReplaceSimpleText(TagGenWFImport_Conditions, newLinePattern);
        }



    }
}

