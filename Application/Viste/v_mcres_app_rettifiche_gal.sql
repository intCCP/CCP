/* Formatted on 21/07/2014 18:42:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_GAL
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_Q,
   VAL_RETTIFICA_NETTA,
   VAL_ANNOMESE_DRC_CONT,
   VAL_ANNOMESE_DRC_DACONT
)
AS
   SELECT                                  --RV trimestrali (dati di bilancio)
         cod_abi,
          val_annomese,
          TRUNC ( (SUBSTR (val_annomese, 5, 2) - 1) / 3) + 1 cod_q,
          SUM (
             val_rettifica_netta)
          OVER (
             PARTITION BY cod_abi,
                          SUBSTR (val_annomese, 1, 4),
                          TRUNC ( (SUBSTR (val_annomese, 5, 2) - 1) / 3) + 1
             ORDER BY SUBSTR (val_annomese, 5, 2))
             val_rettifica_netta,
          TO_NUMBER (NULL) val_annomese_drc_cont,
          TO_NUMBER (NULL) val_annomese_drc_dacont
     FROM (  SELECT cod_abi,
                    val_annomese,
                    SUM (val_rettifica_netta) val_rettifica_netta
               FROM t_mcres_fen_rettifiche
              WHERE flg_gruppo = 1
           GROUP BY cod_abi, val_annomese)
   UNION ALL
     SELECT                                           --RV mese contabilizzato
           cod_abi,
            val_annomese,
            5 cod_q,
            SUM (val_rettifica_netta) val_rettifica_netta,
            TO_NUMBER (NULL) val_annomese_drc_cont,
            TO_NUMBER (NULL) val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche
      WHERE flg_gruppo = 1
   GROUP BY cod_abi, val_annomese
   UNION ALL
     SELECT                                  -- di cui DRC mese contabilizzato
           cod_abi,
            val_annomese,
            9 cod_q,
            SUM (val_rettifica_netta) val_rettifica_netta,
            TO_NUMBER (NULL) val_annomese_drc_cont,
            TO_NUMBER (NULL) val_annomese_drc_dacont
       FROM t_mcres_fen_rettifiche
      WHERE flg_gruppo = 2
   GROUP BY cod_abi, val_annomese
   UNION ALL
   SELECT                                         --RV anno (dati di bilancio)
         cod_abi,
          val_annomese,
          13 cod_q,
          SUM (
             val_rettifica_netta)
          OVER (PARTITION BY cod_abi, SUBSTR (val_annomese, 1, 4)
                ORDER BY SUBSTR (val_annomese, 5, 2))
             val_rettifica_netta,
          TO_NUMBER (NULL) val_annomese_drc_cont,
          TO_NUMBER (NULL) val_annomese_drc_dacont
     FROM (  SELECT cod_abi,
                    val_annomese,
                    SUM (val_rettifica_netta) val_rettifica_netta
               FROM t_mcres_fen_rettifiche
              WHERE flg_gruppo = 1
           GROUP BY cod_abi, val_annomese)
   UNION ALL
   SELECT                                         --RV anno (dati di bilancio)
         cod_abi,
          val_annomese,
          14 cod_q,
          SUM (
             val_rettifica_netta)
          OVER (PARTITION BY cod_abi, SUBSTR (val_annomese, 1, 4)
                ORDER BY SUBSTR (val_annomese, 5, 2))
             val_rettifica_netta,
          TO_NUMBER (NULL) val_annomese_drc_cont,
          TO_NUMBER (NULL) val_annomese_drc_dacont
     FROM (  SELECT cod_abi,
                    val_annomese,
                    SUM (val_rettifica_netta) val_rettifica_netta
               FROM t_mcres_fen_rettifiche
              WHERE flg_gruppo = 2
           GROUP BY cod_abi, val_annomese);
