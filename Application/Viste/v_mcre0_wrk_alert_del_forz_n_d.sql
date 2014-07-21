/* Formatted on 21/07/2014 18:38:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_DEL_FORZ_N_D
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   VAL_ALERT,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT d1.cod_abi,
          d1.cod_ndg,
          d1.cod_sndg,
          CASE
             WHEN TRUNC (SYSDATE) - TRUNC (d1.dta_conferma_pacchetto) < 30
             THEN
                'V'
             WHEN     TRUNC (SYSDATE) - TRUNC (d1.dta_conferma_pacchetto) >=
                         30
                  AND TRUNC (SYSDATE) - TRUNC (d1.dta_conferma_pacchetto) <
                         60
             THEN
                'A'
             WHEN TRUNC (SYSDATE) - TRUNC (d1.dta_conferma_pacchetto) >= 60
             THEN
                'R'
          END
             AS val_alert,
          d1.cod_stato,
          d1.cod_protocollo_delibera
     FROM (SELECT d.cod_abi,
                  d.cod_ndg,
                  d.cod_sndg,
                  d.cod_protocollo_delibera,
                  ad.cod_stato,
                  d.dta_conferma_pacchetto,
                  RANK ()
                     OVER (PARTITION BY d.cod_abi, d.cod_ndg
                           ORDER BY
                              d.dta_conferma_delibera DESC,
                              d.dta_last_upd_delibera DESC,
                              d.val_anno_proposta DESC,
                              d.val_num_progr_delibera DESC)
                     AS rnk_proto
             FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
                  v_mcre0_app_upd_fields ad
            WHERE     d.cod_abi = ad.cod_abi_cartolarizzato
                  AND d.cod_ndg = ad.cod_ndg
                  AND d.flg_no_delibera = 0
                  AND d.flg_attiva = '1'
                  --non necessariamente solo CNF
                  --AND d.cod_fase_pacchetto = 'CNF'
                  AND d.cod_fase_delibera IN
                         ('CO', 'AD', 'CT', 'NA', 'RI', 'NR')
                  AND d.flg_delib_forzata = '1'
                  AND ad.flg_outsourcing = 'Y'
                  AND ad.flg_target = 'Y'
                  AND d.cod_doc_delibera_banca IS NULL) d1
    WHERE rnk_proto = 1;
