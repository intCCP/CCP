/* Formatted on 21/07/2014 18:39:30 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIB_ATT_CONF_OLD
(
   COD_PROTOCOLLO_PACCHETTO,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_MICROTIPOLOGIA_DELIB,
   COD_FASE_PACCHETTO,
   COD_FASE_MICROTIPOLOGIA,
   VAL_RET_TOT_DA_DELIB_CASSA,
   VAL_RET_TOT_DA_DELIB_FIRMA,
   VAL_RET_TOT_DA_DELIB_DERIVATI,
   TOT_RETTIFICA_DA_DELIB,
   DTA_SCADENZA_TOT_DA_DELIB,
   VAL_RDV_TOT_CASSA,
   VAL_RDV_TOT_FIRMA,
   VAL_RDV_TOT_DERIVATI,
   VAL_RDV_TOT,
   TOT_RINUNCIA_DA_DELIB
)
AS
   SELECT DISTINCT             --02.15 aggiunto filtro fase_microtipol = 'ATT'
          cod_protocollo_pacchetto,
          cod_sndg,
          desc_nome_controparte,
          cod_microtipologia_delib,
          cod_fase_pacchetto,
          cod_fase_microtipologia,
          --valori da deliberare
          MAX (
             val_ret_tot_da_delib_cassa)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_cassa,
          MAX (
             val_ret_tot_da_delib_firma)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_firma,
          MAX (
             val_ret_tot_da_delib_derivati)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_ret_tot_da_delib_derivati,
          ---tot_da deliberare
          MAX (
               val_ret_tot_da_delib_cassa
             + val_ret_tot_da_delib_firma
             + val_ret_tot_da_delib_derivati
             + val_rinuncia_deliberata)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS tot_rettifica_da_delib,         ---OPPURE SUM(S.VAL_RDV_TOT) ?
          MAX (
             dta_scadenza_tot_da_delib)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS dta_scadenza_tot_da_delib,
          --29 MARZO
          MAX (
             val_rdv_tot_cassa)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_cassa,
          MAX (
             val_rdv_tot_firma)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_firma,
          MAX (
             val_rdv_tot_derivati)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot_derivati,
          MAX (
             val_rdv_tot_cassa + val_rdv_tot_firma + val_rdv_tot_derivati)
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS val_rdv_tot,
          MAX (
             (val_rinuncia_deliberata + val_rinuncia_proposta))
          OVER (
             PARTITION BY cod_protocollo_pacchetto, cod_microtipologia_delib)
             AS tot_rinuncia_da_delib
     FROM (SELECT DISTINCT
                  cod_protocollo_pacchetto,
                  cod_microtipologia_delib,
                  cod_fase_pacchetto,
                  cod_fase_microtipologia,
                  d.cod_sndg,
                  g.desc_nome_controparte,
                  ----totali_da_deliberare
                  CASE
                     WHEN cod_classe_ft = 'CA'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_cassa,
                  CASE
                     WHEN cod_classe_ft = 'FI'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_firma,
                  CASE
                     WHEN cod_classe_ft = 'ST'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_derivati,
                  --- rettifica di valore complessiva/previsione di perdita
                  CASE
                     WHEN cod_classe_ft = 'CA'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_cassa,
                  CASE
                     WHEN cod_classe_ft = 'FI'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_firma,
                  CASE
                     WHEN cod_classe_ft = 'ST'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_derivati,
                  ----
                  TO_DATE (NULL, 'ddmmyyyy') AS dta_scadenza_tot_da_delib, ---AGGIUNGERE NUOVO CAMPO MANUALE?
                  dta_scadenza,
                  s.val_imp_rettifica_att,
                  s.val_imp_rettifica_pregr,
                  val_rinuncia_proposta,
                  val_rinuncia_deliberata
             FROM t_mcrei_app_delibere d,
                  t_mcrei_app_stime s,
                  t_mcre0_app_anagrafica_gruppo g
            WHERE     d.cod_protocollo_delibera =
                         s.cod_protocollo_delibera(+)
                  AND d.cod_abi = s.cod_abi(+)
                  AND d.cod_ndg = s.cod_ndg(+)
                  AND D.COD_MACROTIPOLOGIA_DELIB != 'TP'  -----SOLO GESTIONALI
                  AND d.cod_fase_pacchetto = 'CNF'
                  AND d.cod_fase_microtipologia = 'ATT'
                  AND d.cod_fase_delibera != 'AN'
                  AND d.flg_no_delibera = '0'
                  AND d.flg_attiva = '1'
                  AND d.cod_sndg = g.cod_sndg
                  AND s.flg_attiva(+) = '1'
                  AND s.flg_tipo_dato(+) = 'R'
           UNION        ----20 marzo per gestire nuova fase microtipologia ACT
           SELECT DISTINCT
                  cod_protocollo_pacchetto,
                  cod_microtipologia_delib,
                  cod_fase_pacchetto,
                  cod_fase_microtipologia,
                  d.cod_sndg,
                  g.desc_nome_controparte,
                  ----totali_da_deliberare
                  CASE
                     WHEN cod_classe_ft = 'CA'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_cassa,
                  CASE
                     WHEN cod_classe_ft = 'FI'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_firma,
                  CASE
                     WHEN cod_classe_ft = 'ST'
                     THEN
                        SUM (
                           val_imp_rettifica_pregr + val_imp_rettifica_att)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_ret_tot_da_delib_derivati,
                  --- rettifica di valore complessiva/previsione di perdita
                  CASE
                     WHEN cod_classe_ft = 'CA'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_cassa,
                  CASE
                     WHEN cod_classe_ft = 'FI'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_firma,
                  CASE
                     WHEN cod_classe_ft = 'ST'
                     THEN
                        SUM (
                           val_rdv_tot)
                        OVER (
                           PARTITION BY cod_protocollo_pacchetto,
                                        cod_microtipologia_delib,
                                        s.cod_abi,
                                        s.cod_ndg,
                                        s.cod_protocollo_delibera,
                                        cod_classe_ft)
                     ELSE
                        0
                  END
                     val_rdv_tot_derivati,
                  ----
                  TO_DATE (NULL, 'ddmmyyyy') AS dta_scadenza_tot_da_delib, ---AGGIUNGERE NUOVO CAMPO MANUALE?
                  dta_scadenza,
                  s.val_imp_rettifica_att,
                  s.val_imp_rettifica_pregr,
                  val_rinuncia_proposta,
                  val_rinuncia_deliberata
             FROM t_mcrei_app_delibere d,
                  t_mcrei_app_stime s,
                  t_mcre0_app_anagrafica_gruppo g
            WHERE     d.cod_protocollo_delibera =
                         s.cod_protocollo_delibera(+)
                  AND d.cod_abi = s.cod_abi(+)
                  AND d.cod_ndg = s.cod_ndg(+)
                  AND D.COD_MACROTIPOLOGIA_DELIB = 'TP' -----SOLO TRANSAZIONI A PRONTI
                  AND d.cod_fase_pacchetto = 'CNF'
                  AND d.cod_fase_microtipologia IN ('ATT', 'CNF')  ---20 MARZO
                  AND d.cod_fase_delibera != 'AN'
                  AND d.flg_no_delibera = '0'
                  AND d.flg_attiva = '1'
                  AND d.cod_sndg = g.cod_sndg
                  AND s.flg_attiva(+) = '1'
                  AND s.flg_tipo_dato(+) = 'R');
