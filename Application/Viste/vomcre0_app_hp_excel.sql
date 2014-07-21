/* Formatted on 21/07/2014 18:46:10 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_HP_EXCEL
(
   COD_COMPARTO,
   DESC_COMPARTO,
   VAL_BANCA,
   VAL_DIREZIONE,
   VAL_REGIONE,
   COD_REGIONE,
   VAL_AEREA,
   COD_AREA,
   COD_FILIALE,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_GE,
   DESC_GE,
   COD_PROCESSO,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_RISTRUTTURATO,
   DTA_DECORRENZA_STATO_RIS,
   VAL_TOT_UTILIZZO,
   VAL_TOT_ACCORDATO,
   VAL_TOT_UTI_CASSA,
   VAL_TOT_UTI_FIRMA,
   VAL_TOT_ACC_CASSA,
   VAL_TOT_ACC_FIRMA,
   VAL_MAU,
   COGNOME,
   NOME,
   DTA_UTENTE_ASSEGNATO,
   DTA_ESTRAZIONE,
   ID_UTENTE,
   ID_REFERENTE,
   FLG_OUTSOURCING,
   VAL_GG_PT
)
AS
   SELECT                                   -- vg  26/01/2011 Codice e desc ge
          -- mm 02/02/2011 dta_estrazione a sysdate, cod_ristrutt. a '-'
          -- vg  14/03/2011 GG di PT
          p.cod_comparto,
          co.desc_comparto,
          i.desc_istituto val_banca,
          s.desc_struttura_competente_dc val_direzione,
          s.desc_struttura_competente_rg val_regione,
          s.cod_struttura_competente_rg cod_regione,
          s.desc_struttura_competente_ar val_aerea,
          s.cod_struttura_competente_ar cod_area,
          p.cod_filiale,
          p.cod_abi_istituto,
          p.cod_abi_cartolarizzato,
          p.cod_ndg,
          p.cod_sndg,
          p.desc_nome_controparte,
          g.cod_gre cod_ge,
          g.val_ana_gre desc_ge,
          p.cod_processo,
          p.cod_stato,
          p.dta_decorrenza_stato,
          p.dta_scadenza_stato,
          '-' cod_stato_ristrutturato,
          TO_DATE (NULL) dta_decorrenza_stato_ris,
          p.val_tot_utilizzo,
          p.val_tot_accordato,
          p.val_tot_uti_cassa,
          p.val_tot_uti_firma,
          p.val_tot_acc_cassa,
          p.val_tot_acc_firma,
          p.val_mau,
          u.cognome,
          u.nome,
          p.dta_utente_assegnato,
          SYSDATE dta_estrazione,
          u.id_utente,
          u.id_referente,
          p.flg_outsourcing,
          DECODE (p.cod_stato,
                  'PT', TRUNC (SYSDATE) - p.dta_decorrenza_stato,
                  TO_NUMBER (NULL))
             val_gg_pt
     FROM mv_mcre0_app_hp_excel p,
          t_mcre0_app_utenti u,
          mv_mcre0_denorm_str_org s,
          t_mcre0_app_anagr_gre g,
          t_mcre0_app_comparti co,
          t_mcre0_app_istituti i
    WHERE     p.id_utente = u.id_utente(+)
          AND p.cod_comparto = co.cod_comparto(+)
          AND p.cod_abi_istituto = s.cod_abi_istituto_fi(+)
          AND p.cod_filiale = s.cod_struttura_competente_fi(+)
          AND p.cod_gruppo_economico = g.cod_gre(+)
          AND p.cod_abi_cartolarizzato = i.cod_abi(+)
          AND p.cod_stato IN (SELECT cod_microstato
                                FROM t_mcre0_app_stati s
                               WHERE s.flg_stato_chk = 1);
