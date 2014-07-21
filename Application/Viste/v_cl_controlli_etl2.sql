/* Formatted on 21/07/2014 18:31:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_ETL2
(
   GIORNO,
   NOME_GIORNO,
   ORARIO_INIZIO,
   ORARIO_FINE,
   TEMPO_TOTALE
)
AS
   SELECT a.giorno,
          a.nome_giorno,
          a.orario_inizio,
          a.orario_fine,
          a.tempo_totale
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.giorno IS NOT NULL;
