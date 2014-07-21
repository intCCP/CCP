/* Formatted on 21/07/2014 18:30:53 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.T_MCRES_APP_UTENTI
(
   ID_UTENTE,
   COD_MATRICOLA,
   COD_FISCALE,
   COGNOME,
   NOME,
   FLG_GESTORE_ABILITATO,
   COD_PRESIDIO,
   VAL_SOCIETA,
   VAL_SOCIETA_UOG,
   COD_MACRO,
   DESC_MACRO,
   COD_CLONE,
   VAL_INDIRIZZO,
   VAL_COMUNE,
   VAL_PROV,
   VAL_CAP,
   VAL_TELEFONO,
   VAL_FAX,
   VAL_CELLULARE,
   VAL_EMAIL,
   COD_FIGURA_PROFESSIONALE,
   DESC_FIGURA_PROFESSIONALE
)
AS
   SELECT cod_userid id_utente,
          cod_matricola,
          NULL cod_fiscale,
          val_cognome cognome,
          val_nome nome,
          '1' flg_gestore_abilitato,
          DECODE (
             SUBSTR (cod_punto_operativo, 1, 1),
             2,    '0'
                || SUBSTR (cod_punto_operativo,
                           2,
                           LENGTH (cod_punto_operativo)),
             cod_punto_operativo)
             cod_presidio,
          val_societa,
          val_societa_uog,
          cod_macro,
          desc_macro,
          cod_clone,
          val_indirizzo,
          val_comune,
          val_prov,
          val_cap,
          val_telefono,
          val_fax,
          val_cellulare,
          val_email,
          cod_figura_professionale,
          desc_figura_professionale
     FROM t_mcres_app_gestori;
