/* Formatted on 17/06/2014 18:10:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DEL_PROSPETTO_POS
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANNOMESE,
   VAL_ESPOSIZIONE_LORDA_CAP,
   VAL_ACCANT_ANTE_DEL,
   VAL_ESPOSIZIONE_NETTA_ANTE_DEL,
   VAL_RETTIFICA_VALORE_PROP,
   VAL_ESPOSIZIONE_NETTA_POST_DEL,
   VAL_IMPORTO_OFFERTO,
   COD_UO_PRATICA,
   COD_STATO_DELIBERA,
   COD_PROTOCOLLO_DELIBERA,
   DTA_ESP_DELIBERA,
   VAL_ESBORSO,
   DTA_ESBORSO,
   VAL_EFF_CONTO_ECONOMICO,
   VAL_ESBORSO_PREVISTO,
   DTA_PREVEDIBILE_ESBORSO,
   COD_GRUPPO,
   VAL_TIPO_GESTIONE,
   COD_ORGANO_DELIBERANTE,
   VAL_NUM_DEL,
   COD_LABEL
)
AS
   SELECT                   -- 20130719 VG cod_uo_pratica e cod_stato_delibera
         a."COD_ABI",
          a."COD_NDG",
          a."COD_SNDG",
          a."DESC_NOME_CONTROPARTE",
          a."VAL_ANNOMESE",
          a."VAL_ESPOSIZIONE_LORDA_CAP",
          a."VAL_ACCANT_ANTE_DEL",
          a."VAL_ESPOSIZIONE_NETTA_ANTE_DEL",
          a."VAL_RETTIFICA_VALORE_PROP",
          a."VAL_ESPOSIZIONE_NETTA_POST_DEL",
          a."VAL_IMPORTO_OFFERTO",
          a.cod_uo_pratica,
          a.cod_stato_delibera,
          a.cod_protocollo_delibera,
          a.dta_esp_delibera,
          VAL_ESBORSO,
          DTA_ESBORSO,
          VAL_EFF_CONTO_ECONOMICO,
          VAL_ESBORSO_PREVISTO,
          DTA_PREVEDIBILE_ESBORSO,
          a."COD_GRUPPO",
          a."VAL_TIPO_GESTIONE",
          a."COD_ORGANO_DELIBERANTE",
          VAL_NUM_DEL,
          CASE
             ---- GRUPPO 1
             WHEN     COD_GRUPPO = 1
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                1
             WHEN     COD_GRUPPO = 1
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA IN ('DRC', 'SRV', 'Presidio')
             THEN
                2
             WHEN     COD_GRUPPO = 1
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                3
             WHEN     COD_GRUPPO = 1
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'DRC'
             THEN
                4
             WHEN     COD_GRUPPO = 1
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Italfondiario'
             THEN
                5
             WHEN COD_GRUPPO = 0
             THEN
                6
             ---- GRUPPO 2
             WHEN     COD_GRUPPO = 2
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                1
             WHEN     COD_GRUPPO = 2
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA IN ('DRC', 'SRV', 'Presidio')
             THEN
                2
             WHEN     COD_GRUPPO = 2
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                3
             WHEN     COD_GRUPPO = 2
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'DRC'
             THEN
                4
             WHEN     COD_GRUPPO = 2
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Italfondiario'
             THEN
                5
             ---- GRUPPO 3
             WHEN     COD_GRUPPO = 3
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                1
             WHEN     COD_GRUPPO = 3
                  AND VAL_TIPO_GESTIONE = 'I'
                  AND O.VAL_CATEGORIA IN ('DRC', 'SRV', 'Presidio')
             THEN
                2
             WHEN     COD_GRUPPO = 3
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Banca'
             THEN
                3
             WHEN     COD_GRUPPO = 3
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'DRC'
             THEN
                4
             WHEN     COD_GRUPPO = 3
                  AND VAL_TIPO_GESTIONE = 'E'
                  AND O.VAL_CATEGORIA = 'Italfondiario'
             THEN
                5
             ---- GRUPPO 4
             WHEN COD_GRUPPO = 4 AND VAL_TIPO_GESTIONE = 'I'
             THEN
                1
             WHEN COD_GRUPPO = 4 AND VAL_TIPO_GESTIONE = 'E'
             THEN
                2
             ---- GRUPPO 5
             WHEN COD_GRUPPO = 5 AND VAL_TIPO_GESTIONE = 'I'
             THEN
                1
             WHEN COD_GRUPPO = 5 AND VAL_TIPO_GESTIONE = 'E'
             THEN
                2
          END
             COD_LABEL
     FROM (  SELECT D.COD_ABI,
                    D.COD_NDG,
                    D.COD_SNDG,
                    a.DESC_NOME_CONTROPARTE,
                    p.cod_uo_pratica,
                    d.cod_stato_delibera,
                    d.cod_protocollo_delibera,
                    NVL (d.dta_conferma, D.DTA_aggiornamento_DELIBERA)
                       dta_esp_delibera,
                    TO_NUMBER (
                       SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6))
                       VAL_ANNOMESE,
                    CASE
                       WHEN COD_DELIBERA IN ('NZ') THEN 0
                       WHEN COD_DELIBERA IN ('RV', 'NS', 'AS') THEN 1
                       WHEN COD_DELIBERA IN ('TT', 'TP', 'TS') THEN 2
                       WHEN COD_DELIBERA IN ('SN') THEN 3
                       WHEN COD_DELIBERA IN ('RE') THEN 4
                       WHEN COD_DELIBERA IN ('ES') THEN 5
                       ELSE -1
                    END
                       COD_GRUPPO,
                    R.VAL_TIPO_GESTIONE,
                    D.COD_ORGANO_DELIBERANTE,
                    COUNT (D.COD_DELIBERA) VAL_NUM_DEL,
                    SUM (VAL_ESPOSIZIONE_LORDA_CAP) VAL_ESPOSIZIONE_LORDA_CAP,
                    SUM (VAL_ACCANT_ANTE_DEL) VAL_ACCANT_ANTE_DEL,
                    SUM (VAL_ESPOSIZIONE_NETTA_ANTE_DEL)
                       VAL_ESPOSIZIONE_NETTA_ANTE_DEL,
                    SUM (VAL_RETTIFICA_VALORE_PROP) VAL_RETTIFICA_VALORE_PROP,
                    SUM (VAL_ESPOSIZIONE_NETTA_POST_DEL)
                       VAL_ESPOSIZIONE_NETTA_POST_DEL,
                    SUM (VAL_IMPORTO_OFFERTO) VAL_IMPORTO_OFFERTO,
                    SUM (D.VAL_ESBORSO) VAL_ESBORSO,
                    MAX (D.DTA_ESBORSO) DTA_ESBORSO,
                    SUM (
                       CASE
                          WHEN COD_DELIBERA IN ('TT', 'TP', 'TS')
                          THEN
                               VAL_IMPORTO_OFFERTO
                             - VAL_ESPOSIZIONE_NETTA_ANTE_DEL
                          ELSE
                             VAL_EFF_CONTO_ECONOMICO
                       END)
                       VAL_EFF_CONTO_ECONOMICO,
                    SUM (VAL_NEW_ACCANT_RISCHI_ONERI) VAL_ESBORSO_PREVISTO,
                    MAX (DTA_PREVEDIBILE_ESBORSO) DTA_PREVEDIBILE_ESBORSO
               FROM T_MCRES_APP_DELIBERE D,
                    T_MCRES_APP_PRATICHE P,
                    T_MCRE0_APP_ANAGRAFICA_GRUPPO a,
                    v_mcres_app_lista_presidi r
              WHERE     D.COD_ABI =
                           SUBSTR (SYS_CONTEXT ('userenv', 'client_info'),
                                   7,
                                   5)
                    AND NVL (d.dta_conferma, D.DTA_aggiornamento_DELIBERA) BETWEEN TO_DATE (
                                                                                         TO_NUMBER (
                                                                                            SUBSTR (
                                                                                               SYS_CONTEXT (
                                                                                                  'userenv',
                                                                                                  'client_info'),
                                                                                               1,
                                                                                               6))
                                                                                      || '01',
                                                                                      'YYYYMMDD')
                                                                               AND LAST_DAY (
                                                                                      TO_DATE (
                                                                                         TO_NUMBER (
                                                                                            SUBSTR (
                                                                                               SYS_CONTEXT (
                                                                                                  'userenv',
                                                                                                  'client_info'),
                                                                                               1,
                                                                                               6)),
                                                                                         'YYYYMM'))
                    AND D.COD_ABI = P.COD_ABI
                    AND D.COD_NDG = P.COD_NDG
                    AND D.COD_PRATICA = P.COD_PRATICA
                    AND D.VAL_ANNO_PRATICA = P.VAL_ANNO
                    AND D.COD_SNDG = a.COD_SNDG(+)
                    AND P.COD_UO_PRATICA = R.COD_PRESIDIO(+)
           --      and d.cod_stato_delibera='CO'
           GROUP BY D.COD_ABI,
                    D.COD_NDG,
                    D.COD_SNDG,
                    a.DESC_NOME_CONTROPARTE,
                    p.cod_uo_pratica,
                    cod_stato_delibera,
                    d.cod_protocollo_delibera,
                    NVL (d.dta_conferma, D.DTA_aggiornamento_DELIBERA),
                    TO_NUMBER (
                       SUBSTR (SYS_CONTEXT ('userenv', 'client_info'), 1, 6)),
                    CASE
                       WHEN COD_DELIBERA IN ('NZ') THEN 0
                       WHEN COD_DELIBERA IN ('RV', 'NS', 'AS') THEN 1
                       WHEN COD_DELIBERA IN ('TT', 'TP', 'TS') THEN 2
                       WHEN COD_DELIBERA IN ('SN') THEN 3
                       WHEN COD_DELIBERA IN ('RE') THEN 4
                       WHEN COD_DELIBERA IN ('ES') THEN 5
                       ELSE -1
                    END,
                    R.VAL_TIPO_GESTIONE,
                    D.COD_ORGANO_DELIBERANTE) a,
          T_MCRES_CL_ORGANO_DELIBERANTE O
    WHERE     a.COD_ABI = O.COD_ABI(+)
          AND a.COD_ORGANO_DELIBERANTE = O.COD_ORGANO_DELIBERANTE(+)
          AND TO_DATE ('99991231', 'YYYYMMDD') = O.DTA_SCADENZA(+)
          AND a.cod_uo_pratica = o.COD_UO(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_DEL_PROSPETTO_POS TO MCRE_USR;
