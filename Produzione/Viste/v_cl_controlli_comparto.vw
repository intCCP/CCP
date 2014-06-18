/* Formatted on 17/06/2014 17:59:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_COMPARTO
(
   COMPARTO,
   MACROSTATO_COMPARTO,
   STATO_COMPARTO,
   PROCESSO_COMPARTO,
   CONTEGGIO_COMPARTO
)
AS
   SELECT a.comparto,
          a.macrostato_comparto,
          a.stato_comparto,
          a.processo_comparto,
          a.conteggio_comparto
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.comparto IS NOT NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_CL_CONTROLLI_COMPARTO TO MCRE_USR;
