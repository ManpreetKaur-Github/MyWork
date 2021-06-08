-- ============================================================
--   Table:  		TM_TASK_TYPE
--   Version:		RMA 17.3 onward
--   Database Type:	SQL
--   DATE:		11/09/2017
--   Author: 		Aditi Gurha
-- ============================================================

------------------------------------------------------------------
-- Insert ACH entry in TM_TASK_TYPE table, if not exists already.
------------------------------------------------------------------

begin
if ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE where NAME = 'ACH') is null)
	begin	
	INSERT INTO TM_TASK_TYPE 
VALUES ((ISNULL((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE),0) + 1) ,'ACH','DA_ACH','<Task Name=''ACH'' cmdline=''yes''><Path>DA_ACH.exe</Path></Task>',-1,'DAACH')
	end
else 
	begin
	UPDATE TM_TASK_TYPE SET DESCRIPTION ='DA_ACH' where NAME = 'ACH'
	
	end
end 
