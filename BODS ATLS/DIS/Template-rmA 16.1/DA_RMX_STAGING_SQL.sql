-- ============================================================
--   SCRIPT HEADER (MSSQL RMX_STAGING DATABASE STRUCTURE)
--   Template-rmA 16.1_DIS
--   Module Name: DA2 (All)
--   Description: 	DDL for Data Analytics 2 modules (DIS/DDS)
--   Date:		04/07/2010 01:38:00 PM
-- ============================================================= 
IF EXISTS (SELECT * FROM sys.objects where object_id = OBJECT_ID(N'[dbo].[ADDRESS_X_PHONEINFO]') AND type in (N'U'))
DROP TABLE [dbo].[ADDRESS_X_PHONEINFO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADJUST_DATED_TEXT]') AND type in (N'U'))
DROP TABLE [dbo].[ADJUST_DATED_TEXT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS]') AND type in (N'U'))
DROP TABLE [dbo].[BOND_ABS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE]') AND type in (N'U'))
DROP TABLE [dbo].[CERTIFICATE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PROCESS_LOG]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PROCESS_LOG]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_FUNDS_DEPOSIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_FUNDS_DEPOSIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIMANT]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIMANT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIMANT_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIMANT_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_ADJUSTER]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_ADJUSTER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_ADJ_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_ADJ_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_PRG_NOTE]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_PRG_NOTE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_STATUS_HIST]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_STATUS_HIST]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_LITIGATION]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_LITIGATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CODES]') AND type in (N'U'))
DROP TABLE [dbo].[CODES]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CODES_TEXT]') AND type in (N'U'))
DROP TABLE [dbo].[CODES_TEXT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CODE_FIELD_MAP]') AND type in (N'U'))
DROP TABLE [dbo].[CODE_FIELD_MAP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[COMPL_MGT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[CONTRCT_MGT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DA_STATISTICS]') AND type in (N'U'))
DROP TABLE [dbo].[DA_STATISTICS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDS_OPTIONSET]') AND type in (N'U'))
DROP TABLE [dbo].[DDS_OPTIONSET]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY]') AND type in (N'U'))
DROP TABLE [dbo].[DIRECTORY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISABILITY_CLASS]') AND type in (N'U'))
DROP TABLE [dbo].[DISABILITY_CLASS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISABILITY_PLAN]') AND type in (N'U'))
DROP TABLE [dbo].[DISABILITY_PLAN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIS_CLASS_TD]') AND type in (N'U'))
DROP TABLE [dbo].[DIS_CLASS_TD]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIS_CLASS_WAIT]') AND type in (N'U'))
DROP TABLE [dbo].[DIS_CLASS_WAIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIS_OPTIONSET]') AND type in (N'U'))
DROP TABLE [dbo].[DIS_OPTIONSET]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIS_PLAN_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[DIS_PLAN_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIS_PLAN_X_INSURED]') AND type in (N'U'))
DROP TABLE [dbo].[DIS_PLAN_X_INSURED]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE]') AND type in (N'U'))
DROP TABLE [dbo].[EMPLOYEE]
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_DUPLICATE]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_DUPLICATE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_EXPOSURE]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_EXPOSURE]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND type in (N'U'))
DROP TABLE [dbo].[ERROR_LOG]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_ACTION]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_ACTION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_MEDWATCH]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_MEDWATCH]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_MEDW_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_MEDW_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_MEDW_TEST]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_MEDW_TEST]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_OSHA]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_OSHA]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_OSHA_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_OSHA_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENT_X_OUTCOME]') AND type in (N'U'))
DROP TABLE [dbo].[EVENT_X_OUTCOME]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EV_CONCOM_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EV_CONCOM_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EV_X_CONCOM_PROD]') AND type in (N'U'))
DROP TABLE [dbo].[EV_X_CONCOM_PROD]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FALL_INDICATOR]') AND type in (N'U'))
DROP TABLE [dbo].[FALL_INDICATOR]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FALL_IND_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[FALL_IND_SUPP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_DEPOSIT]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_DEPOSIT]
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_TRANS_SPLIT]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_TRANS_SPLIT]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HAZ_MAT]') AND type in (N'U'))
DROP TABLE [dbo].[HAZ_MAT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MED_STAFF]') AND type in (N'U'))
DROP TABLE [dbo].[MED_STAFF]
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ORG_HIERARCHY]') AND type in (N'U'))
DROP TABLE [dbo].[ORG_HIERARCHY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ACT_TAKEN]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_ACT_TAKEN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_ATTN_PHYS]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_ATTN_PHYS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DIAGNOSIS]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_DIAGNOSIS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_DRG_CODES]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_DRG_CODES]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_PROCEDURE]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_PROCEDURE]
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERSON_INVOLVED]') AND type in (N'U'))
DROP TABLE [dbo].[PERSON_INVOLVED]
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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_BODY_PART]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_BODY_PART]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_DIAGNOSIS]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_DIAGNOSIS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_INJURY]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_INJURY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_TREATMENT]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_TREATMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_WORK_LOSS]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_WORK_LOSS]
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK]') AND type in (N'U'))
DROP TABLE [dbo].[PROJ_TRACK]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[PROP_MGT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESERVE_CURRENT]') AND type in (N'U'))
DROP TABLE [dbo].[RESERVE_CURRENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESERVE_HISTORY]') AND type in (N'U'))
DROP TABLE [dbo].[RESERVE_HISTORY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_CERTS]') AND type in (N'U'))
DROP TABLE [dbo].[STAFF_CERTS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFF_PRIVS]') AND type in (N'U'))
DROP TABLE [dbo].[STAFF_PRIVS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_EMPLOYEE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_EMPLOYEE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_EMP_X_DEPENDENT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_EMP_X_DEPENDENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_EMP_X_VIOLATION]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_EMP_X_VIOLATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_ENTITY]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_ENTITY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_ADDRESS_X_PHONEINFO]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_ADDRESS_X_PHONEINFO]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_ENTITY_EXPOSURE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_ENTITY_EXPOSURE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_FUNDS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_FUNDS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_FUNDS_TRANS_SPLIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_FUNDS_TRANS_SPLIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_MED_STAFF]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_MED_STAFF]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_ORG_HIER]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_ORG_HIER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT_ACT_TAKEN]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT_ACT_TAKEN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT_ATTN_PHYS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT_ATTN_PHYS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT_DIAGNOSIS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT_DIAGNOSIS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT_DRG_CODES]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT_DRG_CODES]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PATIENT_PROCEDURE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PATIENT_PROCEDURE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYSICIAN]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYSICIAN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYS_CERTS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYS_CERTS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYS_EDUCATION]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYS_EDUCATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYS_PREV_HOSP]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYS_PREV_HOSP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYS_PRIVS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYS_PRIVS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PHYS_SUB_SPECIALTY]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PHYS_SUB_SPECIALTY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POLICY]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POLICY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POLICY_X_CVG_TYPE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POLICY_X_CVG_TYPE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POLICY_X_INSURED]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POLICY_X_INSURED]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POLICY_X_INSURER]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POLICY_X_INSURER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_RESERVE_CURRENT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_RESERVE_CURRENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_STAFF_CERTS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_STAFF_CERTS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_STAFF_PRIVS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_STAFF_PRIVS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_UNIT_X_CLAIM]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_UNIT_X_CLAIM]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_VEHICLE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_VEHICLE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_VEHICLE_X_ACC_DATE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_VEHICLE_X_ACC_DATE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_VEHICLE_X_INSPCT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_VEHICLE_X_INSPCT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIQUE_CODE]') AND type in (N'U'))
DROP TABLE [dbo].[UNIQUE_CODE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIT_X_CLAIM]') AND type in (N'U'))
DROP TABLE [dbo].[UNIT_X_CLAIM]
GO



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USER_DEF_RESERVE_MAP]') AND type in (N'U'))
DROP TABLE [dbo].[USER_DEF_RESERVE_MAP]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_ACC_DATE]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE_X_ACC_DATE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VEHICLE_X_INSPCT]') AND type in (N'U'))
DROP TABLE [dbo].[VEHICLE_X_INSPCT]
GO

--vgupta20  --added
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDS_ADJUSTER_TEXT_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[DDS_ADJUSTER_TEXT_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDS_ENHANCED_NOTES_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[DDS_ENHANCED_NOTES_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DEFENDANT]') AND type in (N'U'))
DROP TABLE [dbo].[DEFENDANT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISABILITY_CLASS_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[DISABILITY_CLASS_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISABILITY_PLAN_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[DISABILITY_PLAN_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVENTS_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[EVENTS_INPUT]
GO

--Added by JMericle
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PAYMENTS_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[PAYMENTS_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GLOSSARY]') AND type in (N'U'))
DROP TABLE [dbo].[GLOSSARY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MEDWATCH_INPUT]') AND type in (N'U'))
DROP TABLE [dbo].[MEDWATCH_INPUT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_BODY_PART]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_BODY_PART]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_INJURY]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_INJURY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PATIENT_TREATMENT]') AND type in (N'U'))
DROP TABLE [dbo].[PATIENT_TREATMENT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_HOSPITAL]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_HOSPITAL]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PI_X_PHYSICIAN]') AND type in (N'U'))
DROP TABLE [dbo].[PI_X_PHYSICIAN]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USER_VERIFICATION]') AND type in (N'U'))
DROP TABLE [dbo].[USER_VERIFICATION]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_PROPERTYLOSS]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_PROPERTYLOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_SITELOSS]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_SITELOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_OTHERUNIT]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_OTHERUNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROPERTY_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[PROPERTY_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POINT_UNIT_DATA]') AND type in (N'U'))
DROP TABLE [dbo].[POINT_UNIT_DATA]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DRIVER]') AND type in (N'U'))
DROP TABLE [dbo].[DRIVER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITE_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[SITE_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_SITE_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_SITE_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PROPERTY_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PROPERTY_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_CLAIM_X_OTHERUNIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_CLAIM_X_OTHERUNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_CLAIM_X_SITELOSS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_CLAIM_X_SITELOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_CLAIM_X_PROPERTYLOSS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_CLAIM_X_PROPERTYLOSS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_DRIVER]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_DRIVER]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PERSON_INVOLVED]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PERSON_INVOLVED]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POINT_UNIT_DATA]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POINT_UNIT_DATA]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OTHER_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[OTHER_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLAIM_X_POLICY]') AND type in (N'U'))
DROP TABLE [dbo].[CLAIM_X_POLICY]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY_X_UNIT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_OTHER_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_OTHER_UNIT]
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_X_PAYEE]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_X_PAYEE]
GO


--ipuri User Verification Start
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DA_JOB_ID]') AND type in (N'U'))
DROP TABLE [dbo].[DA_JOB_ID]
GO
--ipuri End


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_FUNDS_X_PAYEE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_FUNDS_X_PAYEE]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MRG_CLAIM_IDS]') AND type in (N'U'))
DROP TABLE [dbo].[MRG_CLAIM_IDS]
GO



SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

IF NOT EXISTS (SELECT name from sys.tables WHERE name = 'ADDRESS_X_PHONEINFO')
BEGIN
	CREATE TABLE [dbo].[ADDRESS_X_PHONEINFO](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ENTITY_ID] [int] NULL,
		[PHONE_ID] [int] NOT NULL,
		[PHONE_CODE] [int] NULL,
		[PHONE_NO] [varchar](30) NULL,
	 CONSTRAINT [ADD_PHONEINFO_PK] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC, 
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ADJUST_DATED_TEXT') 
BEGIN
	CREATE TABLE [dbo].[ADJUST_DATED_TEXT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[TEXT_TYPE_CODE] [int] NULL,
		[ADJ_DTTEXT_ROW_ID] [int] NULL,
		[ADJ_ROW_ID] [int] NULL,
		[DATE_ENTERED] [varchar](8) NULL,
		[ENTERED_BY_USER] [varchar](50) NULL,
		[TIME_ENTERED] [varchar](6) NULL,
		[DATED_TEXT] [text] NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DATED_TEXT_HTMLCOMMENTS] [text] NULL,
	 CONSTRAINT [PK_ADJUST_DATED_TEXT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'BOND_ABS') 
