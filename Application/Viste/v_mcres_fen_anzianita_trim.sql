/* Formatted on 21/07/2014 18:43:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_ANZIANITA_TRIM
(
   COD_LABEL_TRIM,
   COD_ABI,
   VAL_TOT_GG,
   VAL_TOT_POSIZIONI
)
AS
     SELECT cod_label_trim,
            cod_abi,
            SUM (dta_fine - dta_inizio) val_tot_gg,
            COUNT (1) val_tot_posizioni
       FROM (SELECT cod_label_trim,
                    cod_abi,
                    cod_ndg,
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
                    AND TO_CHAR (dta_passaggio_soff, 'YYYYMM') <=
                           cod_label_trim
                    AND TO_CHAR (dta_chiusura, 'YYYYMM') >= cod_label_trim - 2)
   GROUP BY cod_abi, cod_label_trim;
