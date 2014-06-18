/* Formatted on 17/06/2014 18:17:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_AL_DEL_NON_CONFORM
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_STATO,
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   VAL_CNT_DELIBERE,
   VAL_CNT_RAPPORTI,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT d.cod_abi,
          d.cod_ndg,
          d.cod_sndg,
          a.cod_stato,
          'R' val_alert,
          3 val_ordine_colore,
          1 AS val_cnt_delibere,
          1 val_cnt_rapporti,
          d.cod_protocollo_delibera
     FROM t_mcrei_app_delibere d, t_mcre0_app_all_data_day a
    WHERE     d.cod_abi = a.cod_abi_cartolarizzato
          AND d.cod_ndg = a.cod_ndg
          AND a.today_flg = '1'
          AND d.cod_abi != '01025'                          --solo banche rete
          AND d.cod_microtipologia_delib IN ('RV', 'A0', 'T4', 'IM') --solo rettifiche
          AND d.cod_fase_delibera = 'CO'
          AND d.flg_no_delibera = 0
          AND d.flg_attiva = '1'                                       --17/10
          AND d.flg_delib_in_linea = '0'                --attendiamo conferme!
          AND NVL (d.val_rdv_delib_banca_rete, 0) != val_rdv_qc_progressiva
          AND d.cod_tipo_pacchetto = 'M';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_AL_DEL_NON_CONFORM TO MCRE_USR;
