-- ============================================================
---Template_SICS(rmA17.1 onwards)
--   Module Name: DA_SICS
---mkaur24 JIRA RMA-34763 1/19/2017  
-- ============================================================= 

declare itasktype number; 
iJobState number;
BEGIN
select MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='SICS';
IF(itasktype is NULL) THEN 
		BEGIN
		INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'SICS','DA_SICS', '<Task Name=''SICS'' 
cmdline=''yes''><Path>DA_SICS.exe</Path></Task>', -1, 'SICSSettings');
		END;
ELSE
		BEGIN
    	UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_SICS' WHERE NAME =  'SICS' ;
	--	DELETE FROM TM_TASK_TYPE WHERE NAME='SICS';
	--	INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'SICS','DA_SICS', '<Task Name=''SICS'' 
--cmdline=''yes''><Path>DA_SICS.exe</Path></Task>', -1, 'SICSSettings');
		END;
END IF;
COMMIT;
END;











