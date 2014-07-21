/* Formatted on 17/06/2014 18:14:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_GE
(
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
   DTA_IRIS,
   DTA_PD_ONLINE,
   DTA_PD_MONITORAGGIO
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          -- v2 08/03/2011 MM: passata su tabella PCR
          -- v3 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
          -- v4 28/03/2011 VG: dati presi per ge
          -- v5 21/04/2011 VG: aggiunto cod_sndg per capogruppo
          -- V6 02/05/2011 LF: aggiunti i campi QIS
          -- V7 02/05/2011 VG: PCR NUOVA 3 con CR commentata
          -- V8 20/06/2011 VG: Solo GE join FG
          GE.COD_GRUPPO_ECONOMICO,
          GE.COD_SNDG,
          A.VAL_PD_ONLINE,
          A.VAL_RATING_ONLINE,
          I.VAL_PD_MONITORAGGIO VAL_PD_MONIT_ONLINE,
          I.VAL_RATING_MONITORAGGIO VAL_RATING_MONIT_ONLINE,
          I.VAL_IRIS_GRE VAL_IRIS,
          I.VAL_LIV_RISCHIO_GRE VAL_LR,
          I.VAL_LGD VAL_LGD,
          I.VAL_EAD VAL_EAD,
          I.VAL_PA VAL_PA,
          B.GEGB_ACC_CASSA + B.GEGB_ACC_FIRMA VAL_ACCORDATO,
          B.GEGB_UTI_CASSA + B.GEGB_UTI_FIRMA VAL_UTILIZZATO,
          NULL VAL_QI,
          I.DTA_RIFERIMENTO DTA_IRIS,
          A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          I.DTA_PD_MONITORAGGIO            --,cr.gegb_qis_acc, cr.gegb_qis_uti
     FROM T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          T_MCRE0_APP_GRUPPO_ECONOMICO GE,
          (SELECT DISTINCT P.COD_SNDG,
                           GEGB_ACC_CASSA,
                           GEGB_ACC_FIRMA,
                           GEGB_UTI_CASSA,
                           GEGB_UTI_FIRMA
             FROM T_MCRE0_APP_PCR P, T_MCRE0_APP_FILE_GUIDA G
            WHERE     P.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
                  AND P.COD_NDG = G.COD_NDG
                  AND G.FLG_GRUPPO_ECONOMICO = 1) B,
          T_MCRE0_APP_IRIS I /*,
           (SELECT   DISTINCT gegb_cod_sndg, gegb_qis_acc, gegb_qis_uti
                     FROM t_mcre0_app_cr) cr*/
    WHERE     GE.FLG_CAPOGRUPPO = 'S'
          AND GE.COD_SNDG = B.COD_SNDG
          AND GE.COD_SNDG = A.COD_SNDG
          AND GE.COD_SNDG = I.COD_SNDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_GE TO MCRE_USR;
