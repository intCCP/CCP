/* Formatted on 21/07/2014 18:42:00 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DOC_DA_RACC_OLD
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   FLG_GESTIONE,
   COD_FILIALE_PRINCIPALE,
   DTA_PASSAGGIO_SOFF,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_UO_RAPPORTO,
   COD_STATO_RACCOLTA_DOC
)
AS
   SELECT                                                   -- 20131106 VG New
         p.cod_abi,
          p.cod_ndg,
          p.cod_sndg,
          p.cod_uo_pratica,
          p.VAL_ANNO_PRATICA,
          p.cod_pratica,
          p.flg_gestione,
          p.COD_FILIALE_PRINCIPALE,
          p.DTA_PASSAGGIO_SOFF,
          g.desc_nome_controparte,
          i.desc_istituto,
          uo.cod_uo_rapporto,
          NVL (uo.cod_stato_raccolta_doc, 1) cod_stato_raccolta_doc
     FROM V_MCRES_APP_ALERT_NEWSOFFDAVAL p,
          t_mcre0_app_anagrafica_gruppo g,
          t_mcres_app_istituti i,
          (SELECT DISTINCT
                  cod_abi,
                  cod_ndg,
                  cod_uo_rapporto,
                  (SELECT cod_stato_raccolta_doc
                     FROM T_MCRES_APP_RACCOLTA_DOC d
                    WHERE     d.cod_abi = r.cod_abi
                          AND d.cod_ndg = R.COD_NDG
                          AND d.cod_uo_rapporto = r.cod_uo_rapporto)
                     cod_stato_raccolta_doc
             FROM t_mcres_app_rapporti r
            WHERE dta_chiusura_rapp > SYSDATE AND cod_uo_rapporto IS NOT NULL) uo
    WHERE     1 = 1
          AND p.cod_stato_raccolta_doc IN (1, 3)
          AND p.cod_sndg = g.cod_sndg(+)
          AND p.cod_abi = uo.cod_abi
          AND p.cod_ndg = uo.cod_ndg
          AND p.cod_abi = i.cod_abi;
