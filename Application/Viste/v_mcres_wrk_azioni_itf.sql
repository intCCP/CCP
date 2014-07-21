/* Formatted on 21/07/2014 18:44:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_WRK_AZIONI_ITF
(
   ID_DPER,
   COD_ABI,
   COD_AUTORIZZAZIONE,
   COD_AZIONE
)
AS
       SELECT id_dper,
              DECODE (cod_abi, '3069', '01025', cod_abi) cod_abi,
              cod_autorizzazione,
              cod_azione
         FROM t_mcres_wrk_xml_itf,
              XMLTABLE (
                 '/SPESE/SPESA/AZIONI/AZIONE'
                 PASSING t_mcres_wrk_xml_itf.xml_content
                 COLUMNS id_dper VARCHAR2 (255) PATH 'id_dper',
                         cod_abi VARCHAR2 (255) PATH 'Cod_Abi',
                         cod_autorizzazione VARCHAR2 (255)
                               PATH 'Cod_Autorizzazione',
                         cod_azione VARCHAR2 (255) PATH 'Cod_Azione');
