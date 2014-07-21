/* Formatted on 21/07/2014 18:41:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_GET_LAST_RDV_PROGR
(
   VAL_RDV_QC_PROGRESSIVA,
   COD_ABI,
   COD_NDG,
   COD_PROTOCOLLO_DELIBERA
)
AS
   SELECT val_rdv_qc_progressiva,
          cod_abi,
          cod_ndg,
          cod_protocollo_delibera
     FROM (  SELECT cod_abi,
                    cod_ndg,
                    cod_protocollo_delibera,
                    (  NVL (val_rdv_qc_progressiva, 0)
                     + NVL (val_rdv_progr_fi, 0))
                       AS val_rdv_qc_progressiva,
                    NVL (val_rdv_qc_progressiva, 0),
                    NVL (val_rdv_progr_fi, 0),
                    val_num_progr_delibera
               FROM t_mcrei_app_delibere
              WHERE     cod_fase_delibera IN ('CO', 'AD', 'CT')
                    AND flg_no_delibera = 0
           ORDER BY val_num_progr_delibera DESC)
    WHERE ROWNUM = 1;
