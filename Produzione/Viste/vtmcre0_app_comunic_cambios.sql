/* Formatted on 17/06/2014 18:15:36 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_COMUNIC_CAMBIOS
(
   COD_PERCORSO,
   COD_ABI_CARTOLARIZZATO,
   COD_ABI_ISTITUTO,
   COD_NDG,
   DESC_NOME_CONTROPARTE,
   VAL_ANA_GRE,
   COD_STATO,
   DTA_DECORRENZA_STATO,
   COD_STATO_PRECEDENTE,
   DTA_DECORRENZA_STATO_PRE,
   ID_UTENTE,
   COD_COMPARTO
)
AS
   SELECT                                                 /*   + first_rows */
          -- V1 02/12/2010 VG: Congelata
          -- V1 17/12/2010 VG: LAG eliminata
          -- V2 13/01/2011 MM: invertica condizione <=15gg!
          -- V3 16/02/2011 VG: upd_field
          -- V4 14/03/2011 VG: comparo
          -- v5 14/04/2011 VG: FLG_OUTSOURCING=Y
          -- v6 20/04/2011 VG: FLG_OUTSOURCING=Y x storico e target='Y'
          -- v7 09/06/2011 VG: Tolta MOPLE
          X.COD_PERCORSO,
          X.COD_ABI_CARTOLARIZZATO,
          X.COD_ABI_ISTITUTO,
          X.COD_NDG,
          X.DESC_NOME_CONTROPARTE,
          X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
          X.COD_STATO,
          X.DTA_DECORRENZA_STATO,
          DECODE (X.COD_STATO_PRECEDENTE,
                  '-1', 'BO',
                  NULL, 'BO',
                  X.COD_STATO_PRECEDENTE)
             COD_STATO_PRECEDENTE,
          X.DTA_DECORRENZA_STATO_PRE,
          NULLIF (X.ID_UTENTE, -1) ID_UTENTE,
          X.COD_COMPARTO
     FROM VTMCRE0_APP_UPD_FIELDS X
    WHERE     X.DTA_DECORRENZA_STATO BETWEEN (TRUNC (SYSDATE) - 15)
                                         AND (TRUNC (SYSDATE) + 1)
          AND X.ID_UTENTE <> -1
          AND X.COD_STATO != X.COD_STATO_PRECEDENTE
          AND X.FLG_OUTSOURCING = 'Y'
          AND X.FLG_TARGET = 'Y'
          AND X.FLG_CHK = '1'
          AND FLG_STATO_CHK = '1';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_COMUNIC_CAMBIOS TO MCRE_USR;
