/* Formatted on 17/06/2014 18:04:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_GE
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
   DTA_IRIS,
   DTA_PD_ONLINE,
   DTA_PD_MONITORAGGIO,
   VAL_QI,
   VAL_QIS_ACC,
   VAL_QIS_UTI,
   FLG_FATAL
)
AS
   SELECT /*+ INDEX(CR IDX_T_MCRE0_APP_CR_SNDG) */
         DISTINCT                               -- V1 02/12/2010 VG: Congelata
                                   -- v2 08/03/2011 MM: passata su tabella PCR
    -- v3 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
                                        -- v4 28/03/2011 VG: dati presi per ge
                         -- v5 21/04/2011 VG: aggiunto cod_sndg per capogruppo
                                     -- V6 02/05/2011 LF: aggiunti i campi QIS
                            -- V7 02/05/2011 VG: PCR NUOVA 3 con CR commentata
                                          -- V8 20/06/2011 VG: Solo GE join FG
                                           -- V9 11/07/2011 MM: Scommentata CR
                                -- V10 14/10/2013 TB: AGGIUNTO CAMPO FLG_FATAL
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
           I.DTA_RIFERIMENTO DTA_IRIS,
           A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
           I.DTA_PD_MONITORAGGIO,
           NULL VAL_QI,
           CR.GEGB_QIS_ACC VAL_QIS_ACC,
           CR.GEGB_QIS_UTI VAL_QIS_UTI,
           I.FLG_FATAL
     FROM T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          T_MCRE0_APP_GRUPPO_ECONOMICO GE,
          V_MCRE0_APP_UPD_FIELDS_PALL B,
          T_MCRE0_APP_IRIS I,
          T_MCRE0_APP_CR CR
    WHERE     GE.FLG_CAPOGRUPPO = 'S'
          AND GE.COD_SNDG = B.COD_SNDG
          AND B.FLG_GRUPPO_ECONOMICO = '1'
          AND GE.COD_SNDG = A.COD_SNDG
          AND GE.COD_SNDG = I.COD_SNDG(+)
          AND GE.COD_SNDG = CR.COD_SNDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_GE TO MCRE_USR;
