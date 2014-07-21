/* Formatted on 21/07/2014 18:44:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_TEST_LOAD_UTENTI
(
   ID_UTENTE,
   COD_MATRICOLA,
   COGNOME,
   NOME,
   COD_COMPARTO_APPART,
   COD_COMPARTO_ASSEGN,
   COD_COMPARTO_UTENTE
)
AS
   SELECT DISTINCT TO_NUMBER (te.cod_matricola) AS id_utente,
                   CONCAT ('U', te.cod_matricola) cod_matricola,
                   RTRIM (te.cognome) cognome,
                   RTRIM (te.nome) nome,
                   cod_uo AS cod_comparto_appart,
                   cod_uo AS cod_comparto_assegn,
                   cod_uo AS cod_comparto_utente
     FROM te_mcrei_personale te;
