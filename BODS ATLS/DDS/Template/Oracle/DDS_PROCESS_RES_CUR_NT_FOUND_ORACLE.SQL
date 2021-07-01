CREATE OR REPLACE PROCEDURE DDS_PROCESS_RES_CUR_NT_FOUND
(
  iClaimId NUMBER,
  iClaimantId NUMBER,
  iUnitId NUMBER, ---added by neha 03/10
  iLOB NUMBER,
  iRsvType NUMBER,
  fReserveAmount NUMBER,
  iResStatus NUMBER,
  bProcessRsvhistory NUMBER,
  vDateEntered VARCHAR2,
  iPOLCVG_LOSS_ROW_ID NUMBER,
  iPOLCVG_ROW_ID NUMBER,
  iPolicyCvgSeqNo NUMBER,
  vDbName VARCHAR2,
  iJOBID NUMBER,
  iDA_ROW_ID NUMBER,
  vClaimId VARCHAR2,  --added by neha 03/10
  iVarFinKey IN NUMBER,  --JIRA 23831 knakra
  iResSubTypeCodeId IN NUMBER,--JIRA 23831 knakra
  iHmiFlag IN NUMBER,                --JIRA 24633 knakra
  vBenReviewDate IN VARCHAR2,        --JIRA 24633 knakra
  iClaimMCFields IN NUMBER,          --JIRA 28198 knakra
  iRsvMCFields IN NUMBER,            --JIRA 28198 knakra
  iPolMCFields IN  NUMBER,           --JIRA 28198 knakra
  idClmResAmt IN  NUMBER,  --mkaur24 starts 12/6 JIRA 29954
  idPolResAmt IN  NUMBER,
  dClmToBaseRate IN NUMBER,
  dClmToPolRate IN NUMBER,
  ifVersionNum IN  NUMBER,
  iClmCurCode IN  NUMBER,
  iPolCurCode IN  NUMBER,  --mkaur24 ends 12/6
  iRC_ROW_ID OUT NUMBER,
  iErrCnt OUT NUMBER   ---added by neha 03/10
)
AUTHID CURRENT_USER
AS
   PRAGMA AUTONOMOUS_TRANSACTION;
   v_nSql CLOB;
   v_vReserveCategoryShortCode VARCHAR2(25);
   v_iRSV_ROW_ID NUMBER(10,0);
   v_fReserveBalance NUMBER(20,2);
   v_fIncurAmt NUMBER(20,2);
   v_v_SYS_DATE VARCHAR2(14);
   v_vLoc VARCHAR2(25);
   --v_vProcName VARCHAR2(100):='DDS_PROCESS_RES_CUR_NT_FOUND';
   V_INS_STATUS VARCHAR2(1);
   vErrorMsg CLOB;
   ---mkaur24 starts  JIRA 29954
   idClmIncAmt NUMBER(20,2);
   idClmResBal NUMBER(20,2);
   idPolIncAmt NUMBER(20,2);
   idPolResBal NUMBER(20,2);
   --NSQL CLOB;
   --mkaur24 ends JIRA 29954


BEGIN
   iRC_ROW_ID := 0;
   vErrorMsg := '';
   iErrCnt := 0;  --JIRA 29954 knakra

   v_vLoc := 'ResCat'; ---added by neha 03/10
   v_nSql := 'SELECT C1.SHORT_CODE FROM ' || vDbName || 'CODES C1, ' || vDbName || 'CODES C2 WHERE';
   v_nSql := v_nSql || ' C1.CODE_ID = C2.RELATED_CODE_ID AND C2.CODE_ID = :1 ';

   BEGIN
      EXECUTE IMMEDIATE V_NSQL INTO v_vReserveCategoryShortCode USING NVL(iRsvType, 0);
  -- EXCEPTION
    -- WHEN NO_DATA_FOUND THEN
      -- NULL;
   END;

   IF v_vReserveCategoryShortCode = 'R' THEN
      BEGIN
           v_fIncurAmt := 0;
           idClmIncAmt := 0  ;  --JIRA 37552
           idPolIncAmt := 0  ;  --JIRA 37552
           IF ifVersionNum >= 16.4 THEN
                 idClmIncAmt := 0  ;  --JIRA 29954 knakra
                 idPolIncAmt := 0  ;  --JIRA 29954 knakra
              END IF ;
     END ;
   ELSE
        BEGIN
                 v_fIncurAmt := fReserveAmount ;
                  idClmIncAmt := fReserveAmount ;  --JIRA 37552
                  idPolIncAmt := fReserveAmount ;  --JIRA 37552
                 
              IF ifVersionNum >= 16.4 THEN
                 idClmIncAmt := idClmResAmt ;    --JIRA 29954 knakra
                 idPolIncAmt := idPolResAmt  ;  --JIRA 29954 knakra
              END IF ;
        END ;
   END IF;
   v_fReserveBalance := fReserveAmount;
   idClmResBal := fReserveAmount;   --JIRA 37552
   idPolResBal :=fReserveAmount;    --JIRA 37552
   IF ifVersionNum >= 16.4 THEN
       idClmResBal := idClmResAmt ;
       idPolResBal := idPolResAmt ;
    END IF ;
 BEGIN
   v_vLoc := 'RCUID';  ---added by neha 03/10
   v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1 ';
   EXECUTE IMMEDIATE V_NSQL INTO iRC_ROW_ID USING 'RESERVE_CURRENT';
