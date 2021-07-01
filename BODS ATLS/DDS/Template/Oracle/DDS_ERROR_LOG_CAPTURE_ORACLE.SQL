CREATE OR REPLACE PROCEDURE DDS_ERROR_LOG_CAPTURE(
p_JOBID NUMBER, 
p_DA_ROW_ID NUMBER, 
p_MODULE_NAME Varchar2,
p_CALLING_ERROR_LOCATION Varchar2, 
p_CURRENT_ERROR_LOCATION Varchar2,
p_ERROR_PROC_NAME varchar2,
p_ERROR_MSG  VARCHAR2, -- It is used to fetch error msg and append into the error msg and update it again
p_ERROR_COLUMNS VARCHAR2, -- Columns in which error is coming
p_ERROR_TABLE_TO_CHECK VARCHAR2,
p_ERROR_KEY_COLUMN VARCHAR2, -- Main Column like Claim Number/ event number
P_ERROR_COLUMN_KEY_VALUE VARCHAR2, -- Main Column Value i.e. value of claim number and event number
P_IS_VALIDATION NUMBER -- IT IS USED TO CHECK either error is system error or data related error.Data related error is having value 1 and system related error is having value 0
)
AUTHID CURRENT_USER 
AS
/*Declaration Part*/
PRAGMA AUTONOMOUS_TRANSACTION;
v_SQL VARCHAR2(32000);
v_ERR_LOG_ROW_ID DDS_ERROR_LOG.ERR_LOG_ROW_ID%type; 
/*v_DA_ROW_ID DDS_ERROR_LOG.DA_ROW_ID%type; 
v_MODULE_NAME DDS_ERROR_LOG.MODULE_NAME%type; 
v_CALLING_ERROR_LOCATION DDS_ERROR_LOG.CALLING_ERROR_LOCATION%type; 
v_CURRENT_ERROR_LOCATION DDS_ERROR_LOG.CURRENT_ERROR_LOCATION%type; 
v_ERROR_PROC_NAME DDS_ERROR_LOG.ERROR_PROC_NAME%type; 
v_ERROR_COLUMN DDS_ERROR_LOG.ERROR_COLUMNS%type; 
v_ERROR_TABLE_TO_CHECK DDS_ERROR_LOG.ERROR_TABLE_TO_CHECK%type; 

v_ERROR_DESC DDS_ERROR_LOG.ERROR_DESC%type; */
--V_ERROR_MSG DDS_ERR_MESSAGES.ERR_MESSAGE%type; 
v_commit_flag NUMBER;
--v_status varchar2(1):='Y'; -- It is used for error status message table .. Error Message must be Y

BEGIN
  --*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_ERROR_LOG_CAPTURE PROCEDURE STARTS ************************************************************************
--************************************************************************************************************************************************************* ****
-- If any Error is encountered from the calling proc , an insert into the error_log table is made.
-- If more than one error is encountered corresponding to the same record, An update into DDS_ERROR_LOG is made coressponing to the same JOBID , DA_ROW_ID,ERROR_TABLE_TO_CHECK and IS_VALIDATION.
-- If the Is_validation flag is 0 then It points to the syntax error encountered in the calling proc.
-- If the Is_validation flag is 1 then It points to the validation error encountered in the calling proc.
 --*************************************************************************************************************************************************************
--*********************** STRUCTURE OF DDS_ERROR_LOG_CAPTURE PROCEDURE ENDS ************************************************************************
--************************************************************************************************************************************************************* ****
      
-- Below Code is commented as everybody will pass error message instead of err messge id and no need to maintain this table

/*              BEGIN
                   EXECUTE IMMEDIATE 'SELECT ERR_MESSAGE from DDS_ERR_MESSAGES where ERROR_MSG_ID=:1 and status=:2' into V_ERROR_MSG using p_ERROR_MSG_ID,v_status;
                  
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          NULL;
                     WHEN TOO_MANY_ROWS THEN
                          NULL;
                     WHEN OTHERS THEN
                          NULL;
               END;

               
              IF V_ERROR_MSG IS NOT NULL
               THEN
              -- DBMS_OUTPUT.put_LINE('K1-->'||V_ERROR_MSG);
                      V_ERROR_MSG:= V_ERROR_MSG||'. TableName:'||p_ERROR_TABLE_TO_CHECK||', ColumnName: '||p_ERROR_COLUMN||', Column Value:'||NVL(P_ERROR_COLUMN_Value,0);
              END IF;*/

               
