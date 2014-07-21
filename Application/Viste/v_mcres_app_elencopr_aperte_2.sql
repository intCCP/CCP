/* Formatted on 21/07/2014 18:42:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCOPR_APERTE_2
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DTA_PASSAGGIO_SOFF,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   ANNO_PR,
   NUMERO_PR,
   INTESTAZIONE,
   VAL_PARTITA_IVA,
   VAL_GBV,
   VAL_NBV,
   ADDETTO,
   FILIALE_CAPOFILA,
   UO_COMPETENTE,
   DESC_PRESIDIO,
   DATA_APERTURA_PR,
   FLG_ART_498,
   FLG_GESTIONE,
   STATO_PC,
   COD_LIVELLO,
   FLG_FORFETTARIA,
   FLG_CONFERIMENTO,
   COD_STATO_GIURIDICO,
   FLG_SGR,
   DESC_STATO_PRECEDENTE,
   COD_STATO_RISCHIO,
   DESC_NOME_GESTORE,
   FLG_PARTI_CORRELATE
)
AS
   SELECT pr.cod_abi,
          i.desc_istituto,
          pr.cod_ndg,
          po.cod_sndg,
          po.dta_passaggio_soff,
          ge.cod_gruppo_economico,
          gr.val_ana_gre,
          pr.val_anno AS anno_pr,
          pr.cod_pratica numero_pr,
          angr.desc_nome_controparte intestazione,
          ANGR.VAL_PARTITA_IVA,
          RAPP.IMP_GBV AS VAL_GBV,
          rapp.imp_nbv AS val_nbv,
          PR.COD_MATR_PRATICA ADDETTO,
          po.COD_FILIALE_PRINCIPALE AS filiale_capofila,
          --pr.cod_uo_pratica filiale_capofila,
          pr.cod_uo_pratica AS uo_competente,
          p.desc_PRESIDIO,
          pr.dta_apertura AS data_apertura_pr,
          PO.FLG_ART_498,
          pr.FLG_GESTIONE,
          DECODE (PR.FLG_ATTIVA,  0, 'CHIUSA',  1, 'APERTA',  '-')
             AS STATO_PC,
          P.COD_LIVELLO,
          CASE                                                ---AG 02/07/2012
              WHEN d.cod_delibera IN ('NZ', 'FZ') THEN 1 ELSE 0 END
             flg_forfettaria,
          NVL ( (SELECT DISTINCT 1
                   FROM v_mcres_app_conferimento_nt n
                  WHERE n.cod_abi = pr.cod_abi AND n.cod_ndg = pr.cod_ndg),
               0)
             flg_conferimento,
          po.cod_stato_giuridico,
          po.FLG_SGR_FONDI flg_sgr,
          (SELECT MAX (desc_microstato)
             FROM t_mcre0_app_percorsi p, t_mcre0_app_stati ss
            WHERE     p.cod_abi_cartolarizzato = po.cod_abi
                  AND p.cod_ndg = po.cod_ndg
                  AND p.cod_stato = po.COD_STATO_RISCHIO
                  AND p.dta_decorrenza_stato = po.dta_passaggio_soff
                  AND p.cod_stato_precedente = ss.cod_microstato)
             desc_stato_precedente,
          po.COD_STATO_RISCHIO,
          U.COGNOME || ' ' || U.Nome Desc_Nome_Gestore,
          0 flg_parti_correlate
     FROM t_mcres_app_pratiche PARTITION (soff_pattive) pr,
          t_mcres_app_posizioni PARTITION (soff_pattive) po,
          t_mcres_app_utenti u,
          t_mcres_app_istituti i,
          t_mcre0_app_anagrafica_gruppo angr,
          t_mcre0_app_gruppo_economico ge,
          t_mcre0_app_anagr_gre gr,
          (  SELECT ra.cod_abi,
                    RA.COD_NDG,
                    SUM (-1 * RA.VAL_IMP_GBV) AS IMP_GBV,
                    SUM (-1 * ra.val_imp_nbv) AS imp_nbv
               FROM t_mcres_app_rapporti ra
              WHERE ra.cod_ssa = 'MO'
           GROUP BY ra.cod_abi, ra.cod_ndg) rapp,
          v_mcres_app_lista_presidi p,
          (                                                   ---AG 02/07/2012
           SELECT ROW_NUMBER ()
                  OVER (
                     PARTITION BY cod_abi,
                                  cod_ndg,
                                  val_anno_pratica,
                                  cod_pratica
                     ORDER BY dta_aggiornamento_delibera DESC NULLS LAST)
                     rn,
                  cod_abi,
                  cod_ndg,
                  val_anno_pratica,
                  cod_pratica,
                  cod_protocollo_delibera,
                  dta_aggiornamento_delibera,
                  cod_delibera,
                  cod_stato_delibera
             FROM t_mcres_app_delibere
            WHERE     0 = 0
                  AND cod_delibera NOT IN
                         ('TT', 'TP', 'TS', 'SN', 'ES', 'RE')
                  AND cod_stato_delibera != 'AN') d
    WHERE     PR.COD_ABI = PO.COD_ABI
          AND PR.COD_ABI = RAPP.COD_ABI(+)
          AND pr.cod_abi = i.cod_abi(+)
          AND PR.COD_NDG = PO.COD_NDG
          AND pr.cod_ndg = rapp.cod_ndg(+)
          AND po.cod_sndg = angr.cod_sndg(+)
          AND po.cod_sndg = ge.cod_sndg(+)
          AND GE.COD_GRUPPO_ECONOMICO = GR.COD_GRE(+)
          AND pr.COD_UO_PRATICA = p.COD_PRESIDIO(+)
          AND pr.cod_abi = d.cod_abi(+)
          AND pr.cod_ndg = d.cod_ndg(+)
          AND pr.val_anno = d.val_anno_pratica(+)
          AND pr.cod_pratica = d.cod_pratica(+)
          AND d.rn(+) = 1
          AND pr.COD_MATR_PRATICA = U.COD_MATRICOLA(+);
