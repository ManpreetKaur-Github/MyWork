IF OBJECT_ID('DDS_ERROR_LOG_CAPTURE', 'P') IS NOT NULL
    DROP PROCEDURE DDS_ERROR_LOG_CAPTURE;
GO

CREATE PROCEDURE DDS_ERROR_LOG_CAPTURE
@p_JOBID INT, 
@p_DA_ROW_ID INT, 
@p_MODULE_NAME Varchar(255),
@p_CALLING_ERROR_LOCATION VARCHAR(255), -- PROCEDURE WHICH IS CALLING SUPPOSE MAIN PROC CALLING CODE PROC THEN IT IS THE LOCATION OF MAIN PROC
@p_CURRENT_ERROR_LOCATION VARCHAR(255), -- IT IS THE LOCATION OF CODE PROC 
@p_ERROR_PROC_NAME varchar(35),
@p_ERROR_MSG VARCHAR(4000), 
@p_ERROR_COLUMNS VARCHAR(4000), -- Columns in which error is coming
@p_ERROR_TABLE_TO_CHECK VARCHAR(100),
@p_ERROR_KEY_COLUMN VARCHAR(255), -- Main Column like Claim Number/ event number
@P_ERROR_COLUMN_KEY_VALUE VARCHAR(255), -- Main Column Value i.e. value of claim number and event number
@P_IS_VALIDATION INT  -- IT IS USED TO CHECK either error is system error or data related error.Data related error is having value 1 and system related error is having value 0
 WITH EXECUTE AS CALLER
AS
BEGIN
  --*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_ERROR_LOG_CAPTURE PROCEDURE STARTS ************************************************************************
--************************************************************************************************************************************************************* ****
-- If any Error is encountered from the calling proc , an insert into the error_log table is made.
-- If more than one error is encountered corresponding to the same record, An update into DDS_ERROR_LOG is made coressponing to the same JOBID , DA_ROW_ID,ERROR_TABLE_TO_CHECK and IS_VALIDATION.
-- If the Is_validation flag is 0 then It points to the syntax error encountered in the calling proc.
-- If the Is_validation flag is 1 then It points to the validation error encountered in the calling proc.
 --*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_ERROR_LOG_CAPTURE PROCEDURE ENDS ************************************************************************
--************************************************************************************************************************************************************* ****
      
 SET NOCOUNT ON
/*Declaration Part*/

DECLARE @v_SQL NVARCHAR(MAX);
DECLARE @v_ERR_LOG_ROW_ID INT; 
DECLARE @V_SYS_DATE AS VARCHAR(14);
-- Below declarations are for sequence number used to populate the sequence number in error_log table
DECLARE @v_count INT;


 SET @V_SYS_DATE=replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','');
 SET @v_SQL= 'SELECT @v_ERR_LOG_ROW_ID_p = ERR_LOG_ROW_ID FROM DDS_ERROR_LOG WHERE JOBID =@JOBID_p AND DA_ROW_ID = @DA_ROW_ID_p AND 
 ERROR_TABLE_TO_CHECK =@ERROR_TABLE_TO_CHECK_p AND IS_VALIDATION=@IS_VALIDATION_P';

 Execute sp_Executesql @v_SQL, 
 N' @v_ERR_LOG_ROW_ID_p INT OUTPUT,
 @JOBID_p INT,
 @DA_ROW_ID_p INT,
 @ERROR_TABLE_TO_CHECK_p varchar(100),
 @IS_VALIDATION_P INT ',
 @v_ERR_LOG_ROW_ID_p=@v_ERR_LOG_ROW_ID OUTPUT, 
 @JOBID_p = @p_JOBID,
 @DA_ROW_ID_p =@p_DA_ROW_ID,
 @ERROR_TABLE_TO_CHECK_p = @p_ERROR_TABLE_TO_CHECK,
 @IS_VALIDATION_P = @P_IS_VALIDATION ; 


