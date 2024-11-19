; ModuleID = 'outputs/structs.ll'
source_filename = "outputs/structs.ll"

%Point = type { i32, i32 }
%Structs = type { %Point }

@Point.global = global %Point { i32 10, i32 20 }
@Structs.global = global %Structs { %Point { i32 10, i32 20 } }
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %pointLocal = alloca %Point
  %0 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 0
  store i32 10, i32* %0
  %1 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 1
  store i32 20, i32* %1
  %2 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 0
  %3 = load i32, i32* getelementptr inbounds (%Structs, %Structs* @Structs.global, i32 0, i32 0, i32 0)
  store i32 %3, i32* %2
  %4 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 1
  %5 = load i32, i32* getelementptr inbounds (%Structs, %Structs* @Structs.global, i32 0, i32 0, i32 1)
  store i32 %5, i32* %4
  %6 = load i32, i32* getelementptr inbounds (%Structs, %Structs* @Structs.global, i32 0, i32 0, i32 0)
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %6)
  %8 = load i32, i32* getelementptr inbounds (%Structs, %Structs* @Structs.global, i32 0, i32 0, i32 1)
  %9 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %8)
  %10 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 0
  %11 = load i32, i32* %10
  %12 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %11)
  %13 = getelementptr inbounds %Point, %Point* %pointLocal, i32 0, i32 1
  %14 = load i32, i32* %13
  %15 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %14)
  ret i32 0
}
