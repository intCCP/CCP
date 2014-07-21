/* Formatted on 17/06/2014 18:11:11 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_Q,
   VAL_RETTIFICA_NETTA
)
AS
   WITH nt_tmp
        AS (SELECT a.id_dper,
                   a.cod_abi,
                   a.val_gbv,
                   a.val_nbv,
                   a.val_gbv - a.val_nbv val_fondo_attuale,
                   --lag(val_gbv - val_nbv) over(partition by cod_abi order by id_dper) val_fondo_prec
                   b.val_fondo_prec
              FROM t_mcres_app_ptf_non_target a,
                   (SELECT id_dper, cod_abi, val_gbv - val_nbv val_fondo_prec
                      FROM t_mcres_app_ptf_non_target a
                     WHERE     0 = 0
                           AND tipo_record = 1
                           AND cod_stato_rischio = 'S') b
             WHERE     0 = 0
                   AND a.cod_abi = b.cod_abi(+)
                   AND b.id_dper(+) =
                          TO_NUMBER (
                             TO_CHAR (
                                ADD_MONTHS (TO_DATE (a.id_dper, 'yyyymm'),
                                            -1),
                                'yyyymm'))
                   AND a.tipo_record = 1
                   AND a.cod_stato_rischio = 'S')
     SELECT                                --RV trimestrali (dati di bilancio)
           r.cod_abi,
            am.val_annomese,
            am.cod_q,
            SUM (r.val_rettifica_netta) val_rettifica_mese
       FROM t_mcres_app_am_rv am, t_mcres_fen_rettifiche r
      WHERE 0 = 0 AND am.val_am_prec = r.val_annomese AND r.flg_gruppo = 1
   GROUP BY r.cod_abi, am.val_annomese, am.cod_q
   UNION ALL
     SELECT            --RV trimestrali (dati di bilancio) istituti non target
           r.cod_abi,
            am.val_annomese,
            am.cod_q,
            SUM (NVL (r.val_fondo_attuale - r.val_fondo_prec, 0))
               val_rettifica_mese
       FROM t_mcres_app_am_rv am, nt_tmp r
      WHERE am.val_am_prec = r.id_dper
   GROUP BY r.cod_abi, am.val_annomese, am.cod_q
   UNION ALL
     SELECT                                           --RV mese contabilizzato
           cod_abi,
            val_annomese,
            5 cod_q,
            SUM (val_rettifica_netta) val_rettifica_netta
       FROM t_mcres_fen_rettifiche
      WHERE flg_gruppo = 1
   GROUP BY cod_abi, val_annomese
   UNION ALL
   SELECT                         --RV mese contabilizzato istituti non target
         cod_abi,
          id_dper val_annomese,
          5 cod_q,
          val_fondo_attuale - val_fondo_prec val_rettifica_nett
     FROM nt_tmp
   UNION ALL
     SELECT                                  -- di cui DRC mese contabilizzato
           cod_abi,
            val_annomese,
            9 cod_q,
            SUM (val_rettifica_netta) val_rettifica_netta
       FROM t_mcres_fen_rettifiche
      WHERE flg_gruppo = 2
   GROUP BY cod_abi, val_annomese
   UNION ALL
     SELECT                                       --RV anno (dati di bilancio)
           r.cod_abi,
            am.val_annomese,
            13 cod_q,
            SUM (r.val_rettifica_netta) val_rettifica_mese
       FROM t_mcres_app_am_rv am, t_mcres_fen_rettifiche r
      WHERE 0 = 0 AND am.val_am_prec = r.val_annomese AND r.flg_gruppo = 1
   GROUP BY r.cod_abi, am.val_annomese
   UNION ALL
     SELECT                             --RV i cui DRC anno (dati di bilancio)
           r.cod_abi,
            am.val_annomese,
            14 cod_q,
            SUM (r.val_rettifica_netta) val_rettifica_mese
       FROM t_mcres_app_am_rv am, t_mcres_fen_rettifiche r
      WHERE am.val_am_prec = r.val_annomese AND r.flg_gruppo = 2
   GROUP BY r.cod_abi, am.val_annomese
   UNION ALL
     SELECT                       --RV mese non contabilizzato (dati da SISBA)
           cod_abi,
            val_annomese,
            6 cod_q,
            SUM (val_rv) val_rettifica_mese
       FROM t_mcres_fen_rettifiche_sisba
   GROUP BY cod_abi, val_annomese
   UNION ALL
     SELECT           --RV  ci dui DRC mese non contabilizzato (dati da SISBA)
           cod_abi,
            val_annomese,
            10 cod_q,
            SUM (VAL_DRC) val_rettifica_netta --------------  VG  sum(VAL_RV) val_rettifica_netta
       FROM t_mcres_fen_rettifiche_sisba
   GROUP BY cod_abi, val_annomese
   UNION ALL
   SELECT                                                            --RV  YTD
         c.cod_abi,
          val_annomese,
          7 cod_q,
          val_rettifica_netta + NVL (val_rv, 0) val_rettifica_netta
     FROM (  SELECT r.cod_abi,
                    a.val_annomese,
                    SUM (r.val_rettifica_netta) val_rettifica_netta
               FROM t_mcres_fen_rettifiche r, T_MCRES_APP_AM_RV a
              WHERE     0 = 0
                    AND r.flg_gruppo = 1
                    AND a.val_am_prec = r.val_annomese
           GROUP BY r.cod_abi, a.val_annomese) c,
          (  SELECT cod_abi, SUM (val_rv) val_rv
               FROM t_mcres_fen_rettifiche_sisba
           GROUP BY cod_abi) s
    WHERE 0 = 0 AND c.cod_abi = s.cod_abi(+)
   UNION ALL
   SELECT                                          --RV  di competenza DRC YTD
         c.cod_abi,
          val_annomese,
          8 cod_q,
          val_rettifica_netta + NVL (val_drc, 0) val_rettifica_netta
     FROM (  SELECT r.cod_abi,
                    a.val_annomese,
                    SUM (r.val_rettifica_netta) val_rettifica_netta
               FROM t_mcres_fen_rettifiche r, T_MCRES_APP_AM_RV a
              WHERE     0 = 0
                    AND r.flg_gruppo = 2
                    AND a.val_am_prec = r.val_annomese
           GROUP BY r.cod_abi, a.val_annomese) c,
          (  SELECT cod_abi, SUM (val_drc) val_drc
               FROM t_mcres_fen_rettifiche_sisba
           GROUP BY cod_abi) s
    WHERE 0 = 0 AND c.cod_abi = s.cod_abi(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_RETTIFICHE TO MCRE_USR;
