***********************************************************************
*                                                                     *
* This program interfaces with z/OS provided means to receive console *
* communication. Currently it will simply return when it is detected  *
* that a command was directed to it from a console.                   *
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
*                                                                     *
* Irrelevant, all registers are restored upon return.                 *
*                                                                     *
******************************************************************[v]**
* Parameter list;                                                     *
*                                                                     *
*        0                        7                                   *
* R1 -> [Pointer to first parameter]                                  *
*        |    0                 7                                     *
*        +-> [Pointer to parmlist]                                    *
*                                                                     *
******************************************************************[v]**
        TITLE 'RIFCMND'
        LCLC &MODULE
&MODULE SETC 'RIFCMND'
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
* -----------------------------------------------------------------
* Set up addressability of PARMLST DSECT.
* -----------------------------------------------------------------
        LR  r12,r15                Load r12 with r15.
        USING RIFCMND,r12         Use r12 as our base.
        STM r14,r12,SVAREA         Save registers.
*
        L  R3,0(,R1)
        L  R3,0(,R3)
*       L  R3,0(,R3)

        USING PARMLST,R3           Establish addressability.
*
        ST R3,BASE
        LA R9,COMPTR
* -----------------------------------------------------------------
* Set up communication with the console.
* -----------------------------------------------------------------
ESTAB   EXTRACT (R9),FIELDS=COMM,MF=(E,EXTR)
        L R4,COMPTR                Pointer to comm fields
        LA R5,4(,R4)               Loc of ptr of first CIB in R2
        L  R6,0(,R5)               Address of first CIB in R6
        LTR R6,R6                  If zero -> no first CIB.
        BZ LISTEN                  No first CIB, no need to clear.
*
CLEAR   QEDIT ORIGIN=(R5),BLOCK=(R6) Clear first CIB.
        WTO 'RIF0001I - CLEARED START CIB'
*
LISTEN  L R4,COMPTR                Pointer to comm fields
        LA R5,0(,R4)               Loc of ptr to ECB in R2.
        L R6,0(,R5)                Ptr to ECB in R2.
        WAIT 1,ECB=(R6)            Wait for ECB to be posted.
*
EVAL    L R4,COMPTR                Pointer to comm fields
        LA R5,4(,R4)               Loc of ptr of first CIB in R2
        L  R6,0(,R5)               Address of first CIB in R6
*
        CLI 4(R6),X'40'            Is this a stop command?
        BE STOP                    Yes? Stop.
        WTO 'RIF0002E - NOT A STOP COMMAND'
        B RET                      No? Stop.
STOP    MVI SHTDWN,C'Y'            Notify calling task of shtdwn.
        WTO 'RIF0099I - STOP COMMAND RECEIVED'
CLEAR2  QEDIT ORIGIN=(R5),BLOCK=(R6) Clear stop CIB.
        WTO 'RIF0098I - CLEARED STOP CIB'
        L    R1,ECBPTR             LOAD ADDR OF STOP ECB
        POST (1),0                 POST ECB TO SIGNAL STOP
*
* -----------------------------------------------------------------
* Restore registers and return.
* -----------------------------------------------------------------
RET     LM r14,r12,SVAREA          Restore registers.
        SR r15,r15                 Retcode = 0
        BR r14                     Return from whence we came.
* -----------------------------------------------------------------
* Variables.
* -----------------------------------------------------------------
        DS 0D
EXTR    EXTRACT MF=L
        DS 0D
        DC CL8'RIFEYE_2'
BASE    DS 1F
SVAREA  DS 16F                     SAVE AREA
* -----------------------------------------------------------------
* Parmlist.
*
* We abuse the parmlist. CBA coding a GETMAIN, so we make PL/1
* provide an area to store the communication list.
* -----------------------------------------------------------------
*
PARMLST DSECT
*       DS 0D
        DS CL8
ECBPTR  DS XL4                     POINTER TO ECB TO POST
COMPTR  DS XL4                     EXTRACT ANSWER AREA
SHTDWN  DS XL1'00'                 SHUTDOWN INDICATOR
* -----------------------------------------------------------------
        END
