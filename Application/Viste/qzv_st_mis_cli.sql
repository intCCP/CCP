/* Formatted on 21/07/2014 18:30:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_CLI
(
   COD_CLI_GE,
   DES_CLI_GE
)
AS
   SELECT DISTINCT -- sndg distinti possono appartenere allo stesso gruppo economico
          NVL (s.cod_gruppo_economico, s.cod_sndg) cod_cli_ge,
          CASE
             WHEN s.cod_gruppo_economico IS NOT NULL THEN age.val_ana_gre --eventualmente nullo
             ELSE NVL (ag.desc_nome_controparte, nt.desc_cliente)
          END
             des_cli_ge
     FROM (SELECT ge.cod_gruppo_economico, x.cod_sndg
             FROM (SELECT DISTINCT cod_sndg
                     FROM (SELECT cod_sndg
                             FROM t_mcres_app_sisba_cp cp
                            WHERE     0 = 0
                                  AND cp.cod_stato_rischio IN ('S', 'I', 'R')
                                  AND cp.id_dper =
                                         SYS_CONTEXT ('userenv',
                                                      'client_info')
                           UNION ALL
                           SELECT cod_sndg
                             FROM t_mcres_app_top_30_nt_web
                            WHERE     0 = 0
                                  --                            and tipo_record = 2
                                  AND id_dper =
                                         SUBSTR (
                                            SYS_CONTEXT ('userenv',
                                                         'client_info'),
                                            1,
                                            6))) x,
                  t_mcre0_app_gruppo_economico ge
            WHERE 0 = 0 AND x.cod_sndg = ge.cod_sndg(+)) s,
          t_mcre0_app_anagrafica_gruppo ag,
          t_mcre0_app_anagr_gre age,
          t_mcres_app_top_30_nt_web nt
    WHERE     0 = 0
          AND s.cod_sndg = ag.cod_sndg(+)
          AND s.cod_gruppo_economico = age.cod_gre(+)
          AND s.cod_sndg = nt.cod_sndg(+)
          AND nt.id_dper(+) = SYS_CONTEXT ('userenv', 'client_info');
