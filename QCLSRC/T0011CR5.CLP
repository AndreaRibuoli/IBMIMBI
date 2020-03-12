/******************************************************************/
/*                                                                */
/*  Part name:    T0011CR5                                        */
/*                                                                */
/*  Source file:  QATTCL in library QUSRTOOL                      */
/*                                                                */
/*  Function:     This CL program will create the objects that are*/
/*                used for example 3 in the Application Display   */
/*                Programming manual.                             */
/*                                                                */
/*                The objects created by this program are:        */
/*                                                                */
/*                    Name          Type  Description             */
/*                                                                */
/*                    T0011MG5      *MSGF Used to create *CMD &   */
/*                                        help *PNLGRP            */
/*                                                                */
/*                    T0011DD5      *PF   Physical file containin */
/*                                        data for initial panel  */
/*                                                                */
/*                    T0011DC5      *CMD  Deletes this example    */
/*                    T0011CM5      *CMD  Starts example running  */
/*                                                                */
/*                    T0011DL5      *PGM  CL program is CPP for   */
/*                                        T0011DC5 command        */
/*                    T0011CP5      *PGM  CL program is CPP for   */
/*                                        T0011CM5 command        */
/*                                                                */
/*                    T0011PN5      *PNLGRP  Panel group used by  */
/*                                           example commands     */
/*                    T0011PN6      *PNLGRP  Help panel group for */
/*                                           example              */
/*                                                                */
/*                    T0011RP5      *PGM  RPG program that contro */
/*                                        the example             */
/*                    T0011RE5      *PGM  RPG general exit progra */
/*                    T0011RL5      *PGM  RPG inc. list exit pgm  */
/*                    T0011RP6      *PGM  RPG F4=prompt program   */
/*                    T0011RF5      *PGM  RPG called by RP6       */
/*                    T0011RA5      *PGM  RPG list option exit pg */
/*                    T0011RF6      *PGM  RPG function key exit   */
/*                                                                */
/*  Publication:  Application Display Programming                 */
/*                                                                */
/******************************************************************/
/*                                                                */
/*  DISCLAIMER:                                                   */
/* These examples have not been thoroughly tested under all       */
/* conditions. IBM, therefore, cannot guarantee or imply reliabil-*/
/* ity,serviceability or function of these programs. All programs */
/* contained herein are provided 'AS IS'.  THE IMPLIED WARRANTIES */
/* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE    */
/* EXPRESSLY DISCLAIMED.  IBM may not be liable for any lost      */
/* revenue, lost profits or other consequential damages caused by */
/* the Programs even if advised of the possibilities of such      */
/* damages.  Furthermore, IBM shall not be liable for any delays  */
/* or losses or any other damages which may result from furnishing*/
/* the Program, even if advised of the possibility of such damages*/
/*                                                                */
/*  (C) Copyright IBM Corp. 1993, All rights reserved.            */
/******************************************************************/
PGM        PARM(&LIB)
  DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
  DCL &F *CHAR 10 VALUE(T0011MG5)
  /*---------------------------------------------------------------
      Create library and datafile -
  */
  CRTLIB     LIB(&LIB) AUT(*ALL)
    MONMSG     MSGID(CPF0000)
  ADDLIBLE   LIB(&LIB)
    MONMSG CPF2103
    CRTPF      FILE(&LIB/T0011DD5) SRCFILE(QUSRTOOL/QATTDDS)
    MONMSG     MSGID(CPF0000)
  /*-----------------------------------------------------------
      Create message file -                                 */

             DLTMSGF    MSGF(&LIB/&F)
             MONMSG     MSGID(CPF2105)
             CRTMSGF    MSGF(&LIB/&F)

  /*  Message 0001 is the product title and copyright.  */

  ADDMSGD USR0001 &LIB/&F 'Address Book Utility:  Sample RPG-UIM +
     program.'

  /*  These are messages used in UIM panels */

   ADDMSGD    MSGID(USR0010) MSGF(&LIB/&F) MSG('Data must +
                          be provided on the extended list entry +
                          for this action.') SECLVL('You must type +
                          data in the entry fields provided +
                          whenever you use this action on the +
                          extended list entry (the top list entry +
                          on the display.)') SEV(40)
  ADDMSGD USR0011 &LIB/&F 'The value specified for the Name is not +
     valid.' +
     'The Name cannot be blank and it must start with an uppercase +
     alphabetic character, A through Z, inclusive.' +
     sev(40)
  ADDMSGD USR0012 &LIB/&F 'No records found in T0011DD5 database' +
     'The database may be empty, or possibly someone has deleted +
  it, or renamed it, or it may be that you do not have authority +
     to view the database.'

  /*  These are messages sent by the RPG programs  */

             ADDMSGD MSGID(USR0100) MSGF(&LIB/&F) MSG('Unable to +
                     read from the t0011DD5 database.') +
                     SECLVL('An error occurred when attempting +
                     to read the database by key.  Another +
                     user may currently be changing the record +
                     or you may not have sufficient authority +
                     to the file T0011DD5.') SEV(40)
             ADDMSGD MSGID(USR0101) MSGF(&LIB/&F) MSG('Unable to +
                     update the T0011DD5 database.') +
                     SECLVL('An error occurred when attempting +
                     to update the database. You may not have +
                     sufficient authority to the file +
                     T0011DD5.') SEV(40)
             ADDMSGD MSGID(USR0102) MSGF(&LIB/&F) MSG('Unable to +
                     add record; the specified name may +
                     already exist in the T0011DD5 database.') +
                     SECLVL('An error occurred when attempting +
                     to write a new record to the T0011DD5 +
                     database.  It may be that a record with +
                     the specified name already exists in the +
                     database.  You may change the name and +
                     try to add the record again, or press F12 +
                     to cancel.  You may not have sufficient +
                     authority to the file T0011DD5.') SEV(40)
             ADDMSGD MSGID(USR0103) MSGF(&LIB/&F) MSG('Record not +
                     found in the T0011DD5 database.') +
                     SECLVL('You specified an action for a +
                     record that no longer exists in the +
                     T0011DD5 database.  Someone else may have +
                     recently deleted the record.  Press +
                     F5=Refresh to update the display to +
                     reflect the current content of the +
                     database.') SEV(40)
             ADDMSGD MSGID(USR0104) MSGF(&LIB/&F) MSG('The +
                     specified name is not found in list.') +
                     SECLVL('The action you specified requires +
                     you to type the name of an entry in the +
                     list.  The name you typed does not appear +
                     in the list.') SEV(40)
             ADDMSGD MSGID(USR0105) MSGF(&LIB/&F) MSG('Unable to +
                     delete a record from the T0011DD5 +
                     database.') SECLVL('An error occurred +
                     when attempting to delete a record from +
                     the database.  You may not have +
                     sufficient authority to the file +
                     T0011DD5.') SEV(40)
             ADDMSGD MSGID(USR0106) MSGF(&LIB/&F) MSG('A record +
                     cannot be deleted, because it is deleted +
                     already.') SECLVL('You specified an +
                     action for a record that no longer exists +
                     in the T0011DD5 database.  Someone else +
                     may have recently deleted the record.  +
                     Press F5=Refresh to update the display to +
                     reflect the current content of the +
                     database.') SEV(40)
             ADDMSGD MSGID(USR0107) MSGF(&LIB/&F) MSG('The value +
                     specified for Zip code is not valid.') +
                     SECLVL('You must specify a five digit, +
                     non-negative number for the zip code. If +
                     you do not know the zip code, type +
                     00000.') SEV(40)

  /*  These are messages used for prompts in the T0011CM5 command.*/

  ADDMSGD USR0200 &LIB/&F 'Start Address Book Utility'
  ADDMSGD USR0201 &LIB/&F 'Allow write to database'

  /*---------------------------------------------------------------
      Create panel groups -
  */
       CRTPNLGRP  PNLGRP(&LIB/T0011PN6) SRCFILE(QUSRTOOL/QATTUIM)
       CRTPNLGRP  PNLGRP(&LIB/T0011PN5) SRCFILE(QUSRTOOL/QATTUIM)
  /*---------------------------------------------------------------
      Create command and command processing program -
  */
             CRTCLPGM   PGM(&LIB/T0011CP5) SRCFILE(QUSRTOOL/QATTCL)
             CRTCMD   CMD(&LIB/T0011CM5) PGM(&LIB/T0011CP5) +
                      SRCFILE(QUSRTOOL/QATTCMD) ALLOW(*INTERACT +
                      *IPGM *IREXX *EXEC) ALWLMTUSR(*YES) +
                      PMTFILE(*LIBL/T0011MG5) +
                      HLPPNLGRP(*LIBL/T0011PN6) HLPID(*CMD) +
                      PRDLIB(&LIB)
  /*---------------------------------------------------------------
      Create RPG programs -
  */
  CRTRPGPGM  PGM(&LIB/T0011RP5) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RF6) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RF5) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RE5) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RL5) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RA5) SRCFILE(QUSRTOOL/QATTRPG)
  CRTRPGPGM  PGM(&LIB/T0011RP6) SRCFILE(QUSRTOOL/QATTRPG)

  /********************************************************/
  /*  CREATE A CL PROGRAM THAT WILL BE USED BY A THE      */
  /*  COMMAND THAT DELETES THIS TOOLS SOURCE OR OBJECT.   */
  /********************************************************/
  DLTPGM     PGM(&LIB/T0011DL5) /* DELETE POSSIBLE OLD +
             VERSION OF THE PROGRAM */
  MONMSG     MSGID(CPF2105) /* CONTINUE EVEN IF CL +
             PROGRAM WAS NOT FOUND */
  CRTCLPGM   PGM(&LIB/T0011DL5) SRCFILE(QUSRTOOL/QATTCL) +
             OPTION(*NOSRC) +
             TEXT('PROGRAM USED TO DELETE +
             EXAMPLE 3 OBJECTS')

  /********************************************************/
  /*  CREATE THE T0011DC5 COMMAND. THE PURPOSE OF THE     */
  /*  COMMAND IS TO DELETE EITHER THIS TOOLS SOURCE, OR   */
  /*  ITS CREATED OBJECTS, OR BOTH.                       */
  /********************************************************/
  DLTCMD     CMD(&LIB/T0011DC5) /* DELETE POSSIBLE OLD +
                VERSION OF THE COMMAND */

  MONMSG     MSGID(CPF2105) /* CONTINUE EVEN IF COMMAND +
                WAS NOT FOUND */
  CRTCMD     CMD(&LIB/T0011DC5) PGM(&LIB/T0011DL5) +
             SRCFILE(QUSRTOOL/QATTCMD) TEXT('COMMAND +
             TO DELETE EXAMPLE 3 OBJECTS') VLDCKR(*NONE) +
             MODE(*ALL) ALLOW(*ALL) MAXPOS(2) +
             AUT(*USE)

             SNDPGMMSG  MSG('** The build of example 3 completed +
                          successfully. Type T0011CM5.')
ENDPGM
