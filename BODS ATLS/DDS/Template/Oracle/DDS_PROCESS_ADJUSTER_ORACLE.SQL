CREATE OR REPLACE PROCEDURE PROCESS_ADJUSTER
(
  v_P_JOBID IN NUMBER DEFAULT NULL ,
  v_P_DBNAME IN VARCHAR2 DEFAULT NULL ,
  v_P_USERID IN NUMBER DEFAULT NULL
)--AUTHID DEFINER
AUTHID CURRENT_USER
AS
   --import file variables start
   v_V_RECORD_TYPE VARCHAR2(25);
   v_V_CLAIM_ID VARCHAR2(20);
   v_V_DATE VARCHAR2(8);
   v_V_TIME VARCHAR2(6);
   v_V_FIRSTNAME VARCHAR2(255);
   v_V_LASTNAME VARCHAR2(255);
   v_V_TEXT VARCHAR2(255);
   v_V_ADJUSTER_TYPE VARCHAR2(25);
   v_V_NAME_TYPE VARCHAR2(25);
   --import file variable ends
   --local variables starts
   v_iDaRowId NUMBER(10,0);
   v_iInvalidRow NUMBER(10,0);
   v_vReqColumns VARCHAR2(4000);
   v_vCodeFields VARCHAR2(4000);
   v_vSysTableName VARCHAR2(4000);
   v_vSysTableList VARCHAR2(4000);
   v_iCodeId NUMBER(10,0);
   v_iAdjType NUMBER(10,0);
   v_iNameType NUMBER(10,0);
   v_iClaimId NUMBER(10,0);
   v_iCurRow NUMBER(10,0);
   v_iTotalRows NUMBER(10,0);
   v_vDbName VARCHAR2(4000);
   v_iErrCnt NUMBER(10,0);
   v_vVal VARCHAR2(255);
   v_vColName VARCHAR2(4000);
   v_nSql VARCHAR2(32000);
   v_iLob NUMBER(10,0);
   v_vErrMsgDesc VARCHAR2(4000);
   v_iRecordType NUMBER(10,0);
   v_iAdjEiD NUMBER(10,0);
   v_nSql2 VARCHAR2(32000);
   VENTITY_TYPE  DDS_ENTITY_TYPE; -- KAPIL
   v_iPiRowId NUMBER(10,0);
   v_iClaimantRowId NUMBER(10,0);
   v_iEroleFlag NUMBER(10,0);
   v_iAdjRowId NUMBER(10,0);
   v_vText VARCHAR2(4000);
   v_vString VARCHAR2(4000);
   v_iAdjTextRowId NUMBER(10,0);
   v_iBaseErrCnt NUMBER(10,0);
   V_vSysDateTime VARCHAR2(14);
   v_vLocation VARCHAR2(150);
   v_CheckTime VARCHAR2(14);
  ---neha 33658 -- START 
  v_iRunStatCnt    NUMBER(10, 0):=1;  
  v_iRunCnt        NUMBER(10, 0):=1;  
  v_vProcessMsg    varchar2(4000); 
  v_iCount         NUMBER(10, 0) := 0; 
  ---neha 33658 -- end
   --local variables ends
   --Optionset Variables starts
   v_oAllowNewCodes NUMBER(10,0);
   v_oEmpMatchByEmpNum NUMBER(10,0);
   v_oEmpMatchByName NUMBER(10,0);
   v_oEmpMatchByTaxId NUMBER(10,0);
   v_oNonEmpMatchByName NUMBER(10,0);
   v_oNonEmpMatchByTaxId NUMBER(10,0);
   v_oConfigId NUMBER(10,0);
   v_vValidStrtDate VARCHAR2(8);
   v_vValidEndDate VARCHAR2(8);
   v_oCurAdjFlag NUMBER(10,0);
   v_vCountText NUMBER(10,0) :=0;    --ddhupar JIRA 78172
   CURSOR  v_AdjCursor IS
      SELECT DA_ROW_ID,
INVALID_ROW,
RECORD_TYPE,
CLAIM_ID,
ADJ_DATE,
ADJ_TIME,
FIRST_NAME,
LAST_NAME,
TEXT,
ADJUSTER_TYPE,
NAME_TYPE
        FROM DDS_ADJUSTER
         WHERE JOBID = v_P_JOBID
                 AND INVALID_ROW = 1;


