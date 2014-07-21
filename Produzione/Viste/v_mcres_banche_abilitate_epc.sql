/* Formatted on 17/06/2014 18:11:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_BANCHE_ABILITATE_EPC
(
   LINE
)
AS
   SELECT REPLACE (
                RPAD (NVL (lg.cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (NVL (pa.cod_abi, ' '), 5, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni lg
          JOIN t_mcres_cl_presidio_abi pa
             ON (lg.cod_presidio = pa.cod_presidio)
    WHERE cod_user_id IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRES_BANCHE_ABILITATE_EPC TO MCRE_USR;
