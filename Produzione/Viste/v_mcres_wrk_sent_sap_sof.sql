/* Formatted on 17/06/2014 18:13:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SENT_SAP_SOF
(
   COD_ABI,
   COD_AUTORIZZAZIONE
)
AS
   SELECT s.cod_abi, s.cod_autorizzazione
     FROM t_mcres_app_sp_spese s
    WHERE     0 = 0
          AND s.cod_abi = SYS_CONTEXT ('userenv', 'client_info')
          AND cod_stato = 'CO'
          AND flg_invio_sap = 0
          AND flg_source = 'SOF'
          -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
          AND s.cod_abi != '10637'
          AND s.cod_tipo_autorizzazione IN ('1', '6')
          AND s.cod_autorizzazione_padre IS NULL
          --AND s.flg_spesa_recuperata = 'N'
          AND NOT EXISTS -- esclude spese con addebito su posizioni cartolarizzate
                     (SELECT 1
                        FROM t_mcres_app_sp_contropartita c
                       WHERE     c.cod_autorizzazione = s.cod_autorizzazione
                             AND c.cod_tipo IN ('7', '8'));


GRANT SELECT ON MCRE_OWN.V_MCRES_WRK_SENT_SAP_SOF TO MCRE_USR;
