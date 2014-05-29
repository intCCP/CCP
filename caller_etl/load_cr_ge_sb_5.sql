Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_ge_sb','5','MERGE INTO  T_MCRE0_DWH_CGES trg
USING T_MCRE0_DAY_CGES src
ON  (trg.COD_ABI_CARTOLARIZZATO=src.COD_ABI_CARTOLARIZZATO
and trg.COD_SNDG_GE=src.COD_SNDG_GE)
WHEN MATCHED THEN UPDATE
SET trg.DTA_CR_GESB=src.DTA_CR_GESB,
    trg.VAL_ACC_CR_GESB=src.VAL_ACC_CR_GESB,
    trg.VAL_GAR_CR_GESB=src.VAL_GAR_CR_GESB,
    trg.VAL_SCO_CR_GESB=src.VAL_SCO_CR_GESB,
    trg.VAL_UTI_CR_GESB=src.VAL_UTI_CR_GESB,
    trg.DTA_UPD = sysdate,               
    trg.ID_DPER = src.ID_DPER
WHEN NOT MATCHED THEN INSERT (
        trg.COD_ABI_CARTOLARIZZATO,
        trg.DTA_CR_GESB,
        trg.VAL_ACC_CR_GESB,
        trg.VAL_GAR_CR_GESB,
        trg.VAL_SCO_CR_GESB,
        trg.VAL_UTI_CR_GESB,
        trg.COD_SNDG_GE,
        trg.DTA_INS    ,
        trg.DTA_UPD    ,                       
        trg.ID_DPER
        )
VALUES (
        src.COD_ABI_CARTOLARIZZATO,
        src.DTA_CR_GESB,
        src.VAL_ACC_CR_GESB,
        src.VAL_GAR_CR_GESB,
        src.VAL_SCO_CR_GESB,
        src.VAL_UTI_CR_GESB,
        src.COD_SNDG_GE,
        sysdate,
        sysdate,
        src.ID_DPER )','DWH','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'MERGE INTO  T_MCRE0_DWH_CGES ');