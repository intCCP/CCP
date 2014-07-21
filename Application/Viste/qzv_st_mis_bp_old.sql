/* Formatted on 21/07/2014 18:30:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.QZV_ST_MIS_BP_OLD
(
   COD_SRC,
   COD_STATO_RISCHIO,
   DES_STATO_RISCHIO,
   COD_ABI,
   COD_NDG,
   ID_DPER,
   DTA_COMPETENZA,
   DTA_INIZIO_STATO,
   DTA_FINE_STATO,
   FLG_NDG,
   FLG_NUOVO_INGRESSO,
   FLG_FIRMA,
   FLG_CESSIONE_ROUTINARIA,
   VAL_GBV,
   VAL_NBV,
   COD_PRESIDIO
)
AS
   SELECT COD_SRC,
          COD_STATO_RISCHIO,
          DES_STATO_RISCHIO,
          COD_ABI,
          COD_NDG,
          ID_DPER,
          DTA_COMPETENZA,
          DTA_INIZIO_STATO,
          DTA_FINE_STATO,
          FLG_NDG,
          FLG_NUOVO_INGRESSO,
          FLG_FIRMA,
          FLG_CESSIONE_ROUTINARIA,
          VAL_GBV,
          VAL_NBV,
          (SELECT MAX (
                     NVL (
                        CASE
                           WHEN     COD_LIVELLO IN ('PL', 'RC', 'IP', 'IC')
                                AND cod_abi_istituto = '01025'
                           THEN
                              cod_struttura_competente
                           ELSE
                              '#'
                        END,
                        '#'))
             FROM mcre_own.t_mcre0_app_struttura_org
            WHERE cod_struttura_competente(+) = a.COD_UO_PRATICA)
             cod_presidio
     FROM (  SELECT 'BP' cod_src,
                    'S' cod_stato_rischio,
                    'Sofferenze' des_stato_rischio,
                    pos.cod_abi,
                    pos.cod_ndg,
                    v.val_annomese_sisba_cp ID_DPER,
                    TO_CHAR (
                       ADD_MONTHS (
                          LAST_DAY (
                             TO_DATE (v.val_annomese_sisba_cp, 'yyyymm')),
                          1),
                       'yyyymmdd')
                       dta_Competenza,
                    MIN (pos.DTA_PASSAGGIO_SOFF) dta_inizio_stato,
                    MAX (pos.DTA_CHIUSURA) dta_Fine_stato,
                    1 flg_ndg,
                    1 flg_nuovo_Ingresso,
                    0 flg_firma,
                    CASE WHEN n.cod_tipo_notizia = 50 THEN 1 ELSE 0 END
                       flg_cessione_routinaria,
                    MAX (p.COD_UO_PRATICA) COD_UO_PRATICA,
                    SUM (d.val_proposta) val_gbv,
                    SUM (d.val_proposta * (1 - d.val_perc_dubbio_esito / 100))
                       val_nbv
               FROM mcre_own.t_mcres_app_pratiche p,
                    mcre_own.t_mcres_app_posizioni pos,
                    (SELECT cod_abi,
                            cod_ndg,
                            val_anno_pratica,
                            cod_pratica,
                            val_perc_dubbio_esito,
                              NVL (val_imp_utilizzo, 0)
                            + NVL (val_accordato_derivati, 0)
                               val_proposta,          --- Modifica 2012/04/23,
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
                    AND p.flg_attiva = 1                     -- pratica attiva
                    AND pos.flg_attiva = 1                 -- posizione attiva
                    AND n.cod_tipo_notizia(+) = 50 -- in corso di cessione routinaria
                    AND n.dta_fine_validita(+) =
                           TO_DATE ('99991231', 'yyyymmdd') --notizia in corso di validità
                    AND pos.dta_passaggio_soff >
                           LAST_DAY (
                              TO_DATE (v.val_annomese_sisba_cp, 'yyyymm')) -- passaggio a sofferenza dopo l'ultimo flusso di bilancio
                    AND d.rn = 1
           GROUP BY pos.cod_abi,
                    pos.cod_ndg,
                    v.val_annomese_sisba_cp,
                    TO_CHAR (
                       LAST_DAY (TO_DATE (v.val_annomese_sisba_cp, 'yyyymm')),
                       'yyyymmdd'),
                    CASE WHEN n.cod_tipo_notizia = 50 THEN 1 ELSE 0 END) a;
