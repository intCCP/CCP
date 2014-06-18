/* Formatted on 17/06/2014 18:10:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CRITERI_REG
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
   DESC_PRESIDIO,
   DESC_REGIONE,
   DESC_PROVINCIA
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
          o.desc_presidio,
          (SELECT nome
             FROM T_MCRES_CL_REGIONI
            WHERE codice = DESC_CRITERIO)
             desc_regione,
          (SELECT nome
             FROM T_MCRES_CL_province
            WHERE codice_regione = DESC_CRITERIO AND codice = DESC_CRITERIO2)
             desc_provincia
     FROM t_mcres_app_criteri c, V_MCRES_APP_LISTA_PRESIDI o
    WHERE     dta_fine IS NULL
          AND desc_criterio2 IS NOT NULL
          AND c.cod_presidio = o.cod_presidio;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_CRITERI_REG TO MCRE_USR;