BEGIN
   --Optionset Variables ends
   v_vDbName := v_P_DBNAME || '.';

   SELECT NVL(ALLOW_NEW_CODES, 0),
          NVL(EMPLOYEE_MATCH_BY_EMP_NUM, 0),
          NVL(EMPLOYEE_MATCH_BY_NAME, 0),
          NVL(EMPLOYEE_MATCH_BY_TAX_ID, 0),
          NVL(NON_EMP_MATCH_BY_NAME, 0),
          NVL(NON_EMP_MATCH_BY_TAX_ID, 0),
          CONFIG_ID,
          VALID_START_DATE,
          VALID_END_DATE,
          NVL(SET_ADJUSTER_AS_CURRENT, 0)
     INTO v_oAllowNewCodes,
          v_oEmpMatchByEmpNum,
          v_oEmpMatchByName,
          v_oEmpMatchByTaxId,
          v_oNonEmpMatchByName,
          v_oNonEmpMatchByTaxId,
          v_oConfigId,
          v_vValidStrtDate,
          v_vValidEndDate,
          v_oCurAdjFlag
     FROM DDS_OPTIONSET
      WHERE JOBID = v_P_JOBID;
   BEGIN --Neha Running status starts 33658
  SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_ADJUSTER WHERE JOBID = v_P_JOBID AND INVALID_ROW=1; 
   exception
    when no_data_found then
      null; 
  END; --Neha Running status ends 33658

   v_vLocation := 'Erole';
   v_iBaseErrCnt := 0;
  BEGIN
      v_nSql := 'SELECT STR_PARM_VALUE FROM ' || v_vDbName || 'PARMS_NAME_VALUE WHERE PARM_NAME = :1';
   EXECUTE IMMEDIATE V_NSQL INTO v_iEroleFlag USING 'USE_ENTITY_ROLE';

   EXCEPTION
    WHEN OTHERS THEN
      v_vErrMsgDesc := SQLERRM;
      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                            v_iDaRowId,
                            'DDS_ADJUSTER',
                            'eRoleFlagErr',
                            'eRoleFlagErr',
                            'PROCESS_ADJUSTER',
                            v_vErrMsgDesc,
                            'CLAIM_ID',
                            'DDS_ADJUSTER',
                            'CLAIM_ID',
                            v_V_CLAIM_ID,
                            0);
       v_iBaseErrCnt := v_iBaseErrCnt + 1;
   END;



   v_vLocation := 'CursorOpen';
   OPEN v_AdjCursor;
   LOOP
   FETCH v_AdjCursor INTO v_iDaRowId,v_iInvalidRow,v_V_RECORD_TYPE,v_V_CLAIM_ID,v_V_DATE,v_V_TIME,v_V_FIRSTNAME,v_V_LASTNAME,v_V_TEXT,v_V_ADJUSTER_TYPE,v_V_NAME_TYPE;
   EXIT WHEN v_AdjCursor%NOTFOUND;

  -- WHILE v_iCurRow <= v_iTotalRows
   --LOOP
      BEGIN
         v_iErrCnt := 0;
         v_iAdjType := 0;
         v_iNameType := 0;
         v_iClaimantRowId := 0;
         v_iClaimId := 0;
         v_iLob := 0;
         v_iRecordType := 0;
         v_iAdjEiD := 0;
         v_iPiRowId := 0;
         v_iAdjRowId := 0;
         v_vText := NULL;
         v_vString := NULL;
         v_iAdjTextRowId := 0;

         v_vLocation := 'ClaimIdNull';
         IF v_V_CLAIM_ID IS NULL THEN
            v_vErrMsgDesc := 'Claim Id is a mandatory field and can not be left blank, skipping record.';
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDaRowId,
                                  'DDS_ADJUSTER',
                                  'ClaimIdBlank',
                                  'ClaimIdBlank',
                                  'PROCESS_ADJUSTER',
                                  v_vErrMsgDesc,
                                  v_vColName,
                                  'DDS_ADJUSTER',
                                  'CLAIM_ID',
                                  v_V_CLAIM_ID,
                                  1);

            GOTO NEXTRECORD;
         END IF;

         v_vLocation := 'ReqColumns';
         v_vReqColumns := 'RECORD_TYPE|LAST_NAME|';

         WHILE INSTR(v_vReqColumns, '|', 1) > 0
         LOOP
            BEGIN
              -- v_vColName := SUBSTR(v_vReqColumns, 0, INSTR(v_vReqColumns, '|', 1) - 1);
               --v_vReqColumns := SUBSTR(v_vReqColumns, -1, LENGTH(v_vReqColumns) - INSTR(v_vReqColumns, '|', 1));

               v_vColName := SUBSTR(v_vReqColumns, 0, INSTR(v_vReqColumns, '|', 1) - 1);
               v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)))+1,LENGTH(v_vReqColumns));

               v_nSql := 'SELECT ' || v_vColName || ' FROM DDS_ADJUSTER WHERE JOBID = :1 AND DA_ROW_ID = :2';

               --BEGIN

               BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO v_vVal USING v_P_JOBID,v_iDaRowId;
               EXCEPTION
                  WHEN NO_DATA_fOUND THEN
                       v_vVal := NULL;
               END;

               IF v_vVal IS NULL THEN
                  v_vErrMsgDesc := 'Required field is null or empty in the import file.';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDaRowId,
                                        'DDS_ADJUSTER',
                                        'ReqCol',
                                        'ReqCol',
                                        'PROCESS_ADJUSTER',
                                        v_vErrMsgDesc,
                                        v_vColName,
                                        'DDS_ADJUSTER',
                                        'CLAIM_ID',
                                        v_V_CLAIM_ID,
                                        1);

                  v_iErrCnt := v_iErrCnt + 1;
               END IF;
