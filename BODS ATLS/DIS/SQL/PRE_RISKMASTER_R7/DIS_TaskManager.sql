INSERT INTO TM_TASK_TYPE VALUES (((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE) + 1), 'DIS', 'DIS', '<Task Name=''DIS'' cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings')

