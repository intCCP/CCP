/* Formatted on 21/07/2014 18:37:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ST_GRUPPO_LEGAME
(
   ID_DPER,
   COD_SNDG,
   COD_GRUPPO_LEGAME,
   COD_LEGAME,
   FLG_CAPOLEGAME
)
AS
   WITH c
        AS (SELECT DISTINCT ID_DPER,
                            COD_SNDG,
                            COD_GRUPPO_LEGAME,
                            COD_LEGAME,
                            1 FLG_CAPOLEGAME
              FROM (SELECT ID_DPER,
                           CASE
                              WHEN L.COD_LEGAME = 'TIT'
                              THEN
                                 L.COD_SNDG_LEGAME
                              ELSE
                                 L.COD_SNDG
                           END
                              COD_SNDG,
                              'G'
                           || LPAD (
                                 CASE
                                    WHEN L.COD_LEGAME = 'TIT'
                                    THEN
                                       L.COD_SNDG_LEGAME
                                    ELSE
                                       L.COD_SNDG
                                 END,
                                 17,
                                 '0')
                              COD_GRUPPO_LEGAME,
                           L.COD_LEGAME
                      FROM v_MCRE0_st_LEGAME l
                     WHERE L.COD_LEGAME IN ('TIT', 'FCM'))),
        t
        AS (SELECT ID_DPER,
                   COD_SNDG,
                   COD_GRUPPO_LEGAME,
                   COD_LEGAME,
                   FLG_CAPOLEGAME
              FROM c
            UNION ALL
            SELECT c.ID_DPER,
                   l.COD_SNDG,
                   c.COD_GRUPPO_LEGAME,
                   c.COD_LEGAME,
                   0 FLG_CAPOLEGAME
              FROM c, mcre_own.v_MCRE0_st_LEGAME l
             WHERE     l.COD_LEGAME = c.COD_LEGAME
                   AND l.COD_SNDG_LEGAME = c.COD_SNDG
                   AND c.COD_LEGAME = 'TIT'
            UNION ALL
            SELECT c.ID_DPER,
                   l.COD_SNDG_LEGAME COD_SNDG,
                   c.COD_GRUPPO_LEGAME,
                   c.COD_LEGAME,
                   0 FLG_CAPOLEGAME
              FROM c, mcre_own.v_MCRE0_st_LEGAME l
             WHERE     l.COD_LEGAME = c.COD_LEGAME
                   AND l.COD_SNDG = c.COD_SNDG
                   AND c.COD_LEGAME = 'FCM')
   SELECT "ID_DPER",
          "COD_SNDG",
          "COD_GRUPPO_LEGAME",
          "COD_LEGAME",
          "FLG_CAPOLEGAME"
     FROM (SELECT t.*,
                  ROW_NUMBER ()
                  OVER (PARTITION BY COD_SNDG, COD_LEGAME
                        ORDER BY FLG_CAPOLEGAME ASC)
                     myrnk
             FROM t)
    WHERE myrnk = 1;
