IF OBJECT_ID('[DDS_CODE_VALIDATION_IMPORT]','P') IS NOT NULL
                DROP PROCEDURE [DDS_CODE_VALIDATION_IMPORT]
GO

CREATE PROCEDURE [dbo].[DDS_CODE_VALIDATION_IMPORT]
@p_JOBID INT, 
@P_SHORT_CODE VARCHAR(255), -- Short Code
@P_SYS_TABLE_NAME VARCHAR(255), -- SYstem Table Name to Check
@P_CODE_CREATION_FLAG INT, -- It is used to check allow creation of code flag is set by user or not
@P_DB_NAME VARCHAR(255), -- It is used to fetch error msg and append into the error msg and update it again
@P_LOB VARCHAR(255), -- LOB GC, WC ( It Will be numeric)
@p_DA_ROW_ID INT, 
@p_MODULE_NAME Varchar(255),
@p_ERROR_LOCATION VARCHAR(255), 
@p_ERROR_PROC_NAME varchar(35),
@p_ERROR_KEY_COLUMN VARCHAR(4000), 
@p_ERROR_COLUMN VARCHAR(4000), 
@p_ERROR_TABLE_TO_CHECK VARCHAR(100),
@P_ERROR_COLUMN_KEY_VALUE VARCHAR(4000),
@P_CODE_ID_R INT OUT 
 WITH EXECUTE AS CALLER
AS
--BEGIN
                SET NOCOUNT ON
/*Declaration Part*/

DECLARE @v_SQL NVARCHAR(MAX);
DECLARE @V_SQL_CODES NVARCHAR(4000);
DECLARE @V_DELETED_FLAG INT;
DECLARE @V_SQL_CODES_TEXT NVARCHAR(4000);
DECLARE @V_CODEID INT;
DECLARE @V_TABLEID INT;
DECLARE @V_NEXT_UNIQUE_ID INT;
DECLARE @V_NEXT_UNIQUE_ID_G INT;
DECLARE @V_DB_NAME VARCHAR(100);  ---RMA-25298
DECLARE @V_LOCATION VARCHAR(MAX);
DECLARE @V_ERROR_MESSAGE VARCHAR(2000);
DECLARE @iUseLobFlag INT; 
DECLARE @V_SYS_DATE AS VARCHAR(14); 
DECLARE @iReqRelTblFlag INT; 
DECLARE @iReqIndTblFlag INT; 
DECLARE @iGlossaryTypeCode INT;
DECLARE @P_CODE_CREATION INT;
DECLARE @iRetVal INT; --rma-25298
DECLARE @fVersionNum decimal(10,1); --rma-25298

-- Below declarations are for sequence number used to populate the sequence number in error_log table
DECLARE @v_count INT;
DECLARE @PrintVariable VARCHAR(4000);


BEGIN
--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_CODE_VALIDATION_IMPORT PROCEDURE STARTS ************************************************************************
--*************************************************************************************************************************************************************																																					   ****
-- It fetches the table_id from glossary corresponding to the system_table_name of a particular code column.
-- Corresponding to the table_id fetched from glossary table , Code_id is fetched from codes table for that particular short_code and table_id.
-- It also created the codes for few code columns , Only if allow Creation of Check box is checked and It satisfies few conditions.
-- It also created the codes for few code columns , and code decription for the new created code is added in the codes text table.
-- In the absence of few conditions a self described Error is logged of Why the Short code has not been created for a particular Ciode column Even when
-- the allow Creation of Checkbox was checked.

