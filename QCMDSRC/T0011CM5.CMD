/******************************************************************/
/*   START ADDRESS BOOK UTILITY                                   */
/*                                                                */
/*   THIS COMMAND HAS ONE PARAMETER, IF ALWCHG IS *NO THEN        */
/*   THE USER IS NOT ALLOWED TO CHANGE THE DATABASE.              */
/*                                                                */
/******************************************************************/
             CMD        PROMPT(USR0200)
             PARM       KWD(ALWCHG) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*YES) SPCVAL((*YES 1) (*NO 0)) +
                          PROMPT(USR0201)
