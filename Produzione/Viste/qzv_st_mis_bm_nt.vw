/* Formatted on 17/06/2014 17:59:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BM_NT
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV
)
AS
   SELECT 'BM' cod_src,
          ID_DPER,
          TO_CHAR (LAST_DAY (TO_DATE (ID_DPER, 'yyyymm')), 'yyyymmdd')
             DTA_COMPETENZA,
          cod_stato_rischio,
          CASE
             WHEN cod_stato_rischio = 'S' THEN 'Sofferenze'
             WHEN cod_stato_rischio = 'I' THEN 'Incagli'
             WHEN cod_stato_rischio = 'R' THEN 'Ristrutturati'
             ELSE NULL
          END
             des_stato_rischio,
          cod_abi,
          val_vantato val_vant,
          val_gbv,
          val_nbv
     FROM mcre_own.T_MCRES_APP_PTF_NON_TARGET
    WHERE id_dper = SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_BM_NT TO MCRE_USR;
