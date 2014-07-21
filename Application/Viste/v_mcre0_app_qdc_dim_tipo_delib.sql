/* Formatted on 21/07/2014 18:35:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_TIPO_DELIB
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,
             '00009'
          || LPAD (NVL (TRIM (cod_microtipologia), ' '), 2, ' ')
          || LPAD (NVL (TRIM (cod_macrotipologia), ' '), 2, ' ')
          || LPAD (NVL (TRIM (desc_microtipologia), ' '), 500, ' ')
          || LPAD (NVL (TRIM (desc_macrotipologia), ' '), 500, ' ')
          || '           '
          || 'QDC_DIM_ORG_DELIB'
     FROM t_mcrei_cl_tipologie
--WHERE FLG_ATTIVO=1
;
