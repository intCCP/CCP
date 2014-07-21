/* Formatted on 21/07/2014 18:33:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_CR
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_FINE_MESE,
   COD_STATO_SIS,
   VAL_ORDINE,
   COD_STATO_SIS_PREV,
   DTA_FINE_MESE_MAX,
   VAL_ORDINE_MAX,
   VAL_ORDINE_MIN,
   VAL_ORDINE_MIN_NULL
)
AS
   SELECT cod_abi_cartolarizzato,
          cod_ndg,
          dta_fine_mese,
          cod_stato_sis,
          val_ordine,
          LAG (
             cod_stato_sis)
          OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg
                ORDER BY dta_fine_mese)
             cod_stato_sis_prev,
          MAX (dta_fine_mese)
             OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
             dta_fine_mese_max,
          MAX (val_ordine)
             OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
             val_ordine_max,
          MIN (val_ordine)
             OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
             val_ordine_min,
          MIN (NVL (val_ordine, -1))
             OVER (PARTITION BY cod_abi_cartolarizzato, cod_ndg)
             val_ordine_min_null
     FROM (SELECT e.cod_abi_cartolarizzato,
                  e.cod_ndg,
                  e.scgb_cod_stato_sis cod_stato_sis,
                  TO_DATE (e.cod_mese_hst, 'YYYYMMDD') dta_fine_mese,
                  DENSE_RANK ()
                  OVER (PARTITION BY e.cod_abi_cartolarizzato, e.cod_ndg
                        ORDER BY TO_DATE (e.cod_mese_hst, 'YYYYMMDD') DESC)
                     val_ordine
             FROM t_mcre0_app_storico_eventi e
            WHERE     e.flg_cambio_mese = 1
                  AND e.cod_mese_hst IS NOT NULL
                  AND e.cod_mese_hst >=
                         TO_NUMBER (
                            TO_CHAR (ADD_MONTHS (SYSDATE, -24), 'YYYYMMDD'))
                  AND e.cod_mese_hst <
                         (SELECT TO_NUMBER (
                                    TO_CHAR (MAX (c.scgb_dta_rif_cr),
                                             'YYYYMMDD'))
                            FROM t_mcre0_app_cr c
                           WHERE     c.cod_abi_cartolarizzato =
                                        e.cod_abi_cartolarizzato
                                 AND c.cod_ndg = e.cod_ndg)
           UNION
           SELECT e.cod_abi_cartolarizzato,
                  e.cod_ndg,
                  e.scgb_cod_stato_sis cod_stato_sis,
                  e.scgb_dta_rif_cr dta_fine_mese,
                  NULL val_ordine
             FROM t_mcre0_app_cr e
            WHERE e.scgb_dta_rif_cr >= ADD_MONTHS (SYSDATE, -25));
