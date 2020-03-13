      **************************************************************
      * PROGRAM         T0011RF6
      * APPLICATION     UIM/RPG SAMPLE
      * PURPOSE         This is the function key program for the
      *                 UIM/RPG sample application.
      * NOTES
      * This program is called by UIM whenever a function key with
      * action='call abufkey' is pressed.  In this sample program
      * only the F5=Refresh key is coded this way.
      * When F5 is pressed the gets the entry to which the list is
      * positioned, then it deletes the list, and then it reads the
      * position-to entry from the file and adds it to the list.
      * The incomplete list program adds the rest of the entries.
      *
      * Exit programs must be "reentrant" in the sense that they
      * may be called repeatedly even after they abort.  This means
      * that the exit program must NOT depend on the initialization
      * values in its data structures.  The reason the exit program
      * aborts is because when it detects an error it sends an
      * *ESCAPE message to UIM.  This program uses IN60 to detect
      * reentrancy.
      **************************************************************
     FT0011DD5  IF   E           K DISK
      **************************************************************
      *   Include the UIM constants, and declare the VARRCD
      **************************************************************
     D/COPY T0011RI6
     D/COPY T0011RI7
      *-------------------------------------------------------------
      *   Declare parameters to the QMHSNDPM system API
      *
     D MESS            DS
     D  MSGLEN                 1      4B 0 INZ(0)
     D  MSGTYP                 5     14    INZ('*INFO')
     D  PGMQUE                15     24    INZ('*')
     D  PGMSTK                25     28B 0 INZ(1)
     D MSGF            DS
     D  MSGFN                  1     10    INZ('CONTATTI')
     D  MSGFL                 11     20    INZ('*LIBL')
      **************************************************************
      *   Declare entry parameters (Binary not allowed in *ENTRY)
      **************************************************************
     D                 DS
     D  TYPCAL                 1      4B 0
     D  TYPCA§                 1      4
     D  FNCKEY                 5      8B 0
     D  FNCKE§                 5      8
     D  KNAME                  9     33
     I/COPY UIMPLIST
      **************************************************************
      *  Declare and copy the entry parameters.
      *  Some acrobatics required since B parms not allowed on *ENTR
      **************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    TYPCA£            4
     C                   PARM                    APPHN£            8
     C                   PARM                    PNLNA£           10
     C                   PARM                    FNCKE£            4
     C                   MOVE      TYPCA£        TYPCA§
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      PNLNA£        PNLNAM
     C                   MOVE      FNCKE£        FNCKE§
      **************************************************************
      *   Check the parameters, this routine only does call=1.
      **************************************************************
     C     TYPCAL        COMP      1                                  H1H1      Not equal
     C   H1              RETURN
      **************************************************************
      *   If this is a reentrant call, reset structures
      **************************************************************
     C   60              RESET                   MSGF
     C   60              RESET                   MESS
     C   60              RESET                   UIMV
      **************************************************************
      *   If F5=Refresh, get the current list position.
      **************************************************************
     C                   SELECT
     C     PNLNAM        WHENEQ    'WRKABU'
     C     FNCKEY        ANDEQ     5
     C                   EXSR      FKEY5
     C     PNLNAM        WHENEQ    'WRKABU'
     C     FNCKEY        ANDEQ     17
     C                   EXSR      FKEY17
     C                   ENDSL
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************************************************
      *   Subroutine F5=Refresh
      **************************************************************
     C     FKEY5         BEGSR
     C                   MOVEL(P)  'DATALST'     LSTNAM
     C                   CALL      'QUIRTVLA'    RTVLA
      **************************************************************
      *   If current position is not TOP or BOT, then get the
      *   current "position-to" entry from list.
      *   Delete all the entries in the list.
      *   Read the position-to (top of screen) entry from the datafi
      *   add it to the list, and position the new list to this entr
      *   If the record is not found, reposition list to the top.
      **************************************************************
     C     POSLE         IFNE      'TOP '
     C     POSLE         ANDNE     'BOT '
     C                   MOVE      POSLE         SLTHND
     C                   MOVE      'HNDL'        POSOPT
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   Z-ADD     VLEN          VARLEN
     C                   CALL      'QUIGETLE'    GETLE
     C                   CALL      'QUIDLTL'     DLTL
      *   IN50 means errors occurred reading the datafile record.
     C     NAME          SETGT     T0011DD5                             50
     C  N50              READP     T0011DD5                             5050
     C  N50              CALL      'QUIADDLE'    ADDLE
     C  N50              MOVE      LEHNDL        POSLE
     C  N50              MOVE      'MORE'        CONTNT
     C   50              MOVE      'TOP '        POSLE
     C   50              MOVE      'TOP '        CONTNT
      *   If posle is TOP or BOT, then just delete list and mark it.
      *   The incomplete list program will add records as needed.
     C                   ELSE
     C                   CALL      'QUIDLTL'     DLTL
     C                   MOVE      POSLE         CONTNT
     C                   ENDIF
      *   Set list attributes.
     C                   MOVE      'Y'           ALWTRM
     C                   MOVEL(P)  'ABUINCL'     INCPGM
     C                   CALL      'QUISETLA'    SETLA
     C                   ENDSR
      **************************************************************
      *   Subroutine F17=Position-to
      **************************************************************
     C     FKEY17        BEGSR
      *   Pop-up window to prompt for position-to.
      *   Make the name blanks.
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   Z-ADD     VLEN          VARLEN
     C                   CALL      'QUIPUTV'     PUTV
     C                   MOVEL(P)  '*ROWCOL'     WINLOC
     C                   Z-ADD     13            WINROW
     C                   Z-ADD     2             WINCOL
     C                   CALL      'QUIADDPW'    ADDPW                          Enable po
     C                   MOVEL(P)  'POSABU'      PNLNAM
     C                   CALL      'QUIDSPP'     DSP
     C                   CALL      'QUIRMVPW'    RMVPW                          Disable p
      **************************************************************
      *   If enter is pressed, get the name and reposition the list.
      *   Note:  positioning the list is tricky business.  There are
      *   three cases to consider.  1. exact match, 2. key is a pref
      *   of some name, 3. neither 1 nor 2.  For 1 and 2, position t
      *   the next record, but for 3, position to the previous recor
      *   IN50 = error occurred reading name from datafile
      *   IN51 = end of file encountered.
      *   IN52 = search name is not a prefix of any name (case 3)
      *   IN53 = beginning of file encountered.
      **************************************************************
     C     FNCREQ        IFEQ      ENTKEY
     C                   MOVEL(P)  'DATALST'     LSTNAM
     C                   CALL      'QUIGETV'     GETV
      *   Check for special values of name *TOP and *BOT
     C     NAME          COMP      '*TOP'                                 40
     C   40              MOVE      *LOVAL        NAME
     C     NAME          COMP      '*BOT'                                 40
     C   40              MOVE      *HIVAL        NAME
      *   Calculate the MAX value of name with the given prefix
     C     ' ':'9'       XLATE     NAME          PNAME            25
     C     NAME          SETLL     T0011DD5                             50
     C  N50              READ      T0011DD5                             5051
      *   If EOF condition, then read the last database record.
     C  N50
     CAN 51*HIVAL        SETLL     T0011DD5                             50
     C  N50
     CAN 51              READP     T0011DD5                             5050
      *   Else, check if name is greater than max prefix (case 3)
     C  N50
     CANN51PNAME         COMP      NAME                                 52
     C  N50
     CANN51
     CAN 52              READP     T0011DD5                             5053
      *   If any error occurred, or file empty, send error message
     C   50              MOVE      'USR0103'     MSGID
     C   50              EXSR      ERREND                                       No return
      *   Delete the list and add one record.
     C                   CALL      'QUIDLTL'     DLTL
     C                   CALL      'QUIADDLE'    ADDLE
      *   Mark list incomplete and position to the new entry
     C                   MOVE      LEHNDL        POSLE
     C                   MOVE      'MORE'        CONTNT
     C                   MOVE      'Y'           ALWTRM
     C                   MOVEL(P)  'ABUINCL'     INCPGM
      *   Set list attributes.
     C                   CALL      'QUISETLA'    SETLA
     C                   ENDIF
     C                   ENDSR
      **************************************************************
      *   This subroutine sends an escape error message.
      *   Note:  when a *escape message is sent, the program ends
      *          immediately, i.e. the RETRN is never reached.
      **************************************************************
     C     ERREND        BEGSR
     C                   MOVEL(P)  '*ESCAPE'     MSGTYP
     C                   MOVE      *ON           *IN60
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
