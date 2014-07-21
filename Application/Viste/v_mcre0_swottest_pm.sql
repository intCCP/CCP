/* Formatted on 21/07/2014 18:38:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_SWOTTEST_PM
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_PERCORSO,
   ID_PIANO,
   ID_WORKFLOW,
   DTA_INS,
   DTA_UPD,
   DTA_CONFERMA,
   COD_MATRICOLA,
   COD_RIGA,
   COD_COLONNA,
   VAL_NOTE
)
AS
   SELECT p.COD_ABI_CARTOLARIZZATO,
          p.COD_NDG,
          p.COD_PERCORSO,
          p.ID_PIANO,
          p.ID_WORKFLOW,
          s.DTA_INS,
          s.DTA_UPD,
          s.DTA_CONFERMA,
          s.COD_MATRICOLA,
          c.COD_RIGA,
          c.COD_COLONNA,
          c.VAL_NOTE
     FROM T_MCRE0_APP_GEST_PM p
          LEFT JOIN
          T_MCRE0_SWOTTEST_PM s
             ON     p.COD_ABI_CARTOLARIZZATO = s.COD_ABI_CARTOLARIZZATO
                AND p.COD_NDG = s.COD_NDG
                AND p.COD_PERCORSO = s.COD_PERCORSO
                AND p.ID_PIANO = s.ID_PIANO
          LEFT JOIN
          T_MCRE0_CELLA_SWOTTEST_PM c
             ON     s.COD_ABI_CARTOLARIZZATO = c.COD_ABI_CARTOLARIZZATO
                AND s.COD_NDG = c.COD_NDG
                AND s.COD_PERCORSO = c.COD_PERCORSO
                AND s.ID_PIANO = c.ID_PIANO;
