-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   DA Module Name: MMSEA	
--   Template-RMA_16.2 and above MMSEA Medicare
--   DESCRIPTION: Structure Definition Script for
--   Table:	
--		T_MMSEA_OPTIONSET
--		T_MMSEA_DACLAIMANT
--		T_MMSEA_QUERYRESP
--		T_MMSEA_UNVALIDATE
--		T_MMSEA_CHECKED_QRES
--		T_MMSEA_QUERY_EXPORT 
--		T_MMSEA_EXTRA_TPOC 
--		T_MMSEA_TIN_DATA
--		T_MMSEA_ALLCLAIMAN
--		T_MMSEA_C1_ATTORNEY 
--		T_MMSEA_CLAIM_DETAIL
--		T_MMSEA_CLAIM_AUXI
--		T_MMSEA_CLAIM_RESPONSE_HEADER
--		T_MMSEA_CLAIM_RESPONSE_DETAIL
--		T_MMSEA_CLAIM_RESPONSE_TRAILER
--     		T_MMSEA_ADJLOGDATA
--      	TPOC_THRESHOLD 
--		T_MMSEA_TIN_RESPONSE_DETAIL
--      	T_MMSEA_TIN_RESP_OTHER_DATA
--		WPA_DIARY_ENTRY
--		WPA_DIARY_ACT
--      	ENTITY_X_MMSEA
--     		ERROR_LOG

--	/*** OBSOLETE TABLES ***/
--		T_MMSEA_RCLAIMANT
--		T_MMSEA_INJ_PARTY
--		T_MMSEA_DIAGNCODES
--		T_MMSEA_PRODUCT
--		T_MMSEA_POLICYHOLD
--		T_MMSEA_TPOC
--		T_MMSEA_MOSTRECENT
--		T_MMSEA_PLAN_INFO
--		T_MMSEA_ATTORNEY
--		T_MMSEA_1CLAIMANT
--		T_MMSEA_C_ATTORNEY
--		T_MMSEA_TIN_RESPONSE_OTHER_DATA


--   DATE:	06/22/2009 2:25:50 PM
--   DATE:	12/22/2010 : VSONI5 - MITS 23328 
--   DATE:      06/29/2012 : ipuri -  MITS 28538
-- =============================================================


--   ipuri 06/29/2012  Mits:28538  Drop statements removed start
-- =============================================================
--	   Drop the OBSOLETE staging tables if exist.
-- =============================================================
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN

-- DROP TABLE T_MMSEA_RCLAIMANT
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_RCLAIMANT]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_RCLAIMANT]

-- DROP TABLE T_MMSEA_INJ_PARTY
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_INJ_PARTY]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_INJ_PARTY]

-- DROP TABLE T_MMSEA_DIAGNCODES
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_DIAGNCODES]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_DIAGNCODES]

-- DROP TABLE T_MMSEA_PRODUCT
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_PRODUCT]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_PRODUCT]

-- DROP TABLE T_MMSEA_POLICYHOLD
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_POLICYHOLD]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_POLICYHOLD]

-- DROP TABLE T_MMSEA_TPOC
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TPOC]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_TPOC]

-- DROP TABLE T_MMSEA_MOSTRECENT
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_MOSTRECENT]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_MOSTRECENT]

-- DROP TABLE T_MMSEA_PLAN_INFO
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_PLAN_INFO]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_PLAN_INFO]

-- DROP TABLE T_MMSEA_ATTORNEY
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_ATTORNEY]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_ATTORNEY]

-- DROP TABLE T_MMSEA_1CLAIMANT
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_1CLAIMANT]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_1CLAIMANT]

-- DROP TABLE T_MMSEA_C_ATTORNEY
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_C_ATTORNEY]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_C_ATTORNEY]

-- DROP TABLE T_MMSEA_TIN_RESPONSE_OTHER_DATA
--IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_RESPONSE_OTHER_DATA]') AND type in (N'U'))
--DROP TABLE [dbo].[T_MMSEA_TIN_RESPONSE_OTHER_DATA]

----------------------------------------------------------------


