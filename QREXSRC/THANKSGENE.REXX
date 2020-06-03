/*
*/
 "crtsavf file(qtemp/stdin)"
/*
 "savobj  obj(example*) ",
     "lib(ibmimbi) ",
     "objtype(*all) ",
     "dev(*savf) ",
     "savf(qtemp/stdin) ",
     "updhst(*no) ",
     "dtacpr(*no)"
*/
 "savlib ",
     "lib(ibmimbi) ",
     "dev(*savf) ",
     "savf(qtemp/stdin) ",
     "updhst(*no) ",
     "dtacpr(*no)"
/*
*/
 "ovrdbf  file(stdin) ",
     "tofile(qtemp/stdin)"
 "ovrprtf file(stdout) ",
     "tofile(qsysprt) ",
     "splfname(prtbuiltin)"
 data = ''
 do forever
    parse linein record
    if record == '' then leave
    data = data || left( record, 512 )
 end
 walk = 0
 nxtp = 0
 idate = substr( data, nxtp+1, 8)
 odate = '                 '
 'CALL QSYS/QWCCVTDT PARM(*DTS &idate *YYMD &odate *NULL)'
 say 'Marcatura temporale del       'substr(odate,7,2)'/'substr(odate,5,2)'/'substr(odate,1,4) ,
     substr(odate,9,2)':'substr(odate,11,2)':'substr(odate,13,2)
 say 'Numero record (da 512 byte)   'c2d( substr( data,  nxtp+X2D(08)+1, 4))
 say 'Formato load/dump interno   0x'c2x( substr( data,  nxtp+X2D(0C)+1, 2))
 say 'Formato load/dump esterno   0x'c2x( substr( data,  nxtp+X2D(0E)+1, 2))
 say 'Modello sistema e processore  '||   substr( data,  nxtp+X2D(10)+1, 32)
 say 'Versione OS massima (?)     0x'c2x( substr( data,  nxtp+X2D(30)+1, 2))
 say 'Versione OS minima  (?)     0x'c2x( substr( data,  nxtp+X2D(32)+1, 2))
 say 'Dimensione pagina             'c2d( substr( data,  nxtp+X2D(34)+1, 4))
 say 'Numero record in UINT(8)      'c2d( substr( data,  nxtp+X2D(38)+1, 8))
   say    c2x( substr( data,  nxtp+ 1, 16))
   say    c2x( substr( data,  nxtp+17, 16))
   say    c2x( substr( data,  nxtp+33, 16))
   say    c2x( substr( data,  nxtp+49, 16))

 /* Salto alla pagina successiva */
   walk = c2d(substr(data, nxtp+X2D(34)+1, 4))
   totnumobjs = 0
   remnumobjs = 0
  do forever
   nxtp = walk
   say  '*** Dump Descriptor *** (0x'c2x( substr(data, nxtp+1, 4))')'
   say    c2x( substr( data,  nxtp+X2D(00)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(10)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(20)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(30)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(50)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(60)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(70)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(80)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(90)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(A0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(B0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(C0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(D0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(E0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(F0)+1, 16))
   off      =  substr( data,  nxtp+X2D(44)+1, 4)
   say 'Dimensione descrittore 0x'||c2x(off) '('||c2d(off)||')'
   say 'Numero record successivi 'c2d( substr( data, nxtp+X2D(48)+1, 4))
   say 'Dimensione record        'c2d( substr( data, nxtp+X2D(4C)+1, 4))
   say 'Gli ultimi 16 byte:' c2x(substr(data, nxtp+c2d(off)-16+1, 16))
   say substr(data, walk+X2D(96)+1, 24) substr(data,  walk+X2D(04)+1, 30)
 /* pagesize = c2d(substr(data, walk+X2D(56)+1, 4))  */
   pagesize = X2D(1000)
 cursize  = c2d(substr(data, walk+X2D(CC)+1, 4)) * 512
 say  'Determinata la cursize' cursize
 /* Salto alla pagina successiva */
 nxtp = walk + pagesize
 curobj = substr(data, nxtp+X2D(24)+1, 30)                                                                        
 say  'Dump descriptor catalog' curobj  'type' c2x(substr(data, nxtp+X2D(22)+1, 2))
 /* Salto alla pagina successiva */
 nxtp = nxtp + pagesize
 say  '*** Catalog Header ***'
 say  'Libreria di provenienza oggetti salvati' substr(data, nxtp+X2D(02)+1 , 30)
 if totnumobjs = 0 then do
   totnumobjs = c2d(substr(data, nxtp+X2D(48)+1, 4))
   remnumobjs = totnumobjs
 end
 numobjs = c2d(substr(data, nxtp+X2D(2A)+1, 4))
 say  'Numero' numobjs 'oggetti salvati di' totnumobjs 'totali'
/*
   say    c2x( substr( data,  nxtp+X2D(00)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(10)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(20)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(30)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(50)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(60)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(70)+1, 16))
*/
 nxtp = nxtp + 112
/*
   say    c2x( substr( data,  nxtp+X2D(00)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(10)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(20)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(30)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(50)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(60)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(70)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(80)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(90)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(A0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(B0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(C0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(D0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(E0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(F0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(100)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(110)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(120)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(130)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(140)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(150)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(160)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(170)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(180)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(190)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1A0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1B0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1C0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1D0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1E0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(1F0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(200)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(210)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(220)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(230)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(240)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(250)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(260)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(270)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(280)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(290)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2A0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2B0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2C0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2D0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2E0)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(2F0)+1, 16))
*/
 do count = 1 to numobjs
   if c2d(substr(data, nxtp+1, 3)) = 0 then leave
   say count||')' substr(data, nxtp+1, 30) 'type:' c2x(substr(data, nxtp+X2D(1E)+1,2))
   say '  User:'  substr(data, nxtp+X2D(20)+1,30)
   say '  Object OIR info offset 0x' || c2x(substr(data, nxtp+X2D(4B)+1, 4))
   say '  Object other    offset 0x' || c2x(substr(data, nxtp+X2D(4F)+1, 4))
/*
   say '  ' c2x( substr( data,  nxtp+X2D(40)+1, 16))
   say '  ' c2x( substr( data,  nxtp+X2D(50)+1, 16))
   say '  ' c2x( substr( data,  nxtp+X2D(60)+1, 16))
*/
   nxtp = nxtp + 151
 end
 say "Avanzo in base al numero di record (da 512 byte) utilizzati dall'oggetto" curobj
 walk = walk + cursize
 /* do count = 1 to numobjs */
 do forever
   if c2x( substr(data, walk+1, 4)) <> 'FFFFFFFF' then leave
   if substr(data, walk+5, 30) = 'QSRDSSPC.1                    ' then leave
   nxtp = walk
   say  '*** Dump Descriptor *** (0x'c2x( substr(data, nxtp+1, 4))')'
   say    c2x( substr( data,  nxtp+X2D(00)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(10)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(20)+1, 16))
/*
   say    c2x( substr( data,  nxtp+X2D(30)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(50)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(60)+1, 16))
   say    c2x( substr( data,  nxtp+X2D(70)+1, 16))
*/
   cursize  = c2d( substr( data,  X2D(CC) + walk + 1, 4)) * 512
   say  'Determinata la cursize' cursize
   say  substr( data,  X2D(96) + walk + 1, 24) substr( data,  X2D(04) + walk + 1, 30)
   say  'Offset nel dump descriptor catalog' c2d( substr( data,  X2D(25) + walk + 1, 3))
   off      =  substr( data,  nxtp+X2D(44)+1, 4)
   say 'Dimensione descrittore 0x'||c2x(off) '('||c2d(off)||')'
   say 'Numero record successivi 'c2d( substr( data, nxtp+X2D(48)+1, 4))
   say 'Dimensione record        'c2d( substr( data, nxtp+X2D(4C)+1, 4))
   say 'Gli ultimi 16 byte:' c2x(substr(data, nxtp+c2d(off)-16+1, 16))
   say substr(data, walk+X2D(96)+1, 24) substr(data,  walk+X2D(04)+1, 30)
   say  'Actual object header is on the new page'
   nxtp = walk + pagesize
   curobj = substr( data,  X2D(24) + nxtp + 1, 30)
/*
   say  'Program header' curobj
   say    c2x( substr( data,  nxtp+   1, 32))
   say    c2x( substr( data,  nxtp+  33, 32))
   say    c2x( substr( data,  nxtp+  65, 32))
   say    c2x( substr( data,  nxtp+  97, 32))
   say    c2x( substr( data,  nxtp+ 129, 32))
   say    c2x( substr( data,  nxtp+ 161, 32))
   say    c2x( substr( data,  nxtp+ 193, 32))
   say    c2x( substr( data,  nxtp+ 225, 32))
   say    c2x( substr( data,  nxtp+ 257, 32))
   say    c2x( substr( data,  nxtp+ 289, 32))
   say    c2x( substr( data,  nxtp+ 321, 32))
   say    c2x( substr( data,  nxtp+ 353, 32))
   say    c2x( substr( data,  nxtp+ 385, 32))
   say    c2x( substr( data,  nxtp+ 417, 32))
   say    c2x( substr( data,  nxtp+ 449, 32))
   say    c2x( substr( data,  nxtp+ 481, 32))
*/
   nxtp = c2d( substr( data,  X2D(75) + nxtp + 1, 3)) + nxtp
/*
   say    c2x( substr( data,  nxtp+   1, 32))
   say    c2x( substr( data,  nxtp+  33, 32))
   say    c2x( substr( data,  nxtp+  65, 32))
   say    c2x( substr( data,  nxtp+  97, 32))
   say    c2x( substr( data,  nxtp+ 129, 32))
   say    c2x( substr( data,  nxtp+ 161, 32))
   say    c2x( substr( data,  nxtp+ 193, 32))
   say    c2x( substr( data,  nxtp+ 225, 32))
   say    c2x( substr( data,  nxtp+ 257, 32))
   say    c2x( substr( data,  nxtp+ 289, 32))
   say    c2x( substr( data,  nxtp+ 321, 32))
   say    c2x( substr( data,  nxtp+ 353, 32))
   say    c2x( substr( data,  nxtp+ 385, 32))
   say    c2x( substr( data,  nxtp+ 417, 32))
   say    c2x( substr( data,  nxtp+ 449, 32))
   say    c2x( substr( data,  nxtp+ 481, 32))
*/
/*
   say   'Testing offset 0x05 ' c2x( substr( data,  X2D(05) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(0D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(15) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(25) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(2D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(35) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(3D) + nxtp + 1, 3))
   say   'Testing offset 0x45 ' c2x( substr( data,  X2D(45) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(4D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(55) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(5D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(65) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(6D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(75) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(7D) + nxtp + 1, 3))
   say   'Testing offset 0x85 ' c2x( substr( data,  X2D(85) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(8D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(95) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(9D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(A5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(AD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(B5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(BD) + nxtp + 1, 3))
   say   'Testing offset 0xC5 ' c2x( substr( data,  X2D(C5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(CD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(D5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(DD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(E5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(ED) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(F5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(FD) + nxtp + 1, 3))
   say   'Testing offset 0x105 ' c2x( substr( data,  X2D(105) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(10D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(115) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(11D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(125) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(12D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(135) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(13D) + nxtp + 1, 3))
   say   'Testing offset 0x145 ' c2x( substr( data,  X2D(145) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(14D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(155) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(15D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(165) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(16D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(175) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(17D) + nxtp + 1, 3))
   say   'Testing offset 0x185 ' c2x( substr( data,  X2D(185) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(18D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(195) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(19D) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1A5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1AD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1B5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1BD) + nxtp + 1, 3))
   say   'Testing offset 0x1C5 ' c2x( substr( data,  X2D(1C5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1CD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1D5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1DD) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1E5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1ED) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1F5) + nxtp + 1, 3)) ,
                                c2x( substr( data,  X2D(1FD) + nxtp + 1, 3))
*/
   say   'Testing offset 0x3E1 ' c2x( substr( data,  X2D(3E1) + nxtp + 1, 3))
/* ACCROCCHIO DA SISTEMARE */
/*
   if count = 1 then  nxtp = X2D(C020)
   if count = 2 then  nxtp = X2D(13020)
   if count = 3 then  nxtp = X2D(13020)
   if count = 3 then  nxtp = X2D(1A020)
*/
/* ACCROCCHIO DA SISTEMARE */
/*
   say  '***      Program Template      ***' substr( data,  X2D(0A) + nxtp + 1, 30)
   isp  = c2d( substr( data,  X2D(71) + nxtp + 1, 3)) + nxtp
   IS   = substr( data, isp + 5, c2d(substr( data,  isp + 2 , 3)) - 4)
   say  '***     Instruction Stream     ***'
   say  c2x(IS)
   odvp = c2d( substr( data,  X2D(75) + nxtp + 1, 3)) + nxtp
   ODV  = substr( data, odvp+ 5, c2d(substr( data, odvp + 2 , 3)) - 4)
   say  '***    ODT Directory Vector    ***'
   say  c2x(ODV)
   oesp = c2d( substr( data,  X2D(79) + nxtp + 1, 3)) + nxtp
   OES  = substr( data, oesp+ 5, c2d(substr( data, oesp + 2 , 3)) - 4)
   say  '***      ODT Entry String      ***'
   say  c2x(OES)
*/
  /*
   varp = c2d( substr( data,  X2D(91) + nxtp + 1, 3)) + nxtp
   VAR  = substr( data, varp + 1, c2d(substr( data, X2D(95) + nxtp + 1, 3)) - ,
                                                                   c2d(substr( data, X2D(91) + nxtp + 1 , 3)))
   say  '***    Variables and Labels    ***'
   say  c2x(VAR)
   xfrp = c2d( substr( data,  X2D(95) + nxtp + 1, 3)) + nxtp
   XFR  = substr( data, xfrp + 1, c2d(substr( data, nxtp + 6 , 3)) - c2d(substr( data, X2D(95) + nxtp + 1 , 3)))
   say  '***    Cross-reference         ***'
   say  c2x(XFR)
  */
   say "Avanzo in base al numero di record (da 512 byte) utilizzati dall'oggetto" curobj
   walk = walk + cursize                                                                                              
  end
  say 'remnumobjs:' remnumobjs ', numobjs:' numobjs
  remnumobjs = remnumobjs - numobjs
  if remnumobjs = 0 then leave
  if c2x( substr(data, walk+1, 4)) <> 'FFFFFFFF' then leave
 end
