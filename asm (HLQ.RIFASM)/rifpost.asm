***********************************************************************
* Project: FMT                                                        *
*                                                                     *
* This program is an assembler module that will issue a POST SVC on   *
* an ECB that is provided in a parameter. The assembler module is LE- *
* compliant, and as a result is callable from an Enterprise PL/1      *
* program.                                                            *
*                                                                     *
* We do this because we want to be able to use the POST / WAIT        *
* syncronisation method provided by the z/Architecture, but which is  *
* not available to us in standard Enterprise PL/1.                    *
*                                                                     *
* The ECB to POST should be pre-allocated because there should be a   *
* WAIT pending on it already.                                         *
*                                                                     *
* This program WILL NOT clean up the ECB that is POSTed. It is up to  *
* the calling PL/1 program to feng-shui the ECB.                      *
*                                                                     *
******************************************************************[v]**
* Registers upon entry;                                               *
*  R1  - Points to caller's parameter list. [1]                       *
*  R12 - Points to LE CAA.                                            *
*  R13 - Points to caller's DSA on entry.                             *
*  R14 - Return address.                                              *
*  R15 - Entry address.                                               *
*                                                                     *
*                                                                     *
* Touched registers;                                                  *
*  R15 - Return code upon exit.                                       *
*                                                                     *
*                                                                     *
******************************************************************[v]**
* Parameter list;                                                     *
*                                                                     *
*        0                        7                                   *
* R1 -> [Pointer to first parameter]                                  *
*        |    0                    8                                  *
*        +-> [Pointer to ECB to POST]                                 *
*             |    0        31                                        *
*             +-> [ECB to POST]                                       *
*                                                                     *
******************************************************************[v]**
        TITLE 'RIFPOST'
        LCLC &MODULE
&MODULE SETC 'RIFPOST'
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
        STM r14,r12,12(r13) Store registers in previous DSA's save area
        USING RIFPOST,R12   r12 is base register.
        LR R12,R15          Load r12 with r15 (start of this module).
*
        SR r0,r0            Zero r0.
        L r1,0(,r1)         Load r1 with addr of first parameter.
        L r1,0(,r1)         Load r1 with addr of the ECB.
        SVC 2               SVC 2 = POST.
*
        LM r14,r12,12(r13)  Restore registers.
        SR r15,r15          Retcode = 0.
        BR r14              Return from whence we came.
*
        END
