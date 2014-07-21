/* Formatted on 17/06/2014 18:05:49 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_POSIZIONI_BLOCCATE
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
         s.cod_abi_cartolarizzato,
          (SELECT desc_istituto
             FROM mv_mcre0_app_istituti i
            WHERE s.cod_abi = i.cod_abi)
             desc_istituto,
          s.cod_sndg,
          s.cod_ndg,
          desc_nome_controparte,
          CASE
             WHEN cod_gruppo_economico = -1 THEN NULL
             ELSE cod_gruppo_economico
          END
             cod_gruppo_economico,
          desc_gruppo_economico,
          cod_macrostato,
          cod_struttura_competente,
          cod_struttura_competente_rg,
          desc_struttura_competente_rg,
          cod_struttura_competente_ar,
          desc_struttura_competente_ar,
          cod_struttura_competente_fi,
          desc_struttura_competente_fi,
          cod_struttura_competente_dc,
          cod_struttura_competente_dv,
          CASE
             WHEN     cod_microstato IS NOT NULL
                  AND flg_stato_chk = 1
                  AND flg_outsourcing = 'Y'
             THEN
                w.id_utente
             ELSE
                NULL
          END
             id_utente,
          CASE
             WHEN     COD_MICROSTATO IS NOT NULL
                  AND flg_stato_chk = 1
                  AND flg_outsourcing = 'Y'
             THEN
                (SELECT CASE
                           WHEN id_utente <> -1 THEN cognome || ' ' || nome
                           ELSE NULL
                        END
                   FROM t_mcre0_app_utenti u
                  WHERE w.id_utente = u.id_utente)
             ELSE
                NULL
          END
             desc_utente,
          s.cod_blocco_abi cod_lavorabile,
          s.desc_blocco_abi desc_blocco,
          cod_blocco_sndg cod_sndg_lavorabile,
          desc_blocco_sndg desc_sndg_blocco,
          cod_blocco_gruppo cod_gruppo_lavorabile,
          desc_blocco_gruppo desc_gruppo_blocco,
          CASE
             WHEN     cod_microstato IS NOT NULL
                  AND flg_stato_chk = 1
                  AND flg_outsourcing = 'Y'
             THEN
                cod_comparto
             ELSE
                NULL
          END
             cod_comparto,
          cod_livello,
          id_referente
     FROM v_mcre0_etl_lavorabili s, v_mcre0_app_upd_fields w
    WHERE     w.today_flg = '1'
          -- AND flg_stato_chk(+) = 1
          -- AND flg_outsourcing = 'Y'
          AND w.cod_abi_cartolarizzato = s.cod_abi_cartolarizzato
          AND w.cod_ndg = s.cod_ndg
          AND (   S.COD_BLOCCO_ABI <> 0
               OR S.COD_BLOCCO_SNDG <> 0
               OR S.COD_BLOCCO_GRUPPO <> 0);


GRANT SELECT ON MCRE_OWN.V_MCRE0_POSIZIONI_BLOCCATE TO MCRE_USR;
