/* Formatted on 17/06/2014 18:07:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE_PROG
(
   COD_ABI,
   COD_NDG,
   VAL_RDV_QC_PROGRESSIVA
)
AS
   SELECT COD_ABI, COD_NDG, VAL_RDV_QC_PROGRESSIVA
     FROM (  SELECT cod_abi,
                    cod_ndg,
                    (  NVL (val_rdv_qc_progressiva, 0)
                     + NVL (VAL_RDV_PROGR_FI, 0))
                       AS val_rdv_qc_progressiva
               FROM t_mcrei_app_delibere
              WHERE     cod_fase_delibera NOT IN ('NA', 'VA', 'SO', 'AN')
                    AND DTA_CONFERMA_DELIBERA IS NOT NULL
                    AND FLG_NO_DELIBERA = 0
                    AND flg_attiva = '1'
                    --mm131105 escludo anche le classificazioni, che non sempre ereditano correttamente il progressivo
                    AND COD_MICROTIPOLOGIA_dELIB NOT IN
                           ('IR', 'CI', 'CS', 'CZ', 'CR') ----SI ESCLUDONO LE IR PERCHE' POSSONO ESSERE STATE IMPIANTATE MENTRE UNA RV ERA ANCORA DA CONFERMARE
                    AND cod_abi =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   1,
                                   5)
                    AND cod_ndg =
                           SUBSTR ( (SYS_CONTEXT ('userenv', 'client_info')),
                                   6,
                                   16)
           ORDER BY val_anno_pratica || cod_pratica DESC,
                    val_num_progr_delibera DESC)
    WHERE ROWNUM = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_DELIBERE_PROG TO MCRE_USR;
