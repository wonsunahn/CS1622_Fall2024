# Syllabus - Fall 2024
CS1622 Compiler Design

## WEEK 1 (Week of 26 AUG)

* READINGS: Textbook, Chapters 1.1-1.5, 3.1-3.5

* TOPICS:
  * Course Introduction
    * Why learn Compilers?
    * What is a Compiler?
    * Front End / Back End of a Compiler
    * Challenges facing Compilers
  * Lexical Analysis 
    * Tokens
    * Regular Languages
    * Regular Expressions
    * Lex Tool
  

## WEEK 2 (Week of 2 SEP)

* READINGS: Textbook, Chapters 3.6-3.8, 3.9.6-3.9.7

* TOPICS:
  * Lexical Analysis cont'd 
    * Deterministic Finite Automata
    * Nondeterministic Finite Automata
    * Regular Expression to NFA 
    * NFA to DFA
    * DFA Minimization
    * DFA to table-driven implementation

* ASSIGNMENTS RELEASED:
  * Project 1 (Tuesday)
  * Homework 1 (Thursday)

## WEEK 3 (Week of 9 SEP)

* READINGS: Textbook, Chapters 4.1-4.2

* TOPICS:
  * Syntax Analysis 
    * Grammars
      * Noam Chomsky Classification
    * Languages
    * Context Free Grammars
      * Parse Trees
      * Leftmost / Rightmost Derivations
      * Ambiguity
      * Associativity / Precedence
      * Abstract Syntax Tree

## WEEK 4 (Week of 16 SEP)

* READINGS: Textbook, Chapters 4.3-4.5

* TOPICS:
  * Top-down Parser 
    * Recursive descent using backtracking
      * Removing left-recurion
    * Predictive
      * Left factoring
      * LL(k) parser / grammar / language
      * Recursive
      * Nonrecursive (table driven)
      * Look ahead
    * Parse Table Construction
      * First Set
      * Follow Set
      * Dealing with conflicts

* ASSIGNMENTS DUE:
  * Homework 1 (Thursday)

## WEEK 5 (Week of 23 SEP)

* READINGS: Textbook, Chapters 4.5-4.6

* TOPICS:
  * Bottom-up Parser
    * Handles
    * Shift-reduce parsing
    * Conflicts and ambiguity
  * LR Parsing
    * Viable Prefix
    * LR(0) items
    * Action and Goto Tables
  * Parse Table Construction
    * DFA Construction
      * Closure function
      * Goto function
    * Building Action and Goto Tables from DFA

* ASSIGNMENTS DUE:
  * Project 1 (Thursday)

* ASSIGNMENTS RELEASED:
  * Homework 2 (Thursday)

## WEEK 6 (Week of 30 SEP)

* READINGS: Textbook, Chapters 4.7-4.9

* TOPICS:
  * More powerful LR Parsers
    * Look ahead
    * SLR(k)
    * LR(k)
      * State splitting
    * LALR(k)
      * State merging
    * Comparison between different parsers
  * YACC Tool
    * Shift-reduce conflicts
    * Reduce-reduce conflicts
    * Semantic Actions
    * Error Recovery
    * LR Table Compaction

* ASSIGNMENTS RELEASED:
  * Homework 3 (Thursday)
  * Project 2 (Thursday)

## WEEK 7 (Week of 7 OCT)

* READINGS: Textbook, Chapters 2.7, 6.4.3, 6.5-6.5.2

* TOPICS:
  * Semantic Analysis
    * Static scope / Dynamic scope
    * Symbol Table
    * Semantic of Arrays
    * Type Checking

* ASSIGNMENTS DUE:
  * Homework 2 (Thursday)

## WEEK 8 (Week of 14 OCT)

* Tuesday: NO CLASS (Fall Break)

* READINGS: Textbook, Chapters 5.1-5.2.4, 5.5

* TOPICS:
  * Syntax Directed Translation
    * Attribute Grammar
    * Synthesized Attribute / Inherited Attribute
    * Syntax Directed Definition
    * Syntax Directed Translation Scheme
    * Left-attributed Grammar
    * Syntax Directed Translation Scheme Implementation
      * Bottom-up Parsing
      * Top-down Parsing

* ASSIGNMENTS DUE:
  * Homework 3 (Thursday)

* ASSIGNMENTS RELEASED:
  * Project 3 (Thursday)

## WEEK 9 (Week of 21 OCT)

* Tuesday: Midterm 1 Review

