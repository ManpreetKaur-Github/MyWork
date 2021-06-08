
-- ============================================================
--   SCRIPT HEADER (MSSQL RMX_STAGING DATABASE STRUCTURE)
---  Template_SICS(rmA17.1 onwards)
--   Module Name: DA_SICS (All)
--   Description: 	DDL for Data Analytics SICS
--   mkaur24 JIRA RMA-34763 1/19/2017  
-- ============================================================= 
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SICS_OPTIONSET]') AND type in (N'U'))
DROP TABLE [dbo].[SICS_OPTIONSET]


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DA_SICS]') AND type in (N'U'))
DROP TABLE [dbo].[DA_SICS]


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND type in (N'U'))
DROP TABLE [dbo].[ERROR_LOG]


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DA_CLAIM_EXTRACTED]') AND type in (N'U'))
DROP TABLE [dbo].[DA_CLAIM_EXTRACTED]



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_SICS_PROCESS_LOG]') AND type in (N'U'))
DROP TABLE [dbo].[T_SICS_PROCESS_LOG]





IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SICS_OPTIONSET]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[SICS_OPTIONSET](	
	[JOBID] [int] NOT NULL,
	[OPTIONSET_ID] [int]  NULL,
	[OPTIONSET_NAME] [varchar] (50)  NULL,
	[TARGET_FILE_NAME] [varchar] (100)  NULL,
	[EXPORT_LAST_RUN_DATE] [varchar] (8)  NULL,
	[SPECIFY_DATE_RANGE] [int]  NULL,
	[DATE_FROM] [varchar](8) NULL,
	[DATE_TO] [varchar](8) NULL,	
	
) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DA_SICS') 
BEGIN

	CREATE TABLE [dbo].[DA_SICS](
			[DA_ROW_ID] [int] NOT NULL,
			[JOBID] [int] NOT NULL,
			[INPUT_ROW_ID] [int] NULL,
			[INVALID_ROW] [int] NULL,
			[UPDATE_ROW] [int] NULL,
			[IMPORT_TS][varchar](20) NULL,
			[CREATION_TS][varchar](20) NULL,
			[DTL_AMT] [decimal](22,2) NULL,
			[AS_AT][varchar](1)  NULL,
			[OCC_YR][varchar](4)  NULL,
			[UW_YEAR][varchar](4)  NULL,
			[AC_YEAR][varchar](4)  NULL,
			[AC_START_DATE][varchar](20)  NULL,
			[AC_END_DATE][varchar](20)  NULL,
			[DATE_OF_BOOKING][varchar](20)  NULL,
			[BOOKING_YEAR][varchar](4)  NULL,
			[BOOKING_YEAR_2][varchar](4)  NULL,
			[BOOKING_YEAR_3][varchar](4)  NULL,
			[CEDE][varchar](1)  NULL,
			[IS_ESTIMATE][varchar](1)  NULL,
			[IP_START][varchar](14)  NULL,
			[IP_END][varchar](14)  NULL,
			[ORIGINAL_IP_START][varchar](14)  NULL,
			[ORIGINAL_IP_END][varchar](14)  NULL,
			[AUTOMATIC_PROT_ASS][varchar](1)  NULL,
			[ATT_FROM][varchar](14)  NULL,
			[ATT_TO][varchar](14)  NULL,
			[MAIN_LIMIT][decimal](22,0)  NULL,
			[TOTAL_GROSS_P][decimal](22,2)  NULL,
			[SHARE_PCT][decimal](10,6)  NULL,
			[DOL_BEGIN][varchar](14)  NULL,
			[DOL_END][varchar](14)  NULL,
			[INCL_IN_REC_ORDER][varchar](1)  NULL,
			[ACC_AS_OF_DATE][varchar](20)  NULL,
			[PC_LIMIT_INFO1][decimal](22,0)  NULL,
			[PC_LIMIT_INFO2][decimal](22,0)  NULL,
			[PC_DECL_ATT_FROM][varchar](14)  NULL,
			[PC_DECL_ATT_TO][varchar](14)  NULL,
			[PC_DECL_MAIN_L][decimal](22,0)  NULL,
			[PC_RUG_SEQUENT][varchar](1)  NULL,
			[LF_SAR][decimal](22,0)  NULL,
			[LF_XTRA_MORTAL_PCT][decimal](10,6)  NULL,
			[LF_OTHER_XTRA_PREM][decimal](10,6)  NULL,
			[LF_AGE][varchar](3)  NULL,
			[LF_RETIREMENT_AGE][varchar](3)  NULL,
			[LF_IAB_BEGIN_DATE][varchar](14)  NULL,
			[LF_IO_DT_OF_BIRTH][varchar](14)  NULL,
			[CLAIM_ADVISED_DT][varchar](14)  NULL,
			[VERSION][int]  NULL,
			[RECORD_UNIQUE_ID][varchar](32)  NULL,
			[PID][varchar](32)  NULL,
			[STATUS][varchar](15)  NULL,
			[BATCH_NAME][INT]  NULL,
			[PRIM_SYS][varchar](15)  NULL,
			[ACCESS_CODE][varchar](15)  NULL,
			[BASE_COMPANY][varchar](15)  NULL,
			[EC][varchar](25)  NULL,
			[CURRENCY][varchar](25)  NULL,
			[AC_REF_PERIOD][varchar](15)  NULL,
			[BOOKING_PERIOD][varchar](15)  NULL,
			[BOOKING_PERIOD2][varchar](15)  NULL,
			[BOOKING_PERIOD3][varchar](15)  NULL,
			[DTL_COMMENT][varchar](254)  NULL,
			[WS_IDENTIFIER][varchar](40)  NULL,
			[WS_TITLE][varchar](30)  NULL,
			[UDF_TXT1][varchar](30)  NULL,
			[UDF_TXT2][varchar](30)  NULL,
			[UDF_TXT3][varchar](30)  NULL,
			[POLICY_ID][varchar](40)  NULL,
			[POLICY_TITLE][varchar](60)  NULL,
			[POLICY_FORMER_ID][varchar](50)  NULL,
			[REASON_FOR_MANPROT][varchar](15)  NULL,
			[SECTION_EXT_ID][varchar](32)  NULL,
			[SECTION_NAME][varchar] (80)  NULL,
			[SEC_CURRENCY][varchar](25)  NULL,
			[MAIN_LIMIT_TYPE][varchar](15)  NULL,
			[COUNTRY][varchar](25)  NULL,
			[COUNTRY_GRP][varchar](15)  NULL,
			[STATE][varchar](15)  NULL,
			[STATE_GRP][varchar](15)  NULL,
			[MCOB][varchar](15)  NULL,
			[COB][varchar](15)  NULL,
			[SCOB][varchar](15)  NULL,
			[ADDL_CLASS_1][varchar](15)  NULL,
			[ADDL_CLASS_2][varchar](15)  NULL,
			[ADDL_CLASS_3][varchar](15)  NULL,
			[ADDL_CLASS_4][varchar](15)  NULL,
			[ADDL_CLASS_5][varchar](15)  NULL,
			[ADDL_CLASS_6][varchar](15)  NULL,
			[ADDL_CLASS_7][varchar](15)  NULL,
			[ADDL_CLASS_8][varchar](15)  NULL,
			[ADDL_CLASS_9][varchar](15)  NULL,
			[ADDL_CLASS_10][varchar](15)  NULL,
			[ADDL_CLASS_11][varchar](15)  NULL,
			[REP_UNIT_1][varchar](15)  NULL,
			[REP_UNIT_2][varchar](15)  NULL,
			[REP_UNIT_3][varchar](15)  NULL,
			[ORIGIN_OF_BUS][varchar](15)  NULL,
			[PERIL][varchar](15)  NULL,
			[CLAIM_ID][varchar](30)  NULL,
			[HL_LOSS_ID][varchar](30)  NULL,
			[HL_LOSS_NAME][varchar](60)  NULL,
			[CAUSE_OF_LOSS][varchar](15)  NULL,
			[CONSEQUENCE_OF_LOSS][varchar](15)  NULL,
			[CLAIM_NAME][varchar](60)  NULL,
			[RISKNAME][varchar](60)  NULL,
			[CLAIM_UDF_TXT1][varchar](30)  NULL,
			[CLAIM_UDF_TXT2][varchar](30)  NULL,
			[CLAIM_UDF_TXT3][varchar](30)  NULL,
			[PC_LIMIT_INFO1_TYPE][varchar](15)  NULL,
			[PC_LIMIT_INFO2_TYPE][varchar](15)  NULL,
			[PC_DECL_ID][varchar](32)  NULL,
			[PC_DECL_NAME][varchar](40)  NULL,
			[PC_DECL_CURR][varchar](15)  NULL,
			[PC_INSURED_ID][varchar](20)  NULL,
			[PC_INSURED_NAME][varchar](255)  NULL,
			[PC_RUG][varchar](30)  NULL,
			[PC_RUG_NAME][varchar](40)  NULL,
			[PC_IO_ID][varchar](15)  NULL,
			[PC_IO_NAME][varchar](255)  NULL,
			[PC_IO_TYPE][varchar](15)  NULL,
			[PC_CLAIM_BASIS][varchar](15)  NULL,
			[LF_TRANS_TYPE][varchar](15)  NULL,
			[LF_CALC_BASIS][varchar](15)  NULL,
			[LF_SMOKER_STATUS][varchar](15)  NULL,
			[LF_OCCUPATION_CLS][varchar](15)  NULL,
			[LF_RISK_CLASS][varchar](15)  NULL,
			[LF_DISABILITY_CLS][varchar](15)  NULL,
			[LF_ESCALATION][varchar](15)  NULL,
			[LF_IAB_IDENTIFIER][varchar](36)  NULL,
			[LF_IO_PERSON_ID][varchar](15)  NULL,
			[LF_IO_PERSON_NAME][varchar](50)  NULL,
			[LF_IO_ALIAS][varchar](82)  NULL,
			[LF_IO_BIRTH_COUNTRY][varchar](15)  NULL,
			[LF_IO_NATIONALITY][varchar](15)  NULL,
			[LF_IO_PERSON_STATUS][varchar](15)  NULL,
			[LF_IO_GENDER][varchar](15)  NULL,
			[REASON_FOR_CHANGE][varchar](254)  NULL,	
			[RC_ROW_ID_RC][int] NULL,	
			[POLCVG_LOSS_ROW_ID_RC][int] NULL,
			[EXTERNAL_POLICY_KEY_POLICY] [varchar](50) NULL,
			[RECORD_TYPE][varchar](14) NULL,
			[LINE_OF_BUS_CODE][int] NULL,
			[CLAIM_TYPE_CODE][int] NULL,
			[POLICY_LOB_CODE][int] NULL,
			[INC_POL_COVERAGE][int] NULL,
			[INC_CLAIMANT][int] NULL,
			[TRANS_ID][int] NULL,
			
	 CONSTRAINT [PK_DA_SICS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DA_CLAIM_EXTRACTED]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DA_CLAIM_EXTRACTED](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[CLAIM_ID] [int] NULL,
	[OCC_YR] [varchar](4) NULL,
	[CLAIM_NAME] [varchar](60) NULL,
	[CLAIM_ADVISED_DT] [varchar](14) NULL,
	[RECORD_UNIQUE_ID] [varchar](32) NULL,
	[DOL] [varchar](8) NULL,
	[DATE_OF_EVENT] [varchar](8) NULL,
 CONSTRAINT [PK_DA_CLAIM_EXTRACTED] PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[ERROR_LOG] (
		[ERR_LOG_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[MODULE_NAME] [varchar](50) NULL,
		[WORK_FLOW_NAME] [varchar](50) NULL,
		[DATA_FLOW_NAME] [varchar](4000) NULL,
		[ERROR_TIME] [varchar](14) NULL,
		[ERROR_TITLE] [varchar](100) NULL,
		[ERROR_DESC] [varchar](4000) NULL,
		[IS_VALIDATION] [int] NULL,
		[ERROR_TABLE] [varchar](50) NULL,
		[TABLE_ROW_ID] [int] NULL,
		[ERROR_COLUMNS] [varchar](4000) NULL,
	 CONSTRAINT [PK_ERROR_LOG] PRIMARY KEY CLUSTERED
	(
		[ERR_LOG_ROW_ID] ASC,
		[JOBID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_SICS_PROCESS_LOG') 
BEGIN
	CREATE TABLE [dbo].T_SICS_PROCESS_LOG(
		[JOBID] [int] NOT NULL,
		[PROCESS_DESC] [varchar](500) NULL,
        [DISPLAY_ORDER] [int]  NULL,
        [TRANS_ID] [int]  NULL,
        [IDENTIFIER] [int] NULL
		
	 )
END

END