/* Formatted on 17/06/2014 18:05:55 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_RWA_POSIZIONE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_POSIZ,
   COD_STATO,
   DTA_DECOR_STATO,
   COD_FUNZIONALITA,
   COD_BS,
   COD_MATRICOLA,
   VAL_LIV_UTENTE,
   VAL_STORICO,
   RWA_TICKET_ID,
   COD_ESITO,
   FLG_VALIDITA,
   DTA_INS,
   DTA_UPD,
   COD_PROC_CALC,
   VAL_LIV_POSIZ,
   COD_UO_COMP,
   COD_UO_CAPOFILA_ANAG,
   COD_UO_CAPOFILA_CALC,
   VAL_RWA
)
AS
   SELECT COD_ABI,
          COD_NDG,
          COD_SNDG,
          COD_UO_POSIZ,
          COD_STATO,
          DTA_DECOR_STATO,
          COD_FUNZIONALITA,
          COD_BS,
          COD_MATRICOLA,
          VAL_LIV_UTENTE,
          VAL_STORICO,
          RWA_TICKET_ID,
          COD_ESITO,
          FLG_VALIDITA,
          DTA_INS,
          DTA_UPD,
          COD_PROC_CALC,
          VAL_LIV_POSIZ,
          COD_UO_COMP,
          COD_UO_CAPOFILA_ANAG,
          COD_UO_CAPOFILA_CALC,
          VAL_RWA
     FROM T_MCRE0_RWA_POSIZIONE;


GRANT SELECT ON MCRE_OWN.V_MCRE0_RWA_POSIZIONE TO MCRE_USR;
