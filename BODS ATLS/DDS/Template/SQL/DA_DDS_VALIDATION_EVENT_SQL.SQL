
/****** Object:  StoredProcedure [dbo].[DA_DDS_EVENT_IMPORT]    Script Date: 2/8/2016 2:29:04 PM ******/
IF OBJECT_ID('DA_DDS_EVENT_IMPORT','P') IS NOT NULL
	DROP PROCEDURE DA_DDS_EVENT_IMPORT
GO


CREATE PROCEDURE [dbo].[DA_DDS_EVENT_IMPORT]
	@p_jobID	INT ,
    @p_DBName  varchar(255) , --mkaur24  
	@p_USERID INT 
WITH EXECUTE AS CALLER
AS
BEGIN
--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_VALIDATE_EVENT PROCEDURE STARTS ************************************************************************
--*************************************************************************************************************************************************************																																					   ****

	--		Declaration of  OptionSet Variables, Event Record Variables, CODE_ID Variables, Other Local Variables 	                                           ****
	--	`	Fetching values from DDS_OPTIONSET Table from Staging																							   ****	
	--		Fetching carrier flag, date of loss settings, entity role settings from RISKMASTER																   ****	
	--		Total Rows from DDS_EVENT corresponding to current JOBID																						   ****	
	--		Cursor declaration, start to fetch values from DDS_EVENT Staging Table																			   ****
	--		Initialization of Variables to default values for each New Event Record 
		
		-----****************** 1. EVENT VALIDATION STARTS ***************------------------					
	--	REQUIRED FIELD VALIDATIONS, TAX_ID FIELDS VALIDATION,FLAG VALIDATION,CODE VALIDATION,DATE FORMAT VALIDATION,TIME FORMAT VALIDATION,DATE AND TIME VALIDATION,	
	--  STATE VALIDATION   ,DISABILITY_CODE VALIDATION ,DEPARTMENT / DEPT_INVOLVED / OSHA_ESTAB_EID COMBINED /DEPT_ASSIGNED/FACILITY_DEPT,CREATE NEW DEPARMENT,
	--  REPORTER ENTITY (PROCESS ENTITY)	
    	-----****************** 1. EVENT VALIDATION ENDS ***************---------------------		
	
		-----****************** 2.PERSON INVOLVED VALIDATION STARTS ***************----------			
	--  CREATE_PI_ENT_IF_TAXID_EMPTY IF EID = 0 (PROCESS ENTITY) THEN PASS ERROR , Taxid error check,
	--  CrtNwEvntPiEntyIfTxIDEmpty,HOSPITAL AND PHYS_EID VALIDATION,
	--  PHYS_EID PROCESS ENTITY AND ERROR LOGGING ,WORK LOSS , PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR,
	--  CHECK EXISTENCE AND LOG ERROR IF EMPLOYEE NO. ATTACHED TO SOME OTHER ENTITY
	--  IF FLAG NULL GET VALUE FROM SYS_PARMS , DATA MANUPULATION STARTS ,IF FLAG Y/N SET  VALUES,
    --  RMDB Existence of Employee (@PI_TYPE_ENTITY_ID_GEN) TO LOG AN ERROR		    		
		-----****************** 2.PERSON INVOLVED VALIDATION ENDS ***************------------	

	-----****************** 3.EMPLOYEE VALIDATION ENDS ***************-------------------	
	--   SUPERVISOR DOES NOT EXISTS AS AN EMP SO, INSERT /CREATE SUPERVISOR (ELSE IF IT EXISTS DO NOTHING)
	--   RMDB Existence of Employee
	--   Insert / Update Employee			
		----******************  3.EMPLOYEE VALIDATION ENDS ***************-------------------		
		
		----******************  4.Supplemental Validation call  ***************--------------		
	
	--***********************************************************************************************************************
--*****If there is any Validation Error till now then Procedure will fetch NEXT record and will log errors corresponding to current record.			   ****
	--***********************************************************************************************************************
									----------------------
									--IMPORT PART STARTS--
									----------------------
									
		----******************  5. IMPORT EVENT STARTS ***************-------------------			
	--  IMPORT DATA MANUPULATION  
    --  INSERT / UPDATE EVENT
    --  UPDATE REPORTER ENTITY IN ENTITY TABLE
	--  ACTION / OUTCOME EXISTENCE IN RMDB followed by Insert	
    --  EVENT_X_OSHA|FALL_INDICATOR EXISTENCE IN RMDB  followed by Insert   
		----******************  5. IMPORT EVENT ENDS ***************-------------------
		
		----******************  6. PERSON INVOLVED and its Related tables INSERT STARTS ***************-------------------
    --  RMDB EXISTENCE OF PERSON_INVOLVED	
	--  TABLE INSERT STARTS  TABLE INSERT STARTS commom  
	--  INSERT into PI table WHEN   PI_TYPE_CODE 'P'  
	--	INSERT into PI table WHEN   PI_TYPE_CODE IS WITNESS	  
	--	INSERTION INTO RELATED TABLES AND PI WHEN PI TYPE IS P/E  : - PI_X_HOSPITAL|PI_X_PHYSICIAN ,
	--	INSERTION INTO PHYSICIAN WHEN   PI_TYPE_CODE IS 'PHYS'
	--	INSERTION INTO PATIENT AND PATIENT_RELATED TABLES  WHEN   PI_TYPE_CODE IS 'P'
		----******************  6. PERSON INVOLVED and its Related tables INSERT ENDS ***************-------------------

		----******************  7. PERSON INVOLVED and its Related tables COMMON STARTS ***************-------------------
   --   INSERT INTO PI when  PI_TYPE_CODE 'E'  
   --	Existence Checked  and INSERT INTO PI_X_WORK_LOSS INSERT (because of above condition)
   --	Existence Checked  and INSERT INTO RLATED TABLES (because of above condition)( BODY_PART|DIAGNOSIS|TREATMENT|)  
   --	Existence Checked  and INSERT INTO ILLNESS /INJURY INSERT (because of above condition) 
		----******************  7. PERSON INVOLVED and its Related tables COMMON  ENDS ***************-------------------
			
		----******************  8. UPDATE PI DATA IN ENTITY  ***************-------------------
		
		----******************  9. Supplemtal Insert Call STARTS  ***************-------------------																									  		
   --   Supplemtal Insert Call  FOR EVENT ONLY
   --   Supplemtal Insert Call FOR EMP
   --	Supplemtal Insert Call FOR PATIENT 
		----******************  9. Supplemtal Insert Call ENDS  ***************-------------------	  																												   	
	
																								   				 	
--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_VALIDATE_EVENT PROCEDURE ENDS ************************************************************************
--*************************************************************************************************************************************************************																																					   ****

--BEGIN TRY

SET NOCOUNT ON
DECLARE @TOTALROWS INT;


BEGIN										 -- VARIABLES for criterion settings 
								   
		DECLARE @CheckCreateNewCodes AS SMALLINT;
		DECLARE @CheckCreateNewEmployees AS SMALLINT;
		DECLARE @CheckCreateNewDEPARTMENT AS SMALLINT;	
		DECLARE @EmployeeMatchByName AS SMALLINT;
		DECLARE @EmployeeMatchByTaxId AS SMALLINT;
		DECLARE @EmployeeMatchByEmpNumber AS SMALLINT;
		DECLARE @NonEmployeeMatchByName AS SMALLINT;
		DECLARE @NonEmployeeMatchByTaxId AS SMALLINT;		
		DECLARE @CrtNwEvntPiEntyIfTxIDEmpty AS SMALLINT;
		DECLARE @CONFIG_ID AS SMALLINT;
		DECLARE @EVENT_SUPP AS SMALLINT;  -- @CreateNewEventPiEntityIfTaxIDEmpty
		DECLARE @VALID_START_DATE AS varchar (8);
		DECLARE @VALID_END_DATE AS varchar (8);
		
		--dsharma70 hmi	
		DECLARE @EmployeeMatchByDOB as SMALLINT,
		@NonEmployeeMatchByDOB as SMALLINT

END		
BEGIN 										 -- VARIABLES FOR CODE RELATED VALIDATION 
		DECLARE @CODE_ID_R as int ;
		DECLARE @EVENT_STATUS_CODE_R as int ;
		DECLARE @EVENT_IND_CODE_R as int ;
		DECLARE @LOCATION_TYPE_CODE_R as int ;
		DECLARE @CAUSE_CODE_R as int ;
		DECLARE @PRIMARY_LOC_CODE_R as int ;
		DECLARE @EVENT_TYPE_CODE_R as int ; 
		DECLARE @ACTION_1_CODE_R 	as int ;
		DECLARE @ACTION_2_CODE_R  	AS INT ;
		DECLARE @ACTION_3_CODE_R  	AS INT ;
		DECLARE @ACTION_4_CODE_R  	AS INT ;
		DECLARE @ACTION_5_CODE_R  	AS INT ;
		DECLARE @OUTCOME_1_CODE_R  	AS INT ;
		DECLARE 	@OUTCOME_2_CODE_R  	AS INT ;
		DECLARE 	@OUTCOME_3_CODE_R  	AS INT ;
		DECLARE 	@OUTCOME_4_CODE_R  	AS INT ;
		DECLARE 	@OUTCOME_5_CODE_R  	AS INT ;		
		DECLARE 	@MARITAL_STAT_CODE_R 	AS INT ;
		DECLARE 	@SEX_CODE_R 	AS INT ;
		DECLARE 	@INJURY_1_CODE_R  	AS INT ;
		DECLARE 	@INJURY_2_CODE_R  	AS INT ;
		DECLARE 	@INJURY_3_CODE_R  	AS INT ;
		DECLARE 	@INJURY_4_CODE_R  	AS INT ;
		DECLARE 	@INJURY_5_CODE_R  	AS INT ;
		DECLARE 	@BODY_PART_1_CODE_R 	AS INT ;
		DECLARE 	@BODY_PART_2_CODE_R  	AS INT ;
		DECLARE 	@BODY_PART_3_CODE_R  	AS INT ;
		DECLARE 	@BODY_PART_4_CODE_R  	AS INT ;
		DECLARE 	@BODY_PART_5_CODE_R  	AS INT ;
		DECLARE 	@DIAGNOSIS_1_CODE_R  	AS INT ;
		DECLARE 	@DIAGNOSIS_2_CODE_R  	AS INT ;
		DECLARE 	@DIAGNOSIS_3_CODE_R  	AS INT ;
		DECLARE 	@DIAGNOSIS_4_CODE_R  	AS INT ;
		DECLARE 	@DIAGNOSIS_5_CODE_R  	AS INT ;
		DECLARE 	@TREATMENT_1_CODE_R  	AS INT ;
		DECLARE 	@TREATMENT_2_CODE_R  	AS INT ;
		DECLARE 	@TREATMENT_3_CODE_R  	AS INT ;
		DECLARE 	@TREATMENT_4_CODE_R  	AS INT ;
		DECLARE 	@TREATMENT_5_CODE_R  	AS INT ;
		DECLARE 	@DRIVERSLICTYPECODE_R 	AS INT ;
		DECLARE 	@DRIVLIC_RSTRCT_CODE_R 	AS INT ;
		DECLARE 	@NCCI_CLASS_CODE_R 	AS INT ;
		DECLARE 	@ADM_TYPE_CODE_R 	AS INT ;
		DECLARE 	@ADM_SOURCE_CODE_R 	AS INT ;
		DECLARE 	@ACUITY_LEVEL_CODE_R 	AS INT ;
		DECLARE 	@PATIENT_STAT_CODE_R 	AS INT ;
		DECLARE 	@PATIENT_COND_CODE_R 	AS INT ;
		DECLARE 	@DISCHARGE_DSP_CODE_R 	AS INT ;
		DECLARE 	@PATIENT_TYPE_CODE_R 	AS INT ;
		DECLARE 	@FACILITY_UNIT_CODE_R 	AS INT ;
		DECLARE 	@DISABILITY_CODE_R 	AS INT ;
		DECLARE 	@POSITION_CODE_R 	AS INT ;
		DECLARE 	@PAY_TYPE_CODE_R 	AS INT ;
		DECLARE 	@COND_PRIOR_CODE_R 	AS INT ;
		DECLARE 	@RAIL_POSITION_CODE_R 	AS INT ;
		DECLARE 	@RESTRAINT_CODE_R 	AS INT ;
		DECLARE 	@BED_POSITION_CODE_R 	AS INT ;
		DECLARE 	@ILLNESS_CODE_R 	AS INT ;		
		DECLARE		@NAME_TYPE_R AS INT ;
		DECLARE		@SHARPS_OBJECT_R AS INT ;
		DECLARE		@SHARPS_BRAND_MAKE_R AS INT ;
		DECLARE		@RULES_NOT_FOLLOWED_R AS INT ;
		DECLARE		@SAFEG_PROVIDED_R AS INT ;
		DECLARE		@CALL_LIGHT_CODE_R AS INT ;
		DECLARE		@REPORTED_COUNTRY_R AS INT ;
		DECLARE		@QI_SIGNIF_CODE_R AS INT ;
		DECLARE		@COUNTRY_R AS INT ;
		DECLARE		@STATE_R   AS INT ;
		DECLARE 	@PI_TYPE_CODE_R 	AS INT ;		
		DECLARE     @SEX_CODE_CODE_R	AS INT ;		
		DECLARE		@DRIVLIC_STATE_R AS INT ;
		DECLARE     @BENEFICIARY_CODE_ID AS INT; --Dsharma70 hmi
		DECLARE     @HEALTH_LOB_ID AS INT = 0;--Dsharma70 hmi
END
BEGIN										 -- OTHER  VARIBALES				
		DECLARE @I_ERRORCOUNT AS INT;
			SET @I_ERRORCOUNT = 0;

		DECLARE @I_ROWCOUNT AS INT;
			SET @I_ROWCOUNT = 0;
			
		DECLARE @V_MODULENAME VARCHAR(100);
			SET @V_MODULENAME = 'EVENT';

		DECLARE @V_PROCNAME AS VARCHAR(30);
			SET @V_PROCNAME = 'DDS_VALIDATE_EVENT';

			
		DECLARE  @V_CLOCATION AS VARCHAR(30);
		DECLARE	  @N_SQL AS NVARCHAR(MAX);

		
		DECLARE @I_COUNT AS INT ;
			set @I_COUNT = 0 ;

		DECLARE @V_DBName  AS VARCHAR(255) ;
		IF @p_DBName IS NOT NULL 
			BEGIN
				SET @V_DBName = '[' + @p_DBName + '].[DBO].';
			END

		
		DECLARE @I_STATEID_GEN AS INT  = 0;				 
		DECLARE @V_DTTM_RCD_ADDED_GEN AS VARCHAR(255) ;
		SET @V_DTTM_RCD_ADDED_GEN = NULL ;
		DECLARE @V_DTTM_RCD_LAST_UPD_GEN AS VARCHAR(255) ;
		SET @V_DTTM_RCD_LAST_UPD_GEN = NULL ;
		DECLARE @V_UPDATED_BY_USER AS VARCHAR(25) ; 
			SET @V_UPDATED_BY_USER = NULL ;
		DECLARE @V_ADDED_BY_USER AS VARCHAR(25);
			SET @V_ADDED_BY_USER = NULL ;
		DECLARE @V_NEXT_UNIQUE_ID AS VARCHAR(255) ; 
		SET @V_NEXT_UNIQUE_ID = 0 ;
		DECLARE @N_SQL_EVENT AS NVARCHAR(MAX) ;
			SET @N_SQL_EVENT = 0 ;
		DECLARE @V_ORGSEC_FLAG AS INT ;
			SET @V_ORGSEC_FLAG = 0 ;
		DECLARE @V_SEC_DEPT_EID INT ;
			SET @V_SEC_DEPT_EID = 0 ;		
		DECLARE @vReqColumns VARCHAR (255);
			SET @vReqColumns = NULL ;
		DECLARE @vCodeFieldList varchar(MAX) ;
			SET @vCodeFieldList = NULL ;			
		DECLARE @vSysTableNameList varchar(MAX) ;	
			SET @vSysTableNameList = NULL ;
		DECLARE @iPos AS INT ;
			SET @iPos = 0 ;
		DECLARE @vColName as varchar(100);
			SET @vColName = NULL ;
		DECLARE @nSql as nvarchar(Max);
			SET @nSql = NULL ;
		DECLARE @vColList as varchar(max);
			SET @vColList = NULL ;
		DECLARE @iCount int ;
			SET @iCount = 0 ;
		DECLARE @vVal as varchar(255);
			SET @vVal = NULL ;
		DECLARE @vTableList as varchar(max);
			SET @vTableList = NULL ;
		DECLARE @vTableName as varchar(100);
			SET @vTableName = NULL ;
		DECLARE @vColToProcess as varchar(255) ;
			SET @vColToProcess = NULL ;
		DECLARE @vTab as varchar (255) ;
			SET @vTab = NULL ;
		DECLARE @vTabToProcess  as varchar (max) ;
			SET @vTabToProcess = NULL ;
		DECLARE @vColInRM as varchar (255); 
			SET @vColInRM = NULL ;				
		DECLARE @vColName_value AS INT ;
			SET @vColName_value = 0 ;
		--***********  FLAGS ********************
		DECLARE @I_ON_PREMISE_FLAG_GEN AS INT ;
		SET @I_ON_PREMISE_FLAG_GEN = 0 ;
		DECLARE @I_DEPT_HEAD_ADVISED_GEN  AS INT ;
		SET @I_DEPT_HEAD_ADVISED_GEN = 0 ;
		DECLARE @I_RELEASE_SIGNED_GEN AS INT ;
		SET @I_RELEASE_SIGNED_GEN = 0 ;
		DECLARE @I_TREATMENT_GIVEN_GEN AS INT ;
		SET @I_TREATMENT_GIVEN_GEN = 0 ;
		DECLARE	@I_NO_RULES_FLAG_GEN AS INT ;
		SET @I_NO_RULES_FLAG_GEN = 0 ;
		DECLARE @I_RECORDABLE_FLAG_GEN AS INT ;
		SET @I_RECORDABLE_FLAG_GEN = 0 ;
		DECLARE	@I_SAFEG_NOTUSED_GEN AS INT ;
		SET @I_SAFEG_NOTUSED_GEN = 0 ;
		DECLARE	@I_SAFEGUARD_FLAG_GEN AS INT ;
		SET @I_SAFEGUARD_FLAG_GEN = 0 ;
		DECLARE	@I_PRIVACY_CASE_GEN AS INT ;
		SET @I_PRIVACY_CASE_GEN = 0 ;
		DECLARE @v_WORK_SUN_FLAG_GEN AS INT ;
		SET @v_WORK_SUN_FLAG_GEN = 0 ;
		DECLARE @v_WORK_MON_FLAG_GEN AS INT ;
		SET @v_WORK_MON_FLAG_GEN = 0 ;
		DECLARE @v_WORK_TUE_FLAG_GEN AS INT ;
		SET @v_WORK_TUE_FLAG_GEN = 0 ;
		DECLARE @v_WORK_WED_FLAG_GEN AS INT ;
		SET @v_WORK_WED_FLAG_GEN = 0 ;
		DECLARE @v_WORK_THU_FLAG_GEN AS INT ;
		SET @v_WORK_THU_FLAG_GEN = 0 ;	
		DECLARE @v_WORK_FRI_FLAG_GEN AS INT ;
		SET @v_WORK_FRI_FLAG_GEN = 0 ;
		DECLARE @v_WORK_SAT_FLAG_GEN AS INT ;
		SET @v_WORK_SAT_FLAG_GEN = 0 ;
		DECLARE @v_FULL_TIME_FLAG_GEN	AS INT ;	 -- JJ
		SET @v_FULL_TIME_FLAG_GEN = 0 ;
		DECLARE @v_ACTIVE_FLAG_GEN AS INT ;
		SET @v_ACTIVE_FLAG_GEN = 0 ;
		DECLARE @v_EXEMPT_STATUS_FLAG_GEN AS INT ;
		SET @v_EXEMPT_STATUS_FLAG_GEN = 0 ;
		DECLARE @v_INSURABLE_FLAG_GEN AS INT ;
		SET @v_INSURABLE_FLAG_GEN = 0 ;
		DECLARE @v_REGULAR_JOB_FLAG_GEN AS INT ;
		SET @v_REGULAR_JOB_FLAG_GEN = 0 ;
		DECLARE @v_HIRED_IN_STATE_FLAG_GEN  AS INT ;
		SET @v_HIRED_IN_STATE_FLAG_GEN  = 0 ;
		DECLARE @v_LOST_WORK_FLAG_GEN AS INT ;
		SET @v_LOST_WORK_FLAG_GEN = 0 ;
		--******Dept_Existence Flag**************		
		DECLARE @i_DEPARTMENT_GEN  AS INT ; 
		SET @i_DEPARTMENT_GEN = 0 ;   -- MKAUR24 1/11 START
		DECLARE @i_DEPT_INVOLVED_GEN AS INT ;
		SET @i_DEPT_INVOLVED_GEN = 0 ;
		DECLARE @i_DEPT_ASSIGNED_GEN AS INT ;
		SET @i_DEPT_ASSIGNED_GEN = 0;
		DECLARE @i_FACILITY_DEPT_GEN AS INT ; 
		SET @i_FACILITY_DEPT_GEN = 0 ;
		DECLARE	@i_OSHA_ESTAB_EID_GEN AS INT ;
		SET @i_OSHA_ESTAB_EID_GEN = 0 ;  -- MKAUR24 1/11 END
		--******UPDATE FLAGS *****
		DECLARE @i_UPDATE_FLAG_PI AS INT ;
		
		DECLARE @i_UPDATE_FLAG_SUPERVISOR AS INT ;
		DECLARE @i_UPDATE_FLAG AS INT ;
		DECLARE	@i_UPDATE_FLAG_EMP  AS INT ;
		DECLARE @I_UPDATE_FLAG_EVENT AS INT ;
		
		
		--*** Genrated ID's **********
		DECLARE @i_PI_ROW_ID AS INT ;
		SET  @i_PI_ROW_ID = 0 ;
		DECLARE	@i_ENTITY_ID  AS INT ;
		SET  @i_ENTITY_ID = 0 ;
		DECLARE @i_EVENT_ID AS INT ;
		SET  @i_EVENT_ID = 0 ;
		DECLARE @i_PATIENT_ID_GEN AS INT ;	
		SET  @i_PATIENT_ID_GEN = 0 ;	
		DECLARE @i_PI_TYPE_ENTITY_ID_GEN AS INT ;
		SET  @i_PI_TYPE_ENTITY_ID_GEN = 0 ;			
		DECLARE @i_SUPERVISOR_ENTITY_ID_GEN AS INT ; 
		SET  @i_SUPERVISOR_ENTITY_ID_GEN = 0 ;		
		DECLARE @i_PRI_PHYSICIAN_EID_GEN AS INT ; 
		SET  @i_PRI_PHYSICIAN_EID_GEN = 0 ;
		DECLARE @i_ADM_PHYSICIAN_EID_GEN AS INT ;
		SET   @i_ADM_PHYSICIAN_EID_GEN = 0;
		--** Hospital / Physician VD RELATED VARIEABLES
		DECLARE @vColName1 VARCHAR (255);
		SET @vColName1 = NULL ;
		DECLARE @vColName2 VARCHAR (255);	
		SET @vColName2 = NULL ;
		DECLARE @vColName3 VARCHAR (255);
		SET @vColName3 = NULL ;
		DECLARE @vVal2 VARCHAR (255);
			SET @vVal2 = NULL ;
		DECLARE @vColName4 VARCHAR (255) ;
		SET @vColName4 = NULL ;
		DECLARE @vVal3 VARCHAR (255) ;
		SET @vVal3 = NULL ;
		DECLARE @i_HOSPITAL_1_EID AS INT ;		
		SET @i_HOSPITAL_1_EID = 0 ;
		DECLARE @i_HOSPITAL_2_EID AS INT ;
		SET @i_HOSPITAL_2_EID = 0 ;
		DECLARE @i_HOSPITAL_3_EID AS INT ;
		SET @i_HOSPITAL_3_EID = 0 ;
		DECLARE @i_PHYSICIAN_1_EID AS INT ;
			SET @i_PHYSICIAN_1_EID = 0 ;
		DECLARE @i_PHYSICIAN_2_EID AS INT ;
			SET @i_PHYSICIAN_2_EID = 0 ;
		DECLARE @i_PHYSICIAN_3_EID AS INT ;
			SET @i_PHYSICIAN_3_EID = 0 ;
		--*** Process Entity *******
		DECLARE @Person AS  tEntity ;
		DECLARE	@Department AS tORG_HIERARCHY  ;
		DECLARE @iEntId INT ;
		DECLARE @V_ERROR_MESSAGE VARCHAR (MAX)	; 
			SET @V_ERROR_MESSAGE =  NULL ;
		DECLARE @i_Reporter_ENTITY_ID_GEN AS INT ;
		
		SET @i_Reporter_ENTITY_ID_GEN  = 0 ; --MKAUR24 1/11
		--**** STATE VARIABLE********]
		DECLARE		@v_STATE_R AS INT ;
		SET @v_STATE_R =  0 ;
		DECLARE		@v_REPORTED_STATE_R AS INT ;
		SET @v_REPORTED_STATE_R =  0 ;
		DECLARE		@v_PI_STATE_R AS INT ;
		SET @v_PI_STATE_R =  0 ;
		DECLARE	@v_DRIVLIC_STATE_R AS INT ;
		SET @v_DRIVLIC_STATE_R =  0 ;
		DECLARE	@v_SUPER_STATE_R AS INT ;
		SET @v_SUPER_STATE_R =  0 ;
		DECLARE		@STATE_ROW_ID_R AS INT ;
		SET @STATE_ROW_ID_R =  0 ;
		---****WORKLOASS FLAG *****
		DECLARE @i_PI_WL_ROW_ID AS INT ;
		SET @i_PI_WL_ROW_ID =  0 ;
		DECLARE @vColToProcess2 AS VARCHAR (MAX)
			SET @vColToProcess2 =  NULL ;			
		DECLARE	@iCount2 AS INT ;
		SET @iCount2 =  0 ;
		Declare @iCodeId AS INT ;
		SET @iCodeId =  0 ;
		
		---AFTER UNITTESTING ADDED ------ MKAUR24 1/11/2016 START
		DECLARE  @v_TIME_OF_EVENT_INVALID AS INT ; 
		SET @v_TIME_OF_EVENT_INVALID =  0 ;
		DECLARE  @v_TIME_REPORTED_INVALID AS INT ;
		SET @v_TIME_REPORTED_INVALID = 0 ;	 
		DECLARE @V_DATE_REPORTED_INVALID AS INT ;
		SET @V_DATE_REPORTED_INVALID = 0 ;
		DECLARE @V_DATE_OF_EVENT_INVALID AS INT ;  
 SET @V_DATE_OF_EVENT_INVALID = 0 ; 
  DECLARE @V_DATE_OF_DEATH_INVALID   AS INT ; 
 SET @V_DATE_OF_DEATH_INVALID   = 0 ;
 
   DECLARE @V_DATE_HIRED_INVALID     AS INT ; 
 SET @V_DATE_HIRED_INVALID     = 0 ;
		Declare @vTableToProcess AS varchar (255) ;
		SET @vTableToProcess = NULL ;
		Declare @i_EMPLOYEE_EID AS INT ; -- mkaur24 1/13
		SET @i_EMPLOYEE_EID = 0 ;
		Declare @i_EVENT_ID_O AS INT ;
		SET @i_EVENT_ID_O = 0 ;
		Declare @i_PI_ROW_ID_OP AS INT ;
			SET @i_PI_ROW_ID_OP = 0 ;
		DECLARE @i_Phys_EID_O AS INT ;
		SET @i_Phys_EID_O = 0 ;
	  	Declare @i_PATIENT_EID AS INT ;
	  	SET @i_PATIENT_EID = 0 ;
		Declare @i_EMPLOYEE_EID_UPDATE AS INT ;
			SET @i_EMPLOYEE_EID_UPDATE = 0 ;			
		Declare @i_EMPLOYEE_EID_EN as int ;
		SET @i_EMPLOYEE_EID_EN = 0 ;
		DECLARE @P_SUPP_ERROR_COUNT_R INT 
		SET @P_SUPP_ERROR_COUNT_R = 0 ;
		DECLARE @vVal4 AS VARCHAR (255) ;
		SET @vVal4 = 0 ;
		DECLARE @i_CheckNext AS INT ;
		SET @i_CheckNext = 0;
		DECLARE @vColToProcess1 AS VARCHAR (255) ;
		SET @vColToProcess1 = 0;
		DECLARE @V_ERROR_LOCATION VARCHAR (255);
		DECLARE @V_ERROR_LOCATION_MAIN VARCHAR (255);
		DECLARE @i_NOTHING AS INT = 0 ;		
		DECLARE @Forcecreate as int = 0;
		DECLARE @iRoleTableid INT = 0;
		DECLARE @i_DELETED_FLAG AS INT ; 
		SET @i_DELETED_FLAG = 0 ;	--mkaur24 MK
		DECLARE @iEidForDept int = 0;
		DECLARE @V_ERROR_COLUMN AS VARCHAR (255);
		DECLARE @iNoError INT;
		DECLARE @ErrorColumn Varchar (255); --mkaur24
		DECLARE @iSuperVisorError INT;	--knakra latest
		DECLARE @iRptdTidErr INT = 0;	--knakra latest
		DECLARE @iPiTidErr INT = 0;	--knakra latest
		DECLARE @iSvTidErr INT =0;	--knakra latest
		DECLARE @V_GETDATE VARCHAR (8);
		DECLARE @V_DURATION INT = NULL ;
		Declare @iROW_ID int = 0 ;

			--SET @V_ERROR_COLUMN = NULL;
	END		--OTHER
BEGIN										 -- VARIABLES for EVENT  Column 
			DECLARE @v_JOBID int ;	
			DECLARE @v_DA_ROW_ID int ;	
			DECLARE @v_INVALID_ROW int ;	
			DECLARE @v_UPDATE_ROW int ;	        
			DECLARE @v_INPUT_ROW_ID int ;	
			DECLARE @v_EVENT_NUMBER varchar(25)  ;             	
			DECLARE @v_EVENT_TYPE_CODE	varchar(25);
			DECLARE @v_EVENT_STATUS_CODE	varchar(25);
			DECLARE @v_EVENT_IND_CODE	varchar(25);
			DECLARE @v_EVENT_DESCRIPTION	varchar(max);
			DECLARE @v_BRIEF_DESCRIPTION	varchar(250);
			DECLARE @v_DEPARTMENT	varchar(25);
			DECLARE @v_DEPT_INVOLVED	varchar(25);
			DECLARE @v_ADDR1	varchar(100);
			DECLARE @v_ADDR2	varchar(100);
			DECLARE @v_CITY	varchar(50);
			DECLARE @v_STATE	varchar(4);
			DECLARE @v_ZIP_CODE	varchar(10);
			DECLARE @V_COUNTRY	varchar (20);
			DECLARE @V_COUNTY_OF_INJURY	varchar(50);          ----21SEP
			DECLARE @v_LOCATION_AREA_DESC	varchar(max);
			DECLARE @v_PRIMARY_LOC_CODE	varchar(25);
			DECLARE @v_LOCATION_TYPE_CODE	varchar(25);
			DECLARE @v_ON_PREMISE_FLAG	varchar(1);
			DECLARE @v_NO_OF_INJURIES	int;
			DECLARE @v_NO_OF_FATALITIES	int;
			DECLARE @v_CAUSE_CODE	varchar(25);
			DECLARE @v_DATE_OF_EVENT	varchar(8);
			DECLARE @v_TIME_OF_EVENT	varchar(6);
			DECLARE @v_DATE_REPORTED	varchar(8);
			DECLARE @v_TIME_REPORTED	varchar(6);
			DECLARE @v_REPORTED_TAX_ID	varchar(20);
			DECLARE @v_REPORTED_LAST_NAME	varchar(255);
			DECLARE @v_REPORTED_FIRST_NAME	varchar(255);
			DECLARE @v_REPORTED_ADDR1	varchar(100);
			DECLARE @v_REPORTED_ADDR2	varchar(100);
			DECLARE @v_REPORTED_CITY 	varchar(50);
			DECLARE @v_REPORTED_STATE	varchar(4);
			DECLARE @v_REPORTED_ZIP_CODE	varchar(10);
			DECLARE @v_REPORTED_PHONE	varchar(30);
			DECLARE @v_COMMENTS	varchar(max);
			DECLARE @v_ACTIVITY_WHEN_INJ	varchar(255);
			DECLARE @v_HOW_ACC_OCCURRED	varchar(255);
			DECLARE @v_OBJ_SUBST_THAT_INJ	varchar(255);
			DECLARE @v_RECORDABLE_FLAG	varchar(1);
			DECLARE @v_SAFEG_NOTUSED_FLAG	varchar(1);
			DECLARE @v_SAFEGUARD_FLAG	varchar(1);
			DECLARE @v_NO_RULES_FLAG	varchar(1);
			DECLARE @v_DATE_PHYS_ADVISED	varchar(8); 
			DECLARE @v_TIME_PHYS_ADVISED	varchar(6);
			DECLARE @v_ACTION_1_CODE varchar(25);	
			DECLARE @v_ACTION_2_CODE varchar(25);	
			DECLARE @v_ACTION_3_CODE varchar(25);	
			DECLARE @v_ACTION_4_CODE varchar(25);	
			DECLARE @v_ACTION_5_CODE varchar(25);	
			DECLARE @v_OUTCOME_1_CODE varchar(25);	
			DECLARE @v_OUTCOME_2_CODE varchar(25);	
			DECLARE @v_OUTCOME_3_CODE varchar(25);	
			DECLARE @v_OUTCOME_4_CODE varchar(25);	
			DECLARE @v_OUTCOME_5_CODE varchar(25);	
			DECLARE @v_DATE_TO_FOLLOW_UP	varchar(8);
			DECLARE @v_TREATMENT_GIVEN 	varchar (1);
			DECLARE @v_RELEASE_SIGNED 	varchar(1);
			DECLARE @v_DEPT_HEAD_ADVISED 	varchar(1);
			DECLARE @v_PHYS_NOTES	varchar(max);
			DECLARE @v_DATE_CARRIER_NOTIF	varchar(8);
			DECLARE @v_PI_SUFFIX	int;
			DECLARE @v_PI_TAX_ID	varchar(20);
			DECLARE @v_PI_LAST_NAME	varchar(255);
			DECLARE @v_PI_FIRST_NAME	varchar(255);
			DECLARE @v_PI_ADDR1	varchar(100);
			DECLARE @v_PI_ADDR2	varchar(100);
			DECLARE @v_PI_CITY	varchar(50);
			DECLARE @v_PI_STATE	varchar(4);
			DECLARE @v_PI_ZIP_CODE	varchar (10);
			DECLARE @v_PI_PHONE	varchar (30) ;
			DECLARE @v_PI_TYPE_CODE	varchar(50);
			DECLARE @v_MARITAL_STAT_CODE	varchar(25);
			DECLARE @v_SEX_CODE	varchar(8);
			DECLARE @v_BIRTH_DATE	varchar(8);
			DECLARE @v_DATE_OF_DEATH	varchar(8);
			DECLARE @v_ILLNESS_CODE	varchar(25);
			DECLARE @v_INJURY_1_CODE varchar(25);	
			DECLARE @v_INJURY_2_CODE varchar(25);	
			DECLARE @v_INJURY_3_CODE varchar(25);	
			DECLARE @v_INJURY_4_CODE varchar(25);	
			DECLARE @v_INJURY_5_CODE varchar(25);	
			DECLARE @v_BODY_PART_1_CODE varchar(25);	
			DECLARE @v_BODY_PART_2_CODE varchar(25);	
			DECLARE @v_BODY_PART_3_CODE varchar(25);	
			DECLARE @v_BODY_PART_4_CODE varchar(25);	
			DECLARE @v_BODY_PART_5_CODE varchar(25);	
			DECLARE @v_DIAGNOSIS_1_CODE varchar(25);	
			DECLARE @v_DIAGNOSIS_2_CODE varchar(25);	
			DECLARE @v_DIAGNOSIS_3_CODE varchar(25);	
			DECLARE @v_DIAGNOSIS_4_CODE varchar(25);	
			DECLARE @v_DIAGNOSIS_5_CODE varchar(25);	
			DECLARE @v_TREATMENT_1_CODE varchar(25);	
			DECLARE @v_TREATMENT_2_CODE varchar(25);	
			DECLARE @v_TREATMENT_3_CODE varchar(25);	
			DECLARE @v_TREATMENT_4_CODE varchar(25);	
			DECLARE @v_TREATMENT_5_CODE varchar(25);	
			DECLARE @v_PHYSICIAN_1_LAST_NAME varchar(255);	
			DECLARE @v_PHYSICIAN_1_FIRST_NAME	varchar(255);
			DECLARE @v_PHYSICIAN_1_PHONE	varchar(30);
			DECLARE @v_PHYSICIAN_2_LAST_NAME varchar(255);	
			DECLARE @v_PHYSICIAN_2_FIRST_NAME	varchar(255);
			DECLARE @v_PHYSICIAN_2_PHONE	varchar(30);
			DECLARE @v_PHYSICIAN_3_LAST_NAME varchar(255);	
			DECLARE @v_PHYSICIAN_3_FIRST_NAME	varchar(255);
			DECLARE @v_PHYSICIAN_3_PHONE	varchar(30);
			DECLARE @v_HOSPITAL_1_NAME	varchar(255);
			DECLARE @v_HOSPITAL_1_PHONE	varchar(30);
			DECLARE @v_HOSPITAL_2_NAME	varchar(255);
			DECLARE @v_HOSPITAL_2_PHONE	varchar(30);
			DECLARE @v_HOSPITAL_3_NAME	varchar(255);
			DECLARE @v_HOSPITAL_3_PHONE	varchar(30);
			DECLARE @v_DRIVERS_LIC_NO	varchar(20);
			DECLARE @v_DRIVERSLICTYPECODE	varchar(25);
			DECLARE @v_DATE_DRIVERSLICEXP	varchar(8);
			DECLARE @v_DRIVLIC_RSTRCT_CODE	varchar(25);
			DECLARE @v_DRIVLIC_STATE	varchar(4);
			DECLARE @V_COUNTY_OF_RESIDNC	varchar(50);
			DECLARE @v_NCCI_CLASS_CODE	varchar(25);
			DECLARE @v_EST_LEN_DISABILITY	int;
			DECLARE @v_INSURABLE_FLAG	varchar(1) ;
			DECLARE @v_LAST_VERIFIED_DATE	varchar(8);
			DECLARE @v_PATIENT_ACCT_NO	varchar(20);
			DECLARE @v_MEDICAL_RCD_NO	varchar(12);
			DECLARE @v_INS_PLAN_GROUP_NO	varchar(16);
			DECLARE @v_DATE_OF_ADMISSION	varchar(8);
			DECLARE @v_DATE_OF_DISCHARGE	varchar(8);
			DECLARE @v_ADM_TYPE_CODE	varchar(25);
			DECLARE @v_ADM_SOURCE_CODE	varchar(25);
			DECLARE @v_ADMISSION_REASON	varchar(max);
			DECLARE @v_ACUITY_LEVEL_CODE	varchar(25);
			DECLARE @v_PATIENT_STAT_CODE	varchar(25);
			DECLARE @v_PATIENT_COND_CODE	varchar(25);
			DECLARE @v_DISCHARGE_DSP_CODE	varchar(25);
			DECLARE @v_EXP_LENGTH_OF_STAY	int;
			DECLARE @v_EXPECTED_COST	decimal(20,2); --MKAUR24 QA
			DECLARE @v_QI_SIGNIF_CODE	varchar(25);
			DECLARE @v_EPISODE_OF_CARE_ID	varchar(8);
			DECLARE @v_PATIENT_TYPE_CODE	varchar(25);
			DECLARE @v_WEIGHT int;	
			DECLARE @v_EMERGENCY_CONTACT	varchar(20);
			DECLARE @v_EMERGENCY_CONT_NO	varchar(20);
			DECLARE @v_PATIENT_ROOM_NO	varchar(14);
			DECLARE @v_FACILITY_UNIT_CODE	varchar(25);
			DECLARE @v_FACILITY_DEPT	varchar(25);
			DECLARE @v_HCO_ID_NO	varchar(20);
			DECLARE @v_HCO_SITE_ID_NO	varchar(20);
			DECLARE @v_WHY_AT_FACILITY	varchar(max);
			DECLARE @v_DISABILITY_CODE	varchar(25);
			DECLARE @v_EMPLOYEE_NUMBER	varchar(20);
			DECLARE @v_POSITION_CODE	varchar(25);
			DECLARE @v_DEPT_ASSIGNED	varchar(25);
			DECLARE @v_SUPER_TAX_ID	varchar(20);
			DECLARE @v_SUPER_EMP_NO	varchar(20);
			DECLARE @v_SUPER_LAST_NAME	varchar(255);
			DECLARE @v_SUPER_FIRST_NAME	varchar(255);
			DECLARE @v_SUPER_ADDR1	varchar(100);
			DECLARE @v_SUPER_ADDR2	varchar(100);
			DECLARE @v_SUPER_CITY	varchar(50);
			DECLARE @v_SUPER_STATE	varchar(4);
			DECLARE @v_SUPER_ZIP_CODE	varchar(10);
			DECLARE @v_SUPER_PHONE1	varchar(30);
			DECLARE @v_FULL_TIME_FLAG	varchar(1);
			DECLARE @v_PAY_TYPE_CODE	varchar(25);
			DECLARE @v_HOURLY_RATE	decimal(20,2); --MKAUR24 QA
			DECLARE @v_WEEKLY_HOURS	decimal(20,2); --MKAUR24 QA
			DECLARE @v_WEEKLY_RATE	decimal(20,2);	--MKAUR24 QA
			DECLARE @v_PAY_AMOUNT	decimal(20,2); --MKAUR24 QA
			DECLARE @v_ACTIVE_FLAG	varchar(1);
			DECLARE @v_DATE_HIRED	varchar(8);
			DECLARE @v_DATE_LAST_WORKED_1  varchar(8);	
			DECLARE @v_DATE_RETURNED_1  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_2  varchar(8);	
			DECLARE @v_DATE_RETURNED_2  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_3  varchar(8);	
			DECLARE @v_DATE_RETURNED_3  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_4  varchar(8);	
			DECLARE @v_DATE_RETURNED_4  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_5  varchar(8);	
			DECLARE @v_DATE_RETURNED_5  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_6  varchar(8);	
			DECLARE @v_DATE_RETURNED_6  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_7  varchar(8);	
			DECLARE @v_DATE_RETURNED_7  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_8  varchar(8);	
			DECLARE @v_DATE_RETURNED_8  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_9  varchar(8);	
			DECLARE @v_DATE_RETURNED_9  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_10  varchar(8);	
			DECLARE @v_DATE_RETURNED_10 varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_11  varchar(8);	
			DECLARE @v_DATE_RETURNED_11  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_12  varchar(8);	
			DECLARE @v_DATE_RETURNED_12 varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_13  varchar(8);	
			DECLARE @v_DATE_RETURNED_13  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_14 varchar(8);	
			DECLARE @v_DATE_RETURNED_14  varchar(8);	
			DECLARE @v_DATE_LAST_WORKED_15  varchar(8);	
			DECLARE @v_DATE_RETURNED_15  varchar(8);	
			DECLARE @v_LOST_WORK_FLAG	varchar(1);
			DECLARE @v_LEN_OF_SVC_DAYS	varchar(1);
			DECLARE @v_EXEMPT_STATUS_FLAG	varchar (1) ;
			DECLARE @v_NO_OF_EXEMPTIONS	INT ;
			DECLARE @v_WORK_SUN_FLAG	varchar(1);
			DECLARE @v_WORK_MON_FLAG	varchar(1);
			DECLARE @v_WORK_TUE_FLAG	varchar(1);
			DECLARE @v_WORK_WED_FLAG	varchar(1);
			DECLARE @v_WORK_THU_FLAG	varchar(1);
			DECLARE @v_WORK_FRI_FLAG	varchar(1);
			DECLARE @v_WORK_SAT_FLAG	varchar(1);
			DECLARE @v_WORKDAY_START_TIME	varchar(6);
			DECLARE @v_WORK_PERMIT_DATE	varchar(8);
			DECLARE @v_WORK_PERMIT_NUMBER	varchar(50);
			DECLARE @v_REGULAR_JOB_FLAG	varchar(1);
			DECLARE @v_HIRED_IN_STATE_FLAG	varchar(1);
			DECLARE @v_NUM_OF_VIOLATION int;	
			DECLARE @v_DESC_BY_WITNESS	varchar(max);
			DECLARE @v_USER_FIELD_A	varchar(max);
			DECLARE @v_USER_FIELD_B	varchar(255);
			DECLARE @v_USER_FIELD_C	varchar(255);
			DECLARE @v_USER_FIELD_D	varchar(255);
			DECLARE @v_USER_FIELD_E	varchar(255);
			DECLARE @v_USER_FIELD_F	varchar(255);
			DECLARE @v_USER_FIELD_G	varchar(255);
			DECLARE @v_USER_FIELD_H	varchar(255);
			DECLARE @v_USER_FIELD_I	varchar(255);
			DECLARE @v_USER_FIELD_J	varchar(255);
			DECLARE @v_USER_FIELD_K	varchar(255);
			DECLARE @v_USER_FIELD_L	varchar(255);
			DECLARE @v_USER_FIELD_M	varchar(255);
			DECLARE @v_USER_FIELD_N	varchar(255);
			DECLARE @v_USER_FIELD_O	varchar(255);
			DECLARE @v_USER_FIELD_P	varchar(255);
			DECLARE @v_USER_FIELD_Q	varchar(255);
			DECLARE @v_USER_FIELD_R	varchar(255);
			DECLARE @v_USER_FIELD_S	varchar(255);
			DECLARE @v_USER_FIELD_T	varchar(255);
			DECLARE @v_USER_FIELD_U	varchar(255);
			DECLARE @v_USER_FIELD_V	varchar(255);
			DECLARE @v_USER_FIELD_W	varchar(255);
			DECLARE @v_USER_FIELD_X	varchar(255);
			DECLARE @v_USER_FIELD_Y	varchar(255);
			DECLARE @v_COND_PRIOR_CODE	varchar(25);
			DECLARE @v_RAIL_POSITION_CODE	varchar(25);
			DECLARE @v_RESTRAINT_CODE	varchar(25);
			DECLARE @v_BED_POSITION_CODE	varchar(25);
			DECLARE @v_CALL_LIGHT_CODE	varchar(25);
			DECLARE @v_REPORTED_COUNTRY	varchar(25);	
			DECLARE @v_REPORTED_PHONE2	varchar(30);
			DECLARE @v_REPORTED_FAX	varchar(30);
			DECLARE @v_PI_MIDDLE_NAME	varchar(255);
			DECLARE @v_PRIVACY_CASE_FLAG	varchar(1);
			DECLARE @v_SHARPS_OBJECT	varchar(25);
			DECLARE @v_SHARPS_BRAND_MAKE	varchar(25);
			DECLARE @v_SAFEG_PROVIDED	varchar(1);
			DECLARE @v_RULES_NOT_FOLLOWED	varchar(1);
			DECLARE @v_OSHA_ESTAB_EID	varchar(25);
			DECLARE @v_NAME_TYPE	varchar(25);
			DECLARE @v_BENEFICIARY_CODE varchar(25); --Dsharma70 hmi				
			DECLARE @v_REPORTED_BIRTH_DT varchar(8); --Dsharma70 hmi
			 --neha JIRA 33658 starts	
			DECLARE @iRunStatCnt int=1; 
            DECLARE @vProcessMsg varchar(100);   
			DECLARE @iRunCnt	int=0;
			DECLARE @iTotalRows	int=0;
			 --neha JIRA 33658 ends 			
			
			
END
BEGIN										 -- Storing Values from Optionset variables	
		
			SELECT  @CheckCreateNewCodes = ALLOW_NEW_CODES ,
					@CheckCreateNewEmployees = ALLOW_NEW_EMPLOYEES ,
					@CheckCreateNewDEPARTMENT = ALLOW_NEW_DEPARTMENT,
					@EmployeeMatchByName = EMPLOYEE_MATCH_BY_NAME,
					@EmployeeMatchByTaxId = EMPLOYEE_MATCH_BY_TAX_ID,
					@EmployeeMatchByEmpNumber = EMPLOYEE_MATCH_BY_EMP_NUM,
					@NonEmployeeMatchByName = NON_EMP_MATCH_BY_NAME,
					@NonEmployeeMatchByTaxId = NON_EMP_MATCH_BY_TAX_ID ,				
					@CrtNwEvntPiEntyIfTxIDEmpty = CREATE_PI_ENT_IF_TAXID_EMPTY,
					@CONFIG_ID                  = CONFIG_ID,
					@EVENT_SUPP                  = EVENT_SUPP,
					@VALID_END_DATE              = VALID_END_DATE,
					@VALID_START_DATE			 = VALID_START_DATE,	--dsharma70 hmi			
					@EmployeeMatchByDOB			= EMPLOYEE_MATCH_BY_DOB, --dsharma70 hmi			
					@NonEmployeeMatchByDOB		= NON_EMP_MATCH_BY_DOB --dsharma70 hmi			

			FROM DDS_OPTIONSET WHERE JOBID = @p_jobID;
	
END
	


 SELECT @TOTALROWS = COUNT(DA_ROW_ID) FROM DDS_EVENT WHERE JOBID = @p_jobID AND INVALID_ROW = 1; 
 SET @iTotalRows=@TOTALROWS --neha 33658

BEGIN										 -- Declaring cursor for EVENT 
		DECLARE DDS_EVENT_CUR CURSOR FOR  
	SELECT
			JOBID 	,
			DA_ROW_ID 	,
			INVALID_ROW 	,
			UPDATE_ROW 	,
			DA_ROW_ID 	,
			EVENT_NUMBER           	,
			EVENT_TYPE_CODE	,
			EVENT_STATUS_CODE	,
			EVENT_IND_CODE	,
			EVENT_DESCRIPTION	,
			BRIEF_DESCRIPTION	,
			DEPARTMENT	,
			DEPT_INVOLVED	,
			ADDR1	,
			ADDR2	,
			CITY	,
			STATE	,
			ZIP_CODE	,
			COUNTRY	,
			COUNTY_OF_INJURY	,
			LOCATION_AREA_DESC	,
			PRIMARY_LOC_CODE	,
			LOCATION_TYPE_CODE	,
			ON_PREMISE_FLAG	,
			NO_OF_INJURIES	,
			NO_OF_FATALITIES	,
			CAUSE_CODE	,
			DATE_OF_EVENT	,
			TIME_OF_EVENT	,
			DATE_REPORTED	,
			TIME_REPORTED	,
			REPORTED_TAX_ID	,
			REPORTED_LAST_NAME	,
			REPORTED_FIRST_NAME	,
			REPORTED_ADDR1	,
			REPORTED_ADDR2	,
			REPORTED_CITY 	,
			REPORTED_STATE	,
			REPORTED_ZIP_CODE	,
			REPORTED_PHONE	,
			COMMENTS	,
			ACTIVITY_WHEN_INJ	,
			HOW_ACC_OCCURRED	,
			OBJ_SUBST_THAT_INJ	,
			RECORDABLE_FLAG	,
			SAFEG_NOTUSED_FLAG	,
			SAFEGUARD_FLAG	,
			NO_RULES_FLAG	,
			DATE_PHYS_ADVISED	,
			TIME_PHYS_ADVISED	,
			ACTION_1_CODE 	,
			ACTION_2_CODE 	,
			ACTION_3_CODE 	,
			ACTION_4_CODE 	,
			ACTION_5_CODE 	,
			OUTCOME_1_CODE 	,
			OUTCOME_2_CODE 	,
			OUTCOME_3_CODE 	,
			OUTCOME_4_CODE 	,
			OUTCOME_5_CODE 	,
			DATE_TO_FOLLOW_UP	,
			TREATMENT_GIVEN 	,
			RELEASE_SIGNED 	,
			DEPT_HEAD_ADVISED 	,
			PHYS_NOTES	,
			DATE_CARRIER_NOTIF	,
			PI_SUFFIX	,
			PI_TAX_ID	,
			PI_LAST_NAME	,
			PI_FIRST_NAME	,
			PI_ADDR1	,
			PI_ADDR2	,
			PI_CITY	,
			PI_STATE	,
			PI_ZIP_CODE	,
			PI_PHONE	,
			PI_TYPE_CODE	,
			MARITAL_STAT_CODE	,
			SEX_CODE	,
			BIRTH_DATE	,
			DATE_OF_DEATH	,
			ILLNESS_CODE	,
			INJURY_1_CODE 	,
			INJURY_2_CODE 	,
			INJURY_3_CODE 	,
			INJURY_4_CODE 	,
			INJURY_5_CODE 	,
			BODY_PART_1_CODE 	,
			BODY_PART_2_CODE 	,
			BODY_PART_3_CODE 	,
			BODY_PART_4_CODE 	,
			BODY_PART_5_CODE 	,
			DIAGNOSIS_1_CODE 	,
			DIAGNOSIS_2_CODE 	,
			DIAGNOSIS_3_CODE 	,
			DIAGNOSIS_4_CODE 	,
			DIAGNOSIS_5_CODE 	,
			TREATMENT_1_CODE 	,
			TREATMENT_2_CODE 	,
			TREATMENT_3_CODE 	,
			TREATMENT_4_CODE 	,
			TREATMENT_5_CODE 	,
			PHYSICIAN_1_LAST_NAME 	,
			PHYSICIAN_1_FIRST_NAME	,
			PHYSICIAN_1_PHONE	,
			PHYSICIAN_2_LAST_NAME 	,
			PHYSICIAN_2_FIRST_NAME	,
			PHYSICIAN_2_PHONE	,
			PHYSICIAN_3_LAST_NAME 	,
			PHYSICIAN_3_FIRST_NAME	,
			PHYSICIAN_3_PHONE	,
			HOSPITAL_1_NAME	,
			HOSPITAL_1_PHONE	,
			HOSPITAL_2_NAME	,
			HOSPITAL_2_PHONE	,
			HOSPITAL_3_NAME	,
			HOSPITAL_3_PHONE	,
			DRIVERS_LIC_NO	,
			DRIVERSLICTYPECODE	,
			DATE_DRIVERSLICEXP	,
			DRIVLIC_RSTRCT_CODE	,
			DRIVLIC_STATE	,
			COUNTY_OF_RESIDNC	,
			NCCI_CLASS_CODE	,
			EST_LEN_DISABILITY	,
			INSURABLE_FLAG	,
			LAST_VERIFIED_DATE	,
			PATIENT_ACCT_NO	,
			MEDICAL_RCD_NO	,
			INS_PLAN_GROUP_NO	,
			DATE_OF_ADMISSION	,
			DATE_OF_DISCHARGE	,
			ADM_TYPE_CODE	,
			ADM_SOURCE_CODE	,
			ADMISSION_REASON	,
			ACUITY_LEVEL_CODE	,
			PATIENT_STAT_CODE	,
			PATIENT_COND_CODE	,
			DISCHARGE_DSP_CODE	,
			EXP_LENGTH_OF_STAY	,
			EXPECTED_COST	,
			QI_SIGNIF_CODE	,
			EPISODE_OF_CARE_ID	,
			PATIENT_TYPE_CODE	,
			WEIGHT 	,
			EMERGENCY_CONTACT	,
			EMERGENCY_CONT_NO	,
			PATIENT_ROOM_NO	,
			FACILITY_UNIT_CODE	,
			FACILITY_DEPT	,
			HCO_ID_NO	,
			HCO_SITE_ID_NO	,
			WHY_AT_FACILITY	,
			DISABILITY_CODE	,
			EMPLOYEE_NUMBER	,
			POSITION_CODE	,
			DEPT_ASSIGNED	,
			SUPER_TAX_ID	,
			SUPER_EMP_NO	,
			SUPER_LAST_NAME	,
			SUPER_FIRST_NAME	,
			SUPER_ADDR1	,
			SUPER_ADDR2	,
			SUPER_CITY	,
			SUPER_STATE	,
			SUPER_ZIP_CODE	,
			SUPER_PHONE1	,
			FULL_TIME_FLAG	,
			PAY_TYPE_CODE	,
			HOURLY_RATE	,
			WEEKLY_HOURS	,
			WEEKLY_RATE	,
			PAY_AMOUNT	,
			ACTIVE_FLAG	,
			DATE_HIRED	,
			DATE_LAST_WORKED_1  	,
			DATE_RETURNED_1  	,
			DATE_LAST_WORKED_2  	,
			DATE_RETURNED_2  	,
			DATE_LAST_WORKED_3  	,
			DATE_RETURNED_3  	,
			DATE_LAST_WORKED_4  	,
			DATE_RETURNED_4  	,
			DATE_LAST_WORKED_5  	,
			DATE_RETURNED_5  	,
			DATE_LAST_WORKED_6  	,
			DATE_RETURNED_6  	,
			DATE_LAST_WORKED_7  	,
			DATE_RETURNED_7  	,
			DATE_LAST_WORKED_8  	,
			DATE_RETURNED_8  	,
			DATE_LAST_WORKED_9  	,
			DATE_RETURNED_9  	,
			DATE_LAST_WORKED_10  	,
			DATE_RETURNED_10 	,
			DATE_LAST_WORKED_11  	,
			DATE_RETURNED_11  	,
			DATE_LAST_WORKED_12  	,
			DATE_RETURNED_12 	,
			DATE_LAST_WORKED_13  	,
			DATE_RETURNED_13  	,
			DATE_LAST_WORKED_14 	,
			DATE_RETURNED_14  	,
			DATE_LAST_WORKED_15  	,
			DATE_RETURNED_15  	,
			LOST_WORK_FLAG	,
			LEN_OF_SVC_DAYS	,
			EXEMPT_STATUS_FLAG	,
			NO_OF_EXEMPTIONS	,
			WORK_SUN_FLAG	,
			WORK_MON_FLAG	,
			WORK_TUE_FLAG	,
			WORK_WED_FLAG	,
			WORK_THU_FLAG	,
			WORK_FRI_FLAG	,
			WORK_SAT_FLAG	,
			WORKDAY_START_TIME	,
			WORK_PERMIT_DATE	,
			WORK_PERMIT_NUMBER	,
			REGULAR_JOB_FLAG	,
			HIRED_IN_STATE_FLAG	,
			NUM_OF_VIOLATION 	,
			DESC_BY_WITNESS	,
			USER_FIELD_A	,
			USER_FIELD_B	,
			USER_FIELD_C	,
			USER_FIELD_D	,
			USER_FIELD_E	,
			USER_FIELD_F	,
			USER_FIELD_G	,
			USER_FIELD_H	,
			USER_FIELD_I	,
			USER_FIELD_J	,
			USER_FIELD_K	,
			USER_FIELD_L	,
			USER_FIELD_M	,
			USER_FIELD_N	,
			USER_FIELD_O	,
			USER_FIELD_P	,
			USER_FIELD_Q	,
			USER_FIELD_R	,
			USER_FIELD_S	,
			USER_FIELD_T	,
			USER_FIELD_U	,
			USER_FIELD_V	,
			USER_FIELD_W	,
			USER_FIELD_X	,
			USER_FIELD_Y	,
			COND_PRIOR_CODE	,
			RAIL_POSITION_CODE	,
			RESTRAINT_CODE	,
			BED_POSITION_CODE	,
			CALL_LIGHT_CODE	,
			REPORTED_COUNTRY	,
			REPORTED_PHONE2	,
			REPORTED_FAX	,
			PI_MIDDLE_NAME	,
			PRIVACY_CASE_FLAG	,
			SHARPS_OBJECT	,
			SHARPS_BRAND_MAKE	,
			SAFEG_PROVIDED	,
			RULES_NOT_FOLLOWED	,
			OSHA_ESTAB_EID	,
			NAME_TYPE,        --dsharma70 hmi
			BENEFICIARY_CODE, --dsharma70 hmi
			REPORTED_BIRTH_DT --dsharma70 hmi				
			
	FROM DDS_EVENT 	WHERE JOBID = @p_jobID AND INVALID_ROW = 1;
	
END

BEGIN TRY	
OPEN DDS_EVENT_CUR;
		
 FETCH NEXT FROM DDS_EVENT_CUR INTO 
			@v_JOBID ,
			@v_DA_ROW_ID 	,
			@v_INVALID_ROW 	,
			@v_UPDATE_ROW ,
			@v_DA_ROW_ID 	,
			@v_EVENT_NUMBER           	,
			@v_EVENT_TYPE_CODE	,
			@v_EVENT_STATUS_CODE	,
			@v_EVENT_IND_CODE	,
			@v_EVENT_DESCRIPTION	,
			@v_BRIEF_DESCRIPTION	,
			@v_DEPARTMENT	,
			@v_DEPT_INVOLVED	,
			@v_ADDR1	,
			@v_ADDR2	,
			@v_CITY	,
			@v_STATE	,
			@v_ZIP_CODE	,
			@V_COUNTRY	,
			@V_COUNTY_OF_INJURY	,
			@v_LOCATION_AREA_DESC	,
			@v_PRIMARY_LOC_CODE	,
			@v_LOCATION_TYPE_CODE	,
			@v_ON_PREMISE_FLAG	,
			@v_NO_OF_INJURIES	,
			@v_NO_OF_FATALITIES	,
			@v_CAUSE_CODE	,
			@v_DATE_OF_EVENT	,
			@v_TIME_OF_EVENT	,
			@v_DATE_REPORTED	,
			@v_TIME_REPORTED	,
			@v_REPORTED_TAX_ID	,
			@v_REPORTED_LAST_NAME	,
			@v_REPORTED_FIRST_NAME	,
			@v_REPORTED_ADDR1	,
			@v_REPORTED_ADDR2	,
			@v_REPORTED_CITY 	,
			@v_REPORTED_STATE	,
			@v_REPORTED_ZIP_CODE	,
			@v_REPORTED_PHONE	,
			@v_COMMENTS	,
			@v_ACTIVITY_WHEN_INJ	,
			@v_HOW_ACC_OCCURRED	,
			@v_OBJ_SUBST_THAT_INJ	,
			@v_RECORDABLE_FLAG	,
			@v_SAFEG_NOTUSED_FLAG	,
			@v_SAFEGUARD_FLAG	,
			@v_NO_RULES_FLAG	,
			@v_DATE_PHYS_ADVISED	,
			@v_TIME_PHYS_ADVISED	,
			@v_ACTION_1_CODE 	,
			@v_ACTION_2_CODE 	,
			@v_ACTION_3_CODE 	,
			@v_ACTION_4_CODE 	,
			@v_ACTION_5_CODE 	,
			@v_OUTCOME_1_CODE 	,
			@v_OUTCOME_2_CODE 	,
			@v_OUTCOME_3_CODE 	,
			@v_OUTCOME_4_CODE 	,
			@v_OUTCOME_5_CODE 	,
			@v_DATE_TO_FOLLOW_UP	,
			@v_TREATMENT_GIVEN 	,
			@v_RELEASE_SIGNED 	,
			@v_DEPT_HEAD_ADVISED 	,
			@v_PHYS_NOTES	,
			@v_DATE_CARRIER_NOTIF	,
			@v_PI_SUFFIX	,
			@v_PI_TAX_ID	,
			@v_PI_LAST_NAME	,
			@v_PI_FIRST_NAME	,
			@v_PI_ADDR1	,
			@v_PI_ADDR2	,
			@v_PI_CITY	,
			@v_PI_STATE	,
			@v_PI_ZIP_CODE	,
			@v_PI_PHONE	,
			@v_PI_TYPE_CODE	,
			@v_MARITAL_STAT_CODE	,
			@v_SEX_CODE	,
			@v_BIRTH_DATE	,
			@v_DATE_OF_DEATH	,
			@v_ILLNESS_CODE	,
			@v_INJURY_1_CODE 	,
			@v_INJURY_2_CODE 	,
			@v_INJURY_3_CODE 	,
			@v_INJURY_4_CODE 	,
			@v_INJURY_5_CODE 	,
			@v_BODY_PART_1_CODE 	,
			@v_BODY_PART_2_CODE 	,
			@v_BODY_PART_3_CODE 	,
			@v_BODY_PART_4_CODE 	,
			@v_BODY_PART_5_CODE 	,
			@v_DIAGNOSIS_1_CODE 	,
			@v_DIAGNOSIS_2_CODE 	,
			@v_DIAGNOSIS_3_CODE 	,
			@v_DIAGNOSIS_4_CODE 	,
			@v_DIAGNOSIS_5_CODE 	,
			@v_TREATMENT_1_CODE 	,
			@v_TREATMENT_2_CODE 	,
			@v_TREATMENT_3_CODE 	,
			@v_TREATMENT_4_CODE 	,
			@v_TREATMENT_5_CODE 	,
			@v_PHYSICIAN_1_LAST_NAME 	,
			@v_PHYSICIAN_1_FIRST_NAME	,
			@v_PHYSICIAN_1_PHONE	,
			@v_PHYSICIAN_2_LAST_NAME 	,
			@v_PHYSICIAN_2_FIRST_NAME	,
			@v_PHYSICIAN_2_PHONE	,
			@v_PHYSICIAN_3_LAST_NAME 	,
			@v_PHYSICIAN_3_FIRST_NAME	,
			@v_PHYSICIAN_3_PHONE	,
			@v_HOSPITAL_1_NAME	,
			@v_HOSPITAL_1_PHONE	,
			@v_HOSPITAL_2_NAME	,
			@v_HOSPITAL_2_PHONE	,
			@v_HOSPITAL_3_NAME	,
			@v_HOSPITAL_3_PHONE	,
			@v_DRIVERS_LIC_NO	,
			@v_DRIVERSLICTYPECODE	,
			@v_DATE_DRIVERSLICEXP	,
			@v_DRIVLIC_RSTRCT_CODE	,
			@v_DRIVLIC_STATE	,
			@V_COUNTY_OF_RESIDNC	,
			@v_NCCI_CLASS_CODE	,
			@v_EST_LEN_DISABILITY	,
			@v_INSURABLE_FLAG	,
			@v_LAST_VERIFIED_DATE	,
			@v_PATIENT_ACCT_NO	,
			@v_MEDICAL_RCD_NO	,
			@v_INS_PLAN_GROUP_NO	,
			@v_DATE_OF_ADMISSION	,
			@v_DATE_OF_DISCHARGE	,
			@v_ADM_TYPE_CODE	,
			@v_ADM_SOURCE_CODE	,
			@v_ADMISSION_REASON	,
			@v_ACUITY_LEVEL_CODE	,
			@v_PATIENT_STAT_CODE	,
			@v_PATIENT_COND_CODE	,
			@v_DISCHARGE_DSP_CODE	,
			@v_EXP_LENGTH_OF_STAY	,
			@v_EXPECTED_COST	,
			@v_QI_SIGNIF_CODE	,
			@v_EPISODE_OF_CARE_ID	,
			@v_PATIENT_TYPE_CODE	,
			@v_WEIGHT 	,
			@v_EMERGENCY_CONTACT	,
			@v_EMERGENCY_CONT_NO	,
			@v_PATIENT_ROOM_NO	,
			@v_FACILITY_UNIT_CODE	,
			@v_FACILITY_DEPT	,
			@v_HCO_ID_NO	,
			@v_HCO_SITE_ID_NO	,
			@v_WHY_AT_FACILITY	,
			@v_DISABILITY_CODE	,
			@v_EMPLOYEE_NUMBER	,
			@v_POSITION_CODE	,
			@v_DEPT_ASSIGNED	,
			@v_SUPER_TAX_ID	,
			@v_SUPER_EMP_NO	,
			@v_SUPER_LAST_NAME	,
			@v_SUPER_FIRST_NAME	,
			@v_SUPER_ADDR1	,
			@v_SUPER_ADDR2	,
			@v_SUPER_CITY	,
			@v_SUPER_STATE	,
			@v_SUPER_ZIP_CODE	,
			@v_SUPER_PHONE1	,
			@v_FULL_TIME_FLAG	,
			@v_PAY_TYPE_CODE	,
			@v_HOURLY_RATE	,
			@v_WEEKLY_HOURS	,
			@v_WEEKLY_RATE	,
			@v_PAY_AMOUNT	,
			@v_ACTIVE_FLAG	,
			@v_DATE_HIRED	,
			@v_DATE_LAST_WORKED_1  	,
			@v_DATE_RETURNED_1  	,
			@v_DATE_LAST_WORKED_2  	,
			@v_DATE_RETURNED_2  	,
			@v_DATE_LAST_WORKED_3  	,
			@v_DATE_RETURNED_3  	,
			@v_DATE_LAST_WORKED_4  	,
			@v_DATE_RETURNED_4  	,
			@v_DATE_LAST_WORKED_5  	,
			@v_DATE_RETURNED_5  	,
			@v_DATE_LAST_WORKED_6  	,
			@v_DATE_RETURNED_6  	,
			@v_DATE_LAST_WORKED_7  	,
			@v_DATE_RETURNED_7  	,
			@v_DATE_LAST_WORKED_8  	,
			@v_DATE_RETURNED_8  	,
			@v_DATE_LAST_WORKED_9  	,
			@v_DATE_RETURNED_9  	,
			@v_DATE_LAST_WORKED_10  	,
			@v_DATE_RETURNED_10 	,
			@v_DATE_LAST_WORKED_11  	,
			@v_DATE_RETURNED_11  	,
			@v_DATE_LAST_WORKED_12  	,
			@v_DATE_RETURNED_12 	,
			@v_DATE_LAST_WORKED_13  	,
			@v_DATE_RETURNED_13  	,
			@v_DATE_LAST_WORKED_14 	,
			@v_DATE_RETURNED_14  	,
			@v_DATE_LAST_WORKED_15  	,
			@v_DATE_RETURNED_15  	,
			@v_LOST_WORK_FLAG	,
			@v_LEN_OF_SVC_DAYS	,
			@v_EXEMPT_STATUS_FLAG	,
			@v_NO_OF_EXEMPTIONS	,
			@v_WORK_SUN_FLAG	,
			@v_WORK_MON_FLAG	,
			@v_WORK_TUE_FLAG	,
			@v_WORK_WED_FLAG	,
			@v_WORK_THU_FLAG	,
			@v_WORK_FRI_FLAG	,
			@v_WORK_SAT_FLAG	,
			@v_WORKDAY_START_TIME	,
			@v_WORK_PERMIT_DATE	,
			@v_WORK_PERMIT_NUMBER	,
			@v_REGULAR_JOB_FLAG	,
			@v_HIRED_IN_STATE_FLAG	,
			@v_NUM_OF_VIOLATION 	,
			@v_DESC_BY_WITNESS	,
			@v_USER_FIELD_A	,
			@v_USER_FIELD_B	,
			@v_USER_FIELD_C	,
			@v_USER_FIELD_D	,
			@v_USER_FIELD_E	,
			@v_USER_FIELD_F	,
			@v_USER_FIELD_G	,
			@v_USER_FIELD_H	,
			@v_USER_FIELD_I	,
			@v_USER_FIELD_J	,
			@v_USER_FIELD_K	,
			@v_USER_FIELD_L	,
			@v_USER_FIELD_M	,
			@v_USER_FIELD_N	,
			@v_USER_FIELD_O	,
			@v_USER_FIELD_P	,
			@v_USER_FIELD_Q	,
			@v_USER_FIELD_R	,
			@v_USER_FIELD_S	,
			@v_USER_FIELD_T	,
			@v_USER_FIELD_U	,
			@v_USER_FIELD_V	,
			@v_USER_FIELD_W	,
			@v_USER_FIELD_X	,
			@v_USER_FIELD_Y	,
			@v_COND_PRIOR_CODE	,
			@v_RAIL_POSITION_CODE	,
			@v_RESTRAINT_CODE	,
			@v_BED_POSITION_CODE	,
			@v_CALL_LIGHT_CODE	,
			@v_REPORTED_COUNTRY	,
			@v_REPORTED_PHONE2	,
			@v_REPORTED_FAX	,
			@v_PI_MIDDLE_NAME	,
			@v_PRIVACY_CASE_FLAG	,
			@v_SHARPS_OBJECT	,
			@v_SHARPS_BRAND_MAKE	,
			@v_SAFEG_PROVIDED	,
			@v_RULES_NOT_FOLLOWED	,
			@v_OSHA_ESTAB_EID	,
			@v_NAME_TYPE,        --dsharma70 hmi
			@v_BENEFICIARY_CODE, --dsharma70 hmi
			@v_REPORTED_BIRTH_DT --dsharma70 hmi				
			

WHILE @TOTALROWS <> 0		
BEGIN	


BEGIN TRY -- This is while loop's try-catch start   
SET @V_ERROR_LOCATION_MAIN = 'ES1'

									--********************************************************************
									--************************ EVENT VALIDATION STARTS   ***************** -- TEN BLOCKS
									--********************************************************************
SET @HEALTH_LOB_ID	= 0; --DSHARMA70 HMI

BEGIN			
				--DSHARMA70 HMI STARTS
				SET @N_SQL = 'SELECT @HEALTH_LOB_ID = CODE_ID  FROM ' + @V_DBName +'CODES ';
				SET @N_SQL =  @N_SQL + ' WHERE SHORT_CODE = ''HC'' AND TABLE_ID IN '
				SET @N_SQL =  @N_SQL + '(SELECT TABLE_ID FROM ' + @V_DBName +'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''LINE_OF_BUSINESS'')'
				SET @N_SQL =  @N_SQL + ' AND DELETED_FLAG = 0'
																											
				BEGIN TRY
				Exec sp_Executesql @N_SQL,
						N' @HEALTH_LOB_ID INT OUTPUT',									
						@HEALTH_LOB_ID = @HEALTH_LOB_ID OUTPUT;											  
				END TRY
				BEGIN CATCH
					SET  @V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main',
						@p_CURRENT_ERROR_LOCATION = 'HEALTH_LOB_CHECK', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = NULL , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				END CATCH									
				--DSHARMA70 HMI ENDS		

						  -- EVD1. REQUIRED FIELDS VALIDATION STARTS 
				SET @vReqColumns = 'EVENT_NUMBER|EVENT_TYPE_CODE|DATE_OF_EVENT|TIME_OF_EVENT|EVENT_STATUS_CODE|'
				SET @vReqColumns = @vReqColumns + 'DEPARTMENT|DATE_REPORTED|TIME_REPORTED|EVENT_IND_CODE|'
			
						IF @v_PI_LAST_NAME IS NOT NULL AND (@v_PI_LAST_NAME <> '')  AND UPPER (@v_PI_TYPE_CODE) = 'E'
						 BEGIN
			             SET @vReqColumns = @vReqColumns + 'DEPT_ASSIGNED|EMPLOYEE_NUMBER|'
						 END
				
			WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
			BEGIN
				SET @iPos = CHARINDEX('|',@vReqColumns,1)
				
				SET @vColName = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
				
			
				SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
					
				SELECT @vVal =( CASE 
				WHEN @vColName = 'EVENT_NUMBER'      THEN @V_EVENT_NUMBER
				WHEN @vColName = 'EVENT_TYPE_CODE'   THEN @V_EVENT_TYPE_CODE
				WHEN @vColName = 'DATE_OF_EVENT'	 THEN @V_DATE_OF_EVENT				
				WHEN @vColName = 'TIME_OF_EVENT'     THEN @V_TIME_OF_EVENT
				WHEN @vColName = 'EVENT_STATUS_CODE' THEN @V_EVENT_STATUS_CODE
				WHEN @vColName = 'DEPARTMENT'		 THEN @V_DEPARTMENT
				WHEN @vColName = 'DATE_REPORTED'     THEN @V_DATE_REPORTED
				WHEN @vColName = 'TIME_REPORTED'     THEN @V_TIME_REPORTED
				WHEN @vColName = 'EVENT_IND_CODE'    THEN @V_EVENT_IND_CODE	
				WHEN @vColName = 'DEPT_ASSIGNED'     THEN @V_DEPT_ASSIGNED	
				WHEN @vColName = 'EMPLOYEE_NUMBER'   THEN @V_EMPLOYEE_NUMBER		
				END)
				
				IF @vVal IS NULL OR @vVal = ''	
					BEGIN				
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'REQVD', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'Required Fields are Null or Empty.Please provide a valid value.',
						@p_ERROR_COLUMNS = @vColName , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 1 ; 
						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
					END
			END
END  -- REQUIRED FIELDS VALIDATION ENDS


BEGIN									  -- EVD1. PHONE FIELDS VALIDATION STARTS --WORKING

				  SET @vColList = 'REPORTED_PHONE|REPORTED_PHONE2|'
				
						IF @v_PI_LAST_NAME IS NOT NULL AND @v_PI_LAST_NAME <> ''
						 BEGIN
						  SET @vColList = @vColList + 'PI_PHONE|SUPER_PHONE1|PHYSICIAN_1_PHONE|PHYSICIAN_2_PHONE|PHYSICIAN_3_PHONE|'
						   SET @vColList = @vColList + 'HOSPITAL_1_PHONE|HOSPITAL_2_PHONE|HOSPITAL_3_PHONE|'
						 END				
			WHILE CHARINDEX('|',@vColList,1) > 0		
			BEGIN
					SET @iPos = CHARINDEX('|',@vColList,1)				
					SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)			
			
					SET @vColList = RIGHT(@vColList,LEN(@vColList) - CHARINDEX('|',@vColList,1))
					
					SELECT @vVal =( CASE 
					WHEN @vColName = 'REPORTED_PHONE'			THEN @V_REPORTED_PHONE
					WHEN @vColName = 'REPORTED_PHONE2'			THEN @V_REPORTED_PHONE2
					WHEN @vColName = 'PI_PHONE'					THEN @V_PI_PHONE			
					WHEN @vColName = 'SUPER_PHONE1'				THEN @V_SUPER_PHONE1
					WHEN @vColName = 'PHYSICIAN_1_PHONE'		THEN @V_PHYSICIAN_1_PHONE
					WHEN @vColName = 'PHYSICIAN_2_PHONE'		THEN @V_PHYSICIAN_2_PHONE
					WHEN @vColName = 'PHYSICIAN_3_PHONE'		THEN @V_PHYSICIAN_3_PHONE
					WHEN @vColName = 'HOSPITAL_1_PHONE'			THEN @V_HOSPITAL_1_PHONE
					WHEN @vColName = 'HOSPITAL_2_PHONE'			THEN @V_HOSPITAL_2_PHONE
					WHEN @vColName = 'HOSPITAL_3_PHONE'			THEN @V_HOSPITAL_3_PHONE--				
					END)				
						IF @vVal IS NOT NULL 	--mkaur24
							BEGIN	
								IF LEN (@vVal) < 10
									BEGIN
											EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'Main', 
												@p_CURRENT_ERROR_LOCATION = 'PHONVD', 
												@p_ERROR_PROC_NAME = @V_PROCNAME ,
												@p_ERROR_MSG = 'Please provide a valid phone no.',
												@p_ERROR_COLUMNS = @vColName , 
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
												@P_IS_VALIDATION = 1 ; 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
									END
							 END
						END
END  

BEGIN									  -- EVD1. TAX_ID FIELDS VALIDATION STARTS --WORKING
--knakra knakra
				  SET @vColList = 'REPORTED_TAX_ID|'
				
				IF @v_PI_LAST_NAME IS NOT NULL AND @v_PI_LAST_NAME <> ''
				 BEGIN
	              SET @vColList = @vColList + 'PI_TAX_ID|SUPER_TAX_ID|'
				 END
				
			WHILE CHARINDEX('|',@vColList,1) > 0		
			BEGIN
				SET @iPos = CHARINDEX('|',@vColList,1)
				
				SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
				
			
				SET @vColList = RIGHT(@vColList,LEN(@vColList) - CHARINDEX('|',@vColList,1))
					
				SELECT @vVal =( CASE 
				WHEN @vColName = 'REPORTED_TAX_ID'			THEN @V_REPORTED_TAX_ID
				WHEN @vColName = 'PI_TAX_ID'				THEN @V_PI_TAX_ID
				WHEN @vColName = 'SUPER_TAX_ID'				THEN @V_SUPER_TAX_ID
				END)
				
				IF @vVal IS NOT NULL 	-- MKAUR24 
					BEGIN	
					IF LEN (REPLACE(@vVal,'-','')) <> 9	-- MKAUR24 2	--knakra latest
						BEGIN
							EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								@p_MODULE_NAME = @V_MODULENAME ,
								@p_CALLING_ERROR_LOCATION = 'Main', 
								@p_CURRENT_ERROR_LOCATION = 'TAXIDVD', 
								@p_ERROR_PROC_NAME = @V_PROCNAME ,
								@p_ERROR_MSG = 'Please provide a valid TAX_ID no.',
								@p_ERROR_COLUMNS = @vColName , 
								@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								@P_IS_VALIDATION = 1 ; 
								SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
								--knakra starts
								IF @vColName = 'REPORTED_TAX_ID'
									SET @iRptdTidErr = 1
								ELSE IF @vColName = 'PI_TAX_ID'
									SET @iPiTidErr = 1
								ELSE IF @vColName = 'SUPER_TAX_ID'
									SET @iSvTidErr = 1
								--knakra ends
						END
					END
			END
END  
SET @V_ERROR_LOCATION_MAIN = 'ES2'
BEGIN									  -- EVD2. FLAG VALIDATION STARTS 
	    
 SET @vColList = 'WORK_SUN_FLAG|WORK_MON_FLAG|WORK_WED_FLAG|WORK_THU_FLAG|WORK_FRI_FLAG|WORK_SAT_FLAG|FULL_TIME_FLAG|'
 SET @vColList = @vColList + 'ACTIVE_FLAG|EXEMPT_STATUS_FLAG|INSURABLE_FLAG|REGULAR_JOB_FLAG|LOST_WORK_FLAG|'
 SET @vColList = @vColList + 'ON_PREMISE_FLAG|NO_RULES_FLAG|RECORDABLE_FLAG|SAFEG_NOTUSED_FLAG|SAFEGUARD_FLAG|PRIVACY_CASE_FLAG|HIRED_IN_STATE_FLAG|TREATMENT_GIVEN|RELEASE_SIGNED|DEPT_HEAD_ADVISED|'
				 --print 'before while'
			
			WHILE CHARINDEX('|',@vColList,1) > 0		
			BEGIN
				
				SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
				
				SET @vColList = RIGHT(@vColList,LEN(@vColList) - CHARINDEX('|',@vColList,1))
				
				SELECT @vVal =( CASE 
				WHEN @vColName = 'WORK_SUN_FLAG' THEN  @v_WORK_SUN_FLAG
				WHEN @vColName = 'WORK_MON_FLAG' THEN  @v_WORK_MON_FLAG
				WHEN @vColName = 'WORK_TUE_FLAG' THEN  @v_WORK_TUE_FLAG	
				WHEN @vColName = 'WORK_WED_FLAG' THEN  @v_WORK_WED_FLAG	
				WHEN @vColName = 'WORK_THU_FLAG' THEN  @v_WORK_THU_FLAG	
				WHEN @vColName = 'WORK_FRI_FLAG' THEN  @v_WORK_FRI_FLAG	
				WHEN @vColName = 'WORK_SAT_FLAG' THEN  @v_WORK_SAT_FLAG	
				WHEN @vColName = 'FULL_TIME_FLAG' THEN  @v_FULL_TIME_FLAG
				WHEN @vColName = 'ACTIVE_FLAG' THEN  @v_ACTIVE_FLAG
				WHEN @vColName = 'EXEMPT_STATUS_FLAG' THEN  @v_EXEMPT_STATUS_FLAG	
				WHEN @vColName = 'INSURABLE_FLAG' THEN  @v_INSURABLE_FLAG	
				WHEN @vColName = 'REGULAR_JOB_FLAG' THEN  @v_REGULAR_JOB_FLAG	
				WHEN @vColName = 'LOST_WORK_FLAG' THEN  @v_LOST_WORK_FLAG	
				WHEN @vColName = 'ON_PREMISE_FLAG' THEN  @v_ON_PREMISE_FLAG
				WHEN @vColName = 'NO_RULES_FLAG' THEN  @v_NO_RULES_FLAG
				WHEN @vColName = 'RECORDABLE_FLAG' THEN  @v_RECORDABLE_FLAG
				WHEN @vColName = 'SAFEG_NOTUSED_FLAG' THEN  @v_SAFEG_NOTUSED_FLAG
				WHEN @vColName = 'HIRED_IN_STATE_FLAG' THEN  @v_HIRED_IN_STATE_FLAG			
				WHEN @vColName = 'SAFEGUARD_FLAG' THEN  @v_SAFEGUARD_FLAG	
				WHEN @vColName = 'PRIVACY_CASE_FLAG' THEN  @v_PRIVACY_CASE_FLAG	
				WHEN @vColName = 'TREATMENT_GIVEN' THEN  @v_TREATMENT_GIVEN			
				WHEN @vColName = 'RELEASE_SIGNED' THEN  @v_RELEASE_SIGNED
				WHEN @vColName = 'DEPT_HEAD_ADVISED' THEN  @v_DEPT_HEAD_ADVISED	
				END)		
				
				
		
				
						
				IF ((@vVal IS NOT NULL) AND ((UPPER(@vVal) <> 'Y')	AND (UPPER(@vVal) <> 'N'	)))
					BEGIN	
					
							EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								@p_MODULE_NAME = @V_MODULENAME ,
								@p_CALLING_ERROR_LOCATION = 'Main', 
								@p_CURRENT_ERROR_LOCATION = 'FlagVD', 
								@p_ERROR_PROC_NAME = @V_PROCNAME ,
								@p_ERROR_MSG = 'If providing value for flag column,acceptable value is either Y/N ',
								@p_ERROR_COLUMNS = @vColName , 
								@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER', --MKAUR24 1/12  
								@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								@P_IS_VALIDATION = 1 ; 
								SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
						END
			END

END
SET @V_ERROR_LOCATION_MAIN = 'ES3'
BEGIN									  -- EVD3. CODE VALIDATION STARTS     
--print 'codevd'       
			SET @vCodeFieldList = 'EVENT_TYPE_CODE|EVENT_STATUS_CODE|EVENT_IND_CODE|LOCATION_TYPE_CODE|CAUSE_CODE|PRIMARY_LOC_CODE|ACTION_1_CODE |ACTION_2_CODE|ACTION_3_CODE|ACTION_4_CODE|ACTION_5_CODE|OUTCOME_1_CODE|OUTCOME_2_CODE|OUTCOME_3_CODE|OUTCOME_4_CODE|OUTCOME_5_CODE|'
			SET @vCodeFieldList = @vCodeFieldList + 'MARITAL_STAT_CODE|BODY_PART_1_CODE|BODY_PART_2_CODE|BODY_PART_3_CODE|BODY_PART_4_CODE|BODY_PART_5_CODE|DIAGNOSIS_1_CODE|DIAGNOSIS_2_CODE|DIAGNOSIS_3_CODE|DIAGNOSIS_4_CODE|DIAGNOSIS_5_CODE|'
			SET @vCodeFieldList = @vCodeFieldList + 'TREATMENT_1_CODE|TREATMENT_2_CODE|TREATMENT_3_CODE|TREATMENT_4_CODE|TREATMENT_5_CODE|DRIVERSLICTYPECODE|NCCI_CLASS_CODE|DRIVLIC_RSTRCT_CODE|ADM_TYPE_CODE|ADM_SOURCE_CODE|ACUITY_LEVEL_CODE|'
			SET @vCodeFieldList = @vCodeFieldList + 'PATIENT_STAT_CODE|PATIENT_COND_CODE|DISCHARGE_DSP_CODE|PATIENT_TYPE_CODE|FACILITY_UNIT_CODE|POSITION_CODE|PAY_TYPE_CODE|COND_PRIOR_CODE|RAIL_POSITION_CODE|RESTRAINT_CODE|BED_POSITION_CODE|SHARPS_BRAND_MAKE|SHARPS_OBJECT|SAFEG_PROVIDED|REPORTED_COUNTRY|COUNTRY|QI_SIGNIF_CODE|NAME_TYPE|'
			SET @vCodeFieldList = @vCodeFieldList + 'DISABILITY_CODE|RULES_NOT_FOLLOWED|CALL_LIGHT_CODE|SEX_CODE|' --code creation 0
			SET @vCodeFieldList = @vCodeFieldList + 'BENEFICIARY_CODE|' --dsharma70 hmi
			
			SET @vSysTableNameList = 'EVENT_TYPE|EVENT_STATUS|EVENT_INDICATOR|LOCATION_TYPE|CAUSE_CODE|PRIMARY_LOCATION|ACTION_CODE|ACTION_CODE|ACTION_CODE|ACTION_CODE|ACTION_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|OUTCOME_CODE|'
			SET @vSysTableNameList = @vSysTableNameList + 'MARITAL_STATUS|BODY_PART|BODY_PART|BODY_PART|BODY_PART|BODY_PART|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|DIAGNOSIS_CODE|'
			SET @vSysTableNameList = @vSysTableNameList + 'TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|TREATMENT_TYPE|LICENSE_TYPE_CODE|NCCI_CLASS_CODE|LIC_RESTRICTION|ADMISSION_TYPE|ADMISSION_SOURCE|ACUITY_LEVEL|'
			SET @vSysTableNameList = @vSysTableNameList + 'PATIENT_STATUS|PATIENT_CONDITION|DISCHARGE_DISP|PATIENT_TYPE|FACILITY_UNIT|POSITIONS|PAY_TYPES|CONDITION_PRIOR|SIDE_RAIL_POSITION|RESTRAINTS|BED_POSITION_CODES|SHARPS_LOG_BRAND|SHAPRS_LOG_OBJECT|YES_NO|COUNTRY|COUNTRY|QI_SIGNIFICANCE|ENTITY_NAME_TYPE|' --MKAUR24 1/12
			SET @vSysTableNameList = @vSysTableNameList + 'DISABILITY_CODE|YES_NO|YES_NO|SEX_CODE|' --code creation 0
			SET @vSysTableNameList = @vSysTableNameList + 'BENEFICIARY_CODE|' --dsharma70 hmi

			IF @v_PI_LAST_NAME IS NOT NULL
			BEGIN
				IF (upper(@v_DISABILITY_CODE) = 'INJ') 
					BEGIN
					SET @vCodeFieldList = @vCodeFieldList + 'INJURY_1_CODE|INJURY_2_CODE|INJURY_3_CODE|INJURY_4_CODE|INJURY_5_CODE|' --MKAUR24 BACK
					SET @vSysTableNameList = @vSysTableNameList + 'INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|INJURY_TYPE|'
					END

				IF (upper(@v_DISABILITY_CODE) = 'ILL' AND @v_ILLNESS_CODE IS NOT NULL )
					BEGIN
					SET @vCodeFieldList = @vCodeFieldList + 'ILLNESS_CODE|'
					SET @vSysTableNameList = @vSysTableNameList + 'ILLNESS_TYPE|'
					END
			END

			--@v_DRIVLIC_STATE , @V_SEX_CODE , @v_REPORTED_COUNTRY|@V_COUNTRY					
			
			WHILE CHARINDEX('|',@vCodeFieldList,1) > 0		--CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
			BEGIN
			
				SET @iPos = CHARINDEX('|',@vCodeFieldList,1)
				SET @vColName = LEFT(@vCodeFieldList,CHARINDEX('|',@vCodeFieldList,1) - 1)
				--print 'left3 @vColName : ' + @vColName
				SET @vCodeFieldList = RIGHT(@vCodeFieldList,LEN(@vCodeFieldList) - CHARINDEX('|',@vCodeFieldList,1))
				
				SET @iPos = CHARINDEX('|',@vSysTableNameList,1)
				SET @vTableName = LEFT(@vSysTableNameList,CHARINDEX('|',@vSysTableNameList,1) - 1)
				--print 'left5 @vTableName : ' + @vTableName
				SET @vSysTableNameList = RIGHT(@vSysTableNameList,LEN(@vSysTableNameList) - CHARINDEX('|',@vSysTableNameList,1))
				
				SELECT @vVal =( CASE 
							WHEN @vColName = 'EVENT_TYPE_CODE'	    THEN     @v_EVENT_TYPE_CODE
							WHEN @vColName = 'EVENT_STATUS_CODE'	THEN     @v_EVENT_STATUS_CODE
							WHEN @vColName = 'EVENT_IND_CODE'		THEN     @v_EVENT_IND_CODE 
							WHEN @vColName = 'LOCATION_TYPE_CODE'	THEN     @v_LOCATION_TYPE_CODE 
							WHEN @vColName = 'CAUSE_CODE'			THEN	 @v_CAUSE_CODE
							WHEN @vColName = 'PRIMARY_LOC_CODE'     THEN	 @v_PRIMARY_LOC_CODE
							WHEN @vColName = 'ACTION_1_CODE'		THEN	 @v_ACTION_1_CODE
							WHEN @vColName = 'ACTION_2_CODE'		THEN	 @v_ACTION_2_CODE
							WHEN @vColName = 'ACTION_3_CODE'		THEN	 @v_ACTION_3_CODE
							WHEN @vColName = 'ACTION_4_CODE'		THEN	 @v_ACTION_4_CODE
							WHEN @vColName = 'ACTION_5_CODE'		THEN	 @v_ACTION_5_CODE
							WHEN @vColName = 'OUTCOME_1_CODE'		THEN	 @v_OUTCOME_1_CODE
							WHEN @vColName = 'OUTCOME_2_CODE'		THEN	 @v_OUTCOME_2_CODE
							WHEN @vColName = 'OUTCOME_3_CODE'		THEN	 @v_OUTCOME_3_CODE
							WHEN @vColName = 'OUTCOME_4_CODE'		THEN	 @v_OUTCOME_4_CODE  
							WHEN @vColName = 'OUTCOME_5_CODE'		THEN	 @v_OUTCOME_5_CODE
							WHEN @vColName = 'MARITAL_STAT_CODE'	THEN	 @v_MARITAL_STAT_CODE
							WHEN @vColName = 'BODY_PART_1_CODE'		THEN	 @v_BODY_PART_1_CODE	--knakra latest starts
							WHEN @vColName = 'BODY_PART_2_CODE'		THEN	 @v_BODY_PART_2_CODE
							WHEN @vColName = 'BODY_PART_3_CODE'		THEN	 @v_BODY_PART_3_CODE
							WHEN @vColName = 'BODY_PART_4_CODE'		THEN	 @v_BODY_PART_4_CODE
							WHEN @vColName = 'BODY_PART_5_CODE'		THEN	 @v_BODY_PART_5_CODE
							WHEN @vColName = 'DIAGNOSIS_1_CODE'		THEN	 @v_DIAGNOSIS_1_CODE
							WHEN @vColName = 'DIAGNOSIS_2_CODE'		THEN	 @v_DIAGNOSIS_2_CODE
							WHEN @vColName = 'DIAGNOSIS_3_CODE'		THEN	 @v_DIAGNOSIS_3_CODE
							WHEN @vColName = 'DIAGNOSIS_4_CODE'		THEN	 @v_DIAGNOSIS_4_CODE
							WHEN @vColName = 'DIAGNOSIS_5_CODE'		THEN	 @v_DIAGNOSIS_5_CODE
							WHEN @vColName = 'TREATMENT_1_CODE'		THEN	 @v_TREATMENT_1_CODE
							WHEN @vColName = 'TREATMENT_2_CODE'		THEN	 @v_TREATMENT_2_CODE
							WHEN @vColName = 'TREATMENT_3_CODE'		THEN	 @v_TREATMENT_3_CODE
							WHEN @vColName = 'TREATMENT_4_CODE'		THEN	 @v_TREATMENT_4_CODE
							WHEN @vColName = 'TREATMENT_5_CODE'		THEN	 @v_TREATMENT_5_CODE	--knakra latest ends
							WHEN @vColName = 'DRIVERSLICTYPECODE'	THEN	 @v_DRIVERSLICTYPECODE
							WHEN @vColName = 'NCCI_CLASS_CODE'		THEN	 @v_NCCI_CLASS_CODE
							WHEN @vColName = 'DRIVLIC_RSTRCT_CODE'	THEN	 @v_DRIVLIC_RSTRCT_CODE
							WHEN @vColName = 'ADM_TYPE_CODE'		THEN	 @v_ADM_TYPE_CODE
							WHEN @vColName = 'ADM_SOURCE_CODE'		THEN	 @v_ADM_SOURCE_CODE
							WHEN @vColName = 'ACUITY_LEVEL_CODE'	THEN	 @v_ACUITY_LEVEL_CODE
							WHEN @vColName = 'PATIENT_STAT_CODE'	THEN	 @v_PATIENT_STAT_CODE
							WHEN @vColName = 'PATIENT_COND_CODE'	THEN	 @v_PATIENT_COND_CODE
							WHEN @vColName = 'DISCHARGE_DSP_CODE'	THEN	 @v_DISCHARGE_DSP_CODE
							WHEN @vColName = 'PATIENT_TYPE_CODE'	THEN	 @v_PATIENT_TYPE_CODE
							WHEN @vColName = 'FACILITY_UNIT_CODE'	THEN	 @v_FACILITY_UNIT_CODE							
							WHEN @vColName = 'POSITION_CODE'		THEN	 @v_POSITION_CODE
							WHEN @vColName = 'PAY_TYPE_CODE'		THEN	 @v_PAY_TYPE_CODE
							WHEN @vColName = 'COND_PRIOR_CODE'		THEN	 @v_COND_PRIOR_CODE
							WHEN @vColName = 'RAIL_POSITION_CODE'	THEN	 @v_RAIL_POSITION_CODE
							WHEN @vColName = 'RESTRAINT_CODE'		THEN	 @v_RESTRAINT_CODE
							WHEN @vColName = 'BED_POSITION_CODE'	THEN	 @v_BED_POSITION_CODE
							WHEN @vColName = 'SHARPS_BRAND_MAKE'	THEN	 @v_SHARPS_BRAND_MAKE
							WHEN @vColName = 'SHARPS_OBJECT'		THEN	 @v_SHARPS_OBJECT
							WHEN @vColName = 'SAFEG_PROVIDED'		THEN	 @v_SAFEG_PROVIDED
							WHEN @vColName = 'REPORTED_COUNTRY'		THEN	 @v_REPORTED_COUNTRY
							WHEN @vColName = 'COUNTRY'				THEN	 @V_COUNTRY 
							WHEN @vColName = 'QI_SIGNIF_CODE'		THEN	 @v_QI_SIGNIF_CODE
							WHEN @vColName = 'DISABILITY_CODE'		THEN	 @v_DISABILITY_CODE
							WHEN @vColName = 'RULES_NOT_FOLLOWED'	THEN	 @v_RULES_NOT_FOLLOWED
							WHEN @vColName = 'CALL_LIGHT_CODE'		THEN	 @v_CALL_LIGHT_CODE
							WHEN @vColName = 'NAME_TYPE'			THEN	 @v_NAME_TYPE	
							WHEN @vColName = 'INJURY_1_CODE'		THEN	 @v_INJURY_1_CODE	
							WHEN @vColName = 'INJURY_2_CODE'		THEN	 @v_INJURY_2_CODE		
							WHEN @vColName = 'INJURY_3_CODE'		THEN	 @v_INJURY_3_CODE	
							WHEN @vColName = 'INJURY_4_CODE'		THEN	 @v_INJURY_4_CODE	
							WHEN @vColName = 'INJURY_5_CODE'		THEN	 @v_INJURY_5_CODE	
							WHEN @vColName = 'ILLNESS_CODE'			THEN	 @v_ILLNESS_CODE
							WHEN @vColName = 'SEX_CODE'				THEN	 @v_SEX_CODE
							WHEN @vColName = 'BENEFICIARY_CODE'		THEN	 @v_BENEFICIARY_CODE --DSHARMA70 hmi
																				
							END)
			--print '@vVal : ' + @vVal 
				
		IF @vVal IS NOT NULL AND @vVal <> '' -- MKAUR24 
			BEGIN	
				EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID  = @p_JOBID, 
						@P_SHORT_CODE		    = @vVal , -- Short Code
						@P_SYS_TABLE_NAME       = @vTableName , -- SYstem Table Name to Check
						@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes , -- It is used to check allow creation of code flag is set by user or not						
						@P_DB_NAME			    = @V_DBName , -- It is used to fetch error msg and append into the error msg and update it again
						@P_LOB				    = 0 , -- LOB GC, WC ( It Will be numeric)
						@p_DA_ROW_ID            = @v_DA_ROW_ID,
						@p_MODULE_NAME		    = 'EVENT'  ,
						@p_ERROR_LOCATION       = 'CODEVD31' , --mkaur24
						@p_ERROR_PROC_NAME      = 'DDS_CODE_VALIDATION_IMPORT' ,
						@p_ERROR_KEY_COLUMN		= 'EVENT_NUMBER' ,
						@p_ERROR_COLUMN         =  @vColName , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT' ,
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_CODE_ID_R			  = @iCodeId OUTPUT 	;
					IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	--MKAUR24				   
				   
				   
						IF @vColName      = 'EVENT_TYPE_CODE'       SET  @EVENT_TYPE_CODE_R     = @iCodeId
						ELSE IF @vColName = 'EVENT_STATUS_CODE'	    SET  @EVENT_STATUS_CODE_R   = @iCodeId
						ELSE IF @vColName = 'EVENT_IND_CODE'		SET  @EVENT_IND_CODE_R      = @iCodeId
						ELSE IF @vColName = 'LOCATION_TYPE_CODE'	SET  @LOCATION_TYPE_CODE_R  = @iCodeId
						ELSE IF @vColName = 'CAUSE_CODE'			SET	 @CAUSE_CODE_R          = @iCodeId
						ELSE IF @vColName = 'PRIMARY_LOC_CODE'      SET	 @PRIMARY_LOC_CODE_R    = @iCodeId
						ELSE IF @vColName = 'ACTION_1_CODE'			SET	 @ACTION_1_CODE_R	    = @iCodeId
						ELSE IF @vColName = 'ACTION_2_CODE'			SET	 @ACTION_2_CODE_R       = @iCodeId	--knakra latest starts
						ELSE IF @vColName = 'ACTION_3_CODE'			SET	 @ACTION_3_CODE_R       = @iCodeId
						ELSE IF @vColName = 'ACTION_4_CODE'			SET	 @ACTION_4_CODE_R		= @iCodeId
						ELSE IF @vColName = 'ACTION_5_CODE'			SET	 @ACTION_5_CODE_R		= @iCodeId
						ELSE IF @vColName = 'OUTCOME_1_CODE'		SET	 @OUTCOME_1_CODE_R		= @iCodeId
						ELSE IF @vColName = 'OUTCOME_2_CODE'		SET	 @OUTCOME_2_CODE_R		= @iCodeId
						ELSE IF @vColName = 'OUTCOME_3_CODE'		SET	 @OUTCOME_3_CODE_R		= @iCodeId
						ELSE IF @vColName = 'OUTCOME_4_CODE'		SET	 @OUTCOME_4_CODE_R		= @iCodeId
						ELSE IF @vColName = 'OUTCOME_5_CODE'		SET	 @OUTCOME_5_CODE_R		= @iCodeId
						ELSE IF @vColName = 'MARITAL_STAT_CODE'	    SET	 @MARITAL_STAT_CODE_R	= @iCodeId
						ELSE IF @vColName = 'BODY_PART_1_CODE'		SET	 @BODY_PART_1_CODE_R    = @iCodeId
						ELSE IF @vColName = 'BODY_PART_2_CODE'		SET	 @BODY_PART_2_CODE_R	= @iCodeId
						ELSE IF @vColName = 'BODY_PART_3_CODE'		SET	 @BODY_PART_3_CODE_R	= @iCodeId
						ELSE IF @vColName = 'BODY_PART_4_CODE'		SET	 @BODY_PART_4_CODE_R	= @iCodeId
						ELSE IF @vColName = 'BODY_PART_5_CODE'		SET	 @BODY_PART_5_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DIAGNOSIS_1_CODE'		SET	 @DIAGNOSIS_1_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DIAGNOSIS_2_CODE'		SET	 @DIAGNOSIS_2_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DIAGNOSIS_3_CODE'		SET	 @DIAGNOSIS_3_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DIAGNOSIS_4_CODE'		SET	 @DIAGNOSIS_4_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DIAGNOSIS_5_CODE'		SET	 @DIAGNOSIS_5_CODE_R	= @iCodeId
						ELSE IF @vColName = 'TREATMENT_1_CODE'		SET	 @TREATMENT_1_CODE_R	= @iCodeId
						ELSE IF @vColName = 'TREATMENT_2_CODE'		SET	 @TREATMENT_2_CODE_R	= @iCodeId
						ELSE IF @vColName = 'TREATMENT_3_CODE'		SET	 @TREATMENT_3_CODE_R	= @iCodeId
						ELSE IF @vColName = 'TREATMENT_4_CODE'		SET	 @TREATMENT_4_CODE_R	= @iCodeId
						ELSE IF @vColName = 'TREATMENT_5_CODE'		SET	 @TREATMENT_5_CODE_R	= @iCodeId	--knakra latest ends
						ELSE IF @vColName = 'DRIVERSLICTYPECODE'	SET	 @DRIVERSLICTYPECODE_R	= @iCodeId
						ELSE IF @vColName = 'NCCI_CLASS_CODE'		SET	 @NCCI_CLASS_CODE_R		= @iCodeId
						ELSE IF @vColName = 'DRIVLIC_RSTRCT_CODE'	SET	 @DRIVLIC_RSTRCT_CODE_R = @iCodeId
						ELSE IF @vColName = 'ADM_TYPE_CODE'			SET	 @ADM_TYPE_CODE_R		= @iCodeId
						ELSE IF @vColName = 'ADM_SOURCE_CODE'		SET	 @ADM_SOURCE_CODE_R		= @iCodeId
						ELSE IF @vColName = 'ACUITY_LEVEL_CODE'		SET	 @ACUITY_LEVEL_CODE_R	= @iCodeId
						ELSE IF @vColName = 'PATIENT_STAT_CODE'		SET	 @PATIENT_STAT_CODE_R	= @iCodeId
						ELSE IF @vColName = 'PATIENT_COND_CODE'		SET	 @PATIENT_COND_CODE_R	= @iCodeId
						ELSE IF @vColName = 'DISCHARGE_DSP_CODE'	SET	 @DISCHARGE_DSP_CODE_R	= @iCodeId
						ELSE IF @vColName = 'PATIENT_TYPE_CODE'		SET	 @PATIENT_TYPE_CODE_R	= @iCodeId
						ELSE IF @vColName = 'FACILITY_UNIT_CODE'	SET	 @FACILITY_UNIT_CODE_R	= @iCodeId
						ELSE IF @vColName = 'POSITION_CODE'			SET	 @POSITION_CODE_R	    = @iCodeId
						ELSE IF @vColName = 'PAY_TYPE_CODE'			SET	 @PAY_TYPE_CODE_R		= @iCodeId
						ELSE IF @vColName = 'COND_PRIOR_CODE'		SET	 @COND_PRIOR_CODE_R		= @iCodeId
						ELSE IF @vColName = 'RAIL_POSITION_CODE'	SET	 @RAIL_POSITION_CODE_R	= @iCodeId
						ELSE IF @vColName = 'RESTRAINT_CODE'		SET	 @RESTRAINT_CODE_R		= @iCodeId
						ELSE IF @vColName = 'BED_POSITION_CODE'	    SET	 @BED_POSITION_CODE_R	= @iCodeId
						ELSE IF @vColName = 'SHARPS_BRAND_MAKE'	    SET	 @SHARPS_BRAND_MAKE_R	= @iCodeId
						ELSE IF @vColName = 'SHARPS_OBJECT'			SET	 @SHARPS_OBJECT_R		= @iCodeId
						ELSE IF @vColName = 'SAFEG_PROVIDED'		SET	 @SAFEG_PROVIDED_R		= @iCodeId
						ELSE IF @vColName = 'REPORTED_COUNTRY'		SET	 @REPORTED_COUNTRY_R	= @iCodeId
						ELSE IF @vColName = 'COUNTRY'				SET	 @COUNTRY_R				= @iCodeId
						ELSE IF @vColName = 'QI_SIGNIF_CODE'		SET	 @QI_SIGNIF_CODE_R		= @iCodeId
						ELSE IF @vColName = 'DISABILITY_CODE'		SET	 @DISABILITY_CODE_R		= @iCodeId
						ELSE IF @vColName = 'RULES_NOT_FOLLOWED'	SET	 @RULES_NOT_FOLLOWED_R	= @iCodeId
						ELSE IF @vColName = 'CALL_LIGHT_CODE'		SET	 @CALL_LIGHT_CODE_R		= @iCodeId	
						ELSE IF @vColName = 'NAME_TYPE'				SET	 @NAME_TYPE_R			= @iCodeId
						ELSE IF @vColName = 'INJURY_1_CODE'			SET	 @INJURY_1_CODE_R		= @iCodeId
						ELSE IF @vColName = 'INJURY_2_CODE'			SET	 @INJURY_2_CODE_R		= @iCodeId
						ELSE IF @vColName = 'INJURY_3_CODE'			SET	 @INJURY_3_CODE_R		= @iCodeId
						ELSE IF @vColName = 'INJURY_4_CODE'			SET	 @INJURY_4_CODE_R		= @iCodeId
						ELSE IF @vColName = 'INJURY_5_CODE'			SET	 @INJURY_5_CODE_R		= @iCodeId
						ELSE IF @vColName = 'ILLNESS_CODE'			SET	 @ILLNESS_CODE_R		= @iCodeId	
						ELSE IF @vColName = 'SEX_CODE'				SET	 @SEX_CODE_R			= @iCodeId		
						ELSE IF @vColName = 'BENEFICIARY_CODE'		SET	 @BENEFICIARY_CODE_ID	= @iCodeId	--DSHARMA70 hmi												
											
			END		
						SET @iCodeId = NULL
			END						

			If (upper(@v_PI_TYPE_CODE) <> 'P' AND upper(@v_PI_TYPE_CODE) <> 'E' AND upper(@v_PI_TYPE_CODE) <> 'PHYS' AND upper(@v_PI_TYPE_CODE) <> 'W' AND UPPER(@v_PI_TYPE_CODE) <> 'D' AND UPPER(@v_PI_TYPE_CODE) <> 'MED') OR @v_PI_TYPE_CODE IS NULL   --MKAUR24 3/21/2017 
				--BEGIN 
					SET @v_PI_TYPE_CODE = 'O' 
					--EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID,@v_PI_TYPE_CODE ,'PERSON_INV_TYPE' ,@CheckCreateNewCodes ,@v_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID,'EVENT','CODEVD32' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' ,'PI_TYPE_CODE', 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId  OUTPUT ; --mkaur24 dbname variable and loc
					--IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	--MKAUR24		
					--SET @PI_TYPE_CODE_R = @iCodeId ;
			--	END
			--ELSE 
			--	BEGIN
					EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID,@v_PI_TYPE_CODE ,'PERSON_INV_TYPE' ,@CheckCreateNewCodes ,@V_DBName ,0 ,@v_DA_ROW_ID,'EVENT','CODEVD33' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' ,'PI_TYPE_CODE', 'DDS_EVENT' ,@v_EVENT_NUMBER , @iCodeId OUTPUT ;
					IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	--MKAUR24		
					SET @PI_TYPE_CODE_R = @iCodeId ;
				--END	-- mkaur24 
			--IF @v_PI_LAST_NAME IS NOT NULL --MKAUR24
			--BEGIN
			--IF (upper(@v_DISABILITY_CODE) = 'INJ')	
			--	BEGIN
			--IF @v_INJURY_1_CODE IS NOT NULL
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID, @v_INJURY_1_CODE ,'INJURY_TYPE' ,@CheckCreateNewCodes , @V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD34' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'INJURY_1_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT ; --MKAUR24 1/12 DBNAME AND LOC
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	--MKAUR24		
			--			SET @INJURY_1_CODE_R = @iCodeId ;
			--	END
			--IF @v_INJURY_2_CODE IS NOT NULL --MKAUR24
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID, @v_INJURY_2_CODE ,'INJURY_TYPE' ,@CheckCreateNewCodes , @V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD35' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'INJURY_2_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT ;
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	--MKAUR24		
			--			SET @INJURY_2_CODE_R = @iCodeId ;
			--	END
			--IF @v_INJURY_3_CODE IS NOT NULL
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID, @v_INJURY_3_CODE ,'INJURY_TYPE' ,@CheckCreateNewCodes , @V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD36' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'INJURY_3_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT ;
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	--MKAUR24		
			--			SET @INJURY_3_CODE_R = @iCodeId ;
			--	END
			-- IF @v_INJURY_4_CODE IS NOT NULL
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID, @v_INJURY_4_CODE ,'INJURY_TYPE' ,@CheckCreateNewCodes , @V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD37' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'INJURY_4_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT ;
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	--MKAUR24		
			--			SET @INJURY_4_CODE_R = @iCodeId ;
			--	END
			--IF @v_INJURY_5_CODE IS NOT NULL
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID, @v_INJURY_5_CODE ,'INJURY_TYPE' ,@CheckCreateNewCodes , @V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD38' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'INJURY_5_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT ;
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	--MKAUR24		
			--			SET @INJURY_5_CODE_R = @iCodeId ;
			--	END
			--	END

			--ELSE IF (upper(@v_DISABILITY_CODE) = 'ILL' AND @v_ILLNESS_CODE IS NOT NULL )	--
			--	BEGIN
			--	EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID,  @v_ILLNESS_CODE ,'ILLNESS_TYPE' ,@CheckCreateNewCodes ,@V_DBName ,@v_LINE_OF_BUS_CODE ,@v_DA_ROW_ID, 'EVENT','CODEVD39' , 'DDS_CODE_VALIDATION_IMPORT' , 'EVENT_NUMBER' , 'ILLNESS_CODE' , 'DDS_EVENT' , @v_EVENT_NUMBER , @iCodeId OUTPUT  ;
			--			IF (@iCodeId IS NULL OR @iCodeId = 0) SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	--MKAUR24		
			--			SET @ILLNESS_CODE_R = @iCodeId ;
			--	END
			--END--MKAUR24
				
END  -- CODE VALIDATION ENDS
SET @V_ERROR_LOCATION_MAIN = 'ES4'
BEGIN									  -- EVD4. DATE FORMAT VALIDATION STARTS     

					
					--SET @I_COUNT = 0;	--knakra latest
						
					SET @vColList = 'DATE_REPORTED|DATE_OF_EVENT|DATE_TO_FOLLOW_UP|DATE_PHYS_ADVISED|DATE_CARRIER_NOTIF|'
					SET @vColList = @vColList + 'BIRTH_DATE|DATE_OF_DEATH|DATE_DRIVERSLICEXP|LAST_VERIFIED_DATE|DATE_OF_ADMISSION|DATE_OF_DISCHARGE|DATE_HIRED|WORK_PERMIT_DATE|'
					SET @vColList = @vColList + 'DATE_LAST_WORKED_1|DATE_RETURNED_1|DATE_LAST_WORKED_2|DATE_RETURNED_2|DATE_LAST_WORKED_3|DATE_RETURNED_3|DATE_LAST_WORKED_4|DATE_RETURNED_4|DATE_LAST_WORKED_5|DATE_RETURNED_5|	'
					SET @vColList = @vColList +	'DATE_LAST_WORKED_6|DATE_RETURNED_6|DATE_LAST_WORKED_7|DATE_RETURNED_7|DATE_LAST_WORKED_8|DATE_RETURNED_8|DATE_LAST_WORKED_9|DATE_RETURNED_9|DATE_LAST_WORKED_10|DATE_RETURNED_10|'
					SET @vColList = @vColList +	'DATE_LAST_WORKED_11|DATE_RETURNED_11|DATE_LAST_WORKED_12|DATE_RETURNED_12|DATE_LAST_WORKED_13|DATE_RETURNED_13|DATE_LAST_WORKED_14|DATE_RETURNED_14|DATE_LAST_WORKED_15|DATE_RETURNED_15|'
					
					IF @HEALTH_LOB_ID > 0 SET @vColList = @vColList + 'REPORTED_BIRTH_DT|'

					IF ((@v_PI_LAST_NAME IS NOT NULL) and (@v_PI_LAST_NAME <> '') )
					 BEGIN
					 SET @vColList = @vColList + 'BIRTH_DATE|'
					
					 END
				WHILE CHARINDEX('|',@vColList,1) > 0				--
						BEGIN							
								SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
								SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
								
								SET @vVal = (CASE
								WHEN @vColName = 'DATE_REPORTED'      THEN @v_DATE_REPORTED
								WHEN @vColName = 'DATE_OF_EVENT'	  THEN @v_DATE_OF_EVENT	
								WHEN @vColName = 'DATE_TO_FOLLOW_UP'  THEN @v_DATE_TO_FOLLOW_UP	
								WHEN @vColName = 'DATE_PHYS_ADVISED'  THEN @v_DATE_PHYS_ADVISED
								WHEN @vColName = 'DATE_CARRIER_NOTIF' THEN @v_DATE_CARRIER_NOTIF								
								WHEN @vColName = 'BIRTH_DATE'		  THEN @v_BIRTH_DATE
								WHEN @vColName = 'DATE_OF_DEATH'	  THEN @v_DATE_OF_DEATH		
								WHEN @vColName = 'DATE_DRIVERSLICEXP' THEN @v_DATE_DRIVERSLICEXP								
								WHEN @vColName = 'LAST_VERIFIED_DATE' THEN @v_LAST_VERIFIED_DATE
								WHEN @vColName = 'DATE_OF_ADMISSION'  THEN @v_DATE_OF_ADMISSION
								WHEN @vColName = 'DATE_OF_DISCHARGE'  THEN @v_DATE_OF_DISCHARGE	
								WHEN @vColName = 'DATE_HIRED'         THEN @v_DATE_HIRED
								WHEN @vColName = 'WORK_PERMIT_DATE'   THEN @v_WORK_PERMIT_DATE
								WHEN @vColName = 'DATE_LAST_WORKED_1' THEN @v_DATE_LAST_WORKED_1
								WHEN @vColName = 'DATE_RETURNED_1'   THEN @v_DATE_RETURNED_1
								WHEN @vColName = 'DATE_LAST_WORKED_2' THEN @v_DATE_LAST_WORKED_2
								WHEN @vColName = 'DATE_RETURNED_2'   THEN @v_DATE_RETURNED_2
								WHEN @vColName = 'DATE_LAST_WORKED_3' THEN @v_DATE_LAST_WORKED_3
								WHEN @vColName = 'DATE_RETURNED_3'   THEN @v_DATE_RETURNED_3
								WHEN @vColName = 'DATE_LAST_WORKED_4' THEN @v_DATE_LAST_WORKED_4
								WHEN @vColName = 'DATE_RETURNED_4'   THEN @v_DATE_RETURNED_4
								WHEN @vColName = 'DATE_LAST_WORKED_5' THEN @v_DATE_LAST_WORKED_5
								WHEN @vColName = 'DATE_RETURNED_5'   THEN @v_DATE_RETURNED_5
								WHEN @vColName = 'DATE_LAST_WORKED_6' THEN @v_DATE_LAST_WORKED_6
								WHEN @vColName = 'DATE_RETURNED_6'   THEN @v_DATE_RETURNED_6
								WHEN @vColName = 'DATE_LAST_WORKED_7' THEN @v_DATE_LAST_WORKED_7
								WHEN @vColName = 'DATE_RETURNED_7'   THEN @v_DATE_RETURNED_7
								WHEN @vColName = 'DATE_LAST_WORKED_8' THEN @v_DATE_LAST_WORKED_8
								WHEN @vColName = 'DATE_RETURNED_8'   THEN @v_DATE_RETURNED_8
								WHEN @vColName = 'DATE_LAST_WORKED_9' THEN @v_DATE_LAST_WORKED_9
								WHEN @vColName = 'DATE_RETURNED_9'   THEN @v_DATE_RETURNED_9
								WHEN @vColName = 'DATE_LAST_WORKED_10' THEN @v_DATE_LAST_WORKED_10
								WHEN @vColName = 'DATE_RETURNED_10'   THEN @v_DATE_RETURNED_10
								WHEN @vColName = 'DATE_LAST_WORKED_11' THEN @v_DATE_LAST_WORKED_11
								WHEN @vColName = 'DATE_RETURNED_11'   THEN @v_DATE_RETURNED_11
								WHEN @vColName = 'DATE_LAST_WORKED_12' THEN @v_DATE_LAST_WORKED_12
								WHEN @vColName = 'DATE_RETURNED_12'   THEN @v_DATE_RETURNED_12
								WHEN @vColName = 'DATE_LAST_WORKED_13' THEN @v_DATE_LAST_WORKED_13
								WHEN @vColName = 'DATE_RETURNED_13'   THEN @v_DATE_RETURNED_13
								WHEN @vColName = 'DATE_LAST_WORKED_14' THEN @v_DATE_LAST_WORKED_14
								WHEN @vColName = 'DATE_RETURNED_14'   THEN @v_DATE_RETURNED_14
								WHEN @vColName = 'DATE_LAST_WORKED_15' THEN @v_DATE_LAST_WORKED_15
								WHEN @vColName = 'DATE_RETURNED_15'   THEN @v_DATE_RETURNED_15	
								--WHEN @vColName = 'BIRTH_DATE'   THEN  @v_BIRTH_DATE		knakra latest(redundent)
								WHEN @vColName = 'REPORTED_BIRTH_DT'   THEN @v_REPORTED_BIRTH_DT
												
								END)	
					IF @vVal IS NOT NULL
						BEGIN 
							IF LEN(@vVal) <> 8 OR ISNUMERIC(@vVal) = 0 OR ISDATE(@vVal) = 0
								BEGIN
									EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'DATEFORMAT', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = 'Invalid Date. Please provide Date in YYYYMMDD format .' ,
										@p_ERROR_COLUMNS = @vColName , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
										@P_IS_VALIDATION = 1 ; 
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
										--PRINT '@I_ERRORCOUNT ' + CAST (@I_ERRORCOUNT AS VARCHAR )
										
										IF @vColName = 'DATE_REPORTED'  SET @V_DATE_REPORTED_INVALID = 1;
								   ELSE IF @vColName = 'DATE_OF_EVENT'  SET @V_DATE_OF_EVENT_INVALID = 1;									
 ELSE IF @vColName = 'DATE_OF_DEATH' SET @V_DATE_OF_DEATH_INVALID  = 1 ;

 ELSE IF @vColName = 'DATE_OF_HIRE' SET @V_DATE_HIRED_INVALID  = 1 ;
							  END
							ELSE 
							BEGIN
								IF ISDATE(@vVal) <> 0
								  BEGIN
									IF  (@VALID_START_DATE > @vVal) or  ( @vVal > @VALID_END_DATE)
										BEGIN
											EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = 'DATEFORMAT2', 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = 'Date must fall between the date range selected at UI .' ,
											@p_ERROR_COLUMNS = @vColName , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ; 
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
												IF @vColName = 'DATE_REPORTED'  SET @V_DATE_REPORTED_INVALID = 1;
								   ELSE IF @vColName = 'DATE_OF_EVENT'  SET @V_DATE_OF_EVENT_INVALID = 1;	
 ELSE IF @vColName = 'DATE_OF_DEATH' SET @V_DATE_OF_DEATH_INVALID  = 1 ; 
 ELSE IF @vColName = 'DATE_OF_HIRE' SET @V_DATE_HIRED_INVALID  = 1 ;
										END	
								  END
							END		
						
						END
							--SET @iCount = @iCount + 1	--knakra latest
		END	
						
END  -- DATE FORMAT VALIDATION ENDS
SET @V_ERROR_LOCATION_MAIN = 'ES5'		
BEGIN									  -- EVD5. TIME FORMAT VALIDATION STARTS 
--PRINT 'ENETRETD TIME VD'
					--SET @I_COUNT = 0;
					SET @vColList = 'TIME_OF_EVENT|TIME_REPORTED|TIME_PHYS_ADVISED|WORKDAY_START_TIME|'
				
				WHILE CHARINDEX('|',@vColList,1) > 0				--
						BEGIN						
								SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
								SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))								
								SET @vVal = (CASE									
								WHEN @vColName = 'TIME_OF_EVENT'	  THEN @v_TIME_OF_EVENT								
								WHEN @vColName = 'TIME_REPORTED '      THEN @v_TIME_REPORTED
								WHEN @vColName = 'TIME_PHYS_ADVISED'      THEN @v_TIME_PHYS_ADVISED		--knakra latest						
								WHEN @vColName = 'WORKDAY_START_TIME'  THEN @v_WORKDAY_START_TIME		--knakra latest
								END)
							IF 	@vVal IS NOT NULL
								BEGIN TRY	
									declare @v_CheckTime as VARCHAR(100)
							--select (  CAST(STUFF(STUFF(cast(@vVal as varchar),3,0,':'),6,0,':')AS TIME))
							SET @v_CheckTime = (select cast(CAST(STUFF(STUFF(cast(@vVal as varchar),3,0,':'),6,0,':')AS TIME) as varchar(100)) as time)
								--print @v_CheckTime
						
								END TRY								
								BEGIN CATCH
										 SET 	@V_ERROR_MESSAGE = ERROR_MESSAGE()	 
										 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'Main', 
												@p_CURRENT_ERROR_LOCATION = 'INVALIDTIME', 
												@p_ERROR_PROC_NAME = @V_PROCNAME ,
												@p_ERROR_MSG = @V_ERROR_MESSAGE ,
												@p_ERROR_COLUMNS = @vColName , 
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
												@P_IS_VALIDATION = 1 ;
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
									IF @vColName = 'TIME_OF_EVENT' SET @v_TIME_OF_EVENT_INVALID = 1 ;
									IF @vColName = 'TIME_REPORTED' SET @v_TIME_REPORTED_INVALID = 1 ;				 
								END CATCH										
										--SET @iCount = @iCount + 1 ;	
							
							
							
						END
END 
SET @V_ERROR_LOCATION_MAIN = 'ES6'
BEGIN									  -- EVD6. DATE AND TIME VALIDATION STARTS	
			--•Date Reported Must be >= Event Date
		--print '@V_DATE_REPORTED_INVALID ' + cast (@V_DATE_REPORTED_INVALID as varchar )
		--print '@V_DATE_OF_EVENT_INVALID ' + cast (@V_DATE_OF_EVENT_INVALID as varchar )
			IF (@V_DATE_REPORTED_INVALID =  0 AND @V_DATE_OF_EVENT_INVALID = 0)
			BEGIN
			IF @v_DATE_REPORTED < @v_DATE_OF_EVENT  
				BEGIN
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Date', 
						@p_CURRENT_ERROR_LOCATION = 'D1', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'Date Reported Must be greater than or equal to Event Date' ,
						@p_ERROR_COLUMNS = 'DATE_REPORTED' , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;  
							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
				END
			END	
			
			--MK TODAY S
			--print 'MK TODAY S'
			--print '@v_DATE_REPORTED'
			--SET @V_DATE_REPORTED_INVALID =  0
			--SET @v_DATE_REPORTED = '20160207'
				SET @v_GETDate = convert(varchar(8),getdate(),112) --MY CHNAGE MKAUR24
				IF (@V_DATE_REPORTED_INVALID =  0 )
			BEGIN
			
			IF @v_DATE_REPORTED >  @v_GETDate
				BEGIN
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Date', 
						@p_CURRENT_ERROR_LOCATION = 'D4', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'Date Reported cannot be greater than system date ' ,
						@p_ERROR_COLUMNS = 'DATE_REPORTED' , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;  
							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
				END
			END	
			--	print 'MK TODAY S2'
			--SET @V_DATE_OF_EVENT_INVALID = 0
			--SET @v_DATE_OF_EVENT = '20160206'
				IF ( @V_DATE_OF_EVENT_INVALID = 0)
			BEGIN
			IF    @v_DATE_OF_EVENT  >  @v_GETDate
				BEGIN
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Date', 
						@p_CURRENT_ERROR_LOCATION = 'D5', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'DATE OF EVENT cannot be greater than system date ' ,
						@p_ERROR_COLUMNS = 'DATE_OF_EVENT' , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;  
							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
				END
			END	
			--MK TODAY END
			
							
			----•Time Reported Must be >= Event Time: 12:00:00 PM
			IF (@v_TIME_OF_EVENT_INVALID = 0 AND @v_TIME_REPORTED_INVALID = 0) AND (@v_DATE_REPORTED = @v_DATE_OF_EVENT  )
			BEGIN
			IF @v_TIME_REPORTED < @v_TIME_OF_EVENT  
				BEGIN
						EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Date', 
						@p_CURRENT_ERROR_LOCATION = 'D1', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'Time Reported Must be greater than or equal to Event Time .' ,
						@p_ERROR_COLUMNS = 'TIME_REPORTED' , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;
							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;					
				END	
		END
 --MKAUR24 START
  IF ( @V_DATE_OF_DEATH_INVALID = 0) AND  (@V_DATE_OF_EVENT_INVALID = 0) AND  (@V_DATE_OF_DEATH < @V_DATE_OF_EVENT)
 BEGIN
 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
 @p_DA_ROW_ID = @V_DA_ROW_ID , 
 @p_MODULE_NAME = @V_MODULENAME ,
 @p_CALLING_ERROR_LOCATION = 'Date', 
 @p_CURRENT_ERROR_LOCATION = 'D5.1', 
 @p_ERROR_PROC_NAME = @V_PROCNAME ,
 @p_ERROR_MSG = 'DATE OF DEATH cannot be less than DATE OF EVENT.  ' ,
 @p_ERROR_COLUMNS = 'DATE_OF_DEATH ' , 
 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER', 
 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
 @P_IS_VALIDATION = 1 ; 
 SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
 END


   IF ( @V_DATE_OF_EVENT_INVALID = 0) AND  (@V_DATE_HIRED_INVALID   = 0) AND  (@V_DATE_HIRED > @V_DATE_OF_EVENT)
 BEGIN
 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
 @p_DA_ROW_ID = @V_DA_ROW_ID , 
 @p_MODULE_NAME = @V_MODULENAME ,
 @p_CALLING_ERROR_LOCATION = 'Date', 
 @p_CURRENT_ERROR_LOCATION = 'D5.4', 
 @p_ERROR_PROC_NAME = @V_PROCNAME ,
 @p_ERROR_MSG = 'DATE HIRED cannot be greater than DATE OF EVENT.  ' ,
 @p_ERROR_COLUMNS = 'DATE_HIRED' , 
 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER', 
 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
 @P_IS_VALIDATION = 1 ; 
 SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
 END
 IF ( @V_DATE_OF_DEATH_INVALID   = 0) AND  (@V_DATE_HIRED_INVALID   = 0) AND  (@V_DATE_HIRED > @V_DATE_OF_DEATH)
 BEGIN
 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
 @p_DA_ROW_ID = @V_DA_ROW_ID , 
 @p_MODULE_NAME = @V_MODULENAME ,
 @p_CALLING_ERROR_LOCATION = 'Date', 
 @p_CURRENT_ERROR_LOCATION = 'D5.4', 
 @p_ERROR_PROC_NAME = @V_PROCNAME ,
 @p_ERROR_MSG = 'DATE OF DEATH cannot be less than DATE OF HIRE  ' ,
 @p_ERROR_COLUMNS = 'DATE_OF_DEATH' , 
 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER', 
 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
 @P_IS_VALIDATION = 1 ; 
 SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
 END
 --MKAUR24 END  
 
END	
SET @V_ERROR_LOCATION_MAIN = 'ES7'
BEGIN									  -- EVD7. STATE VALIDATION   neha commenting state validation
						
					SET @vColList = 'STATE|REPORTED_STATE|' --MKAUR24
							
					IF @v_PI_LAST_NAME IS NOT NULL AND (@v_PI_LAST_NAME <> '')  
						 BEGIN
			             SET @vColList = @vColList + 'PI_STATE|DRIVLIC_STATE|SUPER_STATE|' --MKAUR24
						 END
				
				WHILE CHARINDEX('|',@vColList,1) > 0				--
						BEGIN		
								SET @STATE_ROW_ID_R = 0					
								SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
								SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))								
								
								SET @vVal = (CASE									
								WHEN @vColName = 'STATE'		  THEN UPPER(@v_STATE)							
								WHEN @vColName = 'REPORTED_STATE' THEN UPPER(@v_REPORTED_STATE)
								WHEN @vColName = 'PI_STATE'       THEN UPPER(@v_PI_STATE)							
								WHEN @vColName = 'DRIVLIC_STATE'  THEN UPPER(@v_DRIVLIC_STATE)
								WHEN @vColName = 'SUPER_STATE'    THEN UPPER (@v_SUPER_STATE)
								END)	
							IF @vVal IS NOT NULL
							BEGIN
									SET @N_SQL = 'SELECT @STATE_ROW_ID_P = STATE_ROW_ID  FROM ' + @V_DBName +' STATES ';
									SET @N_SQL =  @N_SQL + ' WHERE UPPER(STATE_ID) = @vVal_P  ';									
										BEGIN TRY
										Exec sp_Executesql @N_SQL,
											 N' @STATE_ROW_ID_P INT OUTPUT,											 
											 @vVal_P VARCHAR(25)',									
											 @STATE_ROW_ID_P = @STATE_ROW_ID_R OUTPUT,											
											 @vVal_P = @vVal;											  
										END TRY
										BEGIN CATCH
													 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
													 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
															@p_DA_ROW_ID  = @V_DA_ROW_ID , 
															@p_MODULE_NAME = @V_MODULENAME ,
															@p_CALLING_ERROR_LOCATION = 'Main', 
															@p_CURRENT_ERROR_LOCATION = 'STATESVD', 
															@p_ERROR_PROC_NAME = @V_PROCNAME ,
															@p_ERROR_MSG = @V_ERROR_MESSAGE ,
															@p_ERROR_COLUMNS = NULL , 
															@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
															@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
															@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
															@P_IS_VALIDATION = 0 ; 	
															SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
										 END CATCH									
										 IF (@STATE_ROW_ID_R = 0 )
										 BEGIN
												EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'Main', 
												@p_CURRENT_ERROR_LOCATION = 'STATEVD', 
												@p_ERROR_PROC_NAME = @V_PROCNAME ,
												@p_ERROR_MSG = 'Invalid STATE. Please provide  a valid state.' ,
												@p_ERROR_COLUMNS = @vColName , 
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  -- MKAUR24 1/12 
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
												@P_IS_VALIDATION = 1 ; 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
										END
										IF (@STATE_ROW_ID_R > 0 )
										BEGIN
										 If @vColName = 'STATE'	         SET @v_STATE_R           = @STATE_ROW_ID_R
									ELSE If @vColName = 'REPORTED_STATE' SET @v_REPORTED_STATE_R  = @STATE_ROW_ID_R									  
									ELSE If @vColName = 'PI_STATE'		 SET @v_PI_STATE_R        = @STATE_ROW_ID_R
									ELSE If @vColName = 'DRIVLIC_STATE'	 SET @v_DRIVLIC_STATE_R   = @STATE_ROW_ID_R	
									ELSE If @vColName = 'SUPER_STATE'	 SET @v_SUPER_STATE_R     = @STATE_ROW_ID_R	  	
										END	
							END	
							
						END	
								 


END 
SET @V_ERROR_LOCATION_MAIN = 'ES8'
BEGIN 									  -- EVD8. DISABILITY_CODE VALIDATION STARTS 

			IF 	UPPER(@v_DISABILITY_CODE ) = 'ILL' AND  @v_ILLNESS_CODE IS  NULL
				BEGIN
							SET @V_CLOCATION = 'Dis1' ;
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
						 @p_DA_ROW_ID = @V_DA_ROW_ID , 
						 @p_MODULE_NAME = @V_MODULENAME,
						 @p_CALLING_ERROR_LOCATION = 'Dis' ,	
						 @p_CURRENT_ERROR_LOCATION  = @V_CLOCATION, 
						 @p_ERROR_PROC_NAME = @V_PROCNAME,
						 @p_ERROR_MSG = 'The Disability code is provided as ILL howvever no value is provided for ILLNESS_CODE' , -- REQUIRED FIELD --
						 @p_ERROR_COLUMNS = 'ILLNESS_CODE', 
						 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
						 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						 @P_IS_VALIDATION = 1 ;
							SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
				END					
			
			IF  (UPPER(@v_DISABILITY_CODE) = 'INJ'   AND(  (@v_INJURY_1_CODE  IS  NULL ) AND 
				(@v_INJURY_2_CODE  IS  NULL ) AND (@v_INJURY_3_CODE  IS  NULL ) AND 
				(@v_INJURY_4_CODE  IS  NULL ) AND (@v_INJURY_5_CODE  IS  NULL ) ) )
				 BEGIN
							 SET @V_CLOCATION = 'Dis2' ;
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
						 @p_DA_ROW_ID = @V_DA_ROW_ID , 
						 @p_MODULE_NAME = @V_MODULENAME,
						 @p_CALLING_ERROR_LOCATION = 'Dis' ,	
						 @p_CURRENT_ERROR_LOCATION  = @V_CLOCATION, 
						 @p_ERROR_PROC_NAME = @V_PROCNAME,
						 @p_ERROR_MSG = 'The Disability code is provided as INJ however no value is provided for INJURY_CODE', -- JIRA 20454 MKAUR24
						 @p_ERROR_COLUMNS = 'INJURY_CODE', 
						 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
						 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;
							SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
					END			
			
			IF 	(@v_ILLNESS_CODE IS NOT NULL) AND	--MKAUR24 kdd
				((@v_INJURY_1_CODE  IS NOT NULL )OR (@v_INJURY_2_CODE  IS NOT NULL ) OR 
				(@v_INJURY_3_CODE  IS NOT NULL ) OR (@v_INJURY_4_CODE  IS NOT  NULL ) OR (@v_INJURY_5_CODE  IS NOT  NULL ))			
				 BEGIN
						SET @V_ERROR_COLUMN = NULL
						--IF 	UPPER(@v_DISABILITY_CODE) = 'INJ' SET @V_ERROR_COLUMN = 'ILLNESS_CODE'
						--IF 	UPPER(@v_DISABILITY_CODE) = 'ILL' 
					
					SET @V_ERROR_COLUMN = ''
					IF @v_ILLNESS_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = 'ILLNESS_CODE' 
					IF @v_INJURY_1_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = @V_ERROR_COLUMN + ',INJURY_1_CODE'					
					IF @v_INJURY_2_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = @V_ERROR_COLUMN + ',INJURY_2_CODE' 
					IF @v_INJURY_3_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = @V_ERROR_COLUMN + ',INJURY_3_CODE' 	
					IF @v_INJURY_4_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = @V_ERROR_COLUMN + ',INJURY_4_CODE' 	
					IF @v_INJURY_5_CODE IS NOT NULL
						SET @V_ERROR_COLUMN = @V_ERROR_COLUMN + ',INJURY_5_CODE' 
							
							
							 SET @V_CLOCATION = 'Dis3' ;
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
						 @p_DA_ROW_ID = @V_DA_ROW_ID , 
						 @p_MODULE_NAME = @V_MODULENAME,
						 @p_CALLING_ERROR_LOCATION = 'Dis' ,	
						 @p_CURRENT_ERROR_LOCATION  = @V_CLOCATION, 
						 @p_ERROR_PROC_NAME = @V_PROCNAME,
						 @p_ERROR_MSG = 'Values are provided for both ILLNESS_CODE and INJURY_CODE.Please provide value for the column specific to the code provided for Disablity Code' , -- REQUIRED FIELD -- 
						 @p_ERROR_COLUMNS = @V_ERROR_COLUMN, 
						 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
						 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;
					        SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
				 END			
				 
			
END
SET @V_ERROR_LOCATION_MAIN = 'ES9'
BEGIN									  -- EVD9. DEPARTMENT / DEPT_INVOLVED / OSHA_ESTAB_EID COMBINED /DEPT_ASSIGNED/FACILITY_DEPT
					

SET @vColList = 'DEPARTMENT|DEPT_INVOLVED|OSHA_ESTAB_EID|'
SET @vTableList = 'DEPARTMENT|DEPARTMENT|OSHA_ESTABLISHMENT|'
	IF @v_PI_LAST_NAME IS NOT NULL AND (@v_PI_LAST_NAME <> '')    --mkaur24
		BEGIN
			 IF UPPER (@v_PI_TYPE_CODE) = 'E'	
				BEGIN						
				SET @vColList = @vColList + 'DEPT_ASSIGNED|'
				SET @vTableList = @vTableList + 'DEPARTMENT|'
				END
			IF UPPER(@v_PI_TYPE_CODE) = 'P'	
				BEGIN						
				SET @vColList = @vColList + 'FACILITY_DEPT|'
				SET @vTableList = @vTableList + 'DEPARTMENT|'
				END
		END

			WHILE CHARINDEX('|',@vColList,1) > 0				--
			BEGIN
				SET @i_ENTITY_ID = 0;
				SET @i_DELETED_FLAG = 0 ;
				SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
				SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
				SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
				SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))	
					BEGIN
					SET @vColToProcess = '@v_' + @vColName 						 
					SET @vVal = (CASE
					WHEN @vColToProcess = '@v_DEPARTMENT' THEN UPPER (@v_DEPARTMENT)
					WHEN @vColToProcess = '@v_DEPT_INVOLVED' THEN UPPER(@v_DEPT_INVOLVED)
					WHEN @vColToProcess = '@v_OSHA_ESTAB_EID' THEN UPPER(@v_OSHA_ESTAB_EID)
					WHEN @vColToProcess = '@v_DEPT_ASSIGNED' THEN UPPER(@v_DEPT_ASSIGNED)
					WHEN @vColToProcess = '@v_FACILITY_DEPT' THEN UPPER(@v_FACILITY_DEPT)
					END)	
					IF @vVal IS NOT NULL
					BEGIN
						 --SET @N_SQL =  'SELECT @i_ENTITY_ID_P =  E.ENTITY_ID , @i_DELETED_FLAG_P = G.DELETED_FLAG FROM ' +  @V_DBName  + ' ENTITY E ,  ' ;	--knakra latest
						 SET @N_SQL =  'SELECT @i_ENTITY_ID_P =  E.ENTITY_ID , @i_DELETED_FLAG_P = E.DELETED_FLAG FROM ' +  @V_DBName  + ' ENTITY E ,  ' ;		--knakra latest(it should be E.DELETED_FLAG and not G>DELETED_FLAG)
						 SET @N_SQL =	@N_SQL +  @V_DBName + ' GLOSSARY G WHERE E.ENTITY_TABLE_ID = G.TABLE_ID '  ;
						 SET @N_SQL =	@N_SQL +  ' AND UPPER(E.ABBREVIATION) = @vVal_P  AND G.system_TABLE_NAME = @SYS_TABLE_NAME_P ' ;
						 --TZ1 MK(use deleted flag as well in the select query) --mkaur24 back 
						-- print '@N_SQL -> ' + @N_SQL ;
								BEGIN TRY
									  Exec sp_Executesql @N_SQL, 
											N' @i_ENTITY_ID_P INT output,	
											@i_DELETED_FLAG_P INT output,										
											@vVal_P	varchar(25) ,   
											@SYS_TABLE_NAME_P VARCHAR(255)',
											@i_ENTITY_ID_P = @i_ENTITY_ID OUTPUT,
											@i_DELETED_FLAG_P = @i_DELETED_FLAG OUTPUT,
											@vVal_P =  @vVal ,											
											@SYS_TABLE_NAME_P = @vTableName ;  
								END TRY
								 BEGIN CATCH	
											 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
											 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
													@p_DA_ROW_ID  = @V_DA_ROW_ID , 
													@p_MODULE_NAME = @V_MODULENAME ,
													@p_CALLING_ERROR_LOCATION = 'Main', 
													@p_CURRENT_ERROR_LOCATION = 'DEPT/OSHA1', 
													@p_ERROR_PROC_NAME = @V_PROCNAME ,
													@p_ERROR_MSG = @V_ERROR_MESSAGE ,
													@p_ERROR_COLUMNS = NULL , 
													@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
													@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
													@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
													@P_IS_VALIDATION = 0 ; 	
													SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								 END CATCH
								
							If    @vColName = 'DEPARTMENT'
								  BEGIN 
						 				SET @i_DEPARTMENT_GEN  = @i_ENTITY_ID  ; --DEPARTMENT ID GENERATED	
									 	
								  END
					ELSE		If   @vColName = 'DEPT_INVOLVED'
								  BEGIN 
						 				SET @i_DEPT_INVOLVED_GEN = @i_ENTITY_ID  ; --DEPT_INVOLVED  GENERATED	
									 	
								  END
					ELSE		If   @vColName = 'OSHA_ESTAB_EID'
								  BEGIN 
						 				SET @I_OSHA_ESTAB_EID_GEN = @i_ENTITY_ID -- OSHA_ESTAB_EID GENERATED 						 	
								  END

					ELSE		If   @vColName = 'DEPT_ASSIGNED' --MKAUR24
								  BEGIN 
						 				SET @I_DEPT_ASSIGNED_GEN = @i_ENTITY_ID -- DEPT_ASSIGNED GENERATED 						 	
								  END


					ELSE		If   @vColName = 'FACILITY_DEPT' --MKAUR24
								  BEGIN 
						 				SET @I_FACILITY_DEPT_GEN = @i_ENTITY_ID -- FACILITY_DEPT GENERATED 						 	
								  END
							--MKAUR24
							IF (( @i_ENTITY_ID = 0  OR (@i_ENTITY_ID > 0 and @i_DELETED_FLAG <> 0))AND @CheckCreateNewDEPARTMENT = 0 AND @vColName <> 'OSHA_ESTAB_EID') OR ((@i_ENTITY_ID = 0 OR (@i_ENTITY_ID > 0 AND @i_DELETED_FLAG <> 0)) AND @vColName = 'OSHA_ESTAB_EID')
							BEGIN			
								SET @V_ERROR_MESSAGE = 	'The value provided for the COLUMN  : ' + @vColName + ' does not exist or has been deleted.Please provide a valid entity / Incase of department related columns check allow creation of new dept if wants to create new dept. ' ;
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											 @p_DA_ROW_ID = @V_DA_ROW_ID , 
											 @p_MODULE_NAME = @V_MODULENAME,
											 @p_CALLING_ERROR_LOCATION =  'MAIN',	
											 @p_CURRENT_ERROR_LOCATION  = 'DEPT/OSHA2' , 
											 @p_ERROR_PROC_NAME = @V_PROCNAME,
											 @p_ERROR_MSG = @V_ERROR_MESSAGE ,
											 @p_ERROR_COLUMNS = @vColName, 
											 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;  										 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
							END	
							--MKAUR24
						
					END
		
			END
END
END	
SET @V_ERROR_LOCATION_MAIN = 'ES10'


IF   (@CheckCreateNewDEPARTMENT <> 0)  --MKAUR24
		BEGIN
								
								SET @vColList = 'DEPARTMENT|DEPT_INVOLVED|'
								SET @vTableList = 'DEPARTMENT|DEPARTMENT|'
								

								IF @v_PI_LAST_NAME IS NOT NULL AND (@v_PI_LAST_NAME <> '')    --mkaur24
									BEGIN
										 IF UPPER (@v_PI_TYPE_CODE) = 'E'	
											BEGIN						
											SET @vColList = @vColList + 'DEPT_ASSIGNED|'
											SET @vTableList = @vTableList + 'DEPARTMENT|'
											END
										IF UPPER(@v_PI_TYPE_CODE) = 'P'	
											BEGIN						
											SET @vColList = @vColList + 'FACILITY_DEPT|'
											SET @vTableList = @vTableList + 'DEPARTMENT|'
											END
									END
																	
																
								WHILE CHARINDEX('|',@vColList,1) > 0				--
								BEGIN
									
									SET @iEidForDept = 0 ;
									SET @iEntId = 0
									SET @I_COUNT = 0;	
									SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
									SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
									SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
									SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))	
									SET @vColToProcess = '@v_' + @vColName 						 
										--SET @vVal = (CASE
										--WHEN @vColToProcess = '@v_DEPARTMENT' THEN	@v_DEPARTMENT --MKAUR24
										--WHEN @vColToProcess = '@v_DEPT_INVOLVED' THEN @v_DEPT_INVOLVED	
										--WHEN @vColToProcess = '@v_DEPT_ASSIGNED' THEN @v_DEPT_ASSIGNED
										--WHEN @vColToProcess = '@v_FACILITY_DEPT' THEN @v_FACILITY_DEPT
										--END)
										IF @vColToProcess = '@v_DEPARTMENT'
										BEGIN
											SET @vVal = @v_DEPARTMENT
											SET @iEidForDept = @i_DEPARTMENT_GEN
										END
										IF @vColToProcess = '@v_DEPT_INVOLVED'
										BEGIN
											SET @vVal = @v_DEPT_INVOLVED
											SET @iEidForDept = @i_DEPT_INVOLVED_GEN
										END
										IF @vColToProcess = '@v_DEPT_ASSIGNED'
										BEGIN
											SET @vVal = @v_DEPT_ASSIGNED
											SET @iEidForDept = @i_DEPT_ASSIGNED_GEN
										END
										IF @vColToProcess = '@v_FACILITY_DEPT'
										BEGIN
											SET @vVal = @v_FACILITY_DEPT
											SET @iEidForDept = @i_FACILITY_DEPT_GEN
										END
										
								IF @vVal IS NOT NULL  AND @iEidForDept = 0 --MKUAR24 
									BEGIN
										SET @V_ERROR_LOCATION = 'I1' ;
										SET @iEntId = 0;
										INSERT INTO @Department  ( IJOBID , IDAROWID , VDEPARTMENT  )
										VALUES (@p_jobID , @v_DA_ROW_ID , @vVal ) 
										BEGIN TRY			--MKAUR24			 					
											--EXEC DDS_PROCESSORG_HIERARCHY @Department, @p_jobID, @v_DA_ROW_ID, @p_DBName,  @iEntId OUTPUT -- CREATE NEW ENTITY EVEN IF EXISTS						
										EXEC DDS_PROCESSORG_HIERARCHY @tORG_HIERARCHY = @Department ,											
											@P_JOBID		=  @p_jobID , 
											@P_DA_ROW_ID	= @v_DA_ROW_ID	,
											@P_DBNAME		= @p_DBName,
											@P_KEYCOLUMN	= 'EVENT_NUMBER',
											@P_KEY_VALUE	= @v_EVENT_NUMBER ,
											@P_ENTITY_ID	= @iEntId  OUTPUT	
											
											SET @V_ERROR_LOCATION = 'I2' ;
										END TRY			
										BEGIN CATCH	
												  SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
												  EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
													@p_DA_ROW_ID  = @V_DA_ROW_ID , 
													@p_MODULE_NAME = @V_MODULENAME ,
													@p_CALLING_ERROR_LOCATION = 'Main', 
													@p_CURRENT_ERROR_LOCATION = 'CREATEDEPT', 
													@p_ERROR_PROC_NAME = @V_PROCNAME ,
													@p_ERROR_MSG = @V_ERROR_MESSAGE ,
													@p_ERROR_COLUMNS = NULL , 
													@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
													@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
													@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
													@P_IS_VALIDATION = 0 ; 
													SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
									 END CATCH	
											 IF @vColName = 'DEPARTMENT' SET @i_DEPARTMENT_GEN = @iEntId
									ELSE	 IF @vColName = 'DEPT_INVOLVED' SET @i_DEPT_INVOLVED_GEN = @iEntId
									ELSE	 IF @vColName = 'FACILITY_DEPT' SET @i_FACILITY_DEPT_GEN = @iEntId
									ELSE	 IF @vColName = 'DEPT_ASSIGNED' SET @i_DEPT_ASSIGNED_GEN = @iEntId
									END
								
								END

		END	-- EI2. CREATE NEW DEPARMENT


BEGIN									  -- EVD10. REPORTER ENTITY (PROCESS ENTITY) 
			IF ( @v_REPORTED_LAST_NAME IS NOT NULL AND 	@v_REPORTED_LAST_NAME <> ''  AND 	@v_REPORTED_FIRST_NAME IS NOT NULL AND 	@v_REPORTED_FIRST_NAME <> '' )  AND @iRptdTidErr = 0	--knakra latest(taxid error check)
				BEGIN
					SET @iNoError = 1	--knakra latest
					--print '1'	--MK(remove this statement)
					IF @NonEmployeeMatchByTaxId = 1 AND  @v_REPORTED_TAX_ID IS NULL
						BEGIN
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											 @p_DA_ROW_ID = @V_DA_ROW_ID , 
											 @p_MODULE_NAME = @V_MODULENAME,
											 @p_CALLING_ERROR_LOCATION = 'MAIN' ,	
											 @p_CURRENT_ERROR_LOCATION  = 'REPORTVD1' , 
											 @p_ERROR_PROC_NAME = @V_PROCNAME,
											 @p_ERROR_MSG = 'Match by tax_id is checked however ,REPORTED_TAX_ID is not provided. ', 
											 @p_ERROR_COLUMNS = 'REPORTED_TAX_ID', 
											 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;  										 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
												SET @iNoError = 0	--knakra latest
						END
				--	print '2'	--MK(remove)
					--MKAUR24
			
					
					IF @iNoError = 1	--knakra latest
					
					BEGIN	--knakra latest
						IF @NonEmployeeMatchByName <> 0						
							SET	@ErrorColumn = 'REPORTED_LAST_NAME,REPORTED_FIRST_NAME'
						IF @NonEmployeeMatchByTaxId <> 0
						BEGIN
							IF @ErrorColumn <> ''
								SET @ErrorColumn = @ErrorColumn + ','
							SET @ErrorColumn = @ErrorColumn + 'REPORTED_TAX_ID'
						END	
--DSHARMA70 HMI		STARTS			
				--	INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vFirstName ,vTaxId  ,vAddr1 ,vAddr2 ,vCity , vState , vZip ,vPhone1, vTableName, vCountry , vPhone2 , vFaxNumber , iNameType ) 
				--	VALUES( @v_DA_ROW_ID ,@p_jobID ,  @v_REPORTED_LAST_NAME,@v_REPORTED_FIRST_NAME,@v_REPORTED_TAX_ID,@v_REPORTED_ADDR1,@v_REPORTED_ADDR2,@v_REPORTED_CITY,@v_REPORTED_STATE_R ,@v_REPORTED_ZIP_CODE,@v_REPORTED_PHONE,'REPORTED_BY', @REPORTED_COUNTRY_R ,@v_REPORTED_PHONE2,@v_REPORTED_FAX,@NAME_TYPE_R	 )     
					INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vFirstName ,vTaxId  ,vAddr1 ,vAddr2 ,vCity , vState , vZip ,vPhone1, vTableName, vCountry , vPhone2 , vFaxNumber , iNameType,vBirthDate ) 
					VALUES( @v_DA_ROW_ID ,@p_jobID ,  @v_REPORTED_LAST_NAME,@v_REPORTED_FIRST_NAME,@v_REPORTED_TAX_ID,@v_REPORTED_ADDR1,@v_REPORTED_ADDR2,@v_REPORTED_CITY,@v_REPORTED_STATE_R ,@v_REPORTED_ZIP_CODE,@v_REPORTED_PHONE,'REPORTED_BY', @REPORTED_COUNTRY_R ,@v_REPORTED_PHONE2,@v_REPORTED_FAX,@NAME_TYPE_R, @v_REPORTED_BIRTH_DT )     
--DSHARMA70 HMI		ENDS									

						BEGIN TRY
					--		print '3'	--MK(remove)
							
							EXEC PROCESS_ENTITY @pEntType = @PERSON,
									@PJOBID = @p_jobID,
									@PDAROWID = @v_DA_ROW_ID,
									@vDBNAME = @V_DBNAME,
									@pModuleName = @V_MODULENAME,
									@iForceCrtEnt = 0,
									@iUseTaxId = 1,
									@pCallingErrorLoc = 'REPORTVD1a',
									@pErrorKeyColumnValue = @v_EVENT_NUMBER,
									@IENTITYID = @iEntId OUTPUT,
									@vErrorMsg = @V_ERROR_MESSAGE OUTPUT									
									,@BirthDateAvlbl = 1 --dsharma70 hmi
									
				--		print '4'	--MK(remove)
						END TRY
						BEGIN CATCH	
							 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
									@p_DA_ROW_ID  = @V_DA_ROW_ID , 
									@p_MODULE_NAME = @V_MODULENAME ,
									@p_CALLING_ERROR_LOCATION = 'Main', 
									@p_CURRENT_ERROR_LOCATION = 'REPORTVD2', 
									@p_ERROR_PROC_NAME = @V_PROCNAME ,
									@p_ERROR_MSG = @V_ERROR_MESSAGE ,
									@p_ERROR_COLUMNS = NULL , 
									@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
									@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
									@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
									@P_IS_VALIDATION = 0 ; 	
									SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						END CATCH
			--			print '5'	--MK(remove)
							SET @i_Reporter_ENTITY_ID_GEN = @iEntId ;				
								--SET @V_ERROR_MESSAGE = @V_ERROR_MESSAGE + ' Either select the allow creation of new entity check box on UI/ provide a valid Entity.'		 --MKAR24
						IF (@i_Reporter_ENTITY_ID_GEN = 0)
							BEGIN	
									EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
										@p_DA_ROW_ID = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME,
										@p_CALLING_ERROR_LOCATION = 'Reporter' ,	
										@p_CURRENT_ERROR_LOCATION  = 'REPORTVD3', 
										@p_ERROR_PROC_NAME = @V_PROCNAME,
										@p_ERROR_MSG =  @V_ERROR_MESSAGE , -- REQUIRED FIELD --
										@p_ERROR_COLUMNS = @ErrorColumn, 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
										@P_IS_VALIDATION = 1 ;
										SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
							END
						END	--KNAKRA LATEST
				END
END	


								--	--**********************************************************************
								--	*********************** EVENT VALIDATION ENDS *************************
								--	***********************************************************************
			   
								--	************************************************************************
								--	*********************** PERSON INVOLVED VD STARTS ********************** 	-- NINE BLOCKS
								--	************************************************************************
												


								--*************************************************************************
								--	******************* PERSON INVOLVED VD Starts *****************************
								--	*************************************************************************



								
SET @V_ERROR_LOCATION_MAIN = 'ES11'

IF ((@v_PI_LAST_NAME IS NOT NULL) AND (@v_PI_LAST_NAME <> '') )
BEGIN
							SET  @vTableName = (Case 
								 WHEN UPPER(@V_PI_TYPE_CODE) = 'P' THEN 'PATIENTS'
								 WHEN UPPER(@V_PI_TYPE_CODE) = 'E' THEN 'EMPLOYEES'
								 WHEN UPPER(@V_PI_TYPE_CODE) = 'PHYS' THEN 'PHYSICIANS'
								 WHEN UPPER(@V_PI_TYPE_CODE) = 'W' THEN 'WITNESS'
								  WHEN UPPER(@V_PI_TYPE_CODE) = 'MED' THEN 'MED_STAFF' --MKAUR24 3/21/2017 
								   WHEN UPPER(@V_PI_TYPE_CODE) = 'D' THEN 'DRIVER'  --MKAUR24 3/21/2017
								 WHEN UPPER(@V_PI_TYPE_CODE) = 'O' THEN 'OTHER_PEOPLE'

							END)			
							--mkaur24 MK
							SET @N_SQL = 'SELECT @pRoleTableId = TABLE_ID FROM ' + @V_DBNAME + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = @pTableName'
							EXECUTE SP_EXECUTESQL @N_SQL,
							N' @pRoleTableId INT OUTPUT, @pTableName VARCHAR(50)',
							@pRoleTableId = @iRoleTableId OUTPUT,
							@pTableName = @vTableName

		---nOTE ************THIS WILL BE MODIEFE AS PER PROCESS ENTITYT				
BEGIN
SET @iNoError = 1		
SET @ErrorColumn = ''														-- PIVD2. CREATE_PI_ENT_IF_TAXID_EMPTY IF EID = 0 (PROCESS ENTITY) THEN PASS ERROR 
IF @vTableName = 'EMPLOYEES'
BEGIN

			IF @EmployeeMatchByEmpNumber = 1 AND @v_EMPLOYEE_NUMBER IS NULL --WORK
							BEGIN
								EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											 @p_DA_ROW_ID = @V_DA_ROW_ID , 
											 @p_MODULE_NAME = @V_MODULENAME,
											 @p_CALLING_ERROR_LOCATION = 'MAIN' ,	
											 @p_CURRENT_ERROR_LOCATION  = 'PE1' , 
											 @p_ERROR_PROC_NAME = @V_PROCNAME,
											 @p_ERROR_MSG = 'Match by EMPLOYEE_NUMBER is checked however ,EMPLOYEE_NUMBER is not provided. ', 
											 @p_ERROR_COLUMNS = 'EMPLOYEE_NUMBER', 
											 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;  										 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
												SET @iNoError = 0												
							END		
			IF @v_PI_TAX_ID  IS NULL   --kmalick JIRA:65999
						BEGIN
									EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											 @p_DA_ROW_ID = @V_DA_ROW_ID , 
											 @p_MODULE_NAME = @V_MODULENAME,
											 @p_CALLING_ERROR_LOCATION = 'MAIN' ,	
											 @p_CURRENT_ERROR_LOCATION  = 'PE2' , 
											 @p_ERROR_PROC_NAME = @V_PROCNAME,
											 @p_ERROR_MSG = 'PI_TAX_ID is mandatory for Employee. ', 
											 @p_ERROR_COLUMNS = 'PI_TAX_ID', 
											 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;  										 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
												SET @iNoError = 0
												
						END

						IF @EmployeeMatchByName <> 0 
							SET @ErrorColumn = 'PI_LAST_NAME,PI_FIRST_NAME'
						IF @EmployeeMatchByEmpNumber <> 0
						BEGIN
							IF @ErrorColumn <> ''
								SET @ErrorColumn = @ErrorColumn + ','
							SET @ErrorColumn = @ErrorColumn + 'EMPLOYEE_NUMBER'
						END
						IF @EmployeeMatchByTaxId <> 0							
						BEGIN
							IF @ErrorColumn <> ''
								SET @ErrorColumn = @ErrorColumn + ','
							SET @ErrorColumn = @ErrorColumn + 'PI_TAX_ID'
						END
						
END	
ELSE
BEGIN

		IF @NonEmployeeMatchByTaxId = 1 AND  @v_PI_TAX_ID IS NULL AND @CrtNwEvntPiEntyIfTxIDEmpty = 0
						BEGIN
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											 @p_DA_ROW_ID = @V_DA_ROW_ID , 
											 @p_MODULE_NAME = @V_MODULENAME,
											 @p_CALLING_ERROR_LOCATION = 'MAIN' ,	
											 @p_CURRENT_ERROR_LOCATION  = 'PE3' , 
											 @p_ERROR_PROC_NAME = @V_PROCNAME,
											 @p_ERROR_MSG = 'Match by tax_id is checked however ,PI_TAX_ID is not provided. ', 
											 @p_ERROR_COLUMNS = 'PI_TAX_ID', 
											 @p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;  										 
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
												SET @iNoError = 0
												
												
						END
						
						IF @NonEmployeeMatchByName <> 0						
							SET	@ErrorColumn = 'PI_LAST_NAME,PI_FIRST_NAME'
						IF @NonEmployeeMatchByTaxId <> 0
						BEGIN
							IF @ErrorColumn <> ''
								SET @ErrorColumn = @ErrorColumn + ','
							SET @ErrorColumn = @ErrorColumn + 'PI_TAX_ID'
						END							
						
END



IF @iNoError = 1 AND @iPiTidErr = 0	--knakra latest(taxid error check)
		BEGIN

		IF (@CrtNwEvntPiEntyIfTxIDEmpty = 1 )	--MKAUR24 
	BEGIN
		IF @v_PI_TAX_ID IS NULL AND (@EmployeeMatchByTaxId =1 OR @NonEmployeeMatchByTaxId =1)
			SET @Forcecreate = 1 ;--			
		ELSE 
			SET @Forcecreate = 0 ;--	
	END
			SET @iEntId = 0
			INSERT INTO @PERSON ( iJobId, iDaRowId, vLastName ,vFirstName ,vMiddleName  ,vTaxId  ,vAddr1 ,vAddr2 ,vCity , vState , vZip ,vBirthDate ,vPhone1 ,vSexCode  , vCounty , vTableName , iNameType , vEmpNum) 
			VALUES(@p_jobID ,@v_DA_ROW_ID, @v_PI_LAST_NAME,@v_PI_FIRST_NAME,@v_PI_MIDDLE_NAME,@v_PI_TAX_ID,@v_PI_ADDR1,@v_PI_ADDR2,@v_PI_CITY, @v_PI_STATE_R ,@v_PI_ZIP_CODE,@v_BIRTH_DATE,@v_PI_PHONE,@SEX_CODE_R,@v_COUNTY_OF_RESIDNC,@vTableName, @NAME_TYPE_R , @v_EMPLOYEE_NUMBER)     
			BEGIN TRY									 					
			--EXEC PROCESS_ENTITY @PERSON, @p_jobID, @v_DA_ROW_ID, @p_DBName, @Forcecreate ,0, @iEntId OUTPUT -- CREATE NEW ENTITY EVEN IF EXISTS	
						EXEC PROCESS_ENTITY @pEntType = @PERSON,
									@PJOBID = @p_jobID,
									@PDAROWID = @v_DA_ROW_ID,
									@vDBNAME = @V_DBNAME,
									@pModuleName = @V_MODULENAME,
									@iForceCrtEnt = @Forcecreate,
									@iUseTaxId = 1,
									@pCallingErrorLoc = 'PE',
									@pErrorKeyColumnValue = @v_EVENT_NUMBER,
									@IENTITYID = @iEntId OUTPUT,
									@vErrorMsg = @V_ERROR_MESSAGE OUTPUT
									,@BirthDateAvlbl = 1 --dsharma70 hmi
			
			END TRY		
			BEGIN CATCH	
							 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
									@p_DA_ROW_ID  = @V_DA_ROW_ID , 
									@p_MODULE_NAME = @V_MODULENAME ,
									@p_CALLING_ERROR_LOCATION = 'Main', 
									@p_CURRENT_ERROR_LOCATION = 'PRCSENT1', 
									@p_ERROR_PROC_NAME = @V_PROCNAME ,
									@p_ERROR_MSG = @V_ERROR_MESSAGE ,
									@p_ERROR_COLUMNS = NULL , 
									@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
									@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
									@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
									@P_IS_VALIDATION = 0 ; 	
									SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
			END CATCH			
				SET @i_PI_TYPE_ENTITY_ID_GEN = @iEntId ;

				IF (@i_PI_TYPE_ENTITY_ID_GEN = 0)
						BEGIN
						EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
							@p_DA_ROW_ID = @V_DA_ROW_ID , 
							@p_MODULE_NAME = @V_MODULENAME,
							@p_CALLING_ERROR_LOCATION = 'PIVD' ,	
							@p_CURRENT_ERROR_LOCATION  = 'PI_Ent', 
							@p_ERROR_PROC_NAME = @V_PROCNAME,
							@p_ERROR_MSG = @V_ERROR_MESSAGE , 
							@p_ERROR_COLUMNS = @ErrorColumn, 
							@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
							@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
							@P_IS_VALIDATION = 1 ;
							SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
						END
		END
END

--mkaur24 start 03/28/2016 (Role to component functionality) RMA-22665
If (@i_PI_TYPE_ENTITY_ID_GEN > 0 )
BEGIN
	 SET @iROW_ID = 0 ;
	 SET @N_SQL = 'select @ROW_ID_P = ROW_ID from ' + @V_DBNAME + 'CODE_X_CODE where REL_TYPE_CODE IN ' 
 SET @N_SQL = @N_SQL + '(select CODE_ID from ' + @V_DBNAME +  'codes where  SHORT_CODE = ' + '''RCCRT''' + ' AND  table_id IN (select TABLE_ID from ' + @V_DBNAME +  'glossary where system_table_name = ' + ' ''CODE_REL_TYPE''  ))  '									
 SET @N_SQL = @N_SQL + 'AND CODE1 IN ( select TABLE_ID  from ' + @V_DBNAME +  'glossary where system_table_name = ' + '''EVENT'' )' 	  
 SET @N_SQL = @N_SQL +  'AND CODE2 IN (SELECT TABLE_ID FROM ' + @V_DBNAME +  'glossary where system_table_name = @system_table_name_P)  AND DELETED_FLAG = 0 '	
	
	
			EXECUTE SP_EXECUTESQL @N_SQL ,
			N' @ROW_ID_P INT OUTPUT ,
			@system_table_name_P VARCHAR(50)' ,
			@ROW_ID_P = @iROW_ID OUTPUT ,
			@system_table_name_P = @vTableName 

IF (@iROW_ID = 0 )
BEGIN
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = 'RTCOMP', 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = 'The Role to component mapping is missing for the given PI_TYPE_CODE . ' ,
											@p_ERROR_COLUMNS = 'PI_TYPE_CODE' , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	

END


END

--mkaur24 end 03/28/2016

IF (UPPER(@v_PI_TYPE_CODE) = 'E' OR UPPER(@v_PI_TYPE_CODE) = 'P' )			    -- PIVD8. HOSPITAL AND PHYS_EID VALIDATION
BEGIN
BEGIN																-- PIVD8. HOSPITAL ERROR LOGGING
							--PRINT 'HOSPITAL EID PROCESS ENTITY AND ERROR LOGGING START'	--MK(remove)
							SET @iCount = 1 ;	
			WHILE ( @iCount < 4)
				BEGIN
									SET @iEntId = 0 ;
									 SET @vColName1 = 'HOSPITAL_' + CAST (@iCount AS VARCHAR ) + '_NAME'
									 SET @vColName2 = 'HOSPITAL_' +  CAST (@iCount AS VARCHAR ) + '_PHONE'
									 SET @vColName3 =  @vColName1 + ' , '  + @vColName2  
									 If @vColName1 = 'HOSPITAL_1_NAME'
									  BEGIN 
										SET @vVal = @V_HOSPITAL_1_NAME
										SET @vVal2 = @V_HOSPITAL_1_PHONE										 					
									  END				 
								ELSE	 If @vColName1 = 'HOSPITAL_2_NAME'
									  BEGIN
										SET @vVal = @V_HOSPITAL_2_NAME
										SET @vVal2 = @V_HOSPITAL_2_PHONE										 
									  END
							ELSE		 If @vColName1 = 'HOSPITAL_3_NAME'
									  BEGIN
										SET @vVal = @V_HOSPITAL_3_NAME
										SET @vVal2 = @V_HOSPITAL_3_PHONE	
									  END
									  		
						IF (( @vVal IS NOT NULL) AND ( @vVal2 IS NOT NULL )) --cww
							BEGIN	
								SET @iEntId = 0
								INSERT INTO @PERSON (iJobId, iDaRowId,vLastName , vPhone1 , vTableName , iNameType) VALUES(@p_jobID ,@v_DA_ROW_ID,@vVal , @vVal2 ,  'HOSPITAL',@NAME_TYPE_R)  
								BEGIN TRY   										 					
								--EXEC PROCESS_ENTITY @PERSON, @p_jobID, @v_DA_ROW_ID, @p_DBName, 0,0, @iEntId OUTPUT					
										EXEC PROCESS_ENTITY @pEntType = @PERSON,
											@PJOBID = @p_jobID,
											@PDAROWID = @v_DA_ROW_ID,
											@vDBNAME = @V_DBNAME,
											@pModuleName = @V_MODULENAME,
											@iForceCrtEnt = 0,
											@iUseTaxId = 0,
											@pCallingErrorLoc = 'p',
											@pErrorKeyColumnValue = @v_EVENT_NUMBER,
											@IENTITYID = @iEntId OUTPUT,
											@vErrorMsg = @V_ERROR_MESSAGE OUTPUT
											,@BirthDateAvlbl = 0 --dsharma70 hmi
								END TRY
								BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'HOSP1', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						END CATCH
								
								IF @vColName1 = 'HOSPITAL_1_NAME'  SET @i_HOSPITAL_1_EID = @iEntId
						ELSE		IF @vColName1 = 'HOSPITAL_2_NAME'  SET @i_HOSPITAL_2_EID = @iEntId	
						ELSE		IF @vColName1 = 'HOSPITAL_3_NAME'  SET @i_HOSPITAL_3_EID = @iEntId			
												
								IF (@iEntId = 0)
									BEGIN				
									EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
											@p_CURRENT_ERROR_LOCATION = 'hosp_VD', -- IT IS THE LOCATION OF CODE PROC 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											@p_ERROR_COLUMNS = @vColName3 , -- Columns in which error is coming
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  -- Main Column like Claim Number/ event number
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
											@P_IS_VALIDATION = 1 ;
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;								
									END
							END
						ELSE IF  ((@vVal IS NULL AND @vVal2 IS NOT NULL  ) OR (@vVal2 IS NULL AND @vVal IS NOT NULL) )
						 BEGIN
							--PRINT ' NULL ERROR START'	--MK(remove)
								EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'hosp_VD', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = ' EITHER PROVIDE VALUE IN BOTH (NAME / PHONE) OR DO NOT PROVIDE IN ANY OF THE COLUMN.' ,
										@p_ERROR_COLUMNS = @vColName3 , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
										@P_IS_VALIDATION = 1 ;
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
						    --PRINT ' PRINT  NULL ERROR END LOGGED'	--MK(remove)
						 END				
							     SET @iCount = @iCount + 1;
				END
								-- PRINT 'HOSPITAL EID PROCESS ENTITY AND ERROR LOGGING END '	--MK(remove)
END

BEGIN																-- PIVD9. PHYS_EID PROCESS ENTITY AND ERROR LOGGING 
			SET @iCount = 1 ;	
			WHILE ( @iCount < 4)
				BEGIN

									 SET @iEntId = 0 
									 SET @vColName1 = 'PHYSICIAN_' + CAST (@iCount AS VARCHAR ) + '_LAST_NAME'
									 SET @vColName2 = 'PHYSICIAN_' +  CAST (@iCount AS VARCHAR ) + '_PHONE'
									 SET @vColName4 = 'PHYSICIAN_' + CAST (@iCount AS VARCHAR ) + '_FIRST_NAME'
									 SET @vColName3 =  @vColName1 + ' , '  + @vColName2 + ' , ' + @vColName4
									
									 If @vColName1 = 'PHYSICIAN_1_LAST_NAME'
									  BEGIN 
										SET @vVal = @V_PHYSICIAN_1_LAST_NAME
										SET @vVal2 = @V_PHYSICIAN_1_PHONE
										SET @vVal3 = @V_PHYSICIAN_1_FIRST_NAME										 					
									  END				 
							ELSE		 If @vColName1 = 'PHYSICIAN_2_LAST_NAME'
									  BEGIN
										SET @vVal = @V_PHYSICIAN_2_LAST_NAME
										SET @vVal2 = @V_PHYSICIAN_2_PHONE
										SET @vVal3 = @V_PHYSICIAN_2_FIRST_NAME										 
									  END
								ELSE	 If @vColName1 = 'PHYSICIAN_3_LAST_NAME'
									  BEGIN
										SET @vVal = @V_PHYSICIAN_3_LAST_NAME
										SET @vVal2 = @V_PHYSICIAN_3_PHONE
										SET @vVal3 = @V_PHYSICIAN_3_FIRST_NAME	
									  END
									  		
						IF (( @vVal IS NOT NULL) AND ( @vVal2 IS NOT NULL ) AND (@vVal3 IS NOT NULL)) --cww
							BEGIN	
								INSERT INTO @PERSON (iJobId, iDaRowId,vLastName , vPhone1 , vFirstName , vTableName ,iNameType) VALUES(@p_jobID ,@v_DA_ROW_ID,@vVal , @vVal2 , @vVal3 ,  'PHYSICIANS' , @NAME_TYPE_R )     										 					
								BEGIN TRY
							--	EXEC PROCESS_ENTITY @PERSON, @p_jobID, @v_DA_ROW_ID, @p_DBName, 0,0, @iEntId OUTPUT					
									EXEC PROCESS_ENTITY @pEntType = @PERSON,
											@PJOBID = @p_jobID,
											@PDAROWID = @v_DA_ROW_ID,
											@vDBNAME = @V_DBNAME,
											@pModuleName = @V_MODULENAME,
											@iForceCrtEnt = 0,
											@iUseTaxId = 0,
											@pCallingErrorLoc = 'physp',
											@pErrorKeyColumnValue = @v_EVENT_NUMBER,
											@IENTITYID = @iEntId OUTPUT,
											@vErrorMsg = @V_ERROR_MESSAGE OUTPUT
											,@BirthDateAvlbl = 0 --dsharma70 hmi
								END TRY
								BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'PHYS1', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						END CATCH
								IF @vColName1 = 'PHYSICIAN_1_LAST_NAME'  SET @i_PHYSICIAN_1_EID = @iEntId
							ELSE	IF @vColName1 = 'PHYSICIAN_2_LAST_NAME'  SET @i_PHYSICIAN_2_EID = @iEntId	
							ELSE	IF @vColName1 = 'PHYSICIAN_3_LAST_NAME'  SET @i_PHYSICIAN_3_EID = @iEntId			
								IF @i_PHYSICIAN_1_EID > 0 SET @i_PRI_PHYSICIAN_EID_GEN = @i_PHYSICIAN_1_EID 
								IF @i_PHYSICIAN_2_EID > 0 SET @i_ADM_PHYSICIAN_EID_GEN = @i_PHYSICIAN_2_EID
								 				
								IF (@iEntId = 0)
									BEGIN				
									EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
											@p_CURRENT_ERROR_LOCATION = 'PHYS2', -- IT IS THE LOCATION OF CODE PROC 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											@p_ERROR_COLUMNS = @vColName3 , -- Columns in which error is coming
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  -- Main Column like Claim Number/ event number
											 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
										@P_IS_VALIDATION = 1 ;
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
									END
							END
						ELSE IF   (@vVal is null and @vVal2 is null and @vVal3 is null)
								BEGIN
										SET @i_NOTHING = 1 
								END
						ELSE
								BEGIN
								EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'PHYS3', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = ' EITHER PROVIDE VALUE IN all (Last_NAME / First_Name PHONE ) OR DO NOT PROVIDE IN ANY OF THE COLUMN.' ,
										@p_ERROR_COLUMNS = @vColName3 , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										 @P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
										@P_IS_VALIDATION = 1 ;
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
									--PRINT ' PRINT  NULL ERROR END LOGGED'		--MK(remove)						
								END				
											
					
								 SET @iCount = @iCount + 1;
				END							 

END	
END
IF ((UPPER(@v_PI_TYPE_CODE) = 'E') AND (@i_PI_TYPE_ENTITY_ID_GEN <> 0) )  --mkaur24
BEGIN

														 --					  IMPORT DATA MANUPULATION STARTS 
BEGIN													 -- EmpIn1.    IF FLAG NULL GET VALUE FROM SYS_PARMS
SET @vColList = '@v_WORK_SUN_FLAG|@v_WORK_MON_FLAG|@v_WORK_TUE_FLAG|@v_WORK_WED_FLAG|@v_WORK_THU_FLAG|@v_WORK_FRI_FLAG|@v_WORK_SAT_FLAG|'
declare @vValue as varchar (100)
WHILE CHARINDEX('|',@vColList,1) > 0				--
BEGIN	
	SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
	SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))		
	--PRINT 'COLNAME IS : ' + @vColName
	SET @vValue = ( CASE
	---- --WORKING
	WHEN @vColName = '@v_WORK_SUN_FLAG' THEN  @v_WORK_SUN_FLAG
	WHEN @vColName = '@v_WORK_MON_FLAG' THEN  @v_WORK_MON_FLAG
	WHEN @vColName = '@v_WORK_TUE_FLAG' THEN  @v_WORK_TUE_FLAG	
	WHEN @vColName = '@v_WORK_WED_FLAG' THEN  @v_WORK_WED_FLAG	
	WHEN @vColName = '@v_WORK_THU_FLAG' THEN  @v_WORK_THU_FLAG	
	WHEN @vColName = '@v_WORK_FRI_FLAG' THEN  @v_WORK_FRI_FLAG	
	WHEN @vColName = '@v_WORK_SAT_FLAG' THEN  @v_WORK_SAT_FLAG			
	END)
		
IF 	@vValue IS NULL  OR @vValue = ''
	BEGIN		
		SET @vColName = substring(@vColName,4, 8)		
		--PRINT 	'@vColName AFTR BRK : '  + @vColName
		SET @N_SQL = 'SELECT @vColName_value_P = ' +  @vColName + ' FROM ' + @V_DBName + ' SYS_PARMS '	
			BEGIN TRY
			EXEC sp_Executesql @N_sql,
			N' @vColName_value_P INT OUTPUT',
			@vColName_value_P = @vColName_value OUTPUT	
			END TRY
			BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'FLAGVALUE', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						END CATCH			
			IF @vColName = '@v_WORK_SUN' SET @v_WORK_SUN_FLAG_GEN = @vColName_value ; --MKAUR24 CHANGE
	ELSE		IF @vColName = '@v_WORK_MON' SET @v_WORK_MON_FLAG_GEN = @vColName_value ;
	ELSE		IF @vColName = '@v_WORK_TUE' SET @v_WORK_TUE_FLAG_GEN = @vColName_value ;
	ELSE		IF @vColName = '@v_WORK_WED' SET @v_WORK_WED_FLAG_GEN = @vColName_value ;
	ELSE		IF @vColName = '@v_WORK_THU' SET @v_WORK_THU_FLAG_GEN = @vColName_value ;
	ELSE		IF @vColName = '@v_WORK_FRI' SET @v_WORK_FRI_FLAG_GEN = @vColName_value ;	
	ELSE		IF @vColName = '@v_WORK_SAT' SET @v_WORK_SAT_FLAG_GEN = @vColName_value ;	
	END
END
END

BEGIN													 -- EmpIn2.    IF FLAG Y/N SET  VALUES 
IF UPPER(@v_WORK_SUN_FLAG ) = 'Y' SET @v_WORK_SUN_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_SUN_FLAG ) = 'N' SET @v_WORK_SUN_FLAG_GEN  = 0
IF UPPER(@v_WORK_MON_FLAG ) = 'Y' SET @v_WORK_MON_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_MON_FLAG ) = 'N'   SET @v_WORK_MON_FLAG_GEN  = 0
IF UPPER(@v_WORK_TUE_FLAG ) = 'Y' SET @v_WORK_TUE_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_TUE_FLAG ) = 'N'  SET @v_WORK_TUE_FLAG_GEN  = 0
IF UPPER(@v_WORK_WED_FLAG ) = 'Y' SET @v_WORK_WED_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_WED_FLAG ) = 'N' SET @v_WORK_WED_FLAG_GEN  = 0
IF UPPER(@v_WORK_THU_FLAG ) = 'Y' SET @v_WORK_THU_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_THU_FLAG ) = 'N' SET @v_WORK_THU_FLAG_GEN  = 0
IF UPPER(@v_WORK_FRI_FLAG ) = 'Y' SET @v_WORK_FRI_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_FRI_FLAG ) = 'N' SET @v_WORK_FRI_FLAG_GEN  = 0
IF UPPER(@v_WORK_SAT_FLAG ) = 'Y' SET @v_WORK_SAT_FLAG_GEN = -1 ELSE IF UPPER(@v_WORK_SAT_FLAG ) = 'N' SET @v_WORK_SAT_FLAG_GEN  = 0

--*******************
IF UPPER(@v_FULL_TIME_FLAG ) = 'Y' SET @v_FULL_TIME_FLAG_GEN = -1 ELSE IF UPPER(@v_FULL_TIME_FLAG ) = 'N' SET @v_FULL_TIME_FLAG_GEN  = 0
IF UPPER(@v_ACTIVE_FLAG ) = 'Y' SET @v_ACTIVE_FLAG_GEN = -1 ELSE IF UPPER(@v_ACTIVE_FLAG ) = 'N' SET @v_ACTIVE_FLAG_GEN  = 0
IF UPPER(@v_EXEMPT_STATUS_FLAG ) = 'Y' SET @v_EXEMPT_STATUS_FLAG_GEN = -1 ELSE IF UPPER(@v_EXEMPT_STATUS_FLAG ) = 'N' SET @v_EXEMPT_STATUS_FLAG_GEN  = 0
IF UPPER(@v_INSURABLE_FLAG ) = 'Y' SET @v_INSURABLE_FLAG_GEN = -1 ELSE IF UPPER(@v_INSURABLE_FLAG ) = 'N' SET @v_INSURABLE_FLAG_GEN  = 0
IF UPPER(@v_REGULAR_JOB_FLAG ) = 'Y' SET @v_REGULAR_JOB_FLAG_GEN = -1 ELSE IF UPPER(@v_REGULAR_JOB_FLAG ) = 'N' SET @v_REGULAR_JOB_FLAG_GEN  = 0
IF UPPER(@v_LOST_WORK_FLAG ) = 'Y' SET @v_LOST_WORK_FLAG_GEN = -1 ELSE IF UPPER(@v_LOST_WORK_FLAG ) = 'N' SET @v_LOST_WORK_FLAG_GEN  = 0
IF UPPER(@v_HIRED_IN_STATE_FLAG ) = 'Y' SET @v_HIRED_IN_STATE_FLAG_GEN  = -1 ELSE IF UPPER(@v_HIRED_IN_STATE_FLAG ) = 'N' SET @v_HIRED_IN_STATE_FLAG_GEN  = 0
--KK




END

IF UPPER(@v_LOST_WORK_FLAG ) = 'Y' SET @v_LOST_WORK_FLAG_GEN = -1 ELSE IF UPPER(@v_LOST_WORK_FLAG ) = 'N' SET @v_LOST_WORK_FLAG_GEN  = 0



						
IF (@v_LOST_WORK_FLAG_GEN <> 0)									-- PIVD5. WORK LOSS             
BEGIN
		--PRINT 'FLAG VD ENTERED'	--MK(remove)
					SET @I_UPDATE_FLAG = 0 ;							
						SET @vColName1   = '@v_DATE_LAST_WORKED'
					  	SET @vColName2 = '@v_DATE_RETURNED'
					 
							SET @iCount = 1
		WHILE @iCount <= 15
		BEGIN
							SET @vColToProcess = @vColName1 + '_' + CAST(@iCount as VARCHAR)							
							
							SET @vVal = (CASE
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_1' THEN @v_DATE_LAST_WORKED_1
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_2' THEN @v_DATE_LAST_WORKED_2					
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_3' THEN @v_DATE_LAST_WORKED_3
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_4' THEN @v_DATE_LAST_WORKED_4
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_5' THEN @v_DATE_LAST_WORKED_5	
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_6' THEN @v_DATE_LAST_WORKED_6
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_7' THEN @v_DATE_LAST_WORKED_7					
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_8' THEN @v_DATE_LAST_WORKED_8
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_9' THEN @v_DATE_LAST_WORKED_9
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_10' THEN @v_DATE_LAST_WORKED_10	
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_11' THEN @v_DATE_LAST_WORKED_11
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_12' THEN @v_DATE_LAST_WORKED_12					
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_13' THEN @v_DATE_LAST_WORKED_13
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_14' THEN @v_DATE_LAST_WORKED_14
								WHEN @vColToProcess = '@v_DATE_LAST_WORKED_15' THEN @v_DATE_LAST_WORKED_15															
								END)				
							
							SET @vColToProcess1 = @vColName2 + '_' + CAST(@iCount as VARCHAR) 					 
							SET @vColName3 =  @vColToProcess + ' , '  + @vColToProcess1  	--MKAUR24
								SET @vVal2 = (CASE
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_1'  THEN @v_DATE_RETURNED_1
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_2'  THEN @v_DATE_RETURNED_2				
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_3'  THEN @v_DATE_RETURNED_3
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_4'  THEN @v_DATE_RETURNED_4
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_5'  THEN @v_DATE_RETURNED_5	
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_6'  THEN @v_DATE_RETURNED_6
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_7'  THEN @v_DATE_RETURNED_7				
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_8'  THEN @v_DATE_RETURNED_8
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_9'  THEN @v_DATE_RETURNED_9
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_10' THEN @v_DATE_RETURNED_10
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_11' THEN @v_DATE_RETURNED_11
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_12' THEN @v_DATE_RETURNED_12				
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_13' THEN @v_DATE_RETURNED_13
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_14' THEN @v_DATE_RETURNED_14
								WHEN @vColToProcess1 = '@v_DATE_RETURNED_15' THEN @v_DATE_RETURNED_15													
								END)
															 
							 SET @iCount2 = @iCount + 1 							 
							 SET @vColToProcess2 = @vColName1 + '_' + CAST(@iCount2 as VARCHAR) 	
							
							    SET @vVal3 = (CASE
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_1' THEN @v_DATE_LAST_WORKED_1
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_2' THEN @v_DATE_LAST_WORKED_2					
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_3' THEN @v_DATE_LAST_WORKED_3
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_4' THEN @v_DATE_LAST_WORKED_4
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_5' THEN @v_DATE_LAST_WORKED_5	
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_6' THEN @v_DATE_LAST_WORKED_6
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_7' THEN @v_DATE_LAST_WORKED_7					
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_8' THEN @v_DATE_LAST_WORKED_8
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_9' THEN @v_DATE_LAST_WORKED_9
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_10' THEN @v_DATE_LAST_WORKED_10	
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_11' THEN @v_DATE_LAST_WORKED_11
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_12' THEN @v_DATE_LAST_WORKED_12					
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_13' THEN @v_DATE_LAST_WORKED_13
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_14' THEN @v_DATE_LAST_WORKED_14
								WHEN @vColToProcess2 = '@v_DATE_LAST_WORKED_15' THEN @v_DATE_LAST_WORKED_15															
								END)
								
							 SET @iCount2 = @iCount + 1 
							 SET @vColToProcess2 = @vColName2 + '_' + CAST(@iCount2 as VARCHAR) 
							 	
								SET @vVal4 = (CASE
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_1'  THEN @v_DATE_RETURNED_1
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_2'  THEN @v_DATE_RETURNED_2				
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_3'  THEN @v_DATE_RETURNED_3
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_4'  THEN @v_DATE_RETURNED_4
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_5'  THEN @v_DATE_RETURNED_5	
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_6'  THEN @v_DATE_RETURNED_6
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_7'  THEN @v_DATE_RETURNED_7				
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_8'  THEN @v_DATE_RETURNED_8
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_9'  THEN @v_DATE_RETURNED_9
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_10' THEN @v_DATE_RETURNED_10
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_11' THEN @v_DATE_RETURNED_11
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_12' THEN @v_DATE_RETURNED_12				
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_13' THEN @v_DATE_RETURNED_13
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_14' THEN @v_DATE_RETURNED_14
								WHEN @vColToProcess2 = '@v_DATE_RETURNED_15' THEN @v_DATE_RETURNED_15													
								END)
														 		
							--PRINT '@vVal' + @vVal;	--MK(remove these print statements)
							--PRINT '@vVal2' + @vVal;
							--PRINT '@vVal3' + @vVal;
							-- SET @vColName3 =  @vColToProcess + ' / '  + @vColToProcess   + '/' + @vColToProcess2 DOUBT
			
							IF (@vVal  IS NOT NULL AND @vVal2 IS NULL   ) OR  ( @vVal2 IS NOT  NULL AND @vVal IS NULL ) 			
										BEGIN
										--PRINT ' NULL ERROR START'
										EXECUTE DDS_ERROR_LOG_CAPTURE @p_JOBID  = @P_JOBID ,								
												@p_DA_ROW_ID = @V_DA_ROW_ID ,
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'EVENT_LOC', -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
												@p_CURRENT_ERROR_LOCATION = 'WORKLOSS1', -- IT IS THE LOCATION OF CODE PROC 
												@p_ERROR_PROC_NAME = 'DA_DDS_EVENT_IMPORT',
												@p_ERROR_MSG = ' EITHER PROVIDE VALUE IN BOTH (DATE_LAST_WORKED / DATE_RETURNED) OR DO NOT PROVIDE IN ANY OF THE COLUMN',
												@p_ERROR_COLUMNS = @vColName3,  -- Columns in which error is coming
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' , -- Main Column like Claim Number/ event number
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
												@P_IS_VALIDATION = 1 ;
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
										--PRINT ' PRINT  NULL ERROR END LOGGED'								
										END
							ELSE
										BEGIN
											IF ( (@vVal > @vVal2)  )  
										--DATE_LAST_WORKED SHOULD BE LESS THAN DATE_RETURNED
												BEGIN
														EXECUTE DDS_ERROR_LOG_CAPTURE @p_JOBID  = @P_JOBID ,								
																@p_DA_ROW_ID = @V_DA_ROW_ID ,
																@p_MODULE_NAME = @V_MODULENAME ,
																@p_CALLING_ERROR_LOCATION = 'EVENT_LOC', -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
																@p_CURRENT_ERROR_LOCATION = 'WORKLOSS2', -- IT IS THE LOCATION OF CODE PROC 
																@p_ERROR_PROC_NAME = 'DA_DDS_EVENT_IMPORT',
																@p_ERROR_MSG = ' Date_Last_worked shouldnt be eariler than the previous Date_return',
																@p_ERROR_COLUMNS = @vColName3,  -- Columns in which error is coming
																@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
																@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' , -- Main Column like Claim Number/ event number
																@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
																@P_IS_VALIDATION = 1 ;
																SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
												END	
											ELSE
												SET @i_CheckNext = 1;											
									
										 END	
										 
				IF 	@i_CheckNext = 1
					BEGIN		
						
						EXECUTE DDS_DURATION @P_JOBID, @V_DA_ROW_ID , @V_DBNAME, @V_MODULENAME, 'EVENT_NUMBER' ,@v_EVENT_NUMBER ,@vVal, @vVal2 ,
						@v_WORK_MON_FLAG_GEN ,@v_WORK_TUE_FLAG_GEN , @v_WORK_WED_FLAG_GEN , @v_WORK_THU_FLAG_GEN , @v_WORK_FRI_FLAG_GEN , @v_WORK_SAT_FLAG_GEN , @v_WORK_SUN_FLAG_GEN , @I_DEPT_ASSIGNED_GEN , @V_DURATION OUTPUT -- COME3							
						
						
						IF @V_DURATION < 0  
						 SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
				     
				    END			 		
													
							 IF (@vVal3 IS NOT NULL AND  @vVal4 IS NOT NULL ) AND @i_CheckNext =1 
								BEGIN							
								IF (@vVal3 <  @vVal2)
									BEGIN
										EXECUTE DDS_ERROR_LOG_CAPTURE @p_JOBID  = @P_JOBID ,								
												@p_DA_ROW_ID = @V_DA_ROW_ID ,
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'EVENT_LOC', -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
												@p_CURRENT_ERROR_LOCATION = 'WORKLOSS3', -- IT IS THE LOCATION OF CODE PROC 
												@p_ERROR_PROC_NAME = 'DA_DDS_EVENT_IMPORT',
												@p_ERROR_MSG = ' EITHER PROVIDE VALUE IN BOTH (DATE_LAST_WORKED / DATE_RETURNED) OR DO NOT PROVIDE IN ANY OF THE COLUMN',
												@p_ERROR_COLUMNS = @vColName3,  -- Columns in which error is coming
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' , -- Main Column like Claim Number/ event number
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
												@P_IS_VALIDATION = 1 ;
												
												SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
									--	PRINT ' PRINT  NULL ERROR END LOGGED'			
									
									END
								
								END
									SET @iCount = @iCount + 1
									SET @i_CheckNext = 0 ; --MKAUR24
		

					END					     
			
END	

SET @iSuperVisorError = 0	--knakra latest
IF (@v_SUPER_TAX_ID IS NOT NULL AND @v_SUPER_LAST_NAME IS NOT NULL AND @v_SUPER_FIRST_NAME IS NOT NULL ) AND @iSvTidErr = 0	--knakra latest(taxid error check)
BEGIN
			SET @iEntId = 0
			IF @v_SUPER_EMP_NO IS NULL BEGIN SET @v_SUPER_EMP_NO = @v_SUPER_TAX_ID	END
			INSERT INTO @PERSON (iJobId , iDaRowId ,  vTaxId ,vEmpNuM, vLastName ,vFirstName ,  vAddr1 ,vAddr2 ,vCity , vState , vZip ,vPhone1 , vTableName,iNameType) 
					VALUES(@p_jobID, @v_DA_ROW_ID, @v_SUPER_TAX_ID ,@v_SUPER_EMP_NO	,@v_SUPER_LAST_NAME	,@v_SUPER_FIRST_NAME,@v_SUPER_ADDR1	,@v_SUPER_ADDR2	,@v_SUPER_CITY,@v_SUPER_STATE_R,@v_SUPER_ZIP_CODE	,@v_SUPER_PHONE1,@vTableName,@NAME_TYPE_R)     										 					
			BEGIN TRY							
						EXEC PROCESS_ENTITY @pEntType = @PERSON,
									@PJOBID = @p_jobID,
									@PDAROWID = @v_DA_ROW_ID,
									@vDBNAME = @V_DBNAME,
									@pModuleName = @V_MODULENAME,
									@iForceCrtEnt = 0,
									@iUseTaxId = 1,
									@pCallingErrorLoc = 'sp',
									@pErrorKeyColumnValue = @v_EVENT_NUMBER,
									@IENTITYID = @iEntId OUTPUT,
									@vErrorMsg = @V_ERROR_MESSAGE OUTPUT
									,@BirthDateAvlbl = 0 --dsharma70 hmi
			END TRY
			BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'PRCSENT4', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
										SET @iSuperVisorError = 1	--knakra latest		 
						END CATCH	
						
				SET @i_SUPERVISOR_ENTITY_ID_GEN = @iEntId ;				
				IF (@i_SUPERVISOR_ENTITY_ID_GEN = 0 ) --THEN ERROR LOG
				BEGIN						
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
						@p_DA_ROW_ID = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME,
						@p_CALLING_ERROR_LOCATION = 'ENTITYSUPER' ,	
						@p_CURRENT_ERROR_LOCATION  = @V_CLOCATION, 
						@p_ERROR_PROC_NAME = @V_PROCNAME,
						@p_ERROR_MSG =  @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = '@v_SUPER_LAST_NAME' , 
						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;
						SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
						SET @iSuperVisorError = 1 --knakra latest
				
				END		
				
END --3.D. PROCESS ENTITY CALLING AND ERROR LOGGING FOR SUPERVISOR

IF (@i_SUPERVISOR_ENTITY_ID_GEN > 0) AND (upper(@v_PI_TYPE_CODE) = 'E') -- CHECK EXISTENCE AND LOG ERROR IF EMPLOYEE NO. ATTACHED TO SOME OTHER ENTITY.
	BEGIN
							SET @i_EMPLOYEE_EID = 0 ;
							SET @N_SQL = 'SELECT @V_EMPLOYEE_EID_PO = EMPLOYEE_EID FROM '+ @V_DBName + ' EMPLOYEE' ;
							SET @N_SQL = @N_SQL + ' WHERE EMPLOYEE_EID  = @EMPLOYEE_EID_P ' ;
							BEGIN TRY
							Exec sp_Executesql @N_SQL,
								 N'@EMPLOYEE_EID_P INT  ,
								 @V_EMPLOYEE_EID_PO INT OUTPUT ',								 
								 @V_EMPLOYEE_EID_PO = @i_EMPLOYEE_EID OUTPUT, --MK
								 @EMPLOYEE_EID_P = @i_SUPERVISOR_ENTITY_ID_GEN ;								
								
							END TRY
							BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'SUPREXIST', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL, 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' ,  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
										SET @iSuperVisorError = 1	--knakra latest				
							END CATCH
							IF @i_EMPLOYEE_EID = 0 --WOK
							   BEGIN
									SET @i_EMPLOYEE_EID_EN = 0 ;
									SET @N_SQL = 'SELECT @V_EMPLOYEE_EID_PO = EMPLOYEE_EID FROM '+ @V_DBName + ' EMPLOYEE' ;
									SET @N_SQL = @N_SQL + ' WHERE EMPLOYEE_NUMBER  =  @v_EMPLOYEE_NUMBER_P ' ;
									BEGIN TRY
									Exec sp_Executesql @N_SQL,
										 N' @v_EMPLOYEE_NUMBER_P varchar(20)  ,
										 @V_EMPLOYEE_EID_PO INT OUTPUT ',								 
										 @V_EMPLOYEE_EID_PO = @i_EMPLOYEE_EID_EN OUTPUT , --MK
										 @v_EMPLOYEE_NUMBER_P = @v_SUPER_EMP_NO ;								
								
									END TRY
									BEGIN CATCH	
										 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'Main', 
												@p_CURRENT_ERROR_LOCATION = 'SUPREXIST2', 
												@p_ERROR_PROC_NAME = @V_PROCNAME ,
												@p_ERROR_MSG = @V_ERROR_MESSAGE ,
												@p_ERROR_COLUMNS = NULL , 
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' ,  
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
												@P_IS_VALIDATION = 0 ; 	
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
												SET @iSuperVisorError = 1	--knakra latest				
									END CATCH
									IF (@i_EMPLOYEE_EID_EN > 0) -- MK TZ1 (is this fails, employee should also be not proessed either as Supervisor_EID will have 0 in it)
										BEGIN
											EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
													@p_DA_ROW_ID  = @V_DA_ROW_ID , 
													@p_MODULE_NAME = @V_MODULENAME ,
													@p_CALLING_ERROR_LOCATION = 'Main', 
													@p_CURRENT_ERROR_LOCATION = 'SUPRVD', 
													@p_ERROR_PROC_NAME = @V_PROCNAME ,
													@p_ERROR_MSG = 'Employee Number for Supervisor is already associated with other Employee' ,	--knakra latest(changed error message)
													@p_ERROR_COLUMNS =  @v_SUPER_EMP_NO , --knakra latest(changed error column)
													@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
													@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
													@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
													@P_IS_VALIDATION = 1 ; 
													SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
													SET @iSuperVisorError = 1	--knakra latest
									END
									ELSE
									SET @i_EMPLOYEE_EID_UPDATE = 1;
							   END
					END

IF (@i_PI_TYPE_ENTITY_ID_GEN > 0) AND (upper(@v_PI_TYPE_CODE) = 'E') AND @iSuperVisorError = 0 AND @iSvTidErr = 0  --MKAUR24B	--knakra latest(added supervisorerror check and taxid err check)
BEGIN											 -- .    RMDB Existence of Employee (@PI_TYPE_ENTITY_ID_GEN) TO LOG AN ERROR				
				SET @i_EMPLOYEE_EID  = 0 ;
				SET @N_SQL = 'SELECT @V_EMPLOYEE_EID_PO = EMPLOYEE_EID   FROM '+ @V_DBName + ' EMPLOYEE' ;
				SET @N_SQL = @N_SQL + ' WHERE EMPLOYEE_EID  = @EMPLOYEE_EID_P ' ;
				BEGIN TRY
				Exec sp_Executesql @N_SQL,
					 N'@EMPLOYEE_EID_P INT ,
					  @V_EMPLOYEE_EID_PO INT OUTPUT ',											
					 @EMPLOYEE_EID_P =@i_PI_TYPE_ENTITY_ID_GEN ,								
					 @V_EMPLOYEE_EID_PO = @i_EMPLOYEE_EID OUTPUT ;
				END TRY
				BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'EMPEXIST', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 		
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
										SET @iSuperVisorError = 1	--knakra latest	 
				END CATCH
				IF (@i_EMPLOYEE_EID = 0)
					BEGIN
									SET @i_EMPLOYEE_EID_EN = 0 ;
									SET @N_SQL = 'SELECT @V_EMPLOYEE_EID_PO = EMPLOYEE_EID FROM '+ @V_DBName + ' EMPLOYEE' ;
									SET @N_SQL = @N_SQL + ' WHERE EMPLOYEE_NUMBER  = @v_EMPLOYEE_NUMBER_P ' ;
									BEGIN TRY
									Exec sp_Executesql @N_SQL,
										 N' @v_EMPLOYEE_NUMBER_P varchar(20)  ,
										 @V_EMPLOYEE_EID_PO INT OUTPUT ',								 
										 @V_EMPLOYEE_EID_PO = @i_EMPLOYEE_EID_EN OUTPUT , --MK
										 @v_EMPLOYEE_NUMBER_P = @v_EMPLOYEE_NUMBER ;								
								
									END TRY
									BEGIN CATCH	
										 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												@p_MODULE_NAME = @V_MODULENAME ,
												@p_CALLING_ERROR_LOCATION = 'Main', 
												@p_CURRENT_ERROR_LOCATION = 'EMPEXIST2', 
												@p_ERROR_PROC_NAME = @V_PROCNAME ,
												@p_ERROR_MSG = @V_ERROR_MESSAGE ,
												@p_ERROR_COLUMNS = NULL , 
												@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER' ,  
												@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
												@P_IS_VALIDATION = 0 ; 	
												SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
												SET @iSuperVisorError = 1	--knakra latest
									END CATCH
									IF (@i_EMPLOYEE_EID_EN > 0)
										BEGIN
									 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = 'EMPEXIST3', 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = 'The provided Employee No. is associated with some other Employee_eid.Please provide a valid Employee No.' , -- JIRA 20454 MKAUR24
											@p_ERROR_COLUMNS =  @v_EMPLOYEE_NUMBER , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											@P_IS_VALIDATION = 1 ; 
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
											SET @iSuperVisorError = 1	--knakra latest
									END
									ELSE  
									SET @i_UPDATE_FLAG_EMP = 0;
					END				
		IF @i_EMPLOYEE_EID > 0 
		SET @i_UPDATE_FLAG_EMP = 1 -- EMP EXISTS UPDATE IT
END	 
END



END
								
SET @V_ERROR_LOCATION_MAIN = 'ES12'
				
									--*************************************************************************
									--******************* PERSON INVOLVED VD ENDS *****************************
									--*************************************************************************

				
			
--PRINT '@I_ERRORCOUNT : BEFORE EMPLOYE INSERT STARTS ' + cast (@I_ERRORCOUNT as varchar ) ;


									
									--*************************************************************************
									--******************* EMPLOYEE INSERT STARTS ***************************** -- SEVEN BLOCKS
									--*************************************************************************
									
--SET @i_PI_TYPE_ENTITY_ID_GEN = 78 --remove mk
--SET @v_PI_TYPE_CODE = 'E' --remove mk
IF (  (@i_PI_TYPE_ENTITY_ID_GEN > 0) AND (upper(@v_PI_TYPE_CODE) = 'E') ) --mkaur24 
BEGIN


--PRINT 'SUPERVISR STRT'														 	
--SET @i_SUPERVISOR_ENTITY_ID_GEN = 9 --SAM
														 -- EmpIn3.    SUPERVISOR  INSERT  	
	--SET @i_EMPLOYEE_EID_UPDATE = 0 --SAM
IF (@i_SUPERVISOR_ENTITY_ID_GEN <> 0) AND ( @i_EMPLOYEE_EID_UPDATE = 1) AND @iSuperVisorError = 0 -- SUPERVISOR DOES NOT EXISTS AS AN EMP SO, INSERT /CREATE SUPERVISOR (ELSE IF IT EXISTS DO NOTHING)	--knakra latest(added supervisor check)
			BEGIN
				--PRINT 'SUPERVISR STRT'		
				SET @N_SQL_EVENT = ' INSERT INTO ' + @V_DBNAME + ' EMPLOYEE ( EMPLOYEE_EID , EMPLOYEE_NUMBER )    '
				SET @N_SQL_EVENT = @N_SQL_EVENT + ' VALUES ( @v_EMPLOYEE_EID_P , @v_EMPLOYEE_NUMBER_P ) ' 
									BEGIN TRY
									EXEC sp_Executesql  @N_SQL_EVENT ,
									N' @v_EMPLOYEE_EID_P  int ,
									@v_EMPLOYEE_NUMBER_P	varchar(20)',
									@v_EMPLOYEE_EID_P = @i_SUPERVISOR_ENTITY_ID_GEN ,
									@v_EMPLOYEE_NUMBER_P = @v_SUPER_EMP_NO;

									END TRY
									BEGIN CATCH	
														 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
														 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
																@p_DA_ROW_ID  = @V_DA_ROW_ID , 
																@p_MODULE_NAME = @V_MODULENAME ,
																@p_CALLING_ERROR_LOCATION = 'Main', 
																@p_CURRENT_ERROR_LOCATION = 'SUPRINS', 
																@p_ERROR_PROC_NAME = @V_PROCNAME ,
																@p_ERROR_MSG = @V_ERROR_MESSAGE ,
																@p_ERROR_COLUMNS = NULL , 
																@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
																@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
																@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
																@P_IS_VALIDATION = 0 ; 
																SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
																SET @iSuperVisorError = 1	--knakra latest				 
									END CATCH
						--PRINT '@N_SQL_EVENT SUPERVIUSR' + @N_SQL_EVENT
		   END

--PRINT 'SUPERVISR AFTER END'		

--PRINT '@v_DRIVLIC_STATE_R ' +  CAST (@v_DRIVLIC_STATE_R AS VARCHAR)
--SET @i_UPDATE_FLAG_EMP = 0 ; --SAM
 IF ( @i_UPDATE_FLAG_EMP  = 0 )	AND @iSuperVisorError = 0			 -- EmpIn5.    INSERT Employee			--knakra latest(adder supervisorerror check)
BEGIN 
SET @N_SQL_EVENT = ' INSERT INTO ' + @V_DBNAME + ' EMPLOYEE ( COUNTY_OF_RESIDNC,DRIVLIC_STATE,INSURABLE_FLAG,LAST_VERIFIED_DATE,WORK_PERMIT_DATE,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' WORK_PERMIT_NUMBER,EMPLOYEE_EID,ACTIVE_FLAG,EMPLOYEE_NUMBER,MARITAL_STAT_CODE,DATE_HIRED,POSITION_CODE,DEPT_ASSIGNED_EID,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' EXEMPT_STATUS_FLAG,NO_OF_EXEMPTIONS,FULL_TIME_FLAG,HOURLY_RATE,WEEKLY_HOURS,WEEKLY_RATE,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' WORK_SUN_FLAG,WORK_MON_FLAG,WORK_TUE_FLAG,WORK_WED_FLAG,WORK_THU_FLAG,WORK_FRI_FLAG,WORK_SAT_FLAG,PAY_TYPE_CODE,PAY_AMOUNT,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' DRIVERS_LIC_NO,DRIVERSLICTYPECODE,DATE_DRIVERSLICEXP,DRIVLIC_RSTRCTCODE ,NCCI_CLASS_CODE, NUM_OF_VIOLATIONS , DATE_OF_DEATH)'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' VALUES (@V_COUNTY_OF_RESIDNC_P,@v_DRIVLIC_STATE_P ,@v_INSURABLE_FLAG_P, @v_LAST_VERIFIED_DATE_P , ' 
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_WORK_PERMIT_DATE_P , @v_WORK_PERMIT_NUMBER_P ,@v_EMPLOYEE_EID_P  , @v_ACTIVE_FLAG_P ,	@v_EMPLOYEE_NUMBER_P ,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_MARITAL_STAT_CODE_P ,	@v_DATE_HIRED_P ,	@v_POSITION_CODE_P ,@v_DEPT_ASSIGNED_EID_P , 	@v_EXEMPT_STATUS_FLAG_P ,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_NO_OF_EXEMPTIONS_P ,	@v_FULL_TIME_FLAG_P ,	@v_HOURLY_RATE_P , @v_WEEKLY_HOURS_P	, @v_WEEKLY_RATE_P ,@v_WORK_SUN_FLAG_P ,'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_WORK_MON_FLAG_P ,	@v_WORK_TUE_FLAG_P ,	@v_WORK_WED_FLAG_P , @v_WORK_THU_FLAG_P , @v_WORK_FRI_FLAG_P ,@v_WORK_SAT_FLAG_P ,@v_PAY_TYPE_CODE_P ,	'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_PAY_AMOUNT_P	, 	@v_DRIVERS_LIC_NO_P , @v_DRIVERSLICTYPECODE_P ,	@v_DATE_DRIVERSLICEXP_P ,	@v_DRIVLIC_RSTRCT_CODE_P ,	'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_NCCI_CLASS_CODE_P , @V_NUM_OF_VIOLATION_P ,	@v_DATE_OF_DEATH_P )' 
						--PRINT '@N_SQL_EVENT ERE '  + @N_SQL_EVENT
						BEGIN TRY
						Exec sp_Executesql @N_SQL_EVENT ,
								N' @V_COUNTY_OF_RESIDNC_P varchar(50),
								@v_DRIVLIC_STATE_P	INT ,
								@v_INSURABLE_FLAG_P	INT ,
								@v_LAST_VERIFIED_DATE_P	varchar(8),
								@v_WORK_PERMIT_DATE_P	varchar(8),
								@v_WORK_PERMIT_NUMBER_P	varchar(50),
								@v_EMPLOYEE_EID_P  int ,
								@v_ACTIVE_FLAG_P	INT,
								@v_EMPLOYEE_NUMBER_P	varchar(20),
								@v_MARITAL_STAT_CODE_P	INT,
								@v_DATE_HIRED_P	varchar(8),
								@v_POSITION_CODE_P	INT,
								@v_DEPT_ASSIGNED_EID_P int ,								
								@v_EXEMPT_STATUS_FLAG_P	INT,
								@v_NO_OF_EXEMPTIONS_P	INT,
								@v_FULL_TIME_FLAG_P INT ,
								@v_HOURLY_RATE_P	decimal(20,2),
								@v_WEEKLY_HOURS_P	decimal(20,2),
								@v_WEEKLY_RATE_P	decimal(20,2),
								@v_WORK_SUN_FLAG_P	int,
								@v_WORK_MON_FLAG_P	int,
								@v_WORK_TUE_FLAG_P	int,
								@v_WORK_WED_FLAG_P	int,
								@v_WORK_THU_FLAG_P	int,
								@v_WORK_FRI_FLAG_P	int,
								@v_WORK_SAT_FLAG_P	int,
								@v_PAY_TYPE_CODE_P	INT,
								@v_PAY_AMOUNT_P	decimal(20,2), 
								@v_DRIVERS_LIC_NO_P	varchar(20) ,
								@v_DRIVERSLICTYPECODE_P	INT ,
								@v_DATE_DRIVERSLICEXP_P	varchar(8),
								@v_DRIVLIC_RSTRCT_CODE_P	INT ,
								@v_NCCI_CLASS_CODE_P	INT ,
								@V_NUM_OF_VIOLATION_P INT ,
								@v_DATE_OF_DEATH_P	varchar(8)',
								@V_COUNTY_OF_RESIDNC_P = @V_COUNTY_OF_RESIDNC ,
								@v_DRIVLIC_STATE_P = @v_DRIVLIC_STATE_R, 
								@v_INSURABLE_FLAG_P = @v_INSURABLE_FLAG_GEN,
								@v_LAST_VERIFIED_DATE_P = @v_LAST_VERIFIED_DATE ,
								@v_WORK_PERMIT_DATE_P = @v_WORK_PERMIT_DATE ,
								@v_WORK_PERMIT_NUMBER_P = @v_WORK_PERMIT_NUMBER ,
								@v_EMPLOYEE_EID_P = @i_PI_TYPE_ENTITY_ID_GEN  , 
								@v_ACTIVE_FLAG_P = @v_ACTIVE_FLAG_GEN ,
								@v_EMPLOYEE_NUMBER_P = @v_EMPLOYEE_NUMBER  ,
								@v_MARITAL_STAT_CODE_P = @MARITAL_STAT_CODE_R ,
								@v_DATE_HIRED_P = @v_DATE_HIRED,
								@v_POSITION_CODE_P = @POSITION_CODE_R,
								@v_DEPT_ASSIGNED_EID_P  = @i_DEPT_ASSIGNED_GEN,								 
								@v_EXEMPT_STATUS_FLAG_P = @v_EXEMPT_STATUS_FLAG_GEN,
								@v_NO_OF_EXEMPTIONS_P = @v_NO_OF_EXEMPTIONS ,
								@v_FULL_TIME_FLAG_P = @v_FULL_TIME_FLAG_GEN ,
								@v_HOURLY_RATE_P = @v_HOURLY_RATE ,
								@v_WEEKLY_HOURS_P = @v_WEEKLY_HOURS , 
								@v_WEEKLY_RATE_P = @v_WEEKLY_RATE ,
								@v_WORK_SUN_FLAG_P = @v_WORK_SUN_FLAG_GEN ,
								@v_WORK_MON_FLAG_P = @v_WORK_MON_FLAG_GEN ,
								@v_WORK_TUE_FLAG_P = @v_WORK_TUE_FLAG_GEN ,
								@v_WORK_WED_FLAG_P = @v_WORK_WED_FLAG_GEN ,
								@v_WORK_THU_FLAG_P = @v_WORK_THU_FLAG_GEN ,
								@v_WORK_FRI_FLAG_P = @v_WORK_FRI_FLAG_GEN ,
								@v_WORK_SAT_FLAG_P = @v_WORK_SAT_FLAG_GEN ,
								@v_PAY_TYPE_CODE_P = @PAY_TYPE_CODE_R ,
								@v_PAY_AMOUNT_P	= @v_PAY_AMOUNT ,
								@v_DRIVERS_LIC_NO_P = @v_DRIVERS_LIC_NO,
								@v_DRIVERSLICTYPECODE_P = @DRIVERSLICTYPECODE_R ,
								@v_DATE_DRIVERSLICEXP_P = @v_DATE_DRIVERSLICEXP ,
								@v_DRIVLIC_RSTRCT_CODE_P = @DRIVLIC_RSTRCT_CODE_R ,
								@v_NCCI_CLASS_CODE_P = @NCCI_CLASS_CODE_R ,
								@V_NUM_OF_VIOLATION_P  = @V_NUM_OF_VIOLATION ,
								@v_DATE_OF_DEATH_P = @v_DATE_OF_DEATH ;
						END TRY
						BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'INSEMP', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 	
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						END CATCH
END 
-- COLUMNS NOT FOUND -- > TERM_DATE,SEC_DEPT_EID,JOB_CLASS_CODE,MONTHLY_RATE,ELIG_DIS_BEN_FLAG,DIS_OPTION_CODE,DAILY_COMP_RATE,POST_WEEKLY_WAGE,FEIN_TEXT,DRIVLIC_RSTRCTCODE,



--SET @i_PI_TYPE_ENTITY_ID_GEN = 78
--SET @i_UPDATE_FLAG_EMP = 1 ; --SAM
ELSE IF  ( @i_UPDATE_FLAG_EMP  = 1)	AND @iSuperVisorError = 0				 -- EmpIn6.	   Update Employee	knakra latest(added supervisor error check)
BEGIN					
						--PRINT '@@UPDATE EMP ENTERD' 
						--PRINT '@@DRIVLIC_STATE_R' + CAST (@v_DRIVLIC_STATE_R AS VARCHAR )
						
						SET @N_SQL_EVENT = ' UPDATE ' + @V_DBNAME + ' EMPLOYEE  SET EMPLOYEE_EID =   @v_EMPLOYEE_EID_P ' ; -- JIRA RMA - 20453  MKAUR24
						
						IF @V_COUNTY_OF_RESIDNC IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',COUNTY_OF_RESIDNC =  @V_COUNTY_OF_RESIDNC_P'
						IF @v_DRIVLIC_STATE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVLIC_STATE =  @v_DRIVLIC_STATE_P'
						IF @v_INSURABLE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',INSURABLE_FLAG = @v_INSURABLE_FLAG_P'
						IF @v_LAST_VERIFIED_DATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',LAST_VERIFIED_DATE =   @v_LAST_VERIFIED_DATE_P'
						IF @v_WORK_PERMIT_DATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_PERMIT_DATE =   @v_WORK_PERMIT_DATE_P'
						IF @v_WORK_PERMIT_NUMBER IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_PERMIT_NUMBER =  @v_WORK_PERMIT_NUMBER_P'
						IF @v_ACTIVE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',ACTIVE_FLAG = @v_ACTIVE_FLAG_P'
						--IF @v_EMPLOYEE_NUMBER IS NOT NULL
						--SET	@N_SQL_EVENT = @N_SQL_EVENT  + 'EMPLOYEE_NUMBER = @v_EMPLOYEE_NUMBER_P,'
						IF @MARITAL_STAT_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',MARITAL_STAT_CODE = @v_MARITAL_STAT_CODE_P'
						IF @v_DATE_HIRED IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_HIRED = @v_DATE_HIRED_P'
						IF @POSITION_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',POSITION_CODE = @v_POSITION_CODE_P'
						IF @i_DEPT_ASSIGNED_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DEPT_ASSIGNED_EID = @v_DEPT_ASSIGNED_EID_P'						
						IF @v_EXEMPT_STATUS_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',EXEMPT_STATUS_FLAG = @v_EXEMPT_STATUS_FLAG_P'
						IF @v_NO_OF_EXEMPTIONS IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',NO_OF_EXEMPTIONS = @v_NO_OF_EXEMPTIONS_P'
						IF @v_FULL_TIME_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',FULL_TIME_FLAG = @v_FULL_TIME_FLAG_P '
						IF @v_HOURLY_RATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',HOURLY_RATE = @v_HOURLY_RATE_P'
						IF @v_WEEKLY_HOURS IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WEEKLY_HOURS = @v_WEEKLY_HOURS_P'
						IF @v_WEEKLY_RATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WEEKLY_RATE = @v_WEEKLY_RATE_P'
						IF @v_WORK_SUN_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_SUN_FLAG = @v_WORK_SUN_FLAG_P'
						IF @v_WORK_MON_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_MON_FLAG = @v_WORK_MON_FLAG_P'
						IF @v_WORK_TUE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_TUE_FLAG = @v_WORK_TUE_FLAG_P'
						IF @v_WORK_WED_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_WED_FLAG = @v_WORK_WED_FLAG_P'
						IF @v_WORK_THU_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_THU_FLAG = @v_WORK_THU_FLAG_P'
						IF @v_WORK_FRI_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_FRI_FLAG = @v_WORK_FRI_FLAG_P'
						IF @v_WORK_SAT_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_SAT_FLAG = @v_WORK_SAT_FLAG_P'
						IF @PAY_TYPE_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',PAY_TYPE_CODE = @v_PAY_TYPE_CODE_P'
						IF @v_PAY_AMOUNT IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',PAY_AMOUNT = @v_PAY_AMOUNT_P'
						IF  @v_DRIVERS_LIC_NO IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVERS_LIC_NO = @v_DRIVERS_LIC_NO_P'
						IF @DRIVERSLICTYPECODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVERSLICTYPECODE = @v_DRIVERSLICTYPECODE_P'
						IF @v_DATE_DRIVERSLICEXP IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_DRIVERSLICEXP = @v_DATE_DRIVERSLICEXP_P'
						IF @DRIVLIC_RSTRCT_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVLIC_RSTRCTCODE = @v_DRIVLIC_RSTRCT_CODE_P'
						IF @NCCI_CLASS_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',NCCI_CLASS_CODE = @v_NCCI_CLASS_CODE_P'
						IF @V_NUM_OF_VIOLATION IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',NUM_OF_VIOLATIONS = @V_NUM_OF_VIOLATION_P'
						IF @v_DATE_OF_DEATH  IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_OF_DEATH = @v_DATE_OF_DEATH_P'

						
						SET	 @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE  EMPLOYEE_EID =   @v_EMPLOYEE_EID_P ' ;	
								  BEGIN TRY
								   Exec sp_Executesql @N_SQL_EVENT ,
										N' @V_COUNTY_OF_RESIDNC_P varchar(50),
										@v_DRIVLIC_STATE_P	INT ,
										@v_INSURABLE_FLAG_P	INT ,
										@v_LAST_VERIFIED_DATE_P	varchar(8),
										@v_WORK_PERMIT_DATE_P	varchar(8),
										@v_WORK_PERMIT_NUMBER_P	varchar(50),
										@v_EMPLOYEE_EID_P  int ,
										@v_ACTIVE_FLAG_P	INT,										
										@v_MARITAL_STAT_CODE_P	INT,
										@v_DATE_HIRED_P	varchar(8),
										@v_POSITION_CODE_P	INT,
										@v_DEPT_ASSIGNED_EID_P int ,									
										@v_EXEMPT_STATUS_FLAG_P	INT,
										@v_NO_OF_EXEMPTIONS_P	int,
										@v_FULL_TIME_FLAG_P INT,
										@v_HOURLY_RATE_P	decimal(20,2),
										@v_WEEKLY_HOURS_P	decimal(20,2),
										@v_WEEKLY_RATE_P	decimal(20,2),
										@v_WORK_SUN_FLAG_P	int,
										@v_WORK_MON_FLAG_P	int,
										@v_WORK_TUE_FLAG_P	int,
										@v_WORK_WED_FLAG_P	int,
										@v_WORK_THU_FLAG_P	int,
										@v_WORK_FRI_FLAG_P	int,
										@v_WORK_SAT_FLAG_P	int,
										@v_PAY_TYPE_CODE_P	INT,
										@v_PAY_AMOUNT_P	decimal(20,2), 
										@v_DRIVERS_LIC_NO_P	varchar(20) ,
										@v_DRIVERSLICTYPECODE_P	INT ,
										@v_DATE_DRIVERSLICEXP_P	varchar(8),
										@v_DRIVLIC_RSTRCT_CODE_P	INT ,
										@v_NCCI_CLASS_CODE_P	INT,
										@V_NUM_OF_VIOLATION_P INT ,
										@v_DATE_OF_DEATH_P	varchar(8)',
										@V_COUNTY_OF_RESIDNC_P = @V_COUNTY_OF_RESIDNC ,
										@v_DRIVLIC_STATE_P = @v_DRIVLIC_STATE_R , 
										@v_INSURABLE_FLAG_P = @v_INSURABLE_FLAG_GEN,
										@v_LAST_VERIFIED_DATE_P = @v_LAST_VERIFIED_DATE ,
										@v_WORK_PERMIT_DATE_P = @v_WORK_PERMIT_DATE ,
										@v_WORK_PERMIT_NUMBER_P = @v_WORK_PERMIT_NUMBER ,
										@v_EMPLOYEE_EID_P = @i_PI_TYPE_ENTITY_ID_GEN  , 
										@v_ACTIVE_FLAG_P = @v_ACTIVE_FLAG_GEN ,										
										@v_MARITAL_STAT_CODE_P = @MARITAL_STAT_CODE_R ,
										@v_DATE_HIRED_P = @v_DATE_HIRED,
										@v_POSITION_CODE_P = @POSITION_CODE_R,
										@v_DEPT_ASSIGNED_EID_P  = @i_DEPT_ASSIGNED_GEN,									
										@v_EXEMPT_STATUS_FLAG_P = @v_EXEMPT_STATUS_FLAG_GEN,
										@v_NO_OF_EXEMPTIONS_P = @v_NO_OF_EXEMPTIONS ,
										@v_FULL_TIME_FLAG_P = @v_FULL_TIME_FLAG_GEN ,
										@v_HOURLY_RATE_P = @v_HOURLY_RATE ,
										@v_WEEKLY_HOURS_P = @v_WEEKLY_HOURS , 
										@v_WEEKLY_RATE_P = @v_WEEKLY_RATE ,
										@v_WORK_SUN_FLAG_P = @v_WORK_SUN_FLAG_GEN ,
										@v_WORK_MON_FLAG_P = @v_WORK_MON_FLAG_GEN ,
										@v_WORK_TUE_FLAG_P = @v_WORK_TUE_FLAG_GEN ,
										@v_WORK_WED_FLAG_P = @v_WORK_WED_FLAG_GEN ,
										@v_WORK_THU_FLAG_P = @v_WORK_THU_FLAG_GEN ,
										@v_WORK_FRI_FLAG_P = @v_WORK_FRI_FLAG_GEN ,
										@v_WORK_SAT_FLAG_P = @v_WORK_SAT_FLAG_GEN ,
										@v_PAY_TYPE_CODE_P = @PAY_TYPE_CODE_R ,
										@v_PAY_AMOUNT_P	= @v_PAY_AMOUNT ,
										@v_DRIVERS_LIC_NO_P = @v_DRIVERS_LIC_NO,
										@v_DRIVERSLICTYPECODE_P = @DRIVERSLICTYPECODE_R ,
										@v_DATE_DRIVERSLICEXP_P = @v_DATE_DRIVERSLICEXP ,
										@v_DRIVLIC_RSTRCT_CODE_P = @DRIVLIC_RSTRCT_CODE_R ,
										@v_NCCI_CLASS_CODE_P = @NCCI_CLASS_CODE_R ,
										@V_NUM_OF_VIOLATION_P  = @V_NUM_OF_VIOLATION ,
										@v_DATE_OF_DEATH_P = @v_DATE_OF_DEATH ;
								  END TRY
								BEGIN CATCH	
								 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										@p_MODULE_NAME = @V_MODULENAME ,
										@p_CALLING_ERROR_LOCATION = 'Main', 
										@p_CURRENT_ERROR_LOCATION = 'UPDEMP', 
										@p_ERROR_PROC_NAME = @V_PROCNAME ,
										@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										@p_ERROR_COLUMNS = NULL , 
										@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										@P_IS_VALIDATION = 0 ; 		
										SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		 
						      END CATCH
					--PRINT 'EMP UPDATE STSTMNT : ' + @N_SQL_EVENT
				END

END

								
SET @V_ERROR_LOCATION_MAIN = 'ES13'


									--*************************************************************************
									--******************* EMPLOYEE INSERT ENDS *****************************		-- SEVEN BLOCKS
									--*************************************************************************




			--******************************* Supplemental Validation call Start**********************************
--print 'entered supp'	--MK(remove)
IF  (@EVENT_SUPP <> 0)
BEGIN

EXEC DDS_SUPPLEMENT 
@P_JOBID                = @p_JOBID,
@P_CONFIG_ID            = @CONFIG_ID,
@P_USER_ID              = @p_USERID,
@P_MODULE_NAME          = 'EVENT',
@P_DB_NAME              = @V_DBName,
@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
@P_LOB                  = 0,
@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
@P_STAGE                = 'V',  -- V for validation and I for Insert
@P_CLAIMANT_EID         = 0,
@P_EVENT_ID             = 0,
@P_CLAIM_ID             = 0,
@P_EMPLOYEE_EID         = 0,
@P_UNIT_ID              = 0,
@P_ENTITY_ID            = 0,
@P_DEFENDANT_ROW_ID     = 0,
@P_PI_ROW_ID            = 0,
@P_PI_PROC_ROW_ID       = 0,
@P_PATIENT_ID           = 0,
@P_TRANS_ID             = 0,
@P_PLAN_ID              = 0,
@P_EV_CONCOM_ROW_ID = 0,
@P_EV_MW_TEST_ROW_ID = 0,
@P_KEYCOLUMN            = 'EVENT_NUMBER',
@P_KEYVALUE             = @v_EVENT_NUMBER,
@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
END
--print 'after supp call'	--MK(remove)
				--******************************* Supplemental Validation call End**********************************

								
SET @V_ERROR_LOCATION_MAIN = 'ES14'


--print '@P_SUPP_ERROR_COUNT_R : ' + cast ( @P_SUPP_ERROR_COUNT_R as varchar )
	
	SET @I_ERRORCOUNT = @P_SUPP_ERROR_COUNT_R + @I_ERRORCOUNT

--print @P_SUPP_ERROR_COUNT_R 


BEGIN TRY

				
									--*************************************************************************
									--******************* IMPORT EVENT STARTS *****************************			-- Eight Blocks
									--*************************************************************************


								
IF ( @I_ERRORCOUNT = 0)	
BEGIN				
		BEGIN																									-- EI1. IMPORT DATA MANUPULATION 
					IF (UPPER(@v_ON_PREMISE_FLAG) = 'Y') SET @I_ON_PREMISE_FLAG_GEN = '-1' ;
					IF (UPPER(@v_ON_PREMISE_FLAG) = 'N') OR (@V_ON_PREMISE_FLAG  IS NULL ) SET @I_ON_PREMISE_FLAG_GEN = '0' ;
					IF (UPPER(@v_NO_RULES_FLAG)	  = 'Y') SET @I_NO_RULES_FLAG_GEN = '-1' ;
					IF (UPPER(@v_NO_RULES_FLAG)   = 'N') OR (@v_NO_RULES_FLAG  IS NULL ) SET @I_NO_RULES_FLAG_GEN = '0' ;
					IF (UPPER(@v_RECORDABLE_FLAG) = 'Y') SET @I_RECORDABLE_FLAG_GEN = '-1' ;
					IF (UPPER(@v_RECORDABLE_FLAG) = 'N') OR (@v_RECORDABLE_FLAG  IS NULL ) SET @I_RECORDABLE_FLAG_GEN = '0' ;
					IF (UPPER(@v_SAFEG_NOTUSED_FLAG) = 'Y') SET @I_SAFEG_NOTUSED_GEN = '-1' ;
					IF (UPPER(@v_SAFEG_NOTUSED_FLAG) = 'N') OR (@v_SAFEG_NOTUSED_FLAG  IS NULL ) SET @I_SAFEG_NOTUSED_GEN = '0' ;
					IF (UPPER(@v_SAFEGUARD_FLAG) = 'Y') SET @I_SAFEGUARD_FLAG_GEN = '-1' ;
					IF (UPPER(@v_SAFEGUARD_FLAG) = 'N') OR (@v_SAFEGUARD_FLAG  IS NULL ) SET @I_SAFEGUARD_FLAG_GEN = '0' ;
					IF (UPPER(@v_PRIVACY_CASE_FLAG) = 'Y') SET @I_PRIVACY_CASE_GEN = '-1' ;
					IF (UPPER(@v_PRIVACY_CASE_FLAG) = 'N') OR (@v_PRIVACY_CASE_FLAG  IS NULL ) SET @I_PRIVACY_CASE_GEN = '0' ;	
					IF (UPPER(@v_RELEASE_SIGNED) = 'N') OR (@v_RELEASE_SIGNED IS NULL ) SET @I_RELEASE_SIGNED_GEN = '0' ;
					IF (UPPER(@v_RELEASE_SIGNED) = 'Y') SET @I_RELEASE_SIGNED_GEN = '-1' ;	
					IF (UPPER(@v_DEPT_HEAD_ADVISED) = 'N') OR (@v_DEPT_HEAD_ADVISED  IS NULL ) SET @I_DEPT_HEAD_ADVISED_GEN = '0' ;				
					IF (UPPER(@v_DEPT_HEAD_ADVISED) = 'Y') SET @I_DEPT_HEAD_ADVISED_GEN = '-1' 								
					IF (UPPER(@v_TREATMENT_GIVEN) = 'N') OR (@v_TREATMENT_GIVEN  IS NULL ) SET @I_TREATMENT_GIVEN_GEN = '0' ;				
					IF (UPPER(@v_TREATMENT_GIVEN) = 'Y') SET @I_TREATMENT_GIVEN_GEN = '-1' ;	
								
					SET @V_DTTM_RCD_ADDED_GEN = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');  
					SET @V_DTTM_RCD_LAST_UPD_GEN = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
					--PRINT '@V_DTTM_RCD_LAST_UPD_GEN' + @V_DTTM_RCD_LAST_UPD_GEN ;
					SET @V_UPDATED_BY_USER = 'DDS' ; SET @V_ADDED_BY_USER = 'DDS' ; 		
					--IF	@V_ORGSEC_FLAG = 1 	SET @V_SEC_DEPT_EID =  @I_DEPARTMENT_GEN ; 
		END	


		BEGIN			-- EI3. CHECK IF AN EXISTING EVENT OR A NEW EVENT 
					SET @i_EVENT_ID = 0 ;																				
					SET @V_ERROR_LOCATION = 'I2' ;
					SET @N_SQL = 'SELECT @EVENTID_P = EVENT_ID  FROM ' + @V_DBName +' EVENT';
					SET @N_SQL =  @N_SQL + ' WHERE EVENT_NUMBER = @EVENT_NUMBER_P  ';									
						--BEGIN TRY
						Exec sp_Executesql @N_SQL,
							 N' @EVENTID_P INT OUTPUT,							 
							 @EVENT_NUMBER_P VARCHAR(25)',
							 @EVENTID_P = @i_EVENT_ID OUTPUT ,							
							 @EVENT_NUMBER_P = @V_EVENT_NUMBER;			
						--END TRY
						 --BEGIN CATCH	
						 --SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						 --EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--	@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--	@p_MODULE_NAME = @V_MODULENAME ,
							--	@p_CALLING_ERROR_LOCATION = 'Main', 
							--	@p_CURRENT_ERROR_LOCATION = 'EXISTEVEN', 
							--	@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--	@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--	@p_ERROR_COLUMNS = NULL , 
							--	@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--	@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--	@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--	@P_IS_VALIDATION = 0 ; 	
							--	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						 --END CATCH							 
				--PRINT '@N_SQL EVENT QUERY : ' + @N_SQL
						SET @V_ERROR_LOCATION = 'I3' ;
				IF @i_EVENT_ID = 0
					SET @I_UPDATE_FLAG_EVENT = 0 ;			
				ELSE IF @i_EVENT_ID > 0
					SET @I_UPDATE_FLAG_EVENT = 1 ;		
		END	
			--SET @I_UPDATE_FLAG_EVENT  = 0 ; --SAM
		IF ((@I_UPDATE_FLAG_EVENT =  0) )												-- EI4. INSERT EVENT												
		BEGIN 					
		    IF @v_EVENT_DESCRIPTION LIKE'%''''%' OR @v_BRIEF_DESCRIPTION LIKE'%''''%' OR @v_ADDR1 LIKE'%''''%'OR @v_ADDR2 LIKE'%''''%'OR @v_LOCATION_AREA_DESC LIKE'%''''%' OR @v_COMMENTS LIKE'%''''%'    --ddhupar JIRA 78172 starts
				BEGIN 
				SET @v_EVENT_DESCRIPTION = REPLACE(@v_EVENT_DESCRIPTION,'''''','''')
				SET @v_BRIEF_DESCRIPTION = REPLACE(@v_BRIEF_DESCRIPTION,'''''','''') 
				SET @v_ADDR1 = REPLACE(@v_ADDR1,'''''','''') 
				SET @v_ADDR2 = REPLACE(@v_ADDR2,'''''','''') 
				SET @v_LOCATION_AREA_DESC = REPLACE(@v_LOCATION_AREA_DESC,'''''','''') 
				SET @v_COMMENTS = REPLACE(@v_COMMENTS,'''''','''')  
				END			                                              --ddhupar JIRA 78172 ends
								SET	  @N_SQL = 'SELECT @V_NEXT_UNIQUE_ID_P = NEXT_UNIQUE_ID FROM ' + @V_DBNAME + ' GLOSSARY G ' ;
								SET	  @N_SQL =  @N_SQL + ' WHERE  SYSTEM_TABLE_NAME = ''EVENT'' ' ;
								SET @V_ERROR_LOCATION = 'I4' ;
								--BEGIN TRY
								Exec sp_Executesql @N_SQL, 
									 N' @V_NEXT_UNIQUE_ID_P varchar(255) OUTPUT',
									 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID OUTPUT;										
								SET @V_ERROR_LOCATION = 'I5' ;
								--END TRY
								-- BEGIN CATCH	
								--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--				@p_MODULE_NAME = @V_MODULENAME ,
								--				@p_CALLING_ERROR_LOCATION = 'Main', 
								--				@p_CURRENT_ERROR_LOCATION = 'NEXTUNQEV', 
								--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--				@p_ERROR_COLUMNS = NULL , 
								--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--				@P_IS_VALIDATION = 0 ; 	
								--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								--END CATCH

								SET @V_ERROR_LOCATION = 'I6' ;
								IF ((@V_NEXT_UNIQUE_ID IS NULL) OR (@V_NEXT_UNIQUE_ID = 0 ))
									BEGIN
										SET @V_NEXT_UNIQUE_ID = 1
									END	
								SET	 @i_EVENT_ID        = @V_NEXT_UNIQUE_ID ;
								--PRINT '@i_EVENT_ID LKK' + CAST (@i_EVENT_ID AS VARCHAR)
								SET @V_ERROR_LOCATION = 'I7' ;
			SET @N_SQL_EVENT = 'INSERT INTO '+ @V_DBNAME + ' EVENT ( COUNTY_OF_INJURY,EVENT_ID,EVENT_NUMBER,EVENT_TYPE_CODE,EVENT_STATUS_CODE,EVENT_IND_CODE,';
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' EVENT_DESCRIPTION,BRIEF_DESC,DEPT_EID,DEPT_INVOLVED_EID,ADDR1,ADDR2,CITY,STATE_ID,ZIP_CODE,COUNTRY_CODE,';
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' LOCATION_AREA_DESC,PRIMARY_LOC_CODE,LOCATION_TYPE_CODE,ON_PREMISE_FLAG,NO_OF_INJURIES,NO_OF_FATALITIES,';
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' CAUSE_CODE,DATE_OF_EVENT,TIME_OF_EVENT,DATE_REPORTED,TIME_REPORTED,RPTD_BY_EID,DATE_TO_FOLLOW_UP,COMMENTS,';
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' DATE_PHYS_ADVISED,TIME_PHYS_ADVISED,TREATMENT_GIVEN,RELEASE_SIGNED,DEPT_HEAD_ADVISED,PHYS_NOTES,' ;
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' DATE_CARRIER_NOTIF,DTTM_RCD_ADDED,ADDED_BY_USER )';			
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' VALUES ( @V_COUNTY_OF_INJURY_P, @I_EVENT_ID_P  ,	@v_EVENT_NUMBER_P, @v_EVENT_TYPE_CODE_P, @v_EVENT_STATUS_CODE_P, @v_EVENT_IND_CODE_P, @v_EVENT_DESCRIPTION_P , @v_BRIEF_DESCRIPTION_P ,	@v_DEPARTMENT_P	,	@v_DEPT_INVOLVED_P, 	@v_ADDR1_P ,	@v_ADDR2_P ,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_CITY_P ,	@v_STATE_P ,	@v_ZIP_CODE_P, 	@V_COUNTRY_P ,	@v_LOCATION_AREA_DESC_P, 	@v_PRIMARY_LOC_CODE_P ,	@v_LOCATION_TYPE_CODE_P,	@v_ON_PREMISE_FLAG_P ,	@v_NO_OF_INJURIES_P	,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_NO_OF_FATALITIES_P ,	@v_CAUSE_CODE_P	,	@v_DATE_OF_EVENT_P	,	@v_TIME_OF_EVENT_P	,	@v_DATE_REPORTED_P	,	@v_TIME_REPORTED_P	,	@V_RPTD_BY_EID_P  ,	@v_DATE_TO_FOLLOW_UP_P	,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_COMMENTS_P	,	@v_DATE_PHYS_ADVISED_P	, 	@v_TIME_PHYS_ADVISED_P	,	@v_TREATMENT_GIVEN_P 	,	@v_RELEASE_SIGNED_P 	,	@v_DEPT_HEAD_ADVISED_P 	,	@v_PHYS_NOTES_P	,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_DATE_CARRIER_NOTIF_P	,	@V_DTTM_RCD_ADDED_P  ,	@V_ADDED_BY_USER_P    )'							
								--print '@N_SQL_EVENT see' + @N_SQL_EVENT
								--BEGIN TRY
								Exec sp_Executesql @N_SQL_EVENT ,
									N'@V_COUNTY_OF_INJURY_P	varchar(50) ,
									@I_EVENT_ID_P INT ,
									@v_EVENT_NUMBER_P varchar(25),
									@v_EVENT_TYPE_CODE_P	INT,
									@v_EVENT_STATUS_CODE_P	INT,
									@v_EVENT_IND_CODE_P	INT,
									@v_EVENT_DESCRIPTION_P	varchar(max),
									@v_BRIEF_DESCRIPTION_P	varchar(250),
									@v_DEPARTMENT_P	INT ,
									@v_DEPT_INVOLVED_P	INT,
									@v_ADDR1_P	varchar(100),
									@v_ADDR2_P	varchar(100),
									@v_CITY_P	varchar(50),
									@v_STATE_P	INT,
									@v_ZIP_CODE_P	varchar(10),
									@V_COUNTRY_P	INT,
									@v_LOCATION_AREA_DESC_P	varchar(max),
									@v_PRIMARY_LOC_CODE_P	INT,
									@v_LOCATION_TYPE_CODE_P	INT,
									@v_ON_PREMISE_FLAG_P	INT,
									@v_NO_OF_INJURIES_P	int,
									@v_NO_OF_FATALITIES_P	int,
									@v_CAUSE_CODE_P	INT,
									@v_DATE_OF_EVENT_P	varchar(8),
									@v_TIME_OF_EVENT_P	varchar(6),
									@v_DATE_REPORTED_P	varchar(8),
									@v_TIME_REPORTED_P	varchar(6),
									@V_RPTD_BY_EID_P INT ,
									@v_DATE_TO_FOLLOW_UP_P	varchar(8),
									@v_COMMENTS_P	varchar(max),
									@v_DATE_PHYS_ADVISED_P	varchar(8), 
									@v_TIME_PHYS_ADVISED_P	varchar(8),
									@v_TREATMENT_GIVEN_P 	INT,
									@v_RELEASE_SIGNED_P 	INT,
									@v_DEPT_HEAD_ADVISED_P 	INT,
									@v_PHYS_NOTES_P	varchar(max),
									@v_DATE_CARRIER_NOTIF_P	varchar(8),
									@V_DTTM_RCD_ADDED_P varchar(255) ,
									@V_ADDED_BY_USER_P varchar(255) ,
									@V_SEC_DEPT_EID_P INT',							
									@V_COUNTY_OF_INJURY_P = @V_COUNTY_OF_INJURY	 ,
									@I_EVENT_ID_P  = @i_EVENT_ID ,
									@v_EVENT_NUMBER_P  = @v_EVENT_NUMBER ,
									@v_EVENT_TYPE_CODE_P = @EVENT_TYPE_CODE_R	,
									@v_EVENT_STATUS_CODE_P	=  @EVENT_STATUS_CODE_R ,
									@v_EVENT_IND_CODE_P	= @EVENT_IND_CODE_R ,
									@v_EVENT_DESCRIPTION_P = @v_EVENT_DESCRIPTION	,
									@v_BRIEF_DESCRIPTION_P = @v_BRIEF_DESCRIPTION	,
									@v_DEPARTMENT_P	= @i_DEPARTMENT_GEN  ,
									@v_DEPT_INVOLVED_P = @i_DEPT_INVOLVED_GEN  	,
									@v_ADDR1_P = @v_ADDR1	,
									@v_ADDR2_P = @v_ADDR2	,
									@v_CITY_P = @v_CITY	,
									@v_STATE_P = @v_STATE_R	,
									@v_ZIP_CODE_P = @v_ZIP_CODE	,
									@V_COUNTRY_P = @COUNTRY_R,
									@v_LOCATION_AREA_DESC_P = @v_LOCATION_AREA_DESC	,
									@v_PRIMARY_LOC_CODE_P = @PRIMARY_LOC_CODE_R	,
									@v_LOCATION_TYPE_CODE_P = @LOCATION_TYPE_CODE_R	,
									@v_ON_PREMISE_FLAG_P = @I_ON_PREMISE_FLAG_GEN	,
									@v_NO_OF_INJURIES_P	= @v_NO_OF_INJURIES ,
									@v_NO_OF_FATALITIES_P = @v_NO_OF_FATALITIES	,
									@v_CAUSE_CODE_P	= @CAUSE_CODE_R ,
									@v_DATE_OF_EVENT_P = @v_DATE_OF_EVENT	,
									@v_TIME_OF_EVENT_P	= @v_TIME_OF_EVENT ,
									@v_DATE_REPORTED_P = @v_DATE_REPORTED	,
									@v_TIME_REPORTED_P = @v_TIME_REPORTED,
									@V_RPTD_BY_EID_P = @i_Reporter_ENTITY_ID_GEN ,
									@v_DATE_TO_FOLLOW_UP_P	= @v_DATE_TO_FOLLOW_UP ,
									@v_COMMENTS_P = @v_COMMENTS	,
									@v_DATE_PHYS_ADVISED_P = @v_DATE_PHYS_ADVISED, 
									@v_TIME_PHYS_ADVISED_P = @v_TIME_PHYS_ADVISED,
									@v_TREATMENT_GIVEN_P = @I_TREATMENT_GIVEN_GEN, 
									@v_RELEASE_SIGNED_P =   @I_RELEASE_SIGNED_GEN  , 
									@v_DEPT_HEAD_ADVISED_P = @I_DEPT_HEAD_ADVISED_GEN ,
									@v_PHYS_NOTES_P = @v_PHYS_NOTES	,
									@v_DATE_CARRIER_NOTIF_P = @v_DATE_CARRIER_NOTIF	,
									@V_DTTM_RCD_ADDED_P = @V_DTTM_RCD_ADDED_GEN  ,
									@V_ADDED_BY_USER_P = @V_ADDED_BY_USER ,
									@V_SEC_DEPT_EID_P  = @V_SEC_DEPT_EID;		
								--END TRY
								--BEGIN CATCH	
								--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--				@p_MODULE_NAME = @V_MODULENAME ,
								--				@p_CALLING_ERROR_LOCATION = 'Main', 
								--				@p_CURRENT_ERROR_LOCATION = 'INSEVE', 
								--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--				@p_ERROR_COLUMNS = NULL , 
								--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--				@P_IS_VALIDATION = 0 ;
								--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
								--END CATCH										
								SET @V_ERROR_LOCATION = 'I8' ;
		--COLUMNS NOT FOUND
		--ADDR4 ,ADDR3 ,CATASTROPHE_CODE , CONF_EVENT_ID,CONF_FLAG ,DATE_RPTD_TO_RM , 
		--RPTD_BY_EID ,INJURY_FROM_DATE ,INJURY_TO_DATE ,EVENT_DESCRIPTION_HTMLCOMMENTS ,INT_REQ_FLAG,LOCATION_AREA_DESC_HTMCOMMENTS, HTMLCOMMENTS, ACCOUNT_ID			 
							--Update NEXT_UNIQUE_ID in glossary	
						SET  @V_NEXT_UNIQUE_ID = @V_NEXT_UNIQUE_ID +  1 ; 
						SET	 @N_SQL = 'UPDATE ' + @V_DBNAME +  ' GLOSSARY  SET NEXT_UNIQUE_ID = @V_NEXT_UNIQUE_ID_P ' ;
						SET	 @N_SQL = @N_SQL + ' WHERE SYSTEM_TABLE_NAME = ''EVENT''' ;									
						--BEGIN TRY
						SET @V_ERROR_LOCATION = 'I9' ;
						Exec sp_Executesql @N_SQL, 
							 N' @V_NEXT_UNIQUE_ID_P varchar(255)',
							 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID ;		
						--END TRY
						--BEGIN CATCH	
						--				 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--				 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--						@p_MODULE_NAME = @V_MODULENAME ,
						--						@p_CALLING_ERROR_LOCATION = 'Main', 
						--						@p_CURRENT_ERROR_LOCATION = 'UPDTNXTUEV', 
						--						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--						@p_ERROR_COLUMNS = NULL , 
						--						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--						@P_IS_VALIDATION = 0 ; 	
						--						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						--		END CATCH		
							 SET @V_ERROR_LOCATION = 'I10' ;
		END												
		


		--SET @i_EVENT_ID = 291 --SAM
		--set @I_UPDATE_FLAG_EVENT = 1 --sam
	ELSE IF ((@I_UPDATE_FLAG_EVENT = 1)) 
		BEGIN 
		IF @v_EVENT_DESCRIPTION LIKE'%''''%' OR @v_BRIEF_DESCRIPTION LIKE'%''''%' OR @v_ADDR1 LIKE'%''''%'OR @v_ADDR2 LIKE'%''''%'OR @v_LOCATION_AREA_DESC LIKE'%''''%' OR @v_COMMENTS LIKE'%''''%'    --ddhupar JIRA 78172 starts
				BEGIN 
				SET @v_EVENT_DESCRIPTION = REPLACE(@v_EVENT_DESCRIPTION,'''''','''')
				SET @v_BRIEF_DESCRIPTION = REPLACE(@v_BRIEF_DESCRIPTION,'''''','''') 
				SET @v_ADDR1 = REPLACE(@v_ADDR1,'''''','''') 
				SET @v_ADDR2 = REPLACE(@v_ADDR2,'''''','''') 
				SET @v_LOCATION_AREA_DESC = REPLACE(@v_LOCATION_AREA_DESC,'''''','''') 
				SET @v_COMMENTS = REPLACE(@v_COMMENTS,'''''','''')  
				END			                                              --ddhupar JIRA 78172 ends
								SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' EVENT SET  EVENT_ID = @I_EVENT_ID_P ' ;			--JIRA RMA - 20453			
								IF @V_COUNTY_OF_INJURY IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',COUNTY_OF_INJURY = @V_COUNTY_OF_INJURY_P'	
								IF @v_EVENT_NUMBER IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',EVENT_NUMBER = @v_EVENT_NUMBER_P'	
								IF @EVENT_TYPE_CODE_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',EVENT_TYPE_CODE = @v_EVENT_TYPE_CODE_P'	
								IF @EVENT_STATUS_CODE_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',EVENT_STATUS_CODE = @v_EVENT_STATUS_CODE_P'	
								IF 	@EVENT_IND_CODE_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',EVENT_IND_CODE = @V_EVENT_IND_CODE_P'	
								IF @v_EVENT_DESCRIPTION IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',EVENT_DESCRIPTION = @v_EVENT_DESCRIPTION_P'	
								IF @v_BRIEF_DESCRIPTION IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',BRIEF_DESC = @v_BRIEF_DESCRIPTION_P'	
								IF @i_DEPARTMENT_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DEPT_EID = @v_DEPARTMENT_P'	
								IF @i_DEPT_INVOLVED_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DEPT_INVOLVED_EID = @v_DEPT_INVOLVED_P '				
								IF @v_ADDR1 IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',ADDR1 = @v_ADDR1_P'	
								IF @v_ADDR2 IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',ADDR2 = @v_ADDR2_P'	
								IF @v_CITY IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',CITY = @v_CITY_P'	
								IF @v_STATE IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',STATE_ID = @v_STATE_P'	
								IF 	@v_ZIP_CODE IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',ZIP_CODE = @v_ZIP_CODE_P'	
								IF @COUNTRY_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',COUNTRY_CODE = @V_COUNTRY_P'	
								IF @v_LOCATION_AREA_DESC IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',LOCATION_AREA_DESC = @v_LOCATION_AREA_DESC_P'	
								IF @PRIMARY_LOC_CODE_R	 IS NOT NULL 
								SET	 @N_SQL = @N_SQL + ',PRIMARY_LOC_CODE = @v_PRIMARY_LOC_CODE_P '	
								IF @LOCATION_TYPE_CODE_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',LOCATION_TYPE_CODE = @v_LOCATION_TYPE_CODE_P'			
								IF @I_ON_PREMISE_FLAG_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',ON_PREMISE_FLAG = @v_ON_PREMISE_FLAG_P'	
								IF 	@v_NO_OF_INJURIES IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',NO_OF_INJURIES = @v_NO_OF_INJURIES_P'	
								IF @v_NO_OF_FATALITIES IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',NO_OF_FATALITIES = @v_NO_OF_FATALITIES_P'	
								IF @CAUSE_CODE_R IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',CAUSE_CODE = @v_CAUSE_CODE_P'	
								IF @v_DATE_OF_EVENT	 IS NOT NULL 
								SET	 @N_SQL = @N_SQL + ',DATE_OF_EVENT = @v_DATE_OF_EVENT_P'	
								IF @v_TIME_OF_EVENT IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',TIME_OF_EVENT = @v_TIME_OF_EVENT_P'
								IF @v_DATE_REPORTED IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DATE_REPORTED = @v_DATE_REPORTED_P'	
								IF 	@v_TIME_REPORTED IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',TIME_REPORTED = @v_TIME_REPORTED_P'
								IF @i_Reporter_ENTITY_ID_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',RPTD_BY_EID = @V_RPTD_BY_EID_P'	
								IF @v_DATE_TO_FOLLOW_UP IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DATE_TO_FOLLOW_UP = @v_DATE_TO_FOLLOW_UP_P'	
								IF @v_COMMENTS	 IS NOT NULL 
								SET	 @N_SQL = @N_SQL + ',COMMENTS = @v_COMMENTS_P'	
								IF @v_DATE_PHYS_ADVISED IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DATE_PHYS_ADVISED = @v_DATE_PHYS_ADVISED_P'	
								IF @v_TIME_PHYS_ADVISED IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',TIME_PHYS_ADVISED = @v_TIME_PHYS_ADVISED_P'	
								IF 	@I_TREATMENT_GIVEN_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',TREATMENT_GIVEN = @v_TREATMENT_GIVEN_P'	
								IF @I_RELEASE_SIGNED_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',RELEASE_SIGNED = @v_RELEASE_SIGNED_P'	
								IF @I_DEPT_HEAD_ADVISED_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DEPT_HEAD_ADVISED = @v_DEPT_HEAD_ADVISED_P'	
								IF @v_PHYS_NOTES	 IS NOT NULL 
								SET	 @N_SQL = @N_SQL + ',PHYS_NOTES = @v_PHYS_NOTES_P'	
								IF @v_DATE_CARRIER_NOTIF IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DATE_CARRIER_NOTIF = @v_DATE_CARRIER_NOTIF_P'	
								IF @V_DTTM_RCD_LAST_UPD_GEN IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',DTTM_RCD_LAST_UPD = @V_DTTM_RCD_LAST_UPD_P'	
								IF @V_UPDATED_BY_USER IS NOT NULL 
								SET	 @N_SQL = @N_SQL + ',UPDATED_BY_USER = @V_UPDATED_BY_USER_P'	
							--	IF @V_SEC_DEPT_EID IS NOT NULL						
							--	SET	 @N_SQL = @N_SQL + 'SEC_DEPT_EID = @V_SEC_DEPT_EID_P,'	
								
								SET	 @N_SQL = @N_SQL + ' WHERE EVENT_ID = @I_EVENT_ID_P' ;	
								--BEGIN TRY
								 SET @V_ERROR_LOCATION = 'I11' ;
								Exec sp_Executesql @N_SQL ,
											N'@V_COUNTY_OF_INJURY_P	varchar(50) ,
											@I_EVENT_ID_P INT ,
											@v_EVENT_NUMBER_P varchar(25),
											@v_EVENT_TYPE_CODE_P	INT,
											@v_EVENT_STATUS_CODE_P	INT,
											@v_EVENT_IND_CODE_P	INT,
											@v_EVENT_DESCRIPTION_P	varchar(max),
											@v_BRIEF_DESCRIPTION_P	varchar(250),
											@v_DEPARTMENT_P	INT,
											@v_DEPT_INVOLVED_P	INT,
											@v_ADDR1_P	varchar(100),
											@v_ADDR2_P	varchar(100),
											@v_CITY_P	varchar(50),
											@v_STATE_P	INT,
											@v_ZIP_CODE_P	varchar(10),
											@V_COUNTRY_P	INT,
											@v_LOCATION_AREA_DESC_P	varchar(max),
											@v_PRIMARY_LOC_CODE_P	INT,
											@v_LOCATION_TYPE_CODE_P	INT,
											@v_ON_PREMISE_FLAG_P	INT,
											@v_NO_OF_INJURIES_P	int,
											@v_NO_OF_FATALITIES_P	int,
											@v_CAUSE_CODE_P	INT,
											@v_DATE_OF_EVENT_P	varchar(8),
											@v_TIME_OF_EVENT_P	varchar(6),
											@v_DATE_REPORTED_P	varchar(8),
											@v_TIME_REPORTED_P	varchar(6),
											@V_RPTD_BY_EID_P INT ,
											@v_DATE_TO_FOLLOW_UP_P	varchar(8),
											@v_COMMENTS_P	varchar(max),
											@v_DATE_PHYS_ADVISED_P	varchar(8), 
											@v_TIME_PHYS_ADVISED_P	varchar(8),
											@v_TREATMENT_GIVEN_P 	INT,
											@v_RELEASE_SIGNED_P 	INT,
											@v_DEPT_HEAD_ADVISED_P 	INT,
											@v_PHYS_NOTES_P	varchar(max),
											@v_DATE_CARRIER_NOTIF_P	varchar(8),
											@V_DTTM_RCD_LAST_UPD_P varchar(255) ,
											@V_UPDATED_BY_USER_P varchar(255)',
											--@V_SEC_DEPT_EID_P INT ',							
											@V_COUNTY_OF_INJURY_P = @V_COUNTY_OF_INJURY	 ,
											@I_EVENT_ID_P  = @i_EVENT_ID ,
											@v_EVENT_NUMBER_P  = @v_EVENT_NUMBER ,
											@v_EVENT_TYPE_CODE_P = @EVENT_TYPE_CODE_R	,
											@v_EVENT_STATUS_CODE_P	=  @EVENT_STATUS_CODE_R ,
											@v_EVENT_IND_CODE_P	= @EVENT_IND_CODE_R ,
											@v_EVENT_DESCRIPTION_P = @v_EVENT_DESCRIPTION	,
											@v_BRIEF_DESCRIPTION_P = @v_BRIEF_DESCRIPTION	,
											@v_DEPARTMENT_P	=  @i_DEPARTMENT_GEN  ,
											@v_DEPT_INVOLVED_P =  @i_DEPT_INVOLVED_GEN  	,
											@v_ADDR1_P = @v_ADDR1	,
											@v_ADDR2_P = @v_ADDR2	,
											@v_CITY_P = @v_CITY	,
											@v_STATE_P = @v_STATE_R	,
											@v_ZIP_CODE_P = @v_ZIP_CODE	,
											@V_COUNTRY_P = @COUNTRY_R,
											@v_LOCATION_AREA_DESC_P = @v_LOCATION_AREA_DESC	,
											@v_PRIMARY_LOC_CODE_P = @PRIMARY_LOC_CODE_R	,
											@v_LOCATION_TYPE_CODE_P = @LOCATION_TYPE_CODE_R	,
											@v_ON_PREMISE_FLAG_P = @I_ON_PREMISE_FLAG_GEN	,
											@v_NO_OF_INJURIES_P	= @v_NO_OF_INJURIES ,
											@v_NO_OF_FATALITIES_P = @v_NO_OF_FATALITIES	,
											@v_CAUSE_CODE_P	= @CAUSE_CODE_R ,
											@v_DATE_OF_EVENT_P = @v_DATE_OF_EVENT	,
											@v_TIME_OF_EVENT_P	= @v_TIME_OF_EVENT ,
											@v_DATE_REPORTED_P = @v_DATE_REPORTED	,
											@v_TIME_REPORTED_P = @v_TIME_REPORTED,
											@V_RPTD_BY_EID_P = @i_Reporter_ENTITY_ID_GEN ,
											@v_DATE_TO_FOLLOW_UP_P	= @v_DATE_TO_FOLLOW_UP ,
											@v_COMMENTS_P = @v_COMMENTS	,
											@v_DATE_PHYS_ADVISED_P = @v_DATE_PHYS_ADVISED, 
											@v_TIME_PHYS_ADVISED_P = @v_TIME_PHYS_ADVISED,
											@v_TREATMENT_GIVEN_P = @I_TREATMENT_GIVEN_GEN 	,
											@v_RELEASE_SIGNED_P = @I_RELEASE_SIGNED_GEN	,
											@v_DEPT_HEAD_ADVISED_P = 	@I_DEPT_HEAD_ADVISED_GEN 	,
											@v_PHYS_NOTES_P = @v_PHYS_NOTES	,
											@v_DATE_CARRIER_NOTIF_P = @v_DATE_CARRIER_NOTIF	,
											@V_DTTM_RCD_LAST_UPD_P = @V_DTTM_RCD_LAST_UPD_GEN  ,
											@V_UPDATED_BY_USER_P = @V_UPDATED_BY_USER ;
											--@V_SEC_DEPT_EID_P  = @V_SEC_DEPT_EID ;
	
								--END TRY
								--BEGIN CATCH	
								--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--				@p_MODULE_NAME = @V_MODULENAME ,
								--				@p_CALLING_ERROR_LOCATION = 'Main', 
								--				@p_CURRENT_ERROR_LOCATION = 'UPDTEVNT', 
								--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--				@p_ERROR_COLUMNS = NULL , 
								--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--				@P_IS_VALIDATION = 0 ; 
								--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
								--END CATCH		
								 SET @V_ERROR_LOCATION = 'I12' ;			
					
				END														-- EI5. UPDATE OF EVENT RECORDS 		 
		
		
		--set @i_Reporter_ENTITY_ID_GEN = 7 --sam
		IF  ( (@i_Reporter_ENTITY_ID_GEN > 0) )											-- EI6. UPDATE REPORTER ENTITY IN ENTITY TABLE
		BEGIN			--below select query might not be required as if @i_Reporter_ENTITY_ID_GEN > 0, entity is already existing)
						 --SET @i_ENTITY_ID = 0 ;
						 --SET @N_SQL =  'SELECT @i_ENTITY_ID_OP =  ENTITY_ID FROM ' +  @V_DBName  + ' ENTITY  ';
						 --SET @N_SQL =	@N_SQL +  ' WHERE ENTITY_ID = @i_ENTITY_ID_P ' 
						 --BEGIN TRY
						 --Exec sp_Executesql @N_SQL , 
						 --N'@i_ENTITY_ID_P INT ,
						 --@i_ENTITY_ID_OP INT OUTPUT',						
						 --@i_ENTITY_ID_P  = @i_Reporter_ENTITY_ID_GEN ,
						 --@i_ENTITY_ID_OP = @i_ENTITY_ID OUTPUT ;
						 --END TRY
						 --BEGIN CATCH	
						 --SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						 --EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--	@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--	@p_MODULE_NAME = @V_MODULENAME ,
							--	@p_CALLING_ERROR_LOCATION = 'Main', 
							--	@p_CURRENT_ERROR_LOCATION = 'REPORTINS1', 
							--	@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--	@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--	@p_ERROR_COLUMNS = NULL , 
							--	@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--	@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--	@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--	@P_IS_VALIDATION = 0 ; 	
							--	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						 --END CATCH
						
							--IF (@i_ENTITY_ID > 0)
								BEGIN --  UPDATE REPORTER ENTITY IN ENTITY TABLE
			IF @v_REPORTED_LAST_NAME LIKE'%''''%' OR @v_REPORTED_FIRST_NAME LIKE'%''''%' OR @v_REPORTED_ADDR1 LIKE'%''''%' OR @v_REPORTED_ADDR2 LIKE'%''''%'    --ddhupar JIRA 78172 starts
				BEGIN 
				SET @v_REPORTED_LAST_NAME = REPLACE(@v_REPORTED_LAST_NAME,'''''','''')
				SET @v_REPORTED_FIRST_NAME = REPLACE(@v_REPORTED_FIRST_NAME,'''''','''') 
				SET @v_REPORTED_ADDR1 = REPLACE(@v_REPORTED_ADDR1,'''''','''')
				SET @v_REPORTED_ADDR2 = REPLACE(@v_REPORTED_ADDR2,'''''','''')  
				END      --ddhupar JIRA 78172 end
							
								SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' ENTITY SET  ENTITY_ID = @i_Reporter_ENTITY_ID_GEN_P ' ; 	--JIRA RMA - 20453						
								IF @v_REPORTED_TAX_ID IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',TAX_ID = @v_REPORTED_TAX_ID_P'	
								IF @v_REPORTED_LAST_NAME IS NOT NULL						
								SET	 @N_SQL = @N_SQL + ',LAST_NAME = @v_REPORTED_LAST_NAME_P'
								IF @v_REPORTED_FIRST_NAME IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',FIRST_NAME = @v_REPORTED_FIRST_NAME_P'
								IF @v_REPORTED_ADDR1 IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',ADDR1 = @v_REPORTED_ADDR1_P'
								IF @v_REPORTED_ADDR2 IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',ADDR2 = @v_REPORTED_ADDR2_P'
								IF @v_REPORTED_CITY IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',CITY = @v_REPORTED_CITY_P'
								IF @v_REPORTED_STATE IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',STATE_ID = @v_REPORTED_STATE_P'
								IF @v_REPORTED_ZIP_CODE IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',ZIP_CODE = @v_REPORTED_ZIP_CODE_P'
								IF @v_REPORTED_PHONE IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',PHONE1 = @v_REPORTED_PHONE_P'
								IF @v_REPORTED_COUNTRY IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',COUNTRY_CODE = @v_REPORTED_COUNTRY_P'
								IF @v_REPORTED_PHONE2 IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',PHONE2 = @v_REPORTED_PHONE2_P'
								IF @v_REPORTED_FAX IS NOT NULL
								SET	 @N_SQL = @N_SQL + ',FAX_NUMBER = @v_REPORTED_FAX_P'												
							
								SET	 @N_SQL = @N_SQL + ' WHERE  ENTITY_ID = @i_Reporter_ENTITY_ID_GEN_P' ;	

								IF (@v_REPORTED_TAX_ID <> 0 AND @v_REPORTED_TAX_ID IS NOT NULL)
									BEGIN
										EXECUTE DDS_SSN_IMPORT @v_REPORTED_TAX_ID OUTPUT, @v_REPORTED_STATE_R, @V_DBNAME --asharma590 jira 77663
									END
										--BEGIN TRY							
										Exec sp_Executesql @N_SQL, 
									 N'	@v_REPORTED_TAX_ID_P	VARCHAR (20),
										@v_REPORTED_LAST_NAME_P	varchar(255),
										@v_REPORTED_FIRST_NAME_P	varchar(255),
										@v_REPORTED_ADDR1_P	varchar(100),
										@v_REPORTED_ADDR2_P	varchar(100),
										@v_REPORTED_CITY_P	varchar(50),
										@v_REPORTED_STATE_P	varchar(4),
										@v_REPORTED_ZIP_CODE_P	varchar(10),
										@v_REPORTED_PHONE_P	varchar(30),
										@v_REPORTED_COUNTRY_P	varchar(255),
										@v_REPORTED_PHONE2_P	varchar(255),
										@v_REPORTED_FAX_P	varchar(255),
										@i_Reporter_ENTITY_ID_GEN_P INT  ',
										@v_REPORTED_TAX_ID_P	= @v_REPORTED_TAX_ID,
										@v_REPORTED_LAST_NAME_P	= @v_REPORTED_LAST_NAME,
										@v_REPORTED_FIRST_NAME_P = @v_REPORTED_FIRST_NAME,
										@v_REPORTED_ADDR1_P	= @v_REPORTED_ADDR1,
										@v_REPORTED_ADDR2_P	= @v_REPORTED_ADDR2 ,
										@v_REPORTED_CITY_P	= @v_REPORTED_CITY,
										@v_REPORTED_STATE_P	= @v_REPORTED_STATE_R ,
										@v_REPORTED_ZIP_CODE_P	=	@v_REPORTED_ZIP_CODE ,
										@v_REPORTED_PHONE_P	= @v_REPORTED_PHONE ,
										@v_REPORTED_COUNTRY_P = @REPORTED_COUNTRY_R ,	
										@v_REPORTED_PHONE2_P	 = @v_REPORTED_PHONE2,
										@v_REPORTED_FAX_P	= @v_REPORTED_FAX ,
										@i_Reporter_ENTITY_ID_GEN_P = @i_Reporter_ENTITY_ID_GEN ; 
										--END TRY								
										--BEGIN CATCH	
										-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--		@p_MODULE_NAME = @V_MODULENAME ,
										--		@p_CALLING_ERROR_LOCATION = 'Main', 
										--		@p_CURRENT_ERROR_LOCATION = 'REPORTins2', 
										--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--		@p_ERROR_COLUMNS = NULL , 
										--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--		@P_IS_VALIDATION = 0 ; 
										--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
										--END CATCH
										 SET @V_ERROR_LOCATION = 'I13' ;
								
		END
							--PRINT 'RPORTER SQL ' + @N_SQL 
		END
	



		BEGIN		-- EI7. ACTION / OUTCOME EXISTENCE IN RMDB																										   
		SET @vColList = 'ACTION|OUTCOME|'
		SET @vTableList = 'EVENT_X_ACTION|EVENT_X_OUTCOME|'

		WHILE CHARINDEX('|',@vColList,1) > 0				--
		BEGIN
			
			SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
			SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
			SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
			SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))
			SET @iCount = 1
			WHILE @iCount <= 5
			BEGIN	
				SET @vColToProcess = @vColName + '_' + CAST(@iCount as VARCHAR) + '_CODE'
								 
				SET @vVal = (CASE
				WHEN @vColToProcess = 'ACTION_1_CODE' THEN @ACTION_1_CODE_R
				WHEN @vColToProcess = 'ACTION_2_CODE' THEN @ACTION_2_CODE_R		
				WHEN @vColToProcess = 'ACTION_3_CODE' THEN @ACTION_3_CODE_R
				WHEN @vColToProcess = 'ACTION_4_CODE' THEN @ACTION_4_CODE_R		
				WHEN @vColToProcess = 'ACTION_5_CODE' THEN @ACTION_5_CODE_R
				WHEN @vColToProcess = 'OUTCOME_1_CODE' THEN @OUTCOME_1_CODE_R
				WHEN @vColToProcess = 'OUTCOME_2_CODE' THEN @OUTCOME_2_CODE_R
				WHEN @vColToProcess = 'OUTCOME_3_CODE' THEN @OUTCOME_3_CODE_R
				WHEN @vColToProcess = 'OUTCOME_4_CODE' THEN @OUTCOME_4_CODE_R
				WHEN @vColToProcess = 'OUTCOME_5_CODE' THEN @OUTCOME_5_CODE_R
				END)

	IF (@vVal IS NOT NULL AND @vVal <> 0 )	
		BEGIN	
				--PRINT 'ACT/OIUT ENETERD IF'
				SET @i_EVENT_ID_O =  0 
				SET @vColInRM = @vColName +  '_CODE'				
				SET @N_SQL = 'SELECT @EVENT_ID_OP = EVENT_ID  FROM '+ @V_DBName + @vTableName ;
				SET @N_SQL = @N_SQL + ' WHERE EVENT_ID  = @EVENT_ID_P AND '  + @vColInRM + ' = @vVal_P ' ;
				 SET @V_ERROR_LOCATION = 'I14' ;
				--BEGIN TRY
				Exec sp_Executesql @N_SQL,
								N' @EVENT_ID_P INT ,
								@EVENT_ID_OP INT OUTPUT ,
								@vVal_P INT ',														
								@EVENT_ID_P = @i_EVENT_ID  ,
								@EVENT_ID_OP = @i_EVENT_ID_O OUTPUT ,
								@vVal_P = @vVal ;		
								
				--END TRY
				--BEGIN CATCH	
				--						 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				--						 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				--								@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				--								@p_MODULE_NAME = @V_MODULENAME ,
				--								@p_CALLING_ERROR_LOCATION = 'Main', 
				--								@p_CURRENT_ERROR_LOCATION = 'ACT/OUT1E', 
				--								@p_ERROR_PROC_NAME = @V_PROCNAME ,
				--								@p_ERROR_MSG = @V_ERROR_MESSAGE ,
				--								@p_ERROR_COLUMNS = NULL , 
				--								@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
				--								@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				--								@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				--								@P_IS_VALIDATION = 0 ;
				--								SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
				--				END CATCH
			
				IF @i_EVENT_ID_O = 0
				BEGIN  
				 SET @V_ERROR_LOCATION = 'I14' ;
						SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME + @vTableName + ' (EVENT_ID,' + @vColInRM + ') VALUES ( ' + CAST(@i_EVENT_ID AS VARCHAR) + ',' ;
						SET @N_SQL_EVENT = @N_SQL_EVENT	  + CAST(@vVal AS VARCHAR ) + ')' ;
							--BEGIN TRY
							Exec sp_Executesql @N_SQL_EVENT ;
							--END TRY
							--BE-GIN CATCH	
							--			 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--			 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--					@p_MODULE_NAME = @V_MODULENAME ,
							--					@p_CALLING_ERROR_LOCATION = 'Main', 
							--					@p_CURRENT_ERROR_LOCATION = 'ACT/OUT2E', 
							--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--					@p_ERROR_COLUMNS = NULL , 
							--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--					@P_IS_VALIDATION = 0 ; 		
							--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		 
							--END CATCH
							 SET @V_ERROR_LOCATION = 'I15' ;
				END		
				
		END
						SET @iCount = @iCount + 1
				
				
			END
		END
		END	
		
		
		
		
		--PRINT '@i_EVENT_ID OSHA/INDI ' + CAST (@i_EVENT_ID AS VARCHAR )
		BEGIN		-- EI8. EVENT_X_OSHA|FALL_INDICATOR EXISTENCE IN RMDB	
		 SET @vTableList = 'EVENT_X_OSHA|FALL_INDICATOR|'	--TT
		 WHILE CHARINDEX('|',@vTableList,1) > 0
			BEGIN	
					--PRINT 'OSHA/INDCNT'
					SET @i_EVENT_ID_O = 0 ;
					SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
					SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))				
						BEGIN
							--PRINT '@vTableName : '	 + @vTableName ;
							 SET @V_ERROR_LOCATION = 'I16' ;
							SET @N_SQL = 'SELECT @EVENT_ID_OP = EVENT_ID  FROM '+ @V_DBName + @vTableName ;
							SET @N_SQL = @N_SQL + ' WHERE EVENT_ID  = @EVENT_ID_P   ' ;
								--BEGIN TRY
								Exec sp_Executesql @N_SQL,
									 N'@EVENT_ID_P INT ,
									 @EVENT_ID_OP INT OUTPUT',											
									 @EVENT_ID_P = @i_EVENT_ID ,								
									 @EVENT_ID_OP = @i_EVENT_ID_O OUTPUT ;	
								--END TRY
								--BEGIN CATCH	
								--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--				@p_MODULE_NAME = @V_MODULENAME ,
								--				@p_CALLING_ERROR_LOCATION = 'Main', 
								--				@p_CURRENT_ERROR_LOCATION = 'OSHA/IND1', 
								--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--				@p_ERROR_COLUMNS = NULL , 
								--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--				@P_IS_VALIDATION = 0 ;
								--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
								--END CATCH
							--print '@i_EVENT_ID_O OSHA/INDI : ' + cast ( @i_EVENT_ID_O as varchar)
							 SET @V_ERROR_LOCATION = 'I17' ;

								IF @i_EVENT_ID_O = 0  AND @vTableName = 'EVENT_X_OSHA'		
									BEGIN		
										 SET @V_ERROR_LOCATION = 'I18' ;
										SET @N_SQL_EVENT = 'INSERT INTO '+ @V_DBNAME + ' EVENT_X_OSHA (ACTIVITY_WHEN_INJ,EVENT_ID,HOW_ACC_OCCURRED,NO_RULES_FLAG,';
										SET @N_SQL_EVENT =	@N_SQL_EVENT + 'OBJ_SUBST_THAT_INJ,RECORDABLE_FLAG,SAFEG_NOTUSED_FLAG,SAFEGUARD_FLAG,PRIVACY_CASE_FLAG,';
										SET @N_SQL_EVENT =	@N_SQL_EVENT + 'SHARPS_OBJECT,SHARPS_BRAND_MAKE,SAFEG_PROVIDED,RULES_NOT_FOLLOWED,OSHA_ESTAB_EID)';
										SET @N_SQL_EVENT =	@N_SQL_EVENT + 'VALUES (  @v_ACTIVITY_WHEN_INJ_P	,  @V_EVENT_ID_P , @v_HOW_ACC_OCCURRED_P	, @v_NO_RULES_FLAG_P	, @v_OBJ_SUBST_THAT_INJ_P , @v_RECORDABLE_FLAG_P	, @v_SAFEG_NOTUSED_FLAG_P	, @v_SAFEGUARD_FLAG_P	,'
										SET @N_SQL_EVENT =	@N_SQL_EVENT + '@v_PRIVACY_CASE_FLAG_P	, @v_SHARPS_OBJECT_P	, @v_SHARPS_BRAND_MAKE_P	, @v_SAFEG_PROVIDED_P	, @v_RULES_NOT_FOLLOWED_P , @v_OSHA_ESTAB_EID_P )	'
											--BEGIN TRY
											Exec sp_Executesql @N_SQL_EVENT ,
												 N' @v_ACTIVITY_WHEN_INJ_P	varchar(255),
												 @v_HOW_ACC_OCCURRED_P	varchar(255),
												 @v_NO_RULES_FLAG_P	INT ,
												 @v_OBJ_SUBST_THAT_INJ_P	varchar(255),
												 @v_RECORDABLE_FLAG_P	INT ,
												 @v_SAFEG_NOTUSED_FLAG_P	INT,
												 @v_SAFEGUARD_FLAG_P	INT,
												 @v_PRIVACY_CASE_FLAG_P	INT,
												 @v_SHARPS_OBJECT_P	INT,
												 @v_SHARPS_BRAND_MAKE_P	INT,
												 @v_SAFEG_PROVIDED_P	INT ,
												 @v_RULES_NOT_FOLLOWED_P	INT,
												 @v_OSHA_ESTAB_EID_P	INT,
												 @V_EVENT_ID_P INT',			
												 @v_ACTIVITY_WHEN_INJ_P = @v_ACTIVITY_WHEN_INJ	,
												 @v_HOW_ACC_OCCURRED_P = @v_HOW_ACC_OCCURRED	,
												 @v_NO_RULES_FLAG_P = @I_NO_RULES_FLAG_GEN	, 
												 @v_OBJ_SUBST_THAT_INJ_P =  @v_OBJ_SUBST_THAT_INJ , 
												 @v_RECORDABLE_FLAG_P = @I_RECORDABLE_FLAG_GEN 	, 
												 @v_SAFEG_NOTUSED_FLAG_P = @I_SAFEG_NOTUSED_GEN	, 
												 @v_SAFEGUARD_FLAG_P = @I_SAFEGUARD_FLAG_GEN	,
												 @v_PRIVACY_CASE_FLAG_P	 = @I_PRIVACY_CASE_GEN , 
												 @v_SHARPS_OBJECT_P	 = @SHARPS_OBJECT_R , 
												 @v_SHARPS_BRAND_MAKE_P =  @SHARPS_BRAND_MAKE_R	, 
												 @v_SAFEG_PROVIDED_P = @SAFEG_PROVIDED_R	, 
												 @v_RULES_NOT_FOLLOWED_P = @RULES_NOT_FOLLOWED_R,							
												 @v_OSHA_ESTAB_EID_P 	= @I_OSHA_ESTAB_EID_GEN,
												 @V_EVENT_ID_P = @i_EVENT_ID  ;
											--END TRY
											--BEGIN CATCH	
											-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
											-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											--		@p_MODULE_NAME = @V_MODULENAME ,
											--		@p_CALLING_ERROR_LOCATION = 'Main', 
											--		@p_CURRENT_ERROR_LOCATION = 'OSHA2', 
											--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
											--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											--		@p_ERROR_COLUMNS = NULL , 
											--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											--		@P_IS_VALIDATION = 0 ; 
											--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
											--END CATCH
								--PRINT '@N_SQL_EVENT : OSHA ' + @N_SQL_EVENT
									 SET @V_ERROR_LOCATION = 'I19' ;
									END		--COLUMNS NOT FOUND BUT IN RMDB SAFEG_NOTUSED			
								
								
								IF @i_EVENT_ID_O > 0  AND @vTableName = 'EVENT_X_OSHA'		
									BEGIN	
										 SET @V_ERROR_LOCATION = 'I20' ;
										SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' EVENT_X_OSHA SET EVENT_ID = @V_EVENT_ID_P ' ; 	--JIRA RMA - 20453						
										IF @v_ACTIVITY_WHEN_INJ IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',ACTIVITY_WHEN_INJ = @v_ACTIVITY_WHEN_INJ_P'	
										IF @v_HOW_ACC_OCCURRED IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',HOW_ACC_OCCURRED = @v_HOW_ACC_OCCURRED_P'	
										IF @I_NO_RULES_FLAG_GEN IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',NO_RULES_FLAG = @v_NO_RULES_FLAG_P'	
										IF @v_OBJ_SUBST_THAT_INJ IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',OBJ_SUBST_THAT_INJ = @v_OBJ_SUBST_THAT_INJ_P'	
										IF 	@I_RECORDABLE_FLAG_GEN  IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',RECORDABLE_FLAG = @v_RECORDABLE_FLAG_P'
										IF @I_SAFEG_NOTUSED_GEN IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',SAFEG_NOTUSED_FLAG = @v_SAFEG_NOTUSED_FLAG_P'	
										IF @I_SAFEGUARD_FLAG_GEN IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',SAFEGUARD_FLAG = @v_SAFEGUARD_FLAG_P '	
										IF @I_PRIVACY_CASE_GEN IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',PRIVACY_CASE_FLAG = @v_PRIVACY_CASE_FLAG_P'	
										IF @v_SHARPS_OBJECT IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',SHARPS_OBJECT = @v_SHARPS_OBJECT_P'	
										IF 	@v_SHARPS_BRAND_MAKE  IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',SHARPS_BRAND_MAKE = @v_SHARPS_BRAND_MAKE_P'						
										IF @v_SAFEG_PROVIDED IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',SAFEG_PROVIDED = @v_SAFEG_PROVIDED_P '	
										IF 	@v_RULES_NOT_FOLLOWED  IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',RULES_NOT_FOLLOWED = @v_RULES_NOT_FOLLOWED_P'	
										IF 	@I_OSHA_ESTAB_EID_GEN  IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',OSHA_ESTAB_EID = @v_OSHA_ESTAB_EID_P'							
										
										SET	 @N_SQL = @N_SQL + ' WHERE EVENT_ID = @V_EVENT_ID_P ' ;	
												--BEGIN TRY
												Exec sp_Executesql @N_SQL ,
													 N' @v_ACTIVITY_WHEN_INJ_P	varchar(255),
													 @v_HOW_ACC_OCCURRED_P	varchar(255),
													 @v_NO_RULES_FLAG_P	INT ,
													 @v_OBJ_SUBST_THAT_INJ_P	varchar(255),
													 @v_RECORDABLE_FLAG_P	INT ,
													 @v_SAFEG_NOTUSED_FLAG_P	INT ,
													 @v_SAFEGUARD_FLAG_P	INT,
													 @v_PRIVACY_CASE_FLAG_P	INT ,
													 @v_SHARPS_OBJECT_P	INT ,
													 @v_SHARPS_BRAND_MAKE_P	INT ,
													 @v_SAFEG_PROVIDED_P	INT ,
													 @v_RULES_NOT_FOLLOWED_P	INT,
													 @v_OSHA_ESTAB_EID_P	INT ,
													 @V_EVENT_ID_P INT',			
													 @v_ACTIVITY_WHEN_INJ_P = @v_ACTIVITY_WHEN_INJ	,
													 @v_HOW_ACC_OCCURRED_P = @v_HOW_ACC_OCCURRED	,
													 @v_NO_RULES_FLAG_P = @I_NO_RULES_FLAG_GEN	, 
													 @v_OBJ_SUBST_THAT_INJ_P =  @v_OBJ_SUBST_THAT_INJ , 
													 @v_RECORDABLE_FLAG_P = @I_RECORDABLE_FLAG_GEN 	, 
													 @v_SAFEG_NOTUSED_FLAG_P = @I_SAFEG_NOTUSED_GEN	, 
													 @v_SAFEGUARD_FLAG_P = @I_SAFEGUARD_FLAG_GEN	,
													 @v_PRIVACY_CASE_FLAG_P	 = @I_PRIVACY_CASE_GEN , 
													 @v_SHARPS_OBJECT_P	 = @SHARPS_OBJECT_R , 
													 @v_SHARPS_BRAND_MAKE_P =  @SHARPS_BRAND_MAKE_R	, 
													 @v_SAFEG_PROVIDED_P = @SAFEG_PROVIDED_R	, 
													 @v_RULES_NOT_FOLLOWED_P = @RULES_NOT_FOLLOWED_R,							
													 @v_OSHA_ESTAB_EID_P 	= @I_OSHA_ESTAB_EID_GEN,
													 @V_EVENT_ID_P = @i_EVENT_ID  ;
												--END TRY
												--BEGIN CATCH	
												--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
												--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
												--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
												--				@p_MODULE_NAME = @V_MODULENAME ,
												--				@p_CALLING_ERROR_LOCATION = 'Main', 
												--				@p_CURRENT_ERROR_LOCATION = 'OSHA3', 
												--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
												--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
												--				@p_ERROR_COLUMNS = NULL , 
												--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
												--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
												--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
												--				@P_IS_VALIDATION = 0 ; 
												--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
												--END CATCH
										--PRINT 'OSHA UPD SQL' + @N_SQL 
											 SET @V_ERROR_LOCATION = 'I21' ;
										END		--COLUMNS NOT FOUND BUT IN RMDB SAFEG_NOTUSED	
								
								IF @i_EVENT_ID_O = 0 AND @vTableName = 'FALL_INDICATOR'		
									BEGIN	
										 SET @V_ERROR_LOCATION = 'I22' ;
									SET @N_SQL_EVENT = 'INSERT INTO '+ @V_DBNAME + ' FALL_INDICATOR ( EVENT_ID,COND_PRIOR_CODE,RAIL_POSITION_CODE,RESTRAINT_CODE,';
									SET @N_SQL_EVENT =	@N_SQL_EVENT + 'BED_POSITION_CODE,CALL_LIGHT_CODE )';				
									SET @N_SQL_EVENT =	@N_SQL_EVENT + 'VALUES( @V_EVENT_ID_P , @v_COND_PRIOR_CODE_P ,' 
									SET @N_SQL_EVENT =	@N_SQL_EVENT + ' @v_RAIL_POSITION_CODE_P , @v_RESTRAINT_CODE_P , @v_BED_POSITION_CODE_P , @v_CALL_LIGHT_CODE_P )'
									--BEGIN TRY
							  Exec sp_Executesql @N_SQL_EVENT ,
									N'@V_EVENT_ID_P INT ,
									@v_COND_PRIOR_CODE_P	varchar(255),
									@v_RAIL_POSITION_CODE_P	varchar(255),
									@v_RESTRAINT_CODE_P	varchar(255),
									@v_BED_POSITION_CODE_P	varchar(255),
									@v_CALL_LIGHT_CODE_P	varchar(255)',
									@V_EVENT_ID_P = @i_EVENT_ID ,
									@v_COND_PRIOR_CODE_P = @COND_PRIOR_CODE_R ,	
									@v_RAIL_POSITION_CODE_P = @RAIL_POSITION_CODE_R ,	
									@v_RESTRAINT_CODE_P = @RESTRAINT_CODE_R  ,	
									@v_BED_POSITION_CODE_P = @BED_POSITION_CODE_R ,	
									@v_CALL_LIGHT_CODE_P	 = @CALL_LIGHT_CODE_R ;
							--  END TRY
							--BEGIN CATCH	
							--			 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--			 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--					@p_MODULE_NAME = @V_MODULENAME ,
							--					@p_CALLING_ERROR_LOCATION = 'Main', 
							--					@p_CURRENT_ERROR_LOCATION = 'INDI2', 
							--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--					@p_ERROR_COLUMNS = NULL , 
							--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--					@P_IS_VALIDATION = 0 ; 	
							--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
							--	END CATCH
						--PRINT '@N_SQL_EVENT : FALL_INDICATOR ' + @N_SQL_EVENT

									 SET @V_ERROR_LOCATION = 'I23' ;
						END		-- COULMNS NOT FOUND BUT PRESENT IN RMDB CALL_LIGHT_FLAG
								
								IF @i_EVENT_ID_O > 0 AND  @vTableName = 'FALL_INDICATOR'		
						BEGIN					 
											 SET @V_ERROR_LOCATION = 'I24' ;				 
							 SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' FALL_INDICATOR SET EVENT_ID = @V_EVENT_ID_P ' ;		--JIRA RMA - 20453					
										IF @COND_PRIOR_CODE_R IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',COND_PRIOR_CODE = @v_COND_PRIOR_CODE_P'	
										IF @RAIL_POSITION_CODE_R IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',RAIL_POSITION_CODE = @v_RAIL_POSITION_CODE_P '	
										IF @RESTRAINT_CODE_R IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',RESTRAINT_CODE =  @v_RESTRAINT_CODE_P'	
										IF @BED_POSITION_CODE_R IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',BED_POSITION_CODE = @v_BED_POSITION_CODE_P'	
										IF @CALL_LIGHT_CODE_R IS NOT NULL						
										SET	 @N_SQL = @N_SQL + ',CALL_LIGHT_CODE = @v_CALL_LIGHT_CODE_P'	
										
										SET	 @N_SQL = @N_SQL + ' WHERE EVENT_ID = @V_EVENT_ID_P ' ;						 
							  --BEGIN TRY
							  Exec sp_Executesql @N_SQL ,
									N'@V_EVENT_ID_P INT ,
									@v_COND_PRIOR_CODE_P	varchar(255),
									@v_RAIL_POSITION_CODE_P	varchar(255),
									@v_RESTRAINT_CODE_P	varchar(255),
									@v_BED_POSITION_CODE_P	varchar(255),
									@v_CALL_LIGHT_CODE_P	varchar(255)',
									@V_EVENT_ID_P = @i_EVENT_ID ,
									@v_COND_PRIOR_CODE_P = @COND_PRIOR_CODE_R ,	
									@v_RAIL_POSITION_CODE_P = @RAIL_POSITION_CODE_R ,	
									@v_RESTRAINT_CODE_P = @RESTRAINT_CODE_R  ,	
									@v_BED_POSITION_CODE_P = @BED_POSITION_CODE_R ,	
									@v_CALL_LIGHT_CODE_P	 = @CALL_LIGHT_CODE_R ;
							--  END TRY
							--BEGIN CATCH	
							--			 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--			 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--					@p_MODULE_NAME = @V_MODULENAME ,
							--					@p_CALLING_ERROR_LOCATION = 'Main', 
							--					@p_CURRENT_ERROR_LOCATION = 'INDI2', 
							--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--					@p_ERROR_COLUMNS = NULL , 
							--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--					@P_IS_VALIDATION = 0 ; 	
							--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
							--	END CATCH
								--PRINT 'OSHA UPD SQL' + @N_SQL 
										 SET @V_ERROR_LOCATION = 'I25' ;	
						END	
									
						END	
			END		
		END	




END		
--PRINT 'MPORT EVENT ENDS'


									--*************************************************************************
									--******************* IMPORT EVENT ENDS *****************************			-- Eight Blocks
									--*************************************************************************
				
									--*************************************************************************
									--********PERSON INVOLVED and its Related tables INSERT STARTS  ************	-- TEN Blocks									--*************************************************************************




IF ( @I_ERRORCOUNT = 0 AND @i_EVENT_ID > 0 AND @i_PI_TYPE_ENTITY_ID_GEN > 0 )
BEGIN
--PRINT 'PI ENTERED'	--MK(remove)
IF @v_EXP_LENGTH_OF_STAY IS  NULL SET @v_EXP_LENGTH_OF_STAY = 0 ; --MKAUR24 QA
IF @MARITAL_STAT_CODE_R IS NULL SET @MARITAL_STAT_CODE_R = 0 ;


BEGIN											  -- PIIns1. RMDB EXISTENCE OF PERSON_INVOLVED	
			SET @i_PI_ROW_ID = 0;											
			 SET @V_ERROR_LOCATION = 'I26' ;	
			SET @N_SQL = 'SELECT @PI_ROW_ID_P = PI_ROW_ID   FROM ' + @V_DBName + ' PERSON_INVOLVED';
			SET @N_SQL =  @N_SQL + ' WHERE EVENT_ID = @V_EVENT_ID_P  AND PI_EID = @iEntId_P AND PARENT_TABLE_NAME = ''EVENT'' ';	--MK TZ1 MKAUR24 (level of PI should be used as well as PI can have different level of attachment on same event)								
				--BEGIN TRY	--MK(entity role part is missing and level of attachment for PI has not been implemented)
				Exec sp_Executesql @N_SQL,
					 N' @PI_ROW_ID_P AS INT output ,				
					 @V_EVENT_ID_P INT ,
					 @iEntId_p INT ',
					 @PI_ROW_ID_P = @i_PI_ROW_ID OUTPUT ,					  
					 @V_EVENT_ID_P = @i_EVENT_ID ,
					 @iEntId_P = @i_PI_TYPE_ENTITY_ID_GEN  ;	
				--END TRY
				--	   BEGIN CATCH	
				--				 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				--				 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				--						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				--						@p_MODULE_NAME = @V_MODULENAME ,
				--						@p_CALLING_ERROR_LOCATION = 'Main', 
				--						@p_CURRENT_ERROR_LOCATION = 'PI_EXIST', 
				--						@p_ERROR_PROC_NAME = @V_PROCNAME ,
				--						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
				--						@p_ERROR_COLUMNS = NULL , 
				--						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
				--						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				--						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				--						@P_IS_VALIDATION = 0 ; 
				--						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
				--		END CATCH	
				 SET @V_ERROR_LOCATION = 'I27' ;
--PRINT 'PIIns1. END'	--MK(remove)
END	

IF (@i_PI_ROW_ID = 0) --CW						  -- PIIns2. TABLE INSERT STARTS    	
BEGIN	
--PRINT ' PIIns2. ENETERD' --MK(remove)
				 	-- 1.PI_EID (NEXT_UNIQUE_ID)GENRATED FROM RMDB 				
						 SET @V_ERROR_LOCATION = 'I28' ;
						SET	  @N_SQL = 'SELECT @V_NEXT_UNIQUE_ID_P = NEXT_UNIQUE_ID FROM ' + @V_DBNAME + ' GLOSSARY G ' ;
						SET	  @N_SQL =  @N_SQL + ' WHERE  SYSTEM_TABLE_NAME = ''PERSON_INVOLVED'' ' ;
						--BEGIN TRY
						Exec sp_Executesql @N_SQL, 
							 N' @V_NEXT_UNIQUE_ID_P varchar(255) OUTPUT',
							 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID OUTPUT;										
						--END TRY
						--BEGIN CATCH	
						--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--				@p_MODULE_NAME = @V_MODULENAME ,
						--				@p_CALLING_ERROR_LOCATION = 'Main', 
						--				@p_CURRENT_ERROR_LOCATION = 'PIEIDNXTYNQ', 
						--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--				@p_ERROR_COLUMNS = NULL , 
						--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--				@P_IS_VALIDATION = 0 ; 	
						--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						--END CATCH
						IF ((@V_NEXT_UNIQUE_ID IS NULL) OR (@V_NEXT_UNIQUE_ID = 0 ))
							BEGIN
								SET @V_NEXT_UNIQUE_ID = 1
							END	
						SET	  @i_PI_ROW_ID       = @V_NEXT_UNIQUE_ID ;
						 SET @V_ERROR_LOCATION = 'I29' ;

BEGIN																-- PIIns2. TABLE INSERT STARTS commom   
							 DECLARE @iEroleFlag INT

							 SET @N_SQL_EVENT = 'SELECT @pEroleFlag = STR_PARM_VALUE FROM  '  + @V_DBNAME +  ' PARMS_NAME_VALUE WHERE PARM_NAME = ''USE_ENTITY_ROLE'''
							 EXECUTE SP_EXECUTESQL @N_SQL_EVENT,
							 N' @pEroleFlag INT OUTPUT',
							 @pEroleFlag = @iEroleFlag OUTPUT
							 
							 SET @V_ERROR_LOCATION = 'I30' ;
							 SET @N_SQL_EVENT = 'INSERT INTO ' + @V_DBNAME  +  ' PERSON_INVOLVED (  PI_ROW_ID , EVENT_ID, PI_EID, PI_TYPE_CODE, DATE_OF_DEATH, MARITAL_STAT_CODE,' 
							 
							 --dsharma70 hmi
							 IF @HEALTH_LOB_ID > 0 SET @N_SQL_EVENT = @N_SQL_EVENT +  ' BENEFICIARY_CODE,'

							 SET @N_SQL_EVENT = @N_SQL_EVENT +  ' COUNTY_OF_RESIDNC, WEIGHT, NUM_OF_VIOLATIONS , PARENT_TABLE_NAME, ROLE_TABLE_ID, PARENT_ROW_ID  ) VALUES ( @i_PI_ROW_ID_P ,@i_EVENT_ID_P ,@iEntId_P , @v_PI_TYPE_CODE_P,'
							 SET @N_SQL_EVENT = @N_SQL_EVENT + ' @v_DATE_OF_DEATH_P , @v_MARITAL_STAT_CODE_P ,'

							 --dsharma70 hmi
							 IF @HEALTH_LOB_ID > 0 SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @BENEFICIARY_CODE_ID,'

							 SET @N_SQL_EVENT = @N_SQL_EVENT + ' @V_COUNTY_OF_RESIDNC_P ,  @v_WEIGHT_P, @V_NUM_OF_VIOLATION_P , ''EVENT'','
							 --mkaur24 MK
							 IF @iEroleFlag = 0
								SET @N_SQL_EVENT = @N_SQL_EVENT + '0,'
							 ELSE
								SET @N_SQL_EVENT = @N_SQL_EVENT + '@pRoleTableId,'
							  SET @N_SQL_EVENT = @N_SQL_EVENT + '@i_EVENT_ID_P) '
								--BEGIN TRY
								
								EXEC sp_Executesql   @N_SQL_EVENT ,
								N'@i_PI_ROW_ID_P INT,
								@i_EVENT_ID_p INT ,
								@iEntId_P  INT ,
								@v_PI_TYPE_CODE_P INT ,
								@v_DATE_OF_DEATH_P varchar(8),
								@v_MARITAL_STAT_CODE_P	 INT,
								@V_COUNTY_OF_RESIDNC_P VARCHAR (50),	
								@V_NUM_OF_VIOLATION_P INT ,							
								@v_WEIGHT_P INT,
								@pRoleTableId INT,
								@BENEFICIARY_CODE_ID INT',
								@i_PI_ROW_ID_P = @i_PI_ROW_ID ,
								@i_EVENT_ID_P = @i_EVENT_ID,
								@iEntId_P = @i_PI_TYPE_ENTITY_ID_GEN,
								@v_PI_TYPE_CODE_P = @PI_TYPE_CODE_R,
								@v_DATE_OF_DEATH_P  = 	@v_DATE_OF_DEATH,
								@v_MARITAL_STAT_CODE_P	 = @MARITAL_STAT_CODE_R ,
								@V_COUNTY_OF_RESIDNC_P = @V_COUNTY_OF_RESIDNC  ,
								@V_NUM_OF_VIOLATION_P  = @V_NUM_OF_VIOLATION,
								@v_WEIGHT_P = @v_WEIGHT,
								@pRoleTableId = @iRoleTableId, --mkaur24 MK
								@BENEFICIARY_CODE_ID = @BENEFICIARY_CODE_ID  ;	--DSHARMA70 hmi

								--END TRY
								--BEGIN CATCH	
								-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--		@p_MODULE_NAME = @V_MODULENAME ,
								--		@p_CALLING_ERROR_LOCATION = 'Main', 
								--		@p_CURRENT_ERROR_LOCATION = 'PIINS1', 
								--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--		@p_ERROR_COLUMNS = NULL , 
								--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--		@P_IS_VALIDATION = 0 ; 	
								--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								--END CATCH
								 SET @V_ERROR_LOCATION = 'I31' ;
		END	
							-- 3. Update NEXT_UNIQUE_ID for PERSON_INVOLVED in glossary	
								
										
										SET  @V_NEXT_UNIQUE_ID = @i_PI_ROW_ID +  1 ; -- MKAUR24 
										SET @V_ERROR_LOCATION = 'I37' 
										SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' GLOSSARY  SET NEXT_UNIQUE_ID = @V_NEXT_UNIQUE_ID_P ' ;
										SET	 @N_SQL = @N_SQL + ' WHERE SYSTEM_TABLE_NAME = ''PERSON_INVOLVED''' ;		
										Exec sp_Executesql @N_SQL, 
											 N' @V_NEXT_UNIQUE_ID_P varchar(255)',
											 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID ;

				--SET @v_PI_TYPE_CODE = 'p'
IF  UPPER(@v_PI_TYPE_CODE) = 'P'											-- PIIns5. INSERT into PI table WHEN   PI_TYPE_CODE 'P'                 
					BEGIN	
				--PRINT '-- PIIns5. ENTERED'	--MK(remove)
							BEGIN  -- PATIENT_ID (NEXT_UNIQUE_ID)GENRATED FROM RMDB 	
							 SET @V_ERROR_LOCATION = 'I32' ;
							SET	  @N_SQL = 'SELECT @V_NEXT_UNIQUE_ID_P = NEXT_UNIQUE_ID FROM ' + @V_DBNAME + ' GLOSSARY G ' ;
							SET	  @N_SQL =  @N_SQL + ' WHERE  SYSTEM_TABLE_NAME = ''PATIENTS'' ' ;
							--BEGIN TRY
							Exec sp_Executesql @N_SQL, 
								 N' @V_NEXT_UNIQUE_ID_P varchar(255) OUTPUT',
								 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID OUTPUT;										
						--	END TRY
						--	BEGIN CATCH	
						--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--				@p_MODULE_NAME = @V_MODULENAME ,
						--				@p_CALLING_ERROR_LOCATION = 'Main', 
						--				@p_CURRENT_ERROR_LOCATION = 'PATIENTNXT', 
						--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--				@p_ERROR_COLUMNS = NULL , 
						--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--				@P_IS_VALIDATION = 0 ;
						--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
						--END CATCH
						SET @V_ERROR_LOCATION = 'I33' ;
						IF ((@V_NEXT_UNIQUE_ID IS NULL) OR (@V_NEXT_UNIQUE_ID = 0 ))
								BEGIN
									SET @V_NEXT_UNIQUE_ID = 1
								END	
							SET	  @i_PATIENT_ID_GEN       = @V_NEXT_UNIQUE_ID ;	
													
						END

						SET  @N_SQL_EVENT = ' UPDATE ' + @V_DBNAME + ' PERSON_INVOLVED SET PI_ROW_ID =  @i_PI_ROW_ID_P ' ; 	--JIRA RMA - 20453
						IF   @i_PATIENT_ID_GEN IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_ID = @i_PATIENT_ID_P'
						IF   @v_PATIENT_ACCT_NO IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_ACCT_NO = @v_PATIENT_ACCT_NO_P'
						IF   @v_MEDICAL_RCD_NO IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',MEDICAL_RCD_NO = @v_MEDICAL_RCD_NO_P'
						IF   @v_INS_PLAN_GROUP_NO IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',INS_PLAN_GROUP_NO = @v_INS_PLAN_GROUP_NO_P'						
						IF   @v_DATE_OF_ADMISSION IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_OF_ADMISSION = @v_DATE_OF_ADMISSION_P'
						IF   @v_DATE_OF_DISCHARGE IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_OF_DISCHARGE = @v_DATE_OF_DISCHARGE_P'
						IF   @v_EPISODE_OF_CARE_ID  IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EPISODE_OF_CARE_ID = @v_EPISODE_OF_CARE_ID_P'
						IF   @v_EMERGENCY_CONTACT IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EMERGENCY_CONTACT = @v_EMERGENCY_CONTACT_P'
						IF   @v_EMERGENCY_CONT_NO IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EMERGENCY_CONT_NO = @v_EMERGENCY_CONT_NO_P '
						IF   @v_PATIENT_ROOM_NO  IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_ROOM_NO = @v_PATIENT_ROOM_NO_P'
						IF   @v_EXP_LENGTH_OF_STAY IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EXP_LENGTH_OF_STAY = @v_EXP_LENGTH_OF_STAY_P'
						IF   @v_EXPECTED_COST IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EXPECTED_COST = @v_EXPECTED_COST_P'
						IF   @PATIENT_TYPE_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_TYPE_CODE = @V_PATIENT_TYPE_CODE_P'						
						IF   @PATIENT_STAT_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_STAT_CODE = @V_PATIENT_STAT_CODE_P'
						IF   @PATIENT_COND_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',PATIENT_COND_CODE = @V_PATIENT_COND_CODE_P'
						IF   @ACUITY_LEVEL_CODE_R  IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',ACUITY_LEVEL_CODE = @V_ACUITY_LEVEL_CODE_P'
						IF   @ADM_SOURCE_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',ADM_SOURCE_CODE =  @v_ADM_SOURCE_CODE_P'
						IF   @ADM_TYPE_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',ADM_TYPE_CODE = @V_ADM_TYPE_CODE_P'
						IF   @DISCHARGE_DSP_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',DISCHARGE_DSP_CODE = @v_DISCHARGE_DSP_CODE_P'						
						IF   @QI_SIGNIF_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',QI_SIGNIF_CODE = @v_QI_SIGNIF_CODE_P'
						IF   @FACILITY_UNIT_CODE_R IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',FACILITY_UNIT_CODE = @v_FACILITY_UNIT_CODE_P'
						IF   @i_FACILITY_DEPT_GEN  IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',FACILITY_DEPT_EID = @v_FACILITY_DEPT_P'
						IF   @v_WHY_AT_FACILITY IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',WHY_AT_FACILITY = @v_WHY_AT_FACILITY_P'
						IF   @v_ADMISSION_REASON IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',ADMISSION_REASON = @v_ADMISSION_REASON_P'
						
						--dsharma70 hmi
						IF @HEALTH_LOB_ID > 0 SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',BENEFICIARY_CODE = @BENEFICIARY_CODE_ID'
						
						SET	 @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE PI_ROW_ID =  @i_PI_ROW_ID_P ' ;	
							--BEGIN TRY
								EXEC sp_Executesql @N_SQL_EVENT,
										   N' @i_PATIENT_ID_P INT ,  
										   @v_PATIENT_ACCT_NO_P	varchar(20),
										   @v_MEDICAL_RCD_NO_P	varchar(12),
										   @v_INS_PLAN_GROUP_NO_P	varchar(16),
										   @v_DATE_OF_ADMISSION_P	varchar(8),
										   @v_DATE_OF_DISCHARGE_P	varchar(8) ,
										   @v_EPISODE_OF_CARE_ID_P	varchar(8) ,
										   @v_EMERGENCY_CONTACT_P	varchar(20) ,
										   @v_EMERGENCY_CONT_NO_P	varchar(20),
										   @v_PATIENT_ROOM_NO_P	varchar(14),
										   @v_EXP_LENGTH_OF_STAY_P	int ,
										   @v_EXPECTED_COST_P	decimal(20,2) ,
										   @v_PATIENT_TYPE_CODE_P	int ,
										   @v_PATIENT_STAT_CODE_P	int,
										   @v_PATIENT_COND_CODE_p	int,
										   @v_ACUITY_LEVEL_CODE_P	int,
										   @v_ADM_SOURCE_CODE_P	int,
										   @v_ADM_TYPE_CODE_P	varchar(25),
										   @v_DISCHARGE_DSP_CODE_P	int,
										   @v_QI_SIGNIF_CODE_P	varchar(25),
										   @v_FACILITY_UNIT_CODE_P	int,
										   @v_FACILITY_DEPT_P	int ,
										   @v_WHY_AT_FACILITY_P	varchar(max),
										   @v_ADMISSION_REASON_P	varchar(max),
										   @i_PI_ROW_ID_P INT ,
										   @BENEFICIARY_CODE_ID INT',										   
										   @i_PATIENT_ID_P =  @i_PATIENT_ID_GEN , 
										   @v_PATIENT_ACCT_NO_P	= @v_PATIENT_ACCT_NO,
										   @v_MEDICAL_RCD_NO_P	= @v_MEDICAL_RCD_NO ,
										   @v_INS_PLAN_GROUP_NO_P	= @v_INS_PLAN_GROUP_NO,
										   @v_DATE_OF_ADMISSION_P	= @v_DATE_OF_ADMISSION ,
										   @v_DATE_OF_DISCHARGE_P	= @v_DATE_OF_DISCHARGE ,
										   @v_EPISODE_OF_CARE_ID_P = @v_EPISODE_OF_CARE_ID ,	
										   @v_EMERGENCY_CONTACT_P = @v_EMERGENCY_CONTACT ,	
										   @v_EMERGENCY_CONT_NO_P	= @v_EMERGENCY_CONT_NO ,
										   @v_PATIENT_ROOM_NO_P	= @v_PATIENT_ROOM_NO ,
										   @v_EXP_LENGTH_OF_STAY_P = @v_EXP_LENGTH_OF_STAY,
										   @v_EXPECTED_COST_P	 =  @v_EXPECTED_COST ,
										   @v_PATIENT_TYPE_CODE_P = @PATIENT_TYPE_CODE_R,
										   @v_PATIENT_STAT_CODE_P = @PATIENT_STAT_CODE_R ,
										   @v_PATIENT_COND_CODE_p = @PATIENT_COND_CODE_R ,	
										   @v_ACUITY_LEVEL_CODE_P = @ACUITY_LEVEL_CODE_R ,	
										   @v_ADM_SOURCE_CODE_P	  = @ADM_SOURCE_CODE_R ,
										   @v_ADM_TYPE_CODE_P	  = @ADM_TYPE_CODE_R ,
										   @v_DISCHARGE_DSP_CODE_P = @DISCHARGE_DSP_CODE_R ,
										   @v_QI_SIGNIF_CODE_P	= @QI_SIGNIF_CODE_R ,
										   @v_FACILITY_UNIT_CODE_P = @FACILITY_UNIT_CODE_R ,	
										   @v_FACILITY_DEPT_P	=   @i_FACILITY_DEPT_GEN,
										   @v_WHY_AT_FACILITY_P	= @v_WHY_AT_FACILITY ,
										   @v_ADMISSION_REASON_P = @v_ADMISSION_REASON ,
										   @i_PI_ROW_ID_P = @i_PI_ROW_ID,
										   @BENEFICIARY_CODE_ID = @BENEFICIARY_CODE_ID ;									 
						--	END TRY
						--	BEGIN CATCH	
						--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--				@p_MODULE_NAME = @V_MODULENAME ,
						--				@p_CALLING_ERROR_LOCATION = 'Main', 
						--				@p_CURRENT_ERROR_LOCATION = 'PIINS4', 
						--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--				@p_ERROR_COLUMNS = NULL , 
						--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--				@P_IS_VALIDATION = 0 ; 	
						--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
						--END CATCH
						SET @V_ERROR_LOCATION = 'I34' ;
				--PRINT '-- PIIns5. END'			--MK(remove)   	
									
					END	
								
--SET @v_PI_TYPE_CODE = 'w'
IF UPPER(@v_PI_TYPE_CODE) = 'W'											-- PIIns6. INSERT into PI table WHEN   PI_TYPE_CODE IS WITNESS	   
					BEGIN 
						--PRINT '	-- PIIns6.ENTERED'	--MK(remove)
							SET @V_ERROR_LOCATION = 'I35' ;
						--SET @N_SQL_EVENT = NULL ;
						SET  @N_SQL_EVENT = ' UPDATE ' + @V_DBNAME + 'PERSON_INVOLVED SET PI_ROW_ID =  @i_PI_ROW_ID_P ' ; 	--JIRA RMA - 20453
						 IF   @v_DESC_BY_WITNESS IS NOT NULL
						 SET  @N_SQL_EVENT =  ',DESC_BY_WITNESS = @v_DESC_BY_WITNESS_P'					
					
					     SET  @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE PI_ROW_ID =  @i_PI_ROW_ID_P ' ;	
					
								--BEGIN TRY
								Exec sp_Executesql @N_SQL_EVENT ,
								N'@v_DESC_BY_WITNESS_P	varchar(max),
								@i_PI_ROW_ID_P INT ',
								@v_DESC_BY_WITNESS_P = @v_DESC_BY_WITNESS,
								@i_PI_ROW_ID_P = @i_PI_ROW_ID ;
								--END TRY
								--BEGIN CATCH	
								--	 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--	 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--		@p_MODULE_NAME = @V_MODULENAME ,
								--		@p_CALLING_ERROR_LOCATION = 'Main', 
								--		@p_CURRENT_ERROR_LOCATION = 'PIINS5', 
								--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--		@p_ERROR_COLUMNS = NULL , 
								--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--		@P_IS_VALIDATION = 0 ; 	
								--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								--END CATCH
								SET @V_ERROR_LOCATION = 'I36' 
					
					--	PRINT '	-- PIIns6.END'	--MK(remove)

					END						
									
										





										SET @V_ERROR_LOCATION = 'I38' 
--PRINT 'Update NEXT_UNIQUE_ID AFTER PIINS6 ,END'	--MK(remove)
--SET @v_PI_TYPE_CODE = 'E'
IF (UPPER(@v_PI_TYPE_CODE) = 'E' OR UPPER(@v_PI_TYPE_CODE) = 'P' ) AND (@i_PI_ROW_ID > 0)	 -- PIIns7. INSERTION INTO RELATED TABLES WHEN PI TYPE IS P/E 
BEGIN

BEGIN --1b	--C. HOSPITAL AND PHYSICIAN ENTERD
	 -- PRINT 'HOSPITLA  -- PIIns8. ENTERED  '	--MK(remove)					
	  SET @vColList = 'HOSPITAL|PHYSICIAN|'
	  SET @vTableList = 'PI_X_HOSPITAL|PI_X_PHYSICIAN|'
	  WHILE CHARINDEX('|',@vColList,1) > 0		
	  BEGIN --2B
		--	PRINT 'WHILE ENETERD JHOS'	--MK(remove)
			SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
			SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
			SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
			SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))								
			--SET @i_HOSPITAL_1_EID = 99 --SAM
			--SET  @i_HOSPITAL_2_EID = 89 --SAM
			--SET @i_PHYSICIAN_2_EID =78 --SAM
			SET @iCount = 1
			WHILE @iCount <= 3
				 BEGIN --3B
						SET @vColToProcess = @vColName + '_' + CAST(@iCount as VARCHAR) + '_EID'						 
						--PRINT '@vColToProcess' + @vColToProcess
						SET @vVal = (CASE
						WHEN @vColToProcess = 'HOSPITAL_1_EID' THEN @i_HOSPITAL_1_EID
						WHEN @vColToProcess = 'HOSPITAL_2_EID' THEN @i_HOSPITAL_2_EID		
						WHEN @vColToProcess = 'HOSPITAL_3_EID' THEN @i_HOSPITAL_3_EID								
						WHEN @vColToProcess = 'PHYSICIAN_1_EID' THEN @i_PHYSICIAN_1_EID
						WHEN @vColToProcess = 'PHYSICIAN_2_EID' THEN @i_PHYSICIAN_2_EID
						WHEN @vColToProcess = 'PHYSICIAN_3_EID' THEN @i_PHYSICIAN_3_EID								
						END)
							IF @vVal IS NOT NULL or @vVal <> 0 
								BEGIN  --4B
									 SET @i_PI_ROW_ID_OP = 0							
									 SET @vColInRM = @vColName +  '_EID'										
									SET @V_ERROR_LOCATION = 'I39' 
									 SET @N_SQL = 'SELECT @PI_ROW_ID_OP = PI_ROW_ID  FROM '+ @V_DBName + @vTableName ;
									 SET @N_SQL = @N_SQL + ' WHERE PI_ROW_ID  = @PI_ROW_ID_P AND '  + @vColInRM + ' = @vVal_P ' ;
										--BEGIN TRY
												Exec sp_Executesql @N_SQL,
												N' @PI_ROW_ID_P INT ,
												@PI_ROW_ID_OP INT OUTPUT ,
												@vVal_P INT ',						
												@PI_ROW_ID_P = @i_PI_ROW_ID  ,
												@vVal_P = @vVal ,		
												@PI_ROW_ID_OP = @i_PI_ROW_ID_OP  OUTPUT ;
										--END TRY
										--BEGIN CATCH	
										--		SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--		@p_MODULE_NAME = @V_MODULENAME ,
										--		@p_CALLING_ERROR_LOCATION = 'Main', 
										--		@p_CURRENT_ERROR_LOCATION = 'HOSP/PHYS2', 
										--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--		@p_ERROR_COLUMNS = NULL , 
										--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--		@P_IS_VALIDATION = 0 ; 	
										--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
										--END CATCH
										SET @V_ERROR_LOCATION = 'I40' 
											--SET @i_PI_ROW_ID_OP = 0
											IF (@i_PI_ROW_ID_OP = 0)
												BEGIN --5B
													
													SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME + @vTableName + ' (PI_ROW_ID,' + @vColInRM + ') VALUES ( ' + CAST(@i_PI_ROW_ID AS VARCHAR) + ',' ;
													SET @N_SQL_EVENT = @N_SQL_EVENT	  + ISNULL(CAST(@vVal AS VARCHAR ),0) + ')' ;	
														--BEGIN TRY
															Exec sp_Executesql @N_SQL_EVENT ;
														--END TRY
														--BEGIN CATCH	
														--	SET	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 									 	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	 	 		 	 	 	 	 	 	 	 	 	 	 	 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
														--	@p_DA_ROW_ID  = @V_DA_ROW_ID , 
														--	@p_MODULE_NAME = @V_MODULENAME ,
														--	@p_CALLING_ERROR_LOCATION = 'Main', 
														--	@p_CURRENT_ERROR_LOCATION = 'HOSP/PHYS3', 
														--	@p_ERROR_PROC_NAME = @V_PROCNAME ,
														--	@p_ERROR_MSG = @V_ERROR_MESSAGE ,
														--	@p_ERROR_COLUMNS = NULL , 
														--	@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
														--	@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
														--	@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
														--	@P_IS_VALIDATION = 0 ; 		
														--	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
														--END CATCH	
															SET @V_ERROR_LOCATION = 'I41' 
												END --5B
								END  --4B
						SET @iCount = @iCount + 1
				 END --3B
	  END ----2B
	    --PRINT 'HOSPITLA  -- PIIns8. END  '	
END --1B

BEGIN 
				
					
							SET @V_ERROR_LOCATION = 'I353' ;						
						SET  @N_SQL = ' UPDATE ' + @V_DBNAME + 'PERSON_INVOLVED SET PI_ROW_ID =  @i_PI_ROW_ID_P ' ; 	
						 IF   @v_HCO_ID_NO IS NOT NULL
						 SET  @N_SQL = @N_SQL + ', HCO_ID_NO  = @v_HCO_ID_NO_P '	
																 --PRINT '@@N_SQL lens svc sql 2 ' + @N_SQL
						  IF   @v_HCO_SITE_ID_NO IS NOT NULL
						 SET  @N_SQL = @N_SQL  + ', HCO_SITE_ID_NO = @v_HCO_SITE_ID_NO_P '	
						 
														 --PRINT '@@N_SQL lens svc sql 3 ' + @N_SQL
						 IF   @v_EST_LEN_DISABILITY	 IS NOT NULL
						 SET  @N_SQL =  @N_SQL + ', EST_LEN_DISABILITY = @v_EST_LEN_DISABILITY_P'					
					
					
														 --PRINT '@@N_SQL lens svc sql 4 ' + @N_SQL
						IF   @v_LEN_OF_SVC_DAYS IS NOT NULL
						 SET  @N_SQL = @N_SQL +  ', LEN_OF_SVC_DAYS = @v_LEN_OF_SVC_DAYS_P '	
																					 --PRINT '@@N_SQL lens svc sql 5 ' + @N_SQL
					     SET  @N_SQL = @N_SQL + ' WHERE PI_ROW_ID =  @i_PI_ROW_ID_P ' ;									
								--PRINT '@@N_SQL' + @N_SQL
								Exec sp_Executesql @N_SQL ,
								N' @v_HCO_ID_NO_P	varchar(20),
								@v_EST_LEN_DISABILITY_P INT ,
								@v_LEN_OF_SVC_DAYS_P  varchar(1) , 
								@v_HCO_SITE_ID_NO_P varchar(20) ,
								@i_PI_ROW_ID_P INT  ',
								@v_HCO_ID_NO_P = @v_HCO_ID_NO,
								@v_EST_LEN_DISABILITY_P = @v_EST_LEN_DISABILITY,
								@v_LEN_OF_SVC_DAYS_P = @v_LEN_OF_SVC_DAYS,
								@v_HCO_SITE_ID_NO_P = @v_HCO_SITE_ID_NO,
								@i_PI_ROW_ID_P = @i_PI_ROW_ID ;
								SET @V_ERROR_LOCATION = 'I363' 
					
					

					END		


END --PIINS7 END

--Print 'phys strat'
--SET @v_PI_TYPE_CODE ='PHYS'
IF (UPPER(@v_PI_TYPE_CODE) = 'PHYS')  -- PIIns8. INSERTION INTO PHYSICIAN 
BEGIN
--print 'phys entered'
SET @i_Phys_EID_O = 0
	SET @V_ERROR_LOCATION = 'I42' 
SET @N_SQL_EVENT = 'SELECT  @PHYS_EID_OP = PHYS_EID FROM '+ @V_DBName + ' PHYSICIAN'
SET @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE PHYS_EID = @PHYS_EID_P '	
				--BEGIN TRY
				Exec sp_Executesql @N_SQL_EVENT,
					 N' @PHYS_EID_P INT ,	
					 @PHYS_EID_OP INT OUTPUT',											
					 @PHYS_EID_P  = @i_PI_TYPE_ENTITY_ID_GEN ,								
					 @PHYS_EID_OP = @i_Phys_EID_O OUTPUT ;
				--END TRY
				--BEGIN CATCH	
				--				 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				--				 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				--						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				--						@p_MODULE_NAME = @V_MODULENAME ,
				--						@p_CALLING_ERROR_LOCATION = 'Main', 
				--						@p_CURRENT_ERROR_LOCATION = 'PHYSEXIST', 
				--						@p_ERROR_PROC_NAME = @V_PROCNAME ,
				--						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
				--						@p_ERROR_COLUMNS = NULL , 
				--						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
				--						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				--						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				--						@P_IS_VALIDATION = 0 ; 
				--						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
				--		END CATCH
					SET @V_ERROR_LOCATION = 'I43' 
IF @i_Phys_EID_O = 0 
BEGIN

				IF @v_MARITAL_STAT_CODE IS NULL SET @MARITAL_STAT_CODE_R = 0;
				IF @v_DEPT_ASSIGNED IS NULL SET @i_DEPT_ASSIGNED_GEN = 0 ;
				SET @N_SQL_EVENT = 'INSERT INTO ' + @V_DBNAME  +  ' PHYSICIAN  ( PHYS_EID , PHYSICIAN_NUMBER , PRIMARY_SPECIALTY,PRIMARY_POLICY_ID,HOME_STATE_ID,'
				SET @N_SQL_EVENT = @N_SQL_EVENT + '  MARITAL_STAT_CODE,MAILING_STATE_ID,STAFF_STATUS_CODE,STAFF_TYPE_CODE,STAFF_CAT_CODE,LIC_STATE,DEPT_ASSIGNED_EID)'
				SET @N_SQL_EVENT = @N_SQL_EVENT + ' VALUES (@I_PHYS_EID_P ,	@V_PHYSICIAN_NUMBER_P ,	@V_PRIMARY_SPECIALTY_P  ,	@V_PRIMARY_POLICY_ID_P ,'
				SET @N_SQL_EVENT = @N_SQL_EVENT + ' 	@V_HOME_STATE_ID_P ,	@V_MARITAL_STAT_CODE_P ,	@V_MAILING_STATE_ID_P ,	@V_STAFF_STATUS_CODE_P ,	@V_STAFF_TYPE_CODE_P 	,	@V_STAFF_CAT_CODE_P ,	@V_LIC_STATE_P,@V_DEPT_ASSIGNED_EID_P ) ' 
													--BEGIN TRY
														Exec sp_Executesql @N_SQL_EVENT,
														  N'@I_PHYS_EID_P INT ,
															@V_PHYSICIAN_NUMBER_P VARCHAR(20),
															@V_PRIMARY_SPECIALTY_P INT , 
															@V_PRIMARY_POLICY_ID_P INT ,
															@V_HOME_STATE_ID_P INT ,
															@V_MARITAL_STAT_CODE_P INT ,
															@V_MAILING_STATE_ID_P INT ,
															@V_STAFF_STATUS_CODE_P INT ,
															@V_STAFF_TYPE_CODE_P INT ,	
															@V_STAFF_CAT_CODE_P INT ,
															@V_LIC_STATE_P INT,
															@V_DEPT_ASSIGNED_EID_P INT  ',
															@I_PHYS_EID_P			= @i_PI_TYPE_ENTITY_ID_GEN ,
															@V_PHYSICIAN_NUMBER_P	= @i_PI_TYPE_ENTITY_ID_GEN,
															@V_PRIMARY_SPECIALTY_P  =  0,	
															@V_PRIMARY_POLICY_ID_P	=  0,	
															@V_HOME_STATE_ID_P =  0,	
															@V_MARITAL_STAT_CODE_P =  @MARITAL_STAT_CODE_R,	
															@V_MAILING_STATE_ID_P =  0,	
															@V_STAFF_STATUS_CODE_P =  0,	
															@V_STAFF_TYPE_CODE_P 	=  0,	
															@V_STAFF_CAT_CODE_P =  0,	
															@V_LIC_STATE_P =  0 ,
															@V_DEPT_ASSIGNED_EID_P = @i_DEPT_ASSIGNED_GEN ;	
													--END TRY	
													--BEGIN CATCH	
													--		SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
													--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
													--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
													--			@p_MODULE_NAME = @V_MODULENAME ,
													--			@p_CALLING_ERROR_LOCATION = 'Main', 
													--			@p_CURRENT_ERROR_LOCATION = 'PHYSINS', 
													--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
													--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
													--			@p_ERROR_COLUMNS = NULL , 
													--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
													--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
													--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
													--			@P_IS_VALIDATION = 0 ; 		
													--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		 
													--END CATCH			
													SET @V_ERROR_LOCATION = 'I45' 
END
--PRINT 'PI PHYS END'
END	
--SET @v_PI_TYPE_CODE = 'P'
 IF (UPPER(@v_PI_TYPE_CODE) = 'P' )									--PIIns9  INSERTION INTO PATIENT AND PATIENT_RELATED TABLES 
 BEGIN
 --PRINT 'ENETERD PATIENT1'
BEGIN 
				SET @i_PATIENT_EID = 0 ;
				SET @V_ERROR_LOCATION = 'I46' 
				SET @N_SQL_EVENT = 'SELECT @PATIENT_EID_OP = PATIENT_EID  FROM '+ @V_DBName + 'PATIENT'
				SET @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE PATIENT_EID = @PATIENT_EID_P '	
								--BEGIN TRY
								Exec sp_Executesql @N_SQL_EVENT,
									 N' @PATIENT_EID_P INT ,
									 @PATIENT_EID_OP INT OUTPUT',											
									 @PATIENT_EID_P = @i_PI_TYPE_ENTITY_ID_GEN ,								
									 @PATIENT_EID_OP = @i_PATIENT_EID  OUTPUT ;
								--END TRY
								--BEGIN CATCH	
								-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--		@p_MODULE_NAME = @V_MODULENAME ,
								--		@p_CALLING_ERROR_LOCATION = 'Main', 
								--		@p_CURRENT_ERROR_LOCATION = 'PATIENTEXIST', 
								--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--		@p_ERROR_COLUMNS = NULL , 
								--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--		@P_IS_VALIDATION = 0 ; 	
								--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								--END CATCH
								SET @V_ERROR_LOCATION = 'I47' 
					 IF @i_PATIENT_EID = 0  

				
BEGIN
		IF @i_ADM_PHYSICIAN_EID_GEN IS NULL SET @i_ADM_PHYSICIAN_EID_GEN = 0;
		IF @i_PRI_PHYSICIAN_EID_GEN IS NULL SET @i_PRI_PHYSICIAN_EID_GEN = 0;
		IF @i_FACILITY_DEPT_GEN IS NULL SET  @i_FACILITY_DEPT_GEN = 0 ;
		IF @FACILITY_UNIT_CODE_R IS NULL SET @FACILITY_UNIT_CODE_R = 0 ;
		IF @MARITAL_STAT_CODE_R IS NULL SET @MARITAL_STAT_CODE_R = 0 ;
		IF @PATIENT_TYPE_CODE_R IS NULL SET @PATIENT_TYPE_CODE_R = 0 ;
		IF @v_EXP_LENGTH_OF_STAY IS NULL SET @v_EXP_LENGTH_OF_STAY = 0 ;		
		IF @ACUITY_LEVEL_CODE_R IS NULL SET @ACUITY_LEVEL_CODE_R = 0 ;
		IF @ADM_SOURCE_CODE_R IS NULL SET @ADM_SOURCE_CODE_R = 0 ;
		IF @ADM_TYPE_CODE_R IS NULL SET @ADM_TYPE_CODE_R = 0 ;
		
		IF @PATIENT_COND_CODE_R IS NULL SET @PATIENT_COND_CODE_R = 0 ; --mkaur24 qa
		IF @PATIENT_STAT_CODE_R IS NULL SET @PATIENT_STAT_CODE_R = 0 ; --mkaur24 qa
		IF @DISCHARGE_DSP_CODE_R IS NULL SET @DISCHARGE_DSP_CODE_R = 0 ; --mkaur24 qa
		IF @QI_SIGNIF_CODE_R IS NULL SET @QI_SIGNIF_CODE_R = 0 ; --mkaur24 qa
		

			SET @N_SQL_EVENT = 'INSERT INTO ' + @V_DBNAME  +  ' PATIENT  (PATIENT_ID , PATIENT_EID, PATIENT_ACCT_NO, MEDICAL_RCD_NO, INS_PLAN_GROUP_NO,DATE_OF_ADMISSION, ' 
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' DATE_OF_DISCHARGE,EPISODE_OF_CARE_ID,EMERGENCY_CONTACT,EMERGENCY_CONT_NO,PATIENT_ROOM_NO,EXP_LENGTH_OF_STAY,EXPECTED_COST,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' PATIENT_TYPE_CODE,PATIENT_STAT_CODE,PATIENT_COND_CODE,ACUITY_LEVEL_CODE,ADM_SOURCE_CODE,ADM_TYPE_CODE,'
			SET @N_SQL_EVENT = @N_SQL_EVENT + ' DISCHARGE_DSP_CODE,QI_SIGNIF_CODE,FACILITY_UNIT_CODE,FACILITY_DEPT_EID,WHY_AT_FACILITY,ADMISSION_REASON ,' 
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' PRI_PHYSICIAN_EID , ADM_PHYSICIAN_EID , WEIGHT ,MARITAL_STAT_CODE , DATE_OF_DEATH , HCO_ID_NO , HCO_SITE_ID_NO , PRIMARY_PAY_CODE ,SECOND_PAY_CODE,RACE_ENTH_CODE , CARDIAC_ARREST )'
		    SET @N_SQL_EVENT = @N_SQL_EVENT +  ' VALUES (@i_PATIENT_ID_P,@i_PATIENT_EID_P ,@v_PATIENT_ACCT_NO_P,@v_MEDICAL_RCD_NO_P,@v_INS_PLAN_GROUP_NO_P,@v_DATE_OF_ADMISSION_P,	'
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @v_DATE_OF_DISCHARGE_P ,@v_EPISODE_OF_CARE_ID_P,@v_EMERGENCY_CONTACT_P,@v_EMERGENCY_CONT_NO_P, @v_PATIENT_ROOM_NO_P,'
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @v_EXP_LENGTH_OF_STAY_P, @v_EXPECTED_COST_P,@v_PATIENT_TYPE_CODE_P,@v_PATIENT_STAT_CODE_P ,@v_PATIENT_COND_CODE_p , @v_ACUITY_LEVEL_CODE_P ,'
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @v_ADM_SOURCE_CODE_P , @v_ADM_TYPE_CODE_P,@v_DISCHARGE_DSP_CODE_P, @v_QI_SIGNIF_CODE_P , @v_FACILITY_UNIT_CODE_P , @v_ACUITY_LEVEL_CODE_P ,'
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @v_WHY_AT_FACILITY_P ,@v_ADMISSION_REASON_P , @i_PRI_PHYSICIAN_EID_P , @i_ADM_PHYSICIAN_EID_P , @v_WEIGHT_P ,@v_MARITAL_STAT_CODE_P , '	
			SET @N_SQL_EVENT = @N_SQL_EVENT +  ' @v_DATE_OF_DEATH_P ,@v_HCO_ID_NO_P , @v_HCO_SITE_ID_NO_P , @i_PRIMARY_PAY_CODE_P, @i_SECOND_PAY_CODE_P ,@i_RACE_ENTH_CODE_P , @i_CARDIAC_ARREST_P)'
									
					--PRINT '@N_SQL_EVENT PATEINT INSERT' + @N_SQL_EVENT
					--BEGIN TRY
					EXEC sp_Executesql @N_SQL_EVENT,
								   N' @i_PATIENT_ID_P INT ,
								   @i_PATIENT_EID_P int ,  
								   @v_PATIENT_ACCT_NO_P	varchar(20),
								   @v_MEDICAL_RCD_NO_P	varchar(12),
								   @v_INS_PLAN_GROUP_NO_P	varchar(16),
								   @v_DATE_OF_ADMISSION_P	varchar(8),
								   @v_DATE_OF_DISCHARGE_P	varchar(8) ,
								   @v_EPISODE_OF_CARE_ID_P	varchar(8) ,
								   @v_EMERGENCY_CONTACT_P	varchar(20) ,
								   @v_EMERGENCY_CONT_NO_P	varchar(20),
								   @v_PATIENT_ROOM_NO_P	varchar(14),
								   @v_EXP_LENGTH_OF_STAY_P	int ,
								   @v_EXPECTED_COST_P	decimal(20,2) ,
								   @v_PATIENT_TYPE_CODE_P	int ,
								   @v_PATIENT_STAT_CODE_P	int,
								   @v_PATIENT_COND_CODE_p	int,
								   @v_ACUITY_LEVEL_CODE_P	int,
								   @v_ADM_SOURCE_CODE_P	int,
								   @v_ADM_TYPE_CODE_P	int ,
								   @v_DISCHARGE_DSP_CODE_P	int,
								   @v_QI_SIGNIF_CODE_P	int,
								   @v_FACILITY_UNIT_CODE_P	int,
								   @v_FACILITY_DEPT_P	int ,
								   @v_WHY_AT_FACILITY_P	varchar(max),
								   @v_ADMISSION_REASON_P	varchar(max),
								   @i_PRI_PHYSICIAN_EID_P int ,
								   @i_ADM_PHYSICIAN_EID_P int ,
								   @v_WEIGHT_P int ,
								   @v_MARITAL_STAT_CODE_P	int,
								   @v_DATE_OF_DEATH_P	varchar(8) ,
								   @v_HCO_ID_NO_P	varchar(20) ,
								   @v_HCO_SITE_ID_NO_P	varchar(20),
								   @i_PRIMARY_PAY_CODE_P INT ,
									@i_SECOND_PAY_CODE_P INT,
									@i_CARDIAC_ARREST_P BIT ,
									@i_RACE_ENTH_CODE_P INT' ,	
								   @i_PATIENT_ID_P =  @i_PATIENT_ID_GEN ,
								   @i_PATIENT_EID_P = @i_PI_TYPE_ENTITY_ID_GEN ,
								   @v_PATIENT_ACCT_NO_P	= @v_PATIENT_ACCT_NO,
								   @v_MEDICAL_RCD_NO_P	= @v_MEDICAL_RCD_NO ,
								   @v_INS_PLAN_GROUP_NO_P	= @v_INS_PLAN_GROUP_NO,
								   @v_DATE_OF_ADMISSION_P	= @v_DATE_OF_ADMISSION ,
								   @v_DATE_OF_DISCHARGE_P	= @v_DATE_OF_DISCHARGE ,
								   @v_EPISODE_OF_CARE_ID_P = @v_EPISODE_OF_CARE_ID ,	
								   @v_EMERGENCY_CONTACT_P = @v_EMERGENCY_CONTACT ,	
								   @v_EMERGENCY_CONT_NO_P	= @v_EMERGENCY_CONT_NO ,
								   @v_PATIENT_ROOM_NO_P	= @v_PATIENT_ROOM_NO ,
								   @v_EXP_LENGTH_OF_STAY_P = @v_EXP_LENGTH_OF_STAY,
								   @v_EXPECTED_COST_P	 =  @v_EXPECTED_COST ,
								   @v_PATIENT_TYPE_CODE_P = @PATIENT_TYPE_CODE_R,
								   @v_PATIENT_STAT_CODE_P = @PATIENT_STAT_CODE_R ,
								   @v_PATIENT_COND_CODE_p = @PATIENT_COND_CODE_R ,	
								   @v_ACUITY_LEVEL_CODE_P = @ACUITY_LEVEL_CODE_R ,	
								   @v_ADM_SOURCE_CODE_P	  = @ADM_SOURCE_CODE_R ,
								   @v_ADM_TYPE_CODE_P	  = @ADM_TYPE_CODE_R ,
								   @v_DISCHARGE_DSP_CODE_P = @DISCHARGE_DSP_CODE_R ,
								   @v_QI_SIGNIF_CODE_P	= @QI_SIGNIF_CODE_R ,
								   @v_FACILITY_UNIT_CODE_P = @FACILITY_UNIT_CODE_R ,	
								   @v_FACILITY_DEPT_P	=   @i_FACILITY_DEPT_GEN,
								   @v_WHY_AT_FACILITY_P	= @v_WHY_AT_FACILITY ,
								   @v_ADMISSION_REASON_P = @v_ADMISSION_REASON , 										 
								   @i_PRI_PHYSICIAN_EID_P =	@i_PRI_PHYSICIAN_EID_GEN  ,
								   @i_ADM_PHYSICIAN_EID_P =  @i_ADM_PHYSICIAN_EID_GEN ,
								   @v_WEIGHT_P            = @v_WEIGHT ,
								   @v_MARITAL_STAT_CODE_P	= @MARITAL_STAT_CODE_R ,
								   @v_DATE_OF_DEATH_P   = @v_DATE_OF_DEATH ,
								   @v_HCO_ID_NO_P        = @v_HCO_ID_NO ,
								   @v_HCO_SITE_ID_NO_P	 = @v_HCO_SITE_ID_NO ,
								   @i_PRIMARY_PAY_CODE_P = 0,
									@i_SECOND_PAY_CODE_P = 0,
									@i_RACE_ENTH_CODE_P  = 0,
									@i_CARDIAC_ARREST_P = 0 ;
					--END TRY
					--BEGIN CATCH	
					--			 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					--			 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					--					@p_MODULE_NAME = @V_MODULENAME ,
					--					@p_CALLING_ERROR_LOCATION = 'Main', 
					--					@p_CURRENT_ERROR_LOCATION = 'PATIENTINS', 
					--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
					--					@p_ERROR_COLUMNS = NULL , 
					--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
					--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					--					@P_IS_VALIDATION = 0 ; 	
					--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
					--	END CATCH
							SET @V_ERROR_LOCATION = 'I48' 	   
		
		BEGIN  -- Update NEXT_UNIQUE_ID in glossary	for Patients 
									SET  @V_NEXT_UNIQUE_ID = @i_PATIENT_ID_GEN +  1 ; 
									SET @V_ERROR_LOCATION = 'I49' 	
									SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + ' GLOSSARY  SET NEXT_UNIQUE_ID = @V_NEXT_UNIQUE_ID_P ' ;
									SET	 @N_SQL = @N_SQL + ' WHERE SYSTEM_TABLE_NAME = ''PATIENTS''' ;									
										--BEGIN TRY
										Exec sp_Executesql @N_SQL, 
											 N' @V_NEXT_UNIQUE_ID_P varchar(255)',	
											 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID ;									 
										--END TRY
										--BEGIN CATCH	
										-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--		@p_MODULE_NAME = @V_MODULENAME ,
										--		@p_CALLING_ERROR_LOCATION = 'Main', 
										--		@p_CURRENT_ERROR_LOCATION = 'UPDNEXTPATNT', 
										--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--		@p_ERROR_COLUMNS = NULL , 
										--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--		@P_IS_VALIDATION = 0 ; 	
										--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
										--END CATCH
										SET @V_ERROR_LOCATION = 'I50'
									END	
		END
END 
--PRINT 'ENETERD PATIENT2'
BEGIN										-- PIIns9.INSERT INTO PATIENT REALTED TABLE

	
						SET @I_COUNT = 0;
						SET @vColList = 'BODY_PART|DIAGNOSIS|TREATMENT|'
						SET @vTableList = 'PATIENT_BODY_PART|PATIENT_DIAGNOSIS|PATIENT_TREATMENT|'

						WHILE CHARINDEX('|',@vColList,1) > 0				--
						BEGIN
							
							SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
							SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
							SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
							SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))
							SET @iCount = 1
							WHILE @iCount <= 5
							BEGIN	
								SET @vColToProcess = @vColName + '_' + CAST(@iCount as VARCHAR) + '_CODE'						 
								SET @vVal = (CASE
								WHEN @vColToProcess = 'BODY_PART_1_CODE' THEN @BODY_PART_1_CODE_R
								WHEN @vColToProcess = 'BODY_PART_2_CODE' THEN @BODY_PART_2_CODE_R		
								WHEN @vColToProcess = 'BODY_PART_3_CODE' THEN @BODY_PART_3_CODE_R
								WHEN @vColToProcess = 'BODY_PART_4_CODE' THEN @BODY_PART_4_CODE_R		
								WHEN @vColToProcess = 'BODY_PART_5_CODE' THEN @BODY_PART_5_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_1_CODE' THEN @DIAGNOSIS_1_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_2_CODE' THEN @DIAGNOSIS_2_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_3_CODE' THEN @DIAGNOSIS_3_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_4_CODE' THEN @DIAGNOSIS_4_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_5_CODE' THEN @DIAGNOSIS_5_CODE_R
								WHEN @vColToProcess = 'TREATMENT_1_CODE' THEN @TREATMENT_1_CODE_R
								WHEN @vColToProcess = 'TREATMENT_2_CODE' THEN @TREATMENT_2_CODE_R
								WHEN @vColToProcess = 'TREATMENT_3_CODE' THEN @TREATMENT_3_CODE_R
								WHEN @vColToProcess = 'TREATMENT_4_CODE' THEN @TREATMENT_4_CODE_R
								WHEN @vColToProcess = 'TREATMENT_5_CODE' THEN @TREATMENT_5_CODE_R
								END)
						IF 	@vVal IS NOT NULL	
							BEGIN
								SET @i_PATIENT_EID	= 0
								SET @vColInRM = @vColName +  '_CODE'										
								SET @V_ERROR_LOCATION = 'I51'
								SET @N_SQL = 'SELECT @PATIENT_EID_OP = PATIENT_ID  FROM '+ @V_DBName + @vTableName ;
								SET @N_SQL = @N_SQL + ' WHERE PATIENT_ID  = @PATIENT_ID_P AND '  + @vColInRM + ' = @vVal_P  ' ;
								--BEGIN TRY
											Exec sp_Executesql @N_SQL,
												N'@PATIENT_ID_P INT ,
												@PATIENT_EID_OP  INT OUTPUT ,
												@vVal_P INT ',						
												@PATIENT_ID_P = @i_PATIENT_ID_GEN  ,
												@vVal_P = @vVal ,		
												@PATIENT_EID_OP = @i_PATIENT_EID OUTPUT ;
								--END TRY
								--BEGIN CATCH	
								--	 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--	 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--			@p_MODULE_NAME = @V_MODULENAME ,
								--			@p_CALLING_ERROR_LOCATION = 'Main', 
								--			@p_CURRENT_ERROR_LOCATION = 'BDTFP1', 
								--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--			@p_ERROR_COLUMNS = NULL , 
								--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--			@P_IS_VALIDATION = 0 ; 		
								--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		 
								--END CATCH
								SET @V_ERROR_LOCATION = 'I52'
								IF @i_PATIENT_EID = 0
								BEGIN  
										SET @V_ERROR_LOCATION = 'I53'
										SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME + @vTableName + ' (PATIENT_ID,' + @vColInRM + ') VALUES ( ' + CAST(@i_PATIENT_ID_GEN AS VARCHAR) + ',' ;
										SET @N_SQL_EVENT = @N_SQL_EVENT	  + ISNULL(CAST(@vVal AS VARCHAR ),0) + ')' ;
										--BEGIN TRY
										Exec sp_Executesql @N_SQL_EVENT ;		
										--END TRY
										--BEGIN CATCH	
										-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--		@p_MODULE_NAME = @V_MODULENAME ,
										--		@p_CALLING_ERROR_LOCATION = 'Main', 
										--		@p_CURRENT_ERROR_LOCATION = 'BDTFP2', 
										--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--		@p_ERROR_COLUMNS = NULL , 
										--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--		@P_IS_VALIDATION = 0 ; 	
										--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
										--END CATCH	
										SET @V_ERROR_LOCATION = 'I54'		
								END		
							END			SET @iCount = @iCount + 1							
								
							END	
						END


END
--PRINT 'ENETERD PATIENT3'
BEGIN										-- PIIns10. Existence Checked  and INSERT INTO ILLNESS /INJURY INSERT (because of above condition) 
	--SET @v_DISABILITY_CODE = 'INJ' --SAM
	IF (UPPER(@v_DISABILITY_CODE) = 'ILL')
	BEGIN	
	IF @ILLNESS_CODE_R IS NOT NULL AND @ILLNESS_CODE_R <> 0
	 BEGIN				
		SET @V_ERROR_LOCATION = 'I55'
		SET @N_SQL_EVENT = 'UPDATE ' + @V_DBNAME  + ' PATIENT SET  ILLNESS_CODE = ' + ISNULL(CAST (@ILLNESS_CODE_R  AS VARCHAR),0)
		SET @N_SQL_EVENT = @N_SQL_EVENT + ', DISABILITY_CODE = ' + CAST (@DISABILITY_CODE_R AS VARCHAR ) + ' WHERE PATIENT_ID =  ' + CAST (@i_PATIENT_ID_GEN AS VARCHAR ) 						
							--BEGIN TRY
							Exec sp_Executesql @N_SQL_EVENT; 
							--END TRY
							--BEGIN CATCH	
							--			SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--				@p_MODULE_NAME = @V_MODULENAME ,
							--				@p_CALLING_ERROR_LOCATION = 'Main', 
							--				@p_CURRENT_ERROR_LOCATION = 'ILL/INJP1', 
							--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--				@p_ERROR_COLUMNS = NULL , 
							--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--				@P_IS_VALIDATION = 0 ;
							--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
							--END CATCH	
							SET @V_ERROR_LOCATION = 'I56'
	 END		
						
	END
	ELSE IF (UPPER(@v_DISABILITY_CODE) = 'INJ') --  INJURY EXISTENCE AND  INSERT 
	BEGIN
				SET @V_ERROR_LOCATION = 'I57'
			
			SET @N_SQL_EVENT = 'UPDATE ' + @V_DBNAME  + ' PATIENT SET  DISABILITY_CODE =  ' + CAST (@DISABILITY_CODE_R AS VARCHAR ) 
			SET @N_SQL_EVENT = @N_SQL_EVENT +  + ' WHERE PATIENT_ID =  ' + CAST (@i_PATIENT_ID_GEN AS VARCHAR ) 
					--BEGIN TRY
					Exec sp_Executesql @N_SQL_EVENT ;
				--	END TRY
				--	BEGIN CATCH	
				--			SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				--			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				--				@p_MODULE_NAME = @V_MODULENAME ,
				--				@p_CALLING_ERROR_LOCATION = 'Main', 
				--				@p_CURRENT_ERROR_LOCATION = 'ILL/INJP2', 
				--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
				--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
				--				@p_ERROR_COLUMNS = NULL , 
				--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
				--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				--				@P_IS_VALIDATION = 0 ; 	
				--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				--	END CATCH
				----SET @INJURY_1_CODE_R =8 ; --SAM
				--SET @INJURY_2_CODE_R = 9 --SAM
					SET @V_ERROR_LOCATION = 'I58'
				SET @iCount = 1
				WHILE (@iCount < 6 )							
					BEGIN				
				SET @vColName = '@v_INJURY_' + cast (@iCount as varchar )+ '_CODE'
				SET @vVal = ( CASE
				WHEN @vColName = '@v_INJURY_1_CODE' THEN @INJURY_1_CODE_R
				WHEN @vColName = '@v_INJURY_2_CODE' THEN @INJURY_2_CODE_R
				WHEN @vColName = '@v_INJURY_3_CODE' THEN @INJURY_3_CODE_R
				WHEN @vColName = '@v_INJURY_4_CODE' THEN @INJURY_4_CODE_R
				WHEN @vColName = '@v_INJURY_5_CODE' THEN @INJURY_5_CODE_R	
				END)
				IF @vVal IS NOT NULL
					BEGIN
						SET @i_PATIENT_EID = 0 ; 
						SET @V_ERROR_LOCATION = 'I59'
						SET @N_SQL = 'SELECT @PATIENT_ID_P = PATIENT_ID  FROM '+ @V_DBName + 'PATIENT_INJURY' ;
						SET @N_SQL = @N_SQL + ' WHERE PATIENT_ID  = @PATIENT_ID_P AND INJURY_CODE = @vVal_P  ' ;
							--BEGIN TRY
							Exec sp_Executesql @N_SQL,
								N' @PATIENT_ID_P INT , 
								@PATIENT_ID_OP INT OUTPUT,
								@vVal_P INT ',						
								@PATIENT_ID_P = @i_PI_TYPE_ENTITY_ID_GEN  ,
								@PATIENT_ID_OP	= @i_PATIENT_EID ,
								@vVal_P = @vVal ;	
							--END TRY
							--BEGIN CATCH	
							--		SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--			@p_MODULE_NAME = @V_MODULENAME ,
							--			@p_CALLING_ERROR_LOCATION = 'Main', 
							--			@p_CURRENT_ERROR_LOCATION = 'ILL/INJP3', 
							--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--			@p_ERROR_COLUMNS = NULL , 
							--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--			@P_IS_VALIDATION = 0 ; 		
							--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		 
							--END CATCH
								SET @V_ERROR_LOCATION = 'I60'
			IF @i_PATIENT_EID = 0
				BEGIN 
					SET @V_ERROR_LOCATION = 'I61'
					SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME +  ' PATIENT_INJURY (PATIENT_ID, INJURY_CODE ) VALUES ( ' + CAST(@i_PATIENT_ID_GEN AS VARCHAR) + ',' ;
					SET @N_SQL_EVENT = @N_SQL_EVENT	  + ISNULL(CAST(@vVal AS VARCHAR ),0) + ')' ;												
									--BEGIN TRY
									Exec sp_Executesql @N_SQL_EVENT ;
									--END TRY
									--BEGIN CATCH	
									--	SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
									--	EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
									--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
									--		@p_MODULE_NAME = @V_MODULENAME ,
									--		@p_CALLING_ERROR_LOCATION = 'Main', 
									--		@p_CURRENT_ERROR_LOCATION = 'ILL/INJ4', 
									--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
									--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
									--		@p_ERROR_COLUMNS = NULL , 
									--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
									--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
									--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
									--		@P_IS_VALIDATION = 0 ; 	
									--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
								 --  END CATCH
				SET @V_ERROR_LOCATION = 'I62'
			END	
	END
										
						SET @iCount = @iCount + 1 ;
			END
	END
END	
--PRINT 'ENETERD PATIENT4'
 END 

END											
	
END	
										
									--*************************************************************************
									--********PERSON INVOLVED and its Related tables INSERT ENDS  ************	
									--*************************************************************************
											
											
									--*************************************************************************
									--********PERSON INVOLVED and its Related tables COMMON STARTS  ************		
									--*************************************************************************
	
IF (@I_ERRORCOUNT = 0 AND @i_EVENT_ID > 0 AND @i_PI_TYPE_ENTITY_ID_GEN > 0 AND (@i_PI_ROW_ID > 0))	 --CWZ	
BEGIN

IF UPPER(@v_PI_TYPE_CODE) = 'E'                                     
BEGIN					
BEGIN   
		
						--PRINT 'PIIns3. ENTERED'--MK(remove)
							SET @V_ERROR_LOCATION = 'I63'
						--SET		@N_SQL_EVENT = NULL ;
		 			    SET  @N_SQL_EVENT = ' UPDATE ' + @V_DBNAME + ' PERSON_INVOLVED  SET PI_ROW_ID =  @i_PI_ROW_ID_P ' ; 	--JIRA RMA - 20453
						IF   @v_EMPLOYEE_NUMBER IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',EMPLOYEE_NUMBER = @v_EMPLOYEE_NUMBER_P'						
						IF   @v_DATE_HIRED IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_HIRED = @v_DATE_HIRED_P'
						IF   @v_WEEKLY_RATE IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',WEEKLY_RATE = @v_WEEKLY_RATE_P'
						IF   @v_HOURLY_RATE IS NOT NULL
						SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',HOURLY_RATE = @v_HOURLY_RATE_P'
						IF  @i_SUPERVISOR_ENTITY_ID_GEN IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',SUPERVISOR_EID = @v_SUPERVISOR_EID_P'
						IF  @v_WEEKLY_HOURS IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',WEEKLY_HOURS = @v_WEEKLY_HOURS_P'
						IF  @v_DRIVERS_LIC_NO IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVERS_LIC_NO = @v_DRIVERS_LIC_NO_P'
						IF  @v_DATE_DRIVERSLICEXP IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',DATE_DRIVERSLICEXP = @v_DATE_DRIVERSLICEXP_P'
						IF  @DRIVLIC_STATE_R IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',DRIVLIC_STATE =  @v_DRIVLIC_STATE_P'
						IF  @POSITION_CODE_R IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',POSITION_CODE = @v_POSITION_CODE_P'
						IF  @NCCI_CLASS_CODE_R IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',NCCI_CLASS_CODE = @v_NCCI_CLASS_CODE_P'
						IF  @i_DEPT_ASSIGNED_GEN IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',DEPT_ASSIGNED_EID = @v_DEPT_ASSIGNED_EID_P'						
						IF  @v_FULL_TIME_FLAG_GEN IS NOT NULL
						SET @N_SQL_EVENT = @N_SQL_EVENT  + ',FULL_TIME_FLAG = @v_FULL_TIME_FLAG_P'
						IF @v_ACTIVE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',ACTIVE_FLAG = @v_ACTIVE_FLAG_P'
						IF @v_EXEMPT_STATUS_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',EXEMPT_STATUS_FLAG = @v_EXEMPT_STATUS_FLAG_P'
						IF @v_NO_OF_EXEMPTIONS IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',NO_OF_EXEMPTIONS = @v_NO_OF_EXEMPTIONS_P'
						IF @PAY_TYPE_CODE_R IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',PAY_TYPE_CODE = @v_PAY_TYPE_CODE_P'
						IF @v_PAY_AMOUNT IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',PAY_AMOUNT = @v_PAY_AMOUNT_P'							
						IF @v_WORK_SUN_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_SUN_FLAG = @v_WORK_SUN_FLAG_P'
						IF @v_WORK_MON_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_MON_FLAG = @v_WORK_MON_FLAG_P'
						IF @v_WORK_TUE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_TUE_FLAG = @v_WORK_TUE_FLAG_P'
						IF @v_WORK_WED_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_WED_FLAG = @v_WORK_WED_FLAG_P'
						IF @v_WORK_THU_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_THU_FLAG = @v_WORK_THU_FLAG_P'
						IF @v_WORK_FRI_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_FRI_FLAG = @v_WORK_FRI_FLAG_P'
						IF @v_WORK_SAT_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_SAT_FLAG = @v_WORK_SAT_FLAG_P'
						IF @v_WORK_PERMIT_DATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_PERMIT_DATE =   @v_WORK_PERMIT_DATE_P'
						IF @v_WORK_PERMIT_NUMBER IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORK_PERMIT_NUMBER =  @v_WORK_PERMIT_NUMBER_P'
						IF @v_INSURABLE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',INSURABLE_FLAG = @v_INSURABLE_FLAG_P'
						IF @v_LAST_VERIFIED_DATE IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',LAST_VERIFIED_DATE =   @v_LAST_VERIFIED_DATE_P'						
						IF @v_WORKDAY_START_TIME IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',WORKDAY_START_TIME = @v_WORKDAY_START_TIME_P'
						IF @v_REGULAR_JOB_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',REGULAR_JOB_FLAG = @v_REGULAR_JOB_FLAG_P'
						IF @v_HIRED_IN_STATE_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',HIRED_IN_STE_FLAG = @v_HIRED_IN_STATE_FLAG_P'
						
						IF @v_LOST_WORK_FLAG_GEN IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',LOST_WORK_FLAG = @v_LOST_WORK_FLAG_P'
						IF @V_NUM_OF_VIOLATION IS NOT NULL
						SET	@N_SQL_EVENT = @N_SQL_EVENT  + ',NUM_OF_VIOLATIONS = @V_NUM_OF_VIOLATION_P'

						--dsharma70 hmi
						IF @HEALTH_LOB_ID > 0 SET  @N_SQL_EVENT = @N_SQL_EVENT  + ',BENEFICIARY_CODE = @BENEFICIARY_CODE_ID'
						
						SET	 @N_SQL_EVENT = @N_SQL_EVENT + ' WHERE PI_ROW_ID =  @i_PI_ROW_ID_P ' ;	
							--PRINT '@N_SQL_EVENT AHNDLE ERROR' + @N_SQL_EVENT--MK(remove)
						
							--BEGIN TRY					
							EXEC sp_Executesql @N_SQL_EVENT,
									 N'@v_EMPLOYEE_NUMBER_P	varchar(20),
									 @v_DATE_HIRED_P	varchar(8),
									 @v_WEEKLY_RATE_P	decimal(20,2), 
									 @v_HOURLY_RATE_P	decimal(20,2) ,
									 @v_WEEKLY_HOURS_P	decimal(20,2) ,
									 @v_SUPERVISOR_EID_P int ,	 
									 @v_DRIVERS_LIC_NO_P	varchar(20),
									 @v_DATE_DRIVERSLICEXP_P	varchar(8),
									 @v_DRIVERSLICTYPECODE_P	INT,
									 @v_DRIVLIC_STATE_P	INT,
									 @v_POSITION_CODE_P	INT,
									 @v_NCCI_CLASS_CODE_P	INT,
									 @v_DEPT_ASSIGNED_EID_P	INT,
									 @v_FULL_TIME_FLAG_P	INT,
									 @v_ACTIVE_FLAG_P	INT,
									 @v_EXEMPT_STATUS_FLAG_P INT ,
									 @v_NO_OF_EXEMPTIONS_P	INT,
									 @v_PAY_TYPE_CODE_P	INT,
									 @v_PAY_AMOUNT_P	decimal(20,2),
									 @v_WORK_SUN_FLAG_P	INT,
									 @v_WORK_MON_FLAG_P	INT,
									 @v_WORK_TUE_FLAG_P	INT,
									 @v_WORK_WED_FLAG_P	INT,
									 @v_WORK_THU_FLAG_P	INT,
									 @v_WORK_FRI_FLAG_P	INT,
									 @v_WORK_SAT_FLAG_P	INT,
									 @v_WORK_PERMIT_DATE_P	varchar(8),
									 @v_WORK_PERMIT_NUMBER_P	varchar(50),
									 @v_INSURABLE_FLAG_P	INT,
									 @v_LAST_VERIFIED_DATE_P	varchar(8),
									 @v_WORKDAY_START_TIME_P	varchar(6),
									 @v_REGULAR_JOB_FLAG_P	INT,
									 @v_LOST_WORK_FLAG_P	INT,
									 @v_HIRED_IN_STATE_FLAG_P INT,
									 @V_NUM_OF_VIOLATION_P INT ,
									 @i_PI_ROW_ID_P AS INT,
									 @BENEFICIARY_CODE_ID INT', --dsharma70 hmi						  
									 @v_EMPLOYEE_NUMBER_P = @v_EMPLOYEE_NUMBER,
									 @v_DATE_HIRED_P	=  @v_DATE_HIRED,
									 @v_WEEKLY_RATE_P	= @v_WEEKLY_RATE ,
									 @v_HOURLY_RATE_P	= @v_HOURLY_RATE ,
									 @v_WEEKLY_HOURS_P	= @v_WEEKLY_HOURS , 
									 @v_SUPERVISOR_EID_P	=  @i_SUPERVISOR_ENTITY_ID_GEN ,
									 @v_DRIVERS_LIC_NO_P	= @v_DRIVERS_LIC_NO ,
									 @v_DATE_DRIVERSLICEXP_P =  @v_DATE_DRIVERSLICEXP ,	
									 @v_DRIVERSLICTYPECODE_P	= @DRIVERSLICTYPECODE_R  ,
									 @v_DRIVLIC_STATE_P	= @v_DRIVLIC_STATE_R ,
									 @v_POSITION_CODE_P	= @POSITION_CODE_R , --cww
									 @v_NCCI_CLASS_CODE_P	= @NCCI_CLASS_CODE_R ,
									 @v_DEPT_ASSIGNED_EID_P	= @i_DEPT_ASSIGNED_GEN ,
									 @v_FULL_TIME_FLAG_P	= @v_FULL_TIME_FLAG_GEN ,
									 @v_ACTIVE_FLAG_P	= @v_ACTIVE_FLAG_GEN ,
									 @v_EXEMPT_STATUS_FLAG_P = @v_EXEMPT_STATUS_FLAG_GEN ,
									 @v_NO_OF_EXEMPTIONS_P	= @v_NO_OF_EXEMPTIONS,
									 @v_PAY_TYPE_CODE_P	= @PAY_TYPE_CODE_R ,
									 @v_PAY_AMOUNT_P	=  @v_PAY_AMOUNT ,
									 @v_WORK_SUN_FLAG_P	 =  @v_WORK_SUN_FLAG_GEN ,
									 @v_WORK_MON_FLAG_P	=  @v_WORK_MON_FLAG_GEN,
									 @v_WORK_TUE_FLAG_P	=  @v_WORK_TUE_FLAG_GEN ,
									 @v_WORK_WED_FLAG_P	= @v_WORK_WED_FLAG_GEN ,
									 @v_WORK_THU_FLAG_P	= @v_WORK_THU_FLAG_GEN ,
									 @v_WORK_FRI_FLAG_P	= @v_WORK_FRI_FLAG_GEN ,
									 @v_WORK_SAT_FLAG_P	= @v_WORK_SAT_FLAG_GEN ,
									 @v_WORK_PERMIT_DATE_P	=  @v_WORK_PERMIT_DATE ,
									 @v_WORK_PERMIT_NUMBER_P =  @v_WORK_PERMIT_NUMBER ,
									 @v_INSURABLE_FLAG_P	= @v_INSURABLE_FLAG_GEN ,
									 @v_LAST_VERIFIED_DATE_P = @v_LAST_VERIFIED_DATE ,	
									 @v_WORKDAY_START_TIME_P =  @v_WORKDAY_START_TIME,
									 @v_REGULAR_JOB_FLAG_P	= @v_REGULAR_JOB_FLAG_GEN ,
									 @v_HIRED_IN_STATE_FLAG_P = @v_HIRED_IN_STATE_FLAG_GEN ,
									 @v_LOST_WORK_FLAG_P	= @v_LOST_WORK_FLAG_GEN ,
									 @V_NUM_OF_VIOLATION_P  = @V_NUM_OF_VIOLATION ,
									 @i_PI_ROW_ID_P = @i_PI_ROW_ID,
									 @BENEFICIARY_CODE_ID = @BENEFICIARY_CODE_ID ; --dsharma70 hmi RMA-24634
						--	END TRY
						--	BEGIN CATCH	
						--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--				@p_MODULE_NAME = @V_MODULENAME ,
						--				@p_CALLING_ERROR_LOCATION = 'Main', 
						--				@p_CURRENT_ERROR_LOCATION = 'PIINS2', 
						--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--				@p_ERROR_COLUMNS = NULL , 
						--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--				@P_IS_VALIDATION = 0 ; 
						--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
						--END CATCH
								SET @V_ERROR_LOCATION = 'I64'
										
		--PRINT 'PIIns3. ENT'	--MK(remove)
						
	 				 -- DRIVLIC_RSTRCTCODE, HIRED_IN_STE_FLAG ,  in vb code bt nt in import filr DOUBT
						 
	END					-- INSERT/UPDATE into PI table WHEN PI_TYPE_CODE IS 'E' INSERT INTO PI 
IF  (@v_LOST_WORK_FLAG_GEN <> 0) --  PIUP3. Existence Checked  and INSERT INTO PI_X_WORK_LOSS INSERT (because of above condition)
--PRINT 'FLAG NETERE'
BEGIN 
							
						SET @vColName1   = 'DATE_LAST_WORKED'
					  	SET @vColName2 = 'DATE_RETURNED'
							SET @iCount = 1
		WHILE @iCount <= 15
		BEGIN
							--SET @v_DATE_LAST_WORKED_1 = '21051213' --SAM
							--SET @v_DATE_RETURNED_1 = '20151215' --SAM
							--SET @v_DATE_LAST_WORKED_1 = '21051216'--SAM
							--SET @v_DATE_RETURNED_1 = '20151218'--SAM
							SET @vColToProcess = @vColName1 + '_' + CAST(@iCount as VARCHAR)							
							
								SET @vVal = (CASE
								WHEN @vColToProcess = 'DATE_LAST_WORKED_1' THEN @v_DATE_LAST_WORKED_1
								WHEN @vColToProcess = 'DATE_LAST_WORKED_2' THEN @v_DATE_LAST_WORKED_2					
								WHEN @vColToProcess = 'DATE_LAST_WORKED_3' THEN @v_DATE_LAST_WORKED_3
								WHEN @vColToProcess = 'DATE_LAST_WORKED_4' THEN @v_DATE_LAST_WORKED_4
								WHEN @vColToProcess = 'DATE_LAST_WORKED_5' THEN @v_DATE_LAST_WORKED_5	
								WHEN @vColToProcess = 'DATE_LAST_WORKED_6' THEN @v_DATE_LAST_WORKED_6
								WHEN @vColToProcess = 'DATE_LAST_WORKED_7' THEN @v_DATE_LAST_WORKED_7					
								WHEN @vColToProcess = 'DATE_LAST_WORKED_8' THEN @v_DATE_LAST_WORKED_8
								WHEN @vColToProcess = 'DATE_LAST_WORKED_9' THEN @v_DATE_LAST_WORKED_9
								WHEN @vColToProcess = 'DATE_LAST_WORKED_10' THEN @v_DATE_LAST_WORKED_10	
								WHEN @vColToProcess = 'DATE_LAST_WORKED_11' THEN @v_DATE_LAST_WORKED_11
								WHEN @vColToProcess = 'DATE_LAST_WORKED_12' THEN @v_DATE_LAST_WORKED_12					
								WHEN @vColToProcess = 'DATE_LAST_WORKED_13' THEN @v_DATE_LAST_WORKED_13
								WHEN @vColToProcess = 'DATE_LAST_WORKED_14' THEN @v_DATE_LAST_WORKED_14
								WHEN @vColToProcess = 'DATE_LAST_WORKED_15' THEN @v_DATE_LAST_WORKED_15															
								END)			
								SET @vColToProcess = @vColName2 + '_' + CAST(@iCount as VARCHAR) 					 
								
								SET @vVal2 = (CASE
								WHEN @vColToProcess = 'DATE_RETURNED_1'  THEN @v_DATE_RETURNED_1
								WHEN @vColToProcess = 'DATE_RETURNED_2'  THEN @v_DATE_RETURNED_2				
								WHEN @vColToProcess = 'DATE_RETURNED_3'  THEN @v_DATE_RETURNED_3
								WHEN @vColToProcess = 'DATE_RETURNED_4'  THEN @v_DATE_RETURNED_4
								WHEN @vColToProcess = 'DATE_RETURNED_5'  THEN @v_DATE_RETURNED_5	
								WHEN @vColToProcess = 'DATE_RETURNED_6'  THEN @v_DATE_RETURNED_6
								WHEN @vColToProcess = 'DATE_RETURNED_7'  THEN @v_DATE_RETURNED_7				
								WHEN @vColToProcess = 'DATE_RETURNED_8'  THEN @v_DATE_RETURNED_8
								WHEN @vColToProcess = 'DATE_RETURNED_9'  THEN @v_DATE_RETURNED_9
								WHEN @vColToProcess = 'DATE_RETURNED_10' THEN @v_DATE_RETURNED_10
								WHEN @vColToProcess = 'DATE_RETURNED_11' THEN @v_DATE_RETURNED_11
								WHEN @vColToProcess = 'DATE_RETURNED_12' THEN @v_DATE_RETURNED_12				
								WHEN @vColToProcess = 'DATE_RETURNED_13' THEN @v_DATE_RETURNED_13
								WHEN @vColToProcess = 'DATE_RETURNED_14' THEN @v_DATE_RETURNED_14
								WHEN @vColToProcess = 'DATE_RETURNED_15' THEN @v_DATE_RETURNED_15													
								END)	
									--PRINT '@vVal' + @vVal;
									--PRINT '@vVal2' + @vVal;
									--PRINT '@vVal3' + @vVal;
							
			IF ( @vVal IS NOT NULL AND  @vVal2 IS NOT NULL  )  
			    BEGIN 		
								SET @i_PI_ROW_ID_OP	= 0 ;			
								SET @V_ERROR_LOCATION = 'I65'
								SET @N_SQL = 'SELECT @PI_ROW_ID_OP = PI_ROW_ID  FROM '+ @V_DBName +  ' PI_X_WORK_LOSS ' ;
								SET @N_SQL = @N_SQL + ' WHERE PI_ROW_ID  = @PI_ROW_ID_P AND  DATE_LAST_WORKED  = @vVal_P  AND DATE_RETURNED = @vVal_2P ' ;								
								--BEGIN TRY
								Exec sp_Executesql @N_SQL,
												N' @PI_ROW_ID_OP INT OUTPUT ,												
												@PI_ROW_ID_P INT ,
												@vVal_P VARCHAR (255),
												@vVal_2P VARCHAR (255) ',
												@PI_ROW_ID_OP = @i_PI_ROW_ID_OP OUTPUT ,						
												@PI_ROW_ID_P = @i_PI_ROW_ID  ,
												@vVal_P = @vVal,
												@vVal_2P = @vVal2 ;												
								--END TRY
								--BEGIN CATCH	
								-- SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								-- EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--		@p_MODULE_NAME = @V_MODULENAME ,
								--		@p_CALLING_ERROR_LOCATION = 'Main', 
								--		@p_CURRENT_ERROR_LOCATION = 'WLINS', 
								--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--		@p_ERROR_COLUMNS = NULL , 
								--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--		@P_IS_VALIDATION = 0 ;
								--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
								--END CATCH
						SET @V_ERROR_LOCATION = 'I66'
					 IF (@i_PI_ROW_ID_OP = 0 )			    	
					 BEGIN 					-- 1.PI_WL_ROW_ID (NEXT_UNIQUE_ID)GENRATED FROM RMDB 				
											SET	  @N_SQL = 'SELECT @V_NEXT_UNIQUE_ID_P = NEXT_UNIQUE_ID FROM ' + @V_DBNAME + 'GLOSSARY G ' ;
											SET	  @N_SQL =  @N_SQL + ' WHERE  SYSTEM_TABLE_NAME = ''PI_X_WORK_LOSS'' ' ;
											----BEGIN TRY
											Exec sp_Executesql @N_SQL, 
												 N' @V_NEXT_UNIQUE_ID_P varchar(255) OUTPUT',
												 @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID OUTPUT;										
											--END TRY
											--BEGIN CATCH	
											--	SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	
											--   EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											--		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											--		@p_MODULE_NAME = @V_MODULENAME ,
											--		@p_CALLING_ERROR_LOCATION = 'Main', 
											--		@p_CURRENT_ERROR_LOCATION = 'ILL/INJPI1', 
											--		@p_ERROR_PROC_NAME = @V_PROCNAME ,
											--		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											--		@p_ERROR_COLUMNS = NULL , 
											--		@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											--		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											--		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											--		@P_IS_VALIDATION = 0 ; 
											--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;	
																 
											--END CATCH		
									SET @V_ERROR_LOCATION = 'I67'
											IF ((@V_NEXT_UNIQUE_ID IS NULL) OR (@V_NEXT_UNIQUE_ID = 0 ))
												BEGIN
													SET @V_NEXT_UNIQUE_ID = 1
												END	
											SET	  @i_PI_WL_ROW_ID       = @V_NEXT_UNIQUE_ID ;	
											--PRINT '@V_NEXT_UNIQUE_ID GENERATED :' + @V_NEXT_UNIQUE_ID ;
																		
									END	
					 IF (@i_PI_ROW_ID_OP = 0 )  --  2. INSERT INTO PI  
						BEGIN					
								 
						  	
									SET @V_ERROR_LOCATION = 'I68'
							SET @N_SQL_EVENT = 'INSERT INTO ' + @V_DBNAME  +  ' PI_X_WORK_LOSS (PI_ROW_ID,PI_WL_ROW_ID,DATE_LAST_WORKED,DATE_RETURNED , DURATION) ' 
							SET @N_SQL_EVENT = @N_SQL_EVENT +  ' VALUES ( ' +   CAST(@i_PI_ROW_ID AS VARCHAR) + ',' +   CAST(@i_PI_WL_ROW_ID AS VARCHAR) + ',' 						 
							SET @N_SQL_EVENT = @N_SQL_EVENT +   ISNULL (CAST (@vVal AS VARCHAR),0)	 +  ','  + ISNULL(CAST (@vVal2 AS VARCHAR),0) + ',' + ISNULL(CAST (@V_DURATION AS VARCHAR),0) + ' )' 						 										 
										--BEGIN TRY
										Exec sp_Executesql @N_SQL_EVENT ;
										--END TRY
										--BEGIN CATCH	
										--	SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										--EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--	@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--	@p_MODULE_NAME = @V_MODULENAME ,
										--	@p_CALLING_ERROR_LOCATION = 'Main', 
										--	@p_CURRENT_ERROR_LOCATION = 'WLINS2', 
										--	@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--	@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--	@p_ERROR_COLUMNS = NULL , 
										--	@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--	@p_ERROR_KEY_COLUMN ='EVENT_NUMBER',  
										--	@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--	@P_IS_VALIDATION = 0 ;
										--	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
										--END CATCH

											SET @V_ERROR_LOCATION = 'I69'
						--DURATION FOUND IN VB CODE BUT NOT IN IMPORT FILE					
							
						
										-- 3. Update NEXT_UNIQUE_ID for PERSON_INVOLVED in glossary						
						
						SET  @V_NEXT_UNIQUE_ID = @i_PI_WL_ROW_ID +  1 ; 
							SET @V_ERROR_LOCATION = 'I70'
						SET	 @N_SQL = 'UPDATE' + @V_DBNAME + 'GLOSSARY  SET NEXT_UNIQUE_ID = @V_NEXT_UNIQUE_ID_P ' ;
						SET	 @N_SQL = @N_SQL + ' WHERE SYSTEM_TABLE_NAME = ''PI_X_WORK_LOSS''' ;									
								--BEGIN TRY
							Exec sp_Executesql @N_SQL, 
								N' @V_NEXT_UNIQUE_ID_P varchar(255)',
								@V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID ;
								--END TRY
								--		BEGIN CATCH	
								--			SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
								--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								--			@p_MODULE_NAME = @V_MODULENAME ,
								--			@p_CALLING_ERROR_LOCATION = 'Main', 
								--			@p_CURRENT_ERROR_LOCATION = 'WLINS3', 
								--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
								--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
								--			@p_ERROR_COLUMNS = NULL , 
								--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
								--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
								--			@P_IS_VALIDATION = 0 ; 
								--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 

								--		END CATCH	
								SET @V_ERROR_LOCATION = 'I70'	 
				        END	
				END
		
							SET @iCount = @iCount + 1
		END


END 

END
 
--IF  (upper(@v_PI_TYPE_CODE) = 'E') OR (upper(@v_PI_TYPE_CODE) = 'P') -- mkaur24 qa
--BEGIN
BEGIN				-- A.  Existence Checked  and INSERT INTO RLATED TABLES (because of above condition)( BODY_PART|DIAGNOSIS|TREATMENT|)  
--PRINT '-- PIIns7. ODY_PART|DIA ENTERED'
						
						SET @I_COUNT = 0;
						SET @vColList = 'BODY_PART|DIAGNOSIS|TREATMENT|'
						SET @vTableList = 'PI_X_BODY_PART|PI_X_DIAGNOSIS|PI_X_TREATMENT|'

						WHILE CHARINDEX('|',@vColList,1) > 0				--
						BEGIN
							
							SET @vColName = LEFT(@vColList,CHARINDEX('|',@vColList,1) - 1)
							SET @vColList = RIGHT(@vColList,(LEN(@vColList) - CHARINDEX('|',@vColList,1)))
							SET @vTableName = LEFT(@vTableList,CHARINDEX('|',@vTableList,1) - 1)
							SET @vTableList = RIGHT(@vTableList,(LEN(@vTableList) - CHARINDEX('|',@vTableList,1)))
					
					--SET @BODY_PART_1_CODE_R = 98 --SAM						
					--SET @BODY_PART_2_CODE_R = 92 --SAM	
					--SET @DIAGNOSIS_1_CODE_R = 98 --SAM	
					--SET @DIAGNOSIS_2_CODE_R = 938 --SAM	
					--SET @TREATMENT_1_CODE_R = 98 --SAM
					--SET @TREATMENT_2_CODE_R =829 --SAM
							SET @iCount = 1
							WHILE @iCount <= 5
							BEGIN	
								SET @vColToProcess = @vColName + '_' + CAST(@iCount as VARCHAR) + '_CODE'						 
								SET @vVal = (CASE
								WHEN @vColToProcess = 'BODY_PART_1_CODE' THEN @BODY_PART_1_CODE_R
								WHEN @vColToProcess = 'BODY_PART_2_CODE' THEN @BODY_PART_2_CODE_R		
								WHEN @vColToProcess = 'BODY_PART_3_CODE' THEN @BODY_PART_3_CODE_R
								WHEN @vColToProcess = 'BODY_PART_4_CODE' THEN @BODY_PART_4_CODE_R		
								WHEN @vColToProcess = 'BODY_PART_5_CODE' THEN @BODY_PART_5_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_1_CODE' THEN @DIAGNOSIS_1_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_2_CODE' THEN @DIAGNOSIS_2_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_3_CODE' THEN @DIAGNOSIS_3_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_4_CODE' THEN @DIAGNOSIS_4_CODE_R
								WHEN @vColToProcess = 'DIAGNOSIS_5_CODE' THEN @DIAGNOSIS_5_CODE_R
								WHEN @vColToProcess = 'TREATMENT_1_CODE' THEN @TREATMENT_1_CODE_R
								WHEN @vColToProcess = 'TREATMENT_2_CODE' THEN @TREATMENT_2_CODE_R
								WHEN @vColToProcess = 'TREATMENT_3_CODE' THEN @TREATMENT_3_CODE_R
								WHEN @vColToProcess = 'TREATMENT_4_CODE' THEN @TREATMENT_4_CODE_R
								WHEN @vColToProcess = 'TREATMENT_5_CODE' THEN @TREATMENT_5_CODE_R
								END)
						IF @vVal IS NOT NULL 
							BEGIN	
								SET @i_PI_ROW_ID_OP	= 0 ;								
								SET @vColInRM = @vColName +  '_CODE'										
								SET @V_ERROR_LOCATION = 'I71'	 
								SET @N_SQL = 'SELECT @PI_ROW_ID_OP = PI_ROW_ID  FROM '+ @V_DBName + @vTableName ;
								SET @N_SQL = @N_SQL + ' WHERE PI_ROW_ID  = @PI_ROW_ID_P AND '  + @vColInRM + ' = @vVal_P ' ;
								--BEGIN TRY
								Exec sp_Executesql @N_SQL,
												N' @PI_ROW_ID_OP INT OUTPUT ,												
												@PI_ROW_ID_P INT ,
												@vVal_P INT ',
												@PI_ROW_ID_OP = @i_PI_ROW_ID_OP OUTPUT ,						
												@PI_ROW_ID_P = @i_PI_ROW_ID  ,
												@vVal_P = @vVal  ;	
												
						--		END TRY
						--		BEGIN CATCH	
						--		 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--		 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--				@p_MODULE_NAME = @V_MODULENAME ,
						--				@p_CALLING_ERROR_LOCATION = 'Main', 
						--				@p_CURRENT_ERROR_LOCATION = 'BDT1', 
						--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--				@p_ERROR_COLUMNS = NULL , 
						--				@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--				@P_IS_VALIDATION = 0 ;
						--				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
						--END CATCH
								--SET @i_PI_ROW_ID_OP = 0 --SAM
								SET @V_ERROR_LOCATION = 'I72'	 
								IF @i_PI_ROW_ID_OP = 0
								BEGIN  
									SET @V_ERROR_LOCATION = 'I73'
										SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME + @vTableName + ' (PI_ROW_ID,' + @vColInRM + ') VALUES ( ' + CAST(@i_PI_ROW_ID AS VARCHAR) + ',' ;
										SET @N_SQL_EVENT = @N_SQL_EVENT	  + ISNULL(CAST(@vVal AS VARCHAR ),0) + ')' ;
										--BEGIN TRY
										Exec sp_Executesql @N_SQL_EVENT ;
										--END TRY
										--BEGIN CATCH	
										--	 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										--	 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
										--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
										--			@p_MODULE_NAME = @V_MODULENAME ,
										--			@p_CALLING_ERROR_LOCATION = 'Main', 
										--			@p_CURRENT_ERROR_LOCATION = 'BDT2', 
										--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
										--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
										--			@p_ERROR_COLUMNS = NULL , 
										--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
										--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
										--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
										--			@P_IS_VALIDATION = 0 ; 	
										--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
										--END CATCH
												SET @V_ERROR_LOCATION = 'I72'
								END	
								
							END	
										SET @iCount = @iCount + 1							
								
							END	
						END


--PRINT '-- PIIns7. ODY_PART|DIA END'
END	
BEGIN			-- B. Existence Checked  and INSERT INTO ILLNESS /INJURY INSERT (because of above condition) 
	--PRINT '-- PIIns7.  ENTERED ILLNESS /INJUR START'
	IF (@v_DISABILITY_CODE = 'ILL')
	BEGIN
	--SET @ILLNESS_CODE_R = 26 --SAM
	IF @ILLNESS_CODE_R IS NOT NULL AND @ILLNESS_CODE_R <> 0
		BEGIN					
			SET @V_ERROR_LOCATION = 'I73'
		SET @N_SQL_EVENT = 'UPDATE ' + @V_DBNAME  + ' PERSON_INVOLVED SET  ILLNESS_CODE = ' + ISNULL( CAST(@ILLNESS_CODE_R AS VARCHAR )  , 0 )
		SET @N_SQL_EVENT = @N_SQL_EVENT + ', DISABILITY_CODE = ' + CAST (@DISABILITY_CODE_R AS VARCHAR ) + ' WHERE PI_ROW_ID =  ' + CAST (@i_PI_ROW_ID AS VARCHAR ) 						
			--BEGIN TRY
			Exec sp_Executesql @N_SQL_EVENT ;
			--END TRY
			--BEGIN CATCH	
			--					 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
			--					 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
			--							@p_DA_ROW_ID  = @V_DA_ROW_ID , 
			--							@p_MODULE_NAME = @V_MODULENAME ,
			--							@p_CALLING_ERROR_LOCATION = 'Main', 
			--							@p_CURRENT_ERROR_LOCATION = 'ILL1', 
			--							@p_ERROR_PROC_NAME = @V_PROCNAME ,
			--							@p_ERROR_MSG = @V_ERROR_MESSAGE ,
			--							@p_ERROR_COLUMNS = NULL , 
			--							@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
			--							@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
			--							@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
			--							@P_IS_VALIDATION = 0 ; 	
			--							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
			--END CATCH
				SET @V_ERROR_LOCATION = 'I74'
		END
	END
	
	
	ELSE IF (@v_DISABILITY_CODE = 'INJ') --  INJURY EXISTENCE AND  INSERT 
	BEGIN
			SET @V_ERROR_LOCATION = 'I75'
		SET @N_SQL_EVENT = 'UPDATE ' + @V_DBNAME  + ' PERSON_INVOLVED SET  DISABILITY_CODE =  ' + CAST (@DISABILITY_CODE_R AS VARCHAR ) 
		SET @N_SQL_EVENT = @N_SQL_EVENT +   ' WHERE PI_ROW_ID =  ' + CAST (@i_PI_ROW_ID AS VARCHAR ) 
							--BEGIN TRY
							Exec sp_Executesql @N_SQL_EVENT ;
							--END TRY
							--	BEGIN CATCH	
							--	 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
							--	 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
							--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
							--			@p_MODULE_NAME = @V_MODULENAME ,
							--			@p_CALLING_ERROR_LOCATION = 'Main', 
							--			@p_CURRENT_ERROR_LOCATION = 'INJ1', 
							--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
							--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							--			@p_ERROR_COLUMNS = NULL , 
							--			@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
							--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							--			@P_IS_VALIDATION = 0 ;
							--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ; 				 
							--	END CATCH
									SET @V_ERROR_LOCATION = 'I76'
		--SET @INJURY_1_CODE_R = 56 --SAM
		--SET @INJURY_2_CODE_R = 57 --SAM
		SET @iCount = 1
			WHILE (@iCount < 6 )							
			BEGIN				
				SET @vColName = '@v_INJURY_' + cast (@iCount as varchar) + '_CODE'
				SET @vVal = ( CASE
				WHEN @vColName = '@v_INJURY_1_CODE' THEN @INJURY_1_CODE_R
				WHEN @vColName = '@v_INJURY_2_CODE' THEN @INJURY_2_CODE_R
				WHEN @vColName = '@v_INJURY_3_CODE' THEN @INJURY_3_CODE_R
				WHEN @vColName = '@v_INJURY_4_CODE' THEN @INJURY_4_CODE_R
				WHEN @vColName = '@v_INJURY_5_CODE' THEN @INJURY_5_CODE_R	
				END)
		IF @vVal IS NOT NULL
			BEGIN
				SET @i_PI_ROW_ID_OP = 0 ;
				SET @V_ERROR_LOCATION = 'I77'
				SET @N_SQL = 'SELECT @PI_ROW_ID_OP = PI_ROW_ID  FROM '+ @V_DBName + ' PI_X_INJURY' ;
				SET @N_SQL = @N_SQL + ' WHERE PI_ROW_ID  = @PI_ROW_ID_P AND INJURY_CODE = @vVal_P  ' ;
				--BEGIN TRY
					Exec sp_Executesql @N_SQL,
						N' @PI_ROW_ID_P INT ,
						@PI_ROW_ID_OP INT OUTPUT,
						@vVal_P INT ',						
						@PI_ROW_ID_P = @i_PI_ROW_ID  ,
						@PI_ROW_ID_OP = @i_PI_ROW_ID_OP OUTPUT , 
						@vVal_P = @vVal ;		
						
				--END TRY
				--		BEGIN CATCH	
				--				 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				--				 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				--						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				--						@p_MODULE_NAME = @V_MODULENAME ,
				--						@p_CALLING_ERROR_LOCATION = 'Main', 
				--						@p_CURRENT_ERROR_LOCATION = 'ILL/INJ2', 
				--						@p_ERROR_PROC_NAME = @V_PROCNAME ,
				--						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
				--						@p_ERROR_COLUMNS = NULL , 
				--						@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
				--						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				--						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				--						@P_IS_VALIDATION = 0 ; 	
				--						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				--		END CATCH
				--SET @i_PI_ROW_ID_OP = 0 --SAM
				IF @i_PI_ROW_ID_OP = 0
				BEGIN  
						SET @V_ERROR_LOCATION = 'I78'
					SET @N_SQL_EVENT = 'INSERT INTO '  +  @V_DBNAME +  ' PI_X_INJURY (PI_ROW_ID, INJURY_CODE ) VALUES ( ' + CAST(@i_PI_ROW_ID AS VARCHAR) + ',' ;
					SET @N_SQL_EVENT = @N_SQL_EVENT	  + ISNULL (CAST(@vVal AS VARCHAR ),0)+ ')' ;	
					--BEGIN TRY
					Exec sp_Executesql @N_SQL_EVENT ;	
					--END TRY
					--BEGIN CATCH	
					--			 SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					--			 EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					--					@p_MODULE_NAME = @V_MODULENAME ,
					--					@p_CALLING_ERROR_LOCATION = 'Main', 
					--					@p_CURRENT_ERROR_LOCATION = 'ILL/INJ3', 
					--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
					--					@p_ERROR_COLUMNS = NULL , 
					--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
					--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					--					@P_IS_VALIDATION = 0 ; 
					--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;				 
					--END CATCH	
							SET @V_ERROR_LOCATION = 'I79'									
				END	

			END					
				SET @iCount = @iCount + 1 ;
			END
	END
	--PRINT '-- PIIns7.  ENTERED ILLNESS /INJUR END'
END	
--END

END --PI TYPE UPDATE ENDS 
									--*************************************************************************
									--********PERSON INVOLVED and its Related tables COMMON ENDS ************		
									--*************************************************************************
				


				
									--*************************************************************************
									--*****************UPDATE PI DATA IN ENTITY STARTS ************************
									--*************************************************************************
				
				
IF (@i_PI_TYPE_ENTITY_ID_GEN > 0 AND @I_ERRORCOUNT = 0 )
BEGIN					
-- PRINT 'PI DATA IN ENTITY STARTS '			
							SET @V_ERROR_LOCATION = 'I80'	
						SET	 @N_SQL = 'UPDATE ' + @V_DBNAME + 'ENTITY SET ENTITY_ID = @i_PI_TYPE_ENTITY_ID_GEN_P ' ; 	--JIRA RMA - 20453				
						IF @v_PI_PHONE IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',PHONE1 = @v_PI_PHONE_P';											
						IF @v_PI_ADDR1 IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',ADDR1 = @v_PI_ADDR1_P';
						IF @v_PI_ADDR2 IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',ADDR2 = @v_PI_ADDR2_P';
						IF @v_PI_CITY IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',CITY = @v_PI_CITY_P';
						IF  @v_PI_STATE IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',STATE_ID =  @v_PI_STATE_P';
						IF @v_PI_ZIP_CODE IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',ZIP_CODE = @v_PI_ZIP_CODE_P';
						IF @v_BIRTH_DATE IS NOT NULL
						SET	 @N_SQL = @N_SQL + ',BIRTH_DATE = @v_BIRTH_DATE_P';						
																		
						
						SET	 @N_SQL = @N_SQL + ' WHERE  ENTITY_ID = @i_PI_TYPE_ENTITY_ID_GEN_P ' ;								
						--BEGIN TRY
						Exec sp_Executesql @N_SQL, 
							 N' @v_PI_PHONE_P	varchar (30),
							 @v_PI_ADDR1_P	varchar(100),
							 @v_PI_ADDR2_P	varchar(100),			
							 @v_PI_CITY_P	varchar(50),
							 @v_PI_STATE_P	varchar(4),
							 @v_PI_ZIP_CODE_P	varchar (10),
							 @v_BIRTH_DATE_P	varchar(8),
							 @i_PI_TYPE_ENTITY_ID_GEN_P INT ',							
							 @v_PI_PHONE_P = @v_PI_PHONE,	
							 @v_PI_ADDR1_P	= @v_PI_ADDR1 ,
							 @v_PI_ADDR2_P = @v_PI_ADDR2,			
							 @v_PI_CITY_P	= @v_PI_CITY ,
							 @v_PI_STATE_P	= @v_PI_STATE_R ,
							 @v_PI_ZIP_CODE_P	= @v_PI_ZIP_CODE,
							 @v_BIRTH_DATE_P	=@v_BIRTH_DATE ,
							 @i_PI_TYPE_ENTITY_ID_GEN_P = @i_PI_TYPE_ENTITY_ID_GEN ;
						--END TRY
						--BEGIN CATCH	
						--				SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
						--				EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						--					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						--					@p_MODULE_NAME = @V_MODULENAME ,
						--					@p_CALLING_ERROR_LOCATION = 'Main', 
						--					@p_CURRENT_ERROR_LOCATION = 'PIENTUPD', 
						--					@p_ERROR_PROC_NAME = @V_PROCNAME ,
						--					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						--					@p_ERROR_COLUMNS = NULL , 
						--					@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
						--					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						--					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						--					@P_IS_VALIDATION = 0 ;
						--					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
											 				 
						--END CATCH
									SET @V_ERROR_LOCATION = 'I81'	 	
 --PRINT 'PI DATA IN ENTITY ENDS '			
END	

									--*************************************************************************
									--*****************UPDATE PI DATA IN ENTITY ENDS ************************
									--*************************************************************************
	
									--*************************************************************************
									--******************* SUPPLEMENTAL INSERT STARTS *****************************		
									--*************************************************************************



					


--- kapil start
--print 'supp insert entered @i_PI_TYPE_ENTITY_ID_GEN ' + CAST (@i_PI_TYPE_ENTITY_ID_GEN AS VARCHAR)
IF  (@EVENT_SUPP <> 0) AND(@I_ERRORCOUNT = 0)  --SUPP  
BEGIN

SET @V_ERROR_LOCATION = 'I82'	 
IF @i_EVENT_ID > 0   AND @i_PI_ROW_ID = 0  -- FOR EVENT ONLY
BEGIN								
PRINT 'MK EVENT ONLY'
EXEC DDS_SUPPLEMENT		 
@P_JOBID                = @p_JOBID,
@P_CONFIG_ID            = @CONFIG_ID,
@P_USER_ID              = @p_USERID,
@P_MODULE_NAME          = 'EVENT',
@P_DB_NAME              = @V_DBName,
@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
@P_LOB                  = 0,
@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
@P_STAGE                = 'I',  -- V for validation and I for Insert
@P_CLAIMANT_EID         = 0,
@P_EVENT_ID             = @i_EVENT_ID,
@P_CLAIM_ID             = 0,
@P_EMPLOYEE_EID         = 0,
@P_UNIT_ID              = 0,
@P_ENTITY_ID            = 0,
@P_DEFENDANT_ROW_ID     = 0,
@P_PI_ROW_ID            = 0,
@P_PI_PROC_ROW_ID       = 0,
@P_PATIENT_ID           = 0,
@P_TRANS_ID             = 0,
@P_PLAN_ID              = 0,
@P_EV_CONCOM_ROW_ID = 0,
@P_EV_MW_TEST_ROW_ID = 0,
@P_KEYCOLUMN            = 'EVENT_NUMBER',
@P_KEYVALUE             = @v_EVENT_NUMBER,
@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
END
 IF @i_EVENT_ID > 0 AND @i_PI_ROW_ID > 0 AND @i_PI_TYPE_ENTITY_ID_GEN > 0 AND @i_PATIENT_ID_GEN = 0 --FOR EMP

 BEGIN
  PRINT 'MK EMP ONLY'
EXEC DDS_SUPPLEMENT		 
@P_JOBID                = @p_JOBID,
@P_CONFIG_ID            = @CONFIG_ID,
@P_USER_ID              = @p_USERID,
@P_MODULE_NAME          = 'EVENT',
@P_DB_NAME              = @V_DBName,
@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
@P_LOB                  = 0,
@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
@P_STAGE                = 'I',  -- V for validation and I for Insert
@P_CLAIMANT_EID         = 0,
@P_EVENT_ID             = @i_EVENT_ID,
@P_CLAIM_ID             = 0,
@P_EMPLOYEE_EID         = @i_PI_TYPE_ENTITY_ID_GEN,
@P_UNIT_ID              = 0,
@P_ENTITY_ID            = 0,
@P_DEFENDANT_ROW_ID     = 0,
@P_PI_ROW_ID            = @i_PI_ROW_ID,
@P_PI_PROC_ROW_ID       = 0,
@P_PATIENT_ID           = 0,
@P_TRANS_ID             = 0,
@P_PLAN_ID              = 0,
@P_EV_CONCOM_ROW_ID = 0,
@P_EV_MW_TEST_ROW_ID = 0,
@P_KEYCOLUMN            = 'EVENT_NUMBER',
@P_KEYVALUE             = @v_EVENT_NUMBER,
@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
END
IF @i_EVENT_ID > 0 AND @i_PI_ROW_ID > 0 AND @i_PI_TYPE_ENTITY_ID_GEN = 0 AND @i_PATIENT_ID_GEN > 0 -- FOR PATIENT
 BEGIN
  PRINT 'MK PATEINT ONLY'
EXEC DDS_SUPPLEMENT		 
@P_JOBID                = @p_JOBID,
@P_CONFIG_ID            = @CONFIG_ID,
@P_USER_ID              = @p_USERID,
@P_MODULE_NAME          = 'EVENT',
@P_DB_NAME              = @V_DBName,
@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
@P_LOB                  = 0,
@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
@P_STAGE                = 'I',  -- V for validation and I for Insert
@P_CLAIMANT_EID         = 0,
@P_EVENT_ID             = @i_EVENT_ID,
@P_CLAIM_ID             = 0,
@P_EMPLOYEE_EID         = 0,
@P_UNIT_ID              = 0,
@P_ENTITY_ID            = 0,
@P_DEFENDANT_ROW_ID     = 0,
@P_PI_ROW_ID            = @i_PI_ROW_ID,
@P_PI_PROC_ROW_ID       = 0,
@P_PATIENT_ID           = @i_PATIENT_ID_GEN,
@P_TRANS_ID             = 0,
@P_PLAN_ID              = 0,
@P_EV_CONCOM_ROW_ID = 0,
@P_EV_MW_TEST_ROW_ID = 0,
@P_KEYCOLUMN            = 'EVENT_NUMBER',
@P_KEYVALUE             = @v_EVENT_NUMBER,
@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
END

SET @V_ERROR_LOCATION = 'I86'	

END



--END
--kapil end



--IF  (@EVENT_SUPP <> 0) AND(@I_ERRORCOUNT = 0)  --SUPP  
--BEGIN

--SET @V_ERROR_LOCATION = 'I82'	 
--IF @i_EVENT_ID > 0  
--BEGIN								--**********************************************************************
--EXEC DDS_SUPPLEMENT		  -- 1. EVENT_SUPP     
--@P_JOBID                = @p_JOBID,
--@P_CONFIG_ID            =@CONFIG_ID,
--@P_USER_ID              =@p_USERID,
--@P_MODULE_NAME          ='EVENT',
--@P_DB_NAME              =@V_DBName,
--@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
--@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
--@P_LOB                  = 0,
--@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
--@P_STAGE                = 'I',  -- V for validation and I for Insert
--@P_CLAIMANT_EID         = 0,
--@P_EVENT_ID             =@i_EVENT_ID,
--@P_CLAIM_ID             =0,
--@P_EMPLOYEE_EID         =0,
--@P_UNIT_ID              =0,
--@P_ENTITY_ID            =0,
--@P_DEFENDANT_ROW_ID     =0,
--@P_PI_ROW_ID            =0,
--@P_PI_PROC_ROW_ID       =0,
--@P_PATIENT_ID           =0,
--@P_TRANS_ID             =0,
--@P_PLAN_ID              =0,
--@P_KEYCOLUMN            ='EVENT_NUMBER',
--@P_KEYVALUE             = @v_EVENT_NUMBER,
--@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT  

----EXEC DDS_SUPPLEMENT		  -- 2. FALL_IND_SUPP  
----@P_JOBID                = @p_JOBID,
----@P_CONFIG_ID            =@CONFIG_ID,
----@P_USER_ID              =@p_USERID,
----@P_MODULE_NAME          ='EVENT',
----@P_DB_NAME              =@V_DBName,
----@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
----@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
----@P_LOB                  = @v_LINE_OF_BUS_CODE,
----@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
----@P_STAGE                = 'I',  -- V for validation and I for Insert
----@P_CLAIMANT_EID         = 0,
----@P_EVENT_ID             =0,
----@P_CLAIM_ID             =0,
----@P_EMPLOYEE_EID         =0,
----@P_UNIT_ID              =0,
----@P_ENTITY_ID            =0,
----@P_DEFENDANT_ROW_ID     =0,
----@P_PI_ROW_ID            =0,
----@P_PI_PROC_ROW_ID       =0,
----@P_PATIENT_ID           =0,
----@P_TRANS_ID             =0,
----@P_PLAN_ID              =0,
----@P_KEYCOLUMN            ='EVENT_NUMBER',
----@P_KEYVALUE             = @v_EVENT_NUMBER,
----@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 

----EXEC DDS_SUPPLEMENT		  -- 3. EMP_SUPP       
----@P_JOBID                = @p_JOBID,
----@P_CONFIG_ID            = @CONFIG_ID,
----@P_USER_ID              = @p_USERID,
----@P_MODULE_NAME          = 'EVENT',
----@P_DB_NAME              = @V_DBName,
----@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
----@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
----@P_LOB                  = @v_LINE_OF_BUS_CODE,
----@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
----@P_STAGE                = 'I',  -- V for validation and I for Insert
----@P_CLAIMANT_EID         = 0,
----@P_EVENT_ID             = 0,
----@P_CLAIM_ID             = 0,
----@P_EMPLOYEE_EID         = @i_EMPLOYEE_EID,
----@P_UNIT_ID              = 0,
----@P_ENTITY_ID            = 0,
----@P_DEFENDANT_ROW_ID     = 0,
----@P_PI_ROW_ID            = 0,
----@P_PI_PROC_ROW_ID       = 0,
----@P_PATIENT_ID           = 0,
----@P_TRANS_ID             = 0,
----@P_PLAN_ID              = 0,
----@P_KEYCOLUMN            = 'EVENT_NUMBER',
----@P_KEYVALUE             = @v_EVENT_NUMBER,
----@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 				
--SET @V_ERROR_LOCATION = 'I83'	 

--IF ((@i_PI_ROW_ID > 0))		-- 4 AND 5  
--BEGIN

--EXEC DDS_SUPPLEMENT		  -- 3. PI_SUPP		 
--@P_JOBID                = @p_JOBID,
--@P_CONFIG_ID            = @CONFIG_ID,
--@P_USER_ID              = @p_USERID,
--@P_MODULE_NAME          = 'EVENT',
--@P_DB_NAME              = @V_DBName,
--@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
--@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
--@P_LOB                  = 0,
--@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
--@P_STAGE                = 'I',  -- V for validation and I for Insert
--@P_CLAIMANT_EID         = 0,
--@P_EVENT_ID             = 0,
--@P_CLAIM_ID             = 0,
--@P_EMPLOYEE_EID         = 0,
--@P_UNIT_ID              = 0,
--@P_ENTITY_ID            = 0,
--@P_DEFENDANT_ROW_ID     = 0,
--@P_PI_ROW_ID            = @i_PI_ROW_ID,
--@P_PI_PROC_ROW_ID       = 0,
--@P_PATIENT_ID           = 0,
--@P_TRANS_ID             = 0,
--@P_PLAN_ID              = 0,
--@P_KEYCOLUMN            = 'EVENT_NUMBER',
--@P_KEYVALUE             = @v_EVENT_NUMBER,
--@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
--SET @V_ERROR_LOCATION = 'I84'	
--IF @i_PATIENT_ID_GEN > 0  -- 4. PATIENT_SUPP 
--BEGIN
--EXEC DDS_SUPPLEMENT		  -- 5. PATIENT_SUPP 
--@P_JOBID                = @p_JOBID,
--@P_CONFIG_ID            = @CONFIG_ID,
--@P_USER_ID              = @p_USERID,
--@P_MODULE_NAME          = 'EVENT',
--@P_DB_NAME              = @V_DBName,
--@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
--@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
--@P_LOB                  = 0,
--@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
--@P_STAGE                = 'I',  -- V for validation and I for Insert
--@P_CLAIMANT_EID         = 0,
--@P_EVENT_ID             = 0,
--@P_CLAIM_ID             = 0,
--@P_EMPLOYEE_EID         = 0,
--@P_UNIT_ID              = 0,
--@P_ENTITY_ID            = 0,
--@P_DEFENDANT_ROW_ID     = 0,
--@P_PI_ROW_ID            = 0,
--@P_PI_PROC_ROW_ID       = 0,
--@P_PATIENT_ID           = @i_PATIENT_ID_GEN,
--@P_TRANS_ID             = 0,
--@P_PLAN_ID              = 0,
--@P_KEYCOLUMN            = 'EVENT_NUMBER',
--@P_KEYVALUE             = @v_EVENT_NUMBER,
--@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 

--END
--SET @V_ERROR_LOCATION = 'I85'	
--IF @i_PI_TYPE_ENTITY_ID_GEN > 0  -- -- 5. EMP_SUPP  
--BEGIN
--EXEC DDS_SUPPLEMENT		 
--@P_JOBID                = @p_JOBID,
--@P_CONFIG_ID            = @CONFIG_ID,
--@P_USER_ID              = @p_USERID,
--@P_MODULE_NAME          = 'EVENT',
--@P_DB_NAME              = @V_DBName,
--@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
--@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
--@P_LOB                  = 0,
--@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
--@P_STAGE                = 'I',  -- V for validation and I for Insert
--@P_CLAIMANT_EID         = 0,
--@P_EVENT_ID             = 0,
--@P_CLAIM_ID             = 0,
--@P_EMPLOYEE_EID         = @i_PI_TYPE_ENTITY_ID_GEN,
--@P_UNIT_ID              = 0,
--@P_ENTITY_ID            = 0,
--@P_DEFENDANT_ROW_ID     = 0,
--@P_PI_ROW_ID            = 0,
--@P_PI_PROC_ROW_ID       = 0,
--@P_PATIENT_ID           = 0,
--@P_TRANS_ID             = 0,
--@P_PLAN_ID              = 0,
--@P_KEYCOLUMN            = 'EVENT_NUMBER',
--@P_KEYVALUE             = @v_EVENT_NUMBER,
--@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
--SET @V_ERROR_LOCATION = 'I86'	
--END
--END

--END

--END

										--*************************************************************************
									--******************* SUPPLEMENTAL INSERT ENDS *****************************		
		
		SET @V_ERROR_LOCATION = 'I87'								--*************************************************************************	
	IF @I_ERRORCOUNT = 0
	BEGIN
	UPDATE DDS_EVENT SET INVALID_ROW = 0 WHERE  JOBID = @p_jobID AND DA_ROW_ID = @v_DA_ROW_ID
	SET @V_ERROR_LOCATION = 'I88'	
	END
	SET @V_ERROR_LOCATION = 'I89'	
	
	
	
	
	
	
END TRY
BEGIN CATCH -- INSERT STMNT'S TRY CATCH
								SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = @V_ERROR_LOCATION, 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											@p_ERROR_COLUMNS = NULL , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											@P_IS_VALIDATION = 0 ;
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;

END CATCH
	--PRINT	' CheckCreateNewCodes Is - ' + cast (@CheckCreateNewCodes as char);-
		
								
SET @V_ERROR_LOCATION_MAIN = 'ES15'	
	
--BEGIN						-- FETCH NEXT FROM DDS_EVENT_CUR  




END TRY  -- This Try Catch is of While loop 
BEGIN CATCH
								SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = @V_ERROR_LOCATION_MAIN, 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											@p_ERROR_COLUMNS = NULL , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											@P_IS_VALIDATION = 0 ;
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;

END CATCH

----Neha Running status code starts 33658---
	BEGIN TRY
							
	SET @V_ERROR_LOCATION= 'Running_Status'
			
	IF @iRunStatCnt=1
	BEGIN
			
		SET @vProcessMsg ='Total Number of Records processed in EVENT : '+ cast(@iRunStatCnt as varchar);

		SET @N_sql = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
		SET @N_sql =@N_sql +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

		EXECUTE SP_EXECUTESQL @N_sql,
		N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
		@pJOBID=@v_JobID, @pProcessMsg=@vProcessMsg, @pModuleName='EVENT_RUN',@pTableName ='DDS_EVENT_RUN',@pDisplayOrder=-11
	END
	ELSE  
	IF (@iRunCnt = 1000)
	BEGIN
			SET @vProcessMsg ='Total Number of Records processed in EVENT : '+ cast(@iRunStatCnt as varchar);

			SET @N_sql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
			SET @N_sql =@N_sql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

			EXECUTE SP_EXECUTESQL @N_sql,
			N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
			@pProcessDesc=@vProcessMsg, @pJobID=@v_JobID,@pModuleName='EVENT_RUN',@pTableName ='DDS_EVENT_RUN',@pDisplayOrder=-11
			SET @iRunCnt=1;
	END
	ELSE
	IF (@iTotalRows=@iRunStatCnt)
	BEGIN
		SET @vProcessMsg ='Total Number of Records processed in EVENT : '+ cast(@iRunStatCnt as varchar);
		SET @N_sql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
		SET @N_sql =@N_sql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

			EXECUTE SP_EXECUTESQL @N_sql,
            N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
			@pProcessDesc=@vProcessMsg, @pJobID=@v_JobID,@pModuleName='EVENT_RUN',@pTableName ='DDS_EVENT_RUN',@pDisplayOrder=-11
	END

	SET @iRunStatCnt =@iRunStatCnt + 1; 
	SET @iRunCnt = @iRunCnt + 1;

	END TRY
	BEGIN CATCH
			SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
			EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@v_DA_Row_ID, 'EVENT','Run_Status', 'Run_Status','DDS_PROCESS_EVENT',@V_ERROR_MESSAGE,'EXCEPTION', 'DDS_EVENT','EVENT_NUMBER', @v_EVENT_NUMBER, 0
			SET @I_ERRORCOUNT += 1
	END CATCH
---Neha running status code ends 33658---

  FETCH NEXT FROM DDS_EVENT_CUR INTO  
				@v_JOBID ,
				@v_DA_ROW_ID 	,
				@v_INVALID_ROW 	,
				@v_UPDATE_ROW ,
				@v_DA_ROW_ID 	,
				@v_EVENT_NUMBER           	,
				@v_EVENT_TYPE_CODE	,
				@v_EVENT_STATUS_CODE	,
				@v_EVENT_IND_CODE	,
				@v_EVENT_DESCRIPTION	,
				@v_BRIEF_DESCRIPTION	,
				@v_DEPARTMENT	,
				@v_DEPT_INVOLVED	,
				@v_ADDR1	,
				@v_ADDR2	,
				@v_CITY	,
				@v_STATE	,
				@v_ZIP_CODE	,
				@V_COUNTRY	,
				@V_COUNTY_OF_INJURY	,
				@v_LOCATION_AREA_DESC	,
				@v_PRIMARY_LOC_CODE	,
				@v_LOCATION_TYPE_CODE	,
				@v_ON_PREMISE_FLAG	,
				@v_NO_OF_INJURIES	,
				@v_NO_OF_FATALITIES	,
				@v_CAUSE_CODE	,
				@v_DATE_OF_EVENT	,
				@v_TIME_OF_EVENT	,
				@v_DATE_REPORTED	,
				@v_TIME_REPORTED	,
				@v_REPORTED_TAX_ID	,
				@v_REPORTED_LAST_NAME	,
				@v_REPORTED_FIRST_NAME	,
				@v_REPORTED_ADDR1	,
				@v_REPORTED_ADDR2	,
				@v_REPORTED_CITY 	,
				@v_REPORTED_STATE	,
				@v_REPORTED_ZIP_CODE	,
				@v_REPORTED_PHONE	,
				@v_COMMENTS	,
				@v_ACTIVITY_WHEN_INJ	,
				@v_HOW_ACC_OCCURRED	,
				@v_OBJ_SUBST_THAT_INJ	,
				@v_RECORDABLE_FLAG	,
				@v_SAFEG_NOTUSED_FLAG	,
				@v_SAFEGUARD_FLAG	,
				@v_NO_RULES_FLAG	,
				@v_DATE_PHYS_ADVISED	,
				@v_TIME_PHYS_ADVISED	,
				@v_ACTION_1_CODE 	,
				@v_ACTION_2_CODE 	,
				@v_ACTION_3_CODE 	,
				@v_ACTION_4_CODE 	,
				@v_ACTION_5_CODE 	,
				@v_OUTCOME_1_CODE 	,
				@v_OUTCOME_2_CODE 	,
				@v_OUTCOME_3_CODE 	,
				@v_OUTCOME_4_CODE 	,
				@v_OUTCOME_5_CODE 	,
				@v_DATE_TO_FOLLOW_UP	,
				@v_TREATMENT_GIVEN 	,
				@v_RELEASE_SIGNED 	,
				@v_DEPT_HEAD_ADVISED 	,
				@v_PHYS_NOTES	,
				@v_DATE_CARRIER_NOTIF	,
				@v_PI_SUFFIX	,
				@v_PI_TAX_ID	,
				@v_PI_LAST_NAME	,
				@v_PI_FIRST_NAME	,
				@v_PI_ADDR1	,
				@v_PI_ADDR2	,
				@v_PI_CITY	,
				@v_PI_STATE	,
				@v_PI_ZIP_CODE	,
				@v_PI_PHONE	,
				@v_PI_TYPE_CODE	,
				@v_MARITAL_STAT_CODE	,
				@v_SEX_CODE	,
				@v_BIRTH_DATE	,
				@v_DATE_OF_DEATH	,
				@v_ILLNESS_CODE	,
				@v_INJURY_1_CODE 	,
				@v_INJURY_2_CODE 	,
				@v_INJURY_3_CODE 	,
				@v_INJURY_4_CODE 	,
				@v_INJURY_5_CODE 	,
				@v_BODY_PART_1_CODE 	,
				@v_BODY_PART_2_CODE 	,
				@v_BODY_PART_3_CODE 	,
				@v_BODY_PART_4_CODE 	,
				@v_BODY_PART_5_CODE 	,
				@v_DIAGNOSIS_1_CODE 	,
				@v_DIAGNOSIS_2_CODE 	,
				@v_DIAGNOSIS_3_CODE 	,
				@v_DIAGNOSIS_4_CODE 	,
				@v_DIAGNOSIS_5_CODE 	,
				@v_TREATMENT_1_CODE 	,
				@v_TREATMENT_2_CODE 	,
				@v_TREATMENT_3_CODE 	,
				@v_TREATMENT_4_CODE 	,
				@v_TREATMENT_5_CODE 	,
				@v_PHYSICIAN_1_LAST_NAME 	,
				@v_PHYSICIAN_1_FIRST_NAME	,
				@v_PHYSICIAN_1_PHONE	,
				@v_PHYSICIAN_2_LAST_NAME 	,
				@v_PHYSICIAN_2_FIRST_NAME	,
				@v_PHYSICIAN_2_PHONE	,
				@v_PHYSICIAN_3_LAST_NAME 	,
				@v_PHYSICIAN_3_FIRST_NAME	,
				@v_PHYSICIAN_3_PHONE	,
				@v_HOSPITAL_1_NAME	,
				@v_HOSPITAL_1_PHONE	,
				@v_HOSPITAL_2_NAME	,
				@v_HOSPITAL_2_PHONE	,
				@v_HOSPITAL_3_NAME	,
				@v_HOSPITAL_3_PHONE	,
				@v_DRIVERS_LIC_NO	,
				@v_DRIVERSLICTYPECODE	,
				@v_DATE_DRIVERSLICEXP	,
				@v_DRIVLIC_RSTRCT_CODE	,
				@v_DRIVLIC_STATE	,
				@V_COUNTY_OF_RESIDNC	,
				@v_NCCI_CLASS_CODE	,
				@v_EST_LEN_DISABILITY	,
				@v_INSURABLE_FLAG	,
				@v_LAST_VERIFIED_DATE	,
				@v_PATIENT_ACCT_NO	,
				@v_MEDICAL_RCD_NO	,
				@v_INS_PLAN_GROUP_NO	,
				@v_DATE_OF_ADMISSION	,
				@v_DATE_OF_DISCHARGE	,
				@v_ADM_TYPE_CODE	,
				@v_ADM_SOURCE_CODE	,
				@v_ADMISSION_REASON	,
				@v_ACUITY_LEVEL_CODE	,
				@v_PATIENT_STAT_CODE	,
				@v_PATIENT_COND_CODE	,
				@v_DISCHARGE_DSP_CODE	,
				@v_EXP_LENGTH_OF_STAY	,
				@v_EXPECTED_COST	,
				@v_QI_SIGNIF_CODE	,
				@v_EPISODE_OF_CARE_ID	,
				@v_PATIENT_TYPE_CODE	,
				@v_WEIGHT 	,
				@v_EMERGENCY_CONTACT	,
				@v_EMERGENCY_CONT_NO	,
				@v_PATIENT_ROOM_NO	,
				@v_FACILITY_UNIT_CODE	,
				@v_FACILITY_DEPT	,
				@v_HCO_ID_NO	,
				@v_HCO_SITE_ID_NO	,
				@v_WHY_AT_FACILITY	,
				@v_DISABILITY_CODE	,
				@v_EMPLOYEE_NUMBER	,
				@v_POSITION_CODE	,
				@v_DEPT_ASSIGNED	,
				@v_SUPER_TAX_ID	,
				@v_SUPER_EMP_NO	,
				@v_SUPER_LAST_NAME	,
				@v_SUPER_FIRST_NAME	,
				@v_SUPER_ADDR1	,
				@v_SUPER_ADDR2	,
				@v_SUPER_CITY	,
				@v_SUPER_STATE	,
				@v_SUPER_ZIP_CODE	,
				@v_SUPER_PHONE1	,
				@v_FULL_TIME_FLAG	,
				@v_PAY_TYPE_CODE	,
				@v_HOURLY_RATE	,
				@v_WEEKLY_HOURS	,
				@v_WEEKLY_RATE	,
				@v_PAY_AMOUNT	,
				@v_ACTIVE_FLAG	,
				@v_DATE_HIRED	,
				@v_DATE_LAST_WORKED_1  	,
				@v_DATE_RETURNED_1  	,
				@v_DATE_LAST_WORKED_2  	,
				@v_DATE_RETURNED_2  	,
				@v_DATE_LAST_WORKED_3  	,
				@v_DATE_RETURNED_3  	,
				@v_DATE_LAST_WORKED_4  	,
				@v_DATE_RETURNED_4  	,
				@v_DATE_LAST_WORKED_5  	,
				@v_DATE_RETURNED_5  	,
				@v_DATE_LAST_WORKED_6  	,
				@v_DATE_RETURNED_6  	,
				@v_DATE_LAST_WORKED_7  	,
				@v_DATE_RETURNED_7  	,
				@v_DATE_LAST_WORKED_8  	,
				@v_DATE_RETURNED_8  	,
				@v_DATE_LAST_WORKED_9  	,
				@v_DATE_RETURNED_9  	,
				@v_DATE_LAST_WORKED_10  	,
				@v_DATE_RETURNED_10 	,
				@v_DATE_LAST_WORKED_11  	,
				@v_DATE_RETURNED_11  	,
				@v_DATE_LAST_WORKED_12  	,
				@v_DATE_RETURNED_12 	,
				@v_DATE_LAST_WORKED_13  	,
				@v_DATE_RETURNED_13  	,
				@v_DATE_LAST_WORKED_14 	,
				@v_DATE_RETURNED_14  	,
				@v_DATE_LAST_WORKED_15  	,
				@v_DATE_RETURNED_15  	,
				@v_LOST_WORK_FLAG	,
				@v_LEN_OF_SVC_DAYS	,
				@v_EXEMPT_STATUS_FLAG	,
				@v_NO_OF_EXEMPTIONS	,
				@v_WORK_SUN_FLAG	,
				@v_WORK_MON_FLAG	,
				@v_WORK_TUE_FLAG	,
				@v_WORK_WED_FLAG	,
				@v_WORK_THU_FLAG	,
				@v_WORK_FRI_FLAG	,
				@v_WORK_SAT_FLAG	,
				@v_WORKDAY_START_TIME	,
				@v_WORK_PERMIT_DATE	,
				@v_WORK_PERMIT_NUMBER	,
				@v_REGULAR_JOB_FLAG	,
				@v_HIRED_IN_STATE_FLAG	,
				@v_NUM_OF_VIOLATION 	,
				@v_DESC_BY_WITNESS	,
				@v_USER_FIELD_A	,
				@v_USER_FIELD_B	,
				@v_USER_FIELD_C	,
				@v_USER_FIELD_D	,
				@v_USER_FIELD_E	,
				@v_USER_FIELD_F	,
				@v_USER_FIELD_G	,
				@v_USER_FIELD_H	,
				@v_USER_FIELD_I	,
				@v_USER_FIELD_J	,
				@v_USER_FIELD_K	,
				@v_USER_FIELD_L	,
				@v_USER_FIELD_M	,
				@v_USER_FIELD_N	,
				@v_USER_FIELD_O	,
				@v_USER_FIELD_P	,
				@v_USER_FIELD_Q	,
				@v_USER_FIELD_R	,
				@v_USER_FIELD_S	,
				@v_USER_FIELD_T	,
				@v_USER_FIELD_U	,
				@v_USER_FIELD_V	,
				@v_USER_FIELD_W	,
				@v_USER_FIELD_X	,
				@v_USER_FIELD_Y	,
				@v_COND_PRIOR_CODE	,
				@v_RAIL_POSITION_CODE	,
				@v_RESTRAINT_CODE	,
				@v_BED_POSITION_CODE	,
				@v_CALL_LIGHT_CODE	,
				@v_REPORTED_COUNTRY	,
				@v_REPORTED_PHONE2	,
				@v_REPORTED_FAX	,
				@v_PI_MIDDLE_NAME	,
				@v_PRIVACY_CASE_FLAG	,
				@v_SHARPS_OBJECT	,
				@v_SHARPS_BRAND_MAKE	,
				@v_SAFEG_PROVIDED	,
				@v_RULES_NOT_FOLLOWED	,
				@v_OSHA_ESTAB_EID,
				@v_NAME_TYPE,        --dsharma70 hmi
				@v_BENEFICIARY_CODE, --dsharma70 hmi
				@v_REPORTED_BIRTH_DT --dsharma70 hmi				
													
   
			SET @TOTALROWS = @TOTALROWS - 1;    
			
-- REINITIALIZE LOCAL VARIBLES START
		SET @I_ERRORCOUNT = 0;
		SET @I_ROWCOUNT = 0;
		set @I_COUNT = 0 ;
		SET @I_STATEID_GEN = 0 ;
		SET @V_DTTM_RCD_ADDED_GEN = NULL ;		 
		SET @i_DEPARTMENT_GEN = 0 ; 		
		SET @i_DEPT_INVOLVED_GEN = 0 ;	
		SET @i_DEPT_ASSIGNED_GEN = 0;
		SET @i_FACILITY_DEPT_GEN = 0 ;	
		SET @i_OSHA_ESTAB_EID_GEN = 0;	
		SET @i_PI_ROW_ID = 0 ;
		SET @i_ENTITY_ID = 0 ;	
		SET @i_EVENT_ID = 0 ;		
		SET @i_PATIENT_ID_GEN = 0 ;	
		SET @i_PI_TYPE_ENTITY_ID_GEN = 0 ;	
		SET @i_SUPERVISOR_ENTITY_ID_GEN = 0 ;	
		SET @i_PRI_PHYSICIAN_EID_GEN = 0 ;
		SET @i_ADM_PHYSICIAN_EID_GEN = 0;
		SET @vColName1 = NULL ;		
		SET @vColName2 = NULL ;		
		SET @vColName3 = NULL ;	
		SET @vVal2 = NULL ;		
		SET @vColName4 = NULL ;		
		SET @vVal3 = NULL ;			
		SET @i_HOSPITAL_1_EID = 0 ;		
		SET @i_HOSPITAL_2_EID = 0 ;		
		SET @i_HOSPITAL_3_EID = 0 ;		
		SET @i_PHYSICIAN_1_EID = 0 ;		
		SET @i_PHYSICIAN_2_EID = 0 ;
		SET @i_PHYSICIAN_3_EID = 0 ;	
		SET @V_ERROR_MESSAGE =  NULL ;		
		SET @i_Reporter_ENTITY_ID_GEN  = 0 ; 		
		SET @v_STATE_R =  0 ;	
		SET @v_REPORTED_STATE_R =  0 ;		
		SET @v_PI_STATE_R =  0 ;		
		SET @v_DRIVLIC_STATE_R =  0 ;		
		SET @v_SUPER_STATE_R =  0 ;		
		SET @STATE_ROW_ID_R =  0 ;
		SET @i_PI_WL_ROW_ID =  0 ;
		SET @vColToProcess2 =  NULL ;
		SET @iCount2 =  0 ;		
		SET @iCodeId =  0 ;	
		SET @v_TIME_OF_EVENT_INVALID =  0 ;
		SET @v_TIME_REPORTED_INVALID = 0 ;
		SET @V_DATE_REPORTED_INVALID = 0 ;
		SET @V_DATE_OF_EVENT_INVALID = 0 ; 
		SET @vTableToProcess = NULL ;
		SET @i_EMPLOYEE_EID = 0 ;
		SET @i_EVENT_ID_O = 0 ;
		SET @i_PI_ROW_ID_OP = 0 ;
		SET @i_Phys_EID_O = 0 ;
	  	SET @i_PATIENT_EID = 0 ;
		SET @i_EMPLOYEE_EID_UPDATE = 0 ;
		SET @i_EMPLOYEE_EID_EN = 0 ; 
		SET @V_DTTM_RCD_ADDED_GEN = NULL ;	
		SET @V_DTTM_RCD_LAST_UPD_GEN = NULL ;	
		SET @V_UPDATED_BY_USER = NULL ;	
		SET @V_ADDED_BY_USER = NULL ;	
		SET @V_NEXT_UNIQUE_ID = 0 ;	
		SET @N_SQL_EVENT = 0 ;
		SET @V_ORGSEC_FLAG = 0 ;	
		SET @V_SEC_DEPT_EID = 0 ;	
		SET @vReqColumns = NULL ;	
		SET @vCodeFieldList = NULL ;	
		SET @vSysTableNameList = NULL ;
		SET @iPos = 0 ;	
		SET @vColName = NULL ;	
		SET @nSql = NULL ;	
		SET @vColList = NULL ;
		SET @iCount = 0 ;
		SET @vVal = NULL ;
		SET @vTableList = NULL ;
		SET @vTableName = NULL ;
		SET @vColToProcess = NULL ;	
		SET @vTab = NULL ;	
		SET @vTabToProcess = NULL ;	
		SET @vColInRM = NULL ;	
		SET @vColName_value = 0 ;
		SET @I_ON_PREMISE_FLAG_GEN = 0 ;	
		SET @I_NO_RULES_FLAG_GEN = 0 ;	
		SET @I_RECORDABLE_FLAG_GEN = 0 ;	
		SET @I_SAFEG_NOTUSED_GEN = 0 ;	
		SET @I_SAFEGUARD_FLAG_GEN = 0 ;		
		SET @I_PRIVACY_CASE_GEN = 0 ;	
		SET @v_WORK_SUN_FLAG_GEN = 0 ;		
		SET @v_WORK_MON_FLAG_GEN = 0 ;
		SET @v_WORK_TUE_FLAG_GEN = 0 ;	
		SET @v_WORK_WED_FLAG_GEN = 0 ;	
		SET @v_WORK_THU_FLAG_GEN = 0 ;	
		SET @v_WORK_FRI_FLAG_GEN = 0 ;
		SET @v_WORK_SAT_FLAG_GEN = 0 ;
		SET @v_FULL_TIME_FLAG_GEN = 0 ;
		SET @v_ACTIVE_FLAG_GEN = 0 ;		
		SET @v_EXEMPT_STATUS_FLAG_GEN = 0 ;
		SET @v_INSURABLE_FLAG_GEN = 0 ;	
		SET @v_REGULAR_JOB_FLAG_GEN = 0 ;
		SET @v_HIRED_IN_STATE_FLAG_GEN = 0 ;	
		SET @v_LOST_WORK_FLAG_GEN = 0 ;
		SET @P_SUPP_ERROR_COUNT_R = 0 ;		
		SET @vVal4 = 0 ;	
		SET @i_CheckNext = 0;		
		SET @vColToProcess1 = 0;
		SET	 @i_NOTHING  = 0 ;		
		SET  @Forcecreate = 0 ;
		SET @iEidForDept = 0 ;
		SET @I_TREATMENT_GIVEN_GEN = 0 ;
SET @I_NO_RULES_FLAG_GEN = 0 ;
SET @I_DEPT_HEAD_ADVISED_GEN = 0 ;
		SET @V_DURATION = NULL ;
			set @iROW_ID  = 0 ;
		--SET @V_ERROR_COLUMN = \;
	
		
			--INITIALIZING END    



END	; -- WHILE END



SET NOCOUNT OFF  ; 
CLOSE DDS_EVENT_CUR ;
DEALLOCATE DDS_EVENT_CUR ;

exec    DDS_PROCESS_LOG
@P_JOBID = @p_jobID ,@p_MODULE_NAME='EVENT', @p_PROCESS_TABLE='DDS_EVENT'


END TRY

BEGIN CATCH
												SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
											@p_DA_ROW_ID  = @V_DA_ROW_ID , 
											@p_MODULE_NAME = @V_MODULENAME ,
											@p_CALLING_ERROR_LOCATION = 'Main', 
											@p_CURRENT_ERROR_LOCATION = @V_ERROR_LOCATION_MAIN, 
											@p_ERROR_PROC_NAME = @V_PROCNAME ,
											@p_ERROR_MSG = @V_ERROR_MESSAGE ,
											@p_ERROR_COLUMNS = NULL , 
											@p_ERROR_TABLE_TO_CHECK = 'DDS_EVENT',
											@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
											@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
											@P_IS_VALIDATION = 0 ;
											SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;

CLOSE DDS_EVENT_CUR ;
DEALLOCATE DDS_EVENT_CUR ;

END CATCH

END ; 






-- EVENT VALIDATION								  | EVD1   | 10 Blocks

-- PERSON INVOLVED VD							  | PIVD8  | 8 Blocks

-- EMPLOYEE INSERT								  | EmpIn7 | 7 Blocks

-- IMPORT EVENT									  | EI8    | 8 Blocks

-- PERSON INVOLVED Insert                         | PIIns1 | 9 Blocks

-- PERSON INVOLVED and its Related tables UPDATE  | PIUP1  | 3 BLOCKSa
