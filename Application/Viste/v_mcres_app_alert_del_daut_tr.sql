/* Formatted on 21/07/2014 18:41:17 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ALERT_DEL_DAUT_TR
(
   ID_ALERT,
   COD_ABI,
   DESC_ISTITUTO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_UO_PRATICA,
   COD_MATR_PRATICA,
   COD_PROTOCOLLO_DELIBERA,
   DTA_INSERIMENTO_DELIBERA,
   COD_DELIBERA,
   VAL_ANNO_PRATICA,
   VAL_GBV,
   ALERT,
   COGNOME,
   NOME,
   DESC_NOME_GESTORE,
   DESC_DELIBERA,
   FLG_CONFERIMENTO,
   DTA_INOLTRO,
   COD_OD_CALCOLATO,
   FLG_DA_TRASFERIRE,
   DTA_DELIBERA,
   DTA_AGGIORNAMENTO_DELIBERA,
   COD_UO,
   ID_OBJECT_AL_TR,
   ID_OBJECT_AL_CO
)
AS
   SELECT                                                     -- AP 09/11/2012
                                        -- VG 03/12/2012 - Escluse delibere RW
        A."ID_ALERT",
        A."COD_ABI",
        A."DESC_ISTITUTO",
        A."COD_NDG",
        A."COD_SNDG",
        A."DESC_NOME_CONTROPARTE",
        A."COD_UO_PRATICA",
        A."COD_MATR_PRATICA",
        A."COD_PROTOCOLLO_DELIBERA",
        A."DTA_INSERIMENTO_DELIBERA",
        A."COD_DELIBERA",
        A."VAL_ANNO_PRATICA",
        A."VAL_GBV",
        A."ALERT",
        A."COGNOME",
        A."NOME",
        A."DESC_NOME_GESTORE",
        A."DESC_DELIBERA",
        A."FLG_CONFERIMENTO",
        A."DTA_INOLTRO",
        A."COD_OD_CALCOLATO",
        A."FLG_DA_TRASFERIRE",
        A."DTA_DELIBERA",
        A."DTA_AGGIORNAMENTO_DELIBERA",
        A."COD_UO",
        c.id_object AS id_object_al_tr,
        d.id_object AS id_object_al_co
   FROM (SELECT -- 20120730 AG  valorizzazione semaforo in base alla data di inoltro
    -- 20120820 AG  valorizzazione semaforo in base alla data di TRASFERIMENTO
  --              e aggiunta abi, ndg nella join della condizione di esistenza
                                           -- 20120914 AG  Esposizione cognome
               12 id_alert,
               P.COD_ABI,
               I.DESC_ISTITUTO,
               P.COD_NDG,
               s.COD_SNDG,
               a.DESC_NOME_CONTROPARTE,
               P.COD_UO_PRATICA,
               P.COD_MATR_PRATICA,
               S.COD_PROTOCOLLO_DELIBERA,
               S.DTA_INSERIMENTO_DELIBERA,
               S.COD_DELIBERA,
               P.VAL_ANNO VAL_ANNO_PRATICA,
               (  SELECT SUM (-1 * R.VAL_IMP_GBV) val_gbv
                    FROM T_MCRES_APP_RAPPORTI R
                   WHERE r.COD_ABI = P.COD_ABI AND r.cod_ndg = P.COD_ndg
                GROUP BY r.COD_ABI, COD_NDG)
                  val_gbv,
               --          r.val_gbv,
               CASE
                  WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) <=
                          g.val_current_green
                  THEN
                     'V'
                  WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) BETWEEN   g.val_current_green
                                                                     + 1
                                                                 AND g.val_current_orange
                  THEN
                     'A'
                  WHEN TRUNC (SYSDATE) - TRUNC (dta_inoltro) >
                          g.val_current_orange
                  THEN
                     'R'
                  ELSE
                     'X'
               END
                  ALERT,
               u.cognome,
               u.nome,
               U.COGNOME || ' ' || u.nome desc_nome_gestore, --Non rimosso per non impattare codice Java
               d.desc_delibera,
               NVL ( (SELECT DISTINCT 1
                        FROM v_mcres_app_conferimento_nt n
                       WHERE n.cod_abi = p.cod_abi AND n.cod_ndg = p.cod_ndg),
                    0)
                  flg_conferimento,
               dta_inoltro,
               cod_od_calcolato,
               CASE WHEN cod_od_calcolato = 'RP' THEN 0 ELSE 1 END
                  flg_da_trasferire,
               --AP 23/11/2012
               dta_delibera,
               s.dta_aggiornamento_delibera,
               s.cod_uo
          FROM T_MCRES_APP_PRATICHE P,
               T_MCRES_APP_DELIBERE S,
               --          (  SELECT r.COD_ABI, cod_ndg, SUM (-1 * R.VAL_IMP_GBV) val_gbv
               --               FROM T_MCRES_APP_RAPPORTI R
               --           GROUP BY r.COD_ABI, COD_NDG) R,
               T_MCRES_APP_ISTITUTI I,
               t_mcre0_app_anagrafica_gruppo a,
               t_mcres_app_utenti u,
               t_mcres_cl_tipo_delibera d,
               t_mcres_app_gestione_alert g
         WHERE     P.FLG_ATTIVA = 1
               AND g.id_alert = 12
               AND P.COD_MATR_PRATICA IS NOT NULL
               --          AND P.COD_ABI = r.COD_ABI
               --          AND P.COD_NDG = r.COD_NDG
               AND P.COD_ABI = S.COD_ABI
               AND P.COD_NDG = S.COD_NDG
               AND P.COD_PRATICA = S.COD_PRATICA
               AND P.VAL_ANNO = S.VAL_ANNO_PRATICA
               AND P.COD_ABI = I.COD_ABI
               AND s.COD_SNDG = A.COD_SNDG(+)
               AND s.cod_stato_delibera = 'IT'
               AND P.COD_MATR_PRATICA = U.COD_MATRICOLA(+)
               AND S.COD_DELIBERA = D.COD_DELIBERA(+)
               AND S.COD_ABI = D.COD_ABI(+)
               AND D.FLG_FORFETARIA(+) = 'S'
               AND s.cod_delibera != 'RW'
               AND NOT EXISTS
                          (SELECT DISTINCT 1
                             FROM T_MCRES_APP_DELIBERE z
                            WHERE     z.COD_PROTOCOLLO_DELIBERA_COLL =
                                         S.COD_PROTOCOLLO_DELIBERA
                                  AND z.COD_STATO_DELIBERA = 'TR'
                                  AND z.cod_abi = s.cod_abi
                                  AND z.cod_ndg = s.cod_ndg)
               AND s.cod_stato_rischio = 'S') A
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
