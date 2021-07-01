CREATE OR REPLACE PROCEDURE DA_DDS_EVENT_IMPORT
--DROP  PROCEDURE DA_DDS_EVENT_IMPORT
(
  P_jobID IN NUMBER,
  P_DBName IN VARCHAR2,
  P_USER_ID IN NUMBER
)
AUTHID CURRENT_USER
AS
     -- VARIABLES for criterion settings
      v_CheckCreateNewCodes NUMBER;
      v_CheckCreateNewEmployees NUMBER;
      v_CheckCreateNewDEPARTMENT NUMBER;
      v_EmployeeMatchByName NUMBER;
      v_EmployeeMatchByTaxId NUMBER;
      v_EmployeeMatchByEmpNumber NUMBER;
      v_NonEmployeeMatchByName NUMBER;
      v_NonEmployeeMatchByTaxId NUMBER;
      v_NonEmployeeMatchByNameTaxId NUMBER;
      v_CrtNwEvntPiEntyIfTxIDEmpty NUMBER;
      v_NonEmpMatchByDob NUMBER;   --JIRA 24634 knakra
      v_EmpMatchByDob NUMBER; --JIRA 24634 knakra

      -- VARIABLES FOR CODE RELATED VALIDATION

      --v_CODE_ID_R NUMBER;
      v_iCodeId NUMBER;
      v_EVENT_STATUS_CODE_R NUMBER;
      v_EVENT_IND_CODE_R NUMBER;
      v_LOCATION_TYPE_CODE_R NUMBER;
      v_CAUSE_CODE_R NUMBER;
      v_PRIMARY_LOC_CODE_R NUMBER;
      v_EVENT_TYPE_CODE_R NUMBER;
      v_ACTION_1_CODE_R NUMBER;
      v_ACTION_2_CODE_R NUMBER;
      v_ACTION_3_CODE_R NUMBER;
      v_ACTION_4_CODE_R NUMBER;
      v_ACTION_5_CODE_R NUMBER;
      v_OUTCOME_1_CODE_R NUMBER;
      v_OUTCOME_2_CODE_R NUMBER;
      v_OUTCOME_3_CODE_R NUMBER;
      v_OUTCOME_4_CODE_R NUMBER;
      v_OUTCOME_5_CODE_R NUMBER;
      v_MARITAL_STAT_CODE_R NUMBER;
      v_SEX_CODE_R NUMBER;
      v_INJURY_1_CODE_R NUMBER;
      v_INJURY_2_CODE_R NUMBER;
      v_INJURY_3_CODE_R NUMBER;
      v_INJURY_4_CODE_R NUMBER;
      v_INJURY_5_CODE_R NUMBER;
      v_BODY_PART_1_CODE_R NUMBER;
      v_BODY_PART_2_CODE_R NUMBER;
      v_BODY_PART_3_CODE_R NUMBER;
      v_BODY_PART_4_CODE_R NUMBER;
      v_BODY_PART_5_CODE_R NUMBER;
      v_DIAGNOSIS_1_CODE_R NUMBER;
      v_DIAGNOSIS_2_CODE_R NUMBER;
      v_DIAGNOSIS_3_CODE_R NUMBER;
      v_DIAGNOSIS_4_CODE_R NUMBER;
      v_DIAGNOSIS_5_CODE_R NUMBER;
      v_TREATMENT_1_CODE_R NUMBER;
      v_TREATMENT_2_CODE_R NUMBER;
      v_TREATMENT_3_CODE_R NUMBER;
      v_TREATMENT_4_CODE_R NUMBER;
      v_TREATMENT_5_CODE_R NUMBER;
      v_DRIVERSLICTYPECODE_R NUMBER;
      v_DRIVLIC_RSTRCT_CODE_R NUMBER;
      v_NCCI_CLASS_CODE_R NUMBER;
      v_ADM_TYPE_CODE_R NUMBER;
      v_ADM_SOURCE_CODE_R NUMBER;
      v_ACUITY_LEVEL_CODE_R NUMBER;
      v_PATIENT_STAT_CODE_R NUMBER;
      v_PATIENT_COND_CODE_R NUMBER;
      v_DISCHARGE_DSP_CODE_R NUMBER;
      v_PATIENT_TYPE_CODE_R NUMBER;
      v_FACILITY_UNIT_CODE_R NUMBER;
      v_DISABILITY_CODE_R NUMBER;
      v_POSITION_CODE_R NUMBER;
      v_PAY_TYPE_CODE_R NUMBER;
      v_COND_PRIOR_CODE_R NUMBER;
      v_RAIL_POSITION_CODE_R NUMBER;
      v_RESTRAINT_CODE_R NUMBER;
      v_BED_POSITION_CODE_R NUMBER;
      v_ILLNESS_CODE_R NUMBER;
      v_NAME_TYPE_R NUMBER;
      v_SHARPS_OBJECT_R NUMBER;
      v_SHARPS_BRAND_MAKE_R NUMBER;
      v_RULES_NOT_FOLLOWED_R NUMBER;
      v_SAFEG_PROVIDED_R NUMBER;
      v_CALL_LIGHT_CODE_R NUMBER;
      v_REPORTED_COUNTRY_R NUMBER;
      v_QI_SIGNIF_CODE_R NUMBER;
      v_COUNTRY_R NUMBER;
      v_STATE_R NUMBER;
      v_PI_TYPE_CODE_R NUMBER;
      --v_SEX_CODE_CODE_R NUMBER; Abhishek
      v_DRIVLIC_STATE_R NUMBER;
      v_I_ERRORCOUNT NUMBER;
      v_I_ROWCOUNT NUMBER;
      V_MODULENAME VARCHAR2(100);
      V_PROCNAME VARCHAR2(30);
      V_CLOCATION VARCHAR2(30);
      v_N_SQL CLOB;
      v_I_COUNT NUMBER;
      V_DBName VARCHAR2(255);
      V_CheckTime VARCHAR2(25);
      v_I_STATEID_GEN NUMBER;
      V_DTTM_RCD_ADDED_GEN VARCHAR2(255);
      V_DTTM_RCD_LAST_UPD_GEN VARCHAR2(255);
      V_UPDATED_BY_USER VARCHAR2(25);
      V_ADDED_BY_USER VARCHAR2(25);
      V_NEXT_UNIQUE_ID VARCHAR2(255);
      v_N_SQL_EVENT  CLOB;
      V_ORGSEC_FLAG NUMBER;
      V_SEC_DEPT_EID NUMBER;
      v_vReqColumns VARCHAR2(255);
      v_vCodeFieldList  CLOB;
      v_vSysTableNameList  CLOB;
      v_iPos NUMBER;
      v_vColName VARCHAR2(100);
      v_nSql  CLOB;
      v_vColList  CLOB;
      v_iCount NUMBER;
      v_vVal VARCHAR2(255);
      v_vTableList CLOB;
      v_vTableName VARCHAR2(100);
      v_vColToProcess VARCHAR2(255);
      v_vTab VARCHAR2(255);
      v_vTabToProcess  CLOB;
      v_vColInRM VARCHAR2(255);
      v_vColName_value NUMBER;

      --***********  FLAGS ********************
      v_I_ON_PREMISE_FLAG_GEN NUMBER;
      v_I_NO_RULES_FLAG_GEN NUMBER;
      v_I_RECORDABLE_FLAG_GEN NUMBER;
      v_I_SAFEG_NOTUSED_GEN NUMBER;
      v_I_SAFEGUARD_FLAG_GEN NUMBER;
      v_I_PRIVACY_CASE_GEN NUMBER;
       v_I_TREATMENT_GIVEN_GEN NUMBER;
      v_I_RELEASE_SIGNED_GEN NUMBER;
      v_I_DEPT_HEAD_ADVISED_GEN NUMBER;
      V_WORK_SUN_FLAG_GEN NUMBER;
      V_WORK_MON_FLAG_GEN NUMBER;
      V_WORK_TUE_FLAG_GEN NUMBER;
      V_WORK_WED_FLAG_GEN NUMBER;
      V_WORK_THU_FLAG_GEN NUMBER;
      V_WORK_FRI_FLAG_GEN NUMBER;
      V_WORK_SAT_FLAG_GEN NUMBER;
      V_FULL_TIME_FLAG_GEN NUMBER;

      V_ACTIVE_FLAG_GEN NUMBER;
      V_EXEMPT_STATUS_FLAG_GEN NUMBER;
      V_INSURABLE_FLAG_GEN NUMBER;
      V_REGULAR_JOB_FLAG_GEN NUMBER;
      V_LOST_WORK_FLAG_GEN NUMBER;

     --******Dept_Existence Flag**************
      v_i_DEPARTMENT_GEN NUMBER;
      v_i_DEPT_INVOLVED_GEN NUMBER;
      v_i_DEPT_ASSIGNED_GEN NUMBER;
      v_i_FACILITY_DEPT_GEN NUMBER;
      v_i_OSHA_ESTAB_EID_GEN NUMBER;

      --******UPDATE FLAGS *****
      --v_i_UPDATE_FLAG_PI NUMBER; Abhishek
      --v_i_UPDATE_FLAG_SUPERVISOR NUMBER; Abhishek
      v_i_UPDATE_FLAG NUMBER;
      v_i_UPDATE_FLAG_EMP NUMBER;
      v_I_UPDATE_FLAG_EVENT NUMBER;

      --*** Genrated ID's **********
      v_i_PI_ROW_ID NUMBER := 0 ;
      v_i_ENTITY_ID NUMBER := 0  ;
      v_i_EVENT_ID NUMBER := 0;
      v_i_PATIENT_ID_GEN NUMBER := 0;
      v_i_PI_TYPE_ENTITY_ID_GEN NUMBER := 0 ;
      v_i_SUPERVISOR_ENTITY_ID_GEN NUMBER := 0 ;
      v_i_PRI_PHYSICIAN_EID_GEN NUMBER := 0 ;
      v_i_ADM_PHYSICIAN_EID_GEN NUMBER := 0  ;

      --** Hospital / Physician VD RELATED VARIEABLES
      v_vColName1 VARCHAR2(255);
      v_vColName2 VARCHAR2(255);
      v_vColName3 VARCHAR2(255);
      v_vVal2 VARCHAR2(255);
      v_vColName4 VARCHAR2(255);
      v_vVal3 VARCHAR2(255);
      v_i_HOSPITAL_1_EID NUMBER := 0 ;
      v_i_HOSPITAL_2_EID NUMBER := 0 ;
      v_i_HOSPITAL_3_EID NUMBER := 0 ;
      v_i_PHYSICIAN_1_EID NUMBER := 0 ;
      v_i_PHYSICIAN_2_EID NUMBER := 0  ;
      v_i_PHYSICIAN_3_EID NUMBER := 0 ;

      --*** Process Entity *******
     /* v_Person TENTITY;
      v_Department TORG_HIERARCHY;*/
      v_iEntId NUMBER;
      V_ERROR_MESSAGE CLOB;
     -- V_i_Reporter_ENTITY_ID_GEN NUMBER;

      --**** STATE VARIABLE********]
      --V_STATE_R NUMBER;
      V_REPORTED_STATE_R NUMBER;
      V_PI_STATE_R NUMBER;
      --V_DRIVLIC_STATE_R NUMBER;
      V_SUPER_STATE_R NUMBER;
      v_STATE_ROW_ID_R NUMBER;

      ---****WORKLOASS FLAG *****
      v_i_PI_WL_ROW_ID NUMBER;
      --v_vColToProcess2 CLOB;
      v_iCount2 NUMBER;
      v_iROW_ID NUMBER := 0 ;
      -- VARIABLES for EVENT  Column
      /*V_JOBID NUMBER;
      V_DA_ROW_ID NUMBER;
      V_INVALID_ROW NUMBER;
      V_UPDATE_ROW NUMBER;
      V_INPUT_ROW_ID NUMBER;
      V_EVENT_NUMBER VARCHAR2(25);
      V_EVENT_TYPE_CODE VARCHAR2(25);
      V_EVENT_STATUS_CODE VARCHAR2(25);
      V_EVENT_IND_CODE VARCHAR2(25);
      V_EVENT_DESCRIPTION CLOB;
      V_BRIEF_DESCRIPTION VARCHAR2(250);
      V_DEPARTMENT VARCHAR2(25);
      V_DEPT_INVOLVED VARCHAR2(25);
      V_ADDR1 VARCHAR2(100);
      V_ADDR2 VARCHAR2(100);
      V_CITY VARCHAR2(50);
      V_STATE VARCHAR2(4);
      V_ZIP_CODE VARCHAR2(10);
      V_COUNTRY VARCHAR2(20);
      V_COUNTY_OF_INJURY VARCHAR2(50);

      V_LOCATION_AREA_DESC CLOB;
      V_PRIMARY_LOC_CODE VARCHAR2(25);
      V_LOCATION_TYPE_CODE VARCHAR2(25);
      V_ON_PREMISE_FLAG VARCHAR2(1);
      V_NO_OF_INJURIES NUMBER;
      V_NO_OF_FATALITIES NUMBER;
      V_CAUSE_CODE VARCHAR2(25);
      V_DATE_OF_EVENT VARCHAR2(8);
      V_TIME_OF_EVENT VARCHAR2(6);
      V_DATE_REPORTED VARCHAR2(8);
      V_TIME_REPORTED VARCHAR2(6);
      V_REPORTED_TAX_ID NUMBER;
      V_REPORTED_LAST_NAME VARCHAR2(255);
      V_REPORTED_FIRST_NAME VARCHAR2(255);
      V_REPORTED_ADDR1 VARCHAR2(100);
      V_REPORTED_ADDR2 VARCHAR2(100);
      V_REPORTED_CITY VARCHAR2(50);
      V_REPORTED_STATE VARCHAR2(4);
      V_REPORTED_ZIP_CODE VARCHAR2(10);
      V_REPORTED_PHONE VARCHAR2(30);
      V_COMMENTS CLOB;
      V_ACTIVITY_WHEN_INJ VARCHAR2(255);
      V_HOW_ACC_OCCURRED VARCHAR2(255);
      V_OBJ_SUBST_THAT_INJ VARCHAR2(255);
      V_RECORDABLE_FLAG VARCHAR2(1);
      V_SAFEG_NOTUSED_FLAG VARCHAR2(1);
      V_SAFEGUARD_FLAG VARCHAR2(1);
      V_NO_RULES_FLAG VARCHAR2(1);
      V_DATE_PHYS_ADVISED VARCHAR2(8);
      V_TIME_PHYS_ADVISED VARCHAR2(8);
      V_ACTION_1_CODE VARCHAR2(25);
      V_ACTION_2_CODE VARCHAR2(25);
      V_ACTION_3_CODE VARCHAR2(25);
      V_ACTION_4_CODE VARCHAR2(25);
      V_ACTION_5_CODE VARCHAR2(25);
      V_OUTCOME_1_CODE VARCHAR2(25);
      V_OUTCOME_2_CODE VARCHAR2(25);
      V_OUTCOME_3_CODE VARCHAR2(25);
      V_OUTCOME_4_CODE VARCHAR2(25);
      V_OUTCOME_5_CODE VARCHAR2(25);
      V_DATE_TO_FOLLOW_UP VARCHAR2(8);
      V_TREATMENT_GIVEN VARCHAR2(1);
      V_RELEASE_SIGNED VARCHAR2(1);
      V_DEPT_HEAD_ADVISED VARCHAR2(1);
      V_PHYS_NOTES CLOB;
      V_DATE_CARRIER_NOTIF VARCHAR2(8);
      V_PI_SUFFIX NUMBER;
      V_PI_TAX_ID NUMBER;
      V_PI_LAST_NAME VARCHAR2(255);
      V_PI_FIRST_NAME VARCHAR2(255);
      V_PI_ADDR1 VARCHAR2(100);
      V_PI_ADDR2 VARCHAR2(100);
      V_PI_CITY VARCHAR2(50);
      V_PI_STATE VARCHAR2(4);
      V_PI_ZIP_CODE VARCHAR2(10);
      V_PI_PHONE VARCHAR2(30);
      V_PI_TYPE_CODE VARCHAR2(50);
      V_MARITAL_STAT_CODE VARCHAR2(25);
      V_SEX_CODE VARCHAR2(8);
      V_BIRTH_DATE VARCHAR2(8);
      V_DATE_OF_DEATH VARCHAR2(8);
      V_ILLNESS_CODE VARCHAR2(25);
      V_INJURY_1_CODE VARCHAR2(25);
      V_INJURY_2_CODE VARCHAR2(25);
      V_INJURY_3_CODE VARCHAR2(25);
      V_INJURY_4_CODE VARCHAR2(25);
      V_INJURY_5_CODE VARCHAR2(25);
      V_BODY_PART_1_CODE VARCHAR2(25);
      V_BODY_PART_2_CODE VARCHAR2(25);
      V_BODY_PART_3_CODE VARCHAR2(25);
      V_BODY_PART_4_CODE VARCHAR2(25);
      V_BODY_PART_5_CODE VARCHAR2(25);
      V_DIAGNOSIS_1_CODE VARCHAR2(25);
      V_DIAGNOSIS_2_CODE VARCHAR2(25);
      V_DIAGNOSIS_3_CODE VARCHAR2(25);
      V_DIAGNOSIS_4_CODE VARCHAR2(25);
      V_DIAGNOSIS_5_CODE VARCHAR2(25);
      V_TREATMENT_1_CODE VARCHAR2(25);
      V_TREATMENT_2_CODE VARCHAR2(25);
      V_TREATMENT_3_CODE VARCHAR2(25);
      V_TREATMENT_4_CODE VARCHAR2(25);
      V_TREATMENT_5_CODE VARCHAR2(25);
      V_PHYSICIAN_1_LAST_NAME VARCHAR2(50);
      V_PHYSICIAN_1_FIRST_NAME VARCHAR2(25);
      V_PHYSICIAN_1_PHONE VARCHAR2(30);
      V_PHYSICIAN_2_LAST_NAME VARCHAR2(50);
      V_PHYSICIAN_2_FIRST_NAME VARCHAR2(25);
      V_PHYSICIAN_2_PHONE VARCHAR2(30);
      V_PHYSICIAN_3_LAST_NAME VARCHAR2(50);
      V_PHYSICIAN_3_FIRST_NAME VARCHAR2(25);
      V_PHYSICIAN_3_PHONE VARCHAR2(30);
      V_HOSPITAL_1_NAME VARCHAR2(50);
      V_HOSPITAL_1_PHONE VARCHAR2(30);
      V_HOSPITAL_2_NAME VARCHAR2(50);
      V_HOSPITAL_2_PHONE VARCHAR2(30);
      V_HOSPITAL_3_NAME VARCHAR2(50);
      V_HOSPITAL_3_PHONE VARCHAR2(30);
      V_DRIVERS_LIC_NO VARCHAR2(20);
      V_DRIVERSLICTYPECODE VARCHAR2(25);
      V_DATE_DRIVERSLICEXP VARCHAR2(8);
      V_DRIVLIC_RSTRCT_CODE VARCHAR2(25);
      V_DRIVLIC_STATE VARCHAR2(4);
      V_COUNTY_OF_RESIDNC VARCHAR2(50);
      V_NCCI_CLASS_CODE VARCHAR2(25);
      V_EST_LEN_DISABILITY NUMBER;
      V_INSURABLE_FLAG VARCHAR2(1);
      V_LAST_VERIFIED_DATE VARCHAR2(8);
      V_PATIENT_ACCT_NO VARCHAR2(20);
      V_MEDICAL_RCD_NO VARCHAR2(12);
      V_INS_PLAN_GROUP_NO VARCHAR2(16);
      V_DATE_OF_ADMISSION VARCHAR2(8);
      V_DATE_OF_DISCHARGE VARCHAR2(8);
      V_ADM_TYPE_CODE VARCHAR2(25);
      V_ADM_SOURCE_CODE VARCHAR2(25);
      V_ADMISSION_REASON CLOB;
      V_ACUITY_LEVEL_CODE VARCHAR2(25);
      V_PATIENT_STAT_CODE VARCHAR2(25);
      V_PATIENT_COND_CODE VARCHAR2(25);
      V_DISCHARGE_DSP_CODE VARCHAR2(25);
      V_EXP_LENGTH_OF_STAY NUMBER;
      V_EXPECTED_COST NUMBER;
      V_QI_SIGNIF_CODE VARCHAR2(25);
      V_EPISODE_OF_CARE_ID VARCHAR2(8);
      V_PATIENT_TYPE_CODE VARCHAR2(25);
      V_WEIGHT NUMBER;
      V_EMERGENCY_CONTACT VARCHAR2(20);
      V_EMERGENCY_CONT_NO VARCHAR2(20);
      V_PATIENT_ROOM_NO VARCHAR2(14);
      V_FACILITY_UNIT_CODE VARCHAR2(25);
      V_FACILITY_DEPT VARCHAR2(25);
      V_HCO_ID_NO VARCHAR2(20);
      V_HCO_SITE_ID_NO VARCHAR2(20);
      V_WHY_AT_FACILITY CLOB;
      V_DISABILITY_CODE VARCHAR2(25);  Abhishek: These variables are never used.*/
      V_EMPLOYEE_NUMBER VARCHAR2(20);
      /*V_POSITION_CODE VARCHAR2(25);
      V_DEPT_ASSIGNED VARCHAR2(25);
      V_SUPER_TAX_ID VARCHAR2(34);  Abhishek: These variables are never used.*/
      V_SUPER_EMP_NO VARCHAR2(20);
      /*V_SUPER_LAST_NAME VARCHAR2(255);
      V_SUPER_FIRST_NAME VARCHAR2(255);
      V_SUPER_ADDR1 VARCHAR2(100);
      V_SUPER_ADDR2 VARCHAR2(100);
      V_SUPER_CITY VARCHAR2(50);
      V_SUPER_STATE VARCHAR2(4);
      V_SUPER_ZIP_CODE VARCHAR2(10);
      V_SUPER_PHONE1 VARCHAR2(30);
      V_FULL_TIME_FLAG VARCHAR2(1);
      V_PAY_TYPE_CODE VARCHAR2(25);
      V_HOURLY_RATE NUMBER;
      V_WEEKLY_HOURS NUMBER;
      V_WEEKLY_RATE NUMBER;
      V_PAY_AMOUNT FLOAT(53);
      V_ACTIVE_FLAG VARCHAR2(1);
      V_DATE_HIRED VARCHAR2(8);
      V_DATE_LAST_WORKED_1 VARCHAR2(8);
      V_DATE_RETURNED_1 VARCHAR2(8);
      V_DATE_LAST_WORKED_2 VARCHAR2(8);
      V_DATE_RETURNED_2 VARCHAR2(8);
      V_DATE_LAST_WORKED_3 VARCHAR2(8);
      V_DATE_RETURNED_3 VARCHAR2(8);
      V_DATE_LAST_WORKED_4 VARCHAR2(8);
      V_DATE_RETURNED_4 VARCHAR2(8);
      V_DATE_LAST_WORKED_5 VARCHAR2(8);
      V_DATE_RETURNED_5 VARCHAR2(8);
      V_DATE_LAST_WORKED_6 VARCHAR2(8);
      V_DATE_RETURNED_6 VARCHAR2(8);
      V_DATE_LAST_WORKED_7 VARCHAR2(8);
      V_DATE_RETURNED_7 VARCHAR2(8);
      V_DATE_LAST_WORKED_8 VARCHAR2(8);
      V_DATE_RETURNED_8 VARCHAR2(8);
      V_DATE_LAST_WORKED_9 VARCHAR2(8);
      V_DATE_RETURNED_9 VARCHAR2(8);
      V_DATE_LAST_WORKED_10 VARCHAR2(8);
      V_DATE_RETURNED_10 VARCHAR2(8);
      V_DATE_LAST_WORKED_11 VARCHAR2(8);
      V_DATE_RETURNED_11 VARCHAR2(8);
      V_DATE_LAST_WORKED_12 VARCHAR2(8);
      V_DATE_RETURNED_12 VARCHAR2(8);
      V_DATE_LAST_WORKED_13 VARCHAR2(8);
      V_DATE_RETURNED_13 VARCHAR2(8);
      V_DATE_LAST_WORKED_14 VARCHAR2(8);
      V_DATE_RETURNED_14 VARCHAR2(8);
      V_DATE_LAST_WORKED_15 VARCHAR2(8);
      V_DATE_RETURNED_15 VARCHAR2(8);
      V_LOST_WORK_FLAG VARCHAR2(1);
      V_LEN_OF_SVC_DAYS VARCHAR2(1);
      V_EXEMPT_STATUS_FLAG VARCHAR2(1);
      V_NO_OF_EXEMPTIONS VARCHAR2(1);
      V_WORK_SUN_FLAG VARCHAR2(1);
      V_WORK_MON_FLAG VARCHAR2(1);
      V_WORK_TUE_FLAG VARCHAR2(1);
      V_WORK_WED_FLAG VARCHAR2(1);
      V_WORK_THU_FLAG VARCHAR2(1);
      V_WORK_FRI_FLAG VARCHAR2(1);
      V_WORK_SAT_FLAG VARCHAR2(1);
      V_WORKDAY_START_TIME VARCHAR2(6);
      V_WORK_PERMIT_DATE VARCHAR2(8);
      V_WORK_PERMIT_NUMBER VARCHAR2(50);
      V_REGULAR_JOB_FLAG VARCHAR2(1);
      V_HIRED_IN_STATE_FLAG VARCHAR2(1);
      V_NUM_OF_VIOLATION NUMBER;
      V_DESC_BY_WITNESS CLOB;
      V_USER_FIELD_A CLOB;
      V_USER_FIELD_B VARCHAR2(255);
      V_USER_FIELD_C VARCHAR2(255);
      V_USER_FIELD_D VARCHAR2(255);
      V_USER_FIELD_E VARCHAR2(255);
      V_USER_FIELD_F VARCHAR2(255);
      V_USER_FIELD_G VARCHAR2(255);
      V_USER_FIELD_H VARCHAR2(255);
      V_USER_FIELD_I VARCHAR2(255);
      V_USER_FIELD_J VARCHAR2(255);
      V_USER_FIELD_K VARCHAR2(255);
      V_USER_FIELD_L VARCHAR2(255);
      V_USER_FIELD_M VARCHAR2(255);
      V_USER_FIELD_N VARCHAR2(255);
      V_USER_FIELD_O VARCHAR2(255);
      V_USER_FIELD_P VARCHAR2(255);
      V_USER_FIELD_Q VARCHAR2(255);
      V_USER_FIELD_R VARCHAR2(255);
      V_USER_FIELD_S VARCHAR2(255);
      V_USER_FIELD_T VARCHAR2(255);
      V_USER_FIELD_U VARCHAR2(255);
      V_USER_FIELD_V VARCHAR2(255);
      V_USER_FIELD_W VARCHAR2(255);
      V_USER_FIELD_X VARCHAR2(255);
      V_USER_FIELD_Y VARCHAR2(255);
      V_COND_PRIOR_CODE VARCHAR2(25);
      V_RAIL_POSITION_CODE VARCHAR2(25);
      V_RESTRAINT_CODE VARCHAR2(25);
      V_BED_POSITION_CODE VARCHAR2(25);
      V_CALL_LIGHT_CODE VARCHAR2(25);
      V_REPORTED_COUNTRY VARCHAR2(25);
      V_REPORTED_PHONE2 VARCHAR2(30);
      V_REPORTED_FAX VARCHAR2(255);
      V_PI_MIDDLE_NAME VARCHAR2(255);
      V_PRIVACY_CASE_FLAG VARCHAR2(1);
      V_SHARPS_OBJECT VARCHAR2(25);
      V_SHARPS_BRAND_MAKE VARCHAR2(25);
      V_SAFEG_PROVIDED VARCHAR2(1);
      V_RULES_NOT_FOLLOWED VARCHAR2(1);
      V_OSHA_ESTAB_EID VARCHAR2(25);
      V_NAME_TYPE VARCHAR2(25);
      V_LINE_OF_BUS_CODE NUMBER;  Abhishek: These variables are never used.*/

      V_ERROR_MSG VARCHAR2(2000);


    v_TIME_OF_EVENT_INVALID NUMBER;
    v_TIME_REPORTED_INVALID NUMBER;
    V_DATE_REPORTED_INVALID NUMBER ;
    V_DATE_OF_EVENT_INVALID NUMBER;
    V_DATE_OF_DEATH_INVALID NUMBER := 0;
    V_DATE_HIRED_INVALID NUMBER := 0;
    --vTableToProcess varchar2(255);

    VENTITY_TYPE  DDS_ENTITY_TYPE; -- KAPIL
    v_DDS_ORG_HIERARCHY_TYPE    DDS_ORG_HIERARCHY_TYPE;
    iEntId NUMBER;
    i_Reporter_ENTITY_ID_GEN NUMBER;
    v_Forcecreate NUMBER(10,0);
    --V_CHK_BIRTHDATE VARCHAR2(20);   Abhishek: This variable is never used.
    v_vColToProcess1 VARCHAR2(255):=0 ;
    v_vColToProcess2 VARCHAR2(500):=0 ;
    v_vVal4 VARCHAR2(255);
    v_i_CheckNext NUMBER:=0;
   /*v_v_TIME_OF_EVENT_INVALID NUMBER(10,0);
   v_v_TIME_REPORTED_INVALID NUMBER(10,0);
   v_V_DATE_REPORTED_INVALID NUMBER(10,0);
   v_V_DATE_OF_EVENT_INVALID NUMBER(10,0);Abhishek: These variables are never used.*/
   v_vTableToProcess VARCHAR2(255);
   v_i_EMPLOYEE_EID NUMBER(10,0);
   v_i_EVENT_ID_O NUMBER(10,0);
   v_i_PI_ROW_ID_OP NUMBER(10,0);
   v_i_Phys_EID_O NUMBER(10,0);
   v_i_PATIENT_EID NUMBER(10,0);
   v_i_EMPLOYEE_EID_UPDATE NUMBER(10,0) := 0 ;
   v_i_EMPLOYEE_EID_EN NUMBER(10,0);
   v_P_SUPP_ERROR_COUNT_R NUMBER(10,0);
   V_CONFIG_ID NUMBER;
   V_USER_ID NUMBER;
   v_EVENT_SUPP number;
   v_VALID_END_DATE VARCHAR2(8);
   v_VALID_START_DATE VARCHAR2(8);
   v_i_NOTHING NUMBER;
   v_vValue VARCHAR2(100);
   --v_V_ERROR_LOCATION_MAIN VARCHAR2(255); Abhishek: This variable is never used.
   v_iRoleTableid NUMBER(10,0):=0 ;
   v_i_DELETED_FLAG NUMBER(10,0):=0 ;
   v_iEidForDept  NUMBER(10,0):=0 ;
   v_iNoError NUMBER(10,0):=0 ;
   v_ErrorColumn  VARCHAR2(255);
  v_iSuperVisorError  NUMBER(10,0):=0 ;
  --v_iRptdTidErr  NUMBER(10,0):=0 ; Abhishek: This variable is never used.
  v_iPiTidErr NUMBER(10,0):=0 ;
  v_iSvTidErr NUMBER(10,0):=0 ;
  V_V_ERROR_COLUMN_EVENT VARCHAR2(255):= 0 ;
   v_V_ERROR_MESSAGE  VARCHAR2(255) ;
V_iEroleFlag NUMBER(10,0):=0 ;
l_CURSOR sys_refcursor;
V_SQL CLOB;
V_ERROR_LOCATION VARCHAR2(100);
i_iRptdTidErr NUMBER(10,0):=0 ;
i_iPiTidErr NUMBER(10,0):=0 ;
i_iSvTidErr NUMBER(10,0):=0 ;
v_GETDate  NUMBER(10,0):=0 ;
--i_DELETED_FLAG NUMBER(10,0):=0 ; Abhishek: This variable is never used.
V_DURATION NUMBER(10,0):=0 ;
iRptdTidErr NUMBER(10,0):=0 ;
v_HIRED_IN_STATE_FLAG_GEN NUMBER(10,0):=0;
v_vBENEFICIARY_CODE_ID NUMBER(10,0):= 0;     --JIRA 24634 knakra
v_iHmiFlag NUMBER(10,0) := 0;         --JIRA 24634 knakra
  ---neha 33658 -- START 
  v_iRunStatCnt NUMBER(10, 0) := 1;
  v_iRunCnt     NUMBER(10, 0) := 1;
  v_vProcessMsg varchar2(4000);
  v_iTotCount      NUMBER(10, 0) := 0;
  v_FormatedTaxid           VARCHAR2(11) := NULL;
  ---neha 33658 -- end 

BEGIN -- START EXECUTION OF THIS PROCEDURE

