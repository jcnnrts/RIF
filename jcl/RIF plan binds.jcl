//RIFBPLAN JOB ...
//BINDPLAN EXEC PGM=IKJEFT01
//STEPLIB  DD DISP=SHR,DSN=<DB2HLQ>.SDSNEXIT
//         DD DISP=SHR,DSN=<DB2HLQ>.SDSNLOAD
//DBRMLIB  DD DISP=SHR,DSN=<RIFHLQ>.SRIFDBRM
//*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(<SUBSYSTEM>)

 BIND PLAN     (RIF)            -
      PKLIST   (RIF.*)          -
      OWNER    (???????)        -
      ACTION   (REPLACE)        -
      EXPLAIN  (NO)             -
      RETAIN                    -
      VALIDATE (BIND)           -
      ENCODING (EBCDIC)         -
      ISOLATION(CS)
/*