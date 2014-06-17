/* Formatted on 17/06/2014 18:17:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_ALERT_PRIV_RV
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
                'G'
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
             FROM t_mcrei_app_delibere PARTITION (inc_pattive) d1
            WHERE     (d1.cod_abi, d1.cod_ndg) NOT IN           -- PRIVE DI RV
                         (SELECT DISTINCT cod_abi, cod_ndg
                            FROM t_mcrei_app_delibere d
                           WHERE     d.cod_microtipologia_delib IN
                                        ('A0', 'T4', 'RV', 'IM')
                                 AND flg_no_delibera = 0
                                 AND cod_fase_delibera NOT IN
                                        ('AN', 'AM', 'VA')
                                 --13dic
                                 AND cod_fase_pacchetto NOT IN ('ANM', 'ANA')
                                 --13dic
                                 AND flg_attiva = '1')
                  AND d1.flg_attiva = '1'
                  AND d1.cod_microtipologia_delib = 'CI'
                  AND d1.flg_no_delibera = 0
                  AND d1.cod_fase_delibera NOT IN ('AN', 'AM', 'VA')   --13dic
                  AND d1.cod_fase_pacchetto NOT IN ('ANM', 'ANA')      --13dic
                  AND d1.desc_tipo_gestione IN ('B', 'E')) pos,
          vtmcre0_app_upd_fields ad
    WHERE     pos.cod_abi = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg = ad.cod_ndg
          AND ad.cod_stato IN ('IN', 'RS')
          AND ad.flg_outsourcing = 'Y'
          AND ad.flg_target = 'Y'
          AND ad.id_utente != -1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_ALERT_PRIV_RV TO MCRE_USR;
