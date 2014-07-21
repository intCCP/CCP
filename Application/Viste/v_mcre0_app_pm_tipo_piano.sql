/* Formatted on 21/07/2014 18:34:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_TIPO_PIANO
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_SEGMENTO,
   COD_GRUPPO_SEG,
   GB_VAL_MAU,
   VAL_LIMITE_INF,
   VAL_LIMITE_SUP,
   COD_TIPO_PIANO
)
AS
   SELECT                                        -- VG 20140703  solo stati PM
         cod_abi_cartolarizzato,
          cod_ndg,
          a.cod_sndg,
          s.cod_segmento,
          s.cod_gruppo_seg,
          a.gb_val_mau,
          T.VAL_LIMITE_INF,
          T.VAL_LIMITE_SUP,
          T.COD_TIPO_PIANO
     FROM T_MCRE0_APP_ALL_DATA a,
          t_mcre0_cl_segmenti_reg s,
          t_mcre0_app_anagrafica_gruppo g,
          T_MCRE0_APP_PM_TIPO_PIANO t
    WHERE     TODAY_FLG = '1'
          AND a.cod_stato = 'PM'
          AND a.cod_sndg = g.cod_sndg
          AND g.val_segmento_regolamentare = s.cod_segmento
          AND s.cod_gruppo_seg = T.COD_SEGMENTO
          AND a.gb_val_mau >= T.VAL_LIMITE_INF
          AND a.gb_val_mau < T.VAL_LIMITE_SUP;
