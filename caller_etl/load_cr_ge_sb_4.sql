Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_ge_sb','4','insert into T_MCRE0_DAY_CGES 
select   COD_ABI_CARTOLARIZZATO,
            DTA_CR_GESB,
            VAL_ACC_CR_GESB,
            VAL_GAR_CR_GESB,
            VAL_SCO_CR_GESB,
            VAL_UTI_CR_GESB,
            COD_SNDG_GE,
            SYSDATE as DTA_INS,
            SYSDATE as DTA_UPD,
            ID_DPER
     from   V_MCRE0_DAY_CGES','DAY','1',to_date('11-MAR-2014 13:07:56','DD-MON-YYYY HH24:MI:SS'),'insert into T_MCRE0_DAY_CGES ');