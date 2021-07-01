GO

/****** Object:  Table [dbo].[EMP_SUPP]    Script Date: 9/11/2018 12:28:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMP_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[EMP_ID_TYPE] [int] NULL,
	[EMP_STATUS] [int] NULL,
	[WAGE_PERIOD] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[T_DIS_ENTITY_SUPP](
	[JOBID] [int] NOT NULL,
	[DA_ROW_ID] [int] NOT NULL,
	[ENTITY_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



CREATE TABLE [dbo].[T_DIS_EMP_SUPP](
	[JOBID] [int] NOT NULL,
	[DA_ROW_ID] [int] NOT NULL,
	[EMP_ID_TYPE] [varchar](25) NULL,
	[EMP_STATUS] [varchar](25) NULL,
	[EMPLOYEE_EID] [int] NULL,
	[WAGE_PERIOD] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


CREATE TABLE [dbo].[ENTITY_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[JOBID] [int] NOT NULL
) ON [PRIMARY]



GO

