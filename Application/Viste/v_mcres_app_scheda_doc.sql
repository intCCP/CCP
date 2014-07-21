/* Formatted on 21/07/2014 18:42:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SCHEDA_DOC
(
   COD_ABI,
   COD_NDG,
   COD_UO_RAPPORTO,
   ID_DOCUMENTO,
   VAL_NOTE_FILIALE,
   FLG_CONFORME,
   VAL_NOTE_PRESIDIO,
   FLG_INVIO,
   DTA_INVIO,
   DTA_COMPLETAMENTO,
   COD_MATR_PRATICA,
   FLG_DISPONIBILE,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   COD_FILIALE_PRINCIPALE,
   FLG_GESTIONE,
   DESC_DOCUMENTO,
   COD_STATO_RACCOLTA_DOC
)
AS
   SELECT s."COD_ABI",
          s."COD_NDG",
          s."COD_UO_RAPPORTO",
          s."ID_DOCUMENTO",
          s."VAL_NOTE_FILIALE",
          s."FLG_CONFORME",
          s."VAL_NOTE_PRESIDIO",
          s."FLG_INVIO",
          s."DTA_INVIO",
          s."DTA_COMPLETAMENTO",
          s."COD_MATR_PRATICA",
          s."FLG_DISPONIBILE",
          i.desc_istituto,
          g.desc_nome_controparte,
          p.COD_FILIALE_PRINCIPALE,
          pr.flg_gestione,
          (SELECT DESC_DOCUMENTO
             FROM T_MCRES_CL_DOCUMENTI d
            WHERE d.id_documento = s.id_documento)
             DESC_DOCUMENTO,
          NVL (
             (SELECT cod_stato_raccolta_doc
                FROM t_mcres_app_raccolta_doc d
               WHERE     d.cod_abi = s.cod_abi
                     AND d.cod_ndg = s.cod_ndg
                     AND d.cod_uo_rapporto = s.cod_uo_rapporto),
             0)
             cod_stato_raccolta_doc
     FROM (SELECT COD_ABI,
                  COD_NDG,
                  COD_UO_RAPPORTO,
                  ID_DOCUMENTO,
                  VAL_NOTE_FILIALE,
                  FLG_CONFORME,
                  VAL_NOTE_PRESIDIO,
                  FLG_INVIO,
                  DTA_INVIO,
                  DTA_COMPLETAMENTO,
                  COD_MATR_PRATICA,
                  FLG_DISPONIBILE
             FROM t_mcres_app_scheda_doc
           UNION
           SELECT ss.COD_ABI,
                  ss.COD_NDG,
                  ss.COD_UO_RAPPORTO,
                  NULL ID_DOCUMENTO,
                  NULL VAL_NOTE_FILIALE,
                  NULL FLG_CONFORME,
                  NULL VAL_NOTE_PRESIDIO,
                  NULL FLG_INVIO,
                  NULL DTA_INVIO,
                  NULL DTA_COMPLETAMENTO,
                  NULL COD_MATR_PRATICA,
                  NULL FLG_DISPONIBILE
             FROM V_MCRES_APP_ALERT_DOC_DA_RACC ss
            WHERE NVL (cod_stato_raccolta_doc, 0) IN (0, 1)) s,
          t_mcres_app_istituti i,
          t_mcre0_app_anagrafica_gruppo g,
          t_mcres_app_posizioni p,
          t_mcres_app_pratiche pr
    WHERE     p.flg_attiva = 1
          AND pr.flg_attiva = 1
          AND s.cod_abi = pr.cod_abi
          AND s.cod_ndg = pr.cod_ndg
          AND s.cod_abi = p.cod_abi
          AND s.cod_ndg = p.cod_ndg
          AND s.cod_abi = i.cod_abi(+)
          AND pr.cod_sndg = g.cod_sndg(+);
