Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_ge_gb','4','insert into T_MCRE0_DAY_CGEG
 select   DTA_RIFERIMENTO_CR,
            VAL_ACC_CR_GE,
            VAL_ACC_SIS_GE,
            VAL_GAR_CR_GE,
            VAL_GAR_SIS_GE,
            VAL_SCO_CR_GE,
            VAL_SCO_SIS_GE,
            VAL_UTI_CR_GE,
            VAL_UTI_SIS_GE,
            COD_SNDG_GE,
            SYSDATE as DTA_INS,
            SYSDATE as DTA_UPD,
            ID_DPER
     from   V_MCRE0_DAY_CGEG','DAY','1',to_date('11-MAR-2014 13:08:08','DD-MON-YYYY HH24:MI:SS'),'insert into T_MCRE0_DAY_CGEG');