/* Formatted on 17/06/2014 18:12:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_CL_PRODOTTI_SOFF
(
   COD_TIPO_SOFF,
   VAL_DESC_TIPO_SOFF,
   FLG_FILIALE,
   FLG_PRESIDIO,
   FLG_AUTOMATICA,
   FLG_DISMESSA,
   DTA_INS,
   MATRICOLA_INS
)
AS
   SELECT COD_TIPO_SOFF,
          VAL_DESC_TIPO_SOFF,
          FLG_FILIALE,
          FLG_PRESIDIO,
          FLG_AUTOMATICA,
          FLG_DISMESSA,
          DTA_INS,
          MATRICOLA_INS
     FROM T_MCRES_CL_PRODOTTI_SOFF;


GRANT SELECT ON MCRE_OWN.V_MCRES_CL_PRODOTTI_SOFF TO MCRE_USR;
