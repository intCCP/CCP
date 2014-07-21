/* Formatted on 21/07/2014 18:38:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_G
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
          TO_DATE (cod_annomesegiorno, 'yyyymmdd') DTA_COMPETENZA,
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
                  CASE
                     WHEN EXISTS
                             (SELECT 1
                                FROM t_mcres_app_notizie n
                               WHERE     n.cod_tipo_notizia = 50
                                     AND n.cod_abi = g.cod_abi
                                     AND n.cod_ndg = g.cod_ndg
                                     AND DTA_FINE_VALIDITA > SYSDATE)
                     THEN
                        1
                     ELSE
                        0
                  END
                     flg_cessione_routinaria,
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
             FROM (  SELECT 'G' cod_src,
                            --TO_CHAR (p.dta_riferimento, 'yyyymm') COD_ANNOMESE,
                            (SELECT TO_CHAR (MAX (ID_DPER), 'yyyymm')
                                       COD_ANNOMESEGIORNO
                               FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                              WHERE     COD_STATO IN
                                           ('CARICATO', 'CARICATO_APP') -- AND cod_flusso IN ('SISBA', 'SISBA_CP')
                                    AND cod_flusso = 'SISBA_CP')
                               COD_ANNOMESE,
                            TO_CHAR (LAST_DAY (p.dta_riferimento), 'yyyymmdd')
                               COD_ANNOMESEGIORNO,
                            cod_stato_rischio,
                            m.dta_decorrenza_stato dta_inizio_stato,
                            m.DTA_SCADENZA_STATO dta_fine_stato,
                            '#' cod_filiale,
                            '#' cod_filiale_area,
                            '#' cod_gestione,
                            '#' cod_area_business,
                            p.cod_abi_istituto cod_abi,
                            p.cod_ndg,
                            '#' cod_sndg,
                            '#' cod_gruppo_economico,
                            '#' cod_cli_ge,
                            '#' cod_stato_giuridico,
                            CASE
                               WHEN TO_CHAR (DTA_DECORRENZA_STATO, 'yyyy') =
                                       TO_CHAR (p.dta_riferimento, 'yyyy')
                               THEN
                                  1
                               ELSE
                                  0
                            END
                               flg_nuovo_ingresso,
                            0 val_vant,
                            SUM (p.val_imp_uti_cli) val_uti_ret,
                            0 val_att,
                            0 val_garanzie_reali_personali,
                            0 val_garanzie_reali,
                            0 val_garanzie_ipotecarie,
                            0 val_garanzie_pignoratizie,
                            0 val_garanzie_personali,
                            0 val_garanzie_altre_altri,
                            0 val_garanzie_altre,
                            0 val_garanzie_altri
                       FROM t_mcre0_app_pcr_sc_sb p,
                            (SELECT CASE
                                       WHEN COD_STATO = 'SO' THEN 'S'
                                       WHEN COD_STATO = 'IN' THEN 'I'
                                       ELSE '#'
                                    END
                                       COD_STATO_RISCHIO,
                                    DTA_DECORRENZA_STATO,
                                    DTA_SCADENZA_STATO,
                                    cod_abi_istituto,
                                    cod_ndg
                               FROM t_mcre0_app_mople
                              WHERE COD_STATO = 'IN'
                             UNION ALL
                             SELECT COD_STATO_RISCHIO,
                                    DTA_PASSAGGIO_SOFF DTA_DECORRENZA_STATO,
                                    DTA_CHIUSURA DTA_SCADENZA_STATO,
                                    cod_abi cod_abi_istituto,
                                    cod_ndg
                               FROM t_mcres_app_posizioni
                              WHERE cod_stato_rischio = 'S') m
                      WHERE     m.COD_STATO_RISCHIO IN ('I', 'S')
                            --  and (DTA_SCADENZA_STATO is null or DTA_SCADENZA_STATO>last_day(p.dta_riferimento))
                            AND p.cod_abi_istituto = m.cod_abi_istituto
                            AND p.cod_ndg = m.cod_ndg
                            AND dta_riferimento >
                                   (SELECT MAX (ID_DPER) COD_ANNOMESEGIORNO
                                      FROM MCRE_OWN.T_MCRES_WRK_ACQUISIZIONE W
                                     WHERE     COD_STATO IN
                                                  ('CARICATO', 'CARICATO_APP')
                                           -- AND cod_flusso IN ('SISBA', 'SISBA_CP')
                                           AND cod_flusso = 'SISBA_CP')
                   GROUP BY TO_CHAR (p.dta_riferimento, 'yyyymm'),
                            TO_CHAR (LAST_DAY (p.dta_riferimento),
                                     'yyyymmdd'),
                            --       to_char(p.dta_riferimento,'yyyymmdd')  ,
                            COD_STATO_RISCHIO,
                            p.cod_abi_istituto,
                            p.cod_ndg,
                            m.dta_decorrenza_stato,
                            m.DTA_SCADENZA_STATO,
                            CASE
                               WHEN TO_CHAR (DTA_DECORRENZA_STATO, 'yyyy') =
                                       TO_CHAR (p.dta_riferimento, 'yyyy')
                               THEN
                                  1
                               ELSE
                                  0
                            END) g);
