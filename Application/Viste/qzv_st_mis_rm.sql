/* Formatted on 21/07/2014 18:30:39 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RM
(
   COD_SRC,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   ID_DPER,
   DTA_COMPETENZA,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   FLG_PORTAFOGLIO,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   FLG_CHIUSURA,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_CLI_GE,
   COD_PRESIDIO,
   VAL_RIP_MORA,
   VAL_PER_CE,
   VAL_QUOTA_SVAL,
   VAL_QUOTA_ATT,
   VAL_RETT_SVAL,
   VAL_RIP_SVAL,
   VAL_RETT_ATT,
   VAL_RIP_ATT,
   VAL_ATTUALIZZAZIONE,
   FLG_CMP_DRC
)
AS
   SELECT 'RM' cod_src,
          cod_stato_rischio,
          CASE
             WHEN cod_stato_rischio = 'S' THEN 'Sofferenze'
             WHEN cod_stato_rischio = 'I' THEN 'Incagli'
             WHEN cod_stato_rischio = 'R' THEN 'Ristrutturati'
             ELSE NULL
          END
             des_stato_rischio,
          SUBSTR (rv.id_dper, 1, 6) id_dper,
          rv.id_dper dta_competenza,
          rv.dta_decorrenza_stato dta_inizio_stato,
          NULL dta_fine_stato,
          1 flg_portafoglio,
          1 flg_ndg,
          CASE
             WHEN TO_CHAR (rv.dta_decorrenza_stato, 'yyyy') =
                     SUBSTR (rv.id_dper, 1, 4)
             THEN
                1
             ELSE
                0
          END
             flg_nuovo_ingresso,
          NULL flg_chiusura,
          rv.cod_abi,
          rv.cod_ndg,
          rv.cod_sndg,
          --
          CASE
             WHEN ge.cod_gruppo_economico IS NOT NULL
             THEN
                ge.cod_gruppo_economico
             WHEN rv.cod_sndg IS NOT NULL
             THEN
                rv.cod_sndg
             ELSE
                NULL
          END
             cod_cli_ge,
          cod_filiale_area cod_presidio,
          --
          rv.val_rip_mora,
          val_per_ce,
          val_quota_sval,
          val_quota_att,
          val_rett_sval,
          val_rip_sval,
          val_rett_att,
          val_rip_att,
          val_attualizzazione,
          flg_cmp_drc
     FROM (SELECT ee.id_dper,
                  'S' cod_stato_rischio,
                  CASE
                     WHEN ee.cod_stato_fin = 'S'
                     THEN
                        ee.dta_decorrenza_stato
                     WHEN ee.cod_stato_ini = 'S'
                     THEN
                        cp_prec.dta_decorrenza_stato
                  END
                     dta_decorrenza_stato,
                  CASE
                     WHEN ee.cod_stato_fin = 'S'
                     THEN
                        ee.cod_filiale_area
                     WHEN ee.cod_stato_ini = 'S'
                     THEN
                        cp_prec.cod_filiale_area
                  END
                     cod_filiale_area,
                  CASE
                     WHEN ee.cod_stato_fin = 'S' THEN ee.cod_sndg
                     WHEN ee.cod_stato_ini = 'S' THEN cp_prec.cod_sndg
                  END
                     cod_sndg,
                  ee.cod_abi,
                  ee.cod_ndg,
                  ee.val_per_ce,
                  ee.val_rett_sval,
                  ee.val_rett_att,
                  ee.val_rip_mora,
                  ee.val_quota_sval,
                  ee.val_quota_att,
                  ee.val_rip_sval,
                  ee.val_rip_att,
                  ee.val_attualizzazione,
                  CASE
                     WHEN ee.cod_stato_ini != 'S'
                     THEN
                        0
                     WHEN EXISTS
                             (SELECT 1
                                FROM t_mcres_app_delibere del
                               WHERE     0 = 0
                                     AND del.cod_abi = ee.cod_abi
                                     AND del.cod_ndg = ee.cod_ndg
                                     AND del.cod_stato_delibera = 'CO'
                                     AND del.cod_delibera = 'NZ'
                                     AND del.dta_aggiornamento_delibera <=
                                            TO_DATE (ee.id_dper, 'yyyymmdd'))
                     THEN
                        0
                     WHEN cp_prec.dta_decorrenza_stato IS NULL
                     THEN
                        1
                     WHEN TO_DATE (ee.id_dper, 'yyyymmdd') >=
                             ADD_MONTHS (
                                LAST_DAY (cp_prec.dta_decorrenza_stato),
                                3)
                     THEN
                        1
                     WHEN d.dta_aggiornamento_delibera IS NULL
                     THEN
                        0
                     WHEN TO_CHAR (d.dta_aggiornamento_delibera, 'YYYYMM') <
                             SUBSTR (ee.id_dper, 1, 6)
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_cmp_drc
             FROM (SELECT ee.id_dper,
                          ee.cod_stato_ini,
                          ee.cod_stato_fin,
                          ee.cod_abi,
                          ee.cod_ndg,
                          cp.dta_decorrenza_stato,
                          cp.cod_sndg,
                          cp.cod_filiale_area,
                          ee.val_per_ce,
                          ee.val_rett_sval,
                          ee.val_rett_att,
                          ee.val_rip_mora,
                          ee.val_quota_sval,
                          ee.val_quota_att,
                          ee.val_rip_sval,
                          ee.val_rip_att,
                          ee.val_attualizzazione
                     FROM t_mcres_app_effetti_economici ee,
                          (  SELECT id_dper,
                                    cod_abi,
                                    cod_ndg,
                                    MAX (dta_decorrenza_stato)
                                       dta_decorrenza_stato,
                                    MAX (cod_filiale_area) cod_filiale_area,
                                    MAX (cod_sndg) cod_sndg
                               FROM t_mcres_app_sisba_cp
                              WHERE id_dper =
                                       SYS_CONTEXT ('userenv', 'client_info')
                           GROUP BY id_dper, cod_abi, cod_ndg) cp
                    WHERE     0 = 0
                          AND ee.id_dper =
                                 SYS_CONTEXT ('userenv', 'client_info')
                          AND (cod_stato_ini = 'S' OR cod_stato_fin = 'S')
                          AND ee.id_dper = cp.id_dper(+)
                          AND ee.cod_abi = cp.cod_abi(+)
                          AND ee.cod_ndg = cp.cod_ndg(+)) ee,
                  (  SELECT id_dper,
                            cod_abi,
                            cod_ndg,
                            MAX (cod_sndg) cod_sndg,
                            MAX (dta_decorrenza_stato) dta_decorrenza_stato,
                            MAX (cod_filiale_area) cod_filiale_area
                       FROM t_mcres_app_sisba_cp
                      WHERE     0 = 0
                            AND id_dper(+) =
                                   TO_NUMBER (
                                      TO_CHAR (
                                         ADD_MONTHS (
                                            TO_DATE (
                                               SYS_CONTEXT ('userenv',
                                                            'client_info'),
                                               'yyyymmdd'),
                                            -1),
                                         'yyyymmdd'))
                            AND cod_stato_rischio = 'S'
                   GROUP BY id_dper, cod_abi, cod_ndg) cp_prec,
                  (  SELECT cod_abi,
                            cod_ndg,
                            MAX (dta_aggiornamento_delibera)
                               dta_aggiornamento_delibera
                       FROM t_mcres_app_delibere
                      WHERE     0 = 0
                            AND cod_delibera = 'NS'
                            AND cod_stato_delibera = 'CO'
                            AND dta_aggiornamento_delibera BETWEEN   ADD_MONTHS (
                                                                        TO_DATE (
                                                                           SYS_CONTEXT (
                                                                              'userenv',
                                                                              'client_info'),
                                                                           'yyyymmdd'),
                                                                        -3)
                                                                   + 1
                                                               AND TO_DATE (
                                                                      SYS_CONTEXT (
                                                                         'userenv',
                                                                         'client_info'),
                                                                      'yyyymmdd')
                   GROUP BY cod_abi, cod_ndg) d
            WHERE     0 = 0
                  AND ee.cod_abi = cp_prec.cod_abi(+)
                  AND ee.cod_ndg = cp_prec.cod_ndg(+)
                  AND ee.cod_abi = d.cod_abi(+)
                  AND ee.cod_ndg = d.cod_ndg(+)
           -----------------------------------------------------------------------
           UNION ALL
           ------------------------------------------------------------------------
           SELECT ee.id_dper,
                  'I' cod_stato_rischio,
                  dta_decorrenza_stato,
                  cod_filiale_area,
                  cod_sndg,
                  cod_abi,
                  cod_ndg,
                  val_per_ce,
                  val_rett_sval,
                  val_rett_att,
                  val_rip_mora,
                  val_quota_sval,
                  val_quota_att,
                  val_rip_sval,
                  val_rip_att,
                  val_attualizzazione,
                  CASE
                     WHEN cod_filiale_area IN
                             ('04195', '06601', '11901', '11905', '11906')
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_cmp_drc
             FROM (SELECT ee.id_dper,
                          CASE
                             WHEN ee.cod_stato_fin = 'I'
                             THEN
                                ee.dta_decorrenza_stato
                             WHEN ee.cod_stato_ini = 'I'
                             THEN
                                cp_prec.dta_decorrenza_stato
                          END
                             dta_decorrenza_stato,
                          CASE
                             WHEN ee.cod_stato_fin = 'I'
                             THEN
                                ee.cod_filiale_area
                             WHEN ee.cod_stato_ini = 'I'
                             THEN
                                cp_prec.cod_filiale_area
                          END
                             cod_filiale_area,
                          CASE
                             WHEN ee.cod_stato_fin = 'I'
                             THEN
                                ee.cod_sndg
                             WHEN ee.cod_stato_ini = 'I'
                             THEN
                                cp_prec.cod_sndg
                          END
                             cod_sndg,
                          ee.cod_abi,
                          ee.cod_ndg,
                          ee.val_per_ce,
                          ee.val_rett_sval,
                          ee.val_rett_att,
                          ee.val_rip_mora,
                          ee.val_quota_sval,
                          ee.val_quota_att,
                          ee.val_rip_sval,
                          ee.val_rip_att,
                          ee.val_attualizzazione
                     FROM (SELECT ee.id_dper,
                                  ee.cod_stato_ini,
                                  ee.cod_stato_fin,
                                  ee.cod_abi,
                                  ee.cod_ndg,
                                  cp.dta_decorrenza_stato,
                                  cp.cod_sndg,
                                  cp.cod_filiale_area,
                                  ee.val_per_ce,
                                  ee.val_rett_sval,
                                  ee.val_rett_att,
                                  ee.val_rip_mora,
                                  ee.val_quota_sval,
                                  ee.val_quota_att,
                                  ee.val_rip_sval,
                                  ee.val_rip_att,
                                  ee.val_attualizzazione
                             FROM t_mcres_app_effetti_economici ee,
                                  (  SELECT id_dper,
                                            cod_abi,
                                            cod_ndg,
                                            MAX (dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            MAX (cod_filiale_area)
                                               cod_filiale_area,
                                            MAX (cod_sndg) cod_sndg
                                       FROM t_mcres_app_sisba_cp
                                      WHERE id_dper =
                                               SYS_CONTEXT ('userenv',
                                                            'client_info')
                                   GROUP BY id_dper, cod_abi, cod_ndg) cp
                            WHERE     0 = 0
                                  AND ee.id_dper =
                                         SYS_CONTEXT ('userenv',
                                                      'client_info')
                                  AND (   cod_stato_ini = 'I'
                                       OR cod_stato_fin = 'I')
                                  AND ee.id_dper = cp.id_dper(+)
                                  AND ee.cod_abi = cp.cod_abi(+)
                                  AND ee.cod_ndg = cp.cod_ndg(+)) ee,
                          (  SELECT id_dper,
                                    cod_abi,
                                    cod_ndg,
                                    MAX (cod_sndg) cod_sndg,
                                    MAX (dta_decorrenza_stato)
                                       dta_decorrenza_stato,
                                    MAX (cod_filiale_area) cod_filiale_area
                               FROM t_mcres_app_sisba_cp
                              WHERE     0 = 0
                                    AND id_dper(+) =
                                           TO_NUMBER (
                                              TO_CHAR (
                                                 ADD_MONTHS (
                                                    TO_DATE (
                                                       SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info'),
                                                       'yyyymmdd'),
                                                    -1),
                                                 'yyyymmdd'))
                                    AND cod_stato_rischio = 'I'
                           GROUP BY id_dper, cod_abi, cod_ndg) cp_prec
                    WHERE     0 = 0
                          AND ee.cod_abi = cp_prec.cod_abi(+)
                          AND ee.cod_ndg = cp_prec.cod_ndg(+)) ee
           -----------------------------------------------------------------------
           UNION ALL
           ------------------------------------------------------------------------
           SELECT ee.id_dper,
                  'R' cod_stato_rischio,
                  dta_decorrenza_stato,
                  cod_filiale_area,
                  cod_sndg,
                  cod_abi,
                  cod_ndg,
                  val_per_ce,
                  val_rett_sval,
                  val_rett_att,
                  val_rip_mora,
                  val_quota_sval,
                  val_quota_att,
                  val_rip_sval,
                  val_rip_att,
                  val_attualizzazione,
                  CASE
                     WHEN cod_filiale_area IN
                             ('04195', '06601', '11901', '11905', '11906')
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_cmp_drc
             FROM (SELECT ee.id_dper,
                          CASE
                             WHEN ee.cod_stato_fin = 'R'
                             THEN
                                ee.dta_decorrenza_stato
                             WHEN ee.cod_stato_ini = 'R'
                             THEN
                                cp_prec.dta_decorrenza_stato
                          END
                             dta_decorrenza_stato,
                          CASE
                             WHEN ee.cod_stato_fin = 'R'
                             THEN
                                ee.cod_filiale_area
                             WHEN ee.cod_stato_ini = 'R'
                             THEN
                                cp_prec.cod_filiale_area
                          END
                             cod_filiale_area,
                          CASE
                             WHEN ee.cod_stato_fin = 'R'
                             THEN
                                ee.cod_sndg
                             WHEN ee.cod_stato_ini = 'R'
                             THEN
                                cp_prec.cod_sndg
                          END
                             cod_sndg,
                          ee.cod_abi,
                          ee.cod_ndg,
                          ee.val_per_ce,
                          ee.val_rett_sval,
                          ee.val_rett_att,
                          ee.val_rip_mora,
                          ee.val_quota_sval,
                          ee.val_quota_att,
                          ee.val_rip_sval,
                          ee.val_rip_att,
                          ee.val_attualizzazione
                     FROM (SELECT ee.id_dper,
                                  ee.cod_stato_ini,
                                  ee.cod_stato_fin,
                                  ee.cod_abi,
                                  ee.cod_ndg,
                                  cp.dta_decorrenza_stato,
                                  cp.cod_sndg,
                                  cp.cod_filiale_area,
                                  ee.val_per_ce,
                                  ee.val_rett_sval,
                                  ee.val_rett_att,
                                  ee.val_rip_mora,
                                  ee.val_quota_sval,
                                  ee.val_quota_att,
                                  ee.val_rip_sval,
                                  ee.val_rip_att,
                                  ee.val_attualizzazione
                             FROM t_mcres_app_effetti_economici ee,
                                  (  SELECT id_dper,
                                            cod_abi,
                                            cod_ndg,
                                            MAX (dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            MAX (cod_filiale_area)
                                               cod_filiale_area,
                                            MAX (cod_sndg) cod_sndg
                                       FROM t_mcres_app_sisba_cp
                                      WHERE id_dper =
                                               SYS_CONTEXT ('userenv',
                                                            'client_info')
                                   GROUP BY id_dper, cod_abi, cod_ndg) cp
                            WHERE     0 = 0
                                  AND ee.id_dper =
                                         SYS_CONTEXT ('userenv',
                                                      'client_info')
                                  AND (   cod_stato_ini = 'R'
                                       OR cod_stato_fin = 'R')
                                  AND ee.id_dper = cp.id_dper(+)
                                  AND ee.cod_abi = cp.cod_abi(+)
                                  AND ee.cod_ndg = cp.cod_ndg(+)) ee,
                          (  SELECT id_dper,
                                    cod_abi,
                                    cod_ndg,
                                    MAX (cod_sndg) cod_sndg,
                                    MAX (dta_decorrenza_stato)
                                       dta_decorrenza_stato,
                                    MAX (cod_filiale_area) cod_filiale_area
                               FROM t_mcres_app_sisba_cp
                              WHERE     0 = 0
                                    AND id_dper(+) =
                                           TO_NUMBER (
                                              TO_CHAR (
                                                 ADD_MONTHS (
                                                    TO_DATE (
                                                       SYS_CONTEXT (
                                                          'userenv',
                                                          'client_info'),
                                                       'yyyymmdd'),
                                                    -1),
                                                 'yyyymmdd'))
                                    AND cod_stato_rischio = 'R'
                           GROUP BY id_dper, cod_abi, cod_ndg) cp_prec
                    WHERE     0 = 0
                          AND ee.cod_abi = cp_prec.cod_abi(+)
                          AND ee.cod_ndg = cp_prec.cod_ndg(+)) ee) rv,
          t_mcre0_app_gruppo_economico ge
    WHERE 0 = 0 AND rv.cod_sndg = ge.cod_sndg(+);
