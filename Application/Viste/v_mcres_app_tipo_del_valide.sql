/* Formatted on 21/07/2014 18:43:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_TIPO_DEL_VALIDE
(
   COD_ABI,
   COD_DELIBERA,
   DESC_DELIBERA,
   VAL_ORDINE
)
AS
   WITH delibere
        -- 20130131 AG inserito >= in filtro sulle date delle delibere
        -- 20130718 VG Commentato tipo gestione per TT-TS
        AS (SELECT DISTINCT d.cod_delibera,
                            d.cod_stato_delibera,
                            p.cod_tipo_gestione,
                            D.DTA_INSERIMENTO_DELIBERA
              FROM t_mcres_app_pratiche p,
                   t_mcres_app_delibere d,
                   t_mcres_app_posizioni z
             WHERE     0 = 0
                   AND d.cod_abi =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  16,
                                  5)
                   AND d.cod_pratica =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  5,
                                  11)
                   AND d.val_anno_pratica =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  1,
                                  4)
                   AND p.cod_abi =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  16,
                                  5)
                   AND p.cod_pratica =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  5,
                                  11)
                   AND p.val_anno =
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  1,
                                  4)
                   AND p.flg_attiva = 1
                   AND z.flg_attiva = 1
                   AND p.cod_abi = z.cod_abi
                   AND p.cod_ndg = z.cod_ndg
                   AND p.cod_abi = d.cod_abi
                   AND p.cod_ndg = d.cod_ndg
                   AND p.cod_pratica = d.cod_pratica
                   AND p.val_anno = d.val_anno_pratica
                   AND d.cod_stato_delibera != 'AN'
                   -- AP 11/01/2013
                   --and nvl(dta_delibera,sysdate) >= Z.DTA_PASSAGGIO_SOFF)
                   AND COALESCE (D.DTA_INSERIMENTO_DELIBERA,
                                 D.DTA_DELIBERA,
                                 D.DTA_AGGIORNAMENTO_DELIBERA) >=
                          Z.DTA_PASSAGGIO_SOFF
                   AND d.COD_STATO_RISCHIO = 'S')
     SELECT cod_abi,
            cod_delibera,
            desc_delibera,
            val_ordine
       FROM t_mcres_cl_tipo_delibera a,
            (SELECT 'NS' tipo
               FROM DUAL
              WHERE NOT EXISTS
                       (SELECT 1
                          FROM delibere
                         WHERE cod_stato_delibera != 'TR')
             UNION ALL
             SELECT tipo
               FROM (SELECT 'RV' tipo FROM DUAL
                     UNION ALL
                     SELECT 'AS' FROM DUAL)
              WHERE     EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE     0 = 0
                                   AND cod_delibera IN ('IS', 'NS', 'NZ', 'FZ')
                                   AND cod_stato_delibera = 'CO'
                                   AND cod_tipo_gestione = 'S')
                    --                            UNION ALL
                    --                            SELECT   1
                    --                              FROM   delibere
                    --                             WHERE       cod_delibera IN ('NZ','FZ')
                    --                                     AND cod_stato_delibera = 'CO'
                    --                                     AND cod_tipo_gestione = 'S')
                    AND NOT EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE cod_stato_delibera IN ('IN', 'IT'))
                    AND NOT EXISTS
                               (SELECT 1
                                  FROM delibere
                                 WHERE     cod_delibera = 'RW'
                                       AND TRUNC (dta_inserimento_delibera) =
                                              TRUNC (SYSDATE))
             UNION ALL
             SELECT tipo
               FROM (SELECT 'SN' tipo FROM DUAL
                     UNION ALL
                     SELECT 'TT' FROM DUAL
                     UNION ALL
                     SELECT 'TS' FROM DUAL)
              WHERE     EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE     0 = 0
                                   AND cod_delibera IN ('IS', 'NS', 'NZ', 'FZ')
                                   AND cod_stato_delibera = 'CO' --                        UNION ALL
                                                                --                        SELECT 1
                                                                --                          FROM delibere
                                                                --                         WHERE     cod_delibera IN ('NZ', 'FZ')
                                                                --                               AND cod_stato_delibera = 'CO'
                                                                -- AND cod_tipo_gestione = 'Z'
                        )
                    AND NOT EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE cod_stato_delibera IN ('IN', 'IT'))
             UNION ALL
             SELECT 'TP' tipo
               FROM DUAL
              WHERE     EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE     cod_delibera IN ('IS', 'NS')
                                   AND cod_stato_delibera = 'CO'
                            UNION ALL
                            SELECT 1
                              FROM delibere
                             WHERE     cod_delibera IN ('NZ', 'FZ')
                                   AND cod_stato_delibera = 'CO')
                    AND NOT EXISTS
                               (SELECT 1
                                  FROM delibere
                                 WHERE     cod_stato_delibera IN ('IN', 'IT')
                                       AND cod_delibera != 'TP')
             UNION ALL
             SELECT tipo
               FROM (SELECT 'RE' tipo FROM DUAL
                     UNION ALL
                     SELECT 'ES' tipo FROM DUAL)
              WHERE     EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE     0 = 0
                                   AND cod_delibera IN ('IS', 'NS', 'NZ', 'FZ')
                                   AND cod_stato_delibera = 'CO')
                    AND NOT EXISTS
                           (SELECT 1
                              FROM delibere
                             WHERE cod_stato_delibera IN ('IN', 'IT'))) b
      WHERE     0 = 0
            AND a.cod_abi =
                   SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 16, 5)
            AND a.cod_delibera = b.tipo
            AND a.cod_delibera != 'RW'
   ORDER BY val_ordine;
