/* Formatted on 21/07/2014 18:46:42 (QP5 v5.227.12220.39754) */
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
          ge.cod_gruppo_economico,
          ge.cod_sndg,
          a.val_pd_online,
          a.val_rating_online,
          i.val_pd_monitoraggio val_pd_monit_online,
          i.val_rating_monitoraggio val_rating_monit_online,
          i.val_iris_gre val_iris,
          i.val_liv_rischio_gre val_lr,
          i.val_lgd val_lgd,
          i.val_ead val_ead,
          i.val_pa val_pa,
          b.gegb_acc_cassa + b.gegb_acc_firma val_accordato,
          b.gegb_uti_cassa + b.gegb_uti_firma val_utilizzato,
          NULL val_qi,
          I.DTA_RIFERIMENTO DTA_IRIS,
          A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          i.dta_pd_monitoraggio            --,cr.gegb_qis_acc, cr.gegb_qis_uti
     FROM t_mcre0_app_anagrafica_gruppo a,
          t_mcre0_app_gruppo_economico ge,
          (SELECT DISTINCT p.cod_sndg,
                           gegb_acc_cassa,
                           GEGB_ACC_FIRMA,
                           GEGB_UTI_CASSA,
                           GEGB_UTI_FIRMA
             FROM T_MCRE0_APP_PCR P, T_MCRE0_APP_FILE_GUIDA G
            WHERE     P.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
                  AND P.COD_NDG = G.COD_NDG
                  AND G.FLG_GRUPPO_ECONOMICO = 1) B,
          t_mcre0_app_iris i /*,
           (SELECT   DISTINCT gegb_cod_sndg, gegb_qis_acc, gegb_qis_uti
                     FROM t_mcre0_app_cr) cr*/
    WHERE     ge.flg_capogruppo = 'S'
          AND ge.cod_sndg = b.cod_sndg
          AND GE.COD_SNDG = A.COD_SNDG
          AND GE.COD_SNDG = I.COD_SNDG(+);
