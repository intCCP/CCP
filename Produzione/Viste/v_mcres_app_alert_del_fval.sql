/* Formatted on 17/06/2014 18:09:18 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_FVAL
(
   ID_ALERT,
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COGNOME,
   NOME,
   COD_PROTOCOLLO_DELIBERA,
   DTA_INSERIMENTO_DELIBERA,
   COD_DELIBERA,
   DESC_DELIBERA,
   COD_STATO_DELIBERA,
   DESC_STATO_DELIBERA,
   COD_ORGANO_DELIBERANTE,
   COD_MATR_INSERENTE,
   FLG_PVISIONE_GESTORE,
   FLG_PVISIONE_PRESIDIO,
   ALERT,
   DESC_ORGANO_DELIBERANTE,
   VAL_GBV,
   DTA_DELIBERA,
   DTA_AGGIORNAMENTO_DELIBERA,
   COD_UO,
   DTA_CONFERMA,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO,
   ID_OBJECT_AL_AN
)
AS
   SELECT                                                    --VG 20140305 New
          --AP20140519 Modifiche secondo Upgrade delibere e spese 23/01/2014
          A."ID_ALERT",
          A."COD_ABI",
          A."DESC_ISTITUTO",
          A."COD_NDG",
          A."COD_SNDG",
          A."DESC_NOME_CONTROPARTE",
          A."COD_UO_PRATICA",
          A."COD_MATR_PRATICA",
          A."COGNOME",
          A."NOME",
          A."COD_PROTOCOLLO_DELIBERA",
          A."DTA_INSERIMENTO_DELIBERA",
          A."COD_DELIBERA",
          A."DESC_DELIBERA",
          A."COD_STATO_DELIBERA",
          A."DESC_STATO_DELIBERA",
          A."COD_ORGANO_DELIBERANTE",
          A."COD_MATR_INSERENTE",
          a.FLG_PVISIONE_GESTORE,
          a.FLG_PVISIONE_PRESIDIO,
          A."ALERT",
          A."DESC_ORGANO_DELIBERANTE",
          A."VAL_GBV",
          A."DTA_DELIBERA",
          A."DTA_AGGIORNAMENTO_DELIBERA",
          A."COD_UO",
          A."DTA_CONFERMA",
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co,
          e.id_object AS id_object_al_an
     FROM (SELECT a.ID_ALERT,
                  a.COD_ABI,
                  a.DESC_ISTITUTO,
                  a.COD_NDG,
                  a.COD_SNDG,
                  a.DESC_NOME_CONTROPARTE,
                  a.COD_UO_PRATICA,
                  a.COD_MATR_PRATICA,
                  a.cognome,
                  a.nome,
                  a.COD_PROTOCOLLO_DELIBERA,
                  a.DTA_INSERIMENTO_DELIBERA,
                  a.COD_DELIBERA,
                  a.DESC_DELIBERA,
                  a.COD_STATO_DELIBERA,
                  a.DESC_STATO_DELIBERA,
                  a.COD_ORGANO_DELIBERANTE,
                  a.COD_MATR_INSERENTE,
                  FLG_PVISIONE_GESTORE,
                  FLG_PVISIONE_PRESIDIO,
                  a.ALERT,
                  OD.DESC_ORGANO_DELIBERANTE,
                  val_gbv,
                  dta_delibera,
                  a.dta_aggiornamento_delibera,
                  a.cod_uo,
                  dta_conferma
             FROM (SELECT 41 id_alert,
                          P.COD_ABI,
                          I.DESC_ISTITUTO,
                          p.cod_ndg,
                          Z.COD_SNDG,
                          a.DESC_NOME_CONTROPARTE,
                          P.COD_UO_PRATICA,
                          P.COD_MATR_PRATICA,
                          u.cognome,
                          u.nome,
                          S.COD_PROTOCOLLO_DELIBERA,
                          S.DTA_INSERIMENTO_DELIBERA,
                          S.DTA_AGGIORNAMENTO_DELIBERA,
                          s.DTA_CONFERMA,
                          S.COD_DELIBERA,
                          D.DESC_DELIBERA,
                          S.COD_STATO_DELIBERA,
                          T.DESC_STATO_DELIBERA,
                          S.COD_ORGANO_DELIBERANTE,
                          S.COD_MATR_INS COD_MATR_INSERENTE,
                          NVL (S.FLG_PVISIONE_GESTORE, 'N')
                             FLG_PVISIONE_GESTORE,
                          NVL (FLG_PVISIONE_PRESIDIO, 'N')
                             FLG_PVISIONE_PRESIDIO,
                          CASE
                             --WHEN TRUNC (SYSDATE) - TRUNC (dta_conferma) <=
                             WHEN TRUNC (SYSDATE) - TRUNC (dta_delibera) <=
                                     g.val_current_green
                             THEN
                                'V'
                             --WHEN TRUNC (SYSDATE) - TRUNC (dta_conferma) BETWEEN   g.val_current_green
                             WHEN TRUNC (SYSDATE) - TRUNC (dta_delibera) BETWEEN   g.val_current_green
                                                                                 + 1
                                                                             AND g.val_current_orange
                             THEN
                                'A'
                             -- WHEN TRUNC (SYSDATE) - TRUNC (dta_conferma) >
                             WHEN TRUNC (SYSDATE) - TRUNC (dta_delibera) >
                                     g.val_current_orange
                             THEN
                                'R'
                             ELSE
                                'X'
                          END
                             ALERT,
                          val_gbv,
                          dta_delibera,
                          S.COD_UO
                     FROM T_MCRES_APP_PRATICHE P,
                          T_MCRES_APP_POSIZIONI Z,
                          T_MCRES_APP_DELIBERE S,
                          T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                          T_MCRES_APP_ISTITUTI I,
                          T_MCRES_CL_TIPO_DELIBERA D,
                          T_MCRES_CL_STATO_DELIBERA T,
                          t_mcres_app_utenti u,
                          (  SELECT cod_abi,
                                    cod_ndg,
                                    SUM (-val_imp_gbv) val_gbv
                               FROM t_mcres_app_rapporti
                              WHERE     0 = 0
                                    AND dta_chiusura_rapp =
                                           TO_DATE ('99991231', 'yyyymmdd')
                           GROUP BY cod_abi, cod_ndg) r,
                          t_mcres_app_gestione_alert g
                    WHERE     P.FLG_ATTIVA = 1
                          AND Z.FLG_ATTIVA = 1
                          AND g.id_alert = 41
                          AND P.COD_ABI = Z.COD_ABI
                          AND P.COD_NDG = Z.COD_NDG
                          AND Z.COD_SNDG = A.COD_SNDG(+)
                          AND S.COD_DELIBERA = D.COD_DELIBERA(+)
                          AND s.cod_abi = d.cod_abi(+)
                          AND D.FLG_FORFETARIA(+) = 'S'
                          AND S.COD_STATO_DELIBERA = T.COD_STATO_DELIBERA(+)
                          AND P.COD_MATR_PRATICA IS NOT NULL
                          AND P.COD_ABI = S.COD_ABI
                          AND P.COD_NDG = S.COD_NDG
                          AND P.COD_PRATICA = S.COD_PRATICA
                          AND P.VAL_ANNO = S.VAL_ANNO_PRATICA
                          AND p.cod_matr_pratica = u.cod_matricola(+)
                          AND S.COD_STATO_DELIBERA = 'CO'
                          --AND S.COD_DELIBERA IN ('NZ', 'FZ')
                          AND S.COD_DELIBERA = 'NZ'
                          AND (   NVL (S.FLG_PVISIONE_GESTORE, 'N') != 'S'
                               OR NVL (FLG_PVISIONE_PRESIDIO, 'N') != 'S')
                          AND S.DTA_INSERIMENTO_DELIBERA >=
                                 TO_DATE ('20140101', 'YYYYMMDD')
                          AND s.cod_abi = i.cod_abi(+)
                          AND s.cod_abi = r.cod_abi(+)
                          AND s.cod_ndg = r.cod_ndg(+)
                          AND COALESCE (s.DTA_INSERIMENTO_DELIBERA,
                                        s.DTA_DELIBERA,
                                        s.DTA_AGGIORNAMENTO_DELIBERA) >=
                                 z.DTA_PASSAGGIO_SOFF
                          AND S.COD_STATO_RISCHIO = 'S') a,
                  T_MCRES_CL_ORGANO_DELIBERANTE OD
            WHERE     a.COD_ORGANO_DELIBERANTE = OD.COD_ORGANO_DELIBERANTE(+)
                  AND a.COD_ABI = OD.COD_ABI(+)
                  AND a.COD_UO_PRATICA = OD.COD_UO(+)
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
          --AP 29/07/2013
          LEFT JOIN
          t_mcres_app_documenti E
             ON (    a.cod_protocollo_delibera = e.cod_Aut_protoc
                 AND e.cod_tipo_documento = 'AL'
                 AND e.cod_stato = 'AN');


GRANT SELECT ON MCRE_OWN.V_MCRES_APP_ALERT_DEL_FVAL TO MCRE_USR;
