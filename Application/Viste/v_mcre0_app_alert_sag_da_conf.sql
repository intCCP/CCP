CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_ALERT_SAG_DA_CONF
AS select "VAL_ALERT", "VAL_ORDINE_COLORE", "DTA_INS_ALERT", "COD_SNDG", "COD_NDG", "COD_ABI_CARTOLARIZZATO", "COD_ABI_ISTITUTO", "COD_COMPARTO_POSIZIONE", "COD_RAMO_CALCOLATO", "COD_MACROSTATO", "COD_COMPARTO_UTENTE", "DESC_ISTITUTO", "COD_GRUPPO_ECONOMICO", "VAL_ANA_GRE", "DESC_NOME_CONTROPARTE", "COD_STRUTTURA_COMPETENTE_DC", "DESC_STRUTTURA_COMPETENTE_DC", "COD_STRUTTURA_COMPETENTE_RG", "DESC_STRUTTURA_COMPETENTE_RG", "COD_STRUTTURA_COMPETENTE_AR", "DESC_STRUTTURA_COMPETENTE_AR", "COD_STRUTTURA_COMPETENTE_FI", "DESC_STRUTTURA_COMPETENTE_FI", "COD_PROCESSO", "COD_STATO", "DTA_DECORRENZA_STATO", "DTA_SCADENZA_STATO", "ID_UTENTE", "DTA_UTENTE_ASSEGNATO", "DESC_NOME", "DESC_COGNOME", "DTA_CALCOLO_SAG", "COD_SAG", "COD_PRIV", "FLG_GESTORE_ABILITATO", "ID_REFERENTE", "FLG_ABI_LAVORATO", "VAL_UTI_TOT"
 from (
  SELECT    /*+ordered no_parallel(a) no_parallel(t)*/
                -- v1 06/04/2011 VG: sistemate condizioni where
                -- v2 08/04/2011 VG Modificata da DeMattia
                -- v3 20/04/2011 VG: FLG_ABI_LAVORATO
                -- v4 06/05/2011 VG: COD_MACROSTATO
                -- 21.08.13 utilizzato
                -- v5 25/09/2014 FabC: Aggiunto stato e colore nel calcolo RANK.
                ALERT_1 VAL_ALERT,
                (SELECT     DECODE (
                                 ALERT_1,
                                 'V',
                                 VAL_VERDE,
                                 DECODE (ALERT_1,
                                            'A', VAL_ARANCIO,
                                            DECODE (ALERT_1, 'R', VAL_ROSSO, NULL))
                             )
                    FROM     T_MCRE0_APP_ALERT
                  WHERE     ID_ALERT = 1)
                    VAL_ORDINE_COLORE,
                DTA_INS_1 DTA_INS_ALERT,
                A.COD_SNDG,
                A.COD_NDG,
                A.COD_ABI_CARTOLARIZZATO,
                A.COD_ABI_ISTITUTO,
                X.COD_COMPARTO COD_COMPARTO_POSIZIONE,
                X.COD_RAMO_CALCOLATO,
                X.COD_MACROSTATO,
                --  NVL (x.cod_comparto_assegn, x.cod_comparto_appart) cod_comparto_utente
                X.COD_COMPARTO_UTENTE,
                X.DESC_ISTITUTO,
                X.COD_GRUPPO_ECONOMICO,
                X.DESC_GRUPPO_ECONOMICO VAL_ANA_GRE,
                X.DESC_NOME_CONTROPARTE,
                X.COD_STRUTTURA_COMPETENTE_DC,
                X.DESC_STRUTTURA_COMPETENTE_DC,
                X.COD_STRUTTURA_COMPETENTE_RG,
                X.DESC_STRUTTURA_COMPETENTE_RG,
                X.COD_STRUTTURA_COMPETENTE_AR,
                X.DESC_STRUTTURA_COMPETENTE_AR,
                X.COD_STRUTTURA_COMPETENTE_FI,
                X.DESC_STRUTTURA_COMPETENTE_FI,
                X.COD_PROCESSO,
                X.COD_STATO,
                X.DTA_DECORRENZA_STATO,
                X.DTA_SCADENZA_STATO,
                X.ID_UTENTE,
                X.DTA_UTENTE_ASSEGNATO,
                X.NOME DESC_NOME,
                X.COGNOME DESC_COGNOME,
                T.DTA_CALCOLO_SAG,
                T.COD_SAG,
                X.COD_PRIV,
                X.FLG_GESTORE_ABILITATO,
                X.ID_REFERENTE,
                --i.FLG_ABI_LAVORATO,
                DECODE (
                    DTA_ABI_ELAB,
                    (SELECT     MAX (DTA_ABI_ELAB) DTA_ABI_ELAB_MAX
                        FROM     T_MCRE0_APP_ABI_ELABORATI),
                    '1',
                    '0'
                )
                    FLG_ABI_LAVORATO,
                X.SCSB_UTI_TOT VAL_UTI_TOT ,
              --rank() over ( partition by x.cod_sndg order by x.cod_ndg)    r
              rank() over ( partition by x.cod_sndg, x.cod_macrostato, ALERT_1 order by x.cod_ndg)    r
      FROM    T_MCRE0_APP_ALERT_POS A,
             -- V_MCRE0_APP_UPD_FIELDS_ALL x
             -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
             V_MCRE0_APP_UPD_FIELDS X, T_MCRE0_APP_SAG T
     WHERE         ALERT_1 IS NOT NULL
                AND X.FLG_OUTSOURCING = 'Y'
                AND X.FLG_TARGET = 'Y'
                AND X.COD_ABI_CARTOLARIZZATO = A.COD_ABI_CARTOLARIZZATO
                AND X.COD_NDG = A.COD_NDG
                AND X.COD_SNDG = T.COD_SNDG(+)
        ) sg
        where sg.r = 1;
