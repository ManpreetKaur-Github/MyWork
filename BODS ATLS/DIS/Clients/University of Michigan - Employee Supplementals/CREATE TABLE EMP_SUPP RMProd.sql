USE [UMICH_RMProd]
GO

/****** Object:  Table [dbo].[EMP_SUPP]    Script Date: 11/18/2013 15:06:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EMP_SUPP](
	[EMPLOYEE_EID] [int] NOT NULL,
	[COPHYSEXAM_DATE] [varchar](8) NULL,
	[EMP_APPOINT_MEMO] [text] NULL,
	[EMP_APPOINT_TXCD] [text] NULL,
	[REG_TEMP_CODE] [int] NULL,
	[ACTION_DATE] [varchar](8) NULL,
	[ANNUAL_AMT] [float] NULL,
	[EMPLMNT_STA_CODE] [int] NULL,
	[HIRE_DATE] [varchar](8) NULL,
	[HIRE_STATE] [int] NULL,
	[JOB_FAMILY_CODE] [int] NULL,
	[UNION_CODE] [int] NULL,
	[ADDR3RD_TEXT] [varchar](50) NULL,
	[MEDICAL_COS_AMT] [float] NULL,
	[MED_COST_AMT] [float] NULL,
	[DENTAL_COST_AMT] [float] NULL,
	[LIFE_COST_AMT] [float] NULL,
	[SPOUSE_COST_AMT] [float] NULL,
	[DPNDNT_COST_AMT] [float] NULL,
	[VISION_COST_AMT] [float] NULL,
	[LEGAL_COST_AMT] [float] NULL,
	[RETIRE_DATE] [varchar](8) NULL,
	[LTD_APPRVL_DATE] [varchar](8) NULL,
	[LTD_DENIED_DATE] [varchar](8) NULL,
	[EXT_SK_FULL_NUM] [float] NULL,
	[EXT_SK_HALF_NUM] [float] NULL,
	[SICK_BAL_NUM] [float] NULL,
	[VACA_BAL_NUM] [float] NULL,
	[PTO_BAL_NUM] [float] NULL,
	[EMP_STATUS__CODE] [int] NULL,
	[PRE_DIS_BEN_CODE] [int] NULL,
 CONSTRAINT [PK_EMP_SUPP] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_EID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [REG_TEMP_CODE]
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [EMPLMNT_STA_CODE]
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [JOB_FAMILY_CODE]
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [UNION_CODE]
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [EMP_STATUS__CODE]
GO

ALTER TABLE [dbo].[EMP_SUPP] ADD  DEFAULT ((0)) FOR [PRE_DIS_BEN_CODE]
GO


























EMPLOYEE_EID: Self-explanatory 
EMP_APPOINT_GRID: This is the grid field, data stored in SUPP_GRID_VALUE table
REG_TEMP_CODE: Temp/Reg flag (Code table REG_TEMP (2401)) 
ACTION_DATE: *doesn't appear in document*
ANNUAL_AMT: *doesn't appear in document*
HIRE_STATE: Hire state ("Code" table STATES (46))                                          EMPLMNT_STA_CODE: Employment status (Code table EMPLOY_STATUS (2342))
JOB_FAMILY_CODE: Job family (Code table JOB_FAMILY (2344))                                     HIRE_STATE: Hire state ("Code" table STATES (46))
UNION_CODE: Union code (Code table UNION (2402))                                          JOB_FAMILY_CODE: Job family (Code table JOB_FAMILY (2344))
ADDR3RD_TEXT: Address 3                                                                      UNION_CODE: ??? Union code (Code table ACCIDENT_TYPE (1090))
MED_COST_AMT: Medical cost                                                                  ADDR3RD_TEXT
DENTAL_COST_AMT: Dental cost                                                               MED_COST_AMT
LIFE_COST_AMT: Life cost                                                                 DENTAL_COST_AMT
SPOUSE_COST_AMT: Spousal cost                                                               LIFE_COST_AMT
DPNDNT_COST_AMT: Dependent cost                                                               SPOUSE_COST_AMT
VISION_COST_AMT: Vision cost                                                               DPNDNT_COST_AMT
LEGAL_COST_AMT: Legal cost                                                                VISION_COST_AMT
RETIRE_DATE: Retire date                                                                   LEGAL_COST_AMT
LTD_APPRVL_DATE: *"LTD plan" appears in the document as supp field*                                               RETIRE_DATE
LTD_DENIED_DATE: *but appears to be an amount and not a date*                                               LTD_APPRVL_DATE
EXT_SK_FULL_NUM: Extended sick full pay balance                                               LTD_DENIED_DATE
EXT_SK_HALF_NUM: Extended sick half pay balance                                               EXT_SK_FULL_NUM
SICK_BAL_NUM: Sick balance                                                               EXT_SK_HALF_NUM
VACA_BAL_NUM: Vacation balance                                                               SICK_BAL_NUM
PTO_BAL_NUM: PTO balance                                                                VACA_BAL_NUM
EMP_STATUS__CODE: Employment status (Code table EMPLOY_STATUS (2342))
                       PTO_BAL_NUM
                                       Test_TEXT: *Test field?*
                                       Union2a_CODE: ??? Union code (Code table UNION (2402))
                                       TESTAGAIN_TEXT: *Test field?*
EMPLOYEE_EID
EMP_APPOINT_GRID
REG_TEMP_CODE
ACTION_DATE
ANNUAL_AMT
HIRE_STATE
JOB_FAMILY_CODE
UNION_CODE
ADDR3RD_TEXT
MED_COST_AMT
DENTAL_COST_AMT
LIFE_COST_AMT
SPOUSE_COST_AMT
DPNDNT_COST_AMT
VISION_COST_AMT
LEGAL_COST_AMT
RETIRE_DATE
LTD_APPRVL_DATE
LTD_DENIED_DATE
EXT_SK_FULL_NUM
EXT_SK_HALF_NUM
SICK_BAL_NUM
VACA_BAL_NUM
PTO_BAL_NUM
EMP_STATUS__CODE












2	0	EMP_SUPP	EMPLOYEE_EID	7	0	0	0	0	0	NULL	0	0	NULL	0	0	NULL	NULL	NULL	NULL	0	0	0	0	0	NULL
3162	3162	EMP_SUPP	EMP_APPOINT_GRID	17	0	0	0	0	0		0	0		-26943	0	NULL	Employee Appointment	YongKoh	20130819132402	0	0	0	0	0	Employee Appointment
3226	3226	EMP_SUPP	REG_TEMP_CODE	6	0	0	0	0	0		2401	0		-26879	0	NULL	Reg/Temp	YongKoh	20130910164358	0	0	0	0	0	Reg/Temp
3227	3227	EMP_SUPP	ACTION_DATE	3	8	0	0	0	0		0	0		-26878	0	NULL	Action Date	YongKoh	20130911151822	0	0	0	0	0	Action Date
3228	3228	EMP_SUPP	ANNUAL_AMT	2	0	0	0	0	0		0	0		-26877	0	NULL	Annual Rate	YongKoh	20130910164538	0	0	0	0	0	Annual Rate
3229	3229	EMP_SUPP	EMPLMNT_STA_CODE	6	0	0	0	0	0		2342	0		-26876	0	NULL	Employment Status	YongKoh	20131014113018	0	0	0	0	0	Employment Status
3231	3231	EMP_SUPP	HIRE_STATE	9	0	0	0	0	0		46	0		-26874	0	NULL	Hire State	YongKoh	20130911141510	0	0	0	0	0	Hire State
3232	3232	EMP_SUPP	JOB_FAMILY_CODE	6	0	0	0	0	0		2344	0		-26873	0	NULL	Job Family	YongKoh	20130911142255	0	0	0	0	0	Job Family
3233	3233	EMP_SUPP	UNION_CODE	6	0	0	0	0	0		1090	0		-26872	0	NULL	Union Code	YongKoh	20131029092454	0	0	0	0	0	Union Code
3234	3234	EMP_SUPP	ADDR3RD_TEXT	0	50	0	0	0	0		0	0		-26871	0	NULL	Address 3	YongKoh	20130911150221	0	0	0	0	0	Address 3
3236	3236	EMP_SUPP	MED_COST_AMT	2	0	0	0	0	0		0	0		-26869	0	NULL	Medical Cost	YongKoh	20130911154719	0	0	0	0	0	Medical Cost
3237	3237	EMP_SUPP	DENTAL_COST_AMT	2	0	0	0	0	0		0	0		-26868	0	NULL	Dental Cost	YongKoh	20130911154805	0	0	0	0	0	Dental Cost
3238	3238	EMP_SUPP	LIFE_COST_AMT	2	0	0	0	0	0		0	0		-26867	0	NULL	Life Ins Cost	YongKoh	20130911154840	0	0	0	0	0	Life Ins Cost
3239	3239	EMP_SUPP	SPOUSE_COST_AMT	2	0	0	0	0	0		0	0		-26866	0	NULL	Spouse Ins Cost	YongKoh	20130911155000	0	0	0	0	0	Spouse Ins Cost
3240	3240	EMP_SUPP	DPNDNT_COST_AMT	2	0	0	0	0	0		0	0		-26865	0	NULL	Dependent Ins Cost	YongKoh	20130911155047	0	0	0	0	0	Dependent Ins Cost
3241	3241	EMP_SUPP	VISION_COST_AMT	2	0	0	0	0	0		0	0		-26864	0	NULL	Vision Cost	YongKoh	20130911155121	0	0	0	0	0	Vision Cost
3242	3242	EMP_SUPP	LEGAL_COST_AMT	2	0	0	0	0	0		0	0		-26863	0	NULL	Legal Cost	YongKoh	20130911155138	0	0	0	0	0	Legal Cost
3243	3243	EMP_SUPP	RETIRE_DATE	3	8	0	0	0	0		0	0		-26862	0	NULL	Retire Date	YongKoh	20130911160344	0	0	0	0	0	Retire Date
3244	3244	EMP_SUPP	LTD_APPRVL_DATE	3	8	0	0	0	0		0	0		-26861	0	NULL	LTD Approval Date	YongKoh	20130911160506	0	0	0	0	0	LTD Approval Date
3245	3245	EMP_SUPP	LTD_DENIED_DATE	3	8	0	0	0	0		0	0		-26860	0	NULL	LTD Denied Date	YongKoh	20130911160536	0	0	0	0	0	LTD Denied Date
3246	3246	EMP_SUPP	EXT_SK_FULL_NUM	1	0	0	0	0	0		0	0		-26859	0	NULL	Ext. Sick Full Pay Balance	YongKoh	20130911160743	0	0	0	0	0	Ext. Sick Full Pay Balance
3247	3247	EMP_SUPP	EXT_SK_HALF_NUM	1	0	0	0	0	0		0	0		-26858	0	NULL	Ext. Sick Half Pay Balance	YongKoh	20130911160825	0	0	0	0	0	Ext. Sick Half Pay Balance
3248	3248	EMP_SUPP	SICK_BAL_NUM	1	0	0	0	0	0		0	0		-26857	0	NULL	Sick Balance	YongKoh	20130911160919	0	0	0	0	0	Sick Balance
3249	3249	EMP_SUPP	VACA_BAL_NUM	1	0	0	0	0	0		0	0		-26856	0	NULL	Vacation Balance	YongKoh	20130911160940	0	0	0	0	0	Vacation Balance
3250	3261	EMP_SUPP	PTO_BAL_NUM	1	0	0	0	0	0		0	0		-26855	0	NULL	PTO Balance	ctaylo	20131107095317	0	0	0	0	0	PTO Balance
3261	3262	EMP_SUPP	Test_TEXT	0	11	0	0	0	0		0	0		-26848	0	NULL	TEST	ctaylo	20131107095316	0	0	0	0	0	TEST
3262	3263	EMP_SUPP	Union2a_CODE	6	0	0	0	0	0		2402	0		-26847	0	NULL	Union2a	ctaylo	20131107095315	0	0	0	0	0	Union2a
3263	3306	EMP_SUPP	TESTAGAIN_TEXT	0	12	0	0	0	0		0	0		-26846	0	NULL	TESTAGAIN	ctaylo	20131107095311	0	0	0	0	0	TESTAGAIN
3306	3250	EMP_SUPP	FACULTY_CODE	6	0	0	-1	0	0		2407	0		-26803	0	NULL	Faculty	ctaylo	20131108092735	0	0	0	0	0	Faculty