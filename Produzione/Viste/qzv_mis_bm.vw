/* Formatted on 17/06/2014 17:58:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_MIS_BM
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   COD_FILIALE,
   COD_PRESIDIO,
   COD_GESTIONE,
   COD_AREA_BUSINESS,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_CLI_GE,
   COD_STATO_GIURIDICO,
   COD_FIRMA,
   COD_SEGM_IRB,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_IPOTECARIE,
   VAL_GARANZIE_PIGNORATIZIE,
   VAL_GARANZIE_PERSONALI,
   VAL_GARANZIE_ALTRE_ALTRI,
   VAL_GARANZIE_ALTRE,
   VAL_GARANZIE_ALTRI,
   FLG_NDG,
   FLG_PORTAFOGLIO,
   FLG_NUOVO_INGRESSO,
   FLG_CHIUSURA,
   FLG_GARANZIE_REALI_PERSONALI,
   FLG_GARANZIE_REALI,
   FLG_GARANZIE_IPOTECARIE,
   FLG_GARANZIE_PIGNORATIZIE,
   FLG_GARANZIE_PERSONALI,
   FLG_GARANZIE_ALTRE_ALTRI,
   FLG_GARANZIE_ALTRE,
   FLG_GARANZIE_ALTRI,
   FLG_CMP_DRC,
   FLG_FIRMA,
   COD_FORMA_TECNICA
)
AS
   SELECT b."COD_SRC",
          b."ID_DPER",
          b."DTA_COMPETENZA",
          b."COD_STATO_RISCHIO",
          b."DTA_INIZIO_STATO",
          b."DTA_FINE_STATO",
          b."COD_FILIALE",
          b."COD_FILIALE_AREA" COD_PRESIDIO,
          b."COD_GESTIONE",
          b."COD_AREA_BUSINESS",
          b."COD_ABI",
          b."COD_NDG",
          b."COD_SNDG",
          b."COD_GRUPPO_ECONOMICO",
          b."COD_CLI_GE",
          b."COD_STATO_GIURIDICO",
          b."COD_FIRMA",
          b.COD_SEGM_IRB,
          b."VAL_VANT",
          b."VAL_GBV",
          b."VAL_NBV",
          b."VAL_GARANZIE_REALI_PERSONALI",
          b."VAL_GARANZIE_REALI",
          b."VAL_GARANZIE_IPOTECARIE",
          b."VAL_GARANZIE_PIGNORATIZIE",
          b."VAL_GARANZIE_PERSONALI",
          b."VAL_GARANZIE_ALTRE_ALTRI",
          b."VAL_GARANZIE_ALTRE",
          b."VAL_GARANZIE_ALTRI",
          b."FLG_NDG",
          b."FLG_PORTAFOGLIO",
          b."FLG_NUOVO_INGRESSO",
          b."FLG_CHIUSURA",
          b."FLG_GARANZIE_REALI_PERSONALI",
          b."FLG_GARANZIE_REALI",
          b."FLG_GARANZIE_IPOTECARIE",
          b."FLG_GARANZIE_PIGNORATIZIE",
          b."FLG_GARANZIE_PERSONALI",
          b."FLG_GARANZIE_ALTRE_ALTRI",
          b."FLG_GARANZIE_ALTRE",
          b."FLG_GARANZIE_ALTRI",
          b."FLG_CMP_DRC",
          b."FLG_FIRMA",
          NVL (UPPER (cod_forma_tecnica), '#') cod_forma_tecnica
     FROM (SELECT cod_src,
                  ID_DPER,
                  DTA_COMPETENZA,
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
                  COD_FIRMA,
                  COD_SEGM_IRB,
                  val_vant,
                  val_uti_ret VAL_gbv,
                  val_att VAL_nbv,
                  val_garanzie_reali_personali,
                  val_garanzie_reali,
                  val_garanzie_ipotecarie,
                  val_garanzie_pignoratizie,
                  val_garanzie_personali,
                  val_garanzie_altre_altri,
                  val_garanzie_altre,
                  val_garanzie_altri,
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
                  CASE WHEN val_garanzie_ipotecarie > 0 THEN 1 ELSE 0 END
                     flg_garanzie_ipotecarie,
                  CASE WHEN val_garanzie_pignoratizie > 0 THEN 1 ELSE 0 END
                     flg_garanzie_pignoratizie,
                  CASE WHEN val_garanzie_personali > 0 THEN 1 ELSE 0 END
                     flg_garanzie_personali,
                  CASE WHEN val_garanzie_altre_altri > 0 THEN 1 ELSE 0 END
                     flg_garanzie_altre_altri,
                  CASE WHEN val_garanzie_altre > 0 THEN 1 ELSE 0 END
                     flg_garanzie_altre,
                  CASE WHEN val_garanzie_altri > 0 THEN 1 ELSE 0 END
                     flg_garanzie_altri,
                  NULL FLG_CMP_DRC,
                  CASE WHEN COD_FIRMA = 'FIRMA' THEN 1 ELSE 0 END flg_Firma
             FROM (  SELECT cod_src,
                            cp.ID_DPER,
                            DTA_COMPETENZA,
                            NVL (cod_stato_rischio, '#') cod_stato_rischio,
                            dta_inizio_stato,
                            dta_fine_stato,
                            NVL (cod_filiale, '#') cod_filiale,
                            NVL (cod_filiale_area, '#') cod_filiale_area,
                            NVL (UPPER (i.cod_livello), '#') cod_gestione,
                            NVL (UPPER (j.cod_div), '#') cod_area_business,
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
                            --stato giur prevalente
                            NVL (cod_stato_giuridico, '#') cod_stato_giuridico,
                            COD_FIRMA,
                            COD_SEGM_IRB,
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
                            SUM (val_garanzie_personali) val_garanzie_personali,
                            SUM (val_garanzie_altre_altri)
                               val_garanzie_altre_altri,
                            SUM (val_garanzie_altre) val_garanzie_altre,
                            SUM (val_garanzie_altri) val_garanzie_altri,
                            1 flg_ndg,
                            1 flg_portafoglio,
                            CASE
                               WHEN TO_CHAR (dta_inizio_stato, 'yyyy') =
                                       SUBSTR (cp.ID_DPER, 1, 4)
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
                                                                    cp.ID_DPER,
                                                                    'yyyymm'),
                                                                 -12))
                                                       AND LAST_DAY (
                                                              TO_DATE (
                                                                 cp.ID_DPER,
                                                                 'yyyymm'))
                               THEN
                                  1
                               ELSE
                                  0
                            END
                               flg_chiusura
                       FROM (  SELECT 'MM' cod_src,
                                      SUBSTR (cp.id_dper, 1, 6) ID_DPER,
                                      cp.id_dper DTA_COMPETENZA,
                                      NVL (UPPER (cp.cod_stato_rischio), '#')
                                         cod_stato_rischio,
                                      cp.DTA_DECORRENZA_STATO dta_inizio_stato,
                                      NULL dta_fine_stato,
                                      NVL (UPPER (cp.cod_filiale), '#')
                                         cod_filiale,
                                      NVL (UPPER (cp.cod_filiale_area), '#')
                                         cod_filiale_area,
                                      NVL (UPPER (cp.VAL_FIRMA), '#') COD_FIRMA,
                                      NVL (UPPER (cp.COD_SEGM_IRB), '#')
                                         COD_SEGM_IRB,
                                      cp.cod_abi,
                                      cp.cod_ndg,
                                      cp.cod_sndg,
                                      NVL (UPPER (cp.cod_stato_giuridico), '#')
                                         cod_stato_giuridico,
                                      MIN (cp.dta_decorrenza_stato)
                                         dta_decorrenza_stato,
                                      SUM (cp.val_vant) val_vant,
                                      SUM (cp.val_uti_ret) val_uti_ret,
                                      SUM (cp.val_att) val_att,
                                      SUM (
                                           NVL (val_imp_garanzie_personali, 0)
                                         + NVL (val_imp_garanzia_ipotecaria, 0)
                                         + NVL (val_imp_garanzie_pignoratizie, 0))
                                         val_garanzie_reali_personali,
                                      SUM (
                                           NVL (val_imp_garanzia_ipotecaria, 0)
                                         + NVL (val_imp_garanzie_pignoratizie, 0))
                                         val_garanzie_reali,
                                      SUM (NVL (val_imp_garanzia_ipotecaria, 0))
                                         val_garanzie_ipotecarie,
                                      SUM (
                                         NVL (val_imp_garanzie_pignoratizie, 0))
                                         val_garanzie_pignoratizie,
                                      SUM (NVL (val_imp_garanzie_personali, 0))
                                         val_garanzie_personali,
                                      SUM (
                                           NVL (val_imp_garanzie_altre, 0)
                                         + NVL (val_imp_garanzie_altri, 0))
                                         val_garanzie_altre_altri,
                                      SUM (NVL (val_imp_garanzie_altre, 0))
                                         val_garanzie_altre,
                                      SUM (NVL (val_imp_garanzie_altri, 0))
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
                                      --AND VAL_FIRMA != 'FIRMA'
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
                                      UPPER (cp.cod_stato_giuridico),
                                      NVL (UPPER (cp.VAL_FIRMA), '#'),
                                      NVL (UPPER (cp.COD_SEGM_IRB), '#')) cp,
                            mcre_own.T_MCRE0_APP_STRUTTURA_ORG i,
                            mcre_own.T_MCRE0_APP_STRUTTURA_ORG j,
                            mcre_own.T_MCRE0_APP_GRUPPO_ECONOMICO g
                      WHERE     cp.COD_ABI = i.COD_ABI_ISTITUTO
                            AND cp.COD_FILIALE_AREA =
                                   i.COD_STRUTTURA_COMPETENTE
                            AND cp.COD_ABI = j.COD_ABI_ISTITUTO
                            AND cp.COD_FILIALE = j.COD_STRUTTURA_COMPETENTE
                            AND cp.cod_sndg = g.cod_sndg(+)
                   GROUP BY cod_src,
                            cp.ID_DPER,
                            DTA_COMPETENZA,
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
                               WHEN TO_CHAR (DTA_DECORRENZA_STATO, 'yyyy') =
                                       SUBSTR (cp.ID_DPER, 1, 4)
                               THEN
                                  1
                               ELSE
                                  0
                            END,
                            cod_firma,
                            COD_SEGM_IRB)) b,
          (SELECT 'S' cod_stato_rischio,
                  cod_abi,
                  cod_Ndg,
                  CASE
                     WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
                     WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
                     WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
                     WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
                     WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
                     ELSE 'A'
                  END
                     cod_forma_tecnica
             FROM t_mcres_app_rapporti r
           UNION ALL
           SELECT 'I' cod_stato_rischio,
                  cod_abi,
                  cod_Ndg,
                  CASE
                     -- WHEN NVL (R.FLG_CONFIDI, 'N') = 'S' THEN 'C'
                     -- WHEN NVL (R.FLG_AGEVOLATO, 'N') = 'S' THEN 'G'
                     -- WHEN NVL (R.FLG_CONTRIBUTO, 'N') = 'S' THEN 'R'
                  WHEN NVL (R.FLG_RAPP_CARTOLARIZZATO, 'N') = 'S' THEN 'Z'
                     --WHEN NVL (R.FLG_RAPP_FONDO_TERZO, 'N') = 'S' THEN 'T'
                  WHEN NVL (R.FLG_FONDO_TERZI, 'N') = 'S' THEN 'T'
                     WHEN NVL (R.FLG_RISTRUTTURATO, 'N') = 'S' THEN 'X'
                     ELSE 'A'
                  END
                     cod_forma_tecnica
             FROM t_mcrei_app_rapporti r
            WHERE flg_Attiva = '1') f
    WHERE     b.cod_stato_rischio = f.cod_stato_rischio(+)
          AND b.cod_abi = f.cod_abi(+)
          AND b.cod_Ndg = f.cod_Ndg(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_MIS_BM TO MCRE_USR;
