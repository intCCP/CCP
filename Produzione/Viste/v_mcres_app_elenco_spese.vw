/* Formatted on 17/06/2014 18:10:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCO_SPESE
(
   COD_ABI,
   COD_NDG,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   COD_AUTORIZZAZIONE,
   COD_TIPO_AUTORIZZAZIONE,
   COD_IMPORTO_DIVISA,
   DTA_INS_SPESA,
   VAL_NUMERO_FATTURA,
   COD_SPESA,
   COD_STATO,
   VAL_IMPORTO,
   DESC_INTESTATARIO,
   DTA_AUTORIZZAZIONE,
   FLG_CONVENZIONE,
   DTA_STORNO_CONTABILE,
   VAL_NUM_PROFORMA,
   DTA_FATTURA,
   COD_AUTORIZZAZIONE_PADRE,
   COD_PROTOCOLLO,
   DTA_INVIO_PAGAMENTO,
   FLG_UO_DIVERSA,
   FLG_SOURCE,
   COD_CAUSALE,
   DTA_PAGAMENTO_SAP,
   DTA_PROFORMA_A_FATTURA,
   ID_OBJECT_DO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO,
   ID_OBJECT_AL_AN,
   FLG_PREAUTORIZZATO
)
AS
   SELECT                                                     -- ap 05/11/2012
          -- ag 14/01/2013
          -- VG 20130913 pag_sap
          -- AP 20131210 aggiunto campo dta_pagamento da sap (nuova join con pag sap)
          -- AP  20140124 aggiunto campo dta_proforma_a_fattura
          a."COD_ABI",
          a."COD_NDG",
          a."COD_PRATICA",
          a."VAL_ANNO_PRATICA",
          a."COD_AUTORIZZAZIONE",
          a."COD_TIPO_AUTORIZZAZIONE",
          a."COD_IMPORTO_DIVISA",
          a."DTA_INS_SPESA",
          a."VAL_NUMERO_FATTURA",
          a."COD_SPESA",
          a."COD_STATO",
          a."VAL_IMPORTO",
          a."DESC_INTESTATARIO",
          a."DTA_AUTORIZZAZIONE",
          a."FLG_CONVENZIONE",
          a."DTA_STORNO_CONTABILE",
          a."VAL_NUM_PROFORMA",
          a."DTA_FATTURA",
          a."COD_AUTORIZZAZIONE_PADRE",
          a."COD_PROTOCOLLO",
          a."DTA_INVIO_PAGAMENTO",
          a."FLG_UO_DIVERSA",
          a."FLG_SOURCE",
          a."COD_CAUSALE",
          a."DTA_PAGAMENTO_SAP",
          a."DTA_PROFORMA_A_FATTURA",
          b.id_object AS id_object_do,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co,
          e.id_object AS id_object_al_an,
          DECODE (itf.cod_stato, 'P', 1, 0) flg_preautorizzato
     FROM (SELECT            ------------   nb:   solo application - no system
                 sp.cod_abi,
                  (SELECT cod_ndg
                     FROM t_mcres_app_pratiche pr
                    WHERE     pr.cod_abi = sp.cod_abi
                          AND pr.cod_pratica = sp.cod_pratica
                          AND pr.val_anno = sp.val_anno_pratica)
                     cod_ndg,
                  sp.cod_pratica,
                  sp.val_anno_pratica,
                  sp.cod_autorizzazione,
                  sp.cod_tipo_autorizzazione,
                  sp.cod_importo_divisa,
                  sp.dta_ins_spesa,
                  sp.val_numero_fattura,
                     sp.val_numero_fattura
                  || ' '
                  || sp.cod_autorizzazione
                  || ' '
                  || sp.dta_autorizzazione
                     AS "COD_SPESA",
                  DECODE (sp.COD_STATO,
                          'P', 'IM',
                          'A', 'CO',
                          'D', 'DE',
                          'X', 'AN',
                          sp.COD_STATO)
                     COD_STATO,
                  sp.val_importo_valore AS val_importo,
                  sp.desc_intestatario AS desc_intestatario,
                  sp.dta_autorizzazione,
                  sp.flg_convenzione,
                  sp.dta_storno_contabile,
                  sp.val_num_proforma,
                  sp.dta_fattura,
                  sp.cod_autorizzazione_padre,                ---ag 12/03/2012
                  sp.cod_protocollo,                           --ap 02/10/2012
                  sp.dta_invio_pagamento,                      --ag 14/01/2013
                  NVL (
                     (SELECT DISTINCT 1
                        FROM t_mcres_app_sp_spese ee
                       WHERE     sp.cod_autorizzazione_padre =
                                    ee.cod_autorizzazione_padre
                             AND ee.cod_uo_pratica != sp.cod_uo_pratica),
                     0)
                     flg_uo_diversa,
                  sp.flg_source,
                  sp.cod_causale,
                  sap.dta_pagamento dta_pagamento_sap,
                  sp.DTA_PROFORMA_A_FATTURA
             FROM t_mcres_app_sp_spese sp
                  LEFT JOIN t_mcres_app_pag_sap sap
                     ON (sp.cod_autorizzazione = sap.cod_autorizzazione)
            WHERE NOT EXISTS
                         (SELECT DISTINCT 1
                            FROM t_mcres_app_sp_spese e
                           WHERE e.cod_autorizzazione_padre =
                                    sp.cod_autorizzazione -- ap 05/11/2012 aggiunte join per id_object
                                                         )) a
          LEFT JOIN
          t_mcres_app_documenti b
             ON (    NVL (a.cod_autorizzazione_padre, a.cod_autorizzazione) =
                        b.cod_identificativo
                 AND b.cod_tipo_documento = 'DO')
          LEFT JOIN
          t_mcres_app_documenti c
             ON (    a.cod_autorizzazione = c.cod_aut_protoc
                 AND c.cod_tipo_documento = 'AL'
                 AND c.cod_stato = 'TR')
          LEFT JOIN
          t_mcres_app_documenti d
             ON (    a.cod_autorizzazione = d.cod_aut_protoc
                 AND d.cod_tipo_documento = 'AL'
                 AND d.cod_stato = 'CO')
          LEFT JOIN
          t_mcres_app_documenti e
             ON (    a.cod_autorizzazione = e.cod_aut_protoc
                 AND e.cod_tipo_documento = 'AL'
                 AND e.cod_stato = 'AN')
          LEFT JOIN t_mcres_app_spese_itf itf
             ON (a.cod_autorizzazione = itf.cod_autorizzazione);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ELENCO_SPESE TO MCRE_USR;
