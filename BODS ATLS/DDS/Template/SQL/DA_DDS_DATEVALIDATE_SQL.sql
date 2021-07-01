IF OBJECT_ID (N'DBO.DATEVALIDATE', N'FN') IS NOT NULL
    DROP FUNCTION DATEVALIDATE;
GO
CREATE FUNCTION DBO.DATEVALIDATE(@P_DATE VARCHAR(8))
RETURNS INT
WITH EXECUTE AS CALLER
AS 
BEGIN
	DECLARE @V_VALIDDATE INT

	-- User Defined Function to check various aspects of a date
	-- Below check to check if the date is NULL or not
	IF @P_DATE IS NULL
		SET @V_VALIDDATE = 0
	-- Below check to check if the date is of size 8 according to the RskMaster format (YYYYMMDD)
	-- Also to check if the value is numeric and is a valid date according to the Calender
	ELSE IF (LEN(@P_DATE) <> 8 OR ISNUMERIC(@P_DATE) = 0 OR ISDATE(@P_DATE) = 0)
		SET @V_VALIDDATE = -1
	-- Below check to tell it's a valid date
	ELSE
		SET @V_VALIDDATE = 1

RETURN @V_VALIDDATE;
END;