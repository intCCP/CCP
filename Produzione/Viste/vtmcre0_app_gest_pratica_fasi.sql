/* Formatted on 17/06/2014 18:16:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_GEST_PRATICA_FASI
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_PRAT_FASE,
   ID_TIPOLOGIA_PRATICA,
   ID_FASE_GESTIONE,
   ID_AZIONE,
   DTA_INS,
   DTA_UPD,
   DTA_SCADENZA,
   COD_STATO_RISCHIO,
   FLG_ESITO_POSITIVO,
   FLG_COMPLETATA,
   NOTE,
   FLG_DELETE,
   DTA_DELETE
)
AS
   SELECT ad.cod_abi_cartolarizzato,
          ad.cod_ndg,
          NULL AS cod_sndg,
          ad.cod_gruppo_economico,
          pf.cod_macrostato, --corretto 27 marzo --IN = gestione incagli; RIO = gestione RIO; SC = gestione sconfini
          pf.cod_prat_fase, --valore incrementale (serve per la generazione del PDF)
          pf.id_tipologia_pratica, --tipologia di pratica (configurate sulla tabella T_MCRE0_CL_RIO da trasformare in T_MCRE0_CL_GEST)
          pf.id_fase_gestione, --fase di gestione (configurate sulla tabella T_MCRE0_CL_RIO da trasformare in T_MCRE0_CL_GEST)
          pf.id_azione, --azione (configurate sulla tabella T_MCRE0_CL_RIO_AZIONI - azioni pre-estensione BdT)
          pf.dta_ins,               --data di inserimento della pratica / fase
          pf.dta_upd,      --data di ultimo aggiornamento della pratica / fase
          pf.dta_scadenza,    --data di scadenza della pratica / fase inserita
          pf.cod_stato_rischio, --stato della posizione al momento dell'inserimento della pratica / fase
          pf.flg_esito_positivo, --vale 'N' se la pratica / fase ha esito negativo, vale 'Y' se la pratica / fase ha esito positivo
          pf.flg_completata, --vale 'N' se la pratica / fase e ancora in corso, vale 'Y' se la pratica / fase e completata
          pf.note,              --note a corredo della pratica / fase inserita
          pf.flg_delete, --vale 'N' se la pratica / fase e' valida; vale 'Y' dopo la cancellazione (sempre e solo logica) della pratica / fase
          pf.dta_delete --data di cancellazione (sempre e solo logica) della pratica / fase
     FROM T_MCRE0_APP_GEST_PRATICA_FASI pf, T_MCRE0_APP_ALL_DATA_DAY ad
    WHERE     ad.cod_abi_cartolarizzato = pf.cod_abi_cartolarizzato
          AND ad.cod_ndg = pf.cod_ndg
          AND ad.today_flg = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_GEST_PRATICA_FASI TO MCRE_USR;
