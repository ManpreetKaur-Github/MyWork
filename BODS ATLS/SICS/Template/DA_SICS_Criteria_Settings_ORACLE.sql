--==========================================================
---SICS_Criteria_Settings_SQL
---Template_SICS(rmA17.1 onwards)
---mkaur24 JIRA RMA-34763 1/19/2017
--============================================================
DECLARE
XML_STRING CLOB;

BEGIN
XML_STRING := '<SICS><Target_File_Name></Target_File_Name><Export_Last_Run_Date></Export_Last_Run_Date><Specify_Date_Range></Specify_Date_Range><Date_From></Date_From><Date_To></Date_To></SICS>';

DELETE from DATA_INTEGRATOR_TEMPLATES where MODULE_NAME='SICS';
INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES ((NVL((SELECT MAX(ROW_ID) FROM DATA_INTEGRATOR_TEMPLATES),0) + 1), 'SICS', XML_STRING);
COMMIT;
END ; 
