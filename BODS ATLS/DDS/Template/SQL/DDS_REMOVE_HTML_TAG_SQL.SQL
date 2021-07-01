IF OBJECT_ID (N'DBO.DDS_REMOVE_HTML_TAG', N'FN') IS NOT NULL
    DROP FUNCTION DBO.DDS_REMOVE_HTML_TAG;
GO

CREATE FUNCTION [dbo].[DDS_REMOVE_HTML_TAG] (@HTMLText VARCHAR(MAX))
RETURNS VARCHAR(MAX)
WITH EXECUTE AS CALLER
AS
BEGIN
    DECLARE @Start INT
    DECLARE @End INT
    DECLARE @Length INT
    SET @HTMLText=replace(@HTMLText, '&nbsp;', '' );
    SET @Start = CHARINDEX('<',@HTMLText)
    SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
    SET @Length = (@End - @Start) + 1
    WHILE @Start > 0 AND @End > 0 AND @Length > 0
    BEGIN
        SET @HTMLText = STUFF(@HTMLText,@Start,@Length,'')  -----Stuff function is used to insert string at given position and delete number of characters specified from original string
        SET @Start = CHARINDEX('<',@HTMLText)
        SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
        SET @Length = (@End - @Start) + 1
    END
    RETURN LTRIM(RTRIM(@HTMLText))
END
GO


