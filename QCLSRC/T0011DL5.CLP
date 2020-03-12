/******************************************************************/
/*                                                                */
/*  Part name:  T0011DL5                                          */
/*                                                                */
/*  Source file:QATTCL in library QUSRTOOL                        */
/*                                                                */
/*  Function:   This CL program can be used to delete the objects */
/*              that were created by the T0011CR5 CL program. It  */
/*              can also be used to delete the source that was    */
/*              used to create those objects.                     */
/*                                                                */
/*              This program is the command processing program for*/
/*              the T0011CR5 command and should never be used     */
/*              by anything except that command.                  */
/*                                                                */
/*              The only object not deleted by this program is the*/
/*              program itself.                                   */
/*                                                                */
/*  Publication:Application Display Programming                   */
/*                                                                */
/******************************************************************/

             PGM        PARM(&LIB &SOURCE)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SOURCE) TYPE(*CHAR) LEN(1)

             IF         COND(&SOURCE *EQ 'N') THEN(GOTO +
                          CMDLBL(SKIPSRC))

             RMVM       FILE(QUSRTOOL/QATTDDS) MBR(T0011DD5)
             MONMSG     MSGID(CPF0000)

             RMVM       FILE(QUSRTOOL/QATTUIM) MBR(T0011PN5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTUIM) MBR(T0011PNI)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTUIM) MBR(T0011PN6)
             MONMSG     MSGID(CPF0000)

             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RP5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RE5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RF5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RA5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RF6)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RL5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RP6)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RI7)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RI6)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTRPG) MBR(T0011RI5)
             MONMSG     MSGID(CPF0000)

             RMVM       FILE(QUSRTOOL/QATTCL) MBR(T0011CP5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTCL) MBR(T0011CR5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTCL) MBR(T0011DL5)
             MONMSG     MSGID(CPF0000)

             RMVM       FILE(QUSRTOOL/QATTCMD) MBR(T0011CM5)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(QUSRTOOL/QATTCMD) MBR(T0011DC5)
             MONMSG     MSGID(CPF0000)


 SKIPSRC:    IF         COND(&LIB *EQ '*NONE     ') THEN(GOTO +
                          CMDLBL(END))

             CHKOBJ     OBJ(&LIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(NOTOK))
             GOTO       CMDLBL(OK)
 NOTOK:      SNDPGMMSG  MSG('Library not found. ')
             GOTO       CMDLBL(END)
 OK:

             DLTPGM     PGM(&LIB/T0011CR5)
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011CP5)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(&LIB/T0011DD5)
             MONMSG     MSGID(CPF2105)

             DLTPGM     PGM(&LIB/T0011RE5)
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RF5) /* Delete F4 prompt +
                          program */
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RP5) /* Delete main program*/
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RA5) /* Delete list option +
                          exit */
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RF6) /* Delete function key +
                          exit */
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RL5) /* Incomplete list exit*/
             MONMSG     MSGID(CPF2105)
             DLTPGM     PGM(&LIB/T0011RP6) /* Delete F4 program */
             MONMSG     MSGID(CPF2105)

             DLTMSGF    MSGF(&LIB/T0011MG5) /* Delete the message +
                          file used to build command and its help +
                          text */
             MONMSG     MSGID(CPF2105)

             DLTCMD     CMD(&LIB/T0011CM5) /* Delete the command +
                          that starts the example */
             MONMSG     MSGID(CPF2105)

             DLTCMD     CMD(&LIB/T0011DC5) /* Delete the command +
                          that is used to delete this example */
             MONMSG     MSGID(CPF2105)

             DLTPNLGRP  PNLGRP(&LIB/T0011PN5) /* Delete main panel +
                          group */
             MONMSG     MSGID(CPF2105)
             DLTPNLGRP  PNLGRP(&LIB/T0011PN6) /* Delete example +
                          help panel group */
             MONMSG     MSGID(CPF2105)

 END:        ENDPGM
