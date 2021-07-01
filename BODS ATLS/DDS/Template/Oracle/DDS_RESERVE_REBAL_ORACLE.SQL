CREATE OR REPLACE PROCEDURE DDS_RESERVE_REBAL
(
  v_iClaimId IN NUMBER,
  v_iClaimantEid IN NUMBER,
  v_iResTypeCode IN NUMBER,
  --v_iPolCvgLossRowId IN NUMBER,  commented by neha 03/11
  v_iRcRowId IN NUMBER,
  v_vTransType IN VARCHAR2,  --uncommented by udoni 64208 --commented by neha 03/11
  v_vTransDate IN VARCHAR2,
  v_iCarrierFlag IN NUMBER,
  v_vDbName IN VARCHAR2,
  v_iJOBID IN NUMBER, --neha 03/11
  v_iDA_ROW_ID IN NUMBER, --neha 03/11
  v_vCLAIM_ID IN VARCHAR2,--neha 03/11
  iVarFinKey IN NUMBER,          --JIRA 23831 knakra
  iResSubTypeCodeId IN NUMBER,   --JIRA 23831 knakra
  iHmiFlag IN NUMBER,            --JIRA 24633 knakra
  vBenReviewDate IN VARCHAR2,    --JIRA 24633 knakra
  iClaimMCFields IN NUMBER,      --JIRA 28198 knakra starts
  iRsvMCFields IN NUMBER,
  iPolMCFields IN NUMBER,        --JIRA 28198 knakra ends
  iClmCurCode IN NUMBER,         --JIRA 29954 knakra starts
  iPolCurCode IN NUMBER,
  dClmToBaseRate IN NUMBER,
  dClmToPolRate IN NUMBER,
  fVersionNum IN NUMBER,         --JIRA 29954 knakra ends
  v_iErrCnt OUT NUMBER, --neha 03/11
  dBaseCurrAmt IN NUMBER, 	  ---akumar523 starts 60666
  dPolCurrAmt IN NUMBER, 
  dClmCurrAmt IN NUMBER,
  vCheckStatus IN VARCHAR2    ---akumar523 ends  60666
)
AUTHID CURRENT_USER
AS
   v_vClaimStatus VARCHAR2(25);
   v_nSqlRes CLOB;
   v_dResAmt NUMBER(20,2) := 0.0;
   v_dIncAmt NUMBER(20,2)  := 0.0;
   v_dResBal NUMBER(20,2) := 0.0;
   v_dPaidTot NUMBER(20,2) := 0.0;
   v_dColTot NUMBER(20,2) := 0.0;
   v_nSqlPay CLOB;
   v_nSqlCol CLOB;
   v_iResStatus NUMBER(10,0);
   v_iPolCvgRowId NUMBER(10,0);
   v_iPolCvgSeqNum NUMBER(10,0);
   v_iDbRcRowId NUMBER(10,0);
   v_vParentRsv VARCHAR2(25);
   v_iAdjRsv NUMBER(10,0);
   v_iBalToZero NUMBER(10,0);
   v_iNegBalToZero NUMBER(10,0);
   v_iSetToZero NUMBER(10,0);
   v_dChangeAmt NUMBER(20,2);
   v_iAdjLog NUMBER(10,0);
   v_iDoNothing NUMBER(10,0);
   -- added by kapil
   v_iOResTypeCode NUMBER;
   v_iOClaimantEid NUMBER;
   --v_iOPolCvgLossRowId number;  --neha
   v_iPolCvgLossRowId number;  --neha
   ---kapil ends
   --added by neha starts here---
   v_iColInRsvBal NUMBER;
   v_iColInIncBal NUMBER;
   v_iRsvRowid NUMBER;
   v_TodayDate varchar2(14);
   v_vErrMsgDesc CLOB; --neha 03/11
   v_vLoc  CLOB; --neha 03/11
   ---added by neha ends here--
   --JIRA 29954 knakra starts
   nSqlCurr CLOB;
   dClmPaidTot NUMBER(20,2);
   dPolPaidTot NUMBER(20,2);
   dClmColTot NUMBER(20,2);
   dPolColTot  NUMBER(20,2);
   dClmResBal NUMBER(20,2);
   dPolResBal NUMBER(20,2);
   dClmIncAmt NUMBER(20,2);
   dPolIncAmt NUMBER(20,2);
   dClmResAmt NUMBER(20,2);
   dPolResAmt NUMBER(20,2);
   dClmChgAmt NUMBER(20,2);
   dPolChgAmt NUMBER(20,2);
   --JIRA 29954 knakra ends
   
   ---akumar523 starts 60666
   dClmCurrAlTot NUMBER(20,2) := 0.0;
   dPolCurrPrTot NUMBER(20,2) := 0.0;
   dClmCurrPrTot NUMBER(20,2) := 0.0;
   dPolcurrAlTot NUMBER(20,2) := 0.0;
   dAllocatedAmt NUMBER(20,2) := 0.0;
   dPrintedTot NUMBER(20,2) := 0.0;
   v_nSqlResAm CLOB;
   ---akumar523 ends 60666
	
