--   Template-1099 MISC Export (Version rmA-16.2 and onwards)

declare @var1 int
declare @var2 int
declare @var3 int
set @var1 = (select count(*) from TM_TASK_TYPE where name = '1099-MISC')
	if @var1 = 0
	BEGIN
		set @var2 =  (select max (TASK_TYPE_ID) from TM_TASK_TYPE)
			if @var2 IS NULL
			BEGIN
				set @var3 = 1
				INSERT INTO TM_TASK_TYPE VALUES (@var3 ,'1099-MISC','DA_1099-MISC','<Task Name=''1099-MISC'' cmdline=''yes''><Path>DA_1099.exe</Path></Task>',-1,'RM1099Preferences');
				
			END
			ELSE 
			BEGIN
				set @var3 = @var2 + 1
				INSERT INTO TM_TASK_TYPE VALUES (@var3 ,'1099-MISC','DA_1099-MISC','<Task Name=''1099-MISC'' cmdline=''yes''><Path>DA_1099.exe</Path></Task>',-1,'RM1099Preferences')
				
			END
	END	
	ELSE
	BEGIN
	UPDATE TM_TASK_TYPE SET DESCRIPTION ='DA_1099-MISC' WHERE name = '1099-MISC'
	
	   END
	

