/* Formatted on 17/06/2014 18:07:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_DELIBERE_RICEVUTE
(
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_COMPARTO,
   DESC_COMPARTO,
   DTA_INS_PACCHETTO,
   DTA_TRASF_PACCHETTO,
   COD_PROTOCOLLO_PACCHETTO,
   COD_MACROTIPOLOGIA,
   COD_OD_CALCOLATO,
   COD_OD_EFFETTIVO,
   ID_UTENTE,
   DESC_UTENTE,
   COD_GRUPPO_SUPER
)
AS
   SELECT DISTINCT
          upd.DESC_NOME_CONTROPARTE,
          UPD.COD_SNDG,
          upd.COD_GRUPPO_ECONOMICO,
          upd.DESC_GRUPPO_ECONOMICO,
          upd.COD_COMPARTO,
          upd.DESC_COMPARTO,
          d.DTA_CREAZIONE_PACCHETTO AS DTA_INS_PACCHETTO,
          d.DTA_TRASF_PACCHETTO,
          d.COD_PROTOCOLLO_PACCHETTO,
          d.COD_MACROTIPOLOGIA_DELIB AS COD_MACROTIPOLOGIA,
          DECODE (d.cod_organo_calcolato, '-1', 'ND', d.cod_organo_calcolato)
             AS COD_OD_CALCOLATO,
          d.cod_organo_deliberante AS COD_OD_EFFETTIVO,
          upd.ID_UTENTE,
          (SELECT CASE
                     WHEN id_utente <> -1 THEN cognome || ' ' || nome
                     ELSE NULL
                  END
             FROM t_mcre0_app_utenti u
            WHERE upd.id_utente = u.id_utente)
             DESC_UTENTE,
          COD_GRUPPO_SUPER
     FROM v_mcre0_app_upd_fields upd, t_mcrei_app_delibere d
    WHERE     upd.cod_sndg = d.cod_sndg
          AND upd.cod_abi_cartolarizzato = d.cod_abi
          AND d.flg_pacchetto_trasferito = 'Y';


GRANT SELECT ON MCRE_OWN.V_MCREI_APP_DELIBERE_RICEVUTE TO MCRE_USR;
