/* Formatted on 21/07/2014 18:34:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PT_POS_USCITE_MAN0
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_FILIALE,
   DTA_USCITA_PT,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_MACROSTATO,
   COD_STATO,
   SCSB_UTI_FIRMA,
   SCSB_UTI_CASSA,
   SCSB_UTI_TOT,
   COD_Q,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   NUM_POS_RIPORTAFOGLIATI
)
AS
   SELECT                                         -- v1 17/06/2011 VG: New PCR
         DISTINCT
          E.COD_ABI_CARTOLARIZZATO,
          E.COD_ABI_ISTITUTO,
          E.COD_NDG,
          E.COD_FILIALE,
          E.DTA_DECORRENZA_STATO DTA_USCITA_PT,
          E.ID_UTENTE,
          ID_REFERENTE,
          NVL (E.COD_COMPARTO_ASSEGNATO, E.COD_COMPARTO_CALCOLATO)
             COD_COMPARTO,
          (SELECT COD_MACROSTATO
             FROM T_MCRE0_APP_STATI S
            WHERE S.COD_MICROSTATO = E.COD_STATO)
             COD_MACROSTATO,
          E.COD_STATO,
          SCSB_UTI_FIRMA,
          SCSB_UTI_CASSA,
          SCSB_UTI_TOT,
          CASE
             WHEN     E.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 5)
                  AND E.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 5)
             THEN
                5
             WHEN     E.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 4)
                  AND E.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 4)
             THEN
                4
             WHEN     E.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 3)
                  AND E.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 3)
             THEN
                3
             WHEN     E.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 2)
                  AND E.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 2)
             THEN
                2
             WHEN     E.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 1)
                  AND E.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 1)
             THEN
                1
             ELSE
                0
          END
             COD_Q,
          COD_STRUTTURA_COMPETENTE_DC,
          DESC_STRUTTURA_COMPETENTE_DC,
          COD_STRUTTURA_COMPETENTE_DV,
          DESC_STRUTTURA_COMPETENTE_DV,
          COD_STRUTTURA_COMPETENTE_AR,
          DESC_STRUTTURA_COMPETENTE_AR,
          COD_STRUTTURA_COMPETENTE_FI,
          DESC_STRUTTURA_COMPETENTE_FI,
          COD_STRUTTURA_COMPETENTE_RG,
          DESC_STRUTTURA_COMPETENTE_RG,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM T_MCRE0_APP_STORICO_EVENTI E, MV_MCRE0_DENORM_STR_ORG S
    WHERE     (SELECT COD_MACROSTATO
                 FROM T_MCRE0_APP_STATI S
                WHERE S.COD_MICROSTATO = E.COD_STATO) IN
                 ('GA', 'RIO', 'IN', 'SO')
          AND E.COD_STATO_PRECEDENTE = 'PT'
          AND E.ID_TRANSIZIONE = 'M'
          AND E.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI                 --(+)
          AND E.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI              --(+)
          AND E.DTA_FINE_VALIDITA >= TRUNC (SYSDATE)
   UNION ALL
   SELECT COD_ABI_CARTOLARIZZATO,
          COD_ABI_ISTITUTO,
          COD_NDG,
          COD_FILIALE,
          DTA_USCITA_PT,
          ID_UTENTE,
          ID_REFERENTE,
          COD_COMPARTO,
          COD_MACROSTATO,
          COD_STATO,
          SCSB_UTI_FIRMA,
          SCSB_UTI_CASSA,
          SCSB_UTI_TOT,
          COD_Q,
          COD_STRUTTURA_COMPETENTE_DC,
          DESC_STRUTTURA_COMPETENTE_DC,
          COD_STRUTTURA_COMPETENTE_DV,
          DESC_STRUTTURA_COMPETENTE_DV,
          COD_STRUTTURA_COMPETENTE_AR,
          DESC_STRUTTURA_COMPETENTE_AR,
          COD_STRUTTURA_COMPETENTE_FI,
          DESC_STRUTTURA_COMPETENTE_FI,
          COD_STRUTTURA_COMPETENTE_RG,
          DESC_STRUTTURA_COMPETENTE_RG,
          NUM_POS_RIPORTAFOGLIATI
     FROM MV_MCRE0_APP_PT_POS_USCITE_MAN
    WHERE COD_Q > 0
   UNION ALL
   SELECT DISTINCT
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.COD_NDG,
          X.COD_FILIALE,
          X.DTA_DECORRENZA_STATO DTA_USCITA_PT,
          X.ID_UTENTE,
          X.ID_REFERENTE,
          X.COD_COMPARTO,
          X.COD_MACROSTATO,
          X.COD_STATO,
          SCSB_UTI_FIRMA,
          SCSB_UTI_CASSA,
          SCSB_UTI_TOT,
          CASE
             WHEN     X.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 5)
                  AND X.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 5)
             THEN
                5
             WHEN     X.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 4)
                  AND X.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 4)
             THEN
                4
             WHEN     X.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 3)
                  AND X.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 3)
             THEN
                3
             WHEN     X.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 2)
                  AND X.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 2)
             THEN
                2
             WHEN     X.DTA_DECORRENZA_STATO >= (SELECT DTA_START_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 1)
                  AND X.DTA_DECORRENZA_STATO <= (SELECT DTA_END_Q
                                                   FROM V_MCRE0_APP_QUARTERS
                                                  WHERE COD_Q = 1)
             THEN
                1
             ELSE
                0
          END
             COD_Q,
          COD_STRUTTURA_COMPETENTE_DC,
          DESC_STRUTTURA_COMPETENTE_DC,
          COD_STRUTTURA_COMPETENTE_DV,
          DESC_STRUTTURA_COMPETENTE_DV,
          COD_STRUTTURA_COMPETENTE_AR,
          DESC_STRUTTURA_COMPETENTE_AR,
          COD_STRUTTURA_COMPETENTE_FI,
          DESC_STRUTTURA_COMPETENTE_FI,
          COD_STRUTTURA_COMPETENTE_RG,
          DESC_STRUTTURA_COMPETENTE_RG,
          0 NUM_POS_RIPORTAFOGLIATI
     FROM V_MCRE0_APP_UPD_FIELDS X
    --      T_MCRE0_APP_UTENTI U,
    --      T_MCRE0_APP_PCR P,
    --      MV_MCRE0_DENORM_STR_ORG S
    WHERE     X.COD_MACROSTATO IN ('GA', 'RIO', 'IN', 'SO')
          AND X.COD_STATO_PRECEDENTE = 'PT'
          AND X.ID_TRANSIZIONE = 'M'
          AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y';
