
/****** Object:  StoredProcedure [dbo].[DA_DDS_MEDWATCH_IMPORT]Script Date: 05/06/2016 05:00:00 PM ******/
IF OBJECT_ID('DA_DDS_MEDWATCH_IMPORT','P') IS NOT NULL
	DROP PROCEDURE DA_DDS_MEDWATCH_IMPORT
GO


CREATE PROCEDURE [dbo].[DA_DDS_MEDWATCH_IMPORT]
@p_JobID int ,
@p_Dbname nvarchar(255) ,
@p_UserID int 

With Execute as Caller
As
Begin
Begin Try
Set NOCount On

--print 'mk1'
DECLARE @CheckCreateNewCodes AS SMALLINT,	     --	Declare Variables for Optionset
		 @CONFIG_ID AS SMALLINT,		 
		 @VALID_START_DATE AS varchar (8),		 
		 @NonEmployeeMatchByName AS SMALLINT ,
		 @NonEmployeeMatchByTaxId AS SMALLINT,	
		 @MEDWATCH_SUPP AS SMALLINT,
		 @VALID_END_DATE AS varchar (8)
		 
		 --dsharma70 hmi
DECLARE	 @NonEmployeeMatchByDOB as SMALLINT

--print 'mk2'
SELECT  @CheckCreateNewCodes = ALLOW_NEW_CODES ,					
		@CONFIG_ID           = CONFIG_ID,
		@NonEmployeeMatchByName = NON_EMP_MATCH_BY_NAME ,
		@NonEmployeeMatchByTaxId = 	NON_EMP_MATCH_BY_TAX_ID ,	
		@MEDWATCH_SUPP       = MEDWATCH_SUPP,
		@VALID_END_DATE      = VALID_END_DATE,
		@VALID_START_DATE    = VALID_START_DATE		
		
		--DSHARMA70 HMI
		,@NonEmployeeMatchByDOB = NON_EMP_MATCH_BY_DOB

FROM DDS_OPTIONSET WHERE JOBID = @p_jobID;
	
	--print 'mk3'
Declare	@v_JOBID INT ,							-- Declare Variables Of Cursor 
@v_DA_Row_ID INT ,
@v_Invalid_Row INT ,
@v_Update_Row INT ,
@v_EVENT_NUMBER VARCHAR (25),
@v_UNIT_CODE nVARCHAR (25),
@v_DATE_RPTD_FDA NVARCHAR(8),
@v_DATE_RPTD_MFG NVARCHAR(8),
@v_RPTD_BY_LAST_NAME NVARCHAR(255),
@v_RPTD_BY_FIRST_NAME NVARCHAR(255),
@v_RPTD_BY_ADDR1 NVARCHAR(100),
@v_RPTD_BY_ADDR2 NVARCHAR(100),
@v_RPTD_BY_CITY 	NVARCHAR(50),
@v_RPTD_BY_STATE NVARCHAR(4),
@v_RPTD_BY_ZIP_CODE NVARCHAR (10),
@v_RPTD_BY_TAX_ID NVARCHAR(20),
@v_RPTD_BY_PRO_FLAG NVARCHAR(1),
@v_RPTD_BY_POS_CODE NVARCHAR(25),
@v_RELEVANT_HISTORY NVARCHAR(MAX),
@v_LAST_REPORT_DATE NVARCHAR(8),
@v_REPORT_YEAR INT, 
@v_REPORT_SERIAL_NO INT,
@v_ADVERSE_EVENT_FLAG NVARCHAR(1),
@v_PRODUCT_PROB_FLAG  NVARCHAR(1),
@v_LIFE_THREAT_FLAG  NVARCHAR(1),
@v_HOSPITALIZ_FLAG  NVARCHAR(1),
@v_DISABILITY_FLAG  NVARCHAR(1),
@v_CONGENITAL_FLAG  NVARCHAR(1),
@v_REQD_INTERV_FLAG  NVARCHAR(1),
@v_FOLLOW_UP_COUNT INT,
@v_RPT_MANDATORY NVARCHAR(1),
@v_MED_TYPE NVARCHAR(25), --mkaur24 ak
@v_MED_NAME NVARCHAR(25),
@v_DOSE NVARCHAR(25),
@v_FREQUENCY NVARCHAR(25),
@v_ROUTE NVARCHAR(25),
@v_THERAPY_FROM_DATE NVARCHAR(8),
@v_THERAPY_TO_DATE  NVARCHAR(8),
@v_DURATION INT,
@v_LOT_NUMBER NVARCHAR(15),
@v_NDC_NUMBER INT,
@v_EXPIRATION_DATE NVARCHAR(8),
@v_EVENT_ABATED NVARCHAR(1),
@v_EVENT_REAPPEARED NVARCHAR(1),
@v_DIAGNOSIS_TEST  NVARCHAR(25),
@v_BRAND_NAME NVARCHAR(25),
@v_EQUIP_TYPE_CODE	 NVARCHAR(25),
@v_MANUF_NAME NVARCHAR(255),
@v_MANUF_ADDR1 NVARCHAR(100),
@v_MANUF_ADDR2 NVARCHAR(100),
@v_MANUF_CITY NVARCHAR(50),
@v_MANUF_STATE  NVARCHAR(4),
@v_MANUF_ZIP_CODE	 NVARCHAR (10),
@v_MODEL_NUMBER NVARCHAR (15),
@v_CATALOG_NUMBER NVARCHAR (15),
@v_SERIAL_NUMBER NVARCHAR (15),
@v_OTHER_NUMBER NVARCHAR (15),
@v_DEVICE_OPER_CODE NVARCHAR (25),
@v_IMPLANT_DATE NVARCHAR(8),
@v_EXPLANT_DATE NVARCHAR(8),
@v_AGE_OF_DEVICE NVARCHAR(12),
@v_DEV_AVAIL_FOR_EVAL NVARCHAR(1),
@v_DEVICE_RETURN_DATE NVARCHAR(8),
@v_EQ_LOT_NUMBER NVARCHAR(15),
@v_EQ_EXPIRATION_DATE NVARCHAR(8),
@v_TEST_LAB_TEST_1  NVARCHAR(MAX),
@v_TEST_LAB_TEST_2  NVARCHAR(MAX),
@v_TEST_LAB_TEST_3  NVARCHAR(MAX),
@v_TEST_LAB_TEST_4  NVARCHAR(MAX),
@v_TEST_LAB_TEST_5  NVARCHAR(MAX),
@v_TEST_RESULT_1 NVARCHAR(MAX),
@v_TEST_RESULT_2 NVARCHAR(MAX),
@v_TEST_RESULT_3 NVARCHAR(MAX),
@v_TEST_RESULT_4 NVARCHAR(MAX),
@v_TEST_RESULT_5 NVARCHAR(MAX),
@v_TEST_DATE_1	 NVARCHAR(8),
@v_TEST_DATE_2	 NVARCHAR(8),
@v_TEST_DATE_3	 NVARCHAR(8),
@v_TEST_DATE_4	 NVARCHAR(8),
@v_TEST_DATE_5	 NVARCHAR(8),
@v_CONCOM_PRODUCT_ID_1 INT ,
@v_CONCOM_PRODUCT_ID_2 INT ,
@v_CONCOM_PRODUCT_ID_3 INT ,
@v_CONCOM_PRODUCT_ID_4 INT ,
@v_CONCOM_PRODUCT_ID_5 INT ,
@v_CONCOM_PRODUCT_ID_6 INT ,
@v_CONCOM_FROM_DATE_1 NVARCHAR(8),
@v_CONCOM_FROM_DATE_2 NVARCHAR(8),
@v_CONCOM_FROM_DATE_3 NVARCHAR(8),
@v_CONCOM_FROM_DATE_4 NVARCHAR(8),
@v_CONCOM_FROM_DATE_5 NVARCHAR(8),
@v_CONCOM_FROM_DATE_6 NVARCHAR(8),
@v_CONCOM_TO_DATE_1 NVARCHAR(8),
@v_CONCOM_TO_DATE_2 NVARCHAR(8),
@v_CONCOM_TO_DATE_3 NVARCHAR(8),
@v_CONCOM_TO_DATE_4 NVARCHAR(8),
@v_CONCOM_TO_DATE_5 NVARCHAR(8),
@v_CONCOM_TO_DATE_6 NVARCHAR(8),
@v_CONCOM_PRODUCT_1 NVARCHAR(40),
@v_CONCOM_PRODUCT_2 NVARCHAR(40),
@v_CONCOM_PRODUCT_3 NVARCHAR(40),
@v_CONCOM_PRODUCT_4 NVARCHAR(40),
@v_CONCOM_PRODUCT_5 NVARCHAR(40),
@v_CONCOM_PRODUCT_6 NVARCHAR(40),		
@v_NAME_TYPE	NVARCHAR(25)

--DSHARMA70 HMI
DECLARE @V_MANUF_BIRTH_DT NVARCHAR(25),
@V_RPTD_BY_BIRTH_DT NVARCHAR(25)

--print 'mk4'
Declare @RPTD_BY_POS_CODE_R	 int ,			    -- Declare Code realted variables
@MED_TYPE_R	 int , 		
@EQUIP_TYPE_CODE_R  int , 	
@DEVICE_OPER_CODE_R	  int , 
@NAME_TYPE_R	int
	
	--print 'mk5'				
Declare @TotalRows int ,				        -- Declare Other variables 
@v_Dbname varchar(200),
@I_ERRORCOUNT Int = 0 ,				 
@V_MODULENAME varchar (25) = 'MEDWATCH',
@V_ERROR_MESSAGE VARCHAR (MAX),
@V_PROCNAME varchar (25) = 'DA_DDS_MEDWATCH_IMPORT' ,
@V_ERROR_LOCATION_MAIN VARCHAR (255),
@V_ERROR_TABLE_TO_CHECK varchar (25) = 'DDS_MEDWATCH',
@v_ColName varchar (255),
@v_ColName1 varchar (255),
@v_ColName2 varchar (255),
@v_ColName3 varchar (255),
@v_ColName1List varchar (MAX),
@v_ColName2List varchar (MAX),
@v_ColName3List varchar (MAX),
@v_TableName varchar (255) ,
@v_ColNameList  VARCHAR (MAX),
@v_TableNameList  VARCHAR (MAX),
@iCodeId Int = 0 ,
@v_Val varchar (255),
@v_Val1 varchar (255),
@v_Val2 varchar (255),
@v_Val3 varchar (255),
@N_sql nvarchar (max), -- mkaur24 ak
@MANUF_STATE_R int = 0 ,
@RPTD_BY_STATE_R int = 0 ,
@RPTD_BY_PRO_FLAG_R	 int = 0 ,
@ADVERSE_EVENT_FLAG_R  int = 0 ,
@PRODUCT_PROB_FLAG_R int = 0 ,
@HOSPITALIZ_FLAG_R int = 0 ,  
@DISABILITY_FLAG_R  int = 0 ,
@CONGENITAL_FLAG_R   int = 0 ,
@REQD_INTERV_FLAG_R  int = 0  ,
@v_RPTD_BY_TAX_ID_Invalid_Flag int = 0,
@ErrorColumn varchar(255),
@iEntId int,
@i_Reporter_ENTITY_ID_GEN int ,
@iNoError int ,
@PERSON tentity ,
@i_MANUF_ENTITY_ID_GEN int = 0 ,
@Entity_Id INT = 0 ,
@Do_Nothing INT = 0 ,
@Event_ID int = 0,
@DEV_AVAIL_FOR_EVAL_R int = 0,
@EVENT_REAPPEARED_R int = 0 ,
@EVENT_ABATED_R int = 0 ,
@RPT_MANDATORY_R int = 0 ,
@REVENT_ABATED_R int = 0 ,
@V_DTTM_RCD_LAST_UPD_GEN varchar(255),
@v_UPDATED_BY_USER varchar(25) ,
@Event_ID_MED int = 0,
@UNIT_CODE_R int = 0 ,
@LIFE_THREAT_FLAG_R int =  0 ,
@v_Next_unique_id INT = 0 ,
@v_EV_MW_TEST_ROW_ID_GEN int = 0 ,
@v_EV_CONCOM_ROW_ID_GEN int = 0,
@v_EV_X_CONCOM_PROD_GEN int = 0,
@V_ERROR_LOCATION nvarchar(255),
@P_SUPP_ERROR_COUNT_R Int = 0, --ete
@v_EV_X_CONCOM_PROD_RMDB int = 0, --mkaur24 ak
@v_EV_MW_TEST_ROW_ID_GEN_RMDB int = 0 , --mkaur24 ak
@v_ErrorColName varchar (255), --mkaur24 ak
@Event_ID_Icon int = 0 ,--ete
@iTaxIDErr int = 0 ,
@vErrMsgDesc nvarchar (255),
--neha JIRA 33658 starts
@iRunStatCnt int=1, 
@vProcessMsg varchar(100),
@iRunCnt	int=0,
@iTotalRows int=0
--neha JIRA 33658 ends   

--print 'mk6'
If @p_Dbname is not Null 
Set @v_Dbname = '[' + @p_Dbname + '].[DBO].' --mkaur24 ak
--print 'dvbame : ' + @v_dbname 

--print 'mk7'
Select @TotalRows = COUNT (DA_ROW_ID) from DDS_MEDWATCH where JOBID = @p_JOBID and Invalid_Row = 1
SET @iTotalRows=@TotalRows --neha 33658
SET @V_ERROR_LOCATION = 'MW1'
--print 'mk8'
Declare Cur_MedWatch Cursor for  

Select JOBID ,
DA_ROW_ID , 
Invalid_Row ,
Update_Row ,
EVENT_NUMBER, 
UNIT_CODE ,
DATE_RPTD_FDA  ,
DATE_RPTD_MFG  ,
RPTD_BY_LAST_NAME  ,
RPTD_BY_FIRST_NAME  ,
RPTD_BY_ADDR1  ,
RPTD_BY_ADDR2  ,
RPTD_BY_CITY 	 ,
RPTD_BY_STATE  ,
RPTD_BY_ZIP_CODE  ,
RPTD_BY_TAX_ID  ,
RPTD_BY_PRO_FLAG  ,
RPTD_BY_POS_CODE  ,
RELEVANT_HISTORY  ,
LAST_REPORT_DATE  ,
REPORT_YEAR ,
REPORT_SERIAL_NO ,
ADVERSE_EVENT_FLAG  ,
PRODUCT_PROB_FLAG   ,
LIFE_THREAT_FLAG   ,
HOSPITALIZ_FLAG   ,
DISABILITY_FLAG   ,
CONGENITAL_FLAG   ,
REQD_INTERV_FLAG   ,
FOLLOW_UP_COUNT ,
RPT_MANDATORY  ,
MED_TYPE ,
MED_NAME  ,
DOSE  ,
FREQUENCY  ,
ROUTE  ,
THERAPY_FROM_DATE  ,
THERAPY_TO_DATE   ,
DURATION ,
LOT_NUMBER  ,
NDC_NUMBER ,
EXPIRATION_DATE  ,
EVENT_ABATED  ,
EVENT_REAPPEARED  ,
DIAGNOSIS_TEST   ,
BRAND_NAME  ,
EQUIP_TYPE_CODE	  ,
MANUF_NAME  ,
MANUF_ADDR1  ,
MANUF_ADDR2  ,
MANUF_CITY  ,
MANUF_STATE   ,
MANUF_ZIP_CODE	  ,
MODEL_NUMBER  ,
CATALOG_NUMBER  ,
SERIAL_NUMBER  ,
OTHER_NUMBER  ,
DEVICE_OPER_CODE ,
IMPLANT_DATE  ,
EXPLANT_DATE  ,
AGE_OF_DEVICE  ,
DEV_AVAIL_FOR_EVAL  ,
DEVICE_RETURN_DATE  ,
EQ_LOT_NUMBER  ,
EQ_EXPIRATION_DATE  ,
TEST_LAB_TEST_1   ,
TEST_LAB_TEST_2   ,
TEST_LAB_TEST_3   ,
TEST_LAB_TEST_4   ,
TEST_LAB_TEST_5   ,
TEST_RESULT_1  ,
TEST_RESULT_2  ,
TEST_RESULT_3  ,
TEST_RESULT_4  ,
TEST_RESULT_5  ,
TEST_DATE_1	  ,
TEST_DATE_2 ,	  
TEST_DATE_3 , 	  
TEST_DATE_4 ,   
TEST_DATE_5 ,	  
CONCOM_PRODUCT_ID_1  ,
CONCOM_PRODUCT_ID_2  ,
CONCOM_PRODUCT_ID_3  ,
CONCOM_PRODUCT_ID_4  ,
CONCOM_PRODUCT_ID_5  ,
CONCOM_PRODUCT_ID_6  ,
CONCOM_FROM_DATE_1  ,
CONCOM_FROM_DATE_2  ,
CONCOM_FROM_DATE_3  ,
CONCOM_FROM_DATE_4  ,
CONCOM_FROM_DATE_5  ,
CONCOM_FROM_DATE_6  ,
CONCOM_TO_DATE_1  ,
CONCOM_TO_DATE_2  ,
CONCOM_TO_DATE_3  ,
CONCOM_TO_DATE_4  ,
CONCOM_TO_DATE_5  ,
CONCOM_TO_DATE_6  ,
CONCOM_PRODUCT_1  ,
CONCOM_PRODUCT_2  ,
CONCOM_PRODUCT_3  ,
CONCOM_PRODUCT_4  ,
CONCOM_PRODUCT_5  ,
CONCOM_PRODUCT_6  ,

--DSHARMA70 HMI
MANUF_BIRTH_DT ,
RPTD_BY_BIRTH_DT ,

