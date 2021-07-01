-- ============================================================
--   Table:	TM_TASK_TYPE
--   Template-rmA 16.3_DIS
-- =============================================================

BEGIN
IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='DIS') is null)
	begin
	INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'DIS', 'DA_DIS', '<Task Name=''DIS'' cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings')
	end	
ELSE 
	begin
	UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_DIS' WHERE NAME =  'DIS'
	--DELETE FROM TM_TASK_TYPE WHERE NAME='DIS'
	--INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'DIS', 'DA_DIS', '<Task Name=''DIS'' cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings')
	end
END

IF (SELECT MAX(JOB_STATE_ID) FROM TM_JOB_STATE)<9 INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification')