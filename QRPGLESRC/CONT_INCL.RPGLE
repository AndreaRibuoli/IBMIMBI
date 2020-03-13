      **************************************************************
      *  PROGRAM         T0011RL5
      *  APPLICATION     UIM/RPG SAMPLE
      *  PURPOSE         This is the incomplete list program for the
      *                  UIM/RPG sample application.
      *  NOTES
      *  This program is called by UIM whenever new records are
      *  needed on the display (e.g. the user presses pagedn).
      *  The parameters passed tell the name of the UIM list,
      *  the application handle, and the number of records needed.
      *  This program gets the last list entry, seeks to it in
      *  the file, and then copies records from the file to the UIM
      *  list after (or before) the current list entry.  If during a
      *  READ the program reachs EOF (or BOF) then it tells UIM
      *  about it by calling SETLA with contnt=ALL, BOT, or TOP.
      *  This algorithm ONLY works when the file has a unique key.
      *  If the file does not have a unique
      *  key then we would have to store relative record numbers
      *  (RRN) in the UIM list (as invisible fields) and use the
      *  RRN for seeking.
      *  This algorithm will work when AllowTrim (QUISETLA) is Y.
      *  Indicators
      *    40  the direction to extend the list, 0=forward.
      *    50  file record error or not found
      *    52  list content is MORE
      **************************************************************
     FCONTATTI  IF   E           K DISK
      **************************************************************
      *   Include the UIM constants, and declare the VARRCD
      **************************************************************
     D/COPY VAR4PLIST
     D/COPY UIMVARRCD
      **************************************************************
      *   Declare entry parameters (Binary not allowed in *ENTRY)
      ***************************************************************
     D                 DS
     D  TYPCAL                 1      4B 0
     D  TYPCA§                 1      4
     D  INCDIR                 5      8B 0
     D  INCDI§                 5      8
     D  NUMREQ                 9     12B 0
     D  NUMRE§                 9     12
      **************************************************************
      *  Declare and copy the entry parameters.
      *  Some acrobatics required since B parms not allowed on *ENTR
      **************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    TYPCA£            4
     C                   PARM                    APPHN£            8
     C                   PARM                    LSTNA£           10
     C                   PARM                    INCDI£            4
     C                   PARM                    NUMRE£            4
     C                   MOVE      TYPCA£        TYPCA§
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      LSTNA£        LSTNAM
     C                   MOVE      INCDI£        INCDI§
     C                   MOVE      NUMRE£        NUMRE§
      **************************************************************
      *   Check the parameters, this routine only does call=6
      **************************************************************
     C     TYPCAL        COMP      6                                  H1H1      Not equal
     C   H1              RETURN
      **************************************************************
      *   Get the current list entry (do not extend!)
      *   If any error occurred, then probably the list is empty.
      **************************************************************
     C     INCDIR        COMP      *ZERO                                  40     Forward
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   Z-ADD     VLEN          VARLEN
     C   40              MOVE      'LAST'        POSOPT
     C  N40              MOVE      'FRST'        POSOPT
     C                   MOVE      'N'           EXTOPT
     C                   Z-ADD     ERRSIZ        BYTPRO                         Enable er
     C                   CALL      'QUIGETLE'    GETLE
     C                   Z-ADD     0             BYTPRO                         Disable e
     C     BYTAVA        IFNE      *ZERO
     C   40              MOVE      *LOVAL        NAME
     C  N40              MOVE      *HIVAL        NAME
     C                   Z-ADD     *ZERO         OPT                            Clear opt
     C                   ENDIF
      **************************************************************
      *   If the direction is forward, seek to the NAME record and
      *   Repeat numreq times, get record, add to list.
      **************************************************************
     C                   MOVE      POSOPT        ADDOPT
     C   40NAME          SETGT     CONTATTI
     C  N40NAME          SETLL     CONTATTI
     C                   DO        NUMREQ
     C   40              READ      CONTATTI                             5050
     C  N40              READP     CONTATTI                             5050
     C   50              LEAVE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   ENDDO
      **************************************************************
      *    If end-of-file (or top) then mark list as complete.
      **************************************************************
     C     *IN50         IFEQ      *ON                                          End of fi
     C                   CALL      'QUIRTVLA'    RTVLA
     C     CONTNT        COMP      'MORE'                                 52     Equal
     C   52
     CAN 40              MOVE      'BOT '        CONTNT
     C   52
     CANN40              MOVE      'TOP '        CONTNT
     C  N52              MOVE      'ALL '        CONTNT
     C                   MOVEL(P)  '*SAME'       INCPGM
     C                   MOVE      'SAME'        POSLE
     C                   MOVE      'S'           ALWTRM
     C                   CALL      'QUISETLA'    SETLA
     C                   ENDIF
      **************************************************************
      *    And then return.
      **************************************************************
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************************************************
     I/COPY UIMPLIST
