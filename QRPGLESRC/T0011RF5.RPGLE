      **************************************************************
      *  PROGRAM         T0011RF5
      *  APPLICATION     UIM/RPG SAMPLE
      *  PURPOSE         This fills the popup selection lists.
      *  NOTES
      *    This program is called by T0011RP6 to fill the popup
      *    selection lists.
      **************************************************************
      *   Include the UIM constants, and declare the VARRCD
      **************************************************************
     D/COPY T0011RI6
      **************************************************************
      *   Declare varrcd for selection list processing
      **************************************************************
     D VARRCD          DS                  INZ
     D  OPT1                   1      2B 0
     D  STATE                  3      4
     D  STNAME                 5     29
      *   Size of Varrcd
     D VLEN            C                   CONST(29)
      **************************************************************
      *   Declare and copy the entry parameters.
      **************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    APPHN£            8
     C                   PARM                    LSTNA£           10
     C                   MOVE      APPHN£        APPHND
     C                   MOVE      LSTNA£        LSTNAM
      **************************************************************
      *   Test the list name.
      **************************************************************
     C                   SELECT
     C     LSTNAM        WHENEQ    'STALIST'
     C                   EXSR      STAFIL
     C                   ENDSL
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************************************************
      *   Subroutine to fill the state abbreviations list
      **************************************************************
     C     STAFIL        BEGSR
     C                   MOVEL(P)  'SELVAR'      VARNAM
     C                   Z-ADD     VLEN          VARLEN
     C                   CALL      'QUIGETV'     GETV
      *   Save the STATE so we can restore it later
     C                   MOVE      STATE         STATE2            2
      *   Add one dummy (ensure the list exists) and delete the list
     C                   CALL      'QUIADDLE'    ADDLE
     C                   CALL      'QUIDLTL'     DLTL
      **************************************************************
      *   Add several states to the list.  In actuallity one should
      *   read these names from a datafile or message file, but this
      *   is an example.
      **************************************************************
     C                   Z-ADD     0             OPT1
     C                   MOVEL(P)  'Florida'     STNAME
     C                   MOVE      'FL'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Texas'       STNAME
     C                   MOVE      'TX'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Oregon'      STNAME
     C                   MOVE      'OR'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Virginia'    STNAME
     C                   MOVE      'VA'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Ohio'        STNAME
     C                   MOVE      'OH'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Alabama'     STNAME
     C                   MOVE      'AL'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'Kentucky'    STNAME
     C                   MOVE      'KY'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
     C                   MOVEL(P)  'New York'    STNAME
     C                   MOVE      'NY'          STATE
     C                   CALL      'QUIADDLE'    ADDLE
      *   Restore the previous value of STATE
     C                   MOVE      STATE2        STATE
     C                   CALL      'QUIPUTV'     PUTV
     C                   ENDSR
      **************************************************************
     I/COPY T0011RI5
