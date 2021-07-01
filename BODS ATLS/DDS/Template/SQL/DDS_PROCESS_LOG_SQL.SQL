IF OBJECT_ID('DDS_PROCESS_LOG', 'P') IS NOT NULL
    DROP PROCEDURE DDS_PROCESS_LOG;
GO

CREATE PROCEDURE DDS_PROCESS_LOG
@p_JOBID INT, 
@p_MODULE_NAME Varchar(255),
@p_PROCESS_TABLE VARCHAR(100)
  WITH EXECUTE AS CALLER
AS
--BEGIN
	SET NOCOUNT ON
/*Declaration Part*/

DECLARE @v_SQL NVARCHAR(MAX);
DECLARE @V_PROCESS_MSG NVARCHAR(4000);
DECLARE @V_COUNT INT;
DECLARE @V_COUNT_I INT;
DECLARE @V_COUNT_U INT;

-- Below declarations are for sequence number used to populate the sequence number in error_log table
DECLARE @PrintVariable VARCHAR(4000);

BEGIN

			--BEGIN TRY
			
			 SET @V_SQL = 'SELECT @V_COUNT_P = COUNT(*) from '+@p_PROCESS_TABLE+' where JOBID = @JOBID_P ';
				
				BEGIN TRY
			    Exec sp_Executesql @V_SQL, 
					N' @V_COUNT_P INT output,
					@JOBID_P varchar(255)',
					@V_COUNT_P = @V_COUNT OUTPUT,
					@JOBID_P = @P_JOBID;
	            END TRY
	            BEGIN CATCH
					PRINT  ERROR_MESSAGE() ;
                END CATCH;
                
          SET @V_PROCESS_MSG = 'Total Number of Records Read: '+ cast(@V_COUNT as varchar) + ' in ' + @p_MODULE_NAME + '.';
			
			INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES
			 (@p_JOBID,@V_PROCESS_MSG, @p_MODULE_NAME,@p_PROCESS_TABLE,1);
			 PRINT  ERROR_MESSAGE() ;
			 
			 	PRINT  @V_PROCESS_MSG ;
			 
		  SET @V_SQL = 'SELECT @V_COUNT_P = COUNT(*) from '+ @p_PROCESS_TABLE + ' where JOBID=@JOBID_P AND INVALID_ROW > 0';

			   Exec sp_Executesql @V_SQL, 
	            N' @V_COUNT_P INT output,
	            @JOBID_P varchar(255)',
	            @V_COUNT_P = @V_COUNT OUTPUT,
	            @JOBID_P= @P_JOBID;
                
              SET @V_PROCESS_MSG = 'Total Number of Records Failed : '+ cast(@V_COUNT as varchar)+' in ' + @p_MODULE_NAME +'.';
              
            INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES
			 (@p_JOBID,@V_PROCESS_MSG, @p_MODULE_NAME,@p_PROCESS_TABLE,2); 
		      
		      
		       SET @V_SQL = 'SELECT @V_COUNT_P = COUNT(*) from '+ @p_PROCESS_TABLE + ' where JOBID=@JOBID_P AND INVALID_ROW = 0';

			   Exec sp_Executesql @V_SQL, 
	            N' @V_COUNT_P INT output,
	            @JOBID_P varchar(255)',
	            @V_COUNT_P = @V_COUNT OUTPUT,
	            @JOBID_P= @P_JOBID;
	            
	          
	     --      SET @V_SQL = 'SELECT @V_COUNT_P = COUNT(*) from '+ @p_PROCESS_TABLE + ' where JOBID=@JOBID_P AND INVALID_ROW = 0 and UPDATE_ROW = 0';

			   --Exec sp_Executesql @V_SQL, 
	     --       N' @V_COUNT_P INT output,
	     --       @JOBID_P varchar(255)',
	     --       @V_COUNT_P = @V_COUNT_I OUTPUT,
	     --       @JOBID_P= @P_JOBID;  
	            
	             
	     --      SET @V_SQL = 'SELECT @V_COUNT_P = COUNT(*) from '+ @p_PROCESS_TABLE + ' where JOBID=@JOBID_P AND INVALID_ROW = 0 and UPDATE_ROW = 1';

			   --Exec sp_Executesql @V_SQL, 
	     --       N' @V_COUNT_P INT output,
	     --       @JOBID_P varchar(255)',
	     --       @V_COUNT_P = @V_COUNT_U OUTPUT,
	     --       @JOBID_P= @P_JOBID;
                
             -- SET @V_PROCESS_MSG = 'Processed Records : '+ cast(@V_COUNT as varchar)+ '. New Records : '+cast(@V_COUNT_I as varchar)+' and Updated Records: '+cast(@V_COUNT_U as varchar)+' in ' +@p_MODULE_NAME +' .';

			 SET @V_PROCESS_MSG = 'Total Number of Records Successfully Processed : '+ cast(@V_COUNT as varchar)+ ' in ' +@p_MODULE_NAME + '.';  --neha
              
            INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES
			 (@p_JOBID,@V_PROCESS_MSG, @p_MODULE_NAME,@p_PROCESS_TABLE,3); 
		      
			
SET NOCOUNT OFF;
END
