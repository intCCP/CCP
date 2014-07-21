/* Formatted on 21/07/2014 18:43:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SPESENR
(
   COD_ABI,
   COD_NDG,
   ID_DPER,
   VAL_INTEST_NDG,
   COD_UO_CAPOF,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_STATO_GIUR,
   DTD_STATO_GIUR,
   DTA_APER_SOFF,
   DTA_DISP_DOC,
   DTA_CREAZ_MOD,
   VAL_IMP_VAL_NOM,
   COD_URGENZA,
   FLG_GAR_REALE,
   FLG_GAR_PERS,
   FLG_PROC_CONC,
   DTA_ST_PROVV,
   DTA_ST_CONF,
   DTA_ST_COMPL,
   DTA_ST_APPROV,
   DTA_ST_NON_DOC,
   DTA_ST_DOCUM,
   DTA_ST_DOC_PARZ,
   DTA_ST_DIGIT,
   DTA_ST_SCANN,
   DTA_ST_DA_ASS,
   DTA_ST_ASSEGN,
   DTA_ST_GEST_IT,
   VAL_ANNO_APERT_PRATC,
   VAL_NUM_PROG_PRATC,
   COD_STATO_PREC,
   DTA_RIASSEGN,
   DTA_APERT_PRAT,
   DTA_CHIUS_PRAT,
   VAL_MOT_CHIUS_PRAT,
   COD_STATO_WF,
   VAL_SPESE_NON_RIP_INT,
   VAL_SPESE_NON_RIP_EST,
   FLG_INT_ESTPIC,
   VAL_IMP_GBV,
   VAL_IMP_NBV,
   VAL_PERC_DUBESI,
   DESC_MOT_GEST_INT,
   DTA_INCASSO,
   FLG_GARAN,
   VAL_IMP_GAR_IPO
)
AS
     SELECT COD_ABI,
            COD_NDG,
            ID_DPER,
            VAL_INTEST_NDG,
            COD_UO_CAPOF,
            COD_UO_PRATICA,
            COD_MATR_PRATICA,
            COD_STATO_GIUR,
            DTD_STATO_GIUR,
            DTA_APER_SOFF,
            DTA_DISP_DOC,
            DTA_CREAZ_MOD,
            VAL_IMP_VAL_NOM,
            COD_URGENZA,
            FLG_GAR_REALE,
            FLG_GAR_PERS,
            FLG_PROC_CONC,
            DTA_ST_PROVV,
            DTA_ST_CONF,
            DTA_ST_COMPL,
            DTA_ST_APPROV,
            DTA_ST_NON_DOC,
            DTA_ST_DOCUM,
            DTA_ST_DOC_PARZ,
            DTA_ST_DIGIT,
            DTA_ST_SCANN,
            DTA_ST_DA_ASS,
            TO_CHAR (dta_st_assegn, 'YYYYMMDD') dta_st_assegn,
            DTA_ST_GEST_IT,
            VAL_ANNO_APERT_PRATC,
            VAL_NUM_PROG_PRATC,
            COD_STATO_PREC,
            DTA_RIASSEGN,
            DTA_APERT_PRAT,
            DTA_CHIUS_PRAT,
            VAL_MOT_CHIUS_PRAT,
            COD_STATO_WF,
            SUM (
               CASE
                  WHEN flg_gestione = 'I' THEN NVL (VAL_IMPORTO_VALORE, 0)
                  WHEN flg_gestione = 'E' THEN 0
               END)
               VAL_SPESE_NON_RIP_INT,
            SUM (
               CASE
                  WHEN flg_gestione = 'I' THEN 0
                  WHEN flg_gestione = 'E' THEN NVL (VAL_IMPORTO_VALORE, 0)
               END)
               VAL_SPESE_NON_RIP_EST,
            FLG_INT_ESTPIC,
            VAL_IMP_GBV,
            VAL_IMP_NBV,
            VAL_PERC_DUBESI,
            DESC_MOT_GEST_INT,
            DTA_INCASSO,
            FLG_GARAN,
            VAL_IMP_GAR_IPO
       FROM (SELECT s.*,
                    d.VAL_IMPORTO_VALORE,
                    CASE
                       WHEN dta_st_assegn IS NOT NULL
                       THEN                             ----- Gestione Esterna
                          CASE
                             WHEN TO_CHAR (dta_st_assegn, 'YYYYMM') =
                                     SUBSTR (s.id_dper, 1, 6)
                             THEN
                                CASE
                                   WHEN dta_fattura < dta_st_assegn THEN 'I' ----- Gestione Interna
                                   WHEN dta_fattura >= dta_st_assegn THEN 'E' ----- Gestione Esterna
                                END
                             WHEN TO_CHAR (dta_fattura, 'YYYYMM') <
                                     SUBSTR (s.id_dper, 1, 6)
                             THEN
                                CASE
                                   WHEN TO_CHAR (dta_fattura, 'YYYYMM') =
                                           SUBSTR (s.id_dper, 1, 6)
                                   THEN
                                      'E'               ----- Gestione Esterna
                                   ELSE
                                      'E'                   ----- Gestione ???
                                END
                             ELSE
                                'I'             ---- Non si può verificare ???
                          END
                       WHEN dta_st_assegn IS NULL
                       THEN
                          'I'                           ----- Gestione Interna
                    END
                       flg_gestione
               FROM t_mcres_app_sp_spesenr s,
                    (SELECT cod_abi,
                            cod_ndg,
                            cod_pratica,
                            VAL_ANNO_PRATICA,
                            dta_fattura,
                            VAL_IMPORTO_VALORE
                       FROM t_mcres_app_sp_spese
                      WHERE cod_stato = 'CO' AND flg_spesa_ripetibile = 'N') d
              WHERE     s.cod_abi = d.cod_abi(+)
                    AND s.cod_ndg = d.cod_ndg(+)
                    AND s.VAL_NUM_PROG_PRATC = d.cod_pratica(+)
                    AND S.VAL_ANNO_APERT_PRATC = D.VAL_ANNO_PRATICA(+))
   GROUP BY COD_ABI,
            COD_NDG,
            ID_DPER,
            VAL_INTEST_NDG,
            COD_UO_CAPOF,
            COD_UO_PRATICA,
            COD_MATR_PRATICA,
            COD_STATO_GIUR,
            DTD_STATO_GIUR,
            DTA_APER_SOFF,
            DTA_DISP_DOC,
            DTA_CREAZ_MOD,
            VAL_IMP_VAL_NOM,
            COD_URGENZA,
            FLG_GAR_REALE,
            FLG_GAR_PERS,
            FLG_PROC_CONC,
            DTA_ST_PROVV,
            DTA_ST_CONF,
            DTA_ST_COMPL,
            DTA_ST_APPROV,
            DTA_ST_NON_DOC,
            DTA_ST_DOCUM,
            DTA_ST_DOC_PARZ,
            DTA_ST_DIGIT,
            DTA_ST_SCANN,
            DTA_ST_DA_ASS,
            DTA_ST_ASSEGN,
            DTA_ST_GEST_IT,
            VAL_ANNO_APERT_PRATC,
            VAL_NUM_PROG_PRATC,
            COD_STATO_PREC,
            DTA_RIASSEGN,
            DTA_APERT_PRAT,
            DTA_CHIUS_PRAT,
            VAL_MOT_CHIUS_PRAT,
            COD_STATO_WF,
            FLG_INT_ESTPIC,
            VAL_IMP_GBV,
            VAL_IMP_NBV,
            VAL_PERC_DUBESI,
            DESC_MOT_GEST_INT,
            DTA_INCASSO,
            FLG_GARAN,
            VAL_IMP_GAR_IPO;
