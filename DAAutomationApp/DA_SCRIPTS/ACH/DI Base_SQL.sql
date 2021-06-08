-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--
--   DESCRIPTION: Structure Definition Script for
--   Table:	DATA_INTEGRATOR, DATA_INTEGRATOR_TEMPLATES
--   Version:	Compatible with all versions
--   Note :     FILE_COUNT column was added in 17.3
--   DATE:	16/11/2017 2:25:50 PM
--   Author:	Aditi Gurha
-- ============================================================= 

-- Create the table if not exists already
----------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DATA_INTEGRATOR]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		CREATE TABLE [dbo].[DATA_INTEGRATOR](
			[OPTIONSET_ID] [int] NOT NULL,
			[USER_ID] [int] NOT NULL,
			[MODULE_NAME] [varchar](50) NOT NULL,
			[OPTIONSET_NAME] [varchar](50) NOT NULL,
			[XML_STRING] [Text] NULL,
			[DTTM_LAST_RUN] [varchar](16) NULL,
			[FILE_COUNT] [int] NULL
		PRIMARY KEY CLUSTERED 
		(
			[OPTIONSET_ID] ASC
		) ON [PRIMARY]
		) ON [PRIMARY]
	END
ELSE
	BEGIN
		IF NOT EXISTS(SELECT * FROM sys.columns WHERE name = N'FILE_COUNT' AND Object_ID = OBJECT_ID(N'[dbo].[DATA_INTEGRATOR]') AND OBJECTPROPERTY(Object_ID, N'IsUserTable') = 1)
		BEGIN
			ALTER TABLE DATA_INTEGRATOR ADD FILE_COUNT [int] NULL;
		END
	END
------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DATA_INTEGRATOR_TEMPLATES]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[DATA_INTEGRATOR_TEMPLATES](
	[ROW_ID] [int] NOT NULL,
	[MODULE_NAME] [varchar](50) NOT NULL,
	[XML_STRING] [Text] NOT NULL
) ON [PRIMARY]
END
---------------------------------------------
BEGIN
IF NOT EXISTS (SELECT * FROM sys.columns WHERE name = N'STR_PARM_VALUE_LARGE_TEXT' AND Object_ID = OBJECT_ID(N'[dbo].[PARMS_NAME_VALUE]') AND OBJECTPROPERTY(Object_ID, N'IsUserTable') = 1)
		BEGIN
			ALTER TABLE PARMS_NAME_VALUE ADD STR_PARM_VALUE_LARGE_TEXT TEXT NULL
		END
END
---------------------------------------------