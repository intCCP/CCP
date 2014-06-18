/* Formatted on 17/06/2014 18:09:12 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_AGENDA
(
   ID,
   COD_MATRICOLA,
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   DTA_INIZIO_APPUNTAMENTO,
   DESCRIZIONE,
   DTA_FINE_APPUNTAMENTO,
   OGGETTO,
   COD_PRESIDIO
)
AS
   SELECT a.id,
          a.COD_MATRICOLA,
          a.COD_ABI,
          a.COD_NDG,
          P.COD_SNDG,
          G.DESC_NOME_CONTROPARTE,
          A.DTA_INIZIO_APPUNTAMENTO,
          a.DESCRIZIONE,
          A.DTA_FINE_APPUNTAMENTO,
          A.OGGETTO,
          A.COD_PRESIDIO
     FROM T_MCRES_APP_AGENDA a,
          T_MCRES_APP_POSIZIONI P,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO G
    WHERE     a.COD_ABI = P.COD_ABI(+)
          AND A.COD_NDG = P.COD_NDG(+)
          AND P.COD_SNDG = G.COD_SNDG(+);


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_AGENDA TO MCRE_USR;
