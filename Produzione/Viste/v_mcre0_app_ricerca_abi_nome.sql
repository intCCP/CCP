/* Formatted on 17/06/2014 18:03:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_RICERCA_ABI_NOME
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
   WITH v0
        AS (SELECT cod_sndg
              FROM (SELECT cod_sndg, desc_nome_controparte
                      FROM t_mcre0_app_anagrafica_gruppo
                     WHERE UPPER (desc_nome_controparte) LIKE
                                 '%'
                              || SYS_CONTEXT ('userenv', 'client_info')
                              || '%')
             WHERE (   UPPER (desc_nome_controparte) LIKE
                          SYS_CONTEXT ('userenv', 'client_info') || '%'
                    OR UPPER (desc_nome_controparte) LIKE
                             '% '
                          || SYS_CONTEXT ('userenv', 'client_info')
                          || '%')),
        v1
        AS (SELECT                                      -- 111111 v1 - solo IN
                   -- 111121 v1.2- esiste_del_sndg
                   -- 111121 - aggiunte ssostituzioni
                   cod_comparto,
                   x.cod_ramo_calcolato,
                   x.cod_abi_istituto,
                   x.desc_istituto,
                   x.cod_abi_cartolarizzato,
                   x.cod_ndg,
                   x.cod_sndg,
                   x.desc_nome_controparte,
                   NULLIF (x.cod_gruppo_economico, '-1') cod_gruppo_economico,
                   x.desc_gruppo_economico val_ana_gre,
                   NULLIF (x.id_utente, -1) id_utente,
                   u.cognome,
                   u.nome,
                   x.cod_gestore_mkt,
                   x.desc_anag_gestore_mkt,
                   NULLIF (x.cod_stato, '-1') cod_stato,
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
                      WHEN x.cod_stato = 'IN'
                      THEN
                         CASE
                            WHEN (EXISTS
                                     (SELECT cod_abi, cod_ndg
                                        FROM t_mcrei_app_delibere d
                                       WHERE     x.cod_abi_istituto =
                                                    d.cod_abi
                                             AND x.cod_ndg = d.cod_ndg
                                             AND d.flg_attiva = '1'
                                             AND d.cod_fase_delibera NOT IN
                                                    ('AN', 'VA')       --13dic
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
                                       WHERE     x.cod_abi_istituto =
                                                    d.cod_abi
                                             AND x.cod_ndg = d.cod_ndg
                                             AND d.cod_microtipologia_delib IN
                                                    ('CI', 'CS')
                                             AND d.flg_attiva = '1'
                                             AND d.cod_fase_delibera NOT IN
                                                    ('AN', 'VA')       --13dic
                                             AND d.flg_no_delibera = 0))
                            THEN
                               'Y'
                            ELSE
                               'N'
                         END
                   END
                      AS esiste_del_attiva,
                   CASE
                      WHEN EXISTS
                              (SELECT cod_abi, cod_ndg
                                 FROM t_mcrei_app_delibere d
                                WHERE     x.cod_sndg = d.cod_sndg
                                      AND d.flg_attiva = '1'
                                      AND d.cod_fase_delibera NOT IN
                                             ('AN', 'VA')              --13dic
                                      AND d.flg_no_delibera = 0)
                      THEN
                         'Y'
                      ELSE
                         'N'
                   END
                      AS esiste_del_attiva_sndg
              FROM v_mcre0_app_upd_fields_pall x, t_mcre0_app_utenti u
             WHERE x.id_utente = u.id_utente)
   SELECT v1."COD_COMPARTO",
          v1."COD_RAMO_CALCOLATO",
          v1."COD_ABI_ISTITUTO",
          v1."DESC_ISTITUTO",
          v1."COD_ABI_CARTOLARIZZATO",
          v1."COD_NDG",
          v1."COD_SNDG",
          v1."DESC_NOME_CONTROPARTE",
          v1."COD_GRUPPO_ECONOMICO",
          v1."VAL_ANA_GRE",
          v1."ID_UTENTE",
          v1."COGNOME",
          v1."NOME",
          v1."COD_GESTORE_MKT",
          v1."DESC_ANAG_GESTORE_MKT",
          v1."COD_STATO",
          v1."COD_PROCESSO",
          v1."DTA_DECORRENZA_STATO",
          v1."VAL_TOT_UTILIZZO",
          v1."VAL_TOT_ACCORDATO",
          v1."VAL_TOT_SOSTITUZIONI",
          v1."VAL_MAU",
          v1."COD_GRUPPO_LEGAME",
          v1."COD_GRUPPO_SUPER",
          v1."FLG_OUTSOURCING",
          v1."FLG_TARGET",
          v1."ESISTE_DEL_ATTIVA",
          v1."ESISTE_DEL_ATTIVA_SNDG"
     FROM v1, v0
    WHERE v1.cod_sndg = v0.cod_sndg;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_RICERCA_ABI_NOME TO MCRE_USR;
