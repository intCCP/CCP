/* Formatted on 21/07/2014 18:42:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_OLD
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_Q,
   VAL_RETTIFICA_NETTA,
   VAL_ANNOMESE_DRC_CONT,
   VAL_ANNOMESE_DRC_DACONT
)
AS
     SELECT a.cod_abi,
            a.val_annomese,
            1 cod_q,
            SUM (NVL (b.val_rettifica_netta, 0)) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a, t_mcres_fen_rettifiche b
      WHERE     0 = 0
            AND a.flg_gruppo = 1
            AND b.flg_gruppo(+) = 1
            AND a.cod_abi = b.cod_abi(+)
            AND b.val_annomese(+) BETWEEN SUBSTR (a.val_annomese, 1, 4) || '01'
                                      AND SUBSTR (a.val_annomese, 1, 4) || '03'
            AND b.val_annomese(+) <= a.val_annomese
   GROUP BY a.cod_abi,
            a.val_annomese,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
   --------------------------
   UNION ALL
     --------------------------
     SELECT a.cod_abi,
            a.val_annomese,
            2 cod_q,
            SUM (NVL (b.val_rettifica_netta, 0)) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a, t_mcres_fen_rettifiche b
      WHERE     0 = 0
            AND a.flg_gruppo = 1
            AND b.flg_gruppo(+) = 1
            AND a.cod_abi = b.cod_abi(+)
            AND b.val_annomese(+) BETWEEN SUBSTR (a.val_annomese, 1, 4) || '04'
                                      AND SUBSTR (a.val_annomese, 1, 4) || '06'
            AND b.val_annomese(+) <= a.val_annomese
   GROUP BY a.cod_abi,
            a.val_annomese,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
   --------------------------
   UNION ALL
     --------------------------
     SELECT a.cod_abi,
            a.val_annomese,
            3 cod_q,
            SUM (NVL (b.val_rettifica_netta, 0)) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a, t_mcres_fen_rettifiche b
      WHERE     0 = 0
            AND a.flg_gruppo = 1
            AND b.flg_gruppo(+) = 1
            AND a.cod_abi = b.cod_abi(+)
            AND b.val_annomese(+) BETWEEN SUBSTR (a.val_annomese, 1, 4) || '07'
                                      AND SUBSTR (a.val_annomese, 1, 4) || '09'
            AND b.val_annomese(+) <= a.val_annomese
   GROUP BY a.cod_abi,
            a.val_annomese,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
   --------------------------
   UNION ALL
     --------------------------
     SELECT a.cod_abi,
            a.val_annomese,
            4 cod_q,
            SUM (NVL (b.val_rettifica_netta, 0)) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a, t_mcres_fen_rettifiche b
      WHERE     0 = 0
            AND a.flg_gruppo = 1
            AND b.flg_gruppo(+) = 1
            AND a.cod_abi = b.cod_abi(+)
            AND b.val_annomese(+) BETWEEN SUBSTR (a.val_annomese, 1, 4) || '10'
                                      AND SUBSTR (a.val_annomese, 1, 4) || '12'
            AND b.val_annomese(+) <= a.val_annomese
   GROUP BY a.cod_abi,
            a.val_annomese,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
   --------------------------
   UNION ALL
   --------------------------
   SELECT a.cod_abi,
          a.val_annomese,
          5 cod_q,
          a.val_rettifica_netta,
          a.val_annomese_drc_cont,
          a.val_annomese_drc_dacont
     FROM t_mcres_fen_rettifiche a
    WHERE 0 = 0 AND a.flg_gruppo = 1
   --------------------------
   UNION ALL
     --------------------------
     SELECT a.cod_abi,
            a.val_annomese,
            9 cod_q,
            SUM (a.val_rettifica_netta) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a
      WHERE 0 = 0 AND a.flg_gruppo = 5
   GROUP BY a.cod_abi,
            a.val_annomese,
            flg_gruppo,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
   --------------------------
   UNION ALL
     --------------------------
     SELECT a.cod_abi,
            a.val_annomese,
            flg_gruppo + 4 cod_q,
            SUM (a.val_rettifica_netta) val_rettifica_netta,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche a
      WHERE     0 = 0
            AND a.flg_gruppo NOT IN (1, 5)
            AND a.val_annomese_drc_cont < a.val_annomese_drc_dacont
   GROUP BY a.cod_abi,
            a.val_annomese,
            flg_gruppo,
            a.val_annomese_drc_cont,
            a.val_annomese_drc_dacont;
