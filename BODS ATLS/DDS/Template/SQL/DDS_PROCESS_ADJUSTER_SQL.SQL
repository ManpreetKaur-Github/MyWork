IF OBJECT_ID('PROCESS_ADJUSTER','P') IS NOT NULL
	DROP PROCEDURE PROCESS_ADJUSTER
GO

CREATE PROCEDURE [dbo].[PROCESS_ADJUSTER](@P_JOBID INT, @P_DBNAME VARCHAR(MAX))
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE
	--import file variables start
	@V_RECORD_TYPE VARCHAR(25),
	@V_CLAIM_ID VARCHAR(20),
	@V_DATE VARCHAR(8),
	@V_TIME VARCHAR(6),
	@V_FIRSTNAME VARCHAR(255),
	@V_LASTNAME VARCHAR(255),
	@V_TEXT VARCHAR(255),
	@V_ADJUSTER_TYPE VARCHAR(25),
	@V_NAME_TYPE VARCHAR(25),
	--import file variable ends

	--local variables starts
	@iDaRowId INT,
	@iInvalidRow INT,
	@AdjCursor CURSOR,
	@vReqColumns VARCHAR(MAX),
	@vCodeFields VARCHAR(MAX),
	@vSysTableName VARCHAR(MAX),
	@vSysTableList VARCHAR(MAX),
	@iCodeId INT,
	@iAdjType INT,
	@iNameType INT,
	@iClaimId INT,
	@iCurRow INT,
	@iTotalRows INT,
	@vDbName VARCHAR(MAX),
	@iErrCnt INT,
	@vVal VARCHAR(255),
	@vColName VARCHAR(MAX),
	@nSql NVARCHAR(MAX),
	@iLob INT,
	@vErrMsgDesc VARCHAR(MAX),
	@iRecordType INT,
	@iAdjEiD INT,
	@nSql2 NVARCHAR(MAX),
	@utAdjuster TENTITY,
	@iPiRowId INT,
	@iClaimantRowId INT,
	@iEroleFlag INT,
	@iAdjRowId INT,
	@vText VARCHAR(MAX),
	@vString VARCHAR(MAX),
	@iAdjTextRowId INT,
	@iBaseErrCnt INT = 0,
	@vLocation VARCHAR(50),
	@vSysDateTime VARCHAR(14),
	@vCheckTime VARCHAR(6),	--JIRA 24865 knakra
	--neha JIRA 33658 starts
	@iRunStatCnt int=1,
	@vProcessMsg varchar(100),  
	@iRunCnt int=0,
	--neha JIRA 33658 ends 
	--local variables ends
	
	--Optionset Variables starts
	@oAllowNewCodes INT,
	@oEmpMatchByEmpNum INT,
	@oEmpMatchByName INT,
	@oEmpMatchByTaxId INT,
	@oNonEmpMatchByName INT,
	@oNonEmpMatchByTaxId INT,
	@oConfigId INT,
	@vValidStrtDate VARCHAR(8),
	@vValidEndDate VARCHAR(8),
	@oCurAdjFlag INT
	--Optionset Variables ends

	BEGIN TRY
		SET @vDbName = '[' + @P_DBNAME + '].[DBO].'

		SET @vLocation = 'OptionSet'

		SELECT @oAllowNewCodes = ISNULL(ALLOW_NEW_CODES,0), @oEmpMatchByEmpNum = ISNULL(EMPLOYEE_MATCH_BY_EMP_NUM,0),
		@oEmpMatchByName = ISNULL(EMPLOYEE_MATCH_BY_NAME,0),@oEmpMatchByTaxId =	ISNULL(EMPLOYEE_MATCH_BY_TAX_ID,0), 
		@oNonEmpMatchByName = ISNULL(NON_EMP_MATCH_BY_NAME,0), @oNonEmpMatchByTaxId = ISNULL(NON_EMP_MATCH_BY_TAX_ID,0),
		@oConfigId = CONFIG_ID, @vValidStrtDate = VALID_START_DATE, @vValidEndDate = VALID_END_DATE, @oCurAdjFlag = ISNULL(SET_ADJUSTER_AS_CURRENT,0)
		FROM DDS_OPTIONSET WHERE JOBID = @P_JOBID

		SET @nSql = 'SELECT @pEroleFlag = STR_PARM_VALUE FROM ' + @vDbName +'PARMS_NAME_VALUE WHERE PARM_NAME = ''USE_ENTITY_ROLE'''

		SET @vLocation = 'eRoleFlag'

		EXECUTE SP_EXECUTESQL @nSql,
		N' @pEroleFlag INT OUTPUT',
		@pEroleFlag = @iEroleFlag OUTPUT

		SET @vLocation = 'CursorCnt'

		SELECT @iTotalRows = COUNT(1) FROM DDS_ADJUSTER WHERE JOBID = @P_JOBID AND INVALID_ROW = 1	--JIRA 24815 knakra
		SET @iCurRow = 1
	END TRY
	BEGIN CATCH
		SET @vErrMsgDesc = ERROR_MESSAGE()
		EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER',@vLocation, @vLocation, 'PROCESS_ADJUSTER', @vErrMsgDesc, @vLocation, 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
		SET @iBaseErrCnt += 1
	END CATCH

	SET @AdjCursor = CURSOR LOCAL STATIC
	FOR
	SELECT * FROM DDS_ADJUSTER WHERE JOBID = @P_JOBID AND INVALID_ROW = 1	--JIRA 24815 knakra
	
	OPEN @AdjCursor

	BEGIN TRY
		SET @vLocation = 'CurSorStrt'

		FETCH FIRST FROM @AdjCursor
		INTO
		@P_JOBID,
		@iDaRowId,
		@iInvalidRow,
		@V_RECORD_TYPE,
		@V_CLAIM_ID,
		@V_DATE,
		@V_TIME,
		@V_FIRSTNAME,
		@V_LASTNAME,
		@V_TEXT,
		@V_ADJUSTER_TYPE,
		@V_NAME_TYPE

		WHILE @iCurRow <= @iTotalRows
		BEGIN
			SET @iCurRow += 1
			SET @iErrCnt = 0
			SET @iAdjType = 0
			SET @iNameType = 0
			SET @iClaimantRowId = 0
			SET @iClaimId = 0
			SET @iLob = 0
			SET @iRecordType = 0
			SET @iAdjEiD = 0
			SET @iPiRowId = 0
			SET @iAdjRowId = 0
			SET @vText = NULL
			SET @vString = NULL
			SET @iAdjTextRowId = 0
			SET @iErrCnt = 0
			SET @vCheckTime = NULL	--JIRA 24865 knakra
			
			SET @vLocation = 'MErrClmIdBlnk'

			IF @V_CLAIM_ID IS NULL
			BEGIN
				SET @vErrMsgDesc = 'Claim Id is a mandatory field and can not be left blank, skipping record. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','ClaimIdBlank', 'ClaimIdBlank', 'PROCESS_ADJUSTER',@vErrMsgDesc,@vColName, 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
				GOTO NEXTRECORD
			END

			SET @vLocation = 'MErrReqClmns'

			SET @vReqColumns = 'RECORD_TYPE|LAST_NAME|'
			WHILE CHARINDEX('|',@vReqColumns,1) > 0
			BEGIN
				SET @vColName = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
				SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))

				SET @nSql = 'SELECT @pVal = ' + @vColName + ' FROM DDS_ADJUSTER WHERE JOBID = @pJobId AND DA_ROW_ID = @pDaRowId'

				BEGIN TRY
					EXECUTE SP_EXECUTESQL @nSql,
					N'@pVal VARCHAR(MAX) OUTPUT, @pJobId INT, @pDaRowId INT',
					@pJobId = @P_JOBID,
					@pDaRowId = @iDaRowId,
					@pVal = @vVal OUTPUT

					IF @vVal IS NULL
					BEGIN
						SET @vErrMsgDesc = 'Required field is null or empty in the import file. '
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','ReqCol', 'ReqCol', 'PROCESS_ADJUSTER',@vErrMsgDesc,@vColName, 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
						SET @iErrCnt += 1
					END

				END TRY
				BEGIN CATCH
					SET @vErrMsgDesc = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','ReqColErr', 'ReqColErr', 'PROCESS_ADJUSTER',@vErrMsgDesc,@vColName, 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
					SET @iErrCnt += 1
				END CATCH		
			END
	
			SET @vLocation = 'MErrCodeFields'

			SET @vCodeFields = 'RECORD_TYPE|ADJUSTER_TYPE|NAME_TYPE|'
			SET @vSysTableList = 'ADJ_TEXT_TYPE|CLAIM_ADJUSTER_TYPE|ENTITY_NAME_TYPE|'

			WHILE CHARINDEX('|',@vCodeFields,1) > 0
			BEGIN
				SET @vColName = LEFT(@vCodeFields,CHARINDEX('|',@vCodeFields,1) - 1)
				SET @vCodeFields = RIGHT(@vCodeFields,LEN(@vCodeFields) - CHARINDEX('|',@vCodeFields,1))
				SET @vSysTableName = LEFT(@vSysTableList,CHARINDEX('|',@vSysTableList,1) - 1)
				SET @vSysTableList = RIGHT(@vSysTableList,LEN(@vSysTableList) - CHARINDEX('|',@vSysTableList,1))

				SET @vVal =( CASE
				WHEN @vColName = 'RECORD_TYPE' THEN CAST(@V_RECORD_TYPE AS VARCHAR)	
				WHEN @vColName = 'ADJUSTER_TYPE' THEN CAST(@V_ADJUSTER_TYPE AS VARCHAR)	
				WHEN @vColName = 'NAME_TYPE' THEN CAST(@V_NAME_TYPE AS VARCHAR)
				END)				

				IF @vVal IS NOT NULL AND @vVal <> ''
				BEGIN
					EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,@vVal,@vSysTableName,@oAllowNewCodes,@vDbName,@iLob,@iDaRowId,'PAYMENT','CodeValidate','DDS_PROCESS_PAYMENTS','CLAIM_ID',@vColName,'DDS_PAYMENT',@V_CLAIM_ID,@iCodeId OUTPUT
					IF (@iCodeId = 0 OR @iCodeId IS NULL)
						SET @iErrCnt += 1
				END

				IF @vColName = 'RECORD_TYPE' SET @iRecordType = @iCodeId					
				ELSE IF @vColName = 'ADJUSTER_TYPE' SET @iAdjType = @iCodeId
				ELSE IF @vColName = 'NAME_TYPE' SET @iNameType = @iCodeId
				SET @iCodeId = NULL
			END

			IF @V_DATE IS NOT NULL
			BEGIN
				IF LEN(@V_DATE) <> 8 OR ISDATE(@V_DATE) = 0 OR ISNUMERIC(@V_DATE) = 0
				BEGIN
					SET @vErrMsgDesc = 'Invalid Date format: ' + @V_DATE + '. It should be in YYYYMMDD format. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','InvalidDate', 'InvalidDate', 'PROCESS_ADJUSTER',@vErrMsgDesc,'ADJ_DATE', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
					SET @iErrCnt += 1
				END
				ELSE IF @V_DATE < @vValidStrtDate OR @V_DATE > @vValidEndDate
				BEGIN
					SET @vErrMsgDesc = 'Date Provided: ' + @V_DATE + 'is out of Valid Date Range: ' + @vValidStrtDate + ' - ' + @vValidEndDate + '. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','DateRange', 'DateRange', 'PROCESS_ADJUSTER',@vErrMsgDesc,'ADJ_DATE', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
					SET @iErrCnt += 1
				END
			END
			
			--JIRA 24865 knakra starts
			BEGIN TRY
				IF @V_TIME IS NOT NULL
					SET @vCheckTime = (select cast(CAST(STUFF(STUFF(cast(@V_TIME as varchar),3,0,':'),6,0,':')AS TIME) as varchar(100)) as time)
			END TRY
			BEGIN CATCH
				SET @vErrMsgDesc = 'Time provided: ' + @V_TIME + ', is not valid. '
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','InvalidTime', 'InvalidTime', 'PROCESS_ADJUSTER',@vErrMsgDesc,'ADJ_TIME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
				SET @iErrCnt += 1
			END CATCH
			--JIRA 24865 knakra ends

			SET @vLocation = 'MErrClmNotExist'
			
			SET @nSql = 'SELECT @pClaimId = CLAIM_ID FROM ' + @vDbName + 'CLAIM WHERE CLAIM_NUMBER = @pClaimNumber'

			BEGIN TRY
				EXECUTE SP_EXECUTESQL @nSql,
				N' @pClaimId INT OUTPUT, @pClaimNumber VARCHAR(25)',
				@pClaimNumber = @V_CLAIM_ID,
				@pClaimId = @iClaimId OUTPUT

				IF @iClaimId IS NULL OR @iClaimId = 0
				BEGIN
					SET @vErrMsgDesc = 'Claim Number: ' + @V_CLAIM_ID + ' does not exist, skipping record. '
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','ClaimNotExist', 'ClaimNotExist', 'PROCESS_ADJUSTER',@vErrMsgDesc,'CLAIM_ID', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
					GOTO NEXTRECORD
				END
			END TRY
			BEGIN CATCH
				SET @vErrMsgDesc = ERROR_MESSAGE()
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','ClmNotExistErr', 'ClmNotExistErr', 'PROCESS_ADJUSTER',@vErrMsgDesc,'CLAIM_ID', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
				GOTO NEXTRECORD
			END CATCH

			SET @vLocation = 'MErrProcessEntity'
			SET @vErrMsgDesc = ''
			INSERT INTO @utAdjuster(iJobId, iDaRowId, vLastName, vFirstName, vTableName) VALUES(@P_JOBID, @iDaRowId, @V_LASTNAME, @V_FIRSTNAME, 'ADJUSTERS')
			EXECUTE PROCESS_ENTITY @utAdjuster, @P_JOBID, @iDaRowId, @vDbName, 'ADJUSTER', 0, 0, 'AdjEnt', @V_CLAIM_ID, @iAdjEiD OUTPUT, @vErrMsgDesc OUTPUT
			,0 --dsharma70 hmi
			
			IF @iAdjEiD IS NULL OR @iAdjEiD = 0 OR @vErrMsgDesc <> ''
			BEGIN		
				EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','AdjEntity', 'AdjEntity', 'PROCESS_ADJUSTER',@vErrMsgDesc,'LAST_NAME, FIRST_NAME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
				SET @iErrCnt += 1
			END
			ELSE
			BEGIN
			
				SET @vLocation = 'MErrRoleExc'

				IF @iEroleFlag IS NOT NULL AND @iEroleFlag <> 0
				BEGIN
					SET @nSql = ' FROM ' + @vDbName + 'CODE_X_CODE CXC, ' + @vDbName + 'CODES C, ' + @vDbName + 'GLOSSARY G'
					SET @nSql += ' WHERE CXC.REL_TYPE_CODE = C.CODE_ID AND'
					SET @nSql += ' C.TABLE_ID = G.TABLE_ID AND '
					SET @nSql += ' G.SYSTEM_TABLE_NAME = ''CODE_REL_TYPE'' AND'
					SET @nSql += ' C.SHORT_CODE = ''RECRT'' AND'
					SET @nSql += ' CXC.DELETED_FLAG = 0 AND'
					SET @nSql += ' CXC.CODE2 = (SELECT TABLE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''ADJUSTERS'')'

					SET @nSql2 = 'SELECT @pPiRowId = PI_ROW_ID FROM ' + @vDbName + 'PERSON_INVOLVED WHERE PARENT_TABLE_NAME = ''CLAIM'' AND'
					SET @nSql2 += ' PARENT_ROW_ID = @pClaimId AND PI_EID = @pAdjEid AND ROLE_TABLE_ID IN(SELECT CODE1' + @nSql + ')'

					BEGIN TRY
						EXECUTE SP_EXECUTESQL @nSql2,
						N' @pPiRowId INT OUTPUT, @pClaimId INT, @pAdjEid INT',
						@pClaimId = @iClaimId,
						@pAdjEid = @iAdjEid,
						@pPiRowId = @iPiRowId OUTPUT

						IF @iPiRowId IS NOT NULL AND @iPiRowId <> 0
						BEGIN
							SET @vErrMsgDesc = 'Entity: ' + @V_LASTNAME + ' is already attached with Claim: ' + @V_CLAIM_ID + ', and can not be attached as Adjuster as per Role Combination Exclusion Mapping. '
							EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','RoleExc', 'RoleExc', 'PROCESS_ADJUSTER',@vErrMsgDesc,'LAST_NAME, FIRST_NAME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
							SET @iErrCnt += 1
						END
						ELSE
						BEGIN
							SET @nSql2 = 'SELECT @pCode1 = CXC.CODE1 ' + @nSql + ' AND CXC.CODE1 IN (SELECT TABLE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME IN(''CLAIMANTS'',''OTHER_PEOPLE'',''EMPLOYEES''))'

							EXECUTE SP_EXECUTESQL @nSql2,
							N' @pCode1 INT OUTPUT',
							@pCode1 = @iCodeId OUTPUT

							IF @iCodeId IS NOT NULL AND @iCodeId <> 0
							BEGIN
								SET @nSql = 'SELECT @pClaimantRowid = CLAIMANT_ROW_ID FROM ' + @vDbName + 'CLAIMANT WHERE CLAIM_ID = @pClaimId AND CLAIMANT_EID = @pAdjEid'

								EXECUTE SP_EXECUTESQL @nSql,
								N' @pClaimantRowId INT OUTPUT, @pClaimId INT, @pAdjEid INT',
								@pClaimId = @iClaimId,
								@pAdjEid = @iAdjEiD,
								@pClaimantRowId = @iClaimantRowId OUTPUT

								IF @iClaimantRowId IS NOT NULL AND @iClaimantRowId <> 0
								BEGIN
									SET @vErrMsgDesc = 'Entity: ' + @V_LASTNAME + ' is already attached as Claimant with Claim: ' + @V_CLAIM_ID + ' and can not be attached as adjuster as per Role Combination Exclusion. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','RoleExcClmnt', 'RoleExcClmnt', 'PROCESS_ADJUSTER',@vErrMsgDesc,'LAST_NAME, FIRST_NAME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 1
									SET @iErrCnt += 1
								END
							END			
						END

					END TRY
					BEGIN CATCH
						SET @vErrMsgDesc = ERROR_MESSAGE()
						EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','RoleExc', 'RoleExc', 'PROCESS_ADJUSTER',@vErrMsgDesc,'LAST_NAME, FIRST_NAME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
						SET @iErrCnt += 1
					END CATCH
				END

				SET @nSql = 'SELECT @pAdjRowId = ADJ_ROW_ID FROM ' + @vDbName + 'CLAIM_ADJUSTER WHERE ADJUSTER_EID = @pAdjEid AND CLAIM_ID = @pClaimId'
				
				SET @vLocation = 'MErrAdjRowId'
				
				BEGIN TRY
					EXECUTE SP_EXECUTESQL @nSql,
					N'@pAdjRowId INT OUTPUT, @pAdjEid INT, @pClaimId INT',
					@pAdjEid = @iAdjEiD,
					@pClaimId = @iClaimId,
					@pAdjRowId = @iAdjRowId OUTPUT

					IF (@iAdjRowId IS NULL OR @iAdjRowId = 0) AND @iErrCnt = 0 AND @iBaseErrCnt = 0
					BEGIN
				
						SET @nSql = 'SELECT @pAdjRowId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''CLAIM_ADJUSTER'''
						
						EXECUTE SP_EXECUTESQL @nSql,
						N' @pAdjRowId INT OUTPUT',
						@pAdjRowId = @iAdjRowId OUTPUT
						
						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');

						SET @nSql = 'INSERT INTO ' + @vDbName + 'CLAIM_ADJUSTER(ADJ_ROW_ID,ADJUSTER_EID,CLAIM_ID, CURRENT_ADJ_FLAG, ADJUSTER_TYPE'
						SET @nSql += ',DTTM_RCD_ADDED, ADDED_BY_USER, DTTM_RCD_LAST_UPD, UPDATED_BY_USER'
						SET @nSql += ') VALUES(@pAdjRowId, @pAdjEid, @pClaimId,'
						IF @oCurAdjFlag <> 0
							SET @nSql += '-1,'
						ELSE
							SET @nSql += '0,'
						SET @nSql += '@pAdjType, @pDttm, @pUsr, @pDttm, @pUsr)'		--JIRA 24813 knakra

						EXECUTE SP_EXECUTESQL @nSql,
						N' @pAdjRowId INT, @pAdjEid INT, @pClaimId INT, @pAdjType INT, @pDttm VARCHAR(14), @pUsr VARCHAR(100)',
						@pAdjRowId = @iAdjRowId,
						@pAdjEid = @iAdjEiD,
						@pClaimId = @iClaimId,
						@pAdjType = @iAdjType,
						@pDttm = @vSysDateTime,
						@pUsr = 'DA DDS'

						SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''CLAIM_ADJUSTER'''

						EXECUTE SP_EXECUTESQL @nSql

						IF @oCurAdjFlag <> 0
						BEGIN
							SET @nSql = 'UPDATE ' + @vDbName + 'CLAIM_ADJUSTER SET CURRENT_ADJ_FLAG = 0 WHERE CLAIM_ID = @pClaimId AND ADJUSTER_EID <> @pAdjEid'

							EXECUTE SP_EXECUTESQL @nSql,
							N'@pClaimId INT, @pAdjEid INT',
							@pClaimId = @iClaimId,
							@pAdjEid = @iAdjEiD
						END

						SET @nSql = 'UPDATE DDS_ADJUSTER SET INVALID_ROW = 0 WHERE JOBID = @pJobId AND DA_ROW_ID = @pDaRowId'						

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pJobId INT, @pDaRowId INT',
						@pJobId = @P_JOBID,
						@pDaRowId = @iDaRowId
						
					END
					ELSE IF @iErrCnt = 0 AND @iBaseErrCnt = 0 AND (@iAdjRowId <> 0 AND @iAdjRowId IS NOT NULL)
					BEGIN

						SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
						
						SET @nSql = 'UPDATE ' + @vDbName + 'CLAIM_ADJUSTER SET ADJUSTER_TYPE = @pAdjType'
						IF @oCurAdjFlag <> 0
							SET @nSql += ', CURRENT_ADJ_FLAG = -1'
						SET @nSql += ', DTTM_RCD_LAST_UPD = @pDttm'
						SET @nSql += ', UPDATED_BY_USER = @pUsr'
						SET @nSql += ' WHERE CLAIM_ID = @pClaimId AND ADJUSTER_EID = @pAdjEid'

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pAdjType INT, @pClaimId INT, @pAdjEid INT, @pDttm VARCHAR(14), @pUsr VARCHAR(100)',
						@pAdjType = @iAdjType,
						@pClaimId = @iClaimId,
						@pAdjEid = @iAdjEiD,
						@pDttm = @vSysDateTime,
						@pUsr = 'DA DDS'

						IF @oCurAdjFlag <> 0
						BEGIN
							SET @nSql = 'UPDATE ' + @vDbName + 'CLAIM_ADJUSTER SET CURRENT_ADJ_FLAG = 0 WHERE CLAIM_ID = @pClaimId AND ADJUSTER_EID <> @pAdjEid'

							EXECUTE SP_EXECUTESQL @nSql,
							N'@pClaimId INT, @pAdjEid INT',
							@pClaimId = @iClaimId,
							@pAdjEid = @iAdjEiD
						END

						SET @nSql = 'UPDATE DDS_ADJUSTER SET INVALID_ROW = 0 WHERE JOBID = @pJobId AND DA_ROW_ID = @pDaRowId'	--JIRA 24815 knakra

						EXECUTE SP_EXECUTESQL @nSql,
						N'@pJobId INT, @pDaRowId INT',
						@pJobId = @P_JOBID,
						@pDaRowId = @iDaRowId

					END

					IF @iErrCnt = 0 AND @iBaseErrCnt = 0
					BEGIN
						SET @vText = ''
						WHILE LEN(@V_TEXT) > 0
						BEGIN
							SET @vString = LEFT(@V_TEXT,1)
							IF (@vString = '''')    --ddhupar JIRA 78172
							 SET @vText += @vString
							IF (ASCII(@vString) >= 48 and ASCII(@vString) <= 57) OR (ASCII(@vString) >= 65 AND ASCII(@vString) <= 90) OR (ASCII(@vString) >= 97 AND ASCII(@vString) <= 122)					
								SET @vText += @vString
							SET @V_TEXT = RIGHT(@v_TEXT,(LEN(@V_TEXT) - 1))
						END
				
						IF LEN(@vText) > 0
						BEGIN
						    IF @vText LIKE'%''''%'   --ddhupar JIRA 78172 starts
				            BEGIN 
				            SET @vText = REPLACE(@vText,'''''','''')
				            END                      --ddhupar JIRA 78172 ends
							SET @nSql = 'SELECT @pAdjTextRowid = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''ADJUST_DATED_TEXT'''

							EXECUTE SP_EXECUTESQL @nSql,
							N' @pAdjTextRowId INT OUTPUT',
							@pAdjTextRowid = @iAdjTextRowId OUTPUT
					
							SET @vSysDateTime = replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
							SET @nSql = 'INSERT INTO ' + @vDbName + 'ADJUST_DATED_TEXT(ADJ_DTTEXT_ROW_ID,ADJ_ROW_ID,TEXT_TYPE_CODE,DATE_ENTERED,DATED_TEXT'
							SET @nSql += ',ADDED_BY_USER,ENTERED_BY_USER,TIME_ENTERED,DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,UPDATED_BY_USER'
							SET @nSql += ') VALUES(@pAdjTextRowId, @pAdjRowId, @pTxtTypeCode, @pDateEntered, @pDatedText,'
							SET @nSql += '@pUsr, @pUsr, @pTimeEntered, @pDttm, @pDttm, @pUsr)'

							EXECUTE SP_EXECUTESQL @nSql,
							N'@pAdjTextRowId INT, @pAdjRowId INT, @pTxtTypeCode INT, @pDateEntered VARCHAR(8),
							  @pDatedText VARCHAR(MAX), @pUsr VARCHAR(10), @pTimeEntered VARCHAR(6), @pDttm VARCHAR(14)',
							  @pAdjTextRowId = @iAdjTextRowId,
							  @pAdjRowId = @iAdjRowId,
							  @pTxtTypeCode = @iRecordType,
							  @pDateEntered = @V_DATE,
							  @pDatedText = @vText,
							  @pUsr = 'DA DDS',
							  @pTimeEntered = @V_TIME,	
							  @pDttm = @vSysDateTime
							
							SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''ADJUST_DATED_TEXT'''
							EXECUTE SP_EXECUTESQL @nSql

						END
					END

				END TRY
				BEGIN CATCH
					SET @vErrMsgDesc = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','InsAdj', 'InsAdj', 'PROCESS_ADJUSTER',@vErrMsgDesc,'LAST_NAME, FIRST_NAME', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
					SET @iErrCnt += 1
				END CATCH

			END
	

			NEXTRECORD:

			----Neha Running status code starts 33658---
			BEGIN TRY				
			SET @vLocation= 'Running_Status'
			IF @iRunStatCnt=1
			BEGIN
				SET @vProcessMsg ='Total Number of Records processed in ADJUSTER : '+ cast(@iRunStatCnt as varchar);

				SET @nSql = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
				SET @nSql =@nSql +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

				EXECUTE SP_EXECUTESQL @nSql,
				N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
				@pJOBID=@P_JOBID, @pProcessMsg=@vProcessMsg, @pModuleName='ADJUSTER_RUN',@pTableName ='DDS_ADJUSTER_RUN',@pDisplayOrder=-11
			END
			ELSE  
			IF (@iRunCnt = 1000)
			BEGIN
					SET @vProcessMsg ='Total Number of Records processed in ADJUSTER : '+ cast(@iRunStatCnt as varchar);

					SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
					SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @nSql,
					N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='ADJUSTER_RUN',@pTableName ='DDS_ADJUSTER_RUN',@pDisplayOrder=-11
					SET @iRunCnt=1;
			END
			ELSE
			IF (@iTotalRows=@iRunStatCnt)
			BEGIN
				SET @vProcessMsg ='Total Number of Records processed in ADJUSTER : '+ cast(@iRunStatCnt as varchar);
				SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
				SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

					EXECUTE SP_EXECUTESQL @nSql,
                    N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
					@pProcessDesc=@vProcessMsg, @pJobID=@P_JOBID,@pModuleName='ADJUSTER_RUN',@pTableName ='DDS_ADJUSTER_RUN',@pDisplayOrder=-11
			END

			SET @iRunStatCnt =@iRunStatCnt + 1; 
			SET @iRunCnt = @iRunCnt + 1;
			
			END TRY
			BEGIN CATCH
					SET @vErrMsgDesc = ERROR_MESSAGE()
					EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER','Run_Status', 'Run_Status','PROCESS_ADJUSTER',@vErrMsgDesc,'EXCEPTION', 'DDS_ADJUSTER','CLAIM_ID', @V_CLAIM_ID, 0
					SET @iErrCnt += 1
			END CATCH
			---Neha running status code ends 33658---

			SET @vLocation = 'MErrNextRecCursor'

			FETCH NEXT FROM @AdjCursor
			INTO
			@P_JOBID,
			@iDaRowId,
			@iInvalidRow,
			@V_RECORD_TYPE,
			@V_CLAIM_ID,
			@V_DATE,
			@V_TIME,
			@V_FIRSTNAME,
			@V_LASTNAME,
			@V_TEXT,
			@V_ADJUSTER_TYPE,
			@V_NAME_TYPE
		END

		CLOSE @AdjCursor
		DEALLOCATE @AdjCursor

		EXECUTE DDS_PROCESS_LOG @P_JOBID, 'ADJUSTER', 'DDS_ADJUSTER'  ---ADDED BY NEHA

	END TRY
	BEGIN CATCH
		SET @vErrMsgDesc = ERROR_MESSAGE()
		EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDaRowId, 'DDS_ADJUSTER',@vLocation, @vLocation, 'PROCESS_ADJUSTER',@vErrMsgDesc,'CLAIM_ID', 'DDS_ADJUSTER', 'CLAIM_ID', @V_CLAIM_ID, 0
		SET @iErrCnt += 1
		CLOSE @AdjCursor
		DEALLOCATE @AdjCursor
	END CATCH
END