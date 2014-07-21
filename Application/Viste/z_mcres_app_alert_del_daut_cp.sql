/* Formatted on 21/07/2014 18:47:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.Z_MCRES_APP_ALERT_DEL_DAUT_CP
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COGNOME,
   NOME,
   COD_PRATICA,
   VAL_ANNO_PRATICA,
   DESC_NOME_CONTROPARTE,
   COD_PROTOCOLLO_DELIBERA,
   COD_DELIBERA,
   DESC_DELIBERA,
   DTA_INOLTRO,
   COD_STATO_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   COD_OD_CALCOLATO,
   DESC_OD_CALCOLATO,
   VAL_GBV,
   VAL_SEMAFORO
)
AS
   SELECT a.cod_abi,
          a.cod_ndg,
          a.cod_sndg,
          a.cod_uo_pratica,
          a.cod_matr_pratica,
          a.cognome,
          a.nome,
          a.cod_pratica,
          a.val_anno_pratica,
          a.desc_nome_controparte,
          a.cod_protocollo_delibera,
          a.cod_delibera,
          a.desc_delibera,
          a.dta_inoltro,
          a.cod_stato_delibera,
          a.cod_organo_deliberante,
          od1.desc_organo_deliberante,
          a.cod_od_calcolato,
          od2.desc_organo_deliberante desc_od_calcolato,
          a.val_gbv,
          'V' val_semaforo
     FROM (SELECT d.cod_abi,
                  d.cod_ndg,
                  d.cod_sndg,
                  p.cod_uo_pratica,
                  p.cod_matr_pratica,
                  u.cognome,
                  u.nome,
                  d.cod_pratica,
                  d.val_anno_pratica,
                  a.desc_nome_controparte,
                  d.cod_protocollo_delibera,
                  d.cod_delibera,
                  td.desc_delibera,
                  d.dta_inoltro,
                  d.cod_stato_delibera,
                  d.cod_organo_deliberante,
                  d.cod_od_calcolato,
                  r.val_gbv
             FROM t_mcres_app_delibere d,
                  t_mcres_app_pratiche p,
                  t_mcre0_app_anagrafica_gruppo a,
                  t_mcres_app_utenti u,
                  (  SELECT cod_abi, cod_ndg, SUM (-val_imp_gbv) val_gbv
                       FROM t_mcres_app_rapporti
                      WHERE dta_chiusura_rapp > SYSDATE
                   GROUP BY cod_abi, cod_ndg) r,
                  (  SELECT cod_abi,
                            cod_delibera,
                            MAX (desc_delibera) desc_delibera
                       FROM t_mcres_cl_tipo_delibera
                   GROUP BY cod_abi, cod_delibera) td
            WHERE     0 = 0
                  AND p.flg_attiva = 1
                  AND d.cod_abi = p.cod_abi
                  AND d.cod_ndg = p.cod_ndg
                  AND d.val_anno_pratica = p.val_anno
                  AND d.cod_pratica = p.cod_pratica
                  AND d.cod_sndg = a.cod_sndg(+)
                  AND p.cod_matr_pratica = u.cod_matricola(+)
                  AND d.cod_abi = r.cod_abi(+)
                  AND d.cod_ndg = r.cod_ndg(+)
                  AND d.cod_abi = td.cod_abi(+)
                  AND d.cod_delibera = td.cod_delibera(+)
                  ----
                  AND d.cod_stato_delibera = 'IT'
                  AND EXISTS
                         (SELECT 1
                            FROM t_mcres_app_delibere d2
                           WHERE     0 = 0
                                 AND d2.cod_abi = d.cod_abi
                                 AND d2.cod_ndg = d.cod_ndg
                                 AND d2.cod_protocollo_delibera_coll =
                                        d.cod_protocollo_delibera
                                 AND d2.cod_stato_delibera = 'TR')) a,
          t_mcres_cl_organo_deliberante od1,
          t_mcres_cl_organo_deliberante od2
    WHERE     0 = 0
          AND a.cod_abi = od1.cod_abi(+)
          AND a.cod_uo_pratica = od1.cod_uo(+)
          AND a.cod_organo_deliberante = od1.cod_organo_deliberante(+)
          AND SYSDATE BETWEEN od1.dta_inizio(+) AND od1.dta_scadenza(+)
          AND a.cod_abi = od2.cod_abi(+)
          AND a.cod_uo_pratica = od2.cod_uo(+)
          AND a.cod_od_calcolato = od2.cod_organo_deliberante(+)
          AND SYSDATE BETWEEN od2.dta_inizio(+) AND od2.dta_scadenza(+);
