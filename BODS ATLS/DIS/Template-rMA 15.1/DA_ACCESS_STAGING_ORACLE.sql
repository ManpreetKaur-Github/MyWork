-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Template-rMA 15.1_DIS
--   Database Type: Oracle
--   DI Module Name: DIS MS ACCESS DATABASE
--Create tables
--DA_ACCESS_STAGING_ORACLE.sql
--07/19/2012
--===========================================
declare iExists NUMBER;

BEGIN
--==========================================================
---CREATE EMP_X_DEPENDENT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMP_X_DEPENDENT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE EMP_X_DEPENDENT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE EMP_X_DEPENDENT(
  OPTIONSET_ID number(10) NULL,
  EMPLOYEE_EID number(10) NULL,  
  DEPENDENT_EID number(10) NULL,
  HEALTH_PLAN_FLAG varchar2(1) NULL,
  RELATION_CODE varchar2(25) NULL

)';
END IF;
END;


--==========================================================
---CREATE EMP_X_VIOLATION table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMP_X_VIOLATION';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE EMP_X_VIOLATION';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN

EXECUTE IMMEDIATE
'CREATE TABLE EMP_X_VIOLATION(
  OPTIONSET_ID number(10) NULL,
  EMPLOYEE_EID number(10) NULL,
  VIOLATION_CODE varchar2(25) NULL,
  VIOLATION_DATE varchar2(8) NULL

)';
END IF;
END;
--==========================================================
---CREATE EMPLOYEE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMPLOYEE';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE EMPLOYEE';
 iExists := 0 ;
END IF;
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE EMPLOYEE(
  OPTIONSET_ID number(10) NULL,
  COUNTY_OF_RESIDNC varchar2(50) NULL,
  DRIVLIC_STATE varchar2(25) NULL,
  INSURABLE_FLAG varchar2(1) NULL,
  LAST_VERIFIED_DATE varchar2(8) NULL,
  NUM_OF_VIOLATIONS number (10) NULL,
  TERM_DATE varchar2(8) NULL,
  WORK_PERMIT_DATE varchar2(8) NULL,
  WORK_PERMIT_NUMBER varchar2(50) NULL,
  EMPLOYEE_EID number(10) NULL,  
  ACTIVE_FLAG varchar2(1) NULL,
  EMPLOYEE_NUMBER varchar2(20) NULL,
  MARITAL_STAT_CODE varchar2(25) NULL,
  DATE_HIRED varchar2(8) NULL,
  POSITION_CODE varchar2(25) NULL,
  DEPT_ASSIGNED_EID varchar2(25) NULL,
  SUPERVISOR_EID number(10) NULL,
  EXEMPT_STATUS_FLAG varchar2(1) NULL,  
  NO_OF_EXEMPTIONS number(10) NULL,  
  FULL_TIME_FLAG varchar2(1) NULL,  
  HOURLY_RATE number(8,2) NULL,
  WEEKLY_HOURS number(10) NULL,
  WEEKLY_RATE number(8,2) NULL,
  WORK_SUN_FLAG varchar2(1) NULL,
  WORK_MON_FLAG varchar2(1) NULL,
  WORK_TUE_FLAG varchar2(1) NULL,
  WORK_WED_FLAG varchar2(1) NULL,
  WORK_THU_FLAG varchar2(1) NULL,
  WORK_FRI_FLAG varchar2(1) NULL,
  WORK_SAT_FLAG varchar2(1) NULL,
  PAY_TYPE_CODE varchar2(25) NULL,
  PAY_AMOUNT number(8,2) NULL,
  DRIVERS_LIC_NO varchar2(20) NULL,
  DRIVERSLICTYPECODE varchar2(25) NULL,
  DATE_DRIVERSLICEXP varchar2(8) NULL,
  DRIVLIC_RSTRCTCODE varchar2(25) NULL,
  NCCI_CLASS_CODE varchar2(25) NULL,
  DATE_OF_DEATH varchar2(8) NULL,
  SEC_DEPT_EID varchar2(25) NULL,
  JOB_CLASS_CODE varchar2(25) NULL,
  MONTHLY_RATE number(8,2) NULL,
  ELIG_DIS_BEN_FLAG varchar2(1)  NULL,
  EMP_ENTITY_ID number(10) NULL
)';
END IF;
END;
--==========================================================
---CREATE ENTITY table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='ENTITY';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE ENTITY';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE ENTITY(
  OPTIONSET_ID number(10) NULL,
  BUSINESS_TYPE_CODE varchar2(25) NULL,
  COUNTY varchar2(30) NULL,
  NATURE_OF_BUSINESS varchar2(50) NULL,
  SIC_CODE varchar2(25) NULL,
  WC_FILING_NUMBER varchar2(30) NULL,
  ENTITY_ID number(10) NULL,
  ENTITY_TABLE_ID varchar2(18) NULL,
  LAST_NAME varchar2(100) NULL,
  FIRST_NAME varchar2(50) NULL,
  ALSO_KNOWN_AS varchar2(50) NULL,
  ABBREVIATION varchar2(25) NULL,
  COST_CENTER_CODE varchar2(25) NULL,
  ADDRESS_TYPE_CODE varchar2(25) NULL,                   -- start kkaur25 14.2 enh
  ADDR1 varchar2(50) NULL,
  ADDR2 varchar2(50) NULL,
  CITY varchar2(50) NULL,
  COUNTRY_CODE varchar2(25) NULL,  
  STATE_ID varchar2(25) NULL,
  ZIP_CODE varchar2(10) NULL,
  PARENT_EID number(10) NULL,
  TAX_ID varchar2(20) NULL,
  CONTACT varchar2(50) NULL,
  COMMENTS varchar2(4000) NULL,
  EMAIL_TYPE_CODE varchar2(25) NULL,
  EMAIL_ADDRESS varchar2(25) NULL,
  SEX_CODE varchar2(25) NULL,
  BIRTH_DATE varchar2(8) NULL,
  PHONE1 varchar2(30) NULL,
  PHONE2 varchar2(30) NULL,
  FAX_NUMBER varchar2(30) NULL,
  CONTACT_TYPE_CODE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  CONTACT_NAME varchar2(50) NULL,
  CONTACT_TITLE varchar2(50) NULL,
  CONTACT_INITIALS varchar2(10) NULL,
  CONTACT_ADDR1 varchar2(50) NULL,
  CONTACT_ADDR2 varchar2(50) NULL,
  CONTACT_CITY varchar2(50) NULL,
  CONTACT_STATE_ID varchar2(25) NULL,
  CONTACT_ZIP_CODE varchar2(10) NULL,
  CONTACT_PHONE varchar2(30) NULL,
  CONTACT_FAX_NUMBER varchar2(30) NULL,
  CONTACT_EMAIL_ADDRESS varchar2(25) NULL,		-- end kkaur25 14.2 enh
  DTTM_RCD_ADDED varchar2(14) NULL,
  DTTM_RCD_LAST_UPD varchar2(14) NULL,
  UPDATED_BY_USER varchar2(50) NULL,
  ADDED_BY_USER varchar2(50) NULL,
  DELETED_FLAG varchar2(1) NULL,
  SEC_DEPT_EID varchar2(25)NULL,
  TRIGGER_DATE_FIELD varchar2(50) NULL,
  EFF_START_DATE varchar2(8) NULL,
  EFF_END_DATE varchar2(8) NULL,
  PARENT_1099_EID number(10) NULL,
  REPORT_1099_FLAG varchar2(1) NULL,
  MIDDLE_NAME varchar2(50) NULL,
  TITLE varchar2(50) NULL,
  NAICS_CODE varchar2(25)NULL,
  RM_USER_ID number(10) NULL,
  FREEZE_PAYMENTS varchar2(1) NULL,
  ORGANIZATION_TYPE varchar2(25)NULL,
  NPI_NUMBER varchar2(10) NULL,
  HTMLCOMMENTS varchar2(4000) NULL,
  AUTO_DISCOUNT number (8,2) NULL,
  DISCOUNT_FLAG varchar2(1) NULL,
  FROI_ACORD_PASSWORD varchar2(15) NULL,
  TIME_ZONE_TRACKING varchar2(1) NULL,
  TIME_ZONE_CODE varchar2(25) NULL,
  CONF_FLAG varchar2(1) NULL,
  CONF_EVENT_ID number (10)NULL,
  ENTITY_APPROVAL_STATUS varchar2(25) NULL,
  ENTITY_REJECT_COMMENTS varchar2(4000) NULL,
  ENTITY_REJECT_HTMLCOMMENTS varchar2(4000) NULL,
  OVERRIDE_OFAC_CHECK varchar2(1) NULL,
  ORG_CURR_CODE varchar2(25) NULL,
  HOSPITAL_AMT number(8,2) NULL,
  HOSPITAL_LINES varchar2(25) NULL,
  MEDICAL_AMT number(8,2) NULL,
  MEDICAL_LINES varchar2(25) NULL,
  REFERENCE_NUMBER varchar2(50) NULL,
  CLIENT_SEQ_NUM varchar2(30) NULL,
  ADDRESS_SEQ_NUM number(10) NULL,
  PREFIX varchar2(25)NULL,
  SUFFIX_COMMON varchar2(25)NULL,
  SUFFIX_LEGAL varchar2(50) NULL,
  ID_TYPE varchar2(25) NULL,
  LEGAL_NAME varchar2(50) NULL,
  EFFECTIVE_DATE varchar2(10) NULL,
  EXPIRATION_DATE varchar2(10) NULL,
  NAME_TYPE varchar2(25) NULL,
  ASSIGNADJ_EID varchar2(25) NULL,
  PARENT_ABBREV varchar2(25) NULL,
  ENTITY_ID_TYPE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  ENTITY_ID_NUMBER varchar2(50) NULL,
  ENT_EFFECTIVE_DATE varchar2(8) NULL,
  ENT_EXPIRATION_DATE varchar2(8) NULL			-- end kkaur25 14.2 enh
  )';
END IF;
END;
--==========================================================
---CREATE ENTITY_EXPOSURE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='ENTITY_EXPOSURE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE ENTITY_EXPOSURE';
 iExists := 0 ;
END IF;
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE ENTITY_EXPOSURE(
        OPTIONSET_ID number(10) NULL,
        EXPOSURE_ROW_ID number(10) NULL,
	ORG_TABLE_ID number(10) NULL,
	ABBREVIATION varchar2(25) NULL,
	START_DATE varchar2(8) NULL,
	END_DATE varchar2(8) NULL,
	NO_OF_EMPLOYEES number(10) NULL,
	NO_OF_WORK_HOURS number(10) NULL,
	PAYROLL_AMOUNT number(8,2) NULL,
	ASSET_VALUE number(8,2) NULL,
	SQUARE_FOOTAGE number(10) NULL,
	VEHICLE_COUNT number(10) NULL,
	TOTAL_REVENUE number(8,2) NULL,
	OTHER_BASE number(8,2) NULL,
	RISK_MGMT_OVERHEAD number(8,2) NULL
	)';
END IF;
END;


