parser grammar PythonParser;

options {
	tokenVocab = PythonLexer;
}

// ========================================== 1. REGRAS PRINCIPAIS DE ENTRADA
// ==========================================

/**
 * Ponto de entrada do mini-compilador.
 Permite instruções, condicionais ou quebras de linha vazias
 * consecutivas.
 */
code: (stat | condicional | NEWLINE)* EOF;

/**
 * Definição de instruções isoladas seguidas por quebra de linha.
 */
stat: (atribuicao | expr | query) NEWLINE;

/**
 * Estrutura formal para atribuição de valores a variáveis.
 */
atribuicao: ID ASSIGN expr;

// ========================================== 2. ESTRUTURAS CONDICIONAIS (FASE 5)
// ==========================================

condicional:
	IF query COLON NEWLINE stat+ (condicionalElif)* (
		condicionalElse
	)?;

condicionalElif: ELIF query COLON NEWLINE stat+;

condicionalElse: ELSE COLON NEWLINE stat+;

// ========================================== 3. EXPRESSÕES ARITMÉTICAS
// ==========================================

expr:
	expressoesEntreParenteses					# parenExpr
	| <assoc = right> expr POW expr				# powExpr
	| expr (MULT | DIV | INT_DIV | MOD) expr	# mulDivExpr
	| expr (PLUS | MINUS) expr					# addSubExpr
	| ids										# idExpr
	| numeros									# numExpr;

ids: ID;

numeros: INT_NUMBER | FLOAT_NUMBER;

expressoesEntreParenteses: LPAREN expr RPAREN;

// ========================================== 4. EXPRESSÕES LÓGICAS / QUERIES
// ==========================================

query:
	queryEntreParenteses		# parenQuery
	| NOT query					# notQuery
	| query AND query			# andQuery
	| query OR query			# orQuery
	| relacoesEntreExpressoes	# relQuery
	| valoresBooleanos			# boolQuery;

valoresBooleanos: TRUE | FALSE;

relacoesEntreExpressoes:
	expr (EQ | NEQ | GT | LT | GTE | LTE) expr;

queryEntreParenteses: LPAREN query RPAREN;