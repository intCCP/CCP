/* Formatted on 21/07/2014 18:30:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_FLL_BM
(
   COD_SRC,
   ID_DPER,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
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
          DES_STATO_RISCHIO,
          COD_ABI,
          '#' COD_NDG,
          '#' COD_SNDG,
          '#' COD_GRUPPO_ECONOMICO,
          '#' COD_FILIALE,
          '#' COD_PRESIDIO,
          COD_GESTIONE,
          '#' COD_AREA_BUSINESS,
          COD_STATO_GIURIDICO
     FROM (SELECT 'BM' COD_SRC FROM DUAL) src,
          (  SELECT DISTINCT cod_abi
               FROM mcre_own.QZV_ST_MIS_ABI
           ORDER BY 1) abi,
          (SELECT 'I' COD_STATO_RISCHIO, 'Incagli' DES_STATO_RISCHIO
             FROM DUAL
           UNION ALL
           SELECT 'S' COD_STATO_RISCHIO, 'Sofferenze' DES_STATO_RISCHIO
             FROM DUAL
           ORDER BY 1) str,
          (  SELECT DISTINCT
                    MIN (UPPER (COD_GESTIONE))
                       OVER (PARTITION BY TIPO_GESTIONE)
                       COD_GESTIONE
               FROM mcre_own.QZV_ST_MIS_GST
           ORDER BY 1) ges,
          (  SELECT DISTINCT UPPER (COD_STATO_GIURIDICO) COD_STATO_GIURIDICO
               FROM mcre_own.QZV_ST_MIS_STG
              WHERE COD_STATO_GIURIDICO IS NOT NULL
           ORDER BY 1) stg;
