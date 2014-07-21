/* Formatted on 21/07/2014 18:38:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_TMP_PCR_WRK
(
   DTA_INS,
   DTA_UPD,
   TODAY_FLG,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   SCSB_ACC_CASSA,
   SCSB_ACC_CASSA_BT,
   SCSB_ACC_CASSA_MLT,
   SCSB_ACC_FIRMA,
   SCSB_ACC_FIRMA_DT,
   SCSB_ACC_SMOBILIZZO,
   SCSB_ACC_TOT,
   SCSB_DTA_RIFERIMENTO,
   SCSB_TOT_GAR,
   SCSB_UTI_CASSA,
   SCSB_UTI_CASSA_BT,
   SCSB_UTI_CASSA_MLT,
   SCSB_UTI_FIRMA,
   SCSB_UTI_FIRMA_DT,
   SCSB_UTI_SMOBILIZZO,
   SCSB_UTI_TOT,
   GESB_ACC_CASSA,
   GESB_ACC_CASSA_BT,
   GESB_ACC_CASSA_MLT,
   GESB_ACC_FIRMA,
   GESB_ACC_FIRMA_DT,
   GESB_ACC_SMOBILIZZO,
   GESB_DTA_RIFERIMENTO,
   GESB_TOT_GAR,
   GESB_UTI_CASSA,
   GESB_UTI_CASSA_BT,
   GESB_UTI_CASSA_MLT,
   GESB_UTI_FIRMA,
   GESB_UTI_FIRMA_DT,
   GESB_UTI_SMOBILIZZO,
   SCGB_ACC_CASSA,
   SCGB_ACC_CASSA_BT,
   SCGB_ACC_CASSA_MLT,
   SCGB_ACC_FIRMA,
   SCGB_ACC_FIRMA_DT,
   SCGB_ACC_SMOBILIZZO,
   SCGB_TOT_GAR,
   SCGB_UTI_CASSA,
   SCGB_UTI_CASSA_BT,
   SCGB_UTI_CASSA_MLT,
   SCGB_UTI_FIRMA,
   SCGB_UTI_FIRMA_DT,
   SCGB_UTI_SMOBILIZZO,
   GEGB_ACC_CASSA,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_FIRMA,
   GEGB_ACC_FIRMA_DT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_TOT_GAR,
   GEGB_UTI_CASSA,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_FIRMA,
   GEGB_UTI_FIRMA_DT,
   GEGB_UTI_SMOBILIZZO,
   GLGB_ACC_CASSA,
   GLGB_ACC_CASSA_BT,
   GLGB_ACC_CASSA_MLT,
   GLGB_ACC_FIRMA,
   GLGB_ACC_FIRMA_DT,
   GLGB_ACC_SMOBILIZZO,
   GLGB_TOT_GAR,
   GLGB_UTI_CASSA,
   GLGB_UTI_CASSA_BT,
   GLGB_UTI_CASSA_MLT,
   GLGB_UTI_FIRMA,
   GLGB_UTI_FIRMA_DT,
   GLGB_UTI_SMOBILIZZO,
   GB_VAL_MAU,
   GESB_ACC_TOT,
   GESB_UTI_TOT,
   GEGB_MAU,
   GLGB_MAU,
   SCGB_MAU,
   ID_DPER_SCSB,
   ID_DPER_GESB,
   ID_DPER_GB,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_MASSIMALI,
   SCSB_UTI_RISCHI_INDIRETTI,
   SCSB_UTI_SOSTITUZIONI_DT,
   SCSB_UTI_MASSIMALI_DT,
   SCSB_UTI_RISCHI_INDIRETTI_DT,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_SOSTITUZIONI_DT,
   SCSB_ACC_MASSIMALI,
   SCSB_ACC_MASSIMALI_DT,
   SCSB_ACC_RISCHI_INDIRETTI,
   SCSB_ACC_RISCHI_INDIRETTI_DT,
   GESB_UTI_MASSIMALI,
   GESB_UTI_RISCHI_INDIRETTI,
   GESB_UTI_SOSTITUZIONI_DT,
   GESB_UTI_MASSIMALI_DT,
   GESB_UTI_RISCHI_INDIRETTI_DT,
   GESB_ACC_SOSTITUZIONI,
   GESB_ACC_SOSTITUZIONI_DT,
   GESB_ACC_MASSIMALI,
   GESB_ACC_MASSIMALI_DT,
   GESB_ACC_RISCHI_INDIRETTI,
   GESB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_MASSIMALI,
   SCGB_UTI_RISCHI_INDIRETTI,
   SCGB_UTI_SOSTITUZIONI_DT,
   SCGB_UTI_MASSIMALI_DT,
   SCGB_UTI_RISCHI_INDIRETTI_DT,
   SCGB_ACC_SOSTITUZIONI,
   SCGB_ACC_SOSTITUZIONI_DT,
   SCGB_ACC_MASSIMALI,
   SCGB_ACC_MASSIMALI_DT,
   SCGB_ACC_RISCHI_INDIRETTI,
   SCGB_ACC_RISCHI_INDIRETTI_DT,
   GLGB_UTI_MASSIMALI,
   GLGB_UTI_RISCHI_INDIRETTI,
   GLGB_UTI_SOSTITUZIONI_DT,
   GLGB_UTI_MASSIMALI_DT,
   GLGB_UTI_RISCHI_INDIRETTI_DT,
   GLGB_ACC_SOSTITUZIONI,
   GLGB_ACC_SOSTITUZIONI_DT,
   GLGB_ACC_MASSIMALI,
   GLGB_ACC_MASSIMALI_DT,
   GLGB_ACC_RISCHI_INDIRETTI,
   GLGB_ACC_RISCHI_INDIRETTI_DT,
   GESB_UTI_SOSTITUZIONI,
   SCGB_UTI_SOSTITUZIONI,
   GEGB_UTI_SOSTITUZIONI,
   GLGB_UTI_SOSTITUZIONI,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI,
   GEGB_UTI_MASSIMALI_DT,
   GEGB_UTI_SOSTITUZIONI_DT,
   GEGB_UTI_RISCHI_INDIRETTI_DT,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_ACC_SOSTITUZIONI_DT,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_MASSIMALI_DT,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_TOT,
   SCGB_ACC_TOT,
   GEGB_UTI_TOT,
   GEGB_ACC_TOT,
   GLGB_UTI_TOT,
   GLGB_ACC_TOT,
   GB_DTA_RIFERIMENTO,
   SCSB_UTI_CONSEGNE,
   SCSB_ACC_CONSEGNE,
   SCGB_UTI_CONSEGNE,
   SCGB_ACC_CONSEGNE,
   GESB_UTI_CONSEGNE,
   GESB_ACC_CONSEGNE,
   GEGB_UTI_CONSEGNE,
   GEGB_ACC_CONSEGNE,
   GLGB_UTI_CONSEGNE,
   GLGB_ACC_CONSEGNE,
   SCSB_UTI_CONSEGNE_DT,
   SCSB_ACC_CONSEGNE_DT,
   SCGB_UTI_CONSEGNE_DT,
   SCGB_ACC_CONSEGNE_DT,
   GESB_UTI_CONSEGNE_DT,
   GESB_ACC_CONSEGNE_DT,
   GEGB_UTI_CONSEGNE_DT,
   GEGB_ACC_CONSEGNE_DT,
   GLGB_UTI_CONSEGNE_DT,
   GLGB_ACC_CONSEGNE_DT,
   COD_GRUPPO_ECONOMICO,
   FLG_ERASE
)
AS
   SELECT DISTINCT
          SYSDATE DTA_INS,
          SYSDATE DTA_UPD,
          TODAY_FLG,
          COD_ABI_ISTITUTO,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_SNDG,
          SCSB_ACC_CASSA,
          SCSB_ACC_CASSA_BT,
          SCSB_ACC_CASSA_MLT,
          SCSB_ACC_FIRMA,
          SCSB_ACC_FIRMA_DT,
          SCSB_ACC_SMOBILIZZO,
          SCSB_ACC_TOT,
          SCSB_DTA_RIFERIMENTO,
          SCSB_TOT_GAR,
          SCSB_UTI_CASSA,
          SCSB_UTI_CASSA_BT,
          SCSB_UTI_CASSA_MLT,
          SCSB_UTI_FIRMA,
          SCSB_UTI_FIRMA_DT,
          SCSB_UTI_SMOBILIZZO,
          SCSB_UTI_TOT,
          GESB_ACC_CASSA,
          GESB_ACC_CASSA_BT,
          GESB_ACC_CASSA_MLT,
          GESB_ACC_FIRMA,
          GESB_ACC_FIRMA_DT,
          GESB_ACC_SMOBILIZZO,
          GESB_DTA_RIFERIMENTO,
          GESB_TOT_GAR,
          GESB_UTI_CASSA,
          GESB_UTI_CASSA_BT,
          GESB_UTI_CASSA_MLT,
          GESB_UTI_FIRMA,
          GESB_UTI_FIRMA_DT,
          GESB_UTI_SMOBILIZZO,
          SCGB_ACC_CASSA,
          SCGB_ACC_CASSA_BT,
          SCGB_ACC_CASSA_MLT,
          SCGB_ACC_FIRMA,
          SCGB_ACC_FIRMA_DT,
          SCGB_ACC_SMOBILIZZO,
          SCGB_TOT_GAR,
          SCGB_UTI_CASSA,
          SCGB_UTI_CASSA_BT,
          SCGB_UTI_CASSA_MLT,
          SCGB_UTI_FIRMA,
          SCGB_UTI_FIRMA_DT,
          SCGB_UTI_SMOBILIZZO,
          GEGB_ACC_CASSA,
          GEGB_ACC_CASSA_BT,
          GEGB_ACC_CASSA_MLT,
          GEGB_ACC_FIRMA,
          GEGB_ACC_FIRMA_DT,
          GEGB_ACC_SMOBILIZZO,
          GEGB_TOT_GAR,
          GEGB_UTI_CASSA,
          GEGB_UTI_CASSA_BT,
          GEGB_UTI_CASSA_MLT,
          GEGB_UTI_FIRMA,
          GEGB_UTI_FIRMA_DT,
          GEGB_UTI_SMOBILIZZO,
          GLGB_ACC_CASSA,
          GLGB_ACC_CASSA_BT,
          GLGB_ACC_CASSA_MLT,
          GLGB_ACC_FIRMA,
          GLGB_ACC_FIRMA_DT,
          GLGB_ACC_SMOBILIZZO,
          GLGB_TOT_GAR,
          GLGB_UTI_CASSA,
          GLGB_UTI_CASSA_BT,
          GLGB_UTI_CASSA_MLT,
          GLGB_UTI_FIRMA,
          GLGB_UTI_FIRMA_DT,
          GLGB_UTI_SMOBILIZZO,
          DECODE (flg_gruppo_economico,
                  1, GEGB_MAU,
                  DECODE (flg_gruppo_legame, 1, glgb_mau, scgb_mau))
             GB_VAL_MAU,
          GESB_ACC_TOT,
          GESB_UTI_TOT,
          GEGB_MAU,
          GLGB_MAU,
          SCGB_MAU,
          ID_DPER_SCSB,
          ID_DPER_GESB,
          ID_DPER_GB,
          SCSB_UTI_SOSTITUZIONI,
          SCSB_UTI_MASSIMALI,
          SCSB_UTI_RISCHI_INDIRETTI,
          SCSB_UTI_SOSTITUZIONI_DT,
          SCSB_UTI_MASSIMALI_DT,
          SCSB_UTI_RISCHI_INDIRETTI_DT,
          SCSB_ACC_SOSTITUZIONI,
          SCSB_ACC_SOSTITUZIONI_DT,
          SCSB_ACC_MASSIMALI,
          SCSB_ACC_MASSIMALI_DT,
          SCSB_ACC_RISCHI_INDIRETTI,
          SCSB_ACC_RISCHI_INDIRETTI_DT,
          GESB_UTI_MASSIMALI,
          GESB_UTI_RISCHI_INDIRETTI,
          GESB_UTI_SOSTITUZIONI_DT,
          GESB_UTI_MASSIMALI_DT,
          GESB_UTI_RISCHI_INDIRETTI_DT,
          GESB_ACC_SOSTITUZIONI,
          GESB_ACC_SOSTITUZIONI_DT,
          GESB_ACC_MASSIMALI,
          GESB_ACC_MASSIMALI_DT,
          GESB_ACC_RISCHI_INDIRETTI,
          GESB_ACC_RISCHI_INDIRETTI_DT,
          SCGB_UTI_MASSIMALI,
          SCGB_UTI_RISCHI_INDIRETTI,
          SCGB_UTI_SOSTITUZIONI_DT,
          SCGB_UTI_MASSIMALI_DT,
          SCGB_UTI_RISCHI_INDIRETTI_DT,
          SCGB_ACC_SOSTITUZIONI,
          SCGB_ACC_SOSTITUZIONI_DT,
          SCGB_ACC_MASSIMALI,
          SCGB_ACC_MASSIMALI_DT,
          SCGB_ACC_RISCHI_INDIRETTI,
          SCGB_ACC_RISCHI_INDIRETTI_DT,
          GLGB_UTI_MASSIMALI,
          GLGB_UTI_RISCHI_INDIRETTI,
          GLGB_UTI_SOSTITUZIONI_DT,
          GLGB_UTI_MASSIMALI_DT,
          GLGB_UTI_RISCHI_INDIRETTI_DT,
          GLGB_ACC_SOSTITUZIONI,
          GLGB_ACC_SOSTITUZIONI_DT,
          GLGB_ACC_MASSIMALI,
          GLGB_ACC_MASSIMALI_DT,
          GLGB_ACC_RISCHI_INDIRETTI,
          GLGB_ACC_RISCHI_INDIRETTI_DT,
          GESB_UTI_SOSTITUZIONI,
          SCGB_UTI_SOSTITUZIONI,
          GEGB_UTI_SOSTITUZIONI,
          GLGB_UTI_SOSTITUZIONI,
          GEGB_UTI_MASSIMALI,
          GEGB_UTI_RISCHI_INDIRETTI,
          GEGB_UTI_MASSIMALI_DT,
          GEGB_UTI_SOSTITUZIONI_DT,
          GEGB_UTI_RISCHI_INDIRETTI_DT,
          GEGB_ACC_SOSTITUZIONI,
          GEGB_ACC_SOSTITUZIONI_DT,
          GEGB_ACC_MASSIMALI,
          GEGB_ACC_MASSIMALI_DT,
          GEGB_ACC_RISCHI_INDIRETTI,
          GEGB_ACC_RISCHI_INDIRETTI_DT,
          SCGB_UTI_TOT,
          SCGB_ACC_TOT,
          GEGB_UTI_TOT,
          GEGB_ACC_TOT,
          GLGB_UTI_TOT,
          GLGB_ACC_TOT,
          GB_DTA_RIFERIMENTO,
          SCSB_UTI_CONSEGNE,
          SCSB_ACC_CONSEGNE,
          SCGB_UTI_CONSEGNE,
          SCGB_ACC_CONSEGNE,
          GESB_UTI_CONSEGNE,
          GESB_ACC_CONSEGNE,
          GEGB_UTI_CONSEGNE,
          GEGB_ACC_CONSEGNE,
          GLGB_UTI_CONSEGNE,
          GLGB_ACC_CONSEGNE,
          SCSB_UTI_CONSEGNE_DT,
          SCSB_ACC_CONSEGNE_DT,
          SCGB_UTI_CONSEGNE_DT,
          SCGB_ACC_CONSEGNE_DT,
          GESB_UTI_CONSEGNE_DT,
          GESB_ACC_CONSEGNE_DT,
          GEGB_UTI_CONSEGNE_DT,
          GEGB_ACC_CONSEGNE_DT,
          GLGB_UTI_CONSEGNE_DT,
          GLGB_ACC_CONSEGNE_DT,
          cod_gruppo_economico,
          CASE
             WHEN (    geGB_ACC_consegne IS NULL
                   AND geGB_ACC_consegne_dt IS NULL
                   AND geGB_uti_consegne IS NULL
                   AND geGB_uti_consegne_dt IS NULL
                   AND gesB_ACC_consegne IS NULL
                   AND gesB_ACC_consegne_dt IS NULL
                   AND gesB_uti_consegne IS NULL
                   AND gesB_uti_consegne_dt IS NULL
                   AND glGB_ACC_consegne IS NULL
                   AND glGB_ACC_consegne_dt IS NULL
                   AND glGB_uti_consegne IS NULL
                   AND glGB_uti_consegne_dt IS NULL
                   AND scGB_uti_consegne_dt IS NULL
                   AND scGB_uti_consegne IS NULL
                   AND scGB_acc_consegne_dt IS NULL
                   AND scGB_acc_consegne IS NULL
                   AND scsB_uti_consegne_dt IS NULL
                   AND scsB_uti_consegne IS NULL
                   AND scsB_acc_consegne_dt IS NULL
                   AND scsB_acc_consegne IS NULL
                   AND GEGB_ACC_CASSA IS NULL
                   AND GEGB_ACC_CASSA_BT IS NULL
                   AND GEGB_ACC_CASSA_MLT IS NULL
                   AND GEGB_ACC_FIRMA IS NULL
                   AND GEGB_ACC_FIRMA_DT IS NULL
                   AND GEGB_ACC_MASSIMALI IS NULL
                   AND GEGB_ACC_MASSIMALI_DT IS NULL
                   AND GEGB_ACC_RISCHI_INDIRETTI IS NULL
                   AND GEGB_ACC_RISCHI_INDIRETTI_DT IS NULL
                   AND GEGB_ACC_SMOBILIZZO IS NULL
                   AND GEGB_ACC_SOSTITUZIONI IS NULL
                   AND GEGB_ACC_SOSTITUZIONI_DT IS NULL
                   AND GEGB_ACC_TOT IS NULL
                   AND GEGB_UTI_CASSA IS NULL
                   AND GEGB_UTI_CASSA_BT IS NULL
                   AND GEGB_UTI_CASSA_MLT IS NULL
                   AND GEGB_UTI_FIRMA IS NULL
                   AND GEGB_UTI_FIRMA_DT IS NULL
                   AND GEGB_UTI_MASSIMALI IS NULL
                   AND GEGB_UTI_MASSIMALI_DT IS NULL
                   AND GEGB_UTI_RISCHI_INDIRETTI IS NULL
                   AND GEGB_UTI_RISCHI_INDIRETTI_DT IS NULL
                   AND GEGB_UTI_SMOBILIZZO IS NULL
                   AND GEGB_UTI_SOSTITUZIONI IS NULL
                   AND GEGB_UTI_SOSTITUZIONI_DT IS NULL
                   AND GEGB_UTI_TOT IS NULL
                   AND GESB_ACC_CASSA IS NULL
                   AND GESB_ACC_CASSA_BT IS NULL
                   AND GESB_ACC_CASSA_MLT IS NULL
                   AND GESB_ACC_FIRMA IS NULL
                   AND GESB_ACC_FIRMA_DT IS NULL
                   AND GESB_ACC_MASSIMALI IS NULL
                   AND GESB_ACC_MASSIMALI_DT IS NULL
                   AND GESB_ACC_RISCHI_INDIRETTI IS NULL
                   AND GESB_ACC_RISCHI_INDIRETTI_DT IS NULL
                   AND GESB_ACC_SMOBILIZZO IS NULL
                   AND GESB_ACC_SOSTITUZIONI IS NULL
                   AND GESB_ACC_SOSTITUZIONI_DT IS NULL
                   AND GESB_ACC_TOT IS NULL
                   AND GESB_UTI_CASSA IS NULL
                   AND GESB_UTI_CASSA_BT IS NULL
                   AND GESB_UTI_CASSA_MLT IS NULL
                   AND GESB_UTI_FIRMA IS NULL
                   AND GESB_UTI_FIRMA_DT IS NULL
                   AND GESB_UTI_MASSIMALI IS NULL
                   AND GESB_UTI_MASSIMALI_DT IS NULL
                   AND GESB_UTI_RISCHI_INDIRETTI IS NULL
                   AND GESB_UTI_RISCHI_INDIRETTI_DT IS NULL
                   AND GESB_UTI_SMOBILIZZO IS NULL
                   AND GESB_UTI_SOSTITUZIONI IS NULL
                   AND GESB_UTI_SOSTITUZIONI_DT IS NULL
                   AND GESB_UTI_TOT IS NULL
                   AND GLGB_ACC_CASSA IS NULL
                   AND GLGB_ACC_CASSA_BT IS NULL
                   AND GLGB_ACC_CASSA_MLT IS NULL
                   AND GLGB_ACC_FIRMA IS NULL
                   AND GLGB_ACC_FIRMA_DT IS NULL
                   AND GLGB_ACC_MASSIMALI IS NULL
                   AND GLGB_ACC_MASSIMALI_DT IS NULL
                   AND GLGB_ACC_RISCHI_INDIRETTI IS NULL
                   AND GLGB_ACC_RISCHI_INDIRETTI_DT IS NULL
                   AND GLGB_ACC_SMOBILIZZO IS NULL
                   AND GLGB_ACC_SOSTITUZIONI IS NULL
                   AND GLGB_ACC_SOSTITUZIONI_DT IS NULL
                   AND GLGB_ACC_TOT IS NULL
                   AND GLGB_UTI_CASSA IS NULL
                   AND GLGB_UTI_CASSA_BT IS NULL
                   AND GLGB_UTI_CASSA_MLT IS NULL
                   AND GLGB_UTI_FIRMA IS NULL
                   AND GLGB_UTI_FIRMA_DT IS NULL
                   AND GLGB_UTI_MASSIMALI IS NULL
                   AND GLGB_UTI_MASSIMALI_DT IS NULL
                   AND GLGB_UTI_RISCHI_INDIRETTI IS NULL
                   AND GLGB_UTI_RISCHI_INDIRETTI_DT IS NULL
                   AND GLGB_UTI_SMOBILIZZO IS NULL
                   AND GLGB_UTI_SOSTITUZIONI IS NULL
                   AND GLGB_UTI_SOSTITUZIONI_DT IS NULL
                   AND GLGB_UTI_TOT IS NULL
                   AND SCGB_ACC_CASSA IS NULL
                   AND SCGB_ACC_CASSA_BT IS NULL
                   AND SCGB_ACC_CASSA_MLT IS NULL
                   AND SCGB_ACC_FIRMA IS NULL
                   AND SCGB_ACC_FIRMA_DT IS NULL
                   AND SCGB_ACC_MASSIMALI IS NULL
                   AND SCGB_ACC_MASSIMALI_DT IS NULL
                   AND SCGB_ACC_RISCHI_INDIRETTI IS NULL
                   AND SCGB_ACC_RISCHI_INDIRETTI_DT IS NULL
                   AND SCGB_ACC_SMOBILIZZO IS NULL
                   AND SCGB_ACC_SOSTITUZIONI IS NULL
                   AND SCGB_ACC_SOSTITUZIONI_DT IS NULL
                   AND SCGB_ACC_TOT IS NULL
                   AND SCGB_UTI_CASSA IS NULL
                   AND SCGB_UTI_CASSA_BT IS NULL
                   AND SCGB_UTI_CASSA_MLT IS NULL
                   AND SCGB_UTI_FIRMA IS NULL
                   AND SCGB_UTI_FIRMA_DT IS NULL
                   AND SCGB_UTI_MASSIMALI IS NULL
                   AND SCGB_UTI_MASSIMALI_DT IS NULL
                   AND SCGB_UTI_RISCHI_INDIRETTI IS NULL
                   AND SCGB_UTI_RISCHI_INDIRETTI_DT IS NULL
                   AND SCGB_UTI_SMOBILIZZO IS NULL
                   AND SCGB_UTI_SOSTITUZIONI IS NULL
                   AND SCGB_UTI_SOSTITUZIONI_DT IS NULL
                   AND SCGB_UTI_TOT IS NULL
                   AND SCSB_ACC_CASSA IS NULL
                   AND SCSB_ACC_CASSA_BT IS NULL
                   AND SCSB_ACC_CASSA_MLT IS NULL
                   AND SCSB_ACC_FIRMA IS NULL
                   AND SCSB_ACC_FIRMA_DT IS NULL
                   AND SCSB_ACC_MASSIMALI IS NULL
                   AND SCSB_ACC_MASSIMALI_DT IS NULL
                   AND SCSB_ACC_RISCHI_INDIRETTI IS NULL
                   AND SCSB_ACC_RISCHI_INDIRETTI_DT IS NULL
                   AND SCSB_ACC_SMOBILIZZO IS NULL
                   AND SCSB_ACC_SOSTITUZIONI IS NULL
                   AND SCSB_ACC_SOSTITUZIONI_DT IS NULL
                   AND SCSB_ACC_TOT IS NULL
                   AND SCSB_UTI_CASSA IS NULL
                   AND SCSB_UTI_CASSA_BT IS NULL
                   AND SCSB_UTI_CASSA_MLT IS NULL
                   AND SCSB_UTI_FIRMA IS NULL
                   AND SCSB_UTI_FIRMA_DT IS NULL
                   AND SCSB_UTI_MASSIMALI IS NULL
                   AND SCSB_UTI_MASSIMALI_DT IS NULL
                   AND SCSB_UTI_RISCHI_INDIRETTI IS NULL
                   AND SCSB_UTI_RISCHI_INDIRETTI_DT IS NULL
                   AND SCSB_UTI_SMOBILIZZO IS NULL
                   AND SCSB_UTI_SOSTITUZIONI IS NULL
                   AND SCSB_UTI_SOSTITUZIONI_DT IS NULL
                   AND SCSB_UTI_TOT IS NULL)
             THEN
                '1'
             ELSE
                '0'
          END
             flg_erase
     FROM (SELECT /*+pq_distribute(ge,hash,hash)*/
                 fgb.id_dper,
                  fgb.FLG_LAST_RUN,
                  fgb.cod_abi_cartolarizzato,
                  fgb.cod_ndg,
                  fgb.today_flg,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.COD_SNDG
                     ELSE
                        fgb.cod_sndg
                  END
                     cod_sndg,
                  --FLG_SNDG_GE,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.cod_abi_istituto
                     ELSE
                        fgb.cod_abi_istituto
                  END
                     cod_abi_istituto,
                  NVL (fgb.flg_gruppo_economico, '0') flg_gruppo_economico,
                  fgb.cod_gruppo_economico,
                  NVL (fgb.flg_gruppo_legame, '0') flg_gruppo_legame,
                  --PCR
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.id_dper_scsb
                     ELSE
                        sc.id_dper_scsb
                  END
                     id_dper_scsb,
                  CASE
                     WHEN ge.id_dper_gesb IS NULL THEN p.id_dper_gesb
                     ELSE ge.id_dper_gesb
                  END
                     id_dper_gesb,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.id_dper_gb
                     ELSE
                        fgb.id_dper_gb
                  END
                     id_dper_gb,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_CONSEGNE
                     ELSE
                        sc.SCSB_ACC_CONSEGNE
                  END
                     SCSB_ACC_CONSEGNE,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_CONSEGNE_DT
                     ELSE
                        sc.SCSB_ACC_CONSEGNE_DT
                  END
                     SCSB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_CONSEGNE
                     ELSE
                        sc.SCSB_UTI_CONSEGNE
                  END
                     SCSB_UTI_CONSEGNE,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_CONSEGNE_DT
                     ELSE
                        sc.SCSB_UTI_CONSEGNE_DT
                  END
                     SCSB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_MASSIMALI
                     ELSE
                        sc.SCSB_UTI_MASSIMALI
                  END
                     SCSB_UTI_MASSIMALI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_SOSTITUZIONI
                     ELSE
                        sc.SCSB_UTI_SOSTITUZIONI
                  END
                     SCSB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_RISCHI_INDIRETTI
                     ELSE
                        sc.SCSB_UTI_RISCHI_INDIRETTI
                  END
                     SCSB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_MASSIMALI_DT
                     ELSE
                        sc.SCSB_UTI_MASSIMALI_DT
                  END
                     SCSB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_SOSTITUZIONI_DT
                     ELSE
                        sc.SCSB_UTI_SOSTITUZIONI_DT
                  END
                     SCSB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_RISCHI_INDIRETTI_DT
                     ELSE
                        sc.SCSB_UTI_RISCHI_INDIRETTI_DT
                  END
                     SCSB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_MASSIMALI
                     ELSE
                        sc.SCSB_ACC_MASSIMALI
                  END
                     SCSB_ACC_MASSIMALI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_SOSTITUZIONI
                     ELSE
                        sc.SCSB_ACC_SOSTITUZIONI
                  END
                     SCSB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_RISCHI_INDIRETTI
                     ELSE
                        sc.SCSB_ACC_RISCHI_INDIRETTI
                  END
                     SCSB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_MASSIMALI_DT
                     ELSE
                        sc.SCSB_ACC_MASSIMALI_DT
                  END
                     SCSB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_SOSTITUZIONI_DT
                     ELSE
                        sc.SCSB_ACC_SOSTITUZIONI_DT
                  END
                     SCSB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_RISCHI_INDIRETTI_DT
                     ELSE
                        sc.SCSB_ACC_RISCHI_INDIRETTI_DT
                  END
                     SCSB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_CASSA
                     ELSE
                        sc.SCSB_UTI_CASSA
                  END
                     SCSB_UTI_CASSA,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_FIRMA
                     ELSE
                        sc.SCSB_UTI_FIRMA
                  END
                     SCSB_UTI_FIRMA,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_TOT
                     ELSE
                        sc.SCSB_UTI_TOT
                  END
                     SCSB_UTI_TOT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_CASSA
                     ELSE
                        sc.SCSB_ACC_CASSA
                  END
                     SCSB_ACC_CASSA,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_FIRMA
                     ELSE
                        sc.SCSB_ACC_FIRMA
                  END
                     SCSB_ACC_FIRMA,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_TOT
                     ELSE
                        sc.SCSB_ACC_TOT
                  END
                     SCSB_ACC_TOT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_CASSA_BT
                     ELSE
                        sc.SCSB_UTI_CASSA_BT
                  END
                     SCSB_UTI_CASSA_BT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_CASSA_MLT
                     ELSE
                        sc.SCSB_UTI_CASSA_MLT
                  END
                     SCSB_UTI_CASSA_MLT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_SMOBILIZZO
                     ELSE
                        sc.SCSB_UTI_SMOBILIZZO
                  END
                     SCSB_UTI_SMOBILIZZO,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_UTI_FIRMA_DT
                     ELSE
                        sc.SCSB_UTI_FIRMA_DT
                  END
                     SCSB_UTI_FIRMA_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_CASSA_BT
                     ELSE
                        sc.SCSB_ACC_CASSA_BT
                  END
                     SCSB_ACC_CASSA_BT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_CASSA_MLT
                     ELSE
                        sc.SCSB_ACC_CASSA_MLT
                  END
                     SCSB_ACC_CASSA_MLT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_SMOBILIZZO
                     ELSE
                        sc.SCSB_ACC_SMOBILIZZO
                  END
                     SCSB_ACC_SMOBILIZZO,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_ACC_FIRMA_DT
                     ELSE
                        sc.SCSB_ACC_FIRMA_DT
                  END
                     SCSB_ACC_FIRMA_DT,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_TOT_GAR
                     ELSE
                        sc.SCSB_TOT_GAR
                  END
                     SCSB_TOT_GAR,
                  CASE
                     WHEN     NVL (sc.flg_last_run, '0') = '0'
                          AND NVL (sc.id_dper_scsb, '00000000') <>
                                 NVL (p.id_dper_scsb, '00000000')
                     THEN
                        p.SCSB_DTA_RIFERIMENTO
                     ELSE
                        sc.SCSB_DTA_RIFERIMENTO
                  END
                     SCSB_DTA_RIFERIMENTO,
                  --GESB
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_CONSEGNE
                  END
                     GESB_ACC_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_CONSEGNE_DT
                  END
                     GESB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_CONSEGNE
                  END
                     GESB_UTI_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_CONSEGNE_DT
                  END
                     GESB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_SOSTITUZIONI
                  END
                     GESB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_MASSIMALI
                  END
                     GESB_UTI_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_RISCHI_INDIRETTI
                  END
                     GESB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_SOSTITUZIONI_DT
                  END
                     GESB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_MASSIMALI_DT
                  END
                     GESB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_RISCHI_INDIRETTI_DT
                  END
                     GESB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_SOSTITUZIONI
                  END
                     GESB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_MASSIMALI
                  END
                     GESB_ACC_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_RISCHI_INDIRETTI
                  END
                     GESB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_SOSTITUZIONI_DT
                  END
                     GESB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_MASSIMALI_DT
                  END
                     GESB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_RISCHI_INDIRETTI_DT
                  END
                     GESB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_CASSA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_CASSA
                  END
                     GESB_UTI_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_FIRMA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_FIRMA
                  END
                     GESB_UTI_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_CASSA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_CASSA
                  END
                     GESB_ACC_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_FIRMA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_FIRMA
                  END
                     GESB_ACC_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_CASSA_BT
                  END
                     GESB_UTI_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_CASSA_MLT
                  END
                     GESB_UTI_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_SMOBILIZZO
                  END
                     GESB_UTI_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_FIRMA_DT
                  END
                     GESB_UTI_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_CASSA_BT
                  END
                     GESB_ACC_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_CASSA_MLT
                  END
                     GESB_ACC_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_SMOBILIZZO
                  END
                     GESB_ACC_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_FIRMA_DT
                  END
                     GESB_ACC_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_TOT_GAR
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_TOT_GAR
                  END
                     GESB_TOT_GAR,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_DTA_RIFERIMENTO
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_DTA_RIFERIMENTO
                  END
                     GESB_DTA_RIFERIMENTO,
                  --p.GESB_ACC_TOT GESB_ACC_TOT_1,
                  --ge.GESB_ACC_TOT GESB_ACC_TOT_2,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_ACC_TOT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_ACC_TOT
                  END
                     GESB_ACC_TOT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GESB_UTI_TOT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        ge.GESB_UTI_TOT
                  END
                     GESB_UTI_TOT,
                  --GB
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GB_DTA_RIFERIMENTO
                     ELSE
                        fgb.GB_DTA_RIFERIMENTO
                  END
                     GB_DTA_RIFERIMENTO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_CASSA_BT
                  END
                     GEGB_ACC_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_CASSA_MLT
                  END
                     GEGB_ACC_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_CONSEGNE
                  END
                     GEGB_ACC_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_CONSEGNE_DT
                  END
                     GEGB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_FIRMA_DT
                  END
                     GEGB_ACC_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_MASSIMALI
                  END
                     GEGB_ACC_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_MASSIMALI_DT
                  END
                     GEGB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_RISCHI_INDIRETTI
                  END
                     GEGB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_RISCHI_INDIRETTI_DT
                  END
                     GEGB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_SMOBILIZZO
                  END
                     GEGB_ACC_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_SOSTITUZIONI
                  END
                     GEGB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_SOSTITUZIONI_DT
                  END
                     GEGB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_TOT_GAR
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_TOT_GAR
                  END
                     GEGB_TOT_GAR,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_CASSA_BT
                  END
                     GEGB_UTI_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_CASSA_MLT
                  END
                     GEGB_UTI_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_CONSEGNE
                  END
                     GEGB_UTI_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_CONSEGNE_DT
                  END
                     GEGB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_FIRMA_DT
                  END
                     GEGB_UTI_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_MASSIMALI
                  END
                     GEGB_UTI_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_MASSIMALI_DT
                  END
                     GEGB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_RISCHI_INDIRETTI
                  END
                     GEGB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_RISCHI_INDIRETTI_DT
                  END
                     GEGB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_SMOBILIZZO
                  END
                     GEGB_UTI_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_SOSTITUZIONI
                  END
                     GEGB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_SOSTITUZIONI_DT
                  END
                     GEGB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_CASSA
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_CASSA
                  END
                     GLGB_ACC_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_CASSA_BT
                  END
                     GLGB_ACC_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_CASSA_MLT
                  END
                     GLGB_ACC_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_CONSEGNE
                  END
                     GLGB_ACC_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_CONSEGNE_DT
                  END
                     GLGB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_FIRMA
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_FIRMA
                  END
                     GLGB_ACC_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_FIRMA_DT
                  END
                     GLGB_ACC_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_MASSIMALI
                  END
                     GLGB_ACC_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_MASSIMALI_DT
                  END
                     GLGB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_RISCHI_INDIRETTI
                  END
                     GLGB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_RISCHI_INDIRETTI_DT
                  END
                     GLGB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_SMOBILIZZO
                  END
                     GLGB_ACC_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_SOSTITUZIONI
                  END
                     GLGB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_SOSTITUZIONI_DT
                  END
                     GLGB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_ACC_TOT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_ACC_TOT
                  END
                     GLGB_ACC_TOT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_TOT_GAR
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_TOT_GAR
                  END
                     GLGB_TOT_GAR,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_CASSA
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_CASSA
                  END
                     GLGB_UTI_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_CASSA_BT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_CASSA_BT
                  END
                     GLGB_UTI_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_CASSA_MLT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_CASSA_MLT
                  END
                     GLGB_UTI_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_CONSEGNE
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_CONSEGNE
                  END
                     GLGB_UTI_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_CONSEGNE_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_CONSEGNE_DT
                  END
                     GLGB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_FIRMA
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_FIRMA
                  END
                     GLGB_UTI_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_FIRMA_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_FIRMA_DT
                  END
                     GLGB_UTI_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_MASSIMALI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_MASSIMALI
                  END
                     GLGB_UTI_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_MASSIMALI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_MASSIMALI_DT
                  END
                     GLGB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_RISCHI_INDIRETTI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_RISCHI_INDIRETTI
                  END
                     GLGB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_RISCHI_INDIRETTI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_RISCHI_INDIRETTI_DT
                  END
                     GLGB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_SMOBILIZZO
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_SMOBILIZZO
                  END
                     GLGB_UTI_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_SOSTITUZIONI
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_SOSTITUZIONI
                  END
                     GLGB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_SOSTITUZIONI_DT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_SOSTITUZIONI_DT
                  END
                     GLGB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_UTI_TOT
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_UTI_TOT
                  END
                     GLGB_UTI_TOT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_CASSA
                     ELSE
                        fgb.SCGB_ACC_CASSA
                  END
                     SCGB_ACC_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_CASSA_BT
                     ELSE
                        fgb.SCGB_ACC_CASSA_BT
                  END
                     SCGB_ACC_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_CASSA_MLT
                     ELSE
                        fgb.SCGB_ACC_CASSA_MLT
                  END
                     SCGB_ACC_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_CONSEGNE
                     ELSE
                        fgb.SCGB_ACC_CONSEGNE
                  END
                     SCGB_ACC_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_CONSEGNE_DT
                     ELSE
                        fgb.SCGB_ACC_CONSEGNE_DT
                  END
                     SCGB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_FIRMA
                     ELSE
                        fgb.SCGB_ACC_FIRMA
                  END
                     SCGB_ACC_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_FIRMA_DT
                     ELSE
                        fgb.SCGB_ACC_FIRMA_DT
                  END
                     SCGB_ACC_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_MASSIMALI
                     ELSE
                        fgb.SCGB_ACC_MASSIMALI
                  END
                     SCGB_ACC_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_MASSIMALI_DT
                     ELSE
                        fgb.SCGB_ACC_MASSIMALI_DT
                  END
                     SCGB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_RISCHI_INDIRETTI
                     ELSE
                        fgb.SCGB_ACC_RISCHI_INDIRETTI
                  END
                     SCGB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_RISCHI_INDIRETTI_DT
                     ELSE
                        fgb.SCGB_ACC_RISCHI_INDIRETTI_DT
                  END
                     SCGB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_SMOBILIZZO
                     ELSE
                        fgb.SCGB_ACC_SMOBILIZZO
                  END
                     SCGB_ACC_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_SOSTITUZIONI
                     ELSE
                        fgb.SCGB_ACC_SOSTITUZIONI
                  END
                     SCGB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_SOSTITUZIONI_DT
                     ELSE
                        fgb.SCGB_ACC_SOSTITUZIONI_DT
                  END
                     SCGB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_ACC_TOT
                     ELSE
                        fgb.SCGB_ACC_TOT
                  END
                     SCGB_ACC_TOT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_TOT_GAR
                     ELSE
                        fgb.SCGB_TOT_GAR
                  END
                     SCGB_TOT_GAR,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_CASSA
                     ELSE
                        fgb.SCGB_UTI_CASSA
                  END
                     SCGB_UTI_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_CASSA_BT
                     ELSE
                        fgb.SCGB_UTI_CASSA_BT
                  END
                     SCGB_UTI_CASSA_BT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_CASSA_MLT
                     ELSE
                        fgb.SCGB_UTI_CASSA_MLT
                  END
                     SCGB_UTI_CASSA_MLT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_CONSEGNE
                     ELSE
                        fgb.SCGB_UTI_CONSEGNE
                  END
                     SCGB_UTI_CONSEGNE,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_CONSEGNE_DT
                     ELSE
                        fgb.SCGB_UTI_CONSEGNE_DT
                  END
                     SCGB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_FIRMA
                     ELSE
                        fgb.SCGB_UTI_FIRMA
                  END
                     SCGB_UTI_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_FIRMA_DT
                     ELSE
                        fgb.SCGB_UTI_FIRMA_DT
                  END
                     SCGB_UTI_FIRMA_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_MASSIMALI
                     ELSE
                        fgb.SCGB_UTI_MASSIMALI
                  END
                     SCGB_UTI_MASSIMALI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_MASSIMALI_DT
                     ELSE
                        fgb.SCGB_UTI_MASSIMALI_DT
                  END
                     SCGB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_RISCHI_INDIRETTI
                     ELSE
                        fgb.SCGB_UTI_RISCHI_INDIRETTI
                  END
                     SCGB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_RISCHI_INDIRETTI_DT
                     ELSE
                        fgb.SCGB_UTI_RISCHI_INDIRETTI_DT
                  END
                     SCGB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_SMOBILIZZO
                     ELSE
                        fgb.SCGB_UTI_SMOBILIZZO
                  END
                     SCGB_UTI_SMOBILIZZO,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_SOSTITUZIONI
                     ELSE
                        fgb.SCGB_UTI_SOSTITUZIONI
                  END
                     SCGB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_UTI_SOSTITUZIONI_DT
                     ELSE
                        fgb.SCGB_UTI_SOSTITUZIONI_DT
                  END
                     SCGB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                          AND NVL (fgb.flg_last_run, '0') = '0'
                     THEN
                        p.SCGB_UTI_TOT
                     ELSE
                        fgb.SCGB_UTI_TOT
                  END
                     SCGB_UTI_TOT,
                  --MAU
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.SCGB_MAU
                     ELSE
                        fgb.SCGB_MAU
                  END
                     SCGB_MAU,
                  --p.GB_VAL_MAU GB_VAL_MAU_1,
                  NVL (
                     p.gb_val_mau,
                     DECODE (
                        NVL (fgb.flg_gruppo_economico, '0'),
                        1, fgb.gegb_mau,
                        DECODE (NVL (fgb.flg_gruppo_legame, '0'),
                                1, fgb.glgb_mau,
                                fgb.scgb_mau)))
                     GB_VAL_MAU_2,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GB_VAL_MAU
                     ELSE
                        NVL (
                           p.gb_val_mau,
                           DECODE (
                              NVL (fgb.flg_gruppo_economico, '0'),
                              1, fgb.gegb_mau,
                              DECODE (NVL (fgb.flg_gruppo_legame, '0'),
                                      1, fgb.glgb_mau,
                                      fgb.scgb_mau)))
                  END
                     GB_VAL_MAU,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GLGB_MAU
                     WHEN NVL (fgb.flg_gruppo_legame, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GLGB_MAU
                  END
                     GLGB_MAU,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_MAU
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_MAU
                  END
                     GEGB_MAU,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_CASSA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_CASSA
                  END
                     GEGB_UTI_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_FIRMA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_FIRMA
                  END
                     GEGB_UTI_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_UTI_TOT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_UTI_TOT
                  END
                     GEGB_UTI_TOT,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_CASSA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_CASSA
                  END
                     GEGB_ACC_CASSA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_FIRMA
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_FIRMA
                  END
                     GEGB_ACC_FIRMA,
                  CASE
                     WHEN     NVL (fgb.flg_last_run, '0') = '0'
                          AND NVL (fgb.id_dper_gb, '00000000') <>
                                 NVL (p.id_dper_gb, '00000000')
                     THEN
                        p.GEGB_ACC_TOT
                     WHEN NVL (fgb.flg_gruppo_economico, '0') = 0
                     THEN
                        NULL
                     ELSE
                        fgb.GEGB_ACC_TOT
                  END
                     GEGB_ACC_TOT
             FROM ttmcre0_pcr_gb fgb,
                  T_MCRE0_dwh_PCR p,
                  ttmcre0_pcr_scsb sc,
                  ttmcre0_pcr_gesb ge
            WHERE     fgb.cod_abi_cartolarizzato =
                         p.cod_abi_cartolarizzato(+)
                  AND fgb.cod_ndg = p.cod_ndg(+)
                  AND fgb.cod_abi_cartolarizzato =
                         sc.cod_abi_cartolarizzato(+)
                  AND fgb.cod_ndg = sc.cod_ndg(+)
                  AND fgb.cod_abi_cartolarizzato =
                         ge.cod_abi_cartolarizzato(+)
                  AND fgb.cod_ndg = ge.cod_ndg(+));
