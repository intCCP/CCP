/* Formatted on 21/07/2014 18:30:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_GST
(
   COD_GESTIONE,
   ORD_GESTIONE,
   DES_GESTIONE,
   TIPO_GESTIONE,
   COD_ABI,
   COD_PRESIDIO,
   DES_PRESIDIO,
   TIPO_PRESIDIO,
   COD_TIPO,
   COD_MACROGESTIONE
)
AS
   SELECT DISTINCT
          UPPER (cod_livello) cod_gestione,
          CASE
             WHEN UPPER (cod_livello) IN ('PL', 'RC') THEN 1
             WHEN UPPER (cod_livello) IN ('IC', 'IP') THEN 2
             ELSE 3
          END
             ord_Gestione,
          CASE
             WHEN UPPER (cod_livello) IN ('PL', 'RC')
             THEN
                'DRC - Interna'
             WHEN UPPER (cod_livello) IN ('IC', 'IP')
             THEN
                'Italfondiario - Esterna'
             ELSE
                'Non assegnato'
          END
             des_Gestione,
          CASE
             WHEN UPPER (cod_livello) IN ('PL', 'RC') THEN 'Interna'
             WHEN UPPER (cod_livello) IN ('IC', 'IP') THEN 'Esterna'
             ELSE 'Da assegnare'
          END
             Tipo_Gestione,
          CASE
             WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                  AND cod_abi_istituto = '01025'
             THEN
                cod_abi_istituto
             ELSE
                '#'
          END
             cod_abi,
          CASE
             WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                  AND cod_abi_istituto = '01025'
             THEN
                COD_STRUTTURA_COMPETENTE
             ELSE
                '#'
          END
             cod_presidio,
          CASE
             WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                  AND cod_abi_istituto = '01025'
             THEN
                DESC_STRUTTURA_COMPETENTE
             ELSE
                NULL
          END
             des_presidio,
          CASE
             WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                  AND cod_abi_istituto = '01025'
             THEN
                CASE
                   WHEN COD_LIVELLO IN ('PL', 'RC') THEN 'I'
                   WHEN COD_LIVELLO IN ('IP', 'IC') THEN 'E'
                   ELSE NULL
                END
             ELSE
                NULL
          END
             TIPO_Presidio,
          CASE
             WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                  AND cod_abi_istituto = '01025'
             THEN
                CASE WHEN COD_LIVELLO IN ('PL', 'IP') THEN 'P' ELSE NULL END
             ELSE
                NULL
          END
             cod_tipo,
          CASE WHEN COD_LIVELLO IN ('PL', 'RC') THEN 'I' ELSE 'A' END
             COD_MACROGESTIONE
     FROM mcre_own.T_MCRE0_APP_STRUTTURA_ORG;
