-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Template-rmA 15.4_DIS
--   DESCRIPTION: Structure Definition Script for
--   Table:	DATA_INTEGRATOR, DATA_INTEGRATOR_TEMPLATES
--
--   DATE:	19/03/2009 2:25:50 PM
--   Author: Tanu Malay Singh
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
PRIMARY KEY CLUSTERED 
(
	[OPTIONSET_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
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
--------------------------------------------