v_SQL:=
'SELECT ERR_LOG_ROW_ID FROM DDS_ERROR_LOG WHERE JOBID =:1 AND DA_ROW_ID = :2 AND ERROR_TABLE_TO_CHECK =:3 
AND IS_VALIDATION=:4';  --removed module name from where clause --neha

BEGIN
        EXECUTE IMMEDIATE V_SQL  INTO 
          v_ERR_LOG_ROW_ID--,
         -- v_DA_ROW_ID--,
          --v_MODULE_NAME,
          --v_ERROR_TABLE_TO_CHECK,
          --v_CALLING_ERROR_LOCATION,
         -- v_CURRENT_ERROR_LOCATION,
          --v_error_desc,
         -- v_ERROR_COLUMN,
         --v_ERROR_PROC_NAME
        using 
          p_JOBID, 
          p_DA_ROW_ID,
          p_ERROR_TABLE_TO_CHECK,
          P_IS_VALIDATION
        ;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        -- If any Error is encountered from the calling proc , an insert into the error_log table is made.
        V_SQL:='INSERT INTO DDS_ERROR_LOG (ERR_LOG_ROW_ID,   JOBID,  DA_ROW_ID,  MODULE_NAME,ERROR_TABLE_TO_CHECK ,CALLING_ERROR_LOCATION ,CURRENT_ERROR_LOCATION ,ERROR_PROC_NAME,ERROR_TIME, ERROR_DESC,IS_VALIDATION ,ERROR_COLUMNS,ERROR_KEY_COLUMN ,ERROR_KEY_COLUMN_VALUE)
        Values (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14)';
        
/*        EXECUTE IMMEDIATE V_SQL USING DDS_ERROR_LOG_SEQ.NEXTVAL, p_JOBID, p_DA_ROW_ID,p_MODULE_NAME,p_ERROR_TABLE_TO_CHECK,P_CALLING_ERROR_LOCATION,P_CURRENT_ERROR_LOCATION , p_ERROR_PROC_NAME,
        TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),P_ERROR_MSG,P_IS_VALIDATION,p_ERROR_COLUMNS, p_ERROR_KEY_COLUMN ,  P_ERROR_COLUMN_KEY_VALUE;
*/     

    EXECUTE IMMEDIATE V_SQL USING DDS_ERROR_LOG_SEQ.NEXTVAL, p_JOBID, p_DA_ROW_ID,p_MODULE_NAME,p_ERROR_TABLE_TO_CHECK,P_CALLING_ERROR_LOCATION,P_CURRENT_ERROR_LOCATION , p_ERROR_PROC_NAME,
    TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),p_ERROR_COLUMNS||' : '||P_ERROR_MSG,P_IS_VALIDATION,p_ERROR_COLUMNS, p_ERROR_KEY_COLUMN ,  P_ERROR_COLUMN_KEY_VALUE;

   
