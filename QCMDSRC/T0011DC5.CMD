/******************************************************************/
/*                                                                */
/*  Part name:    T0011DC5                                        */
/*                                                                */
/*  Source file:  QATTCMD in library QUSRTOOL                     */
/*                                                                */
/*  Function:     This command can be used to delete the objects  */
/*                that were created by the T0011CR5 CL program. It*/
/*                can also be used to delete the source that was  */
/*                used to create those objects.                   */
/*                                                                */
/*                The only thing that cannot be deleted by this   */
/*                command is its own command processing program.  */
/*                                                                */
/*  Publication:  Application Display Programming                 */
/*                                                                */
/******************************************************************/

 T0011DC5:   CMD        PROMPT('Delete Objects for Example 3')
             PARM       KWD(LIBRARY) TYPE(*NAME) LEN(10) RSTD(*NO) +
                          SPCVAL((*NONE)) MIN(1) MAX(1) +
                          ALWUNPRT(*YES) FILE(*NO) FULL(*NO) +
                          EXPR(*NO) VARY(*NO) PASSATR(*NO) +
                          PROMPT('Library containing objects')
             PARM       KWD(SOURCE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*NO) SPCVAL((*NO 'N') (*YES 'Y')) +
                          MIN(0) MAX(1) ALWUNPRT(*NO) FILE(*NO) +
                          FULL(*NO) EXPR(*YES) VARY(*NO) +
                          PASSATR(*NO) PROMPT('Delete source from +
                          QUSRTOOL')
