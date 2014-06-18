/* Formatted on 17/06/2014 18:12:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETTIFICHE_DRC
(
   COD_ABI,
   VAL_DRC,
   FLG_VAL,
   COD_DIVISIONE,
   VAL_ANNOMESE_ULTIMO_SISBA,
   VAL_ANNOMESE_ULTIMO_SISBA_CP,
   VAL_ANNOMESE
)
AS
   SELECT z."COD_ABI",
          z."VAL_DRC",
          z."FLG_VAL",
          z."COD_DIVISIONE",
          M.VAL_ANNOMESE_ULTIMO_SISBA,
          M.VAL_ANNOMESE_ULTIMO_SISBA_CP,
          M.VAL_ANNOMESE_ULTIMO_SISBA_CP VAL_ANNOMESE
     FROM (SELECT A.COD_ABI,
                  A.VAL_DRC_ULTIMO_MESE_CONT VAL_DRC,
                  5 flg_val,
                  NULL cod_divisione
             FROM V_MCRES_FEN_RETTIFICHE_UcpCONT a
           UNION ALL
             SELECT A.COD_ABI,
                    SUM (A.VAL_RVNETTE_ULTIMO_MESE_DACONT) VAL_DRC,
                    2 flg_val,
                    NULL cod_divisione
               FROM V_MCRES_FEN_RETTIFICHE_RVDACON A
           GROUP BY COD_ABI
           UNION ALL
           SELECT A.COD_ABI,
                  A.VAL_DRC_ULTIMO_MESE_DACONT VAL_DRC,
                  6 flg_val,
                  NULL cod_divisione
             FROM V_MCRES_FEN_RETTIFICHE_UDACONT A
           UNION ALL
             SELECT A.COD_ABI,
                    SUM (A.VAL_rvytd) VAL_DRC,
                    3 flg_val,
                    cod_divisione
               FROM V_MCRES_FEN_RETTIFICHE_RVYTD A
           GROUP BY COD_ABI, cod_divisione
           UNION ALL
           SELECT A.COD_ABI,
                  A.VAL_DRC_ytd VAL_DRC,
                  4 flg_val,
                  cod_divisione
             FROM V_MCRES_FEN_RETTIFICHE_DRCYTD A
           UNION ALL
           SELECT A.COD_ABI,
                  A.VAL_RETTIFICA_MESE_TRIM VAL_DRC,
                  8 flg_val,
                  cod_divisione
             FROM V_MCRES_FEN_RETTIFICHE_TRIM A
           UNION ALL
           SELECT A.COD_ABI,
                  A.VAL_DRC_TRIM VAL_DRC,
                  7 flg_val,
                  cod_divisione
             FROM V_MCRES_FEN_RETTIFICHE_trim A) Z,
          V_MCRES_APP_ULTIMO_ANNOMESE m;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETTIFICHE_DRC TO MCRE_USR;
