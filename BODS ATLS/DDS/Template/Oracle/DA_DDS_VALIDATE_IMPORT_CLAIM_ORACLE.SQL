CREATE OR REPLACE PROCEDURE DDS_VALIDATE_CLAIM(v_P_JOBID   IN NUMBER DEFAULT NULL,
                                               v_P_DBNAME  IN VARCHAR2 DEFAULT NULL,
                                               v_P_USER_ID IN NUMBER DEFAULT NULL)
  AUTHID CURRENT_USER AS

  --*************************************************************************************************************************************************************
  --****************************************** STRUCTURE OF DDS_VALIDATE_CLAIM PROCEDURE ************************************************************************
  --*************************************************************************************************************************************************************
  --**** ****
  --**** Declaration of OptionSet Variables, Claims Record Variables, CODE_ID Variables, Other Local Variables ****
  --**** Fetching values from DDS_OPTIONSET Table from Staging ****
  --**** Fetching carrier flag, date of loss settings, entity role settings from RISKMASTER ****
  --**** Total Rows from DDS_CLAIM corresponding to current JOBID ****
  --**** Cursor declaration, start to fetch values from DDS_CLAIM Staging Table ****
  --**** Initialization of Variables to default values for each New Claims Record ****
  --**** REQUIRED FIELD VALIDATIONS, SHORT CODE FIELDS VALIDATIONS, RESERVE BUCKET MAPPING VALIDATIONS,STATE CODE FIELDS VALIDATIONS ****
  --**** FLAG INITIALIZATIONS, DATE VALIDATIONS, TIME VALIDATIONS ****
  --**** Other Format/Conditional/Options Validations ****
  --**** DEPARTMENT VALIDATION ****
  --**** Claim Existence Check ****
  --**** Event Existence check ****
  --**** Existing Claim and Existing Event validations with Current import file data ****
  --**** SUPPLEMENTAL FIELDS VALIDATION ****
  --**** ****
  --*************************************************************************************************************************************************************
  --**** If there is any Validation Error till now then Procedure will fetch NEXT record and will log errors corresponding to current record. ****
  --*************************************************************************************************************************************************************
  --**** ****
  --**** If Disability Claim: Disability Plan and Disability Class Checks are performed ****
  --**** Create New unique Claim_ID from glossary ****
  --**** Create New unique Event_ID from glossary ****
  --**** Fetch Policy information: If found then No Error otherwise Error Log ****
  --**** Fetch Values from CLAIM_X_POLICY ****
  --**** PROCESS CLAIMANT: Search Claimant in RiskMaster based on criteria selected by User for GC and VA ****
  --**** PROCESS ENTITY for CLAIMANT: ****
  --**** Search and Create Entity in RiskMaster Based on criteria selected by user for Employee and Non Employee Match.(Decide Claimant Insert or Update) ****
  --**** PROCESS EMPLOYEE: Search Employee in RiskMaster based on Employee details provided in the import file. ****
  --**** PROCESS ENTITY for EMPLOYEE: ****
  --**** Search and Create Entity in RiskMaster Based on criteria selected by user for Employee and Non Employee Match.(Decide Employee Insert or Update) ****
  --**** PROCESS ENTITY for DEFENDENT: ****
  --**** Search and Create Entity in RiskMaster Based on criteria selected by user for Employee and Non Employee Match.(Decide Defendent Insert or Update) ****
  --**** Decide EMP_X_DEPENDENT is NEW or is Existing . EMP_X_DEPENDENT is not updated as of now. ****
  --**** Decide PERSON_INVOLVED is NEW or Existing. Decide to Insert or update. ****
  --**** Decide EVENT_X_OSHA is NEW or Existing. Decide to Insert or update. ****
  --**** Decide Insert and Update for CLAIM_X_LITIGATION ****
  --**** PROCESS ENTITY for DEFENDANT: ****
  --**** Search and Create Entity in RiskMaster Based on criteria selected by user for Employee and Non Employee Match.(Decide DEFENDANT Insert or Update) ****
  --**** Search DEFENDANT and decide to Insert. ****
  --**** Search Vehicle and decide whether to create or update vehicle ****
  --**** Search UNIT_X_CLAIM for Vehicle Unit and decide to Insert or not ****
  --**** Decide UNIT_STAT is NEW or Existing and decide to Insert or Update ****
  --**** PROCESS RESERVE ONLY FOR CORPORATE ****
  --**** ****
  --*************************************************************************************************************************************************************
  --**** If there is any Validation Error till now then Procedure will fetch new record. ****
  --*************************************************************************************************************************************************************
  --**** ****
  --**** Insert/Update EVENT ****
  --**** Insert CLAIM_STATUS_HIST ****
  --**** Insert/Update CLAIM ****
  --**** Insert Employee Department and Org Hierarchy ****
  --**** Insert/Update Employee ****
  --**** Insert into EMP_X_DEPT (Employee x Dependent) ****
  --**** Insert/Update PERSON_INVOLVED ****
  --**** Insert into PI_X_BODY_PART,PI_X_INJURY, PI_X_DIAGNOSIS, PI_X_TREATMENT, PI_X_WORKLOSS, PI_X_RESTRICT ****
  --**** Insert CLAIMANT, Update ENTITY ****
  --**** Insert EVENT_X_OSHA ****
  --**** Insert/Update CLAIM_X_LITIGATION ****
  --**** Insert DEFENDANT ****
  --**** Insert/Update VEHICLE, Insert UNIT_X_CLAIM ****
  --**** Insert/Update RESERVE_CURRENT, Insert RESERVE_HISTORY ****
  --**** Insert/Update UNIT_STAT ****
  --**** Insert ACTIVITY_TRACK ****
  --**** DDS_SUPPLEMENT Insertion ****
  --**** ****
  --*************************************************************************************************************************************************************
  --*************************************************************************************************************************************************************

  -- Variables for selected Options
  v_CheckCreateNewCodes          NUMBER(5, 0);
  v_CheckCreateNewClaim          NUMBER(5, 0);
  v_CheckCreateNewEmployees      NUMBER(5, 0);
  v_CheckCreateNewDepartment     NUMBER(5, 0);
  v_IdentifyClaimantByNameGCVA   NUMBER(5, 0);
  v_IdentifyClaimantBySuffixGCVA NUMBER(5, 0);
  v_UpdateClaimantNameGCVA       NUMBER(5, 0);
  v_UpdateClaimantNameWC         NUMBER(5, 0);
  v_EmployeeMatchByName          NUMBER(5, 0);
  v_EmployeeMatchByTaxId         NUMBER(5, 0);
  v_EmployeeMatchByEmpNumber     NUMBER(5, 0);
  v_NonEmployeeMatchByName       NUMBER(5, 0);
  v_NonEmployeeMatchByTaxId      NUMBER(5, 0);
  v_NonEmployeeMatchByNameTaxId  NUMBER(5, 0);
  v_CONFIG_ID                    NUMBER(5, 0);
  v_CreateEntityIfTaxIDEmptyGCVA NUMBER(5, 0);
  v_CreatePIEntityIfTaxIDEmpty   NUMBER(5, 0);
  v_ForceCreateEntity            NUMBER := 0;
  v_Valid_Start_Date             VARCHAR2(8) := '10000101';
  v_Valid_End_Date               VARCHAR2(8) := '25000101';
  -- Variables for Claims Record Fields
  v_V_DA_ROW_ID NUMBER(10, 0);
  --v_V_JOBID NUMBER(10,0);
  v_V_INVALID_ROW  NUMBER(10, 0);
  v_V_RECORD_TYPE  VARCHAR2(2); -- Kapil 30-Sept-2016
  v_V_CLAIM_NUMBER VARCHAR2(25);
  v_V_CLAIM_SUFFIX NUMBER(10, 0);
  v_V_CLAIM_TYPE   VARCHAR2(25);
  v_V_DIVISION     VARCHAR2(25);
  v_V_LOCATION     VARCHAR2(25);
  v_V_DEPARTMENT   VARCHAR2(25);
  v_V_COMPANY      VARCHAR2(25);
  --v_V_COUNTRY VARCHAR2(20);
  v_V_DIVISION_DESC   VARCHAR2(255);
  v_V_LOCATION_DESC   VARCHAR2(255);
  v_V_DEPARTMENT_DESC VARCHAR2(255);
  v_V_COMPANY_DESC    VARCHAR2(255);
  v_V_TIME_OF_CLAIM   VARCHAR2(6);
  v_V_DATE_OF_LOSS    VARCHAR2(8);
  v_V_DATE_REPORTED   VARCHAR2(8);
  v_V_DATE_OF_CLAIM   VARCHAR2(8);
  v_V_DATE_CLOSED     VARCHAR2(14);
  v_V_DATE_REOPENED   VARCHAR2(8);
  v_V_CLAIM_STATUS    VARCHAR2(25);
  --v_V_RESERVE_A_OPENING FLOAT(53);
  v_V_RESERVE_A_CURRENT FLOAT(53);
  v_V_RESERVE_A_DATE    VARCHAR2(8);
  --v_V_PAID_A_TOTAL FLOAT(53);
  --v_V_COLLECTION_A_TOTAL FLOAT(53);
  --v_V_RESERVE_B_OPENING FLOAT(53);
  v_V_RESERVE_B_CURRENT FLOAT(53);
  v_V_RESERVE_B_DATE    VARCHAR2(8);
  --v_V_PAID_B_TOTAL FLOAT(53);
  --v_V_COLLECTION_B_TOTAL FLOAT(53);
  --v_V_RESERVE_C_OPENING FLOAT(53);
  v_V_RESERVE_C_CURRENT FLOAT(53);
  v_V_RESERVE_C_DATE    VARCHAR2(8);
  --v_V_PAID_C_TOTAL FLOAT(53);
  --v_V_COLLECTION_C_TOTAL FLOAT(53);
  --v_V_RESERVE_D_OPENING FLOAT(53);
  v_V_RESERVE_D_CURRENT FLOAT(53);
  v_V_RESERVE_D_DATE    VARCHAR2(8);
  --v_V_PAID_D_TOTAL FLOAT(53);
  --v_V_COLLECTION_D_TOTAL FLOAT(53);
  v_V_CAUSE_CODE         VARCHAR2(25);
  v_V_CLAIMANT_LASTNAME  VARCHAR2(255);
  v_V_CLAIMANT_FIRSTNAME VARCHAR2(255);
  v_V_CLAIMANT_SSN       VARCHAR2(20);
  v_V_CLAIMANT_ADDRESS1  VARCHAR2(100);
  v_V_CLAIMANT_ADDRESS2  VARCHAR2(100);
  v_V_CLAIMANT_CITY      VARCHAR2(50);
  v_V_CLAIMANT_STATE     VARCHAR2(4);
  v_V_CLAIMANT_ZIP       VARCHAR2(10);
  v_V_CLAIMANT_SEX       VARCHAR2(25);
  v_V_CLAIMANT_BIRTH_DT  VARCHAR2(8);
  v_V_CLAIMANT_PHONE     VARCHAR2(30);
  v_V_CLAIMANT_COMMENT   VARCHAR2(4000);
  v_V_DEF_LASTNAME       VARCHAR2(255);
  v_V_DEF_FIRSTNAME      VARCHAR2(255);
  v_V_DEF_ADDRESS        VARCHAR2(100);
  v_V_DEF_CITY           VARCHAR2(50);
  v_V_DEF_STATE          VARCHAR2(4);
  v_V_DEF_ZIP            VARCHAR2(10);
  v_V_DEF_PHONE          VARCHAR2(30);
  v_V_DEF_COMMENT        VARCHAR2(4000);
  v_V_CLOSURE_METHOD     VARCHAR2(25);
  v_V_DESCRIPTION        VARCHAR2(4000);
  v_V_SERVICE            VARCHAR2(25);
  v_V_ICD10_1            VARCHAR2(25); --asharma590 74846
  v_V_ICD10_2            VARCHAR2(25);
  v_V_ICD10_3            VARCHAR2(25);
  v_V_ICD10_4            VARCHAR2(25);
  v_V_ICD10_5            VARCHAR2(25);
  v_V_DIAGNOSIS_1        VARCHAR2(25);
  v_V_DIAGNOSIS_2        VARCHAR2(25);
  v_V_DIAGNOSIS_3        VARCHAR2(25);
  v_V_DIAGNOSIS_4        VARCHAR2(25);
  v_V_DIAGNOSIS_5        VARCHAR2(25);
  v_V_POLICY_NUMBER      VARCHAR2(40);
  v_V_POLICY_EFFECT_DATE VARCHAR2(8);
  v_V_POLICY_EXPIRE_DATE VARCHAR2(8);
  v_V_SUIT_DATE          VARCHAR2(8);
  v_V_CASE_NUMBER        VARCHAR2(22);
  v_V_EVENT_NUMBER       VARCHAR2(25);
  v_V_COMMENTS           VARCHAR2(4000);
  v_V_ILLNESS_CODE       VARCHAR2(25);
  v_V_INJURY_CODE_1      VARCHAR2(25);
  v_V_INJURY_CODE_2      VARCHAR2(25);
  v_V_INJURY_CODE_3      VARCHAR2(25);
  v_V_INJURY_CODE_4      VARCHAR2(25);
  v_V_INJURY_CODE_5      VARCHAR2(25);
  v_V_BODY_PART_1        VARCHAR2(25);
  v_V_BODY_PART_2        VARCHAR2(25);
  v_V_BODY_PART_3        VARCHAR2(25);
  v_V_BODY_PART_4        VARCHAR2(25);
  v_V_BODY_PART_5        VARCHAR2(25);
  v_V_EMP_DEPARTMENT     VARCHAR2(25);
  v_V_OCCUPATION         VARCHAR2(25);
  v_V_DATE_OF_BIRTH      VARCHAR2(8);
  v_V_DATE_OF_HIRE       VARCHAR2(8);
  v_V_DATE_OF_DEATH      VARCHAR2(8);
  v_V_OSHA_RECORDABLE    VARCHAR2(1);
  --v_V_EMPLOYEE_SEX VARCHAR2(25);
  v_V_WEEKLY_WAGE_RATE   FLOAT(53);
  v_V_HOURLY_WAGE_RATE   FLOAT(53);
  v_V_WEEKLY_HOURS       FLOAT(53);
  v_V_NCCI_CLASS_CODE    VARCHAR2(25);
  v_V_ACCIDENT_STATE     VARCHAR2(4);
  v_V_MARITAL_STATUS     VARCHAR2(25);
  v_V_DEPENDENT_LNAME    VARCHAR2(255);
  v_V_DEPENDENT_FNAME    VARCHAR2(255);
  v_V_DEPENDENT_BIRTH_DT VARCHAR2(8);
  v_V_LICENSE_NUMBER     VARCHAR2(22);
  v_V_LICENSE_EXPIR_DATE VARCHAR2(8);
  v_V_LICENSE_TYPE       VARCHAR2(25);
  v_V_LICENSE_RESTRICT   VARCHAR2(25);
  v_V_RETURN_WORK_DATE   VARCHAR2(8);
  v_V_ACTIVE_FLAG        VARCHAR2(1);
  --v_V_EMPLOYER_SIC_CODE VARCHAR2(25);
  --v_V_EMPLOYER_PAYROLL_CLASS_COD VARCHAR2(25);
  v_V_VEHICLE_ID           VARCHAR2(20);
  v_V_VEHICLE_YEAR         VARCHAR2(4);
  v_V_VEHICLE_MAKE         VARCHAR2(20);
  v_V_EMPLOYEE_ID          VARCHAR2(20);
  v_V_VEHICLE_MODEL        VARCHAR2(50);
  v_V_FILE_NUMBER          VARCHAR2(32);
  v_V_DATE_LAST_WORKED     VARCHAR2(8);
  v_V_CLAIMANT_MIDDLENAME  VARCHAR2(255);
  v_V_ACCIDENT_DESC        VARCHAR2(25);
  v_V_ACCIDENT_PREVENTABLE VARCHAR2(1);
  v_V_PLAN_NAME            VARCHAR2(20);
  v_V_CLASS_NAME           VARCHAR2(20);
  v_V_DISABIL_FROM_DATE    VARCHAR2(8);
  v_V_DISABIL_TO_DATE      VARCHAR2(8);
  v_V_BENEFITS_START       VARCHAR2(8);
  v_V_BENEFITS_THROUGH     VARCHAR2(8);
  v_V_DIS_TYPE             VARCHAR2(25);
  v_V_BEN_CALC_PAY_START   VARCHAR2(8);
  v_V_BEN_CALC_PAY_TO      VARCHAR2(8);
  v_V_FEDERAL_TAX_FLAG     VARCHAR2(1);
  v_V_SOCIAL_SEC_TAX_FLAG  VARCHAR2(1);
  v_V_MEDICARE_TAX_FLAG    VARCHAR2(1);
  v_V_STATE_TAX_FLAG       VARCHAR2(1);
  v_V_STD_DISABIL_TYPE     VARCHAR2(25);
  v_V_MONTHLY_RATE         FLOAT(53);
  v_V_ELIG_DIS_BEN_FLAG    VARCHAR2(1);
  v_V_DIS_OPTION_CODE      VARCHAR2(25);
  v_V_PENSION_AMT          FLOAT(53);
  v_V_SS_AMT               FLOAT(53);
  v_V_OTHER_AMT            FLOAT(53);
  --v_V_RESERVE_E_OPENING FLOAT(53);
  v_V_RESERVE_E_CURRENT FLOAT(53);
  v_V_RESERVE_E_DATE    VARCHAR2(8);
  --v_V_PAID_E_TOTAL FLOAT(53);
  --v_V_COLLECTION_E_TOTAL FLOAT(53);
  v_V_CLAIMANT_TYPE VARCHAR2(25);
  v_V_OSHA_ACC_DESC VARCHAR2(16);
  --v_V_DATE_WORKED_LAST VARCHAR2(8);
  --v_V_DATE_RETURNED VARCHAR2(8);
  v_V_STATE_DURATION            VARCHAR2(4);
  v_V_DATE_FIRST_RESTRICT       VARCHAR2(8);
  v_V_DATE_LAST_RESTRICT        VARCHAR2(8);
  v_V_PERCENT_DISABLED          VARCHAR2(4);
  v_V_SETTLEMENT_METHOD         VARCHAR2(25);
  v_V_MGND_CARE_ORG_TYPE        VARCHAR2(25);
  v_V_DISPUTED_CASE_FLAG        VARCHAR2(1);
  v_V_NCCI_LOSS_TYPE_LOSS_CODE  VARCHAR2(25);
  v_V_NCCI_LOSS_TYPE_RECOV_CODE VARCHAR2(25);
  v_V_TREATMENT_CODE            VARCHAR2(25);
  v_V_CLAIMANT_STATUS           VARCHAR2(25);
  v_V_NAME_TYPE                 VARCHAR2(25);
  v_V_POLICY_LOB                VARCHAR2(25);
  v_V_CURR_CODE                 VARCHAR2(25); --JIRA 29954 Kgupta31
  v_V_CLAIM_TYPE_DT_CHA      VARCHAR2(8);  --akumar523 JIRA 61548 starts 
  v_V_REVIEW_STATUS_CODE     VARCHAR2(25);
  v_V_REV_STA_DT_CH       VARCHAR2(8);
  v_V_REV_REASON        VARCHAR2(2000);
  v_V_CLAIM_TYP_REASON      VARCHAR2(2000);  ----akumar523 JIREA 61584 ends 

  -- CODE_ID VARIABLES
  v_V_CLAIM_TYPE_ID              NUMBER(10, 0) := 0;
  v_V_CLAIM_STATUS_ID            NUMBER(10, 0) := 0;
  v_V_CAUSE_CODE_ID              NUMBER(10, 0) := 0;
  v_V_CLAIMANT_SEX_ID            NUMBER(10, 0) := 0;
  v_V_CLOSURE_METHOD_ID          NUMBER(10, 0) := 0;
  v_V_SERVICE_ID                 NUMBER(10, 0) := 0;
  v_V_ICD10_1_ID             	 NUMBER(10, 0) := 0; --asharma590 74846
  v_V_ICD10_2_ID             	 NUMBER(10, 0) := 0;
  v_V_ICD10_3_ID             	 NUMBER(10, 0) := 0;
  v_V_ICD10_4_ID             	 NUMBER(10, 0) := 0;
  v_V_ICD10_5_ID             	 NUMBER(10, 0) := 0;
  v_V_DIAGNOSIS_1_ID             NUMBER(10, 0) := 0;
  v_V_DIAGNOSIS_2_ID             NUMBER(10, 0) := 0;
  v_V_DIAGNOSIS_3_ID             NUMBER(10, 0) := 0;
  v_V_DIAGNOSIS_4_ID             NUMBER(10, 0) := 0;
  v_V_DIAGNOSIS_5_ID             NUMBER(10, 0) := 0;
  v_V_ILLNESS_CODE_ID            NUMBER(10, 0) := 0;
  v_V_INJURY_CODE_1_ID           NUMBER(10, 0) := 0;
  v_V_INJURY_CODE_2_ID           NUMBER(10, 0) := 0;
  v_V_INJURY_CODE_3_ID           NUMBER(10, 0) := 0;
  v_V_INJURY_CODE_4_ID           NUMBER(10, 0) := 0;
  v_V_INJURY_CODE_5_ID           NUMBER(10, 0) := 0;
  v_V_BODY_PART_1_ID             NUMBER(10, 0) := 0;
  v_V_BODY_PART_2_ID             NUMBER(10, 0) := 0;
  v_V_BODY_PART_3_ID             NUMBER(10, 0) := 0;
  v_V_BODY_PART_4_ID             NUMBER(10, 0) := 0;
  v_V_BODY_PART_5_ID             NUMBER(10, 0) := 0;
  v_V_OCCUPATION_ID              NUMBER(10, 0) := 0;
  v_V_EMPLOYEE_SEX_ID            NUMBER(10, 0) := 0;
  v_V_NCCI_CLASS_CODE_ID         NUMBER(10, 0) := 0;
  v_V_MARITAL_STATUS_ID          NUMBER(10, 0) := 0;
  v_V_LICENSE_TYPE_ID            NUMBER(10, 0) := 0;
  v_V_LICENSE_RESTRICT_ID        NUMBER(10, 0) := 0;
  v_V_EMPLOYER_SIC_CODE_ID       NUMBER(10, 0) := 0;
  v_V_EMPLOYER_PAYROLL_CLASS_CO1 NUMBER(10, 0) := 0;
  v_V_ACCIDENT_DESC_ID           NUMBER(10, 0) := 0;
  v_V_STD_DISABIL_TYPE_ID        NUMBER(10, 0) := 0;
  v_V_DIS_OPTION_CODE_ID         NUMBER(10, 0) := 0;
  v_V_CLAIMANT_TYPE_ID           NUMBER(10, 0) := 0;
  v_V_SETTLEMENT_METHOD_ID       NUMBER(10, 0) := 0;
  v_V_MGND_CARE_ORG_TYPE_ID      NUMBER(10, 0) := 0;
  V_NCCI_LOSS_TYPE_LOSS_CODE_ID  NUMBER(10, 0) := 0;
  V_NCCI_LOSS_TYPE_RECOV_CODE_ID NUMBER(10, 0) := 0;
  v_V_TREATMENT_CODE_ID          NUMBER(10, 0) := 0;
  v_V_CLAIMANT_STATUS_ID         NUMBER(10, 0) := 0;
  v_V_NAME_TYPE_ID               NUMBER(10, 0) := 0;
  v_V_POLICY_LOB_ID              NUMBER(10, 0) := 0;
  v_V_CLAIMANT_STATE_ID          NUMBER(10, 0) := 0;
  v_V_DEF_STATE_ID               NUMBER(10, 0) := 0;
  v_V_ACTIVE_FLAG_ID             NUMBER(10, 0) := 0;
  v_V_ELIG_DIS_BEN_FLAG_ID       NUMBER(10, 0) := 0;
  v_V_ACC_PREV_FLAG_ID           NUMBER(10, 0) := 0;
  v_V_EMP_PI_TYPE_CODE           VARCHAR2(25) := 'E';
  v_V_EMP_PI_TYPE_CODE_ID        NUMBER(10, 0) := 0;
  v_V_OTHR_PI_TYPE_CODE          VARCHAR2(25) := 'O';
  v_V_OTHR_PI_TYPE_CODE_ID       NUMBER(10, 0) := 0;
  v_V_PI_TYPE_CODE_ID            NUMBER(10, 0) := 0;
  v_V_OPENCLAIM_CODE             VARCHAR2(25) := 'O';
  v_V_OPENCLAIM_CODE_ID          NUMBER(10, 0) := 0;
  v_V_CLOSEDCLAIM_CODE           VARCHAR2(25) := 'C';
  v_V_CLOSEDCLAIM_CODE_ID        NUMBER(10, 0) := 0;
  v_V_STATE_ID                   NUMBER(10, 0) := 0;
  v_V_FLAG_ID                    NUMBER(10, 0) := 0;
  v_V_DISPUTED_CASE_FLAG_ID      NUMBER(10, 0) := 0;
  v_V_EMP_DEP_ROW_ID             NUMBER(10, 0) := 0;
  v_V_PI_WL_ROW_ID               NUMBER(10, 0) := 0;
  v_V_PI_RSTRCT_ROW_ID           NUMBER(10, 0) := 0;
  v_V_PI_DEP_ROW_ID              NUMBER(10, 0) := 0;
  v_V_EVENT_ID_RMDB              NUMBER(10, 0) := 0;
  v_V_CLAIMANT_ROW_ID            NUMBER(10, 0) := 0;
  v_V_PRIMARY_CLMNT_FLAG         NUMBER(10, 0) := 0;
  v_V_POLICY_ID                  NUMBER(10, 0) := 0;
  v_V_OPEN_FLAG_ID               NUMBER(10, 0) := 0;
  v_V_CL_STATUS_ROW_ID           NUMBER(10, 0) := 0;
  v_V_LITIGATION_ROW_ID          NUMBER(10, 0) := 0;
  v_V_DEFENDANT_ROW_ID           NUMBER(10, 0) := 0;
  v_V_CLAIM_DEFCOUNT             NUMBER(10, 0) := 0;
  v_V_VEHICLE_UNIT_ID            NUMBER(10, 0) := 0;
  v_V_CLAIMXUNIT_ROW_ID          NUMBER(10, 0) := 0;
  v_V_EVENT_REF_LENGTH           NUMBER(10, 0) := 25; ------ MAX LENGHTH ALLOWED FOR EVENT NUMBER
  v_V_CLM_TYP_ROW_ID             NUMBER(10, 0) := 0;   --AKUMAR523 STARST jira 61584
  v_V_REVIEW_STATUS_CODE_ID      NUMBER(10, 0) := 0;
  v_V_REW_TYP_ROW_ID             NUMBER(10, 0) := 0;  ----AKUMAR523 ENDS jira 61584

  v_V_ERRORLOC       VARCHAR2(20);
  v_V_RECORD_TYPE2   VARCHAR2(2);
  V_V_REASON         VARCHAR2(255) := 'DDS Claim Record';
  v_V_CLASSROW_ID    NUMBER(10, 0) := 0;
  v_V_PLAN_ID        NUMBER(10, 0);
  v_V_TAXFLAGS       NUMBER(10, 0);
  v_V_DIS_TYPE_ID    NUMBER(10, 0);
  v_V_INSERTPLANINFO NUMBER(10, 0) := 0;
  v_V_EMP_PERSON     NUMBER(10, 0) := 0;
  v_V_TABLE_ID       NUMBER(10, 0) := 0;

  --- Other Local Variables
  v_V_ROWCOUNT              NUMBER(10, 0) := 0;
  v_V_CODE_ID_R             NUMBER(10, 0) := 0;
  v_V_CODE_ID_RMDB          NUMBER(10, 0) := 0;
  v_V_MODULENAME            VARCHAR2(100) := 'CLAIM';
  v_V_DBNAME                VARCHAR2(255);
  v_V_CLAIM_ID              NUMBER(10, 0) := 0;
  v_V_SQL                   CLOB;
  v_V_PROCNAME              VARCHAR2(30) := 'DDS_VALIDATE_CLAIM';
  v_V_TABLENAME             VARCHAR2(30) := 'DDS_CLAIM';
  v_V_DDSUSER               VARCHAR2(6) := 'DA DDS';
  v_V_ERRORCOUNT            NUMBER(10, 0) := 0;
  v_V_CLAIM_LOB             NUMBER(10, 0) := 0;
  v_V_CLAIM_LOB_RMDB        NUMBER(10, 0) := 0;
  v_V_BCLOSEDCLAIM          NUMBER(10, 0) := 0;
  v_V_BOPENCLAIM            NUMBER(10, 0) := 0;
  v_V_TEMPSHORTCODE         VARCHAR2(25) := NULL;
  v_V_DATE_CLOSED_DT        VARCHAR2(14) := NULL;
  v_V_ACCIDENT_STATE_ID     NUMBER(10, 0) := 0;
  v_V_ENTITY_ID             NUMBER(10, 0) := 0;
  v_V_DEPT_ID               NUMBER(10, 0) := 0;
  v_V_ENTITY_TABLE_ID       NUMBER(10, 0) := 0;
  v_V_ABBREVIATION          VARCHAR2(25) := NULL;
  v_V_DELETED_FLAG          NUMBER(10, 0) := 0;
  v_V_DELETED_FLAG_EMP_DEPT NUMBER(10, 0) := 0;
  v_V_DELETED_FLAG_DEPT     NUMBER(10, 0) := 0;
  v_V_ENTITY_TABLE_ID_INP   NUMBER(10, 0) := 0;
  v_V_SYS_TABLE_NAME        VARCHAR2(30) := NULL;
  v_V_EVENT_ID              NUMBER(10, 0) := 0;
  v_V_DATE_OF_EVENT         VARCHAR2(8);
  v_V_DEPT_EID              NUMBER(10, 0) := 0;
  v_V_TIME_OF_EVENT         VARCHAR2(6);
  v_V_CLAIMANT_EID          NUMBER(10, 0) := 0;
  v_V_CLAIMANT_EID_R        NUMBER(10, 0) := 0;
  v_V_EMPLOYEE_EID          NUMBER(10, 0) := 0;
  v_V_EMPLOYEE_NUMBER       VARCHAR2(25);
  v_V_DEPARTMENT_ID         NUMBER(10, 0) := 0;
  v_V_EMP_DEPT_ID           NUMBER(10, 0) := 0;
  v_V_DEPENDENT_EID         NUMBER(10, 0) := 0;
  v_V_DEFENDANT_EID         NUMBER(10, 0) := 0;
  v_V_PI_ROW_ID             NUMBER(10, 0) := 0;
  v_V_DISABILITY_CODE_ID    NUMBER(10, 0) := 0;
  v_V_DISABILITY_CODE       VARCHAR2(25) := 'ILL';

  v_V_OSHA_RECORDABLE_ID NUMBER(10, 0) := 0;
  v_V_ROLE_TABLE_ID      NUMBER(10, 0) := 0;
  v_V_PARENT_ROW_ID      NUMBER(10, 0) := 0;
  v_V_PARENT_TABLE_NAME  VARCHAR2(10);
  v_VSQLINSERT           CLOB;
  v_VSQLUPDATE           CLOB;
  VSQLINSCLT        	 CLOB; ---AKUMAR523 STARTS jira 61584
  VSQLUPDCLT       	 CLOB;  
  V_SQL_CLT          	 CLOB;
  VSQLINSREW       	 CLOB;
  V_SQL_REW         	 CLOB;
  VSQLUPDREW       	 CLOB; ----AKUMAR523 ENDS jira 61584
  v_V_EVENT_STATUS_CODE  VARCHAR2(25) := 'O'; ---- NEW CODE CANNOT BE CREATED ONLY PERMITTED VALUES ARE O OR C NOTE:

  v_V_EVENT_TYPE_CODE      VARCHAR2(25) := 'NA';
  V_V_EVENT_STATUS_CODE_ID NUMBER := 0;
  v_V_EVENT_TYPE_CODE_ID   NUMBER(10, 0) := 0;
  v_V_EVENT_IND_CODE_ID    NUMBER(10, 0) := 0;
  v_V_LASTNAME_RMDB        VARCHAR2(255);
  v_V_FIRSTNAME_RMDB       VARCHAR2(255);
  v_V_MIDNAME_RMDB         VARCHAR2(255);
  v_V_ERROR_MESSAGE        CLOB := NULL;
  v_V_RC_ROW_ID            NUMBER(10, 0) := 0;
  v_V_RSV_ROW_ID           NUMBER(10, 0) := 0;
  v_V_DATETIME             VARCHAR2(14);
  v_V_DATE_STATUS_CHGD     VARCHAR2(8);
  v_V_OLDSTATUS_ID         NUMBER(10, 0) := 0;
  v_V_CUR_RSV_AMT          FLOAT(53) := 0;
  v_V_COL_IN_RSV_BAL       NUMBER(10, 0) := 0;
  v_V_COL_IN_INC_BAL       NUMBER(10, 0) := 0;
  v_V_CHANGE_AMT           FLOAT(53) := 0;
  v_V_COL_TOTAL            FLOAT(53) := 0;
  v_V_PAID_TOTAL           FLOAT(53) := 0;
  v_V_RESERVE_AMOUNT       FLOAT(53) := 0;
  v_V_RESERVE_BALANCE      FLOAT(53) := 0;
  v_V_INCURRED_AMOUNT      FLOAT(53) := 0;
  v_V_RESERVE_DATE         VARCHAR2(8);
  v_V_BUCKETLIST           VARCHAR2(255) := NULL;
  v_V_SUPP_ERROR_COUNT     NUMBER(10, 0) := 0;
  v_V_CLAIM_SUPP           NUMBER(10, 0) := 0;
  v_V_DATE_RPTD_TO_RM      VARCHAR2(8);
  v_V_UNIT_ID_R            NUMBER(10, 0);
  v_VCLOSETIME             VARCHAR2(6);
  v_V_TIME_OF_CLAIM_RMDB   VARCHAR2(6);
  v_V_EMPLOYEE_EID_RMDB    NUMBER(10, 0);

  v_vReqColumns       VARCHAR2(4000);
  v_ILEN              NUMBER(10, 0);
  v_iPos1             NUMBER(10, 0) := 0;
  v_vColName1         VARCHAR2(100);
  v_V_VAL             VARCHAR2(4000);
  v_V_ERROR_TABLE     VARCHAR2(10) := 'DDS_CLAIM';
  v_V_BUCKETFIELDS    VARCHAR2(4000);
  v_V_CODEFIELDS      VARCHAR2(4000);
  v_V_SYSTEMTABLENAME VARCHAR2(4000);
  --v_fVersionNum NUMBER(10,1); ---RMA 25298
  v_iRetVal     NUMBER(10, 0) := 0; ---RMA 25298
  ---neha 33658 -- START
  v_iRunStatCnt    NUMBER(10, 0):=1;
  v_iRunCnt        NUMBER(10, 0):=1;
  v_vProcessMsg    varchar2(4000);
  v_iCount         NUMBER(10, 0) := 0;
  ---neha 33658 -- end
  
---AKUMAR523 61584 STARTS 
  v_V_CLTP_CHA   NUMBER := 0;
  v_V_REWTP_CHA  NUMBER := 0;
  v_ioldRevTypCode NUMBER :=0;
---AKUMAR523 61584 ENDS 

  -- USER DEFINED RESERVE MAPPING VARIABLE
  v_V_UDRM_RSV_TYPE_CODE_ID   NUMBER(10, 0) := 0;
  v_V_UDRM_RSV_TYPE_A_CODE_ID NUMBER(10, 0) := 0;
  v_V_UDRM_RSV_TYPE_B_CODE_ID NUMBER(10, 0) := 0;
  v_V_UDRM_RSV_TYPE_C_CODE_ID NUMBER(10, 0) := 0;
  v_V_UDRM_RSV_TYPE_D_CODE_ID NUMBER(10, 0) := 0;
  v_V_UDRM_RSV_TYPE_E_CODE_ID NUMBER(10, 0) := 0;
  v_V_UDRM_BUCKET_MAPPED      VARCHAR2(1);
  v_V_BUCKET                  VARCHAR2(1);
  v_V_PARM_NAME               VARCHAR2(255);
  v_V_CARRIERFLAG             NUMBER(10, 0) := 0;
  v_V_RPT_DATE_AUTO_FLAG      NUMBER(10, 0) := 0;
  v_V_USE_ENTITY_ROLE_FLAG    NUMBER(10, 0) := 0;
  v_V_NEWCLAIM                NUMBER(10, 0) := 0;
  v_V_NEWEVENT                NUMBER(10, 0) := 0;
  v_V_RESERVE_TRACKING        NUMBER(10, 0) := 0;
  v_V_DURATION                NUMBER(10, 0) := 0;
  v_V_NEW_PI                  NUMBER(10, 0) := 0;
  v_V_NEW_VEHICLE             NUMBER(10, 0) := 0;
  v_V_NEW_EMP                 NUMBER(10, 0) := 0;
  v_V_NEW_POLICY              NUMBER(10, 0) := 0;
  v_V_NEW_CLAIMANT            NUMBER(10, 0) := 0;
  v_V_NEW_EVENTXOSHA          NUMBER(10, 0) := 0;
  v_V_NEW_CLAIMXLIT           NUMBER(10, 0) := 0;
  v_V_NEW_DEPENTDENT          NUMBER(10, 0) := 0;
  v_V_NEW_UNITXCLAIM          NUMBER(10, 0) := 0;
  v_V_NEW_UNITSTAT            NUMBER(10, 0) := 0;
  v_V_NEW_DEFENDANT           NUMBER(10, 0) := 0;
  v_V_UPDATE_ENTITYNAME       NUMBER(10, 0) := 0;
  v_V_UPDATE_CLAIMANT_ADDRESS NUMBER(10, 0) := 0;
  v_V_INSERT_EMPXDEP          NUMBER(10, 0) := 0;
  v_V_NEW_CLAIMXPOLICY        NUMBER(10, 0) := 0;
  v_V_POLICY_ID_RMDB          NUMBER(10, 0) := 0;
  v_V_ROW_ID                  NUMBER(10, 0) := 0;
  v_V_WORK_SUN                NUMBER(10, 0);
  v_V_WORK_MON                NUMBER(10, 0);
  v_V_WORK_TUE                NUMBER(10, 0);
  v_V_WORK_WED                NUMBER(10, 0);
  v_V_WORK_THU                NUMBER(10, 0);
  v_V_WORK_FRI                NUMBER(10, 0);
  v_V_WORK_SAT                NUMBER(10, 0);
  v_V_DTTM_CLOSED             VARCHAR2(14);
  v_V_CLAIM_SUFFIX_RMDB       NUMBER(10, 0);
  v_V_CLAIMANT_EID_RMDB       NUMBER(10, 0);
  v_V_CLAIMANT_EID_RMDB_1     NUMBER(10, 0); ----JIRA RMA-23225
  v_iBenCodeId                NUMBER(10, 0); --JIRA 24632 knakra starts
  v_iCauseCodeId              NUMBER(10, 0);
  v_iHmiFlag                  NUMBER(10, 0);
  v_vInfoDateReq              VARCHAR2(8);
  v_vProofLossDate            VARCHAR2(8);
  v_vBenCode                  VARCHAR2(25);
  v_vClaimCauseCode           VARCHAR2(25);
  v_vTodayDate                VARCHAR2(8);
  v_vDefBirthDate             VARCHAR2(8); --JIRA 24632 knakra ends
  v_FormattedTaxid           VARCHAR2(11) := NULL; ---ssnformat
  -- Kapil
  VENTITY_TYPE             DDS_ENTITY_TYPE; -- KAPIL
  v_DDS_ORG_HIERARCHY_TYPE DDS_ORG_HIERARCHY_TYPE;

  ----JIRA RMA-22720 STARTS----
  v_V_SHORT_CODE        VARCHAR(25);
  v_V_CODE_REL_TYPE     VARCHAR(30);
  v_V_ADDClaimantASPI   NUMBER(10, 0);
  v_V_EXCLUSIONERROR    NUMBER(10, 0);
  v_V_DUPLICATECLAIMANT NUMBER(10, 0);
  ----JIRA RMA-22720 ENDS----
  v_V_SUFFIXERROR NUMBER(10, 0); ----JIRA RMA-23225

  --JIRA 23899 kgupta31 starts
  v_iVarFinKey  NUMBER := 0;
  v_fVersionNum NUMBER(10, 1);
  --v_iRetVal NUMBER := 0;
  v_iFinKeyFilter     NUMBER;
  v_iExtClmTypeCode   NUMBER;
  v_iExtPolLobCode    NUMBER;
  v_iIncClaimant      NUMBER;
  v_iIncRsvType       NUMBER;
  v_iIncRsvSubType    NUMBER;
  v_iIncPolCvgUnit    NUMBER;
  v_iIncLossType      NUMBER;
  v_iExtIncClaimant   NUMBER;
  v_iExtIncRsvType    NUMBER;
  v_iExtIncRsvSubType NUMBER;
  v_iExtIncPolCvgUnit NUMBER;
  v_iExtIncLossType   NUMBER;
  v_iRowId            NUMBER;
  v_iFinKeyErr        NUMBER;
  v_vErrorColumns     CLOB;
  --JIRA 23899 KGUPTA31 ends
  --JIRA 42212 knakra starts
  iFacEid NUMBER;
  iLocEid NUMBER;
  iDivEid NUMBER;
  iRegEid NUMBER;
  iOprEid NUMBER;
  iComEid NUMBER;
  iClntEid NUMBER;
  nSqlExec CLOB;
  --JIRA 42212 knakra ends

 v_V_CURR_CODE_ID number:= 0; --JIRA 29954 kgupta31  -- neha RMA-38951
 v_iOldClmCurrCode number:= 0; --JIRA 29954 kgupta31  -- neha RMA-38951
 vEvPrefix VARCHAR(3);      --JIRA 42981 knakra
 iEvIncYear NUMBER;         --JIRA 42981 knakra
 v_V_Count_islocked_reserve NUMBER; --JIRA udoni RMA-75601
 ----------------------------- Fetching Claim Records For Validation----------------------------------------------------
 CURSOR DDS_CLAIM_CUR ------ DECLARING CURSOR
 IS
 SELECT DA_ROW_ID,
 --JOBID,
 --INVALID_ROW,
 RECORD_TYPE,
 CLAIM_NUMBER,
 CLAIM_SUFFIX,
 CLAIM_TYPE,
 DIVISION,
 LOCATION,
 DEPARTMENT,
 COMPANY,
 --COUNTRY,
 DIVISION_DESC,
 LOCATION_DESC,
 DEPARTMENT_DESC,
 COMPANY_DESC,
 TIME_OF_CLAIM,
 DATE_OF_LOSS,
 DATE_REPORTED,
 DATE_OF_CLAIM,
 DATE_CLOSED,
 DATE_REOPENED,
 CLAIM_STATUS,
 --RESERVE_A_OPENING,
 RESERVE_A_CURRENT,
 RESERVE_A_DATE,
 --PAID_A_TOTAL,
 --COLLECTION_A_TOTAL,
 --RESERVE_B_OPENING,
 RESERVE_B_CURRENT,
 RESERVE_B_DATE,
 --PAID_B_TOTAL,
 --COLLECTION_B_TOTAL,
 --RESERVE_C_OPENING,
 RESERVE_C_CURRENT,
 RESERVE_C_DATE,
 --PAID_C_TOTAL,
 --COLLECTION_C_TOTAL,
 --RESERVE_D_OPENING,
 RESERVE_D_CURRENT,
 RESERVE_D_DATE,
 --PAID_D_TOTAL,
 --COLLECTION_D_TOTAL,
 CAUSE_CODE,
 CLAIMANT_LASTNAME,
 CLAIMANT_FIRSTNAME,
 CLAIMANT_SSN,
 CLAIMANT_ADDRESS1,
 CLAIMANT_ADDRESS2,
 CLAIMANT_CITY,
 CLAIMANT_STATE,
 CLAIMANT_ZIP,
 CLAIMANT_SEX,
 CLAIMANT_BIRTH_DT,
 CLAIMANT_PHONE,
 CLAIMANT_COMMENT,
 DEF_LASTNAME,
 DEF_FIRSTNAME,
 DEF_ADDRESS,
 DEF_CITY,
 DEF_STATE,
 DEF_ZIP,
 DEF_PHONE,
 DEF_COMMENT,
 CLOSURE_METHOD,
 DESCRIPTION,
 SERVICE,
 ICD10_1,--asharma590 jira 74846
 ICD10_2,
 ICD10_3,
 ICD10_4,
 ICD10_5,
 DIAGNOSIS_1,
 DIAGNOSIS_2,
 DIAGNOSIS_3,
 DIAGNOSIS_4,
 DIAGNOSIS_5,
 POLICY_NUMBER,
 POLICY_EFFECT_DATE,
 POLICY_EXPIRE_DATE,
 SUIT_DATE,
 CASE_NUMBER,
 EVENT_NUMBER,
 COMMENTS,
 ILLNESS_CODE,
 INJURY_CODE_1,
 INJURY_CODE_2,
 INJURY_CODE_3,
 INJURY_CODE_4,
 INJURY_CODE_5,
 BODY_PART_1,
 BODY_PART_2,
 BODY_PART_3,
 BODY_PART_4,
 BODY_PART_5,
 EMP_DEPARTMENT,
 OCCUPATION,
 DATE_OF_BIRTH,
 DATE_OF_HIRE,
 DATE_OF_DEATH,
 OSHA_RECORDABLE,
 --EMPLOYEE_SEX,
 WEEKLY_WAGE_RATE,
 HOURLY_WAGE_RATE,
 WEEKLY_HOURS,
 NCCI_CLASS_CODE,
 ACCIDENT_STATE,
 MARITAL_STATUS,
 DEPENDENT_LNAME,
 DEPENDENT_FNAME,
 DEPENDENT_BIRTH_DT,
 LICENSE_NUMBER,
 LICENSE_EXPIR_DATE,
 LICENSE_TYPE,
 LICENSE_RESTRICT,
 RETURN_WORK_DATE,
 ACTIVE_FLAG,
 --EMPLOYER_SIC_CODE,
 --EMPLOYER_PAYROLL_CLASS_CODE,
 VEHICLE_ID,
 VEHICLE_YEAR,
 VEHICLE_MAKE,
 EMPLOYEE_ID,
 VEHICLE_MODEL,
 FILE_NUMBER,
 DATE_LAST_WORKED,
 CLAIMANT_MIDDLENAME,
 ACCIDENT_DESC,
 ACCIDENT_PREVENTABLE,
 /* USER_FIELD_A,
 USER_FIELD_B,
 USER_FIELD_C,
 USER_FIELD_D,
 USER_FIELD_E,
 USER_FIELD_F,
 USER_FIELD_G,
 USER_FIELD_H,
 USER_FIELD_I,
 USER_FIELD_J,
 USER_FIELD_K,
 USER_FIELD_L,
 USER_FIELD_M,
 USER_FIELD_N,
 USER_FIELD_O,
 USER_FIELD_P,
 USER_FIELD_Q,
 USER_FIELD_R,
 USER_FIELD_S,
 USER_FIELD_T,
 USER_FIELD_U,
 USER_FIELD_V,
 USER_FIELD_W,
 USER_FIELD_X,
 USER_FIELD_Y,
 USER_FIELD_Z,
 */
 PLAN_NAME,
 CLASS_NAME,
 DISABIL_FROM_DATE,
 DISABIL_TO_DATE,
 BENEFITS_START,
 BENEFITS_THROUGH,
 DIS_TYPE,
 BEN_CALC_PAY_START,
 BEN_CALC_PAY_TO,
 FEDERAL_TAX_FLAG,
 SOCIAL_SEC_TAX_FLAG,
 MEDICARE_TAX_FLAG,
 STATE_TAX_FLAG,
 STD_DISABIL_TYPE,
 MONTHLY_RATE,
 ELIG_DIS_BEN_FLAG,
 DIS_OPTION_CODE,
 PENSION_AMT,
 SS_AMT,
 OTHER_AMT,
 --RESERVE_E_OPENING,
 RESERVE_E_CURRENT,
 RESERVE_E_DATE,
 --PAID_E_TOTAL,
 --COLLECTION_E_TOTAL,
 CLAIMANT_TYPE,
 OSHA_ACC_DESC,
 --DATE_WORKED_LAST,
 --DATE_RETURNED,
 STATE_DURATION,
 DATE_FIRST_RESTRICT,
 DATE_LAST_RESTRICT,
 PERCENT_DISABLED,
 SETTLEMENT_METHOD,
 MGND_CARE_ORG_TYPE,
 DISPUTED_CASE_FLAG,
 NCCI_LOSS_TYPE_LOSS_CODE,
 NCCI_LOSS_TYPE_RECOV_CODE,
 TREATMENT_CODE,
 CLAIMANT_STATUS,
 NAME_TYPE,
 --JIRA 24632 knakra starts
 BENEFICIARY_CODE,
 INFO_REQ_DATE,
 PROOF_OF_LOSS_DATE,
 CLAIM_CAUSE_CODE,
 DEF_BIRTH_DT,
 --JIRA 24632 knakra ends
 POLICY_LOB,
 CURR_CODE, -- JIRA 29954 kgupta31
 CLAIM_TYPE_DATE_CHANGED,    ---akumar523 61584 starts 
 REVIEW_STATUS_CODE, 
 REVIEW_STATUS_DATE_CHANGED, 
 REVIEW_REASON, 
 CLAIM_TYPE_REASON        -----akumar523 61584 end 
 FROM DDS_CLAIM
 WHERE JOBID = v_P_JOBID
 AND INVALID_ROW = 1;
 ----BEGIN TRY ----BEGIN MAIN TRY

BEGIN
 ----BEGIN MAIN
 ---- FETCHING VALUES FROM DDS_OPTIONSET
 ------------------------- FOR SQL db name has to be suffixed by dbo -----------------------------------------
 IF v_P_DBName IS NOT NULL THEN
 v_V_DBNAME := v_P_DBNAME || '.';
 END IF;

 --RMA-25298 JIRA starts--
 DDS_spCheckVersion(v_vTableName => 'UNIT_X_CLAIM',
 v_vFieldName => 'DTTM_RCD_ADDED',
 vDbName => v_P_DBNAME,
 v_iRetVal => v_iRetVal);
 IF v_iRetVal = 1 THEN
 V_fVersionNum := 16.2;
 END IF;
 --RMA-25298 JIRA ends--

 --JIRA 29954 kgupta31 starts
 v_iRetVal := 0;

 DDS_spCheckVersion('RESERVE_HISTORY',
 'CLAIM_CURR_CHANGE_AMOUNT',
 v_P_DBNAME,
 v_iRetVal);

 IF v_iRetVal <> 0 AND v_iRetVal IS NOT NULL THEN
 v_fVersionNum := 16.4;
 END IF;
 --JIRA 29954 kgupta31 ends
 v_iRetVal := 0;

 DDS_spCheckVersion('FUNDS',
 'DISABILITY_CLASS_ROW_ID',
 v_P_DBNAME,
 v_iRetVal);

 IF v_iRetVal <> 0 AND v_iRetVal IS NOT NULL THEN
 v_fVersionNum := 17.3;
 END IF;
 --JIRA 23899 KGUPTA31 starts
 DDS_spCheckVersion('FINANCIAL_KEY', 'ROW_ID', v_P_DBNAME, v_iRetVal);

 IF v_iRetVal <> 0 AND v_iRetVal IS NOT NULL THEN
 v_iVarFinKey := 1;
 END IF;
 --JIRA 23899 KGUPTA31 ends
--AKUMAR523 STARTS RMA-61584
DDS_spCheckVersion('CLAIM_TYPE_HIST','CLM_TYPE_CODE',v_P_DBNAME,v_iRetVal);

IF v_iRetVal <> 0 AND v_iRetVal IS NOT NULL THEN
v_fVersionNum := 19.1;
END IF;
---AKUMAR523 ENDS RMA-61584
---udoni RMA-75601 starts
DDS_spCheckVersion('RESERVE_CURRENT','IS_LOCKED',v_P_DBNAME,v_iRetVal);

IF v_iRetVal <> 0 AND v_iRetVal IS NOT NULL THEN
v_fVersionNum := 20.2;
END IF;
--udoni RMA-75601 ends

 --JIRA 24632 knakra starts
 v_V_SQL := 'SELECT C.CODE_ID FROM ' || v_V_DBNAME ||
 'CODES C INNER JOIN ' || v_V_DBNAME ||
 'GLOSSARY G ON C.TABLE_ID = G.TABLE_ID';
 v_V_SQL := v_V_SQL ||
 ' WHERE C.SHORT_CODE = ''HC'' AND G.SYSTEM_TABLE_NAME = ''LINE_OF_BUSINESS'''; -- Kapil 30-Sept-2016

 BEGIN
 EXECUTE IMMEDIATE v_V_SQL
 INTO v_iHmiFlag;
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 v_iHmiFlag := 0;
 END;
 
  --JIRA 42981 knakra starts
  v_V_SQL := 'SELECT EV_PREFIX, EV_INC_YEAR_FLAG FROM ' || v_V_DBNAME || 'SYS_PARMS';

  EXECUTE IMMEDIATE v_V_SQL INTO vEvPrefix, iEvIncYear;
  --JIRA 42981 knakra ends
 
 IF v_iHmiFlag IS NOT NULL AND v_iHmiFlag > 0 THEN
 v_iHmiFlag := 1;
 END IF;

 v_v_sql := 'select to_char(sysdate,' || '''' || 'yyyymmdd' || '''' ||
 ') from dual'; -- Kapil 30-Sept-2016

 EXECUTE IMMEDIATE v_V_SQL
 into v_vTodayDate;

 --JIRA 24632 kankra ends

 ----------------------------- Storing Values into Optionset variables ---------------------------------------
 v_V_ERRORLOC := 'Z001';
 BEGIN ----Neha Running status starts 33658
 SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_CLAIM WHERE JOBID = v_P_JOBID AND INVALID_ROW=1;
 exception
 when no_data_found then
 null;
 END; --Neha Running status ends 33658
 BEGIN
 SELECT ALLOW_NEW_CLAIMS,
 ALLOW_NEW_CODES,
 ALLOW_NEW_EMPLOYEES,
 ALLOW_NEW_DEPARTMENT,
 ID_CLAIMANT_BY_NAME_GCVA,
 ID_CLAIMANT_BY_SUFFIX_GCVA,
 UPDATE_CLAIMANT_NAME_GCVA,
 UPDATE_CLAIMANT_NAME_WC,
 EMPLOYEE_MATCH_BY_NAME,
 EMPLOYEE_MATCH_BY_TAX_ID,
 EMPLOYEE_MATCH_BY_EMP_NUM,
 NON_EMP_MATCH_BY_NAME,
 NON_EMP_MATCH_BY_TAX_ID,
 NON_EMP_MATCH_BY_NAME_TAX_ID,
 CONFIG_ID,
 CREATE_PI_ENT_IF_TAXID_EMPTY,
 VALID_START_DATE,
 VALID_END_DATE,
 CLAIM_SUPP
 INTO v_CheckCreateNewClaim,
 v_CheckCreateNewCodes,
 v_CheckCreateNewEmployees,
 v_CheckCreateNewDepartment,
 v_IdentifyClaimantByNameGCVA,
 v_IdentifyClaimantBySuffixGCVA,
 v_UpdateClaimantNameGCVA,
 v_UpdateClaimantNameWC,
 v_EmployeeMatchByName,
 v_EmployeeMatchByTaxId,
 v_EmployeeMatchByEmpNumber,
 v_NonEmployeeMatchByName,
 v_NonEmployeeMatchByTaxId,
 v_NonEmployeeMatchByNameTaxId,
 v_CONFIG_ID,
 v_CreatePIEntityIfTaxIDEmpty,
 v_Valid_Start_Date,
 v_Valid_End_Date,
 v_V_CLAIM_SUPP
 FROM DDS_OPTIONSET
 WHERE JOBID = v_P_JOBID;
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
 v_CheckCreateNewClaim := NULL;
 WHEN OTHERS THEN
 ----------- NOTE: IF NO ROWS ARE THERE IN DDS OPTIONSET THEN EXIT THIS PROCEDURE AS THERE IS NO POINT I GOING FORWARD WITHOUT OPTIONSET VALUES
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
 v_V_CLAIM_NUMBER,
 0);
 v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
 END;

 IF v_CheckCreateNewClaim IS NULL THEN
 DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
 v_V_DA_ROW_ID,
 v_V_MODULENAME,
 v_V_ERRORLOC,
 v_V_ERRORLOC,
 v_V_PROCNAME,
 'No rows are there in DDS_Optionset.',
 'JOB_ID',
 'DDS_OPTIONSET',
 'JOB_ID',
 v_P_JOBID,
 1);
 GOTO ENDMAIN;
 END IF;

 BEGIN
 ---- FETCHING CARRIER FLAG
 v_V_ERRORLOC := 'Z002';

    --JIRA 23899 kgupta31 starts
    IF v_iVarFinKey <> 0 THEN
      v_V_PARM_NAME := 'FINANCIAL_KEY_FILTER';

    ELSE
      v_V_PARM_NAME := 'MULTI_COVG_CLM';
      --JIRA 23899 kgupta31 ends
    END IF;

    v_V_SQL := 'SELECT STR_PARM_VALUE FROM ' || v_V_DBNAME ||
               'PARMS_NAME_VALUE ' || ' WHERE PARM_NAME = :1';

    --JIRA 23899 kgupta31 starts
    IF v_iVarFinKey <> 0 then
      EXECUTE IMMEDIATE V_V_SQL
        INTO v_iFinKeyFilter
        USING v_V_PARM_NAME;
    ELSE
      EXECUTE IMMEDIATE V_V_SQL
        INTO v_V_CARRIERFLAG
        USING v_V_PARM_NAME;
    END if;
    --JIRA 23899 kgupta31 ends

  EXCEPTION
    WHEN OTHERS THEN
      ----PRINT 'CARRIER FLAG: ' + CAST(@V_CARRIERFLAG AS VARCHAR(2));
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
                            v_V_CLAIM_NUMBER,
                            0);

      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
  END;

  BEGIN
    ---- FETCHING DATE OF LOSS SETTINGS
    v_V_ERRORLOC  := 'Z004';
    v_V_PARM_NAME := 'RPT_DATE_AUTO_FLAG';
    v_V_SQL       := 'SELECT STR_PARM_VALUE FROM ' || v_V_DBNAME ||
                     'PARMS_NAME_VALUE' || ' WHERE PARM_NAME = :1';
    EXECUTE IMMEDIATE V_V_SQL
      INTO v_V_RPT_DATE_AUTO_FLAG
      USING v_V_PARM_NAME;
  EXCEPTION
    WHEN OTHERS THEN
      ----PRINT 'DATE OF LOSS FLAG: ' + CAST(@V_RPT_DATE_AUTO_FLAG AS VARCHAR(2))
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
                            v_V_CLAIM_NUMBER,
                            0);
      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
  END;

  BEGIN
    ---- FETCH ENTITY ROLE SETTINGS
    v_V_ERRORLOC  := 'Z005';
    v_V_PARM_NAME := 'USE_ENTITY_ROLE';
    v_V_SQL       := 'SELECT STR_PARM_VALUE FROM ' || v_V_DBNAME ||
                     'PARMS_NAME_VALUE' || ' WHERE PARM_NAME = :1';
    EXECUTE IMMEDIATE V_V_SQL
      INTO v_V_USE_ENTITY_ROLE_FLAG
      USING v_V_PARM_NAME;
  EXCEPTION
    WHEN OTHERS THEN
      ----PRINT 'USE ENTITY ROLE FLAG: ' + CAST(@V_USE_ENTITY_ROLE_FLAG AS VARCHAR(2))
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
                            v_V_CLAIM_NUMBER,
                            0);
      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
  END;

  BEGIN
    ---- FETCH ADD CLAIMANT AS PERSON INVOLVED SETTINGS
    v_V_ERRORLOC  := 'Z007';
    v_V_PARM_NAME := 'ADD_CLAIMANT_PI';
    v_V_SQL       := 'SELECT STR_PARM_VALUE FROM ' || v_V_DBNAME ||
                     'PARMS_NAME_VALUE' || ' WHERE PARM_NAME = :1';
    EXECUTE IMMEDIATE V_V_SQL
      INTO v_V_ADDClaimantASPI
      USING v_V_PARM_NAME;
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
                            'CLAIM_NUMBER',
                            v_V_CLAIM_NUMBER,
                            0);
      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
  END;

  -- REMOVE DA ROW ID CHECK
  OPEN DDS_CLAIM_CUR; ---- OPENING CURSOR
  LOOP
    FETCH DDS_CLAIM_CUR
      INTO v_V_DA_ROW_ID,
    --v_V_JOBID,v_V_INVALID_ROW,v_V_COUNTRY,v_V_RESERVE_A_OPENING,v_V_PAID_A_TOTAL,v_V_COLLECTION_A_TOTAL,v_V_RESERVE_B_OPENING,v_V_PAID_B_TOTAL,v_V_COLLECTION_B_TOTAL,v_V_RESERVE_C_OPENING,v_V_PAID_C_TOTAL,v_V_COLLECTION_C_TOTAL,v_V_RESERVE_D_OPENING,v_V_PAID_D_TOTAL,v_V_COLLECTION_D_TOTAL,v_V_EMPLOYEE_SEX,v_V_EMPLOYER_SIC_CODE,v_V_EMPLOYER_PAYROLL_CLASS_COD,v_V_USER_FIELD_A,v_V_USER_FIELD_B,v_V_USER_FIELD_C,v_V_USER_FIELD_D,v_V_USER_FIELD_E,v_V_USER_FIELD_F,v_V_USER_FIELD_G,v_V_USER_FIELD_H,v_V_USER_FIELD_I,v_V_USER_FIELD_J,v_V_USER_FIELD_K,v_V_USER_FIELD_L,v_V_USER_FIELD_M,v_V_USER_FIELD_N,v_V_USER_FIELD_O,v_V_USER_FIELD_P,v_V_USER_FIELD_Q,v_V_USER_FIELD_R,v_V_USER_FIELD_S,v_V_USER_FIELD_T,v_V_USER_FIELD_U,v_V_USER_FIELD_V,v_V_USER_FIELD_W,v_V_USER_FIELD_X,v_V_USER_FIELD_Y,v_V_USER_FIELD_Z,v_V_DATE_WORKED_LAST,v_V_DATE_RETURNED,v_V_RESERVE_E_OPENING,v_V_PAID_E_TOTAL,v_V_COLLECTION_E_TOTAL,
    v_V_RECORD_TYPE, v_V_CLAIM_NUMBER, v_V_CLAIM_SUFFIX, v_V_CLAIM_TYPE, v_V_DIVISION, v_V_LOCATION, v_V_DEPARTMENT, v_V_COMPANY, v_V_DIVISION_DESC, v_V_LOCATION_DESC, v_V_DEPARTMENT_DESC, v_V_COMPANY_DESC, v_V_TIME_OF_CLAIM, v_V_DATE_OF_LOSS, v_V_DATE_REPORTED, v_V_DATE_OF_CLAIM, v_V_DATE_CLOSED, v_V_DATE_REOPENED, v_V_CLAIM_STATUS, v_V_RESERVE_A_CURRENT, v_V_RESERVE_A_DATE, v_V_RESERVE_B_CURRENT, v_V_RESERVE_B_DATE, v_V_RESERVE_C_CURRENT, v_V_RESERVE_C_DATE, v_V_RESERVE_D_CURRENT, v_V_RESERVE_D_DATE, v_V_CAUSE_CODE, v_V_CLAIMANT_LASTNAME, v_V_CLAIMANT_FIRSTNAME, v_V_CLAIMANT_SSN, v_V_CLAIMANT_ADDRESS1, v_V_CLAIMANT_ADDRESS2, v_V_CLAIMANT_CITY, v_V_CLAIMANT_STATE, v_V_CLAIMANT_ZIP, v_V_CLAIMANT_SEX, v_V_CLAIMANT_BIRTH_DT, v_V_CLAIMANT_PHONE, v_V_CLAIMANT_COMMENT, v_V_DEF_LASTNAME, v_V_DEF_FIRSTNAME, v_V_DEF_ADDRESS, v_V_DEF_CITY, v_V_DEF_STATE, v_V_DEF_ZIP, v_V_DEF_PHONE, v_V_DEF_COMMENT, v_V_CLOSURE_METHOD, v_V_DESCRIPTION, v_V_SERVICE, v_V_ICD10_1,v_V_ICD10_2,v_V_ICD10_3,v_V_ICD10_4,v_V_ICD10_5,v_V_DIAGNOSIS_1, v_V_DIAGNOSIS_2, v_V_DIAGNOSIS_3, v_V_DIAGNOSIS_4, v_V_DIAGNOSIS_5, v_V_POLICY_NUMBER, v_V_POLICY_EFFECT_DATE, v_V_POLICY_EXPIRE_DATE, v_V_SUIT_DATE, v_V_CASE_NUMBER, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_ILLNESS_CODE, v_V_INJURY_CODE_1, v_V_INJURY_CODE_2, v_V_INJURY_CODE_3, v_V_INJURY_CODE_4, v_V_INJURY_CODE_5, v_V_BODY_PART_1, v_V_BODY_PART_2, v_V_BODY_PART_3, v_V_BODY_PART_4, v_V_BODY_PART_5, v_V_EMP_DEPARTMENT, v_V_OCCUPATION, v_V_DATE_OF_BIRTH, v_V_DATE_OF_HIRE, v_V_DATE_OF_DEATH, v_V_OSHA_RECORDABLE, v_V_WEEKLY_WAGE_RATE, v_V_HOURLY_WAGE_RATE, v_V_WEEKLY_HOURS, v_V_NCCI_CLASS_CODE, v_V_ACCIDENT_STATE, v_V_MARITAL_STATUS, v_V_DEPENDENT_LNAME, v_V_DEPENDENT_FNAME, v_V_DEPENDENT_BIRTH_DT, v_V_LICENSE_NUMBER, v_V_LICENSE_EXPIR_DATE, v_V_LICENSE_TYPE, v_V_LICENSE_RESTRICT, v_V_RETURN_WORK_DATE, v_V_ACTIVE_FLAG, v_V_VEHICLE_ID, v_V_VEHICLE_YEAR, v_V_VEHICLE_MAKE, v_V_EMPLOYEE_ID, v_V_VEHICLE_MODEL, v_V_FILE_NUMBER, v_V_DATE_LAST_WORKED, v_V_CLAIMANT_MIDDLENAME, v_V_ACCIDENT_DESC, v_V_ACCIDENT_PREVENTABLE, v_V_PLAN_NAME, v_V_CLASS_NAME, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_FEDERAL_TAX_FLAG, v_V_SOCIAL_SEC_TAX_FLAG, v_V_MEDICARE_TAX_FLAG, v_V_STATE_TAX_FLAG, v_V_STD_DISABIL_TYPE, v_V_MONTHLY_RATE, v_V_ELIG_DIS_BEN_FLAG, v_V_DIS_OPTION_CODE, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, v_V_RESERVE_E_CURRENT, v_V_RESERVE_E_DATE, v_V_CLAIMANT_TYPE, v_V_OSHA_ACC_DESC, v_V_STATE_DURATION, v_V_DATE_FIRST_RESTRICT, v_V_DATE_LAST_RESTRICT, v_V_PERCENT_DISABLED, v_V_SETTLEMENT_METHOD, v_V_MGND_CARE_ORG_TYPE, v_V_DISPUTED_CASE_FLAG, v_V_NCCI_LOSS_TYPE_LOSS_CODE, v_V_NCCI_LOSS_TYPE_RECOV_CODE, v_V_TREATMENT_CODE, v_V_CLAIMANT_STATUS, v_V_NAME_TYPE, v_vBenCode, v_vInfoDateReq, v_vProofLossDate, v_vClaimCauseCode, v_vDefBirthDate, v_V_POLICY_LOB, v_V_CURR_CODE,v_V_CLAIM_TYPE_DT_CHA,v_V_REVIEW_STATUS_CODE, v_V_REV_STA_DT_CH, v_V_REV_REASON, v_V_CLAIM_TYP_REASON;
    EXIT WHEN DDS_CLAIM_CUR%NOTFOUND;
    --WHILE v_TOTALROWS <> 0
    --LOOP
    BEGIN
      BEGIN
        BEGIN
          ----BEGIN MAIN TRY
          v_V_ERRORLOC := 'Z007';
          DBMS_OUTPUT.put_LINE('anand_sql111-->'||v_V_CLAIM_TYP_REASON);
        

          ----PRINT 'BEGIN STARTED WITH FETCH STATUS: ' + CAST(@TOTALROWS AS VARCHAR(1))
          ----FETCHING LOB TYPES NOTE: fetch these values from glossary
          ----PRINT '************************************************************************************************************************************************'
          IF v_V_RECORD_TYPE = 'G' THEN
            v_V_RECORD_TYPE2 := 'GC';
          ELSE
            IF v_V_RECORD_TYPE = 'W' THEN
              v_V_RECORD_TYPE2 := 'WC';
            ELSE
              IF v_V_RECORD_TYPE = 'V' THEN
                v_V_RECORD_TYPE2 := 'VA';
              ELSE
                IF v_V_RECORD_TYPE = 'D' THEN
                  v_V_RECORD_TYPE2 := 'DI';
                ELSE
                  IF v_V_RECORD_TYPE = 'H' THEN
                    --JIRA 24634 knakra starts
                    v_V_RECORD_TYPE2 := 'HC'; -- Kapil 3-Oct-2016
                  ELSE
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Unknown Record Type.',
                                          'RECORD_TYPE',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    GOTO FETCHNEXT;
                  END IF; --JIRA 24634 knakra ends
                END IF;
              END IF;
            END IF;
          END IF;

          ----************** INITIALIZATION OF VARIABLES ******************

          v_V_INVALID_ROW                := 0;
          v_V_ERRORCOUNT                 := 0;
          v_V_CLAIM_TYPE_ID              := 0;
          v_V_CLAIM_STATUS_ID            := 0;
          v_V_CAUSE_CODE_ID              := 0;
          v_V_CLAIMANT_SEX_ID            := 0;
          v_V_CLOSURE_METHOD_ID          := 0;
          v_V_SERVICE_ID                 := 0;
		  v_V_ICD10_1_ID                 := 0;--asharma590 74846
          v_V_ICD10_2_ID                 := 0;
		  v_V_ICD10_3_ID                 := 0;
		  v_V_ICD10_4_ID                 := 0;
		  v_V_ICD10_5_ID                 := 0;
		  v_V_DIAGNOSIS_1_ID             := 0;
          v_V_DIAGNOSIS_2_ID             := 0;
          v_V_DIAGNOSIS_3_ID             := 0;
          v_V_DIAGNOSIS_4_ID             := 0;
          v_V_DIAGNOSIS_5_ID             := 0;
          v_V_ILLNESS_CODE_ID            := 0;
          v_V_INJURY_CODE_1_ID           := 0;
          v_V_INJURY_CODE_2_ID           := 0;
          v_V_INJURY_CODE_3_ID           := 0;
          v_V_INJURY_CODE_4_ID           := 0;
          v_V_INJURY_CODE_5_ID           := 0;
          v_V_BODY_PART_1_ID             := 0;
          v_V_BODY_PART_2_ID             := 0;
          v_V_BODY_PART_3_ID             := 0;
          v_V_BODY_PART_4_ID             := 0;
          v_V_BODY_PART_5_ID             := 0;
          v_V_OCCUPATION_ID              := 0;
          v_V_EMPLOYEE_SEX_ID            := 0;
          v_V_NCCI_CLASS_CODE_ID         := 0;
          v_V_MARITAL_STATUS_ID          := 0;
          v_V_LICENSE_TYPE_ID            := 0;
          v_V_LICENSE_RESTRICT_ID        := 0;
          v_V_EMPLOYER_SIC_CODE_ID       := 0;
          v_V_EMPLOYER_PAYROLL_CLASS_CO1 := 0;
          v_V_ACCIDENT_DESC_ID           := 0;
          v_V_STD_DISABIL_TYPE_ID        := 0;
          v_V_DIS_OPTION_CODE_ID         := 0;
          v_V_CLAIMANT_TYPE_ID           := 0;
          v_V_SETTLEMENT_METHOD_ID       := 0;
          v_V_MGND_CARE_ORG_TYPE_ID      := 0;
          V_NCCI_LOSS_TYPE_LOSS_CODE_ID  := 0;
          V_NCCI_LOSS_TYPE_RECOV_CODE_ID := 0;
          v_V_TREATMENT_CODE_ID          := 0;
          v_V_CLAIMANT_STATUS_ID         := 0;
          v_V_NAME_TYPE_ID               := 0;
          v_V_POLICY_LOB_ID              := 0;
          v_V_PLAN_ID                    := 0;
          v_V_TAXFLAGS                   := 0;
          v_V_CLAIMANT_STATE_ID          := 0;
          v_V_DEF_STATE_ID               := 0;
          v_V_ACTIVE_FLAG_ID             := 0;
          v_V_ELIG_DIS_BEN_FLAG_ID       := 0;
          v_V_ACC_PREV_FLAG_ID           := 0;
          v_V_EMP_PI_TYPE_CODE_ID        := 0;
          v_V_OTHR_PI_TYPE_CODE_ID       := 0;
          v_V_PI_TYPE_CODE_ID            := 0;
          v_V_OPENCLAIM_CODE_ID          := 0;
          v_V_CLOSEDCLAIM_CODE_ID        := 0;
          v_V_STATE_ID                   := 0;
          v_V_FLAG_ID                    := 0;
          v_V_DISPUTED_CASE_FLAG_ID      := 0;
          v_V_EMP_DEP_ROW_ID             := 0;
          v_V_PI_WL_ROW_ID               := 0;
          v_V_PI_RSTRCT_ROW_ID           := 0;
          v_V_PI_DEP_ROW_ID              := 0;
          v_V_EVENT_ID_RMDB              := 0;
          v_V_CLAIMANT_ROW_ID            := 0;
          v_V_PRIMARY_CLMNT_FLAG         := 0;
          v_V_POLICY_ID                  := 0;
          v_V_OPEN_FLAG_ID               := 0;
          v_V_CL_STATUS_ROW_ID           := 0;
          v_V_LITIGATION_ROW_ID          := 0;
          v_V_DEFENDANT_ROW_ID           := 0;
          v_V_CLAIM_DEFCOUNT             := 0;
          v_V_VEHICLE_UNIT_ID            := 0;
          v_V_CLAIMXUNIT_ROW_ID          := 0;
          v_V_ROWCOUNT                   := 0;
          v_V_CODE_ID_R                  := 0;
          v_V_CLAIM_ID                   := 0;
          v_V_BCLOSEDCLAIM               := 0;
          v_V_BOPENCLAIM                 := 0;
          v_V_TEMPSHORTCODE              := '';
          v_V_ACCIDENT_STATE_ID          := 0;
          v_V_ENTITY_ID                  := 0;
          v_V_DEPT_ID                    := 0;
          v_V_ENTITY_TABLE_ID            := 0;
          v_V_ABBREVIATION               := '';
          v_V_DELETED_FLAG               := 0;
          v_V_ENTITY_TABLE_ID_INP        := 0;
          v_V_SYS_TABLE_NAME             := '';
          v_V_EVENT_ID                   := 0;
          v_V_DEPT_EID                   := 0;
          v_V_UDRM_RSV_TYPE_CODE_ID      := 0;
          v_V_PARM_NAME                  := '';
          v_V_NEWCLAIM                   := 0;
          v_V_NEWEVENT                   := 0;
          v_V_RESERVE_TRACKING           := 0;
          v_V_DURATION                   := 0;
          v_V_POLICY_ID                  := 0;
          v_V_EMP_DEP_ROW_ID             := 0;
          v_V_ERRORLOC                   := '';
          v_V_RESERVE_TRACKING           := 0;
          v_V_DURATION                   := 0;
          v_V_NEW_PI                     := 0;
          v_V_NEW_VEHICLE                := 0;
          v_V_NEW_EMP                    := 0;
          v_V_NEW_POLICY                 := 0;
          v_V_NEW_CLAIMANT               := 0;
          v_V_NEW_EVENTXOSHA             := 0;
          v_V_NEW_CLAIMXLIT              := 0;
          v_V_NEW_DEPENTDENT             := 0;
          v_V_NEW_UNITXCLAIM             := 0;
          v_V_NEW_UNITSTAT               := 0;
          v_V_NEW_DEFENDANT              := 0;
          v_V_UPDATE_ENTITYNAME          := 0;
          v_V_UPDATE_CLAIMANT_ADDRESS    := 0;
          v_V_INSERT_EMPXDEP             := 0;
          v_V_TABLE_ID                   := 0;

          v_V_COL_IN_RSV_BAL := 0;
          v_V_COL_IN_INC_BAL := 0;
          v_V_EMP_PERSON     := 1;

          v_V_CLAIM_SUFFIX_RMDB   := 0;
          v_V_CLAIMANT_EID_RMDB   := 0;
          v_V_CLAIMANT_EID_RMDB_1 := 0; ----JIRA RMA-23225

          ----JIRA RMA-22720 STARTS----
          v_V_DATE_CLOSED_DT    := NULL;
          v_V_EXCLUSIONERROR    := 0;
          v_V_DUPLICATECLAIMANT := 0;
          ----JIRA RMA-22720 ENDS----

          v_V_SUFFIXERROR := 0; ----JIRA RMA-23225

          --JIRA 23899 kgupta31 starts
          v_iExtClmTypeCode   := NULL;
          v_iExtPolLobCode    := NULL;
          v_iIncClaimant      := NULL;
          v_iIncLossType      := NULL;
          v_iIncPolCvgUnit    := NULL;
          v_iIncRsvSubType    := NULL;
          v_iIncRsvType       := NULL;
          v_iExtIncClaimant   := NULL;
          v_iExtIncLossType   := NULL;
          v_iExtIncPolCvgUnit := NULL;
          v_iExtIncRsvSubType := NULL;
          v_iExtIncRsvType    := NULL;
          v_iRowId            := NULL;
          --JIRA 23899 kgupta31 ends

          --JIRA 24634 knakra starts
          v_iCauseCodeId := 0;
          v_iBenCodeId   := 0;
          /* v_vProofLossDate := NULL;
          v_vInfoDateReq := NULL;
          v_vDefBirthDate := NULL; */ -- Kapil Commented on 4-Oct-2016 -- Birthdate value getting reset here due to which err was coming

          --JIRA 24634 knakra ends
          --JIRA 42212 knakra starts
          iFacEid := 0;
          iLocEid := 0;
          iDivEid := 0;
          iRegEid := 0;
          iOprEid := 0;
          iComEid := 0;
          iClntEid := 0;
          --JIRA 42212 knakra ends
    ---akuma523 JIRA61584 starts 
      	 v_V_CLTP_CHA := 0;
      	 v_V_REWTP_CHA := 0;
      	 v_V_CLM_TYP_ROW_ID := 0;       
      	 v_V_REVIEW_STATUS_CODE_ID := 0;   
         v_V_REW_TYP_ROW_ID := 0; 
		 v_ioldRevTypCode := 0;
    ---akumar523 JIRA 61584 ends 
          IF v_V_ILLNESS_CODE IS NULL THEN
            v_V_DISABILITY_CODE := 'INJ';
          END IF;

          IF v_V_DATE_CLOSED IS NOT NULL AND LENGTH(v_V_DATE_CLOSED) >= 8 THEN
            v_V_DATE_CLOSED_DT := SUBSTR(v_V_DATE_CLOSED, 1, 8);
          END IF;

          /* IF v_V_TIME_OF_CLAIM IS NULL THEN
          v_V_TIME_OF_CLAIM := '000000';
          END IF;*/

          /* IF v_V_DATE_OF_DEATH IS NULL THEN
          v_V_DATE_OF_DEATH := '00000000';
          END IF;*/

          BEGIN
            --********* REQUIRED FIELD VALIDATION STARTS **********************************************
            v_V_ERRORLOC  := 'V001';
            v_vReqColumns := 'RECORD_TYPE|CLAIM_NUMBER|CLAIM_TYPE|DEPARTMENT|';
            v_vReqColumns := v_vReqColumns ||
                             'DATE_OF_LOSS|DATE_REPORTED|DATE_OF_CLAIM|';
            v_vReqColumns := v_vReqColumns ||
                             'CLAIM_STATUS|CLAIMANT_LASTNAME|';

            -- IF (v_V_RECORD_TYPE = 'W') OR (v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0) THEN -- Commented by KGupta31 for JIRA#23899
            ----verify this condition
            IF (v_V_RECORD_TYPE = 'W' AND v_iVarFinKey = 0) OR
               (v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0 AND
               v_iVarFinKey = 0) OR
               (v_V_RECORD_TYPE IN ('W', 'D') AND v_iVarFinKey <> 0) -- Added by KGupta31 for JIRA#23899
             THEN

              v_vReqColumns := v_vReqColumns ||
                               'EMPLOYEE_ID|EMP_DEPARTMENT|CLAIMANT_SSN|ACCIDENT_STATE|';
            END IF;

            -- IF (v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0) THEN -- Commented by KGupta31 for JIRA#23899
            IF (v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0 AND
               v_iVarFinKey = 0) or
               (v_V_RECORD_TYPE = 'D' AND v_iVarFinKey <> 0) -- Added by KGupta31 for JIRA#23899
             THEN
              v_vReqColumns := v_vReqColumns ||
                               'DISABIL_FROM_DATE|PLAN_NAME|';
            END IF;

            -- IF (v_V_CARRIERFLAG <> 0) THEN -- Commented by KGupta31 for JIRA#23899
            IF (v_V_CARRIERFLAG <> 0 AND v_iVarFinKey = 0) OR
               (v_iVarFinKey <> 0 AND v_iFinKeyFilter <> 0) then
              -- Added by KGupta31 for JIRA#23899
              v_vReqColumns := v_vReqColumns || 'POLICY_LOB|';
            END IF;

            WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
             LOOP
              v_iPos1       := INSTR(v_vReqColumns, '|', 1);
              v_vColName1   := SUBSTR(v_vReqColumns,
                                      1,
                                      INSTR(v_vReqColumns, '|', 1) - 1);
              v_vReqColumns := SUBSTR(v_vReqColumns,
                                      LENGTH(SUBSTR(v_vReqColumns,
                                                    1,
                                                    INSTR(v_vReqColumns,
                                                          '|',
                                                          1))) + 1,
                                      LENGTH(v_vReqColumns));
              v_V_VAL       := (CASE WHEN v_vColName1 = 'RECORD_TYPE' THEN v_V_RECORD_TYPE WHEN v_vColName1 = 'CLAIM_NUMBER' THEN v_V_CLAIM_NUMBER WHEN v_vColName1 = 'CLAIM_TYPE' THEN v_V_CLAIM_TYPE WHEN v_vColName1 = 'DEPARTMENT' THEN v_V_DEPARTMENT WHEN v_vColName1 = 'DATE_OF_LOSS' THEN v_V_DATE_OF_LOSS WHEN v_vColName1 = 'DATE_REPORTED' THEN v_V_DATE_REPORTED WHEN v_vColName1 = 'DATE_OF_CLAIM' THEN v_V_DATE_OF_CLAIM WHEN v_vColName1 = 'CLAIM_STATUS' THEN v_V_CLAIM_STATUS WHEN v_vColName1 = 'CLAIMANT_LASTNAME' THEN v_V_CLAIMANT_LASTNAME WHEN v_vColName1 = 'EMPLOYEE_ID' THEN v_V_EMPLOYEE_ID WHEN v_vColName1 = 'EMP_DEPARTMENT' THEN v_V_EMP_DEPARTMENT WHEN v_vColName1 = 'CLAIMANT_SSN' THEN v_V_CLAIMANT_SSN WHEN v_vColName1 = 'ACCIDENT_STATE' THEN v_V_ACCIDENT_STATE WHEN v_vColName1 = 'DISABIL_FROM_DATE' THEN v_V_DISABIL_FROM_DATE WHEN v_vColName1 = 'PLAN_NAME' THEN v_V_PLAN_NAME WHEN v_VCOLNAME1 = 'POLICY_LOB' THEN v_V_POLICY_LOB END);

              IF v_V_VAL IS NULL THEN
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Required Field is Null or Empty.',
                                      v_vColName1,
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);
              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

          END;

          BEGIN
            --***************** REQUIRED FIELD VALIDATION ENDS ******************************************
            ----***************** SHORT CODE FIELDS VALIDATION STARTS *********************************
            v_V_ERRORLOC   := 'V002';
            v_V_CODEFIELDS := 'RECORD_TYPE|CLAIM_TYPE|CLAIM_STATUS|CAUSE_CODE|CLAIMANT_SEX|CLOSURE_METHOD|SERVICE|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'ICD10_1|ICD10_2|ICD10_3|ICD10_4|ICD10_5|DIAGNOSIS_1|DIAGNOSIS_2|DIAGNOSIS_3|DIAGNOSIS_4|DIAGNOSIS_5|'; --asharma590 jira 74846
            v_V_CODEFIELDS := v_V_CODEFIELDS || 'ILLNESS_CODE|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'INJURY_CODE_1|INJURY_CODE_2|INJURY_CODE_3|INJURY_CODE_4|INJURY_CODE_5|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'BODY_PART_1|BODY_PART_2|BODY_PART_3|BODY_PART_4|BODY_PART_5|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'OCCUPATION|NCCI_CLASS_CODE|MARITAL_STATUS|LICENSE_TYPE|LICENSE_RESTRICT|ACCIDENT_DESC|STD_DISABIL_TYPE|DIS_OPTION_CODE|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'CLAIMANT_TYPE|SETTLEMENT_METHOD|MGND_CARE_ORG_TYPE|NCCI_LOSS_TYPE_LOSS_CODE|NCCI_LOSS_TYPE_RECOV_CODE|TREATMENT_CODE|';
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'CLAIMANT_STATUS|NAME_TYPE|POLICY_LOB|DIS_TYPE|';
            ---- BELOW MENTIONED CODES ARE NOT IN IMPORT FILE. THESE CODES ARE HARDCODED IN THE CODE AND NEEDS TO BE VERIFIED BEFORE IMPORTING VALUES.
            v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              ---akumar523 starts 62604
							  ---'DISABILITY_CODE|PERSON_INV_TYPE_E|PERSON_INV_TYPE_O|OPEN_CLAIM_STATUS|CLOSED_CLAIM_STATUS|EVENT_STATUS|EVENT_TYPE|EVENT_IND|';
							  'DISABILITY_CODE|PERSON_INV_TYPE_E|PERSON_INV_TYPE_O|OPEN_CLAIM_STATUS|CLOSED_CLAIM_STATUS|EVENT_STATUS|EVENT_IND|';
							---akumar523 ends 62604
			v_V_CODEFIELDS := v_V_CODEFIELDS ||
                              'BENEFICIARY_CODE|CLAIM_CAUSE_CODE|'; --JIRA 24634 knakra
            v_V_CODEFIELDS := v_V_CODEFIELDS || 'CURR_CODE|'; --JIRA 29954 kgupta31

            v_V_SYSTEMTABLENAME := 'LINE_OF_BUSINESS|CLAIM_TYPE|CLAIM_STATUS|CAUSE_CODE|SEX_CODE|CLOSE_METHOD|SERVICE_CODE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'DIAGNOSIS_CODE_ICD10|DIAGNOSIS_CODE_ICD10|DIAGNOSIS_CODE_ICD10|DIAGNOSIS_CODE_ICD10|DIAGNOSIS_CODE_ICD10|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME || 'ILLNESS_TYPE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'BODY_PART|BODY_PART|BODY_PART|BODY_PART|BODY_PART|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'POSITIONS|NCCI_CLASS_CODE|MARITAL_STATUS|LICENSE_TYPE_CODE|LIC_RESTRICTION|ACCIDENT_DESC_CODE|STD_DISABIL_TYPE|DIS_OPTION_CODE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'CLAIMANT_TYPE|SETTLEMENT_METHOD|MGND_CARE_ORG_TYPE|NCCI_LOSS_CODE|NCCI_RECOV_CODE|TREATMENT_TYPE|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'CLAIMANT_STATUS|ENTITY_NAME_TYPE|POLICY_CLAIM_LOB|BENEFIT_DIS_TYPE|';
            ---- BELOW MENTIONED CODES ARE NOT IN IMPORT FILE. THESE CODES ARE HARDCODED IN THE CODE AND NEEDS TO BE VERIFIED BEFORE IMPORTING VALUES.
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
							----akumar523 62604
                           ---        'DISABILITY_CODE|PERSON_INV_TYPE|PERSON_INV_TYPE|CLAIM_STATUS|CLAIM_STATUS|EVENT_STATUS|EVENT_TYPE|EVENT_INDICATOR|';
								   'DISABILITY_CODE|PERSON_INV_TYPE|PERSON_INV_TYPE|CLAIM_STATUS|CLAIM_STATUS|EVENT_STATUS|EVENT_INDICATOR|';
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME ||
                                   'BENEFICIARY_CODE|CAUSE_DEATH|'; --JIRA 24634 knakra
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME || 'CURRENCY_TYPE|'; -- JIRA 29954 kgupta31
            v_V_SYSTEMTABLENAME := v_V_SYSTEMTABLENAME || 'CLAIM_REVIEW_STATUS|'; ---AKUMAR523 jira 61584
      
            WHILE INSTR(v_V_CODEFIELDS, '|', 1) > 0 --CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
             LOOP
              v_iPos1             := INSTR(v_V_CODEFIELDS, '|', 1);
              v_VCOLNAME1         := SUBSTR(v_V_CODEFIELDS,
                                            1,
                                            INSTR(v_V_CODEFIELDS, '|', 1) - 1);
              v_V_CODEFIELDS      := SUBSTR(v_V_CODEFIELDS,
                                            LENGTH(SUBSTR(v_V_CODEFIELDS,
                                                          1,
                                                          INSTR(v_V_CODEFIELDS,
                                                                '|',
                                                                1))) + 1,
                                            LENGTH(v_V_CODEFIELDS));
              v_iPos1             := INSTR(v_V_SYSTEMTABLENAME, '|', 1);
              v_V_TABLENAME       := SUBSTR(v_V_SYSTEMTABLENAME,
                                            1,
                                            INSTR(v_V_SYSTEMTABLENAME,
                                                  '|',
                                                  1) - 1);
              v_V_SYSTEMTABLENAME := SUBSTR(v_V_SYSTEMTABLENAME,
                                            LENGTH(SUBSTR(v_V_SYSTEMTABLENAME,
                                                          1,
                                                          INSTR(v_V_SYSTEMTABLENAME,
                                                                '|',
                                                                1))) + 1,
                                            LENGTH(v_V_SYSTEMTABLENAME));
			---akumar523 starts 62604
			--   v_V_VAL := (CASE WHEN v_VCOLNAME1 = 'RECORD_TYPE' THEN v_V_RECORD_TYPE2 WHEN v_VCOLNAME1 = 'CLAIM_TYPE' THEN v_V_CLAIM_TYPE WHEN v_VCOLNAME1 = 'CLAIM_STATUS' THEN v_V_CLAIM_STATUS WHEN v_VCOLNAME1 = 'CAUSE_CODE' THEN v_V_CAUSE_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_SEX' THEN v_V_CLAIMANT_SEX WHEN v_VCOLNAME1 = 'CLOSURE_METHOD' THEN v_V_CLOSURE_METHOD WHEN v_VCOLNAME1 = 'SERVICE' THEN v_V_SERVICE WHEN v_VCOLNAME1 = 'DIAGNOSIS_1' THEN v_V_DIAGNOSIS_1 WHEN v_VCOLNAME1 = 'DIAGNOSIS_2' THEN v_V_DIAGNOSIS_2 WHEN v_VCOLNAME1 = 'DIAGNOSIS_3' THEN v_V_DIAGNOSIS_3 WHEN v_VCOLNAME1 = 'DIAGNOSIS_4' THEN v_V_DIAGNOSIS_4 WHEN v_VCOLNAME1 = 'DIAGNOSIS_5' THEN v_V_DIAGNOSIS_5 WHEN v_VCOLNAME1 = 'ILLNESS_CODE' THEN v_V_ILLNESS_CODE WHEN v_VCOLNAME1 = 'INJURY_CODE_1' THEN v_V_INJURY_CODE_1 WHEN v_VCOLNAME1 = 'INJURY_CODE_2' THEN v_V_INJURY_CODE_2 WHEN v_VCOLNAME1 = 'INJURY_CODE_3' THEN v_V_INJURY_CODE_3 WHEN v_VCOLNAME1 = 'INJURY_CODE_4' THEN v_V_INJURY_CODE_4 WHEN v_VCOLNAME1 = 'INJURY_CODE_5' THEN v_V_INJURY_CODE_5 WHEN v_VCOLNAME1 = 'BODY_PART_1' THEN v_V_BODY_PART_1 WHEN v_VCOLNAME1 = 'BODY_PART_2' THEN v_V_BODY_PART_2 WHEN v_VCOLNAME1 = 'BODY_PART_3' THEN v_V_BODY_PART_3 WHEN v_VCOLNAME1 = 'BODY_PART_4' THEN v_V_BODY_PART_4 WHEN v_VCOLNAME1 = 'BODY_PART_5' THEN v_V_BODY_PART_5 WHEN v_VCOLNAME1 = 'OCCUPATION' THEN v_V_OCCUPATION WHEN v_VCOLNAME1 = 'NCCI_CLASS_CODE' THEN v_V_NCCI_CLASS_CODE WHEN v_VCOLNAME1 = 'MARITAL_STATUS' THEN v_V_MARITAL_STATUS WHEN v_VCOLNAME1 = 'LICENSE_TYPE' THEN v_V_LICENSE_TYPE WHEN v_VCOLNAME1 = 'LICENSE_RESTRICT' THEN v_V_LICENSE_RESTRICT WHEN v_VCOLNAME1 = 'ACCIDENT_DESC' THEN v_V_ACCIDENT_DESC WHEN v_VCOLNAME1 = 'STD_DISABIL_TYPE' THEN v_V_STD_DISABIL_TYPE WHEN v_VCOLNAME1 = 'DIS_OPTION_CODE' THEN v_V_DIS_OPTION_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_TYPE' THEN v_V_CLAIMANT_TYPE WHEN v_VCOLNAME1 = 'SETTLEMENT_METHOD' THEN v_V_SETTLEMENT_METHOD WHEN v_VCOLNAME1 = 'MGND_CARE_ORG_TYPE' THEN v_V_MGND_CARE_ORG_TYPE WHEN v_VCOLNAME1 = 'NCCI_LOSS_TYPE_LOSS_CODE' THEN v_V_NCCI_LOSS_TYPE_LOSS_CODE WHEN v_VCOLNAME1 = 'NCCI_LOSS_TYPE_RECOV_CODE' THEN v_V_NCCI_LOSS_TYPE_RECOV_CODE WHEN v_VCOLNAME1 = 'TREATMENT_CODE' THEN v_V_TREATMENT_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_STATUS' THEN v_V_CLAIMANT_STATUS WHEN v_VCOLNAME1 = 'NAME_TYPE' THEN v_V_NAME_TYPE WHEN v_VCOLNAME1 = 'POLICY_LOB' THEN v_V_POLICY_LOB WHEN v_VCOLNAME1 = 'DISABILITY_CODE' THEN v_V_DISABILITY_CODE WHEN v_VCOLNAME1 = 'PERSON_INV_TYPE_E' THEN v_V_EMP_PI_TYPE_CODE WHEN v_VCOLNAME1 = 'PERSON_INV_TYPE_O' THEN v_V_OTHR_PI_TYPE_CODE WHEN v_VCOLNAME1 = 'OPEN_CLAIM_STATUS' THEN v_V_OPENCLAIM_CODE WHEN v_VCOLNAME1 = 'CLOSED_CLAIM_STATUS' THEN v_V_CLOSEDCLAIM_CODE WHEN v_VCOLNAME1 = 'EVENT_STATUS' THEN v_V_EVENT_STATUS_CODE WHEN v_VCOLNAME1 = 'EVENT_TYPE' THEN v_V_EVENT_TYPE_CODE WHEN v_VCOLNAME1 = 'DIS_TYPE' THEN v_V_DIS_TYPE WHEN v_vColName1 = 'BENEFICIARY_CODE' THEN v_vBenCode WHEN v_vColName1 = 'CLAIM_CAUSE_CODE' THEN v_vClaimCauseCode WHEN v_vColName1 = 'CURR_CODE' THEN v_V_CURR_CODE WHEN v_vColName1= 'REVIEW_STATUS_CODE' THEN v_V_REVIEW_STATUS_CODE END); --JIRA 24634 knakra  ,AKUMAR523  jira 61584 ADDED REVIEW_STATUS_CODE
				v_V_VAL := (CASE WHEN v_VCOLNAME1 = 'RECORD_TYPE' THEN v_V_RECORD_TYPE2 WHEN v_VCOLNAME1 = 'CLAIM_TYPE' THEN v_V_CLAIM_TYPE WHEN v_VCOLNAME1 = 'CLAIM_STATUS' THEN v_V_CLAIM_STATUS WHEN v_VCOLNAME1 = 'CAUSE_CODE' THEN v_V_CAUSE_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_SEX' THEN v_V_CLAIMANT_SEX WHEN v_VCOLNAME1 = 'CLOSURE_METHOD' THEN v_V_CLOSURE_METHOD WHEN v_VCOLNAME1 = 'SERVICE' THEN v_V_SERVICE WHEN v_VCOLNAME1 = 'ICD10_1' THEN v_V_ICD10_1 WHEN v_VCOLNAME1 = 'ICD10_2' THEN v_V_ICD10_2 WHEN v_VCOLNAME1 = 'ICD10_3' THEN v_V_ICD10_3 WHEN v_VCOLNAME1 = 'ICD10_4' THEN v_V_ICD10_4 WHEN v_VCOLNAME1 = 'ICD10_5' THEN v_V_ICD10_5 WHEN v_VCOLNAME1 = 'DIAGNOSIS_1' THEN v_V_DIAGNOSIS_1 WHEN v_VCOLNAME1 = 'DIAGNOSIS_2' THEN v_V_DIAGNOSIS_2 WHEN v_VCOLNAME1 = 'DIAGNOSIS_3' THEN v_V_DIAGNOSIS_3 WHEN v_VCOLNAME1 = 'DIAGNOSIS_4' THEN v_V_DIAGNOSIS_4 WHEN v_VCOLNAME1 = 'DIAGNOSIS_5' THEN v_V_DIAGNOSIS_5 WHEN v_VCOLNAME1 = 'ILLNESS_CODE' THEN v_V_ILLNESS_CODE WHEN v_VCOLNAME1 = 'INJURY_CODE_1' THEN v_V_INJURY_CODE_1 WHEN v_VCOLNAME1 = 'INJURY_CODE_2' THEN v_V_INJURY_CODE_2 WHEN v_VCOLNAME1 = 'INJURY_CODE_3' THEN v_V_INJURY_CODE_3 WHEN v_VCOLNAME1 = 'INJURY_CODE_4' THEN v_V_INJURY_CODE_4 WHEN v_VCOLNAME1 = 'INJURY_CODE_5' THEN v_V_INJURY_CODE_5 WHEN v_VCOLNAME1 = 'BODY_PART_1' THEN v_V_BODY_PART_1 WHEN v_VCOLNAME1 = 'BODY_PART_2' THEN v_V_BODY_PART_2 WHEN v_VCOLNAME1 = 'BODY_PART_3' THEN v_V_BODY_PART_3 WHEN v_VCOLNAME1 = 'BODY_PART_4' THEN v_V_BODY_PART_4 WHEN v_VCOLNAME1 = 'BODY_PART_5' THEN v_V_BODY_PART_5 WHEN v_VCOLNAME1 = 'OCCUPATION' THEN v_V_OCCUPATION WHEN v_VCOLNAME1 = 'NCCI_CLASS_CODE' THEN v_V_NCCI_CLASS_CODE WHEN v_VCOLNAME1 = 'MARITAL_STATUS' THEN v_V_MARITAL_STATUS WHEN v_VCOLNAME1 = 'LICENSE_TYPE' THEN v_V_LICENSE_TYPE WHEN v_VCOLNAME1 = 'LICENSE_RESTRICT' THEN v_V_LICENSE_RESTRICT WHEN v_VCOLNAME1 = 'ACCIDENT_DESC' THEN v_V_ACCIDENT_DESC WHEN v_VCOLNAME1 = 'STD_DISABIL_TYPE' THEN v_V_STD_DISABIL_TYPE WHEN v_VCOLNAME1 = 'DIS_OPTION_CODE' THEN v_V_DIS_OPTION_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_TYPE' THEN v_V_CLAIMANT_TYPE WHEN v_VCOLNAME1 = 'SETTLEMENT_METHOD' THEN v_V_SETTLEMENT_METHOD WHEN v_VCOLNAME1 = 'MGND_CARE_ORG_TYPE' THEN v_V_MGND_CARE_ORG_TYPE WHEN v_VCOLNAME1 = 'NCCI_LOSS_TYPE_LOSS_CODE' THEN v_V_NCCI_LOSS_TYPE_LOSS_CODE WHEN v_VCOLNAME1 = 'NCCI_LOSS_TYPE_RECOV_CODE' THEN v_V_NCCI_LOSS_TYPE_RECOV_CODE WHEN v_VCOLNAME1 = 'TREATMENT_CODE' THEN v_V_TREATMENT_CODE WHEN v_VCOLNAME1 = 'CLAIMANT_STATUS' THEN v_V_CLAIMANT_STATUS WHEN v_VCOLNAME1 = 'NAME_TYPE' THEN v_V_NAME_TYPE WHEN v_VCOLNAME1 = 'POLICY_LOB' THEN v_V_POLICY_LOB WHEN v_VCOLNAME1 = 'DISABILITY_CODE' THEN v_V_DISABILITY_CODE WHEN v_VCOLNAME1 = 'PERSON_INV_TYPE_E' THEN v_V_EMP_PI_TYPE_CODE WHEN v_VCOLNAME1 = 'PERSON_INV_TYPE_O' THEN v_V_OTHR_PI_TYPE_CODE WHEN v_VCOLNAME1 = 'OPEN_CLAIM_STATUS' THEN v_V_OPENCLAIM_CODE WHEN v_VCOLNAME1 = 'CLOSED_CLAIM_STATUS' THEN v_V_CLOSEDCLAIM_CODE WHEN v_VCOLNAME1 = 'EVENT_STATUS' THEN v_V_EVENT_STATUS_CODE WHEN v_VCOLNAME1 = 'DIS_TYPE' THEN v_V_DIS_TYPE WHEN v_vColName1 = 'BENEFICIARY_CODE' THEN v_vBenCode WHEN v_vColName1 = 'CLAIM_CAUSE_CODE' THEN v_vClaimCauseCode WHEN v_vColName1 = 'CURR_CODE' THEN v_V_CURR_CODE WHEN v_vColName1= 'REVIEW_STATUS_CODE' THEN v_V_REVIEW_STATUS_CODE END); --JIRA 24634 knakra  ,AKUMAR523  jira 61584 ADDED REVIEW_STATUS_CODE
			---akumar523 ends 62604
              --WHEN @VCOLNAME1 = 'EVENT_IND' THEN @V_EVENT_IND_CODE
              ----PRINT 'CODE CHECK BEGINS'
              ----PRINT @V_VAL
              IF v_V_VAL IS NOT NULL THEN
                ---AND @V_VAL <> '0'
                ----PRINT 'CODE CHECK BEGINS2'
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
                                           p_ERROR_KEY_COLUMN       => 'CLAIM_NUMBER',
                                           p_ERROR_COLUMN           => v_VCOLNAME1,
                                           p_ERROR_TABLE_TO_CHECK   => v_V_ERROR_TABLE,
                                           P_ERROR_COLUMN_KEY_VALUE => v_V_CLAIM_NUMBER,
                                           P_CODE_ID_R              => v_V_CODE_ID_R);

                IF v_V_CODE_ID_R = 0 OR v_V_CODE_ID_R IS NULL THEN
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                END IF;

                IF v_VCOLNAME1 = 'RECORD_TYPE' THEN
                  v_V_CLAIM_LOB := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLAIM_TYPE' THEN
                  v_V_CLAIM_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLAIM_STATUS' THEN
                  v_V_CLAIM_STATUS_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CAUSE_CODE' THEN
                  v_V_CAUSE_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLAIMANT_SEX' THEN
                  v_V_CLAIMANT_SEX_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLOSURE_METHOD' THEN
                  v_V_CLOSURE_METHOD_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'SERVICE' THEN
                  v_V_SERVICE_ID := v_V_CODE_ID_R;
				ELSIF v_VCOLNAME1 = 'ICD10_1' THEN --asharma590 jira 74846 
                  v_V_ICD10_1_ID := v_V_CODE_ID_R;
				ELSIF v_VCOLNAME1 = 'ICD10_2' THEN 
                  v_V_ICD10_2_ID := v_V_CODE_ID_R;
				ELSIF v_VCOLNAME1 = 'ICD10_3' THEN 
                  v_V_ICD10_3_ID := v_V_CODE_ID_R;
				ELSIF v_VCOLNAME1 = 'ICD10_4' THEN 
                  v_V_ICD10_4_ID := v_V_CODE_ID_R;
				ELSIF v_VCOLNAME1 = 'ICD10_5' THEN 
                  v_V_ICD10_5_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIAGNOSIS_1' THEN
                  v_V_DIAGNOSIS_1_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIAGNOSIS_2' THEN
                  v_V_DIAGNOSIS_2_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIAGNOSIS_3' THEN
                  v_V_DIAGNOSIS_3_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIAGNOSIS_4' THEN
                  v_V_DIAGNOSIS_4_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIAGNOSIS_5' THEN
                  v_V_DIAGNOSIS_5_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'ILLNESS_CODE' THEN
                  v_V_ILLNESS_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'INJURY_CODE_1' THEN
                  v_V_INJURY_CODE_1_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'INJURY_CODE_2' THEN
                  v_V_INJURY_CODE_2_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'INJURY_CODE_3' THEN
                  v_V_INJURY_CODE_3_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'INJURY_CODE_4' THEN
                  v_V_INJURY_CODE_4_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'INJURY_CODE_5' THEN
                  v_V_INJURY_CODE_5_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'BODY_PART_1' THEN
                  v_V_BODY_PART_1_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'BODY_PART_2' THEN
                  v_V_BODY_PART_2_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'BODY_PART_3' THEN
                  v_V_BODY_PART_3_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'BODY_PART_4' THEN
                  v_V_BODY_PART_4_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'BODY_PART_5' THEN
                  v_V_BODY_PART_5_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'OCCUPATION' THEN
                  v_V_OCCUPATION_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'NCCI_CLASS_CODE' THEN
                  v_V_NCCI_CLASS_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'MARITAL_STATUS' THEN
                  v_V_MARITAL_STATUS_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'LICENSE_TYPE' THEN
                  v_V_LICENSE_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'LICENSE_RESTRICT' THEN
                  v_V_LICENSE_RESTRICT_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'ACCIDENT_DESC' THEN
                  v_V_ACCIDENT_DESC_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'STD_DISABIL_TYPE' THEN
                  v_V_STD_DISABIL_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DIS_OPTION_CODE' THEN
                  v_V_DIS_OPTION_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLAIMANT_TYPE' THEN
                  v_V_CLAIMANT_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'SETTLEMENT_METHOD' THEN
                  v_V_SETTLEMENT_METHOD_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'MGND_CARE_ORG_TYPE' THEN
                  v_V_MGND_CARE_ORG_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'NCCI_LOSS_TYPE_LOSS_CODE' THEN
                  V_NCCI_LOSS_TYPE_LOSS_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'NCCI_LOSS_TYPE_RECOV_CODE' THEN
                  V_NCCI_LOSS_TYPE_RECOV_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'TREATMENT_CODE' THEN
                  v_V_TREATMENT_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLAIMANT_STATUS' THEN
                  v_V_CLAIMANT_STATUS_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'NAME_TYPE' THEN
                  v_V_NAME_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'POLICY_LOB' THEN
                  v_V_POLICY_LOB_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'DISABILITY_CODE' THEN
                  v_V_DISABILITY_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'PERSON_INV_TYPE_E' THEN
                  v_V_EMP_PI_TYPE_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'PERSON_INV_TYPE_O' THEN
                  v_V_OTHR_PI_TYPE_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'OPEN_CLAIM_STATUS' THEN
                  v_V_OPENCLAIM_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'CLOSED_CLAIM_STATUS' THEN
                  v_V_CLOSEDCLAIM_CODE_ID := v_V_CODE_ID_R;
                ELSIF v_VCOLNAME1 = 'EVENT_STATUS' THEN
                  v_V_EVENT_STATUS_CODE_ID := v_V_CODE_ID_R;
               ---akumar523 starts 62604
			  -- ELSIF v_VCOLNAME1 = 'EVENT_TYPE' THEN
              --    v_V_EVENT_TYPE_CODE_ID := v_V_CODE_ID_R;---akumar523 ends 	62604			  
                ELSIF v_VCOLNAME1 = 'DIS_TYPE' THEN
                  v_V_DIS_TYPE_ID := v_V_CODE_ID_R;
                ELSIF v_vColName1 = 'BENEFICIARY_CODE' THEN
                  --JIRA 24634 knakra starts
                  v_iBenCodeId := v_V_CODE_ID_R;
                ELSIF v_vColName1 = 'CLAIM_CAUSE_CODE' THEN
                  v_iCauseCodeId := v_V_CODE_ID_R; --JIRA 24634 knakra ends
                ELSIF v_vColName1 = 'CURR_CODE' THEN
                  v_V_CURR_CODE_ID := v_V_CODE_ID_R; --JIRA 29954 knakra ends
        	ELSIF v_vColName1 = 'REVIEW_STATUS_CODE' THEN  -----AKUMAR523 STARTS jira 61584
          	v_V_REVIEW_STATUS_CODE_ID := v_V_CODE_ID_R;  ------AKUMAR523  ENDS jira 61584
                END IF;

                --ELSE IF @VCOLNAME1 = 'EVENT_IND' SET @V_EVENT_IND_CODE_ID = @V_CODE_ID_R
                v_V_CODE_ID_R := NULL;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            ----***************** SHORT CODE FIELDS VALIDATION ENDS *******************************************
            --***************** RESERVE BUCKET MAPPING VALIDATIONS STARTS *****************************
            v_V_ERRORLOC := 'V003';
            --SET @V_CARRIERFLAG = 0 ---- remember to remove this line
            --v_Valid_Start_Date := '10000101'; ---- remember to remove this line
            --v_Valid_End_Date := '25000101'; ---- remember to remove this line
            IF v_V_CARRIERFLAG = 0 AND v_iVarFinKey = 0 THEN
              -- VFK condition by Kgupta31 for JIRA#23899
              v_V_BUCKETLIST         := '';
              v_V_UDRM_BUCKET_MAPPED := 'Y';
              v_V_BUCKETFIELDS       := 'RESERVE_A_DATE|RESERVE_B_DATE|RESERVE_C_DATE|RESERVE_D_DATE|RESERVE_E_DATE|';

              WHILE INSTR(v_V_BUCKETFIELDS, '|', 1) > 0 --CHECK FOR DIFFERENT BUCKETS IN IMPORT FILE
               LOOP
                BEGIN
                  v_iPos1                   := INSTR(v_V_BUCKETFIELDS,
                                                     '|',
                                                     1);
                  v_V_VAL                   := SUBSTR(v_V_BUCKETFIELDS,
                                                      1,
                                                      INSTR(v_V_BUCKETFIELDS,
                                                            '|',
                                                            1) - 1);
                  v_V_BUCKETFIELDS          := SUBSTR(v_V_BUCKETFIELDS,
                                                      LENGTH(SUBSTR(v_V_BUCKETFIELDS,
                                                                    1,
                                                                    INSTR(v_V_BUCKETFIELDS,
                                                                          '|',
                                                                          1))) + 1,
                                                      LENGTH(v_V_BUCKETFIELDS));
                  v_V_UDRM_RSV_TYPE_CODE_ID := 0;
                  v_V_BUCKET                := SUBSTR(v_V_VAL, 9, 1); ------ A OR B OR C OR D OR E
                  v_vColName1               := v_V_VAL;

                  v_V_VAL := (CASE WHEN v_V_VAL = 'RESERVE_A_DATE' THEN v_V_RESERVE_A_DATE WHEN v_V_VAL = 'RESERVE_B_DATE' THEN v_V_RESERVE_B_DATE WHEN v_V_VAL = 'RESERVE_C_DATE' THEN v_V_RESERVE_C_DATE WHEN v_V_VAL = 'RESERVE_D_DATE' THEN v_V_RESERVE_D_DATE WHEN v_V_VAL = 'RESERVE_E_DATE' THEN v_V_RESERVE_E_DATE END);

                  v_V_SQL := 'SELECT RSV_TYPE_CODE FROM DDS_USR_DEF_RSV_MAP WHERE BUCKET = :1
 AND LOB_CODE = :2 AND CONFIG_ID = :3 AND USERID = :4'; ----AND BUCKET_MAPPED = @V_UDRM_BUCKET_MAPPED_P'

                  BEGIN
                    EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_UDRM_RSV_TYPE_CODE_ID
                      USING v_V_BUCKET, v_V_CLAIM_LOB, v_CONFIG_ID, v_P_USER_ID;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_V_UDRM_RSV_TYPE_CODE_ID := 0;
                  END;

                  --PRINT 'USER DEFINED RESERVE MAP VALUE A: ' + CAST (@V_UDRM_RSV_TYPE_CODE_ID AS VARCHAR(10))
                  IF v_V_UDRM_RSV_TYPE_CODE_ID > 0 THEN
                    IF (v_V_VAL IS NULL) THEN
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_V_DA_ROW_ID,
                                            v_V_MODULENAME,
                                            v_V_ERRORLOC,
                                            v_V_ERRORLOC,
                                            v_V_PROCNAME,
                                            'Required Fields are Null or Empty.',
                                            v_vColName1,
                                            v_V_ERROR_TABLE,
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            1);

                      v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    ELSE
                      IF v_V_VAL = 'IGNORE' THEN
                        v_V_VAL := v_V_VAL;
                      ELSE
                        IF (DDS_IS_number(v_V_VAL) = 0 OR
                           DDS_IS_DATE(v_V_VAL) = 0) THEN
                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_V_DA_ROW_ID,
                                                v_V_MODULENAME,
                                                v_V_ERRORLOC,
                                                v_V_ERRORLOC,
                                                v_V_PROCNAME,
                                                'Date Provided is Not a Valid Date.',
                                                v_vColName1,
                                                v_V_ERROR_TABLE,
                                                'CLAIM_NUMBER',
                                                v_V_CLAIM_NUMBER,
                                                1);

                          v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                          --PRINT 'ERROR: Not a Valid Date'
                        ELSE
                          IF (v_V_VAL < v_Valid_Start_Date) OR
                             (v_V_VAL > v_Valid_End_Date) THEN
                            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                  v_V_DA_ROW_ID,
                                                  v_V_MODULENAME,
                                                  v_V_ERRORLOC,
                                                  v_V_ERRORLOC,
                                                  v_V_PROCNAME,
                                                  'Date provided is out of Valid Date Range.',
                                                  v_vColName1,
                                                  v_V_ERROR_TABLE,
                                                  'CLAIM_NUMBER',
                                                  v_V_CLAIM_NUMBER,
                                                  1);
                            v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                            --PRINT 'ERROR: Date provided is out of Valid Date Range'
                          ELSE
                            IF (v_V_BUCKET = 'A') THEN
                              v_V_UDRM_RSV_TYPE_A_CODE_ID := v_V_UDRM_RSV_TYPE_CODE_ID;
                              v_V_BUCKETLIST              := 'A' ||
                                                             v_V_BUCKETLIST;
                            ELSE
                              IF (v_V_BUCKET = 'B') THEN
                                v_V_UDRM_RSV_TYPE_B_CODE_ID := v_V_UDRM_RSV_TYPE_CODE_ID;
                                v_V_BUCKETLIST              := 'B' ||
                                                               v_V_BUCKETLIST;
                              ELSE
                                IF (v_V_BUCKET = 'C') THEN
                                  v_V_UDRM_RSV_TYPE_C_CODE_ID := v_V_UDRM_RSV_TYPE_CODE_ID;
                                  v_V_BUCKETLIST              := 'C' ||
                                                                 v_V_BUCKETLIST;
                                ELSE
                                  IF (v_V_BUCKET = 'D') THEN
                                    v_V_UDRM_RSV_TYPE_D_CODE_ID := v_V_UDRM_RSV_TYPE_CODE_ID;
                                    v_V_BUCKETLIST              := 'D' ||
                                                                   v_V_BUCKETLIST;
                                  ELSE
                                    IF (v_V_BUCKET = 'E') THEN
                                      v_V_UDRM_RSV_TYPE_E_CODE_ID := v_V_UDRM_RSV_TYPE_CODE_ID;
                                      v_V_BUCKETLIST              := 'E' ||
                                                                     v_V_BUCKETLIST;
                                    END IF;
                                  END IF;
                                END IF;
                              END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  END IF;

                END;
              END LOOP;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            ----***************** RESERVE BUCKET MAPPING VALIDATIONS ENDS ************************************

            IF v_V_POLICY_NUMBER IS NOT NULL AND
               (v_V_POLICY_EFFECT_DATE IS NULL OR
               v_V_POLICY_EXPIRE_DATE IS NULL) AND v_iVarFinKey = 0 -- VFK Condition added by KGupta31 for JIRA#23899
             THEN
              --- POLICY FIELDS VALIDATIONS *******
              BEGIN
                v_V_ERRORLOC := 'V003A';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Data in Policy realted fields is not provided in the import file. Policy search cannot be performed without all required values.',
                                      'POLICY_NUMBER,POLICY_EFFECT_DATE,POLICY_EXPIRE_DATE',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END;
            END IF;
            ----***************** STATE CODE FIELDS VALIDATION STARTS *********************************
            v_V_ERRORLOC  := 'V004';
            v_vReqColumns := 'ACCIDENT_STATE|CLAIMANT_STATE|DEF_STATE|';
            WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
             LOOP
              v_V_STATE_ID  := 0;
              v_iPos1       := INSTR(v_vReqColumns, '|', 1);
              v_vColName1   := SUBSTR(v_vReqColumns,
                                      1,
                                      INSTR(v_vReqColumns, '|', 1) - 1);
              v_vReqColumns := SUBSTR(v_vReqColumns,
                                      LENGTH(SUBSTR(v_vReqColumns,
                                                    1,
                                                    INSTR(v_vReqColumns,
                                                          '|',
                                                          1))) + 1,
                                      LENGTH(v_vReqColumns));

              v_V_VAL := (CASE WHEN v_vColName1 = 'ACCIDENT_STATE' THEN v_V_ACCIDENT_STATE WHEN v_vColName1 = 'CLAIMANT_STATE' THEN v_V_CLAIMANT_STATE WHEN v_vColName1 = 'DEF_STATE' THEN v_V_DEF_STATE END);

              --PRINT 'STATE CODE FIELDS VALIDATION 1'
              IF v_V_VAL IS NOT NULL THEN
                v_V_SQL := 'SELECT STATE_ROW_ID FROM ' || v_V_DBNAME ||
                           'STATES' || ' WHERE STATE_ID = :1';

                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_STATE_ID
                    USING v_V_VAL;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_STATE_ID := 0;
                END;

                IF v_VCOLNAME1 = 'ACCIDENT_STATE' THEN
                  v_V_ACCIDENT_STATE_ID := v_V_STATE_ID;
                ELSE
                  IF v_VCOLNAME1 = 'CLAIMANT_STATE' THEN
                    v_V_CLAIMANT_STATE_ID := v_V_STATE_ID;
                  ELSE
                    IF v_VCOLNAME1 = 'DEF_STATE' THEN
                      v_V_DEF_STATE_ID := v_V_STATE_ID;
                    END IF;
                  END IF;
                END IF;

                --PRINT @V_VAL;
                --PRINT @V_STATE_ID;
                --PRINT @V_DEF_STATE_ID;
                IF v_V_STATE_ID = 0 OR v_V_STATE_ID IS NULL THEN
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'State provided does not exists.',
                                        v_vColName1,
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);

                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            ----***************** STATE CODE FIELDS VALIDATION ENDS ******************************************
            ----***************** FLAG INITIALIZATION STARTS ******************************************
            v_V_ERRORLOC  := 'V005';
            v_vReqColumns := 'ACTIVE_FLAG|ELIG_DIS_BEN_FLAG|DISPUTED_CASE_FLAG|OSHA_RECORDABLE|ACCIDENT_PREVENTABLE|';
            WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
             LOOP
              v_iPos1       := INSTR(v_vReqColumns, '|', 1);
              v_vColName1   := SUBSTR(v_vReqColumns,
                                      1,
                                      INSTR(v_vReqColumns, '|', 1) - 1);
              v_vReqColumns := SUBSTR(v_vReqColumns,
                                      LENGTH(SUBSTR(v_vReqColumns,
                                                    1,
                                                    INSTR(v_vReqColumns,
                                                          '|',
                                                          1))) + 1,
                                      LENGTH(v_vReqColumns));
              v_V_FLAG_ID   := 0;
              v_V_VAL       := (CASE WHEN v_vColName1 = 'ACTIVE_FLAG' THEN v_V_ACTIVE_FLAG WHEN v_vColName1 = 'ELIG_DIS_BEN_FLAG' THEN v_V_ELIG_DIS_BEN_FLAG WHEN v_vColName1 = 'DISPUTED_CASE_FLAG' THEN v_V_DISPUTED_CASE_FLAG WHEN v_vColName1 = 'OSHA_RECORDABLE' THEN v_V_OSHA_RECORDABLE WHEN v_vColName1 = 'ACCIDENT_PREVENTABLE' THEN v_V_ACCIDENT_PREVENTABLE END);

              IF v_V_VAL IS NOT NULL THEN
                IF UPPER(v_V_VAL) = 'Y' THEN
                  v_V_FLAG_ID := -1;
                ELSE
                  IF UPPER(v_V_VAL) = 'N' OR UPPER(v_V_VAL) = '0' THEN
                    ---BE DEFAULT FLAG WILL BE 0
                    v_V_FLAG_ID := 0;
                  ELSE
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Not a Valid Flag Value. Permitted Values are ''Y'' or ''N'' or ''0''.',
                                          v_vColName1,
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                END IF;
              END IF;

              IF v_VCOLNAME1 = 'ACTIVE_FLAG' THEN
                v_V_ACTIVE_FLAG_ID := v_V_FLAG_ID;
              ELSE
                IF v_VCOLNAME1 = 'ELIG_DIS_BEN_FLAG' THEN
                  v_V_ELIG_DIS_BEN_FLAG_ID := v_V_FLAG_ID;
                ELSE
                  IF v_VCOLNAME1 = 'DISPUTED_CASE_FLAG' THEN
                    v_V_DISPUTED_CASE_FLAG_ID := v_V_FLAG_ID;
                  ELSE
                    IF v_VCOLNAME1 = 'OSHA_RECORDABLE' THEN
                      v_V_OSHA_RECORDABLE_ID := v_V_FLAG_ID;
                    ELSE
                      IF v_VCOLNAME1 = 'ACCIDENT_PREVENTABLE' THEN
                        v_V_ACC_PREV_FLAG_ID := v_V_FLAG_ID;
                      END IF;
                    END IF;
                  END IF;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            --***************** FLAG INITIALIZATION ENDS *****************************************************
            -- **************** DATE VALIDATION STARTS **********************************************
            v_V_ERRORLOC := 'V006';
            -----REMOVE BELOW TWO LINES WHEN TO END TESTING STARTS
            v_vReqColumns := 'DATE_OF_LOSS|DATE_REPORTED|DATE_OF_CLAIM|DATE_CLOSED|DATE_REOPENED|CLAIMANT_BIRTH_DT|DATE_OF_BIRTH|DATE_OF_HIRE|DATE_OF_DEATH|';
            v_vReqColumns := v_vReqColumns ||
                             'DEPENDENT_BIRTH_DT|LICENSE_EXPIR_DATE|RETURN_WORK_DATE|DATE_LAST_WORKED|DISABIL_FROM_DATE|DISABIL_TO_DATE|BENEFITS_START|';
            v_vReqColumns := v_vReqColumns ||
                             'BENEFITS_THROUGH|BEN_CALC_PAY_START|BEN_CALC_PAY_TO|DATE_FIRST_RESTRCT|DATE_LAST_RESTRCT|';
            v_vReqColumns := v_vReqColumns ||
                             'INFO_REQ_DATE|PROOF_OF_LOSS_DATE|DEF_BIRTH_DT|'; --JIRA 24634 knakra
            WHILE INSTR(v_vReqColumns, '|', 1) > 0 --NOTE:CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
             LOOP
              BEGIN
                v_iPos1       := INSTR(v_vReqColumns, '|', 1);
                v_vColName1   := SUBSTR(v_vReqColumns,
                                        1,
                                        INSTR(v_vReqColumns, '|', 1) - 1);
                v_vReqColumns := SUBSTR(v_vReqColumns,
                                        LENGTH(SUBSTR(v_vReqColumns,
                                                      1,
                                                      INSTR(v_vReqColumns,
                                                            '|',
                                                            1))) + 1,
                                        LENGTH(v_vReqColumns));
                v_V_VAL       := (CASE WHEN v_vColName1 = 'DATE_OF_LOSS' THEN v_V_DATE_OF_LOSS WHEN v_vColName1 = 'DATE_REPORTED' THEN v_V_DATE_REPORTED WHEN v_vColName1 = 'DATE_OF_CLAIM' THEN v_V_DATE_OF_CLAIM WHEN v_vColName1 = 'DATE_CLOSED' THEN v_V_DATE_CLOSED_DT WHEN v_vColName1 = 'DATE_REOPENED' THEN v_V_DATE_REOPENED WHEN v_vColName1 = 'CLAIMANT_BIRTH_DT' THEN v_V_CLAIMANT_BIRTH_DT WHEN v_vColName1 = 'DATE_OF_BIRTH' THEN v_V_DATE_OF_BIRTH WHEN v_vColName1 = 'DATE_OF_HIRE' THEN v_V_DATE_OF_HIRE WHEN v_vColName1 = 'DATE_OF_DEATH' THEN v_V_DATE_OF_DEATH WHEN v_vColName1 = 'DEPENDENT_BIRTH_DT' THEN v_V_DEPENDENT_BIRTH_DT WHEN v_vColName1 = 'LICENSE_EXPIR_DATE' THEN v_V_LICENSE_EXPIR_DATE WHEN v_vColName1 = 'RETURN_WORK_DATE' THEN v_V_RETURN_WORK_DATE WHEN v_vColName1 = 'DATE_LAST_WORKED' THEN v_V_DATE_LAST_WORKED WHEN v_vColName1 = 'DISABIL_FROM_DATE' THEN v_V_DISABIL_FROM_DATE WHEN v_vColName1 = 'DISABIL_TO_DATE' THEN v_V_DISABIL_TO_DATE WHEN v_vColName1 = 'BENEFITS_START' THEN v_V_BENEFITS_START WHEN v_vColName1 = 'BENEFITS_THROUGH' THEN v_V_BENEFITS_THROUGH WHEN v_vColName1 = 'BEN_CALC_PAY_START' THEN v_V_BEN_CALC_PAY_START WHEN v_vColName1 = 'BEN_CALC_PAY_TO' THEN v_V_BEN_CALC_PAY_TO WHEN v_vColName1 = 'DATE_FIRST_RESTRCT' THEN v_V_DATE_FIRST_RESTRICT WHEN v_vColName1 = 'DATE_LAST_RESTRCT' THEN v_V_DATE_LAST_RESTRICT END);

                IF v_V_VAL IS NOT NULL THEN
                  IF (DDS_IS_NUMBER(v_V_VAL) = 0 OR
                     DDS_is_date(v_V_VAL) = 0) THEN
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Date Provided is Not a Valid Date ',
                                          v_vColName1,
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    --PRINT 'ERROR: Not a Valid Date'
                  ELSE
                    IF (v_V_VAL < v_Valid_Start_Date) OR
                       (v_V_VAL > v_Valid_End_Date) THEN
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_V_DA_ROW_ID,
                                            v_V_MODULENAME,
                                            v_V_ERRORLOC,
                                            v_V_ERRORLOC,
                                            v_V_PROCNAME,
                                            'Date provided is out of Valid Date Range ',
                                            v_vColName1,
                                            v_V_ERROR_TABLE,
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            1);

                      v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    ELSE
                      IF (v_vColName1 = 'DATE_CLOSED') THEN
                        v_VCLOSETIME := SUBSTR(v_V_DATE_CLOSED, 9, 6);

                        IF LENGTH(v_VCLOSETIME) > 0 THEN
                          IF DDS_IS_NUMBER(v_VCLOSETIME) = 0 OR
                             SUBSTR(v_VCLOSETIME, 1, 2) > 24 OR
                             SUBSTR(v_VCLOSETIME, 3, 2) > 60 OR
                             SUBSTR(v_VCLOSETIME, 5, 2) > 60 THEN
                            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                  v_V_DA_ROW_ID,
                                                  v_V_MODULENAME,
                                                  v_V_ERRORLOC,
                                                  v_V_ERRORLOC,
                                                  v_V_PROCNAME,
                                                  'Date provided is out of Valid Date Range. ',
                                                  v_vColName1,
                                                  v_V_ERROR_TABLE,
                                                  'CLAIM_NUMBER',
                                                  v_V_CLAIM_NUMBER,
                                                  1);

                            v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                          END IF;
                        ELSE
                          v_VCLOSETIME    := '120000';
                          v_V_DATE_CLOSED := v_V_DATE_CLOSED + v_VCLOSETIME;
                        END IF;
                      END IF;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END; ----**************** DATE VALIDATION ENDS *****************************************************

          --JIRA 42212 knakra starts
          IF v_V_BENEFITS_START IS NOT NULL AND v_V_BENEFITS_THROUGH IS NOT NULL AND v_V_BENEFITS_THROUGH < v_V_BENEFITS_START THEN
             v_V_ERRORLOC := 'ErrBenStrtThrough';
             v_V_ERROR_MESSAGE := 'Benefit Start Date: ' || v_V_BENEFITS_START || ' cannot be greater than Benefit Through Date: ' || v_V_BENEFITS_THROUGH || '.';
             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      v_V_ERROR_MESSAGE,
                                      'BENEFITS_START, BENEFITS_THROUGH',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END IF;

          IF v_V_DISABIL_FROM_DATE IS NOT NULL AND v_V_DISABIL_TO_DATE IS NOT NULL AND v_V_DISABIL_TO_DATE < v_V_DISABIL_FROM_DATE THEN
             v_V_ERRORLOC := 'ErrDisDatesComp';
             v_V_ERROR_MESSAGE := 'Disability From Date: ' || v_V_DISABIL_FROM_DATE || ' cannot be greater than Disability To Date: ' || v_V_DISABIL_TO_DATE || '.';
             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      v_V_ERROR_MESSAGE,
                                      'DISABIL_FROM_DATE, DISABIL_TO_DATE',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END IF;

          IF v_V_BEN_CALC_PAY_START IS NOT NULL AND v_V_BEN_CALC_PAY_TO IS NOT NULL AND v_V_BEN_CALC_PAY_TO < v_V_BEN_CALC_PAY_START THEN
             v_V_ERRORLOC := 'ErrBenCalDatesComp';
             v_V_ERROR_MESSAGE := 'Benefit Calculate Start Date: ' || v_V_BEN_CALC_PAY_START || ' cannot be greater than Benefit Calculate To Date: ' || v_V_BEN_CALC_PAY_TO || '.';
             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      v_V_ERROR_MESSAGE,
                                      'BEN_CALC_PAY_START, BEN_CALC_PAY_TO',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END IF;
          --JIRA 42212 knakra ends

          BEGIN
            ----**************** TIME VALIDATION STARTS *****************************************************
            IF v_V_TIME_OF_CLAIM IS NOT NULL THEN
              v_V_ERRORLOC := 'V006A';
              ----PRINT 'CHECK TIME IS TIME OR NOT'
              IF DDS_IS_NUMBER(v_V_TIME_OF_CLAIM) = 0 OR
                 SUBSTR(v_V_TIME_OF_CLAIM, 1, 2) > 24 OR
                 SUBSTR(v_V_TIME_OF_CLAIM, 3, 2) > 60 OR
                 SUBSTR(v_V_TIME_OF_CLAIM, 5, 2) > 60 THEN
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Date provided is out of Valid Date Range.',
                                      'TIME_OF_CLAIM',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END; ----**************** TIME VALIDATION ENDS *****************************************************

          BEGIN
            -- OTHER VALIDATIONS STARTS ***************************************************************
            v_V_ERRORLOC := 'V007';

            IF (v_V_CLAIMANT_SSN IS NOT NULL) AND
               (DDS_is_numBER(REPLACE(v_V_CLAIMANT_SSN, '-', '')) = 0 OR
               LENGTH(REPLACE(v_V_CLAIMANT_SSN, '-', '')) <> 9) THEN
              v_V_ERRORLOC := 'L007';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Invalid Tax-ID. Check Format.',
                                    'CLAIMANT_SSN',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);

              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            --PRINT 'Invalid Tax-ID. Check Format'
            IF (v_V_CLAIMANT_ZIP IS NOT NULL) AND
              --- (DDS_IS_NUMBER(REPLACE(v_V_CLAIMANT_ZIP, '-', '')) = 0 OR
              LENGTH(REPLACE(REPLACE(v_V_CLAIMANT_ZIP, '-', ''), ' ', '')) NOT IN (9, 5,6)  THEN
              v_V_ERRORLOC := 'L007A';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Invalid ZIP CODE. Check Format.',
                                    'CLAIMANT_ZIP',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);
              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            --PRINT 'Invalid ZIP CODE. Check Format'
            IF (v_V_DEF_ZIP IS NOT NULL) AND
               --- (DDS_IS_NUMBER(REPLACE(v_V_CLAIMANT_ZIP, '-', '')) = 0 OR
              LENGTH(REPLACE(REPLACE(v_V_DEF_ZIP, '-', ''), ' ', '')) NOT IN (9, 5,6)  THEN
              v_V_ERRORLOC := 'L007B';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Invalid ZIP CODE. Check Format.',
                                    'DEF_ZIP',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);

              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            --PRINT 'Invalid ZIP CODE. Check Format'
            IF (v_EmployeeMatchByTaxId = 1 OR v_NonEmployeeMatchByTaxId = 1) AND
               (v_V_CLAIMANT_SSN IS NULL) THEN
              v_V_ERRORLOC := 'L008';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Match by Tax-ID is selected as search criteria but Tax_ID is not provided.',
                                    'CLAIMANT_SSN',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);
              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            --PRINT 'Match by Tax-ID is selected as search criteria but Tax_ID is not provided'
            IF (v_V_EMPLOYEE_ID IS NOT NULL) AND (v_V_CLAIMANT_SSN IS NULL) AND
               ((v_V_RECORD_TYPE = 'G') OR (v_V_RECORD_TYPE = 'V') OR
               v_V_RECORD_TYPE = 'H') THEN
              --JIRA 24634 knakra
              v_V_ERRORLOC := 'L009';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'If Employee_ID is populated then Claimant_SSN must be populated.',
                                    'CLAIMANT_SSN',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);
              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            --PRINT 'ERROR 620: If Employee_ID is populated then Emp_Department must be populated'
            IF (v_V_ILLNESS_CODE IS NOT NULL) AND
               (v_V_INJURY_CODE_1 IS NOT NULL OR
               v_V_INJURY_CODE_2 IS NOT NULL OR
               v_V_INJURY_CODE_3 IS NOT NULL OR
               v_V_INJURY_CODE_4 IS NOT NULL OR
               v_V_INJURY_CODE_5 IS NOT NULL) THEN
              v_V_ERRORLOC := 'L011';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Illness Code and Injury Code both contain values. Only one of them may.',
                                    'ILLNESS_CODE\nINJURY_CODE',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);
              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              --PRINT 'Illness Code and Injury Code both contain values. Only one of them may'
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
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            -- **************** OTHER VALIDATIONS ENDS ******************************************************
            -- **************** DEPARTMENT VALIDATION STARTS ****************************************
            v_V_ERRORLOC  := 'V008';
            v_vReqColumns := 'DEPARTMENT|EMP_DEPARTMENT|';
            WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
             LOOP
              --- WHILE LOOP BEGIN
              v_V_DEPT_ID   := 0;
              v_iPos1       := INSTR(v_vReqColumns, '|', 1);
              v_vColName1   := SUBSTR(v_vReqColumns,
                                      1,
                                      INSTR(v_vReqColumns, '|', 1) - 1);
              v_vReqColumns := SUBSTR(v_vReqColumns,
                                      LENGTH(SUBSTR(v_vReqColumns,
                                                    1,
                                                    INSTR(v_vReqColumns,
                                                          '|',
                                                          1))) + 1,
                                      LENGTH(v_vReqColumns));
              v_V_VAL       := (CASE WHEN v_vColName1 = 'DEPARTMENT' THEN v_V_DEPARTMENT WHEN v_vColName1 = 'EMP_DEPARTMENT' THEN v_V_EMP_DEPARTMENT END);

              --PRINT 'DEPARTMENT VALIDATION :'
              IF v_V_VAL IS NOT NULL THEN
                v_V_SYS_TABLE_NAME := 'DEPARTMENT';
                v_V_DELETED_FLAG   := 0;
                v_V_SQL            := 'SELECT E.ENTITY_ID, E.ENTITY_TABLE_ID, E.ABBREVIATION,E.DELETED_FLAG ';
                v_V_SQL            := v_V_SQL || 'FROM ' || v_V_DBNAME ||
                                      'ENTITY E, ' || v_V_DBNAME ||
                                      'GLOSSARY G ' ||
                                      ' WHERE E.ENTITY_TABLE_ID = G.TABLE_ID
 AND G.SYSTEM_TABLE_NAME = :1 AND E.ABBREVIATION = :2';

                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_DEPT_ID, v_V_ENTITY_TABLE_ID, v_V_ABBREVIATION, v_V_DELETED_FLAG
                    USING v_V_SYS_TABLE_NAME, v_V_VAL;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    NULL;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);

                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;

                IF v_VCOLNAME1 = 'DEPARTMENT' THEN
                  v_V_DEPARTMENT_ID     := v_V_DEPT_ID;
                  v_V_DELETED_FLAG_DEPT := v_V_DELETED_FLAG;
                ELSE
                  IF v_VCOLNAME1 = 'EMP_DEPARTMENT' THEN
                    v_V_EMP_DEPT_ID           := v_V_DEPT_ID;
                    v_V_DELETED_FLAG_EMP_DEPT := v_V_DELETED_FLAG;
                  END IF;
                END IF;

                IF (v_V_DEPT_ID = 0 OR v_V_DELETED_FLAG = -1) THEN
                  IF (v_CheckCreateNewDepartment = 0) THEN
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Department does not exists and its creation is not allowed.',
                                          v_vColName1,
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);
                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                END IF;
              END IF;
            END LOOP;
          EXCEPTION
            WHEN OTHERS THEN
              --PRINT 'DEPARTMENT DOES NOT EXISTS AND ITS CREATION IS NOT ALLOWED';
              -- WHILE LOOP ENDS
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
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            -- **************** DEPARTMENT VALIDATION ENDS *************************************************
            ---**************** COMMON VALIDATIONS *************************************************************************************************************************
            ---**************** CHECK IF AN EXISTING CLAIM OR A NEW CLAIM **********************************************************************************
            IF v_V_CLAIM_NUMBER IS NOT NULL THEN
              v_V_ERRORLOC := 'V009';

              --JIRA 29954 knakra starts
            IF v_fVersionNum < 19.1 THEN  ----AKUMAR523 jira 61584
            	IF v_fVersionNum < 16.4 THEN
                	   v_V_SQL := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE, EVENT_ID, EVENT_NUMBER, TIME_OF_CLAIM, CLAIM_STATUS_CODE FROM ' ||
                           v_V_DBNAME || 'CLAIM' ||
                           ' WHERE CLAIM_NUMBER = :1';

              	ELSE
                	IF v_fVersionNum >= 16.4 THEN
                  --v_V_SQL := 'SELECT @V_CLAIM_ID_P = CLAIM_ID, @V_CLAIM_LOB_RMDB_P = LINE_OF_BUS_CODE , @V_EVENT_ID_P = EVENT_ID, @V_EVENT_NUMBER_P = EVENT_NUMBER, @V_TIME_OF_CLAIM_P = TIME_OF_CLAIM, @V_OLDSTATUS_ID_P = CLAIM_STATUS_CODE , @pClmCurrCode = CLM_CURR_CODE FROM ' || v_V_DBNAME || 'CLAIM' || ' WHERE CLAIM_NUMBER = @V_CLAIM_NUMBER_P';
                  	v_V_SQL := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE, EVENT_ID, EVENT_NUMBER, TIME_OF_CLAIM, CLAIM_STATUS_CODE, CLAIM_CURR_CODE FROM ' ||
                             v_V_DBNAME || 'CLAIM' ||
                             ' WHERE CLAIM_NUMBER = :1';
               		END IF;
				END IF;
		
			ELSE      ----AKUMAR523 jira 61584
         	v_V_SQL := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE, EVENT_ID, EVENT_NUMBER, TIME_OF_CLAIM, CLAIM_STATUS_CODE, CLAIM_CURR_CODE, REVIEW_STATUS_CODE FROM ' ||
                v_V_DBNAME || 'CLAIM' ||
                 ' WHERE CLAIM_NUMBER = :1';
            END IF ;       
       
            BEGIN
			IF v_fVersionNum < 19.1 THEN    ---AKUMAR523 STARST jira 61584
                IF v_fVersionNum < 16.4 THEN

                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_CLAIM_ID, v_V_CLAIM_LOB_RMDB, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_TIME_OF_CLAIM_RMDB, v_V_OLDSTATUS_ID
                    USING v_V_CLAIM_NUMBER;
                ELSE
                  IF v_fVersionNum >= 16.4 THEN
                    EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_CLAIM_ID, v_V_CLAIM_LOB_RMDB, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_TIME_OF_CLAIM_RMDB, v_V_OLDSTATUS_ID, v_iOldClmCurrCode
                      USING v_V_CLAIM_NUMBER;

                  END IF;
                END IF;
                --JIRA 29954 knakra ends
			ELSE      ----AKUMAR523 jira 61584
				EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_CLAIM_ID, v_V_CLAIM_LOB_RMDB, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_TIME_OF_CLAIM_RMDB, v_V_OLDSTATUS_ID, v_iOldClmCurrCode,v_ioldRevTypCode
                      USING v_V_CLAIM_NUMBER;
			END IF;    
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  NULL;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

              END;
              IF v_V_CLAIM_ID > 0 THEN
                --PRINT 'EXISTING CLAIM';
                IF v_V_CLAIM_LOB_RMDB <> v_V_CLAIM_LOB THEN
                  v_V_ERRORLOC := 'L76A';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Line of business of this Existing Claim in RiskMaster and Import file are different.',
                                        'RECORD_TYPE',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                ELSE
                  v_V_NEWCLAIM := 0;
                  v_V_ERRORLOC := 'L76B';
                  v_V_SQL      := 'SELECT DATE_STATUS_CHGD FROM (SELECT DATE_STATUS_CHGD FROM ' ||
                                  v_V_DBNAME ||
                                  'CLAIM_STATUS_HIST WHERE CLAIM_ID = :1 ORDER BY DATE_STATUS_CHGD DESC) WHERE ROWNUM = 1';
                  BEGIN
                    EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_DATE_STATUS_CHGD
                      USING v_V_CLAIM_ID;

                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_V_DATE_STATUS_CHGD := '00000000';
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
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            0);

                      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                  END;

                  --JIRA 29954 knakra starts
                  IF v_fVersionNum >= 16.4 AND
                     v_iOldClmCurrCode <> v_V_CURR_CODE_ID AND
                     v_V_CURR_CODE_ID IS NOT NULL AND v_V_CURR_CODE_ID > 0 THEN
                    v_V_ERRORLOC := 'CURR_UPD';

                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Claim Currency can not be updated and different currency provided in the import file than the existing claim currency. ',
                                          'CURR_CODE',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  ---udoni RMA-75601 starts
		  ELSIF v_fVersionNum >= 20.2 and v_V_OLDSTATUS_ID != v_V_CLAIM_STATUS_ID THEN
					v_V_SQL := 'SELECT COUNT(IS_LOCKED) FROM ' ||v_V_DBNAME || 'RESERVE_CURRENT WHERE CLAIM_ID = :1 AND ((IS_LOCKED = -1) OR (IS_LOCKED = 1))';
                  BEGIN
                    EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_Count_islocked_reserve
                      USING v_V_CLAIM_ID;
					END;
					IF v_V_Count_islocked_reserve > 0 THEN
						v_V_ERRORLOC := 'RL1';
                    				DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        	v_V_DA_ROW_ID,
                                        	v_V_MODULENAME,
                                        	v_V_ERRORLOC,
                                        	v_V_ERRORLOC,
                                        	v_V_PROCNAME,
                                        	'Reserve is locked on following claim, claim status cannot be updated.',
                                        	'CLAIM_NUMBER',
                                        	v_V_ERROR_TABLE,
                                        	'CLAIM_NUMBER',
                                        	v_V_CLAIM_NUMBER,
                                        	1);
                    				v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
		    				GOTO FETCHNEXT;
					END IF;
					---udoni RMA-75601 ends
				  END IF;
                  --JIRA 29954 knakra ends
                END IF;
              ELSE
                IF v_CheckCreateNewClaim = 0 THEN
                  --CLAIM DOES NOT EXIST IN RISKMASTER DATABASE AND ALSO IS NOT ALLOWED TO BE CREATED BY THE USER AS THE OPTION IS NOT CHECKED
                  v_V_ERRORLOC := 'L76';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Claim Number does not exists. Check "Allow Creation of New Claim " to create New Claim.',
                                        'CLAIM_NUMBER',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                ELSE
                  --PRINT 'CREATE NEW CLAIM';
                  v_V_NEWCLAIM := 1;
                END IF;
              END IF;

              -- strt Add statement here
              IF v_V_NEWCLAIM = 0 AND v_iVarFinKey <> 0 AND
                 v_V_CLAIM_ID IS NOT NULL AND v_V_CLAIM_ID > 0 THEN
                v_V_SQL := 'SELECT POLICY_LOB_CODE, CLAIM_TYPE_CODE FROM ' ||
                           v_V_DBNAME || 'CLAIM WHERE CLAIM_ID = :1';

                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_iExtPolLobCode, v_iExtClmTypeCode
                  USING v_V_CLAIM_ID;

                v_V_SQL := 'SELECT ROW_ID, INC_CLAIMANT, INC_RSVTYPE, INC_RSVSUBTYPE, ';
                v_v_SQL := v_v_SQL ||
                           'INC_POL_COVERAGE, INC_LOSS_TYPE FROM ' ||
                           v_V_DBNAME || 'FINANCIAL_KEY WHERE';
                v_V_SQL := v_v_SQL || ' LOB_CODE = :1';

                IF v_iFinKeyFilter <> 0 THEN
                  v_V_SQL := v_v_SQL || ' AND POLICY_LOB = :2';
                ELSE
                  v_V_SQL := v_v_SQL || ' AND CLAIM_TYPE = :2';
                END IF;

                BEGIN
                  v_iRowId     := NULL;
                  v_V_ERRORLOC := 'ErrFinKeyExt';

                  BEGIN
                    IF v_iFinKeyFilter <> 0 THEN
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_iRowId, v_iExtIncClaimant, v_iExtIncRsvType, v_iExtIncRsvSubType, v_iExtIncPolCvgUnit, v_iExtIncLossType
                        USING v_V_CLAIM_LOB, v_iExtPolLobCode;
                    ELSE
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_iRowId, v_iExtIncClaimant, v_iExtIncRsvType, v_iExtIncRsvSubType, v_iExtIncPolCvgUnit, v_iExtIncLossType
                        USING v_V_CLAIM_LOB, v_iExtClmTypeCode;
                    END IF;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN

                      v_V_ERRORLOC := 'ErrFinKeyDefExt';
                      BEGIN
                        EXECUTE IMMEDIATE V_V_SQL
                          INTO v_iRowId, v_iExtIncClaimant, v_iExtIncRsvType, v_iExtIncRsvSubType, v_iExtIncPolCvgUnit, v_iExtIncLossType
                          USING v_V_CLAIM_LOB, -1;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN

                          v_V_ERROR_MESSAGE := 'Claim Number: ' ||
                                               v_V_CLAIM_NUMBER ||
                                               ', No Default or user defined key found.';
                          IF v_iFinKeyFilter <> 0 THEN
                            v_vErrorColumns := 'POLICY_LOB';
                          ELSE
                            v_vErrorColumns := 'CLAIM_TYPE';
                          END IF;

                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_V_DA_ROW_ID,
                                                v_V_MODULENAME,
                                                'NoFinKeyExt',
                                                'NoFinKeyExt',
                                                v_V_PROCNAME,
                                                v_V_ERROR_MESSAGE,
                                                v_vErrorColumns,
                                                v_V_ERROR_TABLE,
                                                'CLAIM_NUMBER',
                                                v_V_CLAIM_NUMBER,
                                                1);

                          v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                          v_iFinKeyErr   := 1;

                      END;
                  END;

                  v_iRowId     := NULL;
                  v_V_ERRORLOC := 'ErrFinKeyCur';
                  BEGIN
                    IF v_iFinKeyFilter <> 0 THEN
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_iRowId, v_iIncClaimant, v_iIncRsvType, v_iIncRsvSubType, v_iIncPolCvgUnit, v_iIncLossType
                        USING v_V_CLAIM_LOB, v_V_POLICY_LOB_ID;
                    ELSE
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_iRowId, v_iIncClaimant, v_iIncRsvType, v_iIncRsvSubType, v_iIncPolCvgUnit, v_iIncLossType
                        USING v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID;
                    END IF;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN

                      v_V_ERRORLOC := 'ErrFinKeyDefCur';

                      BEGIN
                        EXECUTE IMMEDIATE V_V_SQL
                          INTO v_iRowId, v_iIncClaimant, v_iIncRsvType, v_iIncRsvSubType, v_iIncPolCvgUnit, v_iIncLossType
                          USING v_V_CLAIM_LOB, -1;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN

                          v_V_ERROR_MESSAGE := 'Claim Number: ' ||
                                               v_V_CLAIM_NUMBER ||
                                               ', No Default or user defined key found. ';

                          IF v_iFinKeyFilter <> 0 THEN
                            v_vErrorColumns := 'POLICY_LOB';
                          ELSE
                            v_vErrorColumns := 'CLAIM_TYPE';
                          END IF;

                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                v_V_DA_ROW_ID,
                                                v_V_MODULENAME,
                                                'NoFinKeyCur',
                                                'NoFinKeyCur',
                                                v_V_PROCNAME,
                                                v_V_ERROR_MESSAGE,
                                                v_vErrorColumns,
                                                v_V_ERROR_TABLE,
                                                'CLAIM_NUMBER',
                                                v_V_CLAIM_NUMBER,
                                                1);

                          v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;

                          v_iFinKeyErr := 1;
                      END;
                  END;

                  IF v_iFinKeyErr IS NULL OR v_iFinKeyErr = 0 THEN
                    IF v_iExtIncClaimant <> v_iIncClaimant OR
                       v_iExtIncLossType <> v_iIncLossType OR
                       v_iExtIncPolCvgUnit <> v_iIncPolCvgUnit OR
                       v_iExtIncRsvSubType <> v_iIncRsvSubType OR
                       v_iExtIncRsvType <> v_iIncRsvType THEN
                      v_V_ERROR_MESSAGE := 'Existing and Current Financial Key is different for Claim: ' ||
                                           v_V_CLAIM_NUMBER ||
                                           ', Claim not updated. ';

                      IF v_iFinKeyFilter <> 0 THEN
                        v_vErrorColumns := 'POLICY_LOB';

                      ELSE
                        v_vErrorColumns := 'CLAIM_TYPE';

                      END IF;

                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_V_DA_ROW_ID,
                                            v_V_MODULENAME,
                                            'FinKeyNotMatch',
                                            'FinKeyNotMatch',
                                            v_V_PROCNAME,
                                            v_V_ERROR_MESSAGE,
                                            v_vErrorColumns,
                                            v_V_ERROR_TABLE,
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            1);

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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    --JIRA 23899 knakra ends
                END;
              END IF;

              -- End Statement here

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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            -----************** CHECK IF CLAIM STATUS PARENT IS CLOSED OR OPEN *****************************************************************************
            v_V_ERRORLOC := 'V010';

            v_V_SQL := 'SELECT CODES1.SHORT_CODE FROM ' || v_V_DBNAME ||
                       'CODES' || ' CODES1, ' || v_V_DBNAME || 'CODES ' ||
                       ' CODES2 WHERE CODES2.CODE_ID = :1 AND CODES1.CODE_ID = CODES2.RELATED_CODE_ID';
            BEGIN
              EXECUTE IMMEDIATE V_V_SQL
                INTO v_V_TEMPSHORTCODE
                USING v_V_CLAIM_STATUS_ID;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
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
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      0);

                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

            END;

            IF v_V_TEMPSHORTCODE = 'C' THEN
              v_V_BCLOSEDCLAIM := 1;
              v_V_OPEN_FLAG_ID := 0;
            ELSE
              IF v_V_TEMPSHORTCODE = 'O' THEN
                v_V_BOPENCLAIM   := 1;
                v_V_OPEN_FLAG_ID := -1;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);
              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;
          -- kAPIL DONE TILL 28-JAN-2016
          BEGIN
            -------************************* EVENTS EXISTS IN RISKMASTER OR NOT ************************************************************************
            IF v_V_CLAIM_NUMBER IS NOT NULL THEN
              v_V_ERRORLOC := 'V011';
              v_V_SQL      := 'SELECT EVENT_ID, DATE_OF_EVENT, DEPT_EID, TIME_OF_EVENT FROM ';
              v_V_SQL      := v_V_SQL || v_V_DBNAME || 'EVENT' ||
                              ' WHERE EVENT_NUMBER = :1';

              BEGIN
                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_EVENT_ID, v_V_DATE_OF_EVENT, v_V_DEPT_EID, v_V_TIME_OF_EVENT
                  USING v_V_EVENT_NUMBER;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_EVENT_ID := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

              END;

              --PRINT 'EVENT ID: ' + CAST(@V_EVENT_ID AS VARCHAR(10));
              IF v_V_EVENT_ID > 0 THEN
                --PRINT 'EXISTING EVENT WITH EVENT NUMBER: ' + CAST(@V_EVENT_ID AS VARCHAR(10))
                v_V_NEWEVENT := 0;
              ELSE
                IF v_V_EVENT_ID = 0 THEN
                  --PRINT 'NEW EVENT WITH EVENT ID: ' + CAST(@V_EVENT_ID AS VARCHAR(10))
                  v_V_NEWEVENT := 1;
                END IF;
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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            -------************************** DATE VALIDATIONS STARTS ************************************************************************************
            IF v_V_CLAIM_NUMBER IS NOT NULL THEN
              v_V_ERRORLOC := 'V012';
              IF v_V_DATE_REOPENED IS NOT NULL AND
                 v_V_DATE_CLOSED IS NOT NULL THEN
                ---BEGIN LEVEL 1
                IF (DDS_IS_DATE(v_V_DATE_REOPENED)) = 1 AND
                   (v_V_BOPENCLAIM = 1) THEN
                  --BEGIN LEVEL 3
                  IF (DDS_IS_DATE(v_V_DATE_OF_CLAIM) = 0) AND
                     (v_V_NEWCLAIM = 1) THEN
                    v_V_ERRORLOC := 'V013';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'If DATE_REOPENED is populated, then both date of claim and date closed are required.',
                                          'DATE_OF_CLAIM \n DATE_CLOSED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;

                  --PRINT 'ERROR 147: If DATE_REOPENED is populated, then both DATE OF CLAIM and DATE CLOSED are required';
                  IF DDS_IS_DATE(v_V_DATE_CLOSED_DT) = 1 AND
                     v_V_DATE_REOPENED < v_V_DATE_CLOSED_DT THEN
                    v_V_ERRORLOC := 'V014';
                    --PRINT @V_DATE_REOPENED;
                    --PRINT @V_DATE_CLOSED_DT;
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'DATE_REOPENED Less than DATE_CLOSED.',
                                          'DATE_REOPENED \n DATE_CLOSED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;

                  --PRINT 'ERROR 148: DATE_REOPENED Less Than DATE_CLOSED';

                  IF (v_V_NEWCLAIM = 0) AND
                     ((v_V_DATE_REOPENED < v_V_DATE_STATUS_CHGD) AND         --ddhupar JIRA 79203
                     (V_V_OLDSTATUS_ID <> v_V_CLAIM_STATUS_ID)) THEN

                    v_V_ERRORLOC := 'V014A';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Date Reopened is Less than Date status changed.',
                                          'DATE_REOPENED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    --PRINT 'ERROR 148: DATE_REOPENED Less Date status changed';
                  END IF;

                  IF DDS_IS_DATE(v_V_DATE_CLOSED_DT) = 1 AND
                     DDS_IS_DATE(v_V_DATE_OF_CLAIM) = 1 AND
                     (v_V_DATE_CLOSED_DT < v_V_DATE_OF_CLAIM) THEN
                    v_V_ERRORLOC := 'V015';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Date Claim closed is Less than Claim Date.',
                                          'DATE_CLOSED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                  --PRINT 'ERROR 144: Date Claim was Closed is Less Than Claim Date '
                  --END LEVEL 3
                ELSE
                  IF (DDS_IS_DATE(v_V_DATE_REOPENED) = 1) AND
                     (v_V_BCLOSEDCLAIM = 1) AND (v_V_NEWCLAIM = 1) THEN
                    v_V_ERRORLOC := 'V016';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'If DATE_REOPENED is populated, CLAIM_STATUS must be O or R (or status with a parent code of O), and cannot be Closed (or status code with parent code C).',
                                          'CLAIM_STATUS',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);
                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                    --PRINT 'ERROR: 149: If DATE_REOPENED is populated, CLAIM_STATUS must be O or R (or status with a parent code of O), and cannot be Closed (or status code with parent code C)';
                  ELSE
                    IF (v_V_NEWCLAIM = 0) AND (v_V_BCLOSEDCLAIM = 1) AND
                       (DDS_IS_DATE(v_V_DATE_CLOSED_DT) = 1 AND
                       DDS_IS_DATE(v_V_DATE_OF_CLAIM) = 1) AND
                       (v_V_DATE_CLOSED_DT < v_V_DATE_OF_CLAIM) THEN

                      v_V_ERRORLOC := 'V016A';
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_V_DA_ROW_ID,
                                            v_V_MODULENAME,
                                            v_V_ERRORLOC,
                                            v_V_ERRORLOC,
                                            v_V_PROCNAME,
                                            'Date on which claim was closed is Less than Date of Claim.',
                                            'DATE_CLOSED',
                                            v_V_ERROR_TABLE,
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            1);
                      v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                      --PRINT 'ERROR: 144: Date on which claim was closed is Less than Date of Claim.';
                    END IF;
                  END IF;
                END IF;
              END IF;
              ---END LEVEL 1

              IF (v_V_EVENT_ID = 0) THEN
                ---- NOTE: WHAT IF THE VALUES COMPARED BELOW ARE NULL
                v_V_DATE_OF_EVENT := v_V_DATE_OF_LOSS;

                IF v_V_TIME_OF_EVENT IS NULL THEN
                  v_V_TIME_OF_EVENT := '000000';
                END IF;
              END IF;

              IF DDS_IS_DATE(v_V_DATE_OF_CLAIM) = 1 AND
                 DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1 AND
                 v_V_DATE_OF_CLAIM < v_V_DATE_OF_EVENT THEN

                IF (v_V_DATE_OF_CLAIM < v_V_DATE_OF_EVENT) THEN
                  v_V_ERRORLOC := 'V017';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Claim Date Less Than Event Date DATE_OF_CLAIM < DATE_OF_EVENT.',
                                        'DATE_OF_CLAIM',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);

                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  --PRINT 'ERROR 145: Claim Date Less Than Event Date DATE_OF_CLAIM < DATE_OF_EVENT'
                END IF;
                --PRINT 'ERROR 151: Same claim and event/loss date, claim time cannot be earlier than event time';
              ELSE
                IF (DDS_IS_DATE(v_V_DATE_OF_CLAIM) = 1 AND
                   DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1) AND
                   (v_V_DATE_OF_CLAIM = v_V_DATE_OF_EVENT) THEN
                  IF (v_V_TIME_OF_CLAIM < v_V_TIME_OF_EVENT) AND
                     (v_V_TIME_OF_CLAIM IS NOT NULL) THEN
                    v_V_ERRORLOC := 'V019';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Same claim and event/loss date, claim time cannot be earlier than event time.',
                                          'TIME_OF_CLAIM',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                  --PRINT 'ERROR 151: Same claim and event/loss date, claim time cannot be earlier than event time'
                ELSE
                  IF (DDS_IS_DATE(v_V_DATE_REPORTED) = 1 AND
                     DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1) AND
                     (v_V_DATE_REPORTED < v_V_DATE_OF_EVENT) THEN
                    v_V_ERRORLOC := 'V020';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Date Reported Less Than Event Date.',
                                          'DATE_REPORTED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);
                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                END IF;
              END IF;

              --PRINT 'ERROR 146: Date Reported Less Than Event Date';
              IF (DDS_IS_DATE(v_V_DATE_OF_BIRTH) = 1 AND
                 DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1) AND
                 (v_V_DATE_OF_BIRTH > v_V_DATE_OF_EVENT) THEN
                v_V_ERRORLOC := 'V021';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Date of Birth is greater than Event Date.',
                                      'DATE_OF_BIRTH',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;

              IF (DDS_IS_DATE(v_V_DATE_OF_DEATH) = 1 AND
                 DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1) AND
                 (v_V_DATE_OF_DEATH < v_V_DATE_OF_EVENT) THEN
                v_V_ERRORLOC := 'V022';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Date of Death is less than Event Date.',
                                      'DATE_OF_DEATH',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);

                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;

              IF (DDS_IS_DATE(v_V_DATE_CLOSED_DT) = 1 AND
                 DDS_IS_DATE(v_V_DATE_OF_EVENT) = 1) AND
                 (v_V_DATE_CLOSED_DT < v_V_DATE_OF_EVENT) THEN
                v_V_ERRORLOC := 'V023';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'Date closed is less than Event Date.',
                                      'DATE_CLOSED',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;

              --JIRA 24634 knakra starts
              IF (DDS_IS_DATE(v_vInfoDateReq)) = 1 AND
                 (DDS_IS_DATE(v_V_DATE_OF_CLAIM)) = 1 AND
                 (v_V_DATE_OF_CLAIM > v_vInfoDateReq OR
                 v_vInfoDateReq > v_vTodayDate) THEN
                v_V_ERRORLOC := 'InfoReqDate';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'INFO_REQ_DATE should be greater than DATE_OF_CLAIM and less than Current Date.',
                                      'INFO_REQ_DATE',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;

              IF (DDS_IS_DATE(v_vProofLossDate)) = 1 AND
                 (DDS_IS_DATE(v_V_DATE_OF_CLAIM)) = 1 AND
                 (v_V_DATE_OF_CLAIM > v_vProofLossDate OR
                 v_vProofLossDate > v_vTodayDate) THEN
                v_V_ERRORLOC := 'ProofOfLossDate';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      'PROOF_OF_LOSS_DATE should be greater than DATE_OF_CLAIM and less than Current Date.',
                                      'PROOF_OF_LOSS_DATE',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;
              --JIRA 24634 knakra ends

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
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    0);
              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          BEGIN
            ----****************************** DATE VALIDATIONS ENDS ****************************************************************************
            IF v_V_CLAIM_NUMBER IS NOT NULL THEN
              IF v_V_RECORD_TYPE = 'W' THEN
                ---BEGIN LEVEL 1

                IF (DDS_IS_DATE(v_V_DATE_LAST_WORKED) = 1 AND
                   DDS_IS_DATE(v_V_RETURN_WORK_DATE) = 1) THEN
                  IF (v_V_DATE_LAST_WORKED > v_V_RETURN_WORK_DATE) THEN
                    v_V_ERRORLOC      := 'V024';
                    v_V_ERROR_MESSAGE := 'Last Worked Date is greater then the Returned Date.';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          v_V_ERROR_MESSAGE,
                                          'DATE_LAST_WORKED',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);
                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                END IF;

                --PRINT 'ERROR: Last Worked Date is greater then the Returned Date';
                IF (DDS_IS_DATE(v_V_DATE_FIRST_RESTRICT) = 1 AND
                   DDS_IS_DATE(v_V_DATE_LAST_RESTRICT) = 1) THEN
                  IF (v_V_DATE_LAST_RESTRICT < v_V_DATE_FIRST_RESTRICT) THEN
                    v_V_ERRORLOC := 'V025';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          'Restricted First Date is greater then Restricted Last Date.',
                                          'DATE_FIRST_RESTRICT\nDATE_LAST_RESTRICT',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);
                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;
                END IF;
              END IF;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              --PRINT 'ERROR: Restricted First Date is greater then Restricted Last Date';
              ---END LEVEL 1
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
                                    v_V_CLAIM_NUMBER,
                                    0);

              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          IF v_V_CLAIM_SUPP = 1 THEN
            -- BEGIN SUPPLEMENTAL FIELDS VALIDATION

            BEGIN
              v_V_ERRORLOC := 'V025A';
              DDS_SUPPLEMENT(v_P_JOBID,
                             v_CONFIG_ID,
                             v_P_USER_ID,
                             v_V_MODULENAME,
                             v_V_DBNAME,
                             v_V_DA_ROW_ID,
                             v_CheckCreateNewCodes,
                             v_V_CLAIM_LOB,
                             v_V_ERRORCOUNT, -- TO CHECK THERE IS ANY ERROR IN BASE RECORD (INPUT PARAMETER TO CHECK BASE ERROR)
                             'V', -- VALIDATION OR INSERT (V OR I)
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
                             0,
                             0,
                             'CLAIM_NUMBER', -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
                             v_V_CLAIM_NUMBER, -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
                             v_V_SUPP_ERROR_COUNT); --(OUT PARAMETER TO INTIMATE BASE THAT THERE IS AND ERROR IN SUPP)

              v_V_ERRORCOUNT := v_V_ERRORCOUNT + v_V_SUPP_ERROR_COUNT;
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
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      0);
                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
            END;
          END IF;
          -- END SUPPLEMENTAL FIELDS VALIDATION

          ----------************************** ALL VALIDATION ENDS ************************************************************************************
          v_V_ERRORLOC := 'V026';
          --PRINT 'ERROR COUNT : ' + CAST(@V_ERRORCOUNT AS VARCHAR(3))
          IF v_V_ERRORCOUNT + v_V_ROWCOUNT > 0 THEN
            v_V_INVALID_ROW := 1;
          ELSE
            IF (v_V_ERRORCOUNT + v_V_ROWCOUNT = 0) THEN
              v_V_INVALID_ROW := 0;
            END IF;
          END IF;

          --------**************************** INSERT/UPDATE PREPRATION *******************************************************************************
          IF v_V_INVALID_ROW = 0 THEN
            ---- NO VALIDATION ERRORS ARE THERE
            ---- BEGIN INVALID ROW 0
            v_V_ROWCOUNT := 0;
            --PRINT 'IMPORT STARTS FOR RECORD NUMBER: ' + CAST(@V_DA_ROW_ID AS VARCHAR(10))
            IF v_V_RPT_DATE_AUTO_FLAG = 2 THEN
              v_V_DATE_RPTD_TO_RM := TO_CHAR(SYSDATE, 'YYYYMMDD');
            ELSE
              v_V_DATE_RPTD_TO_RM := v_V_DATE_OF_CLAIM;
            END IF;

            --IF v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0 THEN -- COMMENTED KGUPTA31 FOR VFK JIRA#23899
            IF (V_V_RECORD_TYPE = 'D' AND V_V_CARRIERFLAG = 0 AND
               V_iVarFinKey = 0) OR
               (V_iVarFinKey <> 0 AND V_V_RECORD_TYPE = 'D') THEN
              -- ADDED KGUPTA31 FOR VFK JIRA#23899
              --BEGIN LEVEL 4

              --JIRA 42212 knakra starts
              --v_V_SQL := 'SELECT PLAN_ID FROM ' || v_V_DBNAME ||
              --           'DISABILITY_PLAN WHERE PLAN_NAME = :1';

        v_V_SQL := 'SELECT FAC.ENTITY_ID, LOC.ENTITY_ID, DIV.ENTITY_ID, REG.ENTITY_ID, OPR.ENTITY_ID, COM.ENTITY_ID, CLNT.ENTITY_ID FROM ' || 
        v_V_DBNAME || 'ENTITY DEPT INNER JOIN ' || v_V_DBNAME || 'ENTITY FAC ON FAC.ENTITY_ID = DEPT.PARENT_EID INNER JOIN ' || v_V_DBNAME || 
        'ENTITY LOC ON LOC.ENTITY_ID = FAC.PARENT_EID INNER JOIN ' || v_V_DBNAME || 'ENTITY DIV ON DIV.ENTITY_ID = LOC.PARENT_EID' || 
        ' INNER JOIN ' || v_V_DBNAME || 'ENTITY REG ON REG.ENTITY_ID = DIV.PARENT_EID INNER JOIN ' || v_V_DBNAME || 'ENTITY OPR ON' || 
        ' OPR.ENTITY_ID = REG.PARENT_EID INNER JOIN ' || v_V_DBNAME || 'ENTITY COM ON COM.ENTITY_ID = OPR.PARENT_EID' || 
        ' INNER JOIN ' || v_V_DBNAME || 'ENTITY CLNT ON CLNT.ENTITY_ID = COM.PARENT_EID WHERE ' || 
        'DEPT.ENTITY_ID = :1'; 
              BEGIN
                v_V_ERRORLOC := 'ErrOrgList';

                EXECUTE IMMEDIATE v_V_SQL INTO iFacEid, iLocEid, iDivEid, iRegEid, iOprEid, iComEid, iClntEid
                USING v_V_DEPARTMENT_ID;

                v_V_SQL := 'SELECT DP.PLAN_ID FROM ' || v_V_DBNAME || 'DISABILITY_PLAN DP INNER JOIN ' || v_V_DBNAME || 'CODES C ON';
                v_V_SQL := v_V_SQL || ' C.CODE_ID = DP.PLAN_STATUS_CODE INNER JOIN ' || v_V_DBNAME || 'GLOSSARY G ON G.TABLE_ID = C.TABLE_ID';

                v_VSQLINSERT := ' INNER JOIN ' || v_V_DBNAME || 'DIS_PLAN_X_INSURED DPI ON DPI.PLAN_ID = DP.PLAN_ID';

                v_VSQLUPDATE := ' WHERE G.SYSTEM_TABLE_NAME = ''PLAN_STATUS'' AND C.SHORT_CODE = ''I'' AND ((DP.EFFECTIVE_DATE <= :1 AND DP.EXPIRATION_DATE >= :2)';
                v_VSQLUPDATE := v_VSQLUPDATE || ' OR (DP.EFFECTIVE_DATE <= :3 AND DP.EXPIRATION_DATE >= :4)) AND DP.PLAN_NAME = :5';

                nSqlExec := v_V_SQL || v_VSQLINSERT || v_VSQLUPDATE || ' AND DPI.INSURED_EID IN(:6, :7, :8, :9, :10, :11, :12, :13)';

                v_V_ERRORLOC := 'ErrPlanWithDept';
                BEGIN
                IF v_fVersionNum < 17.3 OR (v_fVersionNum >= 17.3 AND v_iIncPolCvgUnit = 0) THEN
                  EXECUTE IMMEDIATE nSqlExec INTO v_V_PLAN_ID
                  USING v_V_DATE_OF_EVENT, v_V_DATE_OF_EVENT, v_V_DATE_OF_CLAIM, v_V_DATE_OF_CLAIM, v_V_PLAN_NAME, iFacEid, iLocEid, iDivEid, iRegEid, iOprEid, iComEid, iClntEid, v_V_DEPARTMENT_ID;
                ELSE
                  nSqlExec := v_V_SQL || v_VSQLUPDATE;
                  EXECUTE IMMEDIATE nSqlExec INTO v_V_PLAN_ID
                  USING v_V_DATE_OF_EVENT, v_V_DATE_OF_EVENT, v_V_DATE_OF_CLAIM, v_V_DATE_OF_CLAIM, v_V_PLAN_NAME;
                END IF;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  v_V_PLAN_ID := 0;
                END;
                IF v_V_PLAN_ID IS NULL OR v_V_PLAN_ID = 0 THEN
                   IF v_fVersionNum < 17.3 OR (v_fVersionNum >= 17.3 AND v_iIncPolCvgUnit = 0) THEN
                      nSqlExec := v_V_SQL || v_VSQLUPDATE;
                      BEGIN
                         EXECUTE IMMEDIATE nSqlExec
                         INTO v_V_PLAN_ID
                         USING v_V_DATE_OF_EVENT, v_V_DATE_OF_EVENT, v_V_DATE_OF_CLAIM, v_V_DATE_OF_CLAIM, v_V_PLAN_NAME;
                      EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         v_V_PLAN_ID := 0;
                      END;
                   END IF;

                   IF v_V_PLAN_ID IS NOT NULL AND v_V_PLAN_ID > 0 THEN
                      v_V_ERRORLOC := 'ErrPlanNotFound';
                      v_V_ERROR_MESSAGE := 'Plan: ' || v_V_PLAN_NAME || ', is not associated with the Department: ' || v_V_DEPARTMENT;
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        v_V_ERROR_MESSAGE,
                                        'PLAN_NAME',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                   ELSE
                     v_V_ERRORLOC := 'ErrPlanNotFound';
                     v_V_ERROR_MESSAGE := 'Plan: ' || v_V_PLAN_NAME || ' doesnot exist in the database.';
                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          v_V_ERROR_MESSAGE,
                                          'PLAN_NAME',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                           1);
                     v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                   END IF;
                END IF;
                /*v_V_ERRORLOC := 'V027';
                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_PLAN_ID
                  USING v_V_PLAN_NAME;*/
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
              IF v_V_PLAN_ID > 0 THEN
                v_V_INSERTPLANINFO := 1;
              END IF;

              IF v_V_CLASS_NAME IS NOT NULL AND v_V_PLAN_ID > 0 THEN

                v_V_SQL := 'SELECT CLASS_ROW_ID FROM ' || v_V_DBNAME ||
                           'DISABILITY_CLASS WHERE CLASS_NAME = :1 AND PLAN_ID = :2';

                BEGIN
                  v_V_ERRORLOC    := 'V028';
                  v_V_CLASSROW_ID := NULL;

                  EXECUTE IMMEDIATE v_V_SQL
                    INTO v_V_CLASSROW_ID
                    USING v_V_CLASS_NAME, v_V_PLAN_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLASSROW_ID := NULL;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
              END IF;

              IF v_V_DIS_TYPE_ID > 0 THEN
                v_V_TAXFLAGS := 0;

                IF v_V_FEDERAL_TAX_FLAG = 'Y' THEN
                  v_V_TAXFLAGS := v_V_TAXFLAGS + 1;
                END IF;

                IF v_V_SOCIAL_SEC_TAX_FLAG = 'Y' THEN
                  v_V_TAXFLAGS := v_V_TAXFLAGS + 2;
                END IF;

                IF v_V_MEDICARE_TAX_FLAG = 'Y' THEN
                  v_V_TAXFLAGS := v_V_TAXFLAGS + 4;
                END IF;

                IF v_V_STATE_TAX_FLAG = 'Y' THEN
                  v_V_TAXFLAGS := v_V_TAXFLAGS + 8;
                END IF;
              END IF;
            END IF;

            --END LEVEL 4
            -----************************************ WORK SPECIFIC FOR NEW AND OLD CLAIM *********************************************************************
            ---- ************************************** NEW CLAIM *********************************************************************************************
            IF v_V_NEWCLAIM = 1 AND v_CheckCreateNewClaim = 1 THEN
              ---- NEW CLAIM
              ----BEGIN LEVEL NEW CLAIM
              ----PRINT 'IMPORTING NEW CLAIM: '
              v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' || v_V_DBNAME ||
                              'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

              BEGIN
                v_V_ERRORLOC := 'V029';
                EXECUTE IMMEDIATE v_VSQLINSERT
                  INTO v_V_CLAIM_ID
                  USING 'CLAIM';

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_CLAIM_ID := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              IF v_V_NEWEVENT = 1 THEN
                ----BEGIN LEVEL NEW EVENT

                --PRINT 'IMPORTING NEW EVENT: '
                ---- CREATE EVENT_NUMBER IF IT IS BLANK
               /* IF v_V_EVENT_NUMBER IS NULL THEN
                  IF LENGTH(v_V_CLAIM_NUMBER) > (v_V_EVENT_REF_LENGTH - 2) THEN
                    v_V_EVENT_NUMBER := 'EV' || v_V_CLAIM_ID;
                  ELSE
                    v_V_EVENT_NUMBER := 'EV' || v_V_CLAIM_NUMBER;
                  END IF;
                END IF;*/

                BEGIN
                  v_V_ERRORLOC := 'V031';
                  v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                  v_V_DBNAME ||
                                  'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                  EXECUTE IMMEDIATE v_VSQLINSERT
                    INTO v_V_EVENT_ID
                    USING 'EVENT';
                    
                    --JIRA 42981 knakra starts
                    IF v_V_EVENT_NUMBER IS NULL THEN
                       IF iEvIncYear <> 0 AND iEvIncYear IS NOT NULL THEN
                          v_V_EVENT_NUMBER := to_char(sysdate, 'YYYY') || '0' || to_char(v_V_EVENT_ID);
                       END IF;
                       IF vEvPrefix IS NOT NULL THEN
                          IF v_V_EVENT_NUMBER IS NULL THEN
                             v_V_EVENT_NUMBER := vEvPrefix || '0' || to_char(v_V_EVENT_ID);
                          ELSE
                             v_V_EVENT_NUMBER := vEvPrefix || v_V_EVENT_NUMBER;
                          END IF;
                       END IF;
                       IF v_V_EVENT_NUMBER IS NULL THEN
                          v_V_EVENT_NUMBER := '0' || to_char(v_V_EVENT_ID);
                       END IF;
                    END IF;
                    --JIRA 42981 knakra ends
                    
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_EVENT_ID := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);

                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
              END IF;
            END IF;

            ----END LEVEL NEW EVENT
            ----END LEVEL NEW CLAIM
            ----********************************************* POLICY ********************************************************************************
            IF v_V_POLICY_NUMBER IS NOT NULL AND
               v_V_POLICY_EFFECT_DATE IS NOT NULL AND
               v_V_POLICY_EXPIRE_DATE IS NOT NULL AND v_V_CARRIERFLAG = 0 AND
               V_iVarFinKey = 0 THEN
              -- VFK CONDITION ADDED BY KGUPTA31 FOR JIRA#23899
              ----BEGIN FOR POLICY
              BEGIN
                v_V_ERRORLOC  := 'V032';
                v_V_POLICY_ID := 0;
                v_V_SQL       := 'SELECT POLICY_ID FROM ' || v_V_DBNAME ||
                                 'POLICY WHERE POLICY_NUMBER = :1 AND EFFECTIVE_DATE = :2 AND EXPIRATION_DATE = :3';
                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_V_POLICY_ID
                  USING v_V_POLICY_NUMBER, v_V_POLICY_EFFECT_DATE, v_V_POLICY_EXPIRE_DATE;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_POLICY_ID := 0;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Policy Does not Exists.',
                                        'POLICY_NUMBER, POLICY_EFFECT_DATE, POLICY_EXPIRE_DATE ',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
              IF v_V_POLICY_ID = 0 AND v_V_CARRIERFLAG = 0 THEN
                v_V_NEW_POLICY := 1;
              END IF;
            END IF;

            ----END FOR POLICY
            IF v_V_POLICY_ID > 0 AND v_iVarFinKey = 0 THEN
              -- KGUPTA31 ADDED VFK CONDITION FOR JIRA#23899
              v_V_ERRORLOC := 'V032B';
              v_V_SQL      := 'SELECT POLICY_ID FROM ' || v_V_DBNAME ||
                              'CLAIM_X_POLICY WHERE POLICY_ID = :1 AND CLAIM_ID = :2';
              BEGIN
                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_V_POLICY_ID_RMDB
                  USING v_V_POLICY_ID, v_V_CLAIM_ID;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_POLICY_ID_RMDB   := 0;
                  v_V_NEW_CLAIMXPOLICY := 1;

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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              IF v_V_POLICY_ID_RMDB > 0 THEN
                v_V_NEW_CLAIMXPOLICY := 0;
              END IF;
            END IF;

            ---- *********************** EXISTING CLAIM ****************************************************************************
            IF v_V_NEWCLAIM = 0 THEN
              BEGIN
                ----BEGIN EXISTING CLAIM

                --PRINT 'UPDATING EXISTING CLAIM: '
                IF v_V_NEWEVENT = 0 THEN
                  ---- EXISTING EVENT
                  ----BEGIN EXISTING CLAIM EXISTING EVENT

                  IF (v_V_EVENT_ID > 0) THEN
                    --EVENT UPDATE CASE
                    ----PRINT @V_DATE_OF_CLAIM;
                    ----PRINT @V_DATE_OF_EVENT;
                    IF v_V_DATE_OF_CLAIM < v_V_DATE_OF_LOSS OR
                       v_V_DATE_OF_CLAIM = v_V_DATE_OF_EVENT OR
                       v_V_TIME_OF_CLAIM IS NOT NULL OR
                       v_V_TIME_OF_EVENT < v_V_TIME_OF_CLAIM THEN

                      --PRINT 'DATE OF EVENT WILL BE UPDATED AS DATE OF LOSS';
                      v_V_DATE_OF_EVENT := v_V_DATE_OF_LOSS;

                    END IF;
                  END IF;
                END IF;
              END;
            END IF;

            ----END EXISTING CLAIM EXISTING EVENT
            ----END EXISTING CLAIM
            ------------------------------------ PROCESS CLAIMANT-----------------------------------------------------------------------
            v_V_EMPLOYEE_NUMBER := v_V_EMPLOYEE_ID;

            IF v_V_EMPLOYEE_ID IS NULL THEN
              v_V_EMPLOYEE_NUMBER := v_V_CLAIMANT_SSN;
            END IF;

            IF v_V_RECORD_TYPE = 'W' OR v_V_RECORD_TYPE = 'D' THEN
              --PRINT 'Claimant is an EMPLOYEE'
              v_V_PARENT_TABLE_NAME := 'EVENT';
              v_V_PARENT_ROW_ID     := v_V_EVENT_ID;
              v_V_PI_TYPE_CODE_ID   := v_V_EMP_PI_TYPE_CODE_ID;
              v_V_SYS_TABLE_NAME    := 'EMPLOYEES';
            ELSE
              --IF v_V_RECORD_TYPE = 'G' OR v_V_RECORD_TYPE = 'V' THEN ----JIRA RMA-22720 ----
              IF (v_V_RECORD_TYPE = 'G' OR v_V_RECORD_TYPE = 'V' OR
                 v_V_RECORD_TYPE = 'H') AND
                 (v_V_ADDClaimantASPI <> 0 OR v_V_EMPLOYEE_ID IS NOT NULL) THEN
                ----JIRA RMA-22720 ----
                v_V_PARENT_TABLE_NAME := 'CLAIM';
                v_V_PARENT_ROW_ID     := v_V_CLAIM_ID;

                IF v_V_EMPLOYEE_ID IS NOT NULL THEN
                  --PRINT 'Claimant is an EMPLOYEE'
                  v_V_SYS_TABLE_NAME  := 'EMPLOYEES';
                  v_V_PI_TYPE_CODE_ID := v_V_EMP_PI_TYPE_CODE_ID;
                ELSE
                  IF v_V_EMPLOYEE_ID IS NULL THEN
                    --PRINT 'Claimant is an OTHER_PEOPLE'
                    v_V_SYS_TABLE_NAME  := 'CLAIMANTS';
                    v_V_PI_TYPE_CODE_ID := v_V_OTHR_PI_TYPE_CODE_ID;
                  ELSE
                    v_V_PARENT_TABLE_NAME := 'CLAIM';
                    v_V_SYS_TABLE_NAME    := 'CLAIMANTS';
                    v_V_PARENT_ROW_ID     := v_V_CLAIM_ID;
                  END IF;
                END IF;
              END IF;

            END IF;

            ------ CHECK IF CLAIMANT EXISTS OR NOT BASED ON CLAIMANT SELECTION CRITERIA ------------------------------------------------------------------------
            v_V_ERRORLOC     := 'V034';
            v_V_CLAIMANT_EID := 0;
            v_V_SQL          := 'SELECT CLAIMANT_EID FROM ' || v_V_DBNAME ||
                                'CLAIMANT CL, ' || v_V_DBNAME || 'CLAIM C ';

            IF v_V_RECORD_TYPE = 'W' OR v_V_RECORD_TYPE = 'D' THEN
              --FETCH CLAIMANT EID FOR THE GIVEN CLAIM BASED ON LOB AND OPTIONS SELECTED ON UI
              v_V_SQL := v_V_SQL ||
                         'WHERE C.CLAIM_ID = CL.CLAIM_ID AND C.CLAIM_ID = ' || '''' ||
                         v_V_CLAIM_ID || '''';
              IF v_V_CLAIM_SUFFIX IS NULL THEN
                 v_V_CLAIM_SUFFIX := 1;
              END IF;
            END IF;

            IF v_V_RECORD_TYPE = 'G' OR v_V_RECORD_TYPE = 'V' OR
               v_V_RECORD_TYPE = 'H' THEN
              IF v_IdentifyClaimantBySuffixGCVA <> 0 THEN
                IF v_V_CLAIM_SUFFIX IS NOT NULL THEN
                  v_V_SQL      := v_V_SQL ||
                                  ' WHERE C.CLAIM_ID = CL.CLAIM_ID AND CLAIMANT_NUMBER =' || '''' ||
                                  v_V_CLAIM_SUFFIX || '''' ||
                                  ' AND C.CLAIM_ID =' || '''' ||
                                  v_V_CLAIM_ID || '''';
                  v_V_ERRORLOC := 'V035';
                ELSE
                  v_V_ERRORLOC := 'ClaimSuffixNull';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Claimant Match By Suffix is selected but Claimant Suffix is not provided in the import file.',
                                        'CLAIM_SUFFIX',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                END IF;

                IF v_V_CLAIMANT_SSN IS NULL AND
                   v_CreateEntityIfTaxIDEmptyGCVA <> 0 THEN
                  v_ForceCreateEntity := 1;
                END IF;
              ELSE
                IF v_IdentifyClaimantByNameGCVA <> 0 THEN
                  v_V_SQL      := v_V_SQL || ', ' || v_V_DBNAME ||
                                  'ENTITY E WHERE C.CLAIM_ID = CL.CLAIM_ID AND CL.CLAIMANT_EID = E.ENTITY_ID AND E.LAST_NAME = ''' ||
                                  v_V_CLAIMANT_LASTNAME || '''';
                  v_V_ERRORLOC := 'V036';

                  IF v_V_CLAIMANT_FIRSTNAME IS NOT NULL THEN
                    v_V_SQL := v_V_SQL || ' AND E.FIRST_NAME = ''' ||
                               v_V_CLAIMANT_FIRSTNAME || '''';
                  END IF;

                  v_V_ERRORLOC := 'V037';

                  IF v_V_CLAIMANT_SSN IS NOT NULL THEN
                    v_V_SQL := v_V_SQL ||
                               ' AND REPLACE(E.TAX_ID,''-'','''') = ''' ||
                               REPLACE(v_V_CLAIMANT_SSN, '-', '') || '''';
                    v_V_SQL := v_V_SQL || ' AND C.CLAIM_ID =' || '''' ||
                               v_V_CLAIM_ID || '''';
                  END IF;

                  --JIRA 24634 knakra starts
                  IF v_V_CLAIMANT_BIRTH_DT IS NOT NULL AND
                     v_iHmiFlag IS NOT NULL AND v_iHmiFlag = 1 AND
                     (DDS_IS_DATE(v_V_CLAIMANT_BIRTH_DT)) = 1 THEN
                    v_V_SQL := v_V_SQL || ' AND E.BIRTH_DATE = ''' ||
                               v_V_CLAIMANT_BIRTH_DT || '''';
                  END IF;
                  --JIRA 24643 knakra ends
                  
                  IF v_V_CLAIM_SUFFIX IS NULL THEN
                     v_V_CLAIM_SUFFIX := 1;
                  END IF;

                END IF;
              END IF;
            END IF;

            --PRINT @V_SQL
            BEGIN
              EXECUTE IMMEDIATE V_V_SQL
              --INTO v_V_CLAIMANT_EID; ----JIRA RMA-23225
                INTO v_V_CLAIMANT_EID_RMDB;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_V_CLAIMANT_EID_RMDB := 0;
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
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      0);
                v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
            END;
            IF v_V_CLAIM_SUFFIX = 0 OR v_V_CLAIM_SUFFIX = 1 THEN
              v_V_CLAIM_SUFFIX       := 1;
              
              v_V_SQL := 'SELECT CLAIMANT_ROW_ID FROM ' || v_V_DBNAME || 'CLAIMANT WHERE CLAIM_ID = :1 AND PRIMARY_CLMNT_FLAG <> 0';
              
              BEGIN
              EXECUTE IMMEDIATE v_V_SQL INTO v_iRetVal USING v_V_CLAIM_ID;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   v_iRetVal := 0;
              END;
              IF v_iRetVal = 0 THEN
                 v_V_PRIMARY_CLMNT_FLAG := 1;
              ELSE
                 v_V_PRIMARY_CLMNT_FLAG := 0;
              END IF;
            END IF;
            --------------------------------------------------------------------------

            IF v_V_NEWCLAIM = 0 THEN

              IF v_V_CLAIMANT_EID_RMDB > 0 THEN

                v_V_CLAIM_SUFFIX_RMDB := v_V_CLAIM_SUFFIX;
                v_V_ERRORLOC          := 'NA1';

                v_V_SQL := 'SELECT CLAIMANT_NUMBER FROM ' || v_V_DBNAME ||
                           'CLAIMANT ' ||
                           'WHERE CLAIM_ID = :1 AND CLAIMANT_EID = :2';

                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_CLAIM_SUFFIX_RMDB
                    USING v_V_CLAIM_ID, v_V_CLAIMANT_EID_RMDB;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    NULL;
                END;
                IF v_V_CLAIM_SUFFIX <> v_V_CLAIM_SUFFIX_RMDB THEN
                  v_V_SUFFIXERROR := 1;
                END IF;

              ELSE

                v_V_ERRORLOC := 'NA2';
                v_V_SQL      := 'SELECT CLAIMANT_EID FROM ' || v_V_DBNAME ||
                                'CLAIMANT ' ||
                                'WHERE CLAIM_ID = :1 AND CLAIMANT_NUMBER = :2';

                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_CLAIMANT_EID_RMDB_1
                    USING v_V_CLAIM_ID, v_V_CLAIM_SUFFIX;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLAIMANT_EID_RMDB_1 := 0;
                END;
                IF v_V_CLAIMANT_EID_RMDB = 0 AND
                   v_V_CLAIMANT_EID_RMDB_1 > 0 THEN
                  v_V_SUFFIXERROR := 1;
                END IF;
              END IF;
            END IF;
            ----JIRA RMA-23225 ENDS

            ----------------- IF claimant found then update claimant details based on creteria selected -------------------------------------------------------
            --IF v_V_CLAIMANT_EID <> 0 THEN ----JIRA RMA-23225
            IF v_V_CLAIMANT_EID_RMDB <> 0 THEN
              ----JIRA RMA-23225

              -- CLAIMANT EXISTS BEGIN l
              v_V_DUPLICATECLAIMANT := 1;
              v_V_CLAIMANT_EID      := v_V_CLAIMANT_EID_RMDB; ----JIRA RMA-23225

              --IF (v_UpdateClaimantNameWC <> 0) OR ----JIRA RMA-23225
              --(v_UpdateClaimantNameGCVA <> 0) THEN ----JIRA RMA-23225
              IF (v_UpdateClaimantNameWC <> 0 AND v_V_RECORD_TYPE = 'W') OR
                 (v_UpdateClaimantNameGCVA <> 0 AND
                 v_V_RECORD_TYPE IN ('G', 'V', 'H')) THEN
                ----JIRA RMA-23225
                BEGIN
                  --PRINT 'UPDATE ENTITY NAME'
                  v_V_ERRORLOC := 'V038';
                  v_V_SQL      := 'SELECT LAST_NAME,FIRST_NAME,MIDDLE_NAME FROM ';
                  v_V_SQL      := v_V_SQL || v_V_DBNAME ||
                                  'ENTITY WHERE ENTITY_ID = :1';

                  --PRINT @V_SQL
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_LASTNAME_RMDB, v_V_FIRSTNAME_RMDB, v_V_MIDNAME_RMDB
                    USING v_V_CLAIMANT_EID;

                  IF UPPER(v_V_LASTNAME_RMDB) <>
                     UPPER(v_V_CLAIMANT_LASTNAME) OR
                     UPPER(v_V_FIRSTNAME_RMDB) <>
                     UPPER(v_V_CLAIMANT_FIRSTNAME) OR
                     UPPER(v_V_MIDNAME_RMDB) <>
                     UPPER(v_V_CLAIMANT_MIDDLENAME) THEN
                    --PRINT 'UPDATE ENTITY NAME IS TRUE'
                    v_V_UPDATE_ENTITYNAME := 1;
                  END IF;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_LASTNAME_RMDB  := NULL;
                    v_V_FIRSTNAME_RMDB := NULL;
                    v_V_MIDNAME_RMDB   := NULL;
                  WHEN OTHERS THEN
                    --ELSE --PRINT 'NEW CLAIMANT FIRST NAME, LAST NAME IS NOT UPDATED '
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
                                          v_V_CLAIM_NUMBER,
                                          0);

                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
              END IF;

              --PRINT 'UPDATE CLAIMANT ADDRESS'
              -- BELOW QUERY JUST TO MAKE SURE THE ENTITY TO BE UPDATED STILL EXISTS IN RMDB
              v_V_SQL := 'SELECT ENTITY_ID FROM ' || v_V_DBNAME || 'ENTITY' ||
                         ' WHERE ENTITY_ID = :1';

              BEGIN
                v_V_ERRORLOC := 'V039';
                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_V_ENTITY_ID
                  USING v_V_CLAIMANT_EID;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_ENTITY_ID := 0;
                WHEN OTHERS THEN
                  --PRINT 'ENTITY ID IS : ' + CAST(@V_ENTITY_ID AS VARCHAR(10))
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
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              IF v_V_ENTITY_ID <> 0 THEN
                --PRINT 'UPDATE CLAIMANT ADDRESS'
                v_V_UPDATE_CLAIMANT_ADDRESS := 1;
              END IF;
              ----- END CLAIMANT EXISTS
            ELSE
              IF v_V_CLAIMANT_EID_RMDB = 0 THEN
                ----JIRA RMA-23225
                ---- Create New Entity
                BEGIN
                  --PRINT 'PROCESS ENTITY HERE'
                  v_V_ERRORLOC := 'V040';

                  VENTITY_TYPE := DDS_ENTITY_TYPE(v_V_CLAIMANT_LASTNAME,
                                                  v_V_CLAIMANT_FIRSTNAME,
                                                  v_V_CLAIMANT_MIDDLENAME,
                                                  NULL,
                                                  v_V_CLAIMANT_SSN,
                                                  v_V_CLAIMANT_ADDRESS1,
                                                  v_V_CLAIMANT_ADDRESS2,
                                                  v_V_CLAIMANT_CITY,
                                                  NULL,
                                                  v_V_CLAIMANT_STATE_ID,
                                                  NULL,
                                                  v_V_CLAIMANT_ZIP,
                                                  NULL,
                                                  v_V_CLAIMANT_PHONE,
                                                  NULL,
                                                  v_V_CLAIMANT_BIRTH_DT,
                                                  v_V_CLAIMANT_SEX_ID,
                                                  v_V_CLAIMANT_COMMENT,
                                                  0,
                                                  v_V_SYS_TABLE_NAME,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  v_V_NAME_TYPE_ID,
                                                  v_V_EMPLOYEE_ID,
                                                  v_P_JOBID,
                                                  v_V_DA_ROW_ID);
                  --PRINT 'ENTITY IMPORT STARTS'

                  PROCESS_ENTITY(VENTITY_TYPE,
                                 v_P_JOBID,
                                 v_V_DA_ROW_ID,
                                 v_V_DBNAME,
                                 v_V_MODULENAME,
                                 v_ForceCreateEntity,
                                 1,
                                 v_V_ERRORLOC,
                                 v_V_CLAIM_NUMBER,
                                 1, --JIRA 24634 knakra
                                 v_V_CLAIMANT_EID,
                                 v_V_ERROR_MESSAGE);

                  IF v_V_ERROR_MESSAGE IS NOT NULL THEN
                    v_V_ERRORLOC := 'V040A';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          v_V_ERROR_MESSAGE,
                                          'CLAIMANT',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;

                  ----JIRA RMA-23225 STARTS
                  IF v_V_CLAIMANT_EID > 0 THEN
                    v_V_ERRORLOC := 'V040Y';
                    v_V_SQL      := 'SELECT CLAIMANT_NUMBER FROM ' ||
                                    v_V_DBNAME || 'CLAIMANT ' ||
                                    'WHERE CLAIM_ID = :1 AND CLAIMANT_EID = :2';

                    BEGIN
                      EXECUTE IMMEDIATE v_V_SQL
                        INTO v_V_CLAIM_SUFFIX_RMDB
                        USING v_V_CLAIM_ID, v_V_CLAIMANT_EID;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_CLAIM_SUFFIX_RMDB := 0;
                    END;
                    IF (v_V_CLAIM_SUFFIX_RMDB > 0 AND
                       v_V_CLAIM_SUFFIX_RMDB <> v_V_CLAIM_SUFFIX AND
                       v_IdentifyClaimantBySuffixGCVA <> 0) THEN
                      ---- SUFFIX DOES NOT EXISTS BUT CLAIMANT EXISTS IN CLAIM WITH ANOTHER CLAIMANT_SUFFIX
                      v_V_SUFFIXERROR       := 1;
                      v_V_DUPLICATECLAIMANT := 1;
                    ELSE
                      v_V_NEW_CLAIMANT := 1;
                    END IF;
                  END IF;

                  ----JIRA RMA-23225 ENDS

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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
              END IF;
            END IF;

            IF v_V_SUFFIXERROR = 1 THEN
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_V_DA_ROW_ID,
                                    v_V_MODULENAME,
                                    v_V_ERRORLOC,
                                    v_V_ERRORLOC,
                                    v_V_PROCNAME,
                                    'Claimant for Claimant Suffix or Claimant Name provided in Import File exists in Riskmaster. New Claimant Not created. Record Skipped.',
                                    'CLAIM_SUFFIX',
                                    v_V_ERROR_TABLE,
                                    'CLAIM_NUMBER',
                                    v_V_CLAIM_NUMBER,
                                    1);

              v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
            END IF;

            ---- JIRA RMA-22720 STARTS ----

            IF v_V_USE_ENTITY_ROLE_FLAG <> 0 AND
               v_V_SYS_TABLE_NAME IS NOT NULL THEN
              BEGIN
                v_V_ERRORLOC := 'ER01';
                v_V_SQL      := 'SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                                'GLOSSARY ' ||
                                'WHERE SYSTEM_TABLE_NAME = :1 ';
                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_TABLE_ID
                    USING v_V_SYS_TABLE_NAME;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_TABLE_ID := 0;
                END;
                v_V_ROLE_TABLE_ID := v_V_TABLE_ID;

                ----ROLE COMBINATION EXCLUSION STARTS JIRA RMA-22720 STARTS----
                ---- ONLY IF ENTITY ROLE IS ON
                ---- CURRENTLY THIS FUNCTIONALITY IS IMPLEMENTED AT CLAIM LEVEL FOR PI, ADJUSTER AND CLAIMANT LEVEL ONLY

                IF v_V_PARENT_TABLE_NAME = 'CLAIM' THEN
                  ----AT CLAIM LEVEL

                  v_V_ERRORLOC := 'ER02';
                  --PRINT 'CHECKING FOR ENTITY IN PI: '
                  v_V_SHORT_CODE    := 'RECRT';
                  v_V_CODE_REL_TYPE := 'CODE_REL_TYPE';
                  v_V_CODE_ID_R     := 0;

                  ----CHECK FOR PERSON_INVOLVED
                  v_V_SQL := 'SELECT PI_ROW_ID FROM ' || v_V_DBNAME ||
                             'PERSON_INVOLVED WHERE PI_EID = :1 ' ||
                             'AND PARENT_ROW_ID = :2 AND PARENT_TABLE_NAME = :3 AND ROLE_TABLE_ID IN ' ||
                             '(SELECT CODE1 FROM ' || v_V_DBNAME ||
                             'CODE_X_CODE WHERE REL_TYPE_CODE IN ' ||
                             '(SELECT CODE_ID FROM ' || v_V_DBNAME ||
                             'CODES WHERE SHORT_CODE = :4 AND TABLE_ID IN ' ||
                             '(SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                             'GLOSSARY WHERE SYSTEM_TABLE_NAME = :5)) ' ||
                             'AND CODE2 = :6 AND DELETED_FLAG = 0)';
                  BEGIN
                    EXECUTE IMMEDIATE V_V_SQL
                      INTO v_V_CODE_ID_R
                      USING v_V_CLAIMANT_EID, v_V_PARENT_ROW_ID, v_V_PARENT_TABLE_NAME, v_V_SHORT_CODE, v_V_CODE_REL_TYPE, v_V_ROLE_TABLE_ID;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_V_CODE_ID_R := 0;
                  END;

                  --print v_V_SQL
                  --print 'claimant eid : ' + cast(v_V_CLAIMANT_EID as varchar(10))
                  --print 'role table id : ' + cast(v_V_ROLE_TABLE_ID as varchar(10))
                  --print 'parent row id : ' + cast(v_V_PARENT_ROW_ID as varchar(10))
                  --print 'parent table name: ' + cast(v_V_PARENT_TABLE_NAME as varchar(10))
                  --PRINT 'PI ROW ID: ' + CAST( v_V_PI_ROW_ID AS VARCHAR(10))

                  IF v_V_CODE_ID_R > 0 THEN
                    v_V_EXCLUSIONERROR := 1;
                  END IF;

                  IF v_V_EXCLUSIONERROR = 0 THEN
                    ----FETCH ALL ROLES FROM CODE_X_CODE
                    v_V_ERRORLOC := 'ER03';
                    --PRINT 'COLLECT VALUES FROM CODE_X_CODE: '

                    v_V_SQL := 'SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                               'GLOSSARY WHERE TABLE_ID IN (SELECT CODE1 FROM ' ||
                               v_V_DBNAME ||
                               'CODE_X_CODE WHERE REL_TYPE_CODE IN (SELECT CODE_ID FROM ' ||
                               v_V_DBNAME ||
                               'CODES WHERE SHORT_CODE = :1 AND TABLE_ID IN ' ||
                               '(SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                               'GLOSSARY WHERE SYSTEM_TABLE_NAME = :2 ))' ||
                               'AND CODE2 = :3 AND DELETED_FLAG = 0) AND SYSTEM_TABLE_NAME = ''ADJUSTERS''';
                    BEGIN
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_V_TABLE_ID
                        USING v_V_SHORT_CODE, v_V_CODE_REL_TYPE, v_V_ROLE_TABLE_ID;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_TABLE_ID := 0;
                    END;

                    IF v_V_TABLE_ID > 0 THEN
                      v_V_ERRORLOC := 'ER04';
                      --PRINT 'ADJUSTER EXISTS? : ' + CAST(v_V_TABLE_ID AS VARCHAR)

                      v_V_CODE_ID_R := 0;
                      v_V_SQL       := 'SELECT ADJ_ROW_ID FROM ' ||
                                       v_V_DBNAME ||
                                       'CLAIM_ADJUSTER WHERE CLAIM_ID = :1 AND ADJUSTER_EID = :2';
                      BEGIN
                        EXECUTE IMMEDIATE v_V_SQL
                          INTO v_V_CODE_ID_R
                          USING v_V_CLAIM_ID, v_V_CLAIMANT_EID;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_V_CODE_ID_R := 0;
                      END;

                      --PRINT 'ENTITY FOUND IN ADJUSTERS ? : ' + CAST(v_V_CODE_ID_R AS VARCHAR)
                      IF v_V_CODE_ID_R > 0 THEN
                        v_V_EXCLUSIONERROR := 1;
                      END IF;
                    END IF;

                    IF v_V_EXCLUSIONERROR = 0 THEN
                      v_V_ERRORLOC := 'ER05';
                      v_V_TABLE_ID := 0;

                      v_V_SQL := 'SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                                 'GLOSSARY WHERE TABLE_ID IN (SELECT CODE1 FROM ' ||
                                 v_V_DBNAME ||
                                 'CODE_X_CODE WHERE REL_TYPE_CODE IN (SELECT CODE_ID FROM ' ||
                                 v_V_DBNAME ||
                                 'CODES WHERE SHORT_CODE = :1 AND TABLE_ID IN ' ||
                                 '(SELECT TABLE_ID FROM ' || v_V_DBNAME ||
                                 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :2 ))' ||
                                 'AND CODE2 = :3 AND DELETED_FLAG = 0) AND SYSTEM_TABLE_NAME = ''CLAIMANTS''';
                      BEGIN
                        EXECUTE IMMEDIATE V_V_SQL
                          INTO v_V_TABLE_ID
                          USING v_V_SHORT_CODE, v_V_CODE_REL_TYPE, v_V_ROLE_TABLE_ID;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_V_TABLE_ID := 0;
                      END;
                      --PRINT 'CLAIMANT EXISTS ? : ' + CAST(v_V_TABLE_ID AS VARCHAR(10))
                      --PRINT 'DUPLICATE CLAIMANT ? : ' + CAST(v_V_DUPLICATECLAIMANT AS VARCHAR(10))

                      IF v_V_TABLE_ID > 0 AND v_V_DUPLICATECLAIMANT > 0 THEN
                        --PRINT 'ENTITY FOUND IN CLAIMANT: ' + CAST(v_V_CLAIMANT_EID AS VARCHAR)
                        v_V_EXCLUSIONERROR := 1;
                      END IF;
                    END IF;
                  END IF;
                END IF;

                IF v_V_EXCLUSIONERROR = 1 THEN
                  v_V_ERRORLOC := 'ER10';
                  --print 'ROLE COMBINATION ERROR'
                  v_V_ERROR_MESSAGE := v_V_PARENT_TABLE_NAME ||
                                       ': Role is Excluded with Existing Roles in Person Involved attached with this claim. Use Code Relationship on Riskmaster to change the Mapping.';

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        v_V_ERROR_MESSAGE,
                                        'CODE RELATIONSHIP',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
            END IF;

            ----ROLE COMBINATION EXCLUSION STARTS JIRA RMA-22720 STARTS----

            ----***************************** REMEMBER PERSON INVOLVED FOR ENTITY ROLE ACCORDING TO NEW ENHANCEMENTS ****************************************************
            IF v_V_CLAIMANT_EID > 0 AND
               (v_V_RECORD_TYPE = 'W' OR v_V_RECORD_TYPE = 'D' OR
               --(v_V_RECORD_TYPE = 'G' AND v_V_EMPLOYEE_ID IS NOT NULL) OR ----JIRA RMA-22720 ----
               (v_V_RECORD_TYPE = 'V' AND
               (v_V_EMPLOYEE_ID IS NOT NULL OR v_V_ADDClaimantASPI <> 0)) OR ----JIRA RMA-22720 ----
               --(v_V_RECORD_TYPE = 'V' AND v_V_EMPLOYEE_ID IS NOT NULL)) THEN
               --JIRA 24634 knakra starts
               (v_V_RECORD_TYPE = 'H' AND
               (v_V_EMPLOYEE_ID IS NOT NULL OR v_V_ADDClaimantASPI <> 0)) OR
               --JIRA 24634 knakra ends
               (v_V_RECORD_TYPE = 'G' AND
               (v_V_EMPLOYEE_ID IS NOT NULL OR v_V_ADDClaimantASPI <> 0))) THEN
              ----JIRA RMA-22720 ----

              ----EMPLOYEE BEGINS

              v_V_ERRORLOC     := 'V041';
              v_V_EMPLOYEE_EID := 0;
              v_V_EMP_PERSON   := 1;
              v_V_SQL          := 'SELECT EMPLOYEE_EID FROM ' || v_V_DBNAME ||
                                  'EMPLOYEE WHERE EMPLOYEE_EID = :1';

              BEGIN
                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_V_EMPLOYEE_EID
                  USING v_V_CLAIMANT_EID;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_EMPLOYEE_EID := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              --PRINT 'employee id : ' + cast(@V_EMPLOYEE_EID AS VARCHAR(10))
              IF v_V_EMPLOYEE_EID = 0 THEN
                v_V_ERRORLOC := 'V041A';

                BEGIN
                  v_V_SQL := 'SELECT EMPLOYEE_EID FROM ' || v_V_DBNAME ||
                             'EMPLOYEE WHERE EMPLOYEE_NUMBER = :1';
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_EMPLOYEE_EID_RMDB
                    USING v_V_EMPLOYEE_NUMBER;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_EMPLOYEE_EID_RMDB := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;

                IF v_V_EMPLOYEE_EID_RMDB > 0 THEN
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_V_DA_ROW_ID,
                                        v_V_MODULENAME,
                                        v_V_ERRORLOC,
                                        v_V_ERRORLOC,
                                        v_V_PROCNAME,
                                        'Employee Number is associated with another entity. Provide a Unique Employee Number.',
                                        'EMPLOYEE_ID',
                                        v_V_ERROR_TABLE,
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        1);
                  v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                END IF;

                IF v_CheckCreateNewEmployees = 1 AND
                   (v_V_EMPLOYEE_EID_RMDB = 0) THEN
                  v_V_NEW_EMP := 1;
                END IF;
              ELSE
                IF v_V_EMPLOYEE_EID > 0 THEN
                  ----UPDATE CASE FOR EMPLOYEES
                  --PRINT 'UPDATE CASE FOR EMPLOYEES: '
                  v_V_NEW_EMP := 0;
                END IF;
              END IF;

              IF v_V_DEPENDENT_LNAME IS NOT NULL OR
                 v_V_DEPENDENT_FNAME IS NOT NULL THEN
                BEGIN
                  --PRINT 'PROCESS DEPEPNDENT HERE'
                  v_V_ERRORLOC := 'V042';
                  VENTITY_TYPE := DDS_ENTITY_TYPE(v_V_DEPENDENT_LNAME,
                                                  v_V_DEPENDENT_FNAME,
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
                                                  v_V_DEPENDENT_BIRTH_DT,
                                                  NULL,
                                                  NULL,
                                                  0,
                                                  'DEPENDENTS',
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  v_V_NAME_TYPE_ID,
                                                  NULL,
                                                  v_P_JOBID,
                                                  v_V_DA_ROW_ID);
                  --PRINT 'ENTITY IMPORT STARTS'
                  PROCESS_ENTITY(VENTITY_TYPE,
                                 v_P_JOBID,
                                 v_V_DA_ROW_ID,
                                 v_V_DBNAME,
                                 v_V_MODULENAME,
                                 v_ForceCreateEntity,
                                 0,
                                 v_V_ERRORLOC,
                                 v_V_CLAIM_NUMBER,
                                 1, --JIRA 24634 knakra
                                 v_V_DEPENDENT_EID,
                                 v_V_ERROR_MESSAGE);

                  --PRINT 'ENTITY IMPORT STARTS FOR DEPEPNDENT: '

                  IF v_V_ERROR_MESSAGE IS NOT NULL THEN
                    v_V_ERRORLOC := 'V042A';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_V_DA_ROW_ID,
                                          v_V_MODULENAME,
                                          v_V_ERRORLOC,
                                          v_V_ERRORLOC,
                                          v_V_PROCNAME,
                                          v_V_ERROR_MESSAGE,
                                          'DEPENDENT',
                                          v_V_ERROR_TABLE,
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          1);

                    v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                  END IF;

                  IF v_V_DEPENDENT_EID > 0 AND v_V_CLAIMANT_EID > 0 THEN
                    v_V_ERRORLOC := 'V043';
                    v_V_SQL      := 'SELECT EMP_DEP_ROW_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'EMP_X_DEPENDENT WHERE EMPLOYEE_EID = :1 AND DEPENDENT_EID = :2';
                    BEGIN
                      EXECUTE IMMEDIATE V_V_SQL
                        INTO v_V_EMP_DEP_ROW_ID
                        USING v_V_CLAIMANT_EID, v_V_DEPENDENT_EID;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_EMP_DEP_ROW_ID := 0;
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
                                              'CLAIM_NUMBER',
                                              v_V_CLAIM_NUMBER,
                                              0);
                        v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

                    END;

                    IF v_V_EMP_DEP_ROW_ID = 0 THEN
                      v_V_ERRORLOC := 'V044';

                      v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                      v_V_DBNAME ||
                                      'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                      BEGIN
                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_EMP_DEP_ROW_ID
                          USING 'EMP_X_DEPENDENT';
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_V_EMP_DEP_ROW_ID := 0;
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
                                                'CLAIM_NUMBER',
                                                v_V_CLAIM_NUMBER,
                                                0);

                          v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                      END;

                      --PRINT 'iNSERT INTO EMPLOYEE_X_DEPPENDENT'
                      v_V_INSERT_EMPXDEP := 1;

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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);

                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
              END IF;
            END IF;

            -- DEPPENDENT ENDS
            ----EMPLOYEE ENDS
            IF v_V_EMP_PERSON = 1 THEN
              --- PERSON INVOLVED SHOULD BE THERE FOR EMPLOYEES ONLY
              ---- ROLE TO COMPONENTS STARTS JIRA RMA-22720----
              ---- NO DEPENDENCY ON ENTITY ROLE ON/OFF

              v_V_ERRORLOC      := 'V032CC';
              v_V_ROW_ID        := 0;
              v_V_SHORT_CODE    := 'RCCRT';
              v_V_CODE_REL_TYPE := 'CODE_REL_TYPE';

              v_V_SQL := 'SELECT ROW_ID FROM ' || v_V_DBNAME ||
                         'CODE_X_CODE' || ' WHERE ' ||
                         'REL_TYPE_CODE IN (SELECT CODE_ID FROM ' ||
                         v_V_DBNAME ||
                         'CODES WHERE SHORT_CODE = :1 AND TABLE_ID IN (SELECT TABLE_ID FROM ' ||
                         v_V_DBNAME || 'GLOSSARY' ||
                         ' WHERE SYSTEM_TABLE_NAME = :2 ))' ||
                         ' AND CODE1 IN (SELECT TABLE_ID FROM ' ||
                         v_V_DBNAME ||
                         'GLOSSARY WHERE SYSTEM_TABLE_NAME = :3)' ||
                         ' AND CODE2 IN (SELECT TABLE_ID FROM ' ||
                         v_V_DBNAME ||
                         'GLOSSARY WHERE SYSTEM_TABLE_NAME = :4)' ||
                         ' AND DELETED_FLAG = 0';

              BEGIN
                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_ROW_ID
                  USING v_V_SHORT_CODE, v_V_CODE_REL_TYPE, v_V_PARENT_TABLE_NAME, v_V_SYS_TABLE_NAME;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_ROW_ID := 0;
              END;
              --PRINT 'PARENT TABLE NAME2 ' || v_V_PARENT_TABLE_NAME
              --PRINT 'SYSTEM TABLE NAME2 ' || v_V_SYS_TABLE_NAME

              IF v_V_ROW_ID = 0 THEN
                v_V_ERRORLOC      := 'V032D';
                v_V_ERROR_MESSAGE := 'The Role to component mapping is missing for Component: ' ||
                                     v_V_PARENT_TABLE_NAME ||
                                     ' with Role: ' || v_V_SYS_TABLE_NAME ||
                                     '. Use Code Relationship on Riskmaster for creating a Mapping. ';

                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      v_V_ERROR_MESSAGE,
                                      'CODE RELATIONSHIP',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;

                ---- ROLE TO COMPONENTS ENDS JIRA RMA-22720----
              ELSE
                IF v_V_ROW_ID <> 0 THEN

                  v_V_ERRORLOC  := 'V045';
                  v_V_PI_ROW_ID := 0;
                  v_V_SQL       := 'SELECT PI_ROW_ID FROM ' || v_V_DBNAME ||
                                   'PERSON_INVOLVED WHERE EVENT_ID = :1 AND PI_EID = :2 ';
                  v_V_SQL       := v_V_SQL ||
                                   'AND ROLE_TABLE_ID = :3 AND PARENT_ROW_ID = :4 AND PARENT_TABLE_NAME = :5';
                  BEGIN
                    EXECUTE IMMEDIATE v_V_SQL
                      INTO v_V_PI_ROW_ID
                      USING v_V_EVENT_ID, v_V_CLAIMANT_EID, v_V_ROLE_TABLE_ID, v_V_PARENT_ROW_ID, v_V_PARENT_TABLE_NAME;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_V_PI_ROW_ID := 0;
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
                                            'CLAIM_NUMBER',
                                            v_V_CLAIM_NUMBER,
                                            0);
                      v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                  END;

                  IF v_V_PI_ROW_ID = 0 THEN
                    --PRINT 'PERSON INVOLVED INSERT'

                    v_V_ERRORLOC := 'V046';
                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                    BEGIN
                      EXECUTE IMMEDIATE v_VSQLINSERT
                        INTO v_V_PI_ROW_ID
                        USING 'PERSON_INVOLVED';
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_PI_ROW_ID := 0;
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
                                              'CLAIM_NUMBER',
                                              v_V_CLAIM_NUMBER,
                                              0);
                        v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                    END;

                    v_V_NEW_PI := 1;

                    BEGIN
                      v_V_SQL := 'SELECT WORK_SUN, WORK_MON, WORK_TUE, WORK_WED, WORK_THU,';
                      v_V_SQL := v_V_SQL || ' WORK_FRI, WORK_SAT';
                      v_V_SQL := v_V_SQL || ' FROM ' || v_V_DBNAME ||
                                 'SYS_PARMS';

                      EXECUTE IMMEDIATE v_V_SQL
                        INTO v_V_WORK_SUN, v_V_WORK_MON, v_V_WORK_TUE, v_V_WORK_WED, v_V_WORK_THU, v_V_WORK_FRI, v_V_WORK_SAT;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        NULL;
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
                                              'CLAIM_NUMBER',
                                              v_V_CLAIM_NUMBER,
                                              0);
                        v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                    END;
                  ELSE
                    IF v_V_PI_ROW_ID > 0 THEN
                      ---- PERSON INVOLVED EXISTS BEGIN
                      v_V_NEW_PI := 0;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;

            ---------***************************** EVENT X OSHA *********************************************************************************************
            IF v_V_OSHA_RECORDABLE_ID > 0 THEN
              ---- EVENT_X_OSHA STARTS
              BEGIN
                v_V_ERRORLOC := 'V047';
                v_V_SQL      := 'SELECT EVENT_ID FROM EVENT_X_OSHA WHERE EVENT_ID = :1';

                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_EVENT_ID_RMDB
                  USING v_V_EVENT_ID;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_EVENT_ID_RMDB := 0;
                WHEN OTHERS THEN
                  --PRINT 'UPDATE INTO EVENT_X_OSHA'
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
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              IF v_V_EVENT_ID_RMDB = 0 THEN
                --PRINT 'EVENT_X_OSHA IS NEW'
                v_V_NEW_EVENTXOSHA := 1;
                --PRINT 'iNSERT INTO EVENT_X_OSHA'
              ELSE
                v_V_NEW_EVENTXOSHA := 0;
              END IF;
            END IF;

            ---- EVENT_X_OSHA ENDS
            ---------------- CLAIM_X_LITIGATION OR PROCESS DOCKET FUNCTIONS -----------------------------------------------------------------------------------
            IF v_V_CASE_NUMBER IS NOT NULL THEN
              ---- BEGIN CLAIM X LITIGATION
              BEGIN
                v_V_ERRORLOC := 'V048';
                v_V_SQL      := 'SELECT LITIGATION_ROW_ID FROM ' ||
                                v_V_DBNAME ||
                                'CLAIM_X_LITIGATION WHERE CLAIM_ID = :1 AND DOCKET_NUMBER = :2';

                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_LITIGATION_ROW_ID
                  USING v_V_CLAIM_ID, v_V_CASE_NUMBER;

                --PRINT 'LITIGATION::::'
                --PRINT @V_LITIGATION_ROW_ID
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_V_LITIGATION_ROW_ID := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
              IF v_V_LITIGATION_ROW_ID = 0 THEN
                ----INSERT INTO CLAIM X LITIGATION
                v_V_NEW_CLAIMXLIT := 1;
              ELSE
                IF v_V_LITIGATION_ROW_ID > 0 THEN
                  -----UPDATE CLAIM X LITIGATION
                  v_V_NEW_CLAIMXLIT := 0;
                END IF;
              END IF;
            END IF;

            ----END CLAIM X LITIGATION
            ----------------------------------------------- DEFENDANT -----------------------------------------------------------------------------------------
            IF (v_V_DEF_LASTNAME IS NOT NULL OR
               v_V_DEF_FIRSTNAME IS NOT NULL) THEN
              v_V_ERRORLOC := 'V049';
              VENTITY_TYPE := DDS_ENTITY_TYPE(v_V_DEF_LASTNAME,
                                              v_V_DEF_FIRSTNAME,
                                              NULL,
                                              NULL,
                                              NULL,
                                              v_V_DEF_ADDRESS,
                                              NULL,
                                              v_V_DEF_CITY,
                                              NULL,
                                              v_V_DEF_STATE_ID,
                                              NULL,
                                              v_V_DEF_ZIP,
                                              v_V_DEF_PHONE,
                                              NULL,
                                              NULL,
                                              v_vDefBirthDate, --JIRA 24634 knakra
                                              NULL,
                                              v_V_DEF_COMMENT,
                                              0,
                                              'DEFENDANT',
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              v_V_NAME_TYPE_ID,
                                              NULL,
                                              v_P_JOBID,
                                              v_V_DA_ROW_ID);
              --PRINT 'ENTITY IMPORT STARTS FOR DEFENDANT: '
              v_V_ERRORLOC := 'V049Z';
              PROCESS_ENTITY(VENTITY_TYPE,
                             v_P_JOBID,
                             v_V_DA_ROW_ID,
                             v_V_DBNAME,
                             v_V_MODULENAME,
                             v_ForceCreateEntity,
                             0,
                             v_V_ERRORLOC,
                             v_V_CLAIM_NUMBER,
                             1, --JIRA 24634 knakra
                             v_V_DEFENDANT_EID,
                             v_V_ERROR_MESSAGE);

              IF v_V_ERROR_MESSAGE IS NOT NULL THEN
                v_V_ERRORLOC := 'V049A';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_V_DA_ROW_ID,
                                      v_V_MODULENAME,
                                      v_V_ERRORLOC,
                                      v_V_ERRORLOC,
                                      v_V_PROCNAME,
                                      v_V_ERROR_MESSAGE,
                                      'DEF_LASTNAME;DEF_FIRSTNAME',
                                      v_V_ERROR_TABLE,
                                      'CLAIM_NUMBER',
                                      v_V_CLAIM_NUMBER,
                                      1);
                v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
              END IF;

              --PRINT @V_DEFENDANT_EID
              IF v_V_DEFENDANT_EID > 0 THEN
                v_V_ERRORLOC := 'V050';
                v_V_SQL      := 'SELECT CLAIM.CLAIM_ID FROM ' || v_V_DBNAME ||
                                'CLAIM, ' || v_V_DBNAME ||
                                'DEFENDANT WHERE ' || v_V_DBNAME ||
                                'CLAIM.CLAIM_ID = ' || v_V_DBNAME ||
                                'DEFENDANT.CLAIM_ID';
                v_V_SQL      := v_V_SQL || ' AND ' || v_V_DBNAME ||
                                'DEFENDANT.DEFENDANT_EID = :1 AND ' ||
                                v_V_DBNAME || 'CLAIM.CLAIM_ID = :2';

                --PRINT @v_sql
                BEGIN
                  v_V_CLAIM_DEFCOUNT := 0;
                  EXECUTE IMMEDIATE v_V_SQL
                    INTO v_V_CLAIM_DEFCOUNT
                    USING v_V_DEFENDANT_EID, v_V_CLAIM_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLAIM_DEFCOUNT := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;
                --PRINT @V_CLAIM_DEFCOUNT
                IF v_V_CLAIM_DEFCOUNT = 0 THEN
                  v_V_NEW_DEFENDANT := 1;
                END IF;
              END IF;
            END IF;
            ---- ************************ VEHICLE ***************************** CLAIM ID *******************************DONE

            IF v_V_RECORD_TYPE = 'V' AND v_V_VEHICLE_ID IS NOT NULL THEN
              ---- begin vehicle
              BEGIN
                --PRINT ' VEHICLE PART STARTS'
                ----TEST THIS COUNT
                v_V_ERRORLOC       := 'V051';
                v_V_CLAIM_DEFCOUNT := 0;
                v_V_SQL            := 'SELECT UNIT_ID FROM ' || v_V_DBNAME ||
                                      'VEHICLE WHERE VIN = :1 AND DELETED_FLAG = 0';
                BEGIN
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_CLAIM_DEFCOUNT
                    USING v_V_VEHICLE_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLAIM_DEFCOUNT := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

                END;

                IF v_V_CLAIM_DEFCOUNT = 0 THEN
                  v_V_ERRORLOC := 'V052';

                  --PRINT 'VEHICLE IMPORT'
                  v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                  v_V_DBNAME ||
                                  'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                  EXECUTE IMMEDIATE v_VSQLINSERT
                    INTO v_V_VEHICLE_UNIT_ID
                    USING 'VEHICLE';
                  v_V_NEW_VEHICLE := 1;
                ELSE
                  IF v_V_CLAIM_DEFCOUNT > 0 THEN
                    --PRINT 'VEHICLE UPDATE'
                    v_V_NEW_VEHICLE     := 0;
                    v_V_VEHICLE_UNIT_ID := v_V_CLAIM_DEFCOUNT;
                  END IF;

                END IF;

                BEGIN
                  v_V_ERRORLOC       := 'V053';
                  v_V_CLAIM_DEFCOUNT := 0;
                  v_V_SQL            := 'SELECT CLAIM_ID FROM ' ||
                                        v_V_DBNAME ||
                                        'UNIT_X_CLAIM WHERE CLAIM_ID = :1 AND UNIT_ID = :2';
                  EXECUTE IMMEDIATE v_V_SQL
                    INTO v_V_CLAIM_DEFCOUNT
                    USING v_V_CLAIM_ID, v_V_VEHICLE_UNIT_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLAIM_DEFCOUNT := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;

                IF v_V_CLAIM_DEFCOUNT = 0 THEN
                  v_V_ERRORLOC := 'V054';
                  v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                  v_V_DBNAME ||
                                  'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                  EXECUTE IMMEDIATE v_VSQLINSERT
                    INTO v_V_CLAIMXUNIT_ROW_ID
                    USING 'UNIT_X_CLAIM';
                  v_V_NEW_UNITXCLAIM := 1;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
            END IF;

            ---- end vehicle
            ---- ************************** UNIT_STAT ************************** CLAIM ID ********************
            --PRINT 'RECORD TYPE'
            --PRINT @V_RECORD_TYPE
            IF v_V_RECORD_TYPE = 'W' THEN
              ---- BEGIN UNIT STAT
              BEGIN
                BEGIN
                  v_V_ERRORLOC       := 'V055';
                  v_V_SQL            := 'SELECT CLAIM_ID FROM ' ||
                                        v_V_DBNAME ||
                                        'UNIT_STAT WHERE CLAIM_ID = :1';
                  v_V_CLAIM_DEFCOUNT := 0;
                  EXECUTE IMMEDIATE V_V_SQL
                    INTO v_V_CLAIM_DEFCOUNT
                    USING v_V_CLAIM_ID;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_V_CLAIM_DEFCOUNT := 0;
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
                                          'CLAIM_NUMBER',
                                          v_V_CLAIM_NUMBER,
                                          0);
                    v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                END;

                IF v_V_CLAIM_DEFCOUNT <= 0 THEN
                  v_V_ERRORLOC := 'V056';
                  v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                  v_V_DBNAME ||
                                  'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                  EXECUTE IMMEDIATE v_VSQLINSERT
                    INTO v_V_CLAIMXUNIT_ROW_ID
                    USING 'UNIT_STAT';

                  v_V_NEW_UNITSTAT := 1;
                ELSE
                  ---- UPDATE UNIT STAT
                  --PRINT 'UPDATE UNIT STAT'
                  v_V_NEW_UNITSTAT := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);

                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;
            END IF;

            ---- END UNIT STAT
            -------------------- PROCESS RESERVE CURRENT---------------ONLY FOR CORPORATE CLIENTS----------vvvv----------------------------
            IF v_V_CARRIERFLAG = 0 AND v_V_BUCKETLIST IS NOT NULL AND
               V_iVarFinKey = 0 THEN
              -- ADDED VFK CONDITION FOR JIRA#23899 BY KAPIL
              ----BEGIN PROCESS RESERVE

              v_V_ERRORLOC := 'V057';
              v_V_SQL      := 'SELECT RESERVE_TRACKING FROM ' || v_V_DBNAME ||
                              'SYS_PARMS_LOB' ||
                              ' WHERE LINE_OF_BUS_CODE = :1';

              BEGIN
                --PRINT @V_SQL;
                EXECUTE IMMEDIATE v_V_SQL
                  INTO v_V_RESERVE_TRACKING
                  USING v_V_CLAIM_LOB;

                IF v_V_RECORD_TYPE = 'V' AND v_V_VEHICLE_ID IS NOT NULL THEN
                  v_V_CLAIMANT_EID_R := 0;
                  v_V_UNIT_ID_R      := v_V_VEHICLE_UNIT_ID;
                ELSE
                  v_V_CLAIMANT_EID_R := v_V_CLAIMANT_EID;
                  v_V_UNIT_ID_R      := 0;
                END IF;

                IF v_V_RESERVE_TRACKING = 0 THEN
                  ---- CLAIM LEVEL TRACKING
                  --PRINT 'CLAIM LEVEL RESERVES TRACKING';
                  IF v_V_RECORD_TYPE = 'G' THEN
                    v_V_CLAIMANT_EID_R := 0;
                    v_V_UNIT_ID_R      := 0;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
              END;

              BEGIN
                v_V_ERRORLOC := 'V058';
                v_V_SQL      := 'SELECT COLL_IN_RSV_BAL, COLL_IN_INCUR_BAL FROM ' ||
                                v_V_DBNAME || 'SYS_PARMS_LOB';
                v_V_SQL      := v_V_SQL || ' WHERE LINE_OF_BUS_CODE = :1';

                EXECUTE IMMEDIATE V_V_SQL
                  INTO v_V_COL_IN_RSV_BAL, v_V_COL_IN_INC_BAL
                  USING v_V_CLAIM_LOB;
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
                                        'CLAIM_NUMBER',
                                        v_V_CLAIM_NUMBER,
                                        0);
                  v_V_ROWCOUNT := v_V_ROWCOUNT + 1;

              END;

            END IF;
						---AKUMAAR523 
			IF v_V_NEWEVENT = 1 THEN
                   
					
				  v_V_SQL := 'SELECT C.CODE_ID FROM '||v_V_DBNAME||'CODES C, '||v_V_DBNAME||'GLOSSARY G WHERE c.TABLE_ID = G.TABLE_ID ';
                  v_V_SQL := v_V_SQL || ' AND UPPER(C.SHORT_CODE) = :1 AND G.SYSTEM_TABLE_NAME=:2';

                  EXECUTE IMMEDIATE v_V_SQL into v_V_EVENT_TYPE_CODE_ID  using 'NA', 'EVENT_TYPE';


			END IF ;
			---AKUMAR523  62604
            ----END PROCESS RESERVE
            ------------------------------------------------------------------------------------------------------------
            v_V_ERRORLOC := 'V059';

            --PRINT 'ERROR COUNT : ' + CAST(@V_ERRORCOUNT AS VARCHAR(3))
            IF v_V_ROWCOUNT + v_V_ERRORCOUNT > 0 THEN
              v_V_INVALID_ROW := 1;
            ELSE
              IF v_V_ROWCOUNT + v_V_ERRORCOUNT = 0 THEN
                v_V_INVALID_ROW := 0;
              END IF;
            END IF;

          END IF;
          ------------------------- END INVALID ROW 0

          BEGIN
            BEGIN
              ------------------------------------------------------------------VCVC------------------------------------------------------------------------------------------------
              ------------INSERT WORK STARTS
              IF v_V_INVALID_ROW = 0 THEN
                BEGIN
                  ----BEGIN LEVEL INSERT/UPDATE
                  EXECUTE IMMEDIATE 'select to_char(sysdate,' || '''' ||
                                    'yyyymmddhh24miss' || '''' ||
                                    ') from dual'
                    into v_V_DATETIME;

                  --v_V_DATETIME := REPLACE(REPLACE(REPLACE(sqlserver_utilities.convert_('VARCHAR2(19)', SYSDATE, 120), '-', ''), ':', ''), ' ', '');
                  --v_V_DATETIME :=

                  IF (v_CheckCreateNewDepartment = 1 AND
                     v_V_DEPARTMENT_ID = 0 OR v_V_DELETED_FLAG_DEPT = -1) THEN

                    v_DDS_ORG_HIERARCHY_TYPE := DDS_ORG_HIERARCHY_TYPE(v_P_JOBID,
                                                                       v_V_DA_ROW_ID,
                                                                       v_V_DEPARTMENT,
                                                                       v_V_LOCATION,
                                                                       v_V_DIVISION,
                                                                       v_V_COMPANY,
                                                                       v_V_DEPARTMENT_DESC,
                                                                       v_V_LOCATION_DESC,
                                                                       v_V_DIVISION_DESC,
                                                                       v_V_COMPANY_DESC);

                    --PRINT 'ORG HIERARCHY IMPORT STARTS'
                    DDS_PROCESSORG_HIERARCHY(v_DDS_ORG_HIERARCHY_TYPE,
                                             v_P_JOBID,
                                             v_V_DA_ROW_ID,
                                             v_V_DBNAME,
                                             'CLAIM_NUMBER',
                                             v_V_CLAIM_NUMBER,
                                             v_V_DEPARTMENT_ID);

                    IF v_V_DEPARTMENT_ID < 0 THEN
                      v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                      GOTO FETCHNEXT; ---- IF ANY EXCEPTION OCCURS IN PROCESS ORG HIERARCHY
                    END IF;
                  END IF;

                  IF v_V_NEWEVENT = 1 THEN
                    ----****************** EVENT INSERT *************************************************************
                    ----BEGIN EVENT INSERT
                    v_V_ERRORLOC := 'INSERT052';
                    v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                    'EVENT(EVENT_ID, EVENT_NUMBER, CAUSE_CODE, DATE_OF_EVENT, DATE_REPORTED, TIME_OF_EVENT, TIME_REPORTED, DEPT_HEAD_ADVISED, RELEASE_SIGNED, ';
                    v_V_SQL      := v_V_SQL ||
                                    'TREATMENT_GIVEN, ON_PREMISE_FLAG, EVENT_STATUS_CODE, EVENT_TYPE_CODE, EVENT_IND_CODE, DEPT_EID, DTTM_RCD_ADDED, ADDED_BY_USER, DTTM_RCD_LAST_UPD, ';
                    v_V_SQL      := v_V_SQL ||
                                    'UPDATED_BY_USER, EVENT_DESCRIPTION, STATE_ID ) ';
                    v_V_SQL      := v_V_SQL ||
                                    'VALUES(:1, :2, :3, :4, :5, :6, :7, :8, ';
                    v_V_SQL      := v_V_SQL ||
                                    ':9, :10, :11, :12, :13, :14, ';
                    v_V_SQL      := v_V_SQL ||
                                    ':15, :16, :17, :18, :19, :20, :21 )';
                    --PRINT @V_SQL
                    EXECUTE IMMEDIATE v_V_SQL
                      USING v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_CAUSE_CODE_ID, v_V_DATE_OF_EVENT, v_V_DATE_REPORTED, v_V_TIME_OF_EVENT, '000000', 0, 0, 0, 0, v_V_EVENT_STATUS_CODE_ID, v_V_EVENT_TYPE_CODE_ID, v_V_EVENT_IND_CODE_ID, v_V_DEPARTMENT_ID, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DESCRIPTION, 0;

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'EVENT';

                    ----END EVENT INSERT
                  ELSE
                    IF v_V_NEWEVENT = 0 THEN
                      ----BEGIN EVENT UPDATE

                      v_V_ERRORLOC := 'INSERT053';
                      v_V_SQL      := 'UPDATE ' || v_V_DBNAME ||
                                      'EVENT SET';
                      v_V_SQL      := v_V_SQL || ' DATE_OF_EVENT = :1';
                      v_V_SQL      := v_V_SQL || ', EVENT_STATUS_CODE = :2';
                      v_V_SQL      := v_V_SQL || ', DEPT_EID = :3';
                      v_V_SQL      := v_V_SQL || ' WHERE EVENT_ID = :4';
                      --PRINT @V_SQL
                      EXECUTE IMMEDIATE v_V_SQL
                        USING v_V_DATE_OF_EVENT, v_V_EVENT_STATUS_CODE_ID, v_V_DEPT_EID, v_V_EVENT_ID;

                    END IF;

                  END IF;

                  BEGIN
                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'CLAIM_STATUS_HIST(CL_STATUS_ROW_ID, CLAIM_ID, STATUS_CODE, DATE_STATUS_CHGD, STATUS_CHGD_BY) VALUES( ';
                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5)';

                    v_VSQLUPDATE := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                  END;
      
    ---AKUMAR523 STARTS WRITTING COMMMON QUERRY FOR RMA-61584
  
        IF v_fVersionNum >= 19.1  THEN
          VSQLINSCLT := 'SELECT NEXT_UNIQUE_ID FROM ' ||  v_V_DBNAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
    
          V_SQL_CLT := 'INSERT INTO ' || v_V_DBNAME || 'CLAIM_TYPE_HIST(CLM_TYPE_ROW_ID, CLAIM_ID, CLM_TYPE_CODE, DATE_CLM_TYPE_CHGD, CLM_TYPE_CHGD_BY,DTTM_RCD_ADDED,REASON) VALUES( ';
          V_SQL_CLT := V_SQL_CLT || ':1, :2, :3, :4, :5, :6, :7)';
    ----PRINT @V_SQL_CLT
    
          VSQLUPDCLT := 'UPDATE ' || v_V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
      
    ------FOR REWIEW START
          VSQLINSREW := 'SELECT NEXT_UNIQUE_ID FROM ' || v_V_DBNAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
    
          V_SQL_REW := 'INSERT INTO ' || v_V_DBNAME || 'CLAIM_REVIEW_HIST(CL_REVIEW_ROW_ID, CLAIM_ID, STATUS_CODE, DATE_STATUS_CHGD, STATUS_CHGD_BY,REASON) VALUES( ';
          V_SQL_REW := V_SQL_REW || ':1, :2, :3, :4, :5, :6)';
                                                                        
          VSQLUPDREW := 'UPDATE ' || v_V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

          IF v_V_CLAIM_TYPE_DT_CHA IS NULL OR v_V_CLAIM_TYPE_DT_CHA = 0 THEN   ----FOR CLAIM TYPE HISTORY
       
            v_V_CLAIM_TYPE_DT_CHA := v_vTodayDate;
          END IF;
          IF v_V_REV_STA_DT_CH IS NULL OR v_V_REV_STA_DT_CH = 0 THEN  -----FOR REVIEW TYPE HISTORY
      
            v_V_REV_STA_DT_CH := v_vTodayDate;
          END IF;

          IF v_V_NEWCLAIM = 0 THEN
       
            IF v_V_CLAIM_TYPE_ID <> v_iExtClmTypeCode THEN
        
              v_V_CLTP_CHA := 1;
            END IF;
            IF v_ioldRevTypCode <> v_V_REVIEW_STATUS_CODE_ID THEN
        
              v_V_REWTP_CHA := 1;
            END IF; 
          END IF;     
        END IF;

                  ---- END EVENT UPDATE
                  IF v_V_NEWCLAIM = 1 THEN
                    IF (DDS_IS_DATE(v_V_DATE_REOPENED) = 1 AND
                       v_V_BOPENCLAIM = 1) THEN
                      ------ CLAIM_STATUS HIST WORK
                      --BEGIN LEVEL 1

                      IF v_V_OPENCLAIM_CODE_ID > 0 THEN
                        --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_OF_CLAIM FOR OPEN CLAIM STATUS'
                        v_V_ERRORLOC := 'INSERT054';

                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_CL_STATUS_ROW_ID
                          USING 'CLAIM_STATUS_HIST';

                        EXECUTE IMMEDIATE v_V_SQL
                          USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_OPENCLAIM_CODE_ID, v_V_DATE_OF_CLAIM, v_V_DDSUSER;

                        EXECUTE IMMEDIATE v_VSQLUPDATE
                          USING 'CLAIM_STATUS_HIST';

                      END IF;

                      IF v_V_CLOSEDCLAIM_CODE_ID > 0 THEN
                        --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_CLOSED FOR CLOSED CLAIM STATUS'
                        v_V_ERRORLOC := 'INSERT055';

                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_CL_STATUS_ROW_ID
                          USING 'CLAIM_STATUS_HIST';

                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_CLOSEDCLAIM_CODE_ID, v_V_DATE_CLOSED, v_V_DDSUSER;

                        EXECUTE IMMEDIATE v_VSQLUPDATE
                          USING 'CLAIM_STATUS_HIST';

                        v_V_DTTM_CLOSED := v_V_DATE_CLOSED;

                      END IF;

                      IF v_V_CLAIM_STATUS_ID > 0 THEN
                        --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_REOPENED FOR CLAIM STATUS GIVEN IN IMPORT FILE'
                        v_V_ERRORLOC := 'INSERT056';

                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_CL_STATUS_ROW_ID
                          USING 'CLAIM_STATUS_HIST';

                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_REOPENED, v_V_DDSUSER;

                        EXECUTE IMMEDIATE v_VSQLUPDATE
                          USING 'CLAIM_STATUS_HIST';
                      END IF;
                      --END LEVEL 1
                    ELSE
                      IF (DDS_IS_DATE(v_V_DATE_REOPENED) = 0 AND
                         v_V_BOPENCLAIM = 1) THEN
                        --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_OF_CLAIM FOR OPEN CLAIM STATUS'
                        v_V_ERRORLOC := 'INSERT057';

                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_CL_STATUS_ROW_ID
                          USING 'CLAIM_STATUS_HIST';

                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_OPENCLAIM_CODE_ID, v_V_DATE_OF_CLAIM, v_V_DDSUSER;

                        EXECUTE IMMEDIATE v_VSQLUPDATE
                          USING 'CLAIM_STATUS_HIST';

                        v_V_CLOSURE_METHOD_ID := 0;

                      ELSE
                        IF (DDS_IS_DATE(v_V_DATE_REOPENED) = 0 AND
                           v_V_BCLOSEDCLAIM = 1) THEN
                          ----- BEGIN LEVEL (@V_DATE_REOPENED = 0 AND @V_BCLOSEDCLAIM = 1)

                          IF v_V_OPENCLAIM_CODE_ID > 0 THEN
                            --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_OF_CLAIM FOR OPEN CLAIM'
                            v_V_ERRORLOC := 'INSERT058';

                            EXECUTE IMMEDIATE v_VSQLINSERT
                              INTO v_V_CL_STATUS_ROW_ID
                              USING 'CLAIM_STATUS_HIST';

                            EXECUTE IMMEDIATE V_V_SQL
                              USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_OPENCLAIM_CODE_ID, v_V_DATE_OF_CLAIM, v_V_DDSUSER;

                            EXECUTE IMMEDIATE v_VSQLUPDATE
                              USING 'CLAIM_STATUS_HIST';
                          END IF;

                          IF v_V_DATE_CLOSED_DT >= v_V_DATE_OF_CLAIM THEN
                            --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_CLOSED_DT'
                            v_V_ERRORLOC := 'INSERT059';

                            EXECUTE IMMEDIATE v_VSQLINSERT
                              INTO v_V_CL_STATUS_ROW_ID
                              USING 'CLAIM_STATUS_HIST';

                            EXECUTE IMMEDIATE V_V_SQL
                              USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_CLOSEDCLAIM_CODE_ID, v_V_DATE_CLOSED_DT, v_V_DDSUSER;

                            EXECUTE IMMEDIATE v_VSQLUPDATE
                              USING 'CLAIM_STATUS_HIST';

                            v_V_DTTM_CLOSED := v_V_DATE_CLOSED;

                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  END IF;
                  ----- END LEVEL (@V_DATE_REOPENED = 0 AND @V_BCLOSEDCLAIM = 1)

                  IF v_V_NEWCLAIM = 0 THEN
                    IF (v_V_BCLOSEDCLAIM = 1) AND
                       ((v_V_DATE_STATUS_CHGD < v_V_DATE_CLOSED_DT) OR
                       (v_V_OLDSTATUS_ID <> v_V_CLAIM_STATUS_ID)) THEN
                      -----NOTE: TOC HANGE THE CRITERIA
                      -------NOTE: claim update case******** closed claim *********** datestatus changed < closed_dt and oldstatus and current status not equal then closed_dt in claim_status_hist
                      --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_CLOSED_DT'
                      v_V_ERRORLOC := 'INSERT050';

                      EXECUTE IMMEDIATE v_VSQLINSERT
                        INTO v_V_CL_STATUS_ROW_ID
                        USING 'CLAIM_STATUS_HIST';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_OPENCLAIM_CODE_ID, v_V_DATE_CLOSED_DT, v_V_DDSUSER;

                      EXECUTE IMMEDIATE v_VSQLUPDATE
                        USING 'CLAIM_STATUS_HIST';

                      v_V_DTTM_CLOSED := v_V_DATE_CLOSED;

                    END IF;

                    -------NOTE: claim update case******** open claim *********** datestatus changed < reopen date and oldstatus and current status not equal then reopen date in claim_status_hist
                    IF (v_V_BCLOSEDCLAIM = 1) AND
                       ((v_V_DATE_STATUS_CHGD < v_V_DATE_REOPENED) OR
                       (v_V_OLDSTATUS_ID <> v_V_CLAIM_STATUS_ID)) THEN
                      --PRINT 'INSERT INTO CLAIM_STATUS_HIST @V_DATE_CLOSED_DT'
                      v_V_ERRORLOC := 'INSERT059';

                      EXECUTE IMMEDIATE v_VSQLINSERT
                        INTO v_V_CL_STATUS_ROW_ID
                        USING 'CLAIM_STATUS_HIST';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_CL_STATUS_ROW_ID, v_V_CLAIM_ID, v_V_OPENCLAIM_CODE_ID, v_V_DATE_REOPENED, v_V_DDSUSER;

                      EXECUTE IMMEDIATE v_VSQLUPDATE
                        USING 'CLAIM_STATUS_HIST';
                    END IF;
                  END IF;

                  /*IF v_V_NEW_POLICY = 1 AND v_V_CARRIERFLAG = 0 THEN
                  ----BEGIN POLICY

                  v_V_ERRORLOC := 'INSERT062';

                  --PRINT 'INSERT POLICY IN RISKMASTER'
                  v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' || v_V_DBNAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                  EXECUTE IMMEDIATE v_VSQLINSERT INTO v_V_POLICY_ID USING 'POLICY';

                  v_V_SQL := 'INSERT INTO ' || v_V_DBNAME || 'POLICY(POLICY_ID, POLICY_NAME, POLICY_NUMBER, EFFECTIVE_DATE, EXPIRATION_DATE, DTTM_RCD_LAST_UPD, ';
                  v_V_SQL := v_V_SQL || 'UPDATED_BY_USER, ADDED_BY_USER, DTTM_RCD_ADDED) VALUES(';
                  v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, ';
                  v_V_SQL := v_V_SQL || ':6, :7, :8, ';
                  v_V_SQL := v_V_SQL || ':9)';

                  EXECUTE IMMEDIATE V_V_SQL USING v_V_POLICY_ID,v_V_POLICY_NUMBER, v_V_POLICY_NUMBER,v_V_POLICY_EFFECT_DATE,v_V_POLICY_EXPIRE_DATE,v_V_DATETIME,v_V_DDSUSER,v_V_DATETIME,v_V_DDSUSER ;

                  v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                  EXECUTE IMMEDIATE v_VSQLINSERT USING 'POLICY';
                  END IF;

                  ----END POLICY
                  */
                  --------------------------------------------------------------------------------------------------------

                  IF v_V_NEW_CLAIMXPOLICY = 1 AND v_V_CARRIERFLAG = 0 AND
                     V_iVarFinKey = 0 --JIRA#23899 KGUPTA31
                   THEN
                    ---- BEGIN POLICY
                    v_V_ERRORLOC := 'INSERT062';

                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                    EXECUTE IMMEDIATE v_VSQLINSERT
                      INTO v_V_ROW_ID
                      USING 'CLAIM_X_POLICY';

                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'CLAIM_X_POLICY(ROW_ID, CLAIM_ID, POLICY_ID) ';
                    v_V_SQL := v_V_SQL || 'VALUES(:1,:2,:3)';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_ROW_ID, v_V_CLAIM_ID, v_V_POLICY_ID;

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'CLAIM_X_POLICY';

                  END IF;

                  IF v_V_NEWCLAIM = 1 THEN
                    --------***************************** CLAIM INSERT QUERY STARTS ****************
                    ---- BEGIN NEW CLAIM

                    v_V_ERRORLOC := 'INSERT063';
                    v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                    'CLAIM(CLAIM_ID, CLAIM_NUMBER, LINE_OF_BUS_CODE, CLAIM_TYPE_CODE, CLAIM_STATUS_CODE, DATE_OF_CLAIM, ';
                    v_V_SQL      := v_V_SQL ||
                                    'TIME_OF_CLAIM, METHOD_CLOSED_CODE, DTTM_CLOSED, SERVICE_CODE, FILING_STATE_ID, PRIMARY_POLICY_ID, FILE_NUMBER, ';
                    v_V_SQL      := v_V_SQL ||
                                    'DTTM_RCD_ADDED, ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER, EVENT_ID, EVENT_NUMBER, ';
                    v_V_SQL      := v_V_SQL ||
                                    'COMMENTS, HTMLCOMMENTS, REPORTABLE_FLAG, PREVENTABLE_FLAG, IN_TRAFFIC_FLAG, PAYMNT_FROZEN_FLAG, OPEN_FLAG, ACCIDENT_DESC_CODE, DATE_RPTD_TO_RM ';

                    IF v_V_INSERTPLANINFO = 1 THEN
                      v_V_SQL := v_V_SQL ||
                                 ',DISABIL_FROM_DATE, DISABIL_TO_DATE, PLAN_ID, CLASS_ROW_ID, BENEFITS_START, BENEFITS_THROUGH, DIS_TYPE_CODE, BEN_CALC_PAY_START, ';
                      v_V_SQL := v_V_SQL ||
                                 'BEN_CALC_PAY_TO, TAX_FLAGS, PENSION_AMT, SS_AMT, OTHER_AMT';
                    END IF;

                    --JIRA 24634 knakra starts
                    IF v_iHmiFlag = 1 THEN
                      v_V_SQL := v_V_SQL ||
                                 ',INFO_REQ_DATE, PROOF_OF_LOSS_DATE, CLAIM_CAUSE_CODE';
                    END IF;
                    --JIRA 24634 knakra ends

                    --JIRA 29954 knakra starts
                    IF v_fVersionNum >= 16.4 THEN
                      v_V_SQL := v_V_SQL || ',CLAIM_CURR_CODE';
                    END IF;
                    --JIRA 29954 knakra ends

                    v_V_SQL := v_V_SQL || ', POLICY_LOB_CODE';
                    ---akumar523  jira 61584
                    IF v_fVersionNum >=19.1 THEN
                    v_V_SQL := v_V_SQL || ', REVIEW_STATUS_CODE)';
                    ELSE
                     v_V_SQL := v_V_SQL ||')';
                    END IF ;
                    ---akumar523 ends  jira 61584
                    v_V_SQL := v_V_SQL || 'VALUES(:1, :2, :3, ';
                    v_V_SQL := v_V_SQL || ':4, :5, :6, :7, :8, :9, ';
                    v_V_SQL := v_V_SQL ||
                               ':10, :11, :12, :13, :14,:15, :16, ';
                    v_V_SQL := v_V_SQL ||
                               ':17, :18, :19, :20, :21, :22 , :23, :24, :25, :26, ';
                    v_V_SQL := v_V_SQL || ':27, :28';

                    IF v_V_INSERTPLANINFO = 1 THEN
                      v_V_SQL := v_V_SQL || ',:29, :30, :31, :32, :33, ';
                      v_V_SQL := v_V_SQL ||
                                 ':34, :35, :36, :37, :38, :39, :40, :41';
                    END IF;

                    --JIRA 24634 knakra starts
                    IF v_iHmiFlag = 1 THEN
                      v_V_SQL := v_V_SQL || ',:43,:44,:45';
                    END IF;
                    --JIRA 24634 knakra ends

                    --JIRA 29954 KGUPTA31 starts
                    IF v_fVersionNum >= 16.4 THEN
                      v_V_SQL := v_V_SQL || ',:46';
                    END IF;
                    --JIRA 29954 KGUPTA31 ends

                    v_V_SQL := v_V_SQL || ', :42';
          
          ----AKUMAR523 STARTS jira 61584
                   IF v_fVersionNum >= 19.1 THEN
                    v_V_SQL := v_V_SQL || ', :47)';
                   ELSE 
                   v_V_SQL := v_V_SQL || ')';
                   END IF ;
          
        --  DBMS_OUTPUT.put_LINE('anand2-->'||v_V_SQL);
      --    DBMS_OUTPUT.put_LINE('v_V_INSERTPLANINFO-->'||v_V_INSERTPLANINFO);
       --   DBMS_OUTPUT.put_LINE('v_fVersionNum-->'||v_fVersionNum);
      --    DBMS_OUTPUT.put_LINE('v_iHmiFlag-->'||v_iHmiFlag);
          
                  IF v_V_INSERTPLANINFO = 1 THEN
                      --JIRA 24634 knakra starts
              		IF v_fVersionNum < 19.1  THEN ----akumar523 below this check old version functionality 
                  	   IF v_iHmiFlag = 1 THEN
                      		EXECUTE IMMEDIATE V_V_SQL
                      		USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, v_vInfoDateReq, v_vProofLossDate, v_iCauseCodeId, v_V_POLICY_LOB_ID;
						ELSE
                        --JIRA 29954 KGUPTA31 starts
                  			IF v_fVersionNum >= 16.4 AND v_iHmiFlag = 1 THEN
                      			EXECUTE IMMEDIATE V_V_SQL
                      			USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, v_vInfoDateReq, v_vProofLossDate, v_iCauseCodeId, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID;
                    		
							ELSE
                   				IF v_fVersionNum >= 16.4 AND v_iHmiFlag <> 1 THEN
                    				EXECUTE IMMEDIATE V_V_SQL
                    				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID;
                --JIRA 29954 KGUPTA31 ENDS
                    			ELSE
                    				EXECUTE IMMEDIATE V_V_SQL
                    				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, v_V_POLICY_LOB_ID;
                   				END IF;
                  			END IF;
                	    END IF;  
              		ELSE  -----akumar523 for new version rmA 
            			IF v_iHmiFlag=1 THEN
                			EXECUTE IMMEDIATE V_V_SQL
                			USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, v_vInfoDateReq, v_vProofLossDate, v_iCauseCodeId, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID,v_V_REVIEW_STATUS_CODE_ID;
            			ELSE
                			EXECUTE IMMEDIATE V_V_SQL
                			USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_DISABIL_FROM_DATE, v_V_DISABIL_TO_DATE, v_V_PLAN_ID, v_V_CLASSROW_ID, v_V_BENEFITS_START, v_V_BENEFITS_THROUGH, v_V_DIS_TYPE_ID, v_V_BEN_CALC_PAY_START, v_V_BEN_CALC_PAY_TO, v_V_TAXFLAGS, v_V_PENSION_AMT, v_V_SS_AMT, v_V_OTHER_AMT, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID, v_V_REVIEW_STATUS_CODE_ID;
                
            			END IF;
            
                    END IF;
             
                      --JIRA 24634 knakra ends
         		ELSE
                      --JIRA 24634 knakra starts
            		IF v_fVersionNum < 19.1  THEN 
             			IF v_iHmiFlag = 1 THEN
              				EXECUTE IMMEDIATE V_V_SQL
              				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_vInfoDateReq, v_vProofLossDate, v_iCauseCodeId, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID;  
             			ELSE
              				EXECUTE IMMEDIATE V_V_SQL
              				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_V_POLICY_LOB_ID;
             			END IF;
                      --JIRA 24634 knakra ends
            		ELSE  ---AKUMAR523 satrts jira 61584
            			IF v_iHmiFlag = 1 THEN
              				EXECUTE IMMEDIATE V_V_SQL
              				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM, v_vInfoDateReq, v_vProofLossDate, v_iCauseCodeId, V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID,v_V_REVIEW_STATUS_CODE_ID;  
             			ELSE
              				EXECUTE IMMEDIATE V_V_SQL
              				USING v_V_CLAIM_ID, v_V_CLAIM_NUMBER, v_V_CLAIM_LOB, v_V_CLAIM_TYPE_ID, v_V_CLAIM_STATUS_ID, v_V_DATE_OF_CLAIM, v_V_TIME_OF_CLAIM, v_V_CLOSURE_METHOD_ID, v_V_DTTM_CLOSED, v_V_SERVICE_ID, v_V_ACCIDENT_STATE_ID, v_V_POLICY_ID, v_V_FILE_NUMBER, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_EVENT_ID, v_V_EVENT_NUMBER, v_V_COMMENTS, v_V_COMMENTS, 0, v_V_ACC_PREV_FLAG_ID, 0, 0, 0, v_V_ACCIDENT_DESC_ID, v_V_DATE_RPTD_TO_RM,V_V_CURR_CODE_ID, v_V_POLICY_LOB_ID, v_V_REVIEW_STATUS_CODE_ID;
            			END IF;
            		END IF;  ----AKUMAR523 ends jira 61584
             	 END IF;    
                    v_V_ERRORLOC := 'V030';

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'CLAIM';
                    ----END NEW CLAIM
          ---AKUMAR523 STARTS  jira 61584
          ---CLAIM TYPE and REVIEW STATUS HISTORY INSERTION START
          IF v_fVersionNum >= 19.1  THEN 
          ----CLAIM TYPE 
            EXECUTE IMMEDIATE VSQLINSCLT
            INTO v_V_CLM_TYP_ROW_ID
            USING 'CLAIM_TYPE_HIST';

            DBMS_OUTPUT.put_LINE('neha_sql123-->'||v_V_CLAIM_TYP_REASON); 
            EXECUTE IMMEDIATE V_SQL_CLT
            USING v_V_CLM_TYP_ROW_ID, v_V_CLAIM_ID, v_V_CLAIM_TYPE_ID, v_V_CLAIM_TYPE_DT_CHA, v_V_DDSUSER, v_V_DATETIME,v_V_CLAIM_TYP_REASON;

            EXECUTE IMMEDIATE VSQLUPDCLT
            USING 'CLAIM_TYPE_HIST';
            ----REVIEW
            IF v_V_REVIEW_STATUS_CODE_ID <> 0  THEN
            
              EXECUTE IMMEDIATE VSQLINSREW
              INTO v_V_REW_TYP_ROW_ID
              USING 'CLAIM_REVIEW_HIST';

              EXECUTE IMMEDIATE V_SQL_REW
              USING v_V_REW_TYP_ROW_ID, v_V_CLAIM_ID, v_V_REVIEW_STATUS_CODE_ID, v_V_REV_STA_DT_CH, v_V_DDSUSER, v_V_REV_REASON;

              EXECUTE IMMEDIATE VSQLUPDREW
              USING 'CLAIM_REVIEW_HIST';
            END IF;  
          END IF;
          ---CLAIM TYPE and REVIEW STATUS HISTORY INSERTION END
          ---AKUMAR523 ENDS jira 61584
         ELSE
                    IF v_V_NEWCLAIM = 0 THEN
                      ----************************* CLAIM UPDATE QUERY ********************************************************
                      ----BEGIN EXISTING CLAIM

                      v_V_ERRORLOC := 'INSERT064';

                      v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                 'CLAIM SET CLAIM_ID =' || '''' ||
                                 v_V_CLAIM_ID || '''';
                      v_V_SQL := v_V_SQL || ', DATE_RPTD_TO_RM = ' || '''' ||
                                 v_V_DATE_RPTD_TO_RM || '''';
                      v_V_SQL := v_V_SQL || ', CLAIM_STATUS_CODE = ' || '''' ||
                                 v_V_CLAIM_STATUS_ID || '''';
                      v_V_SQL := v_V_SQL || ', OPEN_FLAG = ' ||
                                 v_V_OPEN_FLAG_ID;
                      v_V_SQL := v_V_SQL || ', METHOD_CLOSED_CODE = ' ||
                                 v_V_CLOSURE_METHOD_ID;
                      v_V_SQL := v_V_SQL || ', DATE_OF_CLAIM = ' || '''' ||
                                 v_V_DATE_OF_CLAIM || '''';
                      v_V_SQL := v_V_SQL || ', TIME_OF_CLAIM = ' || '''' ||
                                 v_V_TIME_OF_CLAIM || '''';
                      v_V_SQL := v_V_SQL || ', CLAIM_TYPE_CODE =' ||
                                 v_V_CLAIM_TYPE_ID;
                      v_V_SQL := v_V_SQL || ', FILING_STATE_ID = ' ||
                                 v_V_ACCIDENT_STATE_ID;
                      v_V_SQL := v_V_SQL || ', DTTM_RCD_LAST_UPD = ' || '''' ||
                                 v_V_DATETIME || '''';
                      v_V_SQL := v_V_SQL || ', UPDATED_BY_USER = ' || '''' ||
                                 v_V_DDSUSER || '''';
                      v_V_SQL := v_V_SQL || ', PREVENTABLE_FLAG = ' ||
                                 v_V_ACC_PREV_FLAG_ID;
                      IF v_V_DATE_CLOSED_DT IS NOT NULL AND
                         v_V_DATE_CLOSED IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', DTTM_CLOSED = ' || '''' ||
                                   v_V_DTTM_CLOSED || ''''; ----REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120),'-',''), ':', ''),' ','')
                      END IF;

                      IF v_V_COMMENTS IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', COMMENTS = ' || '''' ||
                                   v_V_COMMENTS || '''';
                        v_V_SQL := v_V_SQL || ', HTMLCOMMENTS = ' || '''' ||
                                   v_V_COMMENTS || '''';
                      END IF;

                      IF v_V_SERVICE_ID > 0 THEN
                        v_V_SQL := v_V_SQL || ', SERVICE_CODE = ' ||
                                   v_V_SERVICE_ID;
                      END IF;

                      IF v_V_POLICY_ID > 0 THEN
                        v_V_SQL := v_V_SQL || ', PRIMARY_POLICY_ID = ' ||
                                   v_V_POLICY_ID;
                      END IF;

                      IF v_V_ACCIDENT_DESC_ID > 0 THEN
                        v_V_SQL := v_V_SQL || ', ACCIDENT_DESC_CODE = ' ||
                                   v_V_ACCIDENT_DESC_ID;
                      END IF;

                      --JIRA 24634 knakra starts
                      IF v_iHmiFlag = 1 AND v_vProofLossDate IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', PROOF_OF_LOSS_DATE = ' ||
                                   v_vProofLossDate;
                      END IF;

                      if v_iHmiFlag = 1 AND v_vInfoDateReq IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', INFO_REQ_DATE = ' ||
                                   v_vInfoDateReq;
                      END IF;

                      IF v_iHmiFlag = 1 AND v_iCauseCodeId > 0 THEN
                        v_V_SQL := v_V_SQL || ', CLAIM_CAUSE_CODE = ' ||
                                   v_iCauseCodeId;
                      END IF;
                      --JIRA 24634 knakra ends

                      IF (v_V_RECORD_TYPE = 'D' AND v_V_CARRIERFLAG = 0) OR
                         (v_V_RECORD_TYPE = 'D' AND v_iVarFinKey <> 0) THEN
                        ---- CHECK GBSHORTTERMDIS FLAG gbShortTermDis
                        v_V_SQL := v_V_SQL || ', DISABIL_FROM_DATE =' || '''' ||
                                   v_V_DISABIL_FROM_DATE || '''';
                        v_V_SQL := v_V_SQL || ', DISABIL_TO_DATE = ' || '''' ||
                                   v_V_DISABIL_TO_DATE || '''';
                        v_V_SQL := v_V_SQL || ', PLAN_ID = ' || v_V_PLAN_ID;
                        v_V_SQL := v_V_SQL || ', CLASS_ROW_ID =' ||
                                   v_V_CLASSROW_ID;
                        v_V_SQL := v_V_SQL || ', BENEFITS_START =' || '''' ||
                                   v_V_BENEFITS_START || '''';
                        v_V_SQL := v_V_SQL || ', BENEFITS_THROUGH =' || '''' ||
                                   v_V_BENEFITS_THROUGH || '''';
                        v_V_SQL := v_V_SQL || ', BEN_CALC_PAY_TO = ' || '''' ||
                                   v_V_BEN_CALC_PAY_TO || '''';
                        v_V_SQL := v_V_SQL || ', TAX_FLAGS = ' ||
                                   v_V_TAXFLAGS;
                        v_V_SQL := v_V_SQL || ', PENSION_AMT = ' ||
                                   v_V_PENSION_AMT;
                        v_V_SQL := v_V_SQL || ', SS_AMT = ' || v_V_SS_AMT;
                        v_V_SQL := v_V_SQL || ', OTHER_AMT = ' ||
                                   v_V_OTHER_AMT;
                        v_V_SQL := v_V_SQL || ', BEN_CALC_PAY_START = ' || '''' ||
                                   v_V_BENEFITS_START || '''';

                        IF v_V_DIS_TYPE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DIS_TYPE_CODE = ' ||
                                     v_V_DIS_TYPE_ID;
                        END IF;
                      END IF;
					  IF v_fVersionNum >= 19.1  THEN -----AKUMAR523 STARTS 
						 v_V_SQL := v_V_SQL || ', REVIEW_STATUS_CODE = ' ||
                                    v_V_REVIEW_STATUS_CODE_ID;      ----AKUMAR523 ENDS 
					  END IF;
                      v_V_SQL := v_V_SQL || ' WHERE CLAIM_ID = ' ||
                                 v_V_CLAIM_ID;
                      --PRINT @V_SQL
                      EXECUTE IMMEDIATE V_V_SQL;
                    END IF;
          
					---akumar523 jira 61584
					IF v_fVersionNum >= 19.1  THEN 
					----CLAIM TYPE 
  
						IF v_V_CLTP_CHA=1 THEN
							EXECUTE IMMEDIATE VSQLINSCLT
							INTO v_V_CLM_TYP_ROW_ID
							USING 'CLAIM_TYPE_HIST';

							EXECUTE IMMEDIATE V_SQL_CLT
							USING v_V_CLM_TYP_ROW_ID, v_V_CLAIM_ID, v_V_CLAIM_TYPE_ID, v_V_CLAIM_TYPE_DT_CHA, v_V_DDSUSER, v_V_DATETIME,v_V_CLAIM_TYP_REASON;

							EXECUTE IMMEDIATE VSQLUPDCLT
							USING 'CLAIM_TYPE_HIST';
						END IF;  
					----REVIEW
						IF v_V_REWTP_CHA =1  THEN
            
						   EXECUTE IMMEDIATE VSQLINSREW
						   INTO v_V_REW_TYP_ROW_ID
						   USING 'CLAIM_REVIEW_HIST';

						   EXECUTE IMMEDIATE V_SQL_REW
						   USING v_V_REW_TYP_ROW_ID, v_V_CLAIM_ID, v_V_REVIEW_STATUS_CODE_ID, v_V_REV_STA_DT_CH, v_V_DDSUSER, v_V_REV_REASON;

						   EXECUTE IMMEDIATE VSQLUPDREW
						   USING 'CLAIM_REVIEW_HIST';
					  END IF;  
				END IF;
          ---CLAIM TYPE and REVIEW STATUS HISTORY INSERTION END
          ---AKUMAR523 ENDS 
          
          
           END IF;

                  ----END EXISTING CLAIM
                  IF v_V_RECORD_TYPE = 'W' OR v_V_RECORD_TYPE = 'D' OR
                     (v_V_RECORD_TYPE = 'G' AND v_V_EMPLOYEE_ID IS NOT NULL) OR
                     (v_V_RECORD_TYPE = 'H' AND v_V_EMPLOYEE_ID IS NOT NULL) OR --JIRA 24634 knakra
                     (v_V_RECORD_TYPE = 'V' AND v_V_EMPLOYEE_ID IS NOT NULL) THEN
                    ----EMPLOYEE BEGIN
                    v_V_ERRORLOC := 'INSERT0065A';
                    IF (v_CheckCreateNewDepartment = 1 AND
                       v_V_EMP_DEPT_ID = 0 OR
                       v_V_DELETED_FLAG_EMP_DEPT = -1) THEN
                      v_DDS_ORG_HIERARCHY_TYPE := DDS_ORG_HIERARCHY_TYPE(v_P_JOBID,
                                                                         v_V_DA_ROW_ID,
                                                                         v_V_DEPARTMENT,
                                                                         v_V_LOCATION,
                                                                         v_V_DIVISION,
                                                                         v_V_COMPANY,
                                                                         v_V_DEPARTMENT_DESC,
                                                                         v_V_LOCATION_DESC,
                                                                         v_V_DIVISION_DESC,
                                                                         v_V_COMPANY_DESC);

                      --PRINT 'ORG HIERARCHY IMPORT STARTS'
                      DDS_PROCESSORG_HIERARCHY(v_DDS_ORG_HIERARCHY_TYPE,
                                               v_P_JOBID,
                                               v_V_DA_ROW_ID,
                                               v_V_DBNAME,
                                               'CLAIM_NUMBER',
                                               v_V_CLAIM_NUMBER,
                                               v_V_DEPARTMENT_ID);

                      IF v_V_EMP_DEPT_ID < 0 THEN
                        v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                        GOTO FETCHNEXT; ---- IF ANY EXCEPTION OCCURS IN PROCESS ORG HIERARCHY
                      END IF;
                    END IF;

                    IF v_V_NEW_EMP = 1 THEN
                      ---- BEGIN NEW EMP

                      v_V_ERRORLOC := 'INSERT0065';

                      v_V_ERRORLOC := 'INSERT065';
                      v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                      'EMPLOYEE(EMPLOYEE_EID, EMPLOYEE_NUMBER, DATE_HIRED, DATE_OF_DEATH, WEEKLY_RATE, HOURLY_RATE, ';
                      v_V_SQL      := v_V_SQL ||
                                      'WEEKLY_HOURS, DRIVERS_LIC_NO, DATE_DRIVERSLICEXP, POSITION_CODE, NCCI_CLASS_CODE, DRIVERSLICTYPECODE, MARITAL_STAT_CODE, ';
                      v_V_SQL      := v_V_SQL ||
                                      ' WORK_MON_FLAG, WORK_TUE_FLAG, WORK_WED_FLAG, WORK_THU_FLAG, WORK_FRI_FLAG, WORK_SAT_FLAG, WORK_SUN_FLAG, ';
                      v_V_SQL      := v_V_SQL ||
                                      'DRIVLIC_RSTRCTCODE, DEPT_ASSIGNED_EID, ACTIVE_FLAG, MONTHLY_RATE, ELIG_DIS_BEN_FLAG, DIS_OPTION_CODE, INSURABLE_FLAG) VALUES( ';
                      v_V_SQL      := v_V_SQL ||
                                      ' :1, :2, :3, :4, :5, :6, :7, ';
                      v_V_SQL      := v_V_SQL ||
                                      ' :8, :9, :10, :11, :12,:13, ';
                      v_V_SQL      := v_V_SQL ||
                                      ' :14, :15,:16, :17, :18, :19, :20, :21, :22, :23, :24, :25, :26, :27 )';

                      --PRINT 'EMPLOYEE SQL IS: '
                      --PRINT @V_SQL
                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_CLAIMANT_EID, v_V_EMPLOYEE_NUMBER, v_V_DATE_OF_HIRE, v_V_DATE_OF_DEATH, v_V_WEEKLY_WAGE_RATE, v_V_HOURLY_WAGE_RATE, v_V_WEEKLY_HOURS, v_V_LICENSE_NUMBER, v_V_LICENSE_EXPIR_DATE, v_V_OCCUPATION_ID, v_V_NCCI_CLASS_CODE_ID, v_V_LICENSE_TYPE_ID, v_V_MARITAL_STATUS_ID, v_V_WORK_SUN, v_V_WORK_MON, v_V_WORK_TUE, v_V_WORK_WED, v_V_WORK_THU, v_V_WORK_FRI, v_V_WORK_SAT, v_V_LICENSE_RESTRICT_ID, v_V_EMP_DEPT_ID, v_V_ACTIVE_FLAG_ID, v_V_MONTHLY_RATE, v_V_ELIG_DIS_BEN_FLAG_ID, v_V_DIS_OPTION_CODE_ID, 0;

                      v_V_EMPLOYEE_EID := v_V_CLAIMANT_EID;
                      ----END NEW EMP
                    ELSE
                      IF v_V_NEW_EMP = 0 THEN
                        ---- BEGIN EXISTING EMP

                        v_V_ERRORLOC := 'INSERT066';

                        v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                   'EMPLOYEE SET EMPLOYEE_EID = ' ||
                                   v_V_EMPLOYEE_EID;

                        IF v_V_DATE_OF_HIRE IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', DATE_HIRED = ' || '''' ||
                                     v_V_DATE_OF_HIRE || '''';
                        END IF;

                        IF v_V_WEEKLY_WAGE_RATE IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', WEEKLY_RATE = ' ||
                                     v_V_WEEKLY_WAGE_RATE;
                        END IF;

                        IF v_V_HOURLY_WAGE_RATE IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', HOURLY_RATE = ' ||
                                     v_V_HOURLY_WAGE_RATE;
                        END IF;

                        IF v_V_WEEKLY_HOURS IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', WEEKLY_HOURS = ' ||
                                     v_V_WEEKLY_HOURS;
                        END IF;

                        IF v_V_DATE_OF_DEATH IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', DATE_OF_DEATH = ' || '''' ||
                                     v_V_DATE_OF_DEATH || '''';
                        END IF;

                        IF v_V_LICENSE_NUMBER IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', DRIVERS_LIC_NO = ' || '''' ||
                                     v_V_LICENSE_NUMBER || '''';
                        END IF;

                        IF v_V_LICENSE_EXPIR_DATE IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', DATE_DRIVERSLICEXP = ' || '''' ||
                                     v_V_LICENSE_EXPIR_DATE || '''';
                        END IF;

                        IF v_V_OCCUPATION_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', POSITION_CODE = ' ||
                                     v_V_OCCUPATION_ID;
                        END IF;

                        IF v_V_NCCI_CLASS_CODE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', NCCI_CLASS_CODE = ' ||
                                     v_V_NCCI_CLASS_CODE_ID;
                        END IF;

                        IF v_V_LICENSE_TYPE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DRIVERSLICTYPECODE = ' ||
                                     v_V_LICENSE_TYPE_ID;
                        END IF;

                        IF v_V_LICENSE_RESTRICT_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DRIVLIC_RSTRCTCODE = ' ||
                                     v_V_LICENSE_RESTRICT_ID;
                        END IF;

                        IF v_V_EMP_DEPT_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DEPT_ASSIGNED_EID = ' ||
                                     v_V_EMP_DEPT_ID;
                        END IF;

                        IF v_V_ACTIVE_FLAG_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', ACTIVE_FLAG = ' ||
                                     v_V_ACTIVE_FLAG_ID;
                        END IF;

                        IF v_V_DIS_OPTION_CODE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DIS_OPTION_CODE = ' ||
                                     v_V_DIS_OPTION_CODE_ID;
                        END IF;

                        IF v_V_MONTHLY_RATE > 0 THEN
                          v_V_SQL := v_V_SQL || ', MONTHLY_RATE = ' ||
                                     v_V_MONTHLY_RATE;
                        END IF;

                        IF v_V_ELIG_DIS_BEN_FLAG_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', ELIG_DIS_BEN_FLAG = ' ||
                                     v_V_ELIG_DIS_BEN_FLAG_ID;
                        END IF;

                        IF (V_V_RECORD_TYPE = 'D' AND V_V_CARRIERFLAG = 0 AND
                           V_iVarFinKey = 0) OR
                           (V_V_RECORD_TYPE = 'D' AND V_iVarFinKey <> 0) --JIRA 23899 KGUPTA31
                         THEN
                          IF V_V_DIS_OPTION_CODE_ID > 0 THEN
                            V_V_SQL := V_V_SQL || ', DIS_OPTION_CODE = ' ||
                                       v_V_DIS_OPTION_CODE_ID;
                          END IF;
                          IF V_V_MONTHLY_RATE > 0 THEN
                            V_V_SQL := V_V_SQL || ', MONTHLY_RATE = ' ||
                                       v_V_MONTHLY_RATE;
                          END IF;
                          IF V_V_ELIG_DIS_BEN_FLAG_ID > 0 then
                            V_V_SQL := V_V_SQL || ', ELIG_DIS_BEN_FLAG = ' ||
                                       v_V_ELIG_DIS_BEN_FLAG_ID;
                          end if;
                        END IF;

                        v_V_SQL := v_V_SQL || ' WHERE EMPLOYEE_EID = ' ||
                                   v_V_EMPLOYEE_EID;

                        execute immediate v_v_sql;

                      END IF;

                    END IF;

                    ---- END EXISTING EMP
                    IF v_V_INSERT_EMPXDEP = 1 AND v_V_EMPLOYEE_EID > 0 THEN
                      v_V_ERRORLOC := 'INSERT067';

                      v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                 'EMP_X_DEPENDENT(EMP_DEP_ROW_ID, EMPLOYEE_EID, DEPENDENT_EID, HEALTH_PLAN_FLAG, RELATION_CODE, DEPENDENT_ROW_ID) VALUES( ';
                      v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6 )';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_EMP_DEP_ROW_ID, v_V_EMPLOYEE_EID, v_V_DEPENDENT_EID, 0, 0, 0;

                      v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                      'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                      EXECUTE IMMEDIATE v_VSQLINSERT
                        USING 'EMP_X_DEPENDENT';
                    END IF;
                  END IF;

                  ----EMPLOYEE ENDS
                  IF v_V_EMP_PERSON = 1 THEN

                    IF v_V_NEW_PI = 1 THEN
                      ----BEGIN NEW PI

                      v_V_ERRORLOC := 'INSERT068';

                      v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                 'PERSON_INVOLVED(PI_ROW_ID, EVENT_ID, PI_EID, EMPLOYEE_NUMBER, DEPT_ASSIGNED_EID, DATE_OF_DEATH, DATE_HIRED, WEEKLY_RATE, ';
                      v_V_SQL := v_V_SQL ||
                                 'MARITAL_STAT_CODE, POSITION_CODE, NCCI_CLASS_CODE, DRIVERSLICTYPECODE, DRIVLIC_RSTRCTCODE, DRIVERS_LIC_NO, PI_TYPE_CODE, ';
                      v_V_SQL := v_V_SQL ||
                                 'OSHA_ACC_DESC, ILLNESS_CODE, DISABILITY_CODE, OSHA_REC_FLAG, STD_DISABIL_TYPE, ACTIVE_FLAG, ';
                      v_V_SQL := v_V_SQL ||
                                 'LOST_WORK_FLAG, WORK_MON_FLAG, WORK_TUE_FLAG, WORK_WED_FLAG, WORK_THU_FLAG, WORK_FRI_FLAG, WORK_SAT_FLAG, WORK_SUN_FLAG, ';
                      --JIRA 24634 knakra starts
                      v_V_SQL := v_V_SQL ||
                                 'MONTHLY_RATE, WEEKLY_HOURS, HOURLY_RATE, ELIG_DIS_BEN_FLAG, DIS_OPTION_CODE, ROLE_TABLE_ID, PARENT_ROW_ID, PARENT_TABLE_NAME';
                      IF v_iHmiFlag = 1 THEN
                        v_V_SQL := v_V_SQL || ', BENEFICIARY_CODE';
                      END IF;
                      v_V_SQL := v_V_SQL || ') VALUES( ';
                      --JIRA 24634 knakra ends
                      v_V_SQL := v_V_SQL || ' :1, :2, :3, :4, :5 ';
                      v_V_SQL := v_V_SQL || ', :6,:7, :8, :9, :10';
                      v_V_SQL := v_V_SQL || ', :11, :12, :13, :14';
                      v_V_SQL := v_V_SQL || ', :15, :16, :17, :18, :19';
                      v_V_SQL := v_V_SQL || ', :20, :21';
                      v_V_SQL := v_V_SQL ||
                                 ', :22, :23,:24,:25,:26,:27,:28,:29';
                      --JIRA 24634 knakra starts
                      v_V_SQL := v_V_SQL ||
                                 ', :30, :31, :32, :33, :34, :35, :36, :37';
                      IF v_iHmiFlag = 1 THEN
                        v_V_SQL := v_V_SQL || ', :38';
                      END IF;
                      v_V_SQL := v_V_SQL || ')';
                      --JIRA 24634 knakra ends

                      --PRINT 'PERSON INVOLVED SQL IS : '
                      --PRINT @V_SQL

                      --JIRA 24634 knakra starts
                      IF v_iHmiFlag = 1 THEN
                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_PI_ROW_ID, v_V_EVENT_ID, v_V_CLAIMANT_EID, v_V_EMPLOYEE_NUMBER, v_V_EMP_DEPT_ID, v_V_DATE_OF_DEATH, v_V_DATE_OF_HIRE, v_V_WEEKLY_WAGE_RATE, v_V_MARITAL_STATUS_ID, v_V_OCCUPATION_ID, v_V_NCCI_CLASS_CODE_ID, v_V_LICENSE_TYPE_ID, v_V_LICENSE_RESTRICT_ID, v_V_LICENSE_NUMBER, v_V_PI_TYPE_CODE_ID, v_V_OSHA_ACC_DESC, v_V_ILLNESS_CODE_ID, v_V_DISABILITY_CODE_ID, v_V_OSHA_RECORDABLE_ID, v_V_STD_DISABIL_TYPE_ID, v_V_ACTIVE_FLAG_ID, 0, v_V_WORK_SUN, v_V_WORK_MON, v_V_WORK_TUE, v_V_WORK_WED, v_V_WORK_THU, v_V_WORK_FRI, v_V_WORK_SAT, v_V_MONTHLY_RATE, v_V_WEEKLY_HOURS, v_V_HOURLY_WAGE_RATE, v_V_ELIG_DIS_BEN_FLAG_ID, v_V_DIS_OPTION_CODE_ID, v_V_ROLE_TABLE_ID, v_V_PARENT_ROW_ID, v_V_PARENT_TABLE_NAME, v_iBenCodeId;
                      ELSIF v_iHmiFlag IS NULL OR v_iHmiFlag = 0 THEN
                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_PI_ROW_ID, v_V_EVENT_ID, v_V_CLAIMANT_EID, v_V_EMPLOYEE_NUMBER, v_V_EMP_DEPT_ID, v_V_DATE_OF_DEATH, v_V_DATE_OF_HIRE, v_V_WEEKLY_WAGE_RATE, v_V_MARITAL_STATUS_ID, v_V_OCCUPATION_ID, v_V_NCCI_CLASS_CODE_ID, v_V_LICENSE_TYPE_ID, v_V_LICENSE_RESTRICT_ID, v_V_LICENSE_NUMBER, v_V_PI_TYPE_CODE_ID, v_V_OSHA_ACC_DESC, v_V_ILLNESS_CODE_ID, v_V_DISABILITY_CODE_ID, v_V_OSHA_RECORDABLE_ID, v_V_STD_DISABIL_TYPE_ID, v_V_ACTIVE_FLAG_ID, 0, v_V_WORK_SUN, v_V_WORK_MON, v_V_WORK_TUE, v_V_WORK_WED, v_V_WORK_THU, v_V_WORK_FRI, v_V_WORK_SAT, v_V_MONTHLY_RATE, v_V_WEEKLY_HOURS, v_V_HOURLY_WAGE_RATE, v_V_ELIG_DIS_BEN_FLAG_ID, v_V_DIS_OPTION_CODE_ID, v_V_ROLE_TABLE_ID, v_V_PARENT_ROW_ID, v_V_PARENT_TABLE_NAME; ----JIRA RMA-22720 v_V_ROLE_TABLE_ID REPLACED v_V_TABLE_ID ----
                      END IF;
                      --JIRA 24634 knakra ends
                      v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                      'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                      EXECUTE IMMEDIATE v_VSQLINSERT
                        USING 'PERSON_INVOLVED';

                      ---- END NEW PI
                    ELSE
                      IF v_V_NEW_PI = 0 THEN
                        ---- BEGIN EXISTING PI

                        v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                   'PERSON_INVOLVED SET PI_ROW_ID = ' ||
                                   v_V_PI_ROW_ID;

                        v_V_ERRORLOC := 'INSERT073';
                        --JIRA 24634 knakra starts
                        IF v_iHmiFlag = 1 AND v_iBenCodeId > 0 THEN
                          v_V_SQL := v_V_SQL || ', BENEFICIARY_CODE = ' ||
                                     v_iBenCodeId;
                        END IF;
                        --JIRA 24634 knakra ends

                        IF v_V_ILLNESS_CODE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', ILLNESS_CODE = ' ||
                                     v_V_ILLNESS_CODE_ID;
                        END IF;

                        IF v_V_DISABILITY_CODE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', DISABILITY_CODE = ' ||
                                     v_V_DISABILITY_CODE_ID;
                        END IF;

                        IF v_V_OSHA_RECORDABLE_ID > 0 THEN
                          v_V_SQL := v_V_SQL || ', OSHA_REC_FLAG = ' ||
                                     v_V_OSHA_RECORDABLE_ID;
                          IF v_V_OSHA_ACC_DESC IS NOT NULL THEN
                            v_V_SQL := v_V_SQL || ', OSHA_ACC_DESC = ' || '''' ||
                                       v_V_OSHA_ACC_DESC || '''';
                          END IF;
                        END IF;

                        v_V_SQL := v_V_SQL || ' WHERE PI_ROW_ID = ' ||
                                   v_V_PI_ROW_ID;

                        EXECUTE IMMEDIATE V_V_SQL;

                        --PRINT 'DDDDDDDDDDDDDDDDDDDDDDDDDD'
                        --PRINT @V_SQL
                      END IF; --- END EXISTING PI
                    END IF; ---- PI IF ENDS

                    v_vReqColumns := '';

                    IF v_V_BODY_PART_1_ID > 0 OR v_V_BODY_PART_2_ID > 0 OR
                       v_V_BODY_PART_3_ID > 0 OR v_V_BODY_PART_4_ID > 0 OR
                       v_V_BODY_PART_5_ID > 0 THEN
                      v_vReqColumns := 'BODY_PART_1|BODY_PART_2|BODY_PART_3|BODY_PART_4|BODY_PART_5|';
                    END IF;

                    IF v_V_INJURY_CODE_1_ID > 0 OR v_V_INJURY_CODE_2_ID > 0 OR
                       v_V_INJURY_CODE_3_ID > 0 OR v_V_INJURY_CODE_4_ID > 0 OR
                       v_V_INJURY_CODE_5_ID > 0 THEN
                      v_vReqColumns := v_vReqColumns ||
                                       'INJURY_CODE_1|INJURY_CODE_2|INJURY_CODE_3|INJURY_CODE_4|INJURY_CODE_5|';
                    END IF;

                    IF v_V_ICD10_1_ID > 0 OR v_V_ICD10_2_ID > 0 OR v_V_ICD10_3_ID > 0 OR v_V_ICD10_4_ID > 0 OR v_V_ICD10_5_ID > 0  OR v_V_DIAGNOSIS_1_ID > 0 OR v_V_DIAGNOSIS_2_ID > 0 OR
                       v_V_DIAGNOSIS_3_ID > 0 OR v_V_DIAGNOSIS_4_ID > 0 OR
                       v_V_DIAGNOSIS_5_ID > 0 THEN
                      v_vReqColumns := v_vReqColumns ||
                                       'ICD10_1|ICD10_2|ICD10_3|ICD10_4|ICD10_5|DIAGNOSIS_1|DIAGNOSIS_2|DIAGNOSIS_3|DIAGNOSIS_4|DIAGNOSIS_5|';
                    END IF;

                    WHILE INSTR(v_vReqColumns, '|', 1) > 0 --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
                     LOOP
                      -- WHILE STARTS

                      v_iPos1       := INSTR(v_vReqColumns, '|', 1);
                      v_vColName1   := SUBSTR(v_vReqColumns,
                                              1,
                                              INSTR(v_vReqColumns, '|', 1) - 1);
                      v_vReqColumns := SUBSTR(v_vReqColumns,
                                              LENGTH(SUBSTR(v_vReqColumns,
                                                            1,
                                                            INSTR(v_vReqColumns,
                                                                  '|',
                                                                  1))) + 1,
                                              LENGTH(v_vReqColumns));
                      v_V_CODE_ID_R := (CASE WHEN v_vColName1 = 'BODY_PART_1' THEN v_V_BODY_PART_1_ID WHEN v_vColName1 = 'BODY_PART_2' THEN v_V_BODY_PART_2_ID WHEN v_vColName1 = 'BODY_PART_3' THEN v_V_BODY_PART_3_ID WHEN v_vColName1 = 'BODY_PART_4' THEN v_V_BODY_PART_4_ID WHEN v_vColName1 = 'BODY_PART_5' THEN v_V_BODY_PART_5_ID WHEN v_vColName1 = 'INJURY_CODE_1' THEN v_V_INJURY_CODE_1_ID WHEN v_vColName1 = 'INJURY_CODE_2' THEN v_V_INJURY_CODE_2_ID WHEN v_vColName1 = 'INJURY_CODE_3' THEN v_V_INJURY_CODE_3_ID WHEN v_vColName1 = 'INJURY_CODE_4' THEN v_V_INJURY_CODE_4_ID WHEN v_vColName1 = 'INJURY_CODE_5' THEN v_V_INJURY_CODE_5_ID WHEN v_vColName1 = 'ICD10_1' THEN v_V_ICD10_1_ID WHEN v_vColName1 = 'ICD10_2' THEN v_V_ICD10_2_ID WHEN v_vColName1 = 'ICD10_3' THEN v_V_ICD10_3_ID WHEN v_vColName1 = 'ICD10_4' THEN v_V_ICD10_4_ID WHEN v_vColName1 = 'ICD10_5' THEN v_V_ICD10_5_ID  WHEN v_vColName1 = 'DIAGNOSIS_1' THEN v_V_DIAGNOSIS_1_ID WHEN v_vColName1 = 'DIAGNOSIS_2' THEN v_V_DIAGNOSIS_2_ID WHEN v_vColName1 = 'DIAGNOSIS_3' THEN v_V_DIAGNOSIS_3_ID WHEN v_vColName1 = 'DIAGNOSIS_4' THEN v_V_DIAGNOSIS_4_ID WHEN v_vColName1 = 'DIAGNOSIS_5' THEN v_V_DIAGNOSIS_5_ID END);

                      IF v_V_CODE_ID_R > 0 THEN
                        IF v_vColName1 LIKE 'BODY_PART%' THEN
                          v_V_ERRORLOC := 'INSERT074';

                          v_V_SQL := 'SELECT BODY_PART_CODE FROM ' ||
                                     v_V_DBNAME ||
                                     'PI_X_BODY_PART WHERE PI_ROW_ID = :1 AND BODY_PART_CODE = :2';
                          BEGIN
                            EXECUTE IMMEDIATE v_V_SQL
                              INTO v_V_CODE_ID_RMDB
                              USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                          EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                              v_V_CODE_ID_RMDB := 0;
                          END;
                          IF v_V_CODE_ID_RMDB = 0 THEN
                            v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                       'PI_X_BODY_PART(PI_ROW_ID, BODY_PART_CODE) VALUES( ';
                            v_V_SQL := v_V_SQL || ':1, :2)';
                            EXECUTE IMMEDIATE v_V_SQL
                              USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                          END IF;
                          --PRINT 'iNSERT INTO PI_X_BODY_PART'
                        ELSE
                          IF v_vColName1 LIKE 'INJURY_CODE%' AND
                             v_V_ILLNESS_CODE_ID = 0 THEN
                            BEGIN
                              v_V_ERRORLOC := 'INSERT075';

                              BEGIN
                                v_V_SQL := 'SELECT INJURY_CODE FROM ' ||
                                           v_V_DBNAME ||
                                           'PI_X_INJURY WHERE PI_ROW_ID = :1 AND INJURY_CODE = :2';
                                EXECUTE IMMEDIATE v_V_SQL
                                  INTO v_V_CODE_ID_RMDB
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                              EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                  v_V_CODE_ID_RMDB := 0;
                              END;

                              IF v_V_CODE_ID_RMDB = 0 THEN
                                v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                           'PI_X_INJURY(PI_ROW_ID, INJURY_CODE) VALUES( ';
                                v_V_SQL := v_V_SQL || ':1, :2)';
                                EXECUTE IMMEDIATE v_V_SQL
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                              END IF;

                            END;
							--PRINT 'iNSERT INTO PI_X_INJURY'
							--asharma590 start jira 74846
							ELSE
                          IF v_vColName1 LIKE 'ICD10%' THEN
                            BEGIN
                              v_V_ERRORLOC := 'INSERT076A';

                              BEGIN
                                v_V_SQL := 'SELECT DIAGNOSIS_CODE_ICD10 FROM ' ||
                                           v_V_DBNAME ||
                                           'PI_X_DIAGNOSISICD10 WHERE PI_ROW_ID = :1 AND DIAGNOSIS_CODE_ICD10 = :2';
                                EXECUTE IMMEDIATE v_V_SQL
                                  INTO v_V_CODE_ID_RMDB
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                              EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                  v_V_CODE_ID_RMDB := 0;
                              END;

                              IF v_V_CODE_ID_RMDB = 0 THEN
                                v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                           'PI_X_DIAGNOSISICD10(PI_ROW_ID, DIAGNOSIS_CODE_ICD10) VALUES( ';
                                v_V_SQL := v_V_SQL || ':1, :2)';
                                EXECUTE IMMEDIATE v_V_SQL
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                              END IF;

                            END;
							--asharma590 ends jira  74846
                            
                          ELSE
                            IF v_vColName1 LIKE 'DIAGNOSIS%' THEN
                              v_V_ERRORLOC := 'INSERT076';
                              v_V_SQL      := 'SELECT DIAGNOSIS_CODE FROM ' ||
                                              v_V_DBNAME ||
                                              'PI_X_DIAGNOSIS WHERE PI_ROW_ID = :1 AND DIAGNOSIS_CODE = :2';
                              BEGIN
                                EXECUTE IMMEDIATE v_V_SQL
                                  INTO v_V_CODE_ID_RMDB
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;
                              EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                  v_V_CODE_ID_RMDB := 0;
                              END;

                              IF v_V_CODE_ID_RMDB = 0 THEN
                                v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                           'PI_X_DIAGNOSIS(PI_ROW_ID, DIAGNOSIS_CODE) VALUES( ';
                                v_V_SQL := v_V_SQL || ':1, :2 )';
                                EXECUTE IMMEDIATE v_V_SQL
                                  USING v_V_PI_ROW_ID, v_V_CODE_ID_R;

                              END IF;
							 END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;
                    END LOOP;

                    IF v_V_TREATMENT_CODE_ID > 0 THEN
                      ----PI_X_TREATMENT
                      v_V_ERRORLOC := 'INSERT072';

                      BEGIN
                        v_V_SQL := 'SELECT TREATMENT_CODE FROM ' ||
                                   v_V_DBNAME ||
                                   'PI_X_TREATMENT WHERE PI_ROW_ID = :1 AND TREATMENT_CODE = :2';
                        EXECUTE IMMEDIATE v_V_SQL
                          INTO v_V_CODE_ID_RMDB
                          USING v_V_PI_ROW_ID, v_V_TREATMENT_CODE_ID;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_V_CODE_ID_RMDB := 0;
                      END;

                      IF v_V_CODE_ID_RMDB = 0 THEN
                        v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                   'PI_X_TREATMENT(PI_ROW_ID, TREATMENT_CODE) VALUES( ';
                        v_V_SQL := v_V_SQL || ':1, :2)';
                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_PI_ROW_ID, v_V_TREATMENT_CODE_ID;
                      END IF;

                    END IF;
                    --PRINT 'iNSERT INTO PI_X_TREATMENT'

                    IF v_V_ILLNESS_CODE_ID > 0 THEN
                      v_V_ERRORLOC := 'INSERT078';
                      v_V_SQL      := 'UPDATE ' || v_V_DBNAME ||
                                      'PERSON_INVOLVED SET ILLNESS_CODE = :1 WHERE PI_ROW_ID = :2';
                      EXECUTE IMMEDIATE v_V_SQL
                        USING v_V_ILLNESS_CODE_ID, v_V_PI_ROW_ID;
                    END IF;

                  END IF; --EMP PERSON ENDS

                  ---- BEGIN PIXWORKLOSS
                  IF (v_V_DATE_LAST_WORKED < v_V_RETURN_WORK_DATE) AND
                     v_V_RECORD_TYPE = 'W' THEN
                    ---- BEGIN PIXWORKLOSS

                    BEGIN
                      v_V_ERRORLOC     := 'INSERT079A';
                      v_V_CODE_ID_RMDB := 0;
                      v_V_SQL          := 'SELECT PI_ROW_ID FROM ' ||
                                          v_V_DBNAME ||
                                          'PI_X_WORK_LOSS WHERE PI_ROW_ID = :1';
                      EXECUTE IMMEDIATE v_V_SQL
                        INTO v_V_CODE_ID_RMDB
                        USING v_V_PI_ROW_ID;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_CODE_ID_RMDB := 0;
                    END;

                    IF v_V_CODE_ID_RMDB = 0 THEN
                      v_V_ERRORLOC := 'INSERT079B';

                      v_V_DATE_LAST_WORKED := to_char(1 +
                                                      to_date(v_V_DATE_LAST_WORKED,
                                                              'yyyyMMDD'),
                                                      'YYYYmmdd');
                      v_V_RETURN_WORK_DATE := to_char(-1 +
                                                      to_date(v_V_RETURN_WORK_DATE,
                                                              'yyyyMMDD'),
                                                      'YYYYmmdd');

                      DDS_DURATION(v_P_JOBID,
                                   v_V_DA_ROW_ID,
                                   v_V_DBNAME,
                                   v_V_MODULENAME,
                                   'CLAIM_NUMBER',
                                   v_V_CLAIM_NUMBER,
                                   v_V_DATE_LAST_WORKED,
                                   v_V_RETURN_WORK_DATE,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   v_V_EMP_DEPT_ID,
                                   v_V_DURATION);

                      IF v_V_DURATION < 0 THEN
                        v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                        GOTO FETCHNEXT;
                      END IF;

                      --PRINT @V_DURATION;
                      v_V_ERRORLOC := 'INSERT079';
                      v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                      v_V_DBNAME ||
                                      'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                      EXECUTE IMMEDIATE V_VSQLINSERT
                        INTO v_V_PI_WL_ROW_ID
                        USING 'PI_X_WORK_LOSS';

                      v_V_ERRORLOC := 'INSERT080';

                      v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                 'PI_X_WORK_LOSS(PI_ROW_ID, PI_WL_ROW_ID, DATE_RETURNED, DATE_LAST_WORKED, DURATION, STATE_DURATION) VALUES( ';
                      v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6 )';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_PI_ROW_ID, v_V_PI_WL_ROW_ID, v_V_RETURN_WORK_DATE, v_V_DATE_LAST_WORKED, v_V_DURATION, v_V_STATE_DURATION;

                      --PRINT 'iNSERT INTO PI_X_WORK_LOSS'
                      v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                      'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                      EXECUTE IMMEDIATE v_VSQLINSERT
                        USING 'PI_X_WORK_LOSS';
                    END IF;
                  END IF;

                  ---- END PIXWORKLOSS
                  IF (v_V_DATE_LAST_RESTRICT > v_V_DATE_FIRST_RESTRICT) AND
                     v_V_RECORD_TYPE = 'W' THEN
                    ---- BEGIN PIXRESTRICT
                    BEGIN
                      v_V_ERRORLOC     := 'INSERT081A';
                      v_V_CODE_ID_RMDB := 0;
                      v_V_SQL          := 'SELECT PI_ROW_ID FROM ' ||
                                          v_V_DBNAME ||
                                          'PI_X_RESTRICT WHERE PI_ROW_ID = :1';
                      EXECUTE IMMEDIATE v_V_SQL
                        INTO v_V_CODE_ID_RMDB
                        USING v_V_PI_ROW_ID;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        v_V_CODE_ID_RMDB := 0;
                    END;
                    IF v_V_CODE_ID_RMDB = 0 THEN
                      v_V_ERRORLOC := 'INSERT081B';
                      DDS_DURATION(v_P_JOBID,
                                   v_V_DA_ROW_ID,
                                   v_V_DBNAME,
                                   v_V_MODULENAME,
                                   'CLAIM_NUMBER',
                                   v_V_CLAIM_NUMBER,
                                   v_V_DATE_FIRST_RESTRICT,
                                   v_V_DATE_LAST_RESTRICT,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   v_V_EMP_DEPT_ID,
                                   v_V_DURATION);

                      IF v_V_DURATION < 0 THEN
                        v_V_ERRORCOUNT := v_V_ERRORCOUNT + 1;
                        GOTO FETCHNEXT;
                      END IF;

                      v_V_ERRORLOC := 'INSERT081';

                      v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                      v_V_DBNAME ||
                                      'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                      EXECUTE IMMEDIATE V_VSQLINSERT
                        INTO v_V_PI_RSTRCT_ROW_ID
                        USING 'PI_X_RESTRICT';

                      v_V_ERRORLOC := 'INSERT082';

                      v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                 'PI_X_RESTRICT(PI_RESTRICT_ROW_ID, PI_ROW_ID, DATE_FIRST_RESTRCT, PERCENT_DISABLED, DATE_LAST_RESTRCT, DURATION) VALUES( ';
                      v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6)';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_PI_RSTRCT_ROW_ID, v_V_PI_ROW_ID, v_V_DATE_FIRST_RESTRICT, v_V_PERCENT_DISABLED, v_V_DATE_LAST_RESTRICT, v_V_DURATION;

                      --PRINT 'iNSERT INTO PI_X_RESTRICT'
                      v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                      'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                      EXECUTE IMMEDIATE v_VSQLINSERT
                        USING 'PI_X_RESTRICT';
                    END IF;

                  END IF;

                  ---- END PIXRESTRICT

                  IF v_V_NEW_CLAIMANT = 1 THEN
                    ----begin NEW claimANT

                    --PRINT ' INSERT INTO CLAIMANT ' -- SET A VARIABLE TO INSERT/UPDATE CLAIMANT
                    v_V_ERRORLOC := 'INSERT083';

                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1 ';

                    EXECUTE IMMEDIATE V_VSQLINSERT
                      INTO v_V_CLAIMANT_ROW_ID
                      USING 'CLAIMANT';

                    v_V_ERRORLOC := 'INSERT084';

                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'CLAIMANT(CLAIMANT_ROW_ID, CLAIM_ID, CLAIMANT_EID, COMMENTS, PRIMARY_CLMNT_FLAG, CLAIMANT_NUMBER, CLAIMANT_TYPE_CODE, CLAIMANT_STATUS_CODE ) VALUES( ';
                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6, :7, :8)';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_CLAIMANT_ROW_ID, v_V_CLAIM_ID, v_V_CLAIMANT_EID, v_V_COMMENTS, v_V_PRIMARY_CLMNT_FLAG, v_V_CLAIM_SUFFIX, v_V_CLAIMANT_TYPE_ID, v_V_CLAIMANT_STATUS_ID;
                    --PRINT @V_SQL
                    --PRINT @V_CLAIMANT_ROW_ID
                    --PRINT @V_CLAIM_ID
                    --PRINT @V_CLAIMANT_EID
                    --PRINT @V_COMMENTS
                    --PRINT @V_PRIMARY_CLMNT_FLAG
                    --PRINT @V_CLAIM_SUFFIX
                    --PRINT @V_CLAIMANT_TYPE_ID
                    --PRINT @V_CLAIMANT_STATUS_ID
                    --PRINT 'CLAIMANT INSERTED'
                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'CLAIMANT';
                    ---- END NEW CLAIM

                  ELSE
                    IF v_V_NEW_CLAIMANT = 0 THEN
                      ----BEGIN EXISTING CLAIM

                      IF v_V_UPDATE_ENTITYNAME = 1 THEN
                        v_V_ERRORLOC := 'INSERT085';

                        v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                   'ENTITY SET ENTITY_ID = ' ||
                                   v_V_ENTITY_ID;

                        IF v_V_CLAIMANT_LASTNAME IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', LAST_NAME = ' || '''' ||
                                     v_V_CLAIMANT_LASTNAME || '''';
                        END IF;

                        IF v_V_CLAIMANT_FIRSTNAME IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', FIRST_NAME = ' || '''' ||
                                     v_V_CLAIMANT_FIRSTNAME || '''';
                        END IF;

                        IF v_V_CLAIMANT_MIDDLENAME IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', MIDDLE_NAME = ' || '''' ||
                                     v_V_CLAIMANT_MIDDLENAME || '''';
                        END IF;
                        v_V_SQL := v_V_SQL || 'WHERE ENTITY_ID =' ||
                                   v_V_ENTITY_ID;
                        --PRINT @V_SQL
                      END IF;
					  

                      IF v_V_UPDATE_CLAIMANT_ADDRESS = 1 THEN
                        ---- BEGIN CLAIMANT ADDRESS UPDATE
                        -------- UPDATE CLAIMANT ADDRESS NOTE: REST OF THE CLAIMANT FIELDS NEEDS TO BE CHECKED WHETHER THEY NEED TO BE UPDATED OR NOT -----------
                        v_V_ERRORLOC := 'INSERT086';

                        v_V_SQL := ' ';

                        IF v_V_CLAIMANT_ADDRESS1 IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', ADDR1 = ' || '''' ||
                                     v_V_CLAIMANT_ADDRESS1 || '''';
                        END IF;

                        IF v_V_CLAIMANT_ADDRESS2 IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', ADDR2 = ' || '''' ||
                                     v_V_CLAIMANT_ADDRESS2 || '''';
                        END IF;

                        IF v_V_CLAIMANT_SSN IS NOT NULL THEN
						
						DDS_SSN_IMPORT(v_V_CLAIMANT_SSN, NVL(v_V_CLAIMANT_STATE_ID,0), v_V_DBNAME, v_FormattedTaxid); --jira 77662
					  
					    v_V_CLAIMANT_SSN:= v_FormattedTaxid;
                          
						  v_V_SQL := v_V_SQL || ', TAX_ID = ' || '''' ||
                                     v_V_CLAIMANT_SSN || '''';
                        END IF;

                        IF v_V_CLAIMANT_CITY IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', CITY = ' || '''' ||
                                     v_V_CLAIMANT_CITY || '''';
                        END IF;

                        IF v_V_CLAIMANT_ZIP IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', ZIP_CODE = ' || '''' ||
                                     v_V_CLAIMANT_ZIP || '''';
                        END IF;

                        IF v_V_CLAIMANT_STATE_ID IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', STATE_ID = ' ||
                                     v_V_CLAIMANT_STATE_ID;
                        END IF;

                        IF v_V_CLAIMANT_SEX_ID IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', SEX_CODE =' ||
                                     v_V_CLAIMANT_SEX_ID;
                        END IF;

                        IF v_V_CLAIMANT_BIRTH_DT IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', BIRTH_DATE = ' || '''' ||
                                     v_V_CLAIMANT_BIRTH_DT || '''';
                        END IF;

                        IF v_V_CLAIMANT_PHONE IS NOT NULL THEN
                          v_V_SQL := v_V_SQL || ', PHONE2 = ' || '''' ||
                                     v_V_CLAIMANT_PHONE || '''';
                        END IF;

                        v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                   'ENTITY SET ENTITY_ID = ' ||
                                   v_V_ENTITY_ID || v_V_SQL;

                        v_V_SQL := v_V_SQL || ' WHERE ENTITY_ID = ' ||
                                   v_V_ENTITY_ID;

                        --PRINT @V_SQL;
                        EXECUTE IMMEDIATE V_V_SQL;
                      END IF;
                    END IF;
                  END IF;

                  ---- END CLAIMANT ADDRESS UPDATE
                  ----end EXISTING claim
                  IF v_V_NEW_EVENTXOSHA = 1 THEN
                    ----begin eventxosha

                    v_V_ERRORLOC := 'INSERT087';
                    v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                    'EVENT_X_OSHA(EVENT_ID, RECORDABLE_FLAG, OSHA_ESTAB_EID) VALUES( ';
                    v_V_SQL      := v_V_SQL || ':1, :2, :3)';

                    EXECUTE IMMEDIATE v_V_SQL
                      USING v_V_EVENT_ID, v_V_OSHA_RECORDABLE_ID, v_V_CLAIMANT_EID;

                  ELSE
                    IF v_V_NEW_EVENTXOSHA = 0 AND
                       v_V_OSHA_RECORDABLE_ID > 0 THEN
                      v_V_ERRORLOC := 'INSERT088';
                      v_V_SQL      := 'UPDATE ' || v_V_DBNAME ||
                                      'EVENT_X_OSHA SET RECORDABLE_FLAG = :1, OSHA_ESTAB_EID = :2 WHERE EVENT_ID = :3';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_OSHA_RECORDABLE_ID, v_V_CLAIMANT_EID, v_V_EVENT_ID_RMDB;
                    END IF;
                  END IF;

                  ----end eventxosha
                  IF v_V_NEW_CLAIMXLIT = 1 THEN
                    ----begin claimxlitigation

                    v_V_ERRORLOC := 'INSERT089';

                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      INTO v_V_LITIGATION_ROW_ID
                      USING 'CLAIM_X_LITIGATION';

                    v_V_ERRORLOC := 'INSERT090';

                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'CLAIM_X_LITIGATION(CLAIM_ID, LITIGATION_ROW_ID, DOCKET_NUMBER, SUIT_DATE) VALUES( ';
                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4 )';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_CLAIM_ID, v_V_LITIGATION_ROW_ID, v_V_CASE_NUMBER, v_V_SUIT_DATE;

                    --PRINT 'INSERT CLAIM_X_LITIGATION'
                    --PRINT @V_SQL

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME =:1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'CLAIM_X_LITIGATION';
                  ELSE
                    IF v_V_NEW_CLAIMXLIT = 0 AND
                       v_V_CASE_NUMBER IS NOT NULL THEN
                      v_V_ERRORLOC := 'INSERT091';
                      v_V_SQL      := 'UPDATE ' || v_V_DBNAME ||
                                      'CLAIM_X_LITIGATION SET SUIT_DATE = :1 WHERE CLAIM_ID = :2 AND DOCKET_NUMBER = :3';
                      EXECUTE IMMEDIATE v_V_SQL
                        USING v_V_SUIT_DATE, v_V_CLAIM_ID, v_V_CASE_NUMBER;
                      --PRINT 'UPDATE CLAIM_X_LITIGATION'
                      --PRINT @V_SQL
                    END IF;
                  END IF;

                  ---- end claimxlitigation
                  IF v_V_NEW_DEFENDANT = 1 THEN
                    ----begin defendant

                    v_V_ERRORLOC := 'INSERT092';

                    v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                    v_V_DBNAME ||
                                    'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      INTO v_V_DEFENDANT_ROW_ID
                      USING 'DEFENDANT';

                    v_V_ERRORLOC := 'INSERT093';

                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'DEFENDANT(CLAIM_ID, DEFENDANT_ROW_ID, DEFENDANT_EID, COMMENTS) VALUES( ';
                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4)';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_CLAIM_ID, v_V_DEFENDANT_ROW_ID, v_V_DEFENDANT_EID, v_V_DEF_COMMENT;

                    --PRINT @V_SQL
                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'DEFENDANT';
                  END IF;

                  ----end defendant

                  IF v_V_NEW_VEHICLE = 1 THEN
                    ----begin vehicle

                    v_V_ERRORLOC := 'INSERT094';
                    v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                    'VEHICLE(UNIT_ID, VEHICLE_YEAR, VEHICLE_MAKE, VIN, VEHICLE_MODEL, DELETED_FLAG) VALUES(';

                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6)';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_VEHICLE_UNIT_ID, v_V_VEHICLE_YEAR, v_V_VEHICLE_MAKE, v_V_VEHICLE_ID, v_V_VEHICLE_MODEL, 0;

                    --PRINT @V_SQL
                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'VEHICLE';

                  ELSE
                    IF v_V_NEW_VEHICLE = 0 AND v_V_RECORD_TYPE = 'V' THEN

                      v_V_ERRORLOC := 'INSERT095';

                      v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                 'VEHICLE SET UNIT_ID = ' ||
                                 v_V_VEHICLE_UNIT_ID;

                      ----PRINT @V_SQL
                      IF v_V_VEHICLE_MAKE IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', VEHICLE_MAKE =' || '''' ||
                                   v_V_VEHICLE_MAKE || '''';
                      END IF;

                      IF v_V_VEHICLE_MODEL IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', VEHICLE_MODEL = ' || '''' ||
                                   v_V_VEHICLE_MODEL || '''';
                      END IF;

                      IF v_V_VEHICLE_YEAR IS NOT NULL THEN
                        v_V_SQL := v_V_SQL || ', VEHICLE_YEAR = ' || '''' ||
                                   v_V_VEHICLE_YEAR || '''';
                      END IF;

                      v_V_SQL := v_V_SQL ||
                                 ' WHERE VIN = :1 AND DELETED_FLAG = :2';

                      execute immediate v_v_sql
                        using v_V_VEHICLE_ID, 0;

                      ----PRINT @V_SQL
                    END IF;
                  END IF;

                  ----end vehicle
                  IF v_V_NEW_UNITXCLAIM = 1 THEN
                    ----begin unitxclaim

                    v_V_ERRORLOC := 'INSERT096';

                    /*v_V_SQL := 'INSERT INTO ' || v_V_DBNAME || ---commented by RMA-25298
                    'UNIT_X_CLAIM(UNIT_ROW_ID, UNIT_ID, CLAIM_ID, VEHICLE_YEAR, VEHICLE_MAKE, VIN) VALUES( ';

                    v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6)';

                    EXECUTE IMMEDIATE V_V_SQL
                    USING v_V_CLAIMXUNIT_ROW_ID, v_V_VEHICLE_UNIT_ID, v_V_CLAIM_ID, v_V_VEHICLE_YEAR, v_V_VEHICLE_MAKE, v_V_VEHICLE_ID;*/
                    v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                               'UNIT_X_CLAIM(UNIT_ROW_ID, UNIT_ID, CLAIM_ID, VEHICLE_YEAR, VEHICLE_MAKE, VIN';
                    IF v_fVersionNum >= 16.2 THEN
                      v_V_SQL := v_V_SQL ||
                                 ',DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER'; --RMA-25298
                    END IF;
                    v_V_SQL := v_V_SQL ||
                               ') VALUES (:1, :2, :3, :4, :5, :6';

                    IF v_fVersionNum >= 16.2 THEN
                      v_V_SQL := v_V_SQL || ',:7, :8, :9, :10'; --RMA-25298
                    END IF;
                    v_V_SQL := v_V_SQL || ')';

                    IF v_fVersionNum >= 16.2 THEN
                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_CLAIMXUNIT_ROW_ID, v_V_VEHICLE_UNIT_ID, v_V_CLAIM_ID, v_V_VEHICLE_YEAR, v_V_VEHICLE_MAKE, v_V_VEHICLE_ID, v_V_DATETIME, v_V_DATETIME, v_V_DDSUSER, v_V_DDSUSER;
                    ELSE
                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_CLAIMXUNIT_ROW_ID, v_V_VEHICLE_UNIT_ID, v_V_CLAIM_ID, v_V_VEHICLE_YEAR, v_V_VEHICLE_MAKE, v_V_VEHICLE_ID;
                    END IF;
                    --PRINT 'CLAIM X UNIT INSERT'
                    -- PRINT @V_SQL

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'UNIT_X_CLAIM';
                  END IF;

                  ----end unitxclaim
                  ----------------------------------------------RESERVE WORK ---------------------------------------------------------------------------------------
                  -------RESERVE_CURRENT INSERT

                  IF v_V_CARRIERFLAG = 0 AND v_V_BUCKETLIST IS NOT NULL AND
                     v_iVarFinKey = 0 --JIRA 23899 knakra
                   THEN
                    --BEGIN RESERVE WORK

                    v_ILEN := LENGTH(v_V_BUCKETLIST);

                    WHILE v_ILEN > 0 -- BEGIN WHILE
                     LOOP
                      v_vColName1 := SUBSTR(v_V_BUCKETLIST, v_ILEN, 1);

                      IF v_vColName1 = 'A' THEN
                        v_V_UDRM_RSV_TYPE_CODE_ID := v_V_UDRM_RSV_TYPE_A_CODE_ID;
                        v_V_RESERVE_AMOUNT        := v_V_RESERVE_A_CURRENT;
                        v_V_RESERVE_DATE          := v_V_RESERVE_A_DATE;
                      ELSE
                        IF v_vColName1 = 'B' THEN
                          v_V_UDRM_RSV_TYPE_CODE_ID := v_V_UDRM_RSV_TYPE_B_CODE_ID;
                          v_V_RESERVE_AMOUNT        := v_V_RESERVE_B_CURRENT;
                          v_V_RESERVE_DATE          := v_V_RESERVE_B_DATE;
                        ELSE
                          IF v_vColName1 = 'C' THEN
                            v_V_UDRM_RSV_TYPE_CODE_ID := v_V_UDRM_RSV_TYPE_C_CODE_ID;
                            v_V_RESERVE_AMOUNT        := v_V_RESERVE_C_CURRENT;
                            v_V_RESERVE_DATE          := v_V_RESERVE_C_DATE;
                          ELSE
                            IF v_vColName1 = 'D' THEN
                              v_V_UDRM_RSV_TYPE_CODE_ID := v_V_UDRM_RSV_TYPE_D_CODE_ID;
                              v_V_RESERVE_AMOUNT        := v_V_RESERVE_D_CURRENT;
                              v_V_RESERVE_DATE          := v_V_RESERVE_D_DATE;
                            ELSE
                              IF v_vColName1 = 'E' THEN
                                v_V_UDRM_RSV_TYPE_CODE_ID := v_V_UDRM_RSV_TYPE_E_CODE_ID;
                                v_V_RESERVE_AMOUNT        := v_V_RESERVE_E_CURRENT;
                                v_V_RESERVE_DATE          := v_V_RESERVE_E_DATE;
                              END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;

                      v_V_RC_ROW_ID   := 0;
                      v_V_PAID_TOTAL  := 0;
                      v_V_COL_TOTAL   := 0;
                      v_V_CUR_RSV_AMT := 0;

                      BEGIN
                        v_V_ERRORLOC := 'INSERT096B';
                        v_V_SQL      := 'SELECT RC_ROW_ID, RESERVE_AMOUNT, COLLECTION_TOTAL, PAID_TOTAL FROM ' ||
                                        v_V_DBNAME || 'RESERVE_CURRENT';
                        v_V_SQL      := v_V_SQL || ' WHERE CLAIM_ID = :1';
                        v_V_SQL      := v_V_SQL || ' AND CLAIMANT_EID = :2';
                        v_V_SQL      := v_V_SQL ||
                                        ' AND RESERVE_TYPE_CODE = :3';
                        v_V_SQL      := v_V_SQL || ' AND UNIT_ID = :4';

                        EXECUTE IMMEDIATE V_V_SQL
                          INTO v_V_RC_ROW_ID, v_V_CUR_RSV_AMT, v_V_COL_TOTAL, v_V_PAID_TOTAL
                          USING v_V_CLAIM_ID, v_V_CLAIMANT_EID_R, v_V_UDRM_RSV_TYPE_CODE_ID, v_V_UNIT_ID_R;

                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_V_RC_ROW_ID := 0;
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
                                                'CLAIM_NUMBER',
                                                v_V_CLAIM_NUMBER,
                                                0);
                          v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
                      END;

                      ----- RESERVE LOGIC STARTS
                      v_V_CHANGE_AMT := v_V_RESERVE_AMOUNT -
                                        v_V_CUR_RSV_AMT;

                      IF v_V_COL_IN_RSV_BAL <> 0 THEN
                        v_V_RESERVE_BALANCE := v_V_RESERVE_AMOUNT -
                                               (v_V_PAID_TOTAL -
                                               v_V_COL_TOTAL);
                      ELSE
                        IF v_V_COL_IN_RSV_BAL = 0 THEN
                          v_V_RESERVE_BALANCE := v_V_RESERVE_AMOUNT -
                                                 v_V_PAID_TOTAL;
                        END IF;
                      END IF;

                      IF v_V_COL_IN_RSV_BAL <> 0 THEN
                        IF v_V_RESERVE_BALANCE < 0 THEN
                          v_V_INCURRED_AMOUNT := v_V_PAID_TOTAL -
                                                 v_V_COL_TOTAL;
                        ELSE
                          v_V_INCURRED_AMOUNT := v_V_RESERVE_BALANCE +
                                                 (v_V_PAID_TOTAL -
                                                 v_V_COL_TOTAL);
                        END IF;
                      ELSE
                        IF v_V_RESERVE_BALANCE < 0 THEN
                          v_V_INCURRED_AMOUNT := v_V_PAID_TOTAL;
                        ELSE
                          v_V_INCURRED_AMOUNT := v_V_RESERVE_BALANCE +
                                                 v_V_PAID_TOTAL;
                        END IF;
                      END IF;

                      IF v_V_COL_IN_INC_BAL <> 0 THEN
                        v_V_INCURRED_AMOUNT := v_V_INCURRED_AMOUNT -
                                               v_V_COL_TOTAL;
                      END IF;

                      ---- RESERVE LOGIC ENDS

                      ------------------------------------------------------------------------------------

                      IF v_V_RC_ROW_ID = 0 THEN

                        v_V_ERRORLOC        := 'INSERT096C';
                        v_V_RESERVE_BALANCE := v_V_RESERVE_AMOUNT;
                        v_VSQLINSERT        := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                               v_V_DBNAME ||
                                               'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                        EXECUTE IMMEDIATE v_VSQLINSERT
                          INTO v_V_RC_ROW_ID
                          USING 'RESERVE_CURRENT';

                        v_V_ERRORLOC := 'INSERT096D';

                        v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                   'RESERVE_CURRENT(RC_ROW_ID, CLAIM_ID, CLAIMANT_EID, UNIT_ID, RESERVE_TYPE_CODE, ';
                        v_V_SQL := v_V_SQL ||
                                   'RESERVE_AMOUNT, BALANCE_AMOUNT, INCURRED_AMOUNT, PAID_TOTAL, COLLECTION_TOTAL,';
                        v_V_SQL := v_V_SQL ||
                                   'DATE_ENTERED, DTTM_RCD_ADDED, ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER, REASON,';
                        v_V_SQL := v_V_SQL ||
                                   'ENTERED_BY_USER,POLCVG_LOSS_ROW_ID) ';
                        v_V_SQL := v_V_SQL ||
                                   'VALUES(:1, :2, :3, :4, :5, :6, :7,';
                        v_V_SQL := v_V_SQL ||
                                   ':8, :9, :10, :11, :12 ,:13, :14,';
                        v_V_SQL := v_V_SQL || ':15, :16, :17, :18)';

                        EXECUTE IMMEDIATE V_V_SQL
                          USING v_V_RC_ROW_ID, v_V_CLAIM_ID, v_V_CLAIMANT_EID_R, v_V_UNIT_ID_R, v_V_UDRM_RSV_TYPE_CODE_ID, v_V_RESERVE_AMOUNT, v_V_RESERVE_BALANCE, v_V_INCURRED_AMOUNT, v_V_PAID_TOTAL, v_V_COL_TOTAL, v_V_RESERVE_DATE, v_V_DATETIME, v_V_DDSUSER, v_V_DATETIME, v_V_DDSUSER, v_V_REASON, v_V_DDSUSER, 0;

                        v_V_ERRORLOC := 'INSERT096E';

                        v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                        'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                        EXECUTE IMMEDIATE v_VSQLINSERT
                          USING 'RESERVE_CURRENT';
                      ELSE
                        IF v_V_RC_ROW_ID > 0 AND
                           (v_V_CUR_RSV_AMT <> v_V_RESERVE_AMOUNT) THEN
                          v_V_ERRORLOC := 'INSERT096F';
                          v_V_SQL      := 'UPDATE ' || v_V_DBNAME ||
                                          'RESERVE_CURRENT SET RESERVE_AMOUNT = :1';
                          v_V_SQL      := v_V_SQL ||
                                          ', DATE_ENTERED = :2, INCURRED_AMOUNT = :3';
                          v_V_SQL      := v_V_SQL ||
                                          ', PAID_TOTAL = :4, COLLECTION_TOTAL = :5';
                          v_V_SQL      := v_V_SQL ||
                                          ', BALANCE_AMOUNT = :6, REASON = :7';
                          v_V_SQL      := v_V_SQL ||
                                          ', DTTM_RCD_LAST_UPD = :8, UPDATED_BY_USER = :9';
                          v_V_SQL      := v_V_SQL ||
                                          ' WHERE CLAIM_ID = :10';
                          v_V_SQL      := v_V_SQL ||
                                          ' AND UNIT_ID = :11 AND CLAIMANT_EID = :12';
                          v_V_SQL      := v_V_SQL ||
                                          ' AND RESERVE_TYPE_CODE = :13';

                          EXECUTE IMMEDIATE V_V_SQL
                            USING v_V_RESERVE_AMOUNT, v_V_RESERVE_DATE, v_V_INCURRED_AMOUNT, v_V_PAID_TOTAL, v_V_COL_TOTAL, v_V_RESERVE_BALANCE, v_V_REASON, v_V_DATETIME, v_V_DDSUSER, v_V_CLAIM_ID, v_V_UNIT_ID_R, v_V_CLAIMANT_EID_R, v_V_UDRM_RSV_TYPE_CODE_ID;

                        END IF;
                      END IF;

                      -------RESERVE_HISTORY INSERT
                      v_V_ERRORLOC := 'INSERT096G';

                      v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                                      v_V_DBNAME ||
                                      'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
                      EXECUTE IMMEDIATE v_VSQLINSERT
                        INTO v_V_RSV_ROW_ID
                        USING 'RESERVE_HISTORY';

                      v_V_ERRORLOC := 'INSERT096H';

                      v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                                 'RESERVE_HISTORY(RSV_ROW_ID, CLAIM_ID, RESERVE_TYPE_CODE, CLAIMANT_EID, UNIT_ID, RESERVE_AMOUNT, PAID_TOTAL,';
                      v_V_SQL := v_V_SQL ||
                                 'COLLECTION_TOTAL, INCURRED_AMOUNT, BALANCE_AMOUNT, CHANGE_AMOUNT, REASON, DATE_ENTERED, DTTM_RCD_ADDED, ADDED_BY_USER,';
                      v_V_SQL := v_V_SQL ||
                                 ' DTTM_RCD_LAST_UPD, UPDATED_BY_USER, ENTERED_BY_USER) ';
                      v_V_SQL := v_V_SQL || 'VALUES(:1, :2, :3, :4, :5,';
                      v_V_SQL := v_V_SQL ||
                                 ':6, :7, :8, :9, :10, :11, :12,';
                      v_V_SQL := v_V_SQL || ':13, :14,:15, :16, :17, :18)';

                      EXECUTE IMMEDIATE V_V_SQL
                        USING v_V_RSV_ROW_ID, v_V_CLAIM_ID, v_V_UDRM_RSV_TYPE_CODE_ID, v_V_CLAIMANT_EID_R, v_V_UNIT_ID_R, v_V_RESERVE_AMOUNT, v_V_PAID_TOTAL, v_V_COL_TOTAL, V_V_INCURRED_AMOUNT, V_V_RESERVE_BALANCE, v_V_CHANGE_AMT, V_V_REASON, v_V_RESERVE_DATE, V_V_DATETIME, V_V_DDSUSER, V_V_DATETIME, V_V_DDSUSER, V_V_DDSUSER;
                      ----PRINT @V_SQL

                      v_V_ERRORLOC := 'INSERT096I';
                      v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                      'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
                      EXECUTE IMMEDIATE v_VSQLINSERT
                        USING 'RESERVE_HISTORY';

                      v_ILEN := v_ILEN - 1;
                    END LOOP;
                  END IF;

                  --END WHILE
                  --END RESERVE WORK
                  ----------------------------------------------------RESERVE WORK ENDS ----------------------------------------------------------------------------------
                  IF v_V_NEW_UNITSTAT = 1 THEN
                    v_V_ERRORLOC := 'INSERT097';
                    v_V_SQL      := 'INSERT INTO ' || v_V_DBNAME ||
                                    'UNIT_STAT(UNIT_STAT_ROW_ID, CLAIM_ID, SETTLEMENT_METHOD, MGND_CARE_ORG_TYPE, DISPUTED_CASE_FLAG, ';
                    v_V_SQL      := v_V_SQL ||
                                    'NCCI_LOSS_TYPE_LOSS_CODE, NCCI_LOSS_TYPE_RECOV_CODE) VALUES( ';
                    v_V_SQL      := v_V_SQL || ':1, :2, :3, :4, :5, ';
                    v_V_SQL      := v_V_SQL || ':6, :7)';

                    EXECUTE IMMEDIATE V_V_SQL
                      USING v_V_CLAIMXUNIT_ROW_ID, v_V_CLAIM_ID, v_V_SETTLEMENT_METHOD_ID, v_V_MGND_CARE_ORG_TYPE_ID, v_V_DISPUTED_CASE_FLAG_ID, V_NCCI_LOSS_TYPE_LOSS_CODE_ID, V_NCCI_LOSS_TYPE_RECOV_CODE_id;

                    v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                                    'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                    EXECUTE IMMEDIATE v_VSQLINSERT
                      USING 'UNIT_STAT';
                  ELSE
                    IF v_V_NEW_UNITSTAT = 0 AND v_V_RECORD_TYPE = 'W' THEN
                      v_V_ERRORLOC := 'INSERT098';

                      v_V_SQL := 'UPDATE ' || v_V_DBNAME ||
                                 'UNIT_STAT SET CLAIM_ID = ' ||
                                 v_V_CLAIM_ID;

                      IF v_V_SETTLEMENT_METHOD_ID > 0 THEN
                        v_V_SQL := v_V_SQL || ', SETTLEMENT_METHOD = ' ||
                                   v_V_SETTLEMENT_METHOD_ID;
                      END IF;

                      IF v_V_MGND_CARE_ORG_TYPE_ID > 0 THEN
                        v_V_SQL := v_V_SQL || ', MGND_CARE_ORG_TYPE = ' ||
                                   v_V_MGND_CARE_ORG_TYPE_ID;
                      END IF;

                      IF V_NCCI_LOSS_TYPE_LOSS_CODE_ID > 0 THEN
                        v_V_SQL := v_V_SQL ||
                                   ', NCCI_LOSS_TYPE_LOSS_CODE = ' ||
                                   V_NCCI_LOSS_TYPE_LOSS_CODE_ID;
                      END IF;

                      IF V_NCCI_LOSS_TYPE_RECOV_CODE_ID > 0 THEN
                        v_V_SQL := v_V_SQL ||
                                   ', NCCI_LOSS_TYPE_RECOV_CODE = ' ||
                                   V_NCCI_LOSS_TYPE_RECOV_CODE_ID;
                      END IF;

                      v_V_SQL := v_V_SQL || ', DISPUTED_CASE_FLAG = ' ||
                                 v_V_DISPUTED_CASE_FLAG_ID;
                      v_V_SQL := v_V_SQL || ' WHERE CLAIM_ID = ' ||
                                 v_V_CLAIM_ID;

                      --PRINT @V_SQL
                      EXECUTE IMMEDIATE V_V_SQL;
                    END IF;
                  END IF;
                  -- Kapil commenting below code for VFK Enhancement - JIRA#23899 - Start

                  /*BEGIN
                   ------ ACTIVITY TRACK

                   v_V_ERRORLOC := 'INSERT099';

                   v_VSQLINSERT := 'SELECT NEXT_UNIQUE_ID FROM ' ||
                   v_V_DBNAME ||
                   'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

                   EXECUTE IMMEDIATE v_VSQLINSERT
                   INTO v_V_CLAIMXUNIT_ROW_ID
                   USING 'ACTIVITY_TRACK';

                   v_V_ERRORLOC := 'INSERT100';

                   v_V_SQL := 'INSERT INTO ' || v_V_DBNAME ||
                   'ACTIVITY_TRACK(ACTIVITY_ROW_ID, CLAIM_ID, FOREIGN_TABLE_ID, FOREIGN_TABLE_KEY, UPLOAD_FLAG, ';
                   v_V_SQL := v_V_SQL ||
                   'DTTM_RCD_ADDED, ADDED_BY_USER, CHECK_BATCH_ID, POLICY_SYSTEM_ID, IS_UPDATED, ACTIVITY_TYPE, ACCOUNT_ID, RESERVE_AMOUNT, ';
                   v_V_SQL := v_V_SQL ||
                   'RESERVE_STATUS, CHANGE_AMOUNT, CHECK_STATUS, VOID_FLAG, IS_COLLECTION) VALUES( ';
                   v_V_SQL := v_V_SQL || ':1, :2, :3, :4, :5, :6';
                   v_V_SQL := v_V_SQL ||
                   ', :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18)';

                   EXECUTE IMMEDIATE V_V_SQL
                   USING v_V_CLAIMXUNIT_ROW_ID, v_V_CLAIM_ID, 0, 0, 0, v_V_DATETIME, v_V_DDSUSER, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;

                   --PRINT @V_SQL

                   v_VSQLINSERT := 'UPDATE ' || v_V_DBNAME ||
                   'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

                   EXECUTE IMMEDIATE v_VSQLINSERT
                   USING 'ACTIVITY_TRACK';
                   END;
                  */
                  -- Kapil commenting above code for VFK Enhancement - JIRA#23899 - End

                 COMMIT;

                  IF v_V_CLAIM_SUPP = 1 THEN
                    -- SUPPLEMENTAL COLUMN INSERT BEGIN
                    IF v_V_CLAIMANT_EID > 0 THEN
                      DDS_SUPPLEMENT(v_P_JOBID,
                                     v_CONFIG_ID,
                                     v_P_USER_ID,
                                     v_V_MODULENAME,
                                     v_V_DBNAME,
                                     v_V_DA_ROW_ID,
                                     v_CheckCreateNewCodes,
                                     v_V_CLAIM_LOB,
                                     v_V_ERRORCOUNT,
                                     'I',
                                     v_V_CLAIMANT_EID,
                                     v_V_EVENT_ID,
                                     v_V_CLAIM_ID,
                                     v_V_EMPLOYEE_EID,
                                     v_V_VEHICLE_UNIT_ID,
                                     v_V_CLAIMANT_EID, -- FOR ENTITY SUPPLEMENTAL
                                     v_V_DEFENDANT_ROW_ID,
                                     v_V_PI_ROW_ID,
                                     0,
                                     0,
                                     0,
                                     v_V_PLAN_ID,
                                     0,
                                     0,
                                     'CLAIM NUMBER',
                                     v_V_CLAIM_NUMBER,
                                     v_V_SUPP_ERROR_COUNT);
                    END IF;

                    IF v_V_DEPENDENT_EID > 0 THEN
                      DDS_SUPPLEMENT(v_P_JOBID,
                                     v_CONFIG_ID,
                                     v_P_USER_ID,
                                     v_V_MODULENAME,
                                     v_V_DBNAME,
                                     v_V_DA_ROW_ID,
                                     v_CheckCreateNewCodes,
                                     v_V_CLAIM_LOB,
                                     v_V_ERRORCOUNT,
                                     'I',
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     v_V_DEPENDENT_EID,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     'CLAIM NUMBER',
                                     v_V_CLAIM_NUMBER,
                                     v_V_SUPP_ERROR_COUNT);
                    END IF;

                  END IF;

                END;
              END IF;

            END;
          EXCEPTION
            WHEN OTHERS THEN
              -- SUPPLEMENTAL COLUMN INSERT END
              ----END LEVEL INSERT/UPDATE
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
                                    v_V_CLAIM_NUMBER,
                                    0);
              v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          END;

          <<FETCHNEXT>>

          v_V_ERRORLOC := 'END666';

          IF v_V_ERRORCOUNT + v_V_ROWCOUNT = 0 THEN
            v_V_INVALID_ROW := 0;

            v_V_SQL := 'UPDATE DDS_CLAIM SET INVALID_ROW = :1 WHERE DA_ROW_ID = :2';
            EXECUTE IMMEDIATE V_V_SQL
              USING v_V_INVALID_ROW, v_V_DA_ROW_ID;

          END IF;
                  ---Neha Running status code starts 33658---
                  --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);
                  v_V_ERRORLOC := 'Running_Status';
                  IF v_iRunStatCnt = 1 THEN
                  BEGIN
                     v_vProcessMsg := 'Total Number of Records processed in CLAIM : ' ||v_iRunStatCnt;

                     EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
                     USING v_P_JOBID, v_vProcessMsg, 'CLAIM_RUN', 'DDS_CLAIM_RUN', -11;
                  END;
                  ELSIF v_iRunCnt = 1000 THEN
                  BEGIN
                     v_vProcessMsg := 'Total Number of Records processed in CLAIM : ' ||v_iRunStatCnt;
                     v_V_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND
                     MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';
                     EXECUTE IMMEDIATE v_V_SQL using v_vProcessMsg, v_P_JOBID, 'CLAIM_RUN', 'DDS_CLAIM_RUN';
                     v_iRunCnt:=1;
                  END;
                  ELSIF (v_iCount=v_iRunStatCnt) THEN
                  BEGIN
                  v_vProcessMsg := 'Total Number of Records processed in CLAIM : ' ||v_iCount;
                  v_V_SQL := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND
                  MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';

                 EXECUTE IMMEDIATE v_V_SQL using v_vProcessMsg, v_P_JOBID, 'CLAIM_RUN', 'DDS_CLAIM_RUN';
                 END;

                 END IF;

                  v_iRunStatCnt := v_iRunStatCnt + 1;
                  v_iRunCnt := v_iRunCnt + 1;
                 ---Neha running status code ends 33658---

          COMMIT;
        END;
      EXCEPTION
        WHEN OTHERS THEN
          ----INSERT WORK ENDS
          ------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
                                v_V_CLAIM_NUMBER,
                                0);
          v_V_ROWCOUNT := v_V_ROWCOUNT + 1;
          ---In case there is some exception in main try then the cursor needs to be closed and deallocated so that next run does not create any issues
          --CLOSE DDS_CLAIM_CUR;
          ROLLBACK;
      END;

      ---- END MAIN TRY
      ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
      --FETCH DDS_CLAIM_CUR INTO v_V_DA_ROW_ID,v_V_JOBID,v_V_INVALID_ROW,v_V_RECORD_TYPE,v_V_CLAIM_NUMBER,v_V_CLAIM_SUFFIX,v_V_CLAIM_TYPE,v_V_DIVISION,v_V_LOCATION,v_V_DEPARTMENT,v_V_COMPANY,v_V_COUNTRY,v_V_DIVISION_DESC,v_V_LOCATION_DESC,v_V_DEPARTMENT_DESC,v_V_COMPANY_DESC,v_V_TIME_OF_CLAIM,v_V_DATE_OF_LOSS,v_V_DATE_REPORTED,v_V_DATE_OF_CLAIM,v_V_DATE_CLOSED,v_V_DATE_REOPENED,v_V_CLAIM_STATUS,v_V_RESERVE_A_OPENING,v_V_RESERVE_A_CURRENT,v_V_RESERVE_A_DATE,v_V_PAID_A_TOTAL,v_V_COLLECTION_A_TOTAL,v_V_RESERVE_B_OPENING,v_V_RESERVE_B_CURRENT,v_V_RESERVE_B_DATE,v_V_PAID_B_TOTAL,v_V_COLLECTION_B_TOTAL,v_V_RESERVE_C_OPENING,v_V_RESERVE_C_CURRENT,v_V_RESERVE_C_DATE,v_V_PAID_C_TOTAL,v_V_COLLECTION_C_TOTAL,v_V_RESERVE_D_OPENING,v_V_RESERVE_D_CURRENT,v_V_RESERVE_D_DATE,v_V_PAID_D_TOTAL,v_V_COLLECTION_D_TOTAL,v_V_CAUSE_CODE,v_V_CLAIMANT_LASTNAME,v_V_CLAIMANT_FIRSTNAME,v_V_CLAIMANT_SSN,v_V_CLAIMANT_ADDRESS1,v_V_CLAIMANT_ADDRESS2,v_V_CLAIMANT_CITY,v_V_CLAIMANT_STATE,v_V_CLAIMANT_ZIP,v_V_CLAIMANT_SEX,v_V_CLAIMANT_BIRTH_DT,v_V_CLAIMANT_PHONE,v_V_CLAIMANT_COMMENT,v_V_DEF_LASTNAME,v_V_DEF_FIRSTNAME,v_V_DEF_ADDRESS,v_V_DEF_CITY,v_V_DEF_STATE,v_V_DEF_ZIP,v_V_DEF_PHONE,v_V_DEF_COMMENT,v_V_CLOSURE_METHOD,v_V_DESCRIPTION,v_V_SERVICE,v_V_DIAGNOSIS_1,v_V_DIAGNOSIS_2,v_V_DIAGNOSIS_3,v_V_DIAGNOSIS_4,v_V_DIAGNOSIS_5,v_V_POLICY_NUMBER,v_V_POLICY_EFFECT_DATE,v_V_POLICY_EXPIRE_DATE,v_V_SUIT_DATE,v_V_CASE_NUMBER,v_V_EVENT_NUMBER,v_V_COMMENTS,v_V_ILLNESS_CODE,v_V_INJURY_CODE_1,v_V_INJURY_CODE_2,v_V_INJURY_CODE_3,v_V_INJURY_CODE_4,v_V_INJURY_CODE_5,v_V_BODY_PART_1,v_V_BODY_PART_2,v_V_BODY_PART_3,v_V_BODY_PART_4,v_V_BODY_PART_5,v_V_EMP_DEPARTMENT,v_V_OCCUPATION,v_V_DATE_OF_BIRTH,v_V_DATE_OF_HIRE,v_V_DATE_OF_DEATH,v_V_OSHA_RECORDABLE,v_V_EMPLOYEE_SEX,v_V_WEEKLY_WAGE_RATE,v_V_HOURLY_WAGE_RATE,v_V_WEEKLY_HOURS,v_V_NCCI_CLASS_CODE,v_V_ACCIDENT_STATE,v_V_MARITAL_STATUS,v_V_DEPENDENT_LNAME,v_V_DEPENDENT_FNAME,v_V_DEPENDENT_BIRTH_DT,v_V_LICENSE_NUMBER,v_V_LICENSE_EXPIR_DATE,v_V_LICENSE_TYPE,v_V_LICENSE_RESTRICT,v_V_RETURN_WORK_DATE,v_V_ACTIVE_FLAG,v_V_EMPLOYER_SIC_CODE,v_V_EMPLOYER_PAYROLL_CLASS_COD,v_V_VEHICLE_ID,v_V_VEHICLE_YEAR,v_V_VEHICLE_MAKE,v_V_EMPLOYEE_ID,v_V_VEHICLE_MODEL,v_V_FILE_NUMBER,v_V_DATE_LAST_WORKED,v_V_CLAIMANT_MIDDLENAME,v_V_ACCIDENT_DESC,v_V_ACCIDENT_PREVENTABLE,v_V_USER_FIELD_A,v_V_USER_FIELD_B,v_V_USER_FIELD_C,v_V_USER_FIELD_D,v_V_USER_FIELD_E,v_V_USER_FIELD_F,v_V_USER_FIELD_G,v_V_USER_FIELD_H,v_V_USER_FIELD_I,v_V_USER_FIELD_J,v_V_USER_FIELD_K,v_V_USER_FIELD_L,v_V_USER_FIELD_M,v_V_USER_FIELD_N,v_V_USER_FIELD_O,v_V_USER_FIELD_P,v_V_USER_FIELD_Q,v_V_USER_FIELD_R,v_V_USER_FIELD_S,v_V_USER_FIELD_T,v_V_USER_FIELD_U,v_V_USER_FIELD_V,v_V_USER_FIELD_W,v_V_USER_FIELD_X,v_V_USER_FIELD_Y,v_V_USER_FIELD_Z,v_V_PLAN_NAME,v_V_CLASS_NAME,v_V_DISABIL_FROM_DATE,v_V_DISABIL_TO_DATE,v_V_BENEFITS_START,v_V_BENEFITS_THROUGH,v_V_DIS_TYPE,v_V_BEN_CALC_PAY_START,v_V_BEN_CALC_PAY_TO,v_V_FEDERAL_TAX_FLAG,v_V_SOCIAL_SEC_TAX_FLAG,v_V_MEDICARE_TAX_FLAG,v_V_STATE_TAX_FLAG,v_V_STD_DISABIL_TYPE,v_V_MONTHLY_RATE,v_V_ELIG_DIS_BEN_FLAG,v_V_DIS_OPTION_CODE,v_V_PENSION_AMT,v_V_SS_AMT,v_V_OTHER_AMT,v_V_RESERVE_E_OPENING,v_V_RESERVE_E_CURRENT,v_V_RESERVE_E_DATE,v_V_PAID_E_TOTAL,v_V_COLLECTION_E_TOTAL,v_V_CLAIMANT_TYPE,v_V_OSHA_ACC_DESC,v_V_DATE_WORKED_LAST,v_V_DATE_RETURNED,v_V_STATE_DURATION,v_V_DATE_FIRST_RESTRICT,v_V_DATE_LAST_RESTRICT,v_V_PERCENT_DISABLED,v_V_SETTLEMENT_METHOD,v_V_MGND_CARE_ORG_TYPE,v_V_DISPUTED_CASE_FLAG,v_V_NCCI_LOSS_TYPE_LOSS_CODE,v_V_NCCI_LOSS_TYPE_RECOV_CODE,v_V_TREATMENT_CODE,v_V_CLAIMANT_STATUS,v_V_NAME_TYPE,v_V_POLICY_LOB;
      --v_TOTALROWS := v_TOTALROWS - 1;
    END;
  END LOOP;

  CLOSE DDS_CLAIM_CUR;

  <<ENDMAIN>>
  DDS_PROCESS_LOG(v_P_JOBID, v_V_MODULENAME, v_V_ERROR_TABLE);

EXCEPTION
  WHEN OTHERS THEN
    v_V_ERRORLOC      := 'MAIN';
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
                          v_V_CLAIM_NUMBER,
                          0);
    ROLLBACK;
END DDS_VALIDATE_CLAIM;
