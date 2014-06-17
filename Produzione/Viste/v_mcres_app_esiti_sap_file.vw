/* Formatted on 17/06/2014 18:10:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ESITI_SAP_FILE
(
   LINE,
   COD_AUTORIZZAZIONE
)
AS
   SELECT REPLACE (
                RPAD (NVL (ID_FLUSSO_SAP, ' '), 12, ' ')
             || RPAD (NVL (COD_AUTORIZZAZIONE, ' '), 16, ' ')
             || RPAD (NVL (COD_PART_IVA, ' '), 11, ' ')
             || RPAD (NVL (COD_FISCALE, ' '), 16, ' ')
             || RPAD (NVL (VAL_RAG_SOCIALE, ' '), 50, ' ')
             || RPAD (NVL (VAL_TIPO_FLUSSO, ' '), 4, ' ')
             || RPAD (NVL (VAL_TIPO_DOC, ' '), 4, ' ')
             || RPAD (NVL (TO_CHAR (DTA_RIC_FATTURA, 'YYYYMMDD'), ' '),
                      8,
                      ' ')
             || RPAD (NVL (VAL_RIF_FATTURA, ' '), 16, ' ')
             || RPAD (NVL (VAL_STATO_ACQ, ' '), 20, ' ')
             || RPAD (NVL (VAL_NOTE, ' '), 150, ' '),
             CHR (10),
             ' ')
             line,
          COD_AUTORIZZAZIONE
     FROM v_mcres_app_esiti_sap a
    WHERE     cod_esito = 0
          AND EXISTS
                 (SELECT DISTINCT 1
                    FROM t_mcres_app_sp_spese s
                   WHERE     s.cod_autorizzazione = a.cod_autorizzazione
                         AND flg_source = 'ITF')
          AND flg_inviato_itf = 0;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ESITI_SAP_FILE TO MCRE_USR;
