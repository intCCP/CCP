/* Formatted on 17/06/2014 18:13:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FORI_ABILITATI_EPC
(
   LINE
)
AS
   SELECT REPLACE (
                RPAD (NVL (cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (NVL (val_foro1, ' '), 50, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni
    WHERE cod_user_id IS NOT NULL AND val_foro1 IS NOT NULL
   UNION
   SELECT REPLACE (
                RPAD (NVL (cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (NVL (val_foro2, ' '), 50, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni
    WHERE cod_user_id IS NOT NULL AND val_foro2 IS NOT NULL
   UNION
   SELECT REPLACE (
                RPAD (NVL (cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (NVL (val_foro3, ' '), 50, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni
    WHERE cod_user_id IS NOT NULL AND val_foro3 IS NOT NULL
   UNION
   SELECT REPLACE (
                RPAD (NVL (cod_user_id, ' '), 15, ' ')
             || ';'
             || RPAD (NVL (val_foro4, ' '), 50, ' '),
             CHR (10),
             ' ')
             line
     FROM t_mcres_app_legali_esterni
    WHERE cod_user_id IS NOT NULL AND val_foro4 IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRES_FORI_ABILITATI_EPC TO MCRE_USR;
