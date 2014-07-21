/* Formatted on 21/07/2014 18:33:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_ESP_ANN
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   GESB_COD_STATO_AT,
   GESB_DTA_CONTROLLO_AT,
   GESB_DTA_PCR_AT,
   GESB_DTA_CR_AT,
   GESB_ACC_CASSA_BT_AT,
   GESB_UTI_CASSA_BT_AT,
   GESB_ACC_SMOBILIZZO_AT,
   GESB_UTI_SMOBILIZZO_AT,
   GESB_ACC_CASSA_MLT_AT,
   GESB_UTI_CASSA_MLT_AT,
   GESB_ACC_FIRMA_AT,
   GESB_UTI_FIRMA_AT,
   GESB_ACC_TOT_AT,
   GESB_UTI_TOT_AT,
   GESB_TOT_GAR_AT,
   GESB_ACC_SOSTITUZIONI_AT,
   GESB_UTI_SOSTITUZIONI_AT,
   GESB_ACC_MASSIMALI_AT,
   GESB_UTI_MASSIMALI_AT,
   GEGB_ACC_SOSTITUZIONI_AT,
   GEGB_UTI_SOSTITUZIONI_AT,
   GEGB_ACC_MASSIMALI_AT,
   GEGB_UTI_MASSIMALI_AT,
   GEGB_ACC_CASSA_BT_AT,
   GEGB_UTI_CASSA_BT_AT,
   GEGB_ACC_SMOBILIZZO_AT,
   GEGB_UTI_SMOBILIZZO_AT,
   GEGB_ACC_CASSA_MLT_AT,
   GEGB_UTI_CASSA_MLT_AT,
   GEGB_ACC_FIRMA_AT,
   GEGB_UTI_FIRMA_AT,
   GEGB_TOT_GAR_AT,
   GEGB_ACC_TOT_AT,
   GEGB_UTI_TOT_AT,
   GESB_QIS_ACC_AT,
   GESB_QIS_UTI_AT,
   GEGB_QIS_ACC_AT,
   GEGB_QIS_UTI_AT,
   GESB_COD_STATO_MP,
   GESB_DTA_CONTROLLO_MP,
   GESB_DTA_PCR_MP,
   GESB_DTA_CR_MP,
   GESB_ACC_CASSA_BT_MP,
   GESB_UTI_CASSA_BT_MP,
   GESB_ACC_SMOBILIZZO_MP,
   GESB_UTI_SMOBILIZZO_MP,
   GESB_ACC_CASSA_MLT_MP,
   GESB_UTI_CASSA_MLT_MP,
   GESB_ACC_FIRMA_MP,
   GESB_UTI_FIRMA_MP,
   GESB_ACC_TOT_MP,
   GESB_UTI_TOT_MP,
   GESB_TOT_GAR_MP,
   GEGB_ACC_CASSA_BT_MP,
   GEGB_UTI_CASSA_BT_MP,
   GEGB_ACC_SMOBILIZZO_MP,
   GEGB_UTI_SMOBILIZZO_MP,
   GEGB_ACC_CASSA_MLT_MP,
   GEGB_UTI_CASSA_MLT_MP,
   GEGB_ACC_FIRMA_MP,
   GEGB_UTI_FIRMA_MP,
   GEGB_TOT_GAR_MP,
   GESB_ACC_SOSTITUZIONI_MP,
   GESB_UTI_SOSTITUZIONI_MP,
   GESB_ACC_MASSIMALI_MP,
   GESB_UTI_MASSIMALI_MP,
   GEGB_ACC_SOSTITUZIONI_MP,
   GEGB_UTI_SOSTITUZIONI_MP,
   GEGB_ACC_MASSIMALI_MP,
   GEGB_UTI_MASSIMALI_MP,
   GEGB_ACC_TOT_MP,
   GEGB_UTI_TOT_MP,
   GESB_QIS_ACC_MP,
   GESB_QIS_UTI_MP,
   GEGB_QIS_ACC_MP,
   GEGB_QIS_UTI_MP,
   GESB_COD_STATO_LY,
   GESB_DTA_CONTROLLO_LY,
   GESB_DTA_PCR_LY,
   GESB_DTA_CR_LY,
   GESB_ACC_CASSA_BT_LY,
   GESB_UTI_CASSA_BT_LY,
   GESB_ACC_SMOBILIZZO_LY,
   GESB_UTI_SMOBILIZZO_LY,
   GESB_ACC_CASSA_MLT_LY,
   GESB_UTI_CASSA_MLT_LY,
   GESB_ACC_FIRMA_LY,
   GESB_UTI_FIRMA_LY,
   GESB_ACC_TOT_LY,
   GESB_UTI_TOT_LY,
   GESB_TOT_GAR_LY,
   GESB_ACC_SOSTITUZIONI_LY,
   GESB_UTI_SOSTITUZIONI_LY,
   GESB_ACC_MASSIMALI_LY,
   GESB_UTI_MASSIMALI_LY,
   GEGB_ACC_SOSTITUZIONI_LY,
   GEGB_UTI_SOSTITUZIONI_LY,
   GEGB_ACC_MASSIMALI_LY,
   GEGB_UTI_MASSIMALI_LY,
   GEGB_ACC_CASSA_BT_LY,
   GEGB_UTI_CASSA_BT_LY,
   GEGB_ACC_SMOBILIZZO_LY,
   GEGB_UTI_SMOBILIZZO_LY,
   GEGB_ACC_CASSA_MLT_LY,
   GEGB_UTI_CASSA_MLT_LY,
   GEGB_ACC_FIRMA_LY,
   GEGB_UTI_FIRMA_LY,
   GEGB_TOT_GAR_LY,
   GEGB_ACC_TOT_LY,
   GEGB_UTI_TOT_LY,
   GESB_QIS_ACC_LY,
   GESB_QIS_UTI_LY,
   GEGB_QIS_ACC_LY,
   GEGB_QIS_UTI_LY,
   GESB_COD_STATO_LY2,
   GESB_DTA_CONTROLLO_LY2,
   GESB_DTA_PCR_LY2,
   GESB_DTA_CR_LY2,
   GESB_ACC_CASSA_BT_LY2,
   GESB_UTI_CASSA_BT_LY2,
   GESB_ACC_SMOBILIZZO_LY2,
   GESB_UTI_SMOBILIZZO_LY2,
   GESB_ACC_CASSA_MLT_LY2,
   GESB_UTI_CASSA_MLT_LY2,
   GESB_ACC_FIRMA_LY2,
   GESB_UTI_FIRMA_LY2,
   GESB_ACC_TOT_LY2,
   GESB_UTI_TOT_LY2,
   GESB_TOT_GAR_LY2,
   GESB_ACC_SOSTITUZIONI_LY2,
   GESB_UTI_SOSTITUZIONI_LY2,
   GESB_ACC_MASSIMALI_LY2,
   GESB_UTI_MASSIMALI_LY2,
   GEGB_ACC_SOSTITUZIONI_LY2,
   GEGB_UTI_SOSTITUZIONI_LY2,
   GEGB_ACC_MASSIMALI_LY2,
   GEGB_UTI_MASSIMALI_LY2,
   GEGB_ACC_CASSA_BT_LY2,
   GEGB_UTI_CASSA_BT_LY2,
   GEGB_ACC_SMOBILIZZO_LY2,
   GEGB_UTI_SMOBILIZZO_LY2,
   GEGB_ACC_CASSA_MLT_LY2,
   GEGB_UTI_CASSA_MLT_LY2,
   GEGB_ACC_FIRMA_LY2,
   GEGB_UTI_FIRMA_LY2,
   GEGB_TOT_GAR_LY2,
   GEGB_ACC_TOT_LY2,
   GEGB_UTI_TOT_LY2,
   GESB_QIS_ACC_LY2,
   GESB_QIS_UTI_LY2,
   GEGB_QIS_ACC_LY2,
   GEGB_QIS_UTI_LY2,
   SCSB_COD_STATO_AT,
   SCSB_DTA_CONTROLLO_AT,
   SCSB_DTA_PCR_AT,
   SCSB_DTA_CR_AT,
   SCSB_ACC_CASSA_BT_AT,
   SCSB_UTI_CASSA_BT_AT,
   SCSB_ACC_SMOBILIZZO_AT,
   SCSB_UTI_SMOBILIZZO_AT,
   SCSB_ACC_CASSA_MLT_AT,
   SCSB_UTI_CASSA_MLT_AT,
   SCSB_ACC_FIRMA_AT,
   SCSB_UTI_FIRMA_AT,
   SCSB_ACC_TOT_AT,
   SCSB_UTI_TOT_AT,
   SCSB_TOT_GAR_AT,
   SCSB_ACC_SOSTITUZIONI_AT,
   SCSB_UTI_SOSTITUZIONI_AT,
   SCSB_ACC_MASSIMALI_AT,
   SCSB_UTI_MASSIMALI_AT,
   SCGB_ACC_SOSTITUZIONI_AT,
   SCGB_UTI_SOSTITUZIONI_AT,
   SCGB_ACC_MASSIMALI_AT,
   SCGB_UTI_MASSIMALI_AT,
   SCGB_ACC_CASSA_BT_AT,
   SCGB_UTI_CASSA_BT_AT,
   SCGB_ACC_SMOBILIZZO_AT,
   SCGB_UTI_SMOBILIZZO_AT,
   SCGB_ACC_CASSA_MLT_AT,
   SCGB_UTI_CASSA_MLT_AT,
   SCGB_ACC_FIRMA_AT,
   SCGB_UTI_FIRMA_AT,
   SCGB_TOT_GAR_AT,
   SCGB_ACC_TOT_AT,
   SCGB_UTI_TOT_AT,
   SCSB_QIS_ACC_AT,
   SCSB_QIS_UTI_AT,
   SCGB_QIS_ACC_AT,
   SCGB_QIS_UTI_AT,
   SCSB_COD_STATO_MP,
   SCSB_DTA_CONTROLLO_MP,
   SCSB_DTA_PCR_MP,
   SCSB_DTA_CR_MP,
   SCSB_ACC_CASSA_BT_MP,
   SCSB_UTI_CASSA_BT_MP,
   SCSB_ACC_SMOBILIZZO_MP,
   SCSB_UTI_SMOBILIZZO_MP,
   SCSB_ACC_CASSA_MLT_MP,
   SCSB_UTI_CASSA_MLT_MP,
   SCSB_ACC_FIRMA_MP,
   SCSB_UTI_FIRMA_MP,
   SCSB_ACC_TOT_MP,
   SCSB_UTI_TOT_MP,
   SCSB_TOT_GAR_MP,
   SCGB_ACC_CASSA_BT_MP,
   SCGB_UTI_CASSA_BT_MP,
   SCGB_ACC_SMOBILIZZO_MP,
   SCGB_UTI_SMOBILIZZO_MP,
   SCGB_ACC_CASSA_MLT_MP,
   SCGB_UTI_CASSA_MLT_MP,
   SCGB_ACC_FIRMA_MP,
   SCGB_UTI_FIRMA_MP,
   SCGB_TOT_GAR_MP,
   SCSB_ACC_SOSTITUZIONI_MP,
   SCSB_UTI_SOSTITUZIONI_MP,
   SCSB_ACC_MASSIMALI_MP,
   SCSB_UTI_MASSIMALI_MP,
   SCGB_ACC_SOSTITUZIONI_MP,
   SCGB_UTI_SOSTITUZIONI_MP,
   SCGB_ACC_MASSIMALI_MP,
   SCGB_UTI_MASSIMALI_MP,
   SCGB_ACC_TOT_MP,
   SCGB_UTI_TOT_MP,
   SCSB_QIS_ACC_MP,
   SCSB_QIS_UTI_MP,
   SCGB_QIS_ACC_MP,
   SCGB_QIS_UTI_MP,
   SCSB_COD_STATO_LY,
   SCSB_DTA_CONTROLLO_LY,
   SCSB_DTA_PCR_LY,
   SCSB_DTA_CR_LY,
   SCSB_ACC_CASSA_BT_LY,
   SCSB_UTI_CASSA_BT_LY,
   SCSB_ACC_SMOBILIZZO_LY,
   SCSB_UTI_SMOBILIZZO_LY,
   SCSB_ACC_CASSA_MLT_LY,
   SCSB_UTI_CASSA_MLT_LY,
   SCSB_ACC_FIRMA_LY,
   SCSB_UTI_FIRMA_LY,
   SCSB_ACC_TOT_LY,
   SCSB_UTI_TOT_LY,
   SCSB_TOT_GAR_LY,
   SCSB_ACC_SOSTITUZIONI_LY,
   SCSB_UTI_SOSTITUZIONI_LY,
   SCSB_ACC_MASSIMALI_LY,
   SCSB_UTI_MASSIMALI_LY,
   SCGB_ACC_SOSTITUZIONI_LY,
   SCGB_UTI_SOSTITUZIONI_LY,
   SCGB_ACC_MASSIMALI_LY,
   SCGB_UTI_MASSIMALI_LY,
   SCGB_ACC_CASSA_BT_LY,
   SCGB_UTI_CASSA_BT_LY,
   SCGB_ACC_SMOBILIZZO_LY,
   SCGB_UTI_SMOBILIZZO_LY,
   SCGB_ACC_CASSA_MLT_LY,
   SCGB_UTI_CASSA_MLT_LY,
   SCGB_ACC_FIRMA_LY,
   SCGB_UTI_FIRMA_LY,
   SCGB_TOT_GAR_LY,
   SCGB_ACC_TOT_LY,
   SCGB_UTI_TOT_LY,
   SCSB_QIS_ACC_LY,
   SCSB_QIS_UTI_LY,
   SCGB_QIS_ACC_LY,
   SCGB_QIS_UTI_LY,
   SCSB_COD_STATO_LY2,
   SCSB_DTA_CONTROLLO_LY2,
   SCSB_DTA_PCR_LY2,
   SCSB_DTA_CR_LY2,
   SCSB_ACC_CASSA_BT_LY2,
   SCSB_UTI_CASSA_BT_LY2,
   SCSB_ACC_SMOBILIZZO_LY2,
   SCSB_UTI_SMOBILIZZO_LY2,
   SCSB_ACC_CASSA_MLT_LY2,
   SCSB_UTI_CASSA_MLT_LY2,
   SCSB_ACC_FIRMA_LY2,
   SCSB_UTI_FIRMA_LY2,
   SCSB_ACC_TOT_LY2,
   SCSB_UTI_TOT_LY2,
   SCSB_TOT_GAR_LY2,
   SCSB_ACC_SOSTITUZIONI_LY2,
   SCSB_UTI_SOSTITUZIONI_LY2,
   SCSB_ACC_MASSIMALI_LY2,
   SCSB_UTI_MASSIMALI_LY2,
   SCGB_ACC_SOSTITUZIONI_LY2,
   SCGB_UTI_SOSTITUZIONI_LY2,
   SCGB_ACC_MASSIMALI_LY2,
   SCGB_UTI_MASSIMALI_LY2,
   SCGB_ACC_CASSA_BT_LY2,
   SCGB_UTI_CASSA_BT_LY2,
   SCGB_ACC_SMOBILIZZO_LY2,
   SCGB_UTI_SMOBILIZZO_LY2,
   SCGB_ACC_CASSA_MLT_LY2,
   SCGB_UTI_CASSA_MLT_LY2,
   SCGB_ACC_FIRMA_LY2,
   SCGB_UTI_FIRMA_LY2,
   SCGB_TOT_GAR_LY2,
   SCGB_ACC_TOT_LY2,
   SCGB_UTI_TOT_LY2,
   SCSB_QIS_ACC_LY2,
   SCSB_QIS_UTI_LY2,
   SCGB_QIS_ACC_LY2,
   SCGB_QIS_UTI_LY2,
   COD_MACROSTATO
)
AS
   WITH e
        AS (SELECT s.*,
                   h.cod_macrostato,
                   DENSE_RANK ()
                   OVER (PARTITION BY s.cod_abi_cartolarizzato, s.cod_ndg
                         ORDER BY TRUNC (cod_mese_hst) DESC)
                      val_ordine
              FROM t_mcre0_app_storico_eventi s,
                   mv_mcre0_app_upd_field x,
                   t_mcre0_app_stati h
             WHERE     flg_cambio_mese = '1'
                   AND cod_mese_hst IS NOT NULL
                   AND x.cod_stato = h.cod_microstato
                   AND h.cod_macrostato IN ('IN', 'RIO', 'SC')
                   AND x.cod_sndg = s.cod_sndg)
   SELECT DISTINCT
          e.cod_abi_cartolarizzato,
          e.cod_abi_istituto,
          i.desc_istituto,
          e.cod_ndg,
          e.cod_sndg,
          MAX (DECODE (e.val_ordine, 1, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_cod_stato_at,
          MAX (
             DECODE (e.val_ordine,
                     1, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_controllo_at,
          MAX (
             DECODE (e.val_ordine, 1, TRUNC (e.gesb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_at,
          MAX (DECODE (e.val_ordine, 1, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.gesb_acc_cassa + e.gesb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.gesb_uti_cassa + e.gesb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.gegb_acc_cassa + e.gegb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_tot_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.gegb_uti_cassa + e.gegb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_tot_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.gesb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_acc_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.gesb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_uti_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.gegb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_acc_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.gegb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_uti_at,
          MAX (DECODE (e.val_ordine, 2, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_cod_stato_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_controllo_mp,
          MAX (
             DECODE (e.val_ordine, 2, TRUNC (e.gesb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_mp,
          MAX (DECODE (e.val_ordine, 2, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.gesb_acc_cassa + e.gesb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.gesb_uti_cassa + e.gesb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.gegb_acc_cassa + e.gegb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_tot_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.gegb_uti_cassa + e.gegb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_tot_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.gesb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_acc_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.gesb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_uti_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.gegb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_acc_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.gegb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_uti_mp,
          MAX (DECODE (e.val_ordine, 3, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_cod_stato_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_controllo_ly,
          MAX (
             DECODE (e.val_ordine, 3, TRUNC (e.gesb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_ly,
          MAX (DECODE (e.val_ordine, 3, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.gesb_acc_cassa + e.gesb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.gesb_uti_cassa + e.gesb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.gegb_acc_cassa + e.gegb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_tot_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.gegb_uti_cassa + e.gegb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_tot_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.gesb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_acc_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.gesb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_uti_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.gegb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_acc_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.gegb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_uti_ly,
          MAX (DECODE (e.val_ordine, 4, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_cod_stato_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_controllo_ly2,
          MAX (
             DECODE (e.val_ordine, 4, TRUNC (e.gesb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_pcr_ly2,
          MAX (DECODE (e.val_ordine, 4, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_dta_cr_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_firma_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.gesb_acc_cassa + e.gesb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_tot_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.gesb_uti_cassa + e.gesb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_tot_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_tot_gar_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_acc_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gesb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gesb_uti_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.gegb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_tot_gar_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.gegb_acc_cassa + e.gegb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_acc_tot_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.gegb_uti_cassa + e.gegb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             gegb_uti_tot_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.gesb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_acc_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.gesb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gesb_qis_uti_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.gegb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_acc_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.gegb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             gegb_qis_uti_ly2,
          MAX (DECODE (e.val_ordine, 1, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_cod_stato_at,
          MAX (
             DECODE (e.val_ordine,
                     1, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_controllo_at,
          MAX (
             DECODE (e.val_ordine, 1, TRUNC (e.scsb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_at,
          MAX (DECODE (e.val_ordine, 1, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.scsb_acc_cassa + e.scsb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.scsb_uti_cassa + e.scsb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_at,
          MAX (DECODE (e.val_ordine, 1, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.scgb_acc_cassa + e.scgb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_tot_at,
          MAX (
             DECODE (e.val_ordine,
                     1, e.scgb_uti_cassa + e.scgb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_tot_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.scsb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_acc_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.scsb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_uti_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.scgb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_acc_at,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        1, NULLIF (e.scgb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_uti_at,
          MAX (DECODE (e.val_ordine, 2, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_cod_stato_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_controllo_mp,
          MAX (
             DECODE (e.val_ordine, 2, TRUNC (e.scsb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_mp,
          MAX (DECODE (e.val_ordine, 2, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.scsb_acc_cassa + e.scsb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.scsb_uti_cassa + e.scsb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_mp,
          MAX (DECODE (e.val_ordine, 2, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.scgb_acc_cassa + e.scgb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_tot_mp,
          MAX (
             DECODE (e.val_ordine,
                     2, e.scgb_uti_cassa + e.scgb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_tot_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.scsb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_acc_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.scsb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_uti_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.scgb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_acc_mp,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        2, NULLIF (e.scgb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_uti_mp,
          MAX (DECODE (e.val_ordine, 3, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_cod_stato_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_controllo_ly,
          MAX (
             DECODE (e.val_ordine, 3, TRUNC (e.scsb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_ly,
          MAX (DECODE (e.val_ordine, 3, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.scsb_acc_cassa + e.scsb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.scsb_uti_cassa + e.scsb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_ly,
          MAX (DECODE (e.val_ordine, 3, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.scgb_acc_cassa + e.scgb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_tot_ly,
          MAX (
             DECODE (e.val_ordine,
                     3, e.scgb_uti_cassa + e.scgb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_tot_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.scsb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_acc_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.scsb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_uti_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.scgb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_acc_ly,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        3, NULLIF (e.scgb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_uti_ly,
          MAX (DECODE (e.val_ordine, 4, cod_stato, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_cod_stato_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, TO_DATE (cod_mese_hst, 'YYYYMMDD'),
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_controllo_ly2,
          MAX (
             DECODE (e.val_ordine, 4, TRUNC (e.scsb_dta_riferimento), NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_pcr_ly2,
          MAX (DECODE (e.val_ordine, 4, TRUNC (e.scgb_dta_rif_cr), NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_dta_cr_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_firma_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.scsb_acc_cassa + e.scsb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_tot_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.scsb_uti_cassa + e.scsb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_tot_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_tot_gar_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_acc_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scsb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scsb_uti_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_sostituzioni, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_sostituzioni_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_massimali, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_massimali_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_cassa_bt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_bt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_smobilizzo, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_smobilizzo_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_cassa_mlt, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_cassa_mlt_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_acc_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_uti_firma, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_firma_ly2,
          MAX (DECODE (e.val_ordine, 4, e.scgb_tot_gar, NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_tot_gar_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.scgb_acc_cassa + e.scgb_acc_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_acc_tot_ly2,
          MAX (
             DECODE (e.val_ordine,
                     4, e.scgb_uti_cassa + e.scgb_uti_firma,
                     NULL))
          OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg)
             scgb_uti_tot_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.scsb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_acc_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.scsb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scsb_qis_uti_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.scgb_qis_acc, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_acc_ly2,
          TO_NUMBER (
             MAX (
                DECODE (e.val_ordine,
                        4, NULLIF (e.scgb_qis_uti, 'N.D.'),
                        NULL))
             OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg))
             scgb_qis_uti_ly2,
          COD_MACROSTATO
     FROM e, mv_mcre0_app_istituti i
    WHERE     e.cod_abi_cartolarizzato = i.cod_abi(+)
          AND (   val_ordine IN (1, 2)
               OR SUBSTR (cod_mese_hst, 1, 6) =
                     TO_CHAR (ADD_MONTHS (SYSDATE, -12), 'YYYY') || '12'
               OR SUBSTR (cod_mese_hst, 1, 6) =
                     TO_CHAR (ADD_MONTHS (SYSDATE, -24), 'YYYY') || '12');
