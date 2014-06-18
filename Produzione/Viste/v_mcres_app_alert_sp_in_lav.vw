/* Formatted on 17/06/2014 18:09:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SP_IN_LAV
(
   ID_ALERT,
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_PRATICA,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA,
   INTESTAZIONE,
   VAL_IMPORTO_VALORE,
   COD_AUTORIZZAZIONE,
   DTA_UPD_SPESA,
   DESC_NOME_GESTORE,
   FLG_CONFERIMENTO,
   ALERT,
   VAL_ANNO_PRATICA,
   COD_PROTOCOLLO,
   COD_TIPO_AUTORIZZAZIONE,
   DESCR_COD_TIPO_AUTORIZZAZIONE,
   COD_AUTORIZZAZIONE_PADRE,
   DTA_INS_SPESA,
   FLG_ATTIVA,
   COD_MATRICOLA,
   ID_OBJECT_DO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT A."ID_ALERT",
          A."COD_ABI",
          A."DESC_ISTITUTO",
          A."COD_NDG",
          A."COD_SNDG",
          A."DESC_NOME_CONTROPARTE",
          A."COD_PRATICA",
          A."COD_UO_PRATICA",
          A."COD_MATR_PRATICA",
          A."VAL_NUMERO_FATTURA",
          A."DTA_FATTURA",
          A."INTESTAZIONE",
          A."VAL_IMPORTO_VALORE",
          A."COD_AUTORIZZAZIONE",
          A."DTA_UPD_SPESA",
          A."DESC_NOME_GESTORE",
          A."FLG_CONFERIMENTO",
          A."ALERT",
          A."VAL_ANNO_PRATICA",
          A."COD_PROTOCOLLO",
          A."COD_TIPO_AUTORIZZAZIONE",
          A."DESCR_COD_TIPO_AUTORIZZAZIONE",
          A."COD_AUTORIZZAZIONE_PADRE",
          A."DTA_INS_SPESA",
          A."FLG_ATTIVA",
          A."COD_MATRICOLA",
          b.id_object AS id_object_do,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co
     FROM (SELECT 15 AS id_alert,
                  sp.cod_abi,
                  ist.desc_istituto,
                  sp.cod_ndg,
                  sp.cod_sndg,
                  ag.desc_nome_controparte,
                  sp.cod_pratica,
                  sp.cod_uo_pratica,
                  sp.cod_matr_pratica,
                  sp.val_numero_fattura,
                  sp.dta_fattura,
                  NVL (lg.intestazione, sp.desc_intestatario) intestazione,
                  sp.val_importo_valore,
                  sp.cod_autorizzazione,
                  sp.dta_upd_spesa,
                  us.cognome || ' ' || us.nome AS desc_nome_gestore,
                  CASE
                     WHEN nt.cod_abi || nt.cod_ndg IS NULL THEN 0
                     ELSE 1
                  END
                     flg_conferimento,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_ins_spesa) <=
                             gest.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_ins_spesa) BETWEEN   gest.val_current_green
                                                                             + 1
                                                                         AND gest.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_ins_spesa) >
                             gest.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert,
                  sp.val_anno_pratica,
                  sp.cod_protocollo,
                  sp.cod_tipo_autorizzazione,
                  aut.desc_autorizzazione descr_cod_tipo_autorizzazione,
                  sp.cod_Autorizzazione_padre,
                  sp.dta_ins_spesa,
                  sp.flg_attiva,
                  sp.cod_matricola
             FROM (SELECT sp.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_upd_spesa,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.cod_Autorizzazione_padre,
                          sp.dta_ins_spesa,
                          sp.cod_id_legale,
                          sp.desc_intestatario,
                          pr.flg_attiva,
                          sp.cod_matricola
                     FROM t_mcres_app_sp_spese sp
                          JOIN
                          t_mcres_app_pratiche pr
                             ON (    sp.cod_abi = pr.cod_abi
                                 AND sp.val_anno_pratica =
                                        TO_CHAR (pr.val_anno)
                                 AND sp.cod_pratica = pr.cod_pratica)
                    WHERE     0 = 0
                          AND pr.flg_attiva = 1
                          AND sp.cod_stato IN ('IN')
                   UNION
                   SELECT sp.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_upd_spesa,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.cod_Autorizzazione_padre,
                          sp.dta_ins_spesa,
                          sp.cod_id_legale,
                          sp.desc_intestatario,
                          pr.flg_attiva,
                          sp.cod_matricola
                     FROM t_mcres_app_sp_spese sp
                          JOIN
                          t_mcres_app_pratiche pr
                             ON (    sp.cod_abi = pr.cod_abi
                                 AND sp.val_anno_pratica =
                                        TO_CHAR (pr.val_anno)
                                 AND sp.cod_pratica = pr.cod_pratica)
                    WHERE     0 = 0
                          AND pr.flg_attiva = 0
                          AND sp.cod_stato IN ('IN')) sp
                  JOIN t_mcres_app_istituti ist ON (ist.cod_abi = sp.cod_abi)
                  LEFT JOIN t_mcre0_app_anagrafica_gruppo ag
                     ON (ag.cod_sndg = sp.cod_sndg)
                  LEFT JOIN t_mcres_app_utenti us
                     ON (us.cod_matricola = sp.cod_matr_pratica)
                  LEFT JOIN v_mcres_app_sp_legali_esterni lg
                     ON (lg.id_legale = sp.cod_id_legale)
                  LEFT JOIN v_mcres_app_conferimento_nt nt
                     ON (nt.cod_abi = sp.cod_abi AND nt.cod_ndg = sp.cod_ndg)
                  LEFT JOIN t_mcres_cl_tipo_autorizzazione aut
                     ON (aut.cod_tipo = sp.cod_tipo_autorizzazione)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest
                     ON (gest.id_alert = 15)
            WHERE     0 = 0
                  -- SE FATTURA MULTIPLA PRENDE SOLO LE SPESE FIGLIE
                  AND CASE
                         WHEN (    COD_TIPO_AUTORIZZAZIONE = '6'
                               AND COD_AUTORIZZAZIONE_PADRE IS NOT NULL)
                         THEN
                            'X'
                         WHEN COD_TIPO_AUTORIZZAZIONE != '6'
                         THEN
                            'X'
                      END = 'X') A
          LEFT JOIN
          t_mcres_app_documenti B
             ON (    NVL (a.cod_autorizzazione_padre, a.cod_autorizzazione) =
                        b.cod_identificativo
                 AND b.cod_tipo_documento = 'DO')
          LEFT JOIN
          t_mcres_app_documenti C
             ON (    a.cod_autorizzazione = c.cod_Aut_protoc
                 AND c.cod_tipo_documento = 'AL'
                 AND c.cod_stato = 'TR')
          LEFT JOIN
          t_mcres_app_documenti D
             ON (    a.cod_autorizzazione = d.cod_Aut_protoc
                 AND d.cod_tipo_documento = 'AL'
                 AND d.cod_stato = 'CO');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_SP_IN_LAV TO MCRE_USR;
