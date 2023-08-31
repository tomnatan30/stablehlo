// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xbf16>, tensor<20x20xbf16>) {
    %0 = stablehlo.constant dense<"0xE8BF63405EC0C03F0A3F184027406FC04EC0FE402AC0833F20402EBF1DC018C0564022C0A9BE21C051C0184093C04C40A6C0C840A13F51C0263F3E40384014BFCFBD44C07DC010C0D33F58C0973EDA3FA2C0A0BF49C0BC3F6FC01F4082409E3DF83C6C40894085C059BDD83B4A40DC40B5C037BFA8BFD73E01C0F8C0B93F02C09240483C364022C020C0ACBE5C3FB43F6BC0FF3F23BFE9BDA34003C0AF40C2BD5DBF4AC0674098C032BFE9BFBEBFECBF81C09E408EC010C038BE9840C0BDE1BE7C3EAE3F3BBF62BF3740AABF2C4098404640F7BF85400D3F773F7CC08F40C8400EC018BF963FE7BFB23E66C05DBE8E4040BFA3401F4003402C3F1CC051C02F4007404DBF704086BDB93F89BF06C0BE3FA63FA4BFB43BAB3FF5BF90BF9A40EFBE3F40423F8FC0823F2E4094C035C03ABF6540EEBF44C075BD2E40B23F59BF7AC0FC3F97402FBFA53F2540994001C074408A40813E644086C0C34005BD29BD5C3F9DBD9CBF0D3F6CBF45BFFB3ED13FE8BE3540773DBC409FBFBB3F044055C01E40D4401240D03F5DBE04C0F9BF65C060408BC008C0574036C0BA40D1BF4640C9BF653F4FC028C06DC0DCBE244039C0DB408C3F90C0053F6E40F640DBBD86C0B3C016BF2DBF9A3EF73FE3BF8AC0BCBE87C0A7BF50407940C1C09EC072400B4088C045BF64BF5F409A3F4E40ABBFE53FB33ECD3FB740A9BF304020409C404FC08BC051C0403CCD3F2240E6BF484034C0F73FC6C0BBC04C4027C0EABF0540AE3FEF3F2FC02E4082BF8C3FA6400040D5BF0E3F8FBF4E4003BED2409CBF61C07740214058BE76C04AC0B73FF8BE0AC0793FBD3F93404E407D40394048C0B4BF9FBF993F8B40D83FC63FE83FB240453FEABE1EBD2BC0184086BE2A40A63F70405D3FCD3E5ABF1CBF11BF454048C00D3F86BFE73F40BF233E5E3FC73FFE3F0340BCC09A3E394001C189C0DB3F3740733FBB3F9EBE4A4074402A404240273FD53FF9BFF2BD6CC0B8BEC6BD0840E5BFA23FABBF444056BF58403A3E0D3F86BE51C090C051C0AABF0541EBBE4B3F9640CBBF9D3F944046C055C014BE4A3E173F57C077401F408DBF91BFFE3CA73F3A40953F91BFB4BE28C08E40EE3F883FCE3FCDBF59C07BBE"> : tensor<20x20xbf16>
    %1 = stablehlo.constant dense<"0xB33EBC3FCD3E2D4084C03840DB3F913EE0BFA73F4B402340A3BE5E40D3C045C097BF93BF3FBF1CBE2F40563F24C07CC0F9BF7B40F13F5D4094C0FE3F8BC0F8BD10402D40ADC02FBF1340623FEABDDCBF9E3FFE3D49C0D93F173E823F9ABF8BC0E13F094076BF58BFACBF6EC0FABF84406BBED9BE79C092C0B93DBABF33C0863FB23F3EBE5BC0AFBFC0C025C0AF40D34026402EC07AC084BE61C037C019C0EDBF66C0A1C09DC0C1BD2FC0FABF3640A2C0B1C0E8C0614022C02840F2BF56C0C6BF65400C3F96C01D40F3BF67C0104018C028406F3EBF3E39C001C0A63F9D4024C08040CFBF474061BD08408CBF1ABE7340ACBED4BFAA40183FE13F303F16C021C018BF31C0B34049C0F03F1840C2BD99BFD93FF3BD0340A1C03D3F81BF963D8E3E2EC02CC03B409E4017BF95BFC1BE34BDBBBCE83F443FF0BFA54027C00C4051BCCC3DD3C04B3E70BF16C0E43F8F3F01C0183F8ABEFBBF07C0EE3F01C0324008C075C060BFF5BF9140DF4023BF87C07AC0A13F5340CB4085407FC0A3BEC33FB83FACBFAA3E48BFD7C03F3FEBBF08C09BBF1F40E93FAE3D973F28C058C0EEBF5C4039BF864075BE21BEA93FA0BF0640AB3FE3BCF7BEB33F8140E73FC33F6AC0C83FD4BF9AC0ADC0F7BD3EC00E400CC018C03ABF83BFF43FEF3FA8BE223EC23EC9BE1DC028404540BBBF2FC0523F74C05B40C5BC56BF843E933FA13ED73FF53E66C0A2BE8CBFD0BFB1400F3F7040BF3E9FBD74BFB1BF4DC0093E3CC0C2C027403C400E40C13F6D3FBEBFA4BF7B40A1BF7E40F4BF013E01409FC0844057C078C04B3E1740D23E0740DEBF8E4083405E409CC0F43F693F1B400EBFEDC0144003C059C0B23F59C082403F3F7A40C4BF9D407040563F96C0413F0940D23E76BF18C0013F6FBFA4BFD5BEE9BE2DC0C33E28C0E23FCFC0A140E43F1AC052BF19C0A340CFC02EC06EC015C05D40353F444044BFA0C00D3FAA406F402F3F30C032BF9B3EAB40FFC0453FC840CE3FF1BE8A3DD2BF24C0B0BE88C087BF0F40CBBF833FC13F8BC03640FFBF2ABF59BF0240074022C0BDC015C08CBFB9406EC0753FD9BF814006404FBFF63FC3BFA33F8D4040400140DD3F57BF69C0D0BF774046BF0241EA3F2440"> : tensor<20x20xbf16>
    return %0, %1 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x22BFA740B2BF82400EC0DA408F4087BFB440264107C127404CBF17C08141EA407CC03A407C3EC43E0FC1FE3F3C4149C12141C441184034C140C0BD4048C18F3D69BE04C1AB41C53F72403FC00ABD3BC0C8C01FBE1E411F400DBF21409CC0ACBE5A3DFD4084C06040923DC9BCC5C0E341A63F9B3EA340F5BF3ABE344181C008C0CB4014BB1CC15D4070415E3F9640144118C1ADC01F40F03C8FC1BB4051C1343E47407E418EC1E53EF33F644087C01541B2410FC27AC1B640F2BE10C1A03E2E3F613F3E3F5B400BC0AEC09940C24034C10241E7BEC63FCCBFF9BFA3C0AF4180C10EC1763F6940CB3D3D3F7C40053D8741813E07C153419C3F973FD6BFF540DCC0A0BF0E40A841523E2D4023C04B3EE3BF0D401C3E383CD7C0B5BF913FB43E05BE02C102C051C1A040CDBFAC40883F033DA7BD58C016C0E63D604168C0EDBF4C3D493EF9C10BBE9BBFC1C0084110C0F6C024408BBDE0C00D413541863DEBBDEABF963E883F87BF86C0ACC0A0BEDCC0E33F64404C3E1542A5C0BAC028BFA2C063400EC1423FA2BFBA3FC5BF6540F34088C02DC178C0923E57C074C1B040B8C0ADC025BF59C1213F153F11BF4DC0C2C01241F8BC0B403A3F70415E4127BE75410CC1783F5040D0BF6EBEA84019C14E3F2041733F55C0ED4034C1CF3F193F533FD63FF23F16C02C41E1BF0DC18CBFDAC0993F1EBD99C0AEBE4A40493F0341C6BF7A41843F52BC27C0604180BF3C4186BF19BEBD40014123C1B3BEAC404AC16340B040C2C0834071BFD0BFD5C0FB4006400D400840D03E84BE02C2A1C03D416FC1FF3EFFBECABFD5C01FC00AC00DC15840E6C00C413B401941CDBFB94150C0234082C0C140B7C0C940AD3FAE4197BF10C014BE0FC032C14ABEB640083F67C003C04F3E4C3F483F713EB3BF0741573E30404C409B404D3FC63F6FC0D0BF9DC0EFC1F9BFFBC0F0411F41BD4001403A408FBFC63FDF3FA2411F410540E6BF94BF17BF22BFEB418EBE1BBF5B40583FAF3D0C40FBC0933E66C144BE9E3FD53E56C0D9C0634172C084C19C3E2CBF184156C047C0DBC1E640694056BF3CBF113FB6407941A640643F0BC041BDD53F4D41604012C01BBF0D4081C141C083409FBF50C1C6C021BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
