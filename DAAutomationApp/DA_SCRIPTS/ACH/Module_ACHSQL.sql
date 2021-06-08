-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Database Type:	SQL
--   DI Module Name:	ACH
--   Version:		RMA 17.3 onward
--   DESCRIPTION:	Structure Definition Script
--   DATE LAST UPDATED:	11/09/2017
-- =============================================================
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN
-- =============================================================

---- Drop All Tables if already exist.

--/****** Object 1:  Table [dbo].[T_ACH_SETTING] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_SETTING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_SETTING]

--=============================================================

--/****** Object 2:  Table [dbo].[T_ACH_ACHOUTPUT] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_ACHOUTPUT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) 
DROP TABLE [dbo].[T_ACH_ACHOUTPUT]

 --=============================================================

--/****** Object 3:  Table [dbo].[ERROR_LOG] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[ERROR_LOG]    

--=============================================================

--/****** Object 4:  Table [dbo].[T_ACH_FUNDS] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_FUNDS] 

--=============================================================

--/****** Object 5:  Table [dbo].[T_ACH_FUNDS_AUTO] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_FUNDS_AUTO]

--=============================================================

--/****** Object 6:  Table [dbo].[T_ACH_FUNDS_AUTO_SPLIT] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO_SPLIT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_FUNDS_AUTO_SPLIT]

--=============================================================

--/****** Object 7:  Table [dbo].[T_ACH_FUNDS_AUTO_X_PAYEE] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO_X_PAYEE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_FUNDS_AUTO_X_PAYEE]

--=============================================================

--/****** Object 8:  Table [dbo].[T_ACH_RESERVE_CURRENT] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_RESERVE_CURRENT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_RESERVE_CURRENT]

--=============================================================

--/****** Object 9:  Table [dbo].[T_ACH_RESERVE_HISTORY] ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_RESERVE_HISTORY]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[T_ACH_RESERVE_HISTORY]

--=====================================================================================================================================================================================

--/****** Object 1:  Table [dbo].[T_ACH_SETTING]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_SETTING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_SETTING](
	[JOBID] [int] NULL,
	[BANKFORMAT] [varchar](1024)  NULL,
	[ACCOUNT_ID] [varchar](1024) NULL,
	[MANUALLYCHANGEDATERANGE] [varchar](1024) NULL,
	[FROM_DATE] [varchar](1024)  NULL,
	[TO_DATE] [varchar](1024) NULL,
	[TARGET_FILE] [varchar](1024)  NULL,
	[ORIG_ACH_NAME] [varchar](1024) NULL,
	[COMPANY_NAME] [varchar](1024) NULL,
	[COMPANY_TAXID] [varchar](1024) NULL,
	[COMPANY_DISCDATA] [varchar](1024) NULL,
	[COMPANY_ENTRY_DESC] [varchar](1024) NULL,
	[LOB] [varchar](1024) NULL,
	[EMAIL_TO] [varchar](1024) NULL,
	[TESTRUN] [varchar](1024) NULL,
	[AUTOPAYMENT] [varchar](1024) NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_SETTING
ON T_ACH_SETTING (JOBID)

END

----------------------------------------------
--/****** Object 2:  Table [dbo].[T_ACH_ACHOUTPUT]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_ACHOUTPUT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_ACHOUTPUT](
	[ROW_ID] [int] NOT NULL,
	[JOBID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[SEGMENT] [varchar](50) NULL,
	[ALLDATA] [varchar](157) NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_ACHOUTPUT
ON T_ACH_ACHOUTPUT (JOBID)

END

----------------------------------------------
--/****** Object 3:  Table [dbo].[ERROR_LOG]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[ERROR_LOG](
	[ERR_LOG_ROW_ID] [int] Not NULL,
	[JOBID] [int] Not NULL,
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
	[ERROR_COLUMNS] [varchar](4000) NULL
 CONSTRAINT [PK_ERROR_LOG] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[ERR_LOG_ROW_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
CREATE INDEX ERROR_LOG
ON ERROR_LOG (JOBID)

END

----------------------------------------------
--/****** Object 4:  Table [dbo].[T_ACH_FUNDS]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_FUNDS](
	[JOBID] [int] NOT NULL,
	[TRANS_ID] [int] NOT NULL,
	[CLAIM_NUMBER] [varchar](30) NULL,
	[AMOUNT] float NULL,
	[DATE_OF_CHECK] [varchar](8) NULL,
	[PAYEE_EID] [int] NULL,
	[PAY_TO_THE_ORDER_OF] [varchar](255) NULL,
	[ACCOUNT_ID] [int] NULL,
	[PAYEE_ACCOUNT_TYPE_CODE] decimal(10,0) NULL,
	[PAYEE_ROUTING_NUMBER] [varchar](10) NULL,
	[PAYEE_ACCOUNT_NUMBER] [varchar](20) NULL,
	[IS_VALID] [int] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_FUNDS
ON T_ACH_FUNDS (JOBID)

END

----------------------------------------------
--/****** Object 5:  Table [dbo].[T_ACH_FUNDS_AUTO]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_FUNDS_AUTO](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[FUNDS_AUTO_TRANS_ID] [int] NOT NULL,
	[AUTO_BATCH_ID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[AUTO_CHECK_DETAIL] [varchar](30) NULL,
	[ROLLUP_ID] [int] NULL,
	[VOID_DATE] [varchar](8) NULL,
	[ADDR1] [varchar](100) NULL,
	[ADDR2] [varchar](100) NULL,
	[AUTO_CHECK_FLAG] [int] NULL,
	[CITY] [varchar](50) NULL,
	[CLAIMANT_EID_ARCHIVE] [int] NULL,
	[COUNTRY_CODE] [int] NULL,
	[FIRST_NAME] [varchar](255) NULL,
	[LAST_NAME] [varchar](255) NULL,
	[PRECHECK_FLAG] [int] NULL,
	[STATE_ID] [int] NULL,
	[UNIT_ID_ARCHIVE] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[CLAIM_ID] [int] NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[VOID_FLAG] [int] NULL,
	[DATE_OF_CHECK] [varchar](8) NULL,
	[CHECK_MEMO] [varchar](255) NULL,
	[TRANS_NUMBER] [float] NULL,
	[TRANS_DATE] [varchar](8) NULL,
	[PAYEE_EID] [int] NULL,
	[PAYEE_TYPE_CODE] [int] NULL,
	[ACCOUNT_ID] [int] NULL,
	[AMOUNT] [float] NULL,
	[STATUS_CODE] [int] NULL,
	[FILED_1099_FLAG] [int] NULL,
	[CLEARED_FLAG] [int] NULL,
	[PAYMENT_FLAG] [int] NULL,
	[COLLECTION_FLAG] [int] NULL,
	[COMMENTS] [varchar](max) NULL,
	[CRC] [int] NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	[DTTM_RCD_ADDED] [varchar](14) NULL,
	[UPDATED_BY_USER] [varchar](50) NULL,
	[ADDED_BY_USER] [varchar](50) NULL,
	[BATCH_NUMBER] [int] NULL,
	[SEC_DEPT_EID] [int] NULL,
	[ENCLOSURE_FLAG] [int] NULL,
	[APPROVE_USER] [varchar](8) NULL,
	[DTTM_APPROVAL] [varchar](14) NULL,
	[SUB_ACCOUNT_ID] [int] NULL,
	[SETTLEMENT_FLAG] [int] NULL,
	[APPROVER_ID] [int] NULL,
	[VOUCHER_FLAG] [int] NULL,
	[WEEKS_PAID_CODE] [int] NULL,
	[NUM_OF_PAID_DAYS] [int] NULL,
	[TAX_PAYMENT_FLAG] [int] NULL,
	[RESUBMIT_EDI] [int] NULL,
	[SUPP_PAYMENT_FLAG] [int] NULL,
	[HTMLCOMMENTS] [varchar](max) NULL,
	[REISSUE_FLAG] [int] NULL,
	[REISSUE_BY] [varchar](25) NULL,
	[REISSUE_DATE] [varchar](8) NULL,
	[REISSUE_PARENT_ID] [int] NULL,
	[NOTES_HTMLCOMMENTS] [varchar](max) NULL,
	[REISSUE_REASON_CODE] [int] NULL,
	[MIDDLE_NAME] [varchar](50) NULL,
	[REASON] [varchar](255) NULL,
	[CONF_FLAG] [int] NULL,
	[CONF_EVENT_ID] [int] NULL,
	[VOID_REASON] [varchar](max) NULL,
	[VOID_REASON_HTMLCOMMENTS] [varchar](max) NULL,
	[COMBINED_PAY_FLAG] [int] NULL,
	[PAY_TO_THE_ORDER_OF] [varchar](max) NULL,
	[EFT_FLAG] [int] NULL,
	[PMT_CURRENCY_CODE] [int] NULL,
	[PMT_CURRENCY_AMOUNT]  [float] NULL,
	[PMT_TO_BASE_CUR_RATE_AR]  [float] NULL,
	[PMT_TO_POLICY_CUR_RATE_AR] [float] NULL,
	[CLAIM_CURRENCY_CODE] [int] NULL,
	[CLAIM_CURRENCY_AMOUNT_AR]  [float] NULL,
	[PMT_TO_CLAIM_CUR_RATE_AR]  [float] NULL,
	[BASE_TO_PMT_CUR_RATE_AR]   [float] NULL,
	[BASE_TO_CLAIM_CUR_RATE_AR]  [float] NULL,
	[RES_SUPP_PAYMENT_FLAG] [int] NULL,
	[ADDR3] [varchar](100) NULL,
	[ADDR4] [varchar](100) NULL,
	[COUNTY] [varchar](200) NULL,
	[DSTRBN_TYPE_CODE] [int] NULL,
	[MAIL_TO_ADDRESS_ID] [int] NULL,
	[MAIL_TO_EID] [int] NULL,
	[BASE_TO_POLICY_CUR_RATE_AR] [float] NULL,
	[POLICY_CURRENCY_AMOUNT_AR] [float] NULL,
	[POLICY_CURRENCY_CODE] [int] NULL,
	[POLICY_TO_BASE_CUR_RATE_AR] [float] NULL,
	[INVALID_FLAG] [int] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_FUNDS_AUTO
ON T_ACH_FUNDS_AUTO (JOBID)

END
----------------------------------------------
--/****** Object 6:  Table [dbo].[T_ACH_FUNDS_AUTO_SPLIT]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO_SPLIT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE T_ACH_FUNDS_AUTO_SPLIT(
        [DA_ROW_ID] [int] NOT NULL,
        [JOBID] [int] NOT NULL,
	[FUNDS_AUTO_TRANS_ID] [int] NULL,
	[AUTO_SPLIT_ID] [int] NULL,
        [SUM_AMOUNT] [float] NULL,
        [SPLIT_ROW_ID] [int] NULL,
        [TRANS_ID] [int] NULL,
        [TRANS_TYPE_CODE] [int] NULL,
        [RESERVE_TYPE_CODE_ARCHIVE] [int] NULL,
        [AMOUNT] [float] NULL,
        [GL_ACCOUNT_CODE] [int] NULL,
        [FROM_DATE] [varchar](8) NULL,
        [TO_DATE] [varchar](8) NULL,
        [INVOICED_BY] [varchar](20) NULL,
        [INVOICE_AMOUNT] [float] NULL,
        [INVOICE_NUMBER] [varchar](25) NULL,
        [PO_NUMBER] [varchar](14) NULL,
        [CRC] [int] NULL,
        [DTTM_RCD_LAST_UPD] [varchar](14) NULL,
        [DTTM_RCD_ADDED] [varchar](14) NULL,
        [UPDATED_BY_USER] [varchar](50) NULL,
        [ADDED_BY_USER] [varchar](50) NULL,
        [INVOICE_DATE] [varchar](8) NULL,
        [BILL_RCVD_BY_CARRIER_DATE] [varchar](8) NULL,
        [SUPP_PAYMENT_FLAG] [int] NULL,
        [STAGING_ID] [int] NULL,
        [LI_LINE_NUMBER] [int] NULL,
        [CVG_LOSS_ROW_ID ][int] NULL,                      
        [POLCVG_ROW_ID_ARCHIVE] [int] NULL,                        
        [RC_ROW_ID] [int] NULL,                          
        [PMT_CURRENCY_AMOUNT] [float] NULL,		        
        [PMT_CURRENCY_INVOICE_AMOUNT_AR] [float] NULL,	
        [PMT_CURRENCY_AUTO_DISCOUNT] [float] NULL,		
        [CLAIM_CURRENCY_AMOUNT] [float] NULL,				
        [CLAIM_CURR_INVOICE_AMT_AR] [float] NULL,		
        [CLAIM_CURRENCY_AUTO_DISCOUNT] [float] NULL,
        [AUTO_DISCOUNT] [varchar](10) NULL,
        [SPLIT_CURR_CODE] [float] NULL,
        [SPLIT_CURRENCY_AMOUNT] [float] NULL,
        [SPLIT_CURRENCY_INVOICE_AMOUNT] [float] NULL,
        [SPLIT_CURRENCY_AUTO_DISCOUNT] [float] NULL,
        [SPLIT_TO_BASE_CURRENCY_RATE] [float] NULL,
        [BASE_TO_SPLIT_CURRENCY_RATE] [float] NULL,
        [SPLIT_TO_PAYMENT_CURRENCY_RATE] [float] NULL,
        [IS_FIRST_FINAL] [int] NULL,
        [WITHHOLDING_SPLIT_FLAG] [int] NULL,
        [PARENT_SPLIT_ROW_ID] [int] NULL,
        [CONTROL_REQ_FLAG] [int] NULL,
        [FUNDS_CR_STATUS] [int] NULL,
        [UPDATE_POL_SYS] [int] NULL,
        [POLICY_SYSTEM_ID] [int] NULL,
        [LEGACY_UNIQUE_IDENTIFIER] [varchar](100) NULL,
	[INVOICE_CURRENCY_CODE] [int] NULL,
	[POLICY_CURR_INVOICE_AMT_AR] [float] NULL,
	[POLICY_CURRENCY_AMOUNT] [float] NULL,
	[PMT_TO_BASE_CUR_RATE] [float] NULL,
	[PMT_TO_CLAIM_CUR_RATE] [float] NULL,
	[PMT_TO_POLICY_CUR_RATE] [float] NULL,
	[RESERVE_RC_ROW_ID] [int] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_FUNDS_AUTO_SPLIT
ON T_ACH_FUNDS_AUTO_SPLIT (JOBID)

END

----------------------------------------------
--/****** Object 7:  Table [dbo].[T_ACH_FUNDS_AUTO_X_PAYEE]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_FUNDS_AUTO_X_PAYEE]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_FUNDS_AUTO_X_PAYEE](
      [DA_ROW_ID] [int] NOT NULL, 
      [JOBID] [int] NOT NULL, 
      [PAYEE_ROW_ID] [int] NULL, 
      [PAYEE_EID] [int] NULL, 
      [FUNDS_AUTO_TRANS_ID] [int] NOT NULL,
      [TRANS_ID] [int] NULL,
      [PAYEE_1099_FLAG] [int] NULL,
      [DTTM_RCD_ADDED] [varchar](14),
      [DTTM_RCD_LAST_UPD] [varchar](14),
      [ADDED_BY_USER] [varchar](50),
      [UPDATED_BY_USER] [varchar](50),
      [PAYEE_TYPE_CODE] [int] NULL,
      [PHRASE_TYPE_CODE] [int]  NULL,
      [BEFORE_PAYEE] [int] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_FUNDS_AUTO_X_PAYEE
ON T_ACH_FUNDS_AUTO_X_PAYEE (JOBID)

END

----------------------------------------------
--/****** Object 8:  Table [dbo].[T_ACH_RESERVE_CURRENT]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_RESERVE_CURRENT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_RESERVE_CURRENT](
        [DA_ROW_ID] [int] NOT NULL,
        [JOBID] [int] NOT NULL,
        [INPUT_ROW_ID] [int] NULL,
        [INVALID_ROW] [int] NULL,
        [UPDATE_ROW] [int] NULL,
        [BALANCE_AMOUNT] [int] NULL,
        [RC_ROW_ID] [int] NULL,
        [CLAIM_ID] [int] NULL,
        [UNIT_ID] [int] NULL,
        [CLAIMANT_EID] [int] NULL,
        [RESERVE_TYPE_CODE] [int] NULL,
	[RESERVE_AMOUNT] [int] NULL,
        [INCURRED_AMOUNT] [int] NULL,
        [COLLECTION_TOTAL] [int] NULL,
        [PAID_TOTAL] [int] NULL,
        [DATE_ENTERED] [varchar](8) NULL,
        [ENTERED_BY_USER] [varchar](50) NULL,		
        [REASON] [varchar](30) NULL,
        [UPDATED_BY_USER] [varchar](50) NULL,		
        [DTTM_RCD_ADDED] [varchar](14) NULL,
        [DTTM_RCD_LAST_UPD] [varchar](14) NULL,
        [ADDED_BY_USER] [varchar](50) NULL,			
        [CRC] [int] NULL,
        [SEC_DEPT_EID] [int] NULL,
        [RES_STATUS_CODE] [int] NULL,
        [ALLOCATED_AMOUNT] [int] NULL,
        [CONF_FLAG] [int] NULL,
        [CONF_EVENT_ID] [int] NULL,
        [POLCVG_ROW_ID] [int] NULL,
        [POLCVG_LOSS_ROW_ID] [int] NULL,    
        [STAGING_ID] [int] NULL,
        [CLAIM_CURR_CODE] [int] NULL,					    
        [CLAIM_TO_BASE_CUR_RATE] [int] NULL,			
        [CLAIM_CURRENCY_RESERVE_AMOUNT] [int] NULL,	
        [CLAIM_CURRENCY_INCURRED_AMOUNT] [int] NULL,
        [CLAIM_CURR_COLLECTION_TOTAL] [int] NULL,			
	[CLAIM_CURRENCY_PAID_TOTAL] [int] NULL,		
        [CLAIM_CURRENCY_BALANCE_AMOUNT] [int] NULL,	
        [BASE_TO_CLAIM_CUR_RATE] [int] NULL,		
        [RESERVE_CATEGORY] [int] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_RESERVE_CURRENT
ON T_ACH_RESERVE_CURRENT (JOBID)

END

----------------------------------------------
--/****** Object 9:  Table [dbo].[T_ACH_RESERVE_HISTORY]    Script Date: 11/09/2017 15:24:00 ******/
-- Create the table if not exists already
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_ACH_RESERVE_HISTORY]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_ACH_RESERVE_HISTORY](
	[JOBID] [int] NOT NULL,
	[BALANCE_AMOUNT] [float] NULL,
	[CHANGE_AMOUNT] [float] NULL,
	[RC_ROW_ID] [int] NULL,
	[RESERVE_AMOUNT] [float] NULL,
	[INCURRED_AMOUNT] [float] NULL,
	[PAID_TOTAL] [float] NULL,
	[CLAIM_CURRENCY_RESERVE_AMOUNT] [float] NULL,	
	[CLAIM_CURRENCY_INCURRED_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_PAID_TOTAL] [float] NULL,		
	[CLAIM_CURRENCY_BALANCE_AMOUNT] [float] NULL,
	[POLICY_CURR_CODE] [float] NULL,
	[POLICY_CURR_RESERVE_AMOUNT] [float] NULL,
	[POLICY_CURR_INCURRED_AMOUNT] [float] NULL,
	[POLICY_CURR_COLLECTION_TOTAL] [float] NULL,
	[POLICY_CURR_PAID_TOTAL] [float] NULL,
	[POLICY_CURRENCY_BALANCE_AMOUNT] [float] NULL,
	[POLICY_CURR_CHANGE_AMOUNT] [float] NULL,
	[CLAIM_TO_POLICY_CUR_RATE] [float] NULL,
	[CLAIM_CURR_CHANGE_AMOUNT] [float] NULL,
	[CLAIM_TO_BASE_CUR_RATE] [float] NULL,
	[CLAIM_CURR_CODE] [float] NULL
) ON [PRIMARY]
CREATE INDEX T_ACH_RESERVE_HISTORY
ON T_ACH_RESERVE_HISTORY (JOBID)

END

-- =============================================================
END
