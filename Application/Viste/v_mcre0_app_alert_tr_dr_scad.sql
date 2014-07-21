/* Formatted on 21/07/2014 18:33:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_TR_DR_SCAD
(
   VAL_ALERT,
   COD_STRUTTURA_COMPETENTE,
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STATO,
   COD_PROCESSO,
   DTA_DECORRENZA_STATO,
   COD_MICROTIPOLOGIA_DELIB,
   VAL_RINUNCIA_TOTALE,
   DTA_SCADENZA_TRANSAZ
)
AS
   SELECT /*+ index(B pkt_mcre0_app_all_data)  index(d IAM_T_MCREI_APP_DELIBERE) */
         CASE
             WHEN SYSDATE - d.dta_scadenza_transaz <= 0
             THEN
                'V'
             WHEN     SYSDATE - d.dta_scadenza_transaz <= 30
                  AND SYSDATE - d.dta_scadenza_transaz > 0
             THEN
                'A'
             WHEN SYSDATE - d.dta_scadenza_transaz > 30
             THEN
                'R'
          END
             val_alert,
          b.cod_struttura_competente,
          d.cod_sndg,
          d.cod_abi,
          d.cod_ndg,
          b.desc_nome_controparte,
          b.cod_gruppo_economico,
          b.desc_gruppo_economico,
          org.cod_struttura_competente_ar,
          org.desc_struttura_competente_ar,
          org.cod_struttura_competente_fi,
          org.desc_struttura_competente_fi,
          org.cod_struttura_competente_rg,
          org.desc_struttura_competente_rg,
          org.cod_struttura_competente_dc,
          org.desc_struttura_competente_dc,
          b.cod_stato,
          b.cod_processo,
          b.dta_decorrenza_stato,
          d.cod_microtipologia_delib,
          d.val_rinuncia_totale,
          d.dta_scadenza_transaz
     FROM t_mcrei_app_delibere PARTITION (inc_pattive) d,
          t_mcre0_app_all_data b,
          v_mcre0_denorm_str_org org
    WHERE     b.today_flg = 1
          AND b.cod_abi_cartolarizzato = d.cod_abi
          AND b.cod_ndg = d.cod_ndg
          AND b.cod_stato IN ('IN', 'RS')
          AND d.cod_fase_delibera = 'CO'
          AND d.cod_macrotipologia_delib IN ('DR', 'TP')
          AND d.cod_abi = org.cod_abi_istituto_fi(+)
          AND d.cod_filiale_delibera = cod_struttura_competente_fi(+);
