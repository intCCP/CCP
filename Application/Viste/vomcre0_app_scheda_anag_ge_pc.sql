/* Formatted on 21/07/2014 18:46:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_GE_PC
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
   DTA_PD_MONITORAGGIO
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
             DTA_PD_MONITORAGGIO
     FROM (SELECT E.*,
                  MAX (E.DTA_FINE_VALIDITA)
                     OVER (PARTITION BY E.COD_ABI_CARTOLARIZZATO, E.COD_NDG)
                     DTA_FINE_VALIDITA_RC
             FROM T_MCRE0_APP_STORICO_EVENTI E
            WHERE E.FLG_CAMBIO_GESTORE = 1) E
    WHERE DTA_FINE_VALIDITA_RC = DTA_FINE_VALIDITA;
