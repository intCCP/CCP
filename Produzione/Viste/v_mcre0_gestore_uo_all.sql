/* Formatted on 17/06/2014 18:05:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_GESTORE_UO_ALL
(
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_ABI_ISTITUTO,
   DESC_STRUTTURA_COMPETENTE,
   ID_UTENTE_ASSEGNATO,
   COD_MATRICOLA,
   COGNOME,
   TEAM,
   DESC_CRITERIO_ASSEGNAZIONE,
   DTA_INS,
   DTA_UPD,
   COD_COMPARTO_ASSEGNATARIO,
   FLG_ATTIVO,
   COD_STRUTTURA_ASSEGNATARIO,
   DESC_TIPO_STRUTTURA,
   COD_MATRICOLA_ASSEGNATARIO,
   COD_PROCESSO,
   NOME
)
AS
   SELECT "COD_STRUTTURA_COMPETENTE_DC",
          "COD_STRUTTURA_COMPETENTE_DV",
          "COD_STRUTTURA_COMPETENTE_RG",
          "COD_STRUTTURA_COMPETENTE_AR",
          "COD_STRUTTURA_COMPETENTE_FI",
          "COD_ABI_ISTITUTO",
          "DESC_STRUTTURA_COMPETENTE",
          "ID_UTENTE",
          "COD_MATRICOLA",
          "COGNOME",
          "TEAM",
          "COD_CRITERIO_ASSEGN",
          "DTA_INS",
          "DTA_UPD",
          "COD_COMPARTO_ASSEGNATARIO",
          "FLG_ATTIVO",
          "COD_STRUTTURA_ASSEGNATARIO",
          "DESC_TIPO_STRUTTURA",
          "COD_MATRICOLA_ASSEGNATARIO",
          "COD_PROCESSO",
          "NOME"
     FROM (SELECT DISTINCT
                  SORG.COD_STRUTTURA_COMPETENTE_DC,
                  SORG.COD_STRUTTURA_COMPETENTE_DV,
                  SORG.COD_STRUTTURA_COMPETENTE_RG,
                  SORG.COD_STRUTTURA_COMPETENTE_AR,
                  SORG.COD_STRUTTURA_COMPETENTE_FI,
                  SORG.COD_ABI_ISTITUTO_FI AS COD_ABI_ISTITUTO,
                  SORG.DESC_STRUTTURA_COMPETENTE_FI
                     AS DESC_STRUTTURA_COMPETENTE,
                  GU.ID_UTENTE,
                  COD_MATRICOLA,
                  U.COGNOME,
                  team,
                  GU.DESC_CRITERIO_ASSEGNAZIONE AS COD_CRITERIO_ASSEGN,
                  GU.DTA_INS AS DTA_INS,
                  GU.DTA_UPD AS DTA_UPD,
                  GU.COD_COMPARTO_ASSEGNATARIO,
                  GU.FLG_ATTIVO,
                  GU.COD_STRUTTURA_ASSEGNATARIO,
                  GU.DESC_TIPO_STRUTTURA,
                  GU.COD_MATRICOLA_ASSEGNATARIO,
                  GU.COD_PROCESSO,
                  U.NOME
             FROM (SELECT DISTINCT COD_STRUTTURA_COMPETENTE_DC,
                                   COD_STRUTTURA_COMPETENTE_DV,
                                   COD_STRUTTURA_COMPETENTE_RG,
                                   COD_STRUTTURA_COMPETENTE_AR,
                                   COD_STRUTTURA_COMPETENTE_FI,
                                   COD_LIVELLO_FI,
                                   COD_ABI_ISTITUTO_FI,
                                   DESC_STRUTTURA_COMPETENTE_FI
                     FROM MV_MCRE0_DENORM_STR_ORG
                    WHERE COD_LIVELLO_FI = 'FI') SORG,
                  (SELECT COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO AS ID_UTENTE,
                          COD_MATRICOLA_ASSEGNATA AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'C' AS TEAM,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'FI'
                          AND FLG_ATTIVO = '1'
                   UNION
                   SELECT COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO_PT AS ID_UTENTE,
                          COD_MATRICOLA_ASSEGNATA_pt AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'B' AS team,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'FI'
                          AND FLG_ATTIVO = '1') GU,
                  T_MCRE0_APP_UTENTI U,
                  T_MCRE0_APP_STRUTTURA_ORG S
            WHERE     NVL (SORG.COD_STRUTTURA_COMPETENTE_FI, '1') =
                         NVL (GU.COD_STRUTTURA_COMPETENTE_FI(+), '1')
                  AND NVL (SORG.COD_ABI_ISTITUTO_FI, '1') =
                         NVL (GU.COD_ABI_ISTITUTO(+), '1')
                  AND GU.COD_MATRICOLA_gu = U.COD_MATRICOLA(+)
                  AND SORG.COD_STRUTTURA_COMPETENTE_FI =
                         S.COD_STRUTTURA_COMPETENTE
                  AND SORG.COD_ABI_ISTITUTO_FI = S.COD_ABI_ISTITUTO
                  AND S.DTA_CHIUSURA IS NULL
                  AND gu.DESC_CRITERIO_ASSEGNAZIONE NOT IN ('PR', 'AR')
           UNION
           SELECT DISTINCT
                  SORG.COD_STRUTTURA_COMPETENTE_DC,
                  SORG.COD_STRUTTURA_COMPETENTE_DV,
                  SORG.COD_STRUTTURA_COMPETENTE_RG,
                  SORG.COD_STRUTTURA_COMPETENTE_AR,
                  NULL AS COD_STRUTTURA_COMPETENTE_FI,
                  SORG.COD_ABI_ISTITUTO_AR AS COD_ABI_ISTITUTO,
                  DESC_STRUTTURA_COMPETENTE_AR AS DESC_STRUTTURA_COMPETENTE,
                  GU.ID_UTENTE,
                  COD_MATRICOLA,
                  U.COGNOME,
                  team,
                  GU.DESC_CRITERIO_ASSEGNAZIONE AS COD_CRITERIO_ASSEGN,
                  GU.DTA_INS AS DTA_INS,
                  GU.DTA_UPD AS DTA_UPD,
                  GU.COD_COMPARTO_ASSEGNATARIO,
                  GU.FLG_ATTIVO,
                  GU.COD_STRUTTURA_ASSEGNATARIO,
                  GU.DESC_TIPO_STRUTTURA,
                  GU.COD_MATRICOLA_ASSEGNATARIO,
                  GU.COD_PROCESSO,
                  U.NOME
             FROM (SELECT DISTINCT COD_STRUTTURA_COMPETENTE_DC,
                                   COD_STRUTTURA_COMPETENTE_DV,
                                   COD_STRUTTURA_COMPETENTE_RG,
                                   COD_STRUTTURA_COMPETENTE_AR,
                                   COD_LIVELLO_AR,
                                   COD_ABI_ISTITUTO_AR,
                                   DESC_STRUTTURA_COMPETENTE_AR
                     FROM MV_MCRE0_DENORM_STR_ORG
                    WHERE     COD_LIVELLO_AR = 'AR'
                          AND (COD_ABI_ISTITUTO_AR,
                               COD_STRUTTURA_COMPETENTE_AR) NOT IN
                                 (SELECT AREA.COD_ABI_ISTITUTO,
                                         AREA.COD_STRUTTURA_COMPETENTE
                                    FROM (SELECT *
                                            FROM T_MCRE0_APP_STRUTTURA_ORG
                                           WHERE COD_LIVELLO = 'AR') AREA,
                                         (SELECT *
                                            FROM T_MCRE0_APP_STRUTTURA_ORG
                                           WHERE COD_LIVELLO = 'FI') STR
                                   WHERE     AREA.COD_STRUTTURA_COMPETENTE =
                                                STR.COD_STR_ORG_SUP(+)
                                         AND AREA.COD_ABI_ISTITUTO =
                                                STR.COD_ABI_ISTITUTO(+)
                                         AND STR.COD_STR_ORG_SUP IS NULL
                                         AND STR.COD_ABI_ISTITUTO IS NULL)) SORG,
                  (SELECT DISTINCT
                          COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          NULL AS COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO AS ID_UTENTE,
                          COD_MATRICOLA_ASSEGNATA AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'C' AS team,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'AR'
                          AND FLG_ATTIVO = '1'
                   UNION
                   SELECT DISTINCT
                          COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          NULL AS COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO_PT AS id_utente,
                          COD_MATRICOLA_ASSEGNATA_pt AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'B' AS TEAM,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'AR'
                          AND FLG_ATTIVO = '1') GU,
                  T_MCRE0_APP_UTENTI U,
                  T_MCRE0_APP_STRUTTURA_ORG S
            WHERE     NVL (SORG.COD_ABI_ISTITUTO_AR, '1') =
                         NVL (GU.COD_ABI_ISTITUTO(+), '1')
                  AND GU.COD_MATRICOLA_gu = U.COD_MATRICOLA(+)
                  AND SORG.COD_STRUTTURA_COMPETENTE_AR =
                         S.COD_STRUTTURA_COMPETENTE
                  AND SORG.COD_ABI_ISTITUTO_AR = S.COD_ABI_ISTITUTO
                  AND S.DTA_CHIUSURA IS NULL
                  AND gu.DESC_CRITERIO_ASSEGNAZIONE NOT IN ('PR', 'FI')
           -----------DR--------------
           UNION
           SELECT DISTINCT
                  SORG.COD_STRUTTURA_COMPETENTE_DC,
                  SORG.COD_STRUTTURA_COMPETENTE_DV,
                  SORG.COD_STRUTTURA_COMPETENTE_RG,
                  SORG.COD_STRUTTURA_COMPETENTE_AR,
                  SORG.COD_STRUTTURA_COMPETENTE_FI,
                  SORG.COD_ABI_ISTITUTO_FI AS COD_ABI_ISTITUTO,
                  SORG.DESC_STRUTTURA_COMPETENTE_FI
                     AS DESC_STRUTTURA_COMPETENTE,
                  GU.ID_UTENTE,
                  COD_MATRICOLA,
                  U.COGNOME,
                  team,
                  GU.DESC_CRITERIO_ASSEGNAZIONE AS COD_CRITERIO_ASSEGN,
                  GU.DTA_INS AS DTA_INS,
                  GU.DTA_UPD AS DTA_UPD,
                  GU.COD_COMPARTO_ASSEGNATARIO,
                  GU.FLG_ATTIVO,
                  GU.COD_STRUTTURA_ASSEGNATARIO,
                  GU.DESC_TIPO_STRUTTURA,
                  GU.COD_MATRICOLA_ASSEGNATARIO,
                  GU.COD_PROCESSO,
                  U.NOME
             FROM (SELECT DISTINCT COD_STRUTTURA_COMPETENTE_DC,
                                   COD_STRUTTURA_COMPETENTE_DV,
                                   COD_STRUTTURA_COMPETENTE_RG,
                                   COD_STRUTTURA_COMPETENTE_AR,
                                   COD_STRUTTURA_COMPETENTE_FI,
                                   COD_LIVELLO_FI,
                                   COD_ABI_ISTITUTO_FI,
                                   DESC_STRUTTURA_COMPETENTE_FI
                     FROM MV_MCRE0_DENORM_STR_ORG
                    WHERE COD_LIVELLO_FI = 'FI') SORG,
                  (SELECT COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO AS ID_UTENTE,
                          COD_MATRICOLA_ASSEGNATA AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'C' AS TEAM,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'PR'
                          AND FLG_ATTIVO = '1'
                   UNION
                   SELECT COD_STRUTTURA_COMPETENTE_DC,
                          COD_STRUTTURA_COMPETENTE_DV,
                          COD_STRUTTURA_COMPETENTE_RG,
                          COD_STRUTTURA_COMPETENTE_AR,
                          COD_STRUTTURA_COMPETENTE_FI,
                          DESC_CRITERIO_ASSEGNAZIONE,
                          COD_MATRICOLA_ASSEGNATARIO,
                          COD_COMPARTO_ASSEGNATARIO,
                          ID_UTENTE_ASSEGNATO_PT AS ID_UTENTE,
                          COD_MATRICOLA_ASSEGNATA_pt AS cod_matricola_gu,
                          COD_ABI_ISTITUTO,
                          DTA_INS,
                          DTA_UPD,
                          COD_STRUTTURA_ASSEGNATARIO,
                          DESC_TIPO_STRUTTURA,
                          FLG_ATTIVO,
                          'B' AS team,
                          COD_PROCESSO
                     FROM T_MCRE0_APP_ASSOCIA_GESTORI_UO
                    WHERE     DESC_CRITERIO_ASSEGNAZIONE = 'PR'
                          AND FLG_ATTIVO = '1') GU,
                  T_MCRE0_APP_UTENTI U,
                  T_MCRE0_APP_STRUTTURA_ORG S
            WHERE     NVL (SORG.COD_STRUTTURA_COMPETENTE_FI, '1') =
                         NVL (GU.COD_STRUTTURA_COMPETENTE_FI(+), '1')
                  AND NVL (SORG.COD_ABI_ISTITUTO_FI, '1') =
                         NVL (GU.COD_ABI_ISTITUTO(+), '1')
                  AND GU.COD_MATRICOLA_gu = U.COD_MATRICOLA(+)
                  AND SORG.COD_STRUTTURA_COMPETENTE_FI =
                         S.COD_STRUTTURA_COMPETENTE
                  AND SORG.COD_ABI_ISTITUTO_FI = S.COD_ABI_ISTITUTO
                  AND S.DTA_CHIUSURA IS NULL
                  AND gu.DESC_CRITERIO_ASSEGNAZIONE NOT IN ('FI', 'AR'));


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_GESTORE_UO_ALL TO MCRE_USR;
