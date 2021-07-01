CREATE OR REPLACE PROCEDURE DA_DDS_MEDWATCH_IMPORT
(
  v_p_JobID IN NUMBER DEFAULT NULL ,
  v_p_Dbname IN VARCHAR2 DEFAULT NULL ,
  v_p_UserID IN NUMBER DEFAULT NULL
)AUTHID DEFINER
AS
         CURSOR Cur_MedWatch IS SELECT JOBID,
         DA_ROW_ID,
         Invalid_Row,
         Update_Row,
         EVENT_NUMBER,
         UNIT_CODE,
         DATE_RPTD_FDA,
         DATE_RPTD_MFG,
         RPTD_BY_LAST_NAME,
         RPTD_BY_FIRST_NAME,
         RPTD_BY_ADDR1,
         RPTD_BY_ADDR2,
         RPTD_BY_CITY,
         RPTD_BY_STATE,
         RPTD_BY_ZIP_CODE,
         RPTD_BY_TAX_ID,
         RPTD_BY_PRO_FLAG,
         RPTD_BY_POS_CODE,
         RELEVANT_HISTORY,
         LAST_REPORT_DATE,
         REPORT_YEAR,
         REPORT_SERIAL_NO,
         ADVERSE_EVENT_FLAG,
         PRODUCT_PROB_FLAG,
         LIFE_THREAT_FLAG,
         HOSPITALIZ_FLAG,
         DISABILITY_FLAG,
         CONGENITAL_FLAG,
         REQD_INTERV_FLAG,
         FOLLOW_UP_COUNT,
         RPT_MANDATORY,
         MED_TYPE,
         MED_NAME,
         DOSE,
         FREQUENCY,
         ROUTE,
         THERAPY_FROM_DATE,
         THERAPY_TO_DATE,
         DURATION,
         LOT_NUMBER,
         NDC_NUMBER,
         EXPIRATION_DATE,
         EVENT_ABATED,
         EVENT_REAPPEARED,
         DIAGNOSIS_TEST,
         BRAND_NAME,
         EQUIP_TYPE_CODE,
         MANUF_NAME,
         MANUF_ADDR1,
         MANUF_ADDR2,
         MANUF_CITY,
         MANUF_STATE,
         MANUF_ZIP_CODE,
         MODEL_NUMBER,
         CATALOG_NUMBER,
         SERIAL_NUMBER,
         OTHER_NUMBER,
         DEVICE_OPER_CODE,
         IMPLANT_DATE,
         EXPLANT_DATE,
         AGE_OF_DEVICE,
         DEV_AVAIL_FOR_EVAL,
         DEVICE_RETURN_DATE,
         EQ_LOT_NUMBER,
         EQ_EXPIRATION_DATE,
         TEST_LAB_TEST_1,
         TEST_LAB_TEST_2,
         TEST_LAB_TEST_3,
         TEST_LAB_TEST_4,
         TEST_LAB_TEST_5,
         TEST_RESULT_1,
         TEST_RESULT_2,
         TEST_RESULT_3,
         TEST_RESULT_4,
         TEST_RESULT_5,
         TEST_DATE_1,
         TEST_DATE_2,
         TEST_DATE_3,
         TEST_DATE_4,
         TEST_DATE_5,
         CONCOM_PRODUCT_ID_1,
         CONCOM_PRODUCT_ID_2,
         CONCOM_PRODUCT_ID_3,
         CONCOM_PRODUCT_ID_4,
         CONCOM_PRODUCT_ID_5,
         CONCOM_PRODUCT_ID_6,
         CONCOM_FROM_DATE_1,
         CONCOM_FROM_DATE_2,
         CONCOM_FROM_DATE_3,
         CONCOM_FROM_DATE_4,
         CONCOM_FROM_DATE_5,
         CONCOM_FROM_DATE_6,
         CONCOM_TO_DATE_1,
         CONCOM_TO_DATE_2,
         CONCOM_TO_DATE_3,
         CONCOM_TO_DATE_4,
         CONCOM_TO_DATE_5,
         CONCOM_TO_DATE_6,
         CONCOM_PRODUCT_1,
         CONCOM_PRODUCT_2,
         CONCOM_PRODUCT_3,
         CONCOM_PRODUCT_4,
         CONCOM_PRODUCT_5,
         CONCOM_PRODUCT_6,
         NAME_TYPE,
         RPTD_BY_BIRTH_DT,
         MANUF_BIRTH_DT
           FROM DDS_MEDWATCH
            WHERE JOBID = v_p_Jobid
           AND Invalid_Row = 1;

       v_CheckCreateNewCodes NUMBER(5,0);
         v_CONFIG_ID NUMBER(5,0);
         v_VALID_START_DATE VARCHAR2(8);
         v_NonEmployeeMatchByName NUMBER(5,0);
         v_NonEmployeeMatchByTaxId NUMBER(5,0);
         v_MEDWATCH_SUPP NUMBER(5,0);
         v_VALID_END_DATE VARCHAR2(8);
         v_v_JOBID NUMBER(10,0);
         v_v_DA_Row_ID NUMBER(10,0);
         v_v_Invalid_Row NUMBER(10,0);
         v_v_Update_Row NUMBER(10,0);
         v_v_EVENT_NUMBER VARCHAR2(25);
         v_v_UNIT_CODE VARCHAR2(25);
         v_v_DATE_RPTD_FDA varchar2(8);
         v_v_DATE_RPTD_MFG varchar2(8);
         v_v_RPTD_BY_LAST_NAME varchar2(255);
         v_v_RPTD_BY_FIRST_NAME varchar2(255);
         v_v_RPTD_BY_ADDR1 varchar2(100);
         v_v_RPTD_BY_ADDR2 varchar2(100);
         v_v_RPTD_BY_CITY varchar2(50);
         v_v_RPTD_BY_STATE varchar2(4);
         v_v_RPTD_BY_ZIP_CODE varchar2(10);
         v_v_RPTD_BY_TAX_ID varchar2(20);
         v_v_RPTD_BY_PRO_FLAG varchar2(1);
         v_v_RPTD_BY_POS_CODE varchar2(25);
         v_v_RELEVANT_HISTORY CLOB ;
         v_v_LAST_REPORT_DATE varchar2(8);
         v_v_REPORT_YEAR NUMBER(10,0);
         v_v_REPORT_SERIAL_NO NUMBER(10,0);
         v_v_ADVERSE_EVENT_FLAG varchar2(1);
         v_v_PRODUCT_PROB_FLAG varchar2(1);
         v_v_LIFE_THREAT_FLAG varchar2(1);
         v_v_HOSPITALIZ_FLAG varchar2(1);
         v_v_DISABILITY_FLAG varchar2(1);
         v_v_CONGENITAL_FLAG varchar2(1);
         v_v_REQD_INTERV_FLAG varchar2(1);
         v_v_FOLLOW_UP_COUNT NUMBER(10,0);
         v_v_RPT_MANDATORY varchar2(1);
         v_v_MED_TYPE varchar2(25);
         v_v_MED_NAME varchar2(25);
         v_v_DOSE varchar2(25);
         v_v_FREQUENCY varchar2(25);
         v_v_ROUTE varchar2(25);
         v_v_THERAPY_FROM_DATE varchar2(8);
         v_v_THERAPY_TO_DATE varchar2(8);
         v_v_DURATION NUMBER(10,0);
         v_v_LOT_NUMBER varchar2(15);
         v_v_NDC_NUMBER NUMBER(10,0);
         v_v_EXPIRATION_DATE varchar2(8);
         v_v_EVENT_ABATED varchar2(1);
         v_v_EVENT_REAPPEARED varchar2(1);
         v_v_DIAGNOSIS_TEST varchar2(25);
         v_v_BRAND_NAME varchar2(25);
         v_v_EQUIP_TYPE_CODE varchar2(25);
         v_v_MANUF_NAME varchar2(255);
         v_v_MANUF_ADDR1 varchar2(100);
         v_v_MANUF_ADDR2 varchar2(100);
         v_v_MANUF_CITY varchar2(50);
         v_v_MANUF_STATE varchar2(4);
         v_v_MANUF_ZIP_CODE varchar2(10);
         v_v_MODEL_NUMBER varchar2(15);
         v_v_CATALOG_NUMBER varchar2(15);
         v_v_SERIAL_NUMBER varchar2(15);
         v_v_OTHER_NUMBER varchar2(15);
         v_v_DEVICE_OPER_CODE varchar2(25);
         v_v_IMPLANT_DATE varchar2(8);
         v_v_EXPLANT_DATE varchar2(8);
         v_v_AGE_OF_DEVICE varchar2(12);
         v_v_DEV_AVAIL_FOR_EVAL varchar2(1);
         v_v_DEVICE_RETURN_DATE varchar2(8);
         v_v_EQ_LOT_NUMBER varchar2(15);
         v_v_EQ_EXPIRATION_DATE varchar2(8);
         v_v_TEST_LAB_TEST_1 CLOB ;
         v_v_TEST_LAB_TEST_2  CLOB ;
         v_v_TEST_LAB_TEST_3 CLOB ;
         v_v_TEST_LAB_TEST_4 CLOB ;
         v_v_TEST_LAB_TEST_5  CLOB ;
         v_v_TEST_RESULT_1  CLOB ;
         v_v_TEST_RESULT_2  CLOB ;
         v_v_TEST_RESULT_3  CLOB ;
         v_v_TEST_RESULT_4  CLOB ;
         v_v_TEST_RESULT_5  CLOB ;
         v_v_TEST_DATE_1 varchar2(8);
         v_v_TEST_DATE_2 varchar2(8);
         v_v_TEST_DATE_3 varchar2(8);
         v_v_TEST_DATE_4 varchar2(8);
         v_v_TEST_DATE_5 varchar2(8);
         v_v_CONCOM_PRODUCT_ID_1 NUMBER(10,0);
         v_v_CONCOM_PRODUCT_ID_2 NUMBER(10,0);
         v_v_CONCOM_PRODUCT_ID_3 NUMBER(10,0);
         v_v_CONCOM_PRODUCT_ID_4 NUMBER(10,0);
         v_v_CONCOM_PRODUCT_ID_5 NUMBER(10,0);
         v_v_CONCOM_PRODUCT_ID_6 NUMBER(10,0);
         v_v_CONCOM_FROM_DATE_1 varchar2(8);
         v_v_CONCOM_FROM_DATE_2 varchar2(8);
         v_v_CONCOM_FROM_DATE_3 varchar2(8);
         v_v_CONCOM_FROM_DATE_4 varchar2(8);
         v_v_CONCOM_FROM_DATE_5 varchar2(8);
         v_v_CONCOM_FROM_DATE_6 varchar2(8);
         v_v_CONCOM_TO_DATE_1 varchar2(8);
         v_v_CONCOM_TO_DATE_2 varchar2(8);
         v_v_CONCOM_TO_DATE_3 varchar2(8);
         v_v_CONCOM_TO_DATE_4 varchar2(8);
         v_v_CONCOM_TO_DATE_5 varchar2(8);
         v_v_CONCOM_TO_DATE_6 varchar2(8);
         v_v_CONCOM_PRODUCT_1 varchar2(40);
         v_v_CONCOM_PRODUCT_2 varchar2(40);
         v_v_CONCOM_PRODUCT_3 varchar2(40);
         v_v_CONCOM_PRODUCT_4 varchar2(40);
         v_v_CONCOM_PRODUCT_5 varchar2(40);
         v_v_CONCOM_PRODUCT_6 varchar2(40);
         v_v_NAME_TYPE varchar2(25);
         v_RPTD_BY_POS_CODE_R NUMBER(10,0);
         v_MED_TYPE_R NUMBER(10,0);
         v_EQUIP_TYPE_CODE_R NUMBER(10,0);
         v_DEVICE_OPER_CODE_R NUMBER(10,0);
         v_NAME_TYPE_R NUMBER(10,0);
         v_RPTD_BY_BIRTH_DT VARCHAR2(8);
         v_MANUF_BIRTH_DT VARCHAR2(8);

         v_Event_ID_MED number := 0;
          v_UNIT_CODE_R number := 0;
          v_LIFE_THREAT_FLAG_R number := 0;
          v_v_Next_unique_id number := 0;
          v_v_EV_MW_TEST_ROW_ID_GEN number := 0;
          v_v_EV_CONCOM_ROW_ID_GEN number := 0;
          v_v_EV_X_CONCOM_PROD_GEN number := 0;
