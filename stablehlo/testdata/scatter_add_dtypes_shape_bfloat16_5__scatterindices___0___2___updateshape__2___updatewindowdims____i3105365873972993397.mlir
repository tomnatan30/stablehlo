// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0], [2]]> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5xbf16>, tensor<2xbf16>)
    %2 = call @expected() : () -> tensor<5xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0], index_vector_dim = 1>} : (tensor<5xbf16>, tensor<2x1xi32>, tensor<2xbf16>) -> tensor<5xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5xbf16>, tensor<5xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5xbf16>, tensor<2xbf16>) {
    %0 = stablehlo.constant dense<[-3.812500e+00, 1.867190e+00, 4.281250e+00, 1.617190e+00, -1.671880e+00]> : tensor<5xbf16>
    %1 = stablehlo.constant dense<[1.125000e+00, 2.109380e+00]> : tensor<2xbf16>
    return %0, %1 : tensor<5xbf16>, tensor<2xbf16>
  }
  func.func private @expected() -> tensor<5xbf16> {
    %0 = stablehlo.constant dense<[-2.687500e+00, 1.867190e+00, 6.375000e+00, 1.617190e+00, -1.671880e+00]> : tensor<5xbf16>
    return %0 : tensor<5xbf16>
  }
}

