parser grammar PythonParser;
options { tokenVocab=PythonLexer; }

// ------------------------------
// REGRA PRINCIPAL
// ------------------------------
code
    : stat* EOF
    ;

// ------------------------------
// INSTRUÇÕES
// ------------------------------
stat
    : (expr | query) NEWLINE
    ;

// ------------------------------
// EXPRESSÕES (ARITMÉTICAS)
// ------------------------------
// A ordem das alternativas define a precedência (primeiro = mais forte).
// POW > (MULT/DIV/INT_DIV/MOD) > (PLUS/MINUS)
expr
    : expressoesEntreParenteses                                # parenExpr
    | <assoc=right> expr POW expr                              # operacoesComExpressoes
    | expr (MULT | DIV | INT_DIV | MOD) expr                    # operacoesComExpressoes
    | expr (PLUS | MINUS) expr                                  # operacoesComExpressoes
    | ids                                                        # idExpr
    | numeros                                                    # numExpr
    ;

ids
    : ID
    ;

numeros
    : INT_NUMBER
    | FLOAT_NUMBER
    ;

expressoesEntreParenteses
    : LPAREN expr RPAREN
    ;

// ------------------------------
// QUERIES (BOOLEANAS / RELACIONAIS)
// ------------------------------
// A ordem das alternativas define a precedência (primeiro = mais forte).
// NOT > AND > OR
query
    : queryEntreParenteses                                      # parenQuery
    | NOT query                                                 # operacoesBooleanasEntreQuerys
    | query AND query                                            # operacoesBooleanasEntreQuerys
    | query OR query                                             # operacoesBooleanasEntreQuerys
    | relacoesEntreExpressoes                                    # relQuery
    | valoresBooleanos                                           # boolQuery
    ;

valoresBooleanos
    : TRUE
    | FALSE
    ;

relacoesEntreExpressoes
    : expr (EQ | NEQ | GT | LT | GTE | LTE) expr
    ;

queryEntreParenteses
    : LPAREN query RPAREN
    ;