--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_CODE_VALIDATION_IMPORT PROCEDURE ENDS ************************************************************************
--*************************************************************************************************************************************************************																																					   ****
                                                --RMA-25298 JIRA starts--
                                              
                                                SET @V_DB_NAME= SUBSTRING(@P_DB_NAME,2,CHARINDEX(']',@P_DB_NAME,1)-2)
                                                EXECUTE spCheckVersion 'CODES_TEXT','DTTM_RCD_ADDED',@V_DB_NAME,@iRetVal OUTPUT
												IF @iRetVal = 1
													SET @fVersionNum = 16.2
													
												--RMA-25298 JIRA ends--	                                   
                                                IF @P_SHORT_CODE IS NOT NULL  -- IF SHORT CODE IS NOT NULL THEN ONLY START CODE EXISTENCE CHECK AND CREATION WORK
                                                
                                                BEGIN
                                                BEGIN TRY
                                                                
                                                                SET @V_LOCATION = 'C1';
                                                                SET @v_SQL = 'SELECT @pUseLobFlag = LINE_OF_BUS_FLAG, @pReqRelTblFlag = REQD_REL_TABL_FLAG, @pReqIndTblFlag = REQD_IND_TABL_FLAG, @pGlossaryTypeCode = GLOSSARY_TYPE_CODE FROM ' + @P_DB_NAME + 'GLOSSARY '
                                                                SET @V_SQL = @v_SQL + 'WHERE SYSTEM_TABLE_NAME = @SYS_TABLE_NAME_P';              
                                                                
                                                                EXECUTE SP_EXECUTESQL @v_SQL,
                                                                N' @pUseLobFlag int OUTPUT, @pReqRelTblFlag int OUTPUT, @pReqIndTblFlag int OUTPUT, @pGlossaryTypeCode int OUTPUT, @SYS_TABLE_NAME_P VARCHAR(255)',
                                                                @pUseLobFlag = @iUseLobFlag OUTPUT,             
                                                                @pReqRelTblFlag = @iReqRelTblFlag OUTPUT,
                                                                @pReqIndTblFlag = @iReqIndTblFlag OUTPUT,
                                                                @pGlossaryTypeCode = @iGlossaryTypeCode OUTPUT,
                                                                @SYS_TABLE_NAME_P = @P_SYS_TABLE_NAME;

                                                                IF @iReqRelTblFlag IS NULL
                                                                                SET @iReqRelTblFlag = 0
                                                                IF @iReqIndTblFlag IS NULL
                                                                                SET @iReqIndTblFlag = 0

                                                                IF @iGlossaryTypeCode = 3
                                                                                SET @P_CODE_CREATION = 1
                                                                ELSE
                                                                                SET @P_CODE_CREATION = 0
-- It fetches the table_id from glossary corresponding to the system_table_name of a particular code column.
-- Corresponding to the table_id fetched from glossary table , Code_id is fetched from codes table for that particular short_code and table_id.

																
																SET @V_SQL = 'SELECT @V_CODEID_P = c.CODE_ID, @V_TABLEID_P = c.TABLE_ID, @V_DELETED_FLAG_p = c.DELETED_FLAG  FROM ' + @P_DB_NAME+'CODES C, '+@P_DB_NAME+'GLOSSARY G WHERE c.TABLE_ID = G.TABLE_ID';           --KNAKRA
                                                                SET @V_SQL = @V_SQL + ' AND UPPER(c.SHORT_CODE) = @SHORT_CODE_P AND G.system_TABLE_NAME = @SYS_TABLE_NAME_P'
                                                                
                                                                ---AKUMAR523 jira 62380 added @P_LOB <> 0
																IF @iUseLobFlag <> 0 AND @P_LOB <> 0
																BEGIN 
																
                                                                                SET @v_SQL = @v_SQL + ' AND C.LINE_OF_BUS_CODE = ' + CAST(ISNULL(@P_LOB,0) AS VARCHAR)                               
																END 
																				Exec sp_Executesql @V_SQL,
																				N' @V_CODEID_P varchar(255) output,
																				@V_TABLEID_P varchar(255) output,
																				@V_DELETED_FLAG_p INT OUTPUT,
																				@SHORT_CODE_P VARCHAR(255),
																				@SYS_TABLE_NAME_P VARCHAR(255)',
																				@V_CODEID_P = @V_CODEID OUTPUT,
																				@V_TABLEID_P = @V_TABLEID OUTPUT,
																				@V_DELETED_FLAG_p = @V_DELETED_FLAG OUTPUT,
																				@SHORT_CODE_P = @P_SHORT_CODE,
																				@SYS_TABLE_NAME_P = @P_SYS_TABLE_NAME;
                
                                                                SET @V_LOCATION = 'C2';
                                                                IF @V_CODEID = 0 OR @V_CODEID IS NULL
                                                                BEGIN
                                                                                SET @V_LOCATION = 'C3';
                                                                                IF @P_CODE_CREATION_FLAG = 1 AND @P_CODE_CREATION = 1 AND @iReqIndTblFlag = 0 AND @iReqRelTblFlag = 0
                                                                                BEGIN
                                                                                -- It fetches the table_id from glossary corresponding to the system_table_name of a particular code column.
