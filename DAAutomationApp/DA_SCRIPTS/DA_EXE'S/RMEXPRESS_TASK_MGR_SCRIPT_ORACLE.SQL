-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Database Type: Oracle
--   DI Module Name: RMEXPRESS Task Manager STRUCTURE
--Create tables
--Template_DIS_Oracle.sql
--09/07/2012
--===========================================

declare iExists NUMBER;
 CNT  varchar2(100);
 CT  varchar2(100);
 COLM  varchar2(100);
 sql1  CLOB;
 sql2  CLOB;
BEGIN
--==========================================================
---CREATE DA_JOB_NAMES table 
--============================================================
BEGIN 
  SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DA_JOB_NAMES';


    IF iExists = 0 THEN

      EXECUTE IMMEDIATE 'CREATE TABLE DA_JOB_NAMES(
      DSNID number(10) not null,
      TASK_TYPE_ID number(10) NULL  ,
      JOB_NAME varchar2(4000) NULL,
      DOCUMENTMANAGEMENTENABLED varchar2(5),
      RMADOCUMENTPOOLPATH varchar2(50) null,
      KEEPJOBFILESONSUCCESS varchar2(5),
      SUB_JOB_NAME varchar2(10) NULL
    )';

    ELSE

    sql1:='select count(*) from user_tab_cols where column_name=''DOCUMENTMANAGEMENTENABLED'' AND TABLE_NAME=''DA_JOB_NAMES''';
    EXECUTE IMMEDIATE sql1 INTO CNT ;

                  IF (CNT ='0') THEN
                  BEGIN
                  sql1:= 'ALTER TABLE DA_JOB_NAMES ADD (DOCUMENTMANAGEMENTENABLED varchar(5),RMADOCUMENTPOOLPATH varchar(50) null,KEEPJOBFILESONSUCCESS 

varchar(5))';
                  EXECUTE IMMEDIATE sql1;
                  END;
                  ELSE
                  CT:=1;
                  END IF;
    END IF;

    BEGIN
    CNT:=0;
    sql1:='select count(*) from user_tab_cols where column_name=''SUB_JOB_NAME'' AND TABLE_NAME=''DA_JOB_NAMES''';
    EXECUTE IMMEDIATE sql1 INTO CNT ;
    END;
    
    IF (CNT ='0') THEN
    BEGIN
    sql1:= 'ALTER TABLE DA_JOB_NAMES ADD SUB_JOB_NAME varchar(10)';
    EXECUTE IMMEDIATE sql1;
    END;
    END IF;
  --==========================================================
  ---CREATE DA_CONFIG table 
  --============================================================
    BEGIN 
    SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DA_CONFIG';


        IF iExists = 0 THEN

          EXECUTE IMMEDIATE 'CREATE TABLE DA_CONFIG(
          DSNID number(10) not null,
          AccessStagingDataSource varchar2(4000) NULL  ,
          RMXStagingDataSource varchar2(4000) NULL,
          StagingDataSource varchar2(4000) NULL,
          RMXLoginName varchar2(50) null ,
          RMXDataSourceName varchar2(50) null,
          FilePath varchar(4000) null,
          DocAttachNameDelimeter varchar(1) null,
        S3BucketOnCloud varchar(4000) null
              
        )';

        ELSE
        BEGIN
        sql1:='select count(*) from user_tab_cols where column_name=''FILEPATH'' AND TABLE_NAME=''DA_CONFIG''';
        EXECUTE IMMEDIATE sql1 INTO CNT ;
                    IF (CNT ='0') THEN
                    BEGIN
                    sql1:= 'ALTER TABLE DA_CONFIG ADD (FilePath varchar(4000),DocAttachNameDelimeter varchar(1) null,S3BUCKETONCLOUD varchar(4000))';
                    EXECUTE IMMEDIATE sql1;
                    END;
                    END IF;
        END ;
        END IF;
    END;
    
    BEGIN 
       COLM :=0;
       sql2:='select count(*) from user_tab_cols  where column_name=''KEEPJOBFILESONSUCCESS'' AND TABLE_NAME=''DA_CONFIG''';
       EXECUTE IMMEDIATE sql2 INTO COLM ;
       
    END;
    
    if(COLM>'0') THEN 
      BEGIN
         sql1 := 'update DA_JOB_NAMES set DOCUMENTMANAGEMENTENABLED = (select d.DOCUMENTMANAGEMENTENABLED from DA_CONFIG d where d.dsnid=dsnid),
        RMADOCUMENTPOOLPATH = (select d.RMADOCUMENTPOOLPATH from DA_CONFIG d where d.dsnid=dsnid),
        KEEPJOBFILESONSUCCESS = (select d.KEEPJOBFILESONSUCCESS from DA_CONFIG d where d.dsnid=dsnid)
        where dsnid = (select t.dsnid from DA_CONFIG t where t.dsnid=dsnid)';
          EXECUTE IMMEDIATE sql1  ;
          COMMIT;
        
      END ;
     ELSE
      BEGIN
          IF(CT='0') THEN
          BEGIN
           sql1 := 'update DA_JOB_NAMES set DOCUMENTMANAGEMENTENABLED = (select d.DOCUMENTMANAGEMENTENABLED from DA_CONFIG d where d.dsnid=dsnid),
            RMADOCUMENTPOOLPATH = (select d.RMADOCUMENTPOOLPATH from DA_CONFIG d where d.dsnid=dsnid)
            where dsnid = (select t.dsnid from DA_CONFIG t where t.dsnid=dsnid)';
             EXECUTE IMMEDIATE sql1  ;  
             COMMIT;        
          END ;
          END IF ;

      END; 
      
    END IF ;
     
    BEGIN 
          CNT:='0';
          sql1:='select  count(*) from  user_tab_cols  where column_name=''DOCUMENTMANAGEMENTENABLED'' AND TABLE_NAME=''DA_CONFIG''';
          
           EXECUTE IMMEDIATE sql1 INTO CNT ;               
    END ;
   
    if(CNT>'0') THEN 
      BEGIN

      sql1 := 'ALTER TABLE DA_CONFIG DROP ( DOCUMENTMANAGEMENTENABLED,RMADOCUMENTPOOLPATH)';
        EXECUTE IMMEDIATE sql1  ; 
        COMMIT;    

      END; 
    END IF ; 

  BEGIN 
          CNT:='0';
          sql1:='select  count(*) from  user_tab_cols  where column_name=''S3BUCKETONCLOUD'' AND TABLE_NAME=''DA_CONFIG''';
          
           EXECUTE IMMEDIATE sql1 INTO CNT ;               
    END ;
   
    if(CNT='0') THEN 
      BEGIN

      sql1 := 'ALTER TABLE DA_CONFIG ADD S3BUCKETONCLOUD varchar(4000)';
        EXECUTE IMMEDIATE sql1  ; 
        COMMIT;    

      END; 
    END IF ; 
  
    
    if(COLM>'0') THEN
    BEGIN
      sql1 := 'ALTER TABLE DA_CONFIG DROP COLUMN KEEPJOBFILESONSUCCESS' ;
       EXECUTE IMMEDIATE sql1  ;  
       COMMIT;  

    END ;
   END IF ;
    

END; 

END;



