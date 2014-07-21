/* Formatted on 21/07/2014 18:37:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POSIZIONI_LAVORABILI
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_LAVORABILE,
   COD_SNDG_LAVORABILE,
   COD_GRUPPO_LAVORABILE
)
AS
   SELECT e.cod_abi,
          e.cod_ndg,
          e.cod_sndg,
          e.COD_BLOCCO_ABI cod_lavorabile,
          e.COD_BLOCCO_SNDG cod_sndg_lavorabile,
          e.COD_BLOCCO_GRUPPO COD_BLOCCO_GRUPPO
     FROM v_mcre0_etl_lavorabili e;
