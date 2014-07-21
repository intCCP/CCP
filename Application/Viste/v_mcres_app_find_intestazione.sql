/* Formatted on 21/07/2014 18:42:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_FIND_INTESTAZIONE
(
   COD_SNDG,
   DESC_NOME_CONTROPARTE
)
AS
   SELECT cod_sndg, desc_nome_controparte
     FROM t_mcre0_app_anagrafica_gruppo
    WHERE UPPER (desc_nome_controparte) LIKE
                '%'
             || UPPER (
                   REPLACE (SYS_CONTEXT ('userenv', 'client_info'), ' ', '%'))
             || '%';
