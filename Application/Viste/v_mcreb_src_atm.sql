/* Formatted on 21/07/2014 18:38:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREB_SRC_ATM
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
                  VAL_MOV_AUM,                                      -- movcont
                  VAL_MOV_DIM,
                  VAL_MOV_INC,
                  1 flg_ndg,
                  0 flg_portafoglio,
                  NULL flg_nuovo_ingresso,
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
                  NULL FLG_CMP_DRC
             FROM ( -- BEGIN dbms_application_info.set_client_info('20111031'); END;
                   SELECT   COD_FLT_TMP COD_SRC,
                            COD_ANNOMESE,
                            COD_ANNOMESEGIORNO,
                            'R' cod_stato_rischio,
                            cod_abi,
                            cod_ndg,
                            COUNT (DISTINCT ee.id_dper) real_months,
                            MIN (m) total_month,
                            MIN (ee.id_dper) min_month,
                            MAX (ee.id_dper) max_month,
                            MIN (f.ID_DPER) ID_DPER,
                            MAX (f.ID_DPER_pre) ID_DPER_pre,
                            SUM (
                               CASE
                                  WHEN desc_modulo IN
                                          ('ALL.1 - NUOVE SOFFERENZE DA INCAGLIO',
                                           'ALL.2 - NUOVE SOFFERENZE DA BONIS',
                                           'ALL.3 - ADDEBITI SU SOFFERENZE')
                                  THEN
                                     val_cr_tot
                                  ELSE
                                     0
                               END)
                               VAL_MOV_AUM,
                            SUM (
                               CASE
                                  WHEN desc_modulo IN
                                          ('ALL.5 - SOFFERENZE TRASFERITE A BONIS',
                                           'ALL.6 - SOFFERENZE ESTINTE',
                                           'ALL.7 - SOFFERENZE RIDOTTE',
                                           'ALL.8 - STRALCI SU SOFFERENZE')
                                  THEN
                                     val_cr_tot
                                  ELSE
                                     0
                               END)
                               VAL_MOV_DIM,
                            SUM (
                               CASE
                                  WHEN desc_modulo IN
                                          ('ALL.6 - SOFFERENZE ESTINTE',
                                           'ALL.7 - SOFFERENZE RIDOTTE')
                                  THEN
                                     val_cr_tot
                                  ELSE
                                     0
                               END)
                               VAL_MOV_INC
                       FROM t_mcres_app_movimenti_mod_mov ee,
                            (SELECT F.ID_DPER COD_ANNOMESE,
                                    TO_CHAR (
                                       LAST_DAY (TO_DATE (f.ID_DPER, 'yyyymm')),
                                       'yyyymmdd')
                                       COD_ANNOMESEGIORNO,
                                    COD_FLT_TMP,
                                    ID_DPER_pre a,
                                    ID_DPER b,
                                    MONTHS_BETWEEN (
                                       TO_DATE (ID_DPER, 'yyyymm'),
                                       TO_DATE (ID_DPER_pre, 'yyyymm'))
                                       m,
                                    TO_CHAR (
                                       LAST_DAY (
                                          ADD_MONTHS (
                                             TO_DATE (ID_DPER_pre, 'yyyymm'),
                                             1)),
                                       'yyyymmdd')
                                       ID_DPER_pre,
                                    TO_CHAR (
                                       LAST_DAY (TO_DATE (ID_DPER, 'yyyymm')),
                                       'yyyymmdd')
                                       ID_DPER
                               FROM mcre_own.T_MCREB_DIM_MIS_FLT_PRD f
                              WHERE                      --COD_FLT_TMP='A' and
                                   ORD_FLT_TMP = 1      --and F.ID_DPER=201112
                                    AND f.id_dper =
                                           SUBSTR (
                                              SYS_CONTEXT ('userenv',
                                                           'client_info'),
                                              1,
                                              6)) f
                      WHERE ee.id_dper(+) BETWEEN f.ID_DPER_pre AND f.ID_DPER
                   GROUP BY cod_abi,
                            cod_ndg,
                            COD_ANNOMESE,
                            COD_FLT_TMP) g);