--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_VALIDATE_EVENT PROCEDURE STARTS ************************************************************************
--*************************************************************************************************************************************************************                                                                             ****

  --    Declaration of  OptionSet Variables, Event Record Variables, CODE_ID Variables, Other Local Variables                                              ****
  --  `  Fetching values from DDS_OPTIONSET Table from Staging                                                 ****
  --    Fetching carrier flag, date of loss settings, entity role settings from RISKMASTER                                   ****
  --    Total Rows from DDS_EVENT corresponding to current JOBID                                               ****
  --    Cursor declaration, start to fetch values from DDS_EVENT Staging Table                                         ****
  --    Initialization of Variables to default values for each New Event Record

    -----****************** 1. EVENT VALIDATION STARTS ***************------------------
  --  REQUIRED FIELD VALIDATIONS, TAX_ID FIELDS VALIDATION,FLAG VALIDATION,CODE VALIDATION,DATE FORMAT VALIDATION,TIME FORMAT VALIDATION,DATE AND TIME VALIDATION,
  --  STATE VALIDATION   ,DISABILITY_CODE VALIDATION ,DEPARTMENT / DEPT_INVOLVED / OSHA_ESTAB_EID COMBINED /DEPT_ASSIGNED/FACILITY_DEPT,CREATE NEW DEPARMENT,
  --  REPORTER ENTITY (PROCESS ENTITY)
      -----****************** 1. EVENT VALIDATION ENDS ***************---------------------

    -----****************** 2.PERSON INVOLVED VALIDATION STARTS ***************----------
  --  CREATE_PI_ENT_IF_TAXID_EMPTY IF EID = 0 (PROCESS ENTITY) THEN PASS ERROR , Taxid error check,
  --  CrtNwEvntPiEntyIfTxIDEmpty,HOSPITAL AND PHYS_EID VALIDATION,
  --  PHYS_EID PROCESS ENTITY AND ERROR LOGGING ,WORK LOSS , PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR,
  --  CHECK EXISTENCE AND LOG ERROR IF EMPLOYEE NO. ATTACHED TO SOME OTHER ENTITY
  --  IF FLAG NULL GET VALUE FROM SYS_PARMS , DATA MANUPULATION STARTS ,IF FLAG Y/N SET  VALUES,
    --  RMDB Existence of Employee (@PI_TYPE_ENTITY_ID_GEN) TO LOG AN ERROR
    -----****************** 2.PERSON INVOLVED VALIDATION ENDS ***************------------

  -----****************** 3.EMPLOYEE VALIDATION ENDS ***************-------------------
  --   SUPERVISOR DOES NOT EXISTS AS AN EMP SO, INSERT /CREATE SUPERVISOR (ELSE IF IT EXISTS DO NOTHING)
  --   RMDB Existence of Employee
  --   Insert / Update Employee
    ----******************  3.EMPLOYEE VALIDATION ENDS ***************-------------------

    ----******************  4.Supplemental Validation call  ***************--------------

  --***********************************************************************************************************************
--*****If there is any Validation Error till now then Procedure will fetch NEXT record and will log errors corresponding to current record.         ****
  --***********************************************************************************************************************
                  ----------------------
                  --IMPORT PART STARTS--
                  ----------------------

    ----******************  5. IMPORT EVENT STARTS ***************-------------------
  --  IMPORT DATA MANUPULATION
    --  INSERT / UPDATE EVENT
    --  UPDATE REPORTER ENTITY IN ENTITY TABLE
  --  ACTION / OUTCOME EXISTENCE IN RMDB followed by Insert
    --  EVENT_X_OSHA|FALL_INDICATOR EXISTENCE IN RMDB  followed by Insert
    ----******************  5. IMPORT EVENT ENDS ***************-------------------

    ----******************  6. PERSON INVOLVED and its Related tables INSERT STARTS ***************-------------------
    --  RMDB EXISTENCE OF PERSON_INVOLVED
  --  TABLE INSERT STARTS  TABLE INSERT STARTS commom
  --  INSERT into PI table WHEN   PI_TYPE_CODE 'P'
  --  INSERT into PI table WHEN   PI_TYPE_CODE IS WITNESS
  --  INSERTION INTO RELATED TABLES AND PI WHEN PI TYPE IS P/E  : - PI_X_HOSPITAL|PI_X_PHYSICIAN ,
  --  INSERTION INTO PHYSICIAN WHEN   PI_TYPE_CODE IS 'PHYS'
  --  INSERTION INTO PATIENT AND PATIENT_RELATED TABLES  WHEN   PI_TYPE_CODE IS 'P'
    ----******************  6. PERSON INVOLVED and its Related tables INSERT ENDS ***************-------------------

    ----******************  7. PERSON INVOLVED and its Related tables COMMON STARTS ***************-------------------
   --   INSERT INTO PI when  PI_TYPE_CODE 'E'
   --  Existence Checked  and INSERT INTO PI_X_WORK_LOSS INSERT (because of above condition)
   --  Existence Checked  and INSERT INTO RLATED TABLES (because of above condition)( BODY_PART|DIAGNOSIS|TREATMENT|)
   --  Existence Checked  and INSERT INTO ILLNESS /INJURY INSERT (because of above condition)
    ----******************  7. PERSON INVOLVED and its Related tables COMMON  ENDS ***************-------------------

    ----******************  8. UPDATE PI DATA IN ENTITY  ***************-------------------

    ----******************  9. Supplemtal Insert Call STARTS  ***************-------------------
   --   Supplemtal Insert Call  FOR EVENT ONLY
   --   Supplemtal Insert Call FOR EMP
   --  Supplemtal Insert Call FOR PATIENT
    ----******************  9. Supplemtal Insert Call ENDS  ***************-------------------


--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_VALIDATE_EVENT PROCEDURE ENDS ************************************************************************
--*************************************************************************************************************************************************************                                                                             ****



      IF P_DBName IS NOT NULL THEN
         V_DBName := p_DBName || '.';
      END IF;

-- Storing Values from Optionset variables
   BEGIN
     V_ERROR_LOCATION := 1;
      SELECT ALLOW_NEW_CODES,
                 ALLOW_NEW_EMPLOYEES,
                 ALLOW_NEW_DEPARTMENT,
                 EMPLOYEE_MATCH_BY_NAME,
                 EMPLOYEE_MATCH_BY_TAX_ID,
                 EMPLOYEE_MATCH_BY_EMP_NUM,
                 NON_EMP_MATCH_BY_NAME,
                 NON_EMP_MATCH_BY_TAX_ID,
                 NON_EMP_MATCH_BY_NAME_TAX_ID,
                 CREATE_PI_ENT_IF_TAXID_EMPTY,
                 CONFIG_ID,
                 event_supp,
                 VALID_END_DATE,
                 VALID_START_DATE, --,USER_ID
                 EMPLOYEE_MATCH_BY_DOB, --JIRA 24634 knakra
                 NON_EMP_MATCH_BY_DOB   --JIRA 24634 knakra
            INTO v_CheckCreateNewCodes,
             v_CheckCreateNewEmployees,
             v_CheckCreateNewDEPARTMENT,
             v_EmployeeMatchByName,
             v_EmployeeMatchByTaxId,
             v_EmployeeMatchByEmpNumber,
             v_NonEmployeeMatchByName,
             v_NonEmployeeMatchByTaxId,
             v_NonEmployeeMatchByNameTaxId,
             v_CrtNwEvntPiEntyIfTxIDEmpty,
             V_CONFIG_ID,
             v_EVENT_SUPP ,
             v_VALID_END_DATE ,
             v_VALID_START_DATE,
             v_EmpMatchByDob, --JIRA 24634 knakra
             v_NonEmpMatchByDob      --JIRA 24634 knakra
        --@@V_ORGSEC_FLAG needs to get from UI
        FROM DDS_OPTIONSET
         WHERE JOBID = p_jobID;

      v_I_ERRORCOUNT := 0;
      v_I_ROWCOUNT := 0;
      V_MODULENAME := 'EVENT';
      V_PROCNAME := 'DDS_VALIDATE_EVENT';
      v_I_COUNT := 0;
      i_Reporter_ENTITY_ID_GEN  := 0 ;
      v_TIME_OF_EVENT_INVALID :=  0 ;
      v_TIME_REPORTED_INVALID := 0 ;
      V_DATE_REPORTED_INVALID := 0 ;
      V_DATE_OF_EVENT_INVALID := 0 ;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL; -- NEED TO CALL ERROR LOG PROCEDURE AND EXIT FROM THERE.
     END;
     
   BEGIN --Neha Running status starts 33658
  SELECT COUNT(DA_ROW_ID) INTO v_iTotCount FROM DDS_EVENT WHERE JOBID = p_jobID AND INVALID_ROW=1; 
   exception
    when no_data_found then
      null; 
  END; --Neha Running status ends 33658
     --JIRA 24634 knakra starts
     V_SQL := 'SELECT C.CODE_ID FROM ' || V_DBName || 'CODES C INNER JOIN ' || V_DBName || 'GLOSSARY G ON C.TABLE_ID = G.TABLE_ID';
     V_SQL := V_SQL || ' WHERE C.SHORT_CODE = ''HC'' AND G.SYSTEM_TABLE_NAME = ''LINE_OF_BUSINESS''';
     
     BEGIN
           EXECUTE IMMEDIATE V_SQL INTO v_iHmiFlag;
     EXCEPTION
           WHEN NO_DATA_FOUND THEN
                v_iHmiFlag := 0;
     END;
     IF  v_iHmiFlag IS NOT NULL AND v_iHmiFlag > 0 THEN
         v_iHmiFlag := 1;
     END IF;
     --JIRA 24634 knakra ends

   FOR DDS_EVENT_CUR IN
     (SELECT JOBID,
      DA_ROW_ID,
      INVALID_ROW,
      UPDATE_ROW,
      EVENT_NUMBER,
      EVENT_TYPE_CODE,
      EVENT_STATUS_CODE,
      EVENT_IND_CODE,
      EVENT_DESCRIPTION,
      BRIEF_DESCRIPTION,
      DEPARTMENT,
      DEPT_INVOLVED,
      ADDR1,
      ADDR2,
      CITY,
      STATE,
      ZIP_CODE,
      COUNTRY,
      COUNTY_OF_INJURY,
      LOCATION_AREA_DESC,
      PRIMARY_LOC_CODE,
      LOCATION_TYPE_CODE,
      ON_PREMISE_FLAG,
      NO_OF_INJURIES,
      NO_OF_FATALITIES,
      CAUSE_CODE,
      DATE_OF_EVENT,
      TIME_OF_EVENT,
      DATE_REPORTED,
      TIME_REPORTED,
      REPORTED_TAX_ID,
      REPORTED_LAST_NAME,
      REPORTED_FIRST_NAME,
      REPORTED_ADDR1,
      REPORTED_ADDR2,
      REPORTED_CITY,
      REPORTED_STATE,
      REPORTED_ZIP_CODE,
      REPORTED_PHONE,
      COMMENTS,
      ACTIVITY_WHEN_INJ,
      HOW_ACC_OCCURRED,
      OBJ_SUBST_THAT_INJ,
      RECORDABLE_FLAG,
      SAFEG_NOTUSED_FLAG,
      SAFEGUARD_FLAG,
      NO_RULES_FLAG,
      DATE_PHYS_ADVISED,
      TIME_PHYS_ADVISED,
      ACTION_1_CODE,
      ACTION_2_CODE,
      ACTION_3_CODE,
      ACTION_4_CODE,
      ACTION_5_CODE,
      OUTCOME_1_CODE,
      OUTCOME_2_CODE,
      OUTCOME_3_CODE,
      OUTCOME_4_CODE,
      OUTCOME_5_CODE,
      DATE_TO_FOLLOW_UP,
      TREATMENT_GIVEN,
      RELEASE_SIGNED,
      DEPT_HEAD_ADVISED,
      PHYS_NOTES,
      DATE_CARRIER_NOTIF,
      PI_SUFFIX,
      PI_TAX_ID,
      PI_LAST_NAME,
      PI_FIRST_NAME,
      PI_ADDR1,
      PI_ADDR2,
      PI_CITY,
      PI_STATE,
      PI_ZIP_CODE,
      PI_PHONE,
      PI_TYPE_CODE,
      MARITAL_STAT_CODE,
      SEX_CODE,
      BIRTH_DATE,
      DATE_OF_DEATH,
      ILLNESS_CODE,
      INJURY_1_CODE,
      INJURY_2_CODE,
      INJURY_3_CODE,
      INJURY_4_CODE,
      INJURY_5_CODE,
      BODY_PART_1_CODE,
      BODY_PART_2_CODE,
      BODY_PART_3_CODE,
      BODY_PART_4_CODE,
      BODY_PART_5_CODE,
      DIAGNOSIS_1_CODE,
      DIAGNOSIS_2_CODE,
      DIAGNOSIS_3_CODE,
      DIAGNOSIS_4_CODE,
      DIAGNOSIS_5_CODE,
      TREATMENT_1_CODE,
      TREATMENT_2_CODE,
      TREATMENT_3_CODE,
      TREATMENT_4_CODE,
      TREATMENT_5_CODE,
      PHYSICIAN_1_LAST_NAME,
      PHYSICIAN_1_FIRST_NAME,
      PHYSICIAN_1_PHONE,
      PHYSICIAN_2_LAST_NAME,
      PHYSICIAN_2_FIRST_NAME,
      PHYSICIAN_2_PHONE,
      PHYSICIAN_3_LAST_NAME,
      PHYSICIAN_3_FIRST_NAME,
      PHYSICIAN_3_PHONE,
      HOSPITAL_1_NAME,
      HOSPITAL_1_PHONE,
      HOSPITAL_2_NAME,
      HOSPITAL_2_PHONE,
      HOSPITAL_3_NAME,
      HOSPITAL_3_PHONE,
      DRIVERS_LIC_NO,
      DRIVERSLICTYPECODE,
      DATE_DRIVERSLICEXP,
      DRIVLIC_RSTRCT_CODE,
      DRIVLIC_STATE,
      COUNTY_OF_RESIDNC,
      NCCI_CLASS_CODE,
      EST_LEN_DISABILITY,
      INSURABLE_FLAG,
      LAST_VERIFIED_DATE,
      PATIENT_ACCT_NO,
      MEDICAL_RCD_NO,
      INS_PLAN_GROUP_NO,
      DATE_OF_ADMISSION,
      DATE_OF_DISCHARGE,
      ADM_TYPE_CODE,
      ADM_SOURCE_CODE,
      ADMISSION_REASON,
      ACUITY_LEVEL_CODE,
      PATIENT_STAT_CODE,
      PATIENT_COND_CODE,
      DISCHARGE_DSP_CODE,
      EXP_LENGTH_OF_STAY,
      EXPECTED_COST,
      QI_SIGNIF_CODE,
      EPISODE_OF_CARE_ID,
      PATIENT_TYPE_CODE,
      WEIGHT,
      EMERGENCY_CONTACT,
      EMERGENCY_CONT_NO,
      PATIENT_ROOM_NO,
      FACILITY_UNIT_CODE,
      FACILITY_DEPT,
      HCO_ID_NO,
      HCO_SITE_ID_NO,
      WHY_AT_FACILITY,
      DISABILITY_CODE,
      EMPLOYEE_NUMBER,
      POSITION_CODE,
      DEPT_ASSIGNED,
      SUPER_TAX_ID,
      SUPER_EMP_NO,
      SUPER_LAST_NAME,
      SUPER_FIRST_NAME,
      SUPER_ADDR1,
      SUPER_ADDR2,
      SUPER_CITY,
      SUPER_STATE,
      SUPER_ZIP_CODE,
      SUPER_PHONE1,
      FULL_TIME_FLAG,
      PAY_TYPE_CODE,
      HOURLY_RATE,
      WEEKLY_HOURS,
      WEEKLY_RATE,
      PAY_AMOUNT,
      ACTIVE_FLAG,
      DATE_HIRED,
      DATE_LAST_WORKED_1,
      DATE_RETURNED_1,
      DATE_LAST_WORKED_2,
      DATE_RETURNED_2,
      DATE_LAST_WORKED_3,
      DATE_RETURNED_3,
      DATE_LAST_WORKED_4,
      DATE_RETURNED_4,
      DATE_LAST_WORKED_5,
      DATE_RETURNED_5,
      DATE_LAST_WORKED_6,
      DATE_RETURNED_6,
      DATE_LAST_WORKED_7,
      DATE_RETURNED_7,
      DATE_LAST_WORKED_8,
      DATE_RETURNED_8,
      DATE_LAST_WORKED_9,
      DATE_RETURNED_9,
      DATE_LAST_WORKED_10,
      DATE_RETURNED_10,
      DATE_LAST_WORKED_11,
      DATE_RETURNED_11,
      DATE_LAST_WORKED_12,
      DATE_RETURNED_12,
      DATE_LAST_WORKED_13,
      DATE_RETURNED_13,
      DATE_LAST_WORKED_14,
      DATE_RETURNED_14,
      DATE_LAST_WORKED_15,
      DATE_RETURNED_15,
      LOST_WORK_FLAG,
      LEN_OF_SVC_DAYS,
      EXEMPT_STATUS_FLAG,
      NO_OF_EXEMPTIONS,
      WORK_SUN_FLAG,
      WORK_MON_FLAG,
      WORK_TUE_FLAG,
      WORK_WED_FLAG,
      WORK_THU_FLAG,
      WORK_FRI_FLAG,
      WORK_SAT_FLAG,
      WORKDAY_START_TIME,
      WORK_PERMIT_DATE,
      WORK_PERMIT_NUMBER,
      REGULAR_JOB_FLAG,
      HIRED_IN_STATE_FLAG,
      NUM_OF_VIOLATION,
      DESC_BY_WITNESS,
      COND_PRIOR_CODE,
      RAIL_POSITION_CODE,
      RESTRAINT_CODE,
      BED_POSITION_CODE,
      CALL_LIGHT_CODE,
      REPORTED_COUNTRY,
      REPORTED_PHONE2,
      REPORTED_FAX,
      PI_MIDDLE_NAME,
      PRIVACY_CASE_FLAG,
      SHARPS_OBJECT,
      SHARPS_BRAND_MAKE,
      SAFEG_PROVIDED,
      RULES_NOT_FOLLOWED,
      OSHA_ESTAB_EID,
      NAME_TYPE,  --commented by neha 02/26
      REPORTED_BIRTH_DT,      --JIRA 24634 knakra
      BENEFICIARY_CODE        --JIRA 24634 knakra
     -- LINE_OF_BUS_CODE   commented by neha 02/26
        FROM DDS_EVENT
         WHERE JOBID = p_jobID
        AND INVALID_ROW = 1)
   LOOP
  BEGIN
   v_I_ERRORCOUNT := 0;
         v_I_ROWCOUNT := 0;
         v_I_COUNT := 0;
         v_I_STATEID_GEN := 0;
         v_i_DEPARTMENT_GEN := 0;
         v_i_DEPT_INVOLVED_GEN := 0;
         v_i_DEPT_ASSIGNED_GEN := 0;
         v_i_FACILITY_DEPT_GEN := 0;
         v_i_OSHA_ESTAB_EID_GEN := 0;
         v_i_PI_ROW_ID := 0;
         v_i_ENTITY_ID := 0;
         v_i_EVENT_ID := 0;
         v_i_PATIENT_ID_GEN := 0;
         v_i_PI_TYPE_ENTITY_ID_GEN := 0;
         v_i_SUPERVISOR_ENTITY_ID_GEN := 0;
         v_i_PRI_PHYSICIAN_EID_GEN := 0;
         v_i_ADM_PHYSICIAN_EID_GEN := 0;
         v_vColName1 := NULL;
         v_vColName2 := NULL;
         v_vColName3 := NULL;
         v_vVal2 := NULL;
         v_vColName4 := NULL;
         v_vVal3 := NULL;
         v_i_HOSPITAL_1_EID := 0;
         v_i_HOSPITAL_2_EID := 0;
         v_i_HOSPITAL_3_EID := 0;
         v_i_PHYSICIAN_1_EID := 0;
         v_i_PHYSICIAN_2_EID := 0;
         v_i_PHYSICIAN_3_EID := 0;
         V_ERROR_MESSAGE := NULL;
         i_Reporter_ENTITY_ID_GEN := 0;
         v_STATE_R := 0;
         v_REPORTED_STATE_R := 0;
         v_PI_STATE_R := 0;
         v_DRIVLIC_STATE_R := 0;
         v_SUPER_STATE_R := 0;
         v_STATE_ROW_ID_R := 0;
         v_i_PI_WL_ROW_ID := 0;
         v_vColToProcess2 := NULL;
         v_iCount2 := 0;
         v_iCodeId := 0;
         --v_v_TIME_OF_EVENT_INVALID := 0;
         --v_v_TIME_REPORTED_INVALID := 0;
         --v_V_DATE_REPORTED_INVALID := 0;
         --v_V_DATE_OF_EVENT_INVALID := 0;
         v_vTableToProcess := NULL;
         v_i_EMPLOYEE_EID := 0;
         v_i_EVENT_ID_O := 0;
         v_i_PI_ROW_ID_OP := 0;
         v_i_Phys_EID_O := 0;
         v_i_PATIENT_EID := 0;
         v_i_EMPLOYEE_EID_UPDATE := 0;
         v_i_EMPLOYEE_EID_EN := 0;
         V_DTTM_RCD_ADDED_GEN := NULL;
         V_DTTM_RCD_LAST_UPD_GEN := NULL;
         V_UPDATED_BY_USER := NULL;
         V_ADDED_BY_USER := NULL;
         V_NEXT_UNIQUE_ID := 0;
         v_N_SQL_EVENT := NULL;
         V_ORGSEC_FLAG := 0;
         V_SEC_DEPT_EID := 0;
         v_vReqColumns := NULL;
         v_vCodeFieldList := NULL;
         v_vSysTableNameList := NULL;
         v_iPos := 0;
         v_vColName := NULL;
         v_nSql := NULL;
         v_vColList := NULL;
         v_iCount := 0;
         v_vVal := NULL;
         v_vTableList := NULL;
         v_vTableName := NULL;
         v_vColToProcess := NULL;
         v_vTab := NULL;
         v_vTabToProcess := NULL;
         v_vColInRM := NULL;
         v_vColName_value := 0;
         v_I_ON_PREMISE_FLAG_GEN := 0;
         v_I_NO_RULES_FLAG_GEN := 0;
         v_I_RECORDABLE_FLAG_GEN := 0;
         v_I_SAFEG_NOTUSED_GEN := 0;
         v_I_SAFEGUARD_FLAG_GEN := 0;
         v_I_PRIVACY_CASE_GEN := 0;
         v_WORK_SUN_FLAG_GEN := 0;
         v_WORK_MON_FLAG_GEN := 0;
         v_WORK_TUE_FLAG_GEN := 0;
         v_WORK_WED_FLAG_GEN := 0;
         v_WORK_THU_FLAG_GEN := 0;
         v_WORK_FRI_FLAG_GEN := 0;
         v_WORK_SAT_FLAG_GEN := 0;
         v_FULL_TIME_FLAG_GEN := 0;
         v_ACTIVE_FLAG_GEN := 0;
         v_EXEMPT_STATUS_FLAG_GEN := 0;
         v_INSURABLE_FLAG_GEN := 0;
         v_REGULAR_JOB_FLAG_GEN := 0;
         v_HIRED_IN_STATE_FLAG_GEN  := 0 ;
         v_LOST_WORK_FLAG_GEN := 0;
         v_P_SUPP_ERROR_COUNT_R := 0;
         v_vVal4 := 0;
         v_i_CheckNext := 0;
          V_DURATION := 0;
         v_vColToProcess1 := 0;
         v_iROW_ID := 0 ;
         v_vBENEFICIARY_CODE_ID := 0;  --JIRA 24634 knakra
   BEGIN-- REQUIRED FIELDS VALIDATION STARTS
      V_ERROR_LOCATION := 2;
      V_USER_ID:=P_USER_ID;

      v_vReqColumns := 'EVENT_NUMBER|EVENT_TYPE_CODE|DATE_OF_EVENT|TIME_OF_EVENT|EVENT_STATUS_CODE';
      v_vReqColumns := v_vReqColumns || '|DEPARTMENT|DATE_REPORTED|TIME_REPORTED|EVENT_IND_CODE';

       IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL   AND UPPER (DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' THEN
         v_vReqColumns := v_vReqColumns || '|DEPT_ASSIGNED|EMPLOYEE_NUMBER' ;
      END IF ;           -- mkaur24 reverted the change. We have a default value in v_vReqColumns so removing end if  from here and moving to line 923 will create an issue when lastname is null.

        V_SQL :=' select regexp_substr('||''''||v_vReqColumns||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
          connect by regexp_substr('||''''||v_vReqColumns||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';

         OPEN l_CURSOR FOR V_SQL;
          LOOP
            FETCH l_CURSOR INTO v_vVal ;
            EXIT WHEN l_CURSOR%NOTFOUND;
             V_ERROR_LOCATION := 3;
             v_vVal2 := (CASE
                            WHEN v_vVal = 'EVENT_NUMBER' THEN DDS_EVENT_CUR.EVENT_NUMBER
                            WHEN v_vVal = 'EVENT_TYPE_CODE' THEN DDS_EVENT_CUR.EVENT_TYPE_CODE
                            WHEN v_vVal = 'DATE_OF_EVENT' THEN DDS_EVENT_CUR.DATE_OF_EVENT
                            WHEN v_vVal = 'TIME_OF_EVENT' THEN DDS_EVENT_CUR.TIME_OF_EVENT
                            WHEN v_vVal = 'EVENT_STATUS_CODE' THEN DDS_EVENT_CUR.EVENT_STATUS_CODE
                            WHEN v_vVal = 'DEPARTMENT' THEN DDS_EVENT_CUR.DEPARTMENT
                            WHEN v_vVal = 'DATE_REPORTED' THEN DDS_EVENT_CUR.DATE_REPORTED
                            WHEN v_vVal = 'TIME_REPORTED' THEN DDS_EVENT_CUR.TIME_REPORTED
                            WHEN v_vVal = 'EVENT_IND_CODE' THEN DDS_EVENT_CUR.EVENT_IND_CODE
                             WHEN v_vVal = 'DEPT_ASSIGNED' THEN DDS_EVENT_CUR.DEPT_ASSIGNED
                            WHEN v_vVal = 'EMPLOYEE_NUMBER' THEN DDS_EVENT_CUR.EMPLOYEE_NUMBER
                         END);
                 IF v_vVal2 IS NULL --OR v_vVal2 = '' --Abhishek: Commenting comparision of the blank, Reason we can't use null with comparision operators.
                 THEN
                                                            -- Kapil are you providing blank or space ? if it only null then it can be handled
                                                           -- otherwise if its space then second condition is not having a space then it will got failed.
                    V_ERROR_LOCATION := 4;
                     DDS_ERROR_LOG_CAPTURE(P_JOBID,
                                         DDS_EVENT_CUR.DA_ROW_ID,
                                         V_MODULENAME,
                                         V_ERROR_LOCATION,
                                         'REQVD',
                                         V_PROCNAME,
                                         'Required Fields are Null or Empty.Please provide a valid value.',
                                         v_vVal,
                                         'DDS_EVENT',
                                         'EVENT_NUMBER',
                                         DDS_EVENT_CUR.EVENT_NUMBER,
                                         1);
                      v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                 END IF;
            END LOOP;
          CLOSE   l_CURSOR;
   --   END IF ;          mkaur24   reverting the change . It is creating an issue as stated above.
       -- Abhishek: cursor and its execution are moved into if block
       -- kapil take below complete cursor and its execution into if block
       -- reason if v_vColList is null then it is useless to assign below variable.

   END; -- REQUIRED FIELDS VALIDATION ENDS

   BEGIN --  PHONE FIELDS VALIDATION STARTS

      V_ERROR_LOCATION := 3.1 ;

      v_vColList := 'REPORTED_PHONE|REPORTED_PHONE2';


       IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL  THEN --      AND ( DDS_EVENT_CUR.PI_LAST_NAME <> '')
           v_vColList := v_vColList || '|PI_PHONE|SUPER_PHONE1|PHYSICIAN_1_PHONE|PHYSICIAN_2_PHONE|PHYSICIAN_3_PHONE' ;
           v_vColList := v_vColList || '|HOSPITAL_1_PHONE|HOSPITAL_2_PHONE|HOSPITAL_3_PHONE' ;
       END IF  ;         -- mkaur24 reverted the change. We have a default value in v_vReqColumns so removing end if  from here and moving to line 985 will create an issue when lastname is null.

        V_SQL :=' select regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
          connect by regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
         OPEN l_CURSOR FOR V_SQL;
          LOOP
            FETCH l_CURSOR INTO v_vVal ;
            EXIT WHEN l_CURSOR%NOTFOUND;
             V_ERROR_LOCATION := 3;
             v_vVal2 := (CASE
                            WHEN v_vVal = 'REPORTED_PHONE' THEN DDS_EVENT_CUR.REPORTED_PHONE
                            WHEN v_vVal = 'REPORTED_PHONE2' THEN DDS_EVENT_CUR.REPORTED_PHONE2
                            WHEN v_vVal = 'SUPER_PHONE1' THEN DDS_EVENT_CUR.SUPER_PHONE1
                            WHEN v_vVal = 'PHYSICIAN_1_PHONE' THEN DDS_EVENT_CUR.PHYSICIAN_1_PHONE
                            WHEN v_vVal = 'PHYSICIAN_2_PHONE' THEN DDS_EVENT_CUR.PHYSICIAN_2_PHONE
                            WHEN v_vVal = 'PHYSICIAN_3_PHONE' THEN DDS_EVENT_CUR.PHYSICIAN_3_PHONE
                            WHEN v_vVal = 'HOSPITAL_1_PHONE' THEN DDS_EVENT_CUR.HOSPITAL_1_PHONE
                            WHEN v_vVal = 'HOSPITAL_2_PHONE' THEN DDS_EVENT_CUR.HOSPITAL_2_PHONE
                            WHEN v_vVal = 'HOSPITAL_3_PHONE' THEN DDS_EVENT_CUR.HOSPITAL_3_PHONE
                         END);

                    IF v_vVal2 IS NOT NULL and LENGTH (v_vVal2) < 10
                    THEN

                    V_ERROR_LOCATION := 4.1;

                     DDS_ERROR_LOG_CAPTURE(P_JOBID,
                                         DDS_EVENT_CUR.DA_ROW_ID,
                                         V_MODULENAME,
                                         V_ERROR_LOCATION,
                                         'PHONVD',
                                         V_PROCNAME,
                                         'Please provide a valid phone number.', -- Abhishek: done. Kapil phone no should be phone number
                                         v_vVal,
                                         'DDS_EVENT',
                                         'EVENT_NUMBER',
                                         DDS_EVENT_CUR.EVENT_NUMBER,
                                         1);
                      v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                   END IF;
                 --END IF;

            END LOOP;
          CLOSE   l_CURSOR;

    --   END IF  ;   mkaur24 everting the chnage not required.
       -- Abhishek: cursor and its execution are moved into if block
       -- kapil take below complete cursor and its execution into if block
       -- reason if v_vColList is null then it is useless to assign below variable.



   END; -- PHONE FIELDS VALIDATION STARTS

   BEGIN --  TAX_ID FIELDS VALIDATION STARTS

      V_ERROR_LOCATION := 3.2 ;

      v_vColList := 'REPORTED_TAX_ID';

      -- IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL AND ( DDS_EVENT_CUR.PI_LAST_NAME <> '') THEN --mkaur24
      IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL  THEN --neha
          v_vColList := v_vColList || '|PI_TAX_ID|SUPER_TAX_ID';
       END IF    ;          -- mkaur24 reverted the change. We have a default value in v_vReqColumns so removing end if  from here and moving to line 985 will create an issue when lastname is null.

        V_SQL :=' select regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
          connect by regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
         OPEN l_CURSOR FOR V_SQL;
          LOOP
            FETCH l_CURSOR INTO v_vVal ;
            EXIT WHEN l_CURSOR%NOTFOUND;
             V_ERROR_LOCATION := 3;
             v_vVal2 := (CASE
                            WHEN v_vVal = 'REPORTED_TAX_ID' THEN DDS_EVENT_CUR.REPORTED_TAX_ID
                            WHEN v_vVal = 'PI_TAX_ID' THEN DDS_EVENT_CUR.PI_TAX_ID
                            WHEN v_vVal = 'SUPER_TAX_ID' THEN DDS_EVENT_CUR.SUPER_TAX_ID
                         END);
                 IF v_vVal2 IS NOT NULL  AND LENGTH (REPLACE(v_vVal2 ,'-','')) <> 9 --Abhishek: merging both if conditions.
                 THEN  --neha  --- Kapil below if condition can be merged with one .. i.e. like vval2 and length
                    V_ERROR_LOCATION := '4.3';

                     DDS_ERROR_LOG_CAPTURE(P_JOBID,
                                         DDS_EVENT_CUR.DA_ROW_ID,
                                         V_MODULENAME,
                                         V_ERROR_LOCATION,
                                         'TAXIDVD',
                                         V_PROCNAME,
                                         'Please provide a valid TAX_ID no.',
                                         v_vVal,
                                         'DDS_EVENT',
                                         'EVENT_NUMBER',
                                         DDS_EVENT_CUR.EVENT_NUMBER,
                                         1);
                      v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                      --knakra starts
                IF v_vVal = 'REPORTED_TAX_ID' THEN
                   i_iRptdTidErr := 1 ;
                END IF;
                 IF v_vVal  = 'PI_TAX_ID' THEN
                   i_iPiTidErr  := 1 ;
                   END IF;
                 IF v_vVal = 'SUPER_TAX_ID'THEN
                   i_iSvTidErr := 1 ;
                  END IF;

                END IF;
                 --END IF;
            END LOOP;
          CLOSE   l_CURSOR;

      -- END IF    ;     mkaur24 reverting the change.Not required.
       -- Abhishek: cursor and its execution are moved into if block
       -- kapil take below complete cursor and its execution into if block
       -- reason if v_vColList is null then it is useless to assign below variable.



   END; -- TAX_ID FIELDS VALIDATION  STARTS
        V_ERROR_LOCATION := 'Emk4.4';


   BEGIN -- FLAG VALIDATION STARTS
      v_vColList := 'WORK_SUN_FLAG|WORK_MON_FLAG|WORK_TUE_FLAG|WORK_WED_FLAG|WORK_THU_FLAG|WORK_FRI_FLAG|WORK_SAT_FLAG|FULL_TIME_FLAG';
      v_vColList := v_vColList || '|ACTIVE_FLAG|EXEMPT_STATUS_FLAG|INSURABLE_FLAG|REGULAR_JOB_FLAG|LOST_WORK_FLAG';
      v_vColList := v_vColList || '|ON_PREMISE_FLAG|NO_RULES_FLAG|RECORDABLE_FLAG|SAFEG_NOTUSED_FLAG|SAFEGUARD_FLAG|PRIVACY_CASE_FLAG|HIRED_IN_STATE_FLAG|TREATMENT_GIVEN|RELEASE_SIGNED|DEPT_HEAD_ADVISED';


      V_SQL :=' select regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
        connect by regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
       OPEN l_CURSOR FOR V_SQL;
       LOOP
       FETCH l_CURSOR INTO v_vColName ;
       EXIT WHEN l_CURSOR%NOTFOUND;
        v_vVal := (CASE
                            WHEN v_vColName = 'WORK_SUN_FLAG' THEN DDS_EVENT_CUR.WORK_SUN_FLAG
                            WHEN v_vColName = 'WORK_MON_FLAG' THEN DDS_EVENT_CUR.WORK_MON_FLAG
                            WHEN v_vColName = 'WORK_TUE_FLAG' THEN DDS_EVENT_CUR.WORK_TUE_FLAG
                            WHEN v_vColName = 'WORK_WED_FLAG' THEN DDS_EVENT_CUR.WORK_WED_FLAG
                            WHEN v_vColName = 'WORK_THU_FLAG' THEN DDS_EVENT_CUR.WORK_THU_FLAG
                            WHEN v_vColName = 'WORK_FRI_FLAG' THEN DDS_EVENT_CUR.WORK_FRI_FLAG
                            WHEN v_vColName = 'WORK_SAT_FLAG' THEN DDS_EVENT_CUR.WORK_SAT_FLAG
                            WHEN v_vColName = 'FULL_TIME_FLAG' THEN DDS_EVENT_CUR.FULL_TIME_FLAG
                            WHEN v_vColName = 'ACTIVE_FLAG' THEN DDS_EVENT_CUR.ACTIVE_FLAG
                            WHEN v_vColName = 'EXEMPT_STATUS_FLAG' THEN DDS_EVENT_CUR.EXEMPT_STATUS_FLAG
                            WHEN v_vColName = 'INSURABLE_FLAG' THEN DDS_EVENT_CUR.INSURABLE_FLAG
                            WHEN v_vColName = 'REGULAR_JOB_FLAG' THEN DDS_EVENT_CUR.REGULAR_JOB_FLAG
                            WHEN v_vColName = 'LOST_WORK_FLAG' THEN DDS_EVENT_CUR.LOST_WORK_FLAG
                            WHEN v_vColName = 'ON_PREMISE_FLAG' THEN DDS_EVENT_CUR.ON_PREMISE_FLAG
                            WHEN v_vColName = 'NO_RULES_FLAG' THEN DDS_EVENT_CUR.NO_RULES_FLAG
                            WHEN v_vColName = 'RECORDABLE_FLAG' THEN DDS_EVENT_CUR.RECORDABLE_FLAG
                            WHEN v_vColName = 'SAFEG_NOTUSED_FLAG' THEN DDS_EVENT_CUR.SAFEG_NOTUSED_FLAG
                            WHEN v_vColName = 'SAFEGUARD_FLAG' THEN DDS_EVENT_CUR.SAFEGUARD_FLAG
                            WHEN v_vColName = 'HIRED_IN_STATE_FLAG' THEN DDS_EVENT_CUR.HIRED_IN_STATE_FLAG
                            WHEN v_vColName = 'PRIVACY_CASE_FLAG' THEN DDS_EVENT_CUR.PRIVACY_CASE_FLAG
                            WHEN v_vColName = 'TREATMENT_GIVEN' THEN DDS_EVENT_CUR.TREATMENT_GIVEN
                            WHEN v_vColName = 'RELEASE_SIGNED' THEN DDS_EVENT_CUR.RELEASE_SIGNED
                            WHEN v_vColName = 'DEPT_HEAD_ADVISED' THEN DDS_EVENT_CUR.DEPT_HEAD_ADVISED  END);


            IF (( v_vVal IS NOT NULL)
              AND (( UPPER(v_vVal) <> 'Y')
              AND ( UPPER(v_vVal) <> 'N' ))) THEN
            --BEGIN -- Abhishek: Done. kapil remove begin and end
               V_ERROR_LOCATION := '4.2';  --added by neha
               --DBMS_OUTPUT.PUT_LINE('ENTERED');
               DDS_ERROR_LOG_CAPTURE(P_JOBID,
                                         DDS_EVENT_CUR.DA_ROW_ID,
                                         V_MODULENAME,
                                         V_ERROR_LOCATION,
                                         'REQVD',
                                         V_PROCNAME,
                                         'If providing value for flag column, acceptable value is either Y/N.', --Abhishek: Space given, space removed and set full stop.  kapil give space, remove space, give full stop
                                         V_vColName,
                                         'DDS_EVENT',
                                         'EVENT_NUMBER',
                                         DDS_EVENT_CUR.EVENT_NUMBER,
                                         1);
               v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
            --END;
            END IF;
       END LOOP;
       CLOSE   l_CURSOR;

   END; -- FLAG VALIDATION END
 V_ERROR_LOCATION := 'Emk4.5';

 BEGIN-- CODE VALIDATION STARTS
      --DBMS_OUTPUT.PUT_LINE('codevd');
      v_vCodeFieldList := 'EVENT_TYPE_CODE|EVENT_STATUS_CODE|EVENT_IND_CODE|LOCATION_TYPE_CODE|CAUSE_CODE|PRIMARY_LOC_CODE|ACTION_1_CODE|ACTION_2_CODE|ACTION_3_CODE|ACTION_4_CODE|ACTION_5_CODE|OUTCOME_1_CODE|OUTCOME_2_CODE|OUTCOME_3_CODE|OUTCOME_4_CODE|OUTCOME_5_CODE|';
      v_vCodeFieldList := v_vCodeFieldList || 'MARITAL_STAT_CODE|BODY_PART_1_CODE|BODY_PART_2_CODE|BODY_PART_3_CODE|BODY_PART_4_CODE|BODY_PART_5_CODE|DIAGNOSIS_1_CODE|DIAGNOSIS_2_CODE|DIAGNOSIS_3_CODE|DIAGNOSIS_4_CODE|DIAGNOSIS_5_CODE|';
      v_vCodeFieldList := v_vCodeFieldList || 'TREATMENT_1_CODE|TREATMENT_2_CODE|TREATMENT_3_CODE|TREATMENT_4_CODE|TREATMENT_5_CODE|DRIVERSLICTYPECODE|NCCI_CLASS_CODE|DRIVLIC_RSTRCT_CODE|ADM_TYPE_CODE|ADM_SOURCE_CODE|ACUITY_LEVEL_CODE|';
      v_vCodeFieldList := v_vCodeFieldList || 'PATIENT_STAT_CODE|PATIENT_COND_CODE|DISCHARGE_DSP_CODE|PATIENT_TYPE_CODE|FACILITY_UNIT_CODE|POSITION_CODE|PAY_TYPE_CODE|COND_PRIOR_CODE|RAIL_POSITION_CODE|RESTRAINT_CODE|BED_POSITION_CODE|SHARPS_BRAND_MAKE|SHARPS_OBJECT|SAFEG_PROVIDED|REPORTED_COUNTRY|COUNTRY|QI_SIGNIF_CODE|NAME_TYPE|';
      v_vCodeFieldList := v_vCodeFieldList || 'DISABILITY_CODE|RULES_NOT_FOLLOWED|CALL_LIGHT_CODE|SEX_CODE|';--code creation 0
      v_vCodeFieldList := v_vCodeFieldList || 'BENEFICIARY_CODE|'; --JIRA 24634 knakra

      v_vSysTableNameList := 'EVENT_TYPE|EVENT_STATUS|EVENT_INDICATOR|LOCATION_TYPE|CAUSE_CODE|PRIMARY_LOCATION|ACTION_CODE|ACTION_CODE|ACTION_CODE|ACTION_CODE|ACTION_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|';
      v_vSysTableNameList := v_vSysTableNameList || 'MARITAL_STATUS|BODY_PART|BODY_PART|BODY_PART|BODY_PART|BODY_PART|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|';
      v_vSysTableNameList := v_vSysTableNameList || 'TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|LICENSE_TYPE_CODE|NCCI_CLASS_CODE|LIC_RESTRICTION|ADMISSION_TYPE|ADMISSION_SOURCE|ACUITY_LEVEL|';
      v_vSysTableNameList := v_vSysTableNameList || 'PATIENT_STATUS|PATIENT_CONDITION|DISCHARGE_DISP|PATIENT_TYPE|FACILITY_UNIT|POSITIONS|PAY_TYPES|CONDITION_PRIOR|SIDE_RAIL_POSITION|RESTRAINTS|BED_POSITION_CODES|SHARPS_LOG_BRAND|SHAPRS_LOG_OBJECT|YES_NO|COUNTRY|COUNTRY|QI_SIGNIFICANCE|ENTITY_NAME_TYPE|';
      v_vSysTableNameList := v_vSysTableNameList || 'DISABILITY_CODE|YES_NO|YES_NO|SEX_CODE|';--code creation 0
      v_vSysTableNameList := v_vSysTableNameList || 'BENEFICIARY_CODE|';  --JIRA 24634 knakra

      IF DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL THEN

        IF (upper(DDS_EVENT_CUR.DISABILITY_CODE) = 'INJ')  THEN
           v_vCodeFieldList := v_vCodeFieldList || 'INJURY_1_CODE|INJURY_2_CODE|INJURY_3_CODE|INJURY_4_CODE|INJURY_5_CODE|' ;
           v_vSysTableNameList := v_vSysTableNameList || 'INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|';
        END IF ;

        IF (upper(DDS_EVENT_CUR.DISABILITY_CODE) = 'ILL' AND DDS_EVENT_CUR.ILLNESS_CODE IS NOT NULL ) THEN
           v_vCodeFieldList := v_vCodeFieldList || 'ILLNESS_CODE|' ;
           v_vSysTableNameList := v_vSysTableNameList || 'ILLNESS_TYPE|' ;
        END IF ;
      END IF ;    -- mkaur24 reverted the change. We have a default value in v_vReqColumns so removing end if  from here and moving to line 985 will create an issue when lastname is null.


      WHILE INSTR(v_vCodeFieldList, '|', 1) > 0--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
       LOOP

         BEGIN
            v_iPos := INSTR(v_vCodeFieldList, '|', 1);
         /*   v_vColName := SUBSTR(v_vCodeFieldList, 0, INSTR(v_vCodeFieldList, '|', 1) - 1);*/
            --DBMS_OUTPUT.PUT_LINE('left3 @vColName : ' || v_vColName);
            /*v_vCodeFieldList := SUBSTR(v_vCodeFieldList, -1, LENGTH(v_vCodeFieldList) - INSTR(v_vCodeFieldList, '|', 1));*/
            v_vColName := SUBSTR(v_vCodeFieldList,1,INSTR(v_vCodeFieldList, '|', 1)-1);
           v_vCodeFieldList := SUBSTR(v_vCodeFieldList,LENGTH(SUBSTR(v_vCodeFieldList,1,INSTR(v_vCodeFieldList, '|', 1)))+1,LENGTH(v_vCodeFieldList));

          v_iPos := INSTR(v_vSysTableNameList, '|', 1);
            /*v_vTableName := SUBSTR(v_vSysTableNameList, 0, INSTR(v_vSysTableNameList, '|', 1) - 1);*/
            --DBMS_OUTPUT.PUT_LINE('left5 @vTableName : ' || v_vTableName);
           /* v_vSysTableNameList := SUBSTR(v_vSysTableNameList, -1, LENGTH(v_vSysTableNameList) - INSTR(v_vSysTableNameList, '|', 1));*/

           v_vTableName := SUBSTR(v_vSysTableNameList,1,INSTR(v_vSysTableNameList, '|', 1)-1);
           v_vSysTableNameList := SUBSTR(v_vSysTableNameList,LENGTH(SUBSTR(v_vSysTableNameList,1,INSTR(v_vSysTableNameList, '|', 1)))+1,LENGTH(v_vSysTableNameList));


           v_vVal := (CASE
                            WHEN v_vColName = 'EVENT_TYPE_CODE' THEN DDS_EVENT_CUR.EVENT_TYPE_CODE
                            WHEN v_vColName = 'EVENT_STATUS_CODE' THEN DDS_EVENT_CUR.EVENT_STATUS_CODE
                            WHEN v_vColName = 'EVENT_IND_CODE' THEN DDS_EVENT_CUR.EVENT_IND_CODE
                            WHEN v_vColName = 'LOCATION_TYPE_CODE' THEN DDS_EVENT_CUR.LOCATION_TYPE_CODE
                            WHEN v_vColName = 'CAUSE_CODE' THEN DDS_EVENT_CUR.CAUSE_CODE
                            WHEN v_vColName = 'PRIMARY_LOC_CODE' THEN DDS_EVENT_CUR.PRIMARY_LOC_CODE
                            WHEN v_vColName = 'ACTION_1_CODE' THEN DDS_EVENT_CUR.ACTION_1_CODE
                            WHEN v_vColName = 'ACTION_2_CODE' THEN DDS_EVENT_CUR.ACTION_2_CODE
                            WHEN v_vColName = 'ACTION_3_CODE' THEN DDS_EVENT_CUR.ACTION_3_CODE
                            WHEN v_vColName = 'ACTION_4_CODE' THEN DDS_EVENT_CUR.ACTION_4_CODE
                            WHEN v_vColName = 'ACTION_5_CODE' THEN DDS_EVENT_CUR.ACTION_5_CODE
                            WHEN v_vColName = 'OUTCOME_1_CODE' THEN DDS_EVENT_CUR.OUTCOME_1_CODE
                            WHEN v_vColName = 'OUTCOME_2_CODE' THEN DDS_EVENT_CUR.OUTCOME_2_CODE
                            WHEN v_vColName = 'OUTCOME_3_CODE' THEN DDS_EVENT_CUR.OUTCOME_3_CODE
                            WHEN v_vColName = 'OUTCOME_4_CODE' THEN DDS_EVENT_CUR.OUTCOME_4_CODE
                            WHEN v_vColName = 'OUTCOME_5_CODE' THEN DDS_EVENT_CUR.OUTCOME_5_CODE
                            WHEN v_vColName = 'MARITAL_STAT_CODE' THEN DDS_EVENT_CUR.MARITAL_STAT_CODE
                            WHEN v_vColName = 'BODY_PART_1_CODE' THEN DDS_EVENT_CUR.BODY_PART_1_CODE
                            WHEN v_vColName = 'BODY_PART_2_CODE' THEN DDS_EVENT_CUR.BODY_PART_2_CODE
                            WHEN v_vColName = 'BODY_PART_3_CODE' THEN DDS_EVENT_CUR.BODY_PART_3_CODE
                            WHEN v_vColName = 'BODY_PART_4_CODE' THEN DDS_EVENT_CUR.BODY_PART_4_CODE
                            WHEN v_vColName = 'BODY_PART_5_CODE' THEN DDS_EVENT_CUR.BODY_PART_5_CODE
                            WHEN v_vColName = 'DIAGNOSIS_1_CODE' THEN DDS_EVENT_CUR.DIAGNOSIS_1_CODE
                            WHEN v_vColName = 'DIAGNOSIS_2_CODE' THEN DDS_EVENT_CUR.DIAGNOSIS_2_CODE
                            WHEN v_vColName = 'DIAGNOSIS_3_CODE' THEN DDS_EVENT_CUR.DIAGNOSIS_3_CODE
                            WHEN v_vColName = 'DIAGNOSIS_4_CODE' THEN DDS_EVENT_CUR.DIAGNOSIS_4_CODE
                            WHEN v_vColName = 'DIAGNOSIS_5_CODE' THEN DDS_EVENT_CUR.DIAGNOSIS_5_CODE
                            WHEN v_vColName = 'TREATMENT_1_CODE' THEN DDS_EVENT_CUR.TREATMENT_1_CODE
                            WHEN v_vColName = 'TREATMENT_2_CODE' THEN DDS_EVENT_CUR.TREATMENT_2_CODE
                            WHEN v_vColName = 'TREATMENT_3_CODE' THEN DDS_EVENT_CUR.TREATMENT_3_CODE
                            WHEN v_vColName = 'TREATMENT_4_CODE' THEN DDS_EVENT_CUR.TREATMENT_4_CODE
                            WHEN v_vColName = 'TREATMENT_5_CODE' THEN DDS_EVENT_CUR.TREATMENT_5_CODE
                            WHEN v_vColName = 'DRIVERSLICTYPECODE' THEN DDS_EVENT_CUR.DRIVERSLICTYPECODE
                            WHEN v_vColName = 'NCCI_CLASS_CODE' THEN DDS_EVENT_CUR.NCCI_CLASS_CODE
                            WHEN v_vColName = 'DRIVLIC_RSTRCT_CODE' THEN DDS_EVENT_CUR.DRIVLIC_RSTRCT_CODE
                            WHEN v_vColName = 'ADM_TYPE_CODE' THEN DDS_EVENT_CUR.ADM_TYPE_CODE
                            WHEN v_vColName = 'ADM_SOURCE_CODE' THEN DDS_EVENT_CUR.ADM_SOURCE_CODE
                            WHEN v_vColName = 'ACUITY_LEVEL_CODE' THEN DDS_EVENT_CUR.ACUITY_LEVEL_CODE
                            WHEN v_vColName = 'PATIENT_STAT_CODE' THEN DDS_EVENT_CUR.PATIENT_STAT_CODE
                            WHEN v_vColName = 'PATIENT_COND_CODE' THEN DDS_EVENT_CUR.PATIENT_COND_CODE
                            WHEN v_vColName = 'DISCHARGE_DSP_CODE' THEN DDS_EVENT_CUR.DISCHARGE_DSP_CODE
                            WHEN v_vColName = 'PATIENT_TYPE_CODE' THEN DDS_EVENT_CUR.PATIENT_TYPE_CODE
                            WHEN v_vColName = 'FACILITY_UNIT_CODE' THEN DDS_EVENT_CUR.FACILITY_UNIT_CODE
                            WHEN v_vColName = 'DISABILITY_CODE' THEN DDS_EVENT_CUR.DISABILITY_CODE
                            WHEN v_vColName = 'POSITION_CODE' THEN DDS_EVENT_CUR.POSITION_CODE
                            WHEN v_vColName = 'PAY_TYPE_CODE' THEN DDS_EVENT_CUR.PAY_TYPE_CODE
                            WHEN v_vColName = 'COND_PRIOR_CODE' THEN DDS_EVENT_CUR.COND_PRIOR_CODE
                            WHEN v_vColName = 'RAIL_POSITION_CODE' THEN DDS_EVENT_CUR.RAIL_POSITION_CODE
                            WHEN v_vColName = 'RESTRAINT_CODE' THEN DDS_EVENT_CUR.RESTRAINT_CODE
                            WHEN v_vColName = 'BED_POSITION_CODE' THEN DDS_EVENT_CUR.BED_POSITION_CODE
                            WHEN v_vColName = 'SHARPS_BRAND_MAKE' THEN DDS_EVENT_CUR.SHARPS_BRAND_MAKE
                            WHEN v_vColName = 'SHARPS_OBJECT' THEN DDS_EVENT_CUR.SHARPS_OBJECT
                            WHEN v_vColName = 'SAFEG_PROVIDED' THEN DDS_EVENT_CUR.SAFEG_PROVIDED
                            WHEN v_vColName = 'REPORTED_COUNTRY' THEN DDS_EVENT_CUR.REPORTED_COUNTRY
                            WHEN v_vColName = 'COUNTRY' THEN DDS_EVENT_CUR.COUNTRY
                            WHEN v_vColName = 'QI_SIGNIF_CODE' THEN DDS_EVENT_CUR.QI_SIGNIF_CODE
                            WHEN v_vColName = 'DISABILITY_CODE' THEN DDS_EVENT_CUR.DISABILITY_CODE
                            WHEN v_vColName = 'RULES_NOT_FOLLOWED' THEN DDS_EVENT_CUR.RULES_NOT_FOLLOWED
                            WHEN V_vColName = 'NAME_TYPE'      THEN   DDS_EVENT_CUR.NAME_TYPE
                            WHEN v_vColName = 'CALL_LIGHT_CODE' THEN DDS_EVENT_CUR.CALL_LIGHT_CODE
                            WHEN v_vColName = 'INJURY_1_CODE' THEN DDS_EVENT_CUR.INJURY_1_CODE
                            WHEN v_vColName = 'INJURY_2_CODE' THEN DDS_EVENT_CUR.INJURY_2_CODE
                            WHEN v_vColName = 'INJURY_3_CODE' THEN DDS_EVENT_CUR.INJURY_3_CODE
                            WHEN v_vColName = 'INJURY_4_CODE' THEN DDS_EVENT_CUR.INJURY_4_CODE
                            WHEN V_vColName = 'INJURY_5_CODE'      THEN   DDS_EVENT_CUR.INJURY_5_CODE
                            WHEN v_vColName = 'ILLNESS_CODE' THEN DDS_EVENT_CUR.ILLNESS_CODE
                            WHEN v_vColName = 'SEX_CODE' THEN DDS_EVENT_CUR.SEX_CODE
                            WHEN v_vColName = 'BENEFICIARY_CODE' THEN DDS_EVENT_CUR.BENEFICIARY_CODE  --JIRA 24634 knakra
                            END);

   --         DBMS_OUTPUT.PUT_LINE('@vVal : ' || v_vVal);

        IF v_vVal IS NOT NULL AND v_vVal <> '0' THEN  -- AND v_vVal <> ''
                         DDS_CODE_VALIDATION_IMPORT(p_JOBID => p_JOBID,
                                      P_SHORT_CODE => v_vVal,-- Short Code
                                      P_SYS_TABLE_NAME => v_vTableName,-- SYstem Table Name to Check
                                      P_CODE_CREATION_FLAG => v_CheckCreateNewCodes,-- It is used to check allow creation of code flag is set by user or not
                                      P_DB_NAME => V_DBName,-- It is used to fetch error msg and append into the error msg and update it again
                                     -- P_LOB => DDS_EVENT_CUR.LINE_OF_BUS_CODE,-- LOB GC, WC ( It Will be numeric)  ---- neha 02/26
                                      P_LOB => 0,  -- neha 02/26
                                      p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                      p_MODULE_NAME => 'EVENT',
                                      p_ERROR_LOCATION => 'CODEVD3',
                                      p_ERROR_PROC_NAME => 'DDS_CODE_VALIDATION_IMPORT',
                                      p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                      p_ERROR_COLUMN => v_vColName,
                                      p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                      P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                      P_CODE_ID_R => v_iCodeId);
                                      IF (v_iCodeId IS NULL OR v_iCodeId = 0)THEN
                                       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1 ;
                                       END IF;
        END IF;

       IF v_vColName = 'EVENT_TYPE_CODE' THEN
          v_EVENT_TYPE_CODE_R := v_iCodeId;
          elsif v_vColName = 'EVENT_STATUS_CODE' THEN
          v_EVENT_STATUS_CODE_R := v_iCodeId;
          elsif v_vColName = 'EVENT_IND_CODE' THEN
          v_EVENT_IND_CODE_R := v_iCodeId;
          elsif v_vColName = 'LOCATION_TYPE_CODE' THEN
          v_LOCATION_TYPE_CODE_R := v_iCodeId;
          elsif v_vColName = 'CAUSE_CODE' THEN
          v_CAUSE_CODE_R := v_iCodeId;
          elsif v_vColName = 'PRIMARY_LOC_CODE' THEN
          v_PRIMARY_LOC_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACTION_1_CODE' THEN
          v_ACTION_1_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACTION_2_CODE' THEN
          v_ACTION_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACTION_3_CODE' THEN
          v_ACTION_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACTION_4_CODE' THEN
          v_ACTION_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACTION_5_CODE' THEN
          v_ACTION_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'OUTCOME_1_CODE' THEN
          v_OUTCOME_1_CODE_R := v_iCodeId;
          ELSIF v_vColName = 'OUTCOME_2_CODE' THEN
          v_OUTCOME_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'OUTCOME_3_CODE' THEN
          v_OUTCOME_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'OUTCOME_4_CODE' THEN
          v_OUTCOME_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'OUTCOME_5_CODE' THEN
          v_OUTCOME_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'MARITAL_STAT_CODE' THEN
          v_MARITAL_STAT_CODE_R := v_iCodeId;
          ELSIF v_vColName = 'BODY_PART_1_CODE' THEN
          v_BODY_PART_1_CODE_R := v_iCodeId;
          elsif v_vColName = 'BODY_PART_2_CODE' THEN
          v_BODY_PART_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'BODY_PART_3_CODE' THEN
          v_BODY_PART_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'BODY_PART_4_CODE' THEN
          v_BODY_PART_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'BODY_PART_5_CODE' THEN
          v_BODY_PART_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'DIAGNOSIS_1_CODE' THEN
          v_DIAGNOSIS_1_CODE_R := v_iCodeId;
          elsif v_vColName = 'DIAGNOSIS_2_CODE' THEN
          v_DIAGNOSIS_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'DIAGNOSIS_3_CODE' THEN
          v_DIAGNOSIS_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'DIAGNOSIS_4_CODE' THEN
          v_DIAGNOSIS_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'DIAGNOSIS_5_CODE' THEN
          v_DIAGNOSIS_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'TREATMENT_1_CODE' THEN
          v_TREATMENT_1_CODE_R := v_iCodeId;
          elsif v_vColName = 'TREATMENT_2_CODE' THEN
          v_TREATMENT_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'TREATMENT_3_CODE' THEN
          v_TREATMENT_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'TREATMENT_4_CODE' THEN
          v_TREATMENT_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'TREATMENT_5_CODE' THEN
          v_TREATMENT_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'DRIVERSLICTYPECODE' THEN
          v_DRIVERSLICTYPECODE_R := v_iCodeId;
          elsif v_vColName = 'NCCI_CLASS_CODE' THEN
          v_NCCI_CLASS_CODE_R := v_iCodeId;
          elsif v_vColName = 'DRIVLIC_RSTRCT_CODE' THEN
          v_DRIVLIC_RSTRCT_CODE_R := v_iCodeId;
          elsif v_vColName = 'ADM_TYPE_CODE' THEN
          v_ADM_TYPE_CODE_R := v_iCodeId;
          elsif v_vColName = 'ADM_SOURCE_CODE' THEN
          v_ADM_SOURCE_CODE_R := v_iCodeId;
          elsif v_vColName = 'ACUITY_LEVEL_CODE' THEN
          v_ACUITY_LEVEL_CODE_R := v_iCodeId;
          elsif v_vColName = 'PATIENT_STAT_CODE' THEN
          v_PATIENT_STAT_CODE_R := v_iCodeId;
          elsif v_vColName = 'PATIENT_COND_CODE' THEN
          v_PATIENT_COND_CODE_R := v_iCodeId;
          elsif v_vColName = 'DISCHARGE_DSP_CODE' THEN
          v_DISCHARGE_DSP_CODE_R := v_iCodeId;
          elsif v_vColName = 'PATIENT_TYPE_CODE' THEN
          v_PATIENT_TYPE_CODE_R := v_iCodeId;
          elsif v_vColName = 'FACILITY_UNIT_CODE' THEN
          v_FACILITY_UNIT_CODE_R := v_iCodeId;
          elsif v_vColName = 'POSITION_CODE' THEN
          v_POSITION_CODE_R := v_iCodeId;
          elsif v_vColName = 'PAY_TYPE_CODE' THEN
          v_PAY_TYPE_CODE_R := v_iCodeId;
          elsif v_vColName = 'COND_PRIOR_CODE' THEN
          v_COND_PRIOR_CODE_R := v_iCodeId;
          elsif v_vColName = 'RAIL_POSITION_CODE' THEN
          v_RAIL_POSITION_CODE_R := v_iCodeId;
          elsif v_vColName = 'RESTRAINT_CODE' THEN
          v_RESTRAINT_CODE_R := v_iCodeId;
          elsif v_vColName = 'BED_POSITION_CODE' THEN
          v_BED_POSITION_CODE_R := v_iCodeId;
          elsif v_vColName = 'SHARPS_BRAND_MAKE' THEN
          v_SHARPS_BRAND_MAKE_R := v_iCodeId;
          elsif v_vColName = 'SHARPS_OBJECT' THEN
          v_SHARPS_OBJECT_R := v_iCodeId;
          elsif v_vColName = 'SAFEG_PROVIDED' THEN
          v_SAFEG_PROVIDED_R := v_iCodeId;
          elsif v_vColName = 'REPORTED_COUNTRY' THEN
          v_REPORTED_COUNTRY_R := v_iCodeId;
          elsif v_vColName = 'COUNTRY' THEN
          v_COUNTRY_R := v_iCodeId;
          elsif v_vColName = 'QI_SIGNIF_CODE' THEN
          v_QI_SIGNIF_CODE_R := v_iCodeId;
          elsif v_vColName = 'DISABILITY_CODE' THEN
          v_DISABILITY_CODE_R := v_iCodeId;
          elsif v_vColName = 'RULES_NOT_FOLLOWED' THEN
          v_RULES_NOT_FOLLOWED_R := v_iCodeId;
          elsif v_vColName = 'CALL_LIGHT_CODE' THEN
            v_CALL_LIGHT_CODE_R := v_iCodeId;
          ELSIF v_vColName = 'NAME_TYPE'  THEN
            V_NAME_TYPE_R    := v_iCodeId;
          elsif v_vColName = 'INJURY_1_CODE' THEN
          v_INJURY_1_CODE_R := v_iCodeId;
          elsif v_vColName = 'INJURY_2_CODE' THEN
          v_INJURY_2_CODE_R := v_iCodeId;
          elsif v_vColName = 'INJURY_3_CODE' THEN
          v_INJURY_3_CODE_R := v_iCodeId;
          elsif v_vColName = 'INJURY_4_CODE' THEN
          v_INJURY_4_CODE_R := v_iCodeId;
          elsif v_vColName = 'INJURY_5_CODE' THEN
          v_INJURY_5_CODE_R := v_iCodeId;
          elsif v_vColName = 'ILLNESS_CODE' THEN
            v_ILLNESS_CODE_R := v_iCodeId;
          ELSIF v_vColName = 'SEX_CODE'  THEN
            V_SEX_CODE_R    := v_iCodeId;
          ELSIF v_vColName = 'BENEFICIARY_CODE' THEN  --JIRA 24634 knakra
            v_vBENEFICIARY_CODE_ID := v_iCodeId;      --JIRA 24634 knakra
          END IF;

           v_iCodeId := NULL;
                   -- END IF; --mkaur24 END
     END ; --BEGIN END

      END LOOP; --mkaur24 END LOOP


    --  END IF ; mkaur24 reverting the change.
       -- Abhishek: WHILE loop and its execution are moved into if block
       -- kapil take below WHILE LOOP and its execution into ABOVE if block
       -- reason if v_vColList is null then it is useless to assign below variable.


 V_ERROR_LOCATION := 'Emk4.6';

      IF (( upper (DDS_EVENT_CUR.PI_TYPE_CODE) <> 'P'
        AND upper( DDS_EVENT_CUR.PI_TYPE_CODE) <> 'E'
        AND upper(DDS_EVENT_CUR.PI_TYPE_CODE) <> 'PHYS'
        AND upper(DDS_EVENT_CUR.PI_TYPE_CODE) <> 'W'
         AND upper(DDS_EVENT_CUR.PI_TYPE_CODE) <> 'D' --MKAUR24 3/22/2017
          AND upper(DDS_EVENT_CUR.PI_TYPE_CODE) <> 'MED' --MKAUR24 3/22/2017
        )OR DDS_EVENT_CUR.PI_TYPE_CODE is NULL ) THEN
         DDS_EVENT_CUR.PI_TYPE_CODE := 'O';
    END IF ;

           DDS_CODE_VALIDATION_IMPORT(p_JOBID,
                                    DDS_EVENT_CUR.PI_TYPE_CODE,
                                    'PERSON_INV_TYPE',
                                    v_CheckCreateNewCodes,
                                    v_DBName,
                                   -- DDS_EVENT_CUR.LINE_OF_BUS_CODE,  ---neha 02/26
                                    0,  --neha 02/26
                                    DDS_EVENT_CUR.DA_ROW_ID,
                                    'EVENT',
                                    'CODEVD3',
                                    'DDS_CODE_VALIDATION_IMPORT',
                                    'EVENT_NUMBER',
                                    'PI_TYPE_CODE',
                                    'DDS_EVENT',
                                    DDS_EVENT_CUR.EVENT_NUMBER,
                                    v_iCodeId);
         v_PI_TYPE_CODE_R := v_iCodeId;
     IF (v_iCodeId IS NULL OR v_iCodeId = 0) THEN
      V_I_ERRORCOUNT := V_I_ERRORCOUNT + 1 ;
      END IF;


 END ; -- CODE VALIDATION ENDS
 V_ERROR_LOCATION := 'Emk4.7';
BEGIN-- DATE FORMAT VALIDATION STARTS

      v_I_UPDATE_FLAG := 0;
      v_I_COUNT := 0;
      v_vColList := 'DATE_REPORTED|DATE_OF_EVENT|DATE_TO_FOLLOW_UP|DATE_PHYS_ADVISED|DATE_CARRIER_NOTIF';
      v_vColList := v_vColList || '|BIRTH_DATE|DATE_OF_DEATH|DATE_DRIVERSLICEXP|LAST_VERIFIED_DATE|DATE_OF_ADMISSION|DATE_OF_DISCHARGE|DATE_HIRED|WORK_PERMIT_DATE';
      v_vColList := v_vColList || '|DATE_LAST_WORKED_1|DATE_RETURNED_1|DATE_LAST_WORKED_2|DATE_RETURNED_2|DATE_LAST_WORKED_3|DATE_RETURNED_3|DATE_LAST_WORKED_4|DATE_RETURNED_4|DATE_LAST_WORKED_5|DATE_RETURNED_5     ';
      v_vColList := v_vColList || '|DATE_LAST_WORKED_6|DATE_RETURNED_6|DATE_LAST_WORKED_7|DATE_RETURNED_7|DATE_LAST_WORKED_8|DATE_RETURNED_8|DATE_LAST_WORKED_9|DATE_RETURNED_9|DATE_LAST_WORKED_10|DATE_RETURNED_10';
      v_vColList := v_vColList || '|DATE_LAST_WORKED_11|DATE_RETURNED_11|DATE_LAST_WORKED_12|DATE_RETURNED_12|DATE_LAST_WORKED_13|DATE_RETURNED_13|DATE_LAST_WORKED_14|DATE_RETURNED_14|DATE_LAST_WORKED_15|DATE_RETURNED_15';
      v_vColList := v_vColList || '|REPORTED_BIRTH_DT|';  --JIRA 24634 knakra


        V_SQL :=' select regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
          connect by regexp_substr('||''''||v_vColList||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
         OPEN l_CURSOR FOR V_SQL;
          LOOP
            FETCH l_CURSOR INTO v_vColName ;
            EXIT WHEN l_CURSOR%NOTFOUND;
                  v_vVal := (CASE
                            WHEN v_vColName = 'DATE_REPORTED' THEN DDS_EVENT_CUR.DATE_REPORTED
                            WHEN v_vColName = 'DATE_OF_EVENT' THEN DDS_EVENT_CUR.DATE_OF_EVENT
                            WHEN v_vColName = 'DATE_TO_FOLLOW_UP' THEN DDS_EVENT_CUR.DATE_TO_FOLLOW_UP
                            WHEN v_vColName = 'DATE_PHYS_ADVISED' THEN DDS_EVENT_CUR.DATE_PHYS_ADVISED
                            WHEN v_vColName = 'DATE_CARRIER_NOTIF' THEN DDS_EVENT_CUR.DATE_CARRIER_NOTIF
                            WHEN v_vColName = 'BIRTH_DATE' THEN DDS_EVENT_CUR.BIRTH_DATE
                            WHEN v_vColName = 'DATE_OF_DEATH' THEN DDS_EVENT_CUR.DATE_OF_DEATH
                            WHEN v_vColName = 'DATE_DRIVERSLICEXP' THEN DDS_EVENT_CUR.DATE_DRIVERSLICEXP
                            WHEN v_vColName = 'LAST_VERIFIED_DATE' THEN DDS_EVENT_CUR.LAST_VERIFIED_DATE
                            WHEN v_vColName = 'DATE_OF_ADMISSION' THEN DDS_EVENT_CUR.DATE_OF_ADMISSION
                            WHEN v_vColName = 'DATE_OF_DISCHARGE' THEN DDS_EVENT_CUR.DATE_OF_DISCHARGE
                            WHEN v_vColName = 'DATE_HIRED' THEN DDS_EVENT_CUR.DATE_HIRED
                            WHEN v_vColName = 'WORK_PERMIT_DATE' THEN DDS_EVENT_CUR.WORK_PERMIT_DATE
                            WHEN v_vColName = 'DATE_LAST_WORKED_1' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_1
                            WHEN v_vColName = 'DATE_RETURNED_1' THEN DDS_EVENT_CUR.DATE_RETURNED_1
                            WHEN v_vColName = 'DATE_LAST_WORKED_2' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_2
                            WHEN v_vColName = 'DATE_RETURNED_2' THEN DDS_EVENT_CUR.DATE_RETURNED_2
                            WHEN v_vColName = 'DATE_LAST_WORKED_3' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_3
                            WHEN v_vColName = 'DATE_RETURNED_3' THEN DDS_EVENT_CUR.DATE_RETURNED_3
                            WHEN v_vColName = 'DATE_LAST_WORKED_4' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_4
                            WHEN v_vColName = 'DATE_RETURNED_4' THEN DDS_EVENT_CUR.DATE_RETURNED_4
                            WHEN v_vColName = 'DATE_LAST_WORKED_5' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_5
                            WHEN v_vColName = 'DATE_RETURNED_5' THEN DDS_EVENT_CUR.DATE_RETURNED_5
                            WHEN v_vColName = 'DATE_LAST_WORKED_6' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_6
                            WHEN v_vColName = 'DATE_RETURNED_6' THEN DDS_EVENT_CUR.DATE_RETURNED_6
                            WHEN v_vColName = 'DATE_LAST_WORKED_7' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_7
                            WHEN v_vColName = 'DATE_RETURNED_7' THEN DDS_EVENT_CUR.DATE_RETURNED_7
                            WHEN v_vColName = 'DATE_LAST_WORKED_8' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_8
                            WHEN v_vColName = 'DATE_RETURNED_8' THEN DDS_EVENT_CUR.DATE_RETURNED_8
                            WHEN v_vColName = 'DATE_LAST_WORKED_9' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_9
                            WHEN v_vColName = 'DATE_RETURNED_9' THEN DDS_EVENT_CUR.DATE_RETURNED_9
                            WHEN v_vColName = 'DATE_LAST_WORKED_10' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_10
                            WHEN v_vColName = 'DATE_RETURNED_10' THEN DDS_EVENT_CUR.DATE_RETURNED_10
                            WHEN v_vColName = 'DATE_LAST_WORKED_11' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_11
                            WHEN v_vColName = 'DATE_RETURNED_11' THEN DDS_EVENT_CUR.DATE_RETURNED_11
                            WHEN v_vColName = 'DATE_LAST_WORKED_12' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_12
                            WHEN v_vColName = 'DATE_RETURNED_12' THEN DDS_EVENT_CUR.DATE_RETURNED_12
                            WHEN v_vColName = 'DATE_LAST_WORKED_13' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_13
                            WHEN v_vColName = 'DATE_RETURNED_13' THEN DDS_EVENT_CUR.DATE_RETURNED_13
                            WHEN v_vColName = 'DATE_LAST_WORKED_14' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_14
                            WHEN v_vColName = 'DATE_RETURNED_14' THEN DDS_EVENT_CUR.DATE_RETURNED_14
                            WHEN v_vColName = 'DATE_LAST_WORKED_15' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_15
                            WHEN v_vColName = 'DATE_RETURNED_15' THEN DDS_EVENT_CUR.DATE_RETURNED_15
                            WHEN v_vColName = 'REPORTED_BIRTH_DT' THEN DDS_EVENT_CUR.REPORTED_BIRTH_DT  --JIRA 24634 knakra
                            END);
               V_ERROR_LOCATION := 'Emk4.8';
              IF v_vVal IS NOT NULL THEN

                            IF ( LENGTH(v_vVal) <> 8 OR DDS_IS_number(v_vVal) = 0 OR DDS_IS_DATE(v_vVal) = 0 ) THEN
                                DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                                p_MODULE_NAME => V_MODULENAME,
                                                p_CALLING_ERROR_LOCATION => 'Main',
                                                p_CURRENT_ERROR_LOCATION => 'DATEFORMAT',
                                                p_ERROR_PROC_NAME => V_PROCNAME,
                                                p_ERROR_MSG => 'Invalid Date. Please provide Date in YYYYMMDD format.',
                                                p_ERROR_COLUMNS => v_vColName,
                                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                                P_IS_VALIDATION => 1);
                                                v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

                                   IF v_vColName = 'DATE_REPORTED'
                                      THEN
                                        V_DATE_REPORTED_INVALID := 1;
                                    END IF;
                                    IF v_vColName = 'DATE_OF_EVENT'  THEN
                                       V_DATE_OF_EVENT_INVALID := 1;
                                     END IF;
                                       IF v_vColName = 'DATE_OF_DEATH'  THEN
                                       V_DATE_OF_DEATH_INVALID := 1;
                                     END IF;
                                       IF v_vColName = 'DATE_OF_HIRE'  THEN
                                       V_DATE_HIRED_INVALID := 1;
                                     END IF;


                           --END IF;
                      --END IF;
                    ELSE
                      IF  DDS_IS_DATE(v_vVal) <> 0  AND  ( (V_VALID_START_DATE > v_vVal  ) OR ( v_vVal > V_VALID_END_DATE ) ) THEN
                         DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                                p_MODULE_NAME => V_MODULENAME,
                                                p_CALLING_ERROR_LOCATION => 'Main',
                                                p_CURRENT_ERROR_LOCATION => 'DATEFORMAT2',
                                                p_ERROR_PROC_NAME => V_PROCNAME,
                                                p_ERROR_MSG => 'Date must fall between the date range selected at UI.',
                                                p_ERROR_COLUMNS => v_vColName,
                                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                                P_IS_VALIDATION => 1);
                        v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;

                        IF v_vColName = 'DATE_REPORTED'
                          THEN
                            V_DATE_REPORTED_INVALID := 1;
                        END IF;
                        IF v_vColName = 'DATE_OF_EVENT'  THEN
                           V_DATE_OF_EVENT_INVALID := 1;
                        END IF;
                          IF v_vColName = 'DATE_OF_DEATH'  THEN
                                       V_DATE_OF_DEATH_INVALID := 1;
                                     END IF;
                                       IF v_vColName = 'DATE_OF_HIRE'  THEN
                                       V_DATE_HIRED_INVALID := 1;
                                     END IF;
                    END IF;
                   END IF;


              END IF;
            END LOOP;
          CLOSE   l_CURSOR;
END ; --DATE FORMAT VALIDATION ENDS
 V_ERROR_LOCATION := 'Emk4.9';
 BEGIN-- TIME FORMAT VALIDATION STARTS
           -- DBMS_OUTPUT.PUT_LINE('ENETRETD TIME VD');
            v_vColList := 'TIME_OF_EVENT|TIME_REPORTED|TIME_PHYS_ADVISED|WORKDAY_START_TIME|';
            WHILE INSTR(v_vColList, '|', 1) > 0
            LOOP
             -- Abhishek: Unwanted comments removed.
             -- kapil remove unwanted commented lines except dbms output..

             v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1);
           v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList));

              v_vVal := (CASE
                                  WHEN v_vColName = 'TIME_OF_EVENT' THEN DDS_EVENT_CUR.TIME_OF_EVENT
                                  WHEN v_vColName = 'TIME_REPORTED ' THEN DDS_EVENT_CUR.TIME_REPORTED
                                  WHEN v_vColName = 'TIME_PHYS_ADVISED' THEN DDS_EVENT_CUR.TIME_PHYS_ADVISED
                                 WHEN v_vColName = 'WORKDAY_START_TIME' THEN DDS_EVENT_CUR.WORKDAY_START_TIME  END);
           V_ERROR_LOCATION := 'Emk5.1';
                 IF v_vVal IS NOT NULL THEN
                     BEGIN
                           SELECT to_date(v_vVal,'HH24MISS')TIME
                             INTO v_CheckTime
                             FROM DUAL ;
                     EXCEPTION
                        WHEN OTHERS THEN
                              --V_ERROR_MESSAGE := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                                    p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                                    p_MODULE_NAME => V_MODULENAME,
                                                    p_CALLING_ERROR_LOCATION => 'Main',
                                                    p_CURRENT_ERROR_LOCATION => 'INVALIDTIME',
                                                    p_ERROR_PROC_NAME => V_PROCNAME,
                                                    p_ERROR_MSG => 'Time is in valid format. It must be in HH24MISS.',
                                                    p_ERROR_COLUMNS => v_vColName,
                                                    p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                                    p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                                    P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                                    P_IS_VALIDATION => 1);

                              IF v_vColName = 'TIME_OF_EVENT' THEN
                                 v_TIME_OF_EVENT_INVALID := 1;
                              END IF;
                              IF v_vColName = 'TIME_REPORTED' THEN
                                 v_TIME_REPORTED_INVALID := 1;
                              END IF;
                     END;
                  END IF;
            END LOOP;
         END;

    V_ERROR_LOCATION := 'Emk5.2';
 BEGIN-- 3. DATE AND TIME VALIDATION STARTS
    IF ( V_DATE_REPORTED_INVALID = 0 AND V_DATE_OF_EVENT_INVALID = 0 ) THEN
       IF DDS_EVENT_CUR.DATE_REPORTED < DDS_EVENT_CUR.DATE_OF_EVENT THEN
          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D1',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'Date Reported Must be greater than or equal to Event Date.',
                                p_ERROR_COLUMNS => 'DATE_REPORTED',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
    END IF;


    V_ERROR_LOCATION := 'Emk5.8';
     v_GETDate := to_char(sysdate,'yyyymmdd') ;
     IF ( V_DATE_REPORTED_INVALID = 0) THEN
       IF DDS_EVENT_CUR.DATE_REPORTED >  v_GETDate THEN
           DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D7',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'Date Reported cannot be greater than system date.',
                                p_ERROR_COLUMNS => 'DATE_REPORTED',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
     END IF;
     IF ( V_DATE_OF_EVENT_INVALID = 0) THEN
       IF DDS_EVENT_CUR.DATE_OF_EVENT >  v_GETDate THEN
           DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D9',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'DATE OF EVENT cannot be greater than system date.',
                                p_ERROR_COLUMNS => 'DATE_REPORTED',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
     END IF;

     --mkaur24 start
   IF  (V_DATE_OF_DEATH_INVALID = 0) AND  (V_DATE_OF_EVENT_INVALID = 0) AND  (DDS_EVENT_CUR.DATE_OF_DEATH < DDS_EVENT_CUR.DATE_OF_EVENT) THEN

          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D1.1',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'DATE OF EVENT cannot be greater than DATE OF DEATH.',
                                p_ERROR_COLUMNS => 'DATE_OF_EVENT',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
     IF  (V_DATE_OF_EVENT_INVALID = 0) AND  (V_DATE_HIRED_INVALID = 0) AND  (DDS_EVENT_CUR.DATE_HIRED > DDS_EVENT_CUR.DATE_OF_EVENT) THEN

          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D1.2',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'DATE OF EVENT cannot be less than DATE OF HIRE.',
                                p_ERROR_COLUMNS => 'DATE_OF_EVENT',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
      IF  (V_DATE_OF_DEATH_INVALID = 0) AND  (V_DATE_HIRED_INVALID = 0) AND  (DDS_EVENT_CUR.DATE_HIRED > DDS_EVENT_CUR.DATE_OF_DEATH) THEN

          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D1.3',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'DATE OF DEATH cannot be less than DATE OF HIRE.',
                                p_ERROR_COLUMNS => 'DATE_OF_DEATH',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
     --mkaur24 end



    V_ERROR_LOCATION := 'Emk5.9';



    ----•Time Reported Must be >= Event Time: 12:00:00 PM
    IF ( v_TIME_OF_EVENT_INVALID = 0 AND v_TIME_REPORTED_INVALID = 0 ) AND (DDS_EVENT_CUR.DATE_REPORTED = DDS_EVENT_CUR.DATE_OF_EVENT ) THEN
       IF DDS_EVENT_CUR.TIME_REPORTED < DDS_EVENT_CUR.TIME_OF_EVENT THEN
          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                p_MODULE_NAME => V_MODULENAME,
                                p_CALLING_ERROR_LOCATION => 'Date',
                                p_CURRENT_ERROR_LOCATION => 'D1',
                                p_ERROR_PROC_NAME => V_PROCNAME,
                                p_ERROR_MSG => 'Time Reported Must be greater than or equal to Event Time.',
                                p_ERROR_COLUMNS => 'TIME_REPORTED',
                                p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                P_IS_VALIDATION => 1);

          v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END IF;
    END IF;
 END;

    V_ERROR_LOCATION := 'Emk6.1';
 BEGIN-- STATE VALIDATION   neha commenting state validation
            v_vColList := 'STATE|REPORTED_STATE|';

            IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL  THEN         --AND ( DDS_EVENT_CUR.PI_LAST_NAME <> '')
               v_vColList := v_vColList || 'PI_STATE|DRIVLIC_STATE|SUPER_STATE|' ;
            END IF;


            WHILE INSTR(v_vColList, '|', 1) > 0
            LOOP
                  v_I_COUNT := 0;
          /*        v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1);
                  v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1)));*/
             v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1);
           v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList));


             v_vVal := (CASE
                                  WHEN v_vColName = 'STATE' THEN DDS_EVENT_CUR.STATE
                                  WHEN v_vColName = 'REPORTED_STATE' THEN DDS_EVENT_CUR.REPORTED_STATE
                                  WHEN v_vColName = 'PI_STATE' THEN DDS_EVENT_CUR.PI_STATE
                                  WHEN v_vColName = 'DRIVLIC_STATE' THEN DDS_EVENT_CUR.DRIVLIC_STATE
                                  WHEN v_vColName = 'SUPER_STATE' THEN DDS_EVENT_CUR.SUPER_STATE   END);
              V_ERROR_LOCATION := 'Emk6.2';
                 IF v_vVal IS NOT NULL THEN
                     v_N_SQL := 'SELECT STATE_ROW_ID FROM ' || V_DBName || 'STATES ';
                     v_N_SQL := v_N_SQL || ' WHERE UPPER(STATE_ID) = :1';
                     BEGIN
                       EXECUTE IMMEDIATE v_N_SQL INTO v_STATE_ROW_ID_R USING UPPER(v_vVal);
                     EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                           DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                              p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                              p_MODULE_NAME => V_MODULENAME,
                                              p_CALLING_ERROR_LOCATION => 'Main',
                                              p_CURRENT_ERROR_LOCATION => 'STATEVD',
                                              p_ERROR_PROC_NAME => V_PROCNAME,
                                              p_ERROR_MSG => 'Invalid STATE. Please provide  a valid state.',
                                              p_ERROR_COLUMNS => v_vColName,
                                              p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                              p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                              P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                              P_IS_VALIDATION => 1);
                             v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        WHEN OTHERS THEN
                              V_ERROR_MESSAGE := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                                    p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                                    p_MODULE_NAME => V_MODULENAME,
                                                    p_CALLING_ERROR_LOCATION => 'Main',
                                                    p_CURRENT_ERROR_LOCATION => 'STATESVD',
                                                    p_ERROR_PROC_NAME => V_PROCNAME,
                                                    p_ERROR_MSG => V_ERROR_MESSAGE,
                                                    p_ERROR_COLUMNS => v_vColName,
                                                    p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                                    p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                                    P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                                    P_IS_VALIDATION => 0);
                             v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                          END;
                     END IF;
                     IF ( v_STATE_ROW_ID_R IS NOT NULL ) THEN
                        IF v_vColName = 'STATE' THEN
                           v_STATE_R := v_STATE_ROW_ID_R;
                        END IF;
                        IF v_vColName = 'REPORTED_STATE' THEN
                           v_REPORTED_STATE_R := v_STATE_ROW_ID_R;
                        END IF;
                        IF v_vColName = 'PI_STATE' THEN
                           v_PI_STATE_R := v_STATE_ROW_ID_R;
                        END IF;
                        IF v_vColName = 'DRIVLIC_STATE' THEN
                           v_DRIVLIC_STATE_R := v_STATE_ROW_ID_R;
                        END IF;
                        IF v_vColName = 'SUPER_STATE' THEN
                           v_SUPER_STATE_R := v_STATE_ROW_ID_R;
                        END IF;
                     END IF;


            END LOOP;
 END;

  V_ERROR_LOCATION := 'Emk6.3';

 BEGIN-- 6.DISABILITY_CODE VALIDATION STARTS
    IF upper(DDS_EVENT_CUR.DISABILITY_CODE) = 'ILL' AND DDS_EVENT_CUR.ILLNESS_CODE IS NULL THEN
       V_CLOCATION := 'Dis1';
       DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION => 'Dis',
                             p_CURRENT_ERROR_LOCATION => V_CLOCATION,
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG => 'The DISABILITY_CODE is provided as ILL,  howvever no value is provided for ILLNESS_CODE.',
                             p_ERROR_COLUMNS => 'ILLNESS_CODE',
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);
       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
    END IF;
V_ERROR_LOCATION := 'Emk6.7';
    IF (upper( DDS_EVENT_CUR.DISABILITY_CODE) = 'INJ'
      AND ((DDS_EVENT_CUR.INJURY_1_CODE IS NULL )
      AND ( DDS_EVENT_CUR.INJURY_2_CODE IS NULL )
      AND ( DDS_EVENT_CUR.INJURY_3_CODE IS NULL )
      AND (DDS_EVENT_CUR.INJURY_4_CODE IS NULL )
      AND ( DDS_EVENT_CUR.INJURY_5_CODE IS NULL ) ) ) THEN
       V_CLOCATION := 'Dis2';
       DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION => 'Dis',
                             p_CURRENT_ERROR_LOCATION => V_CLOCATION,
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG => 'The DISABILITY_CODE is provided as INJ,  howvever no value is provided for INJURY_CODE',

                             p_ERROR_COLUMNS => 'INJURY_CODE',
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);

       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
    END IF;
V_ERROR_LOCATION := 'Emk6.8';
    IF ( DDS_EVENT_CUR.ILLNESS_CODE IS NOT NULL
      AND ( ( DDS_EVENT_CUR.INJURY_1_CODE IS NOT NULL )
      OR ( DDS_EVENT_CUR.INJURY_2_CODE IS NOT NULL )
      OR ( DDS_EVENT_CUR.INJURY_3_CODE IS NOT NULL )
      OR ( DDS_EVENT_CUR.INJURY_4_CODE IS NOT NULL )
      OR ( DDS_EVENT_CUR.INJURY_5_CODE IS NOT NULL ) )) THEN
       V_CLOCATION := 'Dis3';



            --IF   UPPER(@v_DISABILITY_CODE) = 'INJ' SET @V_ERROR_COLUMN = 'ILLNESS_CODE'
            --IF   UPPER(@v_DISABILITY_CODE) = 'ILL'

           V_V_ERROR_COLUMN_EVENT := '' ; --**neha-this block is working fine:no change req-- **kapil try to avoid such type of assignments not a valid assignment either assign null or 0
          IF DDS_EVENT_CUR.ILLNESS_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := 'ILLNESS_CODE'  ;
           END IF ;
          IF DDS_EVENT_CUR.INJURY_1_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := V_V_ERROR_COLUMN_EVENT || ',INJURY_1_CODE'   ;
          END IF ;
        IF DDS_EVENT_CUR.INJURY_2_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := V_V_ERROR_COLUMN_EVENT || ',INJURY_2_CODE' ;
         END IF ;
          IF DDS_EVENT_CUR.INJURY_3_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := V_V_ERROR_COLUMN_EVENT || ',INJURY_3_CODE' ;
          END IF ;
          IF DDS_EVENT_CUR.INJURY_4_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := V_V_ERROR_COLUMN_EVENT || ',INJURY_4_CODE' ;
        END IF ;
          IF DDS_EVENT_CUR.INJURY_5_CODE IS NOT NULL THEN
             V_V_ERROR_COLUMN_EVENT := V_V_ERROR_COLUMN_EVENT || ',INJURY_5_CODE' ;
          END IF ;
      V_ERROR_LOCATION := 'Emk6.9';
                DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION => 'Dis',
                             p_CURRENT_ERROR_LOCATION => V_CLOCATION,
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG => 'Values are provided for both ILLNESS_CODE and INJURY_CODE. Please provide value for the column specifc to the code provided for Disablity Code.',-- REQUIRED FIELD --
                             -- Abhishek: added apace and full stop. kapil use full stop in error message
                             p_ERROR_COLUMNS => V_V_ERROR_COLUMN_EVENT,
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);

       v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
    END IF;
 END;
   V_ERROR_LOCATION := 'Emk7.1';
 BEGIN-- DEPARTMENT / DEPT_INVOLVED / OSHA_ESTAB_EID COMBINED

 --mkaur24 no chnage required.
 --**neha DDS_EVENT_CUR.DEPARTMENT..etc columns are not null then check.. DEPARTMENT is req field.so leaving this block unchanged.
 -- **Kapil can we check if any column which are used in below while is having non null value then only work
 -- otherwise if any column which is used and not having any value then it will execute it uselessely
 -- if value is either 0 or null then those values can be assigned directly

    v_vColList := 'DEPARTMENT|DEPT_INVOLVED|OSHA_ESTAB_EID|';
    v_vTableList := 'DEPARTMENT|DEPARTMENT|OSHA_ESTABLISHMENT|';

    IF  DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL  THEN
         IF UPPER (DDS_EVENT_CUR.PI_TYPE_CODE) = 'E'   THEN
         v_vColList := v_vColList || 'DEPT_ASSIGNED|' ;
        -- v_vColList := v_vColList || 'DEPARTMENT|';   NEHA
        v_vTableList := v_vTableList || 'DEPARTMENT|';   -- ADDED BY NEHA
         END IF;

      IF UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P'  THEN
         v_vColList := v_vColList || 'FACILITY_DEPT|' ;
         --v_vColList := v_vColList || 'DEPARTMENT|' ;  NEHA
           v_vTableList := v_vTableList || 'DEPARTMENT|';   -- ADDED BY NEHA

       END IF;
     END IF;
    WHILE INSTR(v_vColList, '|', 1) > 0
    LOOP
       BEGIN
        /*  v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1);
          v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1)));
          v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1);
          v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/

           v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1);
           v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList));
           v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1);
           v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList));

            v_vColToProcess := v_vColName;
             v_vVal := (CASE
                             WHEN v_vColToProcess = 'DEPARTMENT' THEN UPPER(DDS_EVENT_CUR.DEPARTMENT)
                             WHEN v_vColToProcess = 'DEPT_INVOLVED' THEN UPPER(DDS_EVENT_CUR.DEPT_INVOLVED)
                             WHEN v_vColToProcess = 'OSHA_ESTAB_EID' THEN UPPER(DDS_EVENT_CUR.OSHA_ESTAB_EID)
                              WHEN v_vColToProcess = 'DEPT_ASSIGNED' THEN UPPER(DDS_EVENT_CUR.DEPT_ASSIGNED)
                             WHEN v_vColToProcess = 'FACILITY_DEPT' THEN UPPER(DDS_EVENT_CUR.FACILITY_DEPT)
                             END);
 V_ERROR_LOCATION := 'Emk7.2';
             IF v_vVal IS NOT NULL THEN
                v_i_ENTITY_ID := 0;
                v_I_COUNT := 0;
                v_N_SQL := 'SELECT E.ENTITY_ID,  E.DELETED_FLAG FROM ' || V_DBName || 'ENTITY E , ';
                v_N_SQL := v_N_SQL || V_DBName || 'GLOSSARY G WHERE E.ENTITY_TABLE_ID = G.TABLE_ID ';
                v_N_SQL := v_N_SQL || ' AND UPPER(E.ABBREVIATION) = :1  AND G.system_TABLE_NAME = :2 ';
                --v_N_SQL := v_N_SQL || 'GROUP BY E.ENTITY_ID ';
                DBMS_OUTPUT.PUT_LINE('@N_SQL -> ' || v_N_SQL);
              BEGIN
                  EXECUTE IMMEDIATE v_N_SQL INTO v_i_ENTITY_ID , v_i_DELETED_FLAG USING v_vVal, v_vTableName;
              EXCEPTION
               WHEN NO_DATA_FOUND THEN

                     IF (( v_i_ENTITY_ID = 0  OR (v_i_ENTITY_ID > 0 and v_i_DELETED_FLAG <> 0))AND v_CheckCreateNewDEPARTMENT = 0 AND v_vColName <> 'OSHA_ESTAB_EID') OR ((v_i_ENTITY_ID = 0 OR (v_i_ENTITY_ID > 0 AND v_i_DELETED_FLAG <> 0)) AND v_vColName = 'OSHA_ESTAB_EID')    THEN

                        v_V_ERROR_MESSAGE := 'The value provided for the COLUMN: '|| v_vColName ||' does not exist or has been deleted. Please provide a valid entity. / Incase of department related columns; If creating new department, please check allow creation of new department.';


                         DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                               p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                               p_MODULE_NAME => V_MODULENAME,
                                               p_CALLING_ERROR_LOCATION => 'MAIN',
                                               p_CURRENT_ERROR_LOCATION => 'DEPT/OSHA2',
                                               p_ERROR_PROC_NAME => V_PROCNAME,
                                               p_ERROR_MSG => v_V_ERROR_MESSAGE,
                                               p_ERROR_COLUMNS => v_vColName,
                                               p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                               p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                               P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                               P_IS_VALIDATION => 1);
                         v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                      END IF;
                    /*  IF v_vColName = 'OSHA_ESTAB_EID' THEN
                         DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                               p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                               p_MODULE_NAME => V_MODULENAME,
                                               p_CALLING_ERROR_LOCATION => 'MAIN',
                                               p_CURRENT_ERROR_LOCATION => 'DEPT/OSHA3',
                                               p_ERROR_PROC_NAME => V_PROCNAME,
                                               p_ERROR_MSG => 'The value provided for the said column does not exists as an entity.Please provide a valid entity / Incase of department realted columns check allow creation of new dept if wants to create new dept. ',
                                               p_ERROR_COLUMNS => v_vColName,
                                               p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                               p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                               P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                               P_IS_VALIDATION => 1);
                         v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                      END IF; */
               WHEN OTHERS THEN
                  V_ERROR_MESSAGE := SQLERRM;
                     DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                           p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                           p_MODULE_NAME => V_MODULENAME,
                                           p_CALLING_ERROR_LOCATION => 'Main',
                                           p_CURRENT_ERROR_LOCATION => 'DEPT/OSHA1',
                                           p_ERROR_PROC_NAME =>  V_PROCNAME,
                                           p_ERROR_MSG => V_ERROR_MESSAGE,
                                           p_ERROR_COLUMNS => v_vColName,
                                           p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                           p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                           P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                           P_IS_VALIDATION => 0);
               END;

                IF v_vColName = 'DEPARTMENT' THEN
                   v_i_DEPARTMENT_GEN := v_i_ENTITY_ID;--DEPARTMENT ID GENERATED
                END IF;
                IF v_vColName = 'DEPT_INVOLVED' THEN
                   v_i_DEPT_INVOLVED_GEN := v_i_ENTITY_ID;--DEPT_INVOLVED  GENERATED
                END IF;
                IF v_vColName = 'OSHA_ESTAB_EID' THEN
                   v_I_OSHA_ESTAB_EID_GEN := v_i_ENTITY_ID;-- OSHA_ESTAB_EID GENERATED
                END IF;
                 IF v_vColName = 'DEPT_ASSIGNED' THEN
                   v_I_DEPT_ASSIGNED_GEN := v_i_ENTITY_ID;-- DEPT_ASSIGNED GENERATED
                END IF;
             END IF;
       END;
    END LOOP;
 END;
 V_ERROR_LOCATION := 'Emk7.4';
 --create dep star
    IF ( v_CheckCreateNewDEPARTMENT <> 0 ) THEN
               v_vColList := 'DEPARTMENT|DEPT_INVOLVED|';
               v_vTableList := 'DEPARTMENT|DEPARTMENT|';

               IF DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL THEN
                  v_vColList := v_vColList || 'FACILITY_DEPT|DEPT_ASSIGNED|';
                  v_vTableList := v_vTableList || 'DEPARTMENT|DEPARTMENT|';
               END IF;

               WHILE INSTR(v_vColList, '|', 1) > 0
               LOOP
                     v_iEntId := 0;
                     v_I_COUNT := 0;
                  /*   v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1);
                     v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1)));
                     v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1);
                     v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/

                      v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1);
           v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList));
           v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1);
           v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList));



                     v_vColToProcess := v_vColName;

                   /*  v_vVal := (CASE
                                     WHEN v_vColToProcess = 'DEPARTMENT' THEN v_i_DEPARTMENT_GEN
                                     WHEN v_vColToProcess = 'DEPT_INVOLVED' THEN v_i_DEPT_INVOLVED_GEN
                                     WHEN v_vColToProcess = 'DEPT_ASSIGNED' THEN v_i_DEPT_ASSIGNED_GEN
                                     WHEN v_vColToProcess = 'FACILITY_DEPT' THEN v_i_FACILITY_DEPT_GEN   END);*/

                    IF v_vColToProcess = 'DEPARTMENT' THEN
                       v_vVal :=  DDS_EVENT_CUR.DEPARTMENT   ;
                       V_iEidForDept := v_i_DEPARTMENT_GEN ;
                    END IF ;
                    IF v_vColToProcess = 'DEPT_INVOLVED' THEN
                      v_vVal := DDS_EVENT_CUR.DEPT_INVOLVED ;
                      V_iEidForDept := v_i_DEPT_INVOLVED_GEN ;
                      END IF ;
                    IF v_vColToProcess = 'DEPT_ASSIGNED' THEN
                      v_vVal := DDS_EVENT_CUR.DEPT_ASSIGNED;
                      V_iEidForDept :=v_i_DEPT_ASSIGNED_GEN ;
                      END IF ;
                    IF v_vColToProcess = 'FACILITY_DEPT' THEN
                      v_vVal := DDS_EVENT_CUR.FACILITY_DEPT ;
                    V_iEidForDept := v_i_FACILITY_DEPT_GEN ;
                      END IF ;

                      V_ERROR_LOCATION := 'Emk7.5';

                    IF v_vVal is not null AND V_iEidForDept = 0 THEN
                       v_iEntId := 0;
                      v_DDS_ORG_HIERARCHY_TYPE:=  DDS_ORG_HIERARCHY_TYPE(p_jobID,
                                             DDS_EVENT_CUR.DA_ROW_ID,
                                             v_vVal,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL);

                        BEGIN
                          DDS_PROCESSORG_HIERARCHY
                                ( v_DDS_ORG_HIERARCHY_TYPE,
                                  P_JOBID,
                                  DDS_EVENT_CUR.DA_ROW_ID,
                                  V_DBNAME,
                                 'EVENT_NUMBER',
                                  DDS_EVENT_CUR.EVENT_NUMBER,
                                 v_iEntId
                                );-- CREATE NEW ENTITY EVEN IF EXISTS
 V_ERROR_LOCATION := 'Emk7.6';
                        EXCEPTION
                           WHEN OTHERS THEN
                              V_ERROR_MESSAGE := SQLERRM;
                               DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                 p_MODULE_NAME => V_MODULENAME,
                                 p_CALLING_ERROR_LOCATION =>  'Main',
                                 p_CURRENT_ERROR_LOCATION => 'CREATEDEPT',
                                 p_ERROR_PROC_NAME => V_PROCNAME,
                                 p_ERROR_MSG =>  V_ERROR_MESSAGE,-- REQUIRED FIELD
                                 p_ERROR_COLUMNS =>  NULL,
                                 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                 P_IS_VALIDATION => 0);
                                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                        END;

                        IF v_vColName = 'DEPARTMENT' THEN
                           v_i_DEPARTMENT_GEN := v_iEntId;
                        ELSE
                           IF v_vColName = 'DEPT_INVOLVED' THEN
                              v_i_DEPT_INVOLVED_GEN := v_iEntId;
                           ELSE
                              IF v_vColName = 'FACILITY_DEPT' THEN
                                 v_i_FACILITY_DEPT_GEN := v_iEntId;
                              ELSE
                                 IF v_vColName = 'DEPT_ASSIGNED' THEN
                                    v_i_DEPT_ASSIGNED_GEN := v_iEntId;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
               END LOOP;
            END IF;


  --create dep end

                                 --);-- CREATE NEW ENTITY EVEN IF EXISTS
 V_ERROR_LOCATION := 'Emk7.7';
 BEGIN                                         -- EVD10. REPORTER ENTITY (PROCESS ENTITY)
  IF ( DDS_EVENT_CUR.REPORTED_LAST_NAME IS NOT NULL   AND DDS_EVENT_CUR.REPORTED_FIRST_NAME IS NOT NULL    AND iRptdTidErr = 0 ) THEN --AND DDS_EVENT_CUR.REPORTED_LAST_NAME <> '' AND     DDS_EVENT_CUR.REPORTED_FIRST_NAME <> ''
          --l_row := DDS_ORG_HIERARCHY_TYP('72', '100',1,1,1,1,1,1,1,1,1);
                  v_iNoError := 1 ;
                 v_ErrorColumn := null ;


          VENTITY_TYPE := DDS_ENTITY_TYPE(DDS_EVENT_CUR.REPORTED_LAST_NAME, DDS_EVENT_CUR.REPORTED_FIRST_NAME, NULL, NULL,
           DDS_EVENT_CUR.REPORTED_TAX_ID, DDS_EVENT_CUR.REPORTED_ADDR1, DDS_EVENT_CUR.REPORTED_ADDR2, DDS_EVENT_CUR.REPORTED_CITY,v_REPORTED_COUNTRY_R,
           --v_REPORTED_STATE_R, NULL,DDS_EVENT_CUR.REPORTED_ZIP_CODE,DDS_EVENT_CUR.REPORTED_PHONE,DDS_EVENT_CUR.REPORTED_PHONE2,DDS_EVENT_CUR.REPORTED_FAX, NULL, NULL, NULL, NULL, 'REPORTED_BY', NULL, NULL               JIRA 24634 knakra
           v_REPORTED_STATE_R, NULL,DDS_EVENT_CUR.REPORTED_ZIP_CODE,DDS_EVENT_CUR.REPORTED_PHONE,DDS_EVENT_CUR.REPORTED_PHONE2,DDS_EVENT_CUR.REPORTED_FAX,DDS_EVENT_CUR.REPORTED_BIRTH_DT, NULL, NULL, NULL, 'REPORTED_BY', NULL, NULL                 --JIRA 24634 knakra
             , NULL, NULL,v_NAME_TYPE_R,NULL, p_jobID,DDS_EVENT_CUR.DA_ROW_ID);

             V_ERROR_LOCATION := 'Emk7.8';
             IF v_NonEmployeeMatchByTaxId = 1 AND  DDS_EVENT_CUR.REPORTED_TAX_ID IS NULL THEN
              DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                                               p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                                               p_MODULE_NAME => V_MODULENAME,
                                               p_CALLING_ERROR_LOCATION => 'MAIN',
                                               p_CURRENT_ERROR_LOCATION => 'REPORTVD1',
                                               p_ERROR_PROC_NAME => V_PROCNAME,
                                               p_ERROR_MSG =>'Match by tax_id is checked however, REPORTED_TAX_ID is not provided. ',
                                               p_ERROR_COLUMNS => 'REPORTED_TAX_ID',
                                               p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                                               p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                                               P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                                               P_IS_VALIDATION => 1);
                                               v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                                               v_iNoError := 0 ;

             END IF ;
             IF V_iNoError = 1  THEN

                    IF v_NonEmployeeMatchByName <> 0  THEN
                      V_ErrorColumn := 'REPORTED_LAST_NAME,REPORTED_FIRST_NAME' ;
                    END IF ;
                    IF V_NonEmployeeMatchByTaxId <> 0 THEN
                        IF V_ErrorColumn is not null  THEN

                         v_ErrorColumn := v_ErrorColumn || ',' ;
                         END IF ;
                         v_ErrorColumn := v_ErrorColumn || 'REPORTED_TAX_ID' ;
                        --END IF ;
                    END IF ;
                    --JIRA 24634 knakra starts
                    IF v_NonEmpMatchByDob <> 0 THEN
                       IF v_ErrorColumn IS NOT NULL THEN
                          v_ErrorColumn := v_ErrorColumn || ',';
                       END IF;
                       v_ErrorColumn := v_ErrorColumn || 'REPORTED_BIRTH_DT';
                    END IF;
                    --JIRA 24634 knakra ends
             END  IF ;


        V_ERROR_LOCATION := 'Emk7.9';
       BEGIN
          V_CLOCATION := 'PE10';
            --PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,1,'REPORTVD1a', DDS_EVENT_CUR.EVENT_NUMBER, iEntId,V_ERROR_MESSAGE) ;   JIRA 24634 knakra
            PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,1,'REPORTVD1a', DDS_EVENT_CUR.EVENT_NUMBER,1, iEntId,V_ERROR_MESSAGE) ; --JIRA 24634 knakra
            -- CREATE NEW ENTITY EVEN IF NOT EXISTS

       EXCEPTION
          WHEN OTHERS THEN
            V_ERROR_MESSAGE :=  SQLERRM;
                DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                 p_MODULE_NAME => V_MODULENAME,
                 p_CALLING_ERROR_LOCATION =>  'Main',
                 p_CURRENT_ERROR_LOCATION => 'REPORTVD',
                 p_ERROR_PROC_NAME => V_PROCNAME,
                 p_ERROR_MSG =>  V_ERROR_MESSAGE,
                 p_ERROR_COLUMNS => NULL,
                 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                 P_IS_VALIDATION => 0);
                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
       END;
       i_Reporter_ENTITY_ID_GEN := iEntId ;
       IF (i_Reporter_ENTITY_ID_GEN = 0) THEN
          DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                 p_MODULE_NAME => V_MODULENAME,
                 p_CALLING_ERROR_LOCATION =>  'Reporter',
                 p_CURRENT_ERROR_LOCATION => 'Rep_Evnt',
                 p_ERROR_PROC_NAME => V_PROCNAME,
                 p_ERROR_MSG =>  'Either select the allow creation of new entity check box on UI/ provide a valid Entity.' , -- REQUIRED FIELD --,
                 p_ERROR_COLUMNS => NULL,
                 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                 p_ERROR_KEY_COLUMN => 'REPORTED_LAST_NAME/REPORTED_FIRST_NAME',
                 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                 P_IS_VALIDATION => 1);
                 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
      END IF;
   END IF;
 END;
         V_ERROR_LOCATION := 'Emk8.1';
         --**********************************************************************
         --*********************** EVENT VALIDATION ENDS *************************
         --***********************************************************************



    --************************************************************************
         --*********************** PERSON INVOLVED VD STARTS **********************      -- NINE BLOCKS
         --************************************************************************
 IF DDS_EVENT_CUR.PI_LAST_NAME IS NOT NULL then
   BEGIN
            v_vTableName := (CASE
                                  WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' THEN 'PATIENTS'
                                  WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' THEN 'EMPLOYEES'
                                  WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'PHYS' THEN 'PHYSICIANS'
                                  WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'W' THEN 'WITNESS'
                                   WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'D' THEN 'DRIVER' --MKAUR24 3/22/2017
                                    WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'MED' THEN 'MED_STAFF' --MKAUR24 --3/22/2017
                                  WHEN UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'O' THEN 'OTHER_PEOPLE'   END);
                     V_ERROR_LOCATION := 'Emk8.2';
                v_N_SQL := 'SELECT TABLE_ID FROM ' || V_DBNAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1' ;
                  BEGIN
                            EXECUTE IMMEDIATE v_N_SQL INTO v_iRoleTableId USING v_vTableName;
                            EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                    v_iRoleTableId :=0;
                                 WHEN OTHERS THEN
                                      V_ERROR_MESSAGE := SQLERRM;
                              DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION =>  'Main',
                             p_CURRENT_ERROR_LOCATION => 'roltblid',
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG =>  V_ERROR_MESSAGE,-- REQUIRED FIELD
                             p_ERROR_COLUMNS =>  NULL,
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 0);
                              v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                              END;
   V_ERROR_LOCATION := 'Emk8.3';
BEGIN
  v_iNoError := 1    ;
 v_ErrorColumn := null ;
  V_ERROR_LOCATION := 'Emk8.2';
IF v_vTableName = 'EMPLOYEES' THEN
             IF V_EmployeeMatchByEmpNumber = 1 AND DDS_EVENT_CUR.EMPLOYEE_NUMBER IS NULL  THEN
               DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION =>  'MAIN',
                             p_CURRENT_ERROR_LOCATION => 'PE1',
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG =>  'Match by EMPLOYEE_NUMBER is checked however, EMPLOYEE_NUMBER is not provided.',
                             p_ERROR_COLUMNS =>  'EMPLOYEE_NUMBER',
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);
                            v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                            V_iNoError := 0     ;

             END IF;
                V_ERROR_LOCATION := 'Emk8.3';
              IF DDS_EVENT_CUR.PI_TAX_ID  IS NULL  THEN --kmalick JIRA:65999
                  DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION =>  'MAIN',
                             p_CURRENT_ERROR_LOCATION => 'PE2',
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG =>  'PI_TAX_ID is mandatory for Employee.',
                             p_ERROR_COLUMNS =>  'PI_TAX_ID',
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);
                            v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                            V_iNoError := 0     ;
           END IF;
           
           
            IF V_EmployeeMatchByName <> 0 THEN
               V_ErrorColumn := 'PI_LAST_NAME,PI_FIRST_NAME' ;
             END IF;
            IF V_EmployeeMatchByEmpNumber <> 0 THEN
                    IF V_ErrorColumn is not null THEN
                       V_ErrorColumn := V_ErrorColumn || ',' ;
                     END IF;
               V_ErrorColumn := V_ErrorColumn || 'EMPLOYEE_NUMBER' ;
            END IF;
            IF V_EmployeeMatchByTaxId <> 0   THEN
              IF V_ErrorColumn is not null  THEN
                 V_ErrorColumn := V_ErrorColumn || ',' ;
               END IF;
               V_ErrorColumn := V_ErrorColumn || 'PI_TAX_ID' ;
           END IF;
           
           --JIRA 24634 knakra starts
           IF v_EmpMatchByDob <> 0 THEN
              IF V_ErrorColumn is not null  THEN
                 V_ErrorColumn := V_ErrorColumn || ',' ;
               END IF;
               V_ErrorColumn := V_ErrorColumn || 'BIRTH_DATE' ;
           END IF;
           --JIRA 24634 knakra ends

ELSE
            IF V_NonEmployeeMatchByTaxId = 1 AND  DDS_EVENT_CUR.PI_TAX_ID IS NULL AND V_CrtNwEvntPiEntyIfTxIDEmpty = 0 THEN
                      DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID,
                             p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,
                             p_MODULE_NAME => V_MODULENAME,
                             p_CALLING_ERROR_LOCATION =>  'MAIN',
                             p_CURRENT_ERROR_LOCATION => 'PE3',
                             p_ERROR_PROC_NAME => V_PROCNAME,
                             p_ERROR_MSG =>  'Match by tax_id is checked however, PI_TAX_ID is not provided.',
                             p_ERROR_COLUMNS =>  'EMPLOYEE_NUMBER',
                             p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT',
                             p_ERROR_KEY_COLUMN => 'EVENT_NUMBER',
                             P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER,
                             P_IS_VALIDATION => 1);
                            v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1;
                            V_iNoError := 0  ;
            END IF ;

            IF V_NonEmployeeMatchByName <> 0      THEN
                V_ErrorColumn := 'PI_LAST_NAME,PI_FIRST_NAME' ;
              END IF ;
            IF V_NonEmployeeMatchByTaxId <> 0 THEN
                IF V_ErrorColumn is not null THEN
                  V_ErrorColumn := V_ErrorColumn || ',' ;
                END IF ;
               V_ErrorColumn := V_ErrorColumn || 'PI_TAX_ID' ;
          END IF ;
          --JIRA 24634 knakra starts
          IF v_NonEmpMatchByDob <> 0 THEN
             IF V_ErrorColumn is not null THEN
                V_ErrorColumn := V_ErrorColumn || ',' ;
             END IF ;
             V_ErrorColumn := V_ErrorColumn || 'BIRTH_DATE' ;
          END IF;
          --JIRA 24634 knakra ends
   END IF ;

IF V_iNoError = 1 AND V_iPiTidErr = 0 THEN 
 IF ( v_CrtNwEvntPiEntyIfTxIDEmpty = 1 ) THEN--2333 
 IF ( ( DDS_EVENT_CUR.PI_TAX_ID IS NULL ) AND ( ( v_EmployeeMatchByTaxId = 1 ) OR ( v_NonEmployeeMatchByTaxId = 1 ) ) ) THEN 
 v_Forcecreate := 1; 
 ELSE 
 v_Forcecreate := 0; 
 END IF; 
 ELSE 
 v_Forcecreate := 0; 
 END IF; 
 V_ERROR_LOCATION := 'Emk8.5'; 
 v_iEntId := 0; 
 
 VENTITY_TYPE := DDS_ENTITY_TYPE(DDS_EVENT_CUR.PI_LAST_NAME, 
 DDS_EVENT_CUR.PI_FIRST_NAME, 
 DDS_EVENT_CUR.PI_MIDDLE_NAME, 
 NULL, 
 DDS_EVENT_CUR.PI_TAX_ID, 
 DDS_EVENT_CUR.PI_ADDR1, 
 DDS_EVENT_CUR.PI_ADDR2, 
 DDS_EVENT_CUR.PI_CITY, 
 null, 
 v_PI_STATE_R, 
 DDS_EVENT_CUR.COUNTY_OF_RESIDNC, 
 DDS_EVENT_CUR.PI_ZIP_CODE, 
 DDS_EVENT_CUR.PI_PHONE, 
 NULL, 
 NULL, 
 DDS_EVENT_CUR.BIRTH_DATE, 
 v_SEX_CODE_R, 
 NULL, 
 NULL, 
 v_vTableName, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 V_NAME_TYPE_R , 
 DDS_EVENT_CUR.EMPLOYEE_NUMBER, 
 p_jobID, 
 DDS_EVENT_CUR.DA_ROW_ID); 
 V_ERROR_LOCATION := 'Emk8.6'; 
 BEGIN 
 --PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,v_Forcecreate,1,'PE', DDS_EVENT_CUR.EVENT_NUMBER, iEntId,V_ERROR_MESSAGE) ; JIRA 24634 knakra 
 PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,v_Forcecreate,1,'PE', DDS_EVENT_CUR.EVENT_NUMBER,1, iEntId,V_ERROR_MESSAGE) ; --JIRA 24634 knakra 
 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PRCSENT1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 v_i_PI_TYPE_ENTITY_ID_GEN := iEntId; 
 
 IF ( v_i_PI_TYPE_ENTITY_ID_GEN = 0 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'PIVD', 
 p_CURRENT_ERROR_LOCATION => 'PI_Ent', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE, -- 
 p_ERROR_COLUMNS => V_ErrorColumn, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END IF ; 
 END IF ; 
END; 
 
--mkaur24 start 03/28/2016 (Role to component functionality) RMA-22665 
If (v_i_PI_TYPE_ENTITY_ID_GEN > 0 ) THEN 
 V_ERROR_LOCATION := 'RtComp8.1'; 
 v_iROW_ID := 0 ; 
 v_N_SQL := 'select ROW_ID from ' || V_DBNAME || 'CODE_X_CODE where REL_TYPE_CODE IN ' ; 
 v_N_SQL := v_N_SQL || '(select CODE_ID from ' || V_DBNAME || 'codes where SHORT_CODE = ' || '''RCCRT''' || ' AND table_id IN (select TABLE_ID from ' || V_DBNAME || 'glossary where system_table_name = ' || ' ''CODE_REL_TYPE'' )) ' ; 
 v_N_SQL := v_N_SQL || 'AND CODE1 IN ( select TABLE_ID from ' || V_DBNAME || 'glossary where system_table_name = ' || '''EVENT'' )' ; 
 v_N_SQL := v_N_SQL || 'AND CODE2 IN (SELECT TABLE_ID FROM ' || V_DBNAME || 'glossary where system_table_name = :1 ) AND DELETED_FLAG = 0 ' ; 
 
 V_ERROR_LOCATION := 'RtComp8.2'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_iROW_ID USING v_vTableName; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_iROW_ID :=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'RTcomp', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 V_ERROR_LOCATION := 'RtComp8.3'; 
 
 IF ( v_iROW_ID = 0 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'PIVD', 
 p_CURRENT_ERROR_LOCATION => 'RTCOMP', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'The Role to component mapping is missing for the given PI_TYPE_CODE .', -- 
 p_ERROR_COLUMNS => 'PI_TYPE_CODE', 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END IF ; 
 
V_ERROR_LOCATION := 'RtComp8.4'; 
 
END IF ; 
 
--mkaur24 END 03/28/2016 (Role to component functionality) RMA-22665 
 
 
 
 
 
IF ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' OR UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' ) THEN -- VALIDATION 2. PIVD8. HOSPITAL AND PHYS_EID VALIDATION 
 
 BEGIN-- PIVD8. HOSPITAL ERROR LOGGING 
 --DBMS_OUTPUT.PUT_LINE('HOSPITAL EID PROCESS ENTITY AND ERROR LOGGING START'); 
 v_iCount := 1; 
 WHILE ( v_iCount < 4 ) 
 LOOP 
 v_iEntId := 0; 
 v_vColName1 := 'HOSPITAL_' || v_iCount|| '_NAME'; 
 v_vColName2 := 'HOSPITAL_' || v_iCount || '_PHONE'; 
 
 v_vColName3 := v_vColName1 || ' , ' || v_vColName2; 
 
 IF v_vColName1 = 'HOSPITAL_1_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.HOSPITAL_1_NAME; 
 v_vVal2 := DDS_EVENT_CUR.HOSPITAL_1_PHONE; 
 ELSE 
 IF v_vColName1 = 'HOSPITAL_2_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.HOSPITAL_2_NAME; 
 v_vVal2 := DDS_EVENT_CUR.HOSPITAL_2_PHONE; 
 ELSE 
 IF v_vColName1 = 'HOSPITAL_3_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.HOSPITAL_3_NAME; 
 v_vVal2 := DDS_EVENT_CUR.HOSPITAL_3_PHONE; 
 END IF; 
 END IF; 
 END IF; 
 V_ERROR_LOCATION := 'Emk8.8'; 
 IF ( ( v_vVal IS NOT NULL ) AND ( v_vVal2 IS NOT NULL ) ) THEN--cww 
 v_iEntId := 0; 
 VENTITY_TYPE := DDS_ENTITY_TYPE(v_vVal, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 null, 
 NULL, 
 NULL, 
 NULL, 
 v_vVal2, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 'HOSPITAL', 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 v_NAME_TYPE_R, 
 NULL, 
 p_jobID, 
 DDS_EVENT_CUR.DA_ROW_ID); 
 
 BEGIN 
 
 --PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,0,'p', DDS_EVENT_CUR.EVENT_NUMBER, v_iEntId,V_ERROR_MESSAGE) ; JIRA 24634 knakra 
 PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,0,'p', DDS_EVENT_CUR.EVENT_NUMBER,0, v_iEntId,V_ERROR_MESSAGE) ; --JIRA 24634 knakra 
 -- **Kapil here p is in small case... don't know will it impact further processing or not 
 -- **neha p is the calling error loc 
 --mkaur24 no chnage rquired 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'HOSP1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 IF v_vColName1 = 'HOSPITAL_1_NAME' THEN 
 v_i_HOSPITAL_1_EID := v_iEntId; 
 
 ELSE 
 IF v_vColName1 = 'HOSPITAL_2_NAME' THEN 
 v_i_HOSPITAL_2_EID := v_iEntId; 
 ELSE 
 IF v_vColName1 = 'HOSPITAL_3_NAME' THEN 
 v_i_HOSPITAL_3_EID := v_iEntId; 
 END IF; 
 END IF; 
 END IF; 
 
 IF ( v_iEntId = 0 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'hosp_VD', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either select the allow creation of new entity check box on UI/ provide a valid Entity.', 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END IF; 
 ELSE 
 IF ( ( v_vVal IS NULL AND v_vVal2 IS NOT NULL ) OR ( v_vVal2 IS NULL AND v_vVal IS NOT NULL ) ) THEN 
 --DBMS_OUTPUT.PUT_LINE(' NULL ERROR START'); 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'hosp_VD', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either Provide Value In Both (Name / Phone) Or Do Not Provide In Any Of The Column.', 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 -- DBMS_OUTPUT.PUT_LINE(' PRINT NULL ERROR END LOGGED'); 
 END IF; 
 END IF; 
 v_iCount := v_iCount + 1; 
 END LOOP; 
 --DBMS_OUTPUT.PUT_LINE('HOSPITAL EID PROCESS ENTITY AND ERROR LOGGING END '); 
 END; 
 BEGIN-- PIVD9. PHYS_EID PROCESS ENTITY AND ERROR LOGGING 
 v_iCount := 1; 
 WHILE ( v_iCount < 4 ) 
 LOOP 
 BEGIN 
 v_iEntId := 0; 
 v_vColName1 := 'PHYSICIAN_' || v_iCount || '_LAST_NAME'; 
 v_vColName2 := 'PHYSICIAN_' || v_iCount || '_PHONE'; 
 v_vColName4 := 'PHYSICIAN_' || v_iCount || '_FIRST_NAME'; 
 
 v_vColName3 := v_vColName1 || ' , ' || v_vColName2 || ' , ' || v_vColName4; 
 
 IF v_vColName1 = 'PHYSICIAN_1_LAST_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.PHYSICIAN_1_LAST_NAME; 
 v_vVal2 := DDS_EVENT_CUR.PHYSICIAN_1_PHONE; 
 v_vVal3 := DDS_EVENT_CUR.PHYSICIAN_1_FIRST_NAME; 
 ELSE 
 IF v_vColName1 = 'PHYSICIAN_2_LAST_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.PHYSICIAN_2_LAST_NAME; 
 v_vVal2 := DDS_EVENT_CUR.PHYSICIAN_2_PHONE; 
 v_vVal3 := DDS_EVENT_CUR.PHYSICIAN_2_FIRST_NAME; 
 ELSE 
 IF v_vColName1 = 'PHYSICIAN_3_LAST_NAME' THEN 
 v_vVal := DDS_EVENT_CUR.PHYSICIAN_3_LAST_NAME; 
 v_vVal2 := DDS_EVENT_CUR.PHYSICIAN_3_PHONE; 
 v_vVal3 := DDS_EVENT_CUR.PHYSICIAN_3_FIRST_NAME; 
 END IF; 
 END IF; 
 END IF; 
 
 IF ( ( v_vVal IS NOT NULL ) AND ( v_vVal2 IS NOT NULL ) AND ( v_vVal3 IS NOT NULL ) ) THEN--cww 
 
 VENTITY_TYPE := DDS_ENTITY_TYPE(v_vVal, 
 v_vVal3, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 null, 
 NULL, 
 NULL, 
 NULL, 
 v_vVal2, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 'PHYSICIANS', 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 v_NAME_TYPE_R, 
 NULL, 
 p_jobID, 
 DDS_EVENT_CUR.DA_ROW_ID); 
 
 BEGIN 
 --PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,0,'physp', DDS_EVENT_CUR.EVENT_NUMBER, v_iEntId,V_ERROR_MESSAGE) ; JIRA 24634 knakra 
 PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,0,'physp', DDS_EVENT_CUR.EVENT_NUMBER,0, v_iEntId,V_ERROR_MESSAGE) ; --JIRA 24634 knakra 
 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PHYS1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 IF v_vColName1 = 'PHYSICIAN_1_LAST_NAME' THEN 
 v_i_PHYSICIAN_1_EID := v_iEntId; 
 ELSE 
 IF v_vColName1 = 'PHYSICIAN_2_LAST_NAME' THEN 
 v_i_PHYSICIAN_2_EID := v_iEntId; 
 ELSE 
 IF v_vColName1 = 'PHYSICIAN_3_LAST_NAME' THEN 
 v_i_PHYSICIAN_3_EID := v_iEntId; 
 END IF; 
 END IF; 
 END IF; 
 
 IF v_i_PHYSICIAN_1_EID > 0 THEN 
 v_i_PRI_PHYSICIAN_EID_GEN := v_i_PHYSICIAN_1_EID; 
 END IF; 
 
 IF v_i_PHYSICIAN_2_EID > 0 THEN 
 v_i_ADM_PHYSICIAN_EID_GEN := v_i_PHYSICIAN_2_EID; 
 END IF; 
 
 IF ( v_iEntId = 0 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PHYS2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either select the allow creation of new entity check box on UI/ provide a valid Entity.', 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END IF; 
 ELSE 
 IF ( v_vVal IS NULL AND v_vVal2 IS NULL AND v_vVal3 IS NULL ) THEN 
 v_i_NOTHING := 1; 
 ELSE 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PHYS3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either provide value in all (LAST_NAME/FIRST_NAME and PHONE) or do not provide values in any one.', 
 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 --DBMS_OUTPUT.PUT_LINE(' PRINT NULL ERROR END LOGGED'); 
 END IF; 
 END IF; 
 
 v_iCount := v_iCount + 1; 
 
 END; 
 END LOOP; 
 
 END; 
 END IF; 
 
-- START 3 MK 
 V_ERROR_LOCATION := 'Emk9.1'; 
IF ( ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' ) AND ( v_i_PI_TYPE_ENTITY_ID_GEN <> 0 ) ) THEN 
 BEGIN 
 -- IMPORT DATA MANUPULATION STARTS 
 -- EmpIn1. IF FLAG NULL GET VALUE FROM SYS_PARMS 
 
 v_vColList := 'WORK_SUN_FLAG|WORK_MON_FLAG|WORK_TUE_FLAG|WORK_WED_FLAG|WORK_THU_FLAG|WORK_FRI_FLAG|WORK_SAT_FLAG|'; 
 WHILE INSTR(v_vColList, '|', 1) > 0 
 LOOP 
 BEGIN 
 /* v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1); 
 v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1)));*/ 
 
 v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1); 
 v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList)); 
 
 --PRINT 'COLNAME IS : ' + @vColName 
 v_vValue := (CASE 
 ---- --WORKING 
 WHEN v_vColName = 'WORK_SUN_FLAG' THEN DDS_EVENT_CUR.WORK_SUN_FLAG 
 WHEN v_vColName = 'WORK_MON_FLAG' THEN DDS_EVENT_CUR.WORK_MON_FLAG 
 WHEN v_vColName = 'WORK_TUE_FLAG' THEN DDS_EVENT_CUR.WORK_TUE_FLAG 
 WHEN v_vColName = 'WORK_WED_FLAG' THEN DDS_EVENT_CUR.WORK_WED_FLAG 
 WHEN v_vColName = 'WORK_THU_FLAG' THEN DDS_EVENT_CUR.WORK_THU_FLAG 
 WHEN v_vColName = 'WORK_FRI_FLAG' THEN DDS_EVENT_CUR.WORK_FRI_FLAG 
 WHEN v_vColName = 'WORK_SAT_FLAG' THEN DDS_EVENT_CUR.WORK_SAT_FLAG END); 
 
 IF v_vValue IS NULL THEN 
 v_vColName := SUBSTR(v_vColName, 1, 8); 
 --PRINT '@vColName AFTR BRK : ' + @vColName 
 v_N_SQL := 'SELECT ' || v_vColName || ' FROM ' || V_DBName || ' SYS_PARMS '; 
 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL INTO v_vColName_value; 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'FLAGVALUE', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 IF v_vColName = 'WORK_SUN' THEN 
 v_WORK_SUN_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_MON' THEN 
 v_WORK_MON_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_TUE' THEN 
 v_WORK_TUE_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_WED' THEN 
 v_WORK_WED_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_THU' THEN 
 v_WORK_THU_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_FRI' THEN 
 v_WORK_FRI_FLAG_GEN := v_vColName_value; 
 ELSIF v_vColName = 'WORK_SAT' THEN 
 v_WORK_SAT_FLAG_GEN := v_vColName_value; 
 END IF; 
 END IF; 
 END; 
 END LOOP; 
 BEGIN-- EmpIn2. IF FLAG Y/N SET VALUES 
 
 IF UPPER(DDS_EVENT_CUR.WORK_SUN_FLAG) = 'Y' THEN 
 v_WORK_SUN_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_SUN_FLAG) = 'N' THEN 
 v_WORK_SUN_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_MON_FLAG) = 'Y' THEN 
 v_WORK_MON_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_MON_FLAG) = 'N' THEN 
 v_WORK_MON_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_TUE_FLAG) = 'Y' THEN 
 v_WORK_TUE_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_TUE_FLAG) = 'N' THEN 
 v_WORK_TUE_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_WED_FLAG) = 'Y' THEN 
 v_WORK_WED_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_WED_FLAG) = 'N' THEN 
 v_WORK_WED_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_THU_FLAG) = 'Y' THEN 
 v_WORK_THU_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_THU_FLAG) = 'N' THEN 
 v_WORK_THU_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_FRI_FLAG) = 'Y' THEN 
 v_WORK_FRI_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_FRI_FLAG) = 'N' THEN 
 v_WORK_FRI_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.WORK_SAT_FLAG) = 'Y' THEN 
 v_WORK_SAT_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.WORK_SAT_FLAG) = 'N' THEN 
 v_WORK_SAT_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 --******************* 
 IF UPPER(DDS_EVENT_CUR.FULL_TIME_FLAG) = 'Y' THEN 
 v_FULL_TIME_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.FULL_TIME_FLAG) = 'N' THEN 
 v_FULL_TIME_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.ACTIVE_FLAG) = 'Y' THEN 
 v_ACTIVE_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.ACTIVE_FLAG) = 'N' THEN 
 v_ACTIVE_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.EXEMPT_STATUS_FLAG) = 'Y' THEN 
 v_EXEMPT_STATUS_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.EXEMPT_STATUS_FLAG) = 'N' THEN 
 v_EXEMPT_STATUS_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.INSURABLE_FLAG) = 'Y' THEN 
 v_INSURABLE_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.INSURABLE_FLAG) = 'N' THEN 
 v_INSURABLE_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.REGULAR_JOB_FLAG) = 'Y' THEN 
 v_REGULAR_JOB_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.REGULAR_JOB_FLAG) = 'N' THEN 
 v_REGULAR_JOB_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.HIRED_IN_STATE_FLAG) = 'Y' THEN 
 v_HIRED_IN_STATE_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.HIRED_IN_STATE_FLAG) = 'N' THEN 
 v_HIRED_IN_STATE_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 
 IF UPPER(DDS_EVENT_CUR.LOST_WORK_FLAG) = 'Y' THEN 
 v_LOST_WORK_FLAG_GEN := -1; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.LOST_WORK_FLAG) = 'N' THEN 
 v_LOST_WORK_FLAG_GEN := 0; 
 END IF; 
 END IF; 
 END; 
 
 V_ERROR_LOCATION := 'Emk9.2'; 
 
 
 IF UPPER(DDS_EVENT_CUR.LOST_WORK_FLAG ) = 'Y' THEN 
 v_LOST_WORK_FLAG_GEN := -1 ; 
 ELSE 
 IF UPPER(DDS_EVENT_CUR.LOST_WORK_FLAG ) = 'N' THEN 
 v_LOST_WORK_FLAG_GEN := 0 ; 
 END IF ; 
 END IF ; 
 
 IF ( v_LOST_WORK_FLAG_GEN <> 0 ) THEN -- PIVD5. WORK LOSS 
 v_I_UPDATE_FLAG := 0; 
 v_vColName1 := 'DATE_LAST_WORKED'; 
 v_vColName2 := 'DATE_RETURNED'; 
 v_iCount := 1; 
 WHILE v_iCount <= 15 
 LOOP 
 v_vColToProcess := v_vColName1 || '_' || v_iCount; 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_1' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_1 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_2' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_2 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_3' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_3 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_4' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_4 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_5' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_5 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_6' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_6 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_7' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_7 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_8' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_8 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_9' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_9 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_10' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_10 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_11' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_11 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_12' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_12 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_13' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_13 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_14' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_14 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_15' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_15 END); 
 
 v_vColToProcess1 := v_vColName2 || '_' || v_iCount; 
 v_vColName3 := v_vColToProcess || ' , ' || v_vColToProcess1; 
 V_ERROR_LOCATION := 'Emk9.3'; 
 v_vVal2 := (CASE 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_1' THEN DDS_EVENT_CUR.DATE_RETURNED_1 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_2' THEN DDS_EVENT_CUR.DATE_RETURNED_2 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_3' THEN DDS_EVENT_CUR.DATE_RETURNED_3 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_4' THEN DDS_EVENT_CUR.DATE_RETURNED_4 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_5' THEN DDS_EVENT_CUR.DATE_RETURNED_5 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_6' THEN DDS_EVENT_CUR.DATE_RETURNED_6 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_7' THEN DDS_EVENT_CUR.DATE_RETURNED_7 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_8' THEN DDS_EVENT_CUR.DATE_RETURNED_8 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_9' THEN DDS_EVENT_CUR.DATE_RETURNED_9 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_10' THEN DDS_EVENT_CUR.DATE_RETURNED_10 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_11' THEN DDS_EVENT_CUR.DATE_RETURNED_11 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_12' THEN DDS_EVENT_CUR.DATE_RETURNED_12 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_13' THEN DDS_EVENT_CUR.DATE_RETURNED_13 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_14' THEN DDS_EVENT_CUR.DATE_RETURNED_14 
 WHEN v_vColToProcess1 = 'DATE_RETURNED_15' THEN DDS_EVENT_CUR.DATE_RETURNED_15 END); 
 
 v_iCount2 := v_iCount + 1; 
 
 v_vColToProcess2 := v_vColName1 || '_' || v_iCount2; 
 
 v_vVal3 := (CASE 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_1' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_1 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_2' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_2 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_3' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_3 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_4' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_4 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_5' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_5 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_6' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_6 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_7' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_7 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_8' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_8 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_9' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_9 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_10' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_10 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_11' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_11 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_12' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_12 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_13' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_13 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_14' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_14 
 WHEN v_vColToProcess2 = 'DATE_LAST_WORKED_15' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_15 END); 
 
 v_iCount2 := v_iCount + 1; 
 
 v_vColToProcess2 := v_vColName2 || '_' || v_iCount2; 
 
 v_vVal4 := (CASE 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_1' THEN DDS_EVENT_CUR.DATE_RETURNED_1 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_2' THEN DDS_EVENT_CUR.DATE_RETURNED_2 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_3' THEN DDS_EVENT_CUR.DATE_RETURNED_3 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_4' THEN DDS_EVENT_CUR.DATE_RETURNED_4 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_5' THEN DDS_EVENT_CUR.DATE_RETURNED_5 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_6' THEN DDS_EVENT_CUR.DATE_RETURNED_6 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_7' THEN DDS_EVENT_CUR.DATE_RETURNED_7 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_8' THEN DDS_EVENT_CUR.DATE_RETURNED_8 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_9' THEN DDS_EVENT_CUR.DATE_RETURNED_9 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_10' THEN DDS_EVENT_CUR.DATE_RETURNED_10 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_11' THEN DDS_EVENT_CUR.DATE_RETURNED_11 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_12' THEN DDS_EVENT_CUR.DATE_RETURNED_12 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_13' THEN DDS_EVENT_CUR.DATE_RETURNED_13 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_14' THEN DDS_EVENT_CUR.DATE_RETURNED_14 
 WHEN v_vColToProcess2 = 'DATE_RETURNED_15' THEN DDS_EVENT_CUR.DATE_RETURNED_15 END); 
 
 V_ERROR_LOCATION := 'Emk9.4'; 
 IF ( v_vVal IS NOT NULL AND v_vVal2 IS NULL ) OR ( v_vVal2 IS NOT NULL AND v_vVal IS NULL ) THEN 
 -- DBMS_OUTPUT.PUT_LINE(' NULL ERROR START'); 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'EVENT_LOC', 
 p_CURRENT_ERROR_LOCATION => 'WORKLOSS1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either provide values in both (DATE_LAST_WORKED and DATE_RETURNED) or do not provide values in any one.', 
 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 --DBMS_OUTPUT.PUT_LINE(' PRINT NULL ERROR END LOGGED'); 
 
 ELSE 
 IF ( ( v_vVal > v_vVal2 ) ) THEN 
 --DATE_LAST_WORKED SHOULD BE LESS THAN DATE_RETURNED 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'EVENT_LOC', 
 p_CURRENT_ERROR_LOCATION => 'WORKLOSS2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'DATE_LAST_WORKED should not be earlier than the previous DATE_RETURN.', 
 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 ELSE 
 v_i_CheckNext := 1; 
 END IF; 
 END IF; 
 V_ERROR_LOCATION := 'Emk9.5'; 
IF v_i_CheckNext = 1 THEN 
 
 DDS_DURATION (P_JOBID, DDS_EVENT_CUR.DA_ROW_ID , V_DBName, V_MODULENAME, 'EVENT_NUMBER' ,DDS_EVENT_CUR.EVENT_NUMBER , V_vVal, V_vVal2 , 
 v_WORK_MON_FLAG_GEN ,v_WORK_TUE_FLAG_GEN , v_WORK_WED_FLAG_GEN , v_WORK_THU_FLAG_GEN , v_WORK_FRI_FLAG_GEN , v_WORK_SAT_FLAG_GEN , v_WORK_SUN_FLAG_GEN , V_I_DEPT_ASSIGNED_GEN , V_DURATION ) ; -- COME3 
 
 
 IF V_DURATION < 0 THEN 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END IF ; 
 END IF ; 
 
 
 V_ERROR_LOCATION := 'Emk9.6'; 
 IF ( v_vVal3 IS NOT NULL AND v_vVal4 IS NOT NULL ) AND v_i_CheckNext = 1 THEN 
 IF ( v_vVal3 < v_vVal2 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'EVENT_LOC', 
 p_CURRENT_ERROR_LOCATION => 'WORKLOSS3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either provide values in both (DATE_LAST_WORKED / DATE_RETURNED) or do not provide value for any one.', 
 
 p_ERROR_COLUMNS => v_vColName3, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 -- DBMS_OUTPUT.PUT_LINE(' PRINT NULL ERROR END LOGGED'); 
 END IF; 
 END IF; 
 
 v_iCount := v_iCount + 1; 
 V_i_CheckNext := 0 ; 
 END LOOP; 
 V_ERROR_LOCATION := 'Emk9.7'; 
 
 
 
 END IF; --MK 
 V_ERROR_LOCATION := 'Emk9.8'; 
 V_iSuperVisorError := 0 ; 
 BEGIN -- PIVD6. PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR 
 IF ( DDS_EVENT_CUR.SUPER_TAX_ID IS NOT NULL 
 AND DDS_EVENT_CUR.SUPER_LAST_NAME IS NOT NULL 
 AND DDS_EVENT_CUR.SUPER_FIRST_NAME IS NOT NULL 
 AND V_iSvTidErr = 0 ) THEN 
 v_iEntId := 0; 
 
 IF DDS_EVENT_CUR.SUPER_EMP_NO IS NULL THEN 
 v_SUPER_EMP_NO := DDS_EVENT_CUR.SUPER_TAX_ID; 
 END IF; 
 V_ERROR_LOCATION := 'Emk9.9'; 
 VENTITY_TYPE := DDS_ENTITY_TYPE(DDS_EVENT_CUR.SUPER_LAST_NAME, 
 DDS_EVENT_CUR.SUPER_FIRST_NAME, 
 NULL, 
 NULL, 
 DDS_EVENT_CUR.SUPER_TAX_ID, 
 DDS_EVENT_CUR.SUPER_ADDR1, 
 DDS_EVENT_CUR.SUPER_ADDR2, 
 DDS_EVENT_CUR.SUPER_CITY, 
 null, 
 v_SUPER_STATE_R, 
 DDS_EVENT_CUR.COUNTY_OF_RESIDNC, 
 DDS_EVENT_CUR.SUPER_ZIP_CODE, 
 DDS_EVENT_CUR.SUPER_PHONE1, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 v_vTableName, 
 NULL, 
 NULL, 
 NULL, 
 NULL, 
 V_NAME_TYPE_R, 
 v_SUPER_EMP_NO, 
 p_jobID, 
 DDS_EVENT_CUR.DA_ROW_ID); 
 
 
 V_ERROR_LOCATION := 'Emk10.1'; 
 BEGIN 
 --PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,1, 'sp', DDS_EVENT_CUR.EVENT_NUMBER, iEntId,V_ERROR_MESSAGE) ; JIRA 24634 knakra 
 PROCESS_ENTITY(VENTITY_TYPE, p_jobID, DDS_EVENT_CUR.DA_ROW_ID, V_DBName, V_MODULENAME,0,1, 'sp', DDS_EVENT_CUR.EVENT_NUMBER,0, iEntId,V_ERROR_MESSAGE) ; --JIRA 24634 knakra 
 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PRCSENT4', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 v_iSuperVisorError := 1 ; 
 END; 
 
 v_i_SUPERVISOR_ENTITY_ID_GEN := iEntId; 
V_ERROR_LOCATION := 'Emk10.2'; 
 IF ( v_i_SUPERVISOR_ENTITY_ID_GEN = 0 ) THEN--THEN ERROR LOG 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'ENTITYSUPER', 
 p_CURRENT_ERROR_LOCATION => 'ENTITYSUPER1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Either select the allow creation of new entity check box on UI/ provide a valid Entity.', 
 p_ERROR_COLUMNS => DDS_EVENT_CUR.SUPER_LAST_NAME, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_iSuperVisorError := 1 ; 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 --3.D. PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR 
 END IF; 
 END IF; 
END; 
--END --3.D. PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR 
 IF ( v_i_SUPERVISOR_ENTITY_ID_GEN > 0 ) AND ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' ) THEN-- CHECK EXISTENCE AND LOG ERROR IF EMPLOYEE NO. ATTACHED TO SOME OTHER ENTITY. 
 v_i_EMPLOYEE_EID := 0; 
 v_N_SQL := 'SELECT EMPLOYEE_EID FROM ' || V_DBName || 'EMPLOYEE'; 
 v_N_SQL := v_N_SQL || ' WHERE EMPLOYEE_EID = :1'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EMPLOYEE_EID USING v_i_SUPERVISOR_ENTITY_ID_GEN; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EMPLOYEE_EID:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'SUPREXIST', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; 
 END; 
 
V_ERROR_LOCATION := 'Emk10.2'; 
 IF v_i_EMPLOYEE_EID = 0 THEN--WOK 
 v_i_EMPLOYEE_EID_EN := 0; 
 v_N_SQL := 'SELECT EMPLOYEE_EID FROM ' || V_DBName || 'EMPLOYEE'; 
 v_N_SQL := v_N_SQL || ' WHERE EMPLOYEE_NUMBER = :1'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EMPLOYEE_EID_EN USING v_EMPLOYEE_NUMBER; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EMPLOYEE_EID_EN:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'SUPREXIST2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; 
 END; 
 
 IF ( V_i_EMPLOYEE_EID_EN > 0 ) THEN 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'SUPRVD', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'Employee Number for Supervisor is already associated with another employee.' , 
 
 p_ERROR_COLUMNS => DDS_EVENT_CUR.EMPLOYEE_NUMBER, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; -- TILL DATEMK 
 ELSE 
 v_i_EMPLOYEE_EID_UPDATE := 1 ; 
 END IF; 
 END IF; 
 END IF; 
 
V_ERROR_LOCATION := 'Emk10.3'; 
 
 IF ( v_i_PI_TYPE_ENTITY_ID_GEN > 0 ) AND ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' ) AND v_iSuperVisorError = 0 AND v_iSvTidErr = 0 THEN --4 
 
 v_i_EMPLOYEE_EID := 0; 
 v_N_SQL := 'SELECT EMPLOYEE_EID FROM ' || V_DBName || 'EMPLOYEE'; 
 v_N_SQL := v_N_SQL || ' WHERE EMPLOYEE_EID = :1'; 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EMPLOYEE_EID USING v_i_PI_TYPE_ENTITY_ID_GEN; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EMPLOYEE_EID:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'EMPEXIST', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; 
 END; 
 IF ( v_i_EMPLOYEE_EID = 0 ) THEN --3 
 v_i_EMPLOYEE_EID_EN := 0; 
 v_N_SQL := 'SELECT EMPLOYEE_EID FROM ' || V_DBName || ' EMPLOYEE'; 
 v_N_SQL := v_N_SQL || ' WHERE EMPLOYEE_NUMBER = :1'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EMPLOYEE_EID_EN USING v_EMPLOYEE_NUMBER; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EMPLOYEE_EID_EN:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'EMPEXIST2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; 
 END; 
 IF ( v_i_EMPLOYEE_EID_EN > 0 ) THEN --1 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'EMPEXIST3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => 'The provided Employee No. is associated with some other Employe_id.Pleas provide a valid Employee No.', 
 p_ERROR_COLUMNS => DDS_EVENT_CUR.EMPLOYEE_NUMBER, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 1); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 V_iSuperVisorError := 1 ; 
 ELSE 
 v_i_UPDATE_FLAG_EMP := 0; 
 END IF; --1 
 END IF; --3 
 IF v_i_EMPLOYEE_EID > 0 THEN --2 
 v_i_UPDATE_FLAG_EMP := 1;-- EMP EXISTS UPDATE IT 
 END IF; --2 
 END IF; --4 
 
 END; 
 END IF; 
 V_ERROR_LOCATION := 'Emk10.4'; 
-- END 3 MK 
--DONE 
END ; 
 
 
END IF ; 
 
 
 --************************************************************************* 
 --******************* PERSON INVOLVED VD ENDS ***************************** 
 --************************************************************************* 
 
 
 
 
 --************************************************************************* 
 --******************* EMPLOYEE INSERT STARTS ***************************** -- SEVEN BLOCKS 
 --************************************************************************* 
 V_ERROR_LOCATION := 'Emk10.5'; 
IF ( ( v_i_PI_TYPE_ENTITY_ID_GEN > 0 ) AND ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' ) ) THEN 
 --BEGIN -- Abhishek: Done. Kapil remove begin end 
 
 IF ( v_i_SUPERVISOR_ENTITY_ID_GEN <> 0 ) AND ( v_i_EMPLOYEE_EID_UPDATE = 1 ) AND V_iSuperVisorError = 0 THEN-- SUPERVISOR DOES NOT EXISTS AS AN EMP SO, INSERT /CREATE SUPERVISOR (ELSE IF IT EXISTS DO NOTHING) 
 dbms_output.put_line ('SUPERVISOR_ENTITY_ID_GEN entered '); 
 v_N_SQL_EVENT := ' INSERT INTO ' || V_DBNAME || 'EMPLOYEE ( EMPLOYEE_EID , EMPLOYEE_NUMBER )'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES ( :1, :2 ) '; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_SUPERVISOR_ENTITY_ID_GEN, v_SUPER_EMP_NO; 
 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'SUPRINS', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 v_iSuperVisorError := 1 ; 
 END; 
 END IF; 
 
 V_ERROR_LOCATION := 'Emk10.6'; 
 
 
 
 
 IF ( v_i_UPDATE_FLAG_EMP = 0 )AND v_iSuperVisorError = 0 THEN-- EmpIn5. INSERT Employee 
 
 v_N_SQL_EVENT := ' INSERT INTO ' || V_DBNAME || 'EMPLOYEE ( COUNTY_OF_RESIDNC,DRIVLIC_STATE,INSURABLE_FLAG,LAST_VERIFIED_DATE,WORK_PERMIT_DATE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WORK_PERMIT_NUMBER,EMPLOYEE_EID,ACTIVE_FLAG,EMPLOYEE_NUMBER,MARITAL_STAT_CODE,DATE_HIRED,POSITION_CODE,DEPT_ASSIGNED_EID,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' EXEMPT_STATUS_FLAG,NO_OF_EXEMPTIONS,FULL_TIME_FLAG,HOURLY_RATE,WEEKLY_HOURS,WEEKLY_RATE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WORK_SUN_FLAG,WORK_MON_FLAG,WORK_TUE_FLAG,WORK_WED_FLAG,WORK_THU_FLAG,WORK_FRI_FLAG,WORK_SAT_FLAG,PAY_TYPE_CODE,PAY_AMOUNT,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' DRIVERS_LIC_NO,DRIVERSLICTYPECODE,DATE_DRIVERSLICEXP,DRIVLIC_RSTRCTCODE ,NCCI_CLASS_CODE,NUM_OF_VIOLATIONS , DATE_OF_DEATH)'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES (:1, :2, :3 , :4, '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :5 , :6 ,:7 , :8 , :9,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :10, :11, :12 , :13, :14,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :15, :16, :17, :18, :19, :20,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :21, :22, :23, :24, :25, :26, :27,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :28, :29, :30 , :31 , :32 ,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :33 , :34 , :35 )'; 
 
 BEGIN 
 --PRINT '@N_SQL_EVENT ERE ' + @N_SQL_EVENT 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING DDS_EVENT_CUR.COUNTY_OF_RESIDNC, 
 v_DRIVLIC_STATE_R, 
 v_INSURABLE_FLAG_GEN, 
 DDS_EVENT_CUR.LAST_VERIFIED_DATE, 
 DDS_EVENT_CUR.WORK_PERMIT_DATE, 
 DDS_EVENT_CUR.WORK_PERMIT_NUMBER, 
 v_i_PI_TYPE_ENTITY_ID_GEN, 
 v_ACTIVE_FLAG_GEN, 
 DDS_EVENT_CUR.EMPLOYEE_NUMBER, 
 v_MARITAL_STAT_CODE_R, 
 DDS_EVENT_CUR.DATE_HIRED, 
 v_POSITION_CODE_R, 
 v_i_DEPT_ASSIGNED_GEN, 
 v_EXEMPT_STATUS_FLAG_GEN, 
 DDS_EVENT_CUR.NO_OF_EXEMPTIONS, 
 v_FULL_TIME_FLAG_GEN, 
 DDS_EVENT_CUR.HOURLY_RATE, 
 DDS_EVENT_CUR.WEEKLY_HOURS, 
 DDS_EVENT_CUR.WEEKLY_RATE, 
 v_WORK_SUN_FLAG_GEN, 
 v_WORK_MON_FLAG_GEN, 
 v_WORK_TUE_FLAG_GEN, 
 v_WORK_WED_FLAG_GEN, 
 v_WORK_THU_FLAG_GEN, 
 v_WORK_FRI_FLAG_GEN, 
 v_WORK_SAT_FLAG_GEN, 
 v_PAY_TYPE_CODE_R, 
 DDS_EVENT_CUR.PAY_AMOUNT, 
 DDS_EVENT_CUR.DRIVERS_LIC_NO, 
 v_DRIVERSLICTYPECODE_R, 
 DDS_EVENT_CUR.DATE_DRIVERSLICEXP, 
 v_DRIVLIC_RSTRCT_CODE_R, 
 v_NCCI_CLASS_CODE_R, 
 DDS_EVENT_CUR.NUM_OF_VIOLATION, 
 DDS_EVENT_CUR.DATE_OF_DEATH; 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'INSEMP', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 ELSE 
 IF ( v_i_UPDATE_FLAG_EMP = 1 )AND v_iSuperVisorError = 0 THEN-- EmpIn6. Update Employee 
 
 v_N_SQL := ' UPDATE ' || V_DBNAME || 'EMPLOYEE SET EMPLOYEE_EID = ' || v_i_PI_TYPE_ENTITY_ID_GEN ; 
 
 IF DDS_EVENT_CUR.COUNTY_OF_RESIDNC IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,COUNTY_OF_RESIDNC = '||''''||DDS_EVENT_CUR.COUNTY_OF_RESIDNC||''''; 
 
 END IF; 
 IF v_DRIVLIC_STATE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DRIVLIC_STATE = '||v_DRIVLIC_STATE_R; 
 
 END IF; 
 
 IF v_INSURABLE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,INSURABLE_FLAG = '||v_INSURABLE_FLAG_GEN; 
 
 END IF; 
 
 IF DDS_EVENT_CUR.LAST_VERIFIED_DATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,LAST_VERIFIED_DATE = '||''''||DDS_EVENT_CUR.LAST_VERIFIED_DATE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'LAST_VERIFIED_DATE = :4,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.WORK_PERMIT_DATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_PERMIT_DATE = '||''''||DDS_EVENT_CUR.WORK_PERMIT_DATE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_PERMIT_DATE = :5,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.WORK_PERMIT_NUMBER IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,WORK_PERMIT_NUMBER = '||''''||DDS_EVENT_CUR.WORK_PERMIT_NUMBER||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_PERMIT_NUMBER = :6,'; 
 END IF; 
 
 IF v_ACTIVE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ACTIVE_FLAG = '||v_ACTIVE_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'ACTIVE_FLAG = :7,'; 
 END IF; 
 
 --IF @v_EMPLOYEE_NUMBER IS NOT NULL 
 --SET @N_SQL_EVENT = @N_SQL_EVENT + 'EMPLOYEE_NUMBER = @v_EMPLOYEE_NUMBER_P,' 
 IF v_MARITAL_STAT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', MARITAL_STAT_CODE = '||v_MARITAL_STAT_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'MARITAL_STAT_CODE = :8,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_HIRED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DATE_HIRED = '||''''||DDS_EVENT_CUR.DATE_HIRED||''''; 
 END IF; 
 
 IF v_POSITION_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', POSITION_CODE = '||v_POSITION_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'POSITION_CODE = :10,'; 
 END IF; 
 
 IF v_i_DEPT_ASSIGNED_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DEPT_ASSIGNED_EID = '||v_i_DEPT_ASSIGNED_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DEPT_ASSIGNED_EID = :11,'; 
 END IF; 
 
 IF v_EXEMPT_STATUS_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EXEMPT_STATUS_FLAG = '||v_EXEMPT_STATUS_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'EXEMPT_STATUS_FLAG = :12,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.NO_OF_EXEMPTIONS IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NO_OF_EXEMPTIONS = '||DDS_EVENT_CUR.NO_OF_EXEMPTIONS; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'NO_OF_EXEMPTIONS = :13,'; 
 END IF; 
 
 IF v_FULL_TIME_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', FULL_TIME_FLAG = '||v_FULL_TIME_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'FULL_TIME_FLAG = :14 ,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.HOURLY_RATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', HOURLY_RATE = '||DDS_EVENT_CUR.HOURLY_RATE; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'HOURLY_RATE = :15,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.WEEKLY_HOURS IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WEEKLY_HOURS = '||DDS_EVENT_CUR.WEEKLY_HOURS; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WEEKLY_HOURS = :16,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.WEEKLY_RATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WEEKLY_RATE = '||DDS_EVENT_CUR.WEEKLY_RATE; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WEEKLY_RATE = :17,'; 
 
 END IF; 
 
 IF v_WORK_SUN_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' , WORK_SUN_FLAG = '||v_WORK_SUN_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_SUN_FLAG = :18,'; 
 END IF; 
 
 IF v_WORK_MON_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_MON_FLAG = '||v_WORK_MON_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_MON_FLAG = :19,'; 
 END IF; 
 
 IF v_WORK_TUE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,WORK_TUE_FLAG = '||v_WORK_TUE_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_TUE_FLAG = :20,'; 
 END IF; 
 
 IF v_WORK_WED_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,WORK_WED_FLAG = '||v_WORK_WED_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_WED_FLAG = :21,'; 
 END IF; 
 
 IF v_WORK_THU_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_THU_FLAG = '||v_WORK_THU_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_THU_FLAG = :22,'; 
 END IF; 
 
 IF v_WORK_FRI_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_FRI_FLAG = '||v_WORK_FRI_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_FRI_FLAG = :23,'; 
 END IF; 
 
 IF v_WORK_SAT_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_SAT_FLAG = '||v_WORK_SAT_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_SAT_FLAG = :24,'; 
 END IF; 
 
 IF v_PAY_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,PAY_TYPE_CODE = '||v_PAY_TYPE_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'PAY_TYPE_CODE = :25,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.PAY_AMOUNT IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,PAY_AMOUNT = '||DDS_EVENT_CUR.PAY_AMOUNT; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PAY_AMOUNT = :26,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DRIVERS_LIC_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DRIVERS_LIC_NO = '||''''||DDS_EVENT_CUR.DRIVERS_LIC_NO||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DRIVERS_LIC_NO = :27,'; 
 END IF; 
 
 IF v_DRIVERSLICTYPECODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DRIVERSLICTYPECODE = '||v_DRIVERSLICTYPECODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DRIVERSLICTYPECODE = :28,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_DRIVERSLICEXP IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DATE_DRIVERSLICEXP = '||''''||DDS_EVENT_CUR.DATE_DRIVERSLICEXP||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_DRIVERSLICEXP = :29,'; 
 END IF; 
 
 IF v_DRIVLIC_RSTRCT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DRIVLIC_RSTRCTCODE = '||v_DRIVLIC_RSTRCT_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DRIVLIC_RSTRCTCODE = :30,'; 
 END IF; 
 
 IF v_NCCI_CLASS_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,NCCI_CLASS_CODE = '||v_NCCI_CLASS_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'NCCI_CLASS_CODE = :31,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_OF_DEATH IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,DATE_OF_DEATH = '||''''||DDS_EVENT_CUR.DATE_OF_DEATH||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_OF_DEATH = :32,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.NUM_OF_VIOLATION IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NUM_OF_VIOLATIONS = '||''''||DDS_EVENT_CUR.NUM_OF_VIOLATION||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_OF_DEATH = :32,'; 
 END IF; 
 
 v_N_SQL := v_N_SQL || ' WHERE EMPLOYEE_EID = :33 '; --DOUBTMK 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL USING v_i_PI_TYPE_ENTITY_ID_GEN; 
 /* DDS_EVENT_CUR.COUNTY_OF_RESIDNC, 
 v_DRIVLIC_STATE_R, 
 v_INSURABLE_FLAG_GEN, 
 DDS_EVENT_CUR.LAST_VERIFIED_DATE, 
 DDS_EVENT_CUR.WORK_PERMIT_DATE, 
 DDS_EVENT_CUR.WORK_PERMIT_NUMBER, 
 --v_i_PI_TYPE_ENTITY_ID_GEN, 
 v_ACTIVE_FLAG_GEN, 
 v_MARITAL_STAT_CODE_R, 
 DDS_EVENT_CUR.DATE_HIRED, 
 v_POSITION_CODE_R, 
 v_i_DEPT_ASSIGNED_GEN, 
 v_EXEMPT_STATUS_FLAG_GEN, 
 DDS_EVENT_CUR.NO_OF_EXEMPTIONS, 
 v_FULL_TIME_FLAG_GEN, 
 DDS_EVENT_CUR.HOURLY_RATE, 
 DDS_EVENT_CUR.WEEKLY_HOURS, 
 DDS_EVENT_CUR.WEEKLY_RATE, 
 v_WORK_SUN_FLAG_GEN, 
 v_WORK_MON_FLAG_GEN, 
 v_WORK_TUE_FLAG_GEN, 
 v_WORK_WED_FLAG_GEN, 
 v_WORK_THU_FLAG_GEN, 
 v_WORK_FRI_FLAG_GEN, 
 v_WORK_SAT_FLAG_GEN, 
 v_PAY_TYPE_CODE_R, 
 DDS_EVENT_CUR.PAY_AMOUNT, 
 DDS_EVENT_CUR.DRIVERS_LIC_NO, 
 v_DRIVERSLICTYPECODE_R, 
 DDS_EVENT_CUR.DATE_DRIVERSLICEXP, 
 v_DRIVLIC_RSTRCT_CODE_R, 
 v_NCCI_CLASS_CODE_R, 
 DDS_EVENT_CUR.DATE_OF_DEATH,*/ 
 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'UPDEMP', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 END IF; 
 END IF; 
 V_ERROR_LOCATION := 'Emk10.7'; 
 --END; 
END IF; 
 
 
 --************************************************************************* 
 --******************* EMPLOYEE INSERT ENDS ***************************** -- SEVEN BLOCKS 
 --************************************************************************* 
 
 
 --******************************* Supplemental Validation call Start********************************** 
 V_ERROR_LOCATION := 'Emk10.8'; 
 IF ( v_EVENT_SUPP <> 0 ) THEN 
 BEGIN 
 DDS_SUPPLEMENT(P_JOBID => P_JOBID, 
 P_CONFIG_ID => v_CONFIG_ID, 
 P_USER_ID => V_USER_ID, 
 P_MODULE_NAME => 'EVENT', 
 P_DB_NAME => V_DBName, 
 P_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,-- Row to be executed -- MapFlag should be 0 if you dont want to execute it 
 P_CODE_CREATION_FLAG => v_CheckCreateNewCodes, 
 --P_LOB => DDS_EVENT_CUR.LINE_OF_BUS_CODE, --neha 02/26 
 P_LOB =>0, --neha 02/26 
 P_BASE_ERROR_COUNT => v_I_ERRORCOUNT, 
 P_STAGE => 'V',-- V for validation and I for Insert 
 P_CLAIMANT_EID => 0, 
 P_EVENT_ID => 0, 
 P_CLAIM_ID => 0, 
 P_EMPLOYEE_EID => 0, 
 P_UNIT_ID => 0, 
 P_ENTITY_ID => 0, 
 P_DEFENDANT_ROW_ID => 0, 
 P_PI_ROW_ID => 0, 
 P_PI_PROC_ROW_ID => 0, 
 P_PATIENT_ID => 0, 
 P_TRANS_ID => 0, 
 P_PLAN_ID => 0, 
 P_EV_CONCOM_ROW_ID => 0, 
 P_EV_MW_TEST_ROW_ID => 0, 
 P_KEYCOLUMN => 'EVENT_NUMBER', 
 P_KEYVALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_SUPP_ERROR_COUNT => V_P_SUPP_ERROR_COUNT_R); 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'SUPPLEMENTALCALLING1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 END IF; 
 V_ERROR_LOCATION := 'Emk10.9'; 
 --******************************* Supplemental Validation call ENDS********************************** 
 
 
 
 v_I_ERRORCOUNT := NVL(v_P_SUPP_ERROR_COUNT_R,0) + v_I_ERRORCOUNT; 
 
 
-- v_I_ERRORCOUNT := 0 ; 
 V_ERROR_LOCATION := 'Emk11.1'; 
 BEGIN -- INSERT STATEMENT'S TRY CATCH 
 
 V_ERROR_LOCATION := 'INS1' ; 
 --************************************************************************* 
 --******************* IMPORT EVENT STARTS ***************************** -- Eight Blocks 
 --************************************************************************* 
 IF ( v_I_ERRORCOUNT = 0 ) THEN 
 BEGIN --EI1. IMPORT DATA MANUPULATION 
 
 IF ( UPPER(DDS_EVENT_CUR.ON_PREMISE_FLAG) = 'Y' ) THEN 
 v_I_ON_PREMISE_FLAG_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.ON_PREMISE_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.ON_PREMISE_FLAG IS NULL ) THEN 
 v_I_ON_PREMISE_FLAG_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.NO_RULES_FLAG) = 'Y' ) THEN 
 v_I_NO_RULES_FLAG_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.NO_RULES_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.NO_RULES_FLAG IS NULL ) THEN 
 v_I_NO_RULES_FLAG_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.RECORDABLE_FLAG) = 'Y' ) THEN 
 v_I_RECORDABLE_FLAG_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.RECORDABLE_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.RECORDABLE_FLAG IS NULL ) THEN 
 v_I_RECORDABLE_FLAG_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.SAFEG_NOTUSED_FLAG) = 'Y' ) THEN 
 v_I_SAFEG_NOTUSED_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.SAFEG_NOTUSED_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.SAFEG_NOTUSED_FLAG IS NULL ) THEN 
 v_I_SAFEG_NOTUSED_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.SAFEGUARD_FLAG) = 'Y' ) THEN 
 v_I_SAFEGUARD_FLAG_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.SAFEGUARD_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.SAFEGUARD_FLAG IS NULL ) THEN 
 v_I_SAFEGUARD_FLAG_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.PRIVACY_CASE_FLAG) = 'Y' ) THEN 
 v_I_PRIVACY_CASE_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.PRIVACY_CASE_FLAG) = 'N' ) OR ( DDS_EVENT_CUR.PRIVACY_CASE_FLAG IS NULL ) THEN 
 v_I_PRIVACY_CASE_GEN := '0'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.TREATMENT_GIVEN) = 'Y' ) THEN 
 v_I_TREATMENT_GIVEN_GEN := '-1'; 
 END IF; 
 IF ( UPPER(DDS_EVENT_CUR.TREATMENT_GIVEN) = 'N' ) OR ( DDS_EVENT_CUR.TREATMENT_GIVEN IS NULL ) THEN 
 v_I_TREATMENT_GIVEN_GEN := '0'; 
 END IF; --qa 
 
 IF ( UPPER(DDS_EVENT_CUR.RELEASE_SIGNED) = 'Y' ) THEN 
 v_I_RELEASE_SIGNED_GEN := '-1'; 
 END IF; 
 IF ( UPPER(DDS_EVENT_CUR.RELEASE_SIGNED) = 'N' ) OR ( DDS_EVENT_CUR.RELEASE_SIGNED IS NULL ) THEN 
 v_I_RELEASE_SIGNED_GEN := '0'; 
 END IF; --qa 
 
 IF ( UPPER(DDS_EVENT_CUR.DEPT_HEAD_ADVISED) = 'Y' ) THEN 
 v_I_DEPT_HEAD_ADVISED_GEN := '-1'; 
 END IF; 
 
 IF ( UPPER(DDS_EVENT_CUR.DEPT_HEAD_ADVISED) = 'N' ) OR ( DDS_EVENT_CUR.DEPT_HEAD_ADVISED IS NULL ) THEN 
 v_I_DEPT_HEAD_ADVISED_GEN := '0'; 
 END IF; --qa 
 
 V_DTTM_RCD_ADDED_GEN := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'); 
 V_DTTM_RCD_LAST_UPD_GEN := TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'); 
 V_UPDATED_BY_USER := 'DDS'; 
 V_ADDED_BY_USER := 'DDS'; 
 
V_ERROR_LOCATION := 'INS2' ; 
 
 BEGIN-- EI3. CHECK IF AN EXISTING EVENT OR A NEW EVENT 
 
 v_i_EVENT_ID := 0; 
 v_N_SQL := 'SELECT EVENT_ID FROM ' || V_DBName || 'EVENT'; 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_NUMBER = :1'; 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL INTO v_i_EVENT_ID USING DDS_EVENT_CUR.EVENT_NUMBER; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EVENT_ID:=0; 
 v_I_UPDATE_FLAG_EVENT := 0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'EXISTEVEN', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 --PRINT '@N_SQL EVENT QUERY : ' + @N_SQL 
 IF v_i_EVENT_ID > 0 THEN 
 v_I_UPDATE_FLAG_EVENT := 1; 
 END IF; 
 END; 
V_ERROR_LOCATION := 'INS3' ; 
 
 IF ( ( v_I_UPDATE_FLAG_EVENT = 0 ) ) THEN-- EI4. INSERT EVENT 
 
 BEGIN 
 IF DDS_EVENT_CUR.EVENT_DESCRIPTION LIKE'%''''%' OR DDS_EVENT_CUR.BRIEF_DESCRIPTION LIKE'%''''%' OR DDS_EVENT_CUR.ADDR1 LIKE'%''''%' OR DDS_EVENT_CUR.ADDR2 LIKE'%''''%' OR DDS_EVENT_CUR.LOCATION_AREA_DESC LIKE'%''''%' OR DDS_EVENT_CUR.COMMENTS LIKE'%''''%'  THEN        --ddhupar JIRA 78172 STARTS
 DDS_EVENT_CUR.EVENT_DESCRIPTION := REPLACE(DDS_EVENT_CUR.EVENT_DESCRIPTION, '''''','''');
 DDS_EVENT_CUR.BRIEF_DESCRIPTION := REPLACE(DDS_EVENT_CUR.BRIEF_DESCRIPTION, '''''','''');
 DDS_EVENT_CUR.ADDR1 := REPLACE(DDS_EVENT_CUR.ADDR1, '''''','''');
 DDS_EVENT_CUR.ADDR2 := REPLACE(DDS_EVENT_CUR.ADDR2, '''''','''');
 DDS_EVENT_CUR.LOCATION_AREA_DESC := REPLACE(DDS_EVENT_CUR.LOCATION_AREA_DESC, '''''','''');
 DDS_EVENT_CUR.COMMENTS := REPLACE(DDS_EVENT_CUR.COMMENTS, '''''','''');
 END IF;                                                    --ddhupar JIRA 78172 ENDS
 v_N_SQL := 'SELECT NEXT_UNIQUE_ID FROM ' || V_DBNAME || 'GLOSSARY G '; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :1 '; 
 
 /*BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL INTO V_NEXT_UNIQUE_ID USING 'EVENT' ; 
 /*EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 V_NEXT_UNIQUE_ID:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'NEXTUNQEV', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 IF ( ( V_NEXT_UNIQUE_ID IS NULL ) OR ( V_NEXT_UNIQUE_ID = 0 ) ) THEN 
 V_NEXT_UNIQUE_ID := 1; 
 END IF; 
 
 v_i_EVENT_ID := V_NEXT_UNIQUE_ID; 
 --PRINT '@i_EVENT_ID LKK' + CAST (@i_EVENT_ID AS VARCHAR) 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'EVENT ( COUNTY_OF_INJURY,EVENT_ID,EVENT_NUMBER,EVENT_TYPE_CODE,EVENT_STATUS_CODE,EVENT_IND_CODE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' EVENT_DESCRIPTION,BRIEF_DESC,DEPT_EID,DEPT_INVOLVED_EID,ADDR1,ADDR2,CITY,STATE_ID,ZIP_CODE,COUNTRY_CODE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' LOCATION_AREA_DESC,PRIMARY_LOC_CODE,LOCATION_TYPE_CODE,ON_PREMISE_FLAG,NO_OF_INJURIES,NO_OF_FATALITIES,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' CAUSE_CODE,DATE_OF_EVENT,TIME_OF_EVENT,DATE_REPORTED,TIME_REPORTED,RPTD_BY_EID,DATE_TO_FOLLOW_UP,COMMENTS,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' DATE_PHYS_ADVISED,TIME_PHYS_ADVISED,TREATMENT_GIVEN,RELEASE_SIGNED,DEPT_HEAD_ADVISED,PHYS_NOTES,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' DATE_CARRIER_NOTIF,DTTM_RCD_ADDED,ADDED_BY_USER )'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES ( :1, :2 , :3, :4, :5, :6, :7, :8, :9, :10, :11, :12,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :13, :14, :15, :16 , :17, :18, :19,:20, :21,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :22, :23, :24, :25, :26, :27, :28, :29,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :30, :31, :32,:33, :34, :35, :36,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :37 , :38, :39 )'; 
 
 /* BEGIN*/ 
 --print '@N_SQL_EVENT see' + @N_SQL_EVENT 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING 
 DDS_EVENT_CUR.COUNTY_OF_INJURY, 
 v_i_EVENT_ID, 
 DDS_EVENT_CUR.EVENT_NUMBER, 
 v_EVENT_TYPE_CODE_R, 
 v_EVENT_STATUS_CODE_R, 
 v_EVENT_IND_CODE_R, 
 DDS_EVENT_CUR.EVENT_DESCRIPTION, 
 DDS_EVENT_CUR.BRIEF_DESCRIPTION, 
 v_i_DEPARTMENT_GEN, 
 v_i_DEPT_INVOLVED_GEN, 
 DDS_EVENT_CUR.ADDR1, 
 DDS_EVENT_CUR.ADDR2, 
 DDS_EVENT_CUR.CITY, 
 v_STATE_R, 
 DDS_EVENT_CUR.ZIP_CODE, 
 V_COUNTRY_R, 
 DDS_EVENT_CUR.LOCATION_AREA_DESC, 
 v_PRIMARY_LOC_CODE_R, 
 v_LOCATION_TYPE_CODE_R, 
 v_I_ON_PREMISE_FLAG_GEN, 
 DDS_EVENT_CUR.NO_OF_INJURIES, 
 DDS_EVENT_CUR.NO_OF_FATALITIES, 
 v_CAUSE_CODE_R, 
 DDS_EVENT_CUR.DATE_OF_EVENT, 
 DDS_EVENT_CUR.TIME_OF_EVENT, 
 DDS_EVENT_CUR.DATE_REPORTED, 
 DDS_EVENT_CUR.TIME_REPORTED, 
 i_Reporter_ENTITY_ID_GEN, 
 DDS_EVENT_CUR.DATE_TO_FOLLOW_UP, 
 DDS_EVENT_CUR.COMMENTS, 
 DDS_EVENT_CUR.DATE_PHYS_ADVISED, 
 DDS_EVENT_CUR.TIME_PHYS_ADVISED, 
 v_I_TREATMENT_GIVEN_GEN, 
 v_I_RELEASE_SIGNED_GEN, 
 v_I_DEPT_HEAD_ADVISED_GEN, 
 DDS_EVENT_CUR.PHYS_NOTES, 
 DDS_EVENT_CUR.DATE_CARRIER_NOTIF, 
 V_DTTM_RCD_ADDED_GEN, 
 V_ADDED_BY_USER/*, 
 DDS_EVENT_CUR.SEC_DEPT_EID*/ 
 ; 
 V_ERROR_LOCATION := 'INS4' ; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'INSEVE', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
*/ 
 
 V_NEXT_UNIQUE_ID := V_NEXT_UNIQUE_ID + 1; 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = :1'; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :2'; 
 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL USING V_NEXT_UNIQUE_ID, 'EVENT'; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'UPDTNXTUEV', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
V_ERROR_LOCATION := 'INS5' ; 
 END; 
 --SET @i_EVENT_ID = 291 --SAM 
 --set @I_UPDATE_FLAG_EVENT = 1 --sam 
 ELSE 
 IF ( ( v_I_UPDATE_FLAG_EVENT = 1 ) ) THEN 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'EVENT SET '; 
 IF DDS_EVENT_CUR.COUNTY_OF_INJURY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' COUNTY_OF_INJURY = '||''''||DDS_EVENT_CUR.COUNTY_OF_INJURY||''''||','; 
 --v_N_SQL := v_N_SQL || 'COUNTY_OF_INJURY = :1,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EVENT_NUMBER IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' EVENT_NUMBER = '||''''||DDS_EVENT_CUR.EVENT_NUMBER||''''||','; 
 --v_N_SQL := v_N_SQL || 'EVENT_NUMBER = :2,'; 
 END IF; 
 
 IF v_EVENT_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' EVENT_TYPE_CODE = '||v_EVENT_TYPE_CODE_R||','; 
 --v_N_SQL := v_N_SQL || 'EVENT_TYPE_CODE = :3,'; 
 END IF; 
 
 IF v_EVENT_STATUS_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' EVENT_STATUS_CODE = '||v_EVENT_STATUS_CODE_R||','; 
 -- v_N_SQL := v_N_SQL || 'EVENT_STATUS_CODE = :4,'; 
 END IF; 
 
 IF v_EVENT_IND_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' EVENT_IND_CODE = '||v_EVENT_IND_CODE_R||','; 
 --v_N_SQL := v_N_SQL || 'EVENT_IND_CODE = :5,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EVENT_DESCRIPTION IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' EVENT_DESCRIPTION = '||''''||DDS_EVENT_CUR.EVENT_DESCRIPTION||''''||','; 
 --v_N_SQL := v_N_SQL || 'EVENT_DESCRIPTION = :6,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.BRIEF_DESCRIPTION IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' BRIEF_DESC = '||''''||DDS_EVENT_CUR.BRIEF_DESCRIPTION||''''||','; 
 -- v_N_SQL := v_N_SQL || 'BRIEF_DESC = :7,'; 
 END IF; 
 
 IF v_i_DEPARTMENT_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DEPT_EID = '||v_i_DEPARTMENT_GEN||','; 
 -- v_N_SQL := v_N_SQL || 'DEPT_EID = :8,'; 
 END IF; 
 
 IF v_i_DEPT_INVOLVED_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DEPT_INVOLVED_EID = '||v_i_DEPT_INVOLVED_GEN||','; 
 -- v_N_SQL := v_N_SQL || 'DEPT_INVOLVED_EID = :9,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.ADDR1 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ADDR1 = '||''''||DDS_EVENT_CUR.ADDR1||''''||','; 
 --v_N_SQL := v_N_SQL || 'ADDR1 = :10,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.ADDR2 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ADDR2 = '||''''||DDS_EVENT_CUR.ADDR2||''''||','; 
 -- v_N_SQL := v_N_SQL || 'ADDR2 = :11,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.CITY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' CITY = '||''''||DDS_EVENT_CUR.CITY||''''||','; 
 --v_N_SQL := v_N_SQL || 'CITY = :12,'; 
 END IF; 
 
 IF v_STATE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' STATE_ID = '||v_STATE_R||','; 
 --v_N_SQL := v_N_SQL || 'STATE_ID = :13,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.ZIP_CODE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ZIP_CODE = '||''''||DDS_EVENT_CUR.ZIP_CODE||''''||','; 
 -- v_N_SQL := v_N_SQL || 'ZIP_CODE = :14,'; 
 END IF; 
 
 IF v_COUNTRY_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' COUNTRY_CODE = '||v_COUNTRY_R||','; 
 -- v_N_SQL := v_N_SQL || 'COUNTRY_CODE = :15,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.LOCATION_AREA_DESC IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' LOCATION_AREA_DESC = '||''''||DDS_EVENT_CUR.LOCATION_AREA_DESC||''''||','; 
 --v_N_SQL := v_N_SQL || 'LOCATION_AREA_DESC = :16,'; 
 END IF; 
 
 IF v_PRIMARY_LOC_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' PRIMARY_LOC_CODE = '||v_PRIMARY_LOC_CODE_R||','; 
 -- v_N_SQL := v_N_SQL || 'PRIMARY_LOC_CODE = :17,'; 
 END IF; 
 
 IF v_LOCATION_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' LOCATION_TYPE_CODE = '||v_LOCATION_TYPE_CODE_R||','; 
 -- v_N_SQL := v_N_SQL || 'LOCATION_TYPE_CODE = :18,'; 
 END IF; 
 
 IF v_I_ON_PREMISE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ON_PREMISE_FLAG = '||v_I_ON_PREMISE_FLAG_GEN||','; 
 --v_N_SQL := v_N_SQL || 'ON_PREMISE_FLAG = :19,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.NO_OF_INJURIES IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' NO_OF_INJURIES = '||DDS_EVENT_CUR.NO_OF_INJURIES||','; 
 -- v_N_SQL := v_N_SQL || 'NO_OF_INJURIES = :20,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.NO_OF_FATALITIES IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' NO_OF_FATALITIES = '||DDS_EVENT_CUR.NO_OF_FATALITIES||','; 
 --v_N_SQL := v_N_SQL || 'NO_OF_FATALITIES = :21,'; 
 END IF; 
 
 IF v_CAUSE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' CAUSE_CODE = '||v_CAUSE_CODE_R||','; 
 -- v_N_SQL := v_N_SQL || 'CAUSE_CODE = :22,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_OF_EVENT IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DATE_OF_EVENT = '||''''||DDS_EVENT_CUR.DATE_OF_EVENT||''''||','; 
 --v_N_SQL := v_N_SQL || 'DATE_OF_EVENT = :23,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.TIME_OF_EVENT IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' TIME_OF_EVENT = '||''''||DDS_EVENT_CUR.TIME_OF_EVENT||''''||','; 
 -- v_N_SQL := v_N_SQL || 'TIME_OF_EVENT = :24,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_REPORTED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DATE_REPORTED = '||''''||DDS_EVENT_CUR.DATE_REPORTED||''''||','; 
 --v_N_SQL := v_N_SQL || 'DATE_REPORTED = :25,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.TIME_REPORTED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' TIME_REPORTED = '||''''||DDS_EVENT_CUR.TIME_REPORTED||''''||','; 
 --v_N_SQL := v_N_SQL || 'TIME_REPORTED = :26,'; 
 END IF; 
 
 IF i_Reporter_ENTITY_ID_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' RPTD_BY_EID = '|| i_Reporter_ENTITY_ID_GEN||','; 
 --v_N_SQL := v_N_SQL || 'RPTD_BY_EID = :27,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_TO_FOLLOW_UP IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DATE_TO_FOLLOW_UP = '||''''||DDS_EVENT_CUR.DATE_TO_FOLLOW_UP||''''||','; 
 -- v_N_SQL := v_N_SQL || 'DATE_TO_FOLLOW_UP = :28,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.COMMENTS IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' COMMENTS = '||''''||DDS_EVENT_CUR.COMMENTS||''''||','; 
 -- v_N_SQL := v_N_SQL || 'COMMENTS = :29,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_PHYS_ADVISED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DATE_PHYS_ADVISED = '||''''||DDS_EVENT_CUR.DATE_PHYS_ADVISED||''''||','; 
 --v_N_SQL := v_N_SQL || 'DATE_PHYS_ADVISED = :30,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.TIME_PHYS_ADVISED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' TIME_PHYS_ADVISED = '||''''||DDS_EVENT_CUR.TIME_PHYS_ADVISED||''''||','; 
 -- v_N_SQL := v_N_SQL || 'TIME_PHYS_ADVISED = :31,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.TREATMENT_GIVEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' TREATMENT_GIVEN = '||''''||v_I_TREATMENT_GIVEN_GEN||''''||','; 
 --v_N_SQL := v_N_SQL || 'TREATMENT_GIVEN = :32,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.RELEASE_SIGNED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' RELEASE_SIGNED = '||''''||v_I_RELEASE_SIGNED_GEN||''''||','; 
 --v_N_SQL := v_N_SQL || 'RELEASE_SIGNED = :33,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DEPT_HEAD_ADVISED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DEPT_HEAD_ADVISED = '||''''||v_I_DEPT_HEAD_ADVISED_GEN||''''||','; 
 --v_N_SQL := v_N_SQL || 'DEPT_HEAD_ADVISED = :34,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.PHYS_NOTES IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' PHYS_NOTES = '||''''||DDS_EVENT_CUR.PHYS_NOTES||''''||','; 
 --v_N_SQL := v_N_SQL || 'PHYS_NOTES = :35,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_CARRIER_NOTIF IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DATE_CARRIER_NOTIF = '||''''||DDS_EVENT_CUR.DATE_CARRIER_NOTIF||''''||','; 
 --v_N_SQL := v_N_SQL || 'DATE_CARRIER_NOTIF = :36,'; 
 END IF; 
 
 IF V_DTTM_RCD_LAST_UPD_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' DTTM_RCD_LAST_UPD = '||''''||V_DTTM_RCD_LAST_UPD_GEN||''''||','; 
 --v_N_SQL := v_N_SQL || 'DTTM_RCD_LAST_UPD = :37,'; 
 END IF; 
 
 IF V_UPDATED_BY_USER IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' UPDATED_BY_USER = '||''''||V_UPDATED_BY_USER||''''||','; 
 --v_N_SQL := v_N_SQL || 'UPDATED_BY_USER = :38,'; 
 END IF; 
 
 SELECT SUBSTR(v_N_SQL, 0, NULLIF(LENGTH(v_N_SQL) - 1, -1)) 
 INTO v_N_SQL 
 FROM DUAL ; 
 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :39'; 
V_ERROR_LOCATION := 'INS6' ; 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE V_N_SQL USING v_i_EVENT_ID; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'UPDTEVNT', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 END IF; 
 END IF; 
 V_ERROR_LOCATION := 'INS7' ; 
 
 IF ( ( i_Reporter_ENTITY_ID_GEN > 0 ) ) THEN-- EI6. UPDATE REPORTER ENTITY IN ENTITY TABLE 
 
 BEGIN-- UPDATE REPORTER ENTITY IN ENTITY TABLE 
 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'ENTITY SET ENTITY_ID = ' || i_Reporter_ENTITY_ID_GEN; 
 
 IF DDS_EVENT_CUR.REPORTED_TAX_ID IS NOT NULL THEN 
 DDS_SSN_IMPORT(DDS_EVENT_CUR.REPORTED_TAX_ID, NVL(V_REPORTED_STATE_R,0), V_DBNAME, v_FormatedTaxid); --jira 77662
					  
DDS_EVENT_CUR.REPORTED_TAX_ID:= v_FormatedTaxid;
 
 v_N_SQL := v_N_SQL || ' , TAX_ID = '||''''||DDS_EVENT_CUR.REPORTED_TAX_ID||''''; 
 --v_N_SQL := v_N_SQL || 'TAX_ID = :1,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_LAST_NAME IS NOT NULL THEN      
 v_N_SQL := v_N_SQL || ', LAST_NAME = '||''''||DDS_EVENT_CUR.REPORTED_LAST_NAME||''''; 
 -- v_N_SQL := v_N_SQL || 'LAST_NAME = :2,'; 
 END IF; 

 IF DDS_EVENT_CUR.REPORTED_FIRST_NAME IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,FIRST_NAME = '||''''||DDS_EVENT_CUR.REPORTED_FIRST_NAME||''''; 
 -- v_N_SQL := v_N_SQL || 'FIRST_NAME = :3,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_ADDR1 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,ADDR1 = '||''''||DDS_EVENT_CUR.REPORTED_ADDR1||''''; 
 -- v_N_SQL := v_N_SQL || 'ADDR1 = :4,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_ADDR2 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ADDR2 = '||''''||DDS_EVENT_CUR.REPORTED_ADDR2||''''; 
 --v_N_SQL := v_N_SQL || 'ADDR2 = :5,'; 
 END IF;  
 
 IF DDS_EVENT_CUR.REPORTED_CITY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', CITY = '||''''||DDS_EVENT_CUR.REPORTED_CITY||''''; 
 -- v_N_SQL := v_N_SQL || 'CITY = :6,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_STATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', STATE_ID = '||V_REPORTED_STATE_R; 
 -- v_N_SQL := v_N_SQL || 'STATE_ID = :7,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_ZIP_CODE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ZIP_CODE = '||''''||DDS_EVENT_CUR.REPORTED_ZIP_CODE||''''; 
 -- v_N_SQL := v_N_SQL || 'ZIP_CODE = :8,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_PHONE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PHONE1 = '||''''||DDS_EVENT_CUR.REPORTED_PHONE||''''; 
 -- v_N_SQL := v_N_SQL || 'PHONE1 = :9,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_COUNTRY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', COUNTRY_CODE = '||v_REPORTED_COUNTRY_R; 
 -- v_N_SQL := v_N_SQL || 'COUNTRY_CODE = :10,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_PHONE2 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PHONE2 = '||''''||DDS_EVENT_CUR.REPORTED_PHONE2||''''; 
 -- v_N_SQL := v_N_SQL || 'PHONE2 = :11,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.REPORTED_FAX IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', FAX_NUMBER = '||''''||DDS_EVENT_CUR.REPORTED_FAX||''''; 
 -- v_N_SQL := v_N_SQL || 'FAX_NUMBER = :12,'; 
 END IF; 
 
 /* SELECT SUBSTR(v_N_SQL, 0, NULLIF(LENGTH(v_N_SQL) - 1, -1)) 
 INTO v_N_SQL 
 FROM DUAL ;*/ 
 
 v_N_SQL := v_N_SQL || ' WHERE ENTITY_ID = :13'; 
V_ERROR_LOCATION := 'INS7' ; 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL USING i_Reporter_ENTITY_ID_GEN; 
 /*DDS_EVENT_CUR.REPORTED_TAX_ID, 
 DDS_EVENT_CUR.REPORTED_LAST_NAME, 
 DDS_EVENT_CUR.REPORTED_FIRST_NAME, 
 DDS_EVENT_CUR.REPORTED_ADDR1, 
 DDS_EVENT_CUR.REPORTED_ADDR2, 
 DDS_EVENT_CUR.REPORTED_CITY, 
 V_REPORTED_STATE_R, 
 DDS_EVENT_CUR.REPORTED_ZIP_CODE, 
 DDS_EVENT_CUR.REPORTED_PHONE, 
 v_REPORTED_COUNTRY_R, 
 DDS_EVENT_CUR.REPORTED_PHONE2, 
 DDS_EVENT_CUR.REPORTED_FAX,*/ 
 /* 
 EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'REPORTins2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 END; 
 END IF; 
 V_ERROR_LOCATION := 'INS8' ; 
 
 BEGIN-- EI7. ACTION / OUTCOME EXISTENCE IN RMDB 
 
 v_vColList := 'ACTION|OUTCOME|'; 
 v_vTableList := 'EVENT_X_ACTION|EVENT_X_OUTCOME|'; 
 WHILE INSTR(v_vColList, '|', 1) > 0 
 LOOP 
 BEGIN 
 /* v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1); 
 v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1))); 
 v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1); 
 v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1))); */ 
 
 v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1); 
 v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList)); 
 v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1); 
 v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList)); 
 
 v_iCount := 1; 
 WHILE v_iCount <= 5 
 LOOP 
 v_vColToProcess := v_vColName || '_' || v_iCount || '_CODE'; 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'ACTION_1_CODE' THEN v_ACTION_1_CODE_R 
 WHEN v_vColToProcess = 'ACTION_2_CODE' THEN v_ACTION_2_CODE_R 
 WHEN v_vColToProcess = 'ACTION_3_CODE' THEN v_ACTION_3_CODE_R 
 WHEN v_vColToProcess = 'ACTION_4_CODE' THEN v_ACTION_4_CODE_R 
 WHEN v_vColToProcess = 'ACTION_5_CODE' THEN v_ACTION_5_CODE_R 
 WHEN v_vColToProcess = 'OUTCOME_1_CODE' THEN v_OUTCOME_1_CODE_R 
 WHEN v_vColToProcess = 'OUTCOME_2_CODE' THEN v_OUTCOME_2_CODE_R 
 WHEN v_vColToProcess = 'OUTCOME_3_CODE' THEN v_OUTCOME_3_CODE_R 
 WHEN v_vColToProcess = 'OUTCOME_4_CODE' THEN v_OUTCOME_4_CODE_R 
 WHEN v_vColToProcess = 'OUTCOME_5_CODE' THEN v_OUTCOME_5_CODE_R END); 
 
 IF ( v_vVal IS NOT NULL AND v_vVal <> 0 ) THEN 
 --PRINT 'ACT/OIUT ENETERD IF' 
 v_i_EVENT_ID_O := 0; 
 v_vColInRM := v_vColName || '_CODE'; 
 v_N_SQL := 'SELECT EVENT_ID FROM ' || V_DBName || v_vTableName; 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :1 AND ' || v_vColInRM || ' = :2'; 
 BEGIN 
 V_ERROR_LOCATION := 'INS9' ; 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EVENT_ID_O USING v_i_EVENT_ID, v_vVal; 
 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EVENT_ID_O:= 0 ; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ACT/OUT1E', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 IF v_i_EVENT_ID_O = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || v_vTableName || ' (EVENT_ID,' || v_vColInRM || ') 
 VALUES ( :1,:2)'; 
 /* BEGIN*/ 
 V_ERROR_LOCATION := 'INS10' ; 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_EVENT_ID, v_vVal; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ACT/OUT2E', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 END IF; 
 END IF; 
 
 v_iCount := v_iCount + 1; 
 END LOOP; 
 
 END; 
 END LOOP; 
 
 END; 
 V_ERROR_LOCATION := 'INS12' ; 
 BEGIN-- EI8. EVENT_X_OSHA|FALL_INDICATOR EXISTENCE IN RMDB 
 
 v_vTableList := 'EVENT_X_OSHA|FALL_INDICATOR|';--TT 
 
 WHILE INSTR(v_vTableList, '|', 1) > 0 
 LOOP 
 BEGIN 
 --PRINT 'OSHA/INDCNT' 
 v_i_EVENT_ID_O := 0; 
 /*v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1); 
 v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/ 
 
 v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1); 
 v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList)); 
 
 --PRINT '@vTableName : ' + @vTableName ; 
 v_N_SQL := 'SELECT EVENT_ID FROM ' || V_DBName || v_vTableName ; 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :1 '; 
 V_ERROR_LOCATION := 'INS13' ; 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_EVENT_ID_O USING v_i_EVENT_ID; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_EVENT_ID_O :=0; 
 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'OSHA/IND1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 --print '@i_EVENT_ID_O OSHA/INDI : ' + cast ( @i_EVENT_ID_O as varchar) 
 IF v_i_EVENT_ID_O = 0 AND v_vTableName = 'EVENT_X_OSHA' THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'EVENT_X_OSHA (ACTIVITY_WHEN_INJ,EVENT_ID,HOW_ACC_OCCURRED,NO_RULES_FLAG,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || 'OBJ_SUBST_THAT_INJ,RECORDABLE_FLAG,SAFEG_NOTUSED_FLAG,SAFEGUARD_FLAG,PRIVACY_CASE_FLAG,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || 'SHARPS_OBJECT,SHARPS_BRAND_MAKE,SAFEG_PROVIDED,RULES_NOT_FOLLOWED,OSHA_ESTAB_EID)'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || 'VALUES ( :1, :2, :3, 
 :4, :5, :6,:7, :8,:9, :10,:11,:12,:13,:14)'; 
 V_ERROR_LOCATION := 'INS14' ; 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING 
 DDS_EVENT_CUR.ACTIVITY_WHEN_INJ, 
 v_i_EVENT_ID, 
 DDS_EVENT_CUR.HOW_ACC_OCCURRED, 
 v_I_NO_RULES_FLAG_GEN, 
 DDS_EVENT_CUR.OBJ_SUBST_THAT_INJ, 
 v_I_RECORDABLE_FLAG_GEN, 
 v_I_SAFEG_NOTUSED_GEN, 
 v_I_SAFEGUARD_FLAG_GEN, 
 v_I_PRIVACY_CASE_GEN, 
 v_SHARPS_OBJECT_R, 
 v_SHARPS_BRAND_MAKE_R, 
 v_SAFEG_PROVIDED_R, 
 v_RULES_NOT_FOLLOWED_R, 
 v_I_OSHA_ESTAB_EID_GEN; 
 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'OSHA2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 END IF; 
 V_ERROR_LOCATION := 'INS15' ; 
 
 IF v_i_EVENT_ID_O > 0 AND v_vTableName = 'EVENT_X_OSHA' THEN 
 -- **kapil clarification required... v_i_EVENT_ID_O and v_i_EVENT_ID are different? and purpose? 
 -- **neha v_i_EVENT_ID_O and v_i_EVENT_ID are same. 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'EVENT_X_OSHA SET EVENT_ID = ' ||v_i_EVENT_ID ; 
 IF DDS_EVENT_CUR.ACTIVITY_WHEN_INJ IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ACTIVITY_WHEN_INJ = '||''''||DDS_EVENT_CUR.ACTIVITY_WHEN_INJ||''''; 
 -- v_N_SQL := v_N_SQL || 'ACTIVITY_WHEN_INJ = :1,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.HOW_ACC_OCCURRED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', HOW_ACC_OCCURRED = '||''''||DDS_EVENT_CUR.HOW_ACC_OCCURRED||''''; 
 --v_N_SQL := v_N_SQL || 'HOW_ACC_OCCURRED = :2,'; 
 END IF; 
 
 IF v_I_NO_RULES_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NO_RULES_FLAG = '||v_I_NO_RULES_FLAG_GEN; 
 -- v_N_SQL := v_N_SQL || 'NO_RULES_FLAG = :3,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.OBJ_SUBST_THAT_INJ IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', OBJ_SUBST_THAT_INJ = '||''''||DDS_EVENT_CUR.OBJ_SUBST_THAT_INJ||''''; 
 -- v_N_SQL := v_N_SQL || 'OBJ_SUBST_THAT_INJ = :4,'; 
 END IF; 
 
 IF v_I_RECORDABLE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', RECORDABLE_FLAG = '||v_I_RECORDABLE_FLAG_GEN; 
 --v_N_SQL := v_N_SQL || 'RECORDABLE_FLAG = :5,'; 
 END IF; 
 
 IF v_I_SAFEG_NOTUSED_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,SAFEG_NOTUSED_FLAG = '||v_I_SAFEG_NOTUSED_GEN; 
 -- v_N_SQL := v_N_SQL || 'SAFEG_NOTUSED_FLAG = :7,'; 
 END IF; 
 
 IF v_I_SAFEGUARD_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', SAFEGUARD_FLAG = '||v_I_SAFEGUARD_FLAG_GEN; 
 --v_N_SQL := v_N_SQL || 'SAFEGUARD_FLAG = :8,'; 
 END IF; 
 
 IF v_I_PRIVACY_CASE_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PRIVACY_CASE_FLAG = '||v_I_PRIVACY_CASE_GEN; 
 --v_N_SQL := v_N_SQL || 'PRIVACY_CASE_FLAG = :9,'; 
 END IF; 
 
 IF v_SHARPS_OBJECT_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,SHARPS_OBJECT = '||v_SHARPS_OBJECT_R ; --DOUBTMK 
 --v_N_SQL := v_N_SQL || 'SHARPS_OBJECT = :10,'; 
 END IF; 
 
 IF v_SHARPS_BRAND_MAKE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', SHARPS_BRAND_MAKE = '|| v_SHARPS_BRAND_MAKE_R ; 
 --v_N_SQL := v_N_SQL || 'SHARPS_BRAND_MAKE = :11,'; 
 END IF; 
 
 IF v_SAFEG_PROVIDED_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,SAFEG_PROVIDED = '||v_SAFEG_PROVIDED_R; 
 -- v_N_SQL := v_N_SQL || 'SAFEG_PROVIDED = :12,'; 
 END IF; 
 
 IF v_RULES_NOT_FOLLOWED_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,RULES_NOT_FOLLOWED = '||v_RULES_NOT_FOLLOWED_R; 
 -- v_N_SQL := v_N_SQL || 'RULES_NOT_FOLLOWED = :13,'; 
 END IF; 
 
 IF v_I_OSHA_ESTAB_EID_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', OSHA_ESTAB_EID = '||v_I_OSHA_ESTAB_EID_GEN; 
 --v_N_SQL := v_N_SQL || 'OSHA_ESTAB_EID = :14,'; 
 END IF; 
 
 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :15 '; 
 
 /* BEGIN*/ 
 
 
 -- DBMS_OUTPUT.put_line(v_N_SQL); 
 EXECUTE IMMEDIATE v_N_SQL USING v_i_EVENT_ID; 
 /*DDS_EVENT_CUR.ACTIVITY_WHEN_INJ, 
 DDS_EVENT_CUR.HOW_ACC_OCCURRED, 
 v_I_NO_RULES_FLAG_GEN, 
 DDS_EVENT_CUR.OBJ_SUBST_THAT_INJ, 
 v_I_RECORDABLE_FLAG_GEN, 
 v_I_SAFEG_NOTUSED_GEN, 
 v_I_SAFEGUARD_FLAG_GEN, 
 v_I_PRIVACY_CASE_GEN, 
 v_SHARPS_OBJECT_R, 
 v_SHARPS_BRAND_MAKE_R, 
 v_SAFEG_PROVIDED_R, 
 DDS_EVENT_CUR.RULES_NOT_FOLLOWED, 
 v_I_OSHA_ESTAB_EID_GEN,*/ 
 
 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'OSHA3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS16' ; 
 END IF; 
 V_ERROR_LOCATION := 'INS15.1' ; 
 
 IF v_i_EVENT_ID_O = 0 AND v_vTableName = 'FALL_INDICATOR' THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'FALL_INDICATOR ( EVENT_ID,COND_PRIOR_CODE,RAIL_POSITION_CODE,RESTRAINT_CODE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || 'BED_POSITION_CODE,CALL_LIGHT_CODE )'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || 'VALUES( :1, :2,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :3, :4, :5, :6)'; 
 
 /*BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_EVENT_ID, 
 v_COND_PRIOR_CODE_R, 
 v_RAIL_POSITION_CODE_R, 
 v_RESTRAINT_CODE_R, 
 v_BED_POSITION_CODE_R, 
 v_CALL_LIGHT_CODE_R; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'INDI2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS17' ; 
 END IF; 
 
 V_ERROR_LOCATION := 'INS15.2' ; 
 IF v_i_EVENT_ID_O > 0 AND v_vTableName = 'FALL_INDICATOR' THEN 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'FALL_INDICATOR SET EVENT_ID = ' || v_i_EVENT_ID ; 
 
 IF v_COND_PRIOR_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', COND_PRIOR_CODE = '||v_COND_PRIOR_CODE_R; 
 -- v_N_SQL := v_N_SQL || 'COND_PRIOR_CODE = :1,'; 
 END IF; 
 
 IF v_RAIL_POSITION_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', RAIL_POSITION_CODE = '||v_RAIL_POSITION_CODE_R; 
 --v_N_SQL := v_N_SQL || 'RAIL_POSITION_CODE = :2,'; 
 END IF; 
 
 IF v_RESTRAINT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', RESTRAINT_CODE = '||v_RESTRAINT_CODE_R; 
 --v_N_SQL := v_N_SQL || 'RESTRAINT_CODE = :3,'; 
 END IF; 
 
 IF v_BED_POSITION_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,BED_POSITION_CODE = '||v_BED_POSITION_CODE_R; 
 --v_N_SQL := v_N_SQL || 'BED_POSITION_CODE = :4,'; 
 END IF; 
 
 IF v_CALL_LIGHT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,CALL_LIGHT_CODE = '||v_CALL_LIGHT_CODE_R; 
 --v_N_SQL := v_N_SQL || 'CALL_LIGHT_CODE = :5,'; 
 END IF; 
 
 
 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :6'; 
 
 /* BEGIN*/ 
 
 EXECUTE IMMEDIATE V_N_SQL USING v_i_EVENT_ID; 
 /*v_COND_PRIOR_CODE_R, 
 v_RAIL_POSITION_CODE_R, 
 v_RESTRAINT_CODE_R, 
 v_BED_POSITION_CODE_R, 
 v_CALL_LIGHT_CODE_R,*/ 
 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'INDI3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS18' ; 
 END IF; 
 
 V_ERROR_LOCATION := 'INS15.3' ; 
 END; 
 END LOOP; 
 END; 
 V_ERROR_LOCATION := 'INS19' ; 
 END; 
 END IF; 
 
 
 --************************************************************************* 
 --******************* IMPORT EVENT ENDS ***************************** 
 --************************************************************************* 
 
 
 --************************************************************************* 
 --********PERSON INVOLVED and its Related tables INSERT STARTS ************ 
 --************************************************************************* 
 
 
 IF ( v_I_ERRORCOUNT = 0 AND v_i_EVENT_ID > 0 AND v_i_PI_TYPE_ENTITY_ID_GEN > 0 ) THEN 
 BEGIN 
 V_ERROR_LOCATION := 'INS20.1' ; 
 BEGIN-- PIIns1. RMDB EXISTENCE OF PERSON_INVOLVED 
 
 v_i_PI_ROW_ID := 0; 
 v_N_SQL := 'SELECT PI_ROW_ID FROM ' || V_DBName || 'PERSON_INVOLVED '; 
 v_N_SQL := v_N_SQL || ' WHERE EVENT_ID = :1 AND PI_EID = :2'; 
 
 BEGIN 
 V_ERROR_LOCATION := 'INS20.2' ; 
 EXECUTE IMMEDIATE V_N_SQL INTO v_i_PI_ROW_ID USING v_i_EVENT_ID,v_i_PI_TYPE_ENTITY_ID_GEN ; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PI_ROW_ID := 0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PI_EXIST', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 V_ERROR_LOCATION := 'INS20' ; 
 --DBMS_OUTPUT.PUT_LINE('PIIns1. END'); 
 END; 
 IF ( v_i_PI_ROW_ID = 0 ) THEN--CW -- PIIns2. TABLE INSERT STARTS 
 --BEGIN -- Abhishek: Done. kapil remove begin end 
 --DBMS_OUTPUT.PUT_LINE(' PIIns2. ENETERD'); 
V_ERROR_LOCATION := 'INS21' ; 
 -- 1.PI_EID (NEXT_UNIQUE_ID)GENRATED FROM RMDB 
 v_N_SQL := 'SELECT NEXT_UNIQUE_ID FROM ' || V_DBNAME || 'GLOSSARY G '; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :1'; 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO V_NEXT_UNIQUE_ID USING 'PERSON_INVOLVED'; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 V_NEXT_UNIQUE_ID := 0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PIEIDNXTYNQ', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 IF ( ( V_NEXT_UNIQUE_ID IS NULL ) OR ( V_NEXT_UNIQUE_ID = 0 ) ) THEN 
 V_NEXT_UNIQUE_ID := 1; 
 END IF; 
 
 v_i_PI_ROW_ID := V_NEXT_UNIQUE_ID; 
 
 BEGIN -- PIIns2. TABLE INSERT STARTS commom 
 
 V_ERROR_LOCATION := 'INS21.2' ; 
 v_N_SQL := 'SELECT STR_PARM_VALUE FROM ' || V_DBNAME || 'PARMS_NAME_VALUE '; 
 v_N_SQL := v_N_SQL || ' WHERE PARM_NAME =:1 '; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO V_iEroleFlag USING 'USE_ENTITY_ROLE' ; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 V_iEroleFlag :=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'EroleFlag', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 V_ERROR_LOCATION := 'INS22' ; 
 IF V_iEroleFlag = 0 THEN 
 v_iRoleTableId := 0 ; 
 END IF ; 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'PERSON_INVOLVED ( PI_ROW_ID , EVENT_ID, PI_EID, PI_TYPE_CODE, DATE_OF_DEATH, MARITAL_STAT_CODE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' COUNTY_OF_RESIDNC, WEIGHT , PARENT_TABLE_NAME, ROLE_TABLE_ID, PARENT_ROW_ID , NUM_OF_VIOLATIONS ) VALUES ( :1 ,:2, :3, :4, :5 , :6, :7, :8, :9 , :10, :11 , :12)'; 
 /*BEGIN*/ 
 EXECUTE IMMEDIATE V_N_SQL_EVENT USING 
 v_i_PI_ROW_ID, 
 v_i_EVENT_ID, 
 v_i_PI_TYPE_ENTITY_ID_GEN, 
 v_PI_TYPE_CODE_R, 
 DDS_EVENT_CUR.DATE_OF_DEATH, 
 v_MARITAL_STAT_CODE_R, 
 DDS_EVENT_CUR.COUNTY_OF_RESIDNC, 
 DDS_EVENT_CUR.WEIGHT, 
 'EVENT' , 
 v_iRoleTableId , 
 v_i_EVENT_ID, 
 DDS_EVENT_CUR.NUM_OF_VIOLATION ; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PIINS1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 V_ERROR_LOCATION := 'INS23' ; 
 
 END; 
 
 V_NEXT_UNIQUE_ID := v_i_PI_ROW_ID + 1; 
 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = :1'; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :2'; 
 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL USING V_NEXT_UNIQUE_ID,'PERSON_INVOLVED'; 
 V_ERROR_LOCATION := 'INS24' ; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'UPDNXTPI', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
*/ 
 
 
 IF UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' THEN-- PIIns5. INSERT into PI table WHEN PI_TYPE_CODE 'P' 
 
 
 v_N_SQL := 'SELECT NEXT_UNIQUE_ID FROM ' || V_DBNAME || 'GLOSSARY G '; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME =:1 '; 
 /*BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL INTO V_NEXT_UNIQUE_ID USING 'PATIENTS'; 
 /*EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 V_NEXT_UNIQUE_ID:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PATIENTNXT', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
V_ERROR_LOCATION := 'INS25' ; 
 IF ( ( V_NEXT_UNIQUE_ID IS NULL ) OR ( V_NEXT_UNIQUE_ID = 0 ) ) THEN 
 V_NEXT_UNIQUE_ID := 1; 
 END IF; 
 v_i_PATIENT_ID_GEN := V_NEXT_UNIQUE_ID; 
 V_ERROR_LOCATION := 'INS26' ; 
 
 v_N_SQL := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET '; 
-- **Kapil if v_i_PATIENT_ID_GEN is null and DDS_EVENT_CUR.PATIENT_ACCT_NO is not null then 
-- update statement will break 
 
 IF v_i_PATIENT_ID_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' PATIENT_ID = '||v_i_PATIENT_ID_GEN ; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_ID = :1,'; 
 -- END IF; --**neha 
 
 IF DDS_EVENT_CUR.PATIENT_ACCT_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' , PATIENT_ACCT_NO = '||''''||DDS_EVENT_CUR.PATIENT_ACCT_NO||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_ACCT_NO = :2,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.MEDICAL_RCD_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', MEDICAL_RCD_NO = '||''''||DDS_EVENT_CUR.MEDICAL_RCD_NO||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'MEDICAL_RCD_NO = :3,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.INS_PLAN_GROUP_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', INS_PLAN_GROUP_NO = '||''''||DDS_EVENT_CUR.INS_PLAN_GROUP_NO||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'INS_PLAN_GROUP_NO = :4,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_OF_ADMISSION IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DATE_OF_ADMISSION = '||''''||DDS_EVENT_CUR.DATE_OF_ADMISSION||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_OF_ADMISSION = :5,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.DATE_OF_DISCHARGE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DATE_OF_DISCHARGE = '||''''||DDS_EVENT_CUR.DATE_OF_DISCHARGE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_OF_DISCHARGE = :6,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EPISODE_OF_CARE_ID IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EPISODE_OF_CARE_ID = '||''''||DDS_EVENT_CUR.EPISODE_OF_CARE_ID||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EPISODE_OF_CARE_ID = :7,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EMERGENCY_CONTACT IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EMERGENCY_CONTACT = '||''''||DDS_EVENT_CUR.EMERGENCY_CONTACT||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EMERGENCY_CONTACT = :8,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EMERGENCY_CONT_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EMERGENCY_CONT_NO = '||''''||DDS_EVENT_CUR.EMERGENCY_CONT_NO||''''; 
 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'EMERGENCY_CONT_NO = :9,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.PATIENT_ROOM_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PATIENT_ROOM_NO = '||''''||DDS_EVENT_CUR.PATIENT_ROOM_NO||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_ROOM_NO = :10,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EXP_LENGTH_OF_STAY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EXP_LENGTH_OF_STAY = '||DDS_EVENT_CUR.EXP_LENGTH_OF_STAY; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EXP_LENGTH_OF_STAY = :11,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.EXPECTED_COST IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EXPECTED_COST = '||DDS_EVENT_CUR.EXPECTED_COST; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EXPECTED_COST = :12,'; 
 END IF; 
 
 IF v_PATIENT_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PATIENT_TYPE_CODE = '||v_PATIENT_TYPE_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_TYPE_CODE = :13,'; 
 END IF; 
 
 IF v_PATIENT_STAT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ',PATIENT_STAT_CODE = '||v_PATIENT_STAT_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_STAT_CODE = :14,'; 
 END IF; 
 
 IF v_PATIENT_COND_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PATIENT_COND_CODE = '||v_PATIENT_COND_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'PATIENT_COND_CODE = :15,'; 
 END IF; 
 
 IF v_ACUITY_LEVEL_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ACUITY_LEVEL_CODE = '||v_ACUITY_LEVEL_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'ACUITY_LEVEL_CODE = :16,'; 
 END IF; 
 
 IF v_ADM_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ADM_TYPE_CODE = '||v_ADM_TYPE_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'ADM_TYPE_CODE = :17,'; 
 END IF; 
 
 IF v_ADM_SOURCE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ADM_SOURCE_CODE = '||v_ADM_SOURCE_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'ADM_TYPE_CODE = :17,'; 
 END IF; 
 
 IF v_DISCHARGE_DSP_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DISCHARGE_DSP_CODE = '||v_DISCHARGE_DSP_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DISCHARGE_DSP_CODE = :18,'; 
 END IF; 
 
 IF v_QI_SIGNIF_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', QI_SIGNIF_CODE = '||v_QI_SIGNIF_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'QI_SIGNIF_CODE = :19,'; 
 END IF; 
 
 IF v_FACILITY_UNIT_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', FACILITY_UNIT_CODE = '||v_FACILITY_UNIT_CODE_R; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'FACILITY_UNIT_CODE = :20,'; 
 END IF; 
 
 IF v_i_FACILITY_DEPT_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', FACILITY_DEPT_EID = '||v_i_FACILITY_DEPT_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'FACILITY_DEPT_EID = :21,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.WHY_AT_FACILITY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WHY_AT_FACILITY = '||''''||DDS_EVENT_CUR.WHY_AT_FACILITY||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WHY_AT_FACILITY = :22,'; 
 END IF; 
 
 IF DDS_EVENT_CUR.ADMISSION_REASON IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ADMISSION_REASON = '||''''||DDS_EVENT_CUR.ADMISSION_REASON||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'ADMISSION_REASON = :23,'; 
 END IF; 
  
 --JIRA 24634 knakra starts 
 IF v_vBENEFICIARY_CODE_ID IS NOT NULL AND v_vBENEFICIARY_CODE_ID > 0 AND v_iHmiFlag = 1 THEN 
 v_N_SQL := v_N_SQL || ', BENEFICIARY_CODE = ' || v_vBENEFICIARY_CODE_ID; 
 END IF; 
 --JIRA 24634 knakra ends 
 
 /*SELECT SUBSTR(v_N_SQL_EVENT, 0, NULLIF(LENGTH(v_N_SQL_EVENT) - 1, -1)) 
 INTO v_N_SQL_EVENT 
 FROM DUAL ;*/ 
 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :24 '; 
 END IF; --**neha 
 /* BEGIN*/ 
 
 EXECUTE IMMEDIATE v_N_SQL USING v_i_PI_ROW_ID; 
 /* v_i_PATIENT_ID_GEN, 
 DDS_EVENT_CUR.PATIENT_ACCT_NO, 
 DDS_EVENT_CUR.MEDICAL_RCD_NO, 
 DDS_EVENT_CUR.INS_PLAN_GROUP_NO, 
 DDS_EVENT_CUR.DATE_OF_ADMISSION, 
 DDS_EVENT_CUR.DATE_OF_DISCHARGE, 
 DDS_EVENT_CUR.EPISODE_OF_CARE_ID, 
 DDS_EVENT_CUR.EMERGENCY_CONTACT, 
 DDS_EVENT_CUR.EMERGENCY_CONT_NO, 
 DDS_EVENT_CUR.PATIENT_ROOM_NO, 
 DDS_EVENT_CUR.EXP_LENGTH_OF_STAY, 
 DDS_EVENT_CUR.EXPECTED_COST, 
 v_PATIENT_TYPE_CODE_R, 
 v_PATIENT_STAT_CODE_R, 
 v_PATIENT_COND_CODE_R, 
 v_ACUITY_LEVEL_CODE_R, 
 --v_ADM_SOURCE_CODE_R, 
 v_ADM_TYPE_CODE_R, 
 v_DISCHARGE_DSP_CODE_R, 
 v_QI_SIGNIF_CODE_R, 
 v_FACILITY_UNIT_CODE_R, 
 v_i_FACILITY_DEPT_GEN, 
 DDS_EVENT_CUR.WHY_AT_FACILITY, 
 DDS_EVENT_CUR.ADMISSION_REASON,*/ 
 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PIINS4', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
V_ERROR_LOCATION := 'INS27' ; 
 --DBMS_OUTPUT.PUT_LINE('-- PIIns5. END'); 
 END IF; 
 
 
 IF UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'W' THEN-- PIIns6. INSERT into PI table WHEN PI_TYPE_CODE IS WITNESS 
 --DBMS_OUTPUT.PUT_LINE(' -- PIIns6.ENTERED'); 
 /* v_N_SQL_EVENT := NULL;*/ 
 v_N_SQL_EVENT := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET PI_ROW_ID = ' || v_i_PI_ROW_ID ; 
 IF DDS_EVENT_CUR.DESC_BY_WITNESS IS NOT NULL THEN 
 v_N_SQL_EVENT := ', DESC_BY_WITNESS = '||''''||DDS_EVENT_CUR.DESC_BY_WITNESS||''''; 
 END IF; 
 -- **Kapil if statement is small then make it proper dynamic for multiple if else we need to check how can we 
 -- manage 
 
 /* SELECT SUBSTR(v_N_SQL_EVENT, 0, NULLIF(LENGTH(v_N_SQL_EVENT) - 1, -1)) 
 INTO v_N_SQL_EVENT 
 FROM DUAL ;*/ 
 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WHERE PI_ROW_ID = :1'; 
 
 -- IF v_N_SQL_EVENT IS NOT NULL THEN 
 -- v_N_SQL_EVENT := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET ' || v_N_SQL_EVENT; 
V_ERROR_LOCATION := 'INS28' ; 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PIINS5', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS29' ; 
 -- END IF; 
 --DBMS_OUTPUT.PUT_LINE(' -- PIIns6.END'); 
 END IF; 
 
 
 
 
 IF ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' OR UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' ) AND ( v_i_PI_ROW_ID > 0 ) THEN-- PIIns7. INSERTION INTO RELATED TABLES WHEN PI TYPE IS P/E 
 
 BEGIN--1b --C. HOSPITAL AND PHYSICIAN ENTERD 
 
 v_vColList := 'HOSPITAL|PHYSICIAN|'; 
 v_vTableList := 'PI_X_HOSPITAL|PI_X_PHYSICIAN|'; 
 
 WHILE INSTR(v_vColList, '|', 1) > 0 
 LOOP 
 BEGIN--2B 
 
 --DBMS_OUTPUT.PUT_LINE('WHILE ENETERD JHOS'); 
 
 /* v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1); 
 v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1))); 
 v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1); 
 v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/ 
 
 v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1); 
 v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList)); 
 v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1); 
 v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList)); 
 
 
 v_iCount := 1; 
 WHILE v_iCount <= 3 
 LOOP 
 BEGIN--3B 
 
 v_vColToProcess := v_vColName || '_' || v_iCount || '_EID'; 
 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'HOSPITAL_1_EID' THEN v_i_HOSPITAL_1_EID 
 WHEN v_vColToProcess = 'HOSPITAL_2_EID' THEN v_i_HOSPITAL_2_EID 
 WHEN v_vColToProcess = 'HOSPITAL_3_EID' THEN v_i_HOSPITAL_3_EID 
 WHEN v_vColToProcess = 'PHYSICIAN_1_EID' THEN v_i_PHYSICIAN_1_EID 
 WHEN v_vColToProcess = 'PHYSICIAN_2_EID' THEN v_i_PHYSICIAN_2_EID 
 WHEN v_vColToProcess = 'PHYSICIAN_3_EID' THEN v_i_PHYSICIAN_3_EID END); 
 
 
 IF v_vVal IS NOT NULL or v_vVal <> 0 THEN 
 BEGIN--4B 
 
 v_i_PI_ROW_ID_OP := 0; 
 
 v_vColInRM := v_vColName || '_EID'; 
 
 v_N_SQL := 'SELECT PI_ROW_ID FROM ' || V_DBName || v_vTableName; 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :1 AND ' || v_vColInRM || ' = :2 '; 
V_ERROR_LOCATION := 'INS30' ; 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL INTO v_i_PI_ROW_ID_OP USING v_i_PI_ROW_ID, v_vVal; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PI_ROW_ID_OP:=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'HOSP/PHYS2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 V_ERROR_LOCATION := 'INS31' ; 
 
 --v_i_PI_ROW_ID_OP := 0; 
 
 IF ( v_i_PI_ROW_ID_OP = 0 ) THEN --5B 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || v_vTableName || ' (PI_ROW_ID,' || v_vColInRM || ' 
 ) VALUES ( :1,:2)'; 
 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID, NVL(v_vVal, 0); 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'HOSP/PHYS3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS32' ; 
 END IF; 
 
 END; 
 END IF; 
 v_iCount := v_iCount + 1; 
 END; 
 END LOOP; 
 
 END; 
 END LOOP; 
 
 END; 
 
 
 v_N_SQL_EVENT := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET PI_ROW_ID = ' || v_i_PI_ROW_ID ; 
 IF DDS_EVENT_CUR.HCO_ID_NO IS NOT NULL THEN 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', HCO_ID_NO = '||''''||DDS_EVENT_CUR.HCO_ID_NO||''''; 
 END IF; 
 IF DDS_EVENT_CUR.HCO_SITE_ID_NO IS NOT NULL THEN 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', HCO_SITE_ID_NO = '||''''||DDS_EVENT_CUR.HCO_SITE_ID_NO||''''; 
 END IF; 
 
 IF DDS_EVENT_CUR.EST_LEN_DISABILITY IS NOT NULL THEN 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', EST_LEN_DISABILITY = '||''''||DDS_EVENT_CUR.EST_LEN_DISABILITY||''''; 
 END IF; 
 
 IF DDS_EVENT_CUR.LEN_OF_SVC_DAYS IS NOT NULL THEN 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', LEN_OF_SVC_DAYS = '||''''||DDS_EVENT_CUR.LEN_OF_SVC_DAYS||''''; 
 END IF; 
 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WHERE PI_ROW_ID = :1'; 
 
 
V_ERROR_LOCATION := 'INS288' ; 
 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID; 
 
 
 
 
 
 
 
 
 END IF; 
 
 
 IF ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'PHYS' ) THEN-- PIIns8. INSERTION INTO PHYSICIAN 
 BEGIN 
 --print 'phys entered' 
 v_i_Phys_EID_O := 0; 
 v_N_SQL_EVENT := 'SELECT PHYS_EID FROM ' || V_DBName || 'PHYSICIAN '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WHERE PHYS_EID = :1'; 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL_EVENT INTO v_i_Phys_EID_O USING v_i_PI_TYPE_ENTITY_ID_GEN; 
 V_ERROR_LOCATION := 'INS33' ; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_Phys_EID_O :=0; 
 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PHYSEXIST', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
IF v_MARITAL_STAT_CODE_R IS NULL THEN 
 v_MARITAL_STAT_CODE_R := 0 ; END IF ; 
IF v_i_DEPT_ASSIGNED_GEN IS NULL THEN 
v_i_DEPT_ASSIGNED_GEN := 0 ; END IF; 
 
 IF v_i_Phys_EID_O = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'PHYSICIAN ( PHYS_EID , PHYSICIAN_NUMBER , PRIMARY_SPECIALTY,PRIMARY_POLICY_ID,HOME_STATE_ID,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' MARITAL_STAT_CODE,MAILING_STATE_ID,STAFF_STATUS_CODE,STAFF_TYPE_CODE,STAFF_CAT_CODE,LIC_STATE,DEPT_ASSIGNED_EID)'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES (:1,:2 ,:3, :4,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :5, :6, :7, :8, :9, :10,:11) '; 
 
 /* BEGIN*/ 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING 
 v_i_PI_TYPE_ENTITY_ID_GEN, 
 v_i_PI_TYPE_ENTITY_ID_GEN, 
 0, 
 0, 
 0, 
 v_MARITAL_STAT_CODE_R, 
 0, 
 0, 
 0, 
 0, 
 0, 
 v_i_DEPT_ASSIGNED_GEN ; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PHYSINS', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 V_ERROR_LOCATION := 'INS34' ; 
 END IF; 
 END; 
 END IF; 
 
 
 
 
 
 IF ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' ) THEN--PIIns9 INSERTION INTO PATIENT AND PATIENT_RELATED TABLES 
 
 --BEGIN -- Abhishek: Done. Kapil remove extra begin not required here 
 --PRINT 'ENETERD PATIENT1' 
 BEGIN 
 v_i_PATIENT_EID := 0; 
 v_N_SQL_EVENT := 'SELECT PATIENT_EID FROM ' || V_DBName || 'PATIENT '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' WHERE PATIENT_EID = :1'; 
 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL_EVENT INTO v_i_PATIENT_EID USING v_i_PI_TYPE_ENTITY_ID_GEN; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PATIENT_EID :=0; 
 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PATIENTEXIST', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 
 
 V_ERROR_LOCATION := 'INS35' ; 
 
IF v_i_ADM_PHYSICIAN_EID_GEN IS NULL THEN v_i_ADM_PHYSICIAN_EID_GEN := 0 ; END IF ; 
 
 
 IF v_i_PRI_PHYSICIAN_EID_GEN IS NULL THEN v_i_PRI_PHYSICIAN_EID_GEN := 0 ; END IF ; 
 IF v_i_FACILITY_DEPT_GEN IS NULL THEN v_i_FACILITY_DEPT_GEN := 0 ; END IF ; 
 IF v_FACILITY_UNIT_CODE_R IS NULL THEN v_FACILITY_UNIT_CODE_R := 0 ; END IF ; 
 IF v_MARITAL_STAT_CODE_R IS NULL THEN v_MARITAL_STAT_CODE_R := 0 ; END IF ; 
 IF v_PATIENT_TYPE_CODE_R IS NULL THEN v_PATIENT_TYPE_CODE_R := 0 ; END IF ; 
 IF DDS_EVENT_CUR.EXP_LENGTH_OF_STAY IS NULL THEN DDS_EVENT_CUR.EXP_LENGTH_OF_STAY := 0 ; END IF ; 
 IF v_ACUITY_LEVEL_CODE_R IS NULL THEN v_ACUITY_LEVEL_CODE_R := 0 ; END IF ; 
 IF v_ADM_SOURCE_CODE_R IS NULL THEN v_ADM_SOURCE_CODE_R := 0 ; END IF ; 
 IF v_ADM_TYPE_CODE_R IS NULL THEN v_ADM_TYPE_CODE_R := 0 ; END IF ; 
 IF v_PATIENT_COND_CODE_R IS NULL THEN v_PATIENT_COND_CODE_R := 0 ; END IF ; 
 IF v_PATIENT_STAT_CODE_R IS NULL THEN v_PATIENT_STAT_CODE_R := 0 ; END IF ; 
 IF v_DISCHARGE_DSP_CODE_R IS NULL THEN v_DISCHARGE_DSP_CODE_R := 0 ; END IF ; 
 IF v_QI_SIGNIF_CODE_R IS NULL THEN v_QI_SIGNIF_CODE_R := 0 ; END IF ; 
 
 
 
 
 IF v_i_PATIENT_EID = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'PATIENT (PATIENT_ID , PATIENT_EID, PATIENT_ACCT_NO, MEDICAL_RCD_NO, INS_PLAN_GROUP_NO,DATE_OF_ADMISSION, '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' DATE_OF_DISCHARGE,EPISODE_OF_CARE_ID,EMERGENCY_CONTACT,EMERGENCY_CONT_NO,PATIENT_ROOM_NO,EXP_LENGTH_OF_STAY,EXPECTED_COST,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' PATIENT_TYPE_CODE,PATIENT_STAT_CODE,PATIENT_COND_CODE,ACUITY_LEVEL_CODE,ADM_SOURCE_CODE,ADM_TYPE_CODE,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' DISCHARGE_DSP_CODE,QI_SIGNIF_CODE,FACILITY_UNIT_CODE,FACILITY_DEPT_EID,WHY_AT_FACILITY,ADMISSION_REASON ,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' PRI_PHYSICIAN_EID , ADM_PHYSICIAN_EID , WEIGHT ,MARITAL_STAT_CODE , DATE_OF_DEATH , HCO_ID_NO , HCO_SITE_ID_NO , PRIMARY_PAY_CODE ,SECOND_PAY_CODE,RACE_ENTH_CODE , CARDIAC_ARREST)'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES (:1, :2, :3, :4, :5, :6, '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :7, :8, :9, :10, :11,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :12, :13, :14, :15, :16, :17,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :18, :19, :20, :21,:22, :23,'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :24, :25,:26,:27,:28, :29, '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' :30, :31, :32, :33, :34, :35 , :36 )'; 
 
 /* BEGIN*/ EXECUTE IMMEDIATE V_N_SQL_EVENT USING 
 v_i_PATIENT_ID_GEN, 
 v_i_PI_TYPE_ENTITY_ID_GEN, 
 DDS_EVENT_CUR.PATIENT_ACCT_NO, 
 DDS_EVENT_CUR.MEDICAL_RCD_NO, 
 DDS_EVENT_CUR.INS_PLAN_GROUP_NO, 
 DDS_EVENT_CUR.DATE_OF_ADMISSION, 
 DDS_EVENT_CUR.DATE_OF_DISCHARGE, 
 DDS_EVENT_CUR.EPISODE_OF_CARE_ID, 
 DDS_EVENT_CUR.EMERGENCY_CONTACT, 
 DDS_EVENT_CUR.EMERGENCY_CONT_NO, 
 DDS_EVENT_CUR.PATIENT_ROOM_NO, 
 DDS_EVENT_CUR.EXP_LENGTH_OF_STAY, 
 DDS_EVENT_CUR.EXPECTED_COST, 
 v_PATIENT_TYPE_CODE_R, 
 v_PATIENT_STAT_CODE_R, 
 v_PATIENT_COND_CODE_R, 
 v_ACUITY_LEVEL_CODE_R, 
 v_ADM_SOURCE_CODE_R, 
 v_ADM_TYPE_CODE_R, 
 v_DISCHARGE_DSP_CODE_R, 
 v_QI_SIGNIF_CODE_R, 
 v_FACILITY_UNIT_CODE_R, 
 v_i_FACILITY_DEPT_GEN, 
 DDS_EVENT_CUR.WHY_AT_FACILITY, 
 DDS_EVENT_CUR.ADMISSION_REASON, 
 v_i_PRI_PHYSICIAN_EID_GEN, 
 v_i_ADM_PHYSICIAN_EID_GEN, 
 DDS_EVENT_CUR.WEIGHT, 
 v_MARITAL_STAT_CODE_R, 
 DDS_EVENT_CUR.DATE_OF_DEATH, 
 DDS_EVENT_CUR.HCO_ID_NO, 
 DDS_EVENT_CUR.HCO_SITE_ID_NO, 
 0, 
 0, 
 0, 
 0; 
 
 V_ERROR_LOCATION := 'INS36' ; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PATIENTINS', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 BEGIN-- Update NEXT_UNIQUE_ID in glossary for Patients 
 V_NEXT_UNIQUE_ID := v_i_PATIENT_ID_GEN + 1; 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = :1'; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :2 '; 
 
 /* BEGIN*/ EXECUTE IMMEDIATE V_N_SQL USING V_NEXT_UNIQUE_ID,'PATIENTS'; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'UPDNEXTPATNT', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ V_ERROR_LOCATION := 'INS37' ; 
 END; END IF; 
 END; --PRINT 'ENETERD PATIENT2' 
 BEGIN-- PIIns9.INSERT INTO PATIENT REALTED TABLE 
 
 v_I_COUNT := 0; 
 v_vColList := 'BODY_PART|DIAGNOSIS|TREATMENT|'; 
 v_vTableList := 'PATIENT_BODY_PART|PATIENT_DIAGNOSIS|PATIENT_TREATMENT|'; 
 
 WHILE INSTR(v_vColList, '|', 1) > 0 
 LOOP 
 BEGIN 
 /* v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1); 
 v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1))); 
 v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1); 
 v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/ 
 v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1); 
 v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList)); 
 v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1); 
 v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList)); 
 
 
 v_iCount := 1; 
 
 WHILE v_iCount <= 5 
 LOOP 
 BEGIN 
 v_vColToProcess := v_vColName || '_' || CAST(v_iCount AS VARCHAR2) || '_CODE'; 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'BODY_PART_1_CODE' THEN v_BODY_PART_1_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_2_CODE' THEN v_BODY_PART_2_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_3_CODE' THEN v_BODY_PART_3_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_4_CODE' THEN v_BODY_PART_4_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_5_CODE' THEN v_BODY_PART_5_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_1_CODE' THEN v_DIAGNOSIS_1_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_2_CODE' THEN v_DIAGNOSIS_2_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_3_CODE' THEN v_DIAGNOSIS_3_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_4_CODE' THEN v_DIAGNOSIS_4_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_5_CODE' THEN v_DIAGNOSIS_5_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_1_CODE' THEN v_TREATMENT_1_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_2_CODE' THEN v_TREATMENT_2_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_3_CODE' THEN v_TREATMENT_3_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_4_CODE' THEN v_TREATMENT_4_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_5_CODE' THEN v_TREATMENT_5_CODE_R END); 
 
 IF v_vVal IS NOT NULL THEN 
 v_i_PATIENT_EID := 0; 
 v_vColInRM := v_vColName || '_CODE'; 
 
 v_N_SQL := 'SELECT PATIENT_ID FROM ' || V_DBName || v_vTableName; 
 v_N_SQL := v_N_SQL || ' WHERE PATIENT_ID = :1 AND ' || v_vColInRM || ' = :2'; 
 
 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL INTO v_i_PATIENT_EID USING v_i_PATIENT_ID_GEN,v_vVal ; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PATIENT_EID :=0; 
 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'BDTFP1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 V_ERROR_LOCATION := 'INS36' ; 
 
 IF v_i_PATIENT_EID = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || v_vTableName || ' (PATIENT_ID,' || v_vColInRM || ') 
 VALUES (:1,:2 )'; 
 
 /*BEGIN*/ EXECUTE IMMEDIATE v_N_SQL_EVENT using v_i_PATIENT_ID_GEN, NVL(v_vVal , 0) ; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'BDTFP2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ END IF; END IF; v_iCount := v_iCount + 1; 
 END; END LOOP; 
 END; END LOOP; 
 END; --PRINT 'ENETERD PATIENT3' 
 BEGIN-- PIIns10. Existence Checked and INSERT INTO ILLNESS /INJURY INSERT (because of above condition) 
 
 --SET @v_DISABILITY_CODE = 'INJ' --SAM 
 IF ( UPPER(DDS_EVENT_CUR.DISABILITY_CODE) = 'ILL' ) THEN 
 IF v_ILLNESS_CODE_R IS NOT NULL AND v_ILLNESS_CODE_R <> 0 THEN 
 v_N_SQL_EVENT := 'UPDATE ' || V_DBNAME || 'PATIENT SET ILLNESS_CODE = :1 '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', DISABILITY_CODE = :2 WHERE PATIENT_ID = :3 '; 
V_ERROR_LOCATION := 'INS37' ; 
 /*BEGIN*/ EXECUTE IMMEDIATE v_N_SQL_EVENT USING NVL(v_ILLNESS_CODE_R,0), v_DISABILITY_CODE_R, v_i_PI_TYPE_ENTITY_ID_GEN; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJP1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ END IF; ELSE 
 IF ( UPPER(DDS_EVENT_CUR.DISABILITY_CODE) = 'INJ' ) THEN-- INJURY EXISTENCE AND INSERT 
 v_N_SQL_EVENT := 'UPDATE ' || V_DBNAME || 'PATIENT SET DISABILITY_CODE = :1 WHERE PATIENT_ID = :2' ; 
/* 
 BEGIN*/ EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_DISABILITY_CODE_R,v_i_PI_TYPE_ENTITY_ID_GEN ; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJP2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS38' ; 
 
 v_iCount := 1; 
 
 WHILE ( v_iCount < 6 ) 
 LOOP 
 BEGIN 
 v_vColName := '@v_INJURY_' || v_iCount|| '_CODE'; -- mkaur24 reverted change not required 
 -- mkaur24 reverted change not required 
 -- v_vColName := 'INJURY_' || v_iCount|| '_CODE'; --**neha 
 -- **Kapil why using @? 
 --**neha removed @v_ 
 v_vVal := (CASE 
 WHEN v_vColName = '@v_INJURY_1_CODE' THEN v_INJURY_1_CODE_R 
 WHEN v_vColName = '@v_INJURY_2_CODE' THEN v_INJURY_2_CODE_R 
 WHEN v_vColName = '@v_INJURY_3_CODE' THEN v_INJURY_3_CODE_R 
 WHEN v_vColName = '@v_INJURY_4_CODE' THEN v_INJURY_4_CODE_R 
 WHEN v_vColName = '@v_INJURY_5_CODE' THEN v_INJURY_5_CODE_R END); 
 
 IF v_vVal IS NOT NULL THEN 
 v_i_PATIENT_EID := 0; 
 
 v_N_SQL := 'SELECT PATIENT_ID FROM ' || V_DBName || 'PATIENT_INJURY'; 
 v_N_SQL := v_N_SQL || ' WHERE PATIENT_ID = :1 AND INJURY_CODE = :2 '; 
V_ERROR_LOCATION := 'INS39' ; 
 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_PATIENT_EID USING v_i_PI_TYPE_ENTITY_ID_GEN, v_vVal; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PATIENT_EID :=0; 
 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJP3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END; 
 
 V_ERROR_LOCATION := 'INS40' ; 
 END IF; 
 v_iCount := v_iCount + 1; 
 
 END; 
 END LOOP; 
 END IF; 
 END IF; 
 END; 
 --END; 
 END IF; 
 END IF; 
 END; 
 --END; 
 END IF; 
 --PRINT 'ENETERD PATIENT4' 
 --************************************************************************* 
 --********PERSON INVOLVED and its Related tables INSERT ENDS ************ 
 --************************************************************************* 
 
 --************************************************************************* 
 --********PERSON INVOLVED and its Related tables COMMON STARTS ************ 
 --************************************************************************* 
 
 V_ERROR_LOCATION := 'INS20upd' ; 
 IF ( v_I_ERRORCOUNT = 0 AND v_i_EVENT_ID > 0 AND v_i_PI_TYPE_ENTITY_ID_GEN > 0 AND ( v_i_PI_ROW_ID > 0 ) ) THEN--CWZ 
 IF UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' THEN 
 BEGIN 
 --DBMS_OUTPUT.PUT_LINE('PIIns3. ENTERED'); 
 -- v_N_SQL_EVENT := NULL; 
 --v_N_SQL_EVENT := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET '; 
 
 v_N_SQL := ' UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET PI_ROW_ID = ' || v_i_PI_ROW_ID ; 
 IF DDS_EVENT_CUR.EMPLOYEE_NUMBER IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EMPLOYEE_NUMBER = '||''''||DDS_EVENT_CUR.EMPLOYEE_NUMBER||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EMPLOYEE_NUMBER = @v_EMPLOYEE_NUMBER_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.DATE_HIRED IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DATE_HIRED = '||''''||DDS_EVENT_CUR.DATE_HIRED||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_HIRED = @v_DATE_HIRED_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.WEEKLY_RATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WEEKLY_RATE = '||''''||DDS_EVENT_CUR.WEEKLY_RATE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WEEKLY_RATE = @v_WEEKLY_RATE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.HOURLY_RATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', HOURLY_RATE = '||''''||DDS_EVENT_CUR.HOURLY_RATE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'HOURLY_RATE = @v_HOURLY_RATE_P,'; 
 END IF; 
 IF v_i_SUPERVISOR_ENTITY_ID_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', SUPERVISOR_EID = '||v_i_SUPERVISOR_ENTITY_ID_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'SUPERVISOR_EID = @v_SUPERVISOR_EID_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.WEEKLY_HOURS IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WEEKLY_HOURS = '||''''||DDS_EVENT_CUR.WEEKLY_HOURS||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WEEKLY_HOURS = @v_WEEKLY_HOURS,'; 
 END IF; 
 IF DDS_EVENT_CUR.DRIVERS_LIC_NO IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DRIVERS_LIC_NO = '||''''||DDS_EVENT_CUR.DRIVERS_LIC_NO||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DRIVERS_LIC_NO = @v_DRIVERS_LIC_NO_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.DATE_DRIVERSLICEXP IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DATE_DRIVERSLICEXP = '||''''||DDS_EVENT_CUR.DATE_DRIVERSLICEXP||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DATE_DRIVERSLICEXP = @v_DATE_DRIVERSLICEXP_P,'; 
 END IF; 
 IF v_DRIVLIC_STATE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DRIVLIC_STATE = '||v_DRIVLIC_STATE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DRIVLIC_STATE = @v_DRIVLIC_STATE_P,'; 
 END IF; 
 IF v_POSITION_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', POSITION_CODE = '||v_POSITION_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'POSITION_CODE = @v_POSITION_CODE_P,'; 
 END IF; 
 IF v_NCCI_CLASS_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NCCI_CLASS_CODE = '||v_NCCI_CLASS_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'NCCI_CLASS_CODE = @v_NCCI_CLASS_CODE_P,'; 
 END IF; 
 IF v_i_DEPT_ASSIGNED_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', DEPT_ASSIGNED_EID = '||v_i_DEPT_ASSIGNED_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'DEPT_ASSIGNED_EID = @v_DEPT_ASSIGNED_EID_P,'; 
 END IF; 
 IF v_FULL_TIME_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', FULL_TIME_FLAG = '||v_FULL_TIME_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'FULL_TIME_FLAG = @v_FULL_TIME_FLAG_P ,'; 
 END IF; 
 IF v_ACTIVE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ACTIVE_FLAG = '||v_ACTIVE_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'ACTIVE_FLAG = @v_ACTIVE_FLAG_P,'; 
 END IF; 
 IF v_EXEMPT_STATUS_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', EXEMPT_STATUS_FLAG = '||v_EXEMPT_STATUS_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'EXEMPT_STATUS_FLAG = @v_EXEMPT_STATUS_FLAG_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.NO_OF_EXEMPTIONS IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NO_OF_EXEMPTIONS = '||''''||DDS_EVENT_CUR.NO_OF_EXEMPTIONS||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'NO_OF_EXEMPTIONS = @v_NO_OF_EXEMPTIONS_P,'; 
 END IF; 
 IF v_PAY_TYPE_CODE_R IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', PAY_TYPE_CODE = '||v_PAY_TYPE_CODE_R; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PAY_TYPE_CODE = @v_PAY_TYPE_CODE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.PAY_AMOUNT IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,PAY_AMOUNT = '||DDS_EVENT_CUR.PAY_AMOUNT; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'PAY_AMOUNT = @v_PAY_AMOUNT_P,'; 
 END IF; 
 IF v_WORK_SUN_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_SUN_FLAG = '||v_WORK_SUN_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_SUN_FLAG = @v_WORK_SUN_FLAG_P,'; 
 END IF; 
 IF v_WORK_MON_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_MON_FLAG = '||v_WORK_MON_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_MON_FLAG = @v_WORK_MON_FLAG_P,'; 
 END IF; 
 IF v_WORK_TUE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_TUE_FLAG = '||v_WORK_TUE_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_TUE_FLAG = @v_WORK_TUE_FLAG_P,'; 
 END IF; 
 IF v_WORK_WED_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_WED_FLAG = '||v_WORK_WED_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_WED_FLAG = @v_WORK_WED_FLAG_P,'; 
 END IF; 
 IF v_WORK_THU_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_THU_FLAG = '||v_WORK_THU_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_THU_FLAG = @v_WORK_THU_FLAG_P,'; 
 END IF; 
 IF v_WORK_FRI_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_FRI_FLAG = '||v_WORK_FRI_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_FRI_FLAG = @v_WORK_FRI_FLAG_P,'; 
 END IF; 
 IF v_WORK_SAT_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_SAT_FLAG = '||v_WORK_SAT_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_SAT_FLAG = @v_WORK_SAT_FLAG_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.WORK_PERMIT_DATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_PERMIT_DATE = '||''''||DDS_EVENT_CUR.WORK_PERMIT_DATE||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_PERMIT_DATE = @v_WORK_PERMIT_DATE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.WORK_PERMIT_NUMBER IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORK_PERMIT_NUMBER = '||''''||DDS_EVENT_CUR.WORK_PERMIT_NUMBER||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORK_PERMIT_NUMBER = @v_WORK_PERMIT_NUMBER_P,'; 
 END IF; 
 IF v_INSURABLE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', INSURABLE_FLAG = '||v_INSURABLE_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'INSURABLE_FLAG = @v_INSURABLE_FLAG_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.LAST_VERIFIED_DATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', LAST_VERIFIED_DATE = '||''''||DDS_EVENT_CUR.LAST_VERIFIED_DATE||''''; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'LAST_VERIFIED_DATE = @v_LAST_VERIFIED_DATE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.WORKDAY_START_TIME IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', WORKDAY_START_TIME = '||''''||DDS_EVENT_CUR.WORKDAY_START_TIME||''''; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'WORKDAY_START_TIME = @v_WORKDAY_START_TIME_P,'; 
 END IF; 
 IF v_REGULAR_JOB_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', REGULAR_JOB_FLAG = '||v_REGULAR_JOB_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'REGULAR_JOB_FLAG = @v_REGULAR_JOB_FLAG_P,'; 
 
 END IF; 
 IF v_HIRED_IN_STATE_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', HIRED_IN_STE_FLAG = '||v_HIRED_IN_STATE_FLAG_GEN; 
 -- v_N_SQL_EVENT := v_N_SQL_EVENT || 'REGULAR_JOB_FLAG = @v_REGULAR_JOB_FLAG_P,'; 
 
 END IF; 
 
 IF v_LOST_WORK_FLAG_GEN IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', LOST_WORK_FLAG = '||v_LOST_WORK_FLAG_GEN; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'LOST_WORK_FLAG = @v_LOST_WORK_FLAG_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.NUM_OF_VIOLATION IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', NUM_OF_VIOLATIONS = '||DDS_EVENT_CUR.NUM_OF_VIOLATION ; 
 --v_N_SQL_EVENT := v_N_SQL_EVENT || 'LOST_WORK_FLAG = @v_LOST_WORK_FLAG_P,'; 
 END IF; 
 /* SELECT SUBSTR(v_N_SQL_EVENT, 0, NULLIF(LENGTH(v_N_SQL_EVENT) - 1, -1)) 
 INTO v_N_SQL_EVENT 
 FROM DUAL ;*/ 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :1 '; 
 EXECUTE IMMEDIATE v_N_SQL USING v_i_PI_ROW_ID; 
 V_ERROR_LOCATION := 'INS41' ; 
 
 
 END; -- DRIVLIC_RSTRCTCODE, HIRED_IN_STE_FLAG , in vb code bt nt in import filr DOUBT 
 -- INSERT/UPDATE into PI table WHEN PI_TYPE_CODE IS 'E' INSERT INTO PI 
 IF ( V_LOST_WORK_FLAG_GEN <> 0 ) THEN-- PIUP3. Existence Checked and INSERT INTO PI_X_WORK_LOSS INSERT (because of above condition) 
 
 --PRINT 'FLAG NETERE' 
 v_vColName1 := 'DATE_LAST_WORKED'; 
 v_vColName2 := 'DATE_RETURNED'; 
 v_iCount := 1; 
 
 WHILE v_iCount <= 15 
 LOOP 
 BEGIN 
 
 v_vColToProcess := v_vColName1 || '_' || v_iCounT; 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_1' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_1 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_2' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_2 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_3' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_3 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_4' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_4 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_5' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_5 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_6' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_6 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_7' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_7 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_8' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_8 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_9' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_9 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_10' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_10 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_11' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_11 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_12' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_12 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_13' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_13 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_14' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_14 
 WHEN v_vColToProcess = 'DATE_LAST_WORKED_15' THEN DDS_EVENT_CUR.DATE_LAST_WORKED_15 END); 
 
 v_vColToProcess := v_vColName2 || '_' || v_iCount; 
 
 v_vVal2 := (CASE 
 WHEN v_vColToProcess = 'DATE_RETURNED_1' THEN DDS_EVENT_CUR.DATE_RETURNED_1 
 WHEN v_vColToProcess = 'DATE_RETURNED_2' THEN DDS_EVENT_CUR.DATE_RETURNED_2 
 WHEN v_vColToProcess = 'DATE_RETURNED_3' THEN DDS_EVENT_CUR.DATE_RETURNED_3 
 WHEN v_vColToProcess = 'DATE_RETURNED_4' THEN DDS_EVENT_CUR.DATE_RETURNED_4 
 WHEN v_vColToProcess = 'DATE_RETURNED_5' THEN DDS_EVENT_CUR.DATE_RETURNED_5 
 WHEN v_vColToProcess = 'DATE_RETURNED_6' THEN DDS_EVENT_CUR.DATE_RETURNED_6 
 WHEN v_vColToProcess = 'DATE_RETURNED_7' THEN DDS_EVENT_CUR.DATE_RETURNED_7 
 WHEN v_vColToProcess = 'DATE_RETURNED_8' THEN DDS_EVENT_CUR.DATE_RETURNED_8 
 WHEN v_vColToProcess = 'DATE_RETURNED_9' THEN DDS_EVENT_CUR.DATE_RETURNED_9 
 WHEN v_vColToProcess = 'DATE_RETURNED_10' THEN DDS_EVENT_CUR.DATE_RETURNED_10 
 WHEN v_vColToProcess = 'DATE_RETURNED_11' THEN DDS_EVENT_CUR.DATE_RETURNED_11 
 WHEN v_vColToProcess = 'DATE_RETURNED_12' THEN DDS_EVENT_CUR.DATE_RETURNED_12 
 WHEN v_vColToProcess = 'DATE_RETURNED_13' THEN DDS_EVENT_CUR.DATE_RETURNED_13 
 WHEN v_vColToProcess = 'DATE_RETURNED_14' THEN DDS_EVENT_CUR.DATE_RETURNED_14 
 WHEN v_vColToProcess = 'DATE_RETURNED_15' THEN DDS_EVENT_CUR.DATE_RETURNED_15 END); 
 
 
 IF ( v_vVal IS NOT NULL AND v_vVal2 IS NOT NULL ) THEN 
 v_i_PI_ROW_ID_OP := 0; 
 
 v_N_SQL := 'SELECT PI_ROW_ID FROM ' || V_DBName || 'PI_X_WORK_LOSS '; 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :1 AND DATE_LAST_WORKED = :2 AND DATE_RETURNED = :3'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL INTO v_i_PI_ROW_ID_OP USING v_i_PI_ROW_ID,v_vVal,v_vVal2; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PI_ROW_ID_OP :=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'WLINS', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 END; 
 
 V_ERROR_LOCATION := 'INS42' ; 
 IF ( v_i_PI_ROW_ID_OP = 0 ) THEN -- 1.PI_WL_ROW_ID (NEXT_UNIQUE_ID)GENRATED FROM RMDB 
 
 v_N_SQL := 'SELECT NEXT_UNIQUE_ID FROM ' || V_DBNAME || 'GLOSSARY G '; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :1 '; 
 
 /* BEGIN*/ EXECUTE IMMEDIATE v_n_sql INTO V_NEXT_UNIQUE_ID USING 'PI_X_WORK_LOSS'; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJPI1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 V_ERROR_LOCATION := 'INS43' ; --Abhishek: done. Kapil if line is getting commented then need to start it in new line 
 IF ( ( V_NEXT_UNIQUE_ID IS NULL ) OR ( V_NEXT_UNIQUE_ID = 0 ) ) THEN 
 V_NEXT_UNIQUE_ID := 1; 
 END IF; 
 v_i_PI_WL_ROW_ID := V_NEXT_UNIQUE_ID; 
 END IF; 
 --PRINT '@V_NEXT_UNIQUE_ID GENERATED :' + @V_NEXT_UNIQUE_ID ; 
 IF ( v_i_PI_ROW_ID_OP = 0 ) THEN-- 2. INSERT INTO PI 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'PI_X_WORK_LOSS (PI_ROW_ID,PI_WL_ROW_ID,DATE_LAST_WORKED,DATE_RETURNED,DURATION) '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ' VALUES (:1,:2,:3,:4,:5)'; 
 -- Abhishek: Done. Kapil if line is getting commented then need to start it in new line 
 EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID, v_i_PI_WL_ROW_ID, NVL(v_vVal, 0), NVL(v_vVal2, 0),NVL(v_DURATION, 0) ; 
 /* BEGIN*/ 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'WLINS2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 V_ERROR_LOCATION := 'INS44' ; 
 
 
 --DURATION FOUND IN VB CODE BUT NOT IN IMPORT FILE 
 -- 3. Update NEXT_UNIQUE_ID for PERSON_INVOLVED in glossary 
 
 V_NEXT_UNIQUE_ID := v_i_PI_WL_ROW_ID + 1; 
 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = :1'; 
 v_N_SQL := v_N_SQL || ' WHERE SYSTEM_TABLE_NAME = :2'; 
 -- Abhishek: Done. Kapil if line is getting commented then need to start it in new line 
 EXECUTE IMMEDIATE V_N_SQL USING V_NEXT_UNIQUE_ID, 'PI_X_WORK_LOSS'; 
 /* BEGIN*/ 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'WLINS3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ 
 
 V_ERROR_LOCATION := 'INS45' ; 
 
 END IF; 
 END IF; 
 v_iCount := v_iCount + 1; 
 
 END; 
 END LOOP; 
 END IF; 
 END IF; 
 IF ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'E' ) OR ( UPPER(DDS_EVENT_CUR.PI_TYPE_CODE) = 'P' ) THEN 
 -- A. Existence Checked and INSERT INTO RLATED TABLES (because of above condition)( BODY_PART|DIAGNOSIS|TREATMENT|) 
 --BEGIN -- Abhishek: Done. kapil remove begin end 
 --DBMS_OUTPUT.PUT_LINE('-- PIIns7. ODY_PART|DIA ENTERED'); 
 v_I_COUNT := 0; 
 v_vColList := 'BODY_PART|DIAGNOSIS|TREATMENT|'; 
 v_vTableList := 'PI_X_BODY_PART|PI_X_DIAGNOSIS|PI_X_TREATMENT|'; 
 WHILE INSTR(v_vColList, '|', 1) > 0 
 
 LOOP 
 BEGIN 
 /* v_vColName := SUBSTR(v_vColList, 0, INSTR(v_vColList, '|', 1) - 1); 
 v_vColList := SUBSTR(v_vColList, -1, (LENGTH(v_vColList) - INSTR(v_vColList, '|', 1))); 
 v_vTableName := SUBSTR(v_vTableList, 0, INSTR(v_vTableList, '|', 1) - 1); 
 v_vTableList := SUBSTR(v_vTableList, -1, (LENGTH(v_vTableList) - INSTR(v_vTableList, '|', 1)));*/ 
 v_vColName := SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)-1); 
 v_vColList := SUBSTR(v_vColList,LENGTH(SUBSTR(v_vColList,1,INSTR(v_vColList, '|', 1)))+1,LENGTH(v_vColList)); 
 v_vTableName := SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)-1); 
 v_vTableList := SUBSTR(v_vTableList,LENGTH(SUBSTR(v_vTableList,1,INSTR(v_vTableList, '|', 1)))+1,LENGTH(v_vTableList)); 
 
 v_iCount := 1; 
 
 WHILE v_iCount <= 5 
 LOOP 
 BEGIN 
 v_vColToProcess := v_vColName || '_' || v_iCount || '_CODE'; 
 
 v_vVal := (CASE 
 WHEN v_vColToProcess = 'BODY_PART_1_CODE' THEN v_BODY_PART_1_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_2_CODE' THEN v_BODY_PART_2_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_3_CODE' THEN v_BODY_PART_3_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_4_CODE' THEN v_BODY_PART_4_CODE_R 
 WHEN v_vColToProcess = 'BODY_PART_5_CODE' THEN v_BODY_PART_5_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_1_CODE' THEN v_DIAGNOSIS_1_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_2_CODE' THEN v_DIAGNOSIS_2_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_3_CODE' THEN v_DIAGNOSIS_3_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_4_CODE' THEN v_DIAGNOSIS_4_CODE_R 
 WHEN v_vColToProcess = 'DIAGNOSIS_5_CODE' THEN v_DIAGNOSIS_5_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_1_CODE' THEN v_TREATMENT_1_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_2_CODE' THEN v_TREATMENT_2_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_3_CODE' THEN v_TREATMENT_3_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_4_CODE' THEN v_TREATMENT_4_CODE_R 
 WHEN v_vColToProcess = 'TREATMENT_5_CODE' THEN v_TREATMENT_5_CODE_R END); 
 
 IF v_vVal IS NOT NULL THEN 
 v_i_PI_ROW_ID_OP := 0; 
 v_vColInRM := v_vColName || '_CODE'; 
 
 v_N_SQL := 'SELECT PI_ROW_ID FROM ' || V_DBName || v_vTableName; 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :1 AND ' || v_vColInRM || ' = :2'; 
 
 BEGIN 
 EXECUTE IMMEDIATE V_N_SQL INTO v_i_PI_ROW_ID_OP USING v_i_PI_ROW_ID,v_vVal ; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PI_ROW_ID_OP :=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'BDT1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 END; 
 V_ERROR_LOCATION := 'INS46' ; 
 --SET @i_PI_ROW_ID_OP = 0 --SAM 
 IF v_i_PI_ROW_ID_OP = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || v_vTableName || ' (PI_ROW_ID,' || v_vColInRM || ') VALUES (:1,:2 )'; 
 /* BEGIN*/ EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID, NVL(v_vVal,0); 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'BDT2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ V_ERROR_LOCATION := 'INS47' ; 
 END IF; END IF; v_iCount := v_iCount + 1; 
 END; END LOOP; 
 END; END LOOP; 
 --DBMS_OUTPUT.PUT_LINE('-- PIIns7. ODY_PART|DIA END'); 
 --END; 
 
 BEGIN-- B. Existence Checked and INSERT INTO ILLNESS /INJURY INSERT (because of above condition) 
 --DBMS_OUTPUT.PUT_LINE('-- PIIns7. ENTERED ILLNESS /INJUR START'); 
 
 IF ( upper(DDS_EVENT_CUR.DISABILITY_CODE) = 'ILL' ) THEN 
 --SET @ILLNESS_CODE_R = 26 --SAM 
 IF v_ILLNESS_CODE_R IS NOT NULL AND v_ILLNESS_CODE_R <> 0 THEN 
 v_N_SQL_EVENT := 'UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET ILLNESS_CODE = :1'; 
 v_N_SQL_EVENT := v_N_SQL_EVENT || ', DISABILITY_CODE = :2 WHERE PI_ROW_ID = :3'; 
 
 /*BEGIN */ EXECUTE IMMEDIATE V_N_SQL_EVENT USING NVL(v_ILLNESS_CODE_R,0), v_DISABILITY_CODE_R, v_i_PI_ROW_ID; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ V_ERROR_LOCATION := 'INS48' ; 
 END IF; ELSE 
 IF (upper( DDS_EVENT_CUR.DISABILITY_CODE) = 'INJ' ) THEN-- INJURY EXISTENCE AND INSERT 
 v_N_SQL_EVENT := 'UPDATE ' || V_DBNAME || 'PERSON_INVOLVED SET DISABILITY_CODE = :1 '; 
 v_N_SQL_EVENT := v_N_SQL_EVENT ||' WHERE PI_ROW_ID = :2'; 
 
 /* BEGIN*/ EXECUTE IMMEDIATE V_N_SQL_EVENT USING v_DISABILITY_CODE_R, v_i_PI_ROW_ID; 
 /*EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'INJ1', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/V_ERROR_LOCATION := 'INS49' ; 
 --SET @INJURY_1_CODE_R = 56 --SAM 
 --SET @INJURY_2_CODE_R = 57 --SAM 
 v_iCount := 1; 
 
 WHILE ( v_iCount < 6 ) 
 LOOP 
 BEGIN 
 v_vColName := '@v_INJURY_' || v_iCount || '_CODE'; -- **neha removed @v_ 
 -- mkaur24 reverted change not required 
 --v_vColName := 'INJURY_' || v_iCount || '_CODE'; -- **neha 
 v_vVal := (CASE 
 WHEN v_vColName = '@v_INJURY_1_CODE' THEN v_INJURY_1_CODE_R 
 WHEN v_vColName = '@v_INJURY_2_CODE' THEN v_INJURY_2_CODE_R 
 WHEN v_vColName = '@v_INJURY_3_CODE' THEN v_INJURY_3_CODE_R 
 WHEN v_vColName = '@v_INJURY_4_CODE' THEN v_INJURY_4_CODE_R 
 WHEN v_vColName = '@v_INJURY_5_CODE' THEN v_INJURY_5_CODE_R END); 
 
 IF v_vVal IS NOT NULL THEN 
 v_i_PI_ROW_ID_OP := 0; 
 v_N_SQL := 'SELECT PI_ROW_ID FROM ' || V_DBName || 'PI_X_INJURY'; 
 v_N_SQL := v_N_SQL || ' WHERE PI_ROW_ID = :1 AND INJURY_CODE = :2'; 
 BEGIN 
 EXECUTE IMMEDIATE v_N_SQL into v_i_PI_ROW_ID_OP using v_i_PI_ROW_ID, v_vVal; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 v_i_PI_ROW_ID_OP :=0; 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJ2', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 END; 
 
V_ERROR_LOCATION := 'INS50' ; 
 --SET @i_PI_ROW_ID_OP = 0 --SAM 
 IF v_i_PI_ROW_ID_OP = 0 THEN 
 v_N_SQL_EVENT := 'INSERT INTO ' || V_DBNAME || 'PI_X_INJURY (PI_ROW_ID, INJURY_CODE ) VALUES ( :1,:2)'; 
 /* BEGIN*/ EXECUTE IMMEDIATE v_N_SQL_EVENT USING v_i_PI_ROW_ID, NVL(v_vVal, 0); 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'ILL/INJ3', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ V_ERROR_LOCATION := 'INS51' ; 
 END IF; END IF; 
 v_iCount := v_iCount + 1; 
 END; END LOOP; END IF; 
 END IF; --DBMS_OUTPUT.PUT_LINE('-- PIIns7. ENTERED ILLNESS /INJUR END'); 
 END; END IF; END IF; 
 
 --************************************************************************* 
 --********PERSON INVOLVED and its Related tables COMMON ENDS ************ 
 --************************************************************************* 
 --************************************************************************* 
 --*****************UPDATE PI DATA IN ENTITY STARTS ************************ 
 --************************************************************************* 
 IF ( v_i_PI_TYPE_ENTITY_ID_GEN > 0 AND v_I_ERRORCOUNT = 0 ) THEN 
 -- PRINT 'PI DATA IN ENTITY STARTS ' 
 v_N_SQL := 'UPDATE ' || V_DBNAME || 'ENTITY SET ENTITY_ID = ' || v_i_PI_TYPE_ENTITY_ID_GEN ; 
 IF DDS_EVENT_CUR.PI_PHONE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' ,PHONE1 = '||''''||DDS_EVENT_CUR.PI_PHONE||''''; 
 END IF; 
 IF DDS_EVENT_CUR.PI_ADDR1 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ',ADDR1 = '||''''||DDS_EVENT_CUR.PI_ADDR1||''''; 
 --v_N_SQL := v_N_SQL || 'ADDR1 = @v_PI_ADDR1_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.PI_ADDR2 IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ',ADDR2 = '||''''||DDS_EVENT_CUR.PI_ADDR2||''''; 
 --v_N_SQL := v_N_SQL || 'ADDR2 = @v_PI_ADDR2_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.PI_CITY IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ',CITY = '||''''||DDS_EVENT_CUR.PI_CITY||''''; 
 --v_N_SQL := v_N_SQL || 'CITY = @v_PI_CITY_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.PI_STATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ' , STATE_ID = '||v_PI_STATE_R; 
 --v_N_SQL := v_N_SQL || 'STATE_ID = @v_PI_STATE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.PI_ZIP_CODE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', ZIP_CODE = '||''''||DDS_EVENT_CUR.PI_ZIP_CODE||''''; 
 --v_N_SQL := v_N_SQL || 'ZIP_CODE = @v_PI_ZIP_CODE_P,'; 
 END IF; 
 IF DDS_EVENT_CUR.BIRTH_DATE IS NOT NULL THEN 
 v_N_SQL := v_N_SQL || ', BIRTH_DATE = '||''''||DDS_EVENT_CUR.BIRTH_DATE||''''; 
 --v_N_SQL := v_N_SQL || ' BIRTH_DATE = @v_BIRTH_DATE_P,'; 
 END IF; 
 v_N_SQL := v_N_SQL || ' WHERE ENTITY_ID = :1 '; 
 
 /*BEGIN*/ EXECUTE IMMEDIATE V_N_SQL USING v_i_PI_TYPE_ENTITY_ID_GEN; 
 /* EXCEPTION 
 WHEN OTHERS THEN 
 V_ERROR_MESSAGE := SQLERRM; 
 DDS_ERROR_LOG_CAPTURE(p_JOBID => P_JOBID, 
 p_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID, 
 p_MODULE_NAME => V_MODULENAME, 
 p_CALLING_ERROR_LOCATION => 'Main', 
 p_CURRENT_ERROR_LOCATION => 'PIENTUPD', 
 p_ERROR_PROC_NAME => V_PROCNAME, 
 p_ERROR_MSG => V_ERROR_MESSAGE,-- REQUIRED FIELD 
 p_ERROR_COLUMNS => NULL, 
 p_ERROR_TABLE_TO_CHECK => 'DDS_EVENT', 
 p_ERROR_KEY_COLUMN => 'EVENT_NUMBER', 
 P_ERROR_COLUMN_KEY_VALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_IS_VALIDATION => 0); 
 
 v_I_ERRORCOUNT := v_I_ERRORCOUNT + 1; 
 END;*/ V_ERROR_LOCATION := 'INS52' ; 
 END IF; 
 --PRINT 'PI DATA IN ENTITY ENDS ' 
 --************************************************************************* 
 --*****************UPDATE PI DATA IN ENTITY ENDS ************************ 
 --************************************************************************* 
 
 --************************************************************************* 
 --******************* SUPPLEMENTAL INSERT STARTS ***************************** 
 --************************************************************************* 
 IF ( v_EVENT_SUPP <> 0 ) AND ( v_I_ERRORCOUNT = 0 ) THEN 
 
 
 IF v_i_EVENT_ID > 0 AND v_i_PI_ROW_ID = 0 THEN -- FOR EVENT ONLY --added by neha 
 
 DDS_SUPPLEMENT(P_JOBID => P_JOBID, -- 1. EVENT_SUPP 
 P_CONFIG_ID => v_CONFIG_ID, 
 P_USER_ID => V_USER_ID, 
 P_MODULE_NAME => 'EVENT', 
 P_DB_NAME => V_DBName, 
 P_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,-- Row to be executed -- MapFlag should be 0 if you dont want to execute it 
 P_CODE_CREATION_FLAG => v_CheckCreateNewCodes, 
 -- P_LOB => DDS_EVENT_CUR.LINE_OF_BUS_CODE, --neha 02/26 
 P_LOB =>0, ----neha 02/26 
 P_BASE_ERROR_COUNT => v_I_ERRORCOUNT, 
 P_STAGE => 'I',-- V for validation and I for Insert 
 P_CLAIMANT_EID => 0, 
 P_EVENT_ID => v_i_EVENT_ID, 
 P_CLAIM_ID => 0, 
 P_EMPLOYEE_EID => 0, 
 P_UNIT_ID => 0, 
 P_ENTITY_ID => 0, 
 P_DEFENDANT_ROW_ID => 0, 
 P_PI_ROW_ID => 0, 
 P_PI_PROC_ROW_ID => 0, 
 P_PATIENT_ID => 0, 
 P_TRANS_ID => 0, 
 P_PLAN_ID => 0, 
 P_EV_CONCOM_ROW_ID => 0, 
 P_EV_MW_TEST_ROW_ID => 0, 
 P_KEYCOLUMN => 'EVENT_NUMBER', 
 P_KEYVALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_SUPP_ERROR_COUNT => V_P_SUPP_ERROR_COUNT_R); 
 END IF; 
 
 
 V_ERROR_LOCATION := 'INS53' ; 
 
 IF v_i_EVENT_ID > 0 AND v_i_PI_ROW_ID > 0 AND v_i_PI_TYPE_ENTITY_ID_GEN > 0 AND v_i_PATIENT_ID_GEN = 0 THEN--FOR EMP 
 -- IF ( ( v_i_PI_ROW_ID > 0 ) ) THEN-- 4 AND 5 
 DDS_SUPPLEMENT(P_JOBID => P_JOBID, 
 P_CONFIG_ID => v_CONFIG_ID, 
 P_USER_ID => V_USER_ID, 
 P_MODULE_NAME => 'EVENT', 
 P_DB_NAME => V_DBName, 
 P_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,-- Row to be executed -- MapFlag should be 0 if you dont want to execute it 
 P_CODE_CREATION_FLAG => v_CheckCreateNewCodes, 
 --P_LOB => DDS_EVENT_CUR.LINE_OF_BUS_CODE, --neha 02/26 
 P_LOB =>0, --neha 02/26 
 P_BASE_ERROR_COUNT => v_I_ERRORCOUNT, 
 P_STAGE => 'I',-- V for validation and I for Insert 
 P_CLAIMANT_EID => 0, 
 P_EVENT_ID =>v_i_EVENT_ID , --neha 
 P_CLAIM_ID => 0, 
 P_EMPLOYEE_EID => v_i_PI_TYPE_ENTITY_ID_GEN, 
 P_UNIT_ID => 0, 
 P_ENTITY_ID => 0, 
 P_DEFENDANT_ROW_ID => 0, 
 P_PI_ROW_ID => v_i_PI_ROW_ID, 
 P_PI_PROC_ROW_ID => 0, 
 P_PATIENT_ID => 0, 
 P_TRANS_ID => 0, 
 P_PLAN_ID => 0, 
 P_EV_CONCOM_ROW_ID => 0, 
 P_EV_MW_TEST_ROW_ID => 0, 
 P_KEYCOLUMN => 'EVENT_NUMBER', 
 P_KEYVALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_SUPP_ERROR_COUNT => V_P_SUPP_ERROR_COUNT_R); 
 END IF; --NEHA 
 V_ERROR_LOCATION := 'INS54' ; 
 
 IF v_i_EVENT_ID > 0 AND v_i_PI_ROW_ID > 0 AND v_i_PI_TYPE_ENTITY_ID_GEN > 0 AND v_i_PATIENT_ID_GEN > 0 THEN-- FOR PATIENT 
 -- IF v_i_PATIENT_ID_GEN > 0 THEN-- 5. PATIENT_SUPP --**neha 
 DDS_SUPPLEMENT(P_JOBID => P_JOBID, -- 5. PATIENT_SUPP 
 P_CONFIG_ID => v_CONFIG_ID, 
 P_USER_ID => V_USER_ID, 
 P_MODULE_NAME => 'EVENT', 
 P_DB_NAME => V_DBName, 
 P_DA_ROW_ID => DDS_EVENT_CUR.DA_ROW_ID,-- Row to be executed -- MapFlag should be 0 if you dont want to execute it 
 P_CODE_CREATION_FLAG => v_CheckCreateNewCodes, 
 -- P_LOB => DDS_EVENT_CUR.LINE_OF_BUS_CODE, --neha 02/26 
 P_LOB =>0, --neha 02/26 
 P_BASE_ERROR_COUNT => v_I_ERRORCOUNT, 
 P_STAGE => 'I',-- V for validation and I for Insert 
 P_CLAIMANT_EID => 0, 
 P_EVENT_ID => v_i_EVENT_ID, -- **neha 
 P_CLAIM_ID => 0, 
 P_EMPLOYEE_EID => 0, 
 P_UNIT_ID => 0, 
 P_ENTITY_ID => 0, 
 P_DEFENDANT_ROW_ID => 0, 
 P_PI_ROW_ID => v_i_PI_ROW_ID, --neha 
 P_PI_PROC_ROW_ID => 0, 
 P_PATIENT_ID =>v_i_PATIENT_ID_GEN, 
 P_TRANS_ID => 0, 
 P_PLAN_ID => 0, 
 P_EV_CONCOM_ROW_ID => 0, 
 P_EV_MW_TEST_ROW_ID => 0, 
 P_KEYCOLUMN => 'EVENT_NUMBER', 
 P_KEYVALUE => DDS_EVENT_CUR.EVENT_NUMBER, 
 P_SUPP_ERROR_COUNT => V_P_SUPP_ERROR_COUNT_R); 
 END IF; 
 V_ERROR_LOCATION := 'INS55' ; 
 END IF; 
 
 
 
 --************************************************************************* 
 --******************* SUPPLEMENTAL INSERT ENDS ***************************** 
 --************************************************************************* 
 
 
IF V_I_ERRORCOUNT = 0 THEN 
 UPDATE DDS_EVENT SET INVALID_ROW = 0 WHERE JOBID = P_jobID AND DA_ROW_ID = DDS_EVENT_CUR.DA_ROW_ID ; V_ERROR_LOCATION := 'INS57' ; 
 COMMIT ; 
 END IF ;  
 V_ERROR_LOCATION := 'INS58' ; 
 
 ---Neha Running status code starts 33658---  
 --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);  
  
 IF v_iRunStatCnt = 1 THEN 
 BEGIN 
 v_vProcessMsg := 'Total Number of Records processed in EVENT : ' || v_iRunStatCnt; 
 EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)' 
 USING P_jobID, v_vProcessMsg, 'EVENT_RUN', 'DDS_EVENT_RUN', -11; 
 END; 
 ELSIF v_iRunCnt = 1000 THEN 
 BEGIN 
 v_vProcessMsg := 'Total Number of Records processed in EVENT : ' || v_iRunStatCnt; 
 v_N_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND  
 MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11'; 
  
 EXECUTE IMMEDIATE v_N_SQL using v_vProcessMsg, P_jobID, 'EVENT_RUN', 'DDS_EVENT_RUN'; 
 v_iRunCnt:=1; 
 END; 
 ELSIF (v_iTotCount=v_iRunStatCnt) THEN 
 BEGIN 
 v_vProcessMsg := 'Total Number of Records processed in EVENT : ' ||v_iTotCount; 
 v_N_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND  
 MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11'; 
  
             EXECUTE IMMEDIATE v_N_SQL using v_vProcessMsg, P_jobID, 'EVENT_RUN', 'DDS_EVENT_RUN';
             END;
        END IF;
       COMMIT;
    
      v_iRunStatCnt := v_iRunStatCnt + 1;
      v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658---  


      exception
 WHEN OTHERS THEN
    V_ERROR_MSG:=SQLERRM;
     DDS_ERROR_LOG_CAPTURE(P_JOBID,
         null,
         V_MODULENAME,
         'MAIN',
         V_ERROR_LOCATION,
         V_PROCNAME,
         V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
         NULL,
         'DDS_EVENT',  ---NEHA-- V_MODULENAME,  --neha 02/26
         NULL,
         NULL,
         0);
     ROLLBACK ;
   END ; -- INSERT TRY CATCH



   -- REINITIALIZE LOCAL VARIBLES START
      /*   v_I_ERRORCOUNT := 0;
         v_I_ROWCOUNT := 0;
         v_I_COUNT := 0;
         v_I_STATEID_GEN := 0;
         v_i_DEPARTMENT_GEN := 0;
         v_i_DEPT_INVOLVED_GEN := 0;
         v_i_DEPT_ASSIGNED_GEN := 0;
         v_i_FACILITY_DEPT_GEN := 0;
         v_i_OSHA_ESTAB_EID_GEN := 0;
         v_i_PI_ROW_ID := 0;
         v_i_ENTITY_ID := 0;
         v_i_EVENT_ID := 0;
         v_i_PATIENT_ID_GEN := 0;
         v_i_PI_TYPE_ENTITY_ID_GEN := 0;
         v_i_SUPERVISOR_ENTITY_ID_GEN := 0;
         v_i_PRI_PHYSICIAN_EID_GEN := 0;
         v_i_ADM_PHYSICIAN_EID_GEN := 0;
         v_vColName1 := NULL;
         v_vColName2 := NULL;
         v_vColName3 := NULL;
         v_vVal2 := NULL;
         v_vColName4 := NULL;
         v_vVal3 := NULL;
         v_i_HOSPITAL_1_EID := 0;
         v_i_HOSPITAL_2_EID := 0;
         v_i_HOSPITAL_3_EID := 0;
         v_i_PHYSICIAN_1_EID := 0;
         v_i_PHYSICIAN_2_EID := 0;
         v_i_PHYSICIAN_3_EID := 0;
         V_ERROR_MESSAGE := NULL;
         i_Reporter_ENTITY_ID_GEN := 0;
         v_STATE_R := 0;
         v_REPORTED_STATE_R := 0;
         v_PI_STATE_R := 0;
         v_DRIVLIC_STATE_R := 0;
         v_SUPER_STATE_R := 0;
         v_STATE_ROW_ID_R := 0;
         v_i_PI_WL_ROW_ID := 0;
         v_vColToProcess2 := NULL;
         v_iCount2 := 0;
         v_iCodeId := 0;
         --v_v_TIME_OF_EVENT_INVALID := 0;
         --v_v_TIME_REPORTED_INVALID := 0;
         --v_V_DATE_REPORTED_INVALID := 0;
         --v_V_DATE_OF_EVENT_INVALID := 0;
         v_vTableToProcess := NULL;
         v_i_EMPLOYEE_EID := 0;
         v_i_EVENT_ID_O := 0;
         v_i_PI_ROW_ID_OP := 0;
         v_i_Phys_EID_O := 0;
         v_i_PATIENT_EID := 0;
         v_i_EMPLOYEE_EID_UPDATE := 0;
         v_i_EMPLOYEE_EID_EN := 0;
         V_DTTM_RCD_ADDED_GEN := NULL;
         V_DTTM_RCD_LAST_UPD_GEN := NULL;
         V_UPDATED_BY_USER := NULL;
         V_ADDED_BY_USER := NULL;
         V_NEXT_UNIQUE_ID := 0;
         v_N_SQL_EVENT := NULL;
         V_ORGSEC_FLAG := 0;
         V_SEC_DEPT_EID := 0;
         v_vReqColumns := NULL;
         v_vCodeFieldList := NULL;
         v_vSysTableNameList := NULL;
         v_iPos := 0;
         v_vColName := NULL;
         v_nSql := NULL;
         v_vColList := NULL;
         v_iCount := 0;
         v_vVal := NULL;
         v_vTableList := NULL;
         v_vTableName := NULL;
         v_vColToProcess := NULL;
         v_vTab := NULL;
         v_vTabToProcess := NULL;
         v_vColInRM := NULL;
         v_vColName_value := 0;
         v_I_ON_PREMISE_FLAG_GEN := 0;
         v_I_NO_RULES_FLAG_GEN := 0;
         v_I_RECORDABLE_FLAG_GEN := 0;
         v_I_SAFEG_NOTUSED_GEN := 0;
         v_I_SAFEGUARD_FLAG_GEN := 0;
         v_I_PRIVACY_CASE_GEN := 0;
         v_WORK_SUN_FLAG_GEN := 0;
         v_WORK_MON_FLAG_GEN := 0;
         v_WORK_TUE_FLAG_GEN := 0;
         v_WORK_WED_FLAG_GEN := 0;
         v_WORK_THU_FLAG_GEN := 0;
         v_WORK_FRI_FLAG_GEN := 0;
         v_WORK_SAT_FLAG_GEN := 0;
         v_FULL_TIME_FLAG_GEN := 0;
         v_ACTIVE_FLAG_GEN := 0;
         v_EXEMPT_STATUS_FLAG_GEN := 0;
         v_INSURABLE_FLAG_GEN := 0;
         v_REGULAR_JOB_FLAG_GEN := 0;
         v_HIRED_IN_STATE_FLAG_GEN  := 0 ;
         v_LOST_WORK_FLAG_GEN := 0;
         v_P_SUPP_ERROR_COUNT_R := 0;
         v_vVal4 := 0;
         v_i_CheckNext := 0;
          V_DURATION := 0;
         v_vColToProcess1 := 0;*/
      END;      END LOOP;

    DDS_PROCESS_LOG (P_jobID,'EVENT','DDS_EVENT') ;


 exception
 WHEN OTHERS THEN
    V_ERROR_MSG:=SQLERRM;
     DDS_ERROR_LOG_CAPTURE(P_JOBID,
         null,
         V_MODULENAME,
         V_ERROR_LOCATION,
         V_ERROR_LOCATION,
         V_PROCNAME,
         V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
         NULL,
        'DDS_EVENT',  ---NEHA
         NULL,
         NULL,
         0);
      ROLLBACK ;
END DA_DDS_EVENT_IMPORT;
