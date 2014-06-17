/* Formatted on 17/06/2014 18:10:13 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DOCUMENTI
(
   ID_OBJECT,
   COD_ABI,
   COD_SOCIETA,
   COD_SOA,
   COD_NDG,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_AUT_PROTOC,
   COD_TIPO_DEL_SPESA,
   COD_TIPO_DOCUMENTO,
   COD_PROGRESSIVO,
   COD_STATO,
   COD_ORIGINE,
   VAL_DOC_NAME,
   DTA_INS
)
AS
   SELECT                                                                   --
         d.id_object,
          d.cod_abi,
          s.cod_societa,
          s.cod_soa,
          d.cod_ndg,
          d.cod_pratica,
          d.val_anno_pratica,
          d.cod_aut_protoc,
          d.cod_tipo_del_spesa,
          d.cod_tipo_documento,
          d.cod_progressivo,
          d.cod_stato,
          d.cod_origine,
          d.val_doc_name,
          d.dta_ins
     FROM t_mcres_app_documenti d, t_mcres_cl_sap s
    WHERE 0 = 0 AND d.cod_abi = s.cod_abi(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_DOCUMENTI TO MCRE_USR;
