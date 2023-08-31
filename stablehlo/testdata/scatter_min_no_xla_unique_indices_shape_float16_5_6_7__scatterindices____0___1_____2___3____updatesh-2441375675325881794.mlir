// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0x0C2DE54163412FC1DA451BBC964205440AB9753CB54225BBFEC6F23FD74133B8244082C341C40CB192BC4541F9B435BEFE3D85BD3B430A459C3C8F3D48339635A23CDA394DC13E4358C03AC26C3DB642E9B8DD3E06C19FB41C41893C30B807C2B74219BE82AB2B440F38BB343F3EEAC03FBFDF41FA2C23AB88BF75B999BF79B2C0461DB8FF3F1AC2B2B731C8454325C31A3ED1C352BC8D405EB98FAB8B4054B826AC56C6C7C431BB47418F31853D77411CBDC1BCB6BC0841CEC4B03B0F4137BD6441F3B9F0C42A3CDE38DCBE81342840EEC498BEFCB5CD41CD3857C4CD46F745B642743B7C4421BCBBC337A71F3FF8C42C383143434387BBD5C0DE46DFC19544404042439E4007B45CC204380B383744EA4628C12BBCD9C47835E6C1FD425B382C400DC152BD91C4023EA2BCE0BA2E3B7032F7C10B3E5741B72E2AB273C6B2BA5A40643D18BD84C5CBBE3DC4AFC0ECBA63C27243203DB0C1EE403B44523A87402EBBDE35473768AFB0C10F3F60C42B41C33ED4B46D46E9C18B357B32563B603909C2F8B54644DF2F3D486EC06EBCC13A75C00A441FC381B9E0BC1B446E40EABCDF465AC1"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0xB2B62C47973E0B3C08C493AAD93972B96D453039D841E1C051C5BFC5503BE43E1CC031442734652F4F460940D0C08441A6C114454E4261C1E3BE8B3A323C88C2D52E88BD523DB5C05CC25FB97D3C9F3D02BFDAB8ACC64FC066449BC186443BC811C0D842D4BFC9B683C258B73638B3347DBF4AB800C2203A114208BFC9C4C03F7E3B6144D7C3B342FB3CAC40AE4071443AC5F542F5412F3994C070C04CC78ABAF9BE9F354ABE6142C14181C2DE40E33C4EC3AC343C3C2FC433BB6AC6A93A2EC652BAB3350CC78D3DFC3DC13CB641424054C4F545AF38E4BDED4689C4E1C25B38283ED642C3370ABE97C664BBDCC0D93D61C4063859C5F8C167C065378E3D45B7B4B6D7AF97B4BDC2783A21C60642EB3C46413A4314AD19BD"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xB2B6E541973E2FC108C41BBCD93972B90AB93039D841E1C0FEC6BFC5503B33B81CC082C341C40CB192BC0940D0C035BEA6C185BD4E4261C19C3C8F3D48339635A23CDA394DC13E4358C03AC26C3DB642E9B8DD3E06C19FB4323C88C230B807C2523DB5C05CC25FB90F38BB3402BFEAC0ACC64FC0FA2C9BC188BF3BC811C079B2D4BF1DB883C21AC2B2B731C8454325C31A3ED1C352BC8D405EB98FAB8B4054B826AC56C6C7C431BB7DBF4AB800C2203A1CBD08BFC9C4C03FCEC4B03BD7C337BDFB3CF3B9F0C42A3C3AC5DCBE81342F39EEC470C04CC78ABAF9BE57C44ABE6142B642743B7C4421BCBBC337A71F3FF8C42C383143434387BBD5C0DE46DFC181C24040E33C4EC307B45CC22FC433BB6AC6A93A2EC62BBCD9C40CC7E6C1FC3D5B382C400DC154C491C4AF38E4BDE0BA89C4E1C2F7C10B3E5741B72E2AB273C6B2BA5A40643D18BD84C5CBBE3DC4AFC0ECBA63C2D642C337B0C197C664BBDCC0D93D61C4DE3559C5F8C1B0C1653760C445B7B4B6D4B497B4BDC28B3521C6563B603909C2F8B514AD19BD3D486EC06EBCC13A75C00A441FC381B9E0BC1B446E40EABCDF465AC1"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

