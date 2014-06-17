/* Formatted on 17/06/2014 18:10:43 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_OPERAZ_PROVV_MO01
(
   ID,
   COD_ABI,
   COD_NDG,
   COD_FILIALE,
   DTA_CONTABILE,
   COD_TIPO_SOFF,
   VAL_NUMERO_SOFF,
   COD_RAPPORTO_ORIG,
   VAL_IMPORTO_CAPITALE,
   VAL_INTERESSI_ORIGINARI,
   DTA_INSERT,
   FLG_CANCEL,
   DTA_CANCEL,
   COD_FILIALE_OPER,
   DTA_VALUTA_CAPITALE,
   COD_TIPO_CONTROPART,
   FLG_AGEVOLATO,
   FLG_EX_REVOC,
   VAL_TASSO_MORA,
   VAL_SPREAD,
   VAL_VALORE_AT,
   VAL_TASSO_ATTUALIZZAZIONE,
   DTA_VALUTA_INTERESSI,
   MATR_INS,
   MATR_CANC,
   VAL_KEYMO02,
   VAL_TASSO_APPLICATO
)
AS
   SELECT ID,
          COD_ABI,
          COD_NDG,
          COD_FILIALE,
          DTA_CONTABILE,
          COD_TIPO_SOFF,
          VAL_NUMERO_SOFF,
          COD_RAPPORTO_ORIG,
          VAL_IMPORTO_CAPITALE,
          VAL_INTERESSI_ORIGINARI,
          DTA_INSERT,
          FLG_CANCEL,
          DTA_CANCEL,
          COD_FILIALE_OPER,
          DTA_VALUTA_CAPITALE,
          COD_TIPO_CONTROPART,
          -- AP 14/05/2014 REQF-FU-5.5
          FLG_AGEVOLATO,
          FLG_EX_REVOC,
          VAL_TASSO_MORA,
          VAL_SPREAD,
          VAL_VALORE_AT,
          VAL_TASSO_ATTUALIZZAZIONE,
          DTA_VALUTA_INTERESSI,
          MATR_INS,
          MATR_CANC,
          VAL_KEYMO02,
          VAL_TASSO_APPLICATO
     FROM T_MCRES_APP_ACC_SOFF;


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_OPERAZ_PROVV_MO01 TO MCRE_USR;
