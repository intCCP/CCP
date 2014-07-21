/* Formatted on 17/06/2014 18:10:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ORGANI_DELIBERANTI
(
   COD_ISTITUTO,
   COD_ABI,
   DESC_ISTITUTO,
   COD_UO,
   DESC_PRESIDIO,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   DTA_INIZIO,
   DTA_SCADENZA,
   DESC_RESPONSABILE
)
AS
   SELECT                                    -- 20130218 AG  Created this view
         cl.cod_istituto,
          cl.cod_abi,
          i.desc_istituto,
          cl.cod_uo,
          p.desc_presidio,
          cl.cod_organo_deliberante,
          cl.desc_organo_deliberante,
          cl.dta_inizio,
          cl.dta_scadenza,
          cl.desc_responsabile
     FROM t_mcres_cl_organo_deliberante cl,
          t_mcres_app_istituti i,
          v_mcres_app_lista_presidi p
    WHERE     0 = 0
          AND cl.cod_abi = i.cod_abi(+)
          AND cl.cod_uo = p.cod_presidio(+);


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ORGANI_DELIBERANTI TO MCRE_USR;
