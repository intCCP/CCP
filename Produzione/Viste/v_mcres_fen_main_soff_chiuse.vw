/* Formatted on 17/06/2014 18:12:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_CHIUSE
(
   COD_ABI,
   VAL_ANNOMESE,
   COD_NDG,
   COD_SNDG,
   VAL_GBV,
   VAL_GBV_INCASSI,
   VAL_NBV,
   VAL_NBV_INCASSI,
   DTA_CHIUSURA
)
AS
   SELECT                                     -- vg 31/10/2011 : id_per indip.
                              -- AG 05/12/2011 : FIX partition by val_annomese
         cod_abi,
         val_annomese,
         cod_ndg,
         cod_sndg,
         val_gbv,
         val_gbv_incassi,
         val_nbv,
         val_nbv_incassi,
         dta_chiusura
    FROM (SELECT cod_abi,
                 val_annomese,
                 cod_ndg,
                 cod_sndg,
                 val_gbv,
                 val_gbv_incassi,
                 val_nbv,
                 val_nbv_incassi,
                 dta_chiusura,
                 ROW_NUMBER ()
                 OVER (PARTITION BY cod_abi, val_annomese
                       ORDER BY val_gbv DESC)
                    rn
            FROM (  SELECT p.cod_abi,
                           f.val_annomese,
                           p.cod_ndg,
                           r.cod_sndg,
                           SUM (-r.val_imp_gbv_iniziale) val_gbv,
                           DECODE (
                              SUM (-r.val_imp_gbv_iniziale),
                              0, NULL,
                                SUM (-r.val_imp_tot_incassi)
                              / SUM (-r.val_imp_gbv_iniziale))
                              val_gbv_incassi,
                           SUM (-r.val_imp_nbv_iniziale) val_nbv,
                           DECODE (
                              SUM (-r.val_imp_nbv_iniziale),
                              0, NULL,
                                SUM (-r.val_imp_tot_incassi)
                              / SUM (-r.val_imp_nbv_iniziale))
                              val_nbv_incassi,
                           p.dta_chiusura
                      FROM t_mcres_app_rapporti r,
                           t_mcres_app_pratiche p,
                           v_mcres_ultima_acq_bilancio f
                     WHERE     p.flg_attiva = 0
                           AND p.dta_chiusura <= f.dta_dper --per lo storico, prima non c'era!
                           AND p.cod_abi = r.cod_abi
                           AND p.cod_ndg = r.cod_ndg
                           AND P.COD_ABI = F.COD_ABI
                           AND p.dta_chiusura >=
                                  ADD_MONTHS (TO_DATE (F.ID_DPER, 'YYYYMMDD'),
                                              -12)
                  GROUP BY p.cod_abi,
                           p.cod_ndg,
                           r.cod_sndg,
                           p.dta_chiusura,
                           f.val_annomese))
   WHERE rn <= 50;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_MAIN_SOFF_CHIUSE TO MCRE_USR;
