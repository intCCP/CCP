/* Formatted on 17/06/2014 18:07:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE_ASS_FILE
(
   LINE
)
AS
   SELECT    'COD_ABI'
          || ';'
          || 'COD_NDG'
          || ';'
          || 'COD_SNDG'
          || ';'
          || 'COD_PROTOCOLLO_DELIBERA'
          || ';'
          || 'DESC_NOME_CONTROPARTE'
          || ';'
          || 'GRUPPO_ECONOMICO'
          || ';'
          || 'COD_FILIALE_DELIBERA'
          || ';'
          || 'FILIALE_DELIBERA'
          || ';'
          || 'COD_AREA_DELIBERA'
          || ';'
          || 'AREA_DELIBERA'
          || ';'
          || 'STATO_ATTUALE'
          || ';'
          || 'DTA_DECORRENZA_STATO'
          || ';'
          || 'TIPO_DELIBERA'
          || ';'
          || 'FASE_DELIBERA'
          || ';'
          || 'COD_ORGANO_DELIBERANTE'
          || ';'
          || 'DTA_DELIBERA'
          || ';'
          || 'DTA_SCADENZA'
          || ';'
          || 'DATA_AGGIORNAMNETO'
          || ';'
          || 'COD_MATRICOLA_INSERENTE'
          || ';'
          || 'NOME_INSERENTE'
          || ';'
          || 'NOTE'
          || ';'
          || 'NOTE_DEL_ANNULLATE'
          || ';'
          || 'NOTE_PROP_ANNULLATE'
          || ';'
          || 'ESP_LORDA'
          || ';'
          || 'ESP_LORDA_CAPITALE'
          || ';'
          || 'ESP_LORDA_MORA'
          || ';'
          || 'RDV_QC_ANTE_DELIB'
          || ';'
          || 'ESP_NETTA_ANTE_DELIB'
          || ';'
          || 'RDV_QC_DELIBERATA'
          || ';'
          || 'RDV_QC_PROGRESSIVA'
          || ';'
          || 'ESP_NETTA_POST_DELIB'
          || ';'
          || 'PERC_RDV'
          || ';'
          || 'PARTE_CORRELATA'
          || ';'
          || 'PARTE_CORRELATA_IAS'
          || ';'
          || 'ARTICOLO_136'
          || ';'
          || 'SOGGETTO_COLLEGATO'
          || ';'
          || 'DELIBERA_FORZATA'
          || ';'
          || 'TIPOLOGIA_GESTIONE'
          || ';'
          || 'COD_TIP_RISTR'
     FROM DUAL
   UNION ALL
   SELECT REPLACE (
                NVL (COD_ABI, '')
             || ';'
             || NVL (COD_NDG, '')
             || ';'
             || NVL (COD_SNDG, '')
             || ';'
             || NVL (COD_PROTOCOLLO_DELIBERA, '')
             || ';'
             || NVL (DESC_NOME_CONTROPARTE, '')
             || ';'
             || NVL (GRUPPO_ECONOMICO, '')
             || ';'
             || NVL (COD_FILIALE_DELIBERA, '')
             || ';'
             || NVL (FILIALE_DELIBERA, '')
             || ';'
             || NVL (COD_AREA_DELIBERA, '')
             || ';'
             || NVL (AREA_DELIBERA, '')
             || ';'
             || NVL (STATO_ATTUALE, '')
             || ';'
             || NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (TIPO_DELIBERA, '')
             || ';'
             || NVL (FASE_DELIBERA, '')
             || ';'
             || NVL (COD_ORGANO_DELIBERANTE, '')
             || ';'
             || NVL (TO_CHAR (DTA_DELIBERA, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (TO_CHAR (DTA_SCADENZA, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (TO_CHAR (DATA_AGGIORNAMNETO, 'DD/MM/YYYY'), '')
             || ';'
             || NVL (COD_MATRICOLA_INSERENTE, '')
             || ';'
             || NVL (NOME_INSERENTE, '')
             || ';'
             || NVL (REPLACE (NOTE, CHR (10), ''), '')
             || ';'
             || NVL (REPLACE (NOTE_DEL_ANNULLATE, CHR (10), ''), '')
             || ';'
             || NVL (REPLACE (NOTE_PROP_ANNULLATE, CHR (10), ''), '')
             || ';'
             || NVL (ESP_LORDA, '')
             || ';'
             || NVL (ESP_LORDA_CAPITALE, '')
             || ';'
             || NVL (ESP_LORDA_MORA, '')
             || ';'
             || NVL (RDV_QC_ANTE_DELIB, '')
             || ';'
             || NVL (ESP_NETTA_ANTE_DELIB, '')
             || ';'
             || NVL (RDV_QC_DELIBERATA, '')
             || ';'
             || NVL (RDV_QC_PROGRESSIVA, '')
             || ';'
             || NVL (ESP_NETTA_POST_DELIB, '')
             || ';'
             || NVL (PERC_RDV, '')
             || ';'
             || NVL (PARTE_CORRELATA, '')
             || ';'
             || NVL (PARTE_CORRELATA_IAS, '')
             || ';'
             || NVL (ARTICOLO_136, '')
             || ';'
             || NVL (SOGGETTO_COLLEGATO, '')
             || ';'
             || NVL (DELIBERA_FORZATA, '')
             || ';'
             || NVL (TIPOLOGIA_GESTIONE, '')
             || ';'
             || NVL (COD_TIP_RISTR, ''),
             CHR (10),
             '')
             AS LINE
     FROM V_MCREI_APP_DELIBERE_ASSUNTE;


GRANT SELECT ON MCRE_OWN.V_MCREI_APP_DELIBERE_ASS_FILE TO MCRE_USR;
