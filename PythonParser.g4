parser grammar PythonParser;

options {
	tokenVocab = PythonLexer;
}

// ------------------------------ REGRA PRINCIPAL ------------------------------
code: stat* EOF;

// ------------------------------ INSTRUÇÕES ------------------------------
stat: expr NEWLINE;

// ------------------------------ EXPRESSÕES ------------------------------
expr:
	ids
	| numeros
	| operacoesComExpressoes
	| expressoesEntreParenteses;

// ------------------------------ SUB-REGRAS ------------------------------
ids: ID;

numeros: INT_NUMBER | FLOAT_NUMBER;

operacoesComExpressoes:
	expr (PLUS | MINUS | MULT | DIV | MOD | POW) expr;

expressoesEntreParenteses: LPAREN expr RPAREN;