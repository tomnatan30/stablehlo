// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %2 = call @expected() : () -> tensor<3x5x40xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui8>, tensor<2x1xi32>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>) {
    %0 = stablehlo.constant dense<"0x0501000003010001010401010200000002050300020101030000000001000001010206050004010305030401050202000202020004000404040601000300010600020301000100020508030203010001030201010202000302040300040105050304010001030104000103050201000304040203040201010100010601030102060203000200010000070001010000010003030000020402030104040101010200030202020002030201050006000301030000010302020000000201000202030100030201000505000305000003030200010001010503010401020001000103010205000004040302030305040004030101000003030001020000000106010100010200020000040401040205000104020200000500010104000400040100010000020006000302000402000601070201010001050001040104020100030000030500020100020003010200010101000100000103050307000503000002020004040400000103010100010302040005020104020405020301020001010302030507010202070300030202000406040301000002030003040103000002030004000202000104000100020301040301020202000006000302040207010303050108060403010504020201040100030206020100020000000102030002010203020302000303060501000003010204020402000107030100010000010001020001020504010100040000000300000300010200010204010A0005020702020404010101000400040101010502030206030104000001010101040008020201000305020300010004000202020101010000010104010000030102"> : tensor<3x5x40xui8>
    %1 = stablehlo.constant dense<[[[3, 0], [4, 1], [3, 3], [2, 0], [3, 1]], [[1, 3], [2, 2], [4, 2], [1, 0], [1, 3]], [[0, 4], [0, 5], [0, 1], [2, 4], [0, 1]]]> : tensor<3x5x2xui8>
    return %0, %1 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> tensor<3x5x40xui8> {
    %0 = stablehlo.constant dense<"0x05000000030100010104010102000000020503000201010300000000010000010102060500040103050C0401050202000202020004000404040601000300010600020301000100020508030203010001031201010202000302040300040105050304010001030104000103050201000304040203040201010100010601030102060203000200010000070001010000010003030000020402030104040101010200090202020002030201050006000301030000010302020000000201000202030100030201000505000905000003030200010001010503010401020001000103010205000004040302030305040004030104000003030001020000000106010100010200020000040401040205000104020200000500010104000400040100010000020006000302000402000601070201010001050001040104020100030000030000020100020003010200010101000100000103050307000503000002020004040400000103010100010302040005020104020405020301020001010302030507010202070300030202000406040301000002030003040103000002030004000202000104000100020301040301020202000006000302040007010303050108060403010504020201040100030206020100020000000102030002010203020300000303060501000003010204020402000107030100010000010001020001020504010100040000000300000300010200010204010A0005020702020404010101000400040101010502030206030104000001010101040008020201000305020300010004000202020101010000010104010000030102"> : tensor<3x5x40xui8>
    return %0 : tensor<3x5x40xui8>
  }
}

