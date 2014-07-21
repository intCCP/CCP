/* Formatted on 21/07/2014 18:34:29 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_STATI_LAV
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_PERCORSO,
   ID_PIANO,
   DTA_SCADENZA,
   FLG_SCADUTO,
   FLG_CONFERMA,
   DTA_CONFERMA,
   DTA_INS,
   FLG_STATO_ANNULLATO,
   DTA_STATO_ANNULLATO,
   COD_STATO_LAVORAZIONE,
   DESC_STATO_LAVORAZIONE,
   DTA_CONCLUSIONE_ATTIVITA,
   VAL_NOTE,
   COD_SNDG,
   COD_STATO_PRECEDENTE
)
AS
   SELECT s.cod_abi_cartolarizzato,
          s.cod_ndg,
          s.cod_percorso,
          s.id_piano,
          P.DTA_SCADENZA,
          CASE WHEN P.DTA_SCADENZA < SYSDATE THEN 'S' ELSE 'N' END
             FLG_SCADUTO,
          p.FLG_CONFERMA,
          p.DTA_CONFERMA,
          s.DTA_INS,
          s.FLG_STATO_ANNULLATO,
          s.DTA_STATO_ANNULLATO,
          s.cod_stato_lavorazione,
          cl.desc_stato AS DESC_STATO_LAVORAZIONE,
          s.DTA_CONCLUSIONE_ATTIVITA,
          s.VAL_NOTE,
          a.COD_SNDG,
          a.COD_STATO_PRECEDENTE
     FROM t_mcre0_app_all_data a,
          T_MCRE0_APP_PM_STATI_LAV s,
          T_MCRE0_APP_GEST_PM P,
          T_MCRE0_CL_STATI_LAV_PM cl
    WHERE     a.COD_ABI_CARTOLARIZZATO = s.COD_ABI_CARTOLARIZZATO
          AND a.COD_NDG = s.COD_NDG
          AND A.COD_STATO = 'PM'
          AND A.COD_PERCORSO = s.COD_PERCORSO
          AND a.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
          AND a.COD_NDG = P.COD_NDG
          AND A.COD_PERCORSO = P.COD_PERCORSO
          AND s.ID_PIANO = p.id_piano
          AND s.COD_STATO_LAVORAZIONE = cl.cod_stato(+);
