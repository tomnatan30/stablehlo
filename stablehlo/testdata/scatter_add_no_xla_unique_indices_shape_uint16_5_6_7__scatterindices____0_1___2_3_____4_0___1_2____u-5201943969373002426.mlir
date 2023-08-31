// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x020002000000000004000000010001000100010002000200040001000200040002000100010002000000030001000100030001000200030000000100070000000000000002000100000000000100020001000300000004000400030000000100020003000000000005000300030002000200040001000000020001000400000000000100040002000100000002000000010002000500040000000200040000000100000002000200000003000000020005000100050001000100020004000300020001000000020008000100030001000200040000000000030000000000000001000000050005000200020001000100040001000200010003000100020000000000000000000200000003000100030002000000020003000200000002000400000003000000030000000100010001000000000000000000020003000100000002000200000000000300010001000500030001000000070000000000050002000100010004000200000004000100030000000600020000000200010004000200020000000600020003000000000001000400010005000200010000000000030000000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[0, 4], [0, 2]], [[0, 5], [1, 1]], [[1, 2], [0, 2]], [[4, 0], [0, 3]], [[3, 2], [0, 0]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x020002000000000004000000010001000100030002000200040001000200040002000500010002000000030001000100030001000200030000000100070000000000000002000100000000000100020001000300000004000400030000000100020003000000010005000300030002000200040001000500020001000400000000000100040002000100000003000000010002000500040000000200040000000100000002000200000004000000020005000100050001000100040004000300020001000000020008000300030001000200040000000000030000000000000001000000050005000200020001000100040001000200010003000100020004000000000000000200000003000100060002000000020003000200000002000400000003000000030000000100010001000000000000000000020003000100000002000200000000000300010001000500030004000000070000000000050002000100010004000200000004000100030000000800020000000200010004000200020000000600020003000000000001000400010005000200010000000000030000000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

