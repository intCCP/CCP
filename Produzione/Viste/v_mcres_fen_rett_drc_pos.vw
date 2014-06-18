/* Formatted on 17/06/2014 18:12:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_RETT_DRC_POS
(
   COD_ABI,
   COD_NDG,
   VAL_DRC,
   FLG_VAL,
   COD_DIVISIONE,
   VAL_ANNOMESE_ULTIMO_SISBA,
   VAL_ANNOMESE_ULTIMO_SISBA_CP,
   VAL_ANNOMESE
)
AS
   SELECT Z."COD_ABI",
          Z.COD_NDG,
          z."VAL_DRC",
          z."FLG_VAL",
          z."COD_DIVISIONE",
          M.VAL_ANNOMESE_ULTIMO_SISBA,
          M.VAL_ANNOMESE_ULTIMO_SISBA_CP,
          M.VAL_ANNOMESE_ULTIMO_SISBA_CP VAL_ANNOMESE
     FROM (SELECT A.COD_ABI,
                  A.COD_NDG,
                  A.VAL_DRC_ULTIMO_MESE_CONT VAL_DRC,
                  5 flg_val,
                  NULL cod_divisione
             FROM V_MCRES_FEN_RETT_UcpCONT_POS a
           UNION ALL
             SELECT A.COD_ABI,
                    A.COD_NDG,
                    SUM (A.VAL_RVNETTE_ULTIMO_MESE_DACONT) VAL_DRC,
                    2 flg_val,
                    NULL cod_divisione
               FROM V_MCRES_FEN_RETT_RVDACON_POS A
           GROUP BY COD_ABI, A.COD_NDG
           UNION ALL
             SELECT A.COD_ABI,
                    A.COD_NDG,
                    SUM (A.VAL_rvytd) VAL_DRC,
                    3 flg_val,
                    cod_divisione
               FROM V_MCRES_FEN_RETT_RVYTD_pos A
           GROUP BY COD_ABI, A.COD_NDG, cod_divisione
           UNION ALL
           SELECT A.COD_ABI,
                  A.COD_NDG,
                  A.VAL_DRC_ytd VAL_DRC,
                  4 flg_val,
                  cod_divisione
             FROM V_MCRES_FEN_RETT_DRCYTD_pos A) Z,
          V_MCRES_APP_ULTIMO_ANNOMESE m;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_RETT_DRC_POS TO MCRE_USR;
