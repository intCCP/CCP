
create or replace view V_MCREI_DAY_POSMCI as
select to_number(DATA_FLUSSO) as ID_DPER, 
       COD_ABI, 
       lpad(COD_NDG,16,'0') as cod_ndg, 
       ESPOSIZIONE_OGGI, 
       ESPOSIZIONE_IERI,
       nvl(GESTORE,'-1') as ID_UTENTE
from MCRE_OWN.TE_MCREI_POSMCI;

GRANT SELECT ON MCRE_OWN.V_MCREI_DAY_POSMCI TO MCRE_USR;
