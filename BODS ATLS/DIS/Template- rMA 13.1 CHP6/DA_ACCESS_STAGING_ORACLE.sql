-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
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
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMP_X_DEPENDENT';
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE EMP_X_DEPENDENT(
	OPTIONSET_ID number(10) NULL,
	DEPENDENT_EID number(10) NULL,
	EMPLOYEE_EID number(10) NULL,
	HEALTH_PLAN_FLAG varchar(1) NULL,
	RELATION_CODE varchar(6) NULL

)';
END IF;

--==========================================================
---CREATE EMP_X_VIOLATION table 
--============================================================
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMP_X_VIOLATION';
IF iExists = 0 THEN

EXECUTE IMMEDIATE
'CREATE TABLE EMP_X_VIOLATION(
	OPTIONSET_ID number(10) NULL,
	EMPLOYEE_EID number(10) NULL,
	VIOLATION_CODE varchar(6) NULL,
	VIOLATION_DATE varchar(8) NULL

)';
END IF;
--==========================================================
---CREATE EMPLOYEE table 
--============================================================
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='EMPLOYEE';
IF iExists = 0 THEN

EXECUTE IMMEDIATE
'CREATE TABLE EMPLOYEE(
	OPTIONSET_ID number(10) NULL,
	EMPLOYEE_EID number(10) NULL,
	EMPLOYEE_NUMBER varchar(20) NULL,
	ACTIVE_FLAG varchar(1) NULL,
	WORK_PERMIT_NUMBER varchar(50) NULL,
	WORK_PERMIT_DATE varchar(8) NULL,
	LAST_VERIFIED_DATE varchar(8) NULL,
	DATE_HIRED varchar(8) NULL,
	POSITION_CODE varchar(25) NULL,
	DEPT_ASSIGNED_EID varchar(25) NULL,
	SUPERVISOR_EID number(10) NULL,
	FULL_TIME_FLAG varchar(1) NULL,
	EXEMPT_STATUS_FLAG varchar(1) NULL,
	PAY_TYPE_CODE varchar(6) NULL,
	PAY_AMOUNT number(10,2) NULL,
	HOURLY_RATE number(10,2) NULL,
	WEEKLY_HOURS number(10) NULL,
	WEEKLY_RATE number(10,2) NULL,
	WORK_SUN_FLAG varchar(1) NULL,
	WORK_MON_FLAG varchar(1) NULL,
	WORK_TUE_FLAG varchar(1) NULL,
	WORK_WED_FLAG varchar(1) NULL,
	WORK_THU_FLAG varchar(1) NULL,
	WORK_FRI_FLAG varchar(1) NULL,
	WORK_SAT_FLAG varchar(1) NULL,
	INSURABLE_FLAG varchar(1) NULL,
	DRIVLIC_STATE varchar(6) NULL,
	DRIVERS_LIC_NO varchar(20) NULL,
	DRIVERSLICTYPECODE varchar(6) NULL,
	DATE_DRIVERSLICEXP varchar(8) NULL,
	DRIVLIC_RSTRCTCODE varchar(6) NULL,
	MARITAL_STAT_CODE varchar(6) NULL,
	NO_OF_EXEMPTIONS number(10) NULL,
	DATE_OF_DEATH varchar(8) NULL,
	NCCI_CLASS_CODE varchar(25) NULL,
	TERM_DATE varchar(8) NULL,
	EMP_ENTITY_ID number(10) NULL
)';
END IF;

--==========================================================
---CREATE ENTITY table 
--============================================================
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='ENTITY';
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE ENTITY(

	OPTIONSET_ID number(10) NULL,
       ENTITY_ID number(10) NULL,
	ENTITY_TABLE_ID varchar(18) NULL,
	TAX_ID varchar(20) NULL,
	ABBREVIATION varchar(20) NULL,
	LAST_NAME varchar(50) NULL,
	FIRST_NAME varchar(50) NULL,
	BUSINESS_TYPE_CODE varchar(6) NULL,
	COST_CENTER_CODE varchar(6) NULL,
	SEX_CODE varchar(6) NULL,
	BIRTH_DATE varchar(8) NULL,
	ALSO_KNOWN_AS varchar(20) NULL,
	NATURE_OF_BUSINESS varchar(20) NULL,
	ADDR1 varchar(50) NULL,
	ADDR2 varchar(50) NULL,
	CITY varchar(50) NULL,
	COUNTY varchar(30) NULL,
	STATE_ID varchar(6) NULL,
	COUNTRY_CODE varchar(6) NULL,
	ZIP_CODE varchar(10) NULL,
	PHONE1 varchar(20) NULL,
	PHONE2 varchar(20) NULL,
	FAX_NUMBER varchar(20) NULL,
	EMAIL_TYPE_CODE varchar(6) NULL,
	EMAIL_ADDRESS varchar(25) NULL,
	PARENT_ABBREV varchar(25) NULL,
	WC_FILING_NUMBER varchar(30) NULL,
	SIC_CODE varchar(25) NULL,
	CONTACT varchar(50) NULL,
	PARENT_EID number(10) NULL,
	EFF_START_DATE varchar(8) NULL,
	EFF_END_DATE varchar(8) NULL,
	MIDDLE_NAME varchar(50) NULL,
	REPORT_1099_FLAG varchar(1) NULL,
	DELETED_FLAG varchar(1) NULL,
	PARENT_1099_EID number(10) NULL,
	AUTO_DISCOUNT number(10) NULL,
	NPI_NUMBER varchar(10) NULL

	
)';
END IF;

--==========================================================
---CREATE POLICY_X_INSURER table 
--============================================================
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='POLICY_X_INSURER';
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE POLICY_X_INSURER(

	IN_ROW_ID number(10) NULL,
        POLICY_ID number(10) NULL,
	INSURER_CODE varchar(50) NULL,
	RES_PERCENTAGE number(10) NULL,
	PRIMARY_INSURER varchar(1) NULL
)';
END IF;
END;