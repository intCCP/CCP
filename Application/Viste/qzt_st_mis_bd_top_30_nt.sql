/* Formatted on 21/07/2014 18:30:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZT_ST_MIS_BD_TOP_30_NT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_SNDG,
   COD_CLI_GE,
   COD_GRUPPO_ECONOMICO,
   VAL_GBV,
   VAL_NBV,
   VAL_VANT,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_PERSONALI
)
AS
   SELECT 'BD' cod_src,
          t.id_dper,
          TO_CHAR (LAST_DAY (TO_DATE (t.id_dper, 'yyyymm')), 'yyyymmdd')
             dta_competenza,
          cod_stato_rischio,
          DECODE (cod_stato_rischio,
                  'S', 'Sofferenze',
                  'I', 'Incagli',
                  'R', 'Ristrutturati')
             des_stato_rischio,
          cod_sndg_gruppo_cliente cod_sndg,
          CASE
             WHEN cod_gruppo_economico IS NOT NULL THEN cod_gruppo_economico
             ELSE cod_sndg_gruppo_cliente
          END
             cod_cli_ge,
          NVL (g.cod_gruppo_economico, '#') cod_gruppo_economico,
          val_gbv,
          val_nbv,
          val_vantato val_vant,
          val_garanzie_reali,
          val_garanzie_personali
     FROM t_mcres_app_top_30_nt t, t_mcre0_app_gruppo_economico g
    WHERE     0 = 0
          AND t.id_dper =
                 SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6)
          AND t.cod_sndg_gruppo_cliente = g.cod_sndg(+);
