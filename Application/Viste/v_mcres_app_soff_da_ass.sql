/* Formatted on 21/07/2014 18:43:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SOFF_DA_ASS
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   VAL_ANNO,
   COD_PRATICA,
   VAL_GBV,
   VAL_DUBBIO,
   FLG_RAPP_FONDO_TERZO,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   ALERT,
   FLG_GESTIONE,
   DTA_PASSAGGIO_SOFF
)
AS
     SELECT                         -- 20131106 VG aggiunto campo val_gestione
           5 id_alert,
            p.cod_abi,
            p.cod_ndg,
            p.cod_sndg,
            r.cod_uo_pratica,
            r.val_anno,
            r.cod_pratica,
            SUM (-1 * z.val_imp_gbv) val_gbv,
            --ROUND (SUM (-1 * z.val_imp_nbv/ DECODE (NVL (-1 * z.val_imp_gbv, 1),  0, 1, -1 * val_imp_gbv)),2) val_dubbio,
            ROUND (SUM (-z.val_imp_nbv) / SUM (NULLIF (-z.val_imp_gbv, 0)), 2)
               val_dubbio,
            z.flg_rapp_fondo_terzo,
            g.desc_nome_controparte,
            i.desc_istituto,
            CASE
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff <=
                       ga.val_current_green
               THEN
                  'V'
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff BETWEEN   ga.val_current_green
                                                                   + 1
                                                               AND ga.val_current_orange
               THEN
                  'A'
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff >
                       ga.val_current_orange
               THEN
                  'R'
               ELSE
                  'X'
            END
               alert,
            r.flg_gestione,
            p.dta_passaggio_soff
       FROM t_mcres_app_posizioni p,
            t_mcres_app_pratiche r,
            t_mcres_app_rapporti z,
            t_mcre0_app_anagrafica_gruppo g,
            t_mcres_app_istituti i,
            t_mcres_app_gestione_alert ga
      WHERE     0 = 0
            AND ga.id_alert = 5
            AND p.flg_attiva = 1
            AND r.flg_attiva = 1
            AND p.cod_abi = r.cod_abi
            AND p.cod_ndg = r.cod_ndg
            AND p.cod_abi = z.cod_abi(+)
            AND p.cod_ndg = z.cod_ndg(+)
            AND r.cod_matr_pratica IS NULL
            AND p.cod_sndg = g.cod_sndg(+)
            AND p.cod_abi = i.cod_abi
   GROUP BY p.cod_abi,
            p.cod_ndg,
            p.cod_sndg,
            r.cod_uo_pratica,
            r.val_anno,
            r.cod_pratica,
            flg_rapp_fondo_terzo,
            g.desc_nome_controparte,
            i.desc_istituto,
            CASE
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff <=
                       ga.val_current_green
               THEN
                  'V'
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff BETWEEN   ga.val_current_green
                                                                   + 1
                                                               AND ga.val_current_orange
               THEN
                  'A'
               WHEN TRUNC (SYSDATE) - p.dta_passaggio_soff >
                       ga.val_current_orange
               THEN
                  'R'
               ELSE
                  'X'
            END,
            r.flg_gestione,
            p.dta_passaggio_soff;
