/* Formatted on 21/07/2014 18:30:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RP
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_ABI,
   COD_NDG,
   COD_PRESIDIO,
   COD_CLI_GE,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   VAL_RETT_ATT,
   FLG_CMP_DRC
)
AS
     SELECT 'RP' cod_src,
            TO_CHAR (
               ADD_MONTHS (TO_DATE (SUBSTR (id_dper, 1, 6), 'yyyymm'), -1),
               'yyyymm')
               id_dper,
            id_dper DTA_COMPETENZA,
            cod_abi,
            cod_ndg,
            cod_filiale_area cod_presidio,
            cod_cli_ge,
            'S' cod_stato_rischio,
            'Sofferenze' des_stato_rischio,
            SUM (val_rv) VAL_RETT_ATT,
            flg_drc FLG_CMP_DRC
       FROM (SELECT x.id_dper,
                    cod_abi,
                    cod_ndg,
                    cod_filiale_area,
                    x.cod_sndg,
                    CASE
                       WHEN ge.cod_gruppo_economico IS NOT NULL
                       THEN
                          ge.cod_gruppo_economico
                       ELSE
                          x.cod_sndg
                    END
                       cod_cli_ge,
                      CASE
                         WHEN cod_sr_cp IN ('S', 'I') AND cod_sr_s LIKE 'S'
                         THEN
                            delta_s - delta_cp + NVL (val_tot_mov, 0)
                         ELSE
                            0
                      END                                            --comp_a,
                    - CASE
                         WHEN cod_sr_cp LIKE 'S' AND cod_sr_s != 'S'
                         THEN
                              delta_cp
                            - DECODE (cod_sr_s, 'E', delta_s, 0)
                            - NVL (val_tot_mov, 0)
                         ELSE
                            0
                      END                                             --comp_b
                       val_rv,
                    CASE
                       WHEN        0 = 0
                               AND NOT EXISTS
                                          (SELECT 1
                                             FROM t_mcres_app_delibere d
                                            WHERE     cod_delibera = 'NZ'
                                                  AND cod_stato_delibera = 'CO'
                                                  AND d.cod_abi = x.cod_abi
                                                  AND d.cod_ndg = x.cod_ndg)
                               AND cod_sr_cp = 'S'
                               AND (TO_DATE (x.id_dper, 'yyyymmdd') >=
                                       ADD_MONTHS (
                                          LAST_DAY (dta_decorrenza_stato),
                                          3))
                            OR EXISTS
                                  (SELECT 1
                                     FROM t_mcres_app_delibere
                                    WHERE     cod_abi = x.cod_abi
                                          AND cod_ndg = x.cod_ndg
                                          AND cod_delibera = 'NS'
                                          AND cod_stato_delibera = 'CO'
                                          AND dta_aggiornamento_delibera BETWEEN   ADD_MONTHS (
                                                                                      TO_DATE (
                                                                                         x.id_dper,
                                                                                         'yyyymmdd'),
                                                                                      -3)
                                                                                 + 1
                                                                             AND TO_DATE (
                                                                                    x.id_dper,
                                                                                    'yyyymmdd'))
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_DRC
               FROM (  SELECT p.id_dper,
                              p.cod_abi,
                              p.cod_ndg,
                              MAX (cod_sndg) cod_sndg,
                              MAX (cod_filiale_area) cod_filiale_area,
                              MAX (p.cod_sr_s) cod_sr_s, --sul secondo insieme è null
                              MAX (p.cod_sr_cp) cod_sr_cp, --sul primo insieme è null
                              MAX (p.dta_decorrenza_stato) dta_decorrenza_stato,
                              SUM (p.delta_s) delta_s,
                              SUM (p.delta_cp) delta_cp,
                              m.val_tot_mov      --movimenti nel mese di sisba
                         FROM (SELECT s.id_dper,
                                      s.cod_abi,
                                      s.cod_ndg,
                                      NULL cod_sndg,
                                      NULL cod_filiale_area,
                                      NULL dta_decorrenza_stato,
                                      s.cod_stato_rischio cod_sr_s,
                                      NULL cod_sr_cp,
                                        s.val_imp_uti_rettificato
                                      - s.val_imp_npv_stima_recupero
                                         delta_s,
                                      0 delta_cp
                                 FROM t_mcres_app_sisba s,
                                      (SELECT cod_abi,
                                              TO_NUMBER (
                                                 TO_CHAR (
                                                    ADD_MONTHS (dta_dper, 1),
                                                    'YYYYMMDD'))
                                                 id_dper
                                         FROM v_mcres_ultima_acq_file
                                        WHERE cod_flusso = 'SISBA_CP') u
                                WHERE     0 = 0
                                      AND s.cod_ftecnica NOT IN
                                             ('PD540',
                                              'PD542',
                                              'PD590',
                                              'SF240',
                                              'PD589') ------ Aggiunte 3 forme tecniche VG 20120427
                                      AND s.cod_abi = u.cod_abi
                                      AND s.id_dper = u.id_dper
                               --and s.cod_stato_rischio in ('S', 'E')
                               ---------------------------------------------
                               UNION ALL
                               ----------------------------------------------
                               SELECT u.id_dper_s id_dper,
                                      cp.cod_abi,
                                      cp.cod_ndg,
                                      cp.cod_sndg,
                                      cp.cod_filiale_area,
                                      cp.dta_decorrenza_stato,
                                      NULL cod_sr_s,
                                      cp.cod_stato_rischio cod_sr_cp,
                                      0 delta_s,
                                      cp.val_uti_ret - cp.val_att delta_cp
                                 FROM t_mcres_app_sisba_cp cp,
                                      (SELECT cod_abi,
                                              id_dper,
                                              TO_NUMBER (
                                                 TO_CHAR (
                                                    ADD_MONTHS (dta_dper, 1),
                                                    'YYYYMMDD'))
                                                 id_dper_s
                                         FROM v_mcres_ultima_acq_file
                                        WHERE cod_flusso = 'SISBA_CP') u
                                WHERE     0 = 0
                                      AND cp.cod_abi = u.cod_abi
                                      AND cp.id_dper = u.id_dper
                                      --and cp.cod_stato_rischio in ('S', 'I')
                                      AND cp.val_firma != 'FIRMA') p,
                              (  SELECT r.cod_abi,
                                        r.cod_ndg,
                                        TO_NUMBER (
                                           TO_CHAR (
                                              LAST_DAY (
                                                 mov.dta_contabile_movimento),
                                              'yyyymmdd'))
                                           id_dper,
                                        --    r.cod_rapporto,
                                        --    m.cod_causale_movimento,
                                        SUM (mov.val_imp_movimento) val_tot_mov
                                   FROM t_mcres_app_rapporti r,
                                        t_mcres_app_movimenti mov
                                  WHERE     0 = 0
                                        AND r.cod_abi = mov.cod_abi
                                        AND r.cod_rapporto = mov.cod_rapporto
                                        AND mov.cod_causale_movimento IN
                                               ('006', '0I5', '0I6', '0I7')
                               GROUP BY r.cod_abi,
                                        r.cod_ndg,
                                        TO_NUMBER (
                                           TO_CHAR (
                                              LAST_DAY (
                                                 mov.dta_contabile_movimento),
                                              'yyyymmdd'))) m
                        WHERE     0 = 0
                              AND p.cod_abi = m.cod_abi(+)
                              AND p.cod_ndg = m.cod_ndg(+)
                              AND p.id_dper = m.id_dper(+)
                     GROUP BY p.id_dper,
                              p.cod_abi,
                              p.cod_ndg,
                              m.val_tot_mov) x,
                    --             t_mcre0_app_struttura_org o,
                    t_mcre0_app_gruppo_economico ge
              WHERE 0 = 0         --        and x.cod_abi = o.cod_abi_istituto
                 --        and x.cod_filiale_area = o.cod_struttura_competente
                     AND x.cod_sndg = ge.cod_sndg(+))
   GROUP BY id_dper,
            cod_abi,
            cod_ndg,
            cod_filiale_area,
            cod_cli_ge,
            flg_drc;
