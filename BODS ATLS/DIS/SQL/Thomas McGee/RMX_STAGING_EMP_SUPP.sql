-- =================================================================================
--   SCRIPT HEADER (MSSQL RMX_STAGING DATABASE SUPLEMENTAL TABLE)
--   Database	: RMX_STAGING DATABASE	
--   Module Name: DA DIS
--   Description: DDL for Data Analytics DIS Thomas McGee Supplemental Tables
--   Date	: 05/17/2012 01:38:00 PM
-- ================================================================================= 

USE [DA_RMX_STAGING]
GO

/****** Object:  Table [dbo].[EMP_SUPP]    Script Date: 05/17/2012  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[EMP_SUPP]

        ADD 

            [MVR_ANNUAL_TEXT] [varchar](15) NULL,
            [VALID_LICEN_CODE] [int] NULL,
            [DRVR_FREQ_TEXT] [varchar](8) NULL,
            [GRDE_PNT_TEXT]  [varchar](25) NULL,
            [FCRA_AUTH_TEXT] [varchar](6) NULL,
            [DRVR_STAT_TEXT] [varchar](15) NULL,
            [POSITION_TITLE] [varchar](35) NULL,
	    [EMP_EID_SOURCE] [int] NULL	
       GO



            