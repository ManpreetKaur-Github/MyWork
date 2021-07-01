CREATE OR REPLACE PROCEDURE DDS_PROCESS_LOG(p_JOBID NUMBER,
p_MODULE_NAME VARCHAR2,
p_PROCESS_TABLE VARCHAR2
)
AUTHID CURRENT_USER 
AS
/*Declaration Part*/
PRAGMA AUTONOMOUS_TRANSACTION;
V_PROCESS_MSG varchar2(4000);
V_COUNT NUMBER;

BEGIN

       EXECUTE IMMEDIATE 'SELECT COUNT(*) from '|| p_PROCESS_TABLE || ' where JOBID=:1 ' into V_COUNT using p_JOBID;
   
  -- DBMS_OUTPUT.put_LINE('K1-->'||V_ERROR_MSG);
       V_PROCESS_MSG:= 'Total Number of Records Read: '||V_COUNT||' in ' ||p_MODULE_NAME ||'.';

       EXECUTE IMMEDIATE ' INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)' 
       USING p_JOBID,V_PROCESS_MSG, p_MODULE_NAME,p_PROCESS_TABLE,1 ;
       
       
       EXECUTE IMMEDIATE 'SELECT COUNT(*) from '|| p_PROCESS_TABLE || ' where JOBID=:1 AND INVALID_ROW > 0' into V_COUNT using p_JOBID;
   
  -- DBMS_OUTPUT.put_LINE('K1-->'||V_ERROR_MSG);
       V_PROCESS_MSG:= 'Total Number of Records Failed: '||V_COUNT||' in ' ||p_MODULE_NAME ||'.';

       EXECUTE IMMEDIATE ' INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)' 
       USING p_JOBID,V_PROCESS_MSG, p_MODULE_NAME,p_PROCESS_TABLE,2 ;


      EXECUTE IMMEDIATE 'SELECT COUNT(*) from '|| p_PROCESS_TABLE || ' where JOBID=:1 AND INVALID_ROW = 0' into V_COUNT using p_JOBID;
   
      --EXECUTE IMMEDIATE 'SELECT COUNT(*) from '|| p_PROCESS_TABLE || ' where JOBID=:1 AND INVALID_ROW = 0 and UPDATE_ROW = 0' into V_COUNT_I using p_JOBID;
      
      --EXECUTE IMMEDIATE 'SELECT COUNT(*) from '|| p_PROCESS_TABLE || ' where JOBID=:1 AND INVALID_ROW = 0 and UPDATE_ROW = 1' into V_COUNT_U using p_JOBID;

   
  -- DBMS_OUTPUT.put_LINE('K1-->'||V_ERROR_MSG);
      -- V_PROCESS_MSG:= 'Processed Records : '||V_COUNT||'. New Records : '||V_COUNT_I||' and Updated Records: '||V_COUNT_U||' in ' ||p_MODULE_NAME ||' .';
     
 V_PROCESS_MSG:= 'Total Number of Records Successfully Processed : '||V_COUNT||' in ' ||p_MODULE_NAME ||'.'; --neha 

       EXECUTE IMMEDIATE ' INSERT INTO DDS_PROCESS_LOG_T (JOBID,PROCESS_DESC,MODULE_NAME, TABLE_NAME, DISPLAY_ORDER ) VALUES(:1,:2,:3,:4,:5)' 
       USING p_JOBID,V_PROCESS_MSG, p_MODULE_NAME,p_PROCESS_TABLE,3 ;

       COMMIT;
             
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NULL;
         --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);
     WHEN TOO_MANY_ROWS THEN
          NULL;
     WHEN OTHERS THEN
           NULL;
          --Dbms_Output.put_LINE('sqlerrm--'||sqlerrm);

END DDS_PROCESS_LOG;