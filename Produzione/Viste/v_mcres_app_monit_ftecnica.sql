/* Formatted on 17/06/2014 18:10:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_MONIT_FTECNICA
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_GBV,
   VAL_NBV,
   VAL_IND_COP,
   COD_FTECNICA,
   DTA_INS
)
AS
   SELECT "COD_ABI",
          "VAL_ANNOMESE",
          "VAL_GBV",
          "VAL_NBV",
          "VAL_IND_COP",
          "COD_FTECNICA",
          "DTA_INS"
     FROM t_MCRES_FEN_MONIT_FTECNICA;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_MONIT_FTECNICA TO MCRE_USR;