* Thursday: Midterm 1 on GradeScope
  * Steps:
    1. Do TopHat attendance at start of class.  If no attendance, grade will not be counted.
    2. Click on assignment "Midterm 1" on GradeScope (will appear at start of class).
    3. Click on the "Start Assignment" button.  There will be a count down timer on the top right once you start.
    4. Finish and submit the exam within 75 minutes.  You can submit multiple times.
  * Optionally, you can try the "Sample GradeScope Exam (For Practice)" to get used to the mechanics.
  * Exam is open book (Lecture slides, notes, textbook, homeworks and projects, use of JFLAP, Lex, or Yacc are permitted).
  * Exam is individual work (use of generative AI is banned).

* Thursday: Midterm 1 Exam

## WEEK 10 (Week of 28 OCT)

* READINGS: Textbook, Chapters 6 intro, 6.2, 6.3.4-6.3.6, 6.4

* TOPICS:
  * Code Generation
    * Multi-level IRs / frontends / backends
    * Low-level IRSs
      * Three Address Code and its representation
      * SSA
    * Storage layout
      * Offset
      * Endianness
    * Code Generation Through Syntax Directed Translation
      * Processing Declarations
      * Processing Statements
      * Processing Array references

## WEEK 11 (Week of 4 NOV)

* Tuesday: Remote Class on Zoom (Election Day)

* READINGS: Textbook, Chapters 1.6.6, 6.6-6.7, 7 intro, 7.1-7.3, 12.2.6

* TOPICS:
  * Code Generation Through Syntax Directed Translation (cont’d)
    * Processing Boolean Expressions
      * Short-Circuiting and non-L attributes
    * Handling non-L attributes
      * Two-pass based approach
      * One-pass base approach using backpatching
    * Runtime Management
      * Concept of runtime environment / runtime code
      * Static / stack / heap data management
      * Stack data management
        * Advantages / Disadvantages compared to static management
        * Activation records (ARs)
        * Frame pointer / stack pointer
        * Calling convention and AR layout
    * Runtime Code Generation
      * Code for global / local / non-local variable access
        * Nested procedure declarations
      * Code of function calls and calling conventions
        * Call by value, by reference, by name
      * Buffer Overflow Attack
      * Classes / Objects
        * Member variables / member methods
        * Virtual methods / non-virtual methods
        * Dynamic dispatch / static dispatch

* ASSIGNMENTS DUE:
  * Project 2 (Thursday)

* ASSIGNMENTS RELEASED:
  * Project 4 (Thursday)

## WEEK 12 (Week of 11 NOV)

* READINGS: Textbook, Chapters 7.4-7.7

* TOPICS:
  * Garbage Collection
    * Motivation
    * Reachability and garbage
    * Two GC schemes
      * Reference Counting
      * Tracing
    * Reference Counting
      * Circular data structures
      * Advantages / Disadvantages
    * Tracing
      * Root objects
      * Advantages / Disadvantages
    * Comparison of different Tracing GC
      * Mark-Sweep
      * Semispace
      * Incremental
      * Generational

* ASSIGNMENTS DUE:
  * Project 3 (Thursday)

## WEEK 13 (Week of 18 NOV)

READINGS: Textbook, Chapters 7.4.2.-7.4.4, 8.4, 8.5.4, 9.2.1-9.2.3, 9.2.5, 9.3, 9.4

TOPICS:
  * Code Optimization
    * Data-related optimization
      * Data layout, code layout
    * Code-related optimization
      * Different categories
    * Local optimization
      * Strength reduction
      * Constant folding
    * Global optimization
  * Control flow analysis
    * Basic block
    * Control flow graph
    * Conservatism due to control flow
  * Data flow analysis
    * Data flow framework components
      * Direction
        * Forward analysis
        * Backward analysis
      * Set of values
      * Meet operator
	* Semilattice
        * Top value / bottom value
      * Transfer function
    * Data flow framework implementation
      * Iterative refinement of values
      * Termination guarantee
    * Global Constant Propagation
    * Global Liveness Analysis

## WEEK 14 (Week of 25 NOV)

* NO CLASS (Thanksgiving Break)

## WEEK 15 (Week of 2 DEC)

* READINGS: Textbook, Chapters 8.6, 8.8, 8.9.1-8.9.2

* TOPICS:
  * Register Allocation
    * Local register allocation
      * Register spilling
    * Global register allocation
      * Graph coloring
        * Live ranges
        * Register interference graph
        * Chaitin’s algorithm
          * Optimality
          * Spilling and retry
        * Linear scan
          * Live intervals
          * Linear code layout
        * ILP
  * Instruction selection
    * Importance of CISC
    * Tree tiling

## WEEK 16 (Week of 9 DEC)

* Tuesday: Midterm 2 Exam

* ASSIGNMENTS DUE:
  * Project 4 (Friday)

