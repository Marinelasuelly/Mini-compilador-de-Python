import sys
import json
from antlr4 import FileStream, CommonTokenStream
from PythonLexer import PythonLexer as Lexer
from PythonParser import PythonParser as Parser
from compiler_def import Compiler

def main(argv):
    # Read script file
   # Read script file
    input_stream = FileStream(argv[1], encoding='utf-8')

    # Pass script file to lexer
    lexer = Lexer(input_stream)

    # Identify tokens
    stream = CommonTokenStream(lexer)

    # Pass script file stream to parser
    parser = Parser(stream)

    # Structure script file commands
    tree = parser.code()

    # Check for syntax errors
    if parser.getNumberOfSyntaxErrors() > 0:
        print("syntax errors")
        vars = {}

    # Compile script file
    else:
        # Instancing compiler
        compiler = Compiler()

        # Visiting script file via sintax tree
        compiler.visit(tree)

        # Get variables identifyers
        vars = compiler.vars

    return vars

if __name__ == '__main__':
    vars = main(sys.argv)
    print('Source code vars: ', json.dumps(vars, indent=4, separators=(',', ' = ')))
