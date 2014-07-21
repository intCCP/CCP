/* Formatted on 21/07/2014 18:42:37 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_APP_PRATICHE_CH
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_MATR_PRATICA,
   COD_UO_PRATICA,
   DESC_MOTIVAZIONE,
   DTA_CHIUSURA,
   DESC_NOME_CONTROPARTE,
   DESC_NOME_GESTORE
)
AS
   SELECT P."COD_ABI",
          P."COD_NDG",
          z."COD_SNDG",
          P."COD_MATR_PRATICA",
          P."COD_UO_PRATICA",
          N.DESC_NOTIZIA "DESC_MOTIVAZIONE",
          P."DTA_CHIUSURA",
          G.DESC_NOME_CONTROPARTE,
          U.COGNOME || ' ' || U.NOME desc_nome_gestore
     FROM T_MCRES_APP_PRATICHE P,
          T_MCRES_APP_POSIZIONI Z,
          T_MCRES_app_notizie n,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO G,
          T_MCRES_APP_ISTITUTI I,
          T_MCRES_APP_utenti u
    WHERE     P.FLG_ATTIVA = 0
          AND Z.FLG_ATTIVA = 0
          AND P.COD_ABI = Z.COD_ABI
          AND P.COD_NDG = Z.COD_NDG
          AND P.COD_ABI = n.COD_ABI
          AND P.COD_NDG = N.COD_NDG
          AND P.COD_PRATICA = N.COD_PRATICA
          AND P.COD_MATR_PRATICA = U.COD_MATRICOLA(+)
          AND P.COD_MATR_PRATICA IS NOT NULL
          AND N.COD_TIPO_NOTIZIA IN
                 ('06',
                  '07',
                  '08',
                  '12',
                  '13',
                  '15',
                  '16',
                  '18',
                  '30',
                  '35',
                  '60')
          AND TRUNC (SYSDATE) - TRUNC (P.DTA_CHIUSURA) < 90
          AND z.COD_SNDG = G.COD_SNDG
          AND P.COD_ABI = i.COD_ABI;
