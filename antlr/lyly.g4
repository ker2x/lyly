/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar lyly;

//terminator : '\n' | ';';

// Any number including number begining with 0
// Because no octal tyvm
INT : 
        Digit+
    ;

// Hex IS usefull, 0x... 0X... as usual :)
HEX
    :
        '0'[xX] HexDigit+
    ;

// Because this FPU thingy is pretty common now. ;)
FLOAT
    :
        Digit+ '.' Digit* ExponentPart?
    |   '.' Digit+ ExponentPart?
    |   Digit+ ExponentPart?
    ;


fragment
    Digit
    :
        [0-9]
    ;

fragment
    HexDigit
    :
        [0-9a-fA-F]
    ;

fragment
    ExponentPart
    :
        [eE] [+-]? Digit+
    ;

fragment
    HexExponentPart
    :
        [pP] [+-]? Digit+
    ;

LineComment
    :
        '//' ~[\r\n]*
        -> skip
    ;

BlockComment
    :
        '/*' .*? '*/'
        -> skip
    ;


             