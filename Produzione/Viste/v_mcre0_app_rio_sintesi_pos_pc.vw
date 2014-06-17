/* Formatted on 17/06/2014 18:04:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RIO_SINTESI_POS_PC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_COMPARTO,
   ID_UTENTE,
   DTA_PRESA_IN_CARICO,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   SCGB_ACC_TOT,
   SCGB_UTI_TOT,
   SCSB_QIS_ACC,
   SCSB_QIS_UTI,
   SCGB_QIS_ACC,
   SCGB_QIS_UTI,
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
   SELECT                              -- v1.1 aggiunti valori iris da storico
          -- v2 15/09/2011 VG: Agganciata CR per QIS
          x.cod_abi_cartolarizzato,
          x.cod_ndg,
          NVL (x.cod_comparto_assegnato, x.cod_comparto_calcolato)
             cod_comparto,
          x.id_utente,
          x.dta_fine_validita_rc dta_presa_in_carico,
          x.scsb_acc_tot,
          x.scsb_uti_tot,
          x.scgb_acc_cassa + x.scgb_acc_firma scgb_acc_tot,
          x.scgb_uti_cassa + x.scgb_uti_firma scgb_uti_tot,
          x.SCSB_QIS_ACC,
          x.SCSB_QIS_UTI,
          x.SCGB_QIS_ACC,
          x.SCGB_QIS_uti,
          x.val_pd_online,
          x.dta_pd_online dta_rif_pd_online,
          x.val_rating_online,
          x.val_pd val_pd_monit_online,
          x.dta_pd dta_rif_pd_monit_online,
          x.val_rating val_rating_monit_online,
          x.dta_pd dta_rif_rating_monit_online,
          val_iris_cli val_iris,
          x.val_lgd,
          x.val_ead,
          x.val_pa,
          x.cod_strategia_crz val_strategia_creditizia
     FROM (SELECT e.*,
                  MAX (e.dta_fine_validita)
                     OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
                     dta_fine_validita_rc
             FROM t_mcre0_app_storico_eventi e
            WHERE e.flg_cambio_gestore = 1) x
    WHERE dta_fine_validita_rc = dta_fine_validita;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RIO_SINTESI_POS_PC TO MCRE_USR;
