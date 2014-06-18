/* Formatted on 17/06/2014 18:17:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_ALERT_DEL_DA_CONF
(
   VAL_ALERT,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   COD_STATO,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT       -- 10/10/2012 aggiunta nvl(dta_ins_delibera, dta_upd_delibera)
         DISTINCT
          CASE
             WHEN   TRUNC (SYSDATE)
                  - TRUNC (NVL (d.dta_ins_delibera, d.dta_upd_fase_delibera)) <
                     3
             THEN
                'V'
             WHEN       TRUNC (SYSDATE)
                      - TRUNC (
                           NVL (d.dta_ins_delibera, d.dta_upd_fase_delibera)) <
                         5
                  AND   TRUNC (SYSDATE)
                      - TRUNC (
                           NVL (d.dta_ins_delibera, d.dta_upd_fase_delibera)) >=
                         3
             THEN
                'A'
             WHEN   TRUNC (SYSDATE)
                  - TRUNC (NVL (d.dta_ins_delibera, d.dta_upd_fase_delibera)) >=
                     5
             THEN
                'R'
          END
             AS val_alert,
          ad.cod_sndg,
          d.cod_abi AS cod_abi,
          d.cod_ndg,
          ad.cod_stato,
          COUNT (d.cod_ndg) OVER (PARTITION BY d.cod_abi, d.cod_ndg)
             AS val_cnt_delibere,
          1 val_cnt_rapporti,
          NULL cod_protocollo_delibera
     FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
          vtmcre0_app_upd_fields ad,
          t_mcrei_cl_tipologie tip
    WHERE     d.cod_abi = ad.cod_abi_cartolarizzato
          AND d.cod_ndg = ad.cod_ndg
          AND d.cod_fase_delibera NOT IN ('CO', 'AD', 'AN', 'AM', 'VA') --in, cm --13dic
          AND d.cod_microtipologia_delib NOT IN ('CI', 'CS')
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'
          AND d.cod_fase_pacchetto NOT IN ('CNF', 'ULT', 'ANA', 'ANM') --13dic
          AND d.cod_microtipologia_delib = tip.cod_microtipologia
          AND ad.cod_stato IN ('IN', 'RS')
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_ALERT_DEL_DA_CONF TO MCRE_USR;
