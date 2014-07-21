/* Formatted on 21/07/2014 18:38:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_PAC_NO_ALL
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   VAL_ALERT,
   COD_STATO,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT d.cod_abi,
          d.cod_ndg,
          d.cod_sndg,
          CASE
             WHEN TRUNC (SYSDATE) - TRUNC (dta_conferma_pacchetto) < 30
             THEN
                'V'
             WHEN     TRUNC (SYSDATE) - TRUNC (dta_conferma_pacchetto) >= 30
                  AND TRUNC (SYSDATE) - TRUNC (dta_conferma_pacchetto) < 60
             THEN
                'A'
             WHEN TRUNC (SYSDATE) - TRUNC (dta_conferma_pacchetto) > 60
             THEN
                'R'
          END
             AS val_alert,
          upd.cod_stato,
          d.cod_protocollo_delibera
     FROM t_mcrei_app_delibere d, v_mcre0_app_upd_fields upd
    WHERE     d.cod_abi = upd.cod_abi_cartolarizzato
          AND d.cod_ndg = upd.cod_ndg
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'
          AND d.cod_fase_pacchetto = 'CNF'
          AND upd.cod_stato IN ('IN', 'RS')
          AND upd.flg_outsourcing = 'Y'
          AND upd.flg_target = 'Y'
          --and d.COD_DOC_DELIBERA_BANCA is null
          AND d.cod_doc_parere_conformita IS NULL
          --and d.COD_DOC_APPENDICE_PARERE is null
          AND d.cod_doc_delibera_capogruppo IS NULL
--and d.COD_DOC_CLASSIFICAZIONE is null;
;