--==========================================================
---CREATE VEHICLE_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='VEHICLE_SUPP';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE VEHICLE_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE VEHICLE_SUPP(
OPTIONSET_ID number NULL,
  VIN_TEXT varchar2(255) NULL,
  SSN_TEXT varchar2(255) NULL,
  OP_LAST_TEXT varchar2(255) NULL,
  OP_FIRST_TEXT varchar2(255) NULL,
  MANUF_TEXT varchar2(255) NULL,
  ODOMETER_NUM varchar2(255) NULL,
  UNIT_MEMO varchar2(4000) NULL,
  UNIT_NUM varchar2(255) NULL,
  RDSURFACE_CODE varchar2(255) NULL,
  UNIT_TEXT varchar2(255) NULL,
        UNIT_ID number NULL
)';
END IF;
END;
--==========================================================
---CREATE UNIT_X_CLAIM table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='UNIT_X_CLAIM';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE UNIT_X_CLAIM';
 iExists := 0 ;
END IF;


IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE UNIT_X_CLAIM(
  OPTIONSET_ID number NULL,
        UNIT_ID number NULL,
  CLAIM_ID varchar2(25) NULL,
  VEHICLE_MAKE varchar2(20) NULL,
  VEHICLE_YEAR number NULL,
  HOME_DEPT_EID varchar2(25) NULL,
  LICENSE_NUMBER varchar2(20) NULL,
  STATE_ID varchar2(6) NULL,
  DAMAGE varchar2(4000) NULL,
  UNIT_TYPE_CODE varchar2(25) NULL,
  VIN varchar2(50) NULL,
  ISINSURED varchar2(2) NULL, -- Newly Added - 23Jun2014 - Kapil
  ESTDAMAGE float NULL, -- Newly Added - 23Jun2014 - Kapil
  OWNER_LAST_NAME varchar2(100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  OWNER_FIRST_NAME varchar2(50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  OWNER_TAX_ID varchar2(20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  ISDRIVABLE varchar2(2) NULL, -- Newly Added - 23Jun2014 - Kapil
  ISNONVEHICLEPROPERTYDAMAGE varchar2(2) NULL, -- Newly Added - 23Jun2014 - Kapil
  OTHERINSURANCE varchar2(2) NULL, -- Newly Added - 23Jun2014 - Kapil
  POLHOLDERISPROPERTYOWNER varchar2(2) NULL, -- Newly Added - 23Jun2014 - Kapil 
  POLICYHOLDER_LAST_NAME varchar2(100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  POLICYHOLDER_FIRST_NAME varchar2(50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  POLICYHOLDER_TAX_ID varchar2(20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  COMPANY_LAST_NAME varchar2(100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  COMPANY_FIRST_NAME varchar2(50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  COMPANY_TAX_ID varchar2(20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  SEENAT CLOB NULL, -- Newly  Added - 23Jun2014 - Kapil
  DATEREPORTED varchar2(8) NULL, -- Newly Added - 23Jun2014 - Kapil
  TIMEREPORTED varchar2(6) NULL, -- Newly Added - 23Jun2014 - Kapil
  POLICYNUMBER varchar2(10) NULL, -- Newly Added - 23Jun2014 - Kapil
  COVERAGES clob NULL, -- Newly Added - 23Jun2014 - Kapil
  LIMITS varchar(50) NULL, -- Newly Added - 23Jun2014 - Kapil
  ASSIGNADJ_LAST_NAME varchar2(100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  ASSIGNADJ_FIRST_NAME varchar2(50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
  ASSIGNADJ_TAX_ID varchar2(20) NULL -- Newly Added - 23Jun2014 - Kapil  --
  
)';
END IF;
END;
--==========================================================
---CREATE VEHICLE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='VEHICLE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE VEHICLE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE VEHICLE(
  OPTIONSET_ID number NULL,
  DISPOSAL_DATE varchar2(8) NULL,
  LEASE_AMOUNT float NULL,
  LEASE_EXPIRE_DATE varchar2(8) NULL,
  LEASE_FLAG varchar2(1) NULL,
  LEASE_NUMBER varchar2(50) NULL,
  LEASE_TERM number NULL,
  LEASING_CO_EID varchar2(50) NULL,
  LICENSE_RNWL_DATE varchar2(8) NULL,
  VEHICLE_MODEL varchar2(50) NULL,
        UNIT_ID number NULL,
  VEHICLE_MAKE varchar2(20) NULL,
  VEHICLE_YEAR number NULL,
  UNIT_TYPE_CODE varchar2(25) NULL,
  HOME_DEPT_EID varchar2(50) NULL,
  LICENSE_NUMBER varchar2(20) NULL,
  STATE_ID varchar2(6) NULL,
  GROSS_WEIGHT float NULL,
  VIN varchar2(50) NULL,
  ORIGINAL_COST float NULL,
  PURCHASE_DATE varchar2(8) NULL,
  DEDUCTIBLE float NULL,
  LAST_SERVICE_DATE varchar2(8) NULL,
  TYPE_OF_SERVICE varchar2(4000) NULL,   -- Newly Added - 23Jun2014 - Kapil
  INSURANCE_COVERAGE varchar2(4000) NULL, -- Newly Added - 23Jun2014 - Kapil
  VEH_DESC varchar(300) NULL  -- Newly Added - 23Jun2014 - Kapil
)';
END IF;
END;

--==========================================================
---CREATE VEHICLE_X_ACC_DATE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='VEHICLE_X_ACC_DATE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE VEHICLE_X_ACC_DATE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE VEHICLE_X_ACC_DATE(
OPTIONSET_ID number NULL,
        UNIT_ID number NULL,
  ACCIDENT_DATE varchar2(8) NULL,
  CLAIM_ID varchar2(20) NULL
)';
END IF;
END;

--==========================================================
---CREATE VEHICLE_X_INSPCT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='VEHICLE_X_INSPCT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE VEHICLE_X_INSPCT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE VEHICLE_X_INSPCT(
OPTIONSET_ID number NULL,
        UNIT_ID number NULL,
  INSPECTION_DATE varchar2(8) NULL,
  INSPECTION_RESULT varchar2(255) NULL
)';
END IF;
END;
--==========================================================
---CREATE MED_STAFF table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='MED_STAFF';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE MED_STAFF';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE MED_STAFF(
  OPTIONSET_ID number(10) NULL,
        MED_STAFF_NUMBER varchar2(50) NULL,
  LAST_NAME varchar2(50) NULL,
  FIRST_NAME varchar2(50) NULL,
  TAX_ID varchar2(20) NULL,
  ABBREVIATION varchar2(25) NULL,
  ALSO_KNOWN_AS varchar2(20) NULL,
  ADDRESS_TYPE_CODE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  ADDRESS_SEQ_NUM number(10) NULL,  
  ADDR1 varchar2(50) NULL,
  ADDR2 varchar2(50) NULL,
  CITY varchar2(50) NULL,
  COUNTY varchar2(30) NULL,
  STATE_ID varchar2(25) NULL,
  ZIP_CODE varchar2(10) NULL,
  COUNTRY_CODE varchar2(25) NULL,
  PHONE1 varchar2(30) NULL,
  PHONE2 varchar2(30) NULL,
  FAX_NUMBER varchar2(20) NULL,
  EMAIL_ADDRESS varchar2(25) NULL,
  SEX_CODE varchar2(25) NULL,
  CONTACT_TYPE_CODE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  CONTACT_NAME varchar2(50) NULL,
  CONTACT_TITLE varchar2(50) NULL,
  CONTACT_INITIALS varchar2(10) NULL,
  CONTACT_ADDR1 varchar2(50) NULL,
  CONTACT_ADDR2 varchar2(50) NULL,
  CONTACT_CITY varchar2(50) NULL,
  CONTACT_STATE_ID varchar2(25) NULL,
  CONTACT_ZIP_CODE varchar2(10) NULL,
  CONTACT_PHONE varchar2(30) NULL,
  CONTACT_FAX_NUMBER varchar2(30) NULL,
  CONTACT_EMAIL_ADDRESS varchar2(25) NULL,		-- end kkaur25 14.2 enh
  BIRTH_DATE varchar2(8) NULL,
  PRIMARY_POLICY_NUMBER varchar2(50) NULL,
  HOME_ADDR1 varchar2(50) NULL,
  HOME_ADDR2 varchar2(50) NULL,
  HOME_CITY varchar2(50) NULL,
  HOME_STATE_ID varchar2(25) NULL,
  HOME_ZIP_CODE varchar2(10) NULL,
  MARITAL_STAT_CODE varchar2(25) NULL,
  BEEPER_NUMBER varchar2(30) NULL,
  CELLULAR_NUMBER varchar2(30) NULL,
  EMERGENCY_CONTACT varchar2(30) NULL,
  STAFF_STATUS_CODE varchar2(25) NULL,
  STAFF_POS_CODE varchar2(25) NULL,
  STAFF_CAT_CODE varchar2(25) NULL,
  DEPT_ASSIGNED_EID varchar2(25) NULL,
  HIRE_DATE varchar2(8) NULL,
  LIC_NUM varchar2(20) NULL,
  LIC_STATE varchar2(25) NULL,
  LIC_ISSUE_DATE varchar2(8) NULL,
  LIC_EXPIRY_DATE varchar2(8) NULL,
  LIC_DEA_NUM varchar2(20) NULL,
  LIC_DEA_EXP_DATE varchar2(8) NULL,
  ENTITY_ID_TYPE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  ENTITY_ID_NUMBER varchar2(50) NULL,
  ENT_EFFECTIVE_DATE varchar2(8) NULL,
  ENT_EXPIRATION_DATE varchar2(8) NULL			-- end kkaur25 14.2 enh

)';
END IF;
END;

--==========================================================
---CREATE STAFF_CERTS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='STAFF_CERTS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE STAFF_CERTS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE STAFF_CERTS(
  OPTIONSET_ID number(10) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  NAME_CODE varchar2(25) NULL,
  INT_DATE varchar2(8) NULL,
  END_DATE varchar2(8) NULL

)';
END IF;
END;
--==========================================================
---CREATE STAFF_PRIVS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='STAFF_PRIVS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE STAFF_PRIVS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE STAFF_PRIVS(
  OPTIONSET_ID number(10) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  CATEGORY_CODE varchar2(25) NULL,
  TYPE_CODE varchar2(25) NULL,
  STATUS_CODE varchar2(25) NULL,
  INT_DATE varchar2(8) NULL,
  END_DATE varchar2(8) NULL

)';
END IF;
END;
--==========================================================
---CREATE MED_STAFF_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='MED_STAFF_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE MED_STAFF_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE MED_STAFF_SUPP(
  OPTIONSET_ID number(10) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL

)';
END IF;
END;

--==========================================================
---CREATE PATIENT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT(
        OPTIONSET_ID number(10) NULL,
  PATIENT_ACCT_NO varchar2(20) NULL,
  MEDICAL_RCD_NO varchar2(20) NULL,
  LAST_NAME varchar2(50) NULL,
  FIRST_NAME varchar2(50) NULL,
  TAX_ID varchar2(20) NULL,
  ABBREVIATION varchar2(25) NULL,
  ALSO_KNOWN_AS varchar2(50) NULL,
  ADDRESS_TYPE_CODE varchar2(25) NULL,				-- start kkaur25 14.2 enh
  ADDRESS_SEQ_NUM number(10) NULL,  
  ADDR1 varchar2(50) NULL,
  ADDR2 varchar2(50) NULL,
  CITY varchar2(50) NULL,
  COUNTY varchar2(30) NULL,
  STATE_ID varchar2(25) NULL,
  COUNTRY_CODE varchar2(25) NULL,
  ZIP_CODE varchar2(10) NULL,
  PHONE1 varchar2(30) NULL,
  PHONE2 varchar2(30) NULL,
  FAX_NUMBER varchar2(20) NULL,
  EMAIL_ADDRESS varchar2(25) NULL,
  SEX_CODE varchar2(25) NULL,
  CONTACT_TYPE_CODE varchar2(25) NULL,			-- start kkaur25 14.2 enh
  CONTACT_NAME varchar2(50) NULL,
  CONTACT_TITLE varchar2(50) NULL,
  CONTACT_INITIALS varchar2(10) NULL,
  CONTACT_ADDR1 varchar2(50) NULL,
  CONTACT_ADDR2 varchar2(50) NULL,
  CONTACT_CITY varchar2(50) NULL,
  CONTACT_STATE_ID varchar2(25) NULL,
  CONTACT_ZIP_CODE varchar2(10) NULL,
  CONTACT_PHONE varchar2(30) NULL,
  CONTACT_FAX_NUMBER varchar2(30) NULL,
  CONTACT_EMAIL_ADDRESS varchar2(25) NULL,		-- end kkaur25 14.2 enh
  BIRTH_DATE varchar2(8) NULL,  
  DATE_OF_ADMISSION varchar2(8) NULL,
  TIME_OF_ADMISSION varchar2(6) NULL,
  DATE_OF_DISCHARGE varchar2(8) NULL,
  TIME_OF_DISCHARGE varchar2(6) NULL,
  ADMISSION_REASON varchar2(4000) NULL,
  ADM_TYPE_CODE varchar2(25) NULL,
  ADM_SOURCE_CODE varchar2(25) NULL,
  ACUITY_LEVEL_CODE varchar2(25) NULL,
  CARDIAC_ARREST varchar2(1) NULL,
  PATIENT_STAT_CODE varchar2(25) NULL,
  PATIENT_COND_CODE varchar2(25) NULL,
  DISCHARGE_DSP_CODE varchar2(25) NULL,
  EXP_LENGTH_OF_STAY number(10) NULL,
  EXPECTED_COST float NULL,
  INS_PLAN_GROUP_NO varchar2(16) NULL,
  QI_SIGNIF_CODE varchar2(25) NULL,
  EPISODE_OF_CARE_ID varchar2(8) NULL,
  PATIENT_TYPE_CODE varchar2(25) NULL,
  HEIGHT float NULL,
  WEIGHT float NULL,
  MARITAL_STAT_CODE varchar2(25) NULL,
  RACE_ENTH_CODE varchar2(25) NULL,
  DATE_OF_DEATH varchar2(8) NULL,
  PRIMARY_PAY_CODE varchar2(25) NULL,
  SECOND_PAY_CODE varchar2(25) NULL,  
  EMERGENCY_CONTACT varchar2(20) NULL,
  EMERGENCY_CONT_NO varchar2(20) NULL,
  PATIENT_ROOM_NO varchar2(14) NULL,
  FACILITY_UNIT_CODE varchar2(25) NULL,
  FACILITY_DEPT_EID varchar2(25) NULL,
  HCO_ID_NO varchar2(20) NULL,
  HCO_SITE_ID_NO varchar2(20) NULL,
  PRI_PHYS_LAST_NAME varchar2(50) NULL,
  PRI_PHYS_FIRST_NAME varchar2(50) NULL,
  PRI_PHYS_TAX_ID varchar2(20) NULL,
  PRI_PHYS_NUMBER varchar2(50) NULL,
  ADM_PHYS_LAST_NAME varchar2(50) NULL,
  ADM_PHYS_FIRST_NAME varchar2(50) NULL,
  ADM_PHYS_TAX_ID varchar2(20) NULL,  
  ADM_PHYS_NUMBER varchar2(50) NULL,
  NB_APGAR_SCORE number(10) NULL,
  NB_BIRTH_WEIGHT float NULL,
  NB_LEN_OF_GEST number(10) NULL,
  NB_NICU_STAY varchar2(1) NULL,
  NB_NICU_ADM_DATE varchar2(8) NULL,
  NB_NICU_DISCH_DATE varchar2(8) NULL,
  NB_CEPHALIC_MOLD varchar2(1) NULL,
  NB_EPS_OF_CARE_ID varchar2(8) NULL,
  NBM_PARITY number(10) NULL,
  NBM_PRIOR_C_SECT varchar2(1) NULL,
  NBM_MED_IND_LABOR varchar2(1) NULL,
  NBM_LIVE_BIRTHS number(10) NULL,
  NBM_STILL_BIRTHS number(10) NULL,
  NBM_GRAVIDA number(10) NULL,  
  NBM_EPS_OF_CARE_ID varchar2(8) NULL,  
  DISABILITY_CODE varchar2(25) NULL,
  ILLNESS_CODE varchar2(25) NULL,
  LOST_CONSC_FLAG varchar2(1) NULL,
  WHY_AT_FACILITY varchar2(225) NULL,
  ENTITY_ID_TYPE varchar2(25) NULL,				-- start kkaur25 14.2 enh
  ENTITY_ID_NUMBER varchar2(50) NULL,
  ENT_EFFECTIVE_DATE varchar2(8) NULL,
  ENT_EXPIRATION_DATE varchar2(8) NULL				-- end kkaur25 14.2 enh

)';
END IF;
END;
--==========================================================
---CREATE PATIENT_PROCEDURE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_PROCEDURE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_PROCEDURE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_PROCEDURE(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  PROCEDURE_CODE varchar2(25) NULL,
  PROC_TYPE_CODE varchar2(25) NULL,
  DATE_OF_PROCEDURE varchar2(8) NULL,
  SURGEON_LAST_NAME varchar2(50) NULL,
  SURGEON_FIRST_NAME varchar2(50) NULL,
  SURGEON_TAX_ID varchar2(20) NULL,  
  SURGEON_PHYS_NUMBER varchar2(50) NULL,
  ANESTH_ADMIN_FLAG varchar2(1) NULL,
  ANESTH_TYPE_CODE varchar2(25) NULL,
  ANESTH_LAST_NAME varchar2(50) NULL,
  ANESTH_FIRST_NAME varchar2(50) NULL,
  ANESTH_TAX_ID varchar2(20) NULL,
  ASA_PS_CLASS_CODE varchar2(25) NULL,
  COMPLICATION_DATE varchar2(8) NULL,
  PRIOR_TO_ANES_FLAG varchar2(1) NULL,
  ICC_LEVEL_CODE varchar2(25) NULL,
  LEN_OF_TIME float NULL,
  COMPLICATIONS varchar2(4000) NULL

)';
END IF;
END;
--==========================================================
---CREATE PATIENT_PROCEDURE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_ACT_TAKEN';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_ACT_TAKEN';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_ACT_TAKEN(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  ACTION_CODE varchar2(25) NULL

)';
END IF;
END;
--==========================================================
---CREATE PATIENT_ATTN_PHYS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_ATTN_PHYS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_ATTN_PHYS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_ATTN_PHYS(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  PHYS_LAST_NAME varchar2(50) NULL,
  PHYS_FIRST_NAME varchar2(50) NULL,
  PHYS_TAX_ID varchar2(20) NULL,
  PHYS_NUMBER varchar2(50) NULL

)';
END IF;
END;
--==========================================================
---CREATE PATIENT_DIAGNOSIS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_DIAGNOSIS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_DIAGNOSIS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_DIAGNOSIS(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  DIAGNOSIS_CODE varchar2(25) NULL
)';
END IF;
END;
--==========================================================
---CREATE PATIENT_DRG_CODES table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_DRG_CODES';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_DRG_CODES';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_DRG_CODES(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  DRG_CODE varchar2(25) NULL
)';
END IF;
END;
--==========================================================
---CREATE PATIENT_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_SUPP(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL

)';
END IF;
END;
--==========================================================
---CREATE PATIENT_PROC_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_PROC_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_PROC_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_PROC_SUPP(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  PROCEDURE_CODE varchar2(25) NULL

)';
END IF;
END;
--==========================================================
---CREATE PHYSICIAN table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYSICIAN';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYSICIAN';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYSICIAN(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL,
  MEDICARE_NUMBER varchar2(20) NULL,
  LAST_NAME varchar2(50) NULL,
  FIRST_NAME varchar2(50) NULL,
  TAX_ID varchar2(20) NULL,
  ABBREVIATION varchar2(25) NULL,
  ALSO_KNOWN_AS varchar2(20) NULL,
  ADDRESS_TYPE_CODE varchar2(25) NULL,				-- start kkaur25 14.2 enh
  ADDRESS_SEQ_NUM number(10) NULL,  
  ADDR1 varchar2(50) NULL,
  ADDR2 varchar2(50) NULL,
  CITY varchar2(50) NULL,
  COUNTY varchar2(30) NULL,
  STATE_ID varchar2(25) NULL,
  ZIP_CODE varchar2(10) NULL,
  COUNTRY_CODE varchar2(25) NULL,
  PHONE1 varchar2(30) NULL,
  PHONE2 varchar2(30) NULL,
  FAX_NUMBER varchar2(20) NULL,
  EMAIL_ADDRESS varchar2(25) NULL,
  SEX_CODE varchar2(25) NULL,
  CONTACT_TYPE_CODE varchar2(25) NULL,				-- start kkaur25 14.2 enh
  CONTACT_NAME varchar2(50) NULL,
  CONTACT_TITLE varchar2(50) NULL,
  CONTACT_INITIALS varchar2(10) NULL,
  CONTACT_ADDR1 varchar2(50) NULL,
  CONTACT_ADDR2 varchar2(50) NULL,
  CONTACT_CITY varchar2(50) NULL,
  CONTACT_STATE_ID varchar2(25) NULL,
  CONTACT_ZIP_CODE varchar2(10) NULL,
  CONTACT_PHONE varchar2(30) NULL,
  CONTACT_FAX_NUMBER varchar2(30) NULL,
  CONTACT_EMAIL_ADDRESS varchar2(25) NULL,			-- end kkaur25 14.2 enh
  BIRTH_DATE varchar2(8) NULL,
  MARITAL_STAT_CODE varchar2(25) NULL,
  HOME_ADDR1 varchar2(50) NULL,
  HOME_ADDR2 varchar2(50) NULL,
  HOME_CITY varchar2(50) NULL,
  HOME_STATE_ID varchar2(25) NULL,
  HOME_ZIP_CODE varchar2(10) NULL,
  BEEPER_NUMBER varchar2(30) NULL,
  CELLULAR_NUMBER varchar2(30) NULL,
  MAILING_ADDR1 varchar2(50) NULL,
  MAILING_ADDR2 varchar2(50) NULL,
  MAILING_CITY varchar2(50) NULL,
  MAILING_STATE_ID varchar2(25) NULL,
  MAILING_ZIP_CODE varchar2(10) NULL,
  EMERGENCY_CONTACT varchar2(30) NULL,
  STAFF_STATUS_CODE varchar2(25) NULL,
  STAFF_TYPE_CODE varchar2(25) NULL,
  STAFF_CAT_CODE varchar2(25) NULL,
  DEPT_ASSIGNED_EID varchar2(25) NULL,
  PRIMARY_SPECIALTY varchar2(25) NULL,
  PRIMARY_POLICY_NUMBER varchar2(50) NULL,
  APPOINT_DATE varchar2(8) NULL,
  REAPPOINT_DATE varchar2(8) NULL,
  LIC_STATE varchar2(25) NULL,
  LIC_NUM varchar2(20) NULL,
  LIC_ISSUE_DATE varchar2(8) NULL,
  LIC_EXPIRY_DATE varchar2(8) NULL,
  LIC_DEA_NUM varchar2(20) NULL,
  LIC_DEA_EXP_DATE varchar2(8) NULL,
  MEMBERSHIP varchar2(20) NULL,
  CONT_EDUCATION varchar2(20) NULL,
  TEACHING_EXP varchar2(20) NULL,
  REPORT_1099_FLAG varchar2(1) NULL,
  PARENT_1099_PHYSICIAN_NUMBER varchar2(50) NULL,
  PARENT_1099_TABLE_NAME varchar2(18) NULL,
  PARENT_1099_LAST_NAME varchar2(50) NULL,
  PARENT_1099_TAX_ID varchar2(20) NULL,
  NPI_NUMBER varchar2(10) NULL,
  ENTITY_ID_TYPE varchar2(25) NULL,				-- start kkaur25 14.2 enh
  ENTITY_ID_NUMBER varchar2(50) NULL,
  ENT_EFFECTIVE_DATE varchar2(8) NULL,
  ENT_EXPIRATION_DATE varchar2(8) NULL				-- end kkaur25 14.2 enh	
)';
END IF;
END;
--==========================================================
---CREATE PATIENT_PROC_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PATIENT_PROC_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PATIENT_PROC_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PATIENT_PROC_SUPP(
  OPTIONSET_ID number(10) NULL,
      PATIENT_ACCT_NO varchar2(20) NULL,
  PROCEDURE_CODE varchar2(25) NULL

)';
END IF;
END;
--==========================================================
---CREATE PHYS_CERTS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_CERTS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_CERTS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_CERTS(
  OPTIONSET_ID NUMBER NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  NAME_CODE varchar2(25) NULL,
  STATUS_CODE varchar2(25) NULL,
  BOARD_CODE varchar2(25) NULL,
  INT_DATE varchar2(8) NULL,
  END_DATE varchar2(8) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL
)';
END IF;
END;
--==========================================================
---CREATE PHYS_EDUCATION table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_EDUCATION';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_EDUCATION';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_EDUCATION(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  EDUC_TYPE_CODE varchar2(25) NULL,
  INSTITUTION_NAME varchar2(50) NULL,
  DEGREE_TYPE varchar2(25) NULL,
  DEGREE_DATE varchar2(8) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL
)';
END IF;
END;
--==========================================================
---CREATE PHYS_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_SUPP(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL
)';
END IF;
END;
--==========================================================
---CREATE PHYS_PREV_HOSP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_PREV_HOSP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_PREV_HOSP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_PREV_HOSP(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  STATUS_CODE varchar2(25) NULL,
  HOSPITAL_NAME varchar2(50) NULL,
  PRIV_CODE varchar2(25) NULL,
  INT_DATE varchar2(8) NULL,
  END_DATE varchar2(8) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL
)';
END IF;
END;
--==========================================================
---CREATE PHYS_PRIVS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_PRIVS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_PRIVS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_PRIVS(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  CATEGORY_CODE varchar2(25) NULL,
  TYPE_CODE varchar2(25) NULL,
  STATUS_CODE varchar2(25) NULL,
  INT_DATE varchar2(8) NULL,
  END_DATE varchar2(8) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL
)';
END IF;
END;

--==========================================================
---CREATE PHYS_SUB_SPECIALTY table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PHYS_SUB_SPECIALTY';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PHYS_SUB_SPECIALTY';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PHYS_SUB_SPECIALTY(
  OPTIONSET_ID number NULL,
        PHYSICIAN_NUMBER varchar2(50) NULL,
  SPECIALTY_CODE varchar2(25) NULL,
  MED_STAFF_NUMBER varchar2(50) NULL,
  INTERNAL_NUMBER varchar2(20) NULL
)';
END IF;
END;


--==========================================================
---CREATE RESERVES table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='RESERVES';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE RESERVES';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE RESERVES(
	OPTIONSET_ID number NULL,
        RESERVE_ID number NULL,
	CLAIM_ID varchar2(25) NULL,
	RESERVE_TYPE_CODE varchar2(25) NULL,
	AMOUNT number NULL,
	RESERVE_DATE varchar2(8) NULL,
	ENTERED_BY_USER varchar2(50) NULL,
	REASON varchar2(30) NULL,
	CLAIMANT_LAST varchar2(50) NULL,
	CLAIMANT_FIRST varchar2(50) NULL,
	UNIT_ID varchar2(8) NULL,
	RES_STATUS_CODE varchar2(25) NULL,
	UNIT_TYPE varchar2(25) NULL,
	POLICY_NAME varchar2(25) NULL,
	UNIT_NUMBER varchar2(25) NULL,
	COVERAGE_CODE varchar2(25) NULL,
	LOSS_DISABILITY_CODE varchar2(25) NULL,
	RESERVE_SUB_TYPE varchar2(30) NULL,
	DISABILITY_TYPE_CATEGORY varchar2(25) NULL,
	MODULE_NO varchar2(25) NULL,
	CLASS_CODE varchar2(25) NULL,
	CVG_SEQUENCE_NO varchar2(25) NULL,
	TRANS_SEQ_NO varchar2(25) NULL,
	CVG_DESC varchar2(100) NULL,
	SUBLINE_DESC varchar2(100) NULL,
	CLASS_DESC varchar2(100) NULL,
	STAT_UNIT_NUMBER varchar2(25) NULL,
	POLICY_CVG_SEQNO varchar2(25) NULL,
      	UPDATED_BY_USER varchar2(50) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	CRC number NULL,
	CLAIM_CURR_CODE number NULL,
	CLAIM_TO_BASE_CUR_RATE number NULL,
	CLAIM_CURRENCY_RESERVE_AMOUNT number NULL,
	CLAIM_CURRENCY_INCURRED_AMT number NULL,
	CLAIM_CURR_COLLECTION_TOTAL number NULL,
	CLAIM_CURRENCY_PAID_TOTAL number NULL,
	CLAIM_CURRENCY_BALANCE_AMT number NULL,
	BASE_TO_CLAIM_CUR_RATE number NULL,
	ADJ_FIRST_NAME varchar2(50) NULL,
	ADJ_LAST_NAME varchar2(100) NULL,
	ADJ_TAX_ID varchar2(20) NULL
)';
END IF;
END;

--==========================================================
---CREATE FUNDS_DEPOSIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='FUNDS_DEPOSIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE FUNDS_DEPOSIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE FUNDS_DEPOSIT(
	OPTIONSET_ID number NULL,
        DEPOSIT_ID number NULL,
	CTL_NUMBER varchar2(25) NULL,
	BANK_ACC_ID varchar2(20) NULL,
	SUB_ACC_ID varchar2(20) NULL,
	TRANS_DATE varchar2(8) NULL,
	AMOUNT float NULL,
	CLEARED_FLAG varchar2(1) NULL,
	VOID_FLAG varchar2(1) NULL,
	ADDED_BY_USER varchar2(50) NULL, -- Added for DA DIS Enhancement
	DTTM_RCD_ADDED varchar2(14) NULL, -- Added for DA DIS Enhancement
	UPDATED_BY_USER varchar2(50) NULL, -- Added for DA DIS Enhancement
	DTTM_RCD_LAST_UPD varchar2(14) NULL, -- Added for DA DIS Enhancement
	DESCRIPTION clob NULL, -- field size changed as it is a descriptive column from 40 to 4000
	VOIDCLEAR_DATE varchar2(8) NULL,
	DEPOSIT_TYPE varchar2(1) NULL,
	ADJUST_CODE varchar2(25) NULL
)';
END IF;
END;




---CREATE POLICY table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POLICY';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE POLICY';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POLICY(
  	OPTIONSET_ID number(10) NULL,        
	ADDED_BY_USER varchar2(50) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	POLICY_ID number(10) NULL,
	POLICY_NAME varchar2(20) NULL,
	POLICY_NUMBER varchar2(20) NULL,
	POLICY_STATUS_CODE varchar2(25) NULL,
	INSURER_EID varchar2(25)NULL,
	ISSUE_DATE varchar2(8) NULL,
	REVIEW_DATE varchar2(8) NULL,
	RENEWAL_DATE varchar2(8) NULL,
	EFFECTIVE_DATE varchar2(8) NULL,
	EXPIRATION_DATE varchar2(8) NULL,
	CANCEL_DATE varchar2(8) NULL,
	PREMIUM number(8,2) NULL,
	TRIGGER_CLAIM_FLAG varchar2(1) NULL,
	PRIMARY_POLICY_FLG varchar2(1) NULL,
	COMMENTS varchar2(4000) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	BROKER_EID varchar2(25) NULL,
	BANK_ACC_ID number(10) NULL,
	SUB_ACC_ROW_ID number(10) NULL,
	HTMLCOMMENTS varchar2(4000) NULL,
	ALL_STATES_FLAG varchar2(1) NULL,
	POLICY_SYSTEM_NAME varchar2(25) NULL,
	POLICY_TYPE varchar2(25) NULL,
	POLICY_SYMBOL varchar2(20) NULL,
	EXTERNAL_POLICY_ID varchar2(20) NULL,
	CURRENCY_CODE varchar2(25) NULL,
	POLICY_LOB_CODE varchar2(25) NULL,
	MODULE_INFO varchar2(10) NULL,
	MASTER_COMPANY varchar2(10) NULL,
	LOCATION_COMPANY varchar2(10) NULL,
	BRANCH_CODE varchar2(50) NULL,
	CLAIM_NUMBER varchar2(50) NULL
)';
END IF;
END;

--==========================================================
---CREATE POLICY_X_CVG_TYPE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POLICY_X_CVG_TYPE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE POLICY_X_CVG_TYPE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POLICY_X_CVG_TYPE(
  	OPTIONSET_ID number(10) NULL,
       	CLAIM_LIMIT number(8,2) NULL,
	NOTIFICATION_UID number(10) NULL,
	POLCVG_ROW_ID number(10) NULL,
	POLICY_ID number(10) NULL,
	COVERAGE_TYPE_CODE varchar2(25) NULL,
	POLICY_LIMIT number(8,2) NULL,
	OCCURRENCE_LIMIT number(8,2) NULL,
	TOTAL_PAYMENTS number(8,2) NULL,
	REMARKS varchar2 (4000) NULL,
	EXCEPTIONS varchar2 (4000) NULL,
	CANCEL_NOTICE_DAYS number(10) NULL,
	SELF_INSURE_DEDUCT number(8,2) NULL,
	NEXT_POLICY_ID number(10) NULL,
	BROKER_NAME varchar2(100) NULL,
	SECTION_NUMBER_CODE varchar2(25) NULL,
	PER_PERSON_LIMIT number(8,2) NULL,
	EFFECTIVE_DATE varchar2(8) NULL,
	EXPIRATION_DATE varchar2(8) NULL,
	LIMIT number(8,2) NULL,
	ORIGINAL_PREMIUM number(8,2) NULL,
	WRITTEN_PREMIUM number(8,2) NULL,
	FULL_TERM_PREMIUM number(8,2) NULL,
	TOTAL_WRITTEN_PREMIUM number(8,2) NULL,
	EXPOSURE number(8,2) NULL,
	CHANGE_DATE varchar2(8) NULL,
	CVG_SEQUENCE_NO varchar2(8) NULL,
	TRANS_SEQ_NO varchar2(8) NULL,	
	COVERAGE_CLASS_CODE varchar2(20) NULL,
	WC_DED_AMT number(8,2) NULL,
	WC_DED_AGGR number(8,2) NULL,
	PRODLINE varchar2(50) NULL,
	ASLINE varchar2(50) NULL,
	SUB_LINE varchar2(3) NULL,
	DED_TYPE_CODE varchar2(25) NULL,
	UNIT_ID number(10) NULL,
	COVERAGE_CODE_DESCRIPTION varchar2(100) NULL,
	CLASS_CODE_DESCRIPTION varchar2(100) NULL,
	SUBLINE_DESCRIPTION varchar2(100) NULL,
	REINSURANCE_CODE nvarchar2 (25) NULL,
	RETRO_DATE varchar2 (8) NULL,
	TAIL_DATE varchar2 (8) NULL

)';
END IF;
END;

--==========================================================
---CREATE POLICY_X_INSURED table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POLICY_X_INSURED';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE POLICY_X_INSURED';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POLICY_X_INSURED(
  	OPTIONSET_ID number(10) NULL,
        POLICY_ID number(10) NULL,
	INSURED_EID number(10) NULL,
	LAST_NAME varchar2(100) NULL,
	FIRST_NAME varchar2(50) NULL,	
	TAX_ID varchar2(20) NULL,
	ABBREVIATION varchar2(25) NULL,
	ORG_LEVEL number(10) NULL,
	ORG_LEVEL_PARENT_ABBREVIATION varchar2(25) NULL,
	SUBLINE_DESCRIPTION varchar2(100) NULL,
CLIENT_SEQ_NUM varchar2 (30) NULL
)';
END IF;
END;


--==========================================================
---CREATE POLICY_X_INSURER table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POLICY_X_INSURER';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE POLICY_X_INSURER';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POLICY_X_INSURER(
  	--IN_ROW_ID number(10) NULL,
	OPTIONSET_ID number(10) NULL,
        POLICY_ID number(10) NULL,
	INSURER_CODE number(10) NULL,
	RES_PERCENTAGE number(8,2) NULL,
	PRIMARY_INSURER varchar2(1) NULL,
	PREMIUM_AMOUNT number(8,2) NULL,
	PART_OF_TOTAL_LAYER number(8,2) NULL,
	PORTION_OF_PART_OF_LAYER number(8,2) NULL,
	INSTAL_PAYMENT_AMT number(8,2) NULL,
	INSTAL_SCHEDULE_CODE varchar2(25) NULL,
	SPECIAL_CIRCUM_MEMO varchar2 (4000) NULL,
	LAYER_NUM_CODE varchar2(25) NULL,
	OCCURENCE_LIMIT number(8,2) NULL,
	COVERAGE_DESC varchar2(100) NULL,
	COMMENT_MEMO varchar2 (4000) NULL,
	LAST_NAME varchar2(100) NULL,
	FIRST_NAME varchar2(50) NULL,	
	TAX_ID varchar2(20) NULL,
	ABBREVIATION varchar2(25) NULL,
	CLIENT_SEQ_NUM varchar2 (30) NULL
)';
END IF;
END;








--==========================================================
---CREATE CLAIM_X_PROPERTYLOSS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CLAIM_X_PROPERTYLOSS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CLAIM_X_PROPERTYLOSS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CLAIM_X_PROPERTYLOSS(
  	OPTIONSET_ID  number(10) NULL,
	PROPERTY_ID  number(10) NULL,
	CLAIM_ID varchar2(25) NULL,
	INSURED varchar2(1) NULL,
	DAMAGE varchar2(4000)NULL,
	PROPERTYTYPE varchar2(25) NULL,
	ESTDAMAGE number(8,2) NULL,
	SEENAT varchar2(4000) NULL,
	DATEREPORTED varchar2(8) NULL,
	TIMEREPORTED varchar2(6) NULL,
	DESCRIPTION varchar2(4000) NULL,
	OWNER_LAST_NAME varchar2(100) NULL,
	OWNER_FIRST_NAME varchar2(50) NULL,	
	OWNER_TAX_ID varchar2(20) NULL,
	LOCOFTHEFT varchar2(25) NULL,
	INCENDIARYFIRE varchar2(1) NULL,
	VACANT varchar2(1) NULL,
	UNDERCONSTRUCTION varchar2(1) NULL,
	EXPENSEFROM varchar2(8) NULL,
	EXPENSETO varchar2(8) NULL,
	OTHERINSURANCE varchar2(1) NULL,
	POLHOLDERISPROPERTYOWNER varchar2(1) NULL,
	POLICYHOLDER_LAST_NAME varchar2(100) NULL,
	POLICYHOLDER_FIRST_NAME varchar2(50) NULL,	
	POLICYHOLDER_TAX_ID varchar2(20) NULL,
	COMPANY_LAST_NAME varchar2(100) NULL,
	COMPANY_FIRST_NAME varchar2(50) NULL,	
	COMPANY_TAX_ID varchar2(20) NULL,
	POLICYNUMBER varchar2(10) NULL,
	COVERAGES varchar2(4000) NULL,	
	LIMITS varchar2(50) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	ASSIGNADJ_LAST_NAME varchar2(100) NULL,
	ASSIGNADJ_FIRST_NAME varchar2(50) NULL,	
	ASSIGNADJ_TAX_ID varchar2(20) NULL

)';
END IF;
END;





--==========================================================
---CREATE CLAIM_X_PROPERTYLOSS_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CLAIM_X_PROPERTYLOSS_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CLAIM_X_PROPERTYLOSS_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CLAIM_X_PROPERTYLOSS_SUPP (
  	OPTIONSET_ID  number(10) NULL,
	ROW_ID  number(10) NULL

)';
END IF;
END;

--==========================================================
---CREATE CLAIM_X_SITELOSS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CLAIM_X_SITELOSS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CLAIM_X_SITELOSS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CLAIM_X_SITELOSS(
  	OPTIONSET_ID number(10) NULL,
	CLAIM_ID varchar2(25) NULL,
	SITE_ID number(10) NULL,
	LOSS_PREVENTION_REPRESENTATIVE varchar2(100) NULL,
	LOSS_PREVENTION_CONTACT_NAME varchar2(100) NULL,
	FAX_NUMBER varchar2(50) NULL,
	EMAIL varchar2(50) NULL,
	PRE_QUOTE_SURVEY_ORDERED_DATE varchar2(20) NULL,
	POST_BIND_SURVEY_ORDERED_DATE varchar2(20) NULL,
	LOSS_PREVENTION_RATING varchar2(20) NULL,
	LOSS_PREVENTION_LASTVISITDATE varchar2(20) NULL,
	INTERIM_AUDITOR_ID varchar2(50) NULL,
	INTERIM_AUDITOR varchar2(100) NULL,
	CHECK_AUDITOR_ID varchar2(50) NULL,
	CHECK_AUDITOR varchar2(100) NULL,
	FINAL_AUDITOR_ID varchar2(50) NULL,
	FINAL_AUDITOR varchar2(100) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	ISINSURED varchar2(1) NULL,
	ASSIGNADJ_LAST_NAME varchar2(100) NULL,
	ASSIGNADJ_FIRST_NAME varchar2(50) NULL,	
	ASSIGNADJ_TAX_ID varchar2(20) NULL
)';
END IF;
END;

--==========================================================
---CREATE PROPERTY_UNIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PROPERTY_UNIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PROPERTY_UNIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PROPERTY_UNIT(
  	OPTIONSET_ID number(10) NULL,
	UNIT_ID number(10) NULL,
	PIN varchar2(255) NULL,
	DESCRIPTION varchar2(50) NULL,
	ADDR1 varchar2(200) NULL,
	ADDR2 varchar2(50) NULL,
	CITY varchar2(50) NULL,
	STATE_ID varchar2(25) NULL,
	ZIP_CODE varchar2(10) NULL,
	CLASS_OF_CONS_CODE varchar2(25)NULL,
	YEAR_OF_CONS varchar2(25) NULL,
	WALL_CONS_CODE varchar2(25) NULL,
	ROOF_CONS_CODE varchar2(25) NULL,
	SQUARE_FOOTAGE number(8,2) NULL,
	NO_OF_STORIES number(10) NULL,
	AVG_STORY_HEIGHT number(8,2) NULL,
	HEATING_SYS_CODE varchar2(25)NULL,
	COOLING_SYS_CODE varchar2(25) NULL,
	FIRE_ALARM_CODE varchar2(25) NULL,
	SPRINKLERS_CODE varchar2(25) NULL,
	ENTRY_ALARM_CODE varchar2(25) NULL,
	PLOT_PLANS_CODE varchar2(25) NULL,
	FLOOD_ZONE_CERT_CODE varchar2(25) NULL,
	EARTHQUAKE_ZONE_CODE varchar2(25) NULL,
	GPS_LATITUDE number(8,2) NULL,
	GPS_LONGITUDE number(8,2) NULL,
	GPS_ALTITUDE number(8,2) NULL,
	ROOF_ANCHORING_CODE varchar2(25) NULL,
	GLASS_STRENGTH_CODE varchar2(25) NULL,
	APPRAISED_VALUE number(8,2) NULL,
	REPLACEMENT_VALUE number(8,2) NULL,
	--DELETED_FLAG smallint NULL,
	APPRAISED_DATE varchar2(8) NULL,
	LAND_VALUE number(8,2) NULL,
	APPRAISAL_SOURCE_CODE varchar2(25) NULL,
	CATEGORY_CODE varchar2(25) NULL,
	TERRITORY_CODE varchar2(25) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	COUNTRY_CODE varchar2(25) NULL
)';
END IF;
END;



--==========================================================
---CREATE CLAIM_X_OTHERUNIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CLAIM_X_OTHERUNIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CLAIM_X_OTHERUNIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CLAIM_X_OTHERUNIT(
  	OPTIONSET_ID number(10) NULL,
	CLAIM_ID varchar2(25) NULL,
	OTHER_UNIT_ID number(10) NULL,
	UNIT_TYPE varchar2(10) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	ISINSURED varchar2(1) NULL
)';
END IF;
END;

--==========================================================
---CREATE SITE_UNIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='SITE_UNIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE SITE_UNIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE SITE_UNIT(
  	OPTIONSET_ID number(10) NULL,
	UNIT_ID number(10) NULL,
	SITE_NUMBER varchar2(50) NULL,
	NAME varchar2(200) NULL,
	OPTIONAL varchar2(200) NULL,
	ADDR1 varchar2(200) NULL,
	ADDR2 varchar2(200) NULL,
	STATE_ID varchar2(25)  NULL,
	CITY varchar2(50) NULL,
	ZIP_CODE varchar2(10) NULL,
	COUNTRY_ID varchar2(25) NULL,
	PHONE_NUMBER varchar2(50) NULL,
	CONTACT varchar2(50) NULL,
	TAX_LOCATION varchar2(50) NULL,
	UNEMPLOYEMENT_NUMBER varchar2(50) NULL,
	NUM_OF_EMP number(10) NULL,
	FEIN varchar2(50) NULL,
	SIC varchar2(50) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL
)';
END IF;
END;


--==========================================================
---CREATE POINT_UNIT_DATA table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POINT_UNIT_DATA';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE POINT_UNIT_DATA';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POINT_UNIT_DATA(
  	OPTIONSET_ID number(10) NULL,
	POLICY_ID number(10) NULL,
	--ROW_ID number(10) NULL,
	UNIT_ID number(10) NULL,
	UNIT_TYPE varchar2(10) NULL,
	UNIT_NUMBER varchar2(10) NULL,
	UNIT_RISK_LOC varchar2(10) NULL,
	UNIT_RISK_SUB_LOC varchar2(10) NULL,
	SITE_SEQ_NUMBER varchar2(10) NULL,
	PRODUCT varchar2(50) NULL,
	INS_LINE varchar2(50) NULL,
	STAT_UNIT_NUMBER varchar2(10) NULL
)';
END IF;
END;


--==========================================================
---CREATE UNIT_X_CLAIM_SUPP table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='UNIT_X_CLAIM_SUPP';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE UNIT_X_CLAIM_SUPP';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE UNIT_X_CLAIM_SUPP(
  	UNIT_ROW_ID  number(10) NULL,
	VEH_NUM varchar2(100) NULL,
	PLATE_NUM varchar2(100) NULL,
	STATE varchar2(100) NULL,
	REL_TO_INS varchar2(100) NULL,
	LICENSE_NUM varchar2(100) NULL,
	DRIVER_STATE varchar2(100) NULL,
	PURPOSE_OF_USE varchar2(100) NULL,
	HAD_PERMISSION  number(10) NULL,
	VEH_EST_AMT number(8,2) NULL,
	WHERE_VEH varchar2(100) NULL,
	WHEN_VEH varchar2(100) NULL,
	OTH_VEH_INS varchar2(100) NULL,
	SAME_AS_OWNER  number(10) NULL,
	VEH_COLOR_TEXT varchar2(8) NULL,
	ACV_AMT number(8,2) NULL,
	TOTAL_LOSS_CODE  number(10) NULL,
	REC_THEFT_CODE  number(10) NULL,
	STATED_VALU_AMT number(8,2) NULL,
	DEDUCTIBLE__AMT number(8,2) NULL
)';
END IF;
END;

