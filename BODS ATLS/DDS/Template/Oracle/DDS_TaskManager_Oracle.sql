-- ============================================================
--   Table:	TM_TASK_TYPE
--   DATE:	01/29/2016
--   Template-RMA_16.1 And Onwards DDS
-- =============================================================


declare 
itasktype number;
iJobState number;

BEGIN
select MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='DDS';
IF(itasktype is NULL) THEN 
		BEGIN
			INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE) ,'DDS','DA_DDS', '<Task Name=''DDS'' 
cmdline=''yes''><Path>DA_DDS.exe</Path></Task>', -1, 'DDSSettings');
		END;
else 
		BEGIN
    
	UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_DDS' WHERE NAME =  'DDS' ;
	--	DELETE FROM TM_TASK_TYPE WHERE NAME='DDS';
		--INSERT INTO TM_TASK_TYPE VALUES ((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE) ,'DDS','DA_DDS', '<Task Name=''DDS'' 
--cmdline=''yes''><Path>DA_DDS.exe</Path></Task>', -1, 'DDSSettings');
		END;
END IF;

SELECT NVL(MAX(JOB_STATE_ID) , 0 )  INTO iJobState FROM TM_JOB_STATE;
IF(iJobState<9) THEN
INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification');

END IF;
COMMIT;
END;




























