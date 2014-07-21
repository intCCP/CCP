/* Formatted on 21/07/2014 18:47:01 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRES_CONTROPARTITE_ITF
(
   ID_DPER,
   COD_ABI,
   COD_CONTROPARTITA,
   COD_TIPO,
   COD_DIVISA,
   VAL_IMPORTO,
   COD_FILIALE,
   COD_AUTORIZZAZIONE
)
AS
        SELECT                           -- 20121008     AG  Created this view
              id_dper,
               DECODE (cod_abi, '3069', '01025', cod_abi) cod_abi,
               cod_contropartita,
               cod_tipo,
               cod_divisa,
               val_importo,
               cod_filiale,
               cod_autorizzazione
          FROM XMLTABLE (
                  '/SPESE/SPESA/CONTROPARTITE/CONTROPARTITA'
                  PASSING xmltype (
                             BFILENAME ('D_MCRES_WORK',
                                        'MOPLE_20121012_03069.FLUSSOSPESE.xml'),
                             NLS_CHARSET_ID ('AL16UTF16LE'))
                  COLUMNS id_dper VARCHAR2 (200) PATH 'id_dper',
                          COD_Abi VARCHAR2 (255) PATH 'COD_Abi',
                          COD_Contropartita VARCHAR2 (255)
                                PATH 'COD_Contropartita',
                          Cod_Tipo VARCHAR2 (255) PATH 'Cod_Tipo',
                          Cod_Divisa VARCHAR2 (255) PATH 'Cod_Divisa',
                          Val_Importo VARCHAR2 (255) PATH 'Val_Importo',
                          Cod_Filiale VARCHAR2 (255) PATH 'Cod_Filiale',
                          Cod_Autorizzazione VARCHAR2 (255)
                                PATH 'Cod_Autorizzazione');