IF @v_ERR_LOG_ROW_ID IS NULL OR @v_ERR_LOG_ROW_ID = 0
BEGIn

 SET @v_SQL = 'SELECT @dbObjects = count(1) from DDS_ERROR_LOG'
 EXEC sp_ExecuteSQL @v_SQL,
 N'@dbObjects int output',
 @dbObjects = @v_count OUTPUT;

 SET @v_count = @v_count + 1;

 IF @p_ERROR_COLUMNS IS NULL OR @p_ERROR_COLUMNS = ''
 BEGIN
 SET @p_ERROR_MSG=@p_ERROR_MSG
 END
 ELSE
 BEGIN
 SET @p_ERROR_MSG=@p_ERROR_COLUMNS + ' : ' + @p_ERROR_MSG
 END
 --If any Error is encountered from the calling proc , an insert into the error_log table is made.
 SET @v_SQL= 'INSERT INTO DDS_ERROR_LOG (ERR_LOG_ROW_ID,JOBID,DA_ROW_ID,MODULE_NAME,ERROR_TABLE_TO_CHECK ,CALLING_ERROR_LOCATION, CURRENT_ERROR_LOCATION,ERROR_PROC_NAME,
 ERROR_TIME, ERROR_DESC, IS_VALIDATION ,ERROR_COLUMNS, ERROR_KEY_COLUMN ,ERROR_KEY_COLUMN_VALUE)
 Values (@v_count_P, @p_JOBID_P,@p_DA_ROW_ID_P,@p_MODULE_NAME_P,@p_ERROR_TABLE_TO_CHECK_P,@p_CALLING_ERROR_LOCATION_P,@p_CURRENT_ERROR_LOCATION_P, @p_ERROR_PROC_NAME_P ,
 @p_SYS_DATE_P,@p_ERROR_MSG_P,@P_IS_VALIDATION_P,@p_ERROR_COLUMNS_P, @p_ERROR_KEY_COLUMN_P , @P_ERROR_COLUMN_KEY_VALUE_P )'; 
 
 Execute sp_Executesql @v_SQL, 
 N' @v_count_P int, 
 @p_JOBID_P int,
 @p_DA_ROW_ID_P int,
 @p_MODULE_NAME_P varchar(50),
 @p_ERROR_TABLE_TO_CHECK_P varchar(30),
 @p_CALLING_ERROR_LOCATION_P varchar(max),
 @p_CURRENT_ERROR_LOCATION_P varchar(max), 
 @p_ERROR_PROC_NAME_P varchar(max),
 @p_SYS_DATE_P VARCHAR(14),
 @p_ERROR_MSG_P varchar(max),
 @P_IS_VALIDATION_P int,
 @p_ERROR_COLUMNS_P varchar(max), 
 @p_ERROR_KEY_COLUMN_P varchar(50), 
 @P_ERROR_COLUMN_KEY_VALUE_P varchar(50)',
 @v_count_P	=	@v_count, 
 @p_JOBID_P	= @p_JOBID	,	
 @p_DA_ROW_ID_P	=	@p_DA_ROW_ID,	
 @p_MODULE_NAME_P	=	@p_MODULE_NAME, 
 @p_ERROR_TABLE_TO_CHECK_P	=	@p_ERROR_TABLE_TO_CHECK, 
 @p_CALLING_ERROR_LOCATION_P	=	@p_CALLING_ERROR_LOCATION,	
 @p_CURRENT_ERROR_LOCATION_P	=	@p_CURRENT_ERROR_LOCATION,	
 @p_ERROR_PROC_NAME_P = @p_ERROR_PROC_NAME,
 @p_SYS_DATE_P = @V_SYS_DATE, 
 @p_ERROR_MSG_P	= @p_ERROR_MSG,	
 @P_IS_VALIDATION_P	=	@P_IS_VALIDATION,	
 @p_ERROR_COLUMNS_P	=	@p_ERROR_COLUMNS,	
 @p_ERROR_KEY_COLUMN_P = @p_ERROR_KEY_COLUMN, 
 @P_ERROR_COLUMN_KEY_VALUE_P	= @P_ERROR_COLUMN_KEY_VALUE; 
 

END

ELSE
BEGIN
-- If more than one error is encountered corresponding to the same record, An update into DDS_ERROR_LOG is made coressponing to the
-- same JOBID , DA_ROW_ID,ERROR_TABLE_TO_CHECK and IS_VALIDATION
 SET @v_SQL= ' Update DDS_ERROR_LOG Set CALLING_ERROR_LOCATION = CALLING_ERROR_LOCATION + '' \n '' + @CALLING_ERROR_LOCATION_P,
 CURRENT_ERROR_LOCATION = CURRENT_ERROR_LOCATION + '' \n '' + @CURRENT_ERROR_LOCATION_P,
 ERROR_PROC_NAME = ERROR_PROC_NAME + '' \n '' + @ERROR_PROC_NAME_P,
 ERROR_TIME =@SYS_DATE_P ,
 ERROR_DESC = ERROR_DESC + char(13) + @ERROR_DESC_P,
 ERROR_COLUMNS = ERROR_COLUMNS + '' ; '' + @ERROR_COLUMNS_P
 WHERE JOBID =@JOBID_p AND DA_ROW_ID = @DA_ROW_ID_p AND 
 ERROR_TABLE_TO_CHECK =@ERROR_TABLE_TO_CHECK_p AND IS_VALIDATION=@IS_VALIDATION_P
';
 SET @p_ERROR_MSG = @p_ERROR_COLUMNS + ' : '+ @p_ERROR_MSG
 
 Execute sp_Executesql @v_SQL, 
 N' @CALLING_ERROR_LOCATION_P VARCHAR(MAX),
 @CURRENT_ERROR_LOCATION_P VARCHAR(MAX),
 @ERROR_PROC_NAME_P VARCHAR(4000),
 @SYS_DATE_P VARCHAR(14),
 @ERROR_DESC_P VARCHAR(MAX),
 @ERROR_COLUMNS_P VARCHAR(MAX),
 @JOBID_p INT,
 @DA_ROW_ID_p INT,
 @ERROR_TABLE_TO_CHECK_p varchar(100),
 @IS_VALIDATION_P INT',
 @CALLING_ERROR_LOCATION_P = @P_CALLING_ERROR_LOCATION,
 @CURRENT_ERROR_LOCATION_P = @p_CURRENT_ERROR_LOCATION,
 @ERROR_PROC_NAME_P = @p_ERROR_PROC_NAME,
 @ERROR_DESC_P = @p_ERROR_MSG,
 @SYS_DATE_P = @V_SYS_DATE,
 @ERROR_COLUMNS_P = @p_ERROR_COLUMNS,
 @JOBID_p = @p_JOBID,
 @DA_ROW_ID_p =@p_DA_ROW_ID,
 @ERROR_TABLE_TO_CHECK_p = @p_ERROR_TABLE_TO_CHECK,
 @IS_VALIDATION_P = @P_IS_VALIDATION;
 
 END
 
SET NOCOUNT OFF
END


