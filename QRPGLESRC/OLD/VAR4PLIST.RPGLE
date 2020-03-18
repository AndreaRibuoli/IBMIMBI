      **************************************************************
      * T0011RI6 - Variables for calling UIM APIs.
      *
      * These variables are to be used by the PLISTS in UIMPLIST.
      * To use these members, copy T0011RI5 and T0011RI6 to QRPGSRC
      * in your library.  Then type the following in your RPG
      * program at the appropriate places:
      *      /COPY T0011RI6
      *      /COPY T0011RI5
      * In your program, you will need to define a DS called VARRCD
      * that contains all the dialog variables used to communicate
      * with UIM (in the same order declared in UIM).
      *
      * Each of the following variables is used as a parameter to
      * one or more UIM functions.  Some variables are given default
      * values that are commonly used.  Variables that application
      * must initialize are given the value xxxxxx.
      **************************************************************
     D UIMV            DS
     D  ADDOPT                 1      4    INZ('NEXT')
     D  ALTFNM                 5     14    INZ('*NONE')
     D  APPHND                15     22
     D  CLOOPT                23     23    INZ('M')
     D  CPYOPT                24     24    INZ('Y')
     D  CURPOS                25     25    INZ('D')
     D  EJECT                 26     26    INZ('Y')
     D  ERRLE                 27     30    INZ('NONE')
     D  EXITIN                31     34B 0 INZ(1)
     D  EXTOPT                35     35    INZ('Y')
     D  FNCREQ                36     39B 0
     D  FULHLP                40     40    INZ('N')
     D  LALEN                 41     44B 0 INZ(19)
     D  LASTLE                45     48    INZ('NONE')
     D  LEHNDL                49     52
     D  LSTNAM                53     62    INZ('xxxxxx')
     D  MSGKEY                63     66    INZ('    ')
     D  MSGQUE                67     76    INZ('*CALLER')
     D  PNLNAM                77     86    INZ('xxxxxx')
     D  POSOPT                87     90    INZ('SAME')
     D  REDISP                91     91    INZ('N')
     D  RMVOPT                92     92    INZ('L')
     D  SCOPE                 93     96B 0 INZ(-1)
     D  SHARE                 97     97    INZ('N')
     D  SLTHND                98    101    INZ('EXTE')
     D  STKCNT               102    105B 0 INZ(0)
     D  UPDOPT               106    109    INZ('SAME')
     D  USRDTA               110    119    INZ('*NONE')
     D  USRTSK               120    120    INZ('O')
     D  VARLEN               121    124B 0 INZ(0)
     D  VARNAM               125    134    INZ('*NONE')
     D  WINCOL               135    138B 0 INZ(10)
     D  WINLOC               139    148    INZ('*OFFSET')
     D  WINROW               149    152B 0 INZ(3)
     D  WTIME                153    156B 0 INZ(-1)
      **************************************************************
      *   This structure is used by QUIGETLE
      **************************************************************
     D SLTCRI          DS
     D  CRIT                   1     10    INZ('EQ')
     D  VARNM                 11     20    INZ('xxxxxx')
      **************************************************************
      *   This structure is used by QUIOPNPA
      **************************************************************
     D PRTFNM          DS
     D  PRTFN                  1     10    INZ('xxxxxx')
     D  PRTFL                 11     20    INZ('*LIBL')
      **************************************************************
      *   This structure is used by QUIOPNDA
      **************************************************************
     D PNLGRP          DS
     D  PNLGN                  1     10    INZ('xxxxxx')
     D  PNLGL                 11     20    INZ('*LIBL')
      **************************************************************
      *   This structure is used by QUIRTVLA and QUISETLA
      **************************************************************
     D LATTR           DS
     D  CONTNT                 1      4    INZ('SAME')
     D  INCPGM                 5     14    INZ('*SAME')
     D  POSLE                 15     18    INZ('SAME')
     D  ALWTRM                19     19    INZ('S')
      **************************************************************
      *   This structure is by UIM to return error info.
      *   If BYTes PROvided is zero, UIM will send exception msgs.
      *   Otherwise, you should set BYTPRO to ERRSIZ.
      **************************************************************
     D ERRCOD          DS                  INZ
     D  BYTPRO                 1      4B 0 INZ(0)
     D  BYTAVA                 5      8B 0
     D  MSGID                  9     15
     D  RSRV1                 16     16
     D  MSGDTA                17    256
      **************************************************************
      *   These are some binary constants you can use to test func-
      *   tion with action=Enter, Exit, Cancel, or Prompt.
      *   These values are returned by UIM in some places (like
      *   QUIDSPP) or passed to the usrexit routine.  However, in
      *   some places, other values may be used!
      **************************************************************
     D UIMKEY          DS
     D  ENTKEY                 1      4B 0 INZ(26)
     D  EXTKEY                 5      8B 0 INZ(-4)
     D  CANKEY                 9     12B 0 INZ(-8)
     D  PMTKEY                13     16B 0 INZ(-10)
      **************************************************************
      *   Named Constants
      **************************************************************
     D ERRSIZ          C                   CONST(256)
      ***  END OF UIM VARIABLES
