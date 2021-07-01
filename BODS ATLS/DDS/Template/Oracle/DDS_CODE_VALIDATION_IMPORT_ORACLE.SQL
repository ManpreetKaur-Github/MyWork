CREATE OR REPLACE PROCEDURE DDS_CODE_VALIDATION_IMPORT(P_JOBID NUMBER,
P_SHORT_CODE VARCHAR2, -- Short Code
P_SYS_TABLE_NAME Varchar2, -- SYstem Table Name to Check
P_CODE_CREATION_FLAG NUMBER, -- It is used to check allow creation of code flag is set by user or not
--P_CODE_CREATION NUMBER, -- It is used to check are we able to create code for that system table name or not
P_DB_NAME VARCHAR2, -- It is used to fetch error msg and append into the error msg and update it again
--P_STAGE VARCHAR2, -- Stage VALIDATION OR IMPORT
P_LOB VARCHAR2, -- LOB GC, WC ( It Will be numeric)
p_DA_ROW_ID NUMBER, -- Used for ERROR_LOG_CAPTURE Procedure
p_MODULE_NAME Varchar2, -- Used for ERROR_LOG_CAPTURE Procedure
p_ERROR_LOCATION Varchar2, -- Used for ERROR_LOG_CAPTURE Procedure
p_ERROR_PROC_NAME varchar2, -- Used for ERROR_LOG_CAPTURE Procedure
p_ERROR_KEY_COLUMN VARCHAR2, -- -- Main Column like Claim Number/ event number to capture error log properly -- K
p_ERROR_COLUMN VARCHAR2,  -- Used for ERROR_LOG_CAPTURE Procedure -- K
P_ERROR_TABLE_TO_CHECK VARCHAR2,-- Used for ERROR_LOG_CAPTURE Procedure 
P_ERROR_COLUMN_KEY_VALUE VARCHAR2, -- Main Column Value i.e. value of claim number and event number -- K
P_CODE_ID_R OUT NUMBER
)
AUTHID CURRENT_USER 
AS
/*Declaration Part*/
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQL VARCHAR2(32000);
V_SQL_U VARCHAR2(2000);
V_SQL_CODES VARCHAR2(4000);
V_SQL_CODES_TEXT VARCHAR2(4000);
V_CODEID NUMBER;
V_TABLEID NUMBER;
V_NEXT_UNIQUE_ID NUMBER;
V_LOCATION NUMBER;
v_NON_VALUE NUMBER :=0;
V_DELETED_FLAG NUMBER;
V_ERROR_MESSAGE VARCHAR2(2000);
V_iUseLobFlag NUMBER;

V_iReqRelTblFlag NUMBER;  
v_iReqIndTblFlag  NUMBER;  
v_iGlossaryTypeCode  NUMBER;  
v_P_CODE_CREATION  NUMBER;
V_LOB VARCHAR2(255):= P_LOB ; 
V_DB_NAME VARCHAR2(255); --RMA 25298
v_iRetVal NUMBER(10, 0) := 0;  ---RMA 25298
v_fVersionNum NUMBER(10,1);  ---RMA 25298

BEGIN
--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_CODE_VALIDATION_IMPORT PROCEDURE STARTS ************************************************************************
--*************************************************************************************************************************************************************                                                                             ****
-- It fetches the table_id from glossary corresponding to the system_table_name of a particular code column.
-- Corresponding to the table_id fetched from glossary table , Code_id is fetched from codes table for that particular short_code and table_id.
-- It also created the codes for few code columns , Only if allow Creation of Check box is checked and It satisfies few conditions.
-- It also created the codes for few code columns , and code decription for the new created code is added in the codes text table.
-- In the absence of few conditions a self described Error is logged of Why the Short code has not been created for a particular Ciode column Even when
-- the allow Creation of Checkbox was checked.

--*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_CODE_VALIDATION_IMPORT PROCEDURE ENDS ************************************************************************
--*************************************************************************************************************************************************************                                                                             ****


