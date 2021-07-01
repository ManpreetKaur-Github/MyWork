IF OBJECT_ID('DDS_PROCESS_RSV_CUR_SQL','P') IS NOT NULL
	DROP PROCEDURE DDS_PROCESS_RSV_CUR_SQL
GO
CREATE PROCEDURE [dbo].[DDS_PROCESS_RSV_CUR_SQL](
	@iClaimId INT, @iClaimantId INT, @pUnitId INT,@iLOB INT,@iRsvType INT,@fReserveAmount decimal(20,2),@iResStatus INT,@bProcessRsvhistory BIT,@vDateEntered VARCHAR(8),
	@iPOLCVG_LOSS_ROW_ID INT,@iPOLCVG_ROW_ID INT,@iPolicyCvgSeqNo INT,@vDbName varchar(100),@iJOBID int,
	@iDA_ROW_ID int ,@vCLAIM_ID varchar(20), @iVarFinKey int, @iResSubTypeCodeId int, @iHmiFlag int, @vBenReviewDate varchar(8),
	@iClaimMCFields int, @iRsvMCFields int, @iPolMCFields int, @dClmResAmt decimal(20,2), @dPolResAmt decimal(20,2), @dClmToBaseRate decimal(20,2), @dClmToPolRate decimal(20,2),
	@fVersionNum decimal(20,2), @iClmCurCode INT, @iPolCurCode INT, @iRC_ROW_ID int output, @iErrCnt int output)	--JIRA 23831 knakra(added new parameter @iVarFinKey)
	WITH EXECUTE AS CALLER
	AS
	BEGIN
	
	DECLARE
	@nSql						nvarchar(max),	
	@vReserveCategoryShortCode  varchar(25),
	@iRSV_ROW_ID				int,
	@fReserveBalance			decimal(20,2),
	@fIncurAmt					decimal(20,2),
	@v_SYS_DATE					varchar(14),
	@vErrorLocation				varchar(25),
	@vProcName					varchar(100)='DDS_PROCESS_RSV_CUR_SQL',
	@vErrorMsg					varchar(Max),
	@vLoc						varchar(max),
	@dClmIncAmt					decimal(20,2),
	@dClmResBal					decimal(20,2),
	@dPolIncAmt					decimal(20,2),
	@dPolResBal					decimal(20,2)

	SET @iRC_ROW_ID =0;
	SET @vErrorMsg = ''
	
	SET NOCOUNT ON
	
	BEGIN TRY			
		SET @vLoc = 'ResCat'
		SET @nSql = 'SELECT @pReserveCategoryShortCode = C1.SHORT_CODE FROM ' + @vDbName + 'CODES C1, ' + @vDbName + 'CODES C2 WHERE'
		SET @nSql = @nSql + ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = ' + CAST(ISNULL(@iRsvType,0) AS VARCHAR)

		EXECUTE SP_EXECUTESQL @nSql,
		N' @pReserveCategoryShortCode VARCHAR(25) OUTPUT',
		@pReserveCategoryShortCode = @vReserveCategoryShortCode OUTPUT

		IF @vReserveCategoryShortCode = 'R'
		BEGIN
			SET @fIncurAmt = 0
			SET @dClmIncAmt =  0    --JIRA 37552
			SET @dPolIncAmt =   0   --JIRA 37552
			IF @fVersionNum >= 16.4
			BEGIN
				SET @dClmIncAmt = 0		--JIRA 29954 knakra
				SET @dPolIncAmt = 0		--JIRA 29954 knakra
			END
		END
		ELSE
		BEGIN
			SET @fIncurAmt = @fReserveAmount
			SET @dClmIncAmt =  @fReserveAmount  --JIRA 37552
			SET @dPolIncAmt =   @fReserveAmount  --JIRA 37552
			IF @fVersionNum >= 16.4
			BEGIN
				SET @dClmIncAmt = @dClmResAmt		--JIRA 29954 knakra
				SET @dPolIncAmt = @dPolResAmt		--JIRA 29954 knakra
			END
		END

		SET @fReserveBalance = @fReserveAmount
		SET @dClmResBal = @fReserveAmount  --JIRA 37552
		SET @dPolResBal = @fReserveAmount  --JIRA 37552
		--JIRA 29954 knakra starts
		IF @fVersionNum >= 16.4
		BEGIN
			SET @dClmResBal = @dClmResAmt
			SET @dPolResBal = @dPolResAmt
		END
		--JIRA 29954 knakra ends
		
		SET @nSql = 'SELECT @pNxtUnqId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''RESERVE_CURRENT'''
		SET @vLoc = 'RCUID'
		EXECUTE SP_EXECUTESQL @nSql, N'@pNxtUnqId int OUTPUT', @pnxtUnqId = @iRC_ROW_ID OUTPUT
		

		
		SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = ''RESERVE_CURRENT'''
		SET @vLoc = 'UpdRcUid'
		EXECUTE SP_EXECUTESQL @nSql 
					
		
		SET @v_SYS_DATE=replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
					
					
		SET @nSql='INSERT INTO '+@vDbName+'RESERVE_CURRENT(RC_ROW_ID,CLAIM_ID,CLAIMANT_EID,UNIT_ID,RESERVE_TYPE_CODE,';
		SET @nSql=@nSql+'RESERVE_AMOUNT, BALANCE_AMOUNT, INCURRED_AMOUNT, PAID_TOTAL, COLLECTION_TOTAL,';
		SET @nSql=@nSql+'DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,REASON,';
		--JIRA 23831 knakra starts
		--SET @nSql=@nSql+'ENTERED_BY_USER,POLCVG_LOSS_ROW_ID,RESERVE_CATEGORY,POLCVG_ROW_ID,POLICY_CVG_SEQNO,RES_STATUS_CODE)';	JIRA 23831 knakra
		SET @nSql=@nSql+'ENTERED_BY_USER,POLCVG_LOSS_ROW_ID,RESERVE_CATEGORY,'
		IF @iVarFinKey = 0
			SET @nSql += ' POLCVG_ROW_ID,'
		--JIRA 24633 knakra starts
		--SET @nSql += ' POLICY_CVG_SEQNO,RES_STATUS_CODE)';
		SET @nSql += ' POLICY_CVG_SEQNO,RES_STATUS_CODE'
		IF @iHmiFlag <> 0
			SET @nSql += ', BEN_REVIEW_DATE'
		--JIRA 24633 knakra ends
		--JIRA 23831 knakra ends
		--JIRA 28198 knakra starts
		IF @iClaimMcFields = 1
		BEGIN
			SET @nSql += ', CLAIM_CURR_CODE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT'
			--JIRA 29954 knakra starts
			--SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE'
			SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT'
			IF @fVersionNum < 16.4
				SET @nSql += ', CLAIM_TO_BASE_CUR_RATE, BASE_TO_CLAIM_CUR_RATE '
			--JIRA 29954 knakra ends
		END

		IF @iRsvMCFields = 1
		BEGIN
			SET @nSql += ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE'
			SET @nSql += ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT'
		END

		IF @iPolMCFields = 1
		BEGIN
			--JIRA 29954 knakra starts
			--SET @nSql += ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT'
			--SET @nSql += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE'
			SET @nSql += ', POLICY_CURR_CODE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT'
			SET @nSql += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT'
			IF @fVersionNum < 16.4
				SET @nSql += ', POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE'
			--JIRA 29954 knakra ends
		END
		--JIRA 28198 knakra ends
		SET @nSql=@nSql+')VALUES(@P_RC_ROW_ID,@P_CLAIM_ID,@P_CLAIMANT_EID,@P_UNIT_ID,@P_RESERVE_TYPE_CODE,@P_RESERVE_AMOUNT,@P_BALANCE_AMOUNT,';
		SET @nSql=@nSql+'@P_INCURRED_AMOUNT,@P_PAID_TOTAL,@P_COLLECTION_TOTAL,@P_DATE_ENTERED,@P_DTTM_RCD_ADDED,@P_ADDED_BY_USER,@P_DTTM_RCD_LAST_UPD,';
		--JIRA 23831 knakra starts
		--SET @nSql=@nSql+'@P_UPDATED_BY_USER,@P_REASON,@P_ENTERED_BY_USER,@P_POLCVG_LOSS_ROW_ID,@P_RESERVE_CATEGORY,@P_POLCVG_ROW_ID,@P_POLICY_CVG_SEQNO,@P_RES_STATUS_CODE)' ;
		SET @nSql= @nSql + '@P_UPDATED_BY_USER,@P_REASON,@P_ENTERED_BY_USER,@P_POLCVG_LOSS_ROW_ID,@P_RESERVE_CATEGORY,'
		IF @iVarFinKey = 0
			SET @nSql += ' @P_POLCVG_ROW_ID,'
		--JIRA 23831 knakra ends

		--JIRA 24633 knakra starts
		--SET @nSql += ' @P_POLICY_CVG_SEQNO,@P_RES_STATUS_CODE)' ;
		SET @nSql += ' @P_POLICY_CVG_SEQNO,@P_RES_STATUS_CODE'
		IF @iHmiFlag <> 0
			SET @nSql += ', @pBenReviewDate'
		--JIRA 24633 knakra ends
		--JIRA 28198 knakra starts
		IF @iClaimMcFields = 1
		BEGIN
			SET @nSql += ', @pClmCurCode, @pClmResAmt, @pClmIncAmt, 0, 0, @pClmResBal'
			IF @fVersionNum < 16.4
				SET @nSql += ', 1, 1'
		END
		IF @iRsvMCFields = 1
			SET @nSql += ', 0, 1, @P_RESERVE_AMOUNT, 1, 1, @P_PAID_TOTAL, @P_BALANCE_AMOUNT, @P_COLLECTION_TOTAL, @P_INCURRED_AMOUNT'
		IF @iPolMCFields = 1
		BEGIN
			SET @nSql += ', @pPolCurCode, @pPolResAmt, @pPolIncAmt, 0, 0, @pPolResBal'
			IF @fVersionNum < 16.4
				SET @nSql += ', 1, 1'
		END
		SET @nSql += ')'
		--JIRA 28198 knakra ends
		SET @vLoc = 'RcIns'
		
		Exec sp_Executesql @nSql,
		N'@P_RC_ROW_ID INT,
		@P_CLAIM_ID INT,
		@P_CLAIMANT_EID INT,
		@P_UNIT_ID INT,
		@P_RESERVE_TYPE_CODE INT,
		@P_RESERVE_AMOUNT DECIMAL(20,2),
		@P_BALANCE_AMOUNT DECIMAL(20,2),
		@P_INCURRED_AMOUNT DECIMAL(20,2),
		@P_PAID_TOTAL DECIMAL(20,2),
		@P_COLLECTION_TOTAL DECIMAL(20,2),
		@P_DATE_ENTERED VARCHAR(8),
		@P_DTTM_RCD_ADDED VARCHAR(14),
		@P_ADDED_BY_USER VARCHAR(50),
		@P_DTTM_RCD_LAST_UPD VARCHAR(14),
		@P_UPDATED_BY_USER VARCHAR(50),
		@P_REASON VARCHAR(30),
		@P_ENTERED_BY_USER VARCHAR(50),
		@P_POLCVG_LOSS_ROW_ID INT,
		@P_RESERVE_CATEGORY INT,
		@P_POLCVG_ROW_ID INT,
		@P_POLICY_CVG_SEQNO INT,
		@P_RES_STATUS_CODE INT,
		@pBenReviewDate VARCHAR(8),
		@pClmCurCode INT,
		@pClmResAmt DECIMAL(20,2),
		@pClmIncAmt DECIMAL(20,2),
		@pClmResBal DECIMAL(20,2),
		@pPolCurCode INT,
		@pPolResAmt DECIMAL(20,2),
		@pPolIncAmt DECIMAL(20,2),
		@pPolResBal DECIMAL(20,2)',
		@P_RC_ROW_ID=@iRC_ROW_ID,
		@P_CLAIM_ID=@iClaimId,
		@P_CLAIMANT_EID=@iClaimantId,
		@P_UNIT_ID=@pUnitId,
		@P_RESERVE_TYPE_CODE=@iRsvType,
		@P_RESERVE_AMOUNT=@fReserveAmount,
		@P_BALANCE_AMOUNT=@fReserveBalance, --pending apply dfilterCurrency
		@P_INCURRED_AMOUNT=@fIncurAmt,  ----pending apply dfilterCurrency
		@P_PAID_TOTAL=0,
		@P_COLLECTION_TOTAL=0,
		@P_DATE_ENTERED=@vDateEntered,
		@P_DTTM_RCD_ADDED=@v_SYS_DATE,
		@P_ADDED_BY_USER='DADDS',
		@P_DTTM_RCD_LAST_UPD=@v_SYS_DATE,
		@P_UPDATED_BY_USER='DADDS',
		@P_REASON='DADDS Payment Record',
		@P_ENTERED_BY_USER='DADDS',
		@P_POLCVG_LOSS_ROW_ID=@iPOLCVG_LOSS_ROW_ID,
		@P_RESERVE_CATEGORY=@iResSubTypeCodeId,	--JIRA 23831 knakra
		@P_POLCVG_ROW_ID=@iPOLCVG_ROW_ID,
		@P_POLICY_CVG_SEQNO=@iPolicyCvgSeqNo,
		@P_RES_STATUS_CODE=@iResStatus,
		@pBenReviewDate = @vBenReviewDate,	--JIRA 24633 knakra
		@pClmResAmt = @dClmResAmt,			--JIRA 29954 knakra starts
		@pClmCurCode = @iClmCurCode,
		@pClmIncAmt = @dClmIncAmt,
		@pClmResBal = @dClmResBal,
		@pPolCurCode = @iPolCurCode,
		@pPolResAmt = @dPolResAmt,
		@pPolIncAmt = @dPolIncAmt,
		@pPolResBal = @dPolResBal			--JIRA 29954 knakra ends

		IF (@bProcessRsvhistory=1)
		BEGIN
					
			
			SET @nSql = 'SELECT @pNxtUnqId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''
			SET @vLoc = 'RHUID'
			EXECUTE SP_EXECUTESQL @nSql, N'@pNxtUnqId int OUTPUT', @pnxtUnqId = @iRSV_ROW_ID OUTPUT
								
			SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''
			SET @vLoc = 'UpdRHUid'
			EXECUTE SP_EXECUTESQL @nSql							
						
			SET @v_SYS_DATE=replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
			SET @nSql='INSERT INTO '+@vDbName+'RESERVE_HISTORY(RSV_ROW_ID,CLAIM_ID,RESERVE_TYPE_CODE,CLAIMANT_EID,UNIT_ID,RESERVE_AMOUNT,PAID_TOTAL,';
			SET @nSql=@nSql+'COLLECTION_TOTAL,INCURRED_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,REASON,DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,';
			--JIRA 23831 knakra starts
			SET @nSql=@nSql+'DTTM_RCD_LAST_UPD,UPDATED_BY_USER,ENTERED_BY_USER, POLCVG_LOSS_ROW_ID,RESERVE_CATEGORY, '
			IF @iVarFinKey = 0
				SET @nSql += ' POLCVG_ROW_ID,'
			SET @nSql=@nSql+'APPROVER_ID, ONHOLD_RSV_ROW_ID,RES_STATUS_CODE'
			IF @iVarFinKey <> 0
				SET @nSql += ', RC_ROW_ID'
			--JIRA 23831 knakra ends
			--JIRA 24633 knakra starts
			If @iHmiFlag <> 0
				SET @nSql += ', BEN_REVIEW_DATE'
			--JIRA 24633 knarka ends
			--JIRA 28198 knakra starts
			IF @iClaimMcFields = 1
			BEGIN
				SET @nSql += ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT'
				SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE'
			END

			IF @iRsvMCFields = 1
			BEGIN
				SET @nSql += ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE'
				SET @nSql += ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT'
			END

			IF @iPolMCFields = 1
			BEGIN
				SET @nSql += ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT'
				SET @nSql += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE'
			END
			--JIRA 28198 knakra ends
			SET @nSql += ')VALUES(@P_RSV_ROW_ID,@P_CLAIM_ID,@P_RESERVE_TYPE_CODE,@P_CLAIMANT_EID,@P_UNIT_ID,';
			SET @nSql=@nSql+'@P_RESERVE_AMOUNT,@P_PAID_TOTAL,@P_COLLECTION_TOTAL,@P_INCURRED_AMOUNT,@P_BALANCE_AMOUNT,@P_CHANGE_AMOUNT,@P_REASON,';
			SET @nSql=@nSql+'@P_DATE_ENTERED,@P_DTTM_RCD_ADDED,@P_ADDED_BY_USER,@P_DTTM_RCD_LAST_UPD,@P_UPDATED_BY_USER,@P_ENTERED_BY_USER,';
			--SET @nSql=@nSql+'@P_POLCVG_LOSS_ROW_ID,@P_RESERVE_CATEGORY,@P_POLCVG_ROW_ID,@P_APPROVER_ID,@P_ONHOLD_RSV_ROW_ID,@P_RES_STATUS_CODE)';
			SET @nSql=@nSql+'@P_POLCVG_LOSS_ROW_ID,@P_RESERVE_CATEGORY,'
			IF @iVarFinKey = 0
				SET @nSql += ' @P_POLCVG_ROW_ID,'
			SET @nSql += ' @P_APPROVER_ID,@P_ONHOLD_RSV_ROW_ID,@P_RES_STATUS_CODE'
			--JIRA 24633 and JIRA 23831 knakra starts
			IF @iVarFinKey <> 0
				SET @nSql += ', @pRcRowId'
			IF @iHmiFlag <> 0
				SET @nSql += ', @pBenReviewDate'
			--JIRA 28198 knakra starts
			IF @iClaimMcFields = 1
				SET @nSql += ', 0, 1, @P_RESERVE_AMOUNT, @P_INCURRED_AMOUNT, @P_COLLECTION_TOTAL, @P_PAID_TOTAL, @P_BALANCE_AMOUNT, 1'
			IF @iRsvMCFields = 1
				SET @nSql += ', 0, 1, @P_RESERVE_AMOUNT, 1, 1, @P_PAID_TOTAL, @P_BALANCE_AMOUNT, @P_COLLECTION_TOTAL, @P_INCURRED_AMOUNT'
			IF @iPolMCFields = 1
				SET @nSql += ', 0, 1, @P_RESERVE_AMOUNT, @P_INCURRED_AMOUNT, @P_COLLECTION_TOTAL, @P_PAID_TOTAL, @P_BALANCE_AMOUNT, 1'
			--JIRA 28198 knakra ends
			SET @nSql += ')';
			--JIRA 24633 and JIRA 23831 knakra ends

			SET @vLoc = 'RHIns'
			
			Exec sp_Executesql @nSql,
			N'@P_RSV_ROW_ID INT,
			@P_CLAIM_ID INT,
			@P_RESERVE_TYPE_CODE INT,
			@P_CLAIMANT_EID INT,
			@P_UNIT_ID INT,
			@P_RESERVE_AMOUNT DECIMAL(20,2),
			@P_PAID_TOTAL DECIMAL(20,2),
			@P_COLLECTION_TOTAL DECIMAL(20,2),
			@P_INCURRED_AMOUNT DECIMAL(20,2),
			@P_BALANCE_AMOUNT DECIMAL(20,2),
			@P_CHANGE_AMOUNT DECIMAL(20,2),
			@P_REASON VARCHAR(256),
			@P_DATE_ENTERED VARCHAR(8),
			@P_DTTM_RCD_ADDED VARCHAR(14),
			@P_ADDED_BY_USER VARCHAR(50),
			@P_DTTM_RCD_LAST_UPD VARCHAR(14),
			@P_UPDATED_BY_USER VARCHAR(50),
			@P_ENTERED_BY_USER VARCHAR(50),
			@P_POLCVG_LOSS_ROW_ID INT,
			@P_RESERVE_CATEGORY INT,
			@P_POLCVG_ROW_ID INT,
			@P_APPROVER_ID INT,
			@P_ONHOLD_RSV_ROW_ID INT,
			@P_RES_STATUS_CODE INT,
			@pRcRowId INT,
			@pBenReviewDate VARCHAR(8)',
			@P_RSV_ROW_ID=@iRSV_ROW_ID,
			@P_CLAIM_ID=@iClaimId,
			@P_RESERVE_TYPE_CODE=@iRsvType,
			@P_CLAIMANT_EID=@iClaimantId,
			@P_UNIT_ID=@pUnitId,
			@P_RESERVE_AMOUNT=@fReserveAmount,
			@P_PAID_TOTAL=0,
			@P_COLLECTION_TOTAL=0,
			@P_INCURRED_AMOUNT=@fIncurAmt,
			@P_BALANCE_AMOUNT=@fReserveBalance,
			@P_CHANGE_AMOUNT=@fReserveAmount,
			@P_REASON='DADDS Payment Record',
			@P_DATE_ENTERED=@vDateEntered,
			@P_DTTM_RCD_ADDED=@v_SYS_DATE,
			@P_ADDED_BY_USER='DADDS',
			@P_DTTM_RCD_LAST_UPD=@v_SYS_DATE,
			@P_UPDATED_BY_USER='DADDS',
			@P_ENTERED_BY_USER='DADDS',
			@P_POLCVG_LOSS_ROW_ID=@iPOLCVG_LOSS_ROW_ID,
			@P_RESERVE_CATEGORY=@iResSubTypeCodeId,	--JIRA 23831 knakra
			@P_POLCVG_ROW_ID=@iPOLCVG_ROW_ID,
			@P_APPROVER_ID=0,
			@P_ONHOLD_RSV_ROW_ID=0,
			@P_RES_STATUS_CODE=@iResStatus,
			@pRcRowId = @iRC_ROW_ID,		--JIRA 23831 knakra
			@pBenReviewDate = @vBenReviewDate	--JIRA 24633 knakra
		END
	END TRY
	BEGIN CATCH
		SET @vErrorMsg = ERROR_MESSAGE()
		EXECUTE DDS_ERROR_LOG_CAPTURE @iJOBID,@iDA_ROW_ID,'PAYMENT','RcIfNotFound',@vLoc,'DDS_PROCESS_RSV_CUR_SQL',@vErrorMsg,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
		SET @iErrCnt += 1
	END CATCH

	SET NOCOUNT OFF

	END