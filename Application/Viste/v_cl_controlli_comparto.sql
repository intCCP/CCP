/* Formatted on 21/07/2014 18:31:18 (QP5 v5.227.12220.39754) */
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
