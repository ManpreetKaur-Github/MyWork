CREATE OR REPLACE PROCEDURE DDS_IMPORT_STD_PLAN
(
  v_P_JOBID IN NUMBER DEFAULT NULL ,
  v_P_DBNAME IN VARCHAR2 DEFAULT NULL ,
  v_P_USER_ID IN NUMBER DEFAULT NULL
)
AUTHID CURRENT_USER
AS



  -- Variables for selected Options
  v_CheckCreateNewCodes NUMBER(5,0);
  v_CONFIG_ID NUMBER(5,0);
  v_Valid_Start_Date VARCHAR2(8);
  v_Valid_End_Date VARCHAR2(8);
  v_V_STD_PLAN_SUPP NUMBER(5,0);

  -- Variables for std_plan Record Fields
  v_V_DA_ROW_ID NUMBER(10,0);
  v_V_INVALID_ROW NUMBER(10,0);
  v_V_PLAN_NUMBER VARCHAR2(20);
  v_V_PLAN_NAME VARCHAR2(20);
  v_V_PLAN_DESCRIPTION VARCHAR2(50);
  v_V_PLAN_STATUS VARCHAR2(25);
  v_V_PREMIUM FLOAT(53);
  v_V_BANK_ACCOUNT_NUM VARCHAR2(20);
  v_V_EFFECTIVE_DATE VARCHAR2(8);
  v_V_EXPIRATION_DATE VARCHAR2(8);
  v_V_ISSUE_DATE VARCHAR2(8);
  v_V_REVIEW_DATE VARCHAR2(8);
  v_V_RENEWAL_DATE VARCHAR2(8);
  v_V_CANCEL_DATE VARCHAR2(8);
  v_V_PREF_DAY_PAY_TYPE VARCHAR2(25);
  v_V_PREF_PAY_SCHEDULE_TYPE VARCHAR2(25);
  v_V_COMMENTS VARCHAR2(255);
  v_V_START_PAY_PERIOD VARCHAR2(8);
  v_V_PRINT_BEFORE_END_FLAG VARCHAR2(1);
  v_V_BANK_SUB_ACCNT_NUM VARCHAR2(20);
  v_V_INSURED_EID VARCHAR2(207);
  v_V_INSURED_HIER_LEVEL VARCHAR2(15);

  -- CODE_ID VARIABLES
  v_V_PREF_DAY_PAY_TYPE_ID NUMBER(10,0) := 0;
  v_V_PREF_PAY_SCHEDULE_TYPE_ID NUMBER(10,0) := 0;
  v_V_PLAN_STATUS_ID NUMBER(10,0) := 0;
  v_V_PRINT_BEFORE_END_FLAG_ID NUMBER(10,0);
  v_V_ERRORLOC VARCHAR2(20) := 0;
  v_V_CLASSROW_ID  NUMBER(10,0) := 0;
  v_V_PLAN_ID  NUMBER(10,0) := 0;
  v_V_TAXFLAGS  NUMBER(10,0) := 0;
  v_V_DIS_TYPE_ID NUMBER(10,0) := 0;
  v_V_INSERTPLANINFO NUMBER(10,0) := 0;
  v_V_EMP_PERSON NUMBER(10,0) := 0;
  v_V_TABLE_ID NUMBER(10,0) := 0;
  v_V_ROW_ID NUMBER(10,0) := 0;

  --- Other Local Variables
  v_V_ROWCOUNT  NUMBER(10,0) := 0;
  v_V_CODE_ID_R NUMBER(10,0) := 0;
  v_V_CODE_ID_RMDB NUMBER(10,0) := 0;
  v_V_MODULENAME VARCHAR2(100) := 'STD_PLAN';
  v_V_DBNAME  VARCHAR2(255);
  v_V_SQL  CLOB;
  v_V_PROCNAME  VARCHAR2(30) := 'DDS_STD_PLAN';
  v_V_ERROR_TABLE  VARCHAR2(30) := 'DDS_STD_PLAN';
  v_V_DDSUSER  VARCHAR2(6) := 'DA DDS';
  v_V_ERRORCOUNT  NUMBER(10,0) := 0;
  v_V_ENTITY_ID NUMBER(10,0) := 0;
  v_V_DEPT_ID  NUMBER(10,0) := 0;
  v_V_ENTITY_TABLE_ID  NUMBER(10,0) := 0;
  v_V_ABBREVIATION  VARCHAR2(25) := NULL;
  v_V_DELETED_FLAG  NUMBER(10,0) := 0;
  v_V_SYS_TABLE_NAME  VARCHAR2(30) := NULL;
  v_VSQLINSERT CLOB;
  v_V_DATETIME VARCHAR2(14);
  v_V_ERROR_MESSAGE CLOB;
  v_V_CODEFIELDS CLOB;
  v_V_SYSTEMTABLENAME CLOB;
  v_V_TABLENAME VARCHAR2(30);
  v_V_NEWPLAN NUMBER(10,0) := 0;
  v_V_SUPP_ERROR_COUNT NUMBER(10,0) := 0;
  v_V_BANK_ACC_ID NUMBER(10,0) := 0;
  v_V_SUB_ACC_ROW_ID NUMBER(10,0) := 0;
  v_vReqColumns  CLOB;
  v_vReqColumns1  CLOB;
  v_vColName1    VARCHAR2(100);
  v_vColName2    VARCHAR2(100);
  v_V_VAL      CLOB;
  v_V_INSURED_EID_RMDB NUMBER(10,0) := 0;
  v_V_NEWINSURED NUMBER(10,0) := 0;
  v_V_INSUREDHIERRACHYOK NUMBER(10,0) := 0;
  v_V_CLAIM_LOB NUMBER(10,0) := 844;
  ---neha 33658 -- START 
  v_iRunStatCnt    NUMBER(10, 0):=1;  
  v_iRunCnt        NUMBER(10, 0):=1;  
  v_vProcessMsg    varchar2(4000); 
  v_iCount         NUMBER(10, 0) := 0; 
  ---neha 33658 -- end

