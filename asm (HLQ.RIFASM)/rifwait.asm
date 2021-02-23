***********************************************************************
* Project: FMT                                                        *
*                                                                     *
* This program is an assembler module that will issue a WAIT SVC on   *
* an ECB list. The ECBs should be pre-allocated and cleared to        *
* binary zeroes before calling this module. This assembler program is *
* LE compliant, and as a result is callable from Enterprise PL/1      *
* programs.                                                           *
*                                                                     *
* We do this because we want to be able to use the POST / WAIT        *
* syncronisation method provided by the z/Architecture, but which is  *
* not available to us in standard Enterprise PL/1.                    *
*                                                                     *
* !!! THE ECBs HAVE TO BE FULLWORD ALIGNED !!!                        *
*                                                                     *
* This program WILL NOT clean up the ECB that is WAITed upon, after   *
* it has been POSTed.                                                 *
*                                                                     *
******************************************************************[v]**
* Registers upon entry;                                               *
*  R1  - Points to caller's parameter list.                           *
*  R12 - Points to LE CAA (automatic from PL/1)                       *
*  R13 - Points to caller's DSA on entry.                             *
*  R14 - Return address.                                              *
*  R15 - Entry address.                                               *
*                                                                     *
*                                                                     *
* Touched registers;                                                  *
*  R0  - Number of ECBs to wait on.                                   *
*  R1  - Pointer to ECB.                                              *
*  R12 - Used as a base register.                                     *
*  R15 - Return code upon exit.                                       *
*                                                                     *
*                                                                     *
******************************************************************[v]**
* Parameter list;                                                     *
*                                                                     *
* R1 -> [Pointer to first parameter]                                  *
*        +-> [Pointer to ECBLIST to WAIT on.]                         *
*             +-> [Pointer to first ECB to WAIT on.]                  *
*             +-> [Pointer to second ECB to WAIT on.]                 *
*             +-> [Pointer to ... ECB to WAIT on.]                    *
******************************************************************[v]**
        TITLE 'RIFWAIT'
        LCLC &MODULE
&MODULE SETC 'RIFWAIT'
&MODULE CSECT
&MODULE AMODE 31
&MODULE RMODE 31
*
R0      EQU   0
R1      EQU   1
R2      EQU   2
R3      EQU   3
R4      EQU   4
R5      EQU   5
R6      EQU   6
R7      EQU   7
R8      EQU   8
R9      EQU   9
R10     EQU   10
R11     EQU   11
R12     EQU   12
R13     EQU   13
R14     EQU   14
R15     EQU   15
*
        STM r14,r12,12(r13) Store registers in prev DSA save area.
        USING RIFWAIT,r12   Use r12 as our base.
        LR   r12,r15        Load r12 with r15 (addr of this module)
*
        LA   r0,1(0,r0)     Load 1 in to r0, amount of ECBs to wait on.
        L    r1,0(,r1)      Load addr of first parm in r1.
        L    r1,0(,r1)      Load addr of ECB List in r1.
*       SVC  1              SVC 1 = WAIT
        WAIT 1,ECBLIST=(1),LONG=YES
*
        LM r14,r12,12(r13)  Restore registers.
        SR r15,r15          Retcode = 0
        BR r14              Return from whence we came.
*
        END
