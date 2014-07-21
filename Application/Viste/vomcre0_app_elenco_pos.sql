/* Formatted on 21/07/2014 18:46:09 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_ELENCO_POS
(
   COD_COMPARTO,
   DESC_COMPARTO,
   DESC_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_PROCESSO,
   COD_STATO,
   COD_MACROSTATO,
   DTA_DECORRENZA_STATO,
   DTA_DEC_MACROSTATO,
   DTA_SCADENZA_STATO,
   VAL_TOT_UTILIZZO,
   VAL_TOT_ACCORDATO,
   VAL_MAU,
   COGNOME,
   NOME,
   DTA_UTENTE_ASSEGNATO,
   ID_UTENTE,
   ID_REFERENTE,
   FLG_OUTSOURCING
)
AS
   SELECT p.cod_comparto,
          co.desc_comparto,
          i.desc_istituto,
          s.cod_struttura_competente_dc,
          s.desc_struttura_competente_dc,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          s.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          p.cod_abi_istituto,
          p.cod_abi_cartolarizzato,
          p.cod_ndg,
          p.cod_sndg,
          p.desc_nome_controparte,
          p.cod_gruppo_economico,
          g.val_ana_gre desc_gruppo_economico,
          p.cod_processo,
          p.cod_stato,
          p.cod_macrostato,
          p.dta_decorrenza_stato,
          p.dta_dec_macrostato,
          p.dta_scadenza_stato,
          p.val_tot_utilizzo,
          p.val_tot_accordato,
          p.gb_val_mau val_mau,
          u.cognome,
          u.nome,
          p.dta_utente_assegnato,
          u.id_utente,
          u.id_referente,
          p.flg_outsourcing
     FROM mcre_own.mv_mcre0_app_elenco_pos p,
          mcre_own.t_mcre0_app_utenti u,
          mcre_own.mv_mcre0_denorm_str_org s,
          mcre_own.t_mcre0_app_anagr_gre g,
          mcre_own.t_mcre0_app_comparti co,
          mcre_own.t_mcre0_app_istituti i
    WHERE     p.id_utente = u.id_utente(+)
          AND p.cod_comparto = co.cod_comparto(+)
          AND p.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND p.cod_filiale = s.cod_struttura_competente_fi(+)
          AND p.cod_gruppo_economico = g.cod_gre(+)
          AND p.cod_abi_cartolarizzato = i.cod_abi(+)
          AND p.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1);
