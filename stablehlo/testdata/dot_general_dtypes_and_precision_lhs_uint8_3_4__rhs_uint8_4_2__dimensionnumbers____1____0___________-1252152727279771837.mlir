// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3x4xui8>, tensor<4x2xui8>)
    %1 = call @expected() : () -> tensor<3x2xui8>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>, precision_config = [#stablehlo<precision HIGH>, #stablehlo<precision HIGH>]} : (tensor<3x4xui8>, tensor<4x2xui8>) -> tensor<3x2xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xui8>, tensor<3x2xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x4xui8>, tensor<4x2xui8>) {
    %0 = stablehlo.constant dense<[[2, 1, 3, 2], [1, 1, 3, 1], [0, 0, 4, 0]]> : tensor<3x4xui8>
    %1 = stablehlo.constant dense<[[0, 0], [2, 5], [2, 0], [1, 2]]> : tensor<4x2xui8>
    return %0, %1 : tensor<3x4xui8>, tensor<4x2xui8>
  }
  func.func private @expected() -> tensor<3x2xui8> {
    %0 = stablehlo.constant dense<[[10, 9], [9, 7], [8, 0]]> : tensor<3x2xui8>
    return %0 : tensor<3x2xui8>
  }
}
