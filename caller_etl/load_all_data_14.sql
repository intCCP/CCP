Insert into T_MCRE0_ETL_CALLER (CALLER,SQL_ORD,SQL_TEXT,STEP,FLG_EXEC,LAST_UPDATE_DATE,NOTE) values ('load_all_data','14','update t_mcre0_all_data f
    set id_utente_pre = nvl (id_utente, id_utente_pre),
      id_utente = -1,
      cod_comparto_assegnato = null,
      dta_utente_assegnato = null,
      --------------------   vg - cib/bdt - inizio --------------------
      cod_servizio = null,
      dta_servizio = null
      --------------------   VG - CIB/BDT - FINE --------------------
   where COD_GRUPPO_SUPER in (
select F.COD_GRUPPO_SUPER
from  t_mcre0_all_data f,  t_mcre0_app_stati s 
      where f.COD_STATO = S.COD_MICROSTATO
       and F.COD_COMPARTO_ASSEGNATO is not null  
       and f.today_flg = '1' 
       group by F.COD_GRUPPO_SUPER
       --v5.2 gestisco i Non Outsourcing come stati non gestiti!
       having max(decode(f.flg_outsourcing, 'Y', S.FLG_STATO_CHK,null)) is null
      minus --mm20121112 escludo le posizioni in GB
       select COD_GRUPPO_SUPER
       from t_mcre0_all_data f,  t_mcre0_app_gb_gestione g
       where  f.cod_abi_cartolarizzato = g.cod_abi_cartolarizzato
       and f.cod_ndg = g.cod_ndg 
       and g.flg_stato = 1
)     ','ALL','1',to_date('15-GEN-2014 18:21:51','DD-MON-YYYY HH24:MI:SS'),'(cod_comparto_assegnato, id_utente, dta_utente_assegnato): disassegna_stati_non_gestiti');