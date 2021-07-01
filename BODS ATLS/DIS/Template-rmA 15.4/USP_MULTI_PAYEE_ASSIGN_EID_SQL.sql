/* asingh278 - MITS 38443 - DA-DIS , DataFlow correction - DF_IMPORT_FUNDS_MULTI_PAYEE_ASSIGN_PAYEE_EID*/
/*PAY_TO_THE_ORDER_OF value is calculated based upon Payee information provided in the DIS import  table funds_x_payee and inserted in RMDB*/
-- Template-rmA 15.4_DIS

IF OBJECT_ID('USP_MULTI_PAYEE_ASSIGN_EID', 'P') IS NOT NULL -- check for existing procedure
DROP PROCEDURE USP_MULTI_PAYEE_ASSIGN_EID 					--  drop procedure if exists
GO 
CREATE PROCEDURE USP_MULTI_PAYEE_ASSIGN_EID(@p_JOBID INT)   -- create procedure
AS
BEGIN														-- procedure begin

DECLARE  													-- cursor variable declaration
@DA_ROW_ID INT,
@JOBID  INT,
@ENTITY_ID  INT,
@FIRST_NAME varchar(255),
@LAST_NAME varchar(255),
@ADDR1 varchar(100),
@ADDR2 varchar(100),
@ADDR3 varchar(100),
@ADDR4 varchar(100),
@CITY varchar(50),
@STATE_ID INT,
@ZIP_CODE varchar(10),
@STAGING_ID INT,
@PHRASE_TYPE_CODE varchar(25),
@PAY_TO_THE_ORDER_OF varchar(4000),
@PAY_TO_THE_ORDER_OF_OLD varchar(4000),
@PAY_TO_THE_ORDER_OF_NEW varchar(4000)
DECLARE payee_update CURSOR									--  cursor declared
FOR															-- fetching data from tables
select FUNDS.DA_ROW_ID,FUNDS.JOBID,
ENTITY.ENTITY_ID,ENTITY.FIRST_NAME,ENTITY.LAST_NAME,ENTITY.ADDR1,ENTITY.ADDR2,ENTITY.ADDR3,ENTITY.ADDR4,ENTITY.CITY,ENTITY.STATE_ID,ENTITY.ZIP_CODE,FUNDS.STAGING_ID,
T_DIS_FUNDS_X_PAYEE.PHRASE_TYPE_CODE,
CASE WHEN													--case for "pay to the order of"
ENTITY.FIRST_NAME  IS NULL 
THEN  ENTITY.LAST_NAME ELSE 
ENTITY.FIRST_NAME  + ' '
+  ENTITY.LAST_NAME  END
AS PAY_TO_THE_ORDER_OF
FROM
ENTITY 
INNER JOIN T_DIS_ENTITY ON ENTITY.DA_ROW_ID  =  T_DIS_ENTITY.DA_ROW_ID 
INNER JOIN FUNDS ON T_DIS_ENTITY.JOBID  =  FUNDS.JOBID 
INNER JOIN T_DIS_FUNDS ON  FUNDS.DA_ROW_ID  =  T_DIS_FUNDS.DA_ROW_ID 
INNER JOIN T_DIS_FUNDS_X_PAYEE T_DIS_FUNDS_X_PAYEE ON 
T_DIS_FUNDS.TRANS_ID_SOURCE  =  T_DIS_FUNDS_X_PAYEE.TRANS_ID_SOURCE 
INNER JOIN FUNDS_X_PAYEE ON 
 FUNDS_X_PAYEE.DA_ROW_ID  =  T_DIS_FUNDS_X_PAYEE.DA_ROW_ID 
AND
 FUNDS_X_PAYEE.JOBID  =  FUNDS.JOBID 
AND ( FUNDS_X_PAYEE.PAYEE_EID  =  convert(int ,  T_DIS_ENTITY.ENTITY_ID )) 
WHERE 
FUNDS.JOBID  =  @p_JOBID and								-- getting global job_id
ENTITY.JOBID  =   @p_JOBID and								-- getting global job_id
ENTITY.INVALID_ROW  = 0

OPEN payee_update											-- cursor start
FETCH NEXT FROM payee_update								-- fetching  row
INTO														-- getting row data
@DA_ROW_ID  ,
@JOBID  ,
@ENTITY_ID  ,
@FIRST_NAME ,
@LAST_NAME ,
@ADDR1 ,
@ADDR2 ,
@ADDR3,
@ADDR4,
@CITY ,
@STATE_ID ,
@ZIP_CODE ,
@STAGING_ID ,
@PHRASE_TYPE_CODE ,
@PAY_TO_THE_ORDER_OF
WHILE @@FETCH_STATUS = 0
BEGIN														
IF (@PHRASE_TYPE_CODE is null )OR (@PHRASE_TYPE_CODE= '' )					-- replacing null or blank with 'and'
BEGIN
SET @PHRASE_TYPE_CODE=' and '
END

-- Error Handling -- 
Begin TRY
set @PAY_TO_THE_ORDER_OF_OLD = (Select PAY_TO_THE_ORDER_OF from funds where -- fetching old PAY_TO_THE_ORDER_OF from funds
STAGING_ID=@STAGING_ID and JOBID=@JOBID);
    END TRY
    BEGIN CATCH
		SET @PAY_TO_THE_ORDER_OF_OLD=NULL;
		END CATCH; 



IF (@PAY_TO_THE_ORDER_OF_OLD  IS NOT NULL)									--	calculating PAY_TO_THE_ORDER_OF 
BEGIN
SET @PAY_TO_THE_ORDER_OF_NEW =(@PAY_TO_THE_ORDER_OF +''+@PHRASE_TYPE_CODE+''+@PAY_TO_THE_ORDER_OF_OLD )
END
ELSE
BEGIN     -- Cursor looping begin
SET @PAY_TO_THE_ORDER_OF_NEW =@PAY_TO_THE_ORDER_OF
END

UPDATE funds   																 --updating calculated PAY_TO_THE_ORDER_OF 
SET PAY_TO_THE_ORDER_OF=@PAY_TO_THE_ORDER_OF_NEW
WHERE STAGING_ID=@STAGING_ID and JOBID=@JOBID; 

UPDATE funds 																--updating other values from import entity table 
SET PAYEE_EID=@ENTITY_ID,FIRST_NAME=@FIRST_NAME,LAST_NAME=@LAST_NAME,
ADDR1=@ADDR1,ADDR2=@ADDR2,ADDR3=@ADDR3,ADDR4=@ADDR4,CITY=@CITY,STATE_ID=@STATE_ID,ZIP_CODE=@ZIP_CODE
WHERE DA_ROW_ID=@DA_ROW_ID and JOBID=@JOBID;


FETCH NEXT FROM payee_update			-- fetching next row for looping
INTO									-- getting next row data for looping
@DA_ROW_ID  ,
@JOBID  ,
@ENTITY_ID  ,
@FIRST_NAME ,
@LAST_NAME ,
@ADDR1 ,
@ADDR2 ,
@ADDR3,
@ADDR4,
@CITY ,
@STATE_ID ,
@ZIP_CODE ,
@STAGING_ID ,
@PHRASE_TYPE_CODE ,
@PAY_TO_THE_ORDER_OF


END -- Cursor looping end
CLOSE payee_update				-- cursor close
DEALLOCATE  payee_update		-- cursor deallocate
END -- procedure end


