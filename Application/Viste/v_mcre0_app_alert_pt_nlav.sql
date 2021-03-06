/* Formatted on 21/07/2014 18:32:42 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_PT_NLAV
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
   DTA_CONVOCAZIONE,
   DTA_PIANO_CONFERMA_AREA,
   DTA_DEADLINE_INS_PARERE_AREA,
   DTA_PIANO,
   DTA_VERBALE,
   COD_PRIV,
   FLG_GESTORE_ABILITATO,
   FLG_ABI_LAVORATO,
   VAL_UTI_TOT
)
AS
   SELECT /*+ordered no_parallel(a) no_parallel(t)*/
                                           -- V1 ??/??/???? VG: prima versione
 -- V2 29/03/2011 MDM: Aggiunte  colonne "COD_PRIV" e "FLG_GESTORE_ABILITATO"  per gestione visibilita in base al profilo utente
                               -- v3 06/04/2011 VG: sistemate condizioni where
                                         -- v4 20/04/2011 VG: FLG_ABI_LAVORATO
                                           -- v5 06/05/2011 VG: COD_MACROSTATO
         ALERT_13 VAL_ALERT,
         (SELECT DECODE (
                    ALERT_13,
                    'V', VAL_VERDE,
                    DECODE (ALERT_13,
                            'A', VAL_ARANCIO,
                            DECODE (ALERT_13, 'R', VAL_ROSSO, NULL)))
            FROM T_MCRE0_APP_ALERT
           WHERE ID_ALERT = 13)
            VAL_ORDINE_COLORE,
         DTA_INS_13 DTA_INS_ALERT,
         A.COD_SNDG,
         A.COD_ABI_CARTOLARIZZATO,
         A.COD_ABI_ISTITUTO,
         X.DESC_ISTITUTO,
         A.COD_NDG,
         X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
         X.COD_MACROSTATO,
         --  NVL (u.cod_comparto_assegn, u.cod_comparto_appart) cod_comparto_utente
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
         T.DTA_CONVOCAZIONE,
         T.DTA_PIANO_CONFERMA_AREA,
         T.DTA_DEADLINE_INS_PARERE_AREA,
         T.DTA_PIANO,
         T.DTA_VERBALE,
         X.COD_PRIV,
         X.FLG_GESTORE_ABILITATO,
         --I.FLG_ABI_LAVORATO,
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         X.SCSB_UTI_TOT VAL_UTI_TOT
    FROM T_MCRE0_APP_ALERT_POS A,
         -- MV_MCRE0_app_istituti i,
         -- t_mcre0_app_anagrafica_gruppo g,
         --   MV_MCRE0_APP_UPD_field x,
         --   T_MCRE0_APP_ANAGR_GRE GE,
         --   MV_MCRE0_denorm_str_org s,
         --   t_mcre0_app_utenti u,
         T_MCRE0_APP_PT_GESTIONE_TAVOLI T,
         -- V_MCRE0_APP_UPD_FIELDS_ALL x
         -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
         V_MCRE0_APP_UPD_FIELDS X
   WHERE     ALERT_13 IS NOT NULL
         --AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         AND X.FLG_OUTSOURCING = 'Y'
         -- AND I.FLG_TARGET = 'Y'
         AND X.FLG_TARGET = 'Y'
         AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
         AND X.COD_NDG = A.COD_NDG
         --    AND x.cod_abi_istituto = i.cod_abi(+)
         --    AND x.cod_sndg = g.cod_sndg(+)
         --    AND x.cod_gruppo_economico = ge.cod_gre(+)
         --  AND x.cod_abi_istituto = x.cod_abi_istituto_fi(+)
         --  AND x.cod_filiale = x.cod_struttura_competente_fi(+)
         --  AND x.id_utente = u.id_utente(+)
         AND X.COD_ABI_CARTOLARIZZATO = T.COD_ABI_CARTOLARIZZATO(+)
         AND X.COD_NDG = T.COD_NDG(+);
