/* Formatted on 21/07/2014 18:30:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_MM_NEW
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   COD_PRESIDIO,
   DES_MOV_CNT,
   VAL_MOV_CNT
)
AS
   SELECT 'MM' cod_src,
          SUBSTR (mm.id_dper, 1, 6) id_dper,
          mm.id_dper dta_competenza,
          mm.cod_stato_rischio,
          DECODE (mm.cod_stato_rischio,
                  'S', 'Sofferenze',
                  'I', 'Incagli',
                  'R', 'Ristrutturati')
             des_stato_rischio,
          mm.cod_abi,
          mm.cod_ndg,
          cp.cod_filiale_area cod_presidio,
          mm.desc_modulo des_mov_cnt,
          mm.val_cr_tot val_mov_cnt
     FROM t_mcres_app_movimenti_mod_mov mm,
          (  SELECT id_dper,
                    cod_abi,
                    cod_ndg,
                    cod_stato_rischio,
                    MAX (cod_filiale_area) cod_filiale_area
               FROM t_mcres_app_sisba_cp
              WHERE 0 = 0
           GROUP BY id_dper,
                    cod_abi,
                    cod_ndg,
                    cod_stato_rischio) cp
    WHERE     0 = 0
          AND mm.id_dper = SYS_CONTEXT ('userenv', 'client_info')
          AND mm.id_dper = cp.id_dper(+)
          AND mm.cod_abi = cp.cod_abi(+)
          AND mm.cod_ndg = cp.cod_ndg(+)
          AND mm.cod_stato_rischio = cp.cod_stato_rischio(+);
