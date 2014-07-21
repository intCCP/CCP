/* Formatted on 21/07/2014 18:45:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_SCHEDA_ANAG_SC
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
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.cod_sndg,
          --     a.val_pd_online,
          f.val_pd_online,
          --     a.val_rating_online,
          f.val_rating_online,
          i.val_pd_monitoraggio val_pd_monit_online,
          i.val_rating_monitoraggio val_rating_monit_online,
          i.val_iris_cli val_iris,
          i.val_liv_rischio_cli val_lr,
          i.val_lgd val_lgd,
          i.val_ead val_ead,
          i.val_pa val_pa,
          scsb_acc_cassa + scsb_acc_firma val_accordato,
          scsb_uti_cassa + scsb_uti_firma val_utilizzato,
          NULL val_qi,
          I.DTA_RIFERIMENTO DTA_IRIS,
          --        A.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          f.DTA_RIF_PD_ONLINE DTA_PD_ONLINE,
          i.dta_pd_monitoraggio           --, cr.scsb_qis_acc, cr.scsb_qis_uti
     FROM                                          --t_mcre0_app_file_guida f,
          --  t_mcre0_app_anagrafica_gruppo a,
          -- T_MCRE0_APP_PCR B,
          V_MCRE0_APP_UPD_FIELDS_PALL f, t_mcre0_app_iris i /*,
                                          t_mcre0_app_cr cr*/
    WHERE           --  f.cod_abi_cartolarizzato = b.cod_abi_cartolarizzato(+)
          --AND f.cod_ndg = b.cod_ndg(+)
          --AND F.COD_SNDG = A.COD_SNDG
          F.COD_SNDG = I.COD_SNDG(+);
