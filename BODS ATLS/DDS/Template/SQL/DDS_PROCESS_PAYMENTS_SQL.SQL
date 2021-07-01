IF OBJECT_ID('DDS_PROCESS_PAYMENTS','P') IS NOT NULL
	DROP PROCEDURE DDS_PROCESS_PAYMENTS
GO
CREATE PROCEDURE [dbo].[DDS_PROCESS_PAYMENTS](
	@P_JOBID INT, @P_DB_NAME VARCHAR(MAX), @P_UserId INT) ---- dsharma70 review : @P_DB_NAME length should be more than 100. I checked fro 123 characters and it creates a db anme with it. plz check/knakra(done)
	WITH EXECUTE AS CALLER
	AS	
	BEGIN
		DECLARE 
		--import file columns variable starts
		@iDA_ROW_ID				int,
		@iJOBID					int, 
		--@iINPUT_ROW_ID		int,
		@iINVALID_ROW			int,		
		--@iUPDATE_ROW			int,		
		@vRECORD_TYPE			varchar(1),
		@vTRANSACTION_TYPE		varchar(25),
		@vCLAIM_ID				varchar(25), 
		@vACTIVITY_DATE			varchar(8),
		@vTYPE_FLAG				varchar(1),
		@fAMOUNT				decimal(20,2),
		@vMEMO					varchar(MAX),
		@vCARRIER				varchar(16),
		@vADJUSTER				varchar(16),
		@vCHECK_NO				varchar(25),
		@iCHECK_SUFFIX			int,
		@vCHECK_STATUS			varchar(1),
		@vTYPE_CODE				varchar(25),
		@vPAYEE_TYPE			varchar(25),
		@vPAYEE_TAX_ID_NO		varchar(20),
		@vPAYEE_LASTNAME		varchar(255),
		@vPAYEE_FIRSTNAME		varchar(255),
		@vPAYEE_ADDRESS			varchar(100),
		@vPAYEE_CITY			varchar(50),
		@vPAYEE_STATE			varchar(4),
		@vPAYEE_ZIP				varchar(10),
		@vTRANSACTION_DATE		varchar(8),
		@vREPORT_1099_FLAG		varchar(1),
		@vSERVICE_FROM_DATE		varchar(8),
		@vSERVICE_TO_DATE		varchar(8),
		@vCLEARED_FLAG			varchar(1),
		@vDATE_CLEARED			varchar(8),
		@vBANK_ACCOUNT_NUM		varchar(20),
		@vBANK_SUB_ACCNT_NUM	varchar(20),
		@vPAYEE_ADDRESS2		varchar(100),
		
		
		@vUSER_FIELD_A			varchar(max),
		@vUSER_FIELD_B			varchar(255), 
		@vUSER_FIELD_C			varchar(255),
		@vUSER_FIELD_D			varchar(255),
		@vUSER_FIELD_E			varchar(255),
		@vUSER_FIELD_F			varchar(255),
		@vUSER_FIELD_G			varchar(255),
		@vUSER_FIELD_H			varchar(255),
		@vUSER_FIELD_I			varchar(255),
		@vUSER_FIELD_J			varchar(255),
		@vUSER_FIELD_K			varchar(255),
		@vUSER_FIELD_L			varchar(255),
		@vUSER_FIELD_M			varchar(255),
		@vUSER_FIELD_N			varchar(255),
		@vUSER_FIELD_O			varchar(255),
		@vUSER_FIELD_P			varchar(255),
		@vUSER_FIELD_Q			varchar(255),
		@vUSER_FIELD_R			varchar(255),
		@vUSER_FIELD_S			varchar(255),
		@vUSER_FIELD_T			varchar(255),
		@vUSER_FIELD_U			varchar(255),
		@vUSER_FIELD_V			varchar(255),
		@vUSER_FIELD_W			varchar(255),
		@vUSER_FIELD_X			varchar(255),
		@vUSER_FIELD_Y			varchar(255),
		@vUSER_FIELD_Z			varchar(255),
		

		@vINVOICE_NUMBER		varchar(25),
		@iCLAIMANT_SUFFIX		int,
		@vRES_STATUS_CODE		varchar(25),
		@vUNIT_TYPE				varchar(10),
		@vPOLICY_NAME			varchar(20),
		@vUNIT_NUMBER			varchar(10),
		@vCOVERAGE_CODE			varchar(25),
		@vLOSS_CODE				varchar(25),
		@vRESERVE_SUB_TYPE		varchar(25),
		@vDISABILITY_CATEGORY	varchar(25),
		@vVOID_CODE_REASON		varchar(255),
		@vMODULE_NO				varchar(10),
		@vPREFIX				varchar(25),
		@vSUFFIX_COMMON			varchar(25),
		@vSUFFIX_LEGAL			varchar(50),
		@vMEMO_PHRASE			varchar(50),
		@vCLASS_CODE			varchar(25),
		@vCVG_SEQUENCE_NO		varchar(8),
		@vTRANS_SEQ_NO			varchar(8),
		@vCVG_DESC				varchar(100),
		@vSUBLINE_DESC			varchar(100),
		@vCLASS_DESC			varchar(100),
		@vSTAT_UNIT_NUMBER		varchar(10),
		@vPOLICY_CVG_SEQNO		varchar(10),
		@vRESERVE_TYPE			varchar(25),
		@vNAME_TYPE				varchar(25),
		@vPOLICY_NUMBER			varchar(40),
		@vPOLICY_SYMBOL			varchar(20),
		@vMASTER_COMPANY		varchar(10),
		@vLOCATION_COMPANY		varchar(10),
		@vDSTRBN_TYPE_CODE		varchar(25),
		@vPAYEE_DOB				varchar(8),
		@vREGION				varchar(4),
		@vBEN_REVIEW_DATE		varchar(8),
		@vEOB_REMARKS_CODE_1	varchar(25),	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_2	varchar(25),	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_3	varchar(25),	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_4	varchar(25),	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_5	varchar(25),	--JIRA 24633 knakra
		@vEOB_PRINTED_DATE		varchar(8),
		@vEOB_PRINTED_BY_USER	varchar(50),
		@vUNIT_FIRST_NAME		varchar(255),
		@vUNIT_LAST_NAME		varchar(255),
		@vUNIT_TAX_ID			varchar(20),
		@vUNIT_DOB				varchar(8),
		@vCLMNT_LAST_NAME		varchar(255),
		@vCLMNT_FIRST_NAME		varchar(255),
		@vCLMNT_TAX_ID			varchar(20),
		@vEMP_NUM				varchar(20),
		@vUNIT_ID				varchar(20),
		@vPMT_CURR_CODE			varchar(25),
		@dPMT_TO_BASE_CURR_RATE	decimal(20,2),
		@dPMT_TO_POL_CURR_RATE	decimal(20,2),
		@dPMT_TO_CLM_CURR_RATE	decimal(20,2),
		@dCLM_TO_BASE_CURR_RATE	decimal(20,2),
		@dCLM_TO_POL_CURR_RATE	decimal(20,2),
		--Import file Columns variable ends
		
		--UI Options Specific Variables starts
		@oAllowNewCodes			int,
		@oDontCheckDupPay		int,
		@oAttachTransIdToChkNum	int,
		@oMatchClmntByName		int,
		@oMatchClmntBySuffix	int,
		@oUpdClmntNameGc		int,
		@oUpdClmntNameWc		int,
		@oEmpMatchByName		int,
		@oEmpMatchByEmpNum		int,
		@oEmpMatchByTaxId		int,
		@oNonEmpMatchByName		int,
		@oNonEmpMatchByTaxId	int,
		@oRecalReserves			int,
		@oPayBankAcc			int,
		@oPaySubAcc				int,
		@oChkDupReserves		int,
		@oFundSupp				int,
		@oNonEmpMatchByDob		int,
		@oEmpMatchByDob			int,
		--UI Options Specific Variables ends
		
		--Local Variables Declaration Starts
		@CursorPay				CURSOR,
		@vReqColumns			varchar(max),
		@vDbName				varchar(max),
		@iCarrierFlag			int,
		@nSql					nvarchar(max),
		@iCurrentRow			int,
		@iTotalRows				int = 0,
		@iPos					int,
		@vColName				varchar(100),
		@vVal					varchar(MAX),
		@vCodeField				varchar(MAX),
		@vSysTableName			varchar(MAX),
		@vAllowCreation			varchar(max),
		@vTableName				varchar(100),
		@iCodeId				int,
		@iPayeeTypeCodeId		int,
		@iLossCodeId			int,
		@iDisCatCodeId			int,
		@iResTypeCodeId			int,
		@iNameType				int,
		@iDistTypeCodeId		int,
		@iResSubTypeCodeId		int,
		@iPrefixCodeId			int,
		@iSuffCommonCodeId		int,
		@iChkStatCodeId			int,
		@iTransTypeCodeId		int,
		@iMemoCodeId			int,
		@iLob					int,
		@iClaimId				int,
		@iRsvBucketMapped		int,
		@vErrMsgDesc			varchar(max), 
		@iClaimantEid			int,
		@iUsePolInterface		int,
		@iUseClaimantTrack		int,
		@iPolicyId				int,
		@vPolicyLob				varchar(25),
		@vPolSysId				int,
		@iUnitId				int = 0,
		@iPolUnitRowId			int = 0,
		@iPolCvgRowId			int = 0,
		@iCvgLossRowId			int = 0,
		@vCvgTxt				varchar(max),
		@nSql2					nvarchar(max),
		@iCvgCodeId				int,
		@iLossCodeMapping		int,		
		@iResStatusCodeId		int,
		@fChangeAmt				decimal(20,2),
		@fCurRsvAmt				decimal(20,2),
		@fPaidTot				decimal(20,2),
		@fColTot				decimal(20,2),
		@vParentRsvCode			varchar(25),
		@fResBal				decimal(20,2),
		@fInccurAmt				decimal(20,2),
		@iCollInRsvBal			int,
		@iColInIncBal			int,
		@iPayFlag				int,
		@iVoidFlag				int,
		@iRcRowId				int = 0,
		@iResStatusCode         int =0 ,  ---JIRA 37275 
		@iPayeeEid				int,
		@vCvgKey				varchar(100),
		@vPolKey				varchar(50),
		@iLimitFlag				int,
		@dAggAmtOnPol			decimal(20,2),
		@dOccAmtOnPol			decimal(20,2),
		@dAggAmtOnCvg			decimal(20,2),
		@dOccAmtOnCvg			decimal(20,2),
		@iIsEft					int,
		@iDefDistTypeCode		int,
		@vDistTypeSCode			varchar(25),
		@iPrintedStatus			int,
		@iRowId					int,				
		@iErrCnt				int = 0,
		@iBaseErr				int = 0,
		@iClmntTypePayee		int = 0,
		@iPolErr				int = 0,
		@vErrColumns			varchar(100),
		@vResTypeCode			varchar(25),
		@iRsvRowId				int = 0,		
		@iVehicleId				int = 0,
		@iChkClaimant			int,
		@iOpenResStatusCode		int,
		@iIncSuffix				int,
		@iIncPrefix				int,
		@vPayToTheOrderOf		varchar(max),
		@vResStatus				varchar(25),
		@iResSuppPaymentFlag	int,
		@utPayee				tEntity,
		@vSysDateTime			varchar(16),
		@vCheckStatus			varchar(25),
		@iStateRowId			int,
		@iColFlag				int,
		@iClearedFlag			int,
		@iPayeeRowId			int,
		@iSplitRowId			int,
		@iPolSysId				int = 0,
		@dSumAmount				decimal(20,2),
		@vResCatShortCode		varchar(25),
		@vClmLobDb				varchar(25),
		@iReBalErrCnt			int,
		@vLocation				varchar(max),
		@oConfigId				int,
		@iErrCntSupp			int,
		@iClmntErr				int,
		@vRsvTypeSCode			varchar(25),
		@iEntId					int,
		@iPayeeErr				int,
		@vValidStrtDate			varchar(8),
		@vValidEndDate			varchar(8),
		@iActivityType			int,
		@vActivityType			varchar(25),
		@iActivityRowId			int,	--knakra activity track starts
		@iTableId				int,
		@iActivityCodeid		int,
		@iVoidFlagAt			int,
		@iIsCol					int,			--knakra activity track
		@fVersionNum			decimal(10,1),	--JIRA 23831 knakra starts
		@iRetVal				int,	
		@iVarFinKey				int,
		@iIncClmnt				int,
		@iIncRsvType			int,
		@iIncRsvSubType			int,
		@iIncLossType			int,
		@iIncPolCvg				int,	
		@iFinRowId				int,
		@iFinKeyFilter			int,			
		@iPolLobCode			int,			
		@iClmTypeCode			int,			--JIRA 23831 knakra ends
		@iUnitEntId				int,			--JIRA 24633 knakra
		@iHmiFlag				int = 0,		--JIRA 24633 knakra
		@iClaimMcFields			int = 0,		--JIRA 28198 knarka starts
		@iRsvMCFields			int = 0,
		@iPolMCFields			int = 0,		--JIRA 28198 knakra ends
		@iMcFlag				int = 0,		--JIRA 30818 knakra
		@iMc16_4				int = 0,		--JIRA 30818 knakra
		@iEobRemarksCode1		int = 0,
		@iEobRemarksCode2		int = 0,
		@iEobRemarksCode3		int = 0,
		@iEobRemarksCode4		int = 0,
		@iEobRemarksCode5		int = 0,
		@nSqlMC					nvarchar(MAX),
		@iPmtCurrCodeId			int = 0,		--JIRA 30818 knakra starts
		@dInpAmt				decimal(20,2),
		@iBaseCurrCodeId		int = 0,
		@iClmCurrCodeId			int = 0,
		@iPolCurrCodeId			int = 0,
		@dClmCurrRsvAmt			decimal(20,2) = 0,
		@dClmCurrAmt			decimal(20,2) = 0,
		@dClmCurrChgAmt			decimal(20,2) = 0,
		@dClmCurrPaidTot		decimal(20,2) = 0,
		@dClmCurrColTot			decimal(20,2) = 0,
		@dClmCurrIncAmt			decimal(20,2) = 0,
		@dClmCurrBalAmt			decimal(20,2) = 0,
		@dPolCurrChgAmt			decimal(20,2) = 0,
		@dPmtCurrAmt			decimal(20,2) = 0,
		@dPmtToPolCurrRate		decimal(20,2) = 1,
		@dPmtToClmCurrRate		decimal(20,2) = 1,
		@dPmtToBaseCurrRate		decimal(20,2) = 1,
		@dClmToPolCurrRate		decimal(20,2) = 1,
		@dClmtoBaseCurrRate		decimal(20,2) = 1,
		@dBaseCurrAmt			decimal(20,2) = 0,
		@dBaseCurrRsvAmt		decimal(20,2) = 0,
		@dBaseCurrPaidTot		decimal(20,2) = 0,
		@dBaseCurrBalAmt		decimal(20,2) = 0,
		@dBaseCurrColTot		decimal(20,2) = 0,
		@dBaseCurrIncAmt		decimal(20,2) = 0,
		@dPolCurrRsvAmt			decimal(20,2) = 0,
		@dPolCurrPaidTot		decimal(20,2) = 0,
		@dPolCurrBalAmt			decimal(20,2) = 0,
		@dPolCurrColTot			decimal(20,2) = 0,
		@dPolCurrAmt			decimal(20,2) = 0,
		@iRsvUpdFlag			int = 0,
		@dPolCurrIncAmt			decimal(20,2) = 0,	--JIRA 30818 knakra ends
		@iAccountId				int,
		@iSubAccId				int,
		@iUseSubAcc				int,
		@g_iAccountId			int,
		@g_iSubAccId			int,
		@iTransNumber			int,
		@iTransid				int,
		--neha JIRA 33658 starts
		@iRunStatCnt            int=1,
		@vProcessMsg            varchar(100),
		@iRunCnt		        int=0,
		--neha JIRA 33658 ends   
		
		--Local Variables Declaration Starts
		@vEventDate				varchar(8),--JIRA 34797 kkaur25
		@iMalDistTypeCode		INT,
		@iReadytoprint          INT,   ----ASHARMA590
		@iPolLobRelatedCodeId	INT,    --akumar523 JIRA 63116
		 @iCount_islocked_reserve INT = 0, ---udoni 75601
		@vTableNamePayeType    varchar(100)
		SET NOCOUNT ON

		SET @vDbName = '[' + @P_DB_NAME + '].[DBO].'

		--JIRA 23831 knakra starts
		EXECUTE spCheckVersion 'FINANCIAL_KEY','ROW_ID',@P_DB_NAME,@iRetVal OUTPUT
		IF @iRetVal = 1
			SET @fVersionNum = 16.2

		--JIRA 28198 knakra starts
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_CURRENT', 'CLAIM_CURRENCY_RESERVE_AMOUNT', @P_DB_NAME, @iRetVal OUTPUT
		IF @iRetVal = 1
			SET @iClaimMcFields = 1
		
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_CURRENT', 'RSV_CURR_RSV_AMT', @P_DB_NAME, @iRetVal OUTPUT
		IF @iRetVal = 1
			SET @iRsvMCFields = 1
		
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_CURRENT', 'POLICY_CURR_RESERVE_AMOUNT', @P_DB_NAME, @iRetVal OUTPUT
		IF @iRetVal = 1
			SET @iPolMCFields = 1
		--JIRA 28198 knakra ends

		--JIRA 30818 knakra starts
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_HISTORY','CLAIM_CURR_CHANGE_AMOUNT',@P_DB_NAME,@iRetVal OUTPUT
		IF @iRetVal = 1
			SET @fVersionNum = 16.4
		--JIRA 30818 knakra ends

		SET @iRetVal = 0
		EXECUTE spCheckVersion 'FUNDS','DISABILITY_CLASS_ROW_ID',@P_DB_NAME,@iRetVal OUTPUT
		IF @iRetVal = 1
			SET @fVersionNum = 17.3
		--akumar523 starts 	60666
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_CURRENT','CLAIM_CURR_PRINT_TOTAL',@P_DB_NAME,@iRetVal OUTPUT
		IF @iRetVal = 1
			SET @fVersionNum = 19.1
		---akumar523 ends 60666
		SET @iRetVal = 0
		EXECUTE spCheckVersion 'RESERVE_CURRENT','IS_LOCKED',@P_DB_NAME,@iRetVal OUTPUT
		IF @iRetVal = 1
		SET @fVersionNum = 20.2
		---udoni RMA-75601
		
		--JIRA 24633 knakra starts
		SET @nSql = 'SELECT @pCodeId = CODE_ID FROM ' + @vDbName + 'CODES C INNER JOIN ' + @vDbName + 'GLOSSARY G ON C.TABLE_ID = G.TABLE_ID'
		SET @nSql += ' AND G.SYSTEM_TABLE_NAME = ''LINE_OF_BUSINESS'' AND C.SHORT_CODE = ''HC'''

		BEGIN TRY
			EXECUTE SP_EXECUTESQL @nSql,
			N' @pCodeId INT OUTPUT',
			@pCodeId = @iCodeId OUTPUT

			IF @iCodeId IS NOT NULL AND @iCodeId <> 0
				SET @iHmiFlag = 1
		END TRY
		BEGIN CATCH
			SET @vErrMsgDesc = ERROR_MESSAGE()
			EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','HMICheck','HMICheck','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
			SET @iBaseErr += 1
		END CATCH
		--JIRA 24633 knakra ends
		
		--JIRA 30818 knakra starts
		IF @fVersionNum >= 16.4
		BEGIN
			SET @nSqlMC = 'SELECT @pCurrRowId	= CURR_ROW_ID, @pExchRate = EXCHANGE_RATE FROM ' + @vDbName + 'CURRENCY_RATE WHERE '
			SET @nSqlMC += 'SOURCE_CURRENCY_CODE = @pSrcCurr AND DESTINATION_CURRENCY_CODE = @pDestCurr'

			SET @nSql = 'SELECT @pParmValue = STR_PARM_VALUE FROM ' + @vDbName + 'PARMS_NAME_VALUE WHERE PARM_NAME = @pSettingName'
			BEGIN TRY
				EXECUTE SP_EXECUTESQL @nSql,
				N'@pSettingName VARCHAR(50), @pParmValue INT OUTPUT',
				@pSettingName = 'USE_MULTI_CURRENCY',
				@pParmValue = @iMcFlag OUTPUT

				EXECUTE SP_EXECUTESQL @nSql,
				N'@pSettingName VARCHAR(50), @pParmValue INT OUTPUT',
				@pSettingName = 'BASE_CURRENCY_CODE',
				@pParmValue = @iBaseCurrCodeId OUTPUT
			END TRY
			BEGIN CATCH
				SET @iMcFlag = 0
				SET @vErrMsgDesc = 'McCheck,' + ERROR_MESSAGE() + '. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','McCheck','MCCheck','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
				SET @iBaseErr += 1
			END CATCH
		END
		ELSE
			SET @iMcFlag = 0
		--JIRA 30818 knakra ends 

		BEGIN TRY
			IF @fVersionNum >= 16.2
			BEGIN
				SET @iVarFinKey = 1
				SET @nSql = 'SELECT @pFinKeyFilter = STR_PARM_VALUE FROM ' + @vDbName + ' PARMS_NAME_VALUE WHERE PARM_NAME = ''FINANCIAL_KEY_FILTER'''
				EXECUTE SP_EXECUTESQL @nSql,
				N'@pFinKeyFilter INT OUTPUT',
				@pFinKeyFilter = @iFinKeyFilter OUTPUT
			END
			ELSE
			BEGIN
				SET @iVarFinKey = 0
				SET @nSql = N'SELECT @p_iCarrierFlag = STR_PARM_VALUE FROM ' + @vDbName + 'PARMS_NAME_VALUE WHERE PARM_NAME = ''MULTI_COVG_CLM'''	--check for carrier flag		
				EXEC SP_EXECUTESQL @nSql,N' @p_iCarrierFlag int OUTPUT',
				@p_iCarrierFlag = @iCarrierFlag OUTPUT		
			END
		END TRY
		BEGIN CATCH
			SET @vErrMsgDesc = 'ACCheck,' + ERROR_MESSAGE() + '. '
			EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ACCheck','ACCheck','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
			SET @iBaseErr += 1
		END CATCH
		--JIRA 23831 knakra ends

		SET @nSql = 'SELECT @pUsePolInterface = STR_PARM_VALUE FROM ' + @vDbName + 'PARMS_NAME_VALUE WHERE PARM_NAME = ''USE_POLICY_INTERFACE'''	--check for external policy interface
		BEGIN TRY
			EXECUTE SP_EXECUTESQL @nSql,
			N' @pUsePolInterface int OUTPUT',
			@pUsePolInterface = @iUsePolInterface OUTPUT 				
		END TRY
		BEGIN CATCH
			SET @vErrMsgDesc = 'PolInt, ' + ERROR_MESSAGE() + '. '
			EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PolInt','PolInt','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
			SET @iBaseErr += 1
		END CATCH
		
		BEGIN TRY
			--IF @iCarrierFlag <> 0 AND @iUsePolInterface = 0	--JIRA 23831 kankra
			IF @iCarrierFlag <> 0 AND @iUsePolInterface = 0 AND @iVarFinKey = 0	--JIRA 23831 knakra
			BEGIN
				SET @vErrMsgDesc = 'Carrier Settings is ON but Policy Interface is OFF, Use Policy Interface should be ON for Carrier ON Settings. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,0,'PAYMENT','PolicyInterface','PolicyInterface','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'JOB_ID','DDS_PAYMENT','JOB_ID',@P_JOBID,1
				SET @iBaseErr += 1
			END
		
			SELECT @oAllowNewCodes = ISNULL(ALLOW_NEW_CODES,0), @oAttachTransIdToChkNum = ISNULL(ATTACH_TRANS_ID_TO_CHECK_NO,0),
			@oChkDupReserves = ISNULL(CHECK_DUPLICATE_RESERVE_TRANS,0), @oDontCheckDupPay = ISNULL(DONT_CHECK_DUPLICATE_PAYMENTS,0),
			@oEmpMatchByEmpNum = ISNULL(EMPLOYEE_MATCH_BY_EMP_NUM,0), @oEmpMatchByName = ISNULL(EMPLOYEE_MATCH_BY_NAME,0),
			@oEmpMatchByTaxId =	ISNULL(EMPLOYEE_MATCH_BY_TAX_ID,0), @oMatchClmntByName = ISNULL(ID_CLAIMANT_BY_NAME,0),
			@oMatchClmntBySuffix = ISNULL(ID_CLAIMANT_BY_SUFFIX,0), @oNonEmpMatchByName = ISNULL(NON_EMP_MATCH_BY_NAME,0),
			@oNonEmpMatchByTaxId = ISNULL(NON_EMP_MATCH_BY_TAX_ID,0), @oPayBankAcc = ISNULL(PAYMENT_BANK_ACCOUNT,0),
			@oPaySubAcc = ISNULL(PAYMENT_SUB_ACCOUNT,0), @oRecalReserves = ISNULL(RECALCULATE_RESERVES,0),
			@oUpdClmntNameGc = ISNULL(UPDATE_CLAIMANT_NAME_GCVA,0), @oUpdClmntNameWc = ISNULL(UPDATE_CLAIMANT_NAME_WC,0),
			@oConfigId = CONFIG_ID, @oFundSupp = ISNULL(PAYMENT_SUPP,0), @vValidStrtDate = VALID_START_DATE, @vValidEndDate = VALID_END_DATE,	--JIRA 22275 knakra
			@oEmpMatchByDOB= ISNULL(EMPLOYEE_MATCH_BY_DOB,0), @oNonEmpMatchByDOB = ISNULL(NON_EMP_MATCH_BY_DOB,0)
			FROM DDS_OPTIONSET WHERE JOBID = @P_JOBID		--FETCH VALUES FROM OPTIONSET CORRESPONDING TO JOBID
		END TRY
		BEGIN CATCH
			SET @vErrMsgDesc = 'PolInt_Optionset, ' + ERROR_MESSAGE() + '. '
			EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PolInt_Optionset','PolInt_Optionset','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
			SET @iBaseErr += 1
		END CATCH		

		SELECT @iTotalRows = COUNT(1) FROM DDS_PAYMENT WHERE JOBID = @P_JOBID AND INVALID_ROW = 1
		SET @CursorPay = CURSOR LOCAL STATIC
		FOR
		SELECT * FROM DDS_PAYMENT WHERE JOBID = @P_JOBID AND INVALID_ROW = 1
		
		OPEN @CursorPay
		
		FETCH FIRST FROM @CursorPay INTO
		@iDA_ROW_ID,
		@iJOBID,		
		@iINVALID_ROW,					
		@vRECORD_TYPE,			
		@vTRANSACTION_TYPE,
		@vCLAIM_ID,		
		@vACTIVITY_DATE,
		@vTYPE_FLAG,		
		--@fAMOUNT,	JIRA 30818 knakra
		@dInpAmt,	--JIRA 30818 knakra
		@vMEMO,
		@vCARRIER,
		@vADJUSTER,				
		@vCHECK_NO,				
		@iCHECK_SUFFIX,
		@vCHECK_STATUS,			
		@vTYPE_CODE,			
		@vPAYEE_TYPE,			
		@vPAYEE_TAX_ID_NO,
		@vPAYEE_LASTNAME,		
		@vPAYEE_FIRSTNAME,		
		@vPAYEE_ADDRESS,		
		@vPAYEE_CITY,		
		@vPAYEE_STATE,		
		@vPAYEE_ZIP,		
		@vTRANSACTION_DATE,
		@vREPORT_1099_FLAG,		
		@vSERVICE_FROM_DATE,		
		@vSERVICE_TO_DATE,
		@vCLEARED_FLAG,	
		@vDATE_CLEARED,		
		@vBANK_ACCOUNT_NUM,
		@vBANK_SUB_ACCNT_NUM,
		@vPAYEE_ADDRESS2,
		@vUSER_FIELD_A,	
		@vUSER_FIELD_B,		
		@vUSER_FIELD_C,		
		@vUSER_FIELD_D,		
		@vUSER_FIELD_E,		
		@vUSER_FIELD_F,		
		@vUSER_FIELD_G,	
		@vUSER_FIELD_H,	
		@vUSER_FIELD_I,	
		@vUSER_FIELD_J,	
		@vUSER_FIELD_K,	
		@vUSER_FIELD_L,	
		@vUSER_FIELD_M,	
		@vUSER_FIELD_N,	
		@vUSER_FIELD_O,	
		@vUSER_FIELD_P,	
		@vUSER_FIELD_Q,	
		@vUSER_FIELD_R,	
		@vUSER_FIELD_S,	
		@vUSER_FIELD_T,	
		@vUSER_FIELD_U,	
		@vUSER_FIELD_V,
		@vUSER_FIELD_W,
		@vUSER_FIELD_X,
		@vUSER_FIELD_Y,
		@vUSER_FIELD_Z,
		@vINVOICE_NUMBER,
		@iCLAIMANT_SUFFIX,		
		@vRES_STATUS_CODE,		
		@vUNIT_TYPE,		
		@vPOLICY_NAME,
		@vUNIT_NUMBER,			
		@vCOVERAGE_CODE,
		@vLOSS_CODE,		
		@vRESERVE_SUB_TYPE,
		@vDISABILITY_CATEGORY,
		@vVOID_CODE_REASON,	
		@vMODULE_NO,		
		@vPREFIX,			
		@vSUFFIX_COMMON,
		@vSUFFIX_LEGAL,		
		@vMEMO_PHRASE,			
		@vCLASS_CODE,			
		@vCVG_SEQUENCE_NO,
		@vTRANS_SEQ_NO,		
		@vCVG_DESC,			
		@vSUBLINE_DESC,
		@vCLASS_DESC,			
		@vSTAT_UNIT_NUMBER,
		@vPOLICY_CVG_SEQNO,		
		@vRESERVE_TYPE,		
		@vNAME_TYPE,			
		@vPOLICY_NUMBER,
		@vPOLICY_SYMBOL,		
		@vMASTER_COMPANY,
		@vLOCATION_COMPANY,
		@vDSTRBN_TYPE_CODE,
		@vPAYEE_DOB,
		@vREGION,
		@vBEN_REVIEW_DATE,
		@vEOB_REMARKS_CODE_1,	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_2,	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_3,	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_4,	--JIRA 24633 knakra
		@vEOB_REMARKS_CODE_5,	--JIRA 24633 knakra
		@vEOB_PRINTED_DATE,
		@vEOB_PRINTED_BY_USER,
		@vUNIT_FIRST_NAME,
		@vUNIT_LAST_NAME,
		@vUNIT_TAX_ID,
		@vUNIT_DOB,
		@vCLMNT_LAST_NAME,
		@vCLMNT_FIRST_NAME,
		@vCLMNT_TAX_ID,
		@vEMP_NUM,
		@vUNIT_ID,
		@vPMT_CURR_CODE,			--JIRA 30818 knarka starts
		@dPMT_TO_BASE_CURR_RATE,
		@dPMT_TO_POL_CURR_RATE,
		@dPMT_TO_CLM_CURR_RATE,
		@dCLM_TO_BASE_CURR_RATE,
		@dCLM_TO_POL_CURR_RATE		--JIRA 20818 knakra ends
		
		SET @iCurrentRow = 1
		WHILE (@iTotalRows >= 1 AND @iCurrentRow <= @iTotalRows)	--CURSOR LOOP STARTING
		BEGIN
			BEGIN TRY
				SET @iCurrentRow = @iCurrentRow + 1				
				SET @iClaimId = 0
				SET @iClaimantEid = 0
				SET @iPayeeTypeCodeId = 0
				SET @iLossCodeId = 0	
				SET @iDisCatCodeId	= 0		
				SET @iResTypeCodeId	= 0	
				SET @iNameType = 0	
				SET @iDistTypeCodeId = 0
				SET @iResSubTypeCodeId = 0	
				SET @iPrefixCodeId = 0
				SET @iSuffCommonCodeId = 0		
				SET @iChkStatCodeId = 0
				SET @iTransTypeCodeId = 0
				SET @iMemoCodeId = 0	
				SET @iLob = 0						
				SET @iRsvBucketMapped = 0
				SET @vErrMsgDesc = NULL
				SET @iClaimantEid = 0
				SET @iUseClaimantTrack = 0
				SET @iPolicyId = 0
				SET @vPolicyLob = NULL
				SET @vPolSysId = NULL
				SET @iUnitId = 0
				SET @iPolUnitRowId = 0
				SET @iPolCvgRowId = 0
				SET @iCvgLossRowId = 0
				SET @vCvgTxt = NULL				
				SET @iCvgCodeId = 0
				SET @iLossCodeMapping = 0				
				SET @iResStatusCodeId = 0
				SET @fChangeAmt = 0.00
				SET @fCurRsvAmt = 0.00
				SET @fPaidTot = 0.00
				SET @fColTot = 0.00
				SET @vParentRsvCode = NULL
				SET @fResBal = 0.00
				SET @fInccurAmt	= 0.00
				SET @iCollInRsvBal = 0
				SET @iColInIncBal = 0
				SET @iPayFlag = 0
				SET @iVoidFlag = 0
				SET @iRcRowId = 0
				SET @iResStatusCode = 0
				SET @iPayeeEid = 0
				SET @vCvgKey = NULL
				SET @vPolKey = NULL
				SET @iLimitFlag	= 0
				SET @dAggAmtOnPol = 0.00
				SET @dOccAmtOnPol = 0.00
				SET @dAggAmtOnCvg = 0.00
				SET @dOccAmtOnCvg = 0.00
				SET @iIsEft = 0
				SET @iDefDistTypeCode = 0
				SET @vDistTypeSCode = NULL
				SET @iPrintedStatus = 0
				SET @iRowId	= 0
				SET @iErrCnt  = 0
				SET @iBaseErr = 0
				SET @iClmntTypePayee = 0
				SET @iPolErr = 0
				SET @vErrColumns = NULL
				SET @vResTypeCode = NULL
				SET @iRsvRowId = 0
				SET @iVehicleId = 0
				SET @iChkClaimant = 0
				SET @iOpenResStatusCode = 0
				SET @iIncSuffix = 0
				SET @iIncPrefix = 0
				SET @vPayToTheOrderOf = NULL
				SET @vResStatus = NULL
				SET @iResSuppPaymentFlag = 0				
				SET @vSysDateTime = NULL
				SET @vCheckStatus = NULL
				SET @iStateRowId = 0
				SET @iColFlag = 0
				SET @iClearedFlag = 0
				SET @iPayeeRowId = 0
				SET @iSplitRowId = 0
				SET @iPolSysId = 0
				SET @dSumAmount = 0.00
				SET @vResCatShortCode = NULL
				SET @vClmLobDb = NULL
				SET @iReBalErrCnt = 0
				SET @vLocation = 0
				SET @iAccountId = 0
				SET @iSubAccId = 0
				SET @iUseSubAcc = 0
				SET @g_iAccountId = 0
				SET @g_iSubAccId = 0
				SET @iTransNumber = 0
				SET @iTransid = 0
				SET @iErrCntSupp = 0
				SET @vRsvTypeSCode = NULL
				SET @iClmTypeCode = 0	--JIRA 23831 knakra
				SET @iFinRowId = 0		--JIRA 23831 knakra
				SET @iEobRemarksCode1 = 0
				SET @iEobRemarksCode2 = 0
				SET @iEobRemarksCode3 = 0
				SET @iEobRemarksCode4 = 0
				SET @iEobRemarksCode5 = 0
				--JIRA 29954 knakra starts
				SET @iPmtCurrCodeId = 0
				SET @iClmCurrCodeId	= 0
				SET @iPolCurrCodeId	= 0
				SET @dClmCurrRsvAmt	= 0
				SET @dClmCurrAmt = 0
				SET @dClmCurrChgAmt	= 0
				SET @dClmCurrPaidTot = 0
				SET @dClmCurrColTot	= 0
				SET @dClmCurrIncAmt	= 0
				SET @dClmCurrBalAmt	= 0
				SET @dPolCurrChgAmt	= 0
				SET @dPmtCurrAmt = 0
				SET @dPmtToPolCurrRate = 1
				SET @dPmtToClmCurrRate = 1
				SET @dPmtToBaseCurrRate	= 1
				SET @dClmToPolCurrRate = 1
				SET @dClmtoBaseCurrRate	= 1
				SET @dBaseCurrAmt = 0
				SET @dBaseCurrRsvAmt = 0
				SET @dBaseCurrPaidTot = 0
				SET @dBaseCurrBalAmt = 0
				SET @dBaseCurrColTot = 0
				SET @dBaseCurrIncAmt = 0
				SET @dPolCurrRsvAmt	= 0
				SET @dPolCurrPaidTot = 0
				SET @dPolCurrBalAmt	= 0
				SET @dPolCurrColTot	= 0
				SET @dPolCurrAmt = 0
				SET @iRsvUpdFlag = 0
				SET @dPolCurrIncAmt	= 0
				SET @iPolLobRelatedCodeId = 0	--akumar523 RMA-63116
				--JIRA 29954 knakra ends

				IF @vCLAIM_ID IS NULL
				BEGIN
					SET	@vErrMsgDesc = 'Claim ID is a required field and can not be left empty, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimId','ClaimId','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1				
					GOTO NEXTRECORD
				END

				IF @vRECORD_TYPE IS NULL
				BEGIN
					SET @vErrMsgDesc = 'Record Type is a required field and can not be left blank, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','RecType','RecType','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RECORD_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1				
					GOTO NEXTRECORD
				END

				--IF @iCarrierFlag <> 0 AND @vRECORD_TYPE NOT IN('W','G')	JIRA 23831 knakra
				IF @iCarrierFlag <> 0 AND @vRECORD_TYPE NOT IN('W','G') AND @iHmiFlag = 0 AND @iVarFinKey = 0	--JIRA 23831 knakra
				BEGIN
					SET @vErrMsgDesc = 'Record Type: ' + @vRECORD_TYPE + ' is not valid, Either enter G or W for Carrier Clients. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','RecordTypeACON','RecordTypeACON','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RECORD_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					GOTO NEXTRECORD
				END

				--IF @iCarrierFlag = 0 AND @vRECORD_TYPE NOT IN('G','W','V','D')	JIRA 23831 knakra
				IF @iCarrierFlag = 0 AND @vRECORD_TYPE NOT IN('G','W','V','D') AND @iHmiFlag = 0 AND @iVarFinKey = 0 --JIRA 23831 knakra
				BEGIN
					SET @vErrMsgDesc = 'Record Type: ' + @vRECORD_TYPE + ' is not valid, G,W,V,D only are allowed for Corporate Clients. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','RecordType','RecordType','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RECORD_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					GOTO NEXTRECORD
				END
				
				--JIRA 23831 knakra starts
				IF (@iVarFinKey <> 0 AND @vRECORD_TYPE NOT IN('G','W','D','V') AND @iHmiFlag = 0) OR (@iHmiFlag = 1 AND @vRECORD_TYPE NOT IN('G','W','D','V','H'))
				BEGIN
					SET @vErrMsgDesc = 'Record Type: ' + @vRECORD_TYPE + ' is not valid, only G, W, V, D and H are allowed. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','RecordTypeVfk','RecordTypeVfk','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RECORD_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					GOTO NEXTRECORD
				END
				--JIRA 23831 knakra ends

				--JIRA 23831 knakra starts(code moved above for financial key)
				--SET @nSql = 'SELECT @pClaimId = CLAIM_ID, @pLob = LINE_OF_BUS_CODE FROM ' + @vDbName + 'CLAIM WHERE CLAIM_NUMBER = @pClaimIdIn'	--JIRA 23831 knakra
				SET @nSql = 'SELECT @pClaimId = CLAIM_ID, @pLob = LINE_OF_BUS_CODE, @pClmTypeCode = CLAIM_TYPE_CODE, @pPolLobCode = POLICY_LOB_CODE'
				SET @nSql += ', @pClmCurrCodeId = CLAIM_CURR_CODE FROM ' + @vDbName + 'CLAIM WHERE CLAIM_NUMBER = @pClaimIdIn'
				
				SET @vLocation = 'ClaimLob'
				EXECUTE SP_EXECUTESQL @nSql,
				N' @pClaimId int OUTPUT, @pLob int OUTPUT, @pClmTypeCode INT OUTPUT, @pPolLobCode INT OUTPUT,@pClmCurrCodeId INT OUTPUT, @pClaimIdIn VARCHAR(25)',
				@pClaimIdIn = @vCLAIM_ID,
				@pClaimId = @iClaimId OUTPUT,
				@pLob = @iLob OUTPUT,
				@pPolLobCode = @iPolLobCode OUTPUT,
				@pClmTypeCode = @iClmTypeCode OUTPUT,
				@pClmCurrCodeId = @iClmCurrCodeId OUTPUT	--JIRA 30818 knakra
			    
				IF @iClaimId IS NULL OR @iClaimId = 0 
				BEGIN
					SET @vErrMsgDesc = 'Claim Number does not exist, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimExists','ClaimExists','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					SET @iErrCnt += 1
					GOTO NEXTRECORD				
				END		--CHECK FOR VALID CLAIM
			
				IF @iLob IS NULL OR @iLob = 0 
				BEGIN
					SET @vErrMsgDesc = 'Claim has Invalid LOB associated with it, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimLob','ClaimLob','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					SET @iErrCnt += 1
					GOTO NEXTRECORD
				END		--CHECK FOR VALID LOB
				--JIRA 23831 knakra ends(code moved above for financial key)

				--JIRA 23831 knakra starts
				IF @iVarFinKey <> 0
				BEGIN
					IF @iFinKeyFilter <> 0 AND (@iPolLobCode = 0 OR @iPolLobCode IS NULL)
					BEGIN
						SET @vErrColumns = 'CLAIM_ID'
						SET @vErrMsgDesc = 'Policy Lob Code is either empty of invalid and financial key is set on POLICY LOB. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PolLobInv','PolLobInv','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,@vErrColumns,'DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
						SET @iErrCnt += 1
						GOTO NEXTRECORD
					END
					ELSE IF @iFinKeyFilter = 0 AND (@iClmTypeCode IS NULL OR @iClmTypeCode = 0)
					BEGIN
						SET @vErrColumns = 'CLAIM_ID'
						SET @vErrMsgDesc = 'Claim Type is either empty or invalid and financial key is set on CLAIM TYPE. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClmTypeInv','ClmTypeInv','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,@vErrColumns,'DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
						SET @iErrCnt += 1
						GOTO NEXTRECORD
					END

					SET @nSql = 'SELECT @pFinRowId = ROW_ID, @pIncClmnt = INC_CLAIMANT, @pIncRsvType = INC_RSVTYPE, @pIncRsvSubType = INC_RSVSUBTYPE, @pIncPolCvg = INC_POL_COVERAGE, @pIncLossType = INC_LOSS_TYPE'
					SET @nSql += ' FROM ' + @vDbName + 'FINANCIAL_KEY WHERE '
					IF @iFinKeyFilter <> 0
						SET @nSql += 'POLICY_LOB = @pPolLobCode'
					ELSE IF @iFinKeyFilter = 0
						SET @nSql += 'CLAIM_TYPE = @pClmTypeCode'
					SET @nSql += ' AND LOB_CODE = @pLob'
					
					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql,
						N'@pFinRowId INT OUTPUT, @pIncClmnt INT OUTPUT, @pIncRsvType INT OUTPUT, @pIncRsvSubType INT OUTPUT, @pIncPolCvg INT OUTPUT, @pIncLossType INT OUTPUT,
						@pPolLobCode INT, @pClmTypeCode INT, @pLob INT',
						@pFinRowId = @iFinRowId OUTPUT,
						@pIncClmnt = @iIncClmnt OUTPUT,
						@pIncRsvType = @iIncRsvType OUTPUT,
						@pIncRsvSubType = @iIncRsvSubType OUTPUT,
						@pIncPolCvg = @iIncPolCvg OUTPUT,
						@pIncLossType = @iIncLossType OUTPUT,
						@pPolLobCode = @iPolLobCode,
						@pClmTypeCode = @iClmTypeCode,
						@pLob = @iLob

						IF @iFinRowId IS NULL OR @iFinRowId = 0
						BEGIN
							EXECUTE SP_EXECUTESQL @nSql,
							N'@pFinRowId INT OUTPUT, @pIncClmnt INT OUTPUT, @pIncRsvType INT OUTPUT, @pIncRsvSubType INT OUTPUT, @pIncPolCvg INT OUTPUT, @pIncLossType INT OUTPUT,
							@pPolLobCode INT, @pClmTypeCode INT, @pLob INT',
							@pFinRowId = @iFinRowId OUTPUT,
							@pIncClmnt = @iIncClmnt OUTPUT,
							@pIncRsvType = @iIncRsvType OUTPUT,
							@pIncRsvSubType = @iIncRsvSubType OUTPUT,
							@pIncPolCvg = @iIncPolCvg OUTPUT,
							@pIncLossType = @iIncLossType OUTPUT,
							@pPolLobCode = -1,
							@pClmTypeCode = -1,
							@pLob = @iLob
						END
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'FinKeyFetch, ' + ERROR_MESSAGE()
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','FinKeyFetch','FinKeyFetch','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH

					IF @iUsePolInterface = 0 AND @iIncPolCvg <> 0
					BEGIN
						SET @vErrMsgDesc = 'External Policy Interface is turned OFF and Policy/Unit/Coverages are included in the Financial Key, Skipping record. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','IncCvgPolInt','IncCvgPolInt','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
						GOTO NEXTRECORD
					END
				END
				--JIRA 23831 kankra ends
				
				--JIRA 30818 knakra starts
				IF @iMcFlag = 0 OR @iMcFlag IS NULL OR @fVersionNum < 16.4
					SET @dBaseCurrAmt = @dInpAmt
				--JIRA 30818 knakra ends

				SET @vReqColumns = 'TRANSACTION_TYPE|ACTIVITY_DATE|AMOUNT|'
				IF @vRESERVE_TYPE IS NULL
					SET @vReqColumns += 'TYPE_FLAG|'
				IF @vTRANSACTION_TYPE IN('P','C')
					--SET @vReqColumns += 'CHECK_NO|CHECK_STATUS|TYPE_CODE|PAYEE_LASTNAME|TRANSACTION_DATE|' --Sdalvi3 Jira 65683
					SET @vReqColumns += 'CHECK_STATUS|TYPE_CODE|PAYEE_LASTNAME|TRANSACTION_DATE|' 
				
				--IF @iCarrierFlag <> 0		JIRA 23831 knakra
				IF (@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey = 1 AND @iIncPolCvg <> 0)	--JIRA 23831 knakra
				BEGIN
					--JIRA 24633 knakra starts
					
					--SET @vReqColumns += 'UNIT_TYPE|POLICY_NAME|UNIT_NUMBER|COVERAGE_CODE|LOSS_CODE|'	
					--SET @vReqColumns += 'MODULE_NO|CLASS_CODE|CVG_SEQUENCE_NO|TRANS_SEQ_NO|CLASS_DESC|'
					--SET @vReqColumns += 'STAT_UNIT_NUMBER|POLICY_CVG_SEQNO|POLICY_NUMBER|POLICY_SYMBOL|'
					--SET @vReqColumns += 'MASTER_COMPANY|LOCATION_COMPANY|'

					SET @vReqColumns += 'UNIT_TYPE|POLICY_NUMBER|MASTER_COMPANY|COVERAGE_CODE|CLASS_CODE|POLICY_CVG_SEQNO|'
					IF @vRECORD_TYPE <> 'H'
					BEGIN
						SET @vReqColumns += 'POLICY_NAME|UNIT_NUMBER|MODULE_NO|CVG_SEQUENCE_NO|TRANS_SEQ_NO|CLASS_DESC|'
						SET @vReqColumns += 'STAT_UNIT_NUMBER|POLICY_SYMBOL|LOCATION_COMPANY|'
					END
					ELSE IF @vRECORD_TYPE = 'H' AND @iHmiFlag = 1
						SET @vReqColumns += 'REGION|'
					IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncLossType <> 0)
						SET @vReqColumns += 'LOSS_CODE|'
					--IF @vRECORD_TYPE <> 'W'
					IF (@vRECORD_TYPE <> 'W' AND @vRECORD_TYPE <> 'H' AND @fVersionNum < 17.3) OR (@fVersionNum >= 17.3 AND @vRECORD_TYPE NOT IN ('W', 'H', 'D'))
						SET @vReqColumns += 'CVG_DESC|' 					
					--IF @vRECORD_TYPE = 'W'	JIRA 23831 knakra
					IF @vRECORD_TYPE = 'W' AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncLossType <> 0))	--JIRA 23831 knakra
						SET @vReqColumns += 'DISABILITY_CATEGORY|'	
				END			
				
				WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
				BEGIN

					SET @iPos = CHARINDEX('|',@vReqColumns,1)
					SET @vColName = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
					SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
				
					SELECT @vVal =( CASE
					WHEN @vColName = 'TRANSACTION_TYPE' THEN CAST(@vTRANSACTION_TYPE AS VARCHAR)				
					WHEN @vColName = 'ACTIVITY_DATE' THEN CAST(@vACTIVITY_DATE AS VARCHAR)
					--WHEN @vColName = 'AMOUNT' THEN CAST(@fAMOUNT AS VARCHAR)	JIRA 30818 knakra
					WHEN @vColName = 'AMOUNT' THEN CAST(@dInpAmt AS VARCHAR)	--JIRA 30818 knakra
					WHEN @vColName = 'UNIT_TYPE' THEN CAST(@vUNIT_TYPE AS VARCHAR)
					WHEN @vColName = 'POLICY_NAME' THEN CAST(@vPOLICY_NAME AS VARCHAR)
					WHEN @vColName = 'UNIT_NUMBER' THEN CAST(@vUNIT_NUMBER AS VARCHAR)
					WHEN @vColName = 'COVERAGE_CODE' THEN CAST(@vCOVERAGE_CODE AS VARCHAR)
					WHEN @vColName = 'LOSS_CODE' THEN CAST(@vLOSS_CODE AS VARCHAR)
					WHEN @vColName = 'MODULE_NO' THEN CAST(@vMODULE_NO AS VARCHAR)
					WHEN @vColName = 'CLASS_CODE' THEN CAST(@vCLASS_CODE AS VARCHAR)
					WHEN @vColName = 'CVG_SEQUENCE_NO' THEN CAST(@vCVG_SEQUENCE_NO AS VARCHAR)
					WHEN @vColName = 'TRANS_SEQ_NO' THEN CAST(@vTRANS_SEQ_NO AS VARCHAR)
					WHEN @vColName = 'CLASS_DESC' THEN CAST(@vCLASS_DESC AS VARCHAR)
					WHEN @vColName = 'STAT_UNIT_NUMBER' THEN CAST(@vSTAT_UNIT_NUMBER AS VARCHAR)
					WHEN @vColName = 'POLICY_CVG_SEQNO' THEN CAST(@vPOLICY_CVG_SEQNO AS VARCHAR)
					WHEN @vColName = 'TYPE_FLAG' THEN CAST(@vTYPE_FLAG AS VARCHAR)
					--WHEN @vColName = 'CHECK_NO' THEN CAST(@vCHECK_NO AS VARCHAR) 'Sdalvi3 Jira 65683
					WHEN @vColName = 'CHECK_STATUS' THEN CAST(@vCHECK_STATUS AS VARCHAR)
					WHEN @vColName = 'TYPE_CODE' THEN CAST(@vTYPE_CODE AS VARCHAR)				
					WHEN @vColName = 'PAYEE_LASTNAME' THEN CAST(@vPAYEE_LASTNAME AS VARCHAR)
					WHEN @vColName = 'TRANSACTION_DATE' THEN CAST(@vTRANSACTION_DATE AS VARCHAR)
					WHEN @vColName = 'POLICY_NUMBER' THEN CAST(@vPOLICY_NUMBER AS VARCHAR)
					WHEN @vColName = 'POLICY_SYMBOL' THEN CAST(@vPOLICY_SYMBOL AS VARCHAR)
					WHEN @vColName = 'MASTER_COMPANY' THEN CAST(@vMASTER_COMPANY AS VARCHAR)
					WHEN @vColName = 'LOCATION_COMPANY' THEN CAST(@vLOCATION_COMPANY AS VARCHAR)
					WHEN @vColName = 'CVG_DESC' THEN CAST(@vCVG_DESC AS VARCHAR)
					WHEN @vColName = 'DISABILITY_CATEGORY' THEN CAST(@vDISABILITY_CATEGORY AS VARCHAR)
					WHEN @vColName = 'REGION' THEN CAST(@vREGION AS VARCHAR)	--JIRA 24633 knakra
					END)				
				
					IF @vVal IS NULL OR @vVal = ''
					BEGIN
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','NullCheck','NullCheck','DDS_PROCESS_PAYMENTS','Required Field is Null or Empty in Import file',@vColName,'DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
						SET @iErrCnt += 1
					END

				END
				--JIRA 23831 knakra starts(moving this code above as this information is required prior to required columns check)
				--SET @nSql = 'SELECT @pClaimId = CLAIM_ID, @pLob = LINE_OF_BUS_CODE FROM ' + @vDbName + 'CLAIM WHERE CLAIM_NUMBER = @pClaimIdIn'
			
				
				--SET @vLocation = 'ClaimLob'
				--EXECUTE SP_EXECUTESQL @nSql,
				--N' @pClaimId int OUTPUT, @pLob int OUTPUT, @pClaimIdIn VARCHAR(25)',
				--@pClaimIdIn = @vCLAIM_ID,
				--@pClaimId = @iClaimId OUTPUT,
				--@pLob = @iLob OUTPUT			
			    
				--IF @iClaimId IS NULL OR @iClaimId = 0 
				--BEGIN
				--	SET @vErrMsgDesc = 'Claim Number does not exist, skipping record. '
				--	EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimExists','ClaimExists','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
				--	SET @iErrCnt += 1
				--	GOTO NEXTRECORD				
				--END		--CHECK FOR VALID CLAIM
			
				--IF @iLob IS NULL OR @iLob = 0 
				--BEGIN
				--	SET @vErrMsgDesc = 'Claim has Invalid LOB associated with it, skipping record. '
				--	EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimLob','ClaimLob','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
				--	SET @iErrCnt += 1
				--	GOTO NEXTRECORD
				--END		--CHECK FOR VALID LOB
				--JIRA 23831 knakra ends(moving this code above as this information is required prior to required columns check)
				
				--JIRA 38951 knakra starts
				IF ISNUMERIC(@vPOLICY_CVG_SEQNO) = 1 AND (@iCarrierFlag <> 0 OR @iFinKeyFilter <> 0)
				BEGIN
					IF CAST(@vPOLICY_CVG_SEQNO AS INT) = 0
						SET @vPOLICY_CVG_SEQNO = '1'
				ELSE
					SET @vPOLICY_CVG_SEQNO = '0'
				END
				--JIRA 38951 knakra ends

				SET @nSql = 'SELECT @pClmLobDb = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pLob'
				SET @vLocation = 'LobConfirm' 
				EXECUTE SP_EXECUTESQL @nSql,
				N' @pClmLobDb VARCHAR(25) OUTPUT, @pLob INT',
				@pLob = @iLob,
				@pClmLobDb = @vClmLobDb OUTPUT
				
				--IF (@vRECORD_TYPE = 'G' AND @vClmLobDb <> 'GC') OR (@vRECORD_TYPE = 'W' AND @vClmLobDb <> 'WC') OR (@vRECORD_TYPE = 'D' AND @vClmLobDb <> 'DI') OR (@vRECORD_TYPE = 'V' AND @vClmLobDb <> 'VA')	--JIRA 24633 knakra
				IF (@vRECORD_TYPE = 'G' AND @vClmLobDb <> 'GC') OR (@vRECORD_TYPE = 'W' AND @vClmLobDb <> 'WC') OR (@vRECORD_TYPE = 'D' AND @vClmLobDb <> 'DI') OR (@vRECORD_TYPE = 'V' AND @vClmLobDb <> 'VA') OR (@vRECORD_TYPE = 'H' AND @vClmLobDb <> 'HC')	--JIRA 24633 knakra
				BEGIN
					SET @vErrMsgDesc = 'Record Type: ' + @vRECORD_TYPE + ' is not valid for Claim LOB: ' + @vClmLobDb + '. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClaimLobChk','ClaimLobChk','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RECORD_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					SET @iErrCnt += 1
					GOTO NEXTRECORD
				END
	
				--IF @iCarrierFlag = 0	--JIRA 23831 knakra
				IF @iCarrierFlag = 0 AND @iVarFinKey = 0	--JIRA 23831 knakra
				BEGIN
					SET @nSql = 'SELECT @pUseClaimantTrack = RESERVE_TRACKING FROM ' + @vDbName + 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = @pLob'
					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pUseClaimantTrack int OUTPUT, @pLob INT',
						@pLob = @iLob,
						@pUseClaimantTrack = @iUseClaimantTrack OUTPUT
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'ResTrack, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResTrack','ResTrack','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				ELSE
					SET @iUseClaimantTrack = 1
				---AKUMAR523 RMA-63197 STARTS 
				--IF UPPER(@vPAYEE_TYPE) = 'E' OR UPPER(@vPAYEE_TYPE) = 'C'
				--	SET @vPAYEE_TYPE = 'C'
				--ELSE IF @vPAYEE_TYPE IS NULL OR @vPAYEE_TYPE = ''
				--	SET @vPAYEE_TYPE = 'O'
				--ELSE 
				---SET @vPAYEE_TYPE = 'O' ----AKUMAR523 RMA-63197
				
				IF UPPER(@vPAYEE_TYPE) = 'E' OR UPPER(@vPAYEE_TYPE) = 'C'
				BEGIN
					SET @vTableNamePayeType = 'EMPLOYEE'
					SET @vPAYEE_TYPE = 'C'
				END
				ELSE IF @vPAYEE_TYPE IS NULL OR @vPAYEE_TYPE = '' OR UPPER(@vPAYEE_TYPE) = 'O'
				BEGIN
				    SET @vTableNamePayeType = 'OTHER_PEOPLE'
					SET @vPAYEE_TYPE = 'O'
				END 	
				ELSE IF UPPER(@vPAYEE_TYPE)= 'P'
				BEGIN
					SET @vTableNamePayeType = 'OTHER_PEOPLE'
				END
				ELSE
				BEGIN
					SET @vTableNamePayeType = @vPAYEE_TYPE
					SET @vPAYEE_TYPE ='O'
			    END
				----AKUMAR523 RMA-63197  ENDS
				
				SET @vCheckStatus = @vCHECK_STATUS 

				IF @vCheckStatus IN('V','M')
					SET @vCheckStatus = 'P'
				
				IF @vCheckStatus='P'--asharma590
				SET  @iReadytoprint = -1
				SET @vCodeField = 'PAYEE_TYPE|DISABILITY_CATEGORY|RESERVE_TYPE|NAME_TYPE|DSTRBN_TYPE_CODE|'
				SET @vCodeField = @vCodeField + 'RESERVE_SUB_TYPE|PREFIX|SUFFIX_COMMON|MEMO_PHRASE|CHECK_STATUS|TYPE_CODE|COVERAGE_CODE|RES_STATUS_CODE|PRINTED_STATUS|CLAIMANT_TYPE_PAYEE|OPEN_RESERVE_STATUS|'
				SET @vCodeField += 'EOB_REMARKS_CODE_1|EOB_REMARKS_CODE_2|EOB_REMARKS_CODE_3|EOB_REMARKS_CODE_4|EOB_REMARKS_CODE_5|'	--JIRA 24633 knakra
				SET @vCodeField += 'PMT_CURR_CODE|MAL_DIST_TYPE|'	--JIRA 30818 knakra
				SET @vSysTableName = 'PAYEE_TYPE|DISABILITY_CATEGORY|RESERVE_TYPE|ENTITY_NAME_TYPE|DISTRIBUTION_TYPE|'
				SET @vSysTableName = @vSysTableName + 'RESERVE_SUB_TYPE|ENTITY_PREFIX|ENTITY_SUFFIX|MEMO_PHRASE|CHECK_STATUS|TRANS_TYPES|COVERAGE_TYPE|RESERVE_STATUS|CHECK_STATUS|PAYEE_TYPE|RESERVE_STATUS|'
				SET @vSysTableName += 'EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|'	--JIRA 24633 knakra
				SET @vSysTableName += 'CURRENCY_TYPE|DISTRIBUTION_TYPE|'	--JIRA 30818 knakra
				
				WHILE CHARINDEX('|',@vCodeField,1) > 0		--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
				BEGIN
					SET @iPos = CHARINDEX('|',@vCodeField,1)
					SET @vColName = LEFT(@vCodeField,CHARINDEX('|',@vCodeField,1) - 1)
					SET @vCodeField = RIGHT(@vCodeField,LEN(@vCodeField) - CHARINDEX('|',@vCodeField,1))
					SET @iPos = CHARINDEX('|',@vSysTableName,1)
					SET @vTableName = LEFT(@vSysTableName,CHARINDEX('|',@vSysTableName,1) - 1)
					SET @vSysTableName = RIGHT(@vSysTableName,LEN(@vSysTableName) - CHARINDEX('|',@vSysTableName,1))								
										
					SET @vVal =( CASE
					WHEN @vColName = 'PAYEE_TYPE' THEN CAST(@vPAYEE_TYPE AS VARCHAR)					
					WHEN @vColName = 'DISABILITY_CATEGORY' THEN CAST(@vDISABILITY_CATEGORY AS VARCHAR)
					WHEN @vColName = 'RESERVE_TYPE' THEN CAST(@vRESERVE_TYPE AS VARCHAR)
					WHEN @vColName = 'NAME_TYPE' THEN CAST(@vNAME_TYPE AS VARCHAR)
					WHEN @vColName = 'DSTRBN_TYPE_CODE' THEN CAST(@vDSTRBN_TYPE_CODE AS VARCHAR)
					WHEN @vColName = 'RESERVE_SUB_TYPE' THEN CAST(@vRESERVE_SUB_TYPE AS VARCHAR)
					WHEN @vColName = 'PREFIX' THEN CAST(@vPREFIX AS VARCHAR)
					WHEN @vColName = 'SUFFIX_COMMON' THEN CAST(@vSUFFIX_COMMON AS VARCHAR)
					WHEN @vColName = 'MEMO_PHRASE' THEN CAST(@vMEMO_PHRASE AS VARCHAR)
					WHEN @vColName = 'CHECK_STATUS'	THEN CAST(@vCheckStatus AS VARCHAR)
					WHEN @vColName = 'TYPE_CODE' THEN CAST(@vTYPE_CODE AS VARCHAR)
					WHEN @vColName = 'COVERAGE_CODE' THEN CAST(@vCOVERAGE_CODE AS VARCHAR)
					WHEN @vColName = 'RES_STATUS_CODE' THEN CAST(@vRES_STATUS_CODE AS VARCHAR)
					WHEN @vColName = 'PRINTED_STATUS' THEN 'P'
					WHEN @vColName = 'CLAIMANT_TYPE_PAYEE' THEN 'C'
					WHEN @vColName = 'OPEN_RESERVE_STATUS' THEN 'O'
					WHEN @vColName = 'EOB_REMARKS_CODE_1' THEN @vEOB_REMARKS_CODE_1	--JIRA 24633 knakra starts
					WHEN @vColName = 'EOB_REMARKS_CODE_2' THEN @vEOB_REMARKS_CODE_2
					WHEN @vColName = 'EOB_REMARKS_CODE_3' THEN @vEOB_REMARKS_CODE_3
					WHEN @vColName = 'EOB_REMARKS_CODE_4' THEN @vEOB_REMARKS_CODE_4
					WHEN @vColName = 'EOB_REMARKS_CODE_5' THEN @vEOB_REMARKS_CODE_5	--JIRA 24633 knakra ends
					WHEN @vColName = 'PMT_CURR_CODE' THEN @vPMT_CURR_CODE			--JIRA 30818 knakra
					WHEN @vColName = 'MAL_DIST_TYPE' THEN 'MAL'
					END)				

					IF @vVal IS NOT NULL AND @vVal <> ''
					BEGIN
						EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,@vVal,@vTableName,@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','CodeValidate','DDS_PROCESS_PAYMENTS','CLAIM_ID',@vColName,'DDS_PAYMENT',@vCLAIM_ID,@iCodeId OUTPUT
						IF (@iCodeId = 0 OR @iCodeId IS NULL)
							SET @iErrCnt += 1
					END
				
					IF @vColName = 'PAYEE_TYPE' SET @iPayeeTypeCodeId = @iCodeId					
					ELSE IF @vColName = 'DISABILITY_CATEGORY' SET @iDisCatCodeId = @iCodeId
					ELSE IF @vColName = 'RESERVE_TYPE' SET @iResTypeCodeId = @iCodeId
					ELSE IF @vColName = 'NAME_TYPE' SET @iNameType = @iCodeId
					ELSE IF @vColName = 'DSTRBN_TYPE_CODE' SET @iDistTypeCodeId = @iCodeId
					ELSE IF @vColName = 'RESERVE_SUB_TYPE' SET @iResSubTypeCodeId = @iCodeId
					ELSE IF @vColName = 'PREFIX' SET @iPrefixCodeId = @iCodeId
					ELSE IF @vColName = 'SUFFIX_COMMON' SET @iSuffCommonCodeId = @iCodeId
					ELSE IF @vColName = 'MEMO_PHRASE' SET @iMemoCodeId = @iCodeId
					ELSE IF @vColName = 'CHECK_STATUS' SET @iChkStatCodeId = @iCodeId
					ELSE IF @vColName = 'TYPE_CODE' SET @iTransTypeCodeId = @iCodeId
					ELSE IF @vColName = 'COVERAGE_CODE' SET @iCvgCodeId = @iCodeId
					ELSE IF @vColName = 'RES_STATUS_CODE' SET @iResStatusCodeId = @iCodeId
					ELSE IF @vColName = 'PRINTED_STATUS' SET @iPrintedStatus = @iCodeId
					ELSE IF @vColName = 'CLAIMANT_TYPE_PAYEE' SET @iClmntTypePayee = @iCodeId
					ELSE IF @vColName = 'OPEN_RESERVE_STATUS' SET @iOpenResStatusCode = @iCodeId
					ELSE IF @vColName = 'EOB_REMARKS_CODE_1' SET @iEobRemarksCode1 = @iCodeId	--JIRA 24633 knakra starts
					ELSE IF @vColName = 'EOB_REMARKS_CODE_2' SET @iEobRemarksCode2 = @iCodeId
					ELSE IF @vColName = 'EOB_REMARKS_CODE_3' SET @iEobRemarksCode3 = @iCodeId
					ELSE IF @vColName = 'EOB_REMARKS_CODE_4' SET @iEobRemarksCode4 = @iCodeId
					ELSE IF @vColName = 'EOB_REMARKS_CODE_5' SET @iEobRemarksCode5 = @iCodeId	--JIRA 24633 knakra ends
					ELSE IF @vColName = 'PMT_CURR_CODE' SET @iPmtCurrCodeId = @iCodeId			--JIRA 30818 knakra
					ELSE IF @vColName = 'MAL_DIST_TYPE' SET @iMalDistTypeCode = @iCodeId
					SET @iCodeId = NULL
				END

				--JIRA 30818 knakra starts
				IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
				BEGIN
					IF (@iClmCurrCodeId IS NULL OR @iClmCurrCodeId = 0)
					BEGIN
						SET @vErrMsgDesc = 'Claim Currency is not set for Claim: ' + @vCLAIM_ID + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClmCurrCode','ClmCurrCode','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
						SET @iErrCnt += 1
					END
					-- commented by 37552 starts-
					--ELSE IF @vTRANSACTION_TYPE IN ('P','C') AND (@vPMT_CURR_CODE IS NULL OR @vPMT_CURR_CODE = '') AND @iClmCurrCodeId IS NOT NULL AND @iClmCurrCodeId > 0
					--SET @iPmtCurrCodeId = @iClmCurrCodeId
					-- commented by 37552 ends-
				END
				--JIRA 30818 knakra ends
				-- JIRA 37552 starts--
				IF @vTRANSACTION_TYPE IN ('P','C') AND (@vPMT_CURR_CODE IS NULL OR @vPMT_CURR_CODE = '') AND @iClmCurrCodeId IS NOT NULL AND @iClmCurrCodeId > 0 AND @fVersionNum >= 16.4
					SET @iPmtCurrCodeId = @iClmCurrCodeId
				-- JIRA 37552 ends--

				--JIRA 23831 knakra starts
				IF @iResSubTypeCodeId = 0 AND @iVarFinKey <> 0 AND @iIncRsvSubType <> 0
				BEGIN
					SET @vErrMsgDesc = 'Reserve Sub Type is either invalid or empty and is included in Financial Key, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','IncRsvSubType','IncRsvSubType','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'RESERVE_SUB_TYPE','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
					GOTO NEXTRECORD
				END
				--JIRA 23831 knakra ends

				SET @vReqColumns = 'ACTIVITY_DATE|TRANSACTION_DATE|SERVICE_FROM_DATE|SERVICE_TO_DATE|DATE_CLEARED|PAYEE_DOB|BEN_REVIEW_DATE|EOB_PRINTED_DATE|UNIT_DOB|'

				WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
				BEGIN					
					SET @vColName = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
					SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))

					SET @nSql = 'SELECT @pVal = ' + @vColName + ' FROM DDS_PAYMENT WHERE JOBID = @pJobId AND DA_ROW_ID = @pDaRowId'
					BEGIN TRY
					EXECUTE SP_EXECUTESQL @nSql,
					N' @pVal VARCHAR(8) OUTPUT, @pJobId INT, @pDaRowId INT',
					@pVal = @vVal OUTPUT,
					@pJobId = @P_JOBID,
					@pDaRowId = @iDA_ROW_ID

					IF @vVal IS NOT NULL
					BEGIN
						IF ISNUMERIC(@vVal) = 0 OR LEN(@vVal) <> 8 OR ISDATE(@vVal) = 0
						BEGIN
							SET @vErrMsgDesc = 'Invalid Date Format: ' + @vVal + ' provided in import file, it should be in YYYYMMDD format. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DateFormat', 'DateFormat', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vColName, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
						ELSE	--JIRA 22275 knakra starts
						BEGIN
							IF @vVal < @vValidStrtDate OR @vVal > @vValidEndDate
							BEGIN
								SET @vErrMsgDesc = 'Date provided: ' + @vVal + ' is out of valid Date Range: ' + @vValidStrtDate + ' - ' + @vValidEndDate + '. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DateRange', 'DateRange', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vColName, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
						END	--JIRA 22275 knakra ends
					END
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'DateFormatErr, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','DateFormatErr','DateFormatErr','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END

				IF @vRESERVE_TYPE IS NULL OR @vRESERVE_TYPE = ''		--FixReserveType IF RESERVE_TYPE IS NOT GIVEN IN IMPORT FILE THROUGH UI RESERVE MAPPING
				BEGIN
					SET @iResTypeCodeId = 0
					SELECT 
					@iResTypeCodeId = RSV_TYPE_CODE
					FROM DDS_USR_DEF_RSV_MAP WHERE LOB_CODE = @iLob AND CONFIG_ID = @oConfigId AND BUCKET = @vTYPE_FLAG AND USERID = @P_UserId 
				END 
			
				IF @iResTypeCodeId IS NULL OR @iResTypeCodeId = 0
				BEGIN
					IF @vRESERVE_TYPE IS NULL
					BEGIN
						SET @vErrMsgDesc = 'Reserve Bucket is not Mapped, Either Map reserve for LOB: ' + @vClmLobDb + ' and Bucket: ' + ISNULL(@vTYPE_FLAG,'') + ' or provide Reserve in RESERVE_TYPE column of import file. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						SET @vErrColumns = 'TYPE_FLAG'
					END
					ELSE
					BEGIN
						SET @vErrMsgDesc = 'Invalid Reserve Type: ' + @vRESERVE_TYPE + ' provided in import file. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						SET @vErrColumns = 'RESERVE_TYPE'
					END
					
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResMap', 'ResMap', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
				
					SET @iErrCnt += 1
					GOTO NEXTRECORD
				END
				ELSE
				BEGIN

					SET @nSql = 'SELECT @pRsvTypeSCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pRsvTypeCodeId'

					EXECUTE SP_EXECUTESQL @nSql,
					N'@pRsvTypeSCode VARCHAR(25) OUTPUT, @pRsvTypeCodeId INT',
					@pRsvTypeCodeId = @iResTypeCodeId,
					@pRsvTypeSCode = @vRsvTypeSCode OUTPUT

					SET @nSql = 'SELECT @pParentRsv = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = ('
					SET @nSql = @nSql + 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pResTypeCodeId)'
					
					SET @vLocation = 'ParentRsv'
							
					EXECUTE SP_EXECUTESQL @nSql,
					N' @pParentRsv varchar(25) OUTPUT, @pResTypeCodeId INT',
					@pResTypeCodeId = @iResTypeCodeId,
					@pParentRsv = @vParentRsvCode OUTPUT

					IF @vParentRsvCode IS NULL OR @vParentRsvCode = ''
					BEGIN
						SET @vErrMsgDesc = 'Invalid Reserve Type: ' + @vRsvTypeSCode + ', as it does not belong to any Master Reserve. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResMap', 'ResMap', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'RESERVE_TYPE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
						GOTO NEXTRECORD
					END
					ELSE
					BEGIN
						IF @vParentRsvCode = 'R' AND @vTRANSACTION_TYPE = 'P'	--For recovery reserves, only Collection and Reserves are allowed and no Payment is allowed
						BEGIN
							SET @vErrMsgDesc = 'Payments are not allowed on Recovery Reserve: ' + @vRsvTypeSCode + '. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							SET @vErrColumns = 'TRANSACTION_TYPE'
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResMap', 'ResMap', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END

				END
				
				--JIRA 34797 kkaur25 starts
				SET @nSql = 'SELECT @pEventDate = DATE_OF_EVENT FROM ' + @vDbName + 'EVENT E INNER JOIN ' + @vDbName + 'CLAIM C ON E.EVENT_ID = C.EVENT_ID WHERE C.CLAIM_ID = @pClaimid'
				BEGIN TRY
					SET @vLocation = 'ErrEvntDate'

					EXECUTE SP_EXECUTESQL @nSql,
					N'@pEventDate VARCHAR(8) OUTPUT, @pClaimId INT',
					@pClaimId = @iClaimId,
					@pEventDate = @vEventDate OUTPUT

					IF @vEventDate > @vTRANSACTION_DATE
					BEGIN
						SET @vErrMsgDesc = 'Transaction Date cannot be prior to Event Date.'
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						SET @vErrColumns = 'TRANSACTION_DATE'

						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'EventDate', 'EventDate', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
					END
				END TRY
				BEGIN CATCH
					SET @vErrMsgDesc = 'EvntDateErr, ' + ERROR_MESSAGE() + '. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
					SET @iErrCnt += 1
				END CATCH
				--JIRA 34797 kkaur25 ends

				SET @iClaimantEid = 0
				SET @iVehicleId = 0
				SET @iChkClaimant = 1

				--IF @vUNIT_ID IS NOT NULL AND @vUNIT_ID <> '' AND @vRECORD_TYPE = 'V' AND @iUseClaimantTrack <> 0	JIRA 23831 knakra
				IF @vUNIT_ID IS NOT NULL AND @vUNIT_ID <> '' AND @vRECORD_TYPE = 'V' AND @iUseClaimantTrack <> 0 AND @iVarFinKey = 0	--JIRA 23831 knakra
				BEGIN
				
					SET @iChkClaimant = 0
					SET @nSql = 'SELECT @pVehicleId = UC.UNIT_ID FROM ' + @vDbName + ' VEHICLE V, ' + @vDbName + 'UNIT_X_CLAIM UC'
					SET @nSql += ' WHERE V.UNIT_ID = UC.UNIT_ID AND UC.CLAIM_ID = @pClaimId AND V.VIN = @pUnitId'
					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pClaimId INT, @pUnitId VARCHAR(20), @pVehicleId INT OUTPUT',
						@pClaimId = @iClaimId,
						@pUnitId = @vUNIT_ID,
						@pVehicleId = @iVehicleId OUTPUT

						IF @iVehicleId IS NULL OR @iVehicleId = 0
						BEGIN
							SET @vErrColumns = 'UNIT_ID'
							SET @vErrMsgDesc = 'VIN: ' + @vUNIT_ID + ' is not attached to claim: ' + @vCLAIM_ID + '. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VehClaim', 'VehClaim', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'Vehicle, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','Vehicle','Vehicle','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END

				--IF @iPayeeTypeCodeId = @iClmntTypePayee AND @vTRANSACTION_TYPE IN('P','C')	JIRA 23831 knakra
				IF @iPayeeTypeCodeId = @iClmntTypePayee AND @vTRANSACTION_TYPE IN('P','C') AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0))	--JIRA 23831 knakra
					SET @iChkClaimant = 1

				SET @iClmntErr = 0	--JIRA 22276 knakra

				--IF (@iUseClaimantTrack = 1 OR @vRECORD_TYPE IN('W','D')) AND @iChkClaimant = 1	JIRA 23831 knakra
				IF ((@iUseClaimantTrack = 1 OR @vRECORD_TYPE IN('W','D')) AND @iChkClaimant = 1 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0)
				BEGIN
					IF @vRECORD_TYPE IN('W','D')		--FETCH CLAIMANT EID FOR THE GIVEN CLAIM BASED ON LOB AND OPTIONS SELECTED ON UI
					BEGIN
						SET @nSql = 'SELECT @pClaimantEid = CLAIMANT_EID FROM ' + @vDbName + 'CLAIMANT CL, ' + @vDbName + 'CLAIM C WHERE '
						SET @nSql = @nSql + 'C.CLAIM_ID = CL.CLAIM_ID AND C.CLAIM_ID = @pClaimId'
					END
					--ELSE IF @vRECORD_TYPE IN('G','V')	JIRA 24633 knakra
					ELSE IF @vRECORD_TYPE IN('G','V','H')	--JIRA 24633 knakra
					BEGIN
						IF @oMatchClmntBySuffix <> 0
						BEGIN
							IF @iCLAIMANT_SUFFIX IS NULL
							BEGIN
								SET @vErrMsgDesc = 'CLAIMANT_SUFFIX is left blank in import file and Match By Claimant Suffix option is selected. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClmntSuffixNull', 'ClmntSuffixNull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLAIMANT_SUFFIX', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
								SET @iClmntErr = 1
							END
							ELSE
							BEGIN
								SET @nSql = 'SELECT @pClaimantEid = CLAIMANT_EID FROM ' + @vDbName + 'CLAIMANT CL, ' + @vDbName + 'CLAIM C WHERE '
								SET @nSql = @nSql + 'C.CLAIM_ID = CL.CLAIM_ID AND CLAIMANT_NUMBER = @pClaimantSuffix AND C.CLAIM_ID = @pClaimId'
							END
						END
						ELSE
						BEGIN
							SET @iClmntErr = 0
							IF @vCLMNT_TAX_ID IS NOT NULL AND @vCLMNT_TAX_ID <> ''
							BEGIN
								IF ISNUMERIC(REPLACE(@vCLMNT_TAX_ID,'-','')) = 1
								BEGIN
									IF LEN(REPLACE(@vCLMNT_TAX_ID,'-','')) = 9
									BEGIN
										IF LEN(@vCLMNT_TAX_ID) - LEN(REPLACE(@vCLMNT_TAX_ID,'-','')) = 1
										BEGIN
											IF CHARINDEX('-', @vCLMNT_TAX_ID, 1) <> 3
											BEGIN
												SET @iClmntErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@vCLMNT_TAX_ID) - LEN(REPLACE(@vCLMNT_TAX_ID,'-','')) = 2
										BEGIN
											IF CHARINDEX('-', @vCLMNT_TAX_ID, 1) = 4 AND (CHARINDEX('-', @vCLMNT_TAX_ID, 5) IN (7,8))
											BEGIN
												SET @iClmntErr = 0
											END
											ELSE
											BEGIN
												SET @iClmntErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@vCLMNT_TAX_ID) - LEN(REPLACE(@vCLMNT_TAX_ID,'-','')) = 0
										BEGIN
											SET @iClmntErr = 0
										END
										ELSE
										BEGIN
											SET @iClmntErr = 1
											SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
										END
									END
									ELSE
									BEGIN
										SET @iClmntErr = 1
										SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
									END
								END
								ELSE
								BEGIN
									SET @iClmntErr = 1
									SET @vErrMsgDesc = 'Tax-Id provided for Claimant is not in Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
								END
							END

							IF @iClmntErr = 1
							BEGIN
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClmntTid', 'ClmntTid', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLMNT_TAX_ID', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END

							IF @vCLMNT_LAST_NAME IS NOT NULL
							BEGIN
								SET @nSql = 'SELECT @pClaimantEid = CLAIMANT_EID FROM ' + @vDbName + 'CLAIMANT CL, ' + @vDbName + 'CLAIM C, ' + @vDbName + 'ENTITY E '
								SET @nSql = @nSql + ' WHERE C.CLAIM_ID = CL.CLAIM_ID AND CL.CLAIMANT_EID = E.ENTITY_ID AND E.LAST_NAME = @pClmntLastName'
								IF @vCLMNT_FIRST_NAME IS NOT NULL AND @vCLMNT_FIRST_NAME <> ''
									SET @nSql = @nSql + ' AND E.FIRST_NAME = @pClmntFirstName'
								IF @vCLMNT_TAX_ID IS NOT NULL AND @vCLMNT_TAX_ID <> ''
									SET @nSql = @nSql + ' AND REPLACE(E.TAX_ID,''-'','''') = ''' + REPLACE(@vCLMNT_TAX_ID,'-','') + ''''
								SET @nSql = @nSql + ' AND C.CLAIM_ID = @pClaimId'
							END
							ELSE
							BEGIN
								SET @iClmntErr = 1
								SET @vErrMsgDesc = 'CLAIMANT_LAST_NAME is left blank in import file and Match By Claimant Name option is selected. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClmntNameNull', 'ClmntNameNull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLMNT_LAST_NAME', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
						END
					END
									
					BEGIN TRY
						--IF @vRECORD_TYPE IN('G','W','V','D') AND @iClmntErr = 0	JIRA 24633 knakra
						IF @vRECORD_TYPE IN('G','W','V','D','H') AND @iClmntErr = 0	--JIRA 24633 knakra
						BEGIN
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pClaimantEid int OUTPUT, @pClaimId INT, @pClmntLastName VARCHAR(255), @pClmntFirstName VARCHAR(255), @pClaimantSuffix INT',
							@pClaimId = @iClaimId,
							@pClmntLastName = @vCLMNT_LAST_NAME,
							@pClmntFirstName = @vCLMNT_FIRST_NAME,
							@pClaimantSuffix = @iCLAIMANT_SUFFIX,
							@pClaimantEid = @iClaimantEid OUTPUT
																					
							--IF (@iClaimantEid IS NULL OR @iClaimantEid = 0) AND (@iCarrierFlag <> 0 OR (@iCarrierFlag = 0 AND (@vRECORD_TYPE IN('W','D') OR @iUseClaimantTrack = 1) AND @iChkClaimant = 1))	--JIRA 24633 knakra
							IF (@iClaimantEid IS NULL OR @iClaimantEid = 0) AND (((@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iCarrierFlag = 0 AND @iVarFinKey = 0 AND (@vRECORD_TYPE IN('W','D') OR @iUseClaimantTrack = 1) AND @iChkClaimant = 1)) OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0))		--JIRA 24633 knakra
							BEGIN
								IF @iCLAIMANT_SUFFIX IS NOT NULL
									SET @vErrColumns = 'CLAIMANT_SUFFIX'
								SET @vErrColumns = ''	--JIRA 23831 knakra
								SET @vErrMsgDesc = 'Claimant with Claimant Suffix: ' + CAST(ISNULL(@iCLAIMANT_SUFFIX,'') AS VARCHAR)
								IF @vCLMNT_LAST_NAME IS NOT NULL
								BEGIN
									SET @vErrColumns = @vErrColumns + ',CLMNT_LAST_NAME'
									SET @vErrMsgDesc = @vErrMsgDesc + ', LAST_NAME: ' + @vCLMNT_LAST_NAME
								END
								IF @vCLMNT_FIRST_NAME IS NOT NULL
								BEGIN
									SET @vErrColumns = @vErrColumns + ',CLMNT_FIRST_NAME'
									SET @vErrMsgDesc = @vErrMsgDesc + ', FIRST_NAME: ' + @vCLMNT_FIRST_NAME
								END
								IF @vCLMNT_TAX_ID IS NOT NULL
								BEGIN
									SET @vErrColumns = @vErrColumns + ',CLMNT_TAX_ID'
									SET @vErrMsgDesc = @vErrMsgDesc + ', TAX_ID: ' + @vCLMNT_TAX_ID
								END
								SET @vErrMsgDesc = @vErrMsgDesc + ' is not attached to the Claim with Claim Number: ' + @vCLAIM_ID + '. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								IF LEFT(@vErrColumns,1) = ','
									SET @vErrColumns = RIGHT(@vErrColumns,LEN(@vErrColumns) - CHARINDEX(',',@vErrColumns,1))
									
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClmntClmAttach', 'ClmntClmAttach', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
											
						END
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'ClmntFetch, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ClmntFetch','ClmntFetch','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				
				IF @vTRANSACTION_TYPE IN('P','C')
				BEGIN
					IF @iPayeeTypeCodeId = @iClmntTypePayee AND @iClaimantEid IS NOT NULL AND @iClaimantEid > 0		--Payee is of Claimant Type			
					BEGIN
						SET @iPayeeEid = @iClaimantEid
						SET @iEntId = 0
						SET @nSql = 'SELECT @pEntId = ENTITY_ID FROM ' + @vDbName + 'ENTITY WHERE LAST_NAME = @pLastName'
						SET @nSql += ' AND FIRST_NAME = @pFirstName'

						IF @vPAYEE_TAX_ID_NO IS NOT NULL						
							SET @nSql += ' AND REPLACE(TAX_ID,''-'','''') = ' + REPLACE(@vPAYEE_TAX_ID_NO,'-','')						

						SET @nSql += ' AND ENTITY_ID = @pEntIdIn'
						
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pEntId INT OUTPUT, @pLastName VARCHAR(255), @pFirstName VARCHAR(255), @pEntIdIn INT',
						@pEntId = @iEntId OUTPUT,
						@pLastName = @vPAYEE_LASTNAME,
						@pFirstName = @vPAYEE_FIRSTNAME,
						@pEntIdIn = @iClaimantEid

						IF @iEntId = 0 OR @iEntId IS NULL
						BEGIN
							SET @vErrMsgDesc = 'Payee is of Claimant Type but information provided for Payee is different from Claimant information. '
							SET @vErrColumns = 'PAYEE_LASTNAME, PAYEE_FIRSTNAME, PAYEE_TAX_ID_NO'
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClmntTypePayee', 'ClmntTypePayee', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END

					END
					ELSE
					BEGIN
						SET @iPayeeEid = 0
						SET @iPayeeErr = 0
						IF @vPAYEE_LASTNAME IS NOT NULL
						BEGIN
							IF @vPAYEE_STATE IS NOT NULL
							BEGIN
								SET @nSql = 'SELECT @pStateRowId = STATE_ROW_ID FROM ' + @vDbName + 'STATES WHERE STATE_ID = @pStateid'
								BEGIN TRY
									EXECUTE SP_EXECUTESQL @nSql,
									N' @pStateRowId INT OUTPUT, @pStateId VARCHAR(25)',
									@pStateId = @vPAYEE_STATE,
									@pStateRowId = @iStateRowId OUTPUT
																
									IF @iStateRowId IS NULL OR @iStateRowId = 0
									BEGIN
										SET @vErrColumns = 'PAYEE_STATE'
										SET @vErrMsgDesc = 'Invalid State: ' + @vPAYEE_STATE + ' provided in import file. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'StateRowId', 'StateRowId', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
										SET @iPayeeErr = 1
									END
								END TRY
								BEGIN CATCH
									SET @vErrMsgDesc = 'StateId, ' + ERROR_MESSAGE() + '. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','StateId','StateId','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
									SET @iErrCnt += 1
									SET @iPayeeErr = 1
								END CATCH
							END
							
							IF @vPAYEE_TAX_ID_NO IS NOT NULL AND @vPAYEE_TAX_ID_NO <> ''
							BEGIN
								IF ISNUMERIC(REPLACE(@vPAYEE_TAX_ID_NO,'-','')) = 1
								BEGIN
									IF LEN(REPLACE(@vPAYEE_TAX_ID_NO,'-','')) = 9
									BEGIN
										IF LEN(@vPAYEE_TAX_ID_NO) - LEN(REPLACE(@vPAYEE_TAX_ID_NO,'-','')) = 1
										BEGIN
											IF CHARINDEX('-', @vPAYEE_TAX_ID_NO, 1) <> 3
											BEGIN
												SET @iPayeeErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@vPAYEE_TAX_ID_NO) - LEN(REPLACE(@vPAYEE_TAX_ID_NO,'-','')) = 2
										BEGIN
											IF CHARINDEX('-', @vPAYEE_TAX_ID_NO, 1) = 4 AND (CHARINDEX('-', @vPAYEE_TAX_ID_NO, 5) IN (7,8))
											BEGIN
												SET @iPayeeErr = 0
											END
											ELSE
											BEGIN
												SET @iPayeeErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@vPAYEE_TAX_ID_NO) - LEN(REPLACE(@vPAYEE_TAX_ID_NO,'-','')) = 0
										BEGIN
											SET @iPayeeErr = 0
										END
										ELSE
										BEGIN
											SET @iPayeeErr = 1
											SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
										END
									END
									ELSE
									BEGIN
										SET @iPayeeErr = 1
										SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
									END
								END
								ELSE
								BEGIN
									SET @iPayeeErr = 1
									SET @vErrMsgDesc = 'Tax-Id provided for Claimant is not in Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
								END
							END

							IF @iPayeeErr = 1
							BEGIN
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PayeeTid', 'PayeeTid', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'PAYEE_TAX_ID_NO', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END

							IF @iPayeeErr = 0
							BEGIN
							----AKUMAR523 STARTS RMA-63197
							---THIS FUNCTIONALITY MOVE TO ABOVE WE CAN FIND OUT THE TABLE NAME ON THE WHILE  FETICHING THE  PAYEE TYPE 
								----AKUMAR523 STARTS RMA-63197
								---IF UPPER(@vPAYEE_TYPE) <> 'E' AND UPPER(@vPAYEE_TYPE) <> 'C' AND UPPER(@vPAYEE_TYPE) <> 'P' AND UPPER(@vPAYEE_TYPE) <> 'O'
								---IF @vPAYEE_TYPE_TEST IS NOT NULL AND @vPAYEE_TYPE_TEST <> ''
								---	SET @vTableName = UPPER(@vPAYEE_TYPE_TEST)
								---ELSE IF @vPAYEE_TYPE = 'C'	
								---	SET @vTableName = 'EMPLOYEE'
								---ELSE
								---	SET @vTableName = 'OTHER_PEOPLE'
								SET @vTableName= @vTableNamePayeType
								SET @vErrMsgDesc = ''
								INSERT INTO @utPayee(iJobId, iDaRowId, vLastName, vFirstName, vMiddleName, vAbbr, vTaxId, vAddr1, vAddr2, vCity, vCountry, vState, vCounty, vZip, vPhone1, vPhone2, vFaxNumber, vBirthDate, vSexCode, vComment, iParentEid, vTableName, iRpt1099Flag, iPrefixCodeId, iSuffixCodeId, vSuffixLegal, iNameType, vEmpNum)
								VALUES(@P_JOBID, @iDA_ROW_ID, @vPAYEE_LASTNAME, @vPAYEE_FIRSTNAME, NULL, NULL,@vPAYEE_TAX_ID_NO, @vPAYEE_ADDRESS, @vPAYEE_ADDRESS2, @vPAYEE_CITY, NULL, @iStateRowId, NULL, @vPAYEE_ZIP, NULL, NULL, NULL, @vPAYEE_DOB, NULL, NULL, 0, @vTableName, 0, @iPrefixCodeId, @iSuffCommonCodeId, @vSUFFIX_LEGAL, @iNameType, @vEMP_NUM)					
								EXECUTE PROCESS_ENTITY @utPayee, @P_JOBID, @iDA_ROW_ID, @vDbName, 'PAYMENT', 0, 1, 'ERRLOC', @vCLAIM_ID, @iPayeeEid OUTPUT, @vErrMsgDesc OUTPUT,1
								IF @vErrMsgDesc <> ''
								BEGIN
									SET @vErrColumns=''  ----akumar523 RMA-63313
									IF @vTableName = 'EMPLOYEE'
									BEGIN
										IF @oEmpMatchByEmpNum <> 0
											SET @vErrColumns = 'EMP_NUM'
										IF @oEmpMatchByName <> 0
											SET @vErrColumns += ',PAYEE_LASTNAME,PAYEE_FIRSTNAME'
										IF @oEmpMatchByTaxId <> 0
											SET @vErrColumns += ',PAYEE_TAX_ID_NO'
										IF @oEmpMatchByDob <> 0
											SET @vErrColumns += ',PAYEE_DOB'
									END
									ELSE
									BEGIN
										IF @oNonEmpMatchByName <> 0
											SET @vErrColumns = 'PAYEE_LASTNAME,PAYEE_FIRSTNAME'
										IF @oNonEmpMatchByTaxId <> 0
											SET @vErrColumns += ',PAYEE_TAX_ID_NO'
										IF @oNonEmpMatchByDob <> 0
											SET @vErrColumns += ',PAYEE_DOB'
									END
								
									SET @vErrColumns = RIGHT(@vErrColumns,LEN(@vErrColumns) - CHARINDEX(',',@vErrColumns,1))

									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ProcessEnt', 'ProcessEnt', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END
							END
						END
					END
					--JIRA 43536 knakra starts
					IF @vPAYEE_TYPE = 'P' AND @iPayeeErr = 0
					BEGIN
						SET @nSql = 'SELECT @pRetVal = E.ENTITY_ID FROM ' + @vDbName + 'ENTITY E INNER JOIN ' + @vDbName + 'PERSON_INVOLVED PI'
						SET @nSql += ' ON PI.PI_EID = E.ENTITY_ID INNER JOIN ' + @vDbName + 'EVENT EV ON EV.EVENT_ID = PI.EVENT_ID INNER JOIN ' + @vDbName + 'CLAIM C'
						SET @nSql += ' ON C.EVENT_ID = EV.EVENT_ID WHERE C.CLAIM_ID = @pClaimId'
						IF @oNonEmpMatchByName <> 0
						BEGIN
							SET @nSql += ' AND E.LAST_NAME = @pLastName'
							IF @vPAYEE_FIRSTNAME IS NOT NULL
								SET @nSql += ' AND E.FIRST_NAME = @pFirstName'
						END
						IF @oNonEmpMatchByTaxId <> 0
							SET @nSql += ' AND E.TAX_ID = @pTaxId'
						IF @oNonEmpMatchByDob <> 0
							SET @nSql += ' AND E.BIRTH_DATE = @pBirthDate'

						SET @iRetVal = 0
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @nSql,
							N'@pRetVal INT OUTPUT, @pClaimId INT, @pLastName VARCHAR(255), @pFirstName VARCHAR(255),
							@pTaxId VARCHAR(20), @pBirthDate VARCHAR(8)',
							@pClaimId = @iClaimId,
							@pLastName = @vPAYEE_LASTNAME,
							@pFirstName = @vPAYEE_FIRSTNAME,
							@pTaxId = @vPAYEE_TAX_ID_NO,
							@pBirthDate = @vPAYEE_DOB,
							@pRetVal = @iRetVal OUTPUT

							IF @iRetVal IS NULL OR @iRetVal = 0
							BEGIN
								SET @vErrColumns = ''
								IF @oNonEmpMatchByName <> 0
									SET @vErrColumns = 'PAYEE_LASTNAME,PAYEE_FIRSTNAME'
								IF @oNonEmpMatchByTaxId <> 0
									SET @vErrColumns += ',PAYEE_TAX_ID_NO'
								IF @oNonEmpMatchByDob <> 0
									SET @vErrColumns += ',PAYEE_DOB'

								IF LEFT(@vErrColumns, 1) = ','
									SET @vErrColumns = SUBSTRING(@vErrColumns, 2, LEN(@vErrColumns) - 1)
								
								SET @vErrMsgDesc = 'Payee Type Code is ''Person Involved'' and no PI attached to the Claim with the provided Payee Information. '

								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PayeeNotPI', 'PayeeNotPI', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
								SET @iPayeeErr = 1
							END
							ELSE
								SET @iPayeeEid = @iRetVal
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = 'PayeeNotPI, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PayeeNotPI','PayeeNotPI','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
							SET @iPayeeErr = 1
						END CATCH
					END
					--JIRA 43536 knakra ends
				END
				
				--IF @iUseClaimantTrack = 0 AND @vRECORD_TYPE IN('G','V')	--CLAIMANT_EID WILL BE 0 IF CLAIMANT TRACKING IS OFF FOR GC OR VC IN CORPORATE	JIRA 23831 knakra
				IF @iUseClaimantTrack = 0 AND @vRECORD_TYPE IN('G','V') AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncClmnt = 0))	--CLAIMANT_EID WILL BE 0 IF CLAIMANT TRACKING IS OFF FOR GC OR VC IN CORPORATE	JIRA 23831 knakra
				BEGIN	
					SET @iClaimantEid = 0
					SET @iVehicleId = 0
				END

				--JIRA 24023 knakra starts
				IF @vTRANSACTION_TYPE IN ('R','P','C') AND @iResTypeCodeId IS NOT NULL AND @iResTypeCodeId <> 0
				BEGIN
					SET @iCodeId = NULL
					
					SET @nSql = 'SELECT @pRsvTypeCode = RESERVE_TYPE_CODE FROM ' + @vDbName + 'SYS_LOB_RESERVES WHERE LINE_OF_BUS_CODE = @pLob'
					SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCode'

					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql,
						N'@pRsvTypeCode INT OUTPUT, @pLob INT, @pResTypeCode INT',
						@pRsvTypeCode = @iCodeId OUTPUT,
						@pLob = @iLob,
						@pResTypeCode = @iResTypeCodeId

						IF @iCodeId = 0 OR @iCodeId IS NULL
						BEGIN
							SET @vErrMsgDesc = 'Reserve Type: ' + ISNULL(@vResTypeCode,'') + ', is not mapped with Line Of Business: ' + ISNULL(@vRECORD_TYPE,'')
							SET @vErrMsgDesc += ', Its mapping needs to be created from UI in Line of Business Parameter Setup. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							IF @vRESERVE_TYPE IS NULL
								SET @vErrColumns = 'TYPE_FLAG'
							ELSE
								SET @vErrColumns = 'RESERVE_TYPE'
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResLobRType', 'ResLobRType', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'ResLobRType' +', ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResLobRType','ResLobRType','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				--JIRA 24023 knakra ends

				--PAYMENTS SPECIFIC VALIDATIONS STARTS
				IF @vTRANSACTION_TYPE IN('P','C') AND @iTransTypeCodeId IS NOT NULL AND @iTransTypeCodeId > 0 AND @iResTypeCodeId IS NOT NULL AND @iResTypeCodeId > 0
				BEGIN
					--check if the transaction is the child of reserve starts
					SET @iCodeId = NULL
					
					SET @nSql = 'SELECT @pCodeId = CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pTransTypeCodeId'
					SET @nSql = @nSql + ' AND RELATED_CODE_ID = @pResTypeCodeId'
				
					BEGIN TRY
						SET @vLocation = 'ResTransErr'
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pCodeId INT OUTPUT, @pTransTypeCodeId INT, @pResTypeCodeId INT',
						@pTransTypeCodeId = @iTransTypeCodeId,
						@pResTypeCodeId = @iResTypeCodeId,
						@pCodeId = @iCodeId OUTPUT										
						
						SET @vLocation = 'ResScode'
						SET @nSql = 'SELECT @pShortCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pResTypeCodeId'
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pResTypeCodeId INT, @pShortCode VARCHAR(25) OUTPUT',
						@pResTypeCodeId = @iResTypeCodeId,
						@pShortCode = @vResTypeCode OUTPUT

						IF @iCodeId = 0 OR @iCodeId IS NULL
						BEGIN						
							SET @vErrMsgDesc = 'Transaction Type: ' + @vTYPE_CODE + ' is invalid for reserve type: ' + @vResTypeCode + '. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResTrans', 'ResTrans', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
						--JIRA 24023 knakra starts(making it common for reserves, payments and collections)
						--ELSE IF @iCodeId <> 0 AND @iCodeId IS NOT NULL	--knakra lob reserve starts
						--BEGIN
						--	SET @nSql = 'SELECT @pRsvTypeCode = RESERVE_TYPE_CODE FROM ' + @vDbName + 'SYS_LOB_RESERVES WHERE LINE_OF_BUS_CODE = @pLob'
						--	SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCode'

						--	EXECUTE SP_EXECUTESQL @nSql,
						--	N'@pRsvTypeCode INT OUTPUT, @pLob INT, @pResTypeCode INT',
						--	@pRsvTypeCode = @iCodeId OUTPUT,
						--	@pLob = @iLob,
						--	@pResTypeCode = @iResTypeCodeId

						--	IF @iCodeId = 0 OR @iCodeId IS NULL
						--	BEGIN
						--		SET @vErrMsgDesc = 'Reserve Type: ' + @vResTypeCode + ', is not mapped with Line Of Business: ' + ISNULL(@vRECORD_TYPE,'')
						--		SET @vErrMsgDesc += ', Its mapping needs to be created from UI in Line of Business Parameter Setup. '
						--		IF @vRESERVE_TYPE IS NULL
						--			SET @vErrColumns = 'TYPE_FLAG'
						--		ELSE
						--			SET @vErrColumns = 'RESERVE_TYPE'
						--		EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResLob', 'ResLob', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						--		SET @iErrCnt += 1
						--	END	--knakra lob reserve ends
						--END
						--JIRA 24023 knakra ends(making it common for reserves, payments and collections)
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = @vLocation +', ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
					--check if the transaction is the child of reserve ends
				
					--****BANK ACCOUNT VALIDATION STARTS****
					--if Bank account number from csv is not empty, then find matched bank account ID 
					SET @iAccountId=0;
					IF @vBANK_ACCOUNT_NUM IS NOT NULL
					BEGIN
						SET @nSql = 'SELECT @P_ACCOUNT_ID = ACCOUNT_ID FROM ' + @vDbName +'ACCOUNT WHERE ACCOUNT_NUMBER = @P_BANK_ACCOUNT_NUM';
					
						BEGIN TRY
							Exec sp_Executesql @nSql,
							N'@P_ACCOUNT_ID INT OUTPUT,
							@P_BANK_ACCOUNT_NUM VARCHAR(20)',
							@P_ACCOUNT_ID = @iAccountId OUTPUT,
							@P_BANK_ACCOUNT_NUM = @vBANK_ACCOUNT_NUM;
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = 'AccId, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','AccId','AccId','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END
								
					--using sub_acc_number alone, can't determine the unique sub_row_id, account_id is also needed.
					--if Bank Sub account number from csv is not empty, then find matched bank sub account ID 
					BEGIN TRY
						SET @iSubAccId=0;
						IF @vBANK_SUB_ACCNT_NUM IS NOT NULL
						BEGIN					
							SET @nSql = 'SELECT @P_SUB_ROW_ID = SUB_ROW_ID FROM ' + @vDbName +'BANK_ACC_SUB WHERE SUB_ACC_NUMBER = @P_SUB_ACC_NUMBER AND'; 
							SET @nSql =	@nSql+' ACCOUNT_ID=@P2_ACCOUNT_ID';
							SET @vLocation = 'SubAccId'
							Exec sp_Executesql @nSql,
							N'@P_SUB_ROW_ID INT OUTPUT,
							@P_SUB_ACC_NUMBER VARCHAR(20),
							@P2_ACCOUNT_ID INT',
							@P_SUB_ROW_ID = @iSubAccId OUTPUT,
							@P_SUB_ACC_NUMBER=@vBANK_SUB_ACCNT_NUM,
							@P2_ACCOUNT_ID = @iAccountId;					
						END
					
						--Fetch the value of USE_SUB_ACCOUNT from SYS_PARMS
				
						SET @nSql = 'SELECT @P_USE_SUB_ACCOUNT = USE_SUB_ACCOUNT FROM ' + @vDbName +'SYS_PARMS';				
						SET @vLocation = 'UseSubAcc'
						Exec sp_Executesql @nSql,
						N'@P_USE_SUB_ACCOUNT INT OUTPUT',
						@P_USE_SUB_ACCOUNT=@iUseSubAcc OUTPUT;										
				
						IF (@iUseSubAcc=0)
							SET @g_iAccountId=@oPayBankAcc;
						ELSE IF (@iUseSubAcc <>0)				
							SET @g_iSubAccId=@oPaySubAcc;				
				
						--There are 4 combinations of lSubAcctID and lAccountID.  If both are none-zero, then both are correct,
						--(sub row id is determined by correct combination of sub acc number and account number); if lAccountID is non-zero and
						--sub row id is zero, that is OK; case of lAccountID 0 and sub row id non-zero can't happen because the way sub row id
						--was obtained; only case need to consider is both are zero. in this case, we will use default from the option window.	
						IF (@iAccountId=0 AND @iSubAccId=0)
						BEGIN
							IF (@g_iAccountId>0)
								SET @iAccountId = @g_iAccountId;
							ELSE IF (@g_iSubAccId>0)
							BEGIN				
								SET  @nSql='SELECT @P_ACCOUNT_ID=ACCOUNT_ID FROM ' + @vDbName+'BANK_ACC_SUB WHERE SUB_ROW_ID =@P_SUB_ROW_ID'						
								SET @vLocation = 'SubBank'
								Exec sp_Executesql @nSql,
								N'@P_ACCOUNT_ID INT OUTPUT,
								@P_SUB_ROW_ID INT',
								@P_ACCOUNT_ID=@iAccountId OUTPUT,
								@P_SUB_ROW_ID=@g_iSubAccId;
								SET @iSubAccId=@g_iSubAccId; --CHECK THIS PENDING						
							END
						END  ---(@iAccountId=0 AND @iSubAccId=0) ends here
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = @vLocation + ', ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
					--****BANK ACCOUNT VALIDATION ENDS****
				
					--****CHECK NUMBER VALIDATION STARTS****
					--Sdalvi3 Jira 65683 Start
					IF @vCHECK_STATUS = 'P'
						IF @vCHECK_NO IS NULL OR @vCHECK_NO = ''
						BEGIN
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ChkNumErr','ChkNumErr','DDS_PROCESS_PAYMENTS','Check Number is Required Field for Printed Payments and is Null or Empty in Import file','CHECK_NO','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID,1
							SET @iErrCnt += 1
						END
    				
					ELSE
 					BEGIN
 					--Sdalvi3 Jira 65683 End

					IF ISNUMERIC(@vCHECK_NO)=1
					BEGIN
						IF CAST(@vCHECK_NO AS BIGINT) < 2147483647
							SET @iTransNumber=@vCHECK_NO;
						ELSE
							SET @iTransNumber=0;
					END
					ELSE
						SET @iTransNumber=0;
				
						IF (@oAttachTransIdToChkNum IS NULL OR @oAttachTransIdToChkNum = 0) AND @vCHECK_NO IS NOT NULL
						BEGIN
					
							IF @iCHECK_SUFFIX IS NOT NULL AND LEN(@iCHECK_SUFFIX) > 0
								SET @vCHECK_NO += '-' + CAST(@iCHECK_SUFFIX AS VARCHAR)
					
								SET @nSql = 'SELECT @pTransId = TRANS_ID FROM ' + @vDbName + 'FUNDS WHERE CTL_NUMBER = @pCheckNum'

								BEGIN TRY
									EXECUTE SP_EXECUTESQL @nSql,
									N' @pTransId INT OUTPUT, @pCheckNum VARCHAR(25)',
									@pCheckNum = @vCHECK_NO,
									@pTransId = @iTransid OUTPUT
						

									IF @iTransid IS NOT NULL AND @iTransId <> 0
									BEGIN
										SET @vErrMsgDesc = 'Check Number: ' + @vCHECK_NO + ' already exists in Database. Either provide a unique Check Number or Select ''Attach Trans Id to Check Num'' on UI. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ChckNum', 'ChckNum', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CHECK_NO', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
									END
								END TRY
							BEGIN CATCH
								SET @vErrMsgDesc = 'ChkNumErr, ' + ERROR_MESSAGE() + '. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ChkNumErr','ChkNumErr','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
								SET @iErrCnt += 1
							END CATCH
						END
					END  --Sdalvi3 Jira 65683
					--****CHECK NUMBER VALIDATION ENDS****
				
					IF @iMemoCodeId IS NOT NULL AND @iMemoCodeId <> 0
					BEGIN
						SET @vMEMO = ISNULL(@vMEMO,'') + ISNULL(@vMEMO_PHRASE,'')
						SET @vMEMO = LEFT(@VMEMO,255)
					END
				
					IF @vTRANSACTION_TYPE = 'P'
					BEGIN
						SET @iPayFlag = 1
						SET @iColFlag = 0
					END
					ELSE
					BEGIN
						SET @iPayFlag = 0
						SET @iColFlag = 1
					END
					
					IF @vCHECK_STATUS = 'V'
						SET @iVoidFlag = 1
					ELSE
						SET @iVoidFlag = 0

					--JIRA 22820 knakra starts
					IF LEFT(@vCLEARED_FLAG,1) <> 'Y' AND LEFT(@vCLEARED_FLAG,1) <> 'N' AND @vCLEARED_FLAG IS NOT NULL
					BEGIN
						SET @vErrMsgDesc = 'Incorrect Flag Value: ' + @vCLEARED_FLAG + ', Please enter either Y or N. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'InvalidClrFlag', 'InvalidClrFlag', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLEARED_FLAG', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
					END
					ELSE
					BEGIN
						IF LEFT(@vCLEARED_FLAG,1) = 'Y'
							SET @iClearedFlag = 1
						ELSE IF LEFT(@vCLEARED_FLAG,1) = 'N' OR @vCLEARED_FLAG IS NULL
							SET @iClearedFlag = 0

						IF (@iClearedFlag = 1 OR @iVoidFlag = 1) AND @vDATE_CLEARED IS NULL
						BEGIN
							SET @vErrMsgDesc = 'If Clear Flag is set or Check Status is void, Date Cleared can not be left blank. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClrFlag', 'ClrFlag', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLEARED_FLAG,DATE_CLEARED,CHECK_STATUS', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END
					--JIRA 22820 knakra ends

					--JIRA 38951 knakra starts
					IF @iVoidFlag = 1 AND @iClearedFlag = 1
					BEGIN
						SET @vErrMsgDesc = 'Void Flag and Clear Flag both cannot be set for a transaction. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ClrVoidFlag', 'ClrVoidFlag', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLEARED_FLAG,CHECK_STATUS', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
					END
					--JIRA 38951 knakra ends

					--JIRA 22822 knakra starts
					IF (@vSERVICE_FROM_DATE IS NOT NULL AND @vSERVICE_TO_DATE IS NULL)
					BEGIN
						SET @vErrMsgDesc = 'Value Entered in SERVICE_FROM_DATE, Please enter value in SERVICE_TO_DATE. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						SET @vErrColumns = 'SERVICE_TO_DATE'
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'SrvToDate', 'SrvToDate', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
					END
					ELSE IF (@vSERVICE_FROM_DATE IS NULL AND @vSERVICE_TO_DATE IS NOT NULL)
					BEGIN
						SET @vErrMsgDesc = 'Value Entered in SERVICE_TO_DATE, Please enter value in SERVICE_FROM_DATE. '
						SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
						SET @vErrColumns = 'SERVICE_FROM_DATE'
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'SrvFrmDate', 'SrvFrmDate', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
						SET @iErrCnt += 1
					END
					ELSE IF @vSERVICE_FROM_DATE IS NOT NULL AND @vSERVICE_TO_DATE IS NOT NULL
					BEGIN
						IF @vSERVICE_FROM_DATE > @vSERVICE_TO_DATE
						BEGIN
							SET @vErrMsgDesc = 'SERVICE_FROM_DATE should be less than or equal to SERVICE_TO_DATE. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							SET @vErrColumns = 'SERVICE_FROM_DATE, SERVICE_TO_DATE'
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'SrvDates', 'SrvDates', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END
					--JIRA 22822 knakra starts ends

					--JIRA 29954 knakra(Moving this Code below after Currency rates has been calculated)
					/*IF @oDontCheckDupPay = 0 OR @oDontCheckDupPay IS NULL	--check for duplicate Payments
					BEGIN
						SET @nSql = 'SELECT @pTransId = F.TRANS_ID FROM ' + @vDbName + 'FUNDS F, ' + @vDbName
						IF @iVarFinKey <> 0 SET @nSql += 'RESERVE_CURRENT RC, ' + @vDbName	--JIRA 23831 knakra
						SET @nSql = @nSql + 'FUNDS_TRANS_SPLIT FTS WHERE F.CLAIM_ID = @pClaimId'
						SET @nSql = @nSql + ' AND F.CTL_NUMBER = @pCheckNum AND F.TRANS_DATE = @pActivityDate'
						SET @nSql = @nSql + ' AND F.TRANS_NUMBER = @pTransNumber'
						IF @vTRANSACTION_TYPE = 'P'
							SET @nSql = @nSql + ' AND F.PAYMENT_FLAG <> 0'
						ELSE
							SET @nSql = @nSql + ' AND F.PAYMENT_FLAG = 0'
						IF @vCHECK_STATUS = 'V'
							SET @nSql = @nSql + ' AND F.VOID_FLAG <> 0'
						ELSE
							SET @nSql = @nSql + ' AND F.VOID_FLAG = 0'
						SET @nSql = @nSql + ' AND F.TRANS_ID = FTS.TRANS_ID'
						--JIRA 23831 knakra starts
						IF @iVarFinKey = 0
							SET @nSql = @nSql + ' AND FTS.RESERVE_TYPE_CODE = @pResTypeCodeId'
						ELSE IF @iVarFinKey <> 0
						BEGIN
							SET @nSql += ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID'
							SET @nSql += ' AND RC.RESERVE_TYPE_CODE = @pResTypeCodeId'
							IF @iIncRsvSubType <> 0
								SET @nSql += ' AND RC.RESERVE_CATEGORY = @pResSubType'
						END
						--JIRA 23831 knakra ends
						SET @nSql = @nSql + ' AND (F.AMOUNT - @pAmount) >= 0'
						SET @nSql = @nSql + ' AND (F.AMOUNT - @pAmount) <= 0.009'
						
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pTransId INT OUTPUT, @pClaimId INT, @pCheckNum VARCHAR(12), @pActivityDate VARCHAR(8), @pTransNumber INT,
							@pResTypeCodeId INT, @pAmount DECIMAL(20,2), @pResSubType INT',
							@pClaimId = @iClaimId,
							@pCheckNum = @vCHECK_NO,
							@pActivityDate = @vACTIVITY_DATE,
							@pTransNumber = @iTransNumber,
							@pResTypeCodeId = @iResTypeCodeId,
							@pAmount = @fAMOUNT,
							@pResSubType = @iResSubTypeCodeId,	--JIRA 24633 knakra
							@pTransId = @iTransid OUTPUT
					
							IF @iTransid IS NOT NULL AND @iTransid <> 0
							BEGIN					
								SET @vErrMsgDesc = 'Duplicate Payment exists in the rmA Database. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DupPay', 'DupPay', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLAIM_ID,CHECK_NO,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
						END TRY	
						BEGIN CATCH
							SET @vErrMsgDesc = 'DupPayErr, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','DupPayErr','DupPayErr','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END*/
					--JIRA 29954 knakra ends(Moving this code below)

					SET @nSql = 'SELECT @pIncPrefix = INCLUDE_PREFIX, @pIncSuffix = INCLUDE_SUFFIX FROM ' + @vDbName + 'CHECK_OPTIONS'

					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pIncPrefix INT OUTPUT, @pIncSuffix INT OUTPUT',
						@pIncPrefix = @iIncPrefix OUTPUT,
						@pIncSuffix = @iIncSuffix OUTPUT
				
						SET @vPayToTheOrderOf = LTRIM(RTRIM(ISNULL(@vPAYEE_FIRSTNAME,'') + ' ' + ISNULL(@vPAYEE_LASTNAME,'')))
		
						IF @iIncPrefix <> 0
							SET @vPayToTheOrderOf = LTRIM(RTRIM(ISNULL(@vPREFIX,'') + ' ' + @vPayToTheOrderOf))
							
						IF @iIncSuffix <> 0
							SET @vPayToTheOrderOf = LTRIM(RTRIM(@vPayToTheOrderOf + ' ' + ISNULL(@vSUFFIX_COMMON,'')))
					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'PrefixSuffix, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PrefixSuffix','PrefixSuffix','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH

					--IF @iResStatusCodeId IS NOT NULL AND @iResStatusCodeId > 0 AND @iCarrierFlag <> 0	--Reserve Supplemental Flag is required while uploading financials to Point		JIRA 23831 knakra
					--IF @iResStatusCodeId IS NOT NULL AND @iResStatusCodeId > 0 AND ((@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0))	--Reserve Supplemental Flag is required while uploading financials to Point		JIRA 23831 knakra
					/*IF @iResStatusCode IS NOT NULL AND @iResStatusCode > 0 AND ((@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)) -- commented by JIRA 37275
					BEGIN
						SET @iResSuppPaymentFlag = 0

						SET @nSql = 'SELECT @pShortCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID IN('
						SET @nSql += 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pResStatusCodeId)'

						BEGIN TRY
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pShortCode VARCHAR(25) OUTPUT, @pResStatusCodeId INT',
							--@pResStatusCodeId = @iResStatusCodeid,
							@pResStatusCodeId = @iResStatusCode,
							@pShortCode = @vResStatus OUTPUT

							--IF @vResStatus IN('C','R')        ---JIRA 37275
							IF @vResStatus IN('C')              ---JIRA 37275
								SET @iResSuppPaymentFlag = -1
							ELSE
								SET @iResSuppPaymentFlag = 0
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = 'ResSupp, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResSupp','ResSupp','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END
					ELSE
						SET @iResSuppPaymentFlag = 0 */  -- JIRA 37275

				END
				--PAYMENTS SPECIFIC VALIDATIONS ENDS
			
				--Carrier Clients Check for Policy related coverages and losses starts
				BEGIN TRY
					--IF @iCarrierFlag <> 0	--JIRA 23831 knakra
					IF (@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)	--JIRA 23831 knakra
					BEGIN
						SET @nSql2 = 'SELECT @pPolicyId = POLICY_ID, @pPolKey = EXTERNAL_POLICY_KEY '
						--JIRA 24633 knakra starts
						IF @vRECORD_TYPE <> 'H'
						BEGIN
							SET @nSql = 'FROM ' + @vDbName + 'POLICY WHERE POLICY_NAME = @pPolicyName'
							SET @nSql = @nSql + ' AND MODULE = ISNULL(@pModule,''00'') AND POLICY_NUMBER = @pPolNum'
							SET @nSql = @nSql + ' AND POLICY_SYMBOL = @pPolSymbol AND MASTER_COMPANY = @pMasterCompany'
							SET @nSql = @nSql + ' AND LOCATION_COMPANY = @pLocCompany'
						END
						ELSE IF @vRECORD_TYPE = 'H'
						BEGIN
							SET @vPOLICY_NAME = ISNULL(@vPOLICY_NUMBER,'') + ' ' + ISNULL(@vMASTER_COMPANY,'') + ' ' + ISNULL(@vREGION,'')
							SET @nSql = 'FROM ' + @vDbName + 'POLICY WHERE POLICY_NAME = @pPolicyName'
						END
						--JIRA 24633 knakra ends				
						SET @nSql2 = @nSql2 + @nSql
						SET @vLocation = 'PolicyId'
						
						EXECUTE SP_EXECUTESQL @nSql2,	--check if Policy exists or not
						N' @pPolicyId int OUTPUT, @pPolKey varchar(50) OUTPUT, @pPolicyName VARCHAR(20), @pModule VARCHAR(10),
						@pPolNum VARCHAR(40), @pPolSymbol VARCHAR(20), @pMasterCompany VARCHAR(10), @pLocCompany VARCHAR(10)',
						@pPolicyName = @vPOLICY_NAME,
						@pModule = @vMODULE_NO,
						@pPolNum = @vPOLICY_NUMBER,
						@pPolSymbol = @vPOLICY_SYMBOL,
						@pMasterCompany = @vMASTER_COMPANY,
						@pLocCompany = @vLOCATION_COMPANY,
						@pPolicyId = @iPolicyId OUTPUT,
						@pPolKey = @vPolKey OUTPUT
				
						IF @iPolicyId IS NOT NULL AND @iPolicyId <> 0
						BEGIN
							SET @nSql2 = 'SELECT @pPolicyId = POLICY_ID FROM ' + @vDbName + 'CLAIM_X_POLICY WHERE POLICY_ID IN('
							SET @nSql2 = @nSql2 + 'SELECT POLICY_ID ' + @nSql + ') AND CLAIM_ID = @pClaimId'

							SET @vLocation = 'PolClaim'

							EXECUTE SP_EXECUTESQL @nSql2,	--check if Policy is attached to Claim or Not
							N' @pPolicyId int OUTPUT, @pClaimId INT, @pPolicyName VARCHAR(20), @pModule VARCHAR(10),
							@pPolNum VARCHAR(40), @pPolSymbol VARCHAR(20), @pMasterCompany VARCHAR(10), @pLocCompany VARCHAR(10)',
							@pPolicyName = @vPOLICY_NAME,
							@pModule = @vMODULE_NO,
							@pPolNum = @vPOLICY_NUMBER,
							@pPolSymbol = @vPOLICY_SYMBOL,
							@pMasterCompany = @vMASTER_COMPANY,
							@pLocCompany = @vLOCATION_COMPANY,
							@pClaimId = @iClaimId,
							@pPolicyId = @iPolicyId OUTPUT
					
							IF @iPolicyId <> 0 AND @iPolicyId IS NOT NULL
							BEGIN

								--JIRA 30818 knakra starts
								IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
								BEGIN
									SET @nSql = 'SELECT @pCurrCode = CURRENCY_CODE FROM ' + @vDbName + 'POLICY WHERE POLICY_ID = @pPolId'
									BEGIN TRY
										EXECUTE SP_EXECUTESQL @nSql,
										N'@pCurrCode INT OUTPUT, @pPolId INT',
										@pPolId = @iPolicyId,
										@pCurrCode = @iPolCurrCodeId OUTPUT

									END TRY
									BEGIN CATCH
										SET @vErrMsgDesc = 'PmtCurrCodeErr, ' + ERROR_MESSAGE() + '. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PmtCurrCodeErr','PmtCurrCodeErr','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
										SET @iErrCnt += 1
										SET @iPolErr = 1
									END CATCH
								END
								--JIRA 30818 knakra ends
							
								SET @nSql = 'SELECT @pPolSysId = POLICY_SYSTEM_ID FROM ' + @vDbName + 'POLICY WHERE POLICY_ID = @pPolicyId'

								SET @vLocation = 'PolSysId'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pPolSysId INT OUTPUT, @pPolicyId INT',
								@pPolicyId = @iPolicyId,
								@pPolSysId = @iPolSysId	OUTPUT
								
								--akumar523 RMA-63116 STARTS
								--SET @nSql = 'SELECT @pPolLob = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = '
								--SET @nSql = @nSql + '(SELECT POLICY_LOB_CODE FROM ' + @vDbName + 'POLICY WHERE POLICY_ID = @pPolicyId)'
								SET @nSql = 'SELECT @pPolLob = CR.SHORT_CODE FROM ' + @vDbName + 'CODES CR INNER JOIN ' + @vDbName + 'CODES C ON
											 C.RELATED_CODE_ID = CR.CODE_ID INNER JOIN ' + @vDbName + 'POLICY P ON
											 P.POLICY_LOB_CODE = C.CODE_ID
											 WHERE P.POLICY_ID = @pPolicyId'

								--akumar523 RMA-63116 ENDS
								SET @vLocation = 'PolLob'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pPolLob VARCHAR(25) OUTPUT, @pPolicyId INT',
								@pPolicyId = @iPolicyId,
								@pPolLob = @vPolicyLob OUTPUT
							
								IF @vPolicyLob IS NOT NULL AND @vPolicyLob <> ''
								BEGIN
									--IF ((@vRECORD_TYPE = 'W' AND @fVersionNum < 17.3) OR (@fVersionNum >= 17.3 AND @vRECORD_TYPE IN('W', 'D'))) AND @vPolicyLob = 'WCV'	akumar523 RMA-63116
									IF ((@vRECORD_TYPE = 'W' AND @fVersionNum < 17.3) OR (@fVersionNum >= 17.3 AND @vRECORD_TYPE IN('W', 'D'))) AND @vPolicyLob = 'WL'		--akumar523 RMA-63116
									BEGIN
										--for Policy LOB WL and WC Claim, both Loss Code and Disability Code are required
										EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,@vLOSS_CODE,'DISABILITY_TYPE',@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','CodeValidate','DDS_PROCESS_PAYMENTS','CLAIM_ID',@vColName,'DDS_PAYMENT',@vCLAIM_ID, @iLossCodeId OUTPUT

										--IF @iDisCatCodeId IS NULL OR @iDisCatCodeId = 0	--JIRA 23831 knarka
										IF (@iDisCatCodeId IS NULL OR @iDisCatCodeId = 0) AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 and @iIncLossType <> 0))	--JIRA 23831 knakra
										BEGIN
											SET @vErrMsgDesc = 'DISABILITY CATEGORY: ' + ISNULL(@vDISABILITY_CATEGORY,'') + ' is either empty or have invalid short code. '
											SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DisCat', 'DisCat', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DISABILITY_CATEGORY', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
											SET @iErrCnt += 1
											SET @iPolErr = 1
										END
										--IF @iLossCodeId IS NULL OR @iLossCodeId = 0	--JIRA 23831 knakra
										IF (@iLossCodeId IS NULL OR @iLossCodeId = 0) AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncLossType <> 0))	--JIRA 23831 knakra
										BEGIN
											SET @vErrMsgDesc = 'LOSS CODE/DISABILITY TYPE CODE: ' + ISNULL(@vLOSS_CODE,'') + 'is either empty or have invalid short code. '------akumar523
											SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'LossCode', 'LossCode', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'LOSS_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
											SET @iErrCnt += 1
											SET @iPolErr = 1
										END
									END
									ELSE IF @vRECORD_TYPE IN('G','V','D','W','H')	--knakra(added W as well, else W lob with policy lob other than WCV will not have both loss code and disability category in it)
									BEGIN
										--only Loss Code is required in case of non-wc Claims
										EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,@vLOSS_CODE,'LOSS_CODES',@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','CodeValidate','DDS_PROCESS_PAYMENTS','CLAIM_ID',@vColName,'DDS_PAYMENT',@vCLAIM_ID, @iLossCodeId OUTPUT
										
										--IF @iLossCodeId IS NULL OR @iLossCodeId = 0	JIRA 23831 knakra
										IF (@iLossCodeId IS NULL OR @iLossCodeId = 0) AND (@iVarFinKey = 0 OR (@iVarFinKey <> 0 and @iIncLossType <> 0))	--JIRA 23831 knakra
										BEGIN
											SET @vErrMsgDesc = 'LOSS CODE: ' + ISNULL(@vLOSS_CODE,'') + 'is either empty or have invalid short code. '
											SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'LCode', 'LCode', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'LOSS_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
											SET @iErrCnt += 1
											SET @iPolErr = 1
										END
									END
							
									IF @vUNIT_TYPE = 'S'	--fetch unit_id attached to the policy and claim
									BEGIN
										SET @nSql = 'SELECT @pUnitId = CXSL.SITE_ID FROM ' + @vDbName + 'CLAIM_X_SITELOSS CXSL, '
										SET @nSql = @nSql + @vDbName + 'POINT_UNIT_DATA PUD, ' + @vDbName + 'POLICY_X_UNIT PXU, '
										SET @nSql = @nSql + @vDbName + 'SITE_UNIT SU WHERE CLAIM_ID = @pClaimId'
										SET @nSql = @nSql + ' AND CXSL.SITE_ID = PUD.UNIT_ID AND PUD.UNIT_TYPE = ''S'' AND '
										SET @nSql = @nSql + 'PXU.UNIT_ID = CXSL.SITE_ID AND PXU.POLICY_ID = @pPolicyId'
										SET @nSql = @nSql + ' AND CXSL.CLAIM_ID = @pClaimId AND CXSL.SITE_ID = SU.SITE_ID '
										SET @nSql = @nSql + ' AND CXSL.SITE_ID IN(SELECT UNIT_ID FROM ' + @vDbName + 'POINT_UNIT_DATA WHERE UNIT_NUMBER = @pUnitNumber'
										SET @nSql = @nSql + ' AND STAT_UNIT_NUMBER = @pStatUnitNumber AND UNIT_ID = CXSL.SITE_ID AND UNIT_TYPE = ''S'')'
									END
									ELSE IF @vUNIT_TYPE = 'P'							
									BEGIN
										SET @nSql = 'SELECT @pUnitId = CXPL.PROPERTY_ID FROM ' + @vDbName + 'CLAIM_X_PROPERTYLOSS CXPL, '
										SET @nSql = @nSql + @vDbName + 'POINT_UNIT_DATA PUD, ' + @vDbName + 'POLICY_X_UNIT PXU, ' + @vDbName + 'PROPERTY_UNIT PU'
										SET @nSql = @nSql + ' WHERE CLAIM_ID = @pClaimId AND CXPL.PROPERTY_ID = PUD.UNIT_ID'
										SET @nSql = @nSql + ' AND PUD.UNIT_TYPE = ''P'' AND PXU.UNIT_ID = CXPL.PROPERTY_ID'
										SET @nSql = @nSql + ' AND PXU.POLICY_ID = @pPolicyId'
										SET @nSql = @nSql + ' AND CXPL.CLAIM_ID = @pClaimId'
										SET @nSql = @nSql + ' AND CXPL.PROPERTY_ID = PU.PROPERTY_ID AND CXPL.PROPERTY_ID IN('
										SET @nSql = @nSql + 'SELECT UNIT_ID FROM ' + @vDbName + 'POINT_UNIT_DATA WHERE UNIT_NUMBER = @pUnitNumber'
										SET @nSql = @nSql + ' AND STAT_UNIT_NUMBER = @pStatUnitNumber'
										SET @nSql = @nSql + ' AND UNIT_ID = CXPL.PROPERTY_ID AND UNIT_TYPE = ''P'')'
									END
									ELSE IF @vUNIT_TYPE = 'V'
									BEGIN
										SET @nSql = 'SELECT @pUnitId = UXC.UNIT_ID FROM ' + @vDbName + 'UNIT_X_CLAIM UXC, '
										SET @nSql = @nSql + @vDbName + 'POINT_UNIT_DATA PUD, ' + @vDbName + 'POLICY_X_UNIT PXU, ' + @vDbName + 'VEHICLE V'
										SET @nSql = @nSql + ' WHERE CLAIM_ID = @pClaimId AND UXC.UNIT_ID = PUD.UNIT_ID'
										SET @nSql = @nSql + ' AND PUD.UNIT_TYPE = ''V'' AND PXU.UNIT_ID = UXC.UNIT_ID'
										SET @nSql = @nSql + ' AND PXU.POLICY_ID = @pPolicyId'
										SET @nSql = @nSql + ' AND UXC.CLAIM_ID = @pClaimId'
										SET @nSql = @nSql + ' AND UXC.UNIT_ID = V.UNIT_ID AND UXC.UNIT_ID IN('
										SET @nSql = @nSql + 'SELECT UNIT_ID FROM ' + @vDbName + 'POINT_UNIT_DATA WHERE UNIT_NUMBER = @pUnitNumber'
										SET @nSql = @nSql + ' AND STAT_UNIT_NUMBER = @pStatUnitNumber'
										SET @nSql = @nSql + ' AND UNIT_ID = UXC.UNIT_ID AND UNIT_TYPE = ''V'')'
									END
									ELSE IF @vUNIT_TYPE = 'SU'
									BEGIN
										SET @nSql = 'SELECT @pUnitId = CXOU.OTHER_UNIT_ID FROM ' + @vDbName + 'CLAIM_X_OTHERUNIT CXOU, '
										SET @nSql = @nSql + @vDbName + 'POINT_UNIT_DATA PUD, ' + @vDbName + 'POLICY_X_UNIT PXU, ' + @vDbName + 'OTHER_UNIT OU, ' + @vDbName + 'ENTITY E'
										SET @nSql = @nSql + ' WHERE CXOU.CLAIM_ID = @pClaimId'
										SET @nSql = @nSql + ' AND PXU.UNIT_ID = PUD.UNIT_ID'
										SET @nSql = @nSql + ' AND PXU.UNIT_ID = CXOU.OTHER_UNIT_ID'
										SET @nSql = @nSql + ' AND PXU.UNIT_ID = OU.OTHER_UNIT_ID'
										SET @nSql = @nSql + ' AND PUD.UNIT_TYPE = ''SU'''
										SET @nSql = @nSql + ' AND OU.ENTITY_ID = E.ENTITY_ID'
										SET @nSql = @nSql + ' AND PXU.POLICY_ID = @pPolicyId'
										SET @nSql = @nSql + ' AND PUD.UNIT_NUMBER = @pUnitNumber'
										SET @nSql = @nSql + ' AND PUD.STAT_UNIT_NUMBER = @pStatUnitNumber'
										SET @nSql = @nSql + ' AND PXU.UNIT_TYPE = PUD.UNIT_TYPE'
									END
									--JIRA 24633 knakra starts
									ELSE IF @vUNIT_TYPE = 'I' AND @iHmiFlag <> 0
									BEGIN
										SET @nSql = 'SELECT @pUnitEntId = ENTITY_ID FROM ' + @vDbName + 'ENTITY WHERE'
										SET @nSql += ' LAST_NAME = @pUnitLastName'
										IF @vUNIT_FIRST_NAME IS NOT NULL
											SET @nSql += ' AND FIRST_NAME = @pUnitFirstName'
										IF @vUNIT_TAX_ID IS NOT NULL
											SET @nSql += ' AND REPLACE(TAX_ID,''-'','''') = REPLACE(@pUnitTaxId,''-'','''')'
										IF @vUNIT_DOB IS NOT NULL
											SET @nSql += ' AND BIRTH_DATE = @pUnitDob'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pUnitEntId INT OUTPUT, @pUnitLastName VARCHAR(255), @pUnitFirstName VARCHAR(255), @pUnitTaxId VARCHAR(20), @pUnitDob VARCHAR(8)',
										@pUnitLastName = @vUNIT_LAST_NAME,
										@pUnitFirstName = @vUNIT_FIRST_NAME,
										@pUnitTaxId = @vUNIT_TAX_ID,
										@pUnitDob = @vUNIT_DOB,
										@pUnitEntId = @iUnitEntId OUTPUT

										IF @iUnitEntId IS NOT NULL AND @iUnitEntId <> 0
										BEGIN
											SET @nSql = 'SELECT @pUnitId = CLAIM_X_INSUREDUNIT.INSURED_UNIT_ID FROM ' + @vDbName + 'CLAIM_X_INSUREDUNIT, '
											SET @nSql += @vDbName + 'POLICY_X_UNIT,' + @vDbName + 'INSURED_UNIT,' + @vDbName + 'ENTITY '
											SET @nSql += ' WHERE CLAIM_X_INSUREDUNIT.CLAIM_ID = @pClaimId'
											SET @nSql += ' AND POLICY_X_UNIT.UNIT_ID = CLAIM_X_INSUREDUNIT.INSURED_UNIT_ID'
											SET @nSql += ' AND POLICY_X_UNIT.UNIT_ID = INSURED_UNIT.INSURED_UNIT_ID'
											SET @nSql += ' AND POLICY_X_UNIT.UNIT_TYPE = ''I'''
											SET @nSql += ' AND INSURED_UNIT.ENTITY_ID = ENTITY.ENTITY_ID'
											SET @nSql += ' AND INSURED_UNIT.ENTITY_ID = @pUnitEntId'
											SET @nSql += ' AND POLICY_X_UNIT.POLICY_ID = @pPolicyId'
										END
										ELSE
										BEGIN
											SET @vErrMsgDesc = 'No Unit Entity with Last Name: ' + @vUNIT_LAST_NAME + ', exists in database. '
											SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
											SET @vErrColumns = 'UNIT_LAST_NAME'
											IF @vUNIT_FIRST_NAME IS NOT NULL
												SET @vErrColumns += ',UNIT_FIRST_NAME'
											IF @vUNIT_TAX_ID IS NOT NULL
												SET @vErrColumns += ',UNIT_TAX_ID'
											IF @vUNIT_DOB IS NOT NULL
												SET @vErrColumns += ',UNIT_DOB'
											
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'NoUnitEnt', 'NoUnitEnt', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
											SET @iErrCnt += 1
										END
									END
									ELSE IF @vUNIT_TYPE NOT IN('S','P','V','SU','I')
									BEGIN
										SET @iUnitId = 0
										SET @vErrMsgDesc = 'Invalid Unit Type: ' + ISNULL(@vUNIT_TYPE,'') + '. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'InvUnitId', 'InvUnitId', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'UNIT_TYPE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
									END
									--JIRA 24633 knakra ends
									IF @vUNIT_TYPE IN('S','P','V','SU') OR (@vUNIT_TYPE = 'I' AND @iUnitEntId IS NOT NULL AND @iUnitEntId > 0)
									BEGIN

										SET @vLocation = 'UnitId'
										
										EXECUTE SP_EXECUTESQL @nSql,
										N' @pUnitId int OUTPUT, @pClaimId INT, @pPolicyId INT, @pUnitNumber VARCHAR(10), @pStatUnitNumber VARCHAR(10), @pUnitEntId INT',
										@pClaimId = @iClaimId,
										@pPolicyId = @iPolicyId,
										@pUnitNumber = @vUNIT_NUMBER,
										@pStatUnitNumber = @vSTAT_UNIT_NUMBER,
										@pUnitEntId = @iUnitEntId,
										@pUnitId = @iUnitId OUTPUT
									END
							
									IF @iUnitId <> 0 AND @iUnitId IS NOT NULL AND @iUnitId <> ''
									BEGIN
										SET @nSql = 'SELECT @pPolUnitRowId = POLICY_UNIT_ROW_ID FROM ' + @vDbName + 'POLICY_X_UNIT'
										SET @nSql = @nSql + ' WHERE POLICY_ID = @pPolicyId'
										SET @nSql = @nSql + ' AND UNIT_ID = @pUnitId'
										SET @nSql = @nSql + ' AND UNIT_TYPE = @pUnitType'
										
										SET @vLocation = 'PolUnitRowId'
										
										EXECUTE SP_EXECUTESQL @nSql,
										N' @pPolUnitRowId int OUTPUT, @pPolicyId INT, @pUnitId INT,	@pUnitType VARCHAR(10)',
										@pPolicyId = @iPolicyId,
										@pUnitId = @iUnitId,
										@pUnitType = @vUNIT_TYPE,
										@pPolUnitRowId = @iPolUnitRowId OUTPUT
								
										IF @iPolUnitRowId IS NOT NULL AND @iPolUnitRowId <> 0 AND @iPolUnitRowId <> ''
										BEGIN
											SET @vCvgTxt = ''
											IF @vRECORD_TYPE IN('W', 'D')
												SET @vCvgTxt = @vCOVERAGE_CODE + ' ' + @vCLASS_CODE + ' ' + @vCLASS_DESC
											ELSE IF @vRECORD_TYPE IN('G','V')
												SET @vCvgTxt = @vCOVERAGE_CODE + ' ' + @vCVG_DESC + ' ' + @vCLASS_CODE + ' ' + @vCLASS_DESC									
											--JIRA 24633 knakra starts
											ELSE IF @vRECORD_TYPE = 'H' AND @iHmiFlag <> 0
												SET @vCvgTxt = ISNULL(@vCOVERAGE_CODE,'') + ' - ' + ISNULL(@vCLASS_CODE,'')
											--JIRA 24633 knakra ends

											SET @nSql = 'SELECT @pPolCvgRowId = POLCVG_ROW_ID, @pCvgKey = COVERAGE_KEY FROM ' + @vDbName + 'POLICY_X_CVG_TYPE WHERE'
											SET @nSql = @nSql + ' COVERAGE_TYPE_CODE = @pCvgCodeId'
											SET @nSql = @nSql + ' AND POLICY_UNIT_ROW_ID = @pPolUnitRowId'
											--JIRA 24633 knakra starts
											IF @vRECORD_TYPE <> 'H' AND @iHmiFlag = 0
											BEGIN
												SET @nSql = @nSql + ' AND CVG_SEQUENCE_NO = @pCvgSeqNum'
												SET @nSql = @nSql + ' AND TRANS_SEQ_NO = @pTransSeqNum'
											END
											--JIRA 24633 knakra ends
											SET @nSql = @nSql + ' AND COVERAGE_TEXT = @pCvgText'
											
											SET @vLocation = 'PolCvgRowId'

											EXECUTE SP_EXECUTESQL @nSql,	--fetch coverage on which payment needs to be made
											N' @pPolCvgRowId int OUTPUT, @pCvgKey varchar(100) OUTPUT, @pCvgCodeId INT, @pPolUnitRowId INT,
											@pCvgSeqNum VARCHAR(8), @pTransSeqNum VARCHAR(8), @pCvgText VARCHAR(MAX)',
											@pCvgCodeId = @iCvgCodeId,
											@pPolUnitRowId = @iPolUnitRowId,
											@pCvgSeqNum = @vCVG_SEQUENCE_NO,
											@pTransSeqNum = @vTRANS_SEQ_NO,
											@pCvgText = @vCvgTxt,
											@pPolCvgRowId = @iPolCvgRowId OUTPUT,
											@pCvgKey = @vCvgKey OUTPUT
											
											IF @iPolCvgRowId IS NOT NULL AND @iPolCvgRowId <> 0 AND @iPolCvgRowId <> ''
											BEGIN
												SET @nSql = 'SELECT @pCvgLossRowId = CVG_LOSS_ROW_ID FROM ' + @vDbName + 'COVERAGE_X_LOSS WHERE'												
												SET @nSql = @nSql + ' POLCVG_ROW_ID = @pPolCvgRowId'
												IF (@iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncLossType <> 0))	--JIRA 23831 knakra starts
												BEGIN	
													SET @nSql = @nSql + ' AND LOSS_CODE = @pLossCodeId'						
													IF (@vRECORD_TYPE = 'W' AND @fVersionNum < 17.3) OR (@fVersionNum >= 17.3 AND @vRECORD_TYPE IN('W','D'))
														SET @nSql = @nSql + ' AND DISABILITY_CAT = @pDisCatCodeId'
												END
												SET @vLocation = 'CvgLossRowId'
												
												EXECUTE SP_EXECUTESQL @nSql,	--Loss on which transaction will be made
												N' @pCvgLossRowId int OUTPUT, @pLossCodeId INT, @pPolCvgRowId INT, @pDisCatCodeId INT',
												@pLossCodeId = @iLossCodeId,
												@pPolCvgRowId = @iPolCvgRowId,
												@pDisCatCodeId = @iDisCatCodeId,
												@pCvgLossRowId = @iCvgLossRowId OUTPUT
										
												IF @iCvgLossRowId IS NULL OR @iCvgLossRowId = 0 OR @iCvgLossRowId = ''
												BEGIN
													IF @vTRANSACTION_TYPE = 'R'
													BEGIN
														--SET @nSql = 'SELECT @pLossCode = LOSS_CODE FROM ' + @vDbName + 'CVG_LOSS_LOB_MAPPING WHERE'	JIRA 23831 knakra
														SET @nSql = 'SELECT @pLossCode = ROW_ID FROM ' + @vDbName + 'CVG_LOSS_LOB_MAPPING WHERE'	--JIRA 23831 knakra
														SET @nSql = @nSql + ' POLICY_LOB IN(SELECT POLICY_LOB_CODE FROM ' + @vDbName + 'POLICY WHERE POLICY_ID = @pPolicyId'
														IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 and @iIncLossType <> 0)	--JIRA 23831 knakra
															SET @nSql = @nSql + ' AND LOSS_CODE = @pLossCodeId'
														SET @nSql = @nSql + ' AND POLICY_SYSTEM_ID IN(SELECT POLICY_SYSTEM_ID FROM ' + @vDbName + 'POLICY WHERE POLICY_ID = @pPolicyId)'
														SET @nSql = @nSql + ' AND CVG_TYPE_CODE = @pCvgCodeId)'
														
														SET @vLocation = 'LossCodeMap'
														--check of Loss is mapped to the coverage or not
														EXECUTE SP_EXECUTESQL @nSql,
														N' @pLossCode int OUTPUT, @pLossCodeId INT, @pPolicyId INT, @pCvgCodeId INT',
														@pLossCodeId = @iLossCodeId,
														@pPolicyId = @iPolicyId,
														@pCvgCodeId = @iCvgCodeId,
														@pLossCode = @iLossCodeMapping OUTPUT
												
														IF @iLossCodeMapping IS NOT NULL AND @iLossCodeMapping <> 0
														BEGIN
															SET @nSql = 'SELECT @pNextUniqueId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE'
															SET @nSql = @nSql + ' SYSTEM_TABLE_NAME = ''COVERAGE_X_LOSS'''
															
															SET @vLocation = 'CvgLossUid'
															
															EXECUTE SP_EXECUTESQL @nSql,
															N' @pNextUniqueId int OUTPUT',
															@pNextUniqueId = @iCvgLossRowId OUTPUT														
															
															SET @nSql = 'INSERT INTO ' + @vDbName + 'COVERAGE_X_LOSS(CVG_LOSS_ROW_ID, POLCVG_ROW_ID, LOSS_CODE, DISABILITY_CAT'
															--JIRA 23831 knakra starts
															--SET @nSql += ') VALUES(@pCvgLossRowId, @pPolCvgRowId, @pLossCodeId,@pDisCatCodeId)'															
															SET @nSql += ') VALUES(@pCvgLossRowId, @pPolCvgRowId, '
															IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncLossType <> 0)
																SET @nSql += '@pLossCodeId,@pDisCatCodeId)'
															ELSE
																SET @nSql += '0, 0)'

															SET @vLocation = 'CvgLossIns'

															EXECUTE SP_EXECUTESQL @nSql,
															N' @pCvgLossRowId int, @pLossCodeId int, @pDisCatCodeId int, @pPolCvgRowId int',
															@pCvgLossRowId = @iCvgLossRowId,
															@pLossCodeId = @iLossCodeId,
															@pDisCatCodeId = @iDisCatCodeId,
															@pPolCvgRowId = @iPolCvgRowId
																											
															SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1'
															SET @nSql = @nSql + ' WHERE SYSTEM_TABLE_NAME = ''COVERAGE_X_LOSS'''
															
															SET @vLocation = 'UpdCvgLossUid'

															EXECUTE SP_EXECUTESQL @nSql														
														END
														ELSE
														BEGIN
															SET @vErrMsgDesc = 'Loss Code mapping is missing for LOSS CODE: ' + ISNULL(@vLOSS_CODE,'') + '. '
															SET @vErrMsgDesc += 'COVERAGE_TYPE: ' + ISNULL(@vCOVERAGE_CODE,'') + ' | Policy System with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'')
															SET @vErrMsgDesc = @vErrMsgDesc + '. Discarded Payment/Reserve is combination of transacation Date :' +@vTRANSACTION_DATE + ', Check Number : '+@vCHECK_NO+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
															EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'LCodeMap', 'LCodeMap', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'LOSS_CODE;COVERAGE_CODE;POLICY_NAME', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
															SET @iErrCnt += 1
															SET @iPolErr = 1
														END
													END
													ELSE
													BEGIN
														SET @vErrColumns = 'LOSS_CODE,COVERAGE_CODE'
														SET @vErrMsgDesc = 'Loss or Disability Code is not mapped to Coverge with COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
														SET @vErrMsgDesc += ' ,LOSS_CODE: ' + ISNULL(@vLOSS_CODE,'')
														IF @vDISABILITY_CATEGORY IS NOT NULL
														BEGIN
															SET @vErrColumns += ',DISABILITY_CATEGORY'
															SET @vErrMsgDesc += ' ,DISABILITY_CATEGORY: ' + @vDISABILITY_CATEGORY
														END
														SET @vErrMsgDesc += '. '
														SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
														EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'CodeCvgMap', 'CodeCvgMap', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
														SET @iErrCnt += 1
														SET @iPolErr = 1
													END
												END
												ELSE
												BEGIN
													IF @vTRANSACTION_TYPE IN ('P','C')
													BEGIN
														--SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID FROM ' + @vDbName + 'RESERVE_CURRENT'                             --commented by 37275
														SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID ,@pResStatusCode = RES_STATUS_CODE FROM ' + @vDbName + 'RESERVE_CURRENT'    -- JIRA 37275
														SET @nSql += ' WHERE CLAIM_ID = @pClaimId'
														--JIRA 23831 knakra starts
														IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0)
															SET @nSql += ' AND CLAIMANT_EID = @pClaimantEid'
														IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncRsvType <> 0)
															SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCodeId'														
														IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)
															SET @nSql += ' AND POLCVG_LOSS_ROW_ID = @pCvgLossRowId'
														IF @iVarFinKey <> 0 AND @iIncRsvSubType <> 0
															SET @nSql += ' AND RESERVE_CATEGORY = @pRsvSubTypeCode'
														--JIRA 23831 knakra ends
														--SET @nSql += ' AND UNIT_ID = @pUnitId'             --ddhupar commented for JIRA 65681
														
														SET @vLocation = 'FetchRcRowId'
														--for carrier clients, Reserves should be there if Payments are made using DDS
														EXECUTE SP_EXECUTESQL @nSql,
														N' @pRcRowId INT OUTPUT, @pResStatusCode INT OUTPUT,@pClaimId INT, @pClaimantEid INT, @pResTypeCodeId INT, @pCvgLossRowId INT, @pUnitId INT, @pRsvSubTypeCode INT',
														@pClaimId = @iClaimId,
														@pClaimantEid = @iClaimantEid,
														@pResTypeCodeId = @iResTypeCodeId,
														@pCvgLossRowId = @iCvgLossRowId,
														@pUnitId = @iVehicleId,               
														@pRsvSubTypeCode = @iResSubTypeCodeId,	--JIRA 23831 knakra
														@pRcRowId = @iRcRowId OUTPUT,
														@pResStatusCode = @iResStatusCode OUTPUT   -- JIRA 37275
												
														IF @iRcRowId IS NULL OR @iRcRowId = 0
														BEGIN
															SET @vErrMsgDesc = 'Reserve doesnot exist in Riskmaster Database for this Payment. '
															SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
															SET @vErrColumns = 'CLAIM_ID;RESERVE_TYPE'
															EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResExists', 'ResExists', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
															SET @iErrCnt += 1
															SET @iPolErr = 1
														END																								
													END
												END																													
											END
											ELSE
											BEGIN
												SET @vErrColumns = 'COVERAGE_CODE,TRANS_SEQ_NO,CVG_SEQUENCE_NO,CLASS_CODE,CLASS_DESC'
												SET @vErrMsgDesc = 'Coverage with COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'') + ' | TRANS_SEQ_NO: ' + ISNULL(@vTRANS_SEQ_NO,'')
												SET @vErrMsgDesc += ' | CVG_SEQUENCE_NO: ' + ISNULL(@vCVG_SEQUENCE_NO,'') + ' | CLASS_CODE: ' + ISNULL(@vCLASS_CODE,'')
												SET @vErrMsgDesc += '| CLASS_DESC: ' + ISNULL(@vCLASS_DESC,'')
												IF (@vRECORD_TYPE = 'W' AND @fVersionNum < 17.3) OR (@fVersionNum >= 17.3 AND @vRECORD_TYPE IN('W','D'))
												BEGIN
													SET @vErrColumns += ',CVG_DESC'
													SET @vErrMsgDesc += 'CVG_DESC: ' + ISNULL(@vCVG_DESC,'')
												END
												--JIRA 24633 knakra starts
												IF @vRECORD_TYPE = 'H'
												BEGIN
													SET @vErrMsgDesc = 'Coverage with Coverage Code: ' + ISNULL(@vCOVERAGE_CODE,'') + ', Class Code: ' + ISNULL(@vCLASS_CODE,'')
													SET @vErrColumns = 'COVERAGE_CODE,CLASS_CODE'
												END
												--JIRA 24633 knakra ends
												SET @vErrMsgDesc += ' is not attached to Policy. '
												SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
												EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'CvgPol', 'CvgPol', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
												SET @iErrCnt += 1
												SET @iPolErr = 1
											END									
										END
										ELSE
										BEGIN
											--JIRA 24633 knarka starts
											IF @vRECORD_TYPE = 'H'
												SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION,UNIT_NUMBER,STAT_UNIT_NUMBER,UNIT_TYPE'
											ELSE
												SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,LOCATION_COMPANY,MASTER_COMPANY,MODULE_NO,POLICY_SYMBOL,UNIT_NUMBER,STAT_UNIT_NUMBER,UNIT_TYPE'
											--JIRA 24633 knakra ends
											SET @vErrMsgDesc += 'UNIT with UNIT_NUMBER: ' + ISNULL(@vUNIT_NUMBER,'') + ' | STAT_UNIT_NUMBER: ' + ISNULL(@vSTAT_UNIT_NUMBER,'')
											SET @vErrMsgDesc += ' | UNIT_TYPE: ' + ISNULL(@vUNIT_TYPE,'') + 'is not attached to Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'') + '. '
											SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'UnitPol', 'UnitPol', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
											SET @iErrCnt += 1
											SET @iPolErr = 1
										END								
									END
									ELSE
									BEGIN
										SET @vErrColumns = 'UNIT_TYPE,UNIT_NUMBER,STAT_UNIT_NUMBER'
										SET @vErrMsgDesc = 'Unit Record with UNIT_TYPE: ' + ISNULL(@vUNIT_TYPE,'') + ' | UNIT_NUMBER: ' + ISNULL(@vUNIT_NUMBER,'')
										SET @vErrMsgDesc += ' | STAT_UNIT_NUMBER: ' + ISNULL(@vSTAT_UNIT_NUMBER,'') + ' is not attached with Claim: ' + @vCLAIM_ID + '. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'UnitClm', 'UnitClm', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
										SET @iPolErr = 1
									END
							
								END
								ELSE
								BEGIN
									--JIRA 24633 knakra starts
									IF @vRECORD_TYPE = 'H'
									BEGIN
										SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION'
										SET @vErrMsgDesc = 'Policy with Policy Number: ' + ISNULL(@vPOLICY_NUMBER,'') + ', Master Company: ' + isnull(@vMASTER_COMPANY,'')
										SET @vErrMsgDesc += ', Region: ' + ISNULL(@vREGION,'') + ' have invalid Policy LOB. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									END
									ELSE
									BEGIN
										SET @vErrMsgDesc = 'Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'') + ' | POLICY_NUMBER: ' + ISNULL(@vPOLICY_NUMBER,'')
										SET @vErrMsgDesc += ' | POLICY_SYMBOL: ' + ISNULL(@vPOLICY_SYMBOL,'') + ' | MASTER_COMPANY: ' + ISNULL(@vMASTER_COMPANY,'')
										SET @vErrMsgDesc += ' | LOCATION_COMPANY: ' + ISNULL(@vLOCATION_COMPANY,'') + ' | MODULE_NO: ' + ISNULL(@vMODULE_NO,'')
										SET @vErrMsgDesc += ' have invalid Policy LOB. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
									END
									--JIRA 24633 knakra ends
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'InvPolLob', 'InvPolLob', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
									SET @iPolErr = 1
								END
							END
							ELSE
							BEGIN
								--JIRA 24633 knakra starts
								IF @vRECORD_TYPE = 'H'
								BEGIN
									SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION,CLAIM_ID'
									SET @vErrMsgDesc = 'Policy with Policy Number: ' + ISNULL(@vPOLICY_NUMBER,'') + ', Master Company: ' + isnull(@vMASTER_COMPANY,'')
									SET @vErrMsgDesc += ', Region: ' + ISNULL(@vREGION,'') + ' have invalid Policy LOB. '
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								END
								ELSE
								BEGIN
									SET @vErrColumns = 'CLAIM_ID,POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
									SET @vErrMsgDesc = 'Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'') + ' | POLICY_NUMBER: ' + ISNULL(@vPOLICY_NUMBER,'')
									SET @vErrMsgDesc += ' | POLICY_SYMBOL: ' + ISNULL(@vPOLICY_SYMBOL,'') + ' | MASTER_COMPANY: ' + ISNULL(@vMASTER_COMPANY,'')
									SET @vErrMsgDesc += ' | LOCATION_COMPANY: ' + ISNULL(@vLOCATION_COMPANY,'') + ' | MODULE_NO: ' + ISNULL(@vMODULE_NO,'')
								END
								--JIRA 24633 knakra ends
								SET @vErrMsgDesc += ' is not attached to Claim with Claim Number: ' + @vCLAIM_ID + '. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolClm', 'PolClm', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
								SET @iPolErr = 1
							END
						END
						ELSE
						BEGIN
							--JIRA 24633 knakra starts
							IF @vRECORD_TYPE = 'H'
							BEGIN
								SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION,CLAIM_ID'
								SET @vErrMsgDesc = 'Policy with Policy Number: ' + ISNULL(@vPOLICY_NUMBER,'') + ', Master Company: ' + isnull(@vMASTER_COMPANY,'')
								SET @vErrMsgDesc += ', Region: ' + ISNULL(@vREGION,'') + ' have invalid Policy LOB. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							END
							ELSE
							BEGIN
								SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
								SET @vErrMsgDesc = 'Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'') + ' | POLICY_NUMBER: ' + ISNULL(@vPOLICY_NUMBER,'')
								SET @vErrMsgDesc += ' | POLICY_SYMBOL: ' + ISNULL(@vPOLICY_SYMBOL,'') + ' | MASTER_COMPANY: ' + ISNULL(@vMASTER_COMPANY,'')
								SET @vErrMsgDesc += ' | LOCATION_COMPANY: ' + ISNULL(@vLOCATION_COMPANY,'') + ' | MODULE_NO: ' + ISNULL(@vMODULE_NO,'')
							END
							SET @vErrMsgDesc += ' doesnot exist in rmA Database. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolExists', 'PolExists', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
							SET @iPolErr = 1
						END

						-- JIRA 37275 starts
						
						IF @iResStatusCode IS NOT NULL AND @iResStatusCode > 0 AND ((@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)) 
						BEGIN
						SET @iResSuppPaymentFlag = 0

						SET @nSql = 'SELECT @pShortCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID IN('
						SET @nSql += 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pResStatusCode)'

						BEGIN TRY
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pShortCode VARCHAR(25) OUTPUT, @pResStatusCode INT',
							--@pResStatusCodeId = @iResStatusCodeid,
							@pResStatusCode = @iResStatusCode,
							@pShortCode = @vResStatus OUTPUT

							--IF @vResStatus IN('C','R')        ---JIRA 37275
							IF @vResStatus IN ('C')              ---JIRA 37275
								SET @iResSuppPaymentFlag = -1
							ELSE
								SET @iResSuppPaymentFlag = 0
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = 'ResSupp, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResSupp','ResSupp','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END
					ELSE
						SET @iResSuppPaymentFlag = 0

					-- JIRA 37275 ends

						--Check for Policy Limits Starts--
						/*IF @vTRANSACTION_TYPE = 'P' AND @iPolErr = 0
						BEGIN				
							DECLARE @iLimitCount INT = 0,
									@cLimitCursor CURSOR,
									@iCountLoop INT = 1,
									@vdbCvgKey VARCHAR(100) = '',
									@dLimitAmt DECIMAL(20,2) = 0.00,
									@iLimitCode INT = 0

							SET @nSql = 'SELECT @pLimitFlag = USE_LIMIT_TRACKING FROM ' + @vDbName + 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = @pLob'
							
							SET @vLocation = 'LimitFlag'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pLimitFlag int OUTPUT, @pLob int',
							@pLob = @iLob,
							@pLimitFlag = @iLimitFlag OUTPUT

							IF @iLimitFlag <> 0
							BEGIN
								SET @nSql = 'SELECT @pLimitCount = COUNT(LIMIT_ROW_ID) FROM ' + @vDbName + 'POL_COV_LIMIT'
								SET @nSql = @nSql + ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' + @vDbName + 'CODE_X_CODE WHERE CODE1 = @pResTypeCodeId'
								SET @nSql = @nSql + ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' + @vDbName + 'CODES C, ' + @vDbName + 'GLOSSARY G WHERE'
								SET @nSql = @nSql + ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = ''RTTOLT'' AND G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE''))'
								SET @nSql = @nSql + ' AND POLICY_KEY = @pPolKey AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = @pCvgKey)'

								SET @vLocation = 'LimitCount'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pLimitCount INT OUTPUT, @pResTypeCodeId INT, @pPolKey VARCHAR(50), @pCvgKey VARCHAR(100)',
								@pResTypeCodeId = @iResTypeCodeId,
								@pPolKey = @vPolKey,
								@pCvgKey = @vCvgKey,
								@pLimitCount = @iLimitCount OUTPUT
							
								IF @iLimitCount > 0
								BEGIN
									IF @vPolKey IS NOT NULL AND @vCvgKey IS NOT NULL AND @vPolKey <> '' AND @vCvgKey <> ''
									BEGIN
										--JIRA 29954 knakra starts
										IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
											SET @nSql = 'SELECT @pAggAmtOnPol = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										ELSE
											SET @nSql = 'SELECT @pAggAmtOnPol = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										--JIRA 29954 knakra ends
										SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY, ' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE'
										SET @nSql = @nSql + ' WHERE POLICY.EXTERNAL_POLICY_KEY= @pPolKey AND POLICY.POLICY_ID = POLICY_X_UNIT.POLICY_ID AND'
										SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID= POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)'

										SET @vLocation = 'AggAmtOnPol'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pAggAmtOnPol DECIMAL(20,2) OUTPUT, @pPolKey varchar(50)',
										@pPolKey = @vPolKey,
										@pAggAmtOnPol = @dAggAmtOnPol OUTPUT
										
										--JIRA 29954 knakra starts
										IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
											SET @nSql = 'SELECT @pAggAmtOnCvg = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										ELSE
											SET @nSql = 'SELECT @pAggAmtOnCvg = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										--JIRA 29954 knakra ends
										SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY,' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE'
										SET @nSql = @nSql + ' WHERE POLICY.EXTERNAL_POLICY_KEY = @pPolKey AND POLICY.POLICY_ID=POLICY_X_UNIT.POLICY_ID AND'
										SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID AND POLICY_X_CVG_TYPE.COVERAGE_KEY = @pCvgKey)'

										SET @vLocation = 'AggAmtOnCvg'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pAggAmtOnCvg DECIMAL(20,2) OUTPUT, @pPolKey VARCHAR(50), @pCvgkey VARCHAR(100)',
										@pPolKey = @vPolKey,
										@pCvgKey = @vCvgKey,
										@pAggAmtOnCvg = @dAggAmtOnCvg OUTPUT

										--JIRA 29954 knakra starts
										IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
											SET @nSql = 'SELECT @pOccAmtOnPol = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										ELSE
											SET @nSql = 'SELECT @pOccAmtOnPol = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
										--JIRA 29954 knakra ends
										SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE WHERE'
										SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_ID = @pPolicyId AND POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)'

										SET @vLocation = 'OccAmtOnPol'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pOccAmtOnPol DECIMAL(20,2) OUTPUT, @pPolicyId INT',
										@pPolicyId = @iPolicyId,
										@pOccAmtOnPol = @dOccAmtOnPol OUTPUT

										--JIRA 29954 knakra starts
										IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
											SET @nSql = 'SELECT @pOccAmtOnCvg = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT,' + @vDbName + 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = @pCvgRowid'
										ELSE
											SET @nSql = 'SELECT @pOccAmtOnCvg = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT,' + @vDbName + 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = @pCvgRowid'
										--JIRA 29954 knakra ends
										SET @nSql = @nSql + ' AND COVERAGE_X_LOSS.CVG_LOSS_ROW_ID = RESERVE_CURRENT.POLCVG_LOSS_ROW_ID'

										SET @vLocation = 'OccAmtOnCvg'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pOccAmtOnCvg DECIMAL(20,2) OUTPUT, @pCvgRowid INT',
										@pCvgRowId = @iPolCvgRowId,
										@pOccAmtOnCvg = @dOccAmtOnCvg OUTPUT

										SET @nSql = 'SET @pLimitCursor = CURSOR LOCAL STATIC FOR'
										SET @nSql = @nSql + ' SELECT LIMIT_AMOUNT, LIMIT_TYPE_CODE, COVERAGE_KEY FROM ' + @vDbName + 'POL_COV_LIMIT'
										SET @nSql = @nSql + ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' + @vDbName + 'CODE_X_CODE WHERE CODE1 = @pResTypeCodeId'
										SET @nSql = @nSql + ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' + @vDbName + 'CODES C, ' + @vDbName + 'GLOSSARY G WHERE'
										SET @nSql = @nSql + ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = ''RTTOLT'' AND G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE''))'
										SET @nSql = @nSql + ' AND POLICY_KEY = @pPolKey AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = @pCvgKey)'
										SET @nSql = @nSql + ' OPEN @pLimitCursor'

										SET @vLocation = 'InternalCurLimit'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pLimitCursor CURSOR OUTPUT, @pPolKey VARCHAR(50), @pCvgKey VARCHAR(100), @pResTypeCodeId INT',
										@pPolKey = @vPolKey,
										@pCvgKey = @vCvgKey,
										@pResTypeCodeId = @iResTypeCodeId,
										@pLimitCursor = @cLimitCursor OUTPUT																					

										FETCH FIRST FROM @cLimitCursor INTO @dLimitAmt, @iLimitCode, @vdbCvgKey

										WHILE @iCountLoop <= @iLimitCount
										BEGIN
											DECLARE @vParentLimit VARCHAR(50) = NULL
								
											SET @nSql = 'SELECT @pShortCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID IN('
											SET @nSql = @nSql + 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pCodeId)'

											SET @vLocation = 'ParentLimit'

											EXECUTE SP_EXECUTESQL @nSql,
											N' @pCodeid INT, @pShortCode VARCHAR(50) OUTPUT',
											@pCodeId = @iLimitCode,
											@pShortCode = @vParentLimit OUTPUT

											SET @vErrMsgDesc = 'Policy Limit exceeded for Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'')
											SET @vErrMsgDesc += ', POLICY_NUMBER: ' + ISNULL(@vPOLICY_NUMBER,'') + ', POLICY_SYMBOL: ' + ISNULL(@vPOLICY_SYMBOL,'')
											SET @vErrMsgDesc += ', MASTER_COMPANY: ' + ISNULL(@vMASTER_COMPANY,'') + ', LOCATION_COMPANY: ' + ISNULL(@vLOCATION_COMPANY,'')
											SET @vErrMsgDesc += ', MODULE_NO: ' + ISNULL(@vMODULE_NO,'')
											SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
										
											IF @vParentLimit = 'AGG'
											BEGIN
												IF @vdbCvgKey IS NOT NULL OR @vdbCvgKey <> ''
												BEGIN
													IF @dLimitAmt < (@dAggAmtOnCvg + @fAMOUNT)
													BEGIN
														SET @vErrColumns += ',COVERAGE_CODE'
														SET @vErrMsgDesc += ', COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
														EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitCvgAgg', 'PolLimitCvgAgg', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
														SET @iErrCnt += 1
													END
												END
												ELSE
												BEGIN
													IF @dLimitAmt < (@dAggAmtOnPol + @fAMOUNT)
													BEGIN
														EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitAgg', 'PolLimitAgg', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
														SET @iErrCnt += 1
													END
												END
											END
											ELSE IF @vParentLimit = 'OCC'
											BEGIN
												IF @vdbCvgKey IS NOT NULL AND @vdbCvgKey <> ''
												BEGIN
													IF @dLimitAmt < (@dOccAmtOnCvg + @fAMOUNT)
													BEGIN
														SET @vErrColumns += ',COVERAGE_CODE'
														SET @vErrMsgDesc += ', COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
														EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitCvgOcc', 'PolLimitCvgOcc', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
														SET @iErrCnt += 1
													END
												END
												ELSE
												BEGIN
													IF @dLimitAmt < (@dOccAmtOnPol + @fAMOUNT)
													BEGIN
														EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitOcc', 'PolLimitOcc', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
														SET @iErrCnt += 1
													END
												END
											END
											FETCH NEXT FROM @cLimitCursor INTO @dLimitAmt, @iLimitCode, @vdbCvgKey
										
											SET @iCountLoop += 1
										END
										CLOSE @cLimitCursor
										DEALLOCATE @cLimitCursor
									END
									ELSE
									BEGIN	--policy key and coverage key can not be null for external policies and their coverages
										IF @vPolKey IS NULL
										BEGIN
											SET @vErrMsgDesc = 'POLICY KEY is null for POLICY NAME: ' +	ISNULL(@vPOLICY_NAME,'')
											SET @vErrMsgDesc += ', Invalid Policy in Database as it can not have NULL value for Carrier Clients. '
											--JIRA 24633 knakra starts
											IF @vRECORD_TYPE = 'H'
												SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION'
											ELSE
												SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
											--JIRA 24633 knakra ends
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolKeyNull', 'PolKeyNull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1										
											SET @iErrCnt += 1
										END
										IF @vCvgKey IS NULL
										BEGIN
											SET @vErrMsgDesc = 'COVERAGE_KEY is null for COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
											SET @vErrMsgDesc = ', Invalid Coverage in Database as it can not have NULL value for Carrier Clients. '
											--JIRA 24633 knakra starts
											IF @vRECORD_TYPE = 'H'
												SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION'
											ELSE
												SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
											--JIRA 24633 knakra ends
											EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'CvgKeynull', 'CvgKeynull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1										
											SET @iErrCnt += 1
										END
									END
								END
							END				
						END*/
						--Check for Policy Limits ends--

						--Distribution Type Starts
						/*IF @vTRANSACTION_TYPE in('P','C')		JIRA 26252 knakra starts
						BEGIN
							IF @iAccountId <> 0 AND @iAccountId IS NOT NULL
							BEGIN
								SET @nSql = 'SELECT @pIsEft = IS_EFT_ACCOUNT FROM ' + @vDbName + 'ACCOUNT WHERE ACCOUNT_ID = @pAccId'
								
								SET @vLocation = 'IsEft'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pIsEft INT OUTPUT, @pAccId INT',
								@pAccId = @iAccountId,
								@pIsEft = @iIsEft OUTPUT

								IF @vDSTRBN_TYPE_CODE IS NULL OR @vDSTRBN_TYPE_CODE = ''
								BEGIN
									SET @nSql = 'SELECT @pDefDistTypeCode = DEF_DSTRBN_TYPE_CODE FROM ' + @vDbName + 'CHECK_OPTIONS'

									SET @vLocation = 'DefDistType'

									EXECUTE SP_EXECUTESQL @nSql,
									N'@pDefDistTypeCode INT OUTPUT',
									@pDefDistTypeCode = @iDistTypeCodeId OUTPUT
								END
					
								SET @nSql = 'SELECT @pDistTypeSCode = SHORT_CODE FROM' + @vDbName + 'CODES WHERE CODE_ID = @pDistTypeCodeId AND DELETED_FLAG = 0'
							
								SET @vLocation = 'DistTypeSCode'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pDistTypeSCode VARCHAR(25) OUTPUT, @pDistTypeCodeId INT',
								@pDistTypeCodeId = @iDistTypeCodeId,
								@pDistTypeSCode = @vDistTypeSCode OUTPUT
					
								IF (@vDistTypeSCode = 'MAL')
								BEGIN
									IF @iTransNumber = 0
									BEGIN
										SET @vErrMsgDesc = 'Check Number cannot be left empty for Distribution Type: MAL. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
									END

									IF @iChkStatCodeId <> @iPrintedStatus
									BEGIN
										SET @vErrMsgDesc = 'Check Status should be ''PRINTED'' for Distribution Type: MAL. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
									END
								END

								IF @iIsEft <> 0 AND @vDistTypeSCode = 'EFT'
								BEGIN
									SET @vErrMsgDesc = 'EFT Account is required for an EFT Transaction, Please Correct the data. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END

								IF @vDistTypeSCode NOT IN('EFT','MAL') AND @iChkStatCodeId = @iPrintedStatus
								BEGIN
									SET @nSql = 'SELECT @pRowId = ROW_ID FROM ' + @vDbName + 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE IN('
									SET @nSql = @nSql + 'SELECT CODE_ID FROM ' + @vDbName + 'CODES WHERE TABLE_ID = (SELECT TABLE_ID FROM ' + @vDbName + 'GLOSSARY'
									SET @nSql = @nSql + ' WHERE SYSTEM_TABLE_NAME = ''DISTRIBUTION_TYPE'') AND SHORT_CODE NOT IN(''EFT'',''MAL''))'

									SET @vLocation = 'ChkPrintOptns'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pRowId INT OUTPUT',
									@pRowId = @iRowId OUTPUT
						
									IF @iRowId IS NULL OR @iRowId = 0
									BEGIN
										SET @vErrMsgDesc = 'Mapping is missing in Print Check Options for DSTRBN_TYPE_CODE: ' + ISNULL(@vDistTypeSCode,'') + '. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
										SET @iErrCnt += 1
									END

								END

							END
							ELSE
							BEGIN
								SET @vErrMsgDesc = 'Account/Sub Acount doesnot exist in rmA. '
								IF @iUseSubAcc = 0
									SET @vErrColumns = 'BANK_SUB_ACCNT_NUM'
								ELSE
									SET @vErrColumns = 'BANK_ACCOUNT_NUM'

								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
						END*/		--JIRA 26252 knakra ends
						--Distribution Type Ends
					END
					--Carrier Clients Check for Policy related coverages and losses ends

					--JIRA 30818 knakra starts
					BEGIN TRY
						IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
						BEGIN
							--JIRA 38951 knakra starts
							IF @iPolCurrCodeId IS NULL OR @iPolCurrCodeId <= 0
								SET @iPolCurrCodeId = @iBaseCurrCodeId
							--JIRA 38951 knakra ends
							IF @vTRANSACTION_TYPE IN('R','P','C')
							BEGIN
								IF @iBaseCurrCodeId = @iClmCurrCodeId
									SET @dClmtoBaseCurrRate = 1
								ELSE
								BEGIN
									IF @dCLM_TO_BASE_CURR_RATE IS NULL OR @dCLM_TO_BASE_CURR_RATE = 0
									BEGIN
										SET @vLocation = 'ClmtoBaseErr'

										EXECUTE SP_EXECUTESQL @nSqlMC,
										N'@pCurrRowId INT OUTPUT, @pExchRate DECIMAL(20,2) OUTPUT, @pSrcCurr int, @pDestCurr int',
										@pSrcCurr = @iClmCurrCodeId,
										@pDestCurr = @iBaseCurrCodeId,
										@pExchRate = @dClmtoBaseCurrRate OUTPUT,
										@pCurrRowId = @iRowId OUTPUT

										IF @iRowId IS NULL OR @iRowId = 0
											SET @dClmtoBaseCurrRate = 1
									END
									ELSE IF @dCLM_TO_BASE_CURR_RATE IS NOT NULL AND @dCLM_TO_BASE_CURR_RATE <> 0
										SET @dClmtoBaseCurrRate = @dCLM_TO_BASE_CURR_RATE
								END

								IF @iClmCurrCodeId = @iPolCurrCodeId
									SET @dClmToPolCurrRate = 1
								ELSE IF @iPolCurrCodeId = @iBaseCurrCodeId
									SET @dClmToPolCurrRate = @dClmtoBaseCurrRate
								ELSE
								BEGIN
									IF @dCLM_TO_POL_CURR_RATE IS NULL OR @dCLM_TO_POL_CURR_RATE = 0
									BEGIN
										SET @vLocation = 'ClmtoPolErr'

										EXECUTE SP_EXECUTESQL @nSqlMC,
										N'@pCurrRowId INT OUTPUT, @pExchRate DECIMAL(20,2) OUTPUT, @pSrcCurr int, @pDestCurr int',
										@pSrcCurr = @iClmCurrCodeId,
										@pDestCurr = @iPolCurrCodeId,
										@pExchRate = @dClmToPolCurrRate OUTPUT,
										@pCurrRowId = @iRowId OUTPUT

										IF @iRowId IS NULL OR @iRowId = 0
											SET @dClmToPolCurrRate = 1
									END
									ELSE IF @dCLM_TO_POL_CURR_RATE IS NOT NULL AND @dCLM_TO_POL_CURR_RATE <> 0
										SET @dClmToPolCurrRate = @dCLM_TO_POL_CURR_RATE
								END
							END
							
							IF @vTRANSACTION_TYPE IN('C','P')
							BEGIN
								IF @iPmtCurrCodeId = @iClmCurrCodeId
									SET @dPmtToClmCurrRate = 1
								ELSE
								BEGIN
									IF @dPMT_TO_CLM_CURR_RATE IS NULL OR @dPMT_TO_CLM_CURR_RATE = 0
									BEGIN
										SET @vLocation = 'PmtToClmErr'

										EXECUTE SP_EXECUTESQL @nSqlMC,
										N'@pCurrRowId INT OUTPUT, @pExchRate DECIMAL(20,2) OUTPUT, @pSrcCurr int, @pDestCurr int',
										@pSrcCurr = @iPmtCurrCodeId,
										@pDestCurr = @iClmCurrCodeId,
										@pExchRate = @dPmtToClmCurrRate OUTPUT,
										@pCurrRowId = @iRowId OUTPUT

										IF @iRowId IS NULL OR @iRowId = 0
											SET @dPmtToClmCurrRate = 1
									END
									ELSE
										SET @dPmtToClmCurrRate = @dPMT_TO_CLM_CURR_RATE
								END

								IF @iPmtCurrCodeId = @iBaseCurrCodeId
									SET @dPmtToBaseCurrRate = 1
								ELSE
								BEGIN
									IF @dPMT_TO_BASE_CURR_RATE IS NULL OR @dPMT_TO_BASE_CURR_RATE = 0
									BEGIN
										SET @vLocation = 'PmtToBaseErr'

										EXECUTE SP_EXECUTESQL @nSqlMC,
										N'@pCurrRowId INT OUTPUT, @pExchRate DECIMAL(20,2) OUTPUT, @pSrcCurr int, @pDestCurr int',
										@pSrcCurr = @iPmtCurrCodeId,
										@pDestCurr = @iBaseCurrCodeId,
										@pExchRate = @dPmtToBaseCurrRate OUTPUT,
										@pCurrRowId = @iRowId OUTPUT

										IF @iRowId IS NULL OR @iRowId = 0
											SET @dPmtToBaseCurrRate = 1
									END
									ELSE
										SET @dPmtToBaseCurrRate = @dPMT_TO_BASE_CURR_RATE
								END
								
								IF @iIncPolCvg IS NOT NULL AND @iIncPolCvg <> 0 AND @iVarFinKey <> 0 AND @iVarFinKey IS NOT NULL
								BEGIN
									IF @iPolCurrCodeId = @iPmtCurrCodeId
										SET @dPmtToPolCurrRate = 1
									ELSE IF @iPolCurrCodeId = @iBaseCurrCodeId
										SET @dPmtToPolCurrRate = @dPmtToBaseCurrRate
									ELSE
									BEGIN
										IF @dPMT_TO_POL_CURR_RATE IS NULL OR @dPMT_TO_POL_CURR_RATE = 0
										BEGIN
											SET @vLocation = 'PmtToPolErr'

											EXECUTE SP_EXECUTESQL @nSqlMC,
											N'@pCurrRowId INT OUTPUT, @pExchRate DECIMAL(20,2) OUTPUT, @pSrcCurr int, @pDestCurr int',
											@pSrcCurr = @iPmtCurrCodeId,
											@pDestCurr = @iPolCurrCodeId,
											@pExchRate = @dPmtToPolCurrRate OUTPUT,
											@pCurrRowId = @iRowId OUTPUT

											IF @iRowId IS NULL OR @iRowId = 0
												SET @dPmtToPolCurrRate = 1
										END
										ELSE
											SET @dPmtToPolCurrRate = @dPMT_TO_POL_CURR_RATE
									END
								END
								ELSE
								BEGIN
									SET @dPmtToPolCurrRate = @dPmtToBaseCurrRate
									SET @iPolCurrCodeId = @iBaseCurrCodeId
								END
							END
						END
						ELSE
						BEGIN
							SET @dClmToPolCurrRate = 1
							SET @dClmtoBaseCurrRate = 1
							SET @dPmtToBaseCurrRate = 1
							SET @dPmtToClmCurrRate = 1
							SET @dPmtToPolCurrRate = 1
							SET @iClmCurrCodeId = @iBaseCurrCodeId
							SET @iPolCurrCodeId = @iBaseCurrCodeId
						END

						IF @vTRANSACTION_TYPE = 'R'
						BEGIN
							SET @dClmCurrAmt = @dInpAmt
							SET @dBaseCurrAmt = @dClmCurrAmt * @dClmtoBaseCurrRate
							SET @dPolCurrAmt = @dClmCurrAmt * @dClmToPolCurrRate
						END
						ELSE IF @vTRANSACTION_TYPE IN('P','C')
						BEGIN
							SET @dPmtCurrAmt = @dInpAmt
							SET @dBaseCurrAmt = @dPmtCurrAmt * @dPmtToBaseCurrRate
							SET @dClmCurrAmt = @dPmtCurrAmt * @dPmtToClmCurrRate
							SET @dPolCurrAmt = @dPmtCurrAmt * @dPmtToPolCurrRate
						END

					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = @vLocation + ERROR_MESSAGE() + ''
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', @vLocation, @vLocation, 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vLocation, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
					--JIRA 30818 knakra ends

					--JIRA 29954 knakra starts(Limit tracking Code moved below due to Policy Amount)
					--Check for Policy Limits Starts--
					IF @vTRANSACTION_TYPE = 'P' AND @iPolErr = 0 AND ((@iCarrierFlag <> 0 AND @iCarrierFlag IS NOT NULL AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iVarFinKey IS NOT NULL AND @iIncPolCvg IS NOT NULL AND @iIncPolCvg <> 0))
					BEGIN				
						DECLARE @iLimitCount INT = 0,
								@cLimitCursor CURSOR,
								@iCountLoop INT = 1,
								@vdbCvgKey VARCHAR(100) = '',
								@dLimitAmt DECIMAL(20,2) = 0.00,
								@iLimitCode INT = 0

						SET @nSql = 'SELECT @pLimitFlag = USE_LIMIT_TRACKING FROM ' + @vDbName + 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = @pLob'
							
						SET @vLocation = 'LimitFlag'

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pLimitFlag int OUTPUT, @pLob int',
						@pLob = @iLob,
						@pLimitFlag = @iLimitFlag OUTPUT

						IF @iLimitFlag <> 0
						BEGIN
							SET @nSql = 'SELECT @pLimitCount = COUNT(LIMIT_ROW_ID) FROM ' + @vDbName + 'POL_COV_LIMIT'
							SET @nSql = @nSql + ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' + @vDbName + 'CODE_X_CODE WHERE CODE1 = @pResTypeCodeId'
							SET @nSql = @nSql + ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' + @vDbName + 'CODES C, ' + @vDbName + 'GLOSSARY G WHERE'
							SET @nSql = @nSql + ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = ''RTTOLT'' AND G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE''))'
							SET @nSql = @nSql + ' AND POLICY_KEY = @pPolKey AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = @pCvgKey)'

							SET @vLocation = 'LimitCount'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pLimitCount INT OUTPUT, @pResTypeCodeId INT, @pPolKey VARCHAR(50), @pCvgKey VARCHAR(100)',
							@pResTypeCodeId = @iResTypeCodeId,
							@pPolKey = @vPolKey,
							@pCvgKey = @vCvgKey,
							@pLimitCount = @iLimitCount OUTPUT
							
							IF @iLimitCount > 0
							BEGIN
								IF @vPolKey IS NOT NULL AND @vCvgKey IS NOT NULL AND @vPolKey <> '' AND @vCvgKey <> ''
								BEGIN
									--JIRA 29954 knakra starts
									IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
										SET @nSql = 'SELECT @pAggAmtOnPol = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									ELSE
										SET @nSql = 'SELECT @pAggAmtOnPol = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									--JIRA 29954 knakra ends
									SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY, ' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE'
									SET @nSql = @nSql + ' WHERE POLICY.EXTERNAL_POLICY_KEY= @pPolKey AND POLICY.POLICY_ID = POLICY_X_UNIT.POLICY_ID AND'
									SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID= POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)'

									SET @vLocation = 'AggAmtOnPol'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pAggAmtOnPol DECIMAL(20,2) OUTPUT, @pPolKey varchar(50)',
									@pPolKey = @vPolKey,
									@pAggAmtOnPol = @dAggAmtOnPol OUTPUT
										
									--JIRA 29954 knakra starts
									IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
										SET @nSql = 'SELECT @pAggAmtOnCvg = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									ELSE
										SET @nSql = 'SELECT @pAggAmtOnCvg = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									--JIRA 29954 knakra ends
									SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY,' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE'
									SET @nSql = @nSql + ' WHERE POLICY.EXTERNAL_POLICY_KEY = @pPolKey AND POLICY.POLICY_ID=POLICY_X_UNIT.POLICY_ID AND'
									SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID AND POLICY_X_CVG_TYPE.COVERAGE_KEY = @pCvgKey)'

									SET @vLocation = 'AggAmtOnCvg'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pAggAmtOnCvg DECIMAL(20,2) OUTPUT, @pPolKey VARCHAR(50), @pCvgkey VARCHAR(100)',
									@pPolKey = @vPolKey,
									@pCvgKey = @vCvgKey,
									@pAggAmtOnCvg = @dAggAmtOnCvg OUTPUT

									--JIRA 29954 knakra starts
									IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
										SET @nSql = 'SELECT @pOccAmtOnPol = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									ELSE
										SET @nSql = 'SELECT @pOccAmtOnPol = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT RC, ' + @vDbName + 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID'
									--JIRA 29954 knakra ends
									SET @nSql = @nSql + ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' + @vDbName + 'POLICY_X_UNIT, ' + @vDbName + 'POLICY_X_CVG_TYPE WHERE'
									SET @nSql = @nSql + ' POLICY_X_UNIT.POLICY_ID = @pPolicyId AND POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)'

									SET @vLocation = 'OccAmtOnPol'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pOccAmtOnPol DECIMAL(20,2) OUTPUT, @pPolicyId INT',
									@pPolicyId = @iPolicyId,
									@pOccAmtOnPol = @dOccAmtOnPol OUTPUT

									--JIRA 29954 knakra starts
									IF @iMcFlag IS NOT NULL AND @iMcFlag <> 0 AND @fVersionNum >= 16.4
										SET @nSql = 'SELECT @pOccAmtOnCvg = SUM(POLICY_CURR_PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT,' + @vDbName + 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = @pCvgRowid'
									ELSE
										SET @nSql = 'SELECT @pOccAmtOnCvg = SUM(PAID_TOTAL) FROM ' + @vDbName + 'RESERVE_CURRENT,' + @vDbName + 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = @pCvgRowid'
									--JIRA 29954 knakra ends
									SET @nSql = @nSql + ' AND COVERAGE_X_LOSS.CVG_LOSS_ROW_ID = RESERVE_CURRENT.POLCVG_LOSS_ROW_ID'

									SET @vLocation = 'OccAmtOnCvg'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pOccAmtOnCvg DECIMAL(20,2) OUTPUT, @pCvgRowid INT',
									@pCvgRowId = @iPolCvgRowId,
									@pOccAmtOnCvg = @dOccAmtOnCvg OUTPUT

									SET @nSql = 'SET @pLimitCursor = CURSOR LOCAL STATIC FOR'
									SET @nSql = @nSql + ' SELECT LIMIT_AMOUNT, LIMIT_TYPE_CODE, COVERAGE_KEY FROM ' + @vDbName + 'POL_COV_LIMIT'
									SET @nSql = @nSql + ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' + @vDbName + 'CODE_X_CODE WHERE CODE1 = @pResTypeCodeId'
									SET @nSql = @nSql + ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' + @vDbName + 'CODES C, ' + @vDbName + 'GLOSSARY G WHERE'
									SET @nSql = @nSql + ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = ''RTTOLT'' AND G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE''))'
									SET @nSql = @nSql + ' AND POLICY_KEY = @pPolKey AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = @pCvgKey)'
									SET @nSql = @nSql + ' OPEN @pLimitCursor'

									SET @vLocation = 'InternalCurLimit'

									EXECUTE SP_EXECUTESQL @nSql,
									N' @pLimitCursor CURSOR OUTPUT, @pPolKey VARCHAR(50), @pCvgKey VARCHAR(100), @pResTypeCodeId INT',
									@pPolKey = @vPolKey,
									@pCvgKey = @vCvgKey,
									@pResTypeCodeId = @iResTypeCodeId,
									@pLimitCursor = @cLimitCursor OUTPUT																					

									FETCH FIRST FROM @cLimitCursor INTO @dLimitAmt, @iLimitCode, @vdbCvgKey

									WHILE @iCountLoop <= @iLimitCount
									BEGIN
										DECLARE @vParentLimit VARCHAR(50) = NULL
								
										SET @nSql = 'SELECT @pShortCode = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID IN('
										SET @nSql = @nSql + 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pCodeId)'

										SET @vLocation = 'ParentLimit'

										EXECUTE SP_EXECUTESQL @nSql,
										N' @pCodeid INT, @pShortCode VARCHAR(50) OUTPUT',
										@pCodeId = @iLimitCode,
										@pShortCode = @vParentLimit OUTPUT

										SET @vErrMsgDesc = 'Policy Limit exceeded for Policy with POLICY_NAME: ' + ISNULL(@vPOLICY_NAME,'')
										SET @vErrMsgDesc += ', POLICY_NUMBER: ' + ISNULL(@vPOLICY_NUMBER,'') + ', POLICY_SYMBOL: ' + ISNULL(@vPOLICY_SYMBOL,'')
										SET @vErrMsgDesc += ', MASTER_COMPANY: ' + ISNULL(@vMASTER_COMPANY,'') + ', LOCATION_COMPANY: ' + ISNULL(@vLOCATION_COMPANY,'')
										SET @vErrMsgDesc += ', MODULE_NO: ' + ISNULL(@vMODULE_NO,'')
										SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
										
										IF @vParentLimit = 'AGG'
										BEGIN
											IF @vdbCvgKey IS NOT NULL OR @vdbCvgKey <> ''
											BEGIN
												--IF @dLimitAmt < (@dAggAmtOnCvg + @fAMOUNT)
												IF (@dLimitAmt < (@dAggAmtOnCvg + @dPolCurrAmt) AND @iMcFlag IS NOT NULL AND @iMcFlag <> 0) OR (@dLimitAmt < (@dAggAmtOnCvg + @dBaseCurrAmt) AND (@iMcFlag IS NULL OR @iMcFlag = 0))
												BEGIN
													SET @vErrColumns += ',COVERAGE_CODE'
													SET @vErrMsgDesc += ', COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
													SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
													EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitCvgAgg', 'PolLimitCvgAgg', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
													SET @iErrCnt += 1
												END
											END
											ELSE
											BEGIN
												IF (@dLimitAmt < (@dAggAmtOnCvg + @dPolCurrAmt) AND @iMcFlag IS NOT NULL AND @iMcFlag <> 0) OR (@dLimitAmt < (@dAggAmtOnCvg + @dBaseCurrAmt) AND (@iMcFlag IS NULL OR @iMcFlag = 0))
												BEGIN
													SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
													EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitAgg', 'PolLimitAgg', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
													SET @iErrCnt += 1
												END
											END
										END
										ELSE IF @vParentLimit = 'OCC'
										BEGIN
											IF @vdbCvgKey IS NOT NULL AND @vdbCvgKey <> ''
											BEGIN
												--IF @dLimitAmt < (@dOccAmtOnCvg + @fAMOUNT)
												IF (@dLimitAmt < (@dOccAmtOnCvg + @dPolCurrAmt) AND @iMcFlag IS NOT NULL AND @iMcFlag <> 0) OR (@dLimitAmt < (@dOccAmtOnCvg + @dBaseCurrAmt) AND (@iMcFlag IS NULL OR @iMcFlag = 0))
												BEGIN
													SET @vErrColumns += ',COVERAGE_CODE'
													SET @vErrMsgDesc += ', COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
													SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
													EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitCvgOcc', 'PolLimitCvgOcc', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
													SET @iErrCnt += 1
												END
											END
											ELSE
											BEGIN
												IF (@dLimitAmt < (@dOccAmtOnCvg + @dPolCurrAmt) AND @iMcFlag IS NOT NULL AND @iMcFlag <> 0) OR (@dLimitAmt < (@dOccAmtOnCvg + @dBaseCurrAmt) AND (@iMcFlag IS NULL OR @iMcFlag = 0))
												BEGIN
													SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
													EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolLimitOcc', 'PolLimitOcc', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
													SET @iErrCnt += 1
												END
											END
										END
										FETCH NEXT FROM @cLimitCursor INTO @dLimitAmt, @iLimitCode, @vdbCvgKey
										
										SET @iCountLoop += 1
									END
									CLOSE @cLimitCursor
									DEALLOCATE @cLimitCursor
								END
								ELSE
								BEGIN	--policy key and coverage key can not be null for external policies and their coverages
									IF @vPolKey IS NULL
									BEGIN
										SET @vErrMsgDesc = 'POLICY KEY is null for POLICY NAME: ' +	ISNULL(@vPOLICY_NAME,'')
										SET @vErrMsgDesc += ', Invalid Policy in Database as it can not have NULL value for Carrier Clients. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										--JIRA 24633 knakra starts
										IF @vRECORD_TYPE = 'H'
											SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION'
										ELSE
											SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
										--JIRA 24633 knakra ends
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'PolKeyNull', 'PolKeyNull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1										
										SET @iErrCnt += 1
									END
									IF @vCvgKey IS NULL
									BEGIN
										SET @vErrMsgDesc = 'COVERAGE_KEY is null for COVERAGE_CODE: ' + ISNULL(@vCOVERAGE_CODE,'')
										SET @vErrMsgDesc = ', Invalid Coverage in Database as it can not have NULL value for Carrier Clients. '
										SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
										--JIRA 24633 knakra starts
										IF @vRECORD_TYPE = 'H'
											SET @vErrColumns = 'POLICY_NUMBER,MASTER_COMPANY,REGION'
										ELSE
											SET @vErrColumns = 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO'
										--JIRA 24633 knakra ends
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'CvgKeynull', 'CvgKeynull', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1										
										SET @iErrCnt += 1
									END
								END
							END
						END				
					END
					--JIRA 29954 knakra ends

					--JIRA 29544 starts(moved this code from above as Payment to Base Currency rate is required for duplicacy
					IF @vTRANSACTION_TYPE IN('P','C') AND (@oDontCheckDupPay = 0 OR @oDontCheckDupPay IS NULL)	--check for duplicate Payments
					BEGIN
						SET @nSql = 'SELECT @pTransId = F.TRANS_ID FROM ' + @vDbName + 'FUNDS F, ' + @vDbName
						IF @iVarFinKey <> 0 SET @nSql += 'RESERVE_CURRENT RC, ' + @vDbName	--JIRA 23831 knakra
						SET @nSql = @nSql + 'FUNDS_TRANS_SPLIT FTS WHERE F.CLAIM_ID = @pClaimId'
 						--Sdalvi3 Jira 65683 Start
						IF @vCHECK_STATUS = 'P' BEGIN SET @nSql = @nSql + ' AND F.CTL_NUMBER = @pCheckNum AND F.TRANS_DATE = @pActivityDate' END 
						ELSE BEGIN SET @nSql = @nSql + ' AND F.TRANS_DATE = @pActivityDate' END
						--Sdalvi3 Jira 65683 End
						SET @nSql = @nSql + ' AND F.TRANS_NUMBER = @pTransNumber'
						IF @vTRANSACTION_TYPE = 'P'
							SET @nSql = @nSql + ' AND F.PAYMENT_FLAG <> 0'
						ELSE
							SET @nSql = @nSql + ' AND F.PAYMENT_FLAG = 0'
						IF @vCHECK_STATUS = 'V'
							SET @nSql = @nSql + ' AND F.VOID_FLAG <> 0'
						ELSE
							SET @nSql = @nSql + ' AND F.VOID_FLAG = 0'
						SET @nSql = @nSql + ' AND F.TRANS_ID = FTS.TRANS_ID'
						--JIRA 23831 knakra starts
						IF @fVersionNum >= 19.1
						BEGIN
							SET @nSql = @nSql + ' AND F.STOP_PAY_FLAG = 0'
						END 
						IF @iVarFinKey = 0
							SET @nSql = @nSql + ' AND FTS.RESERVE_TYPE_CODE = @pResTypeCodeId'
						ELSE IF @iVarFinKey <> 0
						BEGIN
							SET @nSql += ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID'
							SET @nSql += ' AND RC.RESERVE_TYPE_CODE = @pResTypeCodeId'
							IF @iIncRsvSubType <> 0
								SET @nSql += ' AND RC.RESERVE_CATEGORY = @pResSubType'
						END
						--JIRA 23831 knakra ends
						SET @nSql = @nSql + ' AND (F.AMOUNT - @pAmount) >= 0'
						SET @nSql = @nSql + ' AND (F.AMOUNT - @pAmount) <= 0.009'
						
						BEGIN TRY
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pTransId INT OUTPUT, @pClaimId INT, @pCheckNum VARCHAR(12), @pActivityDate VARCHAR(8), @pTransNumber INT,
							@pResTypeCodeId INT, @pAmount DECIMAL(20,2), @pResSubType INT',
							@pClaimId = @iClaimId,
							@pCheckNum = @vCHECK_NO,
							@pActivityDate = @vACTIVITY_DATE,
							@pTransNumber = @iTransNumber,
							@pResTypeCodeId = @iResTypeCodeId,
							@pAmount = @dBaseCurrAmt,	--JIRA 29954 knakra
							@pResSubType = @iResSubTypeCodeId,	--JIRA 24633 knakra
							@pTransId = @iTransid OUTPUT
					
							IF @iTransid IS NOT NULL AND @iTransid <> 0
							BEGIN					
								SET @vErrMsgDesc = 'Duplicate Payment exists in the rmA Database. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								IF @vCHECK_STATUS = 'P' BEGIN  --Sdalvi3 Jira 65683
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DupPay', 'DupPay', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLAIM_ID,CHECK_NO,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								END --Sdalvi3 Jira 65683 Start
 								ELSE BEGIN
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DupPay', 'DupPay', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'CLAIM_ID,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
 								END
 								--Sdalvi3 Jira 65683 End
								SET @iErrCnt += 1
							END
						END TRY	
						BEGIN CATCH
							SET @vErrMsgDesc = 'DupPayErr, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','DupPayErr','DupPayErr','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END

					--Distribution Type Starts		--JIRA 26252 knakra starts(making it common for both carrier and corporate clients)
					IF @vTRANSACTION_TYPE in('P','C')
					BEGIN
						IF @iAccountId <> 0 AND @iAccountId IS NOT NULL
						BEGIN
							SET @nSql = 'SELECT @pIsEft = IS_EFT_ACCOUNT FROM ' + @vDbName + 'ACCOUNT WHERE ACCOUNT_ID = @pAccId'
								
							SET @vLocation = 'IsEft'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pIsEft INT OUTPUT, @pAccId INT',
							@pAccId = @iAccountId,
							@pIsEft = @iIsEft OUTPUT

							IF @vDSTRBN_TYPE_CODE IS NULL OR @vDSTRBN_TYPE_CODE = ''
							BEGIN
								SET @nSql = 'SELECT @pDefDistTypeCode = DEF_DSTRBN_TYPE_CODE FROM ' + @vDbName + 'CHECK_OPTIONS'

								SET @vLocation = 'DefDistType'

								EXECUTE SP_EXECUTESQL @nSql,
								N'@pDefDistTypeCode INT OUTPUT',
								@pDefDistTypeCode = @iDistTypeCodeId OUTPUT
							END
					
							SET @nSql = 'SELECT @pDistTypeSCode = SHORT_CODE FROM' + @vDbName + 'CODES WHERE CODE_ID = @pDistTypeCodeId AND DELETED_FLAG = 0'
							
							SET @vLocation = 'DistTypeSCode'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pDistTypeSCode VARCHAR(25) OUTPUT, @pDistTypeCodeId INT',
							@pDistTypeCodeId = @iDistTypeCodeId,
							@pDistTypeSCode = @vDistTypeSCode OUTPUT
					
							IF (@vDistTypeSCode = 'MAL')
							BEGIN
								IF @iTransNumber = 0
								BEGIN
									SET @vErrMsgDesc = 'Check Number cannot be left empty for Distribution Type: MAL. '
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END

								IF @iChkStatCodeId <> @iPrintedStatus
								BEGIN
									SET @vErrMsgDesc = 'Check Status should be ''PRINTED'' for Distribution Type: MAL. '
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END
							END
							
							--JIRA 43561 knakra starts
							IF @iTransNumber IS NOT NULL AND @iTransNumber > 0
							BEGIN
								SET @vDistTypeSCode = 'MAL'
								SET @iDistTypeCodeId = @iMalDistTypeCode

								IF @iChkStatCodeId <> @iPrintedStatus
								BEGIN
									SET @vErrMsgDesc = 'Status Code should be printed as Check Number is provided in the import file. '
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'TransNumDist', 'TransNumDist', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'STATUS_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END
							END
							--JIRA 43561 knakra ends

							IF @iIsEft = 0 AND @vDistTypeSCode = 'EFT'
							BEGIN
								SET @vErrMsgDesc = 'EFT Account is required for an EFT Transaction, Please Correct the data. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END

							IF @vDistTypeSCode NOT IN('EFT','MAL') AND @iChkStatCodeId = @iPrintedStatus
							BEGIN
								/*SET @nSql = 'SELECT @pRowId = ROW_ID FROM ' + @vDbName + 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE IN('	JIRA 27612
								SET @nSql = @nSql + 'SELECT CODE_ID FROM ' + @vDbName + 'CODES WHERE TABLE_ID = (SELECT TABLE_ID FROM ' + @vDbName + 'GLOSSARY'
								SET @nSql = @nSql + ' WHERE SYSTEM_TABLE_NAME = ''DISTRIBUTION_TYPE'') AND SHORT_CODE NOT IN(''EFT'',''MAL''))'
								*/

								SET @nSql = 'SELECT @pRowId = ROW_ID FROM ' + @vDbName + 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE = @pDistTypeCodeId'	--JIRA 27612

								SET @vLocation = 'ChkPrintOptns'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pRowId INT OUTPUT, @pDistTypeCodeId INT',
								@pRowId = @iRowId OUTPUT,
								@pDistTypeCodeId = @iDistTypeCodeId
						
								IF @iRowId IS NULL OR @iRowId = 0
								BEGIN
									SET @vErrMsgDesc = 'Mapping is missing in Print Check Options for DSTRBN_TYPE_CODE: ' + ISNULL(@vDistTypeSCode,'') + '. '
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, 'DSTRBN_TYPE_CODE', 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									SET @iErrCnt += 1
								END

							END

						END
						ELSE
						BEGIN
							SET @vErrMsgDesc = 'Account/Sub Acount doesnot exist in rmA. '
							SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
							IF @iUseSubAcc = 0
								SET @vErrColumns = 'BANK_SUB_ACCNT_NUM'
							ELSE
								SET @vErrColumns = 'BANK_ACCOUNT_NUM'

							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'VERR13', 'VERR13', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
							SET @iErrCnt += 1
						END
					END		--JIRA 26252 knakra ends
					--Distribution Type Ends

				END TRY
				BEGIN CATCH
					SET @vErrMsgDesc = @vLocation + ', ' + ERROR_MESSAGE() + '. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
					SET @iErrCnt += 1
				END CATCH

				--IF ((@iCarrierFlag <> 0 AND @iCvgLossRowId IS NOT NULL AND @iCvgLossRowId <> 0) OR @iCarrierFlag = 0) AND @vTRANSACTION_TYPE = 'R'	JIRA 23831 knakra
				IF ((@iCarrierFlag <> 0 AND @iCvgLossRowId IS NOT NULL AND @iCvgLossRowId <> 0 AND @iVarFinKey = 0) OR (@iCarrierFlag = 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iCvgLossRowId <> 0 AND @iCvgLossRowId IS NOT NULL AND @iIncPolCvg <> 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg = 0)) AND @vTRANSACTION_TYPE = 'R'		--JIRA 23831 knakra
				BEGIN
					IF @oChkDupReserves <> 0
					BEGIN					
						SET @nSql = 'SELECT @pRsvRowId = RSV_ROW_ID FROM ' + @vDbName + 'RESERVE_HISTORY WHERE'
						SET @nSql += ' RES_STATUS_CODE = @pResStatusCodeId AND '
						--JIRA 29954 knakra starts
						IF @fVersionNum >= 16.4
						BEGIN
							SET @nSql += '(CLAIM_CURRENCY_RESERVE_AMOUNT - @pAmount) >= 0 AND '
							SET @nSql += '(CLAIM_CURRENCY_RESERVE_AMOUNT - @pAmount) <= 0.009 '
						END
						ELSE
						BEGIN
							SET @nSql += '(RESERVE_AMOUNT - @pAmount) >= 0 AND '
							SET @nSql += '(RESERVE_AMOUNT - @pAmount) <= 0.009 '
						END
						--JIRA 29954 knakra ends
						SET @nSql += 'AND CLAIM_ID = @pClaimId'
						--JIRA 23831 knakra starts
						IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0)
							SET @nSql += ' AND CLAIMANT_EID = @pClaimantEid'
						IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 and @iIncRsvType <> 0)
							SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCodeId'
						--SET @nSql += ' AND UNIT_ID = @pUnitId' asharma590 jira RMA-65679
						--IF @iCarrierFlag <> 0	JIRA 23831 knakra
						IF (@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)
							SET @nSql += ' AND POLCVG_LOSS_ROW_ID = @pCvgLossRowId'
						IF @iVarFinKey <> 0 AND @iIncRsvSubType <> 0
							SET @nSql += ' AND RESERVE_CATEGORY = @pRsvSubType'
						--JIRA 23831 knakra ends
						SET @nSql += ' AND DATE_ENTERED = @pActivityDate'
						
						BEGIN TRY
							--EXECUTE SP_EXECUTESQL @nSql,	--check for duplicate reserves   
							--N' @pRsvRowId int OUTPUT, @pResStatusCodeId INT, @pAmount DECIMAL(20,2), @pClaimId INT,
							--@pClaimantEid INT, @pResTypeCodeId INT, @pCvgLossRowId INT, @pActivityDate VARCHAR(8), @pUnitId INT, @pRsvSubType INT',
							EXECUTE SP_EXECUTESQL @nSql,	--check for duplicate reserves     asharma590 jira RMA-65679
							N' @pRsvRowId int OUTPUT, @pResStatusCodeId INT, @pAmount DECIMAL(20,2), @pClaimId INT,
							@pClaimantEid INT, @pResTypeCodeId INT, @pCvgLossRowId INT, @pActivityDate VARCHAR(8), @pRsvSubType INT',
							@pResStatusCodeId = @iResStatusCodeId,
							@pAmount = @dInpAmt,
							@pClaimId = @iClaimId,
							@pClaimantEid = @iClaimantEid,
							@pResTypeCodeId = @iResTypeCodeId,
							@pCvgLossRowId = @iCvgLossRowId,
							@pActivityDate = @vACTIVITY_DATE,
							--@pUnitId = @iVehicleId, asharma590 jira RMA-65679
							@pRsvSubType = @iResSubTypeCodeId,	--JIRA 23831 knakra
							@pRsvRowId = @iRsvRowId OUTPUT
							
							IF @iRsvRowId IS NOT NULL AND @iRsvRowId <> 0
							BEGIN
								SET @vErrMsgDesc = 'Duplicate Reserve already exists in the database. Either unselect ''Check Duplicate Reserve Transactions'' on UI or correct data. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								IF @iVehicleId > 0 AND @iVehicleId IS NOT NULL
									SET @vErrColumns = 'UNIT_ID,RESERVE_TYPE,ACTIVITY_DATE,AMOUNT,RES_STATUS_CODE'
								ELSE
									SET @vErrColumns = 'CLMNT_LAST_NAME,CLMNT_FIRST_NAME,CLMNT_TAX_ID,RESERVE_TYPE,ACTIVITY_DATE,AMOUNT,RES_STATUS_CODE'

								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'DupRes', 'DupRes', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								SET @iErrCnt += 1
							END
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = 'DupResErr, ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','DupResErr','DupResErr','DDS_PROCESS_PAYMENT',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END
					
					--JIRA 30818 knakra starts
					IF @fVersionNum >= 16.4
					BEGIN
						SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID, @pCurRsvAmt = RESERVE_AMOUNT, '
						SET @nSql += '@pClmRsvAmt = CLAIM_CURRENCY_RESERVE_AMOUNT, @pPolRsvAmt = POLICY_CURR_RESERVE_AMOUNT'
						SET @nSql += ' FROM ' + @vDbName + 'RESERVE_CURRENT'
					END
					ELSE
						SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID, @pCurRsvAmt = RESERVE_AMOUNT FROM ' + @vDbName + 'RESERVE_CURRENT'
					
					SET @nSql += ' WHERE CLAIM_ID = @pClaimId'
					--JIRA 23831 knakra starts
					IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncClmnt <> 0)
						SET @nSql += ' AND CLAIMANT_EID = @pClaimantEid'
					IF @iVarFinKey = 0 OR (@iVarFinKey <> 0 AND @iIncRsvType <> 0)
						SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCodeId'
					IF @iVarFinKey <> 0 AND @iIncRsvSubType <> 0
						SET @nSql += ' AND RESERVE_CATEGORY = @pRsvSubType'
					--JIRA 23831 knakra ends
					--SET @nSql += ' AND UNIT_ID = @pUnitId' asharma590 jira RMA-65679
					
					--IF @iCarrierFlag <> 0	JIRA 23831 knakra
					IF (@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR (@iVarFinKey <> 0 AND @iIncPolCvg <> 0)	--JIRA 23831 knakra
						SET @nSql += ' AND POLCVG_LOSS_ROW_ID = @pCvgLossRowId'
					
					--EXECUTE SP_EXECUTESQL @nSql,	--reserve amount is fetched to calculate change amount
					--N' @pRcRowId int OUTPUT, @pCurRsvAmt decimal(20,2) OUTPUT, @pClaimantEid INT, 
					--@pResTypeCodeId INT, @pCvgLossRowId INT, @pClaimId INT, @pUnitId INT, @pRsvSubType INT,
					--@pClmRsvAmt decimal(20,2) OUTPUT, @pPolRsvAmt decimal(20,2) OUTPUT',
					EXECUTE SP_EXECUTESQL @nSql,	--reserve amount is fetched to calculate change amount asharma590 jira RMA-65679
					N' @pRcRowId int OUTPUT, @pCurRsvAmt decimal(20,2) OUTPUT, @pClaimantEid INT, 
					@pResTypeCodeId INT, @pCvgLossRowId INT, @pClaimId INT, @pRsvSubType INT,  
					@pClmRsvAmt decimal(20,2) OUTPUT, @pPolRsvAmt decimal(20,2) OUTPUT',
					@pClaimId = @iClaimId,
					@pClaimantEid = @iClaimantEid,
					@pResTypeCodeId = @iResTypeCodeId,
					@pCvgLossRowId = @iCvgLossRowId,
					--@pUnitId = @iVehicleId, asharma590 jira RMA-65679
					@pRsvSubType = @iResSubTypeCodeId,	--JIRA 23831 knakra
					@pRcRowId = @iRcRowId OUTPUT,
					@pCurRsvAmt = @dBaseCurrRsvAmt OUTPUT,
					@pClmRsvAmt = @dClmCurrRsvAmt OUTPUT,
					@pPolRsvAmt = @dPolCurrRsvAmt OUTPUT
					
					IF @iRcRowId IS NOT NULL AND @iRcRowId <> 0	--Paid Total and Collection Total are required if Reserves are made after Payments has been made
					BEGIN
						BEGIN TRY
							---udoni RMA-75601 starts
						IF @fVersionNum >=20.2
						BEGIN
							SET @nSql = 'SELECT @iCount_islocked_reserve = COUNT(IS_LOCKED) from'+ @vDbName +'RESERVE_CURRENT where RC_ROW_ID = @iRcRowId and ((IS_LOCKED = 1) or (IS_LOCKED = -1))'
							BEGIN TRY
								EXECUTE SP_EXECUTESQL @nSql,
								N'@iCount_islocked_reserve INT OUTPUT,
								@iRcRowId INT',
								@iCount_islocked_reserve = @iCount_islocked_reserve OUTPUT,
								@iRcRowId = @iRcRowId;
								if @iCount_islocked_reserve > 0
								BEGIN
									SET @vErrMsgDesc = 'Reserve is locked. Payment cannot be done or reserve cannot be updated.'
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									SET @vErrColumns = 'RESERVE_TYPE'
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'Resislocked', 'Resislocked', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									GOTO NEXTRECORD
								END
							END TRY
							BEGIN CATCH
								SET @vErrMsgDesc = ERROR_MESSAGE()
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','Reserve Current','Reserve Current','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
								SET @iBaseErr += 1
							END CATCH
						END
						---udoni RMA-75601 ends
							--JIRA 30818 knakra starts
							IF @fVersionNum >= 16.4 SET @iRsvUpdFlag = 1 ELSE SET @iRsvUpdFlag = 0

							IF @fVersionNum < 16.4
								--SET @fChangeAmt = @fAMOUNT - @fCurRsvAmt
								SET @fChangeAmt = @dInpAmt - @dBaseCurrRsvAmt
							ELSE
							BEGIN
								SET @dClmCurrChgAmt = @dClmCurrAmt - @dClmCurrRsvAmt
								---akumar523 RMA-63934 starts 
								-- IF @dClmCurrChgAmt IS NULL OR @dClmCurrChgAmt = 0
								-- BEGIN
									-- SET @dBaseCurrAmt = @dBaseCurrRsvAmt + (@dClmtoBaseCurrRate * 1)
									-- SET @dPolCurrAmt = @dPolCurrRsvAmt + (@dClmToPolCurrRate * 1)
								-- END
								-- ELSE
								---BEGIN
									SET @dBaseCurrAmt = @dBaseCurrRsvAmt + (@dClmtoBaseCurrRate * @dClmCurrChgAmt)
									SET @dPolCurrAmt = @dPolCurrRsvAmt + (@dClmToPolCurrRate * @dClmCurrChgAmt)
								---END
								----akumar523 RMA-63934 ends 
								SET @fChangeAmt = @dBaseCurrAmt - @dBaseCurrRsvAmt
								SET @dPolCurrChgAmt = @dPolCurrAmt - @dPolCurrRsvAmt
							END
							
							--JIRA 30818 knakra ends
							IF @fVersionNum >= 16.4
							BEGIN
								SET @nSql = 'SELECT @pSumAmt = SUM(FTS.AMOUNT), @pSumClmAmt = SUM(FTS.CLAIM_CURRENCY_AMOUNT), '
								SET @nSql += '@pSumPolAmt = SUM(FTS.POLICY_CURRENCY_AMOUNT) FROM ' + @vDbName + 'FUNDS F,'
							END
							ELSE
								SET @nSql = 'SELECT @pSumAmt = SUM(FTS.AMOUNT) FROM ' + @vDbName + 'FUNDS F,'

							SET @nSql = @nSql + @vDbName + 'FUNDS_TRANS_SPLIT FTS,'
							SET @nSql = @nSql + @vDbName + 'RESERVE_CURRENT RC'
							SET @nSql = @nSql + ' WHERE F.TRANS_ID = FTS.TRANS_ID'
							SET @nSql = @nSql + ' AND RC.RC_ROW_ID = FTS.RC_ROW_ID'
							SET @nSql = @nSql + ' AND RC.RC_ROW_ID = @pRcRowId'
							
							SET @nSql2 = @nSql + ' AND F.PAYMENT_FLAG = 0 AND F.COLLECTION_FLAG <> 0'
							
							SET @vLocation = 'ColTot'

							EXECUTE SP_EXECUTESQL @nSql2,
							N' @pSumAmt DECIMAL(20,2) OUTPUT, @pSumClmAmt DECIMAL(20,2) OUTPUT,
							@pSumPolAmt DECIMAL(20,2) OUTPUT, @pRcRowId INT',
							@pRcRowId = @iRcRowId,
							@pSumAmt = @dBaseCurrColTot OUTPUT,
							@pSumPolAmt = @dPolCurrColTot OUTPUT,	--JIRA 30818 knakra
							@pSumClmAmt = @dClmCurrColTot OUTPUT	--JIRA 30818 knakra

							IF @dBaseCurrColTot IS NULL
								SET @dBaseCurrColTot = 0
							--JIRA 30818 knakra starts
							IF @dPolCurrColTot IS NULL
								SET @dPolCurrColTot = 0
							IF @dClmCurrColTot IS NULL
								SET @dClmCurrColTot = 0
							--JIRA 30818 knakra ends

							SET @nSql2 = @nSql + ' AND F.PAYMENT_FLAG <> 0 AND F.COLLECTION_FLAG = 0'
							
							SET @vLocation = 'PaidTot'

							EXECUTE SP_EXECUTESQL @nSql2,
							N' @pSumAmt DECIMAL(20,2) OUTPUT, @pSumClmAmt DECIMAL(20,2) OUTPUT,
							@pSumPolAmt DECIMAL(20,2) OUTPUT, @pRcRowId INT',
							@pRcRowId = @iRcRowId,
							@pSumAmt = @dBaseCurrPaidTot OUTPUT,
							@pSumPolAmt = @dPolCurrPaidTot OUTPUT,	--JIRA 30818 knakra
							@pSumClmAmt = @dClmCurrPaidTot OUTPUT	--JIRA 30818 knakra
						
							IF @dBaseCurrPaidTot IS NULL
								SET @dBaseCurrPaidTot = 0
							--JIRA 30818 knakra starts
							IF @dPolCurrPaidTot IS NULL
								SET @dPolCurrPaidTot = 0
							IF @dClmCurrPaidTot IS NULL
								SET @dClmCurrPaidTot = 0
							--JIRA 30818 knakra ends
							
							SET @nSql = 'SELECT @pParentRsv = SHORT_CODE FROM ' + @vDbName + 'CODES WHERE CODE_ID = ('
							SET @nSql = @nSql + 'SELECT RELATED_CODE_ID FROM ' + @vDbName + 'CODES WHERE CODE_ID = @pResTypeCodeId)'
					
							SET @vLocation = 'ParentRsv'
							
							EXECUTE SP_EXECUTESQL @nSql,
							N' @pParentRsv varchar(25) OUTPUT, @pResTypeCodeId INT',
							@pResTypeCodeId = @iResTypeCodeId,
							@pParentRsv = @vParentRsvCode OUTPUT
					
							SET @nSql = 'SELECT @pColInRsvBal = COLL_IN_RSV_BAL, @pColInIncBal = COLL_IN_INCUR_BAL FROM ' + @vDbName + 'SYS_PARMS_LOB'
							SET @nSql = @nSql + ' WHERE LINE_OF_BUS_CODE = @pLob'
							
							SET @vLocation = 'LobParms'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pColInRsvBal int OUTPUT, @pColInIncBal int OUTPUT, @pLob INT',
							@pLob = @iLob,
							@pColInRsvBal = @iCollInRsvBal OUTPUT,
							@pColInIncBal = @iColInIncBal OUTPUT
					
							IF @vParentRsvCode <> 'R' AND @vParentRsvCode IS NOT NULL
							BEGIN
								--JIRA 30818 knakra starts
								IF @iCollInRsvBal <> 0 AND @iCollInRsvBal IS NOT NULL
								BEGIN
									IF @fVersionNum >= 16.4
									BEGIN											
										SET @dClmCurrBalAmt = @dClmCurrAmt - (@dClmCurrPaidTot - @dClmCurrColTot)
										SET @dPolCurrBalAmt = @dPolCurrAmt - (@dPolCurrPaidTot - @dPolCurrColTot)
									END
									SET @dBaseCurrBalAmt = @dBaseCurrAmt - (@dBaseCurrPaidTot - @dBaseCurrColTot)
								END
								ELSE IF @iCollInRsvBal = 0 OR @iCollInRsvBal IS NULL
								BEGIN
									IF @fVersionNum >= 16.4
									BEGIN											
										SET @dClmCurrBalAmt = @dClmCurrAmt - @dClmCurrPaidTot
										SET @dPolCurrBalAmt = @dPolCurrAmt - @dPolCurrPaidTot
									END
									SET @dBaseCurrBalAmt = @dBaseCurrAmt - @dBaseCurrPaidTot
								END
								--JIRA 30818 knakra ends

								IF @iCollInRsvBal <> 0 AND @iCollInRsvBal IS NOT NULL
								BEGIN
									IF @dBaseCurrBalAmt < 0
										SET @dBaseCurrIncAmt = @dBaseCurrPaidTot - @dBaseCurrColTot
									ELSE
										SET @dBaseCurrIncAmt = @dBaseCurrBalAmt + (@dBaseCurrPaidTot - @dBaseCurrColTot)
									IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt < 0
										SET @dClmCurrIncAmt = @dClmCurrPaidTot - @dClmCurrColTot
									ELSE IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt >= 0
										SET @dClmCurrIncAmt = @dClmCurrBalAmt + (@dClmCurrPaidTot - @dClmCurrColTot)
									IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt < 0
										SET @dPolCurrIncAmt = @dPolCurrPaidTot - @dPolCurrColTot
									ELSE IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt >= 0
										SET @dPolCurrIncAmt = @dPolCurrBalAmt + (@dPolCurrPaidTot - @dPolCurrColTot)
								END
								ELSE
								BEGIN
									IF @dBaseCurrBalAmt < 0
										SET @dBaseCurrIncAmt = @dBaseCurrPaidTot
									ELSE
										SET @dBaseCurrIncAmt = @dBaseCurrBalAmt + @dBaseCurrPaidTot
									IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt < 0
										SET @dClmCurrIncAmt = @dClmCurrPaidTot
									ELSE IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt >= 0
										SET @dClmCurrIncAmt = @dClmCurrBalAmt + @dClmCurrPaidTot
									IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt < 0
										SET @dPolCurrIncAmt = @dPolCurrPaidTot
									ELSE IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt >= 0
										SET @dPolCurrIncAmt = @dPolCurrBalAmt + @dPolCurrPaidTot
								END
								IF @iColInIncBal <> 0 AND @iColInIncBal IS NOT NULL
								BEGIN
									--JIRA 30818 knakra starts
									IF @fVersionNum >= 16.4
									BEGIN
										SET @dClmCurrIncAmt = @dClmCurrIncAmt - @dClmCurrColTot
										SET @dPolCurrIncAmt = @dPolCurrIncAmt - @dPolCurrColTot
									END
									SET @dBaseCurrIncAmt = @dBaseCurrIncAmt - @dBaseCurrColTot
									--JIRA 30818 knakra ends
								END
							
							END
							ELSE IF @vParentRsvCode = 'R'
							BEGIN
								--JIRA 30818 knakra starts
								IF @fVersionNum >= 16.4
								BEGIN
									SET @dClmCurrBalAmt = @dClmCurrAmt - @dClmCurrColTot
									SET @dPolCurrBalAmt = @dPolCurrAmt - @dPolCurrColTot
								END
								SET @dBaseCurrBalAmt = @dBaseCurrAmt - @dBaseCurrColTot
								
								IF @dBaseCurrBalAmt < 0
									SET @dBaseCurrIncAmt = @dBaseCurrColTot
								ELSE IF @dBaseCurrBalAmt >= 0
									SET @dBaseCurrIncAmt = @dBaseCurrBalAmt + @dBaseCurrColTot
								IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt < 0
									SET @dClmCurrIncAmt = @dClmCurrColTot
								ELSE IF @fVersionNum >= 16.4 AND @dClmCurrBalAmt >= 0
									SET @dClmCurrIncAmt = @dClmCurrBalAmt + @dClmCurrColTot
								IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt < 0
									SET @dPolCurrIncAmt = @dPolCurrColTot
								ELSE IF @fVersionNum >= 16.4 AND @dPolCurrBalAmt >= 0
									SET @dPolCurrIncAmt = @dPolCurrBalAmt + @dPolCurrColTot
								--JIRA 30818 knarka ends
							END
						END TRY
						BEGIN CATCH
							SET @vErrMsgDesc = @vLocation + ', ' + ERROR_MESSAGE() + '. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
							SET @iErrCnt += 1
						END CATCH
					END
				END
				
				SET @vLocation = 'SuppVal'

				IF  (@oFundSupp > 0)
					EXECUTE DDS_SUPPLEMENT @p_JOBID,@oConfigId,@p_UserId,'PAYMENT',@vDbName,@iDA_ROW_ID,@oAllowNewCodes,0,@iErrCnt,'V',0,0,0,0,0,0,0,0,0,0,@iTransid,0,0,0,'CLAIM_ID',@vCLAIM_ID,@iErrCntSupp OUTPUT
				
				SET @iErrCnt += @iErrCntSupp
				
				--JIRA 33594 kkaur25 starts
				IF((@iMcFlag <> 0 AND @dClmCurrChgAmt = 0) OR ((@iMcFlag = 0 OR @iMcFlag IS NULL) AND @fChangeAmt = 0)) AND @iRcRowId IS NOT NULL AND @iRcRowId > 0 AND @vTRANSACTION_TYPE = 'R'
				BEGIN
					IF @iErrCnt = 0 AND @iBaseErr = 0
					BEGIN
						SET @nSql = 'UPDATE DDS_PAYMENT SET INVALID_ROW = 0 WHERE JOBID = @pJobId AND DA_ROW_ID = @pDaRowId'
						
						EXECUTE sp_executesql @nSql,
						N'@pJobId INT, @pDaRowId INT',
						@pJobId = @P_JOBID,
						@pDaRowId = @iDA_ROW_ID
					END
					GOTO NEXTRECORD
				END
				--JIRA 33594 kkaur25 ends
				
				--Insert Part Starts
				IF @vTRANSACTION_TYPE IN('P','C') AND @iBaseErr = 0 AND @iErrCnt = 0
				BEGIN
					BEGIN TRY
						--IF @iCarrierFlag = 0	--JIRA 23831 knakra
						IF @iCarrierFlag = 0 OR @iVarFinKey <> 0
						BEGIN
							SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID FROM ' + @vDbName + 'RESERVE_CURRENT WHERE'
							--JIRA 23831 knakra starts
							--SET @nSql += ' CLAIM_ID = @pClaimId AND CLAIMANT_EID = @pClaimantEid AND RESERVE_TYPE_CODE = @pResTypeCodeid'
							SET @nSql += ' CLAIM_ID = @pClaimId AND RESERVE_TYPE_CODE = @pResTypeCodeId'
							IF @iIncClmnt <> 0
								SET @nSql += ' AND CLAIMANT_EID = @pClaimantEid'
							IF @iIncRsvSubType <> 0
								SET @nSql += ' AND RESERVE_CATEGORY = @pResCatCodeId'
							--JIRA 23831 knakra ends
							SET @nSql += ' AND UNIT_ID = @pVehicleId'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pClaimId INT, @pClaimantEid INT, @pVehicleId INT, @pResTypeCodeId INT, @pResCatCodeId INT, @pRcRowId INT OUTPUT',
							@pClaimId = @iClaimId,
							@pClaimantEid = @iClaimantEid,
							@pVehicleId = @iVehicleId,
							@pResTypeCodeId = @iResTypeCodeId,
							@pResCatCodeId = @iResSubTypeCodeId,	--JIRA 23831 knakra
							@pRcRowId = @iRcRowId OUTPUT

							--IF @iRcRowId IS NULL OR @iRcRowId = 0	--JIRA 23831 knakra
							IF (@iRcRowId IS NULL OR @iRcRowId = 0) AND @iVarFinKey = 0
							BEGIN
								SET @iReBalErrCnt = 0
								EXECUTE DDS_PROCESS_RSV_CUR_SQL @iClaimId, @iClaimantEid, @iVehicleId, @iLob, @iResTypeCodeId, 0, @iOpenResStatusCode, 1, @vACTIVITY_DATE, @iCvgLossRowid, @iPolCvgRowId, @vPOLICY_CVG_SEQNO, @vDbName, @P_JOBID, @iDA_ROW_ID, @vCLAIM_ID, @iVarFinKey, @iResSubTypeCodeId, @iHmiFlag, @vBEN_REVIEW_DATE,@iClaimMcFields, @iRsvMCFields, @iPolMCFields,@dClmCurrAmt, @dPolCurrAmt,@dClmtoBaseCurrRate, @dClmToPolCurrRate, @fVersionNum, @iClmCurrCodeId, @iPolCurrCodeId, @iRcRowId OUTPUT, @iReBalErrCnt OUTPUT	--JIRA 29954 knakra(added MC related parameters)
							
								IF @iReBalErrCnt > 0
								BEGIN
									SET @iErrCnt += 1
									GOTO NEXTRECORD
								END
							END
							ELSE IF (@iRcRowId IS NULL OR @iRcRowId = 0) AND @iVarFinKey <> 0
							BEGIN
								SET @vErrMsgDesc = 'Reserve doesnot exist in Riskmaster Database for this Payment. '
								SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
								SET @vErrColumns = 'CLAIM_ID;RESERVE_TYPE'
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'ResExistsVfk', 'ResExistsVfk', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
								GOTO NEXTRECORD
							END
						END
						---udoni RMA-75601 starts
						IF @fVersionNum >=20.2
						BEGIN
							SET @nSql = 'SELECT @iCount_islocked_reserve = COUNT(IS_LOCKED) from'+ @vDbName +'RESERVE_CURRENT where RC_ROW_ID = @iRcRowId and ((IS_LOCKED = 1) or (IS_LOCKED = -1))'
							BEGIN TRY
								EXECUTE SP_EXECUTESQL @nSql,
								N'@iCount_islocked_reserve INT OUTPUT,
								@iRcRowId INT',
								@iCount_islocked_reserve = @iCount_islocked_reserve OUTPUT,
								@iRcRowId = @iRcRowId;
								if @iCount_islocked_reserve > 0
								BEGIN
									SET @vErrMsgDesc = 'Reserve is locked. Payment cannot be done or reserve cannot be updated.'
									SET @vErrMsgDesc += 'Discarded Payment/Reserve is combination of transacation Date :' + ISNULL(@vTRANSACTION_DATE,'Transaction Date') + ', Check Number : '+ ISNULL(@vCHECK_NO,'0')+' and Amount :' +Ltrim(str(@dInpAmt,20,2))+'. '
									SET @vErrColumns = 'RESERVE_TYPE'
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT', 'Resislocked', 'Resislocked', 'DDS_PROCESS_PAYMENTS',@vErrMsgDesc, @vErrColumns, 'DDS_PAYMENT', 'CLAIM_ID', @vCLAIM_ID, 1
									GOTO NEXTRECORD
								END
							END TRY
							BEGIN CATCH
								SET @vErrMsgDesc = ERROR_MESSAGE()
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','Reserve Current','Reserve Current','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
								SET @iBaseErr += 1
							END CATCH
						END
						---udoni RMA-75601 ends
						SET @nSql = 'SELECT @pTransId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''FUNDS'''

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pTransId INT OUTPUT',
						@pTransId = @iTransId OUTPUT

						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');

						IF @oAttachTransIdToChkNum <> 0 AND @oAttachTransIdToChkNum IS NOT NULL AND @vCHECK_NO IS NOT NULL
							SET @vCHECK_NO += '-' + CAST(@iTransId AS VARCHAR)
						
						--JIRA 38951 knakra starts
						SET @iRetVal = 0
						EXECUTE spCheckVersion 'FUNDS','EFT_FLAG',@P_DB_NAME,@iRetVal OUTPUT
						--JIRA 28951 knakra ends

						 --Sdalvi3 Jira 65683 Start
						IF @vCHECK_STATUS <> 'P'
							IF @vCHECK_NO IS NULL OR @vCHECK_NO = '' 
							BEGIN
								SET @vCHECK_NO = '0' + CAST(@iTransId AS VARCHAR)
							END
						--Sdalvi3 Jira 65683 End
						--JIRA 23831 knakra starts
						SET @nSql = 'INSERT INTO ' + @vDbName + 'FUNDS(TRANS_ID, CLAIM_ID, CLAIM_NUMBER, TRANS_DATE, DATE_OF_CHECK, CTL_NUMBER,'
						IF @iVarFinKey = 0
							SET @nSql += ' CLAIMANT_EID, UNIT_ID,'
						--JIRA 23831 knakra ends
						SET @nSql += ' PAY_TO_THE_ORDER_OF, MANUAL_CHECK,'
						SET @nSql += ' TRANS_NUMBER, AMOUNT, ACCOUNT_ID, SUB_ACCOUNT_ID, STATUS_CODE, PAYEE_TYPE_CODE, PAYEE_EID, LAST_NAME, '
						SET @nSql += 'FIRST_NAME, ADDR1, ADDR2, CITY, STATE_ID, ZIP_CODE, PAYMENT_FLAG, COLLECTION_FLAG, VOID_FLAG, DTTM_RCD_ADDED, '
						SET @nSql += 'ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER, CHECK_MEMO, CLEARED_FLAG ,AUTO_CHECK_FLAG, PRECHECK_FLAG, FILED_1099_FLAG, VOID_DATE, VOID_REASON,' 
						
						--JIRA 29554 knakra starts
						IF @fVersionNum < 16.4
							SET @nSql += 'PMT_CURRENCY_CODE, PMT_CURRENCY_AMOUNT, PMT_TO_BASE_CUR_RATE, CLAIM_CURRENCY_CODE, CLAIM_CURRENCY_AMOUNT, PMT_TO_CLAIM_CUR_RATE, BASE_TO_PMT_CUR_RATE, BASE_TO_CLAIM_CUR_RATE, '
						ELSE IF @fVersionNum >= 16.4
							SET @nSql += 'PMT_CURRENCY_CODE, PMT_CURRENCY_AMOUNT, CLAIM_CURRENCY_CODE, CLAIM_CURRENCY_AMOUNT, POLICY_CURRENCY_CODE, POLICY_CURRENCY_AMOUNT, '
						--JIRA 29544 knakra ends

						SET @nSql += 'BILL_TYPE, WITHHOLDING_PMT_FLAG, WITHHOLDING_TYPE, WITHHOLDING_CHILD_FLAG, PARENT_TRANS_ID, COMBINED_PAY_FLAG, DORMANCY_STATUS, RES_SUPP_PAYMENT_FLAG, DSTRBN_TYPE_CODE'
						--JIRA 24366 knakra starts
						IF @iHmiFlag <> 0
							SET @nSql += ', EOB_PRINT_DATE, EOB_PRINTED_BY_USER'
						--JIRA 24633 knakra ends

						--JIRA 38951 knakra starts
						IF @iRetVal = 1
							SET @nSql += ', EFT_FLAG'
						--JIRA 38951 knakra ends
						IF @fVersionNum >=19.1---asharma590
						BEGIN
							SET @nSql+= ', READY_TO_PRINT'
						END 
						--JIRA 23831 knakra starts
						SET @nSql += ') VALUES( @pTransId, @pClaimId, @pClaimNumber, @pTransDate, @pDateOfCheck, @pCtlNum,'
						IF @iVarFinKey = 0
							SET @nSql += ' @pClaimantEid, @pUnitId,'
						SET @nSql += ' @pPayToTheOrderOf, @pManualChck,'
						--JIRA 23831 knakra ends
						SET @nSql += ' @pTransNum, @pAmount, @pAccId, @pSubAccId, @pStatusCode, @pPayeeTypeCode, @pPayeeEid, @pLastName, '
						SET @nSql += '@pFirstName, @pAddr1, @pAddr2, @pCity, '
						IF @vPAYEE_STATE IS NULL
							SET @nSql += 'NULL, '
						ELSE
							SET @nSql += '@pStateId,' 					
						SET @nSql += '@pZipCode, @pPaymentFlag, @pCollectionFlag, @pVoidFlag, @pDttmRcdAdded, '
						SET @nSql += '@pAddedByUser, @pDttmRcdLastUpd, @pUpdatedByUser, @pChckMemo, @pClearedFlag, 0, 0, 0, '
					
						IF @vCHECK_STATUS <> 'V'
						BEGIN
							IF @iClearedFlag = 1
								SET @nSql += '@pVoidDate, NULL,'
							ELSE
								SET @nSql += 'NULL, NULL,'
						END
						ELSE IF @vCHECK_STATUS = 'V'
							SET @nSql += '@pVoidDate, @pVoidReason,'
						
						--JIRA 29554 knakra starts
						IF @fVersionNum < 16.4
							SET @nSql += '0, @pPmtCurAmt, 1, 0, @pClaimCurAmt, 1, 1, 1, '
						ELSE IF @fVersionNum >= 16.4
							SET @nSql += '@pPmtCurrCode, @pPmtCurAmt, @pClmCurrCode, @pClaimCurAmt, @pPolCurrCode, @pPolCurrAmt, '
						SET @nSql += '0, 0, 0, 0, 0, 0, 0,@pResSuppPaymentFlag, @pDstrbnTypeCodeId'
						--JIRA 24633 knakra starts
						IF @iHmiFlag <> 0
							SET @nSql += ', @pEobPrintDate, @pEobPrintedByUsr'
						--JIRA 24633 knakra ends

						--JIRA 38951 knakra starts
						IF @iRetVal = 1
						BEGIN
							IF @vDistTypeSCode = 'EFT'
								SET @nSql += ', -1'
							ELSE
								SET @nSql += ', 0'
						END
						--JIRA 38951 knakra ends

						--asharma590 starts 
						IF @fVersionNum >=19.1
						BEGIN
							SET @nSql+= ', @pReadyToPrint'
						END 
						--asharma 590 ends 
						SET @nSql += ')'

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pTransId INT, @pClaimId INT, @pClaimNumber VARCHAR(25), @pTransDate VARCHAR(8), @pDateOfCheck VARCHAR(8), @pCtlNum VARCHAR(25), 
						@pClaimantEid INT, @pPayToTheOrderOf VARCHAR(MAX), @pManualChck INT, @pUnitId INT, @pTransNum BIGINT, @pAmount DECIMAL(20,2), 
						@pAccId INT, @pSubAccId INT, @pStatusCode INT, @pPayeeTypeCode INT, @pPayeeEid INT, @pLastName VARCHAR(255), 
						@pFirstName VARCHAR(255), @pAddr1 VARCHAR(100), @pAddr2 VARCHAR(100), @pCity VARCHAR(50), @pStateId INT, @pZipCode VARCHAR(10), @pPaymentFlag INT, 
						@pCollectionFlag INT, @pVoidFlag INT, @pDttmRcdAdded VARCHAR(16),@pAddedByUser VARCHAR(50), @pDttmRcdLastUpd VARCHAR(14), @pUpdatedByUser VARCHAR(50),
						@pChckMemo VARCHAR(255), @pClearedFlag INT, @pVoidDate VARCHAR(8), @pVoidReason VARCHAR(255),
						@pPmtCurAmt DECIMAL(20,2), @pClaimCurAmt DECIMAL(20,2), @pResSuppPaymentFlag INT, @pDstrbnTypeCodeId INT, @pEobPrintDate VARCHAR(8), @pEobPrintedByUsr VARCHAR(50),
						@pPmtCurrCode int, @pClmCurrCode int, @pPolCurrCode int, @pPolCurrAmt decimal(20,2),	--JIRA 29954 knakra
						@pReadyToPrint INT',-----ASHARMA590
						@pTransId = @iTransid,
						@pClaimId = @iClaimId,
						@pClaimNumber = @vCLAIM_ID,
						@pTransDate = @vACTIVITY_DATE,
						@pDateOfCheck = @vTRANSACTION_DATE,
						@pCtlNum = @vCHECK_NO,
						@pClaimantEid = @iClaimantEid,
						@pPayToTheOrderOf = @vPayToTheOrderOf,
						@pManualChck = 0,
						@pUnitId = @iVehicleId,
						@pTransNum = @iTransNumber,
						--@pAmount = @fAMOUNT,	JIRA 29954 knakra
						@pAmount = @dBaseCurrAmt,	--JIRA 29954 knakra
						@pAccId = @iAccountId,
						@pSubAccId = @iSubAccId,
						@pStatusCode = @iChkStatCodeId,
						@pPayeeTypeCode = @iPayeeTypeCodeId,
						@pPayeeEid = @iPayeeEid,
						@pLastName = @vPAYEE_LASTNAME,
						@pFirstName = @vPAYEE_FIRSTNAME,
						@pAddr1 = @vPAYEE_ADDRESS,
						@pAddr2 = @vPAYEE_ADDRESS2,
						@pCity = @vPAYEE_CITY,
						@pStateId = @iStateRowId,
						@pZipCode = @vPAYEE_ZIP,
						@pPaymentFlag = @iPayFlag,
						@pCollectionFlag = @iColFlag,
						@pVoidFlag = @iVoidFlag,
						@pDttmRcdAdded = @vSysDateTime,
						@pAddedByUser = 'DADDS',
						@pDttmRcdLastUpd = @vSysDateTime,
						@pUpdatedByUser = 'DADDS',
						@pChckMemo = @vMEMO,
						@pClearedFlag = @iClearedFlag,
						@pVoidDate = @vDATE_CLEARED,
						@pVoidReason = @vVOID_CODE_REASON,
						--JIRA 29954 knakra starts
						--@pPmtCurAmt = @fAMOUNT,
						--@pClaimCurAmt = @fAMOUNT,
						@pPmtCurAmt = @dPmtCurrAmt,
						@pClaimCurAmt = @dClmCurrAmt,
						@pPolCurrAmt = @dPolCurrAmt,
						@pPmtCurrCode = @iPmtCurrCodeId,
						@pClmCurrCode = @iClmCurrCodeId,
						@pPolCurrCode = @iPolCurrCodeId,
						--JIRA 29954 knakra ends
						@pResSuppPaymentFlag = @iResSuppPaymentFlag,
						@pDstrbnTypeCodeId = @iDistTypeCodeId,
						@pEobPrintDate = @vEOB_PRINTED_DATE,	--JIRA 24633 knakra
						@pEobPrintedByUsr = @vEOB_PRINTED_BY_USER,	--JIRA 24633 knakra
						@pReadyToPrint =  @iReadytoprint   ----asharma590
						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''FUNDS'''

						EXECUTE SP_EXECUTESQL @nSql

						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');

						SET @nSql = 'SELECT @pPayeeRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''FUNDS_X_PAYEE'''
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pPayeeRowId INT OUTPUT',
						@pPayeeRowId = @iPayeeRowId	OUTPUT

						SET @nSql = 'INSERT INTO ' + @vDbName + 'FUNDS_X_PAYEE(PAYEE_ROW_ID, FUNDS_TRANS_ID,PAYEE_1099_FLAG,PAYEE_TYPE_CODE,PAYEE_EID,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,'
						SET @nSql += 'ADDED_BY_USER, UPDATED_BY_USER'
						SET @nSql += ') VALUES(@pPayeeRowId, @pTransId, 0, @pPayeeTypeCodeId, @pPayeeEid, @pDttm, @pDttm, @pUser, @pUser)'

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pPayeeRowId INT, @pTransId INT, @pPayeeTypeCodeId INT, @pPayeeEid INT, @pDttm VARCHAR(14), @pUser VARCHAR(50)',
						@pPayeeRowId = @iPayeeRowId,
						@pTransId = @iTransid,
						@pPayeeTypeCodeId = @iPayeeTypeCodeId,
						@pPayeeEid = @iPayeeEid,
						@pDttm = @vSysDateTime,
						@pUser = 'DADDS'

						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''FUNDS_X_PAYEE'''

						EXECUTE SP_EXECUTESQL @nSql

						SET @nSql = 'SELECT @pSplitRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''FUNDS_TRANS_SPLIT'''

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pSplitRowId INT OUTPUT',
						@pSplitRowId = @iSplitRowId OUTPUT

						IF @vTRANSACTION_TYPE = 'C'
							SET @dSumAmount = - @dBaseCurrAmt
						ELSE
							SET @dSumAmount = @dBaseCurrAmt

						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
						
						--JIRA 23831 knakra starts
						--SET @nSql = 'INSERT INTO ' + @vDbName + 'FUNDS_TRANS_SPLIT(SPLIT_ROW_ID,RC_ROW_ID,POLCVG_ROW_ID,TRANS_ID,RESERVE_TYPE_CODE,'
						SET @nSql = 'INSERT INTO ' + @vDbName + 'FUNDS_TRANS_SPLIT(SPLIT_ROW_ID,RC_ROW_ID, TRANS_ID, '
						IF @iVarFinKey = 0
							SET @nSql += ' POLCVG_ROW_ID,RESERVE_TYPE_CODE,'
						--JIRA 23831 knakra ends
						SET @nSql += 'TRANS_TYPE_CODE,AMOUNT,FROM_DATE,TO_DATE,SUM_AMOUNT,INVOICE_NUMBER,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,'
						--JIRA 29954 knakra starts
						--SET @nSql += 'UPDATED_BY_USER, SUPP_PAYMENT_FLAG,PMT_CURRENCY_AMOUNT,PMT_CURRENCY_INVOICE_AMOUNT,PMT_CURRENCY_AUTO_DISCOUNT,'
						SET @nSql += 'UPDATED_BY_USER, SUPP_PAYMENT_FLAG,'
						IF @fVersionNum < 16.4
						BEGIN
							SET @nSql += 'PMT_CURRENCY_AMOUNT,PMT_CURRENCY_INVOICE_AMOUNT,PMT_CURRENCY_AUTO_DISCOUNT,'
							--SET @nSql += 'CLAIM_CURRENCY_AMOUNT,CLAIM_CURRENCY_INVOICE_AMOUNT,CLAIM_CURRENCY_AUTO_DISCOUNT,POLICY_SYSTEM_ID,WITHHOLDING_SPLIT_FLAG'
							SET @nSql += 'CLAIM_CURRENCY_AMOUNT,CLAIM_CURRENCY_INVOICE_AMOUNT,CLAIM_CURRENCY_AUTO_DISCOUNT,'
						END
						ELSE IF @fVersionNum >= 16.4
						BEGIN
							SET @nSql += 'PMT_CURRENCY_AMOUNT, PMT_CURRENCY_AUTO_DISCOUNT, CLAIM_CURRENCY_AMOUNT, CLAIM_CURRENCY_AUTO_DISCOUNT, '
							SET @nSql += 'POLICY_CURRENCY_AMOUNT, PMT_TO_BASE_CUR_RATE, PMT_TO_CLAIM_CUR_RATE, PMT_TO_POLICY_CUR_RATE, '
						END
						SET @nSql += 'POLICY_SYSTEM_ID,WITHHOLDING_SPLIT_FLAG'
						--JIRA 29954 knakra ends
						--JIRA 23831 knakra starts
						--SET @nSql += ') VALUES(@pSplitRowId, @pRcRowId, @pPolCvgRowId, @pTransId, @pResTypeCodeId, @pTransTypeCodeId, @pAmount, @pFromDate,'
						SET @nSql += ') VALUES(@pSplitRowId, @pRcRowId, @pTransId,'
						IF @iVarFinKey = 0
							SET @nSql += ' @pPolCvgRowId, @pResTypeCodeId,'
						SET @nSql += ' @pTransTypeCodeId, @pAmount, @pFromDate,'
						--JIRA 23831 knakra ends
						--JIRA 29954 knakra starts
						--SET @nSql += '@pToDate, @pSumAmount, @pInvNum, @pDttm, @pUser, @pDttm, @pUser, 0, @pPmtCurAmt, @pPmtCurAmt, 0, @pPmtCurAmt, @pPmtCurAmt, 0, @pPolSysId, 0'
						SET @nSql += '@pToDate, @pSumAmount, @pInvNum, @pDttm, @pUser, @pDttm, @pUser, 0, '
						IF @fVersionNum < 16.4
							SET @nSql += '@pPmtCurAmt, @pPmtCurAmt, 0, @pPmtCurAmt, @pPmtCurAmt, 0, '
						ELSE IF @fVersionNum >= 16.4
						BEGIN
							SET @nSql += '@pPmtCurAmt, 0, @pClmCurrAmt, 0, @pPolCurrAmt, @pPmtToBaseRate, @pPmtToClmRate, @pPmtToPolRate, '
						END
						SET @nSql += '@pPolSysId, 0'
						--JIRA 29954 knakra ends
						SET @nSql += ')'

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pSplitRowId INT, @pRcRowId INT, @pPolCvgRowId INT, @pTransId INT, @pResTypeCodeId INT, @pTransTypeCodeId INT, @pAmount DECIMAL(20,2),
						@pFromDate VARCHAR(8), @pToDate VARCHAR(8), @pSumAmount DECIMAL(20,2), @pInvNum VARCHAR(30), @pDttm VARCHAR(14), @pUser VARCHAR(50),
						@pPmtCurAmt DECIMAL(20,2), @pPolSysId INT, @pClmCurrAmt decimal(20,2), @pPolCurrAmt decimal(20,2), @pPmtToBaseRate decimal(20,2),
						@pPmtToClmRate decimal(20,2), @pPmtToPolRate decimal(20,2)',
						@pSplitRowId = @iSplitRowId,
						@pRcRowId = @iRcRowId,
						@pPolCvgRowId = @iPolCvgRowId,
						@pTransId = @iTransid,
						@pResTypeCodeId = @iResTypeCodeId,
						@pTransTypeCodeId = @iTransTypeCodeId,
						@pAmount = @dBaseCurrAmt,
						@pFromDate = @vSERVICE_FROM_DATE,
						@pToDate = @vSERVICE_TO_DATE,
						@pSumAmount = @dSumAmount,
						@pInvNum = @vINVOICE_NUMBER,
						@pDttm = @vSysDateTime,
						@pUser = 'DADDS',
						@pPmtCurAmt = @dPmtCurrAmt,
						@pPolSysId = @iPolSysId,
						@pClmCurrAmt = @dClmCurrAmt,	--JIRA 29954 knakra starts
						@pPolCurrAmt = @dPolCurrAmt,
						@pPmtToBaseRate = @dPmtToBaseCurrRate,
						@pPmtToClmRate = @dPmtToClmCurrRate,
						@pPmtToPolRate = @dPmtToPolCurrRate	--JIRA 29954 knakra ends

						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''FUNDS_TRANS_SPLIT'''

						EXECUTE SP_EXECUTESQL @nSql
						
						--JIRA 24633 knakra starts
						IF @iHmiFlag <> 0 AND @vRECORD_TYPE = 'H'
						BEGIN
							SET @iCountLoop = 1
							WHILE @iCountLoop <= 5
							BEGIN
								IF @iCountLoop = 1 SET @iCodeId = @iEobRemarksCode1
								ELSE IF @iCountLoop = 2 SET @iCodeId = @iEobRemarksCode2
								ELSE IF @iCountLoop = 3 SET @iCodeId = @iEobRemarksCode3
								ELSE IF @iCountLoop = 4 SET @iCodeId = @iEobRemarksCode4
								ELSE IF @iCountLoop = 5 SET @iCodeId = @iEobRemarksCode5

								IF @iCodeId IS NOT NULL AND @iCodeId <> 0
								BEGIN
									SET @nSql = 'INSERT INTO ' + @vDbName + 'FTS_X_REMARKS(SPLIT_ROW_ID,EOB_REMARKS_CODE) VALUES('
									SET @nSql += '@pSlitRowId, @pEobRemarksCode)'

									EXECUTE SP_EXECUTESQL @nSql,
									N'@pSplitRowid INT, @pEobRemarksCode',
									@pSplitRowId = @iSplitRowId,
									@pEobRemarksCode = @iCodeId
								END

								SET @iCountLoop += 1
							END
						END
						--JIRA 24633 knakra ends

						IF @oRecalReserves <> 0
						BEGIN
						---akumar523 starts  60666
							--EXECUTE DDS_RESERVE_REBAL_SQL @iClaimId, @iClaimantEid, @iREsTypeCodeid, @iCvgLossRowId, @iRcRowId, @vTRANSACTION_TYPE, @vACTIVITY_DATE, @iCarrierFlag, @vDbName, @P_JOBID, @iDA_ROW_ID, @vCLAIM_ID, @iVarFinKey, @iResSubTypeCodeId, @iHmiFlag, @vBEN_REVIEW_DATE,@iClaimMcFields, @iRsvMCFields, @iPolMCFields,@iClmCurrCodeId, @iPolCurrCodeId, @dClmtoBaseCurrRate, @dClmToPolCurrRate, @fVersionNum, @iReBalErrCnt OUTPUT	--JIRA 29954 knakra(MC parameters added) 
							EXECUTE DDS_RESERVE_REBAL_SQL @iClaimId, @iClaimantEid, @iREsTypeCodeid, @iCvgLossRowId, @iRcRowId, @vTRANSACTION_TYPE, @vACTIVITY_DATE, @iCarrierFlag, @vDbName, @P_JOBID, @iDA_ROW_ID, @vCLAIM_ID, @iVarFinKey, @iResSubTypeCodeId, @iHmiFlag, @vBEN_REVIEW_DATE,@iClaimMcFields, @iRsvMCFields, @iPolMCFields,@iClmCurrCodeId, @iPolCurrCodeId, @dClmtoBaseCurrRate, @dClmToPolCurrRate, @fVersionNum, @vCheckStatus, @dClmCurrAmt, @dPolCurrAmt, @dBaseCurrAmt, @iReBalErrCnt OUTPUT	--akumar523 added checkstatus only for print tot calculation
						---akumar523 ends  60666
						END
						
						SET @vLocation = 'SuppIns'
						IF @oFundSupp > 0
							EXECUTE DDS_SUPPLEMENT @p_JOBID,@oConfigId,@p_UserId,'PAYMENT',@vDbName,@iDA_ROW_ID,@oAllowNewCodes,0,@iErrCnt,'I',0,0,0,0,0,0,0,0,0,0,@iTransid,0,0,0,'CLAIM_ID',@vCLAIM_ID,@iErrCntSupp OUTPUT	--knakra(2 parameters were missing, added those for MedWatch Supp part)

						IF @iReBalErrCnt = 0 OR @iReBalErrCnt IS NULL
							UPDATE DDS_PAYMENT SET INVALID_ROW = 0 WHERE JOBID = @P_JOBID AND DA_ROW_ID = @iDA_ROW_ID						

					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'PayIns, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','PayIns','PayIns','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				ELSE IF @vTRANSACTION_TYPE = 'R' AND @iBaseErr = 0 AND @iErrCnt = 0
				BEGIN

					BEGIN TRY
						SET @nSql = 'SELECT @pRcRowId = RC_ROW_ID FROM ' + @vDbName + 'RESERVE_CURRENT WHERE '
						--JIRA 23831 knakra starts
						--SET @nSql += 'CLAIM_ID = @pClaimId AND CLAIMANT_EID = @pClaimantEid AND RESERVE_TYPE_CODE = @pResTypeCodeId'
						SET @nSql += 'CLAIM_ID = @pClaimId '
						IF (@iVarFinKey <> 0 AND @iIncClmnt <> 0) OR @iVarFinKey = 0
							SET @nSql += ' AND CLAIMANT_EID = @pClaimantEid'
						IF (@iVarFinKey <> 0 AND @iIncRsvType <> 0) OR @iVarFinKey = 0
							SET @nSql += ' AND RESERVE_TYPE_CODE = @pResTypeCodeId'
						IF (@iVarFinKey <> 0 AND @iIncPolCvg <> 0) OR @iVarFinKey = 0
							--SET @nSql += ' AND POLCVG_LOSS_ROW_ID = @pCvgLossRowId AND UNIT_ID = @pUnitId' asharma590 jira RMA-65679
							SET @nSql += ' AND POLCVG_LOSS_ROW_ID = @pCvgLossRowId'
						IF @iVarFinKey <> 0 AND @iIncRsvSubType <> 0
							SET @nSql += ' AND RESERVE_CATEGORY = @pRsvSubType'
						--JIRA 23831 knakra ends

						--EXECUTE SP_EXECUTESQL @nSql,
						--N' @pClaimId INT, @pClaimantEid INT, @pResTypeCodeId INT, @pCvgLossRowId INT, @pUnitId INT, @pRsvSubType INT, @pRcRowId INT OUTPUT',	--JIRA 23831 knakra
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pClaimId INT, @pClaimantEid INT, @pResTypeCodeId INT, @pCvgLossRowId INT, @pRsvSubType INT, @pRcRowId INT OUTPUT',	--JIRA 23831 knakra asharma590 jira RMA-65679
						@pClaimId = @iClaimId,
						@pClaimantEid = @iClaimantEid,
						@pResTypeCodeid = @iResTypeCodeId,
						@pCvgLossRowId = @iCvgLossRowId,
						--@pUnitId = @iVehicleId,   asharma590 jira RMA-65679
						@pRsvSubType = @iResSubTypeCodeId,	--JIRA 23831 knakra
						@pRcRowId = @iRcRowId OUTPUT
				
						IF @iRcRowId IS NULL OR @iRcRowId = 0 OR @iRcRowId = ''
						BEGIN	
							SET @iReBalErrCnt = 0
							IF @fVersionNum >= 16.4 SET @iRsvUpdFlag = 0		--JIRA 29954 knakra
							
							EXECUTE DDS_PROCESS_RSV_CUR_SQL @iClaimId, @iClaimantEid, @iVehicleId, @iLob, @iResTypeCodeId, @dBaseCurrAmt, @iResStatusCodeId, 0, @vACTIVITY_DATE, @iCvgLossRowid, @iPolCvgRowId, @vPOLICY_CVG_SEQNO, @vDbName, @P_JOBID, @iDA_ROW_ID, @vCLAIM_ID, @iVarFinKey, @iResSubTypeCodeId, @iHmiFlag, @vBEN_REVIEW_DATE,@iClaimMcFields, @iRsvMCFields, @iPolMCFields,@dClmCurrAmt, @dPolCurrAmt,@dClmtoBaseCurrRate, @dClmToPolCurrRate, @fVersionNum, @iClmCurrCodeId, @iPolCurrCodeId, @iRcRowId OUTPUT, @iRebalErrCnt OUTPUT	--JIRA 29954 knakra(added MC related parameters)
						
							IF @iReBalErrCnt > 0
							BEGIN
								SET @iErrCnt += 1
								GOTO NEXTRECORD									
							END

						
							SET @nSql = 'SELECT @pReserveCategoryShortCode = C1.SHORT_CODE FROM ' + @vDbName + 'CODES C1, ' + @vDbName + 'CODES C2 WHERE'
							SET @nSql = @nSql + ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = @pResTypeCodeId'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pReserveCategoryShortCode VARCHAR(25) OUTPUT, @pResTypeCodeId INT',
							@pResTypeCodeId = @iResTypeCodeId,
							@pReserveCategoryShortCode = @vResCatShortCode OUTPUT
							
							--JIRA 29954 knakra starts
							--SET @fChangeAmt = @fAMOUNT
							--SET @fResBal = @fAMOUNT
							--SET @fColTot = 0.00
							--SET @fPaidTot = 0.00
							SET @fChangeAmt = @dBaseCurrAmt
							SET @dPolCurrChgAmt = @dPolCurrAmt
							SET @dClmCurrChgAmt = @dClmCurrAmt
							SET @dBaseCurrBalAmt = @dBaseCurrAmt
							SET @dPolCurrBalAmt = @dPolCurrAmt
							SET @dClmCurrBalAmt = @dClmCurrAmt
							SET @dBaseCurrPaidTot = 0.0
							SET @dClmCurrPaidTot = 0.0
							SET @dPolCurrPaidTot = 0.0
							SET @dBaseCurrColTot = 0.0
							SET @dPolCurrColTot = 0.0
							SET @dClmCurrColTot = 0.0
							--JIRA 29954 knakra ends
							
							IF @vResCatShortCode = 'R'
							BEGIN
								--SET @fInccurAmt = 0
								SET @dBaseCurrIncAmt = 0.0
								SET @dClmCurrIncAmt = 0.0
								SET @dPolCurrIncAmt = 0.0
							END
							ELSE
							BEGIN
								--SET @fInccurAmt = @fAMOUNT
								SET @dBaseCurrIncAmt = @dBaseCurrAmt
								SET @dPolCurrIncAmt = @dPolCurrAmt
								SET @dClmCurrIncAmt = @dClmCurrAmt
							END
						
						END
						ELSE
						BEGIN
				
							SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
						
							SET @nSql = 'UPDATE ' + @vDbName + 'RESERVE_CURRENT SET '
							SET @nSql += 'RESERVE_AMOUNT = @pResAmt,'
							SET @nSql += 'BALANCE_AMOUNT = @pBalAmt, '
							SET @nSql += 'PAID_TOTAL = @pPaidTot, '
							SET @nSql += 'COLLECTION_TOTAL = @pColTot, '
							SET @nSql += 'INCURRED_AMOUNT = @pIncAmt, '
							SET @nSql += 'RES_STATUS_CODE = @pResStatusCodeId, '
							SET @nSql += 'DATE_ENTERED = @pDateEntered, '
							SET @nSql += 'UPDATED_BY_USER = ''DADDS'', '
							SET @nSql += 'DTTM_RCD_LAST_UPD = @pDttmRcdLastUpd'
							--JIRA 29954 knakra starts
							IF @fVersionNum >= 16.4
							BEGIN
								SET @nSql += ', CLAIM_CURRENCY_RESERVE_AMOUNT = @pClmCurResAmt'
								SET @nSql += ', CLAIM_CURRENCY_INCURRED_AMOUNT = @pClmCurIncAmt'
								SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL = @pClmCurColTot'
								SET @nSql += ', CLAIM_CURRENCY_PAID_TOTAL = @pClmCurPaidTot'
								SET @nSql += ', CLAIM_CURRENCY_BALANCE_AMOUNT = @pClmCurBalAmt'
								SET @nSql += ', POLICY_CURR_RESERVE_AMOUNT = @pPolCurResAmt'
								SET @nSql += ', POLICY_CURR_INCURRED_AMOUNT= @pPolCurIncAmt'
								SET @nSql += ', POLICY_CURR_COLLECTION_TOTAL = @pPolCurColTot'
								SET @nSql += ', POLICY_CURR_PAID_TOTAL = @pPolCurPaidTot'
								SET @nSql += ', POLICY_CURRENCY_BALANCE_AMOUNT = @pPolCurBalAmt'
							END
							--JIRA 29954 knakra ends
							SET @nSql += ' WHERE RC_ROW_ID = @pRcRowId'

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pResAmt DECIMAL(20,2), @pBalAmt DECIMAL(20,2), @pPaidTot DECIMAL(20,2), @pColTot DECIMAL(20,2), @pIncAmt DECIMAL(20,2),
							@pResStatusCodeId INT, @pDateEntered VARCHAR(8), @pDttmRcdLastUpd VARCHAR(16), @pRcRowId INT,
							@pClmCurResAmt decimal(20,2), @pClmCurIncAmt decimal(20,2), @pClmCurColTot decimal(20,2), 
							@pClmCurPaidTot decimal(20,2), @pClmCurBalAmt decimal(20,2), @pPolCurResAmt decimal(20,2), 
							@pPolCurIncAmt decimal(20,2), @pPolCurColTot decimal(20,2), @pPolCurPaidTot decimal(20,2), @pPolCurBalAmt decimal(20,2)',
							@pResAmt = @dBaseCurrAmt,
							@pBalAmt = @dBaseCurrBalAmt,
							@pPaidTot = @dBaseCurrPaidTot,
							@pColTot = @dBaseCurrColTot,
							@pIncAmt = @dBaseCurrIncAmt,
							@pResStatusCodeId = @iResStatusCodeId,
							@pDateEntered = @vACTIVITY_DATE,
							@pDttmRcdLastUpd = @vSysDateTime,
							@pRcRowId = @iRcRowId,
							@pClmCurResAmt = @dClmCurrAmt,
							@pClmCurIncAmt = @dClmCurrIncAmt,
							@pClmCurColTot = @dClmCurrColTot,
							@pClmCurPaidTot = @dClmCurrPaidTot,
							@pClmCurBalAmt = @dClmCurrBalAmt,
							@pPolCurResAmt = @dPolCurrAmt,
							@pPolCurIncAmt = @dPolCurrIncAmt,
							@pPolCurColTot = @dPolCurrColTot,
							@pPolCurPaidTot = @dPolCurrPaidTot,
							@pPolCurBalAmt = @dPolCurrBalAmt
						END

						--JIRA 29954 knakra starts
						IF @fVersionNum >= 16.4 AND @iRsvUpdFlag = 1
						BEGIN
							---akumar523 63934 starts 
							-- IF @dClmCurrChgAmt IS NULL OR @dClmCurrChgAmt = 0
							-- BEGIN
								-- SET @dBaseCurrAmt = @dBaseCurrRsvAmt + (@dClmtoBaseCurrRate * 1)
								-- SET @dPolCurrAmt = @dPolCurrRsvAmt + (@dClmToPolCurrRate * 1)
							-- END
							-- ELSE
								SET @dBaseCurrAmt = @dBaseCurrRsvAmt + (@dClmtoBaseCurrRate * @dClmCurrChgAmt)
								SET @dPolCurrAmt = @dPolCurrRsvAmt + (@dClmToPolCurrRate * @dClmCurrChgAmt)
						
						END
						--JIRA 29954 knakra ends

						SET @nSql = 'SELECT @pRsvRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pRsvRowId INT OUTPUT',
						@pRsvRowId = @iRsvRowId OUTPUT

						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
						
						--JIRA 23831 knakra starts
						--SET @nSql = 'INSERT INTO ' + @vDbName + 'RESERVE_HISTORY(RSV_ROW_ID,POLCVG_ROW_ID,POLCVG_LOSS_ROW_ID,CLAIM_ID,UNIT_ID,CLAIMANT_EID,RESERVE_TYPE_CODE,'	JIRA 23831 knakra
						SET @nSql = 'INSERT INTO ' + @vDbName + 'RESERVE_HISTORY(RSV_ROW_ID,'
						IF @iVarFinKey = 0
							SET @nSql += ' POLCVG_ROW_ID,'
						SET @nSql += ' POLCVG_LOSS_ROW_ID,CLAIM_ID,UNIT_ID,CLAIMANT_EID,RESERVE_TYPE_CODE,'
						--JIRA 23831 knakra ends
						SET @nSql += 'DATE_ENTERED,REASON,POLICY_CVG_SEQNO,PAID_TOTAL,COLLECTION_TOTAL,RESERVE_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,RESERVE_CATEGORY,APPROVER_ID, '
						SET @nSql += 'ONHOLD_RSV_ROW_ID,DTTM_RCD_ADDED,INCURRED_AMOUNT, ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,ENTERED_BY_USER,RES_STATUS_CODE'
						--JIRA 23831 knakra starts
						IF @iVarFinKey <> 0
							SET @nSql += ', RC_ROW_ID'
						--JIRA 23831 knarka ends

						--JIRA 24633 knakra starts
						IF @iHmiFlag <> 0
							SET @nSql += ', BEN_REVIEW_DATE'
						--JIRA 24633 knakra ends
						--JIRA 28198 knakra starts
						IF @iClaimMcFields = 1
						BEGIN
							--JIRA 29954 knakra starts
							SET @nSql += ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT'
							--SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE'
							SET @nSql += ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, '
							IF @fVersionNum < 16.4
								SET @nSql += 'BASE_TO_CLAIM_CUR_RATE'
							ELSE IF @fVersionNum >= 16.4
								SET @nSql += 'CLAIM_CURR_CHANGE_AMOUNT'
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
							SET @nSql += ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, '
							IF @fVersionNum < 16.4
								SET @nSql += 'POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE'
							ELSE IF @fVersionNum >= 16.4
								SET @nSql += 'CLAIM_TO_POLICY_CUR_RATE, POLICY_CURR_CHANGE_AMOUNT'
						END
						--JIRA 28198 knakra ends
						--JIRA 23831 knakra starts
						SET @nSql += ') VALUES(@pRsvRowId, '
						IF @iVarFinKey = 0
							SET @nSql += ' @pPolCvgRowId, '
						SET @nSql += ' @pCvgLossRowId, @pClaimId, @pVehicleId, @pClaimantEid, @pResTypeCodeId,'
						--JIRA 23831 knakra ends
						SET @nSql += '@pDateEntered, @pRsn, @pPolCvgSeqNum, @pPaidTot, @pColTot, @pResAmt, @pBalAmt, @pChngeAmt, @pResCat, @pApproverId,'
						SET @nSql += '@pOnHoldRsvRowId, @pDttmRcdAdded, @pIncAmt, @pAddedByUsr, @pDttmRcdLastUpd, @pUpdatedByUsr, @pEnteredByUsr, @pResStatusCode'
						--JIRA 23831 knakra starts
						IF @iVarFinKey <> 0
							SET @nSql += ', @pRcRowId'
						--JIRA 23831 knakra ends
						
						--JIRA 24633 knakra starts
						IF @iHmiFlag <> 0
							SET @nSql += ', @pBenReviewDate'
						--JIRA 24633 knakra ends
						--JIRA 28198 knakra starts
						IF @iClaimMcFields = 1
						BEGIN
							SET @nSql += ', @pClmCurCode, @pClmToBaseRate, @pClmResAmt, @pClmIncAmt, @pClmColTot, @pClmPaidTot, @pClmResBal, '
							IF @fVersionNum < 16.4
								SET @nSql += '1 '   ---- RMA 37552
							ELSE IF @fVersionNum >= 16.4
								SET @nSql += '@pClmChgAmt'
						END
						IF @iRsvMCFields = 1
							SET @nSql += ', 0, 1, @pResAmt, 1, 1, @pPaidTot, @pBalAmt, @pColTot, @pIncAmt'
						IF @iPolMCFields = 1
						BEGIN
							SET @nSql += ', @pPolCurCode, @pPolResAmt, @pPolIncAmt, @pPolColTot, @pPolPaidTot, @pPolResBal, '
							IF @fVersionNum < 16.4
								SET @nSql += '1, 1'
							ELSE IF @fVersionNum >= 16.4
								SET @nSql += '@pClmToPolRate, @pPolChgAmt'
						END
						--JIRA 28198 knakra ends
						SET @nSql += ')'

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pRsvRowId INT, @pPolCvgRowId INT, @pCvgLossRowId INT, @pClaimId INT, @pVehicleId INT, @pClaimantEid INT, @pResTypeCodeId INT,
						@pDateEntered VARCHAR(8), @pRsn VARCHAR(255), @pPolCvgSeqNum INT, @pPaidTot DECIMAL(20,2), @pColTot DECIMAL(20,2), @pResAmt DECIMAL(20,2), 
						@pBalAmt DECIMAL(20,2), @pChngeAmt DECIMAL(20,2), @pResCat INT, @pApproverId INT,@pOnHoldRsvRowId INT, @pDttmRcdAdded VARCHAR(16), 
						@pIncAmt DECIMAL(20,2), @pAddedByUsr VARCHAR(50), @pDttmRcdLastUpd VARCHAR(16), @pUpdatedByUsr VARCHAR(50), @pEnteredByUsr VARCHAR(50), 
						@pResStatusCode INT, @pBenReviewDate VARCHAR(8), @pRcRowId INT, @pClmCurCode int, @pClmToBaseRate decimal(20,2),
						@pClmResAmt decimal(20,2), @pClmIncAmt decimal(20,2), @pClmColTot decimal(20,2), @pClmPaidTot decimal(20,2), @pClmResBal decimal(20,2),
						@pClmChgAmt decimal(20,2), @pPolCurCode int, @pPolResAmt decimal(20,2), @pPolIncAmt decimal(20,2), @pPolColTot decimal(20,2),
						@pPolPaidTot decimal(20,2), @pPolResBal decimal(20,2), @pClmToPolRate decimal(20,2), @pPolChgAmt decimal(20,2)',	--JIRA 23831 knakra(added RcRowId)
						@pRsvRowId = @iRsvRowId,
						@pPolCvgRowId = @iPolCvgRowId,
						@pCvgLossRowId = @iCvgLossRowId,
						@pClaimId = @iClaimId,
						@pVehicleId = @iVehicleId,
						@pClaimantEid = @iClaimantEid,
						@pResTypeCodeId = @iResTypeCodeId,
						@pDateEntered = @vACTIVITY_DATE,
						@pRsn = 'DA DDS PAYMENT',
						@pPolCvgSeqNum = @vPOLICY_CVG_SEQNO,
						@pPaidTot = @dBaseCurrPaidTot,
						@pColTot = @dBaseCurrColTot,
						@pResAmt = @dBaseCurrAmt,	--JIRA 29954 knakra
						@pBalAmt = @dBaseCurrBalAmt,
						@pChngeAmt = @fChangeAmt,
						@pResCat = @iResSubTypeCodeId,
						@pApproverId = 0,
						@pOnHoldRsvRowId = 0,
						@pDttmRcdAdded = @vSysDateTime,
						@pIncAmt = @dBaseCurrIncAmt,
						@pAddedByUsr = 'DADDS',
						@pDttmRcdLastUpd = @vSysDateTime,
						@pUpdatedByUsr = 'DADDS',
						@pEnteredByUsr = 'DADDS',
						@pResStatusCode = @iResStatusCodeId,
						@pBenReviewDate = @vBEN_REVIEW_DATE,	--JIRA 24366 knakra
						@pRcRowId = @iRcRowId,	--JIRA 23831 knakra
						@pClmCurCode = @iClmCurrCodeId,	--JIRA 29954 knakra starts
						@pClmToBaseRate = @dClmtoBaseCurrRate,
						@pClmResAmt = @dClmCurrAmt,
						@pClmIncAmt = @dClmCurrIncAmt,
						@pClmColTot = @dClmCurrColTot,
						@pClmPaidTot = @dClmCurrPaidTot,
						@pClmResBal = @dClmCurrBalAmt,
						@pClmChgAmt = @dClmCurrChgAmt,
						@pPolCurCode = @iPolCurrCodeId,
						@pPolResAmt = @dPolCurrAmt,
						@pPolIncAmt = @dPolCurrIncAmt,
						@pPolColTot = @dPolCurrColTot,
						@pPolPaidTot = @dPolCurrPaidTot,
						@pPolResBal = @dPolCurrBalAmt,
						@pClmToPolRate = @dClmToPolCurrRate,
						@pPolChgAmt = @dPolCurrChgAmt		--JIRA 29954 knakra ends
						
						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY'''
				
						EXECUTE SP_EXECUTESQL @nSql

						UPDATE DDS_PAYMENT SET INVALID_ROW = 0 WHERE JOBID = @P_JOBID AND DA_ROW_ID = @iDA_ROW_ID

					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = 'ResIns, ' + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResIns','ResIns','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				--knakra activity track starts
				--IF @vTRANSACTION_TYPE IN('P','C','R') AND @iBaseErr = 0 AND @iErrCnt = 0 AND @iCarrierFlag <> 0	JIRA 23831 knakra
				IF @vTRANSACTION_TYPE IN('P','C','R') AND @iBaseErr = 0 AND @iErrCnt = 0 AND ((@iCarrierFlag <> 0 AND @iVarFinKey = 0) OR @iVarFinKey <> 0)	--JIRA 23899 knakra
				BEGIN
					BEGIN TRY	
						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');

						SET @nSql = 'SELECT @pTableId = TABLE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = '
						IF @vTRANSACTION_TYPE = 'R'
							SET @nSql += '''RESERVE_CURRENT'''
						ELSE IF @vTRANSACTION_TYPE IN('P','C')
							SET @nSql += '''FUNDS'''
					
						SET @vLocation = 'TableIdAt'

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pTableId INT OUTPUT',
						@pTableId = @iTableId OUTPUT
					
						SET @nSql = 'SELECT @pActivityRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''ACTIVITY_TRACK'''

						SET @vLocation = 'NxtIdAt'

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pActivityRowId INT OUTPUT',
						@pActivityRowId = @iActivityRowId OUTPUT

						SET @nSql = 'INSERT INTO ' + @vDbName + 'ACTIVITY_TRACK(ACTIVITY_ROW_ID,CLAIM_ID,FOREIGN_TABLE_ID,FOREIGN_TABLE_KEY,UPLOAD_FLAG,DTTM_RCD_ADDED'
						SET @nSql += ',ADDED_BY_USER,CHECK_BATCH_ID,POLICY_SYSTEM_ID,IS_UPDATED,ACTIVITY_TYPE,ACCOUNT_ID,RESERVE_AMOUNT,RESERVE_STATUS'
						SET @nSql += ',CHANGE_AMOUNT,CHECK_STATUS,VOID_FLAG,IS_COLLECTION'
						IF @fVersionNum >= 16.2
                        BEGIN
							SET @nSql = @nSql + ',DTTM_RCD_LAST_UPD,UPDATED_BY_USER'  ---RMA 25298	
                        END
						SET @nSql = @nSql + ') VALUES (@pActivityRowId, @pClaimId, @pForeignTableId, @pForeignTableKey, 0, @pDttm,'
						SET @nSql += '''DDS'', 0, @pPolSysId, 0, @pActivityType, @pAccId, @pRsvAmt, @pRsvStatus, @pChngeAmt, @pCheckStatus, @pVoidFlag, @pIsCol'
						IF @fVersionNum >= 16.2
                        BEGIN
							SET @nSql = @nSql + ',@pDttmRcdLastUpd, @pUpdatedByUser'	 ---RMA 25298	
                        END
						SET @nSql = @nSql + ')';
						
						IF @vTRANSACTION_TYPE = 'R'  
						BEGIN
							IF @iActivityType = 1
							BEGIN
								EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,'OC','ACTIVITY_TYPE',@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','ActivityTrack','DDS_PROCESS_PAYMENTS','CLAIM_ID','CLAIM_ID','DDS_PAYMENT',@vCLAIM_ID,@iActivityCodeid OUTPUT
							END
							ELSE IF @iActivityType = 0
							BEGIN
								EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,'RC','ACTIVITY_TYPE',@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','ActivityTrack','DDS_PROCESS_PAYMENTS','CLAIM_ID','CLAIM_ID','DDS_PAYMENT',@vCLAIM_ID,@iActivityCodeid OUTPUT
							END

							SET @vLocation = 'InsAtRsv'

							EXECUTE SP_EXECUTESQL @nSql,
							N'@pActivityRowId INT, @pClaimId INT, @pForeignTableId INT, @pForeignTableKey INT, @pDttm VARCHAR(14),
							@pPolSysId INT, @pActivityType INT, @pAccId INT, @pRsvAmt DECIMAL(20,2), @pRsvStatus INT, @pChngeAmt DECIMAL(20,2),
							@pCheckStatus INT, @pVoidFlag INT, @pIsCol INT, @pDttmRcdLastUpd VARCHAR(14),@pUpdatedByUser VARCHAR(50)',
							@pActivityRowId = @iActivityRowId,
							@pClaimId = @iClaimId,
							@pForeignTableId = @iTableId,
							@pForeignTableKey = @iRcRowId,
							@pDttm = @vSysDateTime,
							@pPolSysId = @iPolSysId,
							@pActivityType = @iActivityCodeid,
							@pAccId = 0,
							@pRsvAmt = @dBaseCurrAmt,
							@pRsvStatus = @iResStatusCodeId,
							@pChngeAmt = @fChangeAmt,
							@pCheckStatus = 0,
							@pVoidFlag = 0,
							@pIsCol = 0,
							@pDttmRcdLastUpd=@vSysDateTime,
							@pUpdatedByUser='DDS'   
						END  
						ELSE IF @vTRANSACTION_TYPE IN('P','C')   
						BEGIN						
							IF @iVoidFlag <> 0
								SET @iVoidFlagAt = -1
							ELSE IF @iVoidFlagAt = 0
								SET @iVoidFlagAt = 0

							IF @iPayFlag <> 0
								SET @iIsCol = 0
							ELSE IF @iPayFlag = 0
								SET @iIsCol = -1

							EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,'PP','ACTIVITY_TYPE',@oAllowNewCodes,@vDbName,@iLob,@iDA_ROW_ID,'PAYMENT','ActivityTrackFunds','DDS_PROCESS_PAYMENTS','CLAIM_ID','CLAIM_ID','DDS_PAYMENT',@vCLAIM_ID,@iActivityCodeid OUTPUT

							SET @vLocation = 'InsAtFunds'

							EXECUTE SP_EXECUTESQL @nSql,
							N'@pActivityRowId INT, @pClaimId INT, @pForeignTableId INT, @pForeignTableKey INT, @pDttm VARCHAR(14),
							@pPolSysId INT, @pActivityType INT, @pAccId INT, @pRsvAmt DECIMAL(20,2), @pRsvStatus INT, @pChngeAmt DECIMAL(20,2),
							@pCheckStatus INT, @pVoidFlag INT, @pIsCol INT, @pDttmRcdLastUpd VARCHAR(14), @pUpdatedByUser VARCHAR(50)',
							@pActivityRowId = @iActivityRowId,
							@pClaimId = @iClaimId,
							@pForeignTableId = @iTableId,
							@pForeignTableKey = @iTransid,
							@pDttm = @vSysDateTime,
							@pPolSysId = @iPolSysId,
							@pActivityType = @iActivityCodeid,
							@pAccId = @iAccountId,
							@pRsvAmt = 0,
							@pRsvStatus = 0,
							@pChngeAmt = 0,
							@pCheckStatus = @iChkStatCodeId,
							@pVoidFlag = @iVoidFlagAt,
							@pIsCol = @iIsCol,
							@pDttmRcdLastUpd=@vSysDateTime,
							@pUpdatedByUser='DDS'
						END
						
						SET @vLocation = 'UpdGlsryAt'

						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''ACTIVITY_TRACK'''
						EXECUTE SP_EXECUTESQL @nSql

					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = @vLocation + ERROR_MESSAGE() + '. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT',@vLocation,@vLocation,'DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END
				--knakra activity track ends
				--Insert Part Ends
			END TRY
			BEGIN CATCH
				SET @vErrMsgDesc = 'ResIns, ' + ERROR_MESSAGE() + '. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','ResIns','ResIns','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
				SET @iErrCnt += 1
			END CATCH

			NEXTRECORD:

			----Neha Running status code starts 33658---
			BEGIN TRY
							
			SET @vLocation= 'Running_Status'
			
			IF @iRunStatCnt=1
			BEGIN
			
				SET @vProcessMsg ='Total Number of Records processed in PAYMENT : '+ cast(@iRunStatCnt as varchar);

				SET @nSql = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
				SET @nSql =@nSql +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

				EXECUTE SP_EXECUTESQL @nSql,
				N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
				@pJOBID=@P_JOBID, @pProcessMsg=@vProcessMsg, @pModuleName='PAYMENT_RUN',@pTableName ='DDS_PAYMENT_RUN',@pDisplayOrder=-11
			END
			ELSE  
			IF (@iRunCnt = 1000)
			BEGIN
					SET @vProcessMsg ='Total Number of Records processed in PAYMENT : '+ cast(@iRunStatCnt as varchar);

					SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
					SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @nSql,
					N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='PAYMENT_RUN',@pTableName ='DDS_PAYMENT_RUN',@pDisplayOrder=-11
					SET @iRunCnt=1;
			END
			ELSE
			IF (@iTotalRows=@iRunStatCnt)
			BEGIN
				SET @vProcessMsg ='Total Number of Records processed in PAYMENT : '+ cast(@iRunStatCnt as varchar);
				SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
				SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @nSql,
                    N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='PAYMENT_RUN',@pTableName ='DDS_PAYMENT_RUN',@pDisplayOrder=-11
			END

			SET @iRunStatCnt =@iRunStatCnt + 1; 
			SET @iRunCnt = @iRunCnt + 1;
			 
			END TRY
			BEGIN CATCH
					SET @vErrMsgDesc = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'PAYMENT','Run_Status', 'Run_Status','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'EXCEPTION', 'DDS_PAYMENT','CLAIM_ID', @vCLAIM_ID, 0
					SET @iErrCnt += 1
			END CATCH
			---Neha running status code ends 33658---
			
			BEGIN TRY				
				FETCH NEXT FROM @CursorPay INTO
				@iDA_ROW_ID,
				@iJOBID,				
				@iINVALID_ROW,							
				@vRECORD_TYPE,			
				@vTRANSACTION_TYPE,
				@vCLAIM_ID,		
				@vACTIVITY_DATE,
				@vTYPE_FLAG,		
				@dInpAmt,			
				@vMEMO,				
				@vCARRIER,
				@vADJUSTER,				
				@vCHECK_NO,				
				@iCHECK_SUFFIX,
				@vCHECK_STATUS,
				@vTYPE_CODE,
				@vPAYEE_TYPE,			
				@vPAYEE_TAX_ID_NO,
				@vPAYEE_LASTNAME,		
				@vPAYEE_FIRSTNAME,		
				@vPAYEE_ADDRESS,		
				@vPAYEE_CITY,		
				@vPAYEE_STATE,		
				@vPAYEE_ZIP,		
				@vTRANSACTION_DATE,
				@vREPORT_1099_FLAG,		
				@vSERVICE_FROM_DATE,		
				@vSERVICE_TO_DATE,
				@vCLEARED_FLAG,	
				@vDATE_CLEARED,		
				@vBANK_ACCOUNT_NUM,
				@vBANK_SUB_ACCNT_NUM,
				@vPAYEE_ADDRESS2,
				@vUSER_FIELD_A,	
				@vUSER_FIELD_B,		
				@vUSER_FIELD_C,		
				@vUSER_FIELD_D,		
				@vUSER_FIELD_E,		
				@vUSER_FIELD_F,		
				@vUSER_FIELD_G,	
				@vUSER_FIELD_H,	
				@vUSER_FIELD_I,	
				@vUSER_FIELD_J,	
				@vUSER_FIELD_K,	
				@vUSER_FIELD_L,	
				@vUSER_FIELD_M,	
				@vUSER_FIELD_N,	
				@vUSER_FIELD_O,	
				@vUSER_FIELD_P,	
				@vUSER_FIELD_Q,	
				@vUSER_FIELD_R,	
				@vUSER_FIELD_S,	
				@vUSER_FIELD_T,	
				@vUSER_FIELD_U,	
				@vUSER_FIELD_V,
				@vUSER_FIELD_W,
				@vUSER_FIELD_X,
				@vUSER_FIELD_Y,
				@vUSER_FIELD_Z,
				@vINVOICE_NUMBER,
				@iCLAIMANT_SUFFIX,		
				@vRES_STATUS_CODE,		
				@vUNIT_TYPE,		
				@vPOLICY_NAME,
				@vUNIT_NUMBER,			
				@vCOVERAGE_CODE,
				@vLOSS_CODE,		
				@vRESERVE_SUB_TYPE,
				@vDISABILITY_CATEGORY,
				@vVOID_CODE_REASON,	
				@vMODULE_NO,		
				@vPREFIX,			
				@vSUFFIX_COMMON,
				@vSUFFIX_LEGAL,		
				@vMEMO_PHRASE,			
				@vCLASS_CODE,			
				@vCVG_SEQUENCE_NO,
				@vTRANS_SEQ_NO,		
				@vCVG_DESC,			
				@vSUBLINE_DESC,
				@vCLASS_DESC,			
				@vSTAT_UNIT_NUMBER,
				@vPOLICY_CVG_SEQNO,		
				@vRESERVE_TYPE,		
				@vNAME_TYPE,			
				@vPOLICY_NUMBER,
				@vPOLICY_SYMBOL,		
				@vMASTER_COMPANY,
				@vLOCATION_COMPANY,
				@vDSTRBN_TYPE_CODE,
				@vPAYEE_DOB,
				@vREGION,
				@vBEN_REVIEW_DATE,
				@vEOB_REMARKS_CODE_1,	--JIRA 24633 knakra
				@vEOB_REMARKS_CODE_2,	--JIRA 24633 knakra
				@vEOB_REMARKS_CODE_3,	--JIRA 24633 knakra
				@vEOB_REMARKS_CODE_4,	--JIRA 24633 knakra
				@vEOB_REMARKS_CODE_5,	--JIRA 24633 knakra
				@vEOB_PRINTED_DATE,
				@vEOB_PRINTED_BY_USER,
				@vUNIT_FIRST_NAME,
				@vUNIT_LAST_NAME,
				@vUNIT_TAX_ID,
				@vUNIT_DOB,
				@vCLMNT_LAST_NAME,
				@vCLMNT_FIRST_NAME,
				@vCLMNT_TAX_ID,
				@vEMP_NUM,
				@vUNIT_ID,
				@vPMT_CURR_CODE,			--JIRA 30818 knarka starts
				@dPMT_TO_BASE_CURR_RATE,
				@dPMT_TO_POL_CURR_RATE,
				@dPMT_TO_CLM_CURR_RATE,
				@dCLM_TO_BASE_CURR_RATE,
				@dCLM_TO_POL_CURR_RATE		--JIRA 20818 knakra ends
			END TRY
			BEGIN CATCH
				SET @vErrMsgDesc = 'FetchNext, ' + ERROR_MESSAGE() + '. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'PAYMENT','FetchNext','FetchNext','DDS_PROCESS_PAYMENTS',@vErrMsgDesc,'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',@vCLAIM_ID, 0
				SET @iCurrentRow = @iTotalRows + 1			
			END CATCH
		END
		
		CLOSE @CursorPay
		DEALLOCATE @CursorPay		
		
		EXECUTE DDS_PROCESS_LOG @P_JOBID, 'PAYMENT', 'DDS_PAYMENT'

		SET NOCOUNT OFF

	END
	