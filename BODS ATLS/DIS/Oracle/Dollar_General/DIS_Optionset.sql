declare irowid number;
BEGIN
select MAX(ROW_ID) INTO irowid FROM DATA_INTEGRATOR_TEMPLATES WHERE MODULE_NAME='DIS';
IF(irowid is NULL) THEN INSERT INTO DATA_INTEGRATOR_TEMPLATES VALUES ((Select COUNT(*) from data_integrator_templates) + 1,'DIS','<DIS><Verification_Flag></Verification_Flag><Number_of_Areas_Importing></Number_of_Areas_Importing><Employees_Flag></Employees_Flag><Employees_Import_Supp></Employees_Import_Supp><Employees_Match_Employee_ID></Employees_Match_Employee_ID><Employees_Update_Blank_Zero></Employees_Update_Blank_Zero><Employees_Update_Address_Blank_Zero></Employees_Update_Address_Blank_Zero><Employees_Create_New_Codes></Employees_Create_New_Codes><Employees_Match_Entity_Id></Employees_Match_Entity_Id><OrgHier_Flag></OrgHier_Flag><OrgHier_Import_Supp></OrgHier_Import_Supp><OrgHier_Update_Blank_Zero></OrgHier_Update_Blank_Zero><OrgHier_Create_New_Codes></OrgHier_Create_New_Codes><Funds_Flag></Funds_Flag><Funds_Import_Supp></Funds_Import_Supp><Funds_Open_Claims_Only></Funds_Open_Claims_Only><Funds_Match_Payee_Name></Funds_Match_Payee_Name><Funds_Match_Payee_Tax_Id></Funds_Match_Payee_Tax_Id><Funds_Create_New_Codes></Funds_Create_New_Codes><Funds_Check_Duplicate_Payments></Funds_Check_Duplicate_Payments><Funds_Accept_Duplicate_Check_Number></Funds_Accept_Duplicate_Check_Number><Funds_Import_Cleared_Payments></Funds_Import_Cleared_Payments><Funds_Match_Entity_Id></Funds_Match_Entity_Id><FundsDeposit_Flag></FundsDeposit_Flag><FundsDeposit_Update_Blank_Zero></FundsDeposit_Update_Blank_Zero><FundsDeposit_Create_New_Codes></FundsDeposit_Create_New_Codes><Vehicles_Flag></Vehicles_Flag><Vehicles_Import_Supp></Vehicles_Import_Supp><Vehicles_Update_Blank_Zero></Vehicles_Update_Blank_Zero><Vehicles_Create_New_Codes></Vehicles_Create_New_Codes><Entities_Flag></Entities_Flag><Entities_Import_Supp></Entities_Import_Supp><Entities_Update_Blank_Zero></Entities_Update_Blank_Zero><Entities_Create_New_Codes></Entities_Create_New_Codes><Entities_Match_By_TaxId></Entities_Match_By_TaxId><Entities_Match_By_Name></Entities_Match_By_Name><Entities_Match_By_Abbrev></Entities_Match_By_Abbrev><Policies_Flag></Policies_Flag><Policies_Import_Supp></Policies_Import_Supp><Policies_Create_New_Codes></Policies_Create_New_Codes><Reserves_Flag></Reserves_Flag><Reserves_Import_Supp></Reserves_Import_Supp><Reserves_Create_New_Codes></Reserves_Create_New_Codes><Reserves_Check_Duplicate_Reserves></Reserves_Check_Duplicate_Reserves><OrgExpo_Flag></OrgExpo_Flag><OrgExpo_Import_Supp></OrgExpo_Import_Supp><OrgExpo_New_Records_Only></OrgExpo_New_Records_Only><OrgExpo_Update_Blank_Zero></OrgExpo_Update_Blank_Zero><OrgExpo_Create_New_Codes></OrgExpo_Create_New_Codes><Patients_Flag></Patients_Flag><Patients_Import_Supp></Patients_Import_Supp><Patients_Validate_Data_Only></Patients_Validate_Data_Only><Patients_Match_Patient></Patients_Match_Patient><Patients_Create_New_Codes></Patients_Create_New_Codes><Patients_Match_Patient_Number></Patients_Match_Patient_Number><Physicians_Flag></Physicians_Flag><Physicians_Import_Supp></Physicians_Import_Supp><Physicians_Validate_Data></Physicians_Validate_Data><Physicians_Create_New_Codes></Physicians_Create_New_Codes><Physicians_Match_Physicians_Number></Physicians_Match_Physicians_Number><MedicalStaff_Flag></MedicalStaff_Flag><MedicalStaff_Import_Supp></MedicalStaff_Import_Supp><MedicalStaff_Validate_Data></MedicalStaff_Validate_Data><MedicalStaff_Create_New_Codes></MedicalStaff_Create_New_Codes><AdminTrack_Flag></AdminTrack_Flag><AdminTrack_Area>test</AdminTrack_Area><AdminTrack_Add_Update></AdminTrack_Add_Update><AdminTrack_Create_New_Codes></AdminTrack_Create_New_Codes><Diary_To_Users>test</Diary_To_Users></DIS>');
END IF;
END;