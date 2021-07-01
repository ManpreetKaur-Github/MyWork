/* asingh278  - MITS 38443 - DA-DIS , DataFlow correction - DF_IMPORT_FUNDS_MULTI_PAYEE_ASSIGN_PAYEE_EID*/
/*PAY_TO_THE_ORDER_OF value is calculated based upon Payee information provided in the DIS import table funds_x_payee and inserted in RMDB*/
-- Template-rmA 15.4_DIS
create or replace PROCEDURE USP_MULTI_PAYEE_ASSIGN_EID(p_JOBID IN NUMBER) 
AS
-- cursor variable declaration --
V_DA_ROW_ID  NUMBER;
V_JOBID   NUMBER;
V_ENTITY_ID   NUMBER;
V_FIRST_NAME varchar2(255);
V_LAST_NAME varchar2(255);
V_ADDR1 varchar2(100);
V_ADDR2 varchar2(100);
V_ADDR3 varchar2(100);
V_ADDR4 varchar2(100);
V_CITY varchar2(50);
V_STATE_ID NUMBER;
V_ZIP_CODE varchar2(10);
V_STAGING_ID  NUMBER;
V_PHRASE_TYPE_CODE varchar2(25);
V_PAY_TO_THE_ORDER_OF varchar2(4000);
V_PAY_TO_THE_ORDER_OF_OLD varchar2(4000);
V_PAY_TO_THE_ORDER_OF_NEW varchar2(4000);
CURSOR payee_update IS			--  cursor declared

-- fetching data from tables --
select FUNDS.DA_ROW_ID,FUNDS.JOBID,
ENTITY.ENTITY_ID,ENTITY.FIRST_NAME,ENTITY.LAST_NAME,ENTITY.ADDR1,ENTITY.ADDR2,ENTITY.ADDR3,ENTITY.ADDR4,ENTITY.CITY,ENTITY.STATE_ID,ENTITY.ZIP_CODE,FUNDS.STAGING_ID,
T_DIS_FUNDS_X_PAYEE.PHRASE_TYPE_CODE,
CASE WHEN							--case for "pay to the order of"
ENTITY.FIRST_NAME  IS NULL 
THEN  ENTITY.LAST_NAME ELSE 
ENTITY.FIRST_NAME  || ' '
|| ENTITY.LAST_NAME  END
AS PAY_TO_THE_ORDER_OF
FROM
ENTITY 
INNER JOIN T_DIS_ENTITY ON ENTITY.DA_ROW_ID  =  T_DIS_ENTITY.DA_ROW_ID 
INNER JOIN FUNDS ON T_DIS_ENTITY.JOBID  =  FUNDS.JOBID 
INNER JOIN T_DIS_FUNDS ON  FUNDS.DA_ROW_ID  =  T_DIS_FUNDS.DA_ROW_ID 
INNER JOIN T_DIS_FUNDS_X_PAYEE T_DIS_FUNDS_X_PAYEE ON 
T_DIS_FUNDS.TRANS_ID_SOURCE  =  T_DIS_FUNDS_X_PAYEE.TRANS_ID_SOURCE 
INNER JOIN FUNDS_X_PAYEE ON 
 FUNDS_X_PAYEE.DA_ROW_ID  =  T_DIS_FUNDS_X_PAYEE.DA_ROW_ID 
AND
 FUNDS_X_PAYEE.JOBID  =  FUNDS.JOBID 
AND FUNDS_X_PAYEE.PAYEE_EID  =   T_DIS_ENTITY.ENTITY_ID 
WHERE 
FUNDS.JOBID  =  p_JOBID and		-- getting global variable job_id
ENTITY.JOBID  =   p_JOBID and		-- getting global variable job_id
ENTITY.INVALID_ROW  = 0;

begin
BEGIN
OPEN payee_update;			-- cursor start
LOOP
FETCH payee_update			-- fetching  row
INTO						-- getting row data
V_DA_ROW_ID,
V_JOBID,
V_ENTITY_ID,
V_FIRST_NAME,
V_LAST_NAME,
V_ADDR1,
V_ADDR2 ,
V_ADDR3,
V_ADDR4,
V_CITY ,
V_STATE_ID,
V_ZIP_CODE ,
V_STAGING_ID ,
V_PHRASE_TYPE_CODE ,
V_PAY_TO_THE_ORDER_OF;
EXIT WHEN payee_update%NOTFOUND;

-- replacing null or blank with 'and' -- 

IF (V_PHRASE_TYPE_CODE is null )OR (V_PHRASE_TYPE_CODE= '' )
THEN
V_PHRASE_TYPE_CODE := ' and ';
END IF;
begin

--	fetching old PAY_TO_THE_ORDER_OF from funds	--
Select F.PAY_TO_THE_ORDER_OF INTO V_PAY_TO_THE_ORDER_OF_OLD  from funds F where
F.STAGING_ID=V_STAGING_ID and F.JOBID=V_JOBID;

-- EXCEPTION Handling --
EXCEPTION
when NO_DATA_FOUND then
V_PAY_TO_THE_ORDER_OF_OLD:= null;
when TOO_MANY_ROWS then
V_PAY_TO_THE_ORDER_OF_OLD:= null;
WHEN OTHERS THEN
V_PAY_TO_THE_ORDER_OF_OLD:= null;
END;

IF (V_PAY_TO_THE_ORDER_OF_OLD  IS NOT NULL) THEN		-- fetching old PAY_TO_THE_ORDER_OF from funds
V_PAY_TO_THE_ORDER_OF_NEW :=V_PAY_TO_THE_ORDER_OF ||''||V_PHRASE_TYPE_CODE ||''|| V_PAY_TO_THE_ORDER_OF_OLD ;
ELSE
V_PAY_TO_THE_ORDER_OF_NEW :=V_PAY_TO_THE_ORDER_OF;
END IF;


update funds F 											--updating calculated PAY_TO_THE_ORDER_OF 
set F.PAY_TO_THE_ORDER_OF=V_PAY_TO_THE_ORDER_OF_NEW
where F.STAGING_ID=V_STAGING_ID and F.JOBID=V_JOBID; 
COMMIT;

update funds F											--updating other values from import entity table 
set F.PAYEE_EID=V_ENTITY_ID,F.FIRST_NAME=V_FIRST_NAME,F.LAST_NAME=V_LAST_NAME,
F.ADDR1=V_ADDR1,F.ADDR2=V_ADDR2,F.ADDR3=V_ADDR3,F.ADDR4=V_ADDR4,F.CITY=V_CITY,F.STATE_ID=V_STATE_ID,F.ZIP_CODE=V_ZIP_CODE
where F.DA_ROW_ID=V_DA_ROW_ID and F.JOBID=V_JOBID;

COMMIT;

end LOOP;
CLOSE payee_update	;									-- cursor close

-- EXCEPTION Handling --

EXCEPTION
when NO_DATA_FOUND then
V_PAY_TO_THE_ORDER_OF_OLD:= null;
when TOO_MANY_ROWS then
V_PAY_TO_THE_ORDER_OF_OLD:= null;
WHEN OTHERS THEN
V_PAY_TO_THE_ORDER_OF_OLD:= null;
END;

END; -- procedure end
