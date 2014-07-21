/* Formatted on 21/07/2014 18:31:23 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_PUNTO8_
(
   STATO,
   CONTEGGIO
)
AS
   SELECT a.stato, a.conteggio
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.stato IS NOT NULL;
