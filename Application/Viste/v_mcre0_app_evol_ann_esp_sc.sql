/* Formatted on 21/07/2014 18:33:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_EVOL_ANN_ESP_SC
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DTA_PCR_AT,
   DTA_PCR_MP,
   DTA_PCR_LY,
   DTA_CR_AT,
   DTA_CR_MP,
   DTA_CR_LY,
   COD_STATO_AT,
   COD_STATO_MP,
   COD_STATO_LY,
   VAL_SB_ACC_CASSA_BT_AT,
   VAL_SB_ACC_CASSA_BT_MP,
   VAL_SB_ACC_CASSA_BT_LY,
   VAL_SB_UTI_CASSA_BT_AT,
   VAL_SB_UTI_CASSA_BT_MP,
   VAL_SB_UTI_CASSA_BT_LY,
   VAL_SB_ACC_CASSA_MLT_AT,
   VAL_SB_ACC_CASSA_MLT_MP,
   VAL_SB_ACC_CASSA_MLT_LY,
   VAL_SB_UTI_CASSA_MLT_AT,
   VAL_SB_UTI_CASSA_MLT_MP,
   VAL_SB_UTI_CASSA_MLT_LY,
   VAL_SB_ACC_SMOBILIZZO_AT,
   VAL_SB_ACC_SMOBILIZZO_MP,
   VAL_SB_ACC_SMOBILIZZO_LY,
   VAL_SB_UTI_SMOBILIZZO_AT,
   VAL_SB_UTI_SMOBILIZZO_MP,
   VAL_SB_UTI_SMOBILIZZO_LY,
   VAL_SB_ACC_FIRMA_AT,
   VAL_SB_ACC_FIRMA_MP,
   VAL_SB_ACC_FIRMA_LY,
   VAL_SB_UTI_FIRMA_AT,
   VAL_SB_UTI_FIRMA_MP,
   VAL_SB_UTI_FIRMA_LY,
   VAL_SB_ACC_TOT_AT,
   VAL_SB_ACC_TOT_MP,
   VAL_SB_ACC_TOT_LY,
   VAL_SB_UTI_TOT_AT,
   VAL_SB_UTI_TOT_MP,
   VAL_SB_UTI_TOT_LY,
   VAL_SB_TOT_GAR_AT,
   VAL_SB_TOT_GAR_MP,
   VAL_SB_TOT_GAR_LY,
   VAL_SB_ACC_SOSTITUZIONI_AT,
   VAL_SB_ACC_SOSTITUZIONI_MP,
   VAL_SB_ACC_SOSTITUZIONI_LY,
   VAL_SB_UTI_SOSTITUZIONI_AT,
   VAL_SB_UTI_SOSTITUZIONI_MP,
   VAL_SB_UTI_SOSTITUZIONI_LY,
   VAL_SB_ACC_MASSIMALI_AT,
   VAL_SB_ACC_MASSIMALI_MP,
   VAL_SB_ACC_MASSIMALI_LY,
   VAL_SB_UTI_MASSIMALI_AT,
   VAL_SB_UTI_MASSIMALI_MP,
   VAL_SB_UTI_MASSIMALI_LY,
   VAL_SB_QIS_ACC_AT,
   VAL_SB_QIS_ACC_MP,
   VAL_SB_QIS_ACC_LY,
   VAL_SB_QIS_UTI_AT,
   VAL_SB_QIS_UTI_MP,
   VAL_SB_QIS_UTI_LY,
   VAL_GB_ACC_CASSA_BT_AT,
   VAL_GB_ACC_CASSA_BT_MP,
   VAL_GB_ACC_CASSA_BT_LY,
   VAL_GB_UTI_CASSA_BT_AT,
   VAL_GB_UTI_CASSA_BT_MP,
   VAL_GB_UTI_CASSA_BT_LY,
   VAL_GB_ACC_CASSA_MLT_AT,
   VAL_GB_ACC_CASSA_MLT_MP,
   VAL_GB_ACC_CASSA_MLT_LY,
   VAL_GB_UTI_CASSA_MLT_AT,
   VAL_GB_UTI_CASSA_MLT_MP,
   VAL_GB_UTI_CASSA_MLT_LY,
   VAL_GB_ACC_SMOBILIZZO_AT,
   VAL_GB_ACC_SMOBILIZZO_MP,
   VAL_GB_ACC_SMOBILIZZO_LY,
   VAL_GB_UTI_SMOBILIZZO_AT,
   VAL_GB_UTI_SMOBILIZZO_MP,
   VAL_GB_UTI_SMOBILIZZO_LY,
   VAL_GB_ACC_FIRMA_AT,
   VAL_GB_ACC_FIRMA_MP,
   VAL_GB_ACC_FIRMA_LY,
   VAL_GB_UTI_FIRMA_AT,
   VAL_GB_UTI_FIRMA_MP,
   VAL_GB_UTI_FIRMA_LY,
   VAL_GB_ACC_TOT_AT,
   VAL_GB_ACC_TOT_MP,
   VAL_GB_ACC_TOT_LY,
   VAL_GB_UTI_TOT_AT,
   VAL_GB_UTI_TOT_MP,
   VAL_GB_UTI_TOT_LY,
   VAL_GB_TOT_GAR_AT,
   VAL_GB_TOT_GAR_MP,
   VAL_GB_TOT_GAR_LY,
   VAL_GB_ACC_SOSTITUZIONI_AT,
   VAL_GB_ACC_SOSTITUZIONI_MP,
   VAL_GB_ACC_SOSTITUZIONI_LY,
   VAL_GB_UTI_SOSTITUZIONI_AT,
   VAL_GB_UTI_SOSTITUZIONI_MP,
   VAL_GB_UTI_SOSTITUZIONI_LY,
   VAL_GB_ACC_MASSIMALI_AT,
   VAL_GB_ACC_MASSIMALI_MP,
   VAL_GB_ACC_MASSIMALI_LY,
   VAL_GB_UTI_MASSIMALI_AT,
   VAL_GB_UTI_MASSIMALI_MP,
   VAL_GB_UTI_MASSIMALI_LY,
   VAL_GB_QIS_ACC_AT,
   VAL_GB_QIS_ACC_MP,
   VAL_GB_QIS_ACC_LY,
   VAL_GB_QIS_UTI_AT,
   VAL_GB_QIS_UTI_MP,
   VAL_GB_QIS_UTI_LY
)
AS
   SELECT COD_ABI_CARTOLARIZZATO AS COD_ABI_CARTOLARIZZATO,
          COD_ABI_ISTITUTO AS COD_ABI_ISTITUTO,
          DESC_ISTITUTO AS DESC_ISTITUTO,
          COD_NDG AS COD_NDG,
          COD_SNDG AS COD_SNDG,
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_PCR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_PCR_LY2,
                     DTA_PCR_LY))
             DTA_PCR_LY,
          --data PCR attuale
          DTA_PCR_MP AS DTA_PCR_MP,              --data PCR al mese precedente
          DTA_PCR_LY AS DTA_PCR_LY, --data PCR alla chiusura d'anno precedente
          DTA_CR_AT AS DTA_CR_AT,                            --data CR attuale
          DTA_CR_MP AS DTA_CR_MP,                 --data CR al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_CR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_CR_LY2,
                     DTA_CR_LY))
             DTA_CR_LY,
          --data CR alla chiusura d'anno precedente
          COD_STATO_AT AS COD_STATO_AT,                        --stato attuale
          COD_STATO_MP AS COD_STATO_MP,             --stato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, COD_STATO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, COD_STATO_LY2,
                     COD_STATO_LY))
             AS COD_STATO_LY,          --stato alla chiusura d'anno precedente
          --ESPOSIZIONE BANCA
          SCSB_ACC_CASSA_BT_AT AS VAL_SB_ACC_CASSA_BT_AT, --accordato cassa breve termine attuale
          SCSB_ACC_CASSA_BT_MP AS VAL_SB_ACC_CASSA_BT_MP, --accordato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_CASSA_BT_LY2,
                     SCSB_ACC_CASSA_BT_LY))
             AS VAL_SB_ACC_CASSA_BT_LY, --accordato cassa breve termine alla chiusura d'anno precedente
          SCSB_UTI_CASSA_BT_AT AS VAL_SB_UTI_CASSA_BT_AT, --utilizzato cassa breve termine attuale
          SCSB_UTI_CASSA_BT_MP AS VAL_SB_UTI_CASSA_BT_MP, --utilizzato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_CASSA_BT_LY2,
                     SCSB_UTI_CASSA_BT_LY))
             AS VAL_SB_UTI_CASSA_BT_LY, --utilizzato cassa breve termine alla chiusura d'anno precedente
          SCSB_ACC_CASSA_MLT_AT AS VAL_SB_ACC_CASSA_MLT_AT, --accordato cassa medio-lungo termine attuale
          SCSB_ACC_CASSA_MLT_MP AS VAL_SB_ACC_CASSA_MLT_MP, --accordato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_CASSA_MLT_LY2,
                     SCSB_ACC_CASSA_MLT_LY))
             AS VAL_SB_ACC_CASSA_MLT_LY, --accordato cassa medio-lungo termine alla chiusura d'anno precedente
          SCSB_UTI_CASSA_MLT_AT AS VAL_SB_UTI_CASSA_MLT_AT, --utilizzato cassa medio-lungo termine attuale
          SCSB_UTI_CASSA_MLT_MP AS VAL_SB_UTI_CASSA_MLT_MP, --utilizzato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_CASSA_MLT_LY2,
                     SCSB_UTI_CASSA_MLT_LY))
             AS VAL_SB_UTI_CASSA_MLT_LY, --utilizzato cassa medio-lungo termine alla chiusura d'anno precedente
          SCSB_ACC_SMOBILIZZO_AT AS VAL_SB_ACC_SMOBILIZZO_AT, --accordato smobilizzo attuale
          SCSB_ACC_SMOBILIZZO_MP AS VAL_SB_ACC_SMOBILIZZO_MP, --accordato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_SMOBILIZZO_LY2,
                     SCSB_ACC_SMOBILIZZO_LY))
             AS VAL_SB_ACC_SMOBILIZZO_LY, --accordato smobilizzo alla chiusura d'anno precedente
          SCSB_UTI_SMOBILIZZO_AT AS VAL_SB_UTI_SMOBILIZZO_AT, --utilizzato smobilizzo attuale
          SCSB_UTI_SMOBILIZZO_MP AS VAL_SB_UTI_SMOBILIZZO_MP, --utilizzato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_SMOBILIZZO_LY2,
                     SCSB_UTI_SMOBILIZZO_LY))
             AS VAL_SB_UTI_SMOBILIZZO_LY, --utilizzato smobilizzo alla chiusura d'anno precedente
          SCSB_ACC_FIRMA_AT AS VAL_SB_ACC_FIRMA_AT, --accordato di firma attuale
          SCSB_ACC_FIRMA_MP AS VAL_SB_ACC_FIRMA_MP, --accordato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_FIRMA_LY2,
                     SCSB_ACC_FIRMA_LY))
             AS VAL_SB_ACC_FIRMA_LY, --accordato di firma alla chiusura d'anno precedente
          SCSB_UTI_FIRMA_AT AS VAL_SB_UTI_FIRMA_AT, --utilizzato di firma attuale
          SCSB_UTI_FIRMA_MP AS VAL_SB_UTI_FIRMA_MP, --utilizzato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_FIRMA_LY2,
                     SCSB_UTI_FIRMA_LY))
             AS VAL_SB_UTI_FIRMA_LY, --utilizzato di firma alla chiusura d'anno precedente
          SCSB_ACC_TOT_AT AS VAL_SB_ACC_TOT_AT,     --totale accordato attuale
          SCSB_ACC_TOT_MP AS VAL_SB_ACC_TOT_MP, --totale accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_TOT_LY2,
                     SCSB_ACC_TOT_LY))
             AS VAL_SB_ACC_TOT_LY, --totale accordato alla chiusura d'anno precedente
          SCSB_UTI_TOT_AT AS VAL_SB_UTI_TOT_AT,    --totale utilizzato attuale
          SCSB_UTI_TOT_MP AS VAL_SB_UTI_TOT_MP, --totale utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_TOT_LY2,
                     SCSB_UTI_TOT_LY))
             AS VAL_SB_UTI_TOT_LY, --totale utilizzato alla chiusura d'anno precedente
          SCSB_TOT_GAR_AT AS VAL_SB_TOT_GAR_AT,     --totale garantito attuale
          SCSB_TOT_GAR_MP AS VAL_SB_TOT_GAR_MP, --totale garantito al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_TOT_GAR_LY2,
                     SCSB_TOT_GAR_LY))
             AS VAL_SB_TOT_GAR_LY, --totale garantito alla chiusura d'anno precedente
          SCSB_ACC_SOSTITUZIONI_AT AS VAL_SB_ACC_SOSTITUZIONI_AT, --accordato sostituzioni attuale
          SCSB_ACC_SOSTITUZIONI_MP AS VAL_SB_ACC_SOSTITUZIONI_MP, --accordato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_SOSTITUZIONI_LY2,
                     SCSB_ACC_SOSTITUZIONI_LY))
             AS VAL_SB_ACC_SOSTITUZIONI_LY, --accordato sostituzioni alla chiusura d'anno precedente
          SCSB_UTI_SOSTITUZIONI_AT AS VAL_SB_UTI_SOSTITUZIONI_AT, --utilizzato sostituzioni attuale
          SCSB_UTI_SOSTITUZIONI_MP AS VAL_SB_UTI_SOSTITUZIONI_MP, --utilizzato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_SOSTITUZIONI_LY2,
                     SCSB_UTI_SOSTITUZIONI_LY))
             AS VAL_SB_UTI_SOSTITUZIONI_LY, --utilizzato sostituzioni alla chiusura d'anno precedente
          SCSB_ACC_MASSIMALI_AT AS VAL_SB_ACC_MASSIMALI_AT, --accordato massimali attuale
          SCSB_ACC_MASSIMALI_MP AS VAL_SB_ACC_MASSIMALI_MP, --accordato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_ACC_MASSIMALI_LY2,
                     SCSB_ACC_MASSIMALI_LY))
             AS VAL_SB_ACC_MASSIMALI_LY, --accordato massimali alla chiusura d'anno precedente
          SCSB_UTI_MASSIMALI_AT AS VAL_SB_UTI_MASSIMALI_AT, --utilizzato massimali attuale
          SCSB_UTI_MASSIMALI_MP AS VAL_SB_UTI_MASSIMALI_MP, --utilizzato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_UTI_MASSIMALI_LY2,
                     SCSB_UTI_MASSIMALI_LY))
             AS VAL_SB_UTI_MASSIMALI_LY, --utilizzato massimali alla chiusura d'anno precedente
          SCSB_QIS_ACC_AT AS VAL_SB_QIS_ACC_AT,        --QIS accordato attuale
          SCSB_QIS_ACC_MP AS VAL_SB_QIS_ACC_MP, --QIS accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_QIS_ACC_LY2,
                     SCSB_QIS_ACC_LY))
             AS VAL_SB_QIS_ACC_LY, --QIS accordato alla chiusura d'anno precedente
          SCSB_QIS_UTI_AT AS VAL_SB_QIS_UTI_AT,       --QIS utilizzato attuale
          SCSB_QIS_UTI_MP AS VAL_SB_QIS_UTI_MP, --QIS utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCSB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCSB_QIS_UTI_LY2,
                     SCSB_QIS_UTI_LY))
             AS VAL_SB_QIS_UTI_LY, --QIS utilizzato alla chiusura d'anno precedente
          --ESPOSIZIONE GRUPPO BANCARIO
          SCGB_ACC_CASSA_BT_AT AS VAL_GB_ACC_CASSA_BT_AT, --accordato cassa breve termine attuale
          SCGB_ACC_CASSA_BT_MP AS VAL_GB_ACC_CASSA_BT_MP, --accordato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_CASSA_BT_LY2,
                     SCGB_ACC_CASSA_BT_LY))
             AS VAL_GB_ACC_CASSA_BT_LY, --accordato cassa breve termine alla chiusura d'anno precedente
          SCGB_UTI_CASSA_BT_AT AS VAL_GB_UTI_CASSA_BT_AT, --utilizzato cassa breve termine attuale
          SCGB_UTI_CASSA_BT_MP AS VAL_GB_UTI_CASSA_BT_MP, --utilizzato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_CASSA_BT_LY2,
                     SCGB_UTI_CASSA_BT_LY))
             AS VAL_GB_UTI_CASSA_BT_LY, --utilizzato cassa breve termine alla chiusura d'anno precedente
          SCGB_ACC_CASSA_MLT_AT AS VAL_GB_ACC_CASSA_MLT_AT, --accordato cassa medio-lungo termine attuale
          SCGB_ACC_CASSA_MLT_MP AS VAL_GB_ACC_CASSA_MLT_MP, --accordato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_CASSA_MLT_LY2,
                     SCGB_ACC_CASSA_MLT_LY))
             AS VAL_GB_ACC_CASSA_MLT_LY, --accordato cassa medio-lungo termine alla chiusura d'anno precedente
          SCGB_UTI_CASSA_MLT_AT AS VAL_GB_UTI_CASSA_MLT_AT, --utilizzato cassa medio-lungo termine attuale
          SCGB_UTI_CASSA_MLT_MP AS VAL_GB_UTI_CASSA_MLT_MP, --utilizzato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_CASSA_MLT_LY2,
                     SCGB_UTI_CASSA_MLT_LY))
             AS VAL_GB_UTI_CASSA_MLT_LY, --utilizzato cassa medio-lungo termine alla chiusura d'anno precedente
          SCGB_ACC_SMOBILIZZO_AT AS VAL_GB_ACC_SMOBILIZZO_AT, --accordato smobilizzo attuale
          SCGB_ACC_SMOBILIZZO_MP AS VAL_GB_ACC_SMOBILIZZO_MP, --accordato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_SMOBILIZZO_LY2,
                     SCGB_ACC_SMOBILIZZO_LY))
             AS VAL_GB_ACC_SMOBILIZZO_LY, --accordato smobilizzo alla chiusura d'anno precedente
          SCGB_UTI_SMOBILIZZO_AT AS VAL_GB_UTI_SMOBILIZZO_AT, --utilizzato smobilizzo attuale
          SCGB_UTI_SMOBILIZZO_MP AS VAL_GB_UTI_SMOBILIZZO_MP, --utilizzato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_SMOBILIZZO_LY2,
                     SCGB_UTI_SMOBILIZZO_LY))
             AS VAL_GB_UTI_SMOBILIZZO_LY, --utilizzato smobilizzo alla chiusura d'anno precedente
          SCGB_ACC_FIRMA_AT AS VAL_GB_ACC_FIRMA_AT, --accordato di firma attuale
          SCGB_ACC_FIRMA_MP AS VAL_GB_ACC_FIRMA_MP, --accordato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_FIRMA_LY2,
                     SCGB_ACC_FIRMA_LY))
             AS VAL_GB_ACC_FIRMA_LY, --accordato di firma alla chiusura d'anno precedente
          SCGB_UTI_FIRMA_AT AS VAL_GB_UTI_FIRMA_AT, --utilizzato di firma attuale
          SCGB_UTI_FIRMA_MP AS VAL_GB_UTI_FIRMA_MP, --utilizzato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_FIRMA_LY2,
                     SCGB_UTI_FIRMA_LY))
             AS VAL_GB_UTI_FIRMA_LY, --utilizzato di firma alla chiusura d'anno precedente
          SCGB_ACC_TOT_AT AS VAL_GB_ACC_TOT_AT,     --totale accordato attuale
          SCGB_ACC_TOT_MP AS VAL_GB_ACC_TOT_MP, --totale accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_TOT_LY2,
                     SCGB_ACC_TOT_LY))
             AS VAL_GB_ACC_TOT_LY, --totale accordato alla chiusura d'anno precedente
          SCGB_UTI_TOT_AT AS VAL_GB_UTI_TOT_AT,    --totale utilizzato attuale
          SCGB_UTI_TOT_MP AS VAL_GB_UTI_TOT_MP, --totale utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_TOT_LY2,
                     SCGB_UTI_TOT_LY))
             AS VAL_GB_UTI_TOT_LY, --totale utilizzato alla chiusura d'anno precedente
          SCGB_TOT_GAR_AT AS VAL_GB_TOT_GAR_AT,     --totale garantito attuale
          SCGB_TOT_GAR_MP AS VAL_GB_TOT_GAR_MP, --totale garantito al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_TOT_GAR_LY2,
                     SCGB_TOT_GAR_LY))
             AS VAL_GB_TOT_GAR_LY, --totale garantito alla chiusura d'anno precedente
          SCGB_ACC_SOSTITUZIONI_AT AS VAL_GB_ACC_SOSTITUZIONI_AT, --accordato sostituzioni attuale
          SCGB_ACC_SOSTITUZIONI_MP AS VAL_GB_ACC_SOSTITUZIONI_MP, --accordato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_SOSTITUZIONI_LY2,
                     SCGB_ACC_SOSTITUZIONI_LY))
             AS VAL_GB_ACC_SOSTITUZIONI_LY, --accordato sostituzioni alla chiusura d'anno precedente
          SCGB_UTI_SOSTITUZIONI_AT AS VAL_GB_UTI_SOSTITUZIONI_AT, --utilizzato sostituzioni attuale
          SCGB_UTI_SOSTITUZIONI_MP AS VAL_GB_UTI_SOSTITUZIONI_MP, --utilizzato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_SOSTITUZIONI_LY2,
                     SCGB_UTI_SOSTITUZIONI_LY))
             AS VAL_GB_UTI_SOSTITUZIONI_LY, --utilizzato sostituzioni alla chiusura d'anno precedente
          SCGB_ACC_MASSIMALI_AT AS VAL_GB_ACC_MASSIMALI_AT, --accordato massimali attuale
          SCGB_ACC_MASSIMALI_MP AS VAL_GB_ACC_MASSIMALI_MP, --accordato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_ACC_MASSIMALI_LY2,
                     SCGB_ACC_MASSIMALI_LY))
             AS VAL_GB_ACC_MASSIMALI_LY, --accordato massimali alla chiusura d'anno precedente
          SCGB_UTI_MASSIMALI_AT AS VAL_GB_UTI_MASSIMALI_AT, --utilizzato massimali attuale
          SCGB_UTI_MASSIMALI_MP AS VAL_GB_UTI_MASSIMALI_MP, --utilizzato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_UTI_MASSIMALI_LY2,
                     SCGB_UTI_MASSIMALI_LY))
             AS VAL_GB_UTI_MASSIMALI_LY, --utilizzato massimali alla chiusura d'anno precedente
          SCGB_QIS_ACC_AT AS VAL_GB_QIS_ACC_AT,        --QIS accordato attuale
          SCGB_QIS_ACC_MP AS VAL_GB_QIS_ACC_MP, --QIS accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_QIS_ACC_LY2,
                     SCGB_QIS_ACC_LY))
             AS VAL_GB_QIS_ACC_LY, --QIS accordato alla chiusura d'anno precedente
          SCGB_QIS_UTI_AT AS VAL_GB_QIS_UTI_AT,       --QIS utilizzato attuale
          SCGB_QIS_UTI_MP AS VAL_GB_QIS_UTI_MP, --QIS utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, SCGB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, SCGB_QIS_UTI_LY2,
                     SCGB_QIS_UTI_LY))
             AS VAL_GB_QIS_UTI_LY --QIS utilizzato alla chiusura d'anno precedente
     FROM MV_MCRE0_APP_GEST_ESP_SC_ANN;
