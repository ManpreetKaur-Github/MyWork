IF OBJECT_ID('DDS_SSN_IMPORT','P') IS NOT NULL
	DROP PROCEDURE DDS_SSN_IMPORT
GO

create procedure [dbo].[DDS_SSN_IMPORT](@pTax_id varchar(20) OUTPUT,@pState_id int, @vDbName varchar(100))
WITH EXECUTE AS CALLER
AS BEGIN
		SET NOCOUNT ON
	DECLARE
	@Countrycode varchar(20),
	@Countryid int,
	@SSNformat varchar(11),
	@nSql nvarchar(MAX),
	@V_SQL nvarchar(MAX);
	
	if @pState_id != 0
		BEGIN
			SET @V_SQL = 'SELECT @Countrycode = COUNTRY_ID FROM ' + @vDbName + 'STATES WHERE STATE_ROW_ID =@pState_id'
			EXECUTE SP_EXECUTESQL @V_SQL,
			N' @Countrycode VARCHAR(20) OUTPUT,
			@pState_id INT',
			@Countrycode = @Countrycode OUTPUT,
			@pState_id= @pState_id;

			SET @nSql = 'SELECT @Countryid = CODE_ID FROM '+  @vDbName +'CODES WHERE SHORT_CODE = @Countrycode AND TABLE_ID =(SELECT TABLE_ID FROM '+@vDbName +' GLOSSARY WHERE SYSTEM_TABLE_NAME = ''COUNTRY'')'
			EXECUTE SP_EXECUTESQL @nSql,
			N' @Countryid INT OUTPUT,
			@Countrycode VARCHAR(20)',
			@Countryid = @Countryid OUTPUT,
			@Countrycode =@Countrycode;
		END
	if @Countryid != 0
		BEGIN
			SET @nSql = 'SELECT @SSNformat = SSN_FORMATDESC FROM '+@vDbName + 'SSN_FORMAT WHERE COUNTRY_ID = @Countryid'
			EXECUTE SP_EXECUTESQL @nSql,
			N' @SSNformat varchar(20) OUTPUT,
			@Countryid INT',
			@SSNformat = @SSNformat OUTPUT,
			@Countryid = @Countryid;
		END
	if @SSNformat is NULL
	BEGIN
		SET @nSql = 'SELECT @SSNformat = SSN_FORMATDESC FROM '+@vDbName + 'SSN_FORMAT WHERE COUNTRY_ID = -1'
			EXECUTE SP_EXECUTESQL @nSql,
			N' @SSNformat varchar(20) OUTPUT',
			@SSNformat = @SSNformat OUTPUT;
	END
	
	if @SSNformat = '###-##-####'
	BEGIN
		SET @pTax_id = SUBSTRING(@pTax_id,1,3)+'-'+SUBSTRING(@pTax_id,4,2)+'-'+SUBSTRING(@pTax_id,6,4)
	END
	else if @SSNformat = '###-###-###'
	BEGIN
		SET @pTax_id = SUBSTRING(@pTax_id,1,3)+'-'+SUBSTRING(@pTax_id,4,3)+'-'+SUBSTRING(@pTax_id,7,3)
	END
	else if @SSNformat = '##-#######'
	BEGIN
		SET @pTax_id = SUBSTRING(@pTax_id,1,2)+'-'+SUBSTRING(@pTax_id,3,7)
	END
	RETURN 
END