CREATE OR REPLACE FORCE VIEW V_MCRE0_APP_PM_PIANI_DA_INS
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_ISTITUTO,
   DESC_NOME_CONTROPARTE,
   COD_COMPARTO,
   COD_FILIALE,
   COD_PERCORSO,
   COD_GRUPPO_ECONOMICO,
   DESC_GRUPPO_ECONOMICO,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STRUTTURA_COMPETENTE,
   DTA_DECORRENZA_STATO,
   DTA_SCADENZA_STATO,
   COD_PROCESSO,
   SCSB_ACC_TOT,
   VAL_TOTALE_UTILIZZI,
   VAL_NUMERO_PIANO,
   DTA_PIANO,
   DTA_SCADENZA,
   DTA_SCADENZA_PRECEDENTE,
   DTA_VALIDAZIONE,
   VAL_NOTE_OPERATIVE,
   FLG_PRESENZA_PIANO,
   FLG_PIANO_ANNULLATO,
   VAL_GG_PM,
   COD_TIPO_PIANO,
   COD_UO_ANNULLO
)
AS
   SELECT                      -- VG 20140701 COD_TIPO_PIANO + nvl su workflow
         a.COD_ABI_ISTITUTO,
          a.COD_ABI_CARTOLARIZZATO,
          a.COD_NDG,
          a.COD_SNDG,
          a.DESC_ISTITUTO,
          a.DESC_NOME_CONTROPARTE,
          a.COD_COMPARTO,
          A.COD_FILIALE,
          a.cod_percorso,
          a.COD_GRUPPO_ECONOMICO,
          a.DESC_GRUPPO_ECONOMICO,
          a.COD_STRUTTURA_COMPETENTE_RG,
          a.DESC_STRUTTURA_COMPETENTE_RG,
          a.COD_STRUTTURA_COMPETENTE_AR,
          a.DESC_STRUTTURA_COMPETENTE_AR,
          a.COD_STRUTTURA_COMPETENTE_FI,
          a.DESC_STRUTTURA_COMPETENTE_FI,
          a.COD_STRUTTURA_COMPETENTE,
          a.DTA_DECORRENZA_STATO,
          a.DTA_SCADENZA_STATO,
          a.COD_PROCESSO,
          a.SCSB_ACC_TOT,
          a.SCSB_UTI_TOT val_totale_utilizzi,
          p.ID_PIANO VAL_NUMERO_PIANO,
          p.DTA_PIANO,
          P.DTA_SCADENZA,
          P.DTA_SCADENZA_PRECEDENTE,
          P.DTA_PIANO_VALIDATO DTA_VALIDAZIONE,
          P.VAL_NOTE_OPERATIVE,
          DECODE (P.ID_PIANO, NULL, 'N', 'S') flg_presenza_piano,
          p.FLG_PIANO_ANNULLATO,
          TRUNC (SYSDATE) - a.dta_decorrenza_stato VAL_GG_PM,
          (SELECT COD_TIPO_PIANO
             FROM V_MCRE0_APP_PM_TIPO_PIANO pp
            WHERE     pp.COD_ABI_CARTOLARIZZATO = a.COD_ABI_CARTOLARIZZATO
                  AND pp.COD_NDG = a.COD_NDG)
             COD_TIPO_PIANO,
          (SELECT cod_struttura_competente
             FROM t_mcre0_app_utenti u, t_mcre0_app_struttura_org o
            WHERE     u.id_utente = NVL (id_utente_annullo, -1)
                  AND o.cod_abi_istituto = a.COD_ABI_CARTOLARIZZATO
                  AND o.cod_comparto = U.COD_COMPARTO_UTENTE
                  AND ROWNUM <= 1)
             COD_UO_ANNULLO
     FROM V_MCRE0_APP_UPD_FIELDS a,
          (SELECT a.*,
                  ROW_NUMBER ()
                  OVER (
                     PARTITION BY cod_abi_cartolarizzato,
                                  cod_ndg,
                                  cod_percorso
                     ORDER BY id_piano DESC)
                     AS numb
             FROM T_MCRE0_APP_GEST_PM a) p
    WHERE     p.numb = 1
          AND a.COD_ABI_CARTOLARIZZATO = p.COD_ABI_CARTOLARIZZATO(+)
          AND a.COD_NDG = p.COD_NDG(+)
          AND A.COD_PERCORSO = P.COD_PERCORSO(+)
          AND P.FLG_PIANO_ANNULLATO(+) = 'N'
          AND (   (    NVL (P.ID_WORKFLOW, 1) IN (0, 15, 20, 30)
                   AND NVL (P.DTA_SCADENZA, SYSDATE - 1) < SYSDATE) -- non completati ma scaduti
               OR NVL (P.ID_WORKFLOW, 1) NOT IN (10, 15, 20, 40)) --non completati/validati/da class
          AND A.COD_STATO = 'PM';