-- Note: As per discussion happened with Team. Currently, Parent Code work is not done in it. As it is required 
-- for funds module only and will be handled in it accordingly...

 --RMA-25298 JIRA starts--
                                              
   V_DB_NAME:= SUBSTR( P_DB_NAME, 1 ,(LENGTH(P_DB_NAME)-1));
   DDS_spCheckVersion(v_vTableName=>'CODES_TEXT',
                      v_vFieldName  => 'DTTM_RCD_ADDED',   
                      vDbName =>V_DB_NAME,
                      v_iRetVal=> v_iRetVal);                    
   IF v_iRetVal = 1 THEN                                      
       V_fVersionNum := 16.2;
   END IF;
                          
 --RMA-25298 JIRA ends--  
 
 IF P_SHORT_CODE IS NOT NULL THEN -- IF SHORT CODE IS NOT NULL THEN ONLY START CODE EXISTENCE
 

 V_LOCATION:=0;
         V_SQL := 'SELECT LINE_OF_BUS_FLAG,REQD_REL_TABL_FLAG, REQD_IND_TABL_FLAG, GLOSSARY_TYPE_CODE FROM ' || P_DB_NAME || 'GLOSSARY WHERE SYSTEM_TABLE_NAME = :1';
        BEGIN
                EXECUTE IMMEDIATE V_SQL INTO V_iUseLobFlag,V_iReqRelTblFlag,v_iReqIndTblFlag,v_iGlossaryTypeCode USING P_SYS_TABLE_NAME;
        EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    NULL;
               WHEN OTHERS THEN
                    NULL;     
        END;
 
        IF V_iReqRelTblFlag IS NULL THEN
           V_iReqRelTblFlag := 0;
        END IF;   
        IF V_iReqIndTblFlag IS NULL THEN
          V_iReqIndTblFlag := 0;
        END IF;  
        IF V_iGlossaryTypeCode = 3 THEN
          V_P_CODE_CREATION := 1;
          ELSE
          V_P_CODE_CREATION := 0;
        END IF; 
        -- It fetches the table_id from glossary corresponding to the system_table_name of a particular code column.
