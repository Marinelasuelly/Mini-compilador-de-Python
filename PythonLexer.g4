lexer grammar PythonLexer;

// ========================================== 1. SÍMBOLOS ==========================================

// Operadores Aritméticos
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
INT_DIV: '//';
MOD: '%';
POW: '**';

// Operadores Relacionais
EQ: '==';
NEQ: '!=';
GT: '>';
LT: '<';
GTE: '>=';
LTE: '<=';

// Operadores Booleanos / Bitwise
BIT_AND: '&';
BIT_OR: '|';
BIT_XOR: '^';
BIT_NOT: '~';

// Atribuição
ASSIGN: '=';
ADD_ASSIGN: '+=';
SUB_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';

// Delimitadores
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
LPAREN: '(';
RPAREN: ')';
COMMA: ',';
COLON: ':';
DOT: '.';

// ========================================== 2. PALAVRAS-CHAVE ==========================================

// Identificadoras de Blocos
IF: 'if';
ELIF: 'elif';
ELSE: 'else';
FOR: 'for';
WHILE: 'while';
DEF: 'def';
CLASS: 'class';
TRY: 'try';
EXCEPT: 'except';
FINALLY: 'finally';

// Booleanos
TRUE: 'True';
FALSE: 'False';
NONE: 'None';

// Operadores Booleanos (palavras)
AND: 'and';
OR: 'or';
NOT: 'not';

// Demais Keywords
IMPORT: 'import';
FROM: 'from';
IN: 'in';
AS: 'as';
RETURN: 'return';
PASS: 'pass';
BREAK: 'break';
CONTINUE: 'continue';
IS: 'is';
WITH: 'with';

// ========================================== 3. LITERAIS ==========================================

INT_NUMBER: [0-9]+;
FLOAT_NUMBER: [0-9]+ '.' [0-9]+;

STRING
    : '"' (~["\\] | '\\' .)* '"'
    | '\'' (~['\\] | '\\' .)* '\''
    ;

// ========================================== 4. NOVA LINHA ==========================================
// Separado do WS para poder ser usado no Parser como terminador de instrução (stat: expr NEWLINE;)

NEWLINE: '\r'? '\n';

// ========================================== REQUISITO CRUCIAL: REGRAS NO FINAL DO ARQUIVO (Ordem
// estrita: Identificadores -> Letras -> Dígitos -> WS) ==========================================

// 1. Identificadores (Nomes de variáveis/funções)
ID: LETTER (LETTER | DIGIT)*;

// 2. Letras
fragment LETTER: [a-zA-Z_];

// 3. Dígitos
fragment DIGIT: [0-9];

// 4. Espaços em Branco (WS -> skip). Note que '\n' já não está aqui, pois agora tem o seu próprio token (NEWLINE).
WS: [ \t]+ -> skip;
