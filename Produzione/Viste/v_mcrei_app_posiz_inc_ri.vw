/* Formatted on 17/06/2014 18:08:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_POSIZ_INC_RI
(
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
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
   DTA_SCADENZA_STATO,
   DTA_SERVIZIO,
   DTA_SCADENZA_PERM_SERVIZIO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   SCSB_ACC_TOT_CF,
   SCSB_ACC_TOT_D,
   SCSB_UTI_TOT_CF,
   SCSB_UTI_TOT_D,
   VAL_RDV_TOT,
   ULTIMA_TIPOLOGIA_CONF,
   DESC_ULTIMA_TIPOLOGIA_CONF,
   COD_TIPO_GESTIONE,
   DESC_TIPO_GESTIONE,
   VAL_NUM_PROGR_DELIBERA,
   COD_COMPARTO,
   ID_REFERENTE,
   COD_LIVELLO,
   COD_GRUPPO_SUPER
)
AS
   SELECT     --0215 aggiunto filtro no_delibera = 0 e pacchetto non annullato
          --0227 rimosso filtro no CI/CS
          --0328 - variato ordinamento rank
          --0426 - decorrenza incaglio da pratica
          cod_abi_istituto,
          desc_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          desc_nome_controparte,
          cod_sndg,
          cod_gruppo_economico,
          desc_gruppo_economico,
          cod_struttura_competente_dc,
          desc_struttura_competente_dc,
          cod_struttura_competente_dv,
          desc_struttura_competente_dv,
          cod_struttura_competente_rg,
          desc_struttura_competente_rg,
          cod_struttura_competente_ar,
          desc_struttura_competente_ar,
          cod_struttura_competente_fi,
          desc_struttura_competente_fi,
          cod_processo,
          cod_stato,
          cod_stato_precedente,
          dta_decorrenza_stato,
          dta_scadenza_stato,
          dta_servizio,
          dta_scadenza_perm_servizio,
          id_utente,
          dta_utente_assegnato,
          scsb_acc_tot_cf,
          scsb_acc_tot_d,
          scsb_uti_tot_cf,
          scsb_uti_tot_d,
          val_rdv_tot,
          ultima_tipologia_conf,
          desc_ultima_tipologia_conf,
          cod_tipo_gestione,
          desc_tipo_gestione,
          val_num_progr_delibera,
          cod_comparto,
          ID_REFERENTE,
          COD_LIVELLO,
          cod_gruppo_super
     FROM (SELECT /*DA ESEGUIRE PRIMA DELLA CHIAMATA ALLA VISTA
                BEGIN dbms_application_info.set_client_info( cod_matricola loggata ); END;*/
                  /*+ index(f IXU_T_MCRE0_APP_ALL_DATA) index(p PK_MCREI_APP_PRATICHE) index(de ixp_T_MCREI_APP_DELIBERE) */
                 f.cod_abi_istituto,
                 f.desc_istituto,
                 f.cod_abi_cartolarizzato,
                 f.cod_ndg,
                 f.desc_nome_controparte,
                 f.cod_sndg,
                 NULLIF (f.cod_gruppo_economico, '-1') cod_gruppo_economico,
                 f.desc_gruppo_economico AS desc_gruppo_economico,
                 nor.cod_struttura_competente_dc,
                 nor.desc_struttura_competente_dc,
                 nor.cod_struttura_competente_dv,
                 nor.desc_struttura_competente_dv,
                 nor.cod_struttura_competente_rg,
                 nor.desc_struttura_competente_rg,
                 nor.cod_struttura_competente_ar,
                 nor.desc_struttura_competente_ar,
                 nor.cod_struttura_competente_fi,
                 nor.desc_struttura_competente_fi,
                 f.cod_processo,
                 NULLIF (f.cod_stato, '-1') cod_stato,
                 NULLIF (f.cod_stato_precedente, '-1') cod_stato_precedente,
                 --f.dta_decorrenza_stato,
                 NVL (
                    CASE
                       WHEN f.cod_stato = 'IN' THEN p.dta_decorrenza_stato
                       ELSE f.dta_decorrenza_stato
                    END,
                    f.dta_decorrenza_stato)
                    AS dta_decorrenza_stato,
                 f.dta_scadenza_stato AS dta_scadenza_stato_mople,
                 dta_scadenza_stato AS dta_scadenza_stato, --10 feb, AD. richiesta correzione da ilaria su segnalazione utente
                 f.dta_servizio,
                 DECODE (pro.dta_esito,
                         NULL, f.dta_servizio + c.val_gg_prima_proroga,
                         pro.dta_esito + c.val_gg_seconda_proroga)
                    AS dta_scadenza_perm_servizio, --10 feb, AD. richiesta correzione da ilaria su segnalazione utente
                 NULLIF (f.id_utente, -1) id_utente,
                 f.dta_utente_assegnato,
                 r.scsb_acc_tot AS scsb_acc_tot_cf,             --cassa +firma
                 r.scsb_acc_sostituzioni AS scsb_acc_tot_d,         --derivati
                 r.scsb_uti_tot AS scsb_uti_tot_cf,             --cassa +firma
                 r.scsb_uti_sostituzioni AS scsb_uti_tot_d,         --derivati
                 ---30 marzo: modificato calcolo CA+FI per rdv totale
                 NVL (de.val_rdv_qc_progressiva, 0) + NVL (de.val_rdv_progr_fi, 0)
                    AS val_rdv_tot,
                 de.cod_microtipologia_delib AS ultima_tipologia_conf,
                 t.desc_microtipologia AS desc_ultima_tipologia_conf,
                 --NVL (de.desc_tipo_gestione, p.cod_tipo_gestione)
                 p.cod_tipo_gestione AS cod_tipo_gestione,             --6 GIU
                 NVL (DO.desc_dominio, 'Non Determinato') AS desc_tipo_gestione,
                 de.val_num_progr_delibera,
                 NVL (f.cod_comparto_assegnato,
                      NULLIF (f.cod_comparto_calcolato, '#'))
                    cod_comparto,
                 u.id_referente,
                 RANK ()
                 OVER (
                    PARTITION BY de.cod_abi, de.cod_ndg
                    ORDER BY
                       --decode(de.cod_fase_delibera, 'AD',1,'CO',1,3), commentato il 10 aprile
                       de.dta_conferma_delibera DESC NULLS LAST,
                       val_num_progr_delibera DESC)
                    rn,
                 C.COD_LIVELLO,
                 f.cod_gruppo_super
            FROM t_mcre0_app_all_data f,
                 t_mcre0_app_rio_proroghe pro,
                 t_mcre0_app_comparti c,
                 t_mcrei_app_pratiche p,
                 t_mcrei_app_delibere de,
                 mv_mcre0_denorm_str_org nor,
                 t_mcrei_cl_tipologie t,
                 t_mcre0_app_utenti u,
                 t_mcrei_cl_domini DO,
                 t_mcrei_app_pcr_rapp_aggr r
           WHERE     (   u.id_utente = SYS_CONTEXT ('userenv', 'client_info')
                      OR u.id_referente =
                            SYS_CONTEXT ('userenv', 'client_info'))
                 AND p.cod_abi = de.cod_abi
                 AND p.cod_ndg = de.cod_ndg
                 AND p.val_anno_pratica = de.val_anno_pratica
                 AND p.cod_pratica = de.cod_pratica
                 AND p.flg_attiva = '1'
                 AND de.flg_attiva = '1'
                 AND de.cod_fase_delibera NOT IN ('AN', 'NA', 'IN', 'VA') --13Dicembre
                 --ripristinato stato 'IN' il 4 maggio
                 ---SI VISUALIZZANO TUTTI GLI STATI TRANNE INSERITO,ANNULLATO O NON ADEMPIUTO
                 --escludo i no_delibera, e fasi annullate
                 AND de.flg_no_delibera = 0
                 AND de.cod_abi = r.cod_abi_cartolarizzato(+)
                 --9/3, outer il 13/6
                 AND de.cod_ndg = r.cod_ndg(+)
                 AND de.cod_fase_pacchetto NOT IN ('ANA', 'ANM')  --13Dicembre
                 AND p.cod_abi = f.cod_abi_cartolarizzato
                 AND p.cod_ndg = f.cod_ndg
                 AND f.cod_abi_cartolarizzato = pro.cod_abi_cartolarizzato(+)
                 AND f.cod_ndg = pro.cod_ndg(+)
                 AND pro.flg_storico(+) = 0
                 AND pro.flg_esito(+) = 1
                 AND NVL (f.cod_comparto_assegnato, cod_comparto_calcolato) =
                        c.cod_comparto(+)
                 AND p.cod_tipo_gestione = DO.val_dominio(+)
                 AND DO.cod_dominio(+) = 'TIPO_GESTIONE'
                 AND f.today_flg = '1'
                 AND f.flg_target = 'Y'                               --13 giu
                 AND f.flg_outsourcing = 'Y'                          --13 giu
                 AND f.cod_abi_cartolarizzato = nor.cod_abi_istituto_fi
                 AND f.cod_filiale = nor.cod_struttura_competente_fi
                 AND f.cod_stato IN ('IN', 'RS')
                 AND f.id_utente = u.id_utente
                 AND de.cod_microtipologia_delib = t.cod_microtipologia(+)
                 AND t.flg_attivo(+) = 1) s
    WHERE s.rn = 1;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_POSIZ_INC_RI TO MCRE_USR;
