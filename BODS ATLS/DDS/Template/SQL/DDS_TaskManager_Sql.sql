--   Template-RMA_16.1 And Onwards DDS

begin 
	IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='DDS') is null)
		begin
		INSERT INTO TM_TASK_TYPE VALUES  ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1), 'DDS', 'DA_DDS', '<Task Name=''DDS'' cmdline=''yes''><Path>DA_DDS.exe</Path></Task>', -1, 'DDSsettings')
		end
	else 
		begin
			UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_DDS' WHERE NAME =  'DDS'
		--delete from TM_TASK_TYPE WHERE NAME='DDS'		
		--INSERT INTO TM_TASK_TYPE VALUES  ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1), 'DDS', 'DA_DDS', '<Task Name=''DDS'' cmdline=''yes''><Path>DA_DDS.exe</Path></Task>', -1, 'DDSsettings')
		end
end 

IF (SELECT MAX(JOB_STATE_ID) FROM TM_JOB_STATE)<9 INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification')


