IF OBJECT_ID('DDS_DURATION', 'P') IS NOT NULL
    DROP PROCEDURE DDS_DURATION;
GO

CREATE PROCEDURE [dbo].[DDS_DURATION] 
@P_JOBID INT ,
@P_DA_ROW_ID INT,
@P_DBNAME VARCHAR(255),
@P_MODULENAME VARCHAR(100),
@P_KEYCOLUMN VARCHAR(30),
@P_KEY_VALUE VARCHAR(30),
@P_DATEFIRST VARCHAR(8),
@P_DATELAST VARCHAR(8),
@P_WORK_MON INT,
@P_WORK_TUE INT,
@P_WORK_WED INT,
@P_WORK_THU INT,
@P_WORK_FRI INT,
@P_WORK_SAT INT,
@P_WORK_SUN INT,
@P_DEPTID INT,
@P_DURATION INT OUTPUT

WITH EXECUTE AS CALLER
AS
BEGIN ---- BEGIN ALL
	BEGIN TRY
		SET NOCOUNT ON

	--*************************************************************************************************************************************************************
	--****************************************** STRUCTURE OF DA_DDS_DURATION PROCEDURE ***************************************************************************
	--*************************************************************************************************************************************************************
	--****		IT CALCULATES ACTUAL LOSS DAYS BY SUBTRACTING HOLIDAYS CORRESPONDING TO ORG HIERARCHY OF THE ENTITY FROM TOTAL DAYS ACCORDING TO HOLIDAYS      ****
	--****      -DEFINED IN RISKMASTER BY THE CLIENT																										   ****
	--****      VARIABLE DECLARTIONS																														   ****
	--****      FETCHING WORK FLAG VALUES, EXCL HOLIDAYS VALUES FROM RISKMASTER SYS_PARMS																	   ****
	--****      FECTH LIST OF HOLIDAYS FROM RISKMASTER SYS_HOLIDAYS IF HOLIDAYS NEEDS TO BE COUNTED FOR A PARTICULAR ORG HIERARCHY							   ****
	--****      GET TOTAL DAYS COUNT BETWEEN START DATE AND END DATE																	   				       ****	
	--****		INCREASING NUMBER OF DAYS FROM FIRST DATE ONE BY ONE TILL THE LAST DATE TO CHECK EVERYDAY FOR WORK FLAGS AND HOLIDAYS						   ****
	--****      CHECKS WHICH DAY OF WEEK IT IS (1,2,3,4,5,6,7)																								   ****
	--****      DATE IS HOLIDAY, THEN NEED TO CHECK WHETHER HOLIDAY IS FOR SAME ORG. HIER																	   ****
	--****      GET ORG_ID CORRESPONDING TO THE SAME HOLIDAY DATE																							   ****
	--****      FIND OUT SYSTEM TABLE NAME FROM GLOSSARY CORRESPONDING TO THE ENTITY_TABLE_ID OF (ENTITY_ID/ORG_EID)					   				       ****	
	--****		FIND OUT ORG LEVEL EID FOR THE DEPARTMENT IN ORG HIERARCHY																					   ****	
	--****		FIND OUT ACTUAL LOSS DAYS BY SUBTRACTING HOLIDAYS CORRESPONDING TO ORG HIERARCHY OF THE ENTITY FROM TOTAL DAYS								   ****
	--*************************************************************************************************************************************************************
	--*************************************************************************************************************************************************************


		-------------- VARIABLE DECLARATION -----------
		DECLARE
		@VSQL NVARCHAR(MAX),
		@VSQL2 NVARCHAR(MAX),
		@V_DA_ROW_ID INT = 0,
		@IROWID INT,
		@IJOBID INT ,
		@IDAROWID INT ,
		@V_DATEFIRST VARCHAR(8),
		@V_DATELAST VARCHAR(8),
		@V_WORK_MON INT = 0,
		@V_WORK_TUE INT = 0,
		@V_WORK_WED INT = 0,
		@V_WORK_THU INT = 0,
		@V_WORK_FRI INT = 0,
		@V_WORK_SAT INT = 0,
		@V_WORK_SUN INT = 0,
		@V_DEPTID INT = 0,
		@V_EXCL_HOLIDAYS INT,
		@V_HOL_DATE VARCHAR(8),
		@V_ORG_EID INT,
		@iDays INT,
		@iLossDays INT,
		@IVAR INT = 0,
		@VDateLoss INT,
		@VDAYOFWEEK INT,
		@VDAYFLAG INT,
		--@JVAR INT,	----JIRA 23130
		--@KVAR INT,	----JIRA 23130
		@VHOLDATECOUNT INT = 0,
		@VORGEIDCOUNT INT ,
		@V_ENTITY_TABLE_ID VARCHAR(255),
		@V_SYSTEM_TABLE_NAME VARCHAR(255),
		@VSQL3 NVARCHAR(MAX),
		@V_ENTITY_ID INT ,
		@V_ERROR_MESSAGE NVARCHAR(MAX),
		@V_PROCNAME VARCHAR(100) = 'DDS_DURATION',
		@V_ERRORLOC VARCHAR(100),
		@V_PREVIOUSDATE VARCHAR(8) = '00000000'

		---- FETCHING WORK FLAG VALUES, EXCL HOLIDAYS VALUES FROM RISKMASTER SYS_PARMS

		SET @V_ERRORLOC = 'DURATION001'
		SET @VSQL = 'SELECT @V_WORK_SUN = WORK_SUN, @V_WORK_MON = WORK_MON, @V_WORK_TUE = WORK_TUE, @V_WORK_WED = WORK_WED, @V_WORK_THU = WORK_THU, ' 
		SET @VSQL = @VSQL + '@V_WORK_FRI = WORK_FRI, @V_WORK_SAT = WORK_SAT,  @V_EXCL_HOLIDAYS = EXCL_HOLIDAYS'
		
		SET @VSQL = @VSQL + ' FROM ' + @P_DBNAME+'SYS_PARMS' 
	
		EXEC SP_EXECUTESQL @VSQL,
		N'@V_WORK_SUN INT OUTPUT,
		@V_WORK_MON INT OUTPUT,
		@V_WORK_TUE INT OUTPUT,
		@V_WORK_WED INT OUTPUT,
		@V_WORK_THU INT OUTPUT,
		@V_WORK_FRI INT OUTPUT,
		@V_WORK_SAT INT OUTPUT,		
		@V_EXCL_HOLIDAYS INT OUTPUT',
		@V_WORK_SUN = @V_WORK_SUN OUTPUT,
		@V_WORK_MON = @V_WORK_MON OUTPUT,
		@V_WORK_TUE = @V_WORK_TUE OUTPUT,
		@V_WORK_WED = @V_WORK_WED OUTPUT,
		@V_WORK_THU = @V_WORK_THU OUTPUT,
		@V_WORK_FRI = @V_WORK_FRI OUTPUT,
		@V_WORK_SAT = @V_WORK_SAT OUTPUT,
		@V_EXCL_HOLIDAYS = @V_EXCL_HOLIDAYS OUTPUT

		IF @P_WORK_SUN IS NOT NULL SET @V_WORK_SUN = @P_WORK_SUN
		IF @P_WORK_MON IS NOT NULL SET @V_WORK_MON = @P_WORK_MON
		IF @P_WORK_TUE IS NOT NULL SET @V_WORK_TUE = @P_WORK_TUE
		IF @P_WORK_WED IS NOT NULL SET @V_WORK_WED = @P_WORK_WED
		IF @P_WORK_THU IS NOT NULL SET @V_WORK_THU = @P_WORK_THU
		IF @P_WORK_FRI IS NOT NULL SET @V_WORK_FRI = @P_WORK_FRI
		IF @P_WORK_SAT IS NOT NULL SET @V_WORK_SAT = @P_WORK_SAT

		---- FECTH LIST OF HOLIDAYS FROM RISKMASTER SYS_HOLIDAYS IF HOLIDAYS NEEDS TO BE COUNTED FOR A PARTICULAR ORG HIERARCHY
