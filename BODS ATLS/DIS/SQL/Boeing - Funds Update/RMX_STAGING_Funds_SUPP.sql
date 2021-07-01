CREATE TABLE [dbo].[FUNDS_SUPP](
	[DA_ROW_ID] [int] NOT NULL,
	[JOBID] [int] NOT NULL,
    [TRANS_ID] [int] NOT NULL,
    [INPUT_ROW_ID] [int] NULL,
	[INVALID_ROW] [int] NULL,
	[UPDATE_ROW] [int] NULL,
	[INT_CLAIM_TEXT] [varchar](21) NULL,
    [ACCT_PER_CODE] [int] NULL,
    [SOURCE_CODE] [int] NULL,
    [IBAN_TEXT] [varchar](200)  NULL,
    [COMMENT_ACC_MEMO] [text]  NULL,
    [MATTER_NO_TEXT] [varchar](50)  NULL,
    [TOT_INVOICE_AMT] [float] NULL,
    [CLM_MAJ_CAT_TEXT] [varchar](50)  NULL,
    [CLMT_NM_OTH_TEXT] [varchar](255)  NULL,
    [CLAIMANT_TEXT] [varchar](100)  NULL,
    [FIRM_TEXT] [varchar](50)  NULL,
    [STATUS_CODE] [int] NULL,
    [PER_TOT_INV_NUM] [float] NULL,
    [TYPE_OF_CLM_TEXT] [varchar](50)  NULL,
    [DEDUCTIBLE_AMT] [float] NULL,
    [RECV_SUBMIT_AMT] [float] NULL,
    [OTHER_FEES_AMT] [float] NULL,
    [ACCT_YR_CODE] [int] NULL,
    [INVOICE_NBR_TEXT] [varchar](50)  NULL,
    [TYPE_CODE_CODE] [int] NULL,
    [GROUP_ID_TEXT] [varchar](50)  NULL,
    [FCAST_CAT_CODE] [int] NULL,
    [SPNN_INV_TEXT] [varchar](50)  NULL,
    [INVOICE_DT_DATE] [varchar](8)  NULL,
    [BROKER_DUE_DATE] [varchar](8)  NULL,
    [INS_DUE_DATE] [varchar](8)  NULL,
    [PREMIUM_AMT] [float] NULL,
    [COMMENTS_MEMO] [text]  NULL,
    [INVOICED_BY_TEXT] [varchar](100)  NULL,
    [MATTER_ID_TEXT] [varchar](100)  NULL,
    [MATTER_NAME_TEXT] [varchar](100)  NULL,
    [AUTH_FIRM_TEXT] [varchar](100)  NULL,
    [CHARGELINE_TEXT] [varchar](100)  NULL,
    [COMPANY_TEXT] [varchar](200)  NULL,
    [VN_BK_ACCT_TEXT] [varchar](200)  NULL,
    [VN_BK_EID] [int] NULL,
    [VN_BK_1ADDR_TEXT] [varchar](200)  NULL,
    [VN_BK_2ADDR_TEXT] [varchar](200)  NULL,
    [VN_BK_CITY_TEXT] [varchar](200)  NULL,
    [VN_BK_STATE_TEXT] [varchar](200)  NULL,
    [VN_BK_ABA_TEXT] [varchar](200)  NULL,
    [VN_BK_SWIFT_TEXT] [varchar](200)  NULL,
    [BN_BK_EID] [int] NULL,
    [BN_BK_ADDR_TEXT] [varchar](200)  NULL,
    [ACC_ACT_REQ_CODE] [int] NULL,
    [BN_BK_ABA_TEXT] [varchar](200)  NULL,
    [BN_BK_SWIFT_TEXT] [varchar](200)  NULL,
    [BN_BK_ACCNO_TEXT] [varchar](200)  NULL,
    [TRANS_TYPE_CODE] [int] NULL,
    [PRGRAM_TYPE_EID] [int] NULL,
    [SPECIAL_INS_TEXT] [varchar](100)  NULL,
    [REFERENCE_TEXT] [varchar](100)  NULL,
    [INVOICE_ID_TEXT] [varchar](100)  NULL,
    [REV_ALC_TEXT] [varchar](15)  NULL,
    [FUTURE_SRC_CODE] [int] NULL,
    [INVOICE_DUE_DATE] [varchar](8)  NULL,
    [BN_BK_ACC_TEXT] [varchar](100)  NULL,
    [RECV_SUB_DT_DATE] [varchar](8)  NULL,
    [PAY_TERMS_CODE] [int] NULL,
    [LSS_INVOICE_ID] [float] NULL,
 CONSTRAINT [PK_FUNDS_SUPP] PRIMARY KEY CLUSTERED 
(
	[DA_ROW_ID] ASC,
	[JOBID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]