--   ipuri 06/29/2012  Mits:28538  Drop statements removed end
-- =============================================================
--     create new tables if does not exist.
-- =============================================================
----------------------------------------------------------------
-- Object 1 : T_MMSEA_OPTIONSET
-- Create the table if not exists already -kdchoudhary
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_OPTIONSET]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_OPTIONSET]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_OPTIONSET]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_OPTIONSET](
	[JOBID] [int] Not NULL,
	[RRE_ID] [varchar](9) NULL,
	[TYPE_OF_FILE] [varchar](15) NULL,
	[FILE_FORMAT] [varchar](15) NULL,
	[IMPORTFILE_NAME] [varchar](255) NULL,
	[TEST_EXPORT] [varchar](2) NULL,
	[SCHEDULE_USER_ID] [int] NULL,
	[PRIMARY_CLAIMANT_FLAG] [varchar](2) NULL,
	[TPOCS_THRESHOLD_FLAG] [varchar](2) NULL,
	[TIN_IMPORTFILE_NAME] [varchar](255) NULL,
	[CLAIMTYPE] [varchar](1024) NULL,
	[DIARY_NOTIFICATION_SEND] [int] NULL,
	[DIARY_NOTIFICATION_CURR_ADJ] [int] NULL,
	[DIARY_SEND_OTH_USER_ID] [varchar] (100) NULL,
	[DIARY_SEND_OTH_GROUP_ID] [varchar] (100) NULL,
	[DIARY_SEND_OTH_USER_NAME] [varchar] (500) NULL,
	[DIARY_SEND_OTH_GROUP_NAME] [varchar] (500) NULL,

 CONSTRAINT [PK__T_MMSEA_OPTIONSET] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC

) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 2 : T_MMSEA_DACLAIMANT
-- Create the table if not exists already -kdchoudhary
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_DACLAIMANT]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_DACLAIMANT]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_DACLAIMANT]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_DACLAIMANT](
	[JOBID] [int] NOT NULL,
	[RRE_ID] [varchar](9) NULL,
	[CLAIMANT_EID] [int] NOT NULL,
	[CLAIM_ID] [int] NOT NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
	[TAX_ID] [varchar](20) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[MIDDLE_NAME] [varchar](50) NULL,
	[ADDR1] [varchar](50) NULL,
	[ADDR2] [varchar](50) NULL,
	[CITY] [varchar](50) NULL,
	[STATE_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[SEX_CODE] [int] NULL,
	[BIRTH_DATE] [varchar](8) NULL,
	[POLICY_NUMBER] [varchar](30) NULL,
	[INSURED_TYPE] [varchar](20) NULL,
	[MMSEA_BENEFIY_CODE] [varchar](7) NULL,
	[MMSEA_CONFIRM_DATE] [varchar](8) NULL,
	[MMSEA_HICN_TEXT] [varchar](12) NULL,
	[TIN_ENTITY_ID] [int] NULL,
 CONSTRAINT [PK__T_MMSEA_CLAIMANT] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[CLAIMANT_EID] ASC,
	[CLAIM_ID] ASC,
	[CLAIMANT_ROW_ID] ASC

) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 3 : T_MMSEA_QUERYRESP
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_QUERYRESP]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_QUERYRESP]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_QUERYRESP]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_QUERYRESP](
	[JOBID] [int] Not NULL,
	[HIC_NUMBER] [varchar](12) NULL,
	[LAST_NAME] [varchar](6) NULL,
	[FRIST_INITIAL] [varchar](1) NULL,
	[DOB] [varchar](8) NULL,
	[SEX_CODE] [varchar](1) NULL,
	[SSN] [varchar](9) Not NULL,
	[DISPOSITION_CODE] [varchar](2) NULL,
	[CMS_DOCUMENT_CONTROL_NUMBER] [varchar](15) NULL,
	[RRE_DCN_1] [varchar](30) Not NULL
 CONSTRAINT [PK__T_MMSEA_QUERYRESP] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[SSN]  ASC,
	[RRE_DCN_1] ASC

) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 4 : T_MMSEA_UNVALIDATE
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_UNVALIDATE]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_UNVALIDATE]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_UNVALIDATE]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_UNVALIDATE](
	[JOBID] [int] Not NULL,
	[TYPE_OF_FILE] [varchar](8) NULL,
	[FILE_FORMAT] [varchar](15) NULL,
	[CLAIMANT_EID] [int] NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
	[CLAIM_ID] [int] NULL,
	[TAX_ID] [varchar](20) NULL,
	[LAST_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](50) NULL,
	[MMSEA_HICN_TEXT] [varchar](12) NULL,
	[DI_ERRORACTION] [varchar](1) NULL,
	[DI_ERRORCOLUMNS] [varchar](500) NULL,
	[CMS_CONTROL_NUMBER] [varchar](15) NULL,
	[VALIDATION_ERROR] [varchar](2000) NULL,
	[ATTACH_TABLE] [varchar](18) NULL,
	[ATTACH_RECORED_ID] [int] NULL,
 CONSTRAINT [PK__T_MMSEA_UNVALIDATE] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[CLAIMANT_ROW_ID]  ASC

) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 5 : T_MMSEA_CHECKED_QRES
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CHECKED_QRES]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CHECKED_QRES]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_CHECKED_QRES]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CHECKED_QRES](
	[JOBID] [int] Not NULL,
	[HIC_NUMBER] [varchar](12) NULL,
	[LAST_NAME] [varchar](6) NULL,
	[FRIST_INITIAL] [varchar](1) NULL,
	[DOB] [varchar](8) NULL,
	[SEX_CODE] [varchar](1) NULL,
	[SSN] [varchar](9) NULL,
	[DISPOSITION_CODE] [varchar](2) NULL,
	[CMS_DOCUMENT_CONTROL_NUMBER] [varchar](15) NULL,
	[CLAIM_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(  
	 [JOBID] ASC,
	[CLAIMANT_ROW_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 6 : T_MMSEA_QUERY_EXPORT
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_QUERY_EXPORT]') AND type in (N'U'))
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_QUERY_EXPORT]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_QUERY_EXPORT]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_QUERY_EXPORT](
	[JOBID] [int] Not NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
	[MMSEA_HICN_TEXT] [varchar](12) NULL,
	[LAST_NAME] [varchar](6) NULL,
	[FIRST_NAME] [varchar](1) NULL,
	[BIRTH_DATE] [varchar](8) NULL,
	[SEX_CODE] [varchar](25) NULL,
	[TAX_ID] [varchar](20) NULL,
	[FILLER] [varchar](1) NULL,
	[RRE_DCN_1] [varchar](30) NULL
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 7 : T_MMSEA_EXTRA_TPOC
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_EXTRA_TPOC]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_EXTRA_TPOC]') AND type in (N'U'))
DROP TABLE [dbo].[T_MMSEA_EXTRA_TPOC]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_EXTRA_TPOC](
	[JOBID] [int] NOT NULL,
	[CLAIMANT_EID] [int] NOT NULL,
	[CLAIM_ID] [int] NOT NULL,
	[CLAIMANT_ROW_ID] [int] NULL,
	[TPOC_ROW_ID_2] [int] NULL,
	[FUNDING_DELAYED_BEYOND_2] [varchar](8) NULL,
	[TPOC_AMOUNT_2] [varchar](11) NULL,
	[TPOC_DATE_2] [varchar](8) NULL,
	[TPOC_ROW_ID_3] [int] NULL,
	[FUNDING_DELAYED_BEYOND_3] [varchar](8) NULL,
	[TPOC_AMOUNT_3] [varchar](11) NULL,
	[TPOC_DATE_3] [varchar](8) NULL,
	[TPOC_ROW_ID_4] [int] NULL,
	[FUNDING_DELAYED_BEYOND_4] [varchar](8) NULL,
	[TPOC_AMOUNT_4] [varchar](11) NULL,
	[TPOC_DATE_4] [varchar](8) NULL,
	[TPOC_ROW_ID_5] [int] NULL,
	[FUNDING_DELAYED_BEYOND_5] [varchar](8) NULL,
	[TPOC_AMOUNT_5] [varchar](11) NULL,
	[TPOC_DATE_5] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(   [JOBID] ASC,
	[CLAIMANT_EID] ASC,
	[CLAIM_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 8 : T_MMSEA_TIN_DATA
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_DATA]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_DATA]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_TIN_DATA]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_TIN_DATA](
	[JOBID] [int] NOT NULL,
	[LINE_OF_BUS_CODE] [int] NOT NULL, 
	[ENTITY_ID] [int] NOT NULL,
	[RRE_ID] [varchar](9)NOT NULL,
	[TIN] [varchar](9) NULL,
	[OFFICE_CODE_SITE_ID] [varchar](9) NULL,
	[TIN_OFFICE_CODE_MAILING_NAME] [varchar](70) NULL,
	[TIN_OFFICE_CODE_ADDR_LINE_1] [varchar](50) NULL,
	[TIN_OFFICE_CODE_ADDR_LINE_2] [varchar](50) NULL,
	[TIN_OFFICE_CODE_CITY] [varchar](30) NULL,
	[TIN_OFFICE_CODE_STATE] [varchar](2) NULL,
	[TIN_OFFICE_CODE_ZIP_CODE] [varchar](5) NULL,
	[TIN_OFFICE_CODE_ZIP4] [varchar](4) NULL,
	[TIN_EDIT_FLAG] [smallint] NULL,
	[COUNTRY] [varchar](25) NULL,
	[FOREIGN_RRE_ADDRESS_LINE1][varchar] (32) NULL,
	[FOREIGN_RRE_ADDRESS_LINE2][varchar] (32) NULL,
	[FOREIGN_RRE_ADDRESS_LINE3][varchar] (32) NULL,
	[FOREIGN_RRE_ADDRESS_LINE4][varchar] (32) NULL,
	[ERROR_ROW_ID] [int] NULL, 
	[VALIDATE_FLAG] [int] NULL,
	[RECOVERY_AGENT_NAME] [varchar] (70) NULL,
	[RECOVERY_AGENT_ADDR1] [varchar] (50) NULL,
	[RECOVERY_AGENT_ADDR2] [varchar] (50) NULL,
	[RECOVERY_AGENT_CITY] [varchar] (30) NULL,
	[RECOVERY_AGENT_STATE] [varchar] (2) NULL,
	[RECOVERY_AGENT_ZIP] [varchar] (5) NULL,
	[RECOVERY_AGENT_ZIP4] [varchar] (4) NULL,
PRIMARY KEY CLUSTERED 
(   [JOBID] ASC,
	[ENTITY_ID]ASC,
	[LINE_OF_BUS_CODE] ASC, 
	[RRE_ID] ASC

) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 9 : T_MMSEA_ALLCLAIMAN
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_ALLCLAIMAN]') AND type in (N'U'))
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_ALLCLAIMAN]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_ALLCLAIMAN] 

