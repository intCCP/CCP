/* Formatted on 21/07/2014 18:44:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_ULTIMA_ACQUISIZIONE
(
   COD_FLUSSO,
   ID_FLUSSO,
   ID_DPER,
   VAL_ANNOMESE,
   VAL_ANNO
)
AS
     SELECT                                       -- V1 07/02/2012 VG: Created
           COD_FLUSSO,
            MAX (id_flusso) id_flusso,
            MAX (TO_CHAR (ID_DPER, 'YYYYMMDD')) ID_DPER,
            MAX (TO_CHAR (ID_DPER, 'YYYYMM')) VAL_ANNOMESE,
            MAX (TO_CHAR (ID_DPER, 'YYYY')) VAL_ANNO
       FROM t_mcres_wrk_last_acquisizione w
      WHERE cod_stato IN ('CARICATO', 'CARICATO_APP')
   GROUP BY cod_flusso;
