import sys
from antlr4 import *

class PythonParser(Parser):
    def __init__(self, input, output=sys.stdout):
        super().__init__(input, output)
    def code(self):
        return self.CodeContext(self, self._ctx, self.state)
    class CodeContext(ParserRuleContext):
        def __init__(self, parser, parent=None, invokingState=-1):
            super().__init__(parent, invokingState)
        def accept(self, visitor):
            return visitor.visitCode(self) if hasattr(visitor, "visitCode") else visitor.visitChildren(self)