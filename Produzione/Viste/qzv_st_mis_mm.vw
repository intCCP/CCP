/* Formatted on 17/06/2014 17:59:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_MM
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
   SELECT                   --AG Aggiunto filtro sullo stato rischio non nullo
         'MM' cod_src,
          SUBSTR (mm.id_dper, 1, 6) id_dper,
          mm.id_dper dta_competenza,
          mm.cod_stato_rischio,
          --    'S' cod_stato_rischio,
          DECODE (mm.cod_stato_rischio,
                  'S', 'Sofferenze',
                  'I', 'Incagli',
                  'R', 'Ristrutturati')
             des_stato_rischio,
          --'Sofferenze' des_stato_rischio,
          mm.cod_abi,
          mm.cod_ndg,
          NVL (cp.cod_filiale_area, '#') cod_presidio,
          mm.desc_modulo des_mov_cnt,
          mm.val_cr_tot val_mov_cnt
     FROM t_mcres_app_movimenti_mod_mov mm,
          (  SELECT id_dper,
                    cod_abi,
                    cod_ndg,
                    cod_stato_rischio,
                    MAX (cod_filiale_area) cod_filiale_area
               FROM t_mcres_app_sisba_cp
              WHERE 0 = 0 AND cod_stato_rischio IN ('S', 'I', 'R')
           GROUP BY id_dper,
                    cod_abi,
                    cod_ndg,
                    cod_stato_rischio) cp
    WHERE     0 = 0
          AND mm.cod_stato_rischio IS NOT NULL
          AND mm.id_dper = SYS_CONTEXT ('userenv', 'client_info')
          AND mm.id_dper = cp.id_dper(+)
          AND mm.cod_abi = cp.cod_abi(+)
          AND mm.cod_ndg = cp.cod_ndg(+)
          AND mm.cod_stato_rischio = cp.cod_stato_rischio(+)
          AND mm.cod_stato_rischio IN ('S', 'I', 'R');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_MM TO MCRE_USR;
