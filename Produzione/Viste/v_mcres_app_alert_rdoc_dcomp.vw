/* Formatted on 17/06/2014 18:09:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_RDOC_DCOMP
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   COD_MATR_PRATICA,
   FLG_GESTIONE,
   COD_FILIALE_PRINCIPALE,
   DTA_PASSAGGIO_SOFF,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_UO_RAPPORTO,
   COD_STATO_RACCOLTA_DOC,
   ALERT,
   FLG_URGENTE
)
AS
   SELECT            -- AP 13/05/2014 alert Raccolta documentale da completare
         ga.id_alert,
          p.cod_abi,
          p.cod_ndg,
          p.cod_sndg,
          p.cod_uo_pratica,
          p.VAL_ANNO_PRATICA,
          p.cod_pratica,
          p.cod_matr_pratica,
          p.flg_gestione,
          p.COD_FILIALE_PRINCIPALE,
          p.DTA_PASSAGGIO_SOFF,
          g.desc_nome_controparte,
          i.desc_istituto,
          uo.cod_uo_rapporto,
          NVL (uo.cod_stato_raccolta_doc, 0) cod_stato_raccolta_doc,
          CASE
             WHEN UO.FLG_URGENTE = 1
             THEN
                'R'
             WHEN ( (TRUNC (SYSDATE) - dta_passaggio_soff) BETWEEN 0
                                                               AND ga.val_current_green)
             THEN
                'V'
             WHEN ( (TRUNC (SYSDATE) - dta_passaggio_soff) BETWEEN   ga.val_current_green
                                                                   + 1
                                                               AND ga.val_current_orange)
             THEN
                'A'
             WHEN ( (TRUNC (SYSDATE) - dta_passaggio_soff) >
                      ga.val_current_orange)
             THEN
                'R'
             ELSE
                'X'
          END
             alert,
          uo.flg_urgente
     FROM (SELECT p.cod_abi,
                  p.cod_ndg,
                  z.cod_sndg,
                  p.cod_matr_pratica,
                  dta_passaggio_soff,
                  p.cod_pratica,
                  p.VAL_ANNO val_anno_pratica,
                  p.cod_uo_pratica,
                  z.cod_filiale_principale,
                  p.flg_gestione,
                  1 cod_stato_raccolta_doc
             FROM t_mcres_app_pratiche p, t_mcres_app_posizioni z
            WHERE     0 = 0
                  AND p.flg_attiva = 1
                  AND z.flg_attiva = 1
                  AND p.cod_abi = z.cod_abi
                  AND p.cod_ndg = z.cod_ndg
                  AND z.dta_passaggio_soff BETWEEN (SELECT TO_DATE (
                                                              valore_costante,
                                                              'YYYYMMDD')
                                                      FROM T_MCRES_WRK_CONFIGURAZIONE
                                                     WHERE nome_costante =
                                                              'INIZIO_RACCOLTA_DOCUMENTALE')
                                               AND   z.dta_passaggio_soff
                                                   + (SELECT valore_costante
                                                        FROM T_MCRES_WRK_CONFIGURAZIONE
                                                       WHERE nome_costante =
                                                                'USCITA_RACCOLTA_DOCUMENTALE')
                  AND EXISTS
                         (SELECT DISTINCT 1
                            FROM t_mcres_app_raccolta_doc s
                           WHERE     cod_stato_raccolta_doc IN (0, 1)
                                 AND s.cod_abi = p.cod_abi
                                 AND s.cod_ndg = p.cod_ndg)) p,
          t_mcre0_app_anagrafica_gruppo g,
          t_mcres_app_istituti i,
          (SELECT *
             FROM t_mcres_app_gestione_alert
            WHERE id_alert = 42) ga,
          (SELECT DISTINCT r.cod_abi,
                           r.cod_ndg,
                           r.cod_uo_rapporto,
                           d.cod_stato_raccolta_doc,
                           d.flg_urgente
             FROM t_mcres_app_rapporti r
                  LEFT JOIN
                  T_MCRES_APP_RACCOLTA_DOC d
                     ON (    d.cod_abi = r.cod_abi
                         AND d.cod_ndg = R.COD_NDG
                         AND d.cod_uo_rapporto = r.cod_uo_rapporto)
            WHERE r.cod_uo_rapporto IS NOT NULL) uo
    WHERE     1 = 1
          AND p.cod_sndg = g.cod_sndg
          AND p.cod_abi = uo.cod_abi
          AND p.cod_ndg = uo.cod_ndg
          AND p.cod_abi = i.cod_abi
          AND uo.cod_Stato_Raccolta_doc IN (0, 1);


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ALERT_RDOC_DCOMP TO MCRE_USR;
