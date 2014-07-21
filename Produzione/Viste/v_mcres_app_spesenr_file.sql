/* Formatted on 17/06/2014 18:11:40 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESENR_FILE
(
   LINE
)
AS
   SELECT    RPAD (NVL (DECODE (COD_ABI, '01025', '03069', COD_ABI), ' '),
                   5,
                   ' ')
          || RPAD (NVL (COD_NDG, ' '), 13, ' ')
          || RPAD (NVL (TO_CHAR (ID_DPER), ' '), 8, ' ')
          || RPAD (NVL (VAL_INTEST_NDG, ' '), 30, ' ')
          || RPAD (NVL (COD_UO_CAPOF, ' '), 5, ' ')
          || RPAD (NVL (COD_UO_PRATICA, ' '), 5, ' ')
          || RPAD (NVL (COD_MATR_PRATICA, ' '), 6, ' ')
          || RPAD (NVL (COD_STATO_GIUR, ' '), 1, ' ')
          || RPAD (NVL (DTD_STATO_GIUR, ' '), 8, ' ')
          || RPAD (NVL (DTA_APER_SOFF, ' '), 8, ' ')
          || RPAD (NVL (DTA_DISP_DOC, ' '), 8, ' ')
          || RPAD (NVL (DTA_CREAZ_MOD, ' '), 8, ' ')
          || RPAD (NVL (VAL_IMP_VAL_NOM, ' '), 16, ' ')
          || RPAD (NVL (COD_URGENZA, ' '), 3, ' ')
          || RPAD (NVL (FLG_GAR_REALE, ' '), 1, ' ')
          || RPAD (NVL (FLG_GAR_PERS, ' '), 1, ' ')
          || RPAD (NVL (FLG_PROC_CONC, ' '), 1, ' ')
          || RPAD (NVL (DTA_ST_PROVV, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_CONF, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_COMPL, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_APPROV, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_NON_DOC, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_DOCUM, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_DOC_PARZ, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_DIGIT, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_SCANN, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_DA_ASS, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_ASSEGN, ' '), 8, ' ')
          || RPAD (NVL (DTA_ST_GEST_IT, ' '), 8, ' ')
          || RPAD (NVL (VAL_ANNO_APERT_PRATC, ' '), 4, ' ')
          || RPAD (NVL (VAL_NUM_PROG_PRATC, ' '), 11, ' ')
          || RPAD (NVL (COD_STATO_PREC, ' '), 1, ' ')
          || RPAD (NVL (DTA_RIASSEGN, ' '), 8, ' ')
          || RPAD (NVL (DTA_APERT_PRAT, ' '), 8, ' ')
          || RPAD (NVL (DTA_CHIUS_PRAT, ' '), 8, ' ')
          || RPAD (NVL (VAL_MOT_CHIUS_PRAT, ' '), 2, ' ')
          || RPAD (NVL (COD_STATO_WF, ' '), 3, ' ')
          || RPAD (NVL (TO_CHAR (VAL_SPESE_NON_RIP_INT), ' '), 16, ' ')
          || RPAD (NVL (TO_CHAR (VAL_SPESE_NON_RIP_EST), ' '), 16, ' ')
          || RPAD (NVL (FLG_INT_ESTPIC, ' '), 1, ' ')
          || RPAD (NVL (VAL_IMP_GBV, ' '), 16, ' ')
          || RPAD (NVL (VAL_IMP_NBV, ' '), 16, ' ')
          || RPAD (NVL (VAL_PERC_DUBESI, ' '), 5, ' ')
          || RPAD (NVL (DESC_MOT_GEST_INT, ' '), 50, ' ')
          || RPAD (NVL (DTA_INCASSO, ' '), 8, ' ')
          || RPAD (NVL (FLG_GARAN, ' '), 1, ' ')
          || RPAD (NVL (VAL_IMP_GAR_IPO, ' '), 16, ' ')
          || RPAD (NVL (NULL, ' '), 37, ' ')
             line
     FROM V_MCRES_APP_SPESENR
    WHERE cod_abi = SYS_CONTEXT ('userenv', 'client_info');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_SPESENR_FILE TO MCRE_USR;
