/* Formatted on 21/07/2014 18:42:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCO_EX498
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_UO_PRATICA,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANNO,
   VAL_PARTITA_IVA,
   COD_PRATICA,
   DTA_NASCITA_COSTITUZIONE
)
AS
   SELECT                                      -- ag 05/01/2012    flg_art_498
         PR.COD_ABI,
          I.DESC_ISTITUTO,
          pr.cod_uo_pratica,
          pr.cod_ndg,
          pos.cod_sndg,
          anc.desc_nome_controparte,
          pr.val_anno,
          anc.val_partita_iva,
          pr.cod_pratica,
          anc.dta_nascita_costituzione
     FROM t_mcres_app_pratiche pr,
          T_MCRES_APP_POSIZIONI POS,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO ANC,
          t_mcres_app_istituti i
    WHERE     pos.cod_abi = pr.cod_abi
          AND pos.cod_ndg = pr.cod_ndg
          AND POS.FLG_ATTIVA = 1
          AND pr.flg_attiva = 1
          AND POS.FLG_ART_498 = 'S'
          AND POS.COD_SNDG = ANC.COD_SNDG(+)
          AND pos.cod_abi = i.cod_abi(+);