-- Corresponding to the table_id fetched from glossary table , Code_id is fetched from codes table for that particular short_code and table_id.
                                                                                                SET           @V_SQL = 'SELECT @V_TABLEID_P = G.TABLE_ID FROM ' + @P_DB_NAME + 'GLOSSARY G WHERE ';
                                                                                                SET           @V_SQL = @V_SQL + ' G.system_TABLE_NAME= @SYS_TABLE_NAME_P';
                                                                                                
                                                                                                BEGIN TRY
																												Exec sp_Executesql @V_SQL,
                                                                                                                N' @V_TABLEID_P varchar(255) OUTPUT,
                                                                                                                @SYS_TABLE_NAME_P VARCHAR(255)',
                                                                                                                @V_TABLEID_P = @V_TABLEID OUTPUT,
                                                                                                                @SYS_TABLE_NAME_P = @P_SYS_TABLE_NAME;
                                                                                                                                
                                                                                                                SET @V_LOCATION = 'C4';
                                                                                                END TRY
                                                                                                BEGIN CATCH 
                                                                                                                --PRINT ERROR_MESSAGE();
                                                                                                END CATCH;                                       
                   
                                                                                                                
                                                                                                --PRINT @P_SYS_TABLE_NAME;
                                                                                                --PRINT @V_NEXT_UNIQUE_ID;
                                                                                                SET @V_LOCATION = 'C5';

                                                                                                SET           @V_SQL = 'SELECT @V_NEXT_UNIQUE_ID_P = MAX(G.CODE_ID) FROM ' + @P_DB_NAME + 'CODES G ';

                                                                                                Exec sp_Executesql @V_SQL, 
                                                                                                N' @V_NEXT_UNIQUE_ID_P varchar(255) OUTPUT',
                                                                                                @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID OUTPUT;
                                                                                                                                
                                                                                                SET           @V_NEXT_UNIQUE_ID = isnuLL(@V_NEXT_UNIQUE_ID,0) + 1;
                                                                                                SET           @V_CODEID = @V_NEXT_UNIQUE_ID;
                                                                                                SET @V_SYS_DATE=replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
                                                                                                 --It also creates the codes for few code columns , Only if allow Creation of Check box is checked and It satisfies few conditions.
                                                                                                SET @V_SQL_CODES = 'INSERT INTO '+ @P_DB_NAME + 'CODES(CODE_ID,SHORT_CODE,TABLE_ID,RELATED_CODE_ID,LINE_OF_BUS_CODE,DELETED_FLAG,IND_STANDARD_CODE, DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER) VALUES (';
                                                                                                SET @V_SQL_CODES = @V_SQL_CODES +'@V_NEXT_UNIQUE_ID_P,@SHORT_CODE_P,@V_TABLEID_P,@pRelatedCodeId,'
                                                                                                IF @iUseLobFlag <> 0    
                                                                                                                SET @V_SQL_CODES = @V_SQL_CODES + '@LOB_P,'
                                                                                                ELSE
                                                                                                                SET @V_SQL_CODES = @V_SQL_CODES + '0,'
                                                                                                
                                                                                                SET @V_SQL_CODES = @V_SQL_CODES + '0,0, @DTTM_RCD_ADDED_P,@DTTM_RCD_LAST_UPD_P,@ADDED_BY_USER_P,@UPDATED_BY_USER_P)' ;
                                                                                                BEGIN TRY
                                                                                                                Exec sp_Executesql @V_SQL_CODES,                   
                                                                                                                N' @V_NEXT_UNIQUE_ID_P INT,
                                                                                                                @SHORT_CODE_P varchar(255),
                                                                                                                @V_TABLEID_P varchar(255),
                                                                                                                @pRelatedCodeId int,                                                                                                   
                                                                                                                @LOB_P varchar(255),                                                   
                                                                                                                @DTTM_RCD_ADDED_P VARCHAR(14),
                                                                                                                @DTTM_RCD_LAST_UPD_P VARCHAR(14),
                                                                                                                @ADDED_BY_USER_P VARCHAR(100),
                                                                                                                @UPDATED_BY_USER_P VARCHAR(100)',
                                                                                                                @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID,
                                                                                                                @SHORT_CODE_P = @P_SHORT_CODE,
                                                                                                                @V_TABLEID_P = @V_TABLEID,
                                                                                                                @pRelatedCodeId  = 0, 
                                                                                                                @LOB_P = @P_LOB,                                                                                                                                                                                                                       
                                                                                                                @DTTM_RCD_ADDED_P = @V_SYS_DATE,  
                                                                                                                @DTTM_RCD_LAST_UPD_P =  @V_SYS_DATE, 
                                                                                                                @ADDED_BY_USER_P = 'DADDS',
                                                                                                                @UPDATED_BY_USER_P='DADDS';

                                                                                                                SET @V_LOCATION = 'C6';

                                                                                                END TRY 
                                                                                                BEGIN CATCH
                                                                                                                                                
                                                                                                SET @V_LOCATION = 'C7';
                                                                         -- IF CODE ID NOT EXISTS IN RM DB AND WHILE INSERTING THE DATA AND ERROR OCCURRED THEN INSERTING IN ERROR_LOG
                                   -- In the absence of few conditions a self described Error is logged of Why the Short code has not been created for a particular Ciode column Even when
