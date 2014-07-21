/* Formatted on 21/07/2014 18:41:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_SP_IA_DA_TR
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_PRATICA,
   COD_STATO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_NUMERO_FATTURA,
   DTA_FATTURA,
   INTESTAZIONE,
   VAL_IMPORTO_VALORE,
   COD_AUTORIZZAZIONE,
   DTA_INOLTRO_SPESA,
   DTA_TRASF_SPESA,
   DTA_TRASF_SPESA_RDRC,
   DESC_NOME_GESTORE,
   COD_OD_CALCOLATO,
   FLG_CONFERIMENTO,
   VAL_TIPO_GESTIONE,
   ALERT_INOLTRO,
   ALERT_TRASFERIMENTO,
   VAL_ANNO_PRATICA,
   COD_PROTOCOLLO,
   COD_TIPO_AUTORIZZAZIONE,
   DESCR_COD_TIPO_AUTORIZZAZIONE,
   COD_AUTORIZZAZIONE_PADRE,
   ALERT_INOLTRO16,
   ALERT_TRASFERIMENTO16,
   ALERT_INOLTRO17,
   ALERT_TRASFERIMENTO17,
   ALERT_INOLTRO19,
   ALERT_TRASFERIMENTO19,
   ALERT_INOLTRO20,
   ALERT_TRASFERIMENTO20,
   ALERT_INOLTRO22,
   ALERT_TRASFERIMENTO22,
   ALERT_INOLTRO24,
   ALERT_TRASFERIMENTO24,
   ALERT_INOLTRO26,
   ALERT_TRASFERIMENTO26,
   ALERT_INOLTRO27,
   ALERT_TRASFERIMENTO27,
   ALERT_INOLTRO32,
   ALERT_TRASFERIMENTO32,
   DESC_UO_PRATICA,
   COD_UO,
   COD_CAUSALE,
   FLG_PREAUTORIZZATO,
   FLG_ATTIVA,
   ID_OBJECT_DO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT A."COD_ABI",
          A."DESC_ISTITUTO",
          A."COD_NDG",
          A."COD_SNDG",
          A."DESC_NOME_CONTROPARTE",
          A."COD_PRATICA",
          A."COD_STATO",
          A."COD_UO_PRATICA",
          A."COD_MATR_PRATICA",
          A."VAL_NUMERO_FATTURA",
          A."DTA_FATTURA",
          A."INTESTAZIONE",
          A."VAL_IMPORTO_VALORE",
          A."COD_AUTORIZZAZIONE",
          A."DTA_INOLTRO_SPESA",
          A."DTA_TRASF_SPESA",
          A."DTA_TRASF_SPESA_RDRC",
          A."DESC_NOME_GESTORE",
          A."COD_OD_CALCOLATO",
          A."FLG_CONFERIMENTO",
          A."VAL_TIPO_GESTIONE",
          A."ALERT_INOLTRO",
          A."ALERT_TRASFERIMENTO",
          A."VAL_ANNO_PRATICA",
          A."COD_PROTOCOLLO",
          A."COD_TIPO_AUTORIZZAZIONE",
          A."DESCR_COD_TIPO_AUTORIZZAZIONE",
          A."COD_AUTORIZZAZIONE_PADRE",
          A."ALERT_INOLTRO16",
          A."ALERT_TRASFERIMENTO16",
          A."ALERT_INOLTRO17",
          A."ALERT_TRASFERIMENTO17",
          A."ALERT_INOLTRO19",
          A."ALERT_TRASFERIMENTO19",
          A."ALERT_INOLTRO20",
          A."ALERT_TRASFERIMENTO20",
          A."ALERT_INOLTRO22",
          A."ALERT_TRASFERIMENTO22",
          A."ALERT_INOLTRO24",
          A."ALERT_TRASFERIMENTO24",
          A."ALERT_INOLTRO26",
          A."ALERT_TRASFERIMENTO26",
          A."ALERT_INOLTRO27",
          A."ALERT_TRASFERIMENTO27",
          A."ALERT_INOLTRO32",
          A."ALERT_TRASFERIMENTO32",
          A."DESC_UO_PRATICA",
          A."COD_UO",
          A."COD_CAUSALE",
          A."FLG_PREAUTORIZZATO",
          A."FLG_ATTIVA",
          b.id_object AS id_object_do,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co
     FROM (SELECT sp.cod_abi,
                  ist.desc_istituto,
                  sp.cod_ndg,
                  sp.cod_sndg,
                  ag.desc_nome_controparte,
                  sp.cod_pratica,
                  sp.cod_stato,
                  sp.cod_uo_pratica,
                  sp.cod_matr_pratica,
                  sp.val_numero_fattura,
                  sp.dta_fattura,
                  NVL (lg.intestazione, sp.desc_intestatario) intestazione,
                  sp.val_importo_valore,
                  sp.cod_autorizzazione,
                  sp.dta_inoltro_spesa,
                  sp.dta_trasf_spesa,
                  sp.dta_trasf_spesa_rdrc,
                  us.cognome || ' ' || us.nome AS desc_nome_gestore,
                  sp.cod_od_calcolato,
                  NVL (
                     (SELECT DISTINCT 1
                        FROM v_mcres_app_conferimento_nt n
                       WHERE     n.cod_abi = sp.cod_abi
                             AND n.cod_ndg = sp.cod_ndg),
                     0)
                     flg_conferimento,
                  lp.val_tipo_gestione,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <= 7
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN 8
                                                                             AND 30
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) > 30
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <= 7
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN 8
                                                                           AND 30
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) > 30
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento,
                  sp.val_anno_pratica,
                  sp.cod_protocollo,
                  sp.cod_tipo_autorizzazione,
                  aut.desc_autorizzazione descr_cod_tipo_autorizzazione,
                  sp.COD_AUTORIZZAZIONE_PADRE,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest16.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest16.val_current_green
                                                                                 + 1
                                                                             AND gest16.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest16.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro16,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest16.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest16.val_current_green
                                                                               + 1
                                                                           AND gest16.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest16.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento16,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest17.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest17.val_current_green
                                                                                 + 1
                                                                             AND gest17.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest17.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro17,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest17.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest17.val_current_green
                                                                               + 1
                                                                           AND gest17.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest17.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento17,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest19.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest19.val_current_green
                                                                                 + 1
                                                                             AND gest19.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest19.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro19,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest19.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest19.val_current_green
                                                                               + 1
                                                                           AND gest19.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest19.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento19,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest20.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest20.val_current_green
                                                                                 + 1
                                                                             AND gest20.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest20.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro20,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest20.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest20.val_current_green
                                                                               + 1
                                                                           AND gest20.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest20.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento20,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest22.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest22.val_current_green
                                                                                 + 1
                                                                             AND gest22.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest22.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro22,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest22.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest22.val_current_green
                                                                               + 1
                                                                           AND gest22.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest22.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento22,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest24.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest24.val_current_green
                                                                                 + 1
                                                                             AND gest24.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest24.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro24,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest24.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest24.val_current_green
                                                                               + 1
                                                                           AND gest24.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest24.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento24,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest26.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest26.val_current_green
                                                                                 + 1
                                                                             AND gest26.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest26.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro26,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest26.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest26.val_current_green
                                                                               + 1
                                                                           AND gest26.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest26.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento26,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest27.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest27.val_current_green
                                                                                 + 1
                                                                             AND gest27.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest27.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro27,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest27.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest27.val_current_green
                                                                               + 1
                                                                           AND gest27.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest27.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento27,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) <=
                             gest32.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) BETWEEN   gest32.val_current_green
                                                                                 + 1
                                                                             AND gest32.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_inoltro_spesa) >
                             gest32.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_inoltro32,
                  CASE
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) <=
                             gest32.val_current_green
                     THEN
                        'V'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) BETWEEN   gest32.val_current_green
                                                                               + 1
                                                                           AND gest32.val_current_orange
                     THEN
                        'A'
                     WHEN TRUNC (SYSDATE) - TRUNC (sp.dta_trasf_spesa) >
                             gest32.val_current_orange
                     THEN
                        'R'
                     ELSE
                        'X'
                  END
                     AS alert_trasferimento32,
                  org.desc_struttura_competente DESC_UO_PRATICA,
                  sp.cod_uo,
                  sp.cod_causale,
                  DECODE (sp.cod_stato_itf, 'P', 1, 0) flg_preautorizzato,
                  sp.flg_attiva
             FROM (SELECT sp.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          sp.cod_stato,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_inoltro_spesa,
                          sp.dta_trasf_spesa,
                          sp.dta_trasf_spesa_rdrc,
                          sp.cod_od_calcolato,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.COD_AUTORIZZAZIONE_PADRE,
                          sp.cod_uo,
                          sp.cod_causale,
                          sp.cod_id_legale,
                          itf.cod_Stato cod_Stato_itf,
                          sp.desc_intestatario,
                          pr.flg_attiva
                     FROM t_mcres_app_sp_spese sp
                          LEFT JOIN
                          t_mcres_app_spese_itf itf
                             ON (sp.cod_autorizzazione =
                                    itf.cod_autorizzazione)
                          JOIN
                          t_mcres_app_pratiche pr
                             ON (    pr.flg_attiva = 1
                                 AND pr.cod_abi = sp.cod_abi
                                 AND sp.val_anno_pratica =
                                        TO_CHAR (pr.val_anno)
                                 AND sp.cod_pratica = pr.cod_pratica)
                    WHERE     0 = 0
                          AND sp.cod_stato IN ('IT', 'TR', 'TX')
                          AND CASE
                                 WHEN (    sp.COD_TIPO_AUTORIZZAZIONE = '6'
                                       AND sp.COD_AUTORIZZAZIONE_PADRE
                                              IS NOT NULL)
                                 THEN
                                    'X'
                                 WHEN sp.COD_TIPO_AUTORIZZAZIONE != '6'
                                 THEN
                                    'X'
                              END = 'X'
                   UNION
                   SELECT sp.cod_abi,
                          pr.cod_ndg,
                          pr.cod_sndg,
                          pr.cod_pratica,
                          sp.cod_stato,
                          pr.cod_uo_pratica,
                          pr.cod_matr_pratica,
                          sp.val_numero_fattura,
                          sp.dta_fattura,
                          sp.val_importo_valore,
                          sp.cod_autorizzazione,
                          sp.dta_inoltro_spesa,
                          sp.dta_trasf_spesa,
                          sp.dta_trasf_spesa_rdrc,
                          sp.cod_od_calcolato,
                          sp.val_anno_pratica,
                          sp.cod_protocollo,
                          sp.cod_tipo_autorizzazione,
                          sp.COD_AUTORIZZAZIONE_PADRE,
                          sp.cod_uo,
                          sp.cod_causale,
                          sp.cod_id_legale,
                          itf.cod_Stato cod_stato_itf,
                          sp.desc_intestatario,
                          pr.flg_attiva
                     FROM t_mcres_app_sp_spese sp
                          LEFT JOIN
                          t_mcres_app_spese_itf itf
                             ON (sp.cod_autorizzazione =
                                    itf.cod_autorizzazione)
                          JOIN
                          t_mcres_app_pratiche pr
                             ON (    pr.flg_attiva = 0
                                 AND pr.cod_abi = sp.cod_abi
                                 AND sp.val_anno_pratica =
                                        TO_CHAR (pr.val_anno)
                                 AND sp.cod_pratica = pr.cod_pratica)
                    WHERE     0 = 0
                          AND sp.cod_stato IN ('IT', 'TR', 'TX')
                          AND CASE
                                 WHEN (    sp.COD_TIPO_AUTORIZZAZIONE = '6'
                                       AND sp.COD_AUTORIZZAZIONE_PADRE
                                              IS NOT NULL)
                                 THEN
                                    'X'
                                 WHEN sp.COD_TIPO_AUTORIZZAZIONE != '6'
                                 THEN
                                    'X'
                              END = 'X') sp
                  JOIN t_mcres_app_istituti ist ON (ist.cod_abi = sp.cod_abi)
                  --JOIN t_mcres_app_posizioni ps ON (ps.cod_abi = pr.cod_abi AND ps.cod_ndg = pr.cod_ndg)
                  --LEFT JOIN t_mcre0_app_anagrafica_gruppo ag ON (ag.cod_sndg = ps.cod_sndg)
                  LEFT JOIN t_mcre0_app_anagrafica_gruppo ag
                     ON (ag.cod_sndg = sp.cod_sndg)
                  LEFT JOIN t_mcres_app_utenti us
                     ON (us.cod_matricola = sp.cod_matr_pratica)
                  LEFT JOIN v_mcres_app_sp_legali_esterni lg
                     ON (lg.id_legale = sp.cod_id_legale)
                  --          LEFT JOIN v_mcres_app_conferimento_nt nt
                  --             ON (nt.cod_abi = pr.cod_abi AND nt.cod_ndg = pr.cod_ndg)
                  LEFT JOIN v_mcres_app_lista_presidi lp
                     ON (lp.cod_presidio = sp.cod_uo_pratica)
                  LEFT JOIN t_mcres_cl_tipo_autorizzazione aut
                     ON (aut.cod_tipo = sp.cod_tipo_autorizzazione)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest20
                     ON (gest20.id_alert = 20)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest17
                     ON (gest17.id_alert = 17)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest19
                     ON (gest19.id_alert = 19)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest16
                     ON (gest16.id_alert = 16)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest22
                     ON (gest22.id_alert = 22)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest26
                     ON (gest26.id_alert = 26)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest27
                     ON (gest27.id_alert = 27)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest32
                     ON (gest32.id_alert = 32)
                  --AP 20/02/2013
                  JOIN T_MCRES_APP_GESTIONE_ALERT gest24
                     ON (gest24.id_alert = 24)
                  --AP 21/02/2013
                  LEFT JOIN
                  T_MCRE0_APP_STRUTTURA_ORG ORG
                     ON (    org.cod_Abi_istituto = sp.cod_Abi
                         AND org.cod_Struttura_Competente = sp.cod_uo_pratica)) A
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
