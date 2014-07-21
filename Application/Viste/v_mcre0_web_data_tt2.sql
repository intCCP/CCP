/* Formatted on 21/07/2014 18:38:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WEB_DATA_TT2
(
   TODAY_FLG,
   ID_DPER,
   ID_DPERFG,
   ID_DPERMO,
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
   COD_COMPARTO_CALCOLATO_PRE
)
AS
   SELECT /*+full(w) NO_INDEX(w IX2_MCRE0_WEB_DATA)*/
         a."TODAY_FLG",
          a."ID_DPER",
          a."ID_DPERFG",
          a."ID_DPERMO",
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
          a."COD_GRUPPO_SUPER",
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
          CASE
             WHEN     a.cod_comparto_calcolato <> '011901'
                  AND w.cod_comparto_calcolato = '011901'
             THEN
                '1'
             ELSE
                '0'
          END
             flg_riportafogliato,
          CASE
             WHEN     a.cod_comparto_calcolato <> '011901'
                  AND w.cod_comparto_calcolato = '011901'
             THEN
                SYSDATE
             ELSE
                w.dta_last_riportaf
          END
             dta_last_riportaf,
          CASE
             WHEN     a.cod_comparto_calcolato <> '011901'
                  AND w.cod_comparto_calcolato = '011901'
             THEN
                w.id_utente
             ELSE
                w.id_utente_pre
          END
             id_utente_pre,
          NVL (w.cod_comparto_calcolato, '#') cod_comparto_calcolato_pre
     FROM TTMCRE0_WEB_DATA_1 a, t_mcre0_all_data w
    WHERE                                       -- w.flg_active(+) = '1'   AND
         a    .cod_abi_cartolarizzato = w.cod_abi_cartolarizzato(+)
          AND a.cod_ndg = w.cod_ndg(+);
