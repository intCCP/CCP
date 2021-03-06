/* Formatted on 17/06/2014 18:14:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_RIO_SCHEMA_ESP
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   SCSB_DTA_RIFERIMENTO,
   GESB_ACC_TOT,
   GESB_UTI_TOT,
   GESB_DTA_RIFERIMENTO,
   SCGB_ACC_TOT,
   SCGB_UTI_TOT,
   DESC_NATURA_BT,
   DESC_NATURA_MLT,
   DESC_NATURA_SMOBILIZZO,
   DESC_NATURA_FIRMA,
   SCGB_ACC_CASSA_BT,
   SCGB_ACC_CASSA_MLT,
   SCGB_ACC_SMOBILIZZO,
   SCGB_ACC_FIRMA,
   SCGB_ACC_SOSTITUZIONI,
   SCGB_ACC_CONSEGNE,
   SCGB_ACC_MASSIMALI,
   SCGB_ACC_RISCHI_INDIRETTI,
   SCGB_UTI_CASSA_BT,
   SCGB_UTI_CASSA_MLT,
   SCGB_UTI_SMOBILIZZO,
   SCGB_UTI_FIRMA,
   SCGB_UTI_SOSTITUZIONI,
   SCGB_UTI_CONSEGNE,
   SCGB_UTI_MASSIMALI,
   SCGB_UTI_RISCHI_INDIRETTI,
   GEGB_ACC_CASSA_BT,
   GEGB_ACC_CASSA_MLT,
   GEGB_ACC_SMOBILIZZO,
   GEGB_ACC_FIRMA,
   GEGB_ACC_SOSTITUZIONI,
   GEGB_ACC_CONSEGNE,
   GEGB_ACC_MASSIMALI,
   GEGB_ACC_RISCHI_INDIRETTI,
   GEGB_UTI_CASSA_BT,
   GEGB_UTI_CASSA_MLT,
   GEGB_UTI_SMOBILIZZO,
   GEGB_UTI_FIRMA,
   GEGB_UTI_SOSTITUZIONI,
   GEGB_UTI_CONSEGNE,
   GEGB_UTI_MASSIMALI,
   GEGB_UTI_RISCHI_INDIRETTI
)
AS
   SELECT                                         -- V1 --/--/---- VG: Created
     -- V2 16/06/2011 VG: Sostituzioni, Consegne, Massimali e Rischi Indiretti
                                                  -- V3 17/06/2011 VG: New PCR
         F.COD_ABI_CARTOLARIZZATO,
         F.COD_ABI_ISTITUTO,
         I.DESC_ISTITUTO,
         F.COD_NDG,
         F.COD_SNDG,
         A.DESC_NOME_CONTROPARTE,
         F.COD_GRUPPO_ECONOMICO,
         G.VAL_ANA_GRE,
         -- Lender SCSB
         B.SCSB_ACC_TOT,
         B.SCSB_UTI_TOT,
         B.SCSB_DTA_RIFERIMENTO,
         -- Lender GESB
         B.GESB_ACC_TOT,
         B.GESB_UTI_TOT,
         B.GESB_DTA_RIFERIMENTO,
         -- Borrower SCGB
         B.SCGB_ACC_CASSA + B.SCGB_ACC_FIRMA SCGB_ACC_TOT,
         B.SCGB_UTI_CASSA + B.SCGB_UTI_FIRMA SCGB_UTI_TOT,
         -- Forme tecniche SCGB
         (SELECT DISTINCT DESC_CLASSE_APPL_DETT
            FROM T_MCRE0_APP_NATURA_FTECNICA N
           WHERE N.COD_CLASSE_APPL_DETT = 'CB')
            DESC_NATURA_BT,
         (SELECT DISTINCT DESC_CLASSE_APPL_DETT
            FROM T_MCRE0_APP_NATURA_FTECNICA N
           WHERE N.COD_CLASSE_APPL_DETT = 'CM')
            DESC_NATURA_MLT,
         (SELECT DISTINCT DESC_CLASSE_APPL_DETT
            FROM T_MCRE0_APP_NATURA_FTECNICA N
           WHERE N.COD_CLASSE_APPL_DETT = 'SM')
            DESC_NATURA_SMOBILIZZO,
         (SELECT DISTINCT DESC_CLASSE_APPL_DETT
            FROM T_MCRE0_APP_NATURA_FTECNICA N
           WHERE N.COD_CLASSE_APPL_DETT = 'FI')
            DESC_NATURA_FIRMA,
         B.SCGB_ACC_CASSA_BT,
         B.SCGB_ACC_CASSA_MLT,
         B.SCGB_ACC_SMOBILIZZO,
         B.SCGB_ACC_FIRMA,
         B.SCGB_ACC_SOSTITUZIONI,
         B.SCGB_ACC_CONSEGNE,
         B.SCGB_ACC_MASSIMALI,
         B.SCGB_ACC_RISCHI_INDIRETTI,
         B.SCGB_UTI_CASSA_BT,
         B.SCGB_UTI_CASSA_MLT,
         B.SCGB_UTI_SMOBILIZZO,
         B.SCGB_UTI_FIRMA,
         B.SCGB_UTI_SOSTITUZIONI,
         B.SCGB_UTI_CONSEGNE,
         B.SCGB_UTI_MASSIMALI,
         B.SCGB_UTI_RISCHI_INDIRETTI,
         -- Forme tecniche GEGB
         B.GEGB_ACC_CASSA_BT,
         B.GEGB_ACC_CASSA_MLT,
         B.GEGB_ACC_SMOBILIZZO,
         B.GEGB_ACC_FIRMA,
         B.GEGB_ACC_SOSTITUZIONI,
         B.GEGB_ACC_CONSEGNE,
         B.GEGB_ACC_MASSIMALI,
         B.GEGB_ACC_RISCHI_INDIRETTI,
         B.GEGB_UTI_CASSA_BT,
         B.GEGB_UTI_CASSA_MLT,
         B.GEGB_UTI_SMOBILIZZO,
         B.GEGB_UTI_FIRMA,
         B.GEGB_UTI_SOSTITUZIONI,
         B.GEGB_UTI_CONSEGNE,
         B.GEGB_UTI_MASSIMALI,
         B.GEGB_UTI_RISCHI_INDIRETTI
    FROM MV_MCRE0_APP_UPD_FIELD F,
         T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
         T_MCRE0_APP_PCR B,
         T_MCRE0_APP_ANAGR_GRE G,
         MV_MCRE0_APP_ISTITUTI I
   WHERE     F.COD_ABI_CARTOLARIZZATO = B.COD_ABI_CARTOLARIZZATO(+)
         AND F.COD_NDG = B.COD_NDG(+)
         AND F.COD_SNDG = A.COD_SNDG(+)
         AND F.COD_GRUPPO_ECONOMICO = G.COD_GRE(+)
         AND F.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.VOMCRE0_APP_RIO_SCHEMA_ESP TO MCRE_USR;
