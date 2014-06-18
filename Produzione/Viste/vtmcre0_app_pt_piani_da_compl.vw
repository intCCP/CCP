/* Formatted on 17/06/2014 18:16:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_PT_PIANI_DA_COMPL
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   DTA_CONVOCAZIONE,
   DTA_SOLLECITO,
   DTA_TAVOLO,
   DTA_TAVOLO_ORIG,
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
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   FLG_ABI_LAVORATO,
   VAL_PARERE_AREA,
   FLG_PIANO,
   DTA_DEADLINE_INS_PIANO,
   DTA_DEADLINE_INS_PARERE_AREA,
   COD_SNDG
)
AS
   SELECT                                           -- V1   VG: Prima versione
          -- V2 08/03/2011 ML: Aggiunta VAL_PARERE_AREA e FLG_PIANO
          -- V3 11/03/2011 FS: Aggiunta DTA_TAVOLO_ORIG
          -- V4 31/03/2011 MB: Aggiunte DTA_DEADLINE_INS_PIANO e DTA_DEADLINE_INS_PARERE_AREA
          -- v5 07/04/2011 VG: Outer join per anagrafica
          T.COD_ABI_CARTOLARIZZATO,
          T.COD_NDG,
          T.DTA_CONVOCAZIONE,
          T.DTA_SOLLECITO,
          T.DTA_TAVOLO,
          T.DTA_TAVOLO_ORIG,
          G.DESC_NOME_CONTROPARTE,
          T.COD_GRUPPO_ECONOMICO,
          E.VAL_ANA_GRE,
          I.DESC_ISTITUTO,
          S.COD_STRUTTURA_COMPETENTE_DC,
          S.DESC_STRUTTURA_COMPETENTE_DC,
          S.COD_STRUTTURA_COMPETENTE_AR,
          S.DESC_STRUTTURA_COMPETENTE_AR,
          S.COD_STRUTTURA_COMPETENTE_FI,
          S.DESC_STRUTTURA_COMPETENTE_FI,
          S.COD_STRUTTURA_COMPETENTE_RG,
          S.DESC_STRUTTURA_COMPETENTE_RG,
          U.ID_UTENTE,
          U.ID_REFERENTE,
          T.COD_COMPARTO,
          I.FLG_ABI_LAVORATO,
          T.VAL_PARERE_AREA,
          T.FLG_PIANO,
          T.DTA_DEADLINE_INS_PIANO,
          T.DTA_DEADLINE_INS_PARERE_AREA,
          t.COD_SNDG
     FROM VTMCRE0_APP_PT_GESTIONE_TAVOLI T,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
          T_MCRE0_APP_ANAGR_GRE E,
          MV_MCRE0_APP_ISTITUTI I,
          MV_MCRE0_DENORM_STR_ORG S,
          T_MCRE0_APP_UTENTI U
    WHERE     FLG_WORKFLOW = 1
          AND T.COD_SNDG = G.COD_SNDG(+)
          AND T.ID_UTENTE IS NOT NULL
          AND T.ID_UTENTE = U.ID_UTENTE
          AND T.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          AND T.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          AND T.COD_ABI_CARTOLARIZZATO = I.COD_ABI
          AND T.COD_GRUPPO_ECONOMICO = E.COD_GRE(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_PT_PIANI_DA_COMPL TO MCRE_USR;
