
--   Template_Positive Pay (rmA16.4 and above)

BEGIN

DELETE from DATA_INTEGRATOR_TEMPLATES where MODULE_NAME='POSITIVE_PAY';
INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES(NVL((SELECT MAX(ROW_ID) FROM DATA_INTEGRATOR_TEMPLATES),0) + 1,'POSITIVE_PAY','<POSITIVE_PAY><Positive_Pay_Type>EXPORT</Positive_Pay_Type><AccountLen /><BankFormat /><Account_ID /><ManuallyChangeDateRange /><From_Date /><To_Date /><Target_File /><Company_Name /><File_Format /><Destination_City /></POSITIVE_PAY>');
COMMIT;

END;
