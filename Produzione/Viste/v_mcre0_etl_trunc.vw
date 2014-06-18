/* Formatted on 17/06/2014 18:05:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_TRUNC
(
   ETL_LEVEL,
   TWS_LEVEL,
   TWS_SUBLEVEL,
   AREA,
   CALLER,
   STEP,
   SQL_ORD,
   SQL_TEXT,
   FLG_ARC,
   FLG_TRUNC,
   FLG_STATS,
   FLG_STAGE,
   COD_FILE,
   ARCHIVE_TABLE,
   TRUNCATE_TABLE,
   STAGING_TABLE
)
AS
   SELECT "ETL_LEVEL",
          "TWS_LEVEL",
          "TWS_SUBLEVEL",
          "AREA",
          "CALLER",
          "STEP",
          "SQL_ORD",
          "SQL_TEXT",
          "FLG_ARC",
          "FLG_TRUNC",
          "FLG_STATS",
          "FLG_STAGE",
          "COD_FILE",
          "ARCHIVE_TABLE",
          "TRUNCATE_TABLE",
          "STAGING_TABLE"
     FROM v_mcre0_etl_cfg
    WHERE flg_trunc = 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ETL_TRUNC TO MCRE_USR;
