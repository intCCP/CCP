/* Formatted on 21/07/2014 18:38:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_CLI
(
   COD_CLI_GE,
   DES_CLI_GE
)
AS
   SELECT b.cod_cli_ge, b.des_cli_ge
     FROM (SELECT DISTINCT
                  CASE
                     WHEN g.cod_gruppo_economico IS NOT NULL
                     THEN
                        g.cod_gruppo_economico
                     ELSE
                        cp.cod_sndg
                  END
                     cod_cli_ge
             FROM mcre_own.T_MCRES_APP_SISBA_CP cp,
                  mcre_own.T_MCRE0_APP_GRUPPO_ECONOMICO g
            WHERE     cp.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                  AND UPPER (cp.cod_stato_rischio) IN ('I', 'S')
                  AND cp.cod_sndg = g.cod_sndg(+)) a,
          (SELECT cod_sndg cod_cli_ge, desc_nome_controparte des_cli_ge
             FROM mcre_own.T_MCRE0_APP_ANAGRAFICA_GRUPPO n
           UNION ALL
           SELECT cod_gre cod_cli_ge, val_ana_gre des_cli_ge
             FROM mcre_own.T_MCRE0_APP_ANAGR_GRE e) b
    WHERE a.cod_cli_ge = b.cod_cli_ge;
