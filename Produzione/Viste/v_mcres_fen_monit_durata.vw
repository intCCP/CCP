/* Formatted on 17/06/2014 18:12:34 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_FEN_MONIT_DURATA
(
   COD_ABI,
   ID_DPER,
   VAL_ANNOMESE,
   VAL_GBV,
   VAL_NBV,
   VAL_IND_COP,
   COD_DURATA,
   COD_GARANTITO
)
AS
     SELECT C.COD_ABI,
            C.ID_DPER,
            SUBSTR (C.ID_DPER, 1, 6) VAL_ANNOMESE,
            SUM (C.VAL_UTI_RET) VAL_GBV,
            SUM (C.VAL_ATT) VAL_NBV,
            DECODE (SUM (C.VAL_UTI_RET),
                    0, 0,
                    (1 - SUM (C.VAL_ATT) / SUM (C.VAL_UTI_RET)))
               val_ind_cop,
            CASE
               WHEN C.VAL_FIRMA IN ('ORD', 'AGES')
               THEN
                  'BT'
               WHEN C.VAL_FIRMA IN ('AGMI', 'FOND', 'CREDIOP', 'IMI')
               THEN
                  'MLT'
               ELSE
                  'ALTRO'
            END
               COD_DURATA,
            CASE
               WHEN   VAL_IMP_GARANZIE_PERSONALI
                    + VAL_IMP_GARANZIA_IPOTECARIA
                    + VAL_IMP_GARANZIE_PIGNORATIZIE
                    + VAL_IMP_GARANZIE_ALTRE
                    + VAL_IMP_GARANZIE_ALTRI > 0
               THEN
                  1
               ELSE
                  0
            END
               cod_garantito
       FROM T_MCRES_APP_SISBA_CP C, t_mcres_app_sisba t
      WHERE     c.cod_abi = t.cod_abi(+)
            AND c.cod_ndg = t.cod_ndg(+)
            AND c.id_dper = t.id_dper(+)
            AND C.COD_RAPPORTO = T.COD_RAPPORTO_SISBA(+)
            AND C.COD_SPORTELLO = T.COD_FILIALE_RAPPORTO(+)
            AND C.COD_STATO_RISCHIO = 'S'
   GROUP BY C.COD_ABI,
            c.ID_DPER,
            CASE
               WHEN C.VAL_FIRMA IN ('ORD', 'AGES')
               THEN
                  'BT'
               WHEN C.VAL_FIRMA IN ('AGMI', 'FOND', 'CREDIOP', 'IMI')
               THEN
                  'MLT'
               ELSE
                  'ALTRO'
            END,
            CASE
               WHEN   VAL_IMP_GARANZIE_PERSONALI
                    + VAL_IMP_GARANZIA_IPOTECARIA
                    + VAL_IMP_GARANZIE_PIGNORATIZIE
                    + VAL_IMP_GARANZIE_ALTRE
                    + VAL_IMP_GARANZIE_ALTRI > 0
               THEN
                  1
               ELSE
                  0
            END;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK, MERGE VIEW ON MCRE_OWN.V_MCRES_FEN_MONIT_DURATA TO MCRE_USR;