--==========================================================
---CREATE PERSON_INVOLVED table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PERSON_INVOLVED';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PERSON_INVOLVED';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PERSON_INVOLVED(
  	OPTIONSET_ID number(10) NULL,
	COUNTY_OF_RESIDNC varchar2(50) NULL,
	DRIVLIC_STATE varchar2(25) NULL,
	EST_LEN_DISABILITY number(10) NULL,
	HIRED_IN_STE_FLAG varchar2 (1) NULL,
	INSURABLE_FLAG varchar2 (1) NULL,
	LAST_VERIFIED_DATE varchar2(8) NULL,
	NUM_OF_VIOLATIONS number(10) NULL,
	OSHA_ACC_DESC varchar2 (4000) NULL,
	OSHA_REC_FLAG varchar2 (1) NULL,
	REGULAR_JOB_FLAG varchar2 (1) NULL,
	TERM_DATE varchar2(8) NULL,
	WORK_PERMIT_DATE varchar2(8) NULL,
	WORK_PERMIT_NUMBER varchar2(50) NULL,
	WORKDAY_START_TIME varchar2(6) NULL,
	PI_ROW_ID number(10) NULL,
	EVENT_ID number(10) NULL,	
	PI_LAST_NAME varchar2(100) NULL,
	PI_FIRST_NAME varchar2(50) NULL,	
	PI_TAX_ID varchar2(20) NULL,
	PI_TYPE_CODE varchar2(25) NULL,
	INJURY_ILLNESS_FLG varchar2 (1) NULL,
	DATE_OF_DEATH varchar2(8) NULL,
	REHAB_TEXT varchar2 (4000) NULL,
	DESC_BY_WITNESS varchar2 (4000) NULL,
	PATIENT_ACCT_NO varchar2(20) NULL,
	MEDICAL_RCD_NO varchar2(12) NULL,
	INS_PLAN_GROUP_NO varchar2(4000) NULL,
	DATE_OF_ADMISSION varchar2(8) NULL,
	DATE_OF_DISCHARGE varchar2(8) NULL,
	ADM_TYPE_CODE varchar2(25) NULL,
	ADM_SOURCE_CODE varchar2(25) NULL,
	ADMISSION_REASON varchar2 (4000) NULL,
	ACUITY_LEVEL_CODE varchar2(25) NULL,
	PATIENT_STAT_CODE varchar2(25) NULL,
	PATIENT_COND_CODE varchar2(25) NULL,
	DISCHARGE_DSP_CODE varchar2(25) NULL,
	EXP_LENGTH_OF_STAY number(10) NULL,
	EXPECTED_COST number(8,2) NULL,
	QI_SIGNIF_CODE varchar2(25) NULL,
	EPISODE_OF_CARE_ID varchar2(8) NULL,
	PATIENT_TYPE_CODE varchar2(25) NULL,
	MARITAL_STAT_CODE varchar2(25) NULL,
	RACE_ENTH_CODE varchar2(25) NULL,
	WEIGHT number(10) NULL,
	PRIMARY_PAY_CODE varchar2(25) NULL,
	EMERGENCY_CONTACT varchar2(20) NULL,
	EMERGENCY_CONT_NO varchar2(20) NULL,
	PATIENT_ROOM_NO varchar2(14) NULL,
	FACILITY_UNIT_CODE varchar2(25) NULL,
	FACILITY_DEPT_EID varchar2(25) NULL,
	HCO_ID_NO varchar2(20) NULL,
	HCO_SITE_ID_NO varchar2(20) NULL,
	WHY_AT_FACILITY varchar2 (4000) NULL,
	CLAIM_AMOUNT number(8,2) NULL,
	LOST_WORK_FLAG varchar2 (1) NULL,
	LEN_OF_SVC_DAYS number(10) NULL,
	POSITION_CODE varchar2(25)NULL,
	DEPT_ASSIGNED_EID varchar2(25) NULL,
	SUPERVISOR_EID varchar2(25) NULL,
	EXEMPT_STATUS_FLAG varchar2 (1) NULL,
	NO_OF_EXEMPTIONS number(10) NULL,
	FULL_TIME_FLAG varchar2 (1) NULL,
	HOURLY_RATE number(8,2) NULL,
	WEEKLY_HOURS number(8,2) NULL,
	WEEKLY_RATE number(8,2) NULL,
	WORK_SUN_FLAG varchar2 (1) NULL,
	WORK_MON_FLAG varchar2 (1) NULL,
	WORK_TUE_FLAG varchar2 (1) NULL,
	WORK_WED_FLAG varchar2 (1) NULL,
	WORK_THU_FLAG varchar2 (1) NULL,
	WORK_FRI_FLAG varchar2 (1) NULL,
	WORK_SAT_FLAG varchar2 (1) NULL,
	DRIVERS_LIC_NO varchar2(20) NULL,
	DRIVERSLICTYPECODE varchar2(25) NULL,
	DATE_DRIVERSLICEXP varchar2(8) NULL,
	DRIVLIC_RSTRCTCODE varchar2(25) NULL,
	NCCI_CLASS_CODE varchar2(25) NULL,
	COMMENTS varchar2 (4000) NULL,
	INJURY_CAT_CODE varchar2(25) NULL,
	PAY_AMOUNT number(8,2) NULL,
	ACTIVE_FLAG varchar2 (1) NULL,
	EMPLOYEE_NUMBER varchar2(20) NULL,
	DATE_HIRED varchar2(8) NULL,
	DISABILITY_CODE varchar2(25) NULL,
	ILLNESS_CODE varchar2(25) NULL,
	PAY_TYPE_CODE varchar2(25) NULL,
	LOST_CONSC_FLAG varchar2 (1) NULL,
	SEC_DEPT_EID varchar2(25) NULL,
	PATIENT_ID varchar2(20) NULL,
	EST_RTW_DATE varchar2(8) NULL,
	OSHA_ESTAB_EID varchar2(25) NULL,
	MAJOR_HAND_CODE varchar2(25) NULL,
	HRANGE_START_DATE varchar2(8) NULL,
	HRANGE_END_DATE varchar2(8) NULL,
	JOB_CLASS_CODE varchar2(25)NULL,
	OTHER_TREATMENTS varchar2 (4000) NULL,
	OTHER_MEDCOND varchar2 (4000) NULL,
	STD_DISABIL_TYPE varchar2(25) NULL,
	CUSTOM_FED_TAX_PER number(8,2) NULL,
	CUSTOM_SS_TAX_PER number(8,2) NULL,
	CUSTOM_MED_TAX_PER number(8,2) NULL,
	CUSTOM_ST_TAX_PER number(8,2) NULL,
	MONTHLY_RATE number(8,2) NULL,
	ELIG_DIS_BEN_FLAG varchar2 (1) NULL,
	DIS_OPTION_CODE varchar2(25) NULL,
	HTMLCOMMENTS varchar2 (4000) NULL,
	CONF_FLAG varchar2 (1) NULL,
	CONF_EVENT_ID number(10) NULL,
	WHERE_INJ_TAKEN varchar2 (4000) NULL,
	WHAT_INJ_DOING varchar2 (4000) NULL,
	DATE_DISABILITY_BEGAN varchar2(8) NULL,
	DATE_DISABILITY_END varchar2(8) NULL,
	PRE_EXISTING_COND_FLAG varchar2 (1) NULL,
	PRE_EXISTING_COND varchar2(25) NULL,
	DIAGNOSIS_CODE varchar2(25) NULL,
	COLLAT_SOURCES_DESC number(10) NULL,
	INJ_CON_WITH_POL_RPT_FLAG varchar2 (1) NULL,
	ER_HOSPITAL_FLAG varchar2 (1) NULL,
	CAT_INJURY_FLAG varchar2 (1) NULL,
	MEDICATIONS varchar2(200) NULL,
	FILE_CLOSING_DATE varchar2(8) NULL,
	SYMPTOMS_DESC varchar2(200) NULL,
	--INJ_DEPT_EID number(10) NULL,
	--DELETED_DATE varchar2(14) NULL,
	INJURYCAUSE_CODE varchar2(25) NULL,
	PROGNOSIS varchar2 (4000) NULL,
	IMPAIRMENT_FLAG varchar2 (1) NULL,
	DAILY_HOURS number(8,2) NULL,
	DAILY_RATE number(8,2) NULL,
	WEEKLY_OFFSET number(8,2) NULL,
	GROSS_EARNINGS number(8,2) NULL,
	DRIVER_ROW_ID number(10) NULL,
	POLICY_UNIT_ROW_ID number(10) NULL,
	ENTITY_TABLE_ID varchar2 (30) NULL,
	POLICY_ID number(10) NULL,
	CLIENT_SEQ_NUM varchar2 (30) NULL
)';
END IF;
END;



