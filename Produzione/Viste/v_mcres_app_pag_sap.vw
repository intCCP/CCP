/* Formatted on 17/06/2014 18:10:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PAG_SAP
(
   COD_TIPO_RECORD,
   COD_PROGRESSIVO,
   COD_SISTEMA,
   VAL_MANDANTE,
   COD_AUTORIZZAZIONE,
   VAL_SOCIETA,
   VAL_ESERCIZIO,
   VAL_TIPO_REGISTRAZIONE,
   COD_NUMERO_FATTURA,
   COD_REGISTRAZIONE_FATTURA,
   DTA_FATTURA,
   DTA_REGISTRAZIONE_FATTURA,
   VAL_CONDIZIONI_PAGAMENTO,
   COD_TIPO_PAGAMENTO,
   COD_FORNITORE_EMITTENTE,
   VAL_CODICE_FISCALE,
   VAL_PARTITA_IVA,
   DTA_PAGAMENTO,
   VAL_DOC_PAREGGIO,
   VAL_ESERCIZIO_DOC_PAREGGIO,
   VAL_TIPO_DOC_PAREGGIO,
   VAL_ID_PAGAMENTO,
   VAL_IBAN,
   FLG_STORNO,
   VAL_N_DATREG,
   VAL_N_DTCONTAB,
   VAL_BOLLETTINO_POSTALE,
   VAL_ESITO_PAGAMENTO,
   FLG_INVIATO_ITF,
   COD_ESITO,
   DESC_ESITO,
   DTA_INVIO_SAP
)
AS
   SELECT COD_TIPO_RECORD,
          COD_PROGRESSIVO,
          COD_SISTEMA,
          VAL_MANDANTE,
          COD_AUTORIZZAZIONE,
          VAL_SOCIETA,
          VAL_ESERCIZIO,
          VAL_TIPO_REGISTRAZIONE,
          COD_NUMERO_FATTURA,
          COD_REGISTRAZIONE_FATTURA,
          DTA_FATTURA,
          DTA_REGISTRAZIONE_FATTURA,
          VAL_CONDIZIONI_PAGAMENTO,
          COD_TIPO_PAGAMENTO,
          COD_FORNITORE_EMITTENTE,
          VAL_CODICE_FISCALE,
          VAL_PARTITA_IVA,
          DTA_PAGAMENTO,
          VAL_DOC_PAREGGIO,
          VAL_ESERCIZIO_DOC_PAREGGIO,
          VAL_TIPO_DOC_PAREGGIO,
          VAL_ID_PAGAMENTO,
          VAL_IBAN,
          FLG_STORNO,
          VAL_N_DATREG,
          VAL_N_DTCONTAB,
          VAL_BOLLETTINO_POSTALE,
          VAL_ESITO_PAGAMENTO,
          flg_inviato_itf,
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
                                     FROM t_mcres_app_pag_sap s,
                                          (  SELECT *
                                               FROM T_MCRES_APP_CHK_INTERF_SAP i
                                           ORDER BY val_priority) c) a) b) cc
            WHERE     val_min_priority = val_priority
                  AND val_max_esito = cod_esito) ss;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_PAG_SAP TO MCRE_USR;
