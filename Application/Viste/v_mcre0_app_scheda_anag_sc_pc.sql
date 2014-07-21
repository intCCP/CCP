/* Formatted on 21/07/2014 18:36:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_SC_PC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
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
   SCSB_QIS_ACC,
   SCSB_QIS_UTI,
   SCGB_QIS_UTI
)
AS
   SELECT                                          -- V1 22/12/2010    VG: New
          -- V2 07/03/20111   MM: aggiunti Iris da storico
          -- V3 16/03/2011    LF: aggiunti dta_iris, dta_pd_online e dta_pd da storico_eventi
          -- V4 04/05/2011    LF: aggiunti scsb_qis_acc e scsb_qis_uti
          -- V4 04/05/2011    VG: aggiunto scgb_qis_uti
          E.COD_ABI_CARTOLARIZZATO,
          E.COD_NDG,
          E.COD_SNDG,
          E.COD_STATO,
          E.VAL_PD_ONLINE,
          E.VAL_RATING_ONLINE,
          E.VAL_PD VAL_PD_MONIT_ONLINE,
          E.VAL_RATING VAL_RATING_MONIT_ONLINE,
          E.VAL_IRIS_CLI VAL_IRIS,
          E.LIV_RISCHIO_CLI VAL_LR,
          E.VAL_LGD VAL_LGD,
          E.VAL_EAD VAL_EAD,
          E.VAL_PA VAL_PA,
          E.SCSB_ACC_CASSA + E.SCSB_ACC_FIRMA VAL_ACCORDATO,
          E.SCSB_UTI_CASSA + E.SCSB_UTI_FIRMA VAL_UTILIZZATO,
          NULL VAL_QI,
          DTA_FINE_VALIDITA_RC DTA_PRESA_IN_CARICO,
          E.DTA_IRIS,
          E.DTA_PD_ONLINE,
          E.DTA_PD DTA_PD_MONITORAGGIO,
          -- sarebbe la dta_pd_monitoraggio
          TO_NUMBER (NULLIF (E.SCSB_QIS_ACC, 'N.D.')) SCSB_QIS_ACC,
          TO_NUMBER (NULLIF (E.SCSB_QIS_UTI, 'N.D.')) SCSB_QIS_UTI,
          TO_NUMBER (NULLIF (E.SCGB_QIS_UTI, 'N.D.')) SCGB_QIS_UTI
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
                  E.SCGB_QIS_UTI
             FROM T_MCRE0_APP_STORICO_EVENTI E
            WHERE E.FLG_CAMBIO_GESTORE = '1') E
    WHERE     DTA_FINE_VALIDITA_RC = DTA_FINE_VALIDITA
          AND DTA_FINE_VAL_TR_RC = DTA_FINE_VAL_TR;
