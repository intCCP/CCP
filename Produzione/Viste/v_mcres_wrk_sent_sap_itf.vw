/* Formatted on 17/06/2014 18:13:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_SENT_SAP_ITF
(
   COD_ABI,
   COD_AUTORIZZAZIONE
)
AS
   SELECT s.cod_abi, s.cod_autorizzazione
     FROM t_mcres_app_spese_itf s
    WHERE     0 = 0
          AND s.cod_abi = SYS_CONTEXT ('userenv', 'client_info')
          AND s.flg_inviata_sap = 0
          -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
          AND s.cod_abi != '10637'
          AND s.cod_tipo_autorizzazione IN ('1', '6')
          AND s.cod_autorizzazione_padre IS NULL
          -- s.flg_spesa_recuperata = 0
          AND EXISTS
                 (SELECT 1
                    FROM t_mcres_app_sp_spese sp,
                         t_mcres_app_contropartite_itf c
                   WHERE     0 = 0
                         AND sp.cod_autorizzazione = s.cod_autorizzazione
                         AND c.cod_autorizzazione = sp.cod_autorizzazione
                         AND sp.flg_contabilizzata = 1
                         AND sp.cod_stato = 'CO'
                         AND sp.flg_source = 'ITF'
                         AND c.cod_tipo = '1'
                  UNION
                  SELECT 1
                    FROM t_mcres_app_sp_spese sp,
                         t_mcres_app_contropartite_itf c
                   WHERE     0 = 0
                         AND sp.cod_autorizzazione = s.cod_autorizzazione
                         AND c.cod_autorizzazione = sp.cod_autorizzazione
                         AND sp.cod_stato = 'CO'
                         AND sp.flg_source = 'ITF'
                         AND c.cod_tipo != '1')
          AND NOT EXISTS -- esclude spese con addebito su posizioni cartolarizzate
                     (SELECT 1
                        FROM t_mcres_app_contropartite_itf c
                       WHERE     c.cod_autorizzazione = s.cod_autorizzazione
                             AND c.cod_tipo IN ('7', '8'));


GRANT SELECT ON MCRE_OWN.V_MCRES_WRK_SENT_SAP_ITF TO MCRE_USR;
