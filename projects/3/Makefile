CXXSOURCES = $(shell find . -not -path './examples/*' -name '*.cpp')
CSOURCES = $(shell find . -not -path './y.tab.c' -and -not -path './lex.yy.c' -name '*.c')
CSOURCES += y.tab.c
HEADERS = $(shell find . -not -path './y.tab.h' -name '*.h')
HEADERS += y.tab.h
OBJ += $(CXXSOURCES:%.cpp=%.o)
OBJ += $(CSOURCES:%.c=%.o)


TESTS = $(wildcard tests/*.mjava)
OUTPUTS := $(foreach test,$(TESTS),outputs/$(test:tests/%.mjava=%).out)
DIFFS := $(foreach test,$(TESTS),diffs/$(test:tests/%.mjava=%).diff)

CXX = clang++-10 -stdlib=libc++
CC = clang-10
CFLAGS = -g -I .
LLVMCXXFLAGS = `llvm-config-10 --cxxflags`
LLVMCFLAGS = `llvm-config-10 --cflags`
LLVMFLAGS = `llvm-config-10 --cxxflags --ldflags --system-libs --libs all`

FLEX = flex
YACC = yacc

all: build test
build: parser
test: $(OUTPUTS) $(DIFFS)

parser: ${OBJ}
	${CXX} ${CFLAGS} ${LLVMFLAGS} -o parser ${OBJ} -lfl

lex.yy.c: lex.l
	$(FLEX) lex.l

y.tab.h: grammar.y lex.yy.c
	$(YACC) -d -v grammar.y

y.tab.c: grammar.y lex.yy.c
	$(YACC) -d -v grammar.y

%.o: %.cpp ${HEADERS}
	${CXX} ${CFLAGS} ${LLVMCXXFLAGS} -c $< -o $@

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} ${LLVMCFLAGS} -c $< -o $@


define test_rules
outputs/$(1:tests/%.mjava=%).out: parser $(1)
	@echo "./parser -v $(1) > $$@"
	-@./parser -v $(1) > $$@
endef
$(foreach test,$(TESTS),$(eval $(call test_rules,$(test))))

define diff_rules
diffs/$(1:tests/%.mjava=%).diff: outputs/$(1:tests/%.mjava=%).out
	@echo "diff -dy -W 170 $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@"
	-@diff -d $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@
endef
$(foreach test,$(TESTS),$(eval $(call diff_rules,$(test))))
clean:
	rm -f parser y.tab.* lex.yy.c ${OBJ} outputs/*.out diffs/*.diff