/* Formatted on 17/06/2014 18:12:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_CONT
(
   COD_ABI,
   VAL_ANNOMESE,
   FLG_GAR_REALI_PERSONALI,
   FLG_GAR_REALI,
   VAL_TOT_NDG,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV
)
AS
     SELECT cod_abi,
            SUBSTR (id_dper, 1, 6) val_annomese,
            0 FLG_GAR_REALI_PERSONALI,
            0 FLG_GAR_REALI,
            COUNT (DISTINCT (cod_ndg)) VAL_TOT_NDG,
            SUM (val_vant) VAL_VANTATO,
            SUM (val_uti_ret) val_gbv,
            SUM (val_att) val_nbv
       FROM t_mcres_app_sisba_cp cp
      WHERE     cp.val_firma != 'FIRMA'
            AND cP.COD_STATO_RISCHIO = 'S'
            AND TO_CHAR (cp.dta_decorrenza_stato, 'YYYY') =
                   SUBSTR (cp.id_dper, 1, 4)
   GROUP BY cod_abi, id_dper;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_CONT TO MCRE_USR;
