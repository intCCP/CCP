/* Formatted on 21/07/2014 18:36:03 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_ANAG_MOV
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PERCORSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_UNITA_OPERATIVA,
   ID_UTENTE,
   COGNOME,
   NOME,
   TMS
)
AS
   SELECT                                    -- V1 11/05/2011 VG: controllo SO
          --110926: nullif su cod_stato, test stato e stato_pre != -1
          --111004: Escludo se stato GB
          --120503: gestione stati RS
          --130307: esposto TMS x gestioen RS corretta
          --130311: mascherato stato e decorrenza anche su percorsi per macth all_data
          --130604: cambiata formattazione tms da 13 a 26
          --131009: fix gestione stato su chiusura rs
          DISTINCT
          TFIN.COD_ABI_CARTOLARIZZATO,
          TFIN.COD_ABI_ISTITUTO,
          TFIN.COD_NDG,
          TFIN.COD_PERCORSO,
          -- substr(tms_ini,0,26), substr(tms_fine,0,26), substr(TFIN.tms,0,26) ttms,
          --NULLIF (TFIN.COD_STATO_PRECEDENTE, '-1') COD_STATO_PRECEDENTE,
          CASE
             WHEN     tms_ini IS NOT NULL
                  --            AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                  AND (    SUBSTR (TFIN.TMS, 0, 26) >
                              SUBSTR (rs.TMS_INI, 0, 26)
                       AND SUBSTR (TFIN.TMS, 0, 26) <=
                              NVL (SUBSTR (rs.TMS_FINE, 0, 26),
                                   '9999-12-31.00'))
             THEN
                DECODE (TFIN.COD_STATO_PRECEDENTE,
                        'IN', 'RS',
                        TFIN.COD_STATO_PRECEDENTE)
             ELSE
                NULLIF (TFIN.COD_STATO_PRECEDENTE, '-1')
          END
             COD_STATO_PRECEDENTE,
          --NULLIF (TFIN.COD_STATO, '-1') COD_STATO,
          CASE
             WHEN     (SELECT cod_stato_precedente
                         FROM t_mcre0_app_All_DAta x
                        WHERE     x.cod_abi_cartolarizzato =
                                     tfin.cod_abi_cartolarizzato
                              AND x.cod_ndg = tfin.cod_ndg) = 'IN'
                  AND DTA_CHIUSURA_STATO IS NOT NULL
             THEN
                'IN'
             --AND SUBSTR (TFIN.TMS, 0, 26) <
             --NVL (SUBSTR (rs.TMS_FINE, 0, 26), '9999-12-31.00') THEN
             --DECODE (TFIN.COD_STATO, 'IN', 'RS', TFIN.COD_STATO)
             ELSE
                NULLIF (TFIN.COD_STATO, '-1')
          END
             COD_STATO,
          CASE
             WHEN     tms_ini IS NOT NULL
                  AND COD_STATO_PRECEDENTE = 'RS'                        --new
                  AND val_unita_operativa = 'MAN'                        --new
                  AND DTA_CHIUSURA_STATO IS NOT NULL                     --new
             THEN
                TRUNC (DTA_CHIUSURA_STATO)                               --new
             --  WHEN tms_ini IS NOT NULL
             --            AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
             --     AND SUBSTR (TFIN.TMS, 0, 26) <
             --          NVL (SUBSTR (rs.TMS_FINE, 0, 26), '9999-12-31.00') --rs.DTA_DECORRENZA_STATO
             --  THEN
             --   DECODE (TFIN.COD_STATO,
             --         'IN', rs.DTA_DECORRENZA_STATO,
             --       TFIN.DTA_DECORRENZA_STATO)
             ELSE
                TFIN.DTA_DECORRENZA_STATO
          END
             DTA_DECORRENZA_STATO,
          TFIN.DTA_SCADENZA_STATO,
          TFIN.VAL_UNITA_OPERATIVA,
          TFIN.ID_UTENTE,
          TFIN.COGNOME,
          TFIN.NOME,
          --      CASE
          --        WHEN tms_ini IS NOT NULL
          --            AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
          --           rs.DTA_DECORRENZA_STATO
          --        ELSE
          --           TFIN.DTA_DECORRENZA_STATO
          --      END
          --to_date(TFIN.tms, 'yyyy-mm-dd.hh24.mi.ss.ff') TMS
          TFIN.tms TMS
     FROM t_mcre0_app_rs_posizioni rs,
          (                                                 --Mople + Percorsi
           SELECT DISTINCT
                  OTMP.COD_ABI_CARTOLARIZZATO,
                  OTMP.COD_ABI_ISTITUTO,
                  OTMP.COD_NDG,
                  OTMP.COD_PERCORSO,
                  OTMP.COD_STATO_PRECEDENTE,
                  OTMP.COD_STATO,
                  OTMP.DTA_DECORRENZA_STATO,
                  OTMP.DTA_SCADENZA_STATO,
                  FIRST_VALUE (
                     OTMP.VAL_UNITA_OPERATIVA)
                  OVER (
                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  OTMP.DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO
                     -- , OTMP.TMS
                     ORDER BY ORDINE, TMS)
                     VAL_UNITA_OPERATIVA,
                  FIRST_VALUE (
                     OTMP.ID_UTENTE)
                  OVER (
                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  OTMP.DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO
                     -- , OTMP.TMS
                     ORDER BY ORDINE, TMS)
                     ID_UTENTE,
                  FIRST_VALUE (
                     OTMP.COGNOME)
                  OVER (
                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  OTMP.DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO
                     -- , OTMP.TMS
                     ORDER BY ORDINE, TMS)
                     COGNOME,
                  FIRST_VALUE (
                     OTMP.NOME)
                  OVER (
                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  OTMP.DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO
                     -- , OTMP.TMS
                     ORDER BY ORDINE, TMS)
                     NOME,
                  FIRST_VALUE (
                     OTMP.TMS)
                  OVER (
                     PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  OTMP.DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO
                     -- , OTMP.TMS
                     ORDER BY ORDINE, TMS)
                     TMS
             --, m.tms
             FROM (SELECT M.COD_ABI_CARTOLARIZZATO,
                          M.COD_ABI_ISTITUTO,
                          M.COD_NDG,
                          M.COD_PERCORSO,
                          M.COD_STATO_PRECEDENTE,
                          M.COD_STATO,
                          M.DTA_DECORRENZA_STATO,
                          M.DTA_SCADENZA_STATO,
                          M.COD_COMPARTO || U.COD_MATRICOLA
                             VAL_UNITA_OPERATIVA,
                          NULLIF (M.ID_UTENTE, -1) ID_UTENTE,
                          U.COGNOME,
                          U.NOME,                                    --, m.tms
                          --prova
                          TO_CHAR (LOCALTIMESTAMP (6),
                                   'yyyy-mm-dd.hh24.mi.ss.ff')
                             tms,
                          ----
                          2 ORDINE
                     /*FROM t_mcre0_app_mople m
                                                         INNER JOIN t_mcre0_app_file_guida f
                                                         ON ( m.cod_abi_cartolarizzato = m.cod_abi_cartolarizzato
                                                        AND m.cod_ndg                   = m.cod_ndg )
                                                      left outer JOIN t_mcre0_app_utenti u
                                                      ON (u.id_utente = m.id_utente)
                                                                          WHERE 1            = 1 */
                     FROM V_MCRE0_APP_UPD_FIELDS_PALL M,
                          T_MCRE0_APP_PERCORSI P,
                          T_MCRE0_APP_UTENTI U
                    WHERE     M.COD_ABI_CARTOLARIZZATO =
                                 P.COD_ABI_CARTOLARIZZATO(+)
                          AND M.COD_NDG = P.COD_NDG(+)
                          AND M.DTA_DECORRENZA_STATO =
                                 P.DTA_DECORRENZA_STATO(+)
                          AND M.ID_UTENTE = U.ID_UTENTE
                          AND DECODE (M.COD_STATO,
                                      'SO', DECODE (M.COD_PERCORSO, 0, 0, 1),
                                      1) =
                                 DECODE (
                                    M.COD_STATO,
                                    'SO', DECODE (
                                             M.COD_PERCORSO,
                                             0, DECODE (P.COD_NDG,
                                                        NULL, 0,
                                                        1),
                                             1),
                                    1)
                   --and m.cod_abi_cartolarizzato='06385' and m.cod_ndg='0000423154719000'
                   UNION
                   SELECT PTMP.COD_ABI_CARTOLARIZZATO,
                          PTMP.COD_ABI_ISTITUTO,
                          PTMP.COD_NDG,
                          PTMP.COD_PERCORSO,
                          PTMP.COD_STATO_PRECEDENTE,
                          --'maschero' per macth con all_data
                          CASE
                             WHEN     tms_ini IS NOT NULL
                                  --            AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                                  AND SUBSTR (PTMP.TMS, 0, 26) <
                                         NVL (SUBSTR (rs.TMS_FINE, 0, 26),
                                              '9999-12-31.00')
                             THEN
                                DECODE (PTMP.COD_STATO,
                                        'IN', 'RS',
                                        PTMP.COD_STATO)
                             ELSE
                                NULLIF (PTMP.COD_STATO, '-1')
                          END
                             COD_STATO,
                          CASE
                             WHEN     tms_ini IS NOT NULL
                                  --            AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                                  AND SUBSTR (PTMP.TMS, 0, 26) <
                                         NVL (SUBSTR (rs.TMS_FINE, 0, 26),
                                              '9999-12-31.00') --rs.DTA_DECORRENZA_STATO
                             THEN
                                DECODE (PTMP.COD_STATO,
                                        'IN', rs.DTA_DECORRENZA_STATO,
                                        PTMP.DTA_DECORRENZA_STATO)
                             ELSE
                                PTMP.DTA_DECORRENZA_STATO
                          END
                             DTA_DECORRENZA_STATO,
                          PTMP.DTA_SCADENZA_STATO,
                          PTMP.VAL_UNITA_OPERATIVA,
                          PTMP.ID_UTENTE,
                          PTMP.COGNOME,
                          PTMP.NOME,                              --, ptmp.tms
                          --prova
                          PTMP.TMS,
                          PTMP.ORDINE
                     FROM (SELECT P.COD_ABI_CARTOLARIZZATO,
                                  P.COD_ABI_ISTITUTO,
                                  P.COD_NDG,
                                  P.COD_PERCORSO,
                                  P.COD_STATO_PRECEDENTE,
                                  P.COD_STATO,
                                  P.DTA_DECORRENZA_STATO,
                                  P.DTA_SCADENZA_STATO,
                                  P.COD_CODUTRM VAL_UNITA_OPERATIVA,
                                  U.ID_UTENTE,
                                  U.COGNOME,
                                  U.NOME,                            --, m.tms
                                  --prova
                                  P.TMS,
                                  MAX (
                                     P.COD_PERCORSO)
                                  OVER (
                                     PARTITION BY P.COD_ABI_CARTOLARIZZATO,
                                                  P.COD_NDG)
                                     ULTIMO_PERCORSO,
                                  1 ORDINE
                             FROM T_MCRE0_APP_PERCORSI P
                                  INNER JOIN
                                  T_MCRE0_APP_UTENTI U
                                     ON (SUBSTR (P.COD_CODUTRM, 7) =
                                            U.COD_MATRICOLA(+))) PTMP,
                          t_mcre0_app_rs_posizioni rs
                    WHERE     1 = 1
                          AND PTMP.ULTIMO_PERCORSO = PTMP.COD_PERCORSO --and ptmp.cod_abi_cartolarizzato='06385' and ptmp.cod_ndg='0000423154719000'
                          --'maschero' anche sulla percorsi per match sulla all_data
                          AND PTMP.cod_abi_cartolarizzato =
                                 rs.cod_abi_cartolarizzato(+)
                          AND PTMP.cod_ndg = rs.cod_ndg(+)
                          AND PTMP.cod_percorso = rs.cod_percorso(+)
                          AND SUBSTR (PTMP.TMS, 0, 26) BETWEEN SUBSTR (
                                                                  rs.TMS_INI(+),
                                                                  0,
                                                                  26)
                                                           AND NVL (
                                                                  SUBSTR (
                                                                     rs.TMS_FINE(+),
                                                                     0,
                                                                     26),
                                                                  '9999-12-31.00')) OTMP
           --------------------------------------------------------
           UNION
           --Storico Eventi
           SELECT TEV.COD_ABI_CARTOLARIZZATO,
                  TEV.COD_ABI_ISTITUTO,
                  TEV.COD_NDG,
                  TEV.COD_PERCORSO,
                  TEV.COD_STATO_PRECEDENTE,
                  TEV.COD_STATO,
                  TEV.DTA_DECORRENZA_STATO,
                  TEV.DTA_SCADENZA_STATO,
                  TEV.VAL_UNITA_OPERATIVA,
                  TEV.ID_UTENTE,
                  TEV.COGNOME,
                  TEV.NOME,
                  TEV.TMS
             --, m.tms
             FROM (SELECT /*+ index(otmp,IB1_t_mcre0_app_storico_eventi)*/
                         OTMP.COD_ABI_CARTOLARIZZATO,
                          OTMP.COD_ABI_ISTITUTO,
                          OTMP.COD_NDG,
                          OTMP.COD_PERCORSO,
                          OTMP.COD_STATO_PRECEDENTE,
                          OTMP.COD_STATO,
                          OTMP.DTA_FINE_VALIDITA AS DTA_DECORRENZA_STATO,
                          OTMP.DTA_SCADENZA_STATO,
                             NVL (OTMP.COD_COMPARTO_ASSEGNATO,
                                  OTMP.COD_COMPARTO_CALCOLATO)
                          || U.COD_MATRICOLA
                             VAL_UNITA_OPERATIVA,
                          U.ID_UTENTE,
                          U.COGNOME,
                          U.NOME                                  --, otmp.tms
                                ,
                          MAX (
                             OTMP.COD_PERCORSO)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_NDG)
                             ULTIMO_PERCORSO,
                          --prova
                          TO_CHAR (OTMP.DTA_FINE_VALIDITA,
                                   'yyyy-mm-dd.hh24.mi.ss.ff')
                             tms
                     FROM T_MCRE0_APP_STORICO_EVENTI OTMP
                          LEFT OUTER JOIN T_MCRE0_APP_UTENTI U
                             ON (U.ID_UTENTE = OTMP.ID_UTENTE)
                    WHERE     1 = 1
                          AND OTMP.FLG_CAMBIO_STATO = '1' --   AND otmp.dta_fine_validita >  TRUNC (SYSDATE) + 8 / 24
                          AND OTMP.DTA_FINE_VAL_TR > TRUNC (SYSDATE) + 8 / 24) TEV
            WHERE 1 = 1 AND TEV.ULTIMO_PERCORSO = TEV.COD_PERCORSO) TFIN
    WHERE     NOT (TFIN.COD_STATO = '-1' AND TFIN.COD_STATO_PRECEDENTE = '-1')
          AND TFIN.COD_STATO != 'GB'
          AND tfin.cod_abi_cartolarizzato = rs.cod_abi_cartolarizzato(+)
          AND tfin.cod_ndg = rs.cod_ndg(+)
          AND tfin.cod_percorso = rs.cod_percorso(+)
          AND SUBSTR (TFIN.TMS, 0, 26) BETWEEN SUBSTR (rs.TMS_INI(+), 0, 26)
                                           AND NVL (
                                                  SUBSTR (rs.TMS_FINE(+),
                                                          0,
                                                          26),
                                                  '9999-12-31.00');
