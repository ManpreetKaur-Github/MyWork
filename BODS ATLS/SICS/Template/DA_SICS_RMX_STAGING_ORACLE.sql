

-- ============================================================
--   SCRIPT HEADER (MSSQL RMX_STAGING DATABASE STRUCTURE)
--   Template_SICS(rmA17.1 onwards)
--   Module Name: DA_SICS (All)
--   Description: 	DDL for Data Analytics SICS
--   mkaur24 JIRA RMA-34763 1/19/2017  
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

--==========================================================
---CREATE DA_SICS table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DA_SICS';
IF iExists != 0 THEN
EXECUTE IMMEDIATE
'DROP TABLE DA_SICS';
iExists := 0 ;
END IF;
IF iExists = 0 THEN
  EXECUTE IMMEDIATE 'CREATE TABLE DA_SICS(
         DA_ROW_ID   number(10)  NOT NULL,
			 JOBID   number(10)  NOT NULL,
			 INPUT_ROW_ID   number(10)  NULL,
			 INVALID_ROW   number(10)  NULL,
			 UPDATE_ROW   number(10)  NULL,
			 IMPORT_TS  varchar2 (20) NULL,
			 CREATION_TS  varchar2 (20) NULL,
			 DTL_AMT   decimal (22,2) NULL,
			 AS_AT  varchar2 (1)  NULL,
			 OCC_YR  varchar2 (4)  NULL,
			 UW_YEAR  varchar2 (4)  NULL,
			 AC_YEAR  varchar2 (4)  NULL,
			 AC_START_DATE  varchar2 (20)  NULL,
			 AC_END_DATE  varchar2 (20)  NULL,
			 DATE_OF_BOOKING  varchar2 (20)  NULL,
			 BOOKING_YEAR  varchar2 (4)  NULL,
			 BOOKING_YEAR_2  varchar2 (4)  NULL,
			 BOOKING_YEAR_3  varchar2 (4)  NULL,
			 CEDE  varchar2 (1)  NULL,
			 IS_ESTIMATE  varchar2 (1)  NULL,
			 IP_START  varchar2 (14)  NULL,
			 IP_END  varchar2 (14)  NULL,
			 ORIGINAL_IP_START  varchar2 (14)  NULL,
			 ORIGINAL_IP_END  varchar2 (14)  NULL,
			 AUTOMATIC_PROT_ASS  varchar2 (1)  NULL,
			 ATT_FROM  varchar2 (14)  NULL,
			 ATT_TO  varchar2 (14)  NULL,
			 MAIN_LIMIT  decimal (22,0)  NULL,
			 TOTAL_GROSS_P  decimal (22,2)  NULL,
			 SHARE_PCT  decimal (10,6)  NULL,
			 DOL_BEGIN  varchar2 (14)  NULL,
			 DOL_END  varchar2 (14)  NULL,
			 INCL_IN_REC_ORDER  varchar2 (1)  NULL,
			 ACC_AS_OF_DATE  varchar2 (20)  NULL,
			 PC_LIMIT_INFO1  decimal (22,0)  NULL,
			 PC_LIMIT_INFO2  decimal (22,0)  NULL,
			 PC_DECL_ATT_FROM  varchar2 (14)  NULL,
			 PC_DECL_ATT_TO  varchar2 (14)  NULL,
			 PC_DECL_MAIN_L  decimal (22,0)  NULL,
			 PC_RUG_SEQUENT  varchar2 (1)  NULL,
			 LF_SAR  decimal (22,0)  NULL,
			 LF_XTRA_MORTAL_PCT  decimal (10,6)  NULL,
			 LF_OTHER_XTRA_PREM  decimal (10,6)  NULL,
			 LF_AGE  varchar2 (3)  NULL,
			 LF_RETIREMENT_AGE  varchar2 (3)  NULL,
			 LF_IAB_BEGIN_DATE  varchar2 (14)  NULL,
			 LF_IO_DT_OF_BIRTH  varchar2 (14)  NULL,
			 CLAIM_ADVISED_DT  varchar2 (14)  NULL,
			 VERSION  number(10)   NULL,
			 RECORD_UNIQUE_ID  varchar2 (32)  NULL,
			 PID  varchar2 (32)  NULL,
			 STATUS  varchar2 (15)  NULL,
			 BATCH_NAME  number(10)   NULL,
			 PRIM_SYS  varchar2 (15)  NULL,
			 ACCESS_CODE  varchar2 (15)  NULL,
			 BASE_COMPANY  varchar2 (15)  NULL,
			 EC  varchar2 (25)  NULL,
			 CURRENCY  varchar2 (25)  NULL,
			 AC_REF_PERIOD  varchar2 (15)  NULL,
			 BOOKING_PERIOD  varchar2 (15)  NULL,
			 BOOKING_PERIOD2  varchar2 (15)  NULL,
			 BOOKING_PERIOD3  varchar2 (15)  NULL,
			 DTL_COMMENT  varchar2 (254)  NULL,
			 WS_IDENTIFIER  varchar2 (40)  NULL,
			 WS_TITLE  varchar2 (30)  NULL,
			 UDF_TXT1  varchar2 (30)  NULL,
			 UDF_TXT2  varchar2 (30)  NULL,
			 UDF_TXT3  varchar2 (30)  NULL,
			 POLICY_ID  varchar2 (40)  NULL,
			 POLICY_TITLE  varchar2 (60)  NULL,
			 POLICY_FORMER_ID  varchar2 (50)  NULL,
			 REASON_FOR_MANPROT  varchar2 (15)  NULL,
			 SECTION_EXT_ID  varchar2 (32)  NULL,
			 SECTION_NAME  varchar2  (80)  NULL,
			 SEC_CURRENCY  varchar2 (25)  NULL,
			 MAIN_LIMIT_TYPE  varchar2 (15)  NULL,
			 COUNTRY  varchar2 (25)  NULL,
			 COUNTRY_GRP  varchar2 (15)  NULL,
			 STATE  varchar2 (15)  NULL,
			 STATE_GRP  varchar2 (15)  NULL,
			 MCOB  varchar2 (15)  NULL,
			 COB  varchar2 (15)  NULL,
			 SCOB  varchar2 (15)  NULL,
			 ADDL_CLASS_1  varchar2 (15)  NULL,
			 ADDL_CLASS_2  varchar2 (15)  NULL,
			 ADDL_CLASS_3  varchar2 (15)  NULL,
			 ADDL_CLASS_4  varchar2 (15)  NULL,
			 ADDL_CLASS_5  varchar2 (15)  NULL,
			 ADDL_CLASS_6  varchar2 (15)  NULL,
			 ADDL_CLASS_7  varchar2 (15)  NULL,
			 ADDL_CLASS_8  varchar2 (15)  NULL,
			 ADDL_CLASS_9  varchar2 (15)  NULL,
			 ADDL_CLASS_10  varchar2 (15)  NULL,
			 ADDL_CLASS_11  varchar2 (15)  NULL,
			 REP_UNIT_1  varchar2 (15)  NULL,
			 REP_UNIT_2  varchar2 (15)  NULL,
			 REP_UNIT_3  varchar2 (15)  NULL,
			 ORIGIN_OF_BUS  varchar2 (15)  NULL,
			 PERIL  varchar2 (15)  NULL,
			 CLAIM_ID  varchar2 (30)  NULL,
			 HL_LOSS_ID  varchar2 (30)  NULL,
			 HL_LOSS_NAME  varchar2 (60)  NULL,
			 CAUSE_OF_LOSS  varchar2 (15)  NULL,
			 CONSEQUENCE_OF_LOSS  varchar2 (15)  NULL,
			 CLAIM_NAME  varchar2 (60)  NULL,
			 RISKNAME  varchar2 (60)  NULL,
			 CLAIM_UDF_TXT1  varchar2 (30)  NULL,
			 CLAIM_UDF_TXT2  varchar2 (30)  NULL,
			 CLAIM_UDF_TXT3  varchar2 (30)  NULL,
			 PC_LIMIT_INFO1_TYPE  varchar2 (15)  NULL,
			 PC_LIMIT_INFO2_TYPE  varchar2 (15)  NULL,
			 PC_DECL_ID  varchar2 (32)  NULL,
			 PC_DECL_NAME  varchar2 (40)  NULL,
			 PC_DECL_CURR  varchar2 (15)  NULL,
			 PC_INSURED_ID  varchar2 (20)  NULL,
			 PC_INSURED_NAME  varchar2 (255)  NULL,
			 PC_RUG  varchar2 (30)  NULL,
			 PC_RUG_NAME  varchar2 (40)  NULL,
			 PC_IO_ID  varchar2 (15)  NULL,
			 PC_IO_NAME  varchar2 (255)  NULL,
			 PC_IO_TYPE  varchar2 (15)  NULL,
			 PC_CLAIM_BASIS  varchar2 (15)  NULL,
			 LF_TRANS_TYPE  varchar2 (15)  NULL,
			 LF_CALC_BASIS  varchar2 (15)  NULL,
			 LF_SMOKER_STATUS  varchar2 (15)  NULL,
			 LF_OCCUPATION_CLS  varchar2 (15)  NULL,
			 LF_RISK_CLASS  varchar2 (15)  NULL,
			 LF_DISABILITY_CLS  varchar2 (15)  NULL,
			 LF_ESCALATION  varchar2 (15)  NULL,
			 LF_IAB_IDENTIFIER  varchar2 (36)  NULL,
			 LF_IO_PERSON_ID  varchar2 (15)  NULL,
			 LF_IO_PERSON_NAME  varchar2 (50)  NULL,
			 LF_IO_ALIAS  varchar2 (82)  NULL,
			 LF_IO_BIRTH_COUNTRY  varchar2 (15)  NULL,
			 LF_IO_NATIONALITY  varchar2 (15)  NULL,
			 LF_IO_PERSON_STATUS  varchar2 (15)  NULL,
			 LF_IO_GENDER  varchar2 (15)  NULL,
			 REASON_FOR_CHANGE  varchar2 (254)  NULL,	
			 RC_ROW_ID_RC  number(10)  NULL,	
			 POLCVG_LOSS_ROW_ID_RC  number(10)  NULL,
			 EXTERNAL_POLICY_KEY_POLICY   varchar2 (50) NULL,
			 RECORD_TYPE  varchar2 (14) NULL,
			 LINE_OF_BUS_CODE number(10) NULL,
			 CLAIM_TYPE_CODE number(10) NULL,
			 POLICY_LOB_CODE number(10) NULL,
			 INC_POL_COVERAGE number(10) NULL,
			 INC_CLAIMANT number(10) NULL,
			 TRANS_ID number(10) NULL
)';
  EXECUTE IMMEDIATE 'ALTER TABLE DA_SICS ADD CONSTRAINT PK_DA_SICS PRIMARY KEY (JOBID,DA_ROW_ID)';
