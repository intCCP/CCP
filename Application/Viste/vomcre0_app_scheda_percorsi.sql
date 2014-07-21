/* Formatted on 21/07/2014 18:46:48 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VOMCRE0_APP_SCHEDA_PERCORSI
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PERCORSO,
   COD_PROCESSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_UNITA_OPERATIVA,
   ID_UTENTE,
   COGNOME,
   NOME,
   TMS,
   FLG_ANNULLO,
   FLG_MOPLE
)
AS
   SELECT sp.*,
          CASE WHEN mpl.cod_abi_cartolarizzato IS NOT NULL THEN 1 ELSE 0 END
             AS flg_mople
     FROM (SELECT DISTINCT tfin.cod_abi_cartolarizzato,
                           tfin.cod_abi_istituto,
                           tfin.cod_ndg,
                           tfin.cod_percorso,
                           tfin.cod_processo,
                           tfin.cod_stato_precedente,
                           tfin.cod_stato,
                           tfin.dta_decorrenza_stato,
                           tfin.dta_scadenza_stato,
                           tfin.val_unita_operativa,
                           tfin.id_utente,
                           tfin.cognome,
                           tfin.nome,
                           tfin.dta_decorrenza_stato tms,
                           NULL flg_annullo
             FROM (                                         --Mople + Percorsi
                   SELECT DISTINCT
                          otmp.cod_abi_cartolarizzato,
                          otmp.cod_abi_istituto,
                          otmp.cod_ndg,
                          otmp.cod_percorso,
                          otmp.cod_processo,
                          otmp.cod_stato_precedente,
                          otmp.cod_stato,
                          otmp.dta_decorrenza_stato,
                          otmp.dta_scadenza_stato,
                          FIRST_VALUE (
                             otmp.val_unita_operativa)
                          OVER (
                             PARTITION BY otmp.cod_abi_cartolarizzato,
                                          otmp.cod_abi_istituto,
                                          otmp.cod_ndg,
                                          otmp.cod_percorso,
                                          otmp.cod_processo,
                                          otmp.cod_stato_precedente,
                                          otmp.cod_stato,
                                          otmp.dta_decorrenza_stato,
                                          otmp.dta_scadenza_stato
                             ORDER BY ordine)
                             val_unita_operativa,
                          FIRST_VALUE (
                             otmp.id_utente)
                          OVER (
                             PARTITION BY otmp.cod_abi_cartolarizzato,
                                          otmp.cod_abi_istituto,
                                          otmp.cod_ndg,
                                          otmp.cod_percorso,
                                          otmp.cod_processo,
                                          otmp.cod_stato_precedente,
                                          otmp.cod_stato,
                                          otmp.dta_decorrenza_stato,
                                          otmp.dta_scadenza_stato
                             ORDER BY ordine)
                             id_utente,
                          FIRST_VALUE (
                             otmp.cognome)
                          OVER (
                             PARTITION BY otmp.cod_abi_cartolarizzato,
                                          otmp.cod_abi_istituto,
                                          otmp.cod_ndg,
                                          otmp.cod_percorso,
                                          otmp.cod_processo,
                                          otmp.cod_stato_precedente,
                                          otmp.cod_stato,
                                          otmp.dta_decorrenza_stato,
                                          otmp.dta_scadenza_stato
                             ORDER BY ordine)
                             cognome,
                          FIRST_VALUE (
                             otmp.nome)
                          OVER (
                             PARTITION BY otmp.cod_abi_cartolarizzato,
                                          otmp.cod_abi_istituto,
                                          otmp.cod_ndg,
                                          otmp.cod_percorso,
                                          otmp.cod_processo,
                                          otmp.cod_stato_precedente,
                                          otmp.cod_stato,
                                          otmp.dta_decorrenza_stato,
                                          otmp.dta_scadenza_stato
                             ORDER BY ordine)
                             nome
                     --, m.tms
                     FROM (                                      -------------
                           SELECT m.cod_abi_cartolarizzato,
                                  m.cod_abi_istituto,
                                  m.cod_ndg,
                                  m.cod_percorso,
                                  m.cod_processo,
                                  m.cod_stato_precedente,
                                  m.cod_stato,
                                  m.dta_decorrenza_stato,
                                  m.dta_scadenza_stato,
                                     NVL (f.cod_comparto_assegnato,
                                          f.cod_comparto_calcolato)
                                  || u.cod_matricola
                                     val_unita_operativa,
                                  f.id_utente,
                                  u.cognome,
                                  u.nome                             --, m.tms
                                        ----
                                  ,
                                  2 ordine
                             FROM t_mcre0_app_mople m
                                  INNER JOIN
                                  t_mcre0_app_file_guida f
                                     ON (    f.cod_abi_cartolarizzato =
                                                m.cod_abi_cartolarizzato
                                         AND f.cod_ndg = m.cod_ndg)
                                  LEFT OUTER JOIN t_mcre0_app_utenti u
                                     ON (u.id_utente = f.id_utente)
                            WHERE 1 = 1
                           UNION
                           SELECT ptmp.cod_abi_cartolarizzato,
                                  ptmp.cod_abi_istituto,
                                  ptmp.cod_ndg,
                                  ptmp.cod_percorso,
                                  ptmp.cod_processo,
                                  ptmp.cod_stato_precedente,
                                  ptmp.cod_stato,
                                  ptmp.dta_decorrenza_stato,
                                  ptmp.dta_scadenza_stato,
                                  ptmp.val_unita_operativa,
                                  ptmp.id_utente,
                                  ptmp.cognome,
                                  ptmp.nome                       --, ptmp.tms
                                           ,
                                  ptmp.ordine
                             FROM (SELECT p.cod_abi_cartolarizzato,
                                          p.cod_abi_istituto,
                                          p.cod_ndg,
                                          p.cod_percorso,
                                          p.cod_processo,
                                          p.cod_stato_precedente,
                                          p.cod_stato,
                                          p.dta_decorrenza_stato,
                                          p.dta_scadenza_stato,
                                          p.cod_codutrm val_unita_operativa,
                                          u.id_utente,
                                          u.cognome,
                                          u.nome                     --, m.tms
                                                ----
                                          ,
                                          MAX (
                                             p.cod_percorso)
                                          OVER (
                                             PARTITION BY p.cod_abi_cartolarizzato,
                                                          p.cod_ndg)
                                             ultimo_percorso,
                                          1 ordine
                                     FROM t_mcre0_app_percorsi p
                                          INNER JOIN
                                          t_mcre0_app_utenti u
                                             ON (SUBSTR (p.cod_codutrm, 7) =
                                                    u.cod_matricola(+))) ptmp
                            WHERE 1 = 1) otmp
                   --------------------------------------------------------
                   UNION
                   --Storico Eventi
                   SELECT tev.cod_abi_cartolarizzato,
                          tev.cod_abi_istituto,
                          tev.cod_ndg,
                          tev.cod_percorso,
                          tev.cod_processo,
                          tev.cod_stato_precedente,
                          tev.cod_stato,
                          tev.dta_decorrenza_stato,
                          tev.dta_scadenza_stato,
                          tev.val_unita_operativa,
                          tev.id_utente,
                          tev.cognome,
                          tev.nome
                     --, m.tms
                     FROM (SELECT otmp.cod_abi_cartolarizzato,
                                  otmp.cod_abi_istituto,
                                  otmp.cod_ndg,
                                  otmp.cod_percorso,
                                  otmp.cod_processo,
                                  otmp.cod_stato_precedente,
                                  otmp.cod_stato,
                                  /*otmp.dta_fine_validita*/
                                  dta_decorrenza_stato
                                     AS dta_decorrenza_stato,
                                  otmp.dta_scadenza_stato,
                                     NVL (otmp.cod_comparto_assegnato,
                                          otmp.cod_comparto_calcolato)
                                  || u.cod_matricola
                                     val_unita_operativa,
                                  u.id_utente,
                                  u.cognome,
                                  u.nome                          --, otmp.tms
                                        ,
                                  MAX (
                                     otmp.cod_percorso)
                                  OVER (
                                     PARTITION BY otmp.cod_abi_cartolarizzato,
                                                  otmp.cod_ndg)
                                     ultimo_percorso
                             FROM t_mcre0_app_storico_eventi otmp
                                  LEFT OUTER JOIN t_mcre0_app_utenti u
                                     ON (u.id_utente = otmp.id_utente)
                            WHERE     1 = 1
                                  AND otmp.flg_cambio_stato = 1
                                  AND otmp.dta_fine_validita >
                                         TRUNC (SYSDATE) + 8 / 24) tev
                    WHERE 1 = 1 AND tev.ultimo_percorso = tev.cod_percorso) tfin) sp
          LEFT JOIN
          t_mcre0_app_mople mpl
             ON     mpl.cod_abi_cartolarizzato = sp.cod_abi_cartolarizzato
                AND mpl.cod_ndg = sp.cod_ndg
                AND mpl.dta_decorrenza_stato = sp.dta_decorrenza_stato
                AND mpl.dta_scadenza_stato = sp.dta_scadenza_stato
                AND mpl.cod_stato_precedente = sp.cod_stato_precedente;
