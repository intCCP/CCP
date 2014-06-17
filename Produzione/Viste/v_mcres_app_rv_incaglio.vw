/* Formatted on 17/06/2014 18:11:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_RV_INCAGLIO
(
   COD_ABI,
   COD_NDG,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_UO_PRATICA,
   DTA_RETTIFICA_INC,
   VAL_RETTIFICA_INC
)
AS
   SELECT p.cod_abi,
          p.cod_ndg,
          p.cod_pratica,
          p.val_anno val_anno_pratica,
          p.cod_uo_pratica,
          d.dta_conferma_delibera dta_rettifica_inc,
          d.val_rdv_qc_progressiva val_rettifica_inc
     FROM t_mcres_app_pratiche p,
          (SELECT cod_abi,
                  cod_ndg,
                  val_rdv_qc_progressiva,
                  dta_conferma_delibera
             FROM (SELECT ROW_NUMBER ()
                          OVER (
                             PARTITION BY cod_abi, cod_ndg
                             ORDER BY dta_conferma_delibera DESC NULLS LAST)
                             rn,
                          d.*
                     FROM t_mcrei_app_delibere d
                    WHERE     0 = 0
                          AND cod_fase_delibera = 'CO'
                          AND cod_microtipologia_delib IN
                                 ('RV', 'T4', 'A0', 'IM')
                          AND dta_conferma_delibera IS NOT NULL
                          AND val_rdv_qc_progressiva IS NOT NULL
                          AND flg_attiva = '1')
            WHERE rn = 1) d
    WHERE     0 = 0
          AND p.cod_abi = d.cod_abi
          AND p.cod_ndg = d.cod_ndg
          AND p.flg_attiva = 1;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_RV_INCAGLIO TO MCRE_USR;
