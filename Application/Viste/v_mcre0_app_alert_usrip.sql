/* Formatted on 21/07/2014 18:33:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_USRIP
(
   VAL_ALERT,
   VAL_ORDINE_COLORE,
   DTA_INS_ALERT,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_SNDG,
   COD_NDG,
   DESC_ISTITUTO,
   COD_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
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
   COD_COMPARTO_POSIZIONE,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_UTENTE,
   DESC_NOME,
   DESC_COGNOME,
   DTA_LAST_RIPORTAF,
   ID_UTENTE_PRE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   ID_REFERENTE,
   DESC_NOME_CONTROPARTE,
   DESC_NOME_PRE,
   DESC_COGNOME_PRE,
   FLG_ABI_LAVORATO,
   VAL_UTI_TOT
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(u2)*/
                                           -- V1 ??/??/???? VG: prima versione
 -- V2 30/03/2011 MDM: Aggiunte  colonne "ID_REFERENTE", "COD_PRIV" e "FLG_GESTORE_ABILITATO"  per gestione visibilità in base al profilo utente
 -- V3 31/03/2011 LM: Aggiunte colonne "DESC_COGNOME_PRE", "DESC_NOME_PRE" e "DESC_NOME_CONTROPARTE" per recupero generalità cliente e gestore precedente
                               -- V4 31/03/2011 LM: Aggiunta colonna "COD_NDG"
                                         -- v5 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v6 06/05/2011 VG: COD_MACROSTATO
                                            -- v7 27/05/2011 VG: desc istituto
         ALERT_10 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_10,
                    'V', VAL_VERDE,
                    DECODE (ALERT_10,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_10, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 10)
            VAL_ORDINE_COLORE,
         DTA_INS_10 DTA_INS_ALERT,
         X.COD_ABI_CARTOLARIZZATO,
         X.COD_ABI_ISTITUTO,
         X.COD_SNDG,
         X.COD_NDG,
         X.DESC_ISTITUTO,
         X.COD_GRUPPO_ECONOMICO,
         X.COD_MACROSTATO,
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
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_RAMO_CALCOLATO,
         --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
         X.COD_COMPARTO_UTENTE,
         X.NOME DESC_NOME,
         X.COGNOME DESC_COGNOME,
         X.DTA_LAST_RIPORTAF,
         X.ID_UTENTE_PRE,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         X.ID_REFERENTE,
         X.DESC_NOME_CONTROPARTE,
         U2.NOME DESC_NOME_PRE,
         U2.COGNOME DESC_COGNOME_PRE,
         --i.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.SCSB_UTI_TOT VAL_UTI_TOT
    FROM T_MCRE0_APP_ALERT_POS A, --VNMCRE0_app_alert_pos a, todo: verificare che la sostituzione con la vista non abbia impatti imprevisti
         --   MV_MCRE0_app_istituti i,
         --   t_mcre0_app_anagrafica_gruppo g,
         --   MV_MCRE0_APP_UPD_field x,
         --   T_MCRE0_APP_ANAGR_GRE GE,
         --   MV_MCRE0_denorm_str_org s,
         --   t_mcre0_app_utenti u,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS X,
         T_MCRE0_APP_UTENTI U2
   WHERE     ALERT_10 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         --     AND x.cod_abi_istituto = i.cod_abi(+)
         --     AND x.cod_sndg = g.cod_sndg(+)
         --     AND x.cod_gruppo_economico = ge.cod_gre(+)
         --     AND x.cod_abi_istituto = s.cod_abi_istituto_fi(+)
         --     AND x.cod_filiale = s.cod_struttura_competente_fi(+)
         --     AND x.id_utente = u.id_utente(+)
         AND X.ID_UTENTE_PRE = U2.ID_UTENTE(+);
