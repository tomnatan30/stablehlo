// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x125xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0x33DCF9BF960B87404D3998C0292E1B403F500840B5F1B3C053708EBF8142A73DADD885401B8BA5BFA51343406C909E3F04E024C05F0B96C0191D9EC0CC0930C0607AA53E8AF6D93F510008C1E9847540D80247BF37DFB4BF6F2D17C06E7D8F400BE51CC01F0F70400D4FD3BED0D056C08963893F41B7C0BFF2A8E540768C0D3F67875D3F02F0F63FCB659840D1E296BF712516BFDCF7B6BF49CD8DC020633EC06E07D33E69A5EBBFA9D98C3FBB8F37C05F2EDABEB81403BFB72549C0071D8940DC6473C0E8C0AB3FD8395F40C45515C06E47C840F0A3ACBFB72B763F28A08740069BA93FADD72440CA2E55BFBC92C83F5142E13F3E817A3FCE5235C070D1823FE80800C1581185BEE4D6EF3F2D327C40328A5BC0ECA862BEFD6A40BF061CEABF73DA034016E15C4007F208C0A036BB3F1345A33FD1AC9FBD0695A940B3EF4CC0F6D61040C6E3C03F917F55BF00DB8A40FA8661BFCA96C33F693CC2BF8F8B7D40EF6ACBBF3DD9D0BFBEFDAA3F8562A8C05A5835C09AC584C030084F4022EBCD3F98E7B8C0714D9A405539F83FBF86724081A1363E537EB43F5DB1833F8974FCBEBA3339BF9E31D4BD8A3119BF1A531ABE3CE3283FBCB2BFBEB262DE3E21C5D1BF849360405C7F903F318FA740195B7CC041CB17405B22D73F51BC0540F4C3C4BF5279C13F93F56EC08BA20440B103654034F71640"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<2.08696723> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x33DCF9BF960B87404D3998C0292E1B403F500840B5F1B3C053708EBF8142A73DADD885401B8BA5BFA51343406C909E3F04E024C05F0B96C0191D9EC0CC0930C0607AA53E8AF6D93F510008C1E9847540D80247BF37DFB4BF6F2D17C06E7D8F400BE51CC01F0F70400D4FD3BED0D056C08963893F41B7C0BFF2A8E540768C0D3F67875D3F02F0F63FCB659840D1E296BF712516BFDCF7B6BF49CD8DC020633EC06E07D33E69A5EBBFA9D98C3FBB8F37C05F2EDABEB81403BFB72549C0071D8940DC6473C0E8C0AB3FD8395F40C45515C06E47C840F0A3ACBFB72B763F28A08740069BA93FADD72440CA2E55BFBC92C83F5142E13F3E817A3FCE5235C070D1823FE80800C1581185BEE4D6EF3F2D327C40328A5BC0ECA862BEFD6A40BF061CEABF73DA034016E15C4007F208C0A036BB3F1345A33FD1AC9FBD0695A940B3EF4CC0F6D61040C6E3C03F917F55BF00DB8A40FA8661BFCA96C33F693CC2BF8F8B7D40EF6ACBBF3DD9D0BFBEFDAA3F8562A8C05A5835C09AC584C030084F4022EBCD3F98E7B8C0714D9A405539F83FBF86724081A1363E537EB43F5DB1833F8974FCBEBA3339BF9E31D4BD8A3119BF1A531ABE3CE3283FBCB2BFBEB262DE3E21C5D1BF849360405C7F903F318FA740195B7CC041CB17405B22D73F51BC0540F4C3C4BF5279C13F93F56EC08BA20440B103654034F71640"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}

