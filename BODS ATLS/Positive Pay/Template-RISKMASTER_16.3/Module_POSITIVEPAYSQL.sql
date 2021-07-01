-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   DI Module Name: POSITIVE PAY
--   Template-Positive Pay(Version rmA-12.2 to rmA-16.3)	
--   DESCRIPTION: Structure Definition Script for
--   Table:	T_PPY_SETTING
--		T_PPY_ACCOUNTNUMBER
--		T_PPY_HEADERHOLD
--		T_PPY_DETAILHOLD
--		T_PPY_POSITIVEPAYOUTPUT
--		T_PPY_IMPORT
--		T_PPY_VALIDATED_INPUT
--		T_PPY_CHECKSNOTVOID
--		T_PPY_FUNDS	--ipuri 10/28/2013 Mits:34159
--		ERROR_LOG
--   DATE:	25/03/2009 2:25:50 PM
--   Vsoni5 : 05/19/2011 : MITS 25017 : Script updated to delete staging tables if exist.
-- =============================================================
IF ((SELECT COUNT(*) AS isRMDB FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SYS_PARMS')=1)
	BEGIN
		PRINT 'Error: Script Execution Aborted - Script trying to execute on RISKMASTER database not on DA Staging database. Please open the correct Staging database and execute this script.';
	END
ELSE
BEGIN

-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_SETTING]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_SETTING

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
 
CREATE TABLE [dbo].[T_PPY_SETTING](
	[JobID] [int] NULL,
	[POSITIVE_PAY_TYPE] [varchar](1024) NULL,
	[ACCOUNTLEN] [varchar](1024) NULL,
	[BANKFORMAT] [varchar](1024)  NULL,
	[ACCOUNT_ID] [varchar](1024) NULL,
	[MANUALLYCHANGEDATERANGE] [varchar](1024) NULL,
	[FROM_DATE] [varchar](1024)  NULL,
	[TO_DATE] [varchar](1024) NULL,
	[TARGET_FILE] [varchar](1024)  NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_ACCOUNTNUMBER]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_ACCOUNTNUMBER

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_ACCOUNTNUMBER](
	[ROW_ID] [int] NULL,
	[JOBID] [int] NULL,
	[ACCOUNT_NUMBER] [varchar](20) NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_HEADERHOLD]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_HEADERHOLD 

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_HEADERHOLD](
	[JOBID] [int] NOT NULL,
	[ACCOUNT_NUMBER] [varchar](20) NULL,
	[ACCOUNT_ID] [int] NOT NULL,
	[ACCOUNT_NAME] [varchar](50) NULL,
	[STATE_ID] [varchar](4) NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_DETAILHOLD]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_DETAILHOLD
BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_DETAILHOLD](
	[JOBID] [int] NULL,
	[TRANS_NUMBER] [Bigint] NULL,
	[S_AMOUNT] [float] NULL,
	[DATE_OF_CHECK] [varchar](8) NULL,
	[VOID_FLAG] [int] NULL,
	[VOID_DATE] [varchar](8) NULL,
	[STATUS_CODE] [int] NULL,
	[CLEARED_FLAG] [int] NULL,
	[FIRST_NAME] [varchar](255)  NULL,
	[LAST_NAME] [varchar](255)  NULL,
	[PAYEE_EID] [int] NULL,
	[ACCOUNT_NUMBER] [varchar](50) NULL,
	[ACCOUNT_NAME] [varchar](50)  NULL,
	[TAX_ID] [varchar](20) NULL,
	[PAY_TO_THE_ORDER_OF] varchar(255) NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_POSITIVEPAYOUTPUT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_POSITIVEPAYOUTPUT
BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_POSITIVEPAYOUTPUT](
	[JOBID] [int] NULL,
	[ACCOUNTNUMBER] [varchar](1050) NULL,
	[SEGMENT] [varchar](50) NULL,
	[ALLDATA] [varchar](157) NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_IMPORT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_IMPORT

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_IMPORT](
	[JOBID] [int] NULL,
	[ACCOUNTNUMBER] [varchar](20) NULL,
	[CHECKNUMBER] [decimal](10, 0) NULL,
	[INPUT_AMOUNT] [float] NULL,
	[CHECKDATE] [varchar](8) NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_VALIDATED_INPUT]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_VALIDATED_INPUT

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_VALIDATED_INPUT](
	[JOBID] [int] NULL,
	[ACCOUNTNUMBER] [varchar](20) NULL,
	[CHECKNUMBER] [decimal](10, 0) NULL,
	[INPUT_AMOUNT] [float] NULL,
	[CHECKDATE] [varchar](8) NULL,
	[ACCOUNT_ID] [int] NULL,
	[VOID_FLAG] [int] NULL
) ON [PRIMARY]

END
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_CHECKSNOTVOID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_CHECKSNOTVOID

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_CHECKSNOTVOID](
	[JOBID] [int] NULL,
	[ACCOUNTNUMBER] [varchar](20) NULL,
	[CHECKNUMBER] [decimal](10, 0) NULL,
	[INPUT_AMOUNT] [float] NULL,
	[CHECKDATE] [varchar](8),
	[ACCOUNT_ID] [int] NULL
) ON [PRIMARY]

END
-- =============================================================
--/****** Object:  Table [dbo].[ERROR_LOG]    Script Date: 03/25/2009 15:27:11 ******/
-- Create the table if not exists already
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ERROR_LOG]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[ERROR_LOG]
BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

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

-------------------------------------------------------
--ipuri 10/28/2013 Mits:34159 Start
-- =============================================================
-- Delete the Staging table if already exists then create a new table
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_PPY_FUNDS]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE T_PPY_FUNDS

BEGIN

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF

CREATE TABLE [dbo].[T_PPY_FUNDS](
	[JOBID] [int] NOT NULL,
	[TRANS_NUMBER] [decimal](30, 0) NULL,
	[AMOUNT] [float] NULL,
	[DATE_OF_CHECK] [varchar](8) NULL,
	[VOID_FLAG] [int] NULL,
	[VOID_DATE] [varchar](8) NULL,
	[STATUS_CODE] [int] NULL,
	[CLEARED_FLAG] [int] NULL,
	[FIRST_NAME] [varchar](255) NULL,
	[LAST_NAME] [varchar](255) NULL,
	[PAYEE_EID] [int] NULL,
	[PAY_TO_THE_ORDER_OF] [varchar](255) NULL,
	[ACCOUNT_ID] [int] NULL,

) ON [PRIMARY]

END

END
-- =============================================================
--ipuri 10/28/2013 Mits:34159 End
