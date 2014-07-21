/* Formatted on 21/07/2014 18:30:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BD_TOP_30_NT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
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
          SUBSTR (n.id_dper, 1, 6) id_dper,
          n.id_dper dta_competenza,
          n.cod_stato_rischio,
          DECODE (cod_stato_rischio,
                  'S', 'Sofferenze',
                  'I', 'Incagli',
                  'R', 'Ristrutturati')
             des_stato_rischio,
          '-1' cod_abi,
          n.cod_sndg cod_sndg,
          NVL (ge.cod_gruppo_economico, n.cod_sndg) cod_cli_ge,
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
     FROM t_mcres_app_top_30_nt_web n, t_mcre0_app_gruppo_economico ge
    WHERE     0 = 0
          AND n.cod_sndg = ge.cod_sndg(+)
          AND n.id_dper = SYS_CONTEXT ('userenv', 'client_info');