BEGIN
CREATE TABLE [dbo].[T_MMSEA_ALLCLAIMAN](
	[JOBID] [int] Not NULL,
	[CLAIMANT_EID] [int] NOT NULL,
	[CLAIMANT_ROW_ID] [int] NULL,
	[CLAIM_ID] [int] NOT NULL,
	[MMSEA_CLMT_ROW_ID] [int] NOT NULL,
	[MMSEA_CLAIMANT_EID] [int] NULL,
	[CLAIMANT_RELATIONSHIP] [varchar](1) NULL,
	[CLAIMANT_TIN] [varchar](9) NULL,
	[CLAIMANT_LASTNAME] [varchar](40) NULL,
	[CLAIMANT_FIRSTNAME] [varchar](30) NULL,
	[CLAIMANT_MIDDLEINITIAL] [varchar](1) NULL,
	[CLAIMANT_MAILING_ADDRESS_LINE1] [varchar](50) NULL,
	[CLAIMANT_MAILING_ADDRESS_LINE2] [varchar](50) NULL,
	[CLAIMANT_CITY] [varchar](30) NULL,
	[CLAIMANT_STATE] [varchar](2) NULL,
	[CLAIMANT_ZIP] [varchar](5) NULL,
	[CLAIMANT_ZIP4] [varchar](4) NULL,
	[CLAIMANT_PHONE] [varchar](10) NULL,
	[CLAIMANT_PHONE_EXT] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(   [JOBID] ASC,
	[CLAIMANT_EID] ASC,
	[CLAIM_ID] ASC,
	[MMSEA_CLMT_ROW_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 10 : T_MMSEA_C1_ATTORNEY
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_C1_ATTORNEY]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_C1_ATTORNEY]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_C1_ATTORNEY] 

