CREATE OR REPLACE PROCEDURE DDS_PROCESS_PAYMENTS
(
  v_P_JOBID IN NUMBER DEFAULT NULL ,
  v_P_DB_NAME IN VARCHAR2 DEFAULT NULL ,
  v_P_UserId IN NUMBER DEFAULT NULL
)
AUTHID CURRENT_USER
AS
--BEGIN
      --v_CursorPay SYS_REFCURSOR;
      CURSOR CursorPay
        IS SELECT *
        FROM DDS_PAYMENT
         WHERE JOBID = v_P_JOBID
        AND INVALID_ROW = 1;

      -- Kapil
       VENTITY_TYPE  DDS_ENTITY_TYPE; -- KAPIL

      --import file columns variable starts
      v_iDA_ROW_ID NUMBER(10,0);
      v_iJOBID NUMBER(10,0);
      v_iINPUT_ROW_ID NUMBER(10,0);
      v_iINVALID_ROW NUMBER(10,0);
      v_iUPDATE_ROW NUMBER(10,0);
      v_vRECORD_TYPE VARCHAR2(1);
      v_vTRANSACTION_TYPE VARCHAR2(25);
      v_vCLAIM_ID VARCHAR2(25);
      v_vACTIVITY_DATE VARCHAR2(8);
      v_vTYPE_FLAG VARCHAR2(1);
      v_fAMOUNT NUMBER(20,2);
      v_vMEMO VARCHAR2(4000);
      v_vCARRIER VARCHAR2(16);
      v_vADJUSTER VARCHAR2(16);
      v_vCHECK_NO VARCHAR2(25);
      v_iCHECK_SUFFIX NUMBER(10,0);
      v_vCHECK_STATUS VARCHAR2(1);
      v_vTYPE_CODE VARCHAR2(25);
      v_vPAYEE_TYPE VARCHAR2(25);
      v_vPAYEE_TAX_ID_NO VARCHAR2(20);
      v_vPAYEE_LASTNAME VARCHAR2(255);
      v_vPAYEE_FIRSTNAME VARCHAR2(255);
      v_vPAYEE_ADDRESS VARCHAR2(100);
      v_vPAYEE_CITY VARCHAR2(50);
      v_vPAYEE_STATE VARCHAR2(4);
      v_vPAYEE_ZIP VARCHAR2(10);
      v_vTRANSACTION_DATE VARCHAR2(8);
      v_vREPORT_1099_FLAG VARCHAR2(1);
      v_vSERVICE_FROM_DATE VARCHAR2(8);
      v_vSERVICE_TO_DATE VARCHAR2(8);
      v_vCLEARED_FLAG VARCHAR2(1);
      v_vDATE_CLEARED VARCHAR2(8);
      v_vBANK_ACCOUNT_NUM VARCHAR2(20);
      v_vBANK_SUB_ACCNT_NUM VARCHAR2(20);
      v_vPAYEE_ADDRESS2 VARCHAR2(100);
      v_vUSER_FIELD_A CLOB;
      v_vUSER_FIELD_B VARCHAR2(255);
      v_vUSER_FIELD_C VARCHAR2(255);
      v_vUSER_FIELD_D VARCHAR2(255);
      v_vUSER_FIELD_E VARCHAR2(255);
      v_vUSER_FIELD_F VARCHAR2(255);
      v_vUSER_FIELD_G VARCHAR2(255);
      v_vUSER_FIELD_H VARCHAR2(255);
      v_vUSER_FIELD_I VARCHAR2(255);
      v_vUSER_FIELD_J VARCHAR2(255);
      v_vUSER_FIELD_K VARCHAR2(255);
      v_vUSER_FIELD_L VARCHAR2(255);
      v_vUSER_FIELD_M VARCHAR2(255);
      v_vUSER_FIELD_N VARCHAR2(255);
      v_vUSER_FIELD_O VARCHAR2(255);
      v_vUSER_FIELD_P VARCHAR2(255);
      v_vUSER_FIELD_Q VARCHAR2(255);
      v_vUSER_FIELD_R VARCHAR2(255);
      v_vUSER_FIELD_S VARCHAR2(255);
      v_vUSER_FIELD_T VARCHAR2(255);
      v_vUSER_FIELD_U VARCHAR2(255);
      v_vUSER_FIELD_V VARCHAR2(255);
      v_vUSER_FIELD_W VARCHAR2(255);
      v_vUSER_FIELD_X VARCHAR2(255);
      v_vUSER_FIELD_Y VARCHAR2(255);
      v_vUSER_FIELD_Z VARCHAR2(255);
      v_vINVOICE_NUMBER VARCHAR2(25);
      v_iCLAIMANT_SUFFIX NUMBER;
      v_vRES_STATUS_CODE VARCHAR2(25);
      v_vUNIT_TYPE VARCHAR2(10);
      v_vPOLICY_NAME VARCHAR2(20);
      v_vUNIT_NUMBER VARCHAR2(10);
      v_vCOVERAGE_CODE VARCHAR2(25);
      v_vLOSS_CODE VARCHAR2(25);
      v_vRESERVE_SUB_TYPE VARCHAR2(25);
      v_vDISABILITY_CATEGORY VARCHAR2(25);
      v_vVOID_CODE_REASON VARCHAR2(255);
      v_vMODULE_NO VARCHAR2(10);
      v_vPREFIX VARCHAR2(25);
      v_vSUFFIX_COMMON VARCHAR2(25);
      v_vSUFFIX_LEGAL VARCHAR2(50);
      v_vMEMO_PHRASE VARCHAR2(50);
      v_vCLASS_CODE VARCHAR2(25);
      v_vCVG_SEQUENCE_NO VARCHAR2(8);
      v_vTRANS_SEQ_NO VARCHAR2(8);
      v_vCVG_DESC VARCHAR2(100);
      v_vSUBLINE_DESC VARCHAR2(100);
      v_vCLASS_DESC VARCHAR2(100);
      v_vSTAT_UNIT_NUMBER VARCHAR2(10);
      v_vPOLICY_CVG_SEQNO VARCHAR2(10);
      v_vRESERVE_TYPE VARCHAR2(25);
      v_vNAME_TYPE VARCHAR2(25);
      v_vPOLICY_NUMBER VARCHAR2(40);
      v_vPOLICY_SYMBOL VARCHAR2(20);
      v_vMASTER_COMPANY VARCHAR2(10);
      v_vLOCATION_COMPANY VARCHAR2(10);
      v_vDSTRBN_TYPE_CODE VARCHAR2(25);
      v_vPAYEE_DOB VARCHAR2(8);
      v_vREGION VARCHAR2(4);
      v_vBEN_REVIEW_DATE VARCHAR2(8);
      v_vEOB_REMARKS_CODE_1 VARCHAR2(25);
      v_vEOB_REMARKS_CODE_2 VARCHAR2(25);
      v_vEOB_REMARKS_CODE_3 VARCHAR2(25);
      v_vEOB_REMARKS_CODE_4 VARCHAR2(25);
      v_vEOB_REMARKS_CODE_5 VARCHAR2(25);
      v_vEOB_PRINTED_DATE VARCHAR2(8);
      v_vEOB_PRINTED_BY_USER VARCHAR2(50);
      v_vUNIT_FIRST_NAME VARCHAR2(255);
      v_vUNIT_LAST_NAME VARCHAR2(255);
      v_vUNIT_TAX_ID VARCHAR2(20);
      v_vUNIT_DOB VARCHAR2(8);
      v_vCLMNT_LAST_NAME VARCHAR2(255);
      v_vCLMNT_FIRST_NAME VARCHAR2(255);
      v_vCLMNT_TAX_ID VARCHAR2(20);
      v_vEMP_NUM VARCHAR2(20);
      v_vUNIT_ID VARCHAR2(20);
      --JIRA 29954 knakra starts
      v_vPMT_CURR_CODE VARCHAR2(25);
      v_nPMT_TO_BASE_CURR_RATE NUMBER(20,2);
      v_nPMT_TO_POL_CURR_RATE NUMBER(20,2);
      v_nPMT_TO_CLM_CURR_RATE NUMBER(20,2);
      v_nCLM_TO_BASE_CURR_RATE NUMBER(20,2);
      v_nCLM_TO_POL_CURR_RATE NUMBER(20,2);
      --JIRA 29954 knakra ends
      --Import file Columns variable ends
      --UI Options Specific Variables starts
      v_oAllowNewCodes NUMBER(10,0);
      v_oDontCheckDupPay NUMBER(10,0);
      v_oAttachTransIdToChkNum NUMBER(10,0);
      v_oMatchClmntByName NUMBER(10,0);
      v_oMatchClmntBySuffix NUMBER(10,0);
      v_oEmpMatchByName NUMBER(10,0);
      v_oEmpMatchByEmpNum NUMBER(10,0);
      v_oEmpMatchByTaxId NUMBER(10,0);
      v_oNonEmpMatchByName NUMBER(10,0);
      v_oNonEmpMatchByTaxId NUMBER(10,0);
      v_oNonEmpMatchByDob NUMBER(10,0);
      v_oEmpMatchByDob NUMBER(10,0);
      v_oRecalReserves NUMBER(10,0);
      v_oPayBankAcc NUMBER(10,0);
      v_oPaySubAcc NUMBER(10,0);
      v_oChkDupReserves NUMBER(10,0);
      v_oFundSupp NUMBER(10,0);
      --UI Options Specific Variables ends
      --Local Variables Declaration Starts
      v_vReqColumns VARCHAR2(4000);
      v_vDbName VARCHAR2(100);
      v_iCarrierFlag NUMBER(10,0);
      v_nSql CLOB;
      v_iCurrentRow NUMBER(10,0);
      v_iTotalRows NUMBER(10,0) :=0;
      v_iPos NUMBER(10,0);
      v_vColName VARCHAR2(100);
      v_vVal VARCHAR2(4000);
      v_vCodeField VARCHAR2(4000);
      v_vSysTableName VARCHAR2(4000);
      v_vTableName VARCHAR2(100);
      v_iCodeId NUMBER(10,0);
      v_iPayeeTypeCodeId NUMBER(10,0);
      v_iLossCodeId NUMBER(10,0);
      v_iDisCatCodeId NUMBER(10,0);
      v_iResTypeCodeId NUMBER(10,0);
      v_iNameType NUMBER(10,0);
      v_iDistTypeCodeId NUMBER(10,0);
      v_iResSubTypeCodeId NUMBER(10,0);
      v_iPrefixCodeId NUMBER(10,0);
      v_iSuffCommonCodeId NUMBER(10,0);
      v_iChkStatCodeId NUMBER(10,0);
      v_iTransTypeCodeId NUMBER(10,0);
      v_iMemoCodeId NUMBER(10,0);
      v_iLob NUMBER(10,0);
      v_iClaimId NUMBER(10,0);
      v_iRsvBucketMapped NUMBER(10,0);
      v_vErrMsgDesc VARCHAR2(2000);
      v_iClaimantEid NUMBER(10,0);
      v_iUsePolInterface NUMBER(10,0);
      v_iUseClaimantTrack NUMBER(10,0);
      v_iPolicyId NUMBER(10,0);
      v_vPolicyLob VARCHAR2(25);
      v_vPolSysId NUMBER(10,0);
      v_iUnitId NUMBER(10,0) :=0;
      v_iPolUnitRowId NUMBER(10,0):=0;
      v_iPolCvgRowId NUMBER(10,0):=0;
      v_iCvgLossRowId NUMBER(10,0):=0;
      v_vCvgTxt VARCHAR2(4000);
      v_nSql2 CLOB;
      v_iCvgCodeId NUMBER(10,0);
      v_iLossCodeMapping NUMBER(10,0);
      v_iResStatusCodeId NUMBER(10,0);
      v_fChangeAmt NUMBER(20,2);
      v_fCurRsvAmt NUMBER(20,2);
      v_fPaidTot NUMBER(20,2);
      v_fColTot NUMBER(20,2);
      v_vParentRsvCode VARCHAR2(25);
      v_fResBal NUMBER(20,2);
      v_fInccurAmt NUMBER(20,2);
      v_iCollInRsvBal NUMBER(10,0);
      v_iColInIncBal NUMBER(10,0);
      v_iPayFlag NUMBER(10,0);
      v_iVoidFlag NUMBER(10,0);
      v_iRcRowId NUMBER(10,0):=0;
      v_iResStatusCode NUMBER(10,0):=0;
      v_iPayeeEid NUMBER(10,0);
      v_vCvgKey VARCHAR2(100);
      v_vPolKey VARCHAR2(50);
      v_iLimitFlag NUMBER(10,0);
      v_dAggAmtOnPol NUMBER(20,2);
      v_dOccAmtOnPol NUMBER(20,2);
      v_dAggAmtOnCvg NUMBER(20,2);
      v_dOccAmtOnCvg NUMBER(20,2);
      v_iIsEft NUMBER(10,0);
      v_iDefDistTypeCode NUMBER(10,0);
      v_vDistTypeSCode VARCHAR2(25);
      v_iPrintedStatus NUMBER(10,0);
      v_iRowId NUMBER(10,0);
      v_iErrCnt NUMBER(10,0):=0;
      v_iBaseErr NUMBER(10,0):=0;
      v_iClmntTypePayee NUMBER(10,0):=0;
      v_iPolErr NUMBER(10,0):=0;
      v_vErrColumns VARCHAR2(100);
      v_vResTypeCode VARCHAR2(25);
      v_iRsvRowId NUMBER(10,0):=0;
      v_iVehicleId NUMBER(10,0):=0;
      v_iChkClaimant NUMBER(10,0);
      v_iOpenResStatusCode NUMBER(10,0);
      v_iIncSuffix NUMBER(10,0);
      v_iIncPrefix NUMBER(10,0);
      v_vPayToTheOrderOf VARCHAR2(4000);
      v_vResStatus VARCHAR2(25);
      v_iResSuppPaymentFlag NUMBER(10,0);
      --v_utPayee TENTITY;
      v_vSysDateTime VARCHAR2(16);
      v_vCheckStatus VARCHAR2(25);
      v_iStateRowId NUMBER(10,0);
      v_iColFlag NUMBER(10,0);
      v_iClearedFlag NUMBER(10,0);
      v_iPayeeRowId NUMBER(10,0);
      v_iSplitRowId NUMBER(10,0);
      v_iPolSysId NUMBER(10,0):=0;
      v_dSumAmount NUMBER(20,2);
      v_vResCatShortCode VARCHAR2(25);
      v_vClmLobDb VARCHAR2(25);
      v_iReBalErrCnt NUMBER(10,0);
      v_vLocation VARCHAR2(500);
      v_oConfigId NUMBER(10,0);
      v_iErrCntSupp NUMBER(10,0);
      v_vRsvTypeSCode VARCHAR2(25);
      v_iClmntErr NUMBER(10,0);
      v_iEntId NUMBER(10,0);
      v_iPayeeErr NUMBER(10,0);
      v_vValidStrtDate VARCHAR2(8);
      v_vValidEndDate VARCHAR2(8);
      V_iActivityType      NUMBER;
      v_iActivityRowId      number;  --knakra activity track starts
      v_iTableId        number;
      v_iActivityCodeid    number;
      v_iVoidFlagAt      number;
      v_iIsCol          number;  --knakra activity track ends
      v_iAccountId NUMBER(10,0);
      v_iSubAccId NUMBER(10,0);
      v_iUseSubAcc NUMBER(10,0);
      v_g_iAccountId NUMBER(10,0);
      v_g_iSubAccId NUMBER(10,0);
      v_iTransNumber NUMBER(10,0);
      v_iTransid NUMBER(10,0);
      v_fVersionNum NUMBER(10,1);  ---RMA 25298
      v_iRetVal NUMBER(10, 0) := 0;  ---RMA 25298
      --JIRA 23831 knakra starts
      iVarfinKey NUMBER(10, 0) := 0;
      iFinKeyFilter NUMBER(10, 0) := 0;
      iRowId NUMBER(10,0) := 0;
      iIncClaimant NUMBER(10,0) := 0;
      iIncRsvType NUMBER(10,0) := 0;
      iIncRsvSubType NUMBER(10,0) := 0;
      iIncPolCvg NUMBER(10,0):= 0;
      iIncLossType NUMBER(10,0) := 0;
      iClaimTypeCodeId NUMBER(10,0) := 0;
      iPolicyLobCodeId NUMBER(10,0) := 0;
      --JIRA 23831 knakra ends
      --JIRA 24633 knakra starts
      iHmiFlag NUMBER(10,0) := 0;
      iUnitEntId NUMBER(10,0) := 0;
      iEobCodeId1 NUMBER(10,0) := 0;
      iEobCodeId2 NUMBER(10,0) := 0;
      iEobCodeId3 NUMBER(10,0) := 0;
      iEobCodeId4 NUMBER(10,0) := 0;
      iEobCodeId5 NUMBER(10,0) := 0;
      iCountLoop NUMBER(10,0) := 0;
      --JIRA 24633 knakra ends
      --JIRA 28198 knarka starts
      iClaimMCFields NUMBER(10,0) := 0;
      iRsvMCFields NUMBER(10,0) := 0;
      iPolMCFields NUMBER(10,0) := 0;
      --JIRA 28198 knakra ends
      --JIRA 29954 knakra starts
      -- JIRA 37552 Initializing variables starts--
      v_iPmtToBaseRate NUMBER(20,2):=1;
      v_iPmtToClmRate NUMBER(20,2):=1;
      v_iPmtToPolRate NUMBER(20,2):=1;
      v_iClmToBaseRate NUMBER(20,2):=1;
      v_iClmToPolRate NUMBER(20,2):=1;
      v_iBaseCurCodeId NUMBER(20,2):=0;
      v_iPmtCurCodeId NUMBER(20,2):=0;
      v_iClmCurCodeId NUMBER(20,2):=0;
      v_iPolCurCodeId NUMBER(20,2):=0;
      v_dClmCurrRsvAmt NUMBER(20,2):=0;
      v_dClmCurrAmt NUMBER(20,2):=0;
      v_dClmCurrChgAmt NUMBER(20,2):=0;
      v_dClmCurrPaidTot NUMBER(20,2):=0;
      v_dClmCurrColTot NUMBER(20,2):=0;
      v_dClmCurrIncAmt NUMBER(20,2):=0;
      v_dClmCurrBalAmt NUMBER(20,2):=0;
      v_dPolCurrChgAmt NUMBER(20,2):=0;
      v_dPmtCurrAmt NUMBER(20,2):=0;
      v_dBaseCurrAmt NUMBER(20,2):=0;
      v_dBaseCurrRsvAmt NUMBER(20,2):=0;
      v_dBaseCurrPaidTot NUMBER(20,2):=0;
      v_dBaseCurrBalAmt NUMBER(20,2):=0;
      v_dBaseCurrColTot NUMBER(20,2):=0;
      v_dBaseCurrIncAmt NUMBER(20,2):=0;
      v_dPolCurrRsvAmt NUMBER(20,2):=0;
      v_dPolCurrPaidTot NUMBER(20,2):=0;
      v_dPolCurrBalAmt NUMBER(20,2):=0;
      v_dPolCurrColTot NUMBER(20,2):=0;
      v_dPolCurrAmt NUMBER(20,2):=0;
      v_iRsvUpdFlag NUMBER(20,2):=0;
      v_dPolCurrIncAmt NUMBER(20,2):=0;
      v_dInpAmt NUMBER(20,2);
      v_iMcFlag NUMBER(20,2):=0;
      v_nSqlMc CLOB;
      --JIRA 29954 knakra ends
      ---neha 33658 -- START
      v_iRunStatCnt    NUMBER(10, 0):=1;
      v_iRunCnt        NUMBER(10, 0):=1;
      v_vProcessMsg    varchar2(4000);
      v_iCount         NUMBER(10, 0) := 0;
      ---neha 33658 -- end
      v_EventDate     varchar2(8);--JIRA 34797 kkaur25
      iMalDistTypeCode NUMBER;
	  v_iReadyToPrtFlag NUMBER(20,2):=0; --asharma590 jira 61578
	  v_iPolLobRelatedCodeId NUMBER(10,0);    --akumar523
	  v_vTableNamePayeType varchar2(100);---akumar523
	  v_V_Count_islocked_reserve NUMBER; --JIRA udoni RMA-75601
   BEGIN
      --Local Variables Declaration Starts
      v_vDbName := v_P_DB_NAME || '.';

      --RMA-25298 JIRA starts--
         DDS_spCheckVersion(v_vTableName=>'ACTIVITY_TRACK',
                            v_vFieldName  => 'DTTM_RCD_LAST_UPD',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         IF v_iRetVal = 1 THEN
            V_fVersionNum := 16.2;
         END IF;
      --RMA-25298 JIRA ends--

       --JIRA 28198 knakra starts
       v_iRetVal := 0;
       dds_spcheckversion(v_vTableName => 'RESERVE_CURRENT', v_vFieldName => 'CLAIM_CURRENCY_RESERVE_AMOUNT', vDbName => v_P_DB_NAME, v_iRetVal => v_iRetVal);

       IF v_iRetVal = 1 THEN
         iClaimMCFields := 1;
       ELSE
         iClaimMCFields := 0;
       END IF;

       v_iRetVal := 0;
       dds_spcheckversion(v_vTableName => 'RESERVE_CURRENT', v_vFieldName => 'RSV_CURR_RSV_AMT', vDbName => v_P_DB_NAME, v_iRetVal => v_iRetVal);

       IF v_iRetVal = 1 THEN
         iRsvMCFields := 1;
       ELSE
         iRsvMCFields := 0;
       END IF;

       v_iRetVal := 0;
       dds_spcheckversion(v_vTableName => 'RESERVE_CURRENT', v_vFieldName => 'POLICY_CURR_RESERVE_AMOUNT', vDbName => v_P_DB_NAME, v_iRetVal => v_iRetVal);

       IF v_iRetVal = 1 THEN
         iPolMCFields := 1;
       ELSE
         iPolMCFields := 0;
       END IF;
       --JIRA 28198 knakra ends
         --JIRA 23831 knakra starts
         v_iRetVal := 0;
         DDS_spCheckVersion(v_vTableName=>'FINANCIAL_KEY',
                            v_vFieldName  => 'ROW_ID',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         IF v_iRetVal = 1 THEN
            iVarFinKey := 1;
         END IF;
         --JIRA 23831 knakra ends

       --JIRA 29954 knakra starts
         v_iRetVal := 0;

         DDS_spCheckVersion(v_vTableName=>'RESERVE_HISTORY',
                            v_vFieldName  => 'POLICY_CURR_CHANGE_AMOUNT',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         IF v_iRetVal = 1 THEN
            V_fVersionNum := 16.4;
         END IF;
         
         v_iRetVal := 0;
         
         dds_spcheckversion(v_vTableName=>'FUNDS',
                            v_vFieldName  => 'DISABILITY_CLASS_ROW_ID',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         
         IF v_iRetVal = 1 THEN
            v_fVersionNum := 17.3;
         END IF;
		--akumar523 60666 starts 
		         DDS_spCheckVersion(v_vTableName=>'RESERVE_CURRENT',
                            v_vFieldName  => 'CLAIM_CURR_PRINT_TOTAL',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         IF v_iRetVal = 1 THEN
            V_fVersionNum := 19.1;
         END IF;
		 v_iRetVal := 0;
		---akumar523 60666 ends
		---JIRA udoni RMA-75601 
		         DDS_spCheckVersion(v_vTableName=>'RESERVE_CURRENT',
                            v_vFieldName  => 'IS_LOCKED',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
         IF v_iRetVal = 1 THEN
            V_fVersionNum := 20.2;
         END IF;
		 v_iRetVal := 0;
		---JIRA udoni RMA-75601
		
         v_nSqlMc := 'SELECT EXCHANGE_RATE FROM ' || v_vDbName || 'CURRENCY_RATE WHERE SOURCE_CURRENCY_CODE = :1 AND DESTINATION_CURRENCY_CODE = :2';
       --JIRA 29954 knakra ends

        BEGIN
         v_nSql := 'SELECT STR_PARM_VALUE FROM ' || v_vDbName || 'PARMS_NAME_VALUE ' || ' WHERE PARM_NAME = :1';
         --JIRA 23831 knakra starts
         v_vLocation := 'ACCheck';
         IF iVarfinKey = 0 THEN
             EXECUTE IMMEDIATE v_nSql INTO V_iCarrierFlag USING 'MULTI_COVG_CLM';      --Carrier Check
         ELSE
             EXECUTE IMMEDIATE v_nSql INTO iFinKeyFilter USING 'FINANCIAL_KEY_FILTER';
         END IF;
         --JIRA 29954 knakra starts
         IF (v_fVersionNum >= 16.4) THEN
            v_vLocation := 'MCFlag';
            EXECUTE IMMEDIATE v_nSql INTO v_iMcFlag USING 'USE_MULTI_CURRENCY';
            v_vLocation := 'BaseCurCode';
            EXECUTE IMMEDIATE v_nSql INTO v_iBaseCurCodeId USING 'BASE_CURRENCY_CODE';
         END IF;
         --JIRA 29954 knakra ends
         EXCEPTION
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;

                  V_iBaseErr := V_iBaseErr + 1;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_IDA_ROW_ID,
                                        'PAYMENT',v_vLocation,v_vLocation,'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',v_vCLAIM_ID,
                                        0);
         END;

        BEGIN
         v_nSql := 'SELECT STR_PARM_VALUE FROM ' || v_vDbName || 'PARMS_NAME_VALUE ' || ' WHERE PARM_NAME = :1';  --External Policy Interface Check

         EXECUTE IMMEDIATE v_nSql INTO v_iUsePolInterface USING 'USE_POLICY_INTERFACE';
         EXCEPTION
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  V_iBaseErr := V_iBaseErr + 1;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_IDA_ROW_ID,
                                        'PAYMENT','PolInt','PolInt','DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID','DDS_PAYMENT','CLAIM_ID',v_vCLAIM_ID,
                                        0);
         END;

         --JIRA 24633 knakra starts
         v_nSql := 'SELECT CODE_ID FROM ' || v_vDbName || 'CODES C INNER JOIN ' || v_vDbName || 'GLOSSARY G ON C.TABLE_ID = G.TABLE_ID';
         v_nSql := v_nSql || ' WHERE G.SYSTEM_TABLE_NAME = ''LINE_OF_BUSINESS'' AND C.SHORT_CODE = ''HC''';

         BEGIN
           EXECUTE IMMEDIATE v_nSql INTO iHmiFlag;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                iHmiFlag := 0;
         END;
         IF iHmiFlag IS NOT NULL AND iHmiFlag > 0 THEN
            iHmiFlag := 1;
         END IF;
         --JIRA 24633 knakra ends

       --IF v_iCarrierFlag <> 0  AND v_iUsePolInterface = 0 THEN --JIRA 23831 knakra
       IF v_iCarrierFlag <> 0  AND v_iUsePolInterface = 0 AND iVarfinKey = 0 THEN  --JIRA 23831 knakra
         v_vErrMsgDesc := 'Carrier Settings is ON but Policy Interface is OFF, Use Policy Interface should be ON for Carrier ON Settings. ';
		 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

         DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                               0,
                               'PAYMENT',
                               'PolicyInterface',
                               'PolicyInterface',
                               'DDS_PROCESS_PAYMENTS',
                               v_vErrMsgDesc,
                               'JOB_ID',
                               'DDS_PAYMENT',
                               'JOB_ID',
                               v_P_JOBID,
                               1);

         v_iBaseErr := v_iBaseErr + 1;
       END IF;
  BEGIN --Neha Running status starts 33658
  SELECT COUNT(DA_ROW_ID) INTO v_iCount FROM DDS_PAYMENT WHERE JOBID = v_P_JOBID AND INVALID_ROW=1;
   exception
    when no_data_found then
      null;
  END; --Neha Running status ends 33658

      SELECT NVL(ALLOW_NEW_CODES, 0),
             NVL(ATTACH_TRANS_ID_TO_CHECK_NO, 0),
             NVL(CHECK_DUPLICATE_RESERVE_TRANS, 0),
             NVL(DONT_CHECK_DUPLICATE_PAYMENTS, 0),
             NVL(EMPLOYEE_MATCH_BY_EMP_NUM, 0),
             NVL(EMPLOYEE_MATCH_BY_NAME, 0),
             NVL(EMPLOYEE_MATCH_BY_TAX_ID, 0),
             NVL(ID_CLAIMANT_BY_NAME, 0), --JIRA 23204 knakra (column name changed from ID_CLAIMANT_BY_NAME_GCVA to ID_CLAIMANT_BY_NAME)
             NVL(ID_CLAIMANT_BY_SUFFIX, 0), --JIRA 23204 knakra (column name changed from ID_CLAIMANT_BY_SUFFIX_GCVA to ID_CLAIMANT_BY_SUFFIX)
             NVL(NON_EMP_MATCH_BY_NAME, 0),
             NVL(NON_EMP_MATCH_BY_TAX_ID, 0),
             NVL(PAYMENT_BANK_ACCOUNT, 0),
             NVL(PAYMENT_SUB_ACCOUNT, 0),
             NVL(RECALCULATE_RESERVES, 0),
             CONFIG_ID,
             NVL(PAYMENT_SUPP,0),
       NVL(EMPLOYEE_MATCH_BY_DOB,0),
       NVL(NON_EMP_MATCH_BY_DOB,0),
             VALID_START_DATE,
             VALID_END_DATE
        INTO v_oAllowNewCodes,
             v_oAttachTransIdToChkNum,
             v_oChkDupReserves,
             v_oDontCheckDupPay,
             v_oEmpMatchByEmpNum,
             v_oEmpMatchByName,
             v_oEmpMatchByTaxId,
             v_oMatchClmntByName,
             v_oMatchClmntBySuffix,
             v_oNonEmpMatchByName,
             v_oNonEmpMatchByTaxId,
             v_oPayBankAcc,
             v_oPaySubAcc,
             v_oRecalReserves,
             v_oConfigId,
             v_oFundSupp,
       v_oEmpMatchByDob,
       v_oNonEmpMatchByDob,
             v_vValidStrtDate,
             v_vValidEndDate
        FROM DDS_OPTIONSET
         WHERE JOBID = v_P_JOBID;--FETCH VALUES FROM OPTIONSET CORRESPONDING TO JOBID


      /*SELECT COUNT(1)
        INTO v_iTotalRows
        FROM DDS_PAYMENT
         WHERE JOBID = v_P_JOBID
                 AND INVALID_ROW = 1;
*/ -- Kapil No need of this query in Oracle as cursor will manage itself
BEGIN
      OPEN CursorPay;
      LOOP
      --FETCH CursorPay INTO v_iDA_ROW_ID,v_iJOBID,v_iINPUT_ROW_ID,v_iINVALID_ROW,v_iUPDATE_ROW,v_vRECORD_TYPE,v_vTRANSACTION_TYPE,v_vCLAIM_ID,v_vACTIVITY_DATE,v_vTYPE_FLAG,v_fAMOUNT,v_vMEMO,v_vCARRIER,v_vADJUSTER,v_vCHECK_NO,v_iCHECK_SUFFIX,v_vCHECK_STATUS,v_vTYPE_CODE,v_vPAYEE_TYPE,v_vPAYEE_TAX_ID_NO,v_vPAYEE_LASTNAME,v_vPAYEE_FIRSTNAME,v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_vPAYEE_STATE,v_vPAYEE_ZIP,v_vTRANSACTION_DATE,v_vREPORT_1099_FLAG,v_vSERVICE_FROM_DATE,v_vSERVICE_TO_DATE,v_vCLEARED_FLAG,v_vDATE_CLEARED,v_vBANK_ACCOUNT_NUM,v_vBANK_SUB_ACCNT_NUM,v_vPAYEE_ADDRESS2,v_vUSER_FIELD_A,v_vUSER_FIELD_B,v_vUSER_FIELD_C,v_vUSER_FIELD_D,v_vUSER_FIELD_E,v_vUSER_FIELD_F,v_vUSER_FIELD_G,v_vUSER_FIELD_H,v_vUSER_FIELD_I,v_vUSER_FIELD_J,v_vUSER_FIELD_K,v_vUSER_FIELD_L,v_vUSER_FIELD_M,v_vUSER_FIELD_N,v_vUSER_FIELD_O,v_vUSER_FIELD_P,v_vUSER_FIELD_Q,v_vUSER_FIELD_R,v_vUSER_FIELD_S,v_vUSER_FIELD_T,v_vUSER_FIELD_U,v_vUSER_FIELD_V,v_vUSER_FIELD_W,v_vUSER_FIELD_X,v_vUSER_FIELD_Y,v_vUSER_FIELD_Z,v_vINVOICE_NUMBER,v_iCLAIMANT_SUFFIX,v_vRES_STATUS_CODE,v_vUNIT_TYPE,v_vPOLICY_NAME,v_vUNIT_NUMBER,v_vCOVERAGE_CODE,v_vLOSS_CODE,v_vRESERVE_SUB_TYPE,v_vDISABILITY_CATEGORY,v_vVOID_CODE_REASON,v_vMODULE_NO,v_vPREFIX,v_vSUFFIX_COMMON,v_vSUFFIX_LEGAL,v_vMEMO_PHRASE,v_vCLASS_CODE,v_vCVG_SEQUENCE_NO,v_vTRANS_SEQ_NO,v_vCVG_DESC,v_vSUBLINE_DESC,v_vCLASS_DESC,v_vSTAT_UNIT_NUMBER,v_vPOLICY_CVG_SEQNO,v_vRESERVE_TYPE,v_vNAME_TYPE,v_vPOLICY_NUMBER,v_vPOLICY_SYMBOL,v_vMASTER_COMPANY,v_vLOCATION_COMPANY,v_vDSTRBN_TYPE_CODE,v_vPAYEE_DOB,v_vREGION,v_vBEN_REVIEW_DATE,v_vEOB_REMARKS_CODE_1,v_vEOB_REMARKS_CODE_2,v_vEOB_REMARKS_CODE_3,v_vEOB_REMARKS_CODE_4,v_vEOB_REMARKS_CODE_5,v_vEOB_PRINTED_DATE,v_vEOB_PRINTED_BY_USER,v_vUNIT_FIRST_NAME,v_vUNIT_LAST_NAME,v_vUNIT_TAX_ID,v_vUNIT_DOB,v_vCLMNT_LAST_NAME,v_vCLMNT_FIRST_NAME,v_vCLMNT_TAX_ID,v_vEMP_NUM,v_vUNIT_ID; --JIRA 29954 knakra
      FETCH CursorPay INTO v_iDA_ROW_ID,v_iJOBID,v_iINPUT_ROW_ID,v_iINVALID_ROW,v_iUPDATE_ROW,v_vRECORD_TYPE,v_vTRANSACTION_TYPE,v_vCLAIM_ID,v_vACTIVITY_DATE,v_vTYPE_FLAG,v_dInpAmt,v_vMEMO,v_vCARRIER,v_vADJUSTER,v_vCHECK_NO,v_iCHECK_SUFFIX,v_vCHECK_STATUS,v_vTYPE_CODE,v_vPAYEE_TYPE,v_vPAYEE_TAX_ID_NO,v_vPAYEE_LASTNAME,v_vPAYEE_FIRSTNAME,v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_vPAYEE_STATE,v_vPAYEE_ZIP,v_vTRANSACTION_DATE,v_vREPORT_1099_FLAG,v_vSERVICE_FROM_DATE,v_vSERVICE_TO_DATE,v_vCLEARED_FLAG,v_vDATE_CLEARED,v_vBANK_ACCOUNT_NUM,v_vBANK_SUB_ACCNT_NUM,v_vPAYEE_ADDRESS2,v_vUSER_FIELD_A,v_vUSER_FIELD_B,v_vUSER_FIELD_C,v_vUSER_FIELD_D,v_vUSER_FIELD_E,v_vUSER_FIELD_F,v_vUSER_FIELD_G,v_vUSER_FIELD_H,v_vUSER_FIELD_I,v_vUSER_FIELD_J,v_vUSER_FIELD_K,v_vUSER_FIELD_L,v_vUSER_FIELD_M,v_vUSER_FIELD_N,v_vUSER_FIELD_O,v_vUSER_FIELD_P,v_vUSER_FIELD_Q,v_vUSER_FIELD_R,v_vUSER_FIELD_S,v_vUSER_FIELD_T,v_vUSER_FIELD_U,v_vUSER_FIELD_V,v_vUSER_FIELD_W,v_vUSER_FIELD_X,v_vUSER_FIELD_Y,v_vUSER_FIELD_Z,v_vINVOICE_NUMBER,v_iCLAIMANT_SUFFIX,v_vRES_STATUS_CODE,v_vUNIT_TYPE,v_vPOLICY_NAME,v_vUNIT_NUMBER,v_vCOVERAGE_CODE,v_vLOSS_CODE,v_vRESERVE_SUB_TYPE,v_vDISABILITY_CATEGORY,v_vVOID_CODE_REASON,v_vMODULE_NO,v_vPREFIX,v_vSUFFIX_COMMON,v_vSUFFIX_LEGAL,v_vMEMO_PHRASE,v_vCLASS_CODE,v_vCVG_SEQUENCE_NO,v_vTRANS_SEQ_NO,v_vCVG_DESC,v_vSUBLINE_DESC,v_vCLASS_DESC,v_vSTAT_UNIT_NUMBER,v_vPOLICY_CVG_SEQNO,v_vRESERVE_TYPE,v_vNAME_TYPE,v_vPOLICY_NUMBER,v_vPOLICY_SYMBOL,v_vMASTER_COMPANY,v_vLOCATION_COMPANY,v_vDSTRBN_TYPE_CODE,v_vPAYEE_DOB,v_vREGION,v_vBEN_REVIEW_DATE,v_vEOB_REMARKS_CODE_1,v_vEOB_REMARKS_CODE_2,v_vEOB_REMARKS_CODE_3,v_vEOB_REMARKS_CODE_4,v_vEOB_REMARKS_CODE_5,v_vEOB_PRINTED_DATE,v_vEOB_PRINTED_BY_USER,v_vUNIT_FIRST_NAME,v_vUNIT_LAST_NAME,v_vUNIT_TAX_ID,v_vUNIT_DOB,v_vCLMNT_LAST_NAME,v_vCLMNT_FIRST_NAME,v_vCLMNT_TAX_ID,v_vEMP_NUM,v_vUNIT_ID, v_vPMT_CURR_CODE, v_nPMT_TO_BASE_CURR_RATE, v_nPMT_TO_POL_CURR_RATE, v_nPMT_TO_CLM_CURR_RATE, v_nCLM_TO_BASE_CURR_RATE, v_nCLM_TO_POL_CURR_RATE;   --JIRA 29954 knakra
      EXIT WHEN CursorPay%NOTFOUND;
         v_iCurrentRow := v_iCurrentRow + 1;
         v_iClaimId := 0;
         v_iClaimantEid := 0;
         v_iPayeeTypeCodeId := 0;
         v_iLossCodeId := 0;
         v_iDisCatCodeId := 0;
         v_iResTypeCodeId := 0;
         v_iNameType := 0;
         v_iDistTypeCodeId := 0;
         v_iResSubTypeCodeId := 0;
         v_iPrefixCodeId := 0;
         v_iSuffCommonCodeId := 0;
         v_iChkStatCodeId := 0;
         v_iTransTypeCodeId := 0;
         v_iMemoCodeId := 0;
         v_iLob := 0;
         v_iClaimId := 0;
         v_iRsvBucketMapped := 0;
         v_vErrMsgDesc := NULL;
         v_iClaimantEid := 0;
         v_iUseClaimantTrack := 0;
         v_iPolicyId := 0;
         v_vPolicyLob := NULL;
         v_vPolSysId := NULL;
         v_iUnitId := 0;
         v_iPolUnitRowId := 0;
         v_iPolCvgRowId := 0;
         v_iCvgLossRowId := 0;
         v_vCvgTxt := NULL;
         v_iCvgCodeId := 0;
         v_iLossCodeMapping := 0;
         v_iResStatusCodeId := 0;
         v_fChangeAmt := 0.00;
         v_fCurRsvAmt := 0.00;
         --v_fPaidTot := 0.00;
         --v_fColTot := 0.00;
         v_vParentRsvCode := NULL;
         --v_fResBal := 0.00;
         --v_fInccurAmt := 0.00;
         v_iCollInRsvBal := 0;
         v_iColInIncBal := 0;
         v_iPayFlag := 0;
         v_iVoidFlag := 0;
         v_iRcRowId := 0;
         v_iResStatusCode := 0;
         v_iPayeeEid := 0;
         v_vCvgKey := NULL;
         v_vPolKey := NULL;
         v_iLimitFlag := 0;
         v_dAggAmtOnPol := 0.00;
         v_dOccAmtOnPol := 0.00;
         v_dAggAmtOnCvg := 0.00;
         v_dOccAmtOnCvg := 0.00;
         v_iIsEft := 0;
         v_iDefDistTypeCode := 0;
         v_vDistTypeSCode := 0;
         v_iPrintedStatus := 0;
         v_iRowId := 0;
         v_iErrCnt := 0;
         v_iBaseErr := 0;
         v_iClmntTypePayee := 0;
         v_iPolErr := 0;
         v_vErrColumns := NULL;
         v_vResTypeCode := NULL;
         v_iRsvRowId := 0;
         v_iVehicleId := 0;
         v_iChkClaimant := 0;
         v_iOpenResStatusCode := 0;
         v_iIncSuffix := 0;
         v_iIncPrefix := 0;
         v_vPayToTheOrderOf := NULL;
         v_vResStatus := NULL;
         v_iResSuppPaymentFlag := 0;
         v_vSysDateTime := NULL;
         v_vCheckStatus := NULL;
         v_iStateRowId := 0;
         v_iColFlag := 0;
         v_iClearedFlag := 0;
         v_iPayeeRowId := 0;
         v_iSplitRowId := 0;
         v_iPolSysId := 0;
         v_dSumAmount := 0.00;
         v_vResCatShortCode := NULL;
         v_vClmLobDb := NULL;
         v_iReBalErrCnt := 0;
         v_vLocation := 0;
         v_iAccountId := 0;
         v_iSubAccId := 0;
         v_iUseSubAcc := 0;
         v_g_iAccountId := 0;
         v_g_iSubAccId := 0;
         v_iTransNumber := 0;
         v_iTransid := 0;
         v_iErrCntSupp := 0;
         --JIRA 23831 knakra starts
         iRowId := 0;
         iIncClaimant := 0;
         iIncRsvType := 0;
         iIncRsvSubType := 0;
         iIncPolCvg := 0;
         iIncLossType := 0;
         iClaimTypeCodeId := 0;
         iPolicyLobCodeId := 0;
         --JIRA 23831 knakra ends
         --JIRA 24633 knakra starts
         iUnitEntId := 0;
         iEobCodeId1 := 0;
         iEobCodeId2 := 0;
         iEobCodeId3 := 0;
         iEobCodeId4 := 0;
         iEobCodeId5 := 0;
         --JIRA 24633 knakra ends
         --JIRA 29954 knakra starts
         v_iPmtToBaseRate := 0;
         v_iPmtToClmRate := 0;
         v_iPmtToPolRate := 0;
         v_iClmToBaseRate := 0;
         v_iClmToPolRate := 0;
         v_iPmtCurCodeId := 0;
         v_iClmCurCodeId := 0;
         v_iPolCurCodeId := 0;
         v_iBaseCurCodeId := 0;   --  JIRA 37552
         --JIRA 29954 knakra ends

          IF v_vCLAIM_ID IS NULL THEN
                v_vErrMsgDesc := 'Claim ID is mandatory and can not be left empty, skipping record. ';
				v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'PAYMENT',
                                      'ClaimId',
                                      'ClaimId',
                                      'DDS_PROCESS_PAYMENT',
                                      v_vErrMsgDesc,
                                      'CLAIM_ID',
                                      'DDS_PAYMENT',
                                      'CLAIM_ID',
                                      v_vCLAIM_ID,
                                      1);
                GOTO NEXTRECORD;
         END IF;

           IF v_vRECORD_TYPE IS NULL THEN
              v_vErrMsgDesc := 'Record Type is mandatory and can not be left blank, skipping record. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'RecType',
                                    'RecType',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'RECORD_TYPE',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

              GOTO NEXTRECORD;
           END IF;

           --IF v_iCarrierFlag <> 0 AND UPPER(v_vRECORD_TYPE) NOT IN ('W','G') THEN
           IF v_iCarrierFlag <> 0 AND UPPER(v_vRECORD_TYPE) NOT IN ('W','G') AND iVarfinKey = 0 THEN
              v_vErrMsgDesc := 'Record Type: ' || v_vRECORD_TYPE || ' is not valid, Either enter G or W for Carrier Clients. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'RecordTypeACON',
                                    'RecordTypeACON',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'RECORD_TYPE',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              GOTO NEXTRECORD;
           END IF;
           --IF v_iCarrierFlag = 0 AND UPPER(v_vRECORD_TYPE) NOT IN ( 'G','W','V','D' ) THEN     --JIRA 23831 knakra
           IF ((v_iCarrierFlag = 0 AND iVarfinKey = 0) OR iVarfinKey <> 0) AND UPPER(v_vRECORD_TYPE) NOT IN ( 'G','W','V','D' ) AND iHmiFlag = 0 THEN
              v_vErrMsgDesc := 'Record Type: ' || v_vRECORD_TYPE || ' is not valid, G,W,V,D only are allowed for Corporate Clients. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'RecordType',
                                    'RecordType',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'RECORD_TYPE',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
           END IF;

           --JIRA 24633 knakra starts
           IF iHmiFlag = 1 AND v_vRECORD_TYPE NOT IN('G','W','V','D','H') THEN
              v_vErrMsgDesc := 'Record Type: ' || v_vRECORD_TYPE || ' is not valid, G,W,V,D,H only are allowed. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'RecordTypeHmi',
                                    'RecordTypeHmi',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'RECORD_TYPE',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
           END IF;
           --JIRA 24633 knakra ends

           --JIRA 23831 knakra starts(code moved above for financial key)
           --v_nSql := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_NUMBER = :1'; JIRA 23831 knakra
           --JIRA 29954 knakra starts
           --v_nSql := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE, CLAIM_TYPE_CODE, POLICY_LOB_CODE FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_NUMBER = :1';
           v_nSql := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE, CLAIM_TYPE_CODE, POLICY_LOB_CODE';
           IF v_fVersionNum >= 16.4 THEN
              v_nSql := v_nSql || ', CLAIM_CURR_CODE';
           END IF;
           v_nSql := v_nSql || ' FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_NUMBER = :1';
           --JIRA 29954 knakra ends
           BEGIN
             IF v_fVersionNum >= 16.4 THEN --JIRA 29954 knakra
                EXECUTE IMMEDIATE v_nSql INTO v_iClaimId, v_iLob, iClaimTypeCodeId, iPolicyLobCodeId, v_iClmCurCodeId USING v_vCLAIM_ID;     --JIRA 29954 knakra
             ELSE
                EXECUTE IMMEDIATE v_nSql INTO v_iClaimId, v_iLob, iClaimTypeCodeId, iPolicyLobCodeId USING v_vCLAIM_ID;
             END IF;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_iClaimId:=0;
                 v_iLob := 0;
                 iClaimTypeCodeId := 0;
                 iPolicyLobCodeId := 0;
                 v_iClmCurCodeId := 0;   --JIRA 29954 knakra
           END;

           v_vLocation := 'ClaimLob';

           --CHECK FOR VALID CLAIM
           IF v_iClaimId IS NULL OR v_iClaimId = 0 THEN
              v_vErrMsgDesc := 'Claim does not exist, skipping record. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimExists',
                                    'ClaimExists',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           END IF;

           IF v_iLob IS NULL OR v_iLob = 0 THEN
              v_vErrMsgDesc := 'Claim has Invalid LOB associated with it, skipping record.';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimLob',
                                    'ClaimLob',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;--CHECK FOR VALID LOB
           END IF;

           --JIRA 29954 knakra starts
           IF v_fVersionNum >= 16.4 AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND (v_iClmCurCodeId IS NULL OR v_iClmCurCodeId <= 0) THEN
              v_vLocation := 'NoClmCurrency';
              v_vErrMsgDesc := 'Claim Currency not set for Claim Number: ' || v_vCLAIM_ID || '. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    v_vLocation,
                                    v_vLocation,
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              v_iErrCnt := v_iErrCnt + 1;
           END IF;
           --JIRA 29954 knakra ends

           v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1';
           v_vLocation := 'LobConfirm';
               BEGIN
                 EXECUTE IMMEDIATE v_nSql INTO v_vClmLobDb USING v_iLob;
               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     v_iClaimId:=0;
                     v_iLob := 0;
               END;

           IF ( UPPER(v_vRECORD_TYPE) = 'G' AND UPPER(v_vClmLobDb) <> 'GC' )
             OR ( UPPER(v_vRECORD_TYPE) = 'W' AND UPPER(v_vClmLobDb) <> 'WC' )
             OR ( UPPER(v_vRECORD_TYPE) = 'D' AND UPPER(v_vClmLobDb) <> 'DI' )
             OR ( UPPER(v_vRECORD_TYPE) = 'H' AND UPPER(v_vClmLobDb) <> 'HC' )      --JIRA 24633 knakra
             OR ( UPPER(v_vRECORD_TYPE) = 'V' AND UPPER(v_vClmLobDb) <> 'VA' ) THEN
              v_vErrMsgDesc := 'Record Type: ' || v_vRECORD_TYPE || ' is not valid for Claim LOB: ' || v_vClmLobDb;
			  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimLobChk',
                                    'ClaimLobChk',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           END IF;

           IF iFinKeyFilter <> 0 AND (iPolicyLobCodeId IS NULL OR iPolicyLobCodeId = 0) AND iVarfinKey <> 0 THEN
              v_vErrMsgDesc := 'Claim Id: ' || v_vCLAIM_ID || ', Financial Key is set on Policy LOB and invalid or empty Policy Lob is associated with Claim. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'PolLobBlankVfk',
                                    'PolLobBlankVfk',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           ELSIF iFinKeyFilter = 0 AND (iClaimTypeCodeId IS NULL OR iClaimTypeCodeId = 0) AND iVarFinKey <> 0 THEN
              v_vErrMsgDesc := 'Claim Id: ' || v_vCLAIM_ID || ', Financial Key is set on Claim Type and invalid or empty Claim Type is associated with Claim. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClmTypeBlankVfk',
                                    'ClmTypeBlankVfk',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           END IF;

           IF iVarFinKey <> 0 THEN
              v_nSql := 'SELECT ROW_ID, INC_CLAIMANT, INC_RSVTYPE, INC_RSVSUBTYPE, INC_POL_COVERAGE, INC_LOSS_TYPE FROM ' || v_vDbName || 'FINANCIAL_KEY';
              v_nSql := v_nSql || ' WHERE LOB_CODE = :1';
              IF iFinKeyFilter <> 0 THEN
                 v_nSql := v_nSql || ' AND POLICY_LOB = :2';
              ELSIF iFinKeyFilter = 0 THEN
                 v_nSql := v_nSql || ' AND CLAIM_TYPE = :2';
              END IF;

              BEGIN
                IF iFinKeyFilter <> 0 THEN
                   EXECUTE IMMEDIATE v_nSql INTO iRowId, iIncClaimant, iIncRsvType, iIncRsvSubType, iIncPolCvg, iIncLossType USING v_iLob, iPolicyLobCodeId;
                ELSIF iFinKeyFilter = 0 THEN
                   EXECUTE IMMEDIATE v_nSql INTO iRowId, iIncClaimant, iIncRsvType, iIncRsvSubType, iIncPolCvg, iIncLossType USING v_iLob, iClaimTypeCodeId;
                END IF;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO iRowId, iIncClaimant, iIncRsvType, iIncRsvSubType, iIncPolCvg, iIncLossType USING v_iLob, -1;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_vErrMsgDesc := 'Claim Id: ' || v_vCLAIM_ID || ', No User Defined or Default Financial Key found for the claim. ';
				  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'NoFinKey',
                                    'NoFinKey',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

                  v_iErrCnt := v_iErrCnt + 1 ;
                  GOTO NEXTRECORD;
                END;
                WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                       v_iDA_ROW_ID,
                                       'PAYMENT',
                                       'ErrFinKey',
                                       'ErrFinKey',
                                       'DDS_PROCESS_PAYMENT',
                                       v_vErrMsgDesc,
                                       'CLAIM_ID',
                                       'DDS_PAYMENT',
                                       'CLAIM_ID',
                                       v_vCLAIM_ID,
                                       0);
                  v_iErrCnt := v_iErrCnt + 1 ;
                  GOTO NEXTRECORD;
              END;
           END IF;

           IF v_iUsePolInterface = 0 AND iIncPolCvg <> 0 THEN
             v_vErrMsgDesc := 'Use Policy Interface is turned OFF and Policy/Coverage has been included in the Financial key for Claim: ' || v_vCLAIM_ID || '. ';
			 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'PolInterfaceOff',
                                    'PolInterfaceOff',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

                  v_iErrCnt := v_iErrCnt + 1 ;
                  GOTO NEXTRECORD;
           END IF;

           --JIRA 23831 knakra ends

           v_vReqColumns := 'TRANSACTION_TYPE|ACTIVITY_DATE|AMOUNT|';

           IF v_vRESERVE_TYPE IS NULL THEN
              v_vReqColumns := v_vReqColumns || 'TYPE_FLAG|';
           END IF;

           IF UPPER(v_vTRANSACTION_TYPE) IN ( 'P','C' ) THEN
				--v_vReqColumns := v_vReqColumns || 'CHECK_NO|CHECK_STATUS|TYPE_CODE|PAYEE_LASTNAME|TRANSACTION_DATE|'; --Sdalvi3 Jira 65683
				v_vReqColumns := v_vReqColumns || 'CHECK_STATUS|TYPE_CODE|PAYEE_LASTNAME|TRANSACTION_DATE|';
           END IF;

           --JIRA 23831 knakra starts
           /*IF v_iCarrierFlag <> 0 THEN
              v_vReqColumns := v_vReqColumns || 'UNIT_TYPE|POLICY_NAME|UNIT_NUMBER|COVERAGE_CODE|LOSS_CODE|';
              v_vReqColumns := v_vReqColumns || 'MODULE_NO|CLASS_CODE|CVG_SEQUENCE_NO|TRANS_SEQ_NO|CLASS_DESC|';
              v_vReqColumns := v_vReqColumns || 'STAT_UNIT_NUMBER|POLICY_CVG_SEQNO|POLICY_NUMBER|POLICY_SYMBOL|';
              v_vReqColumns := v_vReqColumns || 'MASTER_COMPANY|LOCATION_COMPANY|';

              IF UPPER(v_vRECORD_TYPE) <> 'W' THEN
                 v_vReqColumns := v_vReqColumns || 'CVG_DESC|';
              END IF;

              IF UPPER(v_vRECORD_TYPE) = 'W' THEN
                 v_vReqColumns := v_vReqColumns || 'DISABILITY_CATEGORY|';
              END IF;
           END IF;*/
           IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR (iVarfinKey <> 0 AND iIncPolCvg <> 0) THEN
              v_vReqColumns := v_vReqColumns || 'UNIT_TYPE|POLICY_NUMBER|MASTER_COMPANY|COVERAGE_CODE|CLASS_CODE|POLICY_CVG_SEQNO|';
              IF v_vRECORD_TYPE <> 'H' THEN  --JIRA 24633 knakra
                 v_vReqColumns := v_vReqColumns || 'POLICY_NAME|UNIT_NUMBER|MODULE_NO|CVG_SEQUENCE_NO|TRANS_SEQ_NO|CLASS_DESC|';
                 v_vReqColumns := v_vReqColumns || 'STAT_UNIT_NUMBER|POLICY_SYMBOL|LOCATION_COMPANY|';
              ELSIF v_vRECORD_TYPE = 'H' AND iHmiFlag = 1 THEN
                 -- v_vRECORD_TYPE := v_vRECORD_TYPE || 'REGION|'; -- Kapil commented on 4th Oct 2016
    v_vReqColumns :=v_vReqColumns || 'REGION|';-- Kapil added  on 4th Oct 2016
              END IF;          --JIRA 24633 knakra
              IF iVarFinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0) THEN
                 v_vReqColumns := v_vReqColumns || 'LOSS_CODE|';
              END IF;
              IF v_vRECORD_TYPE NOT IN('W','H') AND v_fVersionNum < 17.3 THEN    --JIRA 24633 knakra
                 v_vReqColumns := v_vReqColumns || 'CVG_DESC|';
              END IF;
              IF v_vRECORD_TYPE NOT IN('W', 'H', 'D') AND v_fVersionNum >= 17.3 THEN
                 v_vReqColumns := v_vReqColumns || 'CVG_DESC|';
              END IF;
              IF v_vRECORD_TYPE = 'W' AND (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0)) THEN
                 v_vReqColumns := v_vReqColumns || 'DISABILITY_CATEGORY|';
              END IF;
           END IF;
           --JIRA 23831 knakra ends


         WHILE INSTR(v_vReqColumns, '|', 1) > 0--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
           LOOP
                 v_iPos := INSTR(v_vReqColumns, '|', 1);
                 v_vColName := SUBSTR(v_vReqColumns, 0, INSTR(v_vReqColumns, '|', 1) - 1);
                 v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)))+1,LENGTH(v_vReqColumns));
                 v_vVal := (CASE
                                 WHEN v_vColName = 'TRANSACTION_TYPE' THEN v_vTRANSACTION_TYPE
                                 WHEN v_vColName = 'ACTIVITY_DATE' THEN v_vACTIVITY_DATE
                                 --WHEN v_vColName = 'AMOUNT' THEN TO_CHAR(v_fAMOUNT)                     --JIRA 29954 knakra
                                 WHEN v_vColName = 'AMOUNT' THEN TO_CHAR(v_dInpAmt)                       --JIRA 29954 kankra
                                 WHEN v_vColName = 'UNIT_TYPE' THEN v_vUNIT_TYPE
                                 WHEN v_vColName = 'POLICY_NAME' THEN v_vPOLICY_NAME
                                 WHEN v_vColName = 'UNIT_NUMBER' THEN v_vUNIT_NUMBER
                                 WHEN v_vColName = 'COVERAGE_CODE' THEN v_vCOVERAGE_CODE
                                 WHEN v_vColName = 'LOSS_CODE' THEN v_vLOSS_CODE
                                 WHEN v_vColName = 'MODULE_NO' THEN v_vMODULE_NO
                                 WHEN v_vColName = 'CLASS_CODE' THEN v_vCLASS_CODE
                                 WHEN v_vColName = 'CVG_SEQUENCE_NO' THEN v_vCVG_SEQUENCE_NO
                                 WHEN v_vColName = 'TRANS_SEQ_NO' THEN v_vTRANS_SEQ_NO
                                 WHEN v_vColName = 'CLASS_DESC' THEN v_vCLASS_DESC
                                 WHEN v_vColName = 'STAT_UNIT_NUMBER' THEN v_vSTAT_UNIT_NUMBER
                                 WHEN v_vColName = 'POLICY_CVG_SEQNO' THEN v_vPOLICY_CVG_SEQNO
                                 WHEN v_vColName = 'TYPE_FLAG' THEN v_vTYPE_FLAG
                                 --WHEN v_vColName = 'CHECK_NO' THEN v_vCHECK_NO     'Sdalvi3 Jira 65683
                                 WHEN v_vColName = 'CHECK_STATUS' THEN v_vCHECK_STATUS
                                 WHEN v_vColName = 'TYPE_CODE' THEN v_vTYPE_CODE
                                 WHEN v_vColName = 'PAYEE_LASTNAME' THEN v_vPAYEE_LASTNAME
                                 WHEN v_vColName = 'TRANSACTION_DATE' THEN v_vTRANSACTION_DATE
                                 WHEN v_vColName = 'POLICY_NUMBER' THEN v_vPOLICY_NUMBER
                                 WHEN v_vColName = 'POLICY_SYMBOL' THEN v_vPOLICY_SYMBOL
                                 WHEN v_vColName = 'MASTER_COMPANY' THEN v_vMASTER_COMPANY
                                 WHEN v_vColName = 'LOCATION_COMPANY' THEN v_vLOCATION_COMPANY
                                 WHEN v_vColName = 'CVG_DESC' THEN v_vCVG_DESC
                                 WHEN v_vColName = 'DISABILITY_CATEGORY' THEN v_vDISABILITY_CATEGORY
                                 WHEN v_vColName = 'REGION' THEN v_vREGION --JIRA 24633 knakra
                                 END);

                 IF v_vVal IS NULL THEN
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_iDA_ROW_ID,
                                          'PAYMENT',
                                          'NullCheck',
                                          'NullCheck',
                                          'DDS_PROCESS_PAYMENT',
                                          'Required Field is Null or Empty in Import file',
                                          v_vColName,
                                          'DDS_PAYMENT',
                                          'CLAIM_ID',
                                          v_vCLAIM_ID,
                                          1);
                    v_iErrCnt := v_iErrCnt + 1 ;
                 END IF;
           END LOOP;

           --JIRA 23831 knakra starts(commenting below code and moving it above as it is required for financial key)
           /*v_nSql := 'SELECT CLAIM_ID, LINE_OF_BUS_CODE FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_NUMBER = :1';

           BEGIN
             EXECUTE IMMEDIATE v_nSql INTO v_iClaimId,v_iLob  USING v_vCLAIM_ID;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_iClaimId:=0;
                 v_iLob := 0;
           END;

           v_vLocation := 'ClaimLob';

           --CHECK FOR VALID CLAIM
           IF v_iClaimId IS NULL OR v_iClaimId = 0 THEN
              v_vErrMsgDesc := 'Claim does not exist, skipping record.';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimExists',
                                    'ClaimExists',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           END IF;

           IF v_iLob IS NULL OR v_iLob = 0 THEN
              v_vErrMsgDesc := 'Claim has Invalid LOB associated with it, skipping record.';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimLob',
                                    'ClaimLob',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;--CHECK FOR VALID LOB
           END IF;

           v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1';
           v_vLocation := 'LobConfirm';

               BEGIN
                 EXECUTE IMMEDIATE v_nSql INTO v_vClmLobDb USING v_iLob;
               EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     v_iClaimId:=0;
                     v_iLob := 0;
               END;

           IF ( UPPER(v_vRECORD_TYPE) = 'G' AND UPPER(v_vClmLobDb) <> 'GC' )
             OR ( UPPER(v_vRECORD_TYPE) = 'W' AND UPPER(v_vClmLobDb) <> 'WC' )
             OR ( UPPER(v_vRECORD_TYPE) = 'D' AND UPPER(v_vClmLobDb) <> 'DI' )
             OR ( UPPER(v_vRECORD_TYPE) = 'V' AND UPPER(v_vClmLobDb) <> 'VA' ) THEN
              v_vErrMsgDesc := 'Record Type: ' || v_vRECORD_TYPE || ' is not valid for Claim LOB: ' || v_vClmLobDb;
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ClaimLobChk',
                                    'ClaimLobChk',
                                    'DDS_PROCESS_PAYMENT',
                                    v_vErrMsgDesc,
                                    'CLAIM_ID',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);

              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           END IF;*/
           --JIRA 23831 knakra ends
           
           --JIRA 38951 knakra starts
           IF DDS_IS_NUMBER(v_vPOLICY_CVG_SEQNO) = 1 AND (v_iCarrierFlag <> 0 OR iFinKeyFilter <> 0) THEN
              IF cast(v_vPOLICY_CVG_SEQNO as NUMBER) = 0 THEN
                 v_vPOLICY_CVG_SEQNO := '1';
              END IF;
           ELSE
              v_vPOLICY_CVG_SEQNO:= '0';
           END IF;
           --JIRA 38951 knakra ends

         --IF v_iCarrierFlag = 0 THEN  JIRA 23831 knakra
         IF v_iCarrierFlag = 0 AND iVarFinKey = 0 THEN           --JIRA 23831 knakra
              v_nSql := 'SELECT RESERVE_TRACKING FROM ' || v_vDbName || 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = :1';
              BEGIN
                   EXECUTE IMMEDIATE v_nSql INTO v_iUseClaimantTrack USING v_iLob;     --Detail Level Tracking Check
              EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 v_iUseClaimantTrack:=0;
               WHEN OTHERS THEN
                       v_vErrMsgDesc := SQLERRM;
                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'ResTrack',
                                             'ResTrack',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             'CLAIM_ID',
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             0);
                        v_iErrCnt := v_iErrCnt + 1 ;
              END;
           ELSE
              v_iUseClaimantTrack := 1;
           END IF;
		   
		  ---akumar523 starts--RMA-63197
          --- IF UPPER(v_vPAYEE_TYPE) = 'E'  OR  UPPER(v_vPAYEE_TYPE) = 'C' THEN
          ---    v_vPAYEE_TYPE := 'C';
          --- ELSE
           --   IF v_vPAYEE_TYPE IS NULL THEN
           --      v_vPAYEE_TYPE := 'O';
			--  ELSE
			--	 v_vPAYEE_TYPE := 'O';
            --  END IF;
          -- END IF;
		   
		   
		   	IF UPPER(v_vPAYEE_TYPE) = 'E' OR UPPER(v_vPAYEE_TYPE) = 'C' THEN
					 v_vTableNamePayeType := 'EMPLOYEE';
					 v_vPAYEE_TYPE := 'C';
			ELSE 
				IF UPPER(v_vPAYEE_TYPE) IS NULL OR v_vPAYEE_TYPE = '' OR UPPER(v_vPAYEE_TYPE) = 'O' THEN
					 v_vTableNamePayeType := 'OTHER_PEOPLE';
					 v_vPAYEE_TYPE := 'O';
					
				ELSE 
					IF UPPER(v_vPAYEE_TYPE)= 'P' THEN
					 v_vTableNamePayeType := 'OTHER_PEOPLE';
					ELSE
					 v_vTableNamePayeType := v_vPAYEE_TYPE;
					 v_vPAYEE_TYPE :='O';
					END IF;	
			    END IF;
			END IF;	
			----AKUMAR523 RMA-63197  ENDS
			
           v_vCheckStatus := v_vCHECK_STATUS;
           v_vCodeField := 'PAYEE_TYPE|DISABILITY_CATEGORY|RESERVE_TYPE|NAME_TYPE|DSTRBN_TYPE_CODE|';
           v_vCodeField := v_vCodeField || 'RESERVE_SUB_TYPE|PREFIX|SUFFIX_COMMON|MEMO_PHRASE|CHECK_STATUS|TYPE_CODE|COVERAGE_CODE|RES_STATUS_CODE|PRINTED_STATUS|CLAIMANT_TYPE_PAYEE|OPEN_RESERVE_STATUS|';
           v_vCodeField := v_vCodeField || 'EOB_REMARKS_CODE_1|EOB_REMARKS_CODE_2|EOB_REMARKS_CODE_3|EOB_REMARKS_CODE_4|EOB_REMARKS_CODE_5|'; --JIRA 24633 knakra
           v_vCodeField := v_vCodeField || 'PMT_CURR_CODE|MAL_DIST_TYPE|';    --JIRA 29954 knakra
           v_vSysTableName := 'PAYEE_TYPE|DISABILITY_CATEGORY|RESERVE_TYPE|ENTITY_NAME_TYPE|DISTRIBUTION_TYPE|';
           v_vSysTableName := v_vSysTableName || 'RESERVE_SUB_TYPE|ENTITY_PREFIX|ENTITY_SUFFIX|MEMO_PHRASE|CHECK_STATUS|TRANS_TYPES|COVERAGE_TYPE|RESERVE_STATUS|CHECK_STATUS|PAYEE_TYPE|RESERVE_STATUS|';
           v_vSysTableName := v_vSysTableName || 'EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|EOB_REMARKS|';   --JIRA 24633 knakra
           v_vSysTableName := v_vSysTableName || 'CURRENCY_TYPE|DISTRIBUTION_TYPE|';   --JIRA 29954 knakra

           IF UPPER(v_vCheckStatus) IN ( 'V','M' ) THEN
              v_vCheckStatus := 'P';
           END IF;
			--asharma590 jira 61578
			IF UPPER(v_vCheckStatus) = 'P' THEN
			v_iReadyToPrtFlag := -1;
			END IF;
			--asharma590 jira 61578
         WHILE INSTR(v_vCodeField, '|', 1) > 0--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
         LOOP
            BEGIN
               --v_iPos := INSTR(v_vCodeField, '|', 1);
               v_vColName := SUBSTR(v_vCodeField, 0, INSTR(v_vCodeField, '|', 1) - 1);
               v_vCodeField := SUBSTR(v_vCodeField,LENGTH(SUBSTR(v_vCodeField,1,INSTR(v_vCodeField, '|', 1)))+1,LENGTH(v_vCodeField));

               --v_iPos := INSTR(v_vSysTableName, '|', 1);
               v_vTableName := SUBSTR(v_vSysTableName, 0, INSTR(v_vSysTableName, '|', 1) - 1);
               v_vSysTableName := SUBSTR(v_vSysTableName,LENGTH(SUBSTR(v_vSysTableName,1,INSTR(v_vSysTableName, '|', 1)))+1,LENGTH(v_vSysTableName));

               v_vVal := (CASE
                               WHEN v_vColName = 'PAYEE_TYPE' THEN v_vPAYEE_TYPE
                               WHEN v_vColName = 'DISABILITY_CATEGORY' THEN v_vDISABILITY_CATEGORY
                               WHEN v_vColName = 'RESERVE_TYPE' THEN v_vRESERVE_TYPE
                               WHEN v_vColName = 'NAME_TYPE' THEN v_vNAME_TYPE
                               WHEN v_vColName = 'DSTRBN_TYPE_CODE' THEN v_vDSTRBN_TYPE_CODE
                               WHEN v_vColName = 'RESERVE_SUB_TYPE' THEN v_vRESERVE_SUB_TYPE
                               WHEN v_vColName = 'PREFIX' THEN v_vPREFIX
                               WHEN v_vColName = 'SUFFIX_COMMON' THEN v_vSUFFIX_COMMON
                               WHEN v_vColName = 'MEMO_PHRASE' THEN v_vMEMO_PHRASE
                               WHEN v_vColName = 'CHECK_STATUS' THEN v_vCheckStatus
                               WHEN v_vColName = 'TYPE_CODE' THEN v_vTYPE_CODE
                               WHEN v_vColName = 'COVERAGE_CODE' THEN v_vCOVERAGE_CODE
                               WHEN v_vColName = 'RES_STATUS_CODE' THEN v_vRES_STATUS_CODE
                               WHEN v_vColName = 'PRINTED_STATUS' THEN 'P'
                               WHEN v_vColName = 'CLAIMANT_TYPE_PAYEE' THEN 'C'
                               WHEN v_vColName = 'OPEN_RESERVE_STATUS' THEN 'O'
                               --JIRA 24633 knakra starts
                               WHEN v_vColName = 'EOB_REMARKS_CODE_1' THEN v_vEOB_REMARKS_CODE_1
                               WHEN v_vColName = 'EOB_REMARKS_CODE_2' THEN v_vEOB_REMARKS_CODE_2
                               WHEN v_vColName = 'EOB_REMARKS_CODE_3' THEN v_vEOB_REMARKS_CODE_3
                               WHEN v_vColName = 'EOB_REMARKS_CODE_4' THEN v_vEOB_REMARKS_CODE_4
                               WHEN v_vColName = 'EOB_REMARKS_CODE_5' THEN v_vEOB_REMARKS_CODE_5
                               --JIRA 24633 knakra ends
                               WHEN v_vColName = 'PMT_CURR_CODE' THEN v_vPMT_CURR_CODE  --JIRA 29954 knakra
                               WHEN v_vColName = 'MAL_DIST_TYPE' THEN 'MAL'
                               END);


               IF v_vVal IS NOT NULL THEN
                  DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                             v_vVal,
                                             v_vTableName,
                                             v_oAllowNewCodes,
                                             v_vDbName,
                                             v_iLob,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'CodeValidate',
                                             'DDS_PROCESS_PAYMENTS',
                                             'CLAIM_ID',
                                             v_vColName,
                                             'DDS_PAYMENT',
                                             v_vCLAIM_ID,
                                             v_iCodeId);

                  IF ( v_iCodeId = 0 OR v_iCodeId IS NULL ) THEN
                     v_iErrCnt := v_iErrCnt + 1 ;
                  END IF;
               END IF;

                IF v_vColName = 'PAYEE_TYPE' THEN
                v_iPayeeTypeCodeId := v_iCodeId;
                ELSIF v_vColName = 'DISABILITY_CATEGORY' THEN
                v_iDisCatCodeId := v_iCodeId;
                ELSIF v_vColName = 'RESERVE_TYPE' THEN
                v_iResTypeCodeId := v_iCodeId;
                ELSiF v_vColName = 'NAME_TYPE' THEN
                v_iNameType := v_iCodeId;
                ELSIF v_vColName = 'DSTRBN_TYPE_CODE' THEN
                v_iDistTypeCodeId := v_iCodeId;
                ELSIF v_vColName = 'RESERVE_SUB_TYPE' THEN
                v_iResSubTypeCodeId := v_iCodeId;
                ELSIF v_vColName = 'PREFIX' THEN
                v_iPrefixCodeId := v_iCodeId;
                ELSIF v_vColName = 'SUFFIX_COMMON' THEN
                v_iSuffCommonCodeId := v_iCodeId;
                ELSIF v_vColName = 'MEMO_PHRASE' THEN
                v_iMemoCodeId := v_iCodeId;
                ELSIF v_vColName = 'CHECK_STATUS' THEN
                v_iChkStatCodeId := v_iCodeId;
                ELSiF v_vColName = 'TYPE_CODE' THEN
                v_iTransTypeCodeId := v_iCodeId;
                ELSIF v_vColName = 'COVERAGE_CODE' THEN
                v_iCvgCodeId := v_iCodeId;
                ELSIF v_vColName = 'RES_STATUS_CODE' THEN
                v_iResStatusCodeId := v_iCodeId;
                ELSIF v_vColName = 'PRINTED_STATUS' THEN
                v_iPrintedStatus := v_iCodeId;
                ELSIF v_vColName = 'CLAIMANT_TYPE_PAYEE' THEN
                v_iClmntTypePayee := v_iCodeId;
                ELSIF v_vColName = 'OPEN_RESERVE_STATUS' THEN
                v_iOpenResStatusCode := v_iCodeId;
                --JIRA 24633 knakra starts
                ELSIF v_vColName = 'EOB_REMARKS_CODE_1' THEN
                iEobCodeId1 := v_iCodeId;
                ELSIF v_vColName = 'EOB_REMARKS_CODE_2' THEN
                iEobCodeId2 := v_iCodeId;
                ELSIF v_vColName = 'EOB_REMARKS_CODE_3' THEN
                iEobCodeId3 := v_iCodeId;
                ELSIF v_vColName = 'EOB_REMARKS_CODE_4' THEN
                iEobCodeId4 := v_iCodeId;
                ELSIF v_vColName = 'EOB_REMARKS_CODE_5' THEN
                iEobCodeId5 := v_iCodeId;
                --JIRA 24633 knakra ends
                ELSIF v_vColName = 'PMT_CURR_CODE' THEN   --JIRA 29954 knakra
                v_iPmtCurCodeId := v_iCodeId;             --JIRA 29954 knakra
                ELSIF v_vColName = 'MAL_DIST_TYPE' THEN
                iMalDistTypeCode := v_iCodeId;
                END IF;
               v_iCodeId := NULL;
            END;
         END LOOP;

         --JIRA 29954 knakra starts
         IF v_vPMT_CURR_CODE IS NULL OR v_vPMT_CURR_CODE = '' AND v_fVersionNum >= 16.4 THEN
            v_iPmtCurCodeId := v_iClmCurCodeId;
         END IF;
         --JIRA 29954 knakra ends

         v_vReqColumns := 'ACTIVITY_DATE|TRANSACTION_DATE|SERVICE_FROM_DATE|SERVICE_TO_DATE|DATE_CLEARED|PAYEE_DOB|BEN_REVIEW_DATE|EOB_PRINTED_DATE|UNIT_DOB|';

         WHILE INSTR(v_vReqColumns, '|', 1) > 0--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
         LOOP
            BEGIN
               --v_iPos := INSTR(v_vCodeField, '|', 1);
               v_vColName := SUBSTR(v_vReqColumns, 0, INSTR(v_vReqColumns, '|', 1) - 1);
               v_vReqColumns := SUBSTR(v_vReqColumns,LENGTH(SUBSTR(v_vReqColumns,1,INSTR(v_vReqColumns, '|', 1)))+1,LENGTH(v_vReqColumns));

               v_nSql := 'SELECT ' || v_vColName || ' FROM DDS_PAYMENT WHERE JOBID = :1 AND DA_ROW_ID = :2';

               EXECUTE IMMEDIATE v_nSql INTO v_vVal USING v_P_JOBID, v_iDA_ROW_ID;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_vVal := NULL;
            END;
               IF v_vVal IS NOT NULL THEN
                  IF dds_is_number(v_vVal) = 0 OR LENGTH(v_vVal) <> 8 OR dds_is_date(v_vVal) = 0 THEN
                     v_vErrMsgDesc := 'Invalid Date format: ' || v_vVal || ', It should be in YYYYMMDD format. ';
					 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'DateVal',
                                             'DateVal',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             v_vColName, -- Kapil added on 13-Oct-2016
                                             --'CLAIM_ID', -- Kapil comment on 13-Oct-2016
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             1);
                        v_iErrCnt := v_iErrCnt + 1 ;
                  ELSE
                    IF v_vVal < v_vValidStrtDate OR v_vVal > v_vValidEndDate THEN
                       v_vErrMsgDesc := 'Date provided: ' || v_vVal || ' is out of valid date range: ' || v_vValidStrtDate || ' - ' || v_vValidEndDate;
					   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'DateRange',
                                             'DateRange',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             v_vColName,
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             1);
                        v_iErrCnt := v_iErrCnt + 1 ;
                    END IF;
                  END IF;
               END IF;
         END LOOP;

        --JIRA 23831 knakra starts
        IF iVarfinKey <> 0 AND (v_iResSubTypeCodeId IS NULL OR v_iResSubTypeCodeId = 0) AND iIncRsvSubType <> 0 THEN
           v_vErrMsgDesc := 'Claim Id: ' || v_vCLAIM_ID || 'Reserve Sub Type is included in the financial key but it is either empty or invalid in the import file. ';
		   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
           v_vErrColumns := 'RESERVE_SUB_TYPE';
           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                       v_iDA_ROW_ID,
                                       'PAYMENT',
                                       'ResSubTypeVFK',
                                       'ResSubTypeVFK',
                                       'DDS_PROCESS_PAYMENTS',
                                       v_vErrMsgDesc,
                                       v_vErrColumns,
                                       'DDS_PAYMENT',
                                       'CLAIM_ID',
                                       v_vCLAIM_ID,
                                       1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
        END IF;
        --JIRA 23831 knakra ends

        IF v_vRESERVE_TYPE IS NULL THEN
             --FixReserveType IF RESERVE_TYPE IS NOT GIVEN IN IMPORT FILE THROUGH UI RESERVE MAPPING
              v_iResTypeCodeId := 0;

            BEGIN
              EXECUTE IMMEDIATE  'SELECT RSV_TYPE_CODE FROM DDS_USR_DEF_RSV_MAP
                 WHERE LOB_CODE = :1
                         AND CONFIG_ID= :2
                         AND BUCKET = :3
                         AND USERID = :4' INTO v_iResTypeCodeId USING
                         v_iLob,v_oConfigId,v_vTYPE_FLAG,v_P_UserId  ;
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
              v_iResTypeCodeId := 0;
              END;

        END IF;

           IF v_iResTypeCodeId IS NULL OR v_iResTypeCodeId = 0 THEN
              IF v_vRESERVE_TYPE IS NULL THEN
                 v_vErrMsgDesc := 'Reserve Bucket is not Mapped, Either Map reserve for LOB: ' || v_vClmLobDb || ' and Bucket: ' || NVL(v_vTYPE_FLAG,'') || ' or provide Reserve in RESERVE_TYPE column of import file. ';
				 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                 v_vErrColumns := 'TYPE_FLAG';
              ELSE
                 v_vErrMsgDesc := 'Invalid Reserve Type: ' || v_vRESERVE_TYPE || ' provided in import file. ';
				 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                 v_vErrColumns := 'RESERVE_TYPE';
              END IF;
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                       v_iDA_ROW_ID,
                                       'PAYMENT',
                                       'ResMap',
                                       'ResMap',
                                       'DDS_PROCESS_PAYMENTS',
                                       v_vErrMsgDesc,
                                       v_vErrColumns,
                                       'DDS_PAYMENT',
                                       'CLAIM_ID',
                                       v_vCLAIM_ID,
                                       1);
              v_iErrCnt := v_iErrCnt + 1 ;
              GOTO NEXTRECORD;
           ELSE
              v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1';

              BEGIN
                     EXECUTE IMMEDIATE v_nSql INTO v_vRsvTypeSCode USING v_iResTypeCodeId;

                     v_nSql := 'SELECT C1.SHORT_CODE FROM ' || v_vDbName || 'CODES C1, ' || v_vDbName || 'CODES C2 WHERE';
                     v_nSql := v_nSql || ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = :1';
                     BEGIN
                       EXECUTE IMMEDIATE v_nSql INTO v_vParentRsvCode USING v_iResTypeCodeId;

                       IF v_vParentRsvCode = 'R' AND v_vTRANSACTION_TYPE = 'P' THEN
                          v_vErrMsgDesc := 'Payments are not allowed on Recovery Reserve: ' || v_vRsvTypeSCode;
						  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                          v_vErrColumns := 'TRANSACTION_TYPE';
                          v_iErrCnt := v_iErrCnt + 1;
                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                           v_iDA_ROW_ID,
                           'PAYMENT',
                           'PmtOnRecRsv',
                           'PmtOnRecRsv',
                           'DDS_PROCESS_PAYMENT',
                           v_vErrMsgDesc,
                           v_vErrColumns,
                           'DDS_PAYMENT',
                           'CLAIM_ID',
                           v_vCLAIM_ID,
                           1);
                       END IF;

                     EXCEPTION

                     WHEN NO_DATA_FOUND THEN
                        v_iErrCnt := v_iErrCnt + 1;
                        v_vErrMsgDesc := 'Incorrect Reserve: ' || v_vRsvTypeSCode || ', as it doesnot belong to any Master Reserve. ';
						v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                         v_iDA_ROW_ID,
                         'PAYMENT',
                         'NoMasterRsv',
                         'NoMasterRsv',
                         'DDS_PROCESS_PAYMENT',
                         v_vErrMsgDesc,
                         'CLAIM_ID',
                         'DDS_PAYMENT',
                         'CLAIM_ID',
                         v_vCLAIM_ID,
                         1);
                     END;

              EXCEPTION

              WHEN OTHERS THEN
                v_iErrCnt := v_iErrCnt + 1;
                v_vErrMsgDesc := SQLERRM;
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                 v_iDA_ROW_ID,
                 'PAYMENT',
                 'RsvTypeSCode',
                 'RsvTypeSCode',
                 'DDS_PROCESS_PAYMENT',
                 v_vErrMsgDesc,
                 'CLAIM_ID',
                 'DDS_PAYMENT',
                 'CLAIM_ID',
                 v_vCLAIM_ID,
                 0);
              END;
           END IF;


           --JIRA 34797 kkaur25 starts
           v_nSql :='SELECT DATE_OF_EVENT FROM ' || v_vDbName || 'EVENT E INNER JOIN ' || v_vDbName || 'CLAIM C ON E.EVENT_ID = C.EVENT_ID WHERE C.CLAIM_ID =:1';
           v_vLocation := 'ErrEvntDate';
                   BEGIN
                     EXECUTE IMMEDIATE v_nSql INTO  v_EventDate USING v_iClaimId;
                      IF v_EventDate > v_vTRANSACTION_DATE THEN
                       v_vErrMsgDesc :='Transaction Date cannot be prior to Event Date. ';
					   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                       v_vErrColumns :='TRANSACTION_DATE';
                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'ErrEvntDate',
                                             'ErrEvntDate',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             v_vErrColumns,
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             1);
                        v_iErrCnt := v_iErrCnt + 1 ;
                      END IF;
                   EXCEPTION
                   WHEN OTHERS THEN
                   v_iErrCnt := v_iErrCnt + 1 ;
                    v_vErrMsgDesc := SQLERRM;
                   DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'EventDate',
                                             'EventDate',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             'CLAIM_ID',
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             0);
                   END;


            --JIRA 34797 kkaur25 ends

           v_iClaimantEid := 0;
           v_iVehicleId := 0;
           v_iChkClaimant := 1;

           --IF v_vUNIT_ID IS NOT NULL AND v_vRECORD_TYPE = 'V' AND v_iUseClaimantTrack <> 0 THEN       --Unit Level Tracking for Vehicle Claims         JIRA 23831 knakra
           IF v_vUNIT_ID IS NOT NULL AND v_vRECORD_TYPE = 'V' AND v_iUseClaimantTrack <> 0 AND iVarFinKey = 0 THEN   --JIRA 23831 knakra
              v_iChkClaimant := 0;
              v_nSql := 'SELECT UC.UNIT_ID FROM ' || v_vDbName || 'VEHICLE V, ' || v_vDbName || 'UNIT_X_CLAIM UC';
              v_nSql := v_nSql || ' WHERE V.UNIT_ID = UC.UNIT_ID AND UC.CLAIM_ID = :1 AND V.VIN = :2';
              BEGIN
                 EXECUTE IMMEDIATE  v_nSql INTO v_iVehicleId USING v_iClaimId, v_vUNIT_ID;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      v_iVehicleId := 0;
                 WHEN OTHERS THEN
                      v_iErrCnt := v_iErrCnt + 1 ;
                       v_vErrMsgDesc := SQLERRM;
                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'Vehicle',
                                             'Vehicle',
                                             'DDS_PROCESS_PAYMENT',
                                             v_vErrMsgDesc,
                                             'CLAIM_ID',
                                             'DDS_PAYMENT',
                                             'CLAIM_ID',
                                             v_vCLAIM_ID,
                                             0);
              END;
              IF v_iVehicleId IS NULL OR v_iVehicleId = 0 THEN
                     v_vErrColumns := 'UNIT_ID';
                     v_vErrMsgDesc := 'VIN: ' || v_vUNIT_ID || ' is not attached to claim: ' || v_vCLAIM_ID;
					 v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                           v_iDA_ROW_ID,
                                           'PAYMENT',
                                           'VehClaim',
                                           'VehClaim',
                                           'DDS_PROCESS_PAYMENTS',
                                           v_vErrMsgDesc,
                                           v_vErrColumns,
                                           'DDS_PAYMENT',
                                           'CLAIM_ID',
                                           v_vCLAIM_ID,
                                           1);
                  v_iErrCnt := v_iErrCnt + 1 ;
              END IF;
           END IF;


IF v_iPayeeTypeCodeId = v_iClmntTypePayee AND v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN
      v_iChkClaimant := 1;
END IF;
   --JIRA 23831 knakra starts
   IF iVarFinKey <> 0 AND iIncClaimant = 0 THEN
     v_iUseClaimantTrack := 0;
     v_iChkClaimant := 0;
   END IF;
   --JIRA 23831 knakra ends
   v_iClmntErr := 0;
   IF ((v_iUseClaimantTrack = 1 OR v_vRECORD_TYPE IN ( 'W','D' ) ) AND v_iChkClaimant = 1 AND iVarFinKey = 0) OR (iVarfinKey <> 0 AND iIncClaimant <> 0) THEN --JIRA 23831 knakra
      IF v_vRECORD_TYPE IN ( 'W','D' ) THEN--FETCH CLAIMANT EID FOR THE GIVEN CLAIM BASED ON LOB AND OPTIONS SELECTED ON UI
         v_nSql := 'SELECT CLAIMANT_EID FROM ' || v_vDbName || 'CLAIMANT CL, ' || v_vDbName || 'CLAIM C WHERE ';
         v_nSql := v_nSql || 'C.CLAIM_ID = CL.CLAIM_ID AND C.CLAIM_ID = :1';

         BEGIN
                EXECUTE IMMEDIATE v_nSql INTO v_iClaimantEid USING v_iClaimId;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_iClaimantEid:=0;
         END;
      ELSE
         IF v_vRECORD_TYPE IN ( 'G','V','H' ) THEN           --JIRA 24633 knakra
            IF v_oMatchClmntBySuffix <> 0 THEN
               IF v_iCLAIMANT_SUFFIX IS NULL THEN
                  v_vErrMsgDesc := 'CLAIMANT_SUFFIX is left blank in import file and Match By Claimant Suffix option is selected. ';
				  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ClmntSuffixNull',
                                        'ClmntSuffixNull',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        'CLAIMANT_SUFFIX',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);
                  v_iErrCnt := v_iErrCnt + 1 ;
                  v_iClmntErr := 1;
               ELSE
                  v_nSql := 'SELECT CLAIMANT_EID FROM ' || v_vDbName || 'CLAIMANT CL, ' || v_vDbName || 'CLAIM C WHERE ';    --JIRA 26805 knakra(added a space after FROM clause)
                  v_nSql := v_nSql || 'C.CLAIM_ID = CL.CLAIM_ID AND CLAIMANT_NUMBER = :1 AND C.CLAIM_ID = :2';

                BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO v_iClaimantEid USING v_iCLAIMANT_SUFFIX, v_iClaimId;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          v_iClaimantEid:=0;
                END;
               END IF;
            ELSE

               v_iClmntErr := 0;
               IF v_vCLMNT_TAX_ID IS NOT NULL THEN             --Check for Tax-Id formats
                 IF dds_is_number(REPLACE(v_vCLMNT_TAX_ID,'-','')) = 1 THEN
                   IF LENGTH(REPLACE(v_vCLMNT_TAX_ID,'-','')) = 9 THEN
                     IF LENGTH(v_vCLMNT_TAX_ID) - LENGTH(REPLACE(v_vCLMNT_TAX_ID,'-','')) = 1 THEN
                       IF INSTR(v_vCLMNT_TAX_ID,'-',1) <> 3 THEN
                         v_iClmntErr := 1;
                         v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
						 
                       END IF;
                     ELSIF LENGTH(v_vCLMNT_TAX_ID) - LENGTH(REPLACE(v_vCLMNT_TAX_ID,'-','')) = 2 THEN
                       IF INSTR(v_vCLMNT_TAX_ID,'-',1) = 4 AND (INSTR(v_vCLMNT_TAX_ID,'-',5) IN (7,8)) THEN
                         v_iClmntErr := 0;
                       ELSE
                         v_iClmntErr := 1;
                         v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
						 
                       END IF;
                     ELSIF LENGTH(v_vCLMNT_TAX_ID) - LENGTH(REPLACE(v_vCLMNT_TAX_ID,'-','')) = 0 THEN
                       v_iClmntErr := 0;
                     ELSE
                       v_iClmntErr := 1;
                       v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
					   
                     END IF;
                   ELSE
                     v_iClmntErr := 1;
                     v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
					 
                   END IF;
                 ELSE
                   v_vErrMsgDesc := 'Tax-Id provided for Claimant is not in Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
				   
                   v_iClmntErr := 1;
                 END IF;
				 
               END IF;

               IF v_iClmntErr = 1 THEN
			   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                  v_iDA_ROW_ID,
                  'PAYMENT',
                  'ClmntTaxIdErr',
                  'ClmntTaxIdErr',
                  'DDS_PROCESS_PAYMENTS',
                  v_vErrMsgDesc,
                  'CLMNT_TAX_ID',
                  'DDS_PAYMENT',
                  'CLAIM_ID',
                  v_vCLAIM_ID,
                  1);
               END IF;

               IF v_vCLMNT_LAST_NAME IS NOT NULL THEN
                  v_nSql := 'SELECT MAX(CLAIMANT_EID) FROM ' || v_vDbName || 'CLAIMANT CL, ' || v_vDbName || 'CLAIM C, ' || v_vDbName || 'ENTITY E ';
                  v_nSql := v_nSql || ' WHERE C.CLAIM_ID = CL.CLAIM_ID AND CL.CLAIMANT_EID = E.ENTITY_ID AND E.LAST_NAME = :1';

                  IF v_vCLMNT_FIRST_NAME IS NOT NULL THEN
                     v_nSql := v_nSql || ' AND E.FIRST_NAME = :2';
                  END IF;

                  IF v_vCLMNT_TAX_ID IS NOT NULL THEN
                     v_nSql := v_nSql || ' AND REPLACE(E.TAX_ID,''-'','''') = ''' || REPLACE(v_vCLMNT_TAX_ID, '-', '') || '''';
                  END IF;
                  v_nSql := v_nSql || ' AND C.CLAIM_ID = :3';

                  BEGIN
                      IF v_vCLMNT_FIRST_NAME IS NULL AND v_iClmntErr = 0 THEN
                        EXECUTE IMMEDIATE v_nSql INTO v_iClaimantEid USING v_vCLMNT_LAST_NAME,v_iClaimId;
                      ELSIF v_vCLMNT_FIRST_NAME IS NOT NULL AND v_iClmntErr = 0 THEN
                         EXECUTE IMMEDIATE v_nSql INTO v_iClaimantEid USING v_vCLMNT_LAST_NAME,v_vCLMNT_FIRST_NAME, v_iClaimId;
                      END IF;
                  EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            v_iClaimantEid:=0;
                  END;
               ELSE
          v_iClmntErr := 1;
                  v_vErrMsgDesc := 'CLAIMANT_LAST_NAME is left blank in import file and Match By Claimant Name option is selected. ';
				  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ClmntNameNull',
                                        'ClmntNameNull',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        'CLMNT_LAST_NAME',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);
                v_iErrCnt := v_iErrCnt + 1 ;
               END IF;
            END IF;
         END IF;

      END IF;

      BEGIN
            /*Limitation:Syntax Not Recognized:SET @iErrCnt + = 1 ; */
            IF v_vRECORD_TYPE IN ( 'G','W','V','D','H' ) THEN --JIRA 24633 knakra
               IF ( v_iClaimantEid IS NULL OR v_iClaimantEid = 0 )
                 AND ( v_iCarrierFlag <> 0 OR ( v_iCarrierFlag = 0
                 AND ( v_vRECORD_TYPE IN ( 'W','D' )
                 OR v_iUseClaimantTrack = 1 )
                 AND v_iChkClaimant = 1 ) ) THEN

                  v_vErrColumns := '';
                  IF v_iCLAIMANT_SUFFIX IS NOT NULL THEN
                     v_vErrColumns := 'CLAIMANT_SUFFIX';
                  END IF;

                  v_vErrMsgDesc := 'Claimant with Claimant Suffix: ' || NVL(v_iCLAIMANT_SUFFIX, '');

                  IF v_vCLMNT_LAST_NAME IS NOT NULL THEN
                     v_vErrColumns := v_vErrColumns || ',CLMNT_LAST_NAME';
                     v_vErrMsgDesc := v_vErrMsgDesc || ', LAST_NAME: ' || v_vCLMNT_LAST_NAME;
                  END IF;

                  IF v_vCLMNT_FIRST_NAME IS NOT NULL THEN
                     v_vErrColumns := v_vErrColumns || ',CLMNT_FIRST_NAME';
                     v_vErrMsgDesc := v_vErrMsgDesc || ', FIRST_NAME: ' || v_vCLMNT_FIRST_NAME;
                  END IF;

                  IF v_vCLMNT_TAX_ID IS NOT NULL THEN
                     v_vErrColumns := v_vErrColumns || ',CLMNT_TAX_ID';
                     v_vErrMsgDesc := v_vErrMsgDesc || ', TAX_ID: ' || v_vCLMNT_TAX_ID;
                  END IF;

                  v_vErrMsgDesc := v_vErrMsgDesc || ' is not attached to the Claim with Claim Number: ' || v_vCLAIM_ID;
				  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                  IF SUBSTR(v_vErrColumns, 0, 1) = ',' THEN
                     --v_vErrColumns := SUBSTR(v_vErrColumns, -1, LENGTH(v_vErrColumns) - INSTR(v_vErrColumns, ',', 1));
                     v_vErrColumns := SUBSTR(v_vErrColumns, INSTR(v_vErrColumns, ',', 1)+1, LENGTH(v_vErrColumns) - INSTR(v_vErrColumns, ',', 1));
                     -- kAPIL Need to check this statement
                  END IF;

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ClmntClmAttach',
                                        'ClmntClmAttach',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);
                   v_iErrCnt := v_iErrCnt + 1 ;
               END IF;
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
               v_iErrCnt := v_iErrCnt + 1 ;
               v_vErrMsgDesc := SQLERRM;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     'ClmntFetch',
                                     'ClmntFetch',
                                     'DDS_PROCESS_PAYMENT',
                                     v_vErrMsgDesc,
                                     'CLAIM_ID',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     0);
      END;
   END IF;


IF v_vTRANSACTION_TYPE IN ('P','C') THEN
      IF v_iPayeeTypeCodeId = v_iClmntTypePayee AND v_iClaimantEid IS NOT NULL AND v_iClaimantEid > 0 THEN--Payee is of Claimant Type
        v_iPayeeEid := v_iClaimantEid;
        v_iEntId := 0;

        IF v_vPAYEE_LASTNAME IS NOT NULL THEN
          v_nSql := 'SELECT ENTITY_ID FROM ' || v_vDbName || 'ENTITY WHERE LAST_NAME = :1';
          v_nSql := v_nSql || ' AND ENTITY_ID = :2';
          IF v_vPAYEE_FIRSTNAME IS NOT NULL THEN
            v_nSql := v_nSql || ' AND FIRST_NAME = :3';
          END IF;
          IF v_vPAYEE_TAX_ID_NO IS NOT NULL THEN
            v_nSql := v_nSql || ' AND REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(v_vPAYEE_TAX_ID_NO,'-','') || '''';
          END IF;
          BEGIN
            IF v_vPAYEE_FIRSTNAME IS NOT NULL THEN
              EXECUTE IMMEDIATE v_nSql INTO v_iEntId USING v_vPAYEE_LASTNAME, v_iClaimantEid, v_vPAYEE_FIRSTNAME;
            ELSE
              EXECUTE IMMEDIATE v_nSql INTO v_iEntId USING v_vPAYEE_LASTNAME, v_iClaimantEid;
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_iErrCnt := v_iErrCnt+1;
              v_vErrMsgDesc := 'Payee is of Claimant Type but information provided for Payee is different from Claimant information. ';
			  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
              v_vErrColumns := 'PAYEE_LASTNAME, PAYEE_FIRSTNAME, PAYEE_TAX_ID_NO';
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
              v_iDA_ROW_ID,
              'PAYMENT',
              'ClmntTypePayee',
              'ClmntTypePayee',
              'DDS_PROCESS_PAYMENT',
              v_vErrMsgDesc,
              v_vErrColumns,
              'DDS_PAYMENT',
              'CLAIM_ID',
              v_vCLAIM_ID,
              1);
            WHEN OTHERS THEN
              v_vErrMsgDesc := SQLERRM;
              v_iErrCnt := v_iErrCnt+1;
              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
              v_iDA_ROW_ID,
              'PAYMENT',
              'ClmntPayeeErr',
              'ClmntPayeeErr',
              'DDS_PROCESS_PAYMENT',
              v_vErrMsgDesc,
              'CLAIM_ID',
              'DDS_PAYMENT',
              'CLAIM_ID',
              v_vCLAIM_ID,
              0);
          END;
        END IF;
      ELSE
         v_iPayeeEid := 0;
         v_iPayeeErr := 0;
         IF v_vPAYEE_LASTNAME IS NOT NULL THEN
            IF v_vPAYEE_STATE IS NOT NULL THEN
               v_nSql := 'SELECT STATE_ROW_ID FROM ' || v_vDbName || 'STATES WHERE STATE_ID = :1';
               BEGIN
                     EXECUTE IMMEDIATE v_nSql INTO v_iStateRowId USING v_vPAYEE_STATE;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_iStateRowId:=0;
                     v_iErrCnt := v_iErrCnt+1;
                  WHEN OTHERS THEN
                        v_vErrMsgDesc := SQLERRM;
                        v_iErrCnt := v_iErrCnt+1;
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDA_ROW_ID,
                                              'PAYMENT',
                                              'StateId',
                                              'StateId',
                                              'DDS_PROCESS_PAYMENT',
                                              v_vErrMsgDesc,
                                              'CLAIM_ID',
                                              'DDS_PAYMENT',
                                              'CLAIM_ID',
                                              v_vCLAIM_ID,
                                              0);
               END;
                IF v_iStateRowId IS NULL OR v_iStateRowId = 0 THEN
                    v_vErrColumns := 'PAYEE_STATE';
                    v_iPayeeErr := 1;
                    v_vErrMsgDesc := 'Invalid State: ' || v_vPAYEE_STATE || ' provided in import file. ';
					v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                          v_iDA_ROW_ID,
                                          'PAYMENT',
                                          'StateRowId',
                                          'StateRowId',
                                          'DDS_PROCESS_PAYMENTS',
                                          v_vErrMsgDesc,
                                          v_vErrColumns,
                                          'DDS_PAYMENT',
                                          'CLAIM_ID',
                                          v_vCLAIM_ID,
                                          1);
                 END IF;

            END IF;
             v_iPayeeErr := 0;
             IF v_vPAYEE_TAX_ID_NO IS NOT NULL THEN  --Check for Payee Tax-Id formats
               IF dds_is_number(REPLACE(v_vPAYEE_TAX_ID_NO,'-','')) = 1 THEN
                 IF LENGTH(REPLACE(v_vPAYEE_TAX_ID_NO,'-','')) = 9 THEN
                   IF LENGTH(v_vPAYEE_TAX_ID_NO) - LENGTH(REPLACE(v_vPAYEE_TAX_ID_NO,'-','')) = 1 THEN
                     IF INSTR(v_vPAYEE_TAX_ID_NO,'-',1) <> 3 THEN
                       v_iPayeeErr := 1;
                       v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
					   
                     END IF;
                   ELSIF LENGTH(v_vPAYEE_TAX_ID_NO) - LENGTH(REPLACE(v_vPAYEE_TAX_ID_NO,'-','')) = 2 THEN
                     IF INSTR(v_vPAYEE_TAX_ID_NO,'-',1) = 4 AND (INSTR(v_vPAYEE_TAX_ID_NO,'-',5) IN (7,8)) THEN
                       v_iPayeeErr := 0;
                     ELSE
                       v_iPayeeErr := 1;
                       v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
					   
                     END IF;
                   ELSIF LENGTH(v_vPAYEE_TAX_ID_NO) - LENGTH(REPLACE(v_vPAYEE_TAX_ID_NO,'-','')) = 0 THEN
                     v_iPayeeErr := 0;
                   ELSE
                     v_iPayeeErr := 1;
                     v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
					 
                   END IF;
                 ELSE
                   v_iPayeeErr := 1;
                   v_vErrMsgDesc := 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
				   
                 END IF;
               ELSE
                 v_vErrMsgDesc := 'Tax-Id provided for Payee is not in Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######)';
				 
                 v_iPayeeErr := 1;
               END IF;
             END IF;

             IF v_iPayeeErr = 1 THEN
			 v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                v_iErrCnt := v_iErrCnt + 1;
                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                v_iDA_ROW_ID,
                'PAYMENT',
                'PayeeTaxIdErr',
                'PayeeTaxIdErr',
                'DDS_PROCESS_PAYMENTS',
                v_vErrMsgDesc,
                'PAYEE_TAX_ID',
                'DDS_PAYMENT',
                'CLAIM_ID',
                v_vCLAIM_ID,
                1);
             END IF;
            /*Limitation:Syntax Not Recognized:SET @iErrCnt + = 1 ; */
            IF v_iPayeeErr = 0 THEN
			   ---AKUMAR523 RMA-63197 STARTS 
			   ---IF UPPER(v_vPAYEE_TYPE) <> 'E' AND UPPER(v_vPAYEE_TYPE) <> 'C' AND UPPER(v_vPAYEE_TYPE) <> 'P' AND UPPER(@vPAYEE_TYPE) <> 'O'
			  --- IF v_vPAYEE_TYPE_TEST IS NOT NULL THEN 
				---	v_vTableName := UPPER(v_vPAYEE_TYPE_TEST);
               -- ---ELSE
				  -- IF v_vPAYEE_TYPE = 'C' THEN
                    -- v_vTableName := 'EMPLOYEE';
                  -- ELSE
					-- v_vTableName := 'OTHER_PEOPLE';
				  -- END IF;	
               -- END IF;
			   v_vTableName:= v_vTableNamePayeType;
               v_vErrMsgDesc := '';

/*               INSERT INTO tt_v_utPayee
                 ( iJobId, iDaRowId, vLastName, vFirstName, vMiddleName, vAbbr, vTaxId, vAddr1, vAddr2, vCity, vCountry, vState, vCounty, vZip, vPhone1, vPhone2, vFaxNumber, vBirthDate, vSexCode, vComment, iParentEid, vTableName, iRpt1099Flag, iPrefixCodeId, iSuffixCodeId, vSuffixLegal, iNameType, vEmpNum )
                 VALUES ( v_P_JOBID, v_iDA_ROW_ID, v_vPAYEE_LASTNAME, v_vPAYEE_FIRSTNAME, NULL, NULL, v_vPAYEE_TAX_ID_NO, v_vPAYEE_ADDRESS, v_vPAYEE_ADDRESS2, v_vPAYEE_CITY, NULL, v_iStateRowId, NULL, v_vPAYEE_ZIP, NULL, NULL, NULL, NULL, NULL, NULL, 0, v_vTableName, 0, 0, 0, NULL, v_iNameType, v_vEMP_NUM );

*/
                 VENTITY_TYPE := DDS_ENTITY_TYPE(v_vPAYEE_LASTNAME,
                                                  v_vPAYEE_FIRSTNAME,
                                                  NULL,
                                                  NULL,
                                                  v_vPAYEE_TAX_ID_NO,
                                                  v_vPAYEE_ADDRESS,
                                                  v_vPAYEE_ADDRESS2,
                                                  v_vPAYEE_CITY,
                                                  NULL,
                                                  v_iStateRowId,
                                                  NULL,
                                                  v_vPAYEE_ZIP,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  v_vPAYEE_DOB,
                                                  NULL,
                                                  NULL,
                                                  0,
                                                  v_vTableName,
                                                  0,
                                                  v_iPrefixCodeId,
                                                  v_iSuffCommonCodeId, --NULL, v_iNameType, v_vEMP_NUM
                                                  v_vSUFFIX_LEGAL,
                                                  v_iNameType,
                                                  v_vEMP_NUM,
                                                  v_P_JOBID,
                                                  v_iDA_ROW_ID
                                                   );
             PROCESS_ENTITY(VENTITY_TYPE,          --Fetch PayeeEid on the basis of Information given
                            v_P_JOBID,
                            v_iDA_ROW_ID,
                            v_vDbName,
                            'PAYMENT',
                            0,
                            1,
                            'ERRLOC',
                            v_vCLAIM_ID,
                            1,
                            v_iPayeeEid,
                            v_vErrMsgDesc);




               IF v_vErrMsgDesc is not null THEN
                  IF v_vTableName = 'EMPLOYEE' THEN
                     IF v_oEmpMatchByEmpNum <> 0 THEN
                        v_vErrColumns := 'EMP_NUM';
                     END IF;

                     IF v_oEmpMatchByName <> 0 THEN
                        v_vErrColumns := v_vErrColumns || ',PAYEE_LASTNAME,PAYEE_FIRSTNAME';
                     END IF;

                     IF v_oEmpMatchByTaxId <> 0 THEN
                        v_vErrColumns := v_vErrColumns || ',PAYEE_TAX_ID_NO';
                     END IF;
         IF v_oEmpMatchByDob <> 0 THEN
           v_vErrColumns := v_vErrColumns || ',PAYEE_DOB';
         END IF;
                  ELSE
                     IF v_oNonEmpMatchByName <> 0 THEN
                        v_vErrColumns := 'PAYEE_LASTNAME,PAYEE_FIRSTNAME';
                     END IF;

                     IF v_oNonEmpMatchByTaxId <> 0 THEN
                        v_vErrColumns := v_vErrColumns||',PAYEE_TAX_ID_NO';
                     END IF;
         IF v_oNonEmpMatchByDob <> 0 THEN
           v_vErrColumns := v_vErrColumns||',PAYEE_DOB';
         END IF;
                  END IF;

                  --v_vErrColumns := SUBSTR(v_vErrColumns, -1, LENGTH(v_vErrColumns) - INSTR(v_vErrColumns, ',', 1));
                  IF RPAD(v_vErrColumns,1) = ',' THEN
                    v_vErrColumns := SUBSTR(v_vErrColumns, INSTR(v_vErrColumns, ',', 1)+1, LENGTH(v_vErrColumns) - INSTR(v_vErrColumns, ',', 1));
                  END IF;
                  -- Kapil need to check the above statement

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ProcessEnt',
                                        'ProcessEnt',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);
                  v_iErrCnt := v_iErrCnt+1;
               END IF;
            END IF;
         END IF;
      END IF;
      --JIRA 43536 knakra starts
      IF v_vPAYEE_TYPE = 'P' AND v_iPayeeErr = 0 THEN
            v_nSql := 'SELECT E.ENTITY_ID FROM ' || v_vDbName || 'ENTITY E INNER JOIN ' || v_vDbName || 'PERSON_INVOLVED PI';
            v_nSql := v_nSql || ' ON PI.PI_EID = E.ENTITY_ID INNER JOIN ' || v_vDbName || 'EVENT EV ON EV.EVENT_ID = PI.EVENT_ID INNER JOIN ' || v_vDbName || 'CLAIM C';
            v_nSql := v_nSql || ' ON C.EVENT_ID = EV.EVENT_ID WHERE C.CLAIM_ID = :1';
            IF v_oNonEmpMatchByName <> 0 THEN
              v_nSql := v_nSql || ' AND E.LAST_NAME = ''' || v_vPAYEE_LASTNAME || '''';
              IF v_vPAYEE_FIRSTNAME IS NOT NULL THEN
                 v_nSql := v_nSql || ' AND E.FIRST_NAME = ''' || v_vPAYEE_FIRSTNAME || '''';
              END IF;
            END IF;
            IF v_oNonEmpMatchByTaxId <> 0 THEN
              v_nSql := v_nSql || ' AND E.TAX_ID = ''' || v_vPAYEE_TAX_ID_NO || '''';
            END IF;
            IF v_oNonEmpMatchByDob <> 0 THEN
              v_nSql := v_nSql || ' AND E.BIRTH_DATE = ''' || v_vPAYEE_DOB || '''';
            END IF;
            
            v_iRetVal := 0;
            BEGIN
                EXECUTE IMMEDIATE v_nSql INTO v_iRetVal USING v_iClaimId;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                 v_iRetVal := 0;
            END;
            
            IF v_iRetVal = 0 THEN
               v_vErrColumns := 'PAYEE_LASTNAME,PAYEE_FIRSTNAME,PAYEE_TAX_ID_NO,PAYEE_DOB';
               v_vErrMsgDesc := 'Payee Type Code is ''Person Involved'' and no PI attached to the Claim with the provided Payee Information. ';
			   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                              v_iDA_ROW_ID,
                              'PAYMENT',
                              'PayeeNotPI',
                              'PayeeNotPI',
                              'DDS_PROCESS_PAYMENTS',
                              v_vErrMsgDesc,
                              v_vErrColumns,
                              'DDS_PAYMENT',
                              'CLAIM_ID',
                              v_vCLAIM_ID,
                              1);

               v_iErrCnt := v_iErrCnt + 1;
            ELSE
               v_iPayeeEid := v_iRetVal;
            END IF;
            
        END IF;    
          --JIRA 43536 knakra ends
   END IF;
   -- Kapil done till here 2-Mar-2016

   IF v_iUseClaimantTrack = 0
     AND v_vRECORD_TYPE IN ( 'G','V','H' ) THEN--CLAIMANT_EID WILL BE 0 IF CLAIMANT TRACKING IS OFF FOR GC OR VC IN CORPORATE
      v_iClaimantEid := 0;
      v_iVehicleId := 0;
   END IF;

   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 AND iIncClaimant = 0 THEN
      v_iClaimantEid := 0;
      v_iVehicleId := 0;
   END IF;
   --JIRA 23831 knakra ends

   --JIRA 24023 knakra starts
   IF v_iResTypeCodeId IS NOT NULL AND v_iResTypeCodeId <> 0 AND v_vTRANSACTION_TYPE IN('R','P','C') THEN
     v_nSql := 'SELECT RESERVE_TYPE_CODE FROM ' || v_vDbName || 'SYS_LOB_RESERVES WHERE LINE_OF_BUS_CODE = :1';
     v_nSql := v_nSql || ' AND RESERVE_TYPE_CODE = :2';

     BEGIN
     EXECUTE IMMEDIATE V_NSQL INTO v_iCodeId USING v_iLob,v_iResTypeCodeId;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
          v_iCodeId := 0;
     END;


     IF v_iCodeId = 0 OR v_iCodeId IS NULL THEN
        v_vErrMsgDesc := 'Reserve Type: ' || v_vResTypeCode || ', is not mapped with Line Of Business: ' || NVL(v_vRECORD_TYPE, '');
        v_vErrMsgDesc := v_vErrMsgDesc || ', Its mapping needs to be created from UI in Line of Business Parameter Setup. ';
		v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

        IF v_vRESERVE_TYPE IS NULL THEN
           v_vErrColumns := 'TYPE_FLAG';
        ELSE
           v_vErrColumns := 'RESERVE_TYPE';
        END IF;

        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                              v_iDA_ROW_ID,
                              'PAYMENT',
                              'ResLob',
                              'ResLob',
                              'DDS_PROCESS_PAYMENTS',
                              v_vErrMsgDesc,
                              v_vErrColumns,
                              'DDS_PAYMENT',
                              'CLAIM_ID',
                              v_vCLAIM_ID,
                              1);

        v_iErrCnt := v_iErrCnt + 1;
     END IF;
   END IF;
   --JIRA 24023 knakra ends

   --PAYMENTS SPECIFIC VALIDATIONS STARTS
   IF v_vTRANSACTION_TYPE IN ( 'P','C' )
     AND v_iTransTypeCodeId IS NOT NULL
     AND v_iTransTypeCodeId > 0
     AND v_iResTypeCodeId IS NOT NULL
     AND v_iResTypeCodeId > 0 THEN
      --check if the transaction is the child of reserve starts
      v_nSql := 'SELECT CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1';
      v_nSql := v_nSql || ' AND RELATED_CODE_ID = :2';

      BEGIN
            v_vLocation := 'ResTransErr';

            BEGIN
            EXECUTE IMMEDIATE v_nSql INTO v_iCodeId USING v_iTransTypeCodeId, v_iResTypeCodeId;
            EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_iCodeId:=0;
            END;


            v_vLocation := 'ResScode';
            v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1';

            BEGIN
            EXECUTE IMMEDIATE v_nSql INTO v_vResTypeCode USING v_iResTypeCodeId;
            EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  v_vResTypeCode:=0;
            END;

            IF v_iCodeId = 0 OR v_iCodeId IS NULL THEN
               v_vErrMsgDesc := 'Transaction Type: ' || v_vTYPE_CODE || ' is invalid for reserve type: ' || v_vResTypeCode;
			   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     'ResTrans',
                                     'ResTrans',
                                     'DDS_PROCESS_PAYMENTS',
                                     v_vErrMsgDesc,
                                     'TYPE_CODE',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     1);
               v_iErrCnt := v_iErrCnt + 1;
               --JIRA 24023 knakra starts(made this code common for both Reserves and Payments)
            /*ELSIF V_iCodeId <> 0 AND V_iCodeId IS NOT NULL  --knakra lob reserve starts
            THEN

               v_nSql := 'SELECT RESERVE_TYPE_CODE FROM ' || v_vDbName || 'SYS_LOB_RESERVES WHERE LINE_OF_BUS_CODE = :1';
               v_nSql := v_nSql || ' AND RESERVE_TYPE_CODE = :2';

               BEGIN
               EXECUTE IMMEDIATE V_NSQL INTO v_iCodeId USING v_iLob,v_iResTypeCodeId;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_iCodeId := 0;
               END;


               IF v_iCodeId = 0 OR v_iCodeId IS NULL THEN
                  v_vErrMsgDesc := 'Reserve Type: ' || v_vResTypeCode || ', is not mapped with Line Of Business: ' || NVL(v_vRECORD_TYPE, '');
                  v_vErrMsgDesc := v_vErrMsgDesc || ', Its mapping needs to be created from UI in Line of Business Parameter Setup. ';

                  IF v_vRESERVE_TYPE IS NULL THEN
                     v_vErrColumns := 'TYPE_FLAG';
                  ELSE
                     v_vErrColumns := 'RESERVE_TYPE';
                  END IF;

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ResLob',
                                        'ResLob',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);

                  v_iErrCnt := v_iErrCnt + 1;
                  --knakra lob reserve ends
               END IF; */
               --JIRA 24023 knakra ends
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
               v_vErrMsgDesc := SQLERRM;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     v_vLocation,
                                     v_vLocation,
                                     'DDS_PROCESS_PAYMENT',
                                     v_vErrMsgDesc,
                                     'CLAIM_ID',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     0);
               v_iErrCnt := v_iErrCnt + 1;
      END;

      --check if the transaction is the child of reserve ends
      --****BANK ACCOUNT VALIDATION STARTS****
      --if Bank account number from csv is not empty, then find matched bank account ID
      v_iAccountId := 0;

      IF v_vBANK_ACCOUNT_NUM IS NOT NULL THEN
         v_nSql := 'SELECT ACCOUNT_ID FROM ' || v_vDbName || 'ACCOUNT WHERE ACCOUNT_NUMBER = :1';
         BEGIN
            EXECUTE IMMEDIATE v_nSql INTO v_iAccountId USING v_vBANK_ACCOUNT_NUM;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_iAccountId:=0;
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'AccId',
                                        'AccId',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
                  v_iErrCnt := v_iErrCnt + 1;
         END;
      END IF;

      BEGIN
            --using sub_acc_number alone, can't determine the unique sub_row_id, account_id is also needed.
            --if Bank Sub account number from csv is not empty, then find matched bank sub account ID
            v_iSubAccId := 0;

            IF v_vBANK_SUB_ACCNT_NUM IS NOT NULL THEN
               v_nSql := 'SELECT SUB_ROW_ID FROM ' || v_vDbName || 'BANK_ACC_SUB WHERE SUB_ACC_NUMBER = :1 AND';
               v_nSql := v_nSql || ' ACCOUNT_ID = :2';

               v_vLocation := 'SubAccId';

               BEGIN
                EXECUTE IMMEDIATE v_nSql INTO v_iSubAccId USING v_vBANK_SUB_ACCNT_NUM,v_iAccountId;
               EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                    v_iSubAccId:=0;
               END;
           END IF;

            --Fetch the value of USE_SUB_ACCOUNT from SYS_PARMS
            v_nSql := 'SELECT USE_SUB_ACCOUNT FROM ' || v_vDbName || 'SYS_PARMS';
            v_vLocation := 'UseSubAcc';

             BEGIN
              EXECUTE IMMEDIATE v_nSql INTO v_iUseSubAcc;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                  v_iUseSubAcc:=0;
             END;

            IF ( v_iUseSubAcc = 0 ) THEN
               v_g_iAccountId := v_oPayBankAcc;
           ELSE
               IF ( v_iUseSubAcc <> 0 ) THEN
                  v_g_iSubAccId := v_oPaySubAcc;
               END IF;
            END IF;

            --There are 4 combinations of lSubAcctID and lAccountID.  If both are none-zero, then both are correct,
            --(sub row id is determined by correct combination of sub acc number and account number); if lAccountID is non-zero and
            --sub row id is zero, that is OK; case of lAccountID 0 and sub row id non-zero can't happen because the way sub row id
            --was obtained; only case need to consider is both are zero. in this case, we will use default from the option window.
            IF ( v_iAccountId = 0 AND v_iSubAccId = 0 ) THEN
               IF ( v_g_iAccountId > 0 ) THEN
                  v_iAccountId := v_g_iAccountId;
               ELSE
                  IF ( v_g_iSubAccId > 0 ) THEN
                     v_nSql := 'SELECT ACCOUNT_ID FROM ' || v_vDbName || 'BANK_ACC_SUB WHERE SUB_ROW_ID =:1';
                     v_vLocation := 'SubBank';

                     BEGIN
                      EXECUTE IMMEDIATE v_nSql INTO v_iAccountId USING v_g_iSubAccId;
                     EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                          v_iUseSubAcc:=0;
                     END;
                     v_iSubAccId := v_g_iSubAccId;--CHECK THIS PENDING
                  END IF;
               END IF;
            END IF;
      EXCEPTION
         WHEN OTHERS THEN
               ---(@iAccountId=0 AND @iSubAccId=0) ends here
               v_vErrMsgDesc := SQLERRM;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     v_vLocation,
                                     v_vLocation,
                                     'DDS_PROCESS_PAYMENT',
                                     v_vErrMsgDesc,
                                     'CLAIM_ID',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     0);
               v_iErrCnt := v_iErrCnt + 1;
      END;
      --****BANK ACCOUNT VALIDATION ENDS****
      --****CHECK NUMBER VALIDATION STARTS****
	  --Sdalvi3 Jira 65683 
	  IF v_vCHECK_STATUS = 'P' THEN
		IF v_vCHECK_NO IS NULL AND v_vCHECK_NO = 0 THEN
			v_vErrMsgDesc := 'Check Number is Required Field for Printed Payments and is Null or Empty in Import file. ';
			v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
			DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                              v_iDA_ROW_ID,
                              'PAYMENT',
                              'ChkNumErr',
                              'ChkNumErr',
                              'DDS_PROCESS_PAYMENTS',
                              v_vErrMsgDesc,
                              'CHECK_NO',
                              'DDS_PAYMENT',
                              'CLAIM_ID',
                              v_vCLAIM_ID,
                              1);
		END IF;
	  ELSE
		BEGIN
			IF DDS_IS_number(v_vCHECK_NO) = 1 THEN
				IF v_vCHECK_NO < 2147483647 THEN
					v_iTransNumber := v_vCHECK_NO;
				ELSE
					v_iTransNumber := 0;
				END IF;
			ELSE
				v_iTransNumber := 0;
			END IF;

			IF (v_oAttachTransIdToChkNum IS NULL OR v_oAttachTransIdToChkNum = 0) AND v_vCHECK_NO IS NOT NULL THEN
				IF v_iCHECK_SUFFIX IS NOT NULL AND LENGTH(v_iCHECK_SUFFIX) > 0 THEN
					v_vCHECK_NO := v_vcheck_NO || '-' || v_iCHECK_SUFFIX;
				END IF;
				v_nSql := 'SELECT TRANS_ID FROM ' || v_vDbName || 'FUNDS WHERE CTL_NUMBER = :1';

				BEGIN
					EXECUTE IMMEDIATE v_nSql INTO v_iTransid USING v_vCHECK_NO;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
						v_iTransid:=0;
					WHEN OTHERS THEN
					V_iErrCnt  := V_iErrCnt + 1 ;
					v_vErrMsgDesc := SQLERRM;
					DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ChkNumErr',
                                        'ChkNumErr',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
				END;

				IF v_iTransid IS NOT NULL AND v_iTransid <> 0 THEN
					v_vErrMsgDesc := 'Check Number: ' || v_vCHECK_NO || ' already exists in Database. Either provide a unique Check Number or Select ''Attach Trans Id to Check Num'' on UI. ';
					v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
					DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                    v_iDA_ROW_ID,
                                    'PAYMENT',
                                    'ChckNum',
                                    'ChckNum',
                                    'DDS_PROCESS_PAYMENTS',
                                    v_vErrMsgDesc,
                                    'CHECK_NO',
                                    'DDS_PAYMENT',
                                    'CLAIM_ID',
                                    v_vCLAIM_ID,
                                    1);
				END IF;
			END IF;
		END;
	  END IF;
	  --****CHECK NUMBER VALIDATION ENDS****

      IF v_iMemoCodeId IS NOT NULL AND v_iMemoCodeId <> 0 THEN
         v_vMEMO := NVL(v_vMEMO, '') || NVL(v_vMEMO_PHRASE, '');
         v_vMEMO := SUBSTR(v_VMEMO, 0, 255);
      END IF;

      IF v_vTRANSACTION_TYPE = 'P' THEN
         v_iPayFlag := 1;
         v_iColFlag := 0;
      ELSE
         v_iPayFlag := 0;
         v_iColFlag := 1;
      END IF;

      IF v_vCHECK_STATUS = 'V' THEN
         v_iVoidFlag := 1;
      ELSE
         v_iVoidFlag := 0;
      END IF;

      --JIRA 22820 knakra strats
      IF SUBSTR(v_vCLEARED_FLAG, 0, 1) <> 'Y' AND SUBSTR(v_vCLEARED_FLAG, 0, 1) <> 'N' AND SUBSTR(v_vCLEARED_FLAG, 0, 1) IS NOT NULL THEN
         v_vErrMsgDesc := 'Invalid Flag Value' || v_vCLEARED_FLAG || ', provided for CLEARED_FLAG. It should be either Y or N. ';
		 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
         DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                               v_iDA_ROW_ID,
                               'PAYMENT',
                               'InvalidClrFlag',
                               'InvalidClrFlag',
                               'DDS_PROCESS_PAYMENTS',
                               v_vErrMsgDesc,
                               'CLEARED_FLAG',
                               'DDS_PAYMENT',
                               'CLAIM_ID',
                               v_vCLAIM_ID,
                               1);
          V_iErrCnt := V_iErrCnt + 1;
      ELSE
        IF SUBSTR(v_vCLEARED_FLAG, 0, 1) = 'Y' THEN
           v_iClearedFlag := 1;
        ELSE
           IF SUBSTR(v_vCLEARED_FLAG, 0, 1) = 'N' OR v_vCLEARED_FLAG IS NULL THEN
              v_iClearedFlag := 0;
           END IF;
        END IF;
        
        --JIRA 38951 knakra starts
        IF v_iVoidFlag = 1 AND v_iClearedFlag = 1 THEN
           v_vErrMsgDesc := 'Clear Flag and Void Flag both cannot be set for a transaction. ';
		   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                 v_iDA_ROW_ID,
                                 'PAYMENT',
                                 'ClrVoidFlag',
                                 'ClrVoidFlag',
                                 'DDS_PROCESS_PAYMENTS',
                                 v_vErrMsgDesc,
                                 'CLEARED_FLAG,DATE_CLEARED,CHECK_STATUS',
                                 'DDS_PAYMENT',
                                 'CLAIM_ID',
                                 v_vCLAIM_ID,
                                 1);
            V_iErrCnt := V_iErrCnt + 1;
        END IF;
        --JIRA 38951 knakra ends
        
        IF ( v_iClearedFlag = 1 OR v_iVoidFlag = 1 ) AND v_vDATE_CLEARED IS NULL THEN
           v_vErrMsgDesc := 'If Clear Flag is set or Check Status is void, Date Cleared can not be left blank. ';
		   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                 v_iDA_ROW_ID,
                                 'PAYMENT',
                                 'ClrFlag',
                                 'ClrFlag',
                                 'DDS_PROCESS_PAYMENTS',
                                 v_vErrMsgDesc,
                                 'CLEARED_FLAG,DATE_CLEARED,CHECK_STATUS',
                                 'DDS_PAYMENT',
                                 'CLAIM_ID',
                                 v_vCLAIM_ID,
                                 1);
            V_iErrCnt := V_iErrCnt + 1;
        END IF;
      END IF;
      --JIRA 22820 knakra ends

      --JIRA 22822 knakra starts
      IF v_vSERVICE_FROM_DATE IS NOT NULL AND v_vSERVICE_TO_DATE IS NULL THEN
            v_vErrMsgDesc := 'SERVICE_FROM_DATE provided in the import file. Please provide date in SERVICE_TO_DATE also. ';
			v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                 v_iDA_ROW_ID,
                                 'PAYMENT',
                                 'SrvToDate',
                                 'SrvToDate',
                                 'DDS_PROCESS_PAYMENTS',
                                 v_vErrMsgDesc,
                                 'SERVICE_TO_DATE',
                                 'DDS_PAYMENT',
                                 'CLAIM_ID',
                                 v_vCLAIM_ID,
                                 1);
            V_iErrCnt := V_iErrCnt + 1;
      ELSIF v_vSERVICE_FROM_DATE IS NULL AND v_vSERVICE_TO_DATE IS NOT NULL THEN
            v_vErrMsgDesc := 'SERVICE_TO_DATE provided in the import file. Please provide date in SERVICE_FROM_DATE also.';
			v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                 v_iDA_ROW_ID,
                                 'PAYMENT',
                                 'SrvToDate',
                                 'SrvToDate',
                                 'DDS_PROCESS_PAYMENTS',
                                 v_vErrMsgDesc,
                                 'SERVICE_FROM_DATE',
                                 'DDS_PAYMENT',
                                 'CLAIM_ID',
                                 v_vCLAIM_ID,
                                 1);
            V_iErrCnt := V_iErrCnt + 1;
      ELSIF v_vSERVICE_FROM_DATE IS NOT NULL AND v_vSERVICE_TO_DATE IS NOT NULL AND DDS_IS_DATE(v_vSERVICE_FROM_DATE) = 1 AND DDS_IS_DATE(v_vSERVICE_TO_DATE) = 1 THEN
            IF v_vSERVICE_FROM_DATE > v_vSERVICE_TO_DATE THEN
               v_vErrMsgDesc := 'SERVICE_FROM_DATE: ' || v_vSERVICE_FROM_DATE || ' should be less than or equal to SERVICE_TO_DATE: ' || v_vSERVICE_TO_DATE || '. ';
			   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                 v_iDA_ROW_ID,
                                 'PAYMENT',
                                 'SrvDates',
                                 'SrvDates',
                                 'DDS_PROCESS_PAYMENTS',
                                 v_vErrMsgDesc,
                                 'SERVICE_FROM_DATE, SERVICE_TO_DATE ',
                                 'DDS_PAYMENT',
                                 'CLAIM_ID',
                                 v_vCLAIM_ID,
                                 1);
               V_iErrCnt := V_iErrCnt + 1;
            END IF;
      END IF;
      --JIRA 22822 knakra ends
      --JIRA 29954 knakra(moving this code below after the currency rates have been calculated)
      /*IF v_oDontCheckDupPay = 0 OR v_oDontCheckDupPay IS NULL THEN   --Check for duplicate Payments starts
         v_nSql := 'SELECT F.TRANS_ID FROM ' || v_vDbName || 'FUNDS F, ' || v_vDbName;
         --JIRA 23831 knakra starts
         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || 'RESERVE_CURRENT RC, ' || v_vDbName;
         END IF;
         --JIRA 23831 knakra ends
         v_nSql := v_nSql || 'FUNDS_TRANS_SPLIT FTS WHERE F.CLAIM_ID = :1';
         v_nSql := v_nSql || ' AND F.CTL_NUMBER = :2 AND F.TRANS_DATE = :3';
         v_nSql := v_nSql || ' AND F.TRANS_NUMBER = :4';

         IF v_vTRANSACTION_TYPE = 'P' THEN
            v_nSql := v_nSql || ' AND F.PAYMENT_FLAG <> 0';
         ELSE
            v_nSql := v_nSql || ' AND F.PAYMENT_FLAG = 0';
         END IF;

         IF v_vCHECK_STATUS = 'V' THEN
            v_nSql := v_nSql || ' AND F.VOID_FLAG <> 0';
         ELSE
            v_nSql := v_nSql || ' AND F.VOID_FLAG = 0';
         END IF;
         --JIRA 23831 knakra starts
         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RC_ROW_ID = FTS.RC_ROW_ID';
         END IF;
         --JIRA 23831 knakra ends
         v_nSql := v_nSql || ' AND F.TRANS_ID = FTS.TRANS_ID';
         --JIRA 23831 knakra starts
         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RESERVE_TYPE_CODE = :5';
         ELSIF iVarfinKey = 0 THEN
            v_nSql := v_nSql || ' AND FTS.RESERVE_TYPE_CODE = :5';
         END IF;
         --JIRA 23831 knakra ends
         v_nSql := v_nSql || ' AND (F.AMOUNT - :6) >= 0';
         v_nSql := v_nSql || ' AND (F.AMOUNT - :7) <= 0.009';
         --JIRA 23831 knakra starts
         IF iIncRsvSubType <> 0 AND iVarFinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RESERVE_CATEGORY = :8';
         END IF;
         --JIRA 23831 knakra ends
         BEGIN
               --JIRA 23831 knarka starts
               IF iVarfinKey <> 0 AND iIncRsvSubType <> 0 THEN
                  EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_fAMOUNT, v_fAMOUNT, v_iResSubTypeCodeId;
               ELSE
                  EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_fAMOUNT, v_fAMOUNT;
               END IF;
               --JIRA 23831 knakra ends
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_iTransid := 0;
            WHEN OTHERS THEN
                  V_iErrCnt := V_iErrCnt + 1;
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'DupPayErr',
                                        'DupPayErr',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
         END;
         IF v_iTransid IS NOT NULL AND v_iTransid <> 0 THEN
          v_vErrMsgDesc := 'Duplicate Payment exists in the rmA Database.';
          V_iErrCnt := V_iErrCnt + 1;
          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                v_iDA_ROW_ID,
                                'PAYMENT',
                                'DupPay',
                                'DupPay',
                                'DDS_PROCESS_PAYMENTS',
                                v_vErrMsgDesc,
                                'CLAIM_ID,CHECK_NO,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE',
                                'DDS_PAYMENT',
                                'CLAIM_ID',
                                v_vCLAIM_ID,
                                1);
       END IF;
      END IF;                   --Check for Duplicate Payments ends*/
      --JIRA 29954 knakra ends

      /*Limitation:Syntax Not Recognized:SET @iErrCnt = = @iErrCnt + 1 ; */
      v_nSql := 'SELECT INCLUDE_PREFIX, INCLUDE_SUFFIX FROM ' || v_vDbName || 'CHECK_OPTIONS';
      BEGIN
            EXECUTE IMMEDIATE  v_nSql INTO v_iIncPrefix, v_iIncSuffix;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             v_iIncPrefix := 0;
             v_iIncSuffix := 0;
         WHEN OTHERS THEN
               v_vErrMsgDesc := SQLERRM;
               V_iErrCnt := V_iErrCnt + 1;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     'PrefixSuffix',
                                     'PrefixSuffix',
                                     'DDS_PROCESS_PAYMENT',
                                     v_vErrMsgDesc,
                                     'CLAIM_ID',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     0);
      END;

        v_vPayToTheOrderOf := LTRIM(RTRIM(NVL(v_vPAYEE_FIRSTNAME, '') || ' ' || NVL(v_vPAYEE_LASTNAME, '')));
        -- Kapil Need to check the above query
        IF v_iIncPrefix <> 0 THEN
           v_vPayToTheOrderOf := LTRIM(RTRIM(NVL(v_vPREFIX, '') || ' ' || v_vPayToTheOrderOf));
           -- Kapil Need to check the above query
        END IF;

        IF v_iIncSuffix <> 0 THEN
           v_vPayToTheOrderOf := LTRIM(RTRIM(v_vPayToTheOrderOf || ' ' || NVL(v_vSUFFIX_COMMON, '')));
        END IF;


      /*Limitation:Syntax Not Recognized:SET @iErrCnt = = @iErrCnt + 1 ; */
     -- JIRA 37275 starts
     /*IF v_iResStatusCodeId IS NOT NULL AND v_iResStatusCodeId > 0 AND ((v_iCarrierFlag <> 0 AND iVarfinKey = 0) OR (iVarfinKey <> 0 AND iIncPolCvg <> 0)) THEN --Supplemental Payment flag is needed when uploading financials to Point  JIRA 23831 knakra
         v_iResSuppPaymentFlag := 0;

         v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID IN(';
         v_nSql := v_nsql || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1)';

         BEGIN
             EXECUTE IMMEDIATE  v_nSql INTO v_vResStatus USING v_iResStatusCodeid;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_vResStatus:=0;
               --V_iErrCnt := V_iErrCnt + 1;
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  V_iErrCnt := V_iErrCnt + 1;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ResSupp',
                                        'ResSupp',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
         END;

         --IF v_vResStatus IN ( 'C','R' ) THEN     ---JIRA 37275
         IF v_vResStatus IN ('C') THEN           ---JIRA 37275
            v_iResSuppPaymentFlag := -1;
         ELSE
            v_iResSuppPaymentFlag := 0;
         END IF;
      ELSE
         v_iResSuppPaymentFlag := 0;
      END IF; */ -- JIRA 37275 ends
   END IF;
--PAYMENTS SPECIFIC VALIDATIONS ENDS

--Carrier Clients Check for Policy related coverages and losses starts
BEGIN
      BEGIN
         --IF v_iCarrierFlag <> 0 THEN     JIRA 23831 knakra
         IF (v_iCarrierFlag <> 0 AND iVarfinKey = 0) OR (iVarfinKey <> 0 AND iIncPolCvg <> 0) THEN       --JIRA 23831 knakra
         BEGIN
            IF v_vMODULE_NO IS NULL THEN
              v_vMODULE_NO := '00';
            END IF;
            --JIRA 24633 knakra starts
            IF v_vRECORD_TYPE = 'H' THEN
               v_vPOLICY_NAME := v_vPOLICY_NUMBER || ' ' || v_vMASTER_COMPANY || ' ' || v_vREGION;
            END IF;
            --JIRA 24633 knakra ends
            v_nSql2 := 'SELECT POLICY_ID, EXTERNAL_POLICY_KEY ';
            v_nSql := 'FROM ' || v_vDbName || 'POLICY WHERE POLICY_NAME = :1';
            --JIRA 24633 knakra starts
            IF v_vRECORD_TYPE <> 'H' THEN
               v_nSql := v_nSql || ' AND MODULE = :2 AND POLICY_NUMBER = :3';
               v_nSql := v_nSql || ' AND POLICY_SYMBOL = :4 AND MASTER_COMPANY = :5';
               v_nSql := v_nSql || ' AND LOCATION_COMPANY = :6';
            END IF;
            --JIRA 24633 knakra ends
            v_nSql2 := v_nSql2 || v_nSql;

            v_nSql2 := v_nSql2 || ' AND ROWNUM = 1'; --JIRA 23738 knakra

            v_vLocation := 'PolicyId';
            --Check if Policy given is valid or not
           BEGIN
            --JIRA 24633 knakra starts
            IF v_vRECORD_TYPE = 'H' THEN
               EXECUTE IMMEDIATE v_nSql2 INTO v_iPolicyId,v_vPolKey USING v_vPOLICY_NAME;
            ELSE
               EXECUTE IMMEDIATE v_nSql2 INTO v_iPolicyId,v_vPolKey USING  v_vPOLICY_NAME,v_vMODULE_NO, v_vPOLICY_NUMBER,v_vPOLICY_SYMBOL,v_vMASTER_COMPANY, v_vLOCATION_COMPANY;
            END IF;
            --JIRA 24633 knakra ends
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
              v_iPolicyId := 0;
              v_vPolKey := NULL;
            END;

            IF v_iPolicyId IS NOT NULL AND v_iPolicyId <> 0 THEN
            BEGIN
               v_nSql2 := 'SELECT POLICY_ID FROM ' || v_vDbName || 'CLAIM_X_POLICY WHERE POLICY_ID IN(';
               v_nSql2 := v_nSql2 || 'SELECT POLICY_ID ' || v_nSql || ') AND CLAIM_ID = :7';
               v_vLocation := 'PolClaim';
               --Check if Policy is attached to the given claim or not
               BEGIN
                --JIRA 24633 knakra starts
                IF v_vRECORD_TYPE = 'H' THEN
                   EXECUTE IMMEDIATE v_nSql2 INTO v_iPolicyId USING v_vPOLICY_NAME, v_iClaimId;
                ELSE
                   EXECUTE IMMEDIATE v_nSql2 INTO v_iPolicyId USING  v_vPOLICY_NAME,v_vMODULE_NO, v_vPOLICY_NUMBER,v_vPOLICY_SYMBOL,v_vMASTER_COMPANY, v_vLOCATION_COMPANY,v_iClaimId;
                END IF;
                --JIRA 24633 knakra ends
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                  v_iPolicyId := 0;
                END;

               IF v_iPolicyId <> 0 AND v_iPolicyId IS NOT NULL THEN
               BEGIN
                  --JIRA 29954 knakra starts
                  v_vLocation := 'PolicyCurrency';
                  IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                     v_nSql := 'SELECT CURRENCY_CODE FROM ' || v_vDbName || 'POLICY WHERE POLICY_ID = :1';
                     EXECUTE IMMEDIATE v_nSql INTO v_iPolCurCodeId USING v_iPolicyId;
                     IF v_iPolCurCodeId IS NULL OR v_iPolCurCodeId = 0 THEN
                        v_iPolCurCodeId := v_iBaseCurCodeId;
                     END IF;
                  ELSE
                     v_iPolCurCodeId := v_iBaseCurCodeId;
                  END IF;
                  --JIRA 29954 knakra ends
                  v_nSql := 'SELECT POLICY_SYSTEM_ID FROM ' || v_vDbName || 'POLICY WHERE POLICY_ID = :1';
                  v_vLocation := 'PolSysId';

                   BEGIN
                    EXECUTE IMMEDIATE v_nSql INTO v_iPolSysId USING v_iPolicyId;
                   EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                      v_iPolSysId := 0;
                    END;

                  
				 --akumar523 RMA-63116 STARTS 
				
				--v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = '; 
					--v_nSql := v_nSql || '(SELECT POLICY_LOB_CODE FROM ' || v_vDbName || 'POLICY WHERE POLICY_ID = :1)'; 
  
					v_nSql := 'SELECT CR.SHORT_CODE FROM ' || v_vDbName || 'CODES CR INNER JOIN ' || v_vDbName || 'CODES C ON'; 
					v_nSql := v_nSql || 'C.RELATED_CODE_ID = CR.CODE_ID INNER JOIN ' || v_vDbName || 'POLICY P ON'; 
					v_nSql := v_nSql || ' P.POLICY_LOB_CODE = C.CODE_ID WHERE P.POLICY_ID = :1';  
			--akumar523 RMA-63116 ENDS

				  
                  v_vLocation := 'PolLob';

                  BEGIN
                    EXECUTE IMMEDIATE v_nSql INTO v_vPolicyLob USING v_iPolicyId;
                   EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                      v_vPolicyLob := null;
                    END;
                    --Check for Policy Lob, as for WC claim with Policy LOB as WCV, both Loss Code and Disability Category are required but for Non-WC Claims or WC with Policy LOB not WCV, only Loss Code is required
                  IF v_vPolicyLob IS NOT NULL THEN
                  BEGIN
                     IF (iIncLossType <> 0 AND iVarfinKey <> 0) OR iVarfinKey = 0 THEN   --JIRA 23831 knakra
					
                      -- IF ((v_vRECORD_TYPE = 'W' AND v_fVersionNum < 17.3) OR (v_fVersionNum >= 17.3 AND v_vRECORD_TYPE IN('W','D'))) AND v_vPolicyLob = 'WCV' THEN  ---akumar523 RMA 63116
					   IF ((v_vRECORD_TYPE = 'W' AND v_fVersionNum < 17.3) OR (v_fVersionNum >= 17.3 AND v_vRECORD_TYPE IN('W','D'))) AND v_vPolicyLob = 'WL' THEN  ---akumar523 RMA 63116
						IF v_iDisCatCodeId IS NULL OR v_iDisCatCodeId = 0 THEN
                             v_vErrMsgDesc := 'DISABILITY CATEGORY: ' || NVL(v_vDISABILITY_CATEGORY, '') || ' is either empty or have invalid short code.';
							 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                   v_iDA_ROW_ID,
                                                   'PAYMENT',
                                                   'DisCat',
                                                   'DisCat',
                                                   'DDS_PROCESS_PAYMENTS',
                                                   v_vErrMsgDesc,
                                                   'DISABILITY_CATEGORY',
                                                   'DDS_PAYMENT',
                                                   'CLAIM_ID',
                                                   v_vCLAIM_ID,
                                                   1);
                             v_iErrCnt := v_iErrCnt + 1;
                             v_iPolErr := 1;
                          END IF;

                          DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                               v_vLOSS_CODE,
                                               'DISABILITY_TYPE',
                                               v_oAllowNewCodes,
                                               v_vDbName,
                                               v_iLob,
                                               v_iDA_ROW_ID,
                                               'PAYMENT',
                                               'CodeValidate',
                                               'DDS_PROCESS_PAYMENTS',
                                               'CLAIM_ID',
                                               v_vColName,
                                               'DDS_PAYMENT',
                                               v_vCLAIM_ID,
                                               v_iLossCodeId);

                          IF v_iLossCodeId IS NULL OR v_iLossCodeId = 0 THEN
                             v_vErrMsgDesc := 'LOSS CODE/DISABILITY TYPE CODE: ' || NVL(v_vLOSS_CODE, '') || 'is either empty or have invalid short code. '; ----akumar523 63116
							 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                   v_iDA_ROW_ID,
                                                   'PAYMENT',
                                                   'LossCode',
                                                   'LossCode',
                                                   'DDS_PROCESS_PAYMENTS',
                                                   v_vErrMsgDesc,
                                                   'LOSS_CODE',
                                                   'DDS_PAYMENT',
                                                   'CLAIM_ID',
                                                   v_vCLAIM_ID,
                                                   1);
                             v_iErrCnt := v_iErrCnt + 1;
                             v_iPolErr := 1;
                          END IF;
                       ELSE

                          DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                               v_vLOSS_CODE,
                                               'LOSS_CODES',
                                               v_oAllowNewCodes,
                                               v_vDbName,
                                               v_iLob,
                                               v_iDA_ROW_ID,
                                               'PAYMENT',
                                               'CodeValidate',
                                               'DDS_PROCESS_PAYMENTS',
                                               'CLAIM_ID',
                                               v_vColName,
                                               'DDS_PAYMENT',
                                               v_vCLAIM_ID,
                                               v_iLossCodeId);

                          IF v_vRECORD_TYPE IN ( 'G','V','D','W','H' ) THEN      --JIRA 24633 knakra
                             IF v_iLossCodeId IS NULL OR v_iLossCodeId = 0 THEN
                                v_vErrMsgDesc := 'LOSS CODE: ' || NVL(v_vLOSS_CODE, '') || 'is either empty or have invalid short code. ';
								v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                      v_iDA_ROW_ID,
                                                      'PAYMENT',
                                                      'LCode',
                                                      'LCode',
                                                      'DDS_PROCESS_PAYMENTS',
                                                      v_vErrMsgDesc,
                                                      'LOSS_CODE',
                                                      'DDS_PAYMENT',
                                                      'CLAIM_ID',
                                                      v_vCLAIM_ID,
                                                      1);
                                v_iErrCnt := v_iErrCnt + 1;
                                v_iPolErr := 1;
                             END IF;
                          END IF;
                       END IF;
                     END IF;  --JIRA 23831 knakra
                     --Fetch Unit attached with policy and claim starts

                     v_vLocation := 'UnitIdFetch';

                     IF v_vUNIT_TYPE = 'S' THEN
                        v_nSql := 'SELECT @pUnitId = CXSL.SITE_ID FROM ' || v_vDbName || 'CLAIM_X_SITELOSS CXSL, ';
                        v_nSql := v_nSql || v_vDbName || 'POINT_UNIT_DATA PUD, ' || v_vDbName || 'POLICY_X_UNIT PXU, ';
                        v_nSql := v_nSql || v_vDbName || 'SITE_UNIT SU WHERE CLAIM_ID = :1';
                        v_nSql := v_nSql || ' AND CXSL.SITE_ID = PUD.UNIT_ID AND PUD.UNIT_TYPE = ''S'' AND ';
                        v_nSql := v_nSql || 'PXU.UNIT_ID = CXSL.SITE_ID AND PXU.POLICY_ID = :2';
                        v_nSql := v_nSql || ' AND CXSL.CLAIM_ID = :3 AND CXSL.SITE_ID = SU.SITE_ID ';
                        v_nSql := v_nSql || ' AND CXSL.SITE_ID IN(SELECT UNIT_ID FROM ' || v_vDbName || 'POINT_UNIT_DATA WHERE UNIT_NUMBER = :4';
                        v_nSql := v_nSql || ' AND STAT_UNIT_NUMBER = :5 AND UNIT_ID = CXSL.SITE_ID AND UNIT_TYPE = ''S'')';

                        BEGIN
                               EXECUTE  IMMEDIATE  v_nSql INTO v_iUnitId USING v_iClaimId, v_iPolicyId, v_iClaimId, v_vUNIT_NUMBER, v_vSTAT_UNIT_NUMBER;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                 v_iUnitId:=0;
                         END;

                     ELSE
                        IF v_vUNIT_TYPE = 'P' THEN
                           v_nSql := 'SELECT CXPL.PROPERTY_ID FROM ' || v_vDbName || 'CLAIM_X_PROPERTYLOSS CXPL, ';
                           v_nSql := v_nSql || v_vDbName || 'POINT_UNIT_DATA PUD, ' || v_vDbName || 'POLICY_X_UNIT PXU, ' || v_vDbName || 'PROPERTY_UNIT PU';
                           v_nSql := v_nSql || ' WHERE CLAIM_ID = :1 AND CXPL.PROPERTY_ID = PUD.UNIT_ID';
                           v_nSql := v_nSql || ' AND PUD.UNIT_TYPE = ''P'' AND PXU.UNIT_ID = CXPL.PROPERTY_ID';
                           v_nSql := v_nSql || ' AND PXU.POLICY_ID = :2 ';
                           v_nSql := v_nSql || ' AND CXPL.CLAIM_ID = :3';
                           v_nSql := v_nSql || ' AND CXPL.PROPERTY_ID = PU.PROPERTY_ID AND CXPL.PROPERTY_ID IN(';
                           v_nSql := v_nSql || 'SELECT UNIT_ID FROM ' || v_vDbName || 'POINT_UNIT_DATA WHERE UNIT_NUMBER = :4';
                           v_nSql := v_nSql || ' AND STAT_UNIT_NUMBER = :5';
                           v_nSql := v_nSql || ' AND UNIT_ID = CXPL.PROPERTY_ID AND UNIT_TYPE = ''P'')';

                           BEGIN
                               EXECUTE  IMMEDIATE  v_nSql INTO v_iUnitId USING v_iClaimId, v_iPolicyId, v_iClaimId, v_vUNIT_NUMBER, v_vSTAT_UNIT_NUMBER;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                 v_iUnitId:=0;
                         END;

                        ELSE
                           IF v_vUNIT_TYPE = 'V' THEN


                              v_nSql := 'SELECT UXC.UNIT_ID FROM ' || v_vDbName || 'UNIT_X_CLAIM UXC, ';
                              v_nSql := v_nSql || v_vDbName || 'POINT_UNIT_DATA PUD, ' || v_vDbName || 'POLICY_X_UNIT PXU, ' || v_vDbName || 'VEHICLE V';
                              v_nSql := v_nSql || ' WHERE CLAIM_ID = :1 AND UXC.UNIT_ID = PUD.UNIT_ID';
                              v_nSql := v_nSql || ' AND PUD.UNIT_TYPE = ''V'' AND PXU.UNIT_ID = UXC.UNIT_ID';
                              v_nSql := v_nSql || ' AND PXU.POLICY_ID = :2';
                              v_nSql := v_nSql || ' AND UXC.CLAIM_ID = :3';
                              v_nSql := v_nSql || ' AND UXC.UNIT_ID = V.UNIT_ID AND UXC.UNIT_ID IN(';
                              v_nSql := v_nSql || 'SELECT UNIT_ID FROM ' || v_vDbName || 'POINT_UNIT_DATA WHERE UNIT_NUMBER = :4';
                              v_nSql := v_nSql || ' AND STAT_UNIT_NUMBER = :5';
                              v_nSql := v_nSql || ' AND UNIT_ID = UXC.UNIT_ID AND UNIT_TYPE = ''V'')';

                             BEGIN
                               EXECUTE  IMMEDIATE  v_nSql INTO v_iUnitId USING v_iClaimId, v_iPolicyId, v_iClaimId, v_vUNIT_NUMBER, v_vSTAT_UNIT_NUMBER;
                             EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                 v_iUnitId:=0;
                             END;

                           ELSE
                              IF v_vUNIT_TYPE = 'SU' THEN
                                 v_nSql := 'SELECT CXOU.OTHER_UNIT_ID FROM ' || v_vDbName || 'CLAIM_X_OTHERUNIT CXOU, ';
                                 v_nSql := v_nSql || v_vDbName || 'POINT_UNIT_DATA PUD, ' || v_vDbName || 'POLICY_X_UNIT PXU, ' || v_vDbName || 'OTHER_UNIT OU, ' || v_vDbName || 'ENTITY E';
                                 v_nSql := v_nSql || ' WHERE CXOU.CLAIM_ID = :1';
                                 v_nSql := v_nSql || ' AND PXU.UNIT_ID = PUD.UNIT_ID';
                                 v_nSql := v_nSql || ' AND PXU.UNIT_ID = CXOU.OTHER_UNIT_ID';
                                 v_nSql := v_nSql || ' AND PXU.UNIT_ID = OU.OTHER_UNIT_ID';
                                 v_nSql := v_nSql || ' AND PUD.UNIT_TYPE = ''SU''';
                                 v_nSql := v_nSql || ' AND OU.ENTITY_ID = E.ENTITY_ID';
                                 v_nSql := v_nSql || ' AND PXU.POLICY_ID = :2';
                                 v_nSql := v_nSql || ' AND PUD.UNIT_NUMBER = :3';
                                 v_nSql := v_nSql || ' AND PUD.STAT_UNIT_NUMBER = :4';
                                 v_nSql := v_nSql || ' AND PXU.UNIT_TYPE = PUD.UNIT_TYPE';

                                 BEGIN
                                     EXECUTE  IMMEDIATE  v_nSql INTO v_iUnitId USING v_iClaimId, v_iPolicyId, v_vUNIT_NUMBER, v_vSTAT_UNIT_NUMBER;
                                 EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                     v_iUnitId:=0;
                                 END;
                              ELSE
                                 IF v_vUNIT_TYPE = 'I' THEN
                                   v_nSql2 := 'SELECT ENTITY_ID FROM ' || v_vDbName || 'ENTITY WHERE';
                                   v_nSql2 := v_nSql2 || ' LAST_NAME = ''' || v_vUNIT_LAST_NAME || '''';
                                   IF v_vUNIT_FIRST_NAME IS NOT NULL THEN
                                      v_nSql2 := v_nSql2 || ' AND FIRST_NAME = ''' || v_vUNIT_FIRST_NAME || '''';
                                   END IF;
                                   IF v_vUNIT_TAX_ID IS NOT NULL THEN
                                      v_nSql2 := v_nSql2 || ' AND REPLACE(TAX_ID,''-'','''') = ''' || REPLACE(v_vUNIT_TAX_ID,'-','') || '''';
                                   END IF;
                                   IF v_vUNIT_DOB IS NOT NULL THEN
                                      v_nSql2 := v_nSql2 || ' AND BIRTH_DATE = ''' || v_vUNIT_DOB || '''';
                                   END IF;
                                   v_nSql := v_nSql2 || ' AND ROWNUM = 1';

                                   BEGIN
                                       EXECUTE IMMEDIATE v_nSql INTO iUnitEntId;
                                   EXCEPTION
                                       WHEN NO_DATA_FOUND THEN
                                         iUnitEntId := 0;
                                   END;

                                   IF iUnitEntId IS NOT NULL AND iUnitEntId > 0 THEN
                                      v_nSql := 'SELECT CLAIM_X_INSUREDUNIT.INSURED_UNIT_ID FROM ' || v_vDbName || 'CLAIM_X_INSUREDUNIT, ';
                                      v_nSql := v_nSql || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'INSURED_UNIT, ' || v_vDbName || 'ENTITY';
                                      v_nSql := v_nSql || ' WHERE CLAIM_X_INSUREDUNIT.CLAIM_ID = :1';
                                      v_nSql := v_nSql || ' AND POLICY_X_UNIT.UNIT_ID = CLAIM_X_INSUREDUNIT.INSURED_UNIT_ID';
                                      v_nSql := v_nSql || ' AND POLICY_X_UNIT.UNIT_ID = INSURED_UNIT.INSURED_UNIT_ID';
                                      v_nSql := v_nSql || ' AND POLICY_X_UNIT.UNIT_TYPE = ''I''';
                                      v_nSql := v_nSql || ' AND INSURED_UNIT.ENTITY_ID = ENTITY.ENTITY_ID';
                                      v_nSql := v_nSql || ' AND INSURED_UNIT.ENTITY_ID IN(' || v_nSql2 || ')';
                                      v_nSql := v_nSql || ' AND POLICY_X_UNIT.POLICY_ID = :3';
                                      v_nSql := v_nSql || ' AND ROWNUM = 1';

                                      BEGIN
                                        EXECUTE IMMEDIATE v_nSql INTO v_iUnitId USING v_iClaimId, v_iPolicyId;
                                      EXCEPTION
                                        WHEN NO_DATA_FOUND THEN
                                          v_iUnitId := 0;
                                      END;
                                   ELSE
                                      v_vErrMsgDesc := 'No Unit Entity found with Last Name: ' || v_vUNIT_LAST_NAME;
                                      v_vErrColumns := 'UNIT_LAST_NAME';
                                      IF v_vUNIT_FIRST_NAME IS NOT NULL THEN
                                        v_vErrMsgDesc := v_vErrMsgDesc || ', First Name: ' || v_vUNIT_FIRST_NAME;
                                        v_vErrColumns := v_vErrColumns || ',UNIT_FIRST_NAME';
                                      END IF;
                                      IF v_vUNIT_TAX_ID IS NOT NULL THEN
                                        v_vErrMsgDesc := v_vErrMsgDesc || ', Tax Id: ' || v_vUNIT_TAX_ID;
                                        v_vErrColumns := v_vErrColumns || ',UNIT_TAX_ID';
                                      END IF;
                                      IF v_vUNIT_DOB IS NOT NULL THEN
                                        v_vErrMsgDesc := v_vErrMsgDesc || ', DOB: ' || v_vUNIT_DOB;
                                        v_vErrColumns := v_vErrColumns || ',UNIT_DOB';
                                      END IF;
									  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';


                                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                            v_iDA_ROW_ID,
                                                            'PAYMENT',
                                                            'UnitEntId',
                                                            'UnitEntId',
                                                            'DDS_PROCESS_PAYMENTS',
                                                            v_vErrMsgDesc,
                                                            v_vErrColumns,
                                                            'DDS_PAYMENT',
                                                            'CLAIM_ID',
                                                            v_vCLAIM_ID,
                                                            1);

                                      v_iErrCnt := v_iErrCnt + 1;
                                   END IF;

                                 ELSE
                                   IF v_vUNIT_TYPE NOT IN ( 'S','P','V','SU','I' ) THEN            --JIRA 24633 knakra
                                      v_iUnitId := 0;
                                      v_vErrMsgDesc := 'Invalid Unit Type: ' || NVL(v_vUNIT_TYPE, '');
									  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                            v_iDA_ROW_ID,
                                                            'PAYMENT',
                                                            'InvUnitId',
                                                            'InvUnitId',
                                                            'DDS_PROCESS_PAYMENTS',
                                                            v_vErrMsgDesc,
                                                            'UNIT_TYPE',
                                                            'DDS_PAYMENT',
                                                            'CLAIM_ID',
                                                            v_vCLAIM_ID,
                                                            1);

                                      v_iErrCnt := v_iErrCnt + 1;
                                   END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                     --Fecth Unit Id attached with Policy and Claim ends

                     /*IF v_vUNIT_TYPE IN ( 'S','P','V','SU' ) THEN
                        v_vLocation := 'UnitId';
                        SP_EXECUTESQL(v_nSql,                                      N' @pUnitId int OUTPUT, @pClaimId INT, @pPolicyId INT, @pUnitNumber VARCHAR(10), @pStatUnitNumber VARCHAR(10)',
                                      v_pClaimId => v_iClaimId,
                                      v_pPolicyId => v_iPolicyId,
                                      v_pUnitNumber => v_vUNIT_NUMBER,
                                      v_pStatUnitNumber => v_vSTAT_UNIT_NUMBER,
                                      v_pUnitId => v_iUnitId);
                     END IF;*/

                     IF v_iUnitId <> 0 AND v_iUnitId IS NOT NULL THEN
                     BEGIN
                        v_nSql := 'SELECT POLICY_UNIT_ROW_ID FROM ' || v_vDbName || 'POLICY_X_UNIT';
                        v_nSql := v_nSql || ' WHERE POLICY_ID = :1';
                        v_nSql := v_nSql || ' AND UNIT_ID = :2';
                        v_nSql := v_nSql || ' AND UNIT_TYPE = :3';

                        v_vLocation := 'PolUnitRowId';

                        BEGIN
                           EXECUTE IMMEDIATE v_nSql INTO v_iPolUnitRowId USING v_iPolicyId, v_iUnitId, v_vUNIT_TYPE;
                        EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                               v_iPolUnitRowId:=0;
                         END;

                        IF v_iPolUnitRowId IS NOT NULL AND v_iPolUnitRowId <> 0 THEN
                           v_vCvgTxt := '';
                           IF v_vRECORD_TYPE IN('W','D') THEN
                              v_vCvgTxt := v_vCOVERAGE_CODE || ' ' || v_vCLASS_CODE || ' ' || v_vCLASS_DESC;
                           ELSE
                              IF v_vRECORD_TYPE IN ( 'G','V' ) THEN
                                 v_vCvgTxt := v_vCOVERAGE_CODE || ' ' || v_vCVG_DESC || ' ' || v_vCLASS_CODE || ' ' || v_vCLASS_DESC;
                              ELSE         --JIRA 24633 knakra starts
                                 IF v_vRECORD_TYPE = 'H' THEN
                                   v_vCvgTxt := v_vCOVERAGE_CODE || ' - ' || v_vCLASS_CODE;
                                 END IF;     --JIRA 24633 knakra ends
                              END IF;
                           END IF;
                           --Select Coverage on which Loss to be selected for Payments or Reserves
                           v_nSql := 'SELECT POLCVG_ROW_ID, COVERAGE_KEY FROM ' || v_vDbName || 'POLICY_X_CVG_TYPE WHERE';
                           v_nSql := v_nSql || ' COVERAGE_TYPE_CODE = :1';
                           v_nSql := v_nSql || ' AND POLICY_UNIT_ROW_ID = :2';
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE <> 'H' THEN
                              v_nSql := v_nSql || ' AND CVG_SEQUENCE_NO = :3';
                              v_nSql := v_nSql || ' AND TRANS_SEQ_NO = :4';
                           END IF;
                           --JIRA 24633 knakra ends
                           v_nSql := v_nSql || ' AND COVERAGE_TEXT = :5';
                           v_vLocation := 'PolCvgRowId';

                        BEGIN
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE = 'H' THEN
                              EXECUTE IMMEDIATE v_nSql INTO v_iPolCvgRowId,v_vCvgKey USING v_iCvgCodeId, v_iPolUnitRowId,v_vCvgTxt;
                           ELSE
                              EXECUTE IMMEDIATE v_nSql INTO v_iPolCvgRowId,v_vCvgKey USING v_iCvgCodeId, v_iPolUnitRowId, v_vCVG_SEQUENCE_NO,v_vTRANS_SEQ_NO,v_vCvgTxt;
                           END IF;
                           --JIRA 24633 knakra ends
                        EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                               v_iPolCvgRowId:=0;
                               v_vCvgKey := NULL;
                         END;
                         --Select Loss for Payments or Reserves
                           IF v_iPolCvgRowId IS NOT NULL AND v_iPolCvgRowId <> 0 THEN
                              v_nSql := 'SELECT CVG_LOSS_ROW_ID FROM ' || v_vDbName || 'COVERAGE_X_LOSS WHERE';
                              --JIRA 23831 knakra starts
                              --v_nSql := v_nSql || ' LOSS_CODE = :1';
                              --v_nSql := v_nSql || ' AND POLCVG_ROW_ID = :2';
                              v_nSql := v_nSql || ' POLCVG_ROW_ID = :1';
                              IF (iIncLossType <> 0 AND iVarfinKey <> 0) OR iVarfinKey = 0 THEN
                                 v_nSql := v_nSql || ' AND LOSS_CODE = :2';
                              END IF;
                              --IF v_vRECORD_TYPE = 'W' THEN         JIRA 23831 knakra
                              IF ((v_vRECORD_TYPE = 'W' AND v_fVersionNum < 17.3) OR (v_vRECORD_TYPE IN('W','D') AND v_fVersionNum >= 17.3)) AND (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0)) THEN
                                 v_nSql := v_nSql || ' AND DISABILITY_CAT = :3';
                              END IF;

                              BEGIN
                                IF ((v_vRECORD_TYPE = 'W' AND v_fVersionNum < 17.3) OR (v_vRECORD_TYPE IN('W','D') AND v_fVersionNum >= 17.3)) AND (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0)) THEN
                                   EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING v_iPolCvgRowId, v_iLossCodeId, v_iDisCatCodeId;
                                ELSIF ((v_fVersionNum < 17.3 AND v_vRECORD_TYPE <> 'W') OR (v_fVersionNum >= 17.3 AND v_vRECORD_TYPE NOT IN('W','D'))) AND (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0)) THEN
                                   EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING v_iPolCvgRowId, v_iLossCodeId;
                                ELSIF ((v_fVersionNum < 17.3 AND v_vRECORD_TYPE <> 'W') OR (v_fVersionNum >= 17.3 AND v_vRECORD_TYPE NOT IN('W','D'))) AND iVarfinKey <> 0 AND iIncLossType = 0 THEN
                                   EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING v_iPolCvgRowId;
                                END IF;
                              EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 v_iCvgLossRowId := 0;
                              END;
                              /*
                              IF v_vRECORD_TYPE = 'W' THEN
                                BEGIN
                                   EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING v_iLossCodeId, v_iPolCvgRowId, v_iDisCatCodeId;
                                EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                       v_iCvgLossRowId:=0;
                                 END;
                              ELSE
                                BEGIN
                                   EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING v_iLossCodeId, v_iPolCvgRowId;
                                EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                       v_iCvgLossRowId:=0;
                                 END;
                              END IF;
                              */
                              --JIRA 23831 knakra ends
                              v_vLocation := 'CvgLossRowId';

                              IF v_iCvgLossRowId IS NULL OR v_iCvgLossRowId = 0 THEN
                                 IF v_vTRANSACTION_TYPE = 'R' THEN          --For Reserves, Loss Code Mapping is done at run time only
                                    --v_nSql := 'SELECT LOSS_CODE FROM ' || v_vDbName || 'CVG_LOSS_LOB_MAPPING WHERE';   JIRA 23831 knakra
                                    v_nSql := 'SELECT ROW_ID FROM ' || v_vDbName || 'CVG_LOSS_LOB_MAPPING WHERE';     --JIRA 23831 knakra
                                    v_nSql := v_nSql || ' POLICY_LOB IN(SELECT POLICY_LOB_CODE FROM ' || v_vDbName || 'POLICY WHERE POLICY_ID = :1)';
                                    IF iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0) THEN
                                       v_nSql := v_nSql || ' AND LOSS_CODE = :2';
                                    END IF;
                                    v_nSql := v_nSql || ' AND POLICY_SYSTEM_ID IN(SELECT POLICY_SYSTEM_ID FROM ' || v_vDbName || 'POLICY WHERE POLICY_ID = :3';
                                    v_nSql := v_nSql || ' AND CVG_TYPE_CODE = :4)';

                                    v_vLocation := 'LossCodeMap';


                                    BEGIN
                                       --JIRA 23831 knakra starts
                                       IF iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncLossType <> 0) THEN
                                          EXECUTE IMMEDIATE v_nSql INTO v_iLossCodeMapping USING v_iPolicyId, v_iLossCodeId, v_iPolicyId, v_iCvgCodeId;
                                       ELSIF iVarfinKey <> 0 AND iIncLossType = 0 THEN
                                          EXECUTE IMMEDIATE v_nSql INTO v_iLossCodeMapping USING v_iPolicyId, v_iPolicyId, v_iCvgCodeId;
                                       END IF;
                                       --JIRA 23831 knakra ends
                                    EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                           v_iLossCodeMapping:=0;
                                     END;

                                    IF v_iLossCodeMapping IS NOT NULL AND v_iLossCodeMapping <> 0 THEN
                                       v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE';
                                       v_nSql := v_nSql || ' SYSTEM_TABLE_NAME = :1';

                                       v_vLocation := 'CvgLossUid';

                                     BEGIN
                                       EXECUTE IMMEDIATE v_nSql INTO v_iCvgLossRowId USING 'COVERAGE_X_LOSS';
                                    EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                           v_iCvgLossRowId:=0;
                                     END;


                                       v_nSql := 'INSERT INTO ' || v_vDbName || 'COVERAGE_X_LOSS(CVG_LOSS_ROW_ID, POLCVG_ROW_ID, LOSS_CODE, DISABILITY_CAT) VALUES(';
                                       v_nSql := v_nSql || ':1, :2, :3, :4)';
                                       --JIRA 23831 knakra starts
                                       IF iVarfinKey <> 0 AND iIncLossType = 0 THEN
                                          v_iLossCodeId := 0;
                                          v_iDisCatCodeId := 0;
                                       END IF;
                                       --JIRA 23831 knakra ends
                                       v_vLocation := 'CvgLossIns';

                                     BEGIN
                                       EXECUTE IMMEDIATE v_nSql USING v_iCvgLossRowId,v_iPolCvgRowId, v_iLossCodeId,v_iDisCatCodeId;
                                    EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                           v_iCvgLossRowId:=0;
                                     END;


                                       v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1';
                                       v_nSql := v_nSql || ' WHERE SYSTEM_TABLE_NAME = :1';
                                       v_vLocation := 'UpdCvgLossUid';

                                    BEGIN
                                       EXECUTE IMMEDIATE v_nSql USING 'COVERAGE_X_LOSS' ;
                                    EXCEPTION
                                     WHEN Others THEN
                                     v_vErrMsgDesc := SQLERRM();
                                     v_iErrCnt := v_iErrCnt + 1;
                                     v_iPolErr := 1;
                                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                   v_iDA_ROW_ID,
                                                                   'PAYMENT',
                                                                   'LCodeMap',
                                                                   'LCodeMap',
                                                                   'DDS_PROCESS_PAYMENTS',
                                                                   v_vErrMsgDesc,
                                                                   'LOSS_CODE;COVERAGE_CODE;POLICY_NAME',
                                                                   'DDS_PAYMENT',
                                                                   'CLAIM_ID',
                                                                   v_vCLAIM_ID,
                                                                   1);
                                     END;
                                    ELSE                           --For Payments, Loss code mapping must be existing
                                       v_vErrMsgDesc := 'Loss Code mapping is missing for LOSS CODE: ' || NVL(v_vLOSS_CODE, '');
                                       v_vErrMsgDesc := v_vErrMsgDesc||'COVERAGE_TYPE: ' || NVL ( v_vCOVERAGE_CODE , '' ) || ' | Policy System with POLICY_NAME: ' || NVL ( v_vPOLICY_NAME , '' ) ;
									   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                   v_iDA_ROW_ID,
                                                                   'PAYMENT',
                                                                   'LCodeMap',
                                                                   'LCodeMap',
                                                                   'DDS_PROCESS_PAYMENTS',
                                                                   v_vErrMsgDesc,
                                                                   'LOSS_CODE;COVERAGE_CODE;POLICY_NAME',
                                                                   'DDS_PAYMENT',
                                                                   'CLAIM_ID',
                                                                   v_vCLAIM_ID,
                                                                   1);
                                       v_iErrCnt := v_iErrCnt + 1;
                                       v_iPolErr := 1;
                                    END IF;
                                 ELSE
                                    v_vErrColumns := 'LOSS_CODE;COVERAGE_CODE';
                                    v_vErrMsgDesc := 'Loss or Disability Code is not mapped to Coverage with COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
                                    v_vErrMsgDesc := v_vErrMsgDesc || 'LOSS_CODE: ' || NVL(v_vLOSS_CODE, '');
									v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                                    IF v_vDISABILITY_CATEGORY IS NOT NULL THEN
                                       v_vErrColumns := v_vErrColumns || ',DISABILITY_CATEGORY';
                                       v_vErrMsgDesc := v_vErrMsgDesc || 'DISABILITY_CATEGORY: ' || v_vDISABILITY_CATEGORY;
									   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                    END IF;

                                    DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                          v_iDA_ROW_ID,
                                                          'PAYMENT',
                                                          'CodeCvgMap',
                                                          'CodeCvgMap',
                                                          'DDS_PROCESS_PAYMENTS',
                                                          v_vErrMsgDesc,
                                                          v_vErrColumns,
                                                          'DDS_PAYMENT',
                                                          'CLAIM_ID',
                                                          v_vCLAIM_ID,
                                                          1);

                                    v_iErrCnt := v_iErrCnt + 1;
                                    v_iPolErr := 1;
                                 END IF;
                              ELSE
                                 IF v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN                    --For Carrier Claims, reserves should be existing for making Payments
                                    --v_nSql := 'SELECT RC_ROW_ID FROM ' || v_vDbName || 'RESERVE_CURRENT';  -- JIRA 37275
                                    v_nSql := 'SELECT RC_ROW_ID , RES_STATUS_CODE FROM ' || v_vDbName || 'RESERVE_CURRENT';  --JIRA 37275
                                    v_nSql := v_nSql || ' WHERE CLAIM_ID = :1';
                                    --JIRA 23831 knakra starts
                                    IF (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncClaimant <> 0)) AND v_iClaimantEid <> 0 AND v_iClaimantEid IS NOT NULL THEN
                                       v_nSql := v_nSql || ' AND CLAIMANT_EID = ' || v_iClaimantEid;
                                    END IF;
                                    v_nSql := v_nSql || ' AND RESERVE_TYPE_CODE = :3';
                                    v_nSql := v_nSql || ' AND POLCVG_LOSS_ROW_ID = :4';
                                    --IF iVarfinKey = 0 AND v_iVehicleId IS NOT NULL AND v_iVehicleId <> 0 THEN          --ddhupar commented for JIRA 65681
                                       --v_nSql := v_nSql || ' AND UNIT_ID = ' || v_iVehicleId;                       
                                    --END IF;
                                    IF iIncRsvSubType <> 0 AND iVarfinKey <> 0 AND v_iResSubTypeCodeId IS NOT NULL AND v_iResSubTypeCodeId <> 0 THEN
                                       v_nSql := v_nSql || ' AND RESERVE_CATEGORY = ' || v_iResSubTypeCodeId;
                                    END IF;
                                    --JIRA 23831 knakra ends
                                    v_vLocation := 'FetchRcRowId';

                                    BEGIN
                                       EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId ,v_iResStatusCode USING v_iClaimId,v_iResTypeCodeId,v_iCvgLossRowId;
                                    EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                           v_iRcRowId:=0;
                                     END;
                                    IF v_iRcRowId IS NULL OR v_iRcRowId = 0 THEN
                                       v_vErrMsgDesc := 'Reserve doesnot exist in Riskmaster Database for this Payment. ';
									   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                       v_vErrColumns := 'CLAIM_ID,RESERVE_TYPE';

                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_iDA_ROW_ID,
                                                             'PAYMENT',
                                                             'ResExists',
                                                             'ResExists',
                                                             'DDS_PROCESS_PAYMENTS',
                                                             v_vErrMsgDesc,
                                                             v_vErrColumns,
                                                             'DDS_PAYMENT',
                                                             'CLAIM_ID',
                                                             v_vCLAIM_ID,
                                                             1);

                                       v_iErrCnt := v_iErrCnt + 1;
                                       v_iPolErr := 1;
                                    END IF;
                                 END IF;
                              END IF;
                           ELSE
                              v_vErrColumns := 'COVERAGE_CODE,TRANS_SEQ_NO,CVG_SEQUENCE_NO,CLASS_CODE,CLASS_DESC';
                              --JIRA 24633 knakra starts
                              IF v_vRECORD_TYPE <> 'H' AND v_vRECORD_TYPE <> 'W' THEN
                                v_vErrMsgDesc := 'Coverage with COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '') || ' | TRANS_SEQ_NO: ' || NVL(v_vTRANS_SEQ_NO, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ' | CVG_SEQUENCE_NO: ' || NVL(v_vCVG_SEQUENCE_NO, '') || ' | CLASS_CODE: ' || NVL(v_vCLASS_CODE, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || '| CLASS_DESC: ' || NVL(v_vCLASS_DESC, '');
                              ELSIF v_vRECORD_TYPE = 'H' THEN
                                v_vErrMsgDesc := 'Coverage with COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ' | CLASS_CODE: ' || NVL(v_vCLASS_CODE, '');
                                v_vErrColumns := 'COVERAGE_CODE,CLASS_CODE';
                              END IF;
                              IF v_vRECORD_TYPE IN('W','D') THEN
                                 v_vErrColumns := v_vErrColumns || ',CVG_DESC';
                                 v_vErrMsgDesc := v_vErrMsgDesc || 'CVG_DESC: ' || NVL(v_vCVG_DESC, '');
                              END IF;

                              v_vErrMsgDesc := v_vErrMsgDesc || ' is not attached to Policy. ';
							  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                              DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                    v_iDA_ROW_ID,
                                                    'PAYMENT',
                                                    'CvgPol',
                                                    'CvgPol',
                                                    'DDS_PROCESS_PAYMENTS',
                                                    v_vErrMsgDesc,
                                                    v_vErrColumns,
                                                    'DDS_PAYMENT',
                                                    'CLAIM_ID',
                                                    v_vCLAIM_ID,
                                                    1);
                              v_iPolErr := 1;
                              v_iErrCnt := v_iErrCnt + 1; --JIRA 23137 knakra
                           END IF;
                        ELSE
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE <> 'H' THEN
                             v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,LOCATION_COMPANY,MASTER_COMPANY,MODULE_NO,POLICY_SYMBOL,UNIT_NUMBER,STAT_UNIT_NUMBER,UNIT_TYPE';
                           ELSE
                             v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                           END IF;
                           --JIRA 24633 knakra ends
                           v_vErrMsgDesc := v_vErrMsgDesc || 'UNIT with UNIT_NUMBER: ' || NVL(v_vUNIT_NUMBER, '') || ' | STAT_UNIT_NUMBER: ' || NVL(v_vSTAT_UNIT_NUMBER, '');
                           v_vErrMsgDesc := v_vErrMsgDesc || ' | UNIT_TYPE: ' || NVL(v_vUNIT_TYPE, '') || 'is not attached to Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '');
						   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_iDA_ROW_ID,
                                                 'PAYMENT',
                                                 'UnitPol',
                                                 'UnitPol',
                                                 'DDS_PROCESS_PAYMENTS',
                                                 v_vErrMsgDesc,
                                                 v_vErrColumns,
                                                 'DDS_PAYMENT',
                                                 'CLAIM_ID',
                                                 v_vCLAIM_ID,
                                                 1);

                           v_iErrCnt := v_iErrCnt + 1;

                           v_iPolErr := 1;
                        END IF;

                     END;
                     ELSE
                        v_vErrColumns := 'UNIT_TYPE,UNIT_NUMBER,STAT_UNIT_NUMBER';
                        v_vErrMsgDesc := 'Unit Record with UNIT_TYPE: ' || NVL(v_vUNIT_TYPE, '') || ' | UNIT_NUMBER: ' || NVL(v_vUNIT_NUMBER, '');
                        v_vErrMsgDesc := v_vErrMsgDesc || ' | STAT_UNIT_NUMBER: ' || NVL(v_vSTAT_UNIT_NUMBER, '') || ' is not attached with Claim: ' || v_vCLAIM_ID;
						v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDA_ROW_ID,
                                              'PAYMENT',
                                              'UnitClm',
                                              'UnitClm',
                                              'DDS_PROCESS_PAYMENTS',
                                              v_vErrMsgDesc,
                                              v_vErrColumns,
                                              'DDS_PAYMENT',
                                              'CLAIM_ID',
                                              v_vCLAIM_ID,
                                              1);

                        v_iErrCnt := v_iErrCnt + 1;
                        v_iPolErr := 1;
                     END IF;

                  END;
                  ELSE
                     --JIRA 24633 knakra starts
                     IF v_vRECORD_TYPE <> 'H' THEN
                       v_vErrMsgDesc := 'Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '') || ' | POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '');
                       v_vErrMsgDesc := v_vErrMsgDesc || ' | POLICY_SYMBOL: ' || NVL(v_vPOLICY_SYMBOL, '') || ' | MASTER_COMPANY: ' || NVL(v_vMASTER_COMPANY, '');
                       v_vErrMsgDesc := v_vErrMsgDesc || ' | LOCATION_COMPANY: ' || NVL(v_vLOCATION_COMPANY, '') || ' | MODULE_NO: ' || NVL(v_vMODULE_NO, '');
                     ELSE
                       v_vErrMsgDesc := 'Policy with POLICY NAME: ' || NVL(v_vPOLICY_NAME, '') || '';
                     END IF;
                     --JIRA 24633 knakra ends
                     v_vErrMsgDesc := v_vErrMsgDesc || ' have invalid Policy LOB. ';
					 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                     --JIRA 24633 knakra starts
                     IF v_vRECORD_TYPE <> 'H' THEN
                       v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                     ELSE
                       v_vErrColumns := 'POLICY_NUMBER, MASTER_COMPANY, REGION';
                     END IF;

                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                           v_iDA_ROW_ID,
                                           'PAYMENT',
                                           'InvPolLob',
                                           'InvPolLob',
                                           'DDS_PROCESS_PAYMENTS',
                                           v_vErrMsgDesc,
                                           v_vErrColumns,
                                           'DDS_PAYMENT',
                                           'CLAIM_ID',
                                           v_vCLAIM_ID,
                                           1);

                     v_iErrCnt := v_iErrCnt + 1;
                     v_iPolErr := 1;
                  END IF;

               END;
               ELSE
                  --JIRA 24633 knakra starts
                  IF v_vRECORD_TYPE <> 'H' THEN
                    v_vErrMsgDesc := 'Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '') || ' | POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '');
                    v_vErrMsgDesc := v_vErrMsgDesc || ' | POLICY_SYMBOL: ' || NVL(v_vPOLICY_SYMBOL, '') || ' | MASTER_COMPANY: ' || NVL(v_vMASTER_COMPANY, '');
                    v_vErrMsgDesc := v_vErrMsgDesc || ' | LOCATION_COMPANY: ' || NVL(v_vLOCATION_COMPANY, '') || ' | MODULE_NO: ' || NVL(v_vMODULE_NO, '');
                  ELSE
                    v_vErrMsgDesc := 'Policy with POLICY NAME: ' || NVL(v_vPOLICY_NAME, '') || '';
                  END IF;
                  --JIRA 24633 knakra ends
                  v_vErrMsgDesc := v_vErrMsgDesc || ' is not attached to Claim with Claim Number: ' || v_vCLAIM_ID;
				  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                  --JIRA 24633 knakra starts
                  IF v_vRECORD_TYPE = 'H' THEN
                    v_vErrColumns := 'CLAIM_ID,POLICY_NUMBER, MASTER_COMPANY,REGION';
                  ELSE
                    v_vErrColumns := 'CLAIM_ID,POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                  END IF;
                  --JIRA 24633 knakra ends

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'PolClm',
                                        'PolClm',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);

                  v_iErrCnt := v_iErrCnt + 1;
                  v_iPolErr := 1;
               END IF;

            END;
            ELSE
               --JIRA 24633 knakra starts
               IF v_vRECORD_TYPE = 'H' THEN
                 v_vErrMsgDesc := 'Policy with POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '') || ', MASTER COMPANY: ' || NVL(v_vMASTER_COMPANY, '');
                 v_vErrMsgDesc := v_vErrMsgDesc || ', REGION: ' || NVL(v_vREGION, '') || '';
               ELSE
                 v_vErrMsgDesc := 'Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '') || ' | POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '');
                 v_vErrMsgDesc := v_vErrMsgDesc || ' | POLICY_SYMBOL: ' || NVL(v_vPOLICY_SYMBOL, '') || ' | MASTER_COMPANY: ' || NVL(v_vMASTER_COMPANY, '');
                 v_vErrMsgDesc := v_vErrMsgDesc || ' | LOCATION_COMPANY: ' || NVL(v_vLOCATION_COMPANY, '') || ' | MODULE_NO: ' || NVL(v_vMODULE_NO, '');
               END IF;
               --JIRA 24633 knakra ends
               v_vErrMsgDesc := v_vErrMsgDesc || ' does not exist in rmA Database. ';
			   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
               v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';

               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     'PolExists',
                                     'PolExists',
                                     'DDS_PROCESS_PAYMENTS',
                                     v_vErrMsgDesc,
                                     v_vErrColumns,
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     1);

               v_iErrCnt := v_iErrCnt + 1;
               v_iPolErr := 1;
            END IF;

            --Check for Policy Limits Starts--
            /*IF v_vTRANSACTION_TYPE = 'P' AND v_iPolErr = 0 THEN
            DECLARE
               v_iLimitCount NUMBER(10,0):=0;
               --v_iCountLoop NUMBER(10,0):=1;
               v_vdbCvgKey VARCHAR2(100):=NULL;
               v_dLimitAmt NUMBER(20,2):=0.00;
               pLimitCursor SYS_REFCURSOR;
               v_iLimitCode number :=0;
            BEGIN

               v_nSql := 'SELECT  USE_LIMIT_TRACKING FROM ' || v_vDbName || 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = :1';

               v_vLocation := 'LimitFlag';

               BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO    v_iLimitFlag USING   v_iLob;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_iLimitFlag:=0;
               END;

               IF v_iLimitFlag <> 0 THEN
               BEGIN
                  v_nSql := 'SELECT COUNT(LIMIT_ROW_ID) FROM ' || v_vDbName || 'POL_COV_LIMIT';
                  v_nSql := v_nSql || ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' || v_vDbName || 'CODE_X_CODE WHERE CODE1 = :1';
                  v_nSql := v_nSql || ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' || v_vDbName || 'CODES C, ' || v_vDbName || 'GLOSSARY G WHERE';
                  v_nSql := v_nSql || ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = :2 AND G.SYSTEM_TABLE_NAME = :3))';
                  v_nSql := v_nSql || ' AND POLICY_KEY = :4 AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = :5)';

                  v_vLocation := 'LimitCount';

                BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO    v_iLimitCount USING   v_iResTypeCodeId,'RTTOLT','CODE_REL_TYPE',v_vPolKey,v_vCvgKey ;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_iLimitCount:=0;
               END;

                  IF v_iLimitCount > 0 THEN
                  BEGIN
                     IF v_vPolKey IS NOT NULL AND v_vCvgKey IS NOT NULL THEN
                     BEGIN
                        --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY, ' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE';
                        v_nSql := v_nSql || ' WHERE POLICY.EXTERNAL_POLICY_KEY= :1 AND POLICY.POLICY_ID = POLICY_X_UNIT.POLICY_ID AND';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID= POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)';

                        v_vLocation := 'AggAmtOnPol';

                        BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dAggAmtOnPol USING v_vPolKey ;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_dAggAmtOnPol:=0;
                        END;

                        --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY,' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE';
                        v_nSql := v_nSql || ' WHERE POLICY.EXTERNAL_POLICY_KEY = :1 AND POLICY.POLICY_ID=POLICY_X_UNIT.POLICY_ID AND';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID AND POLICY_X_CVG_TYPE.COVERAGE_KEY = :2)';

                        v_vLocation := 'AggAmtOnCvg';

                       BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dAggAmtOnCvg USING v_vPolKey,v_vCvgKey ;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dAggAmtOnCvg:=0;
                       END;

                       --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE WHERE';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_ID = :1 AND POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)';

                        v_vLocation := 'OccAmtOnPol';


                         BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dOccAmtOnPol USING v_iPolicyId;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dOccAmtOnPol:=0;
                       END;

                       --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT,' || v_vDbName || 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = :1';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT,' || v_vDbName || 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = :1';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND COVERAGE_X_LOSS.CVG_LOSS_ROW_ID = RESERVE_CURRENT.POLCVG_LOSS_ROW_ID';

                        v_vLocation := 'OccAmtOnCvg';

                         BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dOccAmtOnCvg USING v_iPolCvgRowId;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dOccAmtOnCvg:=0;
                       END;


                        --v_nSql := 'SET @pLimitCursor = CURSOR LOCAL STATIC FOR';
                        v_nSql := ' SELECT LIMIT_AMOUNT, LIMIT_TYPE_CODE, COVERAGE_KEY FROM ' || v_vDbName || 'POL_COV_LIMIT';
                        v_nSql := v_nSql || ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' || v_vDbName || 'CODE_X_CODE WHERE CODE1 = :1';
                        v_nSql := v_nSql || ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' || v_vDbName || 'CODES C, ' || v_vDbName || 'GLOSSARY G WHERE';
                        v_nSql := v_nSql || ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = :2 AND G.SYSTEM_TABLE_NAME = :3))';
                        v_nSql := v_nSql || ' AND POLICY_KEY = :4 AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = :5)';
                        --v_nSql := v_nSql || ' OPEN @pLimitCursor';

                        v_vLocation := 'InternalCurLimit';

                        OPEN pLimitCursor FOR v_nSql USING v_iResTypeCodeId,'RTTOLT', 'CODE_REL_TYPE',v_vPolKey,v_vCvgKey ;
                        LOOP
                        FETCH PLimitCursor INTO v_dLimitAmt,v_iLimitCode,v_vdbCvgKey;
                        EXIT WHEN PLimitCursor%NOTFOUND;
                           DECLARE v_vParentLimit VARCHAR2(50) := NULL;
                           BEGIN
                              v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID IN(';
                              v_nSql := v_nSql || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1)';

                              v_vLocation := 'ParentLimit';

                             BEGIN
                                EXECUTE IMMEDIATE v_nSql INTO v_vParentLimit USING v_iLimitCode;
                             EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                v_vParentLimit:=0;
                             END;

                              --JIRA 24633 knakra starts
                              IF v_vRECORD_TYPE = 'H' THEN
                                v_vErrMsgDesc := 'Policy Limit exceeded for Policy with Policy Name: ' || NVL(v_vPOLICY_NAME, '');
                                v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                              ELSE
                                v_vErrMsgDesc := 'Policy Limit exceeded for Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '') || ', POLICY_SYMBOL: ' || NVL(v_vPOLICY_SYMBOL, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', MASTER_COMPANY: ' || NVL(v_vMASTER_COMPANY, '') || ', LOCATION_COMPANY: ' || NVL(v_vLOCATION_COMPANY, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', MODULE_NO: ' || NVL(v_vMODULE_NO, '');
                                v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                              END IF;
                              --JIRA 24633 knakra ends
                              IF v_vParentLimit = 'AGG' THEN
                                 IF v_vdbCvgKey IS NOT NULL THEN
                                    --IF v_dLimitAmt < (v_dAggAmtOnCvg + v_fAMOUNT) THEN               JIRA 29954 knakra
                                    IF (v_dLimitAmt < (v_dAggAmtOnPol + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dAggAmtOnPol + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       v_vErrColumns := v_vErrColumns || ',COVERAGE_CODE';
                                       v_vErrMsgDesc := v_vErrMsgDesc || ', COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');

                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_iDA_ROW_ID,
                                                             'PAYMENT',
                                                             'PolLimitCvgAgg',
                                                             'PolLimitCvgAgg',
                                                             'DDS_PROCESS_PAYMENTS',
                                                             v_vErrMsgDesc,
                                                             v_vErrColumns,
                                                             'DDS_PAYMENT',
                                                             'CLAIM_ID',
                                                             v_vCLAIM_ID,
                                                             1);

                                       v_iErrCnt := v_iErrCnt + 1;
                                    END IF;
                                 ELSE
                                    IF (v_dLimitAmt < (v_dAggAmtOnPol + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dAggAmtOnPol + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_iDA_ROW_ID,
                                                             'PAYMENT',
                                                             'PolLimitAgg',
                                                             'PolLimitAgg',
                                                             'DDS_PROCESS_PAYMENTS',
                                                             v_vErrMsgDesc,
                                                             v_vErrColumns,
                                                             'DDS_PAYMENT',
                                                             'CLAIM_ID',
                                                             v_vCLAIM_ID,
                                                             1);

                                       v_iErrCnt := v_iErrCnt + 1;
                                    END IF;
                                 END IF;
                              ELSE
                                 IF v_vParentLimit = 'OCC' THEN
                                    IF v_vdbCvgKey IS NOT NULL THEN
                                       IF (v_dLimitAmt < (v_dOccAmtOnCvg + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dOccAmtOnCvg + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       --IF v_dLimitAmt < (v_dOccAmtOnCvg + v_fAMOUNT) THEN   JIRA 29954 knakra
                                          v_vErrColumns := v_vErrColumns || ',COVERAGE_CODE';
                                          v_vErrMsgDesc := v_vErrMsgDesc || ', COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');

                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_iDA_ROW_ID,
                                                                'PAYMENT',
                                                                'PolLimitCvgOcc',
                                                                'PolLimitCvgOcc',
                                                                'DDS_PROCESS_PAYMENTS',
                                                                v_vErrMsgDesc,
                                                                v_vErrColumns,
                                                                'DDS_PAYMENT',
                                                                'CLAIM_ID',
                                                                v_vCLAIM_ID,
                                                                1);

                                          v_iErrCnt := v_iErrCnt + 1;
                                       END IF;
                                    ELSE
                                       --IF v_dLimitAmt < (v_dOccAmtOnPol + v_fAMOUNT) THEN   JIRA 29954 knakra
                                       IF (v_dLimitAmt < (v_dOccAmtOnCvg + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dOccAmtOnCvg + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       -- Kapil Error msg is not there
                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_iDA_ROW_ID,
                                                                'PAYMENT',
                                                                'PolLimitOcc',
                                                                'PolLimitOcc',
                                                                'DDS_PROCESS_PAYMENTS',
                                                                v_vErrMsgDesc,
                                                                v_vErrColumns,
                                                                'DDS_PAYMENT',
                                                                'CLAIM_ID',
                                                                v_vCLAIM_ID,
                                                                1);

                                          v_iErrCnt := v_iErrCnt + 1;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END;
                        END LOOP;
                        CLOSE PLimitCursor;

                     END;
                     ELSE
                     BEGIN
                        IF v_vPolKey IS NULL THEN
                           v_vErrMsgDesc := 'POLICY KEY is null for POLICY NAME: ' || NVL(v_vPOLICY_NAME, '');
                           v_vErrMsgDesc := v_vErrMsgDesc || ', Invalid Policy in Database.';
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE = 'H' THEN
                             v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                           ELSE
                             v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                           END IF;
                           --JIRA 24633 knakra ends
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_iDA_ROW_ID,
                                                 'PAYMENT',
                                                 'PolKeyNull',
                                                 'PolKeyNull',
                                                 'DDS_PROCESS_PAYMENTS',
                                                 v_vErrMsgDesc,
                                                 v_vErrColumns,
                                                 'DDS_PAYMENT',
                                                 'CLAIM_ID',
                                                 v_vCLAIM_ID,
                                                 1);

                           v_iErrCnt := v_iErrCnt + 1;
                        END IF;

                        IF v_vCvgKey IS NULL THEN
                           v_vErrMsgDesc := 'COVERAGE_KEY is null for COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
                           v_vErrColumns := v_vErrMsgDesc || ', Invalid Coverage in Database.';
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE = 'H' THEN
                             v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                           ELSE
                             v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                           END IF;
                           --JIRA 24633 knakra ends
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_iDA_ROW_ID,
                                                 'PAYMENT',
                                                 'CvgKeynull',
                                                 'CvgKeynull',
                                                 'DDS_PROCESS_PAYMENTS',
                                                 v_vErrMsgDesc,
                                                 v_vErrColumns,
                                                 'DDS_PAYMENT',
                                                 'CLAIM_ID',
                                                 v_vCLAIM_ID,
                                                 1);

                           v_iErrCnt := v_iErrCnt + 1;
                        END IF;

                     END;
                     END IF;

                  END;
                  END IF;

               END;
               END IF;

            END;
            END IF;*/

            --Check for Policy Limits ends--
            --Distribution Type Starts
            /*IF v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN  JIRA 26252 knakra starts(making Dist Type Code common for both Carrier and Corporate Clients)
               IF v_iAccountId <> 0 AND v_iAccountId IS NOT NULL THEN
               BEGIN
                  v_nSql := 'SELECT IS_EFT_ACCOUNT FROM ' || v_vDbName || 'ACCOUNT WHERE ACCOUNT_ID = :1';

                  v_vLocation := 'IsEft';

                  BEGIN
                    EXECUTE IMMEDIATE    v_nSql INTO  v_iIsEft USING  v_iAccountId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  v_iIsEft:=0 ;
                  END;

                  IF v_vDSTRBN_TYPE_CODE IS NULL OR v_vDSTRBN_TYPE_CODE IS NULL THEN
                     v_nSql := 'SELECT DEF_DSTRBN_TYPE_CODE FROM ' || v_vDbName || 'CHECK_OPTIONS';

                     v_vLocation := 'DefDistType';

                    BEGIN
                      EXECUTE IMMEDIATE    v_nSql INTO  v_iDistTypeCodeId;
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    v_iDistTypeCodeId:=0 ;
                    END;
                  END IF;

                  v_nSql := 'SELECT  SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1 AND DELETED_FLAG = 0';

                  v_vLocation := 'DistTypeSCode';

                    BEGIN
                      EXECUTE IMMEDIATE    v_nSql INTO  v_vDistTypeSCode USING v_iDistTypeCodeId;
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    v_iDistTypeCodeId:=0 ;
                    END;

                  IF ( v_vDistTypeSCode = 'MAL' ) THEN
                  BEGIN
                     IF v_iTransNumber = 0 THEN
                        v_vErrMsgDesc := 'Check Number cannot be left empty for Distribution Type: MAL';

                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDA_ROW_ID,
                                              'PAYMENT',
                                              'VERR13',
                                              'VERR13',
                                              'DDS_PROCESS_PAYMENTS',
                                              v_vErrMsgDesc,
                                              'DSTRBN_TYPE_CODE',
                                              'DDS_PAYMENT',
                                              'CLAIM_ID',
                                              v_vCLAIM_ID,
                                              1);

                        v_iErrCnt := v_iErrCnt + 1;
                     END IF;

                     IF v_iChkStatCodeId <> v_iPrintedStatus THEN
                        v_vErrMsgDesc := 'Check Status should be ''PRINTED'' for Distribution Type: MAL.';
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDA_ROW_ID,
                                              'PAYMENT',
                                              'VERR13',
                                              'VERR13',
                                              'DDS_PROCESS_PAYMENTS',
                                              v_vErrMsgDesc,
                                              'DSTRBN_TYPE_CODE',
                                              'DDS_PAYMENT',
                                              'CLAIM_ID',
                                              v_vCLAIM_ID,
                                              1);

                        v_iErrCnt := v_iErrCnt + 1;
                     END IF;

                  END;
                  END IF;

                  IF v_iIsEft <> 0 AND v_vDistTypeSCode = 'EFT' THEN
                     v_vErrMsgDesc := 'EFT Account is required for an EFT Transaction, Please Correct the data.';
                     DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                           v_iDA_ROW_ID,
                                           'PAYMENT',
                                           'VERR13',
                                           'VERR13',
                                           'DDS_PROCESS_PAYMENTS',
                                           v_vErrMsgDesc,
                                           'DSTRBN_TYPE_CODE',
                                           'DDS_PAYMENT',
                                           'CLAIM_ID',
                                           v_vCLAIM_ID,
                                           1);
                     v_iErrCnt := v_iErrCnt + 1;
                  END IF;

                  IF v_vDistTypeSCode NOT IN ( 'EFT','MAL' ) AND v_iChkStatCodeId = v_iPrintedStatus THEN
                     v_nSql := 'SELECT ROW_ID FROM ' || v_vDbName || 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE IN(';
                    v_nSql := v_nSql || 'SELECT CODE_ID FROM ' || v_vDbName || 'CODES WHERE TABLE_ID = (SELECT TABLE_ID FROM ' || v_vDbName || 'GLOSSARY';
                     v_nSql := v_nSql || ' WHERE SYSTEM_TABLE_NAME = :1) AND SHORT_CODE NOT IN(''EFT'',''MAL''))';

                     v_vLocation := 'ChkPrintOptns';

                    BEGIN
                      EXECUTE IMMEDIATE    v_nSql INTO  v_iRowId USING 'DISTRIBUTION_TYPE';
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    v_iRowId:=0 ;
                    END;

                     IF v_iRowId IS NOT NULL OR v_iRowId > 0 THEN
                        v_vErrMsgDesc := 'Mapping is missing in Print Check Options for DSTRBN_TYPE_CODE: ' || NVL(v_vDistTypeSCode, '');
                        DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                              v_iDA_ROW_ID,
                                              'PAYMENT',
                                              'VERR13',
                                              'VERR13',
                                              'DDS_PROCESS_PAYMENTS',
                                              v_vErrMsgDesc,
                                              'DSTRBN_TYPE_CODE',
                                              'DDS_PAYMENT',
                                              'CLAIM_ID',
                                              v_vCLAIM_ID,
                                              1);

                        v_iErrCnt := v_iErrCnt + 1;
                     END IF;
                  END IF;
               END;
               ELSE
                  v_vErrMsgDesc := 'Account/Sub Acount doesnot exist in rmA';

                  IF v_iUseSubAcc = 0 THEN
                     v_vErrColumns := 'BANK_SUB_ACCNT_NUM';
                  ELSE
                     v_vErrColumns := 'BANK_ACCOUNT_NUM';
                  END IF;

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'VERR13',
                                        'VERR13',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);

                  v_iErrCnt := v_iErrCnt + 1;
               END IF;
            END IF;*/         --Distribution Type Ends JIRA 26252 knakra ends
         END;
         END IF;   --Carrier Clients Check for Policy related coverages and losses ends

         --JIRA 37275 starts
         IF v_iResStatusCode IS NOT NULL AND v_iResStatusCode > 0 AND ((v_iCarrierFlag <> 0 AND iVarfinKey = 0) OR (iVarfinKey <> 0 AND iIncPolCvg <> 0)) THEN --Supplemental Payment flag is needed when uploading financials to Point  JIRA 23831 knakra
         v_iResSuppPaymentFlag := 0;

         v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID IN(';
         v_nSql := v_nsql || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1)';

         BEGIN
             EXECUTE IMMEDIATE  v_nSql INTO v_vResStatus USING v_iResStatusCode;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_vResStatus:=0;
               --V_iErrCnt := V_iErrCnt + 1;
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  V_iErrCnt := V_iErrCnt + 1;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ResSupp',
                                        'ResSupp',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
         END;

         --IF v_vResStatus IN ( 'C','R' ) THEN     ---JIRA 37275
         IF v_vResStatus IN ('C') THEN           ---JIRA 37275
            v_iResSuppPaymentFlag := -1;
         ELSE
            v_iResSuppPaymentFlag := 0;
         END IF;
      ELSE
         v_iResSuppPaymentFlag := 0;
      END IF;
         --JIRA 37275 ends
         --JIRA 29954 knakra starts
         --JIRA 38951 knakra starts
         IF v_iPolCurCodeId IS NULL OR v_iPolCurCodeId <= 0 THEN
            v_iPolCurCodeId := v_iBaseCurCodeId;
         END IF;
         --JIRA 38951 knakra ends
         IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
            IF v_iBaseCurCodeId = v_iClmCurCodeId THEN
               v_iClmToBaseRate := 1;
            ELSE
               IF v_nCLM_TO_BASE_CURR_RATE IS NULL OR v_nCLM_TO_BASE_CURR_RATE = 0 THEN
                  BEGIN
                     EXECUTE IMMEDIATE v_nSqlMc INTO v_iClmToBaseRate USING v_iClmCurCodeId, v_iBaseCurCodeId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       v_iClmToBaseRate := 1;
                  END;
               ELSIF v_nCLM_TO_BASE_CURR_RATE IS NOT NULL AND v_nCLM_TO_BASE_CURR_RATE > 0 THEN
                  v_iClmToBaseRate := v_nCLM_TO_BASE_CURR_RATE;
               END IF;
            END IF;

            IF v_iClmCurCodeId = v_iPolCurCodeId THEN
               v_iClmToPolRate := 1;
            ELSIF v_iBaseCurCodeId = v_iPolCurCodeId THEN
               v_iClmToPolRate := v_iClmToBaseRate;
            ELSE
               IF v_nCLM_TO_POL_CURR_RATE IS NULL OR v_nCLM_TO_POL_CURR_RATE = 0 THEN
                  BEGIN
                     EXECUTE IMMEDIATE v_nSqlMc INTO v_iClmToPolRate USING v_iClmCurCodeId, v_iPolCurCodeId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_iClmToPolRate := 1;
                  END;
               ELSIF v_nCLM_TO_POL_CURR_RATE IS NOT NULL AND v_nCLM_TO_POL_CURR_RATE > 0 THEN
                  v_iClmToPolRate := v_nCLM_TO_POL_CURR_RATE;
               END IF;
            END IF;

            IF v_vTRANSACTION_TYPE IN('P','C') THEN
               IF v_iPmtCurCodeId = v_iClmCurCodeId THEN
                  v_iPmtToClmRate := 1;
               ELSE
                  IF v_nPMT_TO_CLM_CURR_RATE IS NULL OR v_nPMT_TO_CLM_CURR_RATE <= 0 THEN
                     BEGIN
                        EXECUTE IMMEDIATE v_nSqlMc INTO v_iPmtToClmRate USING v_iPmtCurCodeId, v_iClmCurCodeId;
                     EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        v_iPmtToClmRate := 1;
                     END;
                  ELSIF v_nPMT_TO_CLM_CURR_RATE IS NOT NULL AND v_nPMT_TO_CLM_CURR_RATE > 0 THEN
                     v_iPmtToClmRate := v_nPMT_TO_CLM_CURR_RATE;
                  END IF;
               END IF;

               IF v_iPmtCurCodeId = v_iBaseCurCodeId THEN
                  v_iPmtToBaseRate := 1;
               ELSE
                  IF v_nPMT_TO_BASE_CURR_RATE IS NULL OR v_nPMT_TO_BASE_CURR_RATE <= 0 THEN
                     BEGIN
                        EXECUTE IMMEDIATE v_nSqlMc INTO v_iPmtToBaseRate USING v_iPmtCurCodeId, v_iBaseCurCodeId;
                     EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        v_iPmtToBaseRate := 1;
                     END;
                  ELSIF v_nPMT_TO_BASE_CURR_RATE IS NOT NULL AND v_nPMT_TO_BASE_CURR_RATE > 0 THEN
                     v_iPmtToBaseRate := v_nPMT_TO_BASE_CURR_RATE;
                  END IF;
               END IF;

               IF iIncPolCvg IS NOT NULL AND iIncPolCvg <> 0 THEN
                  IF v_iPmtCurCodeId = v_iPolCurCodeId THEN
                     v_iPmtToPolRate := 1;
                  ELSIF v_iPolCurCodeId = v_iBaseCurCodeId THEN
                     v_iPmtToPolRate := v_iPmtToBaseRate;
                  ELSIF v_iPolCurCodeId = v_iClmCurCodeId THEN
                     v_iPmtToPolRate := v_iPmtToClmRate;
                  ELSE
                     IF v_nPMT_TO_POL_CURR_RATE IS NULL OR v_nPMT_TO_POL_CURR_RATE <= 0 THEN
                        BEGIN
                           EXECUTE IMMEDIATE v_nSqlMc INTO v_iPmtToPolRate USING v_iPmtCurCodeId, v_iPolCurCodeId;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           v_iPmtToPolRate := 1;
                        END;
                     ELSIF v_nPMT_TO_POL_CURR_RATE IS NOT NULL AND v_nPMT_TO_POL_CURR_RATE > 0 THEN
                        v_iPmtToPolRate := v_nPMT_TO_POL_CURR_RATE;
                     END IF;
                  END IF;
               ELSE
                  v_iPolCurCodeId := v_iBaseCurCodeId;
                  v_iPmtToPolRate := v_iPmtToBaseRate;
               END IF;

            END IF;

         ELSE
            v_iClmToPolRate := 1;
            v_iClmToBaseRate := 1;
            v_iPmtToBaseRate := 1;
            v_iPmtToClmRate := 1;
            v_iPmtToPolRate := 1;
            v_iClmCurCodeId := v_iBaseCurCodeId;
            v_iPmtCurCodeId := v_iBaseCurCodeId;
            v_iPolCurCodeId := v_iBaseCurCodeId;
         END IF;

         IF v_vTRANSACTION_TYPE = 'R' THEN
            v_dClmCurrAmt := v_dInpAmt;
            v_dBaseCurrAmt := v_dClmCurrAmt * v_iClmToBaseRate;
            v_dPolCurrAmt := v_dClmCurrAmt * v_iClmToPolRate;
         ELSIF v_vTRANSACTION_TYPE IN('P','C') THEN
            v_dPmtCurrAmt := v_dInpAmt;
            v_dClmCurrAmt := v_dPmtCurrAmt * v_iPmtToClmRate;
            v_dPolCurrAmt := v_dPmtCurrAmt * v_iPmtToPolRate;
            v_dBaseCurrAmt := v_dPmtCurrAmt * v_iPmtToBaseRate;
         END IF;
         --JIRA 29954 knakra ends

         --Check for Policy Limits Starts--
            IF v_vTRANSACTION_TYPE = 'P' AND v_iPolErr = 0 AND ((v_iCarrierFlag IS NOT NULL AND v_iCarrierFlag <> 0 AND iVarfinKey = 0) OR (iVarfinKey IS NOT NULL AND iVarfinKey <> 0 AND iIncPolCvg IS NOT NULL AND iIncPolCvg <> 0)) THEN
            DECLARE
               v_iLimitCount NUMBER(10,0):=0;
               --v_iCountLoop NUMBER(10,0):=1;
               v_vdbCvgKey VARCHAR2(100):=NULL;
               v_dLimitAmt NUMBER(20,2):=0.00;
               pLimitCursor SYS_REFCURSOR;
               v_iLimitCode number :=0;
            BEGIN

               v_nSql := 'SELECT  USE_LIMIT_TRACKING FROM ' || v_vDbName || 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = :1';

               v_vLocation := 'LimitFlag';

               BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO    v_iLimitFlag USING   v_iLob;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_iLimitFlag:=0;
               END;

               IF v_iLimitFlag <> 0 THEN
               BEGIN
                  v_nSql := 'SELECT COUNT(LIMIT_ROW_ID) FROM ' || v_vDbName || 'POL_COV_LIMIT';
                  v_nSql := v_nSql || ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' || v_vDbName || 'CODE_X_CODE WHERE CODE1 = :1';
                  v_nSql := v_nSql || ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' || v_vDbName || 'CODES C, ' || v_vDbName || 'GLOSSARY G WHERE';
                  v_nSql := v_nSql || ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = :2 AND G.SYSTEM_TABLE_NAME = :3))';
                  v_nSql := v_nSql || ' AND POLICY_KEY = :4 AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = :5)';

                  v_vLocation := 'LimitCount';

                BEGIN
                  EXECUTE IMMEDIATE v_nSql INTO    v_iLimitCount USING   v_iResTypeCodeId,'RTTOLT','CODE_REL_TYPE',v_vPolKey,v_vCvgKey ;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_iLimitCount:=0;
               END;

                  IF v_iLimitCount > 0 THEN
                  BEGIN
                     IF v_vPolKey IS NOT NULL AND v_vCvgKey IS NOT NULL THEN
                     BEGIN
                        --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY, ' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE';
                        v_nSql := v_nSql || ' WHERE POLICY.EXTERNAL_POLICY_KEY= :1 AND POLICY.POLICY_ID = POLICY_X_UNIT.POLICY_ID AND';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID= POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)';

                        v_vLocation := 'AggAmtOnPol';

                        BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dAggAmtOnPol USING v_vPolKey ;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_dAggAmtOnPol:=0;
                        END;

                        --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY,' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE';
                        v_nSql := v_nSql || ' WHERE POLICY.EXTERNAL_POLICY_KEY = :1 AND POLICY.POLICY_ID=POLICY_X_UNIT.POLICY_ID AND';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID AND POLICY_X_CVG_TYPE.COVERAGE_KEY = :2)';

                        v_vLocation := 'AggAmtOnCvg';

                       BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dAggAmtOnCvg USING v_vPolKey,v_vCvgKey ;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dAggAmtOnCvg:=0;
                       END;

                       --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT RC, ' || v_vDbName || 'COVERAGE_X_LOSS CXL WHERE CXL.CVG_LOSS_ROW_ID = RC.POLCVG_LOSS_ROW_ID';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND CXL.POLCVG_ROW_ID IN(SELECT POLICY_X_CVG_TYPE.POLCVG_ROW_ID FROM ' || v_vDbName || 'POLICY_X_UNIT, ' || v_vDbName || 'POLICY_X_CVG_TYPE WHERE';
                        v_nSql := v_nSql || ' POLICY_X_UNIT.POLICY_ID = :1 AND POLICY_X_UNIT.POLICY_UNIT_ROW_ID = POLICY_X_CVG_TYPE.POLICY_UNIT_ROW_ID)';

                        v_vLocation := 'OccAmtOnPol';


                         BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dOccAmtOnPol USING v_iPolicyId;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dOccAmtOnPol:=0;
                       END;

                       --JIRA 29954 knakra starts
                        IF v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0 AND v_fVersionNum >= 16.4 THEN
                           v_nSql := 'SELECT SUM(POLICY_CURR_PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT,' || v_vDbName || 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = :1';
                        ELSE
                           v_nSql := 'SELECT SUM(PAID_TOTAL) FROM ' || v_vDbName || 'RESERVE_CURRENT,' || v_vDbName || 'COVERAGE_X_LOSS WHERE COVERAGE_X_LOSS.POLCVG_ROW_ID = :1';
                        END IF;
                        --JIRA 29954 knakra ends
                        v_nSql := v_nSql || ' AND COVERAGE_X_LOSS.CVG_LOSS_ROW_ID = RESERVE_CURRENT.POLCVG_LOSS_ROW_ID';

                        v_vLocation := 'OccAmtOnCvg';

                         BEGIN
                          EXECUTE IMMEDIATE v_nSql INTO v_dOccAmtOnCvg USING v_iPolCvgRowId;
                       EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          v_dOccAmtOnCvg:=0;
                       END;


                        --v_nSql := 'SET @pLimitCursor = CURSOR LOCAL STATIC FOR';
                        v_nSql := ' SELECT LIMIT_AMOUNT, LIMIT_TYPE_CODE, COVERAGE_KEY FROM ' || v_vDbName || 'POL_COV_LIMIT';
                        v_nSql := v_nSql || ' WHERE LIMIT_TYPE_CODE IN(SELECT CODE2 FROM ' || v_vDbName || 'CODE_X_CODE WHERE CODE1 = :1';
                        v_nSql := v_nSql || ' AND REL_TYPE_CODE = (SELECT CODE_ID FROM ' || v_vDbName || 'CODES C, ' || v_vDbName || 'GLOSSARY G WHERE';
                        v_nSql := v_nSql || ' G.TABLE_ID = C.TABLE_ID AND C.SHORT_CODE = :2 AND G.SYSTEM_TABLE_NAME = :3))';
                        v_nSql := v_nSql || ' AND POLICY_KEY = :4 AND (COVERAGE_KEY IS NULL OR COVERAGE_KEY = :5)';
                        --v_nSql := v_nSql || ' OPEN @pLimitCursor';

                        v_vLocation := 'InternalCurLimit';

                        OPEN pLimitCursor FOR v_nSql USING v_iResTypeCodeId,'RTTOLT', 'CODE_REL_TYPE',v_vPolKey,v_vCvgKey ;
                        LOOP
                        FETCH PLimitCursor INTO v_dLimitAmt,v_iLimitCode,v_vdbCvgKey;
                        EXIT WHEN PLimitCursor%NOTFOUND;
                           DECLARE v_vParentLimit VARCHAR2(50) := NULL;
                           BEGIN
                              v_nSql := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID IN(';
                              v_nSql := v_nSql || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1)';

                              v_vLocation := 'ParentLimit';

                             BEGIN
                                EXECUTE IMMEDIATE v_nSql INTO v_vParentLimit USING v_iLimitCode;
                             EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                v_vParentLimit:=0;
                             END;

                              --JIRA 24633 knakra starts
                              IF v_vRECORD_TYPE = 'H' THEN
                                v_vErrMsgDesc := 'Policy Limit exceeded for Policy with Policy Name: ' || NVL(v_vPOLICY_NAME, '');
								v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                              ELSE
                                v_vErrMsgDesc := 'Policy Limit exceeded for Policy with POLICY_NAME: ' || NVL(v_vPOLICY_NAME, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', POLICY_NUMBER: ' || NVL(v_vPOLICY_NUMBER, '') || ', POLICY_SYMBOL: ' || NVL(v_vPOLICY_SYMBOL, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', MASTER_COMPANY: ' || NVL(v_vMASTER_COMPANY, '') || ', LOCATION_COMPANY: ' || NVL(v_vLOCATION_COMPANY, '');
                                v_vErrMsgDesc := v_vErrMsgDesc || ', MODULE_NO: ' || NVL(v_vMODULE_NO, '');
								v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                                v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                              END IF;
                              --JIRA 24633 knakra ends
                              IF v_vParentLimit = 'AGG' THEN
                                 IF v_vdbCvgKey IS NOT NULL THEN
                                    --IF v_dLimitAmt < (v_dAggAmtOnCvg + v_fAMOUNT) THEN               JIRA 29954 knakra
                                    IF (v_dLimitAmt < (v_dAggAmtOnPol + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dAggAmtOnPol + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       v_vErrColumns := v_vErrColumns || ',COVERAGE_CODE';
                                       v_vErrMsgDesc := v_vErrMsgDesc || ', COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
									   v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                                       DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_iDA_ROW_ID,
                                                             'PAYMENT',
                                                             'PolLimitCvgAgg',
                                                             'PolLimitCvgAgg',
                                                             'DDS_PROCESS_PAYMENTS',
                                                             v_vErrMsgDesc,
                                                             v_vErrColumns,
                                                             'DDS_PAYMENT',
                                                             'CLAIM_ID',
                                                             v_vCLAIM_ID,
                                                             1);

                                       v_iErrCnt := v_iErrCnt + 1;
                                    END IF;
                                 ELSE
                                    IF (v_dLimitAmt < (v_dAggAmtOnPol + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dAggAmtOnPol + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
									   DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                             v_iDA_ROW_ID,
                                                             'PAYMENT',
                                                             'PolLimitAgg',
                                                             'PolLimitAgg',
                                                             'DDS_PROCESS_PAYMENTS',
                                                             v_vErrMsgDesc,
                                                             v_vErrColumns,
                                                             'DDS_PAYMENT',
                                                             'CLAIM_ID',
                                                             v_vCLAIM_ID,
                                                             1);

                                       v_iErrCnt := v_iErrCnt + 1;
                                    END IF;
                                 END IF;
                              ELSE
                                 IF v_vParentLimit = 'OCC' THEN
                                    IF v_vdbCvgKey IS NOT NULL THEN
                                       IF (v_dLimitAmt < (v_dOccAmtOnCvg + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dOccAmtOnCvg + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       --IF v_dLimitAmt < (v_dOccAmtOnCvg + v_fAMOUNT) THEN   JIRA 29954 knakra
                                          v_vErrColumns := v_vErrColumns || ',COVERAGE_CODE';
                                          v_vErrMsgDesc := v_vErrMsgDesc || ', COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
										  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                                          DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_iDA_ROW_ID,
                                                                'PAYMENT',
                                                                'PolLimitCvgOcc',
                                                                'PolLimitCvgOcc',
                                                                'DDS_PROCESS_PAYMENTS',
                                                                v_vErrMsgDesc,
                                                                v_vErrColumns,
                                                                'DDS_PAYMENT',
                                                                'CLAIM_ID',
                                                                v_vCLAIM_ID,
                                                                1);

                                          v_iErrCnt := v_iErrCnt + 1;
                                       END IF;
                                    ELSE
                                       --IF v_dLimitAmt < (v_dOccAmtOnPol + v_fAMOUNT) THEN   JIRA 29954 knakra
                                       IF (v_dLimitAmt < (v_dOccAmtOnCvg + v_dPolCurrAmt) AND v_iMcFlag IS NOT NULL AND v_iMcFlag <> 0) OR (v_dLimitAmt < (v_dOccAmtOnCvg + v_dBaseCurrAmt) AND (v_iMcFlag IS NULL OR v_iMcFlag = 0)) THEN
                                       -- Kapil Error msg is not there
                                          v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
										  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                                v_iDA_ROW_ID,
                                                                'PAYMENT',
                                                                'PolLimitOcc',
                                                                'PolLimitOcc',
                                                                'DDS_PROCESS_PAYMENTS',
                                                                v_vErrMsgDesc,
                                                                v_vErrColumns,
                                                                'DDS_PAYMENT',
                                                                'CLAIM_ID',
                                                                v_vCLAIM_ID,
                                                                1);

                                          v_iErrCnt := v_iErrCnt + 1;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END;
                        END LOOP;
                        CLOSE PLimitCursor;

                     END;
                     ELSE
                     BEGIN
                        IF v_vPolKey IS NULL THEN
                           v_vErrMsgDesc := 'POLICY KEY is null for POLICY NAME: ' || NVL(v_vPOLICY_NAME, '');
                           v_vErrMsgDesc := v_vErrMsgDesc || ', Invalid Policy in Database. ';
						   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE = 'H' THEN
                             v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                           ELSE
                             v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                           END IF;
                           --JIRA 24633 knakra ends
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_iDA_ROW_ID,
                                                 'PAYMENT',
                                                 'PolKeyNull',
                                                 'PolKeyNull',
                                                 'DDS_PROCESS_PAYMENTS',
                                                 v_vErrMsgDesc,
                                                 v_vErrColumns,
                                                 'DDS_PAYMENT',
                                                 'CLAIM_ID',
                                                 v_vCLAIM_ID,
                                                 1);

                           v_iErrCnt := v_iErrCnt + 1;
                        END IF;

                        IF v_vCvgKey IS NULL THEN
                           v_vErrMsgDesc := 'COVERAGE_KEY is null for COVERAGE_CODE: ' || NVL(v_vCOVERAGE_CODE, '');
                           v_vErrMsgDesc := v_vErrMsgDesc || ', Invalid Coverage in Database.';
						   v_vErrMsgDesc := v_vErrMsgDesc || ' Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                           --JIRA 24633 knakra starts
                           IF v_vRECORD_TYPE = 'H' THEN
                             v_vErrColumns := 'POLICY_NUMBER,MASTER_COMPANY,REGION';
                           ELSE
                             v_vErrColumns := 'POLICY_NAME,POLICY_NUMBER,POLICY_SYMBOL,MASTER_COMPANY,LOCATION_COMPANY,MODULE_NO';
                           END IF;
                           --JIRA 24633 knakra ends
                           DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                                 v_iDA_ROW_ID,
                                                 'PAYMENT',
                                                 'CvgKeynull',
                                                 'CvgKeynull',
                                                 'DDS_PROCESS_PAYMENTS',
                                                 v_vErrMsgDesc,
                                                 v_vErrColumns,
                                                 'DDS_PAYMENT',
                                                 'CLAIM_ID',
                                                 v_vCLAIM_ID,
                                                 1);

                           v_iErrCnt := v_iErrCnt + 1;
                        END IF;

                     END;
                     END IF;

                  END;
                  END IF;

               END;
               END IF;

            END;
            END IF;

            --Check for Policy Limits ends--

         --JIRA 29954 knakra starts(Moved this code here from above after calculating Currency Rates)
         IF v_oDontCheckDupPay = 0 OR v_oDontCheckDupPay IS NULL THEN   --Check for duplicate Payments starts
            v_nSql := 'SELECT F.TRANS_ID FROM ' || v_vDbName || 'FUNDS F, ' || v_vDbName;
            --JIRA 23831 knakra starts
            IF iVarfinKey <> 0 THEN
               v_nSql := v_nSql || 'RESERVE_CURRENT RC, ' || v_vDbName;
            END IF;
            --JIRA 23831 knakra ends
            v_nSql := v_nSql || 'FUNDS_TRANS_SPLIT FTS WHERE F.CLAIM_ID = :1';
			--Sdalvi3 Jira 65683
			IF v_vCHECK_STATUS = 'P' THEN
				v_nSql := v_nSql || ' AND F.CTL_NUMBER = :2 AND F.TRANS_DATE = :3';
			ELSE
				v_nSql := v_nSql || ' AND F.TRANS_DATE = :3';
			END IF;            
            v_nSql := v_nSql || ' AND F.TRANS_NUMBER = :4';

            IF v_vTRANSACTION_TYPE = 'P' THEN
               v_nSql := v_nSql || ' AND F.PAYMENT_FLAG <> 0';
            ELSE
               v_nSql := v_nSql || ' AND F.PAYMENT_FLAG = 0';
            END IF;

         IF v_vCHECK_STATUS = 'V' THEN
            v_nSql := v_nSql || ' AND F.VOID_FLAG <> 0';
         ELSE
            v_nSql := v_nSql || ' AND F.VOID_FLAG = 0';
         END IF;
		 IF (v_fVersionNum >= 19.1) THEN
			v_nSql := v_nSql || ' AND F.STOP_PAY_FLAG = 0';
		 END IF;
		 
         --JIRA 23831 knakra starts
         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RC_ROW_ID = FTS.RC_ROW_ID';
         END IF;
         --JIRA 23831 knakra ends
         v_nSql := v_nSql || ' AND F.TRANS_ID = FTS.TRANS_ID';
         --JIRA 23831 knakra starts
         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RESERVE_TYPE_CODE = :5';
         ELSIF iVarfinKey = 0 THEN
            v_nSql := v_nSql || ' AND FTS.RESERVE_TYPE_CODE = :5';
         END IF;
         --JIRA 23831 knakra ends
         v_nSql := v_nSql || ' AND (F.AMOUNT - :6) >= 0';
         v_nSql := v_nSql || ' AND (F.AMOUNT - :7) <= 0.009';
         --JIRA 23831 knakra starts
         IF iIncRsvSubType <> 0 AND iVarFinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RC.RESERVE_CATEGORY = :8';
         END IF;
         --JIRA 23831 knakra ends
         BEGIN
               --JIRA 23831 knarka starts
               IF iVarfinKey <> 0 AND iIncRsvSubType <> 0 THEN
				--EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_fAMOUNT, v_fAMOUNT, v_iResSubTypeCodeId;    JIRA 29954 knakra
					EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_dBaseCurrAmt, v_dBaseCurrAmt, v_iResSubTypeCodeId;      --JIRA 29954 knakra
					
               ELSE					
				--EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_fAMOUNT, v_fAMOUNT;          JIRA 29954 knakra
					EXECUTE IMMEDIATE  v_nSql INTO v_iTransid USING v_iClaimId,v_vCHECK_NO,v_vACTIVITY_DATE,v_iTransNumber,v_iResTypeCodeId,v_dBaseCurrAmt, v_dBaseCurrAmt;            --JIRA 29954 knakra
               END IF;
               --JIRA 23831 knakra ends
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_iTransid := 0;
            WHEN OTHERS THEN
                  V_iErrCnt := V_iErrCnt + 1;
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'DupPayErr',
                                        'DupPayErr',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);
         END;
         IF v_iTransid IS NOT NULL AND v_iTransid <> 0 THEN
          v_vErrMsgDesc := 'Duplicate Payment exists in the rmA Database. ';
		  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
          V_iErrCnt := V_iErrCnt + 1;
		  --Sdalvi3 Jira 65683
		  IF v_vCHECK_STATUS = 'P' THEN
			DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                v_iDA_ROW_ID,
                                'PAYMENT',
                                'DupPay',
                                'DupPay',
                                'DDS_PROCESS_PAYMENTS',
                                v_vErrMsgDesc,
                                'CLAIM_ID,CHECK_NO,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE',
                                'DDS_PAYMENT',
                                'CLAIM_ID',
                                v_vCLAIM_ID,
                                1);
		  ELSE
			DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                v_iDA_ROW_ID,
                                'PAYMENT',
                                'DupPay',
                                'DupPay',
                                'DDS_PROCESS_PAYMENTS',
                                v_vErrMsgDesc,
                                'CLAIM_ID,AMOUNT,ACTIVITY_DATE,RESERVE_TYPE',
                                'DDS_PAYMENT',
                                'CLAIM_ID',
                                v_vCLAIM_ID,
                                1);
		  END IF;
          
       END IF;
      END IF;                   --Check for Duplicate Payments ends

                     --Distribution Type Starts
          IF v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN  --JIRA 26252 knakra starts(making it common for both Carrier and Corporate Clients)
             IF v_iAccountId <> 0 AND v_iAccountId IS NOT NULL THEN
             BEGIN
                v_nSql := 'SELECT IS_EFT_ACCOUNT FROM ' || v_vDbName || 'ACCOUNT WHERE ACCOUNT_ID = :1';

                v_vLocation := 'IsEft';

                BEGIN
                  EXECUTE IMMEDIATE    v_nSql INTO  v_iIsEft USING  v_iAccountId;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                v_iIsEft:=0 ;
                END;

                IF v_vDSTRBN_TYPE_CODE IS NULL OR v_vDSTRBN_TYPE_CODE IS NULL THEN
                   v_nSql := 'SELECT DEF_DSTRBN_TYPE_CODE FROM ' || v_vDbName || 'CHECK_OPTIONS';

                   v_vLocation := 'DefDistType';

                  BEGIN
                    EXECUTE IMMEDIATE    v_nSql INTO  v_iDistTypeCodeId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  v_iDistTypeCodeId:=0 ;
                  END;
                END IF;

                v_nSql := 'SELECT  SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1 AND DELETED_FLAG = 0';

                v_vLocation := 'DistTypeSCode';

                  BEGIN
                    EXECUTE IMMEDIATE    v_nSql INTO  v_vDistTypeSCode USING v_iDistTypeCodeId;
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  v_iDistTypeCodeId:=0 ;
                  END;

                IF ( v_vDistTypeSCode = 'MAL' ) THEN
                BEGIN
                   IF v_iTransNumber = 0 THEN
                      v_vErrMsgDesc := 'Check Number cannot be left empty for Distribution Type: MAL. ';
					  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_iDA_ROW_ID,
                                            'PAYMENT',
                                            'VERR13',
                                            'VERR13',
                                            'DDS_PROCESS_PAYMENTS',
                                            v_vErrMsgDesc,
                                            'DSTRBN_TYPE_CODE',
                                            'DDS_PAYMENT',
                                            'CLAIM_ID',
                                            v_vCLAIM_ID,
                                            1);

                      v_iErrCnt := v_iErrCnt + 1;
                   END IF;

                   IF v_iChkStatCodeId <> v_iPrintedStatus THEN
                      v_vErrMsgDesc := 'Check Status should be ''PRINTED'' for Distribution Type: MAL. ';
					  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_iDA_ROW_ID,
                                            'PAYMENT',
                                            'VERR13',
                                            'VERR13',
                                            'DDS_PROCESS_PAYMENTS',
                                            v_vErrMsgDesc,
                                            'DSTRBN_TYPE_CODE',
                                            'DDS_PAYMENT',
                                            'CLAIM_ID',
                                            v_vCLAIM_ID,
                                            1);

                      v_iErrCnt := v_iErrCnt + 1;
                   END IF;

                END;
                END IF;

                IF v_iIsEft = 0 AND v_vDistTypeSCode = 'EFT' THEN
                   v_vErrMsgDesc := 'EFT Account is required for an EFT Transaction, Please Correct the data. ';
				   v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                   DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                         v_iDA_ROW_ID,
                                         'PAYMENT',
                                         'VERR13',
                                         'VERR13',
                                         'DDS_PROCESS_PAYMENTS',
                                         v_vErrMsgDesc,
                                         'DSTRBN_TYPE_CODE',
                                         'DDS_PAYMENT',
                                         'CLAIM_ID',
                                         v_vCLAIM_ID,
                                         1);
                   v_iErrCnt := v_iErrCnt + 1;
                END IF;
                
                --JIRA 43561 knakra starts
              IF v_iTransNumber IS NOT NULL AND v_iTransNumber > 0 THEN
                v_vDistTypeSCode := 'MAL';
                v_iDistTypeCodeId := iMalDistTypeCode;

                IF v_iChkStatCodeId <> v_iPrintedStatus THEN
                  V_vErrMsgDesc := 'Status Code should be printed as Check Number is provided in the import file. ';
				  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_iDA_ROW_ID,
                                            'PAYMENT',
                                            'TransNumDist',
                                            'TransNumDist',
                                            'DDS_PROCESS_PAYMENTS',
                                            v_vErrMsgDesc,
                                            'CHECK_STATUS',
                                            'DDS_PAYMENT',
                                            'CLAIM_ID',
                                            v_vCLAIM_ID,
                                            1);
                  V_iErrCnt := v_iErrCnt + 1;
                END IF;
              END IF;
              --JIRA 43561 knakra ends

                IF v_vDistTypeSCode NOT IN ( 'EFT','MAL' ) AND v_iChkStatCodeId = v_iPrintedStatus THEN
                   --JIRA 26805 knakra starts
                   --v_nSql := 'SELECT ROW_ID FROM ' || v_vDbName || 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE IN(';
                   --v_nSql := v_nSql || 'SELECT CODE_ID FROM ' || v_vDbName || 'CODES WHERE TABLE_ID = (SELECT TABLE_ID FROM ' || v_vDbName || 'GLOSSARY';
                   --v_nSql := v_nSql || ' WHERE SYSTEM_TABLE_NAME = :1) AND SHORT_CODE NOT IN(''EFT'',''MAL''))';
                   v_nSql := 'SELECT ROW_ID FROM ' || v_vDbName || 'CHECK_PRINT_OPTIONS WHERE DSTRBN_TYPE_CODE = :1 AND ROWNUM = 1';

                   BEGIN
                     v_vLocation := 'ChkPrintOptns';
                     EXECUTE IMMEDIATE v_nSql INTO v_iRowId USING v_iDistTypeCodeId;
                   EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     v_iRowid := 0;
                   END;

                   IF v_iRowId IS NULL OR v_iRowId = 0 THEN --JIRA 26805 knakra ends
                      v_vErrMsgDesc := 'Mapping is missing in Print Check Options for DSTRBN_TYPE_CODE: ' || NVL(v_vDistTypeSCode, '');
					  v_vErrMsgDesc := v_vErrMsgDesc || '. Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
                      DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                            v_iDA_ROW_ID,
                                            'PAYMENT',
                                            'VERR13',
                                            'VERR13',
                                            'DDS_PROCESS_PAYMENTS',
                                            v_vErrMsgDesc,
                                            'DSTRBN_TYPE_CODE',
                                            'DDS_PAYMENT',
                                            'CLAIM_ID',
                                            v_vCLAIM_ID,
                                            1);

                      v_iErrCnt := v_iErrCnt + 1;
                   END IF;
                END IF;
             END;
             ELSE
                v_vErrMsgDesc := 'Account/Sub Acount doesnot exist in rmA. ';
				v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                IF v_iUseSubAcc = 0 THEN
                   v_vErrColumns := 'BANK_SUB_ACCNT_NUM';
                ELSE
                   v_vErrColumns := 'BANK_ACCOUNT_NUM';
                END IF;

                DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                      v_iDA_ROW_ID,
                                      'PAYMENT',
                                      'VERR13',
                                      'VERR13',
                                      'DDS_PROCESS_PAYMENTS',
                                      v_vErrMsgDesc,
                                      v_vErrColumns,
                                      'DDS_PAYMENT',
                                      'CLAIM_ID',
                                      v_vCLAIM_ID,
                                      1);

                v_iErrCnt := v_iErrCnt + 1;
             END IF;
          END IF;         --Distribution Type Ends   JIRa 26252 knakra ends
      END;
   EXCEPTION
      WHEN OTHERS THEN
            v_vErrMsgDesc := SQLERRM;
            DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                  v_iDA_ROW_ID,
                                  'PAYMENT',
                                  v_vLocation,
                                  v_vLocation,
                                  'DDS_PROCESS_PAYMENT',
                                  v_vErrMsgDesc,
                                  'CLAIM_ID',
                                  'DDS_PAYMENT',
                                  'CLAIM_ID',
                                  v_vCLAIM_ID,
                                  0);

            v_iErrCnt := v_iErrCnt + 1;
   END;
   -- Kapil done till here 3-Mar-2016
   IF ( ( ((v_iCarrierFlag <> 0 and iVarfinKey = 0) or (iVarfinKey <> 0 and iIncPolCvg <> 0))
     AND v_iCvgLossRowId IS NOT NULL
     AND v_iCvgLossRowId <> 0 )
     OR ((v_iCarrierFlag = 0 and iVarfinKey = 0) or (iVarfinKey <> 0 and iIncPolCvg = 0)) )
     AND v_vTRANSACTION_TYPE = 'R' THEN
   BEGIN
      IF v_oChkDupReserves <> 0 THEN --Check for Duplicate Reserves Starts
         v_nSql := 'SELECT  RSV_ROW_ID FROM ' || v_vDbName || 'RESERVE_HISTORY WHERE';
         v_nSql := v_nSql || ' RES_STATUS_CODE = :1 AND ';
         --JIRA 29954 knakra starts
         IF v_fVersionNum >= 16.4 AND v_iMcFlag <>  0 AND v_iMcFlag IS NOT NULL THEN
            v_nSql := v_nSql || '(CLAIM_CURRENCY_RESERVE_AMOUNT - :2) >= 0 AND ';
            v_nSql := v_nSql || '(CLAIM_CURRENCY_RESERVE_AMOUNT - :3) <= 0.009 ';
         ELSE
            v_nSql := v_nSql || '(RESERVE_AMOUNT - :2) >= 0 AND ';
            v_nSql := v_nSql || '(RESERVE_AMOUNT - :3) <= 0.009 ';
         END IF;
         v_nSql := v_nSql || 'AND CLAIM_ID = :4';
         --JIRA 23831 knakra starts
         IF (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncClaimant <> 0)) AND v_iClaimantEid IS NOT NULL AND v_iClaimantEid <> 0 THEN
            v_nSql := v_nSql || ' AND CLAIMANT_EID = ' || v_iClaimantEid;
         END IF;
         v_nSql := v_nSql || ' AND RESERVE_TYPE_CODE = :6';
         --IF iVarfinKey = 0 AND v_iVehicleId <> 0 AND v_iVehicleId IS NOT NULL THEN --asharma590 jira rma- 65679
         --   v_nSql := v_nSql || ' AND UNIT_ID = ' || v_iVehicleId;
         --END IF;
         v_nSql := v_nSql || ' AND DATE_ENTERED = :8';

         IF (v_iCarrierFlag <> 0 OR (iVarfinKey <> 0 AND iIncPolCvg <> 0)) AND v_iCvgLossRowId IS NOT NULL AND v_iCvgLossRowId <> 0 THEN
            v_nSql := v_nSql || ' AND POLCVG_LOSS_ROW_ID = ' || v_iCvgLossRowId;
         END IF;

         IF iVarfinKey <> 0 THEN
            v_nSql := v_nSql || ' AND RESERVE_CATEGORY = ' || v_iResSubTypeCodeId;
         END IF;
         --JIRA 23831 knakra ends

         BEGIN

               BEGIN
                 --JIRA 23831 knakra starts
                 /*IF v_iCarrierFlag <> 0 THEN
                    EXECUTE IMMEDIATE v_nSql INTO v_iRsvRowId USING v_iResStatusCodeId,v_fAMOUNT,v_fAMOUNT,v_iClaimId,v_iResTypeCodeId,v_vACTIVITY_DATE,v_iCvgLossRowId  ;
                 ELSE
                    EXECUTE IMMEDIATE v_nSql INTO v_iRsvRowId USING v_iResStatusCodeId,v_fAMOUNT,v_fAMOUNT,v_iClaimId,v_iResTypeCodeId,v_vACTIVITY_DATE;
                 END IF;*/
                 --EXECUTE IMMEDIATE v_nSql INTO v_iRsvRowId USING v_iResStatusCodeId,v_fAMOUNT,v_fAMOUNT,v_iClaimId,v_iResTypeCodeId,v_vACTIVITY_DATE;   JIRA 29954 knakra
                 EXECUTE IMMEDIATE v_nSql INTO v_iRsvRowId USING v_iResStatusCodeId,v_dInpAmt,v_dInpAmt,v_iClaimId,v_iResTypeCodeId,v_vACTIVITY_DATE;     --JIRA 29954 knakra
                 --JIRA 23831 knakra ends
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_iRsvRowId:=0;
               END;

               IF v_iRsvRowId IS NOT NULL AND v_iRsvRowId <> 0 THEN
                  v_vErrMsgDesc := 'Duplicate Reserve already exists in the database. Either unselect ''Check Duplicate Reserve Transactions'' on UI or correct data. ';
				  v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';

                  IF v_iVehicleId > 0 AND v_iVehicleId IS NOT NULL THEN
                     v_vErrColumns := 'UNIT_ID,RESERVE_TYPE,ACTIVITY_DATE,AMOUNT,RES_STATUS_CODE';
                  ELSE
                     v_vErrColumns := 'CLMNT_LAST_NAME,CLMNT_FIRST_NAME,CLMNT_TAX_ID,RESERVE_TYPE,ACTIVITY_DATE,AMOUNT,RES_STATUS_CODE';
                  END IF;

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'DupRes',
                                        'DupRes',
                                        'DDS_PROCESS_PAYMENTS',
                                        v_vErrMsgDesc,
                                        v_vErrColumns,
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        1);

                  v_iErrCnt := v_iErrCnt + 1;
               END IF;
         EXCEPTION
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'DupResErr',
                                        'DupResErr',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);

                  v_iErrCnt := v_iErrCnt + 1;
         END;
      END IF;
      --Check for Duplicate Reserves Ends
      --JIRA 29954 knakra starts
      IF v_fVersionNum >= 16.4 THEN
         v_nSql := 'SELECT RC_ROW_ID, RESERVE_AMOUNT, CLAIM_CURRENCY_RESERVE_AMOUNT, POLICY_CURR_RESERVE_AMOUNT FROM ' || v_vDbName || 'RESERVE_CURRENT';
      ELSE
         v_nSql := 'SELECT RC_ROW_ID, RESERVE_AMOUNT FROM ' || v_vDbName || 'RESERVE_CURRENT';
      END IF;
      v_nSql := v_nSql || ' WHERE CLAIM_ID = :1';
      --JIRA 23831 knakra starts
      IF (iVarfinKey = 0 OR (iVarfinKey <> 0 AND iIncClaimant <> 0)) AND v_iClaimantEid IS NOT NULL AND v_iClaimantEid <> 0 THEN
         v_nSql := v_nSql || ' AND CLAIMANT_EID = ' || v_iClaimantEid;
      END IF;
      v_nSql := v_nSql || ' AND RESERVE_TYPE_CODE = :2';
      --IF iVarfinKey = 0 AND v_iVehicleId IS NOT NULL AND v_iVehicleId <> 0 THEN --- asharma590 jira RMA-65679
      --v_nSql := v_nSql || ' AND UNIT_ID = '|| v_iVehicleId;
      --END IF;

      IF ((v_iCarrierFlag <> 0 AND iVarfinKey = 0) Or (iVarfinKey <> 0 AND iIncPolCvg <> 0)) AND v_iCvgLossRowId IS NOT NULL AND v_iCvgLossRowId <> 0 THEN
         v_nSql := v_nSql || ' AND POLCVG_LOSS_ROW_ID = ' || v_iCvgLossRowId;
      END IF;

      IF iVarfinKey <> 0 AND iIncRsvSubType <> 0 THEN
         v_nSql := v_nSql || ' AND RESERVE_CATEGORY = ' || v_iResSubTypeCodeId;
      END IF;
      --JIRA 23831 knakra ends
       BEGIN
         /*IF v_iCarrierFlag <> 0 THEN
            EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId,v_fCurRsvAmt USING v_iClaimId,v_iClaimantEid,v_iResTypeCodeId,v_iVehicleId,v_iCvgLossRowId  ;
         ELSE
            EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId,v_fCurRsvAmt USING v_iClaimId,v_iClaimantEid,v_iResTypeCodeId,v_iVehicleId;
         END IF;*/
         --JIRA 29954 knakra starts
         IF v_fVersionNum >= 16.4 THEN
            EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId,v_dBaseCurrRsvAmt, v_dClmCurrRsvAmt, v_dPolCurrRsvAmt USING v_iClaimId,v_iResTypeCodeId;
         ELSE
            EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId,v_fCurRsvAmt USING v_iClaimId,v_iResTypeCodeId;
         END IF;
         --JIRA 29954 knakra ends
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            v_iRcRowId:=0;
            v_fCurRsvAmt:=0;
       END;

      IF v_iRcRowId IS NOT NULL AND v_iRcRowId <> 0 THEN
      BEGIN
         BEGIN
            BEGIN
			   ---udoni RMA-75601 starts
			   IF v_fVersionNum >= 20.2 THEN
					v_nSql := 'SELECT COUNT(IS_LOCKED) FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE RC_ROW_ID =:1 AND ((IS_LOCKED = 1) OR (IS_LOCKED = -1))';
					EXECUTE IMMEDIATE v_nSql INTO v_V_Count_islocked_reserve USING v_iRcRowId;
					IF v_V_Count_islocked_reserve > 0 THEN
						            v_vErrMsgDesc := 'Reserve is locked. Payment cannot be done or reserve cannot be updated. ';
									v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
								v_vErrColumns := 'CLAIM_ID,RESERVE_TYPE';
								DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                   				v_iDA_ROW_ID,
                                   				'PAYMENT',
                                   				'Resislocked',
                                   				'Resislocked',
                                   				'DDS_PROCESS_PAYMENTS',
                                   				v_vErrMsgDesc,
                                   				v_vErrColumns,
                                   				'DDS_PAYMENT',
                                   				'CLAIM_ID',
                                   				v_vCLAIM_ID,
                                   				1);
								v_iErrCnt := v_iErrCnt + 1;
					END IF;
			   END IF;
			   ---udoni RMA-75601 ends
               IF v_fVersionNum >= 16.4 THEN
                  v_iRsvUpdFlag := 1;
               ELSE
                  v_iRsvUpdFlag := 0;
               END IF;

               --JIRA 29954 knakra starts
               --v_fChangeAmt := v_fAMOUNT - v_fCurRsvAmt;
               IF v_fVersionNum < 16.4 THEN
                  v_fChangeAmt := v_dInpAmt - v_fCurRsvAmt;
               ELSE
                  v_dClmCurrChgAmt := v_dClmCurrAmt - v_dClmCurrRsvAmt;
				  ----akumar523RMA-63934 
                  -- IF v_dClmCurrChgAmt IS NULL OR v_dClmCurrChgAmt = 0 THEN
                     -- v_dBaseCurrAmt := v_dBaseCurrRsvAmt + (v_iClmToBaseRate * 1);
                     -- v_dPolCurrAmt := v_dPolCurrRsvAmt + (v_iClmToPolRate * 1);
                  -- ELSE
                  v_dBaseCurrAmt := v_dBaseCurrRsvAmt + (v_iClmToBaseRate * v_dClmCurrChgAmt);
                  v_dPolCurrAmt := v_dPolCurrRsvAmt + (v_iClmToPolRate * v_dClmCurrChgAmt);
                  ---END IF;
				  ----akumar523 RMA-63934
                  v_fChangeAmt := v_dBaseCurrAmt - v_dBaseCurrRsvAmt;
                  v_dPolCurrChgAmt := v_dPolCurrAmt - v_dPolCurrRsvAmt;
               END IF;

               IF v_fVersionNum >= 16.4 THEN
                  v_nSql := 'SELECT SUM(FTS.AMOUNT), SUM(FTS.CLAIM_CURRENCY_AMOUNT), SUM(FTS.POLICY_CURRENCY_AMOUNT) FROM ' || v_vDbName || 'FUNDS F,';
               ELSE
                  v_nSql := 'SELECT SUM(FTS.AMOUNT) FROM ' || v_vDbName || 'FUNDS F,';
               END IF;
               --JIRA 29954 knakra ends
               v_nSql := v_nSql || v_vDbName || 'FUNDS_TRANS_SPLIT FTS,';
               v_nSql := v_nSql || v_vDbName || 'RESERVE_CURRENT RC';
               v_nSql := v_nSql || ' WHERE F.TRANS_ID = FTS.TRANS_ID';
               v_nSql := v_nSql || ' AND RC.RC_ROW_ID = FTS.RC_ROW_ID';
               v_nSql := v_nSql || ' AND RC.RC_ROW_ID = :1';
               v_nSql2 := v_nSql || ' AND F.PAYMENT_FLAG = 0 AND F.COLLECTION_FLAG <> 0';

               v_vLocation := 'ColTot';

               BEGIN
                  --JIRA 29954 knakra starts
                  IF v_fVersionNum >= 16.4 THEN
                     EXECUTE IMMEDIATE v_nSql2 INTO v_dBaseCurrColTot, v_dClmCurrColTot, v_dPolCurrColTot USING v_iRcRowId;
                  ELSE
                     EXECUTE IMMEDIATE v_nSql2 INTO v_dBaseCurrColTot USING v_iRcRowId;
                  END IF;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_dBaseCurrColTot := 0;
                    v_dClmCurrColTot := 0;
                    v_dPolCurrColTot := 0;
               END;

               IF v_dBaseCurrColTot IS NULL THEN
                 v_dBaseCurrColTot := 0.0;
               END IF;
               IF v_dPolCurrColTot IS NULL THEN
                  v_dPolCurrColTot := 0.0;
               END IF;
               IF v_dClmCurrColTot IS NULL THEN
                  v_dClmCurrColTot := 0.0;
               END IF;
               --JIRA 29954 knakra ends

               v_nSql2 := v_nSql || ' AND F.PAYMENT_FLAG <> 0 AND F.COLLECTION_FLAG = 0';

               v_vLocation := 'PaidTot';

               BEGIN
               --JIRA 29954 knakra starts
               IF v_fVersionNum >= 16.4 THEN
                  EXECUTE IMMEDIATE v_nSql2 INTO v_dBaseCurrPaidTot, v_dClmCurrPaidTot, v_dPolCurrPaidTot USING v_iRcRowId;
               ELSE
                  EXECUTE IMMEDIATE v_nSql2 INTO v_dBaseCurrPaidTot USING v_iRcRowId;
               END IF;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_dBaseCurrPaidTot:=0;
                    v_dClmCurrPaidTot := 0;
                    v_dPolCurrPaidTot := 0;
               END;

               IF v_dBaseCurrPaidTot IS NULL THEN
                 v_dBaseCurrPaidTot := 0.0;
               END IF;
               IF v_dClmCurrPaidTot IS NULL THEN
                  v_dClmCurrPaidTot := 0;
               END IF;
               IF v_dPolCurrPaidTot IS NULL THEN
                  v_dPolCurrPaidTot := 0;
               END IF;
               --JIRA 29954 knakra ends

               v_nSql := 'SELECT  SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID = (';
               v_nSql := v_nSql || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = :1)';
               v_vLocation := 'ParentRsv';

               BEGIN
                    EXECUTE IMMEDIATE v_nSql INTO v_vParentRsvCode USING v_iResTypeCodeId;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_vParentRsvCode:=0;
               END;


               v_nSql := 'SELECT COLL_IN_RSV_BAL,  COLL_IN_INCUR_BAL FROM ' || v_vDbName || 'SYS_PARMS_LOB';
               v_nSql := v_nSql || ' WHERE LINE_OF_BUS_CODE = :1';
               v_vLocation := 'LobParms';

               BEGIN
                    EXECUTE IMMEDIATE v_nSql INTO v_iCollInRsvBal,v_iColInIncBal USING v_iLob;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    v_iCollInRsvBal:=0;
                    v_iColInIncBal:=0;
               END;


               IF v_vParentRsvCode <> 'R' AND v_vParentRsvCode IS NOT NULL THEN
                  IF v_iCollInRsvBal <> 0 AND v_iCollInRsvBal IS NOT NULL THEN
                     --JIRA 29954 knakra starts
                     IF v_fVersionNum >= 16.4 THEN
                        v_dClmCurrBalAmt := v_dClmCurrAmt - (v_dClmCurrPaidTot - v_dClmCurrColTot);
                        v_dPolCurrBalAmt := v_dPolCurrAmt - (v_dPolCurrPaidTot - v_dClmCurrColTot);
                     END IF;
                     v_dBaseCurrBalAmt := v_dBaseCurrAmt - (v_dBaseCurrPaidTot - v_dBaseCurrColTot);
                     --v_fResBal := v_fAMOUNT - (v_fPaidTot - v_fColTot);
                     --JIRA 29954 knakra ends
                  ELSE
                     IF v_iCollInRsvBal = 0 OR v_iCollInRsvBal IS NULL THEN
                        --JIRA 29954 knakra starts
                        IF v_fVersionNum >= 16.4 THEN
                           v_dClmCurrBalAmt := v_dClmCurrAmt - v_dClmCurrPaidTot;
                           v_dPolCurrBalAmt := v_dPolCurrAmt - v_dPolCurrPaidTot;
                        END IF;
                        v_dBaseCurrBalAmt := v_dBaseCurrAmt - v_dBaseCurrPaidTot;
                        --JIRA 29954 knakra ends
                        --v_fResBal := v_fAMOUNT - v_fPaidTot;
                     END IF;
                  END IF;

                  IF v_iCollInRsvBal <> 0 AND v_iCollInRsvBal IS NOT NULL THEN
                     --JIRA 29954 knakra starts
                     /*IF v_fResBal < 0 THEN
                        v_fInccurAmt := v_fPaidTot - v_fColTot;
                     ELSE
                        v_fInccurAmt := v_fResBal + (v_fPaidTot - v_fColTot);
                     END IF;*/
                     IF v_dBaseCurrBalAmt < 0 THEN
                        v_dBaseCurrIncAmt := v_dBaseCurrPaidTot - v_dBaseCurrColTot;
                     ELSE
                        v_dBaseCurrIncAmt := v_dBaseCurrBalAmt + (v_dBaseCurrPaidTot - v_dBaseCurrColTot);
                     END IF;

                     IF v_fVersionNum >= 16.4 AND v_dClmCurrBalAmt < 0 THEN
                        v_dClmCurrIncAmt := v_dClmCurrPaidTot - v_dClmCurrColTot;
                     ELSIF v_fVersionNum >= 16.4 AND v_dClmCurrBalAmt >= 0 THEN
                        v_dClmCurrIncAmt := v_dClmCurrBalAmt + (v_dClmCurrPaidTot - v_dClmCurrColTot);
                     END IF;

                     IF v_fVersionNum >= 16.4 AND v_dPolCurrBalAmt < 0 THEN
                        v_dPolCurrIncAmt := v_dPolCurrPaidTot - v_dPolCurrColTot;
                     ELSIF v_fVersionNum >= 16.4 AND v_dPolCurrBalAmt >= 0 THEN
                        v_dPolCurrIncAmt := v_dPolCurrBalAmt + (v_dPolCurrPaidTot - v_dPolCurrColTot);
                     END IF;
                     --JIRA 29954 knakra ends
                  ELSE
                     --JIRA 29954 knakra starts
                     /*IF v_fResBal < 0 THEN
                        v_fInccurAmt := v_fPaidTot;
                     ELSE
                        v_fInccurAmt := v_fResBal + v_fPaidTot;
                     END IF;*/
                     IF v_dBaseCurrBalAmt < 0 THEN
                        v_dBaseCurrIncAmt := v_dBaseCurrPaidTot;
                     ELSE
                        v_dBaseCurrIncAmt := v_dBaseCurrBalAmt + v_dBaseCurrPaidTot;
                     END IF;

                     IF v_fVersionNum >= 16.4 AND v_dClmCurrBalAmt < 0 THEN
                        v_dClmCurrIncAmt := v_dClmCurrPaidTot;
                     ELSIF v_fVersionNum >= 16.4 AND v_dClmCurrBalAmt >= 0 THEN
                        v_dClmCurrIncAmt := v_dClmCurrBalAmt + v_dClmCurrPaidTot;
                     END IF;

                     IF v_fVersionNum >= 16.4 AND v_dPolCurrBalAmt < 0 THEN
                        v_dPolCurrIncAmt := v_dPolCurrPaidTot;
                     ELSIF v_fVersionNum >= 16.4 AND v_dPolCurrBalAmt >= 0 THEN
                        v_dPolCurrIncAmt := v_dPolCurrBalAmt + v_dPolCurrPaidTot;
                     END IF;
                     --JIRA 29954 knarka ends
                  END IF;

                  IF v_iColInIncBal <> 0 AND v_iColInIncBal IS NOT NULL THEN
                     --JIRA 29954 knakra starts
                     --v_fInccurAmt := v_fInccurAmt - v_fColTot;
                     v_dBaseCurrIncAmt := v_dBaseCurrIncAmt - v_dBaseCurrColTot;
                     IF v_fVersionNum >= 16.4 THEN
                        v_dClmCurrIncAmt := v_dClmCurrIncAmt - v_dClmCurrColTot;
                        v_dPolCurrIncAmt := v_dPolCurrIncAmt - v_dPolCurrColTot;
                     END IF;
                     --JIRA 29954 knakra ends
                  END IF;
               ELSE
                  IF v_vParentRsvCode = 'R' THEN
                     --JIRA 29954 kankra starts
                     /*v_fResBal := v_fAMOUNT - v_fColTot;

                     IF v_fResBal < 0 THEN
                        v_fInccurAmt := v_fColTot;
                     ELSE
                        v_fInccurAmt := v_fResBal + v_fColTot;
                     END IF;*/

                     v_dBaseCurrBalAmt := v_dBaseCurrAmt - v_dBaseCurrColTot;
                     IF v_fVersionNum >= 16.4 THEN
                        v_dPolCurrBalAmt := v_dPolCurrAmt - v_dPolCurrColTot;
                        v_dClmCurrBalAmt := v_dClmCurrAmt - v_dClmCurrColTot;

                        IF v_dPolCurrBalAmt < 0 THEN
                           v_dPolCurrIncAmt := v_dPolCurrColTot;
                        ELSE
                           v_dPolCurrIncAmt := v_dPolCurrBalAmt + v_dPolCurrColTot;
                        END IF;

                        IF v_dClmCurrBalAmt < 0 THEN
                           v_dClmCurrIncAmt := v_dClmCurrColTot;
                        ELSE
                           v_dClmCurrIncAmt := v_dClmCurrBalAmt + v_dClmCurrColTot;
                        END IF;
                     END IF;

                     IF v_dBaseCurrBalAmt < 0 THEN
                        v_dBaseCurrIncAmt := v_dBaseCurrColTot;
                     ELSE
                        v_dBaseCurrIncAmt := v_dBaseCurrBalAmt + v_dBaseCurrColTot;
                     END IF;

                  END IF;
               END IF;

            END;
         EXCEPTION
            WHEN OTHERS THEN
               BEGIN
                  v_vErrMsgDesc := SQLERRM;

                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        v_vLocation,
                                        v_vLocation,
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);

                  v_iErrCnt := v_ierrcnt + 1;

               END;
         END;

      END;
      END IF;

   END;
   END IF;

   -- kapil done till here 7-mar-2016
   v_vLocation := 'SuppVal';

   IF ( v_oFundSupp > 0 ) THEN
      DDS_SUPPLEMENT(v_p_JOBID,
                     v_oConfigId,
                     v_p_UserId,
                     'PAYMENT',
                     v_vDbName,
                     v_iDA_ROW_ID,
                     v_oAllowNewCodes,
                     0,
                     v_iErrCnt,
                     'V',
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     v_iTransid,
                     0,
                     0,
                     0,
                     'CLAIM_ID',
                     v_vCLAIM_ID,
                     v_iErrCntSupp);
   END IF;

   v_iErrCnt := v_iErrCnt + v_iErrCntSupp;


        --JIRA 33594 kkaur25 starts
        IF((v_iMcFlag <> 0 AND  v_dClmCurrChgAmt = 0) OR ((v_iMcFlag = 0 OR v_iMcFlag IS NULL) AND v_fChangeAmt = 0)) AND v_iRcRowId is not null and v_iRcRowId >0  AND v_vTRANSACTION_TYPE = 'R' THEN

          IF v_iErrCnt = 0 AND v_iBaseErr = 0 THEN

          EXECUTE IMMEDIATE 'UPDATE DDS_PAYMENT SET INVALID_ROW = 0  WHERE JOBID = :1 AND DA_ROW_ID = :2' USING v_P_JOBID , v_iDA_ROW_ID;
     --COMMIT;
            goto NEXTRECORD;
          END IF;

        END IF;
        --JIRA 33594 kkaur25 ends


 --Insert Part Starts
   IF v_vTRANSACTION_TYPE IN ( 'P','C' ) AND v_iBaseErr = 0 AND v_iErrCnt = 0 THEN
      BEGIN
          IF v_iCarrierFlag = 0 OR iVarfinKey <> 0 THEN --JIRA 23831 knakra(added variable fincial key condition)
          v_nSql := 'SELECT RC_ROW_ID FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE';
          v_nSql := v_nSql || ' CLAIM_ID = :1 AND CLAIMANT_EID = :2 AND RESERVE_TYPE_CODE = :3';
          v_nSql := v_nSql || ' AND UNIT_ID = :4';

          --JIRA 23831 knakra starts
          IF iVarfinKey <> 0 THEN
            IF iIncRsvSubType <> 0 AND v_iResSubTypeCodeId IS NOT NULL AND v_iResSubTypeCodeId <> 0 THEN
              v_nSql := v_nSql || ' AND RESERVE_CATEGORY = ' || v_iResSubTypeCodeId;
            END IF;
            IF iIncClaimant = 0 THEN
               v_iClaimantEid := 0;
               v_iVehicleId := 0;
            END IF;
          END IF;
          --JIRA 23831 knarka ends

          BEGIN
              EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId USING v_iClaimId, v_iClaimantEid, v_iResTypeCodeId, v_iVehicleId;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_iRcRowId:=0;
          END;

          --IF v_iRcRowId IS NULL OR v_iRcRowId = 0 THEN  JIRA 23831 knakra
          IF (v_iRcRowId IS NULL OR v_iRcRowId = 0) AND iVarfinKey = 0 THEN   --JIRA 23831 knakra
             v_vErrMsgDesc := '';
             -- Kapil need to check this.
             DDS_PROCESS_RES_CUR_NT_FOUND(v_iClaimId,
                                            v_iClaimantEid,
                                            v_iVehicleId,
                                            v_iLob,
                                            v_iResTypeCodeId,
                                            0,
                                            v_iOpenResStatusCode,
                                            1,
                                            v_vACTIVITY_DATE,
                                            v_iCvgLossRowid,
                                            v_iPolCvgRowId,
                                            v_vPOLICY_CVG_SEQNO,
                                            v_vDbName,
                                            v_P_JOBID,
                                            v_iDA_ROW_ID,
                                            v_vCLAIM_ID,
                                            iVarfinKey,
                                            v_iResSubTypeCodeId,   --JIRA 23831 knakra
                                            iHmiFlag,              --JIRA 24633 knakra
                                            v_vBEN_REVIEW_DATE,    --JIRA 24633 knakra
                                            iClaimMCFields,        --JIRA 28198 knakra starts
                                            iRsvMCFields,
                                            iPolMCFields,          --JIRA 28198 knakra ends
                                            v_dClmCurrAmt,
                                            v_dPolCurrAmt,
                                            v_iClmToBaseRate,
                                            v_iClmToPolRate,
                                            v_fVersionNum,
                                            v_iClmCurCodeId,
                                            v_iPolCurCodeId,
                                            v_iRcRowId,
                                            v_iReBalErrCnt);

             IF v_iReBalErrCnt > 0 THEN
                v_iErrCnt := v_iErrCnt + 1;
               GOTO NEXTRECORD;
             END IF;
          ELSIF (v_iRcRowId IS NULL OR v_iRcRowId = 0) AND iVarfinKey <> 0 THEN      --JIRA 23831 knakra starts
             v_vErrMsgDesc := 'Reserve doesnot exist in Riskmaster Database for this Payment. ';
			 v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
             v_vErrColumns := 'CLAIM_ID,RESERVE_TYPE';

             DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                   v_iDA_ROW_ID,
                                   'PAYMENT',
                                   'ResNotExists',
                                   'ResNotExists',
                                   'DDS_PROCESS_PAYMENTS',
                                   v_vErrMsgDesc,
                                   v_vErrColumns,
                                   'DDS_PAYMENT',
                                   'CLAIM_ID',
                                   v_vCLAIM_ID,
                                   1);

             v_iErrCnt := v_iErrCnt + 1;
			---udoni RMA-75601 starts
			ELSIF (v_iRcRowId IS NOT NULL OR v_iRcRowId != 0) THEN
			   IF v_fVersionNum >= 20.2 THEN
					v_nSql := 'SELECT COUNT(IS_LOCKED) FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE RC_ROW_ID =:1 AND ((IS_LOCKED = 1) OR (IS_LOCKED= -1))';
					EXECUTE IMMEDIATE v_nSql INTO v_V_Count_islocked_reserve USING v_iRcRowId;
					IF v_V_Count_islocked_reserve > 0 THEN
						            v_vErrMsgDesc := 'Reserve is locked. Payment cannot be done or reserve cannot be updated. ';
									v_vErrMsgDesc := v_vErrMsgDesc || 'Discarded Payment/Reserve is combination of transacation Date : ' || NVL(v_vTRANSACTION_TYPE, 'Transaction Date') || ', Check Number : ' || NVL(v_vCHECK_NO, 0) || ' and Amount : ' || LTRIM(TO_CHAR(v_dInpAmt)) || '. ';
								v_vErrColumns := 'CLAIM_ID,RESERVE_TYPE';
								DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                   				v_iDA_ROW_ID,
                                   				'PAYMENT',
                                   				'Resislocked',
                                   				'Resislocked',
                                   				'DDS_PROCESS_PAYMENTS',
                                   				v_vErrMsgDesc,
                                   				v_vErrColumns,
                                   				'DDS_PAYMENT',
                                   				'CLAIM_ID',
                                   				v_vCLAIM_ID,
                                   				1);
								v_iErrCnt := v_iErrCnt + 1;
					END IF;
			   END IF;
			   ---udoni RMA-75601 ends
          END IF;   --JIRA 23831 knakra ends
       END IF;

   v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

    BEGIN
           EXECUTE IMMEDIATE v_nSql INTO v_iTransId USING 'FUNDS';
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         v_iTransId:=0;
    END;

   --SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');;
      V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');
   -- Kapil need to check this..

      IF v_oAttachTransIdToChkNum <> 0     AND v_oAttachTransIdToChkNum IS NOT NULL AND v_vCHECK_NO IS NOT NULL THEN
         v_vCHECK_NO := v_vCHECK_NO || '-' || v_iTransId;
      END IF;
      
      --JIRA 38951 knakra starts
      v_iRetVal := 0;
      DDS_spCheckVersion(v_vTableName=>'FUNDS',
                            v_vFieldName  => 'EFT_FLAG',
                            vDbName => v_P_DB_NAME,
                            v_iRetVal=> v_iRetVal);
      --JIRA 38951 knakra ends
	  --Sdalvi3 Jira 65683 Start
	  IF v_vCHECK_STATUS <> 'P' THEN
		IF v_vCHECK_NO IS NULL AND v_vCHECK_NO = '' THEN
			BEGIN
				v_vCHECK_NO := '0' || v_iTransId;
			END;
		END IF;
	  END IF;
	  --Sdalvi3 Jira 65683 End
   v_nSql := 'INSERT INTO ' || v_vDbName || 'FUNDS(TRANS_ID, CLAIM_ID, CLAIM_NUMBER, TRANS_DATE, DATE_OF_CHECK, CTL_NUMBER, ';
   --JIRA 23831 knakra starts
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || 'CLAIMANT_EID, UNIT_ID, ';
   END IF;
   --JIRA 23831 knakra ends
   v_nSql := v_nSql || 'PAY_TO_THE_ORDER_OF, MANUAL_CHECK, ';
   v_nSql := v_nSql || 'TRANS_NUMBER, AMOUNT, ACCOUNT_ID, SUB_ACCOUNT_ID, STATUS_CODE, PAYEE_TYPE_CODE, PAYEE_EID, LAST_NAME, ';
   v_nSql := v_nSql || 'FIRST_NAME, ADDR1, ADDR2, CITY, STATE_ID, ZIP_CODE, PAYMENT_FLAG, COLLECTION_FLAG, VOID_FLAG, DTTM_RCD_ADDED, ';
   v_nSql := v_nSql || 'ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER, CHECK_MEMO, CLEARED_FLAG ,AUTO_CHECK_FLAG, PRECHECK_FLAG, FILED_1099_FLAG, VOID_DATE, VOID_REASON, BILL_TYPE,';
   --JIRA 29954 knakra starts
   IF v_fVersionNum >= 16.4 THEN
      v_nSql := v_nSql || 'PMT_CURRENCY_CODE, PMT_CURRENCY_AMOUNT, CLAIM_CURRENCY_CODE, CLAIM_CURRENCY_AMOUNT, POLICY_CURRENCY_CODE, POLICY_CURRENCY_AMOUNT, ';
   ELSE
      v_nSql := v_nSql || 'PMT_CURRENCY_CODE, PMT_CURRENCY_AMOUNT, PMT_TO_BASE_CUR_RATE, CLAIM_CURRENCY_CODE, CLAIM_CURRENCY_AMOUNT, PMT_TO_CLAIM_CUR_RATE, BASE_TO_PMT_CUR_RATE, BASE_TO_CLAIM_CUR_RATE, ';
   END IF;
   --JIRA 29954 knakra ends
   v_nSql := v_nSql || 'WITHHOLDING_PMT_FLAG, WITHHOLDING_TYPE, WITHHOLDING_CHILD_FLAG, PARENT_TRANS_ID, COMBINED_PAY_FLAG, DORMANCY_STATUS, RES_SUPP_PAYMENT_FLAG, DSTRBN_TYPE_CODE';
   --JIRA 38951 knakra starts
   IF v_iRetVal = 1 THEN
      v_nSql := v_nSql || ', EFT_FLAG';
   END IF;
   IF v_fVersionNum >= 19.1 THEN---asharma590
	  v_nSql := v_nSql || ', READY_TO_PRINT';
   END IF;
   
   --JIRA 38951 knakra ends
   v_nSql := v_nSql || ') VALUES( :1, :2, :3, :4, :5, :6, ';
   --JIRA 23831 knakra starts
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || ':7, :8, ';
   END IF;
   --JIRA 23831 knarka ends
   v_nSql := v_nSql || ':9, :10, :11, :12, :13, :14, :15, :16, :17, :18, ';
   v_nSql := v_nSql || ':19, :20, NULL, :21,:22, ';
   v_nSql := v_nSql || ':23, :24, :25, :26, :27, ';
   v_nSql := v_nSql || ':28, :29, :30, :31, :32, 0, 0, 0, :33,:34, 0,';
   --JIRA 29954 knakra starts
   IF (v_fVersionNum >= 16.4) THEN
      v_nSql := v_nSql || ':39, :40, :41, :43, :44, :45, ';
   ELSE
      v_nSql := v_nSql || ' 0,:35, 1, 0,:36, 1, 1, 1, ';
   END IF;
   --JIRA 29954 knarka ends
   v_nSql := v_nSql || '0, 0, 0, 0, 0, 0,:37, :38';
   --JIRA 38951 knakra starts
   IF v_iRetVal = 1 THEN
      IF v_vDistTypeSCode = 'EFT' THEN
         v_nSql := v_nSql || ', -1';
      ELSE
         v_nSql := v_nSql || ', 0';
      END IF;
   END IF;
   --JIRA 38951 knakra ends
   --asharma590 jira 61578
   IF (v_fVersionNum >= 19.1) THEN
		--IF v_iReadyToPrtFlag :=1 THEN
		v_nSql := v_nSql || ', :46';
		--END IF;
   END IF;
   --asharma590 jira 61578
   v_nSql := v_nSql || ')';

   IF v_vPAYEE_STATE IS NULL THEN
      v_iStateRowId := NULL;
   ELSE
      v_iStateRowId:= v_iStateRowId;
   END IF;

  IF v_vCHECK_STATUS <> 'V' THEN
      IF v_iClearedFlag = 1 THEN
         v_vDATE_CLEARED := v_vDATE_CLEARED;
         v_vVOID_CODE_REASON := NULL;
      ELSE
         v_vDATE_CLEARED := NULL;
         v_vVOID_CODE_REASON := NULL;
      END IF;
   ELSE
      IF v_vCHECK_STATUS = 'V' THEN
         v_vDATE_CLEARED := v_vDATE_CLEARED;
         v_vVOID_CODE_REASON := v_vVOID_CODE_REASON;
      END IF;
   END IF;

   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 THEN
      IF v_fVersionNum >= 16.4 THEN
		IF v_fVersionNum >= 19.1 THEN
			EXECUTE IMMEDIATE v_nSql using v_iTransid, v_iClaimId, v_vCLAIM_ID, v_vACTIVITY_DATE, v_vTRANSACTION_DATE, v_vCHECK_NO, v_vPayToTheOrderOf, 0,
			v_iTransNumber, v_dBaseCurrAmt, v_iAccountId, v_iSubAccId, v_iChkStatCodeId, v_iPayeeTypeCodeId, v_iPayeeEid, v_vPAYEE_LASTNAME,
			v_vPAYEE_FIRSTNAME, v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_iStateRowId,v_vPAYEE_ZIP, v_iPayFlag, v_iColFlag, v_iVoidFlag, v_vSysDateTime,
			'DADDS', v_vSysDateTime, 'DADDS', v_vMEMO, v_iClearedFlag, v_vDATE_CLEARED,v_vVOID_CODE_REASON,v_iPmtCurCodeId,v_dPmtCurrAmt,
			v_iClmCurCodeId, v_dClmCurrAmt, v_iPolCurCodeId, v_dPolCurrAmt,
			v_iResSuppPaymentFlag, v_iDistTypeCodeId, v_iReadyToPrtFlag ;
		ELSE
			EXECUTE IMMEDIATE v_nSql using v_iTransid, v_iClaimId, v_vCLAIM_ID, v_vACTIVITY_DATE, v_vTRANSACTION_DATE, v_vCHECK_NO, v_vPayToTheOrderOf, 0,
			v_iTransNumber, v_dBaseCurrAmt, v_iAccountId, v_iSubAccId, v_iChkStatCodeId, v_iPayeeTypeCodeId, v_iPayeeEid, v_vPAYEE_LASTNAME,
			v_vPAYEE_FIRSTNAME, v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_iStateRowId,v_vPAYEE_ZIP, v_iPayFlag, v_iColFlag, v_iVoidFlag, v_vSysDateTime,
			'DADDS', v_vSysDateTime, 'DADDS', v_vMEMO, v_iClearedFlag, v_vDATE_CLEARED,v_vVOID_CODE_REASON,v_iPmtCurCodeId,v_dPmtCurrAmt,
			v_iClmCurCodeId, v_dClmCurrAmt, v_iPolCurCodeId, v_dPolCurrAmt,
			v_iResSuppPaymentFlag, v_iDistTypeCodeId ;
		END IF;
      ELSE
         EXECUTE IMMEDIATE v_nSql using v_iTransid, v_iClaimId, v_vCLAIM_ID, v_vACTIVITY_DATE, v_vTRANSACTION_DATE, v_vCHECK_NO, v_vPayToTheOrderOf, 0,
         v_iTransNumber, v_dBaseCurrAmt, v_iAccountId, v_iSubAccId, v_iChkStatCodeId, v_iPayeeTypeCodeId, v_iPayeeEid, v_vPAYEE_LASTNAME,
         v_vPAYEE_FIRSTNAME, v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_iStateRowId,v_vPAYEE_ZIP, v_iPayFlag, v_iColFlag, v_iVoidFlag, v_vSysDateTime,
         'DADDS', v_vSysDateTime, 'DADDS', v_vMEMO, v_iClearedFlag, v_vDATE_CLEARED,v_vVOID_CODE_REASON,
         v_dBaseCurrAmt, v_dBaseCurrAmt, v_iResSuppPaymentFlag, v_iDistTypeCodeId ;
      END IF;
   ELSE
	  EXECUTE IMMEDIATE v_nSql using v_iTransid, v_iClaimId, v_vCLAIM_ID, v_vACTIVITY_DATE, v_vTRANSACTION_DATE, v_vCHECK_NO, v_iClaimantEid, v_iVehicleId, v_vPayToTheOrderOf, 0,
      v_iTransNumber, v_dBaseCurrAmt, v_iAccountId, v_iSubAccId, v_iChkStatCodeId, v_iPayeeTypeCodeId, v_iPayeeEid, v_vPAYEE_LASTNAME,
      v_vPAYEE_FIRSTNAME, v_vPAYEE_ADDRESS,v_vPAYEE_CITY,v_iStateRowId,v_vPAYEE_ZIP, v_iPayFlag, v_iColFlag, v_iVoidFlag, v_vSysDateTime,
      'DADDS', v_vSysDateTime, 'DADDS', v_vMEMO, v_iClearedFlag, v_vDATE_CLEARED,v_vVOID_CODE_REASON,
      v_dBaseCurrAmt, v_dBaseCurrAmt, v_iResSuppPaymentFlag, v_iDistTypeCodeId ;
   END IF;
    --JIRA 23831 knakra ends

   v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID+ 1 WHERE SYSTEM_TABLE_NAME = :1';

   EXECUTE IMMEDIATE v_nSql USING 'FUNDS';


   v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

   BEGIN
      EXECUTE IMMEDIATE v_nSql into v_iPayeeRowId USING 'FUNDS_X_PAYEE';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
   v_iPayeeRowId:=0;
   END;

   v_nSql := 'INSERT INTO ' || v_vDbName || 'FUNDS_X_PAYEE(PAYEE_ROW_ID, FUNDS_TRANS_ID,PAYEE_1099_FLAG,PAYEE_TYPE_CODE,PAYEE_EID,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,';
   v_nSql := v_nSql || 'ADDED_BY_USER, UPDATED_BY_USER';
   v_nSql := v_nSql || ') VALUES(:1, :2, 0, :3, :4, :5, :6, :7, :8)';

   EXECUTE IMMEDIATE v_nSql USING v_iPayeeRowId ,v_iTransid,v_iPayeeTypeCodeId,v_iPayeeEid,v_vSysDateTime,v_vSysDateTime,'DADDS','DADDS'  ;

   v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID+ 1 WHERE SYSTEM_TABLE_NAME = :1';

   EXECUTE IMMEDIATE v_nSql USING 'FUNDS_X_PAYEE';


   v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

   BEGIN
      EXECUTE IMMEDIATE v_nSql into v_iSplitRowId USING 'FUNDS_TRANS_SPLIT';
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
   v_iSplitRowId:=0;
   END;

   IF v_vTRANSACTION_TYPE = 'C' THEN
      v_dSumAmount := -v_dBaseCurrAmt;
   ELSE
      v_dSumAmount := v_dBaseCurrAmt;
   END IF;

   --SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');;
   V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

   --JIRA 23831 knakra starts
   v_nSql := 'INSERT INTO ' || v_vDbName || 'FUNDS_TRANS_SPLIT(SPLIT_ROW_ID,RC_ROW_ID,';
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || 'POLCVG_ROW_ID ,RESERVE_TYPE_CODE,';
   END IF;
   --JIRA 23831 knakra ends
   v_nSql := v_nSql || 'TRANS_ID,TRANS_TYPE_CODE,AMOUNT,FROM_DATE,TO_DATE,SUM_AMOUNT,INVOICE_NUMBER,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,';
   --JIRA 29954 knakra starts
   v_nSql := v_nSql || 'UPDATED_BY_USER, SUPP_PAYMENT_FLAG,PMT_CURRENCY_AMOUNT,';
   IF v_fVersionNum < 16.4 THEN
      v_nSql := v_nSql || 'PMT_CURRENCY_INVOICE_AMOUNT,';
   END IF;
   v_nSql := v_nSql || 'PMT_CURRENCY_AUTO_DISCOUNT,CLAIM_CURRENCY_AMOUNT,';
   IF v_fVersionNum < 16.4 THEN
      v_nSql := v_nSql || 'CLAIM_CURRENCY_INVOICE_AMOUNT,';
   END IF;
   v_nSql := v_nSql || 'CLAIM_CURRENCY_AUTO_DISCOUNT,POLICY_SYSTEM_ID,WITHHOLDING_SPLIT_FLAG';

   IF v_fVersionNum >= 16.4 THEN
      v_nSql := v_nSql || ', POLICY_CURRENCY_AMOUNT, PMT_TO_BASE_CUR_RATE, PMT_TO_CLAIM_CUR_RATE, PMT_TO_POLICY_CUR_RATE';
   END IF;
   --JIRA 29954 knakra ends
   --JIRA 23831 knakra starts
   v_nSql := v_nSql || ') VALUES(:1, :2, ';
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || ':3, :4, ';
   END IF;
   v_nSql := v_nSql || ':5, :6, :7, :8,';
   --JIRA 23831 knakra ends
   v_nSql := v_nSql || ':9, :10, :11, :12, :13, :14, :15, 0,:16,';
   --JIRA 29954 knakra starts
   IF v_fVersionNum < 16.4 THEN
      v_nSql := v_nSql || ' :17, ';
   END IF;
   v_nSql := v_nSql || '0, :18, ';
   IF v_fVersionNum < 16.4 THEN
      v_nSql := v_nSql || ':19, ';
   END IF;
   v_nSql := v_nSql || '0, :20, 0';
   IF v_fVersionNum >= 16.4 THEN
      v_nSql := v_nSql || ', ' || v_dPolCurrAmt || ',' || v_iPmtToBaseRate || ',' || v_iPmtToClmRate || ',' || v_iPmtToPolRate;
   END IF;
   --JIRA 29954 knakra ends
   v_nSql := v_nSql || ')';

   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 THEN
      --JIRA 29954 knakra starts
      IF v_fVersionNum >= 16.4 THEN
         EXECUTE IMMEDIATE v_nSql USING v_iSplitRowId, v_iRcRowId, v_iTransid, v_iTransTypeCodeId, v_dBaseCurrAmt, v_vSERVICE_FROM_DATE,
         v_vSERVICE_TO_DATE, v_dSumAmount, v_vINVOICE_NUMBER, v_vSysDateTime, 'DADDS', v_vSysDateTime, 'DADDS', v_dPmtCurrAmt, v_dClmCurrAmt, v_iPolSysId;
      ELSE
         EXECUTE IMMEDIATE v_nSql USING v_iSplitRowId, v_iRcRowId, v_iTransid, v_iTransTypeCodeId, v_dBaseCurrAmt, v_vSERVICE_FROM_DATE,
         v_vSERVICE_TO_DATE, v_dSumAmount, v_vINVOICE_NUMBER, v_vSysDateTime, 'DADDS', v_vSysDateTime, 'DADDS', v_dBaseCurrAmt, v_dBaseCurrAmt, v_dBaseCurrAmt, v_dBaseCurrAmt, v_iPolSysId;
      END IF;
      --JIRA 29954 knakra ends
   ELSE
      EXECUTE IMMEDIATE v_nSql USING v_iSplitRowId, v_iRcRowId, v_iPolCvgRowId, v_iResTypeCodeId, v_iTransid, v_iTransTypeCodeId, v_dBaseCurrAmt, v_vSERVICE_FROM_DATE,
      v_vSERVICE_TO_DATE, v_dSumAmount, v_vINVOICE_NUMBER, v_vSysDateTime, 'DADDS', v_vSysDateTime, 'DADDS', v_dBaseCurrAmt, v_dBaseCurrAmt, v_dBaseCurrAmt, v_dBaseCurrAmt, v_iPolSysId;
   END IF;
   --JIRA 23831 knakra ends
   v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

   EXECUTE IMMEDIATE v_nSql USING 'FUNDS_TRANS_SPLIT';

   --JIRA 24633 knakra starts
   IF iHmiFlag = 1 AND v_vRECORD_TYPE = 'H' THEN
     iCountLoop := 1;
     WHILE iCountLoop <= 5
     LOOP
       IF iCountLoop = 1 THEN
         v_iCodeId := iEobCodeId1;
       ELSIF iCountLoop = 2 THEN
         v_iCodeId := iEobCodeId2;
       ELSIF iCountLoop = 3 THEN
         v_iCodeId := iEobCodeId3;
       ELSIF iCountLoop = 4 THEN
         v_iCodeId := iEobCodeId4;
       ELSIF iCountLoop = 5 THEN
         v_iCodeId := iEobCodeId5;
       END IF;

       IF v_iCodeId IS NOT NULL AND v_iCodeId > 0 THEN
         v_nSql := 'INSERT INTO ' || v_vDbName || 'FTS_X_REMARKS(SPLIT_ROW_ID, EOB_REMARKS_CODE';
         v_nSql := v_nSql || ') VALUES(';
         v_nSql := v_nSql || ':1, :2';
         v_nSql := v_nSql || ')';

         EXECUTE IMMEDIATE v_nSql USING v_iSplitRowId, v_iCodeId;
       END IF;
       iCountLoop := iCountLoop + 1;
     END LOOP;
   END IF;
   --JIRA 24633 knakra ends

    IF v_oRecalReserves <> 0 THEN
    -- KAPIL NEED TO CHECK THIS
      DDS_RESERVE_REBAL(v_iClaimId,
                        v_iClaimantEid,
                        v_iREsTypeCodeid,
                        v_iRcRowId,
						v_vTRANSACTION_TYPE,--udoni 64208
                        v_vACTIVITY_DATE,
                        v_iCarrierFlag,
                        v_vDbName,
                        v_P_JOBID,
                        v_iDA_ROW_ID,
                        v_vCLAIM_ID,
                        iVarFinKey, --JIRA 23831 knakra
                        v_iResSubTypeCodeId,     --JIRA 23831 knakra
                        iHmiFlag,                --JIRA 24633 knakra
                        v_vBEN_REVIEW_DATE,      --JIRA 24633 knakra
                        iClaimMCFields,          --JIRA 28198 knakra starts
                        iRsvMCFields,
                        iPolMCFields,            --JIRA 28198 knakra ends
                        v_iClmCurCodeId,
                        v_iPolCurCodeId,
                        v_iClmToBaseRate,
                        v_iClmToPolRate,
                        v_fVersionNum,
                        v_iReBalErrCnt,
						v_dBaseCurrAmt,         ---akumar523 starts 
						v_dPolCurrAmt,
						v_dClmCurrAmt,		
						v_vCheckStatus);		---akumar523 ends
   END IF;

   v_vLocation := 'SuppIns';

   IF v_oFundSupp > 0 THEN
      DDS_SUPPLEMENT(v_p_JOBID,
                     v_oConfigId,
                     v_p_UserId,
                     'PAYMENT',
                     v_vDbName,
                     v_iDA_ROW_ID,
                     v_oAllowNewCodes,
                     0,
                     v_iErrCnt,
                     'I',
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     v_iTransid,
                     0,
                     0,
                     0,
                     'CLAIM_ID',
                     v_vCLAIM_ID,
                     v_iErrCntSupp);
   END IF;

   IF v_iReBalErrCnt = 0 OR v_iReBalErrCnt IS NULL THEN

         EXECUTE IMMEDIATE 'UPDATE DDS_PAYMENT SET INVALID_ROW = 0  WHERE JOBID = :1 AND DA_ROW_ID = :2' USING v_P_JOBID , v_iDA_ROW_ID;
     COMMIT;

   END IF;


      EXCEPTION
         WHEN OTHERS THEN
               v_vErrMsgDesc := SQLERRM;
               ROLLBACK;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     'PAYMENT',
                                     'PayIns',
                                     'PayIns',
                                     'DDS_PROCESS_PAYMENT',
                                     v_vErrMsgDesc,
                                     'CLAIM_ID',
                                     'DDS_PAYMENT',
                                     'CLAIM_ID',
                                     v_vCLAIM_ID,
                                     0);
               v_iErrCnt := v_iErrCnt + 1;
      END;
   ELSE
      IF v_vTRANSACTION_TYPE = 'R' AND v_iBaseErr = 0 AND v_iErrCnt = 0 THEN
         BEGIN
            v_nSql := 'SELECT RC_ROW_ID FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE ';
            v_nSql := v_nSql || 'CLAIM_ID = :1 AND CLAIMANT_EID = :2 AND RESERVE_TYPE_CODE = :3';
          --  v_nSql := v_nSql || ' AND POLCVG_LOSS_ROW_ID = :4 AND UNIT_ID = :5'; asharma590 jira RMA-65679
		  v_nSql := v_nSql || ' AND POLCVG_LOSS_ROW_ID = :4';
            --JIRA 23831 knakra starts
            IF iVarfinKey <> 0 THEN
              IF iIncRsvSubType <> 0 THEN
                v_nSql := v_nSql || ' AND RESERVE_CATEGORY = ' || v_iResSubTypeCodeId;
              END IF;
              IF iIncClaimant = 0 THEN
                 v_iClaimantEid := 0;
                 v_iVehicleId := 0;
              END IF;
              IF iIncPolCvg = 0 THEN
                v_iCvgLossRowId := 0;
              END IF;
            END IF;
            --JIRA 23831 knarka ends
          BEGIN
            --EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId USING v_iClaimId, v_iClaimantEid,v_iResTypeCodeId,v_iCvgLossRowId, v_iVehicleId;
			EXECUTE IMMEDIATE v_nSql INTO v_iRcRowId USING v_iClaimId, v_iClaimantEid,v_iResTypeCodeId,v_iCvgLossRowId; --- asharma590 jira RMA-65679
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_iRcRowId:= 0;
            END;


      IF v_iRcRowId IS NULL OR v_iRcRowId = 0 THEN
   BEGIN
      --JIRA 29954 knakra starts
      IF v_fVersionNum >= 16.4 THEN
         v_iRsvUpdFlag := 0;
      END IF;
      v_iActivityType := 1;  --knakra activity track
      v_iReBalErrCnt := 0;
      --KAPIL NEED TO CHECK THIS
      DDS_PROCESS_RES_CUR_NT_FOUND(v_iClaimId,
                                     v_iClaimantEid,
                                     v_iVehicleId,
                                     v_iLob,
                                     v_iResTypeCodeId,
                                     v_dBaseCurrAmt,
                                     v_iResStatusCodeId,
                                     0,
                                     v_vACTIVITY_DATE,
                                     v_iCvgLossRowid,
                                     v_iPolCvgRowId,
                                     v_vPOLICY_CVG_SEQNO,
                                     v_vDbName,
                                     v_P_JOBID,
                                     v_iDA_ROW_ID,
                                     v_vCLAIM_ID,
                                     iVarfinKey,     --JIRA 23831 knakra
                                     v_iResSubTypeCodeId,   --JIRA 23831 knakra
                                     iHmiFlag,              --JIRA 24633 knakra
                                     v_vBEN_REVIEW_DATE,    --JIRA 24633 knakra
                                     iClaimMCFields,        --JIRA 28198 knakra starts
                                     iRsvMCFields,
                                     iPolMCFields,          --JIRA 28198 knakra ends
                                     v_dClmCurrAmt,         --JIRA 29954 knakra starts
                                     v_dPolCurrAmt,
                                     v_iClmToBaseRate,
                                     v_iClmToPolRate,
                                     v_fVersionNum,
                                     v_iClmCurCodeId,
                                     v_iPolCurCodeId,       --JIRA 29954 knakra ends
                                     v_iRcRowId,
                                     v_iReBalErrCnt);

      IF v_iReBalErrCnt <> 0 THEN
         v_vErrMsgDesc := SQLERRM;
         v_iErrCnt := v_iErrCnt + 1;
         GOTO NEXTRECORD;
      END IF;

      v_nSql := 'SELECT  C1.SHORT_CODE FROM ' || v_vDbName || 'CODES C1, ' || v_vDbName || 'CODES C2 WHERE';
      v_nSql := v_nSql || ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = :1';


      BEGIN
        EXECUTE IMMEDIATE v_nSql INTO v_vResCatShortCode USING v_iResTypeCodeId;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_vResCatShortCode:= 0;
        END;

      --JIRA 29954 knakra starts
      v_fChangeAmt := v_dBaseCurrAmt;
      v_dBaseCurrBalAmt := v_dBaseCurrAmt;
      v_dBaseCurrColTot := 0.00;
      v_dBaseCurrPaidTot := 0.00;
      v_dClmCurrChgAmt := v_dClmCurrAmt;    --- JIRA 37552
      v_dClmCurrBalAmt := v_dClmCurrAmt;     --- JIRA 37552
      v_dPolCurrChgAmt := v_dPolCurrAmt;     --- JIRA 37552
      v_dPolCurrBalAmt := v_dPolCurrAmt;     --- JIRA 37552
      IF v_fVersionNum >= 16.4 THEN
        v_dClmCurrChgAmt := v_dClmCurrAmt;
        v_dClmCurrBalAmt := v_dClmCurrAmt;
        v_dClmCurrPaidTot := 0.0;
        v_dClmCurrColTot := 0.0;
        v_dPolCurrChgAmt := v_dPolCurrAmt;
        v_dPolCurrBalAmt := v_dPolCurrAmt;
        v_dPolCurrPaidTot := 0.0;
        v_dPolCurrColTot := 0.0;
      END IF;
      IF v_vResCatShortCode = 'R' THEN
         --v_fInccurAmt := 0;
         v_dBaseCurrAmt := 0.0;
         IF v_fVersionNum >= 16.4 THEN
            v_dClmCurrIncAmt := 0.0;
            v_dPolCurrIncAmt := 0.0;
         END IF;
      ELSE
         --v_fInccurAmt := v_fAMOUNT;
         v_dBaseCurrIncAmt := v_dBaseCurrAmt;
         v_dClmCurrIncAmt := v_dClmCurrAmt; -- JIRA 37552
         v_dPolCurrIncAmt := v_dPolCurrAmt; -- JIRA 37552
         IF v_fVersionNum >= 16.4 THEN
            v_dClmCurrIncAmt := v_dClmCurrAmt;
            v_dPolCurrIncAmt := v_dPolCurrAmt;
         END IF;
      END IF;

   END;
   ELSE
      v_iActivityType := 0;  --knakra activity track
      V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

      v_nSql := 'UPDATE ' || v_vDbName || 'RESERVE_CURRENT SET ';
      v_nSql := v_nSql || 'RESERVE_AMOUNT = :1,';
      v_nSql := v_nSql || 'BALANCE_AMOUNT = :2, ';
      v_nSql := v_nSql || 'PAID_TOTAL = :3, ';
      v_nSql := v_nSql || 'COLLECTION_TOTAL = :4, ';
      v_nSql := v_nSql || 'INCURRED_AMOUNT = :5, ';
      v_nSql := v_nSql || 'RES_STATUS_CODE = :6, ';
      v_nSql := v_nSql || 'DATE_ENTERED = :7, ';
      v_nSql := v_nSql || 'UPDATED_BY_USER = ''DADDS'', ';
      v_nSql := v_nSql || 'DTTM_RCD_LAST_UPD = :8';
      --JIRA 29954 knakra starts
      IF v_fVersionNum >= 16.4 THEN
         v_nSql := v_nSql || ', CLAIM_CURRENCY_RESERVE_AMOUNT = :10';
         v_nSql := v_nSql || ', CLAIM_CURRENCY_INCURRED_AMOUNT = :11';
         v_nSql := v_nSql || ', CLAIM_CURR_COLLECTION_TOTAL = :12';
         v_nSql := v_nSql || ', CLAIM_CURRENCY_PAID_TOTAL = :13';
         v_nSql := v_nSql || ', CLAIM_CURRENCY_BALANCE_AMOUNT = :14';
         v_nSql := v_nSql || ', POLICY_CURR_RESERVE_AMOUNT = :15';
         v_nSql := v_nSql || ', POLICY_CURR_INCURRED_AMOUNT = :16';
         v_nSql := v_nSql || ', POLICY_CURR_COLLECTION_TOTAL = :17';
         v_nSql := v_nSql || ', POLICY_CURR_PAID_TOTAL = :18';
         v_nSql := v_nSql || ', POLICY_CURRENCY_BALANCE_AMOUNT = :19';
      END IF;

      --JIRA 29954 knarka ends
      v_nSql := v_nSql || ' WHERE RC_ROW_ID = :9';

      --JIRA 29954 knakra starts
      IF v_fVersionNum >= 16.4 THEN
         EXECUTE IMMEDIATE v_nSql USING v_dBaseCurrAmt,v_dBaseCurrBalAmt, v_dBaseCurrPaidTot,v_dBaseCurrColTot,v_dBaseCurrIncAmt ,v_iResStatusCodeId,v_vACTIVITY_DATE,v_vSysDateTime, v_dClmCurrAmt, v_dClmCurrIncAmt, v_dClmCurrColTot, v_dClmCurrPaidTot, v_dClmCurrBalAmt, v_dPolCurrAmt, v_dPolCurrIncAmt, v_dPolCurrColTot, v_dPolCurrPaidTot, v_dPolCurrBalAmt,v_iRcRowId;
      ELSE
         EXECUTE IMMEDIATE v_nSql USING v_dBaseCurrAmt,v_dBaseCurrBalAmt, v_dBaseCurrPaidTot,v_dBaseCurrColTot,v_dBaseCurrIncAmt ,v_iResStatusCodeId,v_vACTIVITY_DATE,v_vSysDateTime,v_iRcRowId;
      END IF;
      --JIRA 29954 knakra ends
   END IF;

   v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

      BEGIN
        EXECUTE IMMEDIATE v_nSql INTO v_iRsvRowId USING 'RESERVE_HISTORY';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_iRsvRowId:= 0;
        END;


   V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');
   --JIRA 23831 knakra starts
   v_nSql := 'INSERT INTO ' || v_vDbName || 'RESERVE_HISTORY(RSV_ROW_ID,';
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || 'POLCVG_ROW_ID,';
   END IF;
   v_nSql := v_nSql || 'POLCVG_LOSS_ROW_ID,CLAIM_ID,UNIT_ID,CLAIMANT_EID,RESERVE_TYPE_CODE,';
   --JIRA 23831 knakra ends
   v_nSql := v_nSql || 'DATE_ENTERED,REASON,POLICY_CVG_SEQNO,PAID_TOTAL,COLLECTION_TOTAL,RESERVE_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,RESERVE_CATEGORY,APPROVER_ID, ';
   v_nSql := v_nSql || 'ONHOLD_RSV_ROW_ID,DTTM_RCD_ADDED,INCURRED_AMOUNT, ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,ENTERED_BY_USER,RES_STATUS_CODE';
   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 THEN
     v_nSql := v_nSql || ', RC_ROW_ID';
   END IF;
   --JIRA 24633 knarka starts
   IF v_vRECORD_TYPE = 'H' AND iHmiFlag = 1 AND v_vBEN_REVIEW_DATE IS NOT NULL THEN
     v_nSql := v_nSql || ', BEN_REVIEW_DATE';
   END IF;
   --JIRA 24633 knakra ends

   --JIRA 28198 knakra starts
   IF iClaimMCFields = 1 THEN
     v_nSql := v_nSql || ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT';
     --JIRA 29954 kankra starts
     --v_nSql := v_nSql || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE';
     v_nSql := v_nSql || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT';
     IF v_fVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', BASE_TO_CLAIM_CUR_RATE';
     ELSIF v_fVersionNum >= 16.4 THEN
        v_nSql := v_nSql || ', CLAIM_CURR_CHANGE_AMOUNT';
     END IF;
     --JIRA 29954 knakra ends
   END IF;

   IF iRsvMCFields = 1 THEN
     v_nSql := v_nSql || ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE';
     v_nSql := v_nSql || ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT';
   END IF;

   IF iPolMCFields = 1 THEN
     --JIRA 29954 knakra starts
     --v_nSql := v_nSql || ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT';
     --v_nSql := v_nSql || ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE';
     v_nSql := v_nSql || ', POLICY_CURR_CODE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT, POLICY_CURR_COLLECTION_TOTAL, ';
     v_nSql := v_nSql || 'POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, ';
     IF v_fVersionNum < 16.4 THEN
        v_nSql := v_nSql || 'POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE';
     ELSIF v_fVersionNum >= 16.4 THEN
        v_nSql := v_nSql || 'CLAIM_TO_POLICY_CUR_RATE, POLICY_CURR_CHANGE_AMOUNT';
     END IF;
     --JIRA 29954 knakra ends
   END IF;
   --JIRA 28198 knakra ends

   v_nSql := v_nSql || ') VALUES(:1, ';
   IF iVarfinKey = 0 THEN
      v_nSql := v_nSql || ':2, ';
   END IF;
   v_nsql := v_nSql || ':3, :4, :5, :6, :7,';
   --JIRA 23831 knakra ends
   v_nSql := v_nSql || ':8, :9, :10, :11, :12, :13, :14, :15, :16, :17,';
   v_nSql := v_nSql || ':18, :19, :20, :21, :22, :23, :24, :25';
   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 THEN
     v_nSql := v_nSql || ', :26';
   END IF;
   --JIRA 23831 knakra ends
   --JIRA 24633 knakra starts
   IF v_vRECORD_TYPE = 'H' AND iHmiFlag = 1 AND v_vBEN_REVIEW_DATE IS NOT NULL THEN
     v_nSql := v_nSql || ', ''' || v_vBEN_REVIEW_DATE || '''';
   END IF;
   --JIRA 24633 knakra ends

   --JIRA 28198 knakra starts
   IF iClaimMCFields = 1 THEN
     --JIRa 29954 knakra starts
     v_nSql := v_nSql || ',' || v_iClmCurCodeId || ',' || v_iClmToBaseRate || ', ' || v_dClmCurrAmt || ', ' || v_dClmCurrIncAmt || ', ' || v_dClmCurrColTot || ', ' || v_dClmCurrPaidTot || ', ' || v_dClmCurrBalAmt;
     IF v_fVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', 1';
     ELSIF v_fVersionNum >= 16.4 THEN
        v_nSql := v_nSql || ', ' || v_dClmCurrChgAmt || '';
     END IF;
     --JIRA 29954 knakra ends
   END IF;

   IF iRsvMCFields = 1 THEN
     v_nSql := v_nSql || ', 0, 1, ' || v_dBaseCurrAmt || ', 1, 1, ' || v_dBaseCurrPaidTot || ', ' || v_dBaseCurrBalAmt || ', ' || v_dBaseCurrColTot || ', ' || v_dBaseCurrIncAmt;
   END IF;

   IF iPolMCFields = 1 THEN
     --JIRA 29954 knakra starts
     --v_nSql := v_nSql || ', 0, 1, ' || v_fAMOUNT || ', ' || v_fInccurAmt || ', ' || v_fColTot || ', ' || v_fPaidTot || ', ' || v_fResBal || ', 1';
     v_nSql := v_nSql || ', ' || v_iPolCurCodeId || ', ' || v_dPolCurrAmt || ',' || v_dPolCurrIncAmt || ', ' || v_dPolCurrColTot || ', ' || v_dPolCurrPaidTot || ', ' || v_dPolCurrBalAmt;
     IF v_fVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', 1, 1';
     ELSIF v_fVersionNum >= 16.4 THEN
        v_nSql := v_nSql || ', ' || v_iClmToPolRate || ', ' || v_dPolCurrChgAmt || '';
     END IF;
     --JIRA 29954 knakra ends
   END IF;
   --JIRA 28198 knakra ends

   v_nSql := v_nSql || ')';

   --JIRA 23831 knakra starts
   IF iVarfinKey <> 0 THEN
       EXECUTE IMMEDIATE v_nSql USING
               v_iRsvRowId,
               v_iCvgLossRowId,
               v_iClaimId,
               v_iVehicleId,
               v_iClaimantEid,
               v_iResTypeCodeId,
               v_vACTIVITY_DATE,
               'DA DDS PAYMENT',
               v_vPOLICY_CVG_SEQNO,
               v_dBaseCurrPaidTot,
               v_dBaseCurrColTot,
               v_dBaseCurrAmt,
               v_dBaseCurrBalAmt,
               v_fChangeAmt,
               v_iResSubTypeCodeId,
               0,
               0,
               v_vSysDateTime,
               v_dBaseCurrIncAmt,
               'DADDS',
               v_vSysDateTime,
               'DA DDS',
               'DA DDS',
               v_iResStatusCodeId,
               v_iRcRowId;
   ELSIF iVarfinKey = 0 THEN
       EXECUTE IMMEDIATE v_nSql USING
               v_iRsvRowId,
               v_iPolCvgRowId,
               v_iCvgLossRowId,
               v_iClaimId,
               v_iVehicleId,
               v_iClaimantEid,
               v_iResTypeCodeId,
               v_vACTIVITY_DATE,
               'DA DDS PAYMENT',
               v_vCVG_SEQUENCE_NO,
               v_dBaseCurrPaidTot,
               v_dBaseCurrColTot,
               v_dBaseCurrAmt,
               v_dBaseCurrBalAmt,
               v_fChangeAmt,
               v_iResSubTypeCodeId,
               0,
               0,
               v_vSysDateTime,
               v_dBaseCurrIncAmt,
               'DADDS',
               v_vSysDateTime,
               'DA DDS',
               'DA DDS',
               v_iResStatusCodeId;
   END IF;
   v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID =NEXT_UNIQUE_ID+ 1 WHERE SYSTEM_TABLE_NAME = :1';

   EXECUTE IMMEDIATE v_nSql USING 'RESERVE_HISTORY';

   EXECUTE IMMEDIATE 'UPDATE DDS_PAYMENT SET INVALID_ROW = 0 WHERE JOBID = :1  AND DA_ROW_ID = :2' USING v_P_JOBID,v_iDA_ROW_ID;



 --knakra activity track starts
   --IF v_vTRANSACTION_TYPE IN ( 'P','C','R' ) AND v_iBaseErr = 0 AND v_iErrCnt = 0 AND v_iCarrierFlag <> 0 THEN JIRA 23831 knarka
   IF v_vTRANSACTION_TYPE IN ( 'P','C','R' ) AND v_iBaseErr = 0 AND v_iErrCnt = 0 AND ((v_iCarrierFlag <> 0 AND iVarfinKey = 0) OR (iVarfinKey <> 0 AND iIncPolCvg <> 0)) THEN   --JIRA 23831 knarka
            --v_vSysDateTime := REPLACE(REPLACE(REPLACE(sqlserver_utilities.convert_('VARCHAR2(19)', SYSDATE, 126), '-', ''), 'T', ''), ':', '');

            V_vSysDateTime := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS');

         BEGIN
            v_nSql := 'SELECT TABLE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ';

            IF v_vTRANSACTION_TYPE = 'R' THEN
               v_nSql := v_nSql || '''RESERVE_CURRENT''';
            ELSE
               IF v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN
                  v_nSql := v_nSql || '''FUNDS''';
               END IF;
            END IF;

            v_vLocation := 'TableIdAt';

            EXECUTE IMMEDIATE v_nSql INTO v_iTableId;

            v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';

            v_vLocation := 'NxtIdAt';

            EXECUTE IMMEDIATE v_nSql INTO v_iActivityRowId USING 'ACTIVITY_TRACK';


           /* v_nSql := 'INSERT INTO ' || v_vDbName || 'ACTIVITY_TRACK(ACTIVITY_ROW_ID,CLAIM_ID,FOREIGN_TABLE_ID,FOREIGN_TABLE_KEY,UPLOAD_FLAG,DTTM_RCD_ADDED';
            v_nSql := v_nSql || ',ADDED_BY_USER,CHECK_BATCH_ID,POLICY_SYSTEM_ID,IS_UPDATED,ACTIVITY_TYPE,ACCOUNT_ID,RESERVE_AMOUNT,RESERVE_STATUS';
            v_nSql := v_nSql || ',CHANGE_AMOUNT,CHECK_STATUS,VOID_FLAG,IS_COLLECTION) VALUES(:1, :2, :3, :4, :5,:6,';
            v_nSql := v_nSql || ':7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18)';*/ --commented by 25298
            --added user and time stamp field in activity track for 16.2
            v_nSql := 'INSERT INTO ' || v_vDbName || 'ACTIVITY_TRACK(ACTIVITY_ROW_ID,CLAIM_ID,FOREIGN_TABLE_ID,FOREIGN_TABLE_KEY,UPLOAD_FLAG,DTTM_RCD_ADDED';
            v_nSql := v_nSql || ',ADDED_BY_USER,CHECK_BATCH_ID,POLICY_SYSTEM_ID,IS_UPDATED,ACTIVITY_TYPE,ACCOUNT_ID,RESERVE_AMOUNT,RESERVE_STATUS';
            v_nSql := v_nSql || ',CHANGE_AMOUNT,CHECK_STATUS,VOID_FLAG,IS_COLLECTION';
            IF v_fVersionNum >=16.2 THEN
                   v_nSql:= v_nSql ||',DTTM_RCD_LAST_UPD,UPDATED_BY_USER';--RMA-25298
            END IF;
            v_nSql:= v_nSql || ') VALUES (:1, :2, :3, :4, :5,:6,:7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18';
            IF v_fVersionNum >= 16.2 THEN   --RMA-25298
                        v_nSql:= v_nSql || ',:19, :20';
            END IF;
            v_nSql:= v_nSql || ')';

            IF v_vTRANSACTION_TYPE = 'R' THEN
               IF v_iActivityType = 1 THEN
                  DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                             'OC',
                                             'ACTIVITY_TYPE',
                                             v_oAllowNewCodes,
                                             v_vDbName,
                                             v_iLob,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'ActivityTrack',
                                             'DDS_PROCESS_PAYMENTS',
                                             'CLAIM_ID',
                                             'CLAIM_ID',
                                             'DDS_PAYMENT',
                                             v_vCLAIM_ID,
                                             v_iActivityCodeid);

               ELSE
                  IF v_iActivityType = 0 THEN
                     DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                                'RC',
                                                'ACTIVITY_TYPE',
                                                v_oAllowNewCodes,
                                                v_vDbName,
                                                v_iLob,
                                                v_iDA_ROW_ID,
                                                'PAYMENT',
                                                'ActivityTrack',
                                                'DDS_PROCESS_PAYMENTS',
                                                'CLAIM_ID',
                                                'CLAIM_ID',
                                                'DDS_PAYMENT',
                                                v_vCLAIM_ID,
                                                v_iActivityCodeid);
                  END IF;
               END IF;

               v_vLocation := 'InsAtRsv';

                        IF v_fVersionNum >= 16.2 THEN  ---RMA-25298
                                EXECUTE IMMEDIATE V_NSQL USING
                                v_iActivityRowId, v_iClaimId, v_iTableId, v_iRcRowId, 0, v_vSysDateTime,
                                'DDS', 0, v_iPolSysId, 0, v_iActivityCodeid, 0, v_dBaseCurrAmt, v_iResStatusCodeId, v_fChangeAmt, 0, 0, 0,
                                v_vSysDateTime,'DADDS';

                        ELSE
                                EXECUTE IMMEDIATE V_NSQL USING
                                v_iActivityRowId, v_iClaimId, v_iTableId, v_iRcRowId, 0, v_vSysDateTime,
                                'DDS', 0, v_iPolSysId, 0, v_iActivityCodeid, 0, v_dBaseCurrAmt, v_iResStatusCodeId, v_fChangeAmt, 0, 0, 0;
                        END IF;

            ELSE
               IF v_vTRANSACTION_TYPE IN ( 'P','C' ) THEN
                  IF v_iVoidFlag <> 0 THEN
                     v_iVoidFlagAt := -1;
                  ELSE
                     IF v_iVoidFlagAt = 0 THEN
                        v_iVoidFlagAt := 0;
                     END IF;
                  END IF;

                  IF v_iPayFlag <> 0 THEN
                     v_iIsCol := 0;
                  ELSE
                     IF v_iPayFlag = 0 THEN
                        v_iIsCol := -1;
                     END IF;
                  END IF;

                  DDS_CODE_VALIDATION_IMPORT(v_P_JOBID,
                                             'PP',
                                             'ACTIVITY_TYPE',
                                             v_oAllowNewCodes,
                                             v_vDbName,
                                             v_iLob,
                                             v_iDA_ROW_ID,
                                             'PAYMENT',
                                             'ActivityTrackFunds',
                                             'DDS_PROCESS_PAYMENTS',
                                             'CLAIM_ID',
                                             'CLAIM_ID',
                                             'DDS_PAYMENT',
                                             v_vCLAIM_ID,
                                             v_iActivityCodeid);

                  v_vLocation := 'InsAtFunds';

                                IF v_fVersionNum >= 16.2 THEN  ---RMA-25298
                                   EXECUTE IMMEDIATE V_NSQL USING
                                   v_iActivityRowId, v_iClaimId, v_iTableId, v_iRcRowId, 0, v_vSysDateTime,
                                   'DDS', 0, v_iPolSysId, 0, v_iActivityCodeid, 0, v_dBaseCurrAmt, v_iResStatusCodeId, v_fChangeAmt, 0, 0, 0,
                                   v_vSysDateTime,'DADDS';

                                ELSE
                                   EXECUTE IMMEDIATE V_NSQL USING
                                   v_iActivityRowId, v_iClaimId, v_iTableId, v_iTransid, 0, v_vSysDateTime,
                                   'DDS', 0, v_iPolSysId, 0, v_iActivityCodeid, v_iAccountId, 0, 0, 0, v_iChkStatCodeId, v_iVoidFlagAt, v_iIsCol;
                                END IF;

               END IF;

            END IF;

            v_vLocation := 'UpdGlsryAt';
            v_nSql := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';

            EXECUTE IMMEDIATE V_NSQL USING 'ACTIVITY_TRACK';
                        --knakra activity track ends
         EXCEPTION
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  ROLLBACK;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        v_vLocation,
                                        v_vLocation,
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);

                  v_iErrCnt := v_iErrCnt + 1;
                  --Insert Part Ends
         END;

   END IF;


   COMMIT;

         EXCEPTION
            WHEN OTHERS THEN
                  v_vErrMsgDesc := SQLERRM;
                  ROLLBACK;
                  DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                        v_iDA_ROW_ID,
                                        'PAYMENT',
                                        'ResIns',
                                        'ResIns',
                                        'DDS_PROCESS_PAYMENT',
                                        v_vErrMsgDesc,
                                        'CLAIM_ID',
                                        'DDS_PAYMENT',
                                        'CLAIM_ID',
                                        v_vCLAIM_ID,
                                        0);

                  v_iErrCnt := v_iErrCnt + 1;
                  --Insert Part Ends
         END;
      END IF;
   END IF;

   -- Kapil done till here 8-mar-2016
      <<NEXTRECORD>>

      ---Neha Running status code starts 33658---
      --DBMS_OUTPUT.put_LINE('neha_counter-->'||v_iRunStatCnt);
      v_vLocation := 'Running_Status';
      IF v_iRunStatCnt = 1 THEN
        BEGIN
          v_vProcessMsg := 'Total Number of Records processed in PAYMENTS : ' ||
                           v_iRunStatCnt;
          EXECUTE IMMEDIATE 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)'
            USING v_P_JOBID, v_vProcessMsg, 'PAYMENT_RUN', 'DDS_PAYMENT_RUN', -11;
        END;
      ELSIF v_iRunCnt = 1000 THEN
        BEGIN
            v_vProcessMsg := 'Total Number of Records processed in PAYMENTS : ' ||v_iRunStatCnt;
            v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND
            MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';

            EXECUTE IMMEDIATE v_nsql using v_vProcessMsg, v_P_JOBID, 'PAYMENT_RUN', 'DDS_PAYMENT_RUN';
            v_iRunCnt:=1;
          END;
       ELSIF (v_iCount=v_iRunStatCnt) THEN
              BEGIN
              v_vProcessMsg := 'Total Number of Records processed in PAYMENTS : ' ||v_iCount;
              v_nSql := 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =:1 WHERE JOBID = :2 AND
              MODULE_NAME =:3 AND TABLE_NAME=:4 AND DISPLAY_ORDER=-11';

             EXECUTE IMMEDIATE v_nsql using v_vProcessMsg, v_P_JOBID, 'PAYMENT_RUN', 'DDS_PAYMENT_RUN';
             END;
      END IF;
      commit;

      v_iRunStatCnt := v_iRunStatCnt + 1;
      v_iRunCnt := v_iRunCnt + 1;
      ---Neha running status code ends 33658---
       END LOOP;
       CLOSE CursorPay;

        DDS_PROCESS_LOG(v_P_JOBID,
                   'PAYMENT',
                   'DDS_PAYMENT');

EXCEPTION   WHEN OTHERS THEN
         v_vErrMsgDesc := SQLERRM;
         ROLLBACK;
         DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                               v_iDA_ROW_ID,
                               'PAYMENT',
                               'FetchNext',
                               'FetchNext',
                               'DDS_PROCESS_PAYMENT',
                               v_vErrMsgDesc,
                               'CLAIM_ID',
                               'DDS_PAYMENT',
                               'CLAIM_ID',
                               v_vCLAIM_ID,
                               0);
         v_iCurrentRow := v_iTotalRows + 1;
END;
END DDS_PROCESS_PAYMENTS;
