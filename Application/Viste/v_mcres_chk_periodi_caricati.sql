/* Formatted on 21/07/2014 18:43:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_CHK_PERIODI_CARICATI
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
     SELECT b.cod_abi,
            b.desc_breve abi,
            a.cod_flusso flusso,
            MAX (CASE WHEN periodo = '2009-01' THEN caricato_ok ELSE NULL END)
               P0901,
            MAX (CASE WHEN periodo = '2009-02' THEN caricato_ok ELSE NULL END)
               P0902,
            MAX (CASE WHEN periodo = '2009-03' THEN caricato_ok ELSE NULL END)
               P0903,
            MAX (CASE WHEN periodo = '2009-04' THEN caricato_ok ELSE NULL END)
               P0904,
            MAX (CASE WHEN periodo = '2009-05' THEN caricato_ok ELSE NULL END)
               P0905,
            MAX (CASE WHEN periodo = '2009-06' THEN caricato_ok ELSE NULL END)
               P0906,
            MAX (CASE WHEN periodo = '2009-07' THEN caricato_ok ELSE NULL END)
               P0907,
            MAX (CASE WHEN periodo = '2009-08' THEN caricato_ok ELSE NULL END)
               P0908,
            MAX (CASE WHEN periodo = '2009-09' THEN caricato_ok ELSE NULL END)
               P0909,
            MAX (CASE WHEN periodo = '2009-10' THEN caricato_ok ELSE NULL END)
               P0910,
            MAX (CASE WHEN periodo = '2009-11' THEN caricato_ok ELSE NULL END)
               P0911,
            MAX (CASE WHEN periodo = '2009-12' THEN caricato_ok ELSE NULL END)
               P0912,
            MAX (CASE WHEN periodo = '2010-01' THEN caricato_ok ELSE NULL END)
               P1001,
            MAX (CASE WHEN periodo = '2010-02' THEN caricato_ok ELSE NULL END)
               P1002,
            MAX (CASE WHEN periodo = '2010-03' THEN caricato_ok ELSE NULL END)
               P1003,
            MAX (CASE WHEN periodo = '2010-04' THEN caricato_ok ELSE NULL END)
               P1004,
            MAX (CASE WHEN periodo = '2010-05' THEN caricato_ok ELSE NULL END)
               P1005,
            MAX (CASE WHEN periodo = '2010-06' THEN caricato_ok ELSE NULL END)
               P1006,
            MAX (CASE WHEN periodo = '2010-07' THEN caricato_ok ELSE NULL END)
               P1007,
            MAX (CASE WHEN periodo = '2010-08' THEN caricato_ok ELSE NULL END)
               P1008,
            MAX (CASE WHEN periodo = '2010-09' THEN caricato_ok ELSE NULL END)
               P1009,
            MAX (CASE WHEN periodo = '2010-10' THEN caricato_ok ELSE NULL END)
               P1010,
            MAX (CASE WHEN periodo = '2010-11' THEN caricato_ok ELSE NULL END)
               P1011,
            MAX (CASE WHEN periodo = '2010-12' THEN caricato_ok ELSE NULL END)
               P1012,
            MAX (CASE WHEN periodo = '2011-01' THEN caricato_ok ELSE NULL END)
               P1101,
            MAX (CASE WHEN periodo = '2011-02' THEN caricato_ok ELSE NULL END)
               P1102,
            MAX (CASE WHEN periodo = '2011-03' THEN caricato_ok ELSE NULL END)
               P1103,
            MAX (CASE WHEN periodo = '2011-04' THEN caricato_ok ELSE NULL END)
               P1104,
            MAX (CASE WHEN periodo = '2011-05' THEN caricato_ok ELSE NULL END)
               P1105,
            MAX (CASE WHEN periodo = '2011-06' THEN caricato_ok ELSE NULL END)
               P1106,
            MAX (CASE WHEN periodo = '2011-07' THEN caricato_ok ELSE NULL END)
               P1107,
            MAX (CASE WHEN periodo = '2011-08' THEN caricato_ok ELSE NULL END)
               P1108,
            MAX (CASE WHEN periodo = '2011-09' THEN caricato_ok ELSE NULL END)
               P1109,
            MAX (CASE WHEN periodo = '2011-10' THEN caricato_ok ELSE NULL END)
               P1110,
            MAX (CASE WHEN periodo = '2011-11' THEN caricato_ok ELSE NULL END)
               P1111,
            MAX (CASE WHEN periodo = '2011-12' THEN caricato_ok ELSE NULL END)
               P1112
       FROM (  SELECT SUBSTR (cod_flusso, 1, 2) cod_flusso,
                      cod_abi,
                      TO_CHAR (id_dper, 'YYYY-MM') periodo,
                      DECODE (cod_stato, 'CARICATO', 'OK', NULL) caricato_ok
                 FROM t_mcres_wrk_acquisizione
                WHERE     cod_flusso IN
                             ('EFFETTI_ECONOMICI',
                              'SISBA_CP',
                              'MOVIMENTI_MOD_MOV')
                      AND cod_stato IN ('CARICATO', 'RIMOSSO')
                      AND id_flusso > 0
             GROUP BY cod_flusso,
                      cod_abi,
                      TO_CHAR (id_dper, 'YYYY-MM'),
                      DECODE (cod_stato, 'CARICATO', 'OK', NULL)
             ORDER BY 1, 2, 3) a,
            (  SELECT cod_abi, desc_breve
                 FROM t_mcres_app_istituti
                WHERE cod_istituto != 'XX'
             ORDER BY desc_breve) b
      WHERE b.cod_abi = a.cod_abi(+)
   GROUP BY b.cod_abi, b.desc_breve, a.cod_flusso
   ORDER BY b.desc_breve, a.cod_flusso;