END IF ;
END;


--==========================================================
---CREATE SICS_OPTIONSET table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='SICS_OPTIONSET';
IF iExists != 0 THEN
EXECUTE IMMEDIATE
'DROP TABLE SICS_OPTIONSET';
iExists := 0 ;
END IF;
IF iExists = 0 THEN
  EXECUTE IMMEDIATE 'CREATE TABLE SICS_OPTIONSET(
         JOBID   number(10)  NOT NULL,
	 OPTIONSET_ID   number(10)   NULL,
	 OPTIONSET_NAME   varchar2  (50)  NULL,
	 TARGET_FILE_NAME   varchar2  (100)  NULL,
	 EXPORT_LAST_RUN_DATE   varchar2  (8)  NULL,
	 SPECIFY_DATE_RANGE   number(10)   NULL,
	 DATE_FROM   varchar2 (8) NULL,
	 DATE_TO   varchar2 (8) NULL
			
)';

END IF ;
END;

--==========================================================
---CREATE DA_CLAIM_EXTRACTED table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DA_CLAIM_EXTRACTED';
IF iExists != 0 THEN
EXECUTE IMMEDIATE
'DROP TABLE DA_CLAIM_EXTRACTED';
iExists := 0 ;
END IF;
IF iExists = 0 THEN
  EXECUTE IMMEDIATE 'CREATE TABLE DA_CLAIM_EXTRACTED(
          DA_ROW_ID  number(10) NOT NULL,
	 JOBID  number(10) NOT NULL,
	 INPUT_ROW_ID  number(10) NULL,
	 INVALID_ROW  number(10) NULL,
	 UPDATE_ROW  number(10) NULL,
	 CLAIM_ID  number(10) NULL,
	 OCC_YR   varchar2 (4) NULL,
	 CLAIM_NAME   varchar2 (60) NULL,
	 CLAIM_ADVISED_DT   varchar2 (14) NULL,
	 RECORD_UNIQUE_ID   varchar2 (32) NULL,
	 DOL   varchar2 (8) NULL,
	 DATE_OF_EVENT   varchar2 (8) NULL
			
)';
  EXECUTE IMMEDIATE 'ALTER TABLE DA_CLAIM_EXTRACTED ADD CONSTRAINT PK_DA_CLAIM_EXTRACTED PRIMARY KEY (JOBID,DA_ROW_ID)';