BEGIN

   v_nSqlRes := 'SELECT SHORT_CODE FROM ' || v_vDbName || 'CODES WHERE CODE_ID =(';
   v_nSqlRes := v_nSqlRes || 'SELECT RELATED_CODE_ID FROM ' || v_vDbName || 'CODES WHERE CODE_ID = (';
   v_nSqlRes := v_nSqlRes || 'SELECT CLAIM_STATUS_CODE FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_ID = :1))';
   v_vLoc := 'ResReBal1';
   BEGIN
     EXECUTE IMMEDIATE v_nSqlRes INTO v_vClaimStatus USING v_iClaimId;
   --EXCEPTION
   -- WHEN OTHERS THEN
        --NULL;
   END;
   ---akumar523 starts 60666
	IF fVersionNum >= 19.1 THEN
	
		v_nSqlResAm := 'SELECT CLAIM_CURR_ALLOCATED_TOTAL,POLICY_CURR_PRINT_TOTAL,CLAIM_CURR_PRINT_TOTAL';
		v_nSqlResAm := v_nSqlResAm ||',POLICY_CURR_ALLOCATED_TOTAL, ALLOCATED_AMOUNT,PRINT_TOTAL FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE RC_ROW_ID = :1';
				
		EXECUTE IMMEDIATE v_nSqlResAm INTO dClmCurrAlTot, dPolCurrPrTot, dClmCurrPrTot, dPolcurrAlTot,dAllocatedAmt, dPrintedTot USING v_iRcRowId;

		IF dClmCurrAlTot IS NULL THEN
		   dClmCurrAlTot := 0.0;
		END IF;
		IF dPolCurrPrTot IS NULL THEN
           dPolCurrPrTot := 0.0;
		END IF;
		IF dClmCurrPrTot IS NULL THEN
		   dClmCurrPrTot := 0.0;
		END IF;
		IF dPolcurrAlTot IS NULL THEN
           dPolcurrAlTot := 0.0;
		END IF;
		IF dPolPaidTot IS NULL THEN
           dPolPaidTot := 0.0;
		END IF;
		IF dAllocatedAmt IS NULL THEN
           dAllocatedAmt := 0.0;
		END IF;
		IF dPrintedTot IS NULL THEN
           dPrintedTot := 0.0;
		END IF;
		
	END IF;
	
   --JIRA 29954 knakra starts
   IF fVersionNum >= 16.4 THEN
      nSqlCurr := 'SELECT SUM(FTS.AMOUNT), SUM(FTS.CLAIM_CURRENCY_AMOUNT), SUM(FTS.POLICY_CURRENCY_AMOUNT)';
      nSqlCurr := nSqlCurr || ' FROM ' || v_vDbName || 'FUNDS F, ' || v_vDbName || 'FUNDS_TRANS_SPLIT FTS, ';
      nSqlCurr := nSqlCurr || v_vDbName || 'RESERVE_CURRENT RC WHERE F.TRANS_ID = FTS.TRANS_ID';
      nSqlCurr := nSqlCurr || ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID';
      nSqlCurr := nSqlCurr || ' AND F.TRANS_DATE <= :1';
	  IF fVersionNum >=19.1 THEN 
	  BEGIN
      nSqlCurr := nSqlCurr || ' AND F.VOID_FLAG = 0 AND F.STOP_PAY_FLAG = 0';
	  END;
	  ELSE
	  BEGIN
	  nSqlCurr := nSqlCurr || ' AND F.VOID_FLAG = 0'; 
	  END;
	  END IF;
      nSqlCurr := nSqlCurr || ' AND RC.RC_ROW_ID = :2';
      
      v_nSqlPay := nSqlCurr || ' AND F.PAYMENT_FLAG <> 0';
      v_nSqlCol := nSqlCurr || ' AND F.PAYMENT_FLAG = 0';
      
      EXECUTE IMMEDIATE v_nSqlPay INTO v_dPaidTot, dClmPaidTot, dPolPaidTot USING v_vTransDate, v_iRcRowId;
      EXECUTE IMMEDIATE v_nSqlCol INTO v_dColTot, dClmColTot, dPolColTot USING v_vTransDate, v_iRcRowId;
      
      IF v_dPaidTot IS NULL THEN
         v_dPaidTot := 0.0;
      END IF;
      IF v_dColTot IS NULL THEN
         v_dColTot := 0.0;
      END IF;
      IF dClmPaidTot IS NULL THEN
         dClmPaidTot := 0.0;
      END IF;
      IF dClmColTot IS NULL THEN
         dClmColTot := 0.0;
      END IF;
      IF dPolPaidTot IS NULL THEN
         dPolPaidTot := 0.0;
      END IF;
      IF dPolColTot IS NULL THEN
         dPolColTot := 0.0;
      END IF;
      
      nSqlCurr := 'UPDATE ' || v_vDbName || 'RESERVE_CURRENT SET PAID_TOTAL = :1, COLLECTION_TOTAL = :2,';
      nSqlCurr := nSqlCurr || ' CLAIM_CURRENCY_PAID_TOTAL = :3, CLAIM_CURR_COLLECTION_TOTAL = :4,';
      nSqlCurr := nSqlCurr || ' POLICY_CURR_PAID_TOTAL = :5, POLICY_CURR_COLLECTION_TOTAL = :6,';
      nSqlCurr := nSqlCurr || ' DTTM_RCD_LAST_UPD = :7, UPDATED_BY_USER = ''DA_DDS''';
      nSqlCurr := nSqlCurr || ' WHERE RC_ROW_ID = :8';
      
      EXECUTE IMMEDIATE nSqlCurr USING v_dPaidTot, v_dColTot, dClmPaidTot, dClmColTot, dPolPaidTot, dPolColTot,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), v_iRcRowId; 
      
   ELSE
     v_nSqlPay := 'UPDATE ' || v_vDbName || 'RESERVE_CURRENT SET PAID_TOTAL = ';
     v_nSqlCol := 'UPDATE ' || v_vDbName || 'RESERVE_CURRENT SET COLLECTION_TOTAL = ';

     --IF v_iCarrierFlag <> 0 THEN       JIRA 23831 knakra
     IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR iVarFinKey <> 0 THEN          --JIRA 23831 knakra
        v_nSqlRes := '(SELECT SUM(FTS.AMOUNT) FROM ' || v_vDbName || 'FUNDS F, ' || v_vDbName || 'FUNDS_TRANS_SPLIT FTS, ';
        v_nSqlRes := v_nSqlRes || v_vDbName || 'RESERVE_CURRENT RC WHERE';
        v_nSqlRes := v_nSqlRes || ' F.TRANS_ID = FTS.TRANS_ID';  --neha 03/11
        v_nSqlRes := v_nSqlRes || ' AND FTS.RC_ROW_ID = RC.RC_ROW_ID';
        v_nSqlRes := v_nSqlRes || ' AND F.TRANS_DATE <= :1';
        v_nSqlRes := v_nSqlRes || ' AND F.VOID_FLAG = 0';
        v_nSqlRes := v_nSqlRes || ' AND RC.RC_ROW_ID = :2';
        v_nSqlPay := v_nSqlPay || v_nSqlRes || ' AND F.PAYMENT_FLAG <> 0),';
        v_nSqlCol := v_nSqlCol || v_nSqlRes || ' AND F.PAYMENT_FLAG = 0),';
        v_nSqlRes := ' DTTM_RCD_LAST_UPD = :3, UPDATED_BY_USER = :4';
        v_nSqlRes := v_nSqlRes || ' WHERE RC_ROW_ID = :5';
        v_nSqlPay := v_nSqlPay || v_nSqlRes;
        v_nSqlCol := v_nSqlCol || v_nSqlRes;
     ELSIF(iVarFinKey = 0 AND v_iCarrierFlag = 0) THEN         --JIRA 23831 knakra
        v_nSqlRes := '(SELECT SUM(FTS.AMOUNT) FROM ' || v_vDbName || 'FUNDS F, ' || v_vDbName || 'FUNDS_TRANS_SPLIT FTS WHERE';
        v_nSqlRes := v_nSqlRes || ' F.TRANS_ID = FTS.TRANS_ID';
        v_nSqlRes := v_nSqlRes || ' AND F.CLAIM_ID = :1';
        v_nSqlRes := v_nSqlRes || ' AND F.CLAIMANT_EID = :2';
        v_nSqlRes := v_nSqlRes || ' AND FTS.RESERVE_TYPE_CODE = :3';
        v_nSqlRes := v_nSqlRes || ' AND F.TRANS_DATE <= :4';
        v_nSqlRes := v_nSqlRes || ' AND F.VOID_FLAG = 0';
        v_nSqlPay := v_nSqlPay || v_nSqlRes || ' AND F.PAYMENT_FLAG <> 0),';
        v_nSqlCol := v_nSqlCol || v_nSqlRes || ' AND F.PAYMENT_FLAG = 0),';
        v_nSqlRes := ' DTTM_RCD_LAST_UPD =  :5 , UPDATED_BY_USER = :6';
        v_nSqlRes := v_nSqlRes || ' WHERE CLAIM_ID = :7 AND CLAIMANT_EID = :8';
        v_nSqlRes := v_nSqlRes || ' AND RESERVE_TYPE_CODE = :9';
        v_nSqlPay := v_nSqlPay || v_nSqlRes;
        v_nSqlCol := v_nSqlCol || v_nSqlRes;
     END IF;

      --IF v_iCarrierFlag <> 0 THEN JIRA 23831 knakra
      --IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR iVarFinKey = 0 THEN   --JIRA 23831 knakra --commented by JIRA 37552
      IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR iVarFinKey <> 0 THEN   --JIRA 37552
        v_vLoc := 'ResReBal2';
       EXECUTE IMMEDIATE v_nSqlPay USING v_vTransDate, v_iRcRowId,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),'DA_DDS', v_iRcRowId;
        v_vLoc := 'ResReBal3';
       EXECUTE IMMEDIATE v_nSqlCol USING v_vTransDate, v_iRcRowId,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),'DA_DDS', v_iRcRowId;
      ELSIF (iVarFinKey = 0 AND v_iCarrierFlag = 0) THEN    --JIRA 23831 knakra
        v_vLoc := 'ResReBal4';
       EXECUTE IMMEDIATE v_nSqlPay USING v_iClaimId,v_iClaimantEid,v_iResTypeCode, v_vTransDate,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), 'DA_DDS',v_iClaimId,v_iClaimantEid,v_iResTypeCode;
        v_vLoc := 'ResReBal5';
       EXECUTE IMMEDIATE v_nSqlCol USING v_iClaimId,v_iClaimantEid,v_iResTypeCode, v_vTransDate,TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), 'DA_DDS',v_iClaimId,v_iClaimantEid,v_iResTypeCode;
      END IF;
   END IF;
