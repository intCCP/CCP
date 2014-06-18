/* Formatted on 17/06/2014 18:08:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_POSIZ_CON_CLASSIF
(
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_NDG,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
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
   ID_UTENTE,
   STATO_PROPOSTO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO_MOPLE,
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_APERTURA_DELIBERA,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_ACC_TOT_D,
   SCSB_UTI_TOT_CF,
   SCSB_UTI_TOT_D,
   VAL_RDV_TOT,
   ULTIMA_TIPOLOGIA_CONF,
   DESC_ULTIMA_TIPOLOGIA_CONF,
   DTA_CONFERMA_DELIBERA,
   COD_MACROTIPOLOGIA_DELIB,
   COD_COMPARTO,
   ID_REFERENTE,
   COD_FASE_DELIBERA,
   COD_LIVELLO,
   DTA_SCADENZA_PERM_SERVIZIO,
   COD_GRUPPO_SUPER
)
AS
   SELECT /*+ index(de ixp_T_MCREI_APP_DELIBERE) index(f IXU_T_MCRE0_APP_ALL_DATA)  */
          --0215 aggiunto filtro per no-delibera = 0 e pacchetto non annullato
         f.cod_sndg,
         f.desc_nome_controparte,
         f.cod_ndg,
         f.cod_abi_istituto,
         f.desc_istituto,
         f.cod_abi_cartolarizzato,
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
         f.id_utente,
         DECODE (de.cod_microtipologia_delib,  'CI', 'IN',  'CS', 'SO')
            AS stato_proposto,
         f.dta_decorrenza_stato,
         f.dta_scadenza_stato AS dta_scadenza_stato_mople,
         dta_scadenza_stato AS dta_scadenza_stato, --12 feb, AD. richiesta correzione da ilaria su segnalazione utente
         f.dta_servizio,
         de.dta_ins_delibera AS dta_apertura_delibera,
         f.dta_utente_assegnato,
         r.scsb_acc_tot AS scsb_acc_tot_cf,
         --ACC CASSA+FIRMA
         r.scsb_acc_sostituzioni AS scsb_acc_tot_d,             --ACC DERIVATI
         r.scsb_uti_tot AS scsb_uti_tot_cf,                  --ACC CASSA+FIRMA
         r.scsb_uti_sostituzioni AS scsb_uti_tot_d,             --ACC DERIVATI
         de.val_rdv_qc_progressiva AS val_rdv_tot,
         de.cod_microtipologia_delib AS ultima_tipologia_conf,
         t.desc_microtipologia AS desc_ultima_tipologia_conf,
         de.dta_conferma_delibera,
         de.cod_macrotipologia_delib,
         NVL (f.cod_comparto_assegnato, f.cod_comparto_calcolato) cod_comparto,
         u.id_referente,
         cod_fase_delibera,
         c.cod_livello,
         DECODE (pro.dta_esito,
                 NULL, f.dta_servizio + c.val_gg_prima_proroga,
                 PRO.DTA_ESITO + C.VAL_GG_SECONDA_PROROGA)
            AS DTA_SCADENZA_PERM_SERVIZIO,
         f.cod_gruppo_super
    FROM t_mcrei_app_delibere de,
         t_mcre0_app_all_data f,
         t_mcre0_app_rio_proroghe pro,
         t_mcre0_app_comparti c,
         mv_mcre0_denorm_str_org nor,
         t_mcrei_cl_tipologie t,
         t_mcre0_app_utenti u,
         t_mcrei_app_pcr_rapp_aggr r                                    ---9/3
   WHERE     (   u.id_utente = SYS_CONTEXT ('userenv', 'client_info')
              OR u.id_referente = SYS_CONTEXT ('userenv', 'client_info'))
         AND de.cod_abi = f.cod_abi_cartolarizzato
         AND de.cod_ndg = f.cod_ndg
         -- AND de.cod_microtipologia_delib IN ('CI', 'CS') Cambiato con filtro su cod_famiglia_tipologia 17.04.2012
         AND f.flg_target = 'Y'                                       --13 GIU
         AND f.flg_outsourcing = 'Y'                                  --13 GIU
         AND f.today_flg = '1'
         AND f.cod_abi_cartolarizzato = pro.cod_abi_cartolarizzato(+)
         AND f.cod_ndg = pro.cod_ndg(+)
         AND pro.flg_storico(+) = 0
         AND pro.flg_esito(+) = 1
         AND NVL (f.cod_comparto_assegnato, cod_comparto_calcolato) =
                c.cod_comparto(+)
         AND t.cod_famiglia_tipologia IN ('DCLI', 'DCLS')
         AND t.flg_attivo(+) = 1                       --- aggiunto outer 24/2
         AND de.cod_pratica IS NULL
         AND de.flg_attiva = '1'
         AND de.cod_tipo_pacchetto = 'M'
         AND de.cod_microtipologia_delib = t.cod_microtipologia
         --escludo i no_delibera, e fasi annullate
         AND de.flg_no_delibera = 0
         AND de.cod_fase_pacchetto NOT IN ('ANA', 'ANM')          --13Dicembre
         ---SI VISUALIZZANO TUTTI GLI STATI TRANNE INSERITO,ANNULLATO O NON ADEMPIUTO
         AND de.cod_fase_delibera NOT IN ('AN', 'NA', 'VA')       --13Dicembre
         AND de.cod_abi = r.cod_abi_cartolarizzato(+)
         AND de.cod_ndg = r.cod_ndg(+)                                --13 giu
         AND f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
         AND f.cod_filiale = nor.cod_struttura_competente_fi
         AND f.id_utente = u.id_utente;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_POSIZ_CON_CLASSIF TO MCRE_USR;
