/* Formatted on 17/06/2014 18:09:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_IN_LAV
(
   ID_ALERT,
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANNO_PRATICA,
   COD_PRATICA,
   COD_UO_PRATICA,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   COD_MATR_PRATICA,
   COGNOME_GESTORE,
   NOME_GESTORE,
   COD_PROTOCOLLO_DELIBERA,
   COD_DELIBERA,
   DESC_DELIBERA,
   VAL_GBV,
   DTA_AGGIORNAMENTO_DELIBERA,
   DTA_INSERIMENTO_DELIBERA,
   ALERT,
   FLG_CONFERIMENTO,
   DTA_DELIBERA,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT                                                     -- AP 09/11/2012
 -- AG 29/11/2012    Added filter substr(d.cod_protocollo_delibera, -5) not in ('02440', '06472')
                                        -- VG 03/12/2012 - Escluse delibere RW
                                                 -- VG 20130710 - hint ordered
        A.*, c.id_object AS id_object_al_tr, d.id_object AS id_object_al_co
   FROM (SELECT                               -- 20120718 AG Created this view
                -- 20120719 AG valorizzazione GBV
                -- 20120726 AG added cod_sndg
                -- 20120924 AG added flg_conferimento
                14 id_alert,
                v.cod_abi,
                desc_istituto,
                cod_ndg,
                cod_sndg,
                desc_nome_controparte,
                val_anno_pratica,
                cod_pratica,
                cod_uo_pratica,
                v.cod_organo_deliberante,
                desc_organo_deliberante,
                cod_matr_pratica,
                cognome_gestore,
                nome_gestore,
                cod_protocollo_delibera,
                cod_delibera,
                desc_delibera,
                val_gbv,
                dta_aggiornamento_delibera,
                dta_inserimento_delibera,
                alert,
                flg_conferimento,
                --AP 23/11/2012
                dta_delibera
           FROM (SELECT /*+ ordered */
                       d.cod_abi,
                        i.desc_istituto,
                        d.cod_ndg,
                        d.cod_sndg,
                        a.desc_nome_controparte,
                        d.val_anno_pratica,
                        d.cod_pratica,
                        p.cod_uo_pratica,
                        d.cod_organo_deliberante,
                        p.cod_matr_pratica,
                        u.cognome cognome_gestore,
                        u.nome nome_gestore,
                        d.cod_protocollo_delibera,
                        d.cod_delibera,
                        t.desc_delibera,
                        (SELECT -SUM (val_imp_gbv) val_gbv
                           FROM t_mcres_app_rapporti r
                          WHERE     0 = 0
                                AND dta_chiusura_rapp =
                                       TO_DATE ('99991231', 'yyyymmdd')
                                AND r.cod_abi = p.cod_abi
                                AND r.cod_ndg = p.cod_ndg)
                           val_gbv,
                        dta_aggiornamento_delibera,
                        dta_inserimento_delibera,
                        CASE
                           WHEN   TRUNC (SYSDATE)
                                - TRUNC (dta_inserimento_delibera) <=
                                   g.val_current_green
                           THEN
                              'V'
                           WHEN   TRUNC (SYSDATE)
                                - TRUNC (dta_inserimento_delibera) BETWEEN   g.val_current_green
                                                                           + 1
                                                                       AND g.val_current_orange
                           THEN
                              'A'
                           WHEN   TRUNC (SYSDATE)
                                - TRUNC (dta_inserimento_delibera) >
                                   g.val_current_orange
                           THEN
                              'R'
                           ELSE
                              'X'
                        END
                           alert,
                        NVL (
                           (SELECT DISTINCT 1
                              FROM v_mcres_app_conferimento_nt n
                             WHERE     n.cod_abi = p.cod_abi
                                   AND n.cod_ndg = p.cod_ndg),
                           0)
                           flg_conferimento,
                        --AP 23/11/2012
                        dta_delibera
                   FROM t_mcres_app_pratiche p,
                        t_mcres_app_delibere d,
                        t_mcres_app_istituti i,
                        t_mcre0_app_anagrafica_gruppo a,
                        t_mcres_app_utenti u,
                        (  SELECT cod_delibera,
                                  MAX (desc_delibera) desc_delibera
                             FROM t_mcres_cl_tipo_delibera
                         GROUP BY cod_delibera) t,
                        t_mcres_app_gestione_alert g
                  WHERE     0 = 0
                        AND g.id_alert = 14
                        AND p.flg_attiva = 1
                        AND p.cod_abi = d.cod_abi
                        AND p.cod_ndg = d.cod_ndg
                        AND p.val_anno = d.val_anno_pratica
                        AND p.cod_pratica = d.cod_pratica
                        AND d.cod_abi = i.cod_abi
                        AND d.cod_sndg = a.cod_sndg(+)
                        AND p.cod_matr_pratica = u.cod_matricola(+)
                        AND d.cod_delibera = t.cod_delibera(+)
                        AND d.cod_delibera != 'RW'
                        --
                        -- filtri specifici per tipologia alert
                        --
                        AND cod_stato_delibera = 'IN'
                        AND SUBSTR (d.cod_protocollo_delibera, -5) NOT IN
                               ('02440', '06472')
                        AND d.cod_stato_rischio = 'S') v,
                t_mcres_cl_organo_deliberante o
          WHERE     0 = 0
                AND v.cod_abi = o.cod_abi(+)
                AND v.cod_organo_deliberante = o.cod_organo_deliberante(+)
                AND v.cod_uo_pratica = o.cod_uo(+)
                AND TO_DATE (99991231, 'yyyymmdd') = o.dta_scadenza(+)) A
        --AP 16/11/2012
        LEFT JOIN
        t_mcres_app_delibere coll_tr
           ON (    coll_tr.cod_abi = a.cod_abi
               AND coll_tr.cod_protocollo_delibera_coll =
                      a.cod_protocollo_delibera
               AND coll_tr.cod_stato_Delibera = 'TR')
        LEFT JOIN
        t_mcres_app_documenti C
           ON (    CASE
                      WHEN (coll_tr.cod_protocollo_delibera IS NOT NULL)
                      THEN
                         coll_tr.cod_protocollo_delibera
                      ELSE
                         a.cod_protocollo_delibera
                   END = c.cod_Aut_protoc
               AND c.cod_tipo_documento = 'AL'
               AND c.cod_stato = 'TR')
        LEFT JOIN
        t_mcres_app_documenti D
           ON (    a.cod_protocollo_delibera = d.cod_Aut_protoc
               AND d.cod_tipo_documento = 'AL'
               AND d.cod_stato = 'CO')
        --AP 23/11/2012
        --JOIN t_mcres_app_posizioni POS ON (POS.COD_ABI = A.COD_ABI AND POS.COD_NDG = A.COD_NDG AND POS.FLG_ATTIVA = 1 AND NVL(A.DTA_DELIBERA,SYSDATE) >= POS.DTA_PASSAGGIO_SOFF)
        --AP 11/01/2013
        JOIN
        t_mcres_app_posizioni POS
           ON (    POS.COD_ABI = A.COD_ABI
               AND POS.COD_NDG = A.COD_NDG
               AND POS.FLG_ATTIVA = 1
               AND COALESCE (A.DTA_INSERIMENTO_DELIBERA,
                             A.DTA_DELIBERA,
                             A.DTA_AGGIORNAMENTO_DELIBERA) >=
                      POS.DTA_PASSAGGIO_SOFF);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_DEL_IN_LAV TO MCRE_USR;
