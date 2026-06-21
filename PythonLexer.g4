lexer grammar PythonLexer;

// ========================================== 1. PALAVRAS-CHAVE (KEYWORDS)
// ==========================================

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

TRUE: 'True';
FALSE: 'False';
NONE: 'None';

AND: 'and';
OR: 'or';
NOT: 'not';

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

// ========================================== 2. SÍMBOLOS E OPERADORES (Precedência Corrigida)
// ==========================================

INT_DIV: '//';
POW: '**';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
MOD: '%';

EQ: '==';
NEQ: '!=';
GTE: '>=';
LTE: '<=';
GT: '>';
LT: '<';

BIT_AND: '&';
BIT_OR: '|';
BIT_XOR: '^';
BIT_NOT: '~';

ADD_ASSIGN: '+=';
SUB_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';
ASSIGN: '=';

LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
LPAREN: '(';
RPAREN: ')';
COMMA: ',';
COLON: ':';
DOT: '.';

// ========================================== 3. LITERAIS (Float primeiro para evitar mascaramento)
// ==========================================

FLOAT_NUMBER: [0-9]+ '.' [0-9]+;
INT_NUMBER: [0-9]+;

STRING:
	'"' (~["\\] | '\\' .)* '"'
	| '\'' (~['\\] | '\\' .)* '\'';

// ========================================== 4. CONTROLADORES DE FLUXO
// ==========================================

NEWLINE: '\r'? '\n';

// ========================================== REQUISITO OBRIGATÓRIO (Encerramento do Arquivo)
// ==========================================

ID: LETTER (LETTER | DIGIT)*;

fragment LETTER: [a-zA-Z_];
fragment DIGIT: [0-9];

WS: [ \t]+ -> skip;