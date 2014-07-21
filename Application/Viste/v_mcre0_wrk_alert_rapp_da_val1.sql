/* Formatted on 21/07/2014 18:38:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_RAPP_DA_VAL1
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT
          -- 04.10.2012 V3 - aggiunta exists sulle stime, da ottimizzare se possibile
          -- 04.10.2012 V4 - RICOSTRUITA LOGICA CON JOIN SENZA T_MCRE0_APP_ALL_DATA, COD_STATO Š SEMPRE A nulL
          -- 12.10.2012 V4.1 - AGGIUNTE STIME EXTRA
          -- 15.10.2012   V.4.2 Tolte stime extra -- la pagina di extra delibera non comporta la scrittura nella stime extra
          PPCR.COD_ABI,
          PPCR.COD_NDG,
          PPCR.COD_SNDG,
          TO_CHAR (NULL) AS COD_STATO,
          'R' AS VAL_ALERT,
          1 AS VAL_CNT_DELIBERE,
          COUNT (PPCR.COD_RAPPORTO)
             OVER (PARTITION BY PPCR.COD_ABI, PPCR.COD_NDG)
             VAL_CNT_RAPPORTI,
          SYSDATE AS DTA_INS,
          NULL AS COD_PROTOCOLLO_DELIBERA
     FROM (SELECT PCR.COD_ABI,
                  PCR.COD_NDG,
                  PCR.COD_SNDG,
                  PCR.COD_RAPPORTO
             FROM MV_STIME_DELIBERE POS,                   -- (1) LE POSIZIONI
                                        MV_RAPP_NNE PCR -- (1) PCR A MENO DI RAPPORTI ESTERI
            WHERE     POS.COD_ABI = PCR.COD_ABI
                  AND POS.COD_NDG = PCR.COD_NDG
                  AND PCR.VAL_IMP_UTILIZZATO > 0) PPCR, --- (2) PCR A MENO DI RAPPORTI ESTERI E POS
          MV_STIME_MAX S2 --- (2) STIME livello rapporto insiemi con MAX_DTA_STIMA
    WHERE     PPCR.COD_ABI = S2.COD_ABI(+)
          AND PPCR.COD_NDG = S2.COD_NDG(+)
          AND PPCR.COD_RAPPORTO = S2.COD_RAPPORTO(+)
          AND S2.COD_RAPPORTO IS NULL;
