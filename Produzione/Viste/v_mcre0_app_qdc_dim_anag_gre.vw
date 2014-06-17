/* Formatted on 17/06/2014 18:02:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_ANAG_GRE
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00001'
          || LPAD (NVL (TRIM (cod_gre), ' '), 8, ' ')
          || RPAD (NVL (TRIM (val_ana_gre), ' '), 60, ' ')
          || '           '
          || 'QDC_DIM_ANAG_GRE'
     FROM t_mcre0_app_anagr_gre
    WHERE cod_gre <> -1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM_ANAG_GRE TO MCRE_USR;
