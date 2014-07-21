/* Formatted on 21/07/2014 18:39:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CR_SC_SB
(
   COD_ABI,
   COD_SNDG,
   VAL_ACC_SC_BRT,
   VAL_ACC_SC_MLT,
   VAL_ACC_SC_FIR,
   VAL_ACC_SC_TOT,
   VAL_UTI_SC_BRT,
   VAL_UTI_SC_MLT,
   VAL_UTI_SC_FIR,
   VAL_UTI_SC_TOT,
   VAL_SCONFINO_SC_TOT
)
AS
   SELECT CR.COD_ABI_CARTOLARIZZATO,
          AD.COD_SNDG,
          CR.VAL_ACC_CR_SCSB_BRT AS VAL_ACC_SC_BRT, -- Accordato Singola Banca Cassa Breve Termine
          CR.VAL_ACC_CR_SCSB_MLT AS VAL_ACC_SC_MLT, -- Accordato Singola Banca Cassa Medio-Lungo Termine
          CR.VAL_ACC_CR_SCSB_FIR AS VAL_ACC_SC_FIR, -- Accordato Singola Banca Firma
          CR.VAL_ACC_CR_SCSB AS VAL_ACC_SC_TOT, -- Accordato Singola Banca Sub-totale
          CR.VAL_UTI_CR_SCSB_BRT AS VAL_UTI_SC_BRT, -- Utilizzato  Singola Banca Cassa Breve Termine
          CR.VAL_UTI_CR_SCSB_MLT AS VAL_UTI_SC_MLT, -- Utilizzato  Singola Banca Cassa Medio-Lungo Termine
          CR.VAL_UTI_CR_SCSB_FIR AS VAL_UTI_SC_FIR, -- Utilizzato  Singola Banca Firma
          CR.VAL_UTI_CR_SCSB AS VAL_UTI_SC_BRT_TOT, -- Utilizzato  Singola Banca Sub-totale
          CR.VAL_SCO_CR_SCSB AS VAL_SCONFINO_SC_TOT -- Sconfino Singolo Cliente Sub-Totale
     FROM T_MCRE0_APP_CR_SC_SB CR, T_MCRE0_APP_ALL_DATA AD
    WHERE     CR.COD_ABI_CARTOLARIZZATO = AD.COD_ABI_CARTOLARIZZATO
          AND CR.COD_NDG = AD.COD_NDG;
