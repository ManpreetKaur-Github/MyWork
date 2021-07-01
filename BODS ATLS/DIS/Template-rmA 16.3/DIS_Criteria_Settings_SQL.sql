--==========================================================
--  DIS_Criteria_Settings_SQL
--  Template-rmA 16.3_DIS
--============================================================

DELETE FROM DATA_INTEGRATOR_TEMPLATES  WHERE MODULE_NAME='DIS'

INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES ((ISNULL((SELECT MAX(ROW_ID) FROM DATA_INTEGRATOR_TEMPLATES),0) + 1), 'DIS', '<DIS><Verification_Flag></Verification_Flag><chk2GBData></chk2GBData><txtBatchID></txtBatchID><Employees_Flag></Employees_Flag><OrgHier_Flag></OrgHier_Flag><Funds_Flag></Funds_Flag><FundsDeposit_Flag></FundsDeposit_Flag><Vehicles_Flag></Vehicles_Flag><Entities_Flag></Entities_Flag><Policies_Flag></Policies_Flag><Reserves_Flag></Reserves_Flag><OrgExpo_Flag></OrgExpo_Flag><Patients_Flag></Patients_Flag><Physicians_Flag></Physicians_Flag><MedicalStaff_Flag></MedicalStaff_Flag><AdminTrack_Flag></AdminTrack_Flag><Employees_Import_Supp></Employees_Import_Supp><Employees_Update_Blank_Zero></Employees_Update_Blank_Zero><Employees_Create_New_Codes></Employees_Create_New_Codes><Employees_Update_Address_Blank_Zero></Employees_Update_Address_Blank_Zero><Employees_Match_Employee_ID></Employees_Match_Employee_ID><Employees_Match_Entity_Id></Employees_Match_Entity_Id><OrgHier_Import_Supp></OrgHier_Import_Supp><OrgHier_Update_Blank_Zero></OrgHier_Update_Blank_Zero><OrgHier_Create_New_Codes></OrgHier_Create_New_Codes><Funds_Import_Supp></Funds_Import_Supp><Funds_Create_New_Codes></Funds_Create_New_Codes><Funds_Open_Claims_Only></Funds_Open_Claims_Only><Funds_Check_Duplicate_Payments></Funds_Check_Duplicate_Payments><Funds_Accept_Duplicate_Check_Number></Funds_Accept_Duplicate_Check_Number><Funds_Import_Cleared_Payments></Funds_Import_Cleared_Payments><Funds_Match_Payee_Name></Funds_Match_Payee_Name><Funds_Match_Payee_Tax_Id></Funds_Match_Payee_Tax_Id><Funds_Match_Payee_DOB></Funds_Match_Payee_DOB><Funds_Match_Entity_Id></Funds_Match_Entity_Id><Funds_Import_Multiple_Payees></Funds_Import_Multiple_Payees><FundsDeposit_Update_Blank_Zero></FundsDeposit_Update_Blank_Zero><FundsDeposit_Create_New_Codes></FundsDeposit_Create_New_Codes><Vehicles_Import_Supp></Vehicles_Import_Supp><Vehicles_Update_Blank_Zero></Vehicles_Update_Blank_Zero><Vehicles_Create_New_Codes></Vehicles_Create_New_Codes><Entities_Import_Supp></Entities_Import_Supp><Entities_Update_Blank_Zero></Entities_Update_Blank_Zero><Entities_Create_New_Codes></Entities_Create_New_Codes><Entities_Match_By_TaxId></Entities_Match_By_TaxId><Entities_Match_By_Name></Entities_Match_By_Name><Entities_Match_By_Abbrev></Entities_Match_By_Abbrev><Entities_Match_By_DOB></Entities_Match_By_DOB><Policies_Import_Supp></Policies_Import_Supp><Policies_Create_New_Codes></Policies_Create_New_Codes><Pol_Insured_EntityID></Pol_Insured_EntityID><Pol_Match_Insured_TaxID></Pol_Match_Insured_TaxID><Pol_Match_Insured_Name></Pol_Match_Insured_Name><Pol_Match_Insured_Abbrev></Pol_Match_Insured_Abbrev><Pol_Match_Insured_DOB></Pol_Match_Insured_DOB><Pol_Insurer_EntityID></Pol_Insurer_EntityID><Pol_Match_Insurer_TaxID></Pol_Match_Insurer_TaxID><Pol_Match_Insurer_Name></Pol_Match_Insurer_Name><Pol_Match_Insurer_Abbrev></Pol_Match_Insurer_Abbrev><Pol_Match_Insurer_DOB></Pol_Match_Insurer_DOB><Pol_Insured_Claimant></Pol_Insured_Claimant><Pol_Imprt_Add_Intrst></Pol_Imprt_Add_Intrst><Pol_Imprt_Add_Intrst_TaxID></Pol_Imprt_Add_Intrst_TaxID><Pol_Imprt_Add_Intrst_Name></Pol_Imprt_Add_Intrst_Name><Pol_Imprt_Add_Intrst_DOB></Pol_Imprt_Add_Intrst_DOB><Reserves_Create_New_Codes></Reserves_Create_New_Codes><Reserves_Check_Duplicate_Reserves></Reserves_Check_Duplicate_Reserves><OrgExpo_Import_Supp></OrgExpo_Import_Supp><OrgExpo_Update_Blank_Zero></OrgExpo_Update_Blank_Zero><OrgExpo_Create_New_Codes></OrgExpo_Create_New_Codes><OrgExpo_New_Records_Only></OrgExpo_New_Records_Only><Patients_Import_Supp></Patients_Import_Supp><Patients_Create_New_Codes></Patients_Create_New_Codes><Patients_Validate_Data_Only></Patients_Validate_Data_Only><Patients_Match_Patient_Number></Patients_Match_Patient_Number><Patients_Match_Patient></Patients_Match_Patient><Physicians_Import_Supp></Physicians_Import_Supp><Physicians_Create_New_Codes></Physicians_Create_New_Codes><Physicians_Validate_Data></Physicians_Validate_Data><Physicians_Match_Physicians_Number></Physicians_Match_Physicians_Number><MedicalStaff_Import_Supp></MedicalStaff_Import_Supp><MedicalStaff_Create_New_Codes></MedicalStaff_Create_New_Codes><MedicalStaff_Validate_Data></MedicalStaff_Validate_Data><AdminTrack_Create_New_Codes></AdminTrack_Create_New_Codes><AdminTrack_Area>test</AdminTrack_Area><AdminTrack_Add_Update></AdminTrack_Add_Update><AdminTrack_Match_Field></AdminTrack_Match_Field><Diary_To_Users>test</Diary_To_Users><Number_of_Areas_Importing></Number_of_Areas_Importing></DIS>')
