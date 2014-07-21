/* Formatted on 21/07/2014 18:38:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_TMP_PCR
(
   PCR_ACTION,
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
   DTA_INS,
   GESB_ACC_TOT,
   GESB_UTI_TOT,
   GEGB_MAU,
   GLGB_MAU,
   SCGB_MAU,
   ID_DPER_SCSB,
   ID_DPER_GESB,
   ID_DPER_GB,
   DTA_UPD,
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
   GLGB_ACC_CONSEGNE_DT
)
AS
   SELECT CASE
             WHEN (    gegb_acc_consegne IS NULL
                   AND gegb_acc_consegne_dt IS NULL
                   AND gegb_uti_consegne IS NULL
                   AND gegb_uti_consegne_dt IS NULL
                   AND gesb_acc_consegne IS NULL
                   AND gesb_acc_consegne_dt IS NULL
                   AND gesb_uti_consegne IS NULL
                   AND gesb_uti_consegne_dt IS NULL
                   AND glgb_acc_consegne IS NULL
                   AND glgb_acc_consegne_dt IS NULL
                   AND glgb_uti_consegne IS NULL
                   AND glgb_uti_consegne_dt IS NULL
                   AND scgb_uti_consegne_dt IS NULL
                   AND scgb_uti_consegne IS NULL
                   AND scgb_acc_consegne_dt IS NULL
                   AND scgb_acc_consegne IS NULL
                   AND scsb_uti_consegne_dt IS NULL
                   AND scsb_uti_consegne IS NULL
                   AND scsb_acc_consegne_dt IS NULL
                   AND scsb_acc_consegne IS NULL
                   AND gegb_acc_cassa IS NULL
                   AND gegb_acc_cassa_bt IS NULL
                   AND gegb_acc_cassa_mlt IS NULL
                   AND gegb_acc_firma IS NULL
                   AND gegb_acc_firma_dt IS NULL
                   AND gegb_acc_massimali IS NULL
                   AND gegb_acc_massimali_dt IS NULL
                   AND gegb_acc_rischi_indiretti IS NULL
                   AND gegb_acc_rischi_indiretti_dt IS NULL
                   AND gegb_acc_smobilizzo IS NULL
                   AND gegb_acc_sostituzioni IS NULL
                   AND gegb_acc_sostituzioni_dt IS NULL
                   AND gegb_acc_tot IS NULL
                   AND gegb_uti_cassa IS NULL
                   AND gegb_uti_cassa_bt IS NULL
                   AND gegb_uti_cassa_mlt IS NULL
                   AND gegb_uti_firma IS NULL
                   AND gegb_uti_firma_dt IS NULL
                   AND gegb_uti_massimali IS NULL
                   AND gegb_uti_massimali_dt IS NULL
                   AND gegb_uti_rischi_indiretti IS NULL
                   AND gegb_uti_rischi_indiretti_dt IS NULL
                   AND gegb_uti_smobilizzo IS NULL
                   AND gegb_uti_sostituzioni IS NULL
                   AND gegb_uti_sostituzioni_dt IS NULL
                   AND gegb_uti_tot IS NULL
                   AND gesb_acc_cassa IS NULL
                   AND gesb_acc_cassa_bt IS NULL
                   AND gesb_acc_cassa_mlt IS NULL
                   AND gesb_acc_firma IS NULL
                   AND gesb_acc_firma_dt IS NULL
                   AND gesb_acc_massimali IS NULL
                   AND gesb_acc_massimali_dt IS NULL
                   AND gesb_acc_rischi_indiretti IS NULL
                   AND gesb_acc_rischi_indiretti_dt IS NULL
                   AND gesb_acc_smobilizzo IS NULL
                   AND gesb_acc_sostituzioni IS NULL
                   AND gesb_acc_sostituzioni_dt IS NULL
                   AND gesb_acc_tot IS NULL
                   AND gesb_uti_cassa IS NULL
                   AND gesb_uti_cassa_bt IS NULL
                   AND gesb_uti_cassa_mlt IS NULL
                   AND gesb_uti_firma IS NULL
                   AND gesb_uti_firma_dt IS NULL
                   AND gesb_uti_massimali IS NULL
                   AND gesb_uti_massimali_dt IS NULL
                   AND gesb_uti_rischi_indiretti IS NULL
                   AND gesb_uti_rischi_indiretti_dt IS NULL
                   AND gesb_uti_smobilizzo IS NULL
                   AND gesb_uti_sostituzioni IS NULL
                   AND gesb_uti_sostituzioni_dt IS NULL
                   AND gesb_uti_tot IS NULL
                   AND glgb_acc_cassa IS NULL
                   AND glgb_acc_cassa_bt IS NULL
                   AND glgb_acc_cassa_mlt IS NULL
                   AND glgb_acc_firma IS NULL
                   AND glgb_acc_firma_dt IS NULL
                   AND glgb_acc_massimali IS NULL
                   AND glgb_acc_massimali_dt IS NULL
                   AND glgb_acc_rischi_indiretti IS NULL
                   AND glgb_acc_rischi_indiretti_dt IS NULL
                   AND glgb_acc_smobilizzo IS NULL
                   AND glgb_acc_sostituzioni IS NULL
                   AND glgb_acc_sostituzioni_dt IS NULL
                   AND glgb_acc_tot IS NULL
                   AND glgb_uti_cassa IS NULL
                   AND glgb_uti_cassa_bt IS NULL
                   AND glgb_uti_cassa_mlt IS NULL
                   AND glgb_uti_firma IS NULL
                   AND glgb_uti_firma_dt IS NULL
                   AND glgb_uti_massimali IS NULL
                   AND glgb_uti_massimali_dt IS NULL
                   AND glgb_uti_rischi_indiretti IS NULL
                   AND glgb_uti_rischi_indiretti_dt IS NULL
                   AND glgb_uti_smobilizzo IS NULL
                   AND glgb_uti_sostituzioni IS NULL
                   AND glgb_uti_sostituzioni_dt IS NULL
                   AND glgb_uti_tot IS NULL
                   AND scgb_acc_cassa IS NULL
                   AND scgb_acc_cassa_bt IS NULL
                   AND scgb_acc_cassa_mlt IS NULL
                   AND scgb_acc_firma IS NULL
                   AND scgb_acc_firma_dt IS NULL
                   AND scgb_acc_massimali IS NULL
                   AND scgb_acc_massimali_dt IS NULL
                   AND scgb_acc_rischi_indiretti IS NULL
                   AND scgb_acc_rischi_indiretti_dt IS NULL
                   AND scgb_acc_smobilizzo IS NULL
                   AND scgb_acc_sostituzioni IS NULL
                   AND scgb_acc_sostituzioni_dt IS NULL
                   AND scgb_acc_tot IS NULL
                   AND scgb_uti_cassa IS NULL
                   AND scgb_uti_cassa_bt IS NULL
                   AND scgb_uti_cassa_mlt IS NULL
                   AND scgb_uti_firma IS NULL
                   AND scgb_uti_firma_dt IS NULL
                   AND scgb_uti_massimali IS NULL
                   AND scgb_uti_massimali_dt IS NULL
                   AND scgb_uti_rischi_indiretti IS NULL
                   AND scgb_uti_rischi_indiretti_dt IS NULL
                   AND scgb_uti_smobilizzo IS NULL
                   AND scgb_uti_sostituzioni IS NULL
                   AND scgb_uti_sostituzioni_dt IS NULL
                   AND scgb_uti_tot IS NULL
                   AND scsb_acc_cassa IS NULL
                   AND scsb_acc_cassa_bt IS NULL
                   AND scsb_acc_cassa_mlt IS NULL
                   AND scsb_acc_firma IS NULL
                   AND scsb_acc_firma_dt IS NULL
                   AND scsb_acc_massimali IS NULL
                   AND scsb_acc_massimali_dt IS NULL
                   AND scsb_acc_rischi_indiretti IS NULL
                   AND scsb_acc_rischi_indiretti_dt IS NULL
                   AND scsb_acc_smobilizzo IS NULL
                   AND scsb_acc_sostituzioni IS NULL
                   AND scsb_acc_sostituzioni_dt IS NULL
                   AND scsb_acc_tot IS NULL
                   AND scsb_uti_cassa IS NULL
                   AND scsb_uti_cassa_bt IS NULL
                   AND scsb_uti_cassa_mlt IS NULL
                   AND scsb_uti_firma IS NULL
                   AND scsb_uti_firma_dt IS NULL
                   AND scsb_uti_massimali IS NULL
                   AND scsb_uti_massimali_dt IS NULL
                   AND scsb_uti_rischi_indiretti IS NULL
                   AND scsb_uti_rischi_indiretti_dt IS NULL
                   AND scsb_uti_smobilizzo IS NULL
                   AND scsb_uti_sostituzioni IS NULL
                   AND scsb_uti_sostituzioni_dt IS NULL
                   AND scsb_uti_tot IS NULL)
             THEN
                'del'
             ELSE
                'upd'
          END
             pcr_action,
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
          DTA_INS,
          GESB_ACC_TOT,
          GESB_UTI_TOT,
          GEGB_MAU,
          GLGB_MAU,
          SCGB_MAU,
          ID_DPER_SCSB,
          ID_DPER_GESB,
          ID_DPER_GB,
          DTA_UPD,
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
          GLGB_ACC_CONSEGNE_DT
     FROM t_mcre0_tmp_pcr;
