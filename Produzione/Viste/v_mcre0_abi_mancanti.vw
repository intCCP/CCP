/* Formatted on 17/06/2014 17:59:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ABI_MANCANTI
(
   COD_ABI_ISTITUTO
)
AS
   SELECT a.cod_abi_istituto
     FROM mcre_own.t_mcre0_day_abi b, mcre_own.t_mcre0_etl_abi a
    WHERE     TRUNC (SYSDATE) BETWEEN a.start_date AND a.end_date
          AND a.cod_abi_istituto = b.cod_abi_istituto(+)
          AND b.cod_abi_istituto IS NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ABI_MANCANTI TO MCRE_USR;
