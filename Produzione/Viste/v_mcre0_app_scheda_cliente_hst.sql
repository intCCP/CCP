/* Formatted on 17/06/2014 18:04:24 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_SCHEDA_CLIENTE_HST
(
   DTA_FINE_VALIDITA,
   COD_ABI_CARTOLARIZZATO,
   DESC_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   COD_SNDG,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE,
   COD_GRUPPO_LEGAME,
   COD_SNDG_GE,
   COD_COMPARTO,
   COD_STRUTTURA_COMPETENTE,
   NOME,
   COGNOME,
   COD_STRUTTURA_COMPETENTE_DC,
   DESC_STRUTTURA_COMPETENTE_DC,
   COD_STRUTTURA_COMPETENTE_RG,
   DESC_STRUTTURA_COMPETENTE_RG,
   COD_STRUTTURA_COMPETENTE_AR,
   DESC_STRUTTURA_COMPETENTE_AR,
   COD_STRUTTURA_COMPETENTE_FI,
   DESC_STRUTTURA_COMPETENTE_FI,
   COD_STATO,
   COD_PROCESSO,
   VAL_GG_INTERCETTAMENTO,
   DTA_SCADENZA_STATO,
   DTA_LAST_DEL_FIDO,
   DTA_LAST_PEF_PROPOSTA,
   FLG_FIDI_SCADUTI,
   DTA_SCADENZA_FIDO,
   VAL_LAST_FASE_PEF,
   VAL_STRATEGIA_CREDIT,
   VAL_LAST_ORGANO_DEL_CP,
   VAL_CONTRASS_ORGANO_DEL_CP,
   FLG_CONFERMA_SAG,
   FLG_ALLINEATO_SAG,
   VAL_SCONFINO,
   DTA_LAST_UPDATE,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO,
   COD_PERCORSO,
   GL_COD_GRUPPO_LEGAME,
   GL_COD_LEGAME,
   GL_VAL_PD_ONLINE,
   GL_VAL_RATING_ONLINE,
   GL_VAL_PD_MONIT_ONLINE,
   GL_VAL_RATING_MONIT_ONLINE,
   GL_VAL_IRIS,
   GL_VAL_LR,
   GL_VAL_LGD,
   GL_VAL_EAD,
   GL_VAL_PA,
   GL_VAL_ACCORDATO,
   GL_VAL_UTILIZZATO,
   GL_VAL_QI,
   GL_DTA_IRIS,
   GL_DTA_PD_ONLINE,
   GL_DTA_PD_MONITORAGGIO,
   GL_GLGB_QIS_ACC,
   GL_GLGB_QIS_UTI,
   GE_COD_GRUPPO_ECONOMICO,
   GE_VAL_PD_ONLINE,
   GE_VAL_RATING_ONLINE,
   GE_VAL_PD_MONIT_ONLINE,
   GE_VAL_RATING_MONIT_ONLINE,
   GE_VAL_IRIS,
   GE_VAL_LR,
   GE_VAL_LGD,
   GE_VAL_EAD,
   GE_VAL_PA,
   GE_VAL_ACCORDATO,
   GE_VAL_UTILIZZATO,
   GE_VAL_QI,
   GE_DTA_IRIS,
   GE_DTA_PD_ONLINE,
   GE_DTA_PD_MONITORAGGIO,
   GE_GEGB_QIS_ACC,
   GE_GEGB_QIS_UTI,
   SC_VAL_PD_ONLINE,
   SC_VAL_RATING_ONLINE,
   SC_VAL_PD_MONIT_ONLINE,
   SC_VAL_RATING_MONIT_ONLINE,
   SC_VAL_IRIS,
   SC_VAL_LR,
   SC_VAL_LGD,
   SC_VAL_EAD,
   SC_VAL_PA,
   SC_VAL_ACCORDATO,
   SC_VAL_UTILIZZATO,
   SC_VAL_QI,
   SC_DTA_IRIS,
   SC_DTA_PD_ONLINE,
   SC_DTA_PD_MONITORAGGIO,
   SC_SCSB_QIS_ACC,
   SC_SCSB_QIS_UTI,
   VAL_RWA
)
AS
   SELECT E.DTA_FINE_VALIDITA,
          E.COD_ABI_CARTOLARIZZATO,
          I.DESC_ISTITUTO,
          E.COD_NDG,
          E.DESC_NOME_CONTROPARTE,
          E.COD_SNDG,
          E.COD_GRUPPO_ECONOMICO,
          G.VAL_ANA_GRE,
          E.COD_GRUPPO_LEGAME,
          E.COD_SNDG COD_SNDG_GE,
          NVL (E.COD_COMPARTO_ASSEGNATO, E.COD_COMPARTO_CALCOLATO)
             COD_COMPARTO,
          E.COD_STRUTTURA_COMPETENTE,
          U.NOME,
          U.COGNOME,
          S.COD_STRUTTURA_COMPETENTE_DC,
          S.DESC_STRUTTURA_COMPETENTE_DC,
          S.COD_STRUTTURA_COMPETENTE_RG,
          S.DESC_STRUTTURA_COMPETENTE_RG,
          S.COD_STRUTTURA_COMPETENTE_AR,
          S.DESC_STRUTTURA_COMPETENTE_AR,
          S.COD_STRUTTURA_COMPETENTE_FI,
          S.DESC_STRUTTURA_COMPETENTE_FI,
          E.COD_STATO,
          E.COD_PROCESSO,
          TRUNC (SYSDATE) - E.DTA_INTERCETTAMENTO VAL_GG_INTERCETTAMENTO,
          E.DTA_SCADENZA_STATO,
          E.DTA_COMPLETAMENTO_PEF DTA_LAST_DEL_FIDO,
          DTA_ULTIMA_REVISIONE_PEF DTA_LAST_PEF_PROPOSTA,
          E.FLG_FIDI_SCADUTI AS FLG_FIDI_SCADUTI,
          E.DAT_ULTIMO_SCADUTO AS DTA_SCADENZA_FIDO,
          E.COD_FASE_PEF VAL_LAST_FASE_PEF,
          E.COD_STRATEGIA_CRZ VAL_STRATEGIA_CREDIT,
          NULL VAL_LAST_ORGANO_DEL_CP,
          NULL VAL_CONTRASS_ORGANO_DEL_CP,
          E.FLG_CONFERMA_SAG,
          E.FLG_ALLINEATO_SAG,
          E.VAL_SCONFINO,
          E.DTA_FINE_VALIDITA DTA_LAST_UPDATE,
          E.COD_STATO_PRECEDENTE,
          E.DTA_DECORRENZA_STATO,
          E.COD_PERCORSO,
          E.COD_GRUPPO_LEGAME,
          LE.COD_LEGAME,
          DECODE (E.COD_GRUPPO_LEGAME,
                  NULL, TO_NUMBER (NULL),
                  E.VAL_PD_ONLINE)
             VAL_PD_ONLINE,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, NULL, E.VAL_RATING_ONLINE)
             VAL_RATING_ONLINE,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_NUMBER (NULL), E.VAL_PD)
             VAL_PD_MONIT_ONLINE,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, NULL, E.VAL_RATING)
             VAL_RATING_MONIT_ONLINE,
          NULL VAL_IRIS,
          NULL VAL_LR,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_NUMBER (NULL), E.VAL_LGD)
             VAL_LGD,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_NUMBER (NULL), E.VAL_EAD)
             VAL_EAD,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_NUMBER (NULL), E.VAL_PA)
             VAL_PA,
          DECODE (E.COD_GRUPPO_LEGAME,
                  NULL, TO_NUMBER (NULL),
                  E.GLGB_ACC_CASSA + E.GLGB_ACC_FIRMA)
             VAL_ACCORDATO,
          DECODE (E.COD_GRUPPO_LEGAME,
                  NULL, TO_NUMBER (NULL),
                  E.GLGB_UTI_CASSA + E.GLGB_UTI_FIRMA)
             VAL_UTILIZZATO,
          NULL VAL_QI,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_DATE (NULL), E.DTA_IRIS)
             DTA_IRIS,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_DATE (NULL), E.DTA_PD_ONLINE)
             DTA_PD_ONLINE,
          DECODE (E.COD_GRUPPO_LEGAME, NULL, TO_DATE (NULL), E.DTA_PD)
             DTA_PD_MONITORAGGIO,
          TO_NUMBER (NULLIF (E.GLGB_QIS_ACC, 'N.D.')) GLGB_QIS_ACC,
          TO_NUMBER (NULLIF (E.GLGB_QIS_UTI, 'N.D.')) GLGB_QIS_UTI,
          E.COD_GRUPPO_ECONOMICO,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.VAL_PD_ONLINE)
             VAL_PD_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_RATING_ONLINE)
             VAL_RATING_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_PD)
             VAL_PD_MONIT_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_RATING)
             VAL_RATING_MONIT_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.VAL_IRIS_GE) VAL_IRIS,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, NULL, E.LIV_RISCHIO_GE)
             VAL_LR,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_LGD)
             VAL_LGD,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_EAD)
             VAL_EAD,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_NUMBER (NULL), E.VAL_PA)
             VAL_PA,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.GEGB_ACC_CASSA + E.GEGB_ACC_FIRMA)
             VAL_ACCORDATO,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_NUMBER (NULL),
                  E.GEGB_UTI_CASSA + E.GEGB_UTI_FIRMA)
             VAL_UTILIZZATO,
          NULL VAL_QI,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_DATE (NULL), E.DTA_IRIS)
             DTA_IRIS,
          DECODE (E.COD_GRUPPO_ECONOMICO,
                  NULL, TO_DATE (NULL),
                  E.DTA_PD_ONLINE)
             DTA_PD_ONLINE,
          DECODE (E.COD_GRUPPO_ECONOMICO, NULL, TO_DATE (NULL), E.DTA_PD)
             DTA_PD_MONITORAGGIO,
          TO_NUMBER (NULLIF (E.GEGB_QIS_ACC, 'N.D.')) GEGB_QIS_ACC,
          TO_NUMBER (NULLIF (E.GEGB_QIS_UTI, 'N.D.')) GEGB_QIS_UTI,
          E.VAL_PD_ONLINE,
          E.VAL_RATING_ONLINE,
          E.VAL_PD VAL_PD_MONIT_ONLINE,
          E.VAL_RATING VAL_RATING_MONIT_ONLINE,
          E.VAL_IRIS_CLI VAL_IRIS,
          E.LIV_RISCHIO_CLI VAL_LR,
          E.VAL_LGD VAL_LGD,
          E.VAL_EAD VAL_EAD,
          E.VAL_PA VAL_PA,
          E.SCSB_ACC_CASSA + E.SCSB_ACC_FIRMA VAL_ACCORDATO,
          E.SCSB_UTI_CASSA + E.SCSB_UTI_FIRMA VAL_UTILIZZATO,
          E.SCGB_QIS_UTI VAL_QI,
          E.DTA_IRIS,
          E.DTA_PD_ONLINE,
          E.DTA_PD DTA_PD_MONITORAGGIO,
          -- sarebbe la dta_pd_monitoraggio
          TO_NUMBER (NULLIF (E.SCSB_QIS_ACC, 'N.D.')) SCSB_QIS_ACC,
          TO_NUMBER (NULLIF (E.SCSB_QIS_UTI, 'N.D.')) SCSB_QIS_UTI,
          --19.03 segnaposto rwa.. da storicizzare..
          TO_NUMBER (NULL) val_rwa
     FROM T_MCRE0_APP_STORICO_EVENTI E,
          T_MCRE0_APP_GRUPPO_LEGAME LE,
          T_MCRE0_APP_UTENTI U,
          MV_MCRE0_DENORM_STR_ORG S,
          MV_MCRE0_APP_ISTITUTI I,
          T_MCRE0_APP_ANAGR_GRE G
    WHERE     E.ID_UTENTE = U.ID_UTENTE(+)
          AND E.COD_ABI_ISTITUTO = S.COD_ABI_ISTITUTO_FI(+)
          AND E.COD_FILIALE = S.COD_STRUTTURA_COMPETENTE_FI(+)
          AND E.COD_ABI_CARTOLARIZZATO = I.COD_ABI(+)
          AND E.COD_SNDG = LE.COD_SNDG(+)
          AND E.COD_GRUPPO_ECONOMICO = G.COD_GRE(+)
          AND E.FLG_CAMBIO_STATO = 1
          AND E.FLG_CAMBIO_GESTORE = 0
          AND E.FLG_CAMBIO_COMPARTO = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRE0_APP_SCHEDA_CLIENTE_HST TO MCRE_USR;
