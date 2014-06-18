/* Formatted on 17/06/2014 18:06:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_SPALMA_GRUPPI
(
   COD_GRUPPO_SUPER,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   MIN_DTA_UTENTE_ASSEGNATO,
   MIN_COD_COMPARTO_ASSEGNATO,
   MIN_ID_UTENTE_1,
   MIN_ID_UTENTE,
   MAX_ID_UTENTE,
   ID_UTENTE_DATA_MIN,
   NUM_UTENTI_1,
   NUM_COMP_ASSEGNATI_1,
   NUM_SERVIZI_1,
   NUM_RAMI_1,
   MIN_ID_UTENTE_CON_DATA,
   MIN_ID_UTENTE_CON_COMPARTO,
   FLG_RIGA_GIUSTA
)
AS
   SELECT "COD_GRUPPO_SUPER",
          "ID_UTENTE",
          "DTA_UTENTE_ASSEGNATO",
          "COD_COMPARTO_ASSEGNATO",
          "MIN_DTA_UTENTE_ASSEGNATO",
          "MIN_COD_COMPARTO_ASSEGNATO",
          "MIN_ID_UTENTE_1",
          "MIN_ID_UTENTE",
          "MAX_ID_UTENTE",
          "ID_UTENTE_DATA_MIN",
          "NUM_UTENTI_1",
          "NUM_COMP_ASSEGNATI_1",
          "NUM_SERVIZI_1",
          "NUM_RAMI_1",
          "MIN_ID_UTENTE_CON_DATA",
          "MIN_ID_UTENTE_CON_COMPARTO",
          "FLG_RIGA_GIUSTA"
     FROM (SELECT DISTINCT
                  (COD_GRUPPO_SUPER),
                  ID_UTENTE,
                  DTA_UTENTE_ASSEGNATO,
                  COD_COMPARTO_ASSEGNATO,
                  MIN_DTA_UTENTE_ASSEGNATO,
                  MIN_COD_COMPARTO_ASSEGNATO,
                  -- MIN_COD_SERVIZIO,
                  -- MIN_COD_RAMO,
                  MIN_ID_UTENTE_1,
                  /* AGGIUNTA IO */
                  MIN_ID_UTENTE,
                  /* AGGIUNTA IO */
                  MAX_ID_UTENTE,
                  /* AGGIUNTA IO */
                  ID_UTENTE_DATA_MIN,
                  NUM_UTENTI_1,
                  NUM_COMP_ASSEGNATI_1,
                  NUM_SERVIZI_1,
                  NUM_RAMI_1,
                  MIN_ID_UTENTE_CON_DATA,
                  MIN_ID_UTENTE_CON_COMPARTO,
                  CASE
                     WHEN     NUM_UTENTI_1 > 1
                          AND MIN_DTA_UTENTE_ASSEGNATO IS NOT NULL
                          AND NUM_COMP_ASSEGNATI_1 = 1
                     THEN
                        CASE
                           WHEN     DTA_UTENTE_ASSEGNATO =
                                       MIN_DTA_UTENTE_ASSEGNATO
                                AND ID_UTENTE = ID_UTENTE_DATA_MIN
                           THEN
                              1
                           ELSE
                              0
                        END
                     WHEN     NUM_UTENTI_1 > 1
                          AND MIN_DTA_UTENTE_ASSEGNATO IS NULL
                          AND NUM_COMP_ASSEGNATI_1 = 1
                     THEN
                        CASE
                           WHEN     ID_UTENTE = MIN_ID_UTENTE_CON_COMPARTO
                                AND COD_COMPARTO_ASSEGNATO =
                                       MIN_COD_COMPARTO_ASSEGNATO
                           THEN
                              1
                           ELSE
                              0
                        END
                     WHEN     NUM_UTENTI_1 > 1
                          AND MIN_DTA_UTENTE_ASSEGNATO IS NOT NULL
                          AND NUM_COMP_ASSEGNATI_1 > 1
                     THEN
                        CASE
                           WHEN     ID_UTENTE = MIN_ID_UTENTE
                                AND DTA_UTENTE_ASSEGNATO =
                                       MIN_DTA_UTENTE_ASSEGNATO
                           THEN
                              DECODE (
                                 COD_COMPARTO_ASSEGNATO,
                                 (SELECT U.COD_COMPARTO_UTENTE
                                    FROM T_MCRE0_APP_UTENTI U
                                   WHERE U.ID_UTENTE =
                                            MIN_ID_UTENTE_CON_COMPARTO), 1,
                                 0)
                           ---comparto dell'utente
                           ELSE
                              0
                        END
                     WHEN     NUM_UTENTI_1 > 1
                          AND MIN_DTA_UTENTE_ASSEGNATO IS NULL
                          AND NUM_COMP_ASSEGNATI_1 > 1
                     THEN
                        CASE
                           WHEN ID_UTENTE = MIN_ID_UTENTE_CON_COMPARTO
                           THEN
                              DECODE (
                                 COD_COMPARTO_ASSEGNATO,
                                 (SELECT U.COD_COMPARTO_UTENTE
                                    FROM T_MCRE0_APP_UTENTI U
                                   WHERE U.ID_UTENTE =
                                            MIN_ID_UTENTE_CON_COMPARTO), 1,
                                 0)
                           ---comparto dell'utente
                           ELSE
                              0
                        END
                     WHEN     NUM_UTENTI_1 = 1
                          AND MIN_ID_UTENTE_1 != -1
                          AND NUM_COMP_ASSEGNATI_1 > 1
                     THEN
                        DECODE (COD_COMPARTO_ASSEGNATO,
                                (SELECT U.COD_COMPARTO_UTENTE
                                   FROM T_MCRE0_APP_UTENTI U
                                  WHERE U.ID_UTENTE = MIN_ID_UTENTE), 1,
                                0)                     ---comparto dell'utente
                     WHEN     NUM_UTENTI_1 = 1
                          AND MIN_ID_UTENTE_1 = -1
                          AND NUM_COMP_ASSEGNATI_1 > 1
                     THEN
                        DECODE (
                           COD_RAMO,
                           MIN_COD_RAMO_CON_COMPARTO, DECODE (
                                                         COD_COMPARTO_ASSEGNATO,
                                                         NULL, 0,
                                                         1),
                           0)
                     ELSE
                        0
                  END
                     FLG_RIGA_GIUSTA
             FROM (SELECT COD_GRUPPO_SUPER,
                          ID_UTENTE,
                          DTA_UTENTE_ASSEGNATO,
                          COD_COMPARTO_ASSEGNATO,
                          COD_SERVIZIO,
                          COD_RAMO_CALCOLATO COD_RAMO,
                          MIN (DTA_UTENTE_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_DTA_UTENTE_ASSEGNATO,
                          MIN (NVL (COD_COMPARTO_ASSEGNATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_COMPARTO_ASSEGNATO_1,
                          MIN (NVL (COD_SERVIZIO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_SERVIZIO_1,
                          MIN (NVL (COD_RAMO_CALCOLATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_RAMO_1,
                          MIN (ID_UTENTE)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_ID_UTENTE_1,
                          /* AGGIUNTA IO */
                          MAX (ID_UTENTE)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MAX_ID_UTENTE,
                          MIN (COD_COMPARTO_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_COMPARTO_ASSEGNATO,
                          MIN (COD_SERVIZIO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_SERVIZIO,
                          MIN (COD_RAMO_CALCOLATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_RAMO,
                          MIN (NULLIF (ID_UTENTE, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_ID_UTENTE,
                          MIN (
                             DECODE (DTA_UTENTE_ASSEGNATO,
                                     NULL, TO_NUMBER (NULL),
                                     ID_UTENTE))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_ID_UTENTE_CON_DATA,
                          /* AGGIUNTA IO */
                          FIRST_VALUE (
                             ID_UTENTE)
                          OVER (PARTITION BY COD_GRUPPO_SUPER
                                ORDER BY DTA_UTENTE_ASSEGNATO)
                             ID_UTENTE_DATA_MIN,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, TO_NUMBER (NULL),
                                     ID_UTENTE))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_ID_UTENTE_CON_COMPARTO,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, NULL,
                                     DTA_UTENTE_ASSEGNATO))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_DTA_UTENTE_CON_COMPARTO,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, NULL,
                                     COD_RAMO_CALCOLATO))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             MIN_COD_RAMO_CON_COMPARTO,
                          COUNT (DISTINCT NVL (COD_COMPARTO_ASSEGNATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_COMP_ASSEGNATI_1,
                          COUNT (DISTINCT NVL (COD_SERVIZIO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_SERVIZI_1,
                          COUNT (DISTINCT NVL (COD_RAMO_CALCOLATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_RAMI_1,
                          COUNT (DISTINCT NVL (ID_UTENTE, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_UTENTI_1,
                          COUNT (DISTINCT COD_COMPARTO_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_COMP_ASSEGNATI,
                          COUNT (DISTINCT COD_SERVIZIO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_SERVIZI,
                          COUNT (DISTINCT COD_RAMO_CALCOLATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_RAMI,
                          COUNT (DISTINCT ID_UTENTE)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_UTENTI,
                          COUNT (DISTINCT DTA_UTENTE_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             NUM_DTA_UTENTE_ASSEGNATO
                     FROM T_MCRE0_ALL_DATA T
                    WHERE     COD_GRUPPO_SUPER IN
                                 (  SELECT COD_GRUPPO_SUPER
                                      FROM T_MCRE0_ALL_DATA TT
                                     WHERE     TT.COD_GRUPPO_SUPER IS NOT NULL
                                           AND TT.FLG_ACTIVE = '1'
                                           AND MCRE_OWN.FNC_MCREI_IS_NUMERIC (
                                                  COD_GRUPPO_SUPER) = 1
                                  GROUP BY COD_GRUPPO_SUPER
                                    HAVING COUNT (DISTINCT (ID_UTENTE)) > 1)
                          AND T.COD_GRUPPO_SUPER IS NOT NULL
                          AND T.FLG_ACTIVE = '1')
            WHERE NUM_UTENTI_1 > 1 OR NUM_COMP_ASSEGNATI_1 > 1)
    WHERE FLG_RIGA_GIUSTA = 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_SPALMA_GRUPPI TO MCRE_USR;
