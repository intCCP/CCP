/* Formatted on 17/06/2014 18:17:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_ALERT_INR_PI2
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   DTA_INS_ALERT,
   VAL_ALERT,
   VAL_CNT_RAPPORTI,
   VAL_CNT_DELIBERE,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT cod_abi,
          cod_ndg,
          cod_sndg,
          cod_stato,
          SYSDATE dta_ins_alert,
          CASE
             WHEN TRUNC (SYSDATE) - dta_scadenza_transaz <= 30
             THEN
                'V'
             WHEN     TRUNC (SYSDATE) - dta_scadenza_transaz <= 60
                  AND TRUNC (SYSDATE) - dta_scadenza_transaz > 30
             THEN
                'A'
             WHEN TRUNC (SYSDATE) - dta_scadenza_transaz > 60
             THEN
                'R'
          END
             AS val_alert,
          NULL AS val_cnt_rapporti,
          NULL AS val_cnt_delibere,
          cod_protocollo_delibera
     FROM (                                      --V_MCRE0_WRK_RAPP_DA_VAL_POS
           -- V_MCRE0_WRK_ALERT_INRI_P_DAINS
           SELECT (SELECT de.cod_protocollo_delibera
                     FROM t_mcrei_app_delibere PARTITION (inc_pattive) de
                    WHERE     de.cod_abi = uf.cod_abi_cartolarizzato
                          AND de.cod_ndg = uf.cod_ndg
                          AND de.cod_tipo_pacchetto = 'M'
                          AND de.dta_scadenza_transaz <= SYSDATE
                          AND de.flg_no_delibera = 0
                          AND de.flg_attiva = '1'
                          AND de.cod_fase_delibera = 'CO')
                     cod_protocollo_delibera,
                  (SELECT MIN (de.dta_scadenza_transaz)
                             OVER (PARTITION BY de.cod_abi, de.cod_ndg)
                     FROM t_mcrei_app_delibere PARTITION (inc_pattive) de
                    WHERE     de.cod_abi = uf.cod_abi_cartolarizzato
                          AND de.cod_ndg = uf.cod_ndg
                          AND de.cod_tipo_pacchetto = 'M'
                          AND de.dta_scadenza_transaz <= SYSDATE
                          AND de.flg_no_delibera = 0
                          AND de.flg_attiva = '1'
                          AND de.cod_fase_delibera = 'CO')
                     dta_scadenza_transaz,
                  (SELECT RANK ()
                          OVER (PARTITION BY de.cod_abi, de.cod_ndg
                                ORDER BY de.dta_conferma_delibera DESC)
                             AS rn
                     FROM t_mcrei_app_delibere PARTITION (inc_pattive) de
                    WHERE     de.cod_abi = uf.cod_abi_cartolarizzato
                          AND de.cod_ndg = uf.cod_ndg
                          AND de.cod_tipo_pacchetto = 'M'
                          AND de.dta_scadenza_transaz <= SYSDATE
                          AND de.flg_no_delibera = 0
                          AND de.flg_attiva = '1'
                          AND de.cod_fase_delibera = 'CO')
                     rn,
                  uf.cod_abi_cartolarizzato cod_abi,
                  uf.cod_ndg,
                  uf.cod_sndg,
                  uf.cod_stato
             FROM vtmcre0_app_upd_fields_p1 uf
            WHERE     uf.cod_stato IN ('IN', 'RS')
                  AND uf.flg_outsourcing = 'Y'
                  AND uf.flg_target = 'Y'
                  AND uf.today_flg = '1')
    WHERE cod_protocollo_delibera IS NOT NULL AND rn = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_ALERT_INR_PI2 TO MCRE_USR;
