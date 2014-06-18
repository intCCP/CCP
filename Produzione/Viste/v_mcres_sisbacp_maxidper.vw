/* Formatted on 17/06/2014 18:13:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_SISBACP_MAXIDPER
(
   COD_ABI,
   ID_DPER,
   ID_DPER_MAX
)
AS
   SELECT cod_abi,
          id_dper,
          FIRST_VALUE (id_dper) OVER (ORDER BY id_dper DESC) id_dper_max
     FROM (  SELECT MAX (Id_Dper) id_dper, cod_abi
               FROM T_Mcres_App_Sisba_Cp
           GROUP BY Cod_Abi);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_SISBACP_MAXIDPER TO MCRE_USR;
