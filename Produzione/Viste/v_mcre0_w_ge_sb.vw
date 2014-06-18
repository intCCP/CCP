/* Formatted on 17/06/2014 18:06:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_GE_SB
(
   COD_SNDG,
   COD_ABI_ISTITUTO,
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
   FLG_FLUSSO_GE_SB
)
AS
   SELECT cod_sndg,
          cod_abi_istituto,
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
          gesb_acc_cassa + gesb_acc_firma AS gesb_acc_tot,
          gesb_uti_cassa + gesb_uti_firma AS gesb_uti_tot,
          1 AS FLG_FLUSSO_GE_SB
     FROM (  SELECT pcr.cod_abi_istituto,
                    pcr.cod_sndg,
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
               FROM MCRE_OWN.T_MCRE0_DAY_PGES pcr,
                    T_MCRE0_APP_NATURA_FTECNICA cl,
                    T_MCRE0_APP_GRUPPO_ECONOMICO ge
              WHERE     pcr.cod_forma_tecn = cl.cod_ftecnica
                    AND PCR.COD_SNDG = GE.COD_SNDG
           GROUP BY pcr.cod_abi_istituto,
                    pcr.cod_sndg,
                    ge.cod_gruppo_economico)
   UNION ALL
   SELECT dwh.cod_sndg,
          dwh.cod_abi_istituto,
          dwh.gesb_acc_consegne,
          NULL AS gesb_acc_consegne_dt,
          dwh.gesb_uti_consegne,
          NULL AS gesb_uti_consegne_dt,
          dwh.gesb_uti_sostituzioni,
          dwh.gesb_uti_massimali,
          dwh.gesb_uti_rischi_indiretti,
          NULL AS gesb_uti_sostituzioni_dt,
          NULL AS gesb_uti_massimali_dt,
          NULL AS gesb_uti_rischi_indiretti_dt,
          dwh.gesb_acc_sostituzioni,
          dwh.gesb_acc_massimali,
          dwh.gesb_acc_rischi_indiretti,
          NULL AS gesb_acc_sostituzioni_dt,
          NULL AS gesb_acc_massimali_dt,
          NULL AS gesb_acc_rischi_indiretti_dt,
          dwh.gesb_uti_cassa,
          dwh.gesb_uti_firma,
          dwh.gesb_acc_cassa,
          dwh.gesb_acc_firma,
          dwh.gesb_uti_cassa_bt,
          dwh.gesb_uti_cassa_mlt,
          dwh.gesb_uti_smobilizzo,
          dwh.gesb_uti_firma_dt,
          dwh.gesb_acc_cassa_bt,
          dwh.gesb_acc_cassa_mlt,
          dwh.gesb_acc_smobilizzo,
          dwh.gesb_acc_firma_dt,
          dwh.gesb_tot_gar,
          dwh.gesb_dta_riferimento,
          gesb_acc_cassa + gesb_acc_firma AS gesb_acc_tot,
          gesb_uti_cassa + gesb_uti_firma AS gesb_uti_tot,
          0 AS FLG_FLUSSO_GE_SB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          (SELECT /*+ full(fg) */
                 cod_abi_Cartolarizzato, cod_ndg
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                     (SELECT 1
                        FROM MCRE_OWN.T_MCRE0_DAY_PGES pgb
                       WHERE pgb.cod_sndg = fg.cod_sndg)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_GE_SB TO MCRE_USR;
