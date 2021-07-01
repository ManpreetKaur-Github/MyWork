
-- ============================================================
-- Template_SICS(rmA17.1 onwards)
--   Module Name: DA_SICS
---mkaur24 JIRA RMA-34763 1/19/2017  
-- ============================================================= 


begin
IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='SICS') is null)
	begin
INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'SICS', 'DA_SICS', '<Task Name=''SICS'' cmdline=''yes''><Path>DA_SICS.exe</Path></Task>', -1, 'SICSSettings')
	end
else 
	begin
			UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_SICS' WHERE NAME =  'SICS'
--delete from TM_TASK_TYPE WHERE NAME='SICS'
--INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'SICS', 'DA_SICS', '<Task Name=''SICS'' cmdline=''yes''><Path>DA_SICS.exe</Path></Task>', -1, 'SICSSettings')
	end
end