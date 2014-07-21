/* Formatted on 21/07/2014 18:31:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CL_CONTROLLI_PUNTO7
(
   DATA_EVENTO,
   COD_GRUPPO_SUPER,
   NUM_POS,
   CAMBIO_STATO,
   CAMBIO_COMP,
   CAMBIO_GEST
)
AS
   SELECT a.data_evento,
          a.cod_gruppo_super,
          a.num_pos,
          a.cambio_stato,
          a.cambio_comp,
          a.cambio_gest
     FROM t_mcre0_cl_controlli a
    WHERE     a.id_controllo =
                 (SELECT MAX (id_controllo) FROM t_mcre0_cl_controlli)
          AND a.data_evento IS NOT NULL;