NAME_TYPE from DDS_MEDWATCH where JOBID = @p_Jobid AND Invalid_Row = 1
SET @V_ERROR_LOCATION = 'MW2'
Open Cur_MEDWATCH 
--print 'mk9'
Fetch Next from  Cur_MedWatch into  
@v_JobID ,
@v_DA_Row_ID,
@v_Invalid_Row,
@v_Update_Row ,
@v_EVENT_NUMBER	 ,
@v_UNIT_CODE ,
@v_DATE_RPTD_FDA  ,
@v_DATE_RPTD_MFG  ,
@v_RPTD_BY_LAST_NAME  ,
@v_RPTD_BY_FIRST_NAME  ,
@v_RPTD_BY_ADDR1  ,
@v_RPTD_BY_ADDR2  ,
@v_RPTD_BY_CITY 	 ,
@v_RPTD_BY_STATE  ,
@v_RPTD_BY_ZIP_CODE  ,
@v_RPTD_BY_TAX_ID  ,
@v_RPTD_BY_PRO_FLAG  ,
@v_RPTD_BY_POS_CODE  ,
@v_RELEVANT_HISTORY ,
@v_LAST_REPORT_DATE  ,
@v_REPORT_YEAR , 
@v_REPORT_SERIAL_NO ,
@v_ADVERSE_EVENT_FLAG  ,
@v_PRODUCT_PROB_FLAG   ,
@v_LIFE_THREAT_FLAG   ,
@v_HOSPITALIZ_FLAG   ,
@v_DISABILITY_FLAG   ,
@v_CONGENITAL_FLAG   ,
@v_REQD_INTERV_FLAG   ,
@v_FOLLOW_UP_COUNT ,
@v_RPT_MANDATORY  ,
@v_MED_TYPE ,
@v_MED_NAME  ,
@v_DOSE  ,
@v_FREQUENCY  ,
@v_ROUTE  ,
@v_THERAPY_FROM_DATE  ,
@v_THERAPY_TO_DATE   ,
@v_DURATION ,
@v_LOT_NUMBER  ,
@v_NDC_NUMBER ,
@v_EXPIRATION_DATE  ,
@v_EVENT_ABATED  ,
@v_EVENT_REAPPEARED  ,
@v_DIAGNOSIS_TEST   ,
@v_BRAND_NAME  ,
@v_EQUIP_TYPE_CODE	  ,
@v_MANUF_NAME  ,
@v_MANUF_ADDR1  ,
@v_MANUF_ADDR2  ,
@v_MANUF_CITY  ,
@v_MANUF_STATE   ,
@v_MANUF_ZIP_CODE	  ,
@v_MODEL_NUMBER  ,
@v_CATALOG_NUMBER  ,
@v_SERIAL_NUMBER  ,
@v_OTHER_NUMBER  ,
@v_DEVICE_OPER_CODE  ,
@v_IMPLANT_DATE  ,
@v_EXPLANT_DATE  ,
@v_AGE_OF_DEVICE  ,
@v_DEV_AVAIL_FOR_EVAL  ,
@v_DEVICE_RETURN_DATE  ,
@v_EQ_LOT_NUMBER  ,
@v_EQ_EXPIRATION_DATE  ,
@v_TEST_LAB_TEST_1   ,
@v_TEST_LAB_TEST_2   ,
@v_TEST_LAB_TEST_3   ,
@v_TEST_LAB_TEST_4   ,
@v_TEST_LAB_TEST_5   ,
@v_TEST_RESULT_1  ,
@v_TEST_RESULT_2  ,
@v_TEST_RESULT_3  ,
@v_TEST_RESULT_4  ,
@v_TEST_RESULT_5  ,
@v_TEST_DATE_1	  ,
@v_TEST_DATE_2 ,	  
@v_TEST_DATE_3 , 	  
@v_TEST_DATE_4 ,   
@v_TEST_DATE_5 ,
@v_CONCOM_PRODUCT_ID_1  ,
@v_CONCOM_PRODUCT_ID_2  ,
@v_CONCOM_PRODUCT_ID_3  ,
@v_CONCOM_PRODUCT_ID_4  ,
@v_CONCOM_PRODUCT_ID_5  ,
@v_CONCOM_PRODUCT_ID_6  ,
@v_CONCOM_FROM_DATE_1  ,
@v_CONCOM_FROM_DATE_2  ,
@v_CONCOM_FROM_DATE_3  ,
@v_CONCOM_FROM_DATE_4  ,
@v_CONCOM_FROM_DATE_5  ,
@v_CONCOM_FROM_DATE_6  ,
@v_CONCOM_TO_DATE_1  ,
@v_CONCOM_TO_DATE_2  ,
@v_CONCOM_TO_DATE_3  ,
@v_CONCOM_TO_DATE_4  ,
@v_CONCOM_TO_DATE_5  ,
@v_CONCOM_TO_DATE_6  ,
@v_CONCOM_PRODUCT_1  ,
@v_CONCOM_PRODUCT_2  ,
@v_CONCOM_PRODUCT_3  ,
@v_CONCOM_PRODUCT_4  ,
@v_CONCOM_PRODUCT_5  ,
@v_CONCOM_PRODUCT_6  ,

--DSHARMA70 HMI
@V_MANUF_BIRTH_DT ,
@V_RPTD_BY_BIRTH_DT ,

@v_NAME_TYPE	 
--print 'mk10'
SET @V_ERROR_LOCATION = 'MW3'
While @TotalRows <> 0
Begin
--print 'mk11'
Begin Try
SET @V_ERROR_LOCATION = 'MW4'

SET @V_ERROR_LOCATION = 'MW7'

	If @v_EVENT_NUMBER is Null		 -- 1. Required Field Validation    
	BEGIN
		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @v_JOBID,
			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
			@p_MODULE_NAME = @V_MODULENAME ,
			@p_CALLING_ERROR_LOCATION = 'Main', 
			@p_CURRENT_ERROR_LOCATION = 'REQVD', 
			@p_ERROR_PROC_NAME = @V_PROCNAME ,
			@p_ERROR_MSG = 'Required Fields are Null or Empty.Please provide a valid value.',
			@p_ERROR_COLUMNS = 'EVENT_NUMBER' , 
			@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK ,
			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
			@P_IS_VALIDATION = 1 ;
			 
		    SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
	END;   
	IF @v_RPTD_BY_LAST_NAME is Null --mkaur24 ak
	Begin
		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @v_JOBID,
			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
			@p_MODULE_NAME = @V_MODULENAME ,
			@p_CALLING_ERROR_LOCATION = 'Main', 
			@p_CURRENT_ERROR_LOCATION = 'REQVD', 
			@p_ERROR_PROC_NAME = @V_PROCNAME ,
			@p_ERROR_MSG = 'Required Fields are Null or Empty.Please provide a valid value.',
			@p_ERROR_COLUMNS = 'RPTD_BY_LAST_NAME' , 
			@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK ,
			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
			@P_IS_VALIDATION = 1 ;
			 
		    SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
	End


		SET @V_ERROR_LOCATION = 'MW8'
	Begin							 -- 2. Code Field Validation        
		Set @v_ColNameList   =  'RPTD_BY_POS_CODE|MED_TYPE|EQUIP_TYPE_CODE|DEVICE_OPER_CODE|NAME_TYPE|'

		Set @v_TableNameList =  'POSITIONS|MEDICATION_TYPE|EQUIP_TYPE_CODE|DEVICE_OPER_CODES|ENTITY_NAME_TYPE|'
		
		While CHARINDEX ('|' , @v_ColNameList , 1) > 0
		Begin

			Set @v_ColName		= Left(@v_ColNameList ,CharIndex('|' , @v_ColNameList , 1) - 1 )
			
			Set @v_ColNameList  = Right (@v_ColNameList ,Len (@v_ColNameList) - CharIndex ('|', @v_ColNameList, 1) )
			Set @v_TableName = Left ( @v_TableNameList , CharIndex ('|',@v_TableNameList,1) - 1 )
			Set @v_TableNameList = Right(@v_TableNameList , Len (@v_TableNameList) - CharIndex('|',@v_TableNameList,1 ))

			Select @v_Val = ( Case
				When  @v_ColName   = 'RPTD_BY_POS_CODE'  Then  @v_RPTD_BY_POS_CODE
				When  @v_ColName   = 'MED_TYPE'          Then  @v_MED_TYPE
				When  @v_ColName   = 'EQUIP_TYPE_CODE'   Then  @v_EQUIP_TYPE_CODE
				When  @v_ColName   = 'DEVICE_OPER_CODE'  Then  @v_DEVICE_OPER_CODE
				When  @v_ColName   = 'NAME_TYPE'         Then  @v_NAME_TYPE   --dsharma70 hmi RMA-24636
		
			End )
			
			If @v_Val is Not Null
			Begin
				EXECUTE DDS_CODE_VALIDATION_IMPORT @p_JOBID  = @p_JOBID, 
					@P_SHORT_CODE		    = @v_Val , -- Short Code
					@P_SYS_TABLE_NAME       = @v_TableName , -- SYstem Table Name to Check
					@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes , -- It is used to check allow creation of code flag is set by user or not						
					@P_DB_NAME			    = @v_Dbname , -- It is used to fetch error msg and append into the error msg and update it again
					@P_LOB				    = 0 , -- LOB GC, WC ( It Will be numeric)
					@p_DA_ROW_ID            = @v_DA_ROW_ID,
					@p_MODULE_NAME		    = @V_MODULENAME  ,
					@p_ERROR_LOCATION       = 'CODEVD31' , --mkaur24
					@p_ERROR_PROC_NAME      = 'DDS_CODE_VALIDATION_IMPORT' ,
					@p_ERROR_KEY_COLUMN		= 'EVENT_NUMBER' ,
					@p_ERROR_COLUMN         =  @v_ColName , 
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK ,
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
					@P_CODE_ID_R			  = @iCodeId OUTPUT 	;
				
				If @iCodeId = 0 or @iCodeId = Null 
				Set @I_ERRORCOUNT = @I_ERRORCOUNT + 1 	
			End
			
			If			@v_ColName = 'RPTD_BY_POS_CODE'			Set  @RPTD_BY_POS_CODE_R	= @iCodeId  --come
			Else If     @v_ColName = 'MED_TYPE'					Set  @MED_TYPE_R			= @iCodeId 
			Else If     @v_ColName = 'EQUIP_TYPE_CODE'			Set  @EQUIP_TYPE_CODE_R	= @iCodeId 
			Else If     @v_ColName = 'DEVICE_OPER_CODE'			Set  @DEVICE_OPER_CODE_R	= @iCodeId 
			Else If     @v_ColName = 'NAME_TYPE'				Set  @NAME_TYPE_R			= @iCodeId 		

			SET @iCodeId = NULL
		End
	End
		SET @V_ERROR_LOCATION = 'MW9'
	Begin						     -- 3. Date Format Validation       

		Set @v_ColNameList = 'DEVICE_RETURN_DATE|EXPIRATION_DATE|IMPLANT_DATE|EXPLANT_DATE|LAST_REPORT_DATE|THERAPY_FROM_DATE|DATE_RPTD_MFG|THERAPY_TO_DATE|'
		Set @v_ColNameList = @v_ColNameList + 'EQ_EXPIRATION_DATE|TEST_DATE_1|TEST_DATE_2|TEST_DATE_3|TEST_DATE_4|TEST_DATE_5|CONCOM_FROM_DATE_1|'
		Set @v_ColNameList = @v_ColNameList + 'CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_TO_DATE_6|DATE_RPTD_FDA|'
		
		--dsharma70 hmi
		Set @v_ColNameList = @v_ColNameList + 'MANUF_BIRTH_DT|RPTD_BY_BIRTH_DT|'

			While CHARINDEX ('|', @v_ColNameList , 1 )  > 0
			Begin

				Set @v_ColName = Left (@v_ColNameList , CharIndex ('|' , @v_ColNameList , 1) - 1 ) --MKAUR24 AK
				
				Set @v_ColNameList = RIGHT (@v_ColNameList , LEN(@v_ColNameList) - CHARINDEX( '|' , @v_ColNameList , 1 ))

				Select @v_Val = (Case  
					When  @v_ColName = 'DEVICE_RETURN_DATE'    Then  @v_DEVICE_RETURN_DATE
					When  @v_ColName = 'EXPIRATION_DATE'       Then  @v_EXPIRATION_DATE
					When  @v_ColName = 'IMPLANT_DATE'	       Then  @v_IMPLANT_DATE
					When  @v_ColName = 'EXPLANT_DATE'          Then  @v_EXPLANT_DATE
					When  @v_ColName = 'LAST_REPORT_DATE'      Then  @v_LAST_REPORT_DATE
					When  @v_ColName = 'THERAPY_FROM_DATE'	   Then  @v_THERAPY_FROM_DATE
					When  @v_ColName = 'DATE_RPTD_MFG'         Then  @v_DATE_RPTD_MFG
					When  @v_ColName = 'THERAPY_TO_DATE'       Then  @v_THERAPY_TO_DATE
					When  @v_ColName = 'EQ_EXPIRATION_DATE'    Then  @v_EQ_EXPIRATION_DATE				
					When  @v_ColName = 'TEST_DATE_1'           Then  @v_TEST_DATE_1
					When  @v_ColName = 'TEST_DATE_2'           Then  @v_TEST_DATE_2
					When  @v_ColName = 'TEST_DATE_3'           Then  @v_TEST_DATE_3
					When  @v_ColName = 'TEST_DATE_4'           Then  @v_TEST_DATE_4
					When  @v_ColName = 'TEST_DATE_5'           Then  @v_TEST_DATE_5
					When  @v_ColName = 'CONCOM_FROM_DATE_1'	   Then  @v_CONCOM_FROM_DATE_1	--knakra(correct these column names)
					When  @v_ColName = 'CONCOM_FROM_DATE_2'	   Then  @v_CONCOM_FROM_DATE_2
					When  @v_ColName = 'CONCOM_FROM_DATE_3'	   Then  @v_CONCOM_FROM_DATE_3
					When  @v_ColName = 'CONCOM_FROM_DATE_4'	   Then  @v_CONCOM_FROM_DATE_4
					When  @v_ColName = 'CONCOM_FROM_DATE_5'	   Then  @v_CONCOM_FROM_DATE_5
					When  @v_ColName = 'CONCOM_FROM_DATE_6'	   Then  @v_CONCOM_FROM_DATE_6
					When @v_ColName  = 'DATE_RPTD_FDA'         Then  @v_DATE_RPTD_FDA				
					
					--dsharma70 hmi
					When @v_ColName  = 'MANUF_BIRTH_DT'         Then  @v_MANUF_BIRTH_DT
					When @v_ColName  = 'RPTD_BY_BIRTH_DT'         Then  @v_RPTD_BY_BIRTH_DT
				End)

				If @v_Val is not null
				Begin				
					If    ISNumeric (@v_Val) = 0 or LEN (@v_Val) <> 8 or ISDATE (@v_Val) = 0  --mkaur24 ak
					Begin
						EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'DATEFORMAT', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'Invalid Date. Please provide Date in YYYYMMDD format .' ,
						@p_ERROR_COLUMNS = @v_ColName , 
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ; 
						
						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
					End
					Else
					Begin	--knakra(added)
						IF  (@VALID_START_DATE > @v_Val) or  ( @v_Val > @VALID_END_DATE)
						BEGIN
							EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
								@p_DA_ROW_ID  = @V_DA_ROW_ID , 
								@p_MODULE_NAME = @V_MODULENAME ,
								@p_CALLING_ERROR_LOCATION = 'Main', 
								@p_CURRENT_ERROR_LOCATION = 'DATEFORMAT2', 
								@p_ERROR_PROC_NAME = @V_PROCNAME ,
								@p_ERROR_MSG = 'Date must fall between the date range selected at UI .' ,
								@p_ERROR_COLUMNS = @v_ColName , 
								@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
								@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
								@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
								@P_IS_VALIDATION = 1 ; 
						
							SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
						End
					End	--knakra(added)
				End
			End
	End
		SET @V_ERROR_LOCATION = 'MW10'
	Begin						     -- 4. Tax_id Format validation     
		--If @v_RPTD_BY_TAX_ID is Not null
		--Begin
			IF @v_RPTD_BY_TAX_ID IS NOT NULL AND @v_RPTD_BY_TAX_ID  <> ''
							BEGIN
								IF ISNUMERIC(REPLACE(@v_RPTD_BY_TAX_ID,'-','')) = 1
								BEGIN
									IF LEN(REPLACE(@v_RPTD_BY_TAX_ID,'-','')) = 9
									BEGIN
										IF LEN(@v_RPTD_BY_TAX_ID) - LEN(REPLACE(@v_RPTD_BY_TAX_ID,'-','')) = 1
										BEGIN
											IF CHARINDEX('-', @v_RPTD_BY_TAX_ID, 1) <> 3
											BEGIN
												SET @iTaxIDErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@v_RPTD_BY_TAX_ID) - LEN(REPLACE(@v_RPTD_BY_TAX_ID,'-','')) = 2
										BEGIN
											IF CHARINDEX('-', @v_RPTD_BY_TAX_ID, 1) = 4 AND (CHARINDEX('-', @v_RPTD_BY_TAX_ID, 5) IN (7,8))
											BEGIN
												SET @iTaxIDErr = 0
											END
											ELSE
											BEGIN
												SET @iTaxIDErr = 1
												SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
											END
										END
										ELSE IF LEN(@v_RPTD_BY_TAX_ID) - LEN(REPLACE(@v_RPTD_BY_TAX_ID,'-','')) = 0
										BEGIN
											SET @iTaxIDErr = 0
										END
										ELSE
										BEGIN
											SET @iTaxIDErr = 1
											SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
										END
									END
									ELSE
									BEGIN
										SET @iTaxIDErr = 1
										SET @vErrMsgDesc = 'Tax-Id should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
									END
								END
								ELSE
								BEGIN
									SET @iTaxIDErr = 1
									SET @vErrMsgDesc = 'Tax-Id provided  is not is Numeric form and should be in one of these formats(###-##-####, ###-###-###, ##-#######). '
								END
							END
