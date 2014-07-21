/* Formatted on 21/07/2014 18:36:14 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SISBA_CP
(
   RECORD_CHAR
)
AS
   SELECT    SUBSTR (ID_DPER, 1, 6)
          || LPAD (COD_ABI, 5, 0)
          || LPAD (NVL (TO_CHAR (DTA_SISBA_CP, 'yyyymmdd'), ' '), 8, ' ')
          || LPAD (NVL (COD_FILIALE_AREA, ' '), 5, ' ')
          || LPAD (NVL (COD_FILIALE, ' '), 5, ' ')
          || LPAD (COD_NDG, 16, 0)
          || NVL (LPAD (COD_SNDG, 16, 0), LPAD (' ', 16, ' '))
          || LPAD (NVL (COD_STATO_GIURIDICO, ' '), 1, ' ')
          || LPAD (NVL (TO_CHAR (DTA_DECORRENZA_STATO, 'yyyymmdd'), ' '),
                   8,
                   ' ')
          || LPAD (COD_SPORTELLO, 7, ' ')
          || LPAD (COD_RAPPORTO, 32, ' ')
          || LPAD (NVL (COD_RAPPORTO_ORIG, ' '), 12, ' ')
          || LPAD (NVL (COD_FORMA_TECN, ' '), 5, ' ')
          || LPAD (NVL (COD_FORMA_TECN_CMLT, ' '), 3, ' ')
          || LPAD (NVL (VAL_UTI_RET * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_VANT * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_ATT * 100, 0), 22, ' ')
          || LPAD (NVL (COD_SEGM_IRB, ' '), 5, ' ')
          || LPAD (NVL (COD_SEGM_STAND, ' '), 5, ' ')
          || LPAD (NVL (COD_R437, ' '), 2, ' ')
          || LPAD (NVL (VAL_IMP_GAR_IPOT * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_MORA * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_RATEO_MORA * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_RATEO_CORR * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_UTI_FIRMA * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_STRALCI_FISC_CAP * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_STRALCI_FISC_MORA * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_STRALCI_ALTRI_CAP * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_STRALCI_ALTRI_MORA * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_SOPRAVVENIENZE * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_NUM_ATT * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_NUM_DUBBIO_ESITO * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_DELTA_IAS_LORDO * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_DELTA_IAS_RET * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_FIRMA, ' '), 8, ' ')
          || LPAD (NVL (COD_STATO_RISCHIO, ' '), 2, ' ')
          || LPAD (NVL (TO_CHAR (DTA_INS, 'yyyymmdd'), ' '), 8, ' ')
          || LPAD (NVL (TO_CHAR (DTA_UPD, 'yyyymmdd'), ' '), 8, ' ')
          || LPAD (NVL (COD_OPERATORE_INS_UPD, ' '), 20, ' ')
          || LPAD (NVL (FLG_TAPPO, ' '), 1, ' ')
          || LPAD (NVL (VAL_UTI_RET_OLD * 100, 0), 22, ' ')
          || LPAD (NVL (VAL_ATT_OLD * 100, 0), 22, ' ')
     FROM T_MCRES_APP_SISBA_CP
    WHERE ID_DPER =
             TO_CHAR (
                LAST_DAY (
                   TO_DATE (SYS_CONTEXT ('userenv', 'client_info'), 'yyyymm')),
                'yyyymmdd');
