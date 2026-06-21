from antlr4 import *

class PythonParserVisitor(ParseTreeVisitor):
    def visitCode(self, ctx): return self.visitChildren(ctx)
    def visitStat(self, ctx): return self.visitChildren(ctx)
    def visitAtribuicao(self, ctx): return self.visitChildren(ctx)
    def visitExpr(self, ctx): return self.visitChildren(ctx)