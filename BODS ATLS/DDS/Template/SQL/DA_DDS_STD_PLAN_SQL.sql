IF OBJECT_ID('DDS_IMPORT_STD_PLAN','P') IS NOT NULL
       DROP PROCEDURE DDS_IMPORT_STD_PLAN
GO
CREATE PROCEDURE [dbo].[DDS_IMPORT_STD_PLAN]
@P_JOBID      INT ,
@P_DBNAME     VARCHAR(255),
@P_USER_ID INT
WITH EXECUTE AS CALLER 
AS 
BEGIN ----BEGIN MAIN
BEGIN TRY  ----BEGIN MAIN TRY`
       SET NOCOUNT ON

       -- Variables for selected Options
       DECLARE @CheckCreateNewCodes SMALLINT,
       @CONFIG_ID SMALLINT,
       @Valid_Start_Date VARCHAR(8),
       @Valid_End_Date VARCHAR(8),
       @V_STD_PLAN_SUPP INT

       -- Variables for std_plan Record Fields
       DECLARE @V_DA_ROW_ID INT ,
       @V_INVALID_ROW INT,
       @V_PLAN_NUMBER VARCHAR(20),
       @V_PLAN_NAME VARCHAR(20),
       @V_PLAN_DESCRIPTION VARCHAR(50),
       @V_PLAN_STATUS VARCHAR(25),
       @V_PREMIUM DECIMAL(20,2),
       @V_BANK_ACCOUNT_NUM VARCHAR(20),
       @V_EFFECTIVE_DATE VARCHAR(8),
       @V_EXPIRATION_DATE VARCHAR(8),
       @V_ISSUE_DATE VARCHAR(8),
       @V_REVIEW_DATE VARCHAR(8),
       @V_RENEWAL_DATE VARCHAR(8),
       @V_CANCEL_DATE VARCHAR(8),
       @V_PREF_DAY_PAY_TYPE VARCHAR(25),
       @V_PREF_PAY_SCHEDULE_TYPE VARCHAR(25),
       @V_COMMENTS VARCHAR(255),
       @V_START_PAY_PERIOD VARCHAR(8),
       @V_PRINT_BEFORE_END_FLAG VARCHAR(1),
       @V_BANK_SUB_ACCNT_NUM VARCHAR(20),
       @V_INSURED_EID VARCHAR(207),
       @V_INSURED_HIER_LEVEL VARCHAR(15)

       -- CODE_ID VARIABLES
       DECLARE @V_PREF_DAY_PAY_TYPE_ID INT = 0 ,
       @V_PREF_PAY_SCHEDULE_TYPE_ID INT = 0,
       @V_PLAN_STATUS_ID INT = 0 ,
       @V_PRINT_BEFORE_END_FLAG_ID INT,
       @V_ERRORLOC VARCHAR(20),
       @V_CLASSROW_ID  INT = 0,
       @V_PLAN_ID  INT,
       @V_TAXFLAGS  INT,
       @V_DIS_TYPE_ID INT,
       @V_INSERTPLANINFO INT = 0,
       @V_EMP_PERSON INT = 0,
       @V_TABLE_ID INT = 0,
       @V_ROW_ID INT = 0

       --- Other Local Variables
       DECLARE @V_ROWCOUNT  INT = 0 ,
       @V_CODE_ID_R INT  = 0 ,
       @V_MODULENAME VARCHAR(100) = 'STD_PLAN',
       @V_DBNAME  VARCHAR(255),
       @V_SQL  NVARCHAR(MAX),
       @V_PROCNAME  VARCHAR(30) = 'DDS_STD_PLAN',
       @V_TABLE_NAME  VARCHAR(30) = 'DDS_STD_PLAN',
       @V_DDSUSER  VARCHAR(6) = 'DA DDS',
       @V_ERRORCOUNT  INT = 0 ,
       @V_ENTITY_ID  INT = 0 ,
       @V_DEPT_ID  INT = 0 ,
       @V_ENTITY_TABLE_ID  INT = 0 ,
       @V_ABBREVIATION  VARCHAR(25) = NULL,
       @VSQLINSERT NVARCHAR(MAX),
       @V_DATETIME VARCHAR(14),
       @V_ERROR_MESSAGE NVARCHAR(MAX),
       @TOTALROWS INT,
       @V_CODEFIELDS VARCHAR(MAX),
       @V_SYSTEMTABLENAME VARCHAR(MAX),
       @V_TABLENAME VARCHAR(30),
       @V_NEWPLAN INT = 0,
       @V_SUPP_ERROR_COUNT INT = 0,
       @V_BANK_ACC_ID INT = 0,
       @V_SUB_ACC_ROW_ID INT = 0,
       @vReqColumns  VARCHAR(MAX),
       @vReqColumns1  VARCHAR(MAX),
       @vColName1      VARCHAR(100),
       @vColName2      VARCHAR(100),
       @V_VAL          VARCHAR(MAX),
       @V_INSURED_EID_RMDB INT = 0,
       @V_NEWINSURED INT = 0,
       @V_INSUREDHIERRACHYOK INT = 0,
       @V_CLAIM_LOB INT = 844,
	   --neha JIRA 33658 starts
       @iRunStatCnt int=1, 
       @vProcessMsg varchar(100) ,  
	   @iRunCnt	int=0,
	   @iTotalRows int= 0
	   --neha JIRA 33658 ends

       BEGIN TRY ---- FETCHING VALUES FROM DDS_OPTIONSET
              ------------------------- FOR SQL db name has to be suffixed by dbo -----------------------------------------
              IF @P_DBName IS NOT NULL 
              BEGIN
                 SET @V_DBNAME = '[' + @P_DBNAME + '].DBO.';
              END
              ----------------------------- Storing Values into Optionset variables ---------------------------------------
              SET @V_ERRORLOC = 'Z001'
                     
              SET @V_SQL = 'SELECT @CheckCreateNewCodes = ALLOW_NEW_CODES, @CONFIG_ID = CONFIG_ID, @Valid_Start_Date = VALID_START_DATE, '
              SET @V_SQL = @V_SQL + '@Valid_End_Date = VALID_END_DATE, @V_STD_PLAN_SUPP = STDPLAN_SUPP '
              SET @V_SQL = @V_SQL + 'FROM DDS_OPTIONSET WHERE JOBID = @P_JOBID'

              Exec sp_Executesql @V_SQL,
              N'@CheckCreateNewCodes INT OUTPUT,
              @CONFIG_ID INT OUTPUT,     
              @Valid_Start_Date VARCHAR(8) OUTPUT, 
              @Valid_End_Date VARCHAR(8) OUTPUT, 
              @V_STD_PLAN_SUPP INT OUTPUT,
              @P_JOBID INT',
              @CheckCreateNewCodes = @CheckCreateNewCodes OUTPUT,
              @CONFIG_ID = @CONFIG_ID OUTPUT,   
              @Valid_Start_Date = @Valid_Start_Date OUTPUT, 
              @Valid_End_Date = @Valid_End_Date OUTPUT, 
              @V_STD_PLAN_SUPP = @V_STD_PLAN_SUPP OUTPUT,
              @P_JOBID = @P_JOBID;


              IF @Valid_Start_Date IS NULL 
              BEGIN
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,
                     'Please select Valid Date Range from Optionset screen.','JOB_ID', 'DDS_OPTIONSET', 'JOB_ID', @P_JOBID, 1
                     GOTO ENDMAIN
              END
              
       END TRY
       BEGIN CATCH
              SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
              EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0
              SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
       END CATCH
       
       BEGIN TRY ---- FETCHING TOTAL ROWS FROM DDS_STD_PLAN
              SET @V_ERRORLOC = 'Z002'
              SET @V_SQL = 'SELECT @TOTALROWS = COUNT(DA_ROW_ID) FROM DDS_STD_PLAN WHERE JOBID = @P_JOBID AND INVALID_ROW = 1'; 

              Exec sp_Executesql @V_SQL,
              N' @TOTALROWS INT OUTPUT,
              @P_JOBID INT',
              @TOTALROWS = @TOTALROWS OUTPUT,
              @P_JOBID = @P_JOBID;
              
              ----PRINT '@TOTALROWS: ' + CAST (@TOTALROWS AS VARCHAR(10));
       END TRY
       BEGIN CATCH
              SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
              EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, @V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0
              SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
       END CATCH

	   SET @iTotalRows=@TOTALROWS --neha 33658
       
       ----------------------------- Fetching PLAN Records For Validation----------------------------------------------------
       SET @V_ERRORLOC = 'Z003'          

       DECLARE DDS_STD_PLAN_CUR CURSOR FOR  ------ DECLARING CURSOR  
       SELECT 
              DA_ROW_ID,    INVALID_ROW , PLAN_NUMBER , PLAN_NAME ,   PLAN_DESCRIPTION ,   PLAN_STATUS ,      PREMIUM ,     BANK_ACCOUNT_NUM ,   EFFECTIVE_DATE ,
              EXPIRATION_DATE ,    ISSUE_DATE ,  REVIEW_DATE , RENEWAL_DATE ,       CANCEL_DATE ,       PREF_DAY_PAY_TYPE ,  PREF_PAY_SCHEDULE_TYPE ,   COMMENTS ,    START_PAY_PERIOD ,
              PRINT_BEFORE_END_FLAG ,    BANK_SUB_ACCNT_NUM , INSURED_EID , INSURED_HIER_LEVEL

       FROM DDS_STD_PLAN
       WHERE JOBID = @P_JOBID AND INVALID_ROW = 1 ; 

       OPEN DDS_STD_PLAN_CUR;  ---- OPENING CURSOR

       FETCH NEXT FROM DDS_STD_PLAN_CUR
       INTO @V_DA_ROW_ID,   @V_INVALID_ROW,      @V_PLAN_NUMBER,      @V_PLAN_NAME,       @V_PLAN_DESCRIPTION, @V_PLAN_STATUS,      @V_PREMIUM,   @V_BANK_ACCOUNT_NUM, @V_EFFECTIVE_DATE,
       @V_EXPIRATION_DATE,  @V_ISSUE_DATE ,      @V_REVIEW_DATE ,     @V_RENEWAL_DATE ,       @V_CANCEL_DATE ,     @V_PREF_DAY_PAY_TYPE ,     @V_PREF_PAY_SCHEDULE_TYPE , @V_COMMENTS ,
       @V_START_PAY_PERIOD ,      @V_PRINT_BEFORE_END_FLAG , @V_BANK_SUB_ACCNT_NUM ,       @V_INSURED_EID ,     @V_INSURED_HIER_LEVEL      
       
       WHILE @TOTALROWS <> 0
       BEGIN

              ----************** INITIALIZATION OF VARIABLES ******************
              SET @V_PREF_DAY_PAY_TYPE_ID = 0 
              SET @V_PREF_PAY_SCHEDULE_TYPE_ID  = 0
              SET @V_PLAN_STATUS_ID  = 0 
              SET @V_ERRORLOC = 0
              SET @V_CLASSROW_ID   = 0
              SET @V_PLAN_ID  = 0
              SET @V_TAXFLAGS  = 0
              SET @V_DIS_TYPE_ID = 0
              SET @V_INSERTPLANINFO  = 0
              SET @V_EMP_PERSON  = 0
              SET @V_TABLE_ID  = 0
              SET @V_ROW_ID  = 0
              SET @V_ROWCOUNT   = 0 
              SET @V_CODE_ID_R   = 0 
              SET @V_ERRORCOUNT   = 0 
              SET @V_ENTITY_ID   = 0 
              SET @V_DEPT_ID   = 0 
              SET @V_ENTITY_TABLE_ID   = 0 
              SET @V_ABBREVIATION  = 0
              SET @V_DATETIME = 0
              SET @V_NEWPLAN = 0
              SET @V_SUPP_ERROR_COUNT = 0
              SET @vColName1 = NULL
              SET @vReqColumns = NULL
              SET @vColName2 = NULL
              SET @vReqColumns1 = NULL
              SET @V_INSURED_EID_RMDB = 0
              SET @V_NEWINSURED = 0
              SET @V_INSUREDHIERRACHYOK = 0

              BEGIN TRY     --********* REQUIRED FIELD VALIDATION STARTS **********************************************
                     SET @V_ERRORLOC = 'V001'
                     SET @vReqColumns = 'PLAN_NUMBER|PLAN_NAME|PLAN_STATUS|EFFECTIVE_DATE|EXPIRATION_DATE|'

                     WHILE CHARINDEX('|',@vReqColumns,1) > 0         --CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
                     BEGIN

                           SET @vColName1 = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
                           SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))

                           SET @V_VAL = ( CASE 
                           WHEN @vColName1 = 'PLAN_NUMBER' THEN @V_PLAN_NUMBER 
                           WHEN @vColName1 = 'PLAN_NAME' THEN @V_PLAN_NAME 
                           WHEN @vColName1 = 'PLAN_STATUS' THEN @V_PLAN_STATUS           
                           WHEN @vColName1 = 'EFFECTIVE_DATE' THEN @V_EFFECTIVE_DATE  
                           WHEN @vColName1 = 'EXPIRATION_DATE' THEN @V_EXPIRATION_DATE   
                           END )

                           IF @V_VAL IS NULL
                           BEGIN
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,'Required Fields are Null or Empty.',@vColName1, @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                                  SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
                           END
                     END
              END TRY
              BEGIN CATCH
                     SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                     SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
              END CATCH --***************** REQUIRED FIELD VALIDATION ENDS ******************************************
              
              BEGIN TRY     ----***************** SHORT CODE FIELDS VALIDATION STARTS *********************************
                     SET @V_ERRORLOC = 'V002'
                     SET @V_CODEFIELDS = 'PLAN_STATUS|PREF_DAY_PAY_TYPE|PREF_PAY_SCHEDULE_TYPE|'

                     SET @V_SYSTEMTABLENAME = 'PLAN_STATUS|PREF_PAYMENT_DAY|PERIOD_TYPES|'
       
                     WHILE CHARINDEX('|',@V_CODEFIELDS,1) > 0        --CHECK FOR CODE ID EXISTENCE AND THEIR CREATIONS
                                                                                                                                                                                                                                                                                                                                  BEGIN
                     SET @VCOLNAME1 = LEFT(@V_CODEFIELDS,CHARINDEX('|',@V_CODEFIELDS,1) - 1)
                     SET @V_CODEFIELDS = RIGHT(@V_CODEFIELDS,LEN(@V_CODEFIELDS) - CHARINDEX('|',@V_CODEFIELDS,1))
              
                     SET @V_TABLENAME = LEFT(@V_SYSTEMTABLENAME,CHARINDEX('|',@V_SYSTEMTABLENAME,1) - 1)
                     SET @V_SYSTEMTABLENAME = RIGHT(@V_SYSTEMTABLENAME,LEN(@V_SYSTEMTABLENAME) - CHARINDEX('|',@V_SYSTEMTABLENAME,1))

                     SET @V_VAL =( CASE 
                     WHEN @VCOLNAME1 = 'PLAN_STATUS' THEN @V_PLAN_STATUS
                     WHEN @VCOLNAME1 = 'PREF_DAY_PAY_TYPE' THEN @V_PREF_DAY_PAY_TYPE
                     WHEN @VCOLNAME1 = 'PREF_PAY_SCHEDULE_TYPE' THEN @V_PREF_PAY_SCHEDULE_TYPE
                     END )
                     ----PRINT 'CODE CHECK BEGINS'
                     ----PRINT @V_VAL
                     IF @V_VAL IS NOT NULL 
                     BEGIN
                                  ----PRINT 'CODE CHECK BEGINS2'
                           EXECUTE DDS_CODE_VALIDATION_IMPORT 
                           @p_JOBID = @P_JOBID, 
                           @P_SHORT_CODE = @V_VAL, 
                            @P_SYS_TABLE_NAME = @V_TABLENAME, 
                           @P_CODE_CREATION_FLAG = @CheckCreateNewCodes, 
                           @P_DB_NAME = @V_DBNAME, 
                           @P_LOB = @V_CLAIM_LOB, 
                           @p_DA_ROW_ID = @V_DA_ROW_ID,
                           @p_MODULE_NAME = @V_MODULENAME, 
                           @p_ERROR_LOCATION = @V_ERRORLOC, 
                           @p_ERROR_PROC_NAME = @V_PROCNAME, 
                           @p_ERROR_KEY_COLUMN = 'PLAN_NUMBER', 
                           @p_ERROR_COLUMN = @VCOLNAME1, 
                           @p_ERROR_TABLE_TO_CHECK = @V_TABLE_NAME, 
                           @P_ERROR_COLUMN_KEY_VALUE = @V_PLAN_NUMBER, 
                           @P_CODE_ID_R = @V_CODE_ID_R OUTPUT

                           IF @V_CODE_ID_R = 0 OR @V_CODE_ID_R IS NULL
                           BEGIN
                                  SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;
                           END

                           IF @VCOLNAME1 = 'PLAN_STATUS' SET @V_PLAN_STATUS_ID = @V_CODE_ID_R   
                           ELSE IF @VCOLNAME1 = 'PREF_DAY_PAY_TYPE' SET @V_PREF_DAY_PAY_TYPE_ID = @V_CODE_ID_R
                           ELSE IF @VCOLNAME1 = 'PREF_PAY_SCHEDULE_TYPE' SET @V_PREF_PAY_SCHEDULE_TYPE_ID = @V_CODE_ID_R
                                                
                           SET @V_CODE_ID_R = NULL
                     END
              END
              END TRY
              BEGIN CATCH
                           SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                           EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                           SET @V_ROWCOUNT = @V_ROWCOUNT + 1
              END CATCH ----***************** SHORT CODE FIELDS VALIDATION ENDS *******************************************

              BEGIN TRY     ----***************** FLAG INITIALIZATION STARTS ******************************************
                     SET @V_ERRORLOC = 'V003'
              
                           IF @V_PRINT_BEFORE_END_FLAG IS NOT NULL
                           BEGIN
                                  IF @V_PRINT_BEFORE_END_FLAG = 'Y'
                                         SET @V_PRINT_BEFORE_END_FLAG_ID = -1
                                  ELSE IF @V_PRINT_BEFORE_END_FLAG = 'N' OR @V_PRINT_BEFORE_END_FLAG = '0' ---BY DEFAULT FLAG WILL BE 0
                                         SET @V_PRINT_BEFORE_END_FLAG_ID = 0
                                  ELSE
                                  BEGIN
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'Not a Valid Flag Value. Permitted Values are ''Y'' or ''N'' or ''0''.', @vColName1, @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                                         SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
                                  END
                           END
                                  
              END TRY
              BEGIN CATCH
                     SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                     SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
              END CATCH     --***************** FLAG INITIALIZATION ENDS *****************************************************

              BEGIN TRY     -- **************** DATE VALIDATION STARTS   **********************************************
              SET @V_ERRORLOC = 'V004'
       
              SET @vReqColumns = 'EFFECTIVE_DATE|EXPIRATION_DATE|ISSUE_DATE|REVIEW_DATE|RENEWAL_DATE|CANCEL_DATE|START_PAY_PERIOD|'

              WHILE CHARINDEX('|',@vReqColumns,1) > 0         --NOTE:CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
              BEGIN
                     SET @vColName1 = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
                     SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
              
                     SET @V_VAL = ( CASE 
                     WHEN @vColName1 = 'EFFECTIVE_DATE' THEN @V_EFFECTIVE_DATE
                     WHEN @vColName1 = 'EXPIRATION_DATE' THEN @V_EXPIRATION_DATE  
                     WHEN @vColName1 = 'ISSUE_DATE' THEN @V_ISSUE_DATE 
                     WHEN @vColName1 = 'REVIEW_DATE' THEN @V_REVIEW_DATE  
                     WHEN @vColName1 = 'RENEWAL_DATE' THEN @V_RENEWAL_DATE
                     WHEN @vColName1 = 'CANCEL_DATE' THEN @V_CANCEL_DATE  
                     WHEN @vColName1 = 'START_PAY_PERIOD' THEN @V_START_PAY_PERIOD  
                     END)
              
                     IF @V_VAL IS NOT NULL
                     BEGIN
                           IF DBO.DATEVALIDATE(@V_VAL) = -1
                           BEGIN
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'Date Provided is Not a Valid Date.', @vColName1, @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                                  SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
                                  --PRINT 'ERROR: Not a Valid Date'
                           END
                           ELSE IF (@V_VAL < @Valid_Start_Date) OR (@Valid_End_Date < @V_VAL)
                           BEGIN
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'Date provided is out of Valid Date Range.', @vColName1, @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                                  SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
                                  --PRINT 'ERROR: Date provided is out of Valid Date Range'
                                  --PRINT @V_VAL
                           END
                     END
              END
			  
			  IF DBO.DATEVALIDATE(@V_EFFECTIVE_DATE) = 1 AND DBO.DATEVALIDATE(@V_EXPIRATION_DATE) = 1 AND @V_EXPIRATION_DATE < @V_EFFECTIVE_DATE
			  BEGIN
                                EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'Plan Expiration Date Should be Greater than or Equal to Effective Date', 'EXPIRATION_DATE,EFFECTIVE_DATE', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                                 SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
			  END
              
		END TRY
              BEGIN CATCH
                     SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                     SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
              END CATCH     ----**************** DATE VALIDATION ENDS    *****************************************************

              
              --********************************** ERROR COUNT *******************************************************************************************
              SET @V_ERRORLOC = 'V005'
                           
              IF @V_ERRORCOUNT + @V_ROWCOUNT > 0 SET @V_INVALID_ROW = 1

              ELSE IF (@V_ERRORCOUNT + @V_ROWCOUNT = 0) SET @V_INVALID_ROW = 0

              --********************************** ERROR COUNT ******************************************************************************************
                     
                                                       
              BEGIN TRY     ---**************** CHECK IF AN EXISTING PLAN OR A NEW PLAN *******************************************************************
              IF @V_PLAN_NUMBER IS NOT NULL AND @V_INVALID_ROW = 0
              BEGIN
                     SET @V_ERRORLOC = 'P001' 
                     SET @V_SQL = 'SELECT @V_PLAN_ID = PLAN_ID FROM ' + @V_DBNAME + 'DISABILITY_PLAN WHERE PLAN_NUMBER = @V_PLAN_NUMBER'
                     
                     Exec sp_Executesql @V_SQL,
                     N' @V_PLAN_ID INT OUTPUT,
                     @V_PLAN_NUMBER VARCHAR(20)',
                     @V_PLAN_ID = @V_PLAN_ID OUTPUT,
                     @V_PLAN_NUMBER = @V_PLAN_NUMBER
              
                     IF            @V_PLAN_ID > 0       SET @V_NEWPLAN = 0   --PLAN EXIST IN RISKMASTER DATABASE 
                     ELSE IF @V_PLAN_ID = 0  SET @V_NEWPLAN = 1      --PLAN DOES NOT EXIST IN RISKMASTER DATABASE 

                     IF @V_BANK_ACCOUNT_NUM IS NOT NULL
                     BEGIN
                           SET @V_ERRORLOC = 'P002' 
                           SET @V_BANK_ACC_ID = 0
                           SET @V_SQL = 'SELECT @V_BANK_ACC_ID = ACCOUNT_ID FROM ' + @V_DBNAME + 'ACCOUNT WHERE ACCOUNT_NUMBER = @V_BANK_ACCOUNT_NUM'

                           Exec sp_Executesql @V_SQL,
                           N'@V_BANK_ACC_ID INT OUTPUT,
                           @V_BANK_ACCOUNT_NUM VARCHAR(20)',
                           @V_BANK_ACC_ID = @V_BANK_ACC_ID OUTPUT,
                           @V_BANK_ACCOUNT_NUM = @V_BANK_ACCOUNT_NUM

                     END

                     IF @V_BANK_SUB_ACCNT_NUM IS NOT NULL 
                     BEGIN
                           SET @V_ERRORLOC = 'P003' 
                           SET  @V_SUB_ACC_ROW_ID = 0
                           SET @V_SQL = 'SELECT @V_SUB_ACC_ROW_ID = SUB_ROW_ID FROM ' + @V_DBNAME + 'BANK_ACC_SUB WHERE SUB_ACC_NUMBER = @V_BANK_SUB_ACCNT_NUM'

                           Exec sp_Executesql @V_SQL,
                           N'@V_SUB_ACC_ROW_ID INT OUTPUT,
                           @V_BANK_SUB_ACCNT_NUM VARCHAR(20)',
                           @V_SUB_ACC_ROW_ID = @V_SUB_ACC_ROW_ID OUTPUT,
                           @V_BANK_SUB_ACCNT_NUM = @V_BANK_SUB_ACCNT_NUM

                     END
       
                     SET @V_ERRORLOC = 'P004'
                     SET @vReqColumns1 = @V_INSURED_HIER_LEVEL
					 IF @vReqColumns1 IS NOT NULL SET @vReqColumns1 = @vReqColumns1 + '|'
					 						
		 			 WHILE CHARINDEX('|',@vReqColumns1,1) > 0 
					 BEGIN
						SET @vColName2 = LEFT(@vReqColumns1, CHARINDEX('|',@vReqColumns1,1) - 1)
						SET @vReqColumns1 = RIGHT(@vReqColumns1,LEN(@vReqColumns1) - CHARINDEX('|',@vReqColumns1,1))

						IF CAST (@vColName2 AS INT) > 8 OR CAST(@vColName2 AS INT) < 1
						BEGIN
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'INSURED_HIER_LEVEL NOT between 1 and 8 Including both.', 'INSURED_HIER_LEVEL', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
							SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
						END
					 END
					
					 SET @vReqColumns = @V_INSURED_EID
                     SET @vReqColumns1 = @V_INSURED_HIER_LEVEL

                     IF (LEN(@vReqColumns) - LEN(REPLACE(@vReqColumns, '|', ''))) = (LEN(@vReqColumns1) - LEN(REPLACE(@vReqColumns1, '|', '')))
						AND @vReqColumns IS NOT NULL AND @vReqColumns1 IS NOT NULL
					 BEGIN
						  SET @V_INSUREDHIERRACHYOK = 1
					 END 
					 ELSE IF @vReqColumns IS NOT NULL AND @vReqColumns1 IS NOT NULL
                     BEGIN
                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME, 'Numbers of DIS_PLAN_X_INSURED plan abbreviation and Hierarchy levels does not match.', 'INSURED_EID,INSURED_HIER_LEVEL', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,1
                           SET @V_ERRORCOUNT = @V_ERRORCOUNT + 1;   
                     END
              END
              END TRY
              BEGIN CATCH
                     SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                     SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
              END CATCH     
                     
              IF @V_STD_PLAN_SUPP = 1 
              BEGIN -- BEGIN SUPPLEMENTAL FIELDS VALIDATION
              BEGIN TRY
                     SET @V_ERRORLOC = 'P005'

                     EXECUTE DDS_SUPPLEMENT
                     @P_JOBID, @CONFIG_ID, @P_USER_ID, @V_MODULENAME, @V_DBNAME, @V_DA_ROW_ID, @CheckCreateNewCodes, 0,
                     @V_ERRORCOUNT,       -- TO CHECK THERE IS ANY ERROR IN BASE RECORD (INPUT PARAMETER TO CHECK BASE ERROR)
                     'V',                 -- VALIDATION OR INSERT (V OR I)
                     0,0,0,0,0,0,0,0,0,0,0,
                     @V_PLAN_ID, 0,0,                                
                     'PLAN_NUMBER',                                  -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
                     @V_PLAN_NUMBER,                                -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
                     @V_SUPP_ERROR_COUNT OUTPUT --(OUT PARAMETER TO INTIMATE BASE THAT THERE IS AND ERROR IN SUPP)
              
              SET @V_ERRORCOUNT = @V_ERRORCOUNT + ISNULL(@V_SUPP_ERROR_COUNT,0)
              
              END TRY
              BEGIN CATCH
                     SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                     EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
                     SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
              END CATCH
              END -- END SUPPLEMENTAL FIELDS VALIDATION

              ----------************************** CHECK IF AN EXISTING PLAN OR A NEW PLAN ENDS **********************************************************           
              
              ----****************************************************************************************************************************************

                     SET @V_ERRORLOC = 'P006'
                     
                     IF @V_ROWCOUNT + @V_ERRORCOUNT > 0 SET @V_INVALID_ROW = 1

                     ELSE IF @V_ROWCOUNT + @V_ERRORCOUNT = 0 SET @V_INVALID_ROW = 0

              ----****************************************************************************************************************************************
              
              ----****************************************************************************************************************************************                     
              BEGIN TRY  ------------INSERT WORK STARTS

              IF @V_INVALID_ROW = 0
              BEGIN  ----BEGIN LEVEL INSERT/UPDATE
                           SET @V_ERRORLOC = 'INS01'
                           SET @V_DATETIME = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120),'-',''), ':', ''),' ','')
                           
                           IF @V_NEWPLAN = 1
                           BEGIN
                                  SET @V_ERRORLOC = 'INS02'
                                  SET @VSQLINSERT = 'SELECT @NEXTUNIQUEID_P = NEXT_UNIQUE_ID FROM ' + @V_DBNAME + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''DISABILITY_PLAN'''
                                  EXECUTE SP_EXECUTESQL @VSQLINSERT, N'@NEXTUNIQUEID_P INT OUTPUT', @NEXTUNIQUEID_P = @V_PLAN_ID OUTPUT;

                                  SET @V_ERRORLOC = 'INS03'
                                  SET @V_SQL = 'INSERT INTO ' + @V_DBNAME+'DISABILITY_PLAN(PLAN_ID,
                                                              PLAN_NUMBER, PLAN_NAME, PLAN_DESCRIPTION, PLAN_STATUS_CODE, PREMIUM, BANK_ACC_ID, EFFECTIVE_DATE, EXPIRATION_DATE,
                                                              ISSUE_DATE,   REVIEW_DATE, RENEWAL_DATE, CANCEL_DATE, PREF_DAY_CODE, PREF_PAY_SCH_CODE, COMMENTS,     ADDED_BY_USER,
                                                              DTTM_RCD_ADDED,      UPDATED_BY_USER, DTTM_RCD_LAST_UPD, START_PAY_PERIOD, PRINT_BEFORE_END, SUB_ACC_ROW_ID,
                                                              HTMLCOMMENTS)'

                                  SET @V_SQL =  @V_SQL + ' VALUES(@V_PLAN_ID,
                                                              @V_PLAN_NUMBER,      @V_PLAN_NAME, @V_PLAN_DESCRIPTION, @V_PLAN_STATUS_ID, @V_PREMIUM, @V_BANK_ACC_ID, @V_EFFECTIVE_DATE,                                                   @V_EXPIRATION_DATE,
                                                              @V_ISSUE_DATE, @V_REVIEW_DATE, @V_RENEWAL_DATE,     @V_CANCEL_DATE,      @V_PREF_DAY_PAY_TYPE_ID, @V_PREF_PAY_SCHEDULE_TYPE_ID,       @V_COMMENTS, @V_DDSUSER,
                                                              @V_DATETIME, @V_DDSUSER, @V_DATETIME, @V_START_PAY_PERIOD, @V_PRINT_BEFORE_END_FLAG_ID,      @V_SUB_ACC_ROW_ID,
                                                              @V_HTMLCOMMENTS)'
              
       
                                  EXECUTE SP_EXECUTESQL @V_SQL,  
                                  N'@V_PLAN_ID INT,
                                  @V_PLAN_NUMBER VARCHAR(20),
                                  @V_PLAN_NAME VARCHAR(20),
                                  @V_PLAN_DESCRIPTION  VARCHAR(50),
                                  @V_PLAN_STATUS_ID  INT,
                                  @V_PREMIUM  DECIMAL(20,2),
                                  @V_BANK_ACC_ID  INT,
                                  @V_EFFECTIVE_DATE  VARCHAR(8),
                                  @V_EXPIRATION_DATE  VARCHAR(8),
                                  @V_ISSUE_DATE VARCHAR(8),
                                  @V_REVIEW_DATE VARCHAR(8),
                                  @V_RENEWAL_DATE VARCHAR(8),
                                  @V_CANCEL_DATE VARCHAR(8),
                                  @V_PREF_DAY_PAY_TYPE_ID INT,
                                  @V_PREF_PAY_SCHEDULE_TYPE_ID INT,
                                  @V_COMMENTS VARCHAR(255),
                                  @V_DDSUSER VARCHAR(6),
                                  @V_DATETIME VARCHAR(14),
                                  @V_START_PAY_PERIOD VARCHAR(8),
                                  @V_PRINT_BEFORE_END_FLAG_ID INT,
                                  @V_SUB_ACC_ROW_ID INT,
                                  @V_HTMLCOMMENTS VARCHAR(255)',
                                  @V_PLAN_ID = @V_PLAN_ID,
                                  @V_PLAN_NUMBER = @V_PLAN_NUMBER,
                                  @V_PLAN_NAME = @V_PLAN_NAME,
                                  @V_PLAN_DESCRIPTION = @V_PLAN_DESCRIPTION,
                                  @V_PLAN_STATUS_ID = @V_PLAN_STATUS_ID,
                                  @V_PREMIUM = @V_PREMIUM,
                                  @V_BANK_ACC_ID = @V_BANK_ACC_ID,
                                  @V_EFFECTIVE_DATE = @V_EFFECTIVE_DATE,
                                  @V_EXPIRATION_DATE = @V_EXPIRATION_DATE,
                                  @V_ISSUE_DATE = @V_ISSUE_DATE,
                                  @V_REVIEW_DATE = @V_REVIEW_DATE,
                                  @V_RENEWAL_DATE = @V_RENEWAL_DATE,
                                  @V_CANCEL_DATE = @V_CANCEL_DATE,
                                  @V_PREF_DAY_PAY_TYPE_ID = @V_PREF_DAY_PAY_TYPE_ID,
                                  @V_PREF_PAY_SCHEDULE_TYPE_ID = @V_PREF_PAY_SCHEDULE_TYPE_ID,
                                  @V_COMMENTS = @V_COMMENTS,
                                  @V_DDSUSER = @V_DDSUSER,
                                  @V_DATETIME = @V_DATETIME,
                                  @V_START_PAY_PERIOD = @V_START_PAY_PERIOD,
                                  @V_PRINT_BEFORE_END_FLAG_ID = @V_PRINT_BEFORE_END_FLAG_ID,
                                  @V_SUB_ACC_ROW_ID = @V_SUB_ACC_ROW_ID,
                                  @V_HTMLCOMMENTS = @V_COMMENTS 
                           
                                  SET @V_ERRORLOC = 'INS04'
                                  SET @VSQLINSERT = 'UPDATE ' + @V_DBNAME + 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = ''DISABILITY_PLAN'''
                                  EXECUTE SP_EXECUTESQL @VSQLINSERT
                           END
                           ELSE
                           BEGIN
                                  SET @V_ERRORLOC = 'INS05'

                                  SET @V_SQL = 'UPDATE ' + @V_DBNAME + 'DISABILITY_PLAN SET '

                                  SET @V_SQL = @V_SQL + ' PLAN_NAME = @V_PLAN_NAME'
                                  SET @V_SQL = @V_SQL + ', UPDATED_BY_USER = @V_DDSUSER'
                                  SET @V_SQL = @V_SQL + ', DTTM_RCD_LAST_UPD = @V_DATETIME'
                                  SET @V_SQL = @V_SQL + ', EFFECTIVE_DATE = @V_EFFECTIVE_DATE'
                                  SET @V_SQL = @V_SQL + ', EXPIRATION_DATE = @V_EXPIRATION_DATE'
                                  IF @V_PLAN_DESCRIPTION IS NOT NULL SET @V_SQL = @V_SQL + ', PLAN_DESCRIPTION = @V_PLAN_DESCRIPTION'
                                  IF @V_PLAN_STATUS_ID IS NOT NULL SET @V_SQL = @V_SQL + ', PLAN_STATUS_CODE = @V_PLAN_STATUS_ID'
                                  IF @V_PREMIUM > 0 SET @V_SQL = @V_SQL + ', PREMIUM = @V_PREMIUM'
                                  IF @V_ISSUE_DATE IS NOT NULL SET @V_SQL = @V_SQL + ', ISSUE_DATE = @V_ISSUE_DATE'
                                  IF @V_REVIEW_DATE IS NOT NULL SET @V_SQL = @V_SQL + ', REVIEW_DATE = @V_REVIEW_DATE'
                                  IF @V_RENEWAL_DATE IS NOT NULL SET @V_SQL = @V_SQL + ', RENEWAL_DATE = @V_RENEWAL_DATE'
                                  IF @V_CANCEL_DATE IS NOT NULL SET @V_SQL = @V_SQL + ', CANCEL_DATE = @V_CANCEL_DATE'
                                  IF @V_PREF_DAY_PAY_TYPE_ID > 0 SET @V_SQL = @V_SQL + ', PREF_DAY_CODE = @V_PREF_DAY_PAY_TYPE_ID'
                                  IF @V_PREF_DAY_PAY_TYPE_ID > 0 SET @V_SQL = @V_SQL + ', PREF_PAY_SCH_CODE =  @V_PREF_PAY_SCHEDULE_TYPE_ID'
                                  IF @V_COMMENTS IS NOT NULL SET @V_SQL = @V_SQL + ', COMMENTS = @V_COMMENTS'
                                  IF @V_PRINT_BEFORE_END_FLAG_ID IS NOT NULL SET @V_SQL = @V_SQL + ', PRINT_BEFORE_END = @V_PRINT_BEFORE_END_FLAG_ID'
                                  IF @V_START_PAY_PERIOD IS NOT NULL SET @V_SQL = @V_SQL + ', START_PAY_PERIOD = @V_START_PAY_PERIOD'
                                  IF @V_SUB_ACC_ROW_ID > 0 SET @V_SQL = @V_SQL + ', SUB_ACC_ROW_ID = @V_SUB_ACC_ROW_ID'
                                  IF @V_COMMENTS IS NOT NULL SET @V_SQL = @V_SQL + ', HTMLCOMMENTS = @V_COMMENTS'


                                  SET @V_SQL = @V_SQL + ' WHERE PLAN_ID = @V_PLAN_ID'


                                  EXECUTE SP_EXECUTESQL @V_SQL,  
                                  N'@V_PLAN_ID INT,
                                  @V_PLAN_NAME VARCHAR(20),
                                  @V_PLAN_DESCRIPTION  VARCHAR(50),
                                  @V_PLAN_STATUS_ID  INT,
                                  @V_PREMIUM  DECIMAL(20,2),
                                  @V_BANK_ACC_ID  INT,
                                  @V_EFFECTIVE_DATE  VARCHAR(8),
                                  @V_EXPIRATION_DATE  VARCHAR(8),
                                  @V_ISSUE_DATE VARCHAR(8),
                                  @V_REVIEW_DATE VARCHAR(8),
                                  @V_RENEWAL_DATE VARCHAR(8),
                                  @V_CANCEL_DATE VARCHAR(8),
                                  @V_PREF_DAY_PAY_TYPE_ID INT,
                                  @V_PREF_PAY_SCHEDULE_TYPE_ID INT,
                                  @V_COMMENTS VARCHAR(255),
                                  @V_DDSUSER VARCHAR(6),
                                  @V_DATETIME VARCHAR(14),
                                  @V_START_PAY_PERIOD VARCHAR(8),
                                  @V_PRINT_BEFORE_END_FLAG_ID SMALLINT,
                                  @V_SUB_ACC_ROW_ID INT,
                                  @V_HTMLCOMMENTS VARCHAR(255)',
                                  @V_PLAN_ID = @V_PLAN_ID,
                                  @V_PLAN_NAME = @V_PLAN_NAME,
                                  @V_PLAN_DESCRIPTION = @V_PLAN_DESCRIPTION,
                                  @V_PLAN_STATUS_ID = @V_PLAN_STATUS_ID,
                                  @V_PREMIUM = @V_PREMIUM,
                                  @V_BANK_ACC_ID = @V_BANK_ACC_ID,
                                  @V_EFFECTIVE_DATE = @V_EFFECTIVE_DATE,
                                  @V_EXPIRATION_DATE = @V_EXPIRATION_DATE,
                                  @V_ISSUE_DATE = @V_ISSUE_DATE,
                                  @V_REVIEW_DATE = @V_REVIEW_DATE,
                                  @V_RENEWAL_DATE = @V_RENEWAL_DATE,
                                  @V_CANCEL_DATE = @V_CANCEL_DATE,
                                  @V_PREF_DAY_PAY_TYPE_ID = @V_PREF_DAY_PAY_TYPE_ID,
                                  @V_PREF_PAY_SCHEDULE_TYPE_ID = @V_PREF_PAY_SCHEDULE_TYPE_ID,
                                  @V_COMMENTS = @V_COMMENTS,
                                  @V_DDSUSER = @V_DDSUSER,
                                  @V_DATETIME = @V_DATETIME,
                                  @V_START_PAY_PERIOD = @V_START_PAY_PERIOD,
                                  @V_PRINT_BEFORE_END_FLAG_ID = @V_PRINT_BEFORE_END_FLAG_ID,
                                  @V_SUB_ACC_ROW_ID = @V_SUB_ACC_ROW_ID,
                                  @V_HTMLCOMMENTS = @V_COMMENTS

                           END    

                           IF @V_INSUREDHIERRACHYOK = 1
                           BEGIN
								  SET @vReqColumns = @V_INSURED_EID
			    				  IF @vReqColumns IS NOT NULL SET @vReqColumns = @vReqColumns + '|'
								  
			                      SET @vReqColumns1 = @V_INSURED_HIER_LEVEL
								  IF @vReqColumns1 IS NOT NULL SET @vReqColumns1 = @vReqColumns1 + '|'

                                  SET @V_ERRORLOC = 'INS06'
                                  WHILE CHARINDEX('|',@vReqColumns,1) > 0         
                                  BEGIN

                                         SET @vColName1 = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
                                         SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))

                                         SET @vColName2 = LEFT(@vReqColumns1,CHARINDEX('|',@vReqColumns1,1) - 1)
                                         SET @vReqColumns1 = RIGHT(@vReqColumns1,LEN(@vReqColumns1) - CHARINDEX('|',@vReqColumns1,1))
                           
                                         SET @V_ERRORLOC = 'INS07'
                                         SET @V_ENTITY_ID = 0
                                         SET @V_ENTITY_TABLE_ID = CAST(@vColName2 AS INT) + 1004              

                                         SET @V_SQL = 'SELECT @V_ENTITY_ID = ENTITY_ID FROM ' + @V_DBNAME + 'ENTITY WHERE ABBREVIATION = @vColName1 AND ENTITY_TABLE_ID = @V_ENTITY_TABLE_ID AND DELETED_FLAG = 0'   

                                         Exec sp_Executesql @V_SQL, 
                                         N'@V_ENTITY_ID INT OUTPUT,
                                         @vColName1 VARCHAR(25),
                                         @V_ENTITY_TABLE_ID INT',
                                         @V_ENTITY_ID = @V_ENTITY_ID OUTPUT,
                                         @vColName1 = @vColName1,
                                         @V_ENTITY_TABLE_ID = @V_ENTITY_TABLE_ID

                                         IF @V_ENTITY_ID > 0
                                         BEGIN
                                                SET @V_ERRORLOC = 'INS08'
                                                SET @V_INSURED_EID_RMDB = 0
                                                SET @V_SQL = 'SELECT @V_INSURED_EID_RMDB = INSURED_EID FROM ' + @V_DBNAME + 'DIS_PLAN_X_INSURED WHERE PLAN_ID = @V_PLAN_ID AND INSURED_EID = @V_ENTITY_ID'

                                                Exec sp_Executesql @V_SQL,
                                                N'@V_INSURED_EID_RMDB INT OUTPUT,
                                                @V_PLAN_ID INT,
                                                @V_ENTITY_ID INT',
                                                @V_INSURED_EID_RMDB = @V_INSURED_EID_RMDB OUTPUT,
                                                @V_PLAN_ID = @V_PLAN_ID,
                                                @V_ENTITY_ID = @V_ENTITY_ID

                                                IF @V_INSURED_EID_RMDB = 0 
                                                BEGIN
                                                       SET @V_ERRORLOC = 'INS09'
                                                       SET @V_SQL = 'INSERT INTO ' + @V_DBNAME+'DIS_PLAN_X_INSURED(PLAN_ID,INSURED_EID)'
                                                       SET @V_SQL =  @V_SQL + ' VALUES(@V_PLAN_ID, @V_ENTITY_ID)'
              
                                                       EXECUTE SP_EXECUTESQL @V_SQL,  
                                                       N'@V_PLAN_ID INT,
                                                       @V_ENTITY_ID INT',
                                                       @V_PLAN_ID = @V_PLAN_ID,
                                                       @V_ENTITY_ID = @V_ENTITY_ID                                         
                                                END
                                         END
                                  END
                           END
                                                       
                     IF @V_STD_PLAN_SUPP = 1 
                     BEGIN -- SUPPLEMENTAL COLUMN INSERT BEGIN
                           SET @V_ERRORLOC = 'INS10'
                           IF @V_PLAN_ID > 0 
                           EXECUTE DDS_SUPPLEMENT @P_JOBID, @CONFIG_ID, @P_USER_ID, @V_MODULENAME, @V_DBNAME, @V_DA_ROW_ID, @CheckCreateNewCodes, 0,
                           @V_ERRORCOUNT, 'I',  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @V_PLAN_ID,0,0, 'PLAN NUMBER', @V_PLAN_NUMBER, @V_SUPP_ERROR_COUNT OUTPUT 

                     END -- SUPPLEMENTAL COLUMN INSERT END


              END  ----END LEVEL INSERT/UPDATE

       END TRY
       BEGIN CATCH
              SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
              EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
              SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
       END CATCH    ----INSERT WORK ENDS

       --********************************************************************************************************************************************************************
       SET @V_ERRORLOC = 'END666'
              
       IF @V_ROWCOUNT + @V_ERRORCOUNT = 0 SET @V_INVALID_ROW = 0
              
       IF @V_INVALID_ROW = 0
       BEGIN
              SET @V_SQL = 'UPDATE DDS_STD_PLAN SET INVALID_ROW = @V_INVALID_ROW_P WHERE DA_ROW_ID = @V_DA_ROW_ID_P AND JOBID = @P_JOBID_P';

              Exec sp_Executesql @V_SQL,
              N' @V_INVALID_ROW_P AS INT ,
              @V_DA_ROW_ID_P INT,
              @P_JOBID_P INT',
              @V_INVALID_ROW_P = @V_INVALID_ROW,
              @V_DA_ROW_ID_P = @V_DA_ROW_ID,
              @P_JOBID_P = @P_JOBID

       END

	   ----Neha Running status code starts 33658---
			BEGIN TRY
							
			SET @V_ERRORLOC= 'Running_Status'
			
			IF @iRunStatCnt=1
			BEGIN
			
				SET @vProcessMsg ='Total Number of Records processed in STD PLAN : '+ cast(@iRunStatCnt as varchar);

				SET @V_SQL = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
				SET @V_SQL =@V_SQL +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

				EXECUTE SP_EXECUTESQL @V_SQL,
				N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
				@pJOBID=@P_JOBID, @pProcessMsg=@vProcessMsg, @pModuleName='STD_PLAN_RUN',@pTableName ='DDS_STD_PLAN_RUN',@pDisplayOrder=-11
			END
			ELSE  
			IF (@iRunCnt = 1000)
			BEGIN
					SET @vProcessMsg ='Total Number of Records processed in STD PLAN : '+ cast(@iRunStatCnt as varchar);

					SET @V_SQL = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
					SET @V_SQL =@V_SQL +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @V_SQL,
					N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='STD_PLAN_RUN',@pTableName ='DDS_STD_PLAN_RUN',@pDisplayOrder=-11
					SET @iRunCnt=1;
			END
			ELSE
			IF (@iTotalRows=@iRunStatCnt)
			BEGIN
				SET @vProcessMsg ='Total Number of Records processed in STD PLAN : '+ cast(@iRunStatCnt as varchar);
				SET @V_SQL = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
				SET @V_SQL =@V_SQL +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @V_SQL,
                    N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='STD_PLAN_RUN',@pTableName ='DDS_STD_PLAN_RUN',@pDisplayOrder=-11
			END

			SET @iRunStatCnt =@iRunStatCnt + 1; 
			SET @iRunCnt = @iRunCnt + 1;
			END TRY
			BEGIN CATCH
					SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
					SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
			END CATCH
			---Neha running status code ends 33658---

       FETCH NEXT FROM DDS_STD_PLAN_CUR
       INTO @V_DA_ROW_ID,   @V_INVALID_ROW,      @V_PLAN_NUMBER,      @V_PLAN_NAME,       @V_PLAN_DESCRIPTION, @V_PLAN_STATUS,      @V_PREMIUM,   @V_BANK_ACCOUNT_NUM, @V_EFFECTIVE_DATE,
       @V_EXPIRATION_DATE,  @V_ISSUE_DATE ,      @V_REVIEW_DATE ,     @V_RENEWAL_DATE ,       @V_CANCEL_DATE ,     @V_PREF_DAY_PAY_TYPE ,     @V_PREF_PAY_SCHEDULE_TYPE , @V_COMMENTS ,
       @V_START_PAY_PERIOD ,      @V_PRINT_BEFORE_END_FLAG , @V_BANK_SUB_ACCNT_NUM ,       @V_INSURED_EID ,     @V_INSURED_HIER_LEVEL      
       
       SET @TOTALROWS = @TOTALROWS - 1

       END

       CLOSE DDS_STD_PLAN_CUR;
       DEALLOCATE DDS_STD_PLAN_CUR;
       SET NOCOUNT OFF

ENDMAIN:
---PROCESS LOG CALLING FOR SUMMARY OF RECORDS
EXEC DDS_PROCESS_LOG @P_JOBID, @V_MODULENAME, @V_TABLE_NAME   

END TRY ---- END MAIN TRY
BEGIN CATCH   
       SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
       EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @V_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', @V_TABLE_NAME, 'PLAN_NUMBER', @V_PLAN_NUMBER,0;
       SET @V_ROWCOUNT = @V_ROWCOUNT + 1;
       ---In case there is some exception in main try then the cursor needs to be closed and deallocated so that next run does not create any issues
       CLOSE DDS_STD_PLAN_CUR;
       DEALLOCATE DDS_STD_PLAN_CUR;      
END CATCH ---- END MAIN CATCH

END ----- END MAIN