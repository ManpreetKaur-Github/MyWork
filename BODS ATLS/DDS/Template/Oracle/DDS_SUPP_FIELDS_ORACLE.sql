CREATE OR REPLACE PROCEDURE DDS_SUPP_FIELDS(
P_TABLENAME VARCHAR2, 
P_RMDBNAME VARCHAR2,
P_SFIELD VARCHAR2,
P_QUERY_RESULT OUT SYS_REFCURSOR
) 
AS
V_SQL VARCHAR2(4000);
V_RMDBNAME VARCHAR2(50);
BEGIN
  V_RMDBNAME := P_RMDBNAME ||'.';
 IF P_SFIELD IS NULL THEN 
  V_SQL :=  'SELECT DISTINCT UPPER(SD.SYS_FIELD_NAME) SYS_FIELD_NAME, SD.FIELD_ID FROM '||V_RMDBNAME||'SUPP_DICTIONARY SD  WHERE SD.SUPP_TABLE_NAME = :1 ';--|| ''''||P_TABLENAME||'''' ;   
  V_SQL := V_SQL || ' AND SD.FIELD_TYPE not in (7,20,31,10,25,12, 22,13)  AND SD.DELETE_FLAG = 0 ' ;
  OPEN P_QUERY_RESULT FOR V_SQL USING P_TABLENAME;
 ELSIF P_SFIELD IS NOT NULL THEN
  V_SQL :=  'SELECT SD.CODE_FILE_ID FROM '||V_RMDBNAME||'SUPP_DICTIONARY SD  WHERE SD.FIELD_ID = :1';--|| ''''||P_SFIELD||'''' ;   
  V_SQL := V_SQL || ' AND SD.FIELD_TYPE not in (7,20,31,10,25,12, 22,13)  AND SD.DELETE_FLAG = 0 ' ;
  OPEN P_QUERY_RESULT FOR V_SQL USING P_SFIELD;
 END IF;
/*SELECT DISTINCT UPPER(SD.SYS_FIELD_NAME),SD.FIELD_ID FROM USER_TAB_COLUMNS C
RIGHT OUTER JOIN SUPP_DICTIONARY SD  ON UPPER(C.COLUMN_NAME) = UPPER(SD.SYS_FIELD_NAME)
WHERE SD.SUPP_TABLE_NAME = 'CLAIM_SUPP' 
and NVL(UPPER(C.TABLE_name),'CLAIM_SUPP')  = UPPER(SD.SUPP_TABLE_NAME)
AND SD.FIELD_TYPE <> 7 
AND SD.FIELD_TYPE <> 20 
AND SD.DELETE_FLAG = 0*/
--OPEN P_QUERY_RESULT FOR V_SQL USING P_TABLENAME;

END DDS_SUPP_FIELDS;