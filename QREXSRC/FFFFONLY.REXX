 "crtsavf file(qtemp/stdin)"
 "savlib ",
     "lib(ibmimbi) ",
     "dev(*savf) ",
     "savf(qtemp/stdin) ",
     "updhst(*no) ",
     "dtacpr(*no)"
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
 nxtp = nxtp + 112
 do count = 1 to numobjs
   if c2d(substr(data, nxtp+1, 3)) = 0 then leave
   say count||')' substr(data, nxtp+1, 30) 'type:' c2x(substr(data, nxtp+X2D(1E)+1,2))
   say '  User:'  substr(data, nxtp+X2D(20)+1,30)
   say '  Object OIR info offset 0x' || c2x(substr(data, nxtp+X2D(4B)+1, 4))
   say '  Object other    offset 0x' || c2x(substr(data, nxtp+X2D(4F)+1, 4))
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
   nxtp = c2d( substr( data,  X2D(75) + nxtp + 1, 3)) + nxtp
   say "Avanzo in base al numero di record (da 512 byte) utilizzati dall'oggetto" curobj
   walk = walk + cursize                                                                                              
  end
  say 'remnumobjs:' remnumobjs ', numobjs:' numobjs
  remnumobjs = remnumobjs - numobjs
  if remnumobjs = 0 then leave
  if c2x( substr(data, walk+1, 4)) <> 'FFFFFFFF' then leave
 end