----JIRA 23130 STARTS
		--IF @V_EXCL_HOLIDAYS <> 0 AND @P_DEPTID <> 0
		--BEGIN
		--	SET @V_ERRORLOC = 'DURATION002'

		--	CREATE TABLE #TEMPHOLIDAY(HOL_DATE VARCHAR(8), ORG_EID INT);
				
		--	SET @VSQL = 'INSERT INTO #TEMPHOLIDAY SELECT HOL_DATE, ORG_EID FROM ' + @P_DBNAME+'SYS_HOLIDAYS ORDER BY HOL_DATE, ORG_EID'
		--	EXEC SP_EXECUTESQL @VSQL,N'@P_DEPTID INT',@P_DEPTID = @P_DEPTID

		--	SET @V_ERRORLOC = 'DURATION003'
		--	SET @VSQL = 'SELECT @VHOLDATECOUNT = COUNT(HOL_DATE) FROM #TEMPHOLIDAY';
		--	EXEC SP_EXECUTESQL @VSQL, N'@VHOLDATECOUNT INT OUTPUT', @VHOLDATECOUNT = @VHOLDATECOUNT OUTPUT
		--END
----JIRA 23130 ENDS
		BEGIN ---- GET TOTAL DAYS COUNT
	    
        SET @iDays = ABS(DATEDIFF(DAY, @P_DATEFIRST, @P_DATELAST)) + 1
        SET @iLossDays = 0
		SET @IVAR = 1

		WHILE @IVAR <> @iDays -- INCREASING NUMBER OF DAYS FROM FIRST DATE ONE BY ONE TILL THE LAST DATE TO CHECK EVERYDAY FOR WORK FLAGS AND HOLIDAYS
		BEGIN
			SET @VDAYOFWEEK = DATEPART(WEEKDAY,DATEADD(DAY, @IVAR - 1, @P_DATEFIRST)) ---- CHECKS WHICH DAY OF WEEK IT IS (1,2,3,4,5,6,7)
			--PRINT @VDAYOFWEEK
			SET @VDAYFLAG = ( CASE 
				WHEN @VDAYOFWEEK = 1 THEN @V_WORK_SUN 
				WHEN @VDAYOFWEEK = 2 THEN @V_WORK_MON 
				WHEN @VDAYOFWEEK = 3 THEN @V_WORK_TUE  
				WHEN @VDAYOFWEEK = 4 THEN @V_WORK_WED
				WHEN @VDAYOFWEEK = 5 THEN @V_WORK_THU  
				WHEN @VDAYOFWEEK = 6 THEN @V_WORK_FRI  
				WHEN @VDAYOFWEEK = 7 THEN @V_WORK_SAT
				END )

				IF @VDAYFLAG <> 0 
				BEGIN  ----@VDAYFLAG <> 0 BEGINS
				
				    SET @VSQL = 'SELECT @VHOLDATECOUNT = COUNT(1) FROM ' + @P_DBNAME + 'SYS_HOLIDAYS';
				    EXECUTE SP_EXECUTESQL @VSQL, N'@VHOLDATECOUNT INT OUTPUT', @VHOLDATECOUNT = @VHOLDATECOUNT OUTPUT

					IF @V_EXCL_HOLIDAYS <> 0 And @P_DEPTID <> 0 AND @VHOLDATECOUNT <> 0 --Then 'don't count Holidays
					BEGIN
						SET @VDateLoss = 1
						--SET @JVAR = 0 ----JIRA 23130
							
							SET @V_ERRORLOC = 'DURATION004'		
							----JIRA 23130 STARTS
							--DECLARE DDS_DURATION_CUR1 CURSOR FOR  
							--SELECT HOL_DATE, ORG_EID FROM #TEMPHOLIDAY ORDER BY HOL_DATE, ORG_EID
							SET @VSQL = 'DECLARE DDS_DURATION_CUR1 CURSOR FOR SELECT HOL_DATE, ORG_EID FROM ' + @P_DBNAME+'SYS_HOLIDAYS ORDER BY HOL_DATE, ORG_EID'
							EXEC SP_EXECUTESQL @VSQL
							----JIRA 23130 ENDS
														
							OPEN DDS_DURATION_CUR1
							FETCH NEXT FROM DDS_DURATION_CUR1
							INTO @V_HOL_DATE, @V_ORG_EID
		
							WHILE @VHOLDATECOUNT <> 0
							BEGIN
								IF DATEADD(DAY, @IVAR - 1, @P_DATEFIRST) = @V_HOL_DATE AND (@V_PREVIOUSDATE <> @V_HOL_DATE) ---- date is holiday, then need to check whether holiday is for same org. hier
								BEGIN
								    ---- GET ORG_ID CORRESPONDING TO THE SAME HOLIDAY DATE
									SET @V_ERRORLOC = 'DURATION005'
									--SET @VSQL = 'SELECT @VORGEIDCOUNT = COUNT(ORG_EID) FROM #TEMPHOLIDAY WHERE HOL_DATE = @V_HOL_DATE'; ----JIRA 23130
									--EXEC SP_EXECUTESQL @VSQL, N'@VORGEIDCOUNT INT OUTPUT, @V_HOL_DATE VARCHAR(8)', @VORGEIDCOUNT = @VORGEIDCOUNT OUTPUT, @V_HOL_DATE = @V_HOL_DATE ----JIRA 23130
									SET @VSQL = 'SELECT @VORGEIDCOUNT = COUNT(1) FROM ' + @P_DBNAME+'SYS_HOLIDAYS WHERE HOL_DATE = @V_HOL_DATE'
									EXEC SP_EXECUTESQL @VSQL, N'@VORGEIDCOUNT INT OUTPUT , @V_HOL_DATE VARCHAR(8)', @VORGEIDCOUNT = @VORGEIDCOUNT OUTPUT, @V_HOL_DATE = @V_HOL_DATE
									

									--SET @KVAR = 0 ----JIRA 23130
										---- GET ORG_ID CORRESPONDING TO THE SAME HOLIDAY DATE
									IF 	@VORGEIDCOUNT > 0 ----JIRA 23130
									BEGIN ----JIRA 23130
										SET @V_ERRORLOC = 'DURATION006'
										
										--DECLARE DDS_DURATION_CUR2 CURSOR FOR  ----JIRA 23130
										--SELECT ORG_EID FROM #TEMPHOLIDAY WHERE HOL_DATE = @V_HOL_DATE ORDER BY HOL_DATE, ORG_EID ----JIRA 23130
										SET @VSQL = 'DECLARE DDS_DURATION_CUR2 CURSOR FOR SELECT ORG_EID FROM ' + @P_DBNAME+'SYS_HOLIDAYS WHERE HOL_DATE = @V_HOL_DATE ORDER BY HOL_DATE, ORG_EID' ----JIRA 23130
										EXEC SP_EXECUTESQL @VSQL, N'@V_HOL_DATE VARCHAR(8)', @V_HOL_DATE = @V_HOL_DATE ----JIRA 23130
										OPEN DDS_DURATION_CUR2
										FETCH NEXT FROM DDS_DURATION_CUR2
										INTO @V_ORG_EID

										WHILE @VORGEIDCOUNT <> 0
										BEGIN 	
											SET @V_ERRORLOC = 'DURATION007'

											---- FIND OUT SYSTEM TABLE NAME FROM GLOSSARY CORRESPONDING TO THE ENTITY_TABLE_ID OF (ENTITY_ID/ORG_EID)
											SET @VSQL = 'SELECT @V_SYSTEM_TABLE_NAME = G.SYSTEM_TABLE_NAME, @V_ENTITY_ID = E.ENTITY_ID ' 
											SET @VSQL = @VSQL + 'FROM ' + @P_DBNAME+'ENTITY E, ' + @P_DBNAME+'GLOSSARY G ' + ' WHERE E.ENTITY_TABLE_ID = G.TABLE_ID AND E.ENTITY_ID = @V_ORG_EID AND E.DELETED_FLAG = 0'
											EXEC SP_EXECUTESQL @VSQL, N'@V_SYSTEM_TABLE_NAME VARCHAR(255) OUTPUT,  @V_ENTITY_ID INT OUTPUT, @V_ORG_EID INT',
											@V_SYSTEM_TABLE_NAME = @V_SYSTEM_TABLE_NAME OUTPUT, @V_ENTITY_ID =  @V_ENTITY_ID OUTPUT, @V_ORG_EID = @V_ORG_EID
										
											IF @V_SYSTEM_TABLE_NAME IS NOT NULL
 											BEGIN
												SET @V_ERRORLOC = 'DURATION008'
												SET @VSQL3 = @V_SYSTEM_TABLE_NAME + '_EID'

												---- FIND OUT ORG LEVEL EID FOR THE DEPARTMENT IN ORG HIERARCHY
												SET @VSQL2 = 'SELECT @V_DEPTID = '
												SET @VSQL2 = @VSQL2 + @VSQL3
												SET @VSQL2 = @VSQL2 + ' FROM '+ @P_DBNAME+'ORG_HIERARCHY WHERE DEPARTMENT_EID = @P_DEPTID AND '
												SET @VSQL2 = @VSQL2 + @VSQL3 +' = @V_ENTITY_ID '

												EXEC SP_EXECUTESQL @VSQL2, N'@V_ENTITY_ID INT, @V_DEPTID INT OUTPUT, @P_DEPTID INT',
												@V_ENTITY_ID = @V_ENTITY_ID, @V_DEPTID = @V_DEPTID OUTPUT, @P_DEPTID = @P_DEPTID
											END
											IF @V_ORG_EID = @V_DEPTID
												SET @VDateLoss = 0  --- 'This holiday will not be counted as a work loss day
																			
											SET @V_ERRORLOC = 'DURATION009'
										
											FETCH NEXT FROM DDS_DURATION_CUR2
											INTO @V_ORG_EID
										
											SET @VORGEIDCOUNT = @VORGEIDCOUNT - 1
										END
										CLOSE DDS_DURATION_CUR2;
										DEALLOCATE DDS_DURATION_CUR2;

									END
								END ----JIRA 23130
								SET @V_ERRORLOC = 'DURATION010'
								SET @V_PREVIOUSDATE = @V_HOL_DATE

								FETCH NEXT FROM DDS_DURATION_CUR1
								INTO @V_HOL_DATE, @V_ORG_EID

								SET @VHOLDATECOUNT = @VHOLDATECOUNT - 1
							END
							CLOSE DDS_DURATION_CUR1;
							DEALLOCATE DDS_DURATION_CUR1;

						SET @V_ERRORLOC = 'DURATION011'
						IF @VDateLoss = 1 SET @iLossDays = @iLossDays + 1 
					END
					ELSE 
					BEGIN
						SET @V_ERRORLOC = 'DURATION012'
						SET @iLossDays = @iLossDays + 1 ---- COUNT ALL DAYS
					END
				END ---- @VDAYFLAG <> 0 ENDS

			SET @IVAR = @IVAR + 1
		END

		SET @V_ERRORLOC = 'DURATION013'
        END -- INCREASING NUMBER OF DAYS FROM FIRSTADTE ONE BY ONE TILL THE LASTDATE
		SET @P_DURATION = @iLossDays
		
		--IF @V_EXCL_HOLIDAYS <> 0 AND @P_DEPTID <> 0 DROP TABLE #TEMPHOLIDAY --CREATE TABLE CONDTION ----JIRA 23130

	END TRY
	BEGIN CATCH
		SET @V_ERROR_MESSAGE = ERROR_MESSAGE()
		EXECUTE DDS_ERROR_LOG_CAPTURE @P_JOBID, @V_DA_ROW_ID, @P_MODULENAME, @V_ERRORLOC, @V_ERRORLOC, @V_PROCNAME,@V_ERROR_MESSAGE,'EXCEPTION', 'DDS_CLAIM', @P_KEYCOLUMN, @P_KEY_VALUE, 0;
		SET @P_DURATION = -1
	END CATCH
END --END ALL