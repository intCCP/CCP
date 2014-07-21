/* Formatted on 21/07/2014 18:41:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_DA_RDRC
(
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
   COD_FILIALE_PRINCIPALE,
   DESC_ORGANO_DELIBERANTE,
   VAL_CATEGORIA,
   DESC_RESPONSABILE,
   COD_OD_CALCOLATO,
   DESC_OD_CALCOLATO,
   DTA_INOLTRO,
   VAL_GBV,
   COD_TIPO_GESTIONE,
   ALERT,
   DTA_DELIBERA,
   DTA_AGGIORNAMENTO_DELIBERA,
   COD_STATO_RISCHIO,
   ALERT30,
   ALERT31,
   DESC_UO,
   COD_UO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT A."COD_ABI",
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
          A."COD_FILIALE_PRINCIPALE",
          A."DESC_ORGANO_DELIBERANTE",
          A."VAL_CATEGORIA",
          A."DESC_RESPONSABILE",
          A."COD_OD_CALCOLATO",
          A."DESC_OD_CALCOLATO",
          A."DTA_INOLTRO",
          A."VAL_GBV",
          A."COD_TIPO_GESTIONE",
          A."ALERT",
          A."DTA_DELIBERA",
          A."DTA_AGGIORNAMENTO_DELIBERA",
          A."COD_STATO_RISCHIO",
          A."ALERT30",
          A."ALERT31",
          A."DESC_UO",
          A."COD_UO",
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co
     FROM (SELECT              --  20120914    AG  Join con t_mcres_app_utenti
                                  --  20130315    AG Esposizione campo desc_uo
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
                 a.COD_FILIALE_PRINCIPALE,
                 OD1.DESC_ORGANO_DELIBERANTE,
                 OD1.VAL_CATEGORIA,
                 OD1.DESC_RESPONSABILE,
                 a.cod_od_calcolato,
                 od2.desc_organo_deliberante desc_od_calcolato,
                 dta_inoltro,
                 val_gbv,
                 cod_tipo_gestione,
                 alert,
                 dta_delibera,
                 a.dta_aggiornamento_delibera,
                 cod_stato_rischio,
                 alert30,
                 alert31,
                 desc_uo,
                 a.cod_uo
            FROM (SELECT P.COD_ABI,
                         I.DESC_ISTITUTO,
                         P.COD_NDG,
                         Z.COD_SNDG,
                         a.DESC_NOME_CONTROPARTE,
                         P.COD_UO_PRATICA,
                         P.COD_MATR_PRATICA,
                         S.COD_PROTOCOLLO_DELIBERA,
                         S.DTA_INSERIMENTO_DELIBERA,
                         S.DTA_AGGIORNAMENTO_DELIBERA,
                         S.COD_DELIBERA,
                         D.DESC_DELIBERA,
                         S.COD_STATO_DELIBERA,
                         T.DESC_STATO_DELIBERA,
                         S.COD_ORGANO_DELIBERANTE,
                         NULL COD_MATR_INSERENTE,
                         z.COD_FILIALE_PRINCIPALE,
                         r.val_gbv,
                         s.dta_inoltro,
                         s.cod_od_calcolato,
                         u.cognome,
                         u.nome,
                         so.desc_struttura_competente desc_uo,
                         CASE
                            WHEN so.cod_livello IN ('PL', 'RC') THEN 'I'
                            WHEN so.cod_livello IN ('IP', 'IC') THEN 'E'
                         END
                            cod_tipo_gestione,
                         CASE
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) <= 7
                            THEN
                               'V'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) BETWEEN 8
                                                                           AND 30
                            THEN
                               'A'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) > 30
                            THEN
                               'R'
                            ELSE
                               'X'
                         END
                            ALERT,
                         --AP 23/11/2012
                         dta_delibera,
                         s.cod_stato_rischio,
                         CASE
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) <=
                                    gest30.val_current_green
                            THEN
                               'V'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) BETWEEN   gest30.val_current_green
                                                                               + 1
                                                                           AND gest30.val_current_orange
                            THEN
                               'A'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) >
                                    gest30.val_current_orange
                            THEN
                               'R'
                            ELSE
                               'X'
                         END
                            ALERT30,
                         CASE
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) <=
                                    gest31.val_current_green
                            THEN
                               'V'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) BETWEEN   gest31.val_current_green
                                                                               + 1
                                                                           AND gest31.val_current_orange
                            THEN
                               'A'
                            WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) >
                                    gest31.val_current_orange
                            THEN
                               'R'
                            ELSE
                               'X'
                         END
                            ALERT31,
                         s.cod_uo
                    FROM T_MCRES_APP_PRATICHE P,
                         T_MCRES_APP_POSIZIONI Z,
                         T_MCRES_APP_DELIBERE S,
                         T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                         T_MCRES_APP_GESTIONE_ALERT gest30,
                         T_MCRES_APP_GESTIONE_ALERT gest31,
                         T_MCRES_APP_ISTITUTI I,
                         (  SELECT cod_abi,
                                   cod_delibera,
                                   MAX (desc_delibera) desc_delibera
                              FROM t_mcres_cl_tipo_delibera
                             WHERE dta_scadenza > SYSDATE
                          GROUP BY cod_abi, cod_delibera) D,
                         T_MCRES_CL_STATO_DELIBERA T,
                         t_mcre0_app_struttura_org so,
                         (  SELECT cod_abi, cod_ndg, SUM (-val_imp_gbv) val_gbv
                              FROM t_mcres_app_rapporti
                             WHERE dta_chiusura_rapp > SYSDATE
                          GROUP BY cod_abi, cod_ndg) r,
                         t_mcres_app_utenti u
                   WHERE     P.FLG_ATTIVA = 1
                         AND Z.FLG_ATTIVA = 1
                         AND gest30.id_alert = 30
                         AND gest31.id_alert = 31
                         AND P.COD_ABI = z.COD_ABI
                         AND P.COD_NDG = Z.COD_NDG
                         AND Z.COD_SNDG = A.COD_SNDG(+)
                         AND P.COD_ABI = I.COD_ABI
                         AND S.COD_DELIBERA = D.COD_DELIBERA(+)
                         AND s.cod_abi = d.cod_abi(+)
                         AND S.COD_STATO_DELIBERA = T.COD_STATO_DELIBERA(+)
                         AND P.COD_MATR_PRATICA IS NOT NULL
                         AND P.COD_ABI = S.COD_ABI
                         AND P.COD_NDG = S.COD_NDG
                         AND P.COD_PRATICA = S.COD_PRATICA
                         AND P.VAL_ANNO = S.VAL_ANNO_PRATICA
                         AND p.cod_abi = r.cod_abi(+)
                         AND p.cod_ndg = r.cod_ndg(+)
                         AND p.cod_abi = so.cod_abi_istituto(+)
                         AND p.cod_uo_pratica = so.cod_struttura_competente(+)
                         AND p.cod_matr_pratica = u.cod_matricola(+)
                         AND S.COD_STATO_DELIBERA = 'TX'
                         AND COALESCE (s.DTA_INSERIMENTO_DELIBERA,
                                       s.DTA_DELIBERA,
                                       s.DTA_AGGIORNAMENTO_DELIBERA) >=
                                z.DTA_PASSAGGIO_SOFF
                         AND s.cod_stato_rischio = 'S') a,
                 T_MCRES_CL_ORGANO_DELIBERANTE OD1,
                 t_mcres_cl_organo_deliberante od2
           WHERE     0 = 0
                 AND a.COD_ORGANO_DELIBERANTE = OD1.COD_ORGANO_DELIBERANTE(+)
                 AND a.COD_ABI = OD1.COD_ABI(+)
                 AND SUBSTR (a.cod_protocollo_delibera, -5) = od1.cod_uo(+)
                 AND TO_DATE ('99991231', 'YYYYMMDD') = Od1.DTA_SCADENZA(+)
                 AND a.COD_od_calcolato = OD2.COD_ORGANO_DELIBERANTE(+)
                 AND a.COD_ABI = OD2.COD_ABI(+)
                 AND TO_DATE ('99991231', 'YYYYMMDD') = Od2.DTA_SCADENZA(+)) A
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
                 AND d.cod_stato = 'CO');
