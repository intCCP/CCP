/* Formatted on 21/07/2014 18:37:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_PCR_SCSB
(
   ID_DPER_SCSB,
   FLG_LAST_RUN,
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   SCSB_ACC_CONSEGNE,
   SCSB_ACC_CONSEGNE_DT,
   SCSB_UTI_CONSEGNE,
   SCSB_UTI_CONSEGNE_DT,
   SCSB_UTI_MASSIMALI,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_RISCHI_INDIRETTI,
   SCSB_UTI_MASSIMALI_DT,
   SCSB_UTI_SOSTITUZIONI_DT,
   SCSB_UTI_RISCHI_INDIRETTI_DT,
   SCSB_ACC_MASSIMALI,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_RISCHI_INDIRETTI,
   SCSB_ACC_MASSIMALI_DT,
   SCSB_ACC_SOSTITUZIONI_DT,
   SCSB_ACC_RISCHI_INDIRETTI_DT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_TOT,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA_BT,
   SCSB_UTI_CASSA_MLT,
   SCSB_UTI_SMOBILIZZO,
   SCSB_UTI_FIRMA_DT,
   SCSB_ACC_CASSA_BT,
   SCSB_ACC_CASSA_MLT,
   SCSB_ACC_SMOBILIZZO,
   SCSB_ACC_FIRMA_DT,
   SCSB_TOT_GAR,
   SCSB_DTA_RIFERIMENTO,
   DTA_INS,
   DTA_UPD,
   MY_RNK
)
AS
   SELECT ID_DPER_SCSB,
          FLG_LAST_RUN,
          ID_DPER,
          COD_ABI_ISTITUTO,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_SNDG,
          SCSB_ACC_CONSEGNE,
          SCSB_ACC_CONSEGNE_DT,
          SCSB_UTI_CONSEGNE,
          SCSB_UTI_CONSEGNE_DT,
          SCSB_UTI_MASSIMALI,
          SCSB_UTI_SOSTITUZIONI,
          SCSB_UTI_RISCHI_INDIRETTI,
          SCSB_UTI_MASSIMALI_DT,
          SCSB_UTI_SOSTITUZIONI_DT,
          SCSB_UTI_RISCHI_INDIRETTI_DT,
          SCSB_ACC_MASSIMALI,
          SCSB_ACC_SOSTITUZIONI,
          SCSB_ACC_RISCHI_INDIRETTI,
          SCSB_ACC_MASSIMALI_DT,
          SCSB_ACC_SOSTITUZIONI_DT,
          SCSB_ACC_RISCHI_INDIRETTI_DT,
          SCSB_UTI_CASSA,
          SCSB_UTI_FIRMA,
          SCSB_UTI_TOT,
          SCSB_ACC_CASSA,
          SCSB_ACC_FIRMA,
          SCSB_ACC_TOT,
          SCSB_UTI_CASSA_BT,
          SCSB_UTI_CASSA_MLT,
          SCSB_UTI_SMOBILIZZO,
          SCSB_UTI_FIRMA_DT,
          SCSB_ACC_CASSA_BT,
          SCSB_ACC_CASSA_MLT,
          SCSB_ACC_SMOBILIZZO,
          SCSB_ACC_FIRMA_DT,
          SCSB_TOT_GAR,
          SCSB_DTA_RIFERIMENTO,
          DTA_INS,
          DTA_UPD,
          my_rnk
     FROM (SELECT RANK ()
                  OVER (PARTITION BY                       --COD_ABI_ISTITUTO,
                                    COD_NDG, COD_ABI_CARTOLARIZZATO
                        ORDER BY ID_DPER_SCSB DESC)
                     my_rnk,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_SNDG,
                  ID_DPER_SCSB,
                  FLG_LAST_RUN,
                  ID_DPER,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_CONSEGNE
                  END
                     SCSB_ACC_CONSEGNE,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_CONSEGNE_DT
                  END
                     SCSB_ACC_CONSEGNE_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_CONSEGNE
                  END
                     SCSB_UTI_CONSEGNE,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_CONSEGNE_DT
                  END
                     SCSB_UTI_CONSEGNE_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_MASSIMALI
                  END
                     SCSB_UTI_MASSIMALI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_SOSTITUZIONI
                  END
                     SCSB_UTI_SOSTITUZIONI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_RISCHI_INDIRETTI
                  END
                     SCSB_UTI_RISCHI_INDIRETTI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_MASSIMALI_DT
                  END
                     SCSB_UTI_MASSIMALI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_SOSTITUZIONI_DT
                  END
                     SCSB_UTI_SOSTITUZIONI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_RISCHI_INDIRETTI_DT
                  END
                     SCSB_UTI_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_MASSIMALI
                  END
                     SCSB_ACC_MASSIMALI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_SOSTITUZIONI
                  END
                     SCSB_ACC_SOSTITUZIONI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_RISCHI_INDIRETTI
                  END
                     SCSB_ACC_RISCHI_INDIRETTI,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_MASSIMALI_DT
                  END
                     SCSB_ACC_MASSIMALI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_SOSTITUZIONI_DT
                  END
                     SCSB_ACC_SOSTITUZIONI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_RISCHI_INDIRETTI_DT
                  END
                     SCSB_ACC_RISCHI_INDIRETTI_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_CASSA
                  END
                     SCSB_UTI_CASSA,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_FIRMA
                  END
                     SCSB_UTI_FIRMA,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_TOT
                  END
                     SCSB_UTI_TOT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_CASSA
                  END
                     SCSB_ACC_CASSA,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_FIRMA
                  END
                     SCSB_ACC_FIRMA,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_TOT
                  END
                     SCSB_ACC_TOT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_CASSA_BT
                  END
                     SCSB_UTI_CASSA_BT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_CASSA_MLT
                  END
                     SCSB_UTI_CASSA_MLT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_SMOBILIZZO
                  END
                     SCSB_UTI_SMOBILIZZO,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_UTI_FIRMA_DT
                  END
                     SCSB_UTI_FIRMA_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_CASSA_BT
                  END
                     SCSB_ACC_CASSA_BT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_CASSA_MLT
                  END
                     SCSB_ACC_CASSA_MLT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_SMOBILIZZO
                  END
                     SCSB_ACC_SMOBILIZZO,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_ACC_FIRMA_DT
                  END
                     SCSB_ACC_FIRMA_DT,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_TOT_GAR
                  END
                     SCSB_TOT_GAR,
                  CASE
                     WHEN ID_DPER_SCSB < ID_DPER THEN NULL
                     ELSE SCSB_DTA_RIFERIMENTO
                  END
                     SCSB_DTA_RIFERIMENTO,
                  DTA_INS,
                  DTA_UPD
             FROM (SELECT pcr.id_dper id_dper_scsb,
                          pcr.FLG_LAST_RUN,
                          xx.id_dper,
                          XX.COD_ABI_ISTITUTO,
                          XX.COD_ABI_CARTOLARIZZATO,
                          XX.COD_NDG,
                          val_tot_ACC_CONSEGNE SCSB_ACC_CONSEGNE,
                          val_tot_ACC_CONSEGNE_DT SCSB_ACC_CONSEGNE_DT,
                          val_tot_UTI_CONSEGNE SCSB_UTI_CONSEGNE,
                          val_tot_UTI_CONSEGNE_DT SCSB_UTI_CONSEGNE_DT,
                          val_tot_uti_MASSIMALI scsb_uti_massimali,
                          val_tot_uti_sostituzioni scsb_uti_sostituzioni,
                          val_tot_uti_rischi_indiretti
                             scsb_uti_rischi_indiretti,
                          val_tot_dett_uti_MASSIMALI scsb_uti_massimali_dt,
                          val_tot_dett_uti_sostituzioni
                             scsb_uti_sostituzioni_dt,
                          val_tot_dett_uti_rischi_ind
                             scsb_uti_rischi_indiretti_dt,
                          val_tot_acc_MASSIMALI scsb_acc_massimali,
                          val_tot_acc_sostituzioni scsb_acc_sostituzioni,
                          val_tot_acc_rischi_indiretti
                             scsb_acc_rischi_indiretti,
                          val_tot_dett_acc_MASSIMALI scsb_acc_massimali_dt,
                          val_tot_dett_acc_sostituzioni
                             scsb_acc_sostituzioni_dt,
                          val_tot_dett_acc_rischi_ind
                             scsb_acc_rischi_indiretti_dt,
                          val_tot_uti_cassa scsb_uti_cassa,
                          val_tot_uti_firma scsb_uti_firma,
                          (val_tot_uti_cassa + val_tot_uti_firma)
                             scsb_uti_tot,
                          val_tot_acc_cassa scsb_acc_cassa,
                          val_tot_acc_firma scsb_acc_firma,
                          (val_tot_acc_cassa + val_tot_acc_firma)
                             scsb_acc_tot,
                          val_tot_dett_uti_cassa_bt scsb_uti_cassa_bt,
                          val_tot_dett_uti_cassa_mlt scsb_uti_cassa_mlt,
                          val_tot_dett_uti_smobilizzo scsb_uti_smobilizzo,
                          val_tot_dett_uti_firma scsb_uti_firma_dt,
                          val_tot_dett_acc_cassa_bt scsb_acc_cassa_bt,
                          val_tot_dett_acc_cassa_mlt scsb_acc_cassa_mlt,
                          val_tot_dett_acc_smobilizzo scsb_acc_smobilizzo,
                          val_tot_dett_acc_firma scsb_acc_firma_dt,
                          val_tot_gar scsb_tot_gar,
                          dta_riferimento scsb_dta_riferimento,
                          xx.cod_sndg,
                          SYSDATE dta_ins,
                          SYSDATE dta_upd
                     FROM (  SELECT cod_abi_istituto,
                                    cod_ndg,
                                    pcr.id_dper,
                                    r.FLG_LAST_RUN,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CO'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_CONSEGNE,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CO'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_CONSEGNE_DT,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CO'
                                          THEN
                                             pcr.val_imp_ACC_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_ACC_CONSEGNE,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CO'
                                          THEN
                                             pcr.val_imp_ACC_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_ACC_CONSEGNE_DT,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'ST'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_sostituzioni,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'MS'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_massimali,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'RI'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_rischi_indiretti,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'ST'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_acc_sostituzioni,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'MS'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_acc_massimali,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'RI'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_acc_rischi_indiretti,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'ST'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_sostituzioni,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'MS'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_massimali,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'RI'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_rischi_ind,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'ST'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_sostituzioni,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'MS'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_massimali,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'RI'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_rischi_ind,
                                    ---------------------- OLD
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CA'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_cassa,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'FI'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_uti_firma,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'CA'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_acc_cassa,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_cf = 'FI'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_acc_firma,
                                    MAX (val_imp_gar_tot) val_tot_gar,
                                    --stesso valore su tutte le Forme Tecniche
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'CB'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_cassa_bt,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'CM'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_cassa_mlt,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'SM'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_smobilizzo,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'FI'
                                          THEN
                                             pcr.val_imp_uti_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_uti_firma,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'CB'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_cassa_bt,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'CM'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_cassa_mlt,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'SM'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_smobilizzo,
                                    SUM (
                                       CASE
                                          WHEN cl.cod_classe_appl_dett = 'FI'
                                          THEN
                                             pcr.val_imp_acc_cli
                                          ELSE
                                             0
                                       END)
                                       val_tot_dett_acc_firma,
                                    MAX (pcr.dta_riferimento) dta_riferimento
                               FROM t_mcre0_dwh_pscb pcr, -- t_mcre0_app_pcr_sc_sb pcr,
                                    t_mcre0_app_natura_ftecnica cl,
                                    (SELECT id_dper,
                                            CASE
                                               WHEN RANK ()
                                                    OVER (
                                                       ORDER BY id_dper DESC) =
                                                       1
                                               THEN
                                                  1
                                               ELSE
                                                  0
                                            END
                                               flg_last_run
                                       FROM (  SELECT DISTINCT id_dper
                                                 FROM t_mcre0_dwh_pgb --T_MCRE0_APP_PCR_GB
                                             ORDER BY id_dper DESC)
                                      WHERE ROWNUM < 3) r
                              WHERE     pcr.cod_forma_tecnica = cl.cod_ftecnica
                                    AND pcr.id_dper = r.id_dper
                           GROUP BY pcr.cod_abi_istituto,
                                    pcr.cod_ndg,
                                    pcr.id_dper,
                                    r.flg_last_run) pcr,
                          (SELECT cod_sndg,
                                  cod_abi_cartolarizzato,
                                  cod_abi_istituto,
                                  cod_ndg,
                                  id_dper
                             FROM t_mcre0_day_fg) xx
                    WHERE     xx.cod_abi_istituto = pcr.cod_abi_istituto
                          AND xx.cod_ndg = pcr.cod_ndg))
    WHERE my_rnk = 1;
