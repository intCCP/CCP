/* Formatted on 17/06/2014 17:59:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RM_NT
(
   COD_SRC,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   ID_DPER,
   DTA_COMPETENZA,
   COD_ABI,
   VAL_RETT_ATT
)
AS
   WITH tmp
        AS (SELECT id_dper,
                   cod_abi,
                   val_gbv - val_nbv val_fondo_attuale,
                   LAG (val_gbv - val_nbv)
                      OVER (PARTITION BY cod_abi ORDER BY id_dper)
                      val_fondo_precedente,
                   LAG (id_dper) OVER (PARTITION BY cod_abi ORDER BY id_dper)
                      id_dper_prec
              FROM t_mcres_app_ptf_non_target)
   SELECT "COD_SRC",
          "COD_STATO_RISCHIO",
          "DES_STATO_RISCHIO",
          "ID_DPER",
          "DTA_COMPETENZA",
          "COD_ABI",
          "VAL_RETT_ATT"
     FROM (SELECT 'RM' cod_src,
                  'S' cod_stato_rischio,
                  'Sofferenze' des_stato_rischio,
                  SUBSTR (id_dper, 1, 6) id_dper,
                  id_dper dta_competenza,
                  cod_abi,
                  val_fondo_attuale - val_fondo_precedente val_rett_att
             FROM tmp
            WHERE     0 = 0
                  AND MONTHS_BETWEEN (TO_DATE (id_dper, 'yyyymm'),
                                      TO_DATE (id_dper_prec, 'yyyymm')) = 1)
    WHERE id_dper = SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_RM_NT TO MCRE_USR;
