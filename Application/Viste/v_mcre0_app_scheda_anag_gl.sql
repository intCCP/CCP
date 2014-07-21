/* Formatted on 21/07/2014 18:36:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_GL
(
   COD_GRUPPO_LEGAME,
   COD_LEGAME,
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
   DTA_PD_MONITORAGGIO,
   GLGB_QIS_ACC,
   GLGB_QIS_UTI,
   FLG_FATAL
)
AS
   SELECT /*+full(le) noparallel(i)*/
                                                -- V1 02/12/2010 VG: Congelata
    -- V2 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
                                    -- v3 28/03/2011 VG: presi dati PCR per GL
                          -- v4 21/04/2011 VG: aggiunto cod_sndg per capolegam
                                             -- v5 04/05/2011 LF: aggiunti qis
                                -- v6 10/05/2011 VG: sistemata lettura dati CR
                                   -- v7 15/05/2011 MM: su nuova pcr, senza CR
                                          -- V8 20/06/2011 VG: Solo GL join FG
                                -- v9 080911 MM: allineata a scheda_GE, con CR
         DISTINCT LE.COD_GRUPPO_LEGAME,
                  LE.COD_LEGAME,
                  LE.COD_SNDG,
                  A.VAL_PD_ONLINE,
                  A.VAL_RATING_ONLINE,
                  I.VAL_PD_MONITORAGGIO VAL_PD_MONIT_ONLINE,
                  I.VAL_RATING_MONITORAGGIO VAL_RATING_MONIT_ONLINE,
                  NULL VAL_IRIS,
                  NULL VAL_LR,
                  I.VAL_LGD VAL_LGD,
                  I.VAL_EAD VAL_EAD,
                  I.VAL_PA VAL_PA,
                  GLGB_ACC_CASSA + GLGB_ACC_FIRMA VAL_ACCORDATO,
                  GLGB_UTI_CASSA + GLGB_UTI_FIRMA VAL_UTILIZZATO,
                  NULL VAL_QI,
                  I.DTA_RIFERIMENTO DTA_IRIS,
                  A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
                  I.DTA_PD_MONITORAGGIO,
                  CR.GLGB_QIS_ACC,
                  CR.GLGB_QIS_UTI,
                  I.FLG_FATAL
    FROM T_MCRE0_APP_GRUPPO_LEGAME LE,
         T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
         T_MCRE0_APP_CR CR,
         V_MCRE0_APP_UPD_FIELDS_PALL B,
         T_MCRE0_APP_IRIS I
   --             WHERE LE.COD_SNDG = A.COD_SNDG(+)
   --               AND LE.COD_SNDG = B.COD_SNDG(+)
   --               --AND LE.COD_GRUPPO_LEGAME = B.COD_GRUPPO_LEGAME(+)
   --               AND LE.COD_SNDG = I.COD_SNDG(+)
   --               --AND LE.COD_SNDG = CR.GLGB_COD_SNDG(+)
   --               AND LE.FLG_CAPOLEGAME = 1
   --               AND B.FLG_GRUPPO_LEGAME = '1';
   WHERE     LE.FLG_CAPOLEGAME = 1
         AND LE.COD_SNDG = B.COD_SNDG                                    --(+)
         AND B.FLG_GRUPPO_LEGAME = '1'
         AND LE.COD_SNDG = A.COD_SNDG                                    --(+)
         AND LE.COD_SNDG = I.COD_SNDG(+)
         AND LE.COD_SNDG = CR.COD_SNDG(+);
