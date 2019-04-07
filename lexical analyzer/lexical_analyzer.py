import re


def tokenSplit(input):
    tmp = input
    i = 0
    while i < len(tmp):
        if re.match('[^A-Za-z0-9_\s]', tmp[i]):
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
    print(tmp)
    ret = list(re.split('\s+', tmp))
    del(ret[len(ret)-1])
    return ret


a = 'a == b+ (c<<d);'
s = tokenSplit(a)
print(s)
