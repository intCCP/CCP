/* Formatted on 17/06/2014 18:05:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_PEF
(
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PEF,
   COD_FASE_PEF,
   DTA_ULTIMA_REVISIONE,
   DTA_SCADENZA_FIDO,
   DTA_ULTIMA_DELIBERA,
   FLG_FIDI_SCADUTI,
   DAT_ULTIMO_SCADUTO,
   COD_ULTIMO_ODE,
   COD_CTS_ULTIMO_ODE,
   COD_STRATEGIA_CRZ,
   COD_ODE,
   DTA_COMPLETAMENTO_PEF,
   DTA_INS,
   DTA_UPD,
   ID_DPER,
   DTA_SCA_REV_PEF
)
AS
   WITH mis
        AS (SELECT DISTINCT a.COD_ABI_ISTITUTO, a.COD_NDG
              FROM t_mcre0_day_pef b, t_mcre0_day_fg a
             WHERE     b.COD_ABI_ISTITUTO(+) = a.COD_ABI_ISTITUTO
                   AND b.cod_ndg(+) = a.cod_ndg
                   AND b.COD_ABI_ISTITUTO || b.cod_ndg IS NULL)
   SELECT a."COD_ABI_ISTITUTO",
          a."COD_NDG",
          a."COD_PEF",
          a."COD_FASE_PEF",
          a."DTA_ULTIMA_REVISIONE",
          a."DTA_SCADENZA_FIDO",
          a."DTA_ULTIMA_DELIBERA",
          a."FLG_FIDI_SCADUTI",
          a."DAT_ULTIMO_SCADUTO",
          a."COD_ULTIMO_ODE",
          a."COD_CTS_ULTIMO_ODE",
          a."COD_STRATEGIA_CRZ",
          a."COD_ODE",
          a."DTA_COMPLETAMENTO_PEF",
          a."DTA_INS",
          a."DTA_UPD",
          a."ID_DPER",
          a."DTA_SCA_REV_PEF"
     FROM t_mcre0_dwh_pef a, mis
    WHERE     a.COD_ABI_ISTITUTO = mis.COD_ABI_ISTITUTO
          AND a.COD_NDG = mis.COD_NDG;


GRANT SELECT ON MCRE_OWN.V_MCRE0_MIS_PEF TO MCRE_USR;
