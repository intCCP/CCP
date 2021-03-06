CREATE TABLE MCRE_OWN.TE_MCREI_LGD_PAR_BAD
(
BAD VARCHAR2(533 BYTE)
) 
ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY D_MCRE0_BAD
      ACCESS PARAMETERS
      ( RECORDS FIXED 533 CHARACTERSET WE8EBCDIC500
        NOBADFILE
        NODISCARDFILE
        NOLOGFILE
        FIELDS (
                BAD CHAR (533)
               )                                      
      )
      LOCATION
       ( D_MCRE0_BAD:'LGD_PAR.bad')
    )
   REJECT LIMIT UNLIMITED;

GRANT SELECT ON MCRE_OWN.TE_MCREI_LGD_PAR_BAD TO MCRE_APP;
GRANT SELECT ON MCRE_OWN.TE_MCREI_LGD_PAR_BAD TO MCRE_USR;
CREATE PUBLIC SYNONYM TE_MCREI_LGD_PAR_BAD FOR MCRE_OWN.TE_MCREI_LGD_PAR_BAD;