END IF ;
END;


--==========================================================
---CREATE ERROR_LOG table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='ERROR_LOG';
IF iExists != 0 THEN
EXECUTE IMMEDIATE
'DROP TABLE ERROR_LOG';
iExists := 0 ;
END IF;
IF iExists = 0 THEN
  EXECUTE IMMEDIATE 'CREATE TABLE ERROR_LOG(
          ERR_LOG_ROW_ID  number(10) NOT NULL,
		 JOBID  number(10) NOT NULL,
		 INPUT_ROW_ID  number(10) NULL,
		 MODULE_NAME    varchar2 (50) NULL,
		 WORK_FLOW_NAME    varchar2 (50) NULL,
		 DATA_FLOW_NAME    varchar2 (4000) NULL,
		 ERROR_TIME    varchar2 (14) NULL,
		 ERROR_TITLE    varchar2 (100) NULL,
		 ERROR_DESC    varchar2 (4000) NULL,
		 IS_VALIDATION  number(10) NULL,
		 ERROR_TABLE    varchar2 (50) NULL,
		 TABLE_ROW_ID  number(10) NULL,
		 ERROR_COLUMNS    varchar2 (4000) NULL
			
)';
  EXECUTE IMMEDIATE 'ALTER TABLE ERROR_LOG ADD CONSTRAINT PK_ERROR_LOG PRIMARY KEY (ERR_LOG_ROW_ID,JOBID)';
END IF ;
END;


--==========================================================
---CREATE T_SICS_PROCESS_LOG table 
--============================================================
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='T_SICS_PROCESS_LOG';
IF iExists != 0 THEN
EXECUTE IMMEDIATE
'DROP TABLE T_SICS_PROCESS_LOG';
iExists := 0 ;
END IF;
IF iExists = 0 THEN
  EXECUTE IMMEDIATE 'CREATE TABLE T_SICS_PROCESS_LOG(
          JOBID  number(10)NOT NULL,
		 PROCESS_DESC   varchar2 (500) NULL,
         DISPLAY_ORDER  number(10) NULL,
         TRANS_ID  number(10) NULL,
         IDENTIFIER  number(10)NULL
				
)';
 
END IF ;
END;
END IF;
END;