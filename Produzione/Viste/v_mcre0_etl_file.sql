/* Formatted on 17/06/2014 18:05:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ETL_FILE
(
   ID_FILE,
   FILE_NAME,
   DIRECTORY_NAME,
   COD_FILE,
   EXT_TABLE_NAME,
   EXT_TABLE_NAME_DTA,
   EXT_TABLE_NAME_INC,
   EXT_TABLE_NAME_DTA_INC,
   FILE_NAME_INC,
   DIRECTORY_NAME_INC
)
AS
   SELECT id_file,
          --          CASE
          --             WHEN MAX (comp) OVER (PARTITION BY 1) <> comp THEN 0
          --             ELSE 1
          --          END
          --             FLG_FILE_EXISTS,
          a.location file_name,
          a.directory_name,
          cod_file,
          ext_table_name,
          ext_table_name_dta,
          ext_table_name_inc,
          ext_table_name_dta_inc,
          file_name_inc,
          directory_name_inc
     FROM (SELECT --SUBSTR (REPLACE (l.location, f.cod_file || '_', '), 1, 8)  comp,
                 l.*,
                  f.*,
                  i.location file_name_inc,
                  i.directory_name directory_name_inc
             FROM all_external_locations l,
                  t_mcre0_etl_file f,
                  all_external_locations i
            WHERE     l.owner = 'MCRE_OWN'
                  AND l.table_name = f.ext_table_name
                  AND i.owner = 'MCRE_OWN'
                  AND i.table_name = f.ext_table_name_inc) a;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ETL_FILE TO MCRE_USR;