----------------------------- Fetching Claim Records For Validation----------------------------------------------------
CURSOR DDS_STD_PLAN_CUR------ DECLARING CURSOR
        IS SELECT
             DA_ROW_ID,
             PLAN_NUMBER ,  PLAN_NAME ,  PLAN_DESCRIPTION ,  PLAN_STATUS ,  PREMIUM ,  BANK_ACCOUNT_NUM ,
             EFFECTIVE_DATE ,  EXPIRATION_DATE ,  ISSUE_DATE ,  REVIEW_DATE ,  RENEWAL_DATE ,  CANCEL_DATE ,
             PREF_DAY_PAY_TYPE ,  PREF_PAY_SCHEDULE_TYPE ,  COMMENTS ,  START_PAY_PERIOD ,  PRINT_BEFORE_END_FLAG ,
             BANK_SUB_ACCNT_NUM ,  INSURED_EID ,  INSURED_HIER_LEVEL

        FROM DDS_STD_PLAN
        WHERE JOBID = v_P_JOBID
        AND INVALID_ROW = 1;

BEGIN --MAIN BEGIN

  IF v_P_DBName IS NOT NULL THEN
    v_V_DBNAME := v_P_DBNAME || '.';
 END IF;


  v_V_ERRORLOC := 'Z001';
  
  BEGIN --Neha Running status starts 33658
        SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_STD_PLAN WHERE JOBID = v_P_JOBID AND INVALID_ROW=1; 
   exception
    when no_data_found then
      null; 
  END; --Neha Running status ends 33658

  BEGIN
    SELECT ALLOW_NEW_CODES,
        CONFIG_ID,
        VALID_START_DATE,
        VALID_END_DATE,
        STDPLAN_SUPP
   INTO v_CheckCreateNewCodes,
        v_CONFIG_ID,
        v_Valid_Start_Date,
        v_Valid_End_Date,
        v_V_STD_PLAN_SUPP
   FROM DDS_OPTIONSET
    WHERE JOBID = v_P_JOBID;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
        v_Valid_Start_Date := NULL;
    WHEN OTHERS THEN
    ----------- NOTE: IF NO ROWS ARE THERE IN DDS OPTIONTHEN EXIT THIS PROCEDURE AS THERE IS NO POINT I GOING FORWARD WITHOUT OPTIONVALUES
    v_V_ERROR_MESSAGE := SQLERRM;
    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                          v_V_DA_ROW_ID,
                          v_V_MODULENAME,
                          v_V_ERRORLOC,
                          v_V_ERRORLOC,
                          v_V_PROCNAME,
                          v_V_ERROR_MESSAGE,
                          'EXCEPTION',
                          v_V_ERROR_TABLE,
                          'PLAN_NUMBER',
                          v_V_PLAN_NUMBER,
                          0);
    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
  END;

   IF v_Valid_Start_Date IS NULL THEN
    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                          v_V_DA_ROW_ID,
                          v_V_MODULENAME,
                          v_V_ERRORLOC,
                          v_V_ERRORLOC,
                          v_V_PROCNAME,
                          'Please select Valid Date Range from Optionset screen.',
                          'JOB_ID',
                          'DDS_OPTIONSET',
                          'JOB_ID',
                          v_P_JOBID,
                          1);
      GOTO ENDMAIN;
   END IF;

   OPEN DDS_STD_PLAN_CUR;---- OPENING CURSOR
   LOOP
       FETCH DDS_STD_PLAN_CUR INTO v_V_DA_ROW_ID,
             v_V_PLAN_NUMBER ,  v_V_PLAN_NAME ,  v_V_PLAN_DESCRIPTION ,  v_V_PLAN_STATUS ,  v_V_PREMIUM ,  v_V_BANK_ACCOUNT_NUM ,
             v_V_EFFECTIVE_DATE ,  v_V_EXPIRATION_DATE ,  v_V_ISSUE_DATE ,  v_V_REVIEW_DATE ,  v_V_RENEWAL_DATE ,  v_V_CANCEL_DATE ,
             v_V_PREF_DAY_PAY_TYPE ,  v_V_PREF_PAY_SCHEDULE_TYPE ,  v_V_COMMENTS ,  v_V_START_PAY_PERIOD ,  v_V_PRINT_BEFORE_END_FLAG ,
             v_V_BANK_SUB_ACCNT_NUM ,  v_V_INSURED_EID ,  v_V_INSURED_HIER_LEVEL;
       EXIT WHEN DDS_STD_PLAN_CUR%NOTFOUND;
      BEGIN
            v_V_ERRORLOC := 'Z007';



                ----************** INITIALIZATION OF VARIABLES ******************
     v_V_PREF_DAY_PAY_TYPE_ID := 0;
     v_V_PREF_PAY_SCHEDULE_TYPE_ID  := 0;
     v_V_PLAN_STATUS_ID  := 0;
     v_V_ERRORLOC := 0;
     v_V_CLASSROW_ID   := 0;
     v_V_PLAN_ID  := 0;
     v_V_TAXFLAGS  := 0;
     v_V_DIS_TYPE_ID := 0;
     v_V_INSERTPLANINFO  := 0;
     v_V_EMP_PERSON  := 0;
     v_V_TABLE_ID  := 0;
     v_V_ROW_ID  := 0;
     v_V_ROWCOUNT   := 0;
     v_V_CODE_ID_R   := 0;
     v_V_CODE_ID_RMDB  := 0;
     v_V_ERRORCOUNT   := 0;
     v_V_ENTITY_ID   := 0;
     v_V_DEPT_ID   := 0;
     v_V_ENTITY_TABLE_ID   := 0;
     v_V_ABBREVIATION  := 0;
     v_V_DELETED_FLAG   := 0;
     v_V_SYS_TABLE_NAME := 0;
     v_V_DATETIME := 0;
     v_V_NEWPLAN := 0;
     v_V_SUPP_ERROR_COUNT := 0;
     v_vColName1 := NULL;
     v_vReqColumns := NULL;
     v_vColName2 := NULL;
     v_vReqColumns1 := NULL;
     v_V_INSURED_EID_RMDB := 0;
     v_V_NEWINSURED := 0;
     v_V_INSUREDHIERRACHYOK := 0;


    BEGIN   --********* REQUIRED FIELD VALIDATION STARTS **********************************************
       v_V_ERRORLOC := 'V001';
       v_vReqColumns := 'PLAN_NUMBER|PLAN_NAME|PLAN_STATUS|EFFECTIVE_DATE|EXPIRATION_DATE|';

      WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
      LOOP

          v_vColName1 := SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)-1);
          v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)))+1,LENGTH(v_vReqColumns));

        v_V_VAL := (CASE
        WHEN v_vColName1 = 'PLAN_NUMBER' THEN v_V_PLAN_NUMBER
        WHEN v_vColName1 = 'PLAN_NAME' THEN v_V_PLAN_NAME
        WHEN v_vColName1 = 'PLAN_STATUS' THEN v_V_PLAN_STATUS
        WHEN v_vColName1 = 'EFFECTIVE_DATE' THEN v_V_EFFECTIVE_DATE
        WHEN v_vColName1 = 'EXPIRATION_DATE' THEN v_V_EXPIRATION_DATE
        END );

        IF v_V_VAL IS NULL THEN
          DDS_ERROR_LOG_CAPTURE(v_P_JOBID, v_V_DA_ROW_ID, v_V_MODULENAME, v_V_ERRORLOC, v_V_ERRORLOC, v_V_PROCNAME,'Required Fields are Null or Empty.',v_vColName1, v_V_ERROR_TABLE, 'PLAN_NUMBER', v_V_PLAN_NUMBER,1);
          v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
        END IF;
      END LOOP;
          EXCEPTION
            WHEN OTHERS THEN
              v_V_ERROR_MESSAGE := SQLERRM;
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    v_V_ERROR_MESSAGE,
                                    'EXCEPTION',
                                    v_V_ERROR_TABLE,
                                    'PLAN_NUMBER',
                                    v_V_PLAN_NUMBER,
                                    0);
              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

          END; --***************** REQUIRED FIELD VALIDATION ENDS ******************************************

    BEGIN  ----***************** SHORT CODE FIELDS VALIDATION STARTS *********************************

        v_V_ERRORLOC   := 'V002';
        v_V_CODEFIELDS := 'PLAN_STATUS|PREF_DAY_PAY_TYPE|PREF_PAY_SCHEDULE_TYPE|';

        v_V_SYSTEMTABLENAME := 'PLAN_STATUS|PREF_PAYMENT_DAY|PERIOD_TYPES|';

        WHILE INSTR(v_V_CODEFIELDS, '|', 1) > 0 --CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
         LOOP

          v_VCOLNAME1         := SUBSTR(v_V_CODEFIELDS,1, INSTR(v_V_CODEFIELDS, '|', 1) - 1);
          v_V_CODEFIELDS      := SUBSTR(v_V_CODEFIELDS, LENGTH(SUBSTR(v_V_CODEFIELDS, 1,INSTR(v_V_CODEFIELDS,'|', 1))) + 1, LENGTH(v_V_CODEFIELDS));
          v_V_TABLENAME       := SUBSTR(v_V_SYSTEMTABLENAME, 1, INSTR(v_V_SYSTEMTABLENAME, '|', 1) - 1);
          v_V_SYSTEMTABLENAME := SUBSTR(v_V_SYSTEMTABLENAME, LENGTH(SUBSTR(v_V_SYSTEMTABLENAME, 1, INSTR(v_V_SYSTEMTABLENAME,'|', 1))) + 1, LENGTH(v_V_SYSTEMTABLENAME));

          v_V_VAL := (CASE
          WHEN v_VCOLNAME1 = 'PLAN_STATUS' THEN v_V_PLAN_STATUS
          WHEN v_VCOLNAME1 = 'PREF_DAY_PAY_TYPE' THEN v_V_PREF_DAY_PAY_TYPE
          WHEN v_VCOLNAME1 = 'PREF_PAY_SCHEDULE_TYPE' THEN v_V_PREF_PAY_SCHEDULE_TYPE
          END);

          v_V_CODE_ID_R := NULL;

          IF v_V_VAL IS NOT NULL THEN
            DDS_CODE_VALIDATION_IMPORT(p_JOBID                  => v_P_JOBID,
                                       P_SHORT_CODE             => v_V_VAL,
                                       P_SYS_TABLE_NAME         => v_V_TABLENAME,
                                       P_CODE_CREATION_FLAG     => v_CheckCreateNewCodes,
                                       P_DB_NAME                => v_V_DBNAME,
                                       P_LOB                    => v_V_CLAIM_LOB,
                                       p_DA_ROW_ID              => v_V_DA_ROW_ID,
                                       p_MODULE_NAME            => v_V_MODULENAME,
                                       p_ERROR_LOCATION         => v_V_ERRORLOC,
                                       p_ERROR_PROC_NAME        => v_V_PROCNAME,
                                       p_ERROR_KEY_COLUMN       => 'PLAN_NUMBER',
                                       p_ERROR_COLUMN           => v_VCOLNAME1,
                                       p_ERROR_TABLE_TO_CHECK   => v_V_ERROR_TABLE,
                                       P_ERROR_COLUMN_KEY_VALUE => v_V_PLAN_NUMBER,
                                       P_CODE_ID_R              => v_V_CODE_ID_R);

            IF v_V_CODE_ID_R = 0 OR v_V_CODE_ID_R IS NULL THEN
              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            IF v_VCOLNAME1 = 'PLAN_STATUS' THEN
            v_V_PLAN_STATUS_ID := v_V_CODE_ID_R;
            ELSIF v_VCOLNAME1 = 'PREF_DAY_PAY_TYPE' THEN
            v_V_PREF_DAY_PAY_TYPE_ID := v_V_CODE_ID_R;
            ELSIF v_VCOLNAME1 = 'PREF_PAY_SCHEDULE_TYPE' THEN
            v_V_PREF_PAY_SCHEDULE_TYPE_ID := v_V_CODE_ID_R;
            END IF;

          END IF;

       END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        v_V_ERROR_MESSAGE := SQLERRM;
        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                              v_V_DA_ROW_ID,
                              v_V_MODULENAME,
                              v_V_ERRORLOC,
                              v_V_ERRORLOC,
                              v_V_PROCNAME,
                              v_V_ERROR_MESSAGE,
                              'EXCEPTION',
                              v_V_ERROR_TABLE,
                              'PLAN_NUMBER',
                              v_V_PLAN_NUMBER,
                              0);

        v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
    END; ----***************** SHORT CODE FIELDS VALIDATION ENDS *******************************************

    BEGIN  ----***************** FLAG INITIALIZATION STARTS ******************************************
      v_V_ERRORLOC := 'V003';

        IF v_V_PRINT_BEFORE_END_FLAG IS NOT NULL THEN

          IF v_V_PRINT_BEFORE_END_FLAG = 'Y' THEN
            v_V_PRINT_BEFORE_END_FLAG_ID := -1;
          ELSIF v_V_PRINT_BEFORE_END_FLAG = 'N' OR v_V_PRINT_BEFORE_END_FLAG = '0' THEN ---BY DEFAULT FLAG WILL BE 0
            v_V_PRINT_BEFORE_END_FLAG_ID := 0;
          ELSE
            DDS_ERROR_LOG_CAPTURE (v_P_JOBID, v_V_DA_ROW_ID, v_V_MODULENAME, v_V_ERRORLOC, v_V_ERRORLOC, v_V_PROCNAME, 'Not a Valid Flag Value. Permitted Values are ''Y'' or ''N'' or ''0''.', v_vColName1, v_V_ERROR_TABLE, 'PLAN_NUMBER', v_V_PLAN_NUMBER,1);
            v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
        END IF;
       END IF;
    EXCEPTION
      WHEN OTHERS THEN
        v_V_ERROR_MESSAGE := SQLERRM;
        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                              v_V_DA_ROW_ID,
                              v_V_MODULENAME,
                              v_V_ERRORLOC,
                              v_V_ERRORLOC,
                              v_V_PROCNAME,
                              v_V_ERROR_MESSAGE,
                              'EXCEPTION',
                              v_V_ERROR_TABLE,
                              'PLAN_NUMBER',
                              v_V_PLAN_NUMBER,
                              0);

        v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
    END;            --***************** FLAG INITIALIZATION ENDS *****************************************************

   BEGIN -- **************** DATE VALIDATION STARTS   **********************************************
         v_V_ERRORLOC := 'V006';
         v_vReqColumns := 'EFFECTIVE_DATE|EXPIRATION_DATE|ISSUE_DATE|REVIEW_DATE|RENEWAL_DATE|CANCEL_DATE|START_PAY_PERIOD|';                     WHILE INSTR(v_vReqColumns, '|', 1) > 0--NOTE:CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
         LOOP
            BEGIN
               v_vColName1 := SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)-1);
               v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)))+1,LENGTH(v_vReqColumns));
               v_V_VAL := (CASE
                                WHEN v_vColName1 = 'EFFECTIVE_DATE' THEN v_V_EFFECTIVE_DATE
                                WHEN v_vColName1 = 'EXPIRATION_DATE' THEN v_V_EXPIRATION_DATE
                                WHEN v_vColName1 = 'ISSUE_DATE' THEN v_V_ISSUE_DATE
                                WHEN v_vColName1 = 'REVIEW_DATE' THEN v_V_REVIEW_DATE
                                WHEN v_vColName1 = 'RENEWAL_DATE' THEN v_V_RENEWAL_DATE
                                WHEN v_vColName1 = 'CANCEL_DATE' THEN v_V_CANCEL_DATE
                                WHEN v_vColName1 = 'START_PAY_PERIOD' THEN v_V_START_PAY_PERIOD
                                END);

               IF v_V_VAL IS NOT NULL THEN
                  IF ( DDS_IS_NUMBER(v_V_VAL) = 0 OR DDS_is_date(v_V_VAL) = 0 ) THEN
                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                           v_V_DA_ROW_ID,
                                           v_V_MODULENAME,
                                           v_V_ERRORLOC,
                                           v_V_ERRORLOC,
                                           v_V_PROCNAME,
                                           'Date Provided is Not a Valid Date ',
                                           v_vColName1,
                                           v_V_ERROR_TABLE,
                                           'PLAN_NUMBER',
                                           v_V_PLAN_NUMBER,
                                           1);

                     v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  --PRINT 'ERROR: Not a Valid Date'
                  ELSE
                     IF ( v_V_VAL < v_Valid_Start_Date ) OR ( v_V_VAL > v_Valid_End_Date ) THEN
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_V_DA_ROW_ID,
                                              v_V_MODULENAME,
                                              v_V_ERRORLOC,
                                              v_V_ERRORLOC,
                                              v_V_PROCNAME,
                                              'Date provided is out of Valid Date Range ',
                                              v_vColName1,
                                              v_V_ERROR_TABLE,
                                              'PLAN_NUMBER',
                                              v_V_PLAN_NUMBER,
                                              1);

                        v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                     END IF;
                  END IF;
               END IF;
            END;
         END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
            --PRINT 'ERROR: Date provided is out of Valid Date Range'
            --PRINT @V_VAL
            v_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  v_V_ERRORLOC,
                                  v_V_ERRORLOC,
                                  v_V_PROCNAME,
                                  v_V_ERROR_MESSAGE,
                                  'EXCEPTION',
                                  v_V_ERROR_TABLE,
                                  'PLAN_NUMBER',
                                  v_V_PLAN_NUMBER,
                                  0);

            v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
   END; ----**************** DATE VALIDATION ENDS    *****************************************************
 
