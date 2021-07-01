INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES ((ISNULL((SELECT MAX(ROW_ID) FROM DATA_INTEGRATOR_TEMPLATES),0) + 1),'POSITIVE_PAY','<POSITIVE_PAY><Positive_Pay_Type>EXPORT</Positive_Pay_Type><AccountLen /><BankFormat /><Account_ID /><ManuallyChangeDateRange /><From_Date /><To_Date /><Target_File /></POSITIVE_PAY>')

