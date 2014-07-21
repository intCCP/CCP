/* Formatted on 17/06/2014 18:12:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_CL_CODIVA
(
   VAL_SCHEMA_IVA,
   COD_IVA,
   DESC_IVA,
   VAL_PERC_IVA
)
AS
   SELECT                                 -- 20121026 AG  filtro su flg_attivo
         val_schema_iva,
          cod_iva,
          desc_iva,
          val_perc_iva
     FROM t_mcres_cl_codiva
    WHERE flg_attivo = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_CL_CODIVA TO MCRE_USR;
