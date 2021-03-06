/* Formatted on 21/07/2014 18:38:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_U
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
                  DTA_DECORRENZA_STATO dta_inizio_stato,
                  DTA_SCADENZA_STATO dta_fine_stato,
                  '#' cod_filiale,
                  '#' cod_filiale_area,
                  '#' cod_gestione,
                  '#' cod_area_business,
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
                  NULL VAL_RET_EFF,                    -- effetti: rettificato
                  NULL VAL_MOV_AUM,                                 -- movcont
                  NULL VAL_MOV_DIM,
                  NULL VAL_MOV_INC,
                  1 flg_ndg,
                  0 flg_portafoglio,
                  NULL flg_nuovo_ingresso,
                  1 flg_chiusura,
                  NULL flg_cessione_routinaria,
                  NULL flg_garanzie_reali_personali,
                  NULL flg_garanzie_reali,
                  NULL flg_garanzie_ipotecarie,
                  NULL flg_garanzie_pignoratizie,
                  NULL flg_garanzie_personali,
                  NULL flg_garanzie_altre_altri,
                  NULL flg_garanzie_altre,
                  NULL flg_garanzie_altri
             FROM (SELECT 'U' cod_src,
                          SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                  1,
                                  6)
                             COD_ANNOMESE,
                          SYS_CONTEXT ('userenv', 'client_info')
                             COD_ANNOMESEGIORNO,
                          COD_STATO_RISCHIO,
                          cod_abi_istituto cod_abi,
                          cod_ndg,
                          DTA_DECORRENZA_STATO,
                          DTA_SCADENZA_STATO
                     FROM (SELECT CASE
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
                    WHERE DTA_SCADENZA_STATO BETWEEN   ADD_MONTHS (
                                                          TO_DATE (
                                                             SYS_CONTEXT (
                                                                'userenv',
                                                                'client_info'),
                                                             'yyyymmdd'),
                                                          -12)
                                                     + 1
                                                 AND TO_DATE (
                                                        SYS_CONTEXT (
                                                           'userenv',
                                                           'client_info'),
                                                        'yyyymmdd')) g);