BEGIN
CREATE TABLE [dbo].[T_MMSEA_C1_ATTORNEY](
	[JOBID] [int] NULL,
	[CLAIM_ID] [int] NULL,
	[CLAIMANT_EID] [int] NULL,
	[CLAIMANT_ROW_ID] [int] NULL,
	[PARENT_EID] [int] NULL,
	[MMSEA_CLMT_ROW_ID] [int] NULL,
	[MMSEA_CLAIMANT_EID] [int] NULL,
	[C1_REPRESENTATIVE_INDICATOR] [varchar](1) NULL,
	[C1_REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[C1_REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[C1_REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[C1_REPRESENTATIVE_TIN] [varchar](9) NULL,
	[C1_REPRESENTATIVE_ADDR1] [varchar](50) NULL,
	[C1_REPRESENTATIVE_ADDR2] [varchar](50) NULL,
	[C1_REPRESENTATIVE_MAIL_CITY] [varchar](30) NULL,
	[C1_REPRESENTATIVE_STATE] [varchar](2) NULL,
	[C1_REPRESENTATIVE_ZIP] [varchar](5) NULL,
	[C1_REPRESENTATIVE_ZIP4] [varchar](4) NULL,
	[C1_REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[C1_REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 11 : T_MMSEA_CLAIM_DETAIL
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_DETAIL]') AND type in (N'U')) 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_DETAIL]') AND type in (N'U')) 

DROP TABLE [dbo].[T_MMSEA_CLAIM_DETAIL]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CLAIM_DETAIL](
	[JOBID] [int] Not NULL,
	[CLAIMANT_EID] [int] NOT NULL,
	[CLAIM_ID] [int] NOT NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
	[RECORD_IDENTIFIER] [varchar](4) NULL,
	[DCN] [varchar](15) NOT NULL,
	[ACTION_TYPE] [varchar](1) NULL,
	[INJURED_PARTY_HICN] [varchar](12) NULL,
	[INJURED_PARTY_SSN] [varchar](9) NULL,
	[INJURED_PARTY_LAST_NAME] [varchar](40) NULL,
	[INJURED_PARTY_FIRST_NAME] [varchar](30) NULL,
	[INJURED_PARTY_MIDDLE_INIT] [varchar](1) NULL,
	[INJURED_PARTY_GENDER] [varchar](1) NULL,
	[INJURED_PARTY_DOB] [varchar](8) NULL,
	[CMS_DATE_OF_INCIDENT] [varchar](8) NULL,
	[INDUSTRY_DATE] [varchar](8) NULL,
	[ALLEGED_CAUSE_OF_INJURY] [varchar](7) NULL,
	[STATE_OF_VENUES] [varchar](2) NULL,
	[ICD_INDICATOR][varchar](1) NULL,
	[CDC_ICD_DIGNS_CODE_1] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_2] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_3] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_4] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_5] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_6] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_7] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_8] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_9] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_10] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_11] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_12] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_13] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_14] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_15] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_16] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_17] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_18] [varchar](7) NULL,
	[CDC_ICD_DIGNS_CODE_19] [varchar](7) NULL,
	[DESCRIPTION_OF_ILLNESS_INJURY] [varchar](50) NULL,
	[MMSEA_PRO_LIY_CODE] [varchar](1) NULL,
	[MMSEA_PRO_GEN_TEXT] [varchar](40) NULL,
	[MMSEA_PRO_BRD_TEXT] [varchar](40) NULL,
	[MMSEA_PRO_MAN_TEXT] [varchar](40) NULL,
	[MMSEA_PRO_ALL_TEXT] [varchar](200) NULL,
	[SELF_INSURED_INDICATOR] [varchar](1) NULL,
	[SELF_INSURED_TYPE] [varchar](1) NULL,
	[POLICYHOLDER_LAST_NAME] [varchar](40) NULL,
	[POLICYHOLDER_FIRST_NAME] [varchar](30) NULL,
	[DBA_NAME] [varchar](70) NULL,
	[LEGAL_NAME] [varchar](70) NULL,
	[PLAN_INSURANCE_TYPE] [varchar](1) NULL,
	[TIN] [varchar](9) NULL,
	[OFFICE_CODE_SITE_ID] [varchar](9) NULL,
	[POLICY_NUMBER] [varchar](30) NULL,
	[CLAIM_NUMBER] [varchar](30) NULL,
	[PLAN_CONTACT_DEPT_NAME] [varchar](70) NULL,
	[PLAN_CONTACT_LAST_NAME] [varchar](40) NULL,
	[PLAN_CONTACT_FIRST_NAME] [varchar](30) NULL,
	[PLAN_CONTACT_PHONE] [varchar](10) NULL,
	[PLAN_CONTACT_PHONE_EXT] [varchar](5) NULL,
	[NO_FAULT_INSURANCE_LIMIT] [varchar](11) NULL,
	[EXHAUST_DATE_DOLLAR_LIMIT] [varchar](8) NULL,
	[INJURIED_PART_REP_INDICATOR] [varchar](1) NULL,
	[REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[REPRESENTATIVE_TIN] [varchar](9) NULL,
	[REPRESENTATIVE_ADDR_LINE1] [varchar](50) NULL,
	[REPRESENTATIVE_ADDR_LINE2] [varchar](50) NULL,
	[REPRESENTATIVE_CITY] [varchar](30) NULL,
	[REPRESENTATIVE_STATE] [varchar](2) NULL,
	[REPRESENTATIVE_ZIP_CODE] [varchar](5) NULL,
	[REPRESENTATIVE_ZIP_CODE4] [varchar](4) NULL,
	[REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL,
	[ORM] [varchar](1) NULL,
	[ORM_TERMINATION_DATE] [varchar](8) NULL,
	[TPOC_START_DATE] [varchar](8) NULL,
	[TPOC_AMOUNT] [varchar](11) NULL,
	[FUNDING_DELAYED_BEYOND] [varchar](8) NULL,
	[CLAIMANT1_RELATIONSHIP] [varchar](1) NULL,
	[CLAIMANT1_TIN] [varchar](9) NULL,
	[CLAIMANT1_LASTNAME] [varchar](40) NULL,
	[CLAIMANT1_FIRSTNAME] [varchar](30) NULL,
	[CLAIMANT1_MIDDLEINITIAL] [varchar](1) NULL,
	[CLAIMANT1_ADDR_LINE1] [varchar](50) NULL,
	[CLAIMANT1_ADDR_LINE2] [varchar](50) NULL,
	[CLAIMANT1_CITY] [varchar](30) NULL,
	[CLAIMANT1_STATE] [varchar](2) NULL,
	[CLAIMANT1_ZIP] [varchar](5) NULL,
	[CLAIMANT1_ZIP4] [varchar](4) NULL,
	[CLAIMANT1_PHONE] [varchar](10) NULL,
	[CLAIMANT1_PHONE_EXT] [varchar](5) NULL,
	[C1_REPRESENTATIVE_INDICATOR] [varchar](1) NULL,
	[C1_REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[C1_REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[C1_REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[C1_REPRESENTATIVE_TIN] [varchar](9) NULL,
	[C1_REPRESENTATIVE_ADDR1] [varchar](50) NULL,
	[C1_REPRESENTATIVE_ADDR2] [varchar](50) NULL,
	[C1_REPRESENTATIVE_MAIL_CITY] [varchar](30) NULL,
	[C1_REPRESENTATIVE_STATE] [varchar](2) NULL,
	[C1_REPRESENTATIVE_ZIP] [varchar](5) NULL,
	[C1_REPRESENTATIVE_ZIP4] [varchar](4) NULL,
	[C1_REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[C1_REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL,
	[PARTY_TO_CLAIMANT_ID] [int] NULL, 
	[EDIT_RMX_DATABASE_FLAG] [int] NULL,
	[VALIDATE_FLAG] [int] NULL, 
	[ERROR_ROW_ID] [int] NULL
	

PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[CLAIMANT_ROW_ID] ASC,
	[DCN] ASC
	
) ON [PRIMARY]
) ON [PRIMARY]
END

----------------------------------------------------------------
-- Object 12 : T_MMSEA_CLAIM_AUXI
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_AUXI]') AND type in (N'U')) 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_AUXI]') AND type in (N'U')) 

DROP TABLE [dbo].[T_MMSEA_CLAIM_AUXI]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CLAIM_AUXI](
	[JOBID] [int] Not NULL,
	[CLAIMANT_EID] [int] NOT NULL,
	[CLAIM_ID] [int] NOT NULL,
	[CLAIMANT_ROW_ID] [int] NOT NULL,
	[RECORD_IDENTIFIER] [varchar](4) NULL,
	[DCN] [varchar](15) NULL,
	[INJURED_PARTY_HICN] [varchar](12) NULL,
	[INJURED_PARTY_SSN] [varchar](9) NULL,
	[INJURED_PARTY_LAST_NAME] [varchar](40) NULL,
	[INJURED_PARTY_FIRST_NAME] [varchar](30) NULL,
	[CLAIMANT_2_RELATIONSHIP] [varchar](1) NULL,
	[CLAIMANT_2_CLAIMANT_TIN] [varchar](9) NULL,
	[CLAIMANT_2_LASTNAME] [varchar](40) NULL,
	[CLAIMANT_2_FIRSTNAME] [varchar](30) NULL,
	[CLAIMANT_2_MIDDLEINITIAL] [varchar](1) NULL,
	[CLAIMANT_2_ADDR_LINE1] [varchar](50) NULL,
	[CLAIMANT_2_ADDR_LINE2] [varchar](50) NULL,
	[CLAIMANT_2_CITY] [varchar](30) NULL,
	[CLAIMANT_2_STATE] [varchar](2) NULL,
	[CLAIMANT_2_ZIP] [varchar](5) NULL,
	[CLAIMANT_2_ZIP4] [varchar](4) NULL,
	[CLAIMANT_2_PHONE] [varchar](10) NULL,
	[CLAIMANT_2_PHONE_EXT] [varchar](5) NULL,
	[C2_REPRESENTATIVE_INDICATOR] [varchar](1) NULL,
	[C2_REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[C2_REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[C2_REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[C2_REPRESENTATIVE_TIN] [varchar](9) NULL,
	[C2_REPRESENTATIVE_ADDR1] [varchar](50) NULL,
	[C2_REPRESENTATIVE_ADDR2] [varchar](50) NULL,
	[C2_REPRESENTATIVE_MAIL_CITY] [varchar](30) NULL,
	[C2_REPRESENTATIVE_STATE] [varchar](2) NULL,
	[C2_REPRESENTATIVE_ZIP] [varchar](5) NULL,
	[C2_REPRESENTATIVE_ZIP4] [varchar](4) NULL,
	[C2_REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[C2_REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL,
	[CLAIMANT_3_RELATIONSHIP] [varchar](1) NULL,
	[CLAIMANT_3_TIN] [varchar](9) NULL,
	[CLAIMANT_3_LASTNAME] [varchar](40) NULL,
	[CLAIMANT_3_FIRSTNAME] [varchar](30) NULL,
	[CLAIMANT_3_MIDDLEINITIAL] [varchar](1) NULL,
	[CLAIMANT_3_ADDR_LINE1] [varchar](50) NULL,
	[CLAIMANT_3_ADDR_LINE2] [varchar](50) NULL,
	[CLAIMANT_3_CITY] [varchar](30) NULL,
	[CLAIMANT_3_CLAIMANT_STATE] [varchar](2) NULL,
	[CLAIMANT_3_ZIP] [varchar](5) NULL,
	[CLAIMANT_3_ZIP4] [varchar](4) NULL,
	[CLAIMANT_3_PHONE] [varchar](10) NULL,
	[CLAIMANT_3_PHONE_EXT] [varchar](5) NULL,
	[C3_REPRESENTATIVE_INDICATOR] [varchar](1) NULL,
	[C3_REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[C3_REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[C3_REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[C3_REPRESENTATIVE_TIN] [varchar](9) NULL,
	[C3_REPRESENTATIVE_ADDR1] [varchar](50) NULL,
	[C3_REPRESENTATIVE_ADDR2] [varchar](50) NULL,
	[C3_REPRESENTATIVE_MAIL_CITY] [varchar](30) NULL,
	[C3_REPRESENTATIVE_STATE] [varchar](2) NULL,
	[C3_REPRESENTATIVE_ZIP] [varchar](5) NULL,
	[C3_REPRESENTATIVE_ZIP4] [varchar](4) NULL,
	[C3_REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[C3_REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL,
	[CLAIMANT_4_RELATIONSHIP] [varchar](1) NULL,
	[CLAIMANT_4_TIN] [varchar](9) NULL,
	[CLAIMANT_4_LASTNAME] [varchar](40) NULL,
	[CLAIMANT_4_FIRSTNAME] [varchar](30) NULL,
	[CLAIMANT_4_MIDDLEINITIAL] [varchar](1) NULL,
	[CLAIMANT_4_ADDR_LINE1] [varchar](50) NULL,
	[CLAIMANT_4_ADDR_LINE2] [varchar](50) NULL,
	[CLAIMANT_4_CITY] [varchar](30) NULL,
	[CLAIMANT_4_STATE] [varchar](2) NULL,
	[CLAIMANT_4_ZIP] [varchar](5) NULL,
	[CLAIMANT_4_ZIP4] [varchar](4) NULL,
	[CLAIMANT_4_PHONE] [varchar](10) NULL,
	[CLAIMANT_4_PHONE_EXT] [varchar](5) NULL,
	[C4_REPRESENTATIVE_INDICATOR] [varchar](1) NULL,
	[C4_REPRESENTATIVE_LAST_NAME] [varchar](40) NULL,
	[C4_REPRESENTATIVE_FIRST_NAME] [varchar](30) NULL,
	[C4_REPRESENTATIVE_FIRM_NAME] [varchar](70) NULL,
	[C4_REPRESENTATIVE_TIN] [varchar](9) NULL,
	[C4_REPRESENTATIVE_ADDR1] [varchar](50) NULL,
	[C4_REPRESENTATIVE_ADDR2] [varchar](50) NULL,
	[C4_REPRESENTATIVE_MAIL_CITY] [varchar](30) NULL,
	[C4_REPRESENTATIVE_STATE] [varchar](2) NULL,
	[C4_REPRESENTATIVE_ZIP] [varchar](5) NULL,
	[C4_REPRESENTATIVE_ZIP4] [varchar](4) NULL,
	[C4_REPRESENTATIVE_PHONE] [varchar](10) NULL,
	[C4_REPRESENTATIVE_PHONE_EXT] [varchar](5) NULL,
	[TPOC_DATE_2] [varchar](8) NULL,
	[TPOC_AMOUNT_2] [varchar](11) NULL,
	[FUNDING_DELAYED_BEYOND_2] [varchar](8) NULL,
	[TPOC_DATE_3] [varchar](8) NULL,
	[TPOC_AMOUNT_3] [varchar](11) NULL,
	[FUNDING_DELAYED_BEYOND_3] [varchar](8) NULL,
	[TPOC_DATE_4] [varchar](8) NULL,
	[TPOC_AMOUNT_4] [varchar](11) NULL,
	[FUNDING_DELAYED_BEYOND_4] [varchar](8) NULL,
	[TPOC_DATE_5] [varchar](8) NULL,
	[TPOC_AMOUNT_5] [varchar](11) NULL,
	[FUNDING_DELAYED_BEYOND_5] [varchar](8) NULL,
	[VALIDATE_FLAG] [int] NULL, 
	[ERROR_ROW_ID] [int] NULL


 CONSTRAINT [PK__T_MMSEA_CLAIM_AU] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[CLAIMANT_EID] ASC,
	[CLAIM_ID] ASC, 
	[CLAIMANT_ROW_ID] ASC

) ON [PRIMARY]
) 
END
----------------------------------------------------------------
-- Object 13 : T_MMSEA_CLAIM_RESPONSE_HEADER
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_HEADER]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_HEADER]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_HEADER]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_HEADER](
	[JobId] [int] NULL,
	[RECORDID] [varchar](4) NULL,
	[REPORTERID] [int] NULL,
	[REPORTINGFILETYPE] [varchar](7) NULL,
	[SUBMISSIONDATE] [varchar](8) NULL,
	[BADFLAG] [int] NULL
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 14 : T_MMSEA_CLAIM_RESPONSE_DETAIL
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_DETAIL]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_DETAIL]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_DETAIL]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_DETAIL](
	[JOBID] [int] Not NULL,
	[RECORDID] [varchar](4) NULL,
	[CLAIM_NUMBER] [varchar](30) NULL,
	[SUBDCN] [varchar](15) NULL,
	[SUBACTIONTYPE] [int] NULL,
	[INJPARTYHICN] [varchar](12) NULL,
	[SUBINJSSN] [varchar](9) NULL,
	[SUNINJLASTNAME] [varchar](40) NULL,
	[SUBINJFIRSTNAME] [varchar](30) NULL,
	[SUBINJMIDDLEINIT] [varchar](1) NULL,
	[SUBINJGENDER] [int] NULL,
	[SUBINJDOB] [varchar](8) NULL,
	[SUBTIN] [int] NULL,
	[SUBOFFICECODE] [varchar](9) NULL,
	[APPINJHICN] [varchar](12) NULL,
	[APPINJLASTNAME] [varchar](40) NULL,
	[APPINJFIRSTNAME] [varchar](30) NULL,
	[APPINJMIDDLEINIT] [varchar](1) NULL,
	[APPINJGENDER] [int] NULL,
	[APPINJDOB] [varchar](8) NULL,
	[APPEFFECTIVEDATE] [varchar](8) NULL,
	[APPTERMINATIONDATE] [varchar](8) NULL,
	[APPTYPEINDICATOR] [varchar](1) NULL,
	[RESERVED2] [varchar](20) NULL,
	[APPDISPOSITIONCODE] [varchar](2) NULL,
	[APPERROR1] [varchar](5) NULL,
	[APPERROR2] [varchar](5) NULL,
	[APPERROR3] [varchar](5) NULL,
	[APPERROR4] [varchar](5) NULL,
	[APPERROR5] [varchar](5) NULL,
	[APPERROR6] [varchar](5) NULL,
	[APPERROR7] [varchar](5) NULL,
	[APPERROR8] [varchar](5) NULL,
	[APPERROR9] [varchar](5) NULL,
	[APPERROR10] [varchar](5) NULL,
	[APPCOMPLAINCEFLAG1] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG2] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG3] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG4] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG5] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG6] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG7] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG8] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG9] [varchar](2) NULL,
	[APPCOMPLAINCEFLAG10] [varchar](2) NULL
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 15 : T_MMSEA_CLAIM_RESPONSE_TRAILER
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_TRAILER]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_CLAIM_RESPONSE_TRAILER]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_TRAILER]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_CLAIM_RESPONSE_TRAILER](
	[JobId] [int] NULL,
	[RECORDID] [varchar](4) NULL,
	[REPORTERID] [int] NULL,
	[REPORTINGFILETYPE] [varchar](7) NULL,
	[FILESUBMISSIONDATE] [varchar](8) NULL,
	[FILERECORDCOUNT] [int] NULL,
	[BADFLAG] [int] NULL
) ON [PRIMARY]
END

