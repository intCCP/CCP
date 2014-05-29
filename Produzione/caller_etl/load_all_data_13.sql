Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','13','merge into  t_mcre0_all_data  fg
using (select distinct cod_gruppo_super,cod_comparto_proposto from v_mcre0_assegna_comparto_GB_AV) a
on (fg.cod_gruppo_super = a.cod_gruppo_super and fg.flg_active = '1') 
when matched then
update
set fg.cod_comparto_assegnato = a.cod_comparto_proposto','ALL','1',to_date('30-APR-2014 11:10:44','DD-MON-YYYY HH24:MI:SS'),'(cod_comparto_assegnato, id_utente, dta_utente_assegnato): assegna_comparto_GB_AV');