-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Database Type: Oracle
--   DI Module Name: POSITIVE PAY
--   Template_Positive Pay (rmA16.4 and above)	
--   DESCRIPTION: Structure Definition Script for
--   Table:	T_PPY_SETTING
--		T_PPY_ACCOUNTNUMBER
--		T_PPY_HEADERHOLD
--		T_PPY_DETAILHOLD
--		T_PPY_POSITIVEPAYOUTPUT
--		T_PPY_IMPORT
--		T_PPY_VALIDATED_INPUT
--		T_PPY_CHECKSNOTVOID
--		T_PPY_FUNDS	--ipuri 10/28/2013 Mits:34159
--		ERROR_LOG
--   DATE:	07/27/2009 
--   DATE:  02/09/2011 : VSONI5 (MITS 23920) - Drop statement added, Table names changed, New column "ManuallyChangeDateRange" added in T_PYY_SETTING table.
-- DATE:  10/06/2016 : vchaturvedi2 (JIRA 29402) - New column "Company Name", "File Format" and Destination City added in T_PYY_SETTING table.
-- ============================================================= 

declare 
isRmdb number;
iExists NUMBER;
begin
select count(*) into isRmdb from user_tables where table_name='SYS_PARMS';
if isRmdb > 0 then
dbms_output.put_line('Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and 
execute this script.');
else

BEGIN

--================================================================
-- Drop the Staging tables if exists.
--================================================================
-----------------------------------------------------
--/****** Object 1:  Table T_PPY_SETTING
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_SETTING';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_SETTING';
END IF;
END;

-----------------------------------------------------
--/****** Object 2:  Table T_PPY_ACCOUNTNUMBER
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_ACCOUNTNUMBER';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_ACCOUNTNUMBER';
END IF;
END;

-----------------------------------------------------
--/****** Object 3:  Table T_PPY_HEADERHOLD
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_HEADERHOLD';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_HEADERHOLD';
END IF;
END;

-----------------------------------------------------
--/****** Object 4:  Table T_PPY_DETAILHOLD
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_DETAILHOLD';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_DETAILHOLD';
END IF;
END;

-----------------------------------------------------
--/****** Object 5:  Table T_PPY_POSITIVEPAYOUTPUT
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_POSITIVEPAYOUTPUT';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_POSITIVEPAYOUTPUT';
END IF;
END;

-----------------------------------------------------
--/****** Object 6:  Table T_PPY_IMPORT
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_IMPORT';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_IMPORT';
END IF;
END;

-----------------------------------------------------
--/****** Object 7:  Table T_PPY_VALIDATED_INPUT
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_VALIDATED_INPUT';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_VALIDATED_INPUT';
END IF;
END;

-----------------------------------------------------
--/****** Object 8:  Table T_PPY_CHECKSNOTVOID
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_CHECKSNOTVOID';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_CHECKSNOTVOID';
END IF;
END;

-----------------------------------------------------
--/****** Object 9:  Table ERROR_LOG
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='ERROR_LOG';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE ERROR_LOG';
END IF;
END;
--==================================================
-----------------------------------------------------
--ipuri 10/28/2013 Mits:34159 Start
--/****** Object 10:  Table T_PPY_FUNDS
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_PPY_FUNDS';
IF iExists = 1 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_PPY_FUNDS';
END IF;
END;
--==================================================
--ipuri 10/28/2013 Mits:34159 End

--==================================================
-- Create the Staging tables
--==================================================

---------------------------------------------
--/****** Object 1:  Table T_PPY_SETTING
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_SETTING(
	JobID number NULL,
	POSITIVE_PAY_TYPE varchar(1024) NULL,
	ACCOUNTLEN varchar(1024) NULL,
	BANKFORMAT varchar(1024)  NULL,
	ACCOUNT_ID varchar(1024) NULL,
	MANUALLYCHANGEDATERANGE varchar(1024) NULL,
	FROM_DATE varchar(1024) NULL,
	TO_DATE varchar(1024) NULL,
	Company_Name varchar(1024) NULL, 
	File_Format varchar(1024) NULL,
	TARGET_FILE varchar(1024) NULL,
	DESTINATION_CITY varchar(1024) NULL
	
)';
END;

----------------------------------------------
--/****** Object 2:  Table T_PPY_ACCOUNTNUMBER
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_ACCOUNTNUMBER(
	ROW_ID number NULL,
	JOBID number NULL,
	ACCOUNT_NUMBER varchar(20) NULL
)';
END;

-------------------------------------------------------
--/****** Object 3:  Table T_PPY_HEADERHOLD
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_HEADERHOLD(
	JOBID number NOT NULL,
	ACCOUNT_NUMBER varchar(20) NULL,
	ACCOUNT_ID number NOT NULL,
	ACCOUNT_NAME varchar(50) NULL,
	STATE_ID varchar(4) NULL
)';
END;

----------------------------------------------
--/****** Object 4:  Table T_PPY_DETAILHOLD
--/PAY_TO_THE_ORDER_OF column is added to provide multiple payee support in RMX r8.
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_DETAILHOLD(
	JOBID number NULL,
	TRANS_NUMBER number(30,0) NULL,
	S_AMOUNT float NULL,
	DATE_OF_CHECK varchar(8) NULL,
	VOID_FLAG number NULL,
	VOID_DATE varchar(8) NULL,
	STATUS_CODE number NULL,
	CLEARED_FLAG number NULL,
	FIRST_NAME varchar(255)  NULL,
	LAST_NAME varchar(255)  NULL,
	PAYEE_EID number NULL,
	ACCOUNT_NUMBER varchar(50) NULL,
	ACCOUNT_NAME varchar(50)  NULL,
	TAX_ID varchar(20) NULL,
	PAY_TO_THE_ORDER_OF varchar(255) NULL
)';
END;

-----------------------------------------------------
--/****** Object 5:  Table T_PPY_POSITIVEPAYOUTPUT
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_POSITIVEPAYOUTPUT(
	JOBID number NULL,
	ACCOUNTNUMBER varchar(1050) NULL,
	SEGMENT varchar(50) NULL,
	ALLDATA varchar(157) NULL
)';
END;

-----------------------------------------------------
--/****** Object 6:  Table T_PPY_IMPORT
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_IMPORT(
	JOBID number NULL,
	ACCOUNTNUMBER varchar(20) NULL,     --Changed from Decimal to varchar datatype.
	CHECKNUMBER decimal(10, 0) NULL,
	INPUT_AMOUNT float NULL,
	CHECKDATE varchar(8) NULL
)';
END;

-----------------------------------------------------
--/****** Object 7:  Table T_PPY_VALIDATED_INPUT
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_VALIDATED_INPUT(
	JOBID number NULL,
	ACCOUNTNUMBER varchar(20) NULL,   --Changed from Decimal to varchar datatype.
	CHECKNUMBER decimal(10, 0) NULL,
	INPUT_AMOUNT float NULL,
	CHECKDATE varchar(8) NULL,
	ACCOUNT_ID number NULL,
	VOID_FLAG number NULL,
	ROLLUP_ID number NULL,
	STOP_PAY_FLAG number NULL
)';
END;

-----------------------------------------------------
--/****** Object 8:  Table T_PPY_CHECKSNOTVOID
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_CHECKSNOTVOID(
	JOBID number NULL,
	ACCOUNTNUMBER varchar(20) NULL,    --Changed from Decimal to varchar datatype.
	CHECKNUMBER decimal(10, 0) NULL,
	INPUT_AMOUNT float NULL,
	CHECKDATE varchar(8),
	ACCOUNT_ID number NULL,
	ROLLUP_ID number NULL
)';
END;
-----------------------------------------------------
--/****** Object 9:  Table ERROR_LOG
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE ERROR_LOG(
	ERR_LOG_ROW_ID number(10) Not NULL,
	JOBID number(10) Not NULL,
	INPUT_ROW_ID number(10) NULL,
	MODULE_NAME varchar(50) NULL,
	WORK_FLOW_NAME varchar(50) NULL,
	DATA_FLOW_NAME varchar(50) NULL,
	ERROR_TIME varchar(14) NULL,					-- pyadav25 MITS 34778 1/2/2014. Field size changed to 14 from 50.
	ERROR_TITLE varchar(100) NULL,
	ERROR_DESC varchar(4000) NULL,
	IS_VALIDATION number(10) NULL,
	ERROR_TABLE varchar(50) NULL,
	TABLE_ROW_ID number(10) NULL, 
	ERROR_COLUMNS varchar(4000) NULL

)';
EXECUTE IMMEDIATE
'ALTER TABLE ERROR_LOG ADD CONSTRAINT PK_ERROR_LOG PRIMARY KEY (JOBID, ERR_LOG_ROW_ID)';
END;
-----------------------------------------------------

--ipuri 10/28/2013 Mits:34159 Start
-- =============================================================
--/****** Object 10:  Table T_PPY_FUNDS
BEGIN
EXECUTE IMMEDIATE
'CREATE TABLE T_PPY_FUNDS(
	JOBID number(10) NOT NULL,
	TRANS_NUMBER number(30,0) NULL,
	AMOUNT float NULL,
	DATE_OF_CHECK varchar(8) NULL,
	VOID_FLAG number NULL,
	VOID_DATE varchar(8) NULL,
	STATUS_CODE number NULL,
	CLEARED_FLAG number NULL,
	FIRST_NAME varchar(255) NULL,
	LAST_NAME varchar(255) NULL,
	PAYEE_EID number NULL,
	PAY_TO_THE_ORDER_OF varchar(255) NULL,
	ACCOUNT_ID number NULL

)';
END;
-----------------------------------------------------
--ipuri 10/28/2013 Mits:34159 End

END;
END IF;
END;
--=====================================================
