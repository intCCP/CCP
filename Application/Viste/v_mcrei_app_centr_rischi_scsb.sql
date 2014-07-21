/* Formatted on 21/07/2014 18:39:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CENTR_RISCHI_SCSB
(
   COD_ABI,
   COD_SNDG,
   VAL_ACC_SB_BRT,
   VAL_ACC_SB_MLT,
   VAL_ACC_SB_FIRMA,
   VAL_ACC_SB_TOT,
   VAL_UTI_SB_BRT,
   VAL_UTI_SC_MLT,
   VAL_UTI_SC_FIRM,
   VAL_UTI_SC_TOT,
   VAL_SCO_SB_TOT,
   DTA_RIFERIMENTO_CR
)
AS
   SELECT                           -- Manca lo Sconfino per BRT, MLT e Firma,
          -- perche' attualmente non arrivano i dati da flusso

          -- Nota abbreviazioni
          -- SC = Singolo Cliente
          -- ACC = Acordato
          -- UTI = Utilizzato
          -- SCO = Sconfino
          -- BRT = Breve Termine
          -- MLT = Medio Lungo Termine
          AD.COD_ABI_CARTOLARIZZATO AS COD_ABI,
          AD.COD_SNDG AS "COD_SNDG",
          /*CR.VAL_ACC_CR_SCSB_BRT*/
          TO_NUMBER (NULL) AS "VAL_ACC_SB_BRT",
          /*CR.VAL_ACC_CR_SCSB_MLT*/
          TO_NUMBER (NULL) AS "VAL_ACC_SB_MLT",
          /*CR.VAL_ACC_CR_SCSB_FIR*/
          TO_NUMBER (NULL) AS "VAL_ACC_SB_FIRMA",
          CR.VAL_ACC_CR_SCSB AS "VAL_ACC_SB_TOT",
          /*CR.VAL_UTI_CR_SCSB_BRT*/
          TO_NUMBER (NULL) AS "VAL_UTI_SB_BRT",
          /*CR.VAL_UTI_CR_SCSB_MLT*/
          TO_NUMBER (NULL) AS "VAL_UTI_SB_MLT",
          /*CR.VAL_UTI_CR_SCSB_FIR*/
          TO_NUMBER (NULL) AS "VAL_UTI_SB_FIRMA",
          CR.VAL_UTI_CR_SCSB AS "VAL_UTI_SC_TOT",
          CR.VAL_SCO_CR_SCSB AS "VAL_SCO_TOT",
          CR.DTA_CR_SCSB AS DTA_RIFERIMENTO_CR
     FROM T_MCRE0_APP_CR_SC_SB CR, T_MCRE0_APP_ALL_DATA AD
    WHERE     CR.COD_ABI_CARTOLARIZZATO = AD.COD_ABI_CARTOLARIZZATO
          AND CR.COD_NDG = AD.COD_NDG;
