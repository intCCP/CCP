/* Formatted on 21/07/2014 18:45:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_ARCHIVIO
(
   DTA_UPD,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_PROCESSO,
   COD_PROCESSO_MESE_PRE,
   SCGB_COD_STATO_SIS,
   COD_STATO_SIS_MESE_PRE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   NUM_GG_SERVIZIO,
   NUM_GG_SCONFINO,
   COD_TIPO_PORTAFOGLIO,
   DESC_TIPO_PORT,
   SCSB_ACC_CASSA,
   SCSB_ACC_FIRMA,
   SCSB_ACC_SOSTITUZIONI,
   SCSB_ACC_TOT,
   SCSB_UTI_CASSA,
   SCSB_UTI_FIRMA,
   SCSB_UTI_SOSTITUZIONI,
   SCSB_UTI_TOT,
   SCGB_ACC_TOT,
   SCGB_UTI_TOT,
   GEB_ACC_TOT,
   GEGB_UTI_TOT,
   GB_VAL_MAU,
   COD_MATRICOLA,
   COGNOME,
   DTA_UTENTE_ASSEGNATO,
   COD_RAE,
   COD_SAE,
   COD_SEGMENTO_REGOLAMENTARE,
   VAL_UTI_CASSA_SISBA,
   VAL_UTI_FIRMA_SISBA,
   VAL_TOT_MORA_SISBA,
   VAL_TOT_RATEO_SISBA,
   VAL_TOT_UTI_SISBA,
   VAL_DUBBIO_ESITO_CASSA_SISBA,
   VAL_DUBBIO_ESITO_FIRMA_SISBA,
   VAL_DUBBIO_ATT_SISBA,
   VAL_DUBBIO_ESITO_DERIVATI,
   VAL_TOT_DUBBIO_ESITO_NT_ATT,
   DTA_ULTIMA_REVISIONE_PEF,
   COD_ULTIMO_ODE,
   DTA_ULTIMA_DELIBERA,
   VAL_TIPO_DELIBERA,
   VAL_RETTIFICA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA,
   VAL_OD_ULTIMA_DELIBERA_NOTE
)
AS
   SELECT /*ordered index(g PK_MV_MCRE0_ANAG_GENERALE) index(e IB1_T_MCRE0_APP_STORICO_EVENTI)*/
         TO_CHAR (SYSDATE, 'DDMMYY') DTA_UPD,
          XX.COD_RAMO_CALCOLATO,
          XX.COD_COMPARTO,
          XX.COD_ABI_CARTOLARIZZATO,
          XX.COD_ABI_ISTITUTO,
          xx.cod_struttura_competente_dc,
          xx.COD_STRUTTURA_COMPETENTE_AR,
          xx.COD_STRUTTURA_COMPETENTE_FI,
          XX.COD_NDG,
          G.DESC_NOME_CONTROPARTE,
          XX.COD_SNDG,
          XX.COD_GRUPPO_ECONOMICO,
          xx.desc_GRUPPO_ECONOMICO VAL_ANA_GRE,
          XX.COD_PROCESSO,
          e.COD_PROCESSO COD_PROCESSO_mese_pre, -- Processo fine mese precedente
          G.SCGB_COD_STATO_SIS,                   --MACROSTATO RISCHIO ATTUALE
          e.SCGB_COD_STATO_SIS COD_STATO_SIS_mese_pre, --Macrostato rischio mese precedente
          XX.COD_STATO,
          XX.DTA_DECORRENZA_STATO,
          XX.DTA_SCADENZA_STATO,
          TRUNC (SYSDATE) - TRUNC (XX.DTA_SERVIZIO) NUM_GG_SERVIZIO,
          G.VAL_SCONFINO NUM_GG_SCONFINO,
          xx.COD_TIPO_PORTAFOGLIO,
          T.DESC_TIPO_PORT,
          G.SCSB_ACC_CASSA,
          G.SCSB_ACC_FIRMA,
          NULL scsb_acc_sostituzioni,
          G.SCSB_acc_TOT,
          G.SCSB_UTI_CASSA,
          G.SCSB_uti_FIRMA,
          NULL scsb_uti_sostituzioni,
          G.SCSB_UTI_TOT,
          G.SCGB_ACC_CASSA + G.SCGB_ACC_FIRMA SCGB_ACC_TOT,
          G.scGB_UTI_cassa + g.scGB_UTI_firma SCGB_UTI_TOT,
          G.GEGB_acc_cassa + g.GEGB_acc_firma GEB_ACC_TOT,
          G.GEGB_UTI_cassa + g.GEGB_UTI_firma GEGB_UTI_TOT,
          G.GB_VAL_MAU,                                                 --????
          xx.COD_MATRICOLA,
          xx.COGNOME,
          XX.DTA_UTENTE_ASSEGNATO,
          NULL COD_RAE,
          NULL COD_SAE,
          NULL COD_SEGMENTO_REGOLAMENTARE,
          NULL VAL_UTI_CASSA_SISBA,
          NULL val_UTI_FIRMA_SISBA,
          NULL VAL_TOT_MORA_SISBA,
          NULL VAL_TOT_RATEO_SISBA,
          NULL val_TOT_UTI_SISBA,
          NULL VAL_DUBBIO_ESITO_CASSA_SISBA,
          NULL VAL_DUBBIO_ESITO_FIRMA_SISBA,
          NULL VAL_DUBBIO_ATT_SISBA,
          NULL VAL_DUBBIO_ESITO_DERIVATI,
          NULL VAL_Tot_dubbio_esito_nt_att,
          G.DTA_ULTIMA_REVISIONE_PEF,
          G.COD_ULTIMO_ODE,
          NULL DTA_ULTIMA_DELIBERA,
          NULL VAL_TIPO_DELIBERA,
          NULL VAL_RETTIFICA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA,
          NULL VAL_OD_ULTIMA_DELIBERA_note
     FROM T_MCRE0_APP_TIPI_PORTAFOGLIO T,
          V_MCRE0_APP_UPD_FIELDS xx,
          MV_MCRE0_ANAGRAFICA_GENERALE G,
          --          MV_MCRE0_APP_UPD_FIELD XX,
          --          MV_MCRE0_DENORM_STR_ORG S,
          --          T_MCRE0_APP_ANAGR_GRE GE,
          --          T_MCRE0_APP_UTENTI U,
          --          T_MCRE0_APP_MOPLE M,
          T_MCRE0_APP_STORICO_EVENTI E
    WHERE     SUBSTR (e.COD_MESE_HST, 1, 6) =
                 TO_CHAR (ADD_MONTHS (SYSDATE, -1), 'YYYYMM')
          AND e.flg_cambio_mese = '1'
          AND XX.COD_ABI_CARTOLARIZZATO = G.COD_ABI_CARTOLARIZZATO
          AND XX.COD_NDG = G.COD_NDG
          --    AND XX.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          --    AND XX.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          --    AND XX.COD_GRUPPO_ECONOMICO = GE.COD_GRE(+)
          --     AND XX.ID_UTENTE = U.ID_UTENTE(+)
          --      AND XX.COD_ABI_CARTOLARIZZATO = m.COD_ABI_CARTOLARIZZATO
          --      AND XX.COD_NDG = M.COD_NDG
          AND xx.COD_TIPO_PORTAFOGLIO = T.COD_TIPO_PORT
          AND XX.COD_ABI_CARTOLARIZZATO = E.COD_ABI_CARTOLARIZZATO       --(+)
          AND XX.COD_NDG = e.COD_NDG                                    --(+)
;
