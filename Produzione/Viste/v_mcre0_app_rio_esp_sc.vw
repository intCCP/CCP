/* Formatted on 17/06/2014 18:03:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ESP_SC
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   COD_STATO_AT,
   DTA_CONTROLLO_AT,
   DTA_PCR_AT,
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
   SCGB_ACC_CASSA_BT_AT,
   SCGB_UTI_CASSA_BT_AT,
   SCGB_ACC_SMOBILIZZO_AT,
   SCGB_UTI_SMOBILIZZO_AT,
   SCGB_ACC_CASSA_MLT_AT,
   SCGB_UTI_CASSA_MLT_AT,
   SCGB_ACC_FIRMA_AT,
   SCGB_UTI_FIRMA_AT,
   SCGB_TOT_GAR_AT,
   SCGB_ACC_SOSTITUZIONI_AT,
   SCGB_UTI_SOSTITUZIONI_AT,
   SCGB_ACC_MASSIMALI_AT,
   SCGB_UTI_MASSIMALI_AT,
   SCGB_UTI_TOT_AT,
   SCGB_ACC_TOT_AT,
   SCSB_QIS_ACC_AT,
   SCSB_QIS_UTI_AT,
   SCGB_QIS_ACC_AT,
   SCGB_QIS_UTI_AT,
   DTA_CR_AT,
   SCGB_ACC_SIS_AT,
   SCGB_UTI_SIS_AT,
   COD_STATO_1,
   DTA_CONTROLLO_1,
   DTA_PCR_1,
   DTA_CR_1,
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
   SCGB_ACC_CASSA_BT_1,
   SCGB_UTI_CASSA_BT_1,
   SCGB_ACC_SMOBILIZZO_1,
   SCGB_UTI_SMOBILIZZO_1,
   SCGB_ACC_CASSA_MLT_1,
   SCGB_UTI_CASSA_MLT_1,
   SCGB_ACC_FIRMA_1,
   SCGB_UTI_FIRMA_1,
   SCGB_TOT_GAR_1,
   SCGB_ACC_SOSTITUZIONI_1,
   SCGB_UTI_SOSTITUZIONI_1,
   SCGB_ACC_MASSIMALI_1,
   SCGB_UTI_MASSIMALI_1,
   SCGB_ACC_TOT_1,
   SCGB_UTI_TOT_1,
   SCSB_QIS_ACC_1,
   SCSB_QIS_UTI_1,
   SCGB_QIS_ACC_1,
   SCGB_QIS_UTI_1,
   SCGB_ACC_SIS_1,
   SCGB_UTI_SIS_1,
   COD_STATO_2,
   DTA_CONTROLLO_2,
   DTA_PCR_2,
   DTA_CR_2,
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
   SCGB_ACC_CASSA_BT_2,
   SCGB_UTI_CASSA_BT_2,
   SCGB_ACC_SMOBILIZZO_2,
   SCGB_UTI_SMOBILIZZO_2,
   SCGB_ACC_CASSA_MLT_2,
   SCGB_UTI_CASSA_MLT_2,
   SCGB_ACC_FIRMA_2,
   SCGB_UTI_FIRMA_2,
   SCGB_TOT_GAR_2,
   SCGB_ACC_SOSTITUZIONI_2,
   SCGB_UTI_SOSTITUZIONI_2,
   SCGB_ACC_MASSIMALI_2,
   SCGB_UTI_MASSIMALI_2,
   SCGB_ACC_TOT_2,
   SCGB_UTI_TOT_2,
   SCSB_QIS_ACC_2,
   SCSB_QIS_UTI_2,
   SCGB_QIS_ACC_2,
   SCGB_QIS_UTI_2,
   SCGB_ACC_SIS_2,
   SCGB_UTI_SIS_2,
   COD_STATO_3,
   DTA_CONTROLLO_3,
   DTA_PCR_3,
   DTA_CR_3,
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
   SCGB_ACC_CASSA_BT_3,
   SCGB_UTI_CASSA_BT_3,
   SCGB_ACC_SMOBILIZZO_3,
   SCGB_UTI_SMOBILIZZO_3,
   SCGB_ACC_CASSA_MLT_3,
   SCGB_UTI_CASSA_MLT_3,
   SCGB_ACC_FIRMA_3,
   SCGB_UTI_FIRMA_3,
   SCGB_TOT_GAR_3,
   SCGB_ACC_SOSTITUZIONI_3,
   SCGB_UTI_SOSTITUZIONI_3,
   SCGB_ACC_MASSIMALI_3,
   SCGB_UTI_MASSIMALI_3,
   SCGB_ACC_TOT_3,
   SCGB_UTI_TOT_3,
   SCSB_QIS_ACC_3,
   SCSB_QIS_UTI_3,
   SCGB_QIS_ACC_3,
   SCGB_QIS_UTI_3,
   SCGB_ACC_SIS_3,
   SCGB_UTI_SIS_3,
   COD_STATO_4,
   DTA_CONTROLLO_4,
   DTA_PCR_4,
   DTA_CR_4,
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
   SCGB_ACC_CASSA_BT_4,
   SCGB_UTI_CASSA_BT_4,
   SCGB_ACC_SMOBILIZZO_4,
   SCGB_UTI_SMOBILIZZO_4,
   SCGB_ACC_CASSA_MLT_4,
   SCGB_UTI_CASSA_MLT_4,
   SCGB_ACC_FIRMA_4,
   SCGB_UTI_FIRMA_4,
   SCGB_TOT_GAR_4,
   SCGB_ACC_SOSTITUZIONI_4,
   SCGB_UTI_SOSTITUZIONI_4,
   SCGB_ACC_MASSIMALI_4,
   SCGB_UTI_MASSIMALI_4,
   SCGB_ACC_TOT_4,
   SCGB_UTI_TOT_4,
   SCSB_QIS_ACC_4,
   SCSB_QIS_UTI_4,
   SCGB_QIS_ACC_4,
   SCGB_QIS_UTI_4,
   SCGB_ACC_SIS_4,
   SCGB_UTI_SIS_4,
   COD_STATO_5,
   DTA_CONTROLLO_5,
   DTA_PCR_5,
   DTA_CR_5,
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
   SCGB_ACC_CASSA_BT_5,
   SCGB_UTI_CASSA_BT_5,
   SCGB_ACC_SMOBILIZZO_5,
   SCGB_UTI_SMOBILIZZO_5,
   SCGB_ACC_CASSA_MLT_5,
   SCGB_UTI_CASSA_MLT_5,
   SCGB_ACC_FIRMA_5,
   SCGB_UTI_FIRMA_5,
   SCGB_TOT_GAR_5,
   SCGB_ACC_SOSTITUZIONI_5,
   SCGB_UTI_SOSTITUZIONI_5,
   SCGB_ACC_MASSIMALI_5,
   SCGB_UTI_MASSIMALI_5,
   SCGB_ACC_TOT_5,
   SCGB_UTI_TOT_5,
   SCSB_QIS_ACC_5,
   SCSB_QIS_UTI_5,
   SCGB_QIS_ACC_5,
   SCGB_QIS_UTI_5,
   SCGB_ACC_SIS_5,
   SCGB_UTI_SIS_5,
   COD_STATO_6,
   DTA_CONTROLLO_6,
   DTA_PCR_6,
   DTA_CR_6,
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
   SCGB_ACC_CASSA_BT_6,
   SCGB_UTI_CASSA_BT_6,
   SCGB_ACC_SMOBILIZZO_6,
   SCGB_UTI_SMOBILIZZO_6,
   SCGB_ACC_CASSA_MLT_6,
   SCGB_UTI_CASSA_MLT_6,
   SCGB_ACC_FIRMA_6,
   SCGB_UTI_FIRMA_6,
   SCGB_TOT_GAR_6,
   SCGB_ACC_SOSTITUZIONI_6,
   SCGB_UTI_SOSTITUZIONI_6,
   SCGB_ACC_MASSIMALI_6,
   SCGB_UTI_MASSIMALI_6,
   SCGB_ACC_TOT_6,
   SCGB_UTI_TOT_6,
   SCSB_QIS_ACC_6,
   SCSB_QIS_UTI_6,
   SCGB_QIS_ACC_6,
   SCGB_QIS_UTI_6,
   SCGB_ACC_SIS_6,
   SCGB_UTI_SIS_6,
   DTA_CONTROLLO_PC,
   COD_STATO_PC,
   DTA_PCR_PC,
   DTA_CR_PC,
   SCSB_ACC_CASSA_BT_PC,
   SCSB_UTI_CASSA_BT_PC,
   SCSB_ACC_SMOBILIZZO_PC,
   SCSB_UTI_SMOBILIZZO_PC,
   SCSB_ACC_CASSA_MLT_PC,
   SCSB_UTI_CASSA_MLT_PC,
   SCSB_ACC_FIRMA_PC,
   SCSB_UTI_FIRMA_PC,
   SCSB_ACC_TOT_PC,
   SCSB_UTI_TOT_PC,
   SCSB_TOT_GAR_PC,
   SCSB_ACC_SOSTITUZIONI_PC,
   SCSB_UTI_SOSTITUZIONI_PC,
   SCSB_ACC_MASSIMALI_PC,
   SCSB_UTI_MASSIMALI_PC,
   SCGB_ACC_CASSA_BT_PC,
   SCGB_UTI_CASSA_BT_PC,
   SCGB_ACC_SMOBILIZZO_PC,
   SCGB_UTI_SMOBILIZZO_PC,
   SCGB_ACC_CASSA_MLT_PC,
   SCGB_UTI_CASSA_MLT_PC,
   SCGB_ACC_FIRMA_PC,
   SCGB_UTI_FIRMA_PC,
   SCGB_TOT_GAR_PC,
   SCGB_ACC_SOSTITUZIONI_PC,
   SCGB_UTI_SOSTITUZIONI_PC,
   SCGB_ACC_MASSIMALI_PC,
   SCGB_UTI_MASSIMALI_PC,
   SCGB_ACC_TOT_PC,
   SCGB_UTI_TOT_PC,
   SCSB_QIS_ACC_PC,
   SCSB_QIS_UTI_PC,
   SCGB_QIS_ACC_PC,
   SCGB_QIS_UTI_PC,
   SCGB_ACC_SIS_PC,
   SCGB_UTI_SIS_PC
)
AS
   SELECT                                                     -- V1 VG Created
          -- V2 06/05/2011 VG: CR
          -- v3 07/07/2011 MM massimali e sostituzioni
          --110907: QIS forzati a number
          D.COD_ABI_CARTOLARIZZATO,
          D.COD_ABI_ISTITUTO,
          D.DESC_ISTITUTO,
          D.COD_NDG,
          D.COD_SNDG,
          X.COD_STATO COD_STATO_AT,
          D.DTA_CONTROLLO_AT,
          D.DTA_PCR_AT,
          D.SCSB_ACC_CASSA_BT_AT,
          D.SCSB_UTI_CASSA_BT_AT,
          D.SCSB_ACC_SMOBILIZZO_AT,
          D.SCSB_UTI_SMOBILIZZO_AT,
          D.SCSB_ACC_CASSA_MLT_AT,
          D.SCSB_UTI_CASSA_MLT_AT,
          D.SCSB_ACC_FIRMA_AT,
          D.SCSB_UTI_FIRMA_AT,
          D.SCSB_ACC_TOT_AT,
          D.SCSB_UTI_TOT_AT,
          D.SCSB_TOT_GAR_AT,
          --
          D.SCSB_ACC_SOSTITUZIONI_AT,
          D.SCSB_UTI_SOSTITUZIONI_AT,
          D.SCSB_ACC_MASSIMALI_AT,
          D.SCSB_UTI_MASSIMALI_AT,
          --
          D.SCGB_ACC_CASSA_BT_AT,
          D.SCGB_UTI_CASSA_BT_AT,
          D.SCGB_ACC_SMOBILIZZO_AT,
          D.SCGB_UTI_SMOBILIZZO_AT,
          D.SCGB_ACC_CASSA_MLT_AT,
          D.SCGB_UTI_CASSA_MLT_AT,
          D.SCGB_ACC_FIRMA_AT,
          D.SCGB_UTI_FIRMA_AT,
          D.SCGB_TOT_GAR_AT,
          --
          D.SCGB_ACC_SOSTITUZIONI_AT,
          D.SCGB_UTI_SOSTITUZIONI_AT,
          D.SCGB_ACC_MASSIMALI_AT,
          D.SCGB_UTI_MASSIMALI_AT,
          --
          D.SCGB_UTI_TOT_AT,
          D.SCGB_ACC_TOT_AT,
          D.SCSB_QIS_ACC_AT,
          D.SCSB_QIS_UTI_AT,
          D.SCGB_QIS_ACC_AT,
          D.SCGB_QIS_UTI_AT,
          D.DTA_CR_AT,
          D.SCGB_ACC_SIS_AT,
          D.SCGB_UTI_SIS_AT,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, NULL,
                  D.COD_STATO_1)
             COD_STATO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_1)
             DTA_CONTROLLO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_1)
             DTA_PCR_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_DATE (NULL),
                  D.DTA_CR_1)
             DTA_CR_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_1)
             SCSB_ACC_CASSA_BT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_1)
             SCSB_UTI_CASSA_BT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_1)
             SCSB_ACC_SMOBILIZZO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_1)
             SCSB_UTI_SMOBILIZZO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_1)
             SCSB_ACC_CASSA_MLT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_1)
             SCSB_UTI_CASSA_MLT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_1)
             SCSB_ACC_FIRMA_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_1)
             SCSB_UTI_FIRMA_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_1)
             SCSB_ACC_TOT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_1)
             SCSB_UTI_TOT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_1)
             SCSB_TOT_GAR_1,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_1)
             SCSB_ACC_SOSTITUZIONI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_1)
             SCSB_UTI_SOSTITUZIONI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_1)
             SCSB_ACC_MASSIMALI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_1)
             SCSB_UTI_MASSIMALI_1,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_1)
             SCGB_ACC_CASSA_BT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_1)
             SCGB_UTI_CASSA_BT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_1)
             SCGB_ACC_SMOBILIZZO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_1)
             SCGB_UTI_SMOBILIZZO_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_1)
             SCGB_ACC_CASSA_MLT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_1)
             SCGB_UTI_CASSA_MLT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_1)
             SCGB_ACC_FIRMA_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_1)
             SCGB_UTI_FIRMA_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_1)
             SCGB_TOT_GAR_1,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_1)
             SCGB_ACC_SOSTITUZIONI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_1)
             SCGB_UTI_SOSTITUZIONI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_1)
             SCGB_ACC_MASSIMALI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_1)
             SCGB_UTI_MASSIMALI_1,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_1)
             SCGB_ACC_TOT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_1)
             SCGB_UTI_TOT_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_1)
             SCSB_QIS_ACC_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_1)
             SCSB_QIS_UTI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_1)
             SCGB_QIS_ACC_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_1)
             SCGB_QIS_UTI_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_1)
             SCGB_ACC_SIS_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_1)
             SCGB_UTI_SIS_1,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, NULL,
                  D.COD_STATO_2)
             COD_STATO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_2)
             DTA_CONTROLLO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_2)
             DTA_PCR_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_DATE (NULL),
                  D.DTA_CR_2)
             DTA_CR_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_2)
             SCSB_ACC_CASSA_BT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_2)
             SCSB_UTI_CASSA_BT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_2)
             SCSB_ACC_SMOBILIZZO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_2)
             SCSB_UTI_SMOBILIZZO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_2)
             SCSB_ACC_CASSA_MLT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_2)
             SCSB_UTI_CASSA_MLT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_2)
             SCSB_ACC_FIRMA_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_2)
             SCSB_UTI_FIRMA_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_2)
             SCSB_ACC_TOT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_2)
             SCSB_UTI_TOT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_2)
             SCSB_TOT_GAR_2,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_2)
             SCSB_ACC_SOSTITUZIONI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_2)
             SCSB_UTI_SOSTITUZIONI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_2)
             SCSB_ACC_MASSIMALI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_2)
             SCSB_UTI_MASSIMALI_2,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_2)
             SCGB_ACC_CASSA_BT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_2)
             SCGB_UTI_CASSA_BT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_2)
             SCGB_ACC_SMOBILIZZO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_2)
             SCGB_UTI_SMOBILIZZO_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_2)
             SCGB_ACC_CASSA_MLT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_2)
             SCGB_UTI_CASSA_MLT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_2)
             SCGB_ACC_FIRMA_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_2)
             SCGB_UTI_FIRMA_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_2)
             SCGB_TOT_GAR_2,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_2)
             SCGB_ACC_SOSTITUZIONI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_2)
             SCGB_UTI_SOSTITUZIONI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_2)
             SCGB_ACC_MASSIMALI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_2)
             SCGB_UTI_MASSIMALI_2,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_2)
             SCGB_ACC_TOT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_2)
             SCGB_UTI_TOT_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_2)
             SCSB_QIS_ACC_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_2)
             SCSB_QIS_UTI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_2)
             SCGB_QIS_ACC_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_2),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_2)
             SCGB_QIS_UTI_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_2)
             SCGB_ACC_SIS_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_2)
             SCGB_UTI_SIS_2,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, NULL,
                  D.COD_STATO_3)
             COD_STATO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_3)
             DTA_CONTROLLO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_3)
             DTA_PCR_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_DATE (NULL),
                  D.DTA_CR_3)
             DTA_CR_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_3)
             SCSB_ACC_CASSA_BT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_3)
             SCSB_UTI_CASSA_BT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_3)
             SCSB_ACC_SMOBILIZZO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_3)
             SCSB_UTI_SMOBILIZZO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_3)
             SCSB_ACC_CASSA_MLT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_3)
             SCSB_UTI_CASSA_MLT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_3)
             SCSB_ACC_FIRMA_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_3)
             SCSB_UTI_FIRMA_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_3)
             SCSB_ACC_TOT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_3)
             SCSB_UTI_TOT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_3)
             SCSB_TOT_GAR_3,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_3)
             SCSB_ACC_SOSTITUZIONI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_3)
             SCSB_UTI_SOSTITUZIONI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_3)
             SCSB_ACC_MASSIMALI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_3)
             SCSB_UTI_MASSIMALI_3,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_3)
             SCGB_ACC_CASSA_BT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_3)
             SCGB_UTI_CASSA_BT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_3)
             SCGB_ACC_SMOBILIZZO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_3)
             SCGB_UTI_SMOBILIZZO_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_3)
             SCGB_ACC_CASSA_MLT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_3)
             SCGB_UTI_CASSA_MLT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_3)
             SCGB_ACC_FIRMA_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_3)
             SCGB_UTI_FIRMA_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_3)
             SCGB_TOT_GAR_3,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_3)
             SCGB_ACC_SOSTITUZIONI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_3)
             SCGB_UTI_SOSTITUZIONI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_3)
             SCGB_ACC_MASSIMALI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_3)
             SCGB_UTI_MASSIMALI_3,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_3)
             SCGB_ACC_TOT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_3)
             SCGB_UTI_TOT_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_3)
             SCSB_QIS_ACC_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_3)
             SCSB_QIS_UTI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_3)
             SCGB_QIS_ACC_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_3),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_3)
             SCGB_QIS_UTI_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_3)
             SCGB_ACC_SIS_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_3)
             SCGB_UTI_SIS_3,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, NULL,
                  D.COD_STATO_4)
             COD_STATO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_4)
             DTA_CONTROLLO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_4)
             DTA_PCR_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_DATE (NULL),
                  D.DTA_CR_4)
             DTA_CR_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_4)
             SCSB_ACC_CASSA_BT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_4)
             SCSB_UTI_CASSA_BT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_4)
             SCSB_ACC_SMOBILIZZO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_4)
             SCSB_UTI_SMOBILIZZO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_4)
             SCSB_ACC_CASSA_MLT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_4)
             SCSB_UTI_CASSA_MLT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_4)
             SCSB_ACC_FIRMA_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_4)
             SCSB_UTI_FIRMA_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_4)
             SCSB_ACC_TOT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_4)
             SCSB_UTI_TOT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_4)
             SCSB_TOT_GAR_4,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_4)
             SCSB_ACC_SOSTITUZIONI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_4)
             SCSB_UTI_SOSTITUZIONI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_4)
             SCSB_ACC_MASSIMALI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_4)
             SCSB_UTI_MASSIMALI_4,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_4)
             SCGB_ACC_CASSA_BT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_4)
             SCGB_UTI_CASSA_BT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_4)
             SCGB_ACC_SMOBILIZZO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_4)
             SCGB_UTI_SMOBILIZZO_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_4)
             SCGB_ACC_CASSA_MLT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_4)
             SCGB_UTI_CASSA_MLT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_4)
             SCGB_ACC_FIRMA_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_4)
             SCGB_UTI_FIRMA_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_4)
             SCGB_TOT_GAR_4,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_4)
             SCGB_ACC_SOSTITUZIONI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_4)
             SCGB_UTI_SOSTITUZIONI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_4)
             SCGB_ACC_MASSIMALI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_4)
             SCGB_UTI_MASSIMALI_4,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_4)
             SCGB_ACC_TOT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_4)
             SCGB_UTI_TOT_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_4)
             SCSB_QIS_ACC_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_4)
             SCSB_QIS_UTI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_4)
             SCGB_QIS_ACC_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_4),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_4)
             SCGB_QIS_UTI_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_4)
             SCGB_ACC_SIS_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_4)
             SCGB_UTI_SIS_4,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, NULL,
                  D.COD_STATO_5)
             COD_STATO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_5)
             DTA_CONTROLLO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_5)
             DTA_PCR_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_DATE (NULL),
                  D.DTA_CR_5)
             DTA_CR_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_5)
             SCSB_ACC_CASSA_BT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_5)
             SCSB_UTI_CASSA_BT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_5)
             SCSB_ACC_SMOBILIZZO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_5)
             SCSB_UTI_SMOBILIZZO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_5)
             SCSB_ACC_CASSA_MLT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_5)
             SCSB_UTI_CASSA_MLT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_5)
             SCSB_ACC_FIRMA_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_5)
             SCSB_UTI_FIRMA_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_5)
             SCSB_ACC_TOT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_5)
             SCSB_UTI_TOT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_5)
             SCSB_TOT_GAR_5,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_5)
             SCSB_ACC_SOSTITUZIONI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_5)
             SCSB_UTI_SOSTITUZIONI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_5)
             SCSB_ACC_MASSIMALI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_5)
             SCSB_UTI_MASSIMALI_5,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_5)
             SCGB_ACC_CASSA_BT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_5)
             SCGB_UTI_CASSA_BT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_5)
             SCGB_ACC_SMOBILIZZO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_5)
             SCGB_UTI_SMOBILIZZO_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_5)
             SCGB_ACC_CASSA_MLT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_5)
             SCGB_UTI_CASSA_MLT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_5)
             SCGB_ACC_FIRMA_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_5)
             SCGB_UTI_FIRMA_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_5)
             SCGB_TOT_GAR_5,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_5)
             SCGB_ACC_SOSTITUZIONI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_5)
             SCGB_UTI_SOSTITUZIONI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_5)
             SCGB_ACC_MASSIMALI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_5)
             SCGB_UTI_MASSIMALI_5,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_5)
             SCGB_ACC_TOT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_5)
             SCGB_UTI_TOT_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_5)
             SCSB_QIS_ACC_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_5)
             SCSB_QIS_UTI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_5)
             SCGB_QIS_ACC_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_5),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_5)
             SCGB_QIS_UTI_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_5)
             SCGB_ACC_SIS_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_5)
             SCGB_UTI_SIS_5,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, NULL,
                  D.COD_STATO_6)
             COD_STATO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_DATE (NULL),
                  D.DTA_CONTROLLO_6)
             DTA_CONTROLLO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_DATE (NULL),
                  D.DTA_PCR_6)
             DTA_PCR_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_DATE (NULL),
                  D.DTA_CR_6)
             DTA_CR_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_BT_6)
             SCSB_ACC_CASSA_BT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_BT_6)
             SCSB_UTI_CASSA_BT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SMOBILIZZO_6)
             SCSB_ACC_SMOBILIZZO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SMOBILIZZO_6)
             SCSB_UTI_SMOBILIZZO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_CASSA_MLT_6)
             SCSB_ACC_CASSA_MLT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_CASSA_MLT_6)
             SCSB_UTI_CASSA_MLT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_FIRMA_6)
             SCSB_ACC_FIRMA_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_FIRMA_6)
             SCSB_UTI_FIRMA_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_TOT_6)
             SCSB_ACC_TOT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_TOT_6)
             SCSB_UTI_TOT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_TOT_GAR_6)
             SCSB_TOT_GAR_6,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_SOSTITUZIONI_6)
             SCSB_ACC_SOSTITUZIONI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_SOSTITUZIONI_6)
             SCSB_UTI_SOSTITUZIONI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_ACC_MASSIMALI_6)
             SCSB_ACC_MASSIMALI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_UTI_MASSIMALI_6)
             SCSB_UTI_MASSIMALI_6,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_BT_6)
             SCGB_ACC_CASSA_BT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_BT_6)
             SCGB_UTI_CASSA_BT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SMOBILIZZO_6)
             SCGB_ACC_SMOBILIZZO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SMOBILIZZO_6)
             SCGB_UTI_SMOBILIZZO_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_CASSA_MLT_6)
             SCGB_ACC_CASSA_MLT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_CASSA_MLT_6)
             SCGB_UTI_CASSA_MLT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_FIRMA_6)
             SCGB_ACC_FIRMA_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_FIRMA_6)
             SCGB_UTI_FIRMA_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_TOT_GAR_6)
             SCGB_TOT_GAR_6,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SOSTITUZIONI_6)
             SCGB_ACC_SOSTITUZIONI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SOSTITUZIONI_6)
             SCGB_UTI_SOSTITUZIONI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_MASSIMALI_6)
             SCGB_ACC_MASSIMALI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_MASSIMALI_6)
             SCGB_UTI_MASSIMALI_6,
          --
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_TOT_6)
             SCGB_ACC_TOT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_TOT_6)
             SCGB_UTI_TOT_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_ACC_6)
             SCSB_QIS_ACC_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCSB_QIS_UTI_6)
             SCSB_QIS_UTI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_ACC_6)
             SCGB_QIS_ACC_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_6),
                  1, TO_NUMBER (NULL),
                  D.SCGB_QIS_UTI_6)
             SCGB_QIS_UTI_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_ACC_SIS_6)
             SCGB_ACC_SIS_6,
          DECODE (SIGN (F.DTA_FINE_VALIDITA - D.DTA_CONTROLLO_1),
                  1, TO_NUMBER (NULL),
                  D.SCGB_UTI_SIS_6)
             SCGB_UTI_SIS_6,
          F.DTA_FINE_VALIDITA_RC DTA_CONTROLLO_PC,
          F.COD_STATO COD_STATO_PC,
          TRUNC (F.SCSB_DTA_RIFERIMENTO) DTA_PCR_PC,
          TRUNC (F.SCGB_DTA_RIF_CR) DTA_CR_PC,
          F.SCSB_ACC_CASSA_BT SCSB_ACC_CASSA_BT_PC,
          F.SCSB_UTI_CASSA_BT SCSB_UTI_CASSA_BT_PC,
          F.SCSB_ACC_SMOBILIZZO SCSB_ACC_SMOBILIZZO_PC,
          F.SCSB_UTI_SMOBILIZZO SCSB_UTI_SMOBILIZZO_PC,
          F.SCSB_ACC_CASSA_MLT SCSB_ACC_CASSA_MLT_PC,
          F.SCSB_UTI_CASSA_MLT SCSB_UTI_CASSA_MLT_PC,
          F.SCSB_ACC_FIRMA SCSB_ACC_FIRMA_PC,
          F.SCSB_UTI_FIRMA SCSB_UTI_FIRMA_PC,
          F.SCSB_ACC_CASSA + F.SCSB_ACC_FIRMA SCSB_ACC_TOT_PC,
          F.SCSB_UTI_CASSA + F.SCSB_UTI_FIRMA SCSB_UTI_TOT_PC,
          F.SCSB_TOT_GAR SCSB_TOT_GAR_PC,
          --
          F.SCSB_ACC_SOSTITUZIONI SCSB_ACC_SOSTITUZIONI_PC,
          F.SCSB_UTI_SOSTITUZIONI SCSB_UTI_SOSTITUZIONI_PC,
          F.SCSB_ACC_MASSIMALI SCSB_ACC_MASSIMALI_PC,
          F.SCSB_UTI_MASSIMALI SCSB_UTI_MASSIMALI_PC,
          --
          F.SCGB_ACC_CASSA_BT SCGB_ACC_CASSA_BT_PC,
          F.SCGB_UTI_CASSA_BT SCGB_UTI_CASSA_BT_PC,
          F.SCGB_ACC_SMOBILIZZO SCGB_ACC_SMOBILIZZO_PC,
          F.SCGB_UTI_SMOBILIZZO SCGB_UTI_SMOBILIZZO_PC,
          F.SCGB_ACC_CASSA_MLT SCGB_ACC_CASSA_MLT_PC,
          F.SCGB_UTI_CASSA_MLT SCGB_UTI_CASSA_MLT_PC,
          F.SCGB_ACC_FIRMA SCGB_ACC_FIRMA_PC,
          F.SCGB_UTI_FIRMA SCGB_UTI_FIRMA_PC,
          F.SCGB_TOT_GAR SCGB_TOT_GAR_PC,
          --
          F.SCGB_ACC_SOSTITUZIONI SCGB_ACC_SOSTITUZIONI_PC,
          F.SCGB_UTI_SOSTITUZIONI SCGB_UTI_SOSTITUZIONI_PC,
          F.SCGB_ACC_MASSIMALI SCGB_ACC_MASSIMALI_PC,
          F.SCGB_UTI_MASSIMALI SCGB_UTI_MASSIMALI_PC,
          --
          F.SCGB_ACC_CASSA + F.SCGB_ACC_FIRMA SCGB_ACC_TOT_PC,
          F.SCGB_UTI_CASSA + F.SCGB_UTI_FIRMA SCGB_UTI_TOT_PC,
          TO_NUMBER (NULLIF (F.SCSB_QIS_ACC, 'N.D.')) SCSB_QIS_ACC_PC,
          TO_NUMBER (NULLIF (F.SCSB_QIS_UTI, 'N.D.')) SCSB_QIS_UTI_PC,
          TO_NUMBER (NULLIF (F.SCGB_QIS_ACC, 'N.D.')) SCGB_QIS_ACC_PC,
          TO_NUMBER (NULLIF (F.SCGB_QIS_UTI, 'N.D.')) SCGB_QIS_UTI_PC,
          F.SCGB_ACC_SIS SCGB_ACC_SIS_PC,
          F.SCGB_UTI_SIS SCGB_UTI_SIS_PC
     FROM MV_MCRE0_APP_RIO_ESP_SC D,
          V_MCRE0_APP_UPD_FIELDS_P1 X,
          (SELECT *
             FROM (SELECT E1.*,
                          MAX (
                             E1.DTA_FINE_VALIDITA)
                          OVER (
                             PARTITION BY E1.COD_ABI_CARTOLARIZZATO,
                                          E1.COD_NDG)
                             DTA_FINE_VALIDITA_RC
                     FROM T_MCRE0_APP_STORICO_EVENTI E1
                    WHERE E1.FLG_CAMBIO_GESTORE = '1') E2
            WHERE DTA_FINE_VALIDITA_RC = DTA_FINE_VALIDITA) F
    WHERE     D.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO(+)
          AND D.COD_NDG = X.COD_NDG(+)
          AND D.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO(+)
          AND D.COD_NDG = F.COD_NDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_ESP_SC TO MCRE_USR;
