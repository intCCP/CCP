/* Formatted on 17/06/2014 18:11:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_TO_DOC_PDF_ITF
(
   COD_ABI,
   COD_NDG,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_AUTORIZZAZIONE,
   COD_AUTORIZZAZIONE_PADRE,
   COD_TIPO_AUTORIZZAZIONE,
   COD_STATO,
   VAL_DOC_NAME,
   COD_TIPO_DOCUMENTO,
   BLOB_PDF_CONTENT
)
AS
   SELECT                                --  20121029    AG  Creatad this view
                          --  20121105    AG  Aggiunto cammpo blob_pdf_content
 --  20121106    AG  Aggiunta decodifia dello stato e modificata logica di estrazione
 --                                                              (flg_docs_archiviati = 0 and flg_calcolato_uo_od = 1 and flg_fornitore_non_censito = 0)
 --  20121119    AG  Rimossso controllo sul caclolo di UO e OD e rimossa decodifica dello stato
                               --  20130308    AG  Aggiunto cod_tipo_documento
                            --  20130409    AG  Rimosso controllo su fornitore
  --  20130410    AG  Sostituita tabella esterna con t_mcres_wrk_pdf_spese_itf
         l.cod_abi,
         l.cod_ndg,
         l.cod_pratica,
         l.val_anno_pratica,
         l.cod_autorizzazione,
         l.cod_autorizzazione_padre,
         l.cod_tipo_autorizzazione,
         --l.cod_stato,
         'TR' cod_stato,
         l.val_doc_name,
         l.cod_tipo_documento,
         t.blob_pdf_content
    FROM (SELECT cod_abi,
                 cod_ndg,
                 cod_pratica,
                 val_anno_pratica,
                 cod_autorizzazione,
                 cod_autorizzazione_padre,
                 cod_tipo_autorizzazione,
                 cod_stato,
                 desc_file_nosta val_doc_name,
                 cod_uo_proposto,
                 cod_uo_calcolato,
                 'AL' cod_tipo_documento
            FROM t_mcres_app_spese_itf app
           WHERE     0 = 0
                 AND flg_docs_archiviati = 0
                 --            and flg_fornitore_non_censito = 0
                 AND NOT EXISTS
                            (SELECT 1
                               FROM t_mcres_app_documenti d
                              WHERE     0 = 0
                                    AND app.cod_abi = d.cod_abi
                                    AND app.cod_ndg = d.cod_ndg
                                    AND app.cod_autorizzazione =
                                           d.cod_aut_protoc
                                    AND d.cod_tipo_documento = 'AL')
          UNION ALL
          SELECT cod_abi,
                 cod_ndg,
                 cod_pratica,
                 val_anno_pratica,
                 cod_autorizzazione,
                 cod_autorizzazione_padre,
                 cod_tipo_autorizzazione,
                 cod_stato,
                 desc_file_fatt val_doc_name,
                 cod_uo_proposto,
                 cod_uo_calcolato,
                 'DO' cod_tipo_documento
            FROM t_mcres_app_spese_itf app
           WHERE     0 = 0
                 AND flg_docs_archiviati = 0
                 --            and flg_fornitore_non_censito = 0
                 AND NOT EXISTS
                            (SELECT 1
                               FROM t_mcres_app_documenti d
                              WHERE     0 = 0
                                    AND app.cod_abi = d.cod_abi
                                    AND app.cod_ndg = d.cod_ndg
                                    AND app.cod_autorizzazione =
                                           d.cod_aut_protoc
                                    AND d.cod_tipo_documento = 'DO')) l,
         t_mcres_wrk_pdf_spese_itf t
   WHERE 0 = 0 AND l.val_doc_name = t.val_pdf_filename;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_TO_DOC_PDF_ITF TO MCRE_USR;
