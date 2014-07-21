/* Formatted on 21/07/2014 18:34:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PT_POS_USCITE_MAN1
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
   COD_LIVELLO,
   NUM_POS_RIPORTAFOGLIATI,
   FLG_RIGA_GIUSTA,
   FLG_SRC,
   MAX_FLG_SRC
)
AS
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
          COD_LIVELLO,
          NUM_POS_RIPORTAFOGLIATI,
          1 flg_riga_giusta,
          1 flg_src,
          1 max_flg_src
     FROM MV_MCRE0_APP_PT_POS_USCITE_man
   UNION ALL
   SELECT "COD_ABI_CARTOLARIZZATO",
          "COD_ABI_ISTITUTO",
          "COD_NDG",
          "COD_FILIALE",
          "DTA_USCITA_PT",
          "ID_UTENTE",
          "ID_REFERENTE",
          "COD_COMPARTO",
          "COD_MACROSTATO",
          "COD_STATO",
          "SCSB_UTI_FIRMA",
          "SCSB_UTI_CASSA",
          "SCSB_UTI_TOT",
          "COD_Q",
          "COD_STRUTTURA_COMPETENTE_DC",
          "DESC_STRUTTURA_COMPETENTE_DC",
          "COD_STRUTTURA_COMPETENTE_DV",
          "DESC_STRUTTURA_COMPETENTE_DV",
          "COD_STRUTTURA_COMPETENTE_AR",
          "DESC_STRUTTURA_COMPETENTE_AR",
          "COD_STRUTTURA_COMPETENTE_FI",
          "DESC_STRUTTURA_COMPETENTE_FI",
          "COD_STRUTTURA_COMPETENTE_RG",
          "DESC_STRUTTURA_COMPETENTE_RG",
          "COD_LIVELLO",
          "NUM_POS_RIPORTAFOGLIATI",
          "FLG_RIGA_GIUSTA",
          "FLG_SRC",
          "MAX_FLG_SRC"
     FROM (SELECT all_new.*,
                  MAX (
                     flg_src)
                  OVER (
                     PARTITION BY COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  DTA_USCITA_PT)
                     max_flg_src
             FROM (SELECT oggi_st_eventi.*, 1 flg_src
                     FROM (SELECT DISTINCT
                                  E.COD_ABI_CARTOLARIZZATO,
                                  E.COD_ABI_ISTITUTO,
                                  E.COD_NDG,
                                  E.COD_FILIALE,
                                  E.DTA_DECORRENZA_STATO DTA_USCITA_PT,
                                  E.ID_UTENTE,
                                  e.ID_REFERENTE,
                                  NVL (E.COD_COMPARTO_ASSEGNATO,
                                       E.COD_COMPARTO_CALCOLATO)
                                     COD_COMPARTO,
                                  (SELECT COD_MACROSTATO
                                     FROM T_MCRE0_APP_STATI S
                                    WHERE S.COD_MICROSTATO = E.COD_STATO)
                                     COD_MACROSTATO,
                                  E.COD_STATO,
                                  e.SCSB_UTI_FIRMA,
                                  e.SCSB_UTI_CASSA,
                                  e.SCSB_UTI_TOT,
                                  CASE
                                     WHEN     E.DTA_DECORRENZA_STATO >=
                                                 (SELECT DTA_START_Q
                                                    FROM V_MCRE0_APP_QUARTERS
                                                   WHERE COD_Q = 5)
                                          AND E.DTA_DECORRENZA_STATO <=
                                                 (SELECT DTA_END_Q
                                                    FROM V_MCRE0_APP_QUARTERS
                                                   WHERE COD_Q = 5)
                                     THEN
                                        5
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
                                  C.COD_LIVELLO,
                                  0 NUM_POS_RIPORTAFOGLIATI,
                                  DENSE_RANK ()
                                  OVER (
                                     PARTITION BY E.COD_ABI_CARTOLARIZZATO,
                                                  E.COD_NDG,
                                                  E.DTA_DECORRENZA_STATO
                                     ORDER BY e.DTA_FINE_VALIDITA)
                                     flg_riga_giusta
                             FROM T_MCRE0_APP_STORICO_EVENTI E,
                                  MV_MCRE0_DENORM_STR_ORG S,
                                  T_MCRE0_APP_COMPARTI C
                            WHERE     (SELECT COD_MACROSTATO
                                         FROM T_MCRE0_APP_STATI S
                                        WHERE S.COD_MICROSTATO = E.COD_STATO) IN
                                         ('GA', 'RIO', 'IN', 'SO')
                                  AND E.COD_STATO_PRECEDENTE = 'PT'
                                  AND E.ID_TRANSIZIONE = 'M'
                                  AND E.COD_ABI_ISTITUTO =
                                         S.COD_ABI_ISTITUTO_FI
                                  AND E.COD_FILIALE =
                                         S.COD_STRUTTURA_COMPETENTE_FI
                                  AND C.COD_COMPARTO =
                                         NVL (E.COD_COMPARTO_ASSEGNATO,
                                              E.COD_COMPARTO_CALCOLATO)
                                  AND E.DTA_FINE_VALIDITA >= TRUNC (SYSDATE)
                                  AND e.DTA_DECORRENZA_STATO >=
                                         (SELECT DTA_START_Q
                                            FROM V_MCRE0_APP_QUARTERS
                                           WHERE COD_Q = 5)
                                  AND e.DTA_DECORRENZA_STATO <=
                                         (SELECT DTA_END_Q
                                            FROM V_MCRE0_APP_QUARTERS
                                           WHERE COD_Q = 5)) oggi_st_eventi
                    WHERE flg_riga_giusta = 1
                   UNION ALL
                   SELECT DISTINCT
                          x.COD_ABI_CARTOLARIZZATO,
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
                             WHEN     X.DTA_DECORRENZA_STATO >=
                                         (SELECT DTA_START_Q
                                            FROM V_MCRE0_APP_QUARTERS
                                           WHERE COD_Q = 5)
                                  AND X.DTA_DECORRENZA_STATO <=
                                         (SELECT DTA_END_Q
                                            FROM V_MCRE0_APP_QUARTERS
                                           WHERE COD_Q = 5)
                             THEN
                                5
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
                          X.COD_LIVELLO,
                          0 NUM_POS_RIPORTAFOGLIATI,
                          1 flg_riga_giusta,
                          0 flg_src
                     FROM V_MCRE0_APP_UPD_FIELDS X
                    WHERE     X.COD_MACROSTATO IN ('GA', 'RIO', 'IN', 'SO')
                          AND X.COD_STATO_PRECEDENTE = 'PT'
                          AND X.ID_TRANSIZIONE = 'M'
                          AND NVL (X.FLG_OUTSOURCING, 'N') = 'Y'
                          AND X.DTA_DECORRENZA_STATO >=
                                 (SELECT DTA_START_Q
                                    FROM V_MCRE0_APP_QUARTERS
                                   WHERE COD_Q = 5)
                          AND X.DTA_DECORRENZA_STATO <=
                                 (SELECT DTA_END_Q
                                    FROM V_MCRE0_APP_QUARTERS
                                   WHERE COD_Q = 5)) all_new)
    WHERE max_flg_src = flg_src;
