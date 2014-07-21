/* Formatted on 21/07/2014 18:46:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_RICERCA_LIST_NDG
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
   VAL_MAU,
   COD_GRUPPO_LEGAME,
   COD_GRUPPO_SUPER,
   FLG_OUTSOURCING,
   FLG_TARGET
)
AS
   SELECT                                         -- v1 17/06/2011 VG: New PCR
          /*+ first_rows */
          -- V1 02/12/2010 VG: Congelata
          -- V2 22/12/2010 VG: COD_RAMO_CALCOLATO
          -- v3 17/01/2011 MM: aggiunto DTA_DECORRENZA_STATO
          -- v4 08/02/2011 LF: FLG_OUTSOURCING preso da MOPLE
          -- v5 08/03/2011 MM: passaggio alla tabella PCR
          -- v6 28/03/2011 VG: recupero MAU x ge e gl
          -- v7 06/04/2011 AG: bug-fix recupero MAU x ge e gl
          -- v8 07/04/2011 VG: nuova versione pcr
          -- v9 26/05/2011 VG: utilizzato
          NVL (F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO)
             COD_COMPARTO,
          F.COD_RAMO_CALCOLATO,
          F.COD_ABI_ISTITUTO,
          I.DESC_ISTITUTO,
          F.COD_ABI_CARTOLARIZZATO,
          F.COD_NDG,
          F.COD_SNDG,
          A.DESC_NOME_CONTROPARTE,
          F.COD_GRUPPO_ECONOMICO,
          E.VAL_ANA_GRE,
          U.ID_UTENTE,
          U.COGNOME,
          U.NOME,
          M.COD_GESTORE_MKT,
          M.DESC_ANAG_GESTORE_MKT,
          M.COD_STATO,
          M.COD_PROCESSO,
          M.DTA_DECORRENZA_STATO,
          p.SCSB_UTI_TOT VAL_TOT_UTILIZZO,
          p.SCSB_ACC_TOT VAL_TOT_ACCORDATO,
          p.gb_val_mau VAL_MAU,
          F.COD_GRUPPO_LEGAME,
          F.COD_GRUPPO_SUPER,
          M.FLG_OUTSOURCING,
          I.FLG_TARGET
     FROM T_MCRE0_APP_FILE_GUIDA F,
          T_MCRE0_APP_MOPLE M,
          T_MCRE0_APP_UTENTI U,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
          T_MCRE0_APP_ISTITUTI I,
          T_MCRE0_APP_ANAGR_GRE E,
          T_MCRE0_APP_PCR P
    WHERE     F.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO(+)
          AND F.COD_NDG = M.COD_NDG(+)
          AND F.ID_UTENTE = U.ID_UTENTE(+)
          AND F.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO(+)
          AND F.COD_NDG = P.COD_NDG(+)
          AND F.COD_SNDG = A.COD_SNDG(+)
          AND F.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
          AND F.COD_GRUPPO_ECONOMICO = E.COD_GRE(+);
