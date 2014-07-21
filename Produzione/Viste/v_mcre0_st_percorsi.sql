/* Formatted on 17/06/2014 18:06:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_PERCORSI
(
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_USCITA_STATO,
   COD_PERCORSO,
   TMS,
   FLG_ANNULLO,
   COD_CODUTRM,
   COD_PROCESSO,
   VAL_IMP_ACC_CASSA,
   VAL_IMP_UTI_CASSA,
   VAL_IMP_ACC_FIRMA,
   VAL_IMP_UTI_FIRMA,
   DTA_PROCESSO,
   COD_TIPO_VARIAZIONE,
   FLG_FATAL
)
AS
   WITH T_MCRE0_FL_PERCORSI
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_PERC_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   LPAD (FA5_ABI_IST, 5, 0) COD_ABI_ISTITUTO,
                   LPAD (FA5_ABI_ELA, 5, 0) COD_ABI_CARTOLARIZZATO,
                   RPAD (FA6_NDG_SET, 16, 0) COD_NDG,
                   TRIM (FA5_COD_STA_PRE) COD_STATO_PRECEDENTE,
                   TRIM (FA5_COD_STA) COD_STATO,
                   TO_DATE (FA5_DAT_DEC_STA, 'ddmmyyyy') DTA_DECORRENZA_STATO,
                   TO_DATE (FA5_DAT_SCA_STA, 'ddmmyyyy') DTA_SCADENZA_STATO,
                   TO_DATE (FA5_DAT_USC_STA, 'ddmmyyyy') DTA_USCITA_STATO,
                   TO_NUMBER (FA5_NUM_PRG_PRO) COD_PERCORSO,
                   TRIM (FA5_TMS) TMS,
                   TRIM (FA5_FLG_ANN) FLG_ANNULLO,
                   TRIM (FA5_COD_UTR) COD_CODUTRM,
                   TRIM (FA5_COD_PRO) COD_PROCESSO,
                   TO_NUMBER (TRIM (FA5_IMP_ACC_CAS)) VAL_IMP_ACC_CASSA,
                   TO_NUMBER (TRIM (FA5_IMP_UTI_CAS)) VAL_IMP_UTI_CASSA,
                   TO_NUMBER (TRIM (FA5_IMP_ACC_FIR)) VAL_IMP_ACC_FIRMA,
                   TO_NUMBER (TRIM (FA5_IMP_UTI_FIR)) VAL_IMP_UTI_FIRMA,
                   TO_DATE (FA5_DAT_PRO, 'ddmmyyyy') DTA_PROCESSO,
                   TRIM (FA5_IDN_TIP_VAR) COD_TIPO_VARIAZIONE,
                   TRIM (FA5_FLG_FAT) FLG_FATAL
              FROM TE_MCRE0_PERC_INC
             WHERE     FND_MCRE0_is_numeric (FA5_ABI_IST) = 1
                   AND FND_MCRE0_is_numeric (FA5_ABI_ELA) = 1
                   AND FND_MCRE0_is_numeric (FA6_NDG_SET) = 1
                   AND FND_MCRE0_is_date (FA5_DAT_DEC_STA) = 1
                   AND FND_MCRE0_is_date (FA5_DAT_SCA_STA) = 1
                   AND FND_MCRE0_is_date (FA5_DAT_USC_STA) = 1
                   AND FND_MCRE0_is_numeric (FA5_NUM_PRG_PRO) = 1
                   AND FND_MCRE0_is_date (FA5_DAT_PRO) = 1)
   SELECT ID_DPER,
          COD_ABI_ISTITUTO,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_STATO_PRECEDENTE,
          COD_STATO,
          DTA_DECORRENZA_STATO,
          DTA_SCADENZA_STATO,
          DTA_USCITA_STATO,
          COD_PERCORSO,
          TMS,
          FLG_ANNULLO,
          COD_CODUTRM,
          COD_PROCESSO,
          VAL_IMP_ACC_CASSA,
          VAL_IMP_UTI_CASSA,
          VAL_IMP_ACC_FIRMA,
          VAL_IMP_UTI_FIRMA,
          DTA_PROCESSO,
          COD_TIPO_VARIAZIONE,
          FLG_FATAL
     FROM (SELECT COUNT (
                     1)
                  OVER (
                     PARTITION BY ID_DPER,
                                  COD_ABI_CARTOLARIZZATO,
                                  COD_NDG,
                                  TMS)
                     NUM_RECS,
                  ID_DPER,
                  COD_ABI_ISTITUTO,
                  COD_ABI_CARTOLARIZZATO,
                  COD_NDG,
                  COD_STATO_PRECEDENTE,
                  COD_STATO,
                  DTA_DECORRENZA_STATO,
                  DTA_SCADENZA_STATO,
                  DTA_USCITA_STATO,
                  COD_PERCORSO,
                  TMS,
                  FLG_ANNULLO,
                  COD_CODUTRM,
                  COD_PROCESSO,
                  VAL_IMP_ACC_CASSA,
                  VAL_IMP_UTI_CASSA,
                  VAL_IMP_ACC_FIRMA,
                  VAL_IMP_UTI_FIRMA,
                  DTA_PROCESSO,
                  COD_TIPO_VARIAZIONE,
                  FLG_FATAL
             FROM T_MCRE0_FL_PERCORSI) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (ID_DPER)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_ABI_CARTOLARIZZATO)) IS NOT NULL
          AND TRIM (TO_CHAR (COD_NDG)) IS NOT NULL
          AND TRIM (TO_CHAR (TMS)) IS NOT NULL;


GRANT SELECT ON MCRE_OWN.V_MCRE0_ST_PERCORSI TO MCRE_USR;
