/* Formatted on 21/07/2014 18:43:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STATOWI_SAP
(
   COD_AUTORIZZAZIONE,
   COD_DOCUMENTO_RIF,
   COD_FORNITORE,
   COD_MANDANTE,
   COD_STATO,
   COD_TIPO_FLUSSO,
   DTA_DOCUMENTO,
   DTA_INIZIO_VAL,
   DTA_INVIATO_ITF,
   DTA_RICEZIONE_FATTURA,
   DTA_TMST_ELABORAZIONE,
   FLG_INVIATO_ITF,
   VAL_CODICE_FISCALE,
   VAL_GRUPPO_UTENTI_R3,
   VAL_IMPORTO,
   VAL_PARTITA_IVA,
   VAL_RAGIONE_SOCIALE,
   VAL_SOURCE,
   VAL_NOTE,
   FLG_BLOCCO_PAG,
   COD_ESITO,
   DESC_ESITO,
   DTA_INVIO_SAP
)
AS
   SELECT COD_AUTORIZZAZIONE,
          COD_DOCUMENTO_RIF,
          COD_FORNITORE,
          COD_MANDANTE,
          COD_STATO,
          COD_TIPO_FLUSSO,
          DTA_DOCUMENTO,
          DTA_INIZIO_VAL,
          DTA_INVIATO_ITF,
          DTA_RICEZIONE_FATTURA,
          DTA_TMST_ELABORAZIONE,
          FLG_INVIATO_ITF,
          VAL_CODICE_FISCALE,
          VAL_GRUPPO_UTENTI_R3,
          VAL_IMPORTO,
          VAL_PARTITA_IVA,
          VAL_RAGIONE_SOCIALE,
          VAL_SOURCE,
          VAL_NOTE,
          FLG_BLOCCO_PAG,
          DECODE (cod_esito, 0, 0, id_regola) cod_esito,
          CASE
             WHEN cod_esito = 0
             THEN
                NULL
             ELSE
                (SELECT desc_regola
                   FROM t_mcres_app_chk_interf_sap s
                  WHERE s.id_regola = ss.id_regola AND flg_attiva = 1)
          END
             desc_esito,
          (SELECT dta_invio_pagamento
             FROM t_mcres_app_sp_spese w
            WHERE w.COD_AUTORIZZAZIONE = ss.COD_AUTORIZZAZIONE)
             dta_invio_sap
     FROM (SELECT cc.*
             FROM (SELECT b.*,
                          MAX (cod_esito)
                             OVER (PARTITION BY cod_autorizzazione)
                             val_max_esito
                     FROM (SELECT a.*,
                                  MIN (
                                     val_priority)
                                  OVER (
                                     PARTITION BY cod_autorizzazione,
                                                  cod_esito)
                                     val_min_priority
                             FROM (SELECT s.*,
                                          id_regola,
                                          val_priority,
                                          CASE
                                             WHEN s.FLG_INVIATO_ITF = 1
                                             THEN
                                                0
                                             ELSE
                                                CASE
                                                   WHEN PKG_MCRES_FUNZIONI_PORTALE.FNC_CHK_INTERF_SAP (
                                                           id_regola,
                                                           s.cod_autorizzazione) =
                                                           1
                                                   THEN
                                                      1
                                                   ELSE
                                                      0
                                                END
                                          END
                                             cod_esito
                                     FROM t_mcres_app_STATOWI_SAP s,
                                          (  SELECT *
                                               FROM T_MCRES_APP_CHK_INTERF_SAP i
                                              WHERE     FLG_ATTIVA = 1
                                                    AND val_source = 'WI_SAP'
                                           ORDER BY val_priority) c) a) b) cc
            WHERE     val_min_priority = val_priority
                  AND val_max_esito = cod_esito) ss;
