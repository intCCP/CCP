/* Formatted on 21/07/2014 18:38:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_SO_GEST_INT
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   COD_PROTOCOLLO_DELIBERA,
   VAL_ORDINE_COLORE,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   COD_UO_PRATICA
)
AS
   SELECT DISTINCT
          d.cod_abi,
          d.cod_ndg,
          d.cod_sndg,
          'SO' cod_stato,
          CASE
             WHEN (SYSDATE - NVL (POS.DTA_INS, SYSDATE)) <= 2
             THEN
                'V'
             WHEN     (SYSDATE - NVL (POS.DTA_INS, SYSDATE)) <= 5
                  AND (SYSDATE - NVL (POS.DTA_INS, SYSDATE)) > 2
             THEN
                'A'
             WHEN (SYSDATE - NVL (POS.DTA_INS, SYSDATE)) > 5
             THEN
                'R'
          END
             VAL_ALERT,
          -- tb 131309 CALCOLATO A PARTIRE DALLA DATA ACCENSIONE ALERT
          NULL AS cod_protocollo_delibera,
          1 val_ordine_colore,
          1 AS val_cnt_delibere,
          1 val_cnt_rapporti,
          p.cod_uo_pratica
     FROM t_mcrei_app_delibere d,
          t_mcres_app_pratiche p,
          v_mcre0_app_upd_fields ad,
          t_mcre0_app_comparti comp,
          T_MCREI_APP_ALERT_POS_WRK PARTITION (INC_P42) POS
    WHERE     p.cod_abi = ad.cod_abi_cartolarizzato
          AND p.cod_ndg = ad.cod_ndg
          AND NVL (ad.cod_comparto_calcolato, cod_comparto_assegnato) =
                 comp.cod_comparto
          AND comp.cod_livello = 'DC'
          -- di DCP COMMENTATO PER CREARE CASI DI TEST
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND d.cod_microtipologia_delib = 'CS'
          AND d.flg_no_delibera = 0
          AND d.cod_fase_delibera = 'CO'
          AND d.flg_attiva = '1'
          AND p.flg_gestione = 'I'
          -- si selezionano solo pratiche con gestione interna
          AND p.flg_attiva = 1
          AND d.flg_attiva = 1
          --mm 0606 filtro outsourcing
          AND AD.FLG_OUTSOURCING = 'Y'
          --mm 130823
          AND ad.cod_stato = 'SO'
          AND pos.cod_abi(+) = ad.cod_abi_cartolarizzato
          AND pos.cod_ndg(+) = ad.cod_ndg;
