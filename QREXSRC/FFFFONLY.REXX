/*
*/
 "crtsavf file(qtemp/stdin)"
 "savlib ",
     "lib(ibmimbi) ",
     "dev(*savf) ",
     "savf(qtemp/stdin) ",
     "updhst(*no) ",
     "TGTRLS(*prv) ",
     "dtacpr(*no)"
/*
*/
 "ovrdbf  file(stdin) ",
     "tofile(qtemp/stdin)"
 "ovrprtf file(stdout) ",
     "tofile(qsysprt) ",
     "splfname(prtbuiltin)"
 data = ''
 count = 0
 last16_2 = ''
 last16_3 = ''
 last16_4 = ''
 last16_5 = ''
 last16_6 = ''
 last16_7 = ''
 last16_8 = ''
 do forever
    parse linein record
    count = count + 1
    if count = 2 then last16_2 = substr(record, 513, 16)
    if count = 3 then last16_3 = substr(record, 513, 16)
    if count = 4 then last16_4 = substr(record, 513, 16)
    if count = 5 then last16_5 = substr(record, 513, 16)
    if count = 6 then last16_6 = substr(record, 513, 16)
    if count = 7 then last16_7 = substr(record, 513, 16)
    if count = 8 then last16_8 = substr(record, 513, 16)
    if record == '' then leave
    data = data || left( record, 512 )
 end
 walk = 0
 nxtp = 0
 base = 0
 idate = substr( data, nxtp+1, 8)
 dts = C2X(substr(data,nxtp+1,8))
 odate = '                    '
 'CALL QSYS/QWCCVTDT PARM(*DTS &idate *YYMD &odate *NULL)'
 say '.       SSSSS        AA   VV        VV  EEEEEEEEEE  FFFFFFFFFFF  III  LLL         EEEEEEEEEE'
 say '.     SSS   SSS     AAAA   VV       VV  EEE         FFF          III  LLL         EEE'
 say '.    SS            AAAAAA   VV     VV   EEE         FFF          III  LLL         EEE'
 say '.     SSSS         AA   AA   VV    VV   EEEEEEE     FFFFFFF      III  LLL         EEEEEEE'
 say '.        SSSSS    AAA    AA   VV  VV    EEE         FFF          III  LLL         EEE'
 say '.           SSS   AAAAAAAAAA   VVVVV    EEE         FFF          III  LLL         EEE'
 say '.     SS    SSS  AAA       AA   VVV     EEE         FFF          III  LLL         EEE'
 say '.      SSSSSS   AAA         AA   VV     EEEEEEEEEE  FFF          III  LLLLLLLLLL  EEEEEEEEEE'
 say '.'
 say 'I primi 8 byte di un savefile sono composti da un timestamp in un formato interno al sistema e noto come *DST.'
 say 'Si tratta di un numero binario, BIN(8), che esprime i microsecondi intercorsi facendo riferimento alla'
 say 'convenzione che al valore esadecimale X''8000000000000000'' debbano corrispondere le ore 0 del 1 Gennaio 2000.'
 say 'Nel nostro caso tale marcatura temporale vale X'''dts''' che corrisponde al timestamp' ,
     substr(odate,7,2)'/'substr(odate,5,2)'/'substr(odate,1,4) ,
     substr(odate,9,2)':'substr(odate,11,2)':'substr(odate,13,2)'.'substr(odate,15,6)
 say '.'
 say '+------------------+-'
 say '|    *DST BIN(8)   +-'
 say '+------------------+-'
 say '| ' ||  dts  ||  ' |'
 say '+------------------+-'
 say '.'
 say 'I successivi 4 byte, BIN(4), dichiarano la lunghezza dell''intero savefile espressa in numero record.'
 say 'La lunghezza utile del record è di 512 byte a cui si aggiungono 16 byte di controllo quando il savefile'
 say 'viene trasferito. Tutti gli scostamenti interni al savefile si riferiscono al contenuto "depurato" dei byte di'
 say 'controllo. Di questi ultimi 16 i primi 4 rappresentano il sequenziale record (si parte dal numero 1). I 12 byte'
 say 'finali sono determinati da un checksum proprietario basato sui 512 byte + 4 (del sequenziale numerico) con la'
 say 'aggiunta della marcatura temporale sopra descritta (8 byte).'
 say 'Importante osservare che la marcatura temporale del primo record interviene nel calcolo del checksum di *tutti*'
 say 'i record successivi. A parte questo aspetto, l''algoritmo del checksum di riga non dipende dal contenuto degli'
 say 'altri record.'
 say '.'
 nrecs = c2d(substr(data,nxtp+X2D(08)+1,4))
 say 'Nel nostro caso l''esadecimale  X'''c2x(substr(data,nxtp+X2D(08)+1,4))''' corrisponde a' nrecs 'record.'
 say 'Dalla introduzione della architettura RISC (PowerPC) il numero record è sempre multiplo di 8 in quanto 4096 è'
 say 'la unità minima di allocazione memoria (pagina): occorrono 8 record da 512 per memorizzare una pagina da 4096.'
 say 'Nel savefile in oggetto il numero di pagine coinvolto è' nrecs'/8 =' (nrecs/8)
 say 'Indirettamente questo cambiamento ha reso di facile comprensione quale fosse la logica del checksum (benchè non'
 say 'resa pubblica da parte di IBM): i sette record dopo il primo avevano tutti i 512 byte pari a X''00''.'
 say 'Questo ha involontariamente presentato il fianco ad una sorta di ''chosen-plaintext attack''. Ad esempio,'
 say 'in questo savefile i 16 byte finali del secondo record valgono X'''c2x(last16_2)''','
 say '                                    del terzo record           X'''c2x(last16_3)''','
 say '                                    del quarto record          X'''c2x(last16_4)''','
 say '                                    del quinto record          X'''c2x(last16_5)''','
 say '                                    del sesto record           X'''c2x(last16_6)''','
 say '                                    del settimorecord          X'''c2x(last16_7)''','
 say '                                    dell''ottavo record         X'''c2x(last16_8)'''.'
 say 'Ricordandoci che la marcatura temporale iniziale vale                  X'''dts''' si possono più facilemnte fare'
 say 'ipotesi sull''effettivo algoritmo adottato.'
 say '.'
 say '+----------------+--------+-'
 say '|   *DST BIN(8)  + BIN(4) +-'
 say '+----------------+--------+-'
 say '|' ||  dts  ||  '|' || c2x(substr(data,nxtp+X2D(08)+1,4)) || '|'
 say '+----------------+--------+-'
 say '.'
 say 'Seguono due campi BIN(2) che fanno presumibilmente riferimento ad un valore che identifica la versione'
 say 'del formato del savefile adottato. Durante un ripristino è controllato, tuttavia, solo il secondo valore.'
 say 'Il formato dei savefile è dunque "versionato" e questo è abbastanza comprensibile affinché un sistema IBM i possa'
 say 'acquisire savefile generati su sistemi diversi aventi anche versioni molto datate.'
 say 'Nonostante questo, la struttura del savefile cambia molto raramente e da diversi rilasci del sistema operativo'
 say 'è ferma alla X''3000''.'
 say '.'
 say '+----------------+--------+----+----+-'
 say '|   *DST BIN(8)  | BIN(4) |    |    | '
 say '+----------------+--------+----+----+-'
 say '|' ||  dts  ||  '|' || c2x(substr(data,nxtp+X2D(08)+1,4)) || '|' || c2x(substr(data,nxtp+X2D(0C)+1,2)) || '|' ,
                                                                       || c2x(substr(data,nxtp+X2D(0E)+1,2)) || '|'
 say '+----------------+--------+----+----+-'
 say '.'
 say 'Segue un campo testo CHAR(32) che contine indicazione del modello di sistema e della feature processore'
 say '.'
 say '+----------------+--------+----+----+-'
 say '|   *DST BIN(8)  | BIN(4) |    |    | '
 say '+----------------+--------+----+----+-'
 say '|' ||  dts  ||  '|' || c2x(substr(data,nxtp+X2D(08)+1,4)) || '|' || c2x(substr(data,nxtp+X2D(0C)+1,2)) || '|' ,
                                                                       || c2x(substr(data,nxtp+X2D(0E)+1,2)) || '|'
 say '+----------------+--------+----+----+-'
 say '|   CHAR(32)                        > '
 say '+-------------------------------------'
 say '| ' || c2x(substr(data,nxtp+X2D(10)+1,16)) || '  >'
 say '| ' || c2x(substr(data,nxtp+X2D(20)+1,16)) || '  |'
 say '------------------------------------+-'
 say '.'
 say 'Nel nostro caso (essendo espresso in EBCDIC) l''esadecimale corrisponde alla dicitura:' ,
       substr(data,nxtp+X2D(10)+1,32)
 say '.'
 say 'A seguire abbiamo altri quattro campi: BIN(2), BIN(2), BIN(4) e BIN(8). L''ultimo ripete il numero record'
 say 'archiviati con maggiori possibilità di dimensione del valore, il penultimo dovrebbe segnalare la dimensione'
 say 'della pagina di memoria (era X''00000200'' ai tempi del CISC).'
 say 'Il secondo campo di questa ultima serie sembra indicare una versione minima del sistema operativo per cui'
 say 'è ipotizzato il ripristino. Pur retrocedendo in un SAVLIB *PRV il valore effettivo differisce dalla'
 say 'versione esatta che è indicata altrove.'
 say 'Anche questo campo è di fatto ignorato all''atto di un ripristino: ovviamente questa come altre asserzioni'
 say 'che possono essere fatte sul formato dei savefile è sempre soggetta ad essere contraddetta in evoluzioni'
 say 'future del sistema operativo.'
 say '.'
 say '+----------------+--------+----+----+-'
 say '|   *DST BIN(8)  | BIN(4) |    |    | '
 say '+----------------+--------+----+----+-'
 say '|' ||  dts  ||  '|' || c2x(substr(data,nxtp+X2D(08)+1,4)) || '|' || c2x(substr(data,nxtp+X2D(0C)+1,2)) || '|' ,
                                                                       || c2x(substr(data,nxtp+X2D(0E)+1,2)) || '|'
 say '+----------------+--------+----+----+-'
 say '|   CHAR(32)                        > '
 say '+-------------------------------------'
 say '| ' || c2x(substr(data,nxtp+X2D(10)+1,16)) || '  >'
 say '| ' || c2x(substr(data,nxtp+X2D(20)+1,16)) || '  |'
 say '+----+----+--------+----------------+-'
 say '|    |    | BIN(4) |    BIN(8)      | '
 say '+----+----+--------+----------------+-'
 say '|' ||  c2x(substr(data,nxtp+X2D(30)+1,2)) || '|' || c2x(substr(data,nxtp+X2D(32)+1,2)) || '|' ,
         ||  c2x(substr(data,nxtp+X2D(34)+1,4)) || '|' || c2x(substr(data,nxtp+X2D(38)+1,8)) || '|'
 say '+----+----+--------+----------------+-'
 say '.'
 /*
 say 'Numero record totale          'c2d( substr( data,  nxtp+X2D(08)+1, 4))
 say 'Formato load/dump interno   0x'c2x( substr( data,  nxtp+X2D(0C)+1, 2))
 say 'Formato load/dump esterno   0x'c2x( substr( data,  nxtp+X2D(0E)+1, 2))
 say 'Modello sistema e processore  '||   substr( data,  nxtp+X2D(10)+1, 32)
 say 'Versione OS massima (?)     0x'c2x( substr( data,  nxtp+X2D(30)+1, 2))
 say 'Versione OS minima  (?)     0x'c2x( substr( data,  nxtp+X2D(32)+1, 2))
 say 'Dimensione pagina             'c2d( substr( data,  nxtp+X2D(34)+1, 4))
 say 'Numero record totale UINT(8)  'c2d( substr( data,  nxtp+X2D(38)+1, 8))
   say    c2x( substr( data,  nxtp+ 1, 16))
   say    c2x( substr( data,  nxtp+17, 16))
   say    c2x( substr( data,  nxtp+33, 16))
   say    c2x( substr( data,  nxtp+49, 16))
*/
   walk = c2d(substr(data, nxtp+X2D(34)+1, 4))
   totnumobjs = 0
   remnumobjs = 0
  do forever
   nxtp = walk
/*

   say  '*** Dump Descriptor *** (0x'c2x( substr(data, nxtp+1, 4))')'
   say    c2x( substr( data,  nxtp+X2D(00)+1, 64))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 64))
   say    c2x( substr( data,  nxtp+X2D(80)+1, 64))
   say    c2x( substr( data,  nxtp+X2D(C0)+1, 64))
   off      =  substr( data,  nxtp+X2D(44)+1, 4)
   say 'Dimensione descrittore 0x'||c2x(off) '('||c2d(off)||')'
   say 'Numero record successivi 'c2d( substr( data, nxtp+X2D(48)+1, 4))
   say 'Dimensione record        'c2d( substr( data, nxtp+X2D(4C)+1, 4))
   say 'Gli ultimi 16 byte:' c2x(substr(data, nxtp+c2d(off)-16+1, 16))
   say substr(data, walk+X2D(96)+1, 24) substr(data,  walk+X2D(04)+1, 30)
*/
   say 'at 0x'd2x(nxtp,8) 'record' d2x(nxtp/512,8) '+' c2x(substr(data,nxtp+X2D(CC)+1,4)) ,
       '|' c2x(substr(data,nxtp+X2D(48)+1,4)) c2x(substr(data,nxtp+X2D(44)+1,4)) ,
           c2x(substr(data,nxtp+X2D(55)+1,4)) c2x(substr(data,nxtp+X2D(D0)+1,4)) ,
           c2x(substr(data,nxtp+X2D(D4)+1,4)) c2x(substr(data, nxtp+c2d(substr( data, nxtp+X2D(44)+1, 4))-16+1, 16))
 /* pagesize = c2d(substr(data, walk+X2D(56)+1, 4))  */
   pagesize = X2D(1000)
 cursize  = c2d(substr(data, walk+X2D(CC)+1, 4)) * 512
/*  say  'Determinata la cursize' cursize */
 nxtp = walk + pagesize
 curobj = substr(data, nxtp+X2D(24)+1, 30)                                                                        
/* say  'Dump descriptor catalog' curobj  'type' c2x(substr(data, nxtp+X2D(22)+1, 2))  */
 /* Salto alla pagina successiva */
 nxtp = nxtp + pagesize
/* say  '*** Catalog Header ***' */
 say  'Libreria di provenienza oggetti salvati' substr(data, nxtp+X2D(02)+1 , 30)
 if totnumobjs = 0 then do
   totnumobjs = c2d(substr(data, nxtp+X2D(48)+1, 4))
   remnumobjs = totnumobjs
 end
 numobjs = c2d(substr(data, nxtp+X2D(2A)+1, 4))
 /* say  'Numero' numobjs 'oggetti salvati di' totnumobjs 'totali' */
 nxtp = nxtp + 112
 do count = 1 to numobjs
   if c2d(substr(data, nxtp+1, 3)) = 0 then leave
/*
   say (base+count)||')' substr(data, nxtp+1, 30) 'type:' c2x(substr(data, nxtp+X2D(1E)+1,2))
   say '  User:'  substr(data, nxtp+X2D(20)+1,30)
   say    c2x( substr( data,  nxtp+X2D(00)+1, 64))
   say    c2x( substr( data,  nxtp+X2D(40)+1, 64))
   say    c2x( substr( data,  nxtp+X2D(80)+1, 23))
   say '  Numero o offset?       0x' || c2x(substr(data, nxtp+X2D(3F)+1, 4))
   say '  Numero o offset?       0x' || c2x(substr(data, nxtp+X2D(43)+1, 4))
   say '  Numero o offset?       0x' || c2x(substr(data, nxtp+X2D(47)+1, 4))
   say '  Object OIR info offset 0x' || c2x(substr(data, nxtp+X2D(4B)+1, 4))
   say '  Object other    offset 0x' || c2x(substr(data, nxtp+X2D(4F)+1, 4))
*/
   nxtp = nxtp + 151
 end
 base = base + numobjs
/*  say "Avanzo in base al numero di record (da 512 byte) utilizzati dall'oggetto" curobj */
 walk = walk + cursize
 /* do count = 1 to numobjs */
 do forever
   if c2x( substr(data, walk+1, 4)) <> 'FFFFFFFF' then leave
   if substr(data, walk+5, 30) = 'QSRDSSPC.1                    ' then leave
   nxtp = walk
   say 'at 0x'd2x(nxtp,8) 'record' d2x(nxtp/512,8) '+' c2x(substr(data,nxtp+X2D(CC)+1,4)) ,
       '|' c2x(substr(data,nxtp+X2D(48)+1,4)) c2x(substr(data,nxtp+X2D(44)+1,4)) ,
           c2x(substr(data,nxtp+X2D(55)+1,4)) c2x(substr(data,nxtp+X2D(D0)+1,4)) ,
           c2x(substr(data,nxtp+X2D(D4)+1,4)) c2x(substr(data, nxtp+c2d(substr( data, nxtp+X2D(44)+1, 4))-16+1, 16))
/*
   say  '*** Dump Descriptor *** (0x'c2x( substr(data, nxtp+1, 4))')'
*/
   cursize  = c2d( substr( data,  X2D(CC) + walk + 1, 4)) * 512
/*
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
*/
   nxtp = walk + pagesize
   curobj = substr( data,  X2D(24) + nxtp + 1, 30)
   nxtp = c2d( substr( data,  X2D(75) + nxtp + 1, 3)) + nxtp
/*   say "Avanzo in base al numero di record (da 512 byte) utilizzati dall'oggetto" curobj  */
   walk = walk + cursize                                                                                              
  end
/*   say 'remnumobjs:' remnumobjs ', numobjs:' numobjs  */
  remnumobjs = remnumobjs - numobjs
  if remnumobjs = 0 then leave
  if c2x( substr(data, walk+1, 4)) <> 'FFFFFFFF' then leave
 end
