-- ============================================================
--   SCRIPT HEADER (DATABASE STRUCTURE)
--   Template-rmA 15.3_DIS
--   DESCRIPTION: Structure Definition Script for
--   Table:	DATA_INTEGRATOR, DATA_INTEGRATOR_TEMPLATES
--
--   DATE:	19/03/2009 2:25:50 PM
--   Author: Tanu Malay Singh
-- ============================================================= 
BEGIN
declare iExists NUMBER;
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DATA_INTEGRATOR';
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE DATA_INTEGRATOR(
				OPTIONSET_ID number NOT NULL,
				USER_ID number NULL,
				MODULE_NAME varchar2(50) NOT NULL,
				OPTIONSET_NAME varchar2(50) NOT NULL,
				XML_STRING CLOB NULL,
				DTTM_LAST_RUN varchar(16) NULL,
				CONSTRAINT DATA_INTEGRATOR_PK PRIMARY KEY (OPTIONSET_ID)
)';
END IF;
END;
-----------------------------------------
declare iExists NUMBER;
BEGIN
SELECT COUNT(*) INTO iExists FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OBJECT_NAME='DATA_INTEGRATOR_TEMPLATES';
IF iExists = 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE DATA_INTEGRATOR_TEMPLATES(
					ROW_ID integer NOT NULL,
					MODULE_NAME varchar2(50) NOT NULL,
					XML_STRING CLOB NOT NULL
)';
END IF;
END;
END;
----------------------------------------