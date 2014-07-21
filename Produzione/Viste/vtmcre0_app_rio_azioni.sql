/* Formatted on 17/06/2014 18:16:32 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_RIO_AZIONI
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
          a.cod_ndg,
          a.id_azione,
          a.dta_inserimento,
          a.dta_scadenza,
          a.flg_status,
          a.note,
          a.cod_azione,
          a.flg_esito,
          x.cod_macrostato,
          x.cod_stato,
          NVL (t.descrizione_azione, d.desc_tipo) descrizione_azione,
          a.cod_stato_rischio,
          a.cod_tipologia_pratica,
          c.desc_tipo desc_tipo_pratica
     FROM t_mcre0_app_rio_azioni a,
          vtmcre0_app_upd_fields_p1 x,
          t_mcre0_cl_rio_azioni t,
          (SELECT *
             FROM t_mcre0_cl_rio
            WHERE val_utilizzo = 'FASE') c,
          (SELECT *
             FROM t_mcre0_cl_rio
            WHERE val_utilizzo = 'TIPOLOGIA_PRATICA') d
    WHERE     a.cod_abi_cartolarizzato = x.cod_abi_cartolarizzato
          AND a.cod_ndg = x.cod_ndg
          AND t.cod_azione(+) = a.cod_azione
          AND a.cod_tipologia_pratica = c.cod_tipo(+)
          AND a.cod_azione = d.cod_tipo(+)
          AND a.flg_delete = 0;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_RIO_AZIONI TO MCRE_USR;
