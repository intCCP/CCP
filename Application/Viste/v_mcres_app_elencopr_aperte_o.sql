/* Formatted on 21/07/2014 18:42:07 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCOPR_APERTE_O
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
   DATA_APERTURA_PR,
   FLG_ART_498,
   STATO_PC
)
AS
   SELECT pr.cod_abi,
          i.desc_istituto,
          pr.cod_ndg,
          Po.Cod_Sndg,
          po.DTA_PASSAGGIO_SOFF,
          ge.cod_gruppo_economico,
          gr.val_ana_gre,
          pr.val_anno AS ANNO_PR,
          pr.cod_pratica numero_pr,
          angr.desc_nome_controparte INTESTAZIONE,
          angr.val_partita_iva,
          rapp.imp_gbv AS val_gbv,
          Rapp.Imp_Nbv AS Val_Nbv,
          pr.cod_matr_pratica ADDETTO,
          pr.cod_uo_pratica AS FILIALE_CAPOFILA,
          pr.cod_uo_pratica AS UO_COMPETENTE,
          Pr.Dta_Apertura AS Data_Apertura_Pr,
          po.flg_art_498,
          DECODE (pr.flg_attiva,  0, 'CHIUSA',  1, 'APERTA',  '-')
             AS stato_pc
     FROM t_mcres_app_pratiche PARTITION (SOFF_PATTIVE) pr,
          t_mcres_app_posizioni PARTITION (SOFF_PATTIVE) po,
          t_mcres_app_istituti i,
          t_mcre0_app_anagrafica_gruppo angr,
          t_mcre0_app_gruppo_economico ge,
          t_mcre0_app_anagr_gre gr,
          (  SELECT ra.cod_abi,
                    ra.cod_ndg,
                    SUM (ra.val_imp_gbv) AS imp_gbv,
                    SUM (ra.val_imp_nbv) AS imp_nbv
               FROM t_mcres_app_rapporti ra
              WHERE ra.cod_ssa = 'MO'
           GROUP BY ra.cod_abi, ra.cod_ndg) rapp
    WHERE     pr.cod_abi = po.cod_abi
          AND pr.cod_abi = rapp.cod_abi
          AND pr.cod_abi = i.cod_abi
          AND pr.cod_ndg = po.cod_ndg
          AND pr.cod_ndg = rapp.cod_ndg
          AND po.cod_sndg = angr.cod_sndg(+)
          AND Po.Cod_Sndg = Ge.Cod_Sndg(+)
          AND ge.cod_gruppo_economico = gr.cod_gre(+);
