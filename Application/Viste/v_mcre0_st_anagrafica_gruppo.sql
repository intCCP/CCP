/* Formatted on 21/07/2014 18:37:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_ANAGRAFICA_GRUPPO
(
   ID_DPER,
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
   VAL_RATING_ONLINE,
   DTA_NASCITA_COSTITUZIONE
)
AS
   WITH T_MCRE0_FL_ANAGRAFICA_GRUPPO
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_AGRU_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FA7_NDG_GRP, 16, 0) AS COD_SNDG,
                   TRIM (FA7_INT) AS DESC_NOME_CONTROPARTE,
                   TRIM (FA7_PAR_IVA) AS VAL_PARTITA_IVA,
                   TO_NUMBER (FA7_SAE) AS VAL_SETTORE_ECONOMICO,
                   TO_NUMBER (FA7_RAE) AS VAL_RAMO_ECONOMICO,
                   TRIM (FA7_ART_136) AS FLG_ART_136,
                   RPAD (FA7_SOG_COI, 16, 0) AS COD_SNDG_SOGGETTO,
                   TRIM (FA7_SEG_REG) AS VAL_SEGMENTO_REGOLAMENTARE,
                   TO_DATE (FA7_DAT_SEG_REG, 'ddmmyyyy')
                      AS DTA_SEGMENTO_REGOLAMENTARE,
                   TO_NUMBER (TRIM (FA7_PDO)) AS VAL_PD_ONLINE,
                   TO_DATE (FA7_DAT_RIF_PDO, 'ddmmyyyy') AS DTA_RIF_PD_ONLINE,
                   TO_DATE (FA7_DAT_INI_REL, 'ddmmyyyy')
                      AS DTA_INIZIO_RELAZIONE,
                   TRIM (FA7_RAT_PDO) AS VAL_RATING_ONLINE,
                   TO_DATE (FA7_DTA_NASC_COST, 'ddmmyyyy')
                      AS DTA_NASCITA_COSTITUZIONE
              FROM TE_MCRE0_AGRU_INC
             WHERE     FND_MCRE0_is_numeric (FA7_SAE) = 1
                   AND FND_MCRE0_is_numeric (FA7_RAE) = 1
                   AND FND_MCRE0_is_date (FA7_DAT_SEG_REG) = 1
                   AND FND_MCRE0_is_date (FA7_DAT_RIF_PDO) = 1
                   AND FND_MCRE0_is_date (FA7_DAT_INI_REL) = 1
                   AND fnd_mcre0_is_date (FA7_DTA_NASC_COST) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "DESC_NOME_CONTROPARTE",
          "VAL_PARTITA_IVA",
          "VAL_SETTORE_ECONOMICO",
          "VAL_RAMO_ECONOMICO",
          "FLG_ART_136",
          "COD_SNDG_SOGGETTO",
          "VAL_SEGMENTO_REGOLAMENTARE",
          "DTA_SEGMENTO_REGOLAMENTARE",
          "VAL_PD_ONLINE",
          "DTA_RIF_PD_ONLINE",
          "DTA_INIZIO_RELAZIONE",
          "VAL_RATING_ONLINE",
          "DTA_NASCITA_COSTITUZIONE"
     FROM (SELECT COUNT (1) OVER (PARTITION BY ID_DPER, COD_SNDG) NUM_RECS,
                  ID_DPER,
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
                  VAL_RATING_ONLINE,
                  DTA_NASCITA_COSTITUZIONE
             FROM T_MCRE0_FL_ANAGRAFICA_GRUPPO) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_SNDG)) IS NOT NULL;
