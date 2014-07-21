/* Formatted on 17/06/2014 18:17:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_ALERT_SO_GEST_INT
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
   SELECT DISTINCT d.cod_abi,
                   d.cod_ndg,
                   d.cod_sndg,
                   'SO' cod_stato,
                   'V' val_alert,
                   -- ¿ DA CALCOLARE A PARTIRE DALLA DATA ACCENSIONE ALERT
                   NULL AS cod_protocollo_delibera,
                   1 val_ordine_colore,
                   1 AS val_cnt_delibere,
                   1 val_cnt_rapporti,
                   p.cod_uo_pratica
     FROM t_mcrei_app_delibere d,
          t_mcres_app_pratiche p,
          vtmcre0_app_upd_fields ad,
          t_mcre0_app_comparti comp
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
          AND d.flg_attiva = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_ALERT_SO_GEST_INT TO MCRE_USR;
