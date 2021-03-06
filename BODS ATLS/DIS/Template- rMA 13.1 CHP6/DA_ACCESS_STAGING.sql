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
	[VIOLATION_CODE] [nvarchar](6) NULL,
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
        [DEPENDENT_EID] [int] NULL,
	[EMPLOYEE_EID] [int] NULL,
	[HEALTH_PLAN_FLAG] [nvarchar](1) NULL,
	[RELATION_CODE] [nvarchar](6) NULL
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
        [EMPLOYEE_EID] [int] NULL,
	[EMPLOYEE_NUMBER] [nvarchar](20) NULL,
	[ACTIVE_FLAG] [nvarchar](1) NULL,
	[WORK_PERMIT_NUMBER] [nvarchar](50) NULL,
	[WORK_PERMIT_DATE] [nvarchar](8) NULL,
	[LAST_VERIFIED_DATE] [nvarchar](8) NULL,
	[DATE_HIRED] [nvarchar](8) NULL,
	[POSITION_CODE] [nvarchar](25) NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[SUPERVISOR_EID] [int] NULL,
	[FULL_TIME_FLAG] [nvarchar](1) NULL,
	[EXEMPT_STATUS_FLAG] [nvarchar](1) NULL,
	[PAY_TYPE_CODE] [nvarchar](6) NULL,
	[PAY_AMOUNT] [float] NULL,
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
	[INSURABLE_FLAG] [nvarchar](1) NULL,
	[DRIVLIC_STATE] [nvarchar](6) NULL,
	[DRIVERS_LIC_NO] [nvarchar](20) NULL,
	[DRIVERSLICTYPECODE] [nvarchar](6) NULL,
	[DATE_DRIVERSLICEXP] [nvarchar](8) NULL,
	[DRIVLIC_RSTRCTCODE] [nvarchar](6) NULL,
	[MARITAL_STAT_CODE] [nvarchar](6) NULL,
	[NO_OF_EXEMPTIONS] [int] NULL,
	[DATE_OF_DEATH] [nvarchar](8) NULL,
	[NCCI_CLASS_CODE] [nvarchar](25) NULL,
	[TERM_DATE] [nvarchar](8) NULL,
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
        [ENTITY_ID] [int] NULL,
	[ENTITY_TABLE_ID] [nvarchar](18) NULL,
	[TAX_ID] [nvarchar](20) NULL,
	[ABBREVIATION] [nvarchar](20) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[BUSINESS_TYPE_CODE] [nvarchar](6) NULL,
	[COST_CENTER_CODE] [nvarchar](6) NULL,
	[SEX_CODE] [nvarchar](6) NULL,
	[BIRTH_DATE] [nvarchar](8) NULL,
	[ALSO_KNOWN_AS] [nvarchar](20) NULL,
	[NATURE_OF_BUSINESS] [nvarchar](20) NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[COUNTRY_CODE] [nvarchar](6) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](20) NULL,
	[EMAIL_TYPE_CODE] [nvarchar](6) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[PARENT_ABBREV] [nvarchar](25) NULL,
	[WC_FILING_NUMBER] [nvarchar](30) NULL,
	[SIC_CODE] [nvarchar](25) NULL,
	[CONTACT] [nvarchar](50) NULL,
	[PARENT_EID] [int] NULL,
	[EFF_START_DATE] [nvarchar](8) NULL,
	[EFF_END_DATE] [nvarchar](8) NULL,
	[MIDDLE_NAME] [nvarchar](50) NULL,
	[REPORT_1099_FLAG] [nvarchar](1) NULL,
	[DELETED_FLAG] [nvarchar](1) NULL,
	[PARENT_1099_EID] [int] NULL,
	[AUTO_DISCOUNT] [int] NULL,
	[NPI_NUMBER] [nvarchar](10) NULL
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
	[CLAIM_ID] [nvarchar](50) NULL,
	[CLAIMANT_LAST] [nvarchar](50) NULL,
	[CLAIMANT_FIRST] [nvarchar](50) NULL,
	[UNIT_ID] [nvarchar](50) NULL,
	[LAST_NAME] [nvarchar](50) NULL,
	[FIRST_NAME] [nvarchar](50) NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[COUNTRY_CODE] [nvarchar](6) NULL,
	[PAYEE_TYPE_CODE] [nvarchar](25) NULL,
	[ACCOUNT_ID] [nvarchar](20) NULL,
	[DATE_OF_CHECK] [nvarchar](8) NULL,
	[TRANS_DATE] [nvarchar](8) NULL,
	[TRANS_TYPE] [nvarchar](1) NULL,
	[STATUS_CODE] [nvarchar](1) NULL,
	[CLEARED_FLAG] [nvarchar](1) NULL,
	[AMOUNT] [float] NULL,
	[FILED_1099_FLAG] [nvarchar](1) NULL,
	[UPDATE_RESERVES] [nvarchar](1) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[TRANS_NUMBER] [int] NULL,
	[CTL_NUMBER] [nvarchar](25) NULL,
	[TAX_ID] [nvarchar](11) NULL,
	[CHECK_MEMO] [nvarchar](255) NULL,
	[VOID_DATE] [nvarchar](8) NULL,
	[PAYMENT_FLAG] [int] NULL,
	[PAYEE_EID] [int] NULL
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
	[DESCRIPTION] [nvarchar](40) NULL,
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
	[ALSO_KNOWN_AS] [nvarchar](20) NULL,
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
	[BIRTH_DATE] [nvarchar](8) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[HOME_ADDR1] [nvarchar](50) NULL,
	[HOME_ADDR2] [nvarchar](50) NULL,
	[HOME_CITY] [nvarchar](50) NULL,
	[HOME_STATE_ID] [nvarchar](25) NULL,
	[HOME_ZIP_CODE] [nvarchar](10) NULL,
	[BEEPER_NUMBER] [nvarchar](30) NULL,
	[CELLULAR_NUMBER] [nvarchar](30) NULL,
	[EMERGENCY_CONTACT] [nvarchar](30) NULL,
	[STAFF_STATUS_CODE] [nvarchar](25) NULL,
	[STAFF_POS_CODE] [nvarchar](25) NULL,
	[STAFF_CAT_CODE] [nvarchar](25) NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[HIRE_DATE] [nvarchar](8) NULL,
	[PRIMARY_POLICY_NUMBER] [nvarchar](50) NULL,
	[LIC_NUM] [nvarchar](20) NULL,
	[LIC_STATE] [nvarchar](25) NULL,
	[LIC_ISSUE_DATE] [nvarchar](8) NULL,
	[LIC_EXPIRY_DATE] [nvarchar](8) NULL,
	[LIC_DEA_NUM] [nvarchar](20) NULL,
	[LIC_DEA_EXP_DATE] [nvarchar](8) NULL
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
	[TRANS_ID] [int] NULL,
	[TRANS_TYPE_CODE] [nvarchar](25) NULL,
	[RESERVE_TYPE_CODE] [nvarchar](25) NULL,
	[GL_ACCOUNT_CODE] [nvarchar](6) NULL,
	[FROM_DATE] [nvarchar](8) NULL,
	[TO_DATE] [nvarchar](8) NULL,
	[INVOICED_BY] [nvarchar](20) NULL,
	[INVOICE_AMOUNT] [float] NULL,
	[INVOICE_NUMBER] [nvarchar](14) NULL,
	[PO_NUMBER] [nvarchar](14) NULL,
	[AMOUNT] [float] NULL,
	[INVOICE_DATE] [nvarchar](8) NULL
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
	[ALSO_KNOWN_AS] [nvarchar](20) NULL,
	[ADDR1] [nvarchar](50) NULL,
	[ADDR2] [nvarchar](50) NULL,
	[CITY] [nvarchar](50) NULL,
	[COUNTY] [nvarchar](30) NULL,
	[STATE_ID] [nvarchar](25) NULL,
	[ZIP_CODE] [nvarchar](10) NULL,
	[PHONE1] [nvarchar](30) NULL,
	[PHONE2] [nvarchar](30) NULL,
	[FAX_NUMBER] [nvarchar](20) NULL,
	[EMAIL_ADDRESS] [nvarchar](25) NULL,
	[SEX_CODE] [nvarchar](25) NULL,
	[BIRTH_DATE] [nvarchar](8) NULL,
	[HEIGHT] [float] NULL,
	[WEIGHT] [float] NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[RACE_ENTH_CODE] [nvarchar](25) NULL,
	[EMERGENCY_CONTACT] [nvarchar](20) NULL,
	[EMERGENCY_CONT_NO] [nvarchar](20) NULL,
	[DATE_OF_ADMISSION] [nvarchar](8) NULL,
	[TIME_OF_ADMISSION] [nvarchar](6) NULL,
	[DATE_OF_DISCHARGE] [nvarchar](8) NULL,
	[TIME_OF_DISCHARGE] [nvarchar](6) NULL,
	[ADMISSION_REASON] [ntext] NULL,
	[ADM_TYPE_CODE] [nvarchar](25) NULL,
	[ADM_SOURCE_CODE] [nvarchar](25) NULL,
	[ACUITY_LEVEL_CODE] [nvarchar](25) NULL,
	[CARDIAC_ARREST] [nvarchar](1) NULL,
	[PATIENT_STAT_CODE] [nvarchar](25) NULL,
	[PATIENT_COND_CODE] [nvarchar](25) NULL,
	[DISCHARGE_DSP_CODE] [nvarchar](25) NULL,
	[DATE_OF_DEATH] [nvarchar](8) NULL,
	[EXP_LENGTH_OF_STAY] [int] NULL,
	[EXPECTED_COST] [float] NULL,
	[INS_PLAN_GROUP_NO] [nvarchar](16) NULL,
	[QI_SIGNIF_CODE] [nvarchar](25) NULL,
	[EPISODE_OF_CARE_ID] [nvarchar](8) NULL,
	[PATIENT_TYPE_CODE] [nvarchar](25) NULL,
	[PRIMARY_PAY_CODE] [nvarchar](25) NULL,
	[SECOND_PAY_CODE] [nvarchar](25) NULL,
	[PATIENT_ROOM_NO] [nvarchar](14) NULL,
	[FACILITY_UNIT_CODE] [nvarchar](25) NULL,
	[FACILITY_DEPT_EID] [nvarchar](25) NULL,
	[HCO_ID_NO] [nvarchar](20) NULL,
	[HCO_SITE_ID_NO] [nvarchar](20) NULL,
	[PRI_PHYS_LAST_NAME] [nvarchar](50) NULL,
	[PRI_PHYS_FIRST_NAME] [nvarchar](50) NULL,
	[PRI_PHYS_TAX_ID] [nvarchar](20) NULL,
	[ADM_PHYS_LAST_NAME] [nvarchar](50) NULL,
	[ADM_PHYS_FIRST_NAME] [nvarchar](50) NULL,
	[ADM_PHYS_TAX_ID] [nvarchar](20) NULL,
	[COUNTRY_CODE] [nvarchar](25) NULL,
	[PRI_PHYS_NUMBER] [nvarchar](50) NULL,
	[ADM_PHYS_NUMBER] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
	[COMPLICATIONS] [ntext] NULL,
	[SURGEON_PHYS_NUMBER] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
	[POLICY_ID] [int] NULL,
	[POLICY_NUMBER] [nvarchar](20) NULL,
	[EFFECTIVE_DATE] [nvarchar](8) NULL,
	[EXPIRATION_DATE] [nvarchar](8) NULL,
	[INSURER_EID] [nvarchar](20) NULL,
	[POLICY_STATUS_CODE] [nvarchar](6) NULL,
	[POLICY_NAME] [nvarchar](20) NULL,
	[ISSUE_DATE] [nvarchar](8) NULL,
	[REVIEW_DATE] [nvarchar](8) NULL,
	[RENEWAL_DATE] [nvarchar](8) NULL,
	[CANCEL_DATE] [nvarchar](8) NULL,
	[PREMIUM] [float] NULL,
	[TRIGGER_CLAIM_FLAG] [nvarchar](1) NULL,
	[PRIMARY_POLICY_FLG] [nvarchar](1) NULL,
	[COMMENTS] [nvarchar](50) NULL,
	[BROKER_EID] [nvarchar](50) NULL,
	[BANK_ACC_ID] [int] NULL,
	[SUB_ACC_ROW_ID] [int] NULL,
	[PHONE1] [nvarchar](30) NULL,
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
	[NEW_POLICY_ID] INT
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
	[NPI_NUMBER] [nvarchar](10) NULL
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
        [POLICY_ID] [int] NULL,
	[COVERAGE_TYPE_CODE] [nvarchar](25) NULL,
	[POLICY_LIMIT] [float] NULL,
	[CLAIM_LIMIT] [float] NULL,
	[OCCURRENCE_LIMIT] [float] NULL,
	[NEXT_POLICY_ID] [int] NULL,
	[CANCEL_NOTICE_DAYS] [int] NULL,
	[SELF_INSURE_DEDUCT] [float] NULL,
	[NOTIFICATION_UID] [int] NULL
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
	[ABBREVIATION] [nvarchar](25) NULL,
	[ORG_LEVEL] [int] NULL
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
	[IN_ROW_ID] [int] NULL,
        [POLICY_ID] [int] NULL,
	[INSURER_CODE] [nvarchar](50) NULL,
	[RES_PERCENTAGE] [float] NULL,
	[PRIMARY_INSURER] [nvarchar](1) NULL
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
	[ENTERED_BY_USER] [nvarchar](8) NULL,
	[REASON] [nvarchar](30) NULL,
	[CLAIMANT_LAST] [nvarchar](50) NULL,
	[CLAIMANT_FIRST] [nvarchar](50) NULL,
	[UNIT_ID] [nvarchar](50) NULL
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
	[VIN] [nvarchar](50) NULL,
	[VEHICLE_MAKE] [nvarchar](20) NULL,
	[VEHICLE_YEAR] [int] NULL,
	[HOME_DEPT_EID] [nvarchar](25) NULL,
	[LICENSE_NUMBER] [nvarchar](20) NULL,
	[DAMAGE] [ntext] NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[UNIT_TYPE_CODE] [nvarchar](25) NULL
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
        [UNIT_ID] [int] NULL,
	[VEHICLE_YEAR] [int] NULL,
	[HOME_DEPT_EID] [nvarchar](50) NULL,
	[VEHICLE_MODEL] [nvarchar](50) NULL,
	[VEHICLE_MAKE] [nvarchar](20) NULL,
	[LICENSE_NUMBER] [nvarchar](20) NULL,
	[VIN] [nvarchar](50) NULL,
	[DISPOSAL_DATE] [nvarchar](8) NULL,
	[LEASE_AMOUNT] [float] NULL,
	[LEASE_EXPIRE_DATE] [nvarchar](8) NULL,
	[STATE_ID] [nvarchar](6) NULL,
	[LEASE_FLAG] [nvarchar](1) NULL,
	[LEASE_NUMBER] [nvarchar](50) NULL,
	[LEASE_TERM] [int] NULL,
	[LEASING_CO_EID] [nvarchar](50) NULL,
	[LICENSE_RNWL_DATE] [nvarchar](8) NULL,
	[GROSS_WEIGHT] [int] NULL,
	[UNIT_TYPE_CODE] [nvarchar](25) NULL,
	[ORIGINAL_COST] [float] NULL,
	[PURCHASE_DATE] [nvarchar](8) NULL,
	[DEDUCTIBLE] [float] NULL,
	[LAST_SERVICE_DATE] [nvarchar](8) NULL,
	[NEW_UNIT_ID] [int] NULL
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
	[CLAIM_ID] [nvarchar](20) NULL,
	[ACCIDENT_DATE] [nvarchar](8) NULL
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

