/* Formatted on 17/06/2014 17:59:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_CK_ISTITUITI
(
   COD_ABI_CARTOLARIZZATO
)
AS
   SELECT fg.cod_abi_cartolarizzato
     FROM (SELECT DISTINCT cod_abi_cartolarizzato FROM t_mcre0_app_file_guida) fg
          LEFT JOIN (SELECT DISTINCT cod_abi FROM t_mcre0_app_istituti) ist
             ON fg.cod_abi_cartolarizzato = ist.cod_abi
    WHERE ist.cod_abi IS NULL;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_CK_ISTITUITI TO MCRE_USR;
