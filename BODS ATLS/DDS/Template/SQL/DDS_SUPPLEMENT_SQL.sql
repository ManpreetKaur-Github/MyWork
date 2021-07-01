IF OBJECT_ID('[DDS_SUPPLEMENT]','P') IS NOT NULL
	DROP PROCEDURE [DDS_SUPPLEMENT];
GO

CREATE PROCEDURE DDS_SUPPLEMENT
	@P_JOBID                                  INT ,
	@P_CONFIG_ID                              INT ,
	@P_USER_ID                                INT ,
	@P_MODULE_NAME                            VARCHAR(50) ,
	@P_DB_NAME                                VARCHAR(50) ,
	@P_DA_ROW_ID                              INT ,
	@P_CODE_CREATION_FLAG                     INT ,
	@P_LOB                                    INT ,
	@P_BASE_ERROR_COUNT                       INT ,	-- TO CHECK THERE IS ANY ERROR IN BASE RECORD (INPUT PARAMETER TO CHECK BASE ERROR)
	@P_STAGE                                  VARCHAR(50) ,	-- VALIDATION OR INSERT (V OR I)
	@P_CLAIMANT_EID                           INT ,
	@P_EVENT_ID                               INT ,
	@P_CLAIM_ID                               INT ,
	@P_EMPLOYEE_EID                           INT ,
	@P_UNIT_ID                                INT ,
	@P_ENTITY_ID                              INT ,
	@P_DEFENDANT_ROW_ID                       INT ,
	@P_PI_ROW_ID                              INT ,
	@P_PI_PROC_ROW_ID                         INT ,
	@P_PATIENT_ID                             INT ,
	@P_TRANS_ID                               INT ,
	@P_PLAN_ID                                INT ,
	@P_EV_CONCOM_ROW_ID			  INT,--Kapil added below conditions for Med Watch functionality                         
	@P_EV_MW_TEST_ROW_ID			  INT,--Kapil added below conditions for Med Watch functionality
	@P_KEYCOLUMN                              VARCHAR(4000) ,	-- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
	@P_KEYVALUE                               VARCHAR(4000) ,	-- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
	@P_SUPP_ERROR_COUNT                       INT OUTPUT --(OUT PARAMETER TO INTIMATE BASE THAT THERE IS AND ERROR IN SUPP)
 WITH EXECUTE AS CALLER
	AS 
	BEGIN
		BEGIN TRY
			SET NOCOUNT ON
		
			--*************************************************************************************************************************************************************
			--*********************** STRUCTURE OF DDS_SUPPLEMENT PROCEDURE STARTS ************************************************************************
			--*************************************************************************************************************************************************************		
			--Insert into DDS_SUPPLEMENTAL_RUNTIME_DATA (staging)
			--Select count of records from DDS_modulename_USR_SUPP_MAP (staging),data is saved into this table from RMA UI when saving optionset
			--Declare corsor ,loop for the count of records
			--Fetch the records from SUPP_DICTIONARY
			--@P_STAGE=V --validation block
			--@P_STAGE=I --Insertion block
			--*************************************************************************************************************************************************************
			--*********************** STRUCTURE OF DDS_SUPPLEMENT PROCEDURE ENDS ************************************************************************
			--*************************************************************************************************************************************************************

			DECLARE @adv_error INT
			
		
			DECLARE @V_SQL                                    NVARCHAR(Max) 
			DECLARE @V_SQL_VALUE                              NVARCHAR(Max) 
			DECLARE @ParmDefinition 						  NVARCHAR(MAX)
			DECLARE @V_FIELD_NUM                              INT 
			DECLARE @V_USER_FIELD_NAME                        VARCHAR(25) 
			DECLARE @V_MAP_FLAG                               VARCHAR(10) 
			DECLARE @V_FIELD_TYPE                             VARCHAR(25) 
			DECLARE @V_MAPPED_TABLE                           VARCHAR(50) 
			DECLARE @V_MAPPED_FIELD                           VARCHAR(50) 
			DECLARE @V_NULL_FLAG                              VARCHAR(10) 
			DECLARE @V_VALIDATE_FLAG                          VARCHAR(10) 
			DECLARE @V_CODE_TABLE_ID                          VARCHAR(10) 
			DECLARE @V_DB_NAME                                VARCHAR(100) 
			DECLARE @V_FIELD_TYPE_C                           INT 
			DECLARE @V_FIELD_ID_C                             INT 
			DECLARE @V_CODE_FILE_ID_C                         INT 
			DECLARE @V_MULTI_VAL                              INT 
			DECLARE @V_FIELD_TYPE_NAME                        VARCHAR(100) 
			DECLARE @V_USER_FIELD_NAME_VALUE                  VARCHAR(MAX) 		-- THIS VARIABLE IS USED IN VALIDATION AS WELL AS IN INSERTION
		
			DECLARE @V_ERROR_COUNT                            INT                           
			SET @V_ERROR_COUNT = 0 
			DECLARE @V_ERROR_LOCATION                         VARCHAR(100)
			DECLARE @V_LOCATION								  VARCHAR(100)
			DECLARE @V_CODE_ID_R                              INT    				-- value returned from codes procedure	
			DECLARE @V_INS_UPD_FLAG                           VARCHAR(1) 
			DECLARE @V_SQL_MULTI_CODE                         VARCHAR(2000) 		-- USED FOR SELECT QUERY BUILD	
			DECLARE @V_SQL_MULTI_CODE_VAL                     VARCHAR(100) 		-- USED TO CAPTURE CURSOR VALUE	
			DECLARE @V_CODE_ID_M_R                            VARCHAR(300) 		-- USED TO STORE THE MULTI CODE VALUES
		
			--- STATES VARIABLES	
			DECLARE @V_SQL_STATES                             NVARCHAR(2000) 		-- USED FOR SELECT QUERY BUILD FOR STATE FIELD CHECKING	
			DECLARE @V_STATE_ROW_ID                           VARCHAR(300) 		-- USED TO CAPTURE CURSOR VALUE	
			DECLARE @V_SQL_STATES_VAL                         VARCHAR(100) 		-- USED TO CAPTURE MULTI CURSOR VALUE	
			DECLARE @V_STATE_ROW_ID_M_R                       VARCHAR(300) 		-- USED TO STORE THE MULTI CODE VALUES
		
			-- ENTITY FIELD VARIABLES	
			DECLARE @V_ENTITY_ID                              VARCHAR(300) 		-- capture single entity id returned for the last name and abbrv in case of entity fields	
			DECLARE @V_SQL_ENTITY                             NVARCHAR(2000) 		-- USED FOR SELECT QUERY BUILD FOR ENTITY FIELD	
			DECLARE @V_SQL_ENTITY_VAL                         VARCHAR(100) 		-- USED TO CAPTURE MULTI CURSOR VALUE	
			DECLARE @V_SQL_ENTITY_C                           NVARCHAR(2000) 		-- USED TO MAKE A SELECT QUERY WITH IN MULTI VALUE CURSOR	
			DECLARE @V_ENTITY_ID_M_R                          VARCHAR(300) 		-- USED TO STORE THE MULTI CODE VALUES	
			DECLARE @V_EROLE_FLAG                             INT 		-- TEXT FIELD VARIABLES	
			DECLARE @V_CHK_TXT_CODE                           VARCHAR(100) 		-- USED TO CHECK THAT STRING IS HAVING - OR NOT	
			DECLARE @V_TXT_CODE                               VARCHAR(100) 		-- USED TO CAPTURE THE SPLITTED STRING HAVING CODE
			DECLARE @V_TXT_DESC                               VARCHAR(4000) 		-- USED TO CAPTURE THE SPLITTED STRING HAVING DESCRIPTION	
			DECLARE @V_TXT_CODE_R                             INT 		-- USED TO CAPTURE THE CODE ID RETURNED FROM TEXT FIELD VALUE IF HAVING ANY CODE	
			DECLARE @V_SQL_TXT_CODE                           NVARCHAR(2000) 		-- USED FOR SELECT QUERY BUILD FOR ENTITY FIELD	
			DECLARE @V_SQL_TXT_CODE_VAL                       VARCHAR(100) 		-- USED TO CAPTURE MULTI CURSOR VALUE
			--V_SQL_TXT_CODE_C VARCHAR2(2000); -- USED TO MAKE A SELECT QUERY WITH IN MULTI VALUE CURSOR
			--V_TXT_CODE_M_R CLOB; -- USED TO STORE THE MULTI CODE VALUES
		
			DECLARE @V_TXT_CODE_CODE_DESC_R                   VARCHAR(8000)		-- USED TO STORE CODE AND DESC VALUES RETURNED DURING MULTI VALUE	
			DECLARE @V_SQL_SYS_TAB_NAME                       NVARCHAR(500) 		-- FOR MAKING QUERY	
			DECLARE @V_SQL_SYS_TAB_NAME_V                     VARCHAR(200) 		-- FOR COLLECT VALUE OF SYSTEM TABLE NAME
		
			-- BELOW VARIABLES ARE USED FOR RM DB TABLES
			--V_SQL_CLAIMANT VARCHAR2(400);	
			DECLARE @V_SQL_RM_SUPP                            NVARCHAR(400) 		-- USED FOR RM SUPP TABLES QUERY CHECKING DATA EXISTS IN RM DB OR NOT	
			DECLARE @V_TAB_PK_ID                              INT 		-- USED TO STORE COLUMN VALUE OF PRIMARY KEY OF SUPP TABLE FOR DYNAMIC PURPOSE	
			DECLARE @V_TAB_PK_COL_NAME                        VARCHAR(100) 		-- USED TO STORE PRIMARY KEY COLUMN NAME OF SUPP TABLE FOR DYNAMIC PURPOSE	
			DECLARE @V_TAB_PK_COL_VAL                         INT 		-- USED TO STORE VALUE COMING FROM PARAMETER ASSIGNING THE PRIMARY VALUE TO IT AND FETCHING DATA FROM SUPP TABLES	
			DECLARE @V_INS_UPD_SUPP_FLAG                      VARCHAR(1) 		-- SUPP MULTIVALUE FLAG CHECK -- HAVING DATA OR NOT	
			DECLARE @V_ERROR_MSG                              VARCHAR(200)
			DECLARE @Rcnt_l_cursor                            INT 
			DECLARE @iPos                             	      VARCHAR(200)
			DECLARE @vReqColumns                              VARCHAR(2000)
			DECLARE @DDS_MODULE_NAME                          VARCHAR(200)
			DECLARE @Count_C1								  VARCHAR(30)
			DECLARE @Count_C2								  VARCHAR(30)
					
			/*v_MODULE_NAME DDS_ERROR_LOG.MODULE_NAME%type;
			v_ERROR_PROC_NAME DDS_ERROR_LOG.ERROR_PROC_NAME%type;
			v_ERROR_COLUMN DDS_ERROR_LOG.ERROR_COLUMNS%type;
			v_ERROR_TABLE_TO_CHECK DDS_ERROR_LOG.ERROR_TABLE_TO_CHECK%type;
			v_ERR_LOG_ROW_ID DDS_ERROR_LOG.ERR_LOG_ROW_ID%type;
			v_ERROR_DESC DDS_ERROR_LOG.ERROR_DESC%type;
			V_ERROR_MSG DDS_ERR_MESSAGES.ERR_MESSAGE%type;
			*/
		
			DECLARE @v_commit_flag                            INT 
		
			--IF @P_DB_NAME IS NOT NULL 
			--	BEGIN 
			--		SET @V_DB_NAME = '[' +  @P_DB_NAME  + '].[dbo].'
			--	END
	   
			IF @P_STAGE = 'V' 
				BEGIN 
					-- IF VALIDATION FLAG V IS COMING
					-- POPULATING THE DATA INTO TEMP TABLE AND UPDATE IT LATER OR AFTER FETCHING THE VALUE
				
					SET @V_ERROR_LOCATION = 0;
					--PRINT 'REACHED              -' + @V_ERROR_LOCATION
				
				
					INSERT INTO DDS_SUPPLEMENTAL_RUNTIME_DATA   
													(JOBID , DA_ROW_ID, CLAIMANT_EID, EVENT_ID, CLAIM_ID, EMPLOYEE_EID, UNIT_ID, ENTITY_ID, 
													DEFENDANT_ROW_ID, PI_ROW_ID, PI_PROC_ROW_ID, PATIENT_ID, TRANS_ID, PLAN_ID, MODULE_NAME)  
					 VALUES 						( @P_JOBID, @P_DA_ROW_ID, @P_CLAIMANT_EID, @P_EVENT_ID, @P_CLAIM_ID, @P_EMPLOYEE_EID, @P_UNIT_ID, @P_ENTITY_ID, 
													@P_DEFENDANT_ROW_ID, @P_PI_ROW_ID, @P_PI_PROC_ROW_ID, @P_PATIENT_ID, @P_TRANS_ID, @P_PLAN_ID, @P_MODULE_NAME)  
					-- IMPLICIT_TRANSACTIONS is set to OFF
				END
			SET @V_ERROR_LOCATION = 1;
			--PRINT 'REACHED              -' + @V_ERROR_LOCATION
			-- CHECKING INSERT OR UPDATE
			SET @DDS_MODULE_NAME = 'DDS_' + @P_MODULE_NAME;

			SET @V_SQL = N'SELECT @result = COUNT (*) from DDS_' + @P_MODULE_NAME + '_USR_SUPP_MAP ' + 
			                  'WHERE CONFIG_ID = @CONFIG_ID_P AND USER_ID = @USER_ID_P AND MAP_FLAG = 1 and MAPPED_FIELD IS NOT NULL';
			SET @ParmDefinition = N'@result NVARCHAR(30) OUTPUT,
									@CONFIG_ID_P INT,
									@USER_ID_P INT'
			EXECUTE sp_executesql @V_SQL, @ParmDefinition,
			@CONFIG_ID_P = @P_CONFIG_ID,
			@USER_ID_P= @P_USER_ID,								
			@result = @Count_C1 OUTPUT;

			SET @V_ERROR_LOCATION = 2;
			--PRINT 'REACHED              -' + @V_ERROR_LOCATION
			SET @Count_C1 = CAST(@Count_C1 as int);
			--PRINT 'ROWS FETCHED=' 
			--PRINT @Count_C1
		
			
		
			SET @V_SQL='DECLARE l_cursor_1 CURSOR FOR SELECT FIELD_NUM, USER_FIELD_NAME, MAP_FLAG, FIELD_TYPE, MAPPED_TABLE,MAPPED_FIELD, NULL_FLAG, VALIDATE_FLAG, CODE_TABLE_ID from DDS_';
		    SET @V_SQL= @V_SQL+ @P_MODULE_NAME + '_USR_SUPP_MAP WHERE CONFIG_ID = @CONFIG_ID_P AND USER_ID = @USER_ID_P AND MAP_FLAG = 1 and MAPPED_FIELD IS NOT NULL';
		    --PRINT @V_SQL;                           
            EXEC sp_Executesql @V_SQL,
            N'@CONFIG_ID_P INT,
            @USER_ID_P INT',
            @CONFIG_ID_P = @P_CONFIG_ID,
            @USER_ID_P= @P_USER_ID;
            --PRINT 'P_MODULE_NAME=' + @P_MODULE_NAME + '_USR_SUPP_MAP'
            --PRINT 'P_CONFIG_ID=' 
            --PRINT @P_CONFIG_ID
            --PRINT 'P_USER_ID=' 
            --PRINT @P_USER_ID
            --PRINT 'neha'	
		    OPEN l_cursor_1
		    FETCH NEXT FROM l_cursor_1 
            INTO @V_FIELD_NUM, @V_USER_FIELD_NAME, @V_MAP_FLAG, @V_FIELD_TYPE,	@V_MAPPED_TABLE,@V_MAPPED_FIELD,@V_NULL_FLAG,@V_VALIDATE_FLAG , @V_CODE_TABLE_ID;
            --PRINT '@V_USER_FIELD_NAME=' 
            --PRINT @V_USER_FIELD_NAME
            
            SET @V_ERROR_LOCATION = 3;
            --PRINT 'REACHED              -' + @V_ERROR_LOCATION
            WHILE @Count_C1>0  -- --LOOP
				BEGIN
					BEGIN TRY
						SET @V_ERROR_LOCATION = 4;
						--PRINT 'REACHED              -' + @V_ERROR_LOCATION
						SET @V_SQL = 'SELECT @FIELD_TYPE_P=FIELD_TYPE,@FIELD_ID_P=FIELD_ID,@CODE_FILE_ID_P= CODE_FILE_ID FROM ' 
                            + @P_DB_NAME + 'SUPP_DICTIONARY WHERE DELETE_FLAG = 0 and SUPP_TABLE_NAME = @MAPPED_TABLE_P AND SYS_FIELD_NAME = @MAPPED_FIELD_P';
						SET @V_ERROR_LOCATION = 5;
						--PRINT 'REACHED              -' + @V_ERROR_LOCATION
						--PRINT @V_SQL;
						--PRINT 'V_MAPPED_TABLE=' + @V_MAPPED_TABLE
						--PRINT 'V_MAPPED_FIELD=' + @V_MAPPED_FIELD	                             
						EXEC sp_Executesql @V_SQL,  
							   N'@MAPPED_TABLE_P VARCHAR(50),
								 @MAPPED_FIELD_P VARCHAR(50),
								 @FIELD_TYPE_P INT OUTPUT,
								 @FIELD_ID_P INT OUTPUT, 
								 @CODE_FILE_ID_P INT OUTPUT',
								 @MAPPED_TABLE_P = @V_MAPPED_TABLE,
								 @MAPPED_FIELD_P = @V_MAPPED_FIELD,
								 @FIELD_TYPE_P = @V_FIELD_TYPE_C OUTPUT,
								 @FIELD_ID_P = @V_FIELD_ID_C OUTPUT,
								 @CODE_FILE_ID_P = @V_CODE_FILE_ID_C OUTPUT;
					
						SET @V_ERROR_LOCATION = 6;
						--PRINT 'REACHED              -' + @V_ERROR_LOCATION
						--MultiCodes
						IF (@V_FIELD_TYPE_C = 14)
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'CODE_FIELD'
								SET @V_MULTI_VAL = 1 --IF 1 THEN IT IS True
							END
						ELSE IF (@V_FIELD_TYPE_C = 15)    --'MultiStates
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'STATE_FIELD'
								SET @V_MULTI_VAL = 1 --IF 1 THEN IT IS True
							END
						ELSE IF (@V_FIELD_TYPE_C = 16)   --MultiEnties
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'ENTITY_FIELD'
								SET @V_MULTI_VAL = 1 --IF 1 THEN IT IS True
							END
						ELSE IF (@V_FIELD_TYPE_C = 6)      --'code
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'CODE_FIELD'
								SET @V_MULTI_VAL = 0 --IF 1 THEN IT IS True
							END
						ELSE IF (@V_FIELD_TYPE_C = 8)     -- 'entity
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'ENTITY_FIELD'
								SET @V_MULTI_VAL = 0 --IF 1 THEN IT IS True                            
							END
						ELSE IF (@V_FIELD_TYPE_C = 9)      --'state
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'STATE_FIELD'
								SET @V_MULTI_VAL = 0 --IF 1 THEN IT IS True                  
							END
						ELSE IF (@V_FIELD_TYPE_C = 5)       --   mits 13694
							BEGIN
								SET @V_FIELD_TYPE_NAME = 'TXTCODE_FIELD'
								SET @V_MULTI_VAL = 1 --IF 1 THEN IT IS True
							END
						ELSE
							BEGIN
								SET @V_FIELD_TYPE_NAME = '0'                
								SET @V_MULTI_VAL = 0 --IF 1 THEN IT IS True                  
							END
						--PRINT '@V_FIELD_TYPE_C=' +  cast (isnull(@V_FIELD_TYPE_C,0) as varchar(50))
						--PRINT '@V_MULTI_VAL=' +  cast (isnull(@V_MULTI_VAL,0) as varchar(50))
						-- FETCH SYSTEM TABLE NAME FROM RM DB FOR 
					
						BEGIN TRY
							SET @V_ERROR_LOCATION = 7;
							--PRINT 'REACHED              -' + @V_ERROR_LOCATION
							
							-- Kapil added on 16-Feb-2016-- start
							SET @V_SQL_SYS_TAB_NAME = N'SELECT @result = SYSTEM_TABLE_NAME FROM ' +  @P_DB_NAME + 'GLOSSARY WHERE TABLE_ID=@V_CODE_FILE_ID_P';
							SET @ParmDefinition = N'@result VARCHAR(MAX) OUTPUT,
													@V_CODE_FILE_ID_P INT'
							EXECUTE sp_executesql @V_SQL_SYS_TAB_NAME, @ParmDefinition,
							@V_CODE_FILE_ID_P = @V_CODE_FILE_ID_C,
							@result = @V_SQL_SYS_TAB_NAME_V OUTPUT;
							-- Kapil added on 16-Feb-2016-- end
							--PRINT @V_CODE_FILE_ID_C
							--PRINT @V_SQL_SYS_TAB_NAME_V
							SET @V_ERROR_LOCATION = 8;						
							--PRINT 'REACHED              -' + @V_ERROR_LOCATION
							IF (@V_SQL_SYS_TAB_NAME_V = NULL)
								BEGIN							
								SET @V_ERROR_MSG = 'No data found in ' + @V_USER_FIELD_NAME;
								EXEC DDS_ERROR_LOG_CAPTURE  
												@P_JOBID, 
												@p_DA_ROW_ID, 
												@p_MODULE_NAME,
												@V_ERROR_LOCATION, 
												@V_ERROR_LOCATION,
												'DDS_SUPPLEMENT',
												@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
												@V_USER_FIELD_NAME, 
												@DDS_MODULE_NAME,
												@P_KEYCOLUMN,
												@P_KEYVALUE,
												1;
								END
						END TRY
						BEGIN CATCH							
							SET @V_ERROR_MSG = ERROR_MESSAGE ();															
							EXEC DDS_ERROR_LOG_CAPTURE  
											@P_JOBID, 
											@p_DA_ROW_ID, 
											@p_MODULE_NAME,
											@V_ERROR_LOCATION, 
											@V_ERROR_LOCATION,
											'DDS_SUPPLEMENT',
											@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
											@V_USER_FIELD_NAME, 
											@DDS_MODULE_NAME,
											@P_KEYCOLUMN,
											@P_KEYVALUE,
											0;
						END CATCH
						SET @V_ERROR_LOCATION = 9;						 
						--PRINT 'REACHED              -' + @V_ERROR_LOCATION
						-- VALIDATION FLAG / STAGE WORK COMPLETED / START HERE
						IF (@P_STAGE = 'V') 
							BEGIN
								--IF V_CODE_TABLE_ID > 0 THEN -- IF CODE TABLE ID IS GREATER THAN 0 THEN ONLY START VALIDATION -- START
								SET @V_ERROR_LOCATION = 10;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								IF (@V_VALIDATE_FLAG = 1) -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 1 THEN NEED TO DO VALIDATION
                                BEGIN
									SET @V_ERROR_LOCATION = 11;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									--IF V_NULL_FLAG = 0 THEN --- NULL FIELD VALIDATION FOR A RECORD START, IF 0 THEN ALLOW NULL IS ALLOWED WHILE 1 THEN NOT ALLOWED
                                    BEGIN TRY
										SET @V_ERROR_LOCATION = 12;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										--PRINT '@V_USER_FIELD_NAME=' + @V_USER_FIELD_NAME;
										--Fetch User_fields from respective table of modules
										SET @V_SQL_VALUE = N'SELECT @result = '+ @V_USER_FIELD_NAME +' FROM DDS_'+ @P_MODULE_NAME + ' WHERE DA_ROW_ID = @DA_ROW_ID_P AND JOBID = @JOBID_P';
										SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																@DA_ROW_ID_P INT,
																@JOBID_P INT'
										EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
										@DA_ROW_ID_P = @P_DA_ROW_ID,
										@JOBID_P = @P_JOBID,
										@result = @V_USER_FIELD_NAME_VALUE OUTPUT;
										IF (@V_USER_FIELD_NAME_VALUE IS NULL AND @V_NULL_FLAG = 0)
											BEGIN												 
												SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1
												SET @V_ERROR_MSG = 'No data found in ' + @V_USER_FIELD_NAME
												EXEC DDS_ERROR_LOG_CAPTURE  
															@P_JOBID, 
															@p_DA_ROW_ID, 
															@p_MODULE_NAME,
															@V_ERROR_LOCATION, 
															@V_ERROR_LOCATION,
															'DDS_SUPPLEMENT',
															@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
															@V_USER_FIELD_NAME, 
															@DDS_MODULE_NAME,
															@P_KEYCOLUMN,
															@P_KEYVALUE,
															1;
											END
										SET @V_ERROR_LOCATION = 13;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION										
									END TRY
									BEGIN CATCH									
										SET @V_ERROR_MSG = ERROR_MESSAGE ();
										EXEC DDS_ERROR_LOG_CAPTURE  
													@P_JOBID, 
													@p_DA_ROW_ID, 
													@p_MODULE_NAME,
													@V_ERROR_LOCATION, 
													@V_ERROR_LOCATION,
													'DDS_SUPPLEMENT',
													@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
													@V_USER_FIELD_NAME, 
													@DDS_MODULE_NAME,
													@P_KEYCOLUMN,
													@P_KEYVALUE,
													0;
									END CATCH
                                
                                
									SET @V_ERROR_LOCATION = 14;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                  
									SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '= @V_USER_FIELD_NAME_VALUE_P  WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';						
									SET @ParmDefinition = N'@DA_ROW_ID_P INT,
														@JOBID_P INT,
														@MODULE_NAME_P VARCHAR(50),
														@V_USER_FIELD_NAME_VALUE_P VARCHAR(2000)'
									EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
														@DA_ROW_ID_P = @P_DA_ROW_ID,
														@JOBID_P = @P_JOBID,
														@MODULE_NAME_P = @P_MODULE_NAME,
														@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
                                
									--END IF; --- NULL FIELD VALIDATION FOR A RECORD END
                               
									SET @V_ERROR_LOCATION = 15;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									IF  (@V_FIELD_TYPE_NAME = 'CODE_FIELD' AND @V_USER_FIELD_NAME_VALUE IS NOT NULL )
										BEGIN
										-- HERE WE ARE GOING TO CREATE CODES WHEN START
										SET @V_ERROR_LOCATION = 16;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										IF (@V_CODE_TABLE_ID > 0 And @V_MULTI_VAL <> 1) -- CODE VALIDATION -- AND CODE CREATION FOR SINGLE VALUE
											BEGIN
												SET @V_ERROR_LOCATION = 17;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--PRINT @P_JOBID 
												--PRINT @V_USER_FIELD_NAME_VALUE -- Short Code
												--PRINT @V_SQL_SYS_TAB_NAME_V -- SYstem Table Name to Check
												--PRINT @P_CODE_CREATION_FLAG -- It is used to check allow creation of code flag is set by user or not
												--PRINT 1 -- It is used to check are we able to create code for that system table name or not
												--PRINT @P_DB_NAME -- It is used to fetch error msg and append into the error msg and update it again
												--PRINT @P_LOB -- LOB GC, WC ( It Will be numeric)
												--PRINT @P_DA_ROW_ID -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @p_MODULE_NAME--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @V_ERROR_LOCATION -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT 'DDS_SUPPLEMENT' -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @P_KEYCOLUMN -- It is used to fetch error msg and append into the error msg and update it again
												--PRINT @V_USER_FIELD_NAME  -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @DDS_MODULE_NAME -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @P_KEYVALUE -- Used for ERROR_LOG_CAPTURE Procedure
												--PRINT @V_CODE_ID_R
												EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
																		   @V_USER_FIELD_NAME_VALUE, -- Short Code
																		   @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
																		   @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
																		   --1, -- It is used to check are we able to create code for that system table name or not
																		   @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
																		   @P_LOB, -- LOB GC, WC ( It Will be numeric)
																		   @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
																		   @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
																		   @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
																		   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
																		   @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
																		   @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
																		   @DDS_MODULE_NAME, -- Used for ERROR_LOG_CAPTURE Procedure
																		   @P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
																		   @V_CODE_ID_R OUTPUT;
												SET @V_ERROR_LOCATION = 18;  
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--PRINT '@V_CODE_ID_R='
												--PRINT @V_CODE_ID_R
												IF (@V_CODE_ID_R = 0 OR @V_CODE_ID_R IS NULL)
													BEGIN
														SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 ;
														SET @V_ERROR_LOCATION = 19;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														SET @V_ERROR_MSG = 'Code does not exists in RM DB.' + @V_USER_FIELD_NAME + ' - ' + @V_USER_FIELD_NAME_VALUE;
														EXEC DDS_ERROR_LOG_CAPTURE  
																	@P_JOBID, 
																	@p_DA_ROW_ID, 
																	@p_MODULE_NAME,
																	@V_ERROR_LOCATION, 
																	@V_ERROR_LOCATION,
																	'DDS_SUPPLEMENT',
																	@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																	@V_USER_FIELD_NAME, 
																	@DDS_MODULE_NAME,
																	@P_KEYCOLUMN,
																	@P_KEYVALUE,
																	1;

													END
												ELSE -- UPDATE CODE VALUE IN TEMP TABLE
													BEGIN
														SET @V_ERROR_LOCATION = 20;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														--Updating the temp table for codes
														SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '= @V_CODE_ID_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
														SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																				@JOBID_P INT,
																				@MODULE_NAME_P VARCHAR(50),
																				@V_CODE_ID_R_P INT'
														--PRINT @V_SQL_VALUE
														EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																				@DA_ROW_ID_P = @P_DA_ROW_ID,
																				@JOBID_P = @P_JOBID,
																				@MODULE_NAME_P = @P_MODULE_NAME,
																				@V_CODE_ID_R_P = @V_CODE_ID_R;
														SET @V_ERROR_LOCATION = 21;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													END                         
											END                           
										SET @V_ERROR_LOCATION = 22;  
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										--PRINT @V_CODE_TABLE_ID
										--PRINT @V_MULTI_VAL
										
										IF (@V_CODE_TABLE_ID > 0 And @V_MULTI_VAL = 1)-- CODE VALIDATION -- AND CODE CREATION FOR MULTI VALUE
											BEGIN
												SET @V_ERROR_LOCATION = 23;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											
												SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
												WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
													BEGIN
														SET @V_ERROR_LOCATION = 24;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														SET @iPos = CHARINDEX('|',@vReqColumns,1)
														SET @V_SQL_MULTI_CODE_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
														SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
													
														SET @V_ERROR_LOCATION = 25;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
	                                                                                   
														--PRINT @P_JOBID 
														--PRINT @V_USER_FIELD_NAME_VALUE -- Short Code
														--PRINT @V_SQL_SYS_TAB_NAME_V -- SYstem Table Name to Check
														--PRINT @P_CODE_CREATION_FLAG -- It is used to check allow creation of code flag is set by user or not
														--PRINT 1 -- It is used to check are we able to create code for that system table name or not
														--PRINT @P_DB_NAME -- It is used to fetch error msg and append into the error msg and update it again
														--PRINT @P_LOB -- LOB GC, WC ( It Will be numeric)
														--PRINT @P_DA_ROW_ID -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @p_MODULE_NAME--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @V_ERROR_LOCATION -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT 'DDS_SUPPLEMENT' -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @P_KEYCOLUMN -- It is used to fetch error msg and append into the error msg and update it again
														--PRINT @V_USER_FIELD_NAME  -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @DDS_MODULE_NAME -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @P_KEYVALUE -- Used for ERROR_LOG_CAPTURE Procedure
														--PRINT @V_CODE_ID_R
														EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
																	   @V_SQL_MULTI_CODE_VAL, -- Short Code
																	   @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
																	   @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
																	   --1, -- It is used to check are we able to create code for that system table name or not
																	   @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
																	   @P_LOB, -- LOB GC, WC ( It Will be numeric)
																	   @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
																	   @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
																	   @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
																	   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
																	   @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
																	   @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
																	   @DDS_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
																	   @P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
																	   @V_CODE_ID_R OUTPUT;
														 --PRINT @V_CODE_ID_R			   
														 SET @V_ERROR_LOCATION = 26;
														 --PRINT 'REACHED              -' + @V_ERROR_LOCATION
	                                                              
														IF (@V_CODE_ID_R = 0 OR @V_CODE_ID_R IS NULL)
															BEGIN
																--PRINT 'ALOK1'
																SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 																
															END      
	                                                        
														IF (@V_CODE_ID_M_R IS NOT NULL AND @V_CODE_ID_M_R <> '0') 
															BEGIN
																--PRINT 'ALOK2'																
																SET @V_CODE_ID_M_R = @V_CODE_ID_M_R + '|' + CAST(ISNULL(@V_CODE_ID_R,0) AS VARCHAR(100))
															END
														ELSE 
															BEGIN
																--PRINT 'ALOK3'
																SET @V_CODE_ID_M_R = CAST(ISNULL(@V_CODE_ID_R,0) AS VARCHAR(100))
															END      
	                                                     
														 IF (@V_CODE_ID_M_R = '0')
															BEGIN
																SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1
															END
	                                                     
												END -- END LOOP 
											
												SET @V_ERROR_LOCATION = 27;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
	                                          
												--UPDATING MULTICODES VALUE IN TEMP TABLE
												SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '= @V_CODE_ID_M_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
												SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																		@JOBID_P INT,
																		@MODULE_NAME_P VARCHAR(50),
																		@V_CODE_ID_M_R_P VARCHAR(100)'
												EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																		@DA_ROW_ID_P = @P_DA_ROW_ID,
																		@JOBID_P = @P_JOBID,
																		@MODULE_NAME_P = @P_MODULE_NAME,
																		@V_CODE_ID_M_R_P = @V_CODE_ID_M_R;
												SET @V_ERROR_LOCATION = 28; 
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											END  --CODE VALIDATION COMPLETE HERE FOR MULTI VALUE
	                                 
										ELSE IF (@V_FIELD_TYPE_NAME = 'CODE_FIELD' AND @V_NULL_FLAG = 0 AND @V_USER_FIELD_NAME_VALUE IS NULL)
											BEGIN
											SET @V_ERROR_LOCATION = 29;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_ERROR_MSG = 'Validation failed as allow null is not checked and no value is provided in ' +  @V_USER_FIELD_NAME;

											EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
	                                           
											SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 ;      
										END -- WE ARE GOING TO CREATE CODES WHEN END
									END 
									-- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD END
								END	--END IF;   -- IF CODE TABLE ID IS GREATER THAN 0 THEN ONLY START VALIDATION -- END
                         
								IF (@V_VALIDATE_FLAG = '0')  -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 0 THEN NO NEED TO DO VALIDATION
									BEGIN
									SET @V_ERROR_LOCATION = 30;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									BEGIN TRY
										SET @V_SQL_VALUE = N'SELECT @result = '+ @V_USER_FIELD_NAME +' FROM DDS_'+ @P_MODULE_NAME + ' WHERE DA_ROW_ID = @DA_ROW_ID_P AND JOBID = @JOBID_P';
										SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																@DA_ROW_ID_P INT,
																@JOBID_P INT'
										EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
										@DA_ROW_ID_P = @P_DA_ROW_ID,
										@JOBID_P = @P_JOBID,
										@result = @V_USER_FIELD_NAME_VALUE OUTPUT;				
										
										SET @V_ERROR_LOCATION = 31;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									END TRY
									BEGIN CATCH
										SET @V_ERROR_MSG= ERROR_MESSAGE(); 
										EXEC DDS_ERROR_LOG_CAPTURE  
															@P_JOBID, 
															@p_DA_ROW_ID, 
															@p_MODULE_NAME,
															@V_ERROR_LOCATION, 
															@V_ERROR_LOCATION,
															'DDS_SUPPLEMENT',
															@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
															@V_USER_FIELD_NAME, 
															@DDS_MODULE_NAME,
															@P_KEYCOLUMN,
															@P_KEYVALUE,
															0;
									END CATCH                                           

									SET @V_ERROR_LOCATION = 32;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '= @V_USER_FIELD_NAME_VALUE_P  WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';						
									SET @ParmDefinition = N'@DA_ROW_ID_P INT,
															@JOBID_P INT,
															@MODULE_NAME_P VARCHAR(50),
															@V_USER_FIELD_NAME_VALUE_P VARCHAR(50)'
									EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
															@DA_ROW_ID_P = @P_DA_ROW_ID,
															@JOBID_P = @P_JOBID,
															@MODULE_NAME_P = @P_MODULE_NAME,
															@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
									SET @V_ERROR_LOCATION = 33;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									IF  (@V_FIELD_TYPE_NAME = 'CODE_FIELD')
										BEGIN
										-- HERE WE ARE GOING TO CREATE CODES WHEN START
											SET @V_ERROR_LOCATION = 34;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									
											IF (@V_CODE_TABLE_ID > 0 And @V_MULTI_VAL <> 1) -- CODE VALIDATION -- AND CODE CREATION FOR SINGLE VALUE
												BEGIN
													SET @V_ERROR_LOCATION = 35;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												
													EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
                                                                   @V_USER_FIELD_NAME_VALUE, -- Short Code
                                                                   @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                   @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                   --1, -- It is used to check are we able to create code for that system table name or not
                                                                   @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   @P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                   @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @DDS_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   @V_CODE_ID_R OUTPUT;
                                                     SET @V_ERROR_LOCATION = 36;
                                                     --PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                                                   
												
													SET @V_ERROR_LOCATION = 37;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '= ISNULL(@V_CODE_ID_R_P,0) WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
													SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																			@JOBID_P INT,
																			@MODULE_NAME_P VARCHAR(50),
																			@V_CODE_ID_R_P INT'
													EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																			@DA_ROW_ID_P = @P_DA_ROW_ID,
																			@JOBID_P = @P_JOBID,
																			@MODULE_NAME_P = @P_MODULE_NAME,
																			@V_CODE_ID_R_P = @V_CODE_ID_R;
													SET @V_ERROR_LOCATION = 38;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										END  --CODE VALIDATION COMPLETE HERE FOR SINGLE VALUE
                                        
											SET @V_ERROR_LOCATION = 39;									
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											IF (@V_CODE_TABLE_ID > 0 And @V_MULTI_VAL = 1) -- CODE VALIDATION -- AND CODE CREATION FOR MULTI VALUE
										BEGIN
											SET @V_ERROR_LOCATION = 40;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
											WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
												BEGIN
													SET @V_ERROR_LOCATION = 41;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													SET @iPos = CHARINDEX('|',@vReqColumns,1)
													SET @V_SQL_MULTI_CODE_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
													SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))												 
													SET @V_ERROR_LOCATION = 42;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF (@V_SQL_MULTI_CODE_VAL IS NOT NULL)												
														BEGIN
															SET @V_ERROR_LOCATION = 43;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
																							   @V_SQL_MULTI_CODE_VAL, -- Short Code
																							   @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
																							   @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
																							   --1, -- It is used to check are we able to create code for that system table name or not
																							   @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
																							   @P_LOB, -- LOB GC, WC ( It Will be numeric)
																							   @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
																							   @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
																							   @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
																							   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
																							   @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
																							   @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
																							   @DDS_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
																							   @P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
																							   @V_CODE_ID_R OUTPUT;
															SET @V_ERROR_LOCATION = 44;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														END                           
													SET @V_ERROR_LOCATION = 45;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF ((@V_CODE_ID_R = 0 OR @V_CODE_ID_R IS NULL )AND @V_SQL_MULTI_CODE_VAL IS NOT NULL)
														BEGIN
															SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1
															SET @V_ERROR_LOCATION = 46;  
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															-- Commenting the below code as error log is getting captured in code procedure
														END      
													
														SET @V_ERROR_LOCATION = 47;   
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													
														IF (@V_CODE_ID_M_R IS NOT NULL)
															BEGIN
																SET @V_CODE_ID_M_R = @V_CODE_ID_M_R + '|' + CAST(ISNULL(@V_CODE_ID_R,0) AS VARCHAR(100))
															END
														ELSE 
															BEGIN
																SET @V_CODE_ID_M_R = CAST(ISNULL(@V_CODE_ID_R,0) AS VARCHAR(100))  
															END 
												 
												END -- end loop                                           
                                        
										SET @V_ERROR_LOCATION = 48;   
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										--UPDATING MULTICODES VALUE IN TEMP TABLE
										SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + '=  @V_CODE_ID_M_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
										SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																@JOBID_P INT,
																@MODULE_NAME_P VARCHAR(50)
																@V_CODE_ID_R_P VARCHAR(100)'
										EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																@DA_ROW_ID_P = @P_DA_ROW_ID,
																@JOBID_P = @P_JOBID,
																@MODULE_NAME_P = @P_MODULE_NAME,
																@V_CODE_ID_M_R_P = @V_CODE_ID_M_R;
										SET @V_ERROR_LOCATION = 49;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @V_CODE_ID_M_R=NULL;-- KAPIL - 22-FEB-2016
                                    END --CODE VALIDATION COMPLETE HERE  FOR MULTI VALUE
										END -- WE ARE GOING TO CREATE CODES WHEN END
								END -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 0 THEN NO NEED TO DO VALIDATION
                         
                        
                        
								SET @V_ERROR_LOCATION = 50;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
						
								--PRINT '@V_FIELD_TYPE_NAME =' + @V_FIELD_TYPE_NAME
								 -- STATE CODE VALIDATION START HERE
								IF  (@V_FIELD_TYPE_NAME = 'STATE_FIELD')
									BEGIN
								SET @V_ERROR_LOCATION = 51;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								IF (@V_MULTI_VAL <> 1)  -- FOR SINGLE VALUE START HERE
									BEGIN
										SET @V_ERROR_LOCATION = 52;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										BEGIN TRY
											SET @V_ERROR_LOCATION = 53;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_SQL_STATES = N'SELECT @result = STATE_ROW_ID FROM ' + @P_DB_NAME + 'STATES WHERE STATE_ID = UPPER(@V_USER_FIELD_NAME_VALUE_P)';
											SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																	@V_USER_FIELD_NAME_VALUE_P VARCHAR(500)'					
											EXECUTE sp_executesql @V_SQL_STATES, @ParmDefinition,
																	@V_USER_FIELD_NAME_VALUE_P=@V_USER_FIELD_NAME_VALUE,
																	@result = @V_STATE_ROW_ID OUTPUT;
											SET @V_ERROR_LOCATION = 54;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION

											IF (@V_STATE_ROW_ID IS NULL)
												BEGIN
													SET @V_ERROR_LOCATION = 55;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF (@V_VALIDATE_FLAG = 1) -- STATE VALIDATION FLAG IS ON -- START HERE
														BEGIN
															SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 
														
															IF  (@V_USER_FIELD_NAME_VALUE IS NULL and @V_NULL_FLAG = 0)
																BEGIN
																	SET @V_ERROR_MSG = 'Validation failed as allow null is not checked and no value is provided in '+ @V_USER_FIELD_NAME;
																END
															ELSE IF (@V_USER_FIELD_NAME_VALUE IS NOT NULL)
																BEGIN
																	SET @V_ERROR_MSG = 'Validation failed as State value does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME;
																END
															SET @V_ERROR_LOCATION = 56;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																	 
															EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END
													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NOT NULL)
														BEGIN
															SET @V_ERROR_MSG = 'State value does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME;
															SET @V_ERROR_LOCATION = 57;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END
													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_NULL_FLAG = 0 AND @V_USER_FIELD_NAME_VALUE IS NULL)
														BEGIN
															SET @V_ERROR_MSG = 'Allow null is not checked. Please provide the value in ' + @V_USER_FIELD_NAME;
															SET @V_ERROR_LOCATION = 58;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END
													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_NULL_FLAG = 1 AND @V_USER_FIELD_NAME_VALUE IS NULL)         
														BEGIN
															SET @V_ERROR_LOCATION = 59;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															SET @V_STATE_ROW_ID = -1;        
														END 
														-- STATE VALIDATION FLAG IS ON -- END  HERE
												END
										END TRY
										BEGIN CATCH
											BEGIN
												SET @V_ERROR_MSG= ERROR_MESSAGE() 
												EXEC DDS_ERROR_LOG_CAPTURE  
																	@P_JOBID, 
																	@p_DA_ROW_ID, 
																	@p_MODULE_NAME,
																	@V_ERROR_LOCATION, 
																	@V_ERROR_LOCATION,
																	'DDS_SUPPLEMENT',
																	@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																	@V_USER_FIELD_NAME, 
																	@DDS_MODULE_NAME,
																	@P_KEYCOLUMN,
																	@P_KEYVALUE,
																	0;
												END											
											
										END CATCH
									
                                   -- UPDATING STATE ROW ID INTO THE TEMP TABLE 
                                    SET @V_ERROR_LOCATION = 60;
                                    --PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' =  @V_STATE_ROW_ID_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
									SET @ParmDefinition = N'@DA_ROW_ID_P INT,
															@JOBID_P INT,
															@MODULE_NAME_P VARCHAR(50),
															@V_STATE_ROW_ID_P INT'
									EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
															@DA_ROW_ID_P = @P_DA_ROW_ID,
															@JOBID_P = @P_JOBID,
															@MODULE_NAME_P = @P_MODULE_NAME,
															@V_STATE_ROW_ID_P = @V_STATE_ROW_ID;
									SET @V_ERROR_LOCATION = 61;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								END
				
								ELSE IF (@V_MULTI_VAL = 1) -- FOR MULTI VALUE START HERE
									BEGIN
										SET @V_ERROR_LOCATION = 62;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
										WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
									BEGIN
										SET @V_ERROR_LOCATION = 63;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @iPos = CHARINDEX('|',@vReqColumns,1)
										SET @V_SQL_STATES_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
										SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
										BEGIN TRY
											SET @V_ERROR_LOCATION = 64;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_SQL_STATES = N'SELECT @result = STATE_ROW_ID FROM ' + @P_DB_NAME + 'STATES WHERE STATE_ID = UPPER(@V_SQL_STATES_VAL_P) ';
											SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																	@V_SQL_STATES_VAL_P VARCHAR(500)'
											SET @V_ERROR_LOCATION = 65;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											--PRINT @V_SQL_STATES
											--PRINT '@V_SQL_STATES_VAL' + @V_SQL_STATES_VAL
																			
											EXECUTE sp_executesql @V_SQL_STATES, @ParmDefinition,
																	@V_SQL_STATES_VAL_P=@V_SQL_STATES_VAL,
																	@result = @V_STATE_ROW_ID OUTPUT;
											SET @V_ERROR_LOCATION = 66;						
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											IF (@V_STATE_ROW_ID IS NULL)
												BEGIN
													SET @V_ERROR_LOCATION = 67;						
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF (@V_VALIDATE_FLAG = 1) -- STATE VALIDATION FLAG IS ON -- START HERE
														BEGIN
															SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 
														
															IF  (@V_USER_FIELD_NAME_VALUE IS NULL and @V_NULL_FLAG = 0)
																BEGIN
																	SET @V_ERROR_MSG = 'Validation failed as allow null is not checked and no value is provided in ' + @V_USER_FIELD_NAME;
																END
															ELSE IF (@V_USER_FIELD_NAME_VALUE IS NOT NULL)
																BEGIN
																	SET @V_ERROR_MSG = 'Validation failed as validation flag is ON. State value does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME;
																END     
															SET @V_ERROR_LOCATION = 68;						
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														   
														   EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END

													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NOT NULL)
														BEGIN
															SET @V_ERROR_MSG = 'State value does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME
															SET @V_ERROR_LOCATION = 69;						
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END		 
													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_NULL_FLAG = 0 AND @V_USER_FIELD_NAME_VALUE IS NULL)
														BEGIN
															SET @V_ERROR_MSG = 'Allow null is not checked. Please provide the value in ' + @V_USER_FIELD_NAME;
															SET @V_ERROR_LOCATION = 70;						
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
														END
													ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_NULL_FLAG = 1 and @V_USER_FIELD_NAME_VALUE IS NULL)
														BEGIN
															SET @V_ERROR_LOCATION = 71;						
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															SET @V_STATE_ROW_ID = -1        
														END   -- STATE VALIDATION FLAG IS ON -- END  HERE
												END
										END TRY
										BEGIN CATCH
											BEGIN												
												SET @V_ERROR_MSG= ERROR_MESSAGE() 
												EXEC DDS_ERROR_LOG_CAPTURE  
																	@P_JOBID, 
																	@p_DA_ROW_ID, 
																	@p_MODULE_NAME,
																	@V_ERROR_LOCATION, 
																	@V_ERROR_LOCATION,
																	'DDS_SUPPLEMENT',
																	@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																	@V_USER_FIELD_NAME, 
																	@DDS_MODULE_NAME,
																	@P_KEYCOLUMN,
																	@P_KEYVALUE,
																	0;
											END
										END CATCH 
										SET @V_ERROR_LOCATION = 72;                                     
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION

										IF (@V_STATE_ROW_ID_M_R IS NOT NULL) 
											BEGIN
												SET @V_STATE_ROW_ID_M_R = @V_STATE_ROW_ID_M_R + '|' + CAST(ISNULL(@V_STATE_ROW_ID,0) AS VARCHAR(100))
											END
										ELSE 
											BEGIN
												SET @V_STATE_ROW_ID_M_R = CAST(ISNULL(@V_STATE_ROW_ID,-1) AS VARCHAR(100));  									
											END 
										SET @V_ERROR_LOCATION = 73;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                                     
								END -- END LOOP
										-- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
										SET @V_ERROR_LOCATION = 74;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' =  @V_STATE_ROW_ID_M_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
										SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																@JOBID_P INT,
																@MODULE_NAME_P VARCHAR(50),
																@V_STATE_ROW_ID_M_R_P VARCHAR(100)'
										EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																@DA_ROW_ID_P = @P_DA_ROW_ID,
																@JOBID_P = @P_JOBID,
																@MODULE_NAME_P = @P_MODULE_NAME,
																@V_STATE_ROW_ID_M_R_P = @V_STATE_ROW_ID_M_R;
										SET @V_ERROR_LOCATION = 75;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @V_STATE_ROW_ID_M_R=NULL;-- KAPIL - 22-FEB-2016
									END -- SINGLE AND MULTI VALUE STATES WORK END HERE                                    
							END
								-- STATE CODE VALIDATION END HERE
                       
								--ENTITY VALIDATION STARTS HERE
								IF (@V_FIELD_TYPE_NAME = 'ENTITY_FIELD')
                    BEGIN
						SET @V_ERROR_LOCATION = 76;     
						--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                         -- CHECK EROLE FLAG
                            --SELECT STR_PARM_VALUE INTO V_EROLE_FLAG from PARMS_NAME_VALUE where PARM_NAME ='USE_ENTITY_ROLE' ;
                            BEGIN TRY
								SET @V_ERROR_LOCATION = 77;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								SET @V_SQL_VALUE = N'SELECT @result = STR_PARM_VALUE FROM ' + @P_DB_NAME +'PARMS_NAME_VALUE  WHERE PARM_NAME = ''USE_ENTITY_ROLE''';
								SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT'													
								EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
														@result = @V_EROLE_FLAG OUTPUT;
								SET @V_ERROR_LOCATION = 78;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
							END TRY
							BEGIN CATCH							
								SET @V_ERROR_MSG= ERROR_MESSAGE() 
								EXEC DDS_ERROR_LOG_CAPTURE  
													@P_JOBID, 
													@p_DA_ROW_ID, 
													@p_MODULE_NAME,
													@V_ERROR_LOCATION, 
													@V_ERROR_LOCATION,
													'DDS_SUPPLEMENT',
													@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
													@V_USER_FIELD_NAME, 
													@DDS_MODULE_NAME,
													@P_KEYCOLUMN,
													@P_KEYVALUE,
													0;

							END CATCH
							SET @V_ERROR_LOCATION = 79;
							--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                            IF (@V_EROLE_FLAG <> 0) -- IF E ROLE FLAG IS ON THEN TABLE ID MUST BE 0
                                BEGIN
									SET @V_CODE_FILE_ID_C = 0 -- SETTING UP THE TABLE ID VALUE TO 0 IF EROLE IS ON
								END
                            
                         
                            IF (@V_MULTI_VAL <> 1) -- FOR SINGLE ENTITY FIELD VALUE START HERE
								BEGIN
								SET @V_ERROR_LOCATION = 80;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									IF (@V_USER_FIELD_NAME_VALUE IS NULL AND @V_NULL_FLAG = 0)  -- CHECKING ENTITY NAME IS NULL OR NOT NULL
										BEGIN
											SET @V_ERROR_LOCATION = 81;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											IF (@V_VALIDATE_FLAG = 1)  -- ENTITY VALIDATION FLAG IS ON IN CASE OF USER FIELD NOT PROVIDED VALUE-- START HERE
												BEGIN
													SET @V_ERROR_LOCATION = 82;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 ;												
													SET @V_ERROR_MSG = 'Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME;
                                           
													EXEC DDS_ERROR_LOG_CAPTURE  
														@P_JOBID, 
														@p_DA_ROW_ID, 
														@p_MODULE_NAME,
														@V_ERROR_LOCATION, 
														@V_ERROR_LOCATION,
														'DDS_SUPPLEMENT',
														@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
														@V_USER_FIELD_NAME, 
														@DDS_MODULE_NAME,
														@P_KEYCOLUMN,
														@P_KEYVALUE,
														1;
												END
      
											ELSE IF (@V_VALIDATE_FLAG <> 1)
                                                BEGIN
													SET @V_ERROR_LOCATION = 83;						
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													SET @V_ENTITY_ID = 0
												END
                                        END   -- ENTITY VALIDATION FLAG IS ON IN CASE OF USER FIELD NOT PROVIDED VALUE -- END  HERE
									
									ELSE IF (@V_USER_FIELD_NAME_VALUE IS NOT NULL)
										BEGIN
											SET @V_ERROR_LOCATION = 84;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											BEGIN TRY
												SET @V_ERROR_LOCATION = 85;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--Select Entity_Id from ENTITY where entity_table_id=@V_CODE_FILE_ID_C and last_name=@V_USER_FIELD_NAME_VALUE
												SET @V_SQL_VALUE = N'SELECT @result = ENTITY_ID FROM ' + @P_DB_NAME + 'ENTITY WHERE ENTITY_TABLE_ID = @V_CODE_FILE_ID_C_P AND LAST_NAME = UPPER(@V_USER_FIELD_NAME_VALUE_P)';
												SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																		@V_CODE_FILE_ID_C_P INT,
																		@V_USER_FIELD_NAME_VALUE_P VARCHAR(500)'
												EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																		@V_CODE_FILE_ID_C_P = @V_CODE_FILE_ID_C,
																		@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE,
																		@result = @V_ENTITY_ID OUTPUT;
												SET @V_ERROR_LOCATION = 86;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--PRINT @V_SQL_VALUE
												--PRINT @V_CODE_FILE_ID_C
												--PRINT @V_USER_FIELD_NAME_VALUE
												--PRINT @V_ENTITY_ID
												IF (@V_ENTITY_ID IS NULL)
													BEGIN													
														SET @V_ERROR_LOCATION = 87;						
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														IF (@V_VALIDATE_FLAG = 1)  -- ENTITY VALIDATION FLAG IS ON -- START HERE
															BEGIN														
																SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1
															
																SET @V_ERROR_MSG = 'Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME
																SET @V_ERROR_LOCATION = 88;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															 
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END
														ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NOT NULL)
															BEGIN
																SET @V_ERROR_MSG = 'Entity does not exists in RM DB. Please provide the correct value in '+ @V_USER_FIELD_NAME;
																SET @V_ERROR_LOCATION = 89;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END    -- ENTITY VALIDATION FLAG IS ON -- END  HERE
													END
											END TRY
											BEGIN CATCH
													SET @V_ERROR_MSG= ERROR_MESSAGE() 
													EXEC DDS_ERROR_LOG_CAPTURE  
																		@P_JOBID, 
																		@p_DA_ROW_ID, 
																		@p_MODULE_NAME,
																		@V_ERROR_LOCATION, 
																		@V_ERROR_LOCATION,
																		'DDS_SUPPLEMENT',
																		@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																		@V_USER_FIELD_NAME, 
																		@DDS_MODULE_NAME,
																		@P_KEYCOLUMN,
																		@P_KEYVALUE,
																		0;
										END CATCH
									END                                   
                                   SET @V_ERROR_LOCATION = 90;
                                   --PRINT 'REACHED              -' + @V_ERROR_LOCATION
									IF (@V_ENTITY_ID = 0 AND @V_USER_FIELD_NAME_VALUE IS NOT NULL) -- IF ENTITY ID IS 0 THEN NEED TO CHECK FOR ABBREVIATION
										BEGIN    
											BEGIN TRY
												SET @V_ERROR_LOCATION = 91;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--SELECT ENTITY_ID from ENTITY WHERE ENTITY_TABLE_ID = @V_CODE_FILE_ID_C AND LAST_NAME =@V_USER_FIELD_NAME_VALUE
												SET @V_SQL_VALUE = N'SELECT @result = ENTITY_ID FROM ' + @P_DB_NAME + 'ENTITY WHERE ENTITY_TABLE_ID = @V_CODE_FILE_ID_C_P AND LAST_NAME = UPPER(@V_USER_FIELD_NAME_VALUE_P)';
												SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																		@V_CODE_FILE_ID_C_P INT,
																		@V_USER_FIELD_NAME_VALUE_P VARCHAR(500)'
												EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																		@V_CODE_FILE_ID_C_P = @V_CODE_FILE_ID_C,
																		@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE,
																		@result = @V_ENTITY_ID OUTPUT;
												SET @V_ERROR_LOCATION = 92;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												IF (@V_ENTITY_ID IS NULL)
													BEGIN												
														SET @V_ERROR_LOCATION = 93;						
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														IF (@V_VALIDATE_FLAG = 1) -- ENTITY VALIDATION FLAG IS ON -- START HERE
															BEGIN
																SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 
															
																SET @V_ERROR_MSG = 'Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME;
																SET @V_ERROR_LOCATION = 94;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END
														ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NOT NULL)
															BEGIN
																SET @V_ERROR_MSG = 'Entity does not exists in RM DB. Please provide the correct value in ' + @V_USER_FIELD_NAME
																SET @V_ERROR_LOCATION = 95;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END   -- ENTITY VALIDATION FLAG IS ON -- END  HERE
													END
											END TRY
											BEGIN CATCH										
												SET @V_ERROR_MSG= ERROR_MESSAGE() 
												EXEC DDS_ERROR_LOG_CAPTURE  
																	@P_JOBID, 
																	@p_DA_ROW_ID, 
																	@p_MODULE_NAME,
																	@V_ERROR_LOCATION, 
																	@V_ERROR_LOCATION,
																	'DDS_SUPPLEMENT',
																	@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																	@V_USER_FIELD_NAME, 
																	@DDS_MODULE_NAME,
																	@P_KEYCOLUMN,
																	@P_KEYVALUE,
																	0;
										   END CATCH
									   END                                  
									SET @V_ERROR_LOCATION = 96;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' =  @V_ENTITY_ID_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
									SET @ParmDefinition = N'@DA_ROW_ID_P INT,
															@JOBID_P INT,
															@MODULE_NAME_P VARCHAR(50),
															@V_ENTITY_ID_P INT'
									EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
															@DA_ROW_ID_P = @P_DA_ROW_ID,
															@JOBID_P = @P_JOBID,
															@MODULE_NAME_P = @P_MODULE_NAME,
															@V_ENTITY_ID_P = @V_ENTITY_ID;
									SET @V_ERROR_LOCATION = 97;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								   -- FOR SINGLE ENTITY FIELD VALUE END HERE 
                               END
                            ELSE IF (@V_MULTI_VAL = 1)    -- FOR MULTI VALUE ENTITY FIELD START HERE
								BEGIN
									SET @V_ERROR_LOCATION = 98;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
									WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
										BEGIN
											SET @V_ERROR_LOCATION = 99;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @iPos = CHARINDEX('|',@vReqColumns,1)
											SET @V_SQL_ENTITY_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
											SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
											BEGIN TRY
												SET @V_ERROR_LOCATION = 100;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												SET @V_SQL_ENTITY_C = N'SELECT @result = ENTITY_ID FROM ' + @P_DB_NAME + 'ENTITY WHERE ENTITY_TABLE_ID = @V_CODE_FILE_ID_C_P AND LAST_NAME = UPPER(@V_SQL_ENTITY_VAL_P)';
												SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																		@V_CODE_FILE_ID_C_P VARCHAR(500),																		
																		@V_SQL_ENTITY_VAL_P VARCHAR(500)'
												--PRINT @V_SQL_ENTITY_C
												--PRINT  @V_CODE_FILE_ID_C
												--PRINT '@V_USER_FIELD_NAME_VALUE=' + @V_USER_FIELD_NAME_VALUE
												--PRINT '@V_SQL_ENTITY_VAL' + @V_SQL_ENTITY_VAL
												EXECUTE sp_executesql @V_SQL_ENTITY_C, @ParmDefinition,
																		@V_CODE_FILE_ID_C_P = @V_CODE_FILE_ID_C,																		
																		@V_SQL_ENTITY_VAL_P = @V_SQL_ENTITY_VAL,
																		@result = @V_ENTITY_ID OUTPUT;
												
												
												SET @V_ERROR_LOCATION = 101;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												IF (@V_ENTITY_ID IS NULL)
													BEGIN
														SET @V_ERROR_LOCATION = 102;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														IF (@V_VALIDATE_FLAG = 1) -- ENTITY VALIDATION FLAG IS ON -- START HERE
															BEGIN
															SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 ;														
															SET @V_ERROR_MSG = 'Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in '+ @V_USER_FIELD_NAME;
																SET @V_ERROR_LOCATION = 103;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END

														ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NOT NULL)
															BEGIN
																SET @V_ERROR_MSG = 'Entity does not exists in RM DB. Please provide the correct value in '+ @V_USER_FIELD_NAME;
																SET @V_ERROR_LOCATION = 104;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END
														ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NULL AND @V_NULL_FLAG=0)
															BEGIN
																SET @V_ERROR_MSG = 'Allow null is not allowed. Please provide the value in '+ @V_USER_FIELD_NAME;
																SET @V_ERROR_LOCATION = 105;						
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																EXEC DDS_ERROR_LOG_CAPTURE  
																@P_JOBID, 
																@p_DA_ROW_ID, 
																@p_MODULE_NAME,
																@V_ERROR_LOCATION, 
																@V_ERROR_LOCATION,
																'DDS_SUPPLEMENT',
																@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																@V_USER_FIELD_NAME, 
																@DDS_MODULE_NAME,
																@P_KEYCOLUMN,
																@P_KEYVALUE,
																1;
															END
														ELSE IF (@V_VALIDATE_FLAG <> 1 and @V_USER_FIELD_NAME_VALUE IS NULL AND @V_NULL_FLAG=1)
															BEGIN
																SET @V_ENTITY_ID = 0;                
															END   -- ENTITY VALIDATION FLAG IS ON -- END  HERE
													END
											END TRY
											BEGIN CATCH											
												SET @V_ERROR_MSG= ERROR_MESSAGE() 
												EXEC DDS_ERROR_LOG_CAPTURE  
																	@P_JOBID, 
																	@p_DA_ROW_ID, 
																	@p_MODULE_NAME,
																	@V_ERROR_LOCATION, 
																	@V_ERROR_LOCATION,
																	'DDS_SUPPLEMENT',
																	@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																	@V_USER_FIELD_NAME, 
																	@DDS_MODULE_NAME,
																	@P_KEYCOLUMN,
																	@P_KEYVALUE,
																	0;
											END CATCH
                                            SET @V_ERROR_LOCATION = 106;
                                            --PRINT 'REACHED              -' + @V_ERROR_LOCATION
											IF (@V_ENTITY_ID_M_R IS NOT NULL)
												BEGIN
													SET @V_ENTITY_ID_M_R = @V_ENTITY_ID_M_R + '|' + CAST(ISNULL(@V_ENTITY_ID,0) AS VARCHAR(100))
												END
											ELSE 
												BEGIN
													SET @V_ENTITY_ID_M_R = CAST(ISNULL(@V_ENTITY_ID,0) AS VARCHAR(100))													
												END 
                                                 
										END -- END LOOP
                                          
                                   -- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
                                    SET @V_ERROR_LOCATION = 107;
                                    --PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' =  @V_ENTITY_ID_M_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
									SET @ParmDefinition = N'@DA_ROW_ID_P INT,
															@JOBID_P INT,
															@MODULE_NAME_P VARCHAR(50),
															@V_ENTITY_ID_M_R_P VARCHAR(50)'
									EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
															@DA_ROW_ID_P = @P_DA_ROW_ID,
															@JOBID_P = @P_JOBID,
															@MODULE_NAME_P = @P_MODULE_NAME,
															@V_ENTITY_ID_M_R_P = @V_ENTITY_ID_M_R;
									
									SET @V_ERROR_LOCATION = 108;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_ENTITY_ID_M_R=NULL; -- KAPIL -- 22-FEB-2016
								
								END    -- SINGLE AND MULTI VALUE STATES WORK END HERE
						
					END 
								--ENTITY VALIDATION END HERE			
                         
								--TEXT FIELD VALIDATION STARTS HERE
								IF (@V_FIELD_TYPE_NAME = 'TXTCODE_FIELD')
						BEGIN
                            SET @V_ERROR_LOCATION = 109;  
                            --PRINT 'REACHED              -' + @V_ERROR_LOCATION
                            --PRINT '@V_USER_FIELD_NAME_VALUE=' 
                            --PRINT @V_USER_FIELD_NAME_VALUE
                            IF (@V_MULTI_VAL <> 1) -- FOR SINGLE TEXT FIELD VALUE START HERE
                                BEGIN
									SET @V_ERROR_LOCATION = 110;
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @V_CHK_TXT_CODE = LEFT(@V_USER_FIELD_NAME_VALUE,CHARINDEX('-',@V_USER_FIELD_NAME_VALUE,1) - 1)
								
									SET @V_ERROR_LOCATION = 111; 
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									IF (LEN(@V_CHK_TXT_CODE) > 0) -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
										BEGIN
											SET @V_ERROR_LOCATION = 112;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_TXT_CODE = LEFT(@V_USER_FIELD_NAME_VALUE,CHARINDEX('-',@V_USER_FIELD_NAME_VALUE,1) - 1)
											-- FETCHING CODE VALUE FROM THE STRING
											 
											SET @V_TXT_DESC = Right(@V_USER_FIELD_NAME_VALUE,CHARINDEX('-',@V_USER_FIELD_NAME_VALUE,1) + 1)
											-- FETCHING DESCRIPTION VALUE FROM THE STRING
										END
									ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
										BEGIN 
											SET @V_ERROR_LOCATION = 113;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_TXT_CODE = @V_USER_FIELD_NAME_VALUE										 
											SET @V_TXT_DESC = NULL
										END
								
									IF (@V_TXT_CODE IS NOT NULL)
										BEGIN
											SET @V_ERROR_LOCATION = 114;  
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
                                                                         @V_TXT_CODE, -- Short Code
                                                                         @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                         @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                         --1, -- It is used to check are we able to create code for that system table name or not
                                                                         @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         @P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                         @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @DDS_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @P_KEYVALUE,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @V_TXT_CODE_R OUTPUT;
                                                                         
											SET @V_ERROR_LOCATION = 115;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                        
                                            IF ((@V_TXT_CODE_R = 0 OR @V_TXT_CODE_R IS NULL) AND @V_TXT_CODE IS NOT NULL)
												BEGIN
                                                    SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 
                                                    SET @V_ERROR_LOCATION = 116;  
                                                    --PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                                                   -- Commenting the below code as error log is getting captured in code procedure
												END
                                            ELSE
												BEGIN
													SET @V_ERROR_LOCATION = 117;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													--Updating temp table for single Text fields
													SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' =  ISNULL(@V_TXT_CODE_R_P,0) WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
													SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																			@JOBID_P INT,
																			@MODULE_NAME_P VARCHAR(50)
																			@V_TXT_CODE_R_P INT'
													EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																			@DA_ROW_ID_P = @P_DA_ROW_ID,
																			@JOBID_P = @P_JOBID,
																			@MODULE_NAME_P = @P_MODULE_NAME,
																			@V_TXT_CODE_R_P = @V_TXT_CODE_R;
													SET @V_ERROR_LOCATION = 118;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												END                                                                            
										END 
								END
                            ELSE IF (@V_MULTI_VAL = 1 AND @V_USER_FIELD_NAME_VALUE IS NOT NULL)  -- FOR MULTI VALUE TEXT FIELD START HERE
                                BEGIN 
									SET @V_ERROR_LOCATION = 119;  
									--PRINT 'REACHED              -' + @V_ERROR_LOCATION
									SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
									WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
										BEGIN
											SET @V_ERROR_LOCATION = 120;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @iPos = CHARINDEX('|',@vReqColumns,1)
											SET @V_SQL_TXT_CODE_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
											SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
										
											SET @V_CHK_TXT_CODE = LEFT(@V_SQL_TXT_CODE_VAL,CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1) - 1)
											SET @V_ERROR_LOCATION = 121;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											IF (LEN(@V_CHK_TXT_CODE) > 0) -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
												BEGIN
													SET @V_TXT_CODE = LEFT(@V_SQL_TXT_CODE_VAL,CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1) - 1)
													--PRINT '@V_TXT_CODE=' + @V_TXT_CODE
													-- FETCHING CODE VALUE FROM THE STRING
													
													 
													--SET @V_TXT_DESC =  Right(@V_SQL_TXT_CODE_VAL,CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1) + 1)
													SET @V_TXT_DESC = RIGHT(@V_SQL_TXT_CODE_VAL,LEN(@V_SQL_TXT_CODE_VAL) - CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1))
													
													--PRINT '@V_TXT_DESC=' + @V_TXT_DESC
													-- FETCHING DESCRIPTION VALUE FROM THE STRING
												END
											ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
												BEGIN 
													SET @V_TXT_CODE = @V_USER_FIELD_NAME_VALUE										 
													SET @V_TXT_DESC = NULL
												END
							
											IF (@V_TXT_CODE IS NOT NULL)
                                                BEGIN 
                                                SET @V_ERROR_LOCATION = 122;      
                                                --PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF (@V_TXT_CODE IS NOT NULL)
														BEGIN
															SET @V_ERROR_LOCATION = 123;  
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															EXEC DDS_CODE_VALIDATION_IMPORT @P_JOBID, 
                                                                         @V_TXT_CODE, -- Short Code
                                                                         @V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                         @P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                        -- 1, -- It is used to check are we able to create code for that system table name or not
                                                                         @P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         @P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                         @P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         @V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @DDS_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         @V_TXT_CODE_R OUTPUT;
													
															SET @V_ERROR_LOCATION = 124;
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
                                                         
                                                            IF ((@V_TXT_CODE_R = 0 OR @V_TXT_CODE_R IS NULL) AND @V_TXT_CODE IS NOT NULL)
                                                                BEGIN 
																	SET @V_ERROR_COUNT = @V_ERROR_COUNT + 1 
																END            
                                                         
															IF (@V_TXT_CODE_CODE_DESC_R IS NOT NULL)
																BEGIN
																	SET @V_TXT_CODE_CODE_DESC_R = @V_TXT_CODE_CODE_DESC_R + '|' + CAST(ISNULL(@V_TXT_CODE_R,0) AS VARCHAR(100)) + ' - ' + @V_TXT_DESC;
																END
															ELSE 
																BEGIN
																	SET @V_TXT_CODE_CODE_DESC_R = CAST(ISNULL(@V_TXT_CODE_R,0) AS VARCHAR(100)) + ' - ' + @V_TXT_DESC
																END 
                                                         
														END
												END			
                                                       
                                            END -- END LOOP;
                                                           
											-- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
											SET @V_ERROR_LOCATION = 125;  
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET ' + @V_USER_FIELD_NAME + ' = @V_TXT_CODE_CODE_DESC_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
											SET @ParmDefinition = N'@DA_ROW_ID_P INT,
																	@JOBID_P INT,
																	@MODULE_NAME_P VARCHAR(50),
																	@V_TXT_CODE_CODE_DESC_R_P VARCHAR(2000)'
											EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
																	@DA_ROW_ID_P = @P_DA_ROW_ID,
																	@JOBID_P = @P_JOBID,
																	@MODULE_NAME_P = @P_MODULE_NAME,
																	@V_TXT_CODE_CODE_DESC_R_P = @V_TXT_CODE_CODE_DESC_R;
											----- KAPIL START 16-FEB-2016 -- START
											--SET @V_SQL_VALUE = N'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET  USER_FIELD_TXT_CODE = @V_TXT_CODE_CODE_DESC_R_P WHERE DA_ROW_ID=@DA_ROW_ID_P AND JOBID=@JOBID_P AND MODULE_NAME=@MODULE_NAME_P';
											--SET @ParmDefinition = N'@DA_ROW_ID_P INT,
											--						@JOBID_P INT,
											--						@MODULE_NAME_P VARCHAR(50),
											--						@V_TXT_CODE_CODE_DESC_R_P VARCHAR(MAX)'
											--EXECUTE sp_executesql @V_SQL_VALUE, @ParmDefinition,
											--						@DA_ROW_ID_P = @P_DA_ROW_ID,
											--						@JOBID_P = @P_JOBID,
											--						@MODULE_NAME_P = @P_MODULE_NAME,
											--						@V_TXT_CODE_CODE_DESC_R_P = @V_USER_FIELD_NAME_VALUE;	
																	
											----- KAPIL START 16-FEB-2016 -- END																													
																	
											SET @V_ERROR_LOCATION = 126;
											--PRINT 'REACHED              -' + @V_ERROR_LOCATION
											SET @V_TXT_CODE_CODE_DESC_R=NULL;-- KAPIL - 22-FEB-2016
									END-- FOR SINGLE AND MULTI TEXT FIELD VALUE END HERE
								
						END
								--TEXT FIELD VALIDATION END HERE         
				END
                         
						SET @P_SUPP_ERROR_COUNT = @V_ERROR_COUNT -- SETTING UP THE ERROR VALUE FLAG IF THERE IS ANY

						-- VALIDATION FLAG / STAGE WORK COMPLETED / END HERE       
                     
						/*BELOW CODE IS THE COMMON CODE FOR BOTH VALIDATION FLAG 0 AND 1. IN IT WE ARE GOING TO CHECK
						THAT RECORD EXISTS IN RM DB OR NOT AND IF NOT EXISTS THEN WE INSERTING THE RELATED INFORMATION INTO THE TARGET 
						TABLES ACCORDINGLY*/
                 
                 
						-- RM TABLE CHECK PROCESSING START
						-- INSERTION FLAG / STAGE WORK COMPLETED / START HERE
						IF (@P_STAGE='I')            
							BEGIN
								SET @V_ERROR_LOCATION = 127;
								--PRINT 'REACHED              -' + @V_ERROR_LOCATION
								--PRINT '@P_BASE_ERROR_COUNT='
								--PRINT @P_BASE_ERROR_COUNT
								IF (@P_BASE_ERROR_COUNT = 0)  -- MAIN IF FOR RM DB WORK START HERE
									BEGIN
										SET @V_ERROR_LOCATION = 128;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										--PRINT '@V_MAPPED_TABLE='+@V_MAPPED_TABLE
										-- CHECKING CLAIMANT EXISTS IN CLAIMANT SUPP OR NOT, IF EXISTS THEN IT WILL BE A UPDATE CASE OTHERWISE INSERT CASE
										IF (@V_MAPPED_TABLE = 'CLAIMANT_SUPP')-- CLAIMANT SUPP START HERE                        
											BEGIN
												BEGIN TRY
													SET @V_ERROR_LOCATION = 129;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													--SELECT CLAIMANT_ROW_ID FROM CLAIMANT_SUPP WHERE CLAIM_ID =@P_CLAIM_ID AND CLAIMANT_EID =@P_CLAIMANT_EID
													SET @V_SQL_RM_SUPP = N'SELECT @result = CLAIMANT_ROW_ID FROM '  + @P_DB_NAME + 'CLAIMANT_SUPP WHERE CLAIM_ID = @CLAIM_ID_P AND CLAIMANT_EID = @CLAIMANT_EID_P';
													SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
																			@CLAIM_ID_P INT,
																			@CLAIMANT_EID_P INT'
													EXECUTE sp_executesql @V_SQL_RM_SUPP, @ParmDefinition,
																			@CLAIM_ID_P = @P_CLAIM_ID,
																			@CLAIMANT_EID_P= @P_CLAIMANT_EID,								
																			@result = @V_TAB_PK_COL_VAL OUTPUT; -- kAPIL 25-FEB-2016
																			--@result = @V_TAB_PK_ID OUTPUT;										
													SET @V_TAB_PK_COL_NAME = 'CLAIMANT_ROW_ID'		-- KAPIL 25-FEB-2016
													SET @V_ERROR_LOCATION = 130;
													--PRINT @P_CLAIMANT_EID
													--PRINT @V_TAB_PK_ID
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													IF (@V_TAB_PK_COL_VAL IS NULL)--(@V_TAB_PK_ID IS NULL) -- KAPIL --25-FEB-2016
														BEGIN															
															BEGIN TRY
																SET @V_ERROR_LOCATION = 131;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																SET @V_SQL_RM_SUPP = N'SELECT @result = CLAIMANT_ROW_ID FROM '  + @P_DB_NAME + 'CLAIMANT WHERE CLAIM_ID = @CLAIM_ID_P AND CLAIMANT_EID = @CLAIMANT_EID_P'; -- Kapil 25-feb-2016
																SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
																						@CLAIM_ID_P INT,
																						@CLAIMANT_EID_P INT'
																EXECUTE sp_executesql @V_SQL_RM_SUPP, @ParmDefinition,
																						@CLAIM_ID_P = @P_CLAIM_ID,
																						@CLAIMANT_EID_P= @P_CLAIMANT_EID,
																						@result = @V_TAB_PK_COL_VAL OUTPUT; -- kAPIL 25-FEB-2016
																						--@result = @V_TAB_PK_ID OUTPUT;
																														
																SET @V_INS_UPD_FLAG = 'I';
																SET @V_ERROR_LOCATION = 132;
																--PRINT @V_TAB_PK_ID
																--PRINT @V_INS_UPD_FLAG
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															END TRY
															BEGIN CATCH													
																	SET @V_ERROR_MSG= ERROR_MESSAGE() 
																	EXEC DDS_ERROR_LOG_CAPTURE  
																						@P_JOBID, 
																						@p_DA_ROW_ID, 
																						@p_MODULE_NAME,
																						@V_ERROR_LOCATION, 
																						@V_ERROR_LOCATION,
																						'DDS_SUPPLEMENT',
																						@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																						@V_USER_FIELD_NAME, 
																						@DDS_MODULE_NAME,
																						@P_KEYCOLUMN,
																						@P_KEYVALUE,
																						0;
															END CATCH
														END
													ELSE
														BEGIN
															SET @V_ERROR_LOCATION = 133;						
															--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															SET @V_INS_UPD_FLAG = 'U'
														END
												END TRY
												BEGIN CATCH										
													SET @V_ERROR_MSG= ERROR_MESSAGE() 
													EXEC DDS_ERROR_LOG_CAPTURE  
																		@P_JOBID, 
																		@p_DA_ROW_ID, 
																		@p_MODULE_NAME,
																		@V_ERROR_LOCATION, 
																		@V_ERROR_LOCATION,
																		'DDS_SUPPLEMENT',
																		@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																		@V_USER_FIELD_NAME, 
																		@DDS_MODULE_NAME,
																		@P_KEYCOLUMN,
																		@P_KEYVALUE,
																		0;
												END CATCH
											END  
									
										ELSE
											BEGIN
												SET @V_ERROR_LOCATION = 134;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												--MAKING DYNAMIC QUERY FOR REST OF THE TABLES AND CHECKING RECORD EXISTS IN IT OR NOT -- START
												IF (@V_MAPPED_TABLE = 'EVENT_SUPP' OR @V_MAPPED_TABLE = 'EVENT_X_MEDW_SUPP' OR @V_MAPPED_TABLE = 'FALL_IND_SUPP') 
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'EVENT_ID'
														SET @V_TAB_PK_COL_VAL = @P_EVENT_ID
													END
												ELSE IF (@V_MAPPED_TABLE = 'CLAIM_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'CLAIM_ID';
														SET @V_TAB_PK_COL_VAL = @P_CLAIM_ID;
														--PRINT @P_CLAIM_ID
													END
												ELSE IF (@V_MAPPED_TABLE = 'EMP_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'EMPLOYEE_EID';
														SET @V_TAB_PK_COL_VAL = @P_EMPLOYEE_EID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'VEHICLE_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'UNIT_ID';
														SET @V_TAB_PK_COL_VAL = @P_UNIT_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'ENTITY_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'ENTITY_ID';  
														SET @V_TAB_PK_COL_VAL = @P_ENTITY_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'DEFENDANT_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'DEFENDANT_ROW_ID';
														SET @V_TAB_PK_COL_VAL = @P_DEFENDANT_ROW_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'PI_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'PI_ROW_ID';
														SET @V_TAB_PK_COL_VAL = @P_PI_ROW_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'PI_X_PROC_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'PI_PROC_ROW_ID';
														SET @V_TAB_PK_COL_VAL = @P_PI_PROC_ROW_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'PATIENT_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'PATIENT_ID';
														SET @V_TAB_PK_COL_VAL = @P_PATIENT_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'FUNDS_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'TRANS_ID';  
														SET @V_TAB_PK_COL_VAL = @P_TRANS_ID;
													END
												ELSE IF (@V_MAPPED_TABLE = 'DIS_PLAN_SUPP')
													BEGIN
														SET @V_TAB_PK_COL_NAME = 'PLAN_ID';             
														SET @V_TAB_PK_COL_VAL = @P_PLAN_ID;    
													END
											        --Kapil added below conditions for Med Watch functionality
											        -- Start, Date: 22-Apr-2016
											        ELSE IF (@V_MAPPED_TABLE = 'EV_CONCOM_SUPP')
												      BEGIN
													SET @V_TAB_PK_COL_NAME = 'EV_CONCOM_ROW_ID';             
													SET @V_TAB_PK_COL_VAL = @P_EV_CONCOM_ROW_ID;    
												      END
	                      								        ELSE IF (@V_MAPPED_TABLE = 'EV_MW_TEST_SUPP')
											             BEGIN
													SET @V_TAB_PK_COL_NAME = 'EV_MW_TEST_ROW_ID';             
													SET @V_TAB_PK_COL_VAL = @P_EV_MW_TEST_ROW_ID;                                       
												     END
											    -- End, Date: 22-Apr-2016  

												SET @V_ERROR_LOCATION = 135;
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												BEGIN TRY
													SET @V_ERROR_LOCATION = 136;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													SET @V_SQL_RM_SUPP = N'SELECT @result = '+ @V_TAB_PK_COL_NAME + ' FROM ' + @P_DB_NAME + @V_MAPPED_TABLE + ' WHERE ' + @V_TAB_PK_COL_NAME + ' = @V_TAB_PK_COL_VAL_P';
													SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
																			@V_TAB_PK_COL_VAL_P VARCHAR(500)'
													EXECUTE sp_executesql @V_SQL_RM_SUPP, @ParmDefinition,
																			@V_TAB_PK_COL_VAL_P= @V_TAB_PK_COL_VAL,								
																			@result = @V_TAB_PK_ID OUTPUT;																							
													IF (@V_TAB_PK_ID IS NULL  or @V_TAB_PK_ID = 0) 
														BEGIN
															SET @V_INS_UPD_FLAG = 'I';
														END
													ELSE
														BEGIN
															SET @V_INS_UPD_FLAG = 'U';
														END
													SET @V_ERROR_LOCATION = 137;
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													--PRINT @V_TAB_PK_ID
												END TRY
												BEGIN CATCH								
													SET @V_ERROR_MSG= ERROR_MESSAGE() 
													EXEC DDS_ERROR_LOG_CAPTURE  
																		@P_JOBID, 
																		@p_DA_ROW_ID, 
																		@p_MODULE_NAME,
																		@V_ERROR_LOCATION, 
																		@V_ERROR_LOCATION,
																		'DDS_SUPPLEMENT',
																		@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
																		@V_USER_FIELD_NAME, 
																		@DDS_MODULE_NAME,
																		@P_KEYCOLUMN,
																		@P_KEYVALUE,
																		0;
												END CATCH
									
										END;      
										--MAKING DYNAMIC QUERY FOR REST OF THE TABLES AND CHECKING RECORD EXISTS IN IT OR NOT -- END  
										-- CLAIMANT SUPP END HERE
		          
										-- insert or update into rm db tables                    
										--IF V_TAB_PK_ID>0 THEN -- IF PK VALUE OF A TABLE IS HAVING ANY VALUE -- eg CLAIMANT ROW ID -- START
										SET @V_ERROR_LOCATION = 138;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @V_SQL = N'SELECT @result = COUNT (' + @V_USER_FIELD_NAME + ') from DDS_SUPPLEMENTAL_RUNTIME_DATA WHERE JOBID = @JOBID_P AND DA_ROW_ID=@DA_ROW_ID_P AND MODULE_NAME=@MODULE_NAME_P';
										SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
														@JOBID_P INT,
														@DA_ROW_ID_P INT,												
														@MODULE_NAME_P VARCHAR(50)'
										EXECUTE sp_executesql @V_SQL, @ParmDefinition,
														@JOBID_P = @P_JOBID,
														@DA_ROW_ID_P = @P_DA_ROW_ID,												
														@MODULE_NAME_P = @P_MODULE_NAME,								
														@result = @Count_C2 OUTPUT;

										SET @Count_C2 = CAST(@Count_C2 AS INT);
										SET @V_ERROR_LOCATION = 139;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
							

										SET @V_SQL_RM_SUPP='DECLARE l_CURSOR_RM_DB_I_U_F CURSOR FOR SELECT ' + @V_USER_FIELD_NAME + ' from DDS_SUPPLEMENTAL_RUNTIME_DATA WHERE JOBID = @JOBID_P AND DA_ROW_ID=@DA_ROW_ID_P AND MODULE_NAME=@MODULE_NAME_P';;
										--PRINT @V_SQL_RM_SUPP;                             
										SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
														@JOBID_P INT,
														@DA_ROW_ID_P INT,												
														@MODULE_NAME_P VARCHAR(50)'
										EXECUTE sp_executesql @V_SQL_RM_SUPP, @ParmDefinition,
																@JOBID_P = @P_JOBID,
																@DA_ROW_ID_P = @P_DA_ROW_ID,												
																@MODULE_NAME_P = @P_MODULE_NAME,							
																@result = @Count_C2 OUTPUT;
										OPEN l_CURSOR_RM_DB_I_U_F; 
										FETCH NEXT FROM l_CURSOR_RM_DB_I_U_F 
										INTO @V_USER_FIELD_NAME_VALUE
										SET @V_ERROR_LOCATION = 140;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										--PRINT @V_USER_FIELD_NAME
										--PRINT '@Count_C2='
										--PRINT @Count_C2
										BEGIN TRY
										WHILE @Count_C2>0  -- --LOOP
											BEGIN
												SET @V_ERROR_LOCATION = 141;							
												--PRINT 'REACHED              -' + @V_ERROR_LOCATION
												IF (@V_MULTI_VAL = 0)-- IF COLUMN FIELD IS NOT MULTI VALUE TYPE THEN WE NEED TO INSERT/ UPDATE DIRECTLY INTO RM DB
													BEGIN
													SET @V_ERROR_LOCATION = 142;                                
													--PRINT 'REACHED              -' + @V_ERROR_LOCATION
													--PRINT '@V_INS_UPD_FLAG=' + @V_INS_UPD_FLAG
														IF (@V_INS_UPD_FLAG = 'I')
															BEGIN
																SET @V_ERROR_LOCATION = 143;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																--PRINT @V_TAB_PK_COL_VAL																	
																--PRINT @V_USER_FIELD_NAME_VALUE
														  IF @V_TAB_PK_COL_VAL > 0 -- KAPIL -- 24-FEB-2016
														  BEGIN		-- KAPIL -- 24-FEB-2016		
															   -- KAPIL START -- 25-FEB-2016                                                                      -- KAPIL START HERE -- 25-FEB-2016
															   IF @V_MAPPED_TABLE = 'CLAIMANT_SUPP' -- CLAIMANT SUPP START HERE
															    BEGIN
																  SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + @V_MAPPED_TABLE + '(' + @V_TAB_PK_COL_NAME + ',' + @V_MAPPED_FIELD + ', CLAIM_ID,CLAIMANT_EID) VALUES (@V_TAB_PK_COL_VAL_P,@V_USER_FIELD_NAME_VALUE_P, @V_CLAIM_ID_P,@V_CLAIMANT_EID_P )';
																	SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																							@V_USER_FIELD_NAME_VALUE_P VARCHAR(MAX),
																							@V_CLAIM_ID_P VARCHAR(500),
																							@V_CLAIMANT_EID_P VARCHAR(500)'
																	EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																							@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																							@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE,
																							@V_CLAIM_ID_P = @P_CLAIM_ID,
																							@V_CLAIMANT_EID_P = @P_CLAIMANT_EID;
																END  
															   ELSE
                                                                BEGIN       
                                                               -- KAPIL END --25-FEB-2016 
																SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + @V_MAPPED_TABLE + '(' + @V_TAB_PK_COL_NAME + ',' + @V_MAPPED_FIELD + ') VALUES (@V_TAB_PK_COL_VAL_P,@V_USER_FIELD_NAME_VALUE_P)';
																SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																						@V_USER_FIELD_NAME_VALUE_P VARCHAR(MAX)'
																EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																						@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																						@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
																END -- KAPIL --25-FEB-2016
																						
																SET @V_ERROR_LOCATION = 144;
																--PRINT @V_SQL_ENTITY
																--PRINT @V_TAB_PK_COL_VAL
																--PRINT @V_USER_FIELD_NAME_VALUE
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															END -- KAPIL -- 24-FEB-2016		
														  END
														ELSE IF (@V_INS_UPD_FLAG = 'U')
															BEGIN
																SET @V_ERROR_LOCATION = 145;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																SET @V_SQL_ENTITY = N'UPDATE ' + @P_DB_NAME + @V_MAPPED_TABLE + ' SET ' + @V_MAPPED_FIELD + ' = @V_USER_FIELD_NAME_VALUE_P WHERE '+ @V_TAB_PK_COL_NAME + ' = @V_TAB_PK_COL_VAL_P';
																SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																						@V_USER_FIELD_NAME_VALUE_P VARCHAR(MAX)'
																--PRINT @V_SQL_ENTITY
																--PRINT @V_TAB_PK_COL_VAL
																--PRINT @V_USER_FIELD_NAME_VALUE
																EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																						@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																						@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
																SET @V_ERROR_LOCATION = 146;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
															END
													   -- NOT MULTI VALUE CODE END HERE     
													END
												ELSE IF (@V_MULTI_VAL = 1)  -- IF COLUMN FIELD IS MULTI VALUE TYPE THEN WE INSERT/ UPDATE INTO RM DB VIA FOR LOOP ON THAT COLUMN -- START HERE
													BEGIN
														SET @V_ERROR_LOCATION = 147;
														--PRINT 'REACHED              -' + @V_ERROR_LOCATION
														SET @vReqColumns = @V_USER_FIELD_NAME_VALUE + '|'
														--PRINT @vReqColumns
														WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
															BEGIN
																SET @V_ERROR_LOCATION = 148;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																SET @iPos = CHARINDEX('|',@vReqColumns,1)
																SET @V_SQL_TXT_CODE_VAL = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
																SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
																SET @V_ERROR_LOCATION = 149;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																IF (@V_SQL_TXT_CODE_VAL IS NULL)
																	BEGIN
																		SET @V_SQL_TXT_CODE_VAL = ISNULL(@V_SQL_TXT_CODE_VAL,0)
																	END
																--PRINT @V_FIELD_TYPE_NAME
																IF (@V_FIELD_TYPE_NAME = 'TXTCODE_FIELD')  -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- START HERE
																	BEGIN
																		SET @V_CHK_TXT_CODE = LEFT(@V_SQL_TXT_CODE_VAL,CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1) - 1)
																		IF (LEN(@V_CHK_TXT_CODE) > 0) -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
																			BEGIN
																				SET @V_TXT_CODE = LEFT(@V_SQL_TXT_CODE_VAL,CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1) - 1)																   
																				SET @V_TXT_DESC = RIGHT(@V_SQL_TXT_CODE_VAL,LEN(@V_SQL_TXT_CODE_VAL) - CHARINDEX('-',@V_SQL_TXT_CODE_VAL,1))
																			END 
																		ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
																			BEGIN
																				SET @V_TXT_CODE = @V_SQL_TXT_CODE_VAL;
																				SET @V_TXT_DESC = NULL;
																			END
																			  
																	END  -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- END HERE
																 SET @V_ERROR_LOCATION = 150;
																 --PRINT 'REACHED              -' + @V_ERROR_LOCATION
																IF (@V_FIELD_TYPE_NAME <> 'TXTCODE_FIELD') -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- START HERE
																	BEGIN
																		SET @V_ERROR_LOCATION = 151;
																		--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																		SET @V_SQL_STATES = N'SELECT @result = COUNT(FIELD_ID) FROM ' + @P_DB_NAME + 'SUPP_MULTI_VALUE WHERE RECORD_ID = @V_TAB_PK_COL_VAL_P AND FIELD_ID=@V_FIELD_ID_C_P AND CODE_ID= @V_SQL_TXT_CODE_VAL_P';
																		SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																								@V_TAB_PK_COL_VAL_P VARCHAR(500),
																								@V_FIELD_ID_C_P INT,
																								@V_SQL_TXT_CODE_VAL_P VARCHAR(500)'
																		--PRINT @V_SQL_STATES
																		--PRINT @V_TAB_PK_COL_VAL
																		--PRINT @V_FIELD_ID_C
																		--PRINT @V_SQL_TXT_CODE_VAL
																		EXECUTE sp_executesql @V_SQL_STATES, @ParmDefinition,
																								@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																								@V_FIELD_ID_C_P = @V_FIELD_ID_C,
																								@V_SQL_TXT_CODE_VAL_P = @V_SQL_TXT_CODE_VAL,
																								@result = @V_SQL_STATES_VAL OUTPUT;
																		SET @V_ERROR_LOCATION = 152;
																		--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																		--PRINT @V_SQL_STATES_VAL
																	END
																ELSE IF (@V_FIELD_TYPE_NAME = 'TXTCODE_FIELD')
																	BEGIN
																		SET @V_ERROR_LOCATION = 153;
																		--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																		SET @V_SQL_STATES = N'SELECT @result = COUNT(FIELD_ID) FROM ' + @P_DB_NAME + 'SUPP_MULTI_VALUE WHERE RECORD_ID = @V_TAB_PK_COL_VAL_P AND FIELD_ID=@V_FIELD_ID_C_P AND CODE_ID= @V_TXT_CODE_P';
																		SET @ParmDefinition = N'@result VARCHAR(500) OUTPUT,
																								@V_TAB_PK_COL_VAL_P VARCHAR(500),
																								@V_FIELD_ID_C_P INT,
																								@V_TXT_CODE_P VARCHAR(500)'
																		--PRINT @V_SQL_STATES
																		--PRINT @V_TAB_PK_COL_VAL
																		--PRINT @V_FIELD_ID_C
																		--PRINT @V_TXT_CODE
																		EXECUTE sp_executesql @V_SQL_STATES, @ParmDefinition,
																								@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																								@V_FIELD_ID_C_P = @V_FIELD_ID_C,
																								@V_TXT_CODE_P = @V_TXT_CODE,
																								@result = @V_SQL_STATES_VAL OUTPUT;																		
																		SET @V_ERROR_LOCATION = 154;
																		--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																		--PRINT @V_SQL_STATES_VAL
																	END
																SET @V_ERROR_LOCATION = 155;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																--PRINT 'K1' + @V_INS_UPD_SUPP_FLAG
																IF (@V_SQL_STATES_VAL > 0)
																	BEGIN
																		--PRINT 'null';
																		SET @V_INS_UPD_SUPP_FLAG = 'U';																																			
																		-- NO WORK IS WRITTEN FOR IT IN VB CODE
																	END
																ELSE IF (@V_SQL_STATES_VAL = 0 or @V_SQL_STATES_VAL IS NULL)--ALOK
																	BEGIN
																		 SET @V_INS_UPD_SUPP_FLAG = 'I';
																	END
																SET @V_ERROR_LOCATION = 156;
																--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																--PRINT 'K2' + cast(isnull(@V_SQL_STATES_VAL,0) as varchar(100))
																 --PRINT 'K3' + @V_INS_UPD_SUPP_FLAG
																IF (@V_INS_UPD_SUPP_FLAG = 'I') 
																	BEGIN
																	IF @V_TAB_PK_COL_VAL > 0 -- KAPIL -- 24-FEB-2016
																	 BEGIN		-- KAPIL -- 24-FEB-2016	
																		IF (@V_FIELD_TYPE_NAME <> 'TXTCODE_FIELD')
																			BEGIN
																				SET @V_ERROR_LOCATION = 157;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																				
																				
																				SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + 'SUPP_MULTI_VALUE (RECORD_ID,FIELD_ID,CODE_ID) VALUES (@V_TAB_PK_COL_VAL_P,@V_FIELD_ID_C_P,@V_SQL_TXT_CODE_VAL_P)';
																				SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),
																										@V_FIELD_ID_C_P INT,
																										@V_SQL_TXT_CODE_VAL_P VARCHAR(500)'
																				EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																										@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																										@V_FIELD_ID_C_P = @V_FIELD_ID_C,
																										@V_SQL_TXT_CODE_VAL_P = @V_SQL_TXT_CODE_VAL;
																				--PRINT @V_SQL_ENTITY
																				--PRINT @V_TAB_PK_COL_VAL
																				--PRINT @V_SQL_TXT_CODE_VAL
																				--PRINT @V_FIELD_ID_C						
																				SET @V_ERROR_LOCATION = 158;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																			END
																		ELSE
																			BEGIN
																				SET @V_ERROR_LOCATION = 159;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																				SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + 'SUPP_MULTI_VALUE (RECORD_ID,FIELD_ID,CODE_ID) VALUES (@V_TAB_PK_COL_VAL_P,@V_FIELD_ID_C_P,@V_TXT_CODE_P)';
																				SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),
																										@V_FIELD_ID_C_P INT,
																										@V_TXT_CODE_P VARCHAR(500)'
																				--PRINT @V_SQL_ENTITY
																				--PRINT @V_TAB_PK_COL_VAL
																				--PRINT @V_FIELD_ID_C
																				--PRINT @V_TXT_CODE
																				EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																										@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																										@V_FIELD_ID_C_P = @V_FIELD_ID_C,
																										@V_TXT_CODE_P = @V_TXT_CODE;
																				SET @V_ERROR_LOCATION = 160;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																			END
																		END -- 24-FEB-2016		
																	END
																ELSE IF  (@V_INS_UPD_SUPP_FLAG = 'U')
																	BEGIN
																		PRINT ('')
																	END                                                            
															
																IF (@V_FIELD_TYPE_NAME = 'TXTCODE_FIELD') -- INSERT DATA INTO RM DB TABLE IN CASE OF TEXT FIELD TYPE
																	BEGIN
																	  SET @V_SQL_ENTITY = N'SELECT @result = '+ @V_USER_FIELD_NAME +' FROM DDS_'+ @P_MODULE_NAME + ' WHERE DA_ROW_ID = @DA_ROW_ID_P AND JOBID = @JOBID_P';
																		SET @ParmDefinition = N'@result VARCHAR(MAX) OUTPUT,
																								@DA_ROW_ID_P INT,
																								@JOBID_P INT'
																		EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																		@DA_ROW_ID_P = @P_DA_ROW_ID,
																		@JOBID_P = @P_JOBID,
																		@result = @V_USER_FIELD_NAME_VALUE OUTPUT;
																		
																		-- KAPIL CHANGES START AT 19-FEB-2016
																		-- WHILE DUPLICATE RECORDS ARE COMING IN CASE OF MULTI CODES THEN DUPLICATE ENTRY ISSUE IS COMING
																		SET @V_SQL_RM_SUPP = N'SELECT @result = '+ @V_TAB_PK_COL_NAME + ' FROM ' + @P_DB_NAME + @V_MAPPED_TABLE + ' WHERE ' + @V_TAB_PK_COL_NAME + ' = @V_TAB_PK_COL_VAL_P';
																		SET @ParmDefinition = N'@result VARCHAR(30) OUTPUT,
																								@V_TAB_PK_COL_VAL_P VARCHAR(500)'
																		EXECUTE sp_executesql @V_SQL_RM_SUPP, @ParmDefinition,
																								@V_TAB_PK_COL_VAL_P= @V_TAB_PK_COL_VAL,								
																								@result = @V_TAB_PK_ID OUTPUT;	
																			--PRINT 'KKINS5'
																			--PRINT @V_TAB_PK_ID
																			--PRINT @V_TAB_PK_COL_VAL
																			--PRINT @V_MAPPED_TABLE
																			--PRINT @V_TAB_PK_COL_NAME
																			--PRINT 'KKINS6'																																									
																		IF (@V_TAB_PK_ID IS NULL) 
																			BEGIN
																				SET @V_INS_UPD_FLAG = 'I';
																			END
																		ELSE
																			BEGIN
																				SET @V_INS_UPD_FLAG = 'U';
																			END
									                                                                         -- KAPIL CHANGES END AT 19-FEB-2016 

                                                                         
																		SET @V_ERROR_LOCATION = 161;
																		--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																		IF (@V_INS_UPD_FLAG = 'I')
																			BEGIN
																				SET @V_ERROR_LOCATION = 162;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																			IF @V_TAB_PK_COL_VAL > 0 -- KAPIL -- 24-FEB-2016
																			 BEGIN		-- KAPIL -- 24-FEB-2016	
																			   -- KAPIL -- 25-FEB-2016		 														   -- KAPIL START -- 25-FEB-2016                                                                      -- KAPIL START HERE -- 25-FEB-2016
																			   IF @V_MAPPED_TABLE = 'CLAIMANT_SUPP' -- CLAIMANT SUPP START HERE
																				BEGIN
																				  SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + @V_MAPPED_TABLE + '(' + @V_TAB_PK_COL_NAME + ',' + @V_MAPPED_FIELD + ', CLAIM_ID,CLAIMANT_EID) VALUES (@V_TAB_PK_COL_VAL_P,@V_USER_FIELD_NAME_VALUE_P, @V_CLAIM_ID_P,@V_CLAIMANT_EID_P )';
																					SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																											@V_USER_FIELD_NAME_VALUE_P VARCHAR(MAX),
																											@V_CLAIM_ID_P VARCHAR(500),
																											@V_CLAIMANT_EID_P VARCHAR(500)'
																					EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																											@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																											@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE,
																											@V_CLAIM_ID_P = @P_CLAIM_ID,
																											@V_CLAIMANT_EID_P = @P_CLAIMANT_EID;
																				END  
																			   ELSE
																				BEGIN       
																			   -- KAPIL END --25-FEB-2016 
																				SET @V_SQL_ENTITY = N'INSERT INTO ' + @P_DB_NAME + @V_MAPPED_TABLE + '(' + @V_TAB_PK_COL_NAME + ',' + @V_MAPPED_FIELD + ') VALUES (@V_TAB_PK_COL_VAL_P,@V_USER_FIELD_NAME_VALUE_P)';
																				SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																										@V_USER_FIELD_NAME_VALUE_P VARCHAR(MAX)'
																				EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																										@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																										@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
																										
																				SET @V_ERROR_LOCATION = 163;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																				END -- KAPIL -- 25-FEB-2016			
																			END 	-- KAPIL -- 24-FEB-2016			
																		 END
																		ELSE IF (@V_INS_UPD_FLAG = 'U')
																			BEGIN
																				SET @V_ERROR_LOCATION = 164;
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																				SET @V_SQL_ENTITY = N'UPDATE ' + @P_DB_NAME + @V_MAPPED_TABLE + ' SET ' + @V_MAPPED_FIELD + ' = @V_USER_FIELD_NAME_VALUE_P WHERE '+ @V_TAB_PK_COL_NAME + ' = @V_TAB_PK_COL_VAL_P';
																				SET @ParmDefinition = N'@V_TAB_PK_COL_VAL_P VARCHAR(500),																							
																										@V_USER_FIELD_NAME_VALUE_P VARCHAR(500)'
																				EXECUTE sp_executesql @V_SQL_ENTITY, @ParmDefinition,
																										@V_TAB_PK_COL_VAL_P = @V_TAB_PK_COL_VAL,
																										@V_USER_FIELD_NAME_VALUE_P = @V_USER_FIELD_NAME_VALUE;
																				SET @V_ERROR_LOCATION = 165;
																				--PRINT @V_USER_FIELD_NAME_VALUE
																				--PRINT @V_TAB_PK_COL_VAL
																				--PRINT @V_MAPPED_TABLE
																				--PRINT @V_MAPPED_FIELD
																				--PRINT 'REACHED              -' + @V_ERROR_LOCATION
																			END
																	END
																 
															END --END LOOP;
													END   -- IF COLUMN FIELD IS MULTI VALUE TYPE THEN WE INSERT/ UPDATE INTO RM DB VIA FOR LOOP ON THAT COLUMN                                
													--PRINT 'CURSOR 2 FETCH ' + cast(@Count_C2 as varchar(50))
													FETCH NEXT FROM l_CURSOR_RM_DB_I_U_F 
													INTO @V_USER_FIELD_NAME_VALUE;
													SET @Count_C2 = @Count_C2 - 1;
											END --END LOOP; 
										END TRY
										BEGIN CATCH
											SET @V_ERROR_MSG= ERROR_MESSAGE();
											EXEC DDS_ERROR_LOG_CAPTURE  
															@P_JOBID, 
															@p_DA_ROW_ID, 
															@p_MODULE_NAME,
															@V_ERROR_LOCATION, 
															@V_ERROR_LOCATION,
															'DDS_SUPPLEMENT',
															@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
															@V_USER_FIELD_NAME, 
															@DDS_MODULE_NAME,
															@P_KEYCOLUMN,
															@P_KEYVALUE,
															0;
										END CATCH										
										CLOSE l_CURSOR_RM_DB_I_U_F; 
										DEALLOCATE l_CURSOR_RM_DB_I_U_F; 
										--PRINT 'CURSOR CLOSED 2'
										SET @V_ERROR_LOCATION = 166;
										--PRINT 'REACHED              -' + @V_ERROR_LOCATION
										SET @V_TAB_PK_COL_VAL = NULL;  -- RESETTING THE VALUE
										SET @V_INS_UPD_FLAG = NULL;  -- RESETTING THE FLAG
										SET @V_INS_UPD_SUPP_FLAG = NULL; -- RESETTING THE FLAG	
										SET @V_TAB_PK_ID = NULL; -- KAPIL 22-FEB-2016      
										-- END IF;-- IF PK VALUE OF A TABLE IS HAVING ANY VALUE -- eg CLAIMANT ROW ID -- END
									END -- MAIN IF FOR RM DB WORK END HERE
							END		
						-- INSERTION FLAG / STAGE WORK COMPLETED / END HERE					 
						-- RM TABLE CHECK PROCESSING END		
					END TRY            
					BEGIN CATCH							
						SET @V_ERROR_MSG= ERROR_MESSAGE();
						EXEC DDS_ERROR_LOG_CAPTURE  
										@P_JOBID, 
										@p_DA_ROW_ID, 
										@p_MODULE_NAME,
										@V_ERROR_LOCATION, 
										@V_ERROR_LOCATION,
										'DDS_SUPPLEMENT',
										@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
										@V_USER_FIELD_NAME, 
										@DDS_MODULE_NAME,
										@P_KEYCOLUMN,
										@P_KEYVALUE,
										0;
					END CATCH
					--PRINT 'CURSOR 1 FETCH ' + cast(@Count_C1 as varchar(50))
					FETCH NEXT FROM l_cursor_1 
					INTO @V_FIELD_NUM, @V_USER_FIELD_NAME, @V_MAP_FLAG, @V_FIELD_TYPE,	@V_MAPPED_TABLE,@V_MAPPED_FIELD,@V_NULL_FLAG,@V_VALIDATE_FLAG , @V_CODE_TABLE_ID;		
					SET @Count_C1 = @Count_C1 - 1;
				END --END LOOP;            
			CLOSE l_cursor_1;			
			DEALLOCATE l_cursor_1;
			--PRINT 'CURSOR CLOSED 1' 
			SET @V_ERROR_LOCATION = 167;
			--PRINT 'REACHED              -' + @V_ERROR_LOCATION
		END TRY
		BEGIN CATCH	
	 	SET @V_ERROR_MSG= ERROR_MESSAGE();
		EXEC DDS_ERROR_LOG_CAPTURE  
							@P_JOBID, 
							@p_DA_ROW_ID, 
							@p_MODULE_NAME,
							@V_ERROR_LOCATION, 
							@V_ERROR_LOCATION,
							'DDS_SUPPLEMENT',
							@V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
							@V_USER_FIELD_NAME, 
							@DDS_MODULE_NAME,
							@P_KEYCOLUMN,
							@P_KEYVALUE,
							0;

		END CATCH
	END --DDS_SUPPLEMENT;