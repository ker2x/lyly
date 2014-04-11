/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar lyly;

NL : '\r'? '\n';
SC : ';';
DOT : '.';
Terminator : (NL|SC);

WS
    : (' '|'\t')+
    -> skip;

String : '"' ~('\\' | '"')* '"';

LineComment
    :   '//' ~[\r\n]*
    -> skip;

BlockComment
    :   '/*' .*? '*/'
    -> skip;

Number
    :   Int
    |   Hex
    |   Float
    ;

Int : Digit+;

Hex : '0'[xX] HexDigit+;

Float 
    :   Digit+ '.' Digit* ExponentPart?
    |   '.' Digit+ ExponentPart?
    |   Digit+ ExponentPart?
    ;


fragment
    Digit : [0-9];

fragment
    HexDigit : [0-9a-fA-F];

fragment
    ExponentPart : [eE] [+-]? Digit+;

fragment
    HexExponentPart : [pP] [+-]? Digit+;



             