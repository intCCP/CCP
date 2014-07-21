/* Formatted on 21/07/2014 18:34:52 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_QDC_CDR_STORICO
(
   ID_DPER,
   RECORD_CHAR
)
AS
     SELECT --SUBSTR(pos.cod_mese_hst,1,6) id_dper,  --cod_mese_hst Š diventato o fine mese o 0 se delibere con fine validit¿ nel mese
           periodo.id_dper,                                      --mod 03.2013
               '001'
            ||                                                    -- id_flusso
              'C'
            ||                                                    -- id_source
              LPAD (TRIM (pos.cod_abi), 5, 0)
            ||                                                      -- cod_abi
              LPAD (TRIM (pos.cod_ndg), 16, 0)
            ||                                                      -- cod_ndg
              LPAD (NVL (TRIM (pos.cod_stato), ' '), 2, ' ')
            ||                                                    -- cod_stato
              LPAD (NVL (TO_CHAR (pos.dta_decorrenza_stato, 'YYYYMMDD'), ' '),
                    8,
                    ' ')
            ||                                         -- dta_decorrenza_stato
              LPAD (NVL (TRIM (pos.cod_struttura_competente), ' '), 5, ' ')
            ||                                     -- cod_struttura_competente
              LPAD (NVL (TRIM (pos.cod_comparto), ' '), 6, ' ')
            ||                                                 -- cod_comparto
              LPAD (NVL (TRIM (pos.cod_processo), ' '), 2, ' ')
            ||                                                 -- cod_processo
              LPAD (0, 22, ' ')
            ||                                         -- val_rett_lorde_cassa
              LPAD (0, 22, ' ')
            ||                                         -- val_rett_lorde_firma
              LPAD (0, 22, ' ')
            ||                                          -- val_rett_lorde_tot,
              LPAD (0, 22, ' ')
            ||                                           -- val_riprese_cassa,
              LPAD (0, 22, ' ')
            ||                                            -- val_riprese_firma
              LPAD (0, 22, ' ')
            ||                                              -- val_riprese_tot
              LPAD (
                    NVL (
                       SUM (
                          CASE
                             WHEN     cod_microtipologia_delib IN
                                         ('RV', 'T4', 'A0', 'IM')
                                  AND cod_fase_delibera IN ('CO')
                                  AND dta_conferma_delibera >=
                                         TO_DATE (periodo.id_dper, 'YYYYMM') --mod 04.2013
                             THEN
                                pos.val_rdv_qc_deliberata        --mod 03.2013
                             ELSE
                                0
                          END),
                       0)
                  * 100,
                  22,
                  ' ')
            ||                                         -- val_rett_nette_cassa
              LPAD (NVL (rdv.val_rdv_progr_fi, 0) * 100, 22, ' ')
            ||                                         -- val_rett_nette_firma
              LPAD (
                    (  NVL (
                          SUM (
                             CASE
                                WHEN     cod_microtipologia_delib IN
                                            ('RV', 'T4', 'A0', 'IM')
                                     AND cod_fase_delibera IN ('CO')
                                     AND dta_conferma_delibera >=
                                            TO_DATE (periodo.id_dper, 'YYYYMM') --mod 04.2013
                                THEN
                                   pos.val_rdv_qc_deliberata     --mod 03.2013
                                ELSE
                                   0
                             END),
                          0)
                     + NVL (rdv.val_rdv_progr_fi, 0))
                  * 100,
                  22,
                  ' ')
            ||                                           -- val_rett_nette_tot
              LPAD (NVL (uti.val_esp_lorda, 0) * 100, 22, ' ')
            ||                                        -- val_espos_lorda_cassa
              LPAD (NVL (uti.val_esp_firma, 0) * 100, 22, ' ')
            ||                                        -- val_espos_lorda_firma
              LPAD (NVL (uti.val_uti_sosti_scsb, 0) * 100, 22, ' ')
            ||                                        -- val_espos_lorda_deriv
              LPAD (NVL (uti.val_uti_tot_scsb, 0) * 100, 22, ' ')
            ||               -- val_espos_lorda_tot (non considera i derivati)
              LPAD (
                    (  NVL (uti.val_esp_lorda, 0)
                     - NVL (
                          SUM (
                             CASE
                                WHEN     cod_microtipologia_delib IN
                                            ('RV', 'T4', 'A0', 'IM')
                                     AND cod_fase_delibera IN ('CO')
                                     AND dta_conferma_delibera >=
                                            TO_DATE (periodo.id_dper, 'YYYYMM') --mod 04.2013
                                THEN
                                   pos.val_rdv_qc_deliberata     --mod 03.2013
                                ELSE
                                   0
                             END),
                          0))
                  * 100,
                  22,
                  ' ')
            ||                                        -- val_espos_netta_cassa
              LPAD (
                    (NVL (uti.val_esp_firma, 0) - NVL (rdv.val_rdv_progr_fi, 0))
                  * 100,
                  22,
                  ' ')
            ||                                        -- val_espos_netta_firma
              LPAD (
                    (  (  NVL (uti.val_esp_lorda, 0)
                        - NVL (
                             SUM (
                                CASE
                                   WHEN     cod_microtipologia_delib IN
                                               ('RV', 'T4', 'A0', 'IM')
                                        AND cod_fase_delibera IN ('CO')
                                        AND dta_conferma_delibera >=
                                               TO_DATE (periodo.id_dper,
                                                        'YYYYMM') --mod 04.2013
                                   THEN
                                      pos.val_rdv_qc_deliberata  --mod 03.2013
                                   ELSE
                                      0
                                END),
                             0))
                     + (  NVL (uti.val_esp_firma, 0)
                        - NVL (rdv.val_rdv_progr_fi, 0)))
                  * 100,
                  22,
                  ' ')
            ||                                          -- val_espos_netta_tot
              LPAD (0, 22, ' ')
            ||                                                   -- val_per_ce
              LPAD (0, 22, ' ')
            ||                                                -- val_rett_sval
              LPAD (0, 22, ' ')
            ||                                                 -- val_rett_att
              LPAD (0, 22, ' ')
            ||                                                 -- val_rip_mora
              LPAD (0, 22, ' ')
            ||                                               -- val_quota_sval
              LPAD (0, 22, ' ')
            ||                                                -- val_quota_att
              LPAD (0, 22, ' ')
            ||                                                 -- val_rip_sval
              LPAD (0, 22, ' ')
            ||                                                  -- val_rip_att
              LPAD (0, 22, ' ')
            ||                                          -- val_attualizzazione
              LPAD (
                    CASE NVL (rdv.val_rdv_qc_progressiva, 0)
                       WHEN 0 THEN NVL (stime.val_rdv_tot, 0)
                       ELSE NVL (rdv.val_rdv_qc_progressiva, 0)
                    END
                  * 100,
                  22,
                  ' ')
            ||       -- val_rdv_qc_progressiva     se 0 da stime --mod 04.2013
              LPAD (NVL (rdv.val_rdv_progr_fi, 0) * 100, 22, ' ')
            ||                                             -- val_rdv_progr_fi
              LPAD (0, 22, ' ')
            ||                                               -- val_utilizzo_0
              LPAD (0, 22, ' ')
            ||                                               -- val_utilizzo_1
              LPAD (0, 22, ' ')
            ||                                               -- val_utilizzo_2
              LPAD (0, 22, ' ')
            ||                                               -- val_utilizzo_3
              LPAD (0, 22, ' ')
            ||                            --  --mod 04.2013        tornato a 0
              LPAD (0, 22, ' ')
            ||                                               -- val_recupero_0
              LPAD (0, 22, ' ')
            ||                                               -- val_recupero_1
              LPAD (0, 22, ' ')
            ||                                               -- val_recupero_2
              LPAD (0, 22, ' ')
            ||                                               -- val_recupero_3
              LPAD (0, 22, ' ')
            ||                                               -- val_rapporto_0
              LPAD (0, 22, ' ')
            ||                                               -- val_rapporto_1
              LPAD (0, 22, ' ')
            ||                                               -- val_rapporto_2
               --LPAD(0,22,' ') || -- val_rapporto_3
               LPAD (
                  (CASE pos.cod_mese_hst WHEN 0 THEN 1 ELSE 0 END) * 100000000,
                  22,
                  ' ')
            ||            -- val_rapporto_3  ---mese_precedente    mod 03.2013
              LPAD (NVL (pos.scsb_uti_cassa, 0) * 100, 22, ' ')
            ||                                               -- scsb_uti_cassa
              LPAD (NVL (pos.scsb_uti_firma, 0) * 100, 22, ' ')
            ||                                               -- scsb_uti_firma
              LPAD (NVL (pos.scsb_uti_sostituzioni, 0) * 100, 22, ' ')
            ||                                               -- scsb_uti_deriv
              LPAD (NVL (pos.scsb_uti_tot, 0) * 100, 22, ' ')  -- scsb_uti_tot
       FROM mcre_own.t_mcre0_app_qdc_posiz_delib pos,
            (SELECT cod_abi,
                    cod_ndg,
                    FIRST_VALUE (
                       val_rdv_qc_progressiva)
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_rdv_qc_progressiva,
                    FIRST_VALUE (
                       val_rdv_progr_fi)
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_rdv_progr_fi
               FROM t_mcre0_app_qdc_posiz_delib
              WHERE     cod_fase_delibera IN ('AD', 'CO', 'CT')
                    AND val_rdv_qc_progressiva IS NOT NULL       --mod 04.2013
                                                          ) rdv,
            (SELECT cod_abi,
                    cod_ndg,
                    FIRST_VALUE (
                       NVL (val_esp_lorda, val_uti_cassa_scsb))
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_esp_lorda,
                    FIRST_VALUE (
                       NVL (val_esp_firma, val_uti_firma_scsb))
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_esp_firma,
                    FIRST_VALUE (
                       val_uti_sosti_scsb)
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_uti_sosti_scsb,
                    FIRST_VALUE (
                       NVL (val_uti_tot_scsb, (val_esp_lorda + val_esp_firma)))
                    OVER (
                       PARTITION BY cod_abi, cod_ndg
                       ORDER BY
                          dta_conferma_delibera DESC,
                          val_num_progr_delibera DESC)
                       val_uti_tot_scsb
               FROM t_mcre0_app_qdc_posiz_delib
              WHERE     cod_fase_delibera IN ('AD', 'CO', 'CT', 'NA')
                    AND NVL (val_esp_lorda, val_uti_tot_scsb) IS NOT NULL) uti,
            (  SELECT b.cod_abi, b.cod_ndg, SUM (b.val_rdv_tot) val_rdv_tot
                 FROM mcre_own.t_mcrei_app_stime_batch b,
                      (  SELECT cod_abi, cod_ndg, MAX (s.id_dper) id_dper
                           FROM mcre_own.t_mcrei_app_stime_batch s,
                                (SELECT SUBSTR (MAX (cod_mese_hst), 1, 6) id_dper
                                   FROM T_MCRE0_APP_QDC_POSIZ_DELIB) p
                          WHERE SUBSTR (s.id_dper, 1, 6) = p.id_dper
                       GROUP BY cod_abi, cod_ndg) a
                WHERE     b.id_dper = a.id_dper
                      AND b.cod_abi = a.cod_abi
                      AND b.cod_ndg = a.cod_ndg
             GROUP BY b.cod_abi, b.cod_ndg) stime,
            (SELECT SUBSTR (MAX (cod_mese_hst), 1, 6) id_dper
               FROM T_MCRE0_APP_QDC_POSIZ_DELIB) periodo
      WHERE     pos.cod_abi = rdv.cod_abi(+)
            AND pos.cod_ndg = rdv.cod_ndg(+)
            AND pos.cod_abi = uti.cod_abi(+)
            AND pos.cod_ndg = uti.cod_ndg(+)
            AND pos.cod_abi = stime.cod_abi(+)
            AND pos.cod_ndg = stime.cod_ndg(+)
   GROUP BY periodo.id_dper,
            pos.cod_abi,
            pos.cod_ndg,
            pos.cod_stato,
            TO_CHAR (pos.dta_decorrenza_stato, 'YYYYMMDD'),
            pos.cod_struttura_competente,
            pos.cod_comparto,
            pos.cod_processo,
            CASE NVL (rdv.val_rdv_qc_progressiva, 0)
               WHEN 0 THEN NVL (stime.val_rdv_tot, 0)
               ELSE NVL (rdv.val_rdv_qc_progressiva, 0)
            END,
            rdv.val_rdv_progr_fi,
            uti.val_esp_lorda,
            uti.val_esp_firma,
            uti.val_uti_sosti_scsb,
            uti.val_uti_tot_scsb,
            CASE pos.cod_mese_hst WHEN 0 THEN 1 ELSE 0 END,
            pos.scsb_uti_cassa,
            pos.scsb_uti_firma,
            pos.scsb_uti_sostituzioni,
            pos.scsb_uti_tot;
