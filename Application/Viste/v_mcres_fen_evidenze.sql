/* Formatted on 21/07/2014 18:43:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_EVIDENZE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_GBV,
   COD_LABEL,
   VAL_TIPO_GESTIONE,
   DTA_PASSAGGIO_SOFF,
   VAL_RETTIFICA_INC,
   VAL_PERC_DUBBIO_ESITO
)
AS
   SELECT                                  -- AG 20120911 Fixed alias cod_sndg
         DISTINCT
          r.COD_ABI,
          r.COD_NDG,
          r.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (-r.val_imp_gbv)
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.COD_ndg = p.COD_ndg
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          1 COD_LABEL,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = r.cod_abi AND i.cod_ndg = r.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = r.cod_abi
                  AND ss.cod_ndg = r.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_RAPPORTI R,
          t_mcres_app_pratiche p,
          T_MCRES_APP_POSIZIONI N
    WHERE     p.flg_attiva = 1
          AND N.FLG_ATTIVA = 1
          AND r.dta_nbv IS NULL
          AND r.val_imp_nbv != 0
          AND R.COD_ABI = P.COD_ABI
          AND r.cod_ndg = p.cod_ndg
          AND R.COD_ABI = n.COD_ABI
          AND r.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (-r.val_imp_gbv)
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.COD_ndg = p.COD_ndg
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          2 cod_label,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND n.flg_attiva = 1
          AND P.DTA_ASSEGN_ADDET >= TRUNC (SYSDATE) - 30
          AND p.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
   UNION ALL
   SELECT P.COD_ABI,
          p.COD_NDG,
          p.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (-r.val_imp_gbv)
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.COD_ndg = p.COD_ndg
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          DECODE (P.FLG_CONFERIMENTO, 'A', 3, 4) COD_LABEL,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE r, T_MCRES_APP_POSIZIONI P
    WHERE     P.FLG_ATTIVA = 1
          AND R.FLG_ATTIVA = 1
          AND P.COD_ABI = R.COD_ABI
          AND p.cod_abi = r.cod_ndg
          AND p.cod_stato_rischio = 'S'
          AND DTA_CONFERIMENTO >= TRUNC (SYSDATE) - 30
          AND FLG_CONFERIMENTO = 'A'                              --- 20140414
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (-r.val_imp_gbv)
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.COD_ndg = p.COD_ndg
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          5 cod_label,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND N.FLG_ATTIVA = 1
          AND P.DTA_ASSEGN_ADDET BETWEEN TRUNC (SYSDATE) - 60
                                     AND TRUNC (SYSDATE) - 30
          AND P.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
          AND FLG_CONFERIMENTO = 'A'
          AND NOT EXISTS
                     (SELECT DISTINCT 1
                        FROM T_MCRES_APP_DELIBERE D
                       WHERE     D.COD_ABI = P.COD_ABI
                             AND d.cod_ndg = p.cod_ndg
                             AND d.cod_delibera IN ('NS', 'NZ', 'IS'))
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (-r.val_imp_gbv)
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.COD_ndg = p.COD_ndg
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          6 cod_label,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND N.FLG_ATTIVA = 1
          AND P.DTA_ASSEGN_ADDET < TRUNC (SYSDATE) - 60
          AND P.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
          AND FLG_CONFERIMENTO = 'A'
          AND NOT EXISTS
                     (SELECT DISTINCT 1
                        FROM T_MCRES_APP_DELIBERE D
                       WHERE     D.COD_ABI = P.COD_ABI
                             AND d.cod_ndg = p.cod_ndg
                             AND d.cod_delibera IN ('NS', 'NZ', 'IS'))
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (
                       CASE
                          WHEN (    FLG_RAPP_FONDO_TERZO = 'S'
                                AND VAL_PERC_RISCHIO_IST != 0)
                          THEN
                             -r.val_imp_gbv * VAL_PERC_RISCHIO_IST / 100
                          ELSE
                             -r.val_imp_gbv
                       END)
                       val_gbv
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.cod_ndg = p.cod_ndg
                    AND (   (   FLG_RAPP_FONDO_TERZO = 'N'
                             OR (    FLG_RAPP_FONDO_TERZO = 'S'
                                 AND VAL_PERC_RISCHIO_IST != 0))
                         OR COD_FORMA_TECNICA != '9561'
                         OR (   FLG_RAPP_CARTOLARIZZATO = 'N'
                             OR (    FLG_RAPP_CARTOLARIZZATO = 'S'
                                 AND COD_ABI_CARTOLARIZZANTE NOT IN
                                        ('32359',
                                         '32432',
                                         '32524',
                                         '32737',
                                         '33256',
                                         '33470')))
                         OR val_imp_gbv > 0)
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          7 cod_label,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND N.FLG_ATTIVA = 1
          AND p.COD_TIPO_GESTIONE = 'S'
          AND P.DTA_ASSEGN_ADDET < TRUNC (SYSDATE) - 30
          AND P.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
          AND FLG_CONFERIMENTO = 'A'
          AND NOT EXISTS
                 (SELECT DISTINCT 1
                    FROM V_MCRES_APP_PIANI_RIENTRO pr
                   WHERE pr.COD_ABI = P.COD_ABI AND pr.cod_ndg = p.cod_ndg)
   UNION ALL
   SELECT p.COD_ABI,
          p.COD_NDG,
          n.cod_sndg,
          COD_UO_PRATICA,
          COD_MATR_PRATICA,
          (  SELECT SUM (
                       CASE
                          WHEN (    FLG_RAPP_FONDO_TERZO = 'S'
                                AND VAL_PERC_RISCHIO_IST != 0)
                          THEN
                             -r.val_imp_gbv * VAL_PERC_RISCHIO_IST / 100
                          ELSE
                             -r.val_imp_gbv
                       END)
                       val_gbv
               FROM t_mcres_app_rapporti r
              WHERE     r.dta_chiusura_rapp = TO_DATE ('99991231', 'yyyymmdd')
                    AND r.COD_ABI = p.COD_ABI
                    AND r.cod_ndg = p.cod_ndg
                    AND (   (   FLG_RAPP_FONDO_TERZO = 'N'
                             OR (    FLG_RAPP_FONDO_TERZO = 'S'
                                 AND VAL_PERC_RISCHIO_IST != 0))
                         OR COD_FORMA_TECNICA != '9561'
                         OR (   FLG_RAPP_CARTOLARIZZATO = 'N'
                             OR (    FLG_RAPP_CARTOLARIZZATO = 'S'
                                 AND COD_ABI_CARTOLARIZZANTE NOT IN
                                        ('32359',
                                         '32432',
                                         '32524',
                                         '32737',
                                         '33256',
                                         '33470')))
                         OR val_imp_gbv > 0)
           GROUP BY r.cod_abi, r.cod_ndg)
             val_gbv,
          8 cod_label,
          FLG_GESTIONE val_tipo_gestione,
          DTA_PASSAGGIO_SOFF,
          (SELECT VAL_RETTIFICA_INC
             FROM V_MCRES_APP_RV_INCAGLIO i
            WHERE i.cod_abi = p.cod_abi AND i.cod_ndg = p.cod_ndg)
             VAL_RETTIFICA_INC,
          (SELECT val_perc_dubbio_esito
             FROM (SELECT cod_abi,
                          cod_ndg,
                          s.val_perc_dubbio_esito,
                          DTA_LAST_UPD_DELIBERA,
                          MAX (DTA_LAST_UPD_DELIBERA)
                             OVER (PARTITION BY cod_abi, cod_ndg)
                             last_UPD_DELIBERA
                     FROM t_mcrei_app_delibere s
                    --and s.cod_protocollo_delibera = a.cod_protocollo_delibera
                    WHERE     s.COD_MICROTIPOLOGIA_DELIB IN ('CS', 'CZ')
                          AND cod_fase_delibera != 'AN') ss
            WHERE     ss.cod_abi = p.cod_abi
                  AND ss.cod_ndg = p.cod_ndg
                  AND DTA_LAST_UPD_DELIBERA = LAST_UPD_DELIBERA
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM T_MCRES_APP_DELIBERE d
                           WHERE     ss.cod_abi = d.cod_abi
                                 AND ss.cod_ndg = d.cod_ndg))
             val_perc_dubbio_esito
     FROM T_MCRES_APP_PRATICHE P, T_MCRES_APP_POSIZIONI N
    WHERE     P.FLG_ATTIVA = 1
          AND N.FLG_ATTIVA = 1
          AND p.COD_TIPO_GESTIONE = 'S'
          AND P.DTA_ASSEGN_ADDET < TRUNC (SYSDATE) - 30
          AND P.COD_ABI = N.COD_ABI
          AND p.cod_ndg = n.cod_ndg
          AND n.cod_stato_rischio = 'S'
          AND FLG_CONFERIMENTO = 'A'
          AND EXISTS
                 (SELECT DISTINCT 1
                    FROM V_MCRES_APP_PIANI_RIENTRO pr
                   WHERE     pr.COD_ABI = P.COD_ABI
                         AND pr.cod_ndg = p.cod_ndg
                         AND dta_scadenza_rata < TRUNC (SYSDATE) + 7);
