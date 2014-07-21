/* Formatted on 21/07/2014 18:42:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_EXTRACT_FROM_DOC
(
   COD_SOCIETA_SAP,
   COD_ABI,
   COD_NDG,
   COD_AUTORIZZAZIONE,
   COD_AUTORIZZAZIONE_PADRE,
   COD_PROGRESSIVO,
   ID_OBJECT,
   VAL_DOC_NAME
)
AS
   SELECT                                  ------ VG 20140610 Blocco invio sap
         SUBSTR (s.cod_autorizzazione, 1, 4) cod_societa_sap,
          s.cod_abi,
          s.cod_ndg,
          s.cod_autorizzazione,
          s.cod_autorizzazione_padre,
          al.cod_progressivo,
          al.id_object,
          al.val_doc_name
     FROM t_mcres_app_sp_spese s, t_mcres_app_documenti al
    WHERE     0 = 0
          --and s.cod_stato = 'CO'
          --and s.flg_contabilizzata = 1
          -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
          AND s.cod_abi != '10637'
          AND s.flg_invio_sap = 0
          AND NVL (flg_blocco_invio_sap, 0) = 0 -- VG 20140610 Blocco invio sap
          --AND s.flg_spesa_recuperata = 'N'
          AND s.cod_autorizzazione_padre IS NULL
          ---
          AND s.cod_autorizzazione = al.cod_aut_protoc
          AND al.cod_tipo_del_spesa IN ('1', '5', '6')
          AND al.cod_tipo_documento IN ('AL')
          AND al.cod_stato IN ('CO', 'TR')
          ---
          AND NOT EXISTS -- scarto l'allegato in stato TR se ne esiste uno in stato CO
                     (SELECT 1
                        FROM t_mcres_app_documenti d
                       WHERE     0 = 0
                             AND d.cod_abi = al.cod_abi
                             AND d.cod_ndg = al.cod_ndg
                             AND d.cod_identificativo = al.cod_identificativo
                             AND d.cod_tipo_documento = 'AL'
                             AND d.cod_stato = 'CO'
                             AND d.id_object != al.id_object)
          ---
          AND EXISTS
                 (SELECT 1
                    FROM t_mcres_app_sp_spese sp
                   WHERE     0 = 0
                         AND sp.cod_autorizzazione = s.cod_autorizzazione
                         AND sp.flg_contabilizzata = 1
                         AND sp.cod_stato = 'CO'
                         AND sp.flg_source != 'MPL'
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
          ---
          AND NOT EXISTS    -- escludo spese legate a posizioni cartolarizzate
                     (SELECT 1
                        FROM t_mcres_app_sp_contropartita c
                       WHERE     0 = 0
                             AND c.cod_autorizzazione = s.cod_autorizzazione
                             AND c.cod_tipo IN ('7', '8'))
   ----------------
   UNION ALL
   ----------------
   SELECT SUBSTR (s.cod_autorizzazione, 1, 4) cod_societa_sap,
          s.cod_abi,
          s.cod_ndg,
          s.cod_autorizzazione,
          s.cod_autorizzazione_padre,
          do.cod_progressivo,
          do.id_object,
          do.val_doc_name
     FROM t_mcres_app_sp_spese s, t_mcres_app_documenti do
    WHERE     0 = 0
          --and s.cod_stato = 'CO'
          --and s.flg_contabilizzata = 1
          -- escludo INVIO SPESE SU MEDIO CREDITO ABI 10637
          AND s.cod_abi != '10637'
          AND s.flg_invio_sap = 0
          AND NVL (flg_blocco_invio_sap, 0) = 0 -- VG 20140610 Blocco invio sap
          --AND s.flg_spesa_recuperata = 'N'
          AND s.cod_autorizzazione_padre IS NULL
          ---
          AND do.cod_tipo_del_spesa IN ('1', '5', '6')
          AND do.cod_tipo_documento = 'DO'
          AND s.cod_abi = do.cod_abi
          AND s.cod_ndg = do.cod_ndg
          AND s.cod_autorizzazione = do.cod_identificativo
          --
          AND EXISTS
                 (SELECT 1
                    FROM t_mcres_app_sp_spese sp
                   WHERE     0 = 0
                         AND sp.cod_autorizzazione = s.cod_autorizzazione
                         AND sp.flg_contabilizzata = 1
                         AND sp.cod_stato = 'CO'
                         AND sp.flg_source != 'MPL'
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
          --
          AND NOT EXISTS    -- escludo spese legate a posizioni cartolarizzate
                     (SELECT 1
                        FROM t_mcres_app_sp_contropartita c
                       WHERE     0 = 0
                             AND c.cod_autorizzazione = s.cod_autorizzazione
                             AND c.cod_tipo IN ('7', '8'));
