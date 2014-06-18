/* Formatted on 17/06/2014 18:09:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ANZIANITA_TRIM
(
   COD_LABEL_TRIM,
   VAL_NUM_POS
)
AS
     SELECT cod_label_trim, AVG (dta_fine - dta_inizio) / 365 val_num_pos
       FROM (SELECT cod_label_trim,
                    dta_passaggio_soff dta_inizio,
                    dta_chiusura,
                    CASE
                       WHEN TO_CHAR (dta_chiusura, 'YYYYMM') > cod_label_trim
                       THEN
                          LAST_DAY (TO_DATE (cod_label_trim, 'YYYYMM'))
                       ELSE
                          dta_chiusura
                    END
                       dta_fine
               FROM t_mcres_app_posizioni, v_mcres_app_lista_trimestri
              WHERE     0 = 0
                    AND DTA_PASSAGGIO_SOFF <=
                           LAST_DAY (TO_DATE (COD_LABEL_TRIM, 'YYYYMM'))
                    AND DTA_CHIUSURA >=
                           ADD_MONTHS (TO_DATE (COD_LABEL_TRIM, 'YYYYMM'), -2)
                    AND COD_LABEL_TRIM <= TO_CHAR (SYSDATE, 'YYYYMM'))
   GROUP BY cod_label_trim;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ANZIANITA_TRIM TO MCRE_USR;
