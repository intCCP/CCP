/* Formatted on 17/06/2014 18:00:41 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_RIO_DAPROROG
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_SNDG,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_COMPARTO_POSIZIONE,
   COD_MACROSTATO,
   COD_COMPARTO_UTENTE,
   COD_RAMO_CALCOLATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
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
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   ID_UTENTE,
   DTA_UTENTE_ASSEGNATO,
   DESC_NOME,
   DESC_COGNOME,
   ID_REFERENTE,
   DTA_SERVIZIO,
   DTA_ULTIMA_PROROGA,
   DTA_LIMITE_PROROGA,
   COD_OD,
   COD_ORG_DELIB,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   VAL_MOTIVO_RICHIESTA,
   DESC_OD,
   DESC_ORG_DELIB,
   FLG_ABI_LAVORATO,
   COD_LIVELLO,
   VAL_UTI_TOT,
   COD_GRUPPO_SUPER
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                         -- v1 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v2 06/05/2011 VG: COD_MACROSTATO
         ALERT_18 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_18,
                    'V', VAL_VERDE,
                    DECODE (ALERT_18,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_18, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 18)
            VAL_ORDINE_COLORE,
         DTA_INS_18 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_MACROSTATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         X.COD_COMPARTO_UTENTE,
         X.COD_RAMO_CALCOLATO,
         X.DESC_NOME_CONTROPARTE,
         X.COD_GRUPPO_ECONOMICO,
         X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
         X.COD_STRUTTURA_COMPETENTE_DC,
         X.DESC_STRUTTURA_COMPETENTE_DC,
         X.COD_STRUTTURA_COMPETENTE_RG,
         X.DESC_STRUTTURA_COMPETENTE_RG,
         X.COD_STRUTTURA_COMPETENTE_AR,
         X.DESC_STRUTTURA_COMPETENTE_AR,
         X.COD_STRUTTURA_COMPETENTE_FI,
         X.DESC_STRUTTURA_COMPETENTE_FI,
         X.COD_PROCESSO,
         X.COD_STATO,
         X.DTA_DECORRENZA_STATO,
         X.DTA_SCADENZA_STATO,
         X.ID_UTENTE,
         X.DTA_UTENTE_ASSEGNATO,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.ID_REFERENTE,
         DECODE (x.cod_livello, 'DC', X.DTA_SERVIZIO, NULL) DTA_SERVIZIO, ----28/12 AD: modificata per estensione aree/regioni
         T.DTA_ESITO DTA_ULTIMA_PROROGA,
         DECODE (
            X.COD_LIVELLO,
            'DC',         ----28/12 AD: modificata per estensione aree/regioni
                  (DECODE (DTA_ESITO,
                           NULL, DTA_SERVIZIO + X.VAL_GG_PRIMA_PROROGA,
                           DTA_ESITO + X.VAL_GG_SECONDA_PROROGA)),
            NULL)
            AS DTA_LIMITE_PROROGA,
         --11.26 DECODE (VAL_NUM_PROROGHE, NULL, NULL, 1, X.VAL_OD_PRIMA_PROROGA,X.VAL_OD_SECONDA_PROROGA)
         DECODE (dta_esito,
                 NULL, x.val_od_prima_proroga,
                 x.val_od_seconda_proroga)
            COD_OD,
         --1giu decodifico l'ID_SERVIZIO sul vero OD
         --11.26
         --       (SELECT   cod_organo_deliberante
         --       FROM  t_mcre0_cl_org_delib
         --       WHERE   id_servizio = DECODE (T.DTA_ESITO,
         --           NULL, X.VAL_OD_PRIMA_PROROGA,X.VAL_OD_SECONDA_PROROGA)
         --          AND cod_abi = '01025' AND '0' || cod_uo = X.COD_COMPARTO)
         (SELECT cod_organo_deliberante
            FROM t_mcre0_cl_org_delib
           WHERE     id_servizio =
                        DECODE (t.dta_esito,
                                NULL, x.val_od_prima_proroga,
                                x.val_od_seconda_proroga)
                 AND cod_abi = '01025'
                 AND '0' || cod_uo = x.cod_comparto)
            COD_ORG_DELIB,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         T.VAL_MOTIVO_RICHIESTA,
         --       (SELECT   NOME_GRUPPO
         --       FROM  T_MCRE0_APP_PR_LOV_GRUPPI
         --       WHERE   ID_GRUPPO =
         --        DECODE (VAL_NUM_PROROGHE,NULL, NULL,
         --         1, X.VAL_OD_PRIMA_PROROGA, X.VAL_OD_SECONDA_PROROGA))
         (SELECT nome_gruppo
            FROM t_mcre0_app_pr_lov_gruppi
           WHERE id_gruppo =
                    DECODE (t.dta_esito,
                            NULL, x.val_od_prima_proroga,
                            x.val_od_seconda_proroga))
            DESC_OD,
         --1giu decodifico l'ID_SERVIZIO sul vero OD
         --       (SELECT   DESC_ORGANO_DELIBERANTE
         --       FROM  T_MCRE0_CL_ORGANI_DELIBERANTI
         --       WHERE   COD_ORGANO_DELIBERANTE =
         --          (SELECT cod_organo_deliberante
         --          FROM  t_mcre0_cl_org_delib
         --           WHERE  id_servizio = DECODE (T.DTA_ESITO,
         --              NULL, X.VAL_OD_PRIMA_PROROGA, X.VAL_OD_SECONDA_PROROGA)
         --            AND cod_abi = '01025'  AND '0' || cod_uo = X.COD_COMPARTO)
         --          AND cod_abi_istituto = '01025')
         (SELECT desc_organo_deliberante
            FROM t_mcre0_cl_organi_deliberanti
           WHERE     cod_organo_deliberante =
                        (SELECT cod_organo_deliberante
                           FROM t_mcre0_cl_org_delib
                          WHERE     id_servizio =
                                       DECODE (t.dta_esito,
                                               NULL, x.val_od_prima_proroga,
                                               x.val_od_seconda_proroga)
                                AND cod_abi = '01025'
                                AND '0' || cod_uo = x.cod_comparto)
                 AND cod_abi_istituto = '01025')
            DESC_ORG_DELIB,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         x.cod_livello,
         X.SCSB_UTI_TOT VAL_UTI_TOT,
         x.cod_gruppo_super
    FROM T_MCRE0_APP_ALERT_POS A,             --      MV_MCRE0_app_istituti i,
         --    t_mcre0_app_anagrafica_gruppo g,
         --    MV_MCRE0_APP_UPD_field x,
         --    T_MCRE0_APP_ANAGR_GRE GE,
         --    MV_MCRE0_denorm_str_org s,
         --    T_MCRE0_APP_UTENTI U,
         T_MCRE0_APP_RIO_PROROGHE T,               --  T_MCRE0_APP_COMPARTI C,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_18 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND T.FLG_STORICO(+) = 0
         AND T.FLG_ESITO(+) = 1
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = T.COD_NDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_ALERT_RIO_DAPROROG TO MCRE_USR;
