      **************************************************************
      *  PROGRAM         T0011RP5
      *  APPLICATION     UIM/RPG SAMPLE
      *  PURPOSE         This is the main driver program for the
      *                  Address Book UIM/RPG sample application.
      **************************************************************
      /COPY T0011RI6
      **************************************************************
      *  Declare the dialog variables data structure
      **************************************************************
     D VARRCD          DS
     D  ACTN$                  1     20    INZ('CONT_ACTN *LIBL')
     D  EXIT$                 21     40    INZ('T0011RE5  *LIBL')
     D  FKEY$                 41     60    INZ('T0011RF6  *LIBL')
     D  INCL$                 61     80    INZ('T0011RL5  *LIBL')
     D  PROM$                 81    100    INZ('T0011RP6  *LIBL')
      **************************************************************
      *   Open the application.  We don't have to check the errcode
      *   on return, bytpro is zero so the program will just abend.
      **************************************************************
     C                   MOVEL(P)  'T0011PN5'    PNLGN
     C                   CALL      'QUIOPNDA'    OPNDA
      **************************************************************
      *   Put the exit program names to UIM
      **************************************************************
     C                   MOVEL(P)  'PGMVAR'      VARNAM
     C                   Z-ADD     100           VARLEN
     C                   CALL      'QUIPUTV'     PUTV
      **************************************************************
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
      /COPY T0011RI5
