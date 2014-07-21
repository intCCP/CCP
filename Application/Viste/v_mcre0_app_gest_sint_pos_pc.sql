/* Formatted on 21/07/2014 18:34:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_SINT_POS_PC
(
   COD_ABI_CARTOLARIZZATO,
   COD_COMPARTO,
   COD_NDG,
   ID_UTENTE,
   COD_MACROSTATO,
   DTA_PRESA_IN_CARICO,
   DTA_RIF_PD_MONIT_ONLINE,
   DTA_RIF_PD_ONLINE,
   DTA_RIF_RATING_MONIT_ONLINE,
   VAL_SCGB_ACC_TOT,
   VAL_SCGB_QIS_ACC,
   VAL_SCGB_QIS_UTI,
   VAL_SCGB_UTI_TOT,
   VAL_SCSB_ACC_TOT,
   VAL_SCSB_QIS_ACC,
   VAL_SCSB_QIS_UTI,
   VAL_SCSB_UTI_TOT,
   VAL_EAD,
   VAL_IRIS,
   VAL_LGD,
   VAL_PA,
   VAL_PD_MONIT_ONLINE,
   VAL_PD_ONLINE,
   VAL_RATING_MONIT_ONLINE,
   VAL_RATING_ONLINE,
   VAL_STRATEGIA_CREDITIZIA
)
AS
   SELECT x.cod_abi_cartolarizzato,
          NVL (x.cod_comparto_assegnato, x.cod_comparto_calcolato)
             cod_comparto,
          x.cod_ndg,
          x.id_utente,
          x.cod_stato AS cod_macrostato,
          x.dta_fine_validita_rc dta_presa_in_carico,
          x.dta_pd dta_rif_pd_monit_online,
          x.dta_pd_online dta_rif_pd_online,
          x.dta_pd dta_rif_rating_monit_online,
          x.scgb_acc_cassa + x.scgb_acc_firma val_scgb_acc_tot,
          x.scgb_qis_acc,
          x.scgb_qis_uti,
          x.scgb_uti_cassa + x.scgb_uti_firma scgb_uti_tot,
          x.scsb_acc_tot,
          x.scsb_qis_acc,
          x.scsb_qis_uti,
          x.scsb_uti_tot,
          x.val_ead,
          val_iris_cli val_iris,
          x.val_lgd,
          x.val_pa,
          x.val_pd val_pd_monit_online,
          x.val_pd_online,
          x.val_rating val_rating_monit_online,
          x.val_rating_online,
          x.cod_strategia_crz val_strategia_creditizia
     FROM (SELECT e.*,
                  MAX (e.dta_fine_validita)
                     OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
                     dta_fine_validita_rc
             FROM t_mcre0_app_storico_eventi e
            WHERE e.flg_cambio_gestore = 1) x
    WHERE dta_fine_validita_rc = dta_fine_validita;