IF (DDS_IS_DATE(v_V_EFFECTIVE_DATE)) = 1 AND (DDS_IS_DATE(v_V_EXPIRATION_DATE)) = 1 AND  (v_V_EXPIRATION_DATE < v_V_EFFECTIVE_DATE) THEN
DDS_ERROR_LOG_CAPTURE(v_P_JOBID, 
 v_V_DA_ROW_ID, 
 v_V_MODULENAME, 
 v_V_ERRORLOC, 
 v_V_ERRORLOC, 
 v_V_PROCNAME, 
 'Plan Expiration Date should be Greater or equal to Effective Date. ', 
 'EXPIRATION_DATE,EFFECTIVE_DATE', 
 v_V_ERROR_TABLE, 
 'PLAN_NUMBER', 
 v_V_PLAN_NUMBER, 
 1); 

END IF;

    --********************************** ERROR COUNT *******************************************************************************************
    v_V_ERRORLOC := 'V005';

    IF v_V_ERRORCOUNT + v_V_ROWCOUNT > 0 THEN
       v_V_INVALID_ROW := 1 ;
    ELSIF (v_V_ERRORCOUNT + v_V_ROWCOUNT = 0) THEN
          v_V_INVALID_ROW := 0;
    END IF;
    --********************************** ERROR COUNT ******************************************************************************************


    ---**************** CHECK IF AN EXISTING PLAN OR A NEW PLAN *******************************************************************
    IF v_V_PLAN_NUMBER IS NOT NULL AND v_V_INVALID_ROW = 0 THEN
    BEGIN
        BEGIN
          v_V_ERRORLOC := 'P001' ;
          v_V_SQL := 'SELECT PLAN_ID FROM ' || v_V_DBNAME || 'DISABILITY_PLAN WHERE PLAN_NUMBER = :1 ';

          EXECUTE IMMEDIATE V_V_SQL INTO v_V_PLAN_ID USING v_V_PLAN_NUMBER;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_V_PLAN_ID := 0;
        END;

        IF    v_V_PLAN_ID > 0  THEN
              v_V_NEWPLAN := 0  ;--PLAN EXIST IN RISKMASTER DATABASE
        ELSIF v_V_PLAN_ID = 0 THEN
               v_V_NEWPLAN := 1;  --PLAN DOES NOT EXIST IN RISKMASTER DATABASE
        END IF;

        IF v_V_BANK_ACCOUNT_NUM IS NOT NULL THEN
          BEGIN
            v_V_ERRORLOC := 'P002' ;
            v_V_BANK_ACC_ID := 0;
            v_V_SQL := 'SELECT ACCOUNT_ID FROM ' || v_V_DBNAME || 'ACCOUNT WHERE ACCOUNT_NUMBER = :1 ';

          EXECUTE IMMEDIATE V_V_SQL INTO v_V_BANK_ACC_ID USING v_V_BANK_ACCOUNT_NUM;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_V_BANK_ACC_ID := 0;
          END;
        END IF;

        IF v_V_BANK_SUB_ACCNT_NUM IS NOT NULL THEN
          BEGIN
            v_V_ERRORLOC := 'P003' ;
            v_V_SUB_ACC_ROW_ID := 0;
            v_V_SQL := 'SELECT SUB_ROW_ID FROM ' || v_V_DBNAME || 'BANK_ACC_SUB WHERE SUB_ACC_NUMBER = :1 ';

            EXECUTE IMMEDIATE V_V_SQL INTO v_V_SUB_ACC_ROW_ID USING v_V_BANK_SUB_ACCNT_NUM;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_V_SUB_ACC_ROW_ID := 0;
          END;
        END IF;

        v_V_ERRORLOC := 'P004';
        v_vReqColumns := v_V_INSURED_EID;
        IF v_vReqColumns IS NOT NULL THEN 
           v_vReqColumns := v_vReqColumns || '|';
        END IF;
        
        WHILE INSTR(v_vReqColumns1, '|', 1) > 0
        LOOP

          v_vColName2 := SUBSTR(v_vReqColumns1, 1, INSTR(v_vReqColumns1, '|', 1) - 1);
          v_vReqColumns1 := SUBSTR(v_vReqColumns1,LENGTH(SUBSTR(v_vReqColumns1, 1, INSTR(v_vReqColumns1,'|', 1))) + 1, LENGTH(v_vReqColumns1));

          IF CAST(v_vColName2 AS INTEGER) > 8 OR CAST(v_vColName2 AS INTEGER) < 1 THEN
            DDS_ERROR_LOG_CAPTURE (v_P_JOBID, v_V_DA_ROW_ID, v_V_MODULENAME, v_V_ERRORLOC, v_V_ERRORLOC, v_V_PROCNAME, 'INSURED_HIER_LEVEL NOT between 1 and 8 Including both.', 'INSURED_HIER_LEVEL', v_V_ERROR_TABLE, 'PLAN_NUMBER', v_V_PLAN_NUMBER,1);
            v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
          END IF;

        END LOOP;

        v_vReqColumns := v_V_INSURED_EID;
        v_vReqColumns1 := v_V_INSURED_HIER_LEVEL;

        IF (LENGTH(v_vReqColumns) - LENGTH(REPLACE(v_vReqColumns, '|', ''))) = (LENGTH(v_vReqColumns1) - LENGTH(REPLACE(v_vReqColumns1, '|', ''))) 
           AND v_vReqColumns IS NOT NULL AND v_vReqColumns1 IS NOT NULL THEN
          v_V_INSUREDHIERRACHYOK := 1;
        ELSE IF v_vReqColumns IS NOT NULL AND v_vReqColumns1 IS NOT NULL THEN
                DDS_ERROR_LOG_CAPTURE (v_P_JOBID, v_V_DA_ROW_ID, v_V_MODULENAME, v_V_ERRORLOC, v_V_ERRORLOC, v_V_PROCNAME, 'Numbers of DIS_PLAN_X_INSURED plan abbreviation and Hierarchy levels does not match.', 'INSURED_EID,INSURED_HIER_LEVEL', v_V_ERROR_TABLE, 'PLAN_NUMBER', v_V_PLAN_NUMBER,1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
             END IF;
        END IF;

   EXCEPTION
      WHEN OTHERS THEN
            --PRINT 'ERROR: Date provided is out of Valid Date Range'
            --PRINT @V_VAL
            v_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  v_V_ERRORLOC,
                                  v_V_ERRORLOC,
                                  v_V_PROCNAME,
                                  v_V_ERROR_MESSAGE,
                                  'EXCEPTION',
                                  v_V_ERROR_TABLE,
                                  'PLAN_NUMBER',
                                  v_V_PLAN_NUMBER,
                                  0);

            v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
   END;
  END IF;

    IF v_V_STD_PLAN_SUPP = 1 THEN
    BEGIN -- BEGIN SUPPLEMENTAL FIELDS VALIDATION

      v_V_ERRORLOC := 'P005';

      DDS_SUPPLEMENT(
      v_P_JOBID, v_CONFIG_ID, v_P_USER_ID, v_V_MODULENAME, v_V_DBNAME, v_V_DA_ROW_ID, v_CheckCreateNewCodes, 0,
      v_V_ERRORCOUNT,  -- TO CHECK THERE IS ANY ERROR IN BASE RECORD (INPUT PARAMETER TO CHECK BASE ERROR)
      'V',      -- VALIDATION OR INSERT (V OR I)
      0,0,0,0,0,0,0,0,0,0,0,
      v_V_PLAN_ID,0,0,
      'PLAN_NUMBER',                                 -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
      v_V_PLAN_NUMBER,                                  -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
      v_V_SUPP_ERROR_COUNT); --(OUT PARAMETER TO INTIMATE BASE THAT THERE IS AND ERROR IN SUPP)

    v_V_ERRORCOUNT := v_V_ERRORCOUNT + NVL(v_V_SUPP_ERROR_COUNT, 0);

   EXCEPTION
      WHEN OTHERS THEN
            --PRINT 'ERROR: Date provided is out of Valid Date Range'
            --PRINT @V_VAL
            v_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  v_V_ERRORLOC,
                                  v_V_ERRORLOC,
                                  v_V_PROCNAME,
                                  v_V_ERROR_MESSAGE,
                                  'EXCEPTION',
                                  v_V_ERROR_TABLE,
                                  'PLAN_NUMBER',
                                  v_V_PLAN_NUMBER,
                                  0);

            v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
   END;
   END IF;
 -- END SUPPLEMENTAL FIELDS VALIDATION

    ----------************************** CHECK IF AN EXISTING PLAN OR A NEW PLAN ENDS **********************************************************

    ----****************************************************************************************************************************************

      v_V_ERRORLOC := 'P006';

      IF v_V_ROWCOUNT + v_V_ERRORCOUNT > 0 THEN
         v_V_INVALID_ROW := 1;

      ELSIF v_V_ROWCOUNT + v_V_ERRORCOUNT = 0 THEN
            v_V_INVALID_ROW := 0;
      END IF;

    ----****************************************************************************************************************************************

    BEGIN ------------INSERT WORK STARTS

    IF v_V_INVALID_ROW = 0 THEN   ----BEGIN LEVEL INSERT/UPDATE
        v_V_ERRORLOC := 'INS01';

        EXECUTE IMMEDIATE 'select to_char(sysdate,' || '''' ||'yyyymmddhh24miss' || '''' ||') from dual'
        INTO v_V_DATETIME;

        IF v_V_NEWPLAN = 1 THEN

          v_V_ERRORLOC := 'INS02';
          v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' || v_V_DBNAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''DISABILITY_PLAN''';
          BEGIN
               EXECUTE IMMEDIATE v_VSQLINSERT INTO v_V_PLAN_ID;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_V_NEWPLAN := 0;
          END;

          v_V_ERRORLOC := 'INS03';
          v_V_SQL := 'INSERT INTO ' || v_V_DBNAME || 'DISABILITY_PLAN(PLAN_ID,
                  PLAN_NUMBER, PLAN_NAME, PLAN_DESCRIPTION, PLAN_STATUS_CODE, PREMIUM, BANK_ACC_ID, EFFECTIVE_DATE, EXPIRATION_DATE,
                  ISSUE_DATE,  REVIEW_DATE, RENEWAL_DATE, CANCEL_DATE,  PREF_DAY_CODE, PREF_PAY_SCH_CODE, COMMENTS,  ADDED_BY_USER,
                  DTTM_RCD_ADDED,  UPDATED_BY_USER, DTTM_RCD_LAST_UPD, START_PAY_PERIOD, PRINT_BEFORE_END,  SUB_ACC_ROW_ID,
                  HTMLCOMMENTS)';

          v_V_SQL :=  v_V_SQL || ' VALUES(:1, :2,  :3, :4, :5, :6, :7, :8,  :9,  :10, :11, :12,  :13,  :14, :15,  :16, :17,  :18, :19, :20, :21, :22,  :23, :24)';

          EXECUTE IMMEDIATE V_V_SQL USING v_V_PLAN_ID, v_V_PLAN_NUMBER, v_V_PLAN_NAME, v_V_PLAN_DESCRIPTION,
          v_V_PLAN_STATUS_ID, v_V_PREMIUM, v_V_BANK_ACC_ID, v_V_EFFECTIVE_DATE, v_V_EXPIRATION_DATE, v_V_ISSUE_DATE,
          v_V_REVIEW_DATE,v_V_RENEWAL_DATE,v_V_CANCEL_DATE,v_V_PREF_DAY_PAY_TYPE_ID, v_V_PREF_PAY_SCHEDULE_TYPE_ID, v_V_COMMENTS,
          v_V_DDSUSER,v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME , v_V_START_PAY_PERIOD,v_V_PRINT_BEFORE_END_FLAG_ID, v_V_SUB_ACC_ROW_ID,v_V_COMMENTS ;


          v_V_ERRORLOC := 'INS04';
          v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = ''DISABILITY_PLAN''';
          EXECUTE IMMEDIATE v_VSQLINSERT ;

        ELSE

          v_V_ERRORLOC := 'INS05';

          v_V_SQL := 'UPDATE ' || v_V_DBNAME || 'DISABILITY_PLAN SET ';

          v_V_SQL := v_V_SQL || ' PLAN_NAME = '||''''|| v_V_PLAN_NAME ||'''';
          v_V_SQL := v_V_SQL || ', UPDATED_BY_USER = '||''''|| v_V_DDSUSER ||'''';
          v_V_SQL := v_V_SQL || ', DTTM_RCD_LAST_UPD = '||''''|| v_V_DATETIME ||'''';
          v_V_SQL := v_V_SQL || ', EFFECTIVE_DATE = '||''''|| v_V_EFFECTIVE_DATE ||'''';
          v_V_SQL := v_V_SQL || ', EXPIRATION_DATE = '||''''|| v_V_EXPIRATION_DATE ||'''';

          IF v_V_PLAN_DESCRIPTION IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', PLAN_DESCRIPTION = '||''''|| v_V_PLAN_DESCRIPTION ||'''';
          END IF;
          IF v_V_PLAN_STATUS_ID IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', PLAN_STATUS_CODE = ' || v_V_PLAN_STATUS_ID;
          END IF;
          IF v_V_PREMIUM > 0 THEN
             v_V_SQL := v_V_SQL || ', PREMIUM = ' || v_V_PREMIUM;
          END IF;
          IF v_V_ISSUE_DATE IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', ISSUE_DATE = '||''''|| v_V_ISSUE_DATE ||'''';
          END IF;
          IF v_V_REVIEW_DATE IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', REVIEW_DATE = '||''''|| v_V_REVIEW_DATE ||'''';
          END IF;
          IF v_V_RENEWAL_DATE IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', RENEWAL_DATE = '||''''|| v_V_RENEWAL_DATE ||'''';
          END IF;
          IF v_V_CANCEL_DATE IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', CANCEL_DATE = '||''''|| v_V_CANCEL_DATE ||'''';
          END IF;
          IF v_V_PREF_DAY_PAY_TYPE_ID > 0 THEN
             v_V_SQL := v_V_SQL || ', PREF_DAY_CODE = ' || v_V_PREF_DAY_PAY_TYPE_ID;
          END IF;
          IF v_V_PREF_DAY_PAY_TYPE_ID > 0 THEN
             v_V_SQL := v_V_SQL || ', PREF_PAY_SCH_CODE =  ' || v_V_PREF_PAY_SCHEDULE_TYPE_ID;
          END IF;
          IF v_V_COMMENTS IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', COMMENTS = '||''''|| v_V_COMMENTS ||'''';
          END IF;
          IF v_V_PRINT_BEFORE_END_FLAG_ID IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', PRINT_BEFORE_END = '|| v_V_PRINT_BEFORE_END_FLAG_ID;
          END IF;
          IF v_V_START_PAY_PERIOD IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', START_PAY_PERIOD = '||''''|| v_V_START_PAY_PERIOD ||'''';
          END IF;
          IF v_V_SUB_ACC_ROW_ID > 0 THEN
             v_V_SQL := v_V_SQL || ', SUB_ACC_ROW_ID = '||v_V_SUB_ACC_ROW_ID;
          END IF;
          IF v_V_COMMENTS IS NOT NULL THEN
             v_V_SQL := v_V_SQL || ', HTMLCOMMENTS = '||''''|| v_V_COMMENTS ||'''';
          END IF;

          v_V_SQL := v_V_SQL || ' WHERE PLAN_ID = ' || v_V_PLAN_ID;

          EXECUTE IMMEDIATE V_V_SQL;

        END IF;

        IF v_V_INSUREDHIERRACHYOK = 1 THEN
          v_V_ERRORLOC := 'INS06';

            IF v_V_INSURED_EID IS NOT NULL THEN 
               v_vReqColumns := v_V_INSURED_EID || '|';
            END IF;

            IF v_V_INSURED_HIER_LEVEL IS NOT NULL THEN 
               v_vReqColumns1 := v_V_INSURED_HIER_LEVEL || '|';
            END IF;

          WHILE INSTR(v_vReqColumns, '|', 1) > 0
          LOOP

            v_vColName1 := SUBSTR(v_vReqColumns, 1, INSTR(v_vReqColumns, '|', 1) - 1);
            v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns, 1, INSTR(v_vReqColumns,'|', 1))) + 1, LENGTH(v_vReqColumns));
            v_vColName2 := SUBSTR(v_vReqColumns1, 1, INSTR(v_vReqColumns1, '|', 1) - 1);
            v_vReqColumns1 := SUBSTR(v_vReqColumns1,LENGTH(SUBSTR(v_vReqColumns1, 1, INSTR(v_vReqColumns1,'|', 1))) + 1, LENGTH(v_vReqColumns1));

            v_V_ERRORLOC := 'INS07';
            v_V_ENTITY_ID := 0;
            v_V_ENTITY_TABLE_ID := CAST(v_vColName2 AS INT) + 1004;

            v_V_SQL := 'SELECT ENTITY_ID FROM ' || v_V_DBNAME || 'ENTITY WHERE ABBREVIATION = :1  AND ENTITY_TABLE_ID = :2 AND DELETED_FLAG = 0';

            BEGIN
                 EXECUTE IMMEDIATE V_V_SQL INTO v_V_ENTITY_ID USING v_vColName1, v_V_ENTITY_TABLE_ID;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_V_ENTITY_ID := 0;
            END;

            IF v_V_ENTITY_ID > 0 THEN

              v_V_ERRORLOC := 'INS08';
              v_V_INSURED_EID_RMDB := 0;

              v_V_SQL := 'SELECT INSURED_EID FROM ' || v_V_DBNAME || 'DIS_PLAN_X_INSURED WHERE PLAN_ID = :1 AND INSURED_EID = :2 ';

              BEGIN
                   EXECUTE IMMEDIATE V_V_SQL INTO v_V_INSURED_EID_RMDB USING v_V_PLAN_ID, v_V_ENTITY_ID;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   v_V_INSURED_EID_RMDB := 0;
              END;

              IF v_V_INSURED_EID_RMDB = 0  THEN

                v_V_ERRORLOC := 'INS09';
                v_V_SQL := 'INSERT INTO ' || v_V_DBNAME || 'DIS_PLAN_X_INSURED(PLAN_ID,INSURED_EID)';
                v_V_SQL :=  v_V_SQL || ' VALUES(:1, :2)';

                EXECUTE IMMEDIATE V_V_SQL USING v_V_PLAN_ID, v_V_ENTITY_ID;

              END IF;
          END IF;
       END LOOP;
     END IF;


      IF v_V_STD_PLAN_SUPP = 1  THEN -- SUPPLEMENTAL COLUMN INSERT BEGIN
        v_V_ERRORLOC := 'INS10';

        IF v_V_PLAN_ID > 0 THEN
          DDS_SUPPLEMENT( v_P_JOBID, v_CONFIG_ID, v_P_USER_ID, v_V_MODULENAME, v_V_DBNAME, v_V_DA_ROW_ID, v_CheckCreateNewCodes, 0,
          v_V_ERRORCOUNT, 'I',  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, v_V_PLAN_ID,0,0, 'PLAN NUMBER', v_V_PLAN_NUMBER, v_V_SUPP_ERROR_COUNT);
        END IF;

      END IF; -- SUPPLEMENTAL COLUMN INSERT END

    END IF;

   EXCEPTION
      WHEN OTHERS THEN
            v_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  v_V_ERRORLOC,
                                  v_V_ERRORLOC,
                                  v_V_PROCNAME,
                                  v_V_ERROR_MESSAGE,
                                  'EXCEPTION',
                                  v_V_ERROR_TABLE,
                                  'PLAN_NUMBER',
                                  v_V_PLAN_NUMBER,
                                  0);

            v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
            ROLLBACK;
   END; ----END LEVEL INSERT/UPDATE
        ----INSERT WORK ENDS

  --********************************************************************************************************************************************************************

  v_V_ERRORLOC := 'END666';

  IF v_V_ROWCOUNT + v_V_ERRORCOUNT = 0 THEN
     v_V_INVALID_ROW := 0;
  ELSE
  v_V_INVALID_ROW := 1;
  END IF;

  IF v_V_INVALID_ROW = 0 THEN
  BEGIN
    v_V_SQL := 'UPDATE DDS_STD_PLAN SET INVALID_ROW = :1 WHERE DA_ROW_ID = :2  AND JOBID = :3';

    EXECUTE IMMEDIATE V_V_SQL USING v_V_INVALID_ROW, v_V_DA_ROW_ID, v_P_JOBID ;

    COMMIT;
  EXCEPTION
      WHEN OTHERS THEN
            v_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  v_V_ERRORLOC,
                                  v_V_ERRORLOC,
                                  v_V_PROCNAME,
                                  v_V_ERROR_MESSAGE,
                                  'EXCEPTION',
                                  v_V_ERROR_TABLE,
                                  'PLAN_NUMBER',
                                  v_V_PLAN_NUMBER,
                                  0);
            v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
            ROLLBACK;
   END;
   END IF;
      ---Neha Running status code starts 33658--- 
      --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);  
    
      IF v_iRunStatCnt = 1 THEN
        BEGIN
          v_vProcessMsg := 'Total Number of Records processed in STD PLAN : ' ||v_iRunStatCnt;
          EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
            USING v_P_JOBID, v_vProcessMsg, 'STD_PLAN_RUN', 'DDS_STD_PLAN_RUN', -11;
        END;
       ELSIF v_iRunCnt = 1000 THEN
          BEGIN
            v_vProcessMsg := 'Total Number of Records processed in STD PLAN : ' || v_iRunStatCnt;
            v_V_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
            MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
            EXECUTE IMMEDIATE v_V_SQL using v_vProcessMsg, v_P_JOBID, 'STD_PLAN_RUN', 'DDS_STD_PLAN_RUN';
            v_iRunCnt:=1;
          END;
        ELSIF (v_iCount=v_iRunStatCnt) THEN
              BEGIN
              v_vProcessMsg := 'Total Number of Records processed in STD PLAN : ' ||v_iCount;
              v_V_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
              MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
  
              EXECUTE IMMEDIATE v_V_SQL using v_vProcessMsg, v_P_JOBID, 'STD_PLAN_RUN', 'DDS_STD_PLAN_RUN';
             END;
      END IF;
      COMMIT;
    
      v_iRunStatCnt := v_iRunStatCnt + 1;
      v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658---
      -----------******************************************************************************************************************** 

   END;
   END LOOP;
  CLOSE DDS_STD_PLAN_CUR;

<<ENDMAIN>>
DDS_PROCESS_LOG( v_P_JOBID, v_V_MODULENAME, v_V_ERROR_TABLE);

EXCEPTION
WHEN OTHERS THEN
v_V_ERRORLOC:='MAIN';
    v_V_ERROR_MESSAGE := SQLERRM;
    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                          v_V_DA_ROW_ID,
                          v_V_MODULENAME,
                          v_V_ERRORLOC,
                          v_V_ERRORLOC,
                          v_V_PROCNAME,
                          v_V_ERROR_MESSAGE,
                          'EXCEPTION',
                          v_V_ERROR_TABLE,
                          'CLAIM_NUMBER',
                          v_V_PLAN_NUMBER,
                          0);
    ROLLBACK;

END DDS_IMPORT_STD_PLAN;