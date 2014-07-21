/* Formatted on 21/07/2014 18:36:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_ARC
(
   ETL_LEVEL,
   TWS_LEVEL,
   TWS_SUBLEVEL,
   AREA,
   CALLER,
   STEP,
   SQL_ORD,
   SRC_TABLE,
   ARC_TABLE,
   SQL_TEXT
)
AS
   SELECT ETL_LEVEL,
          TWS_LEVEL,
          TWS_SUBLEVEL,
          AREA,
          CALLER,
          STEP,
          SQL_ORD,
          UPPER (staging_table) src_table,
          UPPER (archive_table) arc_table,
          sql_text
     FROM v_mcre0_etl_cfg
    WHERE flg_arc = 1;
