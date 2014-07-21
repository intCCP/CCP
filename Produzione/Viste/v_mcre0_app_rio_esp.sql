/* Formatted on 17/06/2014 18:03:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ESP
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DTA_CONTROLLO_AT,
   COD_STATO_1,
   DTA_CONTROLLO_1,
   COD_STATO_2,
   DTA_CONTROLLO_2,
   COD_STATO_3,
   DTA_CONTROLLO_3,
   COD_STATO_4,
   DTA_CONTROLLO_4,
   COD_STATO_5,
   DTA_CONTROLLO_5,
   COD_STATO_6,
   DTA_CONTROLLO_6,
   SCSB_DTA_PCR_AT,
   SCSB_DTA_CR_AT,
   SCSB_ACC_CASSA_BT_AT,
   SCSB_UTI_CASSA_BT_AT,
   SCSB_ACC_SMOBILIZZO_AT,
   SCSB_UTI_SMOBILIZZO_AT,
   SCSB_ACC_CASSA_MLT_AT,
   SCSB_UTI_CASSA_MLT_AT,
   SCSB_ACC_FIRMA_AT,
   SCSB_UTI_FIRMA_AT,
   SCSB_ACC_TOT_AT,
   SCSB_UTI_TOT_AT,
   SCSB_TOT_GAR_AT,
   SCSB_ACC_SOSTITUZIONI_AT,
   SCSB_UTI_SOSTITUZIONI_AT,
   SCSB_ACC_MASSIMALI_AT,
   SCSB_UTI_MASSIMALI_AT,
   SCGB_ACC_SOSTITUZIONI_AT,
   SCGB_UTI_SOSTITUZIONI_AT,
   SCGB_ACC_MASSIMALI_AT,
   SCGB_UTI_MASSIMALI_AT,
   SCGB_ACC_CASSA_BT_AT,
   SCGB_UTI_CASSA_BT_AT,
   SCGB_ACC_SMOBILIZZO_AT,
   SCGB_UTI_SMOBILIZZO_AT,
   SCGB_ACC_CASSA_MLT_AT,
   SCGB_UTI_CASSA_MLT_AT,
   SCGB_ACC_FIRMA_AT,
   SCGB_UTI_FIRMA_AT,
   SCGB_TOT_GAR_AT,
   SCGB_ACC_TOT_AT,
   SCGB_UTI_TOT_AT,
   SCSB_QIS_ACC_AT,
   SCSB_QIS_UTI_AT,
   SCGB_QIS_ACC_AT,
   SCGB_QIS_UTI_AT,
   SCGB_ACC_SIS_AT,
   SCGB_UTI_SIS_AT,
   SCSB_DTA_PCR_1,
   SCSB_DTA_CR_1,
   SCSB_ACC_CASSA_BT_1,
   SCSB_UTI_CASSA_BT_1,
   SCSB_ACC_SMOBILIZZO_1,
   SCSB_UTI_SMOBILIZZO_1,
   SCSB_ACC_CASSA_MLT_1,
   SCSB_UTI_CASSA_MLT_1,
   SCSB_ACC_FIRMA_1,
   SCSB_UTI_FIRMA_1,
   SCSB_ACC_TOT_1,
   SCSB_UTI_TOT_1,
   SCSB_TOT_GAR_1,
   SCSB_ACC_SOSTITUZIONI_1,
   SCSB_UTI_SOSTITUZIONI_1,
   SCSB_ACC_MASSIMALI_1,
   SCSB_UTI_MASSIMALI_1,
   SCGB_ACC_SOSTITUZIONI_1,
   SCGB_UTI_SOSTITUZIONI_1,
   SCGB_ACC_MASSIMALI_1,
   SCGB_UTI_MASSIMALI_1,
   SCGB_ACC_CASSA_BT_1,
   SCGB_UTI_CASSA_BT_1,
   SCGB_ACC_SMOBILIZZO_1,
   SCGB_UTI_SMOBILIZZO_1,
   SCGB_ACC_CASSA_MLT_1,
   SCGB_UTI_CASSA_MLT_1,
   SCGB_ACC_FIRMA_1,
   SCGB_UTI_FIRMA_1,
   SCGB_TOT_GAR_1,
   SCGB_ACC_TOT_1,
   SCGB_UTI_TOT_1,
   SCSB_QIS_ACC_1,
   SCSB_QIS_UTI_1,
   SCGB_QIS_ACC_1,
   SCGB_QIS_UTI_1,
   SCGB_ACC_SIS_1,
   SCGB_UTI_SIS_1,
   SCSB_DTA_PCR_2,
   SCSB_DTA_CR_2,
   SCSB_ACC_CASSA_BT_2,
   SCSB_UTI_CASSA_BT_2,
   SCSB_ACC_SMOBILIZZO_2,
   SCSB_UTI_SMOBILIZZO_2,
   SCSB_ACC_CASSA_MLT_2,
   SCSB_UTI_CASSA_MLT_2,
   SCSB_ACC_FIRMA_2,
   SCSB_UTI_FIRMA_2,
   SCSB_ACC_TOT_2,
   SCSB_UTI_TOT_2,
   SCSB_TOT_GAR_2,
   SCSB_ACC_SOSTITUZIONI_2,
   SCSB_UTI_SOSTITUZIONI_2,
   SCSB_ACC_MASSIMALI_2,
   SCSB_UTI_MASSIMALI_2,
   SCGB_ACC_SOSTITUZIONI_2,
   SCGB_UTI_SOSTITUZIONI_2,
   SCGB_ACC_MASSIMALI_2,
   SCGB_UTI_MASSIMALI_2,
   SCGB_ACC_CASSA_BT_2,
   SCGB_UTI_CASSA_BT_2,
   SCGB_ACC_SMOBILIZZO_2,
   SCGB_UTI_SMOBILIZZO_2,
   SCGB_ACC_CASSA_MLT_2,
   SCGB_UTI_CASSA_MLT_2,
   SCGB_ACC_FIRMA_2,
   SCGB_UTI_FIRMA_2,
   SCGB_TOT_GAR_2,
   SCGB_ACC_TOT_2,
   SCGB_UTI_TOT_2,
   SCSB_QIS_ACC_2,
   SCSB_QIS_UTI_2,
   SCGB_QIS_ACC_2,
   SCGB_QIS_UTI_2,
   SCGB_ACC_SIS_2,
   SCGB_UTI_SIS_2,
   SCSB_DTA_PCR_3,
   SCSB_DTA_CR_3,
   SCSB_ACC_CASSA_BT_3,
   SCSB_UTI_CASSA_BT_3,
   SCSB_ACC_SMOBILIZZO_3,
   SCSB_UTI_SMOBILIZZO_3,
   SCSB_ACC_CASSA_MLT_3,
   SCSB_UTI_CASSA_MLT_3,
   SCSB_ACC_FIRMA_3,
   SCSB_UTI_FIRMA_3,
   SCSB_ACC_TOT_3,
   SCSB_UTI_TOT_3,
   SCSB_TOT_GAR_3,
   SCSB_ACC_SOSTITUZIONI_3,
   SCSB_UTI_SOSTITUZIONI_3,
   SCSB_ACC_MASSIMALI_3,
   SCSB_UTI_MASSIMALI_3,
   SCGB_ACC_SOSTITUZIONI_3,
   SCGB_UTI_SOSTITUZIONI_3,
   SCGB_ACC_MASSIMALI_3,
   SCGB_UTI_MASSIMALI_3,
   SCGB_ACC_CASSA_BT_3,
   SCGB_UTI_CASSA_BT_3,
   SCGB_ACC_SMOBILIZZO_3,
   SCGB_UTI_SMOBILIZZO_3,
   SCGB_ACC_CASSA_MLT_3,
   SCGB_UTI_CASSA_MLT_3,
   SCGB_ACC_FIRMA_3,
   SCGB_UTI_FIRMA_3,
   SCGB_TOT_GAR_3,
   SCGB_ACC_TOT_3,
   SCGB_UTI_TOT_3,
   SCSB_QIS_ACC_3,
   SCSB_QIS_UTI_3,
   SCGB_QIS_ACC_3,
   SCGB_QIS_UTI_3,
   SCGB_ACC_SIS_3,
   SCGB_UTI_SIS_3,
   SCSB_DTA_PCR_4,
   SCSB_DTA_CR_4,
   SCSB_ACC_CASSA_BT_4,
   SCSB_UTI_CASSA_BT_4,
   SCSB_ACC_SMOBILIZZO_4,
   SCSB_UTI_SMOBILIZZO_4,
   SCSB_ACC_CASSA_MLT_4,
   SCSB_UTI_CASSA_MLT_4,
   SCSB_ACC_FIRMA_4,
   SCSB_UTI_FIRMA_4,
   SCSB_ACC_TOT_4,
   SCSB_UTI_TOT_4,
   SCSB_TOT_GAR_4,
   SCSB_ACC_SOSTITUZIONI_4,
   SCSB_UTI_SOSTITUZIONI_4,
   SCSB_ACC_MASSIMALI_4,
   SCSB_UTI_MASSIMALI_4,
   SCGB_ACC_SOSTITUZIONI_4,
   SCGB_UTI_SOSTITUZIONI_4,
   SCGB_ACC_MASSIMALI_4,
   SCGB_UTI_MASSIMALI_4,
   SCGB_ACC_CASSA_BT_4,
   SCGB_UTI_CASSA_BT_4,
   SCGB_ACC_SMOBILIZZO_4,
   SCGB_UTI_SMOBILIZZO_4,
   SCGB_ACC_CASSA_MLT_4,
   SCGB_UTI_CASSA_MLT_4,
   SCGB_ACC_FIRMA_4,
   SCGB_UTI_FIRMA_4,
   SCGB_TOT_GAR_4,
   SCGB_ACC_TOT_4,
   SCGB_UTI_TOT_4,
   SCSB_QIS_ACC_4,
   SCSB_QIS_UTI_4,
   SCGB_QIS_ACC_4,
   SCGB_QIS_UTI_4,
   SCGB_ACC_SIS_4,
   SCGB_UTI_SIS_4,
   SCSB_DTA_PCR_5,
   SCSB_DTA_CR_5,
   SCSB_ACC_CASSA_BT_5,
   SCSB_UTI_CASSA_BT_5,
   SCSB_ACC_SMOBILIZZO_5,
   SCSB_UTI_SMOBILIZZO_5,
   SCSB_ACC_CASSA_MLT_5,
   SCSB_UTI_CASSA_MLT_5,
   SCSB_ACC_FIRMA_5,
   SCSB_UTI_FIRMA_5,
   SCSB_ACC_TOT_5,
   SCSB_UTI_TOT_5,
   SCSB_TOT_GAR_5,
   SCSB_ACC_SOSTITUZIONI_5,
   SCSB_UTI_SOSTITUZIONI_5,
   SCSB_ACC_MASSIMALI_5,
   SCSB_UTI_MASSIMALI_5,
   SCGB_ACC_SOSTITUZIONI_5,
   SCGB_UTI_SOSTITUZIONI_5,
   SCGB_ACC_MASSIMALI_5,
   SCGB_UTI_MASSIMALI_5,
   SCGB_ACC_CASSA_BT_5,
   SCGB_UTI_CASSA_BT_5,
   SCGB_ACC_SMOBILIZZO_5,
   SCGB_UTI_SMOBILIZZO_5,
   SCGB_ACC_CASSA_MLT_5,
   SCGB_UTI_CASSA_MLT_5,
   SCGB_ACC_FIRMA_5,
   SCGB_UTI_FIRMA_5,
   SCGB_TOT_GAR_5,
   SCGB_ACC_TOT_5,
   SCGB_UTI_TOT_5,
   SCSB_QIS_ACC_5,
   SCSB_QIS_UTI_5,
   SCGB_QIS_ACC_5,
   SCGB_QIS_UTI_5,
   SCGB_ACC_SIS_5,
   SCGB_UTI_SIS_5,
   SCSB_DTA_PCR_6,
   SCSB_DTA_CR_6,
   SCSB_ACC_CASSA_BT_6,
   SCSB_UTI_CASSA_BT_6,
   SCSB_ACC_SMOBILIZZO_6,
   SCSB_UTI_SMOBILIZZO_6,
   SCSB_ACC_CASSA_MLT_6,
   SCSB_UTI_CASSA_MLT_6,
   SCSB_ACC_FIRMA_6,
   SCSB_UTI_FIRMA_6,
   SCSB_ACC_TOT_6,
   SCSB_UTI_TOT_6,
   SCSB_TOT_GAR_6,
   SCSB_ACC_SOSTITUZIONI_6,
   SCSB_UTI_SOSTITUZIONI_6,
   SCSB_ACC_MASSIMALI_6,
   SCSB_UTI_MASSIMALI_6,
   SCGB_ACC_SOSTITUZIONI_6,
   SCGB_UTI_SOSTITUZIONI_6,
   SCGB_ACC_MASSIMALI_6,
   SCGB_UTI_MASSIMALI_6,
   SCGB_ACC_CASSA_BT_6,
   SCGB_UTI_CASSA_BT_6,
   SCGB_ACC_SMOBILIZZO_6,
   SCGB_UTI_SMOBILIZZO_6,
   SCGB_ACC_CASSA_MLT_6,
   SCGB_UTI_CASSA_MLT_6,
   SCGB_ACC_FIRMA_6,
   SCGB_UTI_FIRMA_6,
   SCGB_TOT_GAR_6,
   SCGB_ACC_TOT_6,
   SCGB_UTI_TOT_6,
   SCSB_QIS_ACC_6,
   SCSB_QIS_UTI_6,
   SCGB_QIS_ACC_6,
   SCGB_QIS_UTI_6,
   SCGB_ACC_SIS_6,
   SCGB_UTI_SIS_6,
   GESB_DTA_PCR_AT,
   GESB_DTA_CR_AT,
   GESB_ACC_CASSA_BT_AT,
   GESB_UTI_CASSA_BT_AT,
   GESB_ACC_SMOBILIZZO_AT,
   GESB_UTI_SMOBILIZZO_AT,
   GESB_ACC_CASSA_MLT_AT,
   GESB_UTI_CASSA_MLT_AT,
   GESB_ACC_FIRMA_AT,
   GESB_UTI_FIRMA_AT,
   GESB_ACC_TOT_AT,
   GESB_UTI_TOT_AT,
   GESB_TOT_GAR_AT,
   GESB_ACC_SOSTITUZIONI_AT,
   GESB_UTI_SOSTITUZIONI_AT,
   GESB_ACC_MASSIMALI_AT,
   GESB_UTI_MASSIMALI_AT,
   GEGB_ACC_SOSTITUZIONI_AT,
   GEGB_UTI_SOSTITUZIONI_AT,
   GEGB_ACC_MASSIMALI_AT,
   GEGB_UTI_MASSIMALI_AT,
   GEGB_ACC_CASSA_BT_AT,
   GEGB_UTI_CASSA_BT_AT,
   GEGB_ACC_SMOBILIZZO_AT,
   GEGB_UTI_SMOBILIZZO_AT,
   GEGB_ACC_CASSA_MLT_AT,
   GEGB_UTI_CASSA_MLT_AT,
   GEGB_ACC_FIRMA_AT,
   GEGB_UTI_FIRMA_AT,
   GEGB_TOT_GAR_AT,
   GEGB_UTI_TOT_AT,
   GEGB_ACC_TOT_AT,
   GESB_QIS_ACC_AT,
   GESB_QIS_UTI_AT,
   GEGB_QIS_ACC_AT,
   GEGB_QIS_UTI_AT,
   GEGB_ACC_SIS_AT,
   GEGB_UTI_SIS_AT,
   GESB_DTA_PCR_1,
   GESB_DTA_CR_1,
   GESB_ACC_CASSA_BT_1,
   GESB_UTI_CASSA_BT_1,
   GESB_ACC_SMOBILIZZO_1,
   GESB_UTI_SMOBILIZZO_1,
   GESB_ACC_CASSA_MLT_1,
   GESB_UTI_CASSA_MLT_1,
   GESB_ACC_FIRMA_1,
   GESB_UTI_FIRMA_1,
   GESB_ACC_TOT_1,
   GESB_ACC_SOSTITUZIONI_1,
   GESB_UTI_SOSTITUZIONI_1,
   GESB_ACC_MASSIMALI_1,
   GESB_UTI_MASSIMALI_1,
   GEGB_ACC_SOSTITUZIONI_1,
   GEGB_UTI_SOSTITUZIONI_1,
   GEGB_ACC_MASSIMALI_1,
   GEGB_UTI_MASSIMALI_1,
   GESB_UTI_TOT_1,
   GESB_TOT_GAR_1,
   GEGB_ACC_CASSA_BT_1,
   GEGB_UTI_CASSA_BT_1,
   GEGB_ACC_SMOBILIZZO_1,
   GEGB_UTI_SMOBILIZZO_1,
   GEGB_ACC_CASSA_MLT_1,
   GEGB_UTI_CASSA_MLT_1,
   GEGB_ACC_FIRMA_1,
   GEGB_UTI_FIRMA_1,
   GEGB_TOT_GAR_1,
   GEGB_UTI_TOT_1,
   GEGB_ACC_SIS_1,
   GEGB_UTI_SIS_1,
   GEGB_ACC_TOT_1,
   GESB_QIS_ACC_1,
   GESB_QIS_UTI_1,
   GEGB_QIS_ACC_1,
   GEGB_QIS_UTI_1,
   GESB_DTA_PCR_2,
   GESB_DTA_CR_2,
   GESB_ACC_CASSA_BT_2,
   GESB_UTI_CASSA_BT_2,
   GESB_ACC_SMOBILIZZO_2,
   GESB_UTI_SMOBILIZZO_2,
   GESB_ACC_CASSA_MLT_2,
   GESB_UTI_CASSA_MLT_2,
   GESB_ACC_FIRMA_2,
   GESB_UTI_FIRMA_2,
   GESB_ACC_TOT_2,
   GESB_UTI_TOT_2,
   GESB_TOT_GAR_2,
   GEGB_ACC_CASSA_BT_2,
   GEGB_UTI_CASSA_BT_2,
   GEGB_ACC_SMOBILIZZO_2,
   GEGB_UTI_SMOBILIZZO_2,
   GEGB_ACC_CASSA_MLT_2,
   GEGB_UTI_CASSA_MLT_2,
   GEGB_TOT_GAR_2,
   GESB_ACC_SOSTITUZIONI_2,
   GESB_UTI_SOSTITUZIONI_2,
   GESB_ACC_MASSIMALI_2,
   GESB_UTI_MASSIMALI_2,
   GEGB_ACC_SOSTITUZIONI_2,
   GEGB_UTI_SOSTITUZIONI_2,
   GEGB_ACC_MASSIMALI_2,
   GEGB_UTI_MASSIMALI_2,
   GEGB_UTI_TOT_2,
   GEGB_ACC_TOT_2,
   GEGB_ACC_FIRMA_2,
   GEGB_UTI_FIRMA_2,
   GESB_QIS_ACC_2,
   GESB_QIS_UTI_2,
   GEGB_QIS_ACC_2,
   GEGB_QIS_UTI_2,
   GEGB_ACC_SIS_2,
   GEGB_UTI_SIS_2,
   GESB_DTA_PCR_3,
   GESB_DTA_CR_3,
   GESB_ACC_CASSA_BT_3,
   GESB_UTI_CASSA_BT_3,
   GESB_ACC_SMOBILIZZO_3,
   GESB_UTI_SMOBILIZZO_3,
   GESB_ACC_CASSA_MLT_3,
   GESB_UTI_CASSA_MLT_3,
   GESB_ACC_FIRMA_3,
   GESB_UTI_FIRMA_3,
   GESB_ACC_TOT_3,
   GESB_ACC_SOSTITUZIONI_3,
   GESB_UTI_SOSTITUZIONI_3,
   GESB_ACC_MASSIMALI_3,
   GESB_UTI_MASSIMALI_3,
   GEGB_ACC_SOSTITUZIONI_3,
   GEGB_UTI_SOSTITUZIONI_3,
   GEGB_ACC_MASSIMALI_3,
   GEGB_UTI_MASSIMALI_3,
   GESB_UTI_TOT_3,
   GESB_TOT_GAR_3,
   GEGB_ACC_CASSA_BT_3,
   GEGB_UTI_CASSA_BT_3,
   GEGB_ACC_SMOBILIZZO_3,
   GEGB_UTI_SMOBILIZZO_3,
   GEGB_ACC_CASSA_MLT_3,
   GEGB_UTI_CASSA_MLT_3,
   GEGB_ACC_FIRMA_3,
   GEGB_UTI_FIRMA_3,
   GEGB_TOT_GAR_3,
   GEGB_UTI_TOT_3,
   GEGB_ACC_TOT_3,
   GESB_QIS_ACC_3,
   GESB_QIS_UTI_3,
   GEGB_QIS_ACC_3,
   GEGB_QIS_UTI_3,
   GEGB_ACC_SIS_3,
   GEGB_UTI_SIS_3,
   GESB_DTA_PCR_4,
   GESB_DTA_CR_4,
   GESB_ACC_CASSA_BT_4,
   GESB_UTI_CASSA_BT_4,
   GESB_ACC_SMOBILIZZO_4,
   GESB_UTI_SMOBILIZZO_4,
   GESB_ACC_CASSA_MLT_4,
   GESB_UTI_CASSA_MLT_4,
   GESB_ACC_FIRMA_4,
   GESB_UTI_FIRMA_4,
   GESB_ACC_TOT_4,
   GESB_UTI_TOT_4,
   GESB_TOT_GAR_4,
   GEGB_ACC_CASSA_BT_4,
   GEGB_UTI_CASSA_BT_4,
   GEGB_ACC_SMOBILIZZO_4,
   GEGB_UTI_SMOBILIZZO_4,
   GEGB_ACC_CASSA_MLT_4,
   GEGB_UTI_CASSA_MLT_4,
   GEGB_ACC_FIRMA_4,
   GEGB_UTI_FIRMA_4,
   GEGB_TOT_GAR_4,
   GESB_ACC_SOSTITUZIONI_4,
   GESB_UTI_SOSTITUZIONI_4,
   GESB_ACC_MASSIMALI_4,
   GESB_UTI_MASSIMALI_4,
   GEGB_ACC_SOSTITUZIONI_4,
   GEGB_UTI_SOSTITUZIONI_4,
   GEGB_ACC_MASSIMALI_4,
   GEGB_UTI_MASSIMALI_4,
   GEGB_UTI_TOT_4,
   GEGB_ACC_TOT_4,
   GESB_QIS_ACC_4,
   GESB_QIS_UTI_4,
   GEGB_QIS_ACC_4,
   GEGB_QIS_UTI_4,
   GEGB_ACC_SIS_4,
   GEGB_UTI_SIS_4,
   GESB_DTA_PCR_5,
   GESB_DTA_CR_5,
   GESB_ACC_CASSA_BT_5,
   GESB_UTI_CASSA_BT_5,
   GESB_ACC_SMOBILIZZO_5,
   GESB_UTI_SMOBILIZZO_5,
   GESB_ACC_CASSA_MLT_5,
   GESB_UTI_CASSA_MLT_5,
   GESB_ACC_FIRMA_5,
   GESB_UTI_FIRMA_5,
   GESB_ACC_TOT_5,
   GESB_UTI_TOT_5,
   GESB_TOT_GAR_5,
   GEGB_ACC_CASSA_BT_5,
   GEGB_UTI_CASSA_BT_5,
   GEGB_ACC_SMOBILIZZO_5,
   GEGB_UTI_SMOBILIZZO_5,
   GEGB_ACC_CASSA_MLT_5,
   GEGB_UTI_CASSA_MLT_5,
   GEGB_ACC_FIRMA_5,
   GEGB_UTI_FIRMA_5,
   GEGB_TOT_GAR_5,
   GESB_ACC_SOSTITUZIONI_5,
   GESB_UTI_SOSTITUZIONI_5,
   GESB_ACC_MASSIMALI_5,
   GESB_UTI_MASSIMALI_5,
   GEGB_ACC_SOSTITUZIONI_5,
   GEGB_UTI_SOSTITUZIONI_5,
   GEGB_ACC_MASSIMALI_5,
   GEGB_UTI_MASSIMALI_5,
   GEGB_UTI_TOT_5,
   GEGB_ACC_TOT_5,
   GESB_QIS_ACC_5,
   GESB_QIS_UTI_5,
   GEGB_QIS_ACC_5,
   GEGB_QIS_UTI_5,
   GEGB_ACC_SIS_5,
   GEGB_UTI_SIS_5,
   GESB_DTA_PCR_6,
   GESB_DTA_CR_6,
   GESB_ACC_CASSA_BT_6,
   GESB_UTI_CASSA_BT_6,
   GESB_ACC_SMOBILIZZO_6,
   GESB_UTI_SMOBILIZZO_6,
   GESB_ACC_CASSA_MLT_6,
   GESB_UTI_CASSA_MLT_6,
   GESB_ACC_FIRMA_6,
   GESB_UTI_FIRMA_6,
   GESB_ACC_TOT_6,
   GESB_UTI_TOT_6,
   GESB_TOT_GAR_6,
   GESB_ACC_SOSTITUZIONI_6,
   GESB_UTI_SOSTITUZIONI_6,
   GESB_ACC_MASSIMALI_6,
   GESB_UTI_MASSIMALI_6,
   GEGB_ACC_SOSTITUZIONI_6,
   GEGB_UTI_SOSTITUZIONI_6,
   GEGB_ACC_MASSIMALI_6,
   GEGB_UTI_MASSIMALI_6,
   GEGB_ACC_CASSA_BT_6,
   GEGB_UTI_CASSA_BT_6,
   GEGB_ACC_SMOBILIZZO_6,
   GEGB_UTI_SMOBILIZZO_6,
   GEGB_ACC_CASSA_MLT_6,
   GEGB_UTI_CASSA_MLT_6,
   GEGB_ACC_FIRMA_6,
   GEGB_UTI_FIRMA_6,
   GEGB_TOT_GAR_6,
   GEGB_UTI_TOT_6,
   GEGB_ACC_TOT_6,
   GESB_QIS_ACC_6,
   GESB_QIS_UTI_6,
   GEGB_QIS_ACC_6,
   GEGB_QIS_UTI_6,
   GEGB_ACC_SIS_6,
   GEGB_UTI_SIS_6
)
AS
   WITH e
        AS (SELECT s.*,
                   DENSE_RANK ()
                   OVER (PARTITION BY s.cod_abi_cartolarizzato, s.cod_ndg
                         ORDER BY dta_fine_validita DESC)
                      r
              FROM t_mcre0_app_storico_eventi s,
                   mv_mcre0_app_upd_field x,
                   t_mcre0_app_stati h
             WHERE     flg_cambio_stato = '1'
                   AND x.cod_stato = h.cod_microstato
                   AND h.cod_macrostato = 'RIO'
                   AND x.cod_sndg = s.cod_sndg)
   SELECT DISTINCT
          f.cod_abi_cartolarizzato,
          f.cod_abi_istituto,
          i.desc_istituto,
          f.cod_ndg,
          f.cod_sndg,
          TO_DATE (f.id_dper_fg, 'YYYYMMDD') dta_controllo_at,
          MAX (DECODE (r, 1, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_1,
          MAX (DECODE (r, 1, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_1,
          MAX (DECODE (r, 2, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_2,
          MAX (DECODE (r, 2, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_2,
          MAX (DECODE (r, 3, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_3,
          MAX (DECODE (r, 3, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_3,
          MAX (DECODE (r, 4, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_4,
          MAX (DECODE (r, 4, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_4,
          MAX (DECODE (r, 5, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_5,
          MAX (DECODE (r, 5, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_5,
          MAX (DECODE (r, 6, e.cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             cod_stato_6,
          MAX (DECODE (r, 6, TRUNC (dta_ini_validita), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             dta_controllo_6,
          MAX (TRUNC (f.scsb_dta_riferimento))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_dta_pcr_at,
          MAX (TRUNC (f.scgb_dta_rif_cr))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_dta_cr_at,
          MAX (f.scsb_acc_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_cassa_bt_at,
          MAX (f.scsb_uti_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_cassa_bt_at,
          MAX (f.scsb_acc_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_smobilizzo_at,
          MAX (f.scsb_uti_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_smobilizzo_at,
          MAX (f.scsb_acc_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_cassa_mlt_at,
          MAX (f.scsb_uti_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_cassa_mlt_at,
          MAX (f.scsb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_firma_at,
          MAX (f.scsb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_firma_at,
          MAX (f.scsb_acc_cassa + f.scsb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_tot_at,
          MAX (f.scsb_uti_cassa + f.scsb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_tot_at,
          MAX (f.scsb_tot_gar)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_tot_gar_at,
          MAX (f.scsb_acc_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_sostituzioni_at,
          MAX (f.scsb_uti_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_sostituzioni_at,
          MAX (f.scsb_acc_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_acc_massimali_at,
          MAX (f.scsb_uti_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_uti_massimali_at,
          MAX (f.scgb_acc_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sostituzioni_at,
          MAX (f.scgb_uti_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sostituzioni_at,
          MAX (f.scgb_acc_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_massimali_at,
          MAX (f.scgb_uti_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_massimali_at,
          MAX (f.scgb_acc_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_cassa_bt_at,
          MAX (f.scgb_uti_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_cassa_bt_at,
          MAX (f.scgb_acc_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_smobilizzo_at,
          MAX (f.scgb_uti_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_smobilizzo_at,
          MAX (f.scgb_acc_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_cassa_mlt_at,
          MAX (f.scgb_uti_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_cassa_mlt_at,
          MAX (f.scgb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_firma_at,
          MAX (f.scgb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_firma_at,
          MAX (f.scgb_tot_gar)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_tot_gar_at,
          MAX (f.scgb_acc_cassa + f.scgb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_at,
          MAX (f.scgb_uti_cassa + f.scgb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_at,
          MAX (f.scsb_qis_acc)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_qis_acc_at,
          MAX (f.scsb_qis_uti)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scsb_qis_uti_at,
          MAX (f.scgb_qis_acc)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_qis_acc_at,
          MAX (f.scgb_qis_uti)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_qis_uti_at,
          MAX (f.scgb_acc_sis)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_at,
          MAX (f.scgb_uti_sis)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_at,
          MAX (DECODE (r, 1, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_1,
          MAX (DECODE (r, 1, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_1,
          MAX (DECODE (r, 1, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_1,
          MAX (DECODE (r, 1, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_1,
          MAX (DECODE (r, 1, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_1,
          MAX (DECODE (r, 1, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_1,
          MAX (DECODE (r, 1, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_1,
          MAX (DECODE (r, 1, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_1,
          MAX (DECODE (r, 1, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_1,
          MAX (DECODE (r, 1, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_1,
          MAX (DECODE (r, 1, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_1,
          MAX (DECODE (r, 1, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_1,
          MAX (DECODE (r, 1, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_1,
          MAX (DECODE (r, 1, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_1,
          MAX (DECODE (r, 1, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_1,
          MAX (DECODE (r, 1, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_1,
          MAX (DECODE (r, 1, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_1,
          MAX (DECODE (r, 1, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_1,
          MAX (DECODE (r, 1, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_1,
          MAX (DECODE (r, 1, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_1,
          MAX (DECODE (r, 1, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_1,
          MAX (DECODE (r, 1, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_1,
          MAX (DECODE (r, 1, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_1,
          MAX (DECODE (r, 1, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_1,
          MAX (DECODE (r, 1, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_1,
          MAX (DECODE (r, 1, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_1,
          MAX (DECODE (r, 1, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_1,
          MAX (DECODE (r, 1, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_1,
          MAX (DECODE (r, 1, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_1,
          MAX (DECODE (r, 1, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_1,
          MAX (DECODE (r, 1, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_1,
          MAX (DECODE (r, 1, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_1,
          TO_NUMBER (
             MAX (DECODE (r, 1, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_1,
          TO_NUMBER (
             MAX (DECODE (r, 1, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_1,
          TO_NUMBER (
             MAX (DECODE (r, 1, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_1,
          TO_NUMBER (
             MAX (DECODE (r, 1, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_1,
          MAX (DECODE (r, 1, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_1,
          MAX (DECODE (r, 1, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_1,
          MAX (DECODE (r, 2, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_2,
          MAX (DECODE (r, 2, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_2,
          MAX (DECODE (r, 2, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_2,
          MAX (DECODE (r, 2, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_2,
          MAX (DECODE (r, 2, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_2,
          MAX (DECODE (r, 2, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_2,
          MAX (DECODE (r, 2, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_2,
          MAX (DECODE (r, 2, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_2,
          MAX (DECODE (r, 2, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_2,
          MAX (DECODE (r, 2, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_2,
          MAX (DECODE (r, 2, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_2,
          MAX (DECODE (r, 2, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_2,
          MAX (DECODE (r, 2, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_2,
          MAX (DECODE (r, 2, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_2,
          MAX (DECODE (r, 2, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_2,
          MAX (DECODE (r, 2, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_2,
          MAX (DECODE (r, 2, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_2,
          MAX (DECODE (r, 2, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_2,
          MAX (DECODE (r, 2, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_2,
          MAX (DECODE (r, 2, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_2,
          MAX (DECODE (r, 2, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_2,
          MAX (DECODE (r, 2, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_2,
          MAX (DECODE (r, 2, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_2,
          MAX (DECODE (r, 2, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_2,
          MAX (DECODE (r, 2, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_2,
          MAX (DECODE (r, 2, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_2,
          MAX (DECODE (r, 2, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_2,
          MAX (DECODE (r, 2, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_2,
          MAX (DECODE (r, 2, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_2,
          MAX (DECODE (r, 2, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_2,
          MAX (DECODE (r, 2, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_2,
          MAX (DECODE (r, 2, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_2,
          TO_NUMBER (
             MAX (DECODE (r, 2, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_2,
          TO_NUMBER (
             MAX (DECODE (r, 2, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_2,
          TO_NUMBER (
             MAX (DECODE (r, 2, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_2,
          TO_NUMBER (
             MAX (DECODE (r, 2, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_2,
          MAX (DECODE (r, 2, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_2,
          MAX (DECODE (r, 2, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_2,
          MAX (DECODE (r, 3, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_3,
          MAX (DECODE (r, 3, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_3,
          MAX (DECODE (r, 3, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_3,
          MAX (DECODE (r, 3, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_3,
          MAX (DECODE (r, 3, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_3,
          MAX (DECODE (r, 3, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_3,
          MAX (DECODE (r, 3, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_3,
          MAX (DECODE (r, 3, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_3,
          MAX (DECODE (r, 3, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_3,
          MAX (DECODE (r, 3, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_3,
          MAX (DECODE (r, 3, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_3,
          MAX (DECODE (r, 3, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_3,
          MAX (DECODE (r, 3, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_3,
          MAX (DECODE (r, 3, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_3,
          MAX (DECODE (r, 3, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_3,
          MAX (DECODE (r, 3, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_3,
          MAX (DECODE (r, 3, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_3,
          MAX (DECODE (r, 3, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_3,
          MAX (DECODE (r, 3, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_3,
          MAX (DECODE (r, 3, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_3,
          MAX (DECODE (r, 3, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_3,
          MAX (DECODE (r, 3, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_3,
          MAX (DECODE (r, 3, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_3,
          MAX (DECODE (r, 3, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_3,
          MAX (DECODE (r, 3, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_3,
          MAX (DECODE (r, 3, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_3,
          MAX (DECODE (r, 3, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_3,
          MAX (DECODE (r, 3, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_3,
          MAX (DECODE (r, 3, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_3,
          MAX (DECODE (r, 3, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_3,
          MAX (DECODE (r, 3, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_3,
          MAX (DECODE (r, 3, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_3,
          TO_NUMBER (
             MAX (DECODE (r, 3, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_3,
          TO_NUMBER (
             MAX (DECODE (r, 3, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_3,
          TO_NUMBER (
             MAX (DECODE (r, 3, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_3,
          TO_NUMBER (
             MAX (DECODE (r, 3, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_3,
          MAX (DECODE (r, 3, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_3,
          MAX (DECODE (r, 3, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_3,
          MAX (DECODE (r, 4, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_4,
          MAX (DECODE (r, 4, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_4,
          MAX (DECODE (r, 4, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_4,
          MAX (DECODE (r, 4, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_4,
          MAX (DECODE (r, 4, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_4,
          MAX (DECODE (r, 4, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_4,
          MAX (DECODE (r, 4, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_4,
          MAX (DECODE (r, 4, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_4,
          MAX (DECODE (r, 4, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_4,
          MAX (DECODE (r, 4, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_4,
          MAX (DECODE (r, 4, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_4,
          MAX (DECODE (r, 4, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_4,
          MAX (DECODE (r, 4, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_4,
          MAX (DECODE (r, 4, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_4,
          MAX (DECODE (r, 4, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_4,
          MAX (DECODE (r, 4, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_4,
          MAX (DECODE (r, 4, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_4,
          MAX (DECODE (r, 4, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_4,
          MAX (DECODE (r, 4, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_4,
          MAX (DECODE (r, 4, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_4,
          MAX (DECODE (r, 4, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_4,
          MAX (DECODE (r, 4, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_4,
          MAX (DECODE (r, 4, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_4,
          MAX (DECODE (r, 4, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_4,
          MAX (DECODE (r, 4, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_4,
          MAX (DECODE (r, 4, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_4,
          MAX (DECODE (r, 4, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_4,
          MAX (DECODE (r, 4, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_4,
          MAX (DECODE (r, 4, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_4,
          MAX (DECODE (r, 4, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_4,
          MAX (DECODE (r, 4, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_4,
          MAX (DECODE (r, 4, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_4,
          TO_NUMBER (
             MAX (DECODE (r, 4, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_4,
          TO_NUMBER (
             MAX (DECODE (r, 4, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_4,
          TO_NUMBER (
             MAX (DECODE (r, 4, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_4,
          TO_NUMBER (
             MAX (DECODE (r, 4, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_4,
          MAX (DECODE (r, 4, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_4,
          MAX (DECODE (r, 4, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_4,
          MAX (DECODE (r, 5, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_5,
          MAX (DECODE (r, 5, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_5,
          MAX (DECODE (r, 5, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_5,
          MAX (DECODE (r, 5, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_5,
          MAX (DECODE (r, 5, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_5,
          MAX (DECODE (r, 5, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_5,
          MAX (DECODE (r, 5, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_5,
          MAX (DECODE (r, 5, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_5,
          MAX (DECODE (r, 5, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_5,
          MAX (DECODE (r, 5, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_5,
          MAX (DECODE (r, 5, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_5,
          MAX (DECODE (r, 5, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_5,
          MAX (DECODE (r, 5, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_5,
          MAX (DECODE (r, 5, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_5,
          MAX (DECODE (r, 5, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_5,
          MAX (DECODE (r, 5, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_5,
          MAX (DECODE (r, 5, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_5,
          MAX (DECODE (r, 5, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_5,
          MAX (DECODE (r, 5, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_5,
          MAX (DECODE (r, 5, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_5,
          MAX (DECODE (r, 5, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_5,
          MAX (DECODE (r, 5, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_5,
          MAX (DECODE (r, 5, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_5,
          MAX (DECODE (r, 5, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_5,
          MAX (DECODE (r, 5, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_5,
          MAX (DECODE (r, 5, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_5,
          MAX (DECODE (r, 5, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_5,
          MAX (DECODE (r, 5, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_5,
          MAX (DECODE (r, 5, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_5,
          MAX (DECODE (r, 5, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_5,
          MAX (DECODE (r, 5, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_5,
          MAX (DECODE (r, 5, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_5,
          TO_NUMBER (
             MAX (DECODE (r, 5, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_5,
          TO_NUMBER (
             MAX (DECODE (r, 5, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_5,
          TO_NUMBER (
             MAX (DECODE (r, 5, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_5,
          TO_NUMBER (
             MAX (DECODE (r, 5, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_5,
          MAX (DECODE (r, 5, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_5,
          MAX (DECODE (r, 5, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_5,
          MAX (DECODE (r, 6, TRUNC (e.scsb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_6,
          MAX (DECODE (r, 6, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_6,
          MAX (DECODE (r, 6, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_6,
          MAX (DECODE (r, 6, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_6,
          MAX (DECODE (r, 6, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_6,
          MAX (DECODE (r, 6, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_6,
          MAX (DECODE (r, 6, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_6,
          MAX (DECODE (r, 6, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_6,
          MAX (DECODE (r, 6, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_6,
          MAX (DECODE (r, 6, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_6,
          MAX (DECODE (r, 6, e.scsb_acc_cassa + e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_6,
          MAX (DECODE (r, 6, e.scsb_uti_cassa + e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_6,
          MAX (DECODE (r, 6, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_6,
          MAX (DECODE (r, 6, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_6,
          MAX (DECODE (r, 6, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_6,
          MAX (DECODE (r, 6, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_6,
          MAX (DECODE (r, 6, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_6,
          MAX (DECODE (r, 6, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_6,
          MAX (DECODE (r, 6, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_6,
          MAX (DECODE (r, 6, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_6,
          MAX (DECODE (r, 6, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_6,
          MAX (DECODE (r, 6, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_6,
          MAX (DECODE (r, 6, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_6,
          MAX (DECODE (r, 6, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_6,
          MAX (DECODE (r, 6, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_6,
          MAX (DECODE (r, 6, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_6,
          MAX (DECODE (r, 6, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_6,
          MAX (DECODE (r, 6, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_6,
          MAX (DECODE (r, 6, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_6,
          MAX (DECODE (r, 6, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_6,
          MAX (DECODE (r, 6, e.scgb_acc_cassa + e.scgb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_tot_6,
          MAX (DECODE (r, 6, e.scgb_uti_cassa + e.scgb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_tot_6,
          TO_NUMBER (
             MAX (DECODE (r, 6, NULLIF (e.scsb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_acc_6,
          TO_NUMBER (
             MAX (DECODE (r, 6, NULLIF (e.scsb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scsb_qis_uti_6,
          TO_NUMBER (
             MAX (DECODE (r, 6, NULLIF (e.scgb_qis_acc, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_acc_6,
          TO_NUMBER (
             MAX (DECODE (r, 6, NULLIF (e.scgb_qis_uti, 'N.D.'), NULL))
                OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg))
             scgb_qis_uti_6,
          MAX (DECODE (r, 6, e.scgb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_acc_sis_6,
          MAX (DECODE (r, 6, e.scgb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             scgb_uti_sis_6,
          MAX (TRUNC (f.gesb_dta_riferimento))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_dta_pcr_at,
          MAX (TRUNC (f.scgb_dta_rif_cr))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_dta_cr_at,
          MAX (f.gesb_acc_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_cassa_bt_at,
          MAX (f.gesb_uti_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_cassa_bt_at,
          MAX (f.gesb_acc_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_smobilizzo_at,
          MAX (f.gesb_uti_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_smobilizzo_at,
          MAX (f.gesb_acc_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_cassa_mlt_at,
          MAX (f.gesb_uti_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_cassa_mlt_at,
          MAX (f.gesb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_firma_at,
          MAX (f.gesb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_firma_at,
          MAX (f.gesb_acc_cassa + f.gesb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_tot_at,
          MAX (f.gesb_uti_cassa + f.gesb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_tot_at,
          MAX (f.gesb_tot_gar)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_tot_gar_at,
          MAX (f.gesb_acc_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_sostituzioni_at,
          MAX (f.gesb_uti_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_sostituzioni_at,
          MAX (f.gesb_acc_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_acc_massimali_at,
          MAX (f.gesb_uti_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_uti_massimali_at,
          MAX (f.gegb_acc_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sostituzioni_at,
          MAX (f.gegb_uti_sostituzioni)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sostituzioni_at,
          MAX (f.gegb_acc_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_massimali_at,
          MAX (f.gegb_uti_massimali)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_massimali_at,
          MAX (f.gegb_acc_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_cassa_bt_at,
          MAX (f.gegb_uti_cassa_bt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_cassa_bt_at,
          MAX (f.gegb_acc_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_smobilizzo_at,
          MAX (f.gegb_uti_smobilizzo)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_smobilizzo_at,
          MAX (f.gegb_acc_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_cassa_mlt_at,
          MAX (f.gegb_uti_cassa_mlt)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_cassa_mlt_at,
          MAX (f.gegb_acc_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_firma_at,
          MAX (f.gegb_uti_firma)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_firma_at,
          MAX (f.gegb_tot_gar)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_tot_gar_at,
          MAX (f.gegb_uti_firma + f.gegb_uti_cassa)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_at,
          MAX (f.gegb_acc_firma + f.gegb_acc_cassa)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_at,
          MAX (f.gesb_qis_acc)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_qis_acc_at,
          MAX (f.gesb_qis_uti)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gesb_qis_uti_at,
          MAX (f.gegb_qis_acc)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_qis_acc_at,
          MAX (f.gegb_qis_uti)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_qis_uti_at,
          MAX (f.gegb_acc_sis)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_at,
          MAX (f.gegb_uti_sis)
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_at,
          MAX (DECODE (r, 1, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_1,
          MAX (DECODE (r, 1, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_1,
          MAX (DECODE (r, 1, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_1,
          MAX (DECODE (r, 1, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_1,
          MAX (DECODE (r, 1, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_1,
          MAX (DECODE (r, 1, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_1,
          MAX (DECODE (r, 1, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_1,
          MAX (DECODE (r, 1, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_1,
          MAX (DECODE (r, 1, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_1,
          MAX (DECODE (r, 1, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_1,
          MAX (DECODE (r, 1, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_1,
          MAX (DECODE (r, 1, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_1,
          MAX (DECODE (r, 1, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_1,
          MAX (DECODE (r, 1, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_1,
          MAX (DECODE (r, 1, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_1,
          MAX (DECODE (r, 1, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_1,
          MAX (DECODE (r, 1, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_1,
          MAX (DECODE (r, 1, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_1,
          MAX (DECODE (r, 1, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_1,
          MAX (DECODE (r, 1, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_1,
          MAX (DECODE (r, 1, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_1,
          MAX (DECODE (r, 1, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_1,
          MAX (DECODE (r, 1, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_1,
          MAX (DECODE (r, 1, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_1,
          MAX (DECODE (r, 1, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_1,
          MAX (DECODE (r, 1, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_1,
          MAX (DECODE (r, 1, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_1,
          MAX (DECODE (r, 1, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_1,
          MAX (DECODE (r, 1, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_1,
          MAX (DECODE (r, 1, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_1,
          MAX (DECODE (r, 1, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_1,
          MAX (DECODE (r, 1, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_1,
          MAX (DECODE (r, 1, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_1,
          MAX (DECODE (r, 1, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_1,
          MAX (DECODE (r, 1, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_1,
          MAX (DECODE (r, 1, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_1,
          MAX (DECODE (r, 1, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_1,
          MAX (DECODE (r, 1, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_1,
          MAX (DECODE (r, 2, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_2,
          MAX (DECODE (r, 2, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_2,
          MAX (DECODE (r, 2, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_2,
          MAX (DECODE (r, 2, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_2,
          MAX (DECODE (r, 2, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_2,
          MAX (DECODE (r, 2, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_2,
          MAX (DECODE (r, 2, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_2,
          MAX (DECODE (r, 2, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_2,
          MAX (DECODE (r, 2, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_2,
          MAX (DECODE (r, 2, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_2,
          MAX (DECODE (r, 2, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_2,
          MAX (DECODE (r, 2, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_2,
          MAX (DECODE (r, 2, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_2,
          MAX (DECODE (r, 2, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_2,
          MAX (DECODE (r, 2, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_2,
          MAX (DECODE (r, 2, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_2,
          MAX (DECODE (r, 2, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_2,
          MAX (DECODE (r, 2, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_2,
          MAX (DECODE (r, 2, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_2,
          MAX (DECODE (r, 2, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_2,
          MAX (DECODE (r, 2, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_2,
          MAX (DECODE (r, 2, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_2,
          MAX (DECODE (r, 2, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_2,
          MAX (DECODE (r, 2, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_2,
          MAX (DECODE (r, 2, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_2,
          MAX (DECODE (r, 2, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_2,
          MAX (DECODE (r, 2, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_2,
          MAX (DECODE (r, 2, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_2,
          MAX (DECODE (r, 2, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_2,
          MAX (DECODE (r, 2, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_2,
          MAX (DECODE (r, 2, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_2,
          MAX (DECODE (r, 2, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_2,
          MAX (DECODE (r, 2, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_2,
          MAX (DECODE (r, 2, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_2,
          MAX (DECODE (r, 2, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_2,
          MAX (DECODE (r, 2, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_2,
          MAX (DECODE (r, 2, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_2,
          MAX (DECODE (r, 2, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_2,
          MAX (DECODE (r, 3, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_3,
          MAX (DECODE (r, 3, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_3,
          MAX (DECODE (r, 3, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_3,
          MAX (DECODE (r, 3, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_3,
          MAX (DECODE (r, 3, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_3,
          MAX (DECODE (r, 3, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_3,
          MAX (DECODE (r, 3, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_3,
          MAX (DECODE (r, 3, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_3,
          MAX (DECODE (r, 3, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_3,
          MAX (DECODE (r, 3, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_3,
          MAX (DECODE (r, 3, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_3,
          MAX (DECODE (r, 3, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_3,
          MAX (DECODE (r, 3, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_3,
          MAX (DECODE (r, 3, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_3,
          MAX (DECODE (r, 3, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_3,
          MAX (DECODE (r, 3, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_3,
          MAX (DECODE (r, 3, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_3,
          MAX (DECODE (r, 3, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_3,
          MAX (DECODE (r, 3, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_3,
          MAX (DECODE (r, 3, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_3,
          MAX (DECODE (r, 3, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_3,
          MAX (DECODE (r, 3, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_3,
          MAX (DECODE (r, 3, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_3,
          MAX (DECODE (r, 3, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_3,
          MAX (DECODE (r, 3, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_3,
          MAX (DECODE (r, 3, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_3,
          MAX (DECODE (r, 3, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_3,
          MAX (DECODE (r, 3, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_3,
          MAX (DECODE (r, 3, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_3,
          MAX (DECODE (r, 3, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_3,
          MAX (DECODE (e.r, 3, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_3,
          MAX (DECODE (e.r, 3, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_3,
          MAX (DECODE (r, 3, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_3,
          MAX (DECODE (r, 3, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_3,
          MAX (DECODE (r, 3, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_3,
          MAX (DECODE (r, 3, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_3,
          MAX (DECODE (r, 3, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_3,
          MAX (DECODE (r, 3, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_3,
          MAX (DECODE (r, 4, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_4,
          MAX (DECODE (r, 4, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_4,
          MAX (DECODE (r, 4, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_4,
          MAX (DECODE (r, 4, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_4,
          MAX (DECODE (r, 4, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_4,
          MAX (DECODE (r, 4, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_4,
          MAX (DECODE (r, 4, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_4,
          MAX (DECODE (r, 4, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_4,
          MAX (DECODE (r, 4, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_4,
          MAX (DECODE (r, 4, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_4,
          MAX (DECODE (e.r, 4, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_4,
          MAX (DECODE (e.r, 4, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_4,
          MAX (DECODE (r, 4, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_4,
          MAX (DECODE (r, 4, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_4,
          MAX (DECODE (r, 4, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_4,
          MAX (DECODE (r, 4, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_4,
          MAX (DECODE (r, 4, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_4,
          MAX (DECODE (r, 4, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_4,
          MAX (DECODE (r, 4, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_4,
          MAX (DECODE (r, 4, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_4,
          MAX (DECODE (r, 4, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_4,
          MAX (DECODE (r, 4, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_4,
          MAX (DECODE (r, 4, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_4,
          MAX (DECODE (r, 4, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_4,
          MAX (DECODE (r, 4, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_4,
          MAX (DECODE (r, 4, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_4,
          MAX (DECODE (r, 4, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_4,
          MAX (DECODE (r, 4, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_4,
          MAX (DECODE (r, 4, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_4,
          MAX (DECODE (r, 4, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_4,
          MAX (DECODE (e.r, 4, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_4,
          MAX (DECODE (e.r, 4, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_4,
          MAX (DECODE (r, 4, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_4,
          MAX (DECODE (r, 4, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_4,
          MAX (DECODE (r, 4, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_4,
          MAX (DECODE (r, 4, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_4,
          MAX (DECODE (r, 4, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_4,
          MAX (DECODE (r, 4, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_4,
          MAX (DECODE (r, 5, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_5,
          MAX (DECODE (r, 5, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_5,
          MAX (DECODE (r, 5, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_5,
          MAX (DECODE (r, 5, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_5,
          MAX (DECODE (r, 5, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_5,
          MAX (DECODE (r, 5, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_5,
          MAX (DECODE (r, 5, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_5,
          MAX (DECODE (r, 5, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_5,
          MAX (DECODE (r, 5, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_5,
          MAX (DECODE (r, 5, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_5,
          MAX (DECODE (r, 5, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_5,
          MAX (DECODE (r, 5, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_5,
          MAX (DECODE (r, 5, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_5,
          MAX (DECODE (r, 5, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_5,
          MAX (DECODE (r, 5, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_5,
          MAX (DECODE (r, 5, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_5,
          MAX (DECODE (r, 5, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_5,
          MAX (DECODE (r, 5, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_5,
          MAX (DECODE (r, 5, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_5,
          MAX (DECODE (r, 5, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_5,
          MAX (DECODE (r, 5, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_5,
          MAX (DECODE (r, 5, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_5,
          MAX (DECODE (r, 5, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_5,
          MAX (DECODE (r, 5, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_5,
          MAX (DECODE (r, 5, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_5,
          MAX (DECODE (r, 5, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_5,
          MAX (DECODE (r, 5, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_5,
          MAX (DECODE (r, 5, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_5,
          MAX (DECODE (r, 5, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_5,
          MAX (DECODE (r, 5, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_5,
          MAX (DECODE (r, 5, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_5,
          MAX (DECODE (r, 5, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_5,
          MAX (DECODE (r, 5, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_5,
          MAX (DECODE (r, 5, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_5,
          MAX (DECODE (r, 5, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_5,
          MAX (DECODE (r, 5, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_5,
          MAX (DECODE (r, 5, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_5,
          MAX (DECODE (r, 5, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_5,
          MAX (DECODE (r, 6, TRUNC (e.gesb_dta_riferimento), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_6,
          MAX (DECODE (r, 6, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_6,
          MAX (DECODE (r, 6, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_6,
          MAX (DECODE (r, 6, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_6,
          MAX (DECODE (r, 6, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_6,
          MAX (DECODE (r, 6, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_6,
          MAX (DECODE (r, 6, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_6,
          MAX (DECODE (r, 6, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_6,
          MAX (DECODE (r, 6, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_6,
          MAX (DECODE (r, 6, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_6,
          MAX (DECODE (r, 6, e.gesb_acc_cassa + e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_6,
          MAX (DECODE (r, 6, e.gesb_uti_cassa + e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_6,
          MAX (DECODE (r, 6, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_6,
          MAX (DECODE (r, 6, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_6,
          MAX (DECODE (r, 6, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_6,
          MAX (DECODE (r, 6, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_6,
          MAX (DECODE (r, 6, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_6,
          MAX (DECODE (r, 6, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_6,
          MAX (DECODE (r, 6, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_6,
          MAX (DECODE (r, 6, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_6,
          MAX (DECODE (r, 6, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_6,
          MAX (DECODE (r, 6, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_6,
          MAX (DECODE (r, 6, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_6,
          MAX (DECODE (r, 6, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_6,
          MAX (DECODE (r, 6, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_6,
          MAX (DECODE (r, 6, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_6,
          MAX (DECODE (r, 6, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_6,
          MAX (DECODE (r, 6, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_6,
          MAX (DECODE (r, 6, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_6,
          MAX (DECODE (r, 6, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_6,
          MAX (DECODE (r, 6, e.gegb_uti_cassa + e.gegb_uti_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_tot_6,
          MAX (DECODE (r, 6, e.gegb_acc_cassa + e.gegb_acc_firma, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_tot_6,
          MAX (DECODE (r, 6, NULLIF (e.gesb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_acc_6,
          MAX (DECODE (r, 6, NULLIF (e.gesb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_qis_uti_6,
          MAX (DECODE (r, 6, NULLIF (e.gegb_qis_acc, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_acc_6,
          MAX (DECODE (r, 6, NULLIF (e.gegb_qis_uti, 'N.D.'), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_qis_uti_6,
          MAX (DECODE (r, 6, e.gegb_acc_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_acc_sis_6,
          MAX (DECODE (r, 6, e.gegb_uti_sis, NULL))
             OVER (PARTITION BY f.cod_abi_cartolarizzato, f.cod_ndg)
             gegb_uti_sis_6
     FROM e,
          mv_mcre0_app_istituti i,
          mv_mcre0_anagrafica_generale f,
          t_mcre0_app_all_data x
    WHERE     f.cod_abi_cartolarizzato = e.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = e.cod_ndg(+)
          AND x.cod_macrostato = 'RIO'
          AND x.cod_sndg = f.cod_sndg
          AND f.cod_abi_cartolarizzato = i.cod_abi(+)
          AND r < 7;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_ESP TO MCRE_USR;
