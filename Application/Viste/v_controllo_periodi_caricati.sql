/* Formatted on 21/07/2014 18:31:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CONTROLLO_PERIODI_CARICATI
(
   COD_ABI,
   COD_FLUSSO,
   P_2009_01,
   P_2009_02,
   P_2009_03,
   P_2009_04,
   P_2009_05,
   P_2009_06,
   P_2009_07,
   P_2009_08,
   P_2009_09,
   P_2009_10,
   P_2009_11,
   P_2009_12,
   P_2010_01,
   P_2010_02,
   P_2010_03,
   P_2010_04,
   P_2010_05,
   P_2010_06,
   P_2010_07,
   P_2010_08,
   P_2010_09,
   P_2010_10,
   P_2010_11,
   P_2010_12,
   P_2011_01,
   P_2011_02,
   P_2011_03,
   P_2011_04,
   P_2011_05,
   P_2011_06,
   P_2011_07,
   P_2011_08,
   P_2011_09,
   P_2011_10,
   P_2011_11,
   P_2011_12
)
AS
     SELECT Z.COD_ABI,
            C.COD_FLUSSO,
            P_2009_01,
            P_2009_02,
            P_2009_03,
            P_2009_04,
            P_2009_05,
            P_2009_06,
            P_2009_07,
            P_2009_08,
            P_2009_09,
            P_2009_10,
            P_2009_11,
            P_2009_12,
            P_2010_01,
            P_2010_02,
            P_2010_03,
            P_2010_04,
            P_2010_05,
            P_2010_06,
            P_2010_07,
            P_2010_08,
            P_2010_09,
            P_2010_10,
            P_2010_11,
            P_2010_12,
            P_2011_01,
            P_2011_02,
            P_2011_03,
            P_2011_04,
            P_2011_05,
            P_2011_06,
            P_2011_07,
            P_2011_08,
            P_2011_09,
            P_2011_10,
            P_2011_11,
            P_2011_12
       FROM (  SELECT B.COD_ABI,
                      a.COD_FLUSSO,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-01' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_01,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-02' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_02,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-03' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_03,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-04' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_04,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-05' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_05,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-06' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_06,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-07' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_07,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-08' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_08,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-09' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_09,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-10' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_10,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-11' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_11,
                      MAX (
                         CASE
                            WHEN PERIODO = '2009-12' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2009_12,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-01' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_01,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-02' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_02,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-03' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_03,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-04' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_04,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-05' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_05,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-06' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_06,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-07' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_07,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-08' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_08,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-09' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_09,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-10' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_10,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-11' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_11,
                      MAX (
                         CASE
                            WHEN PERIODO = '2010-12' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2010_12,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-01' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_01,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-02' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_02,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-03' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_03,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-04' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_04,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-05' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_05,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-06' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_06,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-07' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_07,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-08' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_08,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-09' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_09,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-10' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_10,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-11' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_11,
                      MAX (
                         CASE
                            WHEN PERIODO = '2011-12' THEN CARICATO_OK
                            ELSE NULL
                         END)
                         P_2011_12
                 FROM (  SELECT COD_FLUSSO,
                                COD_ABI,
                                TO_CHAR (ID_DPER, 'YYYY-MM') PERIODO,
                                DECODE (COD_STATO, 'CARICATO', 'OK', NULL)
                                   CARICATO_OK
                           FROM t_mcres_wrk_acquisizione
                          WHERE     COD_FLUSSO IN
                                       ('EFFETTI_ECONOMICI',
                                        'SISBA_CP',
                                        'MOVIMENTI_MOD_MOV')
                                AND COD_STATO = 'CARICATO'
                       GROUP BY COD_FLUSSO,
                                COD_ABI,
                                TO_CHAR (ID_DPER, 'YYYY-MM'),
                                DECODE (COD_STATO, 'CARICATO', 'OK', NULL)
                       ORDER BY 1, 2, 3) A,
                      (  SELECT COD_ABI, DESC_BREVE
                           FROM T_MCRES_APP_ISTITUTI
                          WHERE COD_ISTITUTO != 'XX'
                       ORDER BY DESC_BREVE) B
                WHERE B.COD_ABI = A.COD_ABI(+)
             GROUP BY B.COD_ABI, a.COD_FLUSSO) z,
            (SELECT 'SISBA_CP' COD_FLUSSO FROM DUAL
             UNION
             SELECT 'EFFETTI_ECONOMICI' COD_FLUSSO FROM DUAL
             UNION
             SELECT 'MOVIMENTI_MOD_MOV' COD_FLUSSO FROM DUAL) C
      WHERE C.COD_FLUSSO = Z.COD_FLUSSO(+)
   ORDER BY z.COD_ABI, c.COD_FLUSSO;
