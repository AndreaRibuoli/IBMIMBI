 /*
 "crtsavf file(qtemp/stdin)"
 "savobj  obj(qwxcrtmd) ",
     "lib(qsys) ",
     "objtype(*pgm) ",
     "dev(*savf) ",
     "savf(qtemp/stdin) ",
     "updhst(*no) ",
     "dtacpr(*no)"
*/
 "crtsavf file(qtemp/stdin)"
 "savobj  obj(example)  ",
     "lib(jupyter) ",
     "objtype(*pgm) ",
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
 walk = c2d( substr( data, X2D(  36 ), 3 ))
 say  '*** Loaddump object descriptor ***' substr( data,  X2D(04) + walk + 1, 30)
 walk = c2d( substr( data,  X2D(CD) + walk + 1, 3)) * 512 + walk
 say  '*** Loaddump object descriptor ***' substr( data,  X2D(04) + walk + 1, 30)
 walk = c2d( substr( data,  X2D(57) + walk + 1, 3)) + walk
 say         substr( data,  X2D(24) + walk + 1, 30)
/*
 say    c2x( substr( data,  walk+   1, 32))
 say    c2x( substr( data,  walk+  33, 32))
 say    c2x( substr( data,  walk+  65, 32))
 say    c2x( substr( data,  walk+  97, 32))
 say    c2x( substr( data,  walk+ 129, 32))
 say    c2x( substr( data,  walk+ 161, 32))
 say    c2x( substr( data,  walk+ 193, 32))
 say    c2x( substr( data,  walk+ 225, 32))
*/
 walk = X2D(C020)
 say  '***      Program Template      ***' substr( data,  X2D(0A) + walk + 1, 30)
 isp  = c2d( substr( data,  X2D(71) + walk + 1, 3)) + walk
 IS   = substr( data, isp + 5, c2d(substr( data,  isp + 2 , 3)) - 4)
 say  '***     Instruction Stream     ***'
 say  c2x(IS)
 odvp = c2d( substr( data,  X2D(75) + walk + 1, 3)) + walk
 ODV  = substr( data, odvp+ 5, c2d(substr( data, odvp + 2 , 3)) - 4)
 say  '***    ODT Directory Vector    ***'
 say  c2x(ODV)
 oesp = c2d( substr( data,  X2D(79) + walk + 1, 3)) + walk
 OES  = substr( data, oesp+ 5, c2d(substr( data, oesp + 2 , 3)) - 4)
 say  '***      ODT Entry String      ***'
 say  c2x(OES)
 varp = c2d( substr( data,  X2D(91) + walk + 1, 3)) + walk
 VAR  = substr( data, varp + 1, c2d(substr( data, X2D(95) + walk + 1, 3)) - ,
                                                                   c2d(substr( data, X2D(91) + walk + 1 , 3)))
 say  '***    Variables and Labels    ***'
 say  c2x(VAR)
 xfrp = c2d( substr( data,  X2D(95) + walk + 1, 3)) + walk
 XFR  = substr( data, xfrp + 1, c2d(substr( data, walk + 6 , 3)) - c2d(substr( data, X2D(95) + walk + 1 , 3)))
 say  '***    Cross-reference         ***'
 say  c2x(XFR)
/*
 say    c2x( substr( data,  walk+   1, 32))
 say    c2x( substr( data,  walk+  33, 32))
 say    c2x( substr( data,  walk+  65, 32))
 say    c2x( substr( data,  walk+  97, 32))
 say    c2x( substr( data,  walk+ 129, 32))
 say    c2x( substr( data,  walk+ 161, 32))
 say    c2x( substr( data,  walk+ 193, 32))
 say    c2x( substr( data,  walk+ 225, 32))
*/
/*
 walk = c2d( substr( data, X2D(  75 ),        3 ))
 walk = c2d( substr( data, X2D(  1D ) + walk, 3 ))
 walk = c2d( substr( data, X(  75 ) + walk, 3 ))
 walk = c2d( substr( data, X(  45 ) + walk, 3 ))
 walk = c2d( substr( data, X( 665 ) + walk, 3 )) + X( 0 )
 name = walk + x2d( 22A0 )
 code = walk + x2d( 3980 )
 do while walk < name
    AA = c2d( substr( data, walk,      4 ))
    BB = c2d( substr( data, walk +  4, 2 ))
    CC = c2d( substr( data, walk +  6, 2 ))
    DD = c2d( substr( data, walk +  8, 2 ))
    EE = c2d( substr( data, walk + 10, 2 ))
    if BB == 0 then leave
    show = left( substr( data, name + AA, BB ), 20 )
    do DD while EE == 0
       show = show ||,
          right( c2d( substr( data, code + CC * 4, 4 )), 6 )
       CC = CC + 1
    end
    say show
    walk = walk + 12
 end
 return
 X: return x2d( 5001 ) + x2d( arg( 1 ))
*/