BEGIN
	CREATE TABLE [dbo].[BOND_ABS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BOND_ABS_ID] [int] NULL,
		[BOND_NUM_TEXT] [varchar](20) NULL,
		[BOND_TYPE_TXCD] [varchar](8000) NULL,
		[BOND_LINE_CODE] [int] NULL,
		[EFF_DATE_DATE] [varchar](8) NULL,
		[EXPIR_DATE_DATE] [varchar](8) NULL,
		[BOND_AMT_AMT] [float] NULL,
		[PREMIUM_AMT] [float] NULL,
		[BILL_NAME_TEXT] [varchar](50) NULL,
		[BILL_ADDR_TEXT] [varchar](50) NULL,
		[BILL_CITY_TEXT] [varchar](25) NULL,
		[BILL_ZIP_TEXT] [varchar](15) NULL,
		[BILL_ACCT_TEXT] [varchar](50) NULL,
		[PRINCIPAL_TXCD] [varchar](8000) NULL,
		[STATE_TEXT] [varchar](3) NULL,
		[BILL_STATE_TEXT] [varchar](25) NULL,
		[OBLIGEE_TXCD] [varchar](8000) NULL,
		[BOND_CLASS_CODE] [int] NULL,
		[OLD_BOND_NO_TEXT] [varchar](25) NULL,
		[REQUESTER_TEXT] [varchar](50) NULL,
		[REQ_ADDR_TEXT] [varchar](50) NULL,
		[REQ_CITY_TEXT] [varchar](25) NULL,
		[REQ_STATE_TEXT] [varchar](25) NULL,
		[REQ_ZIP_TEXT] [varchar](15) NULL,
		[REQ_PHONE_TEXT] [varchar](15) NULL,
		[ORDERED_BY_TEXT] [varchar](50) NULL,
		[ORDER_ADDR_TEXT] [varchar](50) NULL,
		[ORDER_CITY_TEXT] [varchar](25) NULL,
		[ORDER_STATE_TEXT] [varchar](15) NULL,
		[ORDER_ZIP_TEXT] [varchar](15) NULL,
		[ORDER_PHONE_TEXT] [varchar](25) NULL,
		[AUTH_BY_TEXT] [varchar](50) NULL,
		[AUTH_ADDR_TEXT] [varchar](50) NULL,
		[AUTH_CITY_TEXT] [varchar](25) NULL,
		[AUTH_STATE_TEXT] [varchar](15) NULL,
		[AUTH_ZIP_TEXT] [varchar](15) NULL,
		[AUTH_PHONE_TEXT] [varchar](15) NULL,
		[DATE_EXEC_DATE] [varchar](8) NULL,
		[PAID_DATE_DATE] [varchar](8) NULL,
		[BOND_STATUS_CODE] [int] NULL,
		[DATE_CANC_DATE] [varchar](8) NULL,
		[BOND_DETAIL_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_BOND_ABS] PRIMARY KEY CLUSTERED 
	( 	
		[DA_ROW_ID] ASC,
		[JOBID] ASC	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CERTIFICATE') 
BEGIN
	CREATE TABLE [dbo].[CERTIFICATE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CERTIFICATE_ID] [int] NULL,
		[JOB_NO_TEXT] [varchar](15) NULL,
		[JOB_DESC_TXCD] [varchar](8000) NULL,
		[AGENCY_NAME_TEXT] [varchar](50) NULL,
		[AGENCY_PHON_TEXT] [varchar](20) NULL,
		[INSURED_NAM_TEXT] [varchar](50) NULL,
		[INSURED_ADD_TEXT] [varchar](50) NULL,
		[INSURED_CIT_TEXT] [varchar](25) NULL,
		[INSURED_ST_TEXT] [varchar](15) NULL,
		[INSURED_ZIP_TEXT] [varchar](15) NULL,
		[INSURED_PH_TEXT] [varchar](20) NULL,
		[GEN_LIAB_TXCD] [varchar](8000) NULL,
		[INS_NAME_TEXT] [varchar](50) NULL,
		[POL_NUMBER_NUM] [float] NULL,
		[EXPIR_DATE_DATE] [varchar](8) NULL,
		[BI_EA_AGG_TEXT] [varchar](25) NULL,
		[PD_EA_AGG_TEXT] [varchar](25) NULL,
		[BI_PD_COMB_NUM] [float] NULL,
		[PI_AGG_NUM] [float] NULL,
		[AUTO_LIAB_TEXT] [varchar](25) NULL,
		[BI_EA_PERS_NUM] [float] NULL,
		[BI_EA_ACC_NUM] [float] NULL,
		[PD_EA_OCC_NUM] [float] NULL,
		[BI_PD_COMB_TEXT] [varchar](15) NULL,
		[EXCESS_LIAB_TXCD] [varchar](8000) NULL,
		[BI_PD_AGG_TEXT] [varchar](15) NULL,
		[WORK_COMP_NUM] [float] NULL,
		[WORK_COMP_TEXT] [varchar](25) NULL,
		[WC_EA_ACC_NUM] [float] NULL,
		[OPER_DESC_TXCD] [varchar](8000) NULL,
		[ISSUE_DT_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_CERTIFICATE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM') 
BEGIN
	CREATE TABLE [dbo].[CLAIM](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
		[EVENT_NUMBER] [varchar](25) NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
		[CLAIM_STATUS_CODE] [int] NULL,
		[LINE_OF_BUS_CODE] [int] NULL,
		[OPEN_FLAG] [smallint] NULL,
		[CLAIM_TYPE_CODE] [int] NULL,
		[COMMENTS] [varchar](8000) NULL,
		[DTTM_CLOSED] [varchar](14) NULL,
		[DATE_OF_CLAIM] [varchar](8) NULL,
		[TIME_OF_CLAIM] [varchar](6) NULL,
		[FILE_NUMBER] [varchar](32) NULL,
		[METHOD_CLOSED_CODE] [int] NULL,
		[PAYMNT_FROZEN_FLAG] [smallint] NULL,
		[PRIMARY_POLICY_ID] [int] NULL,
		[SERVICE_CODE] [int] NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[ACCIDENT_DESC_CODE] [int] NULL,
		[ACCIDENT_TYPE_CODE] [int] NULL,
		[DATE_FDDOT_RPT] [varchar](8) NULL,
		[DATE_STDOT_RPT] [varchar](8) NULL,
		[IN_TRAFFIC_FLAG] [smallint] NULL,
		[POLICE_AGENCY_EID] [int] NULL,
		[PREVENTABLE_FLAG] [smallint] NULL,
		[REPORTABLE_FLAG] [smallint] NULL,
		[ST_DOT_RPT_ID] [varchar](15) NULL,
		[EST_COLLECTION] [float] NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DATE_RPTD_TO_RM] [varchar](8) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DURATION] [int] NULL,
		[FILING_STATE_ID] [int] NULL,
		[SEC_DEPT_EID] [int] NULL,
		[MCO_EID] [int] NULL,
		[RATE_TABLE_ID] [int] NULL,
		[PLAN_ID] [int] NULL,
		[CLASS_ROW_ID] [int] NULL,
		[TAX_FLAGS] [int] NULL,
		[BEN_CALC_PAY_START] [varchar](8) NULL,
		[BEN_CALC_PAY_TO] [varchar](8) NULL,
		[DIS_TYPE_CODE] [int] NULL,
		[BENEFITS_START] [varchar](8) NULL,
		[BENEFITS_THROUGH] [varchar](8) NULL,
		[DISABIL_FROM_DATE] [varchar](8) NULL,
		[DISABIL_TO_DATE] [varchar](8) NULL,
		[EDI_EXTRACTED] [int] NULL,
		[COMP_RATE] [float] NULL,
		[EXPOSURE_ID] [int] NULL,
		[PENSION_AMT] [float] NULL,
		[SS_AMT] [float] NULL,
		[OTHER_AMT] [float] NULL,
		[HTMLCOMMENTS] [varchar](8000) NULL,
		[LSS_CLAIM_IND] [int] NULL,
		[LEAVE_FLAG] [smallint] NULL,
		[OTH_OFF1] [float] NULL,
		[OTH_OFF2] [float] NULL,
		[OTH_OFF3] [float] NULL,
		[POST_TAX_DED1] [float] NULL,
		[POST_TAX_DED2] [float] NULL,
		[STAGING_CLAIM_ID] [int] NULL,		--vgupta20 -added
	 CONSTRAINT [PK_CLAIM] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_ADJ_SUPP') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_ADJ_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ADJ_ROW_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIM_ADJ_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_ADJUSTER') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_ADJUSTER](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ADJ_ROW_ID] [int] NULL,
		[ADJUSTER_EID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[CURRENT_ADJ_FLAG] [smallint] NULL,
	 CONSTRAINT [PK_CLAIM_ADJUSTER] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_PRG_NOTE') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_PRG_NOTE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CL_PROG_NOTE_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
		[ENTERED_BY] [varchar](50) NULL,
		[DATE_ENTERED] [varchar](12) NULL,
		[DATE_CREATED] [varchar](12) NULL,
		[TIME_CREATED] [varchar](12) NULL,
		[NOTE_TYPE_CODE] [int] NULL,
		[USER_TYPE_CODE] [int] NULL,
		[NOTE_MEMO] [text] NULL,
		[NOTE_MEMO_CARETECH] [text] NULL,
		[ENTERED_BY_NAME] [varchar](50) NULL,
	 CONSTRAINT [PK_CLAIM_PRG_NOTE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_STATUS_HIST') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_STATUS_HIST](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CL_STATUS_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[DATE_STATUS_CHGD] [varchar](8) NULL,
		[STATUS_CODE] [int] NULL,
		[STATUS_CHGD_BY] [varchar](50) NULL,
		[REASON] [varchar](8000) NULL,
		[APPROVED_BY] [varchar](50) NULL,
	 CONSTRAINT [PK_CLAIM_STATUS_HIST] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_SUPP') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[TYPEOFREPORT_CODE] [int] NULL,
		[EMPL_ENRL_MCO_CODE] [int] NULL,
		[ABLE_RTW_DATE] [varchar](8) NULL,
		[PERM_LOSS_NUMB] [float] NULL,
		[PERM_LOSS_TEXT] [varchar](50) NULL,
		[DRIVERLOG_CODE] [int] NULL,
		[OTHEMPLOY_CODE] [int] NULL,
		[PREXISTCON_TEXT] [varchar](40) NULL,
		[SPOUEMP_TEXT] [varchar](40) NULL,
	 CONSTRAINT [PK_CLAIM_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_X_LITIGATION') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_X_LITIGATION](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[LIT_TYPE_CODE] [int] NULL,
		[LITIGATION_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[DOCKET_NUMBER] [varchar](22) NULL,
		[SUIT_DATE] [varchar](8) NULL,
		[COURT_DATE] [varchar](8) NULL,
		[JUDGE_EID] [int] NULL,
		[VENUE_STATE_ID] [int] NULL,
		[COUNTY] [varchar](32) NULL,
		[CO_ATTORNEY_EID] [int] NULL,
		[DEMAND_ALLEGATIONS] [varchar](8000) NULL,
		[COMMENTS] [varchar](8000) NULL,
		[LIT_STATUS_CODE] [int] NULL,
		[HTMLCOMMENTS] [varchar](8000) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	 CONSTRAINT [PK_CLAIM_X_LITIGATION] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIMANT') 
BEGIN
	CREATE TABLE [dbo].[CLAIMANT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIMANT_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[CLAIMANT_TYPE_CODE] [int] NULL,
		[ATTORNEY_EID] [int] NULL,
		[PRIMARY_CLMNT_FLAG] [smallint] NULL,
		[INJURY_DESCRIPTION] [varchar](8000) NULL,
		[DAMAGE_DESCRIPTION] [varchar](8000) NULL,
		[SOL_DATE] [varchar](8) NULL,
		[COMMENTS] [varchar](8000) NULL,
		[CLAIM_AMOUNT] [float] NULL,
		[INSURER_EID] [int] NULL,
		[CLAIMANT_NUMBER] [int] NULL,
		[SEC_DEPT_EID] [int] NULL,
		[HTMLCOMMENTS] [varchar](8000) NULL,
	 CONSTRAINT [PK_CLAIMANT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIMANT_SUPP') 
BEGIN
	CREATE TABLE [dbo].[CLAIMANT_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIMANT_ROW_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[CLAIM_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIMANT_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CODE_FIELD_MAP') 
BEGIN
	CREATE TABLE [dbo].[CODE_FIELD_MAP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ROW_ID] [int] NULL,
		[TABLE_NAME] [varchar](50) NULL,
		[FIELD_NAME] [varchar](50) NULL,
		[CODE_TABLE_NAME] [varchar](50) NULL,
		[TABLE_ID] [int] NULL,
	 CONSTRAINT [PK_ROW_ID] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CODES') 
BEGIN
	CREATE TABLE [dbo].[CODES](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[IND_STANDARD_CODE] [int] NULL,
		[LINE_OF_BUS_CODE] [int] NULL,
		[CODE_ID] [int] NULL,
		[TABLE_ID] [int] NULL,
		[SHORT_CODE] [varchar](25) NULL,
		[RELATED_CODE_ID] [int] NULL,
		[DELETED_FLAG] [smallint] NULL,
		[TRIGGER_DATE_FIELD] [varchar](50) NULL,
		[EFF_START_DATE] [varchar](8) NULL,
		[EFF_END_DATE] [varchar](8) NULL,
		[ORG_GROUP_EID] [int] NULL,
	 CONSTRAINT [PK_CODES] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CODES_TEXT') 
BEGIN
	CREATE TABLE [dbo].[CODES_TEXT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CODE_ID] [int] NULL,
		[LANGUAGE_CODE] [int] NULL,
		[SHORT_CODE] [varchar](25) NULL,
		[CODE_DESC] [varchar](50) NULL,
	 CONSTRAINT [PK_CODES_TEXT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'COMPL_MGT') 
BEGIN
	CREATE TABLE [dbo].[COMPL_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COMPL_MGT_ID] [int] NULL,
		[COMP_NO_TEXT] [varchar](25) NULL,
		[DT_RECV_DATE] [varchar](8) NULL,
		[COMP_TYPE_CODE] [int] NULL,
		[COMP_SRC_CODE] [int] NULL,
		[ACT_REQ_TXCD] [varchar](8000) NULL,
		[FILED_AGNST_TEXT] [varchar](50) NULL,
		[REF_TO_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_COMPL_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CONTRCT_MGT') 
BEGIN
	CREATE TABLE [dbo].[CONTRCT_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CONTRCT_MGT_ID] [int] NULL,
		[CONT_TYPE_CODE] [int] NULL,
		[CONTR_CAT_TXCD] [varchar](8000) NULL,
		[SUBJECTOR_TEXT] [varchar](50) NULL,
		[SUBJECTEE_TEXT] [varchar](50) NULL,
		[DETAILS_TXCD] [varchar](8000) NULL,
		[EFF_DATE_DATE] [varchar](8) NULL,
		[EXPIR_DATE_DATE] [varchar](8) NULL,
		[RENEW_DATE_DATE] [varchar](8) NULL,
		[INDEMNITY_TXCD] [varchar](8000) NULL,
		[SUBROGATION_TXCD] [varchar](8000) NULL,
		[TERM_INFO_TEXT] [varchar](50) NULL,
		[CONDITIONS_TXCD] [varchar](8000) NULL,
		[AUTH_SIGN_TXCD] [varchar](8000) NULL,
		[PAYMENTS_TXCD] [varchar](8000) NULL,
		[WARRANTY_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_CONTRCT_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIRECTORY') 
BEGIN
	CREATE TABLE [dbo].[DIRECTORY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DIRECTORY_ID] [int] NULL,
		[LAST_NAME_TEXT] [varchar](255) NULL,
		[FIRST_NAME_TEXT] [varchar](255) NULL,
		[ADDRESS_TEXT] [varchar](100) NULL,
		[CITY_TEXT] [varchar](50) NULL,
		[STATE_TEXT] [varchar](15) NULL,
		[ZIP_CODE_TEXT] [varchar](15) NULL,
		[HOME_PHONE_TEXT] [varchar](25) NULL,
		[WORK_PHONE_TEXT] [varchar](25) NULL,
		[FAX_TEXT] [varchar](25) NULL,
		[TITLE_TEXT] [varchar](25) NULL,
		[ORGANIZ_TEXT] [varchar](50) NULL,
		[CONTACT_TYP_CODE] [int] NULL,
		[CONTACT_STA_CODE] [int] NULL,
		[RECALL_DT_DATE] [varchar](8) NULL,
		[NOTES_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_DIRECTORY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIS_CLASS_TD') 
BEGIN
	CREATE TABLE [dbo].[DIS_CLASS_TD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[TD_ROW_ID] [int] NOT NULL,
		[CLASS_ID] [int] NULL,
		[WAGES_FROM] [float] NULL,
		[WAGES_TO] [float] NULL,
		[WEEKLY_BENEFIT] [float] NULL,
		[SUPP_AMT] [float] NULL,
	 CONSTRAINT [PK_DIS_CLASS_TD] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC,
		[TD_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIS_CLASS_WAIT') 
BEGIN
	CREATE TABLE [dbo].[DIS_CLASS_WAIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[WAIT_ROW_ID] [int] NOT NULL,
		[CLASS_ID] [int] NULL,
		[DIS_TYPE_CODE] [int] NULL,
		[DIS_WAIT_PRD] [int] NULL,
		[DIS_CLNDR_WRK_CODE] [int] NULL,
		[DIS_PRD_TYPE] [int] NULL,
	 CONSTRAINT [PK_DIS_CLASS_WAIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC,
		[WAIT_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIS_PLAN_SUPP') 
BEGIN
	CREATE TABLE [dbo].[DIS_PLAN_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PLAN_ID] [int] NULL,
	 CONSTRAINT [PK_DIS_PLAN_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIS_PLAN_X_INSURED') 
BEGIN
	CREATE TABLE [dbo].[DIS_PLAN_X_INSURED](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PLAN_ID] [int] NULL,
		[INSURED_EID] [int] NULL,
	 CONSTRAINT [PK_DIS_PLAN_X_INSURED] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DISABILITY_CLASS') 
BEGIN
	CREATE TABLE [dbo].[DISABILITY_CLASS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLASS_ROW_ID] [int] NULL,
		[PLAN_ID] [int] NULL,
		[CLASS_NAME] [varchar](20) NULL,
		[CLASS_DESC] [varchar](50) NULL,
		[ELIG_BENE_PRD] [int] NULL,
		[BENE_PRD_TYPE] [int] NULL,
		[BENE_FROM_DT_TYPE] [int] NULL,
		[DIS_WAIT_PRD] [int] NULL,
		[DIS_CLNDR_WRK_CODE] [int] NULL,
		[DIS_PRD_TYPE] [int] NULL,
		[DIS_MAX_PRD] [int] NULL,
		[DIS_MAX_PRD_TYPE] [int] NULL,
		[FROM_DIS_PRD_TYPE] [int] NULL,
		[ALLOW_EXT] [int] NULL,
		[EXTEND_PRD] [int] NULL,
		[EXTEND_PRD_TYPE] [int] NULL,
		[MAX_TOT_DIS_PRD] [int] NULL,
		[MAX_TOT_PRD_TYPE] [int] NULL,
		[ACTUAL_WORK_WEEK] [smallint] NULL,
		[DAY7_WORK_WEEK] [smallint] NULL,
		[DAY5_WORK_WEEK] [smallint] NULL,
		[OTHER_WORK_WEEK] [smallint] NULL,
		[OTHER_DAYS] [int] NULL,
		[BENE_PRCTG_FLAG] [smallint] NULL,
		[BENE_PER_AMT] [float] NULL,
		[BENE_FLAT_AMT_FLAG] [smallint] NULL,
		[BENE_FLAT_AMT] [float] NULL,
		[BENE_TD_FLAG] [smallint] NULL,
		[BENE_BASED_CODE] [int] NULL,
		[WITHHOLD_FED_ITAX] [smallint] NULL,
		[WITHHOLD_FICA] [smallint] NULL,
		[WEEKLY_BENE_CAP] [float] NULL,
		[MAX_BEN_PER_CLAIM] [float] NULL,
		[MAX_BEN_PER_CAL_YR] [float] NULL,
		[WAGE_FOR_DIS_PRD] [float] NULL,
		[WAGE_FOR_CAL_YR] [float] NULL,
		[TAXABLE_PERCENT] [float] NULL,
		[WITHHOLD_MEDICARE] [smallint] NULL,
		[WITHHOLD_STATE] [smallint] NULL,
		[USE_VOUCHERS] [smallint] NULL,
		[DAY30_WORK_MONTH] [smallint] NULL,
		[ACTUAL_MONTH] [smallint] NULL,
		[UPPER_AGE_LIMIT] [int] NULL,
		[LOWER_AGE_LIMIT] [int] NULL,
		[SUPP_PERCENT] [float] NULL,
		[SUPP_FLAT_AMT] [float] NULL,
		[SUPP_BANK_ACC_ID] [int] NULL,
		[SUPP_SUB_ACC_ID] [int] NULL,
		[SUPP_TR_TYPE_CODE] [int] NULL,
		[SUPP_SEP_PAY_FLAG] [smallint] NULL,
		[PENSION_AMT] [float] NULL,
		[SS_AMT] [float] NULL,
		[OTHER_AMT] [float] NULL,
		[PRORATE_OFF_FLAG] [smallint] NULL,
		[FULLPAY_ONLY_FLAG] [smallint] NULL,
		[OTH_OFF1] [float] NULL,
		[OTH_OFF2] [float] NULL,
		[OTH_OFF3] [float] NULL,
		[POST_TAX_DED1] [float] NULL,
		[POST_TAX_DED2] [float] NULL,
	 CONSTRAINT [PK_DISABILITY_CLASS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DISABILITY_PLAN') 
BEGIN
	CREATE TABLE [dbo].[DISABILITY_PLAN](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PLAN_ID] [int] NULL,
		[PLAN_NUMBER] [varchar](20) NULL,
		[PLAN_NAME] [varchar](20) NULL,
		[PLAN_DESCRIPTION] [varchar](50) NULL,
		[PLAN_STATUS_CODE] [int] NULL,
		[PREMIUM] [float] NULL,
		[BANK_ACC_ID] [int] NULL,
		[EFFECTIVE_DATE] [varchar](8) NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[ISSUE_DATE] [varchar](8) NULL,
		[REVIEW_DATE] [varchar](8) NULL,
		[RENEWAL_DATE] [varchar](8) NULL,
		[CANCEL_DATE] [varchar](8) NULL,
		[PREF_DAY_CODE] [int] NULL,
		[PREF_PAY_SCH_CODE] [int] NULL,
		[COMMENTS] [varchar](8000) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[START_PAY_PERIOD] [varchar](8) NULL,
		[PRINT_BEFORE_END] [smallint] NULL,
		[SUB_ACC_ROW_ID] [int] NULL,
		[PREF_DAY_OF_M_CODE] [int] NULL,
		[HTMLCOMMENTS] [varchar](8000) NULL,
		[TYPE_OF_MONTH_PAY] [int] NULL,
	 CONSTRAINT [PK_DISABILITY_PLAN] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EMP_X_DEPENDENT') 
BEGIN
	CREATE TABLE [dbo].[EMP_X_DEPENDENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EMP_DEP_ROW_ID] [int] NULL,
		[EMPLOYEE_EID] [int] NULL,
		[DEPENDENT_EID] [int] NULL,
		[HEALTH_PLAN_FLAG] [smallint] NULL,
		[RELATION_CODE] [int] NULL,
		[DEPENDENT_ROW_ID] [int] NULL,
	 CONSTRAINT [PK_EMP_X_DEPENDENT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EMP_X_VIOLATION') 
BEGIN
	CREATE TABLE [dbo].[EMP_X_VIOLATION](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[VIOLATION_ID] [int] NULL,
		[EMPLOYEE_EID] [int] NULL,
		[VIOLATION_CODE] [int] NULL,
		[VIOLATION_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_EMP_X_VIOLATION] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EMPLOYEE') 
BEGIN
	CREATE TABLE [dbo].[EMPLOYEE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COUNTY_OF_RESIDNC] [varchar](50) NULL,
		[DRIVLIC_STATE] [int] NULL,
		[INSURABLE_FLAG] [smallint] NULL,
		[LAST_VERIFIED_DATE] [varchar](8) NULL,
		[NUM_OF_VIOLATIONS] [int] NULL,
		[TERM_DATE] [varchar](8) NULL,
		[WORK_PERMIT_DATE] [varchar](8) NULL,
		[WORK_PERMIT_NUMBER] [varchar](50) NULL,
		[EMPLOYEE_EID] [int] NULL,
		[ACTIVE_FLAG] [smallint] NULL,
		[EMPLOYEE_NUMBER] [varchar](20) NULL,
		[MARITAL_STAT_CODE] [int] NULL,
		[DATE_HIRED] [varchar](8) NULL,
		[POSITION_CODE] [int] NULL,
		[DEPT_ASSIGNED_EID] [int] NULL,
		[SUPERVISOR_EID] [int] NULL,
		[EXEMPT_STATUS_FLAG] [smallint] NULL,
		[NO_OF_EXEMPTIONS] [int] NULL,
		[FULL_TIME_FLAG] [smallint] NULL,
		[HOURLY_RATE] [float] NULL,
		[WEEKLY_HOURS] [float] NULL,
		[WEEKLY_RATE] [float] NULL,
		[WORK_SUN_FLAG] [smallint] NULL,
		[WORK_MON_FLAG] [smallint] NULL,
		[WORK_TUE_FLAG] [smallint] NULL,
		[WORK_WED_FLAG] [smallint] NULL,
		[WORK_THU_FLAG] [smallint] NULL,
		[WORK_FRI_FLAG] [smallint] NULL,
		[WORK_SAT_FLAG] [smallint] NULL,
		[PAY_TYPE_CODE] [int] NULL,
		[PAY_AMOUNT] [float] NULL,
		[DRIVERS_LIC_NO] [varchar](20) NULL,
		[DRIVERSLICTYPECODE] [int] NULL,
		[DATE_DRIVERSLICEXP] [varchar](8) NULL,
		[DRIVLIC_RSTRCTCODE] [int] NULL,
		[NCCI_CLASS_CODE] [int] NULL,
		[DATE_OF_DEATH] [varchar](8) NULL,
		[SEC_DEPT_EID] [int] NULL,
		[JOB_CLASS_CODE] [int] NULL,
		[MONTHLY_RATE] [float] NULL,
		[ELIG_DIS_BEN_FLAG] [smallint] NULL,
		[DIS_OPTION_CODE] [int] NULL,
		[STAGING_ID] [int] NULL,			
	 CONSTRAINT [PK_EMPLOYEE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ENTITY') 
BEGIN
	CREATE TABLE [dbo].[ENTITY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BUSINESS_TYPE_CODE] [int] NULL,
		[COUNTY] [varchar](30) NULL,
		[NATURE_OF_BUSINESS] [varchar](50) NULL,
		[SIC_CODE] [int] NULL,
		[SIC_CODE_DESC] [varchar](150) NULL,
		[WC_FILING_NUMBER] [varchar](30) NULL,
		[ENTITY_ID] [int] NULL,
		[ENTITY_TABLE_ID] [int] NULL,
		[LAST_NAME] [varchar](255) NULL,
		[LAST_NAME_SOUNDEX] [varchar](8) NULL,
		[FIRST_NAME] [varchar](255) NULL,
		[ALSO_KNOWN_AS] [varchar](50) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[COST_CENTER_CODE] [int] NULL,
		[ADDRESS_TYPE_CODE] [int] NULL,			-- kkaur25-14.2enhancements
		[ADDR1] [varchar](100) NULL,
		[ADDR2] [varchar](100) NULL,
		[ADDR3] [varchar](100) NULL,
		[ADDR4] [varchar](100) NULL,
		[CITY] [varchar](50) NULL,
		[COUNTRY_CODE] [int] NULL,
		[STATE_ID] [int] NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[PARENT_EID] [int] NULL,
		[TAX_ID] [varchar](20) NULL,
		[CONTACT] [varchar](50) NULL,
		[COMMENTS]  [varchar](4000) NULL,
		[EMAIL_TYPE_CODE] [int] NULL,
		[EMAIL_ADDRESS] [varchar](100) NULL,
		[SEX_CODE] [int] NULL,
		[BIRTH_DATE] [varchar](8) NULL,
		[PHONE1] [varchar](30) NULL,
		[PHONE2] [varchar](30) NULL,
		[FAX_NUMBER] [varchar](30) NULL,
		[CONTACT_NAME] [varchar](255) NULL,           -- start kkaur25-14.2enhancements
		[CONTACT_TITLE] [varchar](50) NULL,
		[CONTACT_INITIALS] [varchar](10) NULL,
		[CONTACT_ADDR1] [varchar](100) NULL,
		[CONTACT_ADDR2] [varchar](100) NULL,
		[CONTACT_ADDR3] [varchar](100) NULL,
		[CONTACT_ADDR4] [varchar](100) NULL,
		[CONTACT_CITY] [varchar](50) NULL,
		[CONTACT_ZIP_CODE] [varchar](10) NULL,
		[CONTACT_PHONE] [varchar](30) NULL,
		[CONTACT_FAX_NUMBER] [varchar](30) NULL,
		[CONTACT_EMAIL_ADDRESS] [varchar](25) NULL,
		[CONTACT_TYPE_CODE] [int] NULL,
		[CONTACT_STATE_ID] [int] NULL,              --end kkaur25-14.2enhancements
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DELETED_FLAG] [smallint] NULL,
		[SEC_DEPT_EID] [int] NULL,
		[TRIGGER_DATE_FIELD] [varchar](50) NULL,
		[EFF_START_DATE] [varchar](8) NULL,
		[EFF_END_DATE] [varchar](8) NULL,
		[PARENT_1099_EID] [int] NULL,
		[REPORT_1099_FLAG] [smallint] NULL,
		[MIDDLE_NAME] [varchar](255) NULL,
		[TITLE] [varchar](50) NULL,
		[NAICS_CODE] [int] NULL,
		[RM_USER_ID] [int] NULL,
		[FREEZE_PAYMENTS] [int] NULL,
		[ORGANIZATION_TYPE] [int] NULL,
		[NPI_NUMBER] [varchar](10) NULL,
		[HTMLCOMMENTS] [varchar](4000) NULL,
		[MMSEA_TIN_EDT_FLAG] [smallint] NULL,
		[AUTO_DISCOUNT] [float] NULL,
		[DISCOUNT_FLAG] [smallint] NULL,
		[FROI_ACORD_PASSWORD] [varchar](15) NULL,
		[MMSEA_REPRTER_TEXT] [varchar](9) NULL,
		[MMSEA_OFE_STE_TEXT] [varchar](9) NULL,
		[TIME_ZONE_TRACKING] [smallint] NULL,
		[TIME_ZONE_CODE] [int] NULL,
		[CONF_FLAG] [smallint] NULL,
        	[CONF_EVENT_ID] [int] NULL,
		[ENTITY_APPROVAL_STATUS] [int] NULL,
		[ENTITY_REJECT_COMMENTS]  [varchar](4000) NULL,
		[ENTITY_REJECT_HTMLCOMMENTS] [varchar](4000) NULL,
		[OVERRIDE_OFAC_CHECK] [smallint] NULL,
		[ORG_CURR_CODE] [int] NULL,
		[HOSPITAL_AMT] [float] NULL,
		[HOSPITAL_LINES] [int] NULL,
		[MEDICAL_AMT] [float] NULL,
		[MEDICAL_LINES] [int] NULL,
		[REFERENCE_NUMBER] [varchar](50) NULL,
		[CLIENT_SEQ_NUM] [varchar](30) NULL, 
		[ADDRESS_SEQ_NUM] [int] NULL,
		[PREFIX] [int] NULL,
		[SUFFIX_COMMON] [int] NULL,
		[SUFFIX_LEGAL] [varchar](50) NULL,
		[ID_TYPE] [int] NULL,
		[LEGAL_NAME] [varchar](255) NULL,
		[EFFECTIVE_DATE] [varchar](10) NULL,
		[EXPIRATION_DATE] [varchar](10) NULL,
		[NAME_TYPE] [int] NULL,
		[ASSIGNADJ_EID] [int] NULL,
		[STAGING_ID] [int] NULL,
		[ENTITY_ID_TYPE] [int] NULL, 			-- start kkaur25-14.2enhancements
		[ENTITY_ID_NUMBER] [varchar](50) NULL,
		[ENT_EFFECTIVE_DATE] [varchar](8) NULL,
		[ENT_EXPIRATION_DATE] [varchar](8) NULL,	-- end kkaur25-14.2enhancements
		[ENT_CATEGORY][int] NULL,
		[ENT_CATEGORY_PRNT][int] NULL,
	 CONSTRAINT [PK_ENTITY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ENTITY_DUPLICATE') 
BEGIN
	CREATE TABLE [dbo].[ENTITY_DUPLICATE](
		[DUPLICATE_FLAG][int] NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ENTITY_ID] [int] NULL,
		[ENTITY_TABLE_ID] [int] NULL,
		[LAST_NAME] [varchar](255) NULL,
		[FIRST_NAME] [varchar](255) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[TAX_ID] [varchar](20) NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_ENTITY_DUPLICATE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ENTITY_EXPOSURE') 
BEGIN
	CREATE TABLE [dbo].[ENTITY_EXPOSURE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EXPOSURE_ROW_ID] [int] NULL,
		[ENTITY_ID] [int] NULL,
		[START_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
		[NO_OF_EMPLOYEES] [int] NULL,
		[NO_OF_WORK_HOURS] [int] NULL,
		[PAYROLL_AMOUNT] [float] NULL,
		[ASSET_VALUE] [float] NULL,
		[SQUARE_FOOTAGE] [int] NULL,
		[VEHICLE_COUNT] [int] NULL,
		[TOTAL_REVENUE] [float] NULL,
		[OTHER_BASE] [float] NULL,
		[RISK_MGMT_OVERHEAD] [float] NULL,
		[USER_GENERATD_FLAG] [smallint] NULL,
	 CONSTRAINT [PK_ENTITY_EXPOSURE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END







/* IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ENTITY_X_ADDRESSES')
BEGIN
	CREATE TABLE [dbo].[ENTITY_X_ADDRESSES](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ENTITY_ID] [int] NULL,
		[ADDRESS_ID] [int] NOT NULL,
		[ADDR1] [varchar](100) NULL,
		[ADDR2] [varchar](100) NULL,
		[CITY] [varchar](50) NULL,
		[COUNTY] [varchar](30) NULL,
		[COUNTRY_CODE] [int] NULL,
		[STATE_ID] [int] NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[EMAIL_ADDRESS] [varchar](100) NULL,
		[FAX_NUMBER] [varchar](30) NULL,
		[PRIMARY_ADD_FLAG] [smallint] NULL,
		[EFFECTIVE_DATE] [varchar](10) NULL,
		[EXPIRATION_DATE] [varchar](10) NULL,
		[ADDRESS_SEQ_NUM] [int] NULL,				--kkaur25 14.2 enhancement
		[ADDRESS_TYPE_CODE] [int] NULL,				--kkaur25 14.2 enhancement
	 CONSTRAINT [ENT_ADDINFO_PK] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC, 
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END */


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EV_CONCOM_SUPP') 
BEGIN
	CREATE TABLE [dbo].[EV_CONCOM_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EV_CONCOM_ROW_ID] [int] NULL,
	 CONSTRAINT [PK_EV_CONCOM_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EV_X_CONCOM_PROD') 
BEGIN
	CREATE TABLE [dbo].[EV_X_CONCOM_PROD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EV_CONCOM_ROW_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
		[CONCOM_PRODUCT_ID] [int] NULL,
		[FROM_DATE] [varchar](8) NULL,
		[TO_DATE] [varchar](8) NULL,
		[CONCOM_PRODUCT] [varchar](40) NULL,
	 CONSTRAINT [PK_EV_X_CONCOM_PROD] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT') 
BEGIN
	CREATE TABLE [dbo].[EVENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COUNTY_OF_INJURY] [varchar](50) NULL,
		[EVENT_ID] [int] NULL,
		[EVENT_NUMBER] [varchar](25) NULL,
		[EVENT_TYPE_CODE] [int] NULL,
		[EVENT_STATUS_CODE] [int] NULL,
		[EVENT_IND_CODE] [int] NULL,
		[EVENT_DESCRIPTION] [varchar](8000) NULL,
		[BRIEF_DESC] [varchar](250) NULL,
		[DEPT_EID] [int] NULL,
		[DEPT_INVOLVED_EID] [int] NULL,
		[ADDR1] [varchar](100) NULL,
		[ADDR2] [varchar](100) NULL,
		[ADDR3] [varchar](100) NULL,
		[ADDR4] [varchar](100) NULL,
		[CITY] [varchar](50) NULL,
		[STATE_ID] [int] NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[COUNTRY_CODE] [int] NULL,
		[LOCATION_AREA_DESC] [varchar](8000) NULL,
		[PRIMARY_LOC_CODE] [int] NULL,
		[LOCATION_TYPE_CODE] [int] NULL,
		[ON_PREMISE_FLAG] [smallint] NULL,
		[NO_OF_INJURIES] [int] NULL,
		[NO_OF_FATALITIES] [int] NULL,
		[CAUSE_CODE] [int] NULL,
		[DATE_OF_EVENT] [varchar](8) NULL,
		[TIME_OF_EVENT] [varchar](6) NULL,
		[DATE_REPORTED] [varchar](8) NULL,
		[TIME_REPORTED] [varchar](6) NULL,
		[RPTD_BY_EID] [int] NULL,
		[DATE_RPTD_TO_RM] [varchar](8) NULL,
		[DATE_TO_FOLLOW_UP] [varchar](8) NULL,
		[COMMENTS] [varchar](8000) NULL,
		[ACCOUNT_ID] [int] NULL,
		[DATE_PHYS_ADVISED] [varchar](8) NULL,
		[TIME_PHYS_ADVISED] [varchar](6) NULL,
		[TREATMENT_GIVEN] [smallint] NULL,
		[RELEASE_SIGNED] [smallint] NULL,
		[DEPT_HEAD_ADVISED] [smallint] NULL,
		[PHYS_NOTES] [varchar](8000) NULL,
		[DATE_CARRIER_NOTIF] [varchar](8) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[SEC_DEPT_EID] [int] NULL,
		[INJURY_FROM_DATE] [varchar](8) NULL,
		[INJURY_TO_DATE] [varchar](8) NULL,
		[HTMLCOMMENTS] [varchar](8000) NULL,
		[EVENT_DESCRIPTION_HTMLCOMMENTS] [varchar](8000) NULL,
		[INT_REQ_FLAG] [smallint] NULL,
		[LOCATION_AREA_DESC_HTMLCOMMENTS] [varchar](8000) NULL, --vgupta20 --added
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_EVENT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_SUPP') 
BEGIN
	CREATE TABLE [dbo].[EVENT_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[RESOLUVALU_AMT] [float] NULL,
	 CONSTRAINT [PK_EVENT_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_ACTION') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_ACTION](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[ACTION_CODE] [int] NULL,
	 CONSTRAINT [PK_EVENT_X_ACTION] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_MEDW_SUPP') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_MEDW_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[PATINT_CODE_A_TEXT] [varchar](16) NULL,
		[PATINT_CODE_B_TEXT] [varchar](16) NULL,
		[PATINT_CODE_C_TEXT] [varchar](16) NULL,
		[DEVICE_CODE_A_TEXT] [varchar](16) NULL,
		[DEVICE_CODE_B_TEXT] [varchar](16) NULL,
		[DEVICE_CODE_C_TEXT] [varchar](16) NULL,
		[OTH_OUTCOME_CODE] [int] NULL,
		[SING_USE_CODE] [int] NULL,
		[REPRO_NAME_ADDR_TEXT] [varchar](50) NULL,
	 CONSTRAINT [PK_EVENT_X_MEDW_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_MEDW_TEST') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_MEDW_TEST](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EV_MW_TEST_ROW_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
		[LAB_TEST] [varchar](50) NULL,
		[RESULT] [varchar](50) NULL,
		[TEST_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_EVENT_X_MEDW_TEST] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_MEDWATCH') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_MEDWATCH](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[UNIT_CODE] [int] NULL,
		[DATE_RPTD_TO_FDA] [varchar](8) NULL,
		[DATE_RPTD_TO_MFG] [varchar](8) NULL,
		[RPTD_BY_EID] [int] NULL,
		[RPTD_BY_PRO_FLAG] [smallint] NULL,
		[RPTD_BY_POS_CODE] [int] NULL,
		[RELEVANT_HISTORY] [varchar](8000) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[LAST_REPORT_DATE] [varchar](8) NULL,
		[REPORT_YEAR] [int] NULL,
		[REPORT_SERIAL_NO] [int] NULL,
		[ADVERSE_EVENT_FLAG] [smallint] NULL,
		[PRODUCT_PROB_FLAG] [smallint] NULL,
		[LIFE_THREAT_FLAG] [smallint] NULL,
		[HOSPITALIZ_FLAG] [smallint] NULL,
		[DISABILITY_FLAG] [smallint] NULL,
		[CONGENITAL_FLAG] [smallint] NULL,
		[REQD_INTERV_FLAG] [smallint] NULL,
		[FOLLOW_UP_COUNT] [int] NULL,
		[RPT_MANDATORY] [smallint] NULL,
		[MED_TYPE] [int] NULL,
		[MED_NAME] [varchar](25) NULL,
		[DOSE] [varchar](25) NULL,
		[FREQUENCY] [varchar](25) NULL,
		[ROUTE] [varchar](25) NULL,
		[THERAPY_FROM_DATE] [varchar](8) NULL,
		[THERAPY_TO_DATE] [varchar](8) NULL,
		[DURATION] [int] NULL,
		[LOT_NUMBER] [varchar](15) NULL,
		[NDC_NUMBER] [int] NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[MW_EVENT_ABATED] [smallint] NULL,
		[MW_EVNT_REAPPEARED] [smallint] NULL,
		[DIAGNOSIS_TEST] [varchar](25) NULL,
		[BRAND_NAME] [varchar](25) NULL,
		[EQUIP_TYPE_CODE] [int] NULL,
		[MANUFACTURER_EID] [int] NULL,
		[MODEL_NUMBER] [varchar](15) NULL,
		[CATALOG_NUMBER] [varchar](15) NULL,
		[SERIAL_NUMBER] [varchar](15) NULL,
		[OTHER_NUMBER] [varchar](15) NULL,
		[DEVICE_OPER_CODE] [int] NULL,
		[IMPLANT_DATE] [varchar](8) NULL,
		[EXPLANT_DATE] [varchar](8) NULL,
		[AGE_OF_DEVICE] [varchar](12) NULL,
		[DEV_AVAIL_FOR_EVAL] [smallint] NULL,
		[DEVICE_RETURN_DATE] [varchar](8) NULL,
		[EQ_LOT_NUMBER] [varchar](15) NULL,
		[EQ_EXPIRATION_DATE] [varchar](8) NULL,
		[OTHERS_FLAG] [smallint] NULL,
	 CONSTRAINT [PK_EVENT_X_MEDWATCH] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_OSHA') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_OSHA](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ACTIVITY_WHEN_INJ] [varchar](8000) NULL,
		[EVENT_ID] [int] NULL,
		[HOW_ACC_OCCURRED] [varchar](8000) NULL,
		[NO_RULES_FLAG] [smallint] NULL,
		[OBJ_SUBST_THAT_INJ] [varchar](8000) NULL,
		[RECORDABLE_FLAG] [smallint] NULL,
		[SAFEG_NOTUSED_FLAG] [smallint] NULL,
		[SAFEGUARD_FLAG] [smallint] NULL,
		[PRIVACY_CASE_FLAG] [int] NULL,
		[SHARPS_OBJECT] [int] NULL,
		[SHARPS_BRAND_MAKE] [int] NULL,
		[SAFEG_NOTUSED] [int] NULL,
		[SAFEG_PROVIDED] [int] NULL,
		[RULES_NOT_FOLLOWED] [int] NULL,
		[OSHA_ESTAB_EID] [int] NULL,
	 CONSTRAINT [PK_EVENT_X_OSHA] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_OSHA_SUPP') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_OSHA_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
	 CONSTRAINT [PK_EVENT_X_OSHA_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENT_X_OUTCOME') 
BEGIN
	CREATE TABLE [dbo].[EVENT_X_OUTCOME](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[OUTCOME_CODE] [int] NULL,
	 CONSTRAINT [PK_EVENT_X_OUTCOME] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FALL_IND_SUPP') 
BEGIN
	CREATE TABLE [dbo].[FALL_IND_SUPP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[HIST_FALL_CODE] [int] NULL,
	 CONSTRAINT [PK_FALL_IND_SUPP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FALL_INDICATOR') 
BEGIN
	CREATE TABLE [dbo].[FALL_INDICATOR](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EVENT_ID] [int] NULL,
		[COND_PRIOR_CODE] [int] NULL,
		[RAIL_POSITION_CODE] [int] NULL,
		[RESTRAINT_CODE] [int] NULL,
		[BED_POSITION_CODE] [int] NULL,
		[CALL_LIGHT_FLAG] [smallint] NULL,
		[CALL_LIGHT_CODE] [int] NULL,
	 CONSTRAINT [PK_FALL_INDICATOR] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FUNDS') 
BEGIN
	CREATE TABLE [dbo].[FUNDS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[AUTO_CHECK_DETAIL] [varchar](30) NULL,
	[ROLLUP_ID] [int] NULL,
	[VOID_DATE] [varchar](8) NULL,
	[ADDR1] [varchar](100) NULL,
	[ADDR2] [varchar](100) NULL,
	[ADDR3] [varchar](100) NULL,
	[ADDR4] [varchar](100) NULL,
	[AUTO_CHECK_FLAG] [smallint] NULL,
	[CITY] [varchar](50) NULL,
	[CLAIMANT_EID] [int] NULL,
	[COUNTRY_CODE] [int] NULL,
	[FIRST_NAME] [varchar](255) NULL,
	[LAST_NAME] [varchar](255) NULL,
	[PRECHECK_FLAG] [smallint] NULL,
	[STATE_ID] [int] NULL,
	[UNIT_ID] [int] NULL,
	[ZIP_CODE] [varchar](10) NULL,
	[TRANS_ID] [int]  NULL,
	[CLAIM_ID] [int] NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[CTL_NUMBER] [varchar](25) NULL,
	[VOID_FLAG] [smallint] NULL,
	[DATE_OF_CHECK] [varchar](8) NULL,
	[CHECK_MEMO] [varchar](255) NULL,
	[TRANS_NUMBER] [bigint] NULL,
	[TRANS_DATE] [varchar](8) NULL,
	[PAYEE_EID] [int] NULL,
	[PAYEE_TYPE_CODE] [int] NULL,
	[ACCOUNT_ID] [int] NULL,
	[AMOUNT] [float] NULL,
	[STATUS_CODE] [int] NULL,
	[FILED_1099_FLAG] [smallint] NULL,
	[CLEARED_FLAG] [smallint] NULL,
	[PAYMENT_FLAG] [smallint] NULL,
	[COLLECTION_FLAG] [smallint] NULL,
	[COMMENTS] [varchar](4000) NULL,
	[NOTES] [varchar](2000) NULL,
	[CRC] [int] NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	[DTTM_RCD_ADDED] [varchar](14) NULL,
	[UPDATED_BY_USER] [varchar](50) NULL,
	[ADDED_BY_USER] [varchar](50) NULL,
	[BATCH_NUMBER] [int] NULL,
	[SEC_DEPT_EID] [int] NULL,
	[ENCLOSURE_FLAG] [smallint] NULL,
	[APPROVE_USER] [varchar](8) NULL,
	[DTTM_APPROVAL] [varchar](14) NULL,
	[SUB_ACCOUNT_ID] [int] NULL,
	[SETTLEMENT_FLAG] [smallint] NULL,
	[APPROVER_ID] [int] NULL,
	[VOUCHER_FLAG] [smallint] NULL,
	[WEEKS_PAID_CODE] [int] NULL,
	[NUM_OF_PAID_DAYS] [int] NULL,
	[TAX_PAYMENT_FLAG] [smallint] NULL,
	[RESUBMIT_EDI] [smallint] NULL,
	[SUPP_PAYMENT_FLAG] [smallint] NULL,
	[HTMLCOMMENTS] [Varchar] (4000) NULL,
	[REISSUE_FLAG] [smallint] NULL,
	[REISSUE_BY] [varchar](25) NULL,
	[REISSUE_DATE] [varchar](8) NULL,
	[REISSUE_PARENT_ID] [int] NULL,
	[NOTES_HTMLCOMMENTS] [Varchar] (4000) NULL,
	[REISSUE_REASON_CODE] [int] NULL,
	[MIDDLE_NAME] [varchar](255) NULL,
	[REASON] [varchar](255) NULL,
	[CONF_FLAG] [smallint] NULL,
	[CONF_EVENT_ID] [int] NULL,
	[VOID_REASON] [varchar](4000) NULL,
	[VOID_REASON_HTMLCOMMENTS] [varchar](4000) NULL,
	[DORMANCY_STATUS] [int] NULL,
	[WITHHOLDING_PMT_FLAG] [smallint] NULL,
	[WITHHOLDING_TYPE] [int] NULL,
	[WITHHOLDING_CHILD_FLAG] [smallint] NULL,
	[PARENT_TRANS_ID] [int] NULL,
	[COMBINED_PAY_FLAG] [smallint] NULL,
	[PAY_TO_THE_ORDER_OF] [varchar](4000) NULL,
	[EFT_FLAG] [smallint] NULL,
	[EFT_FILE_NAME] [varchar](255) NULL,
	[EFT_DATE] [varchar](8) NULL,
	[PMT_CURRENCY_CODE] [int]  NULL,
	[PMT_CURRENCY_AMOUNT] [float] NULL,
	[PMT_TO_BASE_CUR_RATE] [float] NULL,
	[CLAIM_CURRENCY_CODE] [int] NULL,
	[CLAIM_CURRENCY_AMOUNT] [float] NULL,
	[PMT_TO_CLAIM_CUR_RATE] [float] NULL,
	[BASE_TO_PMT_CUR_RATE] [float] NULL,
	[BASE_TO_CLAIM_CUR_RATE] [float] NULL,
	[FINAL_PAYMENT_FLAG] [smallint] NULL,
	[BILL_TYPE] [int] NULL,
	[MANUAL_CHECK] [int] NULL,
	[CHECK_MEMO_HTMCOMMENTS] [varchar](4000) NULL,
	[CHECK_MEMO_HTMLCOMMENTS] [varchar](4000) NULL,
	[RES_SUPP_PAYMENT_FLAG] [smallint] NULL,
	[IAIABC_ADJUST_DATE] [varchar](8) NULL,
	[IAIABC_CREDIT_DATE] [varchar](8) NULL,
	[IAIABC_REDIST_DATE] [varchar](8) NULL,
	[EDI_BATCH_NUMBER] [int] NULL,
	[EDI_MED_EXTRACTED] [int] NULL,
	[OFFSET_FLAG] [smallint] NULL,
	[STOP_PAY_FLAG][int] NULL,
	[STOP_PAY_DATE][varchar](8) NULL,
	[PS_EXTRACTED] [varchar](14) NULL,
	[DSTRBN_TYPE_CODE] [int] NULL,
	[MAIL_TO_EID] [int] NULL,
	[MAIL_TO_ADDRESS_ID][int] NULL,
--ADDED BY JMERICLE
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_FUNDS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FUNDS_DEPOSIT') 
BEGIN
	CREATE TABLE [dbo].[FUNDS_DEPOSIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DEPOSIT_ID] [int] NULL,
		[CTL_NUMBER] [varchar](25) NULL,
		[BANK_ACC_ID] [int] NULL,
		[SUB_ACC_ID] [int] NULL,
		[TRANS_DATE] [varchar](8) NULL,
		[AMOUNT] [float] NULL,
		[CLEARED_FLAG] [smallint] NULL,
		[VOID_FLAG] [smallint] NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DESCRIPTION] [varchar](4000) NULL, -- field size changed as it is a descriptive column
		[VOIDCLEAR_DATE] [varchar](8) NULL,
		[DEPOSIT_TYPE] [smallint] NULL,
		[ADJUST_CODE] [int] NULL
	 CONSTRAINT [PK_FUNDS_DEPOSIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_FUNDS_DEPOSIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_FUNDS_DEPOSIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[ADJUST_CODE]  [varchar](25) NULL,
		[BANK_ACC_ID] [varchar](20) NULL,
		[SUB_ACC_ID] [varchar](20) NULL
	 CONSTRAINT [PK_T_DIS_FUNDS_DEPOSIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FUNDS_TRANS_SPLIT') 
BEGIN
	CREATE TABLE [dbo].[FUNDS_TRANS_SPLIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[SUM_AMOUNT] [float] NULL,
	[SPLIT_ROW_ID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[TRANS_TYPE_CODE] [int] NULL,
	[RESERVE_TYPE_CODE] [int] NULL,
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
	[SUPP_PAYMENT_FLAG] [smallint] NULL,
	[AUTO_DISCOUNT] [varchar](10) NULL,
	[POLCVG_ROW_ID] [int] NULL,
	[IS_FIRST_FINAL] [smallint] NULL,
	[WITHHOLDING_SPLIT_FLAG] [smallint] NULL,
	[PARENT_SPLIT_ROW_ID] [int] NULL,
	[CONTROL_REQ_FLAG] [smallint] NULL,
	[FUNDS_CR_STATUS] [int] NULL,
	[PMT_CURRENCY_AMOUNT] [float] NULL,
	[PMT_CURRENCY_INVOICE_AMOUNT] [float] NULL,
	[PMT_CURRENCY_AUTO_DISCOUNT] [float] NULL,
	[CLAIM_CURRENCY_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_INVOICE_AMOUNT] [float] NULL,
	[CLAIM_CURRENCY_AUTO_DISCOUNT] [float] NULL,
	[UPDATE_POL_SYS] [smallint] NULL,
	[POLICY_SYSTEM_ID] [int] NULL,
	[RC_ROW_ID] [int] NULL,
	
--ADDED BY JMERICLE
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_FUNDS_TRANS_SPLIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'HAZ_MAT') 
BEGIN
	CREATE TABLE [dbo].[HAZ_MAT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[HAZ_MAT_ID] [int] NULL,
		[PROD_NAME_TEXT] [varchar](75) NULL,
		[OTH_NAMES_TXCD] [varchar](8000) NULL,
		[NOTES_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_HAZ_MAT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'MED_STAFF') 
BEGIN
	CREATE TABLE [dbo].[MED_STAFF](	
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[STAFF_EID] [int] NULL,
		[MED_STAFF_NUMBER] [varchar](50) NULL,
		[PRIMARY_POLICY_ID] [int] NULL,
		[HOME_ADDR1] [varchar](100) NULL,
		[HOME_ADDR2] [varchar](100) NULL,
		[HOME_ADDR3] [varchar](100) NULL,
		[HOME_ADDR4] [varchar](100) NULL,
		[HOME_CITY] [varchar](50) NULL,
		[HOME_STATE_ID] [int] NULL,
		[HOME_ZIP_CODE] [varchar](10) NULL,
		[MARITAL_STAT_CODE] [int] NULL,
		[BEEPER_NUMBER] [varchar](30) NULL,
		[CELLULAR_NUMBER] [varchar](30) NULL,
		[EMERGENCY_CONTACT] [varchar](30) NULL,
		[STAFF_STATUS_CODE] [int] NULL,
		[STAFF_POS_CODE] [int] NULL,
		[STAFF_CAT_CODE] [int] NULL,
		[DEPT_ASSIGNED_EID] [int] NULL,
		[HIRE_DATE] [varchar](8) NULL,
		[LIC_NUM] [varchar](20) NULL,
		[LIC_STATE] [int] NULL,
		[LIC_ISSUE_DATE] [varchar](8) NULL,
		[LIC_EXPIRY_DATE] [varchar](8) NULL,
		[LIC_DEA_NUM] [varchar](20) NULL,
		[LIC_DEA_EXP_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_MED_STAFF] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'MRG_CLAIM_IDS') 
BEGIN
	CREATE TABLE [dbo].[MRG_CLAIM_IDS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[CLAIM_ID] [int] NULL,
	 CONSTRAINT [PK_MRG_CLAIM_IDS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ORG_HIERARCHY') 
BEGIN
	CREATE TABLE [dbo].[ORG_HIERARCHY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DEPARTMENT_EID] [int] NULL,
		[FACILITY_EID] [int] NULL,
		[LOCATION_EID] [int] NULL,
		[DIVISION_EID] [int] NULL,
		[REGION_EID] [int] NULL,
		[OPERATION_EID] [int] NULL,
		[COMPANY_EID] [int] NULL,
		[CLIENT_EID] [int] NULL,
	 CONSTRAINT [PK_ORG_HIERARCHY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT') 
BEGIN
	CREATE TABLE [dbo].[PATIENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int]  NULL,
		[PATIENT_EID] [int] NULL,
		[PATIENT_ACCT_NO] [varchar](20) NULL,
		[MEDICAL_RCD_NO] [varchar](20) NULL,
		[DATE_OF_ADMISSION] [varchar](8) NULL,
		[TIME_OF_ADMISSION] [varchar](6) NULL,
		[DATE_OF_DISCHARGE] [varchar](8) NULL,
		[TIME_OF_DISCHARGE] [varchar](6) NULL,
		[ADMISSION_REASON] [varchar](4000) NULL,
		[ADM_TYPE_CODE] [int] NULL,
		[ADM_SOURCE_CODE] [int] NULL,
		[ACUITY_LEVEL_CODE] [int] NULL,
		[CARDIAC_ARREST] [smallint] NULL,
		[PATIENT_STAT_CODE] [int] NULL,
		[PATIENT_COND_CODE] [int] NULL,
		[DISCHARGE_DSP_CODE] [int] NULL,
		[EXP_LENGTH_OF_STAY] [int] NULL,
		[EXPECTED_COST] [float] NULL,
		[INS_PLAN_GROUP_NO] [varchar](16) NULL,
		[QI_SIGNIF_CODE] [int] NULL,
		[EPISODE_OF_CARE_ID] [varchar](8) NULL,
		[PATIENT_TYPE_CODE] [int] NULL,
		[HEIGHT] [float] NULL,
		[WEIGHT] [float] NULL,
		[MARITAL_STAT_CODE] [int] NULL,
		[RACE_ENTH_CODE] [int] NULL,
		[DATE_OF_DEATH] [varchar](8) NULL,
		[PRIMARY_PAY_CODE] [int] NULL,
		[SECOND_PAY_CODE] [int] NULL,
		[EMERGENCY_CONTACT] [varchar](20) NULL,
		[EMERGENCY_CONT_NO] [varchar](20) NULL,
		[PATIENT_ROOM_NO] [varchar](14) NULL,
		[FACILITY_UNIT_CODE] [int] NULL,
		[FACILITY_DEPT_EID] [int] NULL,
		[HCO_ID_NO] [varchar](20) NULL,
		[HCO_SITE_ID_NO] [varchar](20) NULL,
		[PRI_PHYSICIAN_EID] [int] NULL,
		[ADM_PHYSICIAN_EID] [int] NULL,
		[NB_APGAR_SCORE] [int] NULL,
		[NB_BIRTH_WEIGHT] [float] NULL,
		[NB_LEN_OF_GEST] [int] NULL,
		[NB_NICU_STAY] [int] NULL,
		[NB_NICU_ADM_DATE] [varchar](8) NULL,
		[NB_NICU_DISCH_DATE] [varchar](8) NULL,
		[NB_CEPHALIC_MOLD] [int] NULL,
		[NB_EPS_OF_CARE_ID] [varchar](8) NULL,
		[NBM_PARITY] [int] NULL,
		[NBM_PRIOR_C_SECT] [int] NULL,
		[NBM_MED_IND_LABOR] [int] NULL,
		[NBM_LIVE_BIRTHS] [int] NULL,
		[NBM_STILL_BIRTHS] [int] NULL,
		[NBM_GRAVIDA] [int] NULL,
		[NBM_EPS_OF_CARE_ID] [varchar](8) NULL,
		[DISABILITY_CODE] [int] NULL,
		[ILLNESS_CODE] [int] NULL,
		[LOST_CONSC_FLAG] [int] NULL,
		[WHY_AT_FACILITY] [varchar](255) NULL,
	 CONSTRAINT [PK_PATIENT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_ACT_TAKEN') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_ACT_TAKEN](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[ACTION_CODE] [int] NULL,
	 CONSTRAINT [PK_PATIENT_ACT_TAKEN] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_ATTN_PHYS') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_ATTN_PHYS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[PHYSICIAN_EID] [int] NULL,
	 CONSTRAINT [PK_PATIENT_ATTN_PHYS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_DIAGNOSIS') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_DIAGNOSIS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[DIAGNOSIS_CODE] [int] NULL,
	 CONSTRAINT [PK_PATIENT_DIAGNOSIS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_DRG_CODES') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_DRG_CODES](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[DRG_CODE] [int] NULL,
	 CONSTRAINT [PK_PATIENT_DRG_CODES] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_PROCEDURE') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_PROCEDURE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROC_ROW_ID] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[PROCEDURE_CODE] [int] NULL,
		[PROC_TYPE_CODE] [int] NULL,
		[DATE_OF_PROCEDURE] [varchar](8) NULL,
		[SURGEON_EID] [int] NULL,
		[ANESTH_ADMIN_FLAG] [smallint] NULL,
		[ANESTH_TYPE_CODE] [int] NULL,
		[ANESTH_EID] [int] NULL,
		[ASA_PS_CLASS_CODE] [int] NULL,
		[COMPLICATION_DATE] [varchar](8) NULL,
		[PRIOR_TO_ANES_FLAG] [smallint] NULL,
		[ICC_LEVEL_CODE] [int] NULL,
		[LEN_OF_TIME] [float] NULL,
		[COMPLICATIONS] [varchar](4000) NULL,
	 CONSTRAINT [PK_PATIENT_PROCEDURE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PERSON_INVOLVED') 
BEGIN
	CREATE TABLE [dbo].[PERSON_INVOLVED](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COUNTY_OF_RESIDNC] [varchar](50) NULL,
		[DRIVLIC_STATE] [int] NULL,
		[EST_LEN_DISABILITY] [int] NULL,
		[HIRED_IN_STE_FLAG] [smallint] NULL,
		[INSURABLE_FLAG] [smallint] NULL,
		[LAST_VERIFIED_DATE] [varchar](8) NULL,
		[NUM_OF_VIOLATIONS] [int] NULL,
		[OSHA_ACC_DESC] [varchar](4000) NULL,
		[OSHA_REC_FLAG] [int] NULL,
		[REGULAR_JOB_FLAG] [smallint] NULL,
		[TERM_DATE] [varchar](8) NULL,
		[WORK_PERMIT_DATE] [varchar](8) NULL,
		[WORK_PERMIT_NUMBER] [varchar](50) NULL,
		[WORKDAY_START_TIME] [varchar](6) NULL,
		[PI_ROW_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
		[PI_EID] [int] NULL,
		[PI_TYPE_CODE] [int] NULL,
		[INJURY_ILLNESS_FLG] [int] NULL,
		[DATE_OF_DEATH] [varchar](8) NULL,
		[REHAB_TEXT] [varchar](4000) NULL,
		[DESC_BY_WITNESS] [varchar](4000) NULL,
		[PATIENT_ACCT_NO] [varchar](20) NULL,
		[MEDICAL_RCD_NO] [varchar](12) NULL,
		[INS_PLAN_GROUP_NO] [varchar](16) NULL,
		[DATE_OF_ADMISSION] [varchar](8) NULL,
		[DATE_OF_DISCHARGE] [varchar](8) NULL,
		[ADM_TYPE_CODE] [int] NULL,
		[ADM_SOURCE_CODE] [int] NULL,
		[ADMISSION_REASON] [varchar](4000) NULL,
		[ACUITY_LEVEL_CODE] [int] NULL,
		[PATIENT_STAT_CODE] [int] NULL,
		[PATIENT_COND_CODE] [int] NULL,
		[DISCHARGE_DSP_CODE] [int] NULL,
		[EXP_LENGTH_OF_STAY] [int] NULL,
		[EXPECTED_COST] [float] NULL,
		[QI_SIGNIF_CODE] [int] NULL,
		[EPISODE_OF_CARE_ID] [varchar](8) NULL,
		[PATIENT_TYPE_CODE] [int] NULL,
		[MARITAL_STAT_CODE] [int] NULL,
		[RACE_ENTH_CODE] [int] NULL,
		[WEIGHT] [int] NULL,
		[PRIMARY_PAY_CODE] [int] NULL,
		[EMERGENCY_CONTACT] [varchar](20) NULL,
		[EMERGENCY_CONT_NO] [varchar](20) NULL,
		[PATIENT_ROOM_NO] [varchar](14) NULL,
		[FACILITY_UNIT_CODE] [int] NULL,
		[FACILITY_DEPT_EID] [int] NULL,
		[HCO_ID_NO] [varchar](20) NULL,
		[HCO_SITE_ID_NO] [varchar](20) NULL,
		[WHY_AT_FACILITY] [varchar](4000) NULL,
		[CLAIM_AMOUNT] [float] NULL,
		[LOST_WORK_FLAG] [smallint] NULL,
		[LEN_OF_SVC_DAYS] [int] NULL,
		[POSITION_CODE] [int] NULL,
		[DEPT_ASSIGNED_EID] [int] NULL,
		[SUPERVISOR_EID] [int] NULL,
		[EXEMPT_STATUS_FLAG] [smallint] NULL,
		[NO_OF_EXEMPTIONS] [int] NULL,
		[FULL_TIME_FLAG] [smallint] NULL,
		[HOURLY_RATE] [float] NULL,
		[WEEKLY_HOURS] [float] NULL,
		[WEEKLY_RATE] [float] NULL,
		[WORK_SUN_FLAG] [smallint] NULL,
		[WORK_MON_FLAG] [smallint] NULL,
		[WORK_TUE_FLAG] [smallint] NULL,
		[WORK_WED_FLAG] [smallint] NULL,
		[WORK_THU_FLAG] [smallint] NULL,
		[WORK_FRI_FLAG] [smallint] NULL,
		[WORK_SAT_FLAG] [smallint] NULL,
		[DRIVERS_LIC_NO] [varchar](20) NULL,
		[DRIVERSLICTYPECODE] [int] NULL,
		[DATE_DRIVERSLICEXP] [varchar](8) NULL,
		[DRIVLIC_RSTRCTCODE] [int] NULL,
		[NCCI_CLASS_CODE] [int] NULL,
		[COMMENTS] [varchar](4000) NULL,
		[INJURY_CAT_CODE] [int] NULL,
		[PAY_AMOUNT] [float] NULL,
		[ACTIVE_FLAG] [smallint] NULL,
		[EMPLOYEE_NUMBER] [varchar](20) NULL,
		[DATE_HIRED] [varchar](8) NULL,
		[DISABILITY_CODE] [int] NULL,
		[ILLNESS_CODE] [int] NULL,
		[PAY_TYPE_CODE] [int] NULL,
		[LOST_CONSC_FLAG] [smallint] NULL,
		[SEC_DEPT_EID] [int] NULL,
		[PATIENT_ID] [int] NULL,
		[EST_RTW_DATE] [varchar](8) NULL,
		[OSHA_ESTAB_EID] [int] NULL,
		[MAJOR_HAND_CODE] [int] NULL,
		[HRANGE_START_DATE] [varchar](8) NULL,
		[HRANGE_END_DATE] [varchar](8) NULL,
		[JOB_CLASS_CODE] [int] NULL,
		[OTHER_TREATMENTS] [varchar](4000) NULL,
		[OTHER_MEDCOND] [varchar](4000) NULL,
		[STD_DISABIL_TYPE] [int] NULL,
		[CUSTOM_FED_TAX_PER] [float] NULL,
		[CUSTOM_SS_TAX_PER] [float] NULL,
		[CUSTOM_MED_TAX_PER] [float] NULL,
		[CUSTOM_ST_TAX_PER] [float] NULL,
		[MONTHLY_RATE] [float] NULL,
		[ELIG_DIS_BEN_FLAG] [smallint] NULL,
		[DIS_OPTION_CODE] [int] NULL,
		[HTMLCOMMENTS] [varchar](4000) NULL,
		[CONF_FLAG] [smallint] NULL,
		[CONF_EVENT_ID] [int] NULL,
		[WHERE_INJ_TAKEN] [varchar](4000) NULL,
		[WHAT_INJ_DOING][varchar](4000) NULL,
		[DATE_DISABILITY_BEGAN] [varchar](8) NULL,
		[DATE_DISABILITY_END] [varchar](8) NULL,
		[PRE_EXISTING_COND_FLAG] [smallint] NULL,
		[PRE_EXISTING_COND] [int] NULL,
		[DIAGNOSIS_CODE] [int] NULL,
		[COLLAT_SOURCES_DESC] [int] NULL,
		[INJ_CON_WITH_POL_RPT_FLAG] [smallint] NULL,
		[ER_HOSPITAL_FLAG] [smallint] NULL,
		[CAT_INJURY_FLAG] [smallint] NULL,
		[MEDICATIONS] [varchar](200) NULL,
		[FILE_CLOSING_DATE] [varchar](8) NULL,
		[SYMPTOMS_DESC] [varchar](200) NULL,
		[INJ_DEPT_EID] [int] NULL,
		[DELETED_DATE] [varchar](14) NULL,
		[INJURYCAUSE_CODE] [int] NULL,
		[PROGNOSIS] [varchar](4000) NULL,
		[IMPAIRMENT_FLAG] [smallint] NULL,
		[DAILY_HOURS] [float] NULL,
		[DAILY_RATE] [float] NULL,
		[WEEKLY_OFFSET] [float] NULL,
		[GROSS_EARNINGS] [float] NULL,
		[DRIVER_ROW_ID] [int] NULL,
		[POLICY_UNIT_ROW_ID] [int] NULL,
		[PARENT_TABLE_NAME] [varchar](50) NULL,
		[STAGING_ID] [int] NULL,	 
		--[NONHOUR_EARNGS_AMT] [float] NULL,     --vgupta20 --added
		--[NONHOUR_PAYPD_CODE] [int] NULL,	   --vgupta20 --added
	 CONSTRAINT [PK_PERSON_INVOLVED] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYS_CERTS') 
BEGIN
	CREATE TABLE [dbo].[PHYS_CERTS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CERT_ID] [int] NULL,
		[PHYS_EID] [int] NULL,
		[NAME_CODE] [int] NULL,
		[STATUS_CODE] [int] NULL,
		[BOARD_CODE] [int] NULL,
		[INT_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_PHYS_CERTS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYS_EDUCATION') 
BEGIN
	CREATE TABLE [dbo].[PHYS_EDUCATION](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[EDUC_ID] [int] NULL,
		[PHYS_EID] [int] NULL,
		[EDUC_TYPE_CODE] [int] NULL,
		[INSTITUTION_EID] [int] NULL,
		[DEGREE_TYPE] [int] NULL,
		[DEGREE_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_PHYS_EDUCATION] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYS_PREV_HOSP') 
BEGIN
	CREATE TABLE [dbo].[PHYS_PREV_HOSP](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PREV_HOSP_ID] [int] NULL,
		[PHYS_EID] [int] NULL,
		[STATUS_CODE] [int] NULL,
		[HOSPITAL_EID] [int] NULL,
		[PRIV_CODE] [int] NULL,
		[INT_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_PHYS_PREV_HOSP] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYS_PRIVS') 
BEGIN
	CREATE TABLE [dbo].[PHYS_PRIVS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PRIV_ID] [int] NULL,
		[PHYS_EID] [int] NULL,
		[CATEGORY_CODE] [int] NULL,
		[TYPE_CODE] [int] NULL,
		[STATUS_CODE] [int] NULL,
		[INT_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_PHYS_PRIVS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYS_SUB_SPECIALTY') 
BEGIN
	CREATE TABLE [dbo].[PHYS_SUB_SPECIALTY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PHYS_EID] [int] NULL,
		[SPECIALTY_CODE] [int] NULL,
	 CONSTRAINT [PK_PHYS_SUB_SPECIALTY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PHYSICIAN') 
BEGIN
	CREATE TABLE [dbo].[PHYSICIAN](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PHYS_EID] [int] NULL,
		[PHYSICIAN_NUMBER] [varchar](50) NULL,
		[MED_STAFF_NUMBER] [varchar](50) NULL,
		[MEDICARE_NUMBER] [varchar](20) NULL,
		[PRIMARY_SPECIALTY] [int] NULL,
		[PRIMARY_POLICY_ID] [int] NULL,
		[HOME_ADDR1] [varchar](100) NULL,
		[HOME_ADDR2] [varchar](100) NULL,
		[HOME_ADDR3] [varchar](100) NULL,
		[HOME_ADDR4] [varchar](100) NULL,
		[HOME_CITY] [varchar](50) NULL,
		[HOME_STATE_ID] [int] NULL,
		[HOME_ZIP_CODE] [varchar](10) NULL,
		[MARITAL_STAT_CODE] [int] NULL,
		[BEEPER_NUMBER] [varchar](30) NULL,
		[CELLULAR_NUMBER] [varchar](30) NULL,
		[MAILING_ADDR1] [varchar](100) NULL,
		[MAILING_ADDR2] [varchar](100) NULL,
		[MAILING_ADDR3] [varchar](100) NULL,
		[MAILING_ADDR4] [varchar](100) NULL,
		[MAILING_CITY] [varchar](50) NULL,
		[MAILING_STATE_ID] [int] NULL,
		[MAILING_ZIP_CODE] [varchar](10) NULL,
		[EMERGENCY_CONTACT] [varchar](30) NULL,
		[STAFF_STATUS_CODE] [int] NULL,
		[STAFF_TYPE_CODE] [int] NULL,
		[STAFF_CAT_CODE] [int] NULL,
		[INTERNAL_NUMBER] [varchar](20) NULL,
		[DEPT_ASSIGNED_EID] [int] NULL,
		[APPOINT_DATE] [varchar](8) NULL,
		[REAPPOINT_DATE] [varchar](8) NULL,
		[LIC_STATE] [int] NULL,
		[LIC_NUM] [varchar](20) NULL,
		[LIC_ISSUE_DATE] [varchar](8) NULL,
		[LIC_EXPIRY_DATE] [varchar](8) NULL,
		[LIC_DEA_NUM] [varchar](20) NULL,
		[LIC_DEA_EXP_DATE] [varchar](8) NULL,
		[MEMBERSHIP] [varchar](20) NULL,
		[CONT_EDUCATION] [varchar](20) NULL,
		[TEACHING_EXP] [varchar](20) NULL,
	 CONSTRAINT [PK_PHYSICIAN] PRIMARY KEY CLUSTERED 
	(	
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_BODY_PART') 
BEGIN
	CREATE TABLE [dbo].[PI_X_BODY_PART](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[BODY_PART_CODE] [int] NULL,
	 CONSTRAINT [PK_PI_X_BODY_PART] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_DIAGNOSIS') 
BEGIN
	CREATE TABLE [dbo].[PI_X_DIAGNOSIS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[DIAGNOSIS_CODE] [int] NULL,
	 CONSTRAINT [PK_PI_X_DIAGNOSIS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_INJURY') 
BEGIN
	CREATE TABLE [dbo].[PI_X_INJURY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[INJURY_CODE] [int] NULL,
	 CONSTRAINT [PK_PI_X_INJURY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_TREATMENT') 
BEGIN
	CREATE TABLE [dbo].[PI_X_TREATMENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[TREATMENT_CODE] [int] NULL,
	 CONSTRAINT [PK_PI_X_TREATMENT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_WORK_LOSS') 
BEGIN
	CREATE TABLE [dbo].[PI_X_WORK_LOSS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_WL_ROW_ID] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[DATE_LAST_WORKED] [varchar](8) NULL,
		[DATE_RETURNED] [varchar](8) NULL,
		[DURATION] [int] NULL,
		[STATE_DURATION] [int] NULL,
--VGUPTA20 --ADDED
		[DISABILITY_DATE] [varchar](8) NULL,
		[NONCONSEC_PERIOD] [int] NULL,
		[PHYSICAL_RESTRICT] [int] NULL,
		[RTW_QUALIFIER] [int] NULL,
		[RTW_SAME_EMPLOYER] [int] NULL,
		[RTW_TYPE] [int] NULL,
		[WORK_INTENSITY] [int] NULL,
	 CONSTRAINT [PK_PI_X_WORK_LOSS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POLICY') 
BEGIN
	CREATE TABLE [dbo].[POLICY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[POLICY_ID] [int]  NULL,
		[POLICY_NAME] [varchar](20) NULL,
		[POLICY_NUMBER] [varchar](20) NULL,
		[POLICY_STATUS_CODE] [int] NULL,
		[INSURER_EID] [int] NULL,
		[ISSUE_DATE] [varchar](8) NULL,
		[REVIEW_DATE] [varchar](8) NULL,
		[RENEWAL_DATE] [varchar](8) NULL,
		[EFFECTIVE_DATE] [varchar](8) NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[CANCEL_DATE] [varchar](8) NULL,
		[PREMIUM] [float] NULL,
		[TRIGGER_CLAIM_FLAG] [smallint] NULL,
		[PRIMARY_POLICY_FLG] [smallint] NULL,
		[COMMENTS] [varchar](4000) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[BROKER_EID] [int] NULL,
		[BANK_ACC_ID] [int] NULL,
		[SUB_ACC_ROW_ID] [int] NULL,
		[HTMLCOMMENTS] [varchar](4000) NULL,
		[ALL_STATES_FLAG] [smallint] NULL,
		[POLICY_SYSTEM_ID] [int]  NULL,
		[POLICY_TYPE] [int]  NULL,
		[POLICY_SYMBOL] [varchar](20) NULL,
		[EXTERNAL_POLICY_ID] [varchar](20) NULL,
		[CURRENCY_CODE] [int]  NULL,
		[POLICY_LOB_CODE] [int] NULL,
		[MODULE] [varchar](10) NULL,
		[MASTER_COMPANY] [varchar](10) NULL,
		[LOCATION_COMPANY] [varchar](10) NULL,
		[BRANCH_CODE] [varchar](50) NULL,
		[DUPLICATE_FLAG][varchar](50) NULL,
		[EXTERNAL_POLICY_KEY][varchar](50) NULL,
		
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_POLICY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POLICY_X_CVG_TYPE') 
BEGIN
	CREATE TABLE [dbo].[POLICY_X_CVG_TYPE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIM_LIMIT] [float] NULL,
		[NOTIFICATION_UID] [int] NULL,
		[POLCVG_ROW_ID] [int] NULL,
		[POLICY_ID] [int] NULL,
		[COVERAGE_TYPE_CODE] [int] NULL,
		[POLICY_LIMIT] [float] NULL,
		[OCCURRENCE_LIMIT] [float] NULL,
		[TOTAL_PAYMENTS] [float] NULL,
		[REMARKS] [varchar](8000) NULL,
		[EXCEPTIONS] [varchar](8000) NULL,
		[CANCEL_NOTICE_DAYS] [int] NULL,
		[SELF_INSURE_DEDUCT] [float] NULL,
		[NEXT_POLICY_ID] [int] NULL,
		[BROKER_NAME] [varchar](100) NULL,
		[SECTION_NUMBER_CODE] [int] NULL,
		[POLICY_UNIT_ROW_ID] [int] NULL,
		[PER_PERSON_LIMIT] [float] NULL,
		[EFFECTIVE_DATE] [varchar](8) NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[LIMIT] [float] NULL,
		[ORIGINAL_PREMIUM] [float] NULL,
		[WRITTEN_PREMIUM] [float] NULL,
		[FULL_TERM_PREMIUM] [float] NULL,
		[TOTAL_WRITTEN_PREMIUM] [float] NULL,
		[EXPOSURE] [float] NULL,
		[CHANGE_DATE] [varchar](8) NULL,
		[CVG_SEQUENCE_NO] [varchar](8) NULL,
		[TRANS_SEQ_NO] [varchar](8) NULL,
		[COVERAGE_TEXT] [varchar](100) NULL,
		[COVERAGE_CLASS_CODE] [varchar](20) NULL,
		[LIMIT_COVA] [float] NULL,
		[LIMIT_COVB] [float] NULL,
		[LIMIT_COVC] [float] NULL,
		[LIMIT_COVD] [float] NULL,
		[LIMIT_COVE] [float] NULL,
		[LIMIT_COVF] [float] NULL,
		[WC_DED_AMT] [float] NULL,
		[WC_DED_AGGR] [float] NULL,
		[PRODLINE] [varchar](50) NULL,
		[ASLINE] [varchar](50) NULL,
		[SUB_LINE] [varchar](3) NULL,
		[DED_TYPE_CODE] [int] NULL,
		[STAGING_ID] [int] NULL,
		[REINSURANCE_CODE] [int] NULL,
		[RETRO_DATE][varchar](8) NULL,
		[TAIL_DATE][varchar](8) NULL,
		[COVERAGE_KEY][varchar](100) NULL,
	 CONSTRAINT [PK_POLICY_X_CVG_TYPE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POLICY_X_INSURED') 
BEGIN
	CREATE TABLE [dbo].[POLICY_X_INSURED](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[POLICY_ID] [int] NULL,
		[INSURED_EID] [int]  NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_POLICY_X_INSURED] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POLICY_X_INSURER') 
BEGIN
	CREATE TABLE [dbo].[POLICY_X_INSURER](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[IN_ROW_ID] [int] NULL,
		[POLICY_ID] [int] NULL,
		[INSURER_CODE] [int] NULL,
		[RES_PERCENTAGE] [float] NULL,
		[PRIMARY_INSURER] [smallint] NULL,
		[PREMIUM_AMOUNT] [float] NULL,
		[PART_OF_TOTAL_LAYER] [float] NULL,
		[PORTION_OF_PART_OF_LAYER] [float] NULL,
		[INSTAL_PAYMENT_AMT] [float] NULL,
		[INSTAL_SCHEDULE_CODE] [int] NULL,
		[SPECIAL_CIRCUM_MEMO] [varchar](4000) NULL,
		[LAYER_NUM_CODE] [int] NULL,
		[OCCURENCE_LIMIT] [float] NULL,
		[COVERAGE_DESC] [varchar](100) NULL,
		[COMMENT_MEMO] [varchar](16) NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_POLICY_X_INSURER] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROJ_TRACK') 
BEGIN
	CREATE TABLE [dbo].[PROJ_TRACK](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROJ_TRACK_ID] [int] NULL,
		[ACT_TYPE_CODE] [int] NULL,
		[ACTIV_DESC_TXCD] [varchar](8000) NULL,
		[ASSIGN_BY_TEXT] [varchar](50) NULL,
		[ASSIGN_TO_TXCD] [varchar](8000) NULL,
		[PRIORITY_CODE] [int] NULL,
		[EST_HOURS_NUM] [float] NULL,
		[ACT_HOURS_NUM] [float] NULL,
		[DUE_DATE_DATE] [varchar](8) NULL,
		[REVIEW_DATE_DATE] [varchar](8) NULL,
		[COMPLETE_DT_DATE] [varchar](8) NULL,
		[STATUS_CODE] [int] NULL,
		[MAT_USED_TXCD] [varchar](8000) NULL,
		[MAT_COST_AMT] [float] NULL,
		[NOTES_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_PROJ_TRACK] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROP_MGT') 
BEGIN
	CREATE TABLE [dbo].[PROP_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROP_MGT_ID] [int] NULL,
		[PROP_ID_TEXT] [varchar](50) NULL,
		[LOCATION_TXCD] [varchar](8000) NULL,
		[OWNERSHIP_CODE] [int] NULL,
		[PROP_TYPE_CODE] [int] NULL,
		[PROP_CAT_TEXT] [varchar](50) NULL,
		[REPORTED_BY_TXCD] [varchar](8000) NULL,
		[DT_UPDATE_DATE] [varchar](8) NULL,
		[REV_DATE_DATE] [varchar](8) NULL,
		[DETAIL_TXCD] [varchar](8000) NULL,
		[ORIG_VALUE_AMT] [float] NULL,
		[CURR_VALUE_AMT] [float] NULL,
		[REPLACE_VAL_AMT] [float] NULL,
		[CONT_ORG_VL_AMT] [float] NULL,
		[CONT_REP_VL_AMT] [float] NULL,
		[CONT_CUR_VL_AMT] [float] NULL,
		[INSTALL_DT_DATE] [varchar](8) NULL,
		[CONTACT_TEXT] [varchar](50) NULL,
		[CONTACT_ADD_TEXT] [varchar](50) NULL,
		[CONT_CITY_TEXT] [varchar](25) NULL,
		[CONT_STATE_TEXT] [varchar](15) NULL,
		[CONT_ZIP_TEXT] [varchar](15) NULL,
		[CONT_PHONE_TEXT] [varchar](25) NULL,
		[COVERAGE_CODE] [int] NULL,
		[DAMAGES_TXCD] [varchar](8000) NULL,
		[IMPROVEMENT_TXCD] [varchar](8000) NULL,
		[NOTES_TXCD] [varchar](8000) NULL,
	 CONSTRAINT [PK_PROP_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'RESERVE_CURRENT') 
BEGIN
	CREATE TABLE [dbo].[RESERVE_CURRENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BALANCE_AMOUNT] [float] NULL,
		[RC_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[UNIT_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[RESERVE_TYPE_CODE] [int] NULL,
		[RESERVE_AMOUNT] [float] NULL,
		[INCURRED_AMOUNT] [float] NULL,
		[COLLECTION_TOTAL] [float] NULL,
		[PAID_TOTAL] [float] NULL,
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
		[ALLOCATED_AMOUNT] [float] NULL,
		[POLCVG_ROW_ID] [int] NULL,
		[CLAIM_CURR_CODE] [int] NULL,
		[CLAIM_TO_BASE_CUR_RATE] [float] NULL,
		[CLAIM_CURRENCY_RESERVE_AMOUNT] [float] NULL,
		[CLAIM_CURRENCY_INCURRED_AMT] [float] NULL,
		[CLAIM_CURR_COLLECTION_TOTAL] [float] NULL,
		[CLAIM_CURRENCY_PAID_TOTAL] [float] NULL,
		[CLAIM_CURRENCY_BALANCE_AMT] [float] NULL,
		[BASE_TO_CLAIM_CUR_RATE] [float] NULL,
		[RESERVE_CATEGORY] [int] NULL,
		[ASSIGNADJ_EID] [int] NULL,
		[RESERVE_ID] [int] NULL,
	 CONSTRAINT [PK_RESERVE_CURRENT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'RESERVE_HISTORY') 
BEGIN
	CREATE TABLE [dbo].[RESERVE_HISTORY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BALANCE_AMOUNT] [float] NULL,
		[CHANGE_AMOUNT] [float] NULL,
		[RSV_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[UNIT_ID] [int] NULL,
		[RESERVE_TYPE_CODE] [int] NULL,
		[RESERVE_AMOUNT] [float] NULL,
		[COLLECTION_TOTAL] [float] NULL,
		[INCURRED_AMOUNT] [float] NULL,
		[PAID_TOTAL] [float] NULL,
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
		--[CLOSED_FLAG] [int] NULL,
		--[AUTO_ADJ_FLAG] [int] NULL,
--ADDED BY JMERICLE
		[STAGING_ID] [int] NULL,
		[CLAIM_CURR_CODE] [int] NULL,
		[CLAIM_TO_BASE_CUR_RATE] [float] NULL,
		[CLAIM_CURRENCY_RESERVE_AMOUNT] [float] NULL,
		[CLAIM_CURRENCY_INCURRED_AMT] [float] NULL,
		[CLAIM_CURR_COLLECTION_TOTAL] [float] NULL,
		[CLAIM_CURRENCY_PAID_TOTAL] [float] NULL,
		[CLAIM_CURRENCY_BALANCE_AMT] [float] NULL,
		[BASE_TO_CLAIM_CUR_RATE] [float] NULL,
		[RESERVE_CATEGORY] [int] NULL,
		[POLICY_CVG_SEQNO] [int] NULL,
		[POLCVG_LOSS_ROW_ID] [int] NULL,
		[ADJUSTER_ID] [int] NULL,
		[ASSIGNADJ_EID] [int] NULL,
	 CONSTRAINT [PK_RESERVE_HISTORY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'STAFF_CERTS') 
BEGIN
	CREATE TABLE [dbo].[STAFF_CERTS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[STAFF_CERT_ID] [int] NULL,
		[STAFF_EID] [int] NULL,
		[NAME_CODE] [int] NULL,
		[INT_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_STAFF_CERTS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'STAFF_PRIVS') 
BEGIN
	CREATE TABLE [dbo].[STAFF_PRIVS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,	
		[STAFF_PRIV_ID] [int] NULL,
		[STAFF_EID] [int] NULL,
		[CATEGORY_CODE] [int] NULL,
		[TYPE_CODE] [int] NULL,
		[STATUS_CODE] [int] NULL,
		[INT_DATE] [varchar](8) NULL,
		[END_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_STAFF_PRIVS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'UNIT_X_CLAIM') 
BEGIN
	CREATE TABLE [dbo].[UNIT_X_CLAIM](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[UNIT_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[UNIT_ROW_ID] [int] NULL,		
		[VEHICLE_MAKE] [varchar](20) NULL,
		[VEHICLE_YEAR] [int] NULL,
		[HOME_DEPT_EID] [int] NULL,
		[LICENSE_NUMBER] [varchar](20) NULL,
		[STATE_ROW_ID] [int] NULL,
		[DAMAGE] [varchar](4000) NULL,
		[UNIT_TYPE_CODE] [int] NULL,
		[VIN] [varchar](20) NULL,
		[ISINSURED] [int] NULL, -- Newly Added - 23Jun2014 - Kapil
		[ESTDAMAGE] [float] NULL, -- Newly Added - 23Jun2014 - Kapil
		[OWNER_EID] [int] NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[ISDRIVABLE] [int] NULL, -- Newly Added - 23Jun2014 - Kapil
		[ISNONVEHICLEPROPERTYDAMAGE] [int] NULL, -- Newly Added - 23Jun2014 - Kapil
		[OTHERINSURANCE] [int] NULL, -- Newly Added - 23Jun2014 - Kapil
		[POLHOLDERISPROPERTYOWNER] [int] NULL, -- Newly Added - 23Jun2014 - Kapil 
		[POLICYHOLDER] [int] NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[COMPANY] [int] NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[SEENAT] [varchar](4000) NULL, -- Newly  Added - 23Jun2014 - Kapil
		[DATEREPORTED] [varchar](8) NULL, -- Newly Added - 23Jun2014 - Kapil
		[TIMEREPORTED] [varchar](6) NULL, -- Newly Added - 23Jun2014 - Kapil
		[POLICYNUMBER] [varchar](10) NULL, -- Newly Added - 23Jun2014 - Kapil
		[COVERAGES] [varchar](4000) NULL, -- Newly Added - 23Jun2014 - Kapil
		[LIMITS] [varchar](50) NULL, -- Newly Added - 23Jun2014 - Kapil
		[ASSIGNADJ_EID] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_UNIT_X_CLAIM] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC

	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END





IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'VEHICLE') 
BEGIN
	CREATE TABLE [dbo].[VEHICLE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DISPOSAL_DATE] [varchar](8) NULL,
		[LEASE_AMOUNT] [float] NULL,
		[LEASE_EXPIRE_DATE] [varchar](8) NULL,
		[LEASE_FLAG] [smallint] NULL,
		[LEASE_NUMBER] [varchar](50) NULL,
		[LEASE_TERM] [int] NULL,
		[LEASING_CO_EID] [int] NULL,
		[LICENSE_RNWL_DATE] [varchar](8) NULL,
		[VEHICLE_MODEL] [varchar](50) NULL,
		[UNIT_ID] [int] NULL,
		[VEHICLE_MAKE] [varchar](20) NULL,
		[VEHICLE_YEAR] [int] NULL,
		[UNIT_TYPE_CODE] [int] NULL,
		[HOME_DEPT_EID] [int] NULL,
		[LICENSE_NUMBER] [varchar](20) NULL,
		[STATE_ROW_ID] [int] NULL,
		[GROSS_WEIGHT] [float] NULL,
		[VIN] [varchar](20) NULL,
		[ORIGINAL_COST] [float] NULL,
		[PURCHASE_DATE] [varchar](8) NULL,
		[DEDUCTIBLE] [float] NULL,
		[LAST_SERVICE_DATE] [varchar](8) NULL,
		[TYPE_OF_SERVICE] [varchar](4000) NULL,   -- Newly Added - 23Jun2014 - Kapil
		[INSURANCE_COVERAGE] [varchar](4000) NULL,	 -- Newly Added - 23Jun2014 - Kapil
		[VEH_DESC] [varchar](255) NULL,			 -- Newly Added - 23Jun2014 - Kapil
		[DELETED_FLAG] [smallint] NULL,
	 CONSTRAINT [PK_VEHICLE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END




IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'VEHICLE_X_ACC_DATE') 
BEGIN
	CREATE TABLE [dbo].[VEHICLE_X_ACC_DATE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,	
		[UNIT_ID] [int] NULL,
		[ACCIDENT_DATE] [varchar](8) NULL,
		[CLAIM_ID] [int] NULL,
		[VEH_X_ACC_DATE_ROW_ID] [int] NULL,
	 CONSTRAINT [PK_VEHICLE_X_ACC_DATE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'VEHICLE_X_INSPCT') 
BEGIN
	CREATE TABLE [dbo].[VEHICLE_X_INSPCT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[UNIT_INSP_ROW_ID] [int] NULL,
		[UNIT_ID] [int] NULL,
		[INSPECTION_DATE] [varchar](8) NULL,
		[INSPECTION_RESULT] [varchar](255) NULL,
	 CONSTRAINT [PK_VEHICLE_X_INSPCT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ERROR_LOG') 
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


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DA_STATISTICS') 
BEGIN
	CREATE TABLE [dbo].[DA_STATISTICS] (
		[JOBID] [int] NOT NULL,
		[PASS_COUNT] [int] NOT NULL,
		[STAGE] [int] NULL,
		[IS_VALIDATION] [int] NULL,
		[IMPORT_MODULE_NAME] [varchar](50) NULL,
		[TABLE_NAME] [varchar](50) NOT NULL,
		[INPUT_ROW_COUNT] [int] NULL,
		[START_VALID_ROW_COUNT] [int] NULL,
		[START_INVALID_ROW_COUNT] [int] NULL,
		[END_VALID_ROW_COUNT] [int] NULL,
		[END_INVALID_ROW_COUNT] [int] NULL,
		[END_UPDATE_ROW_COUNT] [int] NULL,
		[TOTAL_ROWS] [int] NULL,
		[TOTAL_FAILED_VALIDATIONS] [int] NULL,
		[START_TIME] [varchar](14) NULL,
		[END_TIME] [varchar](14) NULL,
	 CONSTRAINT [PK_DA_STATISTICS] PRIMARY KEY CLUSTERED
	(
		[JOBID] ASC,
		[PASS_COUNT] ASC,
		[TABLE_NAME] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


   --  gmahajan2 11/29/2010 MITS 21311 START; required columns added to USER_DEF_RESERVE_MAP to resolve errors logged in
 -- DIS_EXE_ERROR_.txt

   --  ****************************************************************************
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'USER_DEF_RESERVE_MAP')
BEGIN
	CREATE TABLE [dbo].[USER_DEF_RESERVE_MAP](
		[OPTIONSET_ID] [int] NOT NULL,
        [JOBID] [int] NULL, 
		[LOB_CODE] [int] NOT NULL,
		[BUCKET] [varchar](2) NOT NULL,
		[RSV_TYPE_SHORT_CODE] [varchar](25) NULL,
		[RSV_TYPE_CODE] [int] NULL,
		[CODE_DESC] [varchar](50) NULL,
	CONSTRAINT [PK_USER_DEF_RESERVE_MAP] PRIMARY KEY CLUSTERED
	(
		[OPTIONSET_ID] ASC,
		[LOB_CODE] ASC,
		[BUCKET] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

   --  gmahajan2 11/29/2010 MITS 21311 END

   --  ****************************************************************************

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'UNIQUE_CODE') 
BEGIN
	CREATE TABLE [dbo].[UNIQUE_CODE](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[TABLE_ID] [int] NULL,
		[CODE_ID] [int] NULL,
		[LINE_OF_BUS_CODE] [int] NULL,
		[RELATED_CODE_ID] [int] NULL,
		[NEW_CODE] [int] NULL,
		[SHORT_CODE] [varchar](25) NULL,
		[CODE_TABLE_NAME] [varchar](30) NULL,
                [DELETED_FLAG] [int] NULL,
	 CONSTRAINT [PK_UNIQUE_CODE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DDS_OPTIONSET') 
BEGIN
	CREATE TABLE [dbo].[DDS_OPTIONSET](
		[JOBID] [int] NOT NULL,
		[ALLOW_NEW_CLAIMS] [int] NULL,
		[ALLOW_NEW_CODES] [int] NULL,
		[ALLOW_NEW_EMPLOYEES] [int] NULL,
		[ALLOW_NEW_DEPARTMENT] [int] NULL,
		[PAYMENTS_AVAILABLE] [int] NULL,
		[ADJUSTER_NOTES_AVAILABLE] [int] NULL,
		[EVENTS_AVAILABLE] [int] NULL,
		[CLAIMS_AVAILABLE] [int] NULL,
		[SHORT_TERM_DISABILITY_AVAILABLE] [int] NULL,
		[MED_WATCH_AVAILABLE] [int] NULL,
		[ENHANCED_NOTES_AVAILABLE] [int] NULL,
		[SET_ADJUSTER_AS_CURRENT] [int] NULL,
		[DONT_CHECK_DUPLICATE_PAYMENTS] [int] NULL,
		[ATTACH_TRANS_ID_TO_CHECK_NO] [int] NULL,
		[CREATE_ENTITY_IF_TAX_ID_EMPTY_GCVA] [int] NULL,
		[ID_CLAIMANT_BY_NAME_GCVA] [int] NULL,
		[ID_CLAIMANT_BY_SUFFIX_GCVA] [int] NULL,
		[UPDATE_CLAIMANT_NAME_GCVA] [int] NULL,
		[UPDATE_CLAIMANT_NAME_WC] [int] NULL,
		[USE_TAX_ID_IN_ENTITY_MATCHES] [int] NULL,
		[PAYMENT_BANK_ACCOUNT] [int] NULL,
		[PAYMENT_SUB_ACCOUNT] [int] NULL,
		[EMPLOYEE_MATCH_BY_NAME] [int] NULL,
		[EMPLOYEE_MATCH_BY_TAX_ID] [int] NULL,
		[EMPLOYEE_MATCH_BY_EMP_NUM] [int] NULL,
		[NON_EMP_MATCH_BY_NAME] [int] NULL,
		[NON_EMP_MATCH_BY_TAX_ID] [int] NULL,
		[MAX_ERRORS] [int] NULL,
		[RECALCULATE_RESERVES] [int] NULL,
		[UPDATE_CLAIMANT_DETAILS] [int] NULL,
		[VALID_START_DATE] [varchar](8) NULL,
		[VALID_END_DATE] [varchar](8) NULL,
		[USE_TRANSACTIONS] [int] NULL,
		[PERFORM_VERIFICATION] [int] NULL,
		[VALIDATE_SUPPLEMENTALS] [int] NULL,
		[DIARY_TO_USERS] [varchar](100) NULL,
		[EVENT_IMPORTFILE_NAME] [varchar](100) NULL,
		[MEDWATCH_IMPORTFILE_NAME] [varchar](100) NULL,
		[CLAIM_IMPORTFILE_NAME] [varchar](100) NULL,
		[STD_PLAN_IMPORTFILE_NAME] [varchar](100) NULL,
		[STD_CLASS_IMPORTFILE_NAME] [varchar](100) NULL,
		[ADJUSTER_IMPORTFILE_NAME] [varchar](100) NULL,
		[PAYMENT_IMPORTFILE_NAME] [varchar](100) NULL,
		[ENHANCE_NOTES_IMPORTFILE_NAME] [varchar](100) NULL, 	
	 CONSTRAINT [PK_DDS_OPTIONSET] PRIMARY KEY CLUSTERED
	(
		[JOBID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIS_OPTIONSET') 
BEGIN
	CREATE TABLE [dbo].[DIS_OPTIONSET](
		[JOBID] [int] NOT NULL,
		[OPTIONSET_ID] [int] NULL,
		[OPTIONSET_NAME] [varchar](50) NULL,
		[VERIFICATION_FLAG] [int] NULL,
		[chk2GBData] [int] NULL,
		[txtBatchID] [int] NULL,
		[NUMBER_OF_AREAS_IMPORTING] [int] NULL,
		[EMPLOYEES_FLAG] [int] NULL,
		[EMPLOYEES_IMPORT_SUPP] [int] NULL,
		[EMPLOYEES_MATCH_EMPLOYEE_ID] [int] NULL,			
		[EMPLOYEES_UPDATE_BLANK_ZERO] [int] NULL,
		[EMP_UPDATE_ADDRESS_BLANK_ZERO] [int] NULL,
		[EMPLOYEES_CREATE_NEW_CODES] [int] NULL,
		[EMPLOYEES_MATCH_ENTITY_ID] [int] NULL,
		[ORGHIER_FLAG] [int] NULL,
		[ORGHIER_IMPORT_SUPP] [int] NULL,
		[ORGHIER_UPDATE_BLANK_ZERO] [int] NULL,
		[ORGHIER_CREATE_NEW_CODES] [int] NULL,
		[FUNDS_FLAG] [int] NULL,
		[FUNDS_IMPORT_SUPP] [int] NULL,
		[FUNDS_MATCH_PAYEE_NAME] [int] NULL,
		[FUNDS_MATCH_PAYEE_TAX_ID] [int] NULL,
		[FUNDS_CREATE_NEW_CODES] [int] NULL,
		[FUNDS_OPEN_CLAIMS_ONLY] [int] NULL,
		[FUNDS_CHECK_DUPLICATE_PAYMENTS] [int] NULL,
 		[FUNDS_ACCEPT_DUP_CHECK_NUMBER] [int] NULL,
		[FUNDS_IMPORT_CLEARED_PAYMENTS] [int] NULL,
		[FUNDS_MATCH_ENTITY_ID] [int] NULL,
		[FUNDS_IMPORT_MULTIPLE_PAYEES] [int] NULL,
		[FUNDSDEPOSIT_FLAG] [int] NULL,
		[FUNDSDEPOSIT_UPDATE_BLANK_ZERO] [int] NULL,
		[FUNDSDEPOSIT_CREATE_NEW_CODES] [int] NULL,		
		[VEHICLES_FLAG] [int] NULL,
		[VEHICLES_IMPORT_SUPP] [int] NULL,
		[VEHICLES_UPDATE_BLANK_ZERO] [int] NULL,
		[VEHICLES_CREATE_NEW_CODES] [int] NULL,
		[ENTITIES_FLAG] [int] NULL,
		[ENTITIES_IMPORT_SUPP] [int] NULL,
		[ENTITIES_UPDATE_BLANK_ZERO] [int] NULL,
		[ENTITIES_CREATE_NEW_CODES] [int] NULL,
		[POLICIES_FLAG] [int] NULL,
		[POLICIES_IMPORT_SUPP] [int] NULL,
		[POLICIES_CREATE_NEW_CODES] [int] NULL,	
		[POL_INSURED_ENTITYID] [int] NULL,
		[POL_MATCH_INSURED_TAXID] [int] NULL,
		[POL_MATCH_INSURED_NAME] [int] NULL,
		[POL_MATCH_INSURED_ABBREV] [int] NULL,
		[POL_INSURER_ENTITYID] [int] NULL,
		[POL_MATCH_INSURER_TAXID] [int] NULL,
		[POL_MATCH_INSURER_NAME] [int] NULL,
		[POL_MATCH_INSURER_ABBREV] [int] NULL,
		[POL_INSURED_CLAIMANT] [int] NULL,
		[POL_IMPRT_ADD_INTRST] [int] NULL,
		[POL_IMPRT_ADD_INTRST_TAXID] [int] NULL,	
		[POL_IMPRT_ADD_INTRST_NAME] [int] NULL,	
		[RESERVES_FLAG] [int] NULL,
		[RESERVES_IMPORT_SUPP] [int] NULL,
		[RESERVES_CREATE_NEW_CODES] [int] NULL,
		[RESERVES_CHECK_DUPLICATE] [int] NULL,
		[ORGEXPO_FLAG] [int] NULL,
		[ORGEXPO_IMPORT_SUPP] [int] NULL,
		[ORGEXPO_NEW_RECORDS_ONLY] [int] NULL,
		[ORGEXPO_UPDATE_BLANK_ZERO] [int] NULL,
		[ORGEXPO_CREATE_NEW_CODES] [int] NULL,
		[PATIENTS_FLAG] [int] NULL,
		[PATIENTS_IMPORT_SUPP] [int] NULL,
		[PATIENTS_VALIDATE_DATA] [int] NULL,
		[PATIENTS_MATCH_PATIENT] [int] NULL,
		[PATIENTS_CREATE_NEW_CODES] [int] NULL,
		[PATIENT_MATCH_PATIENT_NUMBER] [int] NULL,
		[PHYSICIANS_FLAG] [int] NULL,
		[PHYSICIANS_IMPORT_SUPP] [int] NULL,
		[PHYSICIANS_VALIDATE_DATA] [int] NULL,
		[PHYSICIANS_CREATE_NEW_CODES] [int] NULL,
		[PHYSICIANS_MATCH_PHY_NUMBER] [int] NULL,
		[MEDICALSTAFF_FLAG] [int] NULL,
		[MEDICALSTAFF_IMPORT_SUPP] [int] NULL,
		[MEDICALSTAFF_VALIDATE_DATA] [int] NULL,
		[MEDICALSTAFF_CREATE_NEW_CODES] [int] NULL,
		[ADMINTRACK_FLAG] [int] NULL,
		[ADMINTRACK_AREA] [varchar](100)NULL,
		[ADMINTRACK_ADD_UPDATE] [int] NULL,
		[ADMINTRACK_CREATE_NEW_CODES] [int] NULL,
		[ADMINTRACK_MATCH_FIELD] [varchar](50) NULL,
		[ENTITIES_MATCH_BY_TAXID] [int] NULL,
		[ENTITIES_MATCH_BY_NAME] [int] NULL,
		[ENTITIES_MATCH_BY_Abbrev] [int] NULL,
		[DIARY_TO_USERS] [varchar](100) NULL,
	 CONSTRAINT [PK_DIS_OPTIONSET] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_EMP_X_DEPENDENT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_EMP_X_DEPENDENT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[EMPLOYEE_EID] [int] NULL,
		[DEPENDENT_EID] [int] NULL,
		[RELATION_CODE] [varchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_EMP_X_DEPENDENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_EMP_X_VIOLATION') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_EMP_X_VIOLATION](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[EMPLOYEE_EID] [int] NULL,
		[VIOLATION_CODE] [varchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_EMP_X_VIOLATION] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_EMPLOYEE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_EMPLOYEE](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[EMPLOYEE_EID] [varchar](50) NULL,
		[EMP_ENTITY_ID] [varchar](50) NULL,
		[SEC_DEPT_EID] [varchar](25) NULL,
		[DRIVLIC_STATE] [varchar](25) NULL,
		[MARITAL_STAT_CODE] [varchar](25) NULL,
		[POSITION_CODE]	[varchar](25) NULL,		
		[DEPT_ASSIGNED_EID] [varchar](50) NULL,
		[SUPERVISOR_EID] [varchar](25) NULL,
		[PAY_TYPE_CODE] [varchar](25) NULL,
		[DRIVERSLICTYPECODE] [varchar](25) NULL,
		[DRIVLIC_RSTRCTCODE] [varchar](25) NULL,
		[NCCI_CLASS_CODE] [varchar](25) NULL,
		[JOB_CLASS_CODE] [varchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_EMPLOYEE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_ENTITY') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_ENTITY](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[ENTITY_ID] [varchar](50) NULL,
		[ENTITY_TABLE_ID] [varchar](50) NULL,
		[SIC_CODE] [varchar](50) NULL,
		[PARENT_EID] [varchar](50) NULL,
		[PARENT_ABBREV] [varchar](50) NULL,
		[PARENT_1099_EID] [varchar](50) NULL,
		[SEC_DEPT_EID] [varchar](25) NULL,
		[ASSIGNADJ_EID] [varchar](25) NULL,
		[BUSINESS_TYPE_CODE] [varchar](25) NULL,
		[COST_CENTER_CODE] [varchar](25) NULL,
		[EMAIL_TYPE_CODE] [varchar](25) NULL,
		[SEX_CODE] [varchar](25) NULL,
		[STATE_ID] [varchar](25) NULL,
		[COUNTRY_CODE] [varchar](25) NULL,
		[NAICS_CODE] [varchar](25) NULL,
		[TIME_ZONE_CODE] [varchar](25) NULL,
		[ENTITY_APPROVAL_STATUS] [varchar] (25) NULL,
		[ORG_CURR_CODE] [varchar] (25) NULL,
		[PREFIX] [varchar] (25) NULL,
		[SUFFIX_COMMON] [varchar](25) NULL,
		[ID_TYPE] [varchar](25) NULL,
		[NAME_TYPE] [varchar](25) NULL,
		[RM_USER_ID] [int] NULL,
		[ORGANIZATION_TYPE] [varchar](25) NULL,
		[ADDRESS_TYPE_CODE] [varchar](25) NULL,		-- start kkaur25 14.2 enhancement
		[CONTACT_TYPE_CODE] [varchar](25) NULL,		
		[CONTACT_STATE_ID] [varchar](25) NULL,
		[ENTITY_ID_TYPE] [varchar](25) NULL,		--end kkaur25 14.2 enhancement
		[EXTERNAL_KEY] [varchar](50) NULL,
		[ENT_CATEGORY][varchar](25) NULL,
		[ENT_CATEGORY_PRNT][varchar](25) NULL,	
 CONSTRAINT [PK_T_DIS_ENTITY] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_ADDRESS_X_PHONEINFO') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_ADDRESS_X_PHONEINFO](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[ENTITY_ID] [int] NULL,
		[EXTERNAL_KEY] [varchar] (50) NULL,
	CONSTRAINT [PK_T_DIS_ADDRESS_X_PHONEINFO] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


/* IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_ENTITY_X_ADDRESSES') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_ENTITY_X_ADDRESSES](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[ENTITY_ID] [int] NULL,
		[EXTERNAL_KEY] [varchar] (50) NULL,
	CONSTRAINT [PK_T_DIS_ENTITY_X_ADDRESSES] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
*/

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_FUNDS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_FUNDS](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[UNIT_VIN] [varchar](50) NULL,
	[ACCOUNT] [varchar](20) NULL,
	[TRANS_TYPE] [char](1) NULL,
	[TAX_ID] [varchar](11) NULL,
	[UPDATE_RESERVES] [char](1) NULL,
	[CLAIMANT_FIRST] [varchar](255) NULL,
	[CLAIMANT_LAST] [varchar](255) NULL,
	[COUNTRY_CODE] [varchar](30) NULL,
	[CLAIM_STATUS_CODE] [int] NULL,
	[LINE_OF_BUS_CODE] [int] NULL,
	[TRANS_ID_SOURCE] [int] NULL,
	[SUB_ACCOUNT] [varchar](20) NULL,
	[STATUS_CODE] [varchar](25) NULL,
	[BILL_TYPE] [varchar](25) NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[PAYEE_TYPE_CODE] [varchar](25) NULL,
	[STATE_ID] [varchar](25) NULL,
	[PMT_CURRENCY_CODE][varchar](25) NULL,
	[CLAIM_CURRENCY_CODE][varchar](25) NULL,
	[DORMANCY_STATUS][varchar](25) NULL,
	[REISSUE_REASON_CODE] [varchar](25) NULL,
	[COUNTY] [varchar](30) NULL,
	[DSTRBN_TYPE_CODE] [varchar](25) NULL,
	[WEEKS_PAID_CODE][varchar](25) NULL,
		
	 CONSTRAINT [PK_T_DIS_FUNDS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_FUNDS_TRANS_SPLIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_FUNDS_TRANS_SPLIT](
		[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[TRANS_ID_SOURCE] [int] NULL,
	[TRANS_TYPE_CODE] [varchar](25) NULL,
	[RESERVE_TYPE_CODE] [varchar](25) NULL,
	[GL_ACCOUNT_CODE] [varchar](25) NULL,
	[UNIT_TYPE] [varchar](5) NULL,
	[POLICY_NAME] [varchar](20) NULL,
	[UNIT_NUMBER] [varchar](10) NULL,
	[COVERAGE_CODE] [varchar](25) NULL,
	[LOSS_DISABILITY_CODE] [varchar](25) NULL,
	[DISABILITY_TYPE_CATEGORY] [varchar](25) NULL,
	[MODULE_NO] [varchar](10) NULL,
	[CLASS_CODE] [varchar](50) NULL,
	[CVG_SEQUENCE_NO] [varchar](8) NULL,
	[TRANS_SEQ_NO] [varchar](8) NULL,
	[CVG_DESC] [varchar](50) NULL,
	[SUBLINE_DESC] [varchar](50) NULL,
	[CLASS_DESC] [varchar](50) NULL,
	[STAT_UNIT_NUMBER] [varchar](10) NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
	[COVERAGE_CODE_ID] [int] NULL,
	[LOSS_DISABILITY_CODE_ID] [int] NULL,
	[DIS_TYPE_CAT_CODE_ID] [int] NULL,
	[CLAIM_ID] [int] NULL,
	[CLAIM_LOB] [int] NULL,
	
	
	 CONSTRAINT [PK_T_DIS_FUNDS_TRANS_SPLIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_MED_STAFF') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_MED_STAFF](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[PRIMARY_POLICY_ID] [varchar](50) NULL,
		[DEPT_ASSIGNED_EID] [varchar](50) NULL,
		--sbhayana START MITS # 36735 
		[HOME_STATE_ID] [varchar](25) NULL,
		[LIC_STATE] [varchar](25) NULL,
		[MARITAL_STAT_CODE] [varchar](25) NULL,
		[STAFF_STATUS_CODE] [varchar](25) NULL,
		[STAFF_POS_CODE] [varchar](25) NULL,
		[STAFF_CAT_CODE] [varchar](25) NULL,
		--sbhayana END MITS # 36735
	 CONSTRAINT [PK_T_DIS_MED_STAFF] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_STAFF_CERTS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_STAFF_CERTS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[MED_STAFF_NUMBER] [varchar](50) NULL,
		--sbhayana START MITS # 36735 
		[NAME_CODE] [varchar](25) NULL,
		--sbhayana START MITS # 36735 
	 CONSTRAINT [PK_T_DIS_STAFF_CERTS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_STAFF_PRIVS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_STAFF_PRIVS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[MED_STAFF_NUMBER] [varchar](50) NULL,
		--sbhayana START MITS # 36735 
		[CATEGORY_CODE] [varchar](25) NULL,
		[TYPE_CODE] [varchar](25) NULL,
		[STATUS_CODE] [varchar](25) NULL,
		--sbhayana START MITS # 36735 
	 CONSTRAINT [PK_T_DIS_STAFF_PRIVS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_ENTITY_EXPOSURE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_ENTITY_EXPOSURE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[ORG_TABLE_ID] [int] NULL,
	 CONSTRAINT [PK_T_DIS_ENTITY_EXPOSURE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_ORG_HIER') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_ORG_HIER](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[ENTITY_ID_SOURCE] [int] NULL,
		[ENTITY_TABLE_DESC] [varchar](18) NULL,
		[PARENT_EID_SOURCE] [int] NULL,
		[PARENT_ABBREV_DESC] [varchar](25) NULL,
		[BUSINESS_TYPE_CODE] [varchar](25) NULL,				
		[COST_CENTER_CODE] [varchar](25) NULL,		
		[COUNTRY_CODE] [varchar](25) NULL,
		[EMAIL_TYPE_CODE] [varchar](25) NULL,
		[STATE_ID] [varchar](25) NULL,		
		[SIC_CODE] [varchar](25) NULL,
		[NAICS_CODE] [varchar](25) NULL,		
		[ORGANIZATION_TYPE] [varchar](25) NULL,
		[ADDRESS_TYPE_CODE] [varchar](25) NULL,
		[CONTACT_TYPE_CODE] [varchar](25) NULL,
		[CONTACT_STATE_ID] [varchar](25) NULL,
		[ENTITY_ID_TYPE] [varchar](25) NULL,
		[ENTITY_TABLE_ID] int NULL,
	 CONSTRAINT [PK_T_DIS_ORG_HIER] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		[FACILITY_DEPT_EID] [varchar](50) NULL,
		[PRI_PHYS_NUMBER] [varchar](50) NULL,
		[ADM_PHYS_NUMBER] [varchar](50) NULL,
		[PRI_PHYS_LAST_NAME] [varchar](255) NULL,
		[PRI_PHYS_FIRST_NAME] [varchar](255) NULL,
		[PRI_PHYS_TAX_ID] [varchar](50) NULL,
		[ADM_PHYS_LAST_NAME] [varchar](255) NULL,
		[ADM_PHYS_FIRST_NAME] [varchar](255) NULL,
		[ADM_PHYS_TAX_ID] [varchar](50) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		--sbhayana START MITS # 36734 
		[ACUITY_LEVEL_CODE] [varchar](25) NULL,
		[ADM_SOURCE_CODE] [varchar](25) NULL,
		[ADM_TYPE_CODE] [varchar](25) NULL,
		[DISCHARGE_DSP_CODE] [varchar](25) NULL,
		[FACILITY_UNIT_CODE] [varchar](25) NULL,
		[MARITAL_STAT_CODE] [varchar](25) NULL,
		[PATIENT_COND_CODE] [varchar](25) NULL,
		[PATIENT_STAT_CODE] [varchar](25) NULL,
		[PATIENT_TYPE_CODE] [varchar](25) NULL,
		[PRIMARY_PAY_CODE] [varchar](25) NULL,
		[QI_SIGNIF_CODE] [varchar](25) NULL,
		[RACE_ENTH_CODE] [varchar](25) NULL,
		[SECOND_PAY_CODE] [varchar](25) NULL,
		[NB_NICU_STAY] [varchar](1) NULL,
		[NB_CEPHALIC_MOLD] [varchar](1) NULL,
		[NBM_PRIOR_C_SECT] [varchar](1) NULL,
		[NBM_MED_IND_LABOR] [varchar](1) NULL,
		[DISABILITY_CODE] [varchar](25) NULL,
		[ILLNESS_CODE] [varchar](25) NULL,	
		--sbhayana END MITS # 36734 
	 CONSTRAINT [PK_T_DIS_PATIENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT_ACT_TAKEN') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT_ACT_TAKEN](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		--sbhayana START MITS # 36734 
		[ACTION_CODE] [varchar](25) NULL,
		--sbhayana END MITS # 36734 
	 CONSTRAINT [PK_T_DIS_PATIENT_ACT_TAKEN] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT_ATTN_PHYS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT_ATTN_PHYS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		[PHYS_LAST_NAME] [varchar](255) NULL,
		[PHYS_FIRST_NAME] [varchar](255) NULL,
		[PHYS_TAX_ID] [varchar](50) NULL,
		[PHYS_NUMBER] [varchar](50) NULL,
	 CONSTRAINT [PK_T_DIS_PATIENT_ATTN_PHYS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT_DIAGNOSIS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT_DIAGNOSIS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		--sbhayana START MITS # 36734 
		[DIAGNOSIS_CODE] [varchar](25) NULL,
		--sbhayana END MITS # 36734 
	 CONSTRAINT [PK_T_DIS_PATIENT_DIAGNOSIS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT_DRG_CODES') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT_DRG_CODES](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		--sbhayana START MITS # 36734 
		[DRG_CODE] [varchar](25) NULL,
		--sbhayana END MITS # 36734 
	 CONSTRAINT [PK_T_DIS_PATIENT_DRG_CODES] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PATIENT_PROCEDURE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PATIENT_PROCEDURE](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		[SURGEON_PHYS_NUMBER] [varchar](50) NULL,
		[SURGEON_LAST_NAME] [varchar](255) NULL,
		[SURGEON_FIRST_NAME] [varchar](255) NULL,
		[SURGEON_TAX_ID] [varchar](50) NULL,
		[ANESTH_LAST_NAME] [varchar](255) NULL,
		[ANESTH_FIRST_NAME] [varchar](255) NULL,
		[ANESTH_TAX_ID] [varchar](50) NULL,
		--sbhayana START MITS # 36734 
		[PROCEDURE_CODE] [varchar](25) NULL,
		[PROC_TYPE_CODE] [varchar](25) NULL,
		[ANESTH_TYPE_CODE] [varchar](25) NULL,
		[ASA_PS_CLASS_CODE] [varchar](25) NULL,
		[ICC_LEVEL_CODE] [varchar](25) NULL,
		--sbhayana END MITS # 36734 
	 CONSTRAINT [PK_T_DIS_PATIENT_PROCEDURE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYSICIAN') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYSICIAN](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		[DEPT_ASSIGNED_EID] [varchar](50) NULL,
		[PRIMARY_POLICY_NUMBER] [varchar](50) NULL,
		[PARENT_1099_PHYSICIAN_NUMBER] [varchar](50) NULL,
		[PARENT_1099_TABLE_NAME] [varchar](50) NULL,
		[PARENT_1099_LAST_NAME] [varchar](255) NULL,
		[PARENT_1099_TAX_ID] [varchar](50) NULL,
		[MARITAL_STAT_CODE] [varchar](25) NULL,
		[HOME_STATE_ID] [varchar](25) NULL,
		[MAILING_STATE_ID] [varchar](25) NULL,
		[STAFF_STATUS_CODE] [varchar](25) NULL,
		[STAFF_TYPE_CODE] [varchar](25) NULL,
		[STAFF_CAT_CODE] [varchar](25) NULL,
		[LIC_STATE] [varchar](25) NULL,
		[PRIMARY_SPECIALTY] [varchar](25) NULL,
	CONSTRAINT [PK_T_DIS_PHYSICIAN] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYS_SUB_SPECIALTY') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYS_SUB_SPECIALTY](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] varchar(50) NULL,
		[SPECIALTY_CODE] varchar(50) NULL
	CONSTRAINT [PK_T_DIS_PHYS_SUB_SPECIALTY] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYS_PRIVS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYS_PRIVS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] varchar(50) NULL,
		[CATEGORY_CODE] [nvarchar](25) NULL,
		[TYPE_CODE] [nvarchar](25) NULL,
		[STATUS_CODE] [nvarchar](25) NULL,
	CONSTRAINT [PK_T_DIS_PHYS_PRIVS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYS_CERTS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYS_CERTS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] varchar(50) NULL,
		[NAME_CODE] [nvarchar](25) NULL,
		[STATUS_CODE] [nvarchar](25) NULL,
		[BOARD_CODE] [nvarchar](25) NULL,
	CONSTRAINT [PK_T_DIS_PHYS_CERTS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYS_EDUCATION') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYS_EDUCATION](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [nvarchar](50) NULL,
		[EDUC_TYPE_CODE] [nvarchar](25) NULL,
		[INSTITUTION_NAME] varchar(255) NULL,
		[DEGREE_TYPE] [nvarchar](25) NULL,
	CONSTRAINT [PK_T_DIS_PHYS_EDUCATION] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PHYS_PREV_HOSP') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PHYS_PREV_HOSP](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[KEY_FIELD_VALUE] [varchar](50) NULL,
		[STATUS_CODE] [nvarchar](25) NULL,
		[HOSPITAL_NAME] [nvarchar](255) NULL,
		[PRIV_CODE] [nvarchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_PHYS_PREV_HOSP] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POLICY') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_POLICY](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int]  NULL,
		[POLICY_STATUS_CODE] [varchar](6) NULL,
		[INSURER_EID][varchar](25)  NULL,
		[BROKER_EID] [varchar](25) NULL,
		[POLICY_SYSTEM_NAME] [varchar](100) NULL,
		[POLICY_TYPE] [varchar](25) NULL,
		[CURRENCY_CODE] [varchar](25) NULL,
		[POLICY_LOB_CODE] [varchar](25) NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
		[BRANCH_CODE] [varchar] (50) NULL, 
		[CLAIM_ID][int] NULL, 		
	 CONSTRAINT [PK_T_DIS_POLICY] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POLICY_X_CVG_TYPE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_POLICY_X_CVG_TYPE](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int] NULL,
		[POLCVG_ROW_ID] [int] NULL,
		[COVERAGE_TYPE_CODE] [varchar](25) NULL,
		[NEXT_POLICY_ID] [int] NULL,
		[SECTION_NUMBER_CODE] [varchar](25) NULL,
		[UNIT_ID] [int] NULL,
		[COVERAGE_CODE_DESCRIPTION] [varchar](100) NULL,
		[CLASS_CODE_DESCRIPTION] [varchar](100) NULL,
		[COVERAGE_CLASS_CODE] [varchar](20) NULL,
		[SUBLINE_DESCRIPTION] [varchar](100) NULL,
		[REINSURANCE_CODE] [varchar](25) NULL,
	 CONSTRAINT [PK_T_POLICY_X_CVG_TYPE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POLICY_X_INSURED') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_POLICY_X_INSURED](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int]  NULL,
		[LAST_NAME] [varchar](255) NULL,
		[FIRST_NAME] [varchar](255) NULL,	
		[TAX_ID] [varchar](20) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[ORG_LEVEL] [int]  NULL,
		[ORG_LEVEL_PARENT_ABBREVIATION] [varchar](25) NULL,
		[CLIENT_SEQ_NUM] [varchar](30) NULL, 		
	 CONSTRAINT [PK_T_DIS_POLICY_X_INSURED] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POLICY_X_INSURER') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_POLICY_X_INSURER](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int] NULL,
		[INSURER_CODE] [int] NULL,
		[INSTAL_SCHEDULE_CODE] [varchar](25) NULL,
		[LAYER_NUM_CODE] [varchar](25) NULL,
		[LAST_NAME] [varchar](255) NULL,
		[FIRST_NAME] [varchar](255)NULL,	
		[TAX_ID] [varchar](20) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[PRIMARY_INSURER] int NULL,
		[CLIENT_SEQ_NUM] [varchar](30) NULL, 	
		
	 CONSTRAINT [PK_T_DIS_POLICY_X_INSURER] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_RESERVE_CURRENT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_RESERVE_CURRENT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[CLAIM_NUMBER] [varchar](50) NULL,
		[UNIT_VIN] [varchar](50) NULL,
		[RESERVE_TYPE_CODE_DESC] [varchar](25) NULL,
		[CLAIMANT_FIRST_NAME] [varchar](255) NULL,
		[CLAIMANT_LAST_NAME] [varchar](255) NULL,
		[LINE_OF_BUS_CODE] [int] NULL,
		[RESERVE_ID] [int] NULL,
		[RESERVE_DATE] [varchar](8) NULL,
		[CLAIM_STATUS_CODE] [int] NULL,
		[RESERVE_TRACKING] [int] NULL,
		[CHANGE_AMOUNT] [float] NULL,
		[UPDATE_RESERVES] [int] NULL,
		[COLL_IN_RSV_BAL] [int] NULL,
		[COLL_IN_INC_BAL] [int] NULL,
		[CHK_DUPLICATE_RSV] [int] NULL,
		[UNIT_TYPE] [nvarchar](25) NULL,
		[POLICY_NAME] [nvarchar](25) NULL,
		[UNIT_NUMBER] [nvarchar](25) NULL,
		[COVERAGE_CODE] [nvarchar](25) NULL,
		[LOSS_DISABILITY_CODE] [nvarchar](25) NULL,
		[RESERVE_SUB_TYPE] [nvarchar](25) NULL,
		[DISABILITY_TYPE_CATEGORY] [nvarchar](25) NULL,
		[MODULE_NO] [nvarchar](25) NULL,
		[CLASS_CODE] [nvarchar](25) NULL,
		[CVG_SEQUENCE_NO] [nvarchar](25) NULL,
		[TRANS_SEQ_NO] [nvarchar](25) NULL,
		[CVG_DESC] [nvarchar](100) NULL,
		[SUBLINE_DESC] [nvarchar](100) NULL,
		[CLASS_DESC] [nvarchar](100) NULL,
		[STAT_UNIT_NUMBER] [nvarchar](25) NULL,
		[POLICY_CVG_SEQNO] [nvarchar](25) NULL,
		[POLCVG_LOSS_ROW_ID] [nvarchar](25) NULL,
		[COVERAGE_CODE_SRC] [nvarchar](25) NULL,
		[POLCVG_ROW_ID] [nvarchar](25) NULL,
		[RESERVE_TYPE_CODE] [nvarchar](25) NULL,
		[RES_STATUS_CODE] [nvarchar](25) NULL,
		[COVERAGE_CODE_ID] [int] NULL,
		[LOSS_DISABILITY_CODE_ID] [int] NULL,
		[RESERVE_SUB_TYPE_ID] [int] NULL,
		[DISABILITY_TYPE_CATEGORY_ID] [int] NULL,
		[ADJ_FIRST_NAME] [varchar](255) NULL,
		[ADJ_LAST_NAME] [varchar](255) NULL,
		[ADJ_TAX_ID] [varchar](20) NULL,
	 CONSTRAINT [PK_T_DIS_RESERVE_CURRENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_UNIT_X_CLAIM') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_UNIT_X_CLAIM](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[SOURCE_UNIT_ID] [int] NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
		[HOME_DEPT_EID] [varchar](50) NULL,
		[STATE_ID] [varchar](6) NULL,
		[UNIT_TYPE_CODE] [varchar](25) NULL,
		[UNIT_ID] [int] NULL,
		[OWNER_LAST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[OWNER_FIRST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[OWNER_TAXID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[POLICYHOLDER_LAST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[POLICYHOLDER_FIRST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[POLICYHOLDER_TAXID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[COMPANY_LAST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[COMPANY_FIRST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[COMPANY_TAXID] [nvarchar](20) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[ASSIGNADJ_LAST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[ASSIGNADJ_FIRST_NAME] [nvarchar](255) NULL, -- Newly Added - 23Jun2014 - Kapil  --
		[ASSIGNADJ_TAXID] [nvarchar](20) NULL -- Newly Added - 23Jun2014 - Kapil  --
	 CONSTRAINT [PK_T_DIS_UNIT_X_CLAIM] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_VEHICLE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_VEHICLE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[SOURCE_UNIT_ID] [int] NULL,
		[LEASING_CO_EID_DESC] [varchar](50) NULL,
		[HOME_DEPT_EID_DESC] [varchar](50) NULL,
		[STATE_ID] [varchar](6) NULL,
		[UNIT_TYPE_CODE] [varchar](25) NULL,
		[UNIT_ID][int] NULL,
	 CONSTRAINT [PK_T_DIS_VEHICLE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_VEHICLE_X_ACC_DATE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_VEHICLE_X_ACC_DATE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[SOURCE_UNIT_ID] [int] NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_VEHICLE_X_ACC_DATE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_VEHICLE_X_INSPCT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_VEHICLE_X_INSPCT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[SOURCE_UNIT_ID] [int] NULL,
	 CONSTRAINT [PK_T_DIS_VEHICLE_X_INSPCT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

--------------------------
--VGUPTA20  --NEW TABLES

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_INPUT') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_INPUT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[ISVALIDATE] [int] NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[RECORD_TYPE] [varchar](1) NULL,
		[CLAIM_SUFFIX] [varchar](3) NULL,
		[CLAIM_TYPE] [varchar](25) NULL,
		[DIVISION] [varchar](25) NULL,
		[LOCATION] [varchar](25) NULL,
		[DEPARTMENT] [varchar](25) NULL,
		[COMPANY] [varchar](25) NULL,
		[COUNTRY] [varchar](20) NULL,
		[DIVISION_DESC] [varchar](50) NULL,
		[LOCATION_DESC] [varchar](50) NULL,
		[DEPARTMENT_DESC] [varchar](50) NULL,
		[COMPANY_DESC] [varchar](50) NULL,
		[COUNTRY_DESC] [varchar](24) NULL,
		[DATE_OF_LOSS] [varchar](8) NULL,
		[DATE_REPORTED] [varchar](8) NULL,
		[DATE_OF_CLAIM] [varchar](8) NULL,
		[DATE_CLOSED] [varchar](8) NULL,
		[DATE_REOPENED] [varchar](8) NULL,
		[CLAIM_STATUS] [varchar](25) NULL,
		[RESERVE_A_OPENING] [varchar](20) NULL,
		[RESERVE_A_CURRENT] [varchar](20) NULL,
		[RESERVE_A_DATE] [varchar](8) NULL,
		[PAID_A_TOTAL] [varchar](20) NULL,
		[COLLECTION_A_TOTAL] [varchar](20) NULL,
		[RESERVE_B_OPENING] [varchar](20) NULL,
		[RESERVE_B_CURRENT] [varchar](20) NULL,
		[RESERVE_B_DATE] [varchar](8) NULL,
		[PAID_B_TOTAL] [varchar](20) NULL,
		[COLLECTION_B_TOTAL] [varchar](20) NULL,
		[RESERVE_C_OPENING] [varchar](20) NULL,
		[RESERVE_C_CURRENT] [varchar](20) NULL,
		[RESERVE_C_DATE] [varchar](8) NULL,
		[PAID_C_TOTAL] [varchar](20) NULL,
		[COLLECTION_C_TOTAL] [varchar](20) NULL,
		[RESERVE_D_OPENING] [varchar](20) NULL,
		[RESERVE_D_CURRENT] [varchar](20) NULL,
		[RESERVE_D_DATE] [varchar](8) NULL,
		[PAID_D_TOTAL] [varchar](20) NULL,
		[COLLECTION_D_TOTAL] [varchar](20) NULL,
		[CAUSE_CODE] [varchar](25) NULL,
		[CLAIMANT_LASTNAME] [varchar](50) NULL,
		[CLAIMANT_FIRSTNAME] [varchar](50) NULL,
		[CLAIMANT_SSN] [varchar](11) NULL,
		[CLAIMANT_ADDRESS] [varchar](91) NULL,
		[CLAIMANT_CITY] [varchar](50) NULL,
		[CLAIMANT_STATE] [varchar](4) NULL,
		[CLAIMANT_ZIP] [varchar](9) NULL,
		[CLAIMANT_SEX] [varchar](8) NULL,
		[CLAIMANT_DOB] [varchar](8) NULL,
		[CLAIMANT_PHONE] [varchar](30) NULL,
		[CLAIMANT_COMMENT] [text] NULL,
		[DEF_LASTNAME] [varchar](50) NULL,
		[DEF_FIRSTNAME] [varchar](50) NULL,
		[DEF_ADDRESS] [varchar](50) NULL,
		[DEF_CITY] [varchar](50) NULL,
		[DEF_STATE] [varchar](4) NULL,
		[DEF_ZIP] [varchar](9) NULL,
		[DEF_PHONE] [varchar](30) NULL,
		[DEF_COMMENT] [text] NULL,
		[CLOSURE_METHOD] [varchar](25) NULL,
		[DESCRIPTION] [text] NULL,
		[SERVICE] [varchar](25) NULL,
		[DIAGNOSIS] [varchar](25) NULL,
		[POLICY_NUMBER] [varchar](20) NULL,
		[POLICY_EFFECT_DATE] [varchar](8) NULL,
		[POLICY_EXPIRE_DATE] [varchar](8) NULL,
		[SUIT_DATE] [varchar](8) NULL,
		[CASE_NUMBER] [varchar](15) NULL,
		[EVENT_NUMBER] [varchar](25) NULL,
		[COMMENTS] [text] NULL,
		[ILLNESS_CODE] [varchar](25) NULL,
		[INJURY_CODE] [varchar](25) NULL,
		[BODY_PART] [varchar](25) NULL,
		[EMP_DEPARTMENT] [varchar](25) NULL,
		[OCCUPATION] [varchar](18) NULL,
		[DATE_OF_BIRTH] [varchar](8) NULL,
		[DATE_OF_HIRE] [varchar](8) NULL,
		[DATE_OF_DEATH] [varchar](8) NULL,
		[OSHA_RECORDABLE] [varchar](1) NULL,
		[EMPLOYEE_SEX] [varchar](8) NULL,
		[WEEKLY_WAGE_RATE] [varchar](12) NULL,
		[HOURLY_WAGE_RATE] [varchar](12) NULL,
		[WEEKLY_HOURS] [varchar](12) NULL,
		[NCCI_CLASS_CODE] [varchar](25) NULL,
		[ACCIDENT_STATE] [varchar](4) NULL,
		[MARITAL_STATUS] [varchar](8) NULL,
		[DEPENDENT_LNAME] [varchar](50) NULL,
		[DEPENDENT_FNAME] [varchar](50) NULL,
		[DEPENDENT_BIRTH_DT] [varchar](8) NULL,
		[LICENSE_NUMBER] [varchar](22) NULL,
		[LICENSE_EXPIR_DATE] [varchar](8) NULL,
		[LICENSE_TYPE] [varchar](25) NULL,
		[LICENSE_RESTRICT] [varchar](25) NULL,
		[RETURN_WORK_DATE] [varchar](8) NULL,
		[ACTIVE_FLAG] [varchar](1) NULL,
		[EMPLOYER_SIC_CODE] [varchar](4) NULL,
		[EMPLOYER_PAYROLL_CLASS_CODE] [varchar](1) NULL,
		[VEHICLE_ID] [varchar](20) NULL,
		[VEHICLE_YEAR] [varchar](4) NULL,
		[VEHICLE_MAKE] [varchar](20) NULL,
		[EMPLOYEE_ID] [varchar](20) NULL,
		[VEHICLE_MODEL] [varchar](32) NULL,
		[FILE_NUMBER] [varchar](32) NULL,
		[DATE_LAST_WORKED] [varchar](8) NULL,
		[CLAIMANT_MIDDLENAME] [varchar](50) NULL,
		[ACCIDENT_DESC] [varchar](25) NULL,
		[ACCIDENT_PREVENTABLE] [varchar](1) NULL,
		[USER_FIELD_B] [varchar](255) NULL,
		[USER_FIELD_C] [varchar](255) NULL,
		[USER_FIELD_D] [varchar](255) NULL,
		[USER_FIELD_E] [varchar](255) NULL,
		[USER_FIELD_F] [varchar](255) NULL,
		[USER_FIELD_G] [varchar](255) NULL,
		[USER_FIELD_H] [varchar](255) NULL,
		[USER_FIELD_I] [varchar](255) NULL,
		[USER_FIELD_J] [varchar](255) NULL,
		[USER_FIELD_K] [varchar](255) NULL,
		[USER_FIELD_L] [varchar](255) NULL,
		[USER_FIELD_M] [varchar](255) NULL,
		[USER_FIELD_N] [varchar](255) NULL,
		[USER_FIELD_O] [varchar](255) NULL,
		[USER_FIELD_P] [varchar](255) NULL,
		[USER_FIELD_Q] [varchar](255) NULL,
		[USER_FIELD_R] [varchar](255) NULL,
		[USER_FIELD_S] [varchar](255) NULL,
		[USER_FIELD_T] [varchar](255) NULL,
		[CLAIM_TYPE_ID] [int] NULL,
		[CLAIM_TYPE_TABLE_NAME] [varchar](30) NULL,
		[CLAIM_STATUS_ID] [int] NULL,
		[CLAIM_STATUS_TABLE_NAME] [varchar](30) NULL,
		[CAUSE_CODE_ID] [int] NULL,
		[CAUSE_CODE_TABLE_NAME] [varchar](30) NULL,
		[CLOSURE_METHOD_ID] [int] NULL,
		[CLOSURE_METHOD_TABLE_NAME] [varchar](30) NULL,
		[SERVICE_ID] [int] NULL,
		[SERVICE_TABLE_NAME] [varchar](30) NULL,
		[ILLNESS_CODE_ID] [int] NULL,
		[ILLNESS_CODE_TABLE_NAME] [varchar](30) NULL,
		[OCCUPATION_TABLE_NAME] [varchar](30) NULL,
		[NCCI_CLASS_CODE_ID] [int] NULL,
		[NCCI_CLASS_CODE_TABLE_NAME] [varchar](30) NULL,
		[MARITAL_STATUS_ID] [int] NULL,
		[MARITAL_STATUS_TABLE_NAME] [varchar](30) NULL,
		[PLAN_NAME] [varchar](20) NULL,
		[CLASS_NAME] [varchar](20) NULL,
		[DISABIL_FROM_DATE] [varchar](8) NULL,
		[DISABIL_TO_DATE] [varchar](8) NULL,
		[BENEFITS_START] [varchar](8) NULL,
		[BENEFITS_THROUGH] [varchar](8) NULL,
		[DIS_TYPE] [varchar](25) NULL,
		[BEN_CALC_PAY_START] [varchar](8) NULL,
		[BEN_CALC_PAY_TO] [varchar](8) NULL,
		[FEDERAL_TAX_FLAG] [varchar](1) NULL,
		[SOCIAL_SEC_TAX_FLAG] [varchar](1) NULL,
		[MEDICARE_TAX_FLAG] [varchar](1) NULL,
		[STATE_TAX_FLAG] [varchar](1) NULL,
		[STD_DISABIL_TYPE] [varchar](25) NULL,
		[MONTHLY_RATE] [varchar](8) NULL,
		[ELIG_DIS_BEN_FLAG] [varchar](1) NULL,
		[DIS_OPTION_CODE] [varchar](25) NULL,
		[PENSION_AMT] [varchar](8) NULL,
		[SS_AMT] [varchar](8) NULL,
		[OTHER_AMT] [varchar](8) NULL,
		[TIME_OF_CLAIM] [varchar](6) NULL,
		[CLAIMANT_BIRTH_DT] [varchar](8) NULL,
		[user_field_a] [varchar](255) NULL,
		[OCCUPATION_ID] [int] NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
		[CLAIM_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[STAGING_CLAIM_ID] [int] NULL,
		[STAGING_LOCATION_EID] [int] NULL,
		[STAGING_FACILITY_EID] [int] NULL,
		[STAGING_DIVISION_EID] [int] NULL,
		[STAGING_OPERATION_EID] [int] NULL,
		[STAGING_COMPANY_EID] [int] NULL,
		[STAGING_DEPARTMENT_EID] [int] NULL,
		[STAGING_REGION_EID] [int] NULL,
		[STAGING_CLIENT_EID] [int] NULL,
		[BODY_PART_1_CODE] [varchar](50) NULL,
		[BODY_PART_1_CODE_ID] [int] NULL,
		[BODY_PART_1_CODE_TABLE_NAME] [varchar](50) NULL,
		[BODY_PART_2_CODE] [varchar](50) NULL,
		[BODY_PART_2_CODE_ID] [int] NULL,
		[BODY_PART_2_CODE_TABLE_NAME] [varchar](50) NULL,
		[BODY_PART_3_CODE] [varchar](50) NULL,
		[BODY_PART_3_CODE_ID] [int] NULL,
		[BODY_PART_3_CODE_TABLE_NAME] [varchar](50) NULL,
		[BODY_PART_4_CODE] [varchar](50) NULL,
		[BODY_PART_4_CODE_ID] [int] NULL,
		[BODY_PART_4_CODE_TABLE_NAME] [varchar](50) NULL,
		[BODY_PART_5_CODE] [varchar](50) NULL,
		[BODY_PART_5_CODE_ID] [int] NULL,
		[BODY_PART_5_CODE_TABLE_NAME] [varchar](50) NULL,
		[DIAGNOSIS_1_CODE] [varchar](50) NULL,
		[DIAGNOSIS_1_CODE_ID] [int] NULL,
		[DIAGNOSIS_1_CODE_TABLE_NAME] [varchar](50) NULL,
		[DIAGNOSIS_2_CODE] [varchar](50) NULL,
		[DIAGNOSIS_2_CODE_ID] [int] NULL,
		[DIAGNOSIS_2_CODE_TABLE_NAME] [varchar](50) NULL,
		[DIAGNOSIS_3_CODE] [varchar](50) NULL,
		[DIAGNOSIS_3_CODE_ID] [int] NULL,
		[DIAGNOSIS_3_CODE_TABLE_NAME] [varchar](50) NULL,
		[DIAGNOSIS_4_CODE] [varchar](50) NULL,
		[DIAGNOSIS_4_CODE_ID] [int] NULL,
		[DIAGNOSIS_4_CODE_TABLE_NAME] [varchar](50) NULL,
		[DIAGNOSIS_5_CODE] [varchar](50) NULL,
		[DIAGNOSIS_5_CODE_ID] [int] NULL,
		[DIAGNOSIS_5_CODE_TABLE_NAME] [varchar](50) NULL,
		[INJURY_1_CODE] [varchar](50) NULL,
		[INJURY_1_CODE_ID] [int] NULL,
		[INJURY_1_CODE_TABLE_NAME] [varchar](50) NULL,
		[INJURY_2_CODE] [varchar](50) NULL,
		[INJURY_2_CODE_ID] [int] NULL,
		[INJURY_2_CODE_TABLE_NAME] [varchar](50) NULL,
		[INJURY_3_CODE] [varchar](50) NULL,
		[INJURY_3_CODE_ID] [int] NULL,
		[INJURY_3_CODE_TABLE_NAME] [varchar](50) NULL,
		[INJURY_4_CODE] [varchar](50) NULL,
		[INJURY_4_CODE_ID] [int] NULL,
		[INJURY_4_CODE_TABLE_NAME] [varchar](50) NULL,
		[INJURY_5_CODE] [varchar](50) NULL,
		[INJURY_5_CODE_ID] [int] NULL,
		[INJURY_5_CODE_TABLE_NAME] [varchar](50) NULL,
		[STAGING_POLICY_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIM_INPUT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DDS_ADJUSTER_TEXT_INPUT') 
BEGIN
CREATE TABLE [dbo].[DDS_ADJUSTER_TEXT_INPUT](
		[RECORD_TYPE] [varchar](50) NULL,
		[RECORD_TYPE_CODE_ID] [int] NULL,
		[RECORD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[CLAIM_ID] [int] NULL,
		[CLAIM_NUMBER] [varchar](25) NULL,
		[DATE] [varchar](8) NULL,
		[TIME] [varchar](6) NULL,
		[ADJUSTER_FIRST] [varchar](50) NULL,
		[ADJUSTER_LAST] [varchar](50) NULL,
		[TEXT] [varchar](8000) NULL,
		[JOBID] [int] NOT NULL,
		[INVALID_ROW] [int] NULL,
		[INPUT_ROW_ID] [int] NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[UPDATE_ROW] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_DDS_ADJUSTER_TEXT_INPUT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DDS_ENHANCED_NOTES_INPUT') 
BEGIN
	CREATE TABLE [dbo].[DDS_ENHANCED_NOTES_INPUT](
		[ID] [varchar](50) NULL,
		[CLAIM_OR_EVENT] [varchar](50) NULL,
		[NOTE_TYPE] [varchar](25) NULL,
		[NOTE_TYPE_CODE_ID] [varchar](25) NULL,
		[NOTE_TYPE_TABLE_NAME] [varchar](50) NULL,
		[USER_TYPE] [varchar](25) NULL,
		[USER_TYPE_CODE_ID] [varchar](25) NULL,
		[USER_TYPE_TABLE_NAME] [varchar](51) NULL,
		[NOTE_MEMO] [varchar](8000) NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INVALID_ROW] [int] NULL,
		[INPUT_ROW_ID] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[EVENT_ID] [int] NULL,
	 CONSTRAINT [PK_DDS_ENHANCED_NOTES_INPUT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DEFENDANT') 
BEGIN
	CREATE TABLE [dbo].[DEFENDANT](
		[DEFENDANT_ROW_ID] [int] NULL,
		[CLAIM_ID] [int] NULL,
		[DEFENDANT_EID] [int] NULL,
		[INSURER_EID] [int] NULL,
		[ATTORNEY_EID] [int] NULL,
		[POLICY_NUMBER] [varchar](30) NULL,
		[POLICY_TYPE_CODE] [int] NULL,
		[POLICY_LIMIT] [float] NULL,
		[POL_EXPIRE_DATE] [varchar](8) NULL,
		[DFNDNT_TYPE_CODE] [int] NULL,
		[COMMENTS] [text] NULL,
		[HTMLCOMMENTS] [text] NULL,
		[ISO_CODE] [int] NULL,
		[AFFENT_APPORTIONMENT] [int] NULL,
		[PRIMARY_LOSS_CAUSE] [int] NULL,
		[SECONDARY_LOSS_CAUSE] [int] NULL,
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
	 CONSTRAINT [PK_DEFENDANT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DISABILITY_CLASS_INPUT') 
BEGIN
	CREATE TABLE [dbo].[DISABILITY_CLASS_INPUT](
		[CLASS_NAME] [varchar](50) NULL,
		[CLASS_DESC] [varchar](50) NULL,
		[PLAN_NUMBER] [varchar](50) NULL,
		[STAGING_CLASS_ROW_ID] [int] NULL,
		[ELIG_BENE_PRD] [varchar](50) NULL,
		[BENE_PRD_TYPE] [varchar](50) NULL,
		[BENE_PRD_TYPE_CODE_ID] [int] NULL,
		[BENE_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[BENE_FROM_DT_TYPE] [varchar](50) NULL,
		[BENE_FROM_DT_TYPE_CODE_ID] [int] NULL,
		[BENE_FROM_DT_TYPE_TABLE_NAME] [varchar](50) NULL,
		[DIS_WAIT_PRD] [varchar](50) NULL,
		[DIS_CLNDR_WRK_TYPE] [varchar](50) NULL,
		[DIS_CLNDR_WRK_TYPE_CODE_ID] [int] NULL,
		[DIS_CLNDR_WRK_TYPE_TABLE_NAME] [varchar](50) NULL,
		[DIS_PRD_TYPE] [varchar](50) NULL,
		[DIS_PRD_TYPE_CODE_ID] [int] NULL,
		[DIS_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[DIS_MAX_PRD] [varchar](50) NULL,
		[DIS_MAX_PRD_TYPE] [varchar](50) NULL,
		[DIS_MAX_PRD_TYPE_CODE_ID] [int] NULL,
		[DIS_MAX_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[FROM_DIS_PRD_TYPE] [varchar](50) NULL,
		[FROM_DIS_PRD_TYPE_CODE_ID] [int] NULL,
		[FROM_DIS_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[ALLOW_EXT] [varchar](50) NULL,
		[EXTEND_PRD] [varchar](50) NULL,
		[EXTEND_PRD_TYPE] [varchar](50) NULL,
		[EXTEND_PRD_TYPE_CODE_ID] [int] NULL,
		[EXTEND_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[MAX_TOT_DIS_PRD] [varchar](50) NULL,
		[MAX_TOT_PRD_TYPE] [varchar](50) NULL,
		[MAX_TOT_PRD_TYPE_CODE_ID] [int] NULL,
		[MAX_TOT_PRD_TYPE_TABLE_NAME] [varchar](50) NULL,
		[ACTUAL_WORK_WEEK_FLAG] [varchar](50) NULL,
		[DAY7_WORK_WEEK_FLAG] [varchar](50) NULL,
		[DAY5_WORK_WEEK_FLAG] [varchar](50) NULL,
		[OTHER_WORK_WEEK_FLAG] [varchar](50) NULL,
		[OTHER_DAYS] [varchar](50) NULL,
		[BENE_PRCTG_FLAG] [varchar](50) NULL,
		[BENE_PER_AMT] [varchar](50) NULL,
		[BENE_FLAT_AMT_FLAG] [varchar](50) NULL,
		[BENE_FLAT_AMT] [varchar](50) NULL,
		[BENE_TD_FLAG] [varchar](50) NULL,
		[BENE_BASED_TYPE] [varchar](50) NULL,
		[BENE_BASED_TYPE_CODE_ID] [int] NULL,
		[BENE_BASED_TYPE_TABLE_NAME] [varchar](50) NULL,
		[WITHHOLD_FED_ITAX_FLAG] [varchar](50) NULL,
		[WITHHOLD_FICA_FLAG] [varchar](50) NULL,
		[WEEKLY_BENE_CAP] [varchar](50) NULL,
		[MAX_BEN_PER_CLAIM] [varchar](50) NULL,
		[MAX_BEN_PER_CAL_YR] [varchar](50) NULL,
		[WAGE_FOR_DIS_PRD] [varchar](50) NULL,
		[WAGE_FOR_CAL_YR] [varchar](50) NULL,
		[TAXABLE_PERCENT] [varchar](50) NULL,
		[WITHHOLD_MEDICARE_FLAG] [varchar](50) NULL,
		[WITHHOLD_STATE_FLAG] [varchar](50) NULL,
		[USE_VOUCHERS_FLAG] [varchar](50) NULL,
		[DAY30_WORK_MONTH] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE] [varchar](255) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD] [varchar](255) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE] [varchar](255) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE] [varchar](255) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME] [varchar](255) NULL,
		[WAGES_FROM] [varchar](255) NULL,
		[WAGES_TO] [varchar](255) NULL,
		[WEEKLY_BENEFIT] [varchar](255) NULL,
		[DAY30_WORK_MONTH_FLAG] [varchar](50) NULL,
		[ACTUAL_MONTH_FLAG] [varchar](50) NULL,
		[UPPER_AGE_LIMIT] [varchar](50) NULL,
		[LOWER_AGE_LIMIT] [varchar](50) NULL,
		[SUPP_PERCENT] [varchar](50) NULL,
		[SUPP_FLAT_AMT] [int] NULL,
		[SUPP_BANK_ACC_NAME] [varchar](50) NULL,
		[SUPP_SUB_ACC_NAME] [varchar](50) NULL,
		[SUPP_TR_TYPE_CODE] [varchar](50) NULL,
		[SUPP_TR_TYPE_CODE_ID] [int] NULL,
		[SUPP_TR_TYPE_CODE_TABLE_NAME] [varchar](50) NULL,
		[SUPP_SEP_PAY_FLAG] [varchar](50) NULL,
		[PENSION_AMT] [int] NULL,
		[SS_AMT] [int] NULL,
		[OTHER_AMT] [int] NULL,
		[PRORATE_OFF_FLAG] [varchar](50) NULL,
		[FULLPAY_ONLY_FLAG] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_1] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_2] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_3] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_4] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_5] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_6] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_7] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_8] [varchar](50) NULL,
		[ALT_WAIT_DIS_TYPE_CODE_ID_8] [int] NULL,
		[ALT_WAIT_DIS_TYPE_TABLE_NAME_8] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_1] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_2] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_3] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_4] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_5] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_6] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_7] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_8] [varchar](50) NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_CODE_ID_8] [int] NULL,
		[ALT_WAIT_DIS_CLNDR_WRK_TYPE_TABLE_NAME_8] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_1] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_1] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_2] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_2] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_3] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_3] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_4] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_4] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_5] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_5] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_6] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_6] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_7] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_7] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_8] [varchar](50) NULL,
		[ALT_WAIT_DIS_PRD_TYPE_CODE_ID_8] [int] NULL,
		[ALT_WAIT_DIS_PRD_TYPE_TABLE_NAME_8] [varchar](50) NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
	 CONSTRAINT [PK_DISABILITY_CLASS_INPUT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DISABILITY_PLAN_INPUT') 
BEGIN
	CREATE TABLE [dbo].[DISABILITY_PLAN_INPUT](
		[PLAN_ID] [int] NULL,
		[PLAN_NAME] [varchar](20) NULL,
		[PLAN_NUMBER] [varchar](20) NULL,
		[STAGING_PLAN_ID] [int] NULL,
		[PLAN_DESCRIPTION] [varchar](50) NULL,
		[PLAN_STATUS] [varchar](50) NULL,
		[PLAN_STATUS_CODE_ID] [int] NULL,
		[PLAN_STATUS_TABLE_NAME] [varchar](50) NULL,
		[PREMIUM] [varchar](50) NULL,
		[BANK_ACCOUNT_NUM] [varchar](50) NULL,
		[EFFECTIVE_DATE] [varchar](8) NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[ISSUE_DATE] [varchar](8) NULL,
		[REVIEW_DATE] [varchar](8) NULL,
		[RENEWAL_DATE] [varchar](8) NULL,
		[CANCEL_DATE] [varchar](8) NULL,
		[PREF_DAY_PAY_TYPE] [varchar](50) NULL,
		[PREF_DAY_PAY_TYPE_CODE_ID] [int] NULL,
		[PREF_DAY_PAY_TYPE_TABLE_NAME] [varchar](50) NULL,
		[PREF_PAY_SCHEDULE_TYPE] [varchar](50) NULL,
		[PREF_PAY_SCHEDULE_TYPE_CODE_ID] [int] NULL,
		[PREF_PAY_SCHEDULE_TYPE_TABLE_NAME] [varchar](50) NULL,
		[COMMENTS] [varchar](255) NULL,
		[START_PAY_PERIOD] [varchar](8) NULL,
		[PRINT_BEFORE_END_FLAG] [varchar](255) NULL,
		[BANK_SUB_ACCNT_NUM] [varchar](255) NULL,
		[INSURED_EID] [varchar](255) NULL,
		[INSURED_HIER_LEVEL] [varchar](255) NULL,
		[USER_FIELD_A] [varchar](255) NULL,
		[USER_FIELD_B] [varchar](255) NULL,
		[USER_FIELD_C] [varchar](255) NULL,
		[USER_FIELD_D] [varchar](255) NULL,
		[USER_FIELD_E] [varchar](255) NULL,
		[USER_FIELD_F] [varchar](255) NULL,
		[USER_FIELD_G] [varchar](255) NULL,
		[USER_FIELD_H] [varchar](255) NULL,
		[USER_FIELD_I] [varchar](255) NULL,
		[USER_FIELD_J] [varchar](255) NULL,
		[USER_FIELD_K] [varchar](255) NULL,
		[USER_FIELD_L] [varchar](255) NULL,
		[USER_FIELD_M] [varchar](255) NULL,
		[USER_FIELD_N] [varchar](255) NULL,
		[USER_FIELD_O] [varchar](255) NULL,
		[USER_FIELD_P] [varchar](255) NULL,
		[USER_FIELD_Q] [varchar](255) NULL,
		[USER_FIELD_R] [varchar](255) NULL,
		[USER_FIELD_S] [varchar](255) NULL,
		[USER_FIELD_T] [varchar](255) NULL,
		[USER_FIELD_U] [varchar](255) NULL,
		[USER_FIELD_V] [varchar](255) NULL,
		[USER_FIELD_W] [varchar](255) NULL,
		[USER_FIELD_X] [varchar](255) NULL,
		[USER_FIELD_Y] [varchar](255) NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[RMX_PLAN_ID] [int] NULL,
	 CONSTRAINT [PK_DISABILITY_PLAN_INPUT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EVENTS_INPUT') 
BEGIN
	CREATE TABLE [dbo].[EVENTS_INPUT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INVALID_ROW] [int] NULL,
		[INPUT_ROW_ID] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[LINE_OF_BUS_CODE] [int] NULL,
		[EVENT_NUMBER] [varchar](25) NOT NULL,
		[EVENT_TYPE_CODE] [varchar](25) NULL,
		[EVENT_STATUS_CODE] [varchar](25) NULL,
		[EVENT_IND_CODE] [varchar](25) NULL,
		[EVENT_DESCRIPTION] [varchar](8000) NULL,
		[BRIEF_DESCRIPTION] [varchar](250) NULL,
		[DEPARTMENT] [varchar](25) NULL,
		[DEPT_INVOLVED] [varchar](25) NULL,
		[ADDR1] [varchar](50) NULL,
		[ADDR2] [varchar](50) NULL,
		[CITY] [varchar](50) NULL,
		[STATE] [varchar](4) NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[COUNTRY] [varchar](20) NULL,
		[COUNTY_OF_INJURY] [varchar](50) NULL,
		[LOCATION_AREA_DESC] [varchar](8000) NULL,
		[PRIMARY_LOC_CODE] [varchar](25) NULL,
		[LOCATION_TYPE_CODE] [varchar](25) NULL,
		[ON_PREMISE_FLAG] [varchar](1) NULL,
		[NO_OF_INJURIES] [varchar](8) NULL,
		[NO_OF_FATALITIES] [varchar](8) NULL,
		[CAUSE_CODE] [varchar](25) NULL,
		[DATE_OF_EVENT] [varchar](8) NULL,
		[TIME_OF_EVENT] [varchar](6) NULL,
		[DATE_REPORTED] [varchar](8) NULL,
		[TIME_REPORTED] [varchar](6) NULL,
		[REPORTED_TAX_ID] [varchar](11) NULL,
		[REPORTED_LAST_NAME] [varchar](255) NULL,
		[REPORTED_FIRST_NAME] [varchar](255) NULL,
		[REPORTED_ADDR1] [varchar](50) NULL,
		[REPORTED_ADDR2] [varchar](50) NULL,
		[REPORTED_CITY] [varchar](50) NULL,
		[REPORTED_STATE] [varchar](4) NULL,
		[REPORTED_ZIP_CODE] [varchar](10) NULL,
		[REPORTED_PHONE] [varchar](30) NULL,
		[COMMENTS] [varchar](8000) NULL,
		[ACTIVITY_WHEN_INJ] [varchar](255) NULL,
		[HOW_ACC_OCCURRED] [varchar](255) NULL,
		[OBJ_SUBST_THAT_INJ] [varchar](255) NULL,
		[RECORDABLE_FLAG] [varchar](1) NULL,
		[SAFEG_NOTUSED_FLAG] [varchar](1) NULL,
		[SAFEGUARD_FLAG] [varchar](1) NULL,
		[NO_RULES_FLAG] [varchar](1) NULL,
		[DATE_PHYS_ADVISED] [varchar](8) NULL,
		[TIME_PHYS_ADVISED] [varchar](6) NULL,
		[ACTION] [varchar](50) NULL,
		[ACTION_1_CODE] [varchar](25) NULL,
		[ACTION_1_CODE_ID] [int] NULL,
		[ACTION_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[ACTION_2_CODE] [varchar](25) NULL,
		[ACTION_2_CODE_ID] [int] NULL,
		[ACTION_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[ACTION_3_CODE] [varchar](25) NULL,
		[ACTION_3_CODE_ID] [int] NULL,
		[ACTION_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[ACTION_4_CODE] [varchar](25) NULL,
		[ACTION_4_CODE_ID] [int] NULL,
		[ACTION_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[ACTION_5_CODE] [varchar](25) NULL,
		[ACTION_5_CODE_ID] [int] NULL,
		[ACTION_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[OUTCOME] [varchar](50) NULL,
		[OUTCOME_1_CODE] [varchar](25) NULL,
		[OUTCOME_1_CODE_ID] [int] NULL,
		[OUTCOME_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[OUTCOME_2_CODE] [varchar](25) NULL,
		[OUTCOME_2_CODE_ID] [int] NULL,
		[OUTCOME_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[OUTCOME_3_CODE] [varchar](25) NULL,
		[OUTCOME_3_CODE_ID] [int] NULL,
		[OUTCOME_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[OUTCOME_4_CODE] [varchar](25) NULL,
		[OUTCOME_4_CODE_ID] [int] NULL,
		[OUTCOME_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[OUTCOME_5_CODE] [varchar](25) NULL,
		[OUTCOME_5_CODE_ID] [int] NULL,
		[OUTCOME_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[DATE_TO_FOLLOW_UP] [varchar](8) NULL,
		[TREATMENT_GIVEN] [varchar](1) NULL,
		[RELEASE_SIGNED] [varchar](1) NULL,
		[DEPT_HEAD_ADVISED] [varchar](1) NULL,
		[PHYS_NOTES] [varchar](8000) NULL,
		[DATE_CARRIER_NOTIF] [varchar](8) NULL,
		[PI_SUFFIX] [varchar](4) NULL,
		[PI_TAX_ID] [varchar](11) NULL,
		[PI_LAST_NAME] [varchar](255) NULL,
		[PI_FIRST_NAME] [varchar](255) NULL,
		[PI_ADDR1] [varchar](50) NULL,
		[PI_ADDR2] [varchar](50) NULL,
		[PI_CITY] [varchar](50) NULL,
		[PI_STATE] [varchar](4) NULL,
		[PI_ZIP_CODE] [varchar](10) NULL,
		[PI_PHONE] [varchar](30) NULL,
		[PI_TYPE_CODE] [varchar](50) NULL,
		[MARITAL_STAT_CODE] [varchar](8) NULL,
		[SEX_CODE] [varchar](8) NULL,
		[BIRTH_DATE] [varchar](8) NULL,
		[DATE_OF_DEATH] [varchar](8) NULL,
		[ILLNESS_CODE] [varchar](25) NULL,
		[INJURY_1_CODE] [varchar](25) NULL,
		[INJURY_1_CODE_ID] [int] NULL,
		[INJURY_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[INJURY_2_CODE] [varchar](25) NULL,
		[INJURY_2_CODE_ID] [int] NULL,
		[INJURY_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[INJURY_3_CODE] [varchar](25) NULL,
		[INJURY_3_CODE_ID] [int] NULL,
		[INJURY_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[INJURY_4_CODE] [varchar](25) NULL,
		[INJURY_4_CODE_ID] [int] NULL,
		[INJURY_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[INJURY_5_CODE] [varchar](25) NULL,
		[INJURY_5_CODE_ID] [int] NULL,
		[INJURY_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[BODY_PART_1_CODE] [varchar](25) NULL,
		[BODY_PART_1_CODE_ID] [int] NULL,
		[BODY_PART_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[BODY_PART_2_CODE] [varchar](25) NULL,
		[BODY_PART_2_CODE_ID] [int] NULL,
		[BODY_PART_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[BODY_PART_3_CODE] [varchar](25) NULL,
		[BODY_PART_3_CODE_ID] [int] NULL,
		[BODY_PART_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[BODY_PART_4_CODE] [varchar](25) NULL,
		[BODY_PART_4_CODE_ID] [int] NULL,
		[BODY_PART_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[BODY_PART_5_CODE] [varchar](25) NULL,
		[BODY_PART_5_CODE_ID] [int] NULL,
		[BODY_PART_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[DIAGNOSIS_1_CODE] [varchar](25) NULL,
		[DIAGNOSIS_1_CODE_ID] [int] NULL,
		[DIAGNOSIS_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[DIAGNOSIS_2_CODE] [varchar](25) NULL,
		[DIAGNOSIS_2_CODE_ID] [int] NULL,
		[DIAGNOSIS_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[DIAGNOSIS_3_CODE] [varchar](25) NULL,
		[DIAGNOSIS_3_CODE_ID] [int] NULL,
		[DIAGNOSIS_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[DIAGNOSIS_4_CODE] [varchar](25) NULL,
		[DIAGNOSIS_4_CODE_ID] [int] NULL,
		[DIAGNOSIS_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[DIAGNOSIS_5_CODE] [varchar](25) NULL,
		[DIAGNOSIS_5_CODE_ID] [int] NULL,
		[DIAGNOSIS_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[TREATMENT_1_CODE] [varchar](25) NULL,
		[TREATMENT_1_CODE_ID] [int] NULL,
		[TREATMENT_1_CODE_TABLE_NAME] [varchar](30) NULL,
		[TREATMENT_2_CODE] [varchar](25) NULL,
		[TREATMENT_2_CODE_ID] [int] NULL,
		[TREATMENT_2_CODE_TABLE_NAME] [varchar](30) NULL,
		[TREATMENT_3_CODE] [varchar](25) NULL,
		[TREATMENT_3_CODE_ID] [int] NULL,
		[TREATMENT_3_CODE_TABLE_NAME] [varchar](30) NULL,
		[TREATMENT_4_CODE] [varchar](25) NULL,
		[TREATMENT_4_CODE_ID] [int] NULL,
		[TREATMENT_4_CODE_TABLE_NAME] [varchar](30) NULL,
		[TREATMENT_5_CODE] [varchar](25) NULL,
		[TREATMENT_5_CODE_ID] [int] NULL,
		[TREATMENT_5_CODE_TABLE_NAME] [varchar](30) NULL,
		[PHYSICIAN_LAST_NAME] [varchar](255) NULL,
		[PHYSICIAN_FIRST_NAME] [varchar](255) NULL,
		[PHYSICIAN_PHONE1] [varchar](90) NULL,
		[HOSPITAL_NAME] [varchar](150) NULL,
		[HOSPITAL_PHONE] [varchar](90) NULL,
		[DRIVERS_LIC_NO] [varchar](20) NULL,
		[DRIVERSLICTYPECODE] [varchar](25) NULL,
		[DATE_DRIVERSLICEXP] [varchar](8) NULL,
		[DRIVLIC_RSTRCT_CODE] [varchar](25) NULL,
		[DRIVLIC_STATE] [varchar](4) NULL,
		[COUNTY_OF_RESIDNC] [varchar](50) NULL,
		[NCCI_CLASS_CODE] [varchar](25) NULL,
		[EST_LEN_DISABILITY] [varchar](4) NULL,
		[INSURABLE_FLAG] [varchar](1) NULL,
		[LAST_VERIFIED_DATE] [varchar](8) NULL,
		[PATIENT_ACCT_NO] [varchar](20) NULL,
		[MEDICAL_RCD_NO] [varchar](12) NULL,
		[INS_PLAN_GROUP_NO] [varchar](16) NULL,
		[DATE_OF_ADMISSION] [varchar](8) NULL,
		[DATE_OF_DISCHARGE] [varchar](8) NULL,
		[ADM_TYPE_CODE] [varchar](25) NULL,
		[ADM_SOURCE_CODE] [varchar](25) NULL,
		[ADMISSION_REASON] [varchar](8000) NULL,
		[ACUITY_LEVEL_CODE] [varchar](25) NULL,
		[PATIENT_STAT_CODE] [varchar](25) NULL,
		[PATIENT_COND_CODE] [varchar](25) NULL,
		[DISCHARGE_DSP_CODE] [varchar](25) NULL,
		[EXP_LENGTH_OF_STAY] [varchar](4) NULL,
		[EXPECTED_COST] [varchar](8) NULL,
		[QI_SIGNIF_CODE] [varchar](25) NULL,
		[EPISODE_OF_CARE_ID] [varchar](8) NULL,
		[PATIENT_TYPE_CODE] [varchar](25) NULL,
		[WEIGHT] [varchar](4) NULL,
		[EMERGENCY_CONTACT] [varchar](20) NULL,
		[EMERGENCY_CONT_NO] [varchar](20) NULL,
		[PATIENT_ROOM_NO] [varchar](14) NULL,
		[FACILITY_UNIT_CODE] [varchar](25) NULL,
		[FACILITY_DEPT] [varchar](25) NULL,
		[HCO_ID_NO] [varchar](20) NULL,
		[HCO_SITE_ID_NO] [varchar](20) NULL,
		[WHY_AT_FACILITY] [varchar](8000) NULL,
		[DISABILITY_CODE] [varchar](25) NULL,
		[EMPLOYEE_NUMBER] [varchar](20) NULL,
		[POSITION_CODE] [varchar](25) NULL,
		[DEPT_ASSIGNED] [varchar](25) NULL,
		[SUPER_TAX_ID] [varchar](34) NULL,
		[SUPER_LAST_NAME] [varchar](50) NULL,
		[SUPER_FIRST_NAME] [varchar](25) NULL,
		[SUPER_ADDR1] [varchar](50) NULL,
		[SUPER_ADDR2] [varchar](50) NULL,
		[SUPER_CITY] [varchar](50) NULL,
		[SUPER_STATE] [varchar](4) NULL,
		[SUPER_ZIP_CODE] [varchar](10) NULL,
		[SUPER_PHONE1] [varchar](30) NULL,
		[FULL_TIME_FLAG] [varchar](1) NULL,
		[PAY_TYPE_CODE] [varchar](25) NULL,
		[HOURLY_RATE] [varchar](8) NULL,
		[WEEKLY_HOURS] [varchar](4) NULL,
		[WEEKLY_RATE] [varchar](8) NULL,
		[PAY_AMOUNT] [varchar](8) NULL,
		[ACTIVE_FLAG] [varchar](1) NULL,
		[DATE_HIRED] [varchar](8) NULL,
		[DATE_LAST_WORKED] [varchar](134) NULL,
		[DATE_RETURNED] [varchar](134) NULL,
		[LOST_WORK_FLAG] [varchar](1) NULL,
		[LEN_OF_SVC_DAYS] [varchar](8) NULL,
		[EXEMPT_STATUS_FLAG] [varchar](1) NULL,
		[NO_OF_EXEMPTIONS] [varchar](4) NULL,
		[WORK_SUN_FLAG] [varchar](1) NULL,
		[WORK_MON_FLAG] [varchar](1) NULL,
		[WORK_TUE_FLAG] [varchar](1) NULL,
		[WORK_WED_FLAG] [varchar](1) NULL,
		[WORK_THU_FLAG] [varchar](1) NULL,
		[WORK_FRI_FLAG] [varchar](1) NULL,
		[WORK_SAT_FLAG] [varchar](1) NULL,
		[WORKDAY_START_TIME] [varchar](6) NULL,
		[WORK_PERMIT_DATE] [varchar](8) NULL,
		[WORK_PERMIT_NUMBER] [varchar](50) NULL,
		[REGULAR_JOB_FLAG] [varchar](1) NULL,
		[HIRED_IN_STATE_FLAG] [varchar](1) NULL,
		[NUM_OF_VIOLATIONS] [varchar](4) NULL,
		[DESC_BY_WITNESS] [varchar](8000) NULL,
		[USER_FIELD_A] [varchar](8000) NULL,
		[USER_FIELD_B] [varchar](255) NULL,
		[USER_FIELD_C] [varchar](255) NULL,
		[USER_FIELD_D] [varchar](255) NULL,
		[USER_FIELD_E] [varchar](255) NULL,
		[USER_FIELD_F] [varchar](255) NULL,
		[USER_FIELD_G] [varchar](255) NULL,
		[USER_FIELD_H] [varchar](255) NULL,
		[USER_FIELD_I] [varchar](255) NULL,
		[USER_FIELD_J] [varchar](255) NULL,
		[USER_FIELD_K] [varchar](255) NULL,
		[USER_FIELD_L] [varchar](255) NULL,
		[USER_FIELD_M] [varchar](255) NULL,
		[USER_FIELD_N] [varchar](255) NULL,
		[USER_FIELD_O] [varchar](255) NULL,
		[USER_FIELD_P] [varchar](255) NULL,
		[USER_FIELD_Q] [varchar](255) NULL,
		[USER_FIELD_R] [varchar](255) NULL,
		[USER_FIELD_S] [varchar](255) NULL,
		[USER_FIELD_T] [varchar](255) NULL,
		[USER_FIELD_U] [varchar](255) NULL,
		[USER_FIELD_V] [varchar](255) NULL,
		[USER_FIELD_W] [varchar](255) NULL,
		[USER_FIELD_X] [varchar](255) NULL,
		[USER_FIELD_Y] [varchar](255) NULL,
		[COND_PRIOR_CODE] [varchar](25) NULL,
		[RAIL_POSITION_CODE] [varchar](25) NULL,
		[RESTRAINT_CODE] [varchar](25) NULL,
		[BED_POSITION_CODE] [varchar](25) NULL,
		[CALL_LIGHT_CODE] [varchar](25) NULL,
		[REPORTED_COUNTRY] [varchar](24) NULL,
		[REPORTED_PHONE2] [varchar](30) NULL,
		[REPORTED_FAX] [varchar](30) NULL,
		[PI_MIDDLE_NAME] [varchar](255) NULL,
		[PRIVACY_CASE_FLAG] [varchar](1) NULL,
		[SHARPS_OBJECT] [varchar](25) NULL,
		[SHARPS_OBJECT_CODE_ID] [int] NULL,
		[SHARPS_OBJECT_CODE_TABLE_NAME] [varchar](30) NULL,
		[SHARPS_BRAND_MAKE] [varchar](25) NULL,
		[SHARPS_BRAND_MAKE_CODE_ID] [int] NULL,
		[SHARPS_BRAND_MAKE_CODE_TABLE_NAME] [varchar](30) NULL,
		[SAFEG_PROVIDED] [varchar](1) NULL,
		[RULES_NOT_FOLLOWED] [varchar](1) NULL,
		[OSHA_ESTAB_EID] [varchar](25) NULL,
		[EVENT_TYPE_CODE_ID] [int] NULL,
		[EVENT_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[EVENT_STATUS_CODE_ID] [int] NULL,
		[EVENT_STATUS_CODE_TABLE_NAME] [varchar](30) NULL,
		[EVENT_IND_CODE_ID] [int] NULL,
		[EVENT_IND_CODE_TABLE_NAME] [varchar](30) NULL,
		[PRIMARY_LOC_CODE_ID] [int] NULL,
		[LOCATION_TYPE_CODE_ID] [int] NULL,
		[CAUSE_CODE_ID] [int] NULL,
		[PI_TYPE_CODE_ID] [int] NULL,
		[MARITAL_STAT_CODE_ID] [int] NULL,
		[SEX_CODE_ID] [int] NULL,
		[ILLNESS_CODE_ID] [int] NULL,
		[INJURY_CODE_ID] [int] NULL,
		[DRIVERSLICTYPECODE_ID] [int] NULL,
		[DRIVLIC_RSTRCT_CODE_ID] [int] NULL,
		[NCCI_CLASS_CODE_ID] [int] NULL,
		[ADM_TYPE_CODE_ID] [int] NULL,
		[ADM_SOURCE_CODE_ID] [int] NULL,
		[ACUITY_LEVEL_CODE_ID] [int] NULL,
		[PATIENT_STAT_CODE_ID] [int] NULL,
		[PATIENT_COND_CODE_ID] [int] NULL,
		[DISCHARGE_DSP_CODE_ID] [int] NULL,
		[QI_SIGNIF_CODE_ID] [int] NULL,
		[PATIENT_TYPE_CODE_ID] [int] NULL,
		[FACILITY_UNIT_CODE_ID] [int] NULL,
		[DISABILITY_CODE_ID] [int] NULL,
		[POSITION_CODE_ID] [int] NULL,
		[PAY_TYPE_CODE_ID] [int] NULL,
		[COND_PRIOR_CODE_ID] [int] NULL,
		[RAIL_POSITION_CODE_ID] [int] NULL,
		[RESTRAINT_CODE_ID] [int] NULL,
		[BED_POSITION_CODE_ID] [int] NULL,
		[CALL_LIGHT_CODE_ID] [int] NULL,
		[PRIMARY_LOC_CODE_TABLE_NAME] [varchar](30) NULL,
		[LOCATION_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[CAUSE_CODE_TABLE_NAME] [varchar](30) NULL,
		[PI_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[MARITAL_STAT_CODE_TABLE_NAME] [varchar](30) NULL,
		[SEX_CODE_TABLE_NAME] [varchar](30) NULL,
		[ILLNESS_CODE_TABLE_NAME] [varchar](30) NULL,
		[DRIVERSLICTYPECODE_TABLE_NAME] [varchar](30) NULL,
		[DRIVLIC_RSTRCT_CODE_TABLE_NAME] [varchar](30) NULL,
		[NCCI_CLASS_CODE_TABLE_NAME] [varchar](30) NULL,
		[ADM_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[ADM_SOURCE_CODE_TABLE_NAME] [varchar](30) NULL,
		[ACUITY_LEVEL_CODE_TABLE_NAME] [varchar](30) NULL,
		[PATIENT_STAT_CODE_TABLE_NAME] [varchar](30) NULL,
		[PATIENT_COND_CODE_TABLE_NAME] [varchar](30) NULL,
		[DISCHARGE_DSP_CODE_TABLE_NAME] [varchar](30) NULL,
		[QI_SIGNIF_CODE_TABLE_NAME] [varchar](30) NULL,
		[PATIENT_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[FACILITY_UNIT_CODE_TABLE_NAME] [varchar](30) NULL,
		[DISABILITY_CODE_TABLE_NAME] [varchar](30) NULL,
		[POSITION_CODE_TABLE_NAME] [varchar](30) NULL,
		[PAY_TYPE_CODE_TABLE_NAME] [varchar](30) NULL,
		[COND_PRIOR_CODE_TABLE_NAME] [varchar](30) NULL,
		[RAIL_POSITION_CODE_TABLE_NAME] [varchar](30) NULL,
		[RESTRAINT_CODE_TABLE_NAME] [varchar](30) NULL,
		[BED_POSITION_CODE_TABLE_NAME] [varchar](30) NULL,
		[CALL_LIGHT_CODE_TABLE_NAME] [varchar](30) NULL,
		[EVENT_ID] [int] NULL,
		[SUPERVISOR_ID] [int] NULL,
		[REPORTER_ID] [int] NULL,
		[ENTITY_ID] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_EVENTS_INPUT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

--ADDED BY JMERICLE
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PAYMENTS_INPUT') 
BEGIN
	CREATE TABLE [dbo].[PAYMENTS_INPUT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ACTIVITY_DATE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ADJUSTER] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AMOUNT] [float] NULL,
		[BANK_ACCOUNT_NUM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[BANK_ACCOUNT_ID] [int] NULL,
		[BANK_SUB_ACCNT_NUM] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[BANK_SUB_ACCNT_ID] [int] NULL,
		[CARRIER] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CHECK_NO] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CHECK_SUFFIX] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CHECK_STATUS] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CHECK_STATUS_CODE_ID] [int] NULL,
		[CHECK_STATUS_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CLAIM_NUMBER] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CLAIM_ID] [int] NULL,
		[CLAIMANT_EID] [int] NULL,
		[CLAIMANT_SUFFIX] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CLEARED_FLAG] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[COLLECTION_FLAG] [int] NULL,
		[CTL_NUMBER] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[DATE_CLEARED] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[INVOICE_NUMBER] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LINE_OF_BUSINESS] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LOB_CODE_ID] [int] NULL,
		[LOB_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[MEMO] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_EID] [int] NULL,
		[PAYEE_TYPE] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_TYPE_CODE_ID] [int] NULL,
		[PAYEE_TYPE_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_TAX_ID_NO] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_LASTNAME] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_FIRSTNAME] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_ADDRESS] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_ADDRESS2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_CITY] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_STATE] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_STATE_CODE] [int] NULL,
		[PAYEE_STATE_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_ZIP] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYEE_TABLE_ID] [int] NULL,
		[PAYEE_TABLE_NAME] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PAYMENT_FLAG] [int] NULL,
		[PAYMENT_TYPE] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[REPORT_1099_FLAG] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RESERVE_CATEGORY] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RES_STATUS] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RESERVE_STATUS_CODE_ID] [int] NULL,
		[RESERVE_STATUS_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RESERVE_TYPE_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RESERVE_TYPE_CODE_ID] [int] NULL,
		[RSV_ROW_ID] [int] NULL,
		[RSV_TYPE_MAPPING] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CHANGE_AMOUNT] [float] NULL,
		[COLLECTION_TOTAL] [float] NULL,
		[PAID_TOTAL] [float] NULL,
		[RESERVE_AMOUNT] [float] NULL,
		[REASON] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SERVICE_FROM_DATE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SERVICE_TO_DATE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TRANSACTION_DATE] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TRANSACTION_TYPE] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TRANS_TYPE_CODE_ID] [int] NULL,
		[TRANS_TYPE_TABLE_NAME] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TRANS_ID] [int] NULL,
		[TRANS_NUMBER] [int] NULL,
		[UNIT_ID] [int] NULL,
		[VOID_FLAG] [int] NULL,
		[USER_FIELD_A] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_B] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_C] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_D] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_E] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_F] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_G] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_H] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_I] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_J] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_K] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_L] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_M] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_N] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_O] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_P] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_Q] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_R] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_S] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_T] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_U] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_V] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_W] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_X] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_Y] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[USER_FIELD_Z] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 CONSTRAINT [PK_PAYMENTS_INPUT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'GLOSSARY') 
BEGIN
	CREATE TABLE [dbo].[GLOSSARY](
		[IND_STAND_TABLE_ID] [int] NULL,
		[LINE_OF_BUS_FLAG] [smallint] NULL,
		[REQD_IND_TABL_FLAG] [smallint] NULL,
		[TABLE_ID] [int] NULL,
		[SYSTEM_TABLE_NAME] [varchar](30) NULL,
		[GLOSSARY_TYPE_CODE] [int] NULL,
		[ATTACHMENTS_FLAG] [smallint] NULL,
		[RELATED_TABLE_ID] [int] NULL,
		[REQD_REL_TABL_FLAG] [smallint] NULL,
		[NEXT_UNIQUE_ID] [int] NULL,
		[RM_USER_ID] [varchar](50) NULL,
		[DTTM_LAST_UPDATE] [varchar](14) NULL,
		[DELETED_FLAG] [smallint] NULL,
		[TREE_DISPLAY_FLAG] [smallint] NULL
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'MEDWATCH_INPUT') 
BEGIN
	CREATE TABLE [dbo].[MEDWATCH_INPUT](
		[EVENT_NUMBER] [varchar](25) NOT NULL,
		[EVENT_ID] [int] NULL,
		[STAGING_EVENT_ID] [int] NULL,
		[UNIT_CODE] [varchar](25) NULL,
		[UNIT_CODE_ID] [int] NULL,
		[UNIT_CODE_TABLE_NAME] [varchar](50) NULL,
		[DATE_RPTD_FDA] [varchar](8) NULL,
		[DATE_RPTD_MFG] [varchar](8) NULL,
		[RPTD_BY_LAST_NAME] [varchar](50) NULL,
		[RPTD_BY_FIRST_NAME] [varchar](25) NULL,
		[RPTD_BY_ADDR1] [varchar](50) NULL,
		[RPTD_BY_ADDR2] [varchar](50) NULL,
		[RPTD_BY_CITY] [varchar](50) NULL,
		[RPTD_BY_STATE] [varchar](4) NULL,
		[RPTD_BY_ZIP_CODE] [varchar](10) NULL,
		[RPTD_BY_TAX_ID] [varchar](11) NULL,
		[RPTD_BY_PRO_FLAG] [varchar](25) NULL,
		[RPTD_BY_POS_CODE] [varchar](25) NULL,
		[RPTD_BY_POS_CODE_ID] [int] NULL,
		[RPTD_BY_POS_CODE_TABLE_NAME] [varchar](50) NULL,
		[RELEVANT_HISTORY] [varchar](4000) NULL,
		[LAST_REPORT_DATE] [varchar](8) NULL,
		[REPORT_YEAR] [varchar](4) NULL,
		[REPORT_SERIAL_NO] [varchar](20) NULL,
		[ADVERSE_EVENT_FLAG] [varchar](1) NULL,
		[PRODUCT_PROB_FLAG] [varchar](1) NULL,
		[LIFE_THREAT_FLAG] [varchar](1) NULL,
		[HOSPITALIZ_FLAG] [varchar](1) NULL,
		[DISABILITY_FLAG] [varchar](1) NULL,
		[CONGENITAL_FLAG] [varchar](1) NULL,
		[REQD_INTERV_FLAG] [varchar](1) NULL,
		[FOLLOW_UP_COUNT] [varchar](4) NULL,
		[RPT_MANDATORY] [varchar](1) NULL,
		[MED_TYPE] [varchar](25) NULL,
		[MED_TYPE_CODE_ID] [int] NULL,
		[MED_TYPE_TABLE_NAME] [varchar](50) NULL,
		[MED_NAME] [varchar](25) NULL,
		[DOSE] [varchar](25) NULL,
		[FREQUENCY] [varchar](25) NULL,
		[ROUTE] [varchar](25) NULL,
		[THERAPY_FROM_DATE] [varchar](8) NULL,
		[THERAPY_TO_DATE] [varchar](8) NULL,
		[DURATION] [varchar](4) NULL,
		[LOT_NUMBER] [varchar](15) NULL,
		[NDC_NUMBER] [varchar](15) NULL,
		[EXPIRATION_DATE] [varchar](8) NULL,
		[EVENT_ABATED] [varchar](1) NULL,
		[EVENT_REAPPEARED] [varchar](1) NULL,
		[DIAGNOSIS_TEST] [varchar](25) NULL,
		[BRAND_NAME] [varchar](25) NULL,
		[EQUIP_TYPE_CODE] [varchar](25) NULL,
		[EQUIP_TYPE_CODE_ID] [int] NULL,
		[EQUIP_TYPE_CODE_TABLE_NAME] [varchar](50) NULL,
		[MANUF_NAME] [varchar](50) NULL,
		[MANUF_ADDR1] [varchar](50) NULL,
		[MANUF_ADDR2] [varchar](50) NULL,
		[MANUF_CITY] [varchar](50) NULL,
		[MANUF_STATE] [varchar](4) NULL,
		[MANUF_ZIP_CODE] [varchar](10) NULL,
		[MODEL_NUMBER] [varchar](15) NULL,
		[CATALOG_NUMBER] [varchar](15) NULL,
		[SERIAL_NUMBER] [varchar](15) NULL,
		[OTHER_NUMBER] [varchar](15) NULL,
		[DEVICE_OPER_CODE] [varchar](25) NULL,
		[DEVICE_OPER_CODE_ID] [int] NULL,
		[DEVICE_OPER_CODE_TABLE_NAME] [varchar](50) NULL,
		[IMPLANT_DATE] [varchar](8) NULL,
		[EXPLANT_DATE] [varchar](8) NULL,
		[AGE_OF_DEVICE] [varchar](12) NULL,
		[DEV_AVAIL_FOR_EVAL] [varchar](1) NULL,
		[DEVICE_RETURN_DATE] [varchar](8) NULL,
		[EQ_LOT_NUMBER] [varchar](15) NULL,
		[EQ_EXPIRATION_DATE] [varchar](8) NULL,
		[TEST_LAB_TEST] [varchar](50) NULL,
		[TEST_RESULT] [varchar](50) NULL,
		[TEST_DATE] [varchar](8) NULL,
		[CONCOM_PRODUCT_ID] [varchar](20) NULL,
		[CONCOM_FROM_DATE] [varchar](8) NULL,
		[CONCOM_TO_DATE] [varchar](8) NULL,
		[CONCOM_PRODUCT] [varchar](40) NULL,
		[USER_FIELD_A] [varchar](255) NULL,
		[USER_FIELD_B] [varchar](255) NULL,
		[USER_FIELD_C] [varchar](255) NULL,
		[USER_FIELD_D] [varchar](255) NULL,
		[USER_FIELD_E] [varchar](255) NULL,
		[USER_FIELD_F] [varchar](255) NULL,
		[USER_FIELD_G] [varchar](255) NULL,
		[USER_FIELD_H] [varchar](255) NULL,
		[USER_FIELD_I] [varchar](255) NULL,
		[USER_FIELD_J] [varchar](255) NULL,
		[USER_FIELD_K] [varchar](255) NULL,
		[USER_FIELD_L] [varchar](255) NULL,
		[USER_FIELD_M] [varchar](255) NULL,
		[USER_FIELD_N] [varchar](255) NULL,
		[USER_FIELD_O] [varchar](255) NULL,
		[USER_FIELD_P] [varchar](255) NULL,
		[USER_FIELD_Q] [varchar](255) NULL,
		[USER_FIELD_R] [varchar](255) NULL,
		[USER_FIELD_S] [varchar](255) NULL,
		[USER_FIELD_T] [varchar](255) NULL,
		[USER_FIELD_U] [varchar](255) NULL,
		[USER_FIELD_V] [varchar](255) NULL,
		[USER_FIELD_W] [varchar](255) NULL,
		[USER_FIELD_X] [varchar](255) NULL,
		[USER_FIELD_Y] [varchar](255) NULL,
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INVALID_ROW] [int] NULL,
		[INPUT_ROW_ID] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[REPORTER_ID] [int] NULL,
		[MANUFACTURER_ID] [int] NULL,
	 CONSTRAINT [PK_MEDWATCH_INPUT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_BODY_PART') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_BODY_PART](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NOT NULL,
		[BODY_PART_CODE] [int] NOT NULL,
	 CONSTRAINT [PK_PATIENT_BODY_PART] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_INJURY') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_INJURY](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NOT NULL,
		[INJURY_CODE] [int] NOT NULL,
	 CONSTRAINT [PK_PATIENT_INJURY] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PATIENT_TREATMENT') 
BEGIN
	CREATE TABLE [dbo].[PATIENT_TREATMENT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PATIENT_ID] [int] NOT NULL,
		[TREATMENT_CODE] [int] NOT NULL,
	CONSTRAINT [PK_PATIENT_TREATMENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_HOSPITAL') 
BEGIN
	CREATE TABLE [dbo].[PI_X_HOSPITAL](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[HOSPITAL_EID] [int] NULL,
	 CONSTRAINT [PK_PI_X_HOSPITAL] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PI_X_PHYSICIAN') 
BEGIN
	CREATE TABLE [dbo].[PI_X_PHYSICIAN](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PI_ROW_ID] [int] NULL,
		[PHYSICIAN_EID] [int] NULL,
	 CONSTRAINT [PK_PI_X_PHYSICIAN] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

   --  gmahajan2 11/29/2010 MITS 21311 START; columns added to user_verification table to resolve errors logged in
-- DIS_EXE_ERROR_.txt

   --  ****************************************************************************
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'USER_VERIFICATION') 
BEGIN
	CREATE TABLE [dbo].[USER_VERIFICATION](     
		[JOBID] [int] NULL,
		[OPTIONSET_ID] [int] NULL,
		[MODULE_NAME] [varchar](25) NULL,
		[IMPORT_AREA] [varchar](25) NULL,
		[TABLE_NAME] [varchar](4000) NULL,
		[VERIFICATION_FLAG] [int] NULL,
		[STOP_VERIFICATION] [int] NULL
	) ON [PRIMARY]
END

--  gmahajan2 11/29/2010 MITS 21311 END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_X_PROPERTYLOSS') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_X_PROPERTYLOSS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ROW_ID] [int]  NULL,
		[PROPERTY_ID] [int]  NULL,
		[CLAIM_ID] [int] NULL,
		[INSURED] [int] NULL,
		[DAMAGE] [varchar](4000) NULL,
		[PROPERTYTYPE] [int] NULL,
		[ESTDAMAGE] [float] NULL,
		[SEENAT] [varchar](4000) NULL,
		[DATEREPORTED] [varchar](8) NULL,
		[TIMEREPORTED] [varchar](6) NULL,
		[DESCRIPTION] [varchar](4000) NULL,
		[OWNER] [int] NULL,
		[LOCOFTHEFT] [int] NULL,
		[INCENDIARYFIRE] [int] NULL,
		[VACANT] [int] NULL,
		[UNDERCONSTRUCTION] [int] NULL,
		[EXPENSEFROM] [varchar](8) NULL,
		[EXPENSETO] [varchar](8) NULL,
		[OTHERINSURANCE] [int] NULL,
		[POLHOLDERISPROPERTYOWNER] [int] NULL,
		[POLICYHOLDER] [int] NULL,
		[COMPANY] [int] NULL,
		[POLICYNUMBER] [varchar](10) NULL,
		[COVERAGES] [varchar](4000) NULL,
		[LIMITS] [varchar](50) NULL,
		[ADDED_BY_USER] [varchar](50)  NULL,
		[UPDATED_BY_USER] [varchar](50)  NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[ASSIGNADJ_EID] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIM_X_PROPERTYLOSS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

   --  ****************************************************************************
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PROCESS_LOG') 
BEGIN
	CREATE TABLE [dbo].T_DIS_PROCESS_LOG(
		[JOBID] [int] NOT NULL,
		[PROCESS_DESC] [varchar](500) NULL,
                [DISPLAY_ORDER] [int]  NULL,
                [TRANS_ID] [int]  NULL,
                [IDENTIFIER] [int] NULL
		
	 )
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_X_SITELOSS') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_X_SITELOSS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ROW_ID] [int]  NULL,
		[CLAIM_ID] [int]  NULL,
		[SITE_ID] [int] NOT NULL,
		[LOSS_PREVENTION_REPRESENTATIVE] [varchar](100) NULL,
		[LOSS_PREVENTION_CONTACT_NAME] [varchar](255) NULL,
		[FAX_NUMBER] [varchar](50) NULL,
		[EMAIL] [varchar](50) NULL,
		[PRE_QUOTE_SURVEY_ORDERED_DATE] [varchar](20) NULL,
		[POST_BIND_SURVEY_ORDERED_DATE] [varchar](20) NULL,
		[LOSS_PREVENTION_RATING] [varchar](20) NULL,
		[LOSS_PREVENTION_LASTVISITDATE] [varchar](20) NULL,
		[INTERIM_AUDITOR_ID] [varchar](50) NULL,
		[INTERIM_AUDITOR] [varchar](100) NULL,
		[CHECK_AUDITOR_ID] [varchar](50) NULL,
		[CHECK_AUDITOR] [varchar](100) NULL,
		[FINAL_AUDITOR_ID] [varchar](50) NULL,
		[FINAL_AUDITOR] [varchar](100) NULL,
		[ADDED_BY_USER] [varchar](50)  NULL,
		[UPDATED_BY_USER] [varchar](50)  NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[ISINSURED] [int] NULL,
		[ASSIGNADJ_EID] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIM_X_SITELOSS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CLAIM_X_OTHERUNIT') 
BEGIN
	CREATE TABLE [dbo].[CLAIM_X_OTHERUNIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,		
		[ROW_ID] [int]  NULL,
		[CLAIM_ID] [int]  NULL,
		[OTHER_UNIT_ID] [int]  NULL,
		[UNIT_TYPE] [varchar](10) NULL,
		[ADDED_BY_USER] [varchar](50)  NULL,
		[UPDATED_BY_USER] [varchar](50)  NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[ISINSURED] [int] NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_CLAIM_X_OTHERUNIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROPERTY_UNIT') 
BEGIN
	CREATE TABLE [dbo].[PROPERTY_UNIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROPERTY_ID] [int]  NULL,
		[PIN] [varchar](300) NULL,
		[DESCRIPTION] [varchar](50) NULL,
		[ADDR1] [varchar](100) NULL,
		[ADDR2] [varchar](100) NULL,
		[ADDR3] [varchar](100) NULL,
		[ADDR4] [varchar](100) NULL,
		[CITY] [varchar](50) NULL,
		[STATE_ID] [int]  NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[CLASS_OF_CONS_CODE] [int]  NULL,
		[YEAR_OF_CONS] [int]  NULL,
		[WALL_CONS_CODE] [int]  NULL,
		[ROOF_CONS_CODE] [int]  NULL,
		[SQUARE_FOOTAGE] [float] NULL,
		[NO_OF_STORIES] [int] NULL,
		[AVG_STORY_HEIGHT] [float] NULL,
		[HEATING_SYS_CODE] [int]  NULL,
		[COOLING_SYS_CODE] [int]  NULL,
		[FIRE_ALARM_CODE] [int]  NULL,
		[SPRINKLERS_CODE] [int]  NULL,
		[ENTRY_ALARM_CODE] [int]  NULL,
		[PLOT_PLANS_CODE] [int]  NULL,
		[FLOOD_ZONE_CERT_CODE] [int]  NULL,
		[EARTHQUAKE_ZONE_CODE] [int]  NULL,
		[GPS_LATITUDE] [float] NULL,
		[GPS_LONGITUDE] [float]  NULL,
		[GPS_ALTITUDE] [float]  NULL,
		[ROOF_ANCHORING_CODE] [int] NULL,
		[GLASS_STRENGTH_CODE] [int]  NULL,
		[APPRAISED_VALUE] [float]  NULL,
		[REPLACEMENT_VALUE] [float]  NULL,
		[DELETED_FLAG] [smallint] NULL,
		[APPRAISED_DATE] [varchar](8) NULL,
		[LAND_VALUE] [float]  NULL,
		[APPRAISAL_SOURCE_CODE] [int]  NULL,
		[CATEGORY_CODE] [int]  NULL,
		[TERRITORY_CODE] [int]  NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[COUNTRY_CODE] [int]  NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_PROPERTY_UNIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POINT_UNIT_DATA') 
BEGIN
	
    CREATE TABLE [dbo].[POINT_UNIT_DATA](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[ROW_ID] [int]  NULL,
		[UNIT_ID] [int] NULL,
		[UNIT_TYPE] [varchar](10) NULL,
		[UNIT_NUMBER] [varchar](10) NULL,
		[UNIT_RISK_LOC] [varchar](10) NULL,
		[UNIT_RISK_SUB_LOC] [varchar](10) NULL,
		[SITE_SEQ_NUMBER] [varchar](10) NULL,
		[PRODUCT] [varchar](50) NULL,
		[INS_LINE] [varchar](50) NULL,
		[STAT_UNIT_NUMBER] [varchar](10) NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_POINT_UNIT_DATA] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END 


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DRIVER') 
BEGIN
	
    CREATE TABLE [dbo].[DRIVER](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DRIVER_ROW_ID] [int]  NULL,
		[DRIVER_EID] [int]  NULL,
		[DRIVER_TYPE] [int]  NULL,
		[LICENCE_DATE] [varchar](8) NULL,
		[LICENCE_NUMBER] [varchar](50) NULL,
		[MARITAL_STAT_CODE] [int] NULL,		
		[STAGING_ID] [int] NULL,
		[PS_INS_LINE] [varchar](50) NULL,
		[PS_RISK_LOC][varchar](10) NULL,
		[PS_RISK_SUB_LOC][varchar](10) NULL,
		[PS_PRODUCT][varchar](50) NULL,
		[PS_DRIVER_ID] [int]  NULL, 
		[PS_RECORD_STATUS][varchar](1) NULL,


	 CONSTRAINT [PK_DRIVER] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'SITE_UNIT') 
BEGIN	
    CREATE TABLE [dbo].[SITE_UNIT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[SITE_ID] [int]  NULL,
		[SITE_NUMBER] [varchar](50) NULL,
		[NAME] [varchar](255) NULL,
		[OPTIONAL] [varchar](200) NULL,
		[ADDR1] [varchar](100) NULL,
		[ADDR2] [varchar](100) NULL,
		[ADDR3] [varchar](100) NULL,
		[ADDR4] [varchar](100) NULL,
		[STATE_ID] [int] NULL,
		[CITY] [varchar](50) NULL,
		[ZIP_CODE] [varchar](10) NULL,
		[COUNTRY_ID] [int] NULL,
		[PHONE_NUMBER] [varchar](50) NULL,
		[CONTACT] [varchar](50) NULL,
		[TAX_LOCATION] [varchar](50) NULL,
		[UNEMPLOYEMENT_NUMBER] [varchar](50) NULL,
		[NUM_OF_EMP] [int] NULL,
		[FEIN] [varchar](50) NULL,
		[SIC] [varchar](50) NULL,
		[DELETED_FLAG] [smallint] NULL,
		[DTTM_RCD_ADDED] [varchar](14) NULL,
		[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
		[ADDED_BY_USER] [varchar](50) NULL,
		[UPDATED_BY_USER] [varchar](50) NULL,
		[STAGING_ID] [int] NULL,
	 CONSTRAINT [PK_SITE_UNIT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_SITE_UNIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_SITE_UNIT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[STATE_ID] [varchar](25)  NULL,
		[COUNTRY_ID] [varchar](25) NULL,
		[SITE_ID][int]  NULL,		
	 CONSTRAINT [PK_T_DIS_SITE_UNIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PROPERTY_UNIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PROPERTY_UNIT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[STATE_ID] [varchar](25)  NULL,
		[CLASS_OF_CONS_CODE] [varchar](25) NULL,	
		[WALL_CONS_CODE] [varchar](25)  NULL,
		[ROOF_CONS_CODE] [varchar](25)  NULL,
		[HEATING_SYS_CODE][varchar](25) NULL,
		[COOLING_SYS_CODE] [varchar](25) NULL,
		[FIRE_ALARM_CODE][varchar](25)  NULL,
		[SPRINKLERS_CODE] [varchar](25)  NULL,
		[ENTRY_ALARM_CODE] [varchar](25)  NULL,
		[PLOT_PLANS_CODE][varchar](25)  NULL,
		[FLOOD_ZONE_CERT_CODE] [varchar](25)  NULL,
		[EARTHQUAKE_ZONE_CODE] [varchar](25)  NULL,
		[ROOF_ANCHORING_CODE] [varchar](25)  NULL,
		[GLASS_STRENGTH_CODE][varchar](25)  NULL,
		[APPRAISAL_SOURCE_CODE] [varchar](25)  NULL,
		[CATEGORY_CODE] [varchar](25)  NULL,
		[TERRITORY_CODE] [varchar](25)  NULL,
		[COUNTRY_CODE] [varchar](25)  NULL,	
		[PROPERTY_ID] [int] NULL	
	 CONSTRAINT [PK_T_DIS_PROPERTY_UNIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_CLAIM_X_OTHERUNIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_CLAIM_X_OTHERUNIT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CLAIM_ID] [varchar](25)  NULL,	
		[OTHER_UNIT_ID] [int]  NULL,
	 CONSTRAINT [PK_T_DIS_CLAIM_X_OTHERUNIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_CLAIM_X_SITELOSS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_CLAIM_X_SITELOSS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CLAIM_ID] [varchar](25)  NULL,
		[ASSIGNADJ_LAST_NAME] [varchar](255) NULL,
		[ASSIGNADJ_FIRST_NAME] [varchar](255) NULL,	
		[ASSIGNADJ_TAX_ID] [varchar](20) NULL,
		[SITE_ID] [int] NOT NULL,	
	 CONSTRAINT [PK_T_DIS_CLAIM_X_SITELOSS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_CLAIM_X_PROPERTYLOSS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_CLAIM_X_PROPERTYLOSS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CLAIM_ID] [varchar](25) NULL,
		[PROPERTYTYPE] [varchar](25) NULL,
		[OWNER_LAST_NAME] [varchar](255) NULL,
		[OWNER_FIRST_NAME] [varchar](255) NULL,	
		[OWNER_TAX_ID] [varchar](20) NULL,
		[LOCOFTHEFT] [varchar](25) NULL,
		[POLICYHOLDER_LAST_NAME] [varchar](255) NULL,
		[POLICYHOLDER_FIRST_NAME] [varchar](255) NULL,	
		[POLICYHOLDER_TAX_ID] [varchar](20) NULL,
		[COMPANY_LAST_NAME] [varchar](255) NULL,
		[COMPANY_FIRST_NAME] [varchar](255)NULL,	
		[COMPANY_TAX_ID] [varchar](20) NULL,
		[ASSIGNADJ_LAST_NAME] [varchar](255) NULL,
		[ASSIGNADJ_FIRST_NAME] [varchar](255) NULL,	
		[ASSIGNADJ_TAX_ID] [varchar](20) NULL,	
		[PROPERTY_ID] [int]  NULL,
	 CONSTRAINT [PK_T_DIS_CLAIM_X_PROPERTYLOSS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_DRIVER') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_DRIVER](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CLAIM_ID] [varchar](25) NULL,
		[DRIVER_LAST_NAME] [varchar](255) NULL,
		[DRIVER_FIRST_NAME] [varchar](255) NULL,	
		[DRIVER_TAX_ID] [varchar](20) NULL,	
		[DRIVER_TYPE] [varchar](25)  NULL,
		[MARITAL_STAT_CODE] [varchar](25) NULL,
	 CONSTRAINT [PK_T_DIS_DRIVER] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PERSON_INVOLVED') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PERSON_INVOLVED](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int] NULL,
		[LAST_NAME] [varchar](255) NULL,
		[FIRST_NAME] [varchar](255) NULL,	
		[TAX_ID] [varchar](20) NULL,
		[ENTITY_TABLE_ID][varchar](30) NULL,
		[ABBREVIATION] [varchar](25) NULL,
		[COUNTY_OF_RESIDNC] [nvarchar](50) NULL,
	[DRIVLIC_STATE] [nvarchar](25) NULL,
	[PI_LAST_NAME] [nvarchar](255) NULL,
	[PI_FIRST_NAME] [nvarchar](255) NULL,	
	[PI_TAX_ID] [nvarchar](20) NULL,
	[PI_TYPE_CODE] [nvarchar](25) NULL,
	[ADM_TYPE_CODE] [nvarchar](25) NULL,
	[ADM_SOURCE_CODE] [nvarchar](25) NULL,
	
	[ACUITY_LEVEL_CODE] [nvarchar](25) NULL,
	[PATIENT_STAT_CODE] [nvarchar](25) NULL,
	[PATIENT_COND_CODE] [nvarchar](25) NULL,
	[DISCHARGE_DSP_CODE] [nvarchar](25) NULL,
	[QI_SIGNIF_CODE][nvarchar](25) NULL,
	[PATIENT_TYPE_CODE] [nvarchar](25) NULL,
	[MARITAL_STAT_CODE] [nvarchar](25) NULL,
	[RACE_ENTH_CODE] [nvarchar](25) NULL,
	[PRIMARY_PAY_CODE] [nvarchar](25) NULL,
	[FACILITY_UNIT_CODE] [nvarchar](25) NULL,
	[FACILITY_DEPT_EID] [nvarchar](25) NULL,
	
	
	[POSITION_CODE][nvarchar](25)NULL,
	[DEPT_ASSIGNED_EID] [nvarchar](25) NULL,
	[SUPERVISOR_EID] [nvarchar](25) NULL,
	[DRIVERSLICTYPECODE][nvarchar](25) NULL,
	
	[DRIVLIC_RSTRCTCODE] [nvarchar](25) NULL,
	[NCCI_CLASS_CODE] [nvarchar](25) NULL,
	
	[INJURY_CAT_CODE] [nvarchar](25) NULL,
	
	[DISABILITY_CODE] [nvarchar](25) NULL,
	[ILLNESS_CODE] [nvarchar](25) NULL,
	[PAY_TYPE_CODE] [nvarchar](25) NULL,
	[SEC_DEPT_EID] [nvarchar](25) NULL,
	[PATIENT_ID] [nvarchar](20) NULL,
	
	
	[OSHA_ESTAB_EID] [nvarchar](25) NULL,
	[MAJOR_HAND_CODE] [nvarchar](25) NULL,
	
	[JOB_CLASS_CODE] [nvarchar](25)NULL,
	[STD_DISABIL_TYPE] [nvarchar](25) NULL,
	[MONTHLY_RATE] [float] NULL,
	[DIS_OPTION_CODE] [nvarchar](25) NULL,
	
	[DIAGNOSIS_CODE] [nvarchar](25) NULL,
	
	[INJURYCAUSE_CODE] [nvarchar](25) NULL,
	[STAGING_RECORD] [int] null,
	[DRIVER_ROW_ID] [int] NULL,
	[POLICY_UNIT_ROW_ID] [int] NULL,
	[CLIENT_SEQ_NUM] [varchar](30) NULL, 
					
	 CONSTRAINT [PK_T_DIS_PERSON_INVOLVED] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POINT_UNIT_DATA') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_POINT_UNIT_DATA](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[POLICY_ID] [int]  NULL,
		[UNIT_ID] [int]  NULL,
	CONSTRAINT [PK_T_DIS_POINT_UNIT_DATA] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



/****** Object:  Table [dbo].[OTHER_UNIT]    Script Date: 07/17/2014 17:21:11 ******/

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'OTHER_UNIT') 
BEGIN

CREATE TABLE [dbo].[OTHER_UNIT](
	[JOBID] [int] NOT NULL,
	[DA_ROW_ID] [int] NOT NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[INPUT_ROW_ID] [int] NULL,
	[OTHER_UNIT_ID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
	[UNIT_TYPE] [varchar](10) NULL,
	--[DELETED_FLAG] [smallint] NULL,
	[ADDED_BY_USER] [varchar](10) NULL,
	[UPDATED_BY_USER] [varchar](10) NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	[DTTM_RCD_ADDED] [varchar](14) NULL,
[STAGING_ID] [int] NULL,
 CONSTRAINT [PK_OTHER_UNIT] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[DA_ROW_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_OTHER_UNIT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_OTHER_UNIT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[OTHER_UNIT_ID] [int]  NULL,
		[ENTITY_ID] [int] NULL,						
	 CONSTRAINT [PK_T_DIS_OTHER_UNIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


SET ANSI_PADDING OFF



/****** Object:  Table [dbo].[CLAIM_X_POLICY]    Script Date: 07/30/2014 11:58:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CLAIM_X_POLICY](
	[JOBID] [int] NOT NULL,
	[DA_ROW_ID] [int] NOT NULL,
	[ROW_ID] [int] NOT NULL,
	[CLAIM_ID] [int] NOT NULL,
	[POLICY_ID] [int] NOT NULL,
 CONSTRAINT [PK_CLAIM_X_POLICY] PRIMARY KEY CLUSTERED 
(
	[JOBID] ASC,
	[DA_ROW_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[POLICY_X_UNIT]    Script Date: 07/31/2014 18:37:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[POLICY_X_UNIT](
[JOBID] [int] NOT NULL,
[DA_ROW_ID] [int] NOT NULL,
[UPDATE_ROW][int] NULL,
[POLICY_UNIT_ROW_ID] [int]  NULL,
[POLICY_ID] [int] NULL,
[UNIT_ID] [int] NULL,
[UNIT_TYPE] [varchar](10) NULL,
[STAGING_ID][int] NULL
CONSTRAINT [PK_POLICY_X_UNIT] PRIMARY KEY CLUSTERED 
(
[JOBID] ASC,
[DA_ROW_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]





--ipuri User Verification Start
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DA_JOB_ID') 
BEGIN
	CREATE TABLE [dbo].[DA_JOB_ID]( 
		[NEW_JOBID] [int] NULL,
		[JOBID] [int] NOT NULL,
		[OPTIONSET_ID] [int] NOT NULL
	) ON [PRIMARY]
END
--ipuri End



/****** Object:  Table [dbo].[T_DIS_FUNDS_X_PAYEE]    Script Date: 10/06/2014 15:44:21 ******/

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_FUNDS_X_PAYEE') 
BEGIN
CREATE TABLE [dbo].[T_DIS_FUNDS_X_PAYEE](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[TRANS_ID_SOURCE] [int] NULL,
	[PAYEE_TYPE_CODE] [varchar](25) NULL,
	[PHRASE_TYPE_CODE] [varchar](25) NULL,
	[CLAIM_NUMBER] [varchar](25) NULL,
 CONSTRAINT [PK_T_DIS_FUNDS_X_PAYEE] PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
End



/****** Object:  Table [dbo].[FUNDS_X_PAYEE]    Script Date: 10/07/2014 15:54:34 ******/

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FUNDS_X_PAYEE') 
BEGIN
CREATE TABLE [dbo].[FUNDS_X_PAYEE](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[PAYEE_ROW_ID] [int]  NULL,
	[PAYEE_EID] [int] NULL,
	[FUNDS_TRANS_ID] [int] NULL,
	[PAYEE_1099_FLAG] [smallint] NULL,
	[DTTM_RCD_ADDED] [varchar](14) NULL,
	[DTTM_RCD_LAST_UPD] [varchar](14) NULL,
	[ADDED_BY_USER] [varchar](50) NULL,
	[UPDATED_BY_USER] [varchar](50) NULL,
	[PAYEE_TYPE_CODE] [int] NULL,
	[BEFORE_PAYEE] [int] NULL,
	[PHRASE_TYPE_CODE] [int] NULL,
	[STAGING_ID][int] Null
 CONSTRAINT [PK_FUNDS_X_PAYEE] PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
end
GO
/* <12/18/2014>mkaur24 */

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[PROP_MGT]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROP_MGT') 
BEGIN
	CREATE TABLE [dbo].[PROP_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROP_MGT_ID] [int]  NULL,
	[PROP_ID_TEXT] [varchar](50) NULL,
	[LOCATION_TXCD] [varchar](2000) NULL,
	[OWNERSHIP_CODE] [int] NULL,
	[PROP_TYPE_CODE] [int] NULL,
	[PROP_CAT_TEXT] [varchar](50) NULL,
	[REPORTED_BY_TXCD] [varchar](2000) NULL,
	[DT_UPDATE_DATE] [varchar](8) NULL,
	[REV_DATE_DATE] [varchar](8) NULL,
	[DETAIL_TXCD] [varchar](2000) NULL,
	[ORIG_VALUE_AMT] [float] NULL,
	[CURR_VALUE_AMT] [float] NULL,
	[REPLACE_VAL_AMT] [float] NULL,
	[CONT_ORG_VL_AMT] [float] NULL,
	[CONT_REP_VL_AMT] [float] NULL,
	[CONT_CUR_VL_AMT] [float] NULL,
	[INSTALL_DT_DATE] [varchar](8) NULL,
	[CONTACT_TEXT] [varchar](50) NULL,
	[CONTACT_ADD_TEXT] [varchar](50) NULL,
	[CONT_CITY_TEXT] [varchar](25) NULL,
	[CONT_STATE_TEXT] [varchar](15) NULL,
	[CONT_ZIP_TEXT] [varchar](15) NULL,
	[CONT_PHONE_TEXT] [varchar](25) NULL,
	[COVERAGE_CODE] [int] NULL,
	[DAMAGES_TXCD] [varchar](2000) NULL,
	[IMPROVEMENT_TXCD] [varchar](2000) NULL,
	[NOTES_TXCD] [varchar](2000) NULL,
	
		 CONSTRAINT [PK_PROP_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PROP_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PROP_MGT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PROP_MGT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PROP_MGT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[PROP_MGT_ID] [int]  NULL,
		[OWNERSHIP_CODE] [varchar] (25) NULL,
		[PROP_TYPE_CODE] [varchar] (25) NULL,
		[COVERAGE_CODE] [varchar] (25) NULL,
		
			 		
	 CONSTRAINT [PK_T_DIS_PROP_MGT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROP_MGT_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[PROP_MGT_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROP_MGT_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[PROP_MGT_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROP_MGT_ID] [int]  NULL,	
	[PROP_ID_TEXT] [varchar](50) NULL,
	[LOCATION_TXCD] [varchar](2000) NULL,
	[OWNERSHIP_CODE] [int] NULL,
	[PROP_TYPE_CODE] [int] NULL,
	[PROP_CAT_TEXT] [varchar](50) NULL,
	[REPORTED_BY_TXCD] [varchar](2000) NULL,
	[DT_UPDATE_DATE] [varchar](8) NULL,
	[REV_DATE_DATE] [varchar](8) NULL,
	[DETAIL_TXCD] [varchar](2000) NULL,
	[ORIG_VALUE_AMT] [float] NULL,
	[CURR_VALUE_AMT] [float] NULL,
	[REPLACE_VAL_AMT] [float] NULL,
	[CONT_ORG_VL_AMT] [float] NULL,
	[CONT_REP_VL_AMT] [float] NULL,
	[CONT_CUR_VL_AMT] [float] NULL,
	[INSTALL_DT_DATE] [varchar](8) NULL,
	[CONTACT_TEXT] [varchar](50) NULL,
	[CONTACT_ADD_TEXT] [varchar](50) NULL,
	[CONT_CITY_TEXT] [varchar](25) NULL,
	[CONT_STATE_TEXT] [varchar](15) NULL,
	[CONT_ZIP_TEXT] [varchar](15) NULL,
	[CONT_PHONE_TEXT] [varchar](25) NULL,
	[COVERAGE_CODE] [int] NULL,
	[DAMAGES_TXCD] [varchar](2000) NULL,
	[IMPROVEMENT_TXCD] [varchar](2000) NULL,
	[NOTES_TXCD] [varchar](2000) NULL,

	[PROP_MGT_ID_RMDB] [int]  NULL,	
	
	) ON [PRIMARY]
END




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK]') AND type in (N'U'))
DROP TABLE [dbo].[PROJ_TRACK]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROJ_TRACK') 
BEGIN
	CREATE TABLE [dbo].[PROJ_TRACK](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROJ_TRACK_ID] [int]  NULL,
	[ACT_TYPE_CODE] [int] NULL,
	[ACTIV_DESC_TXCD] [varchar](2000) NULL,
	[ASSIGN_BY_TEXT] [varchar](50) NULL,
	[ASSIGN_TO_TXCD][varchar](2000) NULL,
	[PRIORITY_CODE] [int] NULL,
	[EST_HOURS_NUM] [float] NULL,
	[ACT_HOURS_NUM] [float] NULL,
	[DUE_DATE_DATE] [varchar](8) NULL,
	[REVIEW_DATE_DATE] [varchar](8) NULL,
	[COMPLETE_DT_DATE] [varchar](8) NULL,
	[STATUS_CODE] [int] NULL,
	[MAT_USED_TXCD] [varchar](2000) NULL,
	[MAT_COST_AMT] [float] NULL,
	[NOTES_TXCD] [varchar](2000) NULL,
	 CONSTRAINT [PK_PROJ_TRACK] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PROJ_TRACK]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PROJ_TRACK]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PROJ_TRACK') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PROJ_TRACK](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[PROJ_TRACK_ID] [int]  NULL,
		[ACT_TYPE_CODE]  [varchar] (25) NULL,
		[PRIORITY_CODE]  [varchar] (25) NULL,		
		[STATUS_CODE] [varchar] (25) NULL,
			 		
	 CONSTRAINT [PK_T_DIS_PROJ_TRACK] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROJ_TRACK_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[PROJ_TRACK_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PROJ_TRACK_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[PROJ_TRACK_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[PROJ_TRACK_ID] [int]  NULL,
	[ACT_TYPE_CODE] [int] NULL,
	[ACTIV_DESC_TXCD] [varchar](2000) NULL,
	[ASSIGN_BY_TEXT] [varchar](50) NULL,
	[ASSIGN_TO_TXCD][varchar](2000) NULL,
	[PRIORITY_CODE] [int] NULL,
	[EST_HOURS_NUM] [float] NULL,
	[ACT_HOURS_NUM] [float] NULL,
	[DUE_DATE_DATE] [varchar](8) NULL,
	[REVIEW_DATE_DATE] [varchar](8) NULL,
	[COMPLETE_DT_DATE] [varchar](8) NULL,
	[STATUS_CODE] [int] NULL,
	[MAT_USED_TXCD] [varchar](2000) NULL,
	[MAT_COST_AMT] [float] NULL,
	[NOTES_TXCD] [varchar](2000) NULL,
	[PROJ_TRACK_ID_RMDB] [int]  NULL,	
		) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY]') AND type in (N'U'))
DROP TABLE [dbo].[DIRECTORY]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIRECTORY') 
BEGIN
	CREATE TABLE [dbo].[DIRECTORY](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DIRECTORY_ID] [int]  NULL,
	[LAST_NAME_TEXT] [varchar](255) NULL,
	[FIRST_NAME_TEXT] [varchar](255) NULL,
	[ADDRESS_TEXT] [varchar](100) NULL,
	[CITY_TEXT] [varchar](50) NULL,
	[STATE_TEXT] [varchar](15) NULL,
	[ZIP_CODE_TEXT] [varchar](15) NULL,
	[HOME_PHONE_TEXT] [varchar](25) NULL,
	[WORK_PHONE_TEXT] [varchar](25) NULL,
	[FAX_TEXT] [varchar](25) NULL,
	[TITLE_TEXT] [varchar](25) NULL,
	[ORGANIZ_TEXT] [varchar](50) NULL,
	[CONTACT_TYP_CODE] [int] NULL,
	[CONTACT_STA_CODE] [int] NULL,
	[RECALL_DT_DATE] [varchar](8) NULL,
	[NOTES_TXCD] [varchar](2000) NULL,
	 CONSTRAINT [PK_DIRECTORY] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_DIRECTORY]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_DIRECTORY]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_DIRECTORY') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_DIRECTORY](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[DIRECTORY_ID] [int]  NULL,
		[CONTACT_TYP_CODE] [varchar](25) NULL,
		[CONTACT_STA_CODE] [varchar](25) NULL,
			 		
	 CONSTRAINT [PK_T_DIS_DIRECTORY] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIRECTORY_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[DIRECTORY_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'DIRECTORY_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[DIRECTORY_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[DIRECTORY_ID] [int]  NULL,
	[LAST_NAME_TEXT] [varchar](255) NULL,
	[FIRST_NAME_TEXT] [varchar](255) NULL,
	[ADDRESS_TEXT] [varchar](50) NULL,
	[CITY_TEXT] [varchar](50) NULL,
	[STATE_TEXT] [varchar](15) NULL,
	[ZIP_CODE_TEXT] [varchar](15) NULL,
	[HOME_PHONE_TEXT] [varchar](25) NULL,
	[WORK_PHONE_TEXT] [varchar](25) NULL,
	[FAX_TEXT] [varchar](25) NULL,
	[TITLE_TEXT] [varchar](25) NULL,
	[ORGANIZ_TEXT] [varchar](50) NULL,
	[CONTACT_TYP_CODE] [int] NULL,
	[CONTACT_STA_CODE] [int] NULL,
	[RECALL_DT_DATE] [varchar](8) NULL,
	[NOTES_TXCD] [varchar](2000) NULL,
	[DIRECTORY_ID_RMDB] [int]  NULL,	
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[COMPL_MGT]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'COMPL_MGT') 
BEGIN
	CREATE TABLE [dbo].[COMPL_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COMPL_MGT_ID] [int]  NULL,
	[COMP_NO_TEXT] [varchar](25) NULL,
	[DT_RECV_DATE] [varchar](8) NULL,
	[COMP_TYPE_CODE] [int] NULL,
	[COMP_SRC_CODE] [int] NULL,
	[ACT_REQ_TXCD] [varchar](2000) NULL,
	[FILED_AGNST_TEXT] [varchar](50) NULL,
	[REF_TO_TXCD] [varchar](2000) NULL,
	 CONSTRAINT [PK_COMPL_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_COMPL_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_COMPL_MGT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_COMPL_MGT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_COMPL_MGT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[COMPL_MGT_ID] [int]  NULL,
		[COMP_TYPE_CODE] [varchar](25) NULL,
	[COMP_SRC_CODE] [varchar](25) NULL,			 		
	 CONSTRAINT [PK_T_DIS_COMPL_MGT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPL_MGT_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[COMPL_MGT_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'COMPL_MGT_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[COMPL_MGT_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[COMPL_MGT_ID] [int]  NULL,
	[COMP_NO_TEXT] [varchar](25) NULL,
	[DT_RECV_DATE] [varchar](8) NULL,
	[COMP_TYPE_CODE] [int] NULL,
	[COMP_SRC_CODE] [int] NULL,
	[ACT_REQ_TXCD] [varchar](2000) NULL,
	[FILED_AGNST_TEXT] [varchar](50) NULL,
	[REF_TO_TXCD] [varchar](2000) NULL,
	[COMPL_MGT_ID_RMDB] [int]  NULL,
		) ON [PRIMARY]
END




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[CONTRCT_MGT]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CONTRCT_MGT') 
BEGIN
	CREATE TABLE [dbo].[CONTRCT_MGT](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CONTRCT_MGT_ID] [int]  NULL,
	[CONT_TYPE_CODE] [int] NULL,
	[CONTR_CAT_TXCD] [varchar](2000) NULL,
	[SUBJECTOR_TEXT] [varchar](50) NULL,
	[SUBJECTEE_TEXT] [varchar](50) NULL,
	[DETAILS_TXCD] [varchar](2000) NULL,
	[EFF_DATE_DATE] [varchar](8) NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[RENEW_DATE_DATE] [varchar](8) NULL,
	[INDEMNITY_TXCD] [varchar](2000) NULL,
	[SUBROGATION_TXCD][varchar](2000) NULL,
	[TERM_INFO_TEXT] [varchar](50) NULL,
	[CONDITIONS_TXCD] [varchar](2000) NULL,
	[AUTH_SIGN_TXCD] [varchar](2000) NULL,
	[PAYMENTS_TXCD] [varchar](2000) NULL,
	[WARRANTY_TXCD] [varchar](2000) NULL,	
	 CONSTRAINT [PK_CONTRCT_MGT] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_CONTRCT_MGT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_CONTRCT_MGT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_CONTRCT_MGT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_CONTRCT_MGT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CONTRCT_MGT_ID] [int]  NULL,
		[CONT_TYPE_CODE] [varchar](25) NULL,					 		
	 CONSTRAINT [PK_T_DIS_CONTRCT_MGT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTRCT_MGT_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[CONTRCT_MGT_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CONTRCT_MGT_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[CONTRCT_MGT_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CONTRCT_MGT_ID] [int]  NULL,
	[CONT_TYPE_CODE] [int] NULL,
	[CONTR_CAT_TXCD] [varchar](2000) NULL,
	[SUBJECTOR_TEXT] [varchar](50) NULL,
	[SUBJECTEE_TEXT] [varchar](50) NULL,
	[DETAILS_TXCD] [varchar](2000) NULL,
	[EFF_DATE_DATE] [varchar](8) NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[RENEW_DATE_DATE] [varchar](8) NULL,
	[INDEMNITY_TXCD] [varchar](2000) NULL,
	[SUBROGATION_TXCD][varchar](2000) NULL,
	[TERM_INFO_TEXT] [varchar](50) NULL,
	[CONDITIONS_TXCD] [varchar](2000) NULL,
	[AUTH_SIGN_TXCD] [varchar](2000) NULL,
	[PAYMENTS_TXCD] [varchar](2000) NULL,
	[WARRANTY_TXCD] [varchar](2000) NULL,
	[CONTRCT_MGT_ID_RMDB] [int]  NULL,	
	) ON [PRIMARY]
END




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE]') AND type in (N'U'))
DROP TABLE [dbo].[CERTIFICATE]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CERTIFICATE') 
BEGIN
	CREATE TABLE [dbo].[CERTIFICATE](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CERTIFICATE_ID] [int]  NULL,
	[JOB_NO_TEXT] [varchar](15) NULL,
	[JOB_DESC_TXCD] [varchar](2000) NULL,
	[AGENCY_NAME_TEXT] [varchar](50) NULL,
	[AGENCY_PHON_TEXT] [varchar](20) NULL,
	[INSURED_NAM_TEXT] [varchar](50) NULL,
	[INSURED_ADD_TEXT] [varchar](50) NULL,
	[INSURED_CIT_TEXT] [varchar](25) NULL,
	[INSURED_ST_TEXT] [varchar](15) NULL,
	[INSURED_ZIP_TEXT] [varchar](15) NULL,
	[INSURED_PH_TEXT] [varchar](20) NULL,
	[GEN_LIAB_TXCD] [varchar](2000) NULL,
	[INS_NAME_TEXT] [varchar](50) NULL,
	[POL_NUMBER_NUM] [float] NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[BI_EA_AGG_TEXT] [varchar](25) NULL,
	[PD_EA_AGG_TEXT] [varchar](25) NULL,
	[BI_PD_COMB_NUM] [float] NULL,
	[PI_AGG_NUM] [float] NULL,
	[AUTO_LIAB_TEXT] [varchar](25) NULL,
	[BI_EA_PERS_NUM] [float] NULL,
	[BI_EA_ACC_NUM] [float] NULL,
	[PD_EA_OCC_NUM] [float] NULL,
	[BI_PD_COMB_TEXT] [varchar](15) NULL,
	[EXCESS_LIAB_TXCD] [varchar](2000) NULL,
	[BI_PD_AGG_TEXT] [varchar](15) NULL,
	[WORK_COMP_NUM] [float] NULL,
	[WORK_COMP_TEXT] [varchar](25) NULL,
	[WC_EA_ACC_NUM] [float] NULL,
	[OPER_DESC_TXCD] [varchar](2000) NULL,
	[ISSUE_DT_DATE] [varchar](8) NULL,
	 CONSTRAINT [PK_CERTIFICATE] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_CERTIFICATE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_CERTIFICATE]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_CERTIFICATE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_CERTIFICATE](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CERTIFICATE_ID] [int]  NULL,						 		
	 CONSTRAINT [PK_T_DIS_CERTIFICATE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICATE_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[CERTIFICATE_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'CERTIFICATE_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[CERTIFICATE_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[CERTIFICATE_ID] [int]  NULL,
	[JOB_NO_TEXT] [varchar](15) NULL,
	[JOB_DESC_TXCD] [varchar](2000) NULL,
	[AGENCY_NAME_TEXT] [varchar](50) NULL,
	[AGENCY_PHON_TEXT] [varchar](20) NULL,
	[INSURED_NAM_TEXT] [varchar](50) NULL,
	[INSURED_ADD_TEXT] [varchar](50) NULL,
	[INSURED_CIT_TEXT] [varchar](25) NULL,
	[INSURED_ST_TEXT] [varchar](15) NULL,
	[INSURED_ZIP_TEXT] [varchar](15) NULL,
	[INSURED_PH_TEXT] [varchar](20) NULL,
	[GEN_LIAB_TXCD] [varchar](2000) NULL,
	[INS_NAME_TEXT] [varchar](50) NULL,
	[POL_NUMBER_NUM] [float] NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[BI_EA_AGG_TEXT] [varchar](25) NULL,
	[PD_EA_AGG_TEXT] [varchar](25) NULL,
	[BI_PD_COMB_NUM] [float] NULL,
	[PI_AGG_NUM] [float] NULL,
	[AUTO_LIAB_TEXT] [varchar](25) NULL,
	[BI_EA_PERS_NUM] [float] NULL,
	[BI_EA_ACC_NUM] [float] NULL,
	[PD_EA_OCC_NUM] [float] NULL,
	[BI_PD_COMB_TEXT] [varchar](15) NULL,
	[EXCESS_LIAB_TXCD] [varchar](2000) NULL,
	[BI_PD_AGG_TEXT] [varchar](15) NULL,
	[WORK_COMP_NUM] [float] NULL,
	[WORK_COMP_TEXT] [varchar](25) NULL,
	[WC_EA_ACC_NUM] [float] NULL,
	[OPER_DESC_TXCD] [varchar](2000) NULL,
	[ISSUE_DT_DATE] [varchar](8) NULL,
	[CERTIFICATE_ID_RMDB] [int]  NULL,	
	) ON [PRIMARY]
END





IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS]') AND type in (N'U'))
DROP TABLE [dbo].[BOND_ABS]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'BOND_ABS') 
BEGIN
	CREATE TABLE [dbo].[BOND_ABS](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BOND_ABS_ID] [int]  NULL,
	[BOND_NUM_TEXT] [varchar](20) NULL,
	[BOND_TYPE_TXCD] [varchar](2000) NULL,
	[BOND_LINE_CODE] [int] NULL,
	[EFF_DATE_DATE] [varchar](8) NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[BOND_AMT_AMT] [float] NULL,
	[PREMIUM_AMT] [float] NULL,
	[BILL_NAME_TEXT] [varchar](50) NULL,
	[BILL_ADDR_TEXT] [varchar](50) NULL,
	[BILL_CITY_TEXT] [varchar](25) NULL,
	[BILL_ZIP_TEXT] [varchar](15) NULL,
	[BILL_ACCT_TEXT] [varchar](50) NULL,
	[PRINCIPAL_TXCD] [varchar](2000) NULL,
	[STATE_TEXT] [varchar](3) NULL,
	[BILL_STATE_TEXT] [varchar](25) NULL,
	[OBLIGEE_TXCD] [varchar](2000) NULL,
	[BOND_CLASS_CODE] [int] NULL,
	[OLD_BOND_NO_TEXT] [varchar](25) NULL,
	[REQUESTER_TEXT] [varchar](50) NULL,
	[REQ_ADDR_TEXT] [varchar](50) NULL,
	[REQ_CITY_TEXT] [varchar](25) NULL,
	[REQ_STATE_TEXT] [varchar](25) NULL,
	[REQ_ZIP_TEXT] [varchar](15) NULL,
	[REQ_PHONE_TEXT] [varchar](15) NULL,
	[ORDERED_BY_TEXT] [varchar](50) NULL,
	[ORDER_ADDR_TEXT] [varchar](50) NULL,
	[ORDER_CITY_TEXT] [varchar](25) NULL,
	[ORDER_STATE_TEXT] [varchar](15) NULL,
	[ORDER_ZIP_TEXT] [varchar](15) NULL,
	[ORDER_PHONE_TEXT] [varchar](25) NULL,
	[AUTH_BY_TEXT] [varchar](50) NULL,
	[AUTH_ADDR_TEXT] [varchar](50) NULL,
	[AUTH_CITY_TEXT] [varchar](25) NULL,
	[AUTH_STATE_TEXT] [varchar](15) NULL,
	[AUTH_ZIP_TEXT] [varchar](15) NULL,
	[AUTH_PHONE_TEXT] [varchar](15) NULL,
	[DATE_EXEC_DATE] [varchar](8) NULL,
	[PAID_DATE_DATE] [varchar](8) NULL,
	[BOND_STATUS_CODE] [int] NULL,
	[DATE_CANC_DATE] [varchar](8) NULL,
	[BOND_DETAIL_TXCD] [varchar](2000) NULL,
	 CONSTRAINT [PK_BOND_ABS] PRIMARY KEY CLUSTERED 
	(
		[DA_ROW_ID] ASC,
		[JOBID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_BOND_ABS]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_BOND_ABS]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_BOND_ABS') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_BOND_ABS](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[BOND_ABS_ID] [int]  NULL,
		[BOND_LINE_CODE] [varchar](25) NULL,
		[BOND_CLASS_CODE] [varchar](25) NULL,
		[BOND_STATUS_CODE] [varchar](25) NULL,						 		
	 CONSTRAINT [PK_T_DIS_BOND_ABS] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOND_ABS_TEMP_FD]') AND type in (N'U'))
DROP TABLE [dbo].[BOND_ABS_TEMP_FD]
GO



IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'BOND_ABS_TEMP_FD') 
BEGIN
	CREATE TABLE [dbo].[BOND_ABS_TEMP_FD](
		[DA_ROW_ID] [int] NOT NULL,
		[JOBID] [int] NOT NULL,
		[INPUT_ROW_ID] [int] NULL,
		[INVALID_ROW] [int] NULL,
		[UPDATE_ROW] [int] NULL,
		[BOND_ABS_ID] [int]  NULL,
	[BOND_NUM_TEXT] [varchar](20) NULL,
	[BOND_TYPE_TXCD] [varchar](2000) NULL,
	[BOND_LINE_CODE] [int] NULL,
	[EFF_DATE_DATE] [varchar](8) NULL,
	[EXPIR_DATE_DATE] [varchar](8) NULL,
	[BOND_AMT_AMT] [float] NULL,
	[PREMIUM_AMT] [float] NULL,
	[BILL_NAME_TEXT] [varchar](50) NULL,
	[BILL_ADDR_TEXT] [varchar](50) NULL,
	[BILL_CITY_TEXT] [varchar](25) NULL,
	[BILL_ZIP_TEXT] [varchar](15) NULL,
	[BILL_ACCT_TEXT] [varchar](50) NULL,
	[PRINCIPAL_TXCD] [varchar](2000) NULL,
	[STATE_TEXT] [varchar](3) NULL,
	[BILL_STATE_TEXT] [varchar](25) NULL,
	[OBLIGEE_TXCD] [varchar](2000) NULL,
	[BOND_CLASS_CODE] [int] NULL,
	[OLD_BOND_NO_TEXT] [varchar](25) NULL,
	[REQUESTER_TEXT] [varchar](50) NULL,
	[REQ_ADDR_TEXT] [varchar](50) NULL,
	[REQ_CITY_TEXT] [varchar](25) NULL,
	[REQ_STATE_TEXT] [varchar](25) NULL,
	[REQ_ZIP_TEXT] [varchar](15) NULL,
	[REQ_PHONE_TEXT] [varchar](15) NULL,
	[ORDERED_BY_TEXT] [varchar](50) NULL,
	[ORDER_ADDR_TEXT] [varchar](50) NULL,
	[ORDER_CITY_TEXT] [varchar](25) NULL,
	[ORDER_STATE_TEXT] [varchar](15) NULL,
	[ORDER_ZIP_TEXT] [varchar](15) NULL,
	[ORDER_PHONE_TEXT] [varchar](25) NULL,
	[AUTH_BY_TEXT] [varchar](50) NULL,
	[AUTH_ADDR_TEXT] [varchar](50) NULL,
	[AUTH_CITY_TEXT] [varchar](25) NULL,
	[AUTH_STATE_TEXT] [varchar](15) NULL,
	[AUTH_ZIP_TEXT] [varchar](15) NULL,
	[AUTH_PHONE_TEXT] [varchar](15) NULL,
	[DATE_EXEC_DATE] [varchar](8) NULL,
	[PAID_DATE_DATE] [varchar](8) NULL,
	[BOND_STATUS_CODE] [int] NULL,
	[DATE_CANC_DATE] [varchar](8) NULL,
	[BOND_DETAIL_TXCD] [varchar](2000) NULL,
	[BOND_ABS_ID_RMDB] [int]  NULL,
	
	) ON [PRIMARY]
END







IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PS_ENDORSEMENT]') AND type in (N'U'))
DROP TABLE [dbo].[PS_ENDORSEMENT]
GO
IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'PS_ENDORSEMENT') 
BEGIN
CREATE TABLE [dbo].[PS_ENDORSEMENT](
	
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,	
	[ENDORSEMENT_ID] [int] NULL,
	[POLICY_ID] [int] NULL,
	[TABLE_ID] [int] NULL,
	[ROW_ID] [int] NULL,
	[FORM_NUMBER] [varchar](14) NULL,
	[FORM_DATE] [varchar](14) NULL,
	[FORM_DESCRIPTION] [varchar](100) NULL,
	[STAT] [varchar](50) NULL,
	[INS_LINE] [varchar](50) NULL,
	[LOC] [varchar](50) NULL,
	[BLDG] [varchar](50) NULL,
	[UNIT] [varchar](50) NULL,
	[FORM_ACTION] [varchar](100) NULL,
	[EZ_SCM] [varchar](50) NULL,
	[DATA] [varchar](50) NULL,
	[ITERATIVE] [varchar](50) NULL,
	[DTTM_RCD_ADDED] [varchar](50) NULL,
	[ADDED_BY_USER] [varchar](50) NULL,
	[EDITIONDATE] [varchar](14) NULL,
	[RATEOP] [varchar](50) NULL,
	[ENTRYDTE] [varchar](14) NULL,
  CONSTRAINT [PK_PS_ENDORSEMENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_PS_ENDORSEMENT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_PS_ENDORSEMENT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_PS_ENDORSEMENT') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_PS_ENDORSEMENT](
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[TABLE_NAME] [varchar] (30) NULL, -- It will be populated from Table Name in import File
							 		
	 CONSTRAINT [PK_T_DIS_PS_ENDORSEMENT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END






/****** Object:  Table [dbo].[SALVAGE]    Script Date: 06/01/2015 16:56:24 ******/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SALVAGE]') AND type in (N'U'))
DROP TABLE [dbo].[SALVAGE]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'SALVAGE') 
BEGIN
CREATE TABLE [dbo].[SALVAGE](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[SALVAGE_ROW_ID] [int] NULL,
	[PARENT_NAME] [varchar](50) NULL,
	[IS_INSURED] [int] NULL,
	[IS_OWNER_RETAINED] [int] NULL,
	[SALVAGE_TYPE] [int] NULL,
	[POSSESSION_OF] [int] NULL,
	[CONTROLNUMBER] [varchar](50) NULL,
	[SALVAGE_STATUS] [int] NULL,
	[MOVE_DATE] [varchar](8) NULL,
	[CLOSE_DATE] [varchar](8) NULL,
	[STOCKNUMBER] [varchar](50) NULL,
	[CUTOFF_DATE] [varchar](8) NULL,
	[DAILYFEES] [float] NULL,
	[CUTOFFREASON] [int] NULL,
	[APPRAISED_DATE] [varchar](8) NULL,
	[ACT_CASH_VALUE] [float] NULL,
	[EST_SALVAGE_VALUE] [float] NULL,
	[TOW_CHARGE] [float] NULL,
	[STORAGE_VALUE] [float] NULL,
	[OTHER_CHARGES] [float] NULL,
	[TOTAL_CHARGES] [float] NULL,
	[SOLD_DATE] [varchar](8) NULL,
	[NETRECOVERY] [float] NULL,
	[SALE_PRICE] [float] NULL,
	[RECOVERY_RATE] [int] NULL,
	[PARENT_ID] [int] NOT NULL,
	[BUYER_EID] [int] NULL,
	[SALVAGE_YARD_ADDR_ID] [int] NULL,
	[MILEAGE] [int] NULL,
	[TITLE_NUMBER] [varchar](15) NULL,
	[STATE_BRAND_CODE] [int] NULL,
	[THEFT_RECOVERED] [int] NULL,
	[SALVAGE_DSGND_DATE] [varchar](8) NULL,
	[SALVAGE_REASON] [varchar](4000) NULL,
 
 CONSTRAINT [PK_SALVAGE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
		
		
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END




IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_SALVAGE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_SALVAGE]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_SALVAGE') 
BEGIN
	CREATE TABLE [dbo].[T_DIS_SALVAGE](
	[UNIT_ID] [int] NULL,
		[JOBID] [int] NOT NULL,
		[DA_ROW_ID] [int] NOT NULL,
		[CUTOFFREASON] varchar (25) NULL,
		[SALVAGE_TYPE] varchar (25) NULL,
		[SALVAGE_STATUS] varchar (25) NULL,
		[BUYER_FIRST_NAME] [varchar](255) NULL,   ---Fields will be used to get Buyer EID from RMA
		[BUYER_LAST_NAME] [varchar](255) NULL,
		[BUYER_TAX_ID]  [varchar](20) NULL,
		[STATE_BRAND_CODE]varchar (25) NULL,
 CONSTRAINT [PK_T_SALVAGE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLICY_X_STATE]') AND type in (N'U'))
DROP TABLE [dbo].[POLICY_X_STATE]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POLICY_X_STATE') 
BEGIN

CREATE TABLE [dbo].[POLICY_X_STATE](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[POLICY_ID] [int] NULL,
	[STATE_ID] [int] NULL,
 CONSTRAINT [PK_POLICY_X_STATE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END
 
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POLICY_X_STATE]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POLICY_X_STATE]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POLICY_X_STATE') 
BEGIN

CREATE TABLE [dbo].[T_DIS_POLICY_X_STATE](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[POLICY_ID] [int] NULL,
	[STATE_ID] [VARCHAR] (25) NULL,
 CONSTRAINT [PK_T_DIS_POLICY_X_STATE] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END
 
 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POL_COV_LIMIT]') AND type in (N'U'))
DROP TABLE [dbo].[POL_COV_LIMIT ]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'POL_COV_LIMIT') 
BEGIN

CREATE TABLE [dbo].[POL_COV_LIMIT](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[LIMIT_ROW_ID] [int] null,
	[POLICY_KEY] [VARCHAR] (50) NULL,
	[COVERAGE_KEY]  [VARCHAR] (100) NULL,
	[LIMIT_TYPE_CODE] [int] NULL,
	[LIMIT_AMOUNT] [float] NULL,
	[STAGING_ID][int] NULL,
	
 CONSTRAINT [PK_POL_COV_LIMIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END
 
 IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_POL_COV_LIMIT]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_POL_COV_LIMIT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'T_DIS_POL_COV_LIMIT') 
BEGIN

CREATE TABLE [dbo].[T_DIS_POL_COV_LIMIT](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[POLICY_KEY] [INT] NULL,
	[COVERAGE_KEY]  [INT] NULL,
	[LIMIT_TYPE_CODE] [varchar] (25) NULL,
	CONSTRAINT [PK_T_DIS_POL_COV_LIMIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END



IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMP_LIMIT]') AND type in (N'U'))
DROP TABLE [dbo].[TEMP_LIMIT]
GO

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'TEMP_LIMIT') 
BEGIN

CREATE TABLE [dbo].[TEMP_LIMIT](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[LIMIT_ROW_ID] [int] null,
	[POLICY_KEY] [VARCHAR] (50) NULL,
	[COVERAGE_KEY]  [VARCHAR] (100) NULL,
	[LIMIT_TYPE_CODE] [int] NULL,
	[LIMIT_AMOUNT] [float] NULL,
	[STAGING_ID][int] NULL,
	CONSTRAINT [PK_TEMP_LIMIT] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END