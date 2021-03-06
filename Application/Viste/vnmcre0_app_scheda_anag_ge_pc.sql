/* Formatted on 21/07/2014 18:45:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_SCHEDA_ANAG_GE_PC
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
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
   DTA_PRESA_IN_CARICO,
   DTA_IRIS,
   DTA_PD_ONLINE,
   DTA_PD_MONITORAGGIO,
   GEGB_QIS_ACC,
   GEGB_QIS_UTI
)
AS
   SELECT                                             -- V1 22/12/2010 VG: New
          -- V2 07/03/2011 MM: aggiunti campi iris
          -- V3 16/03/2011 LF: aggiunti dta_iris, dta_pd_online e dta_pd da storico_eventi
          -- V4 28/03/2011 MM: aggiunte le docode mancanti
          e.cod_abi_cartolarizzato,
          e.cod_ndg,
          e.cod_gruppo_economico,
          e.cod_sndg,
          DECODE (e.cod_gruppo_economico,
                  NULL, TO_NUMBER (NULL),
                  e.val_pd_online)
             val_pd_online,
          DECODE (e.cod_gruppo_economico, NULL, NULL, e.val_rating_online)
             val_rating_online,
          DECODE (e.cod_gruppo_economico, NULL, TO_NUMBER (NULL), e.val_pd)
             val_pd_monit_online,
          DECODE (e.cod_gruppo_economico, NULL, NULL, e.val_rating)
             val_rating_monit_online,
          DECODE (e.cod_gruppo_economico, NULL, NULL, e.val_iris_ge) val_iris,
          DECODE (e.cod_gruppo_economico, NULL, NULL, e.liv_rischio_ge)
             val_lr,
          DECODE (e.cod_gruppo_economico, NULL, TO_NUMBER (NULL), e.val_lgd)
             val_lgd,
          DECODE (e.cod_gruppo_economico, NULL, TO_NUMBER (NULL), e.val_ead)
             val_ead,
          DECODE (e.cod_gruppo_economico, NULL, TO_NUMBER (NULL), e.val_pa)
             val_pa,
          DECODE (e.cod_gruppo_economico,
                  NULL, TO_NUMBER (NULL),
                  e.gegb_acc_cassa + e.gegb_acc_firma)
             val_accordato,
          DECODE (e.cod_gruppo_economico,
                  NULL, TO_NUMBER (NULL),
                  e.gegb_uti_cassa + e.gegb_uti_firma)
             val_utilizzato,
          NULL val_qi,
          DECODE (e.cod_gruppo_economico,
                  NULL, TO_DATE (NULL),
                  dta_fine_validita_rc)
             dta_presa_in_carico,
          DECODE (e.cod_gruppo_economico, NULL, TO_DATE (NULL), e.dta_iris)
             dta_iris,
          DECODE (e.cod_gruppo_economico,
                  NULL, TO_DATE (NULL),
                  e.dta_pd_online)
             dta_pd_online,
          DECODE (e.cod_gruppo_economico, NULL, TO_DATE (NULL), e.dta_pd)
             dta_pd_monitoraggio,
          e.GEGB_QIS_ACC,
          e.GEGB_QIS_UTI
     FROM (SELECT e.cod_abi_cartolarizzato,
                  e.cod_ndg,
                  e.DTA_FINE_VAL_TR,
                  MAX (e.DTA_FINE_VAL_TR)
                     OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
                     DTA_FINE_VAL_TR_rc,
                  e.dta_fine_validita,
                  MAX (e.dta_fine_validita)
                     OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
                     dta_fine_validita_rc,
                  e.cod_sndg,
                  e.cod_stato,
                  e.val_pd_online,
                  e.val_rating_online,
                  e.val_pd,
                  e.val_rating,
                  e.val_iris_cli,
                  e.liv_rischio_cli,
                  e.val_lgd,
                  e.val_ead,
                  e.val_pa,
                  e.scsb_acc_cassa,
                  e.scsb_acc_firma,
                  e.scsb_uti_cassa,
                  e.scsb_uti_firma,
                  e.dta_iris,
                  e.dta_pd_online,
                  e.dta_pd,
                  e.scsb_qis_acc,
                  e.scsb_qis_uti,
                  e.scgb_qis_uti,
                  e.GEGB_QIS_ACC,
                  e.GEGB_QIS_UTI,
                  e.cod_gruppo_economico,
                  e.gegb_acc_cassa,
                  e.gegb_acc_firma,
                  e.gegb_uti_cassa,
                  e.gegb_uti_firma,
                  e.liv_rischio_ge,
                  e.val_iris_ge
             FROM t_mcre0_app_storico_eventi e
            WHERE e.flg_cambio_gestore = '1') e
    WHERE dta_fine_validita_rc = dta_fine_validita;
