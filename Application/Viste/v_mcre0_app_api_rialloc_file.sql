/* Formatted on 21/07/2014 18:33:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_API_RIALLOC_FILE
(
   RECORD_CHAR
)
AS
   SELECT CASE
             WHEN SUBSTR (record_char, 1, 10) = '0000000000'
             THEN
                RPAD (SUBSTR (record_char, 11, 8), 60, ' ')
             ELSE
                record_char
          END
             AS record_char
     FROM (SELECT RPAD ('0000000000' || TO_CHAR (SYSDATE, 'ddmmyyyy'),
                        60,
                        ' ')
                     AS record_char
             FROM DUAL
           UNION
           SELECT    NVL (COD_ABI_ISTITUTO, '     ')
                  || COD_ABI_CARTOLARIZZATO
                  || NVL (COD_NDG, '                ')
                  || NVL (RPAD (COD_STATO, 2, ' '), '  ')
                  || NVL (FLG_OUTSOURCING, ' ')
                  || NVL (RPAD (COD_MATRICOLA, 7, ' '), '       ')
                  || NVL (
                        RPAD (SUBSTR (COD_STRUTTURA_COMPETENTE, -5, 5),
                              5,
                              ' '),
                        'NULL ')
                  || '                   '
                     AS record_char
             FROM V_MCRE0_APP_API_RIALLOC
           ORDER BY record_char ASC);
