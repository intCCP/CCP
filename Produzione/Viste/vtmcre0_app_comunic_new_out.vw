/* Formatted on 17/06/2014 18:15:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_COMUNIC_NEW_OUT
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   ID_UTENTE,
   ID_UTENTE_PRE,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_STATO,
   COD_STATO_PRECEDENTE,
   COD_PROCESSO,
   COD_PROCESSO_PRE,
   COD_COMPARTO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_RAMO_CALCOLATO,
   DTA_UTENTE_ASSEGNATO,
   DTA_UTENTE_DISASS,
   DTA_IN_OUT
)
AS
   SELECT X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.COD_NDG,
          X.ID_UTENTE,
          NULL ID_UTENTE_PRE,
          X.DESC_NOME_CONTROPARTE,
          X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          X.COD_STATO,
          X.COD_STATO_PRECEDENTE,
          X.COD_PROCESSO,
          X.COD_PROCESSO_PRE,
          X.COD_COMPARTO,
          X.COD_COMPARTO_CALCOLATO,
          X.COD_COMPARTO_CALCOLATO_PRE,
          X.COD_RAMO_CALCOLATO,
          X.DTA_UTENTE_ASSEGNATO,
          NULL DTA_UTENTE_DISASS,
          X.DTA_UTENTE_ASSEGNATO DTA_IN_OUT
     FROM VTMCRE0_APP_UPD_FIELDS X
    WHERE     X.DTA_UTENTE_ASSEGNATO >= TRUNC (SYSDATE) - 15
          AND X.FLG_CHK = '1'
          AND X.FLG_OUTSOURCING = 'Y'
          AND X.FLG_TARGET = 'Y'
   UNION ALL
   SELECT COD_ABI_CARTOLARIZZATO,
          COD_ABI_ISTITUTO,
          COD_NDG,
          ID_UTENTE,
          ID_UTENTE_PRE,
          DESC_NOME_CONTROPARTE,
          VAL_ANA_GRE,
          COD_STATO,
          COD_STATO_PRECEDENTE,
          COD_PROCESSO,
          '' COD_PROCESSO_PRE,
          COD_COMPARTO,
          COD_COMPARTO_CALCOLATO,
          COD_COMPARTO_CALCOLATO_PRE,
          '' COD_RAMO_CALCOLATO,
          NULL DTA_UTENTE_ASSEGNATO,
          DTA_FINE_VALIDITA DTA_UTENTE_DISASS,
          DTA_FINE_VALIDITA DTA_IN_OUT
     FROM (SELECT /*+index(e IX2_T_MCRE0_APP_STORICO_EVENTI)  no_parallel(e)*/
                 DISTINCT
                  COD_ABI_CARTOLARIZZATO,
                  COD_ABI_ISTITUTO,
                  COD_NDG,
                  NULL ID_UTENTE,
                  ID_UTENTE ID_UTENTE_PRE,
                  DESC_NOME_CONTROPARTE,
                  VAL_ANA_GRE,
                  COD_STATO,
                  COD_STATO_PRECEDENTE,
                  COD_PROCESSO,
                  '' COD_PROCESSO_PRE,
                  NVL (E.COD_COMPARTO_ASSEGNATO, E.COD_COMPARTO_CALCOLATO)
                     COD_COMPARTO,
                  E.COD_COMPARTO_CALCOLATO,
                  E.COD_COMPARTO_CALCOLATO_PRE,
                  '' COD_RAMO_CALCOLATO,
                  DTA_FINE_VALIDITA,
                  MAX (
                     DTA_FINE_VALIDITA)
                  OVER (
                     PARTITION BY COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  TRUNC (DTA_FINE_VALIDITA))
                     DTA_FINE_VALIDITA_MAX
             FROM T_MCRE0_APP_STORICO_EVENTI E,
                  T_MCRE0_APP_ANAGR_GRE G,
                  T_MCRE0_APP_STATI S
            WHERE     FLG_CAMBIO_GESTORE = '1'
                  AND DTA_FINE_VAL_TR >= TRUNC (SYSDATE) - 15
                  AND S.FLG_STATO_CHK = 1
                  AND E.COD_GRUPPO_ECONOMICO = G.COD_GRE
                  AND E.COD_STATO = S.COD_MICROSTATO)
    WHERE DTA_FINE_VALIDITA = DTA_FINE_VALIDITA_MAX;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_COMUNIC_NEW_OUT TO MCRE_USR;
