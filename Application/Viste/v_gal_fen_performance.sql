/* Formatted on 21/07/2014 18:31:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_GAL_FEN_PERFORMANCE
(
   ID_DPER,
   COD_ABI,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_VANTATO,
   VAL_GBV,
   VAL_NBV,
   VAL_SOPRAVVENIENZE,
   VAL_INCASSI,
   VAL_SOPRAVVENIENZE_ATTIVE,
   VAL_SPESE
)
AS
     SELECT cp.id_dper,
            cp.cod_abi,
            --cp.cod_ndg,
            p.cod_uo_pratica,
            NVL (p.cod_matr_pratica, -1) cod_matr_pratica,
            SUM (cp.val_vantato) val_vantato,
            SUM (cp.val_gbv) val_gbv,
            SUM (cp.val_nbv) val_nbv,
            SUM (cp.val_sopravvenienze) val_sopravvenienze,
            SUM (NVL (m.val_incassi, 0)) val_incassi,
            SUM (0) val_sopravvenienze_attive,
            SUM (0) val_spese
       FROM (  SELECT id_dper,
                      cod_abi,
                      cod_ndg,
                      SUM (val_vant) val_vantato,
                      SUM (val_uti_ret) val_gbv,
                      SUM (val_att) val_nbv,
                      SUM (val_sopravvenienze) val_sopravvenienze
                 FROM t_mcres_app_sisba_cp
                WHERE cod_stato_rischio = 'S'
             GROUP BY id_dper, cod_abi, cod_ndg) cp,
            (  SELECT id_dper,
                      cod_abi,
                      cod_ndg,
                      SUM (val_cr_tot) val_incassi
                 FROM t_mcres_app_movimenti_mod_mov
                WHERE     0 = 0
                      AND UPPER (desc_modulo) IN
                             ('ALL.6 - SOFFERENZE ESTINTE',
                              'ALL.7 - SOFFERENZE RIDOTTE')
             GROUP BY id_dper, cod_abi, cod_ndg) m,
            t_mcres_app_pratiche p
      WHERE     0 = 0
            AND cp.cod_abi = p.cod_abi
            AND cp.cod_ndg = p.cod_ndg
            AND cp.cod_abi = m.cod_abi
            AND cp.cod_ndg = m.cod_ndg
            AND p.flg_attiva = 1
   GROUP BY cp.id_dper,
            cp.cod_abi,
            p.cod_uo_pratica,
            p.cod_matr_pratica;
