Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','7','alter table t_mcre0_all_data exchange subpartition ccp_s11 with table t_mcre0_all_data_today including indexes','ALL','1',to_date('09-DIC-2013 17:51:27','DD-MON-YYYY HH24:MI:SS'),'EXCHANGE SUBPARTITION CCP_S11 WITH TABLE T_MCRE0_ALL_DATA_TODAY');