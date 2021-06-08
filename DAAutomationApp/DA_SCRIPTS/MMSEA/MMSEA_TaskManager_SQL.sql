-- ============================================================
--   Table:	TM_TASK_TYPE
--   DATE:	 06/29/2012
--   ipuri  Mits:28538  Added If Statement
--   Template-RMA_16.2 and above MMSEA Medicare
-- =============================================================

BEGIN
IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='MMSEA') is null)
	begin
	INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'MMSEA', 'DA_MMSEA', '<Task Name=''MMSEA'' cmdline=''yes''><Path>DA_MMSEA.exe</Path></Task>', -1, 'MMSEASettings')
	end
	
ELSE
	begin
	UPDATE TM_TASK_TYPE SET DESCRIPTION ='DA_MMSEA' WHERE NAME ='MMSEA'
	--DELETE FROM TM_TASK_TYPE WHERE NAME='MMSEA'
	--INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'MMSEA', 'DA_MMSEA', '<Task Name=''MMSEA'' cmdline=''yes''><Path>DA_MMSEA.exe</Path></Task>', -1, 'MMSEASettings')
	end
END


