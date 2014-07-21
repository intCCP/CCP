/* Formatted on 21/07/2014 18:42:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_GESTORI_FINE_MESE
(
   COD_ABI,
   COD_NDG,
   COD_PRATICA,
   COD_UO_PRATICA,
   DTA_APERTURA_PL,
   DTA_CHIUSURA_PL,
   VAL_ANNO_APERTURA_PL,
   COD_MATR_PRATICA,
   DTA_FINEDECORRENZAINCARICO,
   DTA_DECORRENZAINCARICO,
   COD_TIPO_STORICO,
   FLG_ATTIVA,
   DTA_INS,
   DTA_UPD
)
AS
   SELECT "COD_ABI",
          "COD_NDG",
          "COD_PRATICA",
          "COD_UO_PRATICA",
          "DTA_APERTURA_PL",
          "DTA_CHIUSURA_PL",
          "VAL_ANNO_APERTURA_PL",
          "COD_MATR_PRATICA",
          "DTA_FINEDECORRENZAINCARICO",
          "DTA_DECORRENZAINCARICO",
          "COD_TIPO_STORICO",
          "FLG_ATTIVA",
          "DTA_INS",
          "DTA_UPD"
     FROM t_mcres_app_gestori_pl a
    WHERE LAST_DAY (
             TO_DATE (SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6),
                      'YYYYMM')) BETWEEN a.dta_decorrenzaincarico
                                     AND NVL (a.dta_finedecorrenzaincarico,
                                              SYSDATE);
