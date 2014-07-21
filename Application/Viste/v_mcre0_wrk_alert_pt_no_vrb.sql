/* Formatted on 21/07/2014 18:38:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_PT_NO_VRB
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   DTA_INS,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT DISTINCT
          a.cod_abi_cartolarizzato AS COD_ABI,
          a.COD_NDG,
          a.COD_SNDG,
          a.COD_STATO,
          CASE
             WHEN (SYSDATE - t.DTA_CLASSIFICAZIONE) < 30
             THEN
                'V'
             WHEN (SYSDATE - t.DTA_CLASSIFICAZIONE) BETWEEN 30 AND 59
             THEN
                'G'
             WHEN (SYSDATE - t.DTA_CLASSIFICAZIONE) >= 60
             THEN
                'R'
          END
             VAL_ALERT,
          1 AS VAL_CNT_DELIBERE,
          1 AS VAL_CNT_RAPPORTI,
          t.DTA_CLASSIFICAZIONE AS DTA_INS,
          NULL AS COD_PROTOCOLLO_DELIBERA
     FROM t_mcre0_app_all_data a, t_mcre0_app_pt_gestione_tavoli t
    WHERE     a.cod_abi_cartolarizzato = t.cod_abi_cartolarizzato
          AND a.cod_percorso = t.cod_percorso
          AND a.cod_ndg = t.cod_ndg
          AND t.flg_allegato = 0;
