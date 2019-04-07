import re

#For the reserved words table below, I didn't find the words for c-- so I used words for C.
ResTable = [
    'auto', 'break', 'case', 'char', 'const', 'continue', 'default',
    'do', 'int', 'long', 'register', 'return', 'short', 'signed',
    'sizeof', 'static', 'struct', 'switch', 'typedef', 'union',
    'unsigned', 'void', 'volatile', 'while', 'double', 'else', 'enum',
    'extern', 'float', 'for', 'goto', 'if', 'end'
]

#Table reserved for user defined variables
UsrTable = []

#This function is for spliting the input into tokens
def TokenSplit(input):
    tmp = input.lower()
    i = 0
    #  The following loop is to delete the commets from the input
    #  Comments in C-- is /* and */ Refer to the C-- Manual:
    #  https://www.microsoft.com/en-us/research/wp-content/uploads/1998/01/pal-manual.pdf
    while i < len(tmp):
        a = 0
        b = len(tmp)
        if i + 1 < len(tmp) and tmp[i] == '/' and tmp[i + 1] == '*':
            a = i
            i = i + 2
            while i < len(tmp):
                if i + 1 < len(tmp) and tmp[i] == '*' and tmp[i + 1] == '/':
                    b = i + 2
                    break
                i = i + 1
            i = a
            tmp = tmp[:a] + tmp[b:]
        i = i + 1
    i = 0
    # The following loop is for adding additional spaces to the strings
    # These spaces will help when we use the re.split
    # For example, the function can split 'a = b + c ;' correctly,
    # But can't split 'a=b+c'
    while i < len(tmp):
        if re.match('[^.A-Za-z0-9_\s]', tmp[i]):
            tmp = tmp[:i] + ' ' + tmp[i:]
            i = i + 1
            if i + 1 < len(tmp) and tmp[i] == '=' and tmp[i + 1] == '=':
                i = i + 1
            elif i + 1 < len(tmp) and tmp[i] == '>' and tmp[i + 1] == '=':
                i = i + 1
            elif i + 1 < len(tmp) and tmp[i] == '<' and tmp[i + 1] == '=':
                i = i + 1
            elif i + 1 < len(tmp) and tmp[i] == '!' and tmp[i + 1] == '=':
                i = i + 1
            elif i + 1 < len(tmp) and tmp[i] == '>' and tmp[i + 1] == '>':
                i = i + 1
            elif i + 1 < len(tmp) and tmp[i] == '<' and tmp[i + 1] == '<':
                i = i + 1
            if i <= len(tmp):
                tmp = tmp[:i + 1] + ' ' + tmp[i + 1:]
            i = i + 1
        i = i + 1
    # Split the input into tokens here
    # extra operations on the list are to delete the empty elements at the front & the end.
    ret = list(re.split('\s+', tmp))
    if ret[0] == '':
        del (ret[0])
    del (ret[len(ret) - 1])
    return ret

#This function is for checking the type of each token.
def TypeCheck(input):
    ret = []
    for x in input:
        #Check for Symbols
        if x == ';':
            ret.append([x,'SEMICOLON'])
        elif x == '+':
            ret.append([x,'ADD_OP'])
        elif x == '-':
            ret.append([x,'SUBTRACT_OP'])
        elif x == '*':
            ret.append([x,'MULTIPLY_OP'])
        elif x == '/':
            ret.append([x,'DIVIDE_OP'])
        elif x == 'and':
            ret.append([x,'AND_OP'])
        elif x == 'or':
            ret.append([x,'OR_OP'])
        elif x == '!':
            ret.append([x,'NOT_OP'])
        elif x == '%':
            ret.append([x,'MOD_OP'])
        elif x == '=':
            ret.append([x,'ASSIGN_OP'])
        elif x == '==':
            ret.append([x,'EQUAL_OP'])
        elif x == '!=':
            ret.append([x,'NOTEQUAL_OP'])
        elif x == '>':
            ret.append([x,'BIGGER_OP'])
        elif x == '<':
            ret.append([x,'SMALLER_OP'])
        elif x == '>=':
            ret.append([x,'B&E_OP'])
        elif x == '<=':
            ret.append([x,'S&E_OP'])
        elif x == '>>':
            ret.append([x,'RSHIFT_OP'])
        elif x == '<<':
            ret.append([x,'LSHIFT_OP'])
        elif x == '{':
            ret.append([x,'LBRACE'])
        elif x == '}':
            ret.append([x,'RBRACE'])
        elif x == '(':
            ret.append([x,'LPARENTHESIS'])
        elif x == ')':
            ret.append([x,'RPARENTHESIS'])
        #Check For numbers
        elif x.isdigit():
            if x.isdecimal():
                ret.append([x, 'DIGIT_INT'])
            else:
                ret.append([x, 'DIGIT_FLOAT'])
        #Check for Reserved Words
        else:
            find=False
            for word in ResTable:
                if x==word:
                    ret.append([x,'RESERVE_'+word.upper()])
                    find = True
            for word in UsrTable:
                if x==word:
                    ret.append([x,'USR_'+word.upper()])
                    find = True
            if find ==False:
                ret.append([x, 'VAR_CODE'])
    return ret

# This function is the Error Check function for checking the syntax error.
# For now I only checked for
# 1.Parenthesis
# 2.Brace
# Adding other checks later.
def ErrorCheck(TokenTable):
    p = 0
    for i in TokenTable:
        if i[1]=='LPARENTHESIS':
            p=p+1
        if i[1]=='RPARENTHESIS':
            p=p-1
        if p<0:
            break
    if not p==0:
        print('Syntax Error: Parenthesis error')
    d = 0
    for i in TokenTable:
        if i[1]=='LBRACE':
            d = d + 1
        if i[1]=='RBRACE':
            d = d - 1
        if d < 0:
            break
    if not d==0:
        print('Syntax Error: Brace error')





#This function is the main program for the analyzer.
def LexicalAnalyzer(input):
    Token = TokenSplit(input)
    TokenTable = TypeCheck(Token)
    for x in TokenTable:
        print(x)
    ErrorCheck(TokenTable)




#Folloing is the test program
a='''
{
Int x ;
Int y ;
Int z ;
X = 10 ;
Y = 20 ;
print (x);
print (x+y);
read(z)
z = z + x + y;
print (z);
}
{
if 5 > 1:
{
if (4>3) and (2 <5) :
{
print 1;
print 2;
}
 else:
{
print 3;
print (3+1)
}
end if;
}
end if;
}'''
LexicalAnalyzer(a)