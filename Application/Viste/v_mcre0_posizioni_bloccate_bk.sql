/* Formatted on 21/07/2014 18:37:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POSIZIONI_BLOCCATE_BK
(
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_SNDG,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_MACROSTATO,
   COD_STRUTTURA_COMPETENTE,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   ID_UTENTE,
   DESC_UTENTE,
   COD_LAVORABILE,
   DESC_BLOCCO,
   COD_SNDG_LAVORABILE,
   DESC_SNDG_BLOCCO,
   COD_GRUPPO_LAVORABILE,
   DESC_GRUPPO_BLOCCO,
   COD_COMPARTO,
   COD_LIVELLO,
   ID_REFERENTE
)
AS
   SELECT /*+ordered full(s)*/
         s.COD_ABI_CARTOLARIZZATO,
          (SELECT desc_istituto
             FROM mv_mcre0_app_istituti i
            WHERE s.cod_abi = i.cod_abi)
             DESC_ISTITUTO,
          s.COD_SNDG,
          s.COD_NDG,
          DESC_NOME_CONTROPARTE,
          CASE
             WHEN COD_GRUPPO_ECONOMICO = -1 THEN NULL
             ELSE COD_GRUPPO_ECONOMICO
          END
             COD_GRUPPO_ECONOMICO,
          --(select DESC_GRUPPO_ECONOMICO from t_mcre0_dwh_data d where d.cod_ndg=w.cod_ndg and w.cod_abi_cartolarizzato=d.cod_abi_cartolarizzato)
          DESC_GRUPPO_ECONOMICO,
          COD_MACROSTATO,
          COD_STRUTTURA_COMPETENTE,
          COD_STRUTTURA_COMPETENTE_RG,
          DESC_STRUTTURA_COMPETENTE_RG,
          COD_STRUTTURA_COMPETENTE_AR,
          DESC_STRUTTURA_COMPETENTE_AR,
          COD_STRUTTURA_COMPETENTE_FI,
          DESC_STRUTTURA_COMPETENTE_FI,
          COD_STRUTTURA_COMPETENTE_DC,
          COD_STRUTTURA_COMPETENTE_DV,
          ID_UTENTE,
          (SELECT CASE
                     WHEN id_utente <> -1 THEN cognome || ' ' || nome
                     ELSE NULL
                  END
             FROM t_mcre0_app_utenti u
            WHERE w.id_utente = u.id_utente)
             DESC_UTENTE,
          s.COD_BLOCCO_ABI COD_LAVORABILE,
          s.DESC_BLOCCO_ABI DESC_BLOCCO,
          COD_BLOCCO_SNDG COD_SNDG_LAVORABILE,
          DESC_BLOCCO_SNDG DESC_SNDG_BLOCCO,
          COD_BLOCCO_GRUPPO COD_GRUPPO_LAVORABILE,
          DESC_BLOCCO_GRUPPO DESC_GRUPPO_BLOCCO,
          COD_COMPARTO,
          (SELECT MIN (COD_LIVELLO)
             FROM T_MCRE0_APP_COMPARTI CO
            WHERE COD_COMPARTO = CO.COD_COMPARTO)
             COD_LIVELLO,
          (SELECT MIN (id_referente)
             FROM t_mcre0_app_utenti u
            WHERE w.id_utente = u.id_utente)
             id_referente
     FROM v_mcre0_etl_lavorabili s,           --V_MCRE0_APP_UPD_FIELDS_pall w,
                                   v_mcre0_ALL_data w                      --,
    --   mv_mcre0_denorm_str_org o
    WHERE     w.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
          AND w.cod_ndg = s.cod_ndg
          -- AND o.cod_abi_istituto_fi = w.cod_abi_istituto
          -- AND o.cod_struttura_competente_fi = w.cod_filiale
          AND today_flg = '1'
          AND                                                      --redundant
              (   S.COD_BLOCCO_ABI <> 0
               OR S.COD_BLOCCO_SNDG <> 0
               OR S.COD_BLOCCO_GRUPPO <> 0);
