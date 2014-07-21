/* Formatted on 21/07/2014 18:47:02 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.X_MCRES_RAPPORTI_ITF
(
   ID_DPER,
   COD_AUTORIZZAZIONE,
   COD_ABI,
   COD_NDG,
   COD_RAPPORTO,
   COD_CONTROPARTITA,
   COD_FILIALE_COMPETENTE,
   FLG_TIPO_RAPPORTO,
   COD_PRODOTTO
)
AS
    SELECT id_dper,
           cod_autorizzazione,
           DECODE (cod_abi, '3069', '01025', cod_abi) cod_abi,
           cod_ndg,
           cod_rapporto,
           cod_contropartita,
           cod_filiale_competente,
           flg_tipo_rapporto,
           cod_prodotto
      FROM XMLTABLE (
              '/SPESE/SPESA'
              PASSING xmltype (
                         BFILENAME ('D_MCRES_WORK',
                                    'MOPLE_20121012_03069.FLUSSOSPESE.xml'),
                         NLS_CHARSET_ID ('AL16UTF16LE'))
              COLUMNS id_dper VARCHAR2 (200) PATH 'RAPPORTI/RAPPORTO/id_dper',
                      cod_autorizzazione VARCHAR2 (255)
                            PATH 'Cod_Autorizzazione',
                      cod_abi VARCHAR2 (255) PATH 'RAPPORTI/RAPPORTO/COD_Abi',
                      cod_ndg VARCHAR2 (255) PATH 'NDG',
                      cod_rapporto VARCHAR2 (255)
                            PATH 'RAPPORTI/RAPPORTO/Cod_Rapporto',
                      cod_contropartita VARCHAR2 (255)
                            PATH 'RAPPORTI/RAPPORTO/COD_Contropartita',
                      cod_filiale_competente VARCHAR2 (255)
                            PATH 'RAPPORTI/RAPPORTO/Cod_Filiale_Competente',
                      flg_tipo_rapporto VARCHAR2 (255)
                            PATH 'RAPPORTI/RAPPORTO/Flg_Tipo_Rapporto',
                      cod_prodotto VARCHAR2 (255)
                            PATH 'RAPPORTI/RAPPORTO/Cod_Prodotto');
