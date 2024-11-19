- [Project 3: Semantic Analysis](#project-3--semantic-analysis)
  * [Description](#description)
  * [Codespace Development Environment](#codespace-development-environment)
  * [Directory Structure and Makefile Script](#directory-structure-and-makefile-script)
  * [Implementation](#implementation)
    + [Updating lex.l, grammar.y, and table.cpp](#updating-lexl-grammary-and-tablecpp)
    + [Completing proj3.cpp and table.cpp](#completing-proj3cpp-and-tablecpp)
    + [Completing semantic.cpp](#completing-semanticcpp)
  * [Appendix](#appendix)
    + [Appendix A: Attributes in the symbol table](#appendix-a-attributes-in-the-symbol-table)
    + [Appendix B: Doxygen documentation generation](#appendix-b-doxygen-documentation-generation)
    + [Appendix C: Debugging](#appendix-c-debugging)
    + [Appendix D: Extra Credit](#appendix-d-extra-credit)
    + [Appendix E: Obtaining the solution for Project 2](#appendix-e-obtaining-the-solution-for-project-2)
  * [Grading](#grading)
  * [Submission](#submission)

# Project 3: Semantic Analysis

DUE: December 13 (Friday), 2024 11:59 PM

Please accept Project 4 on **GitHub Classroom** using the following link: TBD

## Description

In this phase of the project, you will write a code generator for the CS 1622
programming language, MINI-JAVA. The code generator works by traversing the
symbol table, and for each symbol, generating the code for that symbol.  You
will generate the code based on all the information in the symbol table that
you gathered through semantic analysis.  If the symbol is a class, you will
generate code for the definition of a class object.  If the symbol is a
function, you will generate code for a function.  If the symbol is a local
variable or function parameter, you will generate code to allocate the variable
on the function stack.

The code that you generate will be in LLVM IR (Intermediate Representation)
instead of assembly language for a specific machine ISA.  The IR is the
instruction set for LLVM (Low Level Virtual Machine) which is later converted
to the machine code for your target machine, whether it be x86 or ARM.

## Codespace Development Environment

We will use the same exact development environment as Project 3.  Just like
before, please install Flex/Bison:

```
sudo apt-get update
sudo apt-get install -y flex
```

And the VSCode C++ Extensions Pack:

https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack

In addition to that, we need to set up the Clang/LLVM development environment
as we are going to leverage Clang/LLVM to build our compiler.  First, let's
start by installing the Clang/LLVM build tools:

```
sudo apt-get install -y clang-10 lldb-10 lld-10 clangd-10 clang-tidy-10 clang-format-10 clang-tools-10 llvm-10-dev llvm-10-tools libomp-10-dev libc++-10-dev libc++abi-10-dev libclang-common-10-dev libclang-10-dev libclang-cpp10-dev
```

Then, let's install the VSCode CodeLLDB extension to enable VSCode debugging using LLDB (which is the GDB counterpart for Clang/LLVM):

https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb

Now we are all set!  You should be able to build the codegen binary by invoking
the build target of the Makefile script on the terminal:

```
make build
```

This results in the following output:

```
$ make build
flex lex.l
yacc -d -v grammar.y
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c table.cpp -o table.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c codegen.cpp -o codegen.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c proj2.cpp -o proj2.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c proj3.cpp -o proj3.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c main.cpp -o main.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c semantic.cpp -o semantic.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags` -c llvm/LLVMGlobals.cpp -o llvm/LLVMGlobals.o
clang-10 -g -I . `llvm-config-10 --cflags` -c y.tab.c -o y.tab.o
clang++-10 -stdlib=libc++ -g -I . `llvm-config-10 --cxxflags --ldflags --system-libs --libs all` -o codegen ./table.o ./codegen.o ./proj2.o ./proj3.o ./main.o ./semantic.o ./llvm/LLVMGlobals.o y.tab.o -lfl
```

Try also building the LLVM code examples.  We will talk about these later:

```
$ make examples
examples_outputs/structs.exe > examples_outputs/structs.codegen.ll
clang -Wno-override-module -S -c examples_outputs/structs.codegen.ll -o examples_outputs/structs.codegen.s
clang examples_outputs/structs.codegen.s -o examples_outputs/structs.codegen.exe
examples_outputs/structs.codegen.exe > examples_outputs/structs.codegen.out
examples_outputs/fib.exe > examples_outputs/fib.codegen.ll
clang -Wno-override-module -S -c examples_outputs/fib.codegen.ll -o examples_outputs/fib.codegen.s
clang examples_outputs/fib.codegen.s -o examples_outputs/fib.codegen.exe
examples_outputs/fib.codegen.exe > examples_outputs/fib.codegen.out
examples_outputs/array-1d.exe > examples_outputs/array-1d.codegen.ll
clang -Wno-override-module -S -c examples_outputs/array-1d.codegen.ll -o examples_outputs/array-1d.codegen.s
clang examples_outputs/array-1d.codegen.s -o examples_outputs/array-1d.codegen.exe
examples_outputs/array-1d.codegen.exe > examples_outputs/array-1d.codegen.out
examples_outputs/array-2d.exe > examples_outputs/array-2d.codegen.ll
clang -Wno-override-module -S -c examples_outputs/array-2d.codegen.ll -o examples_outputs/array-2d.codegen.s
clang examples_outputs/array-2d.codegen.s -o examples_outputs/array-2d.codegen.exe
examples_outputs/array-2d.codegen.exe > examples_outputs/array-2d.codegen.out
examples_outputs/helloworld.exe > examples_outputs/helloworld.codegen.ll
clang -Wno-override-module -S -c examples_outputs/helloworld.codegen.ll -o examples_outputs/helloworld.codegen.s
clang examples_outputs/helloworld.codegen.s -o examples_outputs/helloworld.codegen.exe
examples_outputs/helloworld.codegen.exe > examples_outputs/helloworld.codegen.out
```

## Directory Structure and Makefile Script

Here is an overview of the directory structure in alphabetical order.  The files that you are expected to update or modify are marked in bold:

* **codegen.cpp** : Implements the code generation stage of the compiler. **Modify**.
* **grammar.y** : Implements the parser using the Yacc language. **Update**.
* **lex.l** : Implements the lexer using the Lex language.  **Update**.
* main.cpp : The main function for the compiler.  Processes various command line arguments.
* Makefile : The build script for the make tool.
* proj2.cpp / proj2.h : Helper functions for building the parse tree, pre-implemented for you.
* **proj3.cpp** / proj3.h : Helper functions for building and querying the symbol table, (mostly) pre-implemented for you.  **Update**
* **semantic.cpp** : Implements the semantic analysis stage of the compiler.  **Update**.
* **table.cpp** : Implements the string table.  **Update**.
* diffs/ : Directory where comparisons between outputs/ and outputs_solution/ are stored, generated by the <tt>diff</tt> command.
* examples/ : Directory where LLVM code examples are stored.
* examples_outputs/ : Directory where the code generated from the LLVM examples are stored.  As well as the execution outputs of the generated codes.
* outputs/ : Directory where outputs after running your parser on source files under tests/ are stored.
* outputs_solution/ : Directory where solution outputs after running the reference parser on source files under tests/ are stored.
* tests/ : Source files for testing and grading your parser.

The files that are marked **Update** need only updating from the corresponding
file in Project 3.  You can simply overwrite the file with your implementation.
The only file that you need to work on for this project is **codegen.cpp**.

As mentioned above, in order to build the codegen binary, you only need to invoke the build make target:

```
make build
```

To build and run the LLVM examples under the examples/ folder, invoke the examples make target:

```
make examples
```

To build and run everything, including the test source files under tests/ and diffing the generated files under outputs/ with outputs_solution/, invoke the default make target:

```
make
```

The make script generates outputs and diffs in exactly the same way as in
Projects 1~3.  This time, the outputs that are being diffed are the outputs of
the compiled MINI-JAVA source codes after they have executed.  We are not going
to diff the generated LLVM IR code itself, because two compilers can generate
different codes but both can still be correct.

If you wish to remove all files generated from the make script and
start from scratch, invoke the 'clean' target:

```
make clean
```

## Implementation

As mentioned, all your implementation efforts will be focused upon codegen.cpp.

### Updating Project 3 files

After updating the above mentioned grammar.y, lex.l, proj3.cpp, semantic.cpp,
and table.cpp from Project 3, if you do 'make', you will still get lots of
failures because you have not yet generated any code.  However, the
outputs/\*.log files should now contain the symbol tables and parse trees which
are the results of semantic analysis.

For example, outputs/helloworld.log should contain:

```
**************** SYMBOL TABLE ****************

          Name       Kind Nest-Level Predefined       Type     Init-Node     Offset Dimensions  Arguments LLVMObject

  0 helloworld    program          1                                                                                
  1     system      class          2        yes                                                                     
  2    println   function          3        yes                                                         1           
  3 Helloworld      class          2                                                                                
  4       main   function          3                   int        BodyOp                                0           
************* SYNTAX TREE PRINTOUT ***********

  +-[STNode,0,"helloworld"]
R-[ProgramOp]
  |   +-[STNode,3,"Helloworld"]
  | +-[ClassDefOp]
  | | |         +-[DUMMYnode]
  | | |       +-[ReturnOp]
  | | |       | +-[NUMNode,0]
  | | |     +-[StmtOp]
  | | |     | |     +-[DUMMYnode]
  | | |     | |   +-[CommaOp]
  | | |     | |   | +-[STRINGNode,42,"Hello World !!!"]
  | | |     | | +-[RoutineCallOp]
  | | |     | | | |   +-[DUMMYnode]
  | | |     | | | | +-[SelectOp]
  | | |     | | | | | | +-[DUMMYnode]
  | | |     | | | | | +-[FieldOp]
  | | |     | | | | |   +-[STNode,2,"println"]
  | | |     | | | +-[VarOp]
  | | |     | | |   +-[STNode,1,"system"]
  | | |     | +-[StmtOp]
  | | |     |   +-[DUMMYnode]
  | | |   +-[BodyOp]
  | | |   | +-[DUMMYnode]
  | | | +-[MethodOp]
  | | | | |     +-[DUMMYnode]
  | | | | |   +-[TypeIdOp]
  | | | | |   | +-[INTEGERTNode]
  | | | | | +-[SpecOp]
  | | | | | | +-[DUMMYnode]
  | | | | +-[HeadOp]
  | | | |   +-[STNode,4,"main"]
  | | +-[BodyOp]
  | |   +-[DUMMYnode]
  +-[ClassOp]
    +-[DUMMYnode]
```

If you see the above, you are ready to proceed to the next step.

### Understanding LLVM IR

Before getting started on the code generation, you will have to understand LLVM
IR and the APIs to generate that IR.  For that purpose, I have created multiple
examples of LLVM API usage under the examples/ folder.  The .cpp files are LLVM
IR implementations of the .mjava MINI-JAVA source files.  When you do 'make
examples' or just simply 'make', you should see a bunch of files getting
generated under examples_outputs/.  Here is the explanation for each file using
helloworld.mjava as an example.

* examples/helloworld.mjava : MINI-JAVA source code for the program.
* examples/helloworld.cpp : C++ code that uses LLVM APIs to emit LLVM IR so that it mimics helloworld.mjava.
* examples_outputs/helloworld.exe : helloword.mjava code generator compiled from helloworld.cpp.
* examples_outputs/helloworld.codegen.ll : LLVM IR generated by helloword.exe.
* examples_outputs/helloworld.codegen.s : Machine assembly code converted from helloworld.codegen.ll using clang (a tool called llc to be exact).
* examples_outputs/helloworld.codegen.exe : Machine executable assembled and linked from helloworld.codegen.s using clang.
* examples_outputs/helloworld.codegen.out : Output from running the helloworld.codegen.exe program.

The file examples_outputs/helloworld.codegen.out contains, as expected:

```
Hello world !!!
```

The file examples_outputs/helloworld.codegen.ll should contain:

```
; ModuleID = 'helloworld.codegen.ll'
source_filename = "helloworld.codegen.ll"

@0 = private unnamed_addr constant [17 x i8] c"Hello world !!!\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %call = call i32 (...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @0, i32 0, i32 0))
  ret i32 0
}
```

This is the LLVM IR emitted by examples/helloworld.cpp.  As you can see, it is
very human readable!  This makes code generation (and also code optimization)
supremely easy to debug with Clang/LLVM.  If you try reading
examples_outputs/helloworld.codegen.s, the assembly file, the differece is
stark.  Note how function calls like printf are maintained at an abstract level
and not translated to a jump instruction and instructions to transfer function
arguments through CPU registers or the stack.  This is because different ABIs
(Application Binary Interface) for different machine ISAs will translate that
function call to very different instructions, so in the common LLVM IR, we want
to maintain it at a high level, while still enabling optimizations.

It is likely fastest to learn by example, but if you want a reference for LLVM IR, here it is:
https://releases.llvm.org/11.0.0/docs/LangRef.html

For example, if you want to understand what the getelementptr instruction does:
https://releases.llvm.org/11.0.0/docs/LangRef.html#getelementptr-instruction

Here is a rough explanation of what is important to understand.  Any string
preceded by the @ character are identifiers in the program (e.g. @0, @printf,
@main).  You might ask what is @0 --- there is no such identifier in the
program?  In this case, it refers to the string constant "Hello world !!!\n"
which is used as an argument to printf.  Whenever there is an unnamed object
like a string constant that needs a unique label, LLVM will assign a number
like @0 which will keep incrementing to @1, @2, and so forth, for each
identifier.

Any string preceded by a % character are virtual CPU registers (e.g. %call).
Virtual registers are used to hold temporary values for computation just like
real registers.  The only difference is that LLVM has an unlimited number of
virtual registers unlike real CPUs (hence the word 'virtual').  This simplifies
code generation and optimization and keeps the code machine-agnostic.  By
default, virtual registers will start from %0 and keep incrementing to %1, %2,
and so forth as more virtual registers are needed.  Since LLVM IR uses SSA
(Static Single Assignment) representation, each virtual register is assigned to
only once in the program.  Now, virtual registers can also be named using LLVM
API to make the code more readable.  In this case the virtual register %call
was named by the LLVM API that emitted that code.  If two instructions attempt
to use the same virtual register name, LLVM will automatically attach a suffix
such as %call1, $call2, etc.  All these virtual registers will be mapped to
real CPU registers when LLVM IR is converted to machine code.  Some virtual
registers will have to be stored in stack memory if there are not enough CPU
registers, however (called register spilling).

Study examples/helloworld.cpp to understand how LLVM APIs were used to generate
the .ll LLVM IR file.  Do the same for all the other MINI-JAVA example programs
and their corresponding .cpp and .ll files.  Examples of all manners of program
constructs, such as functions, variables, structs, arrays, if-then-else
statements, and while loops shoould all be there.

### Completing codegen.cpp

You are given some skeleton code in the form of the 'void codegen()' function.
The code simply iterates over the symbol table and calls emitSymbol(i) on each
of those symbols.  Your job is to fill in the emitSymbol function to emit the
code for the corresponding symbol.  Note that the syntax tree is not passed in
anywhere.  That is because all the information needed to emit code for the
symbol is already in the symbol table, if you did semantic analysis properly.
In fact, there is no use for the syntax tree any more.  Please practice modular
programming and add helper functions and variables as needed --- otherwise, the
emitSymbol function is going to get too big and unwieldy.

Whenever you emit code for a symbol (in effect, defining the symbol), register
the LLVM object that represents that symbol in the symbol table, using the
OBJECT_ATTR attribute.  This is going to prove useful when you later use the
symbol (for example, reading/writing a variable or calling a function).  You
can use the corresponding LLVM object to emit the code for its use.

For example, take a look at the outputs_solution/helloworld.log file:

```
**************** SYMBOL TABLE ****************

          Name       Kind Nest-Level Predefined       Type     Init-Node     Offset Dimensions  Arguments LLVMObject

  0 helloworld    program          1                                                                                
  1     system      class          2        yes                                                                 null
  2    println   function          3        yes                                                         1     printf
  3 Helloworld      class          2                                                                     Helloworld.global
  4       main   function          3                   int        BodyOp                                0       main
************* SYNTAX TREE PRINTOUT ***********
...
```

Note the LLVMObject column.  The STPrint function in proj3.cpp that prints the
symbol table uses the getName() LLVM API to get the names of the LLVM objects
for printing.  The names may differ depending on how you decide to name the
objects, but you should have object attributes for the corresponding symbols.

## Appendix

### Appendix A: Debugging

You can use the VSCode Debugger just like you did for previous projects.  You
will have to edit the .vscode/launch.json file so that you use the mjava file
that you want as input.  But otherwise, it should work smoothly.

If you want to do commandline debugging, you need to use the **lldb-10**
debugger instead of gdb as now we are using the Clang/LLVM compiler.

If you think you have a memory bug, you can run **valgrind** as such:

```
valgrind <command line>
```

### Appendix B: Extra Credit

TBA

### Appendix C: Obtaining the solution for Project 3

If you were not able to complete Project 3, and you want to move on to Project
3, I will provide a way forward.  Just message me on Teams.  I am going to
provide to you the binary object file y.tab.o that you can just link into your
program.  

## Grading

Each of the 14 tests under the tests/ folder is worth 10 points for a total of
140 points.  A diff failure on the output for one of these .mjava files will
result in a deduction of 10 points.

## Submission

When all tests pass, you are ready to submit.  Please submit your GitHub
Classroom repository to GradeScope at the "Project 4" link.  Once you submit,
GradeScope will run the autograder to grade you and give feedback.  If you get
deductions, fix your code based on the feedback and resubmit.  Repeat until you
don't get deductions.  The tests performed on GradeScope is identical to the
tests under the tests/ folder.

Don't forget that you have to Commit and Push your changes to upload them to
the repository.  Please review this tutorial if you don't remember how:

https://docs.github.com/en/codespaces/developing-in-a-codespace/using-source-control-in-your-codespace#committing-your-changes