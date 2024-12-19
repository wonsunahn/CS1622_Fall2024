CXXSOURCES = $(shell find . -not -path './examples/*' -and -not -path './project_3_solution/*' -and -not -path './table.cpp' -and -not -path './proj3.cpp' -and -not -path './semantic.cpp' -name '*.cpp')
CSOURCES = $(shell find . -not -path './y.tab.c' -and -not -path './lex.yy.c' -name '*.c')
#CSOURCES += y.tab.c
HEADERS = $(shell find . -not -path './y.tab.h' -name '*.h')
HEADERS += y.tab.h
OBJ += $(CXXSOURCES:%.cpp=%.o)
OBJ += $(CSOURCES:%.c=%.o)


TESTS = $(wildcard tests/*.mjava)
OUTPUTS := $(foreach test,$(TESTS),outputs/$(test:tests/%.mjava=%).out)
DIFFS := $(foreach test,$(TESTS),diffs/$(test:tests/%.mjava=%).diff)

EXAMPLES = $(wildcard examples/*.cpp)
EXAMPLE_OUTPUTS = $(foreach example,$(EXAMPLES),examples_outputs/$(example:examples/%.cpp=%).codegen.out)

CXX = clang++-10 -stdlib=libc++
CC = clang-10
CFLAGS = -g -I .
LLVMCXXFLAGS = `llvm-config-10 --cxxflags`
LLVMCFLAGS = `llvm-config-10 --cflags`
LLVMFLAGS = `llvm-config-10 --cxxflags --ldflags --system-libs --libs all`

FLEX = flex
YACC = yacc

all: build test
build: codegen
test: $(EXAMPLE_OUTPUTS) $(OUTPUTS) $(DIFFS)

codegen: ${OBJ}
	${CXX} ${CFLAGS} ${LLVMFLAGS} -o codegen y.tab.o table.o proj3.o semantic.o ${OBJ} -lfl

lex.yy.c: lex.l
	$(FLEX) lex.l

#y.tab.h: grammar.y lex.yy.c
#	$(YACC) -d -v grammar.y

#y.tab.c: grammar.y lex.yy.c
#	$(YACC) -d -v grammar.y

%.o: %.cpp ${HEADERS}
	${CXX} ${CFLAGS} ${LLVMCXXFLAGS} -c $< -o $@

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} ${LLVMCFLAGS} -c $< -o $@

define example_rules
examples_outputs/$(1:examples/%.cpp=%).exe: $(1) llvm/LLVMGlobals.o
	@${CXX} ${CFLAGS} ${LLVMFLAGS} llvm/LLVMGlobals.o $$< -o $$@
examples_outputs/$(1:examples/%.cpp=%).codegen.ll: examples_outputs/$(1:examples/%.cpp=%).exe
	@echo "$$< > $$@"
	-@$$< > $$@
examples_outputs/$(1:examples/%.cpp=%).codegen.s: examples_outputs/$(1:examples/%.cpp=%).codegen.ll
	@echo "${CC} -Wno-override-module -S -c $$< -o $$@"
	-@${CC} -Wno-override-module -S -c $$< -o $$@
examples_outputs/$(1:examples/%.cpp=%).codegen.exe: examples_outputs/$(1:examples/%.cpp=%).codegen.s
	@echo "${CC} $$< -o $$@"
	-@${CC} $$< -o $$@
examples_outputs/$(1:examples/%.cpp=%).codegen.out: examples_outputs/$(1:examples/%.cpp=%).codegen.exe
	@echo "$$< > $$@"
	-@$$< > $$@
endef
$(foreach example,$(EXAMPLES),$(eval $(call example_rules,$(example))))

define test_rules
outputs/$(1:tests/%.mjava=%).ll: $(1) codegen
	@echo "./codegen -v -o $$@ $(1) > outputs/$(1:tests/%.mjava=%).log"
	-@./codegen -v -o $$@ $(1) > outputs/$(1:tests/%.mjava=%).log
outputs/$(1:tests/%.mjava=%).s: outputs/$(1:tests/%.mjava=%).ll
	@echo "${CC} -S -c $$< -o $$@"
	-@${CC} -Wno-override-module -S -c $$< -o $$@
outputs/$(1:tests/%.mjava=%).o: outputs/$(1:tests/%.mjava=%).s
	@echo "${CC} -c $$< -o $$@"
	-@${CC} -c $$< -o $$@
outputs/$(1:tests/%.mjava=%).exe: outputs/$(1:tests/%.mjava=%).o
	@echo "${CC} $$^ -o $$@"
	-@${CC} $$^ -o $$@
ifneq ("$(wildcard tests/$(1:tests/%.mjava=%).in)","")
outputs/$(1:tests/%.mjava=%).out: outputs/$(1:tests/%.mjava=%).exe
	@echo "$$< < tests/$(1:tests/%.mjava=%).in > $$@"
	-@$$< < tests/$(1:tests/%.mjava=%).in > $$@
else
outputs/$(1:tests/%.mjava=%).out: outputs/$(1:tests/%.mjava=%).exe
	@echo "$$< > $$@"
	-@$$< > $$@
endif
endef
$(foreach test,$(TESTS),$(eval $(call test_rules,$(test))))

define diff_rules
diffs/$(1:tests/%.mjava=%).diff: outputs/$(1:tests/%.mjava=%).out
	@echo "diff -dy -W 170 $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@"
	-@diff -d $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@
endef
$(foreach test,$(TESTS),$(eval $(call diff_rules,$(test))))

clean:
	rm -f codegen lex.yy.c ${OBJ} outputs/* examples_outputs/* diffs/*
#	rm -f codegen y.tab.* lex.yy.c ${OBJ} outputs/* examples_outputs/* diffs/*