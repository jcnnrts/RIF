//RIFASMC  JOB ...
//*---------------------------------------------------------------------
//ASM      EXEC PGM=ASMA90,REGION=6M,
//            PARM='DECK,NOOBJECT,LIST,XREF(SHORT),NORENT'
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//         DD DSN=SYS1.MODGEN,DISP=SHR
//         DD DSN=<RIFHLQ>.RIFASM,DISP=SHR
//         DD DSN=CEE.SCEEMAC,DISP=SHR
//SYSUT1   DD UNIT=3390,SPACE=(CYL,(15,1))
//SYSUT2   DD UNIT=3390,SPACE=(CYL,(15,1))
//SYSUT3   DD UNIT=3390,SPACE=(CYL,(15,1))
//SYSPUNCH DD DSN=&&OBJSET,UNIT=3390,SPACE=(80,(800,100)),
//            DISP=(NEW,PASS)
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DSN=<RIFHLQ>.RIFASM(RIFWAIT),DISP=SHR
//*---------------------------------------------------------------------
//LKED     EXEC PGM=IEWL,REGION=3M,
//            PARM='XREF,LET,LIST,MAP,AC=1,NORENT,AMODE=31,RMODE=ANY',
//            COND=(8,LE,ASM)
//SYSUT1   DD UNIT=3390,SPACE=(1024,(200,20))
//SYSLMOD  DD DSN=<RIFHLQ>.RIFLOAD(RIFWAIT),DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSLIB   DD DISP=SHR,DSN=CEE.SCEELKED
//         DD DISP=SHR,DSN=CEE.SCEEBIND
//         DD DISP=SHR,DSN=CEE.SCEEBND2
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//         DD DDNAME=SYSIN
//SYSIN    DD *
   NAME  RIFWAIT(R)
/*