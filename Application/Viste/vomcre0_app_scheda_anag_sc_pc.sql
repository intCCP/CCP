/* Formatted on 21/07/2014 18:46:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_ANAG_SC_PC
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
          e.cod_abi_cartolarizzato,
          e.cod_ndg,
          e.cod_sndg,
          e.cod_stato,
          e.val_pd_online,
          e.val_rating_online,
          e.val_pd val_pd_monit_online,
          e.val_rating val_rating_monit_online,
          e.val_iris_cli val_iris,
          e.liv_rischio_cli val_lr,
          e.val_lgd val_lgd,
          e.val_ead val_ead,
          e.val_pa val_pa,
          e.scsb_acc_cassa + e.scsb_acc_firma val_accordato,
          e.scsb_uti_cassa + e.scsb_uti_firma val_utilizzato,
          NULL val_qi,
          dta_fine_validita_rc dta_presa_in_carico,
          e.dta_iris,
          e.dta_pd_online,
          e.dta_pd dta_pd_monitoraggio,
          -- sarebbe la dta_pd_monitoraggio
          e.scsb_qis_acc,
          e.scsb_qis_uti,
          e.scgb_qis_uti
     FROM (SELECT e.*,
                  MAX (e.dta_fine_validita)
                     OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
                     dta_fine_validita_rc
             FROM t_mcre0_app_storico_eventi e
            WHERE e.flg_cambio_gestore = 1) e
    WHERE dta_fine_validita_rc = dta_fine_validita;
