/* Formatted on 17/06/2014 18:05:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_PCR_GESB
(
   ID_DPER_GESB,
   FLG_LAST_RUN,
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   GESB_ACC_CONSEGNE,
   GESB_ACC_CONSEGNE_DT,
   GESB_UTI_CONSEGNE,
   GESB_UTI_CONSEGNE_DT,
   GESB_UTI_SOSTITUZIONI,
   GESB_UTI_MASSIMALI,
   GESB_UTI_RISCHI_INDIRETTI,
   GESB_UTI_SOSTITUZIONI_DT,
   GESB_UTI_MASSIMALI_DT,
   GESB_UTI_RISCHI_INDIRETTI_DT,
   GESB_ACC_SOSTITUZIONI,
   GESB_ACC_MASSIMALI,
   GESB_ACC_RISCHI_INDIRETTI,
   GESB_ACC_SOSTITUZIONI_DT,
   GESB_ACC_MASSIMALI_DT,
   GESB_ACC_RISCHI_INDIRETTI_DT,
   GESB_UTI_CASSA,
   GESB_UTI_FIRMA,
   GESB_ACC_CASSA,
   GESB_ACC_FIRMA,
   GESB_UTI_CASSA_BT,
   GESB_UTI_CASSA_MLT,
   GESB_UTI_SMOBILIZZO,
   GESB_UTI_FIRMA_DT,
   GESB_ACC_CASSA_BT,
   GESB_ACC_CASSA_MLT,
   GESB_ACC_SMOBILIZZO,
   GESB_ACC_FIRMA_DT,
   GESB_TOT_GAR,
   GESB_DTA_RIFERIMENTO,
   GESB_ACC_TOT,
   GESB_UTI_TOT,
   DTA_INS,
   DTA_UPD
)
AS
   SELECT ID_DPER_GESB,
          FLG_LAST_RUN,
          ID_DPER,
          COD_ABI_ISTITUTO,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_SNDG,
          GESB_ACC_CONSEGNE,
          GESB_ACC_CONSEGNE_DT,
          GESB_UTI_CONSEGNE,
          GESB_UTI_CONSEGNE_DT,
          GESB_UTI_SOSTITUZIONI,
          GESB_UTI_MASSIMALI,
          GESB_UTI_RISCHI_INDIRETTI,
          GESB_UTI_SOSTITUZIONI_DT,
          GESB_UTI_MASSIMALI_DT,
          GESB_UTI_RISCHI_INDIRETTI_DT,
          GESB_ACC_SOSTITUZIONI,
          GESB_ACC_MASSIMALI,
          GESB_ACC_RISCHI_INDIRETTI,
          GESB_ACC_SOSTITUZIONI_DT,
          GESB_ACC_MASSIMALI_DT,
          GESB_ACC_RISCHI_INDIRETTI_DT,
          GESB_UTI_CASSA,
          GESB_UTI_FIRMA,
          GESB_ACC_CASSA,
          GESB_ACC_FIRMA,
          GESB_UTI_CASSA_BT,
          GESB_UTI_CASSA_MLT,
          GESB_UTI_SMOBILIZZO,
          GESB_UTI_FIRMA_DT,
          GESB_ACC_CASSA_BT,
          GESB_ACC_CASSA_MLT,
          GESB_ACC_SMOBILIZZO,
          GESB_ACC_FIRMA_DT,
          GESB_TOT_GAR,
          GESB_DTA_RIFERIMENTO,
          GESB_ACC_TOT,
          GESB_UTI_TOT,
          DTA_INS,
          DTA_UPD
     FROM (SELECT pcr.id_dper id_dper_gesb,
                  1 FLG_LAST_RUN,
                  xx.id_dper,
                  gesb_acc_consegne,
                  gesb_acc_consegne_dt,
                  gesb_uti_consegne,
                  gesb_uti_consegne_dt,
                  gesb_uti_sostituzioni,
                  gesb_uti_massimali,
                  gesb_uti_rischi_indiretti,
                  gesb_uti_sostituzioni_dt,
                  gesb_uti_massimali_dt,
                  gesb_uti_rischi_indiretti_dt,
                  gesb_acc_sostituzioni,
                  gesb_acc_massimali,
                  gesb_acc_rischi_indiretti,
                  gesb_acc_sostituzioni_dt,
                  gesb_acc_massimali_dt,
                  gesb_acc_rischi_indiretti_dt,
                  gesb_uti_cassa,
                  gesb_uti_firma,
                  gesb_acc_cassa,
                  gesb_acc_firma,
                  gesb_uti_cassa_bt,
                  gesb_uti_cassa_mlt,
                  gesb_uti_smobilizzo,
                  gesb_uti_firma_dt,
                  gesb_acc_cassa_bt,
                  gesb_acc_cassa_mlt,
                  gesb_acc_smobilizzo,
                  gesb_acc_firma_dt,
                  gesb_tot_gar,
                  gesb_dta_riferimento,
                  gesb_acc_cassa + gesb_acc_firma gesb_acc_tot,
                  gesb_uti_cassa + gesb_uti_firma gesb_uti_tot,
                  xx.cod_sndg,
                  xx.cod_abi_istituto,
                  xx.cod_ndg,
                  cod_abi_cartolarizzato,
                  SYSDATE dta_ins,
                  SYSDATE dta_upd
             FROM (  SELECT pcr.cod_abi_istituto,
                            pcr.cod_sndg,
                            pcr.id_dper,
                            ge.cod_gruppo_economico,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CO'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_CONSEGNE,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CO'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_CONSEGNE_DT,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CO'
                                  THEN
                                     pcr.val_imp_ACC_gre
                                  ELSE
                                     0
                               END)
                               gesb_ACC_CONSEGNE,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CO'
                                  THEN
                                     pcr.val_imp_ACC_gre
                                  ELSE
                                     0
                               END)
                               gesb_ACC_CONSEGNE_DT,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'ST'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_sostituzioni,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'MS'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_massimali,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'RI'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_rischi_indiretti,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'ST'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_sostituzioni,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'MS'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_massimali,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'RI'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_rischi_indiretti,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'ST'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_sostituzioni_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'MS'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_massimali_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'RI'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_rischi_indiretti_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'ST'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_sostituzioni_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'MS'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_massimali_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'RI'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_rischi_indiretti_dt,
                            ---------------------------------------- OLD
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CA'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_cassa,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'FI'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_firma,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'CA'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_cassa,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_cf = 'FI'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_firma,
                            MAX (val_imp_gar_gre) gesb_tot_gar,
                            --stesso valore su tutte le Forme Tecniche
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'CB'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_cassa_bt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'CM'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_cassa_mlt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'SM'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_smobilizzo,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'FI'
                                  THEN
                                     pcr.val_imp_uti_gre
                                  ELSE
                                     0
                               END)
                               gesb_uti_firma_dt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'CB'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_cassa_bt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'CM'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_cassa_mlt,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'SM'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_smobilizzo,
                            SUM (
                               CASE
                                  WHEN cl.cod_classe_appl_dett = 'FI'
                                  THEN
                                     pcr.val_imp_acc_gre
                                  ELSE
                                     0
                               END)
                               gesb_acc_firma_dt,
                            MAX (pcr.dta_riferimento) GESB_dta_riferimento
                       FROM t_mcre0_day_pges pcr, --t_mcre0_app_pcr_ge_sb pcr,
                            t_mcre0_app_natura_ftecnica cl,
                            t_mcre0_dwh_ge ge --t_mcre0_app_gruppo_economico ge
                      WHERE     pcr.cod_forma_tecn = cl.cod_ftecnica
                            AND pcr.cod_sndg = ge.cod_sndg
                   --AND pcr.id_dper =(SELECT a.idper
                   --FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
                   --WHERE a.cod_file = 'PCR_GE_SB')
                   GROUP BY pcr.cod_abi_istituto,
                            pcr.cod_sndg,
                            ge.cod_gruppo_economico,
                            pcr.id_dper) pcr,
                  (SELECT id_dper,
                          cod_sndg,
                          cod_abi_cartolarizzato,
                          cod_abi_istituto,
                          cod_ndg
                     FROM t_mcre0_day_fg) xx
            WHERE     xx.cod_sndg = pcr.cod_sndg
                  AND xx.cod_abi_istituto = pcr.cod_abi_istituto);


GRANT SELECT ON MCRE_OWN.V_MCRE0_PCR_GESB TO MCRE_USR;
