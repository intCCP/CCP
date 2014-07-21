/* Formatted on 21/07/2014 18:33:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_EVOL_ANN_ESP_GE
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
          DTA_PCR_AT AS DTA_PCR_AT,                         --data PCR attuale
          DTA_PCR_MP AS DTA_PCR_MP,              --data PCR al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_PCR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_PCR_LY2,
                     DTA_PCR_LY))
             AS DTA_PCR_LY,         --data PCR alla chiusura d'anno precedente
          DTA_CR_AT AS DTA_CR_AT,                            --data CR attuale
          DTA_CR_MP AS DTA_CR_MP,                 --data CR al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, DTA_CR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, DTA_CR_LY2,
                     DTA_CR_LY))
             AS DTA_CR_LY,           --data CR alla chiusura d'anno precedente
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
          GESB_ACC_CASSA_BT_AT VAL_SB_ACC_CASSA_BT_AT, --accordato cassa breve termine attuale
          GESB_ACC_CASSA_BT_MP VAL_SB_ACC_CASSA_BT_MP, --accordato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_CASSA_BT_LY2,
                     GESB_ACC_CASSA_BT_LY))
             VAL_SB_ACC_CASSA_BT_LY, --accordato cassa breve termine alla chiusura d'anno precedente
          GESB_UTI_CASSA_BT_AT VAL_SB_UTI_CASSA_BT_AT, --utilizzato cassa breve termine attuale
          GESB_UTI_CASSA_BT_MP VAL_SB_UTI_CASSA_BT_MP, --utilizzato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_CASSA_BT_LY2,
                     GESB_UTI_CASSA_BT_LY))
             VAL_SB_UTI_CASSA_BT_LY, --utilizzato cassa breve termine alla chiusura d'anno precedente
          GESB_ACC_CASSA_MLT_AT VAL_SB_ACC_CASSA_MLT_AT, --accordato cassa medio-lungo termine attuale
          GESB_ACC_CASSA_MLT_MP VAL_SB_ACC_CASSA_MLT_MP, --accordato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_CASSA_MLT_LY2,
                     GESB_ACC_CASSA_MLT_LY))
             VAL_SB_ACC_CASSA_MLT_LY, --accordato cassa medio-lungo termine alla chiusura d'anno precedente
          GESB_UTI_CASSA_MLT_AT VAL_SB_UTI_CASSA_MLT_AT, --utilizzato cassa medio-lungo termine attuale
          GESB_UTI_CASSA_MLT_MP VAL_SB_UTI_CASSA_MLT_MP, --utilizzato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_CASSA_MLT_LY2,
                     GESB_UTI_CASSA_MLT_LY))
             VAL_SB_UTI_CASSA_MLT_LY, --utilizzato cassa medio-lungo termine alla chiusura d'anno precedente
          GESB_ACC_SMOBILIZZO_AT VAL_SB_ACC_SMOBILIZZO_AT, --accordato smobilizzo attuale
          GESB_ACC_SMOBILIZZO_MP VAL_SB_ACC_SMOBILIZZO_MP, --accordato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_SMOBILIZZO_LY2,
                     GESB_ACC_SMOBILIZZO_LY))
             VAL_SB_ACC_SMOBILIZZO_LY, --accordato smobilizzo alla chiusura d'anno precedente
          GESB_UTI_SMOBILIZZO_AT VAL_SB_UTI_SMOBILIZZO_AT, --utilizzato smobilizzo attuale
          GESB_UTI_SMOBILIZZO_MP VAL_SB_UTI_SMOBILIZZO_MP, --utilizzato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_SMOBILIZZO_LY2,
                     GESB_UTI_SMOBILIZZO_LY))
             VAL_SB_UTI_SMOBILIZZO_LY, --utilizzato smobilizzo alla chiusura d'anno precedente
          GESB_ACC_FIRMA_AT VAL_SB_ACC_FIRMA_AT,  --accordato di firma attuale
          GESB_ACC_FIRMA_MP VAL_SB_ACC_FIRMA_MP, --accordato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_FIRMA_LY2,
                     GESB_ACC_FIRMA_LY))
             VAL_SB_ACC_FIRMA_LY, --accordato di firma alla chiusura d'anno precedente
          GESB_UTI_FIRMA_AT VAL_SB_UTI_FIRMA_AT, --utilizzato di firma attuale
          GESB_UTI_FIRMA_MP VAL_SB_UTI_FIRMA_MP, --utilizzato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_FIRMA_LY2,
                     GESB_UTI_FIRMA_LY))
             VAL_SB_UTI_FIRMA_LY, --utilizzato di firma alla chiusura d'anno precedente
          GESB_ACC_TOT_AT VAL_SB_ACC_TOT_AT,        --totale accordato attuale
          GESB_ACC_TOT_MP VAL_SB_ACC_TOT_MP, --totale accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_TOT_LY2,
                     GESB_ACC_TOT_LY))
             VAL_SB_ACC_TOT_LY, --totale accordato alla chiusura d'anno precedente
          GESB_UTI_TOT_AT VAL_SB_UTI_TOT_AT,       --totale utilizzato attuale
          GESB_UTI_TOT_MP VAL_SB_UTI_TOT_MP, --totale utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_TOT_LY2,
                     GESB_UTI_TOT_LY))
             VAL_SB_UTI_TOT_LY, --totale utilizzato alla chiusura d'anno precedente
          GESB_TOT_GAR_AT VAL_SB_TOT_GAR_AT,        --totale garantito attuale
          GESB_TOT_GAR_MP VAL_SB_TOT_GAR_MP, --totale garantito al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_TOT_GAR_LY2,
                     GESB_TOT_GAR_LY))
             VAL_SB_TOT_GAR_LY, --totale garantito alla chiusura d'anno precedente
          GESB_ACC_SOSTITUZIONI_AT VAL_SB_ACC_SOSTITUZIONI_AT, --accordato sostituzioni attuale
          GESB_ACC_SOSTITUZIONI_MP VAL_SB_ACC_SOSTITUZIONI_MP, --accordato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_SOSTITUZIONI_LY2,
                     GESB_ACC_SOSTITUZIONI_LY))
             VAL_SB_ACC_SOSTITUZIONI_LY, --accordato sostituzioni alla chiusura d'anno precedente
          GESB_UTI_SOSTITUZIONI_AT VAL_SB_UTI_SOSTITUZIONI_AT, --utilizzato sostituzioni attuale
          GESB_UTI_SOSTITUZIONI_MP VAL_SB_UTI_SOSTITUZIONI_MP, --utilizzato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_SOSTITUZIONI_LY2,
                     GESB_UTI_SOSTITUZIONI_LY))
             VAL_SB_UTI_SOSTITUZIONI_LY, --utilizzato sostituzioni alla chiusura d'anno precedente
          GESB_ACC_MASSIMALI_AT VAL_SB_ACC_MASSIMALI_AT, --accordato massimali attuale
          GESB_ACC_MASSIMALI_MP VAL_SB_ACC_MASSIMALI_MP, --accordato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_ACC_MASSIMALI_LY2,
                     GESB_ACC_MASSIMALI_LY))
             VAL_SB_ACC_MASSIMALI_LY, --accordato massimali alla chiusura d'anno precedente
          GESB_UTI_MASSIMALI_AT VAL_SB_UTI_MASSIMALI_AT, --utilizzato massimali attuale
          GESB_UTI_MASSIMALI_MP VAL_SB_UTI_MASSIMALI_MP, --utilizzato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_UTI_MASSIMALI_LY2,
                     GESB_UTI_MASSIMALI_LY))
             VAL_SB_UTI_MASSIMALI_LY, --utilizzato massimali alla chiusura d'anno precedente
          GESB_QIS_ACC_AT VAL_SB_QIS_ACC_AT,           --QIS accordato attuale
          GESB_QIS_ACC_MP VAL_SB_QIS_ACC_MP, --QIS accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_QIS_ACC_LY2,
                     GESB_QIS_ACC_LY))
             VAL_SB_QIS_ACC_LY, --QIS accordato alla chiusura d'anno precedente
          GESB_QIS_UTI_AT VAL_SB_QIS_UTI_AT,          --QIS utilizzato attuale
          GESB_QIS_UTI_MP VAL_SB_QIS_UTI_MP, --QIS utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GESB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GESB_QIS_UTI_LY2,
                     GESB_QIS_UTI_LY))
             VAL_SB_QIS_UTI_LY, --QIS utilizzato alla chiusura d'anno precedente
          --ESPOSIZIONE GRUPPO BANCARIO
          GEGB_ACC_CASSA_BT_AT VAL_GB_ACC_CASSA_BT_AT, --accordato cassa breve termine attuale
          GEGB_ACC_CASSA_BT_MP VAL_GB_ACC_CASSA_BT_MP, --accordato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_CASSA_BT_LY2,
                     GEGB_ACC_CASSA_BT_LY))
             VAL_GB_ACC_CASSA_BT_LY, --accordato cassa breve termine alla chiusura d'anno precedente
          GEGB_UTI_CASSA_BT_AT VAL_GB_UTI_CASSA_BT_AT, --utilizzato cassa breve termine attuale
          GEGB_UTI_CASSA_BT_MP VAL_GB_UTI_CASSA_BT_MP, --utilizzato cassa breve termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_CASSA_BT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_CASSA_BT_LY2,
                     GEGB_UTI_CASSA_BT_LY))
             VAL_GB_UTI_CASSA_BT_LY, --utilizzato cassa breve termine alla chiusura d'anno precedente
          GEGB_ACC_CASSA_MLT_AT VAL_GB_ACC_CASSA_MLT_AT, --accordato cassa medio-lungo termine attuale
          GEGB_ACC_CASSA_MLT_MP VAL_GB_ACC_CASSA_MLT_MP, --accordato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_CASSA_MLT_LY2,
                     GEGB_ACC_CASSA_MLT_LY))
             VAL_GB_ACC_CASSA_MLT_LY, --accordato cassa medio-lungo termine alla chiusura d'anno precedente
          GEGB_UTI_CASSA_MLT_AT VAL_GB_UTI_CASSA_MLT_AT, --utilizzato cassa medio-lungo termine attuale
          GEGB_UTI_CASSA_MLT_MP VAL_GB_UTI_CASSA_MLT_MP, --utilizzato cassa medio-lungo termine al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_CASSA_MLT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_CASSA_MLT_LY2,
                     GEGB_UTI_CASSA_MLT_LY))
             VAL_GB_UTI_CASSA_MLT_LY, --utilizzato cassa medio-lungo termine alla chiusura d'anno precedente
          GEGB_ACC_SMOBILIZZO_AT VAL_GB_ACC_SMOBILIZZO_AT, --accordato smobilizzo attuale
          GEGB_ACC_SMOBILIZZO_MP VAL_GB_ACC_SMOBILIZZO_MP, --accordato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_SMOBILIZZO_LY2,
                     GEGB_ACC_SMOBILIZZO_LY))
             VAL_GB_ACC_SMOBILIZZO_LY, --accordato smobilizzo alla chiusura d'anno precedente
          GEGB_UTI_SMOBILIZZO_AT VAL_GB_UTI_SMOBILIZZO_AT, --utilizzato smobilizzo attuale
          GEGB_UTI_SMOBILIZZO_MP VAL_GB_UTI_SMOBILIZZO_MP, --utilizzato smobilizzo al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_SMOBILIZZO_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_SMOBILIZZO_LY2,
                     GEGB_UTI_SMOBILIZZO_LY))
             VAL_GB_UTI_SMOBILIZZO_LY, --utilizzato smobilizzo alla chiusura d'anno precedente
          GEGB_ACC_FIRMA_AT VAL_GB_ACC_FIRMA_AT,  --accordato di firma attuale
          GEGB_ACC_FIRMA_MP VAL_GB_ACC_FIRMA_MP, --accordato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_FIRMA_LY2,
                     GEGB_ACC_FIRMA_LY))
             VAL_GB_ACC_FIRMA_LY, --accordato di firma alla chiusura d'anno precedente
          GEGB_UTI_FIRMA_AT VAL_GB_UTI_FIRMA_AT, --utilizzato di firma attuale
          GEGB_UTI_FIRMA_MP VAL_GB_UTI_FIRMA_MP, --utilizzato di firma al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_FIRMA_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_FIRMA_LY2,
                     GEGB_UTI_FIRMA_LY))
             VAL_GB_UTI_FIRMA_LY, --utilizzato di firma alla chiusura d'anno precedente
          GEGB_ACC_TOT_AT VAL_GB_ACC_TOT_AT,        --totale accordato attuale
          GEGB_ACC_TOT_MP VAL_GB_ACC_TOT_MP, --totale accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_TOT_LY2,
                     GEGB_ACC_TOT_LY))
             VAL_GB_ACC_TOT_LY, --totale accordato alla chiusura d'anno precedente
          GEGB_UTI_TOT_AT VAL_GB_UTI_TOT_AT,       --totale utilizzato attuale
          GEGB_UTI_TOT_MP VAL_GB_UTI_TOT_MP, --totale utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_TOT_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_TOT_LY2,
                     GEGB_UTI_TOT_LY))
             VAL_GB_UTI_TOT_LY, --totale utilizzato alla chiusura d'anno precedente
          GEGB_TOT_GAR_AT VAL_GB_TOT_GAR_AT,        --totale garantito attuale
          GEGB_TOT_GAR_MP VAL_GB_TOT_GAR_MP, --totale garantito al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_TOT_GAR_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_TOT_GAR_LY2,
                     GEGB_TOT_GAR_LY))
             VAL_GB_TOT_GAR_LY, --totale garantito alla chiusura d'anno precedente
          GEGB_ACC_SOSTITUZIONI_AT VAL_GB_ACC_SOSTITUZIONI_AT, --accordato sostituzioni attuale
          GEGB_ACC_SOSTITUZIONI_MP VAL_GB_ACC_SOSTITUZIONI_MP, --accordato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_SOSTITUZIONI_LY2,
                     GEGB_ACC_SOSTITUZIONI_LY))
             VAL_GB_ACC_SOSTITUZIONI_LY, --accordato sostituzioni alla chiusura d'anno precedente
          GEGB_UTI_SOSTITUZIONI_AT VAL_GB_UTI_SOSTITUZIONI_AT, --utilizzato sostituzioni attuale
          GEGB_UTI_SOSTITUZIONI_MP VAL_GB_UTI_SOSTITUZIONI_MP, --utilizzato sostituzioni al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_SOSTITUZIONI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_SOSTITUZIONI_LY2,
                     GEGB_UTI_SOSTITUZIONI_LY))
             VAL_GB_UTI_SOSTITUZIONI_LY, --utilizzato sostituzioni alla chiusura d'anno precedente
          GEGB_ACC_MASSIMALI_AT VAL_GB_ACC_MASSIMALI_AT, --accordato massimali attuale
          GEGB_ACC_MASSIMALI_MP VAL_GB_ACC_MASSIMALI_MP, --accordato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_ACC_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_ACC_MASSIMALI_LY2,
                     GEGB_ACC_MASSIMALI_LY))
             VAL_GB_ACC_MASSIMALI_LY, --accordato massimali alla chiusura d'anno precedente
          GEGB_UTI_MASSIMALI_AT VAL_GB_UTI_MASSIMALI_AT, --utilizzato massimali attuale
          GEGB_UTI_MASSIMALI_MP VAL_GB_UTI_MASSIMALI_MP, --utilizzato massimali al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_UTI_MASSIMALI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_UTI_MASSIMALI_LY2,
                     GEGB_UTI_MASSIMALI_LY))
             VAL_GB_UTI_MASSIMALI_LY, --utilizzato massimali alla chiusura d'anno precedente
          GEGB_QIS_ACC_AT VAL_GB_QIS_ACC_AT,           --QIS accordato attuale
          GEGB_QIS_ACC_MP VAL_GB_QIS_ACC_MP, --QIS accordato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_QIS_ACC_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_QIS_ACC_LY2,
                     GEGB_QIS_ACC_LY))
             VAL_GB_QIS_ACC_LY, --QIS accordato alla chiusura d'anno precedente
          GEGB_QIS_UTI_AT VAL_GB_QIS_UTI_AT,          --QIS utilizzato attuale
          GEGB_QIS_UTI_MP VAL_GB_QIS_UTI_MP, --QIS utilizzato al mese precedente
          DECODE (
             DTA_CONTROLLO_LY,
             DTA_CONTROLLO_AT, GEGB_QIS_UTI_LY2,
             DECODE (DTA_CONTROLLO_LY,
                     DTA_CONTROLLO_MP, GEGB_QIS_UTI_LY2,
                     GEGB_QIS_UTI_LY))
             VAL_GB_QIS_UTI_LY --QIS utilizzato alla chiusura d'anno precedente
     FROM MV_MCRE0_APP_GEST_ESP_GE_ANN;
