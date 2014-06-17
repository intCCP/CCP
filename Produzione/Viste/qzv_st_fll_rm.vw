/* Formatted on 17/06/2014 17:58:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_FLL_RM
(
   COD_SRC,
   ID_DPER,
   COD_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_FILIALE,
   COD_PRESIDIO,
   COD_GESTIONE,
   COD_AREA_BUSINESS,
   COD_STATO_GIURIDICO
)
AS
   SELECT COD_SRC,
          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6) id_dper,
          COD_STATO_RISCHIO,
          '#' COD_ABI,
          '#' COD_NDG,
          '#' COD_SNDG,
          '#' COD_GRUPPO_ECONOMICO,
          '#' COD_FILIALE,
          '#' COD_PRESIDIO,
          '#' COD_GESTIONE,
          COD_AREA_BUSINESS,
          '#' COD_STATO_GIURIDICO
     FROM (SELECT 'RM' COD_SRC FROM DUAL) src,
          (SELECT 'I' COD_STATO_RISCHIO FROM DUAL
           UNION ALL
           SELECT 'S' COD_STATO_RISCHIO FROM DUAL
           ORDER BY 1) str,
          (  SELECT cod_area_business
               FROM mcre_own.QZV_ST_MIS_ABS
           ORDER BY 1) ABS;


GRANT SELECT ON MCRE_OWN.QZV_ST_FLL_RM TO MCRE_USR;
