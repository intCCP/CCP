/* Formatted on 21/07/2014 18:36:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_STATI_AMMINISTR_2
(
   COD_MATRICOLA,
   COD_ABI,
   COD_STRUTTURA_COMPETENTE,
   DESC_STRUTTURA_COMPETENTE,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_SNDG,
   COD_NDG,
   DESC_INTESTAZIONE,
   COD_PROCESSO,
   COD_STATO,
   VAL_NUM_PERCORSI,
   DTA_DECORRENZA,
   DTA_SCADENZA,
   COD_LIVELLO_CRITICITA,
   COD_TIPO_FILIALE,
   COD_STATO_PRATICA,
   COD_TIPO_CLIENTE,
   COD_INDICATORE
)
AS
   SELECT /*+ STAR_TRANSFORMATION */
         u.cod_matricola,
          p.cod_abi_cartolarizzato cod_abi,
          c.cod_struttura_competente,
          c.desc_struttura_competente,
          s.cod_struttura_competente_rg,
          s.desc_struttura_competente_rg,
          s.cod_struttura_competente_ar,
          s.desc_struttura_competente_ar,
          s.cod_struttura_competente_fi,
          s.desc_struttura_competente_fi,
          p.cod_sndg,
          p.cod_ndg,
          p.desc_nome_controparte desc_intestazione,
          p.cod_processo,
          p.cod_stato,
          DECODE (
             p.cod_stato,
             'SO', (  SELECT COUNT (DISTINCT cod_percorso)
                        FROM t_mcre0_app_percorsi d
                       WHERE     d.cod_abi_cartolarizzato =
                                    p.cod_abi_cartolarizzato
                             AND d.cod_ndg = p.cod_ndg
                    GROUP BY d.cod_abi_cartolarizzato, d.cod_ndg),
             p.cod_percorso)
             val_num_percorsi,
          p.dta_decorrenza_stato dta_decorrenza,
          p.dta_scadenza_stato dta_scadenza,
          NULL cod_livello_criticita,
          c.cod_div cod_tipo_filiale,
          DECODE (p.today_flg, '1', 'A', 'C') cod_stato_pratica,
          NULL cod_tipo_cliente,
          NULL cod_indicatore
     FROM t_mcre0_app_all_data P,
          MV_MCRE0_DENORM_STR_ORG S,
          T_MCRE0_APP_STATI I,
          T_MCRE0_APP_UTENTI U,
          T_MCRE0_APP_COMPARTI CO,
          t_mcre0_app_struttura_org c
    WHERE     P.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI
          AND P.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI
          AND P.COD_STATO = I.COD_MICROSTATO
          AND P.ID_UTENTE = U.ID_UTENTE
          AND NVL (P.COD_COMPARTO_assegnato, p.COD_COMPARTO_calcolato) =
                 CO.COD_COMPARTO
          AND s.COD_ABI_ISTITUTO_FI = c.cod_abi_istituto
          AND S.COD_STRUTTURA_COMPETENTE_FI = C.COD_STRUTTURA_COMPETENTE
          AND co.flg_chk = '1'
          AND cod_stato != '-1';