IF @iTaxIDErr = 1
							BEGIN
										EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					@p_MODULE_NAME = @V_MODULENAME ,
					@p_CALLING_ERROR_LOCATION = 'Main', 
					@p_CURRENT_ERROR_LOCATION = 'TAXIDVD', 
					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					@p_ERROR_MSG = 'Please provide a valid TAX_ID no.',
					@p_ERROR_COLUMNS = 'RPTD_BY_TAX_ID' , 
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					@P_IS_VALIDATION = 1 ; 
									SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
			Set @v_RPTD_BY_TAX_ID_Invalid_Flag = 1
							END
		
		--	If Len (Replace(@v_RPTD_BY_TAX_ID , '-' , '' )) <> 9	--knakra(what if tax_id is not numeric)
		--	Begin
		--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
		--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
		--			@p_MODULE_NAME = @V_MODULENAME ,
		--			@p_CALLING_ERROR_LOCATION = 'Main', 
		--			@p_CURRENT_ERROR_LOCATION = 'TAXIDVD', 
		--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
		--			@p_ERROR_MSG = 'Please provide a valid TAX_ID no.',
		--			@p_ERROR_COLUMNS = 'RPTD_BY_TAX_ID' , 
		--			@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
		--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
		--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
		--			@P_IS_VALIDATION = 1 ; 
				
		--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
		--		Set @v_RPTD_BY_TAX_ID_Invalid_Flag = 1			
		--	End
		--End
	End
		SET @V_ERROR_LOCATION = 'MW11'
	Begin						     -- 5. Flags    Validation		
		Set @v_ColNameList = 'RPTD_BY_PRO_FLAG|ADVERSE_EVENT_FLAG|PRODUCT_PROB_FLAG|LIFE_THREAT_FLAG|'
		Set @v_ColNameList = @v_ColNameList + 'HOSPITALIZ_FLAG|DISABILITY_FLAG|CONGENITAL_FLAG|REQD_INTERV_FLAG|'
		Set @v_ColNameList = @v_ColNameList + 'DEV_AVAIL_FOR_EVAL|EVENT_REAPPEARED|EVENT_ABATED|RPT_MANDATORY|'
		--print @v_ColNameList
		While CHARINDEX ('|' ,@v_ColNameList , 1 ) > 0
		Begin
			Set @v_ColName     =  LEFT (@v_ColNameList , CHARINDEX ( '|' , @v_ColNameList , 1 ) - 1 )
				
			Set @v_ColNameList =  RIGHT (@v_ColNameList , (LEN (@v_ColNameList)  - CHARINDEX ('|' ,@v_ColNameList , 1  )  )) --MKAUR24 AK
				
		Select @v_Val = (Case
			When @v_ColName = 'RPTD_BY_PRO_FLAG'   Then @v_RPTD_BY_PRO_FLAG
			When @v_ColName = 'ADVERSE_EVENT_FLAG' Then @v_ADVERSE_EVENT_FLAG
			When @v_ColName = 'PRODUCT_PROB_FLAG'  Then @v_PRODUCT_PROB_FLAG
			When @v_ColName = 'LIFE_THREAT_FLAG'   Then @v_LIFE_THREAT_FLAG				    
			When @v_ColName = 'HOSPITALIZ_FLAG'    Then @v_HOSPITALIZ_FLAG
			When @v_ColName = 'DISABILITY_FLAG'    Then @v_DISABILITY_FLAG
			When @v_ColName = 'CONGENITAL_FLAG'    Then @v_CONGENITAL_FLAG
			When @v_ColName = 'REQD_INTERV_FLAG'   Then @v_REQD_INTERV_FLAG
			When @v_ColName = 'DEV_AVAIL_FOR_EVAL' Then @v_DEV_AVAIL_FOR_EVAL
			When @v_ColName = 'EVENT_REAPPEARED'   Then @v_EVENT_REAPPEARED
			When @v_ColName = 'EVENT_ABATED'		Then @v_EVENT_ABATED
			When @v_ColName = 'RPT_MANDATORY'		Then @v_RPT_MANDATORY
		End)
			
			If @v_Val is Not Null
			Begin
				If upper(@v_Val)  <> 'Y' and  Upper(@v_val) <> 'N' --mkaur24 ak
				Begin 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'FlagVD', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'If providing value for flag column,acceptable value is either Y/N ',
						@p_ERROR_COLUMNS = @v_ColName , 
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER', --MKAUR24 1/12  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 1 ; 
						
					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
				End
				Else IF @v_ColName = 'RPTD_BY_PRO_FLAG'   AND UPPER( @v_Val) = 'Y'  SET @RPTD_BY_PRO_FLAG_R   = -1
				Else IF @v_ColName = 'RPTD_BY_PRO_FLAG'   AND UPPER( @v_Val) = 'N'  SET @RPTD_BY_PRO_FLAG_R   =  0

				Else IF @v_ColName = 'ADVERSE_EVENT_FLAG' AND UPPER( @v_Val) = 'Y'  SET @ADVERSE_EVENT_FLAG_R = -1
				Else IF @v_ColName = 'ADVERSE_EVENT_FLAG' AND UPPER( @v_Val) = 'N'  SET @ADVERSE_EVENT_FLAG_R =  0

				Else IF @v_ColName = 'PRODUCT_PROB_FLAG'  AND UPPER( @v_Val) = 'Y'  SET @PRODUCT_PROB_FLAG_R  = -1
				Else IF @v_ColName = 'PRODUCT_PROB_FLAG'  AND UPPER( @v_Val) = 'N'  SET @PRODUCT_PROB_FLAG_R  =  0


				Else IF @v_ColName = 'LIFE_THREAT_FLAG'    AND UPPER( @v_Val) = 'Y'  SET @LIFE_THREAT_FLAG_R    = -1
				Else IF @v_ColName = 'LIFE_THREAT_FLAG'    AND UPPER( @v_Val) = 'N'  SET @LIFE_THREAT_FLAG_R    =  0

				Else IF @v_ColName = 'HOSPITALIZ_FLAG'    AND UPPER( @v_Val) = 'Y'  SET @HOSPITALIZ_FLAG_R    = -1
				Else IF @v_ColName = 'HOSPITALIZ_FLAG'    AND UPPER( @v_Val) = 'N'  SET @HOSPITALIZ_FLAG_R    =  0

				Else IF @v_ColName = 'DISABILITY_FLAG'    AND UPPER( @v_Val) = 'Y'  SET @DISABILITY_FLAG_R    = -1
				Else IF @v_ColName = 'DISABILITY_FLAG'    AND UPPER( @v_Val) = 'N'  SET @DISABILITY_FLAG_R    =  0

				Else IF @v_ColName = 'CONGENITAL_FLAG'    AND UPPER( @v_Val) = 'Y'  SET @CONGENITAL_FLAG_R    = -1
				Else IF @v_ColName = 'CONGENITAL_FLAG'    AND UPPER( @v_Val) = 'N'  SET @CONGENITAL_FLAG_R    =  0

				Else IF @v_ColName = 'REQD_INTERV_FLAG'   AND UPPER( @v_Val) = 'Y'  SET @REQD_INTERV_FLAG_R   = -1
				Else IF @v_ColName = 'REQD_INTERV_FLAG'   AND UPPER( @v_Val) = 'N'  SET @REQD_INTERV_FLAG_R   =  0		 

				Else IF @v_ColName = 'DEV_AVAIL_FOR_EVAL'   AND UPPER( @v_Val) = 'Y'  SET @DEV_AVAIL_FOR_EVAL_R   = -1
				Else IF @v_ColName = 'DEV_AVAIL_FOR_EVAL'   AND UPPER( @v_Val) = 'N'  SET @DEV_AVAIL_FOR_EVAL_R   =  0

				Else IF @v_ColName = 'EVENT_REAPPEARED'   AND UPPER( @v_Val) = 'Y'  SET @EVENT_REAPPEARED_R   = -1
				Else IF @v_ColName = 'EVENT_REAPPEARED'   AND UPPER( @v_Val) = 'N'  SET @EVENT_REAPPEARED_R   =  0

				Else IF @v_ColName = 'EVENT_ABATED'   AND UPPER( @v_Val) = 'Y'      SET @EVENT_ABATED_R   = -1
				Else IF @v_ColName = 'EVENT_ABATED'   AND UPPER( @v_Val) = 'N'      SET @EVENT_ABATED_R   =  0

				Else IF @v_ColName = 'REQD_INTERV_FLAG'   AND UPPER( @v_Val) = 'Y'  SET @REQD_INTERV_FLAG_R   = -1
				Else IF @v_ColName = 'REQD_INTERV_FLAG'   AND UPPER( @v_Val) = 'N'  SET @REQD_INTERV_FLAG_R   =  0

				Else IF @v_ColName = 'RPT_MANDATORY'   AND UPPER( @v_Val) = 'Y'    SET @RPT_MANDATORY_R   = -1
				Else IF @v_ColName = 'RPT_MANDATORY'   AND UPPER( @v_Val) = 'N'    SET @RPT_MANDATORY_R   =  0
			End
		End
	End
		SET @V_ERROR_LOCATION = 'MW12'

	Begin                            -- 6. Zip Code Validation	
		If @v_RPTD_BY_ZIP_CODE is Not Null and 
		---(  ISNUMERIC (REPLACE (@v_RPTD_BY_ZIP_CODE , '-' , '') ) = 0 OR
		LEN (REPLACE (REPLACE (@v_RPTD_BY_ZIP_CODE , '-' , '') , ' ' , '') )  NOT IN (9,5,6) 
		Begin
			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				@p_MODULE_NAME = @V_MODULENAME ,
				@p_CALLING_ERROR_LOCATION = 'Main', 
				@p_CURRENT_ERROR_LOCATION = 'zip1', 
				@p_ERROR_PROC_NAME = @V_PROCNAME ,
				@p_ERROR_MSG = 'Please provide a valid ZIP_CODE no.',
				@p_ERROR_COLUMNS = 'RPTD_BY_ZIP_CODE' , 
				@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				@P_IS_VALIDATION = 1 ; 
			
			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
		End
			SET @V_ERROR_LOCATION = 'MW13'
		If @v_MANUF_ZIP_CODE is Not Null and
		----(  ISNUMERIC (REPLACE (@v_MANUF_ZIP_CODE , '-' , '') ) = 0 OR  
		LEN (REPLACE (REPLACE (@v_MANUF_ZIP_CODE , '-' , '') , ' ' , '') )  NOT IN (9,5,6) 
		Begin
			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				@p_MODULE_NAME = @V_MODULENAME ,
				@p_CALLING_ERROR_LOCATION = 'Main', 
				@p_CURRENT_ERROR_LOCATION = 'zip2', 
				@p_ERROR_PROC_NAME = @V_PROCNAME ,
				@p_ERROR_MSG = 'Please provide a valid ZIP_CODE no.',
				@p_ERROR_COLUMNS = 'MANUF_ZIP_CODE' , 
				@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				@P_IS_VALIDATION = 1 ; 
				
		   SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
		End
		SET @V_ERROR_LOCATION = 'MW14'
	End

	Begin						     -- 7. State  Validation			
		If @v_MANUF_STATE is not null      
		Begin
			Set @v_MANUF_STATE = UPPER(@v_MANUF_STATE) 		
			Set @N_sql = 'Select @v_STATE_ROW_ID_P = STATE_ROW_ID from ' + @v_Dbname + 'States  where upper(STATE_ID) = @v_MANUF_STATE_P  '
				Begin Try
				Exec sp_Executesql  @N_sql ,
					N'@v_STATE_ROW_ID_P int output ,
					@v_MANUF_STATE_P nvarchar (4)',
					@v_MANUF_STATE_P = @v_MANUF_STATE ,
					@v_STATE_ROW_ID_P = @MANUF_STATE_R output ;
				End Try			
				Begin Catch		
					SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'STATESVD', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = 'Exception' ,
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
				
					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				End Catch
		End
		SET @V_ERROR_LOCATION = 'MW15'
		If @v_RPTD_BY_STATE is not null	   
		Begin
			Set @v_RPTD_BY_STATE = UPPER(@v_RPTD_BY_STATE) 		
			Set @N_sql = 'Select @v_STATE_ROW_ID_P = STATE_ROW_ID from ' + @v_Dbname + 'States  where upper(STATE_ID) = @v_RPTD_BY_STATE_P  '
				Begin Try
					Exec sp_Executesql  @N_sql ,
						N'@v_STATE_ROW_ID_P int output ,
						@v_RPTD_BY_STATE_P nvarchar (4)',
						@v_RPTD_BY_STATE_P = @v_RPTD_BY_STATE ,
						@v_STATE_ROW_ID_P = @RPTD_BY_STATE_R output ;
				End Try			
				Begin Catch
					SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'STATESVD', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = 'Exception' ,
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
					
					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				End Catch
		End
	End
		SET @V_ERROR_LOCATION = 'MW16'
	Begin							 -- 8. Reporter Entity              
		If @v_RPTD_BY_LAST_NAME is Not Null and @v_RPTD_BY_TAX_ID_Invalid_Flag = 0
		Begin
			SET @iNoError = 1
			SET @ErrorColumn = ''	
			
			IF @NonEmployeeMatchByTaxId = 1 AND  @v_RPTD_BY_TAX_ID  IS NULL
			BEGIN
				EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
					@p_DA_ROW_ID = @V_DA_ROW_ID , 
					@p_MODULE_NAME = @V_MODULENAME,
					@p_CALLING_ERROR_LOCATION = 'MAIN' ,	
					@p_CURRENT_ERROR_LOCATION  = 'REPORTVD1' , 
					@p_ERROR_PROC_NAME = @V_PROCNAME,
					@p_ERROR_MSG = 'Match by tax_id is checked however ,REPORTED_TAX_ID is not provided. ', 
					@p_ERROR_COLUMNS = 'RPTD_BY_TAX_ID', 
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
					@P_IS_VALIDATION = 1 ;  										 
				
				SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
				SET @iNoError = 0	--knakra latest
			END
					
			If @iNoError =1
			Begin
				If @NonEmployeeMatchByName <> 0
					Set @ErrorColumn = 'RPTD_BY_LAST_NAME'
				If @NonEmployeeMatchByTaxId <> 0 and @v_RPTD_BY_TAX_ID is null 
				Begin
					If @ErrorColumn <>  ''
						Set @ErrorColumn = @ErrorColumn + ';'
					Set @ErrorColumn = @ErrorColumn +  'RPTD_BY_TAX_ID'
				End
				
				--dsharma70 hmi INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vFirstName ,vTaxId  ,vAddr1 ,vAddr2 ,vCity , vState , vZip , vTableName,  iNameType ) 
				INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vFirstName ,vTaxId  ,vAddr1 ,vAddr2 ,vCity , vState , vZip , vTableName,  iNameType, vBirthDate ) 
				--dsharma70 hmi VALUES( @V_DA_ROW_ID ,@p_jobID ,  @v_RPTD_BY_LAST_NAME,@v_RPTD_BY_FIRST_NAME,@v_RPTD_BY_TAX_ID,@v_RPTD_BY_ADDR1,@v_RPTD_BY_ADDR2 ,@v_RPTD_BY_CITY ,@RPTD_BY_STATE_R ,@v_RPTD_BY_ZIP_CODE ,'OTHER_PEOPLE', @NAME_TYPE_R )
				VALUES( @V_DA_ROW_ID ,@p_jobID ,  @v_RPTD_BY_LAST_NAME,@v_RPTD_BY_FIRST_NAME,@v_RPTD_BY_TAX_ID,@v_RPTD_BY_ADDR1,@v_RPTD_BY_ADDR2 ,@v_RPTD_BY_CITY ,@RPTD_BY_STATE_R ,@v_RPTD_BY_ZIP_CODE ,'OTHER_PEOPLE', @NAME_TYPE_R, @V_RPTD_BY_BIRTH_DT ) --dsharma70 hmi    
					BEGIN TRY	
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
							@p_ERROR_COLUMNS = 'Exception' ,
							@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
							@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							@P_IS_VALIDATION = 0 ; 	
						
						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
					END CATCH

					SET @i_Reporter_ENTITY_ID_GEN = @iEntId ;			

				IF (@i_Reporter_ENTITY_ID_GEN = 0)
					BEGIN	
						EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
							@p_DA_ROW_ID = @V_DA_ROW_ID , 
							@p_MODULE_NAME = @V_MODULENAME,
							@p_CALLING_ERROR_LOCATION = 'Reporter' ,	
							@p_CURRENT_ERROR_LOCATION  = 'REPORTVD3', 
							@p_ERROR_PROC_NAME = @V_PROCNAME,
							@p_ERROR_MSG =  @V_ERROR_MESSAGE , 
							@p_ERROR_COLUMNS = @ErrorColumn, 
							@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
							@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
							@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
							@P_IS_VALIDATION = 1 ;
						
						SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
					END
			End
		End
	End
		SET @V_ERROR_LOCATION = 'MW17'
	Begin							 -- 9. Manufacturer Entity 
		If @v_MANUF_NAME is Not Null 
			Begin
			SET @iNoError = 1
			SET @ErrorColumn = ''	
			--IF @NonEmployeeMatchByTaxId = 1 AND  @v_RPTD_BY_TAX_ID  IS NULL
			--				BEGIN
			--								EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
			--									 @p_DA_ROW_ID = @V_DA_ROW_ID , 
			--									 @p_MODULE_NAME = @V_MODULENAME,
			--									 @p_CALLING_ERROR_LOCATION = 'MAIN' ,	
			--									 @p_CURRENT_ERROR_LOCATION  = 'REPORTVD1' , 
			--									 @p_ERROR_PROC_NAME = @V_PROCNAME,
			--									 @p_ERROR_MSG = 'Match by tax_id is checked however ,REPORTED_TAX_ID is not provided. ', 
			--									 @p_ERROR_COLUMNS = 'RPTD_BY_TAX_ID', 
			--									 @p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
			--									 @p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
			--									@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
			--									@P_IS_VALIDATION = 1 ;  										 
			--										SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;
			--										SET @iNoError = 0	--knakra latest
			--				END
			If @iNoError =1
			Begin
				If @NonEmployeeMatchByName <> 0
					Set @ErrorColumn = 'MANUF_NAME'
				--If @NonEmployeeMatchByTaxId <> 0
				--  Begin
				--	  If @ErrorColumn <>  ''
				--		 Set @ErrorColumn = @ErrorColumn + ','
				--	Set @ErrorColumn = @ErrorColumn +  'RPTD_BY_TAX_ID'
				--  End
				--dsharma70 hmi INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vAddr1 ,vAddr2 ,vCity , vState , vZip , vTableName,  iNameType ) 
				INSERT INTO @PERSON (iDaRowId , iJobId , vLastName ,vAddr1 ,vAddr2 ,vCity , vState , vZip , vTableName,  iNameType, vBirthDate ) 
				--dsharma70 hmi VALUES( @V_DA_ROW_ID ,@p_jobID ,  @v_MANUF_NAME ,@v_MANUF_ADDR1,@v_MANUF_ADDR2 ,@v_MANUF_CITY ,@MANUF_STATE_R ,@v_MANUF_ZIP_CODE ,'MANUFACTURERS',@NAME_TYPE_R)     
				VALUES( @V_DA_ROW_ID ,@p_jobID ,  @v_MANUF_NAME ,@v_MANUF_ADDR1,@v_MANUF_ADDR2 ,@v_MANUF_CITY ,@MANUF_STATE_R ,@v_MANUF_ZIP_CODE ,'MANUFACTURERS',@NAME_TYPE_R, @V_MANUF_BIRTH_DT )     
					BEGIN TRY
						EXEC PROCESS_ENTITY @pEntType = @PERSON,
							@PJOBID = @p_jobID,
							@PDAROWID = @v_DA_ROW_ID,
							@vDBNAME = @V_DBNAME,
							@pModuleName = @V_MODULENAME,
							@iForceCrtEnt = 0,
							@iUseTaxId = 0,		--knakra(this should be 0 if there is no column for tax id for manufacturer)
							@pCallingErrorLoc = 'manufct1',
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
							@p_CURRENT_ERROR_LOCATION = 'manufct2', 
							@p_ERROR_PROC_NAME = @V_PROCNAME ,
							@p_ERROR_MSG = @V_ERROR_MESSAGE ,
							@p_ERROR_COLUMNS = 'Exception' ,
							@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
							@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
							@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
							@P_IS_VALIDATION = 0 ; 	
						
						SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
					END CATCH

					SET @i_MANUF_ENTITY_ID_GEN = @iEntId ;			

				IF (@i_MANUF_ENTITY_ID_GEN = 0)
				BEGIN	
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID, 
						@p_DA_ROW_ID = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME,
						@p_CALLING_ERROR_LOCATION = 'manufct1' ,	
						@p_CURRENT_ERROR_LOCATION  = 'manufct3', 
						@p_ERROR_PROC_NAME = @V_PROCNAME,
						@p_ERROR_MSG =  @V_ERROR_MESSAGE , 
						@p_ERROR_COLUMNS = @ErrorColumn, 
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER ,
						@P_IS_VALIDATION = 1 ;
					
					SET @I_ERRORCOUNT = @I_ERRORCOUNT +1 ;	
				END

			End
		End
	End
		SET @V_ERROR_LOCATION = 'MW18'
	Begin							 -- 10. Validaton for EVENT_X_MEDW_TEST's Columns
		Set @v_ColNameList  = 'TEST_LAB_TEST_1|TEST_LAB_TEST_2|TEST_LAB_TEST_3|TEST_LAB_TEST_4|TEST_LAB_TEST_5|' --mkaur24 ak
		Set @v_ColName1List = 'TEST_RESULT_1|TEST_RESULT_2|TEST_RESULT_3|TEST_RESULT_4|TEST_RESULT_5|'
		Set @v_ColName2List = 'TEST_DATE_1|TEST_DATE_2|TEST_DATE_3|TEST_DATE_4|TEST_DATE_5|'

		While CHARINDEX ('|' , @v_ColNameList , 1) > 0    
			Begin  

				Set @v_ColName		= LEFT (@v_ColNameList , CHARINDEX ('|' , @v_ColNameList , 1 ) - 1 )  
				Set @v_ColNameList = Right (@v_ColNameList ,len(@v_ColNameList) - CharIndex ('|', @v_ColNameList, 1) )		

				Set @v_ColName1 = LEFT (@v_ColName1List , CHARINDEX ('|' , @v_ColName1List , 1 ) - 1 )
				Set @v_ColName1List = Right (@v_ColName1List ,len(@v_ColName1List) - CharIndex ('|', @v_ColName1List, 1) )		 

				Set @v_ColName2 = LEFT (@v_ColName2List , CHARINDEX ('|' , @v_ColName2List , 1 ) - 1 )
				Set @v_ColName2List = Right (@v_ColName2List ,len(@v_ColName2List) - CharIndex ('|', @v_ColName2List, 1) )	
				
				Select @v_Val = ( Case				
					When @v_ColName = 'TEST_LAB_TEST_1'  Then  @v_TEST_LAB_TEST_1  --mkaur24 ak
					When @v_ColName = 'TEST_LAB_TEST_2'  Then  @v_TEST_LAB_TEST_2
					When @v_ColName = 'TEST_LAB_TEST_3'  Then  @v_TEST_LAB_TEST_3
					When @v_ColName = 'TEST_LAB_TEST_4'  Then  @v_TEST_LAB_TEST_4
					When @v_ColName = 'TEST_LAB_TEST_5'  Then  @v_TEST_LAB_TEST_5
				End )
				Select @v_Val1 = ( Case			
					When @v_ColName1 = 'TEST_RESULT_1'  Then  @v_TEST_RESULT_1  --mkaur24 ak
					When @v_ColName1 = 'TEST_RESULT_2'  Then  @v_TEST_RESULT_2
					When @v_ColName1 = 'TEST_RESULT_3'  Then  @v_TEST_RESULT_3
					When @v_ColName1 = 'TEST_RESULT_4'  Then  @v_TEST_RESULT_4
					When @v_ColName1 = 'TEST_RESULT_5'  Then  @v_TEST_RESULT_5
				End )
				Select @v_Val2 = ( Case			
					When @v_ColName2 = 'TEST_DATE_1'  Then  @v_TEST_DATE_1  --mkaur24 ak
					When @v_ColName2 = 'TEST_DATE_2'  Then  @v_TEST_DATE_2
					When @v_ColName2 = 'TEST_DATE_3'  Then  @v_TEST_DATE_3
					When @v_ColName2 = 'TEST_DATE_4'  Then  @v_TEST_DATE_4
					When @v_ColName2 = 'TEST_DATE_5'  Then  @v_TEST_DATE_5
				End )
				If @v_Val is not null and  @v_Val1 is not null and  @v_Val2 is not null  --knakra(if all 3 are null then error will be logged)
					Set @Do_Nothing = 1;
				Else if  @v_Val is  null and  @v_Val1 is  null and  @v_Val2 is  null  --knakra(if all 3 are null then error will be logged)
					Set @Do_Nothing = 2;
				Else
				Begin
				Set @v_ErrorColName = @v_ColName + ';' + @v_ColName1 + ';' + @v_ColName2 ;  --mkaur24 ak
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'zip2', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = 'The number of values in each column must be equal.',
						@p_ERROR_COLUMNS = @v_ErrorColName  ,   --mkaur24 ak
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 1 ; 		    

					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
				End
			End
	End
		SET @V_ERROR_LOCATION = 'MW19'
	Begin							 -- 11. Validaton for EVENT_X_MEDW_TEST's Columns
		Set @v_ColNameList  = 'CONCOM_PRODUCT_ID_1|CONCOM_PRODUCT_ID_2|CONCOM_PRODUCT_ID_3|CONCOM_PRODUCT_ID_4|CONCOM_PRODUCT_ID_5|CONCOM_PRODUCT_ID_6|'
		Set @v_ColName1List = 'CONCOM_FROM_DATE_1|CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_FROM_DATE_6|'
		Set @v_ColName2List = 'CONCOM_TO_DATE_1|CONCOM_TO_DATE_2|CONCOM_TO_DATE_3|CONCOM_TO_DATE_4|CONCOM_TO_DATE_5|CONCOM_TO_DATE_6|'
		Set @v_ColName3List = 'CONCOM_PRODUCT_1|CONCOM_PRODUCT_2|CONCOM_PRODUCT_3|CONCOM_PRODUCT_4|CONCOM_PRODUCT_5|CONCOM_PRODUCT_6|'

		While CHARINDEX ('|' , @v_ColNameList , 1) > 0    
		Begin  
			Set @v_ColName = LEFT (@v_ColNameList , CHARINDEX ('|' , @v_ColNameList , 1 ) - 1 )  
			Set @v_ColNameList = Right (@v_ColNameList ,len(@v_ColNameList) - CharIndex ('|', @v_ColNameList, 1) )		

			Set @v_ColName1 = LEFT (@v_ColName1List , CHARINDEX ('|' , @v_ColName1List , 1 ) - 1 )
			Set @v_ColName1List = Right (@v_ColName1List ,len(@v_ColName1List) - CharIndex ('|', @v_ColName1List, 1) )	

			Set @v_ColName2 = LEFT (@v_ColName2List , CHARINDEX ('|' , @v_ColName2List , 1 ) - 1 )
			Set @v_ColName2List = Right (@v_ColName2List ,len(@v_ColName2List) - CharIndex ('|', @v_ColName2List, 1) )	

			Set @v_ColName3 = LEFT (@v_ColName3List , CHARINDEX ('|' , @v_ColName3List , 1 ) - 1 )
			Set @v_ColName3List = Right (@v_ColName3List ,len(@v_ColName3List) - CharIndex ('|', @v_ColName3List, 1) )	
				
			Set @v_ErrorColName  = @v_ColName + ';' + @v_ColName1 + ';' + @v_ColName2 + ';' + @v_ColName3  --mkaur24 ak

			Select @v_Val = ( Case				
				When @v_ColName = 'CONCOM_PRODUCT_ID_1'  Then  @v_CONCOM_PRODUCT_ID_1
				When @v_ColName = 'CONCOM_PRODUCT_ID_2'  Then  @v_CONCOM_PRODUCT_ID_2
				When @v_ColName = 'CONCOM_PRODUCT_ID_3'  Then  @v_CONCOM_PRODUCT_ID_3
				When @v_ColName = 'CONCOM_PRODUCT_ID_4'  Then  @v_CONCOM_PRODUCT_ID_4
				When @v_ColName = 'CONCOM_PRODUCT_ID_5'  Then  @v_CONCOM_PRODUCT_ID_5
				When @v_ColName = 'CONCOM_PRODUCT_ID_6'  Then  @v_CONCOM_PRODUCT_ID_6
			End ) 
			Select @v_Val1 = ( Case			
				When @v_ColName1 = 'CONCOM_FROM_DATE_1'  Then  @v_CONCOM_FROM_DATE_1
				When @v_ColName1 = 'CONCOM_FROM_DATE_2'  Then  @v_CONCOM_FROM_DATE_2
				When @v_ColName1 = 'CONCOM_FROM_DATE_3'  Then  @v_CONCOM_FROM_DATE_3
				When @v_ColName1 = 'CONCOM_FROM_DATE_4'  Then  @v_CONCOM_FROM_DATE_4
				When @v_ColName1 = 'CONCOM_FROM_DATE_5'  Then  @v_CONCOM_FROM_DATE_5
				When @v_ColName1 = 'CONCOM_FROM_DATE_6'  Then  @v_CONCOM_FROM_DATE_6
			End ) 
			Select @v_Val2 = ( Case			
				When @v_ColName2 = 'CONCOM_TO_DATE_1'  Then  @v_CONCOM_TO_DATE_1
				When @v_ColName2 = 'CONCOM_TO_DATE_2'  Then  @v_CONCOM_TO_DATE_2
				When @v_ColName2 = 'CONCOM_TO_DATE_3'  Then  @v_CONCOM_TO_DATE_3
				When @v_ColName2 = 'CONCOM_TO_DATE_4'  Then  @v_CONCOM_TO_DATE_4
				When @v_ColName2 = 'CONCOM_TO_DATE_5'  Then  @v_CONCOM_TO_DATE_5
				When @v_ColName2 = 'CONCOM_TO_DATE_6'  Then  @v_CONCOM_TO_DATE_6
			End )				  
			Select @v_Val3 = ( Case			
				When @v_ColName3 = 'CONCOM_PRODUCT_1'  Then  @v_CONCOM_PRODUCT_1
				When @v_ColName3 = 'CONCOM_PRODUCT_2'  Then  @v_CONCOM_PRODUCT_2
				When @v_ColName3 = 'CONCOM_PRODUCT_3'  Then  @v_CONCOM_PRODUCT_3
				When @v_ColName3 = 'CONCOM_PRODUCT_4'  Then  @v_CONCOM_PRODUCT_4
				When @v_ColName3 = 'CONCOM_PRODUCT_5'  Then  @v_CONCOM_PRODUCT_5				       
				When @v_ColName3 = 'CONCOM_PRODUCT_6'  Then  @v_CONCOM_PRODUCT_6
			End )				  
			If @v_Val is not null and @v_Val1 is not null and @v_Val2 is not null and @v_Val3 is not null	--knakra(if all 4 are null, an error will be logged)
				Set @Do_Nothing = 1 ;
			Else if  @v_Val is  null and  @v_Val1 is  null and  @v_Val2 is  null 
					Set @Do_Nothing = 2;
			Else
			Begin		
				EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					@p_MODULE_NAME = @V_MODULENAME ,
					@p_CALLING_ERROR_LOCATION = 'Main', 
					@p_CURRENT_ERROR_LOCATION = 'zip2', 
					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					@p_ERROR_MSG = 'The number of values in each column must be equal.',
					@p_ERROR_COLUMNS = @v_ErrorColName   ,   --mkaur24 ak
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					@P_IS_VALIDATION = 1 ; 
			End
		End
	End
		SET @V_ERROR_LOCATION = 'MW20'
	
	If @v_Event_Number is not null
	Begin								-- 12. Event number must exist	
		Set @N_Sql =  'Select @Event_ID_P =  Event_Id from ' + @v_Dbname + ' Event where Event_Number = @Event_Number_P '	--knakra(if event_number is null, this should not be processed)
		SET @V_ERROR_LOCATION = 'MW5'
		Begin Try
			Exec sp_executesql @N_sql,
				N'@Event_ID_P Int Output,
				@Event_Number_P varchar (255) ',
				@Event_ID_P =  @Event_ID output ,
				@Event_Number_P = @v_Event_Number 
			SET @V_ERROR_LOCATION = 'MW6'
		End Try
		Begin Catch
			SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					@p_MODULE_NAME = @V_MODULENAME ,
					@p_CALLING_ERROR_LOCATION = 'Main', 
					@p_CURRENT_ERROR_LOCATION = 'EvntExist1', 
					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					@p_ERROR_MSG = @V_ERROR_MESSAGE ,
					@p_ERROR_COLUMNS = 'Exception' ,
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					@P_IS_VALIDATION = 0 ; 	
										
			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		
		End Catch
		If (@Event_ID = 0)	
		Begin
			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
				@p_MODULE_NAME = @V_MODULENAME ,
				@p_CALLING_ERROR_LOCATION = 'Main', 
				@p_CURRENT_ERROR_LOCATION = 'EvntExist', 
				@p_ERROR_PROC_NAME = @V_PROCNAME ,
				@p_ERROR_MSG = 'The Event does not exists corresponding to this Event_Number.Please provide a valid Event_number.',
				@p_ERROR_COLUMNS = 'EVENT_NUMBER' , 
				@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
				@P_IS_VALIDATION = 1 ;
						
			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
		End	
