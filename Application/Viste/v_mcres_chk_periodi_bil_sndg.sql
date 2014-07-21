/* Formatted on 21/07/2014 18:43:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_CHK_PERIODI_BIL_SNDG
(
   COD_ABI,
   ABI,
   FLUSSO,
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
     SELECT B.COD_ABI,
            B.DESC_BREVE ABI,
            a.COD_FLUSSO flusso,
               MAX (
                  CASE WHEN PERIODO = '2009-01' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-01' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_01,
               MAX (
                  CASE WHEN PERIODO = '2009-02' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-02' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_02,
               MAX (
                  CASE WHEN PERIODO = '2009-03' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-03' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_03,
               MAX (
                  CASE WHEN PERIODO = '2009-04' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-04' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_04,
               MAX (
                  CASE WHEN PERIODO = '2009-05' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-05' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_05,
               MAX (
                  CASE WHEN PERIODO = '2009-06' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-06' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_06,
               MAX (
                  CASE WHEN PERIODO = '2009-07' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-07' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_07,
               MAX (
                  CASE WHEN PERIODO = '2009-08' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-08' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_08,
               MAX (
                  CASE WHEN PERIODO = '2009-09' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-09' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_09,
               MAX (
                  CASE WHEN PERIODO = '2009-10' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-10' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_10,
               MAX (
                  CASE WHEN PERIODO = '2009-11' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-11' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_11,
               MAX (
                  CASE WHEN PERIODO = '2009-12' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2009-12' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2009_12,
               MAX (
                  CASE WHEN PERIODO = '2010-01' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-01' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_01,
               MAX (
                  CASE WHEN PERIODO = '2010-02' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-02' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_02,
               MAX (
                  CASE WHEN PERIODO = '2010-03' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-03' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_03,
               MAX (
                  CASE WHEN PERIODO = '2010-04' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-04' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_04,
               MAX (
                  CASE WHEN PERIODO = '2010-05' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-05' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_05,
               MAX (
                  CASE WHEN PERIODO = '2010-06' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-06' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_06,
               MAX (
                  CASE WHEN PERIODO = '2010-07' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-07' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_07,
               MAX (
                  CASE WHEN PERIODO = '2010-08' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-08' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_08,
               MAX (
                  CASE WHEN PERIODO = '2010-09' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-09' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_09,
               MAX (
                  CASE WHEN PERIODO = '2010-10' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-10' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_10,
               MAX (
                  CASE WHEN PERIODO = '2010-11' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-11' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_11,
               MAX (
                  CASE WHEN PERIODO = '2010-12' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2010-12' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2010_12,
               MAX (
                  CASE WHEN PERIODO = '2011-01' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-01' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_01,
               MAX (
                  CASE WHEN PERIODO = '2011-02' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-02' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_02,
               MAX (
                  CASE WHEN PERIODO = '2011-03' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-03' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_03,
               MAX (
                  CASE WHEN PERIODO = '2011-04' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-04' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_04,
               MAX (
                  CASE WHEN PERIODO = '2011-05' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-05' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_05,
               MAX (
                  CASE WHEN PERIODO = '2011-06' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-06' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_06,
               MAX (
                  CASE WHEN PERIODO = '2011-07' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-07' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_07,
               MAX (
                  CASE WHEN PERIODO = '2011-08' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-08' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_08,
               MAX (
                  CASE WHEN PERIODO = '2011-09' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-09' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_09,
               MAX (
                  CASE WHEN PERIODO = '2011-10' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-10' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_10,
               MAX (
                  CASE WHEN PERIODO = '2011-11' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-11' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_11,
               MAX (
                  CASE WHEN PERIODO = '2011-12' THEN TOTALE_RECORD ELSE 0 END)
            || '('
            || MAX (
                  CASE
                     WHEN PERIODO = '2011-12' THEN totale_sndg_nulli
                     ELSE 0
                  END)
            || ')'
               P_2011_12
       FROM (SELECT S.*,
                    CASE
                       WHEN COD_FLUSSO = 'SISBA_CP'
                       THEN
                          (  SELECT COUNT (*) TOTALE_RECORD
                               FROM T_MCRES_APP_SISBA_CP C
                              WHERE     C.COD_ABI = S.COD_ABI
                                    AND C.ID_DPER = S.ID_DPER
                           GROUP BY COD_ABI, ID_DPER)
                    END
                       TOTALE_RECORD,
                    CASE
                       WHEN COD_FLUSSO = 'SISBA_CP'
                       THEN
                          (  SELECT COUNT (*) TOTALE_SNDG_NULLI
                               FROM T_MCRES_SC_VINCOLI_SISBA_CP P
                              WHERE     P.ID_FLUSSO = S.ID_FLUSSO
                                    AND P.ID_DPER = S.ID_DPER
                                    AND P.COD_ABI = S.COD_ABI
                                    AND P.COD_SNDG IS NULL
                           GROUP BY ID_FLUSSO, COD_ABI, ID_DPER)
                    END
                       TOTALE_SNDG_NULLI
               FROM (  SELECT COD_FLUSSO,
                              COD_ABI,
                              TO_CHAR (ID_DPER, 'YYYYMMDD') ID_DPER,
                              TO_CHAR (ID_DPER, 'YYYY-MM') PERIODO,
                              DECODE (COD_STATO, 'CARICATO', 'OK', NULL)
                                 CARICATO_OK,
                              MAX (
                                   A.VAL_SCARTI_CONVERT
                                 + A.VAL_SCARTI_EXTERNAL
                                 + A.VAL_SCARTI_VINCOLI)
                                 TOTALE_SCARTI,
                              MAX (ID_FLUSSO) ID_FLUSSO
                         FROM t_mcres_wrk_acquisizione a
                        WHERE     COD_FLUSSO = 'SISBA_CP'
                              AND COD_STATO IN ('CARICATO', 'RIMOSSO')
                              AND ID_FLUSSO > 0
                     GROUP BY COD_FLUSSO,
                              COD_ABI,
                              TO_CHAR (ID_DPER, 'YYYYMMDD'),
                              TO_CHAR (ID_DPER, 'YYYY-MM'),
                              DECODE (COD_STATO, 'CARICATO', 'OK', NULL)) S) A,
            (  SELECT COD_ABI, DESC_BREVE
                 FROM T_MCRES_APP_ISTITUTI
                WHERE COD_ISTITUTO != 'XX'
             ORDER BY DESC_BREVE) B
      WHERE B.COD_ABI = A.COD_ABI(+)
   GROUP BY B.COD_ABI, B.DESC_BREVE, A.COD_FLUSSO
   ORDER BY B.DESC_BREVE, a.COD_FLUSSO;
