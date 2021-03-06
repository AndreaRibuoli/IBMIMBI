            PGM        PARM(&SRCMBR)
            DCLF       FILE(QMISRC)
            DCL        VAR(&SRCMBR)     TYPE(*CHAR) LEN(10)
            DCL        VAR(&MIPGMSRC)   TYPE(*CHAR) LEN(32767)
            DCL        VAR(&MIPGMSRCSZ) TYPE(*CHAR) LEN(4)
            DCL        VAR(&OFFSET)     TYPE(*DEC)  LEN(5 0) VALUE(1)
            DCL        VAR(&PGMNAM)     TYPE(*CHAR) LEN(20)  VALUE('          *CURLIB   ')
            DCL        VAR(&PGMTXT)     TYPE(*CHAR) LEN(50) +
                         VALUE('Compare two packed arguments and return larger')
            DCL        VAR(&PGMSRCF)    TYPE(*CHAR) LEN(20)  VALUE('*NONE')
            DCL        VAR(&PGMSRCM)    TYPE(*CHAR) LEN(10)  VALUE(' ')
            DCL        VAR(&PGMSRCCHG)  TYPE(*CHAR) LEN(13)  VALUE(' ')
            DCL        VAR(&PRTFNAM)    TYPE(*CHAR) LEN(20)  VALUE('QSYSPRT   *LIBL     ')
            DCL        VAR(&PRTSTRPAG)  TYPE(*INT)  LEN(4)   VALUE(1)
            DCL        VAR(&PGMPUBAUT)  TYPE(*CHAR) LEN(10)  VALUE('*ALL      ')
            DCL        VAR(&PGMOPTS)    TYPE(*CHAR) LEN(22)  VALUE('*LIST      *REPLACE   ')
            DCL        VAR(&NUMOPTS)    TYPE(*INT)  LEN(4)   VALUE(2)
LOOP:       RCVF
            MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CRTPGM))
            CHGVAR     VAR(%SST(&MIPGMSRC &OFFSET 132)) VALUE(&SRCDTA)
            CHGVAR     VAR(&OFFSET) VALUE(&OFFSET + 132)
            GOTO       CMDLBL(LOOP)
CRTPGM:     CHGVAR     VAR(%SST(&PGMNAM 1 10)) VALUE(&SRCMBR)
            CHGVAR     VAR(%BIN(&MIPGMSRCSZ)) VALUE(&OFFSET)
            CALL       PGM(QSYS/QPRCRTPG) PARM(&MIPGMSRC +
                         &MIPGMSRCSZ &PGMNAM &PGMTXT &PGMSRCF +
                         &PGMSRCM &PGMSRCCHG &PRTFNAM &PRTSTRPAG +
                         &PGMPUBAUT &PGMOPTS &NUMOPTS)
            ENDPGM
