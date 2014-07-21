/* Formatted on 21/07/2014 18:41:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CRITERI_FILE
(
   LINE
)
AS
     SELECT REPLACE (
                  cod_presidio
               || (SELECT sigla
                     FROM T_MCRES_CL_province
                    WHERE     codice_regione = DESC_CRITERIO
                          AND codice = DESC_CRITERIO2)
               || RPAD (
                     SUBSTR (
                        CASE
                           WHEN DESC_CRITERIO2 IS NULL
                           THEN
                              CASE
                                 WHEN UPPER (desc_criterio) LIKE
                                         UPPER ('%Cartolarizzati%')
                                 THEN
                                    'RCEC' || desc_criterio
                                 WHEN UPPER (desc_criterio) LIKE
                                         UPPER ('%Esteri%')
                                 THEN
                                    'REEC' || desc_criterio
                                 WHEN UPPER (desc_criterio) LIKE
                                         UPPER ('%Fondi Terzi%')
                                 THEN
                                    'RTEC' || desc_criterio
                                 WHEN UPPER (desc_criterio) LIKE
                                         UPPER ('%Gic%')
                                 THEN
                                    'RGEC' || desc_criterio
                                 ELSE
                                    '  EC' || desc_criterio
                              END
                           ELSE
                              NULL
                        END,
                        1,
                        50),
                     50,
                     ' '),
               CHR (10),
               ' ')
               line
       FROM t_mcres_app_criteri
      WHERE dta_fine IS NULL
   ORDER BY NVL (val_priorita, 999);
