/* Formatted on 17/06/2014 18:06:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_AL_DELIB_DACONF_BR
(
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   VAL_ALERT,
   COD_STATO,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT cod_sndg,
          cod_abi,
          cod_ndg,
          val_alert,
          cod_stato,
          val_num_delib val_cnt_delibere,
          1 val_cnt_rapporti,
          cod_protocollo_delibera
     FROM (SELECT /*+ index(a pkt_mcre0_app_all_data) index(d IAM_T_MCREI_APP_DELIBERE) */
                 DISTINCT
                  d.cod_sndg AS cod_sndg,
                  d.cod_abi AS cod_abi,
                  d.cod_ndg AS cod_ndg,
                  CASE
                     WHEN (TRUNC (SYSDATE) - TRUNC (dta_conferma_pacchetto)) <=
                             30
                     THEN
                        'A'
                     ELSE
                        'R'
                  END
                     AS val_alert,
                  a.cod_stato AS cod_stato,
                  COUNT (d.cod_ndg) OVER (PARTITION BY d.cod_abi, d.cod_ndg)
                     AS val_num_delib,
                  d.cod_protocollo_delibera,
                  RANK ()
                  OVER (PARTITION BY d.cod_abi, d.cod_ndg
                        ORDER BY val_num_progr_delibera ASC)
                     AS rn
             FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
                  v_mcre0_app_upd_fields a
            WHERE     d.cod_fase_pacchetto = 'CNF'
                  AND d.cod_fase_microtipologia = 'ATT'
                  AND cod_fase_Delibera NOT IN ('CA', 'CO')
                  AND d.cod_abi = a.cod_abi_cartolarizzato
                  AND d.cod_ndg = a.cod_ndg
                  AND d.flg_no_delibera = 0
                  AND d.flg_attiva = '1'
                  --AND a.cod_stato IN ('IN', 'RS')
                  AND a.flg_outsourcing = 'Y'
                  AND a.flg_target = 'Y')
    WHERE rn = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_WRK_AL_DELIB_DACONF_BR TO MCRE_USR;
