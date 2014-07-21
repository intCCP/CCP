/* Formatted on 21/07/2014 18:41:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_CRITERI
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
   DESC_PRESIDIO
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
          o.desc_presidio
     FROM t_mcres_app_criteri c, V_MCRES_APP_LISTA_PRESIDI o
    WHERE     dta_fine IS NULL
          AND desc_criterio2 IS NULL
          AND c.cod_presidio = o.cod_presidio;
