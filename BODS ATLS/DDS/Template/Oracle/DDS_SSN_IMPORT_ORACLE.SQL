CREATE OR REPLACE PROCEDURE DDS_SSN_IMPORT
(
v_P_Tax_id IN VARCHAR2 ,
v_P_State_id IN NUMBER,
v_P_DBNAME IN VARCHAR2,
v_P_TaxIDFormatted OUT VARCHAR2
)

AUTHID CURRENT_USER 
AS

v_Countrycode VARCHAR2(20);
v_Countryid NUMBER(10,0);
v_SSNformat VARCHAR2(11);
v_n_SQL VARCHAR2(32000);
v_V_SQL VARCHAR2(32000);
v_Taxid VARCHAR2(11);
  
BEGIN
	
v_Taxid := v_P_Tax_id;

	IF v_P_State_id != 0 THEN
	BEGIN
		v_V_SQL := 'SELECT COUNTRY_ID FROM ' || v_P_DBNAME || 'STATES WHERE STATE_ROW_ID = ' || v_P_State_id;
			EXECUTE IMMEDIATE v_V_SQL INTO v_Countrycode;
	    v_Countrycode :=  '''' || v_Countrycode || '''';
	    v_n_SQL := 'SELECT CODE_ID FROM ' || v_P_DBNAME || 'CODES WHERE SHORT_CODE = ' || v_Countrycode ||  ' AND TABLE_ID =(SELECT TABLE_ID FROM ' || v_P_DBNAME || ' GLOSSARY WHERE SYSTEM_TABLE_NAME = ''COUNTRY'')';
			EXECUTE IMMEDIATE v_n_SQL INTO v_Countryid; 
	END;
	END IF;
	IF v_Countryid != 0 THEN
	BEGIN
		v_n_SQL := 'SELECT SSN_FORMATDESC FROM ' || v_P_DBNAME || 'SSN_FORMAT WHERE COUNTRY_ID = ' || v_Countryid || ' AND SSN_FORMATDESC != ''0'' AND ROWNUM <=1 ORDER BY ROWNUM';
			EXECUTE IMMEDIATE v_n_SQL INTO v_SSNformat;
	END;
	END IF;
	IF v_SSNformat is NULL THEN
	BEGIN
		v_n_SQL := 'SELECT SSN_FORMATDESC FROM ' || v_P_DBNAME || 'SSN_FORMAT WHERE COUNTRY_ID = -1 AND SSN_FORMATDESC != ''0'' AND ROWNUM <=1 ORDER BY ROWNUM';
			EXECUTE IMMEDIATE v_n_SQL INTO v_SSNformat;
	END;
	END IF;
	
	IF v_SSNformat = '###-##-####' THEN
	
		v_Taxid := SUBSTR(v_Taxid,1,3) || '-' || SUBSTR(v_Taxid,4,2) || '-' || SUBSTR(v_Taxid,6,4);

	ELSIF v_SSNformat = '###-###-###' THEN
	
		v_Taxid := SUBSTR(v_Taxid,1,3) || '-' || SUBSTR(v_Taxid,4,3) || '-' || SUBSTR(v_Taxid,7,3);

	ELSIF v_SSNformat = '##-#######' THEN
	
		v_Taxid := SUBSTR(v_Taxid,1,2) || '-' || SUBSTR(v_Taxid,3,7);
	END IF;
	
	v_P_TaxIDFormatted := v_Taxid;
  
END DDS_SSN_IMPORT;