# How to compile

You will need the flex/bison tool set to compile this code.  If you don't have either, please run the below on the terminal:

```
sudo apt-get update
sudo apt-get install flex bison
```

Then you can simply do make:

```
make
```

Which should result in:

```
$ make
flex lex.l 
yacc -d -v grammar.y
grammar.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]
gcc -c y.tab.c 
gcc -o parser y.tab.o -ll
```

# How to run

You can stream in whatever input you want to get parsed into stdin, as follows:

```
echo "hello world" | ./parser
```

Which should result in:

```
$ echo "hello world" | ./parser
Sentence -> STRING_TOKEN (hello)
Sentence -> STRING_TOKEN (world)

Sentence -> Sentence SPACE_TOKEN Sentence
```

# How to resolve the shift-reduce conflict

When you run YACC on your grammar as part of 'make' you get a shift-reduce conflict:

```
yacc -d -v grammar.y
grammar.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]
```

Passing the '-v' option enables the generation of the y.output conflict report file.

Towards the beginning of the y.output file, you will see the following line:

```
State 5 conflicts: 1 shift/reduce
```

That tells you which state had the conflict.  This is State 5 in y.output:

```
State 5

    2 Sentence: Sentence . SPACE_TOKEN Sentence
    2         | Sentence SPACE_TOKEN Sentence .

    SPACE_TOKEN  shift, and go to state 4

    SPACE_TOKEN  [reduce using rule 2 (Sentence)]
    $default     reduce using rule 2 (Sentence)
```

You can plainly see that there are two actions on a lookahead of the SPACE_TOKEN: to shift the SPACE_TOKEN or to reduce using rule 2.  Now you will have to do some thinking in what situation that conflict would occur.  It is when you already consumed "Sentence SPACE_TOKEN Sentence" and you see a SPACE_TOKEN, upon which you don't know whether to shift or reduce.  In short, the culprit string is:

```
Sentence SPACE_TOKEN Sentence SPACE_TOKEN Sentence
```

And you don't know whether to reduce the first two sentences or keep shifting the SPACE_TOKEN in order to reduce the last two sentences first.  You can tell that this is an associativity problem.  So how would you solve it?  You could modify the grammar so that it is left-associative, for example.  Another option is to specify left-associativity on the SPACE_TOKEN terminal by adding the following directive below the token declarations:

```
%left SPACE_TOKEN
```

After saving grammar.y, if you recompile, you will no longer get a conflict:

```
$ make
yacc -d -v grammar.y
gcc -c y.tab.c 
gcc -o parser y.tab.o -ll
```