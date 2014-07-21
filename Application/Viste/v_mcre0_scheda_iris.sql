/* Formatted on 21/07/2014 18:37:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_SCHEDA_IRIS
(
   COD_SNDG,
   ORDINE,
   GENERALE,
   MESE1,
   MESE2,
   MESE3,
   MESE4,
   MESE5,
   MESE6,
   MESE7
)
AS
     SELECT DISTINCT COD_SNDG,
                     ORDINE,
                     GENERALE,
                     MAX (D1) MESE1,
                     MAX (D2) MESE2,
                     MAX (d3) mese3,
                     MAX (d4) mese4,
                     MAX (d5) mese5,
                     MAX (d6) mese6,
                     MAX (d7) mese7
       FROM (SELECT cod_sndg,
                    dta_riferimento,
                    0 ordine,
                    '' generale,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -6), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d1,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -5), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d2,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -4), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d3,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -3), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d4,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -2), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d5,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -1), 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d6,
                    TO_CHAR (TRUNC (max_per, 'MM'),
                             'MONth',
                             'NLS_DATE_LANGUAGE = ITALIAN')
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    2 ordine,
                    'Iris' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_iris_cli) val_iris_cli
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    1 ordine,
                    'Livello di Rischio' generale,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d1,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d2,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d3,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d4,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d5,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d6,
                    CASE
                       WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_liv_rischio_cli) val_liv_rischio_cli
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    3 ordine,
                    'IRIS a livello di gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_iris_gre, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_iris_gre) val_iris_gre
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    4 ordine,
                    'Indebitamento' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_indebitamento) val_ind_indebitamento
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    5 ordine,
                    'Rotazione' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_rotazione) val_ind_rotazione
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    6 ordine,
                    'Utilizzi gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_utl_complessivo)
                                 val_ind_utl_complessivo
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    7 ordine,
                    'Prestiti diretti' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_rata) val_ind_rata
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    8 ordine,
                    'Utilizzi esterni al gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_utl_esterno) val_ind_utl_esterno
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, dta_riferimento)
              WHERE dta_riferimento BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    dta_riferimento,
                    9 ordine,
                    '% Insoluti Portafoglio Comm.' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_insol_portaf) val_ind_insol_portaf
                         FROM t_mcre0_app_iris_storico
                     GROUP BY COD_SNDG, DTA_RIFERIMENTO)
              WHERE DTA_RIFERIMENTO BETWEEN MIN_PER AND MAX_PER
             ----------------------------------------
             UNION
             SELECT COD_SNDG,
                    DTA_RIFERIMENTO,
                    10 ORDINE,
                    'Flag Fatal' generale,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       D6,
                    TO_CHAR (
                       CASE
                          WHEN dta_riferimento = ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (FLG_FATAL)
                          ELSE
                             NULL
                       END)
                       D7
               FROM (  SELECT cod_sndg,
                              dta_riferimento,
                              flg_Fatal,
                              MAX (dta_riferimento) OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (dta_riferimento)
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_insol_portaf) val_ind_insol_portaf
                         FROM t_mcre0_app_iris_storico
                     GROUP BY COD_SNDG, DTA_RIFERIMENTO, flg_fatal)
              WHERE DTA_RIFERIMENTO BETWEEN MIN_PER AND MAX_PER)
   -- where cod_sndg='0000000000415543'
   GROUP BY cod_sndg, ordine, generale
   ORDER BY cod_sndg, ordine;
