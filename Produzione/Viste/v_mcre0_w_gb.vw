/* Formatted on 17/06/2014 18:06:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_GB
(
   ID_DPER,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
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
   FLG_FLUSSO_GB
)
AS
     SELECT id_dper,
            pcr.cod_sndg,
            NULL AS cod_abi_cartolarizzato,
            NULL AS cod_ndg,
            MAX (pcr.val_imp_gar_gre) gegb_tot_gar,
            MAX (pcr.val_imp_gar_cli) scgb_tot_gar,
            MAX (pcr.val_imp_gar_leg) glgb_tot_gar,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_gre
                  ELSE 0
               END)
               gegb_ACC_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_gre
                  ELSE 0
               END)
               gegb_ACC_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_CLI
                  ELSE 0
               END)
               SCgb_uti_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_CLI
                  ELSE 0
               END)
               SCgb_uti_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_CLI
                  ELSE 0
               END)
               SCgb_ACC_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_CLI
                  ELSE 0
               END)
               SCgb_ACC_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_LEG
                  ELSE 0
               END)
               GLgb_uti_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_uti_LEG
                  ELSE 0
               END)
               GLgb_uti_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_LEG
                  ELSE 0
               END)
               GLgb_ACC_CONSEGNE,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CO' THEN pcr.val_imp_ACC_LEG
                  ELSE 0
               END)
               GLgb_ACC_CONSEGNE_DT,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_sostituzioni,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_massimali,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_rischi_indiretti,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'ST' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_sostituzioni_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'MS' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_massimali_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'RI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_rischi_indiretti_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               scgb_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'C' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               scgb_acc_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               gegb_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               gegb_acc_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               glgb_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               glgb_acc_firma_dt,
            MAX (pcr.dta_riferimento) dta_riferimento,
            1 AS FLG_FLUSSO_GB
       FROM T_MCRE0_DAY_PGB pcr, T_MCRE0_APP_NATURA_FTECNICA cl
      WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
   GROUP BY PCR.COD_SNDG, id_dper
   UNION ALL
   SELECT SCGB_ID_DPER,
          COD_SNDG,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
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
          FLG_FLUSSO_GB
     FROM (SELECT SCGB_ID_DPER,
                  DWH.COD_SNDG,
                  dwh.cod_abi_cartolarizzato,
                  dwh.cod_ndg,
                  dwh.gegb_tot_gar,
                  dwh.scgb_tot_gar,
                  dwh.glgb_tot_gar,
                  dwh.gegb_uti_CONSEGNE,
                  NULL AS gegb_uti_CONSEGNE_DT,
                  dwh.gegb_ACC_CONSEGNE,
                  NULL AS gegb_ACC_CONSEGNE_DT,
                  dwh.SCgb_uti_CONSEGNE,
                  NULL AS SCgb_uti_CONSEGNE_DT,
                  dwh.SCgb_ACC_CONSEGNE,
                  NULL AS SCgb_ACC_CONSEGNE_DT,
                  dwh.GLgb_uti_CONSEGNE,
                  NULL AS GLgb_uti_CONSEGNE_DT,
                  dwh.GLgb_ACC_CONSEGNE,
                  NULL AS GLgb_ACC_CONSEGNE_DT,
                  dwh.gegb_uti_sostituzioni,
                  dwh.gegb_uti_massimali,
                  dwh.gegb_uti_rischi_indiretti,
                  dwh.gegb_acc_sostituzioni,
                  dwh.gegb_acc_massimali,
                  dwh.gegb_acc_rischi_indiretti,
                  NULL AS gegb_uti_sostituzioni_dt,
                  NULL AS gegb_uti_massimali_dt,
                  NULL AS gegb_uti_rischi_indiretti_dt,
                  NULL AS gegb_acc_sostituzioni_dt,
                  NULL AS gegb_acc_massimali_dt,
                  NULL AS gegb_acc_rischi_indiretti_dt,
                  dwh.scgb_uti_sostituzioni,
                  dwh.scgb_uti_massimali,
                  dwh.scgb_uti_rischi_indiretti,
                  dwh.scgb_acc_sostituzioni,
                  dwh.scgb_acc_massimali,
                  dwh.scgb_acc_rischi_indiretti,
                  NULL AS scgb_uti_sostituzioni_dt,
                  NULL AS scgb_uti_massimali_dt,
                  NULL AS scgb_uti_rischi_indiretti_dt,
                  NULL AS scgb_acc_sostituzioni_dt,
                  NULL AS scgb_acc_massimali_dt,
                  NULL AS scgb_acc_rischi_indiretti_dt,
                  dwh.glgb_uti_sostituzioni,
                  dwh.glgb_uti_massimali,
                  dwh.glgb_uti_rischi_indiretti,
                  dwh.glgb_acc_sostituzioni,
                  dwh.glgb_acc_massimali,
                  dwh.glgb_acc_rischi_indiretti,
                  NULL AS glgb_uti_sostituzioni_dt,
                  NULL AS glgb_uti_massimali_dt,
                  NULL AS glgb_uti_rischi_indiretti_dt,
                  NULL AS glgb_acc_sostituzioni_dt,
                  NULL AS glgb_acc_massimali_dt,
                  NULL AS glgb_acc_rischi_indiretti_dt,
                  dwh.scgb_uti_cassa,
                  dwh.scgb_uti_firma,
                  dwh.scgb_acc_cassa,
                  dwh.scgb_acc_firma,
                  dwh.scgb_uti_cassa_bt,
                  dwh.scgb_uti_cassa_mlt,
                  dwh.scgb_uti_smobilizzo,
                  dwh.scgb_uti_firma_dt,
                  dwh.scgb_acc_cassa_bt,
                  dwh.scgb_acc_cassa_mlt,
                  dwh.scgb_acc_smobilizzo,
                  dwh.scgb_acc_firma_dt,
                  dwh.gegb_uti_cassa,
                  dwh.gegb_uti_firma,
                  dwh.gegb_acc_cassa,
                  dwh.gegb_acc_firma,
                  dwh.gegb_uti_cassa_bt,
                  dwh.gegb_uti_cassa_mlt,
                  dwh.gegb_uti_smobilizzo,
                  dwh.gegb_uti_firma_dt,
                  dwh.gegb_acc_cassa_bt,
                  dwh.gegb_acc_cassa_mlt,
                  dwh.gegb_acc_smobilizzo,
                  dwh.gegb_acc_firma_dt,
                  dwh.glgb_uti_cassa,
                  dwh.glgb_uti_firma,
                  dwh.glgb_acc_cassa,
                  dwh.glgb_acc_firma,
                  dwh.glgb_uti_cassa_bt,
                  dwh.glgb_uti_cassa_mlt,
                  dwh.glgb_uti_smobilizzo,
                  dwh.glgb_uti_firma_dt,
                  dwh.glgb_acc_cassa_bt,
                  dwh.glgb_acc_cassa_mlt,
                  dwh.glgb_acc_smobilizzo,
                  dwh.glgb_acc_firma_dt,
                  dwh.gb_dta_riferimento dta_riferimento,
                  0 AS FLG_FLUSSO_GB
             FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
                  (SELECT cod_abi_Cartolarizzato, cod_ndg
                     FROM MCRE_OWN.T_MCRE0_DAY_FG fg
                    WHERE NOT EXISTS
                             (SELECT 1
                                FROM MCRE_OWN.T_MCRE0_DAY_PGB pgb
                               WHERE pgb.cod_sndg = fg.cod_sndg)) oth
            WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
                  AND DWH.COD_NDG = oth.cod_ndg);


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_GB TO MCRE_USR;