--==========================================================
---CREATE DRIVER table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DRIVER';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE DRIVER';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE DRIVER (
  	OPTIONSET_ID number(10) NULL,
	DRIVER_ROW_ID number(10) NULL,	
	DRIVER_LAST_NAME varchar2(100) NULL,
	DRIVER_FIRST_NAME varchar2(50) NULL,	
	DRIVER_TAX_ID varchar2(20) NULL,	
	DRIVER_TYPE varchar2(25) NULL,
	LICENCE_DATE varchar2(8) NULL,
	LICENCE_NUMBER varchar2(50) NULL,
	MARITAL_STAT_CODE varchar2(25) NULL,
	PS_INS_LINE varchar2(50) NULL,
PS_RISK_LOC varchar2(10) NULL,
PS_RISK_SUB_LOC varchar2(10) NULL,
PS_PRODUCT varchar2(50) NULL,
PS_DRIVER_ID number NULL,
PS_RECORD_STATUS varchar2 (25) NULL
)';
END IF;
END;



--==========================================================
---CREATE OTHER_UNIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='OTHER_UNIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE OTHER_UNIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE OTHER_UNIT (
  	OPTIONSET_ID number(10) NULL,
	OTHER_UNIT_ID number(10) NULL,
	ENTITY_ID number(10) NULL,
	UNIT_TYPE varchar2(10) NULL,	
	ADDED_BY_USER varchar2(10) NULL,
	UPDATED_BY_USER varchar2(10) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL
)';
END IF;
END;


