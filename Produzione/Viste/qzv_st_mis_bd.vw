/* Formatted on 17/06/2014 17:58:58 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BD
(
   COD_SRC,
   ID_DPER,
   DTA_COMPETENZA,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_PRESIDIO,
   COD_SEGM_IRB,
   DTA_INIZIO_STATO,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_CLI_GE,
   COD_GRUPPO_ECONOMICO,
   COD_STATO_GIURIDICO,
   VAL_VANT,
   VAL_GBV,
   VAL_NBV,
   VAL_TOT_INCASSI,
   VAL_GARANZIE_REALI_PERSONALI,
   VAL_GARANZIE_REALI,
   VAL_GARANZIE_IPOTECARIE,
   VAL_GARANZIE_PIGNORATIZIE,
   VAL_GARANZIE_PERSONALI,
   VAL_GARANZIE_ALTRE_ALTRI,
   VAL_GARANZIE_ALTRE,
   VAL_GARANZIE_ALTRI,
   FLG_NDG,
   FLG_GARANZIE_REALI_PERSONALI,
   FLG_GARANZIE_REALI,
   FLG_GARANZIE_IPOTECARIE,
   FLG_GARANZIE_PIGNORATIZIE,
   FLG_GARANZIE_PERSONALI,
   FLG_GARANZIE_ALTRE_ALTRI,
   FLG_GARANZIE_ALTRE,
   FLG_GARANZIE_ALTRI,
   COD_FIRMA,
   FLG_FIRMA
)
AS
   SELECT 'BD' cod_src,
          id_dper,
          dta_competenza,
          cod_stato_rischio,
          CASE
             WHEN cod_stato_rischio = 'S' THEN 'Sofferenze'
             WHEN cod_stato_rischio = 'I' THEN 'Incagli'
             WHEN cod_stato_rischio = 'R' THEN 'Ristrutturati'
             ELSE NULL
          END
             des_stato_rischio,
          cod_filiale_area cod_presidio,
          cod_segm_irb,
          dta_decorrenza_stato dta_inizio_stato,
          cod_abi,
          cod_ndg,
          cod_sndg,
          cod_cli_ge,
          cod_gruppo_economico,
          --stato giuridico prevalente calcolato a livello di clige
          -- substr(max(COD_STATO_GIURIDICO_prev_ndg) over (partition by cod_stato_rischio,id_dper,cod_cli_ge),instr(COD_STATO_GIURIDICO_prev_ndg,'@#@')+3,length(COD_STATO_GIURIDICO_prev_ndg))  COD_STATO_GIURIDICO,
          SUBSTR (
             MAX (COD_STATO_GIURIDICO_prev_ndg)
                OVER (PARTITION BY cod_stato_rischio, id_dper, cod_cli_ge),
               INSTR (
                  MAX (COD_STATO_GIURIDICO_prev_ndg)
                  OVER (PARTITION BY cod_stato_rischio, id_dper, cod_cli_ge),
                  '@#@')
             + 3,
             LENGTH (
                MAX (COD_STATO_GIURIDICO_prev_ndg)
                   OVER (PARTITION BY cod_stato_rischio, id_dper, cod_cli_ge)))
             COD_STATO_GIURIDICO,
          val_vant,
          val_uti_ret val_gbv,
          val_att val_nbv,
          VAL_UTI_FIRMA val_tot_incassi,
          val_garanzie_reali_personali,
          val_garanzie_reali,
          val_garanzie_ipotecarie,
          val_garanzie_pignoratizie,
          val_garanzie_personali,
          val_garanzie_altre_altri,
          val_garanzie_altre,
          val_garanzie_altri,
          flg_ndg,
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
             flg_garanzie_altri,
          --null flg_cmp_drc,
          val_firma cod_firma,
          CASE WHEN VAL_FIRMA != 'FIRMA' THEN 0 ELSE 1 END flg_firma
     FROM (  SELECT SUBSTR (cp.id_dper, 1, 6) id_dper,
                    cp.id_dper dta_competenza,
                    NVL (UPPER (cp.cod_stato_rischio), '#') cod_stato_rischio,
                    cp.cod_abi,
                    cp.cod_ndg,
                    cp.val_firma,
                    COUNT (DISTINCT cp.COD_RAPPORTO) flg_portafoglio,
                    -- ATTENZIONE: andrà poi gestita sulla vista la moltiplicazione delle righe dovuto al val_firma nel livello di dettaglio
                    COUNT (DISTINCT cp.cod_Ndg) flg_ndg,
                    MAX (cp.cod_filiale_area) cod_filiale_area,
                    MAX (cp.COD_SEGM_IRB) cod_segm_irb,
                    MAX (cp.DTA_DECORRENZA_STATO) dta_decorrenza_stato,
                    MAX (cp.cod_sndg) cod_sndg,
                    MAX (NVL (g.cod_gruppo_economico, '#'))
                       cod_gruppo_economico,
                    MAX (
                       CASE
                          WHEN g.cod_gruppo_economico IS NOT NULL
                          THEN
                             g.cod_gruppo_economico
                          ELSE
                             cp.cod_sndg
                       END)
                       cod_cli_ge,
                    --stato giuridico prevalente
                    MAX (x.VAL_PESO || '@#@' || x.COD_STATO_GIURIDICO)
                       COD_STATO_GIURIDICO_prev_ndg,
                    -- ATTENZIONE: se val_firma='FIRMA' inserisco il VAL_UTI_FIRMA nel campo di VAL_TOT_INCASSI
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA' THEN cp.val_vant
                          ELSE 0
                       END)
                       val_vant,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA' THEN cp.val_uti_ret
                          ELSE 0
                       END)
                       val_uti_ret,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA' THEN cp.val_att
                          ELSE 0
                       END)
                       val_att,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA' THEN 0
                          ELSE cp.VAL_UTI_FIRMA
                       END)
                       VAL_UTI_FIRMA,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                               NVL (val_imp_garanzie_personali, 0)
                             + NVL (val_imp_garanzia_ipotecaria, 0)
                             + NVL (val_imp_garanzie_pignoratizie, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_reali_personali,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                               NVL (val_imp_garanzia_ipotecaria, 0)
                             + NVL (val_imp_garanzie_pignoratizie, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_reali,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                             NVL (val_imp_garanzia_ipotecaria, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_ipotecarie,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                             NVL (val_imp_garanzie_pignoratizie, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_pignoratizie,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                             NVL (val_imp_garanzie_personali, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_personali,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                               NVL (val_imp_garanzie_altre, 0)
                             + NVL (val_imp_garanzie_altri, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_altre_altri,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                             NVL (val_imp_garanzie_altre, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_altre,
                    SUM (
                       CASE
                          WHEN VAL_FIRMA != 'FIRMA'
                          THEN
                             NVL (val_imp_garanzie_altri, 0)
                          ELSE
                             0
                       END)
                       val_garanzie_altri
               FROM mcre_own.t_mcres_app_sisba_cp cp,
                    mcre_own.t_mcres_app_sisba s,
                    mcre_own.t_mcre0_app_gruppo_economico g,
                    mcre_own.T_MCRES_CL_STATO_GIURIDICO x
              WHERE     cp.cod_abi = s.cod_abi(+)
                    AND cp.cod_ndg = s.cod_ndg(+)
                    AND cp.id_dper = s.id_dper(+)
                    AND cp.cod_rapporto = s.cod_rapporto_sisba(+)
                    AND cp.cod_sportello = s.cod_filiale_rapporto(+)
                    AND UPPER (cp.cod_stato_rischio) IN ('I', 'S', 'R')
                    --    nota devo gestire il VAL_UTI_FIRMA
                    ----  AND VAL_FIRMA != 'FIRMA'
                    AND cp.id_dper = SYS_CONTEXT ('userenv', 'client_info')
                    AND cp.cod_sndg = g.cod_sndg(+)
                    AND UPPER (cp.COD_STATO_GIURIDICO) =
                           UPPER (x.COD_STATO_GIURIDICO(+))
           GROUP BY SUBSTR (cp.id_dper, 1, 6),
                    cp.id_dper,
                    cp.cod_stato_rischio,
                    cp.cod_abi,
                    cp.cod_ndg,
                    cp.val_firma);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.QZV_ST_MIS_BD TO MCRE_USR;
