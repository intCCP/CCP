Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_cr_lg_gb','0','insert into T_MCRE0_STH_CLGG select * from T_MCRE0_STG_CLGG g where not exists (select 1 from T_MCRE0_STH_CLGG h where h.id_dper=g.id_dper)','STG','1',to_date('18-NOV-2013 00:47:46','DD-MON-YYYY HH24:MI:SS'),'insert into T_MCRE0_STH_CLGG select * from T_MCRE0_STG_CLGG g where not exists (select 1 from T_MCRE0_STH_CLGG h where h.id_dper=g.id_dper)');