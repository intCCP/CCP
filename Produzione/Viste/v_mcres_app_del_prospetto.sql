/* Formatted on 17/06/2014 18:10:04 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_DEL_PROSPETTO
(
   COD_GRUPPO,
   COD_ABI,
   VAL_ANNOMESE,
   VAL_TIPO_GESTIONE,
   COD_LABEL,
   DESC_LABEL,
   VAL_NUM_DEL,
   VAL_CREDITO_LORDO,
   VAL_CREDITO_NETTO_ANTE_PRO,
   VAL_RETTIFICA,
   VAL_CREDITO_NETTO,
   VAL_CREDITO_NETTO_POST,
   VAL_IMP_OFFERTO,
   VAL_ESBORSO_PREVISTO,
   VAL_ESBORSO,
   VAL_EFFETTO_CONTO_ECO,
   VAL_TOT_DELIBERE,
   COD_UO_PRATICA,
   COD_STATO_DELIBERA
)
AS
   SELECT a."COD_GRUPPO",
          a."COD_ABI",
          a."VAL_ANNOMESE",
          a."VAL_TIPO_GESTIONE",
          a."COD_LABEL",
          a."DESC_LABEL",
          a."VAL_NUM_DEL",
          a."VAL_CREDITO_LORDO",
          a."VAL_CREDITO_NETTO_ANTE_PRO",
          a."VAL_RETTIFICA",
          a."VAL_CREDITO_NETTO",
          a."VAL_CREDITO_NETTO_POST",
          a."VAL_IMP_OFFERTO",
          a."VAL_ESBORSO_PREVISTO",
          a."VAL_ESBORSO",
          a."VAL_EFFETTO_CONTO_ECO",
          SUM (a.VAL_NUM_DEL) OVER (PARTITION BY a.COD_GRUPPO)
             val_tot_delibere,
          cod_uo_pratica,
          cod_stato_delibera
     FROM (  SELECT L.COD_GRUPPO,
                    P.COD_ABI,
                    P.VAL_ANNOMESE,
                    VAL_TIPO_GESTIONE,
                    L.COD_LABEL,
                    L.DESCRIZIONE DESC_LABEL,
                    cod_uo_pratica,
                    cod_stato_delibera,
                    SUM (VAL_NUM_del) VAL_NUM_del,
                    SUM (VAL_ESPOSIZIONE_LORDA_CAP) VAL_CREDITO_LORDO,
                    SUM (VAL_ESPOSIZIONE_NETTA_ANTE_DEL)
                       VAL_CREDITO_NETTO_ANTE_PRO,
                    SUM (VAL_RETTIFICA_VALORE_PROP) VAL_RETTIFICA,
                    SUM (VAL_ESPOSIZIONE_NETTA_ANTE_DEL) VAL_CREDITO_NETTO,
                    SUM (VAL_ESPOSIZIONE_NETTA_POST_DEL) VAL_CREDITO_NETTO_post,
                    SUM (VAL_IMPORTO_OFFERTO) VAL_IMP_OFFERTO,
                    SUM (VAL_ESBORSO_PREVISTO) VAL_ESBORSO_PREVISTO,
                    SUM (VAL_ESBORSO) VAL_ESBORSO,
                    CASE
                       WHEN l.COD_GRUPPO = 2
                       THEN
                            SUM (VAL_IMPORTO_OFFERTO)
                          - SUM (VAL_ESPOSIZIONE_NETTA_ANTE_DEL)
                       ELSE
                          SUM (0)
                    END
                       VAL_EFFETTO_CONTO_ECO
               FROM V_MCRES_APP_DEL_PROSPETTO_POS P, T_MCRES_CL_LABELS L
              WHERE     L.COD_UTILIZZO = 'DELIBERE_PROSPETTO'
                    AND L.COD_GRUPPO = P.cod_GRUPPO(+)
                    AND L.COD_LABEL = P.COD_LABEL(+)
           GROUP BY l.COD_GRUPPO,
                    P.COD_ABI,
                    P.VAL_ANNOMESE,
                    VAL_TIPO_GESTIONE,
                    L.COD_LABEL,
                    L.DESCRIZIONE,
                    cod_uo_pratica,
                    cod_stato_delibera) a;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_APP_DEL_PROSPETTO TO MCRE_USR;
