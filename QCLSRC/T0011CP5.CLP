/******************************************************************/
/*                                                                */
/*  Part name:    T0011CP5                                        */
/*                                                                */
/*  Source file:  QATTCMD in library QUSRTOOL                     */
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
PGM PARM(&ALWCHG)
  DCL &ALWCHG *char 1

  ALCOBJ     OBJ((T0011DD5 *FILE *SHRUPD *FIRST))
    monmsg cpf0000 exec(do)
      SNDPGMMSG  MSGID(CPF1999) MSGF(QCPFMSG)
      return
    enddo

  if (&alwchg = '1') then( +
    OVRDBF     FILE(T0011DD5) WAITFILE(3) WAITRCD(3) SEQONLY(*NO) )
  else +
    OVRDBF     FILE(T0011DD5) WAITFILE(3) WAITRCD(3) +
                 INHWRT(*YES) SEQONLY(*NO)
  call t0011rp5
    monmsg (cpf0000 mch0000 rpg0000 cpd0000) exec( +
      SNDPGMMSG  MSGID(CPF1999) MSGF(QCPFMSG) )
  DLCOBJ     OBJ((T0011DD5 *FILE *SHRUPD *FIRST))
ENDPGM
