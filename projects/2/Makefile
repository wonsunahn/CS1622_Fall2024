TARGETS = parser
TESTS = $(wildcard tests/*.mjava)
OUTPUTS := $(foreach test,$(TESTS),outputs/$(test:tests/%.mjava=%).out)
DIFFS_DEFAULT := $(foreach test,$(TESTS),diffs_default/$(test:tests/%.mjava=%).diff)
DIFFS_SIDE_BY_SIDE := $(foreach test,$(TESTS),diffs_side_by_side/$(test:tests/%.mjava=%).diff)

CC = gcc
C++ = g++
FLEX = flex
YACC=yacc

all: build test
build: $(TARGETS)
test: $(OUTPUTS) $(DIFFS_DEFAULT) $(DIFFS_SIDE_BY_SIDE)

parser: y.tab.o proj2.o table.o driver.o
	$(CC) -g -o parser y.tab.o proj2.o table.o driver.o -ll -lstdc++

y.tab.c: lex.yy.c proj2.h
y.tab.c: grammar.y
	$(YACC) -d -v  $< 

lex.yy.c: lex.l
	$(FLEX) $< 

%.o: %.c
	$(CC) -g -c $<
%.o: %.cpp
	$(C++) -g -c $<

define test_rules
outputs/$(1:tests/%.mjava=%).out: parser $(1)
	@echo "cat $(1) | ./parser > $$@"
	-@cat $(1) | ./parser > $$@
endef
$(foreach test,$(TESTS),$(eval $(call test_rules,$(test))))

define diff_rules
diffs_default/$(1:tests/%.mjava=%).diff: outputs/$(1:tests/%.mjava=%).out
	@echo "diff -dy -W 170 $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@"
	-@diff -d $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@
diffs_side_by_side/$(1:tests/%.mjava=%).diff: outputs/$(1:tests/%.mjava=%).out
	@echo "diff -dy -W 170 $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@"
	-@diff -dy -W 120 $$< outputs_solution/$(1:tests/%.mjava=%).out > $$@
endef
$(foreach test,$(TESTS),$(eval $(call diff_rules,$(test))))

clean:
	rm -f parser *.o lex.yy.c y.tab.h y.tab.c y.output outputs/*.out diffs_default/*.diff diffs_side_by_side/*.diff
