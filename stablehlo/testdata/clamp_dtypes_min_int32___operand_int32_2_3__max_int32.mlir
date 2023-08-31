// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:3 = call @inputs() : () -> (tensor<i32>, tensor<2x3xi32>, tensor<i32>)
    %1 = call @expected() : () -> tensor<2x3xi32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [] : (tensor<i32>) -> tensor<2x3xi32>
    %3 = stablehlo.broadcast_in_dim %0#2, dims = [] : (tensor<i32>) -> tensor<2x3xi32>
    %4 = stablehlo.clamp %2, %0#1, %3 : tensor<2x3xi32>
    %5 = stablehlo.custom_call @check.eq(%4, %1) : (tensor<2x3xi32>, tensor<2x3xi32>) -> tensor<i1>
    return %5 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<i32>, tensor<2x3xi32>, tensor<i32>) {
    %0 = stablehlo.constant dense<[[-3, 1, 1], [0, 3, 1]]> : tensor<2x3xi32>
    %1 = stablehlo.constant dense<1> : tensor<i32>
    %2 = stablehlo.constant dense<-2> : tensor<i32>
    return %1, %0, %2 : tensor<i32>, tensor<2x3xi32>, tensor<i32>
  }
  func.func private @expected() -> tensor<2x3xi32> {
    %0 = stablehlo.constant dense<-2> : tensor<2x3xi32>
    return %0 : tensor<2x3xi32>
  }
}
