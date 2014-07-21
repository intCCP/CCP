/* Formatted on 21/07/2014 18:44:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_PTF_DETT_VG
(
   VAL_ANNOMESE,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   DTA_APERTURA,
   DTA_PASSAGGIO_SOFF,
   COD_STATO_RISCHIO,
   COD_FILIALE,
   SCSB_UTI_TOT,
   DTA_DELIBERA,
   FLG_NI,
   VAL_IMP_GBV_NI_OLD,
   VAL_IMP_GBV_NI,
   VAL_IMP_NBV_NI,
   FLG_NT,
   VAL_IMP_GBV_NT,
   VAL_IMP_NBV_NT,
   FLG_FT,
   VAL_IMP_GBV_FT_OLD,
   VAL_IMP_GBV_FT,
   VAL_IMP_NBV_FT,
   FLG_FB,
   VAL_IMP_GBV_FB,
   VAL_IMP_NBV_FB,
   FLG_CT,
   VAL_IMP_GBV_CT_OLD,
   VAL_IMP_GBV_CT,
   VAL_IMP_NBV_CT,
   FLG_AR,
   VAL_IMP_GBV_AR,
   VAL_IMP_NBV_AR,
   FLG_RE,
   VAL_IMP_GBV_RE,
   VAL_IMP_NBV_RE,
   VAL_TIPO_GESTIONE
)
AS
   SELECT "VAL_ANNOMESE",
          "COD_ABI",
          "COD_NDG",
          "COD_SNDG",
          "COD_MATR_PRATICA",
          "COD_UO_PRATICA",
          "DTA_APERTURA",
          "DTA_PASSAGGIO_SOFF",
          "COD_STATO_RISCHIO",
          "COD_FILIALE",
          "SCSB_UTI_TOT",
          "DTA_DELIBERA",
          "FLG_NI",
          "VAL_IMP_GBV_NI_OLD",
          "VAL_IMP_GBV_NI",
          "VAL_IMP_NBV_NI",
          "FLG_NT",
          "VAL_IMP_GBV_NT",
          "VAL_IMP_NBV_NT",
          "FLG_FT",
          "VAL_IMP_GBV_FT_OLD",
          "VAL_IMP_GBV_FT",
          "VAL_IMP_NBV_FT",
          "FLG_FB",
          "VAL_IMP_GBV_FB",
          "VAL_IMP_NBV_FB",
          "FLG_CT",
          "VAL_IMP_GBV_CT_OLD",
          "VAL_IMP_GBV_CT",
          "VAL_IMP_NBV_CT",
          "FLG_AR",
          "VAL_IMP_GBV_AR",
          "VAL_IMP_NBV_AR",
          "FLG_RE",
          "VAL_IMP_GBV_RE",
          "VAL_IMP_NBV_RE",
          "VAL_TIPO_GESTIONE"
     FROM (SELECT DISTINCT
                  A.VAL_ANNOMESE_SISBA_CP val_annomese,
                  Z.COD_ABI,
                  Z.COD_NDG,
                  Z.COD_SNDG,
                  p.cod_matr_pratica,
                  CASE
                     WHEN z.flg_art_498 = 'S' THEN cod_uo_art_498
                     ELSE p.cod_uo_pratica
                  END
                     COD_UO_PRATICA,
                  p.DTA_APERTURA,
                  Z.DTA_PASSAGGIO_SOFF,
                  z.cod_stato_rischio,
                  CASE
                     WHEN z.flg_art_498 = 'S' THEN cod_uo_art_498
                     ELSE p.cod_uo_pratica
                  END
                     cod_filiale,
                  PCR.SCSB_UTI_TOT,
                  CASE
                     WHEN     Z.DTA_PASSAGGIO_SOFF >=
                                 ADD_MONTHS (TRUNC (SYSDATE), -3)
                          AND del.dta_delibera IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        DEL.DTA_DELIBERA
                     ELSE
                        NULL
                  END
                     dta_delibera,
                  CASE
                     WHEN     Z.DTA_PASSAGGIO_SOFF >=
                                 ADD_MONTHS (TRUNC (SYSDATE), -3)
                          AND del.dta_delibera IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_NI,
                  CASE
                     WHEN     Z.DTA_PASSAGGIO_SOFF >=
                                 ADD_MONTHS (TRUNC (SYSDATE), -3)
                          AND del.dta_delibera IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * val_imp_gbv)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_NI_OLD,
                  CASE
                     WHEN     Z.DTA_PASSAGGIO_SOFF >=
                                 ADD_MONTHS (TRUNC (SYSDATE), -3)
                          AND del.dta_delibera IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           CASE
                              WHEN R.DTA_APERTURA_RAPP <=
                                      NVL (pcr_inc.DTA_INZ_VLD,
                                           R.DTA_APERTURA_RAPP)
                              THEN
                                 -1 * val_imp_gbv
                              ELSE
                                 pcr_inc.val_gbv_pcr
                           END)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_NI,
                  CASE
                     WHEN     Z.DTA_PASSAGGIO_SOFF >=
                                 ADD_MONTHS (TRUNC (SYSDATE), -3)
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_ni,
                  CASE
                     WHEN     NT.COD_TIPO_NOTIZIA IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_NT,
                  CASE
                     WHEN     NT.COD_TIPO_NOTIZIA IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_Nt,
                  CASE
                     WHEN     NT.COD_TIPO_NOTIZIA IS NOT NULL
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_nt,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_FT,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        R.FLG_RAPP_FONDO_TERZO)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_FT_OLD,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           ---1 * R.VAL_IMP_GBV)
                           CASE
                              WHEN R.DTA_APERTURA_RAPP <=
                                      NVL (pcr_inc.DTA_INZ_VLD,
                                           R.DTA_APERTURA_RAPP)
                              THEN
                                 -1 * val_imp_gbv
                              ELSE
                                 pcr_inc.val_gbv_pcr
                           END)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        R.FLG_RAPP_FONDO_TERZO)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_FT,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        R.FLG_RAPP_FONDO_TERZO)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_ft,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'N'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_FB,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'N'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        R.FLG_RAPP_FONDO_TERZO)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_FB,
                  CASE
                     WHEN     FLG_RAPP_FONDO_TERZO = 'N'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        R.FLG_RAPP_FONDO_TERZO)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_fb,
                  CASE
                     WHEN     FLG_RAPP_CARTOLARIZZATo = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_CT,
                  CASE
                     WHEN     FLG_RAPP_CARTOLARIZZATo = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_RAPP_CARTOLARIZZATI)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_CT_OLD,
                  CASE
                     WHEN     FLG_RAPP_CARTOLARIZZATo = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           ---1 * R.VAL_IMP_GBV)
                           CASE
                              WHEN R.DTA_APERTURA_RAPP <=
                                      NVL (pcr_inc.DTA_INZ_VLD,
                                           R.DTA_APERTURA_RAPP)
                              THEN
                                 -1 * val_imp_gbv
                              ELSE
                                 pcr_inc.val_gbv_pcr
                           END)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_RAPP_CARTOLARIZZATI)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_CT,
                  CASE
                     WHEN     FLG_RAPP_CARTOLARIZZATo = 'S'
                          AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_RAPP_CARTOLARIZZATI)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_ct,
                  CASE WHEN z.FLG_ART_498 = 'S' THEN 'S' ELSE NULL END FLG_AR,
                  CASE
                     WHEN z.FLG_ART_498 = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_ART_498)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_AR,
                  CASE
                     WHEN z.FLG_ART_498 = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_ART_498)
                     ELSE
                        NULL
                  END
                     val_imp_nbv_ar,
                  CASE
                     WHEN FLG_RAPP_ESTERo = 'S' AND z.cod_stato_rischio = 'S'
                     THEN
                        'S'
                     ELSE
                        NULL
                  END
                     FLG_RE,
                  CASE
                     WHEN FLG_RAPP_ESTERo = 'S' AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_GBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDG,
                                        P.COD_MATR_PRATICA,
                                        P.COD_UO_PRATICA,
                                        Z.FLG_RAPP_ESTERI)
                     ELSE
                        NULL
                  END
                     VAL_IMP_GBV_RE,
                  CASE
                     WHEN FLG_RAPP_ESTERo = 'S' AND z.cod_stato_rischio = 'S'
                     THEN
                        SUM (
                           -1 * R.VAL_IMP_NBV)
                        OVER (
                           PARTITION BY Z.COD_ABI,
                                        Z.COD_NDg,
                                        P.COD_MATR_PRATICA,
                                        p.COD_UO_PRATICA,
                                        z.FLG_RAPP_ESTERI)
                     ELSE
                        NULL
                  END
                     VAL_IMP_NBV_RE,
                  lp.val_tipo_gestione
             FROM T_MCRES_APP_POSIZIONI PARTITION (SOFF_PATTIVE) Z,
                  T_MCRES_APP_Pratiche PARTITION (SOFF_PATTIVE) p,
                  t_mcres_app_rapporti r,
                  --------------- INIZIO PCR --------------------
                  (  SELECT p.cod_abi,
                            p.cod_ndg,
                            p.cod_rapporto,
                            P.DTA_INZ_VLD,
                            SUM (P.VAL_IMP_UTILIZZATO) val_gbv_pcr
                       FROM t_mcrei_app_pcr_rapporti p
                   GROUP BY p.cod_abi,
                            p.cod_ndg,
                            p.cod_rapporto,
                            P.DTA_INZ_VLD) pcr_inc,
                  --------------- FINE PCR --------------------
                  (  SELECT COD_ABI,
                            cod_ndg,
                            MAX (DTA_INSERIMENTO_DELIBERA) dta_delibera
                       FROM T_MCRES_APP_DELIBERE D
                      WHERE cod_delibera IN ('NS', 'NZ')
                   GROUP BY cod_abi, cod_ndg) del,
                  (SELECT DISTINCT COD_ABI_ISTITUTO, COD_NDG, p.SCSB_UTI_TOT
                     FROM T_MCRE0_APP_ALL_DATA PARTITION (CCP_P1) P
                    WHERE p.cod_stato = 'SO') PCR,
                  (SELECT DISTINCT COD_ABI, cod_ndg, COD_TIPO_NOTIZIA
                     FROM T_MCRES_APP_NOTIZIE N
                    WHERE     DTA_FINE_VALIDITA =
                                 TO_DATE ('99991231', 'YYYYMMDD')
                          AND cod_tipo_notizia IN (1, 2, 85)) NT,
                  (SELECT *
                     FROM V_MCRES_APP_LISTA_PRESIDI
                    WHERE COD_TIPO = 'P') lp,
                  V_MCRES_APP_ULTIMO_ANNOMESE A
            WHERE     (z.cod_stato_rischio = 'S' OR z.FLG_ART_498 = 'S')
                  AND Z.COD_ABI = R.COD_ABI(+)
                  AND z.cod_ndg = r.cod_ndg(+)
                  AND z.cod_abi = p.cod_abi(+)
                  AND Z.COD_NDG = p.COD_NDG(+)
                  AND Z.COD_ABI = DEL.COD_ABI(+)
                  AND Z.COD_NDG = DEL.COD_NDG(+)
                  AND Z.COD_ABI = pcr.COD_ABI_istituto(+)
                  AND Z.COD_NDG = PCR.COD_NDG(+)
                  AND Z.COD_ABI = NT.COD_ABI(+)
                  AND Z.COD_NDG = NT.COD_NDG(+)
                  AND p.cod_uo_pratica = lp.COD_PRESIDIO(+)
                  AND r.cod_abi = pcr_inc.cod_abi(+)
                  AND r.cod_ndg = pcr_inc.cod_ndg(+)
                  AND r.cod_rapporto = pcr_inc.COD_RAPPORTO(+))
    WHERE flg_ni = 'S' OR flg_ct = 'S' OR flg_ft = 'S';
