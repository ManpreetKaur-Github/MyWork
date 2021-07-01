--  Template-Positive Pay(Version rmA-12.2 to rmA-16.3)

declare @var1 int
declare @var2 int
declare @var3 int
set @var1 = (select count(*) from TM_TASK_TYPE where name = 'PositivePay')
	if @var1 = 0
	BEGIN
		set @var2 =  (select max (TASK_TYPE_ID) from TM_TASK_TYPE)
			if @var2 IS NULL
			BEGIN
				set @var3 = 1
				INSERT INTO TM_TASK_TYPE VALUES (@var3 ,'PositivePay','DA_PositivePay','<Task Name=''PositivePay'' cmdline=''yes''><Path>DA_PPY.exe</Path></Task>',-1,'DAPositivePay')
				
			END
			ELSE 
			BEGIN
				set @var3 = @var2 + 1
				INSERT INTO TM_TASK_TYPE VALUES (@var3 ,'PositivePay','DA_PositivePay','<Task Name=''PositivePay'' cmdline=''yes''><Path>DA_PPY.exe</Path></Task>',-1,'DAPositivePay')
				
			END
	END	
	ELSE
	BEGIN
	UPDATE TM_TASK_TYPE SET DESCRIPTION='DA_PositivePay' WHERE NAME='PositivePay'
	
	END	