/*        INSERT INTO DDS_ERROR_LOG (ERR_LOG_ROW_ID,   JOBID,  DA_ROW_ID,  MODULE_NAME,ERROR_TABLE_TO_CHECK ,CALLING_ERROR_LOCATION ,CURRENT_ERROR_LOCATION , ERROR_PROC_NAME,
                  ERROR_TIME, ERROR_DESC, IS_VALIDATION ,  ERROR_COLUMNS, ERROR_KEY_COLUMN ,  ERROR_KEY_COLUMN_VALUE)
          Values (DDS_ERROR_LOG_SEQ.NEXTVAL, p_JOBID, p_DA_ROW_ID,p_MODULE_NAME,p_ERROR_TABLE_TO_CHECK,P_CALLING_ERROR_LOCATION ,P_CURRENT_ERROR_LOCATION , p_ERROR_PROC_NAME ,
         --to_date(Sysdate,'YYYYMMDDHH24MISS'),P_ERROR_MSG,P_IS_VALIDATION,p_ERROR_COLUMNS, p_ERROR_KEY_COLUMN ,  P_ERROR_COLUMN_KEY_VALUE );  --neha changed the date format
         TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),P_ERROR_MSG,P_IS_VALIDATION,p_ERROR_COLUMNS, p_ERROR_KEY_COLUMN ,  P_ERROR_COLUMN_KEY_VALUE );
*/     
    v_commit_flag := 1;
      WHEN TOO_MANY_ROWS THEN
        NULL;
      WHEN OTHERS THEN
        NULL;
       --Dbms_Output.put_LINE('sqlerrm1--'||sqlerrm);  
        
END;

    IF v_ERR_LOG_ROW_ID IS NOT NULL THEN
      -- If more than one error is encountered corresponding to the same record, An update into DDS_ERROR_LOG is made coressponing to the same JOBID , DA_ROW_ID,ERROR_TABLE_TO_CHECK and IS_VALIDATION.
      v_SQL:= 'Update DDS_ERROR_LOG Set CALLING_ERROR_LOCATION = CALLING_ERROR_LOCATION ||'||''' \n '''||' ||  :1,
     CURRENT_ERROR_LOCATION = CURRENT_ERROR_LOCATION ||'||''' \n '''||'|| :2,
      ERROR_PROC_NAME = ERROR_PROC_NAME ||'||''' \n '''||'|| :3,
      ERROR_TIME =  :4,
      ERROR_DESC = ERROR_DESC||chr(13)|| :5,
      ERROR_COLUMNS = ERROR_COLUMNS ||'||''' ; '''||'||  :6
       WHERE JOBID =:7 AND DA_ROW_ID = :8 AND ERROR_TABLE_TO_CHECK =:9 
AND IS_VALIDATION=:10
    ';
       
    EXECUTE IMMEDIATE V_SQL USING P_CALLING_ERROR_LOCATION,P_CURRENT_ERROR_LOCATION, p_ERROR_PROC_NAME,TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),
      p_ERROR_COLUMNS||' : '||P_ERROR_MSG, p_ERROR_COLUMNS,
          p_JOBID, 
          p_DA_ROW_ID,
          p_ERROR_TABLE_TO_CHECK,
          P_IS_VALIDATION
;
       
      
    /*  Update DDS_ERROR_LOG Set 
      CALLING_ERROR_LOCATION = CALLING_ERROR_LOCATION ||'\n'|| P_CALLING_ERROR_LOCATION,
      CURRENT_ERROR_LOCATION = CURRENT_ERROR_LOCATION ||'\n'|| P_CURRENT_ERROR_LOCATION,
      ERROR_PROC_NAME = ERROR_PROC_NAME||'\n'||p_ERROR_PROC_NAME,
      ERROR_TIME = to_date(Sysdate,'YYYYMMDDHH24MISS'), 
      ERROR_DESC=ERROR_DESC||chr(13)||P_ERROR_MSG,
      --IS_VALIDATION=IS_VALIDATION||P_IS_VALIDATION,  
      ERROR_COLUMNS = ERROR_COLUMNS||' ; '||p_ERROR_COLUMNS
      WHERE ERR_LOG_ROW_ID=v_ERR_LOG_ROW_ID;*/
      
     -- DBMS_OUTPUT.put_LINE('KAPIL-->'||v_ERROR_DESC||'-=-=-==-'||V_ERROR_MSG||'--ERRLOGRWID--'||v_ERR_LOG_ROW_ID);
    
      
      v_commit_flag := 1;
      
    END IF;

    IF v_commit_flag = 1 then
      COMMIT;
    END IF;

EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NULL;
         --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
     WHEN TOO_MANY_ROWS THEN
          NULL;
     WHEN OTHERS THEN
           NULL;
          --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);

END DDS_ERROR_LOG_CAPTURE;