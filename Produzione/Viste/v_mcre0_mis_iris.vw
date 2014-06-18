/* Formatted on 17/06/2014 18:05:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_IRIS
(
   COD_SNDG,
   DTA_RIFERIMENTO,
   VAL_IRIS_GRE,
   VAL_IRIS_CLI,
   VAL_LIV_RISCHIO_GRE,
   VAL_LIV_RISCHIO_CLI,
   VAL_LGD,
   DTA_LGD,
   VAL_EAD,
   DTA_EAD,
   VAL_PA,
   DTA_PA,
   VAL_PD_MONITORAGGIO,
   DTA_PD_MONITORAGGIO,
   VAL_RATING_MONITORAGGIO,
   DTA_INS,
   DTA_UPD,
   ID_DPER,
   VAL_IND_UTL_INTERNO,
   VAL_IND_UTL_ESTERNO,
   VAL_IND_UTL_COMPLESSIVO,
   VAL_IND_RATA,
   VAL_IND_ROTAZIONE,
   VAL_IND_INDEBITAMENTO,
   VAL_IND_INSOL_PORTAF,
   FLG_FATAL
)
AS
   WITH mis
        AS (SELECT DISTINCT a.COD_SNDG
              FROM t_mcre0_day_iris b, t_mcre0_day_fg a
             WHERE b.COD_SNDG(+) = a.COD_SNDG AND b.COD_SNDG IS NULL)
   SELECT a."COD_SNDG",
          a."DTA_RIFERIMENTO",
          a."VAL_IRIS_GRE",
          a."VAL_IRIS_CLI",
          a."VAL_LIV_RISCHIO_GRE",
          a."VAL_LIV_RISCHIO_CLI",
          a."VAL_LGD",
          a."DTA_LGD",
          a."VAL_EAD",
          a."DTA_EAD",
          a."VAL_PA",
          a."DTA_PA",
          a."VAL_PD_MONITORAGGIO",
          a."DTA_PD_MONITORAGGIO",
          a."VAL_RATING_MONITORAGGIO",
          a."DTA_INS",
          a."DTA_UPD",
          a."ID_DPER",
          a."VAL_IND_UTL_INTERNO",
          a."VAL_IND_UTL_ESTERNO",
          a."VAL_IND_UTL_COMPLESSIVO",
          a."VAL_IND_RATA",
          a."VAL_IND_ROTAZIONE",
          A."VAL_IND_INDEBITAMENTO",
          A."VAL_IND_INSOL_PORTAF",
          a."FLG_FATAL"
     FROM t_mcre0_dwh_iris a, mis
    WHERE A.COD_SNDG = MIS.COD_SNDG;


GRANT SELECT ON MCRE_OWN.V_MCRE0_MIS_IRIS TO MCRE_USR;
