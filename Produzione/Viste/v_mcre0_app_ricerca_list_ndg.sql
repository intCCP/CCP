/* Formatted on 17/06/2014 18:03:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_NDG
(
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   ID_UTENTE,
   COGNOME,
   NOME,
   COD_GESTORE_MKT,
   DESC_ANAG_GESTORE_MKT,
   COD_STATO,
   COD_PROCESSO,
   DTA_DECORRENZA_STATO,
   VAL_TOT_UTILIZZO,
   VAL_TOT_ACCORDATO,
   VAL_TOT_SOSTITUZIONI,
   VAL_MAU,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_SUPER,
   FLG_OUTSOURCING,
   FLG_TARGET,
   ESISTE_DEL_ATTIVA,
   ESISTE_DEL_ATTIVA_SNDG
)
AS
   SELECT                                               -- 111111 v1 - solo IN
          -- 111121 v1.2- esiste_del_sndg
          -- 111121 - aggiunte ssostituzioni
          -- 0216 aggiunto filtro fase e no_delibera
          cod_comparto,
          x.cod_ramo_calcolato,
          x.cod_abi_istituto,
          x.desc_istituto,
          x.cod_abi_cartolarizzato,
          x.cod_ndg,
          x.cod_sndg,
          x.desc_nome_controparte,
          x.cod_gruppo_economico,
          x.desc_gruppo_economico val_ana_gre,
          NULLIF (x.id_utente, -1) id_utente,
          x.cognome,
          x.nome,
          x.cod_gestore_mkt,
          x.desc_anag_gestore_mkt,
          x.cod_stato,
          x.cod_processo,
          x.dta_decorrenza_stato,
          x.scsb_uti_tot val_tot_utilizzo,
          x.scsb_acc_tot val_tot_accordato,
          x.scsb_uti_sostituzioni val_tot_sostituzioni,
          x.gb_val_mau val_mau,
          x.cod_gruppo_legame,
          x.cod_gruppo_super,
          x.flg_outsourcing,
          x.flg_target,
          CASE
             WHEN x.cod_stato IN ('IN', 'RS') ----26 FEB: CORRETTO PER GESTIRE IMPIANTO RISTRUTTURATI CON STATO PRECEDENTE !='IN' E COD_sTATO= RS
             THEN
                CASE
                   WHEN (EXISTS
                            (SELECT cod_abi, cod_ndg
                               FROM t_mcrei_app_delibere d
                              WHERE     x.cod_abi_istituto = d.cod_abi
                                    AND x.cod_ndg = d.cod_ndg
                                    AND d.flg_attiva = '1'
                                    AND d.cod_fase_delibera NOT IN
                                           ('AN', 'VA')                --13dic
                                    AND d.flg_no_delibera = 0))
                   THEN
                      'Y'
                   ELSE
                      'N'
                END
             WHEN x.cod_stato_precedente = 'IN' --15 feb: aggiunto caso per rendere disponibile puntamento alla delibera anche per posiz con stato non pi? in incaglio
             THEN
                CASE
                   WHEN (EXISTS
                            (SELECT cod_abi, cod_ndg
                               FROM t_mcrei_app_delibere d
                              WHERE     x.cod_abi_istituto = d.cod_abi
                                    AND x.cod_ndg = d.cod_ndg
                                    AND d.flg_attiva = '1'
                                    AND d.cod_fase_delibera NOT IN
                                           ('AN', 'VA')                --13dic
                                    AND d.flg_no_delibera = 0))
                   THEN
                      'Y'
                   ELSE
                      'N'
                END
             ELSE
                CASE
                   WHEN (EXISTS
                            (SELECT cod_abi, cod_ndg
                               FROM t_mcrei_app_delibere d
                              WHERE     x.cod_abi_istituto = d.cod_abi
                                    AND x.cod_ndg = d.cod_ndg
                                    AND d.cod_microtipologia_delib IN
                                           ('CI', 'CS')
                                    AND d.flg_attiva = '1'
                                    AND d.cod_fase_delibera NOT IN
                                           ('AN', 'VA')                --13dic
                                    AND d.flg_no_delibera = 0))
                   THEN
                      'Y'
                   ELSE
                      'N'
                END
          END
             AS esiste_del_attiva,
          (SELECT esiste_del_attiva
             FROM v_mcre0_app_ricerca_list_sndg v
            WHERE v.cod_sndg = x.cod_sndg)
             AS esiste_del_attiva_sndg
     FROM v_mcre0_app_upd_fields_all x;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RICERCA_LIST_NDG TO MCRE_USR;