-- the allow Creation of Checkbox was checked.

																								SET @V_ERROR_MESSAGE = ERROR_MESSAGE() + '. For ' + @P_ERROR_COLUMN + ':' + @P_SHORT_CODE;
                                   
																								EXEC DDS_ERROR_LOG_CAPTURE   @P_JOBID, 
																								@p_DA_ROW_ID, 
																								@p_MODULE_NAME,
																								@p_ERROR_LOCATION, 
																								@V_LOCATION,
																								@p_ERROR_PROC_NAME,
																								@V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
																								@p_ERROR_COLUMN, 
																								@p_ERROR_TABLE_TO_CHECK,
																								@p_ERROR_KEY_COLUMN,
																								@P_ERROR_COLUMN_KEY_VALUE,
																								0;

                                                                                                                
                                                                                                END CATCH;

																								BEGIN TRY   ----neha starts
																								
																								SET @V_SQL = 'UPDATE '+@P_DB_NAME+'GLOSSARY SET NEXT_UNIQUE_ID=@V_NEXT_UNIQUE_ID_P  WHERE SYSTEM_TABLE_NAME=@SYSTEM_TABLE_NAME_P'
																								SET @V_NEXT_UNIQUE_ID_G = @V_NEXT_UNIQUE_ID + 1
																								Exec sp_Executesql @V_SQL, 
																								N' @V_NEXT_UNIQUE_ID_P varchar(255),
																								@SYSTEM_TABLE_NAME_P VARCHAR(255)',
																								@V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID_G,
																								@SYSTEM_TABLE_NAME_P='CODES';

																								END TRY
																								BEGIN CATCH
                                                                                                                SET @V_LOCATION = 'C8';
                                                                                                                SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
                                   
																												EXEC DDS_ERROR_LOG_CAPTURE  @P_JOBID, 
                                                                                                                                            @p_DA_ROW_ID, 
                                                                                                                                            @p_MODULE_NAME,
                                                                                                                                            @p_ERROR_LOCATION, 
                                                                                                                                            @V_LOCATION,
                                                                                                                                            @p_ERROR_PROC_NAME,
                                                                                                                                            @V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                                                                                                            @p_ERROR_COLUMN, 
                                                                                                                                            @p_ERROR_TABLE_TO_CHECK,
                                                                                                                                            @p_ERROR_KEY_COLUMN,
                                                                                                                                            @P_ERROR_COLUMN_KEY_VALUE,
                                                                                                                                            0;
                                                                                                                                    
                                                                                                               
                                                                                                END CATCH;

																								BEGIN TRY
                                                                                                                                
                                                                                                                SET @V_LOCATION = 'C9';  
																											--It also created the codes for few code columns , and code decription for the new created code is added in the codes text table.
																											--RMA-25298 added Time and user fields
                                                                                                                SET @V_SQL_CODES_TEXT = 'INSERT INTO '+ @P_DB_NAME + 'CODES_TEXT(CODE_ID,SHORT_CODE,CODE_DESC,LANGUAGE_CODE'
                                                                                                                IF @fVersionNum >= 16.2
                                                                                                                BEGIN
																													SET @V_SQL_CODES_TEXT = @V_SQL_CODES_TEXT + ',DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER'	
                                                                                                                END
                                                                                                                SET @V_SQL_CODES_TEXT = @V_SQL_CODES_TEXT + ') VALUES (';
                                                                                                                SET @V_SQL_CODES_TEXT = @V_SQL_CODES_TEXT + '@V_NEXT_UNIQUE_ID_P,@SHORT_CODE_P1,@SHORT_CODE_P2,@V_NON_VALUE_P'
                                                                                                                IF @fVersionNum >= 16.2
                                                                                                                BEGIN
																													SET @V_SQL_CODES_TEXT = @V_SQL_CODES_TEXT + ',@V_DTTM_RCD_ADDED_P,@V_DTTM_RCD_LAST_UPD_P,@V_ADDED_BY_USER_P,@V_UPDATED_BY_USER_P'	
                                                                                                                END
                                                                                                                SET @V_SQL_CODES_TEXT = @V_SQL_CODES_TEXT + ')';
																												
                                                                                                                Exec sp_Executesql @V_SQL_CODES_TEXT, 
                                                                                                                N' @V_NEXT_UNIQUE_ID_P INT,
                                                                                                                @SHORT_CODE_P1 varchar(255),
                                                                                                                @SHORT_CODE_P2 varchar(255),
                                                                                                                @v_NON_VALUE_P INT,
                                                                                                                @V_DTTM_RCD_ADDED_P varchar(14),
                                                                                                                @V_DTTM_RCD_LAST_UPD_P varchar(14),
                                                                                                                @V_ADDED_BY_USER_P varchar(50),
                                                                                                                @V_UPDATED_BY_USER_P varchar(50)',
                                                                                                                @V_NEXT_UNIQUE_ID_P = @V_NEXT_UNIQUE_ID,
                                                                                                                @SHORT_CODE_P1 = @P_SHORT_CODE,
                                                                                                                @SHORT_CODE_P2 = @P_SHORT_CODE,
                                                                                                                @v_NON_VALUE_P  = 1033,
                                                                                                                @V_DTTM_RCD_ADDED_P =@V_SYS_DATE,
                                                                                                                @V_DTTM_RCD_LAST_UPD_P=@V_SYS_DATE,
                                                                                                                @V_ADDED_BY_USER_P='DADDS',
                                                                                                                @V_UPDATED_BY_USER_P ='DADDS';               
                                                                                                                SET @V_LOCATION = 'C10';
                                                                                                                                                
                                                                                                END TRY 
                                                                                                BEGIN CATCH
                                                                                                                SET @V_LOCATION = 'C11';
                                                                                                                SET @V_ERROR_MESSAGE = ERROR_MESSAGE() + '. For ' + @P_ERROR_COLUMN + ':' + @P_SHORT_CODE;
                                   
																												EXEC DDS_ERROR_LOG_CAPTURE  @P_JOBID, 
                                                                                                                                            @p_DA_ROW_ID, 
                                                                                                                                            @p_MODULE_NAME,
                                                                                                                                            @p_ERROR_LOCATION, 
                                                                                                                                            @V_LOCATION,
                                                                                                                                            @p_ERROR_PROC_NAME,
                                                                                                                                            @V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                                                                                                            @p_ERROR_COLUMN, 
                                                                                                                                            @p_ERROR_TABLE_TO_CHECK,
                                                                                                                                            @p_ERROR_KEY_COLUMN,
                                                                                                                                            @P_ERROR_COLUMN_KEY_VALUE,
                                                                                                                                            0;
                                                                                                                                    
                                                                                                               
                                                                                                END CATCH;                       
                                                                                                                                
                                                                                                                                                                                              
                                                END;
                                                ELSE
                                                BEGIN
                                                                                                SET @V_LOCATION = 'C14';
                                                                -- WHEN NO FLAG IS SET TO CREATE A NEW CODES THEN ERROR WILL BE LOGGED
                                                                                                SET @V_CODEID = 0; -- When no data has been found in codes table and creation flags are not set
                                                                                                IF @iReqIndTblFlag <> 0 OR @iReqRelTblFlag <> 0 --mkaur24     JIRA RMA-23448                                                                             
                                                                                                                SET @V_ERROR_MESSAGE = 'The Code ''' + @P_SHORT_CODE + ''' is not found in codes table of RMDB for ' + @p_ERROR_COLUMN + ' and it needs to be created from rmA-UI as it requires either Related Code Id or Industry Standard Code';                                                                                        
                                                                                                ELSE                                                                                       
                                                                                                                SET @V_ERROR_MESSAGE = 'The Code ''' + @P_SHORT_CODE + ''' is not found in codes table of RMDB for ' + @p_ERROR_COLUMN + ', either it is not user defined code or Allow Creation of New Codes is not selected';
                                                                                                
                                                
                                                                                                                EXEC DDS_ERROR_LOG_CAPTURE  @P_JOBID, 
                                                                                                                                            @p_DA_ROW_ID, 
                                                                                                                                            @p_MODULE_NAME,
                                                                                                                                            @p_ERROR_LOCATION, 
                                                                                                                                            @V_LOCATION,
                                                                                                                                            @p_ERROR_PROC_NAME,
                                                                                                                                            @V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                                                                                                            @p_ERROR_COLUMN, 
                                                                                                                                            @p_ERROR_TABLE_TO_CHECK,
                                                                                                                                            @p_ERROR_KEY_COLUMN,
                                                                                                                                            @P_ERROR_COLUMN_KEY_VALUE,
                                                                                                                                            1;
                                    END;                                  
                                                                END;
                                                
                                                
                                                                IF @V_DELETED_FLAG <>0 AND @P_CODE_CREATION_FLAG = 1 AND @P_CODE_CREATION = 1 
                                                                BEGIN
                                                                                SET @V_LOCATION = 'C15';
                                                                                SET @V_SQL = 'UPDATE '+@P_DB_NAME+'CODES SET DELETED_FLAG = 0, DTTM_RCD_LAST_UPD = @DTTM_RCD_LAST_UPD_P  WHERE '
                                                                                
                                                                                IF @iUseLobFlag <> 0
                                                                                                SET @v_SQL = @v_SQL + 'LINE_OF_BUS_CODE = @LOB_P';
                                                                                ELSE
                                                                                                SET @V_SQL = @v_SQL + 'LINE_OF_BUS_CODE = 0'

                                                                                SET @V_SQL = @V_SQL + ' AND UPPER(SHORT_CODE) = @SHORT_CODE_P  AND TABLE_ID =(SELECT TABLE_ID FROM '+@P_DB_NAME+'GLOSSARY WHERE system_TABLE_NAME = @SYS_TABLE_NAME_P)';
                                                                               
                                                                                
                                                                                Exec sp_Executesql @V_SQL, 
                                                                                N' @LOB_P varchar(255),
                                                                                @SHORT_CODE_P VARCHAR(255),
                                                                                @SYS_TABLE_NAME_P VARCHAR(255),
                                                                                @DTTM_RCD_LAST_UPD_P VARCHAR(14)',
                                                                                @LOB_P = @P_LOB,
                                                                                @SHORT_CODE_P = @P_SHORT_CODE,
                                                                                @DTTM_RCD_LAST_UPD_P = @V_SYS_DATE, 
                                                                                @SYS_TABLE_NAME_P = @P_SYS_TABLE_NAME;

                                                                                SET @V_LOCATION = 'C16';
                                                                END
                                                                ELSE IF  @V_DELETED_FLAG <>0 AND @P_CODE_CREATION_FLAG = 1 AND @P_CODE_CREATION <> 1 
                                                                BEGIN
                                                                                SET @V_LOCATION = 'C17';
                                                                                SET @V_ERROR_MESSAGE = 'The Code ''' + @P_SHORT_CODE + ''' is found in codes table of RMDB but its deleted flag is -1 for ' + @p_ERROR_COLUMN;
                                                                                EXEC DDS_ERROR_LOG_CAPTURE  @P_JOBID, 
                                                                                                            @p_DA_ROW_ID, 
                                                                                                            @p_MODULE_NAME,
                                                                                                            @p_ERROR_LOCATION, 
                                                                                                            @V_LOCATION,
                                                                                                            @p_ERROR_PROC_NAME,
                                                                                                            @V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                                                                            @p_ERROR_COLUMN, 
                                                                                                            @p_ERROR_TABLE_TO_CHECK,
                                                                                                            @p_ERROR_KEY_COLUMN,
                                                                                                            @P_ERROR_COLUMN_KEY_VALUE,
                                                                                                            1;
                                                                END
                                                
                                                
                                                END TRY
                                                BEGIN CATCH
                                                
                                                               
                                                                SET @V_LOCATION = 'C19';
                                                                SET @V_ERROR_MESSAGE = ERROR_MESSAGE() + '. For ' + @p_ERROR_KEY_COLUMN + ':' + @P_ERROR_COLUMN_KEY_VALUE;
                                                                EXEC DDS_ERROR_LOG_CAPTURE  @P_JOBID, 
                                                                                            @p_DA_ROW_ID, 
                                                                                            @p_MODULE_NAME,
                                                                                            @p_ERROR_LOCATION, 
                                                                                            @V_LOCATION,
                                                                                            @p_ERROR_PROC_NAME,
                                                                                            @V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                                                            @p_ERROR_COLUMN, 
                                                                                            @p_ERROR_TABLE_TO_CHECK,
                                                                                            @p_ERROR_KEY_COLUMN,
                                                                                            @P_ERROR_COLUMN_KEY_VALUE,
                                                                                            0;
                                                                
                                                                

                                                END CATCH         
                                                END
SET @P_CODE_ID_R = @V_CODEID;         
SET NOCOUNT OFF;
END
