; ModuleID = 'outputs/if-else-statements.ll'
source_filename = "outputs/if-else-statements.ll"

%IfElse = type {}

@IfElse.global = global %IfElse zeroinitializer
@scanf.format = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@string.const = private unnamed_addr constant [3 x i8] c"i=\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @scanf(...)

declare i32 @printf(...)

define i32 @main() {
entry:
  %x = alloca i32
  %i = alloca i32
  %0 = call i32 (...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @scanf.format, i32 0, i32 0), i32* %x)
  %1 = load i32, i32* %x
  %sgt = icmp sgt i32 %1, 10
  br i1 %sgt, label %then, label %else

then:                                             ; preds = %entry
  store i32 1, i32* %i
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %2 = load i32, i32* %x
  %sgt1 = icmp sgt i32 %2, 6
  br i1 %sgt1, label %then2, label %else3

then2:                                            ; preds = %ifcont
  store i32 2, i32* %i
  br label %ifcont7

else3:                                            ; preds = %ifcont
  %3 = load i32, i32* %x
  %sgt4 = icmp sgt i32 %3, 3
  br i1 %sgt4, label %then5, label %else6

then5:                                            ; preds = %else3
  store i32 3, i32* %i
  br label %ifcont7

else6:                                            ; preds = %else3
  store i32 4, i32* %i
  br label %ifcont7

ifcont7:                                          ; preds = %else6, %then5, %then2
  %4 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const, i32 0, i32 0))
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %6 = load i32, i32* %i
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %6)
  ret i32 0
}
