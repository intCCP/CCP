/* Formatted on 21/07/2014 18:36:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_PERCORSI
(
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   COD_PERCORSO,
   COD_PROCESSO,
   DTA_PROCESSO,
   COD_STATO_PRECEDENTE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   VAL_UNITA_OPERATIVA,
   ID_UTENTE,
   COGNOME,
   NOME,
   TMS,
   FLG_ANNULLO,
   FLG_MOPLE,
   ESISTE_DEL_ATTIVA
)
AS
   SELECT   --110926: corretto nullif cod_stato, condizione su stati non nulli
          --111004: Escludo se stato GB
          --111114: MM aggiunto segnaposto ESISTE_DEL_ATTIVA (da calcolare)
          --120503: gestione stati RS
          --120709: esposto campo dta_processo per ordinamento a video
          --130604: MM esteso formato tms interni da 13 a 26
          SP.COD_ABI_CARTOLARIZZATO,
          SP.COD_ABI_ISTITUTO,
          SP.COD_NDG,
          SP.COD_PERCORSO,
          SP.COD_PROCESSO,
          SP.DTA_PROCESSO,
          NULLIF (SP.COD_STATO_PRECEDENTE, '-1') COD_STATO_PRECEDENTE,
          NULLIF (SP.COD_STATO, '-1') COD_STATO,
          SP.DTA_DECORRENZA_STATO,
          SP.DTA_SCADENZA_STATO,
          SP.VAL_UNITA_OPERATIVA,
          NULLIF (SP.ID_UTENTE, -1) ID_UTENTE,
          SP.COGNOME,
          SP.NOME,
          TO_DATE (SUBSTR (SP.TMS, 1, 19), 'yyyy-mm-dd.hh24.mi.ss') TMS,
          SP.FLG_ANNULLO,
          CASE WHEN MPL.COD_ABI_CARTOLARIZZATO IS NOT NULL THEN 1 ELSE 0 END
             AS FLG_MOPLE,
          'N' ESISTE_DEL_ATTIVA
     FROM (SELECT DISTINCT
                  TFIN.COD_ABI_CARTOLARIZZATO,
                  TFIN.COD_ABI_ISTITUTO,
                  TFIN.COD_NDG,
                  TFIN.COD_PERCORSO,
                  TFIN.COD_PROCESSO,
                  TFIN.DTA_PROCESSO,
                  CASE
                     WHEN     tms_ini IS NOT NULL
                          --               AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
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
                     WHEN     tms_ini IS NOT NULL
                          --               AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                          AND SUBSTR (TFIN.TMS, 0, 26) <
                                 NVL (SUBSTR (rs.TMS_FINE, 0, 26),
                                      '9999-12-31.00')
                     THEN
                        DECODE (TFIN.COD_STATO, 'IN', 'RS', TFIN.COD_STATO)
                     ELSE
                        NULLIF (TFIN.COD_STATO, '-1')
                  END
                     COD_STATO,
                  CASE
                     WHEN     tms_ini IS NOT NULL
                          --               AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                          AND SUBSTR (TFIN.TMS, 0, 26) <
                                 NVL (SUBSTR (rs.TMS_FINE, 0, 26),
                                      '9999-12-31.00') --rs.DTA_DECORRENZA_STATO
                     THEN
                        DECODE (TFIN.COD_STATO,
                                'IN', rs.DTA_DECORRENZA_STATO,
                                TFIN.DTA_DECORRENZA_STATO)
                     ELSE
                        TFIN.DTA_DECORRENZA_STATO
                  END
                     DTA_DECORRENZA_STATO,
                  TFIN.DTA_SCADENZA_STATO,
                  TFIN.VAL_UNITA_OPERATIVA,
                  TFIN.ID_UTENTE,
                  TFIN.COGNOME,
                  TFIN.NOME,
                  TFIN.tms TMS,
                  NULL FLG_ANNULLO
             FROM t_mcre0_app_rs_posizioni rs,
                  (                                         --Mople + Percorsi
                   SELECT DISTINCT
                          OTMP.COD_ABI_CARTOLARIZZATO,
                          OTMP.COD_ABI_ISTITUTO,
                          OTMP.COD_NDG,
                          OTMP.COD_PERCORSO,
                          OTMP.COD_PROCESSO,
                          OTMP.DTA_PROCESSO,
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
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             VAL_UNITA_OPERATIVA,
                          FIRST_VALUE (
                             OTMP.ID_UTENTE)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             ID_UTENTE,
                          FIRST_VALUE (
                             OTMP.COGNOME)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
                             COGNOME,
                          FIRST_VALUE (
                             OTMP.NOME)
                          OVER (
                             PARTITION BY OTMP.COD_ABI_CARTOLARIZZATO,
                                          OTMP.COD_ABI_ISTITUTO,
                                          OTMP.COD_NDG,
                                          OTMP.COD_PERCORSO,
                                          OTMP.COD_PROCESSO,
                                          OTMP.DTA_PROCESSO,
                                          OTMP.COD_STATO_PRECEDENTE,
                                          OTMP.COD_STATO,
                                          OTMP.DTA_DECORRENZA_STATO,
                                          OTMP.DTA_SCADENZA_STATO
                             ORDER BY ORDINE)
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
                     FROM (                                      -------------
                           SELECT COD_ABI_CARTOLARIZZATO,
                                  COD_ABI_ISTITUTO,
                                  COD_NDG,
                                  COD_PERCORSO,
                                  COD_PROCESSO,
                                  DTA_PROCESSO,
                                  COD_STATO_PRECEDENTE,
                                  COD_STATO,
                                  DTA_DECORRENZA_STATO,
                                  DTA_SCADENZA_STATO,
                                     NVL (COD_COMPARTO_ASSEGNATO,
                                          COD_COMPARTO_CALCOLATO)
                                  || COD_MATRICOLA
                                     VAL_UNITA_OPERATIVA,
                                  V.ID_UTENTE,
                                  COGNOME,
                                  NOME,                                --, tms
                                  TO_CHAR (LOCALTIMESTAMP (6),
                                           'yyyy-mm-dd.hh24.mi.ss.ff')
                                     tms,
                                  2 ORDINE
                             FROM V_MCRE0_APP_UPD_FIELDS_PALL V,
                                  T_MCRE0_APP_UTENTI U
                            WHERE V.ID_UTENTE = U.ID_UTENTE(+)
                           UNION
                           SELECT PTMP.COD_ABI_CARTOLARIZZATO,
                                  PTMP.COD_ABI_ISTITUTO,
                                  PTMP.COD_NDG,
                                  PTMP.COD_PERCORSO,
                                  PTMP.COD_PROCESSO,
                                  PTMP.DTA_PROCESSO,
                                  PTMP.COD_STATO_PRECEDENTE,
                                  --'maschero' per macth con all_data
                                  CASE
                                     WHEN     tms_ini IS NOT NULL
                                          --               AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                                          AND SUBSTR (PTMP.TMS, 0, 26) <
                                                 NVL (
                                                    SUBSTR (rs.TMS_FINE,
                                                            0,
                                                            26),
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
                                          --               AND TFIN.DTA_DECORRENZA_STATO > rs.DTA_DECORRENZA_STATO THEN
                                          AND SUBSTR (PTMP.TMS, 0, 26) <
                                                 NVL (
                                                    SUBSTR (rs.TMS_FINE,
                                                            0,
                                                            26),
                                                    '9999-12-31.00') --rs.DTA_DECORRENZA_STATO
                                     THEN
                                        DECODE (
                                           PTMP.COD_STATO,
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
                                  PTMP.NOME,                      --, ptmp.tms
                                  --prova
                                  PTMP.TMS,
                                  PTMP.ORDINE
                             FROM (SELECT P.COD_ABI_CARTOLARIZZATO,
                                          P.COD_ABI_ISTITUTO,
                                          P.COD_NDG,
                                          P.COD_PERCORSO,
                                          P.COD_PROCESSO,
                                          P.DTA_PROCESSO,
                                          P.COD_STATO_PRECEDENTE,
                                          P.COD_STATO,
                                          P.DTA_DECORRENZA_STATO,
                                          P.DTA_SCADENZA_STATO,
                                          P.COD_CODUTRM VAL_UNITA_OPERATIVA,
                                          U.ID_UTENTE,
                                          U.COGNOME,
                                          U.NOME,
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
                                  --AND PTMP.ULTIMO_PERCORSO = PTMP.COD_PERCORSO --and ptmp.cod_abi_cartolarizzato='06385' and ptmp.cod_ndg='0000423154719000'
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
                          TEV.COD_PROCESSO,
                          TEV.DTA_PROCESSO,
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
                     FROM (SELECT /*+index(otmp IX2_T_MCRE0_APP_STORICO_EVENTI) no_parallel(otmp)
                                                             no_parallel(u)*/
                                 OTMP.COD_ABI_CARTOLARIZZATO,
                                  OTMP.COD_ABI_ISTITUTO,
                                  OTMP.COD_NDG,
                                  OTMP.COD_PERCORSO,
                                  OTMP.COD_PROCESSO,
                                  OTMP.DTA_PROCESSO,
                                  OTMP.COD_STATO_PRECEDENTE,
                                  OTMP.COD_STATO,
                                  /*otmp.dta_fine_validita*/
                                  DTA_DECORRENZA_STATO
                                     AS DTA_DECORRENZA_STATO,
                                  OTMP.DTA_SCADENZA_STATO,
                                     NVL (OTMP.COD_COMPARTO_ASSEGNATO,
                                          OTMP.COD_COMPARTO_CALCOLATO)
                                  || U.COD_MATRICOLA
                                     VAL_UNITA_OPERATIVA,
                                  U.ID_UTENTE,
                                  U.COGNOME,
                                  U.NOME                          --, otmp.tms
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
                                  INNER JOIN T_MCRE0_APP_UTENTI U
                                     ON (U.ID_UTENTE = OTMP.ID_UTENTE)
                            WHERE     OTMP.FLG_CAMBIO_STATO = '1'
                                  AND OTMP.DTA_FINE_VAL_TR >
                                         TRUNC (SYSDATE) + 8 / 24) TEV
                    WHERE 1 = 1 AND TEV.ULTIMO_PERCORSO = TEV.COD_PERCORSO) TFIN
            WHERE     tfin.cod_abi_cartolarizzato =
                         rs.cod_abi_cartolarizzato(+)
                  AND tfin.cod_ndg = rs.cod_ndg(+)
                  AND tfin.cod_percorso = rs.cod_percorso(+)
                  AND SUBSTR (TFIN.TMS, 0, 26) BETWEEN SUBSTR (rs.TMS_INI(+),
                                                               0,
                                                               26)
                                                   AND NVL (
                                                          SUBSTR (
                                                             rs.TMS_FINE(+),
                                                             0,
                                                             26),
                                                          '9999-12-31.00')) SP
          LEFT JOIN
          T_MCRE0_APP_ALL_DATA MPL
             ON     MPL.COD_ABI_CARTOLARIZZATO = SP.COD_ABI_CARTOLARIZZATO
                AND MPL.COD_NDG = SP.COD_NDG
                AND MPL.DTA_DECORRENZA_STATO = SP.DTA_DECORRENZA_STATO
                AND MPL.DTA_SCADENZA_STATO = SP.DTA_SCADENZA_STATO
                AND MPL.COD_STATO_PRECEDENTE = SP.COD_STATO_PRECEDENTE
    WHERE     NOT (SP.COD_STATO = '-1' AND SP.COD_STATO_PRECEDENTE = '-1')
          AND SP.COD_STATO != 'GB'

--   AND SP.COD_NDG ='0000019687562000'
-- AND SP.COD_ABI_CARTOLARIZZATO = '01025'
-- order by tms desc;
;
