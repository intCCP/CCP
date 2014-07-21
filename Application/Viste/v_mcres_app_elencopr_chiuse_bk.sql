/* Formatted on 21/07/2014 18:42:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCOPR_CHIUSE_BK
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
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
   DESC_PRESIDIO,
   UO_COMPETENTE,
   DATA_APERTURA_PR,
   DTA_PASSAGGIO_SOFF,
   FLG_ART_498,
   STATO_PC,
   COD_LIVELLO
)
AS
   SELECT pr.cod_abi,
          i.desc_istituto,
          pr.cod_ndg,
          po.cod_sndg,
          ge.cod_gruppo_economico,
          gr.val_ana_gre,
          pr.val_anno anno_pr,
          pr.cod_pratica numero_pr,
          angr.desc_nome_controparte intestazione,
          angr.val_partita_iva,
          rapp.imp_gbv val_gbv,
          rapp.imp_nbv val_nbv,
          PR.COD_MATR_PRATICA ADDETTO,
          po.COD_FILIALE_PRINCIPALE filiale_capofila,
          --pr.cod_uo_pratica filiale_capofila,
          p.desc_PRESIDIO,
          pr.cod_uo_pratica uo_competente,
          pr.dta_apertura data_apertura_pr,
          po.dta_passaggio_soff,
          PO.FLG_ART_498,
          DECODE (PR.FLG_ATTIVA,  0, 'CHIUSA',  1, 'APERTA',  '-')
             AS STATO_PC,
          P.COD_LIVELLO
     FROM t_mcres_app_pratiche PARTITION (soff_pstoriche) pr,
          t_mcres_app_posizioni PARTITION (soff_pstoriche) po,
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
