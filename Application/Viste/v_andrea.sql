/* Formatted on 21/07/2014 18:30:59 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_ANDREA
(
   N
)
AS
   SELECT COUNT (*) n
     FROM (       SELECT id_dper_spese,
                         id_dper_azioni,
                         id_dper_contropartite,
                         id_dper_fatture,
                         LPAD (cod_abi_spese, 5, '0'),
                         LPAD (cod_abi_azioni, 5, '0'),
                         LPAD (cod_abi_contropartite, 5, '0'),
                         LPAD (cod_abi_rapporti, 5, '0')
                    FROM XMLTABLE (
                            'SPESE/SPESA'
                            PASSING xmltype (
                                       BFILENAME ('D_MCRES_WORK',
                                                  'MOPLE_20121012_03069.ANDREA.xml'),
                                       NLS_CHARSET_ID ('AL16UTF16LE'))
                            COLUMNS id_dper_spese VARCHAR2 (512) PATH 'id_dper',
                                    id_dper_azioni VARCHAR2 (512)
                                          PATH 'AZIONI/AZIONE/id_dper',
                                    id_dper_contropartite VARCHAR2 (512)
                                          PATH 'CONTROPARTITE/CONTROPARTITA/id_dper',
                                    id_dper_fatture VARCHAR2 (512)
                                          PATH 'FATTURE/FATTURA/id_dper',
                                    cod_abi_spese VARCHAR2 (512) PATH 'Cod_Abi',
                                    cod_abi_azioni VARCHAR2 (512)
                                          PATH 'AZIONI/AZIONE/Cod_Abi',
                                    cod_abi_contropartite VARCHAR2 (512)
                                          PATH 'CONTROPARTITE/CONTROPARTITA/COD_Abi',
                                    cod_abi_rapporti VARCHAR2 (512)
                                          PATH 'RAPPORTI/RAPPORTO/COD_Abi')
           MINUS
           SELECT '20121012',
                  '20121012',
                  '20121012',
                  '20121012',
                  '01025',
                  '01025',
                  '01025',
                  '01025'
             FROM DUAL);
