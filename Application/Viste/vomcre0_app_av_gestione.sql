/* Formatted on 21/07/2014 18:46:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_AV_GESTIONE
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   COD_PROCESSO,
   COD_STATO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE,
   COD_COMPARTO,
   DESC_COMPARTO,
   FLG_STATO,
   DESC_STATO,
   DTA_STATO,
   ID_UTENTE,
   DESC_GESTORE,
   COD_COMPARTO_RICHIEDENTE,
   DESC_COMPARTO_RICHIEDENTE,
   COD_MATRICOLA,
   DTA_INS
)
AS
   SELECT                                                -- MM v0.1 01.07.2011
          -- MM v0.2 13.07 - aggiunta Strutura Competente da Mople
          av.cod_abi_cartolarizzato,
          f.cod_abi_istituto,
          av.cod_ndg,
          f.cod_sndg,
          i.desc_istituto,
          f.cod_processo,
          f.cod_stato,
          a.desc_nome_controparte,
          f.cod_gruppo_economico,
          g.val_ana_gre desc_gruppo_economico,
          s.cod_struttura_competente_dc,
          s.desc_struttura_competente_dc,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          f.cod_filiale cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          m.cod_struttura_competente,
          f.cod_comparto,
          c.desc_comparto,
          av.flg_stato,
          cl.desc_stato,
          av.dta_stato,
          f.id_utente,
          u.cognome || ' ' || u.nome desc_gestore,
          av.cod_comparto_av cod_comparto_richiedente,
          c1.desc_comparto desc_comparto_richiedente,
          av.cod_matricola,
          av.dta_ins
     FROM mv_mcre0_denorm_str_org s,
          t_mcre0_app_av_gestione av,
          t_mcre0_cl_av_stati cl,
          mv_mcre0_app_upd_field f,
          t_mcre0_app_anagrafica_gruppo a,
          t_mcre0_app_anagr_gre g,
          t_mcre0_app_utenti u,
          t_mcre0_app_comparti c,
          t_mcre0_app_comparti c1,
          mv_mcre0_app_istituti i,
          t_mcre0_app_mople m
    WHERE     f.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND f.cod_filiale = s.cod_struttura_competente_fi(+)
          --AND AV.FLG_STATO = GS.COD_STATO(+)
          AND f.cod_abi_cartolarizzato = av.cod_abi_cartolarizzato
          AND f.cod_ndg = av.cod_ndg
          AND f.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato
          AND f.cod_ndg = m.cod_ndg
          AND f.id_utente = u.id_utente(+)
          AND f.cod_comparto = c.cod_comparto(+)
          AND av.cod_comparto_av = c1.cod_comparto(+)
          AND av.cod_abi_cartolarizzato = i.cod_abi(+)
          AND f.cod_gruppo_economico = g.cod_gre(+)
          AND f.cod_sndg = a.cod_sndg(+)
          AND av.flg_stato = cl.cod_stato;
