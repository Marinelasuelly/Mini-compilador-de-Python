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

// Operadores Booleanos / Bitwise (Símbolos)
BIT_AND: '&';
BIT_OR: '|';
BIT_XOR: '^';
BIT_NOT: '~';

// Símbolos de Atribuição
ASSIGN: '=';
ADD_ASSIGN: '+=';
SUB_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';

// Símbolos Identificadores de Tipos de Dados (Delimitadores)
SQUOTE: '\'';
DQUOTE: '"';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
LPAREN: '(';
RPAREN: ')';

// Símbolo Identificador de Início de Bloco
COLON: ':';

// ========================================== 2. PALAVRAS-CHAVE (KEYWORDS)
// ==========================================

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

// Tipos de Dados
INT: 'int';
FLOAT: 'float';
STR: 'str';
BOOL: 'bool';
LIST: 'list';
DICT: 'dict';
TUPLE: 'tuple';
SET: 'set';

// Funções Built-in
PRINT: 'print';
INPUT: 'input';
LEN: 'len';
RANGE: 'range';
TYPE: 'type';
OPEN: 'open';
SUM: 'sum';

// Operadores Booleanos (Palavras)
AND: 'and';
OR: 'or';
NOT: 'not';
TRUE: 'True';
FALSE: 'False';

// Demais Palavras-chave
IMPORT: 'import';
FROM: 'from';
IN: 'in';
AS: 'as';
RETURN: 'return';
PASS: 'pass';
BREAK: 'break';
CONTINUE: 'continue';
IS: 'is';
NONE: 'None';
WITH: 'with';

// ========================================== REQUISITO CRUCIAL: REGRAS NO FINAL DO ARQUIVO (Ordem
// estrita: Identificadores -> Letras -> Dígitos -> WS) ==========================================

// 1. Identificadores (Nomes de variáveis/funções)
ID: LETTER (LETTER | DIGIT)*;

// 2. Letras
fragment LETTER: [a-zA-Z_];

// 3. Dígitos
fragment DIGIT: [0-9];

// 4. Espaços em Branco / Linhas (WS -> skip)
WS: [ \t\r\n]+ -> skip;