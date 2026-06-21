import sys
from antlr4 import *

class PythonLexer(Lexer):
    def __init__(self, input=None, output=sys.stdout):
        super().__init__(input, output)