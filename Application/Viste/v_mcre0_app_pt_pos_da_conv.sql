/* Formatted on 21/07/2014 18:34:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PT_POS_DA_CONV
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   DESC_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   VAL_GG_PT,
   COD_STATO,
   COD_PROCESSO,
   DTA_DECORRENZA_STATO,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_FILIALE,
   COD_MATRICOLA,
   COD_GESTORE_MKT,
   FLG_ABI_LAVORATO,
   FLG_CORPORATE
)
AS
   SELECT /*+ first_rows */
 -- V1.1 17/01/2011 MM: Aggiunti cod stato, cod processo e dta_decorrenza_stato
                        -- v2 4/04/2011 VG: Messi outer join per GE e gr anag.
 -- v3  21/05/2012 Valeria Galli flg_corporate (Commenti con label:  VG - CIB/BDT - INIZIO)
         X.COD_ABI_ISTITUTO,
         X.COD_ABI_CARTOLARIZZATO,
         X.COD_NDG,
         x.cod_sndg,                      -- 3 luglio per posizioni lavorabili
         X.DESC_NOME_CONTROPARTE,
         X.COD_GRUPPO_ECONOMICO,
         X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
         X.DESC_ISTITUTO,
         X.COD_STRUTTURA_COMPETENTE_DC,
         X.DESC_STRUTTURA_COMPETENTE_DC,
         X.COD_STRUTTURA_COMPETENTE_AR,
         X.DESC_STRUTTURA_COMPETENTE_AR,
         X.COD_STRUTTURA_COMPETENTE_FI,
         X.DESC_STRUTTURA_COMPETENTE_FI,
         X.COD_STRUTTURA_COMPETENTE_RG,
         X.DESC_STRUTTURA_COMPETENTE_RG,
         TRUNC (SYSDATE) - TRUNC (X.DTA_DECORRENZA_STATO) VAL_GG_PT,
         X.COD_STATO,
         X.COD_PROCESSO,
         X.DTA_DECORRENZA_STATO,
         X.ID_UTENTE,
         X.ID_REFERENTE,
         X.COD_COMPARTO,
         --MM11.12
         X.COD_FILIALE,
         X.COD_MATRICOLA,
         X.COD_GESTORE_MKT,
         --MM
         DECODE (
            DTA_ABI_ELAB,
            (SELECT MAX (DTA_ELABORAZIONE) DTA_ABI_ELAB_MAX
               FROM T_MCRE0_APP_ABI_ELABORATI), '1',
            '0')
            FLG_ABI_LAVORATO,
         --------------------   VG - CIB/BDT - INIZIO --------------------
         DECODE (p.tip_div, 'C', 1, 0) flg_corporate
    -------------------- VG - CIB/BDT - FINE --------------------
    FROM V_MCRE0_APP_UPD_FIELDS X,
         T_MCRE0_APP_PT_GESTIONE_TAVOLI PT,
         T_MCRE0_CL_PROCESSI p
   --T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
   --T_MCRE0_APP_ANAGR_GRE E,
   --MV_MCRE0_APP_ISTITUTI I,
   --MV_MCRE0_DENORM_STR_ORG S,
   --T_MCRE0_APP_UTENTI U
   WHERE                               --X.COD_GRUPPO_ECONOMICO = E.COD_GRE(+)
             --AND X.COD_ABI_CARTOLARIZZATO = I.COD_ABI
             X.COD_STATO = 'PT'
         AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
         --AND X.COD_SNDG = G.COD_SNDG(+)
         AND X.ID_UTENTE != -1
         --AND X.ID_UTENTE = U.ID_UTENTE
         --AND X.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
         --AND X.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
         AND X.COD_NDG = PT.COD_NDG(+)
         AND X.COD_ABI_CARTOLARIZZATO = PT.COD_ABI_CARTOLARIZZATO(+)
         --------------------   VG - CIB/BDT - INIZIO --------------------
         AND X.cod_abi_istituto = p.cod_abi(+)
         AND X.COD_PROCESSO = p.COD_PROCESSO(+)
         --------------------   VG - CIB/BDT - FINE --------------------
         AND PT.COD_NDG IS NULL
         --   AND NOT EXISTS (
         --      SELECT 1
         --      FROM T_MCRE0_APP_PT_GESTIONE_TAVOLI PT
         --     WHERE PT.COD_NDG = X.COD_NDG
         --       AND PT.COD_ABI_CARTOLARIZZATO = X.COD_ABI_CARTOLARIZZATO)
         --   AND X.COD_COMPARTO IN (SELECT C.COD_COMPARTO
         --            FROM T_MCRE0_APP_COMPARTI C
         --           WHERE C.FLG_CHK = 1)
         AND FLG_CHK = '1';
