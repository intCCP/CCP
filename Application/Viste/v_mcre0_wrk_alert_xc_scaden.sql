/* Formatted on 21/07/2014 18:38:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_XC_SCADEN
(
   COD_ABI,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI
)
AS
   SELECT d.cod_abi_cartolarizzato AS cod_abi,
          d.cod_abi_istituto,
          d.cod_ndg,
          d.cod_sndg,
          d.cod_stato,
          CASE
             WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 30
                  AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 15
             THEN
                'V'
             WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 15
                  AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 5
             THEN
                'A'
             WHEN d.dta_scadenza_stato - TRUNC (SYSDATE) < 5
             THEN
                'R'
          END
             val_alert,
          CASE
             WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 30
                  AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 15
             THEN
                1
             WHEN     d.dta_scadenza_stato - TRUNC (SYSDATE) < 15
                  AND d.dta_scadenza_stato - TRUNC (SYSDATE) >= 5
             THEN
                3
             WHEN d.dta_scadenza_stato - TRUNC (SYSDATE) < 5
             THEN
                6
          END
             val_ordine_colore,
          NULL cod_protocollo_delibera,
          1 val_cnt_delibere,
          1 val_cnt_rapporti
     FROM v_mcre0_app_upd_fields d
    WHERE     d.cod_stato = 'XC'                        --0320 solo XC, non XS
          AND d.flg_outsourcing = 'Y'
          AND d.flg_target = 'Y'
          AND d.dta_scadenza_stato - TRUNC (SYSDATE) < 30;
