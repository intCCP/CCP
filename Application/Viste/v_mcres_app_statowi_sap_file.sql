/* Formatted on 21/07/2014 18:43:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_STATOWI_SAP_FILE
(
   LINE,
   COD_AUTORIZZAZIONE
)
AS
   SELECT REPLACE (
                RPAD (NVL (cod_Mandante, ' '), 3, ' ')
             || RPAD (NVL (COD_AUTORIZZAZIONE, ' '), 16, ' ')
             || RPAD (NVL (VAL_SOurce, ' '), 1, ' ')
             || RPAD (NVL (TO_CHAR (dta_inizio_val, 'YYYYMMDD'), ' '),
                      8,
                      ' ')
             || RPAD (NVL (dta_tmst_elaborazione, ' '), 6, ' ')
             || RPAD (NVL (cod_stato, ' '), 2, ' ')
             || RPAD (NVL (val_Gruppo_utenti_R3, ' '), 15, ' ')
             || RPAD (NVL (cod_Tipo_flusso, ' '), 4, ' ')
             || RPAD (NVL (Cod_Fornitore, ' '), 10, ' ')
             || RPAD (NVL (val_Partita_IVA, ' '), 16, ' ')
             || RPAD (NVL (val_Codice_fiscale, ' '), 16, ' ')
             || RPAD (NVL (val_Ragione_sociale, ' '), 35, ' ')
             || RPAD (NVL (cod_documento_rif, ' '), 16, ' ')
             || RPAD (NVL (val_Importo, ' '), 13, ' ')
             || RPAD (NVL (TO_CHAR (dta_ricezione_fattura, 'YYYYMMDD'), ' '),
                      8,
                      ' ')
             || RPAD (NVL (TO_CHAR (Dta_documento, 'YYYYMMDD'), ' '), 8, ' ')
             || RPAD (NVL (val_note, ' '), 150, ' ')
             || RPAD (NVL (flg_blocco_pag, ' '), 1, ' '),
             CHR (10),
             ' ')
             line,
          COD_AUTORIZZAZIONE
     FROM v_mcres_app_statowi_sap a
    WHERE     cod_esito = 0
          AND EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE     s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source = 'ITF')
          AND flg_inviato_itf = 0;
