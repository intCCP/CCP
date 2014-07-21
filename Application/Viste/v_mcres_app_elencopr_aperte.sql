/* Formatted on 21/07/2014 18:42:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ELENCOPR_APERTE
(
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DTA_PASSAGGIO_SOFF,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   ANNO_PR,
   NUMERO_PR,
   INTESTAZIONE,
   VAL_PARTITA_IVA,
   VAL_GBV,
   VAL_NBV,
   ADDETTO,
   FILIALE_CAPOFILA,
   UO_COMPETENTE,
   DESC_PRESIDIO,
   DATA_APERTURA_PR,
   FLG_ART_498,
   FLG_GESTIONE,
   STATO_PC,
   COD_LIVELLO,
   FLG_FORFETTARIA,
   FLG_CONFERIMENTO,
   COD_STATO_GIURIDICO,
   FLG_SGR,
   DESC_STATO_PRECEDENTE,
   COD_STATO_RISCHIO,
   DESC_NOME_GESTORE,
   FLG_CORRELATO,
   FLG_CONNESSO,
   FLG_PRATICA_CEDUTA
)
AS
   SELECT                                    -- VG 20140624 flg_pratica_ceduta
         pr.cod_abi,
          (SELECT desc_istituto
             FROM t_mcres_app_istituti i
            WHERE i.cod_abi = pr.cod_abi)
             desc_istituto,
          pr.cod_ndg,
          po.cod_sndg,
          po.dta_passaggio_soff,
          ge.cod_gruppo_economico,
          gr.val_ana_gre,
          pr.val_anno AS anno_pr,
          pr.cod_pratica numero_pr,
          (SELECT angr.desc_nome_controparte
             FROM t_mcre0_app_anagrafica_gruppo angr
            WHERE angr.cod_sndg = po.cod_sndg)
             intestazione,
          (SELECT angr.VAL_PARTITA_IVA
             FROM t_mcre0_app_anagrafica_gruppo angr
            WHERE angr.cod_sndg = po.cod_sndg)
             VAL_PARTITA_IVA,
          (  SELECT SUM (-1 * RA.VAL_IMP_GBV) AS IMP_GBV
               FROM t_mcres_app_rapporti ra
              WHERE     ra.cod_abi = pr.cod_abi
                    AND ra.cod_ndg = pr.cod_ndg
                    AND ra.cod_ssa = 'MO'
           GROUP BY ra.cod_abi, ra.cod_ndg)
             AS VAL_GBV,
          (  SELECT SUM (-1 * ra.val_imp_nbv) AS imp_nbv
               FROM t_mcres_app_rapporti ra
              WHERE     ra.cod_abi = pr.cod_abi
                    AND ra.cod_ndg = pr.cod_ndg
                    AND ra.cod_ssa = 'MO'
           GROUP BY ra.cod_abi, ra.cod_ndg)
             AS val_nbv,
          PR.COD_MATR_PRATICA ADDETTO,
          po.COD_FILIALE_PRINCIPALE AS filiale_capofila,
          --pr.cod_uo_pratica filiale_capofila,
          pr.cod_uo_pratica AS uo_competente,
          p.desc_PRESIDIO,
          pr.dta_apertura AS data_apertura_pr,
          PO.FLG_ART_498,
          pr.FLG_GESTIONE,
          DECODE (PR.FLG_ATTIVA,  0, 'CHIUSA',  1, 'APERTA',  '-')
             AS STATO_PC,
          P.COD_LIVELLO,
          CASE
             WHEN SUBSTR (
                     (SELECT MAX (
                                   TO_CHAR (dta_aggiornamento_delibera,
                                            'YYYYMMDD')
                                || cod_delibera)
                        FROM t_mcres_app_delibere d
                       WHERE     0 = 0
                             AND cod_delibera NOT IN
                                    ('TT', 'TP', 'TS', 'SN', 'ES', 'RE')
                             AND cod_stato_delibera != 'AN'
                             AND d.cod_abi = pr.cod_abi
                             AND d.cod_ndg = pr.cod_ndg),
                     9,
                     2) IN
                     ('NZ', 'FZ')
             THEN
                1
             ELSE
                0
          END
             flg_forfettaria,
          NVL ( (SELECT DISTINCT 1
                   FROM v_mcres_app_conferimento_nt n
                  WHERE n.cod_abi = pr.cod_abi AND n.cod_ndg = pr.cod_ndg),
               0)
             flg_conferimento,
          po.cod_stato_giuridico,
          po.FLG_SGR_FONDI flg_sgr,
          (SELECT MAX (desc_microstato)
             FROM t_mcre0_app_percorsi p, t_mcre0_app_stati ss
            WHERE     p.cod_abi_cartolarizzato = po.cod_abi
                  AND p.cod_ndg = po.cod_ndg
                  AND p.cod_stato = po.COD_STATO_RISCHIO
                  AND p.dta_decorrenza_stato = po.dta_passaggio_soff
                  AND p.cod_stato_precedente = ss.cod_microstato)
             desc_stato_precedente,
          po.COD_STATO_RISCHIO,
          (SELECT U.COGNOME || ' ' || U.Nome
             FROM t_mcres_app_utenti u
            WHERE u.COD_MATRICOLA = pr.COD_MATR_PRATICA)
             Desc_Nome_Gestore,
          NVL (
             (SELECT DISTINCT 1
                FROM T_MCRES_APP_PARTI_CORR a
               WHERE     a.cod_abi = pr.cod_abi
                     AND a.COD_SNDG_CG_CONTROPARTE = po.cod_sndg),
             0)
             flg_correlato,
          NVL (
             (SELECT DISTINCT 1
                FROM T_MCRES_APP_PARTI_CORR a
               WHERE     a.cod_abi = pr.cod_abi
                     AND a.COD_SNDG_SOGG_CONNESSO = po.cod_sndg),
             0)
             flg_connesso,
          NVL (
             (SELECT DISTINCT 1
                FROM t_mcres_app_notizie n
               WHERE     n.cod_abi = pr.cod_abi
                     AND n.cod_ndg = pr.cod_ndg
                     AND cod_tipo_notizia IN ('04', '16', '60')),
             0)
             flg_pratica_ceduta
     FROM t_mcres_app_pratiche PARTITION (soff_pattive) pr,
          t_mcres_app_posizioni PARTITION (soff_pattive) po,
          t_mcre0_app_gruppo_economico ge,
          t_mcre0_app_anagr_gre gr,
          v_mcres_app_lista_presidi p
    WHERE     PR.COD_ABI = PO.COD_ABI
          AND PR.COD_NDG = PO.COD_NDG
          AND po.cod_sndg = ge.cod_sndg(+)
          AND GE.COD_GRUPPO_ECONOMICO = GR.COD_GRE(+)
          AND pr.COD_UO_PRATICA = p.COD_PRESIDIO(+);
