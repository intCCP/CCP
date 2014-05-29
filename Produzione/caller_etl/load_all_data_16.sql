Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','16','merge into  t_mcre0_all_data  fg
using (select * from v_mcre0_spalma_gruppi) calc
on (fg.cod_gruppo_super = calc.cod_gruppo_super and fg.flg_active = '1') 
when matched then
update
set fg.id_utente = calc.id_utente,
fg.dta_utente_assegnato = calc.dta_utente_assegnato,
fg.cod_comparto_assegnato = calc.cod_comparto_assegnato','ALL','1',to_date('09-DIC-2013 19:02:23','DD-MON-YYYY HH24:MI:SS'),'(cod_comparto_assegnato, id_utente, dta_utente_assegnato): spalma_gruppi');