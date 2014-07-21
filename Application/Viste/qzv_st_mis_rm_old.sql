/* Formatted on 21/07/2014 18:30:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_RM_OLD
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   FLG_PORTAFOGLIO,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   FLG_CHIUSURA,
   COD_FILIALE,
   COD_PRESIDIO,
   COD_GRUPPO_ECONOMICO,
   COD_ABI,
   COD_NDG,
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
   SELECT 'RM' COD_SRC,
          ee.ID_DPER,
          ee.DTA_COMPETENZA,
          ee.COD_STATO_RISCHIO,
          CASE
             WHEN ee.cod_stato_rischio = 'S' THEN 'Sofferenze'
             WHEN ee.cod_stato_rischio = 'I' THEN 'Incagli'
             WHEN ee.cod_stato_rischio = 'R' THEN 'Ristrutturati'
             ELSE NULL
          END
             des_stato_rischio,
          ee.DTA_INIZIO_STATO,
          ee.DTA_FINE_STATO,
          ee.FLG_PORTAFOGLIO,
          ee.FLG_NDG,
          ee.FLG_NUOVO_INGRESSO,
          ee.FLG_CHIUSURA,
          cod_filiale,
          cod_presidio,
          cod_gruppo_economico,
          --cod_area_business,
          ee.COD_ABI,
          ee.COD_NDG,
          val_rip_mora,
          val_per_ce,
          val_quota_sval,
          val_quota_att,
          val_rett_sval,
          val_rip_sval,
          val_rett_att,
          val_rip_att,
          val_attualizzazione,
          flg_cmp_drc
     FROM (  SELECT 'RM' cod_src, --dta_effetti_economici solo per mensile coincide con id_dper
                    SUBSTR (ee.id_dper, 1, 6) id_dper,
                    ee.dta_effetti_economici,
                    TO_CHAR (dta_effetti_economici, 'YYYYMMDD') dta_competenza,
                    ee.cod_abi,
                    ee.cod_ndg,
                    'S' cod_stato_rischio,
                    --verificare il max
                    MAX (cp.dta_decorrenza_stato) dta_inizio_stato,
                    NULL dta_fine_stato,
                    1 flg_portafoglio,
                    1 flg_ndg,
                    CASE
                       WHEN TO_CHAR (MAX (cp.dta_decorrenza_stato), 'yyyy') =
                               SUBSTR (cp.id_dper, 1, 4)
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_nuovo_ingresso,
                    CASE
                       WHEN MAX (cp.dta_decorrenza_stato) BETWEEN LAST_DAY (
                                                                     ADD_MONTHS (
                                                                        TO_DATE (
                                                                           ee.id_dper,
                                                                           'yyyymmdd'),
                                                                        -12))
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                        ee.id_dper,
                                                                        'yyyymmdd'))
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_chiusura,
                    cp.cod_filiale,
                    cod_area_business,
                    cod_presidio,
                    cod_gruppo_economico,
                    SUM (val_rip_mora) val_rip_mora,
                    SUM (val_per_ce) val_per_ce,
                    SUM (val_quota_sval) val_quota_sval,
                    SUM (val_quota_att) val_quota_att,
                    SUM (val_rett_sval) val_rett_sval,
                    SUM (val_rip_sval) val_rip_sval,
                    SUM (val_rett_att) val_rett_att,
                    SUM (val_rip_att) val_rip_att,
                    SUM (val_attualizzazione) val_attualizzazione,
                    --max (dta_aggiornamento_delibera),
                    CASE
                       WHEN     MAX (ee.cod_stato_ini) = 'S'
                            AND NOT EXISTS
                                       (SELECT 1
                                          FROM t_mcres_app_delibere d
                                         WHERE     0 = 0
                                               AND ee.cod_abi = d.cod_abi
                                               AND ee.cod_ndg = d.cod_ndg
                                               AND d.cod_delibera = 'NZ'
                                               AND d.cod_stato_delibera = 'CO'
                                               AND d.dta_aggiornamento_delibera <=
                                                      TO_DATE (ee.id_dper,
                                                               'yyyymmdd'))
                            AND ( (   (MAX (cp.dta_decorrenza_stato) IS NULL)
                                   OR (TO_DATE (ee.id_dper, 'yyyymmdd') >=
                                          ADD_MONTHS (
                                             LAST_DAY (
                                                MAX (cp.dta_decorrenza_stato)),
                                             3))
                                   OR (TO_CHAR (
                                          MAX (d.dta_aggiornamento_delibera),
                                          'YYYYMM') < SUBSTR (ee.id_dper, 1, 6))))
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_cmp_drc
               FROM t_mcres_app_effetti_economici ee,
                    (  SELECT cod_abi,
                              cod_ndg,
                              MAX (dta_aggiornamento_delibera)
                                 dta_aggiornamento_delibera
                         FROM t_mcres_app_delibere d
                        WHERE     d.cod_delibera = 'NS'
                              AND d.cod_stato_delibera = 'CO'
                     GROUP BY cod_abi, cod_ndg) d,
                    (SELECT cp.id_dper,
                            cod_abi,
                            cod_ndg,
                            CASE
                               WHEN g.cod_gruppo_economico IS NOT NULL
                               THEN
                                  g.cod_gruppo_economico
                               WHEN cp.cod_sndg IS NOT NULL
                               THEN
                                  cp.cod_sndg
                               ELSE
                                  '#'
                            END
                               cod_gruppo_economico,
                            dta_decorrenza_stato,
                            NVL (UPPER (cp.cod_filiale), '#') cod_filiale,
                            NVL (UPPER (cp.cod_filiale_area), '#') cod_presidio,
                            NVL (UPPER (o.cod_div), '#') cod_area_business
                       FROM (  SELECT id_dper,
                                      cod_abi,
                                      cod_ndg,
                                      MAX (cod_sndg) cod_sndg,
                                      MAX (cod_filiale) cod_filiale,
                                      MAX (cod_filiale_area) cod_filiale_area,
                                      cod_stato_rischio,
                                      MAX (dta_decorrenza_stato)
                                         dta_decorrenza_stato
                                 FROM t_mcres_app_sisba_cp
                                WHERE cod_stato_rischio = 'S'
                             GROUP BY id_dper,
                                      cod_abi,
                                      cod_ndg,
                                      --cod_filiale,cod_filiale_area,
                                      cod_stato_rischio) cp,
                            t_mcre0_app_struttura_org o,
                            t_mcre0_app_gruppo_economico g
                      WHERE     cod_abi = cod_abi_istituto(+)
                            AND cod_filiale = cod_struttura_competente(+)
                            AND cp.cod_sndg = g.cod_sndg(+)) cp
              WHERE     0 = 0
                    AND (ee.cod_stato_ini = 'S' OR ee.cod_stato_fin = 'S')
                    AND ee.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                    AND ee.cod_abi = cp.cod_abi(+)
                    AND ee.cod_ndg = cp.cod_ndg(+)
                    AND cp.id_dper(+) =
                           TO_NUMBER (
                              TO_CHAR (
                                 ADD_MONTHS (TO_DATE (ee.id_dper, 'yyyymmdd'),
                                             -1),
                                 'yyyymmdd'))
                    AND ee.cod_abi = d.cod_abi(+)
                    AND ee.cod_ndg = d.cod_ndg(+)
           --and d.cod_delibera(+) = 'ns'
           --and d.cod_stato_delibera(+) = 'co'
           --and d.dta_aggiornamento_delibera(+) between add_months ( ee.dta_effetti_economici,  -3) + 1 and ee.dta_effetti_economici
           GROUP BY SUBSTR (cp.id_dper, 1, 4),
                    SUBSTR (ee.id_dper, 1, 6),
                    ee.id_dper,
                    ee.dta_effetti_economici,
                    ee.cod_abi,
                    ee.cod_ndg,
                    cp.cod_filiale,
                    cod_area_business,
                    cod_presidio,
                    cod_gruppo_economico
           UNION ALL
             SELECT 'RM' cod_src, --dta_effetti_economici solo per mensile coincide con id_dper
                    SUBSTR (ee.id_dper, 1, 6) id_dper,
                    ee.dta_effetti_economici,
                    TO_CHAR (dta_effetti_economici, 'YYYYMMDD') dta_competenza,
                    ee.cod_abi,
                    ee.cod_ndg,
                    'I' cod_stato_rischio,
                    --verificare il max
                    MAX (cp.dta_decorrenza_stato) dta_inizio_stato,
                    NULL dta_fine_stato,
                    1 flg_portafoglio,
                    1 flg_ndg,
                    CASE
                       WHEN TO_NUMBER (
                               TO_CHAR (
                                  LAST_DAY (MAX (cp.dta_decorrenza_stato)),
                                  'YYYYMMDD')) = ee.id_dper
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_nuovo_ingresso,
                    CASE
                       WHEN MAX (cp.dta_decorrenza_stato) BETWEEN LAST_DAY (
                                                                     ADD_MONTHS (
                                                                        TO_DATE (
                                                                           ee.id_dper,
                                                                           'yyyymmdd'),
                                                                        -12))
                                                              AND LAST_DAY (
                                                                     TO_DATE (
                                                                        ee.id_dper,
                                                                        'yyyymmdd'))
                       THEN
                          1
                       ELSE
                          0
                    END
                       flg_chiusura,
                    cp.cod_filiale,
                    cod_area_business,
                    cod_presidio,
                    NULL cod_gruppo_economico,
                    SUM (val_rip_mora) val_rip_mora,
                    SUM (val_per_ce) val_per_ce,
                    SUM (val_quota_sval) val_quota_sval,
                    SUM (val_quota_att) val_quota_att,
                    SUM (val_rett_sval) val_rett_sval,
                    SUM (val_rip_sval) val_rip_sval,
                    SUM (val_rett_att) val_rett_att,
                    SUM (val_rip_att) val_rip_att,
                    SUM (val_attualizzazione) val_attualizzazione,
                    NULL flg_cmp_drc
               FROM t_mcres_app_effetti_economici ee,
                    (SELECT id_dper,
                            cod_abi,
                            cod_ndg,
                            dta_decorrenza_stato,
                            NVL (UPPER (cp.cod_filiale), '#') cod_filiale,
                            NVL (UPPER (cp.cod_filiale_area), '#') cod_presidio,
                            NVL (UPPER (o.cod_div), '#') cod_area_business
                       FROM (  SELECT id_dper,
                                      cod_abi,
                                      cod_ndg,
                                      MAX (cod_filiale) cod_filiale,
                                      MAX (cod_filiale_area) cod_filiale_area,
                                      cod_stato_rischio,
                                      MAX (dta_decorrenza_stato)
                                         dta_decorrenza_stato
                                 FROM t_mcres_app_sisba_cp
                                WHERE cod_stato_rischio = 'I'
                             GROUP BY id_dper,
                                      cod_abi,
                                      cod_ndg,
                                      --cod_filiale,cod_filiale_area,
                                      cod_stato_rischio) cp,
                            t_mcre0_app_struttura_org o
                      WHERE     cod_abi = cod_abi_istituto(+)
                            AND cod_filiale = cod_struttura_competente(+)) cp
              WHERE     0 = 0
                    AND (ee.cod_stato_ini = 'I' OR ee.cod_stato_fin = 'I')
                    AND ee.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                    AND ee.cod_abi = cp.cod_abi(+)
                    AND ee.cod_ndg = cp.cod_ndg(+)
                    AND cp.id_dper(+) =
                           TO_NUMBER (
                              TO_CHAR (
                                 ADD_MONTHS (TO_DATE (ee.id_dper, 'yyyymmdd'),
                                             -1),
                                 'yyyymmdd'))
           GROUP BY SUBSTR (ee.id_dper, 1, 6),
                    ee.id_dper,
                    ee.dta_effetti_economici,
                    ee.cod_abi,
                    ee.cod_ndg,
                    cp.cod_filiale,
                    cod_area_business,
                    cod_presidio) ee,
          (  SELECT MAX (dta_decorrenza_stato) dta_decorrenza_stato,
                    cod_stato_rischio,
                    id_dper,
                    cod_abi,
                    cod_ndg
               FROM mcre_own.t_mcres_app_sisba_cp
              WHERE id_dper =
                       TO_NUMBER (
                          TO_CHAR (
                             ADD_MONTHS (
                                TO_DATE (
                                   SYS_CONTEXT ('userenv', 'client_info'),
                                   'yyyymmdd'),
                                -1),
                             'yyyymmdd'))
           GROUP BY cod_stato_rischio,
                    id_dper,
                    cod_abi,
                    cod_ndg) cp_prec
    --                    ,
    --          (select distinct
    --                  cod_stato_rischio,
    --                  id_dper,
    --                  cod_abi,
    --                  cod_ndg,
    --                  nvl (upper (cp.cod_filiale), '#') cod_filiale,
    --                  nvl (upper (cp.cod_filiale_area), '#') cod_presidio,
    --                  nvl (upper (j.cod_div), '#') cod_area_business
    --             from mcre_own.t_mcres_app_sisba_cp cp,
    --                  mcre_own.t_mcre0_app_struttura_org j
    --            where     cp.id_dper = sys_context ('userenv', 'client_info')
    --                  and cp.cod_abi = j.cod_abi_istituto
    --                  and cp.cod_filiale = j.cod_struttura_competente) cp
    WHERE     ee.cod_stato_rischio = cp_prec.cod_stato_rischio(+)
          AND TO_NUMBER (
                 TO_CHAR (ADD_MONTHS (TO_DATE (ee.id_dper, 'yyyymm'), -1),
                          'yyyymmdd')) = cp_prec.id_dper(+)
          AND ee.cod_abi = cp_prec.cod_abi(+)
          AND ee.cod_ndg = cp_prec.cod_ndg(+)
--          and ee.cod_stato_rischio = cp.cod_stato_rischio(+)
--          and ee.id_dper = cp.id_dper(+)
--          and ee.cod_abi = cp.cod_abi(+)
--          and ee.cod_ndg = cp.cod_ndg(+);
;
