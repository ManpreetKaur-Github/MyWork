CREATE OR REPLACE PROCEDURE DDS_PROCESS_ENHANCEDNOTES
(
  v_P_JOBID IN NUMBER DEFAULT NULL,
  v_P_DB_NAME IN VARCHAR2 DEFAULT NULL
)AUTHID CURRENT_USER
AS
     CURSOR v_CursorEnh IS SELECT * FROM DDS_ENHANCEDNOTES WHERE JOBID = v_P_JOBID AND INVALID_ROW = 1;
  --Import file columns variable starts 
  v_iDA_ROW_ID          NUMBER(10, 0);
  v_iJOBID              NUMBER(10, 0);
  v_iINVALID_ROW        NUMBER(10, 0);
  v_vID                 VARCHAR2(25);
  v_vCLAIM_OR_EVENT     VARCHAR2(1);
  v_vNOTE_TYPE          VARCHAR2(25);
  v_vUSER_TYPE          VARCHAR2(25);
  v_vNOTE_MEMO          VARCHAR2(4000);
  v_vENTERED_BY         VARCHAR2(50);
  v_vDATE_ENTERED       VARCHAR2(12);
  v_vDATE_CREATED       VARCHAR2(12);
  v_vTIME_CREATED       VARCHAR2(12);
  v_vENTERED_BY_NAME    VARCHAR2(50);
  v_vCLAIMANT_LASTNAME  VARCHAR2(255);
  v_vCLAIMANT_FIRSTNAME VARCHAR2(255);
  v_vCLAIMANT_SSN       VARCHAR2(20);
  v_vABBREVIATION       VARCHAR2(25);
  --Import file Columns variable ends 
  --UI Options Specific Variables starts 
  v_oEnhNotesClmtMatchByName  NUMBER(10, 0);
  v_oEnhNotesClmtMatchByTaxId NUMBER(10, 0);
  v_oEnhNotesClmtMatchByAbb   NUMBER(10, 0);
  v_oAllowNewCodes            NUMBER(10, 0);
  --UI Options Specific Variables ends 
  --Local Variables Declaration Starts 
  v_vDbName        VARCHAR2(100);
  v_iCurrentRow    NUMBER(10, 0);
  v_nSql           VARCHAR2(4000);
  v_vLocation      VARCHAR2(4000);
  v_vCareTechNote  VARCHAR2(4000);
  v_vErrMsgDesc    VARCHAR2(4000);
  v_iErrCount      NUMBER(10, 0);
  v_iClaimId       NUMBER(10, 0);
  v_iLob           NUMBER(10, 0);
  v_iEventId       NUMBER(10, 0);
  v_iCodeId        NUMBER(10, 0);
  v_iUserType      NUMBER(10, 0);
  v_iClPrgNoteID   NUMBER(10, 0);
  v_vSysDate       VARCHAR2(12);
  v_vSysTime       VARCHAR2(12);
  v_iClmntErr      NUMBER(10, 0);
  v_vErrColumns    VARCHAR2(4000);
  v_iClaimantId    NUMBER(10, 0);
  v_iClaimantRowId NUMBER(10, 0);
  v_vValidStrtDate VARCHAR2(8);
  v_vValidEndDate  VARCHAR2(8);
  v_vReqColumns    VARCHAR2(500);
  v_iPos           NUMBER(10, 0);
  v_vColName       VARCHAR2(100);
  v_vVal           VARCHAR2(4000);
  v_CheckTime      VARCHAR2(25);
  ---neha 33658 -- START 
  v_iRunStatCnt    NUMBER(10, 0):=1;  
  v_iRunCnt        NUMBER(10, 0):=1;  
  v_vProcessMsg    varchar2(4000); 
  v_iCount         NUMBER(10, 0) := 0; 
  ---neha 33658 -- end  
