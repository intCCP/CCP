/* Formatted on 17/06/2014 18:13:46 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_GB_GESTIONE
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_PROCESSO_CALCOLATO,
   COD_PROCESSO,
   COD_PROCESSO_ATTUALE,
   COD_STATO_ATTUALE,
   COD_MACROSTATO_PROPOSTO,
   DTA_INS,
   FLG_STATO,
   DESC_STATO,
   DTA_STATO,
   DTA_INVIO,
   ID_UTENTE,
   DESC_UTENTE,
   COD_COMPARTO,
   DESC_COMPARTO,
   ID_OD,
   DESC_OD,
   DESC_STRUTTURA_DISP,
   FLG_OUTSOURCING,
   COD_COMPARTO_PROPOSTO,
   DESC_COMPARTO_PROPOSTO,
   COD_MATRICOLA,
   DESC_MOTIVO_ANNULLO,
   FLG_MODO_ANNULLO,
   COD_ORDINE
)
AS
   SELECT                                                -- MM 26-04-2011 v1.0
          -- MM 23-05-2011 v1.1 - nome controparte dal BS, mople x processo attuale
          GB.COD_ABI_CARTOLARIZZATO,
          GB.COD_ABI_ISTITUTO,
          GB.COD_NDG,
          GB.COD_SNDG,
          I.DESC_ISTITUTO,
          GB.DESC_NOME_CONTROPARTE,
          S.COD_STRUTTURA_COMPETENTE_DC,
          S.DESC_STRUTTURA_COMPETENTE_DC,
          S.COD_STRUTTURA_COMPETENTE_RG,
          S.DESC_STRUTTURA_COMPETENTE_RG,
          S.COD_STRUTTURA_COMPETENTE_AR,
          S.DESC_STRUTTURA_COMPETENTE_AR,
          GB.COD_FILIALE COD_STRUTTURA_COMPETENTE_FI,
          S.DESC_STRUTTURA_COMPETENTE_FI,
          GB.COD_PROCESSO_CALCOLATO,
          GB.COD_PROCESSO,
          M.COD_PROCESSO COD_PROCESSO_ATTUALE,
          M.COD_STATO COD_STATO_ATTUALE,
          GB.COD_MACROSTATO_PROPOSTO,
          GB.DTA_INS,
          GB.FLG_STATO,
          GS.DESC_STATO,
          GB.DTA_STATO,
          GB.DTA_INVIO,
          F.ID_UTENTE,
          U.COGNOME || ' ' || U.NOME DESC_UTENTE,
          NVL (F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO)
             COD_COMPARTO,
          C.DESC_COMPARTO,
          GB.ID_OD,
          VAL_ORGANO_DELIBERANTE DESC_OD,
          GB.DESC_STRUTTURA_DISP,
          I.FLG_OUTSOURCING,
          GB.COD_COMPARTO_PROPOSTO,
          C1.DESC_COMPARTO DESC_COMPARTO_PROPOSTO,
          GB.COD_MATRICOLA,
          DECODE (
             GB.FLG_STATO,
             -3, GB.DESC_MOTIVO_ANNULLO,
             DECODE (
                GB.FLG_STATO,
                -1, 'Rifiutato dall''utente',
                DECODE (
                   GB.FLG_STATO,
                   -2, 'Ingresso in altro stato',
                   DECODE (GB.FLG_STATO, 2, 'Ingresso in altro stato', ''))))
             DESC_MOTIVO_ANNULLO,
          DECODE (
             GB.FLG_STATO,
             -2, 'A',
             DECODE (
                GB.FLG_STATO,
                -1, 'M',
                DECODE (GB.FLG_STATO,
                        -3, 'M',
                        DECODE (GB.FLG_STATO, 2, 'M', ' '))))
             FLG_MODO_ANNULLO,
          GS.COD_ORDINE
     FROM MV_MCRE0_DENORM_STR_ORG S,
          T_MCRE0_APP_GB_GESTIONE GB,
          T_MCRE0_CL_CALCOLO_OD OD,
          T_MCRE0_CL_GB_STATI GS,
          T_MCRE0_APP_FILE_GUIDA F,
          T_MCRE0_APP_MOPLE M,
          T_MCRE0_APP_UTENTI U,
          T_MCRE0_APP_COMPARTI C,
          T_MCRE0_APP_COMPARTI C1,
          MV_MCRE0_APP_ISTITUTI I
    WHERE     GB.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          AND GB.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          AND GB.FLG_STATO = GS.COD_STATO(+)
          AND GB.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO(+)
          AND GB.COD_NDG = F.COD_NDG(+)
          AND GB.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO(+)
          AND GB.COD_NDG = M.COD_NDG(+)
          AND F.ID_UTENTE = U.ID_UTENTE(+)
          AND NVL (F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO) =
                 C.COD_COMPARTO(+)
          AND GB.COD_COMPARTO_PROPOSTO = C1.COD_COMPARTO(+)
          AND GB.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
          AND GB.ID_OD = OD.ID(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_GB_GESTIONE TO MCRE_USR;
