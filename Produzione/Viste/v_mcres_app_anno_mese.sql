/* Formatted on 17/06/2014 18:09:45 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_ANNO_MESE (VAL_ANNOMESE)
AS
   SELECT DISTINCT                                -- Vista per tendina portale
                  VAL_ANNOMESE
     FROM V_MCRES_ULTIMA_ACQUISIZIONE A
    WHERE A.COD_FLUSSO = 'SISBA';


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_ANNO_MESE TO MCRE_USR;
