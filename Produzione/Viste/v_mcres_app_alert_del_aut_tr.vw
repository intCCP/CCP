/* Formatted on 17/06/2014 18:09:15 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_AUT_TR
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
   FLG_PRESA_VISIONE,
   ALERT,
   DESC_ORGANO_DELIBERANTE,
   VAL_GBV,
   DTA_INOLTRO,
   COD_OD_CALCOLATO,
   DTA_DELIBERA,
   DTA_AGGIORNAMENTO_DELIBERA,
   ALERT_CONFERMA_ANNULL29,
   ALERT_CONFERMA_ANNULL35,
   DTA_TRASFERIMENTO,
   COD_TIPO_GESTIONE,
   FLG_PRESA_VISIONE_ENTE_CENTR,
   COD_UO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO,
   ID_OBJECT_AL_AN
)
AS
   SELECT                                                     -- AP 09/11/2012
          -- VG 03/12/2012 - Escluse delibere RW
          A.*,
          c.id_object AS id_object_al_tr,
          d.id_object AS id_object_al_co,
          e.id_object AS id_object_al_an
     FROM (SELECT -- 20120723 AG  Aggiunti nuovi campi e abi ndg nella condizioni di esistenza
                                          -- 20120904 AG  Filtro delibere 2440
                                   -- 20120914 AG  Koin con t_mcres_app_utenti
                      -- VG 20131025 tolta condizione <60 gg (anomalia id 361)
                 a.ID_ALERT,
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
                 a.FLG_PRESA_VISIONE,
                 a.ALERT,
                 OD.DESC_ORGANO_DELIBERANTE,
                 val_gbv,
                 dta_inoltro,
                 cod_od_calcolato,
                 --AP 23/11/2012
                 dta_delibera,
                 a.dta_aggiornamento_delibera,
                 a.alert_conferma_Annull29,
                 a.alert_conferma_Annull35,
                 a.dta_trasferimento,
                 a.cod_tipo_gestione,
                 a.FLG_PRESA_VISIONE_ENTE_CENTR,
                 a.cod_uo
            FROM (SELECT 4 id_alert,
                         P.COD_ABI,
                         I.DESC_ISTITUTO,
                         P.COD_NDG,
                         Z.COD_SNDG,
                         a.DESC_NOME_CONTROPARTE,
                         P.COD_UO_PRATICA,
                         P.COD_MATR_PRATICA,
                         u.cognome,
                         u.nome,
                         S.COD_PROTOCOLLO_DELIBERA,
                         S.DTA_INSERIMENTO_DELIBERA,
                         S.DTA_AGGIORNAMENTO_DELIBERA,
                         S.COD_DELIBERA,
                         D.DESC_DELIBERA,
                         S.COD_STATO_DELIBERA,
                         T.DESC_STATO_DELIBERA,
                         S.COD_ORGANO_DELIBERANTE,
                         S.COD_MATR_INS COD_MATR_INSERENTE,
                         COALESCE (S.FLG_PVISIONE_PRESIDIO,
                                   S.FLG_PRESA_VISIONE,
                                   'N')
                            FLG_PRESA_VISIONE,
                         'V' ALERT,
                         val_gbv,
                         dta_inoltro,
                         cod_od_calcolato,
                         --AP 23/11/2012
                         dta_delibera,
                         -- AP 04/02/2013
                         DECODE (
                            s.cod_stato_delibera,
                            'CO', CASE
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) <=
                                             gest29.val_current_green
                                     THEN
                                        'V'
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) BETWEEN   gest29.val_current_green
                                                                                       + 1
                                                                                   AND gest29.val_current_orange
                                     THEN
                                        'A'
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) >
                                             gest29.val_current_orange
                                     THEN
                                        'R'
                                     ELSE
                                        'X'
                                  END,
                            CASE
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_delibera) <=
                                       gest29.val_current_green
                               THEN
                                  'V'
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_Delibera) BETWEEN   gest29.val_current_green
                                                                                  + 1
                                                                              AND gest29.val_current_orange
                               THEN
                                  'A'
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_delibera) >
                                       gest29.val_current_orange
                               THEN
                                  'R'
                               ELSE
                                  'X'
                            END)
                            AS alert_conferma_Annull29,
                         DECODE (
                            s.cod_stato_delibera,
                            'CO', CASE
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) <=
                                             gest35.val_current_green
                                     THEN
                                        'V'
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) BETWEEN   gest35.val_current_green
                                                                                       + 1
                                                                                   AND gest35.val_current_orange
                                     THEN
                                        'A'
                                     WHEN   TRUNC (SYSDATE)
                                          - TRUNC (s.DTA_INSERIMENTO_DELIBERA) >
                                             gest35.val_current_orange
                                     THEN
                                        'R'
                                     ELSE
                                        'X'
                                  END,
                            CASE
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_delibera) <=
                                       gest35.val_current_green
                               THEN
                                  'V'
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_Delibera) BETWEEN   gest35.val_current_green
                                                                                  + 1
                                                                              AND gest35.val_current_orange
                               THEN
                                  'A'
                               WHEN   TRUNC (SYSDATE)
                                    - TRUNC (s.dta_annullamento_delibera) >
                                       gest35.val_current_orange
                               THEN
                                  'R'
                               ELSE
                                  'X'
                            END)
                            AS alert_conferma_Annull35,
                         s.dta_trasferimento,
                         CASE
                            WHEN so.cod_livello IN ('PL', 'RC') THEN 'I'
                            WHEN so.cod_livello IN ('IP', 'IC') THEN 'E'
                         END
                            cod_tipo_gestione,
                         NVL (s.FLG_PVISIONE_ENTE_CENTR, 'N')
                            AS FLG_PRESA_VISIONE_ENTE_CENTR,
                         s.cod_uo
                    FROM T_MCRES_APP_PRATICHE P,
                         T_MCRES_APP_POSIZIONI Z,
                         T_MCRES_APP_DELIBERE S,
                         T_MCRE0_APP_ANAGRAFICA_GRUPPO A,
                         T_MCRES_APP_ISTITUTI I,
                         T_MCRES_CL_TIPO_DELIBERA D,
                         T_MCRES_CL_STATO_DELIBERA T,
                         V_MCRES_APP_LISTA_PRESIDI E,
                         t_mcres_app_utenti u,
                         -- AP 01/03/2013
                         T_MCRES_APP_GESTIONE_ALERT gest29,
                         T_MCRES_APP_GESTIONE_ALERT gest35,
                         t_mcre0_app_struttura_org so,
                         (  SELECT cod_abi, cod_ndg, SUM (-val_imp_gbv) val_gbv
                              FROM t_mcres_app_rapporti
                             WHERE     0 = 0
                                   AND dta_chiusura_rapp =
                                          TO_DATE (99991231, 'yyyymmdd')
                          GROUP BY cod_abi, cod_ndg) r
                   WHERE     P.FLG_ATTIVA = 1
                         AND Z.FLG_ATTIVA = 1
                         AND P.COD_ABI = z.COD_ABI
                         AND P.COD_NDG = Z.COD_NDG
                         AND Z.COD_SNDG = A.COD_SNDG(+)
                         AND P.COD_ABI = I.COD_ABI
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
                         -- AP 04/02/2013
                         --AND S.COD_STATO_DELIBERA                              = 'CO'
                         AND S.COD_STATO_DELIBERA IN ('CO', 'AN')
                         AND gest29.id_alert = 29
                         AND gest35.id_alert = 35
                         AND p.cod_abi = so.cod_abi_istituto(+)
                         AND p.cod_uo_pratica = so.cod_struttura_competente(+)
                         --
                         AND P.COD_UO_PRATICA = E.COD_PRESIDIO(+)
                         -- COMMENTATA LA PRESA VISIONE -- AP 01/03/2013
                         --AND NVL(S.FLG_PVISIONE_PRESIDIO,S.FLG_PRESA_VISIONE) != 'S'
                         --AND SUBSTR(S.COD_PROTOCOLLO_DELIBERA,LENGTH(S.COD_PROTOCOLLO_DELIBERA)-4,5) = E.COD_STR_ORG_SUP
                         --AP 04/02/2013
                         --and cod_protocollo_delibera like '%02440'
                         AND (   cod_protocollo_delibera LIKE '%02440'
                              OR cod_protocollo_delibera LIKE '%06472')
                         --
                         --        AND TRUNC (SYSDATE) - S.DTA_INSERIMENTO_DELIBERA <=   60
                         AND s.cod_abi = r.cod_abi(+)
                         AND s.cod_ndg = r.cod_ndg(+)
                         AND EXISTS
                                (SELECT DISTINCT 1
                                   FROM T_MCRES_APP_DELIBERE R
                                  WHERE     R.COD_PROTOCOLLO_DELIBERA_COLL =
                                               S.COD_PROTOCOLLO_DELIBERA
                                        AND r.cod_abi = s.cod_abi
                                        AND r.cod_ndg = s.cod_ndg
                                        AND R.COD_STATO_DELIBERA = 'TR')
                         AND s.cod_delibera != 'RW'
                         AND COALESCE (s.DTA_INSERIMENTO_DELIBERA,
                                       s.DTA_DELIBERA,
                                       s.DTA_AGGIORNAMENTO_DELIBERA) >=
                                z.DTA_PASSAGGIO_SOFF
                         AND s.cod_stato_rischio = 'S') a,
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
          -- AP 29/07/2013
          LEFT JOIN
          t_mcres_app_documenti E
             ON (    a.cod_protocollo_delibera = e.cod_Aut_protoc
                 AND e.cod_tipo_documento = 'AL'
                 AND e.cod_stato = 'AN')
--AP 23/11/2012
--JOIN t_mcres_app_posizioni POS ON (POS.COD_ABI = A.COD_ABI AND POS.COD_NDG = A.COD_NDG AND POS.FLG_ATTIVA = 1 AND NVL(A.DTA_DELIBERA,SYSDATE) >= POS.DTA_PASSAGGIO_SOFF)
--AP 11/01/2013
--JOIN t_mcres_app_posizioni POS ON (POS.COD_ABI = A.COD_ABI AND POS.COD_NDG = A.COD_NDG AND POS.FLG_ATTIVA = 1 AND COALESCE(A.DTA_INSERIMENTO_DELIBERA, A.DTA_DELIBERA, A.DTA_AGGIORNAMENTO_DELIBERA) >= POS.DTA_PASSAGGIO_SOFF)
;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ALERT_DEL_AUT_TR TO MCRE_USR;
