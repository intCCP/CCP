/* Formatted on 17/06/2014 18:06:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_W_SC_SB
(
   COD_ABI_ISTITUTO,
   COD_NDG,
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
   FLG_FLUSSO_SC_SB
)
AS
   SELECT COD_ABI_ISTITUTO,
          COD_NDG,
          val_tot_ACC_CONSEGNE AS SCSB_ACC_CONSEGNE,
          val_tot_ACC_CONSEGNE_DT AS SCSB_ACC_CONSEGNE_DT,
          val_tot_UTI_CONSEGNE AS SCSB_UTI_CONSEGNE,
          val_tot_UTI_CONSEGNE_DT AS SCSB_UTI_CONSEGNE_DT,
          val_tot_uti_MASSIMALI AS scsb_uti_massimali,
          val_tot_uti_sostituzioni AS scsb_uti_sostituzioni,
          val_tot_uti_rischi_indiretti AS scsb_uti_rischi_indiretti,
          val_tot_dett_uti_MASSIMALI AS scsb_uti_massimali_dt,
          val_tot_dett_uti_sostituzioni AS scsb_uti_sostituzioni_dt,
          val_tot_dett_uti_rischi_ind AS scsb_uti_rischi_indiretti_dt,
          val_tot_acc_MASSIMALI AS scsb_acc_massimali,
          val_tot_acc_sostituzioni AS scsb_acc_sostituzioni,
          val_tot_acc_rischi_indiretti AS scsb_acc_rischi_indiretti,
          val_tot_dett_acc_MASSIMALI AS scsb_acc_massimali_dt,
          val_tot_dett_acc_sostituzioni AS scsb_acc_sostituzioni_dt,
          val_tot_dett_acc_rischi_ind AS scsb_acc_rischi_indiretti_dt,
          val_tot_uti_cassa AS scsb_uti_cassa,
          val_tot_uti_firma AS scsb_uti_firma,
          (val_tot_uti_cassa + val_tot_uti_firma) AS scsb_uti_tot,
          val_tot_acc_cassa AS scsb_acc_cassa,
          val_tot_acc_firma AS scsb_acc_firma,
          (val_tot_acc_cassa + val_tot_acc_firma) AS scsb_acc_tot,
          val_tot_dett_uti_cassa_bt AS scsb_uti_cassa_bt,
          val_tot_dett_uti_cassa_mlt AS scsb_uti_cassa_mlt,
          val_tot_dett_uti_smobilizzo AS scsb_uti_smobilizzo,
          val_tot_dett_uti_firma AS scsb_uti_firma_dt,
          val_tot_dett_acc_cassa_bt AS scsb_acc_cassa_bt,
          val_tot_dett_acc_cassa_mlt AS scsb_acc_cassa_mlt,
          val_tot_dett_acc_smobilizzo AS scsb_acc_smobilizzo,
          val_tot_dett_acc_firma AS scsb_acc_firma_dt,
          val_tot_gar AS scsb_tot_gar,
          dta_riferimento AS scsb_dta_riferimento,
          1 AS FLG_FLUSSO_SC_SB
     FROM (  SELECT cod_abi_istituto,
                    cod_ndg,
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
                    MAX (val_imp_gar_tot) AS val_tot_gar,
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
                    MAX (pcr.dta_riferimento) AS dta_riferimento
               FROM MCRE_OWN.T_MCRE0_DAY_PSCB pcr,
                    MCRE_OWN.T_MCRE0_APP_NATURA_FTECNICA CL
              WHERE PCR.COD_FORMA_TECNICA = CL.COD_FTECNICA
           GROUP BY PCR.COD_ABI_ISTITUTO, PCR.COD_NDG)
   UNION ALL
   SELECT dwh.COD_ABI_ISTITUTO,
          dwh.COD_NDG,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.SCSB_ACC_CONSEGNE
          END
             SCSB_ACC_CONSEGNE,
          NULL AS SCSB_ACC_CONSEGNE_DT,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.SCSB_UTI_CONSEGNE
          END
             SCSB_UTI_CONSEGNE,
          NULL AS SCSB_UTI_CONSEGNE_DT,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_massimali
          END
             scsb_uti_massimali,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_sostituzioni
          END
             scsb_uti_sostituzioni,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_rischi_indiretti
          END
             scsb_uti_rischi_indiretti,
          NULL AS scsb_uti_massimali_dt,
          NULL AS scsb_uti_sostituzioni_dt,
          NULL AS scsb_uti_rischi_indiretti_dt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_massimali
          END
             scsb_acc_massimali,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_sostituzioni
          END
             scsb_acc_sostituzioni,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_rischi_indiretti
          END
             scsb_acc_rischi_indiretti,
          NULL AS scsb_acc_massimali_dt,
          NULL AS scsb_acc_sostituzioni_dt,
          NULL AS scsb_acc_rischi_indiretti_dt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_cassa
          END
             scsb_uti_cassa,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_firma
          END
             scsb_uti_firma,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_tot
          END
             scsb_uti_tot,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_cassa
          END
             scsb_acc_cassa,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_firma
          END
             scsb_acc_firma,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_tot
          END
             scsb_acc_tot,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_cassa_bt
          END
             scsb_uti_cassa_bt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_cassa_mlt
          END
             scsb_uti_cassa_mlt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_smobilizzo
          END
             scsb_uti_smobilizzo,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_uti_firma_dt
          END
             scsb_uti_firma_dt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_cassa_bt
          END
             scsb_acc_cassa_bt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_cassa_mlt
          END
             scsb_acc_cassa_mlt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_smobilizzo
          END
             scsb_acc_smobilizzo,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_acc_firma_dt
          END
             scsb_acc_firma_dt,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_tot_gar
          END
             scsb_tot_gar,
          CASE
             WHEN oth.ID_DPER_TODAY - ps.ID_DPER <= 2 THEN NULL
             ELSE dwh.scsb_dta_riferimento
          END
             scsb_dta_riferimento,
          0 AS FLG_FLUSSO_SC_SB
     FROM MCRE_OWN.T_MCRE0_DWH_DATA dwh,
          MCRE_OWN.T_MCRE0_DWH_PSCB ps,
          (SELECT cod_abi_Cartolarizzato, cod_ndg, id_dper AS id_dper_today
             FROM MCRE_OWN.T_MCRE0_DAY_FG fg
            WHERE NOT EXISTS
                         (SELECT 1
                            FROM MCRE_OWN.T_MCRE0_DAY_PSCB pgb
                           WHERE     pgb.cod_ndg = fg.cod_ndg
                                 AND PGB.COD_ABI_ISTITUTO =
                                        FG.COD_ABI_ISTITUTO)) oth
    WHERE     DWH.COD_ABI_CARTOLARIZZATO = oth.cod_abi_cartolarizzato
          AND DWH.COD_NDG = oth.cod_ndg
          AND DWH.COD_ABI_ISTITUTO = ps.COD_ABI_ISTITUTO
          AND DWH.COD_NDG = ps.COD_NDG;


GRANT SELECT ON MCRE_OWN.V_MCRE0_W_SC_SB TO MCRE_USR;