--==========================================================
---CREATE FUNDS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='FUNDS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE FUNDS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE FUNDS (
  	OPTIONSET_ID number (10) NULL,
	TRANS_ID number (10) NULL,
	AUTO_CHECK_DETAIL varchar2(30) NULL,
	ROLLUP_ID number (10) NULL,
	VOID_DATE varchar2(8) NULL,
	ADDR1 varchar2(50) NULL,
	ADDR2 varchar2(50) NULL,
	AUTO_CHECK_FLAG varchar2(2) NULL,
	CITY varchar2(50) NULL,
	CLAIMANT_LAST varchar2(50) NULL,
	CLAIMANT_FIRST varchar2(50) NULL,
	COUNTRY_CODE varchar2(25) NULL,
	FIRST_NAME varchar2(50) NULL,
	LAST_NAME varchar2(50) NULL,
	TAX_ID varchar2(20) NULL,
	PRECHECK_FLAG number (10) NULL,
	STATE_ID varchar2(25) NULL,
	UNIT_ID number (10) NULL,
	ZIP_CODE varchar2(10) NULL ,
	CLAIM_ID varchar2(25) NULL , 
	CTL_NUMBER varchar2(25) NULL,
	VOID_FLAG number (1) NULL,
	DATE_OF_CHECK varchar2(8) NULL,
	CHECK_MEMO varchar2(255) NULL,
	TRANS_NUMBER number (10) NULL,
	TRANS_DATE varchar2(8) NULL,
	PAYEE_EID number (10) NULL, 
	PAYEE_TYPE_CODE varchar2(25) NULL,
	ACCOUNT_ID varchar2(20) NULL,
	AMOUNT number(10,2) NULL,
	STATUS_CODE varchar2(25) NULL,
	FILED_1099_FLAG number (10) NULL,
	CLEARED_FLAG number (10) NULL,
	TRANS_TYPE varchar2(25) NULL,
	UPDATE_RESERVES varchar2(1) NULL,
	COMMENTS varchar2(16) NULL,
	NOTES varchar2(16) NULL ,
	CRC number (10) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	BATCH_NUMBER number (10) NULL,
	ENCLOSURE_FLAG number (10) NULL,
	SUB_ACCOUNT_ID varchar2(20) NULL,
	SETTLEMENT_FLAG number (10) NULL,
	WEEKS_PAID_CODE number (10) NULL,
	NUM_OF_PAID_DAYS number (10) NULL,
	RESUBMIT_EDI number (10) NULL,
	SUPP_PAYMENT_FLAG number (10) NULL,
	HTMLCOMMENTS varchar2(16) NULL,
	MIDDLE_NAME varchar2(50) NULL,
	REASON varchar2(255) NULL,
	VOID_REASON varchar2(255) NULL,
	DORMANCY_STATUS varchar(25) NULL,
	WITHHOLDING_PMT_FLAG number (10) NULL,
	WITHHOLDING_TYPE number (10) NULL,
	WITHHOLDING_CHILD_FLAG number (10) NULL, 
	PARENT_TRANS_ID number (10) NULL,
	COMBINED_PAY_FLAG number (10) NULL,
	PMT_CURRENCY_CODE varchar2(25) NULL,
	PMT_CURRENCY_AMOUNT number(10,2) NULL,
	PMT_TO_BASE_CUR_RATE number(10,2) NULL,
	CLAIM_CURRENCY_CODE varchar2(25) NULL,
	CLAIM_CURRENCY_AMOUNT number(10,2) NULL,
	PMT_TO_CLAIM_CUR_RATE number(10,2) NULL,
	BASE_TO_PMT_CUR_RATE number(10,2) NULL,
	BASE_TO_CLAIM_CUR_RATE number(10,2) NULL,
	BILL_TYPE varchar2(8) NULL,
  REISSUE_REASON_CODE varchar2(25) NULL,
	MANUAL_CHECK number (10) NULL,
	OFFSET_FLAG number (10) NULL,
	STOP_PAY_FLAG number (10) NULL,
	STOP_PAY_DATE varchar2(8) NULL,
	APPROVE_USER varchar2(255) NULL,
	CONF_EVENT_ID varchar2(255) Null,
	CONF_FLAG varchar2(255) Null,
	EDI_BATCH_NUMBER varchar2(255) Null,
	EFT_DATE varchar2(8) NULL,
	EFT_FILE_NAME varchar2(255) Null,
	DTTM_APPROVAL varchar2(8) NULL,
	EDI_MED_EXTRACTED varchar2(255) Null,
	EFT_FLAG number (10) NULL,
    FINAL_PAYMENT_FLAG number (10) NULL,
    REISSUE_BY varchar2(255) Null,
    REISSUE_DATE varchar2(8) NULL,
	REISSUE_FLAG number (10) NULL,
	REISSUE_PARENT_ID varchar2(255) Null,
	RES_SUPP_PAYMENT_FLAG number (10) NULL,
	SEC_DEPT_EID varchar2(255) Null,
	TAX_PAYMENT_FLAG number (10) NULL,
	VOID_REASON_HTMLCOMMENTS number (10) NULL,
	IAIABC_ADJUST_DATE varchar2(8) NULL,
	IAIABC_CREDIT_DATE varchar2(8) NULL,
	IAIABC_REDIST_DATE varchar2(8) NULL,
	PS_EXTRACTED number (10) NULL
)';
END IF;
END;


