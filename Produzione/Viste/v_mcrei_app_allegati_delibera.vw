/* Formatted on 17/06/2014 18:07:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_ALLEGATI_DELIBERA
(
   COD_DOCUMENTO,
   DESC_DOCUMENTO,
   COD_PROTOCOLLO_PACCHETTO,
   DTA_UPD
)
AS
   SELECT DISTINCT (A.COD_DOCUMENTO),
                   A.DESC_DOCUMENTO,
                   B.COD_PROTOCOLLO_PACCHETTO,
                   B.DTA_UPD
     FROM T_MCREI_CL_ALLEGATI_DELIB A, T_MCREI_APP_ALLEGATI_DELIBERA B
    WHERE A.COD_DOCUMENTO = B.COD_DOCUMENTO;


GRANT SELECT ON MCRE_OWN.V_MCREI_APP_ALLEGATI_DELIBERA TO MCRE_USR;