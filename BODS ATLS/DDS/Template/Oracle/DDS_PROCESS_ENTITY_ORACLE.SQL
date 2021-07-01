CREATE OR REPLACE PROCEDURE PROCESS_ENTITY
( PENTITY_TYPE  DDS_ENTITY_TYPE,
  pJobId IN NUMBER,
  pDaRowId IN NUMBER,
  vDbName IN VARCHAR2,
  pModuleName IN VARCHAR2,
  iForceCrtEnt IN NUMBER,
  iUseTaxId IN NUMBER,  --added by neha
  pCallingErrorLoc IN VARCHAR2,
  pErrorKeyColumnValue IN VARCHAR2,
  iUseDob IN NUMBER,  --JIRA 27127 knakra
  iEntityId OUT NUMBER,
  vErrorMsg OUT VARCHAR2
)
AUTHID CURRENT_USER
AS
PRAGMA AUTONOMOUS_TRANSACTION;
   /*vLastName VARCHAR2(255);
   vFirstName VARCHAR2(255);
   vMiddleName VARCHAR2(255);
   vAbbr VARCHAR2(25);
   vTaxId VARCHAR2(20);
   vAddr1 VARCHAR2(100);
   vAddr2 VARCHAR2(100);
   vCity VARCHAR2(50);
   vCountry VARCHAR2(25);
   vState VARCHAR2(25);
   vCounty VARCHAR2(30);
   vZip VARCHAR2(10);
   vPhone1 VARCHAR2(30);
   vPhone2 VARCHAR2(30);
   vFaxNumber VARCHAR2(30);
   vBirthDate VARCHAR2(8);
   vSexCode VARCHAR2(25);
   vComment VARCHAR2(16);
   iParentEid NUMBER(10,0);
   vTableName VARCHAR2(30);
   iRpt1099Flag NUMBER(10,0);
   iPrefixCodeId NUMBER(10,0);
   iSuffixCodeId NUMBER(10,0);
   vSuffixLegal VARCHAR2(50);
   iNameType NUMBER(10,0);
   vEmpNum VARCHAR2(20);*/
   --Entity Related variables ends
   nSql VARCHAR2(4000);
   nSqlAdd VARCHAR2(4000);
   --vDbName VARCHAR2(100);
   iEroleFlag NUMBER(10,0);
   iGlossaryType NUMBER(10,0);
   iUseTableId NUMBER(10,0);
   iTableId NUMBER(10,0);
   iCount NUMBER(10,0);
   vLastNameSoundex VARCHAR2(4);
   oEmpMatchByName NUMBER(10,0);
   oEmpMatchByEmpNum NUMBER(10,0);
   oEmpMatchByTaxId NUMBER(10,0);
   oEmpMatchByDob NUMBER(10,0);    --JIRA 27137 knakra
   oNonEmpMatchByName NUMBER(10,0);
   oNonEmpMatchByTaxId NUMBER(10,0);
   oNonEmpMatchByDob NUMBER(10,0); --JIRA 27137 knakra
   oCreateNewEntity NUMBER(10,0);
   oChkDupEntity NUMBER(10,0);
   oCreateNewEmp NUMBER(10,0);
   vSysErrorMsg VARCHAR2(4000);
   vCurrentErrorLoc VARCHAR2(100);
   vErrorTableToCheck VARCHAR2(100);
   vKeycolumn VARCHAR2(100);
   vErrorCount NUMBER:=0;
   vProcName VARCHAR2(100):='PROCESS_ENTITY';
   nSqlCount VARCHAR2(4000);  --neha
   ICODEID NUMBER(10,0):= 0 ; --MKAUR24
   iNameType NUMBER(10,0 ) ;-- MKAUR24
   ENTITY_DATA  DDS_ENTITY_TABTYPE;
   vFormattTaxid VARCHAR2(11):= NULL;

