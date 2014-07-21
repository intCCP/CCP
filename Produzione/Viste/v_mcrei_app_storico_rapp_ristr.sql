/* Formatted on 17/06/2014 18:08:50 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_STORICO_RAPP_RISTR
(
   COD_ABI,
   COD_NDG,
   VAL_ORDINALE,
   FLG_RISTRUTTURATO,
   DTA_INIZIO_SEGN,
   DTA_FINE_SEGN,
   COD_RAPPORTO,
   COD_FORMA_TECNICA,
   VAL_UTIL_LORDO,
   VAL_UTIL_NETTO,
   COD_NPE,
   FLG_ESTINTO,
   DTA_ESTINZIONE,
   FLG_NUOVO,
   DTA_NASCITA
)
AS
   SELECT rr.cod_abi,
          rr.cod_ndg,
          rr.val_ordinale,
          (CASE
              WHEN FLG_eSTINTO = 'Y' AND FLG_RISTRUTTURATO = 'Y' THEN 'N'
              ELSE FLG_RISTRUTTURATO
           END)
             AS flg_ristrutturato,
          rr.dta_inizio_segnalazione_ristr AS dta_inizio_segn,
          (CASE
              WHEN FLG_eSTINTO = 'Y' AND FLG_RISTRUTTURATO = 'Y'
              THEN
                 DTA_ESTINZIONE
              ELSE
                 rr.dta_FINE_segnalazione_ristr
           END)
             AS dta_fine_segn,                                        --11 DEC
          rr.cod_rapporto AS cod_rapporto,
          rr.cod_forma_tecnica AS cod_forma_tecnica,
          NVL (rr.val_utilizzato_netto, 0) + NVL (rr.val_utilizzato_mora, 0)
             AS val_util_lordo,
          rr.val_utilizzato_netto AS val_util_netto,
          rr.COD_NPE,                                                 --22 ott
          flg_Estinto,
          dta_estinzione,
          flg_nuovo,
          dta_nascita
     FROM t_mcrei_hst_rapp_ristr rr;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCREI_APP_STORICO_RAPP_RISTR TO MCRE_USR;
