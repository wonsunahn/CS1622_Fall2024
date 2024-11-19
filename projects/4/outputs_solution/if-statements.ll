; ModuleID = 'outputs/if-statements.ll'
source_filename = "outputs/if-statements.ll"

%IfStatements = type { i32 }

@IfStatements.global = global %IfStatements { i32 -1 }
@string.const = private unnamed_addr constant [5 x i8] c"x>=0\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %x = alloca i32
  store i32 4, i32* %x
  %0 = load i32, i32* %x
  %1 = icmp sge i32 %0, 0
  br i1 %1, label %then, label %else

then:                                             ; preds = %entry
  %2 = call i32 (...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @string.const, i32 0, i32 0))
  %3 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  ret i32 0
}