BEGIN
   ENTITY_DATA  := DDS_ENTITY_TABTYPE(PENTITY_TYPE);
   vCurrentErrorLoc:='11';
   FOR r in
     (select vLastName,
              vFirstName,
              vMiddleName,
              vAbbr,
              vTaxId,
              vAddr1,
              vAddr2,
              vCity,
              vCountry,
              vState,
              vCounty,
              vZip,
              vPhone1,
              vPhone2,
              vFaxNumber,
              vBirthDate,
              vSexCode,
              vComment,
              iParentEid,
              vTableName,
              iRpt1099Flag,
              iPrefixCodeId,
              iSuffixCodeId,
              vSuffixLegal,
              iNameType,
              vEmpNum
          from TABLE(ENTITY_DATA) rt
        where rt.iDaRowId=pDaRowId AND RT.IJOBID=pJobId AND ROWNUM=1)
  LOOP

   --vDbName := pDbName; commented by neha
   iEntityId := 0;
   iCount := 0;

   IF pModuleName = 'EVENT' THEN
      vErrorTableToCheck := 'DDS_EVENT';
      vKeycolumn := 'EVENT_NUMBER';
   ELSIF pModuleName = 'CLAIM' THEN
         vErrorTableToCheck := 'DDS_CLAIM';
         vKeycolumn := 'CLAIM_NUMBER';
   ELSIF pModuleName = 'PAYMENT' THEN
         vErrorTableToCheck := 'DDS_PAYMENT';
         vKeycolumn := 'CLAIM_ID';
   END IF;

   BEGIN
      nSql := 'SELECT STR_PARM_VALUE FROM ' || vDbName || 'PARMS_NAME_VALUE WHERE PARM_NAME = :1';
      EXECUTE IMMEDIATE nSql INTO iEroleFlaG using 'USE_ENTITY_ROLE';
    EXCEPTION
      WHEN OTHERS THEN
            vCurrentErrorLoc := 'SYSERR1';
            vSysErrorMsg := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                  p_DA_ROW_ID => pDaRowId,
                                  p_MODULE_NAME => pModuleName,
                                  p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                  p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                  p_ERROR_PROC_NAME => vProcName,
                                  p_ERROR_MSG => vSysErrorMsg,
                                  p_ERROR_COLUMNS => NULL,
                                  p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                  p_ERROR_KEY_COLUMN => vKeycolumn,
                                  P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                  P_IS_VALIDATION => 0);
            vErrorCount := vErrorCount + 1;
   END;

   BEGIN
     nSql := 'SELECT GLOSSARY_TYPE_CODE,TABLE_ID FROM ' || vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
     EXECUTE IMMEDIATE nSql into iGlossaryType, iTableId USING  r.vTableName;
   EXCEPTION
      WHEN OTHERS THEN
            vCurrentErrorLoc := 'SYSERR2';
            vSysErrorMsg := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                  p_DA_ROW_ID => pDaRowId,
                                  p_MODULE_NAME => pModuleName,
                                  p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                  p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                  p_ERROR_PROC_NAME => vProcName,
                                  p_ERROR_MSG => vSysErrorMsg,
                                  p_ERROR_COLUMNS => NULL,
                                  p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                  p_ERROR_KEY_COLUMN => vKeycolumn,
                                  P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                  P_IS_VALIDATION => 0);
            vErrorCount := vErrorCount + 1;
   END;

   IF iEroleFlag <> 0 AND ( iGlossaryType = 4 OR iGlossaryType = 7 ) THEN
      iUseTableId := 0;
   ELSE
      iUseTableId := 1;
   END IF;



