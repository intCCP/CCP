/* Formatted on 21/07/2014 18:44:38 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_CONTROPARTITE_ITF
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
        SELECT                           -- 20121107     AG  Created this view
              id_dper,
               DECODE (cod_abi, '3069', '01025', cod_abi) cod_abi,
               cod_contropartita,
               cod_tipo,
               cod_divisa,
               val_importo,
               cod_filiale,
               cod_autorizzazione
          FROM t_mcres_wrk_xml_itf,
               XMLTABLE (
                  '/SPESE/SPESA/CONTROPARTITE/CONTROPARTITA'
                  PASSING t_mcres_wrk_xml_itf.xml_content
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
