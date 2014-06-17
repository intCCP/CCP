/* Formatted on 17/06/2014 18:08:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_QUADRO_SINT_SNDG
(
   COD_PROTOCOLLO_PACCHETTO,
   COD_MICROTIPOLOGIA_DELIB,
   COD_PROTOCOLLO_DELIBERA,
   COD_FASE_PACCHETTO,
   COD_FASE_MICROTIPOLOGIA,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   VAL_RET_DELIBERATA_CASSA,
   VAL_RET_DELIBERATA_FIRMA,
   VAL_RET_DELIBERATA_DERIVATI,
   VAL_RET_PROPOSTA_CASSA,
   VAL_RET_PROPOSTA_FIRMA,
   VAL_RET_PROPOSTA_DERIVATI,
   VAL_RET_TOT_DA_DELIB_CASSA,
   VAL_RET_TOT_DA_DELIB_FIRMA,
   VAL_RET_TOT_DA_DELIB_DERIVATI,
   TOT_RETTIFICA_DA_DELIB,
   VAL_RDV_TOT_CASSA,
   VAL_RDV_TOT_FIRMA,
   VAL_RDV_TOT_DERIVATI,
   VAL_RDV_TOT,
   VAL_RINUNCIA_PREGRESSA,
   VAL_RINUNCIA_PROPOSTA,
   TOT_RINUNCIA_DA_DELIB,
   DTA_SCAD_VARIAZIONE_PROPOSTA,
   DTA_SCAD_TOT_DA_DELIBERARE,
   COD_ORGANO_CALCOLATO,
   COD_OD_EFFETTIVO,
   DTA_DELIBERA,
   DTA_DELIBERA_RETE,
   DTA_CONFERMA_DELIBERA,
   FLG_COERENZA_CON_PARERE,
   DESC_NOTE_COERENZA,
   VAL_RDV_DELIB_BANCA_RETE,
   COD_FASE_DELIBERA,
   VAL_STRALCIO_QUOTA_CAP,
   VAL_STRALCIO_QUOTA_MORA,
   DTA_AGGIORNAMENTO_STATO,
   FLG_CONFERMA,
   COD_DOC_DELIBERA_BANCA,
   COD_DOC_PARERE_CONFORMITA,
   COD_DOC_APPENDICE_PARERE,
   COD_DOC_DELIBERA_CAPOGRUPPO,
   COD_DOC_CLASSIFICAZIONE,
   COD_MACROTIPOLOGIA_DELIB,
   VAL_RINUNCIA_CAPITALE,
   VAL_RINUNCIA_MORA,
   DTA_LAST_UPD_DELIBERA,
   COD_TIPO_PACCHETTO,
   FLG_RISTRUTTURATO,
   COD_DELIBERA_MODIFICATO,
   COD_GRUPPO_SUPER,
   DTA_CONFERMA_PACCHETTO,
   DESC_NOME_CONTROPARTE
)
AS
   SELECT D.COD_PROTOCOLLO_PACCHETTO,
          d.cod_microtipologia_delib,
          D.COD_PROTOCOLLO_DELIBERA,
          d.cod_fase_pacchetto,
          D.COD_FASE_MICROTIPOLOGIA,
          D.COD_ABI,
          D.COD_NDG,
          D.COD_SNDG,
          i.desc_istituto,
          --valori deliberati
          d.val_rdv_qc_ante_delib AS val_ret_deliberata_cassa,
          d.val_rdv_pregr_fi AS val_ret_deliberata_firma,
          TO_NUMBER (NULL) AS val_ret_deliberata_derivati,
          -- 5 sest: aggiunto mascheramento anche per TP e DR
          --variazioni proposte
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  - NVL (d.val_rdv_qc_ante_delib, 0))
           END)
             AS val_ret_proposta_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (NVL (d.val_rdv_progr_fi, 0) - NVL (d.val_rdv_pregr_fi, 0))
           END)
             AS val_ret_proposta_firma,
          TO_NUMBER (NULL) AS val_ret_proposta_derivati,
          --valori da deliberare
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_qc_progressiva
           END)
             AS val_ret_tot_da_delib_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_progr_fi
           END)
             AS val_ret_tot_da_delib_firma,
          TO_NUMBER (NULL) AS val_ret_tot_da_delib_derivati,
          ---tot_da deliberare
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  + NVL (d.val_rdv_progr_fi, 0) /*+ pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (d.cod_abi, d.cod_ndg, 'CT')*/
                                               )                   --13 aprile
           END)
             AS tot_rettifica_da_delib,
          ----------------------
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_qc_progressiva
           END)
             AS val_rdv_tot_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_progr_fi
           END)
             AS val_rdv_tot_firma,
          TO_NUMBER (NULL) AS val_rdv_tot_derivati,
          ------------------------
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  + NVL (d.val_rdv_progr_fi, 0))
           END)
             AS val_rdv_tot,
          ------------------------
          --RINUNCE
          val_rinuncia_deliberata AS val_rinuncia_pregressa,
          (CASE
              WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rinuncia_capitale, 0)
                  + NVL (d.val_rinuncia_mora, 0))
           END)
             AS val_rinuncia_proposta,
          -------
          (CASE
              WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
              THEN
                 TO_NUMBER (NULL)
              ELSE                                                 --23 aprile
                 NVL (d.val_imp_perdita, 0)
           /*(nvl(d.val_rinuncia_deliberata, 0) +
                                                                                                                                                                                                                                                 nvl(d.val_rinuncia_capitale, 0) + nvl(d.val_rinuncia_mora, 0))*/
           END)
             AS tot_rinuncia_da_delib,
          MAX (
             NVL (d.dta_scadenza, d.dta_scadenza_transaz)) -- 4 SET SU INDICAZIONE UTENTE
          OVER (
             PARTITION BY d.cod_protocollo_pacchetto,
                          d.cod_microtipologia_delib)
             AS dta_scad_variazione_proposta,
          MAX (
             NVL (d.dta_scadenza, d.dta_scadenza_transaz)) -- 4 SET SU INDICAZIONE UTENTE
          OVER (
             PARTITION BY d.cod_protocollo_pacchetto,
                          d.cod_microtipologia_delib)
             AS dta_scad_tot_da_deliberare,
          cod_organo_calcolato,
          cod_organo_deliberante AS cod_od_effettivo,
          dta_delibera,
          dta_delibera_rete,
          dta_conferma_delibera,
          DECODE (flg_delib_in_linea,
                  'Y', 'SI',
                  'N', 'NO',
                  flg_delib_in_linea)
             AS flg_coerenza_con_parere,
          desc_note_coerenza,
          val_rdv_delib_banca_rete,
          /*seguono campi specifici delle transazioni a pronti*/
          cod_fase_delibera,
          val_stralcio_quota_cap,
          val_stralcio_quota_mora,
          dta_upd_fase_delibera AS dta_aggiornamento_stato,
          DECODE (cod_fase_delibera, 'CO', 'Y', 'N') flg_conferma,
          ---MODIFICATO IL 24/2
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          cod_macrotipologia_delib,
          val_rinuncia_capitale,
          val_rinuncia_mora,
          dta_last_upd_delibera,
          COD_TIPO_PACCHETTO,
          D.FLG_RISTRUTTURATO,
          D.COD_DELIBERA_MODIFICATO,
          A.COD_GRUPPO_SUPER,
          d.DTA_CONFERMA_PACCHETTO,
          a.DESC_NOME_CONTROPARTE
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_istituti i,
          T_MCREI_CL_TIPOLOGIE TIP,
          t_mcre0_app_all_Data a
    WHERE /*     ESEGUIRE BEGIN dbms_application_info.set_client_info( COD_ABI ); END;*/
         d    .cod_macrotipologia_delib != 'TP'            ----SOLO GESTIONALI
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')          --13Dicembre
          AND d.cod_tipo_pacchetto != 'A'
          AND d.flg_no_delibera = '0'
          AND d.flg_attiva = '1'
          AND d.cod_abi = i.cod_abi
          AND d.cod_microtipologia_delib = tip.cod_microtipologia(+)
          AND d.cod_abi =
                 DECODE ( (SYS_CONTEXT ('userenv', 'client_info')),
                         '-', d.cod_abi,
                         (SYS_CONTEXT ('userenv', 'client_info')))
          AND (   d.cod_fase_microtipologia = 'ATT'
               OR (    d.cod_fase_microtipologia = 'CNF'
                   AND d.cod_microtipologia_delib IN
                          (SELECT cod_microtipologia
                             FROM t_mcrei_cl_tipologie
                            WHERE flg_segn_ristr = 1 OR flg_contab_ademp = 1))
               OR (    d.cod_fase_microtipologia = 'RIS'
                   AND d.cod_microtipologia_delib IN
                          (SELECT cod_microtipologia
                             FROM t_mcrei_cl_tipologie
                            WHERE flg_contab_ademp = 1)))
          AND COD_FASE_DELIBERA IN ('CO', 'CA', 'CM', 'AT', 'RI', 'NR') --25.05 aggiunto CA
          AND D.COD_ABI = A.COD_ABI_CARTOLARIZZATO
          AND d.cod_ndg = a.cod_ndg
   UNION
   SELECT d.cod_protocollo_pacchetto,
          d.cod_microtipologia_delib,
          d.cod_protocollo_delibera,
          d.cod_fase_pacchetto,
          D.COD_FASE_MICROTIPOLOGIA,
          D.COD_ABI,
          D.COD_NDG,
          D.COD_SNDG,
          i.desc_istituto,
          --valori deliberati
          d.val_rdv_qc_ante_delib AS val_ret_deliberata_cassa,
          d.val_rdv_pregr_fi AS val_ret_deliberata_firma,
          TO_NUMBER (NULL) AS val_ret_deliberata_derivati,
          --variazioni proposte
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  - NVL (d.val_rdv_qc_ante_delib, 0))
           END)
             AS val_ret_proposta_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (NVL (d.val_rdv_progr_fi, 0) - NVL (d.val_rdv_pregr_fi, 0))
           END)
             AS val_ret_proposta_firma,
          TO_NUMBER (NULL) AS val_ret_proposta_derivati,
          --valori da deliberare
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_qc_progressiva
           END)
             AS val_ret_tot_da_delib_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_progr_fi
           END)
             AS val_ret_tot_da_delib_firma,
          TO_NUMBER (NULL) AS val_ret_tot_da_delib_derivati,
          ---tot_da deliberare
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  + NVL (d.val_rdv_progr_fi, 0) /*+ pkg_mcrei_gest_delibere.fnc_mcrei_get_last_rinuncia (d.cod_abi, d.cod_ndg, 'CT')*/
                                               )                   --13 aprile
           END)
             AS tot_rettifica_da_delib,
          ----------------------
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_qc_progressiva
           END)
             AS val_rdv_tot_cassa,
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 d.val_rdv_progr_fi
           END)
             AS val_rdv_tot_firma,
          TO_NUMBER (NULL) AS val_rdv_tot_derivati,
          ------------------------
          (CASE
              WHEN (   d.cod_microtipologia_delib IN ('CI', 'CS', 'CH')
                    OR d.cod_macrotipologia_delib IN ('TP', 'DR'))
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rdv_qc_progressiva, 0)
                  + NVL (d.val_rdv_progr_fi, 0))
           END)
             AS val_rdv_tot,
          ------------------------
          --RINUNCE
          val_rinuncia_deliberata AS val_rinuncia_pregressa,
          (CASE
              WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
              THEN
                 TO_NUMBER (NULL)
              ELSE
                 (  NVL (d.val_rinuncia_capitale, 0)
                  + NVL (d.val_rinuncia_mora, 0))
           END)
             AS val_rinuncia_proposta,
          -------
          (CASE
              WHEN d.cod_microtipologia_delib IN ('CI', 'CS')
              THEN
                 TO_NUMBER (NULL)
              ELSE                                                 --23 aprile
                 NVL (d.val_imp_perdita, 0)
           /*(nvl(d.val_rinuncia_deliberata, 0) +
                                                                                                                                                                                                                                                 nvl(d.val_rinuncia_capitale, 0) + nvl(d.val_rinuncia_mora, 0))*/
           END)
             AS tot_rinuncia_da_delib,
          MAX (
             NVL (d.dta_scadenza, d.dta_scadenza_transaz)) -- 4 SET SU INDICAZIONE UTENTE
          OVER (
             PARTITION BY d.cod_protocollo_pacchetto,
                          d.cod_microtipologia_delib)
             AS dta_scad_variazione_proposta,
          MAX (
             NVL (d.dta_scadenza, d.dta_scadenza_transaz)) -- 4 SET SU INDICAZIONE UTENTE
          OVER (
             PARTITION BY d.cod_protocollo_pacchetto,
                          d.cod_microtipologia_delib)
             AS dta_scad_tot_da_deliberare,
          --24 APRILE
          cod_organo_calcolato,
          cod_organo_deliberante AS cod_od_effettivo,
          dta_delibera,
          dta_delibera_rete,
          dta_conferma_delibera,
          DECODE (flg_delib_in_linea,
                  'Y', 'SI',
                  'N', 'NO',
                  flg_delib_in_linea)
             AS flg_coerenza_con_parere,
          desc_note_coerenza,
          val_rdv_delib_banca_rete,
          /*seguono campi specifici delle transazioni a pronti*/
          cod_fase_delibera,
          val_stralcio_quota_cap,
          val_stralcio_quota_mora,
          dta_upd_fase_delibera AS dta_aggiornamento_stato,
          DECODE (cod_fase_delibera, 'CO', 'Y', 'N') flg_conferma,
          ---MODIFICATO IL 24/2
          cod_doc_delibera_banca,
          cod_doc_parere_conformita,
          cod_doc_appendice_parere,
          cod_doc_delibera_capogruppo,
          cod_doc_classificazione,
          cod_macrotipologia_delib,
          VAL_RINUNCIA_CAPITALE,
          VAL_RINUNCIA_MORA,
          DTA_LAST_UPD_DELIBERA,
          COD_TIPO_PACCHETTO,
          D.FLG_RISTRUTTURATO,
          D.COD_DELIBERA_MODIFICATO,
          A.COD_GRUPPO_SUPER,
          d.DTA_CONFERMA_PACCHETTO,
          a.DESC_NOME_CONTROPARTE
     FROM t_mcrei_app_delibere d,
          t_mcre0_app_istituti i,
          T_MCREI_CL_TIPOLOGIE TIP,
          t_mcre0_app_all_data a
    WHERE     d.cod_macrotipologia_delib = 'TP'
          AND d.cod_fase_pacchetto NOT IN ('ANA', 'ANM')
          AND d.cod_tipo_pacchetto != 'A'
          AND d.flg_no_delibera = '0'
          AND d.flg_attiva = '1'
          AND d.cod_abi = i.cod_abi
          AND d.cod_microtipologia_delib = tip.cod_microtipologia(+)
          AND d.cod_abi =
                 DECODE ( (SYS_CONTEXT ('userenv', 'client_info')),
                         '-', d.cod_abi,
                         (SYS_CONTEXT ('userenv', 'client_info')))
          AND (   d.cod_fase_microtipologia = 'ATT'
               OR (    d.cod_fase_microtipologia = 'CNF'
                   AND d.cod_microtipologia_delib IN
                          (SELECT cod_microtipologia
                             FROM t_mcrei_cl_tipologie
                            WHERE flg_contab_ademp = 1)))
          AND cod_fase_delibera IN                         --25.05 aggiunto CA
                                  ('CO', 'CA', 'CM', 'AT', 'RI', 'NR')
          AND D.COD_ABI = A.COD_ABI_CARTOLARIZZATO
          AND d.cod_ndg = a.cod_ndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_QUADRO_SINT_SNDG TO MCRE_USR;
