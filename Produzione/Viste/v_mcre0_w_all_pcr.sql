/* Formatted on 17/06/2014 18:06:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_ALL_PCR
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   GEGB_TOT_GAR,
   SCGB_TOT_GAR,
   GLGB_TOT_GAR,
   GEGB_UTI_CONSEGNE,
   GEGB_UTI_CONSEGNE_DT,
   GEGB_ACC_CONSEGNE,
   GEGB_ACC_CONSEGNE_DT,
   SCGB_UTI_CONSEGNE,
   SCGB_UTI_CONSEGNE_DT,
   SCGB_ACC_CONSEGNE,
   SCGB_ACC_CONSEGNE_DT,
   GLGB_UTI_CONSEGNE,
   GLGB_UTI_CONSEGNE_DT,
   GLGB_ACC_CONSEGNE,
   GLGB_ACC_CONSEGNE_DT,
   GEGB_UTI_SOSTITUZIONI,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_UTI_SOSTITUZIONI_DT,
   GEGB_UTI_MASSIMALI_DT,
   GEGB_UTI_RISCHI_INDIRETTI_DT,
   GEGB_ACC_SOSTITUZIONI_DT,
   GEGB_ACC_MASSIMALI_DT,
   GEGB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_SOSTITUZIONI,
   SCGB_UTI_MASSIMALI,
   SCGB_UTI_RISCHI_INDIRETTI,
   SCGB_ACC_SOSTITUZIONI,
   SCGB_ACC_MASSIMALI,
   SCGB_ACC_RISCHI_INDIRETTI,
   SCGB_UTI_SOSTITUZIONI_DT,
   SCGB_UTI_MASSIMALI_DT,
   SCGB_UTI_RISCHI_INDIRETTI_DT,
   SCGB_ACC_SOSTITUZIONI_DT,
   SCGB_ACC_MASSIMALI_DT,
   SCGB_ACC_RISCHI_INDIRETTI_DT,
   GLGB_UTI_SOSTITUZIONI,
   GLGB_UTI_MASSIMALI,
   GLGB_UTI_RISCHI_INDIRETTI,
   GLGB_ACC_SOSTITUZIONI,
   GLGB_ACC_MASSIMALI,
   GLGB_ACC_RISCHI_INDIRETTI,
   GLGB_UTI_SOSTITUZIONI_DT,
   GLGB_UTI_MASSIMALI_DT,
   GLGB_UTI_RISCHI_INDIRETTI_DT,
   GLGB_ACC_SOSTITUZIONI_DT,
   GLGB_ACC_MASSIMALI_DT,
   GLGB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_CASSA,
   SCGB_UTI_FIRMA,
   SCGB_ACC_CASSA,
   SCGB_ACC_FIRMA,
   SCGB_UTI_CASSA_BT,
   SCGB_UTI_CASSA_MLT,
   SCGB_UTI_SMOBILIZZO,
   SCGB_UTI_FIRMA_DT,
   SCGB_ACC_CASSA_BT,
   SCGB_ACC_CASSA_MLT,
   SCGB_ACC_SMOBILIZZO,
   SCGB_ACC_FIRMA_DT,
   GEGB_UTI_CASSA,
   GEGB_UTI_FIRMA,
   GEGB_ACC_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_SMOBILIZZO,
   GEGB_UTI_FIRMA_DT,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_ACC_FIRMA_DT,
   GLGB_UTI_CASSA,
   GLGB_UTI_FIRMA,
   GLGB_ACC_CASSA,
   GLGB_ACC_FIRMA,
   GLGB_UTI_CASSA_BT,
   GLGB_UTI_CASSA_MLT,
   GLGB_UTI_SMOBILIZZO,
   GLGB_UTI_FIRMA_DT,
   GLGB_ACC_CASSA_BT,
   GLGB_ACC_CASSA_MLT,
   GLGB_ACC_SMOBILIZZO,
   GLGB_ACC_FIRMA_DT,
   GB_DTA_RIFERIMENTO,
   GEGB_UTI_TOT,
   GEGB_ACC_TOT,
   GLGB_UTI_TOT,
   GLGB_ACC_TOT,
   SCGB_UTI_TOT,
   SCGB_ACC_TOT,
   GESB_ACC_CONSEGNE,
   GESB_ACC_CONSEGNE_DT,
   GESB_UTI_CONSEGNE,
   GESB_UTI_CONSEGNE_DT,
   GESB_UTI_SOSTITUZIONI,
   GESB_UTI_MASSIMALI,
   GESB_UTI_RISCHI_INDIRETTI,
   GESB_UTI_SOSTITUZIONI_DT,
   GESB_UTI_MASSIMALI_DT,
   GESB_UTI_RISCHI_INDIRETTI_DT,
   GESB_ACC_SOSTITUZIONI,
   GESB_ACC_MASSIMALI,
   GESB_ACC_RISCHI_INDIRETTI,
   GESB_ACC_SOSTITUZIONI_DT,
   GESB_ACC_MASSIMALI_DT,
   GESB_ACC_RISCHI_INDIRETTI_DT,
   GESB_UTI_CASSA,
   GESB_UTI_FIRMA,
   GESB_ACC_CASSA,
   GESB_ACC_FIRMA,
   GESB_UTI_CASSA_BT,
   GESB_UTI_CASSA_MLT,
   GESB_UTI_SMOBILIZZO,
   GESB_UTI_FIRMA_DT,
   GESB_ACC_CASSA_BT,
   GESB_ACC_CASSA_MLT,
   GESB_ACC_SMOBILIZZO,
   GESB_ACC_FIRMA_DT,
   GESB_TOT_GAR,
   GESB_DTA_RIFERIMENTO,
   GESB_ACC_TOT,
   GESB_UTI_TOT,
   SCSB_ACC_CONSEGNE,
   SCSB_ACC_CONSEGNE_DT,
   SCSB_UTI_CONSEGNE,
   SCSB_UTI_CONSEGNE_DT,
   SCSB_UTI_MASSIMALI,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_RISCHI_INDIRETTI,
   SCSB_UTI_MASSIMALI_DT,
   SCSB_UTI_SOSTITUZIONI_DT,
   SCSB_UTI_RISCHI_INDIRETTI_DT,
   SCSB_ACC_MASSIMALI,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_RISCHI_INDIRETTI,
   SCSB_ACC_MASSIMALI_DT,
   SCSB_ACC_SOSTITUZIONI_DT,
   SCSB_ACC_RISCHI_INDIRETTI_DT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_TOT,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA_BT,
   SCSB_UTI_CASSA_MLT,
   SCSB_UTI_SMOBILIZZO,
   SCSB_UTI_FIRMA_DT,
   SCSB_ACC_CASSA_BT,
   SCSB_ACC_CASSA_MLT,
   SCSB_ACC_SMOBILIZZO,
   SCSB_ACC_FIRMA_DT,
   SCSB_TOT_GAR,
   SCSB_DTA_RIFERIMENTO,
   GEGB_MAU,
   GLGB_MAU,
   SCGB_MAU,
   GB_VAL_MAU,
   FLG_FLUSSO_GB,
   FLG_FLUSSO_GE_SB,
   FLG_FLUSSO_SC_SB,
   SCGB_ID_DPER
)
AS
   SELECT DISTINCT
          FG.COD_ABI_ISTITUTO,
          FG.COD_ABI_CARTOLARIZZATO,
          FG.COD_NDG,
          FG.COD_SNDG,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_TOT_GAR
          END
             GEGB_TOT_GAR,
          GB.SCGB_TOT_GAR,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                gb.GLGB_TOT_GAR
          END
             GLGB_TOT_GAR,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_CONSEGNE
          END
             GEGB_UTI_CONSEGNE,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_CONSEGNE_DT
          END
             GEGB_UTI_CONSEGNE_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_CONSEGNE
          END
             GEGB_ACC_CONSEGNE,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_CONSEGNE_DT
          END
             GEGB_ACC_CONSEGNE_DT,
          GB.SCGB_UTI_CONSEGNE,
          GB.SCGB_UTI_CONSEGNE_DT,
          GB.SCGB_ACC_CONSEGNE,
          GB.SCGB_ACC_CONSEGNE_DT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_CONSEGNE
          END
             GLGB_UTI_CONSEGNE,
          GB.GLGB_UTI_CONSEGNE_DT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_CONSEGNE
          END
             GLGB_ACC_CONSEGNE,
          GB.GLGB_ACC_CONSEGNE_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_SOSTITUZIONI
          END
             GEGB_UTI_SOSTITUZIONI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_MASSIMALI
          END
             GEGB_UTI_MASSIMALI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_RISCHI_INDIRETTI
          END
             GEGB_UTI_RISCHI_INDIRETTI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_SOSTITUZIONI
          END
             GEGB_ACC_SOSTITUZIONI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_MASSIMALI
          END
             GEGB_ACC_MASSIMALI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_RISCHI_INDIRETTI
          END
             GEGB_ACC_RISCHI_INDIRETTI,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_SOSTITUZIONI_DT
          END
             GEGB_UTI_SOSTITUZIONI_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_MASSIMALI_DT
          END
             GEGB_UTI_MASSIMALI_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_RISCHI_INDIRETTI_DT
          END
             GEGB_UTI_RISCHI_INDIRETTI_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_SOSTITUZIONI_DT
          END
             GEGB_ACC_SOSTITUZIONI_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_MASSIMALI_DT
          END
             GEGB_ACC_MASSIMALI_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_RISCHI_INDIRETTI_DT
          END
             GEGB_ACC_RISCHI_INDIRETTI_DT,
          GB.SCGB_UTI_SOSTITUZIONI,
          GB.SCGB_UTI_MASSIMALI,
          GB.SCGB_UTI_RISCHI_INDIRETTI,
          GB.SCGB_ACC_SOSTITUZIONI,
          GB.SCGB_ACC_MASSIMALI,
          GB.SCGB_ACC_RISCHI_INDIRETTI,
          GB.SCGB_UTI_SOSTITUZIONI_DT,
          GB.SCGB_UTI_MASSIMALI_DT,
          GB.SCGB_UTI_RISCHI_INDIRETTI_DT,
          GB.SCGB_ACC_SOSTITUZIONI_DT,
          GB.SCGB_ACC_MASSIMALI_DT,
          GB.SCGB_ACC_RISCHI_INDIRETTI_DT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_SOSTITUZIONI
          END
             GLGB_UTI_SOSTITUZIONI,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_MASSIMALI
          END
             GLGB_UTI_MASSIMALI,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_RISCHI_INDIRETTI
          END
             GLGB_UTI_RISCHI_INDIRETTI,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_SOSTITUZIONI
          END
             GLGB_ACC_SOSTITUZIONI,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_MASSIMALI
          END
             GLGB_ACC_MASSIMALI,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_RISCHI_INDIRETTI
          END
             GLGB_ACC_RISCHI_INDIRETTI,
          GB.GLGB_UTI_SOSTITUZIONI_DT,
          GB.GLGB_UTI_MASSIMALI_DT,
          GB.GLGB_UTI_RISCHI_INDIRETTI_DT,
          GB.GLGB_ACC_SOSTITUZIONI_DT,
          GB.GLGB_ACC_MASSIMALI_DT,
          GB.GLGB_ACC_RISCHI_INDIRETTI_DT,
          GB.SCGB_UTI_CASSA,
          GB.SCGB_UTI_FIRMA,
          GB.SCGB_ACC_CASSA,
          GB.SCGB_ACC_FIRMA,
          GB.SCGB_UTI_CASSA_BT,
          GB.SCGB_UTI_CASSA_MLT,
          GB.SCGB_UTI_SMOBILIZZO,
          GB.SCGB_UTI_FIRMA_DT,
          GB.SCGB_ACC_CASSA_BT,
          GB.SCGB_ACC_CASSA_MLT,
          GB.SCGB_ACC_SMOBILIZZO,
          GB.SCGB_ACC_FIRMA_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_CASSA
          END
             GEGB_UTI_CASSA,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_FIRMA
          END
             GEGB_UTI_FIRMA,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_CASSA
          END
             GEGB_ACC_CASSA,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_FIRMA
          END
             GEGB_ACC_FIRMA,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_CASSA_BT
          END
             GEGB_UTI_CASSA_BT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_CASSA_MLT
          END
             GEGB_UTI_CASSA_MLT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_SMOBILIZZO
          END
             GEGB_UTI_SMOBILIZZO,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_UTI_FIRMA_DT
          END
             GEGB_UTI_FIRMA_DT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_CASSA_BT
          END
             GEGB_ACC_CASSA_BT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_CASSA_MLT
          END
             GEGB_ACC_CASSA_MLT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_SMOBILIZZO
          END
             GEGB_ACC_SMOBILIZZO,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                GB.GEGB_ACC_FIRMA_DT
          END
             GEGB_ACC_FIRMA_DT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_CASSA
          END
             GLGB_UTI_CASSA,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_FIRMA
          END
             GLGB_UTI_FIRMA,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_CASSA
          END
             GLGB_ACC_CASSA,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_FIRMA
          END
             GLGB_ACC_FIRMA,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_CASSA_BT
          END
             GLGB_UTI_CASSA_BT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_CASSA_MLT
          END
             GLGB_UTI_CASSA_MLT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_SMOBILIZZO
          END
             GLGB_UTI_SMOBILIZZO,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_UTI_FIRMA_DT
          END
             GLGB_UTI_FIRMA_DT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_CASSA_BT
          END
             GLGB_ACC_CASSA_BT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_CASSA_MLT
          END
             GLGB_ACC_CASSA_MLT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_SMOBILIZZO
          END
             GLGB_ACC_SMOBILIZZO,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                GB.GLGB_ACC_FIRMA_DT
          END
             GLGB_ACC_FIRMA_DT,
          GB.DTA_RIFERIMENTO AS GB_DTA_RIFERIMENTO,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                (GB.gegb_uti_cassa + GB.gegb_uti_firma)
          END
             GEGB_UTI_TOT,
          CASE
             WHEN     NVL (gb.FLG_FLUSSO_GB, 0) = 1
                  AND fg.flg_gruppo_economico = 0
             THEN
                NULL
             ELSE
                (GB.gegb_acc_cassa + GB.gegb_acc_firma)
          END
             GEGB_ACC_TOT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                (GB.glgb_uti_cassa + GB.glgb_uti_firma)
          END
             GLGB_UTI_TOT,
          CASE
             WHEN NVL (gb.FLG_FLUSSO_GB, 0) = 1 AND fg.flg_gruppo_legame = 0
             THEN
                NULL
             ELSE
                (GB.glgb_acc_cassa + GB.glgb_acc_firma)
          END
             GLGB_ACC_TOT,
          (GB.scgb_uti_cassa + GB.scgb_uti_firma) AS SCGB_UTI_TOT,
          (GB.scgb_acc_cassa + GB.scgb_acc_firma) AS SCGB_ACC_TOT,
          GESB.GESB_ACC_CONSEGNE,
          GESB.GESB_ACC_CONSEGNE_DT,
          GESB.GESB_UTI_CONSEGNE,
          GESB.GESB_UTI_CONSEGNE_DT,
          GESB.GESB_UTI_SOSTITUZIONI,
          GESB.GESB_UTI_MASSIMALI,
          GESB.GESB_UTI_RISCHI_INDIRETTI,
          GESB.GESB_UTI_SOSTITUZIONI_DT,
          GESB.GESB_UTI_MASSIMALI_DT,
          GESB.GESB_UTI_RISCHI_INDIRETTI_DT,
          GESB.GESB_ACC_SOSTITUZIONI,
          GESB.GESB_ACC_MASSIMALI,
          GESB.GESB_ACC_RISCHI_INDIRETTI,
          GESB.GESB_ACC_SOSTITUZIONI_DT,
          GESB.GESB_ACC_MASSIMALI_DT,
          GESB.GESB_ACC_RISCHI_INDIRETTI_DT,
          GESB.GESB_UTI_CASSA,
          GESB.GESB_UTI_FIRMA,
          GESB.GESB_ACC_CASSA,
          GESB.GESB_ACC_FIRMA,
          GESB.GESB_UTI_CASSA_BT,
          GESB.GESB_UTI_CASSA_MLT,
          GESB.GESB_UTI_SMOBILIZZO,
          GESB.GESB_UTI_FIRMA_DT,
          GESB.GESB_ACC_CASSA_BT,
          GESB.GESB_ACC_CASSA_MLT,
          GESB.GESB_ACC_SMOBILIZZO,
          GESB.GESB_ACC_FIRMA_DT,
          GESB.GESB_TOT_GAR,
          GESB.GESB_DTA_RIFERIMENTO,
          GESB.GESB_ACC_TOT,
          GESB.GESB_UTI_TOT,
          SCSB.SCSB_ACC_CONSEGNE,
          SCSB.SCSB_ACC_CONSEGNE_DT,
          SCSB.SCSB_UTI_CONSEGNE,
          SCSB.SCSB_UTI_CONSEGNE_DT,
          SCSB.SCSB_UTI_MASSIMALI,
          SCSB.SCSB_UTI_SOSTITUZIONI,
          SCSB.SCSB_UTI_RISCHI_INDIRETTI,
          SCSB.SCSB_UTI_MASSIMALI_DT,
          SCSB.SCSB_UTI_SOSTITUZIONI_DT,
          SCSB.SCSB_UTI_RISCHI_INDIRETTI_DT,
          SCSB.SCSB_ACC_MASSIMALI,
          SCSB.SCSB_ACC_SOSTITUZIONI,
          SCSB.SCSB_ACC_RISCHI_INDIRETTI,
          SCSB.SCSB_ACC_MASSIMALI_DT,
          SCSB.SCSB_ACC_SOSTITUZIONI_DT,
          SCSB.SCSB_ACC_RISCHI_INDIRETTI_DT,
          SCSB.SCSB_UTI_CASSA,
          SCSB.SCSB_UTI_FIRMA,
          SCSB.SCSB_UTI_TOT,
          SCSB.SCSB_ACC_CASSA,
          SCSB.SCSB_ACC_FIRMA,
          SCSB.SCSB_ACC_TOT,
          SCSB.SCSB_UTI_CASSA_BT,
          SCSB.SCSB_UTI_CASSA_MLT,
          SCSB.SCSB_UTI_SMOBILIZZO,
          SCSB.SCSB_UTI_FIRMA_DT,
          SCSB.SCSB_ACC_CASSA_BT,
          SCSB.SCSB_ACC_CASSA_MLT,
          SCSB.SCSB_ACC_SMOBILIZZO,
          SCSB.SCSB_ACC_FIRMA_DT,
          SCSB.SCSB_TOT_GAR,
          SCSB.SCSB_DTA_RIFERIMENTO,
          DECODE (
             SIGN (
                  (gegb_uti_cassa + gegb_uti_firma + gegb_uti_sostituzioni)
                - (gegb_acc_cassa + gegb_acc_firma + gegb_acc_sostituzioni)),
             -1, (gegb_acc_cassa + gegb_acc_firma + gegb_acc_sostituzioni),
             (gegb_uti_cassa + gegb_uti_firma + gegb_uti_sostituzioni))
             gegb_mau,
          DECODE (
             SIGN (
                  (glgb_uti_cassa + glgb_uti_firma + glgb_uti_sostituzioni)
                - (glgb_acc_cassa + glgb_acc_firma + glgb_acc_sostituzioni)),
             -1, (glgb_acc_cassa + glgb_acc_firma + glgb_acc_sostituzioni),
             (glgb_uti_cassa + glgb_uti_firma + glgb_uti_sostituzioni))
             glgb_mau,
          DECODE (
             SIGN (
                  (scgb_uti_cassa + scgb_uti_firma + scgb_uti_sostituzioni)
                - (scgb_acc_cassa + scgb_acc_firma + scgb_acc_sostituzioni)),
             -1, (scgb_acc_cassa + scgb_acc_firma + scgb_acc_sostituzioni),
             (scgb_uti_cassa + scgb_uti_firma + scgb_uti_sostituzioni))
             scgb_mau,
          DECODE (
             fg.flg_gruppo_economico,
             1,                                                   /*GEGB_MAU*/
               DECODE (
                   SIGN (
                        (  gegb_uti_cassa
                         + gegb_uti_firma
                         + gegb_uti_sostituzioni)
                      - (  gegb_acc_cassa
                         + gegb_acc_firma
                         + gegb_acc_sostituzioni)),
                   -1, (  gegb_acc_cassa
                        + gegb_acc_firma
                        + gegb_acc_sostituzioni),
                   (gegb_uti_cassa + gegb_uti_firma + gegb_uti_sostituzioni)),
             DECODE (
                fg.flg_gruppo_legame,
                1,                                               /*GLGB_MAU */
                  DECODE (
                      SIGN (
                           (  glgb_uti_cassa
                            + glgb_uti_firma
                            + glgb_uti_sostituzioni)
                         - (  glgb_acc_cassa
                            + glgb_acc_firma
                            + glgb_acc_sostituzioni)),
                      -1, (  glgb_acc_cassa
                           + glgb_acc_firma
                           + glgb_acc_sostituzioni),
                      (  glgb_uti_cassa
                       + glgb_uti_firma
                       + glgb_uti_sostituzioni)),
                /* SCGB_MAU */
                DECODE (
                   SIGN (
                        (  scgb_uti_cassa
                         + scgb_uti_firma
                         + scgb_uti_sostituzioni)
                      - (  scgb_acc_cassa
                         + scgb_acc_firma
                         + scgb_acc_sostituzioni)),
                   -1, (  scgb_acc_cassa
                        + scgb_acc_firma
                        + scgb_acc_sostituzioni),
                   (scgb_uti_cassa + scgb_uti_firma + scgb_uti_sostituzioni))))
             GB_VAL_MAU,
          NVL (gb.FLG_FLUSSO_GB, 0) AS FLG_FLUSSO_GB,
          NVL (gesb.FLG_FLUSSO_GE_SB, 0) AS FLG_FLUSSO_GE_SB,
          NVL (scsb.FLG_FLUSSO_SC_SB, 0) AS FLG_FLUSSO_SC_SB,
          gb.id_dper SCGB_ID_DPER
     FROM MCRE_OWN.T_MCRE0_DAY_FG fg,
          MCRE_OWN.V_MCRE0_W_GB GB,
          MCRE_OWN.V_MCRE0_W_GE_SB GESB,
          MCRE_OWN.V_MCRE0_W_SC_SB SCSB
    WHERE     FG.COD_SNDG = GB.COD_SNDG(+)
          AND FG.COD_ABI_CARTOLARIZZATO = GB.COD_ABI_CARTOLARIZZATO(+) -- erano commentati
          AND FG.COD_NDG = GB.COD_NDG(+)                   -- erano commentati
          AND FG.COD_SNDG = GESB.COD_SNDG(+)
          AND FG.COD_ABI_ISTITUTO = GESB.COD_ABI_ISTITUTO(+)
          AND FG.COD_NDG = SCSB.COD_NDG(+)
          AND FG.COD_ABI_ISTITUTO = SCSB.COD_ABI_ISTITUTO(+);


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_ALL_PCR TO MCRE_USR;
