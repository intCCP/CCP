/* Formatted on 21/07/2014 18:33:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_API
(
   COD_ABI_ISTITUTO,
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_STATO,
   FLG_OUTSOURCING,
   COD_MATRICOLA,
   COD_STRUTTURA_COMPETENTE,
   RECORD_CHAR
)
AS
   SELECT fg.COD_ABI_ISTITUTO,
          fg.COD_ABI_CARTOLARIZZATO,
          fg.COD_NDG,
          DECODE (fg.COD_STATO, 'RS', 'IN', fg.COD_STATO) COD_STATO,
          fg.FLG_OUTSOURCING,
          UT.COD_MATRICOLA,
          O.COD_STRUTTURA_COMPETENTE,
          '                   ' AS record_char
     FROM MV_MCRE0_APP_UPD_FIELD fg
          INNER JOIN T_MCRE0_APP_ISTITUTI ist
             ON ist.COD_ABI = fg.COD_ABI_CARTOLARIZZATO
          LEFT JOIN
          T_MCRE0_APP_STRUTTURA_ORG O
             ON     SUBSTR (O.COD_COMPARTO, -5, 5) =
                       SUBSTR (fg.COD_COMPARTO, -5, 5)
                AND fg.COD_ABI_ISTITUTO = o.COD_ABI_ISTITUTO
          LEFT JOIN T_MCRE0_APP_UTENTI UT ON UT.ID_UTENTE = FG.ID_UTENTE
    WHERE     fg.COD_COMPARTO IS NOT NULL
          AND fg.COD_STATO IS NOT NULL
          AND ist.flg_outsourcing = 'Y'
          AND flg_cartolarizzato IS NULL
          AND flg_segregato IS NULL;