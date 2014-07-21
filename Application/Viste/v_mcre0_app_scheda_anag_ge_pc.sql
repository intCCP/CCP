/* Formatted on 21/07/2014 18:36:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_GE_PC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_GRUPPO_ECONOMICO,
   COD_SNDG,
   VAL_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_MONIT_ONLINE,
   VAL_RATING_MONIT_ONLINE,
   VAL_IRIS,
   VAL_LR,
   VAL_LGD,
   VAL_EAD,
   VAL_PA,
   VAL_ACCORDATO,
   VAL_UTILIZZATO,
   VAL_QI,
   DTA_PRESA_IN_CARICO,
   DTA_IRIS,
   DTA_PD_ONLINE,
   DTA_PD_MONITORAGGIO,
   GEGB_QIS_ACC,
   GEGB_QIS_UTI
)
AS
   SELECT                                             -- V1 22/12/2010 VG: New
          -- V2 07/03/2011 MM: aggiunti campi iris
          -- V3 16/03/2011 LF: aggiunti dta_iris, dta_pd_online e dta_pd da storico_eventi
          -- V4 28/03/2011 MM: aggiunte le docode mancanti
          E.COD_ABI_CARTOLARIZZATO,
          E.COD_NDG,
          E.COD_GRUPPO_ECONOMICO,
          E.COD_SNDG,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.VAL_PD_ONLINE)
             VAL_PD_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_RATING_ONLINE)
             VAL_RATING_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_PD)
             VAL_PD_MONIT_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_RATING)
             VAL_RATING_MONIT_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_IRIS_GE) VAL_IRIS,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.LIV_RISCHIO_GE)
             VAL_LR,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_LGD)
             VAL_LGD,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_EAD)
             VAL_EAD,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_PA)
             VAL_PA,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.GEGB_ACC_CASSA + E.GEGB_ACC_FIRMA)
             VAL_ACCORDATO,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.GEGB_UTI_CASSA + E.GEGB_UTI_FIRMA)
             VAL_UTILIZZATO,
          NULL VAL_QI,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_DATE (NULL),
                  DTA_FINE_VALIDITA_RC)
             DTA_PRESA_IN_CARICO,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_DATE (NULL), E.DTA_IRIS)
             DTA_IRIS,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_DATE (NULL),
                  E.DTA_PD_ONLINE)
             DTA_PD_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_DATE (NULL), E.DTA_PD)
             DTA_PD_MONITORAGGIO,
          TO_NUMBER (NULLIF (E.GEGB_QIS_ACC, 'N.D.')) GEGB_QIS_ACC,
          TO_NUMBER (NULLIF (E.GEGB_QIS_UTI, 'N.D.')) GEGB_QIS_UTI
     FROM (SELECT E.COD_ABI_CARTOLARIZZATO,
                  E.COD_NDG,
                  E.DTA_FINE_VAL_TR,
                  MAX (E.DTA_FINE_VAL_TR)
                     OVER (PARTITION BY E.COD_ABI_CARTOLARIZZATO, E.COD_NDG)
                     DTA_FINE_VAL_TR_RC,
                  E.DTA_FINE_VALIDITA,
                  MAX (E.DTA_FINE_VALIDITA)
                     OVER (PARTITION BY E.COD_ABI_CARTOLARIZZATO, E.COD_NDG)
                     DTA_FINE_VALIDITA_RC,
                  E.COD_SNDG,
                  E.COD_STATO,
                  E.VAL_PD_ONLINE,
                  E.VAL_RATING_ONLINE,
                  E.VAL_PD,
                  E.VAL_RATING,
                  E.VAL_IRIS_CLI,
                  E.LIV_RISCHIO_CLI,
                  E.VAL_LGD,
                  E.VAL_EAD,
                  E.VAL_PA,
                  E.SCSB_ACC_CASSA,
                  E.SCSB_ACC_FIRMA,
                  E.SCSB_UTI_CASSA,
                  E.SCSB_UTI_FIRMA,
                  E.DTA_IRIS,
                  E.DTA_PD_ONLINE,
                  E.DTA_PD,
                  E.SCSB_QIS_ACC,
                  E.SCSB_QIS_UTI,
                  E.SCGB_QIS_UTI,
                  E.GEGB_QIS_ACC,
                  E.GEGB_QIS_UTI,
                  E.COD_GRUPPO_ECONOMICO,
                  E.GEGB_ACC_CASSA,
                  E.GEGB_ACC_FIRMA,
                  E.GEGB_UTI_CASSA,
                  E.GEGB_UTI_FIRMA,
                  E.LIV_RISCHIO_GE,
                  E.VAL_IRIS_GE
             FROM T_MCRE0_APP_STORICO_EVENTI E
            WHERE E.FLG_CAMBIO_GESTORE = '1') E
    WHERE DTA_FINE_VALIDITA_RC = DTA_FINE_VALIDITA;
