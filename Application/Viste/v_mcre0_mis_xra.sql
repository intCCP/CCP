/* Formatted on 21/07/2014 18:37:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_XRA
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SAB,
   FLG_SOGLIA,
   NUM_GIORNI_SCONFINO,
   COD_RAP,
   NUM_GIORNI_SCONFINO_RAP,
   DTA_INS,
   DTA_UPD,
   ID_DPER,
   VAL_IMP_SCONFINO
)
AS
   WITH mis
        AS (SELECT DISTINCT a.cod_abi_cartolarizzato, a.COD_NDG
              FROM t_mcre0_day_xra b, t_mcre0_day_fg a
             WHERE     b.cod_abi_cartolarizzato(+) = a.cod_abi_cartolarizzato
                   AND b.cod_ndg(+) = a.cod_ndg
                   AND b.cod_abi_cartolarizzato || b.cod_ndg IS NULL)
   SELECT a."COD_ABI_ISTITUTO",
          a."COD_ABI_CARTOLARIZZATO",
          a."COD_NDG",
          a."COD_SAB",
          a."FLG_SOGLIA",
          a."NUM_GIORNI_SCONFINO",
          a."COD_RAP",
          a."NUM_GIORNI_SCONFINO_RAP",
          a."DTA_INS",
          a."DTA_UPD",
          a."ID_DPER",
          a."VAL_IMP_SCONFINO"
     FROM t_mcre0_dwh_xra a, mis
    WHERE     a.cod_abi_cartolarizzato = mis.cod_abi_cartolarizzato
          AND a.COD_NDG = mis.COD_NDG;
