--==========================================================
---Template_DIS(rmA17.2 and Onwards)
--08/21/2017
--==========================================================
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Access Staging database. Please open the correct Access Staging database and execute this script.';
	END
ELSE
BEGIN

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_SUPP]
 
 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMP_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[EMPLOYEE_EID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[AIN_TEXT] [nvarchar](255) NULL,
	[EMP_STATUS_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END
  
  IF EXISTS (SELECT * FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='EMP_SUPP' AND IMPORT_AREA = 'Employees_Flag')
DELETE FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='EMP_SUPP' AND IMPORT_AREA = 'Employees_Flag'

  INSERT into IMPORT_AREAS_STRUCTURE VALUES(7, 'Employees_Flag','EMP_SUPP','CREATE TABLE [dbo].[EMP_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[EMPLOYEE_EID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[AIN_TEXT] [nvarchar](255) NULL,
	[EMP_STATUS_CODE] [nvarchar](25) NULL
)')


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[ENTITY_SUPP]

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENTITY_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ENTITY_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[STATUS_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='ENTITY_SUPP' AND IMPORT_AREA = 'Entities_Flag')
DELETE FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='ENTITY_SUPP' AND IMPORT_AREA = 'Entities_Flag'

INSERT into IMPORT_AREAS_STRUCTURE VALUES(2, 'Entities_Flag','ENTITY_SUPP','CREATE TABLE [dbo].[ENTITY_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[STATUS_CODE] [nvarchar](25) NULL
)')


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[FUNDS_SUPP]


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNDS_SUPP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FUNDS_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[GB_PAY_TYPE_CODE] [nvarchar](25) NULL,
	[GB_RCV_TYPE_CODE] [nvarchar](25) NULL,
	[GB_TXN_TYPE_CODE] [nvarchar](25) NULL,
	[ESISPAYCODE_CODE] [nvarchar](25) NULL,
	[ESISPAYTYPE_CODE] [nvarchar](25) NULL
) ON [PRIMARY]
END


IF EXISTS (SELECT * FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='FUNDS_SUPP' AND IMPORT_AREA = 'Funds_Flag')
DELETE FROM IMPORT_AREAS_STRUCTURE WHERE TABLES_NAME ='FUNDS_SUPP' AND IMPORT_AREA = 'Funds_Flag'

INSERT into IMPORT_AREAS_STRUCTURE VALUES(15,'Funds_Flag','FUNDS_SUPP','CREATE TABLE [dbo].[FUNDS_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[BATCH_ID] [int] NULL,
	[GB_PAY_TYPE_CODE] [nvarchar](25) NULL,
	[GB_RCV_TYPE_CODE] [nvarchar](25) NULL,
	[GB_TXN_TYPE_CODE] [nvarchar](25) NULL,
	[ESISPAYCODE_CODE] [nvarchar](25) NULL,
	[ESISPAYTYPE_CODE] [nvarchar](25) NULL
) ')

END

