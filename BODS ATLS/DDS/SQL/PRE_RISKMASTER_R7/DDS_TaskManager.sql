INSERT INTO TM_TASK_TYPE VALUES (((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE) + 1), 'DDS', 'DDS', '<Task Name=''DDS'' cmdline=''yes''><Path>DA_DDS.exe</Path></Task>', -1, 'DDSsettings')

