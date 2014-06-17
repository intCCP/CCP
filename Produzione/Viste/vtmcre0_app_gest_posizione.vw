/* Formatted on 17/06/2014 18:16:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_GEST_POSIZIONE
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_MACROSTATO,
   COD_STATO_RISCHIO,
   COD_MACROSTATO_DESTINAZIONE,
   NOTE_CLASSIFICAZIONE,
   DTA_INS,
   FLG_LETTURA_VERBALE,
   DTA_UPD_WORKFLOW,
   FLG_WORKFLOW,
   FLG_DELETE,
   DTA_DELETE,
   DTA_SCADENZA_PROROGA,
   MOTIVO_PROROGA
)
AS
   SELECT ad.cod_abi_cartolarizzato,
          ad.cod_ndg,
          ad.cod_sndg,
          p.cod_macrostato,
          --IN = gestione incagli; RIO = gestione RIO; SC = gestione sconfini
          ad.cod_stato AS cod_stato_rischio,
          --stato della posizione al momento della compilazione del box di classificazione
          p.cod_macrostato_destinazione,
          --stato impostato come destinazione della classificazione
          p.note_classificazione,
          --commenti alla classificazione
          p.dta_ins,
          --data di inserimento dell'anomalia
          p.flg_lettura_verbale,
          --vale 'N' se non è stato letto il verbale, vale 'Y' altrimenti
          p.dta_upd_workflow,
          --indica la data di conferma della prima sezione della gestione (data conferma delle anomalie)
          p.flg_workflow,
          --indica lo step di lavorazione della scheda di gestione della posizione
          p.flg_delete,
          --vale 'N' se l'anomalia e' valida; vale 'Y' dopo la cancellazione (sempre e solo logica) dell'anomalia
          p.dta_delete,
          --data di cancellazione (sempre e solo logica) dell'anomalia
          DECODE (NVL (num_proroghe, 0),
                  0, SYSDATE + ad.val_gg_prima_proroga,
                  SYSDATE + ad.val_gg_seconda_proroga)
             dta_scadenza_proroga,
          p.motivo_proroga
     FROM t_mcre0_app_gest_posizione p,
          vtmcre0_app_upd_fields ad,
          (  SELECT cod_abi_cartolarizzato, cod_ndg, COUNT (*) AS num_proroghe
               FROM t_mcre0_app_rio_proroghe p
              WHERE flg_storico = '1' AND flg_esito = '1'
           GROUP BY cod_abi_cartolarizzato, cod_ndg) pr
    WHERE     ad.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato
          AND ad.cod_ndg = p.cod_ndg
          AND ad.today_flg = '1'
          AND ad.cod_abi_cartolarizzato = pr.cod_abi_cartolarizzato(+)
          AND ad.cod_ndg = pr.cod_ndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_GEST_POSIZIONE TO MCRE_USR;