----------------------------------------------------------------
-- Object 16 : T_MMSEA_ADJLOGDATA
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_ADJLOGDATA]') AND type in (N'U')) 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_ADJLOGDATA]') AND type in (N'U')) 

DROP TABLE [dbo].[T_MMSEA_ADJLOGDATA]

BEGIN
CREATE TABLE [dbo].[T_MMSEA_ADJLOGDATA](
	[JOBID] [int] NOT NULL,
	[LOGIN_NAME] [varchar](50) NULL,
	[ADJUSTER_EID] [int] NULL,
	[RM_USER_ID] [int] NOT NULL,
	[ADJ_ROW_ID] [int] NULL,
	[CLAIM_ID] [int] NOT NULL,
	[SCHEDULE_USER_LOGIN] [varchar](50) NULL,
) ON [PRIMARY]
END
----------------------------------------------------------------
-- Object 17 : TPOC_THRESHOLD 
IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TPOC_THRESHOLD]') AND type in (N'U'))
 
--DROP TABLE [dbo].[TPOC_THRESHOLD]

CREATE TABLE [dbo].[TPOC_THRESHOLD](
	[THRESHOLD_MIN_DATE] [varchar](9) NOT NULL,
	[THRESHOLD_END_DATE] [varchar](9) NOT NULL,	
	[THRESHOLD_AMOUNT] [float]  NOT NULL,
	[LINE_OF_BUS_CODE] [int] NOT NULL

PRIMARY KEY CLUSTERED 
(  
	[THRESHOLD_MIN_DATE] ASC,
	[THRESHOLD_END_DATE] ASC,
	[THRESHOLD_AMOUNT] ASC,
	[LINE_OF_BUS_CODE] ASC
) ON [PRIMARY]
) ON [PRIMARY]
----------------------------------------------------------------
-- Object 18 : ERROR_LOG
-- Create the table if not exists already MITS 30003 -kdchoudhary

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)

