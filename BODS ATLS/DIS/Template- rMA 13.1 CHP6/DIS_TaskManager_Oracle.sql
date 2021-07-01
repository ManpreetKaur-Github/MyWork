-- ============================================================
--   Table:	TM_TASK_TYPE
--   DATE:	 09/07/2012
--   ipuri Mits:28558  Added Begin End block
-- =============================================================

declare itasktype number;
BEGIN
select MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='MMSEA';
IF(itasktype is NULL) THEN 
INSERT INTO TM_TASK_TYPE VALUES ((Select COUNT(*) FROM TM_TASK_TYPE) + 1,'DIS','DIS', '<Task Name=''DIS'' 
cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings');
END IF;
END;