IF iEroleFlag <> 0 AND iGlossaryType = 4 AND (iNameType IS NULL OR iNameType = 0 ) THEN --MKAUR24 START NAME _TYPE_CHANGE

   DDS_CODE_VALIDATION_IMPORT (PJOBID,'BUS' ,'ENTITY_NAME_TYPE' ,0 ,VDBNAME ,0 ,PDAROWID,PMODULENAME,'NM' , 'DDS_CODE_VALIDATION_IMPORT' , VKEYCOLUMN ,'NAME_TYPE', VERRORTABLETOCHECK ,PERRORKEYCOLUMNVALUE , ICODEID ) ;
     iNameType := ICODEID ;
  END IF ;
  IF iEroleFlag <> 0 AND iGlossaryType = 7 AND (iNameType IS NULL OR iNameType = 0 ) THEN

   DDS_CODE_VALIDATION_IMPORT ( PJOBID,'IND' ,'ENTITY_NAME_TYPE' ,0 ,VDBNAME ,0 ,PDAROWID,PMODULENAME,'NM' , 'DDS_CODE_VALIDATION_IMPORT' , VKEYCOLUMN ,'NAME_TYPE', VERRORTABLETOCHECK ,PERRORKEYCOLUMNVALUE , ICODEID ) ;
   iNameType := ICODEID ;
   END IF ; --- MKAUR24 END


  BEGIN
     EXECUTE IMMEDIATE 'SELECT NVL(EMPLOYEE_MATCH_BY_NAME, 0),
            NVL(EMPLOYEE_MATCH_BY_EMP_NUM, 0),
            NVL(EMPLOYEE_MATCH_BY_TAX_ID, 0),
            NVL(NON_EMP_MATCH_BY_NAME, 0),
            NVL(NON_EMP_MATCH_BY_TAX_ID, 0),
            NVL(CHK_CREATE_NEWENTITY, 0),   ---neha
            NVL(CHK_DUPLICATE_ENTITY, 0),   ---neha
            NVL(ALLOW_NEW_EMPLOYEES, 0),
            NVL(EMPLOYEE_MATCH_BY_DOB,0),
            NVL(NON_EMP_MATCH_BY_DOB,0)
       FROM DDS_OPTIONSET
       WHERE JOBID = :1 '  INTO oEmpMatchByName,
            oEmpMatchByEmpNum,
            oEmpMatchByTaxId,
            oNonEmpMatchByName,
            oNonEmpMatchByTaxId,
            oCreateNewEntity,
            oChkDupEntity,
            oCreateNewEmp,
            oEmpMatchByDob,
            oNonEmpMatchByDob
            USING pJobId;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       vCurrentErrorLoc := 'SYSERR3';
       vSysErrorMsg := 'No data found in dds_optionset table.';
       DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                            p_DA_ROW_ID => pDaRowId,
                            p_MODULE_NAME => pModuleName,
                            p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                            p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                            p_ERROR_PROC_NAME => vProcName,
                            p_ERROR_MSG => vSysErrorMsg,
                            p_ERROR_COLUMNS => NULL,
                            p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                            p_ERROR_KEY_COLUMN => vKeycolumn,
                            P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                            P_IS_VALIDATION => 0);
      vErrorCount := vErrorCount + 1;
    WHEN OTHERS THEN
       vCurrentErrorLoc := 'SYSERR4';
       vSysErrorMsg := SQLERRM;
       DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                              p_DA_ROW_ID => pDaRowId,
                              p_MODULE_NAME => pModuleName,
                              p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                              p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                              p_ERROR_PROC_NAME => vProcName,
                              p_ERROR_MSG => vSysErrorMsg,
                              p_ERROR_COLUMNS => NULL,
                              p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                              p_ERROR_KEY_COLUMN => vKeycolumn,
                              P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                              P_IS_VALIDATION => 0);
      vErrorCount := vErrorCount + 1;
   END ;
   nSql := NULL;
   nSqlAdd := NULL;


