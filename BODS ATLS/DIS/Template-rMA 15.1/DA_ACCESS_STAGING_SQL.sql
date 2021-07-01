-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Template-rMA 15.1_DIS
--   Database Type: Sql Server
--   DI Module Name: DIS MS ACCESS DATABASE
--===========================================


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE]') AND type in (N'U'))
DROP TABLE [dbo].[EMPLOYEE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_X_DEPENDENT]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_X_DEPENDENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_X_VIOLATION]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_X_VIOLATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY]
GO

IF EXISTS (SELECT * FROM sys.objects where object_id = OBJECT_ID(N'[dbo].[ENTITY_X_ADDRESSES]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_X_ADDRESSES]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_EXPOSURE]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_EXPOSURE]
GO

IF EXISTS (SELECT * FROM sys.objects where object_id = OBJECT_ID(N'[dbo].[ADDRESS_X_PHONEINFO]') AND type in (N'U'))
DROP TABLE [dbo].[ADDRESS_X_PHONEINFO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_DEPOSIT]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_DEPOSIT]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_ACC_DATE]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE_X_ACC_DATE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_INSPCT]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE_X_INSPCT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MED_STAFF]') AND type in (N'U'))
DROP TABLE [dbo].[MED_STAFF]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_CERTS]') AND type in (N'U'))
DROP TABLE [dbo].[STAFF_CERTS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_PRIVS]') AND type in (N'U'))
DROP TABLE [dbo].[STAFF_PRIVS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MED_STAFF_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[MED_STAFF_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_PROCEDURE]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_PROCEDURE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ACT_TAKEN]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_ACT_TAKEN]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DRG_CODES]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_DRG_CODES]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ATTN_PHYS]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_ATTN_PHYS]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DIAGNOSIS]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_DIAGNOSIS]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_PROC_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_PROC_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_X_CLAIM]') AND type in (N'U'))
DROP TABLE [dbo].[UNIT_X_CLAIM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_X_CLAIM_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[UNIT_X_CLAIM_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_CVG_TYPE]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY_X_CVG_TYPE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_INSURED]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY_X_INSURED]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_INSURER]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY_X_INSURER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_PROPERTYLOSS]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_PROPERTYLOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_PROPERTYLOSS_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_PROPERTYLOSS_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_SITELOSS]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_SITELOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_OTHERUNIT]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_OTHERUNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITE_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[SITE_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROPERTY_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[PROPERTY_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POINT_UNIT_DATA]') AND type in (N'U'))
DROP TABLE [dbo].[POINT_UNIT_DATA]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSON_INVOLVED]') AND type in (N'U'))
DROP TABLE [dbo].[PERSON_INVOLVED]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DRIVER]') AND type in (N'U'))
DROP TABLE [dbo].[DRIVER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESERVES]') AND type in (N'U'))
DROP TABLE [dbo].[RESERVES]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OTHER_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[OTHER_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_TRANS_SPLIT]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_TRANS_SPLIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYSICIAN]') AND type in (N'U'))
DROP TABLE [dbo].[PHYSICIAN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_CERTS]') AND type in (N'U'))
DROP TABLE [dbo].[PHYS_CERTS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_EDUCATION]') AND type in (N'U'))
DROP TABLE [dbo].[PHYS_EDUCATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_PREV_HOSP]') AND type in (N'U'))
DROP TABLE [dbo].[PHYS_PREV_HOSP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_PRIVS]') AND type in (N'U'))
DROP TABLE [dbo].[PHYS_PRIVS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_SUB_SPECIALTY]') AND type in (N'U'))
DROP TABLE [dbo].[PHYS_SUB_SPECIALTY]
GO


