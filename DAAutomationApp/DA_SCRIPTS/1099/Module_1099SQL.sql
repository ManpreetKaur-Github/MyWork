-- ============================================================
--   Template-1099 MISC Export (Version rmA-16.2 and onwards)
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Database Type: SQL
--   DI Module Name: RM1099
--   DESCRIPTION: Structure Definition Script for
--   Table:	(15 Tables Total)
--		DI_1099_DATACREATED	
--		DI_1099_EXPORT_DATA_STAGING
--		DI_1099_EXPORT_TO_FILE
--		DI_1099_EXPORTDATA
--		DI_1099_MERGED_DATA
--		DI_1099_PAYEE_WITH_VALID_TAXID
--		DI_1099_STAGEDATA_I
--		DI_1099_STAGEDATA_II
--		DI_1099_VALID_PAYEES
--		DI_1099_PARMS
--		DI_1099_PAYER_DATA
--		DI_1099_GLOBAL_LOG
--		DI_1099_VALID_PAYER
--		DI_1099_ORG_HIERARCHY
--		ERROR_LOG
--   DATE:	23/07/2009 2:25:50 PM
-- ============================================================= 
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN

-- Drop All Tables if already exist.

--****** Object:  Table [dbo].[DI_1099_DATACREATED] ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_DATACREATED]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_DATACREATED]

--****** Object:  Table [dbo].[DI_1099_EXPORT_DATA_STAGING] ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORT_DATA_STAGING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_EXPORT_DATA_STAGING]

--****** Object:  Table [dbo].[DI_1099_EXPORT_TO_FILE]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORT_TO_FILE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_EXPORT_TO_FILE]

--****** Object:  Table [dbo].[DI_1099_EXPORTDATA]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORTDATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_EXPORTDATA]

--****** Object:  Table [dbo].[DI_1099_MERGED_DATA]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_MERGED_DATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_MERGED_DATA]

--****** Object:  Table [dbo].[DI_1099_PAYEE_WITH_VALID_TAXID]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PAYEE_WITH_VALID_TAXID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_PAYEE_WITH_VALID_TAXID]

--****** Object:  Table [dbo].[DI_1099_STAGEDATA_I]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_STAGEDATA_I]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_STAGEDATA_I]

--****** Object:  Table [dbo].[DI_1099_STAGEDATA_II]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_STAGEDATA_II]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_STAGEDATA_II]

--****** Object:  Table [dbo].[DI_1099_VALID_PAYEES]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_VALID_PAYEES]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_VALID_PAYEES]

--****** Object:  Table [dbo].[DI_1099_PARMS]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PARMS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_PARMS]

--****** Object:  Table [dbo].[DI_1099_PAYER_DATA]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PAYER_DATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_PAYER_DATA]

--****** Object:  Table [dbo].[DI_1099_GLOBAL_LOG]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_GLOBAL_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_GLOBAL_LOG]

--****** Object:  Table [dbo].[DI_1099_VALID_PAYER]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_VALID_PAYER]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_VALID_PAYER]

--****** Object:  Table [dbo].[DI_1099_ORG_HIERARCHY]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_ORG_HIERARCHY]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[DI_1099_ORG_HIERARCHY]

--****** Object:  Table [dbo].[ERROR_LOG]  ******
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[ERROR_LOG]



