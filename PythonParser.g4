parser grammar PythonParser;

options {
	tokenVocab = PythonLexer;
}

// ========================================== 1. REGRAS PRINCIPAIS DE ENTRADA
// ==========================================

/**
 * Ponto de entrada do mini-compilador (Atualizado para a Fase 7).
 Permite instruções,
 * condicionais, funções, chamadas, loops ou quebras de linha.
 */
code: (
		stat
		| condicional
		| func
		| func_call
		| loop_while
		| loop_for
		| NEWLINE
	)* EOF;

/**
 * Definição de instruções isoladas seguidas por quebra de linha.
 */
stat: (return_stmt | atribuicao | expr | query) NEWLINE;

/**
 * Estrutura formal para atribuição de valores a variáveis.
 */
atribuicao: ID ASSIGN expr;

// ========================================== 2. ESTRUTURAS DE REPETIÇÃO / LOOPS (FASE 7)
// ==========================================

/**
 * Estrutura de repetição while: while condicao:
 */
loop_while: WHILE query COLON NEWLINE stat+;

/**
 * Estrutura de repetição for simplificada: for i in range(x): ou for i in lista:
 Aceita uma query
 * ou uma expressão geral após a keyword IN.
 */
loop_for: FOR ID IN expr COLON NEWLINE stat+;

// ========================================== 3. ESTRUTURAS DE FUNÇÕES (FASE 6)
// ==========================================

func: DEF ID LPAREN parametros? RPAREN COLON NEWLINE stat+;

parametros: ID (COMMA ID)*;

func_call: ID LPAREN argumentos? RPAREN;

argumentos: expr (COMMA expr)*;

return_stmt: RETURN expr;

// ========================================== 4. ESTRUTURAS CONDICIONAIS (FASE 5)
// ==========================================

condicional:
	IF query COLON NEWLINE stat+ (condicionalElif)* (
		condicionalElse
	)?;

condicionalElif: ELIF query COLON NEWLINE stat+;

condicionalElse: ELSE COLON NEWLINE stat+;

// ========================================== 5. EXPRESSÕES ARITMÉTICAS
// ==========================================

expr:
	expressoesEntreParenteses					# parenExpr
	| func_call									# funcCallExpr
	| <assoc = right> expr POW expr				# powExpr
	| expr (MULT | DIV | INT_DIV | MOD) expr	# mulDivExpr
	| expr (PLUS | MINUS) expr					# addSubExpr
	| ids										# idExpr
	| numeros									# numExpr;

ids: ID;

numeros: INT_NUMBER | FLOAT_NUMBER;

expressoesEntreParenteses: LPAREN expr RPAREN;

// ========================================== 6. EXPRESSÕES LÓGICAS / QUERIES
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