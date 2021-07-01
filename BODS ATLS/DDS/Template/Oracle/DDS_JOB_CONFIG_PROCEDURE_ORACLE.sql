CREATE OR REPLACE PROCEDURE DDS_CONFIG_JOB_ORACLE(
 P_CONFIG_ID IN INTEGER 
 ,P_CONFIG_NAME IN VARCHAR2 
 ,P_USERID IN INTEGER 
 ,P_XML_STRING IN CLOB 
 ,P_INPUT_TYPE in VARCHAR2
 ,P_IS_DELETED in INTEGER
) 
AUTHID CURRENT_USER 
AS 
BEGIN 
 
IF P_input_type='I' then 
 INSERT INTO DDS_JOB_CONFIG_OPTIONS(CONFIG_ID,CONFIG_NAME,USERID, XML_STRING,IS_DELETED) VALUES  
 (P_CONFIG_ID, P_CONFIG_NAME, P_USERID,P_XML_STRING,P_IS_DELETED); 
 ELSE  
 IF P_input_type='U' then 
 UPDATE DDS_JOB_CONFIG_OPTIONS set xml_string= P_XML_STRING where CONFIG_ID=P_CONFIG_ID  
 and CONFIG_NAME=P_CONFIG_NAME and USERID=P_USERID and IS_DELETED=P_IS_DELETED; 
 END IF; 
 COMMIT; 
END IF; 
END DDS_CONFIG_JOB_ORACLE;