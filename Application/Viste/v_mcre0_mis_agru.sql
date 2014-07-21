/* Formatted on 21/07/2014 18:37:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_MIS_AGRU
(
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   VAL_PARTITA_IVA,
   VAL_SETTORE_ECONOMICO,
   VAL_RAMO_ECONOMICO,
   FLG_ART_136,
   COD_SNDG_SOGGETTO,
   VAL_SEGMENTO_REGOLAMENTARE,
   DTA_SEGMENTO_REGOLAMENTARE,
   VAL_PD_ONLINE,
   DTA_RIF_PD_ONLINE,
   DTA_INIZIO_RELAZIONE,
   DTA_INS,
   DTA_UPD,
   ID_DPER,
   VAL_RATING_ONLINE,
   DTA_NASCITA_COSTITUZIONE
)
AS
   WITH mis
        AS (SELECT DISTINCT a.cod_sndg
              FROM T_MCRE0_day_agru b, t_mcre0_day_fg a
             WHERE b.cod_sndg(+) = a.cod_sndg AND b.cod_sndg IS NULL)
   SELECT a."COD_SNDG",
          a."DESC_NOME_CONTROPARTE",
          a."VAL_PARTITA_IVA",
          a."VAL_SETTORE_ECONOMICO",
          a."VAL_RAMO_ECONOMICO",
          a."FLG_ART_136",
          a."COD_SNDG_SOGGETTO",
          a."VAL_SEGMENTO_REGOLAMENTARE",
          a."DTA_SEGMENTO_REGOLAMENTARE",
          a."VAL_PD_ONLINE",
          a."DTA_RIF_PD_ONLINE",
          a."DTA_INIZIO_RELAZIONE",
          a."DTA_INS",
          a."DTA_UPD",
          a."ID_DPER",
          a."VAL_RATING_ONLINE",
          a."DTA_NASCITA_COSTITUZIONE"
     FROM t_mcre0_dwh_agru a, mis
    WHERE a.cod_sndg = mis.cod_sndg;
