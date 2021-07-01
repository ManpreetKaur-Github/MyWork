-- ============================================================
--   Table:	TM_TASK_TYPE
--   Template-rmA 16.3_DIS
--   DATE:	 09/07/2012
--   ipuri Mits:28558  Added Begin End block
--   ipuri 09/07/2014 User Verification changes
-- =============================================================


declare itasktype number;iJobState number;
BEGIN
select MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='DIS';
IF(itasktype is NULL) THEN 
	BEGIN
		INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'DIS','DA_DIS', '<Task Name=''DIS'' 
cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings');
	END;
ELSE 
	BEGIN
  	UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_DIS' WHERE NAME =  'DIS';
  ---	DELETE FROM TM_TASK_TYPE WHERE NAME='DIS';
---	INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'DIS','DA_DIS', '<Task Name=''DIS'' 
---cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings');	
	END;
END IF;

SELECT MAX(JOB_STATE_ID)  INTO iJobState FROM TM_JOB_STATE;
IF(iJobState<9) THEN
INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification');
END IF;
COMMIT;
END;

