CREATE OR REPLACE PROCEDURE DDS_DURATION
(
  v_P_JOBID IN NUMBER,
  v_P_DA_ROW_ID IN NUMBER ,
  v_P_DBNAME IN VARCHAR2,
  v_P_MODULENAME IN VARCHAR2 ,
  v_P_KEYCOLUMN IN VARCHAR2 ,
  v_P_KEY_VALUE IN VARCHAR2,
  v_P_DATEFIRST IN VARCHAR2,
  v_P_DATELAST IN VARCHAR2,
  v_P_WORK_MON IN NUMBER,
  v_P_WORK_TUE IN NUMBER,
  v_P_WORK_WED IN NUMBER,
  v_P_WORK_THU IN NUMBER,
  v_P_WORK_FRI IN NUMBER,
  v_P_WORK_SAT IN NUMBER,
  v_P_WORK_SUN IN NUMBER,
  v_P_DEPTID IN NUMBER,
  v_P_DURATION OUT NUMBER
)
AUTHID CURRENT_USER 
AS
   v_VSQL CLOB;
   v_VSQL2 CLOB;
   v_V_WORK_MON NUMBER(10,0):=0;
   v_V_WORK_TUE NUMBER(10,0):=0;
   v_V_WORK_WED NUMBER(10,0):=0;
   v_V_WORK_THU NUMBER(10,0):=0;
   v_V_WORK_FRI NUMBER(10,0):=0;
   v_V_WORK_SAT NUMBER(10,0):=0;
   v_V_WORK_SUN NUMBER(10,0):=0;
   v_V_DEPTID NUMBER(10,0) := 0 ;
   v_V_EXCL_HOLIDAYS NUMBER(10,0);
   v_V_HOL_DATE VARCHAR2(8);
   v_V_ORG_EID NUMBER(10,0);
   v_iDays NUMBER(10,0);
   v_iLossDays NUMBER(10,0);
   v_IVAR NUMBER(10,0) := 0 ;
   v_VDateLoss NUMBER(10,0);
   v_VDAYOFWEEK NUMBER(10,0);
   v_VDAYFLAG NUMBER(10,0);
   v_JVAR NUMBER(10,0);
   v_KVAR NUMBER(10,0);
   v_VHOLDATECOUNT NUMBER(10,0) := 0 ;
   v_VORGEIDCOUNT NUMBER(10,0);
   --v_V_ENTITY_TABLE_ID VARCHAR2(255);
   v_V_SYSTEM_TABLE_NAME VARCHAR2(255);
   v_VSQL3 CLOB;
   v_V_ENTITY_ID NUMBER(10,0);
   v_V_ERROR_MESSAGE CLOB;
   v_V_PROCNAME VARCHAR2(100) := 'DDS_DURATION';
   v_V_ERRORLOC VARCHAR2(100);
   DDS_DURATION_CUR1 SYS_REFCURSOR;
   DDS_DURATION_CUR2 SYS_REFCURSOR;
   v_VSQL4 VARCHAR2(500);
   v_V_PREVIOUSDATE VARCHAR2(8) := '00000000';
   
