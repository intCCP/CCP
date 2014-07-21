/* Formatted on 21/07/2014 18:41:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CRITERI_CHIUSI
(
   ID_CRITERIO,
   FLG_CRITERIO,
   DESC_CRITERIO,
   DESC_CRITERIO2,
   VAL_PRIORITA,
   COD_PRESIDIO,
   DTA_INIZIO,
   DTA_FINE,
   COD_MATR_PRATICA,
   COD_TIPO_OPERAZIONE,
   ID_CRITERIO_NUOVO,
   DESC_PRESIDIO,
   DESC_VARIAZIONE
)
AS
   SELECT c."ID_CRITERIO",
          c."FLG_CRITERIO",
          c."DESC_CRITERIO",
          c."DESC_CRITERIO2",
          c."VAL_PRIORITA",
          c."COD_PRESIDIO",
          c."DTA_INIZIO",
          c."DTA_FINE",
          c."COD_MATR_PRATICA",
          c."COD_TIPO_OPERAZIONE",
          c."ID_CRITERIO_NUOVO",
          o.desc_presidio,
          CASE
             WHEN FLG_CRITERIO = 'C'
             THEN
                CASE
                   WHEN dta_fine IS NOT NULL AND id_criterio_nuovo IS NULL
                   THEN
                         'CANCELLAZIONE: '
                      || DESC_CRITERIO
                      || ' su '
                      || desc_presidio
                   WHEN (COD_TIPO_OPERAZIONE = 'I')
                   THEN
                         'INSERIMENTO: '
                      || DESC_CRITERIO
                      || ' su '
                      || desc_presidio
                      || ' con priorità '
                      || VAL_PRIORITA
                   WHEN COD_TIPO_OPERAZIONE = 'U'
                   THEN
                         'VARIAZIONE: '
                      || DESC_CRITERIO
                      || ' da '
                      || (SELECT (SELECT desc_presidio
                                    FROM V_MCRES_APP_LISTA_PRESIDI ii
                                   WHERE ii.cod_presidio = c2.cod_presidio)
                            FROM t_mcres_app_criteri c2
                           WHERE c2.id_criterio_nuovo = c.id_criterio)
                      || ' con priorità '
                      || (SELECT VAL_PRIORITA
                            FROM t_mcres_app_criteri c2
                           WHERE c2.id_criterio_nuovo = c.id_criterio)
                      || ' a '
                      || desc_presidio
                      || ' con priorità '
                      || VAL_PRIORITA
                END
             WHEN FLG_CRITERIO = 'R'
             THEN
                CASE
                   WHEN dta_fine IS NOT NULL AND id_criterio_nuovo IS NULL
                   THEN
                         'CANCELLAZIONE: '
                      || (SELECT nome
                            FROM T_MCRES_CL_REGIONI
                           WHERE codice = DESC_CRITERIO)
                      || ' - '
                      || (SELECT nome
                            FROM T_MCRES_CL_province
                           WHERE     codice_regione = DESC_CRITERIO
                                 AND codice = DESC_CRITERIO2)
                      || ' - '
                      || desc_presidio
                   WHEN COD_TIPO_OPERAZIONE = 'I'
                   THEN
                         'INSERIMENTO: '
                      || (SELECT nome
                            FROM T_MCRES_CL_REGIONI
                           WHERE codice = DESC_CRITERIO)
                      || ' - '
                      || (SELECT nome
                            FROM T_MCRES_CL_province
                           WHERE     codice_regione = DESC_CRITERIO
                                 AND codice = DESC_CRITERIO2)
                      || ' - '
                      || desc_presidio
                   WHEN COD_TIPO_OPERAZIONE = 'U'
                   THEN
                         'VARIAZIONE: da '
                      || (SELECT (SELECT nome
                                    FROM T_MCRES_CL_REGIONI
                                   WHERE codice = c2.DESC_CRITERIO)
                            FROM t_mcres_app_criteri c2
                           WHERE c2.id_criterio_nuovo = c.id_criterio)
                      || ' - '
                      || (SELECT (SELECT nome
                                    FROM T_MCRES_CL_province
                                   WHERE     codice_regione = DESC_CRITERIO
                                         AND codice = DESC_CRITERIO2)
                            FROM t_mcres_app_criteri c2
                           WHERE c2.id_criterio_nuovo = c.id_criterio)
                      || ' - '
                      || (SELECT (SELECT desc_presidio
                                    FROM V_MCRES_APP_LISTA_PRESIDI ii
                                   WHERE ii.cod_presidio = c2.cod_presidio)
                            FROM t_mcres_app_criteri c2
                           WHERE c2.id_criterio_nuovo = c.id_criterio)
                      || ' a '
                      || (SELECT nome
                            FROM T_MCRES_CL_REGIONI
                           WHERE codice = DESC_CRITERIO)
                      || ' - '
                      || (SELECT nome
                            FROM T_MCRES_CL_province
                           WHERE     codice_regione = DESC_CRITERIO
                                 AND codice = DESC_CRITERIO2)
                      || ' - '
                      || desc_presidio
                END
          END
             desc_variazione
     FROM t_mcres_app_criteri c, V_MCRES_APP_LISTA_PRESIDI o
    WHERE c.cod_presidio = o.cod_presidio;
