/* Formatted on 17/06/2014 18:14:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_SC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
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
   DTA_IRIS,
   DTA_PD_ONLINE,
   DTA_PD_MONITORAGGIO
)
AS
   SELECT                                     -- V1   02/12/2010 VG: Congelata
          -- v1.1 23/12/2010 MM: rimossa condizione Solo Posizioni Singole
          -- v1.2 09/03/2011 MM: passata su tabella PCR
          -- v1.3 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
          -- v1.4 02/05/2011 LF: aggiunti QIS
          -- v1.5 17/06/2011 VG: New PCR
          F.COD_ABI_CARTOLARIZZATO,
          F.COD_NDG,
          F.COD_SNDG,
          A.VAL_PD_ONLINE,
          A.VAL_RATING_ONLINE,
          I.VAL_PD_MONITORAGGIO VAL_PD_MONIT_ONLINE,
          I.VAL_RATING_MONITORAGGIO VAL_RATING_MONIT_ONLINE,
          I.VAL_IRIS_CLI VAL_IRIS,
          I.VAL_LIV_RISCHIO_CLI VAL_LR,
          I.VAL_LGD VAL_LGD,
          I.VAL_EAD VAL_EAD,
          I.VAL_PA VAL_PA,
          SCSB_ACC_CASSA + SCSB_ACC_FIRMA VAL_ACCORDATO,
          SCSB_UTI_CASSA + SCSB_UTI_FIRMA VAL_UTILIZZATO,
          NULL VAL_QI,
          I.DTA_RIFERIMENTO DTA_IRIS,
          A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          I.DTA_PD_MONITORAGGIO           --, cr.scsb_qis_acc, cr.scsb_qis_uti
     FROM T_MCRE0_APP_FILE_GUIDA F,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          T_MCRE0_APP_PCR B,
          T_MCRE0_APP_IRIS I                  /*,
                            t_mcre0_app_cr cr*/
    WHERE     F.COD_ABI_CARTOLARIZZATO = B.COD_ABI_CARTOLARIZZATO(+)
          AND F.COD_NDG = B.COD_NDG(+)
          AND F.COD_SNDG = A.COD_SNDG
          AND F.COD_SNDG = I.COD_SNDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_SC TO MCRE_USR;
