/* Formatted on 21/07/2014 18:34:20 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_PM_DI_COMP
(
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO,
   COD_SNDG,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_PERCORSO,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   DTA_UTENTE_ASSEGNATO,
   COD_STATO_PRECEDENTE,
   COD_PROCESSO,
   SCSB_ACC_TOT,
   SCSB_UTI_TOT,
   FLG_PIANO_ANNULLATO,
   VAL_GG_PM,
   DTA_SCADENZA,
   ID_WORKFLOW,
   DESC_NOMINATIVO_FILIALE,
   COD_TIPO_PIANO,
   FLG_NUOVO_PIANO
)
AS
   SELECT a.ID_UTENTE,
          a.ID_REFERENTE,
          a.COD_COMPARTO,
          a.COD_SNDG,
          a.COD_NDG,
          a.DESC_NOME_CONTROPARTE,
          a.COD_GRUPPO_ECONOMICO,
          a.DESC_GRUPPO_ECONOMICO,
          a.COD_ABI_ISTITUTO,
          a.COD_ABI_CARTOLARIZZATO,
          a.DESC_ISTITUTO,
          a.cod_percorso,
          a.COD_STRUTTURA_COMPETENTE_RG,
          a.DESC_STRUTTURA_COMPETENTE_RG,
          a.COD_STRUTTURA_COMPETENTE_AR,
          a.DESC_STRUTTURA_COMPETENTE_AR,
          a.COD_STRUTTURA_COMPETENTE_FI,
          a.DESC_STRUTTURA_COMPETENTE_FI,
          a.COD_STRUTTURA_COMPETENTE,
          a.DTA_DECORRENZA_STATO,
          a.DTA_SCADENZA_STATO,
          a.DTA_UTENTE_ASSEGNATO,
          (SELECT cod_macrostato
             FROM t_mcre0_app_stati
            WHERE cod_microstato = a.COD_STATO_PRECEDENTE)
             COD_STATO_PRECEDENTE,
          a.COD_PROCESSO,
          a.SCSB_ACC_TOT,
          a.SCSB_UTI_TOT,
          p.FLG_PIANO_ANNULLATO,
          TRUNC (SYSDATE) - a.dta_decorrenza_stato VAL_GG_PM,
          p.DTA_SCADENZA,
          p.ID_WORKFLOW,
          P.DESC_NOMINATIVO_FILIALE,
          NVL (
             P.COD_TIPO_PIANO,
             (SELECT cod_tipo_piano
                FROM V_MCRE0_APP_PM_TIPO_PIANO v
               WHERE     v.cod_abi_cartolarizzato = a.cod_abi_cartolarizzato
                     AND v.cod_ndg = a.cod_ndg))
             cod_tipo_piano,
          CASE WHEN NVL (P.ID_PIANO, 0) > 1 THEN 'S' ELSE 'N' END
             FLG_NUOVO_PIANO
     FROM V_MCRE0_APP_UPD_FIELDS a, T_MCRE0_APP_GEST_PM p
    WHERE     a.COD_ABI_CARTOLARIZZATO = p.COD_ABI_CARTOLARIZZATO(+)
          AND a.COD_NDG = p.COD_NDG(+)
          AND A.COD_STATO = 'PM'
          --and P.FLG_PIANO_ANNULLATO = 'N' li mostro lo stesso..
          AND P.ID_WORKFLOW(+) < 10 --inizio lavorazione-piano non ancora da confermare
          --AND a.DTA_DECORRENZA_STATO = P.DTA_DECORRENZA_STATO(+)
          AND a.cod_percorso = p.cod_percorso(+)
          AND NOT EXISTS
                     (SELECT 1
                        FROM t_mcre0_app_gest_pm p
                       WHERE     p.cod_abi_cartolarizzato =
                                    a.cod_abi_cartolarizzato
                             AND p.cod_ndg = a.cod_ndg
                             AND p.cod_percorso = a.cod_percorso
                             AND p.id_workflow BETWEEN 10 AND 20)
          ---- VG 20140701 controllo id_utente e outsourcing e messi outerjoin
          --AND a.id_utente != -1
          AND NVL (FLG_OUTSOURCING, 'N') = 'Y';
