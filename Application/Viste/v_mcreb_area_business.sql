/* Formatted on 21/07/2014 18:38:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_AREA_BUSINESS
(
   COD_AREA_BUSINESS,
   ORD_AREA_BUSINESS,
   DES_AREA_BUSINESS
)
AS
   SELECT DISTINCT
          NVL (UPPER (cod_div), '#') cod_area_business,
          CASE
             WHEN cod_div IN ('DIVRE', 'DIVCI', 'DIVPR') THEN 1
             WHEN cod_div IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES') THEN 2
             ELSE 3
          END
             ord_area_business,
          CASE
             WHEN cod_div IN ('DIVRE', 'DIVCI', 'DIVPR')
             THEN
                'Banca dei territori'
             WHEN cod_div IN ('DIVCC', 'DIVLC', 'DIVFI', 'DIVES')
             THEN
                'CIB'
             ELSE
                'Altro'
          END
             des_area_business
     FROM mcre_own.T_MCRE0_APP_STRUTTURA_ORG;
