      /COPY VAR4PLIST
     D VARRCD          DS
     D  ACTN$                  1     20    INZ('CONT_ACTN *LIBL')
     D  EXIT$                 21     40    INZ('CONT_EXIT *LIBL')
     D  FKEY$                 41     60    INZ('CONT_FKEY *LIBL')
     D  INCL$                 61     80    INZ('CONT_INCL *LIBL')
     D  PROM$                 81    100    INZ('CONT_PROM *LIBL')
      *
     C                   MOVEL(P)  'CONT_MAIN'   PNLGN
     C                   CALL      'QUIOPNDA'    OPNDA
      *
     C                   MOVEL(P)  'PGMVAR'      VARNAM
     C                   Z-ADD     100           VARLEN
     C                   CALL      'QUIPUTV'     PUTV
      *
      *************************************************************
      *    Set the list attributes to incomplete so that UIM will
      *    call the INCPGM before displaying the panel.
      **************************************************************
     C                   MOVEL(P)  'DATALST'     LSTNAM
     C                   MOVEL(P)  'TOP'         CONTNT
     C                   MOVEL(P)  'ABUINCL'     INCPGM
     C                   MOVEL     'Y'           ALWTRM
     C                   CALL      'QUISETLA'    SETLA
      **************************************************************
      *    Display the main panel.  When it returns, end the program
      *    Note: usrtsk=N will cause the F3=Exit to stop on this pan
      **************************************************************
     C                   MOVEL(P)  'WRKABU'      PNLNAM
     C                   MOVE      'N'           USRTSK                          New Task
     C                   CALL      'QUIDSPP'     DSPP
     C                   CALL      'QUICLOA'     CLOA
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /COPY UIMPLIST
