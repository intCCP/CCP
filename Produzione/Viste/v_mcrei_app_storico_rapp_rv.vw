/* Formatted on 17/06/2014 18:08:51 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_STORICO_RAPP_RV
(
   COD_RAPPORTO,
   COD_PROTOCOLLO_DELIBERA,
   COD_ABI,
   COD_NDG,
   DTA_STIMA_RETTIFICA,
   COD_TIPOLOGIA,
   DESC_TIPO_DATO,
   COD_UTENTE,
   DESC_CAUSA_PREV_RECUPERO,
   VAL_ESPOSIZIONE_QC,
   VAL_STIMA_RETTIFICA,
   VAL_RDV_CALCOLATA,
   VAL_REC_TOT,
   FLG_PIANO_RIENTRO
)
AS
   SELECT /*+index(A IDX_T_MCREI_APP_sTIME) */
         DISTINCT
          a.cod_rapporto AS cod_rapporto,                           --9 maggio
          a.cod_protocollo_delibera,
          a.cod_abi,
          a.cod_ndg,
          a.dta_stima AS dta_stima_rettifica,
          a.flg_tipo_dato AS cod_tipologia,
          DECODE (a.flg_tipo_dato,  'S', 'Stima',  'R', 'Rettifica')  --13 giu
             AS desc_tipo_dato,                                       --12 giu
          a.cod_utente,
          a.desc_causa_prev_recupero,
            NVL (a.val_esposizione, pcr.val_imp_utilizzato)
          - NVL (a.val_utilizzato_mora, 0)
             AS val_esposizione_qc,                                --22 maggio
          DECODE (a.flg_tipo_dato, 'S', a.val_prev_recupero, a.val_rdv_tot)
             AS val_stima_rettifica,
          ------ 8 NOV: AGGIUNTA VERIFICA SU FLG_rECUPERO_tOT
          (CASE
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'N'
              THEN
                 val_utilizzato_netto - val_prev_recupero -- val_esposizione - val_prev_recupero
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'Y'
              THEN
                 0
              ELSE
                 a.val_rdv_tot
           END)
             AS val_rdv_calcolata,
          a.flg_recupero_tot AS val_rec_tot,               ---flg_recupero_tot
          DECODE (r.cod_rapporto, NULL, 'N', 'Y') AS flg_piano_rientro -- flg_piano_rientro
     FROM t_mcrei_app_stime a,
          t_mcrei_app_piani_rientro r,
          t_mcrei_app_delibere d,
          t_mcrei_app_pcr_rapporti pcr ----28.05: AGGIUNTO PCR PER SANARE CASI SPORCHI
    WHERE     a.cod_abi = r.cod_abi(+)
          AND a.cod_ndg = r.cod_ndg(+)
          AND a.cod_rapporto = r.cod_rapporto(+)
          AND a.dta_stima = r.dta_stima(+)
          AND a.flg_attiva = '1'
          AND a.cod_abi = pcr.cod_abi(+)
          AND a.cod_ndg = pcr.cod_ndg(+)
          AND a.cod_rapporto = pcr.cod_rapporto(+)
          AND a.cod_abi = d.cod_abi
          AND a.cod_ndg = d.cod_ndg
          AND d.flg_attiva = '1'
          AND d.cod_fase_delibera = 'CO'
   UNION ALL
   SELECT DISTINCT
          a.cod_rapporto AS cod_rapporto,                           --9 maggio
          a.cod_protocollo_delibera,
          a.cod_abi,
          a.cod_ndg,
          a.dta_stima AS dta_stima_rettifica,
          a.flg_tipo_dato AS cod_tipologia,
          DECODE (a.flg_tipo_dato,  'S', 'Stima',  'R', 'Rettifica')   --6 nov
             AS desc_tipo_dato,                                       --12 giu
          a.cod_utente,
          a.desc_causa_prev_recupero,
            NVL (a.val_esposizione, pcr.val_imp_utilizzato)
          - NVL (a.val_utilizzato_mora, 0)
             AS val_esposizione_qc,                                --30 MAGGIO
          DECODE (a.flg_tipo_dato, 'S', a.val_prev_recupero, a.val_rdv_tot)
             AS val_stima_rettifica,
          --8 NOV
          (CASE
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'N'
              THEN
                 val_utilizzato_netto - val_prev_recupero -- val_esposizione - val_prev_recupero
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'Y'
              THEN
                 0
              ELSE
                 a.val_rdv_tot
           END)
             AS val_rdv_calcolata,                                    --31 ott
          a.flg_recupero_tot AS val_rec_tot,               ---flg_recupero_tot
          DECODE (r.cod_rapporto, NULL, 'N', 'Y') AS flg_piano_rientro -- flg_piano_rientro
     FROM t_mcrei_hst_valutazioni a,
          t_mcrei_hst_piani_rivalutati r,
          t_mcrei_app_pcr_rapporti pcr ----28.05: AGGIUNTO PCR PER SANARE CASI SPORCHI
    WHERE     a.cod_abi = r.cod_abi(+)
          AND a.cod_ndg = r.cod_ndg(+)
          AND a.cod_rapporto = r.cod_rapporto(+)
          AND a.dta_stima = r.dta_stima(+)
          AND a.cod_abi = pcr.cod_abi(+)
          AND a.cod_ndg = pcr.cod_ndg(+)
          AND a.cod_rapporto = pcr.cod_rapporto(+)
   UNION ALL
   SELECT DISTINCT
          a.cod_rapporto AS cod_rapporto,                           --9 maggio
          a.cod_protocollo_delibera,
          a.cod_abi,
          a.cod_ndg,
          a.dta_stima AS dta_stima_rettifica,
          a.flg_tipo_dato AS cod_tipologia,
          DECODE (a.flg_tipo_dato,  'S', 'Stima',  'R', 'Rettifica')   --6 nov
             AS desc_tipo_dato,                                       --12 giu
          a.cod_utente,
          a.desc_causa_prev_recupero,
          a.val_esposizione - NVL (a.val_utilizzato_mora, 0)
             AS val_esposizione_qc,                                --22 maggio
          DECODE (a.flg_tipo_dato, 'S', a.val_prev_recupero, a.val_rdv_tot)
             AS val_stima_rettifica,
          --8 NOV
          (CASE
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'N'
              THEN
                 val_utilizzato_netto - val_prev_recupero -- val_esposizione - val_prev_recupero
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'Y'
              THEN
                 0
              ELSE
                 a.val_rdv_tot
           END)
             AS val_rdv_calcolata,                                    --31 ott
          a.flg_recupero_tot AS val_rec_tot,               ---flg_recupero_tot
          NULL AS flg_piano_rientro                       -- flg_piano_rientro
     FROM t_mcrei_app_stime_batch a
   UNION ALL
   SELECT DISTINCT
          a.cod_rapporto AS cod_rapporto,                           --9 maggio
          NULL AS cod_protocollo_delibera,
          a.cod_abi,
          a.cod_ndg,
          a.dta_stima AS dta_stima_rettifica,
          a.flg_tipo_dato AS cod_tipologia,
          DECODE (a.flg_tipo_dato,  'S', 'Stima',  'R', 'Rettifica')   --6 nov
             AS desc_tipo_dato,                                       --12 giu
          a.cod_utente,
          a.desc_causa_prev_recupero,
          a.val_esposizione - NVL (a.val_utilizzato_mora, 0)
             AS val_esposizione_qc,                                --22 maggio
          DECODE (a.flg_tipo_dato, 'S', a.val_prev_recupero, a.val_rdv_tot)
             AS val_stima_rettifica,
          --8 NOV
          (CASE
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'N'
              THEN
                 val_utilizzato_netto - val_prev_recupero -- val_esposizione - val_prev_recupero
              WHEN flg_tipo_dato = 'S' AND a.flg_recupero_tot = 'Y'
              THEN
                 0
              ELSE
                 a.val_rdv_tot
           END)
             AS val_rdv_calcolata,                                    --31 ott
          a.flg_recupero_tot AS val_rec_tot,               ---flg_recupero_tot
          NULL AS flg_piano_rientro                       -- flg_piano_rientro
     FROM t_mcrei_app_stime_extra a, t_mcrei_app_piani_rientro_extr p  --4 set
    WHERE     a.cod_abi = p.cod_abi(+)
          AND a.cod_ndg = p.cod_ndg(+)
          AND a.cod_rapporto = p.cod_rapporto(+)
          AND a.dta_stima = p.dta_stima(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_STORICO_RAPP_RV TO MCRE_USR;
