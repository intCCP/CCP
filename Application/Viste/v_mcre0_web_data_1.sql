/* Formatted on 21/07/2014 18:38:19 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_WEB_DATA_1
(
   TODAY_FLG,
   FLG_ACTIVE,
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
   COD_FILIALE,
   COD_STRUTTURA_COMPETENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   DTA_INTERCETTAMENTO,
   COD_TIPO_INGRESSO,
   COD_CAUSALE_INGRESSO,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_PROCESSO_PRE,
   COD_MACROSTATO,
   DTA_DEC_MACROSTATO,
   COD_RAMO_CALCOLATO,
   COD_COMPARTO_CALCOLATO,
   COD_COMPARTO_CALCOLATO_PRE,
   COD_GRUPPO_SUPER,
   COD_GRUPPO_SUPER_OLD,
   FLG_RIPORTAFOGLIATO,
   DTA_LAST_RIPORTAF,
   FLG_PROPOSTO_ASSEGNATO,
   DTA_UTENTE_ASSEGNATO,
   COD_COMPARTO_ASSEGNATO,
   ID_UTENTE,
   ID_UTENTE_PRE,
   COD_SERVIZIO,
   DTA_SERVIZIO,
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
   DTA_UPD
)
AS
   WITH                                                                     --
       gbav
        AS                                                             --GB/AV
          (SELECT *
             FROM (SELECT a.*,
                          h.cod_comparto_proposto,
                          ROW_NUMBER ()
                          OVER (PARTITION BY a.cod_gruppo_super
                                ORDER BY h.dta_stato)
                             myrnk
                     FROM (SELECT cod_abi_cartolarizzato,
                                  cod_ndg,
                                  cod_comparto_proposto,
                                  dta_stato
                             FROM t_mcre0_app_gb_gestione
                            WHERE flg_stato = 1
                           UNION
                           SELECT cod_abi_cartolarizzato,
                                  cod_ndg,
                                  cod_comparto_av,
                                  dta_stato
                             FROM t_mcre0_app_av_gestione
                            WHERE flg_stato = 1) h,
                          t_mcre0_day_fg_mopl a
                    WHERE     h.cod_abi_cartolarizzato =
                                 a.cod_abi_cartolarizzato
                          AND h.cod_ndg = a.cod_ndg) h
            WHERE h.myrnk = 1),
        r
        AS                                   --controlli di riportafogliazione
          (SELECT a.*,
                  CASE
                     WHEN     NVL (a.cod_comparto_calcolato, -1) <> '011901'
                          AND (SELECT w.COD_COMPARTO_CALCOLATO_PRE
                                 FROM t_mcre0_web_data w
                                WHERE     w.flg_active = '1'
                                      AND a.cod_abi_cartolarizzato =
                                             w.cod_abi_cartolarizzato
                                      AND a.cod_ndg = w.cod_ndg) = '011901'
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
                     flg_riportafogliato,
                  CASE
                     WHEN     NVL (a.cod_comparto_calcolato, -1) <> '011901'
                          AND (SELECT w.COD_COMPARTO_CALCOLATO_PRE
                                 FROM t_mcre0_web_data w
                                WHERE     w.flg_active = '1'
                                      AND a.cod_abi_cartolarizzato =
                                             w.cod_abi_cartolarizzato
                                      AND a.cod_ndg = w.cod_ndg) = '011901'
                     THEN
                        SYSDATE
                     ELSE
                        (SELECT w.dta_last_riportaf
                           FROM t_mcre0_web_data w
                          WHERE     w.flg_active = '1'
                                AND a.cod_abi_cartolarizzato =
                                       w.cod_abi_cartolarizzato
                                AND a.cod_ndg = w.cod_ndg)
                  END
                     dta_last_riportaf,
                  CASE
                     WHEN     NVL (a.cod_comparto_calcolato, -1) <> '011901'
                          AND (SELECT w.COD_COMPARTO_CALCOLATO_PRE
                                 FROM t_mcre0_web_data w
                                WHERE     w.flg_active = '1'
                                      AND a.cod_abi_cartolarizzato =
                                             w.cod_abi_cartolarizzato
                                      AND a.cod_ndg = w.cod_ndg) = '011901'
                     THEN
                        (SELECT w.id_utente
                           FROM t_mcre0_web_data w
                          WHERE     w.flg_active = '1'
                                AND a.cod_abi_cartolarizzato =
                                       w.cod_abi_cartolarizzato
                                AND a.cod_ndg = w.cod_ndg)
                     ELSE
                        (SELECT w.id_utente_pre
                           FROM t_mcre0_web_data w
                          WHERE     w.flg_active = '1'
                                AND a.cod_abi_cartolarizzato =
                                       w.cod_abi_cartolarizzato
                                AND a.cod_ndg = w.cod_ndg)
                  END
                     id_utente_pre,
                  (SELECT w.cod_comparto_calcolato_pre
                     FROM t_mcre0_web_data w
                    WHERE     w.flg_active = '1'
                          AND a.cod_abi_cartolarizzato =
                                 w.cod_abi_cartolarizzato
                          AND a.cod_ndg = w.cod_ndg)
                     cod_comparto_calcolato_pre
             FROM gbav a),
        a
        AS -- individuo le sole posizioni che mi interessano, quelli con gli stati opportuni
          (SELECT TO_CHAR (
                     NVL (
                        SUM (v.flg_web)
                           OVER (PARTITION BY r.cod_gruppo_super),
                        0))
                     flg_web,
                  r.*
             FROM r, v_mcre0_posz_web v
            WHERE     v.cod_abi_cartolarizzato(+) = r.cod_abi_cartolarizzato
                  AND v.cod_ndg(+) = r.cod_ndg),
        n
        AS (SELECT a.*,
                   CASE
                      WHEN a.flg_riportafogliato = '1' THEN NULL
                      WHEN a.flg_web = '1' THEN dta_utente_assegnato
                      ELSE NULL
                   END
                      dta_utente_assegnato,
                   CASE
                      WHEN a.flg_riportafogliato = '1' THEN NULL
                      WHEN a.flg_web = '1' THEN cod_comparto_assegnato
                      ELSE cod_comparto_proposto
                   END
                      cod_comparto_assegnato,
                   CASE
                      WHEN a.flg_riportafogliato = '1' THEN -1
                      WHEN a.flg_web = '1' THEN id_utente
                      ELSE -1
                   END
                      id_utente,
                   TO_CHAR (
                      CASE
                         WHEN a.flg_riportafogliato = '1' THEN 0
                         WHEN a.flg_web = '1' THEN 0
                         ELSE 1
                      END)
                      flg_proposto_assegnato
              FROM a,
                   (SELECT *
                      FROM ( --recupero la terna (dta_utente_assegnato,cod_comparto_assegnato,id_utente) dai dati dell'applicazione, prendo il record più vecchio e lo spalmo sul GS
                            SELECT cod_gruppo_super,
                                   dta_utente_assegnato,
                                   cod_comparto_assegnato,
                                   id_utente,
                                   ROW_NUMBER ()
                                   OVER (PARTITION BY cod_gruppo_super
                                         ORDER BY dta_utente_assegnato)
                                      myrnk
                              FROM t_mcre0_web_data
                             WHERE     flg_active = '1'
                                   AND COD_GRUPPO_SUPER IS NOT NULL) b
                     WHERE     b.myrnk = 1
                           -- esiste il caso con cod_comparto_assegnato=NULL ma id_utente/dta_utente_assegnato valorizzati, perché si visualizza come cmparto il default (che è il calcolato)
                           AND (   dta_utente_assegnato IS NOT NULL
                                OR cod_comparto_assegnato IS NOT NULL
                                OR id_utente IS NOT NULL)
                           AND COD_GRUPPO_SUPER IS NOT NULL) b
             WHERE a.COD_GRUPPO_SUPER = b.COD_GRUPPO_SUPER(+)),
        y
        AS (SELECT n.*, -- se COD_COMPARTO_CALCOLATO = '011901'  impongo il servizio e data relativi, nota: per costruzione non è un riportafogliato
                   CASE
                      WHEN cod_macrostato IN
                              ('PT', 'RIO', 'IN', 'SC', 'RS', 'SO')
                      THEN
                         CASE
                            WHEN n.cod_comparto_calcolato = '011901'
                            THEN
                               (SELECT cod_servizio
                                  FROM t_mcre0_app_comparti
                                 WHERE cod_comparto =
                                          NVL (n.cod_comparto_assegnato,
                                               n.cod_comparto_calcolato))
                            ELSE
                               (SELECT w.cod_servizio
                                  FROM t_mcre0_web_data w
                                 WHERE     w.flg_active = '1'
                                       AND n.cod_abi_cartolarizzato =
                                              w.cod_abi_cartolarizzato
                                       AND n.cod_ndg = cod_ndg)
                         END
                      ELSE
                         NULL
                   END
                      cod_servizio,
                   CASE
                      WHEN cod_macrostato IN
                              ('PT', 'RIO', 'IN', 'SC', 'RS', 'SO')
                      THEN
                         CASE
                            WHEN n.cod_comparto_calcolato = '011901'
                            THEN
                               SYSDATE
                            ELSE
                               (SELECT CASE
                                          WHEN w.cod_servizio IS NULL
                                          THEN
                                             NULL
                                          ELSE
                                             w.dta_servizio
                                       END
                                          dta_servizio
                                  FROM t_mcre0_web_data w
                                 WHERE     w.flg_active = '1'
                                       AND n.cod_abi_cartolarizzato =
                                              w.cod_abi_cartolarizzato
                                       AND n.cod_ndg = cod_ndg)
                         END
                      ELSE
                         NULL
                   END
                      dta_servizio
              FROM n)
   SELECT TODAY_FLG,
          '1' flg_active,
          ID_DPER,
          COD_ABI_ISTITUTO,
          COD_ABI_CARTOLARIZZATO,
          COD_NDG,
          COD_SNDG,
          --
          COD_GRUPPO_ECONOMICO,
          COD_GRUPPO_LEGAME,
          FLG_GRUPPO_ECONOMICO,
          FLG_GRUPPO_LEGAME,
          FLG_SINGOLO,
          FLG_CONDIVISO,
          FLG_SOMMA,
          FLG_OUTSOURCING,
          COD_FILIALE,
          COD_STRUTTURA_COMPETENTE,
          COD_STATO,
          DTA_DECORRENZA_STATO,
          DTA_SCADENZA_STATO,
          COD_STATO_PRECEDENTE,
          DTA_DECORRENZA_STATO_PRE,
          DTA_INTERCETTAMENTO,
          COD_TIPO_INGRESSO,
          COD_CAUSALE_INGRESSO,
          COD_PERCORSO,
          COD_PROCESSO,
          DTA_PROCESSO,
          COD_PROCESSO_PRE,
          COD_MACROSTATO,
          DTA_DEC_MACROSTATO,
          COD_RAMO_CALCOLATO,
          COD_COMPARTO_CALCOLATO,
          COD_COMPARTO_CALCOLATO_PRE,
          --
          COD_GRUPPO_SUPER,
          COD_GRUPPO_SUPER_OLD,
          --
          FLG_RIPORTAFOGLIATO,
          DTA_LAST_RIPORTAF,
          --
          flg_proposto_assegnato,
          --
          DTA_UTENTE_ASSEGNATO,
          COD_COMPARTO_ASSEGNATO,
          ID_UTENTE,
          ID_UTENTE_PRE,
          --
          COD_SERVIZIO,
          DTA_SERVIZIO,
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
          DTA_UPD
     FROM y;
