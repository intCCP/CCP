/* Formatted on 21/07/2014 18:37:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_PCR_GB1
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
     SELECT /*+full(pcr)*/
           pcr.cod_sndg,
            pcr.id_dper id_dper,
            1 FLG_LAST_RUN,
            MAX (val_imp_gar_gre) gegb_tot_gar,
            MAX (val_imp_gar_cli) scgb_tot_gar,
            MAX (val_imp_gar_leg) glgb_tot_gar,
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
                  WHEN CL.COD_CLASSE_APPL_CF = 'RI' THEN pcr.val_imp_acc_cli
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
            ---------------------------------------- OLD
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
                  WHEN CL.COD_CLASSE_APPL_DETT = 'C' THEN pcr.val_imp_acc_cli
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
                  WHEN CL.COD_CLASSE_APPL_DETT = 'FI' THEN pcr.val_imp_uti_gre
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
            SYSDATE dta_ins,
            SYSDATE dta_upd
       FROM mcre_own.t_mcre0_day_pgb pcr,            --t_mcre0_app_pcr_gb pcr,
                                         t_mcre0_app_natura_ftecnica cl
      WHERE pcr.cod_forma_tecnica = cl.cod_ftecnica
   --AND pcr.id_dper = (SELECT a.idper
   --FROM V_MCRE0_ULTIMA_ACQUISIZIONE A
   --WHERE a.cod_file = 'PCR_GB')
   GROUP BY pcr.cod_sndg, pcr.id_dper;
