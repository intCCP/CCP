/* Formatted on 17/06/2014 18:06:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_STRIS_CONSISTENZA_DB
(
   REC
)
AS
   SELECT ' Verifica che lo stato di rischio delle posizioni a Sofferenza sia coerente con quanto riportato sulla All_data'
             AS REC
     FROM DUAL
   UNION
   SELECT ' ABI;NDG;DATA_PASSAGGIO_SOFFERENZA;DATA_CHIUSURA;STATO_RISCHIO;MACROSTATO;STATO;DATA_DECORRENZA_STATO;NOME_CONTROPARTE'
             AS REC
     FROM DUAL
   UNION -- Verifica che lo stato di rischio delle posizioni a Sofferenza sia coerente con quanto riportato sulla All_data
   SELECT    b.cod_abi
          || ';'
          || b.cod_ndg
          || ';'
          || b.DTA_PASSAGGIO_SOFF
          || ';'
          || b.DTA_CHIUSURA
          || ';'
          || b.COD_STATO_RISCHIO
          || ';'
          || a.COD_MACROSTATO
          || ';'
          || a.COD_STATO
          || ';'
          || a.DTA_DECORRENZA_STATO
          || ';'
          || a.DESC_NOME_CONTROPARTE
             AS REC
     FROM T_MCRES_APP_POSIZIONI b, T_MCRE0_APP_ALL_DATA a
    WHERE     a.cod_abi_cartolarizzato = b.cod_abi
          AND a.cod_ndg = b.cod_ndg
          AND b.flg_attiva = 1
          AND a.TODAY_FLG = '1'
          AND b.COD_STATO_RISCHIO = 'S'
          AND a.COD_STATO <> 'SO';


GRANT SELECT ON MCRE_OWN.V_MCRE0_STRIS_CONSISTENZA_DB TO MCRE_USR;
