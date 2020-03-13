      *
      *    This program is called by UIM whenever the user selects
      *    an action on the work-with panel.
      *
      *  Indicators
      *    40  indicates extended action list entry actions.
      *
     FT0011DD5  UF   E           K DISK
     D/COPY T0011RI6
     D/COPY T0011RI7
     D ROCH            C                   CONST('Pesaro')
      *
      *    parameters for QMHSNDPM system API
      *
     D                 DS
     D  MSGLEN                 1      4B 0 INZ(0)
     D  MSGTYP                 5     14    INZ('*INFO')
     D  PGMQUE                15     24    INZ('*')
     D  PGMSTK                25     28B 0 INZ(1)
      *
     D MSGF            DS
     D  MSGFN                  1     10    INZ('T0011MG5')
     D  MSGFL                 11     20    INZ('*LIBL')
      *
      *   entry parameters (binary not allowed in *ENTRY)
      *
     D                 DS
     D  TYPCAL                 1      4B 0
     D  TYPCA§                 1      4
     D  OPTNUM                 5      8B 0
     D  OPTNU§                 5      8
     D  FNCQUA                 9     12B 0
     D  FNCQU§                 9     12
      *
      *   declare and copy the entry parameters.
      *   some acrobatics required since BINARY parms not allowed on *ENTRY
      *
     C     *ENTRY        PLIST
     C                   PARM                    TYPCA£            4
     C                   PARM                    APPHN£            8
     C                   PARM                    PNLNA£           10
     C                   PARM                    LSTNA£           10
     C                   PARM                    SLTHN£            4
     C                   PARM                    OPTNU£            4
     C                   PARM                    FNCQU£            4
     C                   MOVE      TYPCA£        TYPCA§
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      PNLNA£        PNLNAM
     C                   MOVE      LSTNA£        LSTNAM
     C                   MOVE      SLTHN£        SLTHND
     C                   MOVE      OPTNU£        OPTNU§
     C                   MOVE      FNCQU£        FNCQU§
      *
      *   check the parameters, this routine only does call=3.
      *
     C     TYPCAL        COMP      3                                  H1H1      Not equal
     C   H1              RETURN
      *
      *   Setup name and sizeof of varrcd.
      *
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   Z-ADD     VLEN          VARLEN
      *
      *   Test the list option and invoke the appropriate subroutine
      *
     C                   SELECT
     C     OPTNUM        WHENEQ    1
     C                   EXSR      ADDREC
     C     OPTNUM        WHENEQ    2
     C                   EXSR      CHGREC
     C     OPTNUM        WHENEQ    4
     C                   EXSR      RMVREC
     C     OPTNUM        WHENEQ    5
     C                   EXSR      DSPREC
     C     OPTNUM        WHENEQ    6
     C                   EXSR      PRTREC
     C                   ENDSL
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************
      **   1=Add Subroutine   **
      **************************
     C     ADDREC        BEGSR
      *
      *   At this point you might want to get the EXTE line and see
      *   if a name was entered and if it already exists in the data
      *   file.  If so you would then send a program message to UIM
      *   and return.  For now, we only check for duplicates in the
      *   abuexit program.
      *   Get the name typed on the extended action line
      *
     C                   MOVE      'HNDL'        POSOPT
     C                   CALL      'QUIGETLE'    GETLE
      *
      *   Fill in default values for the add record screen
      *
     C                   Z-ADD     0             OPT
     C                   MOVE      *BLANK        ADDR
     C                   MOVEL(P)  ROCH          CITY
     C                   MOVE      'MN'          STATE
     C                   MOVE      55901         ZIP
     C                   CALL      'QUIPUTV'     PUTV
      *
      *   Display the Add panel
      *
     C                   MOVEL(P)  'ADDABU'      PNLNAM
     C                   CALL      'QUIDSPP'     DSP
      *
      *  If enter was pressed, then search for the correct insertion
      *  point in the list.  Because the list may be incomplete,
      *  it must be searched in both directions in some cases.
      *
     C     FNCREQ        IFEQ      ENTKEY
     C                   CALL      'QUIGETV'     GETV
     C                   CALL      'QUIRTVLA'    RTVLA
     C                   MOVEL(P)  '*NONE'       VARNAM
     C                   MOVE      'N'           CPYOPT
     C                   MOVE      'N'           EXTOPT
      *
      *   Search the list in the forwards direction
      *
     C                   MOVE      'FSLT'        POSOPT
     C                   MOVEL(P)  'GE'          CRIT
     C                   MOVEL(P)  'NAME'        VARNM
     C                   MOVE      ERRSIZ        BYTPRO                         Enabler
     C                   CALL      'QUIGETLE'    GETLE
     C                   Z-ADD     0             BYTPRO                         Disable
      *
      *   If error, then check if list is complete at the bottom.
      *
     C     BYTAVA        IFNE      *ZERO
      *
      *   If complete at bottom, add record, else do nothing
      *
     C     CONTNT        IFEQ      'ALL '
     C     CONTNT        OREQ      'BOT '
     C                   MOVE      'LAST'        ADDOPT
     C                   CALL      'QUIADDLE'    ADDLE
     C                   ENDIF
     C                   GOTO      ADDEND
     C                   ENDIF
      *
      *   Search the list in the backwards direction
      *
     C                   MOVE      'LSLT'        POSOPT
     C                   MOVEL(P)  'LE'          CRIT
     C                   MOVE      ERRSIZ        BYTPRO                         Enable er
     C                   CALL      'QUIGETLE'    GETLE
     C                   Z-ADD     0             BYTPRO                         Disable e
      *
      *   If error, then check if list is complete at the top.
      *
     C     BYTAVA        IFNE      *ZERO
      *
      *   If complete at top, add record, else do nothing
      *
     C     CONTNT        IFEQ      'ALL '
     C     CONTNT        OREQ      'TOP '
     C                   MOVE      'FRST'        ADDOPT
     C                   CALL      'QUIADDLE'    ADDLE
     C                   ENDIF
     C                   GOTO      ADDEND
     C                   ENDIF
      *
      *   If an insertion position is found, then add the new record
      *
     C                   MOVE      'NEXT'        ADDOPT
     C                   CALL      'QUIADDLE'    ADDLE
     C                   ENDIF                                                  Enter pre
      *
      *   Clear the extended action entry
      *
     C     ADDEND        TAG
     C                   MOVE      'EXTE'        UPDOPT
     C                   MOVE      *BLANK        NAME
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDSR
      *****************************
      **   2=Change Subroutine   **
      *****************************
     C     CHGREC        BEGSR
      *
      *   If the handle is EXTE, get the extended action entry.
      *   Else get the current list entry.
      *
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'HNDL'        POSOPT
     C                   ENDIF
     C                   CALL      'QUIGETLE'    GETLE
      *
      *   Read the datafile record by key, and LOCK the record.
      *
     C     NAME          CHAIN     T0011DD5                           5051
     C   50              MOVE      'USR0103'     MSGID                          Not found
     C   50              EXSR      ERREND
     C   51              MOVE      'USR0100'     MSGID                          Read erro
     C   51              EXSR      ERREND
      *
      *   Display the Change panel
      *
     C                   Z-ADD     0             OPT
     C                   CALL      'QUIPUTV'     PUTV
     C                   MOVEL(P)  'CHGABU'      PNLNAM
     C                   CALL      'QUIDSPP'     DSP
      *
      *   If enter was pressed, then get the UIM variables and try
      *   to update the datafile record.
      *
     C     FNCREQ        IFEQ      ENTKEY                                       Enter key
     C                   CALL      'QUIGETV'     GETV
     C                   UPDATE    DD5REC                               50
     C   50              MOVE      'USR0101'     MSGID                          Updater
     C   50              EXSR      ERREND
      *
      *   If this was on the extended entry, search for it and updat
      *   it in the UIM list.
      *
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVEL(P)  '*NONE'       VARNAM
     C                   MOVE      'N'           CPYOPT
     C                   MOVE      'N'           EXTOPT
     C                   MOVE      'FSLT'        POSOPT
     C                   MOVEL(P)  'EQ'          CRIT
     C                   MOVEL(P)  'NAME'        VARNM
     C                   MOVE      ERRSIZ        BYTPRO                         Enabler
     C                   CALL      'QUIGETLE'    GETLE
     C                   Z-ADD     0             BYTPRO                         Disable
      *
      *   If not found, don't do the update.
      *
     C     BYTAVA        CABNE     *ZERO         CHGEND
     C                   ENDIF
      *
      *   Update the UIM list entry.
      *
     C                   MOVEL(P)  '*NONE'       VARNAM
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
      *
      *   If the action was on the extended action entry, clear it.
      *
     C     CHGEND        TAG
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'EXTE'        UPDOPT
     C                   MOVE      *BLANK        NAME
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
     C                   ENDSR
      *****************************
      **   4=Remove Subroutine   **
      *****************************
     C     RMVREC        BEGSR
     C                   MOVE      'HNDL'        POSOPT
     C                   CALL      'QUIGETLE'    GETLE
     C     NAME          DELETE    DD5REC                             5150
      *   If delete is not successful, send an error message
     C   50              MOVEL(P)  'USR0105'     MSGID                          Error
     C   51              MOVEL(P)  'USR0106'     MSGID                          Not found
     C   50
     COR 51              EXSR      ERREND
      *   If delete is successful, remove the UIM list entry
     C                   MOVE      'N'           EXTOPT
     C                   CALL      'QUIRMVLE'    RMVLE
     C                   ENDSR
      **************************************************************
      *   5=Display Subroutine
      **************************************************************
     C     DSPREC        BEGSR
      *   If the handle is EXTE, get the extended action entry.
      *   Else get the current list entry.
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'HNDL'        POSOPT
     C                   ENDIF
     C                   CALL      'QUIGETLE'    GETLE
      *   Read the datafile record by key.
     C     NAME          CHAIN(N)  T0011DD5                           5051      Don't loc
     C   50              MOVE      'USR0104'     MSGID                          Not found
     C   50              EXSR      ERREND
     C   51              MOVE      'USR0100'     MSGID                          Read erro
     C   51              EXSR      ERREND
      *   Display the display panel
     C                   MOVE      *ZERO         OPT
     C                   CALL      'QUIPUTV'     PUTV
     C                   MOVEL(P)  'DSPABU'      PNLNAM
     C                   CALL      'QUIDSPP'     DSP
      *   If enter pressed and action was not on exte, then update
      *   the UIM list entry.
     C     FNCREQ        IFEQ      ENTKEY
     C     SLTHND        ANDNE     'EXTE'
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
      *   If the action was on the extended action entry, clear it.
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'EXTE'        UPDOPT
     C                   MOVE      *BLANK        NAME
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
     C                   ENDSR
      **************************************************************
      *   6=Print Subroutine
      *   Print is left as an exercise for the student.
      **************************************************************
     C     PRTREC        BEGSR
      *   If the handle is EXTE, get the extended action entry.
      *   Else get the current list entry.
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'HNDL'        POSOPT
     C                   ENDIF
     C                   CALL      'QUIGETLE'    GETLE
      *   Read the datafile record by key.
     C     NAME          CHAIN(N)  T0011DD5                           5051      Don't loc
     C     *IN50         IFEQ      *ON
     C                   MOVE      'USR0104'     MSGID                          Not found
     C                   EXSR      ERREND
     C                   ENDIF
     C   51              MOVE      'USR0100'     MSGID                          Read erro
     C   51              EXSR      ERREND
      *   Print the selected entry
     C                   MOVE      *ZERO         OPT
     C                   CALL      'QUIPUTV'     PUTV
      *   Add the print to the open panel group
     C                   MOVEL(P)  'QSYSPRT'     PRTFN
     C                   MOVEL(P)  '*NONE'       ALTFNM
     C                   MOVEL     'Y'           SHARE
     C                   MOVEL(P)  '*FILE'       USRDTA
     C                   CALL      'QUIADDPA'    ADDPA
      *   Print the header
     C                   MOVEL(P)  'PRTHDABU'    PNLNAM
     C                   MOVEL     'Y'           EJECT
     C                   CALL      'QUIPRTP'     PRTP
      *   Print the selected entry
     C                   MOVEL(P)  'PRTABU'      PNLNAM
     C                   MOVEL     'Y'           EJECT
     C                   CALL      'QUIPRTP'     PRTP
      *   Remove the print from the open panel group
     C                   MOVEL     'M'           RMVOPT
     C                   CALL      'QUIRMVPA'    RMVPA
      *   IF action was not on exte, then update
      *   the UIM list entry.
     C     SLTHND        IFNE      'EXTE'
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
      *   If the action was on the extended action entry, clear it.
     C     SLTHND        IFEQ      'EXTE'
     C                   MOVE      'EXTE'        UPDOPT
     C                   MOVE      *BLANK        NAME
     C                   CALL      'QUIUPDLE'    UPDLE
     C                   ENDIF
     C                   ENDSR
      **************************************************************
      *   This subroutine sends an escape error message.
      *   Note:  when a *escape message is sent, the program ends
      *          immediately, i.e. the RETRN is never reached.
      *   The "call" programs are not reentrant.  Set H1 as a safety
      *   measure, to break any attempt to reenter.
      **************************************************************
     C     ERREND        BEGSR
     C                   MOVEL(P)  '*ESCAPE'     MSGTYP
     C                   MOVE      *ON           *INH1
     C                   CALL      'QMHSNDPM'    SNDPM
     C                   RETURN                                                 Never her
     C                   ENDSR
      **************************************************************
     C     SNDPM         PLIST
     C                   PARM                    MSGID
     C                   PARM                    MSGF
     C                   PARM                    MSGDTA
     C                   PARM                    MSGLEN
     C                   PARM                    MSGTYP
     C                   PARM                    PGMQUE
     C                   PARM                    PGMSTK
     C                   PARM                    MSGKEY
     C                   PARM                    ERRCOD
      **************************************************************
     I/COPY T0011RI5
