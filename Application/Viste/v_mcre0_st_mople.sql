/* Formatted on 21/07/2014 18:37:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_MOPLE
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DTA_INTERCETTAMENTO,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   ID_TRANSIZIONE,
   DTA_PROCESSO,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO
)
AS
   WITH T_MCRE0_FL_MOPLE
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_MOPL_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FA4_ABI_IST, 5, 0) AS COD_ABI_ISTITUTO,
                   LPAD (FA4_ABI_ELA, 5, 0) AS COD_ABI_CARTOLARIZZATO,
                   RPAD (FA4_NDG_SET, 16, 0) AS COD_NDG,
                   RPAD (FA4_NDG_GRP, 16, 0) AS COD_SNDG,
                   TO_DATE (FA4_DAT_INT, 'ddmmyyyy') AS DTA_INTERCETTAMENTO,
                   SUBSTR (FA4_COD_FIL, 2, 5) AS COD_FILIALE,
                   SUBSTR (FA4_COD_UOP, 2, 5) AS COD_STRUTTURA_COMPETENTE,
                   FA4_TIP_ING AS COD_TIPO_INGRESSO,
                   FA4_CAU_ING AS COD_CAUSALE_INGRESSO,
                   TO_NUMBER (FA4_NUM_PRG_PRO) AS COD_PERCORSO,
                   FA4_COD_PRO AS COD_PROCESSO,
                   FA4_COD_STA AS COD_STATO,
                   TO_DATE (FA4_DAT_DEC_STA, 'ddmmyyyy')
                      AS DTA_DECORRENZA_STATO,
                   TO_DATE (FA4_DAT_SCA_STA, 'ddmmyyyy')
                      AS DTA_SCADENZA_STATO,
                   FA4_COD_STA_PRE AS COD_STATO_PRECEDENTE,
                   FA4_IDN_SIT_POS AS ID_STATO_POSIZIONE,
                   FA4_COD_EST AS COD_CLIENTE_ESTESO,
                   FA4_IND_EST AS ID_CLIENTE_ESTESO,
                   FA4_ANA_GES_MKT AS DESC_ANAG_GESTORE_MKT,
                   FA4_COD_GES_MKT AS COD_GESTORE_MKT,
                   FA4_COD_TIP_POR AS COD_TIPO_PORTAFOGLIO,
                   FA4_FLG_GES_EST AS FLG_GESTIONE_ESTERNA,
                   TO_NUMBER (FA4_PERC_DEC) AS VAL_PERC_DECURTAZIONE,
                   FA4_IDN_TRN AS ID_TRANSIZIONE,
                   TO_DATE (FA4_DAT_PRO, 'ddmmyyyy') AS DTA_PROCESSO,
                   FA4_MAT_CON AS COD_MATR_RISCHIO,
                   FA4_COD_ARE AS COD_UO_RISCHIO,
                   FA4_COD_DIS AS COD_DISP_RISCHIO
              FROM TE_MCRE0_MOPL_INC
             WHERE     FND_MCRE0_is_numeric (FA4_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FA4_ABI_ELA) = 1
                   AND FND_MCRE0_is_numeric (FA4_NDG_SET) = 1
                   AND FND_MCRE0_is_numeric (FA4_NDG_GRP) = 1
                   AND FND_MCRE0_is_date (FA4_DAT_INT) = 1
                   AND FND_MCRE0_is_numeric (FA4_COD_FIL) = 1
                   AND FND_MCRE0_is_numeric (FA4_COD_UOP) = 1
                   AND FND_MCRE0_is_numeric (FA4_NUM_PRG_PRO) = 1
                   AND FND_MCRE0_is_date (FA4_DAT_DEC_STA) = 1
                   AND FND_MCRE0_is_date (FA4_DAT_SCA_STA) = 1
                   AND FND_MCRE0_is_numeric (FA4_PERC_DEC) = 1
                   AND FND_MCRE0_is_date (FA4_DAT_PRO) = 1)
   SELECT "ID_DPER",
          "COD_ABI_ISTITUTO",
          "COD_ABI_CARTOLARIZZATO",
          "COD_NDG",
          "COD_SNDG",
          "DTA_INTERCETTAMENTO",
          "COD_FILIALE",
          "COD_STRUTTURA_COMPETENTE",
          "COD_TIPO_INGRESSO",
          "COD_CAUSALE_INGRESSO",
          "COD_PERCORSO",
          "COD_PROCESSO",
          "COD_STATO",
          "DTA_DECORRENZA_STATO",
          "DTA_SCADENZA_STATO",
          "COD_STATO_PRECEDENTE",
          "ID_STATO_POSIZIONE",
          "COD_CLIENTE_ESTESO",
          "ID_CLIENTE_ESTESO",
          "DESC_ANAG_GESTORE_MKT",
          "COD_GESTORE_MKT",
          "COD_TIPO_PORTAFOGLIO",
          "FLG_GESTIONE_ESTERNA",
          "VAL_PERC_DECURTAZIONE",
          "ID_TRANSIZIONE",
          "DTA_PROCESSO",
          "COD_MATR_RISCHIO",
          "COD_UO_RISCHIO",
          "COD_DISP_RISCHIO"
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER, COD_ABI_CARTOLARIZZATO, COD_NDG)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_SNDG,
                  DTA_INTERCETTAMENTO,
                  COD_FILIALE,
                  COD_STRUTTURA_COMPETENTE,
                  COD_TIPO_INGRESSO,
                  COD_CAUSALE_INGRESSO,
                  COD_PERCORSO,
                  COD_PROCESSO,
                  COD_STATO,
                  DTA_DECORRENZA_STATO,
                  DTA_SCADENZA_STATO,
                  COD_STATO_PRECEDENTE,
                  ID_STATO_POSIZIONE,
                  COD_CLIENTE_ESTESO,
                  ID_CLIENTE_ESTESO,
                  DESC_ANAG_GESTORE_MKT,
                  COD_GESTORE_MKT,
                  COD_TIPO_PORTAFOGLIO,
                  FLG_GESTIONE_ESTERNA,
                  VAL_PERC_DECURTAZIONE,
                  ID_TRANSIZIONE,
                  DTA_PROCESSO,
                  COD_MATR_RISCHIO,
                  COD_UO_RISCHIO,
                  COD_DISP_RISCHIO
             FROM T_MCRE0_FL_MOPLE) tmp
    WHERE     NUM_RECS = 1
          AND ID_DPER IS NOT NULL
          AND COD_ABI_CARTOLARIZZATO IS NOT NULL
          AND COD_NDG IS NOT NULL;
