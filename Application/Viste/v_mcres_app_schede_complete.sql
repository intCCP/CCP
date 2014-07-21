/* Formatted on 21/07/2014 18:42:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SCHEDE_COMPLETE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   VAL_ANNO,
   COD_PRATICA,
   FLG_GESTIONE,
   COD_FILIALE_PRINCIPALE,
   DESC_NOME_CONTROPARTE,
   DESC_ISTITUTO,
   COD_UO_RAPPORTO,
   COD_STATO_RACCOLTA_DOC,
   DESC_DOCUMENTO,
   FLG_CONFORME,
   ID_DOCUMENTO,
   VAL_NOTE_FILIALE,
   VAL_NOTE_PRESIDIO
)
AS
   SELECT                                                   -- 20131106 VG New
         p.cod_abi,
          p.cod_ndg,
          p.cod_sndg,
          r.cod_uo_pratica,
          r.val_anno,
          r.cod_pratica,
          r.flg_gestione,
          p.COD_FILIALE_PRINCIPALE,
          g.desc_nome_controparte,
          i.desc_istituto,
          s.cod_uo_rapporto,
          s.cod_stato_raccolta_doc,
          (SELECT DESC_DOCUMENTO
             FROM T_MCRES_CL_DOCUMENTI d
            WHERE d.id_documento = ss.id_documento)
             DESC_DOCUMENTO,
          FLG_CONFORME,
          ID_DOCUMENTO,
          VAL_NOTE_FILIALE,
          VAL_NOTE_PRESIDIO
     FROM t_mcres_app_posizioni p,
          t_mcres_app_pratiche r,
          t_mcres_app_raccolta_doc s,
          t_mcres_app_scheda_doc ss,
          t_mcre0_app_anagrafica_gruppo g,
          t_mcres_app_istituti i
    WHERE     p.flg_attiva = 1
          AND r.flg_attiva = 1
          AND p.cod_abi = r.cod_abi
          AND p.cod_ndg = r.cod_ndg
          AND p.cod_abi = s.cod_abi
          AND p.cod_ndg = s.cod_ndg
          AND s.cod_stato_raccolta_doc = 4
          AND s.cod_abi = ss.cod_abi
          AND s.cod_ndg = ss.cod_ndg
          AND s.cod_uo_rapporto = ss.cod_uo_rapporto
          AND ss.dta_completamento >= dta_invio
          AND p.cod_sndg = g.cod_sndg(+)
          AND p.cod_abi = i.cod_abi;
