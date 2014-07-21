/* Formatted on 21/07/2014 18:38:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_PRIV_RV
(
   VAL_ALERT,
   COD_STRUTTURA_COMPETENTE,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   COD_NOME_CLIENTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_PROCESSO,
   COD_STATO,
   MACROSTATO,
   DTA_DECORRENZA_STATO_ATTUALE,
   COD_PROTOCOLLO_DELIBERA,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI
)
AS
   SELECT CASE
             WHEN (SYSDATE - ad.dta_decorrenza_stato) < 30
             THEN
                'V'
             WHEN     (SYSDATE - ad.dta_decorrenza_stato) >= 30
                  AND (SYSDATE - ad.dta_decorrenza_stato) < 45
             THEN
                'A'
             WHEN (SYSDATE - ad.dta_decorrenza_stato) >= 45
             THEN
                'R'
          END
             AS val_alert,
          ad.cod_struttura_competente,
          ad.cod_sndg,
          ad.cod_abi_cartolarizzato AS cod_abi,
          ad.cod_ndg,
          ad.desc_nome_controparte AS cod_nome_cliente,
          ad.cod_gruppo_economico AS cod_gruppo_economico,
          ad.desc_gruppo_economico AS desc_gruppo_economico,
          ad.cod_processo,
          ad.cod_stato AS cod_stato,
          ad.cod_macrostato AS macrostato,
          ad.dta_decorrenza_stato AS dta_decorrenza_stato_attuale,
          NULL cod_protocollo_delibera,
          1 val_cnt_delibere,
          1 val_cnt_rapporti
     FROM (SELECT DISTINCT d1.cod_abi, d1.cod_ndg
             FROM t_mcrei_app_delibere PARTITION (inc_pattive) d1,
                  t_mcrei_app_pratiche PARTITION (inc_pattive) p      --MM0603
            WHERE     (d1.cod_abi, d1.cod_ndg) NOT IN           -- PRIVE DI RV
                         (SELECT DISTINCT cod_abi, cod_ndg
                            FROM t_mcrei_app_delibere d
                           WHERE     d.cod_microtipologia_delib IN
                                        ('A0', 'T4', 'RV', 'IM')
                                 AND flg_no_delibera = 0
                                 --AND cod_fase_delibera IN ('CA')
                                 AND (   cod_fase_delibera = 'CO'
                                      OR NVL (flg_conferma_host, 'N') = 'Y') --MM130808
                                 --13dic
                                 AND cod_fase_pacchetto NOT IN ('ANM', 'ANA')
                                 --13dic
                                 AND flg_attiva = '1')
                  AND d1.flg_attiva = '1'
                  AND d1.cod_microtipologia_delib = 'CI'
                  AND d1.flg_no_delibera = 0
                  AND d1.cod_fase_delibera NOT IN ('AN', 'AM', 'VA')   --13dic
                  AND d1.cod_fase_pacchetto NOT IN ('ANM', 'ANA')      --13dic
                  AND d1.cod_abi = p.cod_abi                          --MM0603
                  AND d1.cod_ndg = p.cod_ndg                          --MM0603
                  AND d1.cod_pratica = p.cod_pratica                  --MM0603
                  AND d1.val_anno_pratica = p.val_anno_pratica        --MM0603
                  AND p.cod_tipo_gestione IN ('B', 'E')) pos,
          v_mcre0_app_upd_fields ad
    WHERE     pos.cod_abi = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg = ad.cod_ndg
          AND ad.cod_stato IN ('IN', 'RS')
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y';
