/* Formatted on 21/07/2014 18:33:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_EFFETTI_ECONOMICI
(
   RECORD_CHAR
)
AS
   SELECT (   SUBSTR (ID_DPER, 1, 6)
           || LPAD (COD_ABI, 5, 0)
           || LPAD (NVL (TO_CHAR (DTA_EFFETTI_ECONOMICI, 'YYYYMMDD'), ' '),
                    8,
                    ' ')
           || LPAD (COD_NDG, 16, 0)
           || LPAD (NVL (VAL_RIP_MORA * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_PER_CE * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_QUOTA_SVAL * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_QUOTA_ATT * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_RETT_SVAL * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_RIP_SVAL * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_RETT_ATT * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_RIP_ATT * 100, 0), 22, ' ')
           || LPAD (NVL (VAL_ATTUALIZZAZIONE * 100, 0), 22, ' ')
           || LPAD (NVL (COD_STATO_INI, ' '), 3, ' ')
           || LPAD (NVL (COD_STATO_FIN, ' '), 3, ' ')
           || LPAD (NVL (TO_CHAR (DTA_INS, 'YYYYMMDD'), ' '), 8, ' ')
           || LPAD (NVL (TO_CHAR (DTA_UPD, 'YYYYMMDD'), ' '), 8, ' ')
           || LPAD (NVL (COD_OPERATORE_INS_UPD, ' '), 20, ' ')
           || LPAD (NVL (FLG_TAPPO, ' '), 1, ' '))
     FROM T_MCRES_APP_EFFETTI_ECONOMICI
    WHERE ID_DPER =
             TO_CHAR (
                LAST_DAY (
                   TO_DATE (SYS_CONTEXT ('userenv', 'client_info'), 'yyyymm')),
                'yyyymmdd');
