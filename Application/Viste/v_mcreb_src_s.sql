/* Formatted on 21/07/2014 18:38:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_S
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
   FLG_GARANZIE_ALTRI
)
AS
   SELECT COD_SRC,
          cod_annomese ID_DPER,
          TO_DATE (cod_annomesegiorno, 'yyyymmdd') DTA_COMPETENZA,
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
          FLG_GARANZIE_ALTRI
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
                  NULL VAL_RET_EFF,                    -- effetti: rettificato
                  NULL VAL_MOV_AUM,                                 -- movcont
                  NULL VAL_MOV_DIM,
                  NULL VAL_MOV_INC,
                  1 flg_ndg,
                  1 flg_portafoglio,
                  NULL flg_nuovo_ingresso,
                  CASE
                     WHEN dta_fine_stato BETWEEN LAST_DAY (
                                                    ADD_MONTHS (
                                                       TO_DATE (COD_ANNOMESE,
                                                                'yyyymm'),
                                                       -12))
                                             AND LAST_DAY (
                                                    TO_DATE (COD_ANNOMESE,
                                                             'yyyymm'))
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_chiusura,
                  NULL flg_cessione_routinaria,
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
                     flg_garanzie_altri
             FROM (  SELECT 'S' cod_src,
                            (SELECT TO_CHAR (MAX (ID_DPER), 'yyyymm')
                                       COD_ANNOMESEGIORNO
                               FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                              WHERE     COD_STATO IN
                                           ('CARICATO', 'CARICATO_APP') -- AND cod_flusso IN ('SISBA', 'SISBA_CP')
                                    AND cod_flusso = 'SISBA_CP')
                               COD_ANNOMESE,
                            id_dper COD_ANNOMESEGIORNO,
                            CASE
                               WHEN UPPER (cod_stato_rischio) = 'E' THEN 'I'
                               WHEN UPPER (cod_stato_rischio) = 'S' THEN 'S'
                               ELSE 'X'
                            END
                               cod_stato_rischio,
                            NULL dta_inizio_stato,
                            NULL dta_fine_stato,
                            '#' cod_filiale,
                            '#' cod_filiale_area,
                            '#' cod_gestione,
                            '#' cod_area_business,
                            cp.cod_abi,
                            cp.cod_ndg,
                            '#' cod_sndg,
                            '#' cod_gruppo_economico,
                            '#' cod_cli_ge,
                            '#' cod_stato_giuridico,
                            SUM (cp.VAL_IMP_CREDITO_VANTATO) val_vant,
                            SUM (cp.VAL_IMP_UTI_RETTIFICATO) val_uti_ret,
                            SUM (VAL_IMP_NPV_STIMA_RECUPERO) val_att,
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
                            SUM (NVL (val_imp_garanzie_pignoratizie, 0))
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
                       FROM mcre_own.T_MCRES_APP_SISBA cp
                      WHERE     UPPER (cod_stato_rischio) IN ('S', 'E')
                            --AND   VAL_FIRMA!='FIRMA'
                            AND ID_DPER >
                                   (SELECT MAX (
                                              TO_NUMBER (
                                                 TO_CHAR (ID_DPER, 'yyyymmdd')))
                                              COD_ANNOMESEGIORNO
                                      FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                                     WHERE     COD_STATO IN
                                                  ('CARICATO', 'CARICATO_APP')
                                           AND cod_flusso = 'SISBA_CP')
                   GROUP BY SUBSTR (id_dper, 1, 6),
                            id_dper,
                            CASE
                               WHEN UPPER (cod_stato_rischio) = 'E' THEN 'I'
                               WHEN UPPER (cod_stato_rischio) = 'S' THEN 'S'
                               ELSE 'X'
                            END,
                            cp.cod_abi,
                            cp.cod_ndg));
