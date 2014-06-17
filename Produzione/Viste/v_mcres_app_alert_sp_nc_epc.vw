/* Formatted on 17/06/2014 18:09:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SP_NC_EPC
(
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   FLG_ATTIVA,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   INTESTAZIONE,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA,
   VAL_IMPORTO_VALORE,
   DTA_UPD,
   COD_AUTORIZZAZIONE,
   VAL_ADDETTO,
   ID_OBJECT_DO
)
AS
   SELECT A."COD_PRATICA",
          A."VAL_ANNO_PRATICA",
          A."FLG_ATTIVA",
          A."COD_UO_PRATICA",
          A."COD_MATR_PRATICA",
          A."COD_ABI",
          A."DESC_ISTITUTO",
          A."COD_NDG",
          A."DESC_NOME_CONTROPARTE",
          A."INTESTAZIONE",
          A."VAL_NUMERO_FATTURA",
          A."DTA_FATTURA",
          A."VAL_IMPORTO_VALORE",
          A."DTA_UPD",
          A."COD_AUTORIZZAZIONE",
          A."VAL_ADDETTO",
          b.id_object AS id_object_do
     FROM (SELECT sp.cod_pratica,
                  sp.val_anno_pratica,
                  sp.flg_attiva,
                  sp.cod_uo_pratica,
                  sp.cod_matr_pratica,
                  sp.cod_abi,
                  ist.desc_istituto,
                  sp.cod_ndg,
                  ag.desc_nome_controparte,
                  sp.val_riferimento_nominativo AS intestazione,
                  sp.val_numero_fattura,
                  sp.dta_fattura,
                  sp.val_importo_valore,
                  sp.dta_upd,
                  sp.cod_autorizzazione,
                  us.cognome || ' ' || us.nome AS val_addetto
             FROM (SELECT pr.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.val_anno_pratica,
                          sp.cod_tipo_autorizzazione,
                          sp.cod_stato,
                          sp.cod_id_legale,
                          sp.desc_intestatario,
                          sp.val_riferimento_nominativo,
                          pr.flg_attiva,
                          sp.dta_upd
                     FROM t_mcres_app_sp_spese sp, t_mcres_app_pratiche pr
                    WHERE     0 = 0
                          AND sp.cod_abi = pr.cod_abi
                          AND TO_NUMBER (sp.val_anno_pratica) = pr.val_anno
                          AND sp.cod_pratica = pr.cod_pratica
                          AND sp.cod_stato = 'NC'
                          AND sp.flg_source = 'EPC') sp
                  JOIN t_mcres_app_istituti ist ON (ist.cod_abi = sp.cod_abi)
                  LEFT JOIN t_mcre0_app_anagrafica_gruppo ag
                     ON (ag.cod_sndg = sp.cod_sndg)
                  LEFT JOIN t_mcres_app_utenti us
                     ON (us.cod_matricola = sp.cod_matr_pratica)
                  LEFT JOIN t_mcres_cl_tipo_autorizzazione aut
                     ON (aut.cod_tipo = sp.cod_tipo_autorizzazione)
                  LEFT JOIN v_mcres_app_lista_presidi lp
                     ON (lp.cod_presidio = sp.cod_uo_pratica)) A
          LEFT JOIN
          t_mcres_app_documenti B
             ON (    a.cod_autorizzazione = b.cod_identificativo
                 AND b.cod_tipo_documento = 'DO');


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ALERT_SP_NC_EPC TO MCRE_USR;
