/* Formatted on 21/07/2014 18:47:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRES_FATTURE_ITF
(
   ID_DPER,
   COD_AUTORIZZAZIONE,
   VAL_IMPONIBILE_IVA,
   VAL_ALIQUOTA_IVA,
   VAL_IMPORTO_IVA,
   VAL_IMPORTO_POS,
   COD_SAP_IVA,
   COD_SAP_SOCIETA
)
AS
             SELECT id_dper,
                    cod_autorizzazione,
                    val_imponibile_iva,
                    val_aliquota_iva,
                    val_importo_iva,
                    val_importo_pos,
                    cod_sap_iva,
                    SUBSTR (cod_autorizzazione, 1, 4) cod_sap_societa
               FROM XMLTABLE (
                       '/SPESE/SPESA/FATTURE/FATTURA'
                       PASSING xmltype (
                                  BFILENAME ('D_MCRES_WORK',
                                             'MOPLE_20121012_03069.FLUSSOSPESE.xml'),
                                  NLS_CHARSET_ID ('AL16UTF16LE'))
                       COLUMNS id_dper VARCHAR2 (255) PATH 'id_dper',
                               Cod_Autorizzazione VARCHAR2 (255)
                                     PATH 'Cod_Autorizzazione',
                               Val_Imponibile_IVA VARCHAR2 (255)
                                     PATH 'Val_Imponibile_IVA',
                               Val_Aliquota_IVA VARCHAR2 (255) PATH 'Val_Aliquota_IVA',
                               Val_Importo_IVA VARCHAR2 (255) PATH 'Val_Importo_IVA',
                               Val_Importo_POS VARCHAR2 (255) PATH 'Val_Importo_POS',
                               Cod_SAP_Iva VARCHAR2 (255) PATH 'Cod_SAP_Iva');
