CREATE OR REPLACE PROCEDURE DDS_SUPPLEMENT
(P_JOBID NUMBER, 
P_CONFIG_ID NUMBER,
P_USER_ID NUMBER,
P_MODULE_NAME VARCHAR2,
P_DB_NAME VARCHAR2,
P_DA_ROW_ID NUMBER,
P_CODE_CREATION_FLAG NUMBER,
P_LOB NUMBER,
P_BASE_ERROR_COUNT NUMBER, -- TO CHECK THERE IS ANY ERROR IN BASE RECORD (INPUT PARAMETER TO CHECK BASE ERROR)
P_STAGE VARCHAR2,-- VALIDATION OR INSERT (V OR I)
P_CLAIMANT_EID NUMBER,
P_EVENT_ID NUMBER,
P_CLAIM_ID NUMBER,
P_EMPLOYEE_EID NUMBER,
P_UNIT_ID    NUMBER,
P_ENTITY_ID NUMBER,
P_DEFENDANT_ROW_ID  NUMBER,
P_PI_ROW_ID    NUMBER,
P_PI_PROC_ROW_ID  NUMBER,
P_PATIENT_ID    NUMBER,
P_TRANS_ID    NUMBER,
P_PLAN_ID    NUMBER,
P_EV_CONCOM_ROW_ID NUMBER,--Kapil added below conditions for Med Watch functionality                         
P_EV_MW_TEST_ROW_ID NUMBER,--Kapil added below conditions for Med Watch functionality
P_KEYCOLUMN VARCHAR2, -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
P_KEYVALUE VARCHAR2, -- USED FOR ERROR LOGGING FOR WHICH RECORD WE HAVE GOT AN ERROR
P_SUPP_ERROR_COUNT OUT NUMBER --(OUT PARAMETER TO INTIMATE BASE THAT THERE IS AND ERROR IN SUPP)
)
AUTHID CURRENT_USER 
AS
--*************************************************************************************************************************************************************
      --*********************** STRUCTURE OF DDS_SUPPLEMENT PROCEDURE STARTS ************************************************************************
      --*************************************************************************************************************************************************************    
      --Insert into DDS_SUPPLEMENTAL_RUNTIME_DATA (staging)
      --Select count of records from DDS_modulename_USR_SUPP_MAP (staging),data is saved into this table from RMA UI when saving optionset
      --Declare corsor ,loop for the count of records
      --Fetch the records from SUPP_DICTIONARY
      --@P_STAGE=V --validation block
      --@P_STAGE=I --Insertion block
      --*************************************************************************************************************************************************************
      --*********************** STRUCTURE OF DDS_SUPPLEMENT PROCEDURE ENDS ************************************************************************
      --*************************************************************************************************************************************************************
/*Declaration Part*/
PRAGMA AUTONOMOUS_TRANSACTION;

l_cursor sys_refcursor;
l_CURSOR_MULTI_CODE sys_refcursor;
l_CURSOR_STATES  sys_refcursor;
l_CURSOR_ENTITY  sys_refcursor;
l_CURSOR_TXT_CODE  sys_refcursor;
l_CURSOR_RM_DB_I_U SYS_REFCURSOR;
 
V_SQL VARCHAR2(32000);
V_SQL_VALUE VARCHAR2(32000);
V_FIELD_NUM NUMBER;
V_USER_FIELD_NAME VARCHAR2(25);
V_MAP_FLAG VARCHAR2(10);
V_FIELD_TYPE VARCHAR2(25); 
V_MAPPED_TABLE VARCHAR2(50); 
V_MAPPED_FIELD VARCHAR2(50); 
V_NULL_FLAG VARCHAR2(10); 
V_VALIDATE_FLAG VARCHAR2(10); 
V_CODE_TABLE_ID VARCHAR2(10);
V_DB_NAME VARCHAR2(100);
V_FIELD_TYPE_C NUMBER;
V_FIELD_ID_C NUMBER;
V_CODE_FILE_ID_C NUMBER;
V_MULTI_VAL NUMBER;
V_FIELD_TYPE_NAME VARCHAR2(100);
V_USER_FIELD_NAME_VALUE VARCHAR2(2000); -- THIS VARIABLE IS USED IN VALIDATION AS WELL AS IN INSERTION
V_ERROR_COUNT NUMBER:=0;
V_ERROR_LOCATION VARCHAR2(100);
V_CODE_ID_R NUMBER; -- value returned from codes procedure

V_INS_UPD_FLAG VARCHAR2(1);

V_SQL_MULTI_CODE VARCHAR2(2000); -- USED FOR SELECT QUERY BUILD
V_SQL_MULTI_CODE_VAL VARCHAR2(100); -- USED TO CAPTURE CURSOR VALUE
V_CODE_ID_M_R VARCHAR2(300); -- USED TO STORE THE MULTI CODE VALUES

--- STATES VARIABLES
V_SQL_STATES VARCHAR2(2000); -- USED FOR SELECT QUERY BUILD FOR STATE FIELD CHECKING
V_STATE_ROW_ID VARCHAR2(300); -- USED TO CAPTURE CURSOR VALUE
V_SQL_STATES_VAL VARCHAR2(100); -- USED TO CAPTURE MULTI CURSOR VALUE
V_STATE_ROW_ID_M_R VARCHAR2(300); -- USED TO STORE THE MULTI CODE VALUES

-- ENTITY FIELD VARIABLES
V_ENTITY_ID VARCHAR2(300); -- capture single entity id returned for the last name and abbrv in case of entity fields
V_SQL_ENTITY VARCHAR2(2000); -- USED FOR SELECT QUERY BUILD FOR ENTITY FIELD
V_SQL_ENTITY_VAL VARCHAR2(100); -- USED TO CAPTURE MULTI CURSOR VALUE
V_SQL_ENTITY_C VARCHAR2(2000); -- USED TO MAKE A SELECT QUERY WITH IN MULTI VALUE CURSOR
V_ENTITY_ID_M_R VARCHAR2(300); -- USED TO STORE THE MULTI CODE VALUES
V_EROLE_FLAG NUMBER;

-- TEXT FIELD VARIABLES
V_CHK_TXT_CODE NUMBER;  -- USED TO CHECK THAT STRING IS HAVING - OR NOT
V_TXT_CODE VARCHAR2(100); -- USED TO CAPTURE THE SPLITTED STRING HAVING CODE
V_TXT_DESC VARCHAR2(4000); -- USED TO CAPTURE THE SPLITTED STRING HAVING DESCRIPTION
V_TXT_CODE_R NUMBER; -- USED TO CAPTURE THE CODE ID RETURNED FROM TEXT FIELD VALUE IF HAVING ANY CODE


V_SQL_TXT_CODE VARCHAR2(2000); -- USED FOR SELECT QUERY BUILD FOR ENTITY FIELD
V_SQL_TXT_CODE_VAL VARCHAR2(100); -- USED TO CAPTURE MULTI CURSOR VALUE
--V_SQL_TXT_CODE_C VARCHAR2(2000); -- USED TO MAKE A SELECT QUERY WITH IN MULTI VALUE CURSOR
--V_TXT_CODE_M_R CLOB; -- USED TO STORE THE MULTI CODE VALUES
V_TXT_CODE_CODE_DESC_R CLOB; -- USED TO STORE CODE AND DESC VALUES RETURNED DURING MULTI VALUE

V_SQL_SYS_TAB_NAME VARCHAR2(500); -- FOR MAKING QUERY
V_SQL_SYS_TAB_NAME_V VARCHAR2(200); -- FOR COLLECT VALUE OF SYSTEM TABLE NAME

-- BELOW VARIABLES ARE USED FOR RM DB TABLES
--V_SQL_CLAIMANT VARCHAR2(400);
V_SQL_RM_SUPP VARCHAR2(400); -- USED FOR RM SUPP TABLES QUERY CHECKING DATA EXISTS IN RM DB OR NOT
V_TAB_PK_ID NUMBER; -- USED TO STORE COLUMN VALUE OF PRIMARY KEY OF SUPP TABLE FOR DYNAMIC PURPOSE
V_TAB_PK_COL_NAME VARCHAR2(100); -- USED TO STORE PRIMARY KEY COLUMN NAME OF SUPP TABLE FOR DYNAMIC PURPOSE
V_TAB_PK_COL_VAL NUMBER; -- USED TO STORE VALUE COMING FROM PARAMETER ASSIGNING THE PRIMARY VALUE TO IT AND FETCHING DATA FROM SUPP TABLES

V_INS_UPD_SUPP_FLAG VARCHAR2(1); -- SUPP MULTIVALUE FLAG CHECK -- HAVING DATA OR NOT

V_ERROR_MSG CLOB;

/*v_MODULE_NAME DDS_ERROR_LOG.MODULE_NAME%type; 
v_ERROR_PROC_NAME DDS_ERROR_LOG.ERROR_PROC_NAME%type; 
v_ERROR_COLUMN DDS_ERROR_LOG.ERROR_COLUMNS%type; 
v_ERROR_TABLE_TO_CHECK DDS_ERROR_LOG.ERROR_TABLE_TO_CHECK%type; 
v_ERR_LOG_ROW_ID DDS_ERROR_LOG.ERR_LOG_ROW_ID%type; 
v_ERROR_DESC DDS_ERROR_LOG.ERROR_DESC%type; 
V_ERROR_MSG DDS_ERR_MESSAGES.ERR_MESSAGE%type; 
*/
--v_commit_flag NUMBER;

--BEGIN

BEGIN

/*IF P_DB_NAME IS NOT NULL THEN
   V_DB_NAME := P_DB_NAME||'.';
END IF;*/

   V_DB_NAME := P_DB_NAME;

IF P_STAGE = 'V' THEN -- IF VALIDATION FLAG V IS COMING
           -- POPULATING THE DATA INTO TEMP TABLE AND UPDATE IT LATER OR AFTER FETCHING THE VALUE
           V_ERROR_LOCATION := 0;
           
           INSERT INTO DDS_SUPPLEMENTAL_RUNTIME_DATA (JOBID, DA_ROW_ID, CLAIMANT_EID, EVENT_ID, CLAIM_ID, EMPLOYEE_EID, UNIT_ID, ENTITY_ID,
                                                      DEFENDANT_ROW_ID, PI_ROW_ID, PI_PROC_ROW_ID, PATIENT_ID, TRANS_ID, PLAN_ID, MODULE_NAME)
           VALUES (P_JOBID,P_DA_ROW_ID, P_CLAIMANT_EID, P_EVENT_ID, P_CLAIM_ID, P_EMPLOYEE_EID, P_UNIT_ID, P_ENTITY_ID,
                   P_DEFENDANT_ROW_ID, P_PI_ROW_ID, P_PI_PROC_ROW_ID, P_PATIENT_ID, P_TRANS_ID, P_PLAN_ID, P_MODULE_NAME);
           
           COMMIT;        
           -- END HERE -- INSERTION INTO SUPPLEMENTAL END HERE
