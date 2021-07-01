IF OBJECT_ID('DDS_RESERVE_REBAL_SQL','P') IS NOT NULL
	DROP PROCEDURE DDS_RESERVE_REBAL_SQL
GO
CREATE PROCEDURE [dbo].[DDS_RESERVE_REBAL_SQL]
@iClaimId INT,
@iClaimantEid INT,
@iResTypeCode INT,
@iPolCvgLossRowId INT,
@iRcRowId INT,
@vTransType VARCHAR(10),
@vTransDate VARCHAR(8),
@iCarrierFlag INT,
@vDbName VARCHAR(MAX),
@p_JOBID INT,
@iDA_ROW_ID INT,
@vCLAIM_ID VARCHAR(20),
@iVarFinKey INT,
@iResSubTypeCodeId INT,	--JIRA 23831 knakra
@iHmiFlag INT,
@vBenReviewDate VARCHAR(8),
@iClaimMCFields INT,	--JIRA 28198 knakra starts
@iRsvMCFields INT,
@iPolMCFields INT,			--JIRA 28198 knakra ends
@iClmCurCode int,			--JIRA 29954 knakra starts
@iPolCurCode int,
@dClmToBaseRate DECIMAL(20,2),
@dClmToPolRate DECIMAL(20,2),			
@fVersionNum decimal(20,2),	--JIRA 29954 knakra ends
@vCheckStatus varchar(25),--akumar523 starts  60666
@dClmCurrAmt DECIMAL(20,2), 
@dPolCurrAmt DECIMAL(20,2), 
@dBaseCurrAmt DECIMAL(20,2),  ---akumar523 ends  60666
@iErrCnt INT OUTPUT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE
	@vClaimStatus VARCHAR(25),	
	@nSqlRes NVARCHAR(MAX),
	@dResAmt DECIMAL(20,2) = 0.0,
	@dIncAmt DECIMAL(20,2) = 0.0,
	@dResBal DECIMAL(20,2) = 0.0,
	@dPaidTot DECIMAL(20,2) = 0.0,
	@dColTot DECIMAL(20,2) = 0.0,
	@nSqlPay NVARCHAR(MAX),
	@nSqlCol NVARCHAR(MAX),
	@iResStatus INT,
	@iPolCvgRowId INT,
	@iPolCvgSeqNum INT,
	@iDbRcRowId INT,
	@vParentRsv	VARCHAR(25),
	@iAdjRsv INT,
	@iBalToZero INT,
	@iNegBalToZero INT,
	@iSetToZero INT,
	@dChangeAmt DECIMAL(20,2),
	@iAdjLog INT,
	@iDoNothing INT,
	@iColInRsvBal INT,
	@iColInIncBal INT,
	@vReason VARCHAR(50),
	@iRsvRowid INT,
	@vTodayDate VARCHAR(8),
	@vDttmRcd VARCHAR(14),
	@vErrMsgDesc VARCHAR(MAX),
	--JIRA 29954 knakra starts
	@nSqlCurr VARCHAR(MAX),
	@dClmPaidTot decimal(20,2),
	@dPolPaidTot decimal(20,2),
	@dClmColTot decimal(20,2),
	@dPolColTot	decimal(20,2),
	@dClmResBal decimal(20,2),
	@dPolResBal decimal(20,2),
	@dClmIncAmt decimal(20,2),
	@dPolIncAmt decimal(20,2),
	@dClmResAmt decimal(20,2),
	@dPolResAmt decimal(20,2),
	@dClmChgAmt decimal(20,2),
	@dPolChgAmt decimal(20,2),
	--akumar523 starts 60666
	@dClmCurrAlTot decimal(20,2) = 0.0,
	@dPolCurrPrTot decimal(20,2) = 0.0,
	@dClmCurrPrTot decimal(20,2) = 0.0,
	@dPolcurrAlTot decimal(20,2) = 0.0,
	@dAllocatedAmt decimal(20,2) = 0.0,
	@dPrintedTot decimal(20,2) = 0.0
	---akumar523 ends 60666
	
	
	--JIRA 29954 knakra ends
		
	BEGIN TRY

	SET NOCOUNT ON

	SET @vTodayDate = convert(varchar(8),getdate(),112)	
	SET @vDttmRcd = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');

	SET @nSqlRes = 'SELECT @pClaimStatus = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID =('
	SET @nSqlRes = @nSqlRes + 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = ('
	SET @nSqlRes = @nSqlRes + 'SELECT CLAIM_STATUS_CODE FROM ' + @vDbName + 'CLAIM WHERE CLAIM_ID = @pClaimId))'
	
	EXECUTE SP_EXECUTESQL @nSqlRes,
	N' @pClaimId INT, @pClaimStatus VARCHAR(25) OUTPUT',
	@pClaimId = @iClaimId,
	@pClaimStatus = @vClaimStatus OUTPUT
	---akumar523 starts 60666
	IF @fVersionNum >= 19.1
	BEGIN
		SET @nSqlRes = 'SELECT @pClmCurrAlTot = CLAIM_CURR_ALLOCATED_TOTAL, @pPolCurrPrTot = POLICY_CURR_PRINT_TOTAL, @pClmCurrPrTot = CLAIM_CURR_PRINT_TOTAL'
		SET @nSqlRes += ', @pPolcurrAlTot = POLICY_CURR_ALLOCATED_TOTAL, @pAllocatedAmt = ALLOCATED_AMOUNT, @pPrintedTot = PRINT_TOTAL FROM ' + @vDbName + 'RESERVE_CURRENT WHERE RC_ROW_ID = @pRcRowId'
				
			
		EXECUTE SP_EXECUTESQL @nSqlRes,
		N' @pClmCurrAlTot decimal(20,2) OUTPUT, @pPolCurrPrTot decimal(20,2) OUTPUT, @pClmCurrPrTot decimal(20,2) OUTPUT, @pPolcurrAlTot decimal(20,2) OUTPUT,
		 @pAllocatedAmt decimal(20,2) OUTPUT, @pPrintedTot decimal(20,2) OUTPUT, @pRcRowId int',
		@pRcRowId = @iRcRowId,
		@pClmCurrAlTot = @dClmCurrAlTot OUTPUT,
		@pPolCurrPrTot = @dPolCurrPrTot OUTPUT,
		@pClmCurrPrTot = @dClmCurrPrTot OUTPUT,
		@pPolcurrAlTot = @dPolcurrAlTot OUTPUT,
		@pAllocatedAmt = @dAllocatedAmt OUTPUT,
		@pPrintedTot = @dPrintedTot OUTPUT
		
		IF @dClmCurrAlTot IS NULL SET @dClmCurrAlTot = 0.0
		IF @dPolCurrPrTot IS NULL SET @dPolCurrPrTot = 0.0
		IF @dClmCurrPrTot IS NULL SET @dClmCurrPrTot = 0.0
		IF @dPolcurrAlTot IS NULL SET @dPolcurrAlTot = 0.0
		IF @dAllocatedAmt IS NULL SET @dAllocatedAmt = 0.0
		IF @dPrintedTot IS NULL SET @dPrintedTot = 0.0
		
	END 
	
	--JIRA 29954 knakra starts
	IF @fVersionNum >= 16.4
	BEGIN
		SET @nSqlCurr = 'SELECT @pBaseTot = SUM(FTS.AMOUNT), @pClmCurTot = SUM(FTS.CLAIM_CURRENCY_AMOUNT), '
		SET @nSqlCurr += '@pPolCurrTot = SUM(FTS.POLICY_CURRENCY_AMOUNT)'
		
		SET @nSqlRes = ' FROM ' + @vDbName + 'FUNDS F, ' + @vDbName + 'FUNDS_TRANS_SPLIT FTS, '
		SET @nSqlRes = @nSqlRes + @vDbName + 'RESERVE_CURRENT RC WHERE'
		SET @nSqlRes = @nSqlRes + ' F.TRANS_ID = FTS.TRANS_ID'
		SET @nSqlRes = @nSqlRes + ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID'
		SET @nSqlRes = @nSqlRes + ' AND F.TRANS_DATE <= @pTransDate'
		--AKUMAR523 STARTS 60666
		IF @fVersionNum >= 19.1
		BEGIN	
			SET @nSqlRes = @nSqlRes + ' AND F.VOID_FLAG = 0 AND F.STOP_PAY_FLAG=0'--asharma590
		END
		ELSE
		BEGIN
			SET @nSqlRes = @nSqlRes + ' AND F.VOID_FLAG = 0'
		END
		--AKUMAR523 ENDS 60666
		IF @fVersionNum >= 16.4
		SET @nSqlRes = @nSqlRes + ' AND RC.RC_ROW_ID = @pRcRowId'

		SET @nSqlPay = @nSqlCurr + @nSqlRes + ' AND F.PAYMENT_FLAG <> 0 AND F.COLLECTION_FLAG = 0'
		SET @nSqlCol = @nSqlCurr + @nSqlRes + ' AND F.PAYMENT_FLAG = 0 AND F.COLLECTION_FLAG <> 0'

		EXECUTE SP_EXECUTESQL @nSqlPay,
		N'@pBaseTot decimal(20,2) output, @pClmCurTot decimal(20,2) output, @pPolCurrTot decimal(20,2) output,
		@pTransDate varchar(8), @pRcRowId int',
		@pTransDate = @vTransDate,
		@pRcRowId = @iRcRowId,
		@pBaseTot = @dPaidTot OUTPUT,
		@pClmCurTot = @dClmPaidTot OUTPUT,
		@pPolCurrTot = @dPolPaidTot OUTPUT

		EXECUTE SP_EXECUTESQL @nSqlCol,
		N'@pBaseTot decimal(20,2) output, @pClmCurTot decimal(20,2) output, @pPolCurrTot decimal(20,2) output,
		@pTransDate varchar(8), @pRcRowId int',
		@pTransDate = @vTransDate,
		@pRcRowId = @iRcRowId,
		@pBaseTot = @dColTot OUTPUT,
		@pClmCurTot = @dClmColTot OUTPUT,
		@pPolCurrTot = @dPolColTot OUTPUT

		IF @dPaidTot IS NULL SET @dPaidTot = 0.0
		IF @dColTot IS NULL SET @dColTot = 0.0
		IF @dClmPaidTot IS NULL SET @dClmPaidTot = 0.0
		IF @dClmColTot IS NULL SET @dClmColTot = 0.0
		IF @dPolPaidTot IS NULL SET @dPolPaidTot = 0.0
		IF @dPolColTot IS NULL SET @dPolColTot = 0.0

		SET @nSqlRes = 'UPDATE ' + @vDbName + 'RESERVE_CURRENT SET PAID_TOTAL = @pBasePaidTot, COLLECTION_TOTAL = @pBaseColTot,'
		SET @nSqlRes += ' CLAIM_CURRENCY_PAID_TOTAL = @pClmPaidTot, CLAIM_CURR_COLLECTION_TOTAL = @pClmColTot,'
		SET @nSqlRes += ' POLICY_CURR_PAID_TOTAL = @pPolPaidtot, POLICY_CURR_COLLECTION_TOTAL = @pPolColTot,'
		SET @nSqlRes += ' DTTM_RCD_LAST_UPD = @pDttm, UPDATED_BY_USER = ''DA_DDS'''
		SET @nSqlRes += ' WHERE RC_ROW_ID = @pRcRowId'

		EXECUTE SP_EXECUTESQL @nSqlRes,
		N'@pBasePaidTot decimal(20,2), @pBaseColTot decimal(20,2), @pClmPaidTot decimal(20,2), @pClmColTot decimal(20,2),
		@pPolPaidtot decimal(20,2), @pPolColTot decimal(20,2), @pDttm varchar(14), @pRcRowId int',
		@pBasePaidTot = @dPaidTot,
		@pBaseColTot = @dColTot,
		@pClmPaidTot = @dClmPaidTot,
		@pClmColTot = @dClmColTot,
		@pPolPaidtot = @dPolPaidTot,
		@pPolColTot = @dPolColTot,
		@pDttm = @vDttmRcd,
		@pRcRowId = @iRcRowId

	END
	ELSE
	BEGIN
		SET @nSqlPay = 'UPDATE ' + @vDbName + 'RESERVE_CURRENT SET PAID_TOTAL = '
		SET @nSqlCol = 'UPDATE ' + @vDbName + 'RESERVE_CURRENT SET COLLECTION_TOTAL = '
		
		--IF @iCarrierFlag <> 0	JIRA 23831 knakra
		IF @iCarrierFlag <> 0 OR @iVarFinKey <> 0
		BEGIN
			SET @nSqlRes = '(SELECT SUM(FTS.AMOUNT) FROM ' + @vDbName + 'FUNDS F, ' + @vDbName + 'FUNDS_TRANS_SPLIT FTS, '
			SET @nSqlRes = @nSqlRes + @vDbName + 'RESERVE_CURRENT RC WHERE'
			SET @nSqlRes = @nSqlRes + ' F.TRANS_ID = FTS.TRANS_ID'
			SET @nSqlRes = @nSqlRes + ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID'
			SET @nSqlRes = @nSqlRes + ' AND F.TRANS_DATE <= @pTransDate'
			SET @nSqlRes = @nSqlRes + ' AND F.VOID_FLAG = 0'
			SET @nSqlRes = @nSqlRes + ' AND RC.RC_ROW_ID = @pRcRowId'
		
			SET @nSqlPay = @nSqlPay + @nSqlRes + ' AND F.PAYMENT_FLAG <> 0),'
			SET @nSqlCol = @nSqlCol + @nSqlRes + ' AND F.PAYMENT_FLAG = 0),'
			SET @nSqlRes = ' DTTM_RCD_LAST_UPD = @pDttm, UPDATED_BY_USER = ''DA_DDS'''
			SET @nSqlRes = @nSqlRes + ' WHERE RC_ROW_ID = @pRcRowId'
			SET @nSqlPay = @nSqlPay + @nSqlRes
			SET @nSqlCol = @nSqlCol + @nSqlRes
		END
		ELSE IF @iVarFinKey = 0 AND @iCarrierFlag = 0
		BEGIN
			SET @nSqlRes = '(SELECT SUM(FTS.AMOUNT) FROM ' + @vDbName + 'FUNDS F, ' + @vDbName + 'FUNDS_TRANS_SPLIT FTS WHERE'
			SET @nSqlRes = @nSqlRes + ' F.TRANS_ID = FTS.TRANS_ID'
			SET @nSqlRes = @nSqlRes + ' AND F.CLAIM_ID = @pClaimId'
			SET @nSqlRes = @nSqlRes + ' AND F.CLAIMANT_EID = @pClaimantEid'
			SET @nSqlRes = @nSqlRes + ' AND FTS.RESERVE_TYPE_CODE = @pResTypeCode'
			SET @nSqlRes = @nSqlRes + ' AND F.TRANS_DATE <= @pTransDate'
			SET @nSqlRes = @nSqlRes + ' AND F.VOID_FLAG = 0'
		
			SET @nSqlPay = @nSqlPay + @nSqlRes + ' AND F.PAYMENT_FLAG <> 0),'
			SET @nSqlCol = @nSqlCol + @nSqlRes + ' AND F.PAYMENT_FLAG = 0),'
			SET @nSqlRes = ' DTTM_RCD_LAST_UPD = @pDttm, UPDATED_BY_USER = ''DA_DDS'''
			SET @nSqlRes = @nSqlRes + ' WHERE CLAIM_ID = @pClaimId AND CLAIMANT_EID = @pClaimantEid'
			SET @nSqlRes = @nSqlRes + ' AND RESERVE_TYPE_CODE = @pResTypeCode'
			SET @nSqlPay = @nSqlPay + @nSqlRes
			SET @nSqlCol = @nSqlCol + @nSqlRes
		END
	
		EXECUTE SP_EXECUTESQL @nSqlPay,	--update Paid Total on the basis of transactions in FUNDS_TRANS_SPLIT table
		N' @pRcRowId INT, @pTransDate VARCHAR(8), @pClaimId INT, @pClaimantEid INT, @pResTypeCode INT, @pDttm VARCHAR(14)',
		@pRcRowId = @iRcRowId,
		@pTransDate = @vTransDate,
		@pClaimId = @iClaimId,
		@pClaimantEid = @iClaimantEid,
		@pDttm = @vDttmRcd,
		@pResTypeCode = @iResTypeCode
	
		EXECUTE SP_EXECUTESQL @nSqlCol,	--update Collection Total on the basis of transactions in FUNDS_TRANS_SPLIT table
		N' @pRcRowId INT, @pTransDate VARCHAR(8), @pClaimId INT, @pClaimantEid INT, @pResTypeCode INT, @pDttm VARCHAR(14)',
		@pRcRowId = @iRcRowId,
		@pTransDate = @vTransDate,
		@pClaimId = @iClaimId,
		@pDttm = @vDttmRcd,
		@pClaimantEid = @iClaimantEid,
		@pResTypeCode = @iResTypeCode
	END
	--JIRA 29954 knakra ends
	SET @nSqlRes = 'SELECT @pPaidtot = PAID_TOTAL, @pColTot = COLLECTION_TOTAL, @pResAmt = RESERVE_AMOUNT,'
	IF @fVersionNum >= 16.4
	BEGIN
		SET @nSqlRes += ' @pClmPaidTot = CLAIM_CURRENCY_PAID_TOTAL, @pClmColTot = CLAIM_CURR_COLLECTION_TOTAL,'
		SET @nSqlRes += ' @pPolPaidTot = POLICY_CURR_PAID_TOTAL, @pPolColTot = POLICY_CURR_COLLECTION_TOTAL, '
		SET @nSqlRes += '@pClmResAmt = CLAIM_CURRENCY_RESERVE_AMOUNT, @pPolResAmt = POLICY_CURR_RESERVE_AMOUNT, '
	END
	--JIRA 29954 knakra ends
	SET @nSqlRes = @nSqlRes + ' @poResTypeCode = RESERVE_TYPE_CODE, @poClaimantEid = CLAIMANT_EID, @poRcRowId = RC_ROW_ID,'
	--JIRA 23831 knakra starts
	SET @nSqlRes = @nSqlRes + ' @pResStatusCode = RES_STATUS_CODE, '
	IF @iVarFinKey = 0
		SET @nSqlRes += '@pPolCvgRowId = POLCVG_ROW_ID, '
	SET @nSqlRes += '@pPolCvgSeqNum = POLICY_CVG_SEQNO,'
	--JIRA 23831 knakra ends
	SET @nSqlRes = @nSqlRes + ' @pPolCvgLossRowId = POLCVG_LOSS_ROW_ID FROM ' + @vDbName + 'RESERVE_CURRENT WHERE'
	IF @iCarrierFlag <> 0 OR @iVarFinKey <> 0
		SET @nSqlRes = @nSqlRes + ' RC_ROW_ID = @pRcRowId'
	ELSE
	BEGIN
		SET @nSqlRes = @nSqlRes + ' CLAIM_ID = @pClaimId AND CLAIMANT_EID = @pClaimantEid AND RESERVE_TYPE_CODE = @pResTypeCode'
	END

	EXECUTE SP_EXECUTESQL @nSqlRes,
	N' @pPaidTot decimal(20,2) OUTPUT,@pColTot decimal(20,2) OUTPUT, @pResAmt decimal(20,2) OUTPUT, @poResTypeCode INT OUTPUT, @poClaimantEid INT OUTPUT,@poRcRowId INT OUTPUT,
	   @pResStatusCode INT OUTPUT, @pPolCvgRowId INT OUTPUT, @pPolCvgSeqNum INT OUTPUT, @pPolCvgLossRowId INT OUTPUT, @pRcRowId INT,
	   @pClaimId INT, @pClaimantEid INT, @pResTypeCode INT, @pClmPaidTot decimal(20,2) OUTPUT, @pClmColTot decimal(20,2) OUTPUT,
	   @pPolPaidTot DECIMAL(20,2) OUTPUT, @pPolColTot DECIMAL(20,2) OUTPUT, @pClmResAmt decimal(20,2) OUTPUT, @pPolResAmt DECIMAL(20,2) OUTPUT',	--JIRA 29954 knakra(MC Columns added)
	@pRcRowId = @iRcRowId,
	@pClaimId = @iClaimId,
	@pClaimantEid = @iClaimantEid,
	@pResTypeCode = @iResTypeCode,
	@pPaidTot = @dPaidtot OUTPUT,
	@PColTot = @dColTot OUTPUT,
	@pResAmt = @dResAmt OUTPUT,
	@poResTypeCode = @iResTypeCode OUTPUT,
	@poClaimantEid = @iClaimantEid OUTPUT,
	@poRcRowId = @iDbRcRowId OUTPUT,
	@pResStatusCode = @iResStatus OUTPUT,
	@pPolCvgRowid = @iPolCvgRowid OUTPUT,
	@pPolCvgSeqNum = @iPolCvgSeqNum OUTPUT,
	@pPolCvgLossRowId = @iPolCvgLossRowId OUTPUT,
	--JIRA 29954 knakra starts
	@pClmPaidTot = @dClmPaidTot OUTPUT,
	@pClmColTot = @dClmColTot OUTPUT,
	@pPolPaidTot = @dPolPaidTot OUTPUT,
	@pPolColTot = @dPolColTot OUTPUT,
	@pClmResAmt = @dClmResAmt OUTPUT,
	@pPolResAmt = @dPolResAmt OUTPUT
	--JIRA 29954 knakra ends

	IF @dPaidTot IS NULL
		SET @dPaidTot = 0
	IF @dColTot IS NULL
		SET @dColTot = 0
	IF @dResAmt IS NULL
		SET @dResAmt = 0
	IF @iPolCvgRowid IS NULL
		SET @iPolCvgRowid = 0
	IF @iPolCvgLossRowId IS NULL
		SET @iPolCvgLossRowId = 0
	--JIRA 29954 knakra starts
	IF @dClmColTot IS NULL SET @dClmColTot = 0.0
	IF @dClmPaidTot IS NULL SET @dClmPaidTot = 0.0
	IF @dPolColTot IS NULL SET @dPolColTot = 0.0
	IF @dPolPaidTot IS NULL SET @dPolPaidTot = 0.0
	IF @dClmResAmt IS NULL SET @dClmResAmt = 0.0
	IF @dPolResAmt IS NULL SET @dPolResAmt = 0.0
	--JIRA 29954 knakra ends

	IF @iDbRcRowId IS NOT NULL AND @iDbRcRowId > 0
	BEGIN
		SET @nSqlRes = 'SELECT @pParentRsv = C1.SHORT_CODE FROM ' + @vDbName + 'CODES C1, ' + @vDbName + 'CODES C2 WHERE'
		SET @nSqlRes = @nSqlRes + ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = @pResTypeCode'

		EXECUTE SP_EXECUTESQL @nSqlRes,	--fetch Parent Reserve
		N' @pParentRsv VARCHAR(25) OUTPUT, @pResTypeCode INT',
		@pResTypeCode = @iResTypeCode,
		@pParentRsv = @vParentRsv OUTPUT

		SET @nSqlRes = 'SELECT @pAdjRsv = ADJ_RSV, @pBalToZero = BAL_TO_ZERO, @pNegBalToZero = NEG_BAL_TO_ZERO,'
		--JIRA 26101 knakra starts
		IF @iVarFinKey <> 0
			SET @nSqlRes = @nSqlRes + '@pColInRsvBal = COLL_IN_RSV_BAL, @pColInIncBal = COLL_IN_INCUR_BAL'
		ELSE
			SET @nSqlRes = @nSqlRes + '@pSetToZero = SET_TO_ZERO, @pColInRsvBal = COLL_IN_RSV_BAL, @pColInIncBal = COLL_IN_INCUR_BAL'
		--JIRA 26101 knakra ends
		SET @nSqlRes = @nSqlRes + ' FROM '  + @vDbname + 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = ('
		SET @nSqlRes = @nSqlRes + 'SELECT LINE_OF_BUS_CODE FROM ' + @vDbName + 'CLAIM WHERE CLAIM_ID = @pClaimId)'

		EXECUTE SP_EXECUTESQL @nSqlRes,	--LOB Parameters
		N' @pAdjRsv INT OUTPUT, @pBalToZero INT OUTPUT, @pNegBalToZero INT OUTPUT, @pSetToZero INT OUTPUT, @pClaimId INT,
		@pColInRsvBal INT OUTPUT, @pColInIncBal INT OUTPUT',
		@pClaimId = @iClaimId,
		@pAdjRsv = @iAdjRsv OUTPUT,
		@pBalToZero = @iBalToZero OUTPUT,
		@pNegBalToZero = @iNegBalToZero OUTPUT,
		@pSetToZero = @iSetToZero OUTPUT,
		@pColInRsvBal = @iColInRsvBal OUTPUT,
		@pColInIncBal = @iColInIncBal OUTPUT

		SET @iDoNothing = 0
		SET @iAdjLog = 0
		--JIRA 26101 knakra starts
		IF @iVarFinKey <> 0
			SET @iSetToZero = 0
		--JIRA 26101 knakra ends

		IF @vParentRsv <> 'R' AND @vParentRsv IS NOT NULL
		BEGIN
			IF @iColInRsvBal <> 0
			BEGIN
				IF @fVersionNum >= 19.1  ----AKUMAR523 ALLOCATED PAHSE enhc  START 
				BEGIN 
					IF @vTransType='P' --udoni 64208 starts
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt  - @dColTot)
					END
					ELSE
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot  - @dColTot)
					END
				END
				ELSE 
				BEGIN
					SET @dResBal = @dResAmt - (@dPaidTot - @dColTot)
				END 
				---SET @dResBal = @dResAmt - (@dPaidTot - @dColTot)
				IF @fVersionNum >= 19.1
				BEGIN
					IF @vTransType='P' --udoni 64208 starts
					BEGIN 
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot + @dClmCurrAmt - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt - @dPolColTot)
					END
					ELSE
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot - @dPolColTot)
					END
				END 
				ELSE
				BEGIN
					IF @fVersionNum >= 16.4
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmPaidTot - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolPaidTot - @dPolColTot)
					END
				END
				-- IF @fVersionNum >= 16.4
				-- BEGIN
					-- SET @dClmResBal = @dClmResAmt - (@dClmPaidTot - @dClmColTot)
					-- SET @dPolResBal = @dPolResAmt - (@dPolPaidTot - @dPolColTot)
				-- END
				----AKUMAR523 ALLOCATED PAHSE enhc END 
			END
			ELSE
			BEGIN
				IF @fVersionNum >= 19.1  ----AKUMAR523 ALLOCATED PAHSE enhc  START 
				BEGIN 
					IF @vTransType = 'P'
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt)
					END
					ELSE
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot)
					END
				END
				ELSE 
				BEGIN
					SET @dResBal = @dResAmt - @dPaidTot
				END 
				-----SET @dResBal = @dResAmt - @dPaidTot
				IF @fVersionNum >= 19.1
				BEGIN
					IF @vTransType = 'P'
					BEGIN 
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot + @dClmCurrAmt)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt)
					END
					ELSE
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot)
					END
				END 
				ELSE 
				BEGIN 
					IF @fVersionNum >= 16.4
					BEGIN
						SET @dClmResBal = @dClmResAmt - @dClmPaidTot
						SET @dPolResBal = @dPolResAmt - @dPolPaidTot
					END
				END	
					-- IF @fVersionNum >= 16.4
					-- BEGIN
						-- SET @dClmResBal = @dClmResAmt - @dClmPaidTot
						-- SET @dPolResBal = @dPolResAmt - @dPolPaidTot
					-- END
					--udoni 64208 ends
			END

			IF @iColInRsvBal <> 0
			BEGIN
				IF @dResBal < 0
				BEGIN
					IF @fVersionNum >= 19.1
					BEGIN 
					SET @dIncAmt = (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt) - @dColTot
					END 
					ELSE 
					BEGIN 
						SET @dIncAmt = @dPaidTot - @dColTot
					END
				END 	 
				---SET @dIncAmt = @dPaidTot - @dColTot
				ELSE
				BEGIN
					IF @fVersionNum >= 19.1
					BEGIN 
						SET @dIncAmt = @dResBal + (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt - @dColTot)
					END 
					ELSE 
					BEGIN 
						SET @dIncAmt = @dResBal + (@dPaidTot - @dColTot)
					END 
					----SET @dIncAmt = @dResBal + (@dPaidTot - @dColTot)
				END 	
				IF @fVersionNum >= 16.4 AND @dClmResBal < 0
					BEGIN
						IF @fVersionNum >= 19.1
						BEGIN
							SET @dClmIncAmt = (@dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt ) - @dClmColTot
						END
						ELSE 
						BEGIN 
							SET @dClmIncAmt = @dClmPaidTot - @dClmColTot
						END 
					END 	
					-----SET @dClmIncAmt = @dClmPaidTot - @dClmColTot
				ELSE IF @fVersionNum >= 16.4 AND @dClmResBal >= 0
					BEGIN
						IF @fVersionNum >= 19.1
						BEGIN 
							SET @dClmIncAmt = @dClmResBal + (@dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt - @dClmColTot)
						END 
						ELSE 
						BEGIN 
							SET @dClmIncAmt = @dClmResBal + (@dClmPaidTot - @dClmColTot)
						END 
					END 	
					----SET @dClmIncAmt = @dClmResBal + (@dClmPaidTot - @dClmColTot)

				IF @fVersionNum >= 16.4 AND @dPolResBal < 0
					BEGIN 
						IF @fVersionNum >= 19.1
						BEGIN
							SET @dPolIncAmt = (@dPolCurrPrTot + @dPolcurrAlTot + @dPolCurrAmt) - @dPolColTot
						END 
						ELSE 
						BEGIN 
							SET @dPolIncAmt = @dPolPaidTot - @dPolColTot
						END 
					END 
					
					----SET @dPolIncAmt = @dPolPaidTot - @dPolColTot
				ELSE IF @fVersionNum >= 16.4 AND @dPolResBal >= 0
					BEGIN 
						IF @fVersionNum >=19.1
						BEGIN
							SET @dPolIncAmt = @dPolResBal + (@dPolCurrPrTot + @dPolcurrAlTot + @dPolCurrAmt - @dPolColTot)
						END 
						ELSE 
						BEGIN 
							SET @dPolIncAmt = @dPolResBal + (@dPolPaidTot - @dPolColTot)
						END 
					END  
					
					----SET @dPolIncAmt = @dPolResBal + (@dPolPaidTot - @dPolColTot)
			END
			ELSE
			BEGIN
				IF @dResBal < 0
					BEGIN 
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dIncAmt = @dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt
						END 
						ELSE 
						BEGIN 
							SET @dIncAmt = @dPaidTot
						END 
					END 
					
					----SET @dIncAmt = @dPaidTot
				ELSE
					BEGIN
						IF @fVersionNum >=19.1 
						BEGIN
							SET @dIncAmt = @dResBal + @dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt
						END 
						ELSE 
						BEGIN 
							SET @dIncAmt = @dResBal + @dPaidTot
						END 
						
					END 
					---SET @dIncAmt = @dResBal + @dPaidTot

				IF @fVersionNum >= 16.4 AND @dClmResBal < 0
				BEGIN 
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dClmIncAmt = @dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt 
						END 
						ELSE 
						BEGIN 
							SET @dClmIncAmt = @dClmPaidTot
						END 
				END 
					
					----SET @dClmIncAmt = @dClmPaidTot
				ELSE IF @fVersionNum >= 16.4 AND @dClmResBal >= 0
				BEGIN
					IF @fVersionNum >=19.1
					BEGIN 
						SET @dClmIncAmt = @dClmResBal + @dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt
					END 
					ELSE 
					BEGIN 
						SET @dClmIncAmt = @dClmResBal + @dClmPaidTot
					END 
				END 
				---SET @dClmIncAmt = @dClmResBal + @dClmPaidTot

				IF @fVersionNum >= 16.4 AND @dPolResBal < 0
				BEGIN 
					IF @fVersionNum >=19.1
					BEGIN 
						SET @dPolIncAmt = @dPolCurrPrTot + @dPolcurrAlTot + @dPolCurrAmt 
					END 
					ELSE 
					BEGIN 
						SET @dPolIncAmt = @dPolPaidTot
					END 
				END 
					---SET @dPolIncAmt = @dPolPaidTot
				ELSE IF @fVersionNum >= 16.4 AND @dPolResBal >= 0
				BEGIN
					IF @fVersionNum >=19.1
					BEGIN 
						SET @dPolIncAmt = @dPolResBal + @dPolCurrPrTot + @dPolcurrAlTot + @dPolCurrAmt 
					END 
					ELSE 
					BEGIN 
						SET @dPolIncAmt = @dPolResBal + @dPolPaidTot
					END 
				END 
					---SET @dPolIncAmt = @dPolResBal + @dPolPaidTot
			END
				
			IF @iColInIncBal <> 0
			BEGIN
				SET @dIncAmt = @dIncAmt - @dColTot
				IF @fVersionNum >= 16.4
				BEGIN
					SET @dClmIncAmt = @dClmIncAmt - @dClmColTot
					SET @dPolIncAmt = @dPolIncAmt - @dPolColTot
				END
			END
		END
		ELSE IF @vParentRsv = 'R' AND @vParentRsv IS NOT NULL
		BEGIN
			SET @dResBal = @dResAmt - @dColtot
			--JIRA 29954 knakra starts
			IF @fVersionNum >= 16.4
			BEGIN
				SET @dClmResBal = @dClmResAmt - @dClmColTot
				SET @dPolResBal = @dPolResAmt - @dPolColTot
			END
			IF @dResBal < 0
				SET @dIncAmt = @dColTot
			ELSE
				SET @dIncAmt = @dResBal + @dColTot

			IF @fVersionNum >= 16.4 AND @dClmResBal < 0
				SET @dClmIncAmt = @dClmColTot
			ELSE IF @fVersionNum >= 16.4 AND @dClmResBal >= 0
				SET @dClmIncAmt = @dClmResBal + @dClmColTot

			IF @fVersionNum >= 16.4 AND @dPolResBal < 0
				SET @dPolIncAmt = @dPolColTot
			ELSE IF @fVersionNum >= 16.4 AND @dPolResBal >= 0
				SET @dPolIncAmt = @dPolResBal + @dPolColTot
			--JIRA 29954 knakra ends
		END

		IF @vClaimStatus = 'O'
		BEGIN
			--IF @iAdjRsv <> 0 AND @dResBal < -0.009 AND @vParentRsv <> 'R'
			IF @iAdjRsv <> 0 AND @vParentRsv <> 'R' AND ((@dResBal < -0.009 AND @fVersionNum < 16.4) OR (@fVersionNum >= 16.4 AND (@dResBal < -0.009 OR @dClmResBal < -0.009 OR @dPolResBal < -0.009)))
			BEGIN
				IF @dResBal < 0
				BEGIN
					SET @dResAmt = @dResAmt + ABS(@dResBal)
					SET @dChangeAmt = ABS(@dResBal)
				END
				ELSE
				BEGIN
					SET @dResAmt = @dResAmt - @dResBal
					SET @dChangeAmt = -(@dResBal)
				END
				
				--JIRA 29954 knakra starts
				IF @fVersionNum >= 16.4
				BEGIN
					IF @dClmResBal < 0
					BEGIN
						SET @dClmResAmt = @dClmResAmt + ABS(@dClmResBal)
						SET @dClmChgAmt = ABS(@dClmResBal)
					END
					ELSE
					BEGIN
						SET @dClmResAmt = @dClmResAmt - @dClmResBal
						SET @dClmChgAmt = -(@dClmResBal)
					END
					IF @dPolResBal < 0
					BEGIN
						SET @dPolResAmt = @dPolResAmt + ABS(@dPolResBal)
						SET @dPolChgAmt = ABS(@dPolResBal)
					END
					ELSE
					BEGIN
						SET @dPolResAmt = @dPolResAmt - @dPolResBal
						SET @dPolChgAmt = -(@dPolResBal)
					END
				END
				--JIRA 29954 knakra ends
				SET @iAdjLog = 1
			END
			ELSE
				SET @iAdjLog = 0
		END
		ELSE	--knakra changed
		BEGIN		

			IF @iSetToZero <> 0 AND @vParentRsv <> 'R'
			BEGIN
				SET @dChangeAmt = -(@dResAmt)
				SET @dResAmt = 0
				SET @iDoNothing = 1
			END
			--ELSE IF @iNegBalToZero <> 0 AND @dResBal < 0 AND @vParentRsv <> 'R'
			ELSE IF @iNegBalToZero <> 0 AND @vParentRsv <> 'R' AND ((@dResBal < 0 AND @fVersionNum < 16.4) OR (@fVersionNum >= 16.4 AND (@dResBal < 0 OR @dClmResBal < 0 OR @dPolResBal < 0)))
			BEGIN
					
				SET @dResAmt = @dResAmt - @dResBal
				SET @dChangeAmt = -(@dResBal)
				
				SET @iDoNothing = 1
				--JIRA 29954 knakra starts
				IF @fVersionNum >= 16.4
				BEGIN
					SET @dClmResAmt = @dClmResAmt - @dClmResBal
					SET @dClmChgAmt = -(@dClmResBal)

					SET @dPolResAmt = @dPolResAmt - @dPolResBal
					SET @dPolChgAmt = -(@dPolResBal)
					
				END
				--JIRA 29954 knakra ends
			END
			ELSE IF @iBalToZero <> 0 AND @vParentRsv <> 'R'
			BEGIN
				SET @dResAmt = @dResAmt - @dResBal
				SET @dChangeAmt = -(@dResBal)
				--JIRA 29954 knakra starts
				IF @fVersionNum >= 16.4
				BEGIN
					SET @dClmResAmt = @dClmResAmt - @dClmResBal
					SET @dPolResAmt = @dPolResAmt - @dPolResBal
					SET @dClmChgAmt = -(@dClmResBal)
					SET @dPolChgAmt = -(@dPolResBal)
				END
				--JIRA 29954 knakra ends
				SET @iDoNothing = 1
			END
		END
		
		IF (@vClaimStatus = 'O' AND @iAdjLog = 1) OR (@vClaimStatus <> 'O' AND @iDoNothing = 1)
		BEGIN
			IF @vParentRsv <> 'R' AND @vParentRsv IS NOT NULL
			BEGIN
				IF @iColInRsvBal <> 0
				BEGIN
					IF @fVersionNum >=19.1
					BEGIN 
					IF @vTransType='P' --udoni 64208 starts
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt  - @dColTot)
					END
					ELSE
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot  - @dColTot)
					END
				END
				ELSE 
				BEGIN
					SET @dResBal = @dResAmt - (@dPaidTot - @dColTot)
				END 
				---SET @dResBal = @dResAmt - (@dPaidTot - @dColTot)
				IF @fVersionNum >= 19.1
				BEGIN
					IF @vTransType='P' --udoni 64208 starts
					BEGIN 
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot + @dClmCurrAmt - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt - @dPolColTot)
					END
					ELSE
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot - @dPolColTot)
					END
				END 
				ELSE
				BEGIN
					IF @fVersionNum >= 16.4
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmPaidTot - @dClmColTot)
						SET @dPolResBal = @dPolResAmt - (@dPolPaidTot - @dPolColTot)
					END
				END
				-- IF @fVersionNum >= 16.4
				-- BEGIN
					-- SET @dClmResBal = @dClmResAmt - (@dClmPaidTot - @dClmColTot)
					-- SET @dPolResBal = @dPolResAmt - (@dPolPaidTot - @dPolColTot)
				-- END
				----AKUMAR523 ALLOCATED PAHSE enhc END 
			END
			ELSE
			BEGIN
				IF @fVersionNum >= 19.1  ----AKUMAR523 ALLOCATED PAHSE enhc  START 
				BEGIN 
					IF @vTransType = 'P'
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt)
					END
					ELSE
					BEGIN
						SET @dResBal = @dResAmt - (@dAllocatedAmt + @dPrintedTot)
					END
				END
				ELSE 
				BEGIN
					SET @dResBal = @dResAmt - @dPaidTot
				END 
				-----SET @dResBal = @dResAmt - @dPaidTot
				IF @fVersionNum >= 19.1
				BEGIN
					IF @vTransType = 'P'
					BEGIN 
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot + @dClmCurrAmt)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt)
					END
					ELSE
					BEGIN
						SET @dClmResBal = @dClmResAmt - (@dClmCurrPrTot + @dClmCurrAlTot)
						SET @dPolResBal = @dPolResAmt - (@dPolcurrAlTot + @dPolCurrPrTot)
					END
				END 
				ELSE 
				BEGIN 
					IF @fVersionNum >= 16.4
					BEGIN
						SET @dClmResBal = @dClmResAmt - @dClmPaidTot
						SET @dPolResBal = @dPolResAmt - @dPolPaidTot
					END
				END	
					--udoni 64208 ends
				END

				IF @iColInRsvBal <> 0
				BEGIN
					
					IF @dResBal < 0
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dIncAmt = (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt - @dColTot)
						END  
						ELSE
						BEGIN
							SET @dIncAmt = @dPaidTot - @dColTot
						END 
					END 	
						---SET @dIncAmt = @dPaidTot - @dColTot
					ELSE
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dIncAmt = @dResBal + (@dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt - @dColTot)
						END
						ELSE 
						BEGIN
							SET @dIncAmt = @dResBal + (@dPaidTot - @dColTot)
						END 
					END 
					---SET @dIncAmt = @dResBal + (@dPaidTot - @dColTot)

					IF @dClmResBal < 0
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dClmIncAmt = (@dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt) - @dClmColTot
						END 
						ELSE
						BEGIN
							SET @dClmIncAmt = @dClmPaidTot - @dClmColTot
						END 
					END 
						---SET @dClmIncAmt = @dClmPaidTot - @dClmColTot
					ELSE
					BEGIN 
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dClmIncAmt = @dClmResBal + (@dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt - @dClmColTot)
						END 
						ELSE
						BEGIN
						SET	@dClmIncAmt = @dClmResBal + (@dClmPaidTot - @dClmColTot)
						END 
					END 
					
					---SET @dClmIncAmt = @dClmResBal + (@dClmPaidTot - @dClmColTot)

					IF @dPolResBal < 0
					BEGIN 
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dPolIncAmt = (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt) - @dPolColTot
						END 
						ELSE 
						BEGIN 
							SET @dPolIncAmt = @dPolPaidTot - @dPolColTot
						END 
					END 
						-----SET @dPolIncAmt = @dPolPaidTot - @dPolColTot
					ELSE
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dPolIncAmt = @dPolResBal + (@dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt - @dPolColTot)
						END 
						ELSE 
						BEGIN
							SET @dPolIncAmt = @dPolResBal + (@dPolPaidTot - @dPolColTot)
						END 
					END 
						------SET @dPolIncAmt = @dPolResBal + (@dPolPaidTot - @dPolColTot)
				END
				ELSE
				BEGIN
					IF @dResBal < 0
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dIncAmt = @dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt
						END
						ELSE 
						BEGIN
							SET @dIncAmt = @dPaidTot
						END 
					END 
						----SET @dIncAmt = @dPaidTot
					ELSE
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN 
							SET @dIncAmt = @dResBal + @dAllocatedAmt + @dPrintedTot + @dBaseCurrAmt
						END 
						ELSE 
						BEGIN 
							SET @dIncAmt = @dResBal + @dPaidTot
						END  
						----SET @dIncAmt = @dResBal + @dPaidTot
					END 
					IF @dClmResBal < 0
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dClmIncAmt = @dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt
						END 
						ELSE 
						BEGIN
							SET @dClmIncAmt = @dClmPaidTot
						END  
					END 
						---SET @dClmIncAmt = @dClmPaidTot
					ELSE
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dClmIncAmt = @dClmResBal + @dClmCurrAlTot + @dClmCurrPrTot + @dClmCurrAmt
						END 
						ELSE
						BEGIN
							SET @dClmIncAmt = @dClmResBal + @dClmPaidTot
						END 
					END
						---SET @dClmIncAmt = @dClmResBal + @dClmPaidTot

					IF @dPolResBal < 0
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dPolIncAmt = @dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt
						END
						ELSE
						BEGIN
							SET @dPolIncAmt = @dPolPaidTot
						END 
					END
						---SET @dPolIncAmt = @dPolPaidTot
					ELSE
					BEGIN
						IF @fVersionNum >=19.1
						BEGIN
							SET @dPolIncAmt = @dPolResBal + @dPolcurrAlTot + @dPolCurrPrTot + @dPolCurrAmt
						END
						ELSE
						BEGIN 
							SET @dPolIncAmt = @dPolResBal + @dPolPaidTot
						END 
					END
						---SET @dPolIncAmt = @dPolResBal + @dPolPaidTot
				END
				
				IF @iColInIncBal <> 0
				BEGIN
					IF @fVersionNum >= 16.4
					BEGIN
						SET @dClmIncAmt = @dClmIncAmt - @dClmColTot
						SET @dPolIncAmt = @dPolIncAmt - @dPolColTot
					END
					SET @dIncAmt = @dIncAmt - @dColTot
				END
			END
		END

		IF @dIncAmt IS NULL
			SET @dIncAmt = 0
		IF @dResBal IS NULL
			SET @dResBal = 0
		--JIRA 29954 knakra starts
		IF @fVersionNum >= 16.4
		BEGIN
			IF @dClmIncAmt IS NULL SET @dClmIncAmt = 0.0
			IF @dPolIncAmt IS NULL SET @dPolIncAmt = 0.0
			IF @dClmResBal IS NULL SET @dClmResBal = 0.0
			IF @dPolResBal IS NULL SET @dPolResBal = 0.0
		END
		--JIRA 29954 knakra ends

		 --JIRA 37552 nkhetan starts
			IF @fVersionNum < 16.4  
			BEGIN
				SET @dClmIncAmt = @dIncAmt 
				SET @dClmResBal = @dResBal
				SET @dClmResAmt = @dResAmt
				SET @dClmPaidTot =@dPaidTot
				SET @dClmColTot =@dColTot

				SET @dPolResBal = @dResbal 
				SET @dPolIncAmt = @dIncAmt 
				SET @dPolResAmt = @dResAmt
				SET @dPolPaidTot = @dPaidTot
				SET @dPolColTot=  @dColTot
			END
		   --JIRA 37552 nkhetan ends

		SET @nSqlRes = 'UPDATE ' + @vDbName + 'RESERVE_CURRENT SET RESERVE_AMOUNT = @pResAmt, BALANCE_AMOUNT = @pBalAmt, '
		SET @nSqlRes = @nSqlRes + 'INCURRED_AMOUNT = @pIncAmt, DTTM_RCD_LAST_UPD = @pDateTime, UPDATED_BY_USER = ''DADDS'', '
		 --JIRA 37552 nkhetan start--commented as Reserve_current and reserve_History was not in sync
		--JIRA 29954 knakra starts
		/*IF @fVersionNum >= 16.4  
		BEGIN                    
			SET @nSqlRes += 'CLAIM_CURRENCY_BALANCE_AMOUNT = @pClmResBal, CLAIM_CURRENCY_RESERVE_AMOUNT = @pClmResAmt, '
			SET @nSqlRes += 'CLAIM_CURRENCY_PAID_TOTAL = @pClmPaidTot, CLAIM_CURR_COLLECTION_TOTAL = @pClmColTot, '
			SET @nSqlRes += 'CLAIM_CURRENCY_INCURRED_AMOUNT = @pClmIncAmt, POLICY_CURRENCY_BALANCE_AMOUNT = @pPolResBal, '
			SET @nSqlRes += 'POLICY_CURR_RESERVE_AMOUNT = @pPolResAmt, POLICY_CURR_PAID_TOTAL = @pPolPaidTot, '
			SET @nSqlRes += 'POLICY_CURR_COLLECTION_TOTAL = @pPolColTot, POLICY_CURR_INCURRED_AMOUNT = @pPolIncAmt, '
		END */                      
		--JIRA 29954 knakra ends
		--JIRA 37552 nkhetan commented part ends
		--JIRA 37552 nkhetan starts
		IF @iClaimMCFields = 1
		BEGIN
			SET @nSqlRes += 'CLAIM_CURRENCY_BALANCE_AMOUNT = @pClmResBal, CLAIM_CURRENCY_RESERVE_AMOUNT = @pClmResAmt, '
			SET @nSqlRes += 'CLAIM_CURRENCY_PAID_TOTAL = @pClmPaidTot, CLAIM_CURR_COLLECTION_TOTAL = @pClmColTot, '
			SET @nSqlRes += 'CLAIM_CURRENCY_INCURRED_AMOUNT = @pClmIncAmt, '
		---AKUMAR523 STARTS 60666
			IF @fVersionNum >=19.1	
			BEGIN				
				IF @vTransType = 'P' --udoni RMA-64208
				BEGIN
					IF @vCheckStatus='P'
						BEGIN
							SET @dClmCurrPrTot = @dClmCurrPrTot + @dClmCurrAmt
							SET @nSqlRes += 'CLAIM_CURR_PRINT_TOTAL = @pClmCurPrtTot,'
						END
					ELSE 
						BEGIN
							SET @dClmCurrAlTot = @dClmCurrAlTot + @dClmCurrAmt
							SET @nSqlRes += 'CLAIM_CURR_ALLOCATED_TOTAL=@pClmCurAltTot,'
						END
					END
			END 	
		---AKUMAR523 ENDS 60666
		END
		IF @iRsvMCFields = 1
		BEGIN
			SET @nSqlRes += 'RSV_CURR_RSV_AMT =@pRsvResAmt, RESERVE_CURRENCY_PAID_TOTAL=@pRsvPaidTot, RSV_CURRENCY_BALANCE_AMOUNT=@RsvResBal'
			SET @nSqlRes += ', RSV_CURR_COLLECTION_TOTAL= @pRsvColTot, RSV_CURR_INCURRED_AMOUNT =@pRsvIncAmt, '
		END
		IF @iPolMCFields = 1
		BEGIN
			SET @nSqlRes += 'POLICY_CURRENCY_BALANCE_AMOUNT = @pPolResBal, POLICY_CURR_RESERVE_AMOUNT = @pPolResAmt, POLICY_CURR_PAID_TOTAL = @pPolPaidTot,'
			SET @nSqlRes += 'POLICY_CURR_COLLECTION_TOTAL = @pPolColTot, POLICY_CURR_INCURRED_AMOUNT = @pPolIncAmt, '
		---AKUMAR523 STARTS  60666
			IF @fVersionNum >=19.1
			BEGIN
			IF @vTransType = 'P' --udoni RMA-64208
				BEGIN
				IF @vCheckStatus='P'
					BEGIN
						SET @dPolCurrPrTot = @dPolCurrPrTot + @dPolCurrAmt
						SET @nSqlRes += 'POLICY_CURR_PRINT_TOTAL = @pPolCurPrtTot,'
					END
				ELSE 
					BEGIN
						SET @dPolcurrAlTot = @dPolcurrAlTot + @dPolCurrAmt
						SET @nSqlRes += 'POLICY_CURR_ALLOCATED_TOTAL=@pPolCurAltTot,'
					END
				END 
			END	
		---AKUMAR523 ENDS 60666
		END
		--JIRA 37552 nkhetan ends

		
		--SET @nSqlRes = @nSqlRes + 'PAID_TOTAL = @pPaidTot, COLLECTION_TOTAL = @pColTot WHERE RC_ROW_ID = @pRcRowId'
		SET @nSqlRes = @nSqlRes + 'PAID_TOTAL = @pPaidTot, COLLECTION_TOTAL = @pColTot' 
		
		--AKUMAR523 STARTS 60666
		IF @fVersionNum >=19.1
		BEGIN
			IF @vTransType = 'P' --udoni RMA-64208
				BEGIN
			IF @vCheckStatus='P'
				BEGIN
					SET @dPrintedTot = @dPrintedTot + @dBaseCurrAmt
					SET @nSqlRes += ', PRINT_TOTAL = @pPaidPrTot'
				END
			ELSE 
				BEGIN
					SET @dAllocatedAmt = @dAllocatedAmt + @dBaseCurrAmt
					SET @nSqlRes += ', ALLOCATED_AMOUNT = @pPaidAlTot'
				END
			---POLICY_CURR_PRINT_TOTAL,POLICY_CURR_ALLOCATED_TOTAL'
			END 	
		END
		SET @nSqlRes = @nSqlRes +' WHERE RC_ROW_ID = @pRcRowId'
		--AKUMAR523 ENDS 60666
		EXECUTE SP_EXECUTESQL @nSqlRes,
		N' @pResAmt DECIMAL(20,2), @pBalAmt DECIMAL(20,2), @pIncAmt DECIMAL(20,2),
		   @pDateTime VARCHAR(14), @pPaidTot DECIMAL(20,2), @pColTot DECIMAL(20,2), @pRcRowId INT,
		   @pClmResBal decimal(20,2), @pClmResAmt decimal(20,2), @pClmPaidTot decimal(20,2), @pClmColTot decimal(20,2),
		   @pClmIncAmt decimal(20,2),@pRsvResAmt decimal(20,2),@pRsvPaidTot decimal(20,2) ,@RsvResBal decimal(20,2),
		   @pRsvColTot decimal(20,2),@pRsvIncAmt decimal(20,2),@pPolResBal decimal(20,2), @pPolResAmt decimal(20,2), @pPolPaidTot decimal(20,2),
		   @pPolColTot decimal(20,2), @pPolIncAmt decimal(20,2), @pClmCurPrtTot decimal(20,2), @pClmCurAltTot decimal(20,2), @pPolCurPrtTot decimal(20,2), @pPolCurAltTot decimal(20,2),
		   @pPaidPrTot decimal (20,2), @pPaidAlTot decimal(20,2)',
		   @pResAmt = @dResAmt, @pBalAmt = @dResBal, @pIncAmt = @dIncAmt, @pDateTime = @vDttmRcd,
		   @pPaidTot = @dPaidTot, @pColTot = @dColTot, @pRcRowId = @iDbRcRowId,
		   --JIRA 29954 knakra starts
		   @pClmResBal = @dClmResBal, @pClmResAmt = @dClmResAmt, @pClmPaidTot = @dClmPaidTot, @pClmColTot = @dClmColTot,
		   @pClmIncAmt = @dClmIncAmt, @pRsvResAmt = @dResAmt, @pRsvPaidTot = @dPaidTot, @RsvResBal =@dResBal,
		   @pRsvColTot = @dColTot ,@pRsvIncAmt =@dIncAmt,
		   @pPolResBal = @dPolResBal, @pPolResAmt = @dPolResAmt, @pPolPaidTot = @dPolPaidTot,
		   @pPolColTot = @dPolColTot, @pPolIncAmt = @dPolIncAmt,
		   --JIRA 29954 knakra ends
		---AKUMAR523 JIRA  60666
		   @pClmCurPrtTot=@dClmCurrPrTot,
		   @pClmCurAltTot=@dClmCurrAlTot,
		   @pPolCurPrtTot=@dPolCurrPrTot,
		   @pPolCurAltTot=@dPolCurrAlTot,
		   @pPaidPrTot=@dPrintedTot,
		   @pPaidAlTot=@dAllocatedAmt
		IF (@vClaimStatus = 'O' AND @iAdjLog = 1) OR (@vClaimStatus <> 'O' AND @iDoNothing = 1)	--Auto Adjust on open claims and rest options for closed claims
		BEGIN

			SET @nSqlRes = 'SELECT @pRsvRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''
			
			EXECUTE SP_EXECUTESQL @nSqlRes,
			N' @pRsvRowId INT OUTPUT',
			@pRsvRowId = @iRsvRowid OUTPUT

			SET @nSqlRes = 'INSERT INTO ' + @vDbName + 'RESERVE_HISTORY(RSV_ROW_ID,CLAIM_ID,RESERVE_TYPE_CODE,CLAIMANT_EID,UNIT_ID,'
			SET @nSqlRes = @nSqlRes + 'RESERVE_AMOUNT,PAID_TOTAL,COLLECTION_TOTAL,INCURRED_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,'
			SET @nSqlRes = @nSqlRes + 'REASON,DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,CLOSED_FLAG,AUTO_ADJ_FLAG,'
			--JIRA 23831 knakra starts
			SET @nSqlRes = @nSqlRes + 'RES_STATUS_CODE,'
			IF @iVarFinKey = 0
				SET @nSqlRes += ' POLCVG_ROW_ID,'
			SET @nSqlRes += ' POLICY_CVG_SEQNO,POLCVG_LOSS_ROW_ID,ENTERED_BY_USER'
			IF @iVarFinKey <> 0
				SET @nSqlRes += ',RC_ROW_ID'
			IF @iHmiFlag <> 0
				SET @nSqlRes += ', BEN_REVIEW_DATE'
			--JIRA 23831 knakra starts
			IF @iVarFinKey <> 0
				SET @nSqlRes += ', RESERVE_CATEGORY'
			--JIRA 23831 knakra ends
			--JIRA 28198 knakra starts
			IF @iClaimMCFields = 1
			BEGIN
				SET @nSqlRes += ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT'
				SET @nSqlRes += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, '
				--JIRA 29954 knakra starts
				IF @fVersionNum < 16.4
					SET @nSqlRes += 'BASE_TO_CLAIM_CUR_RATE'
				ELSE IF @fVersionNum >= 16.4
					SET @nSqlRes += 'CLAIM_CURR_CHANGE_AMOUNT'
				--JIRA 29954 knakra ends
			END

			IF @iRsvMCFields = 1
			BEGIN
				SET @nSqlRes += ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE'
				SET @nSqlRes += ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT'
			END

			IF @iPolMCFields = 1
			BEGIN
				--JIRA 29954 knakra starts
				--SET @nSqlRes += ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT'
				SET @nSqlRes += ', POLICY_CURR_CODE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT'
				--SET @nSqlRes += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE'
				SET @nSqlRes += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT'
				IF @fVersionNum < 16.4
					SET @nSqlRes += ', POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE'
				ELSE IF @fVersionNum >= 16.4
					SET @nSqlRes += ', CLAIM_TO_POLICY_CUR_RATE, POLICY_CURR_CHANGE_AMOUNT'
				--JIRA 29954 knakra ends
			END
			--JIRA 28198 knakra ends
			SET @nSqlRes += ') VALUES('
			--JIRA 23831 knakra ends
			SET @nSqlRes = @nSqlRes + '@pRsvRowId, @pClaimId, @pResTypeCode, @pClaimantEid, 0, '
			SET @nSqlRes = @nSqlRes + '@pResAmt, @pPaidTot,@pColTot, @pIncAmt,@pResBal, @pChangeAmt, '
			IF @iAdjLog = 1 AND @vClaimStatus = 'O'
				SET @nSqlRes = @nSqlRes + '''AUTO ADJUST'', '
			ELSE IF @iDoNothing = 1 AND @vClaimStatus <> 'O'
				SET @nSqlRes = @nSqlRes + '''PMT ON CLOSED CLAIM'', '
			SET @nSqlRes = @nSqlRes + '@pDateEntered, @pDateTime, ''DADDS'', @pDateTime, ''DADDS'', '
			IF @vClaimStatus = 'O' AND @iAdjLog = 1
				SET @nSqlRes = @nSqlRes + '0, -1, '
			ELSE IF @vClaimStatus <> 'O'
				SET @nSqlRes = @nSqlRes + '-1, 0, '
			SET @nSqlRes = @nSqlRes + '@pResStatusCode, '
			IF @iVarFinKey = 0
				SET @nSqlRes += '@pPolCvgRowId, '
			
			SET @nSqlRes += '@pPolCvgSeqNum, '
			IF @iCarrierFlag <> 0 OR @iVarFinKey <> 0
				SET @nSqlRes = @nSqlRes + '@pPolCvgLossRowId, '
			ELSE IF @iCarrierFlag = 0
				SET @nSqlRes = @nSqlRes + '0, '
			SET @nSqlRes = @nSqlRes + '''DADDS'''
			IF @iVarFinKey <> 0
				SET @nSqlRes += ', @pRcRowId'
			IF @iHmiFlag <> 0
				SET @nSqlRes += ', @pBenReviewDate'
			IF @iVarFinKey <> 0
				SET @nSqlRes += ', @pResSubTypeCodeId'
			--JIRA 28198 knakra starts
			IF @iClaimMcFields = 1
			BEGIN
				--SET @nSqlRes += ', 0, 1, @pResAmt, @pIncAmt, @pColTot, @pPaidTot, @pResBal, 1'
				SET @nSqlRes += ', @pClmCurCode, @pClmToBaseRate, @pClmResAmt, @pClmIncAmt, @pClmColTot, @pClmPaidTot, @pClmResBal, '
				IF @fVersionNum < 16.4
					SET @nSqlRes += '1'
				ELSE IF @fVersionNum >= 16.4
					SET @nSqlRes += '@pClmChgAmt'
			END
			IF @iRsvMCFields = 1
				SET @nSqlRes += ', 0, 1, @pResAmt, 1, 1, @pPaidTot, @pResBal, @pColTot, @pIncAmt'
			IF @iPolMCFields = 1
			BEGIN
				--JIRA 29954 knakra starts
				--SET @nSqlRes += ', 0, 1, @pResAmt, @pIncAmt, @pColTot, @pPaidTot, @pResBal, 1'
				SET @nSqlRes += ', @pPolCurCode, @pPolResAmt, @pPolIncAmt, @pPolColTot, @pPolPaidTot, @pPolResBal, '
				IF @fVersionNum < 16.4
					SET @nSqlRes += '1, 1'
				ELSE IF @fVersionNum >= 16.4
					SET @nSqlRes += '@pClmToPolRate, @pPolChgAmt'
				--JIRA 29954 knakra ends
			END
			--JIRA 28198 knakra ends
			SET @nSqlRes += ')'

			EXECUTE SP_EXECUTESQL @nSqlRes,
			N' @pRsvRowId INT, @pClaimId INT, @pResTypeCode INT, @pClaimantEid INT, 
			   @pResAmt DECIMAL(20,2), @pPaidTot DECIMAL(20,2), @pColTot DECIMAL(20,2), @pIncAmt DECIMAL(20,2),
			   @pResBal DECIMAL(20,2), @pChangeAmt DECIMAL(20,2),@pDateEntered VARCHAR(8), @pDateTime VARCHAR(14),
			   @pResStatusCode INT, @pPolCvgRowId INT, @pPolCvgSeqNum INT, @pPolCvgLossRowId INT, @pRcRowId INT, 
			   @pBenReviewDate VARCHAR(8), @pResSubTypeCodeId INT, @pClmCurCode INT, @pClmToBaseRate DECIMAL(20,2),
			   @pClmResAmt DECIMAL(20,2), @pClmIncAmt DECIMAL(20,2), @pClmColTot DECIMAL(20,2), @pClmPaidTot DECIMAL(20,2),
			   @pClmResBal DECIMAL(20,2), @pClmChgAmt DECIMAL(20,2), @pPolCurCode INT, @pPolResAmt DECIMAL(20,2),
			   @pPolIncAmt DECIMAL(20,2), @pPolColTot DECIMAL(20,2), @pPolPaidTot DECIMAL(20,2),
			   @pPolResBal DECIMAL(20,2), @pPolChgAmt DECIMAL(20,2), @pClmToPolRate DECIMAL(20,2)',	--JIRA 29954 knakra(MC  Parameters added)
			   @pRsvRowid = @iRsvRowid, @pClaimid = @iClaimId, @pResTypeCode = @iResTypeCode, @pClaimantEid = @iClaimantEid,
			   @pResAmt = @dResAmt, @pPaidTot = @dPaidTot, @pColTot = @dColTot, @pIncAmt = @dIncAmt, @pResBal = @dResBal,
			   @pChangeAmt = @dChangeAmt, @pDateEntered = @vTodayDate, @pDateTime = @vDttmRcd, @pResStatusCode = @iResStatus,
			   @pPolCvgRowId = @iPolCvgRowId, @pPolCvgSeqNum = @iPolCvgSeqNum, @pPolCvgLossRowid = @iPolCvgLossRowId, @pRcRowId = @iRcRowId,
			   @pBenReviewDate = @vBenReviewDate, @pResSubTypeCodeId = @iResSubTypeCodeId,	--JIRA 24633 and 23831 knakra
			   --JIRA 29954 knakra starts
			   @pClmCurCode = @iClmCurCode,
			   @pClmToBaseRate = @dClmToBaseRate,
			   @pClmResAmt = @dClmResAmt,
			   @pClmIncAmt = @dClmIncAmt,
			   @pClmColTot = @dClmColTot,
			   @pClmPaidTot = @dClmPaidTot,
			   @pClmResBal = @dClmResBal,
			   @pClmChgAmt = @dClmChgAmt,
			   @pPolCurCode = @iPolCurCode,
			   @pPolResAmt = @dPolResAmt,
			   @pPolIncAmt = @dPolIncAmt,
			   @pPolColTot = @dPolColTot,
			   @pPolPaidTot = @dPolPaidTot,
			   @pPolResBal = @dPolResBal,
			   @pPolChgAmt = @dPolChgAmt,
			   @pClmToPolRate = @dClmToPolRate
			   --JIRA 29954 knakra ends

			SET @nSqlRes = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''

			EXECUTE SP_EXECUTESQL @nSqlRes
		END

	END
	END TRY
	BEGIN CATCH
		SET @vErrMsgDesc = ERROR_MESSAGE()
		EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResReBal','ResReBal','DDS_RESERVE_REBAL_SQL',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
		SET @iErrCnt += 1
	END CATCH
	
	SET NOCOUNT OFF

END