BEGIN
  --Local Variables Declaration ends  
  v_vDbName     := v_P_DB_NAME || '.';

  BEGIN --Neha Running status starts 33658
  SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_ENHANCEDNOTES WHERE JOBID = v_P_JOBID AND INVALID_ROW=1; 
   exception
    when no_data_found then
      null; 
  END; --Neha Running status ends 33658
  BEGIN
    SELECT NVL(ENHNOTES_CLMNT_NAME, 0),
           NVL(ENHNOTES_CLMNT_TAX, 0),
           NVL(ENHNOTES_CLMNT_ABBREVIATION, 0),
           NVL(ALLOW_NEW_CODES, 0),
           VALID_START_DATE,
           VALID_END_DATE
      INTO v_oEnhNotesClmtMatchByName,
           v_oEnhNotesClmtMatchByTaxId,
           v_oEnhNotesClmtMatchByAbb,
           v_oAllowNewCodes,
           v_vValidStrtDate,
 v_vValidEndDate FROM DDS_OPTIONSET WHERE JOBID = v_P_JOBID; 
  exception
    when no_data_found then
      null; 
  END;

  OPEN v_CursorEnh;
  loop
    FETCH v_CursorEnh
      INTO v_iDA_ROW_ID, v_iJOBID, v_iINVALID_ROW, v_vID, v_vCLAIM_OR_EVENT, v_vNOTE_TYPE, v_vUSER_TYPE, v_vNOTE_MEMO, v_vENTERED_BY, v_vDATE_ENTERED, v_vDATE_CREATED, v_vTIME_CREATED, v_vENTERED_BY_NAME, v_vCLAIMANT_LASTNAME, v_vCLAIMANT_FIRSTNAME, v_vCLAIMANT_SSN, v_vABBREVIATION;
    EXIT WHEN v_CursorEnh%NOTFOUND;
  
    v_iCurrentRow := 1;
  
    BEGIN
      BEGIN
        BEGIN
          --Re initializing local variables  
          v_iCurrentRow := v_iCurrentRow + 1;
        
          v_iClaimId       := 0;
          v_iLob           := 0;
          v_iEventId       := 0;
          v_iErrCount      := 0;
          v_iUserType      := 0;
          v_iClPrgNoteID   := 0;
          v_iClaimantId    := 0;
          v_iClaimantRowId := 0;
          v_iCodeId        := 0;
        
          v_vCareTechNote   := regexp_replace(v_vNOTE_MEMO, '<.*?>');
          v_vCLAIM_OR_EVENT := UPPER(v_vCLAIM_OR_EVENT);
        
          IF v_vID IS NULL THEN
            v_vErrMsgDesc := 'ID is a required field and can not be left empty, skipping record.';
          
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'ENHANCEDNOTES',
                                  'ValId',
                                  'ValId',
                                  'DDS_PROCESS_ENHANCEDNOTES',
                                  v_vErrMsgDesc,
                                  'ID',
                                  'DDS_ENHANCEDNOTES',
                                  'ID',
                                  v_vID,
                                  1);
          
            GOTO NEXTRECORD;
          END IF;
        
          IF v_vCLAIM_OR_EVENT IS NULL THEN
            v_vErrMsgDesc := 'CLAIM_OR_EVENT is a required field and cannot be left empty, skipping record.';
          
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'ENHANCEDNOTES',
                                  'ValClaimEvent',
                                  'ValClaimEvent',
                                  'DDS_PROCESS_ENHANCEDNOTES',
                                  v_vErrMsgDesc,
                                  'CLAIM_OR_EVENT',
                                  'DDS_ENHANCEDNOTES',
                                  'ID',
                                  v_vID,
                                  1);
          
            GOTO NEXTRECORD;
          END IF;
        
          IF (v_vCLAIM_OR_EVENT = 'C' OR v_vCLAIM_OR_EVENT = 'L') THEN
            v_nSql := 'SELECT CLAIM_ID,LINE_OF_BUS_CODE,EVENT_ID FROM ' ||
                      v_vDbName || 'CLAIM WHERE CLAIM_NUMBER =:1';
          
            BEGIN
            
 EXECUTE IMMEDIATE V_NSQL INTO v_iClaimId, v_iLob, v_iEventId USING v_vID; 
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_iClaimID := 0;
                v_iLob     := 0;
                v_iEventId := 0;
              WHEN OTHERS THEN
                v_vErrMsgDesc := SQLERRM || '. ';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'SysClaimEvent',
                                      'SysClaimEvent',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      'CLAIM_OR_EVENT',
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      0);
              
                v_iErrCount := v_iErrCount + 1;
            END;
          END IF;
        
          IF (v_iClaimId = 0) AND
             (v_vCLAIM_OR_EVENT = 'C' OR v_vCLAIM_OR_EVENT = 'L') THEN
            v_vErrMsgDesc := 'No CLAIM exist in the database with the Claim Number =' ||
                             v_vID || '.';
          
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'ENHANCEDNOTES',
                                  'ValClaim',
                                  'ValClaim',
                                  'DDS_PROCESS_ENHANCEDNOTES',
                                  v_vErrMsgDesc,
                                  'CLAIM_OR_EVENT',
                                  'DDS_ENHANCEDNOTES',
                                  'ID',
                                  v_vID,
                                  1);
          
            v_iErrCount := v_iErrCount + 1;
          END IF;
        
          IF (v_vCLAIM_OR_EVENT = 'E') THEN
            v_nSql := 'SELECT EVENT_ID FROM ' || v_vDbName ||
                      'EVENT WHERE EVENT_NUMBER =:1';
          
            BEGIN
              EXECUTE IMMEDIATE V_NSQL
                INTO v_iEventId
                USING v_vID;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_iClaimID := 0;
              WHEN OTHERS THEN
                v_vErrMsgDesc := SQLERRM || '. ';
              
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'SysEvent',
                                      'SysEvent',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      'CLAIM_OR_EVENT',
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      0);
              
                v_iErrCount := v_iErrCount + 1;
            END;
          END IF;
        
          IF (v_iEventId = 0) AND (v_vCLAIM_OR_EVENT = 'E') THEN
            v_vErrMsgDesc := 'No EVENT exist in the database with the Event Number =' ||
                             v_vID || '.';
          
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'ENHANCEDNOTES',
                                  'ValEvent',
                                  'ValEvent',
                                  'DDS_PROCESS_ENHANCEDNOTES',
                                  v_vErrMsgDesc,
                                  'CLAIM_OR_EVENT',
                                  'DDS_ENHANCEDNOTES',
                                  'ID',
                                  v_vID,
                                  1);
          
            v_iErrCount := v_iErrCount + 1;
          END IF;
        
          --------REQUIRED FIELD VALIDATION STARTS-------  
          v_vReqColumns := 'NOTE_TYPE|USER_TYPE|NOTE_MEMO|';
        
          WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE  
           LOOP
            v_iPos := INSTR(v_vReqColumns, '|', 1);
          
            v_vColName    := SUBSTR(v_vReqColumns,
                                    0,
                                    INSTR(v_vReqColumns, '|', 1) - 1);
            v_vReqColumns := SUBSTR(v_vReqColumns,
                                    LENGTH(SUBSTR(v_vReqColumns,
                                                  1,
                                                  INSTR(v_vReqColumns, '|', 1))) + 1,
                                    LENGTH(v_vReqColumns));
          
            v_vVal := (CASE WHEN v_vColName = 'NOTE_TYPE' THEN v_vNOTE_TYPE WHEN v_vColName = 'USER_TYPE' THEN v_vUSER_TYPE WHEN v_vColName = 'NOTE_MEMO' THEN v_vNOTE_MEMO END);
          
            IF v_vVal IS NULL THEN
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'ENHANCEDNOTES',
                                    'NullCheck',
                                    'NullCheck',
                                    'DDS_PROCESS_ENHANCEDNOTES',
                                    'Required Field is Null or Empty in Import file. ',
                                    v_vColName,
                                    'DDS_ENHANCEDNOTES',
                                    'ID',
                                    v_vID,
                                    1);
            
              v_iErrCount := v_iErrCount + 1;
            END IF;
          END LOOP;
        
          --------REQUIRED FIELD VALIDATION ENDS---------  
          --------CODE VALIDATION STARTS-----------------  
          IF (v_vNOTE_TYPE IS NOT NULL) THEN
            --If Note Type is not null then fetch the Code id from the codes table  
          
            DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                       v_vNOTE_TYPE,
                                       'NOTE_TYPE_CODE',
                                       v_oAllowNewCodes,
                                       v_vDbName,
                                       0,
                                       v_iDA_ROW_ID,
                                       'ENHANCEDNOTES',
                                       'NoteTypeValidate',
                                       'DDS_PROCESS_ENHANCEDNOTES',
                                       'ID',
                                       'NOTE_TYPE',
                                       'DDS_ENHANCEDNOTES',
                                       v_vID,
                                       v_iCodeId);
          
            IF (v_iCodeId = 0 OR v_iCodeId IS NULL) THEN
              v_iErrCount := v_iErrCount + 1;
            END IF;
          END IF;
        
          --------CODE VALIDATION ENDS-------------  
          --------USER TYPE VALIDATION STARTS------  
          IF (v_vUSER_TYPE IS NOT NULL) THEN
            v_nSql := 'SELECT GROUP_ID FROM ' || v_vDbName ||
                      'USER_GROUPS WHERE GROUP_NAME =:1';
          
            BEGIN
              EXECUTE IMMEDIATE V_NSQL
                INTO v_iUserType
                USING v_vUSER_TYPE;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_iUserType := 0;
              WHEN OTHERS THEN
                v_vErrMsgDesc := SQLERRM;
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'SysUserType',
                                      'SysUserType',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      'USER_TYPE',
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      0);
                v_iErrCount := v_iErrCount + 1;
            END;
          
            IF (v_iUserType = 0) THEN
              IF (v_vCLAIM_OR_EVENT = 'C' OR v_vCLAIM_OR_EVENT = 'L') THEN
                v_vErrMsgDesc := 'For Claim Number = ' || v_vID ||
                                 ', no user group exist with the USER TYPE = ' ||
                                 v_vUSER_TYPE || ' in the database.';
              ELSE
                v_vErrMsgDesc := 'For Event Number = ' || v_vID ||
                                 ', no user group exist with the USER TYPE = ' ||
                                 v_vUSER_TYPE || ' in the database.';
              END IF;
            
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'ENHANCEDNOTES',
                                    'ValUserType',
                                    'ValUserType',
                                    'DDS_PROCESS_ENHANCEDNOTES',
                                    v_vErrMsgDesc,
                                    'USER_TYPE',
                                    'DDS_ENHANCEDNOTES',
                                    'ID',
                                    v_vID,
                                    1);
            
              v_iErrCount := v_iErrCount + 1;
            END IF;
          END IF;
        
          --------USER TYPE VALIDATION ENDS------  
          --------TAX ID VALIDATION STARTS-------  
          IF (v_vCLAIM_OR_EVENT = 'L') AND (v_vCLAIMANT_SSN IS NOT NULL) AND
             ((LENGTH(REPLACE(v_vCLAIMANT_SSN, '-', '')) <> 9) OR
             DDS_IS_NUMBER(v_vCLAIMANT_SSN) = 0) THEN
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'ENHANCEDNOTES',
                                  'ValTaxID',
                                  'ValTaxID',
                                  'DDS_PROCESS_ENHANCEDNOTES',
                                  'Please provide a valid Claimant SSN. ',
                                  'CLAIMANT_SSN',
                                  'DDS_ENHANCEDNOTES',
                                  'ID',
                                  v_vID,
                                  1);
          
            v_iErrCount := v_iErrCount + 1;
          END IF;
        
          --------TAX ID VALIDATION ENDS-------  
          --------DATE VALIDATION STARTS-------  
          IF (v_vDATE_ENTERED IS NOT NULL) THEN
            IF dds_is_number(v_vDATE_ENTERED) = 0 OR
               LENGTH(v_vDATE_ENTERED) <> 8 OR
               dds_is_date(v_vDATE_ENTERED) = 0 THEN
              v_vErrMsgDesc := 'Invalid Date Format: ' || v_vDATE_ENTERED ||
                               ' provided in import file, it should be in YYYYMMDD format.';
            
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'ENHANCEDNOTES',
                                    'DateFormat1',
                                    'DateFormat1',
                                    'DDS_PROCESS_ENHANCEDNOTES',
                                    v_vErrMsgDesc,
                                    v_vDATE_ENTERED,
                                    'DDS_ENHANCEDNOTES',
                                    'ID',
                                    v_vID,
                                    1);
            
              v_iErrCount := v_iErrCount + 1;
            ELSE
              IF v_vDATE_ENTERED < v_vValidStrtDate OR
                 v_vDATE_ENTERED > v_vValidEndDate THEN
                v_vErrMsgDesc := 'Date provided: ' || v_vDATE_ENTERED ||
                                 ' is out of valid Date Range: ' ||
                                 v_vValidStrtDate || ' - ' ||
                                 v_vValidEndDate || '.';
              
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'DateFormat2',
                                      'DateFormat2',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      v_vDATE_ENTERED,
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      1);
              
                v_iErrCount := v_iErrCount + 1;
              END IF;
            END IF;
          END IF;
        
          IF (v_vDATE_CREATED IS NOT NULL) THEN
            IF dds_is_number(v_vDATE_CREATED) = 0 OR
               LENGTH(v_vDATE_CREATED) <> 8 OR
               dds_is_date(v_vDATE_CREATED) = 0 THEN
              v_vErrMsgDesc := 'Invalid Date Format: ' || v_vDATE_CREATED ||
                               ' provided in import file, it should be in YYYYMMDD format. ';
            
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'ENHANCEDNOTES',
                                    'DateFormat3',
                                    'DateFormat3',
                                    'DDS_PROCESS_ENHANCEDNOTES',
                                    v_vErrMsgDesc,
                                    v_vDATE_CREATED,
                                    'DDS_ENHANCEDNOTES',
                                    'ID',
                                    v_vID,
                                    1);
            
              v_iErrCount := v_iErrCount + 1;
            ELSE
              IF v_vDATE_CREATED < v_vValidStrtDate OR
                 v_vDATE_CREATED > v_vValidEndDate THEN
                v_vErrMsgDesc := 'Date provided: ' || v_vDATE_CREATED ||
                                 ' is out of valid Date Range: ' ||
                                 v_vValidStrtDate || ' - ' ||
                                 v_vValidEndDate || '.';
              
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'DateFormat4',
                                      'DateFormat4',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      v_vDATE_CREATED,
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      1);
              
                v_iErrCount := v_iErrCount + 1;
              END IF;
            END IF;
          END IF;
        
          --------DATE VALIDATION ENDS-------  
          --------TIME VALIDATION STARTS-----  
          IF (v_vTIME_CREATED IS NOT NULL) THEN
            BEGIN
              SELECT to_date(v_vTIME_CREATED, 'HH24MISS') TIME
                INTO v_CheckTime
                FROM DUAL;
            EXCEPTION
              WHEN OTHERS THEN
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      'TimeFormat',
                                      'TimeFormat',
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      'Invalid Time Format,Please provide the Time in HHNNSS format. ',
                                      v_vTIME_CREATED,
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      1);
              
                v_iErrCount := v_iErrCount + 1;
            END;
          
          END IF;
        
          --------TIME VALIDATION ENDS-----  
          ----GETTING CLAIMANTS ATTACHED WITH THE CLAIM----------  
          IF (v_iClaimId > 0 AND v_vCLAIM_OR_EVENT = 'L') THEN
            BEGIN
              v_iClmntErr := 0;
            
              v_nSql := 'SELECT CL.CLAIMANT_ROW_ID, CL.CLAIMANT_EID FROM ' ||
                        v_vDbName || 'CLAIMANT CL, ' || v_vDbName ||
                        'ENTITY E WHERE ';
              v_nSql := v_nSQL ||
                        'E.ENTITY_ID = CL.CLAIMANT_EID AND CL.CLAIM_ID = :1 ';
            
              v_vErrColumns := '';
            
              IF v_oEnhNotesClmtMatchByName <> 0 THEN
                IF v_vCLAIMANT_LASTNAME IS NULL THEN
                  v_vErrColumns := 'CLAIMANT_LASTNAME,';
                  v_iClmntErr   := 1;
                ELSE
                  v_nSql := v_nSql || ' AND E.LAST_NAME = ' || '''' ||
                            v_vCLAIMANT_LASTNAME || '''';
                  IF v_vCLAIMANT_FIRSTNAME IS NOT NULL THEN
                    v_nSql := v_nSQL || ' AND E.FIRST_NAME = ' || '''' ||
                              v_vCLAIMANT_FIRSTNAME || '''';
                  END IF;
                END IF;
              END IF;
            
              IF v_oEnhNotesClmtMatchByTaxId <> 0 THEN
                IF v_vCLAIMANT_SSN IS NULL THEN
                  v_vErrColumns := v_vErrColumns || 'CLAIMANT_SSN,';
                  v_iClmntErr   := 1;
                ELSE
                  v_nSql := v_nSQL ||
                            ' AND REPLACE(E.TAX_ID,''-'','''') = REPLACE(' || '''' ||
                            v_vCLAIMANT_SSN || '''' || ',''-'','''')';
                END IF;
              END IF;
            
              IF v_oEnhNotesClmtMatchByAbb <> 0 THEN
                IF v_vABBREVIATION IS NULL THEN
                  v_vErrColumns := v_vErrColumns || 'ABBREVIATION';
                  v_iClmntErr   := 1;
                ELSE
                  v_nSql := v_nSql || ' AND E.ABBREVIATION = ' || '''' ||
                            v_vABBREVIATION || '''';
                
                END IF;
              END IF;
            
              v_nSql := v_nSql || ' AND E.DELETED_FLAG = 0 AND ROWNUM = 1';
            
              IF substr(v_vErrColumns, -1, 1) = ',' THEN
                v_vErrColumns := SUBSTR(v_vErrColumns,
                                        0,
                                        LENGTH(v_vErrColumns) - 1);
              END IF;
            
              IF v_iClmntErr = 1 THEN
                v_vLocation   := 'ClaimantCheck';
                v_iErrCount   := v_iErrCount + 1;
                v_vErrMsgDesc := v_vErrColumns ||
                                 ' is selected in Match By criteria and no value is provided in the import file. ';
              
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      v_vLocation,
                                      v_vLocation,
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      v_vErrColumns,
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      1);
              
              ELSE
                BEGIN
                  EXECUTE IMMEDIATE V_NSQL
                    INTO v_iClaimantRowId, v_iClaimantId
                    USING v_iClaimId;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_iClaimantId := 0;
                END;
              
              END IF;
            
              IF (v_iClaimantId = 0) THEN
                --No Claimant is attached with the Claim Number  
                v_vLocation   := 'ValEntityClmt2';
                v_vErrMsgDesc := 'No Claimant is attached with the Claim Number =' ||
                                 v_vID || '.';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'ENHANCEDNOTES',
                                      v_vLocation,
                                      v_vLocation,
                                      'DDS_PROCESS_ENHANCEDNOTES',
                                      v_vErrMsgDesc,
                                      'ID',
                                      'DDS_ENHANCEDNOTES',
                                      'ID',
                                      v_vID,
                                      1);
              
                v_iErrCount := v_iErrCount + 1;
              END IF;
            
            END;
          END IF;
        
          ----------IMPORT STARTS-----------  
          v_vSysDate := TO_CHAR(SYSDATE, 'YYYYMMDD'); --- YYYYMMDD format  
          v_vSysTime := TO_CHAR(SYSTIMESTAMP, 'HH24MISS'); ---HHNNSS format  
        
          IF (v_iErrCount = 0) THEN
            BEGIN
              BEGIN
                v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName ||
                          'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
              
                EXECUTE IMMEDIATE V_NSQL
                  INTO v_iClPrgNoteID
                  USING 'CLAIM_PRG_NOTE';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_iClPrgNoteID := 1;
                WHEN OTHERS THEN
                  v_vLocation   := 'SysNextUnqID';
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'ENHANCEDNOTES',
                                        v_vLocation,
                                        v_vLocation,
                                        'DDS_PROCESS_ENHANCEDNOTES',
                                        v_vErrMsgDesc,
                                        'NEXTID',
                                        'DDS_ENHANCEDNOTES',
                                        'ID',
                                        v_vID,
                                        0);
                
              END;
            
              BEGIN
                BEGIN
                  IF (v_iClPrgNoteID > 0) THEN
                    BEGIN
                      v_nSql := 'INSERT INTO ' || v_vDbName ||
                                'CLAIM_PRG_NOTE(CL_PROG_NOTE_ID,CLAIM_ID,EVENT_ID,ENTERED_BY,DATE_ENTERED,DATE_CREATED,TIME_CREATED,';
                      v_nSql := v_nSql ||
                                ' ATTACH_TABLE,ATTACH_RECORD_ID,TEMPLATE_ID,POLICY_ID,';
                      v_nSql := v_nSql ||
                                ' NOTE_TYPE_CODE,USER_TYPE_CODE,NOTE_MEMO,NOTE_MEMO_CARETECH,ENTERED_BY_NAME) VALUES(';
                      v_nSql := v_nSql || v_iClPrgNoteID || ',';
                    
                      IF (v_vCLAIM_OR_EVENT = 'C') THEN
                        v_nSql := v_nSql || v_iClaimId || ',' || v_iEventId || ',';
                      ELSE
                        v_nSql := v_nSql || ' 0,' || v_iEventId || ',';
                      END IF;
                    
                      IF (v_vENTERED_BY IS NOT NULL) THEN
                        v_nSql := v_nSql || '''' || v_vENTERED_BY || '''' || ',';
                      ELSE
                        v_nSql := v_nSql || '''DADDS'',';
                      
                      END IF;
                    
                      IF (v_vDATE_ENTERED IS NOT NULL) THEN
                        v_nSql := v_nSql || '''' || v_vDATE_ENTERED || '''' || ',';
                      
                      ELSE
                        v_nSql := v_nSql || '''' || v_vSysDate || '''' || ',';
                      
                      END IF;
                    
                      IF (v_vDATE_CREATED IS NOT NULL) THEN
                        v_nSql := v_nSql || '''' || v_vDATE_CREATED || '''' || ',';
                      
                      ELSE
                        v_nSql := v_nSql || '''' || v_vSysDate || '''' || ',';
                      
                      END IF;
                    
                      IF (v_vTIME_CREATED IS NOT NULL) THEN
                        v_nSql := v_nSql || '''' || v_vTIME_CREATED || '''' || ',';
                      
                      ELSE
                        v_nSql := v_nSql || '''' || v_vSysTime || '''' || ',';
                      
                      END IF;
                    
                      IF (v_vCLAIM_OR_EVENT = 'C') THEN
                        v_nSql := v_nSql || '''CLAIM'',' || v_iClaimId || ',';
                      ELSE
                        IF (v_vCLAIM_OR_EVENT = 'E') THEN
                          v_nSql := v_nSql || '''EVENT'',' || v_iEventId || ',';
                        ELSE
                          v_nSql := v_nSql || '''CLAIMANT'',' ||
                                    v_iClaimantRowId || ',';
                        END IF;
                      END IF;
                    
                      v_nSql := v_nSql || '0,0,' || v_iCodeId || ',' ||
                                v_iUserType || ',' || '''' || v_vNOTE_MEMO || '''' || ',' || '''' ||
                                v_vCareTechNote || '''' || ',';
                    
                      IF (v_vENTERED_BY_NAME IS NOT NULL) THEN
                        v_nSql := v_nSql || '''' || v_vENTERED_BY_NAME || '''' || ')';
                      ELSE
                        v_nSql := v_nSql || '''DADDS'')';
                      
                      END IF;
                      v_vLocation := 'SysImportNote';
                    
                    END;
                  END IF;
                
                  EXECUTE IMMEDIATE v_nSql;
                  v_vLocation := 'UpdateGlossary';
                
                  v_nSql := 'UPDATE ' || v_vDbName ||
                            'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                
                  execute immediate v_nsql
                    using 'CLAIM_PRG_NOTE';
                
                  EXECUTE IMMEDIATE ' UPDATE DDS_ENHANCEDNOTES SET INVALID_ROW = 0 WHERE JOBID = ' ||
                                    v_P_JOBID || ' AND DA_ROW_ID = ' ||
                                    v_iDA_ROW_ID;
                
                  COMMIT;
                END;
              EXCEPTION
                WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM || '. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'ENHANCEDNOTES',
                                        v_vLocation,
                                        v_vLocation,
                                        'DDS_PROCESS_ENHANCEDNOTES',
                                        v_vErrMsgDesc,
                                        'IMPORT',
                                        'DDS_ENHANCEDNOTES',
                                        'ID',
                                        v_vID,
                                        0);
              END;
            
            END;
          END IF;
        
        END;
      EXCEPTION
        WHEN OTHERS THEN
          -------------IMPORT ENDS-----------------  
          v_vLocation   := 'SysLocation1';
          v_vErrMsgDesc := SQLERRM;
          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                v_iDA_ROW_ID,
                                'ENHANCEDNOTES',
                                v_vLocation,
                                v_vLocation,
                                'DDS_PROCESS_ENHANCEDNOTES',
                                v_vErrMsgDesc,
                                'EXCEPTION',
                                'DDS_ENHANCEDNOTES',
                                'ID',
                                v_vID,
                                0);
      END;
    
      <<NEXTRECORD>>
    
      ---Neha Running status code starts 33658--- 
      --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);  
      v_vLocation := 'Running_Status';
      IF v_iRunStatCnt = 1 THEN
        BEGIN
          v_vProcessMsg := 'Total Number of Records processed in Enhanced Notes : ' ||v_iRunStatCnt;
          EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
          USING v_P_JOBID, v_vProcessMsg, 'ENHANCEDNOTES_RUN', 'DDS_ENHANCEDNOTES_RUN', -11;
        END;
      ELSIF v_iRunCnt = 1000 THEN
          BEGIN
            v_vProcessMsg := 'Total Number of Records processed in Enhanced Notes : ' ||v_iRunStatCnt;
            v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
            MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
            EXECUTE IMMEDIATE v_nsql using v_vProcessMsg, v_P_JOBID, 'ENHANCEDNOTES_RUN', 'DDS_ENHANCEDNOTES_RUN';
            v_iRunCnt:=1;
          END;
         ELSIF (v_iCount=v_iRunStatCnt) THEN
              BEGIN
              v_vProcessMsg := 'Total Number of Records processed in Enhanced Notes : ' ||v_iCount;
              v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
              MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
  
             EXECUTE IMMEDIATE v_nSql using v_vProcessMsg, v_P_JOBID, 'ENHANCEDNOTES_RUN', 'DDS_ENHANCEDNOTES_RUN';
             END;
      END IF;
      COMMIT;
    
      v_iRunStatCnt := v_iRunStatCnt + 1;
      v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658---  
    
    END;
  END LOOP;
  --While loop ends
  CLOSE v_CursorEnh;

  DDS_PROCESS_LOG(v_P_JOBID, 'ENHANCEDNOTES', 'DDS_ENHANCEDNOTES');
exception
  WHEN OTHERS THEN
    v_vLocation   := 'Main';
    v_vErrMsgDesc := SQLERRM;
    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                          v_iDA_ROW_ID,
                          'ENHANCEDNOTES',
                          v_vLocation,
                          v_vLocation,
                          'DDS_PROCESS_ENHANCEDNOTES',
                          v_vErrMsgDesc,
                          'EXCEPTION',
                          'DDS_ENHANCEDNOTES',
                          'ID',
                          v_vID,
                          0);
END DDS_PROCESS_ENHANCEDNOTES;
