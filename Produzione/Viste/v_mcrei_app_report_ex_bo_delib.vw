/* Formatted on 17/06/2014 18:08:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_REPORT_EX_BO_DELIB
(
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_PROTOCOLLO_DELIBERA,
   COD_MACROTIPOLOGIA_DELIB,
   DESC_MACROTIPOLOGIA,
   COD_FASE_MICROTIPOLOGIA,
   COD_MICROTIPOLOGIA_DELIB,
   DESC_MICROTIPOLOGIA,
   COD_FASE_DELIBERA,
   COD_CAUSA_CHIUS_DELIBERA,
   COD_FILIALE_DELIBERA,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA,
   DTA_SCADENZA_TRANSAZ,
   DTA_CONFERMA_DELIBERA,
   DTA_LAST_UPD_DELIBERA,
   DTA_DELIBERA,
   COD_MATRICOLA_INSERENTE,
   OD_CALCOLATO,
   COD_ORGANO_DELIBERANTE,
   COD_PROTOCOLLO_DELIBERA_COL,
   COD_TIPO_TRANSAZIONE,
   COD_COMPARTO_ASSEGNATO,
   DESC_NOTE,
   DESC_NOTE_DELIBERE_ANNULLATE,
   DESC_GRUPPO_ECONOMICO,
   COD_FILIALE,
   COD_PROTOCOLLO_PACCHETTO,
   VAL_ESP_LORDA,
   VAL_ESP_LORDA_CAPITALE,
   VAL_ESP_LORDA_MORA,
   VAL_ESP_NETTA_ANTE_DELIB,
   VAL_ESP_NETTA_POST_DELIB,
   VAL_UTI_FIRMA_SCSB,
   VAL_UTI_SOSTI_SCSB,
   VAL_RDV_QC_ANTE_DELIB,
   VAL_RDV_QC_DELIBERATA,
   VAL_RDV_QC_PROGRESSIVA,
   VAL_RDV_QUOTA_MORA,
   VAL_RDV_PREGR_FI,
   RDV_DELIB_FIRMA,
   VAL_RDV_PROGR_FI,
   RDV_DERIVATI_ANTE_DELIB,
   RDV_DERIVATI_PROPOSTA,
   RDV_DERIVATI_PROGRESSIVA,
   VAL_PERC_RDV,
   VAL_RINUNCIA_DELIBERATA,
   VAL_RINUNCIA_PROPOSTA,
   VAL_RINUNCIA_CAPITALE,
   VAL_RINUNCIA_MORA,
   VAL_RINUNCIA_TOTALE,
   VAL_IMP_PERDITA,
   VAL_STRALCIO_QUOTA_CAP,
   VAL_STRALCIO_QUOTA_MORA
)
AS
   SELECT DISTINCT
          T.COD_SNDG,
          T.COD_ABI,
          T.COD_NDG,
          D.DESC_NOME_CONTROPARTE,
          COD_PROTOCOLLO_DELIBERA,
          COD_MACROTIPOLOGIA_DELIB,
          T2.DESC_MACROTIPOLOGIA,
          COD_FASE_MICROTIPOLOGIA,
          COD_MICROTIPOLOGIA_DELIB,
          T1.DESC_MICROTIPOLOGIA,
          COD_FASE_DELIBERA,
          COD_CAUSA_CHIUS_DELIBERA,
          COD_FILIALE_DELIBERA,
          D.DTA_DECORRENZA_STATO,
          T.DTA_SCADENZA,
          DTA_SCADENZA_TRANSAZ,
          DTA_CONFERMA_DELIBERA,
          DTA_LAST_UPD_DELIBERA,
          DTA_DELIBERA,
          COD_MATRICOLA_INSERENTE,
          NVL (COD_ORGANO_CALCOLATO, COD_ORGANO_DELIBERANTE) AS OD_CALCOLATO,
          COD_ORGANO_DELIBERANTE,
          COD_PROTOCOLLO_DELIBERA_COL,
          COD_TIPO_TRANSAZIONE,
          D.COD_COMPARTO_ASSEGNATO,
          REPLACE (
             REPLACE (REPLACE (DESC_NOTE, CHR (13), ' '), CHR (10), ' '),
             ';',
             '.')
             AS DESC_NOTE,
          DESC_NOTE_DELIBERE_ANNULLATE,
          D.DESC_GRUPPO_ECONOMICO,
          D.COD_FILIALE,
          COD_PROTOCOLLO_PACCHETTO,
          VAL_ESP_LORDA,
          VAL_ESP_LORDA_CAPITALE,
          VAL_ESP_LORDA_MORA,
          VAL_ESP_NETTA_ANTE_DELIB,
          VAL_ESP_NETTA_POST_DELIB,
          VAL_UTI_FIRMA_SCSB,
          VAL_UTI_SOSTI_SCSB,
          VAL_RDV_QC_ANTE_DELIB,
          VAL_RDV_QC_DELIBERATA,
          VAL_RDV_QC_PROGRESSIVA,
          VAL_RDV_QUOTA_MORA,
          VAL_RDV_PREGR_FI,
          (NVL (VAL_RDV_PROGR_FI, 0) - NVL (VAL_RDV_PREGR_FI, 0))
             rdv_delib_firma,
          VAL_RDV_PROGR_FI,
          TO_NUMBER (NULL) AS RDV_DERIVATI_ANTE_DELIB,
          TO_NUMBER (NULL) AS RDV_DERIVATI_PROPOSTA,
          TO_NUMBER (NULL) AS RDV_DERIVATI_PROGRESSIVA,
          VAL_PERC_RDV,
          VAL_RINUNCIA_DELIBERATA,
          VAL_RINUNCIA_PROPOSTA,
          VAL_RINUNCIA_CAPITALE,
          VAL_RINUNCIA_MORA,
          VAL_RINUNCIA_TOTALE,
          VAL_IMP_PERDITA,
          VAL_STRALCIO_QUOTA_CAP,
          VAL_STRALCIO_QUOTA_MORA
     FROM T_MCREI_APP_DELIBERE T,
          T_MCRE0_APP_ALL_DATA D,
          T_MCREI_CL_TIPOLOGIE T1,
          T_MCREI_CL_TIPOLOGIE T2
    WHERE     T.COD_ABI = D.COD_ABI_CARTOLARIZZATO
          AND T.COD_NDG = D.COD_NDG
          AND D.flg_Active = '1'
          AND T.FLG_ATTIVA = '1'
          AND COD_FASE_DELIBERA != 'AN'
          AND FLG_NO_DELIBERA = 0
          -- AND DTA_CONFERMA_DELIBERA IS NOT NULL
          AND COD_TIPO_PACCHETTO = 'M'
          AND COD_MICROTIPOLOGIA_DELIB = T1.COD_MICROTIPOLOGIA(+)
          AND COD_MACROTIPOLOGIA_DELIB = T2.COD_MACROTIPOLOGIA(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_REPORT_EX_BO_DELIB TO MCRE_USR;
