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
        STM   r14,r12,12(r13) Store registers in prev DSA save area.
        USING RIFCMND,r12  Use r12 as our base.
        LR    r12,r15       Load r12 with r15 (addr of this module)
*
* -----------------------------------------------------------------
* ATTACH the module with the hardcoded name.
* -----------------------------------------------------------------
        L R1,0(,R1)
        L R1,0(,R1)
        ST R1,FPARM
        WTO 'RIF0001I - PERFORMING ATTACH'
        LA  R1,FPARM
        ATTACH EP=RIFCMND,PARAM=FPARM,MF=(E,ATCH)
        LTR R15,R15                Check retcode.
        BNZ FEK                    Retcode ^= 0.
        WTO 'RIF0001I - ATTACH PERFORMED'
        B RET                      Retcode = 0, branch to ret.
FEK     WTO 'RIF0001I - ATTACH NOT PERFORMED'
        DC XL8'00000000'           We force an abend because lazy.
* -----------------------------------------------------------------
* Restore registers and return.
* -----------------------------------------------------------------
RET     LM r14,r12,12(r13)         Restore registers.
        SR r15,r15                 Retcode = 0
        BR r14                     Return from whence we came.
* -----------------------------------------------------------------
* Parmlist.
*
* We abuse the parmlist. CBA coding a GETMAIN, so we make PL/1
* provide an area to store the communication list.
* -----------------------------------------------------------------
        DS 0D
ATCH    ATTACH SF=L
        DC CL8'RIFCMND_'
FPARM   DC A(0)
* -----------------------------------------------------------------
        END
