/* Formatted on 21/07/2014 18:34:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_DIM_PRAT_FASE
(
   ID_DPER,
   RECORD_CHAR
)
AS
   SELECT TO_CHAR (SYSDATE, 'yyyymm') AS id_dper,                    --id_dper
             '00036'                                               --id_flusso
          || RPAD (TRIM (g.COD_TIPO), 100, ' ')                     --COD_TIPO
          || RPAD (TRIM (g.DESC_TIPO), 100, ' ')                   --DESC_TIPO
          || RPAD (TRIM (g.VAL_UTILIZZO), 100, ' ')             --VAL_UTILIZZO
          || '        '
          || 'QDC_DIM_PRAT_FASE'
     FROM T_MCRE0_CL_GEST g
    WHERE g.VAL_UTILIZZO IN ('FASE', 'TIPOLOGIA_PRATICA');
