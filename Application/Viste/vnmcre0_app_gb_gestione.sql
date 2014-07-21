/* Formatted on 21/07/2014 18:45:25 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_GB_GESTIONE
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
          f.COD_ABI_CARTOLARIZZATO,
          f.COD_ABI_ISTITUTO,
          f.COD_NDG,
          f.COD_SNDG,
          f.DESC_ISTITUTO,
          f.DESC_NOME_CONTROPARTE,
          f.COD_STRUTTURA_COMPETENTE_DC,
          f.DESC_STRUTTURA_COMPETENTE_DC,
          f.COD_STRUTTURA_COMPETENTE_RG,
          f.DESC_STRUTTURA_COMPETENTE_RG,
          f.COD_STRUTTURA_COMPETENTE_AR,
          f.DESC_STRUTTURA_COMPETENTE_AR,
          f.COD_FILIALE COD_STRUTTURA_COMPETENTE_FI,
          f.DESC_STRUTTURA_COMPETENTE_FI,
          f.COD_PROCESSO_CALCOLATO,
          f.COD_PROCESSO,
          f.COD_PROCESSO COD_PROCESSO_ATTUALE,
          f.COD_STATO COD_STATO_ATTUALE,
          f.COD_MACROSTATO_PROPOSTO,
          f.DTA_INS,
          f.FLG_STATO,
          GS.DESC_STATO,
          f.DTA_STATO,
          f.DTA_INVIO,
          F.ID_UTENTE,
          COGNOME || ' ' || NOME DESC_UTENTE,
          --NVL (F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO)    COD_COMPARTO,
          f.COD_COMPARTO,
          f.DESC_COMPARTO,
          f.ID_OD,
          VAL_ORGANO_DELIBERANTE DESC_OD,
          f.DESC_STRUTTURA_DISP,
          FLG_OUTSOURCING,
          f.COD_COMPARTO_PROPOSTO,
          C1.DESC_COMPARTO DESC_COMPARTO_PROPOSTO,
          f.COD_MATRICOLA,
          DECODE (
             f.FLG_STATO,
             -3, f.DESC_MOTIVO_ANNULLO,
             DECODE (
                f.FLG_STATO,
                -1, 'Rifiutato dall''utente',
                DECODE (
                   f.FLG_STATO,
                   -2, 'Ingresso in altro stato',
                   DECODE (f.FLG_STATO, 2, 'Ingresso in altro stato', ''))))
             DESC_MOTIVO_ANNULLO,
          DECODE (
             f.FLG_STATO,
             -2, 'A',
             DECODE (
                f.FLG_STATO,
                -1, 'M',
                DECODE (f.FLG_STATO,
                        -3, 'M',
                        DECODE (f.FLG_STATO, 2, 'M', ' '))))
             FLG_MODO_ANNULLO,
          GS.COD_ORDINE
     FROM                                         --MV_MCRE0_DENORM_STR_ORG S,
          --T_MCRE0_APP_GB_GESTIONE GB,
          T_MCRE0_CL_CALCOLO_OD OD,
          T_MCRE0_CL_GB_STATI GS,
          --T_MCRE0_APP_FILE_GUIDA F,
          -- T_MCRE0_APP_MOPLE M,
          -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
          V_MCRE0_APP_UPD_FIELDS_ALL f,
          --  T_MCRE0_APP_UTENTI U,
          --  T_MCRE0_APP_COMPARTI C,
          T_MCRE0_APP_COMPARTI C1                                          --,
    --  MV_MCRE0_APP_ISTITUTI I
    WHERE                      --f.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          --AND f.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          --AND f.FLG_STATO = GS.COD_STATO(+)
          f.FLG_STATO = GS.COD_STATO                                     --(+)
                                     --  AND f.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO(+)
                                     --   AND f.COD_NDG = F.COD_NDG(+)
                                     --   AND f.COD_ABI_CARTOLARIZZATO = M.COD_ABI_CARTOLARIZZATO(+)
                                     --   AND f.COD_NDG = M.COD_NDG(+)
                                     --AND F.ID_UTENTE = U.ID_UTENTE(+)
                                     -- AND NVL (F.COD_COMPARTO_ASSEGNATO, F.COD_COMPARTO_CALCOLATO) =                 C.COD_COMPARTO(+)
                                     -- AND f.COD_COMPARTO_PROPOSTO = C1.COD_COMPARTO(+)
          AND f.COD_COMPARTO_PROPOSTO = C1.COD_COMPARTO                  --(+)
                                                        --  AND f.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
          AND f.ID_OD = OD.ID(+);
