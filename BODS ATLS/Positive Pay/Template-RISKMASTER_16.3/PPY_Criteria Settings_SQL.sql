--  Template-Positive Pay(Version rmA-12.2 to rmA-16.3)

delete from DATA_INTEGRATOR_TEMPLATES where MODULE_NAME='POSITIVE_PAY'
INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES((SELECT ISNULL(MAX(ROW_ID),0) FROM DATA_INTEGRATOR_TEMPLATES)+1,'POSITIVE_PAY','<POSITIVE_PAY><Positive_Pay_Type>EXPORT</Positive_Pay_Type><AccountLen /><BankFormat /><Account_ID /><ManuallyChangeDateRange /><From_Date /><To_Date /><Target_File /><Company_Name /><File_Format /><Destination_City /></POSITIVE_PAY>')
