/* Formatted on 21/07/2014 18:33:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_ANOMALIE
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_ANOMALIA,
   DESC_ANOMALIA,
   COD_STATO_RISCHIO,
   DTA_INS,
   FLG_GRUPPO_ECONOMICO,
   FLG_DELETE,
   DTA_DELETE
)
AS
   SELECT ad.cod_abi_cartolarizzato,
          ad.cod_ndg,
          ad.cod_sndg,
          ad.cod_gruppo_economico,
          ga.cod_macrostato, ---corretto 27 marzo --IN = gestione incagli; RIO = gestione RIO; SC = gestione sconfini
          ga.cod_anomalia, --valore incrementale (serve per la generazione del PDF)
          ga.desc_anomalia,  --descrizione dell'anomalia impostata dall'utente
          ga.cod_stato_rischio, --stato della posizione al momento dell'inserimento dell'anomalia
          ga.dta_ins,                      --data di inserimento dell'anomalia
          ga.flg_gruppo_economico, --vale 'N' se l'anomalia e a livello di singolo cliente, vale 'Y' se l'anomalia e a livello di gruppo economico
          ga.flg_delete, --vale 'N' se l'anomalia e' valida; vale 'Y' dopo la cancellazione (sempre e solo logica) dell'anomalia
          ga.dta_delete --data di cancellazione (sempre e solo logica) dell'anomalia
     FROM t_mcre0_app_gest_anomalie ga, t_mcre0_app_all_data ad
    WHERE     ad.cod_abi_cartolarizzato = ga.cod_abi_cartolarizzato
          AND ad.cod_ndg = ga.cod_ndg
          AND ad.today_flg = '1';
