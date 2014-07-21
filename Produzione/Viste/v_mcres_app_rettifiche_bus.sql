/* Formatted on 17/06/2014 18:11:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RETTIFICHE_BUS
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_LABEL,
   VAL_RETTIFICA_TRIM,
   VAL_RETTIFICA_TRIM_DRC,
   VAL_RETTIFICA_YTD,
   VAL_RETTIFICA_YTD_DRC
)
AS
   SELECT a.cod_abi,
          a.val_annomese,
          a.cod_divisione cod_label,
          val_rettifica_trim,
          val_rettifica_trim_drc,
          val_rettifica_ytd,
          val_rettifica_ytd_drc
     FROM (  SELECT cod_abi,
                    t.val_annomese,
                    cod_divisione,
                    SUM (DECODE (flg_gruppo, 1, val_rettifica_netta, 0))
                       val_rettifica_trim,
                    SUM (DECODE (flg_gruppo, 2, val_rettifica_netta, 0))
                       val_rettifica_trim_drc
               FROM t_mcres_fen_rettifiche r, t_mcres_app_trim_rv t
              WHERE 0 = 0 AND r.val_annomese = t.val_am_trim
           GROUP BY cod_abi, t.val_annomese, cod_divisione) a,
          (SELECT c.cod_abi,
                  val_annomese,
                  c.cod_divisione,
                  c.val_rv + NVL (s.val_rv, 0) val_rettifica_ytd,
                  c.val_drc + NVL (s.val_drc, 0) val_rettifica_ytd_drc
             FROM (  SELECT r.cod_abi,
                            a.val_annomese,
                            cod_divisione,
                            SUM (
                               DECODE (flg_gruppo, 1, r.val_rettifica_netta, 0))
                               val_rv,
                            SUM (
                               DECODE (flg_gruppo, 2, r.val_rettifica_netta, 0))
                               val_drc
                       FROM t_mcres_fen_rettifiche r, T_MCRES_APP_AM_RV a
                      WHERE 0 = 0 AND a.val_am_prec = r.val_annomese
                   GROUP BY r.cod_abi, a.val_annomese, cod_divisione) c,
                  (SELECT cod_abi,
                          cod_divisione,
                          val_rv,
                          val_drc
                     FROM t_mcres_fen_rettifiche_sisba) s
            WHERE     0 = 0
                  AND c.cod_abi = s.cod_abi(+)
                  AND c.cod_divisione = s.cod_divisione(+)) b
    WHERE     0 = 0
          AND a.cod_abi = b.cod_abi
          AND a.cod_divisione = b.cod_divisione
          AND a.val_annomese = b.val_annomese;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_RETTIFICHE_BUS TO MCRE_USR;
