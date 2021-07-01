--   Template_Positive Pay (rmA16.4 and above)

DECLARE
var1 NUMBER;
var2 NUMBER;
var3 NUMBER;
BEGIN
select count(*) INTO var1 from TM_TASK_TYPE where name = 'PositivePay';
	if (var1 = 0) then
		BEGIN
    		select max (TASK_TYPE_ID) INTO var2 from TM_TASK_TYPE;
			if (var2 IS NULL) then
			  	var3 := 1;
      			ELSE
        				var3 := var2 + 1;
     			 END IF;
    		INSERT INTO TM_TASK_TYPE VALUES (var3 ,'PositivePay','DA_PositivePay','<Task Name=''PositivePay'' cmdline=''yes''><Path>DA_PPY.exe</Path></Task>',-1,'DAPositivePay');
		END;
	ELSE 
		BEGIN
		UPDATE TM_TASK_TYPE SET DESCRIPTION='DA_PositivePay' where name = 'PositivePay';
		
		END;
	  END IF;	
   	  COMMIT;  
END;