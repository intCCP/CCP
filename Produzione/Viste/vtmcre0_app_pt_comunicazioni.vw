/* Formatted on 17/06/2014 18:16:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VTMCRE0_APP_PT_COMUNICAZIONI
(
   COD_ABI_CARTOLARIZZATO,
   COD_NDG,
   COD_SNDG,
   DESC_NOME_CONTROPARTE,
   COD_MATRICOLA_GESTORE,
   COD_TIPO_COMUNICAZIONE,
   DTA_INVIO_COMUNICAZIONE,
   ID_UTENTE,
   ID_REFERENTE,
   COD_COMPARTO
)
AS
   SELECT c.cod_abi_cartolarizzato,
          c.cod_ndg,
          c.cod_sndg,
          A.DESC_NOME_CONTROPARTE,
          cod_matricola_gestore,
          cod_tipo_comunicazione,
          dta_invio_comunicazione,
          P.ID_UTENTE,
          u.id_referente,
          p.cod_comparto
     FROM T_MCRE0_APP_PT_COMUNICAZIONI c,
          T_MCRE0_APP_ANAGRAFICA_GRUPPO a,
          VTMCRE0_APP_UPD_FIELDS_P1 p,
          t_mcre0_app_utenti u
    WHERE     C.COD_ABI_CARTOLARIZZATO = P.COD_ABI_CARTOLARIZZATO
          AND c.cod_ndg = p.cod_ndg
          AND c.cod_sndg = a.cod_sndg
          AND p.id_utente = u.id_utente;


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MCRE_OWN.VTMCRE0_APP_PT_COMUNICAZIONI TO MCRE_USR;
