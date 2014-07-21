/* Formatted on 21/07/2014 18:42:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PAG_SAP_OLD
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
   COD_OPERATORE_INS_UPD,
   DTA_INS,
   DTA_UPD,
   FLG_REGOLA1,
   FLG_REGOLA2,
   DESC_REGOLA1,
   DESC_REGOLA2
)
AS
   SELECT ss."COD_TIPO_RECORD",
          ss."COD_PROGRESSIVO",
          ss."COD_SISTEMA",
          ss."VAL_MANDANTE",
          ss."COD_AUTORIZZAZIONE",
          ss."VAL_SOCIETA",
          ss."VAL_ESERCIZIO",
          ss."VAL_TIPO_REGISTRAZIONE",
          ss."COD_NUMERO_FATTURA",
          ss."COD_REGISTRAZIONE_FATTURA",
          ss."DTA_FATTURA",
          ss."DTA_REGISTRAZIONE_FATTURA",
          ss."VAL_CONDIZIONI_PAGAMENTO",
          ss."COD_TIPO_PAGAMENTO",
          ss."COD_FORNITORE_EMITTENTE",
          ss."VAL_CODICE_FISCALE",
          ss."VAL_PARTITA_IVA",
          ss."DTA_PAGAMENTO",
          ss."VAL_DOC_PAREGGIO",
          ss."VAL_ESERCIZIO_DOC_PAREGGIO",
          ss."VAL_TIPO_DOC_PAREGGIO",
          ss."VAL_ID_PAGAMENTO",
          ss."VAL_IBAN",
          ss."FLG_STORNO",
          ss."VAL_N_DATREG",
          ss."VAL_N_DTCONTAB",
          ss."VAL_BOLLETTINO_POSTALE",
          ss."VAL_ESITO_PAGAMENTO",
          ss."COD_OPERATORE_INS_UPD",
          ss."DTA_INS",
          ss."DTA_UPD",
          ss."FLG_REGOLA1",
          ss."FLG_REGOLA2",
          CASE
             WHEN flg_regola1 = 0
             THEN
                NULL
             ELSE
                (SELECT desc_regola
                   FROM t_mcres_app_chk_interf_sap
                  WHERE id_regola = 1 AND flg_attiva = 1)
          END
             desc_regola1,
          CASE
             WHEN flg_regola2 = 0
             THEN
                NULL
             ELSE
                (SELECT desc_regola
                   FROM t_mcres_app_chk_interf_sap
                  WHERE id_regola = 2 AND flg_attiva = 1)
          END
             desc_regola2
     FROM (SELECT s.*,
                  PKG_MCRES_FUNZIONI_PORTALE.FNC_CHK_INTERF_SAP (
                     1,
                     s.cod_autorizzazione)
                     flg_regola1,
                  PKG_MCRES_FUNZIONI_PORTALE.FNC_CHK_INTERF_SAP (
                     2,
                     s.cod_autorizzazione)
                     flg_regola2
             FROM t_mcres_app_pag_sap s) ss;
