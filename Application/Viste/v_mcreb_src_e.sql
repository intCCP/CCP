/* Formatted on 21/07/2014 18:38:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_E
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   COD_ABI,
   COD_NDG,
   COD_CLI_GE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_FILIALE,
   COD_FILIALE_AREA,
   COD_GESTIONE,
   COD_AREA_BUSINESS,
   COD_STATO_GIURIDICO,
   VAL_VANT,
   VAL_UTI_RET,
   VAL_ATT,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_IPOTECARIE,
   VAL_GARANZIE_PIGNORATIZIE,
   VAL_GARANZIE_PERSONALI,
   VAL_GARANZIE_ALTRE_ALTRI,
   VAL_GARANZIE_ALTRE,
   VAL_GARANZIE_ALTRI,
   VAL_RET_EFF,
   VAL_MOV_AUM,
   VAL_MOV_DIM,
   VAL_MOV_INC,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   FLG_PORTAFOGLIO,
   FLG_CESSIONE_ROUTINARIA,
   FLG_CHIUSURA,
   FLG_GARANZIE_REALI_PERSONALI,
   FLG_GARANZIE_REALI,
   FLG_GARANZIE_IPOTECARIE,
   FLG_GARANZIE_PIGNORATIZIE,
   FLG_GARANZIE_PERSONALI,
   FLG_GARANZIE_ALTRE_ALTRI,
   FLG_GARANZIE_ALTRE,
   FLG_GARANZIE_ALTRI,
   FLG_CMP_DRC
)
AS
   SELECT COD_SRC,
          cod_annomese ID_DPER,
          cod_annomesegiorno DTA_COMPETENZA,
          COD_STATO_RISCHIO,
          DTA_INIZIO_STATO,
          DTA_FINE_STATO,
          COD_ABI,
          COD_NDG,
          COD_CLI_GE,
          COD_SNDG,
          cod_gruppo_economico,
          COD_FILIALE,
          COD_FILIALE_AREA,
          COD_GESTIONE,
          COD_AREA_BUSINESS,
          COD_STATO_GIURIDICO,
          VAL_VANT,
          VAL_UTI_RET,
          VAL_ATT,
          VAL_GARANZIE_REALI_PERSONALI,
          VAL_GARANZIE_REALI,
          VAL_GARANZIE_IPOTECARIE,
          VAL_GARANZIE_PIGNORATIZIE,
          VAL_GARANZIE_PERSONALI,
          VAL_GARANZIE_ALTRE_ALTRI,
          VAL_GARANZIE_ALTRE,
          VAL_GARANZIE_ALTRI,
          VAL_RET_EFF,
          VAL_MOV_AUM,
          VAL_MOV_DIM,
          VAL_MOV_INC,
          FLG_NDG,
          FLG_NUOVO_INGRESSO,
          FLG_PORTAFOGLIO,
          FLG_CESSIONE_ROUTINARIA,
          FLG_CHIUSURA,
          FLG_GARANZIE_REALI_PERSONALI,
          FLG_GARANZIE_REALI,
          FLG_GARANZIE_IPOTECARIE,
          FLG_GARANZIE_PIGNORATIZIE,
          FLG_GARANZIE_PERSONALI,
          FLG_GARANZIE_ALTRE_ALTRI,
          FLG_GARANZIE_ALTRE,
          FLG_GARANZIE_ALTRI,
          FLG_CMP_DRC
     FROM (SELECT cod_src,
                  COD_ANNOMESE,
                  COD_ANNOMESEGIORNO,
                  cod_stato_rischio,
                  NULL dta_inizio_stato,
                  NULL dta_fine_stato,
                  cod_filiale,
                  cod_filiale_area,
                  '#' cod_gestione,
                  cod_area_business,
                  cod_abi,
                  cod_ndg,
                  '#' cod_sndg,
                  '#' cod_gruppo_economico,
                  '#' cod_cli_ge,
                  '#' cod_stato_giuridico,
                  NULL val_vant,
                  NULL val_uti_ret,
                  NULL val_att,
                  NULL val_garanzie_reali_personali,
                  NULL val_garanzie_reali,
                  NULL val_garanzie_ipotecarie,
                  NULL val_garanzie_pignoratizie,
                  NULL val_garanzie_personali,
                  NULL val_garanzie_altre_altri,
                  NULL val_garanzie_altre,
                  NULL val_garanzie_altri,
                  VAL_RET_EFF,                         -- effetti: rettificato
                  NULL VAL_MOV_AUM,                                 -- movcont
                  NULL VAL_MOV_DIM,
                  NULL VAL_MOV_INC,
                  1 flg_ndg,
                  flg_portafoglio,
                  flg_nuovo_ingresso,
                  NULL flg_chiusura,
                  NULL flg_cessione_routinaria,
                  NULL flg_garanzie_reali_personali,
                  NULL flg_garanzie_reali,
                  NULL flg_garanzie_ipotecarie,
                  NULL flg_garanzie_pignoratizie,
                  NULL flg_garanzie_personali,
                  NULL flg_garanzie_altre_altri,
                  NULL flg_garanzie_altre,
                  NULL flg_garanzie_altri,
                  flg_cmp_drc
             FROM (SELECT 'E' cod_src,
                          ee.cod_stato_rischio,
                          ee.COD_ANNOMESE,
                          ee.id_dper cod_annomesegiorno,
                          ee.val_ret_eff,
                          ee.cod_abi,
                          ee.cod_ndg,
                          cp.cod_filiale,
                          cp.cod_filiale_area,
                          cp.cod_area_business,
                          ee.FLG_PORTAFOGLIO,
                          ee.flg_nuovo_ingresso,
                          CASE
                             WHEN flg_delibera = 1
                             THEN
                                0
                             WHEN cp_prec.dta_decorrenza_stato IS NULL
                             THEN
                                1
                             WHEN (TO_DATE (ee.id_dper, 'yyyymmdd') >=
                                      ADD_MONTHS (
                                         LAST_DAY (
                                            cp_prec.dta_decorrenza_stato),
                                         3))
                             THEN
                                1
                             WHEN dta_aggiornamento_delibera < cod_annomese
                             THEN
                                1
                             ELSE
                                0
                          END
                             flg_cmp_drc
                     FROM (  SELECT CASE
                                       WHEN (   ee.cod_stato_fin = 'S'
                                             OR ee.cod_stato_ini = 'S')
                                       THEN
                                          'S'
                                       WHEN (   ee.cod_stato_fin = 'I'
                                             OR ee.cod_stato_ini = 'I')
                                       THEN
                                          'I'
                                       ELSE
                                          '#'
                                    END
                                       cod_stato_rischio,
                                    SUBSTR (ee.id_dper, 1, 6) COD_ANNOMESE,
                                    ee.id_dper,
                                    SUM (
                                         (  ee.val_per_ce
                                          + ee.val_rett_sval
                                          + ee.val_rett_att)
                                       - (  ee.val_rip_mora
                                          + ee.val_quota_sval
                                          + ee.val_quota_att
                                          + ee.val_rip_sval
                                          + ee.val_rip_att
                                          + ee.val_attualizzazione))
                                       val_ret_eff,
                                    ee.cod_abi,
                                    ee.cod_ndg,
                                    1 FLG_PORTAFOGLIO,
                                    CASE
                                       WHEN (   ee.cod_stato_fin = 'S'
                                             OR ee.cod_stato_ini = 'S')
                                       THEN
                                          CASE
                                             WHEN ee.cod_stato_ini != 'S'
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END
                                       WHEN (   ee.cod_stato_fin = 'I'
                                             OR ee.cod_stato_ini = 'I')
                                       THEN
                                          CASE
                                             WHEN ee.cod_stato_ini != 'I'
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END
                                       ELSE
                                          0
                                    END
                                       flg_nuovo_ingresso,
                                    TO_CHAR (
                                       MAX (d.dta_aggiornamento_delibera),
                                       'YYYYMM')
                                       dta_aggiornamento_delibera,
                                    CASE
                                       WHEN EXISTS
                                               (SELECT 1
                                                  FROM t_mcres_app_delibere d
                                                 WHERE     0 = 0
                                                       AND ee.cod_abi =
                                                              d.cod_abi
                                                       AND ee.cod_ndg =
                                                              d.cod_ndg
                                                       AND d.cod_delibera =
                                                              'NZ'
                                                       AND d.cod_stato_delibera =
                                                              'CO'
                                                       AND d.dta_aggiornamento_delibera <=
                                                              TO_DATE (
                                                                 ee.id_dper,
                                                                 'yyyymmdd'))
                                       THEN
                                          1
                                       ELSE
                                          0
                                    END
                                       flg_delibera
                               FROM mcre_own.t_mcres_app_effetti_economici ee,
                                    mcre_own.t_mcres_app_delibere d        --,
                              WHERE --ee.cod_abi = p.cod_abi(+) AND ee.cod_ndg = p.cod_ndg(+) and
                                   ee   .id_dper =
                                           SYS_CONTEXT ('userenv',
                                                        'client_info')
                                    AND (   (   ee.cod_stato_fin = 'S'
                                             OR ee.cod_stato_ini = 'S')
                                         OR (   ee.cod_stato_fin = 'I'
                                             OR ee.cod_stato_ini = 'I'))
                                    AND ee.cod_abi = d.cod_abi(+)
                                    AND ee.cod_ndg = d.cod_ndg(+)
                                    AND d.cod_delibera(+) = 'NS'
                                    AND d.cod_stato_delibera(+) = 'CO'
                                    AND d.dta_aggiornamento_delibera(+) BETWEEN   ADD_MONTHS (
                                                                                     ee.dta_effetti_economici,
                                                                                     -2)
                                                                                + 1
                                                                            AND ee.dta_effetti_economici
                           GROUP BY CASE
                                       WHEN (   ee.cod_stato_fin = 'S'
                                             OR ee.cod_stato_ini = 'S')
                                       THEN
                                          'S'
                                       WHEN (   ee.cod_stato_fin = 'I'
                                             OR ee.cod_stato_ini = 'I')
                                       THEN
                                          'I'
                                       ELSE
                                          '#'
                                    END,
                                    SUBSTR (ee.id_dper, 1, 6),
                                    ee.id_dper,
                                    ee.cod_abi,
                                    ee.cod_ndg,
                                    CASE
                                       WHEN (   ee.cod_stato_fin = 'S'
                                             OR ee.cod_stato_ini = 'S')
                                       THEN
                                          CASE
                                             WHEN ee.cod_stato_ini != 'S'
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END
                                       WHEN (   ee.cod_stato_fin = 'I'
                                             OR ee.cod_stato_ini = 'I')
                                       THEN
                                          CASE
                                             WHEN ee.cod_stato_ini != 'I'
                                             THEN
                                                1
                                             ELSE
                                                0
                                          END
                                       ELSE
                                          0
                                    END) ee,
                          (  SELECT MAX (dta_decorrenza_stato)
                                       dta_decorrenza_stato,
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
                                                   SYS_CONTEXT ('userenv',
                                                                'client_info'),
                                                   'yyyymmdd'),
                                                -1),
                                             'yyyymmdd'))
                           GROUP BY cod_stato_rischio,
                                    id_dper,
                                    cod_abi,
                                    cod_ndg) cp_prec,
                          (SELECT DISTINCT
                                  cod_stato_rischio,
                                  id_dper,
                                  cod_abi,
                                  cod_ndg,
                                  NVL (UPPER (cp.cod_filiale), '#')
                                     cod_filiale,
                                  NVL (UPPER (cp.cod_filiale_area), '#')
                                     cod_filiale_area,
                                  NVL (UPPER (j.cod_div), '#')
                                     cod_area_business
                             FROM mcre_own.t_mcres_app_sisba_cp cp,
                                  mcre_own.T_MCRE0_APP_STRUTTURA_ORG j
                            WHERE     cp.id_dper =
                                         SYS_CONTEXT ('userenv',
                                                      'client_info')
                                  AND cp.COD_ABI = j.COD_ABI_ISTITUTO
                                  AND cp.COD_FILIALE =
                                         j.COD_STRUTTURA_COMPETENTE) cp
                    WHERE     ee.cod_stato_rischio =
                                 cp_prec.cod_stato_rischio(+)
                          AND TO_NUMBER (
                                 TO_CHAR (
                                    ADD_MONTHS (
                                       TO_DATE (ee.id_dper, 'yyyymmdd'),
                                       -1),
                                    'yyyymmdd')) = cp_prec.id_dper(+)
                          AND ee.cod_abi = cp_prec.cod_abi(+)
                          AND ee.cod_ndg = cp_prec.cod_ndg(+)
                          AND ee.cod_stato_rischio = cp.cod_stato_rischio(+)
                          AND ee.id_dper = cp.id_dper(+)
                          AND ee.cod_abi = cp.cod_abi(+)
                          AND ee.cod_ndg = cp.cod_ndg(+)));
