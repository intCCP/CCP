/* Formatted on 21/07/2014 18:37:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_GESTORE_UO_ALL_OLD
(
   COD_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_DV,
   COD_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   COD_ABI_ISTITUTO,
   DESC_STRUTTURA_COMPETENTE,
   COD_MATRICOLA,
   COGNOME,
   DESC_CRITERIO_ASSEGNAZIONE,
   DTA_INS,
   DTA_UPD,
   COD_COMPARTO_ASSEGNATARIO,
   FLG_ATTIVO,
   COD_STRUTTURA_ASSEGNATARIO,
   DESC_TIPO_STRUTTURA,
   COD_MATRICOLA_ASSEGNATARIO,
   ID_UTENTE_ASSEGNATO
)
AS
   SELECT DISTINCT
          sorg.cod_struttura_competente_dc,
          sorg.cod_struttura_competente_dv,
          sorg.cod_struttura_competente_rg,
          sorg.cod_struttura_competente_ar,
          sorg.cod_struttura_competente_fi,
          sorg.cod_abi_istituto_fi AS cod_abi_istituto,
          sorg.desc_struttura_competente_fi AS desc_struttura_competente,
          cod_matricola_assegnata AS cod_matricola,
          u.cognome,
          'FI' AS cod_criterio_assegn,
          gu.dta_ins AS dta_ins,
          gu.dta_upd AS dta_upd,
          gu.cod_comparto_assegnatario,
          gu.flg_attivo,
          gu.cod_struttura_assegnatario,
          gu.desc_tipo_struttura,
          gu.cod_matricola_assegnatario,
          gu.id_utente_assegnato
     FROM (SELECT DISTINCT cod_struttura_competente_dc,
                           cod_struttura_competente_dv,
                           cod_struttura_competente_rg,
                           cod_struttura_competente_ar,
                           cod_struttura_competente_fi,
                           cod_livello_fi,
                           cod_abi_istituto_fi,
                           desc_struttura_competente_fi
             FROM mv_mcre0_denorm_str_org
            WHERE cod_livello_fi = 'FI') sorg,
          (SELECT cod_struttura_competente_dc,
                  cod_struttura_competente_dv,
                  cod_struttura_competente_rg,
                  cod_struttura_competente_ar,
                  cod_struttura_competente_fi,
                  desc_criterio_assegnazione,
                  cod_matricola_assegnatario,
                  cod_comparto_assegnatario,
                  cod_matricola_assegnata,
                  cod_abi_istituto,
                  dta_ins,
                  dta_upd,
                  cod_struttura_assegnatario,
                  desc_tipo_struttura,
                  flg_attivo,
                  id_utente_assegnato
             FROM t_mcre0_app_associa_gestori_uo
            WHERE desc_criterio_assegnazione = 'FI' AND flg_attivo = '1') gu,
          t_mcre0_app_utenti u,
          t_mcre0_app_struttura_org s                       --filtro uo chiuse
    WHERE     sorg.cod_struttura_competente_dc =
                 gu.cod_struttura_competente_dc(+)
          AND sorg.cod_struttura_competente_dv =
                 gu.cod_struttura_competente_dv(+)
          AND sorg.cod_struttura_competente_rg =
                 gu.cod_struttura_competente_rg(+)
          AND sorg.cod_struttura_competente_ar =
                 gu.cod_struttura_competente_ar(+)
          AND sorg.cod_struttura_competente_fi =
                 gu.cod_struttura_competente_fi(+)
          AND sorg.cod_abi_istituto_fi = gu.cod_abi_istituto(+)
          AND gu.cod_matricola_assegnata = u.cod_matricola(+)
          AND sorg.cod_struttura_competente_fi = s.cod_struttura_competente
          AND sorg.cod_abi_istituto_fi = s.cod_abi_istituto
          AND s.dta_chiusura IS NULL
   UNION
   SELECT DISTINCT sorg.cod_struttura_competente_dc,
                   sorg.cod_struttura_competente_dv,
                   sorg.cod_struttura_competente_rg,
                   sorg.cod_struttura_competente_ar,
                   NULL AS cod_struttura_competente_fi,
                   sorg.cod_abi_istituto_ar AS cod_abi_istituto,
                   desc_struttura_competente_ar AS desc_struttura_competente,
                   gu.cod_matricola_assegnata AS cod_matricola,
                   u.cognome,
                   'AR' AS cod_criterio_assegn,
                   gu.dta_ins AS dta_ins,
                   gu.dta_upd AS dta_upd,
                   gu.cod_comparto_assegnatario,
                   gu.flg_attivo,
                   gu.cod_struttura_assegnatario,
                   gu.desc_tipo_struttura,
                   gu.cod_matricola_assegnatario,
                   gu.id_utente_assegnato
     FROM (SELECT DISTINCT cod_struttura_competente_dc,
                           cod_struttura_competente_dv,
                           cod_struttura_competente_rg,
                           cod_struttura_competente_ar,
                           cod_livello_ar,
                           cod_abi_istituto_ar,
                           desc_struttura_competente_ar
             FROM mv_mcre0_denorm_str_org
            WHERE     cod_livello_ar = 'AR'
                  AND (cod_abi_istituto_ar, cod_struttura_competente_ar) NOT IN
                         (SELECT area.cod_abi_istituto,
                                 area.cod_struttura_competente
                            FROM (SELECT *
                                    FROM t_mcre0_app_struttura_org
                                   WHERE cod_livello = 'AR') area,
                                 (SELECT *
                                    FROM t_mcre0_app_struttura_org
                                   WHERE cod_livello = 'FI') str
                           WHERE     area.cod_struttura_competente =
                                        str.cod_str_org_sup(+)
                                 AND area.cod_abi_istituto =
                                        str.cod_abi_istituto(+)
                                 AND str.cod_str_org_sup IS NULL
                                 AND str.cod_abi_istituto IS NULL)) sorg,
          (SELECT DISTINCT cod_struttura_competente_dc,
                           cod_struttura_competente_dv,
                           cod_struttura_competente_rg,
                           cod_struttura_competente_ar,
                           NULL AS cod_struttura_competente_fi,
                           desc_criterio_assegnazione,
                           cod_matricola_assegnatario,
                           cod_comparto_assegnatario,
                           cod_matricola_assegnata,
                           cod_abi_istituto,
                           dta_ins,
                           dta_upd,
                           cod_struttura_assegnatario,
                           desc_tipo_struttura,
                           flg_attivo,
                           id_utente_assegnato
             FROM t_mcre0_app_associa_gestori_uo
            WHERE desc_criterio_assegnazione = 'AR' AND flg_attivo = '1') gu,
          t_mcre0_app_utenti u,
          t_mcre0_app_struttura_org s                       --filtro uo chiuse
    WHERE     sorg.cod_struttura_competente_dc =
                 gu.cod_struttura_competente_dc(+)
          AND sorg.cod_struttura_competente_dv =
                 gu.cod_struttura_competente_dv(+)
          AND sorg.cod_struttura_competente_rg =
                 gu.cod_struttura_competente_rg(+)
          AND sorg.cod_struttura_competente_ar =
                 gu.cod_struttura_competente_ar(+)
          AND sorg.cod_abi_istituto_ar = gu.cod_abi_istituto(+)
          AND gu.cod_matricola_assegnata = u.cod_matricola(+)
          AND sorg.cod_struttura_competente_ar = s.cod_struttura_competente
          AND sorg.cod_abi_istituto_ar = s.cod_abi_istituto
          AND s.dta_chiusura IS NULL;
