/* Formatted on 21/07/2014 18:30:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.EMI_MCRE_APP_ALERT_RAPP_DA_VAL
(
   COD_SNDG,
   COD_ABI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_STR_ORG_SUP_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STR_ORG_SUP_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   NUMERI_RAPPORTI,
   COD_FILIALE,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   DTA_INTERCETTAMENTO,
   COD_GESTORE_MKT,
   SEMAFORO
)
AS
   SELECT pp.cod_sndg,
          pp.cod_abi,
          pp.cod_ndg,
          pp.desc_nome_controparte,
          pp.cod_gruppo_economico,
          pp.cod_stato,
          pp.dta_decorrenza_stato,
          COD_STR_ORG_SUP_AR,
          DESC_STRUTTURA_COMPETENTE_AR,
          COD_STR_ORG_SUP_RG,
          DESC_STRUTTURA_COMPETENTE_RG,
          numeri_rapporti,
          pp.cod_filiale,
          O.desc_struttura_competente_fi,
          pp.cod_processo,
          DTA_INTERCETTAMENTO,
          COD_GESTORE_MKT,
          'R' semaforo
     FROM (SELECT DISTINCT
                  p.cod_sndg,
                  p.cod_abi,
                  p.cod_ndg,
                  d.desc_nome_controparte,
                  d.cod_gruppo_economico,
                  d.cod_filiale,
                  d.cod_processo,
                  d.cod_stato,
                  d.dta_decorrenza_stato,
                  DTA_INTERCETTAMENTO,
                  COD_GESTORE_MKT,
                  COUNT (p.cod_rapporto)
                     OVER (PARTITION BY p.cod_abi, p.cod_ndg)
                     numeri_rapporti
             FROM t_mcrei_app_pcr_rapporti p,
                  t_mcrei_app_stime s,
                  t_mcre0_app_all_data d
            WHERE     p.FLG_ATTIVA = 1
                  AND p.cod_abi = s.cod_abi(+)
                  AND p.cod_ndg = s.cod_ndg(+)
                  AND p.cod_rapporto = s.cod_rapporto(+)
                  AND p.cod_abi = d.cod_abi_cartolarizzato
                  AND p.cod_ndg = d.cod_ndg
                  AND s.cod_abi IS NULL) pp,
          v_mcre0_denorm_str_org O
    WHERE     O.COD_ABI_ISTITUTO_FI(+) = pp.COD_ABI
          AND O.COD_STRUTTURA_COMPETENTE_FI(+) = pp.COD_FILIALE;
