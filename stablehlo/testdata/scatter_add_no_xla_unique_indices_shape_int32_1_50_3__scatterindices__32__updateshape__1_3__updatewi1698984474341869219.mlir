// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xi32>, tensor<1x3xi32>)
    %2 = call @expected() : () -> tensor<1x50x3xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xi32>, tensor<1xi32>, tensor<1x3xi32>) -> tensor<1x50x3xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xi32>, tensor<1x50x3xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xi32>, tensor<1x3xi32>) {
    %0 = stablehlo.constant dense<"0x000000000200000002000000FEFFFFFF01000000FCFFFFFF0000000001000000FEFFFFFF010000000000000000000000FEFFFFFF0000000002000000000000000000000000000000FFFFFFFFFFFFFFFFFCFFFFFFFDFFFFFF0500000000000000FBFFFFFF0000000003000000FDFFFFFF0100000002000000FDFFFFFF000000000500000000000000FFFFFFFF030000000000000001000000FCFFFFFFFDFFFFFFFEFFFFFF00000000FCFFFFFF00000000FBFFFFFF00000000FAFFFFFF0100000004000000FDFFFFFF01000000FBFFFFFF01000000FFFFFFFFFFFFFFFF01000000FEFFFFFFFEFFFFFF0400000002000000FEFFFFFF0300000000000000030000000200000001000000FFFFFFFF02000000FEFFFFFF0100000001000000FEFFFFFFFEFFFFFF07000000FFFFFFFF0200000000000000000000000200000002000000040000000500000000000000FFFFFFFFFEFFFFFF070000000300000000000000FDFFFFFFFEFFFFFFFFFFFFFF01000000F9FFFFFF010000000200000000000000FEFFFFFF000000000100000000000000FCFFFFFFFCFFFFFF00000000020000000100000000000000FEFFFFFFFBFFFFFFFEFFFFFFFBFFFFFFFCFFFFFFFEFFFFFF01000000FAFFFFFF03000000000000000400000002000000FDFFFFFF00000000FEFFFFFF04000000FDFFFFFFFFFFFFFF00000000FDFFFFFF0000000002000000FEFFFFFF0300000000000000FFFFFFFFFCFFFFFFFDFFFFFF00000000040000000000000000000000000000000000000002000000FEFFFFFFFFFFFFFFFDFFFFFF0000000002000000FEFFFFFFFFFFFFFF0400000000000000"> : tensor<1x50x3xi32>
    %1 = stablehlo.constant dense<[[-1, 5, 0]]> : tensor<1x3xi32>
    return %0, %1 : tensor<1x50x3xi32>, tensor<1x3xi32>
  }
  func.func private @expected() -> tensor<1x50x3xi32> {
    %0 = stablehlo.constant dense<"0x000000000200000002000000FEFFFFFF01000000FCFFFFFF0000000001000000FEFFFFFF010000000000000000000000FEFFFFFF0000000002000000000000000000000000000000FFFFFFFFFFFFFFFFFCFFFFFFFDFFFFFF0500000000000000FBFFFFFF0000000003000000FDFFFFFF0100000002000000FDFFFFFF000000000500000000000000FFFFFFFF030000000000000001000000FCFFFFFFFDFFFFFFFEFFFFFF00000000FCFFFFFF00000000FBFFFFFF00000000FAFFFFFF0100000004000000FDFFFFFF01000000FBFFFFFF01000000FFFFFFFFFFFFFFFF01000000FEFFFFFFFEFFFFFF0400000002000000FEFFFFFF0300000000000000030000000200000001000000FFFFFFFF02000000FEFFFFFF0100000001000000FEFFFFFFFEFFFFFF07000000FFFFFFFF0200000000000000000000000200000002000000040000000500000000000000FFFFFFFFFEFFFFFF070000000300000000000000FDFFFFFFFEFFFFFFFFFFFFFF01000000F9FFFFFF010000000200000000000000FDFFFFFF050000000100000000000000FCFFFFFFFCFFFFFF00000000020000000100000000000000FEFFFFFFFBFFFFFFFEFFFFFFFBFFFFFFFCFFFFFFFEFFFFFF01000000FAFFFFFF03000000000000000400000002000000FDFFFFFF00000000FEFFFFFF04000000FDFFFFFFFFFFFFFF00000000FDFFFFFF0000000002000000FEFFFFFF0300000000000000FFFFFFFFFCFFFFFFFDFFFFFF00000000040000000000000000000000000000000000000002000000FEFFFFFFFFFFFFFFFDFFFFFF0000000002000000FEFFFFFFFFFFFFFF0400000000000000"> : tensor<1x50x3xi32>
    return %0 : tensor<1x50x3xi32>
  }
}

