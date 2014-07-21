/* Formatted on 21/07/2014 18:30:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_BD_MIS_TOP_30_NT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_SNDG,
   COD_CLI_GE,
   COD_GRUPPO_ECONOMICO,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_PERSONALI,
   FLG_NDG,
   FLG_GARANZIE_REALI,
   FLG_GARANZIE_PERSONALI
)
AS
   SELECT 'BD' cod_src,
          n.id_dper,
          TO_CHAR (LAST_DAY (TO_DATE (n.id_dper, 'yyyymm')), 'yyyymmdd')
             dta_competenza,
          n.cod_stato_rischio,
          DECODE (cod_stato_rischio,
                  'S', 'Sofferenze',
                  'I', 'Incagli',
                  'R', 'Ristrutturati')
             des_stato_rischio,
          cod_sndg_gruppo_cliente cod_sndg,
          NVL (ge.cod_gruppo_economico, cod_sndg_gruppo_cliente) cod_cli_ge,
          ge.cod_gruppo_economico,
          n.val_vantato val_vant,
          n.val_gbv,
          n.val_nbv,
          n.val_garanzie_reali,
          n.val_garanzie_personali,
          '0' flg_ndg,
          CASE WHEN n.val_garanzie_reali > 0 THEN 1 ELSE 0 END
             flg_garanzie_reali,
          CASE WHEN n.val_garanzie_personali > 0 THEN 1 ELSE 0 END
             flg_garanzie_personali
     FROM t_mcres_app_top_30_nt n, t_mcre0_app_gruppo_economico ge
    WHERE     0 = 0
          AND n.cod_sndg_gruppo_cliente = ge.cod_sndg(+)
          AND n.tipo_record = 2
          AND n.id_dper =
                 SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6);
