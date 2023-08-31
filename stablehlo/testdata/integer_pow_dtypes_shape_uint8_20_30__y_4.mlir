// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui8>
    %1 = call @expected() : () -> tensor<20x30xui8>
    %2 = call @integer_pow(%0) : (tensor<20x30xui8>) -> tensor<20x30xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xui8>, tensor<20x30xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui8> {
    %0 = stablehlo.constant dense<"0x000205010304000004030101040101010301020202020500010503020100060105000501060100030004010402000300000201010101010004070501000004010102020301000002000400030400000507010001030002020403040006000300010004020604020305000002020000000100000100020104010002020200010305020105000200030201050003000603010300050401000102020801030201000302040101000001030000050103000705000301010103040203020001000104020300020100020200030300000003000502020200030202000200000000030202000201010001020003030503010204000403020202010300000402010205030104040406010900020406000006020303010001020000010101030100000500000004020603030103010004000002030501010202000204030401050100010206020002050403010204000501010201000200020200020104050105000203010000010000070407000003030102020000050401010304020303000303040305000104020201030101000304030102060100020602020000000003020003000100010302000001030104000101020001000202020102010406000201020103000401020501040203010001030002010000000405050304010000030003030201030202030205030200000000000000030307010000030201010401010403010001030202020301010101040200010202040200010002030202000306020100000400010605030302040401010000020300000101030003030504000002030502010001020301010204040100050003030201020003010600"> : tensor<20x30xui8>
    return %0 : tensor<20x30xui8>
  }
  func.func private @expected() -> tensor<20x30xui8> {
    %0 = stablehlo.constant dense<"0x00107101510000000051010100010101510110101010710001715110010010017100710110010051000001001000510000100101010101000061710100000001011010510100001000000051000000716101000151001010005100001000510001000010100010517100001010000000010000010010010001001010100001517110017100100051100171005100105101510071000100011010000151100100511000010100000151000071015100617100510101015100105110000100010010510010010010100051510000005100711010100051101000100000000051101000100101000110005151715101100000005110101001510000001001107151010000001001A100100010000010105151010001100000010101510100007100000000101051510151010000000010517101011010001000510001710100011010100010710051011000007101011001001000101000100100710171001051010000010000610061000051510110100000710001015100105151005151005171000100101001510101005100510110100100101010100000000051100051000100015110000001510100000101100001001010100110010010001001100151000001107101001051010001510010010000000071715100010000510051511001511010511071511000000000000000515161010000511001010001010051010001511010105101010101001000011010001000010010511010005110100100000000011071515110000001010000105100000101510051517100000010517110010001105101011000000100710051511001100051011000"> : tensor<20x30xui8>
    return %0 : tensor<20x30xui8>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xui8>) -> tensor<20x30xui8> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xui8>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xui8>
    return %1 : tensor<20x30xui8>
  }
}