v_iTaxErr INT := 0 ;
v_vErrMsgDesc VARCHAR2(4000);

           -- Declare Code realted variables
      --v_RPTD_BY_POS_CODE_R NUMBER(10,0);
      --v_MED_TYPE_R NUMBER(10,0);
      --v_EQUIP_TYPE_CODE_R NUMBER(10,0);
      --v_DEVICE_OPER_CODE_R NUMBER(10,0);
      --v_NAME_TYPE_R NUMBER(10,0);
      -- Declare Other variables
      v_TotalRows NUMBER(10,0);
      v_v_Dbname VARCHAR2(200);
      V_I_ERRORCOUNT NUMBER(10,0) := 0 ;
      v_V_ERROR_MESSAGE VARCHAR2(4000);
      v_V_ERROR_LOCATION_MAIN VARCHAR2(255);
      v_v_ColName VARCHAR2(255);
      v_v_ColName1 VARCHAR2(255);
      v_v_ColName2 VARCHAR2(255);
      v_v_ColName3 VARCHAR2(255);
      v_v_ColName1List VARCHAR2(4000);
      v_v_ColName2List VARCHAR2(4000);
      v_v_ColName3List VARCHAR2(4000);
      v_v_TableName VARCHAR2(255);
      v_v_ColNameList VARCHAR2(4000);
      v_v_TableNameList VARCHAR2(4000);
      v_v_Val VARCHAR2(255);
      v_v_Val1 VARCHAR2(255);
      v_v_Val2 VARCHAR2(255);
      v_v_Val3 VARCHAR2(255);
      v_N_sql Clob ;
      v_MANUF_STATE_R NUMBER(10,0) := 0;
      v_RPTD_BY_STATE_R NUMBER(10,0):= 0;
      v_RPTD_BY_PRO_FLAG_R   NUMBER(10,0) := 0;
      v_ADVERSE_EVENT_FLAG_R  NUMBER(10,0) := 0;
      v_PRODUCT_PROB_FLAG_R NUMBER(10,0) := 0;
      v_HOSPITALIZ_FLAG_R NUMBER(10,0) := 0;
      v_DISABILITY_FLAG_R  NUMBER(10,0) := 0;
      v_CONGENITAL_FLAG_R   NUMBER(10,0) := 0;
      v_REQD_INTERV_FLAG_R  NUMBER(10,0) := 0;
      v_RPTD_BY_TAX_ID_Invalid_Flag number := 0;
      v_V_PROCNAME varchar2(25) := 'DA_DDS_MEDWATCH_IMPORT';
      v_V_ERROR_LOCATION_MAIN VARCHAR2(255);
      v_V_ERROR_TABLE_TO_CHECK varchar2(25) := 'DDS_MEDWATCH';
      v_iCodeId number := 0;
  ---neha 33658 -- START 
  v_iRunStatCnt    NUMBER(10, 0):=1;  
  v_iRunCnt        NUMBER(10, 0):=1;  
  v_vProcessMsg    varchar2(4000); 
  v_iCount         NUMBER(10, 0) := 0; 
  ---neha 33658 -- end

      v_i_MANUF_ENTITY_ID_GEN number := 0;
      v_Entity_Id number := 0;
      v_Do_Nothing number := 0;
      v_Event_ID number := 0;
      v_DEV_AVAIL_FOR_EVAL_R number := 0;
      v_EVENT_REAPPEARED_R number := 0;
      v_EVENT_ABATED_R number := 0;
      v_RPT_MANDATORY_R number := 0;
      v_REVENT_ABATED_R number := 0;
      V_V_MODULENAME varchar2(25) := 'MEDWATCH';

      v_ErrorColumn VARCHAR2(255);
      v_iEntId NUMBER(10,0);
      v_i_Reporter_ENTITY_ID_GEN NUMBER(10,0);
      v_iNoError NUMBER(10,0);
      --v_PERSON TENTITY;
      v_V_DTTM_RCD_LAST_UPD_GEN VARCHAR2(255);
      v_v_UPDATED_BY_USER VARCHAR2(25);
      v_V_ERROR_LOCATION NVARCHAR2(255);
      v_P_SUPP_ERROR_COUNT_R NUMBER(10,0):= 0;
      VENTITY_TYPE  DDS_ENTITY_TYPE;
      v_v_EV_X_CONCOM_PROD_RMDB NUMBER(10,0):= 0;

      v_v_EV_MW_TEST_ROW_ID_GEN_RMDB NUMBER(10,0) := 0;
      v_v_ErrorColName NVARCHAR2(255);
      v_Event_ID_Icon Number := 0  ;
      v_NonEmpMatchByDob NUMBER;   --JIRA 27137 knakra
     -- v_I_ERRORCOUNT

   BEGIN
      BEGIN

      BEGIN
         SELECT ALLOW_NEW_CODES,
                CONFIG_ID,
                MEDWATCH_SUPP,
                NON_EMP_MATCH_BY_NAME,
                NON_EMP_MATCH_BY_TAX_ID,
                VALID_END_DATE,
                VALID_START_DATE,
                NON_EMP_MATCH_BY_DOB      --JIRA 27137 knakra
           INTO v_CheckCreateNewCodes,
                v_CONFIG_ID,
                v_MEDWATCH_SUPP,
                v_NonEmployeeMatchByName ,
                v_NonEmployeeMatchByTaxId  ,
                v_VALID_END_DATE,
                v_VALID_START_DATE,
                v_NonEmpMatchByDob         --JIRA 27137 knakra
           FROM DDS_OPTIONSET
            WHERE JOBID = v_p_jobID;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL; -- kAPIL nEED TO ADD ERROR LOG
         END;
    BEGIN --Neha Running status starts 33658
    SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_MEDWATCH WHERE JOBID = v_p_jobID AND INVALID_ROW=1; 
       exception
           when no_data_found then
           null; 
    END; --Neha Running status ends 33658
         -- Declare Other variables
         IF v_p_Dbname IS NOT NULL THEN
            v_v_Dbname := v_p_Dbname || '.';
         END IF;

         v_V_ERROR_LOCATION := 'MW1';

         v_V_ERROR_LOCATION := 'MW2';


         OPEN Cur_MEDWATCH;
         LOOP
         FETCH Cur_MedWatch INTO v_v_JobID,v_v_DA_Row_ID,v_v_Invalid_Row,v_v_Update_Row,v_v_EVENT_NUMBER,v_v_UNIT_CODE,v_v_DATE_RPTD_FDA,v_v_DATE_RPTD_MFG,v_v_RPTD_BY_LAST_NAME,v_v_RPTD_BY_FIRST_NAME,v_v_RPTD_BY_ADDR1,v_v_RPTD_BY_ADDR2,v_v_RPTD_BY_CITY,v_v_RPTD_BY_STATE,v_v_RPTD_BY_ZIP_CODE,v_v_RPTD_BY_TAX_ID,v_v_RPTD_BY_PRO_FLAG,v_v_RPTD_BY_POS_CODE,v_v_RELEVANT_HISTORY,v_v_LAST_REPORT_DATE,v_v_REPORT_YEAR,v_v_REPORT_SERIAL_NO,v_v_ADVERSE_EVENT_FLAG,v_v_PRODUCT_PROB_FLAG,v_v_LIFE_THREAT_FLAG,v_v_HOSPITALIZ_FLAG,v_v_DISABILITY_FLAG,v_v_CONGENITAL_FLAG,v_v_REQD_INTERV_FLAG,v_v_FOLLOW_UP_COUNT,v_v_RPT_MANDATORY,v_v_MED_TYPE,v_v_MED_NAME,v_v_DOSE,v_v_FREQUENCY,v_v_ROUTE,v_v_THERAPY_FROM_DATE,v_v_THERAPY_TO_DATE,v_v_DURATION,v_v_LOT_NUMBER,v_v_NDC_NUMBER,v_v_EXPIRATION_DATE,v_v_EVENT_ABATED,v_v_EVENT_REAPPEARED,v_v_DIAGNOSIS_TEST,v_v_BRAND_NAME,v_v_EQUIP_TYPE_CODE,v_v_MANUF_NAME,v_v_MANUF_ADDR1,v_v_MANUF_ADDR2,v_v_MANUF_CITY,v_v_MANUF_STATE,v_v_MANUF_ZIP_CODE,v_v_MODEL_NUMBER,v_v_CATALOG_NUMBER,v_v_SERIAL_NUMBER,v_v_OTHER_NUMBER,v_v_DEVICE_OPER_CODE,v_v_IMPLANT_DATE,v_v_EXPLANT_DATE,v_v_AGE_OF_DEVICE,v_v_DEV_AVAIL_FOR_EVAL,v_v_DEVICE_RETURN_DATE,v_v_EQ_LOT_NUMBER,v_v_EQ_EXPIRATION_DATE,v_v_TEST_LAB_TEST_1,v_v_TEST_LAB_TEST_2,v_v_TEST_LAB_TEST_3,v_v_TEST_LAB_TEST_4,v_v_TEST_LAB_TEST_5,v_v_TEST_RESULT_1,v_v_TEST_RESULT_2,v_v_TEST_RESULT_3,v_v_TEST_RESULT_4,v_v_TEST_RESULT_5,v_v_TEST_DATE_1,v_v_TEST_DATE_2,v_v_TEST_DATE_3,v_v_TEST_DATE_4,v_v_TEST_DATE_5,v_v_CONCOM_PRODUCT_ID_1,v_v_CONCOM_PRODUCT_ID_2,v_v_CONCOM_PRODUCT_ID_3,v_v_CONCOM_PRODUCT_ID_4,v_v_CONCOM_PRODUCT_ID_5,v_v_CONCOM_PRODUCT_ID_6,v_v_CONCOM_FROM_DATE_1,v_v_CONCOM_FROM_DATE_2,v_v_CONCOM_FROM_DATE_3,v_v_CONCOM_FROM_DATE_4,v_v_CONCOM_FROM_DATE_5,v_v_CONCOM_FROM_DATE_6,v_v_CONCOM_TO_DATE_1,v_v_CONCOM_TO_DATE_2,v_v_CONCOM_TO_DATE_3,v_v_CONCOM_TO_DATE_4,v_v_CONCOM_TO_DATE_5,v_v_CONCOM_TO_DATE_6,v_v_CONCOM_PRODUCT_1,v_v_CONCOM_PRODUCT_2,v_v_CONCOM_PRODUCT_3,v_v_CONCOM_PRODUCT_4,v_v_CONCOM_PRODUCT_5,v_v_CONCOM_PRODUCT_6,v_v_NAME_TYPE,v_RPTD_BY_BIRTH_DT,v_MANUF_BIRTH_DT;
         EXIT WHEN Cur_MEDWATCH%NOTFOUND;
         v_V_ERROR_LOCATION := 'MW3';

            BEGIN
               BEGIN
                  BEGIN
                     v_V_ERROR_LOCATION := 'MW4';

                    /* BEGIN-- 12. Event number must exist

                        v_N_Sql := 'Select Event_Id from ' || v_v_Dbname || ' Event where Event_Number = :1';

                        v_V_ERROR_LOCATION := 'MW5';

                        BEGIN

                        EXECUTE IMMEDIATE V_N_SQL INTO v_Event_ID USING v_v_Event_Number;
                              v_V_ERROR_LOCATION := 'MW6';
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                            v_Event_ID:=0;
                           WHEN OTHERS THEN
                                 v_V_ERROR_MESSAGE := SQLERRM;

                                 DDS_ERROR_LOG_CAPTURE(v_p_JobID,
                                                       v_V_DA_ROW_ID,
                                                       v_V_MODULENAME,
                                                       'Main',
                                                       'EvntExist1',
                                                       v_V_PROCNAME,
                                                       v_V_ERROR_MESSAGE,
                                                       null,
                                                       v_V_ERROR_TABLE_TO_CHECK,
                                                       'EVENT_NUMBER',
                                                       v_v_EVENT_NUMBER,
                                                       0);

                                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END;

                        IF ( v_Event_ID = 0 ) THEN
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_V_DA_ROW_ID,
                                                 v_V_MODULENAME,
                                                 'Main',
                                                 'EvntExist',
                                                 v_V_PROCNAME,
                                                 'The Event does not exists corresponding to this Event_Number.Please provide a valid Event_number.',
                                                 'EVENT_NUMBER',
                                                 v_V_ERROR_TABLE_TO_CHECK,
                                                 'EVENT_NUMBER',
                                                 v_v_EVENT_NUMBER,
                                                 1);

                           v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END IF;

                     END;
*/                     v_V_ERROR_LOCATION := 'MW7';

                     --IF ( v_Event_ID > 0 ) THEN
                     BEGIN
                        IF v_v_EVENT_NUMBER IS NULL THEN-- 1. Required Field Validation
                           DDS_ERROR_LOG_CAPTURE(v_v_JOBID,
                                                 v_V_DA_ROW_ID,
                                                 v_V_MODULENAME,
                                                 'Main',
                                                 'REQVD',
                                                 v_V_PROCNAME,
                                                 'Required Fields are Null or Empty.Please provide a valid value.',
                                                 'EVENT_NUMBER',
                                                 v_V_ERROR_TABLE_TO_CHECK,
                                                 'EVENT_NUMBER',
                                                 v_v_EVENT_NUMBER,
                                                 1);

                           v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END IF;

                        v_V_ERROR_LOCATION := 'MW8';
                         IF v_v_RPTD_BY_LAST_NAME  IS NULL THEN-- MKAUR24 AK
                           DDS_ERROR_LOG_CAPTURE(v_v_JOBID,
                                                 v_V_DA_ROW_ID,
                                                 v_V_MODULENAME,
                                                 'Main',
                                                 'REQVD',
                                                 v_V_PROCNAME,
                                                 'Required Fields are Null or Empty.Please provide a valid value.',
                                                 'RPTD_BY_LAST_NAME',
                                                 v_V_ERROR_TABLE_TO_CHECK,
                                                 'EVENT_NUMBER',
                                                 v_v_EVENT_NUMBER,
                                                 1);

                           v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END IF;







                        BEGIN-- 2. Code Field Validation

                           v_v_ColNameList := 'RPTD_BY_POS_CODE|MED_TYPE|EQUIP_TYPE_CODE|DEVICE_OPER_CODE|NAME_TYPE|';
                           v_v_TableNameList := 'POSITIONS|MEDICATION_TYPE|EQUIP_TYPE_CODE|DEVICE_OPER_CODES|ENTITY_NAME_TYPE|';

                           WHILE INSTR(v_v_ColNameList, '|', 1) > 0
                           LOOP
                               v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
                               v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));

                               v_v_TableName := SUBSTR(v_v_TableNameList, 0, INSTR(v_v_TableNameList, '|', 1) - 1);
                               v_v_TableNameList := SUBSTR(v_v_TableNameList,LENGTH(SUBSTR(v_v_TableNameList,1,INSTR(v_v_TableNameList, '|', 1)))+1,LENGTH(v_v_TableNameList));

                                 v_v_Val := (CASE
                                                  WHEN v_v_ColName = 'RPTD_BY_POS_CODE' THEN v_v_RPTD_BY_POS_CODE
                                                  WHEN v_v_ColName = 'MED_TYPE' THEN v_v_MED_TYPE
                                                  WHEN v_v_ColName = 'EQUIP_TYPE_CODE' THEN v_v_EQUIP_TYPE_CODE
                                                  WHEN v_v_ColName = 'DEVICE_OPER_CODE' THEN v_v_DEVICE_OPER_CODE
                                                  WHEN v_v_NAME_TYPE = 'NAME_TYPE' THEN v_v_NAME_TYPE   END);

                                 IF v_v_Val IS NOT NULL THEN
                                    DDS_CODE_VALIDATION_IMPORT( v_p_JOBID,
                                                               v_v_Val,-- Short Code
                                                               v_v_TableName,-- SYstem Table Name to Check
                                                               v_CheckCreateNewCodes,-- It is used to check allow creation of code flag is set by user or not
                                                               v_v_Dbname,-- It is used to fetch error msg and append into the error msg and update it again
                                                               0,-- LOB GC, WC ( It Will be numeric)
                                                               v_v_DA_ROW_ID,
                                                               v_V_MODULENAME,
                                                               'CODEVD31',--mkaur24
                                                               'DDS_CODE_VALIDATION_IMPORT',
                                                               'EVENT_NUMBER',
                                                               v_v_ColName,
                                                               v_V_ERROR_TABLE_TO_CHECK,
                                                               v_v_EVENT_NUMBER,
                                                               v_iCodeId);

                                    IF v_iCodeId = 0 OR v_iCodeId IS NULL THEN
                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                                    END IF;
                                 END IF;

                                 IF v_v_ColName = 'RPTD_BY_POS_CODE' THEN
                                    v_RPTD_BY_POS_CODE_R := v_iCodeId;--come
                                 ELSIF v_v_ColName = 'MED_TYPE' THEN
                                       v_MED_TYPE_R := v_iCodeId;
                                    ELSIF v_v_ColName = 'EQUIP_TYPE_CODE' THEN
                                          v_EQUIP_TYPE_CODE_R := v_iCodeId;
                                       ELSIF v_v_ColName = 'DEVICE_OPER_CODE' THEN
                                             v_DEVICE_OPER_CODE_R := v_iCodeId;
                                          ELSIF v_v_ColName = 'NAME_TYPE' THEN
                                                v_NAME_TYPE_R := v_iCodeId;
                                 END IF;

                                 v_iCodeId := NULL;
                           END LOOP;

                        END;
                        v_V_ERROR_LOCATION := 'MW9';

                        BEGIN-- 3. Date Format Validation

                           v_v_ColNameList := 'DEVICE_RETURN_DATE|EXPIRATION_DATE|IMPLANT_DATE|EXPLANT_DATE|LAST_REPORT_DATE|THERAPY_FROM_DATE|DATE_RPTD_MFG|THERAPY_TO_DATE|';
                           v_v_ColNameList := v_v_ColNameList || 'EQ_EXPIRATION_DATE|TEST_DATE_1|TEST_DATE_2|TEST_DATE_3|TEST_DATE_4|TEST_DATE_5|CONCOM_FROM_DATE_1|';
                           v_v_ColNameList := v_v_ColNameList || 'CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_TO_DATE_6|DATE_RPTD_FDA|';
                           v_v_ColNameList := v_v_ColNameList || 'RPTD_BY_BIRTH_DT|MANUF_BIRTH_DT|';    --JIRA 27137 knakra
                           WHILE INSTR(v_v_ColNameList, '|', 1) > 0
                           LOOP

                               v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
                               v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));

                                 v_v_Val := (CASE
                                                  WHEN v_v_ColName = 'DEVICE_RETURN_DATE' THEN v_v_DEVICE_RETURN_DATE
                                                  WHEN v_v_ColName = 'EXPIRATION_DATE' THEN v_v_EXPIRATION_DATE
                                                  WHEN v_v_ColName = 'IMPLANT_DATE' THEN v_v_IMPLANT_DATE
                                                  WHEN v_v_ColName = 'EXPLANT_DATE' THEN v_v_EXPLANT_DATE
                                                  WHEN v_v_ColName = 'LAST_REPORT_DATE' THEN v_v_LAST_REPORT_DATE
                                                  WHEN v_v_ColName = 'THERAPY_FROM_DATE' THEN v_v_THERAPY_FROM_DATE
                                                  WHEN v_v_ColName = 'DATE_RPTD_MFG' THEN v_v_DATE_RPTD_MFG
                                                  WHEN v_v_ColName = 'THERAPY_TO_DATE' THEN v_v_THERAPY_TO_DATE
                                                  WHEN v_v_ColName = 'EQ_EXPIRATION_DATE' THEN v_v_EQ_EXPIRATION_DATE
                                                  WHEN v_v_ColName = 'TEST_DATE_1' THEN v_v_TEST_DATE_1
                                                  WHEN v_v_ColName = 'TEST_DATE_2' THEN v_v_TEST_DATE_2
                                                  WHEN v_v_ColName = 'TEST_DATE_3' THEN v_v_TEST_DATE_3
                                                  WHEN v_v_ColName = 'TEST_DATE_4' THEN v_v_TEST_DATE_4
                                                  WHEN v_v_ColName = 'TEST_DATE_5' THEN v_v_TEST_DATE_5
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_1' THEN v_v_CONCOM_FROM_DATE_1
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_2' THEN v_v_CONCOM_FROM_DATE_2
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_3' THEN v_v_CONCOM_FROM_DATE_3
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_4' THEN v_v_CONCOM_FROM_DATE_4
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_5' THEN v_v_CONCOM_FROM_DATE_5
                                                  WHEN v_v_ColName = 'CONCOM_FROM_DATE_6' THEN v_v_CONCOM_FROM_DATE_6
                                                  WHEN v_v_ColName = 'MANUF_BIRTH_DT' THEN v_MANUF_BIRTH_DT                     --JIRA 27137 knakra
                                                  WHEN v_v_ColName = 'RPTD_BY_BIRTH_DT' THEN v_RPTD_BY_BIRTH_DT                 --JIRA 27137 knakra
                                                  WHEN v_v_ColName = 'DATE_RPTD_FDA' THEN v_v_DATE_RPTD_FDA   END);

                                 IF v_v_Val IS NOT NULL THEN
                                    IF dds_is_number(v_v_Val) = 0 OR LENGTH(v_v_Val) <> 8 OR dds_is_date(v_v_Val) = 0 THEN --MKAUR24 AK
                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_V_DA_ROW_ID,
                                                             v_V_MODULENAME,
                                                             'Main',
                                                             'DATEFORMAT',
                                                             v_V_PROCNAME,
                                                             'Invalid Date. Please provide Date in YYYYMMDD format.',
                                                             v_v_ColName,
                                                             v_V_ERROR_TABLE_TO_CHECK,
                                                             'EVENT_NUMBER',
                                                             v_v_EVENT_NUMBER,
                                                             1);

                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                                    ELSE
                                       IF ( v_VALID_START_DATE > v_v_Val ) OR ( v_v_Val > v_VALID_END_DATE ) THEN
                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_V_DA_ROW_ID,
                                                                v_V_MODULENAME,
                                                                'Main',
                                                                'DATEFORMAT2',
                                                                v_V_PROCNAME,
                                                                'Date must fall between the date range selected at UI.',
                                                                v_v_ColName,
                                                                v_V_ERROR_TABLE_TO_CHECK,
                                                                'EVENT_NUMBER',
                                                                v_v_EVENT_NUMBER,
                                                                1);

                                          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

                                       END IF;
                                    END IF;
                                 END IF;

                           END LOOP;

                        END;
                        v_V_ERROR_LOCATION := 'MW10';

                        BEGIN-- 4. Tax_id Format validation
                            IF v_v_RPTD_BY_TAX_ID IS NOT NULL THEN             --Check for Tax-Id formats
                 IF dds_is_number(REPLACE(v_v_RPTD_BY_TAX_ID,'-','')) = 1 THEN
                   IF LENGTH(REPLACE(v_v_RPTD_BY_TAX_ID,'-','')) = 9 THEN
                     IF LENGTH(v_v_RPTD_BY_TAX_ID) - LENGTH(REPLACE(v_v_RPTD_BY_TAX_ID,'-','')) = 1 THEN
                       IF INSTR(v_v_RPTD_BY_TAX_ID,'-',1) <> 3 THEN
                         v_iTaxErr := 1;
                         v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
                       END IF;
                     ELSIF LENGTH(v_v_RPTD_BY_TAX_ID) - LENGTH(REPLACE(v_v_RPTD_BY_TAX_ID,'-','')) = 2 THEN
                       IF INSTR(v_v_RPTD_BY_TAX_ID,'-',1) = 4 AND (INSTR(v_v_RPTD_BY_TAX_ID,'-',5) IN (7,8)) THEN
                         v_iTaxErr := 0;
                       ELSE
                         v_iTaxErr := 1;
                         v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
                       END IF;
                     ELSIF LENGTH(v_v_RPTD_BY_TAX_ID) - LENGTH(REPLACE(v_v_RPTD_BY_TAX_ID,'-','')) = 0 THEN
                       v_iTaxErr := 0;
                     ELSE
                       v_iTaxErr := 1;
                       v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
                     END IF;
                   ELSE
                     v_iTaxErr := 1;
                     v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
                   END IF;
                 ELSE
                   v_vErrMsgDesc := 'Tax-Id provided  is not in Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
                   v_iTaxErr := 1;
                 END IF;
               END IF;
                  IF v_iTaxErr = 1 THEN
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                  v_V_DA_ROW_ID,
                v_V_MODULENAME,
                  'Main',
                  'TAXIDVD',
                v_V_PROCNAME,
                  v_vErrMsgDesc,
                 'RPTD_BY_TAX_ID',
                v_V_ERROR_TABLE_TO_CHECK,
                  'EVENT_NUMBER',
                  v_v_EVENT_NUMBER,
                  1);
               END IF;


                     /*   -----MKAUR2444444444444444444
                           IF v_v_RPTD_BY_TAX_ID IS NOT NULL THEN
                              IF LENGTH(REPLACE(v_v_RPTD_BY_TAX_ID, '-', '')) <> 9 THEN
                                 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                       v_V_DA_ROW_ID,
                                                       v_V_MODULENAME,
                                                       'Main',
                                                       'TAXIDVD',
                                                       v_V_PROCNAME,
                                                       'Please provide a valid TAX_ID no.',
                                                       'RPTD_BY_TAX_ID',
                                                       v_V_ERROR_TABLE_TO_CHECK,
                                                       'EVENT_NUMBER',
                                                       v_v_EVENT_NUMBER,
                                                       1);

                                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

                                 v_RPTD_BY_TAX_ID_Invalid_Flag := 1;
                              END IF;
                           END IF;

                        ----MKAUR244444444*/
                        END;
                        v_V_ERROR_LOCATION := 'MW11';

                        BEGIN-- 5. Flags    Validation

                           v_v_ColNameList := 'RPTD_BY_PRO_FLAG|ADVERSE_EVENT_FLAG|PRODUCT_PROB_FLAG|LIFE_THREAT_FLAG|';
                           v_v_ColNameList := v_v_ColNameList || 'HOSPITALIZ_FLAG|DISABILITY_FLAG|CONGENITAL_FLAG|REQD_INTERV_FLAG|';
                           v_v_ColNameList := v_v_ColNameList || 'DEV_AVAIL_FOR_EVAL|EVENT_REAPPEARED|EVENT_ABATED|RPT_MANDATORY|';

                           WHILE INSTR(v_v_ColNameList, '|', 1) > 0
                           LOOP
                              BEGIN
                               v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
                               v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));


                                 v_v_Val := (CASE
                                                  WHEN v_v_ColName = 'RPTD_BY_PRO_FLAG' THEN v_v_RPTD_BY_PRO_FLAG
                                                  WHEN v_v_ColName = 'ADVERSE_EVENT_FLAG' THEN v_v_ADVERSE_EVENT_FLAG
                                                  WHEN v_v_ColName = 'PRODUCT_PROB_FLAG' THEN v_v_PRODUCT_PROB_FLAG
                                                  WHEN v_v_ColName = 'LIFE_THREAT_FLAG' THEN v_v_LIFE_THREAT_FLAG
                                                  WHEN v_v_ColName = 'HOSPITALIZ_FLAG' THEN v_v_HOSPITALIZ_FLAG
                                                  WHEN v_v_ColName = 'DISABILITY_FLAG' THEN v_v_DISABILITY_FLAG
                                                  WHEN v_v_ColName = 'CONGENITAL_FLAG' THEN v_v_CONGENITAL_FLAG
                                                  WHEN v_v_ColName = 'REQD_INTERV_FLAG' THEN v_v_REQD_INTERV_FLAG
                                                  WHEN v_v_ColName = 'DEV_AVAIL_FOR_EVAL' THEN v_v_DEV_AVAIL_FOR_EVAL
                                                  WHEN v_v_ColName = 'EVENT_REAPPEARED' THEN v_v_EVENT_REAPPEARED
                                                  WHEN v_v_ColName = 'EVENT_ABATED' THEN v_v_EVENT_ABATED
                                                  WHEN v_v_ColName = 'RPT_MANDATORY' THEN v_v_RPT_MANDATORY   END);

                                 IF v_v_Val IS NOT NULL THEN
                                    IF UPPER(v_v_Val) <> 'Y' AND UPPER(v_v_val) <> 'N' THEN --MKAUR24 AK
                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_V_DA_ROW_ID,
                                                             v_V_MODULENAME,
                                                             'Main',
                                                             'FlagVD',
                                                             v_V_PROCNAME,
                                                             'If providing value for flag column,acceptable value is either Y/N.',
                                                             v_v_ColName,
                                                             v_V_ERROR_TABLE_TO_CHECK,
                                                             'EVENT_NUMBER',--MKAUR24 1/12
                                                             v_v_EVENT_NUMBER,
                                                             1);

                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

                                    ELSIF v_v_ColName = 'RPTD_BY_PRO_FLAG' AND UPPER(v_v_Val) = 'Y' THEN
                                          v_RPTD_BY_PRO_FLAG_R := -1;
                                     ELSIF v_v_ColName = 'RPTD_BY_PRO_FLAG' AND UPPER(v_v_Val) = 'N' THEN
                  v_RPTD_BY_PRO_FLAG_R := 0;
                  ELSIF v_v_ColName = 'ADVERSE_EVENT_FLAG' AND UPPER(v_v_Val) = 'Y' THEN
                  v_ADVERSE_EVENT_FLAG_R := -1;
                  ELSIF v_v_ColName = 'ADVERSE_EVENT_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_ADVERSE_EVENT_FLAG_R := 0;
                  ELSIF v_v_ColName = 'PRODUCT_PROB_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_PRODUCT_PROB_FLAG_R := -1;
                  ELSIF v_v_ColName = 'PRODUCT_PROB_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_PRODUCT_PROB_FLAG_R := 0;
                  ELSIF v_v_ColName = 'LIFE_THREAT_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_LIFE_THREAT_FLAG_R := -1;
                  ELSIF v_v_ColName = 'LIFE_THREAT_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_LIFE_THREAT_FLAG_R := 0;
                  ELSIF v_v_ColName = 'HOSPITALIZ_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_HOSPITALIZ_FLAG_R := -1;
                  ELSIF v_v_ColName = 'HOSPITALIZ_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_HOSPITALIZ_FLAG_R := 0;
                  ELSIF v_v_ColName = 'DISABILITY_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_DISABILITY_FLAG_R := -1;
                  ELSIF v_v_ColName = 'DISABILITY_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_DISABILITY_FLAG_R := 0;
                  ELSIF v_v_ColName = 'CONGENITAL_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_CONGENITAL_FLAG_R := -1;
                  ELSIF v_v_ColName = 'CONGENITAL_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_CONGENITAL_FLAG_R := 0;
                  ELSIF v_v_ColName = 'REQD_INTERV_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_REQD_INTERV_FLAG_R := -1;
                  ELSIF v_v_ColName = 'REQD_INTERV_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_REQD_INTERV_FLAG_R := 0;
                  ELSIF v_v_ColName = 'DEV_AVAIL_FOR_EVAL'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_DEV_AVAIL_FOR_EVAL_R := -1;
                  ELSIF v_v_ColName = 'DEV_AVAIL_FOR_EVAL'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_DEV_AVAIL_FOR_EVAL_R := 0;
                  ELSIF v_v_ColName = 'EVENT_REAPPEARED'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_EVENT_REAPPEARED_R := -1;
                  ELSIF v_v_ColName = 'EVENT_REAPPEARED'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_EVENT_REAPPEARED_R := 0;
                  ELSIF v_v_ColName = 'EVENT_ABATED'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_EVENT_ABATED_R := -1;

                  ELSIF v_v_ColName = 'EVENT_ABATED'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_REVENT_ABATED_R := 0;

                  ELSIF v_v_ColName = 'REQD_INTERV_FLAG'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_REQD_INTERV_FLAG_R := -1;

                  ELSIF v_v_ColName = 'REQD_INTERV_FLAG'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_REQD_INTERV_FLAG_R := 0;

                  ELSIF v_v_ColName = 'RPT_MANDATORY'
                  AND UPPER(v_v_Val) = 'Y' THEN
                  v_RPT_MANDATORY_R := -1;
                  ELSIF v_v_ColName = 'RPT_MANDATORY'
                  AND UPPER(v_v_Val) = 'N' THEN
                  v_RPT_MANDATORY_R := 0;
                                              END IF;----

                                 END IF;

                              END;
                           END LOOP;

                        END;
                        v_V_ERROR_LOCATION := 'MW12';

                        BEGIN-- 6. Zip Code Validation

                           IF v_v_RPTD_BY_ZIP_CODE IS NOT NULL AND 
						  -- ( dds_is_number(REPLACE(v_v_RPTD_BY_ZIP_CODE, '-', '')) = 0 
						   LENGTH(REPLACE(REPLACE(v_v_RPTD_BY_ZIP_CODE, '-', ''), ' ', '')) NOT IN (9, 5,6)  THEN
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_V_DA_ROW_ID,
                                                    v_V_MODULENAME,
                                                    'Main',
                                                    'zip1',
                                                    v_V_PROCNAME,
                                                    'Please provide a valid ZIP_CODE no.',
                                                    'RPTD_BY_ZIP_CODE',
                                                    v_V_ERROR_TABLE_TO_CHECK,
                                                    'EVENT_NUMBER',
                                                    v_v_EVENT_NUMBER,
                                                    1);

                              v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                           END IF;

                           v_V_ERROR_LOCATION := 'MW13';

                           IF v_v_MANUF_ZIP_CODE IS NOT NULL AND 
						   --( dds_is_number(REPLACE(v_v_MANUF_ZIP_CODE, '-', '')) = 0 OR
						 LENGTH(REPLACE(REPLACE(v_v_RPTD_BY_ZIP_CODE, '-', ''), ' ', '')) NOT IN (9, 5,6)  THEN
                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_V_DA_ROW_ID,
                                                    v_V_MODULENAME,
                                                    'Main',
                                                    'zip2',
                                                    v_V_PROCNAME,
                                                    'Please provide a valid ZIP_CODE no.',
                                                    'MANUF_ZIP_CODE',
                                                    v_V_ERROR_TABLE_TO_CHECK,
                                                    'EVENT_NUMBER',
                                                    v_v_EVENT_NUMBER,
                                                    1);

                              v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                           END IF;

                           v_V_ERROR_LOCATION := 'MW14';

                        END;
                        BEGIN-- 7. State  Validation

                           IF v_v_MANUF_STATE IS NOT NULL THEN
                              v_v_MANUF_STATE := UPPER(v_v_MANUF_STATE);

                              v_N_sql := 'Select STATE_ROW_ID from ' || v_v_Dbname || 'States  where upper(STATE_ID) = :1';

                              BEGIN
 EXECUTE IMMEDIATE V_N_SQL INTO v_MANUF_STATE_R USING v_v_MANUF_STATE;  --mkaur24 qa
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 v_MANUF_STATE_R := 0;
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'STATESVD',
 v_V_PROCNAME,
 'Invalid STATE. Please provide a valid state.',
 'MANUF_STATE',
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

  WHEN OTHERS THEN
 v_V_ERROR_MESSAGE := SQLERRM;
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'STATESVD',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 'EXCEPTION',
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 0);
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END;
 END IF;

 v_V_ERROR_LOCATION := 'MW15';

 IF v_v_RPTD_BY_STATE IS NOT NULL THEN
 v_v_RPTD_BY_STATE := UPPER(v_v_RPTD_BY_STATE);

 v_N_sql := 'Select STATE_ROW_ID from ' || v_v_Dbname || 'States where upper(STATE_ID) = :1';

 BEGIN
 EXECUTE IMMEDIATE V_N_SQL INTO v_RPTD_BY_STATE_R USING v_v_RPTD_BY_STATE;
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 v_RPTD_BY_STATE_R := 0 ;
DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'STATESVD',
 v_V_PROCNAME,
 'Invalid STATE. Please provide a valid state.',
 'MANUF_STATE',
 'RPTD_BY_STATE',
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 WHEN OTHERS THEN
 v_V_ERROR_MESSAGE := SQLERRM;
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'STATESVD',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 NULL,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 0);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END;
 END IF;





 END;

 v_V_ERROR_LOCATION := 'MW16';

 BEGIN-- 8. Reporter Entity

 IF v_v_RPTD_BY_LAST_NAME IS NOT NULL AND v_RPTD_BY_TAX_ID_Invalid_FlaG = 0 THEN
 v_iNoError := 1;

 v_ErrorColumn := '';

 IF v_NonEmployeeMatchByTaxId = 1 AND v_v_RPTD_BY_TAX_ID IS NULL THEN
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'MAIN',
 'REPORTVD1',
 v_V_PROCNAME,
 'Match by tax_id is checked however ,REPORTED_TAX_ID is not provided. ',
 'RPTD_BY_TAX_ID',
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

 v_iNoError := 0;--knakra latest
 END IF;

 IF v_iNoError = 1 THEN
 IF v_NonEmployeeMatchByName <> 0 THEN
 v_ErrorColumn := 'RPTD_BY_LAST_NAME';

 END IF;

 IF v_NonEmployeeMatchByTaxId <> 0 and v_v_RPTD_BY_TAX_ID is null THEN
 IF v_ErrorColumn is not null THEN
 v_ErrorColumn := v_ErrorColumn || ';';

 END IF;

 v_ErrorColumn := v_ErrorColumn || 'RPTD_BY_TAX_ID';
 END IF;

 --JIRA 27137 knakra starts
 IF v_NonEmpMatchByDob <> 0 and v_RPTD_BY_BIRTH_DT is null THEN
 IF v_ErrorColumn is not null THEN
 v_ErrorColumn := v_ErrorColumn || ';';

 END IF;

 v_ErrorColumn := v_ErrorColumn || 'RPTD_BY_BIRTH_DT';
 END IF;
 --JIRA 27137 knakra ends


 VENTITY_TYPE := DDS_ENTITY_TYPE(v_v_RPTD_BY_LAST_NAME, v_V_RPTD_BY_FIRST_NAME, NULL, NULL,
 v_v_RPTD_BY_TAX_ID, v_v_RPTD_BY_ADDR1, v_v_RPTD_BY_ADDR2, v_v_RPTD_BY_CITY,Null,
 --v_RPTD_BY_STATE_R, NULL,v_v_RPTD_BY_ZIP_CODE,NULL,NULL,NULL, NULL, NULL, NULL, NULL, 'OTHER_PEOPLE', NULL, NULL   JIRA 27137 knakra
 v_RPTD_BY_STATE_R, NULL,v_v_RPTD_BY_ZIP_CODE,NULL,NULL,NULL, v_RPTD_BY_BIRTH_DT, NULL, NULL, NULL, 'OTHER_PEOPLE', NULL, NULL  --JIRA 27137 knakra
 , NULL, NULL,v_NAME_TYPE_R,NULL, v_V_jobID,v_v_DA_ROW_ID);


 BEGIN
 PROCESS_ENTITY(VENTITY_TYPE,
 v_p_jobID,
 v_v_DA_ROW_ID,
 v_V_DBNAME,
 v_V_MODULENAME,
 0,
 1,
 'REPORTVD1a',
 v_v_EVENT_NUMBER,
 1,      --JIRA 27137 knakra
 v_iEntId,
 v_V_ERROR_MESSAGE);

 EXCEPTION
 WHEN OTHERS THEN
 v_V_ERROR_MESSAGE := SQLERRM;
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'REPORTVD2',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 NULL,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 0);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END;


 v_i_Reporter_ENTITY_ID_GEN := v_iEntId;

 IF ( v_i_Reporter_ENTITY_ID_GEN = 0 ) THEN
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Reporter',
 'REPORTVD3',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 v_ErrorColumn,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END IF;
 END IF;
 END IF;
 END;
 v_V_ERROR_LOCATION := 'MW17';

 BEGIN-- 9. Manufacturer Entity

 IF v_v_MANUF_NAME IS NOT NULL THEN
 BEGIN
 v_iNoError := 1;

 v_ErrorColumn := '';

 IF v_iNoError = 1 THEN
 IF v_NonEmployeeMatchByName <> 0 THEN
 v_ErrorColumn := 'MANUF_NAME';

 END IF;
 
 --JIRA 27137 knakra starts
  IF v_NonEmpMatchByDob <> 0 and v_MANUF_BIRTH_DT is null THEN
 IF v_ErrorColumn is not null THEN
 v_ErrorColumn := v_ErrorColumn || ';';
 END IF;

 v_ErrorColumn := v_ErrorColumn || 'MANUF_BIRTH_DT';
 END IF;
 --JIRA 27137 knakra ends



 VENTITY_TYPE := DDS_ENTITY_TYPE(v_v_MANUF_NAME, Null, NULL, NULL,
 Null, v_v_MANUF_ADDR1, v_v_MANUF_ADDR2, v_v_MANUF_CITY,Null,
 --v_MANUF_STATE_R, NULL,v_v_MANUF_ZIP_CODE,NULL,NULL,NULL, NULL, NULL, NULL, NULL, 'MANUFACTURERS', NULL, NULL     JIRA 27137 knakra
 v_MANUF_STATE_R, NULL,v_v_MANUF_ZIP_CODE,NULL,NULL,NULL, v_MANUF_BIRTH_DT, NULL, NULL, NULL, 'MANUFACTURERS', NULL, NULL       --JIRA 27137 knakra
 , NULL, NULL,v_NAME_TYPE_R,NULL, v_V_jobID,v_v_DA_ROW_ID);
 BEGIN
 PROCESS_ENTITY( VENTITY_TYPE,
 v_p_jobID,
 v_v_DA_ROW_ID,
 v_V_DBNAME,
 v_V_MODULENAME,
 0,
 0,
 'manufct1',
 v_v_EVENT_NUMBER,
 1,              --JIRA 27137 knakra
 v_iEntId,
 v_V_ERROR_MESSAGE);

 EXCEPTION
 WHEN OTHERS THEN
 v_V_ERROR_MESSAGE := SQLERRM;
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'manufct2',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 NULL,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 0);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

 END;

 v_i_MANUF_ENTITY_ID_GEN := v_iEntId;

 IF ( v_i_MANUF_ENTITY_ID_GEN = 0 ) THEN
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'manufct1',
 'manufct3',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 v_ErrorColumn,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END IF;
 END IF;

 END;
 END IF;

 END;
 v_V_ERROR_LOCATION := 'MW18';

 BEGIN-- 10. Validaton for EVENT_X_MEDW_TEST's Columns

 v_v_ColNameList := 'TEST_LAB_TEST_1|TEST_LAB_TEST_2|TEST_LAB_TEST_3|TEST_LAB_TEST_4|TEST_LAB_TEST_5|';
 v_v_ColName1List := 'TEST_RESULT_1|TEST_RESULT_2|TEST_RESULT_3|TEST_RESULT_4|TEST_RESULT_5|';
 v_v_ColName2List := 'TEST_DATE_1|TEST_DATE_2|TEST_DATE_3|TEST_DATE_4|TEST_DATE_5|';

 WHILE INSTR(v_v_ColNameList, '|', 1) > 0
 LOOP
 v_V_ERROR_LOCATION := 'MW181';
 v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
 v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));


 v_v_ColName1 := SUBSTR(v_v_ColName1List, 0, INSTR(v_v_ColName1List, '|', 1) - 1);
 v_v_ColName1List := SUBSTR(v_v_ColName1List,LENGTH(SUBSTR(v_v_ColName1List,1,INSTR(v_v_ColName1List, '|', 1)))+1,LENGTH(v_v_ColName1List));

 v_v_ColName2 := SUBSTR(v_v_ColName2List, 0, INSTR(v_v_ColName2List, '|', 1) - 1);
 v_v_ColName2List := SUBSTR(v_v_ColName2List,LENGTH(SUBSTR(v_v_ColName2List,1,INSTR(v_v_ColName2List, '|', 1)))+1,LENGTH(v_v_ColName2List));

 v_V_ERROR_LOCATION := 'MW182';
 v_v_Val := (CASE
 WHEN v_v_ColName = 'TEST_LAB_TEST_1' THEN v_v_TEST_LAB_TEST_1
 WHEN v_v_ColName = 'TEST_LAB_TEST_2' THEN v_v_TEST_LAB_TEST_2
 WHEN v_v_ColName = 'TEST_LAB_TEST_3' THEN v_v_TEST_LAB_TEST_3
 WHEN v_v_ColName = 'TEST_LAB_TEST_4' THEN v_v_TEST_LAB_TEST_4
 WHEN v_v_ColName = 'TEST_LAB_TEST_5' THEN v_v_TEST_LAB_TEST_5 END);
 v_V_ERROR_LOCATION := 'MW183';
 v_v_Val1 := (CASE
 WHEN v_v_ColName1 = 'TEST_RESULT_1' THEN v_v_TEST_RESULT_1
 WHEN v_v_ColName1 = 'TEST_RESULT_2' THEN v_v_TEST_RESULT_2
 WHEN v_v_ColName1 = 'TEST_RESULT_3' THEN v_v_TEST_RESULT_3
 WHEN v_v_ColName1 = 'TEST_RESULT_4' THEN v_v_TEST_RESULT_4
 WHEN v_v_ColName1 = 'TEST_RESULT_5' THEN v_v_TEST_RESULT_5 END);
 v_V_ERROR_LOCATION := 'MW184';
 v_v_Val2 := (CASE
 WHEN v_v_ColName2 = 'TEST_DATE_1' THEN v_v_TEST_DATE_1
 WHEN v_v_ColName2 = 'TEST_DATE_2' THEN v_v_TEST_DATE_2
 WHEN v_v_ColName2 = 'TEST_DATE_3' THEN v_v_TEST_DATE_3
 WHEN v_v_ColName2 = 'TEST_DATE_4' THEN v_v_TEST_DATE_4
 WHEN v_v_ColName2 = 'TEST_DATE_5' THEN v_v_TEST_DATE_5 END);

 IF v_v_Val IS NOT NULL AND v_v_Val1 IS NOT NULL AND v_v_Val2 IS NOT NULL THEN
 v_Do_Nothing := 1;
 Elsif v_v_Val is null and v_v_Val is null and v_v_Val is null Then
 v_Do_Nothing := 2 ;


 ELSE
 v_v_ErrorColName := v_v_ColName || ';' || v_v_ColName1 || ';' || v_v_ColName2 ; --mkaur24 ak
 v_V_ERROR_LOCATION := 'MW185';
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'zip2',
 v_V_PROCNAME,
 'The number of values in each column must be equal.',
 v_v_ErrorColName,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END IF;
 END LOOP;

 END;
 v_V_ERROR_LOCATION := 'MW19';

 BEGIN-- 11. Validaton for EVENT_X_MEDW_TEST's Columns

 v_v_ColNameList := 'CONCOM_PRODUCT_ID_1|CONCOM_PRODUCT_ID_2|CONCOM_PRODUCT_ID_3|CONCOM_PRODUCT_ID_4|CONCOM_PRODUCT_ID_5|CONCOM_PRODUCT_ID_6|';
 v_v_ColName1List := 'CONCOM_FROM_DATE_1|CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_FROM_DATE_6|';
 v_v_ColName2List := 'CONCOM_TO_DATE_1|CONCOM_TO_DATE_2|CONCOM_TO_DATE_3|CONCOM_TO_DATE_4|CONCOM_TO_DATE_5|CONCOM_TO_DATE_6|';
 v_v_ColName3List := 'CONCOM_PRODUCT_1|CONCOM_PRODUCT_2|CONCOM_PRODUCT_3|CONCOM_PRODUCT_4|CONCOM_PRODUCT_5|CONCOM_PRODUCT_6|';

 WHILE INSTR(v_v_ColNameList, '|', 1) > 0
 LOOP
 v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
 v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));


 v_v_ColName1 := SUBSTR(v_v_ColName1List, 0, INSTR(v_v_ColName1List, '|', 1) - 1);
 v_v_ColName1List := SUBSTR(v_v_ColName1List,LENGTH(SUBSTR(v_v_ColName1List,1,INSTR(v_v_ColName1List, '|', 1)))+1,LENGTH(v_v_ColName1List));

 v_v_ColName2 := SUBSTR(v_v_ColName2List, 0, INSTR(v_v_ColName2List, '|', 1) - 1);
 v_v_ColName2List := SUBSTR(v_v_ColName2List,LENGTH(SUBSTR(v_v_ColName2List,1,INSTR(v_v_ColName2List, '|', 1)))+1,LENGTH(v_v_ColName2List));

 v_v_ColName3 := SUBSTR(v_v_ColName3List, 0, INSTR(v_v_ColName3List, '|', 1) - 1);
 v_v_ColName3List := SUBSTR(v_v_ColName3List,LENGTH(SUBSTR(v_v_ColName3List,1,INSTR(v_v_ColName3List, '|', 1)))+1,LENGTH(v_v_ColName3List));

 v_v_ErrorColName := v_v_ColName || ';' || v_v_ColName1 || ';' || v_v_ColName2 || ';' || v_v_ColName3 ; --mkaur24 ak

 v_v_Val := (CASE
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_1' THEN v_v_CONCOM_PRODUCT_ID_1
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_2' THEN v_v_CONCOM_PRODUCT_ID_2
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_3' THEN v_v_CONCOM_PRODUCT_ID_3
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_4' THEN v_v_CONCOM_PRODUCT_ID_4
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_5' THEN v_v_CONCOM_PRODUCT_ID_5
 WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_6' THEN v_v_CONCOM_PRODUCT_ID_6 END);

 v_v_Val1 := (CASE
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_1' THEN v_v_CONCOM_FROM_DATE_1
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_2' THEN v_v_CONCOM_FROM_DATE_2
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_3' THEN v_v_CONCOM_FROM_DATE_3
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_4' THEN v_v_CONCOM_FROM_DATE_4
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_5' THEN v_v_CONCOM_FROM_DATE_5
 WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_6' THEN v_v_CONCOM_FROM_DATE_6 END);

 v_v_Val2 := (CASE
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_1' THEN v_v_CONCOM_TO_DATE_1
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_2' THEN v_v_CONCOM_TO_DATE_2
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_3' THEN v_v_CONCOM_TO_DATE_3
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_4' THEN v_v_CONCOM_TO_DATE_4
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_5' THEN v_v_CONCOM_TO_DATE_5
 WHEN v_v_ColName2 = 'CONCOM_TO_DATE_6' THEN v_v_CONCOM_TO_DATE_6 END);

 v_v_Val3 := (CASE
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_1' THEN v_v_CONCOM_PRODUCT_1
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_2' THEN v_v_CONCOM_PRODUCT_2
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_3' THEN v_v_CONCOM_PRODUCT_3
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_4' THEN v_v_CONCOM_PRODUCT_4
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_5' THEN v_v_CONCOM_PRODUCT_5
 WHEN v_v_ColName3 = 'CONCOM_PRODUCT_6' THEN v_v_CONCOM_PRODUCT_6 END);

 IF v_v_Val IS NOT NULL AND v_v_Val1 IS NOT NULL AND v_v_Val2 IS NOT NULL AND v_v_Val3 IS NOT NULL THEN
 v_Do_Nothing := 1;

 Elsif v_v_Val is null and v_v_Val is null and v_v_Val is null Then
 v_Do_Nothing := 2;
 ELSE
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'zip2',
 v_V_PROCNAME,
 'The number of values in each column must be equal.',
 v_v_ErrorColName,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 END IF;
 END LOOP;

 END;
 v_V_ERROR_LOCATION := 'MW20';

If v_v_Event_Number is not null Then

 BEGIN-- 12. Event number must exist

 v_N_Sql := 'Select Event_Id from ' || v_v_Dbname || 'Event where Event_Number = :1';

 v_V_ERROR_LOCATION := 'MW5';

 BEGIN

 EXECUTE IMMEDIATE V_N_SQL INTO v_Event_ID USING v_v_Event_Number;
 v_V_ERROR_LOCATION := 'MW6';
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 v_Event_ID:=0;
 WHEN OTHERS THEN
 v_V_ERROR_MESSAGE := SQLERRM;

 DDS_ERROR_LOG_CAPTURE(v_p_JobID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'EvntExist1',
 v_V_PROCNAME,
 v_V_ERROR_MESSAGE,
 null,
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 0);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END;

 IF ( v_Event_ID = 0 ) THEN
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 'Main',
 'EvntExist',
 v_V_PROCNAME,
 'The Event does not exists corresponding to this Event_Number.Please provide a valid Event_number.',
 'EVENT_NUMBER',
 v_V_ERROR_TABLE_TO_CHECK,
 'EVENT_NUMBER',
 v_v_EVENT_NUMBER,
 1);

 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
 END IF;
 --mkaur24 start
 Begin

 v_Event_ID_Icon := 0 ;
 v_N_Sql := 'Select Event_Id from ' || v_v_Dbname || 'Event where Event_Number = :1';
 v_N_SQL := v_N_SQL || ' and Event_ind_code in ( Select code_id from ' || v_v_Dbname || 'codes where Deleted_flag = 0 ';
 v_N_SQL := v_N_SQL || ' and table_id in (select table_id from ' || v_v_Dbname || 'glossary where system_table_name = :2) ' ;
 v_N_SQL := v_N_SQL || ' and Related_code_id in (select code_id from ' || v_v_Dbname || 'codes_text where code_id in ';
 v_N_SQL := v_N_SQL || ' (select code_id from ' || v_v_Dbname || 'codes where table_id in (select related_table_id from '|| v_v_Dbname || 'glossary where ';
 v_N_SQL := v_N_SQL || ' system_table_name = :3 )) and upper(code_desc) = :4 ) )' ;--mkaur24 ak full query modified  --added upper for code_desc nkhetan 38951


 BEGIN

 EXECUTE IMMEDIATE v_n_sql into v_Event_ID_Icon using v_v_Event_Number,'EVENT_INDICATOR','EVENT_INDICATOR','MEDICATION';
                              v_V_ERROR_LOCATION := 'MW6';
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                            v_Event_ID_Icon:=0;
                           WHEN OTHERS THEN
                                 v_V_ERROR_MESSAGE := SQLERRM;
                                 DDS_ERROR_LOG_CAPTURE(v_p_JobID,
                                                       v_V_DA_ROW_ID,
                                                       v_V_MODULENAME,
                                                       'Main',
                                                       'EvntExist2',
                                                       v_V_PROCNAME,
                                                       v_V_ERROR_MESSAGE,
                                                       'Exception',
                                                       v_V_ERROR_TABLE_TO_CHECK,
                                                       'EVENT_NUMBER',
                                                       v_v_EVENT_NUMBER,
                                                       0);

                                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END;
                        IF ( v_Event_ID_Icon = 0 ) THEN
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_V_DA_ROW_ID,
                                                 v_V_MODULENAME,
                                                 'Main',
                                                 'EvntExist3',
                                                 v_V_PROCNAME,
                                                 'Event Indicator for the given Event Number is not associated with Medication Event Category.',
                                                 'EVENT_NUMBER',
                                                 v_V_ERROR_TABLE_TO_CHECK,
                                                 'EVENT_NUMBER',
                                                 v_v_EVENT_NUMBER,
                                                 1);

                           v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END IF;


                     END;


                     End ;

