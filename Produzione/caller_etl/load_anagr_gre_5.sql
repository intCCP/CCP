Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_anagr_gre','5','MERGE INTO  T_MCRE0_DWH_AGRE trg
USING T_MCRE0_DAY_AGRE src
ON  (trg.COD_GRE=src.COD_GRE)
WHEN MATCHED THEN UPDATE
SET trg.VAL_ANA_GRE = src.VAL_ANA_GRE,
    trg.DTA_UPD= sysdate,   
    trg.ID_DPER = src.ID_DPER
WHEN NOT MATCHED THEN
    INSERT (
            trg.COD_GRE,
            trg.VAL_ANA_GRE,
            trg.DTA_INS    ,
            trg.DTA_UPD    ,
            trg.ID_DPER)
    VALUES (
            src.COD_GRE,
            src.VAL_ANA_GRE,
            sysdate,
            sysdate,            
            src.ID_DPER )','DWH','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'MERGE INTO  T_MCRE0_DWH_AGRE ');