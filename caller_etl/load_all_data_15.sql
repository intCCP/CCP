Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','15','merge into  t_mcre0_all_data  tgt
using (select distinct cod_abi_cartolarizzato, cod_ndg, cod_gruppo_super,id_corr,cod_comparto_calcolato from v_mcre0_assegna_regioni) src
on (tgt.cod_ndg = src.cod_ndg
            AND tgt.cod_abi_cartolarizzato = src.cod_abi_cartolarizzato)
when matched then update
set tgt.id_utente = src.id_corr,
tgt.cod_comparto_assegnato = src.cod_comparto_calcolato,
tgt.dta_utente_assegnato = sysdate','ALL','1',to_date('30-APR-2014 11:10:34','DD-MON-YYYY HH24:MI:SS'),'(cod_comparto_assegnato, id_utente, dta_utente_assegnato): assegna_regioni');