/* Formatted on 17/06/2014 18:05:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_PCR_GB2
(
   COD_SNDG,
   ID_DPER,
   FLG_LAST_RUN,
   GEGB_TOT_GAR,
   SCGB_TOT_GAR,
   GLGB_TOT_GAR,
   GEGB_UTI_CONSEGNE,
   GEGB_UTI_CONSEGNE_DT,
   GEGB_ACC_CONSEGNE,
   GEGB_ACC_CONSEGNE_DT,
   SCGB_UTI_CONSEGNE,
   SCGB_UTI_CONSEGNE_DT,
   SCGB_ACC_CONSEGNE,
   SCGB_ACC_CONSEGNE_DT,
   GLGB_UTI_CONSEGNE,
   GLGB_UTI_CONSEGNE_DT,
   GLGB_ACC_CONSEGNE,
   GLGB_ACC_CONSEGNE_DT,
   GEGB_UTI_SOSTITUZIONI,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_UTI_SOSTITUZIONI_DT,
   GEGB_UTI_MASSIMALI_DT,
   GEGB_UTI_RISCHI_INDIRETTI_DT,
   GEGB_ACC_SOSTITUZIONI_DT,
   GEGB_ACC_MASSIMALI_DT,
   GEGB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_SOSTITUZIONI,
   SCGB_UTI_MASSIMALI,
   SCGB_UTI_RISCHI_INDIRETTI,
   SCGB_ACC_SOSTITUZIONI,
   SCGB_ACC_MASSIMALI,
   SCGB_ACC_RISCHI_INDIRETTI,
   SCGB_UTI_SOSTITUZIONI_DT,
   SCGB_UTI_MASSIMALI_DT,
   SCGB_UTI_RISCHI_INDIRETTI_DT,
   SCGB_ACC_SOSTITUZIONI_DT,
   SCGB_ACC_MASSIMALI_DT,
   SCGB_ACC_RISCHI_INDIRETTI_DT,
   GLGB_UTI_SOSTITUZIONI,
   GLGB_UTI_MASSIMALI,
   GLGB_UTI_RISCHI_INDIRETTI,
   GLGB_ACC_SOSTITUZIONI,
   GLGB_ACC_MASSIMALI,
   GLGB_ACC_RISCHI_INDIRETTI,
   GLGB_UTI_SOSTITUZIONI_DT,
   GLGB_UTI_MASSIMALI_DT,
   GLGB_UTI_RISCHI_INDIRETTI_DT,
   GLGB_ACC_SOSTITUZIONI_DT,
   GLGB_ACC_MASSIMALI_DT,
   GLGB_ACC_RISCHI_INDIRETTI_DT,
   SCGB_UTI_CASSA,
   SCGB_UTI_FIRMA,
   SCGB_ACC_CASSA,
   SCGB_ACC_FIRMA,
   SCGB_UTI_CASSA_BT,
   SCGB_UTI_CASSA_MLT,
   SCGB_UTI_SMOBILIZZO,
   SCGB_UTI_FIRMA_DT,
   SCGB_ACC_CASSA_BT,
   SCGB_ACC_CASSA_MLT,
   SCGB_ACC_SMOBILIZZO,
   SCGB_ACC_FIRMA_DT,
   GEGB_UTI_CASSA,
   GEGB_UTI_FIRMA,
   GEGB_ACC_CASSA,
   GEGB_ACC_FIRMA,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_SMOBILIZZO,
   GEGB_UTI_FIRMA_DT,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_ACC_FIRMA_DT,
   GLGB_UTI_CASSA,
   GLGB_UTI_FIRMA,
   GLGB_ACC_CASSA,
   GLGB_ACC_FIRMA,
   GLGB_UTI_CASSA_BT,
   GLGB_UTI_CASSA_MLT,
   GLGB_UTI_SMOBILIZZO,
   GLGB_UTI_FIRMA_DT,
   GLGB_ACC_CASSA_BT,
   GLGB_ACC_CASSA_MLT,
   GLGB_ACC_SMOBILIZZO,
   GLGB_ACC_FIRMA_DT,
   DTA_RIFERIMENTO,
   DTA_INS,
   DTA_UPD
)
AS
   SELECT cod_sndg,
          id_dper,
          0 flg_last_run,
          NULL gegb_tot_gar,
          NULL scgb_tot_gar,
          NULL glgb_tot_gar,
          NULL gegb_uti_consegne,
          NULL gegb_uti_consegne_dt,
          NULL gegb_acc_consegne,
          NULL gegb_acc_consegne_dt,
          NULL scgb_uti_consegne,
          NULL scgb_uti_consegne_dt,
          NULL scgb_acc_consegne,
          NULL scgb_acc_consegne_dt,
          NULL glgb_uti_consegne,
          NULL glgb_uti_consegne_dt,
          NULL glgb_acc_consegne,
          NULL glgb_acc_consegne_dt,
          NULL gegb_uti_sostituzioni,
          NULL gegb_uti_massimali,
          NULL gegb_uti_rischi_indiretti,
          NULL gegb_acc_sostituzioni,
          NULL gegb_acc_massimali,
          NULL gegb_acc_rischi_indiretti,
          NULL gegb_uti_sostituzioni_dt,
          NULL gegb_uti_massimali_dt,
          NULL gegb_uti_rischi_indiretti_dt,
          NULL gegb_acc_sostituzioni_dt,
          NULL gegb_acc_massimali_dt,
          NULL gegb_acc_rischi_indiretti_dt,
          NULL scgb_uti_sostituzioni,
          NULL scgb_uti_massimali,
          NULL scgb_uti_rischi_indiretti,
          NULL scgb_acc_sostituzioni,
          NULL scgb_acc_massimali,
          NULL scgb_acc_rischi_indiretti,
          NULL scgb_uti_sostituzioni_dt,
          NULL scgb_uti_massimali_dt,
          NULL scgb_uti_rischi_indiretti_dt,
          NULL scgb_acc_sostituzioni_dt,
          NULL scgb_acc_massimali_dt,
          NULL scgb_acc_rischi_indiretti_dt,
          NULL glgb_uti_sostituzioni,
          NULL glgb_uti_massimali,
          NULL glgb_uti_rischi_indiretti,
          NULL glgb_acc_sostituzioni,
          NULL glgb_acc_massimali,
          NULL glgb_acc_rischi_indiretti,
          NULL glgb_uti_sostituzioni_dt,
          NULL glgb_uti_massimali_dt,
          NULL glgb_uti_rischi_indiretti_dt,
          NULL glgb_acc_sostituzioni_dt,
          NULL glgb_acc_massimali_dt,
          NULL glgb_acc_rischi_indiretti_dt,
          NULL scgb_uti_cassa,
          NULL scgb_uti_firma,
          NULL scgb_acc_cassa,
          NULL scgb_acc_firma,
          NULL scgb_uti_cassa_bt,
          NULL scgb_uti_cassa_mlt,
          NULL scgb_uti_smobilizzo,
          NULL scgb_uti_firma_dt,
          NULL scgb_acc_cassa_bt,
          NULL scgb_acc_cassa_mlt,
          NULL scgb_acc_smobilizzo,
          NULL scgb_acc_firma_dt,
          NULL gegb_uti_cassa,
          NULL gegb_uti_firma,
          NULL gegb_acc_cassa,
          NULL gegb_acc_firma,
          NULL gegb_uti_cassa_bt,
          NULL gegb_uti_cassa_mlt,
          NULL gegb_uti_smobilizzo,
          NULL gegb_uti_firma_dt,
          NULL gegb_acc_cassa_bt,
          NULL gegb_acc_cassa_mlt,
          NULL gegb_acc_smobilizzo,
          NULL gegb_acc_firma_dt,
          NULL glgb_uti_cassa,
          NULL glgb_uti_firma,
          NULL glgb_acc_cassa,
          NULL glgb_acc_firma,
          NULL glgb_uti_cassa_bt,
          NULL glgb_uti_cassa_mlt,
          NULL glgb_uti_smobilizzo,
          NULL glgb_uti_firma_dt,
          NULL glgb_acc_cassa_bt,
          NULL glgb_acc_cassa_mlt,
          NULL glgb_acc_smobilizzo,
          NULL glgb_acc_firma_dt,
          NULL dta_riferimento,
          SYSDATE dta_ins,
          SYSDATE dta_upd
     FROM (SELECT cod_sndg,
                  (SELECT MAX (id_dper)
                     FROM t_mcre0_dwh_pgb
                    WHERE id_dper < (SELECT DISTINCT id_dper
                                       FROM t_mcre0_day_pgb w))
                     id_dper
             FROM t_mcre0_dwh_pgb pcr
            WHERE id_dper = (SELECT MAX (id_dper)
                               FROM t_mcre0_dwh_pgb
                              WHERE id_dper < (SELECT DISTINCT id_dper
                                                 FROM t_mcre0_day_pgb w))
           MINUS
           SELECT cod_sndg,
                  (SELECT MAX (id_dper)
                     FROM t_mcre0_dwh_pgb
                    WHERE id_dper < (SELECT DISTINCT id_dper
                                       FROM t_mcre0_day_pgb w))
                     id_dper
             FROM ttmcre0_pcr_gb1);


GRANT SELECT ON MCRE_OWN.V_MCRE0_PCR_GB2 TO MCRE_USR;
