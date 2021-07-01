;Create field in FUNDS supplemental table
;****************************************************************
[ASSIGN %%1=ADD_STATE_FIELD(FUNDS_SUPP,SICS EXTRACTED,SICS_EXTRACTED,31,0,0,0,0,0,,0)]

;Create field in CVG_TYPE_SUPP table
[ASSIGN %%1=ADD_STATE_FIELD(CVG_TYPE_SUPP,Coverage Country,COV_CNTRY_CODE,6,0,0,0,0,0,,COUNTRY)]
[ASSIGN %%1=ADD_STATE_FIELD(CVG_TYPE_SUPP,Coverage State,COV_ST_STATE,9,0,0,0,0,0,,STATES)]