-- EXCEPTION
   -- WHEN OTHERS THEN
         -- vErrorMsg := vErrorMsg || 'Fetching next unique id for reserve current query failed.' || SQLERRM;
 END;

 BEGIN
   v_v_SYS_DATE :=  to_char(sysdate,'yyyymmddhh24miss');
   v_vLoc := 'RcIns';  -----added by neha 03/10
   v_nSql := 'INSERT INTO ' || vDbName || 'RESERVE_CURRENT(RC_ROW_ID,CLAIM_ID,CLAIMANT_EID,UNIT_ID,RESERVE_TYPE_CODE,';
   v_nSql := v_nSql || 'RESERVE_AMOUNT, BALANCE_AMOUNT, INCURRED_AMOUNT, PAID_TOTAL, COLLECTION_TOTAL,';
   v_nSql := v_nSql || 'DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,DTTM_RCD_LAST_UPD,UPDATED_BY_USER,REASON,';
   --JIRA 23831 knakra starts
   v_nSql := v_nSql || 'ENTERED_BY_USER,POLCVG_LOSS_ROW_ID,RESERVE_CATEGORY';
   IF iVarFinKey = 0 THEN
      v_nSql := v_nSql || ', POLCVG_ROW_ID';
   END IF;
   --JIRA 28198 knakra starts
   IF iClaimMCFields = 1 THEN
   --JIRA 29954 knakra starts
     --v_nSql := v_nSql || ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT';
     v_nSql := v_nSql || ', CLAIM_CURR_CODE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT';
     --v_nSql := v_nSql || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE';
     v_nSql := v_nSql || ',CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT' ;
      IF ifVersionNum < 16.4 THEN
        v_nSql := v_nSql ||  ', CLAIM_TO_BASE_CUR_RATE, BASE_TO_CLAIM_CUR_RATE ' ;
      END IF ;
      --JIRA 29954 knakra ends
   END IF;

   IF iRsvMCFields = 1 THEN
     v_nSql := v_nSql || ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE';
     v_nSql := v_nSql || ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT';
   END IF;

   IF iPolMCFields = 1 THEN
     --v_nSql := v_nSql || ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT';
     v_nSql := v_nSql || ', POLICY_CURR_CODE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT';
     --v_nSql := v_nSql || ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE';
     v_nSql := v_nSql || ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT';
     IF ifVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', POLICY_TO_BASE_CUR_RATE, BASE_TO_POLICY_CUR_RATE ';
     END IF;
   END IF;
   --JIRA 28198 knakra ends
   v_nSql := v_nSql || ', POLICY_CVG_SEQNO,RES_STATUS_CODE)';
   v_nSql := v_nSql || 'VALUES(:1,:2,:3,:4,:5, :6,:7,:8, :9,:10, :11,:12,:13,:14,:15, :16, :17, :18, :19 ';
   IF iVarFinKey = 0 THEN
      v_nSql := v_nsql || ', :20 ';
   END IF;
   --JIRA 28198 knakra starts
   IF iClaimMCFields = 1 THEN
     --JIRA 29954 knakra starts
     --v_nSql := v_nSql || ',' || iClmCurCode || ', ' || dClmToBaseRate || ', ' || idClmResAmt || ', ' || idClmIncAmt || ', 0, 0, ' || idClmResBal || '';
     v_nSql := v_nSql || ',' || iClmCurCode || ', ' || idClmResAmt || ', ' || idClmIncAmt || ', 0, 0, ' || idClmResBal || '';
     IF ifVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', 1, 1';
     END IF;
     --JIRA 29954 knakra ends
   END IF;

   IF iRsvMCFields = 1 THEN
     v_nSql := v_nSql || ', 0, 1, ' || fReserveAmount || ', 1, 1, 0, ' || v_fReserveBalance || ', 0, ' || v_fIncurAmt;
   END IF;

   IF iPolMCFields = 1 THEN
     --JIRA 29954 knakra starts
     --v_nSql := v_nSql || ', 0, 1, ' || fReserveAmount || ', ' || v_fIncurAmt || ', 0, 0, ' || v_fReserveBalance || ', 1';
     v_nSql := v_nSql || ', ' || iPolCurCode || ', ' || idPolResAmt || ', ' || idPolIncAmt || ', 0, 0, ' || idPolResBal || '';
     IF ifVersionNum < 16.4 THEN
        v_nSql := v_nSql || ', 1, 1';
     END IF;
   END IF;
   --JIRA 28198 knakra ends
   v_nSql := v_nSql || ', :21, :22)';

   IF iVarFinKey <> 0 THEN
      EXECUTE IMMEDIATE v_nSql USING  iRC_ROW_ID,iClaimId, iClaimantId,
                 --0, commented by neha
                 iUnitId, -----added by neha 03/10
                 iRsvType,fReserveAmount,v_fReserveBalance,
                 v_fIncurAmt,
                 0,
                 0,
                 vDateEntered,
                 v_v_SYS_DATE,
                 'DADDS',
                 v_v_SYS_DATE,
                 'DADDS',
                 'DADDS Payment Record',  --neha 03/10
                 'DADDS',
                 iPOLCVG_LOSS_ROW_ID,
                 iResSubTypeCodeId,       --JIRA 23831 knakra
                 iPolicyCvgSeqNo,
                 iResStatus;
   ELSE
      EXECUTE IMMEDIATE v_nSql USING  iRC_ROW_ID,iClaimId, iClaimantId,
                 --0, commented by neha
                 iUnitId, -----added by neha 03/10
                 iRsvType,fReserveAmount,v_fReserveBalance,
                 v_fIncurAmt,
                 0,
                 0,
                 vDateEntered,
                 v_v_SYS_DATE,
                 'DADDS',
                 v_v_SYS_DATE,
                 'DADDS',
                 'DADDS Payment Record',  --neha 03/10
                 'DADDS',
                 iPOLCVG_LOSS_ROW_ID,
                 iResSubTypeCodeId,       --JIRA 23831 knakra
                 iPOLCVG_ROW_ID,
                 iPolicyCvgSeqNo,
                 iResStatus;
   END IF;
   --JIRA 23831 knakra ends
     V_INS_STATUS:='Y';

   EXCEPTION
    WHEN OTHERS THEN
      V_INS_STATUS := 'N';
      iErrCnt := iErrCnt + 1;             --JIRA 29954 knakra
      --IF vErrorMsg IS NOT NULL THEN
         --vErrorMsg := vErrorMsg || '\n';
     -- END IF;
     -- vErrorMsg := NVL(vErrorMsg,'') || 'Insert into Reserve Current query failed.' || SQLERRM;
   END;

 BEGIN
   v_vLoc := 'UpdRcUid'; ---added by neha 03/10
   IF V_INS_STATUS = 'Y' THEN
      v_nSql := 'UPDATE ' || vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1 ';
      EXECUTE IMMEDIATE V_NSQL USING 'RESERVE_CURRENT';
   END IF;
 --EXCEPTION
   -- WHEN OTHERS THEN
     -- IF vErrorMsg IS NOT NULL THEN
         --vErrorMsg := vErrorMsg || '\n' || 'Updating next unique id for reserve current query failed...' || SQLERRM;
     -- ELSE
         --vErrorMsg := 'Updating next unique id for reserve current query failed.' || SQLERRM;
      --END IF;
 END;


 IF ( bProcessRsvhistory = 1 AND  V_INS_STATUS = 'Y') THEN
  BEGIN
    v_vLoc := 'RHUID';---added by neha 03/10
    v_nSql := 'SELECT NEXT_UNIQUE_ID FROM ' || vDbName || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
    EXECUTE IMMEDIATE v_nSql INTO v_iRSV_ROW_ID USING 'RESERVE_HISTORY';
  --EXCEPTION
   --WHEN OTHERS THEN
     --IF vErrorMsg IS NOT NULL THEN
       -- vErrorMsg := vErrorMsg || '\n';
     --END IF;
     --vErrorMsg := NVL(vErrorMsg,'') || 'Fetching Next unique id for Reserve History query failed.' || SQLERRM;
  END;

  BEGIN
      v_v_SYS_DATE :=  to_char(sysdate,'yyyymmddhh24miss');
      v_vLoc := 'RHIns';
      v_nSql := 'INSERT INTO ' || vDbName || 'RESERVE_HISTORY(RSV_ROW_ID,CLAIM_ID,RESERVE_TYPE_CODE,CLAIMANT_EID,UNIT_ID,RESERVE_AMOUNT,PAID_TOTAL,';
      v_nSql := v_nSql || 'COLLECTION_TOTAL,INCURRED_AMOUNT,BALANCE_AMOUNT,CHANGE_AMOUNT,REASON,DATE_ENTERED,DTTM_RCD_ADDED,ADDED_BY_USER,';
      --JIRA 23831 knakra starts
      v_nSql := v_nSql || 'DTTM_RCD_LAST_UPD,UPDATED_BY_USER,ENTERED_BY_USER, POLCVG_LOSS_ROW_ID,RESERVE_CATEGORY, ';
      IF iVarFinKey = 0 THEN
         v_nSql := v_nSql || 'POLCVG_ROW_ID,';
      END IF;
      --v_nSql := v_nSql || 'ONHOLD_RSV_ROW_ID,RES_STATUS_CODE)VALUES(:1, :2,:3,:4,:5,';
      v_nSql := v_nSql || 'APPROVER_ID,ONHOLD_RSV_ROW_ID,RES_STATUS_CODE';
      IF iVarFinKey <> 0 THEN
         v_nSql := v_nSql || ', RC_ROW_ID';
      END IF;
       --JIRA 28198 knakra starts
       IF iClaimMCFields = 1 THEN
         v_nSql := v_nSql || ', CLAIM_CURR_CODE, CLAIM_TO_BASE_CUR_RATE, CLAIM_CURRENCY_RESERVE_AMOUNT, CLAIM_CURRENCY_INCURRED_AMOUNT';
         v_nSql := v_nSql || ', CLAIM_CURR_COLLECTION_TOTAL, CLAIM_CURRENCY_PAID_TOTAL, CLAIM_CURRENCY_BALANCE_AMOUNT, BASE_TO_CLAIM_CUR_RATE';
       END IF;

       IF iRsvMCFields = 1 THEN
         v_nSql := v_nSql || ', RESERVE_CURR_CODE, RSV_TO_CLAIM_CUR_RATE, RSV_CURR_RSV_AMT, RESERVE_TO_BASE_CUR_RATE, BASE_TO_RESERVE_CUR_RATE';
         v_nSql := v_nSql || ', RESERVE_CURRENCY_PAID_TOTAL, RSV_CURRENCY_BALANCE_AMOUNT, RSV_CURR_COLLECTION_TOTAL, RSV_CURR_INCURRED_AMOUNT';
       END IF;

       IF iPolMCFields = 1 THEN
         v_nSql := v_nSql || ', POLICY_CURR_CODE, POLICY_TO_BASE_CUR_RATE, POLICY_CURR_RESERVE_AMOUNT, POLICY_CURR_INCURRED_AMOUNT';
         v_nSql := v_nSql || ', POLICY_CURR_COLLECTION_TOTAL, POLICY_CURR_PAID_TOTAL, POLICY_CURRENCY_BALANCE_AMOUNT, BASE_TO_POLICY_CUR_RATE';
       END IF;
       --JIRA 28198 knakra ends
       --JIRA 24633 knakra starts
       IF iHmiFlag = 1 AND vBenReviewDate IS NOT NULL THEN
         v_nSql := v_nSql || ', BEN_REVIEW_DATE';
       END IF;
       --JIRA 24633 knakra ends
      v_nSql := v_nSql || ')VALUES(:1, :2,:3,:4,:5,';
      --JIRA 23831 knakra ends
      v_nSql := v_nSql || ':6, :7,:8,:9, :10, :11, :12,';
      v_nSql := v_nSql || ':13, :14, :15, :16, :17,: 18,';
      --JIRA 23831 knakra starts
      --v_nSql := v_nSql || ':19, :20,:21, :22, :23,:24)';
      v_nSql := v_nSql || ':19, :20,';
      IF iVarFinKey = 0 THEN
         v_nSql := v_nSql || ':21, ';
      END IF;
      v_nSql := v_nSql || ':22, :23,:24';
      IF iVarFinKey <> 0 THEN
         v_nSql := v_nSql || ', ' || iRC_ROW_ID;
      END IF;
      --JIRA 28198 knakra starts
       IF iClaimMCFields = 1 THEN
          v_nSql := v_nSql || ', 0, 1, ' || fReserveAmount || ', ' || v_fIncurAmt || ', ' ||  ', 0, 0, ' || v_fReserveBalance || ', 1';
       END IF;

       IF iRsvMCFields = 1 THEN
           v_nSql := v_nSql || ', 0, 1, ' || fReserveAmount || ', 1, 1, 0, ' || v_fReserveBalance || ', 0, ' || v_fIncurAmt;
       END IF;

       IF iPolMCFields = 1 THEN
          v_nSql := v_nSql || ', 0, 1, ' || fReserveAmount || ', ' || v_fIncurAmt || ', 0, 0, ' || v_fReserveBalance || ', 1';
       END IF;
       --JIRA 28198 knakra ends
       --JIRA 24633 knakra starts
       IF iHmiFlag = 1 AND vBenReviewDate IS NOT NULL THEN
          v_nSql := v_nSql || ', ''' || vBenReviewDate || '''';
       END IF;
       --JIRA 24633 knakra ends
      v_nSql := v_nSql || ')';

      IF iVarFinKey <> 0 THEN
         EXECUTE IMMEDIATE v_nSql USING v_iRSV_ROW_ID,
                          iClaimId,
                          iRsvType,
                          iClaimantId,
                          --0,
                          iUnitId, -----added by neha 03/10
                          fReserveAmount,
                          0,
                          0,
                          v_fIncurAmt,
                          v_fReserveBalance,
                          fReserveAmount,
                          'DADDS Payment Record',
                          vDateEntered,
                          v_v_SYS_DATE,
                          'DADDS',
                          v_v_SYS_DATE,
                          'DADDS',
                          'DADDS',
                          iPOLCVG_LOSS_ROW_ID,
                          iResSubTypeCodeId,  --JIRA 23831 knakra
                          0,
                          0,
                          iResStatus ;
      ELSE
         EXECUTE IMMEDIATE v_nSql USING v_iRSV_ROW_ID,
                          iClaimId,
                          iRsvType,
                          iClaimantId,
                          --0,
                          iUnitId, -----added by neha 03/10
                          fReserveAmount,
                          0,
                          0,
                          v_fIncurAmt,
                          v_fReserveBalance,
                          fReserveAmount,
                          'DADDS Payment Record',
                          vDateEntered,
                          v_v_SYS_DATE,
                          'DADDS',
                          v_v_SYS_DATE,
                          'DADDS',
                          'DADDS',
                          iPOLCVG_LOSS_ROW_ID,
                          iResSubTypeCodeId,  --JIRA 23831 knakra
                          iPOLCVG_ROW_ID,
                          0,
                          0,
                          iResStatus ;
      END IF;
      --JIRA 23831 knakra ends
      V_INS_STATUS := 'Y';
  EXCEPTION
   WHEN OTHERS THEN
     V_INS_STATUS := 'N';
     --IF vErrorMsg IS NOT NULL THEN
       -- vErrorMsg := vErrorMsg || '\n';
     --END IF;
     --vErrorMsg := NVL(vErrorMsg,'') || 'Insert into Reserve History query failed.' || SQLERRM;
  END;

  BEGIN
      v_vLoc := 'UpdRHUid';
      v_nSql := 'UPDATE ' || vDbName || 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = :1';
      EXECUTE IMMEDIATE V_NSQL USING 'RESERVE_HISTORY';
   -- EXCEPTION
    -- WHEN OTHERS THEN
       --IF vErrorMsg IS NOT NULL THEN
         -- vErrorMsg := vErrorMsg || '\n';
       --END IF;
      -- vErrorMsg := NVL(vErrorMsg,'') || 'Updating Next unique id for Reserve History query failed.' || SQLERRM;
    END;
 END IF;


IF V_INS_STATUS = 'Y' THEN
  COMMIT;
ELSIF
  V_INS_STATUS = 'N'  THEN
  ROLLBACK;
END IF;

EXCEPTION
  WHEN OTHERS THEN
    -- IF vErrorMsg IS NOT NULL THEN
       -- vErrorMsg := vErrorMsg || '\n';
     --END IF;
     vErrorMsg := SQLERRM;
     DDS_ERROR_LOG_CAPTURE(iJOBID,iDA_ROW_ID,'PAYMENT','RcIfNotFound',v_vLoc,'DDS_PROCESS_RES_CUR_NT_FOUND',
     vErrorMsg,'EXCEPTION','DDS_PAYMENT','CLAIM_ID',vClaimId,0);
     iErrCnt :=iErrCnt+ 1;  --neha 03/10


END DDS_PROCESS_RES_CUR_NT_FOUND;
