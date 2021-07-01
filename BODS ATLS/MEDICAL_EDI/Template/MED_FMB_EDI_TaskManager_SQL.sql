-- ============================================================
--   MODULE: DA_EDI
--   Table:	TM_TASK_TYPE
--   DATE:	 01/01/2017
--   Template_MEDEDI(rmA16.4 onwards)
-- ============================================================

begin
IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='EDI') is null)
	begin
INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'EDI', 'DA_EDI', '<Task Name=''EDI'' cmdline=''yes''><Path>DA_EDI.exe</Path></Task>', -1, 'EDIsettings')
	end
else 
	begin
			UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_EDI' WHERE NAME =  'EDI'
--delete from TM_TASK_TYPE WHERE NAME='EDI'
--INSERT INTO TM_TASK_TYPE VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1),'EDI', 'DA_EDI', '<Task Name=''EDI'' cmdline=''yes''><Path>DA_EDI.exe</Path></Task>', -1, 'EDIsettings')
	end
end 