---------------------------------------------------------------------

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_DATACREATED]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_DATACREATED](
	[TRANS_ID] [int] NOT NULL,
	[PAYEE_EID] [int] NULL,
	[AMOUNT] [float] NULL,
	[RESERVE_TYPE] [varchar](25) NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[TAX_ID] [varchar](20) NULL,
	[DEPT_EID] [int] NULL,
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [int] NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
	[JOBID] [int] NOT NULL,
	[SPLIT_ROW_ID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORT_DATA_STAGING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_EXPORT_DATA_STAGING](
	[TRANS_ID] [int] NOT NULL,
	[PAYEE_EID] [int] NULL,
	[AMOUNT] [float] NULL,
	[RESERVE_TYPE] [varchar](25) NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[TAX_ID] [varchar](20) NULL,
	[DEPT_EID] [int] NULL,
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [int] NULL,
	[PAYEE_TAX_ID] [varchar](20) NULL,
	[PARENT_TAX_ID] [varchar](20) NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
	[JOBID] [int] NOT NULL,
	[SPLIT_ROW_ID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORT_TO_FILE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_EXPORT_TO_FILE](
	[PAYER_TAX_ID] [varchar](30) NULL,
	[SSN] [varchar](30) NULL,
	[DMEDICAL] [float] NULL,
	[DOTHER] [float] NULL,
	[DBOX13] [float] NULL,
	[DBOX14] [float] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_EXPORTDATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_EXPORTDATA](
	[PAYER_TAX_ID] [varchar](30) NULL,
	[SSN] [varchar](30) NULL,
	[DMEDICAL] [float] NULL,
	[DOTHER] [float] NULL,
	[DBOX13] [float] NULL,
	[DBOX14] [float] NULL,
	[TRANS_ID] [int] NOT NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
	[JOBID] [int] NOT NULL,
	[SPLIT_ROW_ID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_MERGED_DATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_MERGED_DATA](
	[PAYER_TAX_ID] [varchar](30) NULL,
	[SSN] [varchar](30) NULL,
	[DMEDICAL] [float] NULL,
	[DOTHER] [float] NULL,
	[DBOX13] [float] NULL,
	[DBOX14] [float] NULL,
	[TRANS_ID] [int] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PAYEE_WITH_VALID_TAXID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_PAYEE_WITH_VALID_TAXID](
	[PAYEE_EID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[TAX_ID_TYPE] [int] NULL,
	[ADDR1] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[ADDR2] [varchar](50) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [int] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_STAGEDATA_I]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_STAGEDATA_I](
	[PAYEE_EID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[TAX_ID_TYPE] [int] NULL,
	[PAYER_EID] [int] NULL,
	[TRANS_ID] [int] NOT NULL,
	[DEPT_EID] [int] NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[CLAIM_ID] [int] NULL,
	[ADDR1] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[ADDR2] [varchar](50) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [int] NULL,
	[AMOUNT] [float] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
	[ACCOUNT_ID] [int] NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[LINE_OF_BUS_CODE] [int] NULL,
	[JOBID] [int] NOT NULL,
	[REQD_RECORD] [int] NULL,
	[PAYMENT_NO_CLAIM_RECORD] [int] NULL,
	[SPLIT_ROW_ID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_STAGEDATA_II]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_STAGEDATA_II](
	[PAYEE_EID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[TAX_ID_TYPE] [int] NULL,
	[PAYER_EID] [int] NULL,
	[TRANS_ID] [int] NOT NULL,
	[DEPT_EID] [int] NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[CLAIM_ID] [int] NULL,
	[ADDR1] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[ADDR2] [varchar](50) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [int] NULL,
	[AMOUNT] [float] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
	[ACCOUNT_ID] [int] NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[LINE_OF_BUS_CODE] [int] NULL,
	[JOBID] [int] NOT NULL,
	[REQD_RECORD] [int] NULL,
	[PAYMENT_NO_CLAIM_RECORD] [int] NULL,
	[Invalid_TaxID][int] NULL,
	[SPLIT_ROW_ID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_VALID_PAYEES]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_VALID_PAYEES](
	[PAYEE_EID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[TAX_ID_TYPE] [int] NULL,
	[ADDR1] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[ADDR2] [varchar](50) NULL,
	[PARENT_1099_EID] [int] NULL,
	[VALID_PAID_LIMIT][int] NULL,	
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PARMS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_PARMS](
	[FISCAL_YEAR] [varchar](1024) NULL,
	[DATE_FROM] [varchar](1024) NULL,
	[DATE_TO] [varchar](1024) NULL,
	[PAYEE_FILE] [varchar](1024) NULL,
	[PAYER_FILE] [varchar](1024) NULL,
	[DATA_FILE] [varchar](1024) NULL,
	[LOG_FILE] [varchar](1024) NULL,
	[PAYERS_TO_EXPORT] [varchar](1024) NULL,
	[BANK_ACCOUNTS] [varchar](1024) NULL,
	[EXPORT_PRINTED_PAYMENTS_ONLY] [int] NULL,
	[EXPORT_PAYMENTS_WITHOUT_CLAIM] [int] NULL,
	[EXCLUDE_PAYMENTS_TO_ORGHIER] [int] NULL,
	[EXCLUDE_PAYMENTS_TO_CLAIMANTS] [int] NULL,
	[EXCLUDE_DELETED_ENTITIES] [int] NULL,
	[EXPORT_PAYEES_WITH_TOTALPAID] [decimal](28,2) NULL,
	[ROLLUP_PAYMENTS] [int] NULL,
	[IGNORE_TAXID_ERRORS] [int] NULL,
	[CHECK_RM1099_FLAG] [int] NULL,
	[INCLUDE_EID_IN_PAYEE_FILE] [int] NULL,
	[EXPORTALLPYMTS] [INT] NULL,
	[TRANSACTION_TYPE] [varchar](1024) NULL,
	[RESERVE_TYPE] [varchar](1024) NULL,
	[LINE_OF_BUSINESS] [varchar](1024) NULL,
	[MEDICAL_RESERVE_TYPE_BOX6][varchar](1024) NULL,
	[TRANSACTION_TYPE_BOX13] [varchar](1024) NULL,
	[TRANSACTION_TYPE_BOX14] [varchar](1024) NULL,
	[USE_DOUBLE_QUOTES][int] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_PAYER_DATA]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_PAYER_DATA](
	[TAX_ID] [varchar](20) NULL,
	[FLAG] [varchar](1) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[ALSO_KNOWN_AS] [varchar](50) NULL,
	[ADDRESS] [varchar](200) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [varchar](4) NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[PHONE1] [varchar](30) NULL,
	[PAYER_EID] [int] NULL,
	[JOBID] [int] NOT NULL,
	[INVALID_ROW] [int] NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[ADDR1] [varchar](100) NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_GLOBAL_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_GLOBAL_LOG](
	[DTTM_RCD_ADDED] [varchar](29) NULL,
	[LOGINFO] [varchar](1000) NULL,
	[DI_ERRORACTION] [varchar](1) NULL,
	[DI_ERRORCOLUMNS] [varchar](500) NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_VALID_PAYER]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_VALID_PAYER](
	[ADDR1] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[ENTITY_ID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[ENTITY_TABLE_ID] [int] NULL,
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DI_1099_ORG_HIERARCHY]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DI_1099_ORG_HIERARCHY](
	[PAYERID] [int] NULL,
	[PAYER_TAX_ID] [varchar](20) NULL,
	[DEPARTMENT_EID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]
END
------------------------------------------
--  psahay2 05/17/2011 : Change in error log table with refernce to MITS 24994.
--  vgupta20 9/8/2011: Making the error log same as DA2 and MBR modules
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[ERROR_LOG] (
		[ERR_LOG_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[MODULE_NAME] [varchar](50) NULL,
		[WORK_FLOW_NAME] [varchar](50) NULL,
		[DATA_FLOW_NAME] [varchar](50) NULL,
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

END