/* Formatted on 21/07/2014 18:38:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_NUOVE_SOFFX
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT d.cod_abi,
          d.cod_ndg,
          d.cod_sndg,
          'SO' cod_stato,
          'V' val_alert,
          1 val_ordine_colore,
          1 val_cnt_delibere,
          1 val_cnt_rapporti,
          d.cod_protocollo_delibera
     FROM t_mcrei_app_delibere d,
          t_mcres_app_pratiche a,
          v_mcre0_app_upd_fields ad
    WHERE     d.cod_abi = a.cod_abi
          AND d.cod_ndg = a.cod_ndg
          AND d.cod_abi = ad.cod_abi_cartolarizzato
          AND d.cod_ndg = ad.cod_ndg
          AND d.cod_microtipologia_delib = 'CS'
          AND d.cod_fase_delibera = 'CO'
          AND d.flg_attiva = '1'
          AND d.flg_no_delibera = 0
          AND a.flg_attiva = 1
          AND a.flg_gestione = 'E'
          --     AND AD.FLG_TARGET = 'Y'
          --     AND AD.FLG_OUTSOURCING = 'Y'
          AND TRUNC (d.dta_conferma_delibera) >= TRUNC (SYSDATE) - 2;
