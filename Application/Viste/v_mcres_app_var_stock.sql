/* Formatted on 21/07/2014 18:43:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_VAR_STOCK
(
   COD_ABI,
   DESC_ISTITUTO,
   VAL_ANNOMESE,
   FLG_GRUPPO,
   VAL_VAR_AUMENTO,
   VAL_VAR_DIMINUZIONE,
   VAL_INCASSI,
   VAL_GBV_INIZIALE,
   VAL_GBV_FINALE,
   VAL_TMR
)
AS
   SELECT                                                      --AG 16/11/2011
         t.cod_abi,
          i.desc_istituto,
          SUBSTR (t.id_dper, 1, 6) val_annomese,
          t.flg_gruppo,
          t.val_var_aumento,
          t.val_var_diminuzione,
          t.val_incassi,
          t.val_gbv_iniziale,
          t.val_gbv_finale,
          t.val_TMR
     FROM (SELECT a.cod_abi,
                  a.id_dper,
                  'M' flg_gruppo,
                  a.val_var_aumento,
                  a.val_var_diminuzione,
                  a.val_incassi,
                  b.val_gbv val_gbv_iniziale,
                  a.val_gbv val_gbv_finale,
                  c.num_mesi,
                  c.val_gbv_medio,
                  ( (a.val_incassi / c.val_gbv_medio) / 1) * 12 val_TMR
             FROM t_mcres_fen_var_stock a,
                  t_mcres_fen_var_stock b,
                  (  SELECT l.cod_abi,
                            l.id_dper,
                            COUNT (m.val_gbv) num_mesi,
                            AVG (m.val_gbv) val_gbv_medio
                       FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                      WHERE     1 = 1
                            AND l.cod_abi = m.cod_abi
                            AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                              AND l.dta_rif
                   GROUP BY l.cod_abi, l.id_dper) c
            WHERE     1 = 1
                  AND a.cod_abi = b.cod_abi(+)
                  AND b.dta_rif(+) = ADD_MONTHS (a.dta_rif, -1)
                  AND a.cod_abi = c.cod_abi(+)
                  AND a.id_dper = c.id_dper
           UNION ALL
             SELECT a.cod_abi,
                    a.id_dper,
                    'A' flg_gruppo,
                    SUM (b.val_var_aumento) val_var_aumento,
                    SUM (b.val_var_diminuzione) val_var_diminuzione,
                    SUM (b.val_incassi) val_incassi,
                    c.val_gbv val_gbv_iniziale,
                    a.val_gbv val_gbv_finale,
                    d.num_mesi,
                    d.val_gbv_medio,
                      (  (SUM (b.val_incassi) / d.val_gbv_medio)
                       / COUNT (b.val_incassi))
                    * 12
                       val_TMR
               FROM t_mcres_fen_var_stock a,
                    t_mcres_fen_var_stock b,
                    t_mcres_fen_var_stock c,
                    (  SELECT l.cod_abi,
                              l.id_dper,
                              COUNT (m.val_gbv) num_mesi,
                              AVG (m.val_gbv) val_gbv_medio
                         FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                        WHERE     1 = 1
                              AND l.cod_abi = m.cod_abi
                              AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                                AND l.dta_rif
                     GROUP BY l.cod_abi, l.id_dper) d
              WHERE     1 = 1
                    AND a.cod_abi = b.cod_abi(+)
                    AND b.dta_rif(+) BETWEEN TRUNC (a.dta_rif, 'Y')
                                         AND a.dta_rif
                    AND a.cod_abi = c.cod_abi(+)
                    AND c.dta_rif(+) = TRUNC (a.dta_rif, 'Y') - 1
                    AND a.cod_abi = d.cod_abi(+)
                    AND a.id_dper = d.id_dper(+)
           GROUP BY a.cod_abi,
                    a.id_dper,
                    c.val_gbv,
                    a.val_gbv,
                    d.num_mesi,
                    d.val_gbv_medio
           UNION ALL
             SELECT a.cod_abi,
                    a.id_dper,
                    'T' flg_gruppo,
                    SUM (b.val_var_aumento) val_var_aumento,
                    SUM (b.val_var_diminuzione) val_var_diminuzione,
                    SUM (b.val_incassi) val_incassi,
                    c.val_gbv val_gbv_iniziale,
                    d.val_gbv val_gbv_finale,
                    e.num_mesi,
                    e.val_gbv_medio,
                      (  (SUM (b.val_incassi) / e.val_gbv_medio)
                       / COUNT (b.val_incassi))
                    * 12
                       val_TMR
               FROM t_mcres_fen_var_stock a,
                    t_mcres_fen_var_stock b,
                    t_mcres_fen_var_stock c,
                    t_mcres_fen_var_stock d,
                    (  SELECT l.cod_abi,
                              l.id_dper,
                              COUNT (m.val_gbv) num_mesi,
                              AVG (m.val_gbv) val_gbv_medio
                         FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                        WHERE     1 = 1
                              AND l.cod_abi = m.cod_abi
                              AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                                AND TRUNC (l.dta_rif, 'Q') - 1
                     GROUP BY l.cod_abi, l.id_dper) e
              WHERE     1 = 1
                    AND a.cod_abi = b.cod_abi(+)
                    AND b.dta_rif(+) BETWEEN   ADD_MONTHS (
                                                  TRUNC (a.dta_rif + 1, 'Q'),
                                                  -2)
                                             - 1
                                         AND TRUNC (a.dta_rif + 1, 'Q') - 1
                    AND a.cod_abi = c.cod_abi(+)
                    AND c.dta_rif(+) =
                           ADD_MONTHS (TRUNC (a.dta_rif + 1, 'Q'), -3) - 1
                    AND a.cod_abi = d.cod_abi(+)
                    AND d.dta_rif(+) = TRUNC (a.dta_rif + 1, 'Q') - 1
                    AND a.cod_abi = e.cod_abi(+)
                    AND a.id_dper = e.id_dper(+)
           GROUP BY a.cod_abi,
                    a.id_dper,
                    c.val_gbv,
                    d.val_gbv,
                    e.num_mesi,
                    e.val_gbv_medio) t,
          t_mcres_app_istituti i
    WHERE 1 = 1 AND t.cod_abi = i.cod_abi;
