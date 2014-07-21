/* Formatted on 21/07/2014 18:32:44 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RAPP_DA_VA1
(
   COD_ABI,
   COD_NDG,
   COD_ABI_ISTITUTO,
   COD_COMPARTO_POSIZIONE,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_PROCESSO,
   COD_RAMO_CALCOLATO,
   COD_SNDG,
   COD_STATO,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   DTA_DECORRENZA_STATO,
   DTA_INS_ALERT,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   FLG_ABI_LAVORATO,
   VAL_ALERT
)
AS
   SELECT DISTINCT p.cod_abi,
                   p.cod_ndg,
                   --p.cod_Rapporto,
                   d.cod_abi_istituto,
                   d.cod_comparto_assegnato AS cod_comparto_posizione,
                   d.cod_gruppo_economico,
                   d.cod_macrostato,
                   d.cod_processo,
                   d.cod_ramo_calcolato,
                   d.cod_sndg,
                   d.cod_stato,
                   d.desc_istituto,
                   d.desc_nome_controparte,
                   d.dta_decorrenza_stato,
                   SYSDATE dta_ins_alert,
                   d.dta_scadenza_stato,
                   d.dta_utente_assegnato,
                   TO_CHAR (NULL) flg_abi_lavorato,
                   'R' val_alert
     FROM t_mcrei_app_pcr_rapporti p,
          t_mcre0_app_all_data PARTITION (CCP_P1) d
    WHERE     cod_classe_ft IN ('CA', 'FI')
          AND val_imp_utilizzato > 0
          AND flg_attiva = '1'
          AND EXISTS
                 (SELECT 1
                    FROM t_mcrei_app_stime PARTITION (inc_pattive) s
                   WHERE     flg_attiva = '1'
                         AND s.cod_abi = p.cod_abi
                         AND s.cod_ndg = p.cod_ndg)
          AND NOT EXISTS
                     (SELECT cod_rapporto
                        FROM t_mcrei_app_stime PARTITION (inc_pattive) s
                       WHERE     flg_attiva = '1'
                             AND s.cod_abi = p.cod_abi
                             AND S.cod_ndg = p.cod_ndg
                             AND s.cod_rapporto = p.cod_rapporto)
          AND p.cod_abi = d.cod_abi_cartolarizzato
          AND p.cod_ndg = d.cod_ndg
          AND d.today_flg = 1
          AND p.flg_attiva = '1'
          AND d.cod_stato IN ('IN', 'RS');
