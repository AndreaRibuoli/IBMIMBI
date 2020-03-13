      ***********************************************************************
      * UIMPLIST - PLISTS per richiamare le API UIM APIs da RPG ILE
      *
      * Questo codice richiede le variabili dichiarate in VAR4PLIST.
      * Per usare questi membri sorgente, copia VAR4PLIST e UIMPLIST
      * nel file QRPGLESRC della tua libreira di sviluppo.
      * Digita le seguenti istruzioni nel codice del tuo programma
      * RPG ILE in posizione corretta:
      *      /COPY VAR4PLIST
      *      /COPY UIMPLIST
      * Nel tuo programma avrai anche necessità di definire una DS
      * chiamata VARRCD e che contenga tutte le variabili di dialogo
      * utilizzate per comunicare con UIM (nello stesso ordine in cui
      * sono definite in UIM).
      *
      ************************************************************************
      *   NOTA:  I parametri marcati (con *) sono OUTPUT (modificati da UIM)
      ************************************************************************
      *          QUIADDLE
     C     ADDLE         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    VARRCD                         VARIABL RCD
     C                   PARM                    VARLEN                         VARRCD LEN
     C                   PARM                    VARNAM                         VARRCD NAME
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    ADDOPT                         LOCATION OPT
     C                   PARM                    LEHNDL                         *LST ENT HND
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIADDPW
     C     ADDPW         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    WINLOC                         POPUP LOCATE
     C                   PARM                    WINROW                         ROW
     C                   PARM                    WINCOL                         COLUMN
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIADDPA
     C     ADDPA         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    PRTFNM                         PRTF NAME
     C                   PARM                    ALTFNM                         ALT FILENAME
     C                   PARM                    SHARE                          SH OPEN DATA
     C                   PARM                    USRDTA                         USER DATA
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUICLOA
     C     CLOA          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    CLOOPT                         M=NORMAL
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIDLTL
     C     DLTL          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIDSPP (SHORT FORM)
     C     DSP           PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    FNCREQ                         *FUNC REQSTD
     C                   PARM                    PNLNAM                         PANEL NAME
     C                   PARM                    REDISP                         REDISPLAY OPT
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIDSPP (LONG FORM)
     C     DSPP          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    FNCREQ                         *FUNC REQUSTED
     C                   PARM                    PNLNAM                         PANEL NAME
     C                   PARM                    REDISP                         REDISPLAY OPT
     C                   PARM                    ERRCOD                         *ERROR CODE
     C                   PARM                    USRTSK                         USER TASK
     C                   PARM                    STKCNT                         PGM STACK CNT
     C                   PARM                    MSGQUE                         MESSAGE QUEUE
     C                   PARM                    MSGKEY                         MSG REF KEY
     C                   PARM                    CURPOS                         CSR POSITION
     C                   PARM                    LASTLE                         LAST LIST ENT
     C                   PARM                    ERRLE                          ERROR LST ENT
     C                   PARM                    WTIME                          WAIT TIME
      *          QUIGETV
     C     GETV          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    VARRCD                         *VARIABL BUF
     C                   PARM                    VARLEN                         VARRCD LEN
     C                   PARM                    VARNAM                         VARRCD NAME
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIGETLE
     C     GETLE         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    VARRCD                         *VARIABL BUF
     C                   PARM                    VARLEN                         VARRCD LEN
     C                   PARM                    VARNAM                         VARRCD NAME
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    POSOPT                         POSN OPTION
     C                   PARM                    CPYOPT                         COPY OPTION
     C                   PARM                    SLTCRI                         SELECT CRIT
     C                   PARM                    SLTHND                         SELECT HNDL
     C                   PARM                    EXTOPT                         EXTEND OPTIO
     C                   PARM                    LEHNDL                         *LST ENT HAN
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIOPNDA
     C     OPNDA         PLIST
     C                   PARM                    APPHND                         *APPL HANDLE
     C                   PARM                    PNLGRP                         QUAL. PNL GRP
     C                   PARM                    SCOPE                          APPL SCOPE
     C                   PARM                    EXITIN                         EXIT PGM INT
     C                   PARM                    FULHLP                         FULL SCRN HELP
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIOPNPA
     C     OPNPA         PLIST
     C                   PARM                    APPHND                         *APPL HANDLE
     C                   PARM                    PNLGRP                         QUAL PANEL GRP
     C                   PARM                    SCOPE                          APPL SCOPE
     C                   PARM                    EXITIN                         EXIT PGM INT
     C                   PARM                    PRTFNM                         PRTF NAME
     C                   PARM                    ALTFNM                         ALT FILENAME
     C                   PARM                    SHARE                          SH OPEN DATA
     C                   PARM                    USRDTA                         USER DATA
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIPRTP
     C     PRTP          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    PNLNAM                         PANEL NAME
     C                   PARM                    EJECT                          EJECT OPTION
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIPUTV
     C     PUTV          PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    VARRCD                         VARIABL RCD
     C                   PARM                    VARLEN                         VARRCD LEN
     C                   PARM                    VARNAM                         VARRCD NAME
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIRMVLE
     C     RMVLE         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    EXTOPT                         EXTEND OPTIO
     C                   PARM                    LEHNDL                         *LST ENT HAN
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIRMVPW
     C     RMVPW         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    RMVOPT                         REMOVE OPTIO
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIRMVPA
     C     RMVPA         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    CLOOPT                         CLOSE OPTION
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIRTVLA
     C     RTVLA         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    LATTR                           LIST ATTR
     C                   PARM                    LALEN                          LISTA LEN
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUISETLA
     C     SETLA         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    CONTNT                         LIST CONTENT
     C                   PARM                    INCPGM                         INCMPLET PGM
     C                   PARM                    POSLE                          POSN LISTENT
     C                   PARM                    ALWTRM                         ALLOW TRIM
     C                   PARM                    ERRCOD                         *ERROR CODE
      *          QUIUPDLE
     C     UPDLE         PLIST
     C                   PARM                    APPHND                         APPL HANDLE
     C                   PARM                    VARRCD                         VARIABL RCD
     C                   PARM                    VARLEN                         VARRCD LEN
     C                   PARM                    VARNAM                         VARRCD NAME
     C                   PARM                    LSTNAM                         LIST NAME
     C                   PARM                    UPDOPT                         UPDATE OPTIO
     C                   PARM                    LEHNDL                         *LST ENT HAN
     C                   PARM                    ERRCOD                         *ERROR CODE
      ***   END OF UIM PLISTS
