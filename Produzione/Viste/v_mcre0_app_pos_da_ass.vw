/* Formatted on 17/06/2014 18:02:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_POS_DA_ASS
(
   ID_ALERT,
   VAL_ORDINE_COLORE,
   DESC_ALERT,
   VAL_ALERT,
   DTA_INS_ALERT,
   COD_COMPARTO,
   DESC_COMPARTO,
   COD_RAMO_CALCOLATO,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   VAL_ANA_GRE,
   COD_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_GRUPPO,
   FLG_CONDIVISO,
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
   COD_MACROSTATO,
   DTA_DECORRENZA_STATO,
   COD_STATO_DESTINAZIONE,
   ID_UTENTE_GIRATO_DA,
   DESC_UTENTE_GIRATO_DA,
   DESC_ISTITUTO,
   FLG_OUTSOURCING,
   ID_UTENTE_PRE,
   ID_UTENTE_PREASSEGNATO,
   DESC_COGNOME_PREASS,
   DESC_NOME_PREASS,
   COD_COMPARTO_PREASSEGNATO,
   DESC_COMPARTO_PREASS,
   COD_MATR_ASSEGNATORE,
   FLG_ABI_LAVORATO,
   FLG_BLOCCO,
   FLG_GIROCOMPARTO,
   COD_GRUPPO_COMPARTI,
   FLG_COMPARTI_FILTRO,
   FILIALE
)
AS
   SELECT                                       -- V1 02/12/2010 VG: Congelata
          --  17/12/2010 MM aggiunto grupppo Super
          -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
          -- V3 30/12/2010 ML: modifica clausola AND co2.cod_comparto=f.cod_comparto_preassegnato con OUTER JOIN e aggiunta flag gruppo / Legame
          -- VG 26/01/2011 Outsourcing e target
          -- VG 02/01/2011 vista alert sostituita con tabella
          -- VG 08/06/2011 TOLTA FILE_GUIDA
          -- 110921: flg_alert anzichè stato_chk
          -- VG  21/05/2012  flg_blocco (Commenti con label:   VG - CIB/BDT - INIZIO)
          --18/03/2012 TB:Aggiunto campo Filiale
          DISTINCT
          DECODE (P.ALERT_5, NULL, 9, 5) ID_ALERT,
          (SELECT DECODE (
                     ALERT_5,
                     'V', VAL_VERDE,
                     DECODE (ALERT_5,
                             'A', VAL_ARANCIO,
                             DECODE (ALERT_5, 'R', VAL_ROSSO, NULL)))
             FROM T_MCRE0_APP_ALERT
            WHERE ID_ALERT = 5)
             VAL_ORDINE_COLORE,
          (SELECT R.DESC_ALERT
             FROM T_MCRE0_APP_ALERT R
            WHERE R.ID_ALERT = DECODE (P.ALERT_5, NULL, 9, 5))
             DESC_ALERT,
          NVL (P.ALERT_5, P.ALERT_9) VAL_ALERT,
          NVL (P.DTA_INS_5, P.DTA_INS_9) DTA_INS_ALERT,
          X.COD_COMPARTO,
          X.DESC_COMPARTO,
          X.COD_RAMO_CALCOLATO,
          X.COD_ABI_ISTITUTO,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          X.COD_SNDG,
          X.DESC_NOME_CONTROPARTE,
          X.COD_GRUPPO_ECONOMICO,
          X.COD_GRUPPO_SUPER,
          X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          LE.COD_LEGAME,
          X.FLG_GRUPPO_ECONOMICO,
          X.FLG_GRUPPO_LEGAME,
          X.FLG_SINGOLO,
          DECODE (X.FLG_GRUPPO_ECONOMICO,
                  1, 'G',
                  DECODE (X.FLG_GRUPPO_LEGAME, 1, 'L', 'S'))
             FLG_GRUPPO,
          X.FLG_CONDIVISO,
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
          X.COD_MACROSTATO,
          X.DTA_DECORRENZA_STATO,
          ' ' COD_STATO_DESTINAZIONE,
          X.COD_OPERATORE_INS_UPD ID_UTENTE_GIRATO_DA,
          U.COGNOME || ' ' || U.NOME DESC_UTENTE_GIRATO_DA,
          X.DESC_ISTITUTO,
          X.FLG_OUTSOURCING,
          -- verificare se è quello dell'istituto
          NULLIF (X.ID_UTENTE_PRE, -1) ID_UTENTE_PRE,
          X.ID_UTENTE_PREASSEGNATO,
          U2.COGNOME DESC_COGNOME_PREASS,
          U2.NOME DESC_NOME_PREASS,
          X.COD_COMPARTO_PREASSEGNATO,
          CO2.DESC_COMPARTO DESC_COMPARTO_PREASS,
          X.COD_MATR_ASSEGNATORE,
          DECODE (
             DTA_ABI_ELAB,
             (SELECT MAX (DTA_ELABORAZIONE) DTA_ABI_ELAB_MAX
                FROM T_MCRE0_APP_ABI_ELABORATI), '1',
             '0')
             FLG_ABI_LAVORATO,
          --------------------   VG - CIB/BDT - INIZIO --------------------
          flg_blocco,
          X.FLG_GIROCOMPARTO,
          X.COD_GRUPPO_COMPARTI,
          X.FLG_COMPARTI_FILTRO,
          -------------------- VG - CIB/BDT - FINE --------------------
          X.COD_FILIALE
     FROM V_MCRE0_APP_UPD_FIELDS X,
          --  t_mcre0_app_anagrafica_gruppo a,
          --   mv_mcre0_denorm_str_org s,
          --   mcre_own.mv_mcre0_app_istituti i,
          --    t_mcre0_app_comparti co,
          T_MCRE0_APP_COMPARTI CO2,
          T_MCRE0_APP_ALERT_POS P,
          --   t_mcre0_app_anagr_gre ge,
          T_MCRE0_APP_GRUPPO_LEGAME LE,
          T_MCRE0_APP_UTENTI U,
          T_MCRE0_APP_UTENTI U2
    WHERE --  co.cod_comparto = x.cod_comparto     --nvl(f.cod_comparto_calcolato,f.cod_comparto_assegnato) --
              -- AND co.flg_chk = 1
              --and
              X.FLG_CHK = '1'
          AND X.COD_COMPARTO_PREASSEGNATO = CO2.COD_COMPARTO(+)
          AND (P.ALERT_5 IS NOT NULL OR P.ALERT_9 IS NOT NULL)
          /* nota: non ci sarà più null bensì codice tappo
             -- AND x.id_utente IS NULL
            null diventa -1              */
          AND X.ID_UTENTE = -1
          AND X.COD_OPERATORE_INS_UPD = U.COD_MATRICOLA(+)
          AND X.ID_UTENTE_PREASSEGNATO = U2.ID_UTENTE(+)
          /**/
          AND X.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
          AND X.COD_NDG = P.COD_NDG
          --   AND x.cod_sndg = a.cod_sndg(+)
          --   AND x.cod_gruppo_economico = ge.cod_gre(+)
          AND X.COD_SNDG = LE.COD_SNDG(+)
          --   AND x.cod_abi_istituto = x.cod_abi_istituto_fi(+)
          --    AND x.cod_filiale = x.cod_struttura_competente_fi(+)
          --    AND x.cod_abi_cartolarizzato = i.cod_abi(+)
          AND X.FLG_ALERT = '1'
          --     AND x.cod_stato IN (SELECT cod_microstato
          --           FROM t_mcre0_app_stati s
          --            WHERE x.flg_stato_chk = 1)
          --     AND NVL (x.flg_outsourcing, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'
          AND X.FLG_TARGET = 'Y'
          AND DECODE (P.ALERT_5, NULL, 9, 5) = 5;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_POS_DA_ASS TO MCRE_USR;
