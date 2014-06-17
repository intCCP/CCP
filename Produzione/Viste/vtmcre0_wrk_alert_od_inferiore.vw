/* Formatted on 17/06/2014 18:17:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_WRK_ALERT_OD_INFERIORE
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
     SELECT DISTINCT
            d.cod_abi,
            d.cod_ndg,
            d.cod_sndg,
            a.cod_stato,
            'R' val_alert,
            3 val_ordine_colore,
            COUNT (DISTINCT cod_protocollo_delibera) AS val_cnt_delibere,
            1 val_cnt_rapporti,
            NULL cod_protocollo_delibera
       FROM t_mcrei_app_delibere d,
            t_mcre0_app_all_data_DAY a,
            t_mcre0_cl_org_delib cal,
            t_mcre0_cl_org_delib del
      WHERE     d.cod_abi = a.cod_abi_cartolarizzato
            AND d.cod_ndg = a.cod_ndg
            AND a.today_flg = '1'
            AND d.cod_fase_delibera = 'CO'
            AND d.cod_microtipologia_delib NOT IN ('CI', 'CS')
            AND d.cod_abi = cal.cod_abi(+)
            AND d.cod_organo_calcolato = cal.cod_organo_deliberante(+)
            AND d.cod_abi = del.cod_abi(+)
            AND d.cod_organo_deliberante = del.cod_organo_deliberante(+)
            AND del.val_progr_organo_deliberante <
                   cal.val_progr_organo_deliberante ---od inferiore a quello calcolato
            AND d.cod_tipo_pacchetto = 'M'
            AND d.flg_no_delibera = 0
            AND d.flg_attiva = '1'
   GROUP BY d.cod_abi,
            d.cod_ndg,
            d.cod_sndg,
            a.cod_stato;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_WRK_ALERT_OD_INFERIORE TO MCRE_USR;
