/* Formatted on 21/07/2014 18:46:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_GL
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
   DTA_PD_MONITORAGGIO
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          -- V2 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
          -- v3 28/03/2011 VG: presi dati PCR per GL
          -- v4 21/04/2011 VG: aggiunto cod_sndg per capolegam
          -- v5 04/05/2011 LF: aggiunti qis
          -- v6 10/05/2011 VG: sistemata lettura dati CR
          -- v7 15/05/2011 MM: su nuova pcr, senza CR
          -- V8 20/06/2011 VG: Solo GL join FG
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
                   B.VAL_GL_ACCORDATO VAL_ACCORDATO,
                   B.VAL_GL_UTILIZZATO VAL_UTILIZZATO,
                   NULL VAL_QI,
                   I.DTA_RIFERIMENTO DTA_IRIS,
                   A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
                   I.DTA_PD_MONITORAGGIO
     --CR.GLGB_QIS_ACC, CR.GLGB_QIS_UTI
     FROM T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          --T_MCRE0_APP_CR CR,
          T_MCRE0_APP_GRUPPO_LEGAME LE,
          (SELECT DISTINCT                              /*COD_GRUPPO_LEGAME,*/
                  P.COD_SNDG,
                  GLGB_ACC_CASSA + GLGB_ACC_FIRMA AS VAL_GL_ACCORDATO,
                  GLGB_UTI_CASSA + GLGB_UTI_FIRMA AS VAL_GL_UTILIZZATO
             FROM MCRE_OWN.T_MCRE0_APP_PCR P, T_MCRE0_APP_FILE_GUIDA G
            WHERE     P.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
                  AND P.COD_NDG = G.COD_NDG
                  AND G.FLG_GRUPPO_LEGAME = '1') B,
          T_MCRE0_APP_IRIS I
    WHERE     LE.COD_SNDG = A.COD_SNDG(+)
          AND LE.COD_SNDG = B.COD_SNDG(+) --AND LE.COD_GRUPPO_LEGAME = B.COD_GRUPPO_LEGAME(+)
          AND LE.COD_SNDG = I.COD_SNDG(+) --AND LE.COD_SNDG = CR.GLGB_COD_SNDG(+)
          AND LE.FLG_CAPOLEGAME = 1;
