/* Formatted on 21/07/2014 18:36:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_SC
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
   DTA_PD_MONITORAGGIO,
   VAL_QIS_ACC,
   VAL_QIS_UTI,
   FLG_FATAL
)
AS
   SELECT                                     -- V1   02/12/2010 VG: Congelata
          -- v1.1 23/12/2010 MM: rimossa condizione Solo Posizioni Singole
          -- v1.2 09/03/2011 MM: passata su tabella PCR
          -- v1.3 16/03/2011 LF: aggiunti dta_ris, dta_pd_online e dta_pd_monitoraggio
          -- v1.4 02/05/2011 LF: aggiunti QIS
          -- v1.5 17/06/2011 VG: New PCR
          -- v1.6 CR
          -- v2.0 18/02/13 MM: PA da Perdita Attesa
          F.COD_ABI_CARTOLARIZZATO,
          F.COD_NDG,
          F.COD_SNDG,
          --     a.val_pd_online,
          F.VAL_PD_ONLINE,
          --     a.val_rating_online,
          F.VAL_RATING_ONLINE,
          I.VAL_PD_MONITORAGGIO VAL_PD_MONIT_ONLINE,
          I.VAL_RATING_MONITORAGGIO VAL_RATING_MONIT_ONLINE,
          I.VAL_IRIS_CLI VAL_IRIS,
          I.VAL_LIV_RISCHIO_CLI VAL_LR,
          I.VAL_LGD VAL_LGD,
          I.VAL_EAD VAL_EAD,
          PA.PERDITA_ATTESA VAL_PA,
          SCSB_ACC_CASSA + SCSB_ACC_FIRMA VAL_ACCORDATO,
          SCSB_UTI_CASSA + SCSB_UTI_FIRMA VAL_UTILIZZATO,
          NULL VAL_QI,
          I.DTA_RIFERIMENTO DTA_IRIS,
          --         A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          F.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          I.DTA_PD_MONITORAGGIO,
          --v1.6
          SCSB_QIS_ACC VAL_QIS_ACC,
          SCSB_QIS_UTI VAL_QIS_UTI,
          I.FLG_FATAL
     FROM                                          --t_mcre0_app_file_guida f,
          --  t_mcre0_app_anagrafica_gruppo a,
          -- T_MCRE0_APP_PCR B,
          V_MCRE0_APP_UPD_FIELDS_PALL F,
          T_MCRE0_APP_IRIS I,
          T_MCRE0_APP_CR CR,
          T_MCRE0_APP_PERDITA_ATTESA PA
    WHERE          --   f.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato(+)
              --AND f.cod_ndg = b.cod_ndg(+)
              --AND F.COD_SNDG = A.COD_SNDG
              F.COD_SNDG = I.COD_SNDG(+)
          AND F.COD_ABI_CARTOLARIZZATO = CR.COD_ABI_CARTOLARIZZATO(+)
          AND F.COD_NDG = CR.COD_NDG(+)
          AND F.COD_ABI_CARTOLARIZZATO = PA.COD_ABI(+)
          AND F.COD_NDG = PA.COD_NDG(+);
