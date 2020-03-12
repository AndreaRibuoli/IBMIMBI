      **************************************************************
      *  PROGRAM         T0011RI7
      *    This member is included in all the RPG programs.  It has
      *    the varrcd definition used to pass data to and from UIM.
      *  NOTES
      *    The ZAR field is used to check the zipcode in T0011RE5
      *
      *  (C) Copyright IBM Corp. 1993, All rights reserved.
      **************************************************************
     D VARRCD          DS                  INZ
     D  OPT                    1      2B 0
     D  NAME                   3     27
     D  ADDR                  28     57
     D  CITY                  58     77
     D  STATE                 78     79
     D  ZIP                   80     84  0
     D  ZAR                   80     84
      *   Size of the varrcd
     D VLEN            C                   CONST(84)
