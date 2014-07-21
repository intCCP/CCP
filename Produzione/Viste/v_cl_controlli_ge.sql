/* Formatted on 17/06/2014 17:59:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_GE
(
   COD_GE,
   GRUPPO_ECONOMICO,
   MACROSTATO_GE,
   STATO_GE,
   CONTEGGIO_GE
)
AS
   SELECT a.cod_ge,
          a.gruppo_economico,
          a.macrostato_ge,
          a.stato_ge,
          a.conteggio_ge
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.macrostato_ge IS NOT NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_CL_CONTROLLI_GE TO MCRE_USR;
