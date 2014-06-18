/* Formatted on 17/06/2014 17:59:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BM
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_PRESIDIO,
   COD_GESTIONE,
   COD_ABI,
   COD_STATO_GIURIDICO,
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
   SELECT 'BM' cod_src,
          ID_DPER,
          DTA_COMPETENZA,
          cod_stato_rischio,
          CASE
             WHEN cod_stato_rischio = 'S' THEN 'Sofferenze'
             WHEN cod_stato_rischio = 'I' THEN 'Incagli'
             WHEN cod_stato_rischio = 'R' THEN 'Ristrutturati'
             ELSE NULL
          END
             des_stato_rischio,
          --  dta_inizio_stato,
          --  dta_fine_stato,
          -- cod_filiale,
          cod_filiale_area cod_Presidio,
          cod_gestione,
          --   cod_area_business,
          cod_abi,
          --   cod_ndg,
          --   cod_sndg,
          --   cod_gruppo_economico,
          --   cod_cli_ge,
          cod_stato_giuridico,
          --          COD_FIRMA,
          --   COD_SEGM_IRB,
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
          CASE WHEN val_garanzie_reali_personali > 0 THEN 1 ELSE 0 END
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
             flg_garanzie_altri                                            --,
     --          NULL FLG_CMP_DRC--,
     -- CASE WHEN COD_FIRMA = 'FIRMA' THEN 1 ELSE 0 END flg_Firma
     FROM (  SELECT cp.ID_DPER,
                    DTA_COMPETENZA,
                    NVL (cod_stato_rischio, '#') cod_stato_rischio,
                    -- dta_inizio_stato,
                    -- dta_fine_stato,
                    --     NVL (cod_filiale, '#') cod_filiale,
                    NVL (cod_filiale_area, '#') cod_filiale_area,
                    NVL (UPPER (i.cod_livello), '#') cod_gestione,
                    --     NVL (UPPER (j.cod_div), '#') cod_area_business,
                    cod_abi,
                    --  cod_ndg,
                    --  cp.cod_sndg,
                    --  NVL (g.cod_gruppo_economico, '#')       cod_gruppo_economico,
                    --  CASE
                    --     WHEN g.cod_gruppo_economico IS NOT NULL
                    --     THEN
                    --        g.cod_gruppo_economico
                    --     ELSE
                    --        cp.cod_sndg
                    --  END
                    --     cod_cli_ge,
                    --stato giur prevalente
                    --NVL (cod_stato_giuridico, '#')
                    --NVL (substr(cod_stato_giuridico,instr(cod_stato_giuridico,'@#@')+3,length(cod_stato_giuridico))  , '#')      cod_stato_giuridico,
                    cod_stato_giuridico,
                    --    COD_FIRMA,
                    --   COD_SEGM_IRB,
                    SUM (cp.val_vant) val_vant,
                    SUM (cp.val_uti_ret) val_uti_ret,
                    SUM (cp.val_att) val_att,
                    SUM (val_garanzie_reali_personali)
                       val_garanzie_reali_personali,
                    SUM (val_garanzie_reali) val_garanzie_reali,
                    SUM (val_garanzie_ipotecarie) val_garanzie_ipotecarie,
                    SUM (val_garanzie_pignoratizie) val_garanzie_pignoratizie,
                    SUM (val_garanzie_personali) val_garanzie_personali,
                    SUM (val_garanzie_altre_altri) val_garanzie_altre_altri,
                    SUM (val_garanzie_altre) val_garanzie_altre,
                    SUM (val_garanzie_altri) val_garanzie_altri,
                    SUM (flg_ndg) flg_ndg,
                    1 flg_portafoglio,
                    flg_nuovo_ingresso
               FROM (  SELECT SUBSTR (cp.id_dper, 1, 6) ID_DPER,
                              cp.id_dper DTA_COMPETENZA,
                              NVL (UPPER (cp.cod_stato_rischio), '#')
                                 cod_stato_rischio,
                              CASE
                                 WHEN TO_CHAR (dta_decorrenza_stato, 'yyyy') =
                                         SUBSTR (cp.ID_DPER, 1, 4)
                                 THEN
                                    1
                                 ELSE
                                    0
                              END
                                 flg_nuovo_ingresso,
                              --                              NVL (UPPER (cp.cod_filiale), '#')
                              --                                 cod_filiale,
                              --MAX( NVL (UPPER (cp.cod_filiale_area), '#'))
                              cod_filiale_area,
                              --    NVL (UPPER (cp.VAL_FIRMA), '#') COD_FIRMA,
                              -- NVL (UPPER (cp.COD_SEGM_IRB), '#')
                              --     COD_SEGM_IRB,
                              cp.cod_abi,
                              COUNT (DISTINCT cp.cod_ndg) flg_ndg,
                              --   cp.cod_sndg,
                              --max(x.VAL_PESO||'@#@'||x.COD_STATO_GIURIDICO)
                              NVL (UPPER (cp.cod_stato_giuridico), '#')
                                 cod_stato_giuridico,
                              MIN (cp.dta_decorrenza_stato) dta_decorrenza_stato,
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
                         FROM mcre_own.T_MCRES_APP_SISBA_CP cp,
                              mcre_own.t_mcres_app_sisba s                 --,
                        -- mcre_own.T_MCRES_CL_STATO_GIURIDICO x
                        WHERE     cp.cod_abi = s.cod_abi(+)
                              AND cp.cod_ndg = s.cod_ndg(+)
                              AND cp.id_dper = s.id_dper(+)
                              AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                              AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                              AND UPPER (cp.cod_stato_rischio) IN ('I', 'S', 'R')
                              AND VAL_FIRMA != 'FIRMA'
                              --
                              --  and cp.cod_abi='03359'
                              AND cp.id_dper =
                                     SYS_CONTEXT ('userenv', 'client_info')
                     --    AND UPPER (cp.cod_stato_rischio) ='S'
                     --
                     --  and cp.cod_ndg!='#'
                     -- and upper(cp.COD_STATO_GIURIDICO) = upper(x.COD_STATO_GIURIDICO(+))
                     GROUP BY SUBSTR (cp.id_dper, 1, 6),
                              cp.id_dper,
                              cp.cod_stato_rischio,
                              cp.DTA_DECORRENZA_STATO,
                              --   cp.cod_filiale,
                              cp.cod_filiale_area,
                              cp.cod_abi,
                              --cp.cod_ndg,
                              --cp.cod_sndg,
                              NVL (UPPER (cp.cod_stato_giuridico), '#') --      NVL (UPPER (cp.VAL_FIRMA), '#'),
                                          --NVL (UPPER (cp.COD_SEGM_IRB), '#')
                    ) cp,
                    mcre_own.T_MCRE0_APP_STRUTTURA_ORG i                   --,
              --  mcre_own.T_MCRE0_APP_STRUTTURA_ORG j--,
              --mcre_own.T_MCRE0_APP_GRUPPO_ECONOMICO g
              WHERE     cp.COD_ABI = i.COD_ABI_ISTITUTO(+)
                    AND cp.COD_FILIALE_AREA = i.COD_STRUTTURA_COMPETENTE(+)
           --                    AND cp.COD_ABI = j.COD_ABI_ISTITUTO(+)
           --                    AND cp.COD_FILIALE = j.COD_STRUTTURA_COMPETENTE(+)
           ---AND cp.cod_sndg = g.cod_sndg(+)
           GROUP BY cp.ID_DPER,
                    DTA_COMPETENZA,
                    cod_stato_rischio,
                    --dta_inizio_stato,
                    --dta_fine_stato,
                    --   cod_filiale,
                    cod_filiale_area,
                    UPPER (i.cod_livello),
                    --   UPPER (j.cod_div),
                    cod_abi,
                    flg_nuovo_ingresso,
                    --cod_ndg,
                    --cp.cod_sndg,
                    --g.cod_gruppo_economico,
                    cod_stato_giuridico,
                    CASE
                       WHEN TO_CHAR (DTA_DECORRENZA_STATO, 'yyyy') =
                               SUBSTR (cp.ID_DPER, 1, 4)
                       THEN
                          1
                       ELSE
                          0
                    END                                                    --,
                       --  cod_firma--,
                       --COD_SEGM_IRB
          );


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_BM TO MCRE_USR;
