/* Formatted on 21/07/2014 18:38:06 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW MCRE_OWN.V_MCRE0_ULTIMA_ACQUISIZIONE
(
   COD_FILE,
   IDPER
)
AS
     SELECT                                     -- V1 02/12/2010 VG: Congelata
           cod_file, MAX (TO_CHAR (periodo_riferimento, 'YYYYMMDD')) idper
       FROM mcre_own.t_mcre0_wrk_acquisizione w
      WHERE stato = 'CARICATO'
   GROUP BY cod_file;
