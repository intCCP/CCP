/* Formatted on 17/06/2014 18:03:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_ESP_SC_ANN
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
   COD_STATO_MP,
   DTA_CONTROLLO_MP,
   DTA_PCR_MP,
   DTA_CR_MP,
   SCSB_ACC_CASSA_BT_MP,
   SCSB_UTI_CASSA_BT_MP,
   SCSB_ACC_SMOBILIZZO_MP,
   SCSB_UTI_SMOBILIZZO_MP,
   SCSB_ACC_CASSA_MLT_MP,
   SCSB_UTI_CASSA_MLT_MP,
   SCSB_ACC_FIRMA_MP,
   SCSB_UTI_FIRMA_MP,
   SCSB_ACC_TOT_MP,
   SCSB_UTI_TOT_MP,
   SCSB_TOT_GAR_MP,
   SCSB_ACC_SOSTITUZIONI_MP,
   SCSB_UTI_SOSTITUZIONI_MP,
   SCSB_ACC_MASSIMALI_MP,
   SCSB_UTI_MASSIMALI_MP,
   SCGB_ACC_CASSA_BT_MP,
   SCGB_UTI_CASSA_BT_MP,
   SCGB_ACC_SMOBILIZZO_MP,
   SCGB_UTI_SMOBILIZZO_MP,
   SCGB_ACC_CASSA_MLT_MP,
   SCGB_UTI_CASSA_MLT_MP,
   SCGB_ACC_FIRMA_MP,
   SCGB_UTI_FIRMA_MP,
   SCGB_TOT_GAR_MP,
   SCGB_ACC_SOSTITUZIONI_MP,
   SCGB_UTI_SOSTITUZIONI_MP,
   SCGB_ACC_MASSIMALI_MP,
   SCGB_UTI_MASSIMALI_MP,
   SCGB_UTI_TOT_MP,
   SCGB_ACC_TOT_MP,
   SCSB_QIS_ACC_MP,
   SCSB_QIS_UTI_MP,
   SCGB_QIS_ACC_MP,
   SCGB_QIS_UTI_MP,
   COD_STATO_LY,
   DTA_CONTROLLO_LY,
   DTA_PCR_LY,
   DTA_CR_LY,
   SCSB_ACC_CASSA_BT_LY,
   SCSB_UTI_CASSA_BT_LY,
   SCSB_ACC_SMOBILIZZO_LY,
   SCSB_UTI_SMOBILIZZO_LY,
   SCSB_ACC_CASSA_MLT_LY,
   SCSB_UTI_CASSA_MLT_LY,
   SCSB_ACC_FIRMA_LY,
   SCSB_UTI_FIRMA_LY,
   SCSB_ACC_TOT_LY,
   SCSB_UTI_TOT_LY,
   SCSB_TOT_GAR_LY,
   SCSB_ACC_SOSTITUZIONI_LY,
   SCSB_UTI_SOSTITUZIONI_LY,
   SCSB_ACC_MASSIMALI_LY,
   SCSB_UTI_MASSIMALI_LY,
   SCGB_ACC_CASSA_BT_LY,
   SCGB_UTI_CASSA_BT_LY,
   SCGB_ACC_SMOBILIZZO_LY,
   SCGB_UTI_SMOBILIZZO_LY,
   SCGB_ACC_CASSA_MLT_LY,
   SCGB_UTI_CASSA_MLT_LY,
   SCGB_ACC_FIRMA_LY,
   SCGB_UTI_FIRMA_LY,
   SCGB_TOT_GAR_LY,
   SCGB_ACC_SOSTITUZIONI_LY,
   SCGB_UTI_SOSTITUZIONI_LY,
   SCGB_ACC_MASSIMALI_LY,
   SCGB_UTI_MASSIMALI_LY,
   SCGB_ACC_TOT_LY,
   SCGB_UTI_TOT_LY,
   SCSB_QIS_ACC_LY,
   SCSB_QIS_UTI_LY,
   SCGB_QIS_ACC_LY,
   SCGB_QIS_UTI_LY
)
AS
   SELECT                                              -- V2 09/05/2011 VG: CR
          -- v3 08/07/2011 MM: massimali e sostituzioni
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
          --
          SCSB_ACC_SOSTITUZIONI_AT,
          SCSB_UTI_SOSTITUZIONI_AT,
          SCSB_ACC_MASSIMALI_AT,
          SCSB_UTI_MASSIMALI_AT,
          --
          SCGB_ACC_CASSA_BT_AT,
          SCGB_UTI_CASSA_BT_AT,
          SCGB_ACC_SMOBILIZZO_AT,
          SCGB_UTI_SMOBILIZZO_AT,
          SCGB_ACC_CASSA_MLT_AT,
          SCGB_UTI_CASSA_MLT_AT,
          SCGB_ACC_FIRMA_AT,
          SCGB_UTI_FIRMA_AT,
          SCGB_TOT_GAR_AT,
          --
          SCGB_ACC_SOSTITUZIONI_AT,
          SCGB_UTI_SOSTITUZIONI_AT,
          SCGB_ACC_MASSIMALI_AT,
          SCGB_UTI_MASSIMALI_AT,
          --
          SCGB_UTI_TOT_AT,
          SCGB_ACC_TOT_AT,
          SCSB_QIS_ACC_AT,
          SCSB_QIS_UTI_AT,
          SCGB_QIS_ACC_AT,
          SCGB_QIS_UTI_AT,
          DTA_CR_AT,
          COD_STATO_MP,
          DTA_CONTROLLO_MP,
          DTA_PCR_MP,
          DTA_CR_MP,
          SCSB_ACC_CASSA_BT_MP,
          SCSB_UTI_CASSA_BT_MP,
          SCSB_ACC_SMOBILIZZO_MP,
          SCSB_UTI_SMOBILIZZO_MP,
          SCSB_ACC_CASSA_MLT_MP,
          SCSB_UTI_CASSA_MLT_MP,
          SCSB_ACC_FIRMA_MP,
          SCSB_UTI_FIRMA_MP,
          SCSB_ACC_TOT_MP,
          SCSB_UTI_TOT_MP,
          SCSB_TOT_GAR_MP,
          --
          SCSB_ACC_SOSTITUZIONI_MP,
          SCSB_UTI_SOSTITUZIONI_MP,
          SCSB_ACC_MASSIMALI_MP,
          SCSB_UTI_MASSIMALI_MP,
          --
          SCGB_ACC_CASSA_BT_MP,
          SCGB_UTI_CASSA_BT_MP,
          SCGB_ACC_SMOBILIZZO_MP,
          SCGB_UTI_SMOBILIZZO_MP,
          SCGB_ACC_CASSA_MLT_MP,
          SCGB_UTI_CASSA_MLT_MP,
          SCGB_ACC_FIRMA_MP,
          SCGB_UTI_FIRMA_MP,
          SCGB_TOT_GAR_MP,
          --
          SCGB_ACC_SOSTITUZIONI_MP,
          SCGB_UTI_SOSTITUZIONI_MP,
          SCGB_ACC_MASSIMALI_MP,
          SCGB_UTI_MASSIMALI_MP,
          --
          SCGB_UTI_TOT_MP,
          SCGB_ACC_TOT_MP,
          SCSB_QIS_ACC_MP,
          SCSB_QIS_UTI_MP,
          SCGB_QIS_ACC_MP,
          SCGB_QIS_UTI_MP,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, COD_STATO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, COD_STATO_LY2,
                     COD_STATO_LY))
             COD_STATO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_CONTROLLO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_CONTROLLO_LY2,
                     DTA_CONTROLLO_LY))
             DTA_CONTROLLO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_PCR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_PCR_LY2,
                     DTA_PCR_LY))
             DTA_PCR_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_CR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_CR_LY2,
                     DTA_CR_LY))
             DTA_CR_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_CASSA_BT_LY2,
                     SCSB_ACC_CASSA_BT_LY))
             SCSB_ACC_CASSA_BT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_CASSA_BT_LY2,
                     SCSB_UTI_CASSA_BT_LY))
             SCSB_UTI_CASSA_BT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_SMOBILIZZO_LY2,
                     SCSB_ACC_SMOBILIZZO_LY))
             SCSB_ACC_SMOBILIZZO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_SMOBILIZZO_LY2,
                     SCSB_UTI_SMOBILIZZO_LY))
             SCSB_UTI_SMOBILIZZO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_CASSA_MLT_LY2,
                     SCSB_ACC_CASSA_MLT_LY))
             SCSB_ACC_CASSA_MLT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_CASSA_MLT_LY2,
                     SCSB_UTI_CASSA_MLT_LY))
             SCSB_UTI_CASSA_MLT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_FIRMA_LY2,
                     SCSB_ACC_FIRMA_LY))
             SCSB_ACC_FIRMA_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_FIRMA_LY2,
                     SCSB_UTI_FIRMA_LY))
             SCSB_UTI_FIRMA_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_TOT_LY2,
                     SCSB_ACC_TOT_LY))
             SCSB_ACC_TOT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_TOT_LY2,
                     SCSB_UTI_TOT_LY))
             SCSB_UTI_TOT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_TOT_GAR_LY2,
                     SCSB_TOT_GAR_LY))
             SCSB_TOT_GAR_LY,
          --
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_SOSTITUZIONI_LY2,
                     SCSB_ACC_SOSTITUZIONI_LY))
             SCSB_ACC_SOSTITUZIONI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_SOSTITUZIONI_LY2,
                     SCSB_UTI_SOSTITUZIONI_LY))
             SCSB_UTI_SOSTITUZIONI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_MASSIMALI_LY2,
                     SCSB_ACC_MASSIMALI_LY))
             SCSB_ACC_MASSIMALI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_MASSIMALI_LY2,
                     SCSB_UTI_MASSIMALI_LY))
             SCSB_UTI_MASSIMALI_LY,
          --
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_CASSA_BT_LY2,
                     SCGB_ACC_CASSA_BT_LY))
             SCGB_ACC_CASSA_BT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_CASSA_BT_LY2,
                     SCGB_UTI_CASSA_BT_LY))
             SCGB_UTI_CASSA_BT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_SMOBILIZZO_LY2,
                     SCGB_ACC_SMOBILIZZO_LY))
             SCGB_ACC_SMOBILIZZO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_SMOBILIZZO_LY2,
                     SCGB_UTI_SMOBILIZZO_LY))
             SCGB_UTI_SMOBILIZZO_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_CASSA_MLT_LY2,
                     SCGB_ACC_CASSA_MLT_LY))
             SCGB_ACC_CASSA_MLT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_CASSA_MLT_LY2,
                     SCGB_UTI_CASSA_MLT_LY))
             SCGB_UTI_CASSA_MLT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_FIRMA_LY2,
                     SCGB_ACC_FIRMA_LY))
             SCGB_ACC_FIRMA_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_FIRMA_LY2,
                     SCGB_UTI_FIRMA_LY))
             SCGB_UTI_FIRMA_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_TOT_GAR_LY2,
                     SCGB_TOT_GAR_LY))
             SCGB_TOT_GAR_LY,
          --
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_SOSTITUZIONI_LY2,
                     SCGB_ACC_SOSTITUZIONI_LY))
             SCGB_ACC_SOSTITUZIONI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_SOSTITUZIONI_LY2,
                     SCGB_UTI_SOSTITUZIONI_LY))
             SCGB_UTI_SOSTITUZIONI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_MASSIMALI_LY2,
                     SCGB_ACC_MASSIMALI_LY))
             SCGB_ACC_MASSIMALI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_MASSIMALI_LY2,
                     SCGB_UTI_MASSIMALI_LY))
             SCGB_UTI_MASSIMALI_LY,
          --
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_TOT_LY2,
                     SCGB_ACC_TOT_LY))
             SCGB_ACC_TOT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_TOT_LY2,
                     SCGB_UTI_TOT_LY))
             SCGB_UTI_TOT_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_QIS_ACC_LY2,
                     SCSB_QIS_ACC_LY))
             SCSB_QIS_ACC_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_QIS_UTI_LY2,
                     SCSB_QIS_UTI_LY))
             SCSB_QIS_UTI_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_QIS_ACC_LY2,
                     SCGB_QIS_ACC_LY))
             SCGB_QIS_ACC_LY,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_QIS_UTI_LY2,
                     SCGB_QIS_UTI_LY))
             SCGB_QIS_UTI_LY
     FROM MV_MCRE0_APP_RIO_ESP_SC_ANN;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_ESP_SC_ANN TO MCRE_USR;
