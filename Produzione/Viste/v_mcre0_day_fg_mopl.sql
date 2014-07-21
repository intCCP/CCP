/* Formatted on 17/06/2014 18:05:08 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_DAY_FG_MOPL
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
   DTA_UPD
)
AS
   SELECT TODAY_FLG,
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
          DTA_UPD
     FROM (SELECT a.*,
                  CASE
                     WHEN     cod_ramo_calcolato IS NULL
                          AND EXISTS
                                 (SELECT DISTINCT
                                         cod_abi_istituto,
                                         cod_struttura_competente
                                    FROM t_mcre0_app_struttura_org
                                   WHERE    (    cod_livello IN ('AR', 'RG')
                                             AND cod_abi_istituto =
                                                    cod_abi_cartolarizzato
                                             AND cod_struttura_competente =
                                                    cod_comparto_calcolato)
                                         --mc 27/05/14 OR aggiunto per variazione perimetro DR
                                         OR (    cod_livello IN ('AR', 'DI')
                                             AND cod_abi_istituto =
                                                    cod_abi_cartolarizzato
                                             AND cod_comparto =
                                                    cod_comparto_calcolato))
                     THEN
                           cod_comparto_calcolato
                        || SUBSTR (cod_gruppo_super_1, 6, 20)
                     ELSE
                        cod_gruppo_super_1
                  END
                     cod_gruppo_super,
                  CASE
                     WHEN     cod_ramo_calcolato IS NULL
                          AND EXISTS
                                 (SELECT DISTINCT
                                         cod_abi_istituto,
                                         cod_struttura_competente
                                    FROM t_mcre0_app_struttura_org
                                   WHERE    (    cod_livello IN ('AR', 'RG')
                                             AND cod_abi_istituto = '01025'
                                             AND cod_struttura_competente =
                                                    min_chost)
                                         --mc 27/05/14 OR aggiunto per variazione perimetro DR
                                         OR (    cod_livello IN ('AR', 'DI')
                                             AND cod_abi_istituto =
                                                    cod_abi_cartolarizzato
                                             AND cod_comparto =
                                                    cod_comparto_calcolato
                                             AND cod_struttura_competente =
                                                    '01911'))
                     THEN
                        cod_gruppo_super_1
                     ELSE
                        NULL
                  END
                     --                  (SELECT cod_gruppo_super --case when f.cod_gruppo_super!=cod_gruppo_super_1 then cod_gruppo_super else cod_gruppo_super_old end
                     --                     FROM t_mcre0_all_data f
                     --                    WHERE f.cod_gruppo_super IS NOT NULL
                     --                          AND f.cod_abi_cartolarizzato =
                     --                                 a.cod_abi_cartolarizzato
                     --                          AND f.cod_ndg = a.cod_ndg)
                     cod_gruppo_super_old
             FROM (SELECT f.*,
                          m.id_dpermo,
                          NVL (m.today_flg, '0') today_flg,
                          (SELECT CASE
                                     WHEN m.cod_stato = 'SO'
                                     THEN
                                        DECODE (
                                           (SELECT MAX (b.cod_livello)
                                              FROM t_mcre0_app_struttura_org b,
                                                   t_mcres_app_pratiche p
                                             WHERE     m.cod_abi_cartolarizzato =
                                                          b.cod_abi_istituto
                                                   -- AND m.cod_struttura_competente =  b.cod_struttura_competente
                                                   AND p.COD_UO_PRATICA =
                                                          b.COD_STRUTTURA_COMPETENTE
                                                   AND p.flg_attiva(+) = 1
                                                   AND m.COD_ABI_CARTOLARIZZATO =
                                                          p.cod_abi(+)
                                                   AND m.cod_ndg =
                                                          p.cod_ndg(+)),
                                           'PL', 'N',
                                           'IP', 'N',
                                           'IC', 'N',
                                           'RC', 'N',
                                           --NULL, 'N',
                                           NVL (i.FLG_OUTSOURCING, 'N'))
                                     ELSE
                                        NVL (i.FLG_OUTSOURCING, 'N')
                                  END
                             FROM t_mcre0_app_istituti i
                            WHERE i.cod_abi = m.cod_abi_cartolarizzato)
                             FLG_OUTSOURCING,
                          /*mople*/
                          NVL (m.cod_stato, '-1') cod_stato,
                          DTA_INTERCETTAMENTO,
                          CASE
                             WHEN m.cod_abi_cartolarizzato || m.cod_ndg
                                     IS NULL
                             THEN
                                '-'
                             ELSE
                                NVL (COD_FILIALE, '00000')
                          END
                             COD_FILIALE,
                          CASE
                             WHEN m.cod_abi_cartolarizzato || m.cod_ndg
                                     IS NULL
                             THEN
                                NULL
                             ELSE
                                NVL (COD_STRUTTURA_COMPETENTE, '00000')
                          END
                             COD_STRUTTURA_COMPETENTE,
                          COD_TIPO_INGRESSO,
                          COD_CAUSALE_INGRESSO,
                          COD_PERCORSO,
                          COD_PROCESSO,
                          DTA_DECORRENZA_STATO,
                          DTA_SCADENZA_STATO,
                          NVL (m.COD_STATO_PRECEDENTE, '-1')
                             COD_STATO_PRECEDENTE,
                          DTA_DECORRENZA_STATO_PRE,
                          DTA_PROCESSO,
                          COD_PROCESSO_PRE,
                          COD_MACROSTATO,
                          DTA_DEC_MACROSTATO,
                          --
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
                          --
                          CASE
                             WHEN MIN (m.cod_ramo)
                                     OVER (PARTITION BY cod_gruppo_super_1)
                                     IS NOT NULL
                             THEN
                                MIN (m.cod_ramo)
                                   OVER (PARTITION BY cod_gruppo_super_1)
                             ELSE
                                m.cod_ramo_host
                          END
                             cod_ramo_calcolato,
                          NVL (
                             CASE
                                WHEN MIN (m.cod_ramo)
                                     OVER (PARTITION BY cod_gruppo_super_1)
                                        IS NOT NULL
                                THEN
                                   MIN (m.cod_comparto)
                                      OVER (PARTITION BY cod_gruppo_super_1)
                                ELSE
                                   m.cod_comparto_host
                             END,
                             '#')
                             cod_comparto_calcolato,
                          MIN (NVL (m.cod_comparto_host, '999999'))
                             OVER (PARTITION BY cod_gruppo_super_1)
                             min_chost
                     FROM (SELECT t_mcre0_day_fg.*,
                                  id_dper AS id_dperfg,
                                  CASE
                                     WHEN NVL (cod_gruppo_economico, '-1') <>
                                             '-1'
                                     THEN
                                           'GE'
                                        || LPAD (cod_gruppo_economico,
                                                 18,
                                                 '0')
                                     WHEN NVL (cod_gruppo_legame, '-1') <>
                                             '-1'
                                     THEN
                                        NVL (
                                           (SELECT 'GE' || LPAD (ma, 18, '0')
                                              FROM (SELECT DISTINCT
                                                           cod_gruppo_legame,
                                                           COUNT (
                                                              DISTINCT cod_gruppo_economico)
                                                           OVER (
                                                              PARTITION BY cod_gruppo_legame)
                                                              cn,
                                                           MIN (
                                                              cod_gruppo_economico)
                                                           OVER (
                                                              PARTITION BY cod_gruppo_legame)
                                                              mi,
                                                           MAX (
                                                              cod_gruppo_economico)
                                                           OVER (
                                                              PARTITION BY cod_gruppo_legame)
                                                              ma
                                                      FROM (SELECT /*+index(t_mcre0_day_fg IX1_MCRE0_DAY_FG)*/
                                                                  DISTINCT
                                                                   cod_gruppo_legame,
                                                                   NVL (
                                                                      cod_gruppo_economico,
                                                                      '-1')
                                                                      cod_gruppo_economico
                                                              FROM t_mcre0_day_fg)) a
                                             WHERE     a.cn > 1
                                                   AND a.mi = '-1'
                                                   AND a.cod_gruppo_legame =
                                                          t_mcre0_day_fg.cod_gruppo_legame),
                                              'GL'
                                           || LPAD (cod_gruppo_legame,
                                                    18,
                                                    '0'))
                                     --when cod_gruppo_economico is null and cod_gruppo_legame is not null and
                                     --count(DISTINCT NVL(cod_gruppo_economico,'-1')) over (partition by cod_gruppo_legame)>1
                                     --and min(NVL(cod_gruppo_economico,'-1')) over (partition by cod_gruppo_legame)='-1'
                                     --then 'GE'|| LPAD (MAX (cod_gruppo_economico) over (partition by cod_gruppo_legame) , 18, '0')
                                     --WHEN cod_gruppo_legame IS NOT NULL
                                     --THEN 'GL'|| LPAD (cod_gruppo_legame, 18, '0')
                                     WHEN cod_sndg = '0000000000000000'
                                     THEN
                                           'X'
                                        || cod_abi_cartolarizzato
                                        || SUBSTR (cod_ndg, 0, 14)
                                     ELSE
                                        'SP' || LPAD (cod_sndg, 18, '0')
                                  END
                                     cod_gruppo_super_1
                             FROM t_mcre0_day_fg) f,
                          (SELECT NVL (
                                     (SELECT '1' today_flg
                                        FROM t_mcre0_day_mopl u
                                       WHERE     u.cod_abi_cartolarizzato =
                                                    mo.cod_abi_cartolarizzato
                                             AND u.cod_ndg = mo.cod_ndg),
                                     '0')
                                     today_flg,
                                  mo.id_dper AS id_dpermo,
                                  mo.*,
                                  c.*
                             FROM t_mcre0_dwh_mopl mo, --uso storica per quadrature flussi
                                  t_mcre0_day_fg fg,
                                  t_mcre0_cl_trascinamenti c
                            WHERE     mo.cod_ramo_host = c.cod_ramo(+)
                                  AND fg.cod_abi_cartolarizzato =
                                         mo.cod_abi_cartolarizzato(+)
                                  AND fg.cod_ndg = mo.cod_ndg(+)) m
                    WHERE     f.cod_abi_cartolarizzato =
                                 m.cod_abi_cartolarizzato(+)
                          AND f.cod_ndg = m.cod_ndg(+)) a);


GRANT SELECT ON MCRE_OWN.V_MCRE0_DAY_FG_MOPL TO MCRE_USR;
