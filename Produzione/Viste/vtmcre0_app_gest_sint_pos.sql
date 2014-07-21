/* Formatted on 17/06/2014 18:16:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_GEST_SINT_POS
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_MACROSTATO,
   COD_COMPARTO,
   ID_UTENTE,
   DTA_PRESA_IN_CARICO,
   VAL_SCSB_ACC_TOT,
   VAL_SCSB_UTI_TOT,
   VAL_SCGB_ACC_TOT,
   VAL_SCGB_UTI_TOT,
   VAL_SCSB_QIS_ACC,
   VAL_SCSB_QIS_UTI,
   VAL_SCGB_QIS_ACC,
   VAL_SCGB_QIS_UTI,
   VAL_PD_ONLINE,
   DTA_RIF_PD_ONLINE,
   VAL_RATING_ONLINE,
   VAL_PD_MONIT_ONLINE,
   DTA_RIF_PD_MONIT_ONLINE,
   VAL_RATING_MONIT_ONLINE,
   DTA_RIF_RATING_MONIT_ONLINE,
   VAL_IRIS,
   VAL_LGD,
   VAL_EAD,
   VAL_PA,
   VAL_STRATEGIA_CREDITIZIA
)
AS
   SELECT x.cod_abi_cartolarizzato,
          x.cod_ndg,
          x.cod_macrostato,
          x.cod_comparto,
          x.id_utente,
          x.dta_utente_assegnato dta_presa_in_carico,
          DECODE (x.cod_macrostato, 'IN', ra.scsb_acc_tot, p.scsb_acc_tot)
             val_scsb_acc_tot,
          DECODE (x.cod_macrostato, 'IN', ra.scsb_uti_tot, p.scsb_uti_tot)
             val_scsb_uti_tot,
          p.scgb_acc_cassa + p.scgb_acc_firma val_scgb_acc_tot,
          p.scgb_uti_cassa + p.scgb_uti_firma val_scgb_uti_tot,
          cr.scsb_qis_acc val_scsb_qis_acc,
          cr.scsb_qis_uti val_scsb_qis_uti,
          cr.scgb_qis_acc val_scgb_qis_acc,
          cr.scgb_qis_uti val_scgb_qis_uti,
          x.val_pd_online,
          x.dta_rif_pd_online,
          x.val_rating_online,
          i.val_pd_monitoraggio val_pd_monit_online,
          i.dta_pd_monitoraggio dta_rif_pd_monit_online,
          i.val_rating_monitoraggio val_rating_monit_online,
          i.dta_pd_monitoraggio dta_rif_rating_monit_online,
          i.val_iris_cli val_iris,
          i.val_lgd,
          i.val_ead,
          i.val_pa,
          e.cod_strategia_crz val_strategia_creditizia
     FROM vtmcre0_app_upd_fields_p1 x,
          t_mcre0_app_pcr p,
          t_mcre0_app_cr cr,
          t_mcre0_app_iris i,
          t_mcre0_app_pef e,
          t_mcrei_app_pcr_rapp_aggr ra
    WHERE     1 = 1
          AND x.id_utente IS NOT NULL
          AND x.cod_abi_cartolarizzato = p.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = p.cod_ndg(+)
          AND x.cod_abi_cartolarizzato = cr.cod_abi_cartolarizzato(+)
          AND x.cod_ndg = cr.cod_ndg(+)
          AND x.cod_sndg = i.cod_sndg(+)
          AND x.cod_abi_istituto = e.cod_abi_istituto(+)
          AND x.cod_ndg = e.cod_ndg(+)
          AND x.cod_abi_cartolarizzato = ra.cod_abi_cartolarizzato
          AND x.cod_ndg = ra.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_GEST_SINT_POS TO MCRE_USR;
