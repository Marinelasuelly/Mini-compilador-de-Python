import sys

# Truque de emergência fornecido na base do projeto
try:
    from antlr4 import *
except ModuleNotFoundError:
    class ParserRuleContext: pass
    class ParseTreeVisitor:
        def visit(self, ctx):
            if ctx is None: return None
            return ctx.accept(self)
        def visitChildren(self, ctx): return None
    sys.modules['antlr4'] = sys.modules[__name__]
    ParserRuleContext = ParserRuleContext
    ParseTreeVisitor = ParseTreeVisitor

if "." in __name__:
    from .PythonParser import PythonParser
    from .PythonParserVisitor import PythonParserVisitor
else:
    from PythonParser import PythonParser
    from PythonParserVisitor import PythonParserVisitor

# Exceção customizada para controlo de fluxo do return (Fase 10.8)
class ReturnException(Exception):
    def __init__(self, value):
        self.value = value

class Compiler(PythonParserVisitor):

    def __init__(self):
        super().__init__()
        # Espaço de memória para variáveis e funções locais/globais
        self.vars = {}

    # =========================================================================
    # REGRAS PRINCIPAIS E DECLARAÇÕES (STATEMENTS)
    # =========================================================================

    def visitCode(self, ctx: PythonParser.CodeContext):
        # Visita sequencialmente todos os filhos do ponto de entrada
        return self.visitChildren(ctx)

    def visitStat(self, ctx: PythonParser.StatContext):
        # Visita a instrução interna (atribuicao, expr, condicional, etc)
        return self.visitChildren(ctx)

    # =========================================================================
    # FASE 10.3 - ATRIBUIÇÃO DE VARIÁVEIS
    # =========================================================================
    def visitAtribuicao(self, ctx: PythonParser.AtribuicaoContext):
        name = ctx.ID().getText()
        value = self.visit(ctx.expr())
        self.vars[name] = value
        return value

    # =========================================================================
    # FASE 10.2 - AVALIAÇÃO DE EXPRESSÕES
    # =========================================================================

    def visitParenExpr(self, ctx: PythonParser.ParenExprContext):
        return self.visit(ctx.expressoesEntreParenteses().expr())

    def visitIdExpr(self, ctx: PythonParser.IdExprContext):
        var_name = ctx.ids().ID().getText()
        if var_name in self.vars:
            return self.vars[var_name]
        raise NameError(f"Variável '{var_name}' não foi definida.")

    def visitNumExpr(self, ctx: PythonParser.NumExprContext):
        text = ctx.numeros().getText()
        if '.' in text:
            return float(text)
        return int(text)

    def visitStringExpr(self, ctx: PythonParser.StringExprContext):
        # Remove as aspas delimitadoras (' ou ")
        return ctx.STRING().getText()[1:-1]

    # Operações Matemáticas com precedência correta definida pelo Parser
    def visitPowExpr(self, ctx: PythonParser.PowExprContext):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        return left ** right

    def visitMulDivExpr(self, ctx: PythonParser.MulDivExprContext):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        op = ctx.getChild(1).getText()
        
        if op == '*': return left * right
        if op == '/': return left / right
        if op == '//': return left // right
        if op == '%': return left % right
        return 0

    def visitAddSubExpr(self, ctx: PythonParser.AddSubExprContext):
        left = self.visit(ctx.expr(0))
        right = self.visit(ctx.expr(1))
        op = ctx.getChild(1).getText()
        
        if op == '+': return left + right
        if op == '-': return left - right
        return 0

    # Coleções (Fase 8 integrando na Fase 10)
    def visitListExpr(self, ctx: PythonParser.ListExprContext):
        return [self.visit(e) for e in ctx.lista().expr()]

    def visitTupleExpr(self, ctx: PythonParser.TupleExprContext):
        return tuple(self.visit(e) for e in ctx.tupla().expr())

    def visitSetExpr(self, ctx: PythonParser.SetExprContext):
        return {self.visit(e) for e in ctx.conjunto().expr()}

    def visitDictExpr(self, ctx: PythonParser.DictExprContext):
        res = {}
        for par in ctx.dicionario().par_chave_valor():
            key = self.visit(par.expr(0))
            val = self.visit(par.expr(1))
            res[key] = val
        return res

    def visitFuncCallExpr(self, ctx: PythonParser.FuncCallExprContext):
        return self.visit(ctx.func_call())

    # =========================================================================
    # EXPRESSÕES LÓGICAS / QUERIES
    # =========================================================================

    def visitParenQuery(self, ctx: PythonParser.ParenQueryContext):
        return self.visit(ctx.queryEntreParenteses().query())

    def visitBoolQuery(self, ctx: PythonParser.BoolQueryContext):
        return ctx.valoresBooleanos().getText() == 'True'

    def visitNotQuery(self, ctx: PythonParser.NotQueryContext):
        return not self.visit(ctx.query())

    def visitAndQuery(self, ctx: PythonParser.AndQueryContext):
        return self.visit(ctx.query(0)) and self.visit(ctx.query(1))

    def visitOrQuery(self, ctx: PythonParser.OrQueryContext):
        return self.visit(ctx.query(0)) or self.visit(ctx.query(1))

    def visitRelQuery(self, ctx: PythonParser.RelQueryContext):
        rel = ctx.relacoesEntreExpressoes()
        left = self.visit(rel.expr(0))
        right = self.visit(rel.expr(1))
        op = rel.getChild(1).getText()

        if op == '==': return left == right
        if op == '!=': return left != right
        if op == '>':  return left > right
        if op == '<':  return left < right
        if op == '>=': return left >= right
        if op == '<=': return left <= right
        return False

    # =========================================================================
    # FASE 5 & 10.5 - ESTRUTURAS CONDICIONAIS
    # =========================================================================
    def visitCondicional(self, ctx: PythonParser.CondicionalContext):
        # 1. Avalia a condição do IF
        if self.visit(ctx.query()):
            for stat in ctx.stat():
                self.visit(stat)
            return

        # 2. Avalia os ELIFs (se existirem)
        if ctx.condicionalElif():
            for elif_ctx in ctx.condicionalElif():
                # Cada elif_ctx tem a sua própria query e bloco stat+
                if self.visit(elif_ctx.query()):
                    for stat in elif_ctx.stat():
                        self.visit(stat)
                    return

        # 3. Avalia o ELSE (se existir)
        if ctx.condicionalElse():
            for stat in ctx.condicionalElse().stat():
                self.visit(stat)

    # =========================================================================
    # FASE 6, 10.4 & 10.8 - DEFINIÇÃO E EXECUÇÃO DE FUNÇÕES
    # =========================================================================
    def visitFunc(self, ctx: PythonParser.FuncContext):
        func_name = ctx.ID().getText()
        # Armazena o contexto completo da árvore para execução tardia
        self.vars[func_name] = ctx
        return None

    def visitReturn_stmt(self, ctx: PythonParser.Return_stmtContext):
        value = self.visit(ctx.expr())
        # Lança a exceção para interromper o fluxo do bloco de comandos
        raise ReturnException(value)

    # FASE 10.9 - TRATAMENTO DE CHAMADAS E BUILT-INS (print, range, etc.)
    def visitFunc_call(self, ctx: PythonParser.Func_callContext):
        func_name = ctx.ID().getText()
        
        # Resolve argumentos
        args_eval = []
        if ctx.argumentos():
            args_eval = [self.visit(arg) for arg in ctx.argumentos().expr()]

        # Caso 1: Função definida pelo utilizador na memória
        if func_name in self.vars and isinstance(self.vars[func_name], PythonParser.FuncContext):
            func_ctx = self.vars[func_name]
            
            # Guardar escopo atual para simular escopo local limpo
            old_vars = self.vars.copy()
            
            # Mapear parâmetros para os argumentos passados
            if func_ctx.parametros():
                param_list = [p.getText() for p in func_ctx.parametros().ID()]
                for param, arg_val in zip(param_list, args_eval):
                    self.vars[param] = arg_val

            # Executar o bloco da função capturando o ReturnException
            return_val = None
            try:
                for stat in func_ctx.stat():
                    self.visit(stat)
            except ReturnException as e:
                return_val = e.value
            finally:
                # Restaurar o escopo global protetor
                self.vars = old_vars
                
            return return_val

        # Caso 2: Verificar se é um Built-in nativo do Python (print, range, len...)
        import builtins
        builtin_func = getattr(builtins, func_name, None)
        if builtin_func and callable(builtin_func):
            return builtin_func(*args_eval)

        raise NameError(f"Função '{func_name}' não está definida.")

    # =========================================================================
    # FASE 10.6 & 10.7 - LOOPS (WHILE / FOR)
    # =========================================================================
    def visitLoop_while(self, ctx: PythonParser.Loop_whileContext):
        while self.visit(ctx.query()):
            for stat in ctx.stat():
                self.visit(stat)
        return None

    def visitLoop_for(self, ctx: PythonParser.Loop_forContext):
        var_name = ctx.ID().getText()
        iterable = self.visit(ctx.expr())
        
        for item in iterable:
            self.vars[var_name] = item
            for stat in ctx.stat():
                self.visit(stat)
        return None