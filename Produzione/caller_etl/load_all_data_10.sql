Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','12','update t_mcre0_all_data set 
id_utente = -1,
cod_comparto_assegnato = null,
dta_utente_assegnato = null,  
cod_servizio = null,
dta_servizio = null 
where  flg_riportafogliato='1' and  flg_active = '1'','ALL','1',to_date('24-GEN-2014 11:32:02','DD-MON-YYYY HH24:MI:SS'),'(cod_comparto_assegnato, id_utente, dta_utente_assegnato): check_riportafogliazione');