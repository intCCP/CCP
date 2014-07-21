/* Formatted on 21/07/2014 18:31:21 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_PUNTO6
(
   FLG_CAMBIO_STATO,
   PRIMA_STORICIZZAZIONE,
   ULTIMA_STORICIZZAZIONE,
   QUANTI
)
AS
   SELECT a.flg_cambio_stato,
          a.prima_storicizzazione,
          a.ultima_storicizzazione,
          a.quanti
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.flg_cambio_stato IS NOT NULL;
