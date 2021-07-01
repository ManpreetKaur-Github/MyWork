-- ============================================================
--   SCRIPT HEADER (MSSQL RMX_STAGING DATABASE STRUCTURE)
--   Template_DIS(rmA17.2 and Onwards)
--   Module Name: DA2 (All)
--   Description: 	DDL for Data Analytics DIS
--   Date:		06/14/2018   
-- ============================================================= 
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN

-------------------------------------------------------------------mkaur24 start 06142018---------------------------
BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_SUPP]
END

BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_EMP_SUPP]
END

BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_SUPP]
END

BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_ENTITY_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_ENTITY_SUPP]
END

BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_SUPP]
END

BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_DIS_FUNDS_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[T_DIS_FUNDS_SUPP]
END



-------------------------------------------------------------------mkaur24 start 06142018---------------------------
BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_SUPP]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'EMP_SUPP') 
BEGIN

CREATE TABLE [dbo].[EMP_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[EMP_STATUS_CODE] [int] NULL,
	[AIN_TEXT] [varchar](255) NULL,
	[EMPLOYEE_EID] [int] NULL,
	CONSTRAINT [PK_EMP_SUPP] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END

 BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_SUPP]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'ENTITY_SUPP') 
BEGIN

CREATE TABLE [dbo].[ENTITY_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[STATUS_CODE] [int] NULL,
	CONSTRAINT [PK_ENTITY_SUPP] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END

 BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_SUPP]
END

IF NOT EXISTS (SELECT name FROM sys.tables WHERE name = 'FUNDS_SUPP') 
BEGIN

CREATE TABLE [dbo].[FUNDS_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[TRANS_ID] [int] NULL,
	[GB_PAY_TYPE_CODE] [int] NULL,
	[GB_RCV_TYPE_CODE] [int] NULL,
	[GB_TXN_TYPE_CODE] [int] NULL,
	[ESISPAYCODE_CODE] [int] NULL,
	[ESISPAYTYPE_CODE] [int] NULL,
	CONSTRAINT [PK_FUNDS_SUPP] PRIMARY KEY CLUSTERED 
	(
		[JOBID] ASC,
		[DA_ROW_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

 )
 
 END
END