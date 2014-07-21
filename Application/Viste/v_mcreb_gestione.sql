/* Formatted on 21/07/2014 18:38:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_GESTIONE
(
   COD_GESTIONE,
   ORD_GESTIONE,
   DES_GESTIONE,
   TIPO_GESTIONE
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
             Tipo_Gestione
     FROM mcre_own.T_MCRE0_APP_STRUTTURA_ORG;
