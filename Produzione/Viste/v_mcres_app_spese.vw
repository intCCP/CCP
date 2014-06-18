/* Formatted on 17/06/2014 18:11:35 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESE
(
   SPESA,
   DESC_STATO,
   DESCSTATO,
   STATO,
   ID_DPER,
   COD_ABI,
   COD_AUTORIZZAZIONE,
   VAL_ANNO,
   COD_PRATICA,
   COD_NDG,
   COD_UO_PRATICA,
   COD_TIPO_AUTORIZZAZIONE,
   COD_STATO,
   VAL_NUMERO,
   DTA_SPESA,
   VAL_IMPORTO_DIVISA,
   VAL_IMPORTO,
   VAL_CAUSALE,
   VAL_CAUSA_DIVISA,
   VAL_CAUSA_IMPORTO,
   VAL_INTESTATARIO_TIPO,
   DESC_INTESTATARIO,
   VAL_INTESTATARIO_CODFISC,
   VAL_INTESTATARIO_PIVA,
   VAL_AFAVORE_TIPO,
   DESC_AFAVORE,
   VAL_AFAVORE_CODFISC,
   VAL_AFAVORE_PIVA,
   VAL_CONVENZIONE,
   DESC_SPESA,
   VAL_SPESA_RIPETIBILE,
   VAL_ENTE_PAGATORE,
   COD_TIPO_PAGAMENTO,
   VAL_BON_DESTINATARIO,
   VAL_BON_COORDINATE,
   DTA_VALUTA_BON,
   VAL_CIRC_INTESTATARIO,
   VAL_CIRC_TRASFERIBILE,
   VAL_SPESA_RECUPERATA,
   COD_ORGANO_AUTORIZZANTE,
   VAL_NOTE,
   VAL_SPESA_NON_FATTURATA,
   VAL_PUNTO_OPERATIVO,
   VAL_PROTOCOLLO,
   DTA_GENERAZIONE_PROTOCOLLO,
   VAL_INTESTATARIO_ABI,
   VAL_INTESTATARIO_CAB,
   VAL_INTESTATARIO_CONTO,
   VAL_ANN_AUTORIZ,
   VAL_PRATICA_CEDUTA,
   VAL_CARICO_CESSIONARIO,
   VAL_IBAN,
   VAL_FAX,
   VAL_RIFERIMENTO,
   VAL_RAPPRESENTANTE,
   VAL_NOTE2,
   FLG_FM,
   VAL_IMPORTO_FM,
   VAL_NOTE_FM,
   VAL_NUM_PROFORMA,
   DTA_PROFORMA_A_FATTURA,
   VAL_CAUSALE_888,
   DTA_TIMESTAMP,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD
)
AS
   SELECT '' AS SPESA,
          '' AS DESC_STATO,
          '' AS DESCSTATO,
          '' AS STATO,
          T_MCRES_APP_SPESE."ID_DPER",
          T_MCRES_APP_SPESE."COD_ABI",
          T_MCRES_APP_SPESE."COD_AUTORIZZAZIONE",
          T_MCRES_APP_SPESE."VAL_ANNO",
          T_MCRES_APP_SPESE."COD_PRATICA",
          T_MCRES_APP_SPESE."COD_NDG",
          T_MCRES_APP_SPESE."COD_UO_PRATICA",
          T_MCRES_APP_SPESE."COD_TIPO_AUTORIZZAZIONE",
          T_MCRES_APP_SPESE."COD_STATO",
          T_MCRES_APP_SPESE."VAL_NUMERO",
          T_MCRES_APP_SPESE."DTA_SPESA",
          T_MCRES_APP_SPESE."VAL_IMPORTO_DIVISA",
          T_MCRES_APP_SPESE."VAL_IMPORTO",
          T_MCRES_APP_SPESE."VAL_CAUSALE",
          T_MCRES_APP_SPESE."VAL_CAUSA_DIVISA",
          T_MCRES_APP_SPESE."VAL_CAUSA_IMPORTO",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_TIPO",
          T_MCRES_APP_SPESE."DESC_INTESTATARIO",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_CODFISC",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_PIVA",
          T_MCRES_APP_SPESE."VAL_AFAVORE_TIPO",
          T_MCRES_APP_SPESE."DESC_AFAVORE",
          T_MCRES_APP_SPESE."VAL_AFAVORE_CODFISC",
          T_MCRES_APP_SPESE."VAL_AFAVORE_PIVA",
          T_MCRES_APP_SPESE."VAL_CONVENZIONE",
          T_MCRES_APP_SPESE."DESC_SPESA",
          T_MCRES_APP_SPESE."VAL_SPESA_RIPETIBILE",
          T_MCRES_APP_SPESE."VAL_ENTE_PAGATORE",
          T_MCRES_APP_SPESE."COD_TIPO_PAGAMENTO",
          T_MCRES_APP_SPESE."VAL_BON_DESTINATARIO",
          T_MCRES_APP_SPESE."VAL_BON_COORDINATE",
          T_MCRES_APP_SPESE."DTA_VALUTA_BON",
          T_MCRES_APP_SPESE."VAL_CIRC_INTESTATARIO",
          T_MCRES_APP_SPESE."VAL_CIRC_TRASFERIBILE",
          T_MCRES_APP_SPESE."VAL_SPESA_RECUPERATA",
          T_MCRES_APP_SPESE."COD_ORGANO_AUTORIZZANTE",
          T_MCRES_APP_SPESE."VAL_NOTE",
          T_MCRES_APP_SPESE."VAL_SPESA_NON_FATTURATA",
          T_MCRES_APP_SPESE."VAL_PUNTO_OPERATIVO",
          T_MCRES_APP_SPESE."VAL_PROTOCOLLO",
          T_MCRES_APP_SPESE."DTA_GENERAZIONE_PROTOCOLLO",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_ABI",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_CAB",
          T_MCRES_APP_SPESE."VAL_INTESTATARIO_CONTO",
          T_MCRES_APP_SPESE."VAL_ANN_AUTORIZ",
          T_MCRES_APP_SPESE."VAL_PRATICA_CEDUTA",
          T_MCRES_APP_SPESE."VAL_CARICO_CESSIONARIO",
          T_MCRES_APP_SPESE."VAL_IBAN",
          T_MCRES_APP_SPESE."VAL_FAX",
          T_MCRES_APP_SPESE."VAL_RIFERIMENTO",
          T_MCRES_APP_SPESE."VAL_RAPPRESENTANTE",
          T_MCRES_APP_SPESE."VAL_NOTE2",
          T_MCRES_APP_SPESE."FLG_FM",
          T_MCRES_APP_SPESE."VAL_IMPORTO_FM",
          T_MCRES_APP_SPESE."VAL_NOTE_FM",
          T_MCRES_APP_SPESE."VAL_NUM_PROFORMA",
          T_MCRES_APP_SPESE."DTA_PROFORMA_A_FATTURA",
          T_MCRES_APP_SPESE."VAL_CAUSALE_888",
          T_MCRES_APP_SPESE."DTA_TIMESTAMP",
          T_MCRES_APP_SPESE."DTA_INS",
          T_MCRES_APP_SPESE."DTA_UPD",
          T_MCRES_APP_SPESE."COD_OPERATORE_INS_UPD"
     FROM T_MCRES_APP_SPESE;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_SPESE TO MCRE_USR;
