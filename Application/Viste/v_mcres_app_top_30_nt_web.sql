/* Formatted on 21/07/2014 18:43:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_TOP_30_NT_WEB
(
   ID_DPER,
   COD_ABI,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_SNDG,
   DESC_CLIENTE,
   COD_STATO_RISCHIO,
   DTA_DECORRENZA_STATO,
   VAL_GBV,
   VAL_NBV,
   VAL_VANTATO,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_PERSONALI,
   COD_STATO_GIUDIRICO_PREV
)
AS
   SELECT id_dper,
          cod_abi,
          cod_gruppo_economico,
          desc_gruppo_economico,
          cod_sndg,
          desc_cliente,
          cod_stato_rischio,
          dta_decorrenza_stato,
          val_gbv,
          val_nbv,
          val_vantato,
          val_garanzie_reali,
          val_garanzie_personali,
          cod_stato_giudirico_prev
     FROM t_mcres_app_top_30_nt_web;
