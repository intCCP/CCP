/* Formatted on 21/07/2014 18:34:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PCR_SC_SB_AGGR
(
   COD_ABI_ISTITUTO,
   COD_NDG,
   VAL_TOT_UTI_CASSA,
   VAL_TOT_UTI_FIRMA,
   VAL_TOT_ACC_CASSA,
   VAL_TOT_ACC_FIRMA,
   VAL_TOT_GAR,
   VAL_TOT_DETT_UTI_CASSA_BT,
   VAL_TOT_DETT_UTI_CASSA_MLT,
   VAL_TOT_DETT_UTI_SMOBILIZZO,
   VAL_TOT_DETT_UTI_FIRMA,
   VAL_TOT_DETT_ACC_CASSA_BT,
   VAL_TOT_DETT_ACC_CASSA_MLT,
   VAL_TOT_DETT_ACC_SMOBILIZZO,
   VAL_TOT_DETT_ACC_FIRMA,
   DTA_RIFERIMENTO
)
AS
     SELECT                                     -- V1 02/12/2010 VG: Congelata
           cod_abi_istituto,
            cod_ndg,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_uti_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'CA' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_acc_cassa,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_cf = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_acc_firma,
            MAX (val_imp_gar_tot) val_tot_gar,
            --stesso valore su tutte le Forme Tecniche
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_dett_uti_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_dett_uti_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_dett_uti_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_uti_cli
                  ELSE 0
               END)
               val_tot_dett_uti_firma,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CB' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_dett_acc_cassa_bt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'CM' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_dett_acc_cassa_mlt,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'SM' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_dett_acc_smobilizzo,
            SUM (
               CASE
                  WHEN cl.cod_classe_appl_dett = 'FI' THEN pcr.val_imp_acc_cli
                  ELSE 0
               END)
               val_tot_dett_acc_firma,
            pcr.dta_riferimento
       --SUM (val_imp_gar_tot) val_tot_gar
       ---------------
       FROM t_mcre0_app_pcr_sc_sb pcr
            INNER JOIN t_mcre0_app_natura_ftecnica cl
               ON (pcr.cod_forma_tecnica = cl.cod_ftecnica)
      WHERE pcr.id_dper = (SELECT a.idper
                             FROM v_mcre0_ultima_acquisizione a
                            WHERE a.cod_file = 'PCR_SC_SB')
   GROUP BY pcr.cod_abi_istituto, pcr.cod_ndg, pcr.dta_riferimento;
