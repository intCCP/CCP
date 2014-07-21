/* Formatted on 21/07/2014 18:30:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BM_FTECNICA
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_FORMA_TECNICA,
   COD_NDG,
   FLG_FIRMA,
   FLG_PORTAFOGLIO,
   FLG_NDG,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT 'BM' cod_src,
            SUBSTR (id_dper, 1, 6) id_dper,
            id_dper dta_competenza,
            cod_stato_rischio,
            DECODE (cod_stato_rischio,
                    'S', 'Sofferenze',
                    'I', 'Incagli',
                    'R', 'Ristrutturati')
               des_stato_rischio,
            cod_abi,
            cod_forma_tecnica,
            '#' cod_ndg,
            1 flg_firma,
            COUNT (DISTINCT cod_sportello || cod_rapporto) flg_portafoglio,
            COUNT (DISTINCT cod_ndg) flg_ndg,
            SUM (val_vant) val_vant,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM (SELECT cp.id_dper,
                    cp.cod_stato_rischio,
                    cp.cod_abi,
                    cp.cod_ndg,
                    cp.cod_sportello,
                    cp.cod_rapporto,
                    cp.cod_rapporto_orig,
                    val_vant,
                    val_uti_ret,
                    val_att,
                    CASE
                       WHEN NVL (r.flg_confidi, 'N') = 'S' THEN 'C'
                       WHEN NVL (r.flg_agevolato, 'N') = 'S' THEN 'G'
                       WHEN NVL (r.flg_contributo, 'N') = 'S' THEN 'R'
                       WHEN NVL (r.flg_rapp_cartolarizzato, 'N') = 'S' THEN 'Z'
                       WHEN NVL (r.flg_rapp_fondo_terzo, 'N') = 'S' THEN 'T'
                       ELSE 'A'
                    END
                       cod_forma_tecnica
               FROM t_mcres_app_sisba_cp cp, t_mcres_app_rapporti r
              WHERE     0 = 0
                    AND cp.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                    AND cp.cod_stato_rischio = 'S'
                    AND cp.val_firma != 'FIRMA'
                    AND cp.cod_abi = r.cod_abi(+)
                    AND cp.cod_ndg = r.cod_ndg(+)
                    AND SUBSTR (cp.cod_sportello, -5) || cp.cod_rapporto_orig =
                           r.cod_rapporto(+))
   GROUP BY id_dper,
            cod_abi,
            cod_stato_rischio,
            cod_forma_tecnica;
