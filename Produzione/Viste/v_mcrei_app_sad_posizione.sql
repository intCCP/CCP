/* Formatted on 17/06/2014 18:08:47 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCREI_APP_SAD_POSIZIONE
(
   COD_ABI,
   COD_NDG,
   COD_SNDG,
   COD_PROTOCOLLO_PACCHETTO,
   COD_SAD,
   VAL_ORDINALE
)
AS
   (SELECT SAD_POSIZ_PACC.COD_ABI AS COD_ABI,
           SAD_POSIZ_PACC.COD_NDG AS COD_NDG,
           SAD_POSIZ_PACC.COD_SNDG AS COD_SNDG,
           SAD_POSIZ_PACC.COD_PROTOCOLLO_PACCHETTO
              AS COD_PROTOCOLLO_PACCHETTO,
           NVL (CODICI_SAD.COD_SAD, '-1') AS COD_SAD,
           NVL (CODICI_SAD.VAL_ORDINALE, -1) AS VAL_ORDINALE
      FROM (SELECT DISTINCT VAL_ORDINALE, COD_SAD FROM T_MCRE0_CL_SAD) CODICI_SAD,
           (  SELECT DELIBERE.COD_ABI AS COD_ABI,
                     DELIBERE.COD_NDG AS COD_NDG,
                     DELIBERE.COD_SNDG AS COD_SNDG,
                     DELIBERE.COD_PROTOCOLLO_PACCHETTO
                        AS COD_PROTOCOLLO_PACCHETTO,
                     MAX (
                        NVL (
                           SAD.VAL_ORDINALE,
                           (SELECT NVL (SAD1.VAL_ORDINALE, -1)
                              FROM T_MCRE0_APP_ALL_DATA ALL_DATA,
                                   T_MCRE0_CL_SAD SAD1
                             WHERE     ALL_DATA.COD_ABI_CARTOLARIZZATO =
                                          DELIBERE.COD_ABI
                                   AND ALL_DATA.COD_NDG = DELIBERE.COD_NDG
                                   AND ALL_DATA.COD_SNDG = DELIBERE.COD_SNDG
                                   AND SAD1.COD_MACROSTATO(+) =
                                          DECODE (ALL_DATA.COD_STATO,
                                                  'RS', 'RS',
                                                  'IN', 'IN',
                                                  '--'))))
                        AS VAL_ORDINALE
                FROM T_MCREI_APP_DELIBERE DELIBERE, T_MCRE0_CL_SAD SAD
               WHERE     DELIBERE.FLG_NO_DELIBERA = 0 -- nel calcolo del SAD vengono prese in considerazione solamente del delibere non flaggate
                     AND DELIBERE.COD_FASE_DELIBERA = 'CM' -- il calcolo del SAD viene effettuato prima del calcolo OD
                     -- (ossia quando tutte le microtipologie del pacchetto hanno superato il Controllo Dati
                     -- COD_FASE_PACCHETTO = 'CMP'; COD_FASE_MICROTIPOLOGIA = 'CMP'; COD_FASE_DELIBERA = 'CM')
                     AND SAD.COD_MACROSTATO(+) =
                            DECODE (
                               DELIBERE.COD_MICROTIPOLOGIA_DELIB,
                               'CS', 'SO',
                               'CZ', 'SO',
                               'CI', 'IN',
                               'CH', DECODE (DELIBERE.COD_CAUSA_CHIUS_DELIBERA,
                                             '30', 'RIO',
                                             'BO'),
                               'CX', DECODE (DELIBERE.COD_CAUSA_CHIUS_DELIBERA,
                                             '30', 'RIO',
                                             'BO'),
                               'B8', DECODE (
                                        DELIBERE.COD_CAUSA_CHIUS_DELIBERA,
                                        'CI', DECODE (
                                                 DELIBERE.COD_STATO_PROPOSTO,
                                                 'SO', 'SO',
                                                 'IN'),
                                        'CR', DECODE (
                                                 DELIBERE.COD_STATO_PROPOSTO,
                                                 'BO', 'BO',
                                                 'RIO'),
                                        'BO'),
                               '-1')
            GROUP BY DELIBERE.COD_ABI,
                     DELIBERE.COD_NDG,
                     DELIBERE.COD_SNDG,
                     DELIBERE.COD_PROTOCOLLO_PACCHETTO) SAD_POSIZ_PACC
     WHERE CODICI_SAD.VAL_ORDINALE(+) = SAD_POSIZ_PACC.VAL_ORDINALE);


GRANT SELECT ON MCRE_OWN.V_MCREI_APP_SAD_POSIZIONE TO MCRE_USR;