/*               EXCEPTION
                  WHEN OTHERS THEN
                        v_vErrMsgDesc := SQLERRM;
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDaRowId,
                                              'DDS_ADJUSTER',
                                              'ReqColErr',
                                              'ReqColErr',
                                              'PROCESS_ADJUSTER',
                                              v_vErrMsgDesc,
                                              v_vColName,
                                              'DDS_ADJUSTER',
                                              'CLAIM_ID',
                                              v_V_CLAIM_ID,
                                              0);

                        v_iErrCnt := v_iErrCnt + 1;
               END;
*/            END;
         END LOOP;

         v_vLocation := 'CodeFields';
         v_vCodeFields := 'RECORD_TYPE|ADJUSTER_TYPE|NAME_TYPE|';
         v_vSysTableList := 'ADJ_TEXT_TYPE|CLAIM_ADJUSTER_TYPE|ENTITY_NAME_TYPE|';

         WHILE INSTR(v_vCodeFields, '|', 1) > 0
         LOOP
            BEGIN
/*               v_vColName := SUBSTR(v_vCodeFields, 0, INSTR(v_vCodeFields, '|', 1) - 1);
               v_vCodeFields := SUBSTR(v_vCodeFields, -1, LENGTH(v_vCodeFields) - INSTR(v_vCodeFields, '|', 1));
*/
               v_vColName := SUBSTR(v_vCodeFields, 0, INSTR(v_vCodeFields, '|', 1) - 1);
               v_vCodeFields := SUBSTR(v_vCodeFields,LENGTH(SUBSTR(v_vCodeFields,1,INSTR(v_vCodeFields, '|', 1)))+1,LENGTH(v_vCodeFields));


               --v_vSysTableName := SUBSTR(v_vSysTableList, 0, INSTR(v_vSysTableList, '|', 1) - 1);
               --v_vSysTableList := SUBSTR(v_vSysTableList, -1, LENGTH(v_vSysTableList) - INSTR(v_vSysTableList, '|', 1));

               v_vSysTableName := SUBSTR(v_vSysTableList, 0, INSTR(v_vSysTableList, '|', 1) - 1);
               v_vSysTableList := SUBSTR(v_vSysTableList,LENGTH(SUBSTR(v_vSysTableList,1,INSTR(v_vSysTableList, '|', 1)))+1,LENGTH(v_vSysTableList));


               v_vVal := (CASE
                               WHEN v_vColName = 'RECORD_TYPE' THEN v_V_RECORD_TYPE
                               WHEN v_vColName = 'ADJUSTER_TYPE' THEN v_V_ADJUSTER_TYPE
                               WHEN v_vColName = 'NAME_TYPE' THEN v_V_NAME_TYPE   END);

               IF v_vVal IS NOT NULL --AND v_vVal <> ''
                 THEN
                  DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                             v_vVal,
                                             v_vSysTableName,
                                             v_oAllowNewCodes,
                                             v_vDbName,
                                             v_iLob,
                                             v_iDaRowId,
                                             'PAYMENT',
                                             'CodeValidate',
                                             'DDS_PROCESS_PAYMENTS',
                                             'CLAIM_ID',
                                             v_vColName,
                                             'DDS_PAYMENT',
                                             v_V_CLAIM_ID,
                                             v_iCodeId);

                  IF ( v_iCodeId = 0
                    OR v_iCodeId IS NULL ) THEN
                     v_iErrCnt := v_iErrCnt + 1;
                  END IF;
               END IF;

               IF v_vColName = 'RECORD_TYPE' THEN
                  v_iRecordType := v_iCodeId;
               ELSE
                  IF v_vColName = 'ADJUSTER_TYPE' THEN
                     v_iAdjType := v_iCodeId;
                  ELSE
                     IF v_vColName = 'NAME_TYPE' THEN
                        v_iNameType := v_iCodeId;
                     END IF;
                  END IF;
               END IF;

               v_iCodeId := NULL;
            END;
         END LOOP;

         v_vLocation := 'DateChck';
         IF DDS_IS_DATE(v_V_DATE) = 0 AND v_V_DATE IS NOT NULL THEN
            v_vErrMsgDesc := 'Invalid Date format: ' || v_V_DATE || ', it should be in YYYYMMDD format. ';
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
            v_iDaRowId,
            'DDS_ADJUSTER',
            'ClmNotExistErr',
            'ClmNotExistErr',
            'PROCESS_ADJUSTER',
            v_vErrMsgDesc,
            'ADJ_DATE',
            'DDS_ADJUSTER',
            'CLAIM_ID',
            v_V_CLAIM_ID,
            1);
            v_iErrCnt := v_iErrCnt + 1;
         ELSIF v_V_DATE IS NOT NULL AND DDS_IS_DATE(v_V_DATE) = 1 THEN
            IF v_V_DATE < v_vValidStrtDate OR v_V_DATE > v_vValidEndDate THEN
               v_vErrMsgDesc := 'Date provided: ' || v_V_DATE || ', is out of the specified range: ' || v_vValidStrtDate || ' - ' || v_vValidEndDate || '. ';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                v_iDaRowId,
                'DDS_ADJUSTER',
                'ClmNotExistErr',
                'ClmNotExistErr',
                'PROCESS_ADJUSTER',
                v_vErrMsgDesc,
                'ADJ_DATE',
                'DDS_ADJUSTER',
                'CLAIM_ID',
                v_V_CLAIM_ID,
                1);
                v_iErrCnt := v_iErrCnt + 1;
            END IF;
         END IF;

         --JIRA 24865 knakra starts
         IF v_V_TIME IS NOT NULL THEN
            BEGIN
                           SELECT to_date(v_V_TIME,'HH24MISS')TIME
                             INTO v_CheckTime
                             FROM DUAL ;
                     EXCEPTION
                        WHEN OTHERS THEN
                              --V_ERROR_MESSAGE := SQLERRM;
                              v_vErrMsgDesc := 'Time provided: ' || v_V_TIME || ', is not valid. ';
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDaRowId,
                                        'DDS_ADJUSTER',
                                        'TimeFormat',
                                        'TimeFormat',
                                        'PROCESS_ADJUSTER',
                                        v_vErrMsgDesc,
                                        'ADJ_TIME',
                                        'DDS_ADJUSTER',
                                        'CLAIM_ID',
                                        v_V_CLAIM_ID,
                                        1);
    v_iErrCnt := v_iErrCnt + 1;
            END;
         END IF;
         --JIRA 24865 knakra ends

         v_vLocation := 'ClmIdChk';
         v_nSql := 'SELECT CLAIM_ID FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_NUMBER = :1';

            BEGIN
                EXECUTE IMMEDIATE v_nSql INTO v_iClaimId USING v_V_CLAIM_ID;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_iClaimId:= NULL;
              WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDaRowId,
                                        'DDS_ADJUSTER',
                                        'ClmNotExistErr',
                                        'ClmNotExistErr',
                                        'PROCESS_ADJUSTER',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_ADJUSTER',
                                        'CLAIM_ID',
                                        v_V_CLAIM_ID,
                                        0);
                  GOTO NEXTRECORD;
              END;
               IF v_iClaimId IS NULL OR v_iClaimId = 0 THEN
                  v_vErrMsgDesc := 'Claim Number: ' || v_V_CLAIM_ID || ' does not exist, skipping record. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDaRowId,
                                        'DDS_ADJUSTER',
                                        'ClaimNotExist',
                                        'ClaimNotExist',
                                        'PROCESS_ADJUSTER',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_ADJUSTER',
                                        'CLAIM_ID',
                                        v_V_CLAIM_ID,
                                        1);

                  GOTO NEXTRECORD;
               END IF;

         v_vErrMsgDesc := NULL;

         v_vLocation := 'EntType';

         VENTITY_TYPE := DDS_ENTITY_TYPE(v_V_LASTNAME,
                                                  v_V_FIRSTNAME,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  0,
                                                  'ADJUSTERS',
                                                  0,
                                                  NULL,
                                                  NULL, --NULL, v_iNameType, v_vEMP_NUM
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  v_P_JOBID,
                                                  v_iDaRowId
                                                   );

                      PROCESS_ENTITY(VENTITY_TYPE,
                            v_P_JOBID,
                            v_iDaRowId,
                            v_vDbName,
                            'ADJUSTER',
                            0,
                            0,
                            'AdjEnt',
                            v_V_CLAIM_ID,
                            0,                     --JIRA 27366 knakra
                            v_iAdjEiD,
                            v_vErrMsgDesc);


         /*INSERT INTO tt_v_utAdjuster
           ( iJobId, iDaRowId, vLastName, vFirstName )
           VALUES ( v_P_JOBID, v_iDaRowId, v_V_LASTNAME, v_V_FIRSTNAME );

         PROCESS_ENTITY(v_utAdjuster,
                        v_P_JOBID,
                        v_iDaRowId,
                        v_vDbName,
                        'ADJUSTER',
                        0,
                        0,
                        'AdjEnt',
                        v_V_CLAIM_ID,
                        v_iAdjEiD,
                        v_vErrMsgDesc);
*/
         IF v_iAdjEiD IS NULL OR v_iAdjEiD = 0 THEN
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDaRowId,
                                  'DDS_ADJUSTER',
                                  'AdjEntity',
                                  'AdjEntity',
                                  'PROCESS_ADJUSTER',
                                  v_vErrMsgDesc,
                                  'LAST_NAME, FIRST_NAME',
                                  'DDS_ADJUSTER',
                                  'CLAIM_ID',
                                  v_V_CLAIM_ID,
                                  1);

            v_iErrCnt := v_iErrCnt + 1;
         ELSE

            IF v_iEroleFlag IS NOT NULL AND v_iEroleFlag <> 0 THEN
            BEGIN
               v_vLocation := 'RoleExcErrChk';
               v_nSql := ' FROM ' || v_vDbName || 'CODE_X_CODE CXC, ' || v_vDbName || 'CODES C, ' || v_vDbName || 'GLOSSARY G';
               v_nSql := v_nSql || ' WHERE CXC.REL_TYPE_CODE = C.CODE_ID AND';
               v_nSql := v_nSql || ' C.TABLE_ID = G.TABLE_ID AND ';
               v_nSql := v_nSql || ' G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE'' AND';
               v_nSql := v_nSql || ' C.SHORT_CODE = ''RECRT'' AND';
               v_nSql := v_nSql || ' CXC.DELETED_FLAG = 0 AND';
               v_nSql := v_nSql || ' CXC.CODE2 = (SELECT TABLE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''ADJUSTERS'')';

               v_nSql2 := 'SELECT PI_ROW_ID FROM ' || v_vDbName || 'PERSON_INVOLVED WHERE PARENT_TABLE_NAME = ''CLAIM'' AND';
               v_nSql2 := v_nSql2 || ' PARENT_ROW_ID = :1 AND PI_EID = :2 AND ROLE_TABLE_ID IN(SELECT CODE1' || v_nSql || ')';

                  BEGIN
                      EXECUTE IMMEDIATE v_nSql2 INTO v_iPiRowId USING v_iClaimId, v_iAdjEid;
                  EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                       v_iPiRowId:= NULL;
                   WHEN OTHERS THEN
                       v_vErrMsgDesc := SQLERRM;
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDaRowId,
                                              'DDS_ADJUSTER',
                                              'RoleExcErr',
                                              'RoleExcErr',
                                              'PROCESS_ADJUSTER',
                                              v_vErrMsgDesc,
                                              'LAST_NAME, FIRST_NAME',
                                              'DDS_ADJUSTER',
                                              'CLAIM_ID',
                                              v_V_CLAIM_ID,
                                              0);

                        v_iErrCnt := v_iErrCnt + 1;
                  END;

                     IF v_iPiRowId IS NOT NULL AND v_iPiRowId <> 0 THEN
                        v_vErrMsgDesc := 'Entity: ' || v_V_LASTNAME || ' is already attached with Claim: ' || v_V_CLAIM_ID || ', and cannot be attached as Adjuster as per Role Combination Exclusion Mapping.';

                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDaRowId,
                                              'DDS_ADJUSTER',
                                              'RoleExcPi',
                                              'RoleExcPi',
                                              'PROCESS_ADJUSTER',
                                              v_vErrMsgDesc,
                                              'LAST_NAME, FIRST_NAME',
                                              'DDS_ADJUSTER',
                                              'CLAIM_ID',
                                              v_V_CLAIM_ID,
                                              1);

                        v_iErrCnt := v_iErrCnt + 1;
                     ELSE
                        v_nSql2 := 'SELECT max(CXC.CODE1) ' || v_nSql || ' AND CXC.CODE1 IN (SELECT TABLE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME IN(:1,:2,:3))';

                          BEGIN
                              EXECUTE IMMEDIATE v_nSql2 INTO v_iCodeId USING 'CLAIMANTS','OTHER_PEOPLE','EMPLOYEES';
                          EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                               v_iCodeId:= NULL;
                           WHEN TOO_MANY_ROWS THEN
                               v_iCodeId:= -1;
                           WHEN OTHERS THEN
                               v_vErrMsgDesc := SQLERRM;
                                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                      v_iDaRowId,
                                                      'DDS_ADJUSTER',
                                                      'RoleExcClmntErr',
                                                      'RoleExcClmntErr',
                                                      'PROCESS_ADJUSTER',
                                                      v_vErrMsgDesc,
                                                      'LAST_NAME, FIRST_NAME',
                                                      'DDS_ADJUSTER',
                                                      'CLAIM_ID',
                                                      v_V_CLAIM_ID,
                                                      0);

                                v_iErrCnt := v_iErrCnt + 1;
                          END;

                        IF v_iCodeId IS NOT NULL AND v_iCodeId <> 0 THEN
                           v_nSql := 'SELECT CLAIMANT_ROW_ID FROM ' || v_vDbName || 'CLAIMANT WHERE CLAIM_ID = :1 AND CLAIMANT_EID = :2';

                          BEGIN
                              EXECUTE IMMEDIATE v_nSql INTO v_iClaimantRowId USING v_iClaimId,v_iAdjEiD;
                          EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                               v_iClaimantRowId:= NULL;
                           WHEN OTHERS THEN
                               v_vErrMsgDesc := SQLERRM;
                                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                      v_iDaRowId,
                                                      'DDS_ADJUSTER',
                                                      'RoleExcClmntErr',
                                                      'RoleExcClmntErr',
                                                      'PROCESS_ADJUSTER',
                                                      v_vErrMsgDesc,
                                                      'LAST_NAME, FIRST_NAME',
                                                      'DDS_ADJUSTER',
                                                      'CLAIM_ID',
                                                      v_V_CLAIM_ID,
                                                      0);

                                v_iErrCnt := v_iErrCnt + 1;
                          END;

                           IF v_iClaimantRowId IS NOT NULL AND v_iClaimantRowId <> 0 THEN
                              v_vErrMsgDesc := 'Entity: ' || v_V_LASTNAME || ' is already attached as Claimant with Claim: ' || v_V_CLAIM_ID || ' and cannot be attached as adjuster as per Role Combination Exclusion.';
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'RoleExcClmnt',
                                                    'RoleExcClmnt',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    1);

                              v_iErrCnt := v_iErrCnt + 1;
                           END IF;
                        END IF;
                     END IF;

            END;
            END IF;

            v_vLocation := 'AdjRowId';
            v_nSql := 'SELECT ADJ_ROW_ID FROM ' || v_vDbName || 'CLAIM_ADJUSTER WHERE ADJUSTER_EID = :1 AND CLAIM_ID = :2';

                    BEGIN
                        EXECUTE IMMEDIATE v_nSql INTO v_iAdjRowId USING v_iAdjEiD,v_iClaimId;
                    EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                         v_iAdjRowId:= NULL;
                     WHEN OTHERS THEN
                         v_vErrMsgDesc := SQLERRM;
                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_iDaRowId,
                                                'DDS_ADJUSTER',
                                                'AdjExistErr',
                                                'AdjExistErr',
                                                'PROCESS_ADJUSTER',
                                                v_vErrMsgDesc,
                                                'LAST_NAME, FIRST_NAME',
                                                'DDS_ADJUSTER',
                                                'CLAIM_ID',
                                                v_V_CLAIM_ID,
                                                0);

                          v_iErrCnt := v_iErrCnt + 1;
                    END;

                  IF ( v_iAdjRowId IS NULL OR v_iAdjRowId = 0 ) AND v_iErrCnt = 0 AND v_iBaseErrCnt = 0 THEN
                     v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                    BEGIN
                        EXECUTE IMMEDIATE v_nSql INTO v_iAdjRowId USING 'CLAIM_ADJUSTER';
                    EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                         v_iAdjRowId:= NULL;
                     WHEN OTHERS THEN
                         v_vErrMsgDesc := SQLERRM;
                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_iDaRowId,
                                                'DDS_ADJUSTER',
                                                'AdjNextId',
                                                'AdjNextId',
                                                'PROCESS_ADJUSTER',
                                                v_vErrMsgDesc,
                                                'LAST_NAME, FIRST_NAME',
                                                'DDS_ADJUSTER',
                                                'CLAIM_ID',
                                                v_V_CLAIM_ID,
                                                0);

                          v_iErrCnt := v_iErrCnt + 1;
                    END;

                     V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

                     v_nSql := 'INSERT INTO ' || v_vDbName || 'CLAIM_ADJUSTER(ADJ_ROW_ID,ADJUSTER_EID,CLAIM_ID, CURRENT_ADJ_FLAG, ADJUSTER_TYPE';
                     v_nSql := v_nSql || ',DTTM_RCD_ADDED, ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER';
                     v_nSql := v_nSql || ') VALUES(:1, :2, :3,';

                     IF v_oCurAdjFlag <> 0 THEN
                        v_nSql := v_nSql || '-1,';
                     ELSE
                        v_nSql := v_nSql || '0,';
                     END IF;

                     v_nSql := v_nSql || ':4, :5, :6, :7, :8)';

                    BEGIN
                        EXECUTE IMMEDIATE v_nSql USING v_iAdjRowId, v_iAdjEiD,v_iClaimId,v_iAdjType, V_vSysDateTime, 'DA DDS', V_vSysDateTime, 'DA DDS';
                    EXCEPTION
                     WHEN OTHERS THEN
                         v_vErrMsgDesc := SQLERRM;
                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_iDaRowId,
                                                'DDS_ADJUSTER',
                                                'InsClmAdj',
                                                'InsClmAdj',
                                                'PROCESS_ADJUSTER',
                                                v_vErrMsgDesc,
                                                'LAST_NAME, FIRST_NAME',
                                                'DDS_ADJUSTER',
                                                'CLAIM_ID',
                                                v_V_CLAIM_ID,
                                                0);

                          v_iErrCnt := v_iErrCnt + 1;
                    END;

                     v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                     EXECUTE IMMEDIATE v_nSql USING 'CLAIM_ADJUSTER';

                     IF v_oCurAdjFlag <> 0 THEN
                        v_nSql := 'UPDATE ' || v_vDbName || 'CLAIM_ADJUSTER SET CURRENT_ADJ_FLAG = 0 WHERE CLAIM_ID = :1 AND ADJUSTER_EID <> :2';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql USING v_iClaimId,v_iAdjEiD;
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'UpdCurAdj',
                                                    'UpdCurAdj',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;
                     END IF;
                  ELSE
                     IF v_iErrCnt = 0 AND ( v_iAdjRowId <> 0 AND v_iAdjRowId IS NOT NULL ) AND v_iBaseErrCnt = 0 THEN
                        V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

                        v_nSql := 'UPDATE ' || v_vDbName || 'CLAIM_ADJUSTER SET ADJUSTER_TYPE = :1';

                        IF v_oCurAdjFlag <> 0 THEN
                           v_nSql := v_nSql || ', CURRENT_ADJ_FLAG = -1';
                        END IF;
                        v_nSql := v_nSql || ', DTTM_RCD_LAST_UPD = :2';
                        v_nSql := v_nSql || ', UPDATED_BY_USER = :3';
                        v_nSql := v_nSql || ' WHERE CLAIM_ID = :4 AND ADJUSTER_EID = :5';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql USING v_iAdjType,V_vSysDateTime,'DA DDS',v_iClaimId,v_iAdjEiD;
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'UpdAdjErr',
                                                    'UpdAdjErr',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;

                        IF v_oCurAdjFlag <> 0 THEN
                           v_nSql := 'UPDATE ' || v_vDbName || 'CLAIM_ADJUSTER SET CURRENT_ADJ_FLAG = 0 WHERE CLAIM_ID = :1 AND ADJUSTER_EID <> :2';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql USING v_iClaimId,v_iAdjEiD;
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'UpdAdjCurFlag',
                                                    'UpdAdjCurFlag',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;
                        END IF;
                     END IF;
                  END IF;

                  IF v_iErrCnt = 0 AND v_iBaseErrCnt = 0 THEN
                     v_nSql := 'UPDATE DDS_ADJUSTER SET INVALID_ROW = 0 WHERE JOBID = :1 AND DA_ROW_ID = :2';
                     BEGIN
                            EXECUTE IMMEDIATE v_nSql USING v_P_JOBID, v_iDaRowId;
                     EXCEPTION
                            WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'InvalidToZero',
                                                    'InvalidToZero',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'CLAIM_ID',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                     END;
                     v_vText := '';

					 v_vCountText := LENGTH(v_V_TEXT);
                     WHILE LENGTH(v_V_TEXT) > 0
                     LOOP
                           v_vString := SUBSTR(v_V_TEXT, 0, 1);
						   IF (v_vString = '''') THEN          --ddhupar JIRA 78172 starts
							 v_vText := v_vText || v_vString;
						   END IF;                
						   v_vCountText := v_vCountText - 1;   --ddhupar JIRA 78172 ends

                           IF ( ASCII(v_vString) >= 48 AND ASCII(v_vString) <= 57 ) OR ( ASCII(v_vString) >= 65 AND ASCII(v_vString) <= 90 ) OR ( ASCII(v_vString) >= 97
                             AND ASCII(v_vString) <= 122 ) THEN
                              v_vText := v_vText || v_vString;
                           END IF;
                           v_V_TEXT := SUBSTR(v_v_TEXT, (v_vCountText * (-1)), (LENGTH(v_V_TEXT) - 1));
                     END LOOP;

                     IF LENGTH(v_vText) > 0 THEN
					       IF v_vText LIKE'%''''%' THEN  --ddhupar JIRA 78172 starts
				            v_vText := REPLACE(v_vText,'''''','''');
				           END IF;                    --ddhupar JIRA 78172 ends
                        v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql INTO v_iAdjTextRowId USING 'ADJUST_DATED_TEXT';
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'AdjDtdTxtNxtId',
                                                    'AdjDtdTxtNxtId',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'CLAIM_ID',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;

                        V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

                        v_nSql := 'INSERT INTO ' || v_vDbName || 'ADJUST_DATED_TEXT(ADJ_DTTEXT_ROW_ID,ADJ_ROW_ID,TEXT_TYPE_CODE,DATE_ENTERED,DATED_TEXT';
                        v_nSql := v_nSql || ',ADDED_BY_USER,ENTERED_BY_USER,TIME_ENTERED,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,UPDATED_BY_USER';
                        v_nSql := v_nSql || ') VALUES(:1, :2, :3, :4, :5,';
                        v_nSql := v_nSql || ':6, :7, :8, :9, :10, :11)';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql USING v_iAdjTextRowId,
                                      v_iAdjRowId,
                                      v_iRecordType,
                                      v_V_DATE,
                                      v_vText,
                                      'DA DDS',
                                      'DA DDS',
                                      v_V_TIME,
                                      V_vSysDateTime,
                                      V_vSysDateTime,
                                      'DA DDS';
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'InsAdjDate',
                                                    'InsAdjDate',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;
                         v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                        BEGIN
                            EXECUTE IMMEDIATE v_nSql USING 'ADJUST_DATED_TEXT';
                        EXCEPTION
                         WHEN OTHERS THEN
                             v_vErrMsgDesc := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDaRowId,
                                                    'DDS_ADJUSTER',
                                                    'UpdGlsryAdjTxt',
                                                    'UpdGlsryAdjTxt',
                                                    'PROCESS_ADJUSTER',
                                                    v_vErrMsgDesc,
                                                    'LAST_NAME, FIRST_NAME',
                                                    'DDS_ADJUSTER',
                                                    'CLAIM_ID',
                                                    v_V_CLAIM_ID,
                                                    0);

                              v_iErrCnt := v_iErrCnt + 1;
                          END;
                          COMMIT;
                     END IF;
                  END IF;
         END IF;

         <<NEXTRECORD>>
    ---Neha Running status code starts 33658--- 
      --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);  
      v_vLocation := 'Running_Status';
      IF v_iRunStatCnt = 1 THEN
        BEGIN
          v_vProcessMsg := 'Total Number of Records processed in ADJUSTER : ' ||v_iRunStatCnt;
          EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
            USING v_P_JOBID, v_vProcessMsg, 'ADJUSTER_RUN', 'DDS_ADJUSTER_RUN', -11;
        END;
      ELSIF v_iRunCnt = 1000 THEN
          BEGIN
            v_vProcessMsg := 'Total Number of Records processed in ADJUSTER : ' ||v_iRunStatCnt;
            v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
            MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
          
            EXECUTE IMMEDIATE v_nsql using v_vProcessMsg, v_P_JOBID, 'ADJUSTER_RUN', 'DDS_ADJUSTER_RUN';
            v_iRunCnt:=1;
          END;
         ELSIF (v_iCount=v_iRunStatCnt) THEN
              BEGIN
              v_vProcessMsg := 'Total Number of Records processed in ADJUSTER : ' ||v_iCount;
              v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
              MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
  
             EXECUTE IMMEDIATE v_nSql using v_vProcessMsg, v_P_JOBID,'ADJUSTER_RUN', 'DDS_ADJUSTER_RUN';
             END;
      END IF;
      COMMIT;
    
       v_iRunStatCnt := v_iRunStatCnt + 1;
      v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658--- 
       
         --FETCH v_AdjCursor INTO v_P_JOBID,v_iDaRowId,v_iInvalidRow,v_V_RECORD_TYPE,v_V_CLAIM_ID,v_V_DATE,v_V_TIME,v_V_FIRSTNAME,v_V_LASTNAME,v_V_TEXT,v_V_ADJUSTER_TYPE,v_V_NAME_TYPE;

      END;
   END LOOP;
--END;
DDS_PROCESS_LOG(v_P_JOBID,'ADJUSTER', 'DDS_ADJUSTER'); ---added by neha 03jan2017 
EXCEPTION
WHEN OTHERS THEN
v_vErrMsgDesc := SQLERRM;
ROLLBACK;
DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
            v_iDaRowId,
            'DDS_ADJUSTER',
            v_vLocation,
            v_vLocation,
            'PROCESS_ADJUSTER',
            v_vErrMsgDesc,
            'LAST_NAME, FIRST_NAME',
            'DDS_ADJUSTER',
            'CLAIM_ID',
            v_V_CLAIM_ID,
            0);
END PROCESS_ADJUSTER;
