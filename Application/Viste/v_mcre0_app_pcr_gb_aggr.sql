/* Formatted on 21/07/2014 18:34:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PCR_GB_AGGR
(
   COD_SNDG,
   VAL_SC_UTI_CASSA,
   VAL_SC_UTI_FIRMA,
   VAL_SC_ACC_CASSA,
   VAL_SC_ACC_FIRMA,
   VAL_SC_UTI_CASSA_BT,
   VAL_SC_UTI_CASSA_MLT,
   VAL_SC_UTI_SMOBILIZZO,
   VAL_SC_UTI_FIRMA_DT,
   VAL_SC_ACC_CASSA_BT,
   VAL_SC_ACC_CASSA_MLT,
   VAL_SC_ACC_SMOBILIZZO,
   VAL_SC_ACC_FIRMA_DT,
   VAL_GE_UTI_CASSA,
   VAL_GE_UTI_FIRMA,
   VAL_GE_ACC_CASSA,
   VAL_GE_ACC_FIRMA,
   VAL_GE_UTI_CASSA_BT,
   VAL_GE_UTI_CASSA_MLT,
   VAL_GE_UTI_SMOBILIZZO,
   VAL_GE_UTI_FIRMA_DT,
   VAL_GE_ACC_CASSA_BT,
   VAL_GE_ACC_CASSA_MLT,
   VAL_GE_ACC_SMOBILIZZO,
   VAL_GE_ACC_FIRMA_DT,
   VAL_GL_UTI_CASSA,
   VAL_GL_UTI_FIRMA,
   VAL_GL_ACC_CASSA,
   VAL_GL_ACC_FIRMA,
   VAL_GL_UTI_CASSA_BT,
   VAL_GL_UTI_CASSA_MLT,
   VAL_GL_UTI_SMOBILIZZO,
   VAL_GL_UTI_FIRMA_DT,
   VAL_GL_ACC_CASSA_BT,
   VAL_GL_ACC_CASSA_MLT,
   VAL_GL_ACC_SMOBILIZZO,
   VAL_GL_ACC_FIRMA_DT,
   DTA_RIFERIMENTO
)
AS
     SELECT                                     -- V1 02/12/2010 VG: Congelata
           pcr.cod_sndg,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_sc_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_sc_acc_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_gre
                  ELSE 0
               END)
               val_ge_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_gre
                  ELSE 0
               END)
               val_ge_acc_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_leg
                  ELSE 0
               END)
               val_gl_uti_firma_dt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_leg
                  ELSE 0
               END)
               val_gl_acc_firma_dt,
            pcr.dta_riferimento
       FROM t_mcre0_app_pcr_gb pcr, t_mcre0_app_natura_ftecnica cl
      WHERE     pcr.cod_forma_tecnica = cl.cod_ftecnica
            AND pcr.id_dper = (SELECT a.idper
                                 FROM v_mcre0_ultima_acquisizione a
                                WHERE a.cod_file = 'PCR_GB')
   GROUP BY pcr.cod_sndg, pcr.dta_riferimento;
