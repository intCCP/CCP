Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_ge_gb','5','MERGE INTO  T_MCRE0_DWH_CGEG trg
USING T_MCRE0_DAY_CGEG src
ON  (trg.COD_SNDG_GE=src.COD_SNDG_GE)
WHEN MATCHED THEN UPDATE
SET
trg.DTA_RIFERIMENTO_CR=src.DTA_RIFERIMENTO_CR,
trg.VAL_ACC_CR_GE=src.VAL_ACC_CR_GE,
trg.VAL_ACC_SIS_GE=src.VAL_ACC_SIS_GE,
trg.VAL_GAR_CR_GE=src.VAL_GAR_CR_GE,
trg.VAL_GAR_SIS_GE=src.VAL_GAR_SIS_GE,
trg.VAL_SCO_CR_GE=src.VAL_SCO_CR_GE,
trg.VAL_SCO_SIS_GE=src.VAL_SCO_SIS_GE,
trg.VAL_UTI_CR_GE=src.VAL_UTI_CR_GE,
trg.VAL_UTI_SIS_GE=src.VAL_UTI_SIS_GE,
trg.DTA_UPD= sysdate,
trg.ID_DPER = src.ID_DPER
WHEN NOT MATCHED THEN INSERT (
        trg.DTA_RIFERIMENTO_CR,
        trg.VAL_ACC_CR_GE,
        trg.VAL_ACC_SIS_GE,
        trg.VAL_GAR_CR_GE,
        trg.VAL_GAR_SIS_GE,
        trg.VAL_SCO_CR_GE,
        trg.VAL_SCO_SIS_GE,
        trg.VAL_UTI_CR_GE,
        trg.VAL_UTI_SIS_GE,
        trg.COD_SNDG_GE,
        trg.DTA_INS    ,
        trg.DTA_UPD    ,
        trg.ID_DPER
        )
VALUES (
        src.DTA_RIFERIMENTO_CR,
        src.VAL_ACC_CR_GE,
        src.VAL_ACC_SIS_GE,
        src.VAL_GAR_CR_GE,
        src.VAL_GAR_SIS_GE,
        src.VAL_SCO_CR_GE,
        src.VAL_SCO_SIS_GE,
        src.VAL_UTI_CR_GE,
        src.VAL_UTI_SIS_GE,
        src.COD_SNDG_GE,
        sysdate,
        sysdate,
        src.ID_DPER )','DWH','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'MERGE INTO  T_MCRE0_DWH_CGEG');
