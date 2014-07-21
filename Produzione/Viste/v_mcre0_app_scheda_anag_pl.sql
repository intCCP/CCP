/* Formatted on 17/06/2014 18:04:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_PL
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   VAL_ANNO,
   COD_NUMERO_PRATICA,
   COD_MATRICOLA,
   DESC_ADDETTO,
   COD_UO,
   DESC_UO,
   COD_REGIONE,
   DESC_REGIONE,
   COD_AREA,
   DESC_AREA,
   COD_FILIALE,
   DESC_FILIALE,
   COD_PROCESSO,
   COD_STATO_RISCHIO,
   DTA_DEC_MICROSTATO
)
AS
   SELECT p.cod_abi AS cod_abi,
          p.cod_ndg AS cod_ndg,
          p.cod_sndg AS cod_sndg,
          ad.desc_istituto AS desc_istituto,
          ad.desc_nome_controparte AS desc_nome_controparte,
          p.val_anno_pratica AS val_anno,
          p.cod_pratica AS cod_numero_pratica,
          p.cod_matr_pratica AS cod_matricola,
          u.cognome AS desc_addetto,
          p.cod_uo_pratica AS cod_uo,
          c.desc_comparto AS desc_uo,
          d.cod_struttura_competente_rg AS cod_regione,
          d.desc_struttura_competente_rg AS desc_regione,
          d.cod_struttura_competente_ar AS cod_area,
          d.desc_struttura_competente_ar AS desc_area,
          d.cod_struttura_competente_fi AS cod_filiale,
          d.desc_struttura_competente_fi AS desc_filiale,
          ad.cod_processo AS cod_processo,
          ad.cod_stato AS cod_stato_rischio,
          ad.dta_decorrenza_stato AS dta_dec_microstato
     FROM t_mcrei_app_pratiche p
          LEFT JOIN
          t_mcre0_app_all_data ad
             ON     p.cod_abi = ad.cod_abi_cartolarizzato
                AND p.cod_ndg = ad.cod_ndg
                AND ad.cod_stato IN ('IN', 'SO')
                AND ad.flg_active = '1'
          LEFT JOIN
          mv_mcre0_denorm_str_org d
             ON     ad.cod_filiale = d.cod_struttura_competente_fi
                AND ad.cod_abi_istituto = d.cod_abi_istituto_fi
          LEFT JOIN t_mcre0_app_comparti c
             ON ad.cod_comparto_assegnato = c.cod_comparto
          LEFT JOIN t_mcre0_app_utenti u
             ON p.cod_matr_pratica = u.cod_matricola;


GRANT SELECT ON MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_PL TO MCRE_USR;
