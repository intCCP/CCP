/* Formatted on 21/07/2014 18:33:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ELENCO_POS_OLD
(
   COD_COMPARTO,
   DESC_COMPARTO,
   DESC_ISTITUTO,
   COD_STRUTTURA_COMPETENTE_DV,
   DESC_STRUTTURA_COMPETENTE_DV,
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
   COD_MATRICOLA,
   ID_REFERENTE,
   FLG_OUTSOURCING,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD
)
AS
   SELECT      --0709 : esposta dta_decorrenza come in scheda anag per IN e SO
         cod_comparto,
          desc_comparto,
          desc_istituto,
          cod_struttura_competente_dv,
          desc_struttura_competente_dv,
          cod_struttura_competente_dc,
          desc_struttura_competente_dc,
          cod_struttura_competente_rg,
          desc_struttura_competente_rg,
          cod_struttura_competente_ar,
          desc_struttura_competente_ar,
          cod_struttura_competente_fi,
          desc_struttura_competente_fi,
          cod_abi_istituto,
          cod_abi_cartolarizzato,
          cod_ndg,
          cod_sndg,
          desc_nome_controparte,
          cod_gruppo_economico,
          desc_gruppo_economico,
          cod_processo,
          cod_stato,
          cod_macrostato,
          CASE
             WHEN f.cod_stato IN ('IN', 'SO')
             THEN
                (SELECT NVL (
                           CASE
                              WHEN f.cod_stato = 'IN'
                              THEN
                                 pr.dta_decorrenza_stato
                              WHEN f.cod_stato = 'SO'
                              THEN
                                 DECODE (
                                    pr.dta_fine_stato,
                                    TO_DATE ('31/12/9999', 'DD/MM/YYYY'), pr.dta_decorrenza_stato,
                                    (pr.dta_fine_stato + 1))
                              ELSE
                                 f.dta_decorrenza_stato
                           END,
                           f.dta_decorrenza_stato)
                   -- dta_apertura
                   FROM (  SELECT pr.cod_abi,
                                  pr.cod_ndg,
                                  MIN (pr.dta_decorrenza_stato)
                                     dta_decorrenza_stato,
                                  MIN (pr.dta_fine_stato) dta_fine_stato
                             FROM (  SELECT pr.cod_abi,
                                            pr.cod_ndg,
                                            MAX (pr.dta_decorrenza_stato)
                                               dta_decorrenza_stato,
                                            NULL dta_fine_stato
                                       FROM t_mcrei_app_pratiche pr
                                      WHERE dta_fine_stato =
                                               TO_DATE ('31/12/9999',
                                                        'DD/MM/YYYY')
                                   GROUP BY cod_abi, cod_ndg
                                   UNION ALL
                                     SELECT pr.cod_abi,
                                            pr.cod_ndg,
                                            NULL dta_decorrenza_stato,
                                            MAX (pr.dta_fine_stato)
                                               dta_fine_stato
                                       FROM t_mcrei_app_pratiche pr
                                      WHERE dta_fine_stato !=
                                               TO_DATE ('31/12/9999',
                                                        'DD/MM/YYYY')
                                   GROUP BY cod_abi, cod_ndg) pr
                         GROUP BY pr.cod_abi, pr.cod_ndg) pr
                  WHERE     pr.cod_abi(+) = f.cod_abi_cartolarizzato
                        AND pr.cod_ndg(+) = f.cod_ndg)
             ELSE
                f.dta_decorrenza_stato
          END
             AS dta_decorrenza_stato,
          dta_dec_macrostato,
          dta_scadenza_stato,
          scsb_uti_tot val_tot_utilizzo,
          scsb_acc_tot val_tot_accordato,
          gb_val_mau val_mau,
          f.cognome,
          f.nome,
          dta_utente_assegnato,
          NULLIF (f.id_utente, -1) AS id_utente,
          f.COD_MATRICOLA,                       --16 nov per estensione AR/RG
          f.id_referente,
          flg_outsourcing,
          cod_gruppo_super,                      --16 nov per estensione AR/RG
          cod_gruppo_super_old                   --16 nov per estensione AR/RG
     FROM v_mcre0_app_upd_fields f
    WHERE flg_stato_chk = '1';
