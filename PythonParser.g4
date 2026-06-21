parser grammar PythonParser;

options {
	tokenVocab = PythonLexer;
}

// ========================================== 1. REGRAS PRINCIPAIS DE ENTRADA
// ==========================================

/**
 * Ponto de entrada do mini-compilador (Atualizado para a Fase 6).
 Aceita instruções,
 * condicionais,
 definições de funções, chamadas ou quebras de linha.
 */
code: (stat | condicional | func | func_call | NEWLINE)* EOF;

/**
 * Definição de instruções isoladas seguidas por quebra de linha.
 */
stat: (return_stmt | atribuicao | expr | query) NEWLINE;

/**
 * Estrutura formal para atribuição de valores a variáveis.
 */
atribuicao: ID ASSIGN expr;

// ========================================== 2. ESTRUTURAS DE FUNÇÕES (FASE 6)
// ==========================================

/**
 * Estrutura de definição de funções: def nome(parametros):
 */
func: DEF ID LPAREN parametros? RPAREN COLON NEWLINE stat+;

/**
 * Lista opcional de parâmetros separados por vírgula na definição da função.
 */
parametros: ID (COMMA ID)*;

/**
 * Estrutura de chamada de funções: nome(argumentos)
 */
func_call: ID LPAREN argumentos? RPAREN;

/**
 * Lista opcional de argumentos (valores ou expressões) separados por vírgula.
 */
argumentos: expr (COMMA expr)*;

/**
 * Instrução de retorno dentro de funções: return expressao
 */
return_stmt: RETURN expr;

// ========================================== 3. ESTRUTURAS CONDICIONAIS (FASE 5)
// ==========================================

condicional:
	IF query COLON NEWLINE stat+ (condicionalElif)* (
		condicionalElse
	)?;

condicionalElif: ELIF query COLON NEWLINE stat+;

condicionalElse: ELSE COLON NEWLINE stat+;

// ========================================== 4. EXPRESSÕES ARITMÉTICAS
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

// ========================================== 5. EXPRESSÕES LÓGICAS / QUERIES
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