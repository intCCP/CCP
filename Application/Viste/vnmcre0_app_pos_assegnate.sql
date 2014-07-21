/* Formatted on 21/07/2014 18:45:26 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_POS_ASSEGNATE
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_COMPARTO,
   COD_RAMO_CALCOLATO,
   FLG_GRUPPO,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_SUPER,
   VAL_ANA_GRE,
   COD_GRUPPO_LEGAME,
   COD_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
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
   ID_UTENTE,
   DESC_COGNOME,
   DTA_UTENTE_ASSEGNATO,
   COD_MATR_ASSEGNATORE,
   ID_UTENTE_PREASSEGNATO,
   COD_SEZIONE_PREASSEGNATA,
   FLG_ABI_LAVORATO,
   DESC_ISTITUTO,
   FLG_OUTSOURCING
)
AS
   SELECT                                          -- V1 22/12/2010 VG: Creata
          -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
          -- V3 31/12/2010 ML: Aggiunti COD_GRUPPO_SUPER e FLG gruppo/legame
          -- V4 05/01/2011 ML: aggiunta clausola AND F.COD_SNDG= LE.COD_SNDG(+) al posto di AND F.COD_GRUPPO_LEGAME = LE.COD_GRUPPO_LEGAME(+)
          -- V5 12/01/2011 ML: aggiunto campo ID_UTENTE_PREASSEGNATO
          -- V6 12/01/2011 MM: flg_outsourcing da mople
          -- V7 17/02/2011 VG: upd_field
          -- v8 09/05/2011 MM: esposto cod_sezione_preass
          -- V9 17/02/2011 VG: tolta File_Guida
          X.COD_ABI_ISTITUTO,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_NDG,
          X.COD_SNDG,
          DESC_NOME_CONTROPARTE,
          X.COD_COMPARTO,
          X.COD_RAMO_CALCOLATO,
          DECODE (x.FLG_GRUPPO_ECONOMICO,
                  1, 'G',
                  DECODE (x.FLG_GRUPPO_LEGAME, 1, 'L', 'S'))
             FLG_GRUPPO,
          X.COD_GRUPPO_ECONOMICO,
          x.COD_GRUPPO_SUPER,
          x.desc_gruppo_economico val_ana_gre,
          x.COD_GRUPPO_LEGAME,
          LE.COD_LEGAME,
          x.FLG_GRUPPO_ECONOMICO,
          x.FLG_GRUPPO_LEGAME,
          x.FLG_SINGOLO,
          x.FLG_CONDIVISO,
          x.COD_STRUTTURA_COMPETENTE_DC,
          x.DESC_STRUTTURA_COMPETENTE_DC,
          x.COD_STRUTTURA_COMPETENTE_RG,
          x.DESC_STRUTTURA_COMPETENTE_RG,
          x.COD_STRUTTURA_COMPETENTE_AR,
          x.DESC_STRUTTURA_COMPETENTE_AR,
          x.COD_STRUTTURA_COMPETENTE_FI,
          x.DESC_STRUTTURA_COMPETENTE_FI,
          X.COD_PROCESSO,
          X.COD_STATO,
          X.COD_MACROSTATO,
          X.DTA_DECORRENZA_STATO,
          X.ID_UTENTE,
          x.COGNOME DESC_COGNOME,
          X.DTA_UTENTE_ASSEGNATO,
          x.COD_MATR_ASSEGNATORE,
          x.ID_UTENTE_PREASSEGNATO,
          x.COD_SEZIONE_PREASSEGNATA,
          DECODE (
             DTA_ABI_ELAB,
             (SELECT MAX (DTA_ELABORAZIONE) DTA_ABI_ELAB_MAX
                FROM T_MCRE0_APP_ABI_ELABORATI), '1',
             '0')
             FLG_ABI_LAVORATO,
          x.DESC_ISTITUTO,
          X.FLG_OUTSOURCING
     FROM V_MCRE0_APP_UPD_FIELDS x,         --T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                                                --   T_MCRE0_APP_ANAGR_GRE GE,
           T_MCRE0_APP_GRUPPO_LEGAME LE
    -- MV_MCRE0_APP_UPD_FIELD X,
    --   T_MCRE0_APP_UTENTI U,
    --  MV_MCRE0_DENORM_STR_ORG S,
    --   MV_MCRE0_APP_ISTITUTI I
    WHERE X.ID_UTENTE <> -1                                     -- IS NOT NULL
                            -- AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
          AND X.FLG_OUTSOURCING = 'Y'       --  AND X.COD_SNDG = A.COD_SNDG(+)
                                --  AND X.COD_GRUPPO_ECONOMICO = GE.COD_GRE(+)
           AND X.COD_SNDG = LE.COD_SNDG(+) -- AND X.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
                                          --  AND X.ID_UTENTE = U.ID_UTENTE(+)
                         --  AND X.COD_ABI_ISTITUTO = x.COD_ABI_ISTITUTO_FI(+)
                      --  AND X.COD_FILIALE = x.COD_STRUTTURA_COMPETENTE_FI(+)
           AND x.FLG_STATO_CHK = '1'
--          AND X.COD_STATO IN (SELECT COD_MICROSTATO
--                                FROM T_MCRE0_APP_STATI S
--                               WHERE x.FLG_STATO_CHK = 1);
;
