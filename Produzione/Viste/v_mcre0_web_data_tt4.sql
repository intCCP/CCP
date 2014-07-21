/* Formatted on 17/06/2014 18:06:56 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WEB_DATA_TT4
(
   TODAY_FLG,
   ID_DPER,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   COD_GRUPPO_LEGAME,
   FLG_GRUPPO_ECONOMICO,
   FLG_GRUPPO_LEGAME,
   FLG_SINGOLO,
   FLG_CONDIVISO,
   FLG_SOMMA,
   FLG_OUTSOURCING,
   COD_STATO,
   DTA_INTERCETTAMENTO,
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_CALCOLATO,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD,
   ID_STATO_POSIZIONE,
   COD_CLIENTE_ESTESO,
   ID_CLIENTE_ESTESO,
   DESC_ANAG_GESTORE_MKT,
   COD_GESTORE_MKT,
   COD_TIPO_PORTAFOGLIO,
   FLG_GESTIONE_ESTERNA,
   VAL_PERC_DECURTAZIONE,
   COD_COMPARTO_HOST,
   ID_TRANSIZIONE,
   COD_RAMO_HOST,
   COD_MATR_RISCHIO,
   COD_UO_RISCHIO,
   COD_DISP_RISCHIO,
   DTA_INS,
   DTA_UPD,
   COD_COMPARTO_PROPOSTO,
   FLG_RIPORTAFOGLIATO,
   DTA_LAST_RIPORTAF,
   ID_UTENTE_PRE,
   COD_COMPARTO_CALCOLATO_PRE,
   FLG_WEB,
   ID_DPERFG,
   ID_DPERMO,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   FLG_PROPOSTO_ASSEGNATO
)
AS
   SELECT DISTINCT /*+full(h) NO_INDEX(h IX2_MCRE0_WEB_DATA)*/
          a."TODAY_FLG",
          a."ID_DPER",
          a."COD_ABI_ISTITUTO",
          a."COD_ABI_CARTOLARIZZATO",
          a."COD_NDG",
          a."COD_SNDG",
          a."COD_GRUPPO_ECONOMICO",
          a."COD_GRUPPO_LEGAME",
          a."FLG_GRUPPO_ECONOMICO",
          a."FLG_GRUPPO_LEGAME",
          a."FLG_SINGOLO",
          a."FLG_CONDIVISO",
          a."FLG_SOMMA",
          a."FLG_OUTSOURCING",
          a."COD_STATO",
          a."DTA_INTERCETTAMENTO",
          a."COD_FILIALE",
          a."COD_STRUTTURA_COMPETENTE",
          a."COD_TIPO_INGRESSO",
          a."COD_CAUSALE_INGRESSO",
          a."COD_PERCORSO",
          a."COD_PROCESSO",
          a."DTA_DECORRENZA_STATO",
          a."DTA_SCADENZA_STATO",
          a."COD_STATO_PRECEDENTE",
          a."DTA_DECORRENZA_STATO_PRE",
          a."DTA_PROCESSO",
          a."COD_PROCESSO_PRE",
          a."COD_MACROSTATO",
          a."DTA_DEC_MACROSTATO",
          a."COD_RAMO_CALCOLATO",
          a."COD_COMPARTO_CALCOLATO",
          CASE
             WHEN (LENGTH (a.COD_GRUPPO_SUPER) > 20)
             THEN
                   SUBSTR (a.COD_GRUPPO_SUPER, 0, 5)
                || SUBSTR (a.COD_GRUPPO_SUPER, 7, 21)
             ELSE
                a.COD_GRUPPO_SUPER
          END
             COD_GRUPPO_SUPER,                         --a."COD_GRUPPO_SUPER",
          a."COD_GRUPPO_SUPER_OLD",
          a."ID_STATO_POSIZIONE",
          a."COD_CLIENTE_ESTESO",
          a."ID_CLIENTE_ESTESO",
          a."DESC_ANAG_GESTORE_MKT",
          a."COD_GESTORE_MKT",
          a."COD_TIPO_PORTAFOGLIO",
          a."FLG_GESTIONE_ESTERNA",
          a."VAL_PERC_DECURTAZIONE",
          a."COD_COMPARTO_HOST",
          a."ID_TRANSIZIONE",
          a."COD_RAMO_HOST",
          a."COD_MATR_RISCHIO",
          a."COD_UO_RISCHIO",
          a."COD_DISP_RISCHIO",
          a."DTA_INS",
          a."DTA_UPD",
          a."COD_COMPARTO_PROPOSTO",
          a."FLG_RIPORTAFOGLIATO",
          a."DTA_LAST_RIPORTAF",
          a."ID_UTENTE_PRE",
          a."COD_COMPARTO_CALCOLATO_PRE",
          a."FLG_WEB",
          a."ID_DPERFG",
          a."ID_DPERMO",
          --          CASE
          --             WHEN a.flg_riportafogliato = '1' THEN NULL
          --             WHEN a.flg_web = '1' THEN h.dta_utente_assegnato
          --             ELSE NULL
          --          END
          NULL dta_utente_assegnato,
          --          CASE
          --             WHEN a.flg_riportafogliato = '1' THEN NULL
          --             WHEN a.flg_web = '1' THEN h.cod_comparto_assegnato
          --             ELSE cod_comparto_proposto
          --          END
          NULL cod_comparto_assegnato,
          --          CASE
          --             WHEN a.flg_riportafogliato = '1' THEN -1
          --             WHEN a.flg_web = '1' THEN h.id_utente
          --             ELSE -1
          --          END
          -1 id_utente,
          TO_CHAR (
             CASE
                WHEN a.flg_riportafogliato = '1' THEN 0
                WHEN a.flg_web = '1' THEN 0
                ELSE 1
             END)
             flg_proposto_assegnato
     FROM mcre_own.TTMCRE0_WEB_DATA_3 a                                    --,
--          (SELECT cod_gruppo_super,
--                  cod_comparto_assegnato,
--                  id_utente,
--                  dta_utente_assegnato,
--                  ROW_NUMBER ()
--                  OVER (
--                     PARTITION BY cod_gruppo_super
--                     ORDER BY
--                        dta_utente_assegnato,
--                        cod_comparto_assegnato,
--                        id_utente)
--                     myrnk
--             FROM (SELECT          /*+full(h) NO_INDEX(h IX2_MCRE0_WEB_DATA)*/
--                         DISTINCT cod_gruppo_super,
--                                  cod_comparto_assegnato,
--                                  id_utente,
--                                  dta_utente_assegnato
--                     FROM t_mcre0_all_data h
--                    WHERE h.flg_active = '1'
--                          AND h.cod_gruppo_super IS NOT NULL)) h
--          (SELECT -2 id_utente,
--                  NULL dta_utente_assegnato,
--                  NULL COD_COMPARTO_ASSEGNATO,
--                  -2 cod_servizio
--             FROM DUAL) h;
;


GRANT SELECT ON MCRE_OWN.V_MCRE0_WEB_DATA_TT4 TO MCRE_USR;