---- BEGIN ALL
BEGIN
      BEGIN
	  
	--*************************************************************************************************************************************************************
	--****************************************** STRUCTURE OF DDS_DURATION PROCEDURE ***************************************************************************
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
            --SET @VDBNAME = @P_DBNAME + '.DBO.';
         v_V_ERRORLOC := 'DURATION001';
         v_P_DURATION :=0;

         IF v_P_WORK_MON IS NULL OR 
         v_P_WORK_SUN  IS NOT NULL  OR
         v_P_WORK_TUE IS NOT NULL  OR
         v_P_WORK_WED IS NOT NULL  OR
         v_P_WORK_THU IS NOT NULL OR 
         v_P_WORK_FRI IS NOT NULL OR
         v_P_WORK_SAT IS NOT NULL          
         THEN
            v_VSQL := 'SELECT WORK_SUN, WORK_MON,  WORK_TUE,WORK_WED,WORK_THU, ';
            v_VSQL := v_VSQL || 'WORK_FRI,  WORK_SAT, EXCL_HOLIDAYS';
            v_VSQL := v_VSQL || ' FROM ' || v_P_DBNAME || 'SYS_PARMS';
           BEGIN 
            EXECUTE IMMEDIATE V_VSQL INTO   v_V_WORK_SUN,
                          v_V_WORK_MON,
                          v_V_WORK_TUE,
                          v_V_WORK_WED,
                          v_V_WORK_THU,
                          v_V_WORK_FRI,
                          v_V_WORK_SAT,
                          v_V_EXCL_HOLIDAYS;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  RETURN;
           END;
         END IF;  
            IF v_P_WORK_SUN IS NOT NULL THEN
               v_V_WORK_SUN := v_P_WORK_SUN;
            END IF;

             IF v_P_WORK_MON IS NOT NULL THEN
                v_V_WORK_MON := v_P_WORK_MON;
             END IF;

             IF v_P_WORK_TUE IS NOT NULL THEN
                v_V_WORK_TUE := v_P_WORK_TUE;
             END IF;

             IF v_P_WORK_WED IS NOT NULL THEN
                v_V_WORK_WED := v_P_WORK_WED;
             END IF;

             IF v_P_WORK_THU IS NOT NULL THEN
                v_V_WORK_THU := v_P_WORK_THU;
             END IF;

             IF v_P_WORK_FRI IS NOT NULL THEN
                v_V_WORK_FRI := v_P_WORK_FRI;
             END IF;

             IF v_P_WORK_SAT IS NOT NULL THEN
                v_V_WORK_SAT := v_P_WORK_SAT;
             END IF;
                    
            BEGIN---- GET DAY COUNT
               v_V_ERRORLOC := 'DURATION002';
               --v_iDays := sqlserver_utilities.datediff('DAY', v_P_DATEFIRST, v_P_DATELAST) + 1;
               v_iDays := ABS((to_date(v_P_DATELAST,'yyyyMMdd')- to_date(v_P_DATEFIRST,'yyyyMMdd'))) + 1;
               v_iLossDays := 0;
               v_IVAR := 1;
               v_V_ERRORLOC := 'DURATION002A';
               WHILE v_IVAR <> v_iDays-- INCREASING NUMBER OF DAYS FROM FIRSTADTE ONE BY ONE TILL THE LASTDATE               
               LOOP
                  BEGIN
                  v_VDAYOFWEEK := TO_CHAR(((v_IVAR - 1) + to_date(v_P_DATEFIRST,'yyyyMMDD')),'D');                 
                     --v_VDAYOFWEEK := sqlserver_utilities.datepart('WEEKDAY', sqlserver_utilities.dateadd('DAY', v_IVAR - 1, v_P_DATEFIRST));
                     DBMS_OUTPUT.PUT_LINE(v_VDAYOFWEEK);
                     v_VDAYFLAG := (CASE
                                         WHEN v_VDAYOFWEEK = 1 THEN v_V_WORK_SUN
                                         WHEN v_VDAYOFWEEK = 2 THEN v_V_WORK_MON
                                         WHEN v_VDAYOFWEEK = 3 THEN v_V_WORK_TUE
                                         WHEN v_VDAYOFWEEK = 4 THEN v_V_WORK_WED
                                         WHEN v_VDAYOFWEEK = 5 THEN v_V_WORK_THU
                                         WHEN v_VDAYOFWEEK = 6 THEN v_V_WORK_FRI
                                         WHEN v_VDAYOFWEEK = 7 THEN v_V_WORK_SAT   
                                     END);

                    v_V_ERRORLOC := 'DURATION002B';
                     IF v_VDAYFLAG <> 0 THEN
                        --CURSOR DDS_DURATION_CUR1
                          --IS 
                          v_VSQL:= 'SELECT HOL_DATE, ORG_EID FROM ' || v_P_DBNAME || 'SYS_HOLIDAYS ORDER BY HOL_DATE, ORG_EID';
                        IF v_V_EXCL_HOLIDAYS <> 0  AND v_P_DEPTID <> 0 AND v_VHOLDATECOUNT <> 0 THEN--Then 'don't count Holidays
                           v_VDateLoss := 1;
                           v_JVAR := 0;
                           v_V_ERRORLOC := 'DURATION004';
                           
                           v_VSQL2 := 'SELECT COUNT(HOL_DATE) FROM ' || v_P_DBNAME || 'SYS_HOLIDAYS';
                           EXECUTE IMMEDIATE v_VSQL2 INTO v_VHOLDATECOUNT;

                           v_V_ERRORLOC := 'DURATION004';

                           OPEN DDS_DURATION_CUR1 FOR v_VSQL;
                           FETCH DDS_DURATION_CUR1 INTO v_V_HOL_DATE,v_V_ORG_EID;
                           WHILE v_VHOLDATECOUNT <> 0
                           LOOP
                              --DECLARE
                                 --CURSOR DDS_DURATION_CUR2
                                 V_VSQL4:= 'SELECT ORG_EID FROM ' || v_P_DBNAME || 'SYS_HOLIDAYS WHERE HOL_DATE = '||v_V_HOL_DATE||' ORDER BY HOL_DATE, ORG_EID';
                                   
                                 IF ((v_IVAR - 1) + to_date(v_P_DATEFIRST,'yyyyMMDD')) = v_V_HOL_DATE AND (v_V_PREVIOUSDATE <> v_V_HOL_DATE)THEN----date is holiday, then need to check whether holiday is for same org. hier
                                 --sqlserver_utilities.dateadd('DAY', v_IVAR - 1, v_P_DATEFIRST) = v_V_HOL_DATE THEN----date is holiday, then need to check whether holiday is for same org. hier                                 
                                    v_V_ERRORLOC := 'DURATION005';
                                    v_VSQL2 := 'SELECT COUNT(ORG_EID) FROM ' || v_P_DBNAME || 'SYS_HOLIDAYS WHERE HOL_DATE = :1';
                                     EXECUTE IMMEDIATE v_VSQL2 INTO v_VORGEIDCOUNT USING v_V_HOL_DATE;

                                    v_KVAR := 0;
                                    ---- GET ORG_ID CORRESPONDING TO THE SAME HOLIDAY DATE
                                    v_V_ERRORLOC := 'DURATION006';

                                    OPEN DDS_DURATION_CUR2 FOR V_VSQL4;
                                    FETCH DDS_DURATION_CUR2 INTO v_V_ORG_EID;
                                    WHILE v_VORGEIDCOUNT <> 0
                                    LOOP
                                          v_V_ERRORLOC := 'DURATION007';
                                          ---- FIND OUT SYSTEM TABLE NAME FROM GLOSSARY CORRESPONDING TO THE ENTITY_TABLE_ID OF (ENTITY_ID/ORG_EID)
                                          v_VSQL := 'SELECT  G.SYSTEM_TABLE_NAME, E.ENTITY_ID ';
                                          v_VSQL := v_VSQL || 'FROM ' || v_P_DBNAME || 'ENTITY E, ' || v_P_DBNAME || 'GLOSSARY G ' || ' WHERE E.ENTITY_TABLE_ID = G.TABLE_ID AND E.ENTITY_ID = :1 AND E.DELETED_FLAG = 0';
                                          
                                          BEGIN
                                            EXECUTE IMMEDIATE V_VSQL INTO v_V_SYSTEM_TABLE_NAME, v_V_ENTITY_ID USING v_V_ORG_EID;                                         
                                          EXCEPTION
                                            WHEN NO_DATA_FOUND THEN
                                                 v_V_SYSTEM_TABLE_NAME := NULL;
                                          END; 
                                                
                                          IF v_V_SYSTEM_TABLE_NAME IS NOT NULL THEN
                                             v_V_ERRORLOC := 'DURATION008';

                                             v_VSQL3 := v_V_SYSTEM_TABLE_NAME || '_EID';

                                             ---- FIND OUT ORG LEVEL EID FOR THE DEPARTMENT IN ORG HIERARCHY
                                             v_VSQL2 := 'SELECT ';
                                             v_VSQL2 := v_VSQL2 || v_VSQL3;
                                             v_VSQL2 := v_VSQL2 || ' FROM ' || v_P_DBNAME || 'ORG_HIERARCHY WHERE DEPARTMENT_EID = :1 AND ';
                                             v_VSQL2 := v_VSQL2 || v_VSQL3 || ' = :2 ';
                                             BEGIN
                                              EXECUTE IMMEDIATE V_VSQL2 INTO v_V_DEPTID USING v_P_DEPTID,v_V_ENTITY_ID ;
                                             EXCEPTION
                                            WHEN NO_DATA_FOUND THEN
                                                 v_V_DEPTID := NULL;
                                            END;                                                 
                                          END IF;

                                          IF v_V_ORG_EID = v_V_DEPTID THEN
                                             v_VDateLoss := 0;--- 'This holiday will not be counted as a work loss day                                             
                                          END IF;

                                          v_V_ERRORLOC := 'DURATION009';
                                          --FETCH DDS_DURATION_CUR2 INTO v_V_ORG_EID;
                                          v_VORGEIDCOUNT := v_VORGEIDCOUNT - 1;
                                    END LOOP;
                                    CLOSE DDS_DURATION_CUR2;
                                 END IF;
                                 v_V_ERRORLOC := 'DURATION010';
                                 v_V_PREVIOUSDATE := v_V_HOL_DATE;
                                 
                                --FETCH DDS_DURATION_CUR1 INTO v_V_HOL_DATE,v_V_ORG_EID;
                                 v_VHOLDATECOUNT := v_VHOLDATECOUNT - 1;
                           END LOOP;
                           CLOSE DDS_DURATION_CUR1;

                           v_V_ERRORLOC := 'DURATION011';

                           IF v_VDateLoss = 1 THEN
                              v_iLossDays := v_iLossDays + 1;----                            
                           END IF;
                        ELSE
                           v_V_ERRORLOC := 'DURATION012';
                           v_iLossDays := v_iLossDays + 1;----COUNT ALL DAYS
                        END IF;
                     END IF;
                     v_IVAR := v_IVAR + 1;
                  END;
               END LOOP;
               v_V_ERRORLOC := 'DURATION013';
            END;
            -- INCREASING NUMBER OF DAYS FROM FIRSTADTE ONE BY ONE TILL THE LASTDATE
            v_P_DURATION := v_iLossDays;
      EXCEPTION
         WHEN OTHERS THEN
               v_V_ERROR_MESSAGE := SQLERRM;
               DDS_ERROR_LOG_CAPTURE(v_P_JOBID,
                                     v_P_DA_ROW_ID,
                                     v_P_MODULENAME,
                                     v_V_ERRORLOC,
                                     v_V_ERRORLOC,
                                     v_V_PROCNAME,
                                     v_V_ERROR_MESSAGE,
                                     'EXCEPTION',
                                     'DDS_CLAIM',
                                     v_P_KEYCOLUMN,
                                     v_P_KEY_VALUE,
                                     0);

               v_P_DURATION := -1;
      END;
END DDS_DURATION;
