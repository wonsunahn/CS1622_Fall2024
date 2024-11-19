; ModuleID = 'outputs/multi-class.ll'
source_filename = "outputs/multi-class.ll"

%Rect = type { i32, i32 }
%Main = type { i32 }

@Rect.global = global %Rect { i32 7, i32 3 }
@string.const = private unnamed_addr constant [17 x i8] c"width & length: \00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@Main.global = global %Main zeroinitializer

declare i32 @printf(...)

define i32 @getArea(%Rect* %0) {
entry:
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @string.const, i32 0, i32 0))
  %2 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %3 = getelementptr inbounds %Rect, %Rect* %0, i32 0, i32 1
  %4 = load i32, i32* %3
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  %6 = getelementptr inbounds %Rect, %Rect* %0, i32 0, i32 0
  %7 = load i32, i32* %6
  %8 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %7)
  %9 = getelementptr inbounds %Rect, %Rect* %0, i32 0, i32 1
  %10 = load i32, i32* %9
  %11 = getelementptr inbounds %Rect, %Rect* %0, i32 0, i32 0
  %12 = load i32, i32* %11
  %13 = mul i32 %10, %12
  ret i32 %13
}

define i32 @main() {
entry:
  %area = alloca i32
  %0 = load i32, i32* getelementptr inbounds (%Rect, %Rect* @Rect.global, i32 0, i32 1)
  %1 = icmp sgt i32 %0, 0
  br i1 %1, label %then, label %else

then:                                             ; preds = %entry
  store i32 5, i32* getelementptr inbounds (%Rect, %Rect* @Rect.global, i32 0, i32 1)
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %2 = call i32 @getArea(%Rect* @Rect.global)
  store i32 4, i32* getelementptr inbounds (%Rect, %Rect* @Rect.global, i32 0, i32 0)
  %3 = call i32 @getArea(%Rect* @Rect.global)
  store i32 %3, i32* %area
  %4 = load i32, i32* %area
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  %6 = call i32 @getArea(%Rect* @Rect.global)
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %6)
  ret i32 0
}
