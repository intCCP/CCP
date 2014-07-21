/* Formatted on 17/06/2014 18:04:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_CHECK_LOG_ETL
(
   ID,
   PROCEDURA,
   LIVELLO,
   SQL_CODE,
   MESSAGE,
   NOTE,
   DTA_INS
)
AS
     SELECT ID,
            PROCEDURA,
            LIVELLO,
            SQL_CODE,
            MESSAGE,
            NOTE,
            DTA_INS
       FROM t_mcre0_wrk_audit_etl
      WHERE     1 = 1
            AND TRUNC (dta_ins) =
                   (SELECT TRUNC (MAX (dta_ins)) FROM t_mcre0_wrk_audit_etl)
            AND livello <> 3 -- decommentare per filtrare solo warning e errori
            AND (   dta_ins >=
                       (SELECT MAX (dta_ins) AS dta
                          FROM t_mcre0_wrk_audit_etl
                         WHERE     1 = 1
                               AND procedura =
                                      '0 - PKG_MCRE0_TWS - INI - TWS_MCRE0_CHIUDI_PORTALE')
                 OR dta_ins <=
                       (SELECT dta
                          FROM (  SELECT MIN (procedura) AS procedura,
                                         dta_ins AS dta
                                    FROM t_mcre0_wrk_audit_etl
                                   WHERE     1 = 1
                                         AND (   procedura LIKE '0%'
                                              OR procedura LIKE '1%'
                                              OR procedura LIKE '2%'
                                              OR procedura LIKE '3%'
                                              OR procedura LIKE '4%'
                                              OR procedura LIKE '5%'
                                              OR procedura LIKE '6%')
                                         AND dta_ins =
                                                (SELECT MAX (dta_ins)
                                                   FROM t_mcre0_wrk_audit_etl
                                                  WHERE     1 = 1
                                                        AND (   procedura LIKE
                                                                   '0%'
                                                             OR procedura LIKE
                                                                   '1%'
                                                             OR procedura LIKE
                                                                   '2%'
                                                             OR procedura LIKE
                                                                   '3%'
                                                             OR procedura LIKE
                                                                   '4%'
                                                             OR procedura LIKE
                                                                   '5%'
                                                             OR procedura LIKE
                                                                   '6%'))
                                GROUP BY dta_ins)))
   ORDER BY dta_ins DESC;


GRANT SELECT ON MCRE_OWN.V_MCRE0_CHECK_LOG_ETL TO MCRE_USR;