--==========================================================
---CREATE FUNDS_TRANS_SPLIT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='FUNDS_TRANS_SPLIT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE FUNDS_TRANS_SPLIT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE FUNDS_TRANS_SPLIT (
  	OPTIONSET_ID number (10) NULL,
	SPLIT_ROW_ID number (10) NULL,
	SUM_AMOUNT number (10,2) NULL,
	TRANS_ID number (10) NULL,
	TRANS_TYPE_CODE varchar2(25) NULL,
	RESERVE_TYPE_CODE varchar2(25) NULL,
	AMOUNT number (10,2) NULL,
	GL_ACCOUNT_CODE varchar2(6) NULL,
	FROM_DATE varchar2(8) NULL,
	TO_DATE varchar2(8) NULL,
	INVOICED_BY varchar2(20) NULL,
	INVOICE_AMOUNT number (10,2) NULL,
	INVOICE_NUMBER varchar2(25) NULL,
	PO_NUMBER varchar2(14) NULL,
	CRC number (10) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	INVOICE_DATE varchar2(8) NULL,
	BILL_RCVD_BY_CARRIER_DATE varchar2(8) NULL,
	SUPP_PAYMENT_FLAG number (10) NULL,
	AUTO_DISCOUNT varchar2(10) NULL,
	IS_FIRST_FINAL number (10) NULL,
	WITHHOLDING_SPLIT_FLAG number (10) NULL,
	CONTROL_REQ_FLAG number (10) NULL,
	FUNDS_CR_STATUS Varchar(25) NULL,
	PMT_CURRENCY_AMOUNT number (10,2) NULL,
	PMT_CURRENCY_INVOICE_AMOUNT number (10,2) NULL,
	PMT_CURRENCY_AUTO_DISCOUNT number (10,2) NULL,
	CLAIM_CURRENCY_AMOUNT number (10,2) NULL,
	CLAIM_CURRENCY_INVOICE_AMOUNT number (10,2) NULL,
	CLAIM_CURRENCY_AUTO_DISCOUNT number (10,2) NULL,
	UPDATE_POL_SYS number (10) NULL,
	UNIT_TYPE varchar2(5) NULL,
	POLICY_NAME varchar2(20) NULL,
	UNIT_NUMBER varchar2(10) NULL,
	COVERAGE_CODE varchar2(25) NULL,
	LOSS_DISABILITY_CODE varchar2(25) NULL,
	DISABILITY_TYPE_CATEGORY varchar2(25) NULL,
	MODULE_NO varchar2(10) NULL,
	CLASS_CODE varchar2(50) NULL,
	CVG_SEQUENCE_NO varchar2(8) NULL,
	TRANS_SEQ_NO varchar2(8) NULL,
	CVG_DESC varchar2(50) NULL,
	SUBLINE_DESC varchar2(50) NULL,
	CLASS_DESC varchar2(50) NULL,
	STAT_UNIT_NUMBER varchar2(10) NULL
)';
END IF;
END;



