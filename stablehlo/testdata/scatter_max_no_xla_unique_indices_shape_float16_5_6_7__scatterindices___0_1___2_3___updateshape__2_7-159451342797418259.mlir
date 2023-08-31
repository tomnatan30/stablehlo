// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0xD8B8A4453E2FE8389F4068B749C413C1D441CA3EEEBBE44274BE68B5DD3DA74372C395C3133BAF43E0BF6EC17041F5C07129ECC439C6E24339C4CF42583DF13CE2C390BC75BA7C32C12CE8BDE3C5073B903D9C4296BCB5C246C4B6B9FB2C914260BDC836D43A19C4F5C365BDEA4067C416413E3846418BB9D1C44440CEBC8BBCCCBAB6402B4320C4AEB430C1E4441645D3433E3BD43DD7BA91BD4BC06342ACC354BD1540123D5442B1BC3CB765C3F4C6024658C612C6953F3B40392E65BFDDAEEAB8EFBED6BAA5C27FC2AAC4C3447F427F415DBBB1BBBABF59B876BF16C1E5C5BCC2FCC404C47CBC00BFDEC4F5377438C1B5EEC2944328C1854111AE32C1D23A8FC1A43D54418A424DC19D3C77BE1944413802B52E4356BAFE4175B56E41C7418241FE41E1405335B6454E45FBB5C6ADC34146BB5C3C404899441340FAC5853E5B3C1B3FC5C052C0433FD8BDBEC471C26DC5FB3A0741D82F0646F83FDF4012C08040554348C02446623CD0445B408FC2A82D87361F3044C011C174C0C43D6B41ECBAC0C05DC31CC40AC3EAC55E25F4C0D4406D42C23842BA8CC03A3ACEBE21434CC697B8"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[-4.394530e-01, 1.122070e+00, -2.027340e+00, -3.626950e+00, 3.560550e+00, -4.431150e-01, 1.429690e+00], [2.484380e+00, 8.312500e+00, 5.854490e-01, -2.175290e-01, -1.337890e+00, -5.105470e+00, -3.939450e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xD8B8A4453E2FE8389F4068B749C408B7D441CA3EEEBB1F4317B7B83DDD3DA74372C395C3133BAF43E0BF6EC17041F5C07129ECC439C6E24339C4CF42583DF13CE2C390BC75BA7C32C12CE8BDE3C5073B903D9C4296BCB5C246C4B6B9FB2C914260BDC836D43A19C4F5C365BDEA4067C416413E3846418BB9D1C44440CEBC8BBCCCBAB6402B4320C4AEB430C1E4441645D3433E3BD43DD7BA91BD4BC06342ACC354BD1540123D5442B1BC3CB765C3F4C6024658C612C6953F3B40392E65BFDDAEEAB8EFBED6BAA5C27FC2AAC4C3447F427F41F8402848AF38F6B25ABD16C1E1C3BCC2FCC404C47CBC00BFDEC4F5377438C1B5EEC2944328C1854111AE32C1D23A8FC1A43D54418A424DC19D3C77BE1944413802B52E4356BAFE4175B56E41C7418241FE41E1405335B6454E45FBB5C6ADC34146BB5C3C404899441340FAC5853E5B3C1B3FC5C052C0433FD8BDBEC471C26DC5FB3A0741D82F0646F83FDF4012C08040554348C02446623CD0445B408FC2A82D87361F3044C011C174C0C43D6B41ECBAC0C05DC31CC40AC3EAC55E25F4C0D4406D42C23842BA8CC03A3ACEBE21434CC697B8"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

