CREATE TABLE MCRE_OWN.TE_MCREI_POSMCI_DT
   (	PERIODO_RIF VARCHAR2(8 BYTE)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "D_MCRE0_ITT"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE 
        STRING SIZES ARE IN BYTES
        BADFILE 'D_MCRE0_BAD':'TE_MCREI_POSMCI_DT.bad'
        NODISCARDFILE
        LOGFILE 'D_MCRE0_LOG':'TE_MCREI_POSMCI_DT.log'
    FIELDS
    MISSING FIELD VALUES ARE NULL(
    "PERIODO_RIF" POSITION(1:8) CHAR(8),
     FILLER POSITION(9:34) CHAR(6) 
    )
        )
      LOCATION
       ( "D_MCRE0_ITT":'POSMCI.10637')
    )
   REJECT LIMIT UNLIMITED ;

GRANT SELECT ON MCRE_OWN.TE_MCREI_POSMCI_DT TO MCRE_USR;