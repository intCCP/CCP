/* Formatted on 21/07/2014 18:44:57 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.VNMCRE0_APP_AGENDA
(
   ID,
   ID_UTENTE,
   COD_NDG,
   COD_ABI_CARTOLARIZZATO,
   DTA_INIZIO_APPUNTAMENTO,
   DESCRIZIONE,
   DTA_FINE_APPUNTAMENTO,
   DESC_NOME_CONTROPARTE,
   COD_GRUPPO_ECONOMICO,
   VAL_ANA_GRE
)
AS
   SELECT                                          -- v1 VG 21/04/2011 : Nuova
         a."ID",
          a."ID_UTENTE",
          a."COD_NDG",
          a."COD_ABI_CARTOLARIZZATO",
          a."DTA_INIZIO_APPUNTAMENTO",
          a."DESCRIZIONE",
          a."DTA_FINE_APPUNTAMENTO",
          f.DESC_NOME_CONTROPARTE,
          f.cod_gruppo_economico,
          f.desc_gruppo_economico val_ana_gre
     FROM T_MCRE0_APP_AGENDA A,               ---V_MCRE0_APP_UPD_FIELDS_ALL  F
       -- todo_verificare che sia sufficiente lavorare sulla partizione attiva
           V_MCRE0_APP_UPD_FIELDS F
    WHERE     A.COD_ABI_CARTOLARIZZATO = F.COD_ABI_CARTOLARIZZATO(+)
          AND A.COD_NDG = F.COD_NDG(+)
--  AND F.COD_SNDG = G.COD_SNDG(+)
-- AND f.cod_gruppo_economico = ge.cod_gre(+)
;
