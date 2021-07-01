/****** Object:  Table [dbo].[EMP_SUPP]    Script Date: 12/12/2013 15:05:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMP_SUPP]') AND type in (N'U'))
DROP TABLE [dbo].[EMP_SUPP]

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

CREATE TABLE [dbo].[EMP_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[EMPLOYEE_EID] [int] NULL,
	[EMP_APPOINT_GRID] [text] NULL,
	[REG_TEMP_CODE] [varchar](25) NULL,
	[ACTION_DATE] [varchar](8) NULL,
	[HIRE_STATE] [varchar](25) NULL,
	[JOB_FAMILY_CODE] [varchar](25) NULL,
	[UNION_CODE] [varchar](25) NULL,
	[ADDR3RD_TEXT] [varchar](50) NULL,
	[MED_COST_AMT] [float] NULL,
	[DENTAL_COST_AMT] [float] NULL,
	[LIFE_COST_AMT] [float] NULL,
	[SPOUSE_COST_AMT] [float] NULL,
	[DPNDNT_COST_AMT] [float] NULL,
	[VISION_COST_AMT] [float] NULL,
	[LEGAL_COST_AMT] [float] NULL,
	[RETIRE_DATE] [varchar](8) NULL,
	[EXT_SK_FULL_NUM] [float] NULL,
	[EXT_SK_HALF_NUM] [float] NULL,
	[SICK_BAL_NUM] [float] NULL,
	[VACA_BAL_NUM] [float] NULL,
	[PTO_BAL_NUM] [float] NULL,
	[EMP_STATUS__CODE] [varchar](25) NULL,
	[LTD_COST_AMT] [float] NULL,
	[MD_LEAVE_ST_DATE] [varchar] (8) NULL,
	[MD_LEAVE_EN_DATE] [varchar] (8) NULL,
	[FUND_CODE_TEXT] [varchar] (10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING OFF