--Create tables
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BOND_ABS](
	[OPTIONSET_ID] [int] NULL,
        [BOND_ABS_ID] [int] NULL,
	[BOND_NUM_TEXT] [nvarchar](20) NULL,
	[BOND_TYPE_TXCD] [ntext] NULL,
	[BOND_LINE_CODE] [int] NULL,
	[EFF_DATE_DATE] [nvarchar](8) NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[BOND_AMT_AMT] [float] NULL,
	[PREMIUM_AMT] [float] NULL,
	[BILL_NAME_TEXT] [nvarchar](50) NULL,
	[BILL_ADDR_TEXT] [nvarchar](50) NULL,
	[BILL_CITY_TEXT] [nvarchar](25) NULL,
	[BILL_ZIP_TEXT] [nvarchar](15) NULL,
	[BILL_ACCT_TEXT] [nvarchar](50) NULL,
	[PRINCIPAL_TXCD] [ntext] NULL,
	[STATE_TEXT] [nvarchar](3) NULL,
	[BILL_STATE_TEXT] [nvarchar](25) NULL,
	[OBLIGEE_TXCD] [ntext] NULL,
	[BOND_CLASS_CODE] [int] NULL,
	[OLD_BOND_NO_TEXT] [nvarchar](25) NULL,
	[REQUESTER_TEXT] [nvarchar](50) NULL,
	[REQ_ADDR_TEXT] [nvarchar](50) NULL,
	[REQ_CITY_TEXT] [nvarchar](25) NULL,
	[REQ_STATE_TEXT] [nvarchar](25) NULL,
	[REQ_ZIP_TEXT] [nvarchar](15) NULL,
	[REQ_PHONE_TEXT] [nvarchar](15) NULL,
	[ORDERED_BY_TEXT] [nvarchar](50) NULL,
	[ORDER_ADDR_TEXT] [nvarchar](50) NULL,
	[ORDER_CITY_TEXT] [nvarchar](25) NULL,
	[ORDER_STATE_TEXT] [nvarchar](15) NULL,
	[ORDER_ZIP_TEXT] [nvarchar](15) NULL,
	[ORDER_PHONE_TEXT] [nvarchar](25) NULL,
	[AUTH_BY_TEXT] [nvarchar](50) NULL,
	[AUTH_ADDR_TEXT] [nvarchar](50) NULL,
	[AUTH_CITY_TEXT] [nvarchar](25) NULL,
	[AUTH_STATE_TEXT] [nvarchar](15) NULL,
	[AUTH_ZIP_TEXT] [nvarchar](15) NULL,
	[AUTH_PHONE_TEXT] [nvarchar](15) NULL,
	[DATE_EXEC_DATE] [nvarchar](8) NULL,
	[PAID_DATE_DATE] [nvarchar](8) NULL,
	[BOND_STATUS_CODE] [int] NULL,
	[DATE_CANC_DATE] [nvarchar](8) NULL,
	[BOND_DETAIL_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CERTIFICATE](
	[OPTIONSET_ID] [int] NULL,
        [CERTIFICATE_ID] [int] NULL,
	[JOB_NO_TEXT] [nvarchar](15) NULL,
	[JOB_DESC_TXCD] [ntext] NULL,
	[AGENCY_NAME_TEXT] [nvarchar](50) NULL,
	[AGENCY_PHON_TEXT] [nvarchar](20) NULL,
	[INSURED_NAM_TEXT] [nvarchar](50) NULL,
	[INSURED_ADD_TEXT] [nvarchar](50) NULL,
	[INSURED_CIT_TEXT] [nvarchar](25) NULL,
	[INSURED_ST_TEXT] [nvarchar](15) NULL,
	[INSURED_ZIP_TEXT] [nvarchar](15) NULL,
	[INSURED_PH_TEXT] [nvarchar](20) NULL,
	[GEN_LIAB_TXCD] [ntext] NULL,
	[INS_NAME_TEXT] [nvarchar](50) NULL,
	[POL_NUMBER_NUM] [float] NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[BI_EA_AGG_TEXT] [nvarchar](25) NULL,
	[PD_EA_AGG_TEXT] [nvarchar](25) NULL,
	[BI_PD_COMB_NUM] [float] NULL,
	[PI_AGG_NUM] [float] NULL,
	[AUTO_LIAB_TEXT] [nvarchar](25) NULL,
	[BI_EA_PERS_NUM] [float] NULL,
	[BI_EA_ACC_NUM] [float] NULL,
	[PD_EA_OCC_NUM] [float] NULL,
	[BI_PD_COMB_TEXT] [nvarchar](15) NULL,
	[EXCESS_LIAB_TXCD] [ntext] NULL,
	[BI_PD_AGG_TEXT] [nvarchar](15) NULL,
	[WORK_COMP_NUM] [float] NULL,
	[WORK_COMP_TEXT] [nvarchar](25) NULL,
	[WC_EA_ACC_NUM] [float] NULL,
	[OPER_DESC_TXCD] [ntext] NULL,
	[ISSUE_DT_DATE] [nvarchar](8) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPL_MGT](
	[OPTIONSET_ID] [int] NULL,
        [COMPL_MGT_ID] [int] NULL,
	[COMP_NO_TEXT] [nvarchar](25) NULL,
	[DT_RECV_DATE] [nvarchar](8) NULL,
	[COMP_TYPE_CODE] [int] NULL,
	[COMP_SRC_CODE] [int] NULL,
	[ACT_REQ_TXCD] [ntext] NULL,
	[FILED_AGNST_TEXT] [nvarchar](50) NULL,
	[REF_TO_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CONTRCT_MGT](
	[OPTIONSET_ID] [int] NULL,
        [CONTRCT_MGT_ID] [int] NULL,
	[CONT_TYPE_CODE] [int] NULL,
	[CONTR_CAT_TXCD] [ntext] NULL,
	[SUBJECTOR_TEXT] [nvarchar](50) NULL,
	[SUBJECTEE_TEXT] [nvarchar](50) NULL,
	[DETAILS_TXCD] [ntext] NULL,
	[EFF_DATE_DATE] [nvarchar](8) NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[RENEW_DATE_DATE] [nvarchar](8) NULL,
	[INDEMNITY_TXCD] [ntext] NULL,
	[SUBROGATION_TXCD] [ntext] NULL,
	[TERM_INFO_TEXT] [nvarchar](50) NULL,
	[CONDITIONS_TXCD] [ntext] NULL,
	[AUTH_SIGN_TXCD] [ntext] NULL,
	[PAYMENTS_TXCD] [ntext] NULL,
	[WARRANTY_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CVG_TYPE_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CVG_TYPE_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [POLICY_ID] [int] NULL,
	[COVERAGE_TYPE_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DIRECTORY](
	[OPTIONSET_ID] [int] NULL,
        [DIRECTORY_ID] [int] NULL,
	[LAST_NAME_TEXT] [nvarchar](50) NULL,
	[FIRST_NAME_TEXT] [nvarchar](50) NULL,
	[ADDRESS_TEXT] [nvarchar](50) NULL,
	[CITY_TEXT] [nvarchar](50) NULL,
	[STATE_TEXT] [nvarchar](15) NULL,
	[ZIP_CODE_TEXT] [nvarchar](15) NULL,
	[HOME_PHONE_TEXT] [nvarchar](25) NULL,
	[WORK_PHONE_TEXT] [nvarchar](25) NULL,
	[FAX_TEXT] [nvarchar](25) NULL,
	[TITLE_TEXT] [nvarchar](25) NULL,
	[ORGANIZ_TEXT] [nvarchar](50) NULL,
	[CONTACT_TYP_CODE] [int] NULL,
	[CONTACT_STA_CODE] [int] NULL,
	[RECALL_DT_DATE] [nvarchar](8) NULL,
	[NOTES_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_X_VIOLATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMP_X_VIOLATION](
	[OPTIONSET_ID] [int] NULL,
        [EMPLOYEE_EID] [int] NULL,
	[VIOLATION_CODE] [nvarchar](25) NULL,
	[VIOLATION_DATE] [nvarchar](8) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMP_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [EMPLOYEE_EID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_X_DEPENDENT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMP_X_DEPENDENT](
	[OPTIONSET_ID] [int] NULL,
        [EMPLOYEE_EID] [int] NULL,
	[DEPENDENT_EID] [int] NULL,
	[HEALTH_PLAN_FLAG] [nvarchar](1) NULL,
	[RELATION_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMPLOYEE](
	[OPTIONSET_ID] [int] NULL,
	[COUNTY_OF_RESIDNC] [nvarchar] (50) NULL,
	[DRIVLIC_STATE] [nvarchar](25) NULL,
	[INSURABLE_FLAG] [nvarchar](1) NULL,
	[LAST_VERIFIED_DATE] [nvarchar](8) NULL,
	[NUM_OF_VIOLATIONS] [int] NULL,
	[TERM_DATE] [nvarchar](8) NULL,
	[WORK_PERMIT_DATE] [nvarchar](8) NULL,
	[WORK_PERMIT_NUMBER] [nvarchar](50) NULL,
        [EMPLOYEE_EID] [int] NULL,
	[ACTIVE_FLAG] [nvarchar](1) NULL,
	[EMPLOYEE_NUMBER] [nvarchar](20) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[DATE_HIRED] [nvarchar](8) NULL,
	[POSITION_CODE] [nvarchar](25) NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[SUPERVISOR_EID] [int] NULL,
	[EXEMPT_STATUS_FLAG] [nvarchar](1) NULL,
	[NO_OF_EXEMPTIONS] [int] NULL,	
	[FULL_TIME_FLAG] [nvarchar](1) NULL,
	[HOURLY_RATE] [float] NULL,
	[WEEKLY_HOURS] [int] NULL,
	[WEEKLY_RATE] [float] NULL,
	[WORK_SUN_FLAG] [nvarchar](1) NULL,
	[WORK_MON_FLAG] [nvarchar](1) NULL,
	[WORK_TUE_FLAG] [nvarchar](1) NULL,
	[WORK_WED_FLAG] [nvarchar](1) NULL,
	[WORK_THU_FLAG] [nvarchar](1) NULL,
	[WORK_FRI_FLAG] [nvarchar](1) NULL,
	[WORK_SAT_FLAG] [nvarchar](1) NULL,
	[PAY_TYPE_CODE] [nvarchar](25) NULL,
	[PAY_AMOUNT] [float] NULL,
	[DRIVERS_LIC_NO] [nvarchar](20) NULL,
	[DRIVERSLICTYPECODE] [nvarchar](25) NULL,
	[DATE_DRIVERSLICEXP] [nvarchar](8) NULL,
	[DRIVLIC_RSTRCTCODE] [nvarchar](25) NULL,
	[NCCI_CLASS_CODE] [nvarchar](25) NULL,
	[DATE_OF_DEATH] [nvarchar](8) NULL,
	[SEC_DEPT_EID] [nvarchar](25) NULL,
	[JOB_CLASS_CODE] [nvarchar](25) NULL,
	[MONTHLY_RATE] [float] NULL,
	[ELIG_DIS_BEN_FLAG] [nvarchar](1) NULL,
	[EMP_ENTITY_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENTITY](
	[OPTIONSET_ID] [int] NULL,
	[BUSINESS_TYPE_CODE] [nvarchar](25) NULL,
	[COUNTY] [nvarchar](30) NULL, 
	[NATURE_OF_BUSINESS] [nvarchar](50) NULL,       
	[SIC_CODE] [nvarchar](25) NULL,
	[WC_FILING_NUMBER] [nvarchar](30) NULL,
	[ENTITY_ID] [int] NULL,
	[ENTITY_TABLE_ID] [nvarchar](18) NULL,
	[LAST_NAME] [nvarchar](100) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[ALSO_KNOWN_AS] [nvarchar](50) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[COST_CENTER_CODE] [nvarchar](25) NULL,
	[ADDRESS_TYPE_CODE] [nvarchar](25) NULL,            -- kkaur25 14.2 enh
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[PARENT_EID] [int] NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[CONTACT] [nvarchar](50) NULL,
	[COMMENTS] [nvarchar](4000) NULL,
	[EMAIL_TYPE_CODE] [nvarchar](25) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[SEX_CODE] [nvarchar](25) NULL,
	[BIRTH_DATE] [nvarchar](8) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](30) NULL,
	[CONTACT_TYPE_CODE] [nvarchar](25) NULL,		-- start kkaur25 14.2 enh
	[CONTACT_NAME] [nvarchar](50) NULL,
	[CONTACT_TITLE] [nvarchar](50) NULL,
	[CONTACT_INITIALS] [nvarchar](10) NULL,
	[CONTACT_ADDR1] [nvarchar](50) NULL,
	[CONTACT_ADDR2] [nvarchar](50) NULL,
	[CONTACT_CITY] [nvarchar](50) NULL,
	[CONTACT_STATE_ID] [nvarchar](25) NULL,
	[CONTACT_ZIP_CODE] [nvarchar](10) NULL,
	[CONTACT_PHONE] [nvarchar](30) NULL,
	[CONTACT_FAX_NUMBER] [nvarchar](30) NULL,
	[CONTACT_EMAIL_ADDRESS] [nvarchar](25) NULL,		-- end kkaur25 14.2 enh
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[DELETED_FLAG] [nvarchar](1) NULL,
	[SEC_DEPT_EID] [nvarchar](25) NULL,
	[TRIGGER_DATE_FIELD] [nvarchar](50) NULL,
	[EFF_START_DATE] [nvarchar](8) NULL,
	[EFF_END_DATE] [nvarchar](8) NULL,
	[PARENT_1099_EID] [int] NULL,
	[REPORT_1099_FLAG] [nvarchar](1) NULL,
	[MIDDLE_NAME] [nvarchar](50) NULL,
	[TITLE] [nvarchar](50) NULL,
	[NAICS_CODE] [nvarchar](25) NULL,
	[RM_USER_ID] [int] NULL,
	[FREEZE_PAYMENTS] [nvarchar](1) NULL,
	[ORGANIZATION_TYPE] [nvarchar](25) NULL,
	[NPI_NUMBER] [nvarchar](10) NULL,
	[HTMLCOMMENTS] [nvarchar](4000) NULL,
	[AUTO_DISCOUNT] [float] NULL,
	[DISCOUNT_FLAG] [nvarchar](1) NULL,
	[FROI_ACORD_PASSWORD] [nvarchar](15) NULL,
	[TIME_ZONE_TRACKING] [nvarchar](1) NULL,
	[TIME_ZONE_CODE] [nvarchar](25) NULL,
	[CONF_FLAG] [nvarchar](1) NULL,
    	[CONF_EVENT_ID] [int] NULL,
    	[ENTITY_APPROVAL_STATUS] [nvarchar](25) NULL,
	[ENTITY_REJECT_COMMENTS] [nvarchar](4000) NULL,
	[ENTITY_REJECT_HTMLCOMMENTS] [nvarchar](4000) NULL,
	[OVERRIDE_OFAC_CHECK] [nvarchar](1) NULL,
	[ORG_CURR_CODE] [nvarchar](25) NULL,
	[HOSPITAL_AMT] [float] NULL,
	[HOSPITAL_LINES] [nvarchar](25) NULL,
	[MEDICAL_AMT] [float] NULL,
	[MEDICAL_LINES] [nvarchar](25) NULL,
	[REFERENCE_NUMBER] [nvarchar](50) NULL,
	[CLIENT_SEQ_NUM] [nvarchar](30) NULL, 
	[ADDRESS_SEQ_NUM] [int] NULL,
	[PREFIX] [nvarchar](25) NULL,
	[SUFFIX_COMMON] [nvarchar](25) NULL,
	[SUFFIX_LEGAL] [nvarchar](50) NULL,
	[ID_TYPE] [nvarchar](25) NULL,
	[LEGAL_NAME] [nvarchar](50) NULL,
	[EFFECTIVE_DATE] [nvarchar](10) NULL,
	[EXPIRATION_DATE] [nvarchar](10) NULL,
	[NAME_TYPE] [nvarchar](25) NULL,
	[ASSIGNADJ_EID] [nvarchar](25) NULL,
	[PARENT_ABBREV] [nvarchar](25) NULL,
	[ENTITY_ID_TYPE][nvarchar](25) NULL,			-- start kkaur25 14.2 enh
	[ENTITY_ID_NUMBER] [nvarchar](50) NULL,
	[ENT_EFFECTIVE_DATE] [nvarchar](8) NULL,
	[ENT_EXPIRATION_DATE] [nvarchar](8) NULL		-- end kkaur25 14.2 enh

) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENT_EXPOSURE_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENT_EXPOSURE_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [EXPOSURE_ROW_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS](
	[OPTIONSET_ID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[AUTO_CHECK_DETAIL] [nvarchar](30) NULL,
	[ROLLUP_ID] [int] NULL,
	[VOID_DATE] [nvarchar](8) NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[AUTO_CHECK_FLAG] [nvarchar](2) NULL,
	[CITY] [nvarchar](50) NULL,
	[CLAIMANT_LAST] [nvarchar](50) NULL,
	[CLAIMANT_FIRST] [nvarchar](50) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[PRECHECK_FLAG] [int] NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[UNIT_ID] [int] NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[CLAIM_ID] [nvarchar](25) NULL,
	[CTL_NUMBER] [nvarchar](25) NULL,
	[VOID_FLAG] [int] NULL,
	[DATE_OF_CHECK] [nvarchar](8) NULL,
	[CHECK_MEMO] [nvarchar](255) NULL,
	[TRANS_NUMBER] [int] NULL,
	[TRANS_DATE] [nvarchar](8) NULL,
	[PAYEE_EID] [int] NULL,
	[PAYEE_TYPE_CODE] [nvarchar](25) NULL,
	[ACCOUNT_ID] [nvarchar](20) NULL,
	[AMOUNT] [float] NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[FILED_1099_FLAG] [int] NULL,
	[CLEARED_FLAG] [int] NULL,
	[TRANS_TYPE] [nvarchar](25) NULL,
	[UPDATE_RESERVES] [nvarchar](1) NULL,
	[COMMENTS] [nvarchar](16) NULL,
	[NOTES] [nvarchar](16) NULL,
	[CRC] [int] NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[BATCH_NUMBER] [int] NULL,
	[ENCLOSURE_FLAG] [int] NULL,
	[SUB_ACCOUNT_ID] [nvarchar](20) NULL,
	[SETTLEMENT_FLAG] [int] NULL,
	[WEEKS_PAID_CODE] [int] NULL,
	[NUM_OF_PAID_DAYS] [int] NULL,
	[RESUBMIT_EDI] [int] NULL,
	[SUPP_PAYMENT_FLAG] [int] NULL,
	[HTMLCOMMENTS] [nvarchar](16) NULL,
	[MIDDLE_NAME] [nvarchar](50) NULL,
	[REASON] [nvarchar](255) NULL,
	[VOID_REASON] [nvarchar](255) NULL,
	[DORMANCY_STATUS] [varchar](25) NULL,
	[WITHHOLDING_PMT_FLAG] [int] NULL,
	[WITHHOLDING_TYPE] [int] NULL,
	[WITHHOLDING_CHILD_FLAG] [int] NULL,
	[PARENT_TRANS_ID] [int] NULL,
	[COMBINED_PAY_FLAG] [int] NULL,
	[PMT_CURRENCY_CODE] [nvarchar](25) NULL,
	[PMT_CURRENCY_AMOUNT] [float] NULL,
	[PMT_TO_BASE_CUR_RATE] [float] NULL,
	[CLAIM_CURRENCY_CODE][nvarchar](25) NULL,
	[CLAIM_CURRENCY_AMOUNT] [float] NULL,
	[PMT_TO_CLAIM_CUR_RATE] [float] NULL,
	[BASE_TO_PMT_CUR_RATE] [float] NULL,
	[BASE_TO_CLAIM_CUR_RATE] [float] NULL,
	[BILL_TYPE] [nvarchar](8) NULL,
  [REISSUE_REASON_CODE] [nvarchar](25) NULL,
	[MANUAL_CHECK] [int] NULL,
	[OFFSET_FLAG] [int] NULL,
	[STOP_PAY_FLAG] [smallint] NULL,
	[STOP_PAY_DATE] [nvarchar](8) NULL,
	[APPROVE_USER] [nvarchar](255) NULL,
	[CONF_EVENT_ID][nvarchar](255) Null,
	[CONF_FLAG][nvarchar](255) Null,
	[EDI_BATCH_NUMBER] [nvarchar](255) Null,
	[EFT_DATE] [nvarchar](8) NULL,
	[EFT_FILE_NAME][nvarchar](255) Null,
	[DTTM_APPROVAL][nvarchar](8) NULL,
	[EDI_MED_EXTRACTED][nvarchar](255) Null,
	[EFT_FLAG] [smallint] NULL,
    [FINAL_PAYMENT_FLAG] [int] NULL,
    [REISSUE_BY] [nvarchar](255) Null,
    [REISSUE_DATE] [nvarchar](8) NULL,
	[REISSUE_FLAG][int] NULL,
	[REISSUE_PARENT_ID][nvarchar](255) Null,
	[RES_SUPP_PAYMENT_FLAG] [int] NULL,
	[SEC_DEPT_EID] [nvarchar](255) Null,
	[TAX_PAYMENT_FLAG] [int] NULL,
	[VOID_REASON_HTMLCOMMENTS][int] NULL,
	[IAIABC_ADJUST_DATE] [nvarchar](8) NULL,
	[IAIABC_CREDIT_DATE] [nvarchar](8) NULL,
	[IAIABC_REDIST_DATE] [nvarchar](8) NULL,
	[PS_EXTRACTED] [int] NULL,
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_EXPOSURE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENTITY_EXPOSURE](
	[OPTIONSET_ID] [int] NULL,
        [EXPOSURE_ROW_ID] [int] NULL,
	[ORG_TABLE_ID] [int] NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[START_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL,
	[NO_OF_EMPLOYEES] [int] NULL,
	[NO_OF_WORK_HOURS] [int] NULL,
	[PAYROLL_AMOUNT] [float] NULL,
	[ASSET_VALUE] [float] NULL,
	[SQUARE_FOOTAGE] [int] NULL,
	[VEHICLE_COUNT] [int] NULL,
	[TOTAL_REVENUE] [float] NULL,
	[OTHER_BASE] [float] NULL,
	[RISK_MGMT_OVERHEAD] [float] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_DEPOSIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_DEPOSIT](
	[OPTIONSET_ID] [int] NULL,
        [DEPOSIT_ID] [int] NULL,
	[CTL_NUMBER] [nvarchar](25) NULL,
	[BANK_ACC_ID] [nvarchar](20) NULL,
	[SUB_ACC_ID] [nvarchar](20) NULL,
	[TRANS_DATE] [nvarchar](8) NULL,
	[AMOUNT] [float] NULL,
	[CLEARED_FLAG] [nvarchar](1) NULL,
	[VOID_FLAG] [nvarchar](1) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL, -- Added for DA DIS Enhancement
	[DTTM_RCD_ADDED] [nvarchar](14) NULL, -- Added for DA DIS Enhancement
	[UPDATED_BY_USER] [nvarchar](50) NULL, -- Added for DA DIS Enhancement
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL, -- Added for DA DIS Enhancement
	[DESCRIPTION] [nvarchar](max) NULL, -- field size changed as it is a descriptive column from 40 to 4000
	[VOIDCLEAR_DATE] [nvarchar](8) NULL,
	[DEPOSIT_TYPE] [nvarchar](1) NULL,
	[ADJUST_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENTITY_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [ENTITY_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_TRANS_SPLIT_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_TRANS_SPLIT_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [SPLIT_ROW_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HAZ_MAT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HAZ_MAT](
	[OPTIONSET_ID] [int] NULL,
        [HAZ_MAT_ID] [int] NULL,
	[PROD_NAME_TEXT] [nvarchar](75) NULL,
	[OTH_NAMES_TXCD] [ntext] NULL,
	[NOTES_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [TRANS_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MED_STAFF]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MED_STAFF](
	[OPTIONSET_ID] [int] NULL,
    [MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[ALSO_KNOWN_AS] [nvarchar](50) NULL,
	[ADDRESS_TYPE_CODE] [nvarchar](25) NULL,		-- start kkaur25 14.2 enh
	[ADDRESS_SEQ_NUM] [int]	NULL,	
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](20) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[SEX_CODE] [nvarchar](25) NULL,
	[CONTACT_TYPE_CODE] [nvarchar](25) NULL,		-- start kkaur25 14.2 enh
	[CONTACT_NAME] [nvarchar](50) NULL,
	[CONTACT_TITLE] [nvarchar](50) NULL,
	[CONTACT_INITIALS] [nvarchar](10) NULL,
	[CONTACT_ADDR1] [nvarchar](50) NULL,
	[CONTACT_ADDR2] [nvarchar](50) NULL,
	[CONTACT_CITY] [nvarchar](50) NULL,
	[CONTACT_STATE_ID] [nvarchar](25) NULL,
	[CONTACT_ZIP_CODE] [nvarchar](10) NULL,
	[CONTACT_PHONE] [nvarchar](30) NULL,
	[CONTACT_FAX_NUMBER] [nvarchar](30) NULL,
	[CONTACT_EMAIL_ADDRESS] [nvarchar](25) NULL,		-- end kkaur25 14.2 enh
	[BIRTH_DATE] [nvarchar](8) NULL,	
	[PRIMARY_POLICY_NUMBER] [nvarchar](50) NULL,
	[HOME_ADDR1] [nvarchar](50) NULL,
	[HOME_ADDR2] [nvarchar](50) NULL,
	[HOME_CITY] [nvarchar](50) NULL,
	[HOME_STATE_ID] [nvarchar](25) NULL,
	[HOME_ZIP_CODE] [nvarchar](10) NULL,	
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[BEEPER_NUMBER] [nvarchar](30) NULL,
	[CELLULAR_NUMBER] [nvarchar](30) NULL,
	[EMERGENCY_CONTACT] [nvarchar](30) NULL,
	[STAFF_STATUS_CODE] [nvarchar](25) NULL,
	[STAFF_POS_CODE] [nvarchar](25) NULL,
	[STAFF_CAT_CODE] [nvarchar](25) NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[HIRE_DATE] [nvarchar](8) NULL,
	[LIC_NUM] [nvarchar](20) NULL,
	[LIC_STATE] [nvarchar](25) NULL,
	[LIC_ISSUE_DATE] [nvarchar](8) NULL,
	[LIC_EXPIRY_DATE] [nvarchar](8) NULL,
	[LIC_DEA_NUM] [nvarchar](20) NULL,
	[LIC_DEA_EXP_DATE] [nvarchar](8) NULL,
	[ENTITY_ID_TYPE][nvarchar](25) NULL,				-- start kkaur25 14.2 enh
	[ENTITY_ID_NUMBER] [nvarchar](50) NULL,
	[ENT_EFFECTIVE_DATE] [nvarchar](8) NULL,
	[ENT_EXPIRATION_DATE] [nvarchar](8) NULL			-- end kkaur25 14.2 enh
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_TRANS_SPLIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_TRANS_SPLIT](
	[OPTIONSET_ID] [int] NULL,
	[SPLIT_ROW_ID] [int] NULL,
	[SUM_AMOUNT] [float] NULL,
	[TRANS_ID] [int] NULL,
	[TRANS_TYPE_CODE] [nvarchar](25) NULL,
	[RESERVE_TYPE_CODE] [nvarchar](25) NULL,
	[AMOUNT] [float] NULL,
	[GL_ACCOUNT_CODE] [nvarchar](6) NULL,
	[FROM_DATE] [nvarchar](8) NULL,
	[TO_DATE] [nvarchar](8) NULL,
	[INVOICED_BY] [nvarchar](20) NULL,
	[INVOICE_AMOUNT] [float] NULL,
	[INVOICE_NUMBER] [nvarchar](25) NULL,
	[PO_NUMBER] [nvarchar](14) NULL,
	[CRC] [int] NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[INVOICE_DATE] [nvarchar](8) NULL,
	[BILL_RCVD_BY_CARRIER_DATE] [nvarchar](8) NULL,
	[SUPP_PAYMENT_FLAG] [int] NULL,
	[AUTO_DISCOUNT] [nvarchar](10) NULL,
	[IS_FIRST_FINAL] [int] NULL,
	[WITHHOLDING_SPLIT_FLAG] [int] NULL,
	[CONTROL_REQ_FLAG] [int] NULL,
	[FUNDS_CR_STATUS] [Varchar](25) NULL,
	[PMT_CURRENCY_AMOUNT] [float] NULL,
	[PMT_CURRENCY_INVOICE_AMOUNT] [float] NULL,
	[PMT_CURRENCY_AUTO_DISCOUNT] [float] NULL,
	[CLAIM_CURRENCY_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_INVOICE_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_AUTO_DISCOUNT] [float] NULL,
	[UPDATE_POL_SYS] [int] NULL,
	[UNIT_TYPE] [nvarchar](5) NULL,
	[POLICY_NAME] [nvarchar](20) NULL,
	[UNIT_NUMBER] [nvarchar](10) NULL,
	[COVERAGE_CODE] [nvarchar](25) NULL,
	[LOSS_DISABILITY_CODE] [nvarchar](25) NULL,
	[DISABILITY_TYPE_CATEGORY] [nvarchar](25) NULL,
	[MODULE_NO] [nvarchar](10) NULL,
	[CLASS_CODE] [nvarchar](50) NULL,
	[CVG_SEQUENCE_NO] [nvarchar](8) NULL,
	[TRANS_SEQ_NO] [nvarchar](8) NULL,
	[CVG_DESC] [nvarchar](50) NULL,
	[SUBLINE_DESC] [nvarchar](50) NULL,
	[CLASS_DESC] [nvarchar](50) NULL,
	[STAT_UNIT_NUMBER] [nvarchar](10) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MED_STAFF_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MED_STAFF_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [MED_STAFF_NUMBER] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[MEDICAL_RCD_NO] [nvarchar](20) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[ALSO_KNOWN_AS] [nvarchar](50) NULL,
	[ADDRESS_TYPE_CODE] [nvarchar](25) NULL,		-- start kkaur25 14.2 enh
	[ADDRESS_SEQ_NUM] [int]	NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](20) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[SEX_CODE] [nvarchar](25) NULL,
	[CONTACT_TYPE_CODE] [nvarchar](25) NULL,		-- start kkaur25 14.2 enh
	[CONTACT_NAME] [nvarchar](50) NULL,
	[CONTACT_TITLE] [nvarchar](50) NULL,
	[CONTACT_INITIALS] [nvarchar](10) NULL,
	[CONTACT_ADDR1] [nvarchar](50) NULL,
	[CONTACT_ADDR2] [nvarchar](50) NULL,
	[CONTACT_CITY] [nvarchar](50) NULL,
	[CONTACT_STATE_ID] [nvarchar](25) NULL,
	[CONTACT_ZIP_CODE] [nvarchar](10) NULL,
	[CONTACT_PHONE] [nvarchar](30) NULL,
	[CONTACT_FAX_NUMBER] [nvarchar](30) NULL,
	[CONTACT_EMAIL_ADDRESS] [nvarchar](25) NULL,		-- end kkaur25 14.2 enh
	[BIRTH_DATE] [nvarchar](8) NULL,	
	[DATE_OF_ADMISSION] [nvarchar](8) NULL,
	[TIME_OF_ADMISSION] [nvarchar](6) NULL,
	[DATE_OF_DISCHARGE] [nvarchar](8) NULL,
	[TIME_OF_DISCHARGE] [nvarchar](6) NULL,
	[ADMISSION_REASON] [nvarchar](4000) NULL,
	[ADM_TYPE_CODE] [nvarchar](25) NULL,
	[ADM_SOURCE_CODE] [nvarchar](25) NULL,
	[ACUITY_LEVEL_CODE] [nvarchar](25) NULL,
	[CARDIAC_ARREST] [nvarchar](1) NULL,
	[PATIENT_STAT_CODE] [nvarchar](25) NULL,
	[PATIENT_COND_CODE] [nvarchar](25) NULL,
	[DISCHARGE_DSP_CODE] [nvarchar](25) NULL,
	[EXP_LENGTH_OF_STAY] [int] NULL,
	[EXPECTED_COST] [float] NULL,
	[INS_PLAN_GROUP_NO] [nvarchar](16) NULL,
	[QI_SIGNIF_CODE] [nvarchar](25) NULL,
	[EPISODE_OF_CARE_ID] [nvarchar](8) NULL,
	[PATIENT_TYPE_CODE] [nvarchar](25) NULL,
	[HEIGHT] [float] NULL,
	[WEIGHT] [float] NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[RACE_ENTH_CODE] [nvarchar](25) NULL,
	[DATE_OF_DEATH] [nvarchar](8) NULL,
	[PRIMARY_PAY_CODE] [nvarchar](25) NULL,
	[SECOND_PAY_CODE] [nvarchar](25) NULL,	
	[EMERGENCY_CONTACT] [nvarchar](20) NULL,
	[EMERGENCY_CONT_NO] [nvarchar](20) NULL,
	[PATIENT_ROOM_NO] [nvarchar](14) NULL,
	[FACILITY_UNIT_CODE] [nvarchar](25) NULL,
	[FACILITY_DEPT_EID] [nvarchar](25) NULL,
	[HCO_ID_NO] [nvarchar](20) NULL,
	[HCO_SITE_ID_NO] [nvarchar](20) NULL,
	[PRI_PHYS_LAST_NAME] [nvarchar](50) NULL,
	[PRI_PHYS_FIRST_NAME] [nvarchar](50) NULL,
	[PRI_PHYS_TAX_ID] [nvarchar](20) NULL,
	[PRI_PHYS_NUMBER] [nvarchar](50) NULL,
	[ADM_PHYS_LAST_NAME] [nvarchar](50) NULL,
	[ADM_PHYS_FIRST_NAME] [nvarchar](50) NULL,
	[ADM_PHYS_TAX_ID] [nvarchar](20) NULL,	
	[ADM_PHYS_NUMBER] [nvarchar](50) NULL,
	[NB_APGAR_SCORE] [int] NULL,
	[NB_BIRTH_WEIGHT] [float] NULL,
	[NB_LEN_OF_GEST] [int] NULL,
	[NB_NICU_STAY] [nvarchar](1) NULL,
	[NB_NICU_ADM_DATE] [nvarchar](8) NULL,
	[NB_NICU_DISCH_DATE] [nvarchar](8) NULL,
	[NB_CEPHALIC_MOLD] [nvarchar](1) NULL,
	[NB_EPS_OF_CARE_ID] [nvarchar](8) NULL,
	[NBM_PARITY] [int] NULL,
	[NBM_PRIOR_C_SECT] [nvarchar](1) NULL,
	[NBM_MED_IND_LABOR] [nvarchar](1) NULL,
	[NBM_LIVE_BIRTHS] [int] NULL,
	[NBM_STILL_BIRTHS] [int] NULL,
	[NBM_GRAVIDA] [int] NULL,	
	[NBM_EPS_OF_CARE_ID] [nvarchar](8) NULL,	
	[DISABILITY_CODE] [nvarchar](25) NULL,
	[ILLNESS_CODE] [nvarchar](25) NULL,
	[LOST_CONSC_FLAG] [nvarchar](1) NULL,
	[WHY_AT_FACILITY] [nvarchar](225) NULL,
	[ENTITY_ID_TYPE][nvarchar](25) NULL,				-- start kkaur25 14.2 enh
	[ENTITY_ID_NUMBER] [nvarchar](50) NULL,
	[ENT_EFFECTIVE_DATE] [nvarchar](8) NULL,
	[ENT_EXPIRATION_DATE] [nvarchar](8) NULL			-- end kkaur25 14.2 enh
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DIAGNOSIS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_DIAGNOSIS](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[DIAGNOSIS_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ATTN_PHYS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_ATTN_PHYS](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[PHYS_LAST_NAME] [nvarchar](50) NULL,
	[PHYS_FIRST_NAME] [nvarchar](50) NULL,
	[PHYS_TAX_ID] [nvarchar](20) NULL,
	[PHYS_NUMBER] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ACT_TAKEN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_ACT_TAKEN](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[ACTION_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_SUPP](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_PROC_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_PROC_SUPP](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[PROCEDURE_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_PROCEDURE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_PROCEDURE](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[PROCEDURE_CODE] [nvarchar](25) NULL,
	[PROC_TYPE_CODE] [nvarchar](25) NULL,
	[DATE_OF_PROCEDURE] [nvarchar](8) NULL,
	[SURGEON_LAST_NAME] [nvarchar](50) NULL,
	[SURGEON_FIRST_NAME] [nvarchar](50) NULL,
	[SURGEON_TAX_ID] [nvarchar](20) NULL,	
	[SURGEON_PHYS_NUMBER] [nvarchar](50) NULL,
	[ANESTH_ADMIN_FLAG] [nvarchar](1) NULL,
	[ANESTH_TYPE_CODE] [nvarchar](25) NULL,
	[ANESTH_LAST_NAME] [nvarchar](50) NULL,
	[ANESTH_FIRST_NAME] [nvarchar](50) NULL,
	[ANESTH_TAX_ID] [nvarchar](20) NULL,
	[ASA_PS_CLASS_CODE] [nvarchar](25) NULL,
	[COMPLICATION_DATE] [nvarchar](8) NULL,
	[PRIOR_TO_ANES_FLAG] [nvarchar](1) NULL,
	[ICC_LEVEL_CODE] [nvarchar](25) NULL,
	[LEN_OF_TIME] [float] NULL,
	[COMPLICATIONS] [nvarchar](4000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DRG_CODES]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PATIENT_DRG_CODES](
	[OPTIONSET_ID] [int] NULL,
    [PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[DRG_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_PRIVS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_PRIVS](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[CATEGORY_CODE] [nvarchar](25) NULL,
	[TYPE_CODE] [nvarchar](25) NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[INT_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_CERTS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_CERTS](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[NAME_CODE] [nvarchar](25) NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[BOARD_CODE] [nvarchar](25) NULL,
	[INT_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_EDUCATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_EDUCATION](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[EDUC_TYPE_CODE] [nvarchar](25) NULL,
	[INSTITUTION_NAME] [nvarchar](50) NULL,
	[DEGREE_TYPE] [nvarchar](25) NULL,
	[DEGREE_DATE] [nvarchar](8) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_PREV_HOSP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_PREV_HOSP](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[HOSPITAL_NAME] [nvarchar](50) NULL,
	[PRIV_CODE] [nvarchar](25) NULL,
	[INT_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLICY](
	[OPTIONSET_ID] [int] NULL,        
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[POLICY_ID] [int] NULL,
	[POLICY_NAME] [nvarchar](20) NULL,
	[POLICY_NUMBER] [nvarchar](20) NULL,
	[POLICY_STATUS_CODE] [nvarchar](25) NULL,
	[INSURER_EID] [nvarchar](25)NULL,
	[ISSUE_DATE] [nvarchar](8) NULL,
	[REVIEW_DATE] [nvarchar](8) NULL,
	[RENEWAL_DATE] [nvarchar](8) NULL,
	[EFFECTIVE_DATE] [nvarchar](8) NULL,
	[EXPIRATION_DATE] [nvarchar](8) NULL,
	[CANCEL_DATE] [nvarchar](8) NULL,
	[PREMIUM] [float] NULL,
	[TRIGGER_CLAIM_FLAG] [nvarchar](1) NULL,
	[PRIMARY_POLICY_FLG] [nvarchar](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[BROKER_EID] [nvarchar](25) NULL,
	[BANK_ACC_ID] [int] NULL,
	[SUB_ACC_ROW_ID] [int] NULL,
	[HTMLCOMMENTS] [nvarchar](50) NULL,
	[ALL_STATES_FLAG] [nvarchar](1) NULL,
	[POLICY_SYSTEM_NAME] [nvarchar](25) NULL,
	[POLICY_TYPE] [nvarchar](25) NULL,
	[POLICY_SYMBOL] [nvarchar](20) NULL,
	[EXTERNAL_POLICY_ID] [nvarchar](20) NULL,
	[CURRENCY_CODE] [nvarchar](25) NULL,
	[POLICY_LOB_CODE] [nvarchar](25) NULL,
	[MODULE_INFO] [nvarchar](10) NULL,
	[MASTER_COMPANY] [nvarchar](10) NULL,
	[LOCATION_COMPANY] [nvarchar](10) NULL,
	[BRANCH_CODE] [nvarchar](50) NULL,
	[CLAIM_NUMBER] [nvarchar](50) NULL
        /*[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](255) NULL,
	[EMAIL_TYPE_CODE] [nvarchar](255) NULL,
	[EMAIL_ADDRESS] [nvarchar](255) NULL,
	[PARENT_ABBREV] [nvarchar](255) NULL,
	[WC_FILING_NUMBER] [nvarchar](255) NULL,
	[SIC_CODE] [nvarchar](255) NULL,
	[CONTACT] [nvarchar](255) NULL,
	[PARENT_EID] [nvarchar](255) NULL,
	[DELETED_FLAG] NVARCHAR(255),
	[REPORT_1099_FLAG] NVARCHAR(255),
	[PARENT_1099_EID] INT,
	[NEW_POLICY_ID] INT */
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYS_SUB_SPECIALTY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYS_SUB_SPECIALTY](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[SPECIALTY_CODE] [nvarchar](25) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PHYSICIAN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PHYSICIAN](
	[OPTIONSET_ID] [int] NULL,
        [PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[INTERNAL_NUMBER] [nvarchar](20) NULL,
	[MEDICARE_NUMBER] [nvarchar](20) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[ALSO_KNOWN_AS] [nvarchar](20) NULL,
	[ADDRESS_TYPE_CODE] [nvarchar](25) NULL,			-- start kkaur25 14.2 enh
	[ADDRESS_SEQ_NUM] [int]	NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](20) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[SEX_CODE] [nvarchar](25) NULL,
	[CONTACT_TYPE_CODE] [nvarchar](25) NULL,			-- start kkaur25 14.2 enh
	[CONTACT_NAME] [nvarchar](50) NULL,
	[CONTACT_TITLE] [nvarchar](50) NULL,
	[CONTACT_INITIALS] [nvarchar](10) NULL,
	[CONTACT_ADDR1] [nvarchar](50) NULL,
	[CONTACT_ADDR2] [nvarchar](50) NULL,
	[CONTACT_CITY] [nvarchar](50) NULL,
	[CONTACT_STATE_ID] [nvarchar](25) NULL,
	[CONTACT_ZIP_CODE] [nvarchar](10) NULL,
	[CONTACT_PHONE] [nvarchar](30) NULL,
	[CONTACT_FAX_NUMBER] [nvarchar](30) NULL,
	[CONTACT_EMAIL_ADDRESS] [nvarchar](25) NULL,			-- end kkaur25 14.2 enh
	[BIRTH_DATE] [nvarchar](8) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[HOME_ADDR1] [nvarchar](50) NULL,
	[HOME_ADDR2] [nvarchar](50) NULL,
	[HOME_CITY] [nvarchar](50) NULL,
	[HOME_STATE_ID] [nvarchar](25) NULL,
	[HOME_ZIP_CODE] [nvarchar](10) NULL,
	[BEEPER_NUMBER] [nvarchar](30) NULL,
	[CELLULAR_NUMBER] [nvarchar](30) NULL,
	[MAILING_ADDR1] [nvarchar](50) NULL,
	[MAILING_ADDR2] [nvarchar](50) NULL,
	[MAILING_CITY] [nvarchar](50) NULL,
	[MAILING_STATE_ID] [nvarchar](25) NULL,
	[MAILING_ZIP_CODE] [nvarchar](10) NULL,
	[EMERGENCY_CONTACT] [nvarchar](30) NULL,
	[STAFF_STATUS_CODE] [nvarchar](25) NULL,
	[STAFF_TYPE_CODE] [nvarchar](25) NULL,
	[STAFF_CAT_CODE] [nvarchar](25) NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[PRIMARY_SPECIALTY] [nvarchar](25) NULL,
	[PRIMARY_POLICY_NUMBER] [nvarchar](50) NULL,
	[APPOINT_DATE] [nvarchar](8) NULL,
	[REAPPOINT_DATE] [nvarchar](8) NULL,
	[LIC_STATE] [nvarchar](25) NULL,
	[LIC_NUM] [nvarchar](20) NULL,
	[LIC_ISSUE_DATE] [nvarchar](8) NULL,
	[LIC_EXPIRY_DATE] [nvarchar](8) NULL,
	[LIC_DEA_NUM] [nvarchar](20) NULL,
	[LIC_DEA_EXP_DATE] [nvarchar](8) NULL,
	[MEMBERSHIP] [nvarchar](20) NULL,
	[CONT_EDUCATION] [nvarchar](20) NULL,
	[TEACHING_EXP] [nvarchar](20) NULL,
	[REPORT_1099_FLAG] [nvarchar](1) NULL,
	[PARENT_1099_PHYSICIAN_NUMBER] [nvarchar](50) NULL,
	[PARENT_1099_TABLE_NAME] [nvarchar](18) NULL,
	[PARENT_1099_LAST_NAME] [nvarchar](50) NULL,
	[PARENT_1099_TAX_ID] [nvarchar](20) NULL,
	[NPI_NUMBER] [nvarchar](10) NULL,
	[ENTITY_ID_TYPE][nvarchar](25) NULL,				-- start kkaur25 14.2 enh
	[ENTITY_ID_NUMBER] [nvarchar](50) NULL,
	[ENT_EFFECTIVE_DATE] [nvarchar](8) NULL,
	[ENT_EXPIRATION_DATE] [nvarchar](8) NULL			-- end kkaur25 14.2 enh
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_CVG_TYPE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLICY_X_CVG_TYPE](
	[OPTIONSET_ID] [int] NULL,
       	[CLAIM_LIMIT] [float] NULL,
	[NOTIFICATION_UID] [int] NULL,
	[POLCVG_ROW_ID] [int] NULL,
	[POLICY_ID] [int] NULL,
	[COVERAGE_TYPE_CODE] [nvarchar](25) NULL,
	[POLICY_LIMIT] [float] NULL,
	[OCCURRENCE_LIMIT] [float] NULL,
	[TOTAL_PAYMENTS] [float] NULL,
	[REMARKS] [nvarchar] (255) NULL,
	[EXCEPTIONS] [nvarchar] (255) NULL,
	[CANCEL_NOTICE_DAYS] [int] NULL,
	[SELF_INSURE_DEDUCT] [float] NULL,
	[NEXT_POLICY_ID] [int] NULL,
	[BROKER_NAME] [nvarchar](100) NULL,
	[SECTION_NUMBER_CODE] [nvarchar](25) NULL,
	[PER_PERSON_LIMIT] [float] NULL,
	[EFFECTIVE_DATE] [nvarchar](8) NULL,
	[EXPIRATION_DATE] [nvarchar](8) NULL,
	[LIMIT] [float] NULL,
	[ORIGINAL_PREMIUM] [float] NULL,
	[WRITTEN_PREMIUM] [float] NULL,
	[FULL_TERM_PREMIUM] [float] NULL,
	[TOTAL_WRITTEN_PREMIUM] [float] NULL,
	[EXPOSURE] [float] NULL,
	[CHANGE_DATE] [nvarchar](8) NULL,
	[CVG_SEQUENCE_NO] [nvarchar](8) NULL,
	[TRANS_SEQ_NO] [nvarchar](8) NULL,	
	[COVERAGE_CLASS_CODE] [nvarchar](20) NULL,
	[WC_DED_AMT] [float] NULL,
	[WC_DED_AGGR] [float] NULL,
	[PRODLINE] [nvarchar](50) NULL,
	[ASLINE] [nvarchar](50) NULL,
	[SUB_LINE] [nvarchar](3) NULL,
	[DED_TYPE_CODE] [nvarchar](25) NULL,
	[UNIT_ID] [int] NULL,
	[COVERAGE_CODE_DESCRIPTION] [nvarchar](100) NULL,
	[CLASS_CODE_DESCRIPTION] [nvarchar](100) NULL,
	[SUBLINE_DESCRIPTION] [nvarchar](100) NULL,
	[REINSURANCE_CODE] [nvarchar](25) NULL,
	[RETRO_DATE][varchar](8) NULL,
	[TAIL_DATE][varchar](8) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLICY_SUPP](
	[OPTIONSET_ID] [int] NULL,
        [POLICY_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PROJ_TRACK](
	[OPTIONSET_ID] [int] NULL,
        [PROJ_TRACK_ID] [int] NULL,
	[ACT_TYPE_CODE] [int] NULL,
	[ACTIV_DESC_TXCD] [ntext] NULL,
	[ASSIGN_BY_TEXT] [nvarchar](50) NULL,
	[ASSIGN_TO_TXCD] [ntext] NULL,
	[PRIORITY_CODE] [int] NULL,
	[EST_HOURS_NUM] [float] NULL,
	[ACT_HOURS_NUM] [float] NULL,
	[DUE_DATE_DATE] [nvarchar](8) NULL,
	[REVIEW_DATE_DATE] [nvarchar](8) NULL,
	[COMPLETE_DT_DATE] [nvarchar](8) NULL,
	[STATUS_CODE] [int] NULL,
	[MAT_USED_TXCD] [ntext] NULL,
	[MAT_COST_AMT] [float] NULL,
	[NOTES_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_INSURED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLICY_X_INSURED](
	[OPTIONSET_ID] [int] NULL,
        [POLICY_ID] [int] NULL,
	[INSURED_EID] [int] NULL,
	[LAST_NAME] [nvarchar](100) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,	
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
	[ORG_LEVEL] [int] NULL,
	[ORG_LEVEL_PARENT_ABBREVIATION] [nvarchar](25) NULL,
[CLIENT_SEQ_NUM] [varchar](30) NULL,
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_INSURER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLICY_X_INSURER](
	--[IN_ROW_ID] [int] NULL,
	[OPTIONSET_ID] [int] NULL,
        [POLICY_ID] [int] NULL,
	[INSURER_CODE] [int] NULL,
	[RES_PERCENTAGE] [float] NULL,
	[PRIMARY_INSURER] [nvarchar](1) NULL,
	[PREMIUM_AMOUNT] [float] NULL,
	[PART_OF_TOTAL_LAYER] [float] NULL,
	[PORTION_OF_PART_OF_LAYER] [float] NULL,
	[INSTAL_PAYMENT_AMT] [float] NULL,
	[INSTAL_SCHEDULE_CODE] [nvarchar](25) NULL,
	[SPECIAL_CIRCUM_MEMO] [nvarchar](16) NULL,
	[LAYER_NUM_CODE] [nvarchar](25) NULL,
	[OCCURENCE_LIMIT] [float] NULL,
	[COVERAGE_DESC] [nvarchar](100) NULL,
	[COMMENT_MEMO] [nvarchar](16) NULL,
	[LAST_NAME] [nvarchar](100) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,	
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](25) NULL,
[CLIENT_SEQ_NUM] [varchar](30) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PROP_MGT](
	[OPTIONSET_ID] [int] NULL,
        [PROP_MGT_ID] [int] NULL,
	[PROP_ID_TEXT] [nvarchar](50) NULL,
	[LOCATION_TXCD] [ntext] NULL,
	[OWNERSHIP_CODE] [int] NULL,
	[PROP_TYPE_CODE] [int] NULL,
	[PROP_CAT_TEXT] [nvarchar](50) NULL,
	[REPORTED_BY_TXCD] [ntext] NULL,
	[DT_UPDATE_DATE] [nvarchar](8) NULL,
	[REV_DATE_DATE] [nvarchar](8) NULL,
	[DETAIL_TXCD] [ntext] NULL,
	[ORIG_VALUE_AMT] [float] NULL,
	[CURR_VALUE_AMT] [float] NULL,
	[REPLACE_VAL_AMT] [float] NULL,
	[CONT_ORG_VL_AMT] [float] NULL,
	[CONT_REP_VL_AMT] [float] NULL,
	[CONT_CUR_VL_AMT] [float] NULL,
	[INSTALL_DT_DATE] [nvarchar](8) NULL,
	[CONTACT_TEXT] [nvarchar](50) NULL,
	[CONTACT_ADD_TEXT] [nvarchar](50) NULL,
	[CONT_CITY_TEXT] [nvarchar](25) NULL,
	[CONT_STATE_TEXT] [nvarchar](15) NULL,
	[CONT_ZIP_TEXT] [nvarchar](15) NULL,
	[CONT_PHONE_TEXT] [nvarchar](25) NULL,
	[COVERAGE_CODE] [int] NULL,
	[DAMAGES_TXCD] [ntext] NULL,
	[IMPROVEMENT_TXCD] [ntext] NULL,
	[NOTES_TXCD] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_CERTS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STAFF_CERTS](
	[OPTIONSET_ID] [int] NULL,
        [MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[NAME_CODE] [nvarchar](25) NULL,
	[INT_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESERVES]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RESERVES](
	[OPTIONSET_ID] [int] NULL,
        [RESERVE_ID] [int] NULL,
	[CLAIM_ID] [nvarchar](21) NULL,
	[RESERVE_TYPE_CODE] [nvarchar](25) NULL,
	[AMOUNT] [float] NULL,
	[RESERVE_DATE] [nvarchar](8) NULL,
	[ENTERED_BY_USER] [nvarchar](50) NULL,
	[REASON] [nvarchar](30) NULL,
	[CLAIMANT_LAST] [nvarchar](50) NULL,
	[CLAIMANT_FIRST] [nvarchar](50) NULL,
	[UNIT_ID] [nvarchar](50) NULL,
	[RES_STATUS_CODE] [nvarchar](8) NULL,
	[UNIT_TYPE] [nvarchar](25) NULL,
	[POLICY_NAME] [nvarchar](30) NULL,
	[UNIT_NUMBER] [nvarchar](25) NULL,
	[COVERAGE_CODE] [nvarchar](25) NULL,
	[LOSS_DISABILITY_CODE] [nvarchar](25) NULL,
	[RESERVE_SUB_TYPE] [nvarchar](25) NULL,
	[DISABILITY_TYPE_CATEGORY] [nvarchar](25) NULL,
	[MODULE_NO] [nvarchar](25) NULL,
	[CLASS_CODE] [nvarchar](30) NULL,
	[CVG_SEQUENCE_NO] [nvarchar](8) NULL,
	[TRANS_SEQ_NO] [nvarchar](8) NULL,
	[CVG_DESC] [nvarchar](100) NULL,
	[SUBLINE_DESC] [nvarchar](100) NULL,
	[CLASS_DESC] [nvarchar](100) NULL,
	[STAT_UNIT_NUMBER] [nvarchar](10) NULL,
	[POLICY_CVG_SEQNO] [nvarchar](25) NULL,
	[UPDATED_BY_USER] [varchar](50) NULL,
	[DTTM_RCD_ADDED] [varchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	[ADDED_BY_USER] [varchar](50) NULL,
	[CRC] [int] NULL,
	[CLAIM_CURR_CODE] [int] NULL,
	[CLAIM_TO_BASE_CUR_RATE] [float] NULL,
	[CLAIM_CURRENCY_RESERVE_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_INCURRED_AMT] [float] NULL,
	[CLAIM_CURR_COLLECTION_TOTAL] [float] NULL,
	[CLAIM_CURRENCY_PAID_TOTAL] [float] NULL,
	[CLAIM_CURRENCY_BALANCE_AMT] [float] NULL,
	[BASE_TO_CLAIM_CUR_RATE] [float] NULL,
	[ADJ_FIRST_NAME] [varchar](50) NULL,
	[ADJ_LAST_NAME] [varchar](100) NULL,
	[ADJ_TAX_ID] [varchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_PRIVS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[STAFF_PRIVS](
	[OPTIONSET_ID] [int] NULL,
    [MED_STAFF_NUMBER] [nvarchar](50) NULL,
	[CATEGORY_CODE] [nvarchar](25) NULL,
	[TYPE_CODE] [nvarchar](25) NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[INT_DATE] [nvarchar](8) NULL,
	[END_DATE] [nvarchar](8) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VEHICLE_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[VIN_TEXT] [nvarchar](255) NULL,
	[SSN_TEXT] [nvarchar](255) NULL,
	[OP_LAST_TEXT] [nvarchar](255) NULL,
	[OP_FIRST_TEXT] [nvarchar](255) NULL,
	[MANUF_TEXT] [nvarchar](255) NULL,
	[ODOMETER_NUM] [nvarchar](255) NULL,
	[UNIT_MEMO] [ntext] NULL,
	[UNIT_NUM] [nvarchar](255) NULL,
	[RDSURFACE_CODE] [nvarchar](255) NULL,
	[UNIT_TEXT] [nvarchar](255) NULL,
        [UNIT_ID] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_X_CLAIM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UNIT_X_CLAIM](
	[OPTIONSET_ID] [int] NULL,
        [UNIT_ID] [int] NULL,
	[CLAIM_ID] [nvarchar](25) NULL,
	[VEHICLE_MAKE] [nvarchar](20) NULL,
	[VEHICLE_YEAR] [int] NULL,
	[HOME_DEPT_EID] [nvarchar](25) NULL,
	[LICENSE_NUMBER] [nvarchar](20) NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[DAMAGE] [nvarchar](4000) NULL,
	[UNIT_TYPE_CODE] [nvarchar](25) NULL,
	[VIN] [nvarchar](20) NULL,
	[ISINSURED] [nvarchar](2) NULL,
	[ESTDAMAGE] [float] NULL, -- Newly Added - 23Jun2014 - Kapil
	[OWNER_LAST_NAME] [nvarchar](100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[OWNER_FIRST_NAME] [nvarchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[OWNER_TAX_ID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[ISDRIVABLE] [nvarchar](2) NULL,
	[ISNONVEHICLEPROPERTYDAMAGE] [nvarchar](2) NULL,
	[OTHERINSURANCE][nvarchar](2) NULL,
	[POLHOLDERISPROPERTYOWNER] [int] NULL, -- Newly Added - 23Jun2014 - Kapil 
	[POLICYHOLDER_LAST_NAME] [nvarchar](100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[POLICYHOLDER_FIRST_NAME] [nvarchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[POLICYHOLDER_TAX_ID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[COMPANY_LAST_NAME] [nvarchar](100) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[COMPANY_FIRST_NAME] [nvarchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[COMPANY_TAX_ID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[SEENAT] [nvarchar](max) NULL,
	[DATEREPORTED] [nvarchar](8) NULL, -- Newly Added - 23Jun2014 - Kapil
	[TIMEREPORTED] [nvarchar](6) NULL, -- Newly Added - 23Jun2014 - Kapil
	[POLICYNUMBER] [nvarchar](10) NULL, -- Newly Added - 23Jun2014 - Kapil
	[COVERAGES] [nvarchar](max) NULL,
	[LIMITS] [nvarchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil
	[ASSIGNADJ_LAST_NAME] [nvarchar](100) NULL,
	[ASSIGNADJ_FIRST_NAME] [nvarchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil  --
	[ASSIGNADJ_TAX_ID] [nvarchar](20) NULL -- Newly Added - 23Jun2014 - Kapil  --
	
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VEHICLE](
	[OPTIONSET_ID] [int] NULL,
	[DISPOSAL_DATE] [nvarchar](8) NULL,
	[LEASE_AMOUNT] [float] NULL,
	[LEASE_EXPIRE_DATE] [nvarchar](8) NULL,
	[LEASE_FLAG] [nvarchar] (2) NULL,
	[LEASE_NUMBER] [nvarchar](25) NULL,
	[LEASE_TERM] [int] NULL,
	[LEASING_CO_EID] [nvarchar](50) NULL,
	[LICENSE_RNWL_DATE] [nvarchar](8) NULL,
	[VEHICLE_MODEL] [nvarchar](50) NULL,
        [UNIT_ID] [int] NULL,
	[VEHICLE_MAKE] [nvarchar](20) NULL,
	[VEHICLE_YEAR] [int] NULL,
	[UNIT_TYPE_CODE] [nvarchar](25) NULL,
	[HOME_DEPT_EID] [nvarchar](50) NULL,
	[LICENSE_NUMBER] [nvarchar](20) NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[GROSS_WEIGHT] [float] NULL,
	[VIN] [nvarchar](50) NULL,
	[ORIGINAL_COST] [float] NULL,
	[PURCHASE_DATE] [nvarchar](8) NULL,
	[DEDUCTIBLE] [float] NULL,
	[LAST_SERVICE_DATE] [nvarchar](8) NULL,
	[TYPE_OF_SERVICE] [nvarchar](4000) NULL,   -- Newly Added - 23Jun2014 - Kapil
	[INSURANCE_COVERAGE] [nvarchar](4000) NULL, -- Newly Added - 23Jun2014 - Kapil
	[VEH_DESC] [nvarchar](300) NULL  -- Newly Added - 23Jun2014 - Kapil
) ON [PRIMARY] 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_ACC_DATE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VEHICLE_X_ACC_DATE](
	[OPTIONSET_ID] [int] NULL,
	[UNIT_ID] [int] NULL,
	[ACCIDENT_DATE] [nvarchar](8) NULL,
	[CLAIM_ID] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_INSPCT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VEHICLE_X_INSPCT](
	[OPTIONSET_ID] [int] NULL,
        [UNIT_ID] [int] NULL,
	[INSPECTION_DATE] [nvarchar](8) NULL,
	[INSPECTION_RESULT] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_PROPERTYLOSS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CLAIM_X_PROPERTYLOSS](
	[OPTIONSET_ID] [int] NULL,
	[PROPERTY_ID] [int] NULL,
	[CLAIM_ID] [nvarchar](25) NULL,
	[INSURED][nvarchar](1) NULL,
	[DAMAGE] [nvarchar](255)NULL,
	[PROPERTYTYPE] [nvarchar](25) NULL,
	[ESTDAMAGE] [float] NULL,
	[SEENAT] [nvarchar](255) NULL,
	[DATEREPORTED] [nvarchar](8) NULL,
	[TIMEREPORTED] [nvarchar](6) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[OWNER_LAST_NAME] [nvarchar](100) NULL,
	[OWNER_FIRST_NAME] [nvarchar](50) NULL,	
	[OWNER_TAX_ID] [nvarchar](20) NULL,
	[LOCOFTHEFT] [nvarchar](25) NULL,
	[INCENDIARYFIRE] [nvarchar](1) NULL,
	[VACANT][nvarchar](1) NULL,
	[UNDERCONSTRUCTION] [nvarchar](1) NULL,
	[EXPENSEFROM] [nvarchar](8) NULL,
	[EXPENSETO] [nvarchar](8) NULL,
	[OTHERINSURANCE] [nvarchar](1) NULL,
	[POLHOLDERISPROPERTYOWNER][nvarchar](1) NULL,
	[POLICYHOLDER_LAST_NAME] [nvarchar](100) NULL,
	[POLICYHOLDER_FIRST_NAME] [nvarchar](50) NULL,	
	[POLICYHOLDER_TAX_ID] [nvarchar](20) NULL,
	[COMPANY_LAST_NAME] [nvarchar](100) NULL,
	[COMPANY_FIRST_NAME] [nvarchar](50) NULL,	
	[COMPANY_TAX_ID] [nvarchar](20) NULL,
	[POLICYNUMBER] [nvarchar](10) NULL,
	[COVERAGES] [nvarchar](255) NULL,	
	[LIMITS] [nvarchar](50) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[ASSIGNADJ_LAST_NAME] [nvarchar](100) NULL,
	[ASSIGNADJ_FIRST_NAME] [nvarchar](50) NULL,	
	[ASSIGNADJ_TAX_ID] [nvarchar](20) NULL
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_PROPERTYLOSS_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CLAIM_X_PROPERTYLOSS_SUPP](
	[ROW_ID] [int] NULL
) ON [PRIMARY]
END
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_SITELOSS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CLAIM_X_SITELOSS](
	[OPTIONSET_ID] [int] NULL,
	[CLAIM_ID] [nvarchar](25) NULL,
	[SITE_ID] [int] NULL,
	[LOSS_PREVENTION_REPRESENTATIVE] [nvarchar](100) NULL,
	[LOSS_PREVENTION_CONTACT_NAME] [nvarchar](100) NULL,
	[FAX_NUMBER] [nvarchar](50) NULL,
	[EMAIL] [nvarchar](50) NULL,
	[PRE_QUOTE_SURVEY_ORDERED_DATE] [nvarchar](20) NULL,
	[POST_BIND_SURVEY_ORDERED_DATE] [nvarchar](20) NULL,
	[LOSS_PREVENTION_RATING] [nvarchar](20) NULL,
	[LOSS_PREVENTION_LASTVISITDATE] [nvarchar](20) NULL,
	[INTERIM_AUDITOR_ID] [nvarchar](50) NULL,
	[INTERIM_AUDITOR] [nvarchar](100) NULL,
	[CHECK_AUDITOR_ID] [nvarchar](50) NULL,
	[CHECK_AUDITOR] [nvarchar](100) NULL,
	[FINAL_AUDITOR_ID] [nvarchar](50) NULL,
	[FINAL_AUDITOR] [nvarchar](100) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[ISINSURED] [nvarchar](1) NULL,
	[ASSIGNADJ_LAST_NAME] [nvarchar](100) NULL,
	[ASSIGNADJ_FIRST_NAME] [nvarchar](50) NULL,	
	[ASSIGNADJ_TAX_ID] [nvarchar](20) NULL

) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROPERTY_UNIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PROPERTY_UNIT](
	[OPTIONSET_ID] [int] NULL,
	[UNIT_ID] [int] NULL,
	[PIN] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](50) NULL,
	[ADDR1] [nvarchar](200) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[CLASS_OF_CONS_CODE] [nvarchar](25)NULL,
	[YEAR_OF_CONS] [nvarchar](25) NULL,
	[WALL_CONS_CODE] [nvarchar](25) NULL,
	[ROOF_CONS_CODE] [nvarchar](25) NULL,
	[SQUARE_FOOTAGE] [float] NULL,
	[NO_OF_STORIES] [int] NULL,
	[AVG_STORY_HEIGHT] [float] NULL,
	[HEATING_SYS_CODE][nvarchar](25)NULL,
	[COOLING_SYS_CODE] [nvarchar](25) NULL,
	[FIRE_ALARM_CODE][nvarchar](25) NULL,
	[SPRINKLERS_CODE] [nvarchar](25) NULL,
	[ENTRY_ALARM_CODE] [nvarchar](25) NULL,
	[PLOT_PLANS_CODE][nvarchar](25) NULL,
	[FLOOD_ZONE_CERT_CODE] [nvarchar](25) NULL,
	[EARTHQUAKE_ZONE_CODE] [nvarchar](25) NULL,
	[GPS_LATITUDE] [float] NULL,
	[GPS_LONGITUDE] [float] NULL,
	[GPS_ALTITUDE] [float] NULL,
	[ROOF_ANCHORING_CODE] [nvarchar](25) NULL,
	[GLASS_STRENGTH_CODE][nvarchar](25) NULL,
	[APPRAISED_VALUE] [float] NULL,
	[REPLACEMENT_VALUE] [float] NULL,
	--[DELETED_FLAG] [smallint] NULL,
	[APPRAISED_DATE] [nvarchar](8) NULL,
	[LAND_VALUE] [float] NULL,
	[APPRAISAL_SOURCE_CODE] [nvarchar](25) NULL,
	[CATEGORY_CODE] [nvarchar](25) NULL,
	[TERRITORY_CODE] [nvarchar](25) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_OTHERUNIT]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[CLAIM_X_OTHERUNIT](
	[OPTIONSET_ID] [int] NULL,
	[CLAIM_ID] [nvarchar](25) NULL,
	[OTHER_UNIT_ID] [int] NULL,
	[UNIT_TYPE] [nvarchar](10) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[ISINSURED] [nvarchar](1) NULL
) ON [PRIMARY]
END
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITE_UNIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SITE_UNIT](
	[OPTIONSET_ID] [int] NULL,
	[UNIT_ID] [int] NULL,
	[SITE_NUMBER] [nvarchar](50) NULL,
	[NAME] [nvarchar](200) NULL,
	[OPTIONAL] [nvarchar](200) NULL,
	[ADDR1] [nvarchar](200) NULL,
	[ADDR2] [nvarchar](200) NULL,
	[STATE_ID] [nvarchar](25)  NULL,
	[CITY] [nvarchar](50) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[COUNTRY_ID] [nvarchar](25) NULL,--MKAUR
	[PHONE_NUMBER] [nvarchar](50) NULL,
	[CONTACT] [nvarchar](50) NULL,
	[TAX_LOCATION] [nvarchar](50) NULL,
	[UNEMPLOYEMENT_NUMBER] [nvarchar](50) NULL,
	[NUM_OF_EMP] [int] NULL,
	[FEIN] [nvarchar](50) NULL,
	[SIC] [nvarchar](50) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL
) ON [PRIMARY]
END
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POINT_UNIT_DATA]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POINT_UNIT_DATA](
	[OPTIONSET_ID] [int] NULL,
	[POLICY_ID] [int] NULL,
	--[ROW_ID] [int] NULL,
	[UNIT_ID] [int] NULL,
	[UNIT_TYPE] [nvarchar](10) NULL,
	[UNIT_NUMBER] [nvarchar](10) NULL,
	[UNIT_RISK_LOC] [nvarchar](10) NULL,
	[UNIT_RISK_SUB_LOC] [nvarchar](10) NULL,
	[SITE_SEQ_NUMBER] [nvarchar](10) NULL,
	[PRODUCT] [nvarchar](50) NULL,
	[INS_LINE] [nvarchar](50) NULL,
	[STAT_UNIT_NUMBER] [nvarchar](10) NULL
	) ON [PRIMARY]
END
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_X_CLAIM_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UNIT_X_CLAIM_SUPP](
	[UNIT_ROW_ID] [int] NULL,
	[VEH_NUM] [nvarchar](100) NULL,
	[PLATE_NUM] [nvarchar](100) NULL,
	[STATE] [nvarchar](100) NULL,
	[REL_TO_INS] [nvarchar](100) NULL,
	[LICENSE_NUM] [nvarchar](100) NULL,
	[DRIVER_STATE] [nvarchar](100) NULL,
	[PURPOSE_OF_USE] [nvarchar](100) NULL,
	[HAD_PERMISSION] [int] NULL,
	[VEH_EST_AMT] [float] NULL,
	[WHERE_VEH] [nvarchar](100) NULL,
	[WHEN_VEH] [nvarchar](100) NULL,
	[OTH_VEH_INS] [nvarchar](100) NULL,
	[SAME_AS_OWNER] [int] NULL,
	[VEH_COLOR_TEXT] [nvarchar](8) NULL,
	[ACV_AMT] [float] NULL,
	[TOTAL_LOSS_CODE] [int] NULL,
	[REC_THEFT_CODE] [int] NULL,
	[STATED_VALU_AMT] [float] NULL,
	[DEDUCTIBLE__AMT] [float] NULL
	) ON [PRIMARY]
END
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSON_INVOLVED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PERSON_INVOLVED](
	[OPTIONSET_ID] [int] NULL,
	[COUNTY_OF_RESIDNC] [nvarchar](50) NULL,
	[DRIVLIC_STATE] [nvarchar](25) NULL,
	[EST_LEN_DISABILITY] [int] NULL,
	[HIRED_IN_STE_FLAG] [nvarchar] (1) NULL,
	[INSURABLE_FLAG] [nvarchar] (1) NULL,
	[LAST_VERIFIED_DATE] [nvarchar](8) NULL,
	[NUM_OF_VIOLATIONS] [int] NULL,
	[OSHA_ACC_DESC] [nvarchar] (255) NULL,
	[OSHA_REC_FLAG] [nvarchar] (1) NULL,
	[REGULAR_JOB_FLAG] [nvarchar] (1) NULL,
	[TERM_DATE] [nvarchar](8) NULL,
	[WORK_PERMIT_DATE] [nvarchar](8) NULL,
	[WORK_PERMIT_NUMBER] [nvarchar](50) NULL,
	[WORKDAY_START_TIME] [nvarchar](6) NULL,
	[PI_ROW_ID] [int] NULL,
	[EVENT_ID] [int] NULL,	
	[PI_LAST_NAME] [nvarchar](100) NULL,
	[PI_FIRST_NAME] [nvarchar](50) NULL,	
	[PI_TAX_ID] [nvarchar](20) NULL,
	[PI_TYPE_CODE] [nvarchar](25) NULL,
	[INJURY_ILLNESS_FLG] [nvarchar] (1) NULL,
	[DATE_OF_DEATH] [nvarchar](8) NULL,
	[REHAB_TEXT] [nvarchar] (255) NULL,
	[DESC_BY_WITNESS] [nvarchar] (255) NULL,
	[PATIENT_ACCT_NO] [nvarchar](20) NULL,
	[MEDICAL_RCD_NO] [nvarchar](12) NULL,
	[INS_PLAN_GROUP_NO] [nvarchar](16) NULL,
	[DATE_OF_ADMISSION] [nvarchar](8) NULL,
	[DATE_OF_DISCHARGE] [nvarchar](8) NULL,
	[ADM_TYPE_CODE] [nvarchar](25) NULL,
	[ADM_SOURCE_CODE] [nvarchar](25) NULL,
	[ADMISSION_REASON] [nvarchar] (255) NULL,
	[ACUITY_LEVEL_CODE] [nvarchar](25) NULL,
	[PATIENT_STAT_CODE] [nvarchar](25) NULL,
	[PATIENT_COND_CODE] [nvarchar](25) NULL,
	[DISCHARGE_DSP_CODE] [nvarchar](25) NULL,
	[EXP_LENGTH_OF_STAY] [int] NULL,
	[EXPECTED_COST] [float] NULL,
	[QI_SIGNIF_CODE][nvarchar](25) NULL,
	[EPISODE_OF_CARE_ID] [nvarchar](8) NULL,
	[PATIENT_TYPE_CODE] [nvarchar](25) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[RACE_ENTH_CODE] [nvarchar](25) NULL,
	[WEIGHT] [int] NULL,
	[PRIMARY_PAY_CODE] [nvarchar](25) NULL,
	[EMERGENCY_CONTACT] [nvarchar](20) NULL,
	[EMERGENCY_CONT_NO] [nvarchar](20) NULL,
	[PATIENT_ROOM_NO] [nvarchar](14) NULL,
	[FACILITY_UNIT_CODE] [nvarchar](25) NULL,
	[FACILITY_DEPT_EID] [nvarchar](25) NULL,
	[HCO_ID_NO] [nvarchar](20) NULL,
	[HCO_SITE_ID_NO] [nvarchar](20) NULL,
	[WHY_AT_FACILITY] [nvarchar] (255) NULL,
	[CLAIM_AMOUNT] [float] NULL,
	[LOST_WORK_FLAG] [nvarchar] (1) NULL,
	[LEN_OF_SVC_DAYS] [int] NULL,
	[POSITION_CODE][nvarchar](25)NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[SUPERVISOR_EID] [nvarchar](25) NULL,
	[EXEMPT_STATUS_FLAG] [nvarchar] (1) NULL,
	[NO_OF_EXEMPTIONS] [int] NULL,
	[FULL_TIME_FLAG] [nvarchar] (1) NULL,
	[HOURLY_RATE] [float] NULL,
	[WEEKLY_HOURS] [float] NULL,
	[WEEKLY_RATE] [float] NULL,
	[WORK_SUN_FLAG] [nvarchar] (1) NULL,
	[WORK_MON_FLAG] [nvarchar] (1) NULL,
	[WORK_TUE_FLAG] [nvarchar] (1) NULL,
	[WORK_WED_FLAG] [nvarchar] (1) NULL,
	[WORK_THU_FLAG] [nvarchar] (1) NULL,
	[WORK_FRI_FLAG] [nvarchar] (1) NULL,
	[WORK_SAT_FLAG] [nvarchar] (1) NULL,
	[DRIVERS_LIC_NO][nvarchar](20) NULL,
	[DRIVERSLICTYPECODE][nvarchar](25) NULL,
	[DATE_DRIVERSLICEXP] [nvarchar](8) NULL,
	[DRIVLIC_RSTRCTCODE] [nvarchar](25) NULL,
	[NCCI_CLASS_CODE] [nvarchar](25) NULL,
	[COMMENTS] [nvarchar] (255) NULL,
	[INJURY_CAT_CODE] [nvarchar](25) NULL,
	[PAY_AMOUNT] [float] NULL,
	[ACTIVE_FLAG] [nvarchar] (1) NULL,
	[EMPLOYEE_NUMBER] [nvarchar](20) NULL,
	[DATE_HIRED] [nvarchar](8) NULL,
	[DISABILITY_CODE] [nvarchar](25) NULL,
	[ILLNESS_CODE] [nvarchar](25) NULL,
	[PAY_TYPE_CODE] [nvarchar](25) NULL,
	[LOST_CONSC_FLAG] [nvarchar] (1) NULL,
	[SEC_DEPT_EID] [nvarchar](25) NULL,
	[PATIENT_ID] [nvarchar](20) NULL,
	[EST_RTW_DATE] [nvarchar](8) NULL,
	[OSHA_ESTAB_EID] [nvarchar](25) NULL,
	[MAJOR_HAND_CODE] [nvarchar](25) NULL,
	[HRANGE_START_DATE] [nvarchar](8) NULL,
	[HRANGE_END_DATE] [nvarchar](8) NULL,
	[JOB_CLASS_CODE] [nvarchar](25)NULL,
	[OTHER_TREATMENTS] [nvarchar] (255) NULL,
	[OTHER_MEDCOND] [nvarchar] (255) NULL,
	[STD_DISABIL_TYPE] [nvarchar](25) NULL,
	[CUSTOM_FED_TAX_PER] [float] NULL,
	[CUSTOM_SS_TAX_PER] [float] NULL,
	[CUSTOM_MED_TAX_PER] [float] NULL,
	[CUSTOM_ST_TAX_PER] [float] NULL,
	[MONTHLY_RATE] [float] NULL,
	[ELIG_DIS_BEN_FLAG] [nvarchar] (1) NULL,
	[DIS_OPTION_CODE] [nvarchar](25) NULL,
	[HTMLCOMMENTS] [nvarchar] (255) NULL,
	[CONF_FLAG] [nvarchar] (1) NULL,
	[CONF_EVENT_ID] [int] NULL,
	[WHERE_INJ_TAKEN] [nvarchar] (255) NULL,
	[WHAT_INJ_DOING] [nvarchar] (255) NULL,
	[DATE_DISABILITY_BEGAN] [nvarchar](8) NULL,
	[DATE_DISABILITY_END] [nvarchar](8) NULL,
	[PRE_EXISTING_COND_FLAG] [nvarchar] (1) NULL,
	[PRE_EXISTING_COND] [nvarchar](25) NULL,
	[DIAGNOSIS_CODE] [nvarchar](25) NULL,
	[COLLAT_SOURCES_DESC] [int] NULL,
	[INJ_CON_WITH_POL_RPT_FLAG] [nvarchar] (1) NULL,
	[ER_HOSPITAL_FLAG] [nvarchar] (1) NULL,
	[CAT_INJURY_FLAG] [nvarchar] (1) NULL,
	[MEDICATIONS] [nvarchar](200) NULL,
	[FILE_CLOSING_DATE] [nvarchar](8) NULL,
	[SYMPTOMS_DESC] [nvarchar](200) NULL,
	--[INJ_DEPT_EID] [int] NULL,
	--[DELETED_DATE] [nvarchar](14) NULL,
	[INJURYCAUSE_CODE] [nvarchar](25) NULL,
	[PROGNOSIS] [nvarchar] (255) NULL,
	[IMPAIRMENT_FLAG] [nvarchar] (1) NULL,
	[DAILY_HOURS] [float] NULL,
	[DAILY_RATE] [float] NULL,
	[WEEKLY_OFFSET] [float] NULL,
	[GROSS_EARNINGS] [float] NULL,
	[DRIVER_ROW_ID] [int] NULL,
	[POLICY_UNIT_ROW_ID] [int] NULL,
	[ENTITY_TABLE_ID] [nvarchar](30) NULL,	
	[POLICY_ID] [int] NULL,
	[CLIENT_SEQ_NUM] [varchar](30) NULL,
	) ON [PRIMARY]
END
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DRIVER]') AND type in (N'U'))
BEGIN
CREATE TABLE [DRIVER](
	[OPTIONSET_ID] [int] NULL,
	[DRIVER_ROW_ID] [int] NULL,	
	[DRIVER_LAST_NAME] [nvarchar](100) NULL,
	[DRIVER_FIRST_NAME] [nvarchar](50) NULL,	
	[DRIVER_TAX_ID] [nvarchar](20) NULL,	
	[DRIVER_TYPE] [nvarchar](25) NULL,
	[LICENCE_DATE] [nvarchar](8) NULL,
	[LICENCE_NUMBER] [nvarchar](50) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
[PS_INS_LINE] [nvarchar](50) NULL,
[PS_RISK_LOC] [nvarchar](10) NULL,
[PS_RISK_SUB_LOC] [nvarchar](10) NULL,
[PS_PRODUCT] [nvarchar](50) NULL,
[PS_DRIVER_ID] [int] NULL,
[PS_RECORD_STATUS] [nvarchar](25) NULL
	) ON [PRIMARY]
END
Go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OTHER_UNIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [OTHER_UNIT](
	[OPTIONSET_ID] [int] NULL,
	[OTHER_UNIT_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[UNIT_TYPE] [nvarchar](10) NULL,	
	[ADDED_BY_USER] [nvarchar](10) NULL,
	[UPDATED_BY_USER] [nvarchar](10) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL
	) ON [PRIMARY]
END
Go



/****** Object:  Table [dbo].[FUNDS_X_PAYEE]    Script Date: 10/06/2014 13:29:33 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_X_PAYEE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_X_PAYEE](
	[OPTIONSET_ID] [int] NULL,
	[PAYEE_EID] [int] NULL,
	[FUNDS_TRANS_ID] [int] NULL,
	[PAYEE_1099_FLAG] [int] NULL,
	[DTTM_RCD_ADDED] [nvarchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [nvarchar](14) NULL,
	[ADDED_BY_USER] [nvarchar](50) NULL,
	[UPDATED_BY_USER] [nvarchar](50) NULL,
	[PAYEE_TYPE_CODE] [nvarchar](25) NULL,
	[PHRASE_TYPE_CODE] [nvarchar](25) NULL,
	[BEFORE_PAYEE] [int] NULL
) ON [PRIMARY]
END
GO
/* mkaur24 <12/18/2014> */
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[PROP_MGT]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PROP_MGT](
	[OPTIONSET_ID] [int] NULL,
	[PROP_MGT_ID] [int]  NULL,
	[PROP_ID_TEXT] [nvarchar](50) NULL,
	[LOCATION_TXCD] [nvarchar](2000) NULL,
	[OWNERSHIP_CODE] [nvarchar](25) NULL,
	[PROP_TYPE_CODE] [nvarchar](25) NULL,
	[PROP_CAT_TEXT] [nvarchar](50) NULL,
	[REPORTED_BY_TXCD] [nvarchar](2000) NULL,
	[DT_UPDATE_DATE] [nvarchar](8) NULL,
	[REV_DATE_DATE] [nvarchar](8) NULL,
	[DETAIL_TXCD] [nvarchar](2000) NULL,
	[ORIG_VALUE_AMT] [float] NULL,
	[CURR_VALUE_AMT] [float] NULL,
	[REPLACE_VAL_AMT] [float] NULL,
	[CONT_ORG_VL_AMT] [float] NULL,
	[CONT_REP_VL_AMT] [float] NULL,
	[CONT_CUR_VL_AMT] [float] NULL,
	[INSTALL_DT_DATE] [nvarchar](8) NULL,
	[CONTACT_TEXT] [nvarchar](50) NULL,
	[CONTACT_ADD_TEXT] [nvarchar](50) NULL,
	[CONT_CITY_TEXT] [nvarchar](25) NULL,
	[CONT_STATE_TEXT] [nvarchar](15) NULL,
	[CONT_ZIP_TEXT] [nvarchar](15) NULL,
	[CONT_PHONE_TEXT] [nvarchar](25) NULL,
	[COVERAGE_CODE] [nvarchar](25) NULL,
	[DAMAGES_TXCD] [nvarchar](2000) NULL,
	[IMPROVEMENT_TXCD] [nvarchar](2000) NULL,
	[NOTES_TXCD] [nvarchar](2000) NULL
	

) ON [PRIMARY]
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK]') AND type in (N'U'))
DROP TABLE [dbo].[PROJ_TRACK]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PROJ_TRACK](
	[OPTIONSET_ID] [int] NULL,
	[PROJ_TRACK_ID] [int] NULL,
	[ACT_TYPE_CODE] [nvarchar](25) NULL,
	[ACTIV_DESC_TXCD] [nvarchar](2000) NULL,
	[ASSIGN_BY_TEXT] [nvarchar](50) NULL,
	[ASSIGN_TO_TXCD][nvarchar](2000) NULL,
	[PRIORITY_CODE] [nvarchar](25) NULL,
	[EST_HOURS_NUM] [float] NULL,
	[ACT_HOURS_NUM] [float] NULL,
	[DUE_DATE_DATE] [nvarchar](8) NULL,
	[REVIEW_DATE_DATE] [nvarchar](8) NULL,
	[COMPLETE_DT_DATE] [nvarchar](8) NULL,
	[STATUS_CODE] [nvarchar](25) NULL,
	[MAT_USED_TXCD] [nvarchar](2000) NULL,
	[MAT_COST_AMT] [float] NULL,
	[NOTES_TXCD] [nvarchar](2000) NULL
) ON [PRIMARY]
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY]') AND type in (N'U'))
DROP TABLE [dbo].[DIRECTORY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DIRECTORY](
	[OPTIONSET_ID] [int] NULL,
	[DIRECTORY_ID] [int]  NULL,
	[LAST_NAME_TEXT] [nvarchar](50) NULL,
	[FIRST_NAME_TEXT] [nvarchar](50) NULL,
	[ADDRESS_TEXT] [nvarchar](50) NULL,
	[CITY_TEXT] [nvarchar](50) NULL,
	[STATE_TEXT] [nvarchar](15) NULL,
	[ZIP_CODE_TEXT] [nvarchar](15) NULL,
	[HOME_PHONE_TEXT] [nvarchar](25) NULL,
	[WORK_PHONE_TEXT] [nvarchar](25) NULL,
	[FAX_TEXT] [nvarchar](25) NULL,
	[TITLE_TEXT] [nvarchar](25) NULL,
	[ORGANIZ_TEXT] [nvarchar](50) NULL,
	[CONTACT_TYP_CODE] [nvarchar](25) NULL,
	[CONTACT_STA_CODE] [nvarchar](25) NULL,
	[RECALL_DT_DATE] [nvarchar](8) NULL,
	[NOTES_TXCD] [nvarchar](2000) NULL
) ON [PRIMARY]
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[COMPL_MGT]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPL_MGT](
	[OPTIONSET_ID] [int] NULL,
	[COMPL_MGT_ID] [int]  NULL,
	[COMP_NO_TEXT] [nvarchar](25) NULL,
	[DT_RECV_DATE] [nvarchar](8) NULL,
	[COMP_TYPE_CODE] [nvarchar](25) NULL,
	[COMP_SRC_CODE] [nvarchar](25) NULL,
	[ACT_REQ_TXCD] [nvarchar](2000) NULL,
	[FILED_AGNST_TEXT] [nvarchar](50) NULL,
	[REF_TO_TXCD] [nvarchar](2000) NULL
) ON [PRIMARY]
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[CONTRCT_MGT]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CONTRCT_MGT](
	[OPTIONSET_ID] [int] NULL,
	[CONTRCT_MGT_ID] [int]  NULL,
	[CONT_TYPE_CODE][nvarchar](25)NULL,
	[CONTR_CAT_TXCD] [nvarchar](2000) NULL,
	[SUBJECTOR_TEXT] [nvarchar](50) NULL,
	[SUBJECTEE_TEXT] [nvarchar](50) NULL,
	[DETAILS_TXCD] [nvarchar](2000) NULL,
	[EFF_DATE_DATE] [nvarchar](8) NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[RENEW_DATE_DATE] [nvarchar](8) NULL,
	[INDEMNITY_TXCD] [nvarchar](2000) NULL,
	[SUBROGATION_TXCD][nvarchar](2000) NULL,
	[TERM_INFO_TEXT] [nvarchar](50) NULL,
	[CONDITIONS_TXCD] [nvarchar](2000) NULL,
	[AUTH_SIGN_TXCD] [nvarchar](2000) NULL,
	[PAYMENTS_TXCD] [nvarchar](2000) NULL,
	[WARRANTY_TXCD] [nvarchar](2000) NULL
) ON [PRIMARY]
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE]') AND type in (N'U'))
DROP TABLE [dbo].[CERTIFICATE]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CERTIFICATE](
	[OPTIONSET_ID] [int] NULL,
	[CERTIFICATE_ID] [int]  NULL,
	[JOB_NO_TEXT] [nvarchar](15) NULL,
	[JOB_DESC_TXCD] [nvarchar](2000) NULL,
	[AGENCY_NAME_TEXT] [nvarchar](50) NULL,
	[AGENCY_PHON_TEXT] [nvarchar](20) NULL,
	[INSURED_NAM_TEXT] [nvarchar](50) NULL,
	[INSURED_ADD_TEXT] [nvarchar](50) NULL,
	[INSURED_CIT_TEXT] [nvarchar](25) NULL,
	[INSURED_ST_TEXT] [nvarchar](15) NULL,
	[INSURED_ZIP_TEXT] [nvarchar](15) NULL,
	[INSURED_PH_TEXT] [nvarchar](20) NULL,
	[GEN_LIAB_TXCD] [nvarchar](2000) NULL,
	[INS_NAME_TEXT] [nvarchar](50) NULL,
	[POL_NUMBER_NUM] [float] NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[BI_EA_AGG_TEXT] [nvarchar](25) NULL,
	[PD_EA_AGG_TEXT] [nvarchar](25) NULL,
	[BI_PD_COMB_NUM] [float] NULL,
	[PI_AGG_NUM] [float] NULL,
	[AUTO_LIAB_TEXT] [nvarchar](25) NULL,
	[BI_EA_PERS_NUM] [float] NULL,
	[BI_EA_ACC_NUM] [float] NULL,
	[PD_EA_OCC_NUM] [float] NULL,
	[BI_PD_COMB_TEXT] [nvarchar](15) NULL,
	[EXCESS_LIAB_TXCD] [nvarchar](2000) NULL,
	[BI_PD_AGG_TEXT] [nvarchar](15) NULL,
	[WORK_COMP_NUM] [float] NULL,
	[WORK_COMP_TEXT] [nvarchar](25) NULL,
	[WC_EA_ACC_NUM] [float] NULL,
	[OPER_DESC_TXCD] [nvarchar](2000) NULL,
	[ISSUE_DT_DATE] [nvarchar](8) NULL
) ON [PRIMARY]
END
GO




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS]') AND type in (N'U'))
DROP TABLE [dbo].[BOND_ABS]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BOND_ABS](
	[OPTIONSET_ID] [int] NULL,
	[BOND_ABS_ID] [int]  NULL,
	[BOND_NUM_TEXT] [nvarchar](20) NULL,
	[BOND_TYPE_TXCD] [nvarchar](2000) NULL,
	[BOND_LINE_CODE] [nvarchar](25) NULL,
	[EFF_DATE_DATE] [nvarchar](8) NULL,
	[EXPIR_DATE_DATE] [nvarchar](8) NULL,
	[BOND_AMT_AMT] [float] NULL,
	[PREMIUM_AMT] [float] NULL,
	[BILL_NAME_TEXT] [nvarchar](50) NULL,
	[BILL_ADDR_TEXT] [nvarchar](50) NULL,
	[BILL_CITY_TEXT] [nvarchar](25) NULL,
	[BILL_ZIP_TEXT] [nvarchar](15) NULL,
	[BILL_ACCT_TEXT] [nvarchar](50) NULL,
	[PRINCIPAL_TXCD] [nvarchar](2000) NULL,
	[STATE_TEXT] [nvarchar](3) NULL,
	[BILL_STATE_TEXT] [nvarchar](25) NULL,
	[OBLIGEE_TXCD] [nvarchar](2000) NULL,
	[BOND_CLASS_CODE] [nvarchar](25) NULL,
	[OLD_BOND_NO_TEXT] [nvarchar](25) NULL,
	[REQUESTER_TEXT] [nvarchar](50) NULL,
	[REQ_ADDR_TEXT] [nvarchar](50) NULL,
	[REQ_CITY_TEXT] [nvarchar](25) NULL,
	[REQ_STATE_TEXT] [nvarchar](25) NULL,
	[REQ_ZIP_TEXT] [nvarchar](15) NULL,
	[REQ_PHONE_TEXT] [nvarchar](15) NULL,
	[ORDERED_BY_TEXT] [nvarchar](50) NULL,
	[ORDER_ADDR_TEXT] [nvarchar](50) NULL,
	[ORDER_CITY_TEXT] [nvarchar](25) NULL,
	[ORDER_STATE_TEXT] [nvarchar](15) NULL,
	[ORDER_ZIP_TEXT] [nvarchar](15) NULL,
	[ORDER_PHONE_TEXT] [nvarchar](25) NULL,
	[AUTH_BY_TEXT] [nvarchar](50) NULL,
	[AUTH_ADDR_TEXT] [nvarchar](50) NULL,
	[AUTH_CITY_TEXT] [nvarchar](25) NULL,
	[AUTH_STATE_TEXT] [nvarchar](15) NULL,
	[AUTH_ZIP_TEXT] [nvarchar](15) NULL,
	[AUTH_PHONE_TEXT] [nvarchar](15) NULL,
	[DATE_EXEC_DATE] [nvarchar](8) NULL,
	[PAID_DATE_DATE] [nvarchar](8) NULL,
	[BOND_STATUS_CODE] [nvarchar](25) NULL,
	[DATE_CANC_DATE] [nvarchar](8) NULL,
	[BOND_DETAIL_TXCD] [nvarchar](2000) NULL
) ON [PRIMARY]
END
GO