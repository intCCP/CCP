/* Formatted on 21/07/2014 18:45:31 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_RICERCA_LIST_NDG
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
          -- NVL (x.COD_COMPARTO_ASSEGNATO, x.COD_COMPARTO_CALCOLATO)
          COD_COMPARTO,
          x.COD_RAMO_CALCOLATO,
          x.COD_ABI_ISTITUTO,
          x.DESC_ISTITUTO,
          x.COD_ABI_CARTOLARIZZATO,
          x.COD_NDG,
          x.COD_SNDG,
          x.DESC_NOME_CONTROPARTE,
          x.COD_GRUPPO_ECONOMICO,
          x.desc_GRUPPO_ECONOMICO VAL_ANA_GRE,
          x.ID_UTENTE,
          x.COGNOME,
          x.NOME,
          x.COD_GESTORE_MKT,
          x.DESC_ANAG_GESTORE_MKT,
          x.COD_STATO,
          x.COD_PROCESSO,
          x.DTA_DECORRENZA_STATO,
          x.SCSB_UTI_TOT VAL_TOT_UTILIZZO,
          x.SCSB_ACC_TOT VAL_TOT_ACCORDATO,
          x.gb_val_mau VAL_MAU,
          x.COD_GRUPPO_LEGAME,
          x.COD_GRUPPO_SUPER,
          x.FLG_OUTSOURCING,
          x.FLG_TARGET
     FROM V_MCRE0_APP_UPD_FIELDS x                                      --;--,
--       T_MCRE0_APP_FILE_GUIDA F,
--          T_MCRE0_APP_MOPLE M,
--          T_MCRE0_APP_UTENTI U,
--          T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
--          T_MCRE0_APP_ISTITUTI I,
--          T_MCRE0_APP_ANAGR_GRE E,
--          T_MCRE0_APP_PCR P
--    WHERE     x.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO(+)
--          AND x.COD_NDG = M.COD_NDG(+)
--          AND x.ID_UTENTE = U.ID_UTENTE(+)
--          AND x.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO(+)
--          AND x.COD_NDG = P.COD_NDG(+)
--          AND x.COD_SNDG = A.COD_SNDG(+)
--          AND x.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
--          AND x.COD_GRUPPO_ECONOMICO = E.COD_GRE(+)
--;
;
