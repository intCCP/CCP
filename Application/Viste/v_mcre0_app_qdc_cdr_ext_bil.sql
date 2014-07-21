/* Formatted on 21/07/2014 18:34:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_CDR_EXT_BIL
(
   RECORD_CHAR
)
AS
     SELECT    'DATA_RIF'
            || TO_CHAR (LAST_DAY (TO_DATE (id_dper, 'YYYYMM')), 'YYYYMMDD')
       FROM T_MCRE0_APP_QDC_CDR_BILANCIO
   GROUP BY id_dper
   UNION
   SELECT    id_source
          || LPAD (cod_abi, 5, 0)
          ||                                                        -- cod_abi
            LPAD (cod_ndg, 16, 0)
          ||                                                        -- cod_ndg
            LPAD (cod_stato, 2, ' ')
          ||                                                      -- cod_stato
            LPAD (dta_decorrenza_stato, 8, ' ')
          ||                                           -- dta_decorrenza_stato
            LPAD (cod_struttura_competente, 5, ' ')
          ||                                       -- cod_struttura_competente
            LPAD (cod_comparto, 6, ' ')
          ||                                                   -- cod_comparto
            LPAD (cod_processo, 2, ' ')
          ||                                                   -- cod_processo
            LPAD (val_rett_lorde_cassa * 100, 22, ' ')
          ||                                           -- val_rett_lorde_cassa
            LPAD (val_rett_lorde_firma * 100, 22, ' ')
          ||                                           -- val_rett_lorde_firma
            LPAD (val_rett_lorde_tot * 100, 22, ' ')
          ||                                            -- val_rett_lorde_tot,
            LPAD (val_riprese_cassa * 100, 22, ' ')
          ||                                             -- val_riprese_cassa,
            LPAD (val_riprese_firma * 100, 22, ' ')
          ||                                              -- val_riprese_firma
            LPAD (val_riprese_tot * 100, 22, ' ')
          ||                                                -- val_riprese_tot
            LPAD (val_rett_nette_cassa * 100, 22, ' ')
          ||                                           -- val_rett_nette_cassa
            LPAD (val_rett_nette_firma * 100, 22, ' ')
          ||                                           -- val_rett_nette_firma
            LPAD (val_rett_nette_tot * 100, 22, ' ')
          ||                                             -- val_rett_nette_tot
            LPAD (val_espos_lorda_cassa * 100, 22, ' ')
          ||                                          -- val_espos_lorda_cassa
            LPAD (val_espos_lorda_firma * 100, 22, ' ')
          ||                                          -- val_espos_lorda_firma
            LPAD (val_espos_lorda_deriv * 100, 22, ' ')
          ||                                          -- val_espos_lorda_deriv
            LPAD (val_espos_lorda_tot * 100, 22, ' ')
          ||                                            -- val_espos_lorda_tot
            LPAD (val_espos_netta_cassa * 100, 22, ' ')
          ||                                          -- val_espos_netta_cassa
            LPAD (val_espos_netta_firma * 100, 22, ' ')
          ||                                          -- val_espos_netta_firma
            LPAD (val_espos_netta_tot * 100, 22, ' ')
          ||                                            -- val_espos_netta_tot
            LPAD (val_per_ce * 100, 22, ' ')
          ||                                                     -- val_per_ce
            LPAD (val_rett_sval * 100, 22, ' ')
          ||                                                  -- val_rett_sval
            LPAD (val_rett_att * 100, 22, ' ')
          ||                                                   -- val_rett_att
            LPAD (val_rip_mora * 100, 22, ' ')
          ||                                                   -- val_rip_mora
            LPAD (val_quota_sval * 100, 22, ' ')
          ||                                                 -- val_quota_sval
            LPAD (val_quota_att * 100, 22, ' ')
          ||                                                  -- val_quota_att
            LPAD (val_rip_sval * 100, 22, ' ')
          ||                                                   -- val_rip_sval
            LPAD (val_rip_att * 100, 22, ' ')
          ||                                                    -- val_rip_att
            LPAD (val_attualizzazione * 100, 22, ' ')
          ||                                            -- val_attualizzazione
            LPAD (val_rdv_qc_progressiva * 100, 22, ' ')
          ||                                         -- val_rdv_qc_progressiva
            LPAD (val_rdv_progr_fi * 100, 22, ' ')
          ||                                               -- val_rdv_progr_fi
            LPAD (val_utilizzo_0 * 100, 22, ' ')
          || LPAD (val_utilizzo_1 * 100, 22, ' ')
          || LPAD (val_utilizzo_2 * 100, 22, ' ')
          || LPAD (val_utilizzo_3 * 100, 22, ' ')
          || LPAD (val_utilizzo_tot * 100, 22, ' ')
          || LPAD (val_recupero_0 * 100, 22, ' ')
          ||                                                -- val_recupero_0,
            LPAD (val_recupero_1 * 100, 22, ' ')
          ||                                                -- val_recupero_1,
            LPAD (val_recupero_2 * 100, 22, ' ')
          ||                                                -- val_recupero_2,
            LPAD (val_recupero_3 * 100, 22, ' ')
          ||                                                 -- val_recupero_3
            LPAD (ROUND (val_rapporto_0 * 100000000), 22, ' ')
          ||                                                -- val_rapporto_0,
            LPAD (ROUND (val_rapporto_1 * 100000000), 22, ' ')
          ||                                                -- val_rapporto_1,
            LPAD (ROUND (val_rapporto_2 * 100000000), 22, ' ')
          ||                                                -- val_rapporto_2,
            LPAD (ROUND (val_rapporto_3 * 100000000), 22, ' ')
          ||                                                 -- val_rapporto_3
            LPAD (val_scsb_uti_cassa * 100, 22, ' ')
          ||                                            -- val_scsb_uti_cassa,
            LPAD (val_scsb_uti_firma * 100, 22, ' ')
          ||                                        --     val_scsb_uti_firma,
            LPAD (val_scsb_uti_deriv * 100, 22, ' ')
          ||                                        --     val_scsb_uti_deriv,
            LPAD (val_scsb_uti_tot * 100, 22, ' ')     --     val_scsb_uti_tot
     FROM MCRE_OWN.T_MCRE0_APP_QDC_CDR_BILANCIO;
