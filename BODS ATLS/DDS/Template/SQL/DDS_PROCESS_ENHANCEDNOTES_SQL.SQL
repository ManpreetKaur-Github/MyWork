IF OBJECT_ID('DDS_PROCESS_ENHANCEDNOTES','P') IS NOT NULL
	DROP PROCEDURE DDS_PROCESS_ENHANCEDNOTES
GO

CREATE PROCEDURE [dbo].[DDS_PROCESS_ENHANCEDNOTES](
       @P_JOBID INT, @P_DB_NAME VARCHAR(MAX))
       WITH EXECUTE AS CALLER
       AS     
       BEGIN
              DECLARE 
              --Import file columns variable starts
              @iDA_ROW_ID                       int,
              @iJOBID                           int, 
              @iINVALID_ROW                     int,
              @vID                              varchar(25),
              @vCLAIM_OR_EVENT                  varchar(1),
              @vNOTE_TYPE                       varchar(25),
              @vUSER_TYPE                       varchar(25),
              @vNOTE_MEMO                       varchar(max),
              @vENTERED_BY                      varchar(50),
              @vDATE_ENTERED                    varchar(12),
              @vDATE_CREATED                    varchar(12),
              @vTIME_CREATED                    varchar(12),
              @vENTERED_BY_NAME                 varchar(50),
              @vCLAIMANT_LASTNAME               varchar(255),
              @vCLAIMANT_FIRSTNAME              varchar(255),
              @vCLAIMANT_SSN                    varchar(20),
              @vABBREVIATION                    varchar(25),
           --Import file Columns variable ends
           
           --UI Options Specific Variables starts
              @oEnhNotesClmtMatchByName         int,
              @oEnhNotesClmtMatchByTaxId        int,
              @oEnhNotesClmtMatchByAbb          int,
              @oAllowNewCodes                   int,
           --UI Options Specific Variables ends
           --Local Variables Declaration Starts
              @CursorEnh                        CURSOR,
              @vDbName                          varchar(max),
              @iTotalRows                       int = 0,
              @iCurrentRow						int,
              @nSql                             nvarchar(max),
              @vLocation                        varchar(max),
              @vCareTechNote                    varchar(max),
              @vErrMsgDesc						varchar(max),
              @iErrCount                        int = 0,
              @iClaimId                         int = 0,
              @iLob                             int = 0,
              @iEventId                         int = 0,
              @iCodeId                          int=0,
              @iUserType                        int=0,
              @iClPrgNoteID						int=0,
              @vSysDate                         varchar(12),
              @vSysTime                         varchar(12),
              @iClmntErr                        int,
              @vErrColumns						VARCHAR(MAX),
              @iClaimantId						int=0,
              @iClaimantRowId					int=0,
              @vValidStrtDate					varchar(8),
              @vValidEndDate					varchar(8),
              @vReqColumns						varchar(500),
              @iPos								int=0,
              @vColName							varchar(100),
              @vVal								varchar(max),
			  --neha JIRA 33658 starts
			  @iRunStatCnt						int=1, 
			  @vProcessMsg						varchar(100),  
			  @iRunCnt							int=0
			  --neha JIRA 33658 ends 
              --Local Variables Declaration ends
              
              SET NOCOUNT ON
              SET @vDbName = '[' + @P_DB_NAME + '].[DBO].'
              
              SELECT @oEnhNotesClmtMatchByName = ISNULL(ENHNOTES_CLMNT_NAME,0),@oEnhNotesClmtMatchByTaxId=ISNULL(ENHNOTES_CLMNT_TAX,0),@oEnhNotesClmtMatchByAbb=
              ISNULL(ENHNOTES_CLMNT_ABBREVIATION,0),@oAllowNewCodes=ISNULL(ALLOW_NEW_CODES,0),@vValidStrtDate = VALID_START_DATE, @vValidEndDate = VALID_END_DATE 
              FROM DDS_OPTIONSET WHERE JOBID = @P_JOBID
              
              SELECT @iTotalRows = COUNT(1) FROM DDS_ENHANCEDNOTES WHERE JOBID = @P_JOBID AND INVALID_ROW = 1
              SET @CursorEnh = CURSOR LOCAL STATIC
              FOR
              SELECT * FROM DDS_ENHANCEDNOTES WHERE JOBID = @P_JOBID AND INVALID_ROW = 1
              
              OPEN @CursorEnh
              
              FETCH FIRST FROM @CursorEnh INTO
              @iDA_ROW_ID,
              @iJOBID, 
              @iINVALID_ROW,
              @vID,
              @vCLAIM_OR_EVENT,
              @vNOTE_TYPE,
              @vUSER_TYPE,
              @vNOTE_MEMO,
              @vENTERED_BY,
              @vDATE_ENTERED,
              @vDATE_CREATED,
              @vTIME_CREATED,
              @vENTERED_BY_NAME,
              @vCLAIMANT_LASTNAME,
              @vCLAIMANT_FIRSTNAME,
              @vCLAIMANT_SSN,
              @vABBREVIATION
              
              SET @iCurrentRow = 1
              WHILE (@iTotalRows >= 1 AND @iCurrentRow <= @iTotalRows)      --CURSOR LOOP STARTING
              BEGIN
                     BEGIN TRY
                         --Re initializing local variables
                           SET @iCurrentRow = @iCurrentRow + 1
                           SET @iClaimId=0
                           SET @iLob=0
                           SET @iEventId=0
                           SET @iErrCount=0
                           SET @iUserType=0
                           SET @iClPrgNoteID=0
                           SET @iClaimantId=0
                           SET @iClaimantRowId=0
                           SET @iCodeId=0
                           
                     
                           SET @vCareTechNote = dbo.DDS_REMOVE_HTML_TAG(@vNOTE_MEMO)
                           SET @vCLAIM_OR_EVENT=UPPER(@vCLAIM_OR_EVENT)
                           
                           IF @vID IS NULL
                           BEGIN
                                  SET    @vErrMsgDesc = 'ID is a required field and can not be left empty, skipping record. '
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValId','ValId','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'ID','DDS_ENHANCEDNOTES','ID',@vID,1                           
                                  GOTO NEXTRECORD
                           END
                           
                           IF @vCLAIM_OR_EVENT IS NULL
                           BEGIN
                                  SET    @vErrMsgDesc = 'CLAIM_OR_EVENT is a required field and can not be left empty, skipping record. '
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValClaimEvent','ValClaimEvent','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'CLAIM_OR_EVENT','DDS_ENHANCEDNOTES','ID',@vID,1                           
                                  GOTO NEXTRECORD
                           END
                           
                           IF (@vCLAIM_OR_EVENT='C' OR @vCLAIM_OR_EVENT='L')
                           BEGIN
                                  SET @nSql ='SELECT @pClaimId=CLAIM_ID,@pLob=LINE_OF_BUS_CODE,@pEventId=EVENT_ID FROM ' + @vDbName + 'CLAIM WHERE CLAIM_NUMBER =@pID'
                                  BEGIN TRY
                                         EXEC SP_EXECUTESQL @nSql,N'@pClaimId int OUTPUT,@pLob int OUTPUT,@pEventId int OUTPUT,@pID varchar(25)',
                                         @pClaimId=@iClaimId OUTPUT,@pLob=@iLob OUTPUT,@pEventId=@iEventId OUTPUT,@pID=@vID
                                  END TRY
                                  BEGIN CATCH
                                         SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','SysClaimEvent','SysClaimEvent','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'CLAIM_OR_EVENT','DDS_ENHANCEDNOTES','ID',@vID,0
                                         SET @iErrCount += 1
                                  END CATCH
                           END
                           
                           IF (@iClaimId=0) and (@vCLAIM_OR_EVENT='C' OR @vCLAIM_OR_EVENT='L')
                           BEGIN
                                  SET @vErrMsgDesc ='No CLAIM exist in the database with the Claim Number =' +@vID +'. '
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValClaim','ValClaim','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'CLAIM_OR_EVENT','DDS_ENHANCEDNOTES','ID',@vID,1
                                  SET @iErrCount += 1
                           END
                           
                           IF (@vCLAIM_OR_EVENT='E')
                           BEGIN 
                                  SET @nSql ='SELECT @pEventId=EVENT_ID FROM ' + @vDbName + 'EVENT WHERE EVENT_NUMBER =@pID'
                                  BEGIN TRY
                                         EXEC SP_EXECUTESQL @nSql,N'@pEventId int OUTPUT,@pID varchar(25)',
                                         @pEventId=@iEventId OUTPUT,@pID=@vID
                                  END TRY
                                  BEGIN CATCH
                                         SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','SysEvent','SysEvent','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'CLAIM_OR_EVENT','DDS_ENHANCEDNOTES','ID',@vID,0
                                         SET @iErrCount += 1
                                  END CATCH
                           END
                           
                           IF (@iEventId=0) and (@vCLAIM_OR_EVENT='E')
                           BEGIN
                                  SET    @vErrMsgDesc ='No EVENT exist in the database with the Event Number =' +@vID +'. '
                                  EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValEvent','ValEvent','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'CLAIM_OR_EVENT','DDS_ENHANCEDNOTES','ID',@vID,1
                                  SET @iErrCount += 1
                           END
                           
                           --------REQUIRED FIELD VALIDATION STARTS-------
                           SET @vReqColumns = 'NOTE_TYPE|USER_TYPE|NOTE_MEMO|'
                           WHILE CHARINDEX('|',@vReqColumns,1) > 0		--CHECK FOR REQUIRED COLUMNS NULL IN IMPORT FILE
						   BEGIN

								SET @iPos = CHARINDEX('|',@vReqColumns,1)
								SET @vColName = LEFT(@vReqColumns,CHARINDEX('|',@vReqColumns,1) - 1)
								SET @vReqColumns = RIGHT(@vReqColumns,LEN(@vReqColumns) - CHARINDEX('|',@vReqColumns,1))
				
								SELECT @vVal =( CASE
								WHEN @vColName = 'NOTE_TYPE' THEN CAST(@vNOTE_TYPE AS VARCHAR)				
								WHEN @vColName = 'USER_TYPE' THEN CAST(@vUSER_TYPE AS VARCHAR)
								WHEN @vColName = 'NOTE_MEMO' THEN CAST(@vNOTE_MEMO AS VARCHAR)
								END)				
				
								IF @vVal IS NULL OR @vVal = ''
								BEGIN
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','NullCheck','NullCheck','DDS_PROCESS_ENHANCEDNOTES','Required Field is Null or Empty in Import file. ',@vColName,'DDS_ENHANCEDNOTES','ID',@vID,1
									SET @iErrCount += 1
								END
							END
                           
                           --------REQUIRED FIELD VALIDATION ENDS---------
                           
                           --------CODE VALIDATION STARTS-----------------
                           IF (@vNOTE_TYPE IS NOT NULL) --If Note Type is not null then fetch the Code id from the codes table
                           BEGIN
                                  EXECUTE DDS_CODE_VALIDATION_IMPORT @P_JOBID,@vNOTE_TYPE,'NOTE_TYPE_CODE',@oAllowNewCodes,@vDbName,0,@iDA_ROW_ID,'ENHANCEDNOTES','NoteTypeValidate','DDS_PROCESS_ENHANCEDNOTES','ID','NOTE_TYPE','DDS_ENHANCEDNOTES',@vID,@iCodeId OUTPUT  
                                  IF (@iCodeId = 0 OR @iCodeId IS NULL)
                                  SET @iErrCount += 1
                                  
                           END
                           --------CODE VALIDATION ENDS-------------
                           
                           --------USER TYPE VALIDATION STARTS------
                           IF (@vUSER_TYPE IS NOT NULL)
                           BEGIN
                                  SET @nSql ='SELECT @pGroupId=GROUP_ID FROM ' + @vDbName + 'USER_GROUPS WHERE GROUP_NAME =@pUserType'
                                  BEGIN TRY
                                         EXEC SP_EXECUTESQL @nSql,N'@pGroupId int OUTPUT,@pUserType varchar(25)',
                                         @pGroupId=@iUserType OUTPUT,@pUserType=@vUSER_TYPE
                                         
                                  END TRY
                                  BEGIN CATCH
                                         SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','SysUserType','SysUserType','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'USER_TYPE','DDS_ENHANCEDNOTES','ID',@vID,0
                                         SET @iErrCount += 1
                                  END CATCH
                                  
                                  IF (@iUserType=0)
                                  BEGIN
                                         IF (@vCLAIM_OR_EVENT='C' OR @vCLAIM_OR_EVENT='L')
                                                SET @vErrMsgDesc='For Claim Number = ' + @vID +', no user group exist with the USER TYPE = ' +@vUSER_TYPE+ ' in the database.'
                                         ELSE
                                                SET @vErrMsgDesc='For Event Number = ' + @vID +', no user group exist with the USER TYPE = ' +@vUSER_TYPE+ ' in the database.'
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValUserType','ValUserType','DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'USER_TYPE','DDS_ENHANCEDNOTES','ID',@vID,1
                                         SET @iErrCount += 1
                                  END
                           END
                           --------USER TYPE VALIDATION ENDS------
                           --------TAX ID VALIDATION STARTS-------
                           IF (@vCLAIM_OR_EVENT='L' AND @vCLAIMANT_SSN IS NOT NULL) AND 
                           ((LEN(REPLACE(@vCLAIMANT_SSN,'-','')) <> 9) OR ISNUMERIC(@vCLAIMANT_SSN)=0) 
                           BEGIN
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES','ValTaxID','ValTaxID','DDS_PROCESS_ENHANCEDNOTES','Please provide a valid Claimant SSN. ','CLAIMANT_SSN','DDS_ENHANCEDNOTES','ID',@vID,1
								SET @iErrCount += 1
                           END
                           --------TAX ID VALIDATION ENDS-------
                           --------DATE VALIDATION STARTS-------
                           IF (@vDATE_ENTERED IS NOT NULL)
                           BEGIN
								IF ISNUMERIC(@vDATE_ENTERED) = 0 OR LEN(@vDATE_ENTERED) <> 8 OR ISDATE(@vDATE_ENTERED) = 0
								BEGIN
									SET @vErrMsgDesc = 'Invalid Date Format: ' + @vDATE_ENTERED + ' provided in import file, it should be in YYYYMMDD format. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'ENHANCEDNOTES', 'DateFormat1', 'DateFormat1', 'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc, DATE_ENTERED, 'DDS_ENHANCEDNOTES','ID',@vID,1
									SET @iErrCount += 1
								END
								ELSE
								BEGIN
									IF @vDATE_ENTERED < @vValidStrtDate OR @vDATE_ENTERED > @vValidEndDate
									BEGIN
										SET @vErrMsgDesc = 'Date provided: ' + @vDATE_ENTERED + ' is out of valid Date Range: ' + @vValidStrtDate + ' - ' + @vValidEndDate + '. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'ENHANCEDNOTES', 'DateFormat2', 'DateFormat2', 'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc, DATE_ENTERED, 'DDS_ENHANCEDNOTES', 'ID', @vID,1
										SET @iErrCount += 1
									END
							   END	
						   END
						   
						   IF (@vDATE_CREATED IS NOT NULL)
                           BEGIN
								IF ISNUMERIC(@vDATE_CREATED) = 0 OR LEN(@vDATE_CREATED) <> 8 OR ISDATE(@vDATE_CREATED) = 0
								BEGIN
									SET @vErrMsgDesc = 'Invalid Date Format: ' + @vDATE_CREATED + ' provided in import file, it should be in YYYYMMDD format. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'ENHANCEDNOTES', 'DateFormat3', 'DateFormat3', 'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc, DATE_CREATED, 'DDS_ENHANCEDNOTES','ID',@vID,1
									SET @iErrCount += 1
								END
								ELSE
								BEGIN
									IF @vDATE_CREATED < @vValidStrtDate OR @vDATE_CREATED > @vValidEndDate 
									BEGIN
										SET @vErrMsgDesc = 'Date provided: ' + @vDATE_CREATED + ' is out of valid Date Range: ' + @vValidStrtDate + ' - ' + @vValidEndDate + '. '
										EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'ENHANCEDNOTES', 'DateFormat4', 'DateFormat4', 'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc, DATE_CREATED, 'DDS_ENHANCEDNOTES', 'ID', @vID,1
										SET @iErrCount += 1
									END
							   END	
						   END
                           --------DATE VALIDATION ENDS-------
                           --------TIME VALIDATION STARTS-----
                           IF (@vTIME_CREATED IS NOT NULL)
                           BEGIN TRY	
									DECLARE @v_CheckTime as VARCHAR(100)
									SET @v_CheckTime = (select cast(CAST(STUFF(STUFF(cast(@vTIME_CREATED as varchar),3,0,':'),6,0,':')AS TIME) as varchar(100)) as time)
						   END TRY
						   BEGIN CATCH
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID, 'ENHANCEDNOTES', 'TimeFormat', 'TimeFormat', 'DDS_PROCESS_ENHANCEDNOTES','Invalid Time Format,Please provide the Time in HHNNSS format. ', TIME_CREATED, 'DDS_ENHANCEDNOTES','ID', @vID,1
								SET @iErrCount += 1
						   END CATCH
                           
                           --------TIME VALIDATION ENDS-----
                           ----GETTING CLAIMANTS ATTACHED WITH THE CLAIM----------
                           IF (@iClaimId> 0 and @vCLAIM_OR_EVENT='L')
                           BEGIN   
                                         SET @iClmntErr = 0
                                         SET @nSql = 'SELECT @pClmntRowId = CL.CLAIMANT_ROW_ID,@pClaimantId=CL.CLAIMANT_EID FROM ' + @vDbName + 'CLAIMANT CL, ' + @vDbName + 'ENTITY E WHERE '
                                         SET @nSql += 'E.ENTITY_ID = CL.CLAIMANT_EID AND CL.CLAIM_ID = @pClaimId'
                                         SET @vErrColumns = ''
                                         IF @oEnhNotesClmtMatchByName <> 0
                                         BEGIN
                                                IF @vCLAIMANT_LASTNAME IS NULL
                                                BEGIN                                                  
                                                       SET @vErrColumns = 'CLAIMANT_LASTNAME,'
                                                       SET @iClmntErr = 1
                                                      
                                                END
                                                ELSE
                                                BEGIN
                                                       SET @nSql += ' AND E.LAST_NAME = @pLastName'
                                                       IF @vCLAIMANT_FIRSTNAME IS NOT NULL
                                                              SET @nSql += ' AND E.FIRST_NAME = @pFirstname'
                                                END
                                         END
                                         IF @oEnhNotesClmtMatchByTaxId <> 0
                                         BEGIN
                                                IF @vCLAIMANT_SSN IS NULL
                                                BEGIN
                                                       SET @vErrColumns += 'CLAIMANT_SSN,'
                                                       SET @iClmntErr = 1
                                                END
                                                ELSE                                            
                                                       SET @nSql += ' AND REPLACE(E.TAX_ID,''-'','''') = REPLACE(@pTaxId,''-'','''')'                                           
                                         END
                                         IF @oEnhNotesClmtMatchByAbb <> 0
                                         BEGIN
                                                IF @vABBREVIATION IS NULL
                                                BEGIN
                                                       SET @vErrColumns += 'ABBREVIATION'
                                                       SET @iClmntErr = 1
                                                END
                                                ELSE
                                                       SET @nSql += ' AND E.ABBREVIATION = @pAbbrv'
                                         END
                                         SET @nSql += ' AND E.DELETED_FLAG = 0'
                                         
                                         IF RIGHT(@vErrColumns,1) = ','  --Removing last comma
                                         BEGIN
											SET @vErrColumns = LEFT(@vErrColumns,LEN(@vErrColumns)-1)
                                         END
										 
                                         IF @iClmntErr = 1
                                         BEGIN
                                                SET @vLocation = 'ClaimantCheck'
                                                SET @iErrCount += 1
                                                SET @vErrMsgDesc = @vErrColumns + ' is selected in Match By criteria and no value is provided in the import file. '
                                                EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,@vErrColumns,'DDS_ENHANCEDNOTES','ID',@vID,1
                                         END
                                         ELSE
                                         BEGIN
                                                EXECUTE SP_EXECUTESQL @nSql,   
                                                N'@pClmntRowId INT OUTPUT, @pClaimantId INT OUTPUT,@pClaimId INT, @pLastName VARCHAR(255), @pFirstName VARCHAR(255), @pTaxId VARCHAR(20), @pAbbrv varchar(25)',
                                                @pClmntRowId = @iClaimantRowId OUTPUT,
                                                @pClaimantId = @iClaimantId OUTPUT,
                                                @pClaimId = @iClaimId,
                                                @pLastName = @vCLAIMANT_LASTNAME,
                                                @pFirstName = @vCLAIMANT_FIRSTNAME,
                                                @pTaxId = @vCLAIMANT_SSN,
                                                @pAbbrv = @vABBREVIATION
                                         END
                                  IF (@iClaimantId=0)  --No Claimant is attached with the Claim Number 
                                  BEGIN
                                         SET @vLocation='ValEntityClmt2'
                                         SET @vErrMsgDesc='No Claimant is attached with the Claim Number ='+@vID +'. '
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'ID','DDS_ENHANCEDNOTES','ID',@vID,1
                                         SET @iErrCount += 1
                                  END
                           END
                           
                           ----------IMPORT STARTS-----------
                           
                           SET @vSysDate=convert(varchar(8), getdate(), 112)  --- YYYYMMDD format
						   SET @vSysTime=replace(Convert (varchar(8),GetDate(), 108),':','')  ---HHNNSS format
                           IF (@iErrCount=0)
                           BEGIN
                                  BEGIN TRY
                                         SET @nSql = 'SELECT @pNxtUnqId = NEXT_UNIQUE_ID FROM ' + @vDbName + 'GLOSSARY WHERE SYSTEM_TABLE_NAME = ''CLAIM_PRG_NOTE'''
                                         EXECUTE SP_EXECUTESQL @nSql, N'@pNxtUnqId int OUTPUT', @pnxtUnqId = @iClPrgNoteID OUTPUT
                                  END TRY
                                  BEGIN CATCH
                                         SET @vLocation='SysNextUnqID'
                                         SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                                         EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'NEXTID','DDS_ENHANCEDNOTES','ID',@vID,0
                                  END CATCH
                                  BEGIN TRY
                                  IF (@iClPrgNoteID>0)
                                  BEGIN
                                         SET @nSql = 'INSERT INTO  ' + @vDbName + 'CLAIM_PRG_NOTE(CL_PROG_NOTE_ID,CLAIM_ID,EVENT_ID,ENTERED_BY,DATE_ENTERED,DATE_CREATED,TIME_CREATED,'
                                         SET @nSql =@nSql+' ATTACH_TABLE,ATTACH_RECORD_ID,TEMPLATE_ID,POLICY_ID,'
                                         SET @nSql =@nSql +' NOTE_TYPE_CODE,USER_TYPE_CODE,NOTE_MEMO,NOTE_MEMO_CARETECH,ENTERED_BY_NAME) VALUES('
                                         SET @nSql =@nSql +' @pClPrgNoteID,'
                                         IF (@vCLAIM_OR_EVENT='C')
                                                SET @nSql =@nSql +' @pClaimId,@pEventId,'
                                         ELSE 
                                                SET @nSql =@nSql +' 0,@pEventId,'
                                         IF (@vENTERED_BY IS NOT NULL)
                                                SET @nSql =@nSql +'@pEnteredBy,'
                                         ELSE
                                                SET @nSql =@nSql +'''DADDS'','
                                                
                                         IF (@vDATE_ENTERED IS NOT NULL)
                                                SET @nSql =@nSql +'@pDateEntered,'
                                         ELSE
                                                SET @nSql =@nSql +'@pSysDate,'
                                         IF (@vDATE_CREATED IS NOT NULL)
                                                SET @nSql =@nSql +'@pDateCreated,'
                                         ELSE
                                                SET @nSql =@nSql +'@pSysDate,'
                                         IF (@vTIME_CREATED IS NOT NULL)
                                                SET @nSql =@nSql +'@pTimeCreated,'
                                         ELSE
                                                SET @nSql =@nSql +'@pSysTime,' 
                                         IF (@vCLAIM_OR_EVENT='C')
                                                SET @nSql =@nSql + '''CLAIM'',@pClaimId,'
                                         ELSE IF (@vCLAIM_OR_EVENT='E')
                                                SET @nSql =@nSql + '''EVENT'',@pEventId,'
                                         ELSE 
                                                SET @nSql =@nSql + '''CLAIMANT'',@pClaimantRowId,'
                                         SET @nSql =@nSql +'0,0,@pNoteType,@pUserType,@pNoteMemo,@pCareTechNote,'
                                         IF (@vENTERED_BY_NAME IS NOT NULL)
                                                SET @nSql =@nSql + '@pEnteredByName)'
                                         ELSE
                                                SET @nSql =@nSql + '''DADDS'')'
                                                
                                        
                                         SET @vLocation='SysImportNote'       
                                        
                                                EXECUTE SP_EXECUTESQL @nSql,
                                                N'@pClPrgNoteID INT, @pClaimId INT, @pEventId INT, @pEnteredBy varchar(50),  @pDateEntered varchar(12),
                                                @pSysDate varchar(12),@pDateCreated varchar(12), @pTimeCreated varchar(12), @pSysTime varchar(12),
                                                @pClaimantRowId INT,@pNoteType INT,@pUserType INT,@pNoteMemo varchar(max),@pCareTechNote varchar(max),
                                                @pEnteredByName varchar(50)',
                                                @pClPrgNoteID=@iClPrgNoteID,@pClaimId=@iClaimId, @pEventId=@iEventId,@pEnteredBy=@vENTERED_BY,@pDateEntered=@vDATE_ENTERED,
                                                @pSysDate=@vSysDate ,@pDateCreated =@vDATE_CREATED, @pTimeCreated =@vTIME_CREATED, @pSysTime =@vSysTime,
                                                @pClaimantRowId=@iClaimantRowId,@pNoteType =@iCodeId,@pUserType=@iUserType,@pNoteMemo =@vNOTE_MEMO,
                                                @pCareTechNote=@vCareTechNote,@pEnteredByName=@vENTERED_BY_NAME
                                        
                                  END
									SET @vLocation='UpdateGlossary'
                                    SET @nSql = 'UPDATE ' + @vDbName + 'GLOSSARY SET NEXT_UNIQUE_ID += 1 WHERE SYSTEM_TABLE_NAME = ''CLAIM_PRG_NOTE'''
                                    EXECUTE SP_EXECUTESQL @nSql
                                  
                                    UPDATE DDS_ENHANCEDNOTES SET INVALID_ROW = 0 WHERE JOBID = @P_JOBID AND DA_ROW_ID = @iDA_ROW_ID
                                  END TRY
                                  BEGIN CATCH
									SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
									EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'IMPORT','DDS_ENHANCEDNOTES','ID',@vID,0
								  END CATCH
                           END
                       
                     -------------IMPORT ENDS-----------------
                           
                     END TRY
                     BEGIN CATCH
                           SET @vLocation='SysLocation1'
                           SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                           EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'EXCEPTION','DDS_ENHANCEDNOTES','ID',@vID,0
                     END CATCH
                     
                     NEXTRECORD:

					 ---Neha Running status code starts 33658---
					 BEGIN TRY	
							SET @vLocation= 'Running_Status'
							
							IF @iRunStatCnt=1
							BEGIN
								SET @vProcessMsg ='Total Number of Records processed in Enhanced Notes : '+ cast(@iRunStatCnt as varchar);

								SET @nSql = 'INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(';
								SET @nSql =@nSql +' @pJOBID,@pProcessMsg,@pModuleName,@pTableName,@pDisplayOrder)' ;

								EXECUTE SP_EXECUTESQL @nSql,
                                N'@pJOBID INT, @pProcessMsg varchar(4000), @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
								@pJOBID=@iJOBID, @pProcessMsg=@vProcessMsg, @pModuleName='ENHANCEDNOTES_RUN',@pTableName ='DDS_ENHANCEDNOTES_RUN',@pDisplayOrder=-11
							END
							ELSE  
							IF (@iRunCnt = 1000)
							BEGIN
								 SET @vProcessMsg ='Total Number of Records processed in Enhanced Notes : '+ cast(@iRunStatCnt as varchar);

								 SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
								 SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

								 EXECUTE SP_EXECUTESQL @nSql,
                                 N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
								 @pProcessDesc=@vProcessMsg, @pJobID=@iJOBID,@pModuleName='ENHANCEDNOTES_RUN',@pTableName ='DDS_ENHANCEDNOTES_RUN',@pDisplayOrder=-11
								 SET @iRunCnt=1;
							END
							ELSE
							IF (@iTotalRows=@iRunStatCnt)
							BEGIN
								SET @vProcessMsg ='Total Number of Records processed in Enhanced Notes : '+ cast(@iRunStatCnt as varchar);
								SET @nSql = 'UPDATE DDS_PROCESS_LOG_T SET PROCESS_DESC =@pProcessDesc WHERE JOBID =@pJobID AND MODULE_NAME =@pModuleName';
								SET @nSql =@nSql +' AND TABLE_NAME=@pTableName AND DISPLAY_ORDER=@pDisplayOrder';

								 EXECUTE SP_EXECUTESQL @nSql,
                                 N'@pProcessDesc varchar(4000),@pJobID INT, @pModuleName varchar(50),@pTableName varchar(50),@pDisplayOrder INT',
								 @pProcessDesc=@vProcessMsg, @pJobID=@iJOBID,@pModuleName='ENHANCEDNOTES_RUN',@pTableName ='DDS_ENHANCEDNOTES_RUN',@pDisplayOrder=-11
							END

							SET @iRunStatCnt =@iRunStatCnt + 1; 
							SET @iRunCnt = @iRunCnt + 1;
					END TRY
					BEGIN CATCH
								SET @vErrMsgDesc = ERROR_MESSAGE()
								EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @iDA_ROW_ID, 'ENHANCEDNOTES','Run_Status', 'Run_Status','ENHANCEDNOTES',@vErrMsgDesc,'EXCEPTION', 'DDS_ENHANCEDNOTES','CLAIM_ID', @vID, 0
								
					END CATCH
					---Neha running status code ends 33658---
                     
                     BEGIN TRY                         
                           FETCH NEXT FROM @CursorEnh INTO
                           @iDA_ROW_ID,
                           @iJOBID, 
                           @iINVALID_ROW,
                           @vID,
                           @vCLAIM_OR_EVENT,
                           @vNOTE_TYPE,
                           @vUSER_TYPE,
                           @vNOTE_MEMO,
                           @vENTERED_BY,
                           @vDATE_ENTERED,
                           @vDATE_CREATED,
                           @vTIME_CREATED,
                           @vENTERED_BY_NAME,
                           @vCLAIMANT_LASTNAME,
                           @vCLAIMANT_FIRSTNAME,
                           @vCLAIMANT_SSN,
                           @vABBREVIATION             
                           
                     END TRY
                     BEGIN CATCH
                           SET @vLocation='SysLocation2'
                           SET @vErrMsgDesc = ERROR_MESSAGE() + '. '
                           EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID,@iDA_ROW_ID,'ENHANCEDNOTES',@vLocation,@vLocation,'DDS_PROCESS_ENHANCEDNOTES',@vErrMsgDesc,'EXCEPTION','DDS_ENHANCEDNOTES','ID',@vID,0              
                     END CATCH
              END --While loop ends
              
              CLOSE @CursorEnh
              DEALLOCATE @CursorEnh             
              
              EXECUTE DDS_PROCESS_LOG @P_JOBID, 'ENHANCEDNOTES', 'DDS_ENHANCEDNOTES'
              
              SET NOCOUNT OFF

       END