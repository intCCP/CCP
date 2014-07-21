/* Formatted on 21/07/2014 18:37:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_IRIS
(
   ID_DPER,
   COD_SNDG,
   DTA_RIFERIMENTO,
   VAL_IRIS_GRE,
   VAL_IRIS_CLI,
   VAL_LIV_RISCHIO_GRE,
   VAL_LIV_RISCHIO_CLI,
   VAL_LGD,
   DTA_LGD,
   VAL_EAD,
   DTA_EAD,
   VAL_PA,
   DTA_PA,
   VAL_PD_MONITORAGGIO,
   DTA_PD_MONITORAGGIO,
   VAL_RATING_MONITORAGGIO,
   VAL_IND_UTL_INTERNO,
   VAL_IND_UTL_ESTERNO,
   VAL_IND_UTL_COMPLESSIVO,
   VAL_IND_RATA,
   VAL_IND_ROTAZIONE,
   VAL_IND_INDEBITAMENTO,
   VAL_IND_INSOL_PORTAF,
   FLG_FATAL
)
AS
   WITH T_MCRE0_FL_IRIS
        AS (SELECT (SELECT TO_NUMBER (
                              TO_CHAR (
                                 TO_DATE (TRIM (PERIODO_RIF), 'DDMMYYYY'),
                                 'YYYYMMDD'))
                      FROM TE_MCRE0_IRIS_IDT
                     WHERE ROWNUM = 1)
                      ID_DPER,
                   RPAD (FAD_NDG_GRP, 16, 0) AS COD_SNDG,
                   TO_DATE (FAD_DAT_RIF, 'MMYYYY') AS DTA_RIFERIMENTO,
                     TO_NUMBER (FAD_IRS_GRP_ECO)
                   * DECODE (FAD_IRS_GRP_ECO_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IRIS_GRE,
                     TO_NUMBER (FAD_IRS_CLI_GRP)
                   * DECODE (FAD_IRS_CLI_GRP_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IRIS_CLI,
                   TRIM (FAD_LRI_GRP_ECO) AS VAL_LIV_RISCHIO_GRE,
                   TRIM (FAD_LRI_CLI) AS VAL_LIV_RISCHIO_CLI,
                   TO_NUMBER (FAD_LGD) AS VAL_LGD,
                   TO_DATE (FAD_DAT_RIF_LGD, 'DDMMYYYY') AS DTA_LGD,
                   TO_NUMBER (FAD_EAD) AS VAL_EAD,
                   TO_DATE (FAD_DAT_RIF_EAD, 'DDMMYYYY') AS DTA_EAD,
                   TO_NUMBER (FAD_PA) AS VAL_PA,
                   TO_DATE (FAD_DAT_RIF_PA, 'DDMMYYYY') AS DTA_PA,
                   TO_NUMBER (FAD_PDM) AS VAL_PD_MONITORAGGIO,
                   TO_DATE (FAD_DAT_RIF_PDM, 'DDMMYYYY')
                      AS DTA_PD_MONITORAGGIO,
                   TRIM (FAD_RAT_MON) AS VAL_RATING_MONITORAGGIO,
                     TO_NUMBER (FAD_IND_UTL_INT)
                   * DECODE (FAD_IND_UTL_INT_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_UTL_INTERNO,
                     TO_NUMBER (FAD_IND_UTL_EST)
                   * DECODE (FAD_IND_UTL_EST_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_UTL_ESTERNO,
                     TO_NUMBER (FAD_IND_UTL_CPL)
                   * DECODE (FAD_IND_UTL_CPL_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_UTL_COMPLESSIVO,
                     TO_NUMBER (FAD_IND_RAT)
                   * DECODE (FAD_IND_RAT_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_RATA,
                     TO_NUMBER (FAD_IND_RTZ)
                   * DECODE (FAD_IND_RTZ_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_ROTAZIONE,
                     TO_NUMBER (FAD_IND_IDB)
                   * DECODE (FAD_IND_IDB_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_INDEBITAMENTO,
                     TO_NUMBER (FAD_IND_INS_POR)
                   * DECODE (FAD_IND_INS_POR_SGN,  '-', -1,  '+', 1,  0)
                      AS VAL_IND_INSOL_PORTAF,
                   FAD_FLG_FAT AS FLG_FATAL
              FROM TE_MCRE0_IRIS_INC
             WHERE     FND_MCRE0_is_numeric (FAD_NDG_GRP) = 1
                   AND FND_MCRE0_is_date ('01' || FAD_DAT_RIF) = 1
                   AND FND_MCRE0_is_numeric (FAD_IRS_GRP_ECO) = 1
                   AND FND_MCRE0_is_numeric (FAD_IRS_CLI_GRP) = 1
                   AND FND_MCRE0_is_numeric (FAD_LGD) = 1
                   AND FND_MCRE0_is_date (FAD_DAT_RIF_LGD) = 1
                   AND FND_MCRE0_is_numeric (FAD_EAD) = 1
                   AND FND_MCRE0_is_date (FAD_DAT_RIF_EAD) = 1
                   AND FND_MCRE0_is_numeric (FAD_PA) = 1
                   AND FND_MCRE0_is_date (FAD_DAT_RIF_PA) = 1
                   AND FND_MCRE0_is_numeric (FAD_PDM) = 1
                   AND FND_MCRE0_is_date (FAD_DAT_RIF_PDM) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_UTL_INT) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_UTL_EST) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_UTL_CPL) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_RAT) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_RTZ) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_IDB) = 1
                   AND FND_MCRE0_is_numeric (FAD_IND_INS_POR) = 1)
   SELECT "ID_DPER",
          "COD_SNDG",
          "DTA_RIFERIMENTO",
          "VAL_IRIS_GRE",
          "VAL_IRIS_CLI",
          "VAL_LIV_RISCHIO_GRE",
          "VAL_LIV_RISCHIO_CLI",
          "VAL_LGD",
          "DTA_LGD",
          "VAL_EAD",
          "DTA_EAD",
          "VAL_PA",
          "DTA_PA",
          "VAL_PD_MONITORAGGIO",
          "DTA_PD_MONITORAGGIO",
          "VAL_RATING_MONITORAGGIO",
          "VAL_IND_UTL_INTERNO",
          "VAL_IND_UTL_ESTERNO",
          "VAL_IND_UTL_COMPLESSIVO",
          "VAL_IND_RATA",
          "VAL_IND_ROTAZIONE",
          "VAL_IND_INDEBITAMENTO",
          "VAL_IND_INSOL_PORTAF",
          "FLG_FATAL"
     FROM (SELECT COUNT (1) OVER (PARTITION BY id_dper, cod_sndg) num_recs,
                  id_dper,
                  cod_sndg,
                  dta_riferimento,
                  val_iris_gre,
                  val_iris_cli,
                  val_liv_rischio_gre,
                  val_liv_rischio_cli,
                  val_lgd,
                  dta_lgd,
                  val_ead,
                  dta_ead,
                  val_pa,
                  dta_pa,
                  val_pd_monitoraggio,
                  dta_pd_monitoraggio,
                  val_rating_monitoraggio,
                  val_ind_utl_interno,
                  val_ind_utl_esterno,
                  val_ind_utl_complessivo,
                  val_ind_rata,
                  val_ind_rotazione,
                  val_ind_indebitamento,
                  val_ind_insol_portaf,
                  flg_fatal
             FROM T_MCRE0_FL_IRIS) tmp
    WHERE     NUM_RECS = 1
          AND TRIM (TO_CHAR (id_dper)) IS NOT NULL
          AND TRIM (TO_CHAR (cod_sndg)) IS NOT NULL;