If (@Event_ID > 0)
		Begin
		set @Event_ID_Icon = 0 ;
			Set @N_Sql =  'Select @Event_ID_P =  Event_Id from ' + @v_Dbname + ' Event where Event_Number = @Event_Number_P'
			Set @N_sql = @N_Sql + ' and Event_ind_code in ( Select code_id  from ' + @v_Dbname + 'codes where Deleted_flag = 0   '
			Set @N_sql = @N_Sql + ' and table_id in (select table_id  from ' + @v_Dbname + 'glossary where system_table_name = ''EVENT_INDICATOR'') ' 
			Set @N_sql = @N_Sql + ' and Related_code_id in (select code_id   from ' + @v_Dbname + 'codes_text where code_id in  '
			Set @N_sql = @N_Sql + ' (select code_id from ' + @v_Dbname + 'codes where table_id in (select related_table_id  from ' + @v_Dbname  + 'glossary where '
			Set @N_sql = @n_sql + ' system_table_name =  ''EVENT_INDICATOR''  )) and code_desc = ''MEDICATION'' ) )' --mkaur24 ak full query modified
			--print 'mk  @N_sql ' + @N_sql
			
			SET @V_ERROR_LOCATION = 'MW5'
			Begin Try
				Exec sp_executesql @N_sql,
					N'@Event_ID_P Int Output,
					@Event_Number_P varchar (255) ',
					@Event_ID_P =  @Event_ID_Icon output ,
					@Event_Number_P = @v_Event_Number 
				SET @V_ERROR_LOCATION = 'MW6'
			End Try
			Begin Catch
				SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
				EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'EvntExist2', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = 'Exception' ,
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
										
				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;		
			End Catch
			--print  ' @Event_ID before icon if ' + cast (@Event_ID as varchar )
			--print '@Event_ID_Icon' + cast (@Event_ID_Icon as varchar)
			If (@Event_ID_Icon = 0)	
			Begin
				EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
					@p_DA_ROW_ID  = @V_DA_ROW_ID , 
					@p_MODULE_NAME = @V_MODULENAME ,
					@p_CALLING_ERROR_LOCATION = 'Main', 
					@p_CURRENT_ERROR_LOCATION = 'EvntExist3', 
					@p_ERROR_PROC_NAME = @V_PROCNAME ,
					@p_ERROR_MSG = 'Event Indicator for the given Event Number is not associated with Medication Event Category.',				
					@p_ERROR_COLUMNS = 'EVENT_NUMBER' , 
					@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
					@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
					@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
					@P_IS_VALIDATION = 1 ;
						
				SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
			End
		End
	End

	
	Begin							 -- 13. Update Reporter  Entity			
		--If (@i_Reporter_ENTITY_ID_GEN > 0)
		--Begin	
		--	Set @Entity_Id = 0 ;	--knakra(no need for this query, as entity id has already been fetched from entity table itself)
		--	Set @N_sql = 'Select @Entity_Id_P = Entity_id from ' + @v_Dbname + 'Entity where Entity_Id = @Entity_Id_Reporter_P '		--MKAUR24 AK
		--		Begin Try
		--			Exec sp_executesql @n_sql,
		--				N' @Entity_Id_P int Output,
		--				@Entity_Id_Reporter_P int',
		--				@Entity_Id_Reporter_P = @i_Reporter_ENTITY_ID_GEN,
		--				@Entity_Id_P = @Entity_Id output ;
		--		End Try			
		--		Begin Catch
		--			SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
		--			EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
		--				@p_DA_ROW_ID  = @V_DA_ROW_ID , 
		--				@p_MODULE_NAME = @V_MODULENAME ,
		--				@p_CALLING_ERROR_LOCATION = 'Main', 
		--				@p_CURRENT_ERROR_LOCATION = 'RepoUpd1', 
		--				@p_ERROR_PROC_NAME = @V_PROCNAME ,
		--				@p_ERROR_MSG = @V_ERROR_MESSAGE ,
		--				@p_ERROR_COLUMNS = 'Exception' ,
		--				@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
		--				@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
		--				@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
		--				@P_IS_VALIDATION = 0 ; 	
					
		--			SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
		--		End Catch
			If (@i_Reporter_ENTITY_ID_GEN > 0)		
			Begin
			IF @v_RPTD_BY_LAST_NAME LIKE'%''''%' OR @v_RPTD_BY_FIRST_NAME LIKE'%''''%' OR @v_RPTD_BY_ADDR1 LIKE'%''''%' OR @v_RPTD_BY_ADDR2 LIKE'%''''%'    --ddhupar JIRA 78172  starts
				BEGIN 
				SET @v_RPTD_BY_LAST_NAME = REPLACE(@v_RPTD_BY_LAST_NAME,'''''','''')
				SET @v_RPTD_BY_FIRST_NAME = REPLACE(@v_RPTD_BY_FIRST_NAME,'''''','''') 
				SET @v_RPTD_BY_ADDR1 = REPLACE(@v_RPTD_BY_ADDR1,'''''','''')
				SET @v_RPTD_BY_ADDR2 = REPLACE(@v_RPTD_BY_ADDR2,'''''','''')  
				END      --ddhupar JIRA 78172  end
				Set @N_sql = 'Update ' + @V_DBNAME +'Entity Set Entity_Id = @Entity_Id_P ' 
				If @v_RPTD_BY_LAST_NAME is Not Null
				Set @N_sql = @N_sql + ', LAST_NAME = @v_RPTD_BY_LAST_NAME_P '
				If @v_RPTD_BY_FIRST_NAME is Not Null
				Set @N_sql = @N_sql + ', FIRST_NAME = @v_RPTD_BY_FIRST_NAME_P '
				If @v_RPTD_BY_TAX_ID is Not Null
				Set @N_sql = @N_sql + ', TAX_ID = @v_RPTD_BY_TAX_ID_P '
				If @v_RPTD_BY_ADDR1 is Not Null
				Set @N_sql = @N_sql + ', ADDR1 = @v_RPTD_BY_ADDR1_P '
				If @v_RPTD_BY_ADDR2 is Not Null
				Set @N_sql = @N_sql + ', ADDR2 = @v_RPTD_BY_ADDR2_P ' 
				If @v_RPTD_BY_CITY is Not Null
				Set @N_sql = @N_sql + ', CITY = @v_RPTD_BY_CITY_P '  
				If @RPTD_BY_STATE_R is Not Null and @RPTD_BY_STATE_R <> 0
				Set @N_sql = @N_sql + ', STATE_ID = @RPTD_BY_STATE_R_P ' 
				If @v_RPTD_BY_ZIP_CODE is Not Null
				Set @N_sql = @N_sql + ', ZIP_CODE = @v_RPTD_BY_ZIP_CODE_P ' 
				If @NAME_TYPE_R is Not Null and @NAME_TYPE_R <> 0
				Set @N_sql = @N_sql + ', Name_TYPE = @NAME_TYPE_R_P ' 
				
				Set @N_sql = @N_sql + ' WHERE Entity_Id = @Entity_Id_P ' --MKAUR24 AK

				Begin Try
					Exec sp_executesql @N_sql,
						N'@Entity_Id_P int ,
						@v_RPTD_BY_LAST_NAME_P nvarchar(255),
						@v_RPTD_BY_FIRST_NAME_P nvarchar (255),
						@v_RPTD_BY_TAX_ID_P nvarchar (20),
						@v_RPTD_BY_ADDR1_P  nvarchar (20),
						@v_RPTD_BY_ADDR2_P nvarchar (100),
						@v_RPTD_BY_CITY_P nvarchar (50),
						@RPTD_BY_STATE_R_P int ,
						@v_RPTD_BY_ZIP_CODE_P nvarchar(20),
						@NAME_TYPE_R_P int',
						@Entity_Id_P = @i_Reporter_ENTITY_ID_GEN ,
						@v_RPTD_BY_LAST_NAME_P  = @v_RPTD_BY_LAST_NAME ,
						@v_RPTD_BY_FIRST_NAME_P = @v_RPTD_BY_FIRST_NAME,
						@v_RPTD_BY_TAX_ID_P     = @v_RPTD_BY_TAX_ID,
						@v_RPTD_BY_ADDR1_P      = @v_RPTD_BY_ADDR1,
						@v_RPTD_BY_ADDR2_P      = @v_RPTD_BY_ADDR2,
						@v_RPTD_BY_CITY_P       = @v_RPTD_BY_CITY,
						@RPTD_BY_STATE_R_P      = @RPTD_BY_STATE_R ,
						@v_RPTD_BY_ZIP_CODE_P   = @v_RPTD_BY_ZIP_CODE ,
						@NAME_TYPE_R_P          = @NAME_TYPE_R ;
				End Try			
				Begin Catch
					SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'RepoUpd2', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = 'Exception' ,
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
						
					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				End Catch 
			End
	--End
	End
		SET @V_ERROR_LOCATION = 'MW21'
	Begin							 -- 14. Update  Manufacturer Entity		
		--If (@i_MANUF_ENTITY_ID_GEN > 0)
		--Begin	
		--	Set @Entity_Id = 0 ;	--knakra(no need for below query, for the same rsn as above)
		--	Set @N_sql = 'Select @Entity_Id_P = Entity_id from ' + @v_Dbname + 'Entity where Entity_Id = @Entity_Id_Manuf_P '		 --MKAUR24 AK
		--	Begin Try
		--		Exec sp_executesql @n_sql,
		--			N' @Entity_Id_P int Output,
		--			@Entity_Id_Manuf_P int',
		--			@Entity_Id_Manuf_P = @i_MANUF_ENTITY_ID_GEN,
		--			@Entity_Id_P = @Entity_Id output ;
		--	End Try			
		--	Begin Catch
		--		SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
		--		EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
		--			@p_DA_ROW_ID  = @V_DA_ROW_ID , 
		--			@p_MODULE_NAME = @V_MODULENAME ,
		--			@p_CALLING_ERROR_LOCATION = 'Main', 
		--			@p_CURRENT_ERROR_LOCATION = 'ManufUpd1', 
		--			@p_ERROR_PROC_NAME = @V_PROCNAME ,
		--			@p_ERROR_MSG = @V_ERROR_MESSAGE ,
		--			@p_ERROR_COLUMNS = 'Exception' ,
		--			@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
		--			@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
		--			@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
		--			@P_IS_VALIDATION = 0 ; 	
					
		--		SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
		--	End Catch 
			If (@i_MANUF_ENTITY_ID_GEN > 0)		
			Begin
				Set @N_sql = 'Update ' + @V_DBNAME + 'Entity Set Entity_Id = @Entity_Id_P ' 
				If @v_MANUF_NAME is Not Null
				Set @N_sql = @N_sql + ', LAST_NAME = @v_MANUF_NAME_P '
				--If @v_RPTD_BY_FIRST_NAME is Not Null
				--Set @N_sql = @N_sql + ', FIRST_NAME = @v_RPTD_BY_FIRST_NAME_P '
				--If @v_RPTD_BY_TAX_ID is Not Null
				--Set @N_sql = @N_sql + ', TAX_ID = @v_RPTD_BY_TAX_ID_P '
				If @v_MANUF_ADDR1 is Not Null
				Set @N_sql = @N_sql + ', ADDR1 = @v_MANUF_ADDR1_P '
				If @v_MANUF_ADDR2 is Not Null
				Set @N_sql = @N_sql + ', ADDR2 = @v_MANUF_ADDR2_P ' 
				If @v_MANUF_CITY is Not Null
				Set @N_sql = @N_sql + ', CITY = @v_MANUF_CITY_P '  
				If @MANUF_STATE_R is Not Null and @MANUF_STATE_R <> 0
				Set @N_sql = @N_sql + ', STATE_ID = @MANUF_STATE_R_P ' 
				If @v_MANUF_ZIP_CODE is Not Null
				Set @N_sql = @N_sql + ', ZIP_CODE = @v_MANUF_ZIP_CODE_P ' 
				If @NAME_TYPE_R is Not Null and @NAME_TYPE_R <> 0
				Set @N_sql = @N_sql + ', Name_TYPE = @NAME_TYPE_R_P ' 
				 Set @N_sql = @N_sql + 'WHERE Entity_Id = @Entity_Id_P '

				Begin Try
					Exec sp_executesql @N_sql, --mkaur24 ak
						N'@Entity_Id_P int ,
						@v_MANUF_NAME_P nvarchar(255),  --mkaur24
						--@v_RPTD_BY_FIRST_NAME_P nvarchar (255),
						--@v_RPTD_BY_TAX_ID_P nvarchar (20),
						@v_MANUF_ADDR1_P  nvarchar (20),
						@v_MANUF_ADDR2_P nvarchar (100),
						@v_MANUF_CITY_P nvarchar (50),
						@MANUF_STATE_R_P int ,
						@v_MANUF_ZIP_CODE_P  nvarchar(20),
						@NAME_TYPE_R_P int',
						@Entity_Id_P = @i_MANUF_ENTITY_ID_GEN ,
						@v_MANUF_NAME_P  = @v_MANUF_NAME ,
						--@v_RPTD_BY_FIRST_NAME_P = @v_RPTD_BY_FIRST_NAME,
						--@v_RPTD_BY_TAX_ID_P     = @v_RPTD_BY_TAX_ID,
						@v_MANUF_ADDR1_P      = @v_MANUF_ADDR1 ,
						@v_MANUF_ADDR2_P      = @v_MANUF_ADDR2 ,
						@v_MANUF_CITY_P       = @v_MANUF_CITY  ,
						@MANUF_STATE_R_P     =  @MANUF_STATE_R ,
						@v_MANUF_ZIP_CODE_P   = @v_MANUF_ZIP_CODE ,
						@NAME_TYPE_R_P          = @NAME_TYPE_R ;
				End Try			
				Begin Catch
					SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
					EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @P_JOBID,
						@p_DA_ROW_ID  = @V_DA_ROW_ID , 
						@p_MODULE_NAME = @V_MODULENAME ,
						@p_CALLING_ERROR_LOCATION = 'Main', 
						@p_CURRENT_ERROR_LOCATION = 'ManufUpd2', 
						@p_ERROR_PROC_NAME = @V_PROCNAME ,
						@p_ERROR_MSG = @V_ERROR_MESSAGE ,
						@p_ERROR_COLUMNS = 'Exception' ,
						@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
						@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
						@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
						@P_IS_VALIDATION = 0 ; 	
						
					SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;			 
				End Catch  
			End
		--End
	End
		SET @V_ERROR_LOCATION = 'MW22'

		SET @V_ERROR_LOCATION = 'MW21'

-- Supplemnetal Valdation Starts


If (@MEDWATCH_SUPP <> 0 ) and (@Event_ID > 0)
Begin	
	EXEC DDS_SUPPLEMENT		 -- Insert call for Medwatch
		@P_JOBID                = @p_JOBID,
		@P_CONFIG_ID            = @CONFIG_ID,
		@P_USER_ID              = @p_USERID,
		@P_MODULE_NAME          = 'MEDWATCH',
		@P_DB_NAME              = @V_DBName,
		@P_DA_ROW_ID            = @v_DA_ROW_ID,
		@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
		@P_LOB                  = 0,
		@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
		@P_STAGE                = 'V', 
		@P_CLAIMANT_EID         = 0,
		@P_EVENT_ID             = @Event_ID,
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
		@P_EV_CONCOM_ROW_ID		= 0,
		@P_EV_MW_TEST_ROW_ID	= 0,
		@P_KEYCOLUMN            = 'EVENT_NUMBER',
		@P_KEYVALUE             = @v_EVENT_NUMBER,
		@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
End
---- Supplemnetal Valdation Ends

Set @I_ERRORCOUNT = @I_ERRORCOUNT + @P_SUPP_ERROR_COUNT_R

SET @V_ERROR_LOCATION = 'MW22'


---- Insert Starts
If (@I_ERRORCOUNT = 0) and (@Event_ID > 0)
Begin
	---Check if Event_Number / event _id  exists in  
	SET @V_DTTM_RCD_LAST_UPD_GEN = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
	SET @v_UPDATED_BY_USER = 'DDS'
	set @Event_ID_MED = 0 ;
	Set @N_Sql =  'Select @Event_ID_MED_P =  Event_Id from ' + @v_Dbname + ' EVENT_X_MEDWATCH where Event_Id = @Event_ID_IN_P '
		SET @V_ERROR_LOCATION = 'MW23'
		Exec sp_executesql @N_sql,
			N'@Event_ID_MED_P Int Output,
			@Event_ID_IN_P Int ',
			@Event_ID_MED_P =  @Event_ID_MED output ,
			@Event_ID_IN_P = @Event_ID
		SET @V_ERROR_LOCATION = 'MW24'
	If (@Event_ID_MED = 0) -- Insert into EVENT_X_MEDWATCH
	Begin
		Set @N_sql = 'Insert into ' + @v_Dbname + 'EVENT_X_MEDWATCH (EVENT_ID ,UNIT_CODE,DATE_RPTD_TO_FDA,DATE_RPTD_TO_MFG,RPTD_BY_EID,' --mkaur24 ak
		Set @N_sql = @N_sql + 'RPTD_BY_PRO_FLAG,RPTD_BY_POS_CODE,RELEVANT_HISTORY,LAST_REPORT_DATE,'
		Set @N_sql = @N_sql + 'REPORT_YEAR,REPORT_SERIAL_NO,ADVERSE_EVENT_FLAG,PRODUCT_PROB_FLAG,LIFE_THREAT_FLAG,HOSPITALIZ_FLAG,'
		Set @N_sql = @N_sql + 'DISABILITY_FLAG,CONGENITAL_FLAG,REQD_INTERV_FLAG,FOLLOW_UP_COUNT,RPT_MANDATORY,MED_TYPE,MED_NAME,DOSE,'
		Set @N_sql = @N_sql + 'FREQUENCY,ROUTE,THERAPY_FROM_DATE,THERAPY_TO_DATE,DURATION,LOT_NUMBER,NDC_NUMBER,EXPIRATION_DATE,MW_EVENT_ABATED,'
		Set @N_sql = @N_sql + 'MW_EVNT_REAPPEARED,DIAGNOSIS_TEST,BRAND_NAME,EQUIP_TYPE_CODE,MANUFACTURER_EID,MODEL_NUMBER,CATALOG_NUMBER,SERIAL_NUMBER,'
		Set @N_sql = @N_sql + 'OTHER_NUMBER,DEVICE_OPER_CODE,IMPLANT_DATE,EXPLANT_DATE,AGE_OF_DEVICE,DEV_AVAIL_FOR_EVAL,DEVICE_RETURN_DATE,EQ_LOT_NUMBER,'
		Set @N_sql = @N_sql + 'EQ_EXPIRATION_DATE) '
		Set @N_sql = @N_sql + 'values (@Event_ID_P,@v_UNIT_CODE_P,@v_DATE_RPTD_FDA_P,@v_DATE_RPTD_MFG_P,@v_RPTD_BY_EID_P,@v_RPTD_BY_PRO_FLAG_P,'
		Set @N_sql = @N_sql + '@v_RPTD_BY_POS_CODE_P,@v_RELEVANT_HISTORY_P ,@v_LAST_REPORT_DATE_P ,@v_REPORT_YEAR_P,@v_REPORT_SERIAL_NO_P,@v_ADVERSE_EVENT_FLAG_P,'
		Set @N_sql = @N_sql + '@v_PRODUCT_PROB_FLAG_P ,@v_LIFE_THREAT_FLAG_P,@v_HOSPITALIZ_FLAG_P ,@v_DISABILITY_FLAG_P ,@v_CONGENITAL_FLAG_P ,@v_REQD_INTERV_FLAG_P ,'
		Set @N_sql = @N_sql + '@v_FOLLOW_UP_COUNT_P,@v_RPT_MANDATORY_P,@v_MED_TYPE_P ,@v_MED_NAME_P,@v_DOSE_P ,@v_FREQUENCY_P,@v_ROUTE_P,@v_THERAPY_FROM_DATE_P,'
		Set @N_sql = @N_sql + '@v_THERAPY_TO_DATE_P ,@v_DURATION_P ,@v_LOT_NUMBER_P ,@v_NDC_NUMBER_P ,@v_EXPIRATION_DATE_P ,@v_EVENT_ABATED_P ,@v_EVENT_REAPPEARED_P ,'
		Set @N_sql = @N_sql + '@v_DIAGNOSIS_TEST_P ,@v_BRAND_NAME_P ,@v_EQUIP_TYPE_CODE_P ,@v_MANUFACTURER_EID_P,@v_MODEL_NUMBER_P ,@v_CATALOG_NUMBER_P ,@v_SERIAL_NUMBER_P ,'
		Set @N_sql = @N_sql + '@v_OTHER_NUMBER_P ,@v_DEVICE_OPER_CODE_P ,@v_IMPLANT_DATE_P ,@v_EXPLANT_DATE_P ,@v_AGE_OF_DEVICE_P ,@v_DEV_AVAIL_FOR_EVAL_P ,@v_DEVICE_RETURN_DATE_P,'
		Set @N_sql = @N_sql + '@v_EQ_LOT_NUMBER_P ,@v_EQ_EXPIRATION_DATE_P)'
			SET @V_ERROR_LOCATION = 'MW25'
			Execute sp_executesql @N_sql ,	--knakra(v_EQUIP_TYPE_CODE_P and v_DEVICE_OPER_CODE_P, these variables should be int and not nvarchar)
				N' @Event_ID_P INT,
				@v_UNIT_CODE_P INT,
				@v_DATE_RPTD_FDA_P NVARCHAR(8),
				@v_DATE_RPTD_MFG_P NVARCHAR(8),
				@v_RPTD_BY_EID_P int ,		
				@v_RPTD_BY_PRO_FLAG_P INT,
				@v_RPTD_BY_POS_CODE_P NVARCHAR(25),
				@v_RELEVANT_HISTORY_P NVARCHAR(MAX),
				@v_LAST_REPORT_DATE_P NVARCHAR(8),
				@v_REPORT_YEAR_P INT, 
				@v_REPORT_SERIAL_NO_P INT,
				@v_ADVERSE_EVENT_FLAG_P INT,
				@v_PRODUCT_PROB_FLAG_P  INT,
				@v_LIFE_THREAT_FLAG_P INT,
				@v_HOSPITALIZ_FLAG_P  INT,
				@v_DISABILITY_FLAG_P INT,
				@v_CONGENITAL_FLAG_P  INT,
				@v_REQD_INTERV_FLAG_P INT,
				@v_FOLLOW_UP_COUNT_P INT,
				@v_RPT_MANDATORY_P INT,
				@v_MED_TYPE_P INT,
				@v_MED_NAME_P NVARCHAR(25),
				@v_DOSE_P NVARCHAR(25),
				@v_FREQUENCY_P NVARCHAR(25),
				@v_ROUTE_P NVARCHAR(25),
				@v_THERAPY_FROM_DATE_P NVARCHAR(8),
				@v_THERAPY_TO_DATE_P  NVARCHAR(8),
				@v_DURATION_P INT,
				@v_LOT_NUMBER_P NVARCHAR(15),
				@v_NDC_NUMBER_P INT,
				@v_EXPIRATION_DATE_P NVARCHAR(8),
				@v_EVENT_ABATED_P INT,
				@v_EVENT_REAPPEARED_P INT,
				@v_DIAGNOSIS_TEST_P  NVARCHAR(25),
				@v_BRAND_NAME_P NVARCHAR(25),
				@v_EQUIP_TYPE_CODE_P	 int,
				@v_MANUFACTURER_EID_P int ,		
				@v_MODEL_NUMBER_P NVARCHAR (15),
				@v_CATALOG_NUMBER_P NVARCHAR (15),
				@v_SERIAL_NUMBER_P NVARCHAR (15),
				@v_OTHER_NUMBER_P NVARCHAR (15),
				@v_DEVICE_OPER_CODE_P int,
				@v_IMPLANT_DATE_P NVARCHAR(8),
				@v_EXPLANT_DATE_P NVARCHAR(8),
				@v_AGE_OF_DEVICE_P NVARCHAR(12),
				@v_DEV_AVAIL_FOR_EVAL_P INT,
				@v_DEVICE_RETURN_DATE_P NVARCHAR(8),
				@v_EQ_LOT_NUMBER_P NVARCHAR(15),
				@v_EQ_EXPIRATION_DATE_P NVARCHAR(8)',				
				@Event_ID_P = @Event_ID ,
				@v_UNIT_CODE_P =  @UNIT_CODE_R,
				@v_DATE_RPTD_FDA_P =  @v_DATE_RPTD_FDA,
				@v_DATE_RPTD_MFG_P =  @v_DATE_RPTD_MFG,
				@v_RPTD_BY_EID_P =  @i_Reporter_ENTITY_ID_GEN ,		
				@v_RPTD_BY_PRO_FLAG_P = @RPTD_BY_PRO_FLAG_R,
				@v_RPTD_BY_POS_CODE_P =  @RPTD_BY_POS_CODE_R,
				@v_RELEVANT_HISTORY_P =  @v_RELEVANT_HISTORY,
				@v_LAST_REPORT_DATE_P =  @v_LAST_REPORT_DATE, --mkaur24 ak
				@v_REPORT_YEAR_P =  @v_REPORT_YEAR, 
				@v_REPORT_SERIAL_NO_P =  @v_REPORT_SERIAL_NO,
				@v_ADVERSE_EVENT_FLAG_P = @ADVERSE_EVENT_FLAG_R,
				@v_PRODUCT_PROB_FLAG_P =   @PRODUCT_PROB_FLAG_R,
				@v_LIFE_THREAT_FLAG_P =   @LIFE_THREAT_FLAG_R,
				@v_HOSPITALIZ_FLAG_P =   @HOSPITALIZ_FLAG_R,
				@v_DISABILITY_FLAG_P =  @DISABILITY_FLAG_R,
				@v_CONGENITAL_FLAG_P =   @CONGENITAL_FLAG_R,
				@v_REQD_INTERV_FLAG_P = @REQD_INTERV_FLAG_R,
				@v_FOLLOW_UP_COUNT_P =  @v_FOLLOW_UP_COUNT,
				@v_RPT_MANDATORY_P =  @v_RPT_MANDATORY,
				@v_MED_TYPE_P =  @MED_TYPE_R,
				@v_MED_NAME_P =  @v_MED_NAME,
				@v_DOSE_P = @v_DOSE,
				@v_FREQUENCY_P =  @v_FREQUENCY,
				@v_ROUTE_P =  @v_ROUTE,
				@v_THERAPY_FROM_DATE_P =  @v_THERAPY_FROM_DATE,
				@v_THERAPY_TO_DATE_P =   @v_THERAPY_TO_DATE,
				@v_DURATION_P =  @v_DURATION,
				@v_LOT_NUMBER_P =  @v_LOT_NUMBER,
				@v_NDC_NUMBER_P =  @v_NDC_NUMBER,
				@v_EXPIRATION_DATE_P =  @v_EXPIRATION_DATE,
				@v_EVENT_ABATED_P =  @EVENT_ABATED_R,
				@v_EVENT_REAPPEARED_P = @EVENT_REAPPEARED_R,
				@v_DIAGNOSIS_TEST_P =   @v_DIAGNOSIS_TEST,
				@v_BRAND_NAME_P =  @v_BRAND_NAME,
				@v_EQUIP_TYPE_CODE_P = 	 @EQUIP_TYPE_CODE_R,
				@v_MANUFACTURER_EID_P =  @i_MANUF_ENTITY_ID_GEN ,		
				@v_MODEL_NUMBER_P =  @v_MODEL_NUMBER,
				@v_CATALOG_NUMBER_P =  @v_CATALOG_NUMBER,
				@v_SERIAL_NUMBER_P =  @v_SERIAL_NUMBER,
				@v_OTHER_NUMBER_P =  @v_OTHER_NUMBER,
				@v_DEVICE_OPER_CODE_P = @DEVICE_OPER_CODE_R,
				@v_IMPLANT_DATE_P =  @v_IMPLANT_DATE,
				@v_EXPLANT_DATE_P =  @v_EXPLANT_DATE,
				@v_AGE_OF_DEVICE_P =  @v_AGE_OF_DEVICE,
				@v_DEV_AVAIL_FOR_EVAL_P = @DEV_AVAIL_FOR_EVAL_R,
				@v_DEVICE_RETURN_DATE_P = @v_DEVICE_RETURN_DATE,
				@v_EQ_LOT_NUMBER_P =  @v_EQ_LOT_NUMBER,
				@v_EQ_EXPIRATION_DATE_P =  @v_EQ_EXPIRATION_DATE ;
				SET @V_ERROR_LOCATION = 'MW27'
	End
	Else if ( @Event_ID_MED > 0)			--update table
	Begin	
		SET @V_ERROR_LOCATION = 'MW26U'
		Set @N_sql = 'Update ' + @v_Dbname + 'EVENT_X_MEDWATCH SET EVENT_ID = @Event_ID_MED_P  '
		If @UNIT_CODE_R is not null
		Set @N_sql = @N_sql +  ', UNIT_CODE = @v_UNIT_CODE_P '
		If @v_DATE_RPTD_FDA is not null
		Set @N_sql = @N_sql + ', DATE_RPTD_TO_FDA = @v_DATE_RPTD_FDA_P '	
		If  @v_DATE_RPTD_MFG is not null
		Set @N_sql = @N_sql +  ', DATE_RPTD_TO_MFG = @v_DATE_RPTD_MFG_P '		
		If @i_Reporter_ENTITY_ID_GEN is not null and @i_Reporter_ENTITY_ID_GEN <> 0 
		Set @N_sql = @N_sql +  ', RPTD_BY_EID = @v_RPTD_BY_EID_P '
		If @RPTD_BY_PRO_FLAG_R is not null  
		Set @N_sql = @N_sql + ', RPTD_BY_PRO_FLAG = @v_RPTD_BY_PRO_FLAG_P '		
		If @RPTD_BY_POS_CODE_R is not null
		Set @N_sql = @N_sql + ', RPTD_BY_POS_CODE = @v_RPTD_BY_POS_CODE_P '		
		If @v_RELEVANT_HISTORY is not null
		Set @N_sql = @N_sql +  ', RELEVANT_HISTORY = @v_RELEVANT_HISTORY_P '			
		If @v_LAST_REPORT_DATE is not null
		Set @N_sql = @N_sql + ', LAST_REPORT_DATE = @v_LAST_REPORT_DATE_P '			
		If @v_REPORT_YEAR is not null
		Set @N_sql = @N_sql + ', REPORT_YEAR = @v_REPORT_YEAR_P '	
		If @v_REPORT_SERIAL_NO is not null
		Set @N_sql = @N_sql + ', REPORT_SERIAL_NO = @v_REPORT_SERIAL_NO_P '	
		If  @ADVERSE_EVENT_FLAG_R is not null
		Set @N_sql = @N_sql + ', ADVERSE_EVENT_FLAG = @v_ADVERSE_EVENT_FLAG_P '
		If  @PRODUCT_PROB_FLAG_R is not null
		Set @N_sql = @N_sql + ', PRODUCT_PROB_FLAG = @v_PRODUCT_PROB_FLAG_P '
		If  @LIFE_THREAT_FLAG_R is not null
		Set @N_sql = @N_sql +  ', LIFE_THREAT_FLAG = @v_LIFE_THREAT_FLAG_P '
		If  @HOSPITALIZ_FLAG_R is not null
		Set @N_sql = @N_sql +  ', HOSPITALIZ_FLAG = @v_HOSPITALIZ_FLAG_P '
		If  @DISABILITY_FLAG_R is not null
		Set @N_sql = @N_sql + ', DISABILITY_FLAG = @v_DISABILITY_FLAG_P '
		If  @CONGENITAL_FLAG_R is not null
		Set @N_sql = @N_sql + ', CONGENITAL_FLAG = @v_CONGENITAL_FLAG_P'		
		If  @REQD_INTERV_FLAG_R is not null
		Set @N_sql = @N_sql + ', REQD_INTERV_FLAG = 	@v_REQD_INTERV_FLAG_P '
		If  @v_FOLLOW_UP_COUNT is not null
		Set @N_sql = @N_sql + ', FOLLOW_UP_COUNT = @v_FOLLOW_UP_COUNT_P '
		If  @v_RPT_MANDATORY is not null
		Set @N_sql = @N_sql + ', RPT_MANDATORY = @v_RPT_MANDATORY_P '
		If  @MED_TYPE_R is not null
		Set @N_sql = @N_sql + ', MED_TYPE = @v_MED_TYPE_P'
		If  @v_MED_NAME is not null
		Set @N_sql = @N_sql + ', MED_NAME = @v_MED_NAME_P'		
		If  @v_DOSE is not null
		Set @N_sql = @N_sql + ', DOSE = 	@v_DOSE_P '			
		If  @v_FREQUENCY is not null
		Set @N_sql = @N_sql + ', FREQUENCY = @v_FREQUENCY_P '		
		If  @v_ROUTE is not null
		Set @N_sql = @N_sql + ', ROUTE = @v_ROUTE_P'
		If  @v_THERAPY_FROM_DATE is not null
		Set @N_sql = @N_sql + ', THERAPY_FROM_DATE = @v_THERAPY_FROM_DATE_P'		
		If  @v_THERAPY_TO_DATE is not null
		Set @N_sql = @N_sql + ', THERAPY_TO_DATE = 	@v_THERAPY_TO_DATE_P '
		If  @v_DURATION is not null
		Set @N_sql = @N_sql + ', DURATION = @v_DURATION_P '		
		If  @v_LOT_NUMBER is not null
		Set @N_sql = @N_sql + ', LOT_NUMBER = @v_LOT_NUMBER_P'
		If  @v_NDC_NUMBER is not null
		Set @N_sql = @N_sql + ', NDC_NUMBER = @v_NDC_NUMBER_P'	
		If  @v_EXPIRATION_DATE is not null
		Set @N_sql = @N_sql + ', EXPIRATION_DATE = 	@v_EXPIRATION_DATE_P '
		If  @EVENT_ABATED_R is not null
		Set @N_sql = @N_sql + ', MW_EVENT_ABATED = @v_EVENT_ABATED_P'
		If  @EVENT_REAPPEARED_R is not null
		Set @N_sql = @N_sql + ', MW_EVNT_REAPPEARED = @v_EVENT_REAPPEARED_P'		
		If  @v_DIAGNOSIS_TEST is not null
		Set @N_sql = @N_sql + ', DIAGNOSIS_TEST = 	@v_DIAGNOSIS_TEST_P'
		If  @EQUIP_TYPE_CODE_R is not null
		Set @N_sql = @N_sql + ', EQUIP_TYPE_CODE = @v_EQUIP_TYPE_CODE_P '		
		If  @v_BRAND_NAME is not null
		Set @N_sql = @N_sql + ', BRAND_NAME = @v_BRAND_NAME_P'
		If  @i_MANUF_ENTITY_ID_GEN is not null and @i_MANUF_ENTITY_ID_GEN <> 0
		Set @N_sql = @N_sql + ', MANUFACTURER_EID = @v_MANUFACTURER_EID_P'					
		If  @v_MODEL_NUMBER is not null
		Set @N_sql = @N_sql + ', MODEL_NUMBER = @v_MODEL_NUMBER_P'
		If  @v_CATALOG_NUMBER is not null
		Set @N_sql = @N_sql + ', CATALOG_NUMBER = @v_CATALOG_NUMBER_P'		
		If  @v_SERIAL_NUMBER is not null
		Set @N_sql = @N_sql + ', SERIAL_NUMBER = @v_SERIAL_NUMBER_P'		
		If  @v_OTHER_NUMBER is not null
		Set @N_sql = @N_sql + ', OTHER_NUMBER = @v_OTHER_NUMBER_P '		
		If  @DEVICE_OPER_CODE_R is not null
		Set @N_sql = @N_sql + ', DEVICE_OPER_CODE = @v_DEVICE_OPER_CODE_P'
		If  @v_IMPLANT_DATE is not null
		Set @N_sql = @N_sql + ', IMPLANT_DATE = @v_IMPLANT_DATE_P'	
		If  @v_EXPLANT_DATE is not null
		Set @N_sql = @N_sql + ', EXPLANT_DATE = @v_EXPLANT_DATE_P'
		If  @v_AGE_OF_DEVICE is not null
		Set @N_sql = @N_sql + ', AGE_OF_DEVICE = @v_AGE_OF_DEVICE_P'		
		If  @DEV_AVAIL_FOR_EVAL_R is not null
		Set @N_sql = @N_sql +  ', DEV_AVAIL_FOR_EVAL = @v_DEV_AVAIL_FOR_EVAL_P'		
		If  @v_DEVICE_RETURN_DATE is not null
		Set @N_sql = @N_sql + ', DEVICE_RETURN_DATE = @v_DEVICE_RETURN_DATE_P '		
		If  @v_EQ_LOT_NUMBER is not null
		Set @N_sql = @N_sql + ', EQ_LOT_NUMBER = @v_EQ_LOT_NUMBER_P'
		If  @v_EQ_EXPIRATION_DATE is not null
		Set @N_sql = @N_sql + ', EQ_EXPIRATION_DATE = @v_EQ_EXPIRATION_DATE_P'				
		If  @V_DTTM_RCD_LAST_UPD_GEN is not null
		Set @N_sql = @N_sql + ', DTTM_RCD_LAST_UPD = @V_DTTM_RCD_LAST_UPD_GEN_P'
		If  @v_UPDATED_BY_USER is not null
		Set @N_sql = @N_sql + ', UPDATED_BY_USER = @v_UPDATED_BY_USER_P'
		Set @N_sql = @N_sql + ' where EVENT_ID = @Event_ID_MED_P '
			SET @V_ERROR_LOCATION = 'MW27U'
			Execute sp_executesql @N_sql ,
				N' @Event_ID_MED_P INT,
				@v_UNIT_CODE_P INT,
				@v_DATE_RPTD_FDA_P NVARCHAR(8),
				@v_DATE_RPTD_MFG_P NVARCHAR(8),
				@v_RPTD_BY_EID_P int ,		
				@v_RPTD_BY_PRO_FLAG_P int,
				@v_RPTD_BY_POS_CODE_P NVARCHAR(25),
				@v_RELEVANT_HISTORY_P NVARCHAR(MAX),
				@v_LAST_REPORT_DATE_P NVARCHAR(8),
				@v_REPORT_YEAR_P INT, 
				@v_REPORT_SERIAL_NO_P INT,
				@v_ADVERSE_EVENT_FLAG_P INT,
				@v_PRODUCT_PROB_FLAG_P  INT,
				@v_LIFE_THREAT_FLAG_P  INT,
				@v_HOSPITALIZ_FLAG_P  INT,
				@v_DISABILITY_FLAG_P  INT,
				@v_CONGENITAL_FLAG_P  INT,
				@v_REQD_INTERV_FLAG_P  INT,
				@v_FOLLOW_UP_COUNT_P INT,
				@v_RPT_MANDATORY_P INT,
				@v_MED_TYPE_P INT,
				@v_MED_NAME_P NVARCHAR(25),
				@v_DOSE_P NVARCHAR(25),
				@v_FREQUENCY_P NVARCHAR(25),
				@v_ROUTE_P NVARCHAR(25),
				@v_THERAPY_FROM_DATE_P NVARCHAR(8),
				@v_THERAPY_TO_DATE_P  NVARCHAR(8),
				@v_DURATION_P INT,
				@v_LOT_NUMBER_P NVARCHAR(15),
				@v_NDC_NUMBER_P INT,
				@v_EXPIRATION_DATE_P NVARCHAR(8),
				@v_EVENT_ABATED_P INT,
				@v_EVENT_REAPPEARED_P INT,
				@v_DIAGNOSIS_TEST_P  NVARCHAR(25),
				@v_BRAND_NAME_P NVARCHAR(25),
				@v_EQUIP_TYPE_CODE_P	 int,
				@v_MANUFACTURER_EID_P int ,		
				@v_MODEL_NUMBER_P NVARCHAR (15),
				@v_CATALOG_NUMBER_P NVARCHAR (15),
				@v_SERIAL_NUMBER_P NVARCHAR (15),
				@v_OTHER_NUMBER_P NVARCHAR (15),
				@v_DEVICE_OPER_CODE_P int,
				@v_IMPLANT_DATE_P NVARCHAR(8),
				@v_EXPLANT_DATE_P NVARCHAR(8),
				@v_AGE_OF_DEVICE_P NVARCHAR(12),
				@v_DEV_AVAIL_FOR_EVAL_P INT,
				@v_DEVICE_RETURN_DATE_P NVARCHAR(8),
				@v_EQ_LOT_NUMBER_P NVARCHAR(15),
				@v_EQ_EXPIRATION_DATE_P NVARCHAR(8),
				@V_DTTM_RCD_LAST_UPD_GEN_P nvarchar(255),
				@v_UPDATED_BY_USER_P nvarchar(25)',				
				@Event_ID_MED_P = @Event_ID_MED ,
				@v_UNIT_CODE_P =  @UNIT_CODE_R,
				@v_DATE_RPTD_FDA_P =  @v_DATE_RPTD_FDA,
				@v_DATE_RPTD_MFG_P =  @v_DATE_RPTD_MFG,
				@v_RPTD_BY_EID_P =  @i_Reporter_ENTITY_ID_GEN ,		
				@v_RPTD_BY_PRO_FLAG_P = @RPTD_BY_PRO_FLAG_R,
				@v_RPTD_BY_POS_CODE_P =  @RPTD_BY_POS_CODE_R,
				@v_RELEVANT_HISTORY_P =  @v_RELEVANT_HISTORY,
				@v_LAST_REPORT_DATE_P =  @v_LAST_REPORT_DATE,
				@v_REPORT_YEAR_P =  @v_REPORT_YEAR, 
				@v_REPORT_SERIAL_NO_P =  @v_REPORT_SERIAL_NO,
				@v_ADVERSE_EVENT_FLAG_P = @ADVERSE_EVENT_FLAG_R,
				@v_PRODUCT_PROB_FLAG_P =   @PRODUCT_PROB_FLAG_R,
				@v_LIFE_THREAT_FLAG_P =   @LIFE_THREAT_FLAG_R,
				@v_HOSPITALIZ_FLAG_P =   @HOSPITALIZ_FLAG_R,
				@v_DISABILITY_FLAG_P =  @DISABILITY_FLAG_R,
				@v_CONGENITAL_FLAG_P =   @CONGENITAL_FLAG_R,
				@v_REQD_INTERV_FLAG_P = @REQD_INTERV_FLAG_R,
				@v_FOLLOW_UP_COUNT_P =  @v_FOLLOW_UP_COUNT,
				@v_RPT_MANDATORY_P =  @v_RPT_MANDATORY,
				@v_MED_TYPE_P =  @MED_TYPE_R,
				@v_MED_NAME_P =  @v_MED_NAME,
				@v_DOSE_P = @v_DOSE,
				@v_FREQUENCY_P =  @v_FREQUENCY,
				@v_ROUTE_P =  @v_ROUTE,
				@v_THERAPY_FROM_DATE_P =  @v_THERAPY_FROM_DATE,
				@v_THERAPY_TO_DATE_P =   @v_THERAPY_TO_DATE,
				@v_DURATION_P =  @v_DURATION,
				@v_LOT_NUMBER_P =  @v_LOT_NUMBER,
				@v_NDC_NUMBER_P =  @v_NDC_NUMBER,
				@v_EXPIRATION_DATE_P =  @v_EXPIRATION_DATE,
				@v_EVENT_ABATED_P =  @EVENT_ABATED_R,
				@v_EVENT_REAPPEARED_P = @EVENT_REAPPEARED_R,
				@v_DIAGNOSIS_TEST_P =   @v_DIAGNOSIS_TEST,
				@v_BRAND_NAME_P =  @v_BRAND_NAME,
				@v_EQUIP_TYPE_CODE_P = 	 @EQUIP_TYPE_CODE_R,
				@v_MANUFACTURER_EID_P =  @i_MANUF_ENTITY_ID_GEN ,		
				@v_MODEL_NUMBER_P =  @v_MODEL_NUMBER,
				@v_CATALOG_NUMBER_P =  @v_CATALOG_NUMBER,
				@v_SERIAL_NUMBER_P =  @v_SERIAL_NUMBER,
				@v_OTHER_NUMBER_P =  @v_OTHER_NUMBER,
				@v_DEVICE_OPER_CODE_P = @DEVICE_OPER_CODE_R,
				@v_IMPLANT_DATE_P =  @v_IMPLANT_DATE,
				@v_EXPLANT_DATE_P =  @v_EXPLANT_DATE,
				@v_AGE_OF_DEVICE_P =  @v_AGE_OF_DEVICE,
				@v_DEV_AVAIL_FOR_EVAL_P = @DEV_AVAIL_FOR_EVAL_R,
				@v_DEVICE_RETURN_DATE_P = @v_DEVICE_RETURN_DATE,
				@v_EQ_LOT_NUMBER_P =  @v_EQ_LOT_NUMBER,
				@v_EQ_EXPIRATION_DATE_P =  @v_EQ_EXPIRATION_DATE,
				@V_DTTM_RCD_LAST_UPD_GEN_P =	@V_DTTM_RCD_LAST_UPD_GEN , --mkaur24 ak
				@v_UPDATED_BY_USER_P = @v_UPDATED_BY_USER ;
				SET @V_ERROR_LOCATION = 'MW28'
	End

Begin --Insert into Event_X_Medw_test Start	
	Set @v_ColNameList  = '@v_TEST_LAB_TEST_1|@v_TEST_LAB_TEST_2|@v_TEST_LAB_TEST_3|@v_TEST_LAB_TEST_4|@v_TEST_LAB_TEST_5|' --mkaur24 ak
	Set @v_ColName1List = '@v_TEST_RESULT_1|@v_TEST_RESULT_2|@v_TEST_RESULT_3|@v_TEST_RESULT_4|@v_TEST_RESULT_5|' --mkaur24 ak
	Set @v_ColName2List = '@v_TEST_DATE_1|@v_TEST_DATE_2|@v_TEST_DATE_3|@v_TEST_DATE_4|@v_TEST_DATE_5|' --mkaur24 ak
	While CHARINDEX ('|' , @v_ColNameList , 1) > 0    
	Begin 
		SET @V_ERROR_LOCATION = 'MW29'
		Set @v_ColName = LEFT (@v_ColNameList , CHARINDEX ('|' , @v_ColNameList , 1 ) - 1 )  
		Set @v_ColNameList = Right (@v_ColNameList ,len(@v_ColNameList) - CharIndex ('|', @v_ColNameList, 1) )		

		Set @v_ColName1 = LEFT (@v_ColName1List , CHARINDEX ('|' , @v_ColName1List , 1 ) - 1 )
		Set @v_ColName1List = Right (@v_ColName1List ,len(@v_ColName1List) - CharIndex ('|', @v_ColName1List, 1) )		

		Set @v_ColName2 = LEFT (@v_ColName2List , CHARINDEX ('|' , @v_ColName2List , 1 ) - 1 )
		Set @v_ColName2List = Right (@v_ColName2List ,len(@v_ColName2List) - CharIndex ('|', @v_ColName2List, 1) )	
		Select @v_Val = ( Case				
			  When @v_ColName = '@v_TEST_LAB_TEST_1'  Then  @v_TEST_LAB_TEST_1
			  When @v_ColName = '@v_TEST_LAB_TEST_2'  Then  @v_TEST_LAB_TEST_2
			  When @v_ColName = '@v_TEST_LAB_TEST_3'  Then  @v_TEST_LAB_TEST_3
			  When @v_ColName = '@v_TEST_LAB_TEST_4'  Then  @v_TEST_LAB_TEST_4
			  When @v_ColName = '@v_TEST_LAB_TEST_5'  Then  @v_TEST_LAB_TEST_5
		  End )
		Select @v_Val1 = ( Case			
			  When @v_ColName1 = '@v_TEST_RESULT_1'  Then  @v_TEST_RESULT_1
			  When @v_ColName1 = '@v_TEST_RESULT_2'  Then  @v_TEST_RESULT_2
			  When @v_ColName1 = '@v_TEST_RESULT_3'  Then  @v_TEST_RESULT_3
			  When @v_ColName1 = '@v_TEST_RESULT_4'  Then  @v_TEST_RESULT_4
			  When @v_ColName1 = '@v_TEST_RESULT_5'  Then  @v_TEST_RESULT_5
		  End )
		Select @v_Val2 = ( Case			
			  When @v_ColName2 = '@v_TEST_DATE_1'  Then  @v_TEST_DATE_1
			  When @v_ColName2 = '@v_TEST_DATE_2'  Then  @v_TEST_DATE_2
			  When @v_ColName2 = '@v_TEST_DATE_3'  Then  @v_TEST_DATE_3
			  When @v_ColName2 = '@v_TEST_DATE_4'  Then  @v_TEST_DATE_4
			  When @v_ColName2 = '@v_TEST_DATE_5'  Then  @v_TEST_DATE_5
		  End )
		If @v_Val is not null and  @v_Val1 is not null and  @v_Val2 is not null  
		Begin
				--mkaur24  ak start
			Set @v_EV_MW_TEST_ROW_ID_GEN_RMDB = 0
			Set @N_Sql = 'Select @v_EV_MW_TEST_ROW_ID_P = EV_MW_TEST_ROW_ID from ' + @v_Dbname + 'EVENT_X_MEDW_TEST where EVENT_ID = @v_Event_ID_P  '
			set @N_Sql =  @N_sql + 'and LAB_TEST = @v_TEST_LAB_TEST_P  '
			set @N_Sql =  @N_sql + 'and RESULT = @v_TEST_RESULT_P '
			set @N_Sql =  @N_sql + 'and TEST_DATE = @v_TEST_DATE_P '
		
			SET @V_ERROR_LOCATION = 'MWse38'
				Execute sp_executesql @N_sql,
					N' @v_EV_MW_TEST_ROW_ID_P int output , 
					@v_EVENT_ID_P int ,
					@v_TEST_LAB_TEST_P NVARCHAR(MAX),
					@v_TEST_RESULT_P  NVARCHAR(MAX),
					@v_TEST_DATE_P NVARCHAR(8) ',
					@v_EV_MW_TEST_ROW_ID_P = @v_EV_MW_TEST_ROW_ID_GEN_RMDB output , 
					@v_EVENT_ID_P = @Event_ID ,
					@v_TEST_LAB_TEST_P =  @v_Val ,
					@v_TEST_RESULT_P =  @v_Val1 ,
					@v_TEST_DATE_P =  @v_Val2 	

			--mkaur4 end
			If (@v_EV_MW_TEST_ROW_ID_GEN_RMDB = 0)
			Begin
			-- Generate Next Unique Id start
				Set @N_sql = 'select @v_Next_unique_id_P = Next_unique_id from ' + @v_Dbname + 'glossary where system_table_name = ''' + 'EVENT_X_MEDW_TEST'''				
					SET @V_ERROR_LOCATION = 'MW30'
					Execute sp_executesql @N_sql ,
						N'@v_Next_unique_id_P Int Output ',
						@v_Next_unique_id_P = @v_Next_unique_id Output	
						If @v_Next_unique_id is NULL or @v_Next_unique_id = 0 
						Set @v_Next_unique_id = 1
				
					SET @V_ERROR_LOCATION = 'MW31'
					Set @v_EV_MW_TEST_ROW_ID_GEN = @v_Next_unique_id  -- Generate Next Unique Id End
						
				Set	@N_Sql = 'Insert Into ' + @v_Dbname + 'EVENT_X_MEDW_TEST (EV_MW_TEST_ROW_ID,EVENT_ID,LAB_TEST,RESULT,TEST_DATE) '
				Set	@N_Sql =  @N_Sql+ 'Values (@v_EV_MW_TEST_ROW_ID_P , @v_Event_ID_P , @v_TEST_LAB_TEST_P ,@v_TEST_RESULT_P , @v_TEST_DATE_P  )' --mkaur24 ak v_
					SET @V_ERROR_LOCATION = 'MW32'
					Execute sp_executesql @N_sql,
						N' @v_EV_MW_TEST_ROW_ID_P int , 
						@v_EVENT_ID_P int ,
						@v_TEST_LAB_TEST_P NVARCHAR(MAX),
						@v_TEST_RESULT_P  NVARCHAR(MAX),
						@v_TEST_DATE_P NVARCHAR(8) ',
						@v_EV_MW_TEST_ROW_ID_P = @v_EV_MW_TEST_ROW_ID_GEN , 
						@v_EVENT_ID_P = @Event_ID ,
						@v_TEST_LAB_TEST_P =  @v_Val ,
						@v_TEST_RESULT_P =  @v_Val1 ,
						@v_TEST_DATE_P =  @v_Val2 	
					
				SET @V_ERROR_LOCATION = 'MW33'
				Set @v_Next_unique_id = @v_EV_MW_TEST_ROW_ID_GEN + 1 --Update Next_Unique_ID in Glossary Start			
				Set @N_sql = 'Update  ' + @v_Dbname + 'glossary set Next_unique_id = @v_Next_unique_id_P '
				Set @N_sql = @N_sql + ' where system_table_name = ''' + 'EVENT_X_MEDW_TEST'''
					SET @V_ERROR_LOCATION = 'MW34'
					Execute sp_executesql @N_sql ,
						N'@v_Next_unique_id_P Int ',
						@v_Next_unique_id_P = @v_Next_unique_id 	--Update Next_Unique_ID in Glossary End	
					SET @V_ERROR_LOCATION = 'MW35'
			End
		End
	End
End		-- Insert inot Event_X_Medw_Test End

Begin
	Set @v_ColNameList  = 'CONCOM_PRODUCT_ID_1|CONCOM_PRODUCT_ID_2|CONCOM_PRODUCT_ID_3|CONCOM_PRODUCT_ID_4|CONCOM_PRODUCT_ID_5|CONCOM_PRODUCT_ID_6|'
	Set @v_ColName1List = 'CONCOM_FROM_DATE_1|CONCOM_FROM_DATE_2|CONCOM_FROM_DATE_3|CONCOM_FROM_DATE_4|CONCOM_FROM_DATE_5|CONCOM_FROM_DATE_6|'
	Set @v_ColName2List = 'CONCOM_TO_DATE_1|CONCOM_TO_DATE_2|CONCOM_TO_DATE_3|CONCOM_TO_DATE_4|CONCOM_TO_DATE_5|CONCOM_TO_DATE_6|'
	Set @v_ColName3List = 'CONCOM_PRODUCT_1|CONCOM_PRODUCT_2|CONCOM_PRODUCT_3|CONCOM_PRODUCT_4|CONCOM_PRODUCT_5|CONCOM_PRODUCT_6|'
	
	While CHARINDEX ('|' , @v_ColNameList , 1) > 0    
	Begin  
		Set @v_ColName = LEFT (@v_ColNameList , CHARINDEX ('|' , @v_ColNameList , 1 ) - 1 )  
		Set @v_ColNameList = Right (@v_ColNameList ,len(@v_ColNameList) - CharIndex ('|', @v_ColNameList, 1) )		

		Set @v_ColName1 = LEFT (@v_ColName1List , CHARINDEX ('|' , @v_ColName1List , 1 ) - 1 )
		Set @v_ColName1List = Right (@v_ColName1List ,len(@v_ColName1List) - CharIndex ('|', @v_ColName1List, 1) )	

		Set @v_ColName2 = LEFT (@v_ColName2List , CHARINDEX ('|' , @v_ColName2List , 1 ) - 1 )
		Set @v_ColName2List = Right (@v_ColName2List ,len(@v_ColName2List) - CharIndex ('|', @v_ColName2List, 1) )	

		Set @v_ColName3 = LEFT (@v_ColName3List , CHARINDEX ('|' , @v_ColName3List , 1 ) - 1 )
		Set @v_ColName3List = Right (@v_ColName3List ,len(@v_ColName3List) - CharIndex ('|', @v_ColName3List, 1) )	

		Select @v_Val = ( Case				
			  When @v_ColName = 'CONCOM_PRODUCT_ID_1'  Then  @v_CONCOM_PRODUCT_ID_1
			  When @v_ColName = 'CONCOM_PRODUCT_ID_2'  Then  @v_CONCOM_PRODUCT_ID_2
			  When @v_ColName = 'CONCOM_PRODUCT_ID_3'  Then  @v_CONCOM_PRODUCT_ID_3
			  When @v_ColName = 'CONCOM_PRODUCT_ID_4'  Then  @v_CONCOM_PRODUCT_ID_4
			  When @v_ColName = 'CONCOM_PRODUCT_ID_5'  Then  @v_CONCOM_PRODUCT_ID_5
			  When @v_ColName = 'CONCOM_PRODUCT_ID_6'  Then  @v_CONCOM_PRODUCT_ID_6
		  End ) 
		Select @v_Val1 = ( Case			
			  When @v_ColName1 = 'CONCOM_FROM_DATE_1'  Then  @v_CONCOM_FROM_DATE_1
			  When @v_ColName1 = 'CONCOM_FROM_DATE_2'  Then  @v_CONCOM_FROM_DATE_2
			  When @v_ColName1 = 'CONCOM_FROM_DATE_3'  Then  @v_CONCOM_FROM_DATE_3
			  When @v_ColName1 = 'CONCOM_FROM_DATE_4'  Then  @v_CONCOM_FROM_DATE_4
			  When @v_ColName1 = 'CONCOM_FROM_DATE_5'  Then  @v_CONCOM_FROM_DATE_5
			  When @v_ColName1 = 'CONCOM_FROM_DATE_6'  Then  @v_CONCOM_FROM_DATE_6	 
		  End ) 
		Select @v_Val2 = ( Case			
			  When @v_ColName2 = 'CONCOM_TO_DATE_1'  Then  @v_CONCOM_TO_DATE_1
			  When @v_ColName2 = 'CONCOM_TO_DATE_2'  Then  @v_CONCOM_TO_DATE_2
			  When @v_ColName2 = 'CONCOM_TO_DATE_3'  Then  @v_CONCOM_TO_DATE_3
			  When @v_ColName2 = 'CONCOM_TO_DATE_4'  Then  @v_CONCOM_TO_DATE_4
			  When @v_ColName2 = 'CONCOM_TO_DATE_5'  Then  @v_CONCOM_TO_DATE_5
			  When @v_ColName2 = 'CONCOM_TO_DATE_6'  Then  @v_CONCOM_TO_DATE_6	 
		  End )				  
		Select @v_Val3 = ( Case			
			  When @v_ColName3 = 'CONCOM_PRODUCT_1'  Then  @v_CONCOM_PRODUCT_1
			  When @v_ColName3 = 'CONCOM_PRODUCT_2'  Then  @v_CONCOM_PRODUCT_2
			  When @v_ColName3 = 'CONCOM_PRODUCT_3'  Then  @v_CONCOM_PRODUCT_3
			  When @v_ColName3 = 'CONCOM_PRODUCT_4'  Then  @v_CONCOM_PRODUCT_4
			  When @v_ColName3 = 'CONCOM_PRODUCT_5'  Then  @v_CONCOM_PRODUCT_5				       
			  When @v_ColName3 = 'CONCOM_PRODUCT_6'  Then  @v_CONCOM_PRODUCT_6	 
		  End )				  
		If @v_Val is not null and @v_Val1 is not null and @v_Val2 is not null and @v_Val3 is not null 
		Begin
			
			--mkaur24 start
			Set @v_EV_X_CONCOM_PROD_RMDB = 0
			Set @N_Sql = 'Select @v_EV_CONCOM_ROW_ID_P = EV_CONCOM_ROW_ID from ' + @v_Dbname + 'EV_X_CONCOM_PROD where EVENT_ID = @v_Event_ID_P  '
			set @N_Sql =  @N_sql + 'and CONCOM_PRODUCT_ID = @v_CONCOM_PRODUCT_ID_P  '
			set @N_Sql =  @N_sql + 'and FROM_DATE = @v_FROM_DATE_P  '
			set @N_Sql =  @N_sql + 'and TO_DATE = @v_TO_DATE_P  '
			set @N_Sql =  @N_sql + 'and CONCOM_PRODUCT = @v_CONCOM_PRODUCT_P  '
			SET @V_ERROR_LOCATION = 'MWse38'
				Execute sp_executesql @N_sql,
					N' @v_EV_CONCOM_ROW_ID_P int output, 
					@v_EVENT_ID_P int ,
					@v_CONCOM_PRODUCT_ID_P int,
					@v_FROM_DATE_P  NVARCHAR(8),
					@v_TO_DATE_P NVARCHAR(8),
					@v_CONCOM_PRODUCT_P NVARCHAR(40) ',
					@v_EV_CONCOM_ROW_ID_P = @v_EV_X_CONCOM_PROD_RMDB output, --mkaur24 ak
					@v_EVENT_ID_P = @Event_ID ,
					@v_CONCOM_PRODUCT_ID_P =  @v_Val ,
					@v_FROM_DATE_P =  @v_Val1 ,
					@v_TO_DATE_P =  @v_Val2 	,
					@v_CONCOM_PRODUCT_P =  @v_Val3

			--mkaur4 end
			If (@v_EV_X_CONCOM_PROD_RMDB = 0)
			Begin
					-- Generate Next Unique Id start
				Set @N_sql = 'select @v_Next_unique_id_P = Next_unique_id from ' + @v_Dbname + 'glossary where system_table_name = ''' + 'EV_X_CONCOM_PROD'''
				SET @V_ERROR_LOCATION = 'MW36'
					Execute sp_executesql @N_sql ,
						N'@v_Next_unique_id_P Int Output ',
						@v_Next_unique_id_P = @v_Next_unique_id Output
				SET @V_ERROR_LOCATION = 'MW37'
					
				If @v_Next_unique_id is NULL or @v_Next_unique_id = 0 
					Set @v_Next_unique_id = 1
								
				Set @v_EV_X_CONCOM_PROD_GEN = @v_Next_unique_id
				-- Generate Next Unique Id End
				Set	@N_Sql = 'Insert Into ' + @v_Dbname + 'EV_X_CONCOM_PROD (EV_CONCOM_ROW_ID,EVENT_ID,CONCOM_PRODUCT_ID,FROM_DATE,TO_DATE,CONCOM_PRODUCT) '
				Set	@N_Sql =  @N_Sql+ 'Values (@v_EV_CONCOM_ROW_ID_P , @v_Event_ID_P , @v_CONCOM_PRODUCT_ID_P  ,@v_FROM_DATE_P  , @v_TO_DATE_P , @v_CONCOM_PRODUCT_P)' --mkaur24 ak v_ and @v_EV_CONCOM_ROW_ID_P
				SET @V_ERROR_LOCATION = 'MW38'
					Execute sp_executesql @N_sql,
						N' @v_EV_CONCOM_ROW_ID_P int , 
						@v_EVENT_ID_P int ,
						@v_CONCOM_PRODUCT_ID_P int,
						@v_FROM_DATE_P  NVARCHAR(8),
						@v_TO_DATE_P NVARCHAR(8),
						@v_CONCOM_PRODUCT_P NVARCHAR(40) ',
						@v_EV_CONCOM_ROW_ID_P = @v_EV_X_CONCOM_PROD_GEN , --mkaur24 ak
						@v_EVENT_ID_P = @Event_ID ,
						@v_CONCOM_PRODUCT_ID_P =  @v_Val ,
						@v_FROM_DATE_P =  @v_Val1 ,
						@v_TO_DATE_P =  @v_Val2 	,
						@v_CONCOM_PRODUCT_P =  @v_Val3
			
				SET @V_ERROR_LOCATION = 'MW39'
				
				--Update Next_Unique_ID in Glossary Start
				Set @v_Next_unique_id = @v_EV_X_CONCOM_PROD_GEN + 1	

				Set @N_sql = 'Update  ' + @v_Dbname + 'glossary set Next_unique_id = @v_Next_unique_id_P '
				Set @N_sql = @N_sql + ' where system_table_name = ''' + 'EV_X_CONCOM_PROD'''
				SET @V_ERROR_LOCATION = 'MW40'
					Execute sp_executesql @N_sql ,
						N'@v_Next_unique_id_P Int ',
						@v_Next_unique_id_P = @v_Next_unique_id 
				SET @V_ERROR_LOCATION = 'MW41'
				--Update Next_Unique_ID in Glossary End	
			End
		End
	End
End
--Insert into Event_X_Medw_test Ends
SET @V_ERROR_LOCATION = 'MW2'
END

 --Supplemental Insert Starts\
If (@MEDWATCH_SUPP <> 0 ) and (@I_ERRORCOUNT = 0 ) and (@Event_ID > 0)	
Begin	
	EXEC DDS_SUPPLEMENT		 -- Insert call for Medwatch
		@P_JOBID                = @p_JOBID,
		@P_CONFIG_ID            = @CONFIG_ID,
		@P_USER_ID              = @p_USERID,
		@P_MODULE_NAME          = 'MEDWATCH',
		@P_DB_NAME              = @V_DBName,
		@P_DA_ROW_ID            = @v_DA_ROW_ID,
		@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
		@P_LOB                  = 0,
		@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
		@P_STAGE                = 'I', 
		@P_CLAIMANT_EID         = 0,
		@P_EVENT_ID             = @Event_ID,
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
		@P_EV_CONCOM_ROW_ID		= @v_EV_X_CONCOM_PROD_GEN, --ete
		@P_EV_MW_TEST_ROW_ID	= @v_EV_MW_TEST_ROW_ID_GEN,
		@P_KEYCOLUMN            = 'EVENT_NUMBER',
		@P_KEYVALUE             = @v_EVENT_NUMBER,
		@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 
	
	--IF (@v_EV_CONCOM_ROW_ID_GEN > 0)
	--Begin
	--	EXEC DDS_SUPPLEMENT		 -- Insert for EV_CONCOM_ROW_ID
	--		@P_JOBID                = @p_JOBID,
	--		@P_CONFIG_ID            = @CONFIG_ID,
	--		@P_USER_ID              = @p_USERID,
	--		@P_MODULE_NAME          = 'MEDWATCH',
	--		@P_DB_NAME              = @V_DBName,
	--		@P_DA_ROW_ID            = @v_DA_ROW_ID, 
	--		@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
	--		@P_LOB                  = 0,
	--		@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
	--		@P_STAGE                = 'I', 
	--		@P_CLAIMANT_EID         = 0,
	--		@P_EVENT_ID             = 0,
	--		@P_CLAIM_ID             = 0,
	--		@P_EMPLOYEE_EID         = 0,
	--		@P_UNIT_ID              = 0,
	--		@P_ENTITY_ID            = 0,
	--		@P_DEFENDANT_ROW_ID     = 0,
	--		@P_PI_ROW_ID            = 0,
	--		@P_PI_PROC_ROW_ID       = 0,
	--		@P_PATIENT_ID           = 0,
	--		@P_TRANS_ID             = 0,
	--		@P_PLAN_ID              = 0,
	--		@P_EV_CONCOM_ROW_ID		= @v_EV_CONCOM_ROW_ID_GEN,
	--		@P_EV_MW_TEST_ROW_ID	= 0,
	--		@P_KEYCOLUMN            = 'EVENT_NUMBER',
	--		@P_KEYVALUE             = @v_EVENT_NUMBER,
	--		@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 	
	--End
	--IF (@v_EV_MW_TEST_ROW_ID_GEN > 0)
	--Begin
	--	EXEC DDS_SUPPLEMENT		 -- Insert for EV_MW_TEST_ROW_ID
	--		@P_JOBID                = @p_JOBID,
	--		@P_CONFIG_ID            = @CONFIG_ID,
	--		@P_USER_ID              = @p_USERID,
	--		@P_MODULE_NAME          = 'MEDWATCH',
	--		@P_DB_NAME              = @V_DBName,
	--		@P_DA_ROW_ID            = @v_DA_ROW_ID, -- Row to be executed -- MapFlag should be 0 if you dont want to execute it
	--		@P_CODE_CREATION_FLAG   = @CheckCreateNewCodes,
	--		@P_LOB                  = 0,
	--		@P_BASE_ERROR_COUNT     = @I_ERRORCOUNT,
	--		@P_STAGE                = 'I',  -- V for validation and I for Insert
	--		@P_CLAIMANT_EID         = 0,
	--		@P_EVENT_ID             = 0,
	--		@P_CLAIM_ID             = 0,
	--		@P_EMPLOYEE_EID         = 0,
	--		@P_UNIT_ID              = 0,
	--		@P_ENTITY_ID            = 0,
	--		@P_DEFENDANT_ROW_ID     = 0,
	--		@P_PI_ROW_ID            = 0,
	--		@P_PI_PROC_ROW_ID       = 0,
	--		@P_PATIENT_ID           = 0,
	--		@P_TRANS_ID             = 0,
	--		@P_PLAN_ID              = 0,
	--		@P_EV_CONCOM_ROW_ID		= 0,
	--		@P_EV_MW_TEST_ROW_ID	= @v_EV_MW_TEST_ROW_ID_GEN,
	--		@P_KEYCOLUMN            = 'EVENT_NUMBER',
	--		@P_KEYVALUE             = @v_EVENT_NUMBER,
	--		@P_SUPP_ERROR_COUNT	    = @P_SUPP_ERROR_COUNT_R OUTPUT 	
	--End

End
	
 --Supplemental Insert Ends
SET @V_ERROR_LOCATION = 'MW43' --MKAUR24 AK

	IF @I_ERRORCOUNT = 0
	BEGIN
	UPDATE DDS_MEDWATCH SET INVALID_ROW = 0 WHERE  JOBID = @p_jobID AND DA_ROW_ID = @v_DA_ROW_ID
	SET @V_ERROR_LOCATION = 'MW4388'	
	END
	SET @V_ERROR_LOCATION = 'MW4389'	
	

End Try
Begin Catch                          
	
	SET @V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
	EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @v_JOBID,
		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
		@p_MODULE_NAME = @V_MODULENAME ,
		@p_CALLING_ERROR_LOCATION = 'Main', 
		@p_CURRENT_ERROR_LOCATION = @V_ERROR_LOCATION,  --MAKUR24 AK
		@p_ERROR_PROC_NAME = @V_PROCNAME ,
		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
		@p_ERROR_COLUMNS = 'Exception' ,
		@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
		@P_IS_VALIDATION = 0 ;

	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;
	
End Catch
SET @V_ERROR_LOCATION = 'MW44'

		----Neha Running status code starts 33658---
			BEGIN TRY
							
			SET @V_ERROR_LOCATION= 'Running_Status'
			
			IF @iRunStatCnt=1
			BEGIN
			
				SET @vProcessMsg ='Total Number of Records processed in MEDWATCH : '+ cast(@iRunStatCnt as varchar);

				SET @N_sql = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
				SET @N_sql =@N_sql +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

				EXECUTE SP_EXECUTESQL @N_sql,
				N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
				@pJOBID=@v_JobID, @pProcessMsg=@vProcessMsg, @pModuleName='MEDWATCH_RUN',@pTableName ='DDS_MEDWATCH_RUN',@pDisplayOrder=-11
			END
			ELSE  
			IF (@iRunCnt = 1000)
			BEGIN
					SET @vProcessMsg ='Total Number of Records processed in MEDWATCH : '+ cast(@iRunStatCnt as varchar);

					SET @N_sql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
					SET @N_sql =@N_sql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @N_sql,
					N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@v_JobID,@pModuleName='MEDWATCH_RUN',@pTableName ='DDS_MEDWATCH_RUN',@pDisplayOrder=-11
					SET @iRunCnt=1;
			END
			ELSE
			IF (@iTotalRows=@iRunStatCnt)
			BEGIN
				SET @vProcessMsg ='Total Number of Records processed in MEDWATCH : '+ cast(@iRunStatCnt as varchar);
				SET @N_sql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
				SET @N_sql =@N_sql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @N_sql,
                    N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@v_JobID,@pModuleName='MEDWATCH_RUN',@pTableName ='DDS_MEDWATCH_RUN',@pDisplayOrder=-11
			END

			SET @iRunStatCnt =@iRunStatCnt + 1; 
			SET @iRunCnt = @iRunCnt + 1;
			END TRY
			BEGIN CATCH
					SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@v_DA_Row_ID, 'MEDWATCH','Run_Status', 'Run_Status','DDS_PROCESS_MEDWATCH',@V_ERROR_MESSAGE,'EXCEPTION', 'DDS_MEDWATCH','EVENT_NUMBER', @v_EVENT_NUMBER, 0
					SET @I_ERRORCOUNT += 1
			END CATCH
			---Neha running status code ends 33658---


Fetch Next from  Cur_MedWatch into   
@v_JobID ,
@v_DA_Row_ID,
@v_Invalid_Row,
@v_Update_Row ,
@v_EVENT_NUMBER	 ,
@v_UNIT_CODE ,
@v_DATE_RPTD_FDA  ,
@v_DATE_RPTD_MFG  ,
@v_RPTD_BY_LAST_NAME  ,
@v_RPTD_BY_FIRST_NAME  ,
@v_RPTD_BY_ADDR1  ,
@v_RPTD_BY_ADDR2  ,
@v_RPTD_BY_CITY 	 ,
@v_RPTD_BY_STATE  ,
@v_RPTD_BY_ZIP_CODE  ,
@v_RPTD_BY_TAX_ID  ,
@v_RPTD_BY_PRO_FLAG  ,
@v_RPTD_BY_POS_CODE  ,
@v_RELEVANT_HISTORY ,
@v_LAST_REPORT_DATE  ,
@v_REPORT_YEAR , 
@v_REPORT_SERIAL_NO ,
@v_ADVERSE_EVENT_FLAG  ,
@v_PRODUCT_PROB_FLAG   ,
@v_LIFE_THREAT_FLAG   ,
@v_HOSPITALIZ_FLAG   ,
@v_DISABILITY_FLAG   ,
@v_CONGENITAL_FLAG   ,
@v_REQD_INTERV_FLAG   ,
@v_FOLLOW_UP_COUNT ,
@v_RPT_MANDATORY  ,
@v_MED_TYPE ,
@v_MED_NAME  ,
@v_DOSE  ,
@v_FREQUENCY  ,
@v_ROUTE  ,
@v_THERAPY_FROM_DATE  ,
@v_THERAPY_TO_DATE   ,
@v_DURATION ,
@v_LOT_NUMBER  ,
@v_NDC_NUMBER ,
@v_EXPIRATION_DATE  ,
@v_EVENT_ABATED  ,
@v_EVENT_REAPPEARED  ,
@v_DIAGNOSIS_TEST   ,
@v_BRAND_NAME  ,
@v_EQUIP_TYPE_CODE	  ,
@v_MANUF_NAME  ,
@v_MANUF_ADDR1  ,
@v_MANUF_ADDR2  ,
@v_MANUF_CITY  ,
@v_MANUF_STATE   ,
@v_MANUF_ZIP_CODE	  ,
@v_MODEL_NUMBER  ,
@v_CATALOG_NUMBER  ,
@v_SERIAL_NUMBER  ,
@v_OTHER_NUMBER  ,
@v_DEVICE_OPER_CODE  ,
@v_IMPLANT_DATE  ,
@v_EXPLANT_DATE  ,
@v_AGE_OF_DEVICE  ,
@v_DEV_AVAIL_FOR_EVAL  ,
@v_DEVICE_RETURN_DATE  ,
@v_EQ_LOT_NUMBER  ,
@v_EQ_EXPIRATION_DATE  ,
@v_TEST_LAB_TEST_1   ,
@v_TEST_LAB_TEST_2   ,
@v_TEST_LAB_TEST_3   ,
@v_TEST_LAB_TEST_4   ,
@v_TEST_LAB_TEST_5   ,
@v_TEST_RESULT_1  ,
@v_TEST_RESULT_2  ,
@v_TEST_RESULT_3  ,
@v_TEST_RESULT_4  ,
@v_TEST_RESULT_5  ,
@v_TEST_DATE_1	  ,
@v_TEST_DATE_2 ,	  
@v_TEST_DATE_3 , 	  
@v_TEST_DATE_4 ,   
@v_TEST_DATE_5 ,
@v_CONCOM_PRODUCT_ID_1  ,
@v_CONCOM_PRODUCT_ID_2  ,
@v_CONCOM_PRODUCT_ID_3  ,
@v_CONCOM_PRODUCT_ID_4  ,
@v_CONCOM_PRODUCT_ID_5  ,
@v_CONCOM_PRODUCT_ID_6  ,
@v_CONCOM_FROM_DATE_1  ,
@v_CONCOM_FROM_DATE_2  ,
@v_CONCOM_FROM_DATE_3  ,
@v_CONCOM_FROM_DATE_4  ,
@v_CONCOM_FROM_DATE_5  ,
@v_CONCOM_FROM_DATE_6  ,
@v_CONCOM_TO_DATE_1  ,
@v_CONCOM_TO_DATE_2  ,
@v_CONCOM_TO_DATE_3  ,
@v_CONCOM_TO_DATE_4  ,
@v_CONCOM_TO_DATE_5  ,
@v_CONCOM_TO_DATE_6  ,
@v_CONCOM_PRODUCT_1  ,
@v_CONCOM_PRODUCT_2  ,
@v_CONCOM_PRODUCT_3  ,
@v_CONCOM_PRODUCT_4  ,
@v_CONCOM_PRODUCT_5  ,
@v_CONCOM_PRODUCT_6  ,
@V_MANUF_BIRTH_DT ,
@V_RPTD_BY_BIRTH_DT ,
@v_NAME_TYPE

Set @TotalRows = @TotalRows - 1 ;
-- REINITIALIZE LOCAL VARIBLES START
set @I_ERRORCOUNT = 0 ;	
set @v_ColName = null ;
set @v_ColName2  = null ;
set @v_ColName3 = null ;
set @v_ColName1List = null ;
set @v_ColName2List = null ;
set @v_ColName3List = null ;
set @v_TableName = null ;
set @v_ColNameList  = null ;
set @v_TableNameList  = null ;
set @iCodeId  = 0 ;
set @v_Val = null ;
set @v_Val1 = null ;
set @v_Val2 = null ;
set @v_Val3 = null ;
set @N_sql = null ;
set @MANUF_STATE_R  = 0 ;
set @RPTD_BY_STATE_R  = 0 ;
set @RPTD_BY_PRO_FLAG_R	  = 0 ;
set @ADVERSE_EVENT_FLAG_R   = 0 ;
set @PRODUCT_PROB_FLAG_R  = 0 ;
set @HOSPITALIZ_FLAG_R  = 0 ; 
set @DISABILITY_FLAG_R   = 0 ;
set @CONGENITAL_FLAG_R    = 0 ;
set @REQD_INTERV_FLAG_R   = 0  ;
set @v_RPTD_BY_TAX_ID_Invalid_Flag  = 0;
set @ErrorColumn = null ;
set @iEntId = 0;
set @i_Reporter_ENTITY_ID_GEN = 0;
set @iNoError = 0;
set @i_MANUF_ENTITY_ID_GEN  = 0 ;
set @Entity_Id  = 0 ;
set @Do_Nothing  = 0 ;
set @Event_ID  = 0;
set @DEV_AVAIL_FOR_EVAL_R  = 0;
set @EVENT_REAPPEARED_R  = 0 ;
set  @EVENT_ABATED_R  = 0 ;
set @RPT_MANDATORY_R  = 0 ;
set @REVENT_ABATED_R  = 0 ;
set @V_DTTM_RCD_LAST_UPD_GEN = null ;
set @v_UPDATED_BY_USER = null ;
set @Event_ID_MED  = 0;
set @UNIT_CODE_R  = 0 ;
set @LIFE_THREAT_FLAG_R  =  0 ;
set @v_Next_unique_id  = 0 ;
set @v_EV_MW_TEST_ROW_ID_GEN  = 0 ;
set @v_EV_CONCOM_ROW_ID_GEN  = 0 ;
set @v_EV_X_CONCOM_PROD_GEN = 0 ;
set @V_ERROR_LOCATION = null ;
set @P_SUPP_ERROR_COUNT_R = 0 ;
set @iTaxIDErr  = 0  ;
-- REINITIALIZE LOCAL VARIBLES START

End -- While ka end





SET @V_ERROR_LOCATION = 'MW45'
Set Nocount off ;
Close Cur_MedWatch ;
Deallocate Cur_MedWatch ;

SET @V_ERROR_LOCATION = 'MW46'

exec    DDS_PROCESS_LOG
@P_JOBID = @p_jobID ,@p_MODULE_NAME='MEDWATCH', @p_PROCESS_TABLE='DDS_MEDWATCH'

End Try
Begin Catch  
	
	SET 	@V_ERROR_MESSAGE =  ERROR_MESSAGE()	 
	EXEC DDS_ERROR_LOG_CAPTURE @p_JOBID = @v_JOBID,
		@p_DA_ROW_ID  = @V_DA_ROW_ID , 
		@p_MODULE_NAME = @V_MODULENAME ,
		@p_CALLING_ERROR_LOCATION = 'Main', 
		@p_CURRENT_ERROR_LOCATION = @V_ERROR_LOCATION,  --MKAUR24 AK
		@p_ERROR_PROC_NAME = @V_PROCNAME ,
		@p_ERROR_MSG = @V_ERROR_MESSAGE ,
		@p_ERROR_COLUMNS = 'Exception' ,
		@p_ERROR_TABLE_TO_CHECK = @V_ERROR_TABLE_TO_CHECK,
		@p_ERROR_KEY_COLUMN = 'EVENT_NUMBER',  
		@P_ERROR_COLUMN_KEY_VALUE = @v_EVENT_NUMBER , 
		@P_IS_VALIDATION = 0 ;
	
	SET @I_ERRORCOUNT = @I_ERRORCOUNT + 1 ;

CLOSE DDS_EVENT_CUR ;
DEALLOCATE DDS_EVENT_CUR ;

End Catch
End 
