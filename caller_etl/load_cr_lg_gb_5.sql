Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_lg_gb','5','MERGE INTO  T_MCRE0_DWH_CLGG trg
USING T_MCRE0_DAY_CLGG src
ON  (trg.COD_SNDG_LG=src.COD_SNDG_LG)
WHEN MATCHED THEN UPDATE
  SET
        trg.VAL_ACC_LGGB=src.VAL_ACC_LGGB,
        trg.VAL_UTI_LGGB=src.VAL_UTI_LGGB,
        trg.VAL_SCO_LGGB=src.VAL_SCO_LGGB,
        trg.VAL_GAR_LGGB=src.VAL_GAR_LGGB,
        trg.VAL_ACC_SIS_LG=src.VAL_ACC_SIS_LG,
        trg.VAL_UTI_SIS_LG=src.VAL_UTI_SIS_LG,
        trg.VAL_SCO_SIS_LG=src.VAL_SCO_SIS_LG,
        trg.VAL_IMP_GAR_SIS_LG=src.VAL_IMP_GAR_SIS_LG,
        trg.DTA_RIFERIMENTO_CR=src.DTA_RIFERIMENTO_CR,
        trg.DTA_UPD= sysdate,
        trg.ID_DPER = src.ID_DPER
WHEN NOT MATCHED THEN INSERT (
            trg.COD_SNDG_LG,
            trg.VAL_ACC_LGGB,
            trg.VAL_UTI_LGGB,
            trg.VAL_SCO_LGGB,
            trg.VAL_GAR_LGGB,
            trg.VAL_ACC_SIS_LG,
            trg.VAL_UTI_SIS_LG,
            trg.VAL_SCO_SIS_LG,
            trg.VAL_IMP_GAR_SIS_LG,
            trg.DTA_RIFERIMENTO_CR,
            trg.DTA_INS    ,
            trg.DTA_UPD    ,
            trg.ID_DPER
            )
  VALUES (
            src.COD_SNDG_LG,
            src.VAL_ACC_LGGB,
            src.VAL_UTI_LGGB,
            src.VAL_SCO_LGGB,
            src.VAL_GAR_LGGB,
            src.VAL_ACC_SIS_LG,
            src.VAL_UTI_SIS_LG,
            src.VAL_SCO_SIS_LG,
            src.VAL_IMP_GAR_SIS_LG,
            src.DTA_RIFERIMENTO_CR,
            sysdate,
            sysdate,
            src.ID_DPER )','DWH','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'MERGE INTO  T_MCRE0_DWH_CLGG ');
