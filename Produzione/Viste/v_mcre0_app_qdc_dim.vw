/* Formatted on 17/06/2014 18:02:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_anag_gre
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_istituti
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_stati
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_strutt_org
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_utenti
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_comparti
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_processi
   UNION
   SELECT id_dper, RPAD (record_char, 400, ' ')
     FROM v_mcre0_app_qdc_dim_org_delib
   UNION
   SELECT id_dper, RPAD (record_char, 1050, ' ')
     FROM v_mcre0_app_qdc_dim_tipo_delib;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_QDC_DIM TO MCRE_USR;
