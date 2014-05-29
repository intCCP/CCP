Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_anagr_gre','4','insert into T_MCRE0_DAY_AGRE 
select   COD_GRUPPO_ECO as COD_GRE,
            DESC_GRUPPO_ECO as VAL_ANA_GRE,
            SYSDATE as DTA_INS,
            SYSDATE as DTA_UPD,
            ID_DPER
     from   T_MCRE0_STG_AGRE','DAY','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'insert into T_MCRE0_DAY_AGRE 
select   COD_GRUPPO_ECO as COD_GRE,
            DESC_GRUPPO_ECO as VAL_ANA_GRE,
            SYSDATE as DTA_INS,
            SYSDATE as DTA_UPD,
            ID_DPER
     from   T_MCRE0_STG_AGRE');