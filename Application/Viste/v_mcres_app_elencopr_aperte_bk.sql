/* Formatted on 21/07/2014 18:42:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCOPR_APERTE_BK
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
   STATO_PC,
   COD_LIVELLO
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
          DECODE (PR.FLG_ATTIVA,  0, 'CHIUSA',  1, 'APERTA',  '-')
             AS STATO_PC,
          P.COD_LIVELLO
     FROM t_mcres_app_pratiche PARTITION (soff_pattive) pr,
          t_mcres_app_posizioni PARTITION (soff_pattive) po,
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
          v_mcres_app_lista_presidi p
    WHERE     PR.COD_ABI = PO.COD_ABI
          AND PR.COD_ABI = RAPP.COD_ABI(+)
          AND pr.cod_abi = i.cod_abi(+)
          AND PR.COD_NDG = PO.COD_NDG
          AND pr.cod_ndg = rapp.cod_ndg(+)
          AND po.cod_sndg = angr.cod_sndg(+)
          AND po.cod_sndg = ge.cod_sndg(+)
          AND GE.COD_GRUPPO_ECONOMICO = GR.COD_GRE(+)
          AND pr.COD_UO_PRATICA = p.COD_PRESIDIO(+);
