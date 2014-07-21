/* Formatted on 17/06/2014 18:03:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_SNDG
(
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   ESISTE_DEL_ATTIVA
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          --0216 aggiunto filtro fase != 'AN' e no_delib = 0
          a.cod_sndg,
          a.desc_nome_controparte,
          CASE
             WHEN EXISTS
                     (SELECT cod_abi, cod_ndg
                        FROM t_mcrei_app_delibere d
                       WHERE     a.cod_sndg = d.cod_sndg
                             AND d.flg_attiva = '1'
                             AND d.cod_fase_delibera NOT IN ('AN', 'VA') --13dic
                             AND d.flg_no_delibera = 0)
             THEN
                'Y'
             ELSE
                'N'
          END
             esiste_del_attiva
     FROM t_mcre0_app_anagrafica_gruppo a;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_SNDG TO MCRE_USR;
