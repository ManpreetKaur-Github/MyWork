

-- ============================================================
--   Table:	DATA_INTEGRATOR_TEMPLATES
--   DATE:	 02/06/2017
--  Template_MEDEDI(rmA16.4 onwards)
-- ============================================================
declare itasktype number;
BEGIN
SELECT MAX(TASK_TYPE_ID) INTO itasktype FROM TM_TASK_TYPE WHERE NAME='EDI';
IF(itasktype is NULL) THEN 
		begin
		INSERT INTO TM_TASK_TYPE VALUES((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'EDI', 'DA_EDI', '<Task Name=''EDI'' cmdline=''yes''><Path>DA_EDI.exe</Path></Task>', -1, 'EDIsettings');
		end;
else 
		begin
    UPDATE TM_TASK_TYPE SET  DESCRIPTION = 'DA_EDI' WHERE NAME =  'EDI';
	--	delete  FROM TM_TASK_TYPE WHERE NAME='EDI';
	--	INSERT INTO TM_TASK_TYPE VALUES((Select NVL( max(TASK_TYPE_ID) , 0 ) + 1 FROM TM_TASK_TYPE),'EDI', 'DA_EDI', '<Task Name=''EDI'' cmdline=''yes''><Path>DA_EDI.exe</Path></Task>', -1, 'EDIsettings');
		end;

commit;
END IF;
END;