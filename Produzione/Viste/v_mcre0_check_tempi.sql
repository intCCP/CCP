/* Formatted on 17/06/2014 18:04:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_TEMPI
(
   GIORNO,
   DESCRIZIONE,
   INIZIO,
   DURATA,
   FINE
)
AS
   SELECT TRUNC (inizio.inizio) giorno,
          'Flusso ' || inizio.cod_file,
          TO_CHAR (inizio, 'yyyy/mm/dd hh24:mi:ss'),
          ROUND ( (fine.fine - inizio.inizio) * 1440, 0) totmin,
          TO_CHAR (fine, 'yyyy/mm/dd hh24:mi:ss')
     FROM (  SELECT cod_file, tms_file inizio, id_flusso
               FROM t_mcre0_wrk_acquisizione
              WHERE tms_file >
                       (SELECT TRUNC (MAX (tms_file))
                          FROM t_mcre0_wrk_acquisizione)
           ORDER BY tms_file DESC) inizio,
          (  SELECT id_flusso, MAX (tms) fine, nome_funzione
               FROM T_MCRE0_WRK_LOG_EVENTI
              WHERE     1 = 1
                    AND nome_funzione LIKE
                           '%PKG_MCRE0_FUNZIONI_MASTER.FND_MCRE0_master%'
           GROUP BY id_flusso, nome_funzione
           ORDER BY id_flusso DESC) fine
    WHERE inizio.id_flusso = fine.id_flusso
   UNION
     SELECT TRUNC (dta_ins),
            'Pkg_mcre0_tws_livello_' || SUBSTR (procedura, 1, 4),
            TO_CHAR (MIN (dta_ins), 'yyyy/mm/dd hh24:mi:ss'),
            ROUND ( (MAX (dta_ins) - MIN (dta_ins)) * 1440, 0) totmin,
            TO_CHAR (MAX (dta_ins), 'yyyy/mm/dd hh24:mi:ss')
       FROM T_MCRE0_WRK_AUDIT_ETL
      WHERE     1 = 1
            AND TRUNC (dta_ins) =
                   (SELECT MAX (TRUNC (SYSDATE)) FROM T_MCRE0_WRK_AUDIT_ETL)
            AND (   procedura LIKE '0%'
                 OR procedura LIKE '1%'
                 OR procedura LIKE '2%'
                 OR procedura LIKE '3%'
                 OR procedura LIKE '4%'
                 OR procedura LIKE '5%'
                 OR procedura LIKE '6%'
                 OR procedura LIKE '7%'
                 OR procedura LIKE '8%'                --  procedura like '9%'
                                       )
            AND procedura NOT LIKE '%5_16%'
            AND procedura NOT LIKE '%5_15%'
            AND procedura NOT LIKE '%5_14%'
            AND procedura NOT LIKE '%5_13%'
            AND procedura NOT LIKE '%5_12%'
            AND procedura NOT LIKE '%5_11%'
            AND procedura NOT LIKE '%3_12%'
            AND procedura NOT LIKE '%3_13%'
            AND procedura NOT LIKE '%3_14%'
            AND procedura NOT LIKE '%3_22%'
            AND procedura NOT LIKE '%3_24%'
            AND procedura NOT LIKE '%3_25%'
            AND procedura NOT LIKE '%3_26%'
            AND procedura NOT LIKE '%3_23%'
   GROUP BY SUBSTR (procedura, 1, 4), TRUNC (dta_ins)
   ORDER BY 1 DESC;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CHECK_TEMPI TO MCRE_USR;
