/* Formatted on 21/07/2014 18:44:33 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRES_ULTIMA_ACQUISIZIONE2
(
   COD_FILE,
   IDPER
)
AS
     SELECT                                     -- V1 02/12/2010 VG: Congelata
           cod_file, MAX (TO_CHAR (id_dper, 'YYYYMMDD')) idper
       FROM mcre_own.t_mcres_wrk_acquisizione w
      WHERE cod_stato = 'CARICATO'
   GROUP BY cod_file;