IF (vCurrentErrorLoc <> 'SYSERR3' OR vCurrentErrorLoc <> 'SYSERR4') -- START ONLY EXECUTE WHEN DDS OPTIONSET FOUND
  THEN
   BEGIN

   IF iForceCrtEnt <> 0  THEN --NEHA
    GOTO INSERTION;    --NEHA
   END IF;

         nSql := 'SELECT ENTITY_ID FROM ' || vDbName || 'ENTITY ';  --neha
         nSqlCount := 'SELECT COUNT(ENTITY_ID) FROM ' || vDbName || 'ENTITY ';  --neha

        -- nSql := 'SELECT ENTITY_ID,COUNT(ENTITY_ID) FROM ' || vDbName || 'ENTITY ';  neha

         IF R.vTableName = 'EMPLOYEES' THEN
            --neha changed started
            --IF iUseTaxId = 0 AND oEmpMatchByEmpNum = 0 AND oEmpMatchByName = 0 THEN  JIRA 27137 knakra
            IF iUseTaxId = 0 AND oEmpMatchByEmpNum = 0 AND oEmpMatchByName = 0 AND oEmpMatchByDob = 0 THEN
                  oEmpMatchByName:= 1;
                  oEmpMatchByTaxId:= 0;
            END IF;
            
            --JIRA 27137 knakra starts
            IF iUseDob = 0 AND oEmpMatchByEmpNum = 0 AND oEmpMatchByName = 0 AND oEmpMatchByTaxId = 0 THEN
               oEmpMatchByName := 1;
               oEmpMatchByDob := 0;
            END IF;
            --JIRA 27137 knakra ends
            --neha changed ended
            IF oEmpMatchByEmpNum <> 0 THEN
               IF r.vEmpNum IS NULL THEN
                  vErrorMsg := 'Match by Employee Number is selected but Employee Number is not given in import file.';
                  vErrorCount := vErrorCount + 1;
               ELSE
                  nSqlAdd := ', ' || vDbName || 'EMPLOYEE WHERE EMPLOYEE.EMPLOYEE_EID = ENTITY.ENTITY_ID AND EMPLOYEE_NUMBER = ''' || r.vEmpNum || ''' ';
               END IF;
            END IF;

            IF oEmpMatchByName <> 0 THEN
               IF R.vLastName IS NULL THEN
                  IF vErrorMsg IS NOT NULL THEN
                     vErrorMsg := vErrorMsg || '\n';
                     vErrorMsg := vErrorMsg || 'Match by Employee Name is selected but Employee Last Name is not given in import file.';
                  ELSE
                    vErrorMsg := 'Match by Employee Name is selected but Employee Last Name is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  IF nSqlAdd IS NULL THEN
                     nSqlAdd := ' WHERE LAST_NAME = ''' || r.vLastName || ''' ';
                  ELSE
                     nSqlAdd := nSqlAdd || ' AND LAST_NAME = ''' || r.vLastName || ''' ';
                  END IF;

                  IF r.vFirstName IS NOT NULL THEN
                     nSqlAdd := nSqlAdd || ' AND FIRST_NAME = ''' || r.vFirstName || ''' ';
                  END IF;
               END IF;
            END IF;

            IF oEmpMatchByTaxId <> 0 AND iUseTaxid = 1 THEN ---NEHA
               IF R.vTaxId IS NULL THEN
                  IF vErrorMsg is not null THEN
                     vErrorMsg := vErrorMsg || '\n';
                     vErrorMsg := vErrorMsg || 'Match by Employee TaxId is selected but Employee TaxId is not given in import file.';
                  ELSE
                      vErrorMsg := 'Match by Employee TaxId is selected but Employee TaxId is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  R.vTaxId := REPLACE(R.vTaxId, '-', '');
                  IF nSqlAdd IS NULL THEN
                     nSqlAdd := ' WHERE REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(R.vTaxId,'-','') || ''' ';   --Neha added replace
                  ELSE
                     nSqlAdd := nSqlAdd || ' AND REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(R.vTaxId,'-','') || ''' '; ----Neha added replace
                  END IF;
               END IF;
            END IF;
            
            --JIRA 27137 knakra starts
            IF oEmpMatchByDob <> 0 AND iUseDob = 1 THEN
               IF R.vBirthDate IS NULL THEN
                  IF vErrorMsg is not null THEN
                     vErrorMsg := vErrorMsg || '\n';
                     vErrorMsg := vErrorMsg || 'Match by Employee DOB is selected but Employee Birth Date is not given in import file.';
                  ELSE
                      vErrorMsg := 'Match by Employee DOB is selected but Employee Birth Date is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  IF nSqlAdd IS NULL THEN
                     nSqlAdd := ' WHERE BIRTH_DATE = ''' || R.vBirthDate || ''' ';
                  ELSE
                     nSqlAdd := nSqlAdd || ' AND BIRTH_DATE = ''' || R.vBirthDate || ''' ';
                  END IF;
               END IF;
            END IF;
            --JIRA 27137 knakra ends
            ---AKUMAR523 
			IF oCreateNewEmp= 1 THEN 
				oCreateNewEntity := 1;
			END IF ;
			---AKUMAR523
         ELSE
            --neha changed started
            --IF iUseTaxId = 0 AND oNonEmpMatchByName = 0 THEN    JIRA 27137 knakra
            IF iUseTaxId = 0 AND oNonEmpMatchByName = 0 AND oNonEmpMatchByDob = 0 THEN   --JIRA 27137 knakra
               oNonEmpMatchByName := 1;
               oNonEmpMatchByTaxId := 0;
            END IF;
            --neha changed ended
            
            --JIRA 27137 knakra starts
            IF iUseDob = 0 AND oNonEmpMatchByName = 0 AND oNonEmpMatchByTaxId = 0 THEN
               oNonEmpMatchByName := 1;
               oNonEmpMatchByDob := 0;
            END IF;
            --JIRA 27137 knakra ends
            
            IF oNonEmpMatchByName <> 0 THEN
               IF R.vLastName IS NULL THEN
                  IF vErrorMsg IS NOT NULL THEN
                     vErrorMsg := vErrorMsg || '\n';
                     vErrorMsg := vErrorMsg || 'Non Employee match by Name is selected but Non Employee Name is not given in import file.';
                  ELSE
                    vErrorMsg := 'Non Employee match by Name is selected but Non Employee Name is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  nSqlAdd := ' WHERE LAST_NAME = ''' || R.vLastName || ''' ';
                  IF R.vFirstName IS NOT NULL THEN
                     nSqlAdd := nSqlAdd || ' AND FIRST_NAME = ''' || R.vFirstName || ''' ';
                  END IF;
               END IF;
            END IF;

            IF oNonEmpMatchByTaxId <> 0 AND iUseTaxId = 1 THEN  --NEHA
               IF R.vTaxId IS NULL THEN
                  IF vErrorMsg IS NOT NULL THEN
                     vErrorMsg := vErrorMsg || '\n' || 'Non Employee match by TaxId is selected but Non Employee TaxId is not given in import file.';
                  ELSE
                     vErrorMsg := 'Non Employee match by TaxId is selected but Non Employee TaxId is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  IF nSqlAdd IS NULL THEN
                     nSqlAdd := 'WHERE REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(R.vTaxId,'-','') || ''' ';   --neha
                  ELSE
                     nSqlAdd := nSqlAdd || 'AND REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(R.vTaxId,'-','') || ''' ';   --neha
                  END IF;
               END IF;
            END IF;
            
            --JIRA 27137 knakra starts
            IF oNonEmpMatchByDob <> 0 AND iUseDob = 1 THEN
               IF R.vBirthDate IS NULL THEN
                  IF vErrorMsg IS NOT NULL THEN
                     vErrorMsg := vErrorMsg || '\n' || 'Non Employee match by DOB is selected but Non Employee Birth Date is not given in import file.';
                  ELSE
                     vErrorMsg := 'Non Employee match by DOB is selected but Non Employee Birth Date is not given in import file.';
                  END IF;
                  vErrorCount := vErrorCount + 1;
               ELSE
                  IF nSqlAdd IS NULL THEN
                     nSqlAdd := 'WHERE BIRTH_DATE = ''' || R.vBirthDate || ''' ';
                  ELSE
                     nSqlAdd := nSqlAdd || 'AND BIRTH_DATE = ''' || R.vBirthDate || ''' ';
                  END IF;
               END IF;
            END IF;
            --JIRA 27137 knakra ends
            
         END IF;

         nSql := nSql || nSqlAdd || ' AND DELETED_FLAG = 0 ';
         nSqlCount := nSqlCount || nSqlAdd || ' AND DELETED_FLAG = 0 ';  --neha

         IF iUseTableId <> 0 THEN
            nSql := nSql || ' AND ENTITY_TABLE_ID = ' || iTableId;
            nSqlCount := nSqlCount || ' AND ENTITY_TABLE_ID = ' || iTableId;  --neha
         END IF;

         --nSql := nSql || ' GROUP BY ENTITY_ID';   --neha

         IF vErrorCount>0 OR vErrorMsg IS NOT NULL THEN  ---ADDED BY NEHA
           RETURN;   ---NEHA
         END IF;

        -- EXECUTE IMMEDIATE nSql INTO iEntityId, iCount;  neha
          BEGIN
           EXECUTE IMMEDIATE nSql INTO iEntityId;   ---neha
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
                iEntityId:=0;
                --vErrorCount := vErrorCount + 1;
          WHEN OTHERS THEN
                iEntityId:=-1;
                vErrorCount := vErrorCount + 1;
          END;
          BEGIN
           EXECUTE IMMEDIATE nSqlCount INTO iCount;   ---neha
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
                iCount:=0;
                --vErrorCount := vErrorCount + 1;
          WHEN OTHERS THEN
                iCount:=-1;
                vSysErrorMsg:=sqlerrm;
                 vErrorMsg:=vSysErrorMsg;
                 iEntityId:=-1;
                vErrorCount := vErrorCount + 1;
          END;

   EXCEPTION
      WHEN OTHERS THEN
            vCurrentErrorLoc := 'SYSERR5';
            vSysErrorMsg := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                  p_DA_ROW_ID => pDaRowId,
                                  p_MODULE_NAME => pModuleName,
                                  p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                  p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                  p_ERROR_PROC_NAME => vProcName,
                                  p_ERROR_MSG => vSysErrorMsg,
                                  p_ERROR_COLUMNS => NULL,
                                  p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                  p_ERROR_KEY_COLUMN => vKeycolumn,
                                  P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                  P_IS_VALIDATION => 0);
             vErrorCount := vErrorCount + 1;
   END;

   IF oChkDupEntity = 1  AND iCount > 1 THEN
      iEntityId := 0; --log error here and exit
      IF vErrorMsg IS NOT NULL THEN
         vErrorMsg := vErrorMsg || '\n' || 'Duplicate Entity exists for the selected matching criteria.';
      ELSE
        vErrorMsg := 'Duplicate Entity exists for the selected matching criteria.';
      END IF;
      vErrorCount := vErrorCount + 1;
      RETURN;
   END IF;
---AKUMAR523 62518   
   IF ( iEntityId = 0 AND oCreateNewEntity = 0) AND (iForceCrtEnt = 0) THEN  --Entity not found and create new entity is also not checked
      IF vErrorMsg IS NOT NULL THEN
         vErrorMsg := vErrorMsg || '\n' || 'Entity not found with the matching criteria selected and create new entity check box is also not selected.';
      ELSE
        vErrorMsg := 'Entity not found with the matching criteria selected and create new entity check box is also not selected.';
      END IF;
      vErrorCount := vErrorCount + 1;
      RETURN;
   END IF;
  

   IF ( iEntityId = 0 AND oCreateNewEmp = 0 AND R.vTableName = 'EMPLOYEES' ) AND (iForceCrtEnt = 0) THEN
      IF vErrorMsg IS NOT NULL THEN
         vErrorMsg := vErrorMsg || '\n' || 'Employee not found with the matching criteria selected and create new employee check box is also not selected.';
      ELSE
        vErrorMsg := 'Employee not found with the matching criteria selected and create new employee check box is also not selected.';
      END IF;
      vErrorCount := vErrorCount + 1;
      RETURN;  --NEHA
   END IF;

 <<INSERTION>>
 IF ( iEntityId = 0 AND oCreateNewEntity = 1 ) OR ( iForceCrtEnt <> 0 ) THEN
    vLastNameSoundex := SOUNDEX(R.vLastName);
    IF R.vLastName LIKE'%''''%' OR R.vFirstName LIKE'%''''%' OR R.vAddr1 LIKE'%''''%'OR R.vAddr2 LIKE'%''''%'OR R.vComment LIKE'%''''%' THEN      --ddhupar JIRA 78172 STARTS
                  R.vLastName := REPLACE(R.vLastName, '''''','''');
                  R.vFirstName := REPLACE(R.vFirstName, '''''','''');
				  R.vAddr1 := REPLACE(R.vAddr1, '''''','''');
				  R.vAddr2 := REPLACE(R.vAddr2, '''''','''');
				  R.vComment := REPLACE(R.vComment, '''''','''');
    END IF;                                                        --ddhupar JIRA 78172 ENDS
  BEGIN
      nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
      EXECUTE IMMEDIATE NSQL INTO iEntityId USING 'ENTITY';
   EXCEPTION
     WHEN OTHERS THEN
           vCurrentErrorLoc := 'SYSERR7';
           vSysErrorMsg := SQLERRM;
           DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                 p_DA_ROW_ID => pDaRowId,
                                 p_MODULE_NAME => pModuleName,
                                 p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                 p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                 p_ERROR_PROC_NAME => vProcName,
                                 p_ERROR_MSG => vSysErrorMsg,
                                 p_ERROR_COLUMNS => NULL,
                                 p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                 p_ERROR_KEY_COLUMN => vKeycolumn,
                                 P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                 P_IS_VALIDATION => 0);
           vErrorCount := vErrorCount + 1;
    END;
	--ssnFormatt jira 77662
	IF (R.vTaxId != 0 AND R.vTaxId IS NOT NULL) THEN
	DDS_SSN_IMPORT(R.vTaxId, NVL(R.vState,0), vDbName, vFormattTaxid);
	R.vTaxId:= vFormattTaxid;
	END IF;
	--ssnFormatt

  IF vErrorCount = 0 THEN
         BEGIN
               nSql := 'INSERT INTO ' || vDbName || 'ENTITY(ENTITY_ID, LAST_NAME, LAST_NAME_SOUNDEX, FIRST_NAME, MIDDLE_NAME, ABBREVIATION, TAX_ID, ADDR1,';
               nSql := nSql || 'ADDR2, CITY, COUNTRY_CODE, STATE_ID, COUNTY, ZIP_CODE, PHONE1, PHONE2, FAX_NUMBER, SEX_CODE, BIRTH_DATE,';
               nSql := nSql || 'COMMENTS, PARENT_EID, ENTITY_TABLE_ID, REPORT_1099_FLAG, NAME_TYPE, DELETED_FLAG, SUFFIX_COMMON,';
               nSql := nSql || 'PREFIX,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER) VALUES(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12, :13,';
               nSql := nSql || ':14, :15, :16, :17, :18, :19,:20, :21, :22, :23, :24, :25, :26, :27, :28, :29, :30, :31)';

               EXECUTE IMMEDIATE NSQL USING iEntityId,
                             R.vLastName,
                             vLastNameSoundex,
                             R.vFirstName,
                             R.vMiddleName,
                             R.vAbbr,
                             R.vTaxId,
                             R.vAddr1,
                             R.vAddr2,
                             R.vCity,
                             NVL(R.vCountry,0),
                             NVL(R.vState,0),
                             R.vCounty,
                             R.vZip,
                             R.vPhone1,
                             R.vPhone2,
                             R.vFaxNumber,
                             NVL(R.vSexCode,0),
                             R.vBirthDate,
                             R.vComment,
                             NVL(R.iParentEid,0),
                             iTableId,
                             NVL(R.iRpt1099Flag,0),
                             NVL(R.iNameType,0),
                             0,
                             NVL(R.iSuffixCodeId,0),
                             NVL(R.iPrefixCodeId,0),
                             TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),
                             TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),
                             'DA DDS',
                             'DA DDS';

           BEGIN
              nSql := 'UPDATE ' || vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
              EXECUTE IMMEDIATE NSQL USING 'ENTITY';
           EXCEPTION
             WHEN OTHERS THEN
                   vCurrentErrorLoc := 'SYSERR8';
                   vSysErrorMsg := SQLERRM;
                                     vErrorMsg:=vSysErrorMsg;
                 iEntityId:=-1;
                   DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                         p_DA_ROW_ID => PDaRowId,
                                         p_MODULE_NAME => pModuleName,
                                         p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                         p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                         p_ERROR_PROC_NAME => vProcName,
                                         p_ERROR_MSG => vSysErrorMsg,
                                         p_ERROR_COLUMNS => NULL,
                                         p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                         p_ERROR_KEY_COLUMN => vKeycolumn,
                                         P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                         P_IS_VALIDATION => 0);
                   vErrorCount := vErrorCount + 1;
           END;
             COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
                  vCurrentErrorLoc := 'SYSERR9';
                  vSysErrorMsg := SQLERRM;
                  vErrorMsg:=vSysErrorMsg;
                 iEntityId:=-1;
                  DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                                        p_DA_ROW_ID => pDaRowId,
                                        p_MODULE_NAME => pModuleName,
                                        p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                                        p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                                        p_ERROR_PROC_NAME => vProcName,
                                        p_ERROR_MSG => vSysErrorMsg,
                                        p_ERROR_COLUMNS => NULL,
                                        p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                                        p_ERROR_KEY_COLUMN => vKeycolumn,
                                        P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                                        P_IS_VALIDATION => 0);
         END;
   END IF;
 END IF;
END IF; -- END ONLY EXECUTE WHEN DDS OPTIONSET FOUND
END LOOP;
EXCEPTION
  WHEN OTHERS THEN
  vCurrentErrorLoc := 'SYSERR10';
  vSysErrorMsg := SQLERRM;
  vErrorMsg:=vSysErrorMsg;
  iEntityId:=-1;
  DDS_ERROR_LOG_CAPTURE(p_JOBID => pJobId,
                       p_DA_ROW_ID => pDaRowId,
                       p_MODULE_NAME => pModuleName,
                       p_CALLING_ERROR_LOCATION => pCallingErrorLoc,
                       p_CURRENT_ERROR_LOCATION => vCurrentErrorLoc,
                       p_ERROR_PROC_NAME => vProcName,
                       p_ERROR_MSG => vSysErrorMsg,
                       p_ERROR_COLUMNS => NULL,
                       p_ERROR_TABLE_TO_CHECK => vErrorTableToCheck,
                       p_ERROR_KEY_COLUMN => vKeycolumn,
                       P_ERROR_COLUMN_KEY_VALUE => pErrorKeyColumnValue,
                       P_IS_VALIDATION => 0);
END PROCESS_ENTITY;
