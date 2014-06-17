/* Formatted on 17/06/2014 18:17:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_CHECK_UTENTI
(
   COD_MATRICOLA,
   COGNOME,
   NOME,
   POSIZIONI_DIREZIONE
)
AS
     SELECT c.cod_matricola,
            c.cognome,
            c.nome,
            COUNT (*) AS posizioni_direzione
       FROM VTMCRE0_APP_HP_EXCEL a, t_mcre0_app_stati b, t_mcre0_app_utenti c
      WHERE     1 = 1
            AND a.cod_comparto IN
                   ('011905', '006601', '011906', '004195', '011901')
            AND a.COD_STATO = b.COD_MICROSTATO
            AND a.FLG_OUTSOURCING = 'Y'
            --  and     a.COD_PROCESSO in ('GF','GI','GR','GC','GL','GP','EG','CG')
            AND a.id_utente = c.id_utente
   GROUP BY c.cod_matricola, c.cognome, c.nome
   ORDER BY c.cod_matricola, c.cognome, c.nome;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_CHECK_UTENTI TO MCRE_USR;