DROP TABLE [dbo].[ERROR_LOG]
BEGIN
CREATE TABLE [dbo].[ERROR_LOG](
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
PRIMARY KEY CLUSTERED 
(  
	 [JOBID] ASC,
	 [ERR_LOG_ROW_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
----------------------------------------------------------------

-- Object 19 : T_MMSEA_TIN_RESPONSE_DETAIL
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_RESPONSE_DETAIL]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_RESPONSE_DETAIL]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_TIN_RESPONSE_DETAIL] 

BEGIN
CREATE TABLE [dbo].[T_MMSEA_TIN_RESPONSE_DETAIL](
	
	[JOBID] [int] NOT NULL,
	[ROW_ID] [int] NOT NULL,
	[RECORD_IDENTIFIER] [varchar](4) NULL,
	[SECTION_111_RRE_ID] [varchar](9) NULL,
	[SUBMIT_TIN] [varchar](9) NULL,
	[SUBMIT_OFFICE_CODE] [varchar](9) NULL,
	[SUBMIT_TIN_MAILING_NAME] [varchar](70) NULL,
	[SUBMIT_TIN_MAILING_ADDRESS_1] [varchar](50) NULL,
	[SUBMIT_TIN_MAILING_ADDRESS_2] [varchar](50) NULL,
	[SUBMIT_TIN_MAILING_CITY] [varchar](30) NULL,
	[SUBMIT_TIN_MAILING_STATE] [varchar](2) NULL,
	[SUBMIT_TIN_CODE_ZIP] [varchar](5) NULL,
	[SUBMIT_TIN_CODE_ZIP_4] [varchar](4) NULL,
	[APPLIED_TIN_MAILING_ADDRESS_1] [varchar](50) NULL,
	[APPLIED_TIN_MAILING_ADDRESS_2] [varchar](50) NULL,
	[APPLIED_TIN_CITY] [varchar](30) NULL,
	[APPLIED_TIN_STATE] [varchar](2) NULL,
	[APPLIED_TIN_ZIP] [varchar](5) NULL,
	[APPLIED_TIN_ZIP_4] [varchar](4) NULL,
	[SUBMIT_FORIGN_ADDRESS_LINE_1] [varchar](32) NULL,
	[SUBMIT_FORIGN_ADDRESS_LINE_2] [varchar](32) NULL,
	[SUBMIT_FORIGN_ADDRESS_LINE_3] [varchar](32) NULL,
	[SUBMIT_FORIGN_ADDRESS_LINE_4] [varchar](32) NULL,
	[TIN_DISP_CODE] [varchar](2) NULL,
	[TIN_ERROR_CODE_1] [varchar](4) NULL,
	[TIN_ERROR_CODE_2] [varchar](4) NULL,
	[TIN_ERROR_CODE_3] [varchar](4) NULL,
	[TIN_ERROR_CODE_4] [varchar](4) NULL,
	[TIN_ERROR_CODE_5] [varchar](4) NULL,
	[TIN_ERROR_CODE_6] [varchar](4) NULL,
	[TIN_ERROR_CODE_7] [varchar](4) NULL,
	[TIN_ERROR_CODE_8] [varchar](4) NULL,
	[TIN_ERROR_CODE_9] [varchar](4) NULL,
	[TIN_ERROR_CODE_10] [varchar](4) NULL,
	[TIN_OFFICE_CODE_CHANGE_FLAG] [varchar](1) NULL,
	[REC_AGENT_ADDR_CHANGE_FLAG] [varchar](1) NULL,
	[SUBMIT_REC_AGENT_MAIL_NAME] [varchar](70) NULL,
	[SUBMIT_REC_AGENT_MAIL_ADDR1] [varchar](50) NULL,
	[SUBMIT_REC_AGENT_MAIL_ADDR2] [varchar](50) NULL,
	[SUBMIT_REC_AGENT_CITY] [varchar](30) NULL,
	[SUBMIT_REC_AGENT_STATE] [varchar](2) NULL,
	[SUBMIT_REC_AGENT_ZIP] [varchar](5) NULL,
	[SUBMIT_REC_AGENT_ZIP4] [varchar](4) NULL,
	[APPLIED_REC_AGENT_MAIL_ADDR1] [varchar](50) NULL,
	[APPLIED_REC_AGENT_MAIL_ADDR2] [varchar](50) NULL,
	[APPLIED_REC_AGENT_CITY] [varchar](30) NULL,
	[APPLIED_REC_AGENT_STATE] [varchar](2) NULL,
	[APPLIED_REC_AGENT_ZIP] [varchar](5) NULL,
	[APPLIED_REC_AGENT_ZIP4] [varchar](4) NULL,
	[ERROR_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[ROW_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
-- =============================================================

-- Object 20 : T_MMSEA_TIN_RESP_OTHER_DATA
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_RESP_OTHER_DATA]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_MMSEA_TIN_RESP_OTHER_DATA]') AND type in (N'U'))

DROP TABLE [dbo].[T_MMSEA_TIN_RESP_OTHER_DATA] 

BEGIN
CREATE TABLE [dbo].[T_MMSEA_TIN_RESP_OTHER_DATA](

	[JOBID] [int] NOT NULL,
	[ROW_ID] [int] NOT NULL,
	[RECORD_IDENTIFIER] [varchar](4) NULL,
	[SECTION_111_RRE_ID] [varchar](9) NULL,
	[SECTION_111_REPO_FILE_TYPE] [varchar](7) NULL,
	[FILE_DATE] [varchar](8) NULL,
	[FILE_RECORD_COUNT] [varchar](35) NULL,
	[ERROR_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
PRIMARY KEY CLUSTERED 
(  
	[JOBID] ASC,
	[ROW_ID] ASC
	
) ON [PRIMARY]

) 
END
-- =============================================================

-- Object 21 : WPA_DIARY_ENTRY
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[WPA_DIARY_ENTRY]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[WPA_DIARY_ENTRY]') AND type in (N'U'))

DROP TABLE [dbo].[WPA_DIARY_ENTRY] 

BEGIN
CREATE TABLE [dbo].[WPA_DIARY_ENTRY](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[ATT_FORM_CODE] [int] NULL,
	[ATT_FORM_SCRTY] [int] NULL,
	[ATT_PARENT_CODE] [int] NULL,
	[ATT_SEC_REC_ID] [int] NULL,
	[AUTO_ID] [int] NULL,
	[DIARY_DELETED] [smallint] NULL,
	[DIARY_VOID] [smallint] NULL,
	[ESTIMATE_TIME] [float] NULL,
	[NOTIFY_FLAG] [smallint] NULL,
	[ROUTE_FLAG] [smallint] NULL,
	[ENTRY_ID] [int] NOT NULL,
	[ENTRY_NAME] [varchar](200) NULL,
	[ENTRY_NOTES] [varchar](2000) NULL,
	[CREATE_DATE] [varchar](14) NULL,
	[COMPLETE_TIME] [varchar](6) NULL,
	[COMPLETE_DATE] [varchar](8) NULL,
	[PRIORITY] [int] NULL,
	[STATUS_OPEN] [smallint] NULL,
	[AUTO_CONFIRM] [smallint] NULL,
	[RESPONSE_DATE] [varchar](8) NULL,
	[RESPONSE] [varchar](200) NULL,
	[ASSIGNED_USER] [varchar](50) NULL,
	[ASSIGNING_USER] [varchar](50) NULL,
	[ASSIGNED_GROUP] [varchar](50) NULL,
	[IS_ATTACHED] [smallint] NULL,
	[ATTACH_TABLE] [varchar](18) NULL,
	[ATTACH_RECORDID] [int] NULL,
	[REGARDING] [varchar](70) NULL,
	[TE_TRACKED] [smallint] NULL,
	[TE_START_TIME] [varchar](6) NULL,
	[TE_END_TIME] [varchar](6) NULL,
	[TE_TOTAL_HOURS] [float] NULL,
	[TE_EXPENSES] [float] NULL,
	[COMPLETED_BY_USER] [varchar](50) NULL
	
PRIMARY KEY CLUSTERED 
(  
	[JOBID] ASC,
	[DA_ROW_ID] ASC
	
) ON [PRIMARY]

) 
END
-- =============================================================
-- Object 22 : WPA_DIARY_ACT
-- Create the table if not exists already -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[WPA_DIARY_ACT]') AND type in (N'U'))
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[WPA_DIARY_ACT]') AND type in (N'U'))
DROP TABLE [dbo].[WPA_DIARY_ACT] 

BEGIN
CREATE TABLE [dbo].[WPA_DIARY_ACT](

	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[ACTIVITY_ID] [int] NOT NULL,
	[PARENT_ENTRY_ID] [int] NULL,
	[ACT_CODE] [int] NULL,
	[ACT_TEXT] [varchar](50) NULL,
	
PRIMARY KEY CLUSTERED 
(  
	[JOBID] ASC,
	[DA_ROW_ID] ASC
	
) ON [PRIMARY]
)
END
-- =============================================================

-- Object 23 : ENTITY_X_MMSEA
-- Create the table if not exists already  -kdchoudhary
--IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTITY_X_MMSEA]') AND type in (N'U')) 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ENTITY_X_MMSEA]') AND type in (N'U')) 
DROP TABLE [dbo].[ENTITY_X_MMSEA]

