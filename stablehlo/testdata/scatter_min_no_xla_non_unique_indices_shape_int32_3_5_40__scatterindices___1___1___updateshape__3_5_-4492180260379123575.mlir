// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>)
    %2 = call @expected() : () -> tensor<3x5x40xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi32>, tensor<2x1xi32>, tensor<3x5x2xi32>) -> tensor<3x5x40xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi32>, tensor<3x5x40xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi32>, tensor<3x5x2xi32>) {
    %0 = stablehlo.constant dense<"0xFCFFFFFFFFFFFFFFFBFFFFFF0000000000000000FAFFFFFF0000000003000000040000000100000003000000020000000000000000000000FEFFFFFFFEFFFFFF09000000FBFFFFFF0200000001000000FFFFFFFF0400000001000000FCFFFFFFFDFFFFFF0400000000000000010000000300000001000000000000000000000001000000FEFFFFFF0300000001000000020000000200000000000000000000000200000003000000FFFFFFFF01000000FFFFFFFF000000000200000000000000FEFFFFFFFFFFFFFFFDFFFFFF06000000FCFFFFFFFBFFFFFFFEFFFFFF02000000FEFFFFFF02000000FEFFFFFF00000000FFFFFFFFFFFFFFFF000000000200000000000000FFFFFFFFFEFFFFFF00000000FFFFFFFFFFFFFFFF00000000FDFFFFFF0300000001000000FFFFFFFF0400000000000000FFFFFFFF0000000006000000FDFFFFFF03000000FFFFFFFFF9FFFFFFFFFFFFFF0100000006000000FDFFFFFF010000000200000005000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00000000FBFFFFFF00000000FFFFFFFF00000000FBFFFFFF030000000000000001000000FEFFFFFF0000000006000000030000000000000000000000FFFFFFFF050000000000000000000000FDFFFFFF0400000000000000FDFFFFFFFFFFFFFF05000000FEFFFFFF02000000030000000000000002000000FFFFFFFF00000000FBFFFFFF00000000FAFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF02000000FEFFFFFF0200000002000000000000000000000000000000FEFFFFFFFDFFFFFFFFFFFFFF02000000020000000000000000000000FEFFFFFFFAFFFFFFFFFFFFFF0100000002000000FEFFFFFFF9FFFFFF0000000000000000FDFFFFFF000000000000000000000000FCFFFFFF00000000FDFFFFFFFEFFFFFF00000000FEFFFFFF0200000005000000010000000000000003000000FEFFFFFF04000000FEFFFFFF0000000003000000FFFFFFFFFFFFFFFFFFFFFFFF02000000FEFFFFFF0400000000000000040000000000000002000000FFFFFFFF010000000100000000000000FCFFFFFF0000000000000000FFFFFFFF03000000FFFFFFFF0000000005000000000000000000000002000000000000000300000000000000FEFFFFFF00000000FEFFFFFFFFFFFFFF06000000FBFFFFFF020000000100000000000000000000000100000004000000FAFFFFFF000000000200000001000000FEFFFFFF0700000002000000FDFFFFFF00000000FEFFFFFF0000000003000000FBFFFFFF0200000004000000FDFFFFFF000000000000000003000000FDFFFFFF000000000000000000000000030000000000000000000000FCFFFFFFFEFFFFFF0200000006000000000000000400000001000000010000000000000000000000020000000000000000000000FEFFFFFF0400000002000000000000000200000002000000FBFFFFFF0000000005000000FEFFFFFF0400000002000000FDFFFFFF000000000000000001000000FFFFFFFFFDFFFFFFFDFFFFFFF9FFFFFFFFFFFFFF000000000000000000000000FEFFFFFF0000000000000000FDFFFFFF000000000000000000000000FCFFFFFF0000000001000000FCFFFFFF000000000000000000000000FFFFFFFF05000000FEFFFFFF00000000FDFFFFFF00000000FEFFFFFF0100000000000000FAFFFFFFFCFFFFFFFEFFFFFF05000000000000000000000001000000FFFFFFFF0400000007000000FEFFFFFFFFFFFFFFFBFFFFFF0000000003000000030000000200000000000000030000000000000000000000FCFFFFFFFDFFFFFF07000000030000000300000001000000000000000000000000000000010000000600000000000000FDFFFFFFFFFFFFFF01000000FCFFFFFF000000000000000004000000000000000200000007000000FFFFFFFF0400000000000000040000000300000000000000FFFFFFFF000000000000000001000000F9FFFFFFFFFFFFFFFEFFFFFFFEFFFFFF00000000FFFFFFFF0200000001000000040000000300000001000000000000000200000003000000FFFFFFFF00000000FFFFFFFFFDFFFFFFFBFFFFFFFDFFFFFF020000000100000000000000FFFFFFFFFBFFFFFFFEFFFFFF0300000000000000000000000700000003000000FFFFFFFF03000000010000000400000000000000FCFFFFFFFEFFFFFFFCFFFFFF04000000FDFFFFFF00000000050000000000000000000000010000000400000000000000070000000200000001000000FBFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF00000000000000000000000000000000FDFFFFFF02000000FFFFFFFF020000000000000001000000FFFFFFFF0000000003000000FBFFFFFFFFFFFFFFFFFFFFFF0400000001000000FFFFFFFFFFFFFFFF03000000FFFFFFFFFFFFFFFF010000000100000001000000F9FFFFFFFCFFFFFF0500000007000000FEFFFFFF0200000000000000000000000100000000000000FEFFFFFF0400000000000000040000000000000001000000FFFFFFFF000000000400000005000000FFFFFFFFFAFFFFFF07000000FEFFFFFFFFFFFFFFFFFFFFFF00000000FAFFFFFF0300000000000000FFFFFFFF000000000000000000000000FEFFFFFF010000000200000002000000FDFFFFFF060000000600000000000000FFFFFFFF0000000000000000FBFFFFFF02000000FEFFFFFF0000000003000000FDFFFFFF00000000000000000200000000000000FDFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFF07000000FDFFFFFFFBFFFFFF01000000FEFFFFFFFFFFFFFF0200000001000000FBFFFFFFFFFFFFFFFDFFFFFF0100000003000000FEFFFFFFFDFFFFFF0200000000000000FDFFFFFFFAFFFFFFFEFFFFFFFEFFFFFFFDFFFFFF00000000FDFFFFFF000000000300000000000000030000000000000005000000020000000300000001000000FFFFFFFF00000000FCFFFFFF08000000FFFFFFFF0200000001000000FCFFFFFFFDFFFFFF0200000001000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFCFFFFFF010000000200000001000000FCFFFFFF0000000002000000FCFFFFFFFFFFFFFFF9FFFFFF00000000FEFFFFFF00000000FEFFFFFFFCFFFFFF02000000FFFFFFFF04000000000000000100000000000000000000000300000000000000010000000300000000000000FCFFFFFFFAFFFFFFFFFFFFFF00000000FCFFFFFFFEFFFFFF03000000FEFFFFFF0100000004000000FEFFFFFF010000000000000000000000FBFFFFFF01000000060000000100000000000000FEFFFFFF0200000002000000FFFFFFFF000000000600000003000000FFFFFFFFFDFFFFFF"> : tensor<3x5x40xi32>
    %1 = stablehlo.constant dense<[[[-3, -2], [-1, 3], [1, 1], [0, 0], [-4, -3]], [[0, -3], [-5, 2], [-3, -1], [0, -2], [-3, 1]], [[-1, 1], [1, 0], [0, 0], [2, 0], [-3, -3]]]> : tensor<3x5x2xi32>
    return %0, %1 : tensor<3x5x40xi32>, tensor<3x5x2xi32>
  }
  func.func private @expected() -> tensor<3x5x40xi32> {
    %0 = stablehlo.constant dense<"0xFCFFFFFFFDFFFFFFFBFFFFFF0000000000000000FAFFFFFF0000000003000000040000000100000003000000020000000000000000000000FEFFFFFFFEFFFFFF09000000FBFFFFFF0200000001000000FFFFFFFF0400000001000000FCFFFFFFFDFFFFFF0400000000000000010000000300000001000000000000000000000001000000FEFFFFFF03000000010000000200000002000000000000000000000002000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000000200000000000000FEFFFFFFFFFFFFFFFDFFFFFF06000000FCFFFFFFFBFFFFFFFEFFFFFF02000000FEFFFFFF02000000FEFFFFFF00000000FFFFFFFFFFFFFFFF000000000200000000000000FFFFFFFFFEFFFFFF00000000FFFFFFFFFFFFFFFF00000000FDFFFFFF0300000001000000FFFFFFFF0400000000000000FFFFFFFF0000000006000000FDFFFFFF01000000FFFFFFFFF9FFFFFFFFFFFFFF0100000006000000FDFFFFFF010000000200000005000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00000000FBFFFFFF00000000FFFFFFFF00000000FBFFFFFF030000000000000001000000FEFFFFFF0000000006000000030000000000000000000000FFFFFFFF050000000000000000000000FDFFFFFF0400000000000000FDFFFFFFFFFFFFFF05000000FEFFFFFF00000000030000000000000002000000FFFFFFFF00000000FBFFFFFF00000000FAFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF02000000FEFFFFFF0200000002000000000000000000000000000000FEFFFFFFFDFFFFFFFFFFFFFF02000000020000000000000000000000FEFFFFFFFAFFFFFFFFFFFFFF0100000002000000FEFFFFFFF9FFFFFF0000000000000000FDFFFFFF000000000000000000000000FCFFFFFF00000000FDFFFFFFFEFFFFFF00000000FEFFFFFF0200000005000000010000000000000003000000FEFFFFFF04000000FEFFFFFF0000000003000000FFFFFFFFFFFFFFFFFFFFFFFF02000000FEFFFFFF0400000000000000040000000000000002000000FFFFFFFF010000000100000000000000FCFFFFFF0000000000000000FFFFFFFF03000000FFFFFFFF00000000050000000000000000000000FDFFFFFF000000000300000000000000FEFFFFFF00000000FEFFFFFFFFFFFFFF06000000FBFFFFFF020000000100000000000000000000000100000004000000FAFFFFFF000000000200000001000000FEFFFFFF0700000002000000FDFFFFFF00000000FEFFFFFF0000000003000000FBFFFFFF0200000004000000FDFFFFFF000000000000000003000000FDFFFFFF00000000000000000000000003000000FBFFFFFF00000000FCFFFFFFFEFFFFFF0200000006000000000000000400000001000000010000000000000000000000020000000000000000000000FEFFFFFF0400000002000000000000000200000002000000FBFFFFFF0000000005000000FEFFFFFF0400000002000000FDFFFFFF000000000000000001000000FFFFFFFFFDFFFFFFFDFFFFFFF9FFFFFFFFFFFFFF000000000000000000000000FEFFFFFFFDFFFFFF00000000FDFFFFFF000000000000000000000000FCFFFFFF0000000001000000FCFFFFFF000000000000000000000000FFFFFFFF05000000FEFFFFFF00000000FDFFFFFF00000000FEFFFFFF0100000000000000FAFFFFFFFCFFFFFFFEFFFFFF05000000000000000000000001000000FFFFFFFF0400000007000000FEFFFFFFFFFFFFFFFBFFFFFF0000000003000000030000000200000000000000FEFFFFFF0000000000000000FCFFFFFFFDFFFFFF07000000030000000300000001000000000000000000000000000000010000000600000000000000FDFFFFFFFFFFFFFF01000000FCFFFFFF000000000000000004000000000000000200000007000000FFFFFFFF0400000000000000040000000300000000000000FFFFFFFF000000000000000001000000F9FFFFFFFFFFFFFFFEFFFFFFFEFFFFFF00000000FDFFFFFF0200000001000000040000000300000001000000000000000200000003000000FFFFFFFF00000000FFFFFFFFFDFFFFFFFBFFFFFFFDFFFFFF020000000100000000000000FFFFFFFFFBFFFFFFFEFFFFFF0300000000000000000000000700000003000000FFFFFFFF03000000010000000400000000000000FCFFFFFFFEFFFFFFFCFFFFFF04000000FDFFFFFF00000000050000000000000000000000FFFFFFFF0400000000000000070000000200000001000000FBFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF00000000000000000000000000000000FDFFFFFF02000000FFFFFFFF020000000000000001000000FFFFFFFF0000000003000000FBFFFFFFFFFFFFFFFFFFFFFF0400000001000000FFFFFFFFFFFFFFFF03000000FFFFFFFFFFFFFFFF010000000100000001000000F9FFFFFFFCFFFFFF0500000007000000FEFFFFFF0200000000000000000000000100000000000000FEFFFFFF0400000000000000040000000000000001000000FFFFFFFF000000000400000005000000FFFFFFFFFAFFFFFF07000000FEFFFFFFFFFFFFFFFFFFFFFF00000000FAFFFFFF0300000000000000FFFFFFFF000000000000000000000000FEFFFFFF010000000200000002000000FDFFFFFF060000000600000000000000FFFFFFFF0000000000000000FBFFFFFF02000000FEFFFFFF0000000003000000FDFFFFFF00000000000000000200000000000000FDFFFFFFFEFFFFFF00000000FDFFFFFFFFFFFFFF07000000FDFFFFFFFBFFFFFF01000000FEFFFFFFFFFFFFFF0200000001000000FBFFFFFFFFFFFFFFFDFFFFFF0100000003000000FEFFFFFFFDFFFFFF0200000000000000FDFFFFFFFAFFFFFFFEFFFFFFFEFFFFFFFDFFFFFF00000000FDFFFFFF000000000300000000000000030000000000000005000000020000000300000001000000FFFFFFFF00000000FCFFFFFF08000000FFFFFFFF0200000001000000FCFFFFFFFDFFFFFF0200000001000000FEFFFFFF00000000FEFFFFFFFEFFFFFFFCFFFFFF010000000200000001000000FCFFFFFF0000000002000000FCFFFFFFFFFFFFFFF9FFFFFF00000000FEFFFFFF00000000FEFFFFFFFCFFFFFF02000000FDFFFFFF04000000000000000100000000000000000000000300000000000000010000000300000000000000FCFFFFFFFAFFFFFFFFFFFFFF00000000FCFFFFFFFEFFFFFF03000000FEFFFFFF0100000004000000FEFFFFFF010000000000000000000000FBFFFFFF01000000060000000100000000000000FEFFFFFF0200000002000000FFFFFFFF000000000600000003000000FFFFFFFFFDFFFFFF"> : tensor<3x5x40xi32>
    return %0 : tensor<3x5x40xi32>
  }
}