--==========================================================
---CREATE FUNDS_X_PAYEE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='FUNDS_X_PAYEE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE FUNDS_X_PAYEE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE FUNDS_X_PAYEE (
	OPTIONSET_ID number NULL,
	PAYEE_EID number NULL,
	FUNDS_TRANS_ID number NULL,
	PAYEE_1099_FLAG number NULL,
	DTTM_RCD_ADDED varchar2(14) NULL,
	DTTM_RCD_LAST_UPD varchar2(14) NULL,
	ADDED_BY_USER varchar2(50) NULL,
	UPDATED_BY_USER varchar2(50) NULL,
	PAYEE_TYPE_CODE varchar2(25) NULL,
	PHRASE_TYPE_CODE varchar2(25) NULL,
	BEFORE_PAYEE number NULL
)';
END IF;
END;

-- mkaur24 <01/14/2015> MITS 33286


--==========================================================
---CREATE PROP_MGT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PROP_MGT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PROP_MGT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PROP_MGT (
	OPTIONSET_ID number NULL,
	PROP_MGT_ID number  NULL,
	PROP_ID_TEXT varchar2(50) NULL,
	LOCATION_TXCD varchar2(2000) NULL,
	OWNERSHIP_CODE varchar2(25) NULL,
	PROP_TYPE_CODE varchar2(25) NULL,
	PROP_CAT_TEXT varchar2(50) NULL,
	REPORTED_BY_TXCD varchar2(2000) NULL,
	DT_UPDATE_DATE varchar2(8) NULL,
	REV_DATE_DATE varchar2(8) NULL,
	DETAIL_TXCD varchar2(2000) NULL,
	ORIG_VALUE_AMT float NULL,
	CURR_VALUE_AMT float NULL,
	REPLACE_VAL_AMT float NULL,
	CONT_ORG_VL_AMT float NULL,
	CONT_REP_VL_AMT float NULL,
	CONT_CUR_VL_AMT float NULL,
	INSTALL_DT_DATE varchar2(8) NULL,
	CONTACT_TEXT varchar2(50) NULL,
	CONTACT_ADD_TEXT varchar2(50) NULL,
	CONT_CITY_TEXT varchar2(25) NULL,
	CONT_STATE_TEXT varchar2(15) NULL,
	CONT_ZIP_TEXT varchar2(15) NULL,
	CONT_PHONE_TEXT varchar2(25) NULL,
	COVERAGE_CODE varchar2(25) NULL,
	DAMAGES_TXCD varchar2(2000) NULL,
	IMPROVEMENT_TXCD varchar2(2000) NULL,
	NOTES_TXCD varchar2(2000) NULL
	
)';
END IF;
END;

