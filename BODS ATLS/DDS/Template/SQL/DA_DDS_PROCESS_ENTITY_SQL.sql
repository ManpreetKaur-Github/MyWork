IF OBJECT_ID('PROCESS_ENTITY','P') IS NOT NULL
	DROP PROCEDURE PROCESS_ENTITY
GO

CREATE PROCEDURE [dbo].[PROCESS_ENTITY](@pEntType tEntity READONLY, @pJobId int, @pDaRowId int, @vDbName varchar(100),@pModuleName varchar(100),
@iForceCrtEnt int,@iUseTaxId int,@pCallingErrorLoc varchar(255),@pErrorKeyColumnValue varchar(100),@iEntityId int OUTPUT,@vErrorMsg nvarchar(Max) output,@BirthDateAvlbl int)
WITH EXECUTE AS CALLER
AS BEGIN
	SET NOCOUNT ON
	
	DECLARE
	--Entity related variables starts
	@vLastName varchar(255),
	@vFirstName varchar(255),
	@vMiddleName varchar(255),
	@vAbbr varchar(25),
	@vTaxId varchar(20),
	@vAddr1 varchar(100),
	@vAddr2 varchar(100),
	@vCity varchar(50),
	@vCountry int,   ---neha
	@vState int,   ----neha
	@vCounty varchar(30),
	@vZip varchar(10),
	@vPhone1 varchar(30),
	@vPhone2 varchar(30),
	@vFaxNumber varchar(30),
	@vBirthDate varchar(8),
	@vSexCode int,   ----neha
	@vComment nvarchar(max),
	@iParentEid int,	
	@vTableName varchar(30),
	@iRpt1099Flag int,
	@iPrefixCodeId int,
	@iSuffixCodeId int,
	@vSuffixLegal varchar(50),	
	@iNameType int,
	@vEmpNum varchar(20),
	--Entity Related variables ends
	@nSql nvarchar(MAX),
	@nSqlAdd nvarchar(MAX),
	@iEroleFlag int,
	@iGlossaryType int,
	@iUseTableId int,
	@iTableId int,
	@iCount int,
	@vLastLetter varchar(1),
	@vLetter varchar(1),
	@vTotal varchar(255),
	@vLastNameSoundex varchar(4),
	@oEmpMatchByName		int,
	@oEmpMatchByEmpNum		int,
	@oEmpMatchByTaxId		int,
	@oNonEmpMatchByName		int,
	@oNonEmpMatchByTaxId	int,
	@oCreateNewEntity		int,   
	@oChkDupEntity			int,   
	@oCreateNewEmp			int,
	@vSysErrorMsg			nvarchar(max),  
	@vCurrentErrorLoc		varchar(100),
	@vErrorTableToCheck		varchar(100),
	@vKeycolumn				varchar(100),
	@vErrorCount			int=0,
	@vProcName				varchar(100)='PROCESS_ENTITY',
	@nSqlCount				nvarchar(max),   ---knakra
	@vSysDate				varchar(14),  --NEHA
	@iCodeId int ; --mkaur24;
	--dsharma70
	DECLARE @oEmpMatchByDOB			int,
	@oNonEmpMatchByDOB		int;
	
	SELECT TOP 1
	@vLastName = vLastName,
	@vFirstName = vFirstName,
	@vMiddleName = vMiddleName,
	@vAbbr = vAbbr,
	@vTaxId = vTaxId,
	@vAddr1 = vAddr1,
	@vAddr2 = vAddr2,
	@vCity = vCity,
	@vCountry = vCountry,
	@vState = vState,
	@vCounty = vCounty,
	@vZip = vZip,
	@vPhone1 = vPhone1,
	@vPhone2 = vPhone2,
	@vFaxNumber = vFaxNumber,
	@vBirthDate = vBirthDate,
	@vSexCode = vSexCode,
	@vComment = vComment,
	@iParentEid = iParentEid,	
	@vTableName = vTableName,
	@iRpt1099Flag = iRpt1099Flag,
	@iPrefixCodeId = iPrefixCodeId,
	@iSuffixCodeId = iSuffixCodeId,
	@vSuffixLegal = vSuffixLegal,	
	@iNameType = iNameType,
	@vEmpNum = vEmpNum
	FROM @pEntType WHERE iJobId = @pJobId AND iDaRowId = @pDaRowId ORDER BY iRowId DESC

	SET @iEntityId = 0
	SET @iCount = 0
	SET @vErrorMsg=''
	SET @vSysDate=replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');  --NEHA
	
	
	IF @pModuleName='EVENT'
	BEGIN
		SET @vErrorTableToCheck='DDS_EVENT'
		SET @vKeycolumn='EVENT_NUMBER'
	END
	ELSE IF @pModuleName='CLAIM'
	BEGIN
		SET @vErrorTableToCheck='DDS_CLAIM'
		SET @vKeycolumn='CLAIM_NUMBER'  --need to check
	END
	ELSE IF @pModuleName='PAYMENT'
	BEGIN
		SET @vErrorTableToCheck='DDS_PAYMENT' 
		SET @vKeycolumn='CLAIM_ID'  -----need to check
	END
	
	BEGIN TRY
		SET @nSql = 'SELECT @pParmValue = STR_PARM_VALUE FROM ' + @vDbName + 'PARMS_NAME_VALUE WHERE PARM_NAME = ''USE_ENTITY_ROLE'''
		EXECUTE SP_EXECUTESQL @nSql,N' @pParmValue int OUTPUT',@pParmValue = @iEroleFlag OUTPUT
	END TRY
	BEGIN CATCH
		SET @vCurrentErrorLoc='SYSERR1'
		SET @vSysErrorMsg=ERROR_MESSAGE();
		EXEC DDS_ERROR_LOG_CAPTURE
						@p_JOBID=@pJobId, 
						@p_DA_ROW_ID=@pDaRowId, 
						@p_MODULE_NAME=@pModuleName,
						@p_CALLING_ERROR_LOCATION=@pCallingErrorLoc,  
						@p_CURRENT_ERROR_LOCATION=@vCurrentErrorLoc,
						@p_ERROR_PROC_NAME=@vProcName,
						@p_ERROR_MSG=@vSysErrorMsg,
						@p_ERROR_COLUMNS=NULL,
						@p_ERROR_TABLE_TO_CHECK=@vErrorTableToCheck,
						@p_ERROR_KEY_COLUMN=@vKeycolumn, 
						@P_ERROR_COLUMN_KEY_VALUE=@pErrorKeyColumnValue,
						@P_IS_VALIDATION=0;
		SET @vErrorCount=@vErrorCount+1;		
	END CATCH
	
	BEGIN TRY
		SET @nSql = 'SELECT @pGlossaryType = GLOSSARY_TYPE_CODE, @pTableId = TABLE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''' + @vTableName + ''''
	
		EXECUTE SP_EXECUTESQL @nSql,
		N' @pGlossaryType int OUTPUT, @pTableId int OUTPUT',
		@pGlossaryType = @iGlossaryType OUTPUT, @pTableId = @iTableId OUTPUT
	END TRY
	BEGIN CATCH
		SET @vCurrentErrorLoc='SYSERR2'
		SET @vSysErrorMsg=ERROR_MESSAGE();
		EXEC DDS_ERROR_LOG_CAPTURE
						@p_JOBID=@pJobId, 
						@p_DA_ROW_ID=@pDaRowId, 
						@p_MODULE_NAME=@pModuleName,
						@p_CALLING_ERROR_LOCATION=@pCallingErrorLoc,  
						@p_CURRENT_ERROR_LOCATION=@vCurrentErrorLoc,
						@p_ERROR_PROC_NAME=@vProcName,
						@p_ERROR_MSG=@vSysErrorMsg,
						@p_ERROR_COLUMNS=NULL,
						@p_ERROR_TABLE_TO_CHECK=@vErrorTableToCheck,
						@p_ERROR_KEY_COLUMN=@vKeycolumn, 
						@P_ERROR_COLUMN_KEY_VALUE=@pErrorKeyColumnValue,
						@P_IS_VALIDATION=0;
		SET @vErrorCount=@vErrorCount+1;
	END CATCH

	IF @iEroleFlag <> 0 AND (@iGlossaryType = 4 OR @iGlossaryType = 7)
		SET @iUseTableId = 0
	ELSE
		SET @iUseTableId = 1

	IF @iEroleFlag <> 0 AND @iGlossaryType = 4 AND (@iNameType is null or @iNameType = 0 )    --MKAUR24  START NAME _TYPE_CHANGE
	BEGIN
	EXECUTE DDS_CODE_VALIDATION_IMPORT @pJobId,'BUS' ,'ENTITY_NAME_TYPE' ,0 ,@vDbName ,0 ,@pDaRowId,@pModuleName,'NM' , 'DDS_CODE_VALIDATION_IMPORT' , @vKeycolumn ,'NAME_TYPE', @vErrorTableToCheck ,@pErrorKeyColumnValue , @iCodeId OUTPUT ;
	SET @iNameType = @iCodeId ;
	END
	IF @iEroleFlag <> 0 AND @iGlossaryType = 7 AND (@iNameType is null or @iNameType = 0 )
	BEGIN
	EXECUTE DDS_CODE_VALIDATION_IMPORT @pJobId,'IND' ,'ENTITY_NAME_TYPE' ,0 ,@vDbName ,0 ,@pDaRowId,@pModuleName,'NM' , 'DDS_CODE_VALIDATION_IMPORT' , @vKeycolumn ,'NAME_TYPE', @vErrorTableToCheck ,@pErrorKeyColumnValue , @iCodeId OUTPUT ;
	SET @iNameType = @iCodeId ;
	END 	 --- MKAUR24 END
	

	
	SELECT @oEmpMatchByName =  ISNULL(EMPLOYEE_MATCH_BY_NAME,0), @oEmpMatchByEmpNum = ISNULL(EMPLOYEE_MATCH_BY_EMP_NUM,0),
	@oEmpMatchByTaxId = ISNULL(EMPLOYEE_MATCH_BY_TAX_ID,0), @oNonEmpMatchByName = ISNULL(NON_EMP_MATCH_BY_NAME,0), @oNonEmpMatchByTaxId = ISNULL(NON_EMP_MATCH_BY_TAX_ID,0),
	@oCreateNewEntity=ISNULL(CHK_CREATE_NEWENTITY,0),@oChkDupEntity=ISNULL(CHK_DUPLICATE_ENTITY,0),@oCreateNewEmp=ISNULL(ALLOW_NEW_EMPLOYEES,0)
	--dsharma70
	,@oEmpMatchByDOB= ISNULL(EMPLOYEE_MATCH_BY_DOB,0), @oNonEmpMatchByDOB = ISNULL(NON_EMP_MATCH_BY_DOB,0)
	FROM DDS_OPTIONSET WHERE JOBID = @pJobId

	SET @nSql = NULL
	SET @nSqlAdd = NULL
	
	IF @iForceCrtEnt <> 0	--knakra
		GOTO INSERTION		--knakra

	BEGIN TRY
	--SET @nSql = 'SELECT @pEntId = ENTITY_ID, @pCount = COUNT(ENTITY_ID) FROM ' + @vDbName + 'ENTITY '	--knakra
	SET @nSql = 'SELECT @pEntId = ENTITY_ID FROM ' + @vDbName + 'ENTITY '	--knakra
	SET @nSqlCount = 'SELECT @pCount = COUNT(ENTITY_ID) FROM ' + @vDbName + 'ENTITY '	--knakra
	
	IF @vTableName = 'EMPLOYEES'
	BEGIN
		
		--IF @iUseTaxId = 0 AND @oEmpMatchByEmpNum = 0 AND @oEmpMatchByName = 0 --DSHARMA70 hmi
		IF @iUseTaxId = 0 AND @oEmpMatchByEmpNum = 0 AND @oEmpMatchByName = 0 AND @oEmpMatchByDOB = 0 --DSHARMA70 hmi
		BEGIN
			SET @oEmpMatchByName = 1
			SET @oEmpMatchByTaxId = 0
		END		
		
		--DSHARMA70 hmi				
		IF @BirthDateAvlbl = 0 AND @oEmpMatchByEmpNum = 0 AND @oEmpMatchByName = 0 AND @oEmpMatchByTaxId = 0 --DSHARMA70 hmi
		BEGIN
			SET @oEmpMatchByName = 1
			SET @oEmpMatchByDOB = 0
		END		
		
		IF @oEmpMatchByEmpNum <> 0
		BEGIN
			IF @vEmpNum IS NULL
			BEGIN
				SET @vErrorMsg ='Match by Employee Number is selected but Employee Number is not given in import file.';
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				SET @nSqlAdd = ', ' + @vDbName + 'EMPLOYEE WHERE EMPLOYEE.EMPLOYEE_EID = ENTITY.ENTITY_ID AND EMPLOYEE_NUMBER = ''' + @vEmpNum + ''' '
		END
		
		IF @oEmpMatchByName <> 0
		BEGIN
			IF @vLastName IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg=@vErrorMsg +'Match by Employee Name is selected but Employee Last Name is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				BEGIN  
					IF @nSqlAdd IS NULL OR @nSqlAdd = ''			
						SET @nSqlAdd = 'WHERE LAST_NAME = ''' + @vLastName + ''' '							
					ELSE			
						SET @nSqlAdd = @nSqlAdd + 'AND LAST_NAME = ''' + @vLastName + ''' '							
			
					IF @vFirstName IS NOT NULL AND @vFirstName <> ''
						SET @nSqlAdd = @nSqlAdd + 'AND FIRST_NAME = ''' + @vFirstName + ''' '
				                                                     
				END
		END
		
		IF @oEmpMatchByTaxId <> 0 AND @iUseTaxid = 1
		BEGIN
			IF @vTaxId IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg=@vErrorMsg +'Match by Employee TaxId is selected but Employee TaxId is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				BEGIN
					SET @vTaxId = REPLACE(@vTaxId,'-','')
					IF @nSqlAdd IS NULL OR @nSqlAdd = ''
						SET @nSqlAdd = 'WHERE REPLACE(TAX_ID,''-'','''') = ''' + REPLACE(@vTaxId,'-','') + ''' '	--added replace knakra
					ELSE
						SET @nSqlAdd = @nSqlAdd + 'AND REPLACE(TAX_ID,''-'','''') = ''' + REPLACE(@vTaxId,'-','') + ''' '	--added replace knakra
				END
		END		

		----dsharma70 HMI starts
		IF @oEmpMatchByDOB <> 0 AND @BirthDateAvlbl <> 0
		BEGIN
			IF @vBirthDate IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg=@vErrorMsg +'Match by Date of Birth is selected but Employee Date of Birth is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				BEGIN
					IF @nSqlAdd IS NULL OR @nSqlAdd = ''
						SET @nSqlAdd = 'WHERE BIRTH_DATE = ''' + @vBirthDate + ''' '
					ELSE
						SET @nSqlAdd = @nSqlAdd + 'AND BIRTH_DATE = ''' + @vBirthDate + ''' '
				END
		END		
		----dsharma70 HMI ends	
		 	
		----AKumar523 starts 
		IF @oCreateNewEmp <> 0					
				SET @oCreateNewEntity = 1;
		----AKumar523  starts 
		
		
	END
	ELSE
	BEGIN
		
		--IF @iUseTaxId = 0 AND @oNonEmpMatchByName = 0  dsharma70 hmi
		IF @iUseTaxId = 0 AND @oNonEmpMatchByName = 0 and @oNonEmpMatchByDOB = 0 --dsharma70 hmi
		BEGIN
			SET @oNonEmpMatchByName = 1
			SET @oNonEmpMatchByTaxId = 0
		END

		--DSHARMA70 hmi starts				
		IF @BirthDateAvlbl = 0 AND @oNonEmpMatchByName = 0 AND @oNonEmpMatchByTaxId = 0 
		BEGIN
			SET @oNonEmpMatchByName = 1
			SET @oNonEmpMatchByDOB = 0
		END		
		--DSHARMA70 hmi Ends

		IF @oNonEmpMatchByName <> 0
		BEGIN
			IF @vLastName IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg= @vErrorMsg + 'Non Employee match by Name is selected but Non Employee Name is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
			BEGIN
					IF @nSqlAdd IS NULL OR @nSqlAdd = ''			
						SET @nSqlAdd = 'WHERE LAST_NAME = ''' + @vLastName + ''' '							
					ELSE			
						SET @nSqlAdd = @nSqlAdd + 'AND LAST_NAME = ''' + @vLastName + ''' '							
			
					IF @vFirstName IS NOT NULL AND @vFirstName <> ''
						SET @nSqlAdd = @nSqlAdd + 'AND FIRST_NAME = ''' + @vFirstName + ''' '
				                                                    
		    END
		END
		
		IF @oNonEmpMatchByTaxId <> 0 AND @iUseTaxId = 1
		BEGIN
			IF @vTaxId IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg= @vErrorMsg + 'Non Employee match by TaxId is selected but Non Employee TaxId is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				BEGIN
				IF @nSqlAdd IS NULL Or @nSqlAdd = ''			
					SET @nSqlAdd = 'WHERE REPLACE(TAX_ID,''-'','''') = ''' + REPLACE(@vTaxId,'-','') + ''' '	--added replace knakra	
				ELSE			
					SET @nSqlAdd = @nSqlAdd + 'AND REPLACE(TAX_ID,''-'','''') = ''' + REPLACE(@vTaxId,'-','') + ''' '	--added replace knakra
				END			
		END

		----dsharma70 starts
		IF @oNonEmpMatchByDOB <> 0 AND @BirthDateAvlbl <> 0
		BEGIN
			IF @vBirthDate IS NULL
			BEGIN
				IF @vErrorMsg <> ''
					SET @vErrorMsg = @vErrorMsg + '\n'
				SET @vErrorMsg=@vErrorMsg +'Non Employee Match by Date of Birth is selected but Non Employee Date of Birth is not given in import file.'
				SET @vErrorCount=@vErrorCount+1;
			END
			ELSE
				BEGIN
					IF @nSqlAdd IS NULL OR @nSqlAdd = ''
						SET @nSqlAdd = 'WHERE BIRTH_DATE = ''' + @vBirthDate + ''' '
					ELSE
						SET @nSqlAdd = @nSqlAdd + 'AND BIRTH_DATE = ''' + @vBirthDate + ''' '
				END
		END		
		----dsharma70 ends		
		
	END
	
	SET @nSql = @nSql + @nSqlAdd + N'AND DELETED_FLAG = 0 '
	SET @nSqlCount = @nSqlCount + @nSqlAdd + N'AND DELETED_FLAG = 0 '	--knakra
	
	IF @iUseTableId <> 0
	BEGIN	--knakra
		SET @nSql = @nSql + N'AND ENTITY_TABLE_ID = @pTableId'   --neha
		SET @nSqlCount = @nSqlCount + N'AND ENTITY_TABLE_ID = @pTableId'  --neha	--knakra
	END	--knakra

	--SET @nSql = @nSql + ' GROUP BY ENTITY_ID'	--knakra
	
	IF @vErrorCount > 0 OR @vErrorMsg <> ''
		RETURN	

	--EXECUTE sp_executesql @nSql,	--knakra(commented below part)
	--N' @pEntId int OUTPUT, @pCount int OUTPUT,@iTableId AS INT', 
	--@pEntId = @iEntityId OUTPUT,
	--@pCount = @iCount OUTPUT,
	--@iTableId = @iTableId

	--knakra starts
	EXECUTE sp_executesql @nSql,
	N' @pEntId int OUTPUT, @pTableId AS INT',   --neha
	@pEntId = @iEntityId OUTPUT,	
	@pTableId = @iTableId    ---neha
		
	EXECUTE SP_EXECUTESQL @nSqlCount,
	N' @pCount INT OUTPUT, @pTableId INT',
	@pCount = @iCount OUTPUT,
	@pTableId = @iTableId
	--knakra ends

	END TRY
	BEGIN CATCH
		SET @vCurrentErrorLoc='SYSERR3'
		SET @vSysErrorMsg=ERROR_MESSAGE();
		EXEC DDS_ERROR_LOG_CAPTURE
						@p_JOBID=@pJobId, 
						@p_DA_ROW_ID=@pDaRowId, 
						@p_MODULE_NAME=@pModuleName,
						@p_CALLING_ERROR_LOCATION=@pCallingErrorLoc,  
						@p_CURRENT_ERROR_LOCATION=@vCurrentErrorLoc,
						@p_ERROR_PROC_NAME=@vProcName,
						@p_ERROR_MSG=@vSysErrorMsg,
						@p_ERROR_COLUMNS=NULL,
						@p_ERROR_TABLE_TO_CHECK=@vErrorTableToCheck,
						@p_ERROR_KEY_COLUMN=@vKeycolumn, 
						@P_ERROR_COLUMN_KEY_VALUE=@pErrorKeyColumnValue,
						@P_IS_VALIDATION=0;
		SET @vErrorCount=@vErrorCount+1;
	END CATCH
	
	IF @oChkDupEntity = 1 AND @iCount > 1
	BEGIN
		SET @iEntityId = 0
		IF @vErrorMsg <> ''
			SET @vErrorMsg = @vErrorMsg + '\n'
		SET @vErrorMsg= @vErrorMsg + 'Duplicate Entity exists for the selected matching criteria.'
		SET @vErrorCount=@vErrorCount+1;
		RETURN
	END
	----akumar523 RMA-62518
	IF ( @iEntityId = 0 AND @oCreateNewEntity = 0 ) AND (@iForceCrtEnt = 0) 
	BEGIN
		SET @vErrorMsg =@vErrorMsg+'Entity not found with the matching criteria selected and create new entity check box is also not selected'
		SET @vErrorCount=@vErrorCount+1;
		RETURN
	END
	
	IF (@iEntityId = 0 AND @oCreateNewEmp=0 AND @vTableName = 'EMPLOYEES') AND @iForceCrtEnt = 0
	BEGIN
		IF @vErrorMsg <> ''
			SET @vErrorMsg = @vErrorMsg + '\n'
		SET @vErrorMsg= @vErrorMsg + 'Employee not found with the matching criteria selected and create new employee check box is also not selected.'
		SET @vErrorCount=@vErrorCount+1;
		RETURN
	END
	
	INSERTION:	--knakra
	IF (@iEntityId = 0 AND @oCreateNewEntity=1) OR (@iForceCrtEnt <> 0)
	BEGIN
		SET @vLastNameSoundex = SOUNDEX(@vLastName) 
		IF @vLastName LIKE'%''''%' OR @vFirstName LIKE'%''''%' OR @vAddr1 LIKE'%''''%'OR @vAddr2 LIKE'%''''%'OR @vComment LIKE'%''''%'    --ddhupar JIRA 78172 starts
				BEGIN 
				SET @vLastName = REPLACE(@vLastName,'''''','''')
				SET @vFirstName = REPLACE(@vFirstName,'''''','''') 
				SET @vAddr1 = REPLACE(@vAddr1,'''''','''') 
				SET @vAddr2 = REPLACE(@vAddr2,'''''','''') 
				SET @vComment = REPLACE(@vComment,'''''','''')  --ddhupar JIRA 78172 ends
				END
		
		BEGIN TRY
			SET @nSql = 'SELECT @pNxtUnqId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''ENTITY'''
			EXECUTE SP_EXECUTESQL @nSql, N'@pNxtUnqId int OUTPUT', @pnxtUnqId = @iEntityId OUTPUT
		
			IF @vErrorCount=0
			BEGIN
				
				SET @nSql = 'INSERT INTO ' + @vDbName + 'ENTITY(ENTITY_ID, LAST_NAME, LAST_NAME_SOUNDEX, FIRST_NAME, MIDDLE_NAME, ABBREVIATION, TAX_ID, ADDR1,';
				SET @nSql = @nSql + 'ADDR2, CITY, COUNTRY_CODE, STATE_ID, COUNTY, ZIP_CODE, PHONE1, PHONE2, FAX_NUMBER, SEX_CODE, BIRTH_DATE,';
				SET @nSql = @nSql + 'COMMENTS, PARENT_EID, ENTITY_TABLE_ID, REPORT_1099_FLAG, NAME_TYPE, DELETED_FLAG, SUFFIX_COMMON,';
				SET @nSql = @nSql + 'PREFIX,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER) VALUES(@P_ENTITY_ID,@P_LAST_NAME,@P_LAST_NAME_SOUNDEX,@P_FIRST_NAME,@P_MIDDLE_NAME,@P_ABBREVIATION,@P_TAX_ID,@P_ADDR1,';
				SET @nSql = @nSql + '@P_ADDR2,@P_CITY,@P_COUNTRY_CODE, @P_STATE_ID, @P_COUNTY, @P_ZIP_CODE, @P_PHONE1, @P_PHONE2, @P_FAX_NUMBER, @P_SEX_CODE, @P_BIRTH_DATE,';
				SET @nSql = @nSql + '@P_COMMENTS, @P_PARENT_EID, @P_ENTITY_TABLE_ID, @P_REPORT_1099_FLAG, @P_NAME_TYPE, @P_DELETED_FLAG, @P_SUFFIX_COMMON,';
				SET @nSql = @nSql + '@P_PREFIX,@P_DTTM_RCD_ADDED,@P_DTTM_RCD_LAST_UPD,@P_ADDED_BY_USER,@P_UPDATED_BY_USER)';
				
				IF (@vTaxId <> 0 AND @vTaxId IS NOT NULL)
				BEGIN
					EXECUTE DDS_SSN_IMPORT @vTaxId OUTPUT, @vState, @vDbName --asharma590 jira 77660
				END
				EXEC SP_EXECUTESQL @nSql,
				N'@P_ENTITY_ID INT,
				@P_LAST_NAME VARCHAR(255),
				@P_LAST_NAME_SOUNDEX VARCHAR(8),
				@P_FIRST_NAME VARCHAR(255),
				@P_MIDDLE_NAME VARCHAR(255),
				@P_ABBREVIATION VARCHAR(25),
				@P_TAX_ID VARCHAR(20),
				@P_ADDR1 VARCHAR(100),
				@P_ADDR2 VARCHAR(100),
				@P_CITY VARCHAR(50),
				@P_COUNTRY_CODE INT,
				@P_STATE_ID INT,
				@P_COUNTY VARCHAR(30), 
				@P_ZIP_CODE VARCHAR(10), 
				@P_PHONE1 VARCHAR(30), 
				@P_PHONE2 VARCHAR(30), 
				@P_FAX_NUMBER VARCHAR(30), 
				@P_SEX_CODE INT, 
				@P_BIRTH_DATE VARCHAR(8),
				@P_COMMENTS NVARCHAR(MAX), 
				@P_PARENT_EID INT, 
				@P_ENTITY_TABLE_ID INT, 
				@P_REPORT_1099_FLAG INT, 
				@P_NAME_TYPE INT, 
				@P_DELETED_FLAG INT, 
				@P_SUFFIX_COMMON INT,
				@P_PREFIX INT,
				@P_DTTM_RCD_ADDED VARCHAR(14),
				@P_DTTM_RCD_LAST_UPD VARCHAR(14),
				@P_ADDED_BY_USER VARCHAR(50),
				@P_UPDATED_BY_USER VARCHAR(50)',
				@P_ENTITY_ID =@iEntityId ,
				@P_LAST_NAME = @vLastName,
				@P_LAST_NAME_SOUNDEX =@vLastNameSoundex,
				@P_FIRST_NAME=@vFirstName,
				@P_MIDDLE_NAME=@vMiddleName,
				@P_ABBREVIATION =@vAbbr,
				@P_TAX_ID =@vTaxId,
				@P_ADDR1 =@vAddr1,
				@P_ADDR2 =@vAddr2,
				@P_CITY =@vCity,
				@P_COUNTRY_CODE =@vCountry,  
				@P_STATE_ID =@vState,    
				@P_COUNTY =@vCounty, 
				@P_ZIP_CODE =@vZip, 
				@P_PHONE1 =@vPhone1, 
				@P_PHONE2=@vPhone2, 
				@P_FAX_NUMBER =@vFaxNumber, 
				@P_SEX_CODE=@vSexCode,    
				@P_BIRTH_DATE =@vBirthDate,
				@P_COMMENTS =@vComment, 
				@P_PARENT_EID =@iParentEid,  
				@P_ENTITY_TABLE_ID =@iTableId, 
				@P_REPORT_1099_FLAG =@iRpt1099Flag,  
				@P_NAME_TYPE =@iNameType,   
				@P_DELETED_FLAG =0,   
				@P_SUFFIX_COMMON =@iSuffixCodeId,  
				@P_PREFIX =@iPrefixCodeId,  
				@P_DTTM_RCD_ADDED=@vSysDate,
				@P_DTTM_RCD_LAST_UPD=@vSysDate,
				@P_ADDED_BY_USER='DA DDS',
				@P_UPDATED_BY_USER='DA DDS';    
				
				SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID = NEXT_UNIQUE_ID + 1 WHERE SYSTEM_TABLE_NAME = ''ENTITY'''
				EXECUTE SP_EXECUTESQL @nSql			
			END
		END TRY
		BEGIN CATCH
			SET @vCurrentErrorLoc='SYSERR5'
			SET @vSysErrorMsg=ERROR_MESSAGE();
			EXEC DDS_ERROR_LOG_CAPTURE
						@p_JOBID=@pJobId, 
						@p_DA_ROW_ID=@pDaRowId, 
						@p_MODULE_NAME=@pModuleName,
						@p_CALLING_ERROR_LOCATION=@pCallingErrorLoc,  
						@p_CURRENT_ERROR_LOCATION=@vCurrentErrorLoc,
						@p_ERROR_PROC_NAME=@vProcName,
						@p_ERROR_MSG=@vSysErrorMsg,
						@p_ERROR_COLUMNS=NULL,
						@p_ERROR_TABLE_TO_CHECK=@vErrorTableToCheck,
						@p_ERROR_KEY_COLUMN=@vKeycolumn, 
						@P_ERROR_COLUMN_KEY_VALUE=@pErrorKeyColumnValue,
						@P_IS_VALIDATION=0;
			SET @vErrorCount=@vErrorCount+1;
			SET @iEntityId = 0
		END CATCH
	END
	SET NOCOUNT OFF
END


