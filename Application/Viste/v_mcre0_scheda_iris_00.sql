/* Formatted on 21/07/2014 18:37:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_SCHEDA_IRIS_00
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
     SELECT DISTINCT cod_sndg,
                     ordine,
                     generale,
                     MAX (d1) mese1,
                     MAX (d2) mese2,
                     MAX (d3) mese3,
                     MAX (d4) mese4,
                     MAX (d5) mese5,
                     MAX (d6) mese6,
                     MAX (d7) mese7
       FROM (SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    0 ordine,
                    '' generale,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -6), 'MM'), 'MONth')
                       d1,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -5), 'MM'), 'MONth')
                       d2,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -4), 'MM'), 'MONth')
                       d3,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -3), 'MM'), 'MONth')
                       d4,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -2), 'MM'), 'MONth')
                       d5,
                    TO_CHAR (TRUNC (ADD_MONTHS (max_per, -1), 'MM'), 'MONth')
                       d6,
                    TO_CHAR (TRUNC (max_per, 'MM'), 'MONth') d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    2 ordine,
                    'Iris' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_iris_cli, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_iris_cli) val_iris_cli
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    1 ordine,
                    'Livello di Rischio' generale,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -6)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d1,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -5)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d2,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -4)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d3,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -3)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d4,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -2)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d5,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, -1)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d6,
                    CASE
                       WHEN TO_DATE (id_dper, 'yyyymm') =
                               ADD_MONTHS (max_per, 0)
                       THEN
                          val_liv_rischio_cli
                       ELSE
                          NULL
                    END
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_liv_rischio_cli) val_liv_rischio_cli
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    3 ordine,
                    'IRIS a livello di gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (VAL_IRIS_GRE, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (VAL_IRIS_GRE) VAL_IRIS_GRE
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    4 ordine,
                    'Indebitamento' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_indebitamento, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_indebitamento) val_ind_indebitamento
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    5 ordine,
                    'Rotazione' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_rotazione, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_rotazione) val_ind_rotazione
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    6 ordine,
                    'Utilizzi gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_utl_complessivo, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_utl_complessivo)
                                 val_ind_utl_complessivo
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    7 ordine,
                    'Prestiti diretti' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_rata, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_rata) val_ind_rata
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    8 ordine,
                    'Utilizzi esterni al gruppo' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_utl_esterno, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_utl_esterno) val_ind_utl_esterno
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per
             UNION
             SELECT cod_sndg,
                    TO_DATE (id_dper, 'yyyymm'),
                    9 ordine,
                    '% Insoluti Portafoglio Comm.' generale,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -6)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d1,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -5)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d2,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -4)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d3,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -3)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d4,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -2)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d5,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, -1)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d6,
                    TO_CHAR (
                       CASE
                          WHEN TO_DATE (id_dper, 'yyyymm') =
                                  ADD_MONTHS (max_per, 0)
                          THEN
                             TO_CHAR (val_ind_insol_portaf, '999990D99')
                          ELSE
                             NULL
                       END)
                       d7
               FROM (  SELECT cod_sndg,
                              id_dper,
                              MAX (TO_DATE (id_dper, 'yyyymm'))
                                 OVER (PARTITION BY cod_sndg)
                                 max_per,
                              ADD_MONTHS (
                                 MAX (TO_DATE (id_dper, 'yyyymm'))
                                    OVER (PARTITION BY cod_sndg),
                                 -6)
                                 AS min_per,
                              MAX (val_ind_insol_portaf) val_ind_insol_portaf
                         FROM t_mcre0_app_iris_storico
                     GROUP BY cod_sndg, id_dper)
              WHERE TO_DATE (id_dper, 'yyyymm') BETWEEN min_per AND max_per)
   GROUP BY cod_sndg, ordine, generale
   ORDER BY cod_sndg, ordine;
