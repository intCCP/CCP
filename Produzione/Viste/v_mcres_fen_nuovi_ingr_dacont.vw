/* Formatted on 17/06/2014 18:12:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_DACONT
(
   COD_ABI,
   VAL_ANNOMESE,
   VAL_TOT_NDG,
   VAL_TOT_NDG_OVER,
   VAL_TOT_NDG_UNDER,
   VAL_TOT_NDG_CR,
   VAL_GBV,
   VAL_GBV_OVER,
   VAL_GBV_UNDER,
   VAL_GBV_CR,
   VAL_STIMA_NBV,
   VAL_STIMA_NBV_OVER,
   VAL_STIMA_NBV_UNDER,
   VAL_STIMA_NBV_CR,
   VAL_INDICE_COPERTURA
)
AS
     SELECT            -- AG 30/01/2012: Importi dal flusso Proposte (Incagli)
            -- AG 24/02/2012: APP_PROPOSTE --> ST_PROPOSTE
            -- AG 24/02/2012: FIX Indice di copertura  (formula and nullif)
            -- AG 02/03/2012: APP_DELIBERE per dati delle proposte e row_number() = 1
            --AG 23/04/2012: VAL_ACCORDATO_DERIVATI ed NVL
            pos.cod_abi,
            v.val_annomese_sisba_cp val_annomese,
            /*
                Conteggio posizioni
            */
            COUNT (DISTINCT pos.cod_ndg) val_tot_ndg,
            SUM (
               CASE
                  WHEN d.val_proposta >= 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     1
                  ELSE
                     0
               END)
               val_tot_ndg_over,
            SUM (
               CASE
                  WHEN d.val_proposta < 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     1
                  ELSE
                     0
               END)
               val_tot_ndg_under,
            COUNT (DISTINCT n.cod_ndg) val_tot_ndg_cr,
            /*
               Calcolo GBV
           */
            SUM (d.val_proposta) val_gbv,
            SUM (
               CASE
                  WHEN d.val_proposta >= 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     d.val_proposta
                  ELSE
                     0
               END)
               val_gbv_over,
            SUM (
               CASE
                  WHEN d.val_proposta < 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     d.val_proposta
                  ELSE
                     0
               END)
               val_gbv_under,
            SUM (
               CASE WHEN n.cod_tipo_notizia = 50 THEN d.val_proposta ELSE 0 END)
               val_gbv_cr,
            /*
                Stima NBV
            */
            SUM (d.val_proposta * (1 - d.val_perc_dubbio_esito / 100))
               val_stima_nbv,
            SUM (
               CASE
                  WHEN d.val_proposta >= 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     d.val_proposta * (1 - d.val_perc_dubbio_esito / 100)
                  ELSE
                     0
               END)
               val_stima_nbv_over,
            SUM (
               CASE
                  WHEN d.val_proposta < 250000 AND n.cod_tipo_notizia IS NULL
                  THEN
                     d.val_proposta * (1 - d.val_perc_dubbio_esito / 100)
                  ELSE
                     0
               END)
               val_stima_nbv_under,
            SUM (
               CASE
                  WHEN n.cod_tipo_notizia = 50
                  THEN
                     d.val_proposta * (1 - d.val_perc_dubbio_esito / 100)
                  ELSE
                     0
               END)
               val_stima_nbv_cr,
              /*
                 Indice di copertura
             */
              1
            - (  SUM (
                    CASE
                       WHEN     d.val_proposta >= 250000
                            AND n.cod_tipo_notizia IS NULL
                       THEN
                          d.val_proposta * (1 - d.val_perc_dubbio_esito / 100)
                       ELSE
                          0
                    END)
               / NULLIF (
                    SUM (
                       CASE
                          WHEN     d.val_proposta >= 250000
                               AND n.cod_tipo_notizia IS NULL
                          THEN
                             d.val_proposta
                          ELSE
                             0
                       END),
                    0))
               val_indice_copertura
       FROM mcre_own.t_mcres_app_pratiche p,
            mcre_own.t_mcres_app_posizioni pos,
            (SELECT cod_abi,
                    cod_ndg,
                    val_anno_pratica,
                    cod_pratica,
                    val_perc_dubbio_esito,
                    NVL (val_imp_utilizzo, 0) + NVL (val_accordato_derivati, 0)
                       val_proposta,                   --- Modifica 2012/04/23
                    ROW_NUMBER ()
                    OVER (
                       PARTITION BY cod_abi,
                                    cod_ndg,
                                    val_anno_pratica,
                                    cod_pratica
                       ORDER BY val_progr_proposta DESC)
                       rn
               FROM mcre_own.t_mcrei_app_delibere
              WHERE cod_tipo_proposta = 'S') d,
            mcre_own.t_mcres_app_notizie n,
            mcre_own.v_mcres_app_ultimo_annomeseabi v
      WHERE     0 = 0
            AND pos.cod_abi = p.cod_abi
            AND pos.cod_ndg = p.cod_ndg
            AND p.cod_abi = d.cod_abi
            AND p.cod_ndg = d.cod_ndg
            AND p.val_anno = d.val_anno_pratica
            AND p.cod_pratica = d.cod_pratica
            AND p.cod_abi = n.cod_abi(+)
            AND p.cod_ndg = n.cod_ndg(+)
            AND p.val_anno = n.val_anno_pratica(+)
            AND p.cod_pratica = n.cod_pratica(+)
            AND p.cod_abi = v.cod_abi
            AND p.flg_attiva = 1                             -- pratica attiva
            AND pos.flg_attiva = 1                         -- posizione attiva
            AND pos.dta_passaggio_soff >
                   LAST_DAY (TO_DATE (v.val_annomese_sisba_cp, 'yyyymm')) -- passaggio a sofferenza dopo l'ultimo flusso di bilancio
            AND n.cod_tipo_notizia(+) = 50  -- in corso di cessione routinaria
            AND n.dta_fine_validita(+) = TO_DATE ('99991231', 'yyyymmdd') --notizia in corso di validità
            AND d.rn = 1
   GROUP BY pos.cod_abi, v.val_annomese_sisba_cp;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_NUOVI_INGR_DACONT TO MCRE_USR;
