/* Formatted on 21/07/2014 18:40:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_PIANI_RIENTRO
(
   ID_DPER,
   COD_ABI,
   COD_SNDG,
   COD_NDG,
   COD_RAPPORTO,
   DTA_STIMA,
   NUM_RATA,
   DTA_SCADENZA_RATA,
   VAL_RATA,
   DTA_INS_PIANO,
   DTA_UPD_PIANO,
   COD_UTENTE,
   COD_PROTOCOLLO_DELIBERA,
   FLG_ATTIVA,
   DTA_INS,
   DTA_UPD,
   COD_OPERATORE_INS_UPD,
   COD_FORMA_TECNICA
)
AS
   SELECT ID_DPER,
          COD_ABI,
          COD_SNDG,
          COD_NDG,
          COD_RAPPORTO,
          DTA_STIMA,
          NUM_RATA,
          DTA_SCADENZA_RATA,
          VAL_RATA,
          DTA_INS_PIANO,
          DTA_UPD_PIANO,
          COD_UTENTE,
          COD_PROTOCOLLO_DELIBERA,
          FLG_ATTIVA,
          DTA_INS,
          DTA_UPD,
          COD_OPERATORE_INS_UPD,
          cod_Forma_tecnica                                        --24 aprile
     FROM T_MCREI_APP_PIANI_RIENTRO
    WHERE FLG_ATTIVA = '1';
