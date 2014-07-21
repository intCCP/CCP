/* Formatted on 21/07/2014 18:33:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_EVOL_GEST_ESP_SC
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   COD_STATO_AT,
   DTA_CONTROLLO_AT,
   DTA_PCR_AT,
   VAL_SB_ACC_CASSA_BT_AT,
   VAL_SB_UTI_CASSA_BT_AT,
   VAL_SB_ACC_SMOBILIZZO_AT,
   VAL_SB_UTI_SMOBILIZZO_AT,
   VAL_SB_ACC_CASSA_MLT_AT,
   VAL_SB_UTI_CASSA_MLT_AT,
   VAL_SB_ACC_FIRMA_AT,
   VAL_SB_UTI_FIRMA_AT,
   VAL_SB_ACC_TOT_AT,
   VAL_SB_UTI_TOT_AT,
   VAL_SB_TOT_GAR_AT,
   VAL_SB_ACC_SOSTITUZIONI_AT,
   VAL_SB_UTI_SOSTITUZIONI_AT,
   VAL_SB_ACC_MASSIMALI_AT,
   VAL_SB_UTI_MASSIMALI_AT,
   VAL_GB_ACC_CASSA_BT_AT,
   VAL_GB_UTI_CASSA_BT_AT,
   VAL_GB_ACC_SMOBILIZZO_AT,
   VAL_GB_UTI_SMOBILIZZO_AT,
   VAL_GB_ACC_CASSA_MLT_AT,
   VAL_GB_UTI_CASSA_MLT_AT,
   VAL_GB_ACC_FIRMA_AT,
   VAL_GB_UTI_FIRMA_AT,
   VAL_GB_TOT_GAR_AT,
   VAL_GB_ACC_SOSTITUZIONI_AT,
   VAL_GB_UTI_SOSTITUZIONI_AT,
   VAL_GB_ACC_MASSIMALI_AT,
   VAL_GB_UTI_MASSIMALI_AT,
   VAL_GB_UTI_TOT_AT,
   VAL_GB_ACC_TOT_AT,
   VAL_SB_QIS_ACC_AT,
   VAL_SB_QIS_UTI_AT,
   VAL_GB_QIS_ACC_AT,
   VAL_GB_QIS_UTI_AT,
   DTA_CR_AT,
   VAL_GB_ACC_SIS_AT,
   VAL_GB_UTI_SIS_AT,
   COD_STATO_1,
   DTA_CONTROLLO_1,
   DTA_PCR_1,
   DTA_CR_1,
   VAL_SB_ACC_CASSA_BT_1,
   VAL_SB_UTI_CASSA_BT_1,
   VAL_SB_ACC_SMOBILIZZO_1,
   VAL_SB_UTI_SMOBILIZZO_1,
   VAL_SB_ACC_CASSA_MLT_1,
   VAL_SB_UTI_CASSA_MLT_1,
   VAL_SB_ACC_FIRMA_1,
   VAL_SB_UTI_FIRMA_1,
   VAL_SB_ACC_TOT_1,
   VAL_SB_UTI_TOT_1,
   VAL_SB_TOT_GAR_1,
   VAL_SB_ACC_SOSTITUZIONI_1,
   VAL_SB_UTI_SOSTITUZIONI_1,
   VAL_SB_ACC_MASSIMALI_1,
   VAL_SB_UTI_MASSIMALI_1,
   VAL_GB_ACC_CASSA_BT_1,
   VAL_GB_UTI_CASSA_BT_1,
   VAL_GB_ACC_SMOBILIZZO_1,
   VAL_GB_UTI_SMOBILIZZO_1,
   VAL_GB_ACC_CASSA_MLT_1,
   VAL_GB_UTI_CASSA_MLT_1,
   VAL_GB_ACC_FIRMA_1,
   VAL_GB_UTI_FIRMA_1,
   VAL_GB_TOT_GAR_1,
   VAL_GB_ACC_SOSTITUZIONI_1,
   VAL_GB_UTI_SOSTITUZIONI_1,
   VAL_GB_ACC_MASSIMALI_1,
   VAL_GB_UTI_MASSIMALI_1,
   VAL_GB_ACC_TOT_1,
   VAL_GB_UTI_TOT_1,
   VAL_SB_QIS_ACC_1,
   VAL_SB_QIS_UTI_1,
   VAL_GB_QIS_ACC_1,
   VAL_GB_QIS_UTI_1,
   VAL_GB_ACC_SIS_1,
   VAL_GB_UTI_SIS_1,
   COD_STATO_2,
   DTA_CONTROLLO_2,
   DTA_PCR_2,
   DTA_CR_2,
   VAL_SB_ACC_CASSA_BT_2,
   VAL_SB_UTI_CASSA_BT_2,
   VAL_SB_ACC_SMOBILIZZO_2,
   VAL_SB_UTI_SMOBILIZZO_2,
   VAL_SB_ACC_CASSA_MLT_2,
   VAL_SB_UTI_CASSA_MLT_2,
   VAL_SB_ACC_FIRMA_2,
   VAL_SB_UTI_FIRMA_2,
   VAL_SB_ACC_TOT_2,
   VAL_SB_UTI_TOT_2,
   VAL_SB_TOT_GAR_2,
   VAL_SB_ACC_SOSTITUZIONI_2,
   VAL_SB_UTI_SOSTITUZIONI_2,
   VAL_SB_ACC_MASSIMALI_2,
   VAL_SB_UTI_MASSIMALI_2,
   VAL_GB_ACC_CASSA_BT_2,
   VAL_GB_UTI_CASSA_BT_2,
   VAL_GB_ACC_SMOBILIZZO_2,
   VAL_GB_UTI_SMOBILIZZO_2,
   VAL_GB_ACC_CASSA_MLT_2,
   VAL_GB_UTI_CASSA_MLT_2,
   VAL_GB_ACC_FIRMA_2,
   VAL_GB_UTI_FIRMA_2,
   VAL_GB_TOT_GAR_2,
   VAL_GB_ACC_SOSTITUZIONI_2,
   VAL_GB_UTI_SOSTITUZIONI_2,
   VAL_GB_ACC_MASSIMALI_2,
   VAL_GB_UTI_MASSIMALI_2,
   VAL_GB_ACC_TOT_2,
   VAL_GB_UTI_TOT_2,
   VAL_SB_QIS_ACC_2,
   VAL_SB_QIS_UTI_2,
   VAL_GB_QIS_ACC_2,
   VAL_GB_QIS_UTI_2,
   VAL_GB_ACC_SIS_2,
   VAL_GB_UTI_SIS_2,
   COD_STATO_3,
   DTA_CONTROLLO_3,
   DTA_PCR_3,
   DTA_CR_3,
   VAL_SB_ACC_CASSA_BT_3,
   VAL_SB_UTI_CASSA_BT_3,
   VAL_SB_ACC_SMOBILIZZO_3,
   VAL_SB_UTI_SMOBILIZZO_3,
   VAL_SB_ACC_CASSA_MLT_3,
   VAL_SB_UTI_CASSA_MLT_3,
   VAL_SB_ACC_FIRMA_3,
   VAL_SB_UTI_FIRMA_3,
   VAL_SB_ACC_TOT_3,
   VAL_SB_UTI_TOT_3,
   VAL_SB_TOT_GAR_3,
   VAL_SB_ACC_SOSTITUZIONI_3,
   VAL_SB_UTI_SOSTITUZIONI_3,
   VAL_SB_ACC_MASSIMALI_3,
   VAL_SB_UTI_MASSIMALI_3,
   VAL_GB_ACC_CASSA_BT_3,
   VAL_GB_UTI_CASSA_BT_3,
   VAL_GB_ACC_SMOBILIZZO_3,
   VAL_GB_UTI_SMOBILIZZO_3,
   VAL_GB_ACC_CASSA_MLT_3,
   VAL_GB_UTI_CASSA_MLT_3,
   VAL_GB_ACC_FIRMA_3,
   VAL_GB_UTI_FIRMA_3,
   VAL_GB_TOT_GAR_3,
   VAL_GB_ACC_SOSTITUZIONI_3,
   VAL_GB_UTI_SOSTITUZIONI_3,
   VAL_GB_ACC_MASSIMALI_3,
   VAL_GB_UTI_MASSIMALI_3,
   VAL_GB_ACC_TOT_3,
   VAL_GB_UTI_TOT_3,
   VAL_SB_QIS_ACC_3,
   VAL_SB_QIS_UTI_3,
   VAL_GB_QIS_ACC_3,
   VAL_GB_QIS_UTI_3,
   VAL_GB_ACC_SIS_3,
   VAL_GB_UTI_SIS_3,
   COD_STATO_4,
   DTA_CONTROLLO_4,
   DTA_PCR_4,
   DTA_CR_4,
   VAL_SB_ACC_CASSA_BT_4,
   VAL_SB_UTI_CASSA_BT_4,
   VAL_SB_ACC_SMOBILIZZO_4,
   VAL_SB_UTI_SMOBILIZZO_4,
   VAL_SB_ACC_CASSA_MLT_4,
   VAL_SB_UTI_CASSA_MLT_4,
   VAL_SB_ACC_FIRMA_4,
   VAL_SB_UTI_FIRMA_4,
   VAL_SB_ACC_TOT_4,
   VAL_SB_UTI_TOT_4,
   VAL_SB_TOT_GAR_4,
   VAL_SB_ACC_SOSTITUZIONI_4,
   VAL_SB_UTI_SOSTITUZIONI_4,
   VAL_SB_ACC_MASSIMALI_4,
   VAL_SB_UTI_MASSIMALI_4,
   VAL_GB_ACC_CASSA_BT_4,
   VAL_GB_UTI_CASSA_BT_4,
   VAL_GB_ACC_SMOBILIZZO_4,
   VAL_GB_UTI_SMOBILIZZO_4,
   VAL_GB_ACC_CASSA_MLT_4,
   VAL_GB_UTI_CASSA_MLT_4,
   VAL_GB_ACC_FIRMA_4,
   VAL_GB_UTI_FIRMA_4,
   VAL_GB_TOT_GAR_4,
   VAL_GB_ACC_SOSTITUZIONI_4,
   VAL_GB_UTI_SOSTITUZIONI_4,
   VAL_GB_ACC_MASSIMALI_4,
   VAL_GB_UTI_MASSIMALI_4,
   VAL_GB_ACC_TOT_4,
   VAL_GB_UTI_TOT_4,
   VAL_SB_QIS_ACC_4,
   VAL_SB_QIS_UTI_4,
   VAL_GB_QIS_ACC_4,
   VAL_GB_QIS_UTI_4,
   VAL_GB_ACC_SIS_4,
   VAL_GB_UTI_SIS_4,
   COD_STATO_5,
   DTA_CONTROLLO_5,
   DTA_PCR_5,
   DTA_CR_5,
   VAL_SB_ACC_CASSA_BT_5,
   VAL_SB_UTI_CASSA_BT_5,
   VAL_SB_ACC_SMOBILIZZO_5,
   VAL_SB_UTI_SMOBILIZZO_5,
   VAL_SB_ACC_CASSA_MLT_5,
   VAL_SB_UTI_CASSA_MLT_5,
   VAL_SB_ACC_FIRMA_5,
   VAL_SB_UTI_FIRMA_5,
   VAL_SB_ACC_TOT_5,
   VAL_SB_UTI_TOT_5,
   VAL_SB_TOT_GAR_5,
   VAL_SB_ACC_SOSTITUZIONI_5,
   VAL_SB_UTI_SOSTITUZIONI_5,
   VAL_SB_ACC_MASSIMALI_5,
   VAL_SB_UTI_MASSIMALI_5,
   VAL_GB_ACC_CASSA_BT_5,
   VAL_GB_UTI_CASSA_BT_5,
   VAL_GB_ACC_SMOBILIZZO_5,
   VAL_GB_UTI_SMOBILIZZO_5,
   VAL_GB_ACC_CASSA_MLT_5,
   VAL_GB_UTI_CASSA_MLT_5,
   VAL_GB_ACC_FIRMA_5,
   VAL_GB_UTI_FIRMA_5,
   VAL_GB_TOT_GAR_5,
   VAL_GB_ACC_SOSTITUZIONI_5,
   VAL_GB_UTI_SOSTITUZIONI_5,
   VAL_GB_ACC_MASSIMALI_5,
   VAL_GB_UTI_MASSIMALI_5,
   VAL_GB_ACC_TOT_5,
   VAL_GB_UTI_TOT_5,
   VAL_SB_QIS_ACC_5,
   VAL_SB_QIS_UTI_5,
   VAL_GB_QIS_ACC_5,
   VAL_GB_QIS_UTI_5,
   VAL_GB_ACC_SIS_5,
   VAL_GB_UTI_SIS_5,
   COD_STATO_6,
   DTA_CONTROLLO_6,
   DTA_PCR_6,
   DTA_CR_6,
   VAL_SB_ACC_CASSA_BT_6,
   VAL_SB_UTI_CASSA_BT_6,
   VAL_SB_ACC_SMOBILIZZO_6,
   VAL_SB_UTI_SMOBILIZZO_6,
   VAL_SB_ACC_CASSA_MLT_6,
   VAL_SB_UTI_CASSA_MLT_6,
   VAL_SB_ACC_FIRMA_6,
   VAL_SB_UTI_FIRMA_6,
   VAL_SB_ACC_TOT_6,
   VAL_SB_UTI_TOT_6,
   VAL_SB_TOT_GAR_6,
   VAL_SB_ACC_SOSTITUZIONI_6,
   VAL_SB_UTI_SOSTITUZIONI_6,
   VAL_SB_ACC_MASSIMALI_6,
   VAL_SB_UTI_MASSIMALI_6,
   VAL_GB_ACC_CASSA_BT_6,
   VAL_GB_UTI_CASSA_BT_6,
   VAL_GB_ACC_SMOBILIZZO_6,
   VAL_GB_UTI_SMOBILIZZO_6,
   VAL_GB_ACC_CASSA_MLT_6,
   VAL_GB_UTI_CASSA_MLT_6,
   VAL_GB_ACC_FIRMA_6,
   VAL_GB_UTI_FIRMA_6,
   VAL_GB_TOT_GAR_6,
   VAL_GB_ACC_SOSTITUZIONI_6,
   VAL_GB_UTI_SOSTITUZIONI_6,
   VAL_GB_ACC_MASSIMALI_6,
   VAL_GB_UTI_MASSIMALI_6,
   VAL_GB_ACC_TOT_6,
   VAL_GB_UTI_TOT_6,
   VAL_SB_QIS_ACC_6,
   VAL_SB_QIS_UTI_6,
   VAL_GB_QIS_ACC_6,
   VAL_GB_QIS_UTI_6,
   VAL_GB_ACC_SIS_6,
   VAL_GB_UTI_SIS_6,
   DTA_CONTROLLO_PC,
   COD_STATO_PC,
   DTA_PCR_PC,
   DTA_CR_PC,
   VAL_SB_ACC_CASSA_BT_PC,
   VAL_SB_UTI_CASSA_BT_PC,
   VAL_SB_ACC_SMOBILIZZO_PC,
   VAL_SB_UTI_SMOBILIZZO_PC,
   VAL_SB_ACC_CASSA_MLT_PC,
   VAL_SB_UTI_CASSA_MLT_PC,
   VAL_SB_ACC_FIRMA_PC,
   VAL_SB_UTI_FIRMA_PC,
   VAL_SB_ACC_TOT_PC,
   VAL_SB_UTI_TOT_PC,
   VAL_SB_TOT_GAR_PC,
   VAL_SB_ACC_SOSTITUZIONI_PC,
   VAL_SB_UTI_SOSTITUZIONI_PC,
   VAL_SB_ACC_MASSIMALI_PC,
   VAL_SB_UTI_MASSIMALI_PC,
   VAL_GB_ACC_CASSA_BT_PC,
   VAL_GB_UTI_CASSA_BT_PC,
   VAL_GB_ACC_SMOBILIZZO_PC,
   VAL_GB_UTI_SMOBILIZZO_PC,
   VAL_GB_ACC_CASSA_MLT_PC,
   VAL_GB_UTI_CASSA_MLT_PC,
   VAL_GB_ACC_FIRMA_PC,
   VAL_GB_UTI_FIRMA_PC,
   VAL_GB_TOT_GAR_PC,
   VAL_GB_ACC_SOSTITUZIONI_PC,
   VAL_GB_UTI_SOSTITUZIONI_PC,
   VAL_GB_ACC_MASSIMALI_PC,
   VAL_GB_UTI_MASSIMALI_PC,
   VAL_GB_ACC_TOT_PC,
   VAL_GB_UTI_TOT_PC,
   VAL_SB_QIS_ACC_PC,
   VAL_SB_QIS_UTI_PC,
   VAL_GB_QIS_ACC_PC,
   VAL_GB_QIS_UTI_PC,
   VAL_GB_ACC_SIS_PC,
   VAL_GB_UTI_SIS_PC
)
AS
   SELECT d.cod_abi_cartolarizzato,
          d.cod_abi_istituto,
          d.desc_istituto,
          d.cod_ndg,
          d.cod_sndg,
          x.cod_stato cod_stato_at,
          d.dta_controllo_at,
          d.dta_pcr_at,
          d.scsb_acc_cassa_bt_at,
          d.scsb_uti_cassa_bt_at,
          d.scsb_acc_smobilizzo_at,
          d.scsb_uti_smobilizzo_at,
          d.scsb_acc_cassa_mlt_at,
          d.scsb_uti_cassa_mlt_at,
          d.scsb_acc_firma_at,
          d.scsb_uti_firma_at,
          d.scsb_acc_tot_at,
          d.scsb_uti_tot_at,
          d.scsb_tot_gar_at,
          --
          d.scsb_acc_sostituzioni_at,
          d.scsb_uti_sostituzioni_at,
          d.scsb_acc_massimali_at,
          d.scsb_uti_massimali_at,
          --
          d.scgb_acc_cassa_bt_at,
          d.scgb_uti_cassa_bt_at,
          d.scgb_acc_smobilizzo_at,
          d.scgb_uti_smobilizzo_at,
          d.scgb_acc_cassa_mlt_at,
          d.scgb_uti_cassa_mlt_at,
          d.scgb_acc_firma_at,
          d.scgb_uti_firma_at,
          d.scgb_tot_gar_at,
          --
          d.scgb_acc_sostituzioni_at,
          d.scgb_uti_sostituzioni_at,
          d.scgb_acc_massimali_at,
          d.scgb_uti_massimali_at,
          --
          d.scgb_uti_tot_at,
          d.scgb_acc_tot_at,
          d.scsb_qis_acc_at,
          d.scsb_qis_uti_at,
          d.scgb_qis_acc_at,
          d.scgb_qis_uti_at,
          d.dta_cr_at,
          d.scgb_acc_sis_at,
          d.scgb_uti_sis_at,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, NULL,
                  d.cod_stato_1)
             cod_stato_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_DATE (NULL),
                  d.dta_controllo_1)
             dta_controllo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_DATE (NULL),
                  d.dta_pcr_1)
             dta_pcr_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_DATE (NULL),
                  d.dta_cr_1)
             dta_cr_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_1)
             scsb_acc_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_1)
             scsb_uti_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_1)
             scsb_acc_smobilizzo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_1)
             scsb_uti_smobilizzo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_1)
             scsb_acc_cassa_mlt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_1)
             scsb_uti_cassa_mlt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_1)
             scsb_acc_firma_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_1)
             scsb_uti_firma_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_1)
             scsb_acc_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_1)
             scsb_uti_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_1)
             scsb_tot_gar_1,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_1)
             scsb_acc_sostituzioni_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_1)
             scsb_uti_sostituzioni_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_1)
             scsb_acc_massimali_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_1)
             scsb_uti_massimali_1,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_1)
             scgb_acc_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_1)
             scgb_uti_cassa_bt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_1)
             scgb_acc_smobilizzo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_1)
             scgb_uti_smobilizzo_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_1)
             scgb_acc_cassa_mlt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_1)
             scgb_uti_cassa_mlt_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_1)
             scgb_acc_firma_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_1)
             scgb_uti_firma_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_1)
             scgb_tot_gar_1,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_1)
             scgb_acc_sostituzioni_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_1)
             scgb_uti_sostituzioni_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_1)
             scgb_acc_massimali_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_1)
             scgb_uti_massimali_1,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_1)
             scgb_acc_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_1)
             scgb_uti_tot_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_1)
             scsb_qis_acc_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_1)
             scsb_qis_uti_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_1)
             scgb_qis_acc_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_1)
             scgb_qis_uti_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_1)
             scgb_acc_sis_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_1)
             scgb_uti_sis_1,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, NULL,
                  d.cod_stato_2)
             cod_stato_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_DATE (NULL),
                  d.dta_controllo_2)
             dta_controllo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_DATE (NULL),
                  d.dta_pcr_2)
             dta_pcr_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_DATE (NULL),
                  d.dta_cr_2)
             dta_cr_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_2)
             scsb_acc_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_2)
             scsb_uti_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_2)
             scsb_acc_smobilizzo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_2)
             scsb_uti_smobilizzo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_2)
             scsb_acc_cassa_mlt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_2)
             scsb_uti_cassa_mlt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_2)
             scsb_acc_firma_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_2)
             scsb_uti_firma_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_2)
             scsb_acc_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_2)
             scsb_uti_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_2)
             scsb_tot_gar_2,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_2)
             scsb_acc_sostituzioni_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_2)
             scsb_uti_sostituzioni_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_2)
             scsb_acc_massimali_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_2)
             scsb_uti_massimali_2,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_2)
             scgb_acc_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_2)
             scgb_uti_cassa_bt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_2)
             scgb_acc_smobilizzo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_2)
             scgb_uti_smobilizzo_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_2)
             scgb_acc_cassa_mlt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_2)
             scgb_uti_cassa_mlt_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_2)
             scgb_acc_firma_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_2)
             scgb_uti_firma_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_2)
             scgb_tot_gar_2,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_2)
             scgb_acc_sostituzioni_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_2)
             scgb_uti_sostituzioni_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_2)
             scgb_acc_massimali_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_2)
             scgb_uti_massimali_2,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_2)
             scgb_acc_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_2)
             scgb_uti_tot_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_2)
             scsb_qis_acc_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_2)
             scsb_qis_uti_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_2)
             scgb_qis_acc_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_2),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_2)
             scgb_qis_uti_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_2)
             scgb_acc_sis_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_2)
             scgb_uti_sis_2,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, NULL,
                  d.cod_stato_3)
             cod_stato_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_DATE (NULL),
                  d.dta_controllo_3)
             dta_controllo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_DATE (NULL),
                  d.dta_pcr_3)
             dta_pcr_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_DATE (NULL),
                  d.dta_cr_3)
             dta_cr_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_3)
             scsb_acc_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_3)
             scsb_uti_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_3)
             scsb_acc_smobilizzo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_3)
             scsb_uti_smobilizzo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_3)
             scsb_acc_cassa_mlt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_3)
             scsb_uti_cassa_mlt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_3)
             scsb_acc_firma_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_3)
             scsb_uti_firma_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_3)
             scsb_acc_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_3)
             scsb_uti_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_3)
             scsb_tot_gar_3,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_3)
             scsb_acc_sostituzioni_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_3)
             scsb_uti_sostituzioni_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_3)
             scsb_acc_massimali_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_3)
             scsb_uti_massimali_3,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_3)
             scgb_acc_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_3)
             scgb_uti_cassa_bt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_3)
             scgb_acc_smobilizzo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_3)
             scgb_uti_smobilizzo_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_3)
             scgb_acc_cassa_mlt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_3)
             scgb_uti_cassa_mlt_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_3)
             scgb_acc_firma_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_3)
             scgb_uti_firma_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_3)
             scgb_tot_gar_3,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_3)
             scgb_acc_sostituzioni_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_3)
             scgb_uti_sostituzioni_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_3)
             scgb_acc_massimali_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_3)
             scgb_uti_massimali_3,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_3)
             scgb_acc_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_3)
             scgb_uti_tot_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_3)
             scsb_qis_acc_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_3)
             scsb_qis_uti_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_3)
             scgb_qis_acc_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_3),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_3)
             scgb_qis_uti_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_3)
             scgb_acc_sis_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_3)
             scgb_uti_sis_3,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, NULL,
                  d.cod_stato_4)
             cod_stato_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_DATE (NULL),
                  d.dta_controllo_4)
             dta_controllo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_DATE (NULL),
                  d.dta_pcr_4)
             dta_pcr_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_DATE (NULL),
                  d.dta_cr_4)
             dta_cr_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_4)
             scsb_acc_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_4)
             scsb_uti_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_4)
             scsb_acc_smobilizzo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_4)
             scsb_uti_smobilizzo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_4)
             scsb_acc_cassa_mlt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_4)
             scsb_uti_cassa_mlt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_4)
             scsb_acc_firma_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_4)
             scsb_uti_firma_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_4)
             scsb_acc_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_4)
             scsb_uti_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_4)
             scsb_tot_gar_4,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_4)
             scsb_acc_sostituzioni_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_4)
             scsb_uti_sostituzioni_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_4)
             scsb_acc_massimali_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_4)
             scsb_uti_massimali_4,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_4)
             scgb_acc_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_4)
             scgb_uti_cassa_bt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_4)
             scgb_acc_smobilizzo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_4)
             scgb_uti_smobilizzo_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_4)
             scgb_acc_cassa_mlt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_4)
             scgb_uti_cassa_mlt_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_4)
             scgb_acc_firma_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_4)
             scgb_uti_firma_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_4)
             scgb_tot_gar_4,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_4)
             scgb_acc_sostituzioni_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_4)
             scgb_uti_sostituzioni_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_4)
             scgb_acc_massimali_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_4)
             scgb_uti_massimali_4,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_4)
             scgb_acc_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_4)
             scgb_uti_tot_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_4)
             scsb_qis_acc_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_4)
             scsb_qis_uti_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_4)
             scgb_qis_acc_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_4),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_4)
             scgb_qis_uti_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_4)
             scgb_acc_sis_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_4)
             scgb_uti_sis_4,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, NULL,
                  d.cod_stato_5)
             cod_stato_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_DATE (NULL),
                  d.dta_controllo_5)
             dta_controllo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_DATE (NULL),
                  d.dta_pcr_5)
             dta_pcr_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_DATE (NULL),
                  d.dta_cr_5)
             dta_cr_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_5)
             scsb_acc_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_5)
             scsb_uti_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_5)
             scsb_acc_smobilizzo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_5)
             scsb_uti_smobilizzo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_5)
             scsb_acc_cassa_mlt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_5)
             scsb_uti_cassa_mlt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_5)
             scsb_acc_firma_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_5)
             scsb_uti_firma_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_5)
             scsb_acc_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_5)
             scsb_uti_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_5)
             scsb_tot_gar_5,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_5)
             scsb_acc_sostituzioni_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_5)
             scsb_uti_sostituzioni_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_5)
             scsb_acc_massimali_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_5)
             scsb_uti_massimali_5,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_5)
             scgb_acc_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_5)
             scgb_uti_cassa_bt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_5)
             scgb_acc_smobilizzo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_5)
             scgb_uti_smobilizzo_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_5)
             scgb_acc_cassa_mlt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_5)
             scgb_uti_cassa_mlt_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_5)
             scgb_acc_firma_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_5)
             scgb_uti_firma_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_5)
             scgb_tot_gar_5,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_5)
             scgb_acc_sostituzioni_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_5)
             scgb_uti_sostituzioni_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_5)
             scgb_acc_massimali_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_5)
             scgb_uti_massimali_5,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_5)
             scgb_acc_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_5)
             scgb_uti_tot_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_5)
             scsb_qis_acc_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_5)
             scsb_qis_uti_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_5)
             scgb_qis_acc_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_5),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_5)
             scgb_qis_uti_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_5)
             scgb_acc_sis_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_5)
             scgb_uti_sis_5,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, NULL,
                  d.cod_stato_6)
             cod_stato_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_DATE (NULL),
                  d.dta_controllo_6)
             dta_controllo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_DATE (NULL),
                  d.dta_pcr_6)
             dta_pcr_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_DATE (NULL),
                  d.dta_cr_6)
             dta_cr_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_bt_6)
             scsb_acc_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_bt_6)
             scsb_uti_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_smobilizzo_6)
             scsb_acc_smobilizzo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_smobilizzo_6)
             scsb_uti_smobilizzo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_cassa_mlt_6)
             scsb_acc_cassa_mlt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_cassa_mlt_6)
             scsb_uti_cassa_mlt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_firma_6)
             scsb_acc_firma_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_firma_6)
             scsb_uti_firma_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_tot_6)
             scsb_acc_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_tot_6)
             scsb_uti_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_tot_gar_6)
             scsb_tot_gar_6,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_sostituzioni_6)
             scsb_acc_sostituzioni_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_sostituzioni_6)
             scsb_uti_sostituzioni_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_acc_massimali_6)
             scsb_acc_massimali_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_uti_massimali_6)
             scsb_uti_massimali_6,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_bt_6)
             scgb_acc_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_bt_6)
             scgb_uti_cassa_bt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_smobilizzo_6)
             scgb_acc_smobilizzo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_smobilizzo_6)
             scgb_uti_smobilizzo_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_cassa_mlt_6)
             scgb_acc_cassa_mlt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_cassa_mlt_6)
             scgb_uti_cassa_mlt_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_firma_6)
             scgb_acc_firma_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_firma_6)
             scgb_uti_firma_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_tot_gar_6)
             scgb_tot_gar_6,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sostituzioni_6)
             scgb_acc_sostituzioni_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sostituzioni_6)
             scgb_uti_sostituzioni_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_massimali_6)
             scgb_acc_massimali_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_massimali_6)
             scgb_uti_massimali_6,
          --
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_tot_6)
             scgb_acc_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_tot_6)
             scgb_uti_tot_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_acc_6)
             scsb_qis_acc_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scsb_qis_uti_6)
             scsb_qis_uti_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_acc_6)
             scgb_qis_acc_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_6),
                  1, TO_NUMBER (NULL),
                  d.scgb_qis_uti_6)
             scgb_qis_uti_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_acc_sis_6)
             scgb_acc_sis_6,
          DECODE (SIGN (f.dta_fine_validita - d.dta_controllo_1),
                  1, TO_NUMBER (NULL),
                  d.scgb_uti_sis_6)
             scgb_uti_sis_6,
          f.dta_fine_validita_rc dta_controllo_pc,
          f.cod_stato cod_stato_pc,
          TRUNC (f.scsb_dta_riferimento) dta_pcr_pc,
          TRUNC (f.scgb_dta_rif_cr) dta_cr_pc,
          f.scsb_acc_cassa_bt scsb_acc_cassa_bt_pc,
          f.scsb_uti_cassa_bt scsb_uti_cassa_bt_pc,
          f.scsb_acc_smobilizzo scsb_acc_smobilizzo_pc,
          f.scsb_uti_smobilizzo scsb_uti_smobilizzo_pc,
          f.scsb_acc_cassa_mlt scsb_acc_cassa_mlt_pc,
          f.scsb_uti_cassa_mlt scsb_uti_cassa_mlt_pc,
          f.scsb_acc_firma scsb_acc_firma_pc,
          f.scsb_uti_firma scsb_uti_firma_pc,
          f.scsb_acc_cassa + f.scsb_acc_firma scsb_acc_tot_pc,
          f.scsb_uti_cassa + f.scsb_uti_firma scsb_uti_tot_pc,
          f.scsb_tot_gar scsb_tot_gar_pc,
          --
          f.scsb_acc_sostituzioni scsb_acc_sostituzioni_pc,
          f.scsb_uti_sostituzioni scsb_uti_sostituzioni_pc,
          f.scsb_acc_massimali scsb_acc_massimali_pc,
          f.scsb_uti_massimali scsb_uti_massimali_pc,
          --
          f.scgb_acc_cassa_bt scgb_acc_cassa_bt_pc,
          f.scgb_uti_cassa_bt scgb_uti_cassa_bt_pc,
          f.scgb_acc_smobilizzo scgb_acc_smobilizzo_pc,
          f.scgb_uti_smobilizzo scgb_uti_smobilizzo_pc,
          f.scgb_acc_cassa_mlt scgb_acc_cassa_mlt_pc,
          f.scgb_uti_cassa_mlt scgb_uti_cassa_mlt_pc,
          f.scgb_acc_firma scgb_acc_firma_pc,
          f.scgb_uti_firma scgb_uti_firma_pc,
          f.scgb_tot_gar scgb_tot_gar_pc,
          --
          f.scgb_acc_sostituzioni scgb_acc_sostituzioni_pc,
          f.scgb_uti_sostituzioni scgb_uti_sostituzioni_pc,
          f.scgb_acc_massimali scgb_acc_massimali_pc,
          f.scgb_uti_massimali scgb_uti_massimali_pc,
          --
          f.scgb_acc_cassa + f.scgb_acc_firma scgb_acc_tot_pc,
          f.scgb_uti_cassa + f.scgb_uti_firma scgb_uti_tot_pc,
          TO_NUMBER (NULLIF (f.scsb_qis_acc, 'N.D.')) scsb_qis_acc_pc,
          TO_NUMBER (NULLIF (f.scsb_qis_uti, 'N.D.')) scsb_qis_uti_pc,
          TO_NUMBER (NULLIF (f.scgb_qis_acc, 'N.D.')) scgb_qis_acc_pc,
          TO_NUMBER (NULLIF (f.scgb_qis_uti, 'N.D.')) scgb_qis_uti_pc,
          f.scgb_acc_sis scgb_acc_sis_pc,
          f.scgb_uti_sis scgb_uti_sis_pc
     FROM mv_mcre0_app_gest_esp_sc d,
          v_mcre0_app_upd_fields_p1 x,
          (SELECT *
             FROM (SELECT e1.*,
                          MAX (
                             e1.dta_fine_validita)
                          OVER (
                             PARTITION BY e1.cod_abi_cartolarizzato,
                                          e1.cod_ndg)
                             dta_fine_validita_rc
                     FROM t_mcre0_app_storico_eventi e1
                    WHERE e1.flg_cambio_gestore = '1') e2
            WHERE dta_fine_validita_rc = dta_fine_validita) f
    WHERE     d.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = x.cod_ndg(+)
          AND d.cod_abi_cartolarizzato = f.cod_abi_cartolarizzato(+)
          AND d.cod_ndg = f.cod_ndg(+);

COMMENT ON COLUMN MCRE_OWN.V_MCRE0_APP_EVOL_GEST_ESP_SC.COD_ABI_CARTOLARIZZATO IS 'COD_ABI';
