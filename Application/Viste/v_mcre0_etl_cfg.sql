/* Formatted on 21/07/2014 18:37:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_CFG
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
   SELECT A."ETL_LEVEL",
          A."TWS_LEVEL",
          A."TWS_SUBLEVEL",
          A."AREA",
          A."CALLER",
          A."STEP",
          A."SQL_ORD",
          A."SQL_TEXT",
          flg_arc,
          A."FLG_TRUNC",
          A."FLG_STATS",
          A."FLG_STAGE",
          --          A."EXT_TABLE_NAME",
          --          A."EXT_TABLE_NAME_DTA",
          --          A."FILE_NAME",
          --          A.DIRECTORY_NAME,
          COD_FILE,
          CASE
             WHEN FLG_ARC = 1
             THEN
                UPPER (
                   TO_CHAR (
                      TRIM (
                         SUBSTR (
                            TRIM (
                               REPLACE (LOWER (sql_text), 'insert into', '')),
                            1,
                              INSTR (
                                 TRIM (
                                    REPLACE (LOWER (sql_text),
                                             'insert into',
                                             '')),
                                 'select')
                            - 1))))
             ELSE
                ''
          END
             ARCHIVE_TABLE,
          CASE
             WHEN FLG_TRUNC = 1
             THEN
                UPPER (
                   TO_CHAR (
                      TRIM (
                         SUBSTR (
                            TRIM (
                               REPLACE (LOWER (sql_text),
                                        'truncate table',
                                        '')),
                            1,
                              INSTR (
                                 TRIM (
                                    REPLACE (LOWER (sql_text),
                                             'truncate table',
                                             '')),
                                 'reuse storage')
                            - 1))))
             ELSE
                ''
          END
             TRUNCATE_TABLE,
          CASE
             WHEN FLG_ARC = 1
             THEN
                REPLACE (
                   UPPER (
                      TO_CHAR (
                         TRIM (
                            SUBSTR (
                               TRIM (
                                  REPLACE (LOWER (sql_text),
                                           'insert into',
                                           '')),
                               1,
                                 INSTR (
                                    TRIM (
                                       REPLACE (LOWER (sql_text),
                                                'insert into',
                                                '')),
                                    'select')
                               - 1)))),
                   'STH',
                   'STG')
             WHEN FLG_STAGE = 1
             THEN
                UPPER (
                   TO_CHAR (
                      TRIM (
                         SUBSTR (
                            TRIM (
                               REPLACE (LOWER (sql_text), 'insert into', '')),
                            1,
                              INSTR (
                                 TRIM (
                                    REPLACE (LOWER (sql_text),
                                             'insert into',
                                             '')),
                                 'select')
                            - 1))))
             ELSE
                ''
          END
             STAGING_TABLE
     FROM (  SELECT c.etl_level,
                    c.tws_level,
                    c.tws_sublevel,
                    c.area,
                    c.caller,
                    e.step,
                    e.sql_ord,
                    e.sql_text,
                    CASE
                       WHEN LOWER (e.sql_text) LIKE '%insert into t_mcre0_sth%'
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_arc,
                    CASE
                       WHEN LOWER (e.sql_text) LIKE '%truncate%' THEN 1
                       ELSE 0
                    END
                       flg_trunc,
                    CASE
                       WHEN LOWER (e.sql_text) LIKE '%dbms_stats%' THEN 1
                       ELSE 0
                    END
                       flg_stats,
                    CASE
                       WHEN LOWER (e.sql_text) LIKE
                               '%insert%t_mcre0_stg%select%' --and  LOWER (e.sql_text) NOT LIKE '%insert into t_mcre0_sth%'
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_stage,
                    --                    f.ext_table_name,
                    --                    f.ext_table_name_dta,
                    --                    f.file_name,
                    --                    f.directory_name,
                    c.area COD_FILE
               FROM t_mcre0_etl_cfg c, t_mcre0_etl_caller e --, v_mcre0_etl_file f
              WHERE                               --   c.area = f.cod_file AND
                   c.caller = e.caller AND e.flg_exec = 1
           ORDER BY c.etl_level,
                    c.tws_level,
                    c.tws_sublevel,
                    e.sql_ord) A;
