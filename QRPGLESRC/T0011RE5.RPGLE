      **************************************************************
      * PROGRAM         T0011RE5
      * APPLICATION     UIM/RPG SAMPLE
      * PURPOSE         This is the general panel exit program for
      *                 UIM/RPG sample application.
      * NOTES
      * This program is called by UIM whenever enter, or a function
      * key is pressed on any panel with USREXIT='CALL ABUEXIT'.
      * This program does all data file updating and writing.  The
      * reason file writing should be done in the exit program
      * is so that if a problem occurs (like duplicate key) then
      * the panel can be redisplayed with a message.  This is
      * done by sending CPF6A02 to UIM.
      *
      * Exit programs must be "reentrant" in the sense that they
      * may be called repeatedly even after they abort.  This means
      * that the exit program must NOT depend on the initialization
      * of values in its data structures.  The reason the exit
      * program aborts is that when it detects an error it sends an
      * *ESCAPE message to UIM.  This program uses IN60 to detect
      * reentrancy.
      *   Open the datafile for read/write.
     FT0011DD5  IF A E           K DISK
      *-------------------------------------------------------------
      *   Array used to check zip code
     D ZAR             S              1    DIM(5)
      *-------------------------------------------------------------
      *   Include the UIM constants, and declare the VARRCD
      *
     D/COPY QRPGSRC,T0011RI6
     D/COPY QRPGSRC,T0011RI7
      *-------------------------------------------------------------
      *   List of digits, used to check zip code
     D DIGITS          C                   CONST('0123456789')
      *-------------------------------------------------------------
      *   Declare entry parameters (Binary not allowed in *ENTRY)
      *
     D                 DS
     D  TYPCAL                 1      4B 0
     D  TYPCA§                 1      4
     D  OPTNUM                 5      8B 0
     D  OPTNU§                 5      8
     D  FNCQUA                 9     12B 0
     D  FNCQU§                 9     12
     D  FNCKEY                13     16B 0
     D  FNCKE§                13     16
      *-------------------------------------------------------------
      *   Declare parameters to the QMHSNDPM system API
      *
     D MESS            DS
     D  MSGLEN                 1      4B 0 INZ(0)
     D  MSGTYP                 5     14    INZ('*INFO')
     D  PGMQUE                15     24    INZ('*')
     D  PGMSTK                25     28B 0 INZ(1)
     D MSGF            DS
     D  MSGFN                  1     10    INZ('T0011MG5')
     D  MSGFL                 11     20    INZ('*LIBL')
      *-------------------------------------------------------------
      *  Declare and copy the entry parameters.
      *  Some acrobatics required since B parms not allowed on *ENTR
      *
     C     *ENTRY        PLIST
     C                   PARM                    TYPCA£            4
     C                   PARM                    APPHN£            8
     C                   PARM                    PNLNA£           10
     C                   PARM                    FNCKE£            4
     C                   PARM                    FNCQU£            4
     C                   PARM                    OPTNU£            4
     C                   MOVE      TYPCA£        TYPCA§
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      PNLNA£        PNLNAM
     C                   MOVE      FNCKE£        FNCKE§
     C                   MOVE      FNCQU£        FNCQU§
     C                   MOVE      OPTNU£        OPTNU§
      **************************************************************
      *   Check the parameters, this routine only does call=4.
      **************************************************************
     C     TYPCAL        COMP      4                                  H1H1      Not equal
     C   H1              RETURN
      *-------------------------------------------------------------
      *   Setup name and sizeof of varrcd and reset the data structu
      *   if necessary.  in60 is set by ERREND.
     C                   MOVEL(P)  'DATAVAR'     VARNAM
     C                   MOVE      VLEN          VARLEN
     C   60              RESET                   MSGF
     C   60              RESET                   MESS
      *-------------------------------------------------------------
      *   Test the list option and invoke the appropriate subroutine
      *
     C                   SELECT
     C     FNCKEY        WHENEQ    ENTKEY                                       Enter key
     C     PNLNAM        ANDEQ     'ADDABU'                                     Add panel
     C                   EXSR      ADDEXT
     C     FNCKEY        WHENEQ    ENTKEY                                       Enter key
     C     PNLNAM        ANDEQ     'CHGABU'                                     Chg panel
     C                   EXSR      CHKZIP
     C                   ENDSL
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *-------------------------------------------------------------
      *   The following statement is never run, but it avoids some
      *   compiler errors and runtime error CPF4030.
     C     NAME          CHAIN     T0011DD5                           50
      *-------------------------------------------------------------
      *   Exit routine to process add record
      *
     C     ADDEXT        BEGSR
     C                   EXSR      CHKZIP
     C                   WRITE     DD5REC                               50
     C   50              MOVEL(P)  'USR0102'     MSGID                          Error
     C   50              EXSR      ERREND
     C                   ENDSR
      *-------------------------------------------------------------
      *   Exit routine to check the zip code, it does a GETV first
      *
     C     CHKZIP        BEGSR
     C                   CALL      'QUIGETV'     GETV
     C                   DO        5             X                 1 0
     C     ZAR(X)        SCAN      DIGITS                                 50
     C  N50              LEAVE
     C                   ENDDO
     C  N50              MOVEL(P)  'USR0107'     MSGID                          Error
     C  N50              EXSR      ERREND
     C                   ENDSR
      *-------------------------------------------------------------
      *   This subroutine sends an error message and a status messag
      *   Note:  when a *status message is sent, the program ends
      *          immediately.
      *
     C     ERREND        BEGSR
     C                   CALL      'QMHSNDPM'    SNDPM
     C                   MOVEL(P)  'CPF6A02'     MSGID
     C                   MOVEL(P)  '*STATUS'     MSGTYP
     C                   MOVEL(P)  'QCPFMSG'     MSGFN
     C                   MOVE      *ON           *IN60
     C                   CALL      'QMHSNDPM'    SNDPM
     C                   RETURN                                                 Never her
     C                   ENDSR
      *-------------------------------------------------------------
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
      *-------------------------------------------------------------
     I/COPY QRPGSRC,T0011RI5
