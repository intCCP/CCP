/* Formatted on 21/07/2014 18:41:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_OLD
(
   COD_ABI,
   ID_ALERT,
   DESC_ALERT,
   ID_FUNZIONE,
   COD_PRIVILEGIO,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   VAL_ROSSO,
   VAL_ARANCIO,
   VAL_VERDE,
   VAL_TOTALE,
   VAL_ANNOMESE,
   FLG_ORDINE,
   DTA_INS,
   DESC_PRESIDIO,
   VAL_TOT_SPESE
)
AS
   SELECT A."COD_ABI",
          A."ID_ALERT",
          A."DESC_ALERT",
          A."ID_FUNZIONE",
          A."COD_PRIVILEGIO",
          A."COD_UO_PRATICA",
          A."COD_MATR_PRATICA",
          A."VAL_ROSSO",
          A."VAL_ARANCIO",
          A."VAL_VERDE",
          A."VAL_TOTALE",
          A."VAL_ANNOMESE",
          A."FLG_ORDINE",
          A."DTA_INS",
          A."DESC_PRESIDIO",
          B.val_tot_spese
     FROM (SELECT "COD_ABI",
                  b."ID_ALERT",
                  "DESC_ALERT",
                  "ID_FUNZIONE",
                  "COD_PRIVILEGIO",
                  "COD_UO_PRATICA",
                  "COD_MATR_PRATICA",
                  "VAL_ROSSO",
                  "VAL_ARANCIO",
                  "VAL_VERDE",
                  VAL_ROSSO + VAL_ARANCIO + VAL_VERDE VAL_TOTALE,
                  f.val_annomese_sisba_cp VAL_ANNOMESE,
                  "FLG_ORDINE",
                  "DTA_INS",
                  -- AP 12/10/2012
                  DESC_STRUTTURA_COMPETENTE DESC_PRESIDIO
             FROM t_mcres_fen_alert B,
                  T_MCRES_APP_ALERT_RUOLI R,
                  V_MCRES_APP_ULTIMO_ANNOMESE F,
                  --AP 12/10/2012
                  t_mcre0_app_struttura_org org
            WHERE     b.ID_ALERT = R.ID_ALERT
                  AND R.COD_PRIVILEGIO = 'A'
                  AND r.FLG_ATTIVO = 'A'
                  -- AP 12/10/2012
                  AND org.cod_abi_istituto(+) = b.cod_abi
                  AND org.cod_struttura_competente(+) = b.cod_uo_pratica) A
          LEFT JOIN
          (  SELECT a.cod_abi,
                    20 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_ia_da_tr a
              WHERE a.cod_stato = 'TR' AND a.val_tipo_gestione = 'I'
           GROUP BY a.cod_abi, a.cod_uo_pratica, a.cod_matr_pratica
           UNION
             SELECT a.cod_abi,
                    22 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_ia_da_tr a
              WHERE a.cod_stato = 'TR' AND a.val_tipo_gestione = 'E'
           GROUP BY a.cod_abi, a.cod_uo_pratica, a.cod_matr_pratica
           UNION
             --AP 08/11/2012
             SELECT a.cod_abi,
                    23 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_fornitori a
           GROUP BY a.cod_abi, a.cod_uo_pratica, a.cod_matr_pratica
           -- AP 28/02/2013
           UNION
             SELECT a.cod_abi,
                    24 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_ia_da_tr a
              WHERE a.cod_stato = 'TX' AND a.val_tipo_gestione = 'I'
           GROUP BY a.cod_abi, a.cod_uo_pratica, a.cod_matr_pratica
           UNION
             SELECT a.cod_abi,
                    32 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_ia_da_tr a
              WHERE a.cod_stato = 'TX' AND a.val_tipo_gestione = 'E'
           GROUP BY a.cod_abi, a.cod_uo_pratica, a.cod_matr_pratica
           UNION
             SELECT a.cod_abi,
                    25 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_aut a
              WHERE     a.dta_trasf_spesa_rdrc IS NOT NULL
                    AND a.val_tipo_gestione = 'I'
           GROUP BY a.cod_abi,
                    a.id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica
           UNION
             SELECT a.cod_abi,
                    33 AS id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica,
                    SUM (val_importo_valore) val_tot_spese
               FROM v_mcres_app_alert_sp_aut a
              WHERE     a.dta_trasf_spesa_rdrc IS NOT NULL
                    AND a.val_tipo_gestione = 'E'
           GROUP BY a.cod_abi,
                    a.id_alert,
                    a.cod_uo_pratica,
                    a.cod_matr_pratica) B
             ON (    a.cod_abi = b.cod_abi
                 AND a.cod_uo_pratica = b.cod_uo_pratica
                 AND a.cod_matr_pratica = b.cod_matr_pratica
                 AND a.id_alert = b.id_alert);
