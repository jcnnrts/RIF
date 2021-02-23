//RIFBPKG  JOB ...
//BINDPKA  EXEC PGM=IKJEFT01
//STEPLIB  DD DISP=SHR,DSN=<DB2HLQ>.SDSNEXIT
//         DD DISP=SHR,DSN=<DB2HLQ>.SDSNLOAD
//DBRMLIB  DD DISP=SHR,DSN=<RIFHLQ>.SRIFDBRM
//*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(<SUBSYSTEM>)

 BIND PACKAGE (RIF)                    -
      MEMBER(RIFMAIN) -
      QUALIFIER(RIF)                   -
      OWNER(???????)                   -
      ACTION(REPLACE)                  -
      ISOLATION(CS)                    -
      VALIDATE(RUN)                    -
      EXPLAIN (NO)                     -
      ENCODING(EBCDIC)
/*