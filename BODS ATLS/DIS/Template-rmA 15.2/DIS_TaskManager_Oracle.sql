-- ============================================================
--   Table:	TM_TASK_TYPE
--   Template-rmA 15.2_DIS
--   DATE:	 09/07/2012
--   ipuri Mits:28558  Added Begin End block
--   ipuri 09/07/2014 User Verification changes
-- =============================================================


declare itasktype number;iJobState number;
BEGIN
select MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='DIS';
IF(itasktype is NULL) THEN 
INSERT INTO TM_TASK_TYPE VALUES ((Select COUNT(*) FROM TM_TASK_TYPE) + 1,'DIS','DIS', '<Task Name=''DIS'' 
cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings');
END IF;

SELECT MAX(JOB_STATE_ID)  INTO iJobState FROM TM_JOB_STATE;
IF(iJobState<9) THEN
INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification');
END IF;
END;