--JIRA 29954 knakra ends

   v_nSqlRes := 'SELECT PAID_TOTAL, COLLECTION_TOTAL, RESERVE_AMOUNT,';
   --JIRA 29954 knakra starts
   IF fVersionNum >= 16.4 THEN
      v_nSqlRes := v_nSqlRes || 'CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURR_COLLECTION_TOTAL, ';
      v_nSqlRes := v_nSqlRes || 'POLICY_CURR_PAID_TOTAL, POLICY_CURR_COLLECTION_TOTAL, ';
      v_nSqlRes := v_nSqlRes || 'CLAIM_CURRENCY_RESERVE_AMOUNT, POLICY_CURR_RESERVE_AMOUNT, ';
   END IF;
   v_nSqlRes := v_nSqlRes || ' RESERVE_TYPE_CODE, CLAIMANT_EID, RC_ROW_ID,';
   v_nSqlRes := v_nSqlRes || ' RES_STATUS_CODE, ';
   IF iVarFinKey = 0 THEN
      v_nSqlRes := v_nSqlRes || 'POLCVG_ROW_ID, ';
   END IF;
   v_nSqlRes := v_nSqlRes || 'POLICY_CVG_SEQNO, POLCVG_LOSS_ROW_ID FROM ' || v_vDbName || 'RESERVE_CURRENT WHERE';
   
   --IF v_iCarrierFlag <> 0 THEN                  JIRA 23831 knakra
   IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR iVarFinKey <> 0 THEN --JIRA 23831 knakra
      v_nSqlRes := v_nSqlRes || ' RC_ROW_ID = :1';
   ELSIF (iVarFinKey = 0 AND v_iCarrierFlag = 0) THEN
      v_nSqlRes := v_nSqlRes || ' CLAIM_ID = :1 AND CLAIMANT_EID = :2 AND RESERVE_TYPE_CODE = :3';
   END IF;
   
   --JIRA 29954 knakra starts
   IF fVersionNum >= 16.4 THEN
     EXECUTE IMMEDIATE v_nSqlRes INTO v_dPaidTot, v_dColTot, v_dResAmt, dClmPaidTot, dClmColTot, dPolPaidTot, dPolColTot, dClmResAmt, dPolResAmt, v_iOResTypeCode, v_iOClaimantEid, v_iDbRcRowId, v_iResStatus, v_iPolCvgSeqNum, v_iPolCvgLossRowId USING v_iRcRowId;
   ELSE
     --IF v_iCarrierFlag <> 0 THEN  --JIRA 23831 knakra
     IF (v_iCarrierFlag <> 0 AND iVarFinKey = 0) OR iVarFinKey <> 0 THEN --JIRA 23831 knakra
        v_vLoc := 'ResReBal6';
        IF iVarFinKey <> 0 THEN
           EXECUTE IMMEDIATE v_nSqlRes INTO v_dPaidtot,v_dColTot,v_dResAmt,v_iOResTypeCode,v_iOClaimantEid,v_iDbRcRowId,
                   v_iResStatus,
                   v_iPolCvgSeqNum,
                   v_iPolCvgLossRowId  USING v_iRcRowId;
        ELSE
           EXECUTE IMMEDIATE v_nSqlRes INTO v_dPaidtot,v_dColTot,v_dResAmt,v_iOResTypeCode,v_iOClaimantEid,v_iDbRcRowId,
                   v_iResStatus,
                   v_iPolCvgRowid,
                   v_iPolCvgSeqNum,
                   v_iPolCvgLossRowId  USING v_iRcRowId;
        END IF;
     ELSIF (iVarFinKey = 0 AND v_iCarrierFlag = 0) THEN        --JIRA 23831 knakra
        v_vLoc := 'ResReBal7';
        EXECUTE IMMEDIATE v_nSqlRes INTO v_dPaidtot,v_dColTot,v_dResAmt,v_iOResTypeCode,v_iOClaimantEid,v_iDbRcRowId,
                   v_iResStatus,
                   v_iPolCvgRowid,
                   v_iPolCvgSeqNum,
                   v_iPolCvgLossRowId  USING v_iClaimId, v_iClaimantEid,v_iResTypeCode ;
     END IF;
   END IF;
   --JIRA 29954 knakra ends
   ---added by neha--
   IF v_dPaidTot IS NULL then
      v_dPaidTot := 0;
   END IF;
   IF v_dColTot IS NULL then
      v_dColTot := 0;
   END IF;
   IF v_dResAmt IS NULL then
      v_dResAmt := 0;
   END IF;
   IF v_iPolCvgRowid IS NULL then
      v_iPolCvgRowid := 0;
   END IF;
   IF v_iPolCvgLossRowId IS NULL then
      v_iPolCvgLossRowId := 0;
   END IF;
   ---added by neha end--
   --JIRA 29954 knakra starts
   IF fVersionNum >= 16.4 THEN
      IF dClmPaidTot IS NULL THEN
         dClmPaidTot := 0.0;
      END IF;
      IF dClmColTot IS NULL THEN
         dClmColTot := 0.0;
      END IF;
      IF dPolPaidTot IS NULL THEN
         dPolPaidTot := 0.0;
      END IF;
      IF dPolColTot IS NULL THEN
         dPolColTot := 0.0;
      END IF;
      IF dClmResAmt IS NULL THEN
         dClmResAmt := 0.0;
      END IF;
      IF dPolResAmt IS NULL THEN
         dPolResAmt := 0.0;
      END IF;
      
   END IF;
   --JIRA 29954 knakra ends

   IF v_iDbRcRowId IS NOT NULL AND v_iDbRcRowId > 0 THEN

      v_nSqlRes := 'SELECT C1.SHORT_CODE FROM ' || v_vDbName || 'CODES C1, ' || v_vDbName || 'CODES C2 WHERE';
      v_nSqlRes := v_nSqlRes || ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = :1';

      BEGIN
        v_vLoc := 'ResReBal8';
        EXECUTE IMMEDIATE v_nSqlRes INTO v_vParentRsv USING v_iOResTypeCode;
      --EXCEPTION
        --WHEN NO_DATA_FOUND THEN
          --NULL;
         --WHEN OTHERS THEN
          -- NULL;
      END;

      v_nSqlRes := 'SELECT ADJ_RSV, BAL_TO_ZERO, NEG_BAL_TO_ZERO,';
      --JIRA 26101 knakra starts
      IF iVarFinKey <> 0 THEN
         v_nSqlRes := v_nSqlRes || 'COLL_IN_RSV_BAL, COLL_IN_INCUR_BAL';
      ELSE
         v_nSqlRes := v_nSqlRes || 'SET_TO_ZERO, COLL_IN_RSV_BAL, COLL_IN_INCUR_BAL';
      END IF;
      --JIRA 26101 knakra ends
      v_nSqlRes := v_nSqlRes || ' FROM ' || v_vDbname || 'SYS_PARMS_LOB WHERE LINE_OF_BUS_CODE = (';
      v_nSqlRes := v_nSqlRes || 'SELECT LINE_OF_BUS_CODE FROM ' || v_vDbName || 'CLAIM WHERE CLAIM_ID = :1)';

      BEGIN
        v_vLoc := 'ResReBal9';
        --JIRA 26101 knakra starts
        IF iVarFinKey <> 0 THEN
           EXECUTE IMMEDIATE v_nSqlRes INTO v_iAdjRsv,v_iBalToZero, v_iNegBalToZero,v_iColInRsvBal, v_iColInIncBal USING v_iClaimId;
           v_iSetToZero := 0;
        ELSE
           EXECUTE IMMEDIATE v_nSqlRes INTO v_iAdjRsv,v_iBalToZero, v_iNegBalToZero,v_iSetToZero,v_iColInRsvBal, v_iColInIncBal USING v_iClaimId;
        END IF;
        --JIRA 26101 knakra ends
      --EXCEPTION
        --WHEN NO_DATA_FOUND THEN
         --NULL;
         --WHEN OTHERS THEN
           --NULL;
       END;

      v_iDoNothing := 0;
      v_iAdjLog := 0;

      IF v_vParentRsv <> 'R' AND v_vParentRsv IS NOT NULL THEN
         IF v_iColInRsvBal <> 0 THEN
            IF fVersionNum >= 19.1 THEN
				IF v_vTransType = 'P' THEN --udoni 64208	starts
					v_dResBal := v_dResAmt -(dPrintedTot + dAllocatedAmt + dBaseCurrAmt - v_dColTot);
				ELSE
					v_dResBal := v_dResAmt -(dPrintedTot + dAllocatedAmt - v_dColTot);
				END IF;
			
			ELSE
			v_dResBal := v_dResAmt - (v_dPaidTot - v_dColTot);
			END IF;
			---v_dResBal := v_dResAmt - (v_dPaidTot - v_dColTot); --AKUMAR523
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
			   IF fVersionNum >= 19.1 THEN
			   
					IF v_vTransType = 'P' THEN
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt - dClmColTot);
			   
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt - dPolColTot);
					ELSE
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot - dClmColTot);
			   
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot - dPolColTot);
					END IF;
			   
			   ELSE
			   
			   dClmResBal := dClmResAmt - (dClmPaidTot - dClmColTot);
               dPolResBal := dPolResAmt - (dPolPaidTot - dPolColTot);
			   
			   END IF ;
			   
            END IF;
            --JIRA 29954 knakra ends
         ELSE
			IF fVersionNum >= 19.1 THEN   ----AKUMAR523 pahse 2 enhacement 
				v_dResBal := v_dResAmt - (dPrintedTot + dAllocatedAmt + dBaseCurrAmt);
			ELSE
				v_dResBal := v_dResAmt - v_dPaidTot;
			END IF;
            ---v_dResBal := v_dResAmt - v_dPaidTot;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
				IF fVersionNum >= 19.1 THEN ---akumar523 phase 2 enahcement
					IF  v_vTransType = 'P' THEN
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt);
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt);
					ELSE
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot);
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot);
					END IF;

				ELSE
					dClmResBal := dClmResAmt - dClmPaidTot;
					dPolResBal := dPolResAmt - dPolPaidTot;
				END IF;
				--udoni 64208 ends
							   
            END IF;
            --JIRA 29954 knakra ends
         END IF;

         IF v_iColInRsvBal <> 0 THEN
            IF v_dResBal < 0 THEN
				IF fVersionNum >=19.1 THEN ----AKUMAR523 pahse2 ALLOCATE ENHANCEMENT 
					
					v_dIncAmt := (dPrintedTot + dAllocatedAmt + dBaseCurrAmt) - v_dColTot;
				ELSE 
					v_dIncAmt := v_dPaidTot - v_dColTot;
				END IF ;
             ----  v_dIncAmt := v_dPaidTot - v_dColTot;
            ELSE
			   IF fVersionNum >=19.1 THEN  ----AKUMAR523 pahse2 ALLOCATE ENHANCEMENT 
			   v_dIncAmt := v_dResBal + (dPrintedTot + dAllocatedAmt + dBaseCurrAmt - v_dColTot);
			   ELSE
			   v_dIncAmt := v_dResBal + (v_dPaidTot - v_dColTot);
			   END IF; 	
               ----v_dIncAmt := v_dResBal + (v_dPaidTot - v_dColTot);
            END IF;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
               IF dClmResBal < 0 THEN
					IF fVersionNum >=19.1 THEN
						dClmIncAmt := (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt) - dClmColTot;
					ELSE
						dClmIncAmt := dClmPaidTot - dClmColTot;
					END IF ;
                  -- dClmIncAmt := dClmPaidTot - dClmColTot;
               ELSE
					IF fVersionNum >=19.1 THEN 
						dClmIncAmt := dClmResBal + (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt - dClmColTot);
					ELSE
						dClmIncAmt := dClmResBal + (dClmPaidTot - dClmColTot);
					END IF ;
					-----dClmIncAmt := dClmResBal + (dClmPaidTot - dClmColTot);
               END IF;
               IF dPolResBal < 0 THEN
					IF fVersionNum >=19.1 THEN
						dPolIncAmt := (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt) - dPolColTot;
					ELSE
						dPolIncAmt := dPolPaidTot - dPolColTot;
					END IF; 
                  -- dPolIncAmt := dPolPaidTot - dPolColTot;
               ELSE
				  IF fVersionNum >=19.1 THEN 
					 dPolIncAmt := dPolResBal + (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt - dPolColTot);
				  ELSE 
					 dPolIncAmt := dPolResBal + (dPolPaidTot - dPolColTot);
				  END IF; 
                  -----dPolIncAmt := dPolResBal + (dPolPaidTot - dPolColTot);
               END IF;
            END IF;
            --JIRA 29954 knakra ends
         ELSE
            IF v_dResBal < 0 THEN
				IF fVersionNum >=19.1 THEN 
					v_dIncAmt := dPrintedTot + dAllocatedAmt + dBaseCurrAmt;
				ELSE 
					v_dIncAmt := v_dPaidTot;
               ----v_dIncAmt := v_dPaidTot;
				END IF ;
            ELSE
			    IF fVersionNum >= 19.1 THEN 
					v_dIncAmt := v_dResBal + dPrintedTot + dAllocatedAmt + dBaseCurrAmt;
				ELSE 
					v_dIncAmt := v_dResBal + v_dPaidTot;
				END IF ;
               ------v_dIncAmt := v_dResBal + v_dPaidTot;
            END IF;
            --JIRA 29954 knakra starta
            IF fVersionNum >= 16.4 THEN
               IF dClmResBal < 0 THEN
					IF fVersionNum >=19.1 THEN -----AKUMAR523 pahse 2 enhancement 
						dClmIncAmt := dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt;
					ELSE 
						dClmIncAmt := dClmPaidTot;
					END IF ;
                  -- dClmIncAmt := dClmPaidTot;
               ELSE
					IF fVersionNum >=19.1 THEN 
						dClmIncAmt := dClmResBal + dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt;
					ELSE 
						dClmIncAmt := dClmResBal + dClmPaidTot;
					END IF ;
                  ------dClmIncAmt := dClmResBal + dClmPaidTot;
               END IF;
               IF dPolResBal < 0 THEN
					IF fVersionNum >=19.1 THEN 
						 dPolIncAmt := dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt;
					ELSE 
						 dPolIncAmt := dPolPaidTot;
					END IF ;
					
                  -- dPolIncAmt := dPolPaidTot;
               ELSE
					IF fVersionNum >=19.1 THEN ----AKUMAR523 PHASE 2 ENHANEMENT 
						dPolIncAmt := dPolResBal + dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt;
					ELSE 
					    dPolIncAmt := dPolResBal + dPolPaidTot;
					END IF ;
                 ---- dPolIncAmt := dPolResBal + dPolPaidTot;
               END IF;
            END IF;
            --JIRA 29954 knakra ends
         END IF;

         IF v_iColInIncBal <> 0 THEN
            v_dIncAmt := v_dIncAmt - v_dColTot;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
               dClmIncAmt := dClmIncAmt - dClmColTot;
               dPolIncAmt := dPolIncAmt - dPolColTot;
            END IF;
            --JIRA 29954 knarka ends
         END IF;
      ELSE
         IF v_vParentRsv = 'R'
           AND v_vParentRsv IS NOT NULL THEN
            v_dResBal := v_dResAmt - v_dColtot;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
               dClmResBal := dClmResAmt - dClmColTot;
               dPolResBal := dPolResAmt - dPolColTot;
            END IF;
            --JIRA 29954 knakra ends
            IF v_dResBal < 0 THEN
               v_dIncAmt := v_dColTot;
            ELSE
               v_dIncAmt := v_dResBal + v_dColTot;
            END IF;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
               IF dClmResBal < 0 THEN
                  dClmIncAmt := dClmColTot;
               ELSE
                  dClmIncAmt := dClmResBal + dClmColTot;
               END IF;
               IF dPolResBal < 0 THEN
                  dPolIncAmt := dPolColTot;
               ELSE
                  dPolIncAmt := dPolResBal + dPolColTot;
               END IF;
            END IF;
            --JIRA 29954 knakra ends
         END IF;
      END IF;

      IF v_vClaimStatus = 'O' THEN
         --IF v_iAdjRsv <> 0 AND v_dResBal < -0.009  AND v_vParentRsv <> 'R' THEN
         --JIRA 29954 knakra starts
         IF v_iAdjRsv <> 0 AND v_vParentRsv <> 'R' AND ((v_dResBal < -0.009 AND fVersionNum < 16.4) OR (fVersionNum >= 16.4 AND (v_dResBal < -0.009 OR dClmResBal < -0.009 OR dPolResBal < -0.009))) THEN
            --v_dResAmt := v_dResAmt + ABS(v_dResBal);
            --v_dChangeAmt := ABS(v_dResBal);
            v_dResAmt := v_dResAmt - v_dResBal;
            v_dChangeAmt := -(v_dResBal);
            IF fVersionNum >= 16.4 THEN
               dClmResAmt := dClmResAmt - dClmResBal;
               dPolResAmt := dPolResAmt - dPolResBal;
               dClmChgAmt := -(dClmResBal);
               dPolChgAmt := -(dPolResBal);
            END IF;
            --JIRA 29954 knakra ends
            v_iAdjLog := 1;
         ELSE
            v_iAdjLog := 0;
         END IF;
      ELSE
         --IF v_vClaimStatus = 'C' THEN  --commented by neha
            IF v_iSetToZero <> 0 AND v_vParentRsv <> 'R' THEN
               v_dChangeAmt := -v_dResAmt;
               v_dResAmt := 0;
               v_iDoNothing := 1;
            ELSE
               --IF v_iNegBalToZero <> 0 AND v_dResBal < 0 AND v_vParentRsv <> 'R' THEN
               IF v_iNegBalToZero <> 0 AND v_vParentRsv <> 'R' AND ((fVersionNum < 16.4 AND v_dResBal < -0.009) OR (fVersionNum >= 16.4 AND (v_dResBal < 0.009 OR dClmResBal < -0.009 OR dPolResBal < -0.009))) THEN
                  v_dResAmt := v_dResAmt - v_dResBal;
                  v_dChangeAmt := -v_dResBal;
                  --JIRA 29954 knakra starts
                  IF fVersionNum >= 16.4 THEN
                     dClmResAmt := dClmResAmt - dClmResBal;
                     dPolResAmt := dPolResAmt - dPolResBal;
                     dClmChgAmt := -(dClmResBal);
                     dPolChgAmt := -(dPolResBal);
                  END IF;
                  --JIRA 29954 knakra ends
                  v_iDoNothing := 1;
               ELSE
                  IF v_iBalToZero <> 0 AND v_vParentRsv <> 'R' THEN
                     v_dResAmt := v_dResAmt - v_dResBal;
                     v_dChangeAmt := -v_dResBal;
                     --JIRA 29954 knakra starts
                     IF fVersionNum >= 16.4 THEN
                        dClmResAmt := dClmResAmt - dClmResBal;
                        dPolResAmt := dPolResAmt - dPolResBal;
                        dClmChgAmt := -(dClmResBal);
                        dPolChgAmt := -(dPolResBal);
                     END IF;
                     --JIRa 29954 knakra ends
                     v_iDoNothing := 1;
                  END IF;
               END IF;
            END IF;
         END IF;
      --END IF;

   IF (( v_vClaimStatus = 'O' AND v_iAdjLog = 1 )OR ( v_vClaimStatus <> 'O' AND v_iDoNothing = 1 )) THEN  --neha
      IF v_vParentRsv <> 'R'  AND v_vParentRsv IS NOT NULL THEN
         IF v_iColInRsvBal <> 0 THEN
			IF fVersionNum >= 19.1 THEN
				IF v_vTransType = 'P' THEN --udoni 64208	starts
					v_dResBal := v_dResAmt -(dPrintedTot + dAllocatedAmt + dBaseCurrAmt - v_dColTot);
				ELSE
					v_dResBal := v_dResAmt -(dPrintedTot + dAllocatedAmt - v_dColTot);
				END IF;
			
			ELSE
			v_dResBal := v_dResAmt - (v_dPaidTot - v_dColTot);
			END IF;
			---v_dResBal := v_dResAmt - (v_dPaidTot - v_dColTot); --AKUMAR523
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
			   IF fVersionNum >= 19.1 THEN
			   
					IF v_vTransType = 'P' THEN
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt - dClmColTot);
			   
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt - dPolColTot);
					ELSE
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot - dClmColTot);
			   
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot - dPolColTot);
					END IF;
			   
			   ELSE
			   
			   dClmResBal := dClmResAmt - (dClmPaidTot - dClmColTot);
               dPolResBal := dPolResAmt - (dPolPaidTot - dPolColTot);
			   
			   END IF ;
			   
            END IF;
            --JIRA 29954 knakra ends
         ELSE
			IF fVersionNum >= 19.1 THEN   ----AKUMAR523 pahse 2 enhacement 
				v_dResBal := v_dResAmt - (dPrintedTot + dAllocatedAmt + dBaseCurrAmt);
			ELSE
				v_dResBal := v_dResAmt - v_dPaidTot;
			END IF;
            ---v_dResBal := v_dResAmt - v_dPaidTot;
            --JIRA 29954 knakra starts
            IF fVersionNum >= 16.4 THEN
				IF fVersionNum >= 19.1 THEN ---akumar523 phase 2 enahcement
					IF  v_vTransType = 'P' THEN
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot + dClmCurrAmt);
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt);
					ELSE
						dClmResBal := dClmResAmt - (dClmCurrPrTot + dClmCurrAlTot);
						dPolResBal := dPolResAmt - (dPolCurrPrTot + dPolcurrAlTot);
					END IF;

				ELSE
					dClmResBal := dClmResAmt - dClmPaidTot;
					dPolResBal := dPolResAmt - dPolPaidTot;
				END IF;
               ----dClmResBal := dClmResAmt - dClmPaidTot;
              ------ dPolResBal := dPolResAmt - dPolPaidTot;
			  --udoni 64208
            END IF;
            --JIRA 29954 knakra ends
		 END IF;

         IF v_iColInRsvBal <> 0 THEN
             IF v_dResBal < 0 THEN
				IF fVersionNum >=19.1 THEN 
					v_dIncAmt := (dAllocatedAmt + dPrintedTot + dBaseCurrAmt) - v_dColTot;
				ELSE 
					v_dIncAmt := v_dPaidTot - v_dColTot;
				END IF ;
               -----v_dIncAmt := v_dPaidTot - v_dColTot;
             ELSE
				IF fVersionNum >=19.1 THEN----AKUMAR523 pahse2 ALLOCATED_AMOUNT ENHANCEMENT
					v_dIncAmt := v_dResBal + (dAllocatedAmt + dPrintedTot + dBaseCurrAmt - v_dColTot);
			    ELSE 
					v_dIncAmt := v_dResBal + (v_dPaidTot - v_dColTot);
				END IF ;
                ----v_dIncAmt := v_dResBal + (v_dPaidTot - v_dColTot);
             END IF;
             --JIRA 29954 knarka starts
             IF fVersionNum >= 16.4 THEN
                IF dClmResBal < 0 THEN
					IF fVersionNum >=19.1 THEN 
						dClmIncAmt := dClmCurrAlTot + dClmCurrPrTot + dClmCurrAmt - dClmColTot;
					ELSE 
						dClmIncAmt := dClmPaidTot - dClmColTot;
					END IF; 
                   ---dClmIncAmt := dClmPaidTot - dClmColTot;
                ELSE
					IF fVersionNum >=19.1 THEN 
						dClmIncAmt := dClmResBal + (dClmCurrAlTot + dClmCurrPrTot + dClmCurrAmt - dClmColTot);
					ELSE 
						dClmIncAmt := dClmResBal + (dClmPaidTot - dClmColTot);
					END IF;
                   ---dClmIncAmt := dClmResBal + (dClmPaidTot - dClmColTot);
                END IF;
                IF dPolResBal < 0 THEN
					IF fVersionNum >=19.1 THEN
						dPolIncAmt := (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt) - dPolColTot;
					ELSE 
						dPolIncAmt := dPolPaidTot - dPolColTot;
					END IF ;
                   ----dPolIncAmt := dPolPaidTot - dPolColTot;
                ELSE
					IF fVersionNum >=19.1 THEN 
					
						dPolIncAmt := dPolResBal + (dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt - dPolColTot);

					ELSE 
						dPolIncAmt := dPolResBal + (dPolPaidTot - dPolColTot);

					END IF ;
					
                   -----dPolIncAmt := dPolResBal + (dPolPaidTot - dPolColTot);
                END IF;
             END IF;
             --JIRA 29954 knarka ends
         ELSE
             IF v_dResBal < 0 THEN
				IF fVersionNum >=19.1 THEN 
					v_dIncAmt := dAllocatedAmt + dPrintedTot + dBaseCurrAmt;
				ELSE 
					v_dIncAmt := v_dPaidTot;
				END IF; 
               --- v_dIncAmt := v_dPaidTot;
             ELSE
				IF fVersionNum >=19.1 THEN 
					v_dIncAmt := v_dResBal + dAllocatedAmt + dPrintedTot + dBaseCurrAmt;
				ELSE 
					v_dIncAmt := v_dResBal + v_dPaidTot;
				END IF ; 
                ---v_dIncAmt := v_dResBal + v_dPaidTot;
             END IF;
             --JIRA 29954 knakra starts
             IF dClmResBal < 0 THEN
				IF fVersionNum >=19.1 THEN 
					dClmIncAmt := dClmCurrAlTot + dClmCurrPrTot + dClmCurrAmt;
				ELSE 
					dClmIncAmt := dClmPaidTot;
				END IF ; 
				
                -- dClmIncAmt := dClmPaidTot;
             ELSE
				IF  fVersionNum >= 19.1 THEN 
					dClmIncAmt := dClmResBal + dClmCurrAlTot + dClmCurrPrTot + dClmCurrAmt;
				ELSE 
					dClmIncAmt := dClmResBal + dClmPaidTot;
				END IF; 
                -- dClmIncAmt := dClmResBal + dClmPaidTot;
             END IF;
             IF dPolResBal < 0 THEN
				IF fVersionNum >=19.1 THEN 
					dPolIncAmt := dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt;
				ELSE 
					dPolIncAmt := dPolPaidTot;
				END IF; 
                ---dPolIncAmt := dPolPaidTot;
             ELSE
				IF fVersionNum >=19.1 THEN 
					dPolIncAmt := dPolResBal + dPolCurrPrTot + dPolcurrAlTot + dPolCurrAmt;
				ELSE 
					dPolIncAmt := dPolResBal + dPolPaidTot;
				END IF;  
               ---- dPolIncAmt := dPolResBal + dPolPaidTot;
             END IF;
             --JIRA 29954 knakra ends
         END IF;

         IF v_iColInIncBal <> 0 THEN
               v_dIncAmt := v_dIncAmt - v_dColTot;
               --JIRA 29954 knakra starts
               IF fVersionNum >= 16.4 THEN
                  dClmIncAmt := dClmIncAmt - dClmColTot;
                  dPolIncAmt := dPolIncAmt - dPolColTot;
               END IF;
               --JIRA 29954 knakra ends
         END IF;
      END IF;
   END IF;

   IF v_dIncAmt IS NULL THEN ---added by neha 03/11
      v_dIncAmt := 0;
   END IF;
   --JIRA 29954 knakra strats
   IF fVersionNum >= 16.4 THEN
     IF dClmIncAmt IS NULL THEN
        dClmIncAmt := 0.0;
     END IF;
     IF dPolIncAmt IS NULL THEN
        dPolIncAmt := 0.0;
     END IF;
   END IF;
   --JIRA 29954 knarka ends
   IF v_dResBal IS NULL THEN
      v_dResBal := 0;
   END IF;
   --JIRA 29954 knakra starts
   IF fVersionNum >= 16.4 THEN
      IF dClmResBal IS NULL THEN
         dClmResBal := 0.0;
      END IF;
      IF dPolResBal IS NULL THEN
         dPolResBal := 0.0;
      END IF;
   END IF;
   --JIRA 29954 kanrka ends
   
   --JIRA 37552 nkhetan starts
			IF fVersionNum < 16.4  THEN
				 dClmIncAmt := v_dIncAmt;
				 dClmResBal := v_dResBal;
				 dClmResAmt := v_dResAmt;
			   dClmPaidTot := v_dPaidTot;
				 dClmColTot := v_dColTot;

				 dPolResBal := v_dResbal ;
			   dPolIncAmt := v_dIncAmt ;
				 dPolResAmt := v_dResAmt;
				 dPolPaidTot:= v_dPaidTot;
				 dPolColTot := v_dColTot;
			END IF;
		--JIRA 37552 nkhetan ends

 ----------neha changes starts here--------
   v_TodayDate :=  to_char(sysdate,'yyyymmddhh24miss');
   v_nSqlRes := 'UPDATE ' || v_vDbName || 'RESERVE_CURRENT SET RESERVE_AMOUNT = :1, BALANCE_AMOUNT = :2,';
   v_nSqlRes := v_nSqlRes || 'INCURRED_AMOUNT = :3,DTTM_RCD_LAST_UPD = :4, UPDATED_BY_USER = :5,';
   v_nSqlRes := v_nSqlRes || 'PAID_TOTAL = :6, COLLECTION_TOTAL = :7';
   --JIRA 37552 nkhetan starts --commented as Reserve_Current and Reserve_History was not in sync
   --JIRA 29954 knakra starts
   /*IF fVersionNum >= 16.4 THEN
      v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_BALANCE_AMOUNT = :9';
      v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_RESERVE_AMOUNT = :10';
      v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_PAID_TOTAL = :11';
      v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_COLLECTION_TOTAL = :12';
      v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_INCURRED_AMOUNT = :13';
      v_nSqlRes := v_nSqlRes || ', POLICY_CURRENCY_BALANCE_AMOUNT = :14';
      v_nSqlRes := v_nSqlRes || ', POLICY_CURR_RESERVE_AMOUNT = :15';
      v_nSqlRes := v_nSqlRes || ', POLICY_CURR_PAID_TOTAL = :16';
      v_nSqlRes := v_nSqlRes || ', POLICY_CURR_COLLECTION_TOTAL = :l7';
      v_nSqlRes := v_nSqlRes || ', POLICY_CURR_INCURRED_AMOUNT = :18';
   END IF;*/
   --JIRA 29954 knakra ends
   --JIRA 37552 nkhetan commented code ends
   --JIRA 37552 nkhetan starts
   IF iClaimMCFields = 1 THEN
       v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_BALANCE_AMOUNT = '||dClmResBal;
       v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_RESERVE_AMOUNT = '||dClmResAmt;
       v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_PAID_TOTAL = '||dClmPaidTot;
       v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_COLLECTION_TOTAL = '||dClmColTot;
       v_nSqlRes := v_nSqlRes || ', CLAIM_CURRENCY_INCURRED_AMOUNT = '||dClmIncAmt;
	   
	   IF fVersionNum >= 19.1 THEN  ----AKUMAR523
			
			IF v_vTransType = 'P' THEN  --udoni 64208
				IF vCheckStatus ='P' THEN
					dClmCurrPrTot := dClmCurrPrTot + dClmCurrAmt;
					v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_PRINT_TOTAL = '||dClmCurrPrTot;
				ELSE 
					dClmCurrAlTot := dClmCurrAlTot + dClmCurrAmt;
					v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_ALLOCATED_TOTAL= '||dClmCurrAlTot;
				END IF;
			END IF;
	   END IF;	
   END IF;
   IF iRsvMCFields = 1 THEN
       v_nSqlRes := v_nSqlRes || ', RSV_CURR_RSV_AMT = '||v_dResAmt;
       v_nSqlRes := v_nSqlRes || ', RESERVE_CURRENCY_PAID_TOTAL = '||v_dPaidTot;
       v_nSqlRes := v_nSqlRes || ', RSV_CURRENCY_BALANCE_AMOUNT = '||v_dResBal;
       v_nSqlRes := v_nSqlRes || ', RSV_CURR_COLLECTION_TOTAL = '||v_dColTot;
       v_nSqlRes := v_nSqlRes || ', RSV_CURR_INCURRED_AMOUNT = '||v_dIncAmt;
   END IF;
    IF iPolMCFields = 1 THEN
       v_nSqlRes := v_nSqlRes || ', POLICY_CURRENCY_BALANCE_AMOUNT = '||dPolResBal;
       v_nSqlRes := v_nSqlRes || ', POLICY_CURR_RESERVE_AMOUNT = '||dPolResAmt;
       v_nSqlRes := v_nSqlRes || ', POLICY_CURR_PAID_TOTAL ='||dPolPaidTot;
       v_nSqlRes := v_nSqlRes || ', POLICY_CURR_COLLECTION_TOTAL = '|| dPolColTot;
       v_nSqlRes := v_nSqlRes || ', POLICY_CURR_INCURRED_AMOUNT ='||dPolIncAmt;
	   
	   	---AKUMAR523 STARTS  60666
		IF fVersionNum >= 19.1 THEN
				IF v_vTransType = 'P' THEN  --udoni 64208
					IF vCheckStatus='P' THEN
						dPolCurrPrTot := dPolCurrPrTot + dPolCurrAmt;
						v_nSqlRes := v_nSqlRes || ', POLICY_CURR_PRINT_TOTAL = '|| dPolCurrPrTot;
					ELSE 
						dPolcurrAlTot := dPolcurrAlTot + dPolCurrAmt;
						v_nSqlRes := v_nSqlRes || ', POLICY_CURR_ALLOCATED_TOTAL= '|| dPolcurrAlTot;
					END IF;
				END IF;	
		---AKUMAR523 ENDS 60666
	    END IF;
   END IF;
   		--AKUMAR523 STARTS 60666
   IF fVersionNum >= 19.1 THEN
		IF v_vTransType = 'P' THEN  --udoni 64208
			IF vCheckStatus='P' THEN
				dPrintedTot := dPrintedTot + dBaseCurrAmt;
				v_nSqlRes := v_nSqlRes || ', PRINT_TOTAL = ' || dPrintedTot;
			ELSE 
				dAllocatedAmt := dAllocatedAmt + dBaseCurrAmt;
				v_nSqlRes := v_nSqlRes || ', ALLOCATED_AMOUNT = ' ||dAllocatedAmt;
			END IF;
		END IF; 
   END IF;
   v_nSqlRes := v_nSqlRes || ' WHERE RC_ROW_ID = :8';
   BEGIN
    v_vLoc := 'ResReBal10';
    --JIRA 37552 nkhetan starts --commented by 37552
    --JIRA 29954 knakra starts
   /* IF fVersionNum >= 16.4 THEN
       EXECUTE IMMEDIATE v_nSqlRes using v_dResAmt,v_dResBal,v_dIncAmt,v_TodayDate,'DA_DDS',v_dPaidTot,v_dColTot,dClmResBal, dClmResAmt, dClmPaidTot, dClmColTot, dClmIncAmt, dPolResBal, dPolResAmt, dPolPaidTot, dPolColTot, dPolIncAmt,v_iDbRcRowId;
    ELSE
       EXECUTE IMMEDIATE v_nSqlRes using v_dResAmt,v_dResBal,v_dIncAmt,v_TodayDate,'DA_DDS',v_dPaidTot,v_dColTot,v_iDbRcRowId;
    END IF;*/
     --JIRA 29954 knakra ends
    EXECUTE IMMEDIATE v_nSqlRes using v_dResAmt,v_dResBal,v_dIncAmt,v_TodayDate,'DA_DDS',v_dPaidTot,v_dColTot,v_iDbRcRowId;
    --JIRA 37552 nkhetan ends
    --EXCEPTION
         --WHEN OTHERS THEN
          -- NULL;
   END;
   
   IF (( v_vClaimStatus = 'O' AND v_iAdjLog = 1 ) OR ( v_vClaimStatus <> 'O' AND v_iDoNothing = 1 )) THEN
      v_nSqlRes := 'SELECT NEXT_UNIQUE_ID FROM ' || v_vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''RESERVE_HISTORY''';
      EXECUTE IMMEDIATE v_nSqlRes into v_iRsvRowid;


      IF (v_iCarrierFlag = 0 AND iVarFinKey = 0) THEN
         v_iPolCvgLossRowId:=0;
      END IF;

      v_nSqlRes:= 'INSERT INTO ' || v_vDbName || 'RESERVE_HISTORY(RSV_ROW_ID,CLAIM_ID,RESERVE_TYPE_CODE,CLAIMANT_EID,UNIT_ID,';
      v_nSqlRes:= v_nSqlRes || 'RESERVE_AMOUNT,PAID_TOTAL,COLLECTION_TOTAL,INCURRED_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,';
      v_nSqlRes:= v_nSqlRes || 'REASON,DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,CLOSED_FLAG,AUTO_ADJ_FLAG,';
      --JIRA 23831 knakra starts
      --v_nSqlRes:= v_nSqlRes || 'RES_STATUS_CODE,POLCVG_ROW_ID,POLICY_CVG_SEQNO,POLCVG_LOSS_ROW_ID,ENTERED_BY_USER) VALUES(';
      v_nSqlRes:= v_nSqlRes || 'RES_STATUS_CODE,';
      IF iVarFinKey = 0 THEN
         v_nSqlRes := v_nSqlRes || 'POLCVG_ROW_ID,';
      END IF;
      v_nSqlRes := v_nSqlRes || 'POLICY_CVG_SEQNO,POLCVG_LOSS_ROW_ID,ENTERED_BY_USER';
      IF iVarFinKey <> 0 THEN
         v_nSqlRes := v_nSqlRes || ', RC_ROW_ID';
      END IF;
      v_nSqlRes := v_nSqlRes || ', RESERVE_CATEGORY';
      --JIRA 24633 knakra starts
      IF iHmiFlag = 1 AND vBenReviewDate IS NOT NULL THEN
        v_nSqlRes := v_nSqlRes || ', BEN_REVIEW_DATE';
      END IF;
      --JIRA 24633 knakra ends
       --JIRA 28198 knakra starts
       IF iClaimMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT';
         --JIRA 29954 knakra starts
         --v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE';
         v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT';
         IF fVersionNum >= 16.4 THEN
            v_nSqlRes := v_nSqlRes || ', CLAIM_CURR_CHANGE_AMOUNT';
         ELSIF fVersionNum < 16.4 THEN
            v_nSqlRes := v_nSqlRes || ', BASE_TO_CLAIM_CUR_RATE';
         END IF;
         --JIRA 29954 knakra ends
       END IF;

       IF iRsvMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE';
         v_nSqlRes := v_nSqlRes || ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT';
       END IF;

       IF iPolMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ', POLICY_CURR_CODE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT';
         v_nSqlRes := v_nSqlRes || ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT';
         --JIRA 29954 knakra starts
         IF fVersionNum >= 16.4 THEN
            v_nSqlRes := v_nSqlRes || ', CLAIM_TO_POLICY_CUR_RATE, POLICY_CURR_CHANGE_AMOUNT';
         ELSE
            v_nSqlRes := v_nSqlRes || ', POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE';
         END IF;
         --JIRA 29954 knakra ends
       END IF;
       --JIRA 28198 knakra ends
      v_nSqlRes := v_nSqlRes || ') VALUES(';
      --JIRA 23831 knakra ends
      v_nSqlRes:= v_nSqlRes || ':1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,';
      IF v_iAdjLog = 1 AND v_vClaimStatus = 'O' THEN
         v_nSqlRes:= v_nSqlRes || '''AUTO ADJUST'', ';
      ELSIF v_iDoNothing = 1 AND v_vClaimStatus <> 'O' THEN
         v_nSqlRes:= v_nSqlRes || '''PMT ON CLOSED CLAIM'',';
      END IF;
      v_nSqlRes:= v_nSqlRes || ':13,:14, ''DA DDS'', :16, ''DA DDS'', ';
      IF v_vClaimStatus = 'O' AND v_iAdjLog = 1 THEN
         v_nSqlRes:= v_nSqlRes || '0, -1, ';
      ELSIF v_vClaimStatus <> 'O' THEN
        v_nSqlRes:= v_nSqlRes || '-1, 0, ';
      END IF;
      v_nSqlRes:= v_nSqlRes || ':20, ';
      IF iVarFinKey = 0 THEN
         v_nSqlRes := v_nSqlRes || ':21, ';
      END IF;
      v_nsqlRes := v_nsqlRes || ':22,:23, ';
      --JIRA 23831 knakra starts
      v_nSqlRes:= v_nSqlRes || '''DA DDS''';
      IF iVarFinKey <> 0 THEN
         v_nSqlRes := v_nSqlRes || ', :24';
      END IF;
      v_nSqlRes := v_nSqlRes || ', :25';
      --JIRA 24633 knakra starts
      IF iHmiFlag = 1 AND vBenReviewDate IS NOT NULL THEN
        v_nSqlRes := v_nSqlRes || ', ''' || vBenReviewDate || '''';
      END IF;
      --JIRA 24633 knakra ends
      --JIRA 28198 knakra starts
       IF iClaimMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ',' || iClmCurCode || ',' || dClmToBaseRate || ', ' || dClmResAmt || ', ' || dClmIncAmt || ', ' || dClmColTot || ', ' || dClmPaidTot || ', ' || dClmResBal || '';
         --JIRA 29954 knakra starts
         IF fVersionNum >= 16.4 THEN
            v_nSqlRes := v_nSqlRes || ', ' || dClmChgAmt || '';
         ELSE
            v_nSqlRes := v_nSqlRes || ', 1';
         END IF;
         --JIRA 29954 knakra ends
       END IF;

       IF iRsvMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ', 0, 1, ' || v_dResAmt || ', 1, 1, ' || v_dPaidTot || ', ' || v_dResBal || ', ' || v_dColTot || ', ' || v_dIncAmt;
       END IF;

       IF iPolMCFields = 1 THEN
         v_nSqlRes := v_nSqlRes || ',' || iPolCurCode || ', ' || dPolResAmt || ', ' || dPolIncAmt || ', ' || dPolColTot || ', ' || dPolPaidTot || ', ' || dPolResBal || '';
         --JIRA 29954 knakra starts
         IF fVersionNum >= 16.4 THEN
            v_nSqlRes := v_nSqlRes || ', ' || dClmToPolRate || ', ' || dPolChgAmt || '';
         ELSE
            v_nSqlRes := v_nSqlRes || ', 1, 1';
         END IF;
         --JIRA 29954 knakra ends
       END IF;
       --JIRA 28198 knakra ends
      v_nSqlRes:= v_nSqlRes || ')';
      --JIRA 23831 knakra ends
      BEGIN
         v_vLoc := 'ResReBal11';
         IF iVarFinKey <> 0 THEN   --JIRA 23831 knakra
           EXECUTE IMMEDIATE v_nSqlRes USING v_iRsvRowid,v_iClaimId,v_iOResTypeCode,v_iOClaimantEid,0,
           v_dResAmt,v_dPaidTot,v_dColTot,v_dIncAmt,v_dResBal,v_dChangeAmt,TO_CHAR(SYSDATE,'YYYYMMDD'),
           TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), v_iResStatus,
           v_iPolCvgSeqNum,v_iPolCvgLossRowId, v_iDbRcRowId, iResSubTypeCodeId;
         ELSE     --JIRA 23831 knakra
           EXECUTE IMMEDIATE v_nSqlRes USING v_iRsvRowid,v_iClaimId,v_iOResTypeCode,v_iOClaimantEid,0,
           v_dResAmt,v_dPaidTot,v_dColTot,v_dIncAmt,v_dResBal,v_dChangeAmt,TO_CHAR(SYSDATE,'YYYYMMDD'),
           TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), v_iResStatus,
           v_iPolCvgRowId,v_iPolCvgSeqNum,v_iPolCvgLossRowId, iResSubTypeCodeId;
         END IF;  --JIRA 23831 knakra
         --EXCEPTION
        -- WHEN OTHERS THEN
          -- NULL;
      END;

      BEGIN
        v_nSqlRes := 'UPDATE ' || v_vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1 ';
        EXECUTE IMMEDIATE v_nSqlRes USING 'RESERVE_HISTORY';
        --EXCEPTION
          --WHEN OTHERS THEN
           --NULL;
      END;
   END IF;
  END IF;
  COMMIT; --added by neha 03/11

  EXCEPTION
  WHEN OTHERS THEN
     ROLLBACK;  --added by neha 03/11
     v_vErrMsgDesc := SQLERRM;
     DDS_ERROR_LOG_CAPTURE(v_iJOBID,v_iDA_ROW_ID,'PAYMENT','ResReBal',v_vLoc,'DDS_RESERVE_REBAL',
     v_vErrMsgDesc,'EXCEPTION','DDS_PAYMENT','CLAIM_ID',v_vCLAIM_ID,0);
     v_iErrCnt :=v_iErrCnt+ 1;  --neha 03/10

END DDS_RESERVE_REBAL;
