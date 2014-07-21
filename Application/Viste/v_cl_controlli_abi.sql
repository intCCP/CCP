/* Formatted on 21/07/2014 18:31:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_ABI
(
   ABI,
   MACROSTATO_ABI,
   STATO_ABI,
   PROCESSO_ABI,
   CONTEGGIO_ABI
)
AS
   SELECT a.abi,
          a.macrostato_abi,
          a.stato_abi,
          a.processo_abi,
          a.conteggio_abi
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.abi IS NOT NULL;
