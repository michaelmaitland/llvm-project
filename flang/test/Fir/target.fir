// RUN: tco --target=i386-unknown-linux-gnu %s | FileCheck %s --check-prefix=I32
// RUN: tco --target=x86_64-unknown-linux-gnu %s | FileCheck %s --check-prefix=X64
// RUN: tco --target=aarch64-unknown-linux-gnu %s | FileCheck %s --check-prefix=AARCH64
// RUN: tco --target=powerpc64le-unknown-linux-gnu %s | FileCheck %s --check-prefix=PPC

// I32-LABEL: define i64 @gen4()
// X64-LABEL: define <2 x float> @gen4()
// AARCH64-LABEL: define { float, float } @gen4()
// PPC-LABEL: define { float, float } @gen4()
func.func @gen4() -> complex<f32> {
  %1 = fir.undefined complex<f32>
  %2 = arith.constant 2.0 : f32
  %c0 = arith.constant 0 : i32
  %4 = fir.insert_value %1, %2, [0 : index] : (complex<f32>, f32) -> complex<f32>
  %c1 = arith.constant 1 : i32
  %5 = arith.constant -42.0 : f32
  %6 = fir.insert_value %4, %5, [1 : index] : (complex<f32>, f32) -> complex<f32>
  // I32: store { float, float } { float 2.000000e+00, float -4.200000e+01 }
  // I32: %[[load:.*]] = load i64, ptr
  // I32: ret i64 %[[load]]
  // X64: store { float, float } { float 2.000000e+00, float -4.200000e+01 }
  // X64: %[[load:.*]] = load <2 x float>, ptr
  // X64: ret <2 x float> %[[load]]
  // AARCH64: ret { float, float }
  // PPC: ret { float, float }
  return %6 : complex<f32>
}

// I32-LABEL: define void @gen8(ptr noalias sret({ double, double }) align 4 captures(none) %
// X64-LABEL: define { double, double } @gen8()
// AARCH64-LABEL: define { double, double } @gen8()
// PPC-LABEL: define { double, double } @gen8()
func.func @gen8() -> complex<f64> {
  %1 = fir.undefined complex<f64>
  %2 = arith.constant 1.0 : f64
  %3 = arith.constant -4.0 : f64
  %c0 = arith.constant 0 : i32
  %4 = fir.insert_value %1, %3, [0 : index] : (complex<f64>, f64) -> complex<f64>
  %c1 = arith.constant 1 : i32
  %5 = fir.insert_value %4, %2, [1 : index] : (complex<f64>, f64) -> complex<f64>
  // I32: store { double, double } { double -4.000000e+00, double 1.000000e+00 }
  // X64: store { double, double } { double -4.000000e+00, double 1.000000e+00 }
  // X64: %[[load:.*]] = load { double, double }
  // X64: ret { double, double } %[[load]]
  // AARCH64: ret { double, double }
  // PPC: ret { double, double }
  return %5 : complex<f64>
}

// I32: declare void @sink4(ptr byval({ float, float }) align 4)
// X64: declare void @sink4(<2 x float>)
// AARCH64: declare void @sink4([2 x float])
// PPC: declare void @sink4(float, float)
func.func private @sink4(complex<f32>) -> ()

// I32: declare void @sink8(ptr byval({ double, double }) align 4)
// X64: declare void @sink8(double, double)
// AARCH64: declare void @sink8([2 x double])
// PPC: declare void @sink8(double, double)
func.func private @sink8(complex<f64>) -> ()

// I32-LABEL: define void @call4()
// X64-LABEL: define void @call4()
// AARCH64-LABEL: define void @call4()
func.func @call4() {
  // I32: = call i64 @gen4()
  // X64: = call <2 x float> @gen4()
  // AARCH64: = call { float, float } @gen4()
  // PPC: = call { float, float } @gen4()
  %1 = fir.call @gen4() : () -> complex<f32>
  // I32: call void @sink4(ptr byval({ float, float }) align 4 %
  // X64: call void @sink4(<2 x float> %
  // AARCH64: call void @sink4([2 x float] %
  // PPC: call void @sink4(float %{{.*}}, float %{{.*}})
  fir.call @sink4(%1) : (complex<f32>) -> ()
  return
}

// I32-LABEL: define void @call8()
// X64-LABEL: define void @call8()
// AARCH64-LABEL: define void @call8()
func.func @call8() {
  // I32: call void @gen8(ptr sret({ double, double }) align 4 %
  // X64: = call { double, double } @gen8()
  // AARCH64: = call { double, double } @gen8()
  // PPC: = call { double, double } @gen8()
  %1 = fir.call @gen8() : () -> complex<f64>
  // I32: call void @sink8(ptr byval({ double, double }) align 4 %
  // X64: call void @sink8(double %{{[0-9]*}}, double %{{[0-9]*}})
  // AARCH64: call void @sink8([2 x double] %
  // PPC: call void @sink8(double %{{.*}}, double %{{.*}})
  fir.call @sink8(%1) : (complex<f64>) -> ()
  return
}

// I32-LABEL: define i64 @char1lensum(ptr {{[^%]*}}%0, ptr {{[^%]*}}%1, i32 %2, i32 %3)
// X64-LABEL: define i64 @char1lensum(ptr {{[^%]*}}%0, ptr {{[^%]*}}%1, i64 %2, i64 %3)
// PPC-LABEL: define i64 @char1lensum(ptr {{[^%]*}}%0, ptr {{[^%]*}}%1, i64 %2, i64 %3)
func.func @char1lensum(%arg0 : !fir.boxchar<1>, %arg1 : !fir.boxchar<1>) -> i64 {
  // X64-DAG: %[[p0:.*]] = insertvalue { ptr, i64 } undef, ptr %1, 0
  // X64-DAG: = insertvalue { ptr, i64 } %[[p0]], i64 %3, 1
  // X64-DAG: %[[p1:.*]] = insertvalue { ptr, i64 } undef, ptr %0, 0
  // X64-DAG: = insertvalue { ptr, i64 } %[[p1]], i64 %2, 1
  %1:2 = fir.unboxchar %arg0 : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1>>, i64)
  %2:2 = fir.unboxchar %arg1 : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1>>, i64)
  // I32: %[[add:.*]] = add i64 %
  // X64: %[[add:.*]] = add i64 %
  %3 = arith.addi %1#1, %2#1 : i64
  // I32: ret i64 %[[add]]
  // X64: ret i64 %[[add]]
  return %3 : i64
}
