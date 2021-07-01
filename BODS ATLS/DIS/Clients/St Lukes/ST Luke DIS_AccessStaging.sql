GO

/****** Object:  Table [dbo].[EMP_SUPP]    Script Date: 9/11/2018 12:29:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EMP_SUPP](
	[BATCH_ID] [int] NULL,
	[OPTIONSET_ID] [int] NULL,
	[EMP_ID_TYPE] [nvarchar](25) NULL,
	[EMP_STATUS] [nvarchar](25) NULL,
	[WAGE_PERIOD] [nvarchar](25) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[ENTITY_SUPP](
	[OPTIONSET_ID] [int] NULL,
	[ENTITY_ID] [int] NULL,
	[BATCH_ID] [int] NULL
) ON [PRIMARY]


GO