END IF; -- CHECKING INSERT OR UPDATE
       
      OPEN l_cursor FOR 'SELECT FIELD_NUM, USER_FIELD_NAME, MAP_FLAG, FIELD_TYPE,  MAPPED_TABLE,  MAPPED_FIELD, 
  NULL_FLAG, VALIDATE_FLAG ,   CODE_TABLE_ID from DDS_' || P_MODULE_NAME||'_USR_SUPP_MAP WHERE CONFIG_ID = :1 AND USER_ID =:2 AND MAP_FLAG = 1 and MAPPED_FIELD IS NOT NULL' using P_CONFIG_ID, P_USER_ID;
       LOOP 
           FETCH l_cursor --BULK COLLECT
            INTO V_FIELD_NUM, V_USER_FIELD_NAME, V_MAP_FLAG, V_FIELD_TYPE,  V_MAPPED_TABLE,  V_MAPPED_FIELD,  V_NULL_FLAG, V_VALIDATE_FLAG ,   V_CODE_TABLE_ID;
           --LIMIT p_array_size;
           EXIT WHEN l_cursor%NOTFOUND; 
          -- FOR i IN 1 .. V_FIELD_NUM.COUNT
           --LOOP
           
              BEGIN
                V_SQL := 'SELECT FIELD_TYPE, FIELD_ID, CODE_FILE_ID FROM '||V_DB_NAME||'SUPP_DICTIONARY WHERE DELETE_FLAG = 0 and UPPER(SUPP_TABLE_NAME) = :1 AND UPPER(SYS_FIELD_NAME) = :2';
                V_ERROR_LOCATION:=1;
                EXECUTE IMMEDIATE V_SQL INTO V_FIELD_TYPE_C, V_FIELD_ID_C, V_CODE_FILE_ID_C USING UPPER(V_MAPPED_TABLE), UPPER(V_MAPPED_FIELD);              
                V_ERROR_LOCATION:=2;
                 IF V_FIELD_TYPE_C = 14 THEN       --MultiCodes
                    V_FIELD_TYPE_NAME := 'CODE_FIELD';
                    V_MULTI_VAL := 1; --IF 1 THEN IT IS True
                 ELSIF V_FIELD_TYPE_C = 15 THEN   --'MultiStates
                    V_FIELD_TYPE_NAME := 'STATE_FIELD';
                    V_MULTI_VAL := 1; --IF 1 THEN IT IS True
                 ELSIF V_FIELD_TYPE_C = 16 THEN   --MultiEnties
                    V_FIELD_TYPE_NAME := 'ENTITY_FIELD';
                    V_MULTI_VAL := 1; --IF 1 THEN IT IS True
                 ELSIF V_FIELD_TYPE_C = 6 THEN      --'code
                    V_FIELD_TYPE_NAME := 'CODE_FIELD';
                    V_MULTI_VAL := 0; --IF 1 THEN IT IS True
                 ELSIF V_FIELD_TYPE_C = 8 THEN     -- 'entity
                    V_FIELD_TYPE_NAME := 'ENTITY_FIELD';
                    V_MULTI_VAL := 0; --IF 1 THEN IT IS True                            
                 ELSIF V_FIELD_TYPE_C = 9 THEN      --'state
                    V_FIELD_TYPE_NAME := 'STATE_FIELD';
                    V_MULTI_VAL := 0; --IF 1 THEN IT IS True                  
                 ELSIF V_FIELD_TYPE_C = 5 Then                 --   mits 13694
                    V_FIELD_TYPE_NAME := 'TXTCODE_FIELD';
                    V_MULTI_VAL := 1; --IF 1 THEN IT IS True
                 ELSE
                     V_FIELD_TYPE_NAME := 0;                
                     V_MULTI_VAL := 0; --IF 1 THEN IT IS True                  
                END IF;
                
                -- FETCH SYSTEM TABLE NAME FROM RM DB  
                V_SQL_SYS_TAB_NAME:='SELECT SYSTEM_TABLE_NAME FROM '||V_DB_NAME||'GLOSSARY WHERE TABLE_ID=:1';
                BEGIN
                     V_ERROR_LOCATION:=3;
                    EXECUTE IMMEDIATE V_SQL_SYS_TAB_NAME INTO V_SQL_SYS_TAB_NAME_V USING V_CODE_FILE_ID_C;
                EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          NULL;
                          -- Need to send error message
                       WHEN TOO_MANY_ROWS THEN
                          V_ERROR_MSG:=SQLERRM;
                           V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           P_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           V_ERROR_LOCATION, 
                                           V_ERROR_LOCATION,
                                           'DDS_SUPPLEMENT',
                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                           V_USER_FIELD_NAME, 
                                           'DDS_'||P_MODULE_NAME,
                                           P_KEYCOLUMN,
                                           P_KEYVALUE,
                                           0);
                       WHEN OTHERS THEN
                         V_ERROR_MSG:=SQLERRM;
                          V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           P_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           V_ERROR_LOCATION, 
                                           V_ERROR_LOCATION,
                                           'DDS_SUPPLEMENT',
                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                           V_USER_FIELD_NAME, 
                                           'DDS_'||P_MODULE_NAME,
                                           P_KEYCOLUMN,
                                           P_KEYVALUE,
                                           0);
                END;    
                V_ERROR_LOCATION:=4;
                       IF P_STAGE = 'V' THEN -- VALIDATION FLAG / STAGE WORK COMPLETED / START HERE    
                         --IF V_CODE_TABLE_ID > 0 THEN -- IF CODE TABLE ID IS GREATER THAN 0 THEN ONLY START VALIDATION -- START
                            V_ERROR_LOCATION:=5;
                            IF V_VALIDATE_FLAG = 1 THEN -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 1 THEN NEED TO DO VALIDATION
                                V_ERROR_LOCATION:=6;
                                --IF V_NULL_FLAG = 0 THEN --- NULL FIELD VALIDATION FOR A RECORD START, IF 0 THEN ALLOW NULL IS ALLOWED WHILE 1 THEN NOT ALLOWED
                                     V_SQL_VALUE:='SELECT '|| V_USER_FIELD_NAME ||' FROM DDS_'||P_MODULE_NAME||' WHERE DA_ROW_ID=:1 AND JOBID=:2';
                                  
                                  BEGIN
                                       V_ERROR_LOCATION:=7;
                                       EXECUTE IMMEDIATE V_SQL_VALUE INTO V_USER_FIELD_NAME_VALUE USING P_DA_ROW_ID,P_JOBID ;
                                       V_ERROR_LOCATION:=8;
                                  EXCEPTION
                                           WHEN NO_DATA_FOUND THEN
                                            V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                            -- Need to send error message
                                           WHEN TOO_MANY_ROWS THEN
                                            NULL;
                                           WHEN OTHERS THEN
                                                 V_ERROR_MSG:=SQLERRM;
                                                  V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                 DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                     P_DA_ROW_ID, 
                                                     p_MODULE_NAME,
                                                     V_ERROR_LOCATION, 
                                                     V_ERROR_LOCATION,
                                                     'DDS_SUPPLEMENT',
                                                     V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                     V_USER_FIELD_NAME, 
                                                     'DDS_'||P_MODULE_NAME,
                                                     P_KEYCOLUMN,
                                                     P_KEYVALUE,
                                                     0);
                                  END;  
                                  
                                  V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3 AND MODULE_NAME = :4';
                                  
                                  EXECUTE IMMEDIATE V_SQL_VALUE USING V_USER_FIELD_NAME_VALUE,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                  COMMIT;                  
                               --END IF; --- NULL FIELD VALIDATION FOR A RECORD END
                                 V_ERROR_LOCATION:=9;
                                 IF  V_FIELD_TYPE_NAME = 'CODE_FIELD' AND V_USER_FIELD_NAME_VALUE IS NOT NULL THEN
                                 -- HERE WE ARE GOING TO CREATE CODES WHEN START
                                      V_ERROR_LOCATION:=10;
                                      IF V_CODE_TABLE_ID > 0 And V_MULTI_VAL <> 1 THEN -- CODE VALIDATION -- AND CODE CREATION FOR SINGLE VALUE
                                          V_ERROR_LOCATION:=11;
                                          DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                   V_USER_FIELD_NAME_VALUE, -- Short Code
                                                                   V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                   P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                   --1, -- It is used to check are we able to create code for that system table name or not
                                                                   P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                   P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_CODE_ID_R
                                                                   );
                                          V_ERROR_LOCATION:=12;  
                                          IF V_CODE_ID_R = 0 OR V_CODE_ID_R IS NULL  THEN
                                             V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                             -- Commenting below code as we are logging error in code procedure also.
                                             /*V_ERROR_MSG:='Code does not exists in RM DB.' ||V_USER_FIELD_NAME||' - '|| V_USER_FIELD_NAME_VALUE;
                                                 DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                 P_DA_ROW_ID, 
                                                 p_MODULE_NAME,
                                                 V_ERROR_LOCATION, 
                                                 V_ERROR_LOCATION,
                                                 'DDS_SUPPLEMENT',
                                                 V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                 V_USER_FIELD_NAME, 
                                                 'DDS_'||P_MODULE_NAME,
                                                 P_KEYCOLUMN,
                                                 P_KEYVALUE);*/
                                             
                                             -- Need to send error message 
                                             ELSE -- UPDATE CODE VALUE IN TEMP TABLE
                                             V_ERROR_LOCATION:=13;
                                              V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                  
                                              EXECUTE IMMEDIATE V_SQL_VALUE USING V_CODE_ID_R,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                              V_ERROR_LOCATION:=14;
                                              COMMIT;
                                          END IF;                         
                                                                   
                                        END IF; --CODE VALIDATION COMPLETE HERE  FOR SINGLE VALUE
                                      V_ERROR_LOCATION:=15;  
                                      IF V_CODE_TABLE_ID > 0 And V_MULTI_VAL = 1 THEN -- CODE VALIDATION -- AND CODE CREATION FOR MULTI VALUE
                                         V_ERROR_LOCATION:=16;

                                         V_SQL_MULTI_CODE :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                             connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                           
                                           V_ERROR_LOCATION:=17;
                                                                                   
                                           OPEN l_CURSOR_MULTI_CODE FOR V_SQL_MULTI_CODE;
                                            LOOP
                                              FETCH l_CURSOR_MULTI_CODE INTO V_SQL_MULTI_CODE_VAL ;
                                              EXIT WHEN l_CURSOR_MULTI_CODE%NOTFOUND;
                                              
                                                    DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                   V_SQL_MULTI_CODE_VAL, -- Short Code
                                                                   V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                   P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                   --1, -- It is used to check are we able to create code for that system table name or not
                                                                   P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                   P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_CODE_ID_R);
                                                              
                                                     IF V_CODE_ID_R = 0 OR V_CODE_ID_R IS NULL  THEN
                                                         V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                     END IF;      
                                                        
                                                     IF V_CODE_ID_M_R IS NOT NULL AND V_CODE_ID_M_R <> '0' THEN
                                                       V_CODE_ID_M_R:= V_CODE_ID_M_R||'|'||NVL(V_CODE_ID_R,0);
                                                     ELSE 
                                                        V_CODE_ID_M_R:= NVL(V_CODE_ID_R,0);  
                                                     END IF;      
                                                     
                                                     IF V_CODE_ID_M_R = '0' THEN
                                                        V_ERROR_COUNT:=V_ERROR_COUNT+1;
                                                        --V_ERROR_MSG:='Code does not exists in RM DB.' ||V_USER_FIELD_NAME||' - '|| V_USER_FIELD_NAME_VALUE;
                                                        -- Commenting the below code as error log is getting captured in code procedure
                                                         /*DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                         P_DA_ROW_ID, 
                                                         p_MODULE_NAME,
                                                         V_ERROR_LOCATION, 
                                                         V_ERROR_LOCATION,
                                                         'DDS_SUPPLEMENT',
                                                         V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                         P_KEYCOLUMN, 
                                                         'DDS_'||P_MODULE_NAME,
                                                         P_KEYVALUE);*/
                                                     END IF;
                                                     
                                           END LOOP;
                                          CLOSE    l_CURSOR_MULTI_CODE;       
                                          
                                          V_ERROR_LOCATION:=18;
                                          
                                          --UPDATING MULTICODES VALUE IN TEMP TABLE
                                            V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                            EXECUTE IMMEDIATE V_SQL_VALUE USING V_CODE_ID_M_R, P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;     
                                            V_CODE_ID_M_R:=NULL;-- KAPIL - 22-FEB-2016
                                            COMMIT;
                                      END IF; --CODE VALIDATION COMPLETE HERE  FOR MULTI VALUE
                                 
                                 ELSIF V_FIELD_TYPE_NAME = 'CODE_FIELD' AND V_NULL_FLAG = 0 AND V_USER_FIELD_NAME_VALUE IS NULL THEN
                                  V_ERROR_LOCATION:=19;
                                       V_ERROR_MSG:='Validation failed as allow null is not checked and no value is provided in '||V_USER_FIELD_NAME;

                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           P_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           V_ERROR_LOCATION, 
                                           V_ERROR_LOCATION,
                                           'DDS_SUPPLEMENT',
                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                           V_USER_FIELD_NAME, 
                                           'DDS_'||P_MODULE_NAME,
                                           P_KEYCOLUMN,
                                           P_KEYVALUE,
                                           1);
                                           
                                     V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;      
                                 END IF; -- WE ARE GOING TO CREATE CODES WHEN END
                                 
                            END IF; -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD END
                         --END IF;   -- IF CODE TABLE ID IS GREATER THAN 0 THEN ONLY START VALIDATION -- END
                         
                          IF V_VALIDATE_FLAG = 0 THEN -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 0 THEN NO NEED TO DO VALIDATION
                               V_SQL_VALUE:='SELECT '|| V_USER_FIELD_NAME ||' FROM DDS_'||P_MODULE_NAME||' WHERE DA_ROW_ID=:1 AND JOBID=:2';
                                  V_ERROR_LOCATION:=20;
                                  BEGIN
                                       EXECUTE IMMEDIATE V_SQL_VALUE INTO V_USER_FIELD_NAME_VALUE USING P_DA_ROW_ID,P_JOBID ;
                                  EXCEPTION
                                           WHEN NO_DATA_FOUND THEN
                                            --V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                            NULL; 
                                           WHEN TOO_MANY_ROWS THEN
                                            NULL;
                                           WHEN OTHERS THEN
                                                V_ERROR_MSG:=SQLERRM;
                                                 V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                 DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                     P_DA_ROW_ID, 
                                                     p_MODULE_NAME,
                                                     V_ERROR_LOCATION, 
                                                     V_ERROR_LOCATION,
                                                     'DDS_SUPPLEMENT',
                                                     V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                     V_USER_FIELD_NAME, 
                                                     'DDS_'||P_MODULE_NAME,
                                                     P_KEYCOLUMN,
                                                     P_KEYVALUE,
                                                     0);
                                            -- Need to send error message
                                  END;  
                                  
                                  V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                  V_ERROR_LOCATION:=21;
                                  
                                  EXECUTE IMMEDIATE V_SQL_VALUE USING V_USER_FIELD_NAME_VALUE,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                  COMMIT;
                                   IF  V_FIELD_TYPE_NAME = 'CODE_FIELD' THEN
                                 -- HERE WE ARE GOING TO CREATE CODES WHEN START
                                 V_ERROR_LOCATION:=22;
                                      IF V_CODE_TABLE_ID > 0 And V_MULTI_VAL <> 1 THEN -- CODE VALIDATION -- AND CODE CREATION FOR SINGLE VALUE
                                        V_ERROR_LOCATION:=23;
                                          DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                   V_USER_FIELD_NAME_VALUE, -- Short Code
                                                                   V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                   P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                   --1, -- It is used to check are we able to create code for that system table name or not
                                                                   P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                   P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_CODE_ID_R
                                                                   );
            
                                              V_SQL_VALUE:= 'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                              
                                              EXECUTE IMMEDIATE V_SQL_VALUE USING NVL(V_CODE_ID_R,0), P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                              COMMIT;
                                      END IF; --CODE VALIDATION COMPLETE HERE  FOR SINGLE VALUE
                                        V_ERROR_LOCATION:=24;
                                      IF V_CODE_TABLE_ID > 0 And V_MULTI_VAL = 1 THEN -- CODE VALIDATION -- AND CODE CREATION FOR MULTI VALUE
                                         V_ERROR_LOCATION:=25;
                                         V_SQL_MULTI_CODE :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                             connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                      
                                           OPEN l_CURSOR_MULTI_CODE FOR V_SQL_MULTI_CODE;
                                            LOOP
                                              FETCH l_CURSOR_MULTI_CODE INTO V_SQL_MULTI_CODE_VAL ;
                                              EXIT WHEN l_CURSOR_MULTI_CODE%NOTFOUND;      
                                                   IF V_SQL_MULTI_CODE_VAL IS NOT NULL THEN
                                                   V_ERROR_LOCATION:=26;
                                                    DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                   V_SQL_MULTI_CODE_VAL, -- Short Code
                                                                   V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                   P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                   --1, -- It is used to check are we able to create code for that system table name or not
                                                                   P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                   P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                   P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                   V_CODE_ID_R);
                                                     END IF;                           
                                                     IF (V_CODE_ID_R = 0 OR V_CODE_ID_R IS NULL) AND V_SQL_MULTI_CODE_VAL IS NOT NULL THEN
                                                         V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                       V_ERROR_LOCATION:=27;  
                                                        -- Commenting the below code as error log is getting captured in code procedure
                                                          /* V_ERROR_MSG:='Code does not exists in RM DB. For column'||V_USER_FIELD_NAME||':'||V_SQL_MULTI_CODE_VAL;
                                                          DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                               P_DA_ROW_ID, 
                                                               p_MODULE_NAME,
                                                               V_ERROR_LOCATION, 
                                                               V_ERROR_LOCATION,
                                                               'DDS_SUPPLEMENT',
                                                               V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                               P_KEYCOLUMN, 
                                                               'DDS_'||P_MODULE_NAME,
                                                               P_KEYVALUE);*/
                                                         
                                                     END IF;      
                                                     V_ERROR_LOCATION:=28;   
                                                     IF V_CODE_ID_M_R IS NOT NULL THEN
                                                       V_CODE_ID_M_R:= V_CODE_ID_M_R||'|'||NVL(V_CODE_ID_R,0);
                                                     ELSE 
                                                        V_CODE_ID_M_R:= NVL(V_CODE_ID_R,0);  
                                                     END IF; 
                                                                   
                                           END LOOP;
                                          CLOSE    l_CURSOR_MULTI_CODE;    
                                          V_ERROR_LOCATION:=29;   
                                          --UPDATING MULTICODES VALUE IN TEMP TABLE
                                           V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                           EXECUTE IMMEDIATE V_SQL_VALUE USING V_CODE_ID_M_R, P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                           
                                           COMMIT;      
                                      END IF; --CODE VALIDATION COMPLETE HERE  FOR MULTI VALUE
                                 END IF; -- WE ARE GOING TO CREATE CODES WHEN END
                           END IF; -- IF VALIDATED FLAG IS SET THEN ONLY START VALIDATION OF RECORD START, IF 0 THEN NO NEED TO DO VALIDATION
                         
                         V_ERROR_LOCATION:=30;
                         -- STATE CODE VALIDATION START HERE
                         IF  V_FIELD_TYPE_NAME = 'STATE_FIELD' THEN
                         V_ERROR_LOCATION:=31;
                            IF V_MULTI_VAL <> 1 THEN -- FOR SINGLE VALUE START HERE
                            V_ERROR_LOCATION:=32;
                                   V_SQL_STATES := 'SELECT STATE_ROW_ID FROM '||V_DB_NAME||'STATES WHERE STATE_ID = :1 ';
                                   BEGIN
                                        EXECUTE IMMEDIATE V_SQL_STATES INTO V_STATE_ROW_ID USING UPPER(V_USER_FIELD_NAME_VALUE) ;
                                    EXCEPTION
                                             WHEN NO_DATA_FOUND THEN
                                                  V_ERROR_LOCATION:=33;
                                                  IF V_VALIDATE_FLAG = 1  THEN -- STATE VALIDATION FLAG IS ON -- START HERE
                                                      V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                      V_ERROR_LOCATION:=34;
                                                     IF  V_USER_FIELD_NAME_VALUE IS NULL and V_NULL_FLAG = 0 THEN
                                                          V_ERROR_MSG:='Validation failed as allow null is not checked and no value is provided in '||V_USER_FIELD_NAME;
                                                     ELSIF V_USER_FIELD_NAME_VALUE IS NOT NULL THEN
                                                         V_ERROR_MSG:='Validation failed as State value does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                     END IF;     
                                                     
                                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                           P_DA_ROW_ID, 
                                                           p_MODULE_NAME,
                                                           V_ERROR_LOCATION, 
                                                           V_ERROR_LOCATION,
                                                           'DDS_SUPPLEMENT',
                                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                           V_USER_FIELD_NAME, 
                                                           'DDS_'||P_MODULE_NAME,
                                                           P_KEYCOLUMN,
                                                           P_KEYVALUE,
                                                           1);

                                                  ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                                      V_ERROR_MSG:='State value does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                       V_ERROR_LOCATION:=35;
                                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                           P_DA_ROW_ID, 
                                                           p_MODULE_NAME,
                                                           V_ERROR_LOCATION, 
                                                           V_ERROR_LOCATION,
                                                           'DDS_SUPPLEMENT',
                                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                           V_USER_FIELD_NAME, 
                                                           'DDS_'||P_MODULE_NAME,
                                                           P_KEYCOLUMN,
                                                           P_KEYVALUE,
                                                           1); 
                                                  ELSIF V_VALIDATE_FLAG <> 1 and V_NULL_FLAG = 0 AND V_USER_FIELD_NAME_VALUE IS NULL  THEN
                                                   V_ERROR_MSG:='Allow null is not checked. Please provide the value in '||V_USER_FIELD_NAME;
                                                       V_ERROR_LOCATION:=35;
                                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                           P_DA_ROW_ID, 
                                                           p_MODULE_NAME,
                                                           V_ERROR_LOCATION, 
                                                           V_ERROR_LOCATION,
                                                           'DDS_SUPPLEMENT',
                                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                           V_USER_FIELD_NAME, 
                                                           'DDS_'||P_MODULE_NAME,
                                                           P_KEYCOLUMN,
                                                           P_KEYVALUE,
                                                           1);
                                                    ELSIF V_VALIDATE_FLAG <> 1 and V_NULL_FLAG = 1 AND V_USER_FIELD_NAME_VALUE IS NULL  THEN         
                                                         V_STATE_ROW_ID := -1;        
                                                  END IF;   -- STATE VALIDATION FLAG IS ON -- END  HERE
                                                    
                                             WHEN TOO_MANY_ROWS THEN
                                                  NULL;
                                             WHEN OTHERS THEN
                                                  V_ERROR_MSG:=SQLERRM;
                                                   V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                       P_DA_ROW_ID, 
                                                       p_MODULE_NAME,
                                                       V_ERROR_LOCATION, 
                                                       V_ERROR_LOCATION,
                                                       'DDS_SUPPLEMENT',
                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                       V_USER_FIELD_NAME, 
                                                       'DDS_'||P_MODULE_NAME,
                                                       P_KEYCOLUMN,
                                                       P_KEYVALUE,
                                                       0);
                                    END;
                                   -- UPDATING STATE ROW ID INTO THE TEMP TABLE 
                                   V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                    V_ERROR_LOCATION:=36;
                                   EXECUTE IMMEDIATE  V_SQL_VALUE USING V_STATE_ROW_ID, P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                   COMMIT; 
                             ELSE -- FOR MULTI VALUE START HERE
                                 V_ERROR_LOCATION:=37;
                                 V_SQL_STATES :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                             connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                      
                                           OPEN l_CURSOR_STATES FOR V_SQL_STATES;
                                            LOOP
                                              FETCH l_CURSOR_STATES INTO V_SQL_STATES_VAL ;
                                              EXIT WHEN l_CURSOR_STATES%NOTFOUND;    
                                              
                                               V_SQL_STATES := 'SELECT STATE_ROW_ID FROM '||V_DB_NAME||'STATES WHERE STATE_ID = :1 ';
                                                V_ERROR_LOCATION:=38;
                                                BEGIN
                                                     EXECUTE IMMEDIATE V_SQL_STATES INTO V_STATE_ROW_ID USING UPPER(V_SQL_STATES_VAL) ;
                                                EXCEPTION
                                                       WHEN NO_DATA_FOUND THEN
                                                             IF V_VALIDATE_FLAG = 1  THEN -- STATE VALIDATION FLAG IS ON -- START HERE
                                                                    V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                                    V_ERROR_LOCATION:=40;
                                                                   IF  V_USER_FIELD_NAME_VALUE IS NULL and V_NULL_FLAG = 0 THEN
                                                                        V_ERROR_MSG:='Validation failed as allow null is not checked and no value is provided in '||V_USER_FIELD_NAME;
                                                                   ELSIF V_USER_FIELD_NAME_VALUE IS NOT NULL THEN
                                                                       V_ERROR_MSG:='Validation failed as validation flag is ON. State value does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                                   END IF;     
                                                                   
                                                                     DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                         P_DA_ROW_ID, 
                                                                         p_MODULE_NAME,
                                                                         V_ERROR_LOCATION, 
                                                                         V_ERROR_LOCATION,
                                                                         'DDS_SUPPLEMENT',
                                                                         V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         V_USER_FIELD_NAME, 
                                                                         'DDS_'||P_MODULE_NAME,
                                                                         P_KEYCOLUMN,
                                                                         P_KEYVALUE,
                                                                         1);
              
                                                                ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                                                    V_ERROR_MSG:='State value does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                                     V_ERROR_LOCATION:=41;
                                                                     DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                         P_DA_ROW_ID, 
                                                                         p_MODULE_NAME,
                                                                         V_ERROR_LOCATION, 
                                                                         V_ERROR_LOCATION,
                                                                         'DDS_SUPPLEMENT',
                                                                         V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         V_USER_FIELD_NAME, 
                                                                         'DDS_'||P_MODULE_NAME,
                                                                         P_KEYCOLUMN,
                                                                         P_KEYVALUE,
                                                                         1);
                                                                         
                                                                ELSIF V_VALIDATE_FLAG <> 1 and V_NULL_FLAG = 0 AND V_USER_FIELD_NAME_VALUE IS NULL  THEN
                                                                       V_ERROR_MSG:='Allow null is not checked. Please provide the value in '||V_USER_FIELD_NAME;
                                                                       V_ERROR_LOCATION:=61;
                                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                       P_DA_ROW_ID, 
                                                                       p_MODULE_NAME,
                                                                       V_ERROR_LOCATION, 
                                                                       V_ERROR_LOCATION,
                                                                       'DDS_SUPPLEMENT',
                                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                        V_USER_FIELD_NAME, 
                                                                         'DDS_'||P_MODULE_NAME,
                                                                         P_KEYCOLUMN,
                                                                         P_KEYVALUE,
                                                                         1);          
                                                                ELSIF V_VALIDATE_FLAG <> 1 and V_NULL_FLAG = 1 and V_USER_FIELD_NAME_VALUE IS NULL  THEN
                                                                       V_STATE_ROW_ID := -1;        
                                                                END IF;   -- STATE VALIDATION FLAG IS ON -- END  HERE
                                                       WHEN TOO_MANY_ROWS THEN
                                                            NULL;
                                                       WHEN OTHERS THEN
                                                            V_ERROR_MSG:=SQLERRM;
                                                             V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                             DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                 P_DA_ROW_ID, 
                                                                 p_MODULE_NAME,
                                                                 V_ERROR_LOCATION, 
                                                                 V_ERROR_LOCATION,
                                                                 'DDS_SUPPLEMENT',
                                                                 V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                 V_USER_FIELD_NAME, 
                                                                 'DDS_'||P_MODULE_NAME,
                                                                 P_KEYCOLUMN,
                                                                 P_KEYVALUE,
                                                                 0);
                                                END;
                                      
            
                                                     IF V_STATE_ROW_ID_M_R IS NOT NULL THEN
                                                       V_STATE_ROW_ID_M_R:= V_STATE_ROW_ID_M_R||'|'||NVL(V_STATE_ROW_ID,0);
                                                     ELSE 
                                                        V_STATE_ROW_ID_M_R:= NVL(V_STATE_ROW_ID,-1);  
                                                     END IF; 
                                                     
                                            END LOOP;
                                          CLOSE    l_CURSOR_STATES;
                                   -- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
                                   V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                   V_ERROR_LOCATION:=42;
                                   EXECUTE IMMEDIATE V_SQL_VALUE USING V_STATE_ROW_ID_M_R,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;     
                                   V_STATE_ROW_ID_M_R := NULL;
                                   COMMIT;
                             END IF; -- SINGLE AND MULTI VALUE STATES WORK END HERE
                                    
                          END IF;
                         -- STATE CODE VALIDATION END HERE
                         
                         --ENTITY VALIDATION STARTS HERE
                         IF  V_FIELD_TYPE_NAME = 'ENTITY_FIELD' THEN
                         
                         -- CHECK EROLE FLAG
                            V_SQL_ENTITY:= 'SELECT STR_PARM_VALUE FROM '||V_DB_NAME||'PARMS_NAME_VALUE where PARM_NAME =:1';
                            
                            EXECUTE IMMEDIATE V_SQL_ENTITY INTO V_EROLE_FLAG  USING 'USE_ENTITY_ROLE' ;
                            
                            --SELECT STR_PARM_VALUE INTO V_EROLE_FLAG from PARMS_NAME_VALUE where PARM_NAME ='USE_ENTITY_ROLE' ;
                            
                            IF V_EROLE_FLAG <> 0 THEN -- IF E ROLE FLAG IS ON THEN TABLE ID MUST BE 0
                               V_CODE_FILE_ID_C := 0; -- SETTING UP THE TABLE ID VALUE TO 0 IF EROLE IS ON
                            END IF;
                         
                             IF V_MULTI_VAL <> 1 THEN -- FOR SINGLE ENTITY FIELD VALUE START HERE
                                IF V_USER_FIELD_NAME_VALUE IS NULL AND V_NULL_FLAG = 0 THEN -- CHECKING ENTITY NAME IS NULL OR NOT NULL
                                          IF V_VALIDATE_FLAG = 1  THEN -- ENTITY VALIDATION FLAG IS ON IN CASE OF USER FIELD NOT PROVIDED VALUE-- START HERE
                                              V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                              V_ERROR_LOCATION:=43;
                                              V_ERROR_MSG:='Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                           
                                             DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                 P_DA_ROW_ID, 
                                                 p_MODULE_NAME,
                                                 V_ERROR_LOCATION, 
                                                 V_ERROR_LOCATION,
                                                 'DDS_SUPPLEMENT',
                                                 V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                 V_USER_FIELD_NAME, 
                                                 'DDS_'||P_MODULE_NAME,
                                                 P_KEYCOLUMN,
                                                 P_KEYVALUE,
                                                 1);
      
                                           ELSIF V_VALIDATE_FLAG <> 1 THEN
                                                 V_ENTITY_ID:=0;
                                        END IF;   -- ENTITY VALIDATION FLAG IS ON IN CASE OF USER FIELD NOT PROVIDED VALUE -- END  HERE
                                  
                                ELSIF V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                   V_SQL_ENTITY := 'SELECT ENTITY_ID FROM '||V_DB_NAME||'ENTITY WHERE ENTITY_TABLE_ID =:1 AND UPPER(LAST_NAME) =:2';
                                   V_ERROR_LOCATION:=44;
                                   BEGIN
                                       EXECUTE IMMEDIATE V_SQL_ENTITY INTO V_ENTITY_ID USING V_CODE_FILE_ID_C, UPPER(V_USER_FIELD_NAME_VALUE);
                                   EXCEPTION
                                      WHEN NO_DATA_FOUND THEN
                                            IF V_VALIDATE_FLAG = 1  THEN -- ENTITY VALIDATION FLAG IS ON -- START HERE
                                              V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                              V_ERROR_LOCATION:=45;
                                              V_ERROR_MSG:='Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                             
                                               DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                   P_DA_ROW_ID, 
                                                   p_MODULE_NAME,
                                                   V_ERROR_LOCATION, 
                                                   V_ERROR_LOCATION,
                                                   'DDS_SUPPLEMENT',
                                                   V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                   V_USER_FIELD_NAME, 
                                                   'DDS_'||P_MODULE_NAME,
                                                    P_KEYCOLUMN,
                                                   P_KEYVALUE,
                                                   1);

                                              ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                                  V_ERROR_MSG:='Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                   V_ERROR_LOCATION:=46;
                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                       P_DA_ROW_ID, 
                                                       p_MODULE_NAME,
                                                       V_ERROR_LOCATION, 
                                                       V_ERROR_LOCATION,
                                                       'DDS_SUPPLEMENT',
                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                       V_USER_FIELD_NAME, 
                                                   'DDS_'||P_MODULE_NAME,
                                                    P_KEYCOLUMN,
                                                   P_KEYVALUE,
                                                   1); 
                                              END IF;   -- ENTITY VALIDATION FLAG IS ON -- END  HERE
                                       WHEN TOO_MANY_ROWS THEN
                                            NULL;
                                       WHEN OTHERS THEN
                                            NULL;
                                   END;
                                   
                                   IF V_ENTITY_ID = 0 AND V_USER_FIELD_NAME_VALUE IS NOT NULL THEN -- IF ENTITY ID IS 0 THEN NEED TO CHECK FOR ABBREVIATION
                                        V_SQL_ENTITY := 'SELECT ENTITY_ID FROM '||V_DB_NAME||'ENTITY WHERE ENTITY_TABLE_ID =:1 AND UPPER(ABBREVIATION) =:2';
                                   
                                       BEGIN
                                           EXECUTE IMMEDIATE V_SQL_ENTITY INTO V_ENTITY_ID USING V_CODE_FILE_ID_C, UPPER(V_USER_FIELD_NAME_VALUE);
                                       EXCEPTION
                                          WHEN NO_DATA_FOUND THEN
                                              IF V_VALIDATE_FLAG = 1  THEN -- ENTITY VALIDATION FLAG IS ON -- START HERE
                                                  V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                  V_ERROR_LOCATION:=47;
                                                  V_ERROR_MSG:='Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                 
                                               DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                   P_DA_ROW_ID, 
                                                   p_MODULE_NAME,
                                                   V_ERROR_LOCATION, 
                                                   V_ERROR_LOCATION,
                                                   'DDS_SUPPLEMENT',
                                                   V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                   V_USER_FIELD_NAME, 
                                                   'DDS_'||P_MODULE_NAME,
                                                    P_KEYCOLUMN,
                                                   P_KEYVALUE,
                                                   1);

                                              ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                                  V_ERROR_MSG:='Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                   V_ERROR_LOCATION:=48;
                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                       P_DA_ROW_ID, 
                                                       p_MODULE_NAME,
                                                       V_ERROR_LOCATION, 
                                                       V_ERROR_LOCATION,
                                                       'DDS_SUPPLEMENT',
                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                       V_USER_FIELD_NAME, 
                                                       'DDS_'||P_MODULE_NAME,
                                                       P_KEYCOLUMN,
                                                       P_KEYVALUE,
                                                       1); 
                                              END IF;   -- ENTITY VALIDATION FLAG IS ON -- END  HERE
                                           WHEN TOO_MANY_ROWS THEN
                                                NULL;
                                           WHEN OTHERS THEN
                                                V_ERROR_MSG:=SQLERRM;
                                                 V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                               DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                   P_DA_ROW_ID, 
                                                   p_MODULE_NAME,
                                                   V_ERROR_LOCATION, 
                                                   V_ERROR_LOCATION,
                                                   'DDS_SUPPLEMENT',
                                                   V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                   V_USER_FIELD_NAME, 
                                                   'DDS_'||P_MODULE_NAME,
                                                   P_KEYCOLUMN,
                                                   P_KEYVALUE,
                                                   0);
                                       END;
                                   END IF;
                                   
                                END IF;
                                
                                   V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                     V_ERROR_LOCATION:=51;
                                   EXECUTE IMMEDIATE V_SQL_VALUE USING V_ENTITY_ID, P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                   COMMIT;  
                               -- FOR SINGLE ENTITY FIELD VALUE END HERE 
                             ELSIF V_MULTI_VAL = 1 THEN   -- FOR MULTI VALUE ENTITY FIELD START HERE
                                 V_SQL_ENTITY :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                           connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                      
                                           OPEN l_CURSOR_ENTITY FOR V_SQL_ENTITY;
                                            LOOP
                                              FETCH l_CURSOR_ENTITY INTO V_SQL_ENTITY_VAL ;
                                              EXIT WHEN l_CURSOR_ENTITY%NOTFOUND;    
                                              
                                               V_SQL_ENTITY_C := 'SELECT ENTITY_ID FROM '||V_DB_NAME||'ENTITY WHERE ENTITY_TABLE_ID =:1 AND UPPER(LAST_NAME) =:2';
                                                
                                                BEGIN
                                                     EXECUTE IMMEDIATE V_SQL_ENTITY_C INTO V_ENTITY_ID USING V_CODE_FILE_ID_C, UPPER(V_SQL_ENTITY_VAL);
                                                EXCEPTION
                                                       WHEN NO_DATA_FOUND THEN
                                                             IF V_VALIDATE_FLAG = 1  THEN -- ENTITY VALIDATION FLAG IS ON -- START HERE
                                                                  V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                                  V_ERROR_LOCATION:=49;
                                                                  V_ERROR_MSG:='Validation failed as validation flag is ON. Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                                 
                                                               DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                   P_DA_ROW_ID, 
                                                                   p_MODULE_NAME,
                                                                   V_ERROR_LOCATION, 
                                                                   V_ERROR_LOCATION,
                                                                   'DDS_SUPPLEMENT',
                                                                   V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                   V_USER_FIELD_NAME, 
                                                                   'DDS_'||P_MODULE_NAME,
                                                                    P_KEYCOLUMN,
                                                                   P_KEYVALUE,
                                                                   1);
                
                                                              ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NOT NULL  THEN
                                                                  V_ERROR_MSG:='Entity does not exists in RM DB. Please provide the correct value in '||V_USER_FIELD_NAME;
                                                                   V_ERROR_LOCATION:=50;
                                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                       P_DA_ROW_ID, 
                                                                       p_MODULE_NAME,
                                                                       V_ERROR_LOCATION, 
                                                                       V_ERROR_LOCATION,
                                                                       'DDS_SUPPLEMENT',
                                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                       V_USER_FIELD_NAME, 
                                                                       'DDS_'||P_MODULE_NAME,
                                                                        P_KEYCOLUMN,
                                                                       P_KEYVALUE,
                                                                       1); 
                                                               ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NULL AND V_NULL_FLAG=0 THEN
                                                                   V_ERROR_MSG:='Allow null is not allowed. Please provide the value in '||V_USER_FIELD_NAME;
                                                                   V_ERROR_LOCATION:=63;
                                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                       P_DA_ROW_ID, 
                                                                       p_MODULE_NAME,
                                                                       V_ERROR_LOCATION, 
                                                                       V_ERROR_LOCATION,
                                                                       'DDS_SUPPLEMENT',
                                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                       V_USER_FIELD_NAME, 
                                                                       'DDS_'||P_MODULE_NAME,
                                                                        P_KEYCOLUMN,
                                                                       P_KEYVALUE,
                                                                       1);  
                                                               ELSIF V_VALIDATE_FLAG <> 1 and V_USER_FIELD_NAME_VALUE IS NULL AND V_NULL_FLAG=1 THEN
                                                                       V_ENTITY_ID := 0;                
                                                              END IF;   -- ENTITY VALIDATION FLAG IS ON -- END  HERE
                                                       WHEN TOO_MANY_ROWS THEN
                                                            NULL;
                                                       WHEN OTHERS THEN
                                                            V_ERROR_MSG:=SQLERRM;
                                                             V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                           DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                               P_DA_ROW_ID, 
                                                               p_MODULE_NAME,
                                                               V_ERROR_LOCATION, 
                                                               V_ERROR_LOCATION,
                                                               'DDS_SUPPLEMENT',
                                                               V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                               V_USER_FIELD_NAME, 
                                                               'DDS_'||P_MODULE_NAME,
                                                               P_KEYCOLUMN,
                                                               P_KEYVALUE,
                                                               0);
                                                END;
            
                                                 IF V_ENTITY_ID_M_R IS NOT NULL THEN
                                                   V_ENTITY_ID_M_R:= V_ENTITY_ID_M_R||'|'||NVL(V_ENTITY_ID,0);
                                                 ELSE 
                                                    V_ENTITY_ID_M_R:= NVL(V_ENTITY_ID,0);  
                                                 END IF; 
                                                 
                                            END LOOP;
                                          CLOSE    l_CURSOR_ENTITY;
                                   -- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
                                   V_SQL_VALUE:='UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                     V_ERROR_LOCATION:=51;
                                   EXECUTE IMMEDIATE V_SQL_VALUE USING V_ENTITY_ID_M_R, P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                   COMMIT;  
                                   V_ENTITY_ID_M_R:=NULL; -- KAPIL 22-fEB-2016
                             END IF;    -- SINGLE AND MULTI VALUE STATES WORK END HERE
                         END IF;
                         --ENTITY VALIDATION END HERE
                         
                         -- Text Field Validation Start here
                         IF  V_FIELD_TYPE_NAME = 'TXTCODE_FIELD' THEN                                               
                             V_ERROR_LOCATION:=52;  
                             IF V_MULTI_VAL <> 1 THEN -- FOR SINGLE TEXT FIELD VALUE START HERE
                                  SELECT INSTR(V_USER_FIELD_NAME_VALUE,'-') INTO V_CHK_TXT_CODE from dual;    
                                  V_ERROR_LOCATION:=53;  
                                  IF V_CHK_TXT_CODE > 0 THEN -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
                                     SELECT trim(substr(V_USER_FIELD_NAME_VALUE,1, instr(V_USER_FIELD_NAME_VALUE,'-')-1)) 
                                       INTO V_TXT_CODE
                                     FROM DUAL; -- FETCHING CODE VALUE FROM THE STRING
                                     
                                     SELECT trim(substr(V_USER_FIELD_NAME_VALUE,instr(V_USER_FIELD_NAME_VALUE,'-')+1)) 
                                        INTO V_TXT_DESC
                                     FROM DUAL; -- FETCHING DESCRIPTION VALUE FROM THE STRING
                                   
                                   ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
                                     V_TXT_CODE := V_USER_FIELD_NAME_VALUE;
                                     V_TXT_DESC := NULL;
                                  END IF;
                                  IF V_TXT_CODE IS NOT NULL THEN
                                     V_ERROR_LOCATION:=55;  
                                        DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                         V_TXT_CODE, -- Short Code
                                                                         V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                         P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                         --1, -- It is used to check are we able to create code for that system table name or not
                                                                         P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                         P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                         P_KEYVALUE,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         V_TXT_CODE_R
                                                                         );
                                        
                                                    IF (V_TXT_CODE_R = 0 OR V_TXT_CODE_R IS NULL) AND V_TXT_CODE IS NOT NULL THEN
                                                                   V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                                   V_ERROR_LOCATION:=56;  
                                                                   -- Commenting the below code as error log is getting captured in code procedure
                                                                       /*V_ERROR_MSG:='Code does not exists in RM DB. For column'||V_USER_FIELD_NAME||':'||V_TXT_CODE;
                                                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                           P_DA_ROW_ID, 
                                                                           p_MODULE_NAME,
                                                                           V_ERROR_LOCATION, 
                                                                           V_ERROR_LOCATION,
                                                                           'DDS_SUPPLEMENT',
                                                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                           P_KEYCOLUMN, 
                                                                           'DDS_'||P_MODULE_NAME,
                                                                           P_KEYVALUE);*/
                                                    ELSE
                                                       V_SQL_VALUE:= 'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                        --'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'= NVL('||V_TXT_CODE_R||',0)'||' - '||V_TXT_DESC||' WHERE DA_ROW_ID=:1 AND JOBID=:2  AND MODULE_NAME = :3';
                                            
                                                        EXECUTE IMMEDIATE V_SQL_VALUE USING NVL(V_TXT_CODE_R,0)|| ' - '|| V_TXT_DESC,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                                        
                                                        COMMIT;                 
                                                    END IF;                                       
                                      

                                 END IF; 
                              ELSIF V_MULTI_VAL = 1 AND V_USER_FIELD_NAME_VALUE IS NOT NULL THEN  -- FOR MULTI VALUE TEXT FIELD START HERE
                                    V_ERROR_LOCATION:=57;  
                                  V_SQL_TXT_CODE :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                           connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                           OPEN l_CURSOR_TXT_CODE FOR V_SQL_TXT_CODE;
                                            LOOP
                                              FETCH l_CURSOR_TXT_CODE INTO V_SQL_TXT_CODE_VAL ;
                                              EXIT WHEN l_CURSOR_TXT_CODE%NOTFOUND;    
                                                 
                                                 SELECT INSTR(V_SQL_TXT_CODE_VAL,'-') INTO V_CHK_TXT_CODE from dual; 
                                                 
                                                  IF V_CHK_TXT_CODE > 0 THEN -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
                                                     SELECT trim(substr(V_SQL_TXT_CODE_VAL,1, instr(V_SQL_TXT_CODE_VAL,'-')-1)) 
                                                       INTO V_TXT_CODE
                                                     FROM DUAL; -- FETCHING CODE VALUE FROM THE STRING
                                                     
                                                     SELECT trim(substr(V_SQL_TXT_CODE_VAL,instr(V_SQL_TXT_CODE_VAL,'-')+1)) 
                                                        INTO V_TXT_DESC
                                                     FROM DUAL; -- FETCHING DESCRIPTION VALUE FROM THE STRING
                                                   
                                                   ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
                                                     V_TXT_CODE := V_SQL_TXT_CODE_VAL;
                                                     V_TXT_DESC := NULL;
                                                  END IF;                                        
                                                       
                                                  IF V_TXT_CODE IS NOT NULL THEN
                                                        V_ERROR_LOCATION:=58;  
                                                        DDS_CODE_VALIDATION_IMPORT(P_JOBID, 
                                                                         V_TXT_CODE, -- Short Code
                                                                         V_SQL_SYS_TAB_NAME_V, -- SYstem Table Name to Check
                                                                         P_CODE_CREATION_FLAG, -- It is used to check allow creation of code flag is set by user or not
                                                                         --1, -- It is used to check are we able to create code for that system table name or not
                                                                         P_DB_NAME, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         P_LOB, -- LOB GC, WC ( It Will be numeric)
                                                                         P_DA_ROW_ID , -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         p_MODULE_NAME,--||'_SUPP', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         V_ERROR_LOCATION, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_SUPPLEMENT', -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         P_KEYCOLUMN, -- It is used to fetch error msg and append into the error msg and update it again
                                                                         V_USER_FIELD_NAME,  -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         'DDS_'||P_MODULE_NAME,-- Used for ERROR_LOG_CAPTURE Procedure
                                                                         P_KEYVALUE, -- Used for ERROR_LOG_CAPTURE Procedure
                                                                         V_TXT_CODE_R
                                                                         );
                                      
                                                         
                                                            IF (V_TXT_CODE_R = 0 OR V_TXT_CODE_R IS NULL) AND V_TXT_CODE IS NOT NULL THEN
                                                                   V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                                   --V_ERROR_LOCATION:=59;  
                                                                   -- Commenting the below code as error log is getting captured in code procedure
                                                                      /* V_ERROR_MSG:='Code does not exists in RM DB. For column'||V_USER_FIELD_NAME||':'||V_TXT_CODE;
                                                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                                           P_DA_ROW_ID, 
                                                                           p_MODULE_NAME,
                                                                           V_ERROR_LOCATION, 
                                                                           V_ERROR_LOCATION,
                                                                           'DDS_SUPPLEMENT',
                                                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                                           P_KEYCOLUMN, 
                                                                           'DDS_'||P_MODULE_NAME,
                                                                           P_KEYVALUE);*/
                                                           END IF;            
                                                         
                                                         
                                                         IF V_TXT_CODE_CODE_DESC_R IS NOT NULL THEN
                                                            V_TXT_CODE_CODE_DESC_R:= V_TXT_CODE_CODE_DESC_R||'|'||NVL(V_TXT_CODE_R,0) ||' - '||V_TXT_DESC;
                                                         ELSE 
                                                            V_TXT_CODE_CODE_DESC_R:= NVL(V_TXT_CODE_R,0) ||' - '||V_TXT_DESC;
                                                         END IF; 
                                                         
                                                   END IF; 
                                                       
                                            END LOOP;
                                          CLOSE l_CURSOR_TXT_CODE;                      
                                          -- UPDATING MULTI STATE ROW ID INTO THE TEMP TABLE 
                                          V_SQL_VALUE:= 'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'='||':1 WHERE DA_ROW_ID=:2 AND JOBID=:3  AND MODULE_NAME = :4';
                                          --'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET '||V_USER_FIELD_NAME ||'= '||V_TXT_CODE_CODE_DESC_R||' WHERE DA_ROW_ID=:1 AND JOBID=:2  AND MODULE_NAME = :3';
                                          V_ERROR_LOCATION:=60;  
                                          EXECUTE IMMEDIATE V_SQL_VALUE USING V_TXT_CODE_CODE_DESC_R,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;
                                          /*EXECUTE IMMEDIATE 'UPDATE DDS_SUPPLEMENTAL_RUNTIME_DATA SET USER_FIELD_TXT_CODE=:1 WHERE DA_ROW_ID=:2 AND JOBID=:3 AND MODULE_NAME = :4' USING 
                                          V_USER_FIELD_NAME_VALUE,P_DA_ROW_ID,P_JOBID, P_MODULE_NAME ;-- KAPIL ON 16-FEB-2016*/
                                          COMMIT;  
                                          V_TXT_CODE_CODE_DESC_R:=NULL; -- KAPIL -- 22-FEB-2016
                             END IF;-- FOR SINGLE AND MULTI TEXT FIELD VALUE END HERE
                         END IF;
                         -- Text Field Validation End here
                         
                   P_SUPP_ERROR_COUNT:=V_ERROR_COUNT; -- SETTING UP THE ERROR VALUE FLAG IF THERE IS ANY

                  END IF; -- VALIDATION FLAG / STAGE WORK COMPLETED / END HERE       
                     
                 /*BELOW CODE IS THE COMMON CODE FOR BOTH VALIDATION FLAG 0 AND 1. IN IT WE ARE GOING TO CHECK
                 THAT RECORD EXISTS IN RM DB OR NOT AND IF NOT EXISTS THEN WE INSERTING THE RELATED INFORMATION INTO THE TARGET 
                 TABLES ACCORDINGLY*/
                 
                 
                 -- RM TABLE CHECK PROCESSING START
                         
                  IF P_STAGE='I' THEN-- INSERTION FLAG / STAGE WORK COMPLETED / START HERE            
                      IF P_BASE_ERROR_COUNT = 0  THEN   -- MAIN IF FOR RM DB WORK START HERE
                      -- CHECKING CLAIMANT EXISTS IN CLAIMANT SUPP OR NOT, IF EXISTS THEN IT WILL BE A UPDATE CASE OTHERWISE INSERT CASE
                        IF V_MAPPED_TABLE = 'CLAIMANT_SUPP' THEN -- CLAIMANT SUPP START HERE
                        
                          V_SQL_RM_SUPP := 'SELECT CLAIMANT_ROW_ID FROM '||V_DB_NAME||'CLAIMANT_SUPP WHERE CLAIM_ID = :1 AND CLAIMANT_EID = :2';
                           V_TAB_PK_COL_NAME:='CLAIMANT_ROW_ID'; -- Kapil 25-feb-2016
                            BEGIN
                              --EXECUTE IMMEDIATE V_SQL_RM_SUPP INTO V_TAB_PK_ID USING P_CLAIM_ID, P_CLAIMANT_EID;
                              EXECUTE IMMEDIATE V_SQL_RM_SUPP INTO V_TAB_PK_COL_VAL USING P_CLAIM_ID, P_CLAIMANT_EID; -- Kapil 25-feb-2016
                               V_INS_UPD_FLAG := 'U';
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     IF V_TAB_PK_ID IS NULL THEN
                                         V_SQL_RM_SUPP := 'SELECT CLAIMANT_ROW_ID FROM '||V_DB_NAME||'CLAIMANT WHERE CLAIM_ID = :1 AND CLAIMANT_EID = :2';
                                         
                                         BEGIN
                                              EXECUTE IMMEDIATE V_SQL_RM_SUPP INTO V_TAB_PK_COL_VAL USING P_CLAIM_ID, P_CLAIMANT_EID; -- Kapil 25-feb-2016 from V_TAB_PK_ID to V_TAB_PK_COL_VAL
                                              V_INS_UPD_FLAG := 'I';
                                           EXCEPTION
                                              WHEN NO_DATA_FOUND THEN
                                                   NULL; -- IF NO ROWS FOUND THEN WE NEED TO RETURN EXIT THE CODE
                                                 -- NEED TO ADD ERROR MESSAGE THAT CLAIMANT DOES NOT EXISTS.
                                              WHEN TOO_MANY_ROWS THEN
                                                  NULL;
                                              WHEN OTHERS THEN
                                                   V_ERROR_MSG:=SQLERRM;
                                                    V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                                   DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                       P_DA_ROW_ID, 
                                                       p_MODULE_NAME,
                                                       V_ERROR_LOCATION, 
                                                       V_ERROR_LOCATION,
                                                       'DDS_SUPPLEMENT',
                                                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                                       V_USER_FIELD_NAME, 
                                                       'DDS_'||P_MODULE_NAME,
                                                       P_KEYCOLUMN,
                                                       P_KEYVALUE,
                                                       0);
                                                   -- NEED ERROR MESSAGE
                                           END;      
                                     END IF;
                                   --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
                                WHEN TOO_MANY_ROWS THEN
                                    NULL;
                                WHEN OTHERS THEN
                                    V_ERROR_MSG:=SQLERRM;
                                     V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                       DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           P_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           V_ERROR_LOCATION, 
                                           V_ERROR_LOCATION,
                                           'DDS_SUPPLEMENT',
                                           V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                           V_USER_FIELD_NAME, 
                                           'DDS_'||P_MODULE_NAME,
                                           P_KEYCOLUMN,
                                           P_KEYVALUE,
                                           0);
                                     -- NEED ERROR MESSAGE
                             END;  
                        ELSE
                            --MAKING DYNAMIC QUERY FOR REST OF THE TABLES AND CHECKING RECORD EXISTS IN IT OR NOT -- START
                            IF V_MAPPED_TABLE = 'EVENT_SUPP' OR V_MAPPED_TABLE = 'EVENT_X_MEDW_SUPP' OR V_MAPPED_TABLE = 'FALL_IND_SUPP' THEN 
                              V_TAB_PK_COL_NAME:='EVENT_ID';
                              V_TAB_PK_COL_VAL:=P_EVENT_ID;
                            ELSIF  V_MAPPED_TABLE = 'CLAIM_SUPP' THEN
                              V_TAB_PK_COL_NAME:='CLAIM_ID';
                              V_TAB_PK_COL_VAL:=P_CLAIM_ID;
                            ELSIF  V_MAPPED_TABLE = 'EMP_SUPP' THEN
                              V_TAB_PK_COL_NAME:='EMPLOYEE_EID';
                              V_TAB_PK_COL_VAL:=P_EMPLOYEE_EID;
                            ELSIF  V_MAPPED_TABLE = 'VEHICLE_SUPP' THEN
                              V_TAB_PK_COL_NAME:='UNIT_ID';
                              V_TAB_PK_COL_VAL:=P_UNIT_ID;
                            ELSIF  V_MAPPED_TABLE = 'ENTITY_SUPP' THEN
                              V_TAB_PK_COL_NAME:='ENTITY_ID';  
                              V_TAB_PK_COL_VAL:=P_ENTITY_ID;
                            ELSIF  V_MAPPED_TABLE = 'DEFENDANT_SUPP' THEN
                              V_TAB_PK_COL_NAME:='DEFENDANT_ROW_ID';
                              V_TAB_PK_COL_VAL:=P_DEFENDANT_ROW_ID;
                            ELSIF  V_MAPPED_TABLE = 'PI_SUPP' THEN
                              V_TAB_PK_COL_NAME:='PI_ROW_ID';
                              V_TAB_PK_COL_VAL:=P_PI_ROW_ID;
                            ELSIF  V_MAPPED_TABLE = 'PI_X_PROC_SUPP' THEN
                              V_TAB_PK_COL_NAME:='PI_PROC_ROW_ID';
                              V_TAB_PK_COL_VAL:=P_PI_PROC_ROW_ID;
                            ELSIF  V_MAPPED_TABLE = 'PATIENT_SUPP' THEN
                              V_TAB_PK_COL_NAME:='PATIENT_ID';
                              V_TAB_PK_COL_VAL:=P_PATIENT_ID;
                            ELSIF  V_MAPPED_TABLE = 'FUNDS_SUPP' THEN
                              V_TAB_PK_COL_NAME:='TRANS_ID';  
                              V_TAB_PK_COL_VAL:=P_TRANS_ID;
                            ELSIF  V_MAPPED_TABLE = 'DIS_PLAN_SUPP' THEN
                              V_TAB_PK_COL_NAME:='PLAN_ID';             
                              V_TAB_PK_COL_VAL:=P_PLAN_ID;    
                            --Kapil added below conditions for Med Watch functionality
                            -- Start, Date: 22-Apr-2016
                            ELSIF V_MAPPED_TABLE = 'EV_CONCOM_SUPP' THEN
                              V_TAB_PK_COL_NAME:='EV_CONCOM_ROW_ID';             
                              V_TAB_PK_COL_VAL:=P_EV_CONCOM_ROW_ID;    
                            ELSIF V_MAPPED_TABLE = 'EV_MW_TEST_SUPP' THEN
                              V_TAB_PK_COL_NAME:='EV_MW_TEST_ROW_ID';             
                              V_TAB_PK_COL_VAL:=P_EV_MW_TEST_ROW_ID;                                       
                            -- End, Date: 22-Apr-2016  
                            END IF;
                            
                              V_SQL_RM_SUPP := 'SELECT '||V_TAB_PK_COL_NAME||' FROM '||V_DB_NAME||V_MAPPED_TABLE||' WHERE '||V_TAB_PK_COL_NAME ||'= :1';
                                         
                                 BEGIN
                                      EXECUTE IMMEDIATE V_SQL_RM_SUPP INTO V_TAB_PK_ID USING V_TAB_PK_COL_VAL;
                                      IF V_TAB_PK_ID <> 0 THEN -- KAPIL --22-FEB-2016
                                        V_INS_UPD_FLAG := 'U';
                                      END IF;  
                                   EXCEPTION
                                      WHEN NO_DATA_FOUND THEN
                                        V_INS_UPD_FLAG := 'I';
                                      WHEN TOO_MANY_ROWS THEN
                                          NULL;
                                      WHEN OTHERS THEN
                                          V_ERROR_MSG:=SQLERRM;
                                           V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                                           DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                               P_DA_ROW_ID, 
                                               p_MODULE_NAME,
                                               V_ERROR_LOCATION, 
                                               V_ERROR_LOCATION,
                                               'DDS_SUPPLEMENT',
                                               V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                               V_USER_FIELD_NAME, 
                                               'DDS_'||P_MODULE_NAME,
                                               P_KEYCOLUMN,
                                               P_KEYVALUE,
                                               0);
                                           -- NEED ERROR MESSAGE
                                   END;      
                            
                            
                            --MAKING DYNAMIC QUERY FOR REST OF THE TABLES AND CHECKING RECORD EXISTS IN IT OR NOT -- END  
                        END IF; -- CLAIMANT SUPP END HERE
              
                        -- insert or update into rm db tables                    
                         --IF V_TAB_PK_ID>0 THEN -- IF PK VALUE OF A TABLE IS HAVING ANY VALUE -- eg CLAIMANT ROW ID -- START
                         
                             V_SQL_RM_SUPP:='SELECT '|| V_USER_FIELD_NAME||' FROM DDS_SUPPLEMENTAL_RUNTIME_DATA WHERE JOBID=:1 AND DA_ROW_ID=:2 AND MODULE_NAME=:3';
                              
                              OPEN l_CURSOR_RM_DB_I_U FOR  V_SQL_RM_SUPP USING P_JOBID, P_DA_ROW_ID,P_MODULE_NAME;
                                     LOOP 
                                         FETCH l_CURSOR_RM_DB_I_U
                                          INTO V_USER_FIELD_NAME_VALUE;
                                         EXIT WHEN l_CURSOR_RM_DB_I_U%NOTFOUND; 
                                           
                                           IF V_MULTI_VAL = 0 THEN -- IF COLUMN FIELD IS NOT MULTI VALUE TYPE THEN WE NEED TO INSERT/ UPDATE DIRECTLY INTO RM DB
                                              IF V_TAB_PK_COL_VAL > 0 THEN -- KAPIL -- 24-FEB-2016
                                                IF V_INS_UPD_FLAG = 'I' THEN
                                                -- KAPIL START HERE -- 25-FEB-2016
                                                   IF V_MAPPED_TABLE = 'CLAIMANT_SUPP' THEN -- CLAIMANT SUPP START HERE
                                                      V_SQL_ENTITY:='INSERT INTO '||V_DB_NAME||V_MAPPED_TABLE||'('||V_TAB_PK_COL_NAME||','||V_MAPPED_FIELD||',CLAIM_ID, CLAIMANT_EID) VALUES (:1,:2,:3,:4)';
                                                      EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL, V_USER_FIELD_NAME_VALUE, P_CLAIM_ID, P_CLAIMANT_EID;
                                                   ELSE
                                                  -- KAPIL END HERE -- 25-FEB-2016 
                                                      V_SQL_ENTITY:='INSERT INTO '||V_DB_NAME||V_MAPPED_TABLE||'('||V_TAB_PK_COL_NAME||','||V_MAPPED_FIELD||') VALUES (:1,:2)';
                                                      EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL, V_USER_FIELD_NAME_VALUE; 
                                                   END IF;-- KAPIL -- 25-FEB-2016 
                                                  COMMIT;
                                                ELSIF V_INS_UPD_FLAG = 'U' THEN
                                                   V_SQL_ENTITY:='UPDATE '||V_DB_NAME||V_MAPPED_TABLE||' SET '||V_MAPPED_FIELD||'= :1 WHERE '||V_TAB_PK_COL_NAME||'=:2';
                                                   EXECUTE IMMEDIATE V_SQL_ENTITY USING V_USER_FIELD_NAME_VALUE, V_TAB_PK_COL_VAL; 
                                                   COMMIT;
                                                END IF;
                                              END IF;   -- KAPIL -- 24-FEB-2016
                                           -- NOT MULTI VALUE CODE END HERE     
                                          ELSIF V_MULTI_VAL = 1 THEN -- IF COLUMN FIELD IS MULTI VALUE TYPE THEN WE INSERT/ UPDATE INTO RM DB VIA FOR LOOP ON THAT COLUMN -- START HERE
                                              
                                                    V_SQL_TXT_CODE :=' select regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) AS CV from dual
                                                    connect by regexp_substr('||''''||V_USER_FIELD_NAME_VALUE||''''||','||''''||'[^|]+'||''''||', 1, level) is not null ';
                                                     OPEN l_CURSOR_TXT_CODE FOR V_SQL_TXT_CODE;
                                                          LOOP
                                                            FETCH l_CURSOR_TXT_CODE INTO V_SQL_TXT_CODE_VAL ;
                                                             EXIT WHEN l_CURSOR_TXT_CODE%NOTFOUND;  
                                                                 
                                                                 IF V_SQL_TXT_CODE_VAL IS NULL THEN
                                                                    V_SQL_TXT_CODE_VAL:=NVL(V_SQL_TXT_CODE_VAL,0);
                                                                 END IF;
                                                                 
                                                                 IF V_FIELD_TYPE_NAME = 'TXTCODE_FIELD' THEN -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- START HERE
                                                                       SELECT INSTR(V_SQL_TXT_CODE_VAL,'-') INTO V_CHK_TXT_CODE from DUAL; 
                                                 
                                                                              IF V_CHK_TXT_CODE > 0 THEN -- CHECKING IF STRING IS HAVING - IN ITS VALUE... IN WHICH FIRST STRING IS CODE AND REST IS DESCRIPTION
                                                                                 SELECT trim(substr(V_SQL_TXT_CODE_VAL,1, instr(V_SQL_TXT_CODE_VAL,'-')-1)) 
                                                                                   INTO V_TXT_CODE
                                                                                 FROM DUAL; -- FETCHING CODE VALUE FROM THE STRING
                                                                                 
                                                                                 SELECT trim(substr(V_SQL_TXT_CODE_VAL,instr(V_SQL_TXT_CODE_VAL,'-')+1)) 
                                                                                    INTO V_TXT_DESC
                                                                                 FROM DUAL; -- FETCHING DESCRIPTION VALUE FROM THE STRING
                                                                               
                                                                               ELSE -- IF WE HAVE NOT FOUND - THEN SETTING THE VALUE AS IS
                                                                                 V_TXT_CODE := V_SQL_TXT_CODE_VAL;
                                                                                 V_TXT_DESC := NULL;
                                                                              END IF;
                                                                              
                                                                  END IF;  -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- END HERE
                                                                 
                                                                 V_SQL_STATES:='SELECT COUNT(FIELD_ID) FROM '||V_DB_NAME||'SUPP_MULTI_VALUE WHERE RECORD_ID = :1 AND FIELD_ID=:2 AND CODE_ID= :3';
                                                                 
                                                                 IF V_FIELD_TYPE_NAME <> 'TXTCODE_FIELD' THEN -- NEED TO EXECUTE ONLY FOR MULTI TEXT FIELD -- START HERE
                                                                    EXECUTE IMMEDIATE V_SQL_STATES INTO V_SQL_STATES_VAL USING V_TAB_PK_COL_VAL,V_FIELD_ID_C,V_SQL_TXT_CODE_VAL;
                                                                 ELSIF V_FIELD_TYPE_NAME = 'TXTCODE_FIELD' THEN
                                                                    EXECUTE IMMEDIATE V_SQL_STATES INTO V_SQL_STATES_VAL USING V_TAB_PK_COL_VAL,V_FIELD_ID_C,V_TXT_CODE;
                                                                 END IF;
                                                                 
                                                                 IF V_SQL_STATES_VAL>0 THEN
                                                                        V_INS_UPD_SUPP_FLAG := 'U'; -- Otherwise primary constraint error will come up
                                                                        --NULL;
                                                                        -- NO WORK IS WRITTEN FOR IT IN VB CODE
                                                                 ELSIF V_SQL_STATES_VAL = 0 THEN
                                                                         V_INS_UPD_SUPP_FLAG := 'I';
                                                                 END IF;
                                                                 
                                                                 IF V_INS_UPD_SUPP_FLAG = 'I' THEN
                                                                  IF V_TAB_PK_COL_VAL > 0 THEN -- KAPIL -- 24-FEB-2016
                                                                     V_SQL_ENTITY:='INSERT INTO '||V_DB_NAME||'SUPP_MULTI_VALUE (RECORD_ID,FIELD_ID,CODE_ID) VALUES (:1,:2,:3)';
                                                                       IF V_FIELD_TYPE_NAME <> 'TXTCODE_FIELD' THEN
                                                                           EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL,V_FIELD_ID_C,V_SQL_TXT_CODE_VAL;
                                                                       ELSE
                                                                           EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL,V_FIELD_ID_C,V_TXT_CODE;
                                                                       END IF;
                                                                   END IF; --  KAPIL -- 24-FEB-2016      
                                                                 ELSIF  V_INS_UPD_SUPP_FLAG = 'U' THEN
                                                                         NULL;                                                            
                                                                 END IF;
                                                                 
                                                                 IF V_FIELD_TYPE_NAME = 'TXTCODE_FIELD' THEN -- INSERT DATA INTO RM DB TABLE IN CASE OF TEXT FIELD TYPE
                                                                 --Kapil start -- 16-feb-2016
                                                                     V_SQL_ENTITY:='SELECT '|| V_USER_FIELD_NAME ||' FROM DDS_'||P_MODULE_NAME||' WHERE DA_ROW_ID=:1 AND JOBID=:2';                                  
                                                                       V_ERROR_LOCATION:=71;
                                                                         EXECUTE IMMEDIATE V_SQL_ENTITY INTO V_USER_FIELD_NAME_VALUE USING P_DA_ROW_ID,P_JOBID ;
                                                                         V_ERROR_LOCATION:=81;                                                                                                                                     
                --Kapil end -- 16-feb-2016
                 --KAPIL CHANGES START AT 19-FEB-2016
                   V_SQL_RM_SUPP := 'SELECT '||V_TAB_PK_COL_NAME||' FROM '||V_DB_NAME||V_MAPPED_TABLE||' WHERE '||V_TAB_PK_COL_NAME ||'= :1';
         
                     BEGIN
                    EXECUTE IMMEDIATE V_SQL_RM_SUPP INTO V_TAB_PK_ID USING V_TAB_PK_COL_VAL;
                    V_INS_UPD_FLAG := 'U';
                       EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      V_INS_UPD_FLAG := 'I';
                    WHEN TOO_MANY_ROWS THEN
                        NULL;
                    WHEN OTHERS THEN
                        V_ERROR_MSG:=SQLERRM;
                         V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                         DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                       P_DA_ROW_ID, 
                       p_MODULE_NAME,
                       V_ERROR_LOCATION, 
                       V_ERROR_LOCATION,
                       'DDS_SUPPLEMENT',
                       V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                       V_USER_FIELD_NAME, 
                       'DDS_'||P_MODULE_NAME,
                       P_KEYCOLUMN,
                       P_KEYVALUE,
                       0);                                                                                     
                       END;      
                       --KAPIL CHANGES END AT 19-FEB-2016  
                                                                  IF V_TAB_PK_COL_VAL > 0 THEN -- KAPIL -- 24-FEB-2016
                                                                    IF V_INS_UPD_FLAG = 'I' THEN
                                                                         -- KAPIL START HERE -- 25-FEB-2016
                                                                       IF V_MAPPED_TABLE = 'CLAIMANT_SUPP' THEN -- CLAIMANT SUPP START HERE
                                                                          V_SQL_ENTITY:='INSERT INTO '||V_DB_NAME||V_MAPPED_TABLE||'('||V_TAB_PK_COL_NAME||','||V_MAPPED_FIELD||',CLAIM_ID, CLAIMANT_EID) VALUES (:1,:2,:3,:4)';
                                                                          EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL, V_USER_FIELD_NAME_VALUE, P_CLAIM_ID, P_CLAIMANT_EID;
                                                                       ELSE
                                                                      -- KAPIL END HERE -- 25-FEB-2016 
                                                                           V_SQL_ENTITY:='INSERT INTO '||V_DB_NAME||V_MAPPED_TABLE||'('||V_TAB_PK_COL_NAME||','||V_MAPPED_FIELD||') VALUES (:1,:2)';
                                                                           EXECUTE IMMEDIATE V_SQL_ENTITY USING V_TAB_PK_COL_VAL, V_USER_FIELD_NAME_VALUE;
                                                                       END IF; -- 25-FEB-2016     
                                                                       COMMIT;
                                                                    ELSIF V_INS_UPD_FLAG = 'U' THEN
                                                                       V_SQL_ENTITY:='UPDATE '||V_DB_NAME||V_MAPPED_TABLE||' SET '||V_MAPPED_FIELD||'= :1 WHERE '||V_TAB_PK_COL_NAME||'=:2';
                                                                       EXECUTE IMMEDIATE V_SQL_ENTITY USING V_USER_FIELD_NAME_VALUE, V_TAB_PK_COL_VAL; 
                                                                       COMMIT;
                                                                    END IF;
                                                                  END IF;  -- KAPIL -- 24-FEB-2016
                                                                END IF;
                                                                COMMIT; 
                                                          END LOOP;
                                                     CLOSE  l_CURSOR_TXT_CODE;
                                                                                                
                                          END IF;  -- IF COLUMN FIELD IS MULTI VALUE TYPE THEN WE INSERT/ UPDATE INTO RM DB VIA FOR LOOP ON THAT COLUMN
                                
                             END LOOP; 
                             CLOSE l_CURSOR_RM_DB_I_U;  
                             
                             V_TAB_PK_COL_VAL:=NULL;  -- RESETTING THE VALUE
                             V_INS_UPD_FLAG:= NULL;  -- RESETTING THE FLAG
                             V_INS_UPD_SUPP_FLAG:=NULL; -- RESETTING THE FLAG
                             V_TAB_PK_ID := NULL; -- KAPIL 22-FEB-2016     
                        -- END IF;-- IF PK VALUE OF A TABLE IS HAVING ANY VALUE -- eg CLAIMANT ROW ID -- END
                      END IF;    -- MAIN IF FOR RM DB WORK END HERE
                    
                   END IF;-- INSERTION FLAG / STAGE WORK COMPLETED / END HERE    
      -- RM TABLE CHECK PROCESSING END
         
              EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                             V_ERROR_MSG:='No data found in RM DB supplemental.';
                             --V_ERROR_MSG:=SQLERRM;
                             DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                 P_DA_ROW_ID, 
                                 p_MODULE_NAME,
                                 V_ERROR_LOCATION, 
                                 V_ERROR_LOCATION,
                                 'DDS_SUPPLEMENT',
                                 V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                 P_KEYCOLUMN, 
                                 'DDS_'||P_MODULE_NAME,
                                 P_KEYCOLUMN,
                                 P_KEYVALUE,
                                 1);
                           --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
                        WHEN TOO_MANY_ROWS THEN
                            NULL;
                        WHEN OTHERS THEN
                              V_ERROR_MSG:=SQLERRM;
                               V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
                               DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                   P_DA_ROW_ID, 
                                   p_MODULE_NAME,
                                   V_ERROR_LOCATION, 
                                   V_ERROR_LOCATION,
                                   'DDS_SUPPLEMENT',
                                   V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
                                   V_USER_FIELD_NAME, 
                                   'DDS_'||P_MODULE_NAME,
                                   P_KEYCOLUMN,
                                   P_KEYVALUE,
                                   0);
                            --NULL;
                             -- NEED ERROR MESSAGE
               END;             
               
           --END LOOP;

       END LOOP;
       CLOSE l_cursor;


 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NULL;
         --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
     WHEN TOO_MANY_ROWS THEN
          NULL;
     WHEN OTHERS THEN
          V_ERROR_MSG:=SQLERRM;
           V_ERROR_COUNT:= V_ERROR_COUNT + 1 ;
           DDS_ERROR_LOG_CAPTURE(P_JOBID, 
               P_DA_ROW_ID, 
               p_MODULE_NAME,
               V_ERROR_LOCATION, 
               V_ERROR_LOCATION,
               'DDS_SUPPLEMENT',
               V_ERROR_MSG, -- It is used to fetch error msg and append into the error msg and update it again
               V_USER_FIELD_NAME, 
               'DDS_'||P_MODULE_NAME,
               P_KEYCOLUMN,
               P_KEYVALUE,
               0);
           -- NEED ERROR MESSAGE
          --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);

END DDS_SUPPLEMENT;