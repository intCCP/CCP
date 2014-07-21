/* Formatted on 21/07/2014 18:43:28 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ULTIMO_ANNOMESE
(
   VAL_ANNOMESE_FINE_ANNO,
   VAL_ANNOMESE_PENULTIMO_SISBA,
   VAL_ANNOMESE_SISBA,
   VAL_ANNOMESE_SISBA_CP,
   VAL_ANNOMESE_SISBA_CP_PREC,
   VAL_ANNOMESE_SISBA_PREC,
   VAL_ANNOMESE_ULTIMO_SISBA,
   VAL_ANNOMESE_ULTIMO_SISBA_CP
)
AS
   SELECT MAX (VAL_ANNOMESE_FINE_ANNO) VAL_ANNOMESE_FINE_ANNO,
          MAX (VAL_ANNOMESE_PENULTIMO_SISBA) VAL_ANNOMESE_PENULTIMO_SISBA,
          MAX (VAL_ANNOMESE_SISBA) VAL_ANNOMESE_SISBA,
          MAX (VAL_ANNOMESE_SISBA_CP) VAL_ANNOMESE_SISBA_CP,
          MAX (VAL_ANNOMESE_SISBA_CP_PREC) VAL_ANNOMESE_SISBA_CP_PREC,
          MAX (VAL_ANNOMESE_SISBA_PREC) VAL_ANNOMESE_SISBA_PREC,
          MAX (VAL_ANNOMESE_ULTIMO_SISBA) VAL_ANNOMESE_ULTIMO_SISBA,
          MAX (VAL_ANNOMESE_ULTIMO_SISBA_CP) VAL_ANNOMESE_ULTIMO_SISBA_CP
     FROM V_MCRES_APP_ULTIMO_ANNOMESEABI;
