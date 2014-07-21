/* Formatted on 21/07/2014 18:42:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PAG_SAP_FILE
(
   LINE,
   COD_AUTORIZZAZIONE
)
AS
   SELECT REPLACE (
                RPAD (NVL (COD_TIPO_RECORD, ' '), 2, ' ')
             || RPAD (NVL (COD_PROGRESSIVO, ' '), 10, ' ')
             || RPAD (NVL (COD_SISTEMA, ' '), 8, ' ')
             || RPAD (NVL (VAL_MANDANTE, ' '), 3, ' ')
             || RPAD (NVL (COD_AUTORIZZAZIONE, ' '), 16, ' ')
             || RPAD (NVL (VAL_SOCIETA, ' '), 4, ' ')
             || RPAD (NVL (VAL_ESERCIZIO, ' '), 4, ' ')
             || RPAD (NVL (VAL_TIPO_REGISTRAZIONE, ' '), 1, ' ')
             || RPAD (NVL (COD_NUMERO_FATTURA, ' '), 16, ' ')
             || RPAD (NVL (COD_REGISTRAZIONE_FATTURA, ' '), 10, ' ')
             || RPAD (NVL (TO_CHAR (DTA_FATTURA, 'YYYYMMDD'), ' '), 8, ' ')
             || RPAD (
                   NVL (TO_CHAR (DTA_REGISTRAZIONE_FATTURA, 'YYYYMMDD'), ' '),
                   8,
                   ' ')
             || RPAD (NVL (VAL_CONDIZIONI_PAGAMENTO, ' '), 4, ' ')
             || RPAD (NVL (COD_TIPO_PAGAMENTO, ' '), 1, ' ')
             || RPAD (NVL (COD_FORNITORE_EMITTENTE, ' '), 10, ' ')
             || RPAD (NVL (VAL_CODICE_FISCALE, ' '), 16, ' ')
             || RPAD (NVL (VAL_PARTITA_IVA, ' '), 11, ' ')
             || RPAD (NVL (TO_CHAR (DTA_PAGAMENTO, 'YYYYMMDD'), ' '), 8, ' ')
             || RPAD (NVL (VAL_DOC_PAREGGIO, ' '), 10, ' ')
             || RPAD (NVL (VAL_ESERCIZIO_DOC_PAREGGIO, ' '), 4, ' ')
             || RPAD (NVL (VAL_TIPO_DOC_PAREGGIO, ' '), 2, ' ')
             || RPAD (NVL (VAL_ID_PAGAMENTO, ' '), 35, ' ')
             || RPAD (NVL (VAL_IBAN, ' '), 35, ' ')
             || RPAD (NVL (FLG_STORNO, ' '), 1, ' ')
             || RPAD (NVL (VAL_N_DATREG, ' '), 8, ' ')
             || RPAD (NVL (VAL_N_DTCONTAB, ' '), 8, ' ')
             || RPAD (NVL (VAL_BOLLETTINO_POSTALE, ' '), 1, ' ')
             || RPAD (NVL (VAL_ESITO_PAGAMENTO, ' '), 2, ' '),
             CHR (10),
             ' ')
             line,
          COD_AUTORIZZAZIONE
     FROM v_mcres_app_pag_sap a
    WHERE     cod_esito = 0
          AND EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE     s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source = 'ITF')
          AND flg_inviato_itf = 0;
