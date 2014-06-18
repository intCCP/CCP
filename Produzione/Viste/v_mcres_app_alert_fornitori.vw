/* Formatted on 17/06/2014 18:09:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_FORNITORI
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   VAL_ANNO_PRATICA,
   COD_MATR_PRATICA,
   COD_AUTORIZZAZIONE,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   DESC_AFAVORE,
   ALERT,
   COD_TIPO_AUTORIZZAZIONE,
   DESCR_COD_TIPO_AUTORIZZAZIONE,
   VAL_NUMERO_FATTURA,
   VAL_IMPORTO_VALORE,
   DESC_MOTIVO,
   DTA_FATTURA,
   DTA_ATTESA,
   ID_OBJECT_DO,
   ID_OBJECT_AL_TR
)
AS
   SELECT /*+ optimizer_features_enable('10.2.0.3') */
         A."ID_ALERT",
          A."COD_ABI",
          A."COD_NDG",
          A."COD_UO_PRATICA",
          A."VAL_ANNO_PRATICA",
          A."COD_MATR_PRATICA",
          A."COD_AUTORIZZAZIONE",
          A."VAL_AFAVORE_CODFISC",
          A."VAL_AFAVORE_PIVA",
          A."DESC_AFAVORE",
          A."ALERT",
          A."COD_TIPO_AUTORIZZAZIONE",
          A."DESCR_COD_TIPO_AUTORIZZAZIONE",
          A."VAL_NUMERO_FATTURA",
          A."VAL_IMPORTO_VALORE",
          A."DESC_MOTIVO",
          A."DTA_FATTURA",
          A."DTA_ATTESA",
          b.id_object AS id_object_do,
          c.id_object AS id_object_al_tr
     FROM (SELECT                           --20121025      AG  Nuova versione
                  --20121107      AP  Aggiunta join con cl_tipo_autorizzazione
                  --20130122      AG  Descriozione motivo scarto
                  --20130311     VG cod_ndg
                  --20130408     VG
                  --20130902     VG  attive union chiuse
                  23 id_alert,
                  s.cod_abi,
                  s.cod_ndg,
                  p.cod_uo_pratica,
                  s.val_anno_pratica,
                  p.cod_matr_pratica,
                  cod_autorizzazione,
                  s.val_afavore_codfisc,
                  s.val_afavore_piva,
                  s.desc_afavore,
                  CASE
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) <=
                             g.val_current_green
                     THEN
                        'V'
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) BETWEEN   g.val_current_green
                                                                        + 1
                                                                    AND g.val_current_orange
                     THEN
                        'A'
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) >
                             g.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     alert,
                  s.cod_tipo_autorizzazione,
                  aut.desc_autorizzazione descr_cod_tipo_autorizzazione,
                  s.val_numero_fattura,
                  s.val_importo_valore,
                  CASE
                     WHEN flg_fornitore_non_censito = 1
                     THEN
                        'Fornitore non censito'
                     WHEN flg_fornitore_non_censito = 2
                     THEN
                        'Fornitore non attivato'
                  END
                     desc_motivo,
                  s.dta_fattura,
                  s.dta_attesa
             FROM t_mcres_app_spese_itf s,
                  t_mcres_app_pratiche p,
                  t_mcres_cl_tipo_autorizzazione aut,
                  t_mcres_app_gestione_alert g
            WHERE     p.flg_attiva = 1
                  AND s.cod_abi = p.cod_abi
                  AND s.cod_ndg = p.cod_ndg
                  AND s.val_anno_pratica = p.val_anno
                  AND s.cod_pratica = p.cod_pratica
                  AND flg_fornitore_non_censito != 0
                  AND aut.cod_tipo(+) = s.cod_tipo_autorizzazione
                  AND g.id_alert = 23
           UNION
           SELECT                           --20121025      AG  Nuova versione
                  --20121107      AP  Aggiunta join con cl_tipo_autorizzazione
                  --20130122      AG  Descriozione motivo scarto
                  --20130311     VG cod_ndg
                  --20130408     VG
                  --20130902     VG  attive union chiuse
                  23 id_alert,
                  s.cod_abi,
                  s.cod_ndg,
                  p.cod_uo_pratica,
                  s.val_anno_pratica,
                  p.cod_matr_pratica,
                  cod_autorizzazione,
                  s.val_afavore_codfisc,
                  s.val_afavore_piva,
                  s.desc_afavore,
                  CASE
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) <=
                             g.val_current_green
                     THEN
                        'V'
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) BETWEEN   g.val_current_green
                                                                        + 1
                                                                    AND g.val_current_orange
                     THEN
                        'A'
                     WHEN (TRUNC (SYSDATE) - TRUNC (s.dta_ins)) >
                             g.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     alert,
                  s.cod_tipo_autorizzazione,
                  aut.desc_autorizzazione descr_cod_tipo_autorizzazione,
                  s.val_numero_fattura,
                  s.val_importo_valore,
                  CASE
                     WHEN flg_fornitore_non_censito = 1
                     THEN
                        'Fornitore non censito'
                     WHEN flg_fornitore_non_censito = 2
                     THEN
                        'Fornitore non attivato'
                  END
                     desc_motivo,
                  s.dta_fattura,
                  s.dta_attesa
             FROM t_mcres_app_spese_itf s,
                  t_mcres_app_pratiche p,
                  t_mcres_cl_tipo_autorizzazione aut,
                  t_mcres_app_gestione_alert g
            WHERE     p.flg_attiva = 0
                  AND s.cod_abi = p.cod_abi
                  AND s.cod_ndg = p.cod_ndg
                  AND s.val_anno_pratica = p.val_anno
                  AND s.cod_pratica = p.cod_pratica
                  AND flg_fornitore_non_censito != 0
                  AND aut.cod_tipo(+) = s.cod_tipo_autorizzazione
                  AND g.id_alert = 23) A
          LEFT JOIN
          t_mcres_app_documenti B
             ON (    a.cod_autorizzazione = b.cod_identificativo
                 AND b.cod_tipo_documento = 'DO')
          LEFT JOIN
          t_mcres_app_documenti C
             ON (    a.cod_autorizzazione = c.cod_Aut_protoc
                 AND c.cod_tipo_documento = 'AL'
                 AND c.cod_stato = 'TR');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_FORNITORI TO MCRE_USR;