BEGIN
CREATE TABLE [dbo].[ENTITY_X_MMSEA](

	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[ENT_MMSEA_ROW_ID] [int] NOT NULL,
	[ENTITY_ID] [int] NOT NULL,
	[MMSEA_REPRTER_TEXT] [varchar](9) NOT NULL,
	[MMSEA_OFE_STE_TEXT] [varchar](9) NULL,
	[LINE_OF_BUS_CODE] [int] NOT NULL,
	[MMSEA_TIN_EDT_FLAG] [smallint] NOT NULL,
	[ADDED_BY_USER] [varchar](50) NOT NULL,
	[UPDATED_BY_USER] [varchar](50) NOT NULL,
	[DTTM_RCD_ADDED] [varchar](14) NOT NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NOT NULL,
	[REPORT_SCHED_CODE] [int] NULL,
	
PRIMARY KEY CLUSTERED 
(  
	[JOBID] ASC,
	[DA_ROW_ID] ASC
	
) ON [PRIMARY]

) 
END

--kdchoudhary 11/19/2012
--MITS 29528 
--ALTER TABLE T_MMSEA_QUERYRESP DROP CONSTRAINT PK__T_MMSEA_QUERYRESP

--ALTER TABLE T_MMSEA_QUERYRESP ALTER COLUMN RRE_DCN_1 INTEGER NOT NULL 
--ALTER TABLE T_MMSEA_QUERYRESP ADD CONSTRAINT PK__T_MMSEA_QUERYRESP PRIMARY KEY (JOBID,SSN,RRE_DCN_1)  
--END MITS 29528

END


-- END OF SCRIPT
-- =============================================================