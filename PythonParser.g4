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
	expressoesEntreParenteses					# parenExpr
	| <assoc = right> expr POW expr				# operacoesComExpressoes
	| expr (MULT | DIV | INT_DIV | MOD) expr	# operacoesComExpressoes
	| expr (PLUS | MINUS) expr					# operacoesComExpressoes
	| ids										# idExpr
	| numeros									# numExpr;

// ------------------------------ SUB-REGRAS ------------------------------
ids: ID;

numeros: INT_NUMBER | FLOAT_NUMBER;

expressoesEntreParenteses: LPAREN expr RPAREN;