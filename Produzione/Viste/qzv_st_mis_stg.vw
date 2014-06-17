/* Formatted on 17/06/2014 17:59:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_STG
(
   COD_STATO_GIURIDICO,
   ORD_STATO_GIURIDICO,
   DES_STATO_GIURIDICO,
   DES_SHORT_STATO_GIURIDICO
)
AS
   SELECT a.cod_stato_giuridico,
          ord_stato_giuridico,
          des_stato_giuridico,
          b.desc_stato_giuridico des_short_stato_giuridico
     FROM (SELECT DISTINCT
                  NVL (UPPER (cod_stato_giuridico), '#') cod_stato_giuridico,
                  CASE
                     WHEN UPPER (cod_stato_giuridico) = 'C'
                     THEN
                        1
                     WHEN UPPER (cod_stato_giuridico) IN ('A', 'B', 'D', 'E')
                     THEN
                        2
                     ELSE
                        3
                  END
                     ord_stato_giuridico,
                  CASE
                     WHEN UPPER (cod_stato_giuridico) = 'C'
                     THEN
                        'Procedure concorsuai: fallimento'
                     WHEN UPPER (cod_stato_giuridico) IN ('A', 'B', 'D', 'E')
                     THEN
                        'Procedure concorsuai: altre'
                     ELSE
                        'Procedure concorsuai: nessuna'
                  END
                     des_stato_giuridico
             FROM mcre_own.T_MCRES_APP_SISBA_CP s
            WHERE     s.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                  AND UPPER (s.cod_stato_rischio) IN ('I', 'S')
                  AND VAL_FIRMA != 'FIRMA') a,
          t_mcres_cl_stato_giuridico b
    WHERE a.cod_stato_giuridico = b.cod_stato_giuridico(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_STG TO MCRE_USR;
