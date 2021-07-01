

	
					--****************** Common Insert Statements**********************--

	
INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES (1, 'The Required Field is empty. Please provide a valid value for this 
column . ', 'Y')
INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES  (2, 'The Codes cannot be found in the codes table.', 'Y')	
				
					
					--****************** EVENT Related Insert Statements**********************--

INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES  (3, 'Time Reported Must be greater than or equal to Event Time .', 'Y')
INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES (4, 'Date Reported Must be greater than or equal to Event Date . ', 'Y')
INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES (5, 'Please provide the date in the correct format i.e YYYYMMDD format 
.' , 'Y')
INSERT INTO  DDS_ERR_MESSAGES ( ERROR_MSG_ID , ERR_MESSAGE ,Status )  VALUES (6, 'Please provide the time in the correct format i.e hh:mm:ss format 
.' , 'Y')

					--****************** PAYMENTS Related Insert Statements**********************--

Insert into DDS_ERR_MESSAGES values(7,'If CLEAR_FLAG is set or CHECK_STATUS is V, then DATE_CLEARED cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(8,'Record Type Code Provided is Incorrect; Acceptable Values are G, W or V','Y')
Insert into DDS_ERR_MESSAGES values(9,'Transaction Type Code Provided is Incorrect; Acceptable Values are P, R or C','Y')
Insert into DDS_ERR_MESSAGES values(10,'Type Flag Code Provided is Incorrect; Acceptable Values are A, B, C or D','Y')
Insert into DDS_ERR_MESSAGES values(11,'Check Status Code Provided is Incorrect; Acceptable Values are V, P or H','Y')
Insert into DDS_ERR_MESSAGES values(12,'Payee Type Code Provided is Incorrect; Acceptable Values are P or E','Y')
Insert into DDS_ERR_MESSAGES values(13,'Payee Does not Exist in the Target RISKMASTER Database','Y')
Insert into DDS_ERR_MESSAGES values(14,'Payment Record For a Non-Existing Claim','Y')
Insert into DDS_ERR_MESSAGES values(15,'Duplicate Payment Record','Y')
Insert into DDS_ERR_MESSAGES values(16,'Reserve Record for a Unmapped Reserve Bucket','Y')
Insert into DDS_ERR_MESSAGES values(17,'Payment Record Attached to a Unmapped Reserve Bucket','Y')
Insert into DDS_ERR_MESSAGES values(18,'Loss or Disability Type Code is not attached to the Coverage','Y')
Insert into DDS_ERR_MESSAGES values(19,'Coverage Type is not attached to the Policy','Y')
Insert into DDS_ERR_MESSAGES values(20,'Unit Number is not attached to the Policy','Y')
Insert into DDS_ERR_MESSAGES values(21,'Unit Number does not not Exists in RMA','Y')
Insert into DDS_ERR_MESSAGES values(22,'Payment Record not linked to a valid Transaction Type Code','Y')
Insert into DDS_ERR_MESSAGES values(23,'Reserve Type Corresponding to this Payment TYPE_CODE Does not Match that from the Option Bucket','Y')
Insert into DDS_ERR_MESSAGES values(24,'Policy is not attached to the claim','Y')
Insert into DDS_ERR_MESSAGES values(25,'Policy does not exist in RiskMaster','Y')
Insert into DDS_ERR_MESSAGES values(26,'Duplicate Check Number','Y')
Insert into DDS_ERR_MESSAGES values(27,'Claim Record not matched in the database','Y')
Insert into DDS_ERR_MESSAGES values(28,'Claimant Tax ID is invalid','Y')
Insert into DDS_ERR_MESSAGES values(29,'Claimant number/suffix not exist in CLAIMANT table','Y')
Insert into DDS_ERR_MESSAGES values(30,'Claimant not found by name and tax ID','Y')
Insert into DDS_ERR_MESSAGES values(31,'Claimant SSN is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(32,'Payee Tax ID is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(33,'PI Tax ID is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(34,'Reported Tax ID is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(35,'Supervisor Tax ID is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(36,'Disability Plan number not exist','Y')
Insert into DDS_ERR_MESSAGES values(37,'Supervisor Tax ID is empty for Tax ID ONLY match','Y')
Insert into DDS_ERR_MESSAGES values(38,'MEMO_PHRASE value specified in the import file does not exist in RMA DB','Y')
Insert into DDS_ERR_MESSAGES values(39,'Value for field CLASS_CODE must exist for record type W','Y')
Insert into DDS_ERR_MESSAGES values(40,'Duplicate Reserve Error. Reserve History Record already Exist With Same Amount','Y')
Insert into DDS_ERR_MESSAGES values(41,'Transaction Sequence Number is mandatory field when Policy Interface Setting is ON','Y')
Insert into DDS_ERR_MESSAGES values(42,'Coverage Text field is mandatory field when Policy Interface Setting is ON','Y')
Insert into DDS_ERR_MESSAGES values(43,'Coverage Sequence Number field is mandatory field when Policy Interface Setting is ON','Y')
Insert into DDS_ERR_MESSAGES values(44,'Carrier Setting is ON but the Policy Interface Setting is OFF','Y')
Insert into DDS_ERR_MESSAGES values(45,'For record type Worker Compensation value of CLASS_DESC field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(46,'For record type Worker Compensation value of CLASS_CODE field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(47,'Value of LOSS_CODE,DISABILITY_CATEGORY field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(48,'Value of LOSS_CODE field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(49,'Value of COVERAGE_CODE field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(50,'For record type Non-Worker Compensation value of CVG_DESC field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(51,'For record type Non-Worker Compensation value of SUBLINE_DESC field cannot be empty','Y')
Insert into DDS_ERR_MESSAGES values(52,'Coverage type provided in the import file is not valid','Y')
Insert into DDS_ERR_MESSAGES values(53,'Disability Category provided in the import file is not valid','Y')
Insert into DDS_ERR_MESSAGES values(54,'Disability Type Code provided in the import file is not valid','Y')
Insert into DDS_ERR_MESSAGES values(55,'Loss Code provided in the import file is not valid','Y')
Insert into DDS_ERR_MESSAGES values(56,'Claimant Suffix value cannot be blank for General Claims. It’s a mandatory field for GC claims','Y')
Insert into DDS_ERR_MESSAGES values(57,'Claimant already exist for the concerned claim','Y')
Insert into DDS_ERR_MESSAGES values(58,'Claimant Suffix Already Used','Y')
Insert into DDS_ERR_MESSAGES values(59,'Neither TYPE_FLAG nor RESERVE_TYPE field has been populated','Y')
Insert into DDS_ERR_MESSAGES values(60,'Given value of RESERVE_TYPE is not a valid value','Y')




