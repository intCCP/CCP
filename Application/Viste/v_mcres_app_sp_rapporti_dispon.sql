/* Formatted on 21/07/2014 18:43:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_SP_RAPPORTI_DISPON
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_RAPPORTO,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   VAL_SALDO_CORRENTE,
   VAL_RECUPERO_PREVISTO,
   VAL_VANTATO,
   VAL_PERIODO,
   COD_PRODOTTO,
   COD_UO_RAPPORTO,
   COD_ABI_CARTOLARIZZANTE,
   VAL_SOCIETA_CARTOLARIZZAZIONE,
   FLG_SPESA,
   COD_CONTROPARTITA,
   COD_AUTORIZZAZIONE,
   DTA_INS,
   VAL_TIPOLOGIA,
   FLG_RAPP_CARTOLARIZZATO,
   COD_PRATICA_M0,
   VAL_EROGAZIONE_M0,
   COD_LOTTO_M0,
   COD_FORMA_TECNICA,
   DESC_FORMA_TECNICA,
   VAL_IMP_SALDO_CAP,
   VAL_IMP_SALDO_INT,
   COD_RAPPORTO_ORIG,
   DTA_CHIUSURA_RAPP
)
AS
   SELECT r.cod_abi,
          r.cod_ndg,
          r.cod_sndg,
          r.cod_rapporto,
          p.cod_pratica,
          P.VAL_ANNO VAL_ANNO_PRATICA,
          -R.VAL_IMP_gBV VAL_SALDO_CORRENTE,
          -R.VAL_IMP_NBV val_recupero_previsto,
          -r.val_imp_vantato val_vantato,
          Tp.Val_Tipologia Val_Periodo,
          SUBSTR (R.Cod_Rapporto, 6, 4) Cod_Prodotto,
          r.cod_uo_rapporto,
          r.cod_abi_cartolarizzante,
          r.val_societa_cartolarizzazione,
          DECODE (s.cod_rapporto, NULL, 0, 1) flg_spesa,
          C.Cod_Contropartita,
          C.Cod_Autorizzazione,
          -- AP 24/09/2012 S.Dta_Ins,
          r.dta_apertura_rapp AS Dta_Ins,                      --AP 24/09/2012
          TP.VAL_TIPOLOGIA,
          R.FLG_RAPP_CARTOLARIZZATO,
          SUBSTR (M.VAL_CHIAVE_ESTERNA, 1, 9) cod_PRATICA_M0,
          SUBSTR (M.VAL_CHIAVE_ESTERNA, 10, 12) VAL_EROGAZIONE_M0,
          SUBSTR (M.VAL_CHIAVE_ESTERNA, 13, 17) cod_lotto_M0,
          --AP 18/09/2012
          r.cod_forma_tecnica,
          r.desc_forma_tecnica,
          r.val_imp_saldo_Cap,
          r.val_imp_saldo_int,
          r.cod_rapporto_orig,
          -- AP 26/09/2012
          r.dta_chiusura_rapp
     FROM t_mcres_app_pratiche p,
          t_mcres_app_rapporti r,
          t_mcres_app_sp_rapporto s,
          T_MCRES_APP_SP_CONTROPARTITA C,
          (SELECT DISTINCT COD_ABI_ISTITUTO, COD_NDG, p.SCSB_UTI_TOT
             FROM T_MCRE0_APP_ALL_DATA PARTITION (CCP_P1) P
            WHERE P.COD_STATO = 'SO') PCR,
          T_MCRES_CL_PERIODI_PRODOTTI TP,
          T_MCRES_CL_TRANSCODE_M0 m
    WHERE     p.flg_attiva = 1
          AND r.cod_abi = p.cod_abi(+)
          AND r.cod_ndg = p.cod_ndg(+)
          AND r.cod_rapporto = s.cod_rapporto(+)
          AND S.COD_CONTROPARTITA = C.COD_CONTROPARTITA(+)
          AND P.COD_ABI = pcr.COD_ABI_istituto(+)
          AND P.COD_NDG = PCR.COD_NDG(+)
          AND SUBSTR (R.COD_RAPPORTO, 6, 4) = TP.COD_PROD(+)
          AND R.COD_ABI = M.COD_ABI(+)
          AND R.COD_NDG = M.COD_NDG(+)
          AND R.COD_RAPPORTO = M.COD_RAPPORTO(+);
