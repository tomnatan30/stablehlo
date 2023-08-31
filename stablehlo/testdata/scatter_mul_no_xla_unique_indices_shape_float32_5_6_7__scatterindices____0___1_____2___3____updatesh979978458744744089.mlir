// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x1xi32>, tensor<5x2x2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>) {
    %0 = stablehlo.constant dense<"0x2691A8C0B3224E40C2C8A4BF0D8DFF3F4046043F49A0A6C09821843F05B1FE3F145B03BF728B80BF4622C53F9C4AAD3F7F51253F8E9A5A40842BDC3FA16B884057469DBFEEC5DEBFB37CE8BE3E9FD7BF1142253FEA1308C0D0EE94BF9FDF3ABFB4D7EFBFB8FB8AC03ACD1BC0F3B8AA405997CBBF18843E3FA4A109C0DCB2854023D9343E93D15FC0EEC608C07876834074AD83C048C438BF3F98BAC0AEB62AC01FC7364001B9F5C09F8A45C05BAB2C414FCE4B4054A306C0CB17563F05BFFE3FDBAEC040E53FBCC050CAB93F0755893FD852FA3FB0959E3EF36D16C08E64764016F0A63FAB715840A35F8740837C65C0DC3AB9BFD65795C0F88B42C05E178D4041B3924046BAF93FBC14223E33B284BE4EAE5B40AB5626401B366F401B2CF93F97A8CD3F8132C13F573684C070BBA7BF0C72EF3E97BCB7BF98595A40EBB61DC0BA0B1D40EAEBD43F173828BE59A8043D198AFFBF3CE7773F6172B3BFDB3ABB3F0ED517C03A34BF40A7FCFC3FFD5ACDBE5752C8C081541E3F6E5D98BF480B1B401AB602C05B053E3F2E6FB0BFA6EB7740D5FB1E40CCA916BF0702A3C0F2A06BBF51E4C240A8DD4C40750A51C023F807C06197023CE39EEF3F36956140FA3021409DD4B5BE26EDEBBE50F85D3FD6DF7640080147C0F3398A4059352F4053BFC83F5ED91CC04958C3BF454028C084BDAA404390863FE0CC4040D0B3823C8823A3BDA5D49E40E829354045F8FB3E55A59F3F956ACE3FF7E3364092BE62404A9B973FB19D8CBFD41B88BF9CD21640EB3164C098CB253F8CD697BF5AD5A2BF64EA793E32948EBFEE4B7F3F5917AF3F6D983540B266B0C0AAA38B3F62A4CD405E7696406E7B903F510E0B4082126F40C8D2DCBF756BD6BF2BD132C0DCADA740A416AC3E8F953CC09B871EC0E3B00FBFFF8CA3C0B4F05AC0C6588AC0461585408A0481BFC064AF3F3DFC7140FDCF2140B378A5C0BE704CC0D5E383BE57D553C05AD3A0BE91AD78BEC70D05402B77A53E6E1077C0E35EAA40C2FC3040E0A5B1400B26EA3E66E016C0D4291DC0A85A81BF57A4F13F2EA03D3F7E3AA5C02780543F1F07B040897BF2BEFC7354BFDBAA1A3F8A162B3FB6C7153F544C4EC02A923EBE3211803FBF02863E776D5A3D1AB5FAC0DED882BFF84EF03FC44F21C0A1E06E3ED4A417407FE1EF3F20A81AC0"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<"0xEE2A85C04A62A240D6AE1CBE0BCB6D40C298114021C964C051DBBE3F412330C0D9E39740F555693F5711A83F0600833F157421C0702AA2400F989940323BFBBFA591433EA8E28240BF7AC0BF17B38BBEBAC7F4BE86E6A0C083FA29BF6FF4A5BE4339674000C72040D1084EC00234A13E3639183E19F61040930B60402B56E8BFCE93A6404C57ABBF6B97043F86AD5240DF3107C030F0ACBFDF5C81C0CE881CC0CB0C5ABD5A092240194620406D20AF3EF3738D3F0A1683BF2362F7BF61A7584096CAC4C088256ABFCA63E4BE797680BF39D0E43F796F293FCA6542C0D49B97BF7F27C6C0624DB1BFF3F251C0B6BA8840252875BF5DA7163E98BAB0BE0A88CDBFE6203FC03AB3FA3F6DA6A7BE990486BF5B597EC04D6A3DC0013235BFA6EA2C3FFE5B2C40C595ABBF2E6A7E3F1BBE40BF94B1153F2D17BCBF764C0BC16F5B11BF50F043C0A66589C0AD3A25BF0218EAC01CA61F4047E0D3BF09E9B43D98E372402B55AFC079D923BEAF21833F576DD83F548BAF40B418B93F53A20540A1484B40AA486EBF3159D040EB74A0BFF3305CC0214467C0FB09973F37F930C0A6BE17BF3AB882BF65ADC2BC19AD9740B4E341C0332EE6BD7803ACC0CA4D8E40727108BFE902713FDF692DC0AEF6D73F00B3D3C04DBE3CC03214144038A51CBF89F987C06126B0BFEC3439C06253C6C0C8899B3F8E48BCC0BFDF0E3F191BDD40F5850FC0D1713E40385B0240950B4B3D03B138C078B886C0B72FF0BEB9C6353F7FA002402C68C53F01736D4046CA5D3F85D00C40"> : tensor<5x2x2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x5B5FAF411AC18241C1B5493E4560ED407075963FAAE994414304C53FC63CAFC044DF1BC028546ABFD86B0140645AB13F6F86D0BF0B7A8A41C918044112E105C11D4C70BE80CBE3C0FFCC2E3F9D54EB3EE7039EBEF70D2B41C9C6453F1F49723E49A1D8C0B9922EC105C9FA40FF01D73F5997CBBF18843E3FA4A109C0DCB2854023D9343E93D15FC0EEC608C07876834074AD83C048C438BF3F98BAC0AEB62AC01FC7364001B9F5C0E8ECEABEC18CC341BC5D3241AB6274400A4F8B4077802AC04198474004EC9AC1C43B44C0F48BB9BF1DFDFCC0EDEF41BF2521003EA2F41B41870751401E11943FFA999540F1046B40CCFE324083C77CC11E8D95410B0C81C0D5E002C06AA1FABF4CDE903ED7A62FBE70D126C1BE0445C01B366F401B2CF93F97A8CD3F8132C13F573684C070BBA7BF0C72EF3E97BCB7BF98595A40EBB61DC0BA0B1D40EAEBD43F173828BE59A8043D3CCC4541D0B1ABBFAE2A9340A4FFC740B6661140350B613F19A62EBFFDDE243F2D8F95415F0D9B3F0090C73E615522C04EDE0141DC980CC024C2793F92752740A914D64020F7493F9FFFA1C0B067313F27EC6340538596C03A7EE34138689A3FCBE7C7BC2D9B00C1E09811C0E26593C19DD4B5BE26EDEBBE50F85D3FD6DF7640080147C0F3398A4059352F4053BFC83F5ED91CC04958C3BF454028C084BDAA404390863FE0CC4040FA04233D3505073E327CE03EADE22B418B922CC0C75B4CBE6677D33F769E9A40AE7B9B41B33BDB3F2DCE12C05D2958C09C620CC010B8B9C1EFD54FBF69998240DA199340FF72933E5E214540E95317BFB7CFB2BF82188ABDB307D1C12F8553C0CDE638BF2233CAC1BCA0A040753A94BF82126F40C8D2DCBF756BD6BF2BD132C0DCADA740A416AC3E8F953CC09B871EC0E3B00FBFFF8CA3C0B4F05AC0C6588AC0461585408A0481BFD71FA53F88EB23C1998188402FD60842C5BA16413D9418BFB89E014070D8AA3F9C1CAB3EED84C0C0103000C0EB1B96C0F09BFAC1C88DC53F006F1942C64583BF407BE0C07C0EA0C07B314DBD3455AEC0F89447C0A2051B4090E3163FF3A33341BCFB3ABFD10E45C0B4FF053F5D37BC3FB6C7153F544C4EC02A923EBE3211803FBF02863E776D5A3D1AB5FAC0DED882BFF84EF03FC44F21C0A1E06E3ED4A417407FE1EF3F20A81AC0"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

