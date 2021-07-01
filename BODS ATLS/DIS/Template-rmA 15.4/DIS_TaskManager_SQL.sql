-- ============================================================
--   Table:	TM_TASK_TYPE
--   Template-rmA 15.4_DIS
-- =============================================================

IF ((SELECT MAX(TASK_TYPE_ID) FROM TM_TASK_TYPE WHERE NAME='DIS') is null)INSERT INTO TM_TASK_TYPE VALUES((SELECT COUNT(*) FROM TM_TASK_TYPE)+1,'DIS', 'DIS', '<Task Name=''DIS'' cmdline=''yes''><Path>DA_DIS.exe</Path></Task>', -1, 'DISSettings')

IF (SELECT MAX(JOB_STATE_ID) FROM TM_JOB_STATE)<9 INSERT INTO TM_JOB_STATE VALUES (9,'Pending User Verification')