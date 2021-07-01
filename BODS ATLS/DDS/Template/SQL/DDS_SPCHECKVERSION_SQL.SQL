IF OBJECT_ID('spCheckVersion','P') IS NOT NULL
	DROP PROCEDURE spCheckVersion
GO
CREATE PROCEDURE [dbo].[spCheckVersion] @vTableName VARCHAR(MAX), @vFieldName VARCHAR(MAX), @vDbName VARCHAR(MAX), @iRetVal INT OUTPUT
AS
BEGIN
	DECLARE @nSql NVARCHAR(MAX), @vColumnName VARCHAR(MAX)

	SET @vColumnName = NULL
	SET @iRetVal = 0
	SET @vDbName = '[' + @vDbName + '].'

	SET @nSql = 'SELECT @pColName = COLUMN_NAME FROM ' + @vDbName + 'INFORMATION_SCHEMA.COLUMNS WHERE'
	SET @nSql += ' COLUMN_NAME = @pColumnName AND TABLE_NAME = @pTableName AND TABLE_SCHEMA = ''DBO'''

	EXECUTE SP_EXECUTESQL @nSql,
	N' @pColName VARCHAR(MAX) OUTPUT, @pColumnName VARCHAR(MAX), @pTableName VARCHAR(MAX)',
	@pColumnName = @vFieldName,
	@pTableName = @vTableName,
	@pColName = @vColumnName OUTPUT

	IF @vColumnName IS NOT NULL AND @vColumnName = @vFieldName
		SET @iRetVal = 1

END