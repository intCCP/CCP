/* Formatted on 17/06/2014 18:11:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_VAR_STOCK_POS
(
   COD_ABI,
   VAL_ANNOMESE,
   FLG_GRUPPO,
   VAL_VAR_AUMENTO,
   VAL_VAR_DIMINUZIONE,
   VAL_INCASSI,
   VAL_GBV_INIZIALE,
   VAL_GBV_FINALE,
   VAL_TMR,
   VAL_STOCK_MEDIO_ANNO,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   DTA_INS,
   DESC_ISTITUTO
)
AS
   SELECT                                                      --AG 05/11/2011
         t.cod_abi,
          t.val_annomese,
          t.flg_gruppo,
          t.val_var_aumento,
          t.val_var_diminuzione,
          t.val_incassi,
          t.val_gbv_iniziale,
          t.val_gbv_finale,
          t.val_TMR,
          t.val_gbv_medio val_stock_medio_anno,
          0 flg_gar_reali_personali,
          0 flg_gar_reali,
          NULL dta_ins,
          i.desc_istituto
     FROM (SELECT a.cod_abi,
                  a.val_annomese,
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
                            l.val_annomese,
                            COUNT (m.val_gbv) num_mesi,
                            AVG (m.val_gbv) val_gbv_medio
                       FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                      WHERE     1 = 1
                            AND l.cod_abi = m.cod_abi
                            AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                              AND l.dta_rif
                   GROUP BY l.cod_abi, l.val_annomese) c
            WHERE     1 = 1
                  AND a.cod_abi = b.cod_abi(+)
                  AND b.dta_rif(+) = ADD_MONTHS (a.dta_rif, -1)
                  AND a.cod_abi = c.cod_abi(+)
                  AND a.val_annomese = c.val_annomese
           UNION ALL
             SELECT a.cod_abi,
                    a.val_annomese,
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
                              l.val_annomese,
                              COUNT (m.val_gbv) num_mesi,
                              AVG (m.val_gbv) val_gbv_medio
                         FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                        WHERE     1 = 1
                              AND l.cod_abi = m.cod_abi
                              AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                                AND l.dta_rif
                     GROUP BY l.cod_abi, l.val_annomese) d
              WHERE     1 = 1
                    AND a.cod_abi = b.cod_abi(+)
                    AND b.dta_rif(+) BETWEEN TRUNC (a.dta_rif, 'Y')
                                         AND a.dta_rif
                    AND a.cod_abi = c.cod_abi(+)
                    AND c.dta_rif(+) = TRUNC (a.dta_rif, 'Y') - 1
                    AND a.cod_abi = d.cod_abi(+)
                    AND a.val_annomese = d.val_annomese(+)
           GROUP BY a.cod_abi,
                    a.val_annomese,
                    c.val_gbv,
                    a.val_gbv,
                    d.num_mesi,
                    d.val_gbv_medio
           UNION ALL
             SELECT a.cod_abi,
                    a.val_annomese,
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
                              l.val_annomese,
                              COUNT (m.val_gbv) num_mesi,
                              AVG (m.val_gbv) val_gbv_medio
                         FROM t_mcres_fen_var_stock l, t_mcres_fen_var_stock m
                        WHERE     1 = 1
                              AND l.cod_abi = m.cod_abi
                              AND m.dta_rif BETWEEN TRUNC (l.dta_rif, 'Y') - 1
                                                AND TRUNC (l.dta_rif, 'Q') - 1
                     GROUP BY l.cod_abi, l.val_annomese) e
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
                    AND a.val_annomese = e.val_annomese(+)
           GROUP BY a.cod_abi,
                    a.val_annomese,
                    c.val_gbv,
                    d.val_gbv,
                    e.num_mesi,
                    e.val_gbv_medio) t,
          t_mcres_app_istituti i
    WHERE 1 = 1 AND t.cod_abi = i.cod_abi;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_VAR_STOCK_POS TO MCRE_USR;
