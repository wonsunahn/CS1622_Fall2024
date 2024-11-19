#ifndef PROJ2_H_
#define PROJ2_H_

/* Define syntax tree node and pointer type tree. */
typedef struct treenode {
        int NodeKind, NodeOpType, IntVal, LineNo;
        struct treenode *LeftC, *RightC;
} ILTree, *tree;

#define ProgramOp       100
#define BodyOp          101
#define DeclOp          102
#define CommaOp         103
#define ArrayTypeOp     104
#define TypeIdOp        105
#define BoundOp         106
#define RecompOp        107
#define ToOp            108
#define DownToOp        109
#define ConstantIdOp    110
#define ProceOp         111
#define FuncOp          112
#define HeadOp          113
#define RArgTypeOp      114
#define VArgTypeOp      115
#define StmtOp          116
#define IfElseOp        117
#define LoopOp          118
#define SpecOp          119
#define RoutineCallOp   120
#define AssignOp        121
#define ReturnOp        122
#define AddOp           123
#define SubOp           124
#define MultOp          125
#define DivOp           126
#define LTOp            127
#define GTOp            128
#define EQOp            129
#define NEOp            130
#define LEOp            131
#define GEOp            132
#define AndOp           133
#define OrOp            134
#define UnaryNegOp      135
#define NotOp           136
#define VarOp           137
#define SelectOp        138
#define IndexOp         139
#define FieldOp         140
#define SubrangeOp      141
#define ExitOp          142
#define ClassOp         143
#define MethodOp        144
#define ClassDefOp      145

#define IDNode          200 
#define NUMNode         201
#define CHARNode        202
#define STRINGNode      203
#define DUMMYNode       204
#define EXPRNode        205
#define INTEGERTNode	206
#define CHARTNode	207
#define BOOLEANTNode	208
#define STNode		209

tree NullExp();
tree MakeLeaf(int, int);
tree MakeTree(int, tree, tree);
tree LeftChild(tree);
tree RightChild(tree);
tree MkLeftC(tree, tree);
tree MkRightC(tree, tree);

int NodeOp(tree T);
int NodeKind(tree T);
int IntVal(tree T);
int IsNull(tree T);
const char* getNodeOpString(tree nd);

void SetNode(tree, tree);
void SetNodeOp(tree, int);
void SetLeftTreeOp(tree, int);
void SetRightTreeOp(tree, int);
void SetLeftChild(tree, tree);
void SetRightChild(tree, tree);

void printtree(tree nd, int depth);

#endif /* #ifndef PROJ2_H_ */