End If ;


  v_V_ERROR_LOCATION := 'MW7';



                        BEGIN-- 13. Update Reporter  Entity

                          /* IF ( v_i_Reporter_ENTITY_ID_GEN > 0 ) THEN
                           BEGIN
                              v_Entity_Id := 0;

                              v_N_sql := 'SelecT Entity_id from ' || v_v_Dbname || 'Entity where Entity_Id = :1';

                              BEGIN

                                EXECUTE IMMEDIATE v_N_sql INTO v_Entity_Id USING v_i_Reporter_ENTITY_ID_GEN;

                              EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     V_ENTITY_ID := 0;
                                 WHEN OTHERS THEN
                                       v_V_ERROR_MESSAGE := SQLERRM;
                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_V_DA_ROW_ID,
                                                             v_V_MODULENAME,
                                                             'Main',
                                                             'RepoUpd1',
                                                             v_V_PROCNAME,
                                                             v_V_ERROR_MESSAGE,
                                                             NULL,
                                                             v_V_ERROR_TABLE_TO_CHECK,
                                                             'EVENT_NUMBER',
                                                             v_v_EVENT_NUMBER,
                                                             0);
                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                              END;
*/

                              IF ( v_i_Reporter_ENTITY_ID_GEN > 0 ) THEN
                                 v_N_sql := 'Update '||v_v_Dbname||'Entity Set Entity_Id = '||v_i_Reporter_ENTITY_ID_GEN;

                                 IF v_v_RPTD_BY_LAST_NAME IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', LAST_NAME = '||''''||v_v_RPTD_BY_LAST_NAME||'''';
                                 END IF;

                                 IF v_v_RPTD_BY_FIRST_NAME IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', FIRST_NAME = '||''''||v_v_RPTD_BY_FIRST_NAME||'''';
                                 END IF;

                                 IF v_v_RPTD_BY_TAX_ID IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', TAX_ID = '||''''||v_v_RPTD_BY_TAX_ID||'''';
                                 END IF;

                                 IF v_v_RPTD_BY_ADDR1 IS NOT NULL THEN
                                    v_N_SQL := v_N_SQL || ' ,ADDR1 = '||''''||v_v_RPTD_BY_ADDR1||'''';
                                    --v_N_sql := v_N_sql || ', ADDR1 = @v_RPTD_BY_ADDR1_P ';
                                 END IF;

                                 IF v_v_RPTD_BY_ADDR2 IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', ADDR2 = '||''''||v_v_RPTD_BY_ADDR2||'''';

                                 END IF;

                                 IF v_v_RPTD_BY_CITY IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', CITY = '||''''||v_v_RPTD_BY_CITY||'''';

                                 END IF;

                                 IF v_RPTD_BY_STATE_R IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', STATE_ID = '||v_RPTD_BY_STATE_R;

                                 END IF;

                                 IF v_v_RPTD_BY_ZIP_CODE IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', ZIP_CODE = '||''''||v_v_RPTD_BY_ZIP_CODE||'''';

                                 END IF;

                                 IF v_NAME_TYPE_R IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', Name_TYPE = '||v_NAME_TYPE_R;

                                 END IF;
                                      v_N_sql := v_N_sql || ' where Entity_Id = '||v_i_Reporter_ENTITY_ID_GEN ; --- v_v_UPDATED_BY_USER



                                 BEGIN
                                    execute immediate v_n_sql;
                                 EXCEPTION
                                    WHEN OTHERS THEN
                                          v_V_ERROR_MESSAGE := SQLERRM;

                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_V_DA_ROW_ID,
                                                                v_V_MODULENAME,
                                                                'Main',
                                                                'RepoUpd2',
                                                                v_V_PROCNAME,
                                                                v_V_ERROR_MESSAGE,
                                                                NULL,
                                                                v_V_ERROR_TABLE_TO_CHECK,
                                                                'EVENT_NUMBER',
                                                                v_v_EVENT_NUMBER,
                                                                0);

                                          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                                 END;
                              END IF;

                         --  END;
                          -- END IF;

                        END ;
                        v_V_ERROR_LOCATION := 'MW21';

                        BEGIN-- 14. Update  Manufacturer Entity
                      /*
                           IF ( v_i_MANUF_ENTITY_ID_GEN > 0 ) THEN
                           BEGIN
                              v_Entity_Id := 0;

                              v_N_sql := 'Selec Entity_id from ' || v_v_Dbname || 'Entity where Entity_Id = :1 ';

                              BEGIN
                                 EXECUTE IMMEDIATE V_N_SQL INTO v_Entity_Id USING v_i_MANUF_ENTITY_ID_GEN;
                              EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                   v_Entity_Id:=0;
                                 WHEN OTHERS THEN
                                       v_V_ERROR_MESSAGE := SQLERRM;

                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_V_DA_ROW_ID,
                                                             v_V_MODULENAME,
                                                             'Main',
                                                             'ManufUpd1',
                                                             v_V_PROCNAME,
                                                             v_V_ERROR_MESSAGE,
                                                             NULL,
                                                             v_V_ERROR_TABLE_TO_CHECK,
                                                             'EVENT_NUMBER',
                                                             v_v_EVENT_NUMBER,
                                                             0);

                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                              END;
*/
                              IF ( v_Entity_Id > 0 ) THEN
                                 v_N_sql := 'Update' || v_v_Dbname || 'Entity Set Entity_Id = '||v_i_MANUF_ENTITY_ID_GEN;

                                 IF v_v_MANUF_NAME IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', LAST_NAME  = '||''''||v_v_MANUF_NAME||'''';

                                 END IF;

                                 IF v_v_MANUF_ADDR1 IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', ADDR1  = '||''''||v_v_MANUF_ADDR1||'''';

                                 END IF;

                                 IF v_v_MANUF_ADDR2 IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', ADDR2  = '||''''||v_v_MANUF_ADDR2||'''';

                                 END IF;

                                 IF v_v_MANUF_CITY IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', CITY  = '||''''||v_v_MANUF_CITY||'''';

                                 END IF;

                                 IF v_MANUF_STATE_R IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', STATE_ID  = '||v_MANUF_STATE_R;

                                 END IF;

                                 IF v_v_MANUF_ZIP_CODE IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', ZIP_CODE  = '||''''||v_v_MANUF_ZIP_CODE||'''';

                                 END IF;

                                 IF v_NAME_TYPE_R IS NOT NULL THEN
                                    v_N_sql := v_N_sql || ', Name_TYPE  = '||v_NAME_TYPE_R;

                                 END IF;
                                    v_N_sql := v_N_sql || ' where Entity_Id = '||v_i_MANUF_ENTITY_ID_GEN ; --- v_v_UPDATED_BY_USER

                                 BEGIN

                                 execute immediate v_n_sql;

                                 EXCEPTION
                                    WHEN OTHERS THEN
                                          v_V_ERROR_MESSAGE := SQLERRM;

                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_V_DA_ROW_ID,
                                                                v_V_MODULENAME,
                                                                'Main',
                                                                'ManufUpd2',
                                                                v_V_PROCNAME,
                                                                v_V_ERROR_MESSAGE,
                                                                NULL,
                                                                v_V_ERROR_TABLE_TO_CHECK,
                                                                'EVENT_NUMBER',
                                                                v_v_EVENT_NUMBER,
                                                                0);

                                          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                               --  END;
                              --END IF;

                           END;
                           END IF;

                        END;
                        v_V_ERROR_LOCATION := 'MW22';

                     END;
                     --END IF;

                     v_V_ERROR_LOCATION := 'MW21';

                     ---- Supplemnetal Valdation Starts
                     IF ( v_MEDWATCH_SUPP <> 0 ) AND ( v_Event_ID > 0 ) THEN

                        DDS_SUPPLEMENT(v_p_JOBID,-- Insert call for Medwatch
                                             v_CONFIG_ID,
                                             v_p_USERID,
                                             'MEDWATCH',
                                             v_V_DBName,
                                             v_v_DA_ROW_ID,
                                             v_CheckCreateNewCodes,
                                             0,
                                             v_I_ERRORCOUNT,
                                             'V',
                                             0,
                                             v_Event_ID,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             0,
                                             'EVENT_NUMBER',
                                             v_v_EVENT_NUMBER,
                                             v_P_SUPP_ERROR_COUNT_R);
                     END IF;

                     ---- Supplemnetal Valdation Ends
                     v_I_ERRORCOUNT := v_I_ERRORCOUNT + v_P_SUPP_ERROR_COUNT_R;

                     v_V_ERROR_LOCATION := 'MW22';

                     ---- Insert Starts
                     IF ( v_I_ERRORCOUNT = 0 ) AND ( v_Event_ID > 0 ) THEN
                     BEGIN
                        ---Check if Event_Number / event _id  exists in
                        v_V_DTTM_RCD_LAST_UPD_GEN := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');

                        v_v_UPDATED_BY_USER := 'DDS';

                        v_Event_ID_MED := 0;

                        v_N_Sql := 'Select Event_Id from ' || v_v_Dbname || 'EVENT_X_MEDWATCH where Event_Id = :1';

                        v_V_ERROR_LOCATION := 'MW23';

                        BEGIN
                              EXECUTE IMMEDIATE V_N_SQL INTO v_Event_ID_MED USING v_Event_ID;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                             v_Event_ID_MED:=0;
                        END;

                        v_V_ERROR_LOCATION := 'MW24';

                        IF ( v_Event_ID_MED = 0 ) THEN-- Insert into EVENT_X_MEDWATCH
                           v_N_sql := 'Insert into ' || v_v_Dbname || 'EVENT_X_MEDWATCH (EVENT_ID ,UNIT_CODE,DATE_RPTD_TO_FDA,DATE_RPTD_TO_MFG,RPTD_BY_EID,';
                           v_N_sql := v_N_sql || 'RPTD_BY_PRO_FLAG,RPTD_BY_POS_CODE,RELEVANT_HISTORY,LAST_REPORT_DATE,';
                           v_N_sql := v_N_sql || 'REPORT_YEAR,REPORT_SERIAL_NO,ADVERSE_EVENT_FLAG,PRODUCT_PROB_FLAG,LIFE_THREAT_FLAG,HOSPITALIZ_FLAG,';
                           v_N_sql := v_N_sql || 'DISABILITY_FLAG,CONGENITAL_FLAG,REQD_INTERV_FLAG,FOLLOW_UP_COUNT,RPT_MANDATORY,MED_TYPE,MED_NAME,DOSE,';

                           v_N_sql := v_N_sql || 'FREQUENCY,ROUTE,THERAPY_FROM_DATE,THERAPY_TO_DATE,DURATION,LOT_NUMBER,NDC_NUMBER,EXPIRATION_DATE,MW_EVENT_ABATED,';

                           v_N_sql := v_N_sql || 'MW_EVNT_REAPPEARED,DIAGNOSIS_TEST,BRAND_NAME,EQUIP_TYPE_CODE,MANUFACTURER_EID,MODEL_NUMBER,CATALOG_NUMBER,SERIAL_NUMBER,';

                           v_N_sql := v_N_sql || 'OTHER_NUMBER,DEVICE_OPER_CODE,IMPLANT_DATE,EXPLANT_DATE,AGE_OF_DEVICE,DEV_AVAIL_FOR_EVAL,DEVICE_RETURN_DATE,EQ_LOT_NUMBER,';

                           v_N_sql := v_N_sql || 'EQ_EXPIRATION_DATE) ';

                           v_N_sql := v_N_sql || 'values (:1,:2,:3,:4,:5,:6,';
                           v_N_sql := v_N_sql || ':7,:8,:9,:10,:11,:12,';
                           v_N_sql := v_N_sql || ':13 ,:14,:15,:16,:17,:18,';
                           v_N_sql := v_N_sql || ':19,:20,:21,:22,:23,:24,:25,:26,';
                           v_N_sql := v_N_sql || ':27 ,:28 ,:29 ,:30 ,:31,:32,:33,';
                           v_N_sql := v_N_sql || ':34 ,:35 ,:36 ,:37,:38,:39 ,:40,';
                           v_N_sql := v_N_sql || ':41,:42,:43,:44,:45,:46,:47,';
                           v_N_sql := v_N_sql || ':48 ,:49)';

                           v_V_ERROR_LOCATION := 'MW25';
                             dbms_output.put_line('insert for event_X_medwatch') ;
                           dbms_output.put_line(v_N_sql);

                           EXECUTE IMMEDIATE V_N_SQL USING
                           v_Event_ID,v_UNIT_CODE_R,v_v_DATE_RPTD_FDA,v_v_DATE_RPTD_MFG,v_i_Reporter_ENTITY_ID_GEN,
                           v_RPTD_BY_PRO_FLAG_R,v_RPTD_BY_POS_CODE_R,v_v_RELEVANT_HISTORY , V_v_LAST_REPORT_DATE,
                                         v_v_REPORT_YEAR,                                         v_v_REPORT_SERIAL_NO,
                                         v_ADVERSE_EVENT_FLAG_R,                                         v_PRODUCT_PROB_FLAG_R,
                                         v_LIFE_THREAT_FLAG_R,                                         v_HOSPITALIZ_FLAG_R,
                                         v_DISABILITY_FLAG_R,                                         v_CONGENITAL_FLAG_R,
                                         v_REQD_INTERV_FLAG_R,                                         v_v_FOLLOW_UP_COUNT,
                                         v_v_RPT_MANDATORY,                                         v_MED_TYPE_R,
                                         v_v_MED_NAME,                                         v_v_DOSE,
                                         v_v_FREQUENCY,                                         v_v_ROUTE,
                                         v_v_THERAPY_FROM_DATE,                                         v_v_THERAPY_TO_DATE,
                                         v_v_DURATION,                                         v_v_LOT_NUMBER,
                                         v_v_NDC_NUMBER,                                         v_v_EXPIRATION_DATE,
                                         v_EVENT_ABATED_R,                                         v_EVENT_REAPPEARED_R,
                                         v_v_DIAGNOSIS_TEST,
                                         v_v_BRAND_NAME,
                                         v_EQUIP_TYPE_CODE_R,
                                         v_i_MANUF_ENTITY_ID_GEN,
                                         v_v_MODEL_NUMBER,
                                         v_v_CATALOG_NUMBER,
                                         v_v_SERIAL_NUMBER,
                                         v_v_OTHER_NUMBER,
                                         v_DEVICE_OPER_CODE_R,
                                         v_v_IMPLANT_DATE,
                                         v_v_EXPLANT_DATE,
                                         v_v_AGE_OF_DEVICE,
                                         v_DEV_AVAIL_FOR_EVAL_R,
                                         v_v_DEVICE_RETURN_DATE,
                                         v_v_EQ_LOT_NUMBER,
                                         v_v_EQ_EXPIRATION_DATE;
                           v_V_ERROR_LOCATION := 'MW27';
                        ELSE
                           IF ( v_Event_ID_MED > 0 ) THEN--update table

                           BEGIN
                              v_V_ERROR_LOCATION := 'MW26';

                              v_N_sql := 'Update ' || v_v_Dbname || 'EVENT_X_MEDWATCH SET EVENT_ID = '||v_Event_ID_MED;

                              IF v_UNIT_CODE_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', UNIT_CODE = '||v_UNIT_CODE_R;

                              END IF;

                              IF v_v_DATE_RPTD_FDA IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DATE_RPTD_TO_FDA = '||''''||v_v_DATE_RPTD_FDA||'''';

                              END IF;

                                IF v_v_DATE_RPTD_MFG IS NOT NULL THEN
                                 v_N_sql :=  v_N_sql || ', DATE_RPTD_TO_MFG = '||''''||v_v_DATE_RPTD_MFG||'''';

                              END IF;

                              IF v_i_Reporter_ENTITY_ID_GEN IS NOT NULL AND v_i_Reporter_ENTITY_ID_GEN <> 0 THEN
                                 v_N_sql := v_N_sql ||  ', RPTD_BY_EID = '||v_i_Reporter_ENTITY_ID_GEN;

                              END IF;

                              IF v_RPTD_BY_PRO_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', RPTD_BY_PRO_FLAG = '||v_RPTD_BY_PRO_FLAG_R;

                              END IF;

                              IF v_RPTD_BY_POS_CODE_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', RPTD_BY_POS_CODE = '||v_RPTD_BY_POS_CODE_R;
                              END IF;

                              IF v_v_RELEVANT_HISTORY IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', RELEVANT_HISTORY = '||''''||v_v_RELEVANT_HISTORY||'''';

                              END IF;

                              IF v_v_LAST_REPORT_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', LAST_REPORT_DATE = '||''''||v_v_LAST_REPORT_DATE||'''';

                              END IF;

                              IF v_v_REPORT_YEAR IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', REPORT_YEAR = '||v_v_REPORT_YEAR;

                              END IF;

                              IF v_v_REPORT_SERIAL_NO IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', REPORT_SERIAL_NO = '||v_v_REPORT_SERIAL_NO;

                              END IF;

                              IF v_ADVERSE_EVENT_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', ADVERSE_EVENT_FLAG = '||v_ADVERSE_EVENT_FLAG_R;

                              END IF;

                              IF v_PRODUCT_PROB_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', PRODUCT_PROB_FLAG = '||v_PRODUCT_PROB_FLAG_R;

                              END IF;

                              IF v_LIFE_THREAT_FLAG_R IS NOT NULL THEN
                                 v_N_sql :=  v_N_sql || ', LIFE_THREAT_FLAG = '||v_LIFE_THREAT_FLAG_R;

                              END IF;

                              IF v_HOSPITALIZ_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', HOSPITALIZ_FLAG = '||v_HOSPITALIZ_FLAG_R;

                              END IF;

                              IF v_DISABILITY_FLAG_R IS NOT NULL THEN
                                 v_N_sql :=  v_N_sql || ', DISABILITY_FLAG = '||v_DISABILITY_FLAG_R;

                              END IF;

                              IF v_CONGENITAL_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', CONGENITAL_FLAG = '||v_CONGENITAL_FLAG_R;

                              END IF;

                              IF v_REQD_INTERV_FLAG_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', REQD_INTERV_FLAG = '||v_REQD_INTERV_FLAG_R;

                              END IF;

                              IF v_v_FOLLOW_UP_COUNT IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', FOLLOW_UP_COUNT = '||v_v_FOLLOW_UP_COUNT;

                              END IF;

                              IF v_v_RPT_MANDATORY IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', RPT_MANDATORY = '||v_v_RPT_MANDATORY;

                              END IF;

                              IF v_MED_TYPE_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', MED_TYPE = '||v_MED_TYPE_R;

                              END IF;

                              IF v_v_MED_NAME IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', MED_NAME = '||''''||v_v_MED_NAME||'''';

                              END IF;

                              IF v_v_DOSE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DOSE = '||''''||v_V_dose||'''';

                              END IF;

                              IF v_v_FREQUENCY IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', FREQUENCY = '||''''||v_v_FREQUENCY||'''';

                              END IF;

                              IF v_v_ROUTE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', ROUTE = '||''''||v_v_ROUTE||'''';

                              END IF;

                              IF v_v_THERAPY_FROM_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', THERAPY_FROM_DATE = '||''''||v_v_THERAPY_FROM_DATE||'''';

                              END IF;

                              IF v_v_THERAPY_TO_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', THERAPY_TO_DATE = '||''''||v_v_THERAPY_TO_DATE||'''';

                              END IF;

                              IF v_v_DURATION IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DURATION = '||v_v_DURATION;

                              END IF;

                              IF v_v_LOT_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', LOT_NUMBER = '||''''||v_v_LOT_NUMBER||'''';

                              END IF;

                              IF v_v_NDC_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', NDC_NUMBER = '||v_v_NDC_NUMBER;

                              END IF;

                              IF v_v_EXPIRATION_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', EXPIRATION_DATE = '||''''||v_v_EXPIRATION_DATE||'''';
                              END IF;

                              IF v_EVENT_ABATED_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', MW_EVENT_ABATED = '||v_EVENT_ABATED_R;

                              END IF;

                              IF v_EVENT_REAPPEARED_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', MW_EVNT_REAPPEARED = '||v_EVENT_REAPPEARED_R;

                              END IF;

                              IF v_v_DIAGNOSIS_TEST IS NOT NULL THEN
                                 v_N_sql :=  v_N_sql || ', DIAGNOSIS_TEST = '||''''||v_v_DIAGNOSIS_TEST||'''';

                              END IF;

                              IF v_EQUIP_TYPE_CODE_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', EQUIP_TYPE_CODE = '||v_EQUIP_TYPE_CODE_R;

                              END IF;

                              IF v_v_BRAND_NAME IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', BRAND_NAME = '||''''||v_v_BRAND_NAME||'''';

                              END IF;

                              IF v_i_MANUF_ENTITY_ID_GEN IS NOT NULL AND v_i_MANUF_ENTITY_ID_GEN <> 0 THEN
                                 v_N_sql := v_N_sql || ', MANUFACTURER_EID = '||v_i_MANUF_ENTITY_ID_GEN;

                              END IF;

                              IF v_v_MODEL_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', MODEL_NUMBER = '||''''||v_v_MODEL_NUMBER||'''';

                              END IF;

                              IF v_v_CATALOG_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', CATALOG_NUMBER = '||''''||v_v_CATALOG_NUMBER||'''';

                              END IF;

                              IF v_v_SERIAL_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', SERIAL_NUMBER = '||''''||v_v_SERIAL_NUMBER||'''';

                              END IF;

                              IF v_v_OTHER_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', OTHER_NUMBER = '||''''||v_v_OTHER_NUMBER||'''';

                              END IF;

                              IF v_DEVICE_OPER_CODE_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DEVICE_OPER_CODE = '||v_DEVICE_OPER_CODE_R;

                              END IF;

                              IF v_v_IMPLANT_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', IMPLANT_DATE = '||''''||v_v_IMPLANT_DATE||'''';

                              END IF;

                              IF v_v_EXPLANT_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', EXPLANT_DATE = '||''''||v_v_EXPLANT_DATE||'''';

                              END IF;

                              IF v_v_AGE_OF_DEVICE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', AGE_OF_DEVICE = '||''''||v_v_AGE_OF_DEVICE||'''';

                              END IF;

                              IF v_DEV_AVAIL_FOR_EVAL_R IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DEV_AVAIL_FOR_EVAL = '||v_DEV_AVAIL_FOR_EVAL_R;

                              END IF;

                              IF v_v_DEVICE_RETURN_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DEVICE_RETURN_DATE = '||''''||v_v_DEVICE_RETURN_DATE||'''';

                              END IF;

                              IF v_v_EQ_LOT_NUMBER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', EQ_LOT_NUMBER = '||''''||v_v_EQ_LOT_NUMBER||'''';

                              END IF;

                              IF v_v_EQ_EXPIRATION_DATE IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', EQ_EXPIRATION_DATE = '||''''||v_v_EQ_EXPIRATION_DATE||'''';

                              END IF;

                              IF v_V_DTTM_RCD_LAST_UPD_GEN IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', DTTM_RCD_LAST_UPD = '||''''||v_V_DTTM_RCD_LAST_UPD_GEN||'''';

                              END IF;

                              IF v_v_UPDATED_BY_USER IS NOT NULL THEN
                                 v_N_sql := v_N_sql || ', UPDATED_BY_USER = '||''''||v_v_UPDATED_BY_USER||'''';  ----v_NAME_TYPE_R

                              END IF;
                              v_N_sql := v_N_sql || 'where EVENT_ID = '||v_Event_ID_MED; --- v_v_UPDATED_BY_USER

                              v_V_ERROR_LOCATION := 'MW27';

                              execute immediate v_n_sql;

                              v_V_ERROR_LOCATION := 'MW28';

                           END;
                           END IF;

                        END IF;

                        BEGIN--Insert into Event_X_Medw_test Start

                           v_v_ColNameList := '@v_TEST_LAB_TEST_1|@v_TEST_LAB_TEST_2|@v_TEST_LAB_TEST_3|@v_TEST_LAB_TEST_4|@v_TEST_LAB_TEST_5|';
                           v_v_ColName1List := '@v_TEST_RESULT_1|@v_TEST_RESULT_2|@v_TEST_RESULT_3|@v_TEST_RESULT_4|@v_TEST_RESULT_5|';
                           v_v_ColName2List := '@v_TEST_DATE_1|@v_TEST_DATE_2|@v_TEST_DATE_3|@v_TEST_DATE_4|@v_TEST_DATE_5|';

                           WHILE INSTR(v_v_ColNameList, '|', 1) > 0
                           LOOP
                              BEGIN
                                 v_V_ERROR_LOCATION := 'MW29';

                               v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
                               v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));


                               v_v_ColName1 := SUBSTR(v_v_ColName1List, 0, INSTR(v_v_ColName1List, '|', 1) - 1);
                               v_v_ColName1List := SUBSTR(v_v_ColName1List,LENGTH(SUBSTR(v_v_ColName1List,1,INSTR(v_v_ColName1List, '|', 1)))+1,LENGTH(v_v_ColName1List));

                               v_v_ColName2 := SUBSTR(v_v_ColName2List, 0, INSTR(v_v_ColName2List, '|', 1) - 1);
                               v_v_ColName2List := SUBSTR(v_v_ColName2List,LENGTH(SUBSTR(v_v_ColName2List,1,INSTR(v_v_ColName2List, '|', 1)))+1,LENGTH(v_v_ColName2List));


                                 v_v_Val := (CASE
                                                  WHEN v_v_ColName = '@v_TEST_LAB_TEST_1' THEN v_v_TEST_LAB_TEST_1
                                                  WHEN v_v_ColName = '@v_TEST_LAB_TEST_2' THEN v_v_TEST_LAB_TEST_2
                                                  WHEN v_v_ColName = '@v_TEST_LAB_TEST_3' THEN v_v_TEST_LAB_TEST_3
                                                  WHEN v_v_ColName = '@v_TEST_LAB_TEST_4' THEN v_v_TEST_LAB_TEST_4
                                                  WHEN v_v_ColName = '@v_TEST_LAB_TEST_5' THEN v_v_TEST_LAB_TEST_5   END);

                                 v_v_Val1 := (CASE
                                                   WHEN v_v_ColName1 = '@v_TEST_RESULT_1' THEN v_v_TEST_RESULT_1
                                                   WHEN v_v_ColName1 = '@v_TEST_RESULT_2' THEN v_v_TEST_RESULT_2
                                                   WHEN v_v_ColName1 = '@v_TEST_RESULT_3' THEN v_v_TEST_RESULT_3
                                                   WHEN v_v_ColName1 = '@v_TEST_RESULT_4' THEN v_v_TEST_RESULT_4
                                                   WHEN v_v_ColName1 = '@v_TEST_RESULT_5' THEN v_v_TEST_RESULT_5   END);

                                 v_v_Val2 := (CASE
                                                   WHEN v_v_ColName2 = '@v_TEST_DATE_1' THEN v_v_TEST_DATE_1
                                                   WHEN v_v_ColName2 = '@v_TEST_DATE_2' THEN v_v_TEST_DATE_2
                                                   WHEN v_v_ColName2 = '@v_TEST_DATE_3' THEN v_v_TEST_DATE_3
                                                   WHEN v_v_ColName2 = '@v_TEST_DATE_4' THEN v_v_TEST_DATE_4
                                                   WHEN v_v_ColName2 = '@v_TEST_DATE_5' THEN v_v_TEST_DATE_5   END);

                        IF v_v_Val IS NOT NULL AND v_v_Val1 IS NOT NULL AND v_v_Val2 IS NOT NULL THEN
                             BEGIN
                                 ---mkaur24 start now
                                 v_v_EV_MW_TEST_ROW_ID_GEN_RMDB := 0 ;
                                     v_N_Sql := 'Select EV_MW_TEST_ROW_ID from ' || v_v_Dbname ||  'EVENT_X_MEDW_TEST where EVENT_ID = :1  ';
                                  v_N_Sql :=  v_N_sql || 'and LAB_TEST = :2';
                                   v_N_Sql :=  v_N_sql || 'and RESULT = :3  ';
                                 v_N_Sql :=  v_N_sql || 'and TEST_DATE = :4';

                                  v_V_ERROR_LOCATION := 'MWse38';
                                Begin
                                Execute Immediate v_n_sql into v_v_EV_MW_TEST_ROW_ID_GEN_RMDB using v_Event_ID,
                                  v_v_Val ,
                                  v_v_Val1 ,
                                  v_v_Val2  ;
                                  Exception
                                  when No_data_found then
                                           v_v_EV_MW_TEST_ROW_ID_GEN_RMDB :=0;
                                 End ;
                                IF (v_v_EV_MW_TEST_ROW_ID_GEN_RMDB = 0)   Then
                                  -- Generate Next Unique Id start
                                    v_N_sql := 'select Next_unique_id from ' || v_v_Dbname || 'glossary where system_table_name = :1';

                                    v_V_ERROR_LOCATION := 'MW30';

                                    begin

                                    execute immediate v_n_sql into v_v_Next_unique_id using  'EVENT_X_MEDW_TEST';
                                    exception
                                       when no_data_found then
                                            v_v_Next_unique_id:=0;

                                    end;

                                    IF v_v_Next_unique_id IS NULL OR v_v_Next_unique_id = 0 THEN
                                       v_v_Next_unique_id := 1;
                                    END IF;

                                    v_V_ERROR_LOCATION := 'MW31';

                                    v_v_EV_MW_TEST_ROW_ID_GEN := v_v_Next_unique_id;-- Generate Next Unique Id End


                                    v_N_Sql := 'Insert Into ' || v_v_Dbname || 'EVENT_X_MEDW_TEST (EV_MW_TEST_ROW_ID,EVENT_ID,LAB_TEST,RESULT,TEST_DATE) ';
                                    v_N_Sql := v_N_Sql || 'Values (:1 ,:2, :3 ,:4 ,:5 )';

                                    v_V_ERROR_LOCATION := 'MW32';

                                     execute immediate v_n_sql using
                                    v_v_EV_MW_TEST_ROW_ID_GEN,
                                    v_Event_ID,
                                    v_v_Val,
                                    v_v_Val1,
                                    v_v_Val2;



                               /*
                                    execute immediate v_n_sql into v_v_Next_unique_id using   v_v_EV_MW_TEST_ROW_ID_GEN,
                                                  v_Event_ID,
                                                  v_v_Val,
                                                  v_v_Val1,
                                                  v_v_Val2; -- KAPIL :p */


                                    v_V_ERROR_LOCATION := 'MW33';

                                    v_v_Next_unique_id := v_v_EV_MW_TEST_ROW_ID_GEN + 1;--Update Next_Unique_ID in Glossary Start

                                    v_N_sql := 'Update  ' || v_v_Dbname || 'glossary set Next_unique_id = :1';
                                    v_N_sql := v_N_sql || ' where system_table_name = :2';

                                    v_V_ERROR_LOCATION := 'MW34';

                                    execute immediate v_n_sql using  v_v_Next_unique_id,'EVENT_X_MEDW_TEST';


                                    v_V_ERROR_LOCATION := 'MW35';
                               End If ;
                                EnD ;
                                 END If;

                              END;
                           END LOOP;

                        END;
                        -- Insert inot Event_X_Medw_Test End
                        BEGIN
                           v_v_ColNameList := 'CONCOM_PRODUCT_ID_1|CONCOM_PRODUCT_ID_2|CONCOM_PRODUCT_ID_3|CONCOM_PRODUCT_ID_4|CONCOM_PRODUCT_ID_5|CONCOM_PRODUCT_ID_6|';

                           v_v_ColName1List := 'CONCOM_FROM_DATE_1|CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_FROM_DATE_6|';

                           v_v_ColName2List := 'CONCOM_TO_DATE_1|CONCOM_TO_DATE_2|CONCOM_TO_DATE_3|CONCOM_TO_DATE_4|CONCOM_TO_DATE_5|CONCOM_TO_DATE_6|';

                           v_v_ColName3List := 'CONCOM_PRODUCT_1|CONCOM_PRODUCT_2|CONCOM_PRODUCT_3|CONCOM_PRODUCT_4|CONCOM_PRODUCT_5|CONCOM_PRODUCT_6|';

                           WHILE INSTR(v_v_ColNameList, '|', 1) > 0
                           LOOP
                              BEGIN
                               v_v_ColName := SUBSTR(v_v_ColNameList, 0, INSTR(v_v_ColNameList, '|', 1) - 1);
                               v_v_ColNameList := SUBSTR(v_v_ColNameList,LENGTH(SUBSTR(v_v_ColNameList,1,INSTR(v_v_ColNameList, '|', 1)))+1,LENGTH(v_v_ColNameList));


                               v_v_ColName1 := SUBSTR(v_v_ColName1List, 0, INSTR(v_v_ColName1List, '|', 1) - 1);
                               v_v_ColName1List := SUBSTR(v_v_ColName1List,LENGTH(SUBSTR(v_v_ColName1List,1,INSTR(v_v_ColName1List, '|', 1)))+1,LENGTH(v_v_ColName1List));

                               v_v_ColName2 := SUBSTR(v_v_ColName2List, 0, INSTR(v_v_ColName2List, '|', 1) - 1);
                               v_v_ColName2List := SUBSTR(v_v_ColName2List,LENGTH(SUBSTR(v_v_ColName2List,1,INSTR(v_v_ColName2List, '|', 1)))+1,LENGTH(v_v_ColName2List));

                               v_v_ColName3 := SUBSTR(v_v_ColName3List, 0, INSTR(v_v_ColName3List, '|', 1) - 1);
                               v_v_ColName3List := SUBSTR(v_v_ColName3List,LENGTH(SUBSTR(v_v_ColName3List,1,INSTR(v_v_ColName3List, '|', 1)))+1,LENGTH(v_v_ColName3List));


                                 v_v_Val := (CASE
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_1' THEN v_v_CONCOM_PRODUCT_ID_1
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_2' THEN v_v_CONCOM_PRODUCT_ID_2
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_3' THEN v_v_CONCOM_PRODUCT_ID_3
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_4' THEN v_v_CONCOM_PRODUCT_ID_4
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_5' THEN v_v_CONCOM_PRODUCT_ID_5
                                                  WHEN v_v_ColName = 'CONCOM_PRODUCT_ID_6' THEN v_v_CONCOM_PRODUCT_ID_6   END);

                                 v_v_Val1 := (CASE
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_1' THEN v_v_CONCOM_FROM_DATE_1
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_2' THEN v_v_CONCOM_FROM_DATE_2
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_3' THEN v_v_CONCOM_FROM_DATE_3
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_4' THEN v_v_CONCOM_FROM_DATE_4
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_5' THEN v_v_CONCOM_FROM_DATE_5
                                                   WHEN v_v_ColName1 = 'CONCOM_FROM_DATE_6' THEN v_v_CONCOM_FROM_DATE_6   END);

                                 v_v_Val2 := (CASE
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_1' THEN v_v_CONCOM_TO_DATE_1
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_2' THEN v_v_CONCOM_TO_DATE_2
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_3' THEN v_v_CONCOM_TO_DATE_3
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_4' THEN v_v_CONCOM_TO_DATE_4
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_5' THEN v_v_CONCOM_TO_DATE_5
                                                   WHEN v_v_ColName2 = 'CONCOM_TO_DATE_6' THEN v_v_CONCOM_TO_DATE_6   END);

                                 v_v_Val3 := (CASE
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_1' THEN v_v_CONCOM_PRODUCT_1
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_2' THEN v_v_CONCOM_PRODUCT_2
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_3' THEN v_v_CONCOM_PRODUCT_3
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_4' THEN v_v_CONCOM_PRODUCT_4
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_5' THEN v_v_CONCOM_PRODUCT_5
                                                   WHEN v_v_ColName3 = 'CONCOM_PRODUCT_6' THEN v_v_CONCOM_PRODUCT_6   END);

                                 IF v_v_Val IS NOT NULL
                                   AND v_v_Val1 IS NOT NULL
                                   AND v_v_Val2 IS NOT NULL
                                   AND v_v_Val3 IS NOT NULL THEN
                                 BEGIN

                                  v_N_Sql := 'Select EV_CONCOM_ROW_ID from ' || v_v_Dbname ||  'EV_X_CONCOM_PROD where EVENT_ID = :1  ';
                                  v_N_Sql :=  v_N_sql || 'and CONCOM_PRODUCT_ID = :2';
                                   v_N_Sql :=  v_N_sql || 'and FROM_DATE = :3  ';
                                 v_N_Sql :=  v_N_sql || 'and TO_DATE = :4';
                                   v_N_Sql :=  v_N_sql || 'and CONCOM_PRODUCT = :5 ';
                                  v_V_ERROR_LOCATION := 'MWse38';
                                Begin
                                Execute Immediate v_n_sql into v_v_EV_X_CONCOM_PROD_RMDB using v_Event_ID,
                                  v_v_Val ,
                                  v_v_Val1 ,
                                  v_v_Val2       ,
                                  v_v_Val3;
                                  Exception
                                  when No_data_found then
                                           v_v_EV_X_CONCOM_PROD_RMDB :=0;
                                 End ;

                                 IF (v_v_EV_X_CONCOM_PROD_RMDB = 0) Then
                                    -- Generate Next Unique Id start
                                    v_N_sql := 'select Next_unique_id from ' || v_v_Dbname || 'glossary where system_table_name = :1';

                                    v_V_ERROR_LOCATION := 'MW36';

                                    Begin
                                    execute immediate v_n_sql into v_v_Next_unique_id using  'EV_X_CONCOM_PROD';
                                    Exception
                                       when no_data_found then
                                            v_v_Next_unique_id:=0;

                                    End;

                                    v_V_ERROR_LOCATION := 'MW37';

                                    IF v_v_Next_unique_id IS NULL OR v_v_Next_unique_id = 0 THEN
                                       v_v_Next_unique_id := 1;

                                    END IF;

                                    v_v_EV_X_CONCOM_PROD_GEN := v_v_Next_unique_id;

                                    -- Generate Next Unique Id End
                                    v_N_Sql := 'Insert Into ' || v_v_Dbname || 'EV_X_CONCOM_PROD (EV_CONCOM_ROW_ID,EVENT_ID,CONCOM_PRODUCT_ID,FROM_DATE,TO_DATE,CONCOM_PRODUCT) ';
                                    v_N_Sql := v_N_Sql || 'Values (:1 , :2 ,:3 ,:4 , :5 , :6)';

                                    v_V_ERROR_LOCATION := 'MW38';

                                    execute immediate v_n_sql using
                                    v_v_EV_X_CONCOM_PROD_GEN,
                                    v_Event_ID,
                                    v_v_Val,
                                    v_v_Val1,
                                    v_v_Val2,
                                    v_v_Val3;


                                    v_V_ERROR_LOCATION := 'MW39';

                                    --Update Next_Unique_ID in Glossary Start
                                    v_v_Next_unique_id := v_v_EV_X_CONCOM_PROD_GEN + 1;

                                    v_N_sql := 'Update  ' || v_v_Dbname || 'glossary set Next_unique_id = :1 ';
                                    v_N_sql := v_N_sql || ' where system_table_name = :2';

                                    v_V_ERROR_LOCATION := 'MW40';

                                    execute immediate v_n_sql  using  v_v_Next_unique_id ,'EV_X_CONCOM_PROD';

                                    v_V_ERROR_LOCATION := 'MW41';

                                 END IF ;
                                 END;
                                 END IF;

                              END;
                           END LOOP;

                        END;
                        --Update Next_Unique_ID in Glossary End
                        --Insert into Event_X_Medw_test Ends
                        v_V_ERROR_LOCATION := 'MW2';

                     END;
                     END IF;

                     --Supplemental Insert Starts\
                     IF ( v_MEDWATCH_SUPP <> 0 ) AND ( v_I_ERRORCOUNT = 0 ) AND ( v_Event_ID > 0 ) THEN
                        DDS_SUPPLEMENT( v_p_JOBID,-- Insert call for Medwatch
                                             v_CONFIG_ID,
                                           v_p_USERID,
                                              'MEDWATCH',
                                             v_V_DBName,
                                              v_v_DA_ROW_ID,
                                              v_CheckCreateNewCodes,
                                             0,
                                             v_I_ERRORCOUNT,
                                            'I',
                                              0,
                                              v_Event_ID,
                                           0,
                                             0,
                                            0,
                                           0,
                                            0,
                                           0,
                                           0,
                                          0,
                                         0,
                                            0,
                                            v_v_EV_X_CONCOM_PROD_GEN,
                                            v_v_EV_MW_TEST_ROW_ID_GEN,
                                          'EVENT_NUMBER',
                                            v_v_EVENT_NUMBER,
                                        v_P_SUPP_ERROR_COUNT_R);


                     END IF;

                     --Supplemental Insert Ends



                     v_V_ERROR_LOCATION := 'MW43';

                  END;

             IF v_I_ERRORCOUNT = 0 THEN
  UPDATE DDS_MEDWATCH SET INVALID_ROW = 0 WHERE  JOBID = v_v_JOBID AND DA_ROW_ID = v_V_DA_ROW_ID;

   COMMIT ;
  END IF ;

          ---Neha Running status code starts 33658--- 
          --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);  
          v_V_ERROR_LOCATION := 'Running_Status';
          IF v_iRunStatCnt = 1 THEN
            BEGIN
              v_vProcessMsg := 'Total Number of Records processed in MEDWATCH : ' ||v_iRunStatCnt;
                               
              EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
              USING v_P_JOBID, v_vProcessMsg, 'MEDWATCH_RUN', 'DDS_MEDWATCH_RUN', -11;
            END;
          ELSIF v_iRunCnt = 1000 THEN
              BEGIN
                v_vProcessMsg := 'Total Number of Records processed in MEDWATCH : ' || v_iRunStatCnt;
                v_N_sql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
                MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
              
                EXECUTE IMMEDIATE v_N_sql using v_vProcessMsg, v_P_JOBID, 'MEDWATCH_RUN', 'DDS_MEDWATCH_RUN';
              v_iRunCnt:=1;
              END;
           ELSIF (v_iCount=v_iRunStatCnt) THEN
              BEGIN
              v_vProcessMsg := 'Total Number of Records processed in MEDWATCH : ' ||v_iCount;
              v_N_sql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND 
              MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
  
             EXECUTE IMMEDIATE v_N_sql using v_vProcessMsg, v_P_JOBID, 'MEDWATCH_RUN', 'DDS_MEDWATCH_RUN';
             END;
            
          END IF;
         COMMIT;
    
         v_iRunStatCnt := v_iRunStatCnt + 1;
         v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658--- 
        





              EXCEPTION
                  WHEN OTHERS THEN
                        v_V_ERROR_MESSAGE := SQLERRM;
                        DDS_ERROR_LOG_CAPTURE( v_v_JOBID,
                                               v_V_DA_ROW_ID,
                                               v_V_MODULENAME,
                                              'Main',
                                               v_V_ERROR_LOCATION,
                                               v_V_PROCNAME,
                                               v_V_ERROR_MESSAGE,
                                              NULL,
                                               v_V_ERROR_TABLE_TO_CHECK,
                                              'EVENT_NUMBER',
                                              v_v_EVENT_NUMBER,
                                               0);
     ROLLBACK ; --mkaur24 kapil ?

                        v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
               END;

               v_V_ERROR_LOCATION := 'MW44';

               v_TotalRows := v_TotalRows - 1;

               -- REINITIALIZE LOCAL VARIBLES START
               v_I_ERRORCOUNT := 0;
               v_v_ColName := NULL;
               v_v_ColName2 := NULL;
               v_v_ColName3 := NULL;
               v_v_ColName1List := NULL;
               v_v_ColName2List := NULL;
               v_v_ColName3List := NULL;
               v_v_TableName := NULL;
               v_v_ColNameList := NULL;
               v_v_TableNameList := NULL;
               v_iCodeId := 0;
               v_v_Val := NULL;
               v_v_Val1 := NULL;
               v_v_Val2 := NULL;
               v_v_Val3 := NULL;
               v_N_sql := NULL;
               v_MANUF_STATE_R := 0;
               v_RPTD_BY_STATE_R := 0;
               v_RPTD_BY_PRO_FLAG_R := 0;
               v_ADVERSE_EVENT_FLAG_R := 0;
               v_PRODUCT_PROB_FLAG_R := 0;
               v_HOSPITALIZ_FLAG_R := 0;
               v_DISABILITY_FLAG_R := 0;
               v_CONGENITAL_FLAG_R := 0;
               v_REQD_INTERV_FLAG_R := 0;
                v_RPTD_BY_TAX_ID_Invalid_Flag := 0; --see
               v_ErrorColumn := NULL;
               v_iEntId := 0;
               v_i_Reporter_ENTITY_ID_GEN := 0;
               v_iNoError := 0;
               v_i_MANUF_ENTITY_ID_GEN := 0;
               v_Entity_Id := 0;
               v_Do_Nothing := 0;
               v_Event_ID := 0;
               v_DEV_AVAIL_FOR_EVAL_R := 0;
               v_EVENT_REAPPEARED_R := 0;
               v_EVENT_ABATED_R := 0;
               v_RPT_MANDATORY_R := 0;
               v_REVENT_ABATED_R := 0;
               v_V_DTTM_RCD_LAST_UPD_GEN := NULL;
               v_v_UPDATED_BY_USER := NULL;
               v_Event_ID_MED := 0;
               v_UNIT_CODE_R := 0;
               v_LIFE_THREAT_FLAG_R := 0;
               v_v_Next_unique_id := 0;
               v_v_EV_MW_TEST_ROW_ID_GEN := 0;
               v_v_EV_CONCOM_ROW_ID_GEN := 0;
               v_v_EV_X_CONCOM_PROD_GEN := 0;
               v_V_ERROR_LOCATION := NULL;
               v_P_SUPP_ERROR_COUNT_R := 0;
      v_v_EV_X_CONCOM_PROD_RMDB := 0;
      v_v_EV_MW_TEST_ROW_ID_GEN_RMDB  := 0;

            END;
         END LOOP;

         -- REINITIALIZE LOCAL VARIBLES START
         v_V_ERROR_LOCATION := 'MW45';

         CLOSE Cur_MedWatch;

         v_V_ERROR_LOCATION := 'MW46';

      END;
         DDS_PROCESS_LOG (v_v_JOBID,'MEDWATCH','DDS_MEDWATCH') ;

   EXCEPTION
      WHEN OTHERS THEN
            V_V_ERROR_MESSAGE := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_v_JOBID,
                                  v_V_DA_ROW_ID,
                                  v_V_MODULENAME,
                                  'Main',
                                  v_V_ERROR_LOCATION,
                                  v_V_PROCNAME,
                                  V_V_ERROR_MESSAGE,
                                  NULL,
                                  v_V_ERROR_TABLE_TO_CHECK,
                                  'EVENT_NUMBER',
                                  v_v_EVENT_NUMBER,
                                  0);
 ROLLBACK ;  --mkaur24 kapil ?
            v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

END DA_DDS_MEDWATCH_IMPORT;