-- Corresponding to the table_id fetched from glossary table , Code_id is fetched from codes table for that particular short_code and table_id.
       	   
	   V_SQL := 'SELECT c.CODE_ID, c.TABLE_ID,  c.DELETED_FLAG FROM '||P_DB_NAME||'CODES C, '||P_DB_NAME||'GLOSSARY G WHERE c.TABLE_ID = G.TABLE_ID ';
       V_SQL := V_SQL || ' AND UPPER(c.SHORT_CODE) = :1 AND G.system_TABLE_NAME=:2';
       ---akumar523 added V_LOB RMA 62380
       IF V_iUseLobFlag <> 0 AND V_LOB <> 0   THEN
          V_SQL := V_SQL || ' AND C.LINE_OF_BUS_CODE = '|| NVL(V_LOB,0) ;
       END IF;
          
           BEGIN
                 EXECUTE IMMEDIATE V_SQL into V_CODEID,V_TABLEID,V_DELETED_FLAG using UPPER(P_SHORT_CODE), P_SYS_TABLE_NAME;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                -- IF CODE ID NOT EXISTS IN RM DB AND ALLOW CREATION FLAGS ARE SET THEN ONLY CREATE A NEW CODE
                    IF P_CODE_CREATION_FLAG = 1 AND V_P_CODE_CREATION = 1 AND  V_iReqIndTblFlag = 0 AND V_iReqRelTblFlag = 0 THEN  
          
                        V_SQL := 'SELECT G.TABLE_ID FROM '||P_DB_NAME||'GLOSSARY G WHERE ';
                        V_SQL := V_SQL || ' G.system_TABLE_NAME=:1';
                        
                        EXECUTE IMMEDIATE V_SQL into V_TABLEID using P_SYS_TABLE_NAME;
                        
                        V_SQL := 'SELECT MAX(G.CODE_ID) FROM '||P_DB_NAME||'CODES G '; -- ADDED AS IN RM DB WE ARE POPULATING MAX CODE ID'S
                        
                        EXECUTE IMMEDIATE V_SQL into V_NEXT_UNIQUE_ID;
                             
                         V_NEXT_UNIQUE_ID := NVL(V_NEXT_UNIQUE_ID,0) + 1;
                         V_CODEID := V_NEXT_UNIQUE_ID;
                      
                         IF V_iUseLobFlag =0  THEN 
                           V_LOB := '0';
                         END IF;
                          -- It also created the codes for few code columns , Only if allow Creation of Check box is checked and It satisfies few conditions.
                         V_SQL_CODES:= 'INSERT INTO '||P_DB_NAME||'CODES(CODE_ID,SHORT_CODE,TABLE_ID,RELATED_CODE_ID,LINE_OF_BUS_CODE,DELETED_FLAG,IND_STANDARD_CODE, DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER) VALUES (';
                         V_SQL_CODES := V_SQL_CODES ||':1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11)';
                         
                         BEGIN                                  
                              EXECUTE IMMEDIATE V_SQL_CODES USING V_NEXT_UNIQUE_ID,P_SHORT_CODE,V_TABLEID,v_NON_VALUE,V_LOB,v_NON_VALUE,v_NON_VALUE,TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),'DADDS','DADDS' ;
                              V_LOCATION:=1;
                              COMMIT;
                         EXCEPTION
                            WHEN OTHERS THEN
                                 -- IF CODE ID NOT EXISTS IN RM DB AND WHILE INSERTING THE DATA AND ERROR OCCURRED THEN INSERTING IN ERROR_LOG
                                   V_ERROR_MESSAGE:=SQLERRM || '. For ' || P_ERROR_COLUMN ||':'||P_SHORT_CODE;
                                   
                                    DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           p_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           p_ERROR_LOCATION, 
                                           V_LOCATION,
                                           p_ERROR_PROC_NAME,
                                           V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                           p_ERROR_COLUMN, 
                                           P_ERROR_TABLE_TO_CHECK,
                                           p_ERROR_KEY_COLUMN,
                                           P_ERROR_COLUMN_KEY_VALUE,
                                           0);
                               END;
                               
                               -- Kapil Start -- 7 Oct 2016
                               V_SQL_CODES:= 'Update '||P_DB_NAME||'GLOSSARY Set Next_unique_id=';
                               V_SQL_CODES := V_SQL_CODES ||':1 where system_table_name=:4';

                              BEGIN                                  
                                    EXECUTE IMMEDIATE V_SQL_CODES USING V_NEXT_UNIQUE_ID + 1,'CODES';
                                    V_LOCATION:=4;
                                    COMMIT;
                               EXCEPTION
                                  WHEN OTHERS THEN
                                       -- IF CODE ID NOT EXISTS IN RM DB AND WHILE INSERTING THE DATA AND ERROR OCCURRED THEN INSERTING IN ERROR_LOG
                                         V_ERROR_MESSAGE:=SQLERRM || '. For ' || P_ERROR_COLUMN ||':'||P_SHORT_CODE;
                                         
                                          DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                                 p_DA_ROW_ID, 
                                                 p_MODULE_NAME,
                                                 p_ERROR_LOCATION, 
                                                 V_LOCATION,
                                                 p_ERROR_PROC_NAME,
                                                 V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                                 p_ERROR_COLUMN, 
                                                 P_ERROR_TABLE_TO_CHECK,
                                                 p_ERROR_KEY_COLUMN,
                                                 P_ERROR_COLUMN_KEY_VALUE,
                                                 0);
                                     END;

                               -- Kapil End -- 7 Oct 2016
                     
                     BEGIN-- It also created the codes for few code columns , and code decription for the new created code is added in the codes text table.
                    -- added date and user fields in table codes_text in 16.2 version
                     V_SQL_CODES_TEXT:= 'INSERT INTO '||P_DB_NAME||'CODES_TEXT(CODE_ID,SHORT_CODE,CODE_DESC,LANGUAGE_CODE';
                     IF v_fVersionNum >=16.2 THEN 
                        V_SQL_CODES_TEXT:= V_SQL_CODES_TEXT ||',DTTM_RCD_ADDED,DTTM_RCD_LAST_UPD,ADDED_BY_USER,UPDATED_BY_USER';--RMA-25298
                     END IF;  
                     
                     V_SQL_CODES_TEXT:= V_SQL_CODES_TEXT || ') VALUES (';
                     V_SQL_CODES_TEXT:= V_SQL_CODES_TEXT || ':1,:2,:3,:4';
                     
                     IF v_fVersionNum >= 16.2 THEN   --RMA-25298 
                        V_SQL_CODES_TEXT:= V_SQL_CODES_TEXT || ',:5, :6,:7,:8)';
                        
                        EXECUTE IMMEDIATE V_SQL_CODES_TEXT USING V_NEXT_UNIQUE_ID,P_SHORT_CODE,P_SHORT_CODE,1033,
                        TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS'),'DADDS','DADDS';
                       
                     ELSE 
                       V_SQL_CODES_TEXT:= V_SQL_CODES_TEXT || ')';
                       EXECUTE IMMEDIATE V_SQL_CODES_TEXT USING V_NEXT_UNIQUE_ID,P_SHORT_CODE,P_SHORT_CODE,1033 ;
                     END IF;
                     
                     commit;                    
                     V_LOCATION:=2;
                      EXCEPTION
                            WHEN OTHERS THEN
                              V_ERROR_MESSAGE:=SQLERRM || '. For ' || P_ERROR_COLUMN ||':'||P_SHORT_CODE;
                              DDS_ERROR_LOG_CAPTURE(P_JOBID,                                            
                                           p_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           p_ERROR_LOCATION, 
                                           V_LOCATION,
                                           p_ERROR_PROC_NAME,
                                           V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                           p_ERROR_COLUMN, 
                                           P_ERROR_TABLE_TO_CHECK,
                                           p_ERROR_KEY_COLUMN,
                                           P_ERROR_COLUMN_KEY_VALUE,
                                           0);
                                
                              END;
                      
                     -- DBMS_OUTPUT.PUT_LINE ('V_SQL1-->'||V_SQL);
                     ELSE      -- WHEN NO FLAG IS SET TO CREATE A NEW CODES THEN ERROR WILL BE LOGGED
                         V_CODEID:= 0; -- When no data has been found in codes table and creation flags are not set   
                         IF V_iReqIndTblFlag <> 0 OR V_iReqRelTblFlag <> 0 THEN --MKAUR24 04/26/2016 RMA-23448
                            V_ERROR_MESSAGE := 'The Code ''' ||P_SHORT_CODE|| ''' is not found in codes table of RMDB for ' || p_ERROR_COLUMN || ' and it needs to be created from rmA-UI as it requires either Related Code Id or Industry Standard Code';            
                          ELSE            
                              V_ERROR_MESSAGE := 'The Code ''' ||P_SHORT_CODE|| ''' is not found in codes table of RM DB for '||p_ERROR_COLUMN||', either it is not user defined code or Allow Creation of New Codes is not selected';
                          END IF;    
                         DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                           p_DA_ROW_ID, 
                                           p_MODULE_NAME,
                                           p_ERROR_LOCATION, 
                                           V_LOCATION,
                                           p_ERROR_PROC_NAME,
                                           V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                           p_ERROR_COLUMN, 
                                           P_ERROR_TABLE_TO_CHECK,
                                           p_ERROR_KEY_COLUMN,
                                           P_ERROR_COLUMN_KEY_VALUE,
                                           1);
                     END IF;
                WHEN TOO_MANY_ROWS THEN
                  NULL;
                WHEN OTHERS THEN
                 V_ERROR_MESSAGE:=SQLERRM || ' For: ' || p_ERROR_KEY_COLUMN ||':'||P_ERROR_COLUMN_KEY_VALUE;
                          DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                 p_DA_ROW_ID, 
                                 p_MODULE_NAME,
                                 p_ERROR_LOCATION,
                                 V_LOCATION, 
                                 p_ERROR_PROC_NAME,
                                 V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                 p_ERROR_COLUMN, 
                                 P_ERROR_TABLE_TO_CHECK,
                                 p_ERROR_KEY_COLUMN,
                                 P_ERROR_COLUMN_KEY_VALUE,
                                 0);
                END;  
      
      IF V_DELETED_FLAG <> 0 AND P_CODE_CREATION_FLAG = 1 AND V_P_CODE_CREATION = 1 THEN
      -- THIS WILL EXECUTE ONLY WHEN SUPPOSE DELETED FLAG IS SET TO -1 INSTEAD OF 0 AND OTHER CREATION FLAGS ARE ALSO SET THEN 
      -- IT WILL WORK
       IF V_iUseLobFlag =0  THEN 
                V_LOB := '0';
       END IF;
       V_SQL_U := 'UPDATE '||P_DB_NAME||'CODES SET DELETED_FLAG = 0, DTTM_RCD_LAST_UPD = SYSDATE WHERE LINE_OF_BUS_CODE =:1';
       V_SQL_U := V_SQL_U || ' AND UPPER(SHORT_CODE) = :2  AND TABLE_ID =(SELECT TABLE_ID FROM '||P_DB_NAME||'GLOSSARY WHERE system_TABLE_NAME=:3)';
       EXECUTE IMMEDIATE V_SQL_U using V_LOB, UPPER(P_SHORT_CODE), P_SYS_TABLE_NAME;
       COMMIT;
       
       ELSIF V_DELETED_FLAG <> 0 AND P_CODE_CREATION_FLAG = 1 AND V_P_CODE_CREATION <>  1 THEN
       V_LOCATION:=3;
       -- In the absence of few conditions a self described Error is logged of Why the Short code has not been created for a particular Code column Even when
-- the allow Creation of Checkbox was checked.
       V_ERROR_MESSAGE := 'The Code ''' ||P_SHORT_CODE|| ''' is found in codes table of RM DB but its deleted flag is -1 for '||p_ERROR_COLUMN;
        DDS_ERROR_LOG_CAPTURE(P_JOBID, 
                                 p_DA_ROW_ID, 
                                 p_MODULE_NAME,
                                 p_ERROR_LOCATION,
                                 V_LOCATION, 
                                 p_ERROR_PROC_NAME,
                                 V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
                                 p_ERROR_COLUMN, 
                                 P_ERROR_TABLE_TO_CHECK,
                                 p_ERROR_KEY_COLUMN,
                                 P_ERROR_COLUMN_KEY_VALUE,
                                 1);
      END IF;

      END IF; -- IF SHORT CODE IS NOT NULL
 
P_CODE_ID_R := V_CODEID;
 
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NULL;        --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
     WHEN TOO_MANY_ROWS THEN
          NULL;
     WHEN OTHERS THEN
     v_location:=10;
     V_ERROR_MESSAGE:=SQLERRM || ' For: ' || p_ERROR_KEY_COLUMN ||':'||P_ERROR_COLUMN_KEY_VALUE;
         DDS_ERROR_LOG_CAPTURE(P_JOBID, 
           p_DA_ROW_ID, 
           p_MODULE_NAME,
           p_ERROR_LOCATION, 
           V_LOCATION,
           p_ERROR_PROC_NAME,
           V_ERROR_MESSAGE, -- It is used to fetch error msg and append into the error msg and update it again
           p_ERROR_COLUMN, 
           P_ERROR_TABLE_TO_CHECK,
           p_ERROR_KEY_COLUMN,
           P_ERROR_COLUMN_KEY_VALUE,
           0);
           ROLLBACK;
          --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);

END DDS_CODE_VALIDATION_IMPORT;
