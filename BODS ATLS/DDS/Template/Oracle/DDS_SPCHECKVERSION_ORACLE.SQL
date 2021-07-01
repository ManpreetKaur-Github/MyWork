CREATE OR REPLACE PROCEDURE DDS_spCheckVersion
(
  v_vTableName IN VARCHAR2 DEFAULT NULL ,
  v_vFieldName IN VARCHAR2 DEFAULT NULL ,
  vDbName IN VARCHAR2 DEFAULT NULL ,
  v_iRetVal OUT NUMBER
)
AS
   v_nSql VARCHAR2(4000);
   --V_vDbName VARCHAR2(30);
   v_vColumnName VARCHAR2(4000);
BEGIN
   v_vColumnName := NULL;
   v_iRetVal := 0;
   --v_vDbName := vDbName || '.';

   v_nSql := 'SELECT COLUMN_NAME FROM all_tab_columns WHERE';
   v_nSql := v_nSql || ' OWNER=:1 AND TABLE_NAME = :2 AND COLUMN_NAME = :3';
   
  BEGIN 
   EXECUTE IMMEDIATE V_NSQL INTO v_vColumnName USING vDbName, v_vTableName, v_vFieldName;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
      v_vColumnName := NULL;
  END;
         
   IF v_vColumnName IS NOT NULL AND v_vColumnName = v_vFieldName THEN
      v_iRetVal := 1;
   END IF;
END DDS_spCheckVersion;
