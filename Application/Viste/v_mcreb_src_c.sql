/* Formatted on 21/07/2014 18:38:54 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_C
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
   FLG_GARANZIE_ALTRI
)
AS
   SELECT COD_SRC,
          cod_annomese ID_DPER,
          NULL DTA_COMPETENZA,
          COD_STATO_RISCHIO,
          DTA_INIZIO_STATO,
          DTA_FINE_STATO,
          COD_ABI,
          COD_NDG,
          COD_CLI_GE,
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
          FLG_GARANZIE_ALTRI
     FROM (SELECT /*+index(ee,PK_MCRES_APP_EFFETTI_ECONOMICI)*/
                 cod_src,
                  a.cod_annomese,
                  a.cod_annomesegiorno,
                  a.cod_stato_rischio,
                  dta_inizio_stato,
                  dta_fine_stato,
                  cod_filiale,
                  cod_filiale_area,
                  cod_gestione,
                  cod_area_business,
                  a.cod_abi,
                  a.cod_ndg,
                  a.cod_sndg,
                  a.cod_gruppo_economico,
                  cod_cli_ge,
                  cod_stato_giuridico,
                  val_vant,
                  val_uti_ret,
                  val_att,
                  val_garanzie_reali_personali,
                  val_garanzie_reali,
                  val_garanzie_ipotecarie,
                  val_garanzie_pignoratizie,
                  val_garanzie_personali,
                  val_garanzie_altre_altri,
                  val_garanzie_altre,
                  val_garanzie_altri,
                  VAL_RET_EFF,                         -- effetti: rettificato
                  VAL_MOV_AUM,                                      -- movcont
                  VAL_MOV_DIM,
                  VAL_MOV_INC,
                  flg_ndg,
                  flg_portafoglio,
                  flg_nuovo_ingresso,
                  flg_chiusura,
                  NULL flg_cessione_routinaria,
                  flg_garanzie_reali_personali,
                  flg_garanzie_reali,
                  flg_garanzie_ipotecarie,
                  flg_garanzie_pignoratizie,
                  flg_garanzie_personali,
                  flg_garanzie_altre_altri,
                  flg_garanzie_altre,
                  flg_garanzie_altri
             FROM (SELECT cod_src,
                          COD_ANNOMESE,
                          COD_ANNOMESEGIORNO,
                          cod_stato_rischio,
                          dta_inizio_stato,
                          dta_fine_stato,
                          cod_filiale,
                          cod_filiale_area,
                          cod_gestione,
                          cod_area_business,
                          cod_abi,
                          cod_ndg,
                          cod_sndg,
                          cod_gruppo_economico,
                          cod_cli_ge,
                          cod_stato_giuridico,
                          val_vant,
                          val_uti_ret,
                          val_att,
                          val_garanzie_reali_personali,
                          val_garanzie_reali,
                          val_garanzie_ipotecarie,
                          val_garanzie_pignoratizie,
                          val_garanzie_personali,
                          val_garanzie_altre_altri,
                          val_garanzie_altre,
                          val_garanzie_altri,
                          NULL VAL_MOV_AUM,                         -- movcont
                          NULL VAL_MOV_DIM,
                          NULL VAL_MOV_INC,
                          flg_ndg,
                          flg_portafoglio,
                          flg_nuovo_ingresso,
                          flg_chiusura,
                          CASE
                             WHEN val_garanzie_reali_personali > 0 THEN 1
                             ELSE 0
                          END
                             flg_garanzie_reali_personali,
                          CASE WHEN val_garanzie_reali > 0 THEN 1 ELSE 0 END
                             flg_garanzie_reali,
                          CASE
                             WHEN val_garanzie_ipotecarie > 0 THEN 1
                             ELSE 0
                          END
                             flg_garanzie_ipotecarie,
                          CASE
                             WHEN val_garanzie_pignoratizie > 0 THEN 1
                             ELSE 0
                          END
                             flg_garanzie_pignoratizie,
                          CASE
                             WHEN val_garanzie_personali > 0 THEN 1
                             ELSE 0
                          END
                             flg_garanzie_personali,
                          CASE
                             WHEN val_garanzie_altre_altri > 0 THEN 1
                             ELSE 0
                          END
                             flg_garanzie_altre_altri,
                          CASE WHEN val_garanzie_altre > 0 THEN 1 ELSE 0 END
                             flg_garanzie_altre,
                          CASE WHEN val_garanzie_altri > 0 THEN 1 ELSE 0 END
                             flg_garanzie_altri
                     FROM (  SELECT cod_src,
                                    COD_ANNOMESE,
                                    COD_ANNOMESEGIORNO,
                                    NVL (cod_stato_rischio, '#')
                                       cod_stato_rischio,
                                    dta_inizio_stato,
                                    dta_fine_stato,
                                    NVL (cod_filiale, '#') cod_filiale,
                                    NVL (cod_filiale_area, '#')
                                       cod_filiale_area,
                                    NVL (UPPER (i.cod_livello), '#')
                                       cod_gestione,
                                    NVL (UPPER (j.cod_div), '#')
                                       cod_area_business,
                                    cod_abi,
                                    cod_ndg,
                                    cp.cod_sndg,
                                    NVL (g.cod_gruppo_economico, '#')
                                       cod_gruppo_economico,
                                    CASE
                                       WHEN g.cod_gruppo_economico IS NOT NULL
                                       THEN
                                          g.cod_gruppo_economico
                                       ELSE
                                          cp.cod_sndg
                                    END
                                       cod_cli_ge,
                                    NVL (cod_stato_giuridico, '#')
                                       cod_stato_giuridico,
                                    SUM (cp.val_vant) val_vant,
                                    SUM (cp.val_uti_ret) val_uti_ret,
                                    SUM (cp.val_att) val_att,
                                    SUM (val_garanzie_reali_personali)
                                       val_garanzie_reali_personali,
                                    SUM (val_garanzie_reali) val_garanzie_reali,
                                    SUM (val_garanzie_ipotecarie)
                                       val_garanzie_ipotecarie,
                                    SUM (val_garanzie_pignoratizie)
                                       val_garanzie_pignoratizie,
                                    SUM (val_garanzie_personali)
                                       val_garanzie_personali,
                                    SUM (val_garanzie_altre_altri)
                                       val_garanzie_altre_altri,
                                    SUM (val_garanzie_altre) val_garanzie_altre,
                                    SUM (val_garanzie_altri) val_garanzie_altri,
                                    1 flg_ndg,
                                    1 flg_portafoglio,
                                    CASE
                                       WHEN TO_CHAR (dta_inizio_stato, 'yyyy') =
                                               SUBSTR (COD_ANNOMESE, 1, 4)
                                       THEN
                                          1
                                       ELSE
                                          0
                                    END
                                       flg_nuovo_ingresso,
                                    CASE
                                       WHEN dta_fine_stato BETWEEN LAST_DAY (
                                                                      ADD_MONTHS (
                                                                         TO_DATE (
                                                                            COD_ANNOMESE,
                                                                            'yyyymm'),
                                                                         -12))
                                                               AND LAST_DAY (
                                                                      TO_DATE (
                                                                         COD_ANNOMESE,
                                                                         'yyyymm'))
                                       THEN
                                          1
                                       ELSE
                                          0
                                    END
                                       flg_chiusura
                               FROM (  SELECT 'C' cod_src,
                                              SUBSTR (cp.id_dper, 1, 6)
                                                 COD_ANNOMESE,
                                              cp.id_dper COD_ANNOMESEGIORNO,
                                              NVL (UPPER (cp.cod_stato_rischio),
                                                   '#')
                                                 cod_stato_rischio,
                                              cp.DTA_DECORRENZA_STATO
                                                 dta_inizio_stato,
                                              NULL dta_fine_stato,
                                              NVL (UPPER (cp.cod_filiale), '#')
                                                 cod_filiale,
                                              NVL (UPPER (cp.cod_filiale_area),
                                                   '#')
                                                 cod_filiale_area,
                                              cp.cod_abi,
                                              cp.cod_ndg,
                                              cp.cod_sndg,
                                              NVL (
                                                 UPPER (cp.cod_stato_giuridico),
                                                 '#')
                                                 cod_stato_giuridico,
                                              MIN (cp.dta_decorrenza_stato)
                                                 dta_decorrenza_stato,
                                              SUM (cp.val_vant) val_vant,
                                              SUM (cp.val_uti_ret) val_uti_ret,
                                              SUM (cp.val_att) val_att,
                                              SUM (
                                                   NVL (
                                                      val_imp_garanzie_personali,
                                                      0)
                                                 + NVL (
                                                      val_imp_garanzia_ipotecaria,
                                                      0)
                                                 + NVL (
                                                      val_imp_garanzie_pignoratizie,
                                                      0))
                                                 val_garanzie_reali_personali,
                                              SUM (
                                                   NVL (
                                                      val_imp_garanzia_ipotecaria,
                                                      0)
                                                 + NVL (
                                                      val_imp_garanzie_pignoratizie,
                                                      0))
                                                 val_garanzie_reali,
                                              SUM (
                                                 NVL (
                                                    val_imp_garanzia_ipotecaria,
                                                    0))
                                                 val_garanzie_ipotecarie,
                                              SUM (
                                                 NVL (
                                                    val_imp_garanzie_pignoratizie,
                                                    0))
                                                 val_garanzie_pignoratizie,
                                              SUM (
                                                 NVL (val_imp_garanzie_personali,
                                                      0))
                                                 val_garanzie_personali,
                                              SUM (
                                                   NVL (val_imp_garanzie_altre,
                                                        0)
                                                 + NVL (val_imp_garanzie_altri,
                                                        0))
                                                 val_garanzie_altre_altri,
                                              SUM (
                                                 NVL (val_imp_garanzie_altre, 0))
                                                 val_garanzie_altre,
                                              SUM (
                                                 NVL (val_imp_garanzie_altri, 0))
                                                 val_garanzie_altri
                                         FROM mcre_own.T_MCRES_APP_SISBA_CP cp,
                                              mcre_own.t_mcres_app_sisba s
                                        WHERE     cp.cod_abi = s.cod_abi(+)
                                              AND cp.cod_ndg = s.cod_ndg(+)
                                              AND cp.id_dper = s.id_dper(+)
                                              AND cp.cod_rapporto =
                                                     s.cod_rapporto_sisba(+)
                                              AND cp.cod_sportello =
                                                     s.cod_filiale_rapporto(+)
                                              AND UPPER (cp.cod_stato_rischio) IN
                                                     ('I', 'S')
                                              AND VAL_FIRMA != 'FIRMA'
                                              AND cp.id_dper =
                                                     SYS_CONTEXT ('userenv',
                                                                  'client_info')
                                     GROUP BY SUBSTR (cp.id_dper, 1, 6),
                                              cp.id_dper,
                                              cp.cod_stato_rischio,
                                              cp.DTA_DECORRENZA_STATO,
                                              cp.cod_filiale,
                                              cp.cod_filiale_area,
                                              cp.cod_abi,
                                              cp.cod_ndg,
                                              cp.cod_sndg,
                                              UPPER (cp.cod_stato_giuridico)) cp,
                                    mcre_own.T_MCRE0_APP_STRUTTURA_ORG i,
                                    mcre_own.T_MCRE0_APP_STRUTTURA_ORG j,
                                    mcre_own.T_MCRE0_APP_GRUPPO_ECONOMICO g
                              WHERE     cp.COD_ABI = i.COD_ABI_ISTITUTO
                                    AND cp.COD_FILIALE_AREA =
                                           i.COD_STRUTTURA_COMPETENTE
                                    AND cp.COD_ABI = j.COD_ABI_ISTITUTO
                                    AND cp.COD_FILIALE =
                                           j.COD_STRUTTURA_COMPETENTE
                                    AND cp.cod_sndg = g.cod_sndg(+)
                           GROUP BY cod_src,
                                    COD_ANNOMESE,
                                    COD_ANNOMESEGIORNO,
                                    cod_stato_rischio,
                                    dta_inizio_stato,
                                    dta_fine_stato,
                                    cod_filiale,
                                    cod_filiale_area,
                                    UPPER (i.cod_livello),
                                    UPPER (j.cod_div),
                                    cod_abi,
                                    cod_ndg,
                                    cp.cod_sndg,
                                    g.cod_gruppo_economico,
                                    cod_stato_giuridico,
                                    CASE
                                       WHEN TO_CHAR (DTA_DECORRENZA_STATO,
                                                     'yyyy') =
                                               SUBSTR (COD_ANNOMESE, 1, 4)
                                       THEN
                                          1
                                       ELSE
                                          0
                                    END)) a,
                  (  SELECT CASE
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
                            cod_abi,
                            cod_ndg,
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
                               VAL_RET_EFF
                       FROM mcre_own.t_mcres_app_effetti_economici ee
                      WHERE    (   ee.cod_stato_fin = 'S'
                                OR ee.cod_stato_ini = 'S')
                            OR (   ee.cod_stato_fin = 'I'
                                OR ee.cod_stato_ini = 'I')
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
                            cod_abi,
                            cod_ndg) ee
            WHERE     a.cod_abi = ee.cod_abi(+)
                  AND a.cod_ndg = ee.cod_ndg(+)
                  AND a.cod_stato_rischio = ee.cod_stato_rischio(+)
                  AND a.COD_ANNOMESE = ee.COD_ANNOMESE(+));
