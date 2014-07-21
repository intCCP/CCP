/* Formatted on 21/07/2014 18:40:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_POSIZ_PAST_DUE
(
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO_MOPLE,
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_SCADENZA_PERM_SERVIZIO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_ACC_TOT_D,
   SCSB_UTI_TOT_CF,
   SCSB_UTI_TOT_D,
   COD_COMPARTO,
   ID_REFERENTE,
   COD_LIVELLO,
   COD_GRUPPO_SUPER
)
AS
   SELECT f.cod_abi_istituto,
          f.desc_istituto,
          f.cod_abi_cartolarizzato,
          f.cod_ndg,
          f.desc_nome_controparte,
          f.cod_sndg,
          NULLIF (f.cod_gruppo_economico, '-1') cod_gruppo_economico,
          f.desc_gruppo_economico AS desc_gruppo_economico,
          nor.cod_struttura_competente_dv,
          nor.desc_struttura_competente_dv,
          nor.cod_struttura_competente_dc,
          nor.desc_struttura_competente_dc,
          nor.cod_struttura_competente_rg,
          nor.desc_struttura_competente_rg,
          nor.cod_struttura_competente_ar,
          nor.desc_struttura_competente_ar,
          nor.cod_struttura_competente_fi,
          nor.desc_struttura_competente_fi,
          f.cod_processo,
          NULLIF (f.cod_stato, '-1') cod_stato,
          NULLIF (f.cod_stato_precedente, '-1') cod_stato_precedente,
          f.dta_decorrenza_stato,
          f.dta_scadenza_stato AS dta_scadenza_stato_mople,
          dta_scadenza_stato AS dta_scadenza_stato, --12 feb, AD. richiesta correzione da ilaria su segnalazione utente
          f.dta_servizio,
          DECODE (pro.dta_esito,
                  NULL, f.dta_servizio + c.val_gg_prima_proroga,
                  pro.dta_esito + c.val_gg_seconda_proroga)
             AS dta_scadenza_perm_servizio,                      --12 febbraio
          NULLIF (f.id_utente, -1) id_utente,
          f.dta_utente_assegnato,
          r.scsb_acc_tot AS scsb_acc_tot_cf,                    --cassa +firma
          r.scsb_acc_sostituzioni AS scsb_acc_tot_d,                --derivati
          r.scsb_uti_tot AS scsb_uti_tot_cf,                    --cassa +firma
          r.scsb_uti_sostituzioni AS scsb_uti_tot_d,                --derivati
          NVL (f.cod_comparto_assegnato,
               NULLIF (f.cod_comparto_calcolato, '#'))
             COD_COMPARTO,
          U.ID_REFERENTE,
          C.COD_LIVELLO,
          F.COD_GRUPPO_SUPER
     FROM t_mcre0_app_all_data f,
          t_mcre0_app_rio_proroghe pro,
          t_mcre0_app_comparti c,
          mv_mcre0_denorm_str_org nor,
          t_mcre0_app_utenti u,
          t_mcrei_app_pcr_rapp_aggr r
    WHERE     f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
          AND f.cod_filiale = nor.cod_struttura_competente_fi
          AND f.cod_abi_cartolarizzato = r.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = r.cod_ndg(+)
          AND f.cod_stato IN ('XC', 'XS')
          AND f.flg_target = 'Y'                                      --13 GIU
          AND f.flg_outsourcing = 'Y'                                 --13 GIU
          AND f.today_flg = '1'
          AND f.cod_abi_cartolarizzato = pro.cod_abi_cartolarizzato(+)
          AND f.cod_ndg = pro.cod_ndg(+)
          AND pro.flg_storico(+) = 0
          AND pro.flg_esito(+) = 1
          AND NVL (f.cod_comparto_assegnato, cod_comparto_calcolato) =
                 c.cod_comparto(+)
          AND f.id_utente = u.id_utente
          AND NOT EXISTS
                     (SELECT /*+ INDEX(de PK_MCREI_APP_DELIBERE) */
                            1
                        FROM t_mcrei_app_delibere de, t_mcrei_cl_tipologie t
                       WHERE     t.cod_famiglia_tipologia IN ('DCLI', 'DCLS')
                             -- de.cod_microtipologia_delib IN ('CI', 'CS') -- 17.04.2012
                             AND de.cod_microtipologia_delib =
                                    t.cod_microtipologia
                             AND de.cod_abi = f.cod_abi_cartolarizzato
                             AND de.cod_ndg = f.cod_ndg
                             AND de.flg_attiva = '1'
                             AND de.flg_no_delibera = 0
                             AND de.cod_fase_delibera NOT IN
                                    ('AN', 'VA', 'AS')
                             AND t.flg_attivo = 1);
