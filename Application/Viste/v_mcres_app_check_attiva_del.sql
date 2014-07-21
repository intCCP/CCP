/* Formatted on 21/07/2014 18:41:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CHECK_ATTIVA_DEL
(
   COD_ABI,
   COD_NDG,
   COD_PRATICA,
   VAL_ANNO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_DELIBERA,
   VAL_MESSAGGIO
)
AS
   SELECT                          -- VG 20140314 conrollo delibere VA check 9
         cod_abi,
          cod_ndg,
          cod_pratica,
          val_anno,
          cod_uo_pratica,
          cod_matr_pratica,
          cod_delibera,
          CASE
             WHEN val_check_1 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 1 AND flg_attivo = 1)
             WHEN val_check_2 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 2 AND flg_attivo = 1)
             WHEN val_check_3 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 3 AND flg_attivo = 1)
             WHEN val_check_4 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 4 AND flg_attivo = 1)
             WHEN val_check_5 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 5 AND flg_attivo = 1)
             WHEN val_check_6 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 6 AND flg_attivo = 1)
             WHEN val_check_7 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 7 AND flg_attivo = 1)
             WHEN val_check_8 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 8 AND flg_attivo = 1)
             WHEN val_check_9 = 1
             THEN
                (SELECT val_messaggio
                   FROM t_mcres_app_delibere_check
                  WHERE id_check = 9 AND flg_attivo = 1)
             ELSE
                NULL
          END
             val_messaggio
     FROM (SELECT p.cod_abi,
                  p.cod_ndg,
                  p.cod_pratica,
                  p.val_anno,
                  p.cod_uo_pratica,
                  p.cod_matr_pratica,
                  d.cod_delibera,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        DECODE (
                           NVL (
                              (SELECT DISTINCT 1
                                 FROM t_mcres_app_delibere d
                                WHERE     d.cod_abi = p.cod_abi
                                      AND d.cod_ndg = p.cod_ndg
                                      AND d.COD_DELIBERA IN ('IS', 'NS')
                                      AND d.cod_stato_delibera = 'CO'),
                              0),
                           0, 1,
                           0)
                     ELSE
                        0
                  END
                     val_check_1,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        NVL (
                           (SELECT DISTINCT 1
                              FROM t_mcres_app_delibere d
                             WHERE     d.cod_abi = p.cod_abi
                                   AND d.cod_ndg = p.cod_ndg
                                   AND d.COD_DELIBERA IN ('NS', 'AS', 'RV')
                                   AND d.cod_stato_delibera != 'CO'),
                           0)
                     ELSE
                        0
                  END
                     val_check_2,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        NVL (
                           (SELECT DISTINCT 1
                              FROM t_mcres_app_delibere d
                             WHERE     d.cod_abi = p.cod_abi
                                   AND d.cod_ndg = p.cod_ndg
                                   AND d.COD_DELIBERA = 'TT'
                                   AND d.cod_stato_delibera = 'AD'
                                   AND dta_delibera >=
                                          (SELECT MAX (dta_delibera)
                                             FROM t_mcres_app_delibere d
                                            WHERE     d.cod_abi = p.cod_abi
                                                  AND d.cod_ndg = p.cod_ndg
                                                  AND d.COD_DELIBERA IN
                                                         ('NS',
                                                          'AS',
                                                          'RV',
                                                          'RW'))),
                           0)
                     ELSE
                        0
                  END
                     val_check_3,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        NVL (
                           (SELECT DISTINCT 1
                              FROM t_mcres_app_delibere d
                             WHERE     d.cod_abi = p.cod_abi
                                   AND d.cod_ndg = p.cod_ndg
                                   AND d.COD_DELIBERA = 'SN'
                                   AND d.cod_stato_delibera = 'CO'
                                   AND dta_delibera >=
                                          (SELECT MAX (dta_delibera)
                                             FROM t_mcres_app_delibere d
                                            WHERE     d.cod_abi = p.cod_abi
                                                  AND d.cod_ndg = p.cod_ndg
                                                  AND d.COD_DELIBERA IN
                                                         ('NS',
                                                          'AS',
                                                          'RV',
                                                          'RW'))
                                   AND (SELECT NVL (SUM (val_imp_saldo_cap),
                                                    0)
                                          FROM t_mcres_app_rapporti d
                                         WHERE     d.cod_abi = p.cod_abi
                                               AND d.cod_ndg = p.cod_ndg) = 0),
                           0)
                     ELSE
                        0
                  END
                     val_check_4,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        CASE
                           WHEN P.cod_tipo_gestione = 'Z'
                           THEN
                              1
                           WHEN 1 =
                                   (SELECT DISTINCT 1
                                      FROM t_mcres_app_delibere d
                                     WHERE     d.cod_abi = p.cod_abi
                                           AND d.cod_ndg = p.cod_ndg
                                           AND d.COD_DELIBERA IN ('NZ', 'FZ'))
                           THEN
                              1
                           ELSE
                              0
                        END
                     ELSE
                        0
                  END
                     val_check_5,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        CASE
                           WHEN NVL (
                                   (SELECT DISTINCT 1
                                      FROM t_mcres_app_rapporti d
                                     WHERE     d.cod_abi = p.cod_abi
                                           AND d.cod_ndg = p.cod_ndg
                                           AND FLG_RAPP_FONDO_TERZO = 'N'),
                                   0) = 0
                           THEN
                              1
                           WHEN (SELECT NVL (SUM (VAL_PERC_RISCHIO_IST), 0)
                                   FROM t_mcres_app_rapporti d
                                  WHERE     d.cod_abi = p.cod_abi
                                        AND d.cod_ndg = p.cod_ndg
                                        AND FLG_RAPP_FONDO_TERZO = 'S') = 100
                           THEN
                              1
                           ELSE
                              0
                        END
                     ELSE
                        0
                  END
                     val_check_6,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        CASE
                           WHEN (SELECT DECODE (
                                           NVL (SUM (val_imp_saldo_cap), 0),
                                           0, 0,
                                           1)
                                   FROM t_mcres_app_rapporti d
                                  WHERE     d.cod_abi = p.cod_abi
                                        AND d.cod_ndg = p.cod_ndg
                                        AND FLG_RAPP_FONDO_TERZO = 'N') = 0
                           THEN
                              1
                           ELSE
                              0
                        END
                     ELSE
                        0
                  END
                     val_check_7,
                  CASE
                     WHEN cod_delibera = 'RW'
                     THEN
                        NVL (
                           (SELECT DISTINCT 1
                              FROM t_mcres_app_rapporti d
                             WHERE     d.cod_abi = p.cod_abi
                                   AND d.cod_ndg = p.cod_ndg
                                   AND cod_ssa IN ('MO', 'MI')
                                   AND NOT EXISTS
                                              (SELECT DISTINCT 1
                                                 FROM v_mcres_app_stime s
                                                WHERE     s.cod_abi =
                                                             p.cod_abi
                                                      AND s.cod_ndg =
                                                             p.cod_ndg)),
                           0)
                     ELSE
                        0
                  END
                     val_check_8,
                  CASE
                     WHEN cod_delibera = 'VA'
                     THEN
                        NVL (
                           (SELECT DISTINCT 1
                              FROM t_mcres_app_delibere d
                             WHERE     d.cod_abi = p.cod_abi
                                   AND d.cod_ndg = p.cod_ndg
                                   AND cod_delibera IN
                                          ('RW', 'NS', 'AS', 'RV')
                                   AND EXISTS
                                          (SELECT DISTINCT 1
                                             FROM v_mcres_app_stime s
                                            WHERE     s.cod_abi = d.cod_abi
                                                  AND s.cod_ndg = d.cod_ndg
                                                  AND s.COD_PROTOCOLLO_DELIBERA =
                                                         d.COD_PROTOCOLLO_DELIBERA
                                                  AND s.DTA_STIMA >=
                                                         TRUNC (SYSDATE))),
                           0)
                     ELSE
                        0
                  END
                     val_check_9
             FROM t_mcres_app_pratiche p,
                  (SELECT 'RW' cod_delibera FROM DUAL
                   UNION ALL
                   SELECT 'VA' cod_delibera FROM DUAL) d);
