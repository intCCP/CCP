/* Formatted on 21/07/2014 18:34:05 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_APP_GEST_PRATICA_FASI2
(
   COD_ABI_CARTOLARIZZATO,
   COD_GRUPPO_ECONOMICO,
   COD_NDG,
   ID_AZIONE,
   DTA_INSERIMENTO,
   DTA_SCADENZA,
   FLG_STATUS,
   NOTE,
   COD_AZIONE,
   FLG_ESITO,
   COD_MACROSTATO,
   COD_STATO,
   DESCRIZIONE_AZIONE,
   COD_STATO_RISCHIO,
   COD_TIPOLOGIA_PRATICA,
   DESC_TIPO_PRATICA
)
AS
   SELECT a.cod_abi_cartolarizzato,
          NULLIF (x.cod_gruppo_economico, '-1') cod_gruppo_economico,
          A.COD_NDG,
          A.COD_PRAT_FASE,
          A.DTA_INS,
          A.DTA_SCADENZA,
          A.FLG_COMPLETATA,
          A.NOTE,
          A.ID_AZIONE,
          A.FLG_ESITO_POSITIVO,
          X.COD_MACROSTATO,
          x.cod_stato,
          NVL (t.descrizione_azione, d.desc_tipo) descrizione_azione,
          A.COD_STATO_RISCHIO,
          a.ID_tipologia_pratica,
          C.DESC_TIPO DESC_TIPO_PRATICA
     FROM T_MCRE0_APP_GEST_PRATICA_FASI a, --t_mcre0_app_rio_azioni a,        --mod
          v_mcre0_app_upd_fields_p1 x,
          t_mcre0_cl_rio_azioni t,
          (SELECT *
             FROM t_mcre0_cl_rio
            WHERE val_utilizzo = 'TIPOLOGIA_PRATICA') c,
          (SELECT *
             FROM t_mcre0_cl_rio
            WHERE val_utilizzo = 'FASE') d
    WHERE     a.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
          AND A.COD_NDG = X.COD_NDG
          AND T.COD_AZIONE(+) = A.ID_AZIONE                              --mod
          AND A.ID_TIPOLOGIA_PRATICA = C.COD_TIPO(+)
          AND A.ID_AZIONE = D.COD_TIPO(+)                                --mod
          AND a.flg_delete = 'N';
