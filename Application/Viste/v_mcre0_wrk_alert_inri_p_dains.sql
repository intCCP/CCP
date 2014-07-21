/* Formatted on 21/07/2014 18:38:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_INRI_P_DAINS
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
          dta_ins_alert,
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
     FROM (SELECT d.cod_abi_cartolarizzato AS cod_abi,
                  d.cod_ndg AS cod_ndg,
                  d.cod_sndg AS cod_sndg,
                  d.cod_stato AS cod_stato,
                  SYSDATE AS dta_ins_alert,
                  de.cod_protocollo_delibera,
                  MIN (dta_scadenza_transaz)
                     OVER (PARTITION BY de.cod_abi, de.cod_ndg)
                     AS dta_scadenza_transaz,
                  RANK ()
                  OVER (PARTITION BY de.cod_abi, de.cod_ndg
                        ORDER BY de.dta_conferma_delibera DESC)
                     AS rn
             FROM t_mcre0_app_all_data PARTITION (ccp_p1) d,
                  t_mcrei_app_delibere PARTITION (inc_pattive) de,
                  v_mcre0_denorm_str_org o,
                  t_mcre0_app_utenti u
            WHERE     de.cod_abi = d.cod_abi_cartolarizzato
                  AND de.cod_ndg = d.cod_ndg
                  AND de.cod_tipo_pacchetto = 'M'
                  AND de.flg_no_delibera = 0
                  AND de.flg_attiva = '1'
                  AND de.cod_fase_delibera = 'CO'
                  AND de.dta_scadenza_transaz <= SYSDATE
                  AND o.cod_abi_istituto_fi(+) = d.cod_abi_cartolarizzato
                  AND o.cod_struttura_competente_fi(+) = d.cod_filiale
                  AND d.id_utente = u.id_utente(+)
                  AND d.cod_stato IN ('IN', 'RS')
                  AND d.flg_outsourcing = 'Y'
                  AND d.flg_target = 'Y')
    WHERE rn = 1;
