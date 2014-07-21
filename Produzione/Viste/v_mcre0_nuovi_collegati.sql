/* Formatted on 17/06/2014 18:05:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_NUOVI_COLLEGATI
(
   COD_GRUPPO_SUPER,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   MIN_DTA_UTENTE_ASSEGNATO,
   MIN_COD_COMPARTO_ASSEGNATO,
   MIN_COD_SERVIZIO,
   MIN_COD_RAMO,
   MIN_ID_UTENTE_1,
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
          "MIN_COD_SERVIZIO",
          "MIN_COD_RAMO",
          "MIN_ID_UTENTE_1",
          "NUM_UTENTI_1",
          "NUM_COMP_ASSEGNATI_1",
          "NUM_SERVIZI_1",
          "NUM_RAMI_1",
          "MIN_ID_UTENTE_CON_DATA",
          "MIN_ID_UTENTE_CON_COMPARTO",
          "FLG_RIGA_GIUSTA"
     FROM (SELECT DISTINCT
                  COD_GRUPPO_SUPER,
                  ID_UTENTE,
                  DTA_UTENTE_ASSEGNATO,
                  COD_COMPARTO_ASSEGNATO,
                  --COD_SERVIZIO,
                  --cod_ramo,
                  min_DTA_UTENTE_ASSEGNATO,
                  min_COD_COMPARTO_ASSEGNATO,
                  min_cod_servizio,
                  min_cod_ramo,
                  min_ID_UTENTE_1,
                  num_UTENTI_1,
                  num_comp_ASSEGNATI_1,
                  num_SERVIZI_1,
                  num_RAMI_1,
                  min_ID_UTENTE_CON_DATA,
                  min_ID_UTENTE_CON_COMPARTO,
                  CASE
                     WHEN     num_UTENTI_1 > 1
                          AND min_dta_utente_assegnato IS NOT NULL
                          AND num_comp_ASSEGNATI_1 = 1
                     THEN
                        CASE
                           WHEN     dta_utente_assegnato =
                                       min_dta_utente_assegnato
                                AND id_utente = min_ID_UTENTE_CON_DATA
                           THEN
                              1
                           ELSE
                              0
                        END
                     WHEN     num_UTENTI_1 > 1
                          AND min_dta_utente_assegnato IS NULL
                          AND num_comp_ASSEGNATI_1 = 1
                     THEN
                        CASE
                           WHEN     id_utente = min_ID_UTENTE_CON_COMPARTO
                                AND COD_COMPARTO_ASSEGNATO =
                                       min_COD_COMPARTO_ASSEGNATO
                           THEN
                              1
                           ELSE
                              0
                        END
                     WHEN     num_UTENTI_1 > 1
                          AND min_dta_utente_assegnato IS NOT NULL
                          AND num_comp_ASSEGNATI_1 > 1
                     THEN
                        CASE                               --v4.5.. solo qui?!
                           --when id_utente=min_ID_UTENTE_CON_COMPARTO  and dta_utente_assegnato = min_dta_utente_assegnato then decode(cod_comparto_assegnato,(select U.COD_COMPARTO_UTENTE from t_mcre0_app_utenti u where u.id_utente = min_ID_UTENTE_CON_COMPARTO) ,1,0)             ---comparto dell'utente
                           WHEN     id_utente IS NOT NULL
                                AND dta_utente_assegnato =
                                       min_dta_utente_assegnato
                           THEN
                              DECODE (
                                 cod_comparto_assegnato,
                                 (SELECT U.COD_COMPARTO_UTENTE
                                    FROM t_mcre0_app_utenti u
                                   WHERE u.id_utente =
                                            min_ID_UTENTE_CON_COMPARTO), 1,
                                 0)                    ---comparto dell'utente
                           ELSE
                              0
                        END
                     WHEN     num_UTENTI_1 > 1
                          AND min_dta_utente_assegnato IS NULL
                          AND num_comp_ASSEGNATI_1 > 1
                     THEN
                        CASE
                           WHEN id_utente = min_ID_UTENTE_CON_COMPARTO
                           THEN
                              DECODE (
                                 cod_comparto_assegnato,
                                 (SELECT U.COD_COMPARTO_UTENTE
                                    FROM t_mcre0_app_utenti u
                                   WHERE u.id_utente =
                                            min_ID_UTENTE_CON_COMPARTO), 1,
                                 0)                   --- comparto dell'utente
                           ELSE
                              0
                        END
                     WHEN     num_UTENTI_1 = 1
                          AND min_ID_UTENTE_1 != -1
                          AND num_comp_ASSEGNATI_1 > 1
                     THEN
                        DECODE (cod_comparto_assegnato,
                                (SELECT U.COD_COMPARTO_UTENTE
                                   FROM t_mcre0_app_utenti u
                                  WHERE u.id_utente = min_ID_UTENTE), 1,
                                0)                    --- comparto dell'utente
                     WHEN     num_UTENTI_1 = 1
                          AND min_ID_UTENTE_1 = -1
                          AND num_comp_ASSEGNATI_1 > 1
                     THEN
                        CASE
                           WHEN     cod_ramo IS NULL
                                AND min_COD_ramo_CON_COMPARTO IS NULL
                           THEN
                              DECODE (cod_comparto_assegnato,
                                      min_cod_comparto_assegnato, 1,
                                      0)
                           ELSE
                              DECODE (
                                 cod_ramo,
                                 min_COD_ramo_CON_COMPARTO, DECODE (
                                                               cod_comparto_assegnato,
                                                               NULL, 0,
                                                               1),
                                 0)
                        END
                     -- VG 20140403 DECODE ( cod_ramo,   min_COD_ramo_CON_COMPARTO, DECODE (  cod_comparto_assegnato, NULL, 0, 1), 0)
                     ELSE
                        0
                  END
                     flg_riga_giusta
             FROM (SELECT COD_GRUPPO_SUPER,
                          ID_UTENTE,
                          DTA_UTENTE_ASSEGNATO,
                          COD_COMPARTO_ASSEGNATO,
                          COD_SERVIZIO,
                          cod_ramo_calcolato cod_ramo,
                          MIN (DTA_UTENTE_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_DTA_UTENTE_ASSEGNATO,
                          MIN (NVL (COD_COMPARTO_ASSEGNATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_COD_COMPARTO_ASSEGNATO_1,
                          MIN (NVL (cod_servizio, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_cod_servizio_1,
                          MIN (NVL (cod_ramo_calcolato, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_cod_ramo_1,
                          MIN (NVL (ID_UTENTE, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_ID_UTENTE_1,
                          MIN (COD_COMPARTO_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_COD_COMPARTO_ASSEGNATO,
                          MIN (cod_servizio)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_cod_servizio,
                          MIN (cod_ramo_calcolato)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_cod_ramo,
                          MIN (ID_UTENTE)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_ID_UTENTE,
                          MIN (
                             DECODE (DTA_UTENTE_ASSEGNATO,
                                     NULL, NULL,
                                     ID_UTENTE))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_ID_UTENTE_CON_DATA,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, NULL,
                                     ID_UTENTE))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_ID_UTENTE_CON_COMPARTO,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, NULL,
                                     DTA_UTENTE_ASSEGNATO))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_DTA_UTENTE_CON_COMPARTO,
                          MIN (
                             DECODE (COD_COMPARTO_ASSEGNATO,
                                     NULL, NULL,
                                     COD_ramo_calcolato))
                          OVER (PARTITION BY COD_GRUPPO_SUPER)
                             min_COD_ramo_CON_COMPARTO,
                          COUNT (DISTINCT NVL (COD_COMPARTO_ASSEGNATO, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_comp_ASSEGNATI_1,
                          COUNT (DISTINCT NVL (cod_servizio, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_SERVIZI_1,
                          COUNT (DISTINCT NVL (cod_ramo_calcolato, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_RAMI_1,
                          COUNT (DISTINCT NVL (ID_UTENTE, -1))
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_UTENTI_1,
                          COUNT (DISTINCT COD_COMPARTO_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_comp_ASSEGNATI,
                          COUNT (DISTINCT cod_servizio)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_SERVIZI,
                          COUNT (DISTINCT cod_ramo_calcolato)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_RAMI,
                          COUNT (DISTINCT ID_UTENTE)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_UTENTI,
                          COUNT (DISTINCT DTA_UTENTE_ASSEGNATO)
                             OVER (PARTITION BY COD_GRUPPO_SUPER)
                             num_DTA_UTENTE_ASSEGNATO
                     FROM ttmcre0_web_data_5 T
                    WHERE     T.COD_GRUPPO_SUPER IS NOT NULL
                          AND T.flg_active = '1')
            WHERE num_UTENTI_1 > 1 OR num_comp_ASSEGNATI_1 > 1)
    WHERE flg_riga_giusta = 1;


GRANT SELECT ON MCRE_OWN.V_MCRE0_NUOVI_COLLEGATI TO MCRE_USR;
