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
  %2 = icmp sgt i32 %1, 10
  br i1 %2, label %then, label %else

then:                                             ; preds = %entry
  store i32 1, i32* %i
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %3 = load i32, i32* %x
  %4 = icmp sgt i32 %3, 6
  br i1 %4, label %then1, label %else2

then1:                                            ; preds = %ifcont
  store i32 2, i32* %i
  br label %ifcont5

else2:                                            ; preds = %ifcont
  %5 = load i32, i32* %x
  %6 = icmp sgt i32 %5, 3
  br i1 %6, label %then3, label %else4

then3:                                            ; preds = %else2
  store i32 3, i32* %i
  br label %ifcont5

else4:                                            ; preds = %else2
  store i32 4, i32* %i
  br label %ifcont5

ifcont5:                                          ; preds = %else4, %then3, %then1
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const, i32 0, i32 0))
  %8 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %9 = load i32, i32* %i
  %10 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %9)
  ret i32 0
}
