/* Formatted on 17/06/2014 18:09:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SP_AUT
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
   DTA_AUTORIZZAZIONE,
   DESC_NOME_GESTORE,
   COD_OD_CALCOLATO,
   FLG_CONFERIMENTO,
   ALERT,
   VAL_ANNO_PRATICA,
   COD_PROTOCOLLO,
   COD_TIPO_AUTORIZZAZIONE,
   DESCR_COD_TIPO_AUTORIZZAZIONE,
   DTA_TRASF_SPESA,
   COD_ORGANO_AUTORIZZANTE,
   COD_AUTORIZZAZIONE_PADRE,
   DTA_TRASF_SPESA_RDRC,
   COD_STATO,
   ALERT18,
   ALERT21,
   ALERT25,
   ALERT33,
   VAL_TIPO_GESTIONE,
   FLG_PRESA_VIS,
   FLG_PRESA_VIS_PRESIDIO,
   FLG_PRESA_VIS_ENTE_CENTR,
   FLG_ATTIVA,
   ID_OBJECT_DO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO,
   ID_OBJECT_AL_AN
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
          A."DTA_AUTORIZZAZIONE",
          A."DESC_NOME_GESTORE",
          A."COD_OD_CALCOLATO",
          A."FLG_CONFERIMENTO",
          A."ALERT",
          A."VAL_ANNO_PRATICA",
          A."COD_PROTOCOLLO",
          A."COD_TIPO_AUTORIZZAZIONE",
          A."DESCR_COD_TIPO_AUTORIZZAZIONE",
          A."DTA_TRASF_SPESA",
          A."COD_ORGANO_AUTORIZZANTE",
          A."COD_AUTORIZZAZIONE_PADRE",
          A."DTA_TRASF_SPESA_RDRC",
          A."COD_STATO",
          A."ALERT18",
          A."ALERT21",
          A."ALERT25",
          A."ALERT33",
          A."VAL_TIPO_GESTIONE",
          A."FLG_PRESA_VIS",
          A."FLG_PRESA_VIS_PRESIDIO",
          A."FLG_PRESA_VIS_ENTE_CENTR",
          A."FLG_ATTIVA",
          b.id_object AS id_object_do,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co,
          e.id_object AS id_object_al_an
     FROM (SELECT 18 AS id_alert,
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
                  NVL (Lg.VAL_LEGALE_COGNOME || ' ' || Lg.VAL_LEGALE_NOME,
                       sp.desc_intestatario)
                     intestazione,
                  sp.val_importo_valore,
                  sp.cod_autorizzazione,
                  sp.dta_autorizzazione,
                  us.cognome || ' ' || us.nome AS desc_nome_gestore,
                  sp.cod_od_calcolato,
                  NVL (
                     (SELECT DISTINCT 1
                        FROM v_mcres_app_conferimento_nt n
                       WHERE     n.cod_abi = sp.cod_abi
                             AND n.cod_ndg = sp.cod_ndg),
                     0)
                     flg_conferimento,
                  DECODE (
                     sp.cod_stato,
                     'CO', CASE
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) <= 7
                              THEN
                                 'V'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) BETWEEN 8
                                                                       AND 30
                              THEN
                                 'A'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) > 30
                              THEN
                                 'R'
                              ELSE
                                 'X'
                           END,
                     CASE
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) <=
                                7
                        THEN
                           'V'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) BETWEEN 8
                                                                               AND 30
                        THEN
                           'A'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) >
                                30
                        THEN
                           'R'
                        ELSE
                           'X'
                     END)
                     AS alert,
                  sp.val_anno_pratica,
                  sp.cod_protocollo,
                  sp.cod_tipo_autorizzazione,
                  aut.desc_autorizzazione descr_cod_tipo_autorizzazione,
                  sp.dta_trasf_spesa,
                  sp.COD_ORGANO_AUTORIZZANTE,
                  sp.cod_Autorizzazione_padre,
                  sp.Dta_trasf_Spesa_rdrc,
                  sp.cod_stato,
                  DECODE (
                     sp.cod_stato,
                     'CO', CASE
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) <=
                                      gest18.val_current_green
                              THEN
                                 'V'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) BETWEEN   gest18.val_current_green
                                                                           + 1
                                                                       AND gest18.val_current_orange
                              THEN
                                 'A'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) >
                                      gest18.val_current_orange
                              THEN
                                 'R'
                              ELSE
                                 'X'
                           END,
                     CASE
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) <=
                                gest18.val_current_green
                        THEN
                           'V'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) BETWEEN   gest18.val_current_green
                                                                                   + 1
                                                                               AND gest18.val_current_orange
                        THEN
                           'A'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) >
                                gest18.val_current_orange
                        THEN
                           'R'
                        ELSE
                           'X'
                     END)
                     AS alert18,
                  DECODE (
                     sp.cod_stato,
                     'CO', CASE
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) <=
                                      gest21.val_current_green
                              THEN
                                 'V'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) BETWEEN   gest21.val_current_green
                                                                           + 1
                                                                       AND gest21.val_current_orange
                              THEN
                                 'A'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) >
                                      gest21.val_current_orange
                              THEN
                                 'R'
                              ELSE
                                 'X'
                           END,
                     CASE
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) <=
                                gest21.val_current_green
                        THEN
                           'V'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) BETWEEN   gest21.val_current_green
                                                                                   + 1
                                                                               AND gest21.val_current_orange
                        THEN
                           'A'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) >
                                gest21.val_current_orange
                        THEN
                           'R'
                        ELSE
                           'X'
                     END)
                     AS alert21,
                  DECODE (
                     sp.cod_stato,
                     'CO', CASE
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) <=
                                      gest25.val_current_green
                              THEN
                                 'V'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) BETWEEN   gest25.val_current_green
                                                                           + 1
                                                                       AND gest25.val_current_orange
                              THEN
                                 'A'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) >
                                      gest25.val_current_orange
                              THEN
                                 'R'
                              ELSE
                                 'X'
                           END,
                     CASE
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) <=
                                gest25.val_current_green
                        THEN
                           'V'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) BETWEEN   gest25.val_current_green
                                                                                   + 1
                                                                               AND gest25.val_current_orange
                        THEN
                           'A'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) >
                                gest25.val_current_orange
                        THEN
                           'R'
                        ELSE
                           'X'
                     END)
                     AS alert25,
                  DECODE (
                     sp.cod_stato,
                     'CO', CASE
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) <=
                                      gest33.val_current_green
                              THEN
                                 'V'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) BETWEEN   gest33.val_current_green
                                                                           + 1
                                                                       AND gest33.val_current_orange
                              THEN
                                 'A'
                              WHEN   TRUNC (SYSDATE)
                                   - TRUNC (sp.dta_autorizzazione) >
                                      gest33.val_current_orange
                              THEN
                                 'R'
                              ELSE
                                 'X'
                           END,
                     CASE
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) <=
                                gest33.val_current_green
                        THEN
                           'V'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) BETWEEN   gest33.val_current_green
                                                                                   + 1
                                                                               AND gest33.val_current_orange
                        THEN
                           'A'
                        WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_annullamento) >
                                gest33.val_current_orange
                        THEN
                           'R'
                        ELSE
                           'X'
                     END)
                     AS alert33,
                  lp.val_tipo_gestione,
                  sp.flg_presa_vis,
                  sp.flg_presa_vis_presidio,
                  sp.flg_presa_vis_ente_Centr,
                  sp.flg_attiva
             FROM (SELECT 18 AS id_alert,
                          pr.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_autorizzazione,
                          sp.cod_od_calcolato,
                          sp.dta_annullamento,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.dta_trasf_spesa,
                          sp.COD_ORGANO_AUTORIZZANTE,
                          sp.cod_Autorizzazione_padre,
                          sp.Dta_trasf_Spesa_rdrc,
                          sp.cod_stato,
                          sp.flg_presa_vis,
                          sp.flg_presa_vis_presidio,
                          sp.flg_presa_vis_ente_Centr,
                          sp.cod_id_legale,
                          sp.desc_intestatario,
                          pr.flg_attiva
                     FROM t_mcres_app_sp_spese sp, t_mcres_app_pratiche pr
                    WHERE     0 = 0
                          AND pr.flg_attiva = 1
                          AND sp.cod_abi = pr.cod_abi
                          AND TO_NUMBER (sp.val_anno_pratica) = pr.val_anno
                          AND sp.cod_pratica = pr.cod_pratica
                          AND sp.cod_stato IN ('CO', 'AN')
                          AND CASE
                                 WHEN (    COD_TIPO_AUTORIZZAZIONE = '6'
                                       AND COD_AUTORIZZAZIONE_PADRE
                                              IS NOT NULL)
                                 THEN
                                    'X'
                                 WHEN COD_TIPO_AUTORIZZAZIONE != '6'
                                 THEN
                                    'X'
                                 ELSE
                                    'N'
                              END = 'X'
                   UNION ALL
                   SELECT 18 AS id_alert,
                          pr.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_autorizzazione,
                          sp.cod_od_calcolato,
                          sp.dta_annullamento,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.dta_trasf_spesa,
                          sp.COD_ORGANO_AUTORIZZANTE,
                          sp.cod_Autorizzazione_padre,
                          sp.Dta_trasf_Spesa_rdrc,
                          sp.cod_stato,
                          sp.flg_presa_vis,
                          sp.flg_presa_vis_presidio,
                          sp.flg_presa_vis_ente_Centr,
                          sp.cod_id_legale,
                          sp.desc_intestatario,
                          pr.flg_attiva
                     FROM t_mcres_app_sp_spese sp, t_mcres_app_pratiche pr
                    WHERE     0 = 0
                          AND pr.flg_attiva = 0
                          AND sp.cod_abi = pr.cod_abi
                          AND TO_NUMBER (sp.val_anno_pratica) = pr.val_anno
                          AND sp.cod_pratica = pr.cod_pratica
                          AND sp.cod_stato IN ('CO', 'AN')
                          AND CASE
                                 WHEN (    COD_TIPO_AUTORIZZAZIONE = '6'
                                       AND COD_AUTORIZZAZIONE_PADRE
                                              IS NOT NULL)
                                 THEN
                                    'X'
                                 WHEN COD_TIPO_AUTORIZZAZIONE != '6'
                                 THEN
                                    'X'
                                 ELSE
                                    'N'
                              END = 'X') sp
                  JOIN t_mcres_app_istituti ist ON (ist.cod_abi = sp.cod_abi)
                  LEFT JOIN t_mcre0_app_anagrafica_gruppo ag
                     ON (ag.cod_sndg = sp.cod_sndg)
                  LEFT JOIN t_mcres_app_utenti us
                     ON (us.cod_matricola = sp.cod_matr_pratica)
                  LEFT JOIN T_MCRES_APP_LEGALI_ESTERNI lg -- v_mcres_app_sp_legali_esterni lg
                     ON (lg.cod_id_legale = sp.cod_id_legale)
                  LEFT JOIN t_mcres_cl_tipo_autorizzazione aut
                     ON (aut.cod_tipo = sp.cod_tipo_autorizzazione)
                  --AP 19/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest18
                     ON (gest18.id_alert = 18)
                  --AP 19/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest21
                     ON (gest21.id_alert = 21)
                  --AP 19/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest25
                     ON (gest25.id_alert = 25)
                  --AP 19/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest33
                     ON (gest33.id_alert = 33)
                  LEFT JOIN v_mcres_app_lista_presidi lp
                     ON (lp.cod_presidio = sp.cod_uo_pratica)) A
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
                 AND d.cod_stato = 'CO')
          LEFT JOIN
          t_mcres_app_documenti e
             ON (    a.cod_autorizzazione = e.cod_aut_protoc
                 AND e.cod_tipo_documento = 'AL'
                 AND e.cod_stato = 'AN');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_SP_AUT TO MCRE_USR;
