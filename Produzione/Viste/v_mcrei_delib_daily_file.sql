/* Formatted on 17/06/2014 18:08:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_DELIB_DAILY_FILE
(
   LINE
)
AS
   SELECT TO_CLOB (
                'SUPER NDG'
             || ';'
             || 'CODICE ABI'
             || ';'
             || 'NDG POSIZIONE IN INCAGLIO'
             || ';'
             || 'INTESTAZIONE'
             || ';'
             || 'NUMERO PROTOCOLLO DELIBERA'
             || ';'
             || 'MACROTIPOLOGIA DELIBERA'
             || ';'
             || 'DESC MACROTIPOLOGIA'
             || ';'
             || 'STATO MICROTIPOLOGIA DELIBERA'
             || ';'
             || 'MICROTIPOLOGIA DELIBERA'
             || ';'
             || 'DESC MICROTIPOLOGIA'
             || ';'
             || 'STATO DELIBERA'
             || ';'
             || 'CAUSALE CHIUSURA'
             || ';'
             || 'FILIALE DELIBERA'
             || ';'
             || 'DATA INCAGLIO'
             || ';'
             || 'DATA SCADENZA STATO DI RISCHIO'
             || ';'
             || 'DATA SCADENZA TRANSAZIONE'
             || ';'
             || 'DATA CONFERMA DELIBERA'
             || ';'
             || 'DATA DI ULTIMA MODIFICA'
             || ';'
             || 'DATA DELIBERA'
             || ';'
             || 'DENOM INSERENTE DELIBERA'
             || ';'
             || 'OD CALCOLATO'
             || ';'
             || 'OD DELIBERANTE'
             || ';'
             || 'PROTOCOLLO DELIBERA COLLEGATA'
             || ';'
             || 'TIPO TRANSAZIONE'
             || ';'
             || 'CODICE STRUTTURA COMPETENTE'
             || ';'
             || 'NOTE'
             || ';'
             || 'NOTE PER DELIBERE ANNULLATE'
             || ';'
             || 'DESCRIZIONE GRUPPO'
             || ';'
             || 'FILIALE'
             || ';'
             || 'NUMERO PROTOCOLLO PACCHETTO'
             || ';'
             || 'ESPOSIZIONE LORDA'
             || ';'
             || 'ESPOSIZIONE LORDA-CAPITALE'
             || ';'
             || 'ESPOSIZIONE LORDA DI CUI MORA'
             || ';'
             || 'ESP. NETTA ANTE DELIBERA'
             || ';'
             || 'ESP. NETTA POST DELIBERA'
             || ';'
             || 'ESPOSIZIONE FIRMA'
             || ';'
             || 'ESPOSIZIONE DERIVATI'
             || ';'
             || 'RDV QTA CAPITALE ANTE DELIB'
             || ';'
             || 'RDV QTA CAPITALE PROPOSTA'
             || ';'
             || 'RDV QUOTA CAPITALE PROGRESSIVA'
             || ';'
             || 'RDV QUOTA CAPITALE - MORA'
             || ';'
             || 'RDV DI FIRMA ANTE DELIB'
             || ';'
             || 'RDV DI FIRMA PROPOSTA'
             || ';'
             || 'RDV DI FIRMA PROGRESSIVA'
             || ';'
             || 'RDV DERIVATI ANTE DELIB'
             || ';'
             || 'RDV DERIVATI PROPOSTA'
             || ';'
             || 'RDV DERIVATI PROGRESSIVA'
             || ';'
             || '% RETTIFICA DI VALORE'
             || ';'
             || 'RINUNCIA DELIBERATA'
             || ';'
             || 'RINUNCIA PROPOSTA'
             || ';'
             || 'RINUNCIA CAPITALE'
             || ';'
             || 'RINUNCIA MORA'
             || ';'
             || 'RINUNCIA TOTALE'
             || ';'
             || 'PERDITA TOTALE'
             || ';'
             || 'STRALCI QUOTA CAPITALE'
             || ';'
             || 'STRALCI QUOTA MORA')
             AS LINE
     FROM DUAL
   UNION ALL
   SELECT TO_CLOB (
             REPLACE (
                (   NVL (COD_SNDG, '')
                 || ';'
                 || NVL (COD_ABI, '')
                 || ';'
                 || NVL (COD_NDG, '')
                 || ';'
                 || NVL (DESC_NOME_CONTROPARTE, '')
                 || ';'
                 || NVL (COD_PROTOCOLLO_DELIBERA, '')
                 || ';'
                 || NVL (COD_MACROTIPOLOGIA_DELIB, '')
                 || ';'
                 || NVL (DESC_MACROTIPOLOGIA, '')
                 || ';'
                 || NVL (COD_FASE_MICROTIPOLOGIA, '')
                 || ';'
                 || NVL (COD_MICROTIPOLOGIA_DELIB, '')
                 || ';'
                 || NVL (DESC_MICROTIPOLOGIA, '')
                 || ';'
                 || NVL (COD_FASE_DELIBERA, '')
                 || ';'
                 || NVL (COD_CAUSA_CHIUS_DELIBERA, '')
                 || ';'
                 || NVL (COD_FILIALE_DELIBERA, '')
                 || ';'
                 || NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (TO_CHAR (DTA_SCADENZA, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (TO_CHAR (DTA_SCADENZA_TRANSAZ, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (TO_CHAR (DTA_CONFERMA_DELIBERA, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (TO_CHAR (DTA_LAST_UPD_DELIBERA, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (TO_CHAR (DTA_DELIBERA, 'DD/MM/YYYY'), '')
                 || ';'
                 || NVL (COD_MATRICOLA_INSERENTE, '')
                 || ';'
                 || NVL (OD_CALCOLATO, '')
                 || ';'
                 || NVL (COD_ORGANO_DELIBERANTE, '')
                 || ';'
                 || NVL (COD_PROTOCOLLO_DELIBERA_COL, '')
                 || ';'
                 || NVL (COD_TIPO_TRANSAZIONE, '')
                 || ';'
                 || NVL (COD_COMPARTO_ASSEGNATO, '')
                 || ';'
                 || NVL (DESC_NOTE, '')
                 || ';'
                 || NVL (DESC_NOTE_DELIBERE_ANNULLATE, '')
                 || ';'
                 || NVL (DESC_GRUPPO_ECONOMICO, '')
                 || ';'
                 || NVL (COD_FILIALE, '')
                 || ';'
                 || NVL (COD_PROTOCOLLO_PACCHETTO, '')
                 || ';'
                 || NVL (TO_CHAR (VAL_ESP_LORDA, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_ESP_LORDA_CAPITALE, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_ESP_LORDA_MORA, '000000000000000'), '')
                 || ';'
                 || NVL (
                       TO_CHAR (VAL_ESP_NETTA_ANTE_DELIB, '000000000000000'),
                       '')
                 || ';'
                 || NVL (
                       TO_CHAR (VAL_ESP_NETTA_POST_DELIB, '000000000000000'),
                       '')
                 || ';'
                 || NVL (TO_CHAR (VAL_UTI_FIRMA_SCSB, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_UTI_SOSTI_SCSB, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_QC_ANTE_DELIB, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_QC_DELIBERATA, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_QC_PROGRESSIVA, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_QUOTA_MORA, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_PREGR_FI, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (RDV_DELIB_FIRMA, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RDV_PROGR_FI, '000000000000000'), '')
                 || ';'
                 || NVL (
                       TO_CHAR (RDV_DERIVATI_ANTE_DELIB, '000000000000000'),
                       '')
                 || ';'
                 || NVL (TO_CHAR (RDV_DERIVATI_PROPOSTA, '000000000000000'),
                         '')
                 || ';'
                 || NVL (
                       TO_CHAR (RDV_DERIVATI_PROGRESSIVA, '000000000000000'),
                       '')
                 || ';'
                 || NVL (TO_CHAR (VAL_PERC_RDV, '000000000000000'), '')
                 || ';'
                 || NVL (
                       TO_CHAR (VAL_RINUNCIA_DELIBERATA, '000000000000000'),
                       '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RINUNCIA_PROPOSTA, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RINUNCIA_CAPITALE, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RINUNCIA_MORA, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_RINUNCIA_TOTALE, '000000000000000'),
                         '')
                 || ';'
                 || NVL (TO_CHAR (VAL_IMP_PERDITA, '000000000000000'), '')
                 || ';'
                 || NVL (TO_CHAR (VAL_STRALCIO_QUOTA_CAP, '000000000000000'),
                         '')
                 || ';'
                 || NVL (
                       TO_CHAR (VAL_STRALCIO_QUOTA_MORA, '000000000000000'),
                       '')),
                CHR (10),
                ''))
             AS LINE
     FROM (SELECT * FROM V_MCREI_APP_REPORT_EX_BO_DELIB);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_DELIB_DAILY_FILE TO MCRE_USR;
