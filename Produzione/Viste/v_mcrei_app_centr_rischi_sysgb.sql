/* Formatted on 17/06/2014 18:07:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_CENTR_RISCHI_SYSGB
(
   COD_SNDG,
   VAL_ACC_SYS_CASSA_BRT,
   VAL_ACC_SYS_CASSA_MLT,
   VAL_ACC_SYS_FIRMA,
   VAL_ACC_SYS_TOT,
   VAL_UTI_SYS_CASSA_BRT,
   VAL_UTI_SYS_CASSA_MLT,
   VAL_UTI_SYS_FIRMA,
   VAL_UTI_SYS_TOT,
   VAL_SCO_SYS_TOT,
   VAL_ACC_GB_CASSA_BRT,
   VAL_ACC_GB_CASSA_MLT,
   VAL_ACC_GB_FIRMA,
   VAL_ACC_GB_TOT,
   VAL_UTI_GB_CASSA_BRT,
   VAL_UTI_GB_CASSA_MLT,
   VAL_UTI_GB_FIRMA,
   VAL_UTI_GB_TOT,
   VAL_SCO_GB_TOT,
   DTA_RIFERIMENTO_CR
)
AS
   SELECT                           -- Manca lo Sconfino per BRT, MLT e Firma,
          -- perche' attualmente non arrivano i dati da flusso

          -- Nota abbreviazioni
          -- SYS = Sistema
          -- GB = Gruppo Bancario
          -- ACC = Acordato
          -- UTI = Utilizzato
          -- SCO = Sconfino
          -- BRT = Breve Termine
          -- MLT = Medio Lungo Termine
          CR.COD_SNDG AS "COD_SNDG",
          --------------- Sistema ---------------------------
          /*CR.VAL_ACC_SIS_SC_BRT*/
          TO_NUMBER (NULL) AS "VAL_ACC_SYS_CASSA_BRT",
          /*CR.VAL_ACC_SIS_SC_MLT*/
          TO_NUMBER (NULL) AS "VAL_ACC_SYS_CASSA_MLT",
          /*/*CR.VAL_ACC_SIS_SC_FIR*/
          TO_NUMBER (NULL) AS "VAL_ACC_SYS_FIRMA",
          CR.VAL_ACC_SIS_SC AS "VAL_ACC_SYS_TOT",
          /*CR.VAL_UTI_SIS_SC_BRT*/
          TO_NUMBER (NULL) AS "VAL_UTI_SYS_CASSA_BRT",
          /*CR.VAL_UTI_SIS_SC_MLT*/
          TO_NUMBER (NULL) AS "VAL_UTI_SYS_CASSA_MLT",
          /*CR.VAL_UTI_SIS_SC_FIR*/
          TO_NUMBER (NULL) AS "VAL_UTI_SYS_FIRMA",
          CR.VAL_UTI_SIS_SC AS "VAL_UTI_SYS_TOT",
          CR.VAL_SCO_SIS_SC AS "VAL_SCO_SYS_TOT",
          -------------- Gruppo Bancario --------------------
          /*CR.VAL_ACC_CR_SC_BRT*/
          TO_NUMBER (NULL) AS "VAL_ACC_GB_CASSA_BRT",
          /*CR.VAL_ACC_CR_SC_MLT*/
          TO_NUMBER (NULL) AS "VAL_ACC_GB_CASSA_MLT",
          /*CR.VAL_ACC_CR_SC_FIR*/
          TO_NUMBER (NULL) AS "VAL_ACC_GB_FIRMA",
          CR.VAL_ACC_CR_SC AS "VAL_ACC_GB_TOT",
          --         ROUND((CR.VAL_ACC_CR_SC/
          --         DECODE(CR.VAL_ACC_SIS_SC,0,NULL,CR.VAL_ACC_SIS_SC))* 100) AS "VAL_PERC_ACC_GB_SU_SYS",
          --
          /*CR.VAL_UTI_CR_SC_BRT*/
          TO_NUMBER (NULL) AS "VAL_UTI_GB_CASSA_BRT",
          /*CR.VAL_UTI_CR_SC_MLT*/
          TO_NUMBER (NULL) AS "VAL_UTI_GB_CASSA_MLT",
          /*CR.VAL_UTI_CR_SC_FIR*/
          TO_NUMBER (NULL) AS "VAL_UTI_GB_FIRMA",
          CR.VAL_UTI_CR_SC AS "VAL_UTI_GB_TOT",
          --          ROUND((CR.VAL_UTI_CR_SC/
          --          DECODE(CR.VAL_UTI_SIS_SC, 0, NULL,CR.VAL_UTI_SIS_SC))* 100) AS "VAL_PERC_UTI_GB_SU_SYS",

          CR.VAL_SCO_CR_SC AS "VAL_SCO_GB_TOT",
          --          ROUND((CR.VAL_SCO_CR_SC/
          --          DECODE(CR.VAL_SCO_SIS_SC,0,NULL,CR.VAL_SCO_SIS_SC))* 100) AS "VAL_PERC_SCO_GB_SU_SYS"
          --
          CR.DTA_RIFERIMENTO_CR
     FROM T_MCRE0_APP_CR_SC_GB CR;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_CENTR_RISCHI_SYSGB TO MCRE_USR;
