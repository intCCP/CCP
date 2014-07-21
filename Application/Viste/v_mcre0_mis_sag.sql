/* Formatted on 21/07/2014 18:37:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_SAG
(
   COD_SNDG,
   COD_SAG,
   DTA_CALCOLO_SAG,
   FLG_ALLINEAMENTO,
   FLG_CONFERMA,
   DTA_CONFERMA,
   DTA_INS,
   DTA_UPD,
   ID_DPER
)
AS
   WITH mis
        AS (SELECT DISTINCT a.COD_SNDG
              FROM t_mcre0_day_sag b, t_mcre0_day_fg a
             WHERE b.COD_SNDG(+) = a.COD_SNDG AND b.COD_SNDG IS NULL)
   SELECT a."COD_SNDG",
          a."COD_SAG",
          a."DTA_CALCOLO_SAG",
          a."FLG_ALLINEAMENTO",
          a."FLG_CONFERMA",
          a."DTA_CONFERMA",
          a."DTA_INS",
          a."DTA_UPD",
          a."ID_DPER"
     FROM t_mcre0_dwh_sag a, mis
    WHERE a.COD_SNDG = mis.COD_SNDG;
