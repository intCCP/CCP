/* Formatted on 17/06/2014 18:09:22 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_INA_TR
(
   ID_ALERT,
   COD_ABI,
   COD_NDG,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_PROTOCOLLO_DELIBERA,
   DTA_INSERIMENTO_DELIBERA,
   ALERT,
   DESC_NOME_CONTROPARTE,
   COD_FILIALE_PRINCIPALE,
   COD_STATO_DELIBERA,
   DESC_STATO_DELIBERA,
   DTA_DELIBERA,
   COD_MATR_INSERENTE,
   COD_DELIBERA,
   DESC_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   DESC_ORGANO_DELIBERANTE,
   VAL_GBV,
   DTA_INOLTRO,
   DTA_TRASFERIMENTO,
   COD_OD_CALCOLATO,
   COGNOME,
   NOME,
   DESC_ISTITUTO,
   DTA_AGGIORNAMENTO_DELIBERA,
   ALERT_TRASFERIMENTO28,
   ALERT_TRASFERIMENTO34,
   COD_TIPO_GESTIONE,
   DESC_PRESIDIO,
   COD_UO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT                                                     -- AP 09/11/2012
                                        -- VG 03/12/2012 - Escluse delibere RW
            -- AG 15/03/2013 - Modifica join con T_MCRES_CL_ORGANO_DELIBERANTE
                                -- AG 18/03/2013 - Esposto campo desc_presidio
                                    -- VG 19/07/2013 - Aggiunta colonna cod_uo
        A.*, c.id_object AS id_object_al_tr, d.id_object AS id_object_al_co
   FROM (SELECT -- 20120723 AG  Aggiunti nuovi campi e abi ndg nalla condizione di esistenza
 -- 20120904 AG  Modificata where per filtrare delibere 2440 e aggiunta join per recupero data trasferimento
                                        -- 20120910 AG  Fix delibera collegata
                                     -- 20120914 AG  Join t_mcres_app_istituti
               a.ID_ALERT,
               a.COD_ABI,
               a.COD_NDG,
               a.COD_UO_PRATICA,
               a.COD_MATR_PRATICA,
               a.COD_PROTOCOLLO_DELIBERA,
               a.DTA_INSERIMENTO_DELIBERA,
               a.ALERT,
               a.DESC_NOME_CONTROPARTE,
               a.COD_FILIALE_PRINCIPALE,
               a.COD_STATO_DELIBERA,
               a.DESC_STATO_DELIBERA,
               a.DTA_DELIBERA,
               a.COD_MATR_INSERENTE,
               a.COD_DELIBERA,
               a.DESC_DELIBERA,
               a.COD_ORGANO_DELIBERANTE,
               OD.DESC_ORGANO_DELIBERANTE,
               val_gbv,
               dta_inoltro,
               dta_trasferimento,
               cod_od_calcolato,
               cognome,
               nome,
               desc_istituto,
               a.dta_aggiornamento_delibera,
               -- AP 04/02/2013
               a.alert_trasferimento28,
               a.alert_trasferimento34,
               a.cod_tipo_gestione,
               a.desc_presidio,
               a.cod_uo
          FROM (SELECT 11 id_alert,
                       p.cod_abi,
                       p.cod_ndg,
                       P.COD_UO_PRATICA,
                       P.COD_MATR_PRATICA,
                       de.COD_PROTOCOLLO_DELIBERA,
                       de.DTA_INSERIMENTO_DELIBERA,
                       'V' ALERT,
                       G.DESC_NOME_CONTROPARTE,
                       z.COD_FILIALE_PRINCIPALE,
                       DE.COD_STATO_DELIBERA,
                       d.DESC_STATO_DELIBERA,
                       TO_DATE (NULL, 'YYYYMMDD') dta_delibera,
                       DE.COD_MATR_INS COD_MATR_INSERENTE,
                       DE.COD_DELIBERA,
                       td.DESC_DELIBERA,
                       DE.COD_ORGANO_DELIBERANTE,
                       val_gbv,
                       de.dta_inoltro,
                       de2.dta_trasferimento,
                       de.cod_od_calcolato,
                       u.cognome,
                       u.nome,
                       i.desc_istituto,
                       de.dta_aggiornamento_delibera,
                       CASE
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) <=
                                  gest28.val_current_green
                          THEN
                             'V'
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) BETWEEN   gest28.val_current_green
                                                                                      + 1
                                                                                  AND gest28.val_current_orange
                          THEN
                             'A'
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) >
                                  gest28.val_current_green
                          THEN
                             'R'
                          ELSE
                             'X'
                       END
                          AS alert_trasferimento28,
                       CASE
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) <=
                                  gest34.val_current_green
                          THEN
                             'V'
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) BETWEEN   gest34.val_current_green
                                                                                      + 1
                                                                                  AND gest34.val_current_orange
                          THEN
                             'A'
                          WHEN TRUNC (SYSDATE) - TRUNC (de.dta_trasferimento) >
                                  gest34.val_current_green
                          THEN
                             'R'
                          ELSE
                             'X'
                       END
                          AS alert_trasferimento34,
                       CASE
                          WHEN so.cod_livello IN ('PL', 'RC') THEN 'I'
                          WHEN so.cod_livello IN ('IP', 'IC') THEN 'E'
                       END
                          cod_tipo_gestione,
                       SO.DESC_STRUTTURA_COMPETENTE desc_presidio,
                       de.cod_uo
                  FROM T_MCRES_APP_PRATICHE P,
                       T_MCRES_APP_POSIZIONI Z,
                       T_MCRES_APP_delibere de,
                       t_mcres_app_delibere de2,
                       T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
                       T_MCRES_CL_STATO_DELIBERA D,
                       t_mcres_cl_tipo_delibera td,
                       t_mcres_app_utenti u,
                       t_mcres_app_istituti i,
                       --AP 01/03/2013
                       t_mcre0_app_struttura_org so,
                       --AP 20/02/2013
                       T_MCRES_APP_GESTIONE_ALERT gest28,
                       T_MCRES_APP_GESTIONE_ALERT gest34,
                       (  SELECT cod_abi, cod_ndg, SUM (-val_imp_gbv) val_gbv
                            FROM t_mcres_app_rapporti
                           WHERE dta_chiusura_rapp =
                                    TO_DATE ('99991231', 'yyyymmdd')
                        GROUP BY cod_abi, cod_ndg) r
                 WHERE     P.FLG_ATTIVA = 1
                       AND Z.FLG_ATTIVA = 1
                       AND gest28.id_alert = 28
                       AND gest34.id_alert = 34
                       AND P.COD_ABI = Z.COD_ABI
                       AND P.COD_NDG = Z.COD_NDG
                       AND P.COD_MATR_PRATICA IS NOT NULL
                       AND P.COD_ABI = DE.COD_ABI(+)
                       AND P.COD_NDG = DE.COD_NDG(+)
                       AND P.COD_PRATICA = DE.COD_PRATICA(+)
                       AND P.VAL_ANNO = DE.VAL_ANNO_PRATICA(+)
                       --                  --
                       AND p.cod_abi = so.cod_abi_istituto(+)
                       AND p.cod_uo_pratica = so.cod_struttura_competente(+)
                       AND de.cod_abi = de2.cod_abi
                       AND de.cod_ndg = de2.cod_ndg
                       AND de2.cod_protocollo_delibera_coll =
                              de.cod_protocollo_delibera
                       --                  --
                       AND DE.COD_STATO_DELIBERA = D.COD_STATO_DELIBERA(+)
                       AND DE.COD_DELIBERA = TD.COD_DELIBERA(+)
                       AND de.COD_ABI = TD.COD_ABI(+)
                       AND td.flg_forfetaria(+) = 'S'
                       AND Z.COD_SNDG = G.COD_SNDG(+)
                       --AP 04/02/2013
                       --AND de.COD_STATO_DELIBERA = 'IT'
                       AND de.COD_STATO_DELIBERA IN ('IT', 'TX')
                       --
                       --AP 04/02/2013 aggiunto anche RUI (06472)
                       --and substr(de.cod_protocollo_delibera, -5) = '02440'
                       AND SUBSTR (de.cod_protocollo_delibera, -5) IN
                              ('02440', '06472')
                       --
                       AND de.cod_abi = r.cod_abi(+)
                       AND de.cod_ndg = r.cod_ndg(+)
                       AND p.cod_matr_pratica = u.cod_matricola(+)
                       AND p.cod_abi = i.cod_abi(+)
                       AND de.cod_delibera != 'RW'
                       AND COALESCE (de.DTA_INSERIMENTO_DELIBERA,
                                     de.DTA_DELIBERA,
                                     de.DTA_AGGIORNAMENTO_DELIBERA) >=
                              z.DTA_PASSAGGIO_SOFF
                       AND de.cod_stato_rischio = 'S' --                  AND EXISTS
                                 --                         (SELECT DISTINCT 1
                     --                            FROM T_MCRES_APP_DELIBERE R
           --                           WHERE R.COD_PROTOCOLLO_DELIBERA_COLL =
              --                                    de.COD_PROTOCOLLO_DELIBERA
            --                                 AND R.COD_STATO_DELIBERA = 'TR'
                 --                                 and r.cod_abi = de.cod_abi
                 --                                 and r.cod_ndg= de.cod_ndg)
               ) a,
               T_MCRES_CL_ORGANO_DELIBERANTE OD
         WHERE     a.COD_ORGANO_DELIBERANTE = OD.COD_ORGANO_DELIBERANTE(+)
               AND a.COD_ABI = OD.COD_ABI(+)
               AND a.COD_UO = OD.COD_UO(+)                      -- ag 20130315
               AND TO_DATE ('99991231', 'YYYYMMDD') = Od.DTA_SCADENZA(+)) A
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
--        JOIN t_mcres_app_posizioni POS ON (POS.COD_ABI = A.COD_ABI AND POS.COD_NDG = A.COD_NDG AND POS.FLG_ATTIVA = 1 AND COALESCE(A.DTA_INSERIMENTO_DELIBERA, A.DTA_DELIBERA, A.DTA_AGGIORNAMENTO_DELIBERA) >= POS.DTA_PASSAGGIO_SOFF)
--
;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_DEL_INA_TR TO MCRE_USR;
