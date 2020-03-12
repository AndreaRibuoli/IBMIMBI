      **************************************************************
      *  PROGRAM         T0011RP6
      *  APPLICATION     UIM/RPG SAMPLE
      *  PURPOSE         This is the prompt program for the
      *                  UIM/RPG sample application.
      *  NOTES
      *  This program is called by UIM whenever function key F4 is
      *  pressed on a data item which has action='call abuprom'.
      *  In this sample program, only State on the Change ABU panel
      *  is coded this way.
      **************************************************************
      *   Include the UIM constants, and declare the VARRCD
      **************************************************************
     D/COPY QRPGSRC,T0011RI6
     D/COPY QRPGSRC,T0011RI7
      **************************************************************
      *   Declare entry parameters (Binary not allowed in *ENTRY)
      **************************************************************
     D                 DS
     D  TYPCAL                 1      4B 0
     D  TYPCA§                 1      4
      **************************************************************
      *  Declare and copy the entry parameters.
      *  Some acrobatics required since B parms not allowed on *ENTR
      **************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    TYPCA£            4
     C                   PARM                    APPHN£            8
     C                   PARM                    PNLNA£           10
     C                   PARM                    ELETYP            1
     C                   PARM                    VARNM£           10
     C                   PARM                    LSTNA£           10
     C                   PARM                    SLTHN£            4
     C                   MOVE      TYPCA£        TYPCA§
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      PNLNA£        PNLNAM
     C                   MOVE      VARNM£        VARNM
     C                   MOVE      LSTNA£        LSTNAM
     C                   MOVE      SLTHN£        SLTHND
      **************************************************************
      *   Check the parameters, this routine only does call=8.
      **************************************************************
     C     TYPCAL        COMP      8                                  H1H1      Not equal
     C   H1              RETURN
      **************************************************************
      *   Test the prompt panel and location.
      **************************************************************
     C                   SELECT
     C     VARNM         WHENEQ    'STATE'
     C     ELETYP        ANDEQ     '1'
     C                   EXSR      STAPMT
     C                   ENDSL
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************************************************
      *   Subroutine to prompt on the state abbreviations.
      **************************************************************
     C     STAPMT        BEGSR
      *   Call fill routine to fill the popup list
     C                   CALL      'T0011RF5'
     C                   PARM                    APPHND
     C                   PARM      'STALIST'     LSTNAM
      *   Pop-up window to prompt for state.
     C                   MOVEL(P)  '*ROWCOL'     WINLOC
     C                   Z-ADD     7             WINROW
     C                   Z-ADD     10            WINCOL
     C                   CALL      'QUIADDPW'    ADDPW                          Enable po
     C                   MOVEL(P)  'SELSTA'      PNLNAM
     C                   CALL      'QUIDSPP'     DSP
     C                   CALL      'QUIRMVPW'    RMVPW                          Disable p
      **************************************************************
      *   If enter is pressed, get the state.
      *   Notice that this is one of the places that ENTER=0, becaus
      *   we set actfor=caller on the list tag.
      **************************************************************
     C     FNCREQ        IFEQ      *ZERO                                        Enter key
     C                   MOVE      'FSLT'        POSOPT
     C                   MOVEL(P)  'NE'          CRIT
     C                   MOVEL(P)  'OPT1'        VARNM
     C                   MOVEL(P)  '*NONE'       VARNAM
     C                   MOVE      'Y'           CPYOPT
     C                   Z-ADD     ERRSIZ        BYTPRO                         Enable er
     C                   CALL      'QUIGETLE'    GETLE
     C                   Z-ADD     0             BYTPRO                         Disable e
     C                   ENDIF
     C                   ENDSR
      **************************************************************
     I/COPY QRPGSRC,T0011RI5
