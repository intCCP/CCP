/* Formatted on 17/06/2014 18:10:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PARERI_VALIDI
(
   COD_DELIBERA,
   DESC_PARERE,
   VAL_ORDINE
)
AS
   SELECT cod_label_web cod_delibera,
          desc_dominio desc_parere,
          cod_ordinale val_ordine
     FROM t_mcrei_cl_domini
    WHERE 0 = 0 AND cod_dominio = 'TIPO_PARERE_SOFF' AND val_dominio != 'S06';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_PARERI_VALIDI TO MCRE_USR;