--==========================================================
---CREATE PROJ_TRACK table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='PROJ_TRACK';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE PROJ_TRACK';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE PROJ_TRACK (
	OPTIONSET_ID number NULL,
	PROJ_TRACK_ID number NULL,
	ACT_TYPE_CODE  varchar2(25) NULL,
	ACTIV_DESC_TXCD  varchar2(2000) NULL,
	ASSIGN_BY_TEXT  varchar2(50) NULL,
	ASSIGN_TO_TXCD varchar2(2000) NULL,
	PRIORITY_CODE  varchar2(25) NULL,
	EST_HOURS_NUM float NULL,
	ACT_HOURS_NUM float NULL,
	DUE_DATE_DATE  varchar2(8) NULL,
	REVIEW_DATE_DATE  varchar2(8) NULL,
	COMPLETE_DT_DATE  varchar2(8) NULL,
	STATUS_CODE  varchar2(25) NULL,
	MAT_USED_TXCD  varchar2(2000) NULL,
	MAT_COST_AMT float NULL,
	NOTES_TXCD  varchar2(2000) NULL


)';
END IF;
END;

--==========================================================
---CREATE DIRECTORY table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DIRECTORY';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE DIRECTORY';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE DIRECTORY (
	OPTIONSET_ID number NULL,
	DIRECTORY_ID number  NULL,
	LAST_NAME_TEXT  varchar2(50) NULL,
	FIRST_NAME_TEXT  varchar2(50) NULL,
	ADDRESS_TEXT  varchar2(50) NULL,
	CITY_TEXT  varchar2(50) NULL,
	STATE_TEXT  varchar2(15) NULL,
	ZIP_CODE_TEXT  varchar2(15) NULL,
	HOME_PHONE_TEXT  varchar2(25) NULL,
	WORK_PHONE_TEXT  varchar2(25) NULL,
	FAX_TEXT  varchar2(25) NULL,
	TITLE_TEXT  varchar2(25) NULL,
	ORGANIZ_TEXT  varchar2(50) NULL,
	CONTACT_TYP_CODE  varchar2(25) NULL,
	CONTACT_STA_CODE  varchar2(25) NULL,
	RECALL_DT_DATE  varchar2(8) NULL,
	NOTES_TXCD  varchar2(2000) NULL
)';
END IF;
END;

--==========================================================
---CREATE COMPL_MGT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='COMPL_MGT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE COMPL_MGT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE COMPL_MGT (
OPTIONSET_ID number NULL,
	COMPL_MGT_ID number  NULL,
	COMP_NO_TEXT  varchar2(25) NULL,
	DT_RECV_DATE  varchar2(8) NULL,
	COMP_TYPE_CODE  varchar2(25) NULL,
	COMP_SRC_CODE  varchar2(25) NULL,
	ACT_REQ_TXCD  varchar2(2000) NULL,
	FILED_AGNST_TEXT  varchar2(50) NULL,
	REF_TO_TXCD  varchar2(2000) NULL
)';
END IF;
END;

--==========================================================
---CREATE CONTRCT_MGT table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CONTRCT_MGT';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CONTRCT_MGT';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CONTRCT_MGT (
OPTIONSET_ID number NULL,
	CONTRCT_MGT_ID number  NULL,
	CONT_TYPE_CODE varchar2(25)NULL,
	CONTR_CAT_TXCD  varchar2(2000) NULL,
	SUBJECTOR_TEXT  varchar2(50) NULL,
	SUBJECTEE_TEXT  varchar2(50) NULL,
	DETAILS_TXCD  varchar2(2000) NULL,
	EFF_DATE_DATE  varchar2(8) NULL,
	EXPIR_DATE_DATE  varchar2(8) NULL,
	RENEW_DATE_DATE  varchar2(8) NULL,
	INDEMNITY_TXCD  varchar2(2000) NULL,
	SUBROGATION_TXCD varchar2(2000) NULL,
	TERM_INFO_TEXT  varchar2(50) NULL,
	CONDITIONS_TXCD  varchar2(2000) NULL,
	AUTH_SIGN_TXCD  varchar2(2000) NULL,
	PAYMENTS_TXCD  varchar2(2000) NULL,
	WARRANTY_TXCD  varchar2(2000) NULL
)';
END IF;
END;


--==========================================================
---CREATE CERTIFICATE table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='CERTIFICATE';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE CERTIFICATE';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE CERTIFICATE (
OPTIONSET_ID  number NULL,
	CERTIFICATE_ID  number  NULL,
	JOB_NO_TEXT  varchar2(15) NULL,
	JOB_DESC_TXCD  varchar2(2000) NULL,
	AGENCY_NAME_TEXT  varchar2(50) NULL,
	AGENCY_PHON_TEXT  varchar2(20) NULL,
	INSURED_NAM_TEXT  varchar2(50) NULL,
	INSURED_ADD_TEXT  varchar2(50) NULL,
	INSURED_CIT_TEXT  varchar2(25) NULL,
	INSURED_ST_TEXT  varchar2(15) NULL,
	INSURED_ZIP_TEXT  varchar2(15) NULL,
	INSURED_PH_TEXT  varchar2(20) NULL,
	GEN_LIAB_TXCD  varchar2(2000) NULL,
	INS_NAME_TEXT  varchar2(50) NULL,
	POL_NUMBER_NUM float NULL,
	EXPIR_DATE_DATE  varchar2(8) NULL,
	BI_EA_AGG_TEXT  varchar2(25) NULL,
	PD_EA_AGG_TEXT  varchar2(25) NULL,
	BI_PD_COMB_NUM float NULL,
	PI_AGG_NUM float NULL,
	AUTO_LIAB_TEXT  varchar2(25) NULL,
	BI_EA_PERS_NUM float NULL,
	BI_EA_ACC_NUM float NULL,
	PD_EA_OCC_NUM float NULL,
	BI_PD_COMB_TEXT  varchar2(15) NULL,
	EXCESS_LIAB_TXCD  varchar2(2000) NULL,
	BI_PD_AGG_TEXT  varchar2(15) NULL,
	WORK_COMP_NUM float NULL,
	WORK_COMP_TEXT  varchar2(25) NULL,
	WC_EA_ACC_NUM float NULL,
	OPER_DESC_TXCD  varchar2(2000) NULL,
	ISSUE_DT_DATE  varchar2(8) NULL
)';
END IF;
END;


--==========================================================
---CREATE BOND_ABS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='BOND_ABS';

IF iExists = 1 THEN
EXECUTE IMMEDIATE
 'DROP TABLE BOND_ABS';
 iExists := 0 ;
END IF;

IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE BOND_ABS (
OPTIONSET_ID number NULL,
	BOND_ABS_ID number  NULL,
	BOND_NUM_TEXT  varchar2(20) NULL,
	BOND_TYPE_TXCD  varchar2(2000) NULL,
	BOND_LINE_CODE  varchar2(25) NULL,
	EFF_DATE_DATE  varchar2(8) NULL,
	EXPIR_DATE_DATE  varchar2(8) NULL,
	BOND_AMT_AMT float NULL,
	PREMIUM_AMT float NULL,
	BILL_NAME_TEXT  varchar2(50) NULL,
	BILL_ADDR_TEXT  varchar2(50) NULL,
	BILL_CITY_TEXT  varchar2(25) NULL,
	BILL_ZIP_TEXT  varchar2(15) NULL,
	BILL_ACCT_TEXT  varchar2(50) NULL,
	PRINCIPAL_TXCD  varchar2(2000) NULL,
	STATE_TEXT  varchar2(3) NULL,
	BILL_STATE_TEXT  varchar2(25) NULL,
	OBLIGEE_TXCD  varchar2(2000) NULL,
	BOND_CLASS_CODE  varchar2(25) NULL,
	OLD_BOND_NO_TEXT  varchar2(25) NULL,
	REQUESTER_TEXT  varchar2(50) NULL,
	REQ_ADDR_TEXT  varchar2(50) NULL,
	REQ_CITY_TEXT  varchar2(25) NULL,
	REQ_STATE_TEXT  varchar2(25) NULL,
	REQ_ZIP_TEXT  varchar2(15) NULL,
	REQ_PHONE_TEXT  varchar2(15) NULL,
	ORDERED_BY_TEXT  varchar2(50) NULL,
	ORDER_ADDR_TEXT  varchar2(50) NULL,
	ORDER_CITY_TEXT  varchar2(25) NULL,
	ORDER_STATE_TEXT  varchar2(15) NULL,
	ORDER_ZIP_TEXT  varchar2(15) NULL,
	ORDER_PHONE_TEXT  varchar2(25) NULL,
	AUTH_BY_TEXT  varchar2(50) NULL,
	AUTH_ADDR_TEXT  varchar2(50) NULL,
	AUTH_CITY_TEXT  varchar2(25) NULL,
	AUTH_STATE_TEXT  varchar2(15) NULL,
	AUTH_ZIP_TEXT  varchar2(15) NULL,
	AUTH_PHONE_TEXT  varchar2(15) NULL,
	DATE_EXEC_DATE  varchar2(8) NULL,
	PAID_DATE_DATE  varchar2(8) NULL,
	BOND_STATUS_CODE  varchar2(25) NULL,
	DATE_CANC_DATE  varchar2(8) NULL,
	BOND_DETAIL_TXCD  varchar2(2000) NULL
)';
END IF;
END;
END;