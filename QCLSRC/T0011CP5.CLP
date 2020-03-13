             PGM        PARM(&ALWCHG)
             DCL        VAR(&ALWCHG) TYPE(*CHAR) LEN(1)
             ALCOBJ     OBJ((T0011DD5 *FILE *SHRUPD *FIRST))
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSGID(CPF1999) MSGF(QCPFMSG)
             RETURN
             ENDDO
   /*                                                             */
   /*  INHWRT:  Specifica se i record elaborati vengono scritti,  */
   /*  cancellati o aggiornati nel file di database. Il parametro */
   /*  di inibizione scrittura consente di provare un programma   */
   /*  senza memorizzare nel database i record elaborati. Questo  */
   /*  parametro sostituisce temporaneamente il parametro INHWRT  */
   /*  negli altri comandi OVRDBF immessi precedentemente.        */
   /*                                                             */
             IF         COND(&ALWCHG = '1') THEN(OVRDBF +
                          FILE(T0011DD5) WAITFILE(3) WAITRCD(3) +
                          SEQONLY(*NO))
             ELSE       CMD(OVRDBF FILE(T0011DD5) WAITFILE(3) +
                          WAITRCD(3) INHWRT(*YES) SEQONLY(*NO))
             CALL       PGM(T0011RP5)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPD0000) +
                          EXEC(SNDPGMMSG MSGID(CPF1999) MSGF(QCPFMSG))
   /*                                                                                   */
   /*   ID messaggio . . . . . . . . :   CPF1999                                        */
   /*   File dei messaggi  . . . . . :   QCPFMSG                                        */
   /*     Libreria . . . . . . . . . :     QSYS                                         */
   /*   Testo del messaggio  . . . . :   Si sono verificati degli errori nel comando.   */
   /*                                                                                   */
             DLCOBJ     OBJ((T0011DD5 *FILE *SHRUPD *FIRST))
             ENDPGM
