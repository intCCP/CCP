/* Formatted on 21/07/2014 18:38:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WRK_ALERT_NUOVE_SOFF
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
   SELECT ad.cod_abi_cartolarizzato cod_abi,
          ad.cod_ndg,
          ad.cod_sndg,
          ad.cod_stato,
          'V' val_alert,
          1 val_ordine_colore,
          1 val_cnt_delibere,
          1 val_cnt_rapporti,
          NULL cod_protocollo_delibera
     FROM v_mcre0_app_upd_fields ad, t_mcres_app_notizie n
    WHERE     cod_stato = 'SO'
          AND today_flg = '1'
          AND id_utente != '-1'
          AND flg_outsourcing = 'Y'
          AND TRUNC (dta_decorrenza_stato) >= TRUNC (SYSDATE) - 2
          AND ad.cod_abi_cartolarizzato = n.cod_abi(+)
          AND ad.cod_ndg = n.cod_ndg(+)
          AND COD_TIPO_NOTIZIA(+) != '50'
          AND DTA_FINE_VALIDITA(+) = TO_DATE ('12/31/9999', 'MM/DD/YYYY');
