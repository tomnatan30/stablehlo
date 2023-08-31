// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf16>
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xf16>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0xF2C73C4004BD4248CFC0DB3B1A441C407C39B2B7D2C32F37D2419145F2C136370FC4C5C8DDBACFC606B0E4B524BBBA359CC0C64045C5C6BB88C053C17E38E841EAC1183CDF3F04406BC02AC4C23C13C1D7C17A354ABD59C1B841C9B610BA4BC311B4B8437E41243C82463B40713ABF44AA33C2C07B3E1D353B3E73413342DDBC56BAE642C33C60BD9CBFC6C84A3D2941E0C5C04530474E38893528B4A137B644F63D6EC097C48A3C093F163BB6B6EEBFF9C2662EECC4743FB2416AC16730F0C2FCBC4A2F18C54FC4B3BF5142F44404461F436F3B8CBD2F43F6BD3F40C0BEFEBD61A4564212C17F456DBD6139EBAC0B42AE4041C55043E03830B9014443448B40713CEE374B3DE7BF23414D44244691B6F1C126C229C32FC34246143C47A36935ADC738C0C93F0CC31BC0DA3A16C0DBBC27BC3BB7EF43753E3845D74466C2FFC46CB9463F0041AA32D42ED0325845EC3E243E384409C0C63DC548A33A143CB8C43941B23E1E3E3E45813BDA43B6B6E1B385BEC2C396BC22C22740F3AFF147B3C618380AC42BBA4BC2204014B9493DF9C050BC3EC0EDC45943253CC83B68BE8D3BEB3320BC8439373C35B978BCF2C176466EBE483EBFC2E3BE1A40CA34343A953E93BA1FBD3BBA5343373E0A37803C73C132C68DC1903AC7C4D23C9ABE30316D3AA3C569C22A4382B8A93DB545F3BA1935C244C53E1442124118C1C52643C15EC08F44A23F46C1E6C0A242F1BABDBDC0462C42D53D0B3EA238D3B8BC4561BD79B37EBCC33EF0C4E5C54440C2431744354317403CC3763144C465B8463D0C3D66C2C24476C1EB3811C50BC4AA41CF3DA0421BC3693DB5433FBDDD388C41B6BA463C33C0E0448CBD00C1FCB915BDD4BFC1C23734023EA647BBBB05BDB0C0F93FB840813F69B92F36203D16B624BAECC07C3E6A3ED546193E1D35FA436DC0B03DB5BBB3BE3040C0C5A4BF6EB4B1BA65BF05C4E93BC83B1F42F1BC702C8A41B23FEB44A0BB88C21EBC334074B785433DBD4B3F87B9103745C2DD40CD3FFEC141C29DBF29BAF1C401C4BB3901C3AC3F33C1EAC01FC4CAC8A2BBF8B81B38BAC246A64EB5E5C09AC126C36031E0BE62BF1C40C13A46C4BF38A036ADC112C472488D4336422E42F34068C5263DB4C17428A6BF1AAD27C361BB0DC36A42DD4142BC04BC9F36AE3D67BCE1419BB7C7C112C298BE713E0A3F4343544154C0D43F67C26CC4CAC502C3D8BD02C4FC4032411CB027C262C3FEBA4144D82F10C01BC56E3A3243463A7ABF22BCFAAFB4457E38FEC2AB356331393D99C15241CC4279BB60C50D3FD73BFDC89444A6308E43DF43C838AE3C55426FC4CDC4B9C018C11DC255C307C570C0103E393E3DBC3DC2A0C2B1C158415C3D92BDD917C13B40403DB169463744744447BB7E441C3E2D45B0401F40213B7EB3E63610BE09C0D0B122C5FFBBA4AF76C2B22E97BD76350E43CA401631AA41B9BED4C7DB32A53D4EBDA4BC5CBEBC44A7B6D03EEDB46ABE669D59C238B8E1B477C4743BFFC499BE59BC1EBC4FC6C0448441773EFEC794BD8EB80C424B412D4382A9E1483DB691C5773B4B427EBCF9429F4265B620426243B1C1D6C3C4BCDA37C0C56638E3B33240FA45A34834BCDB35A4BCD8329AC4423CC6C455C00CC07031A2BDC54027B4AAC31EBEC33F08457342A63F114045B916C66F3D043F10C50B3CB140"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0xD6DFBF48E3BFD360F3CA933B5054574828351FAF79D3CB2D294E645991CEDC2D2DD4C8E20DB9EEDC129863AAB1B9DE291FCACC4A92D857BBD1C9B7CCAB31704E76CE4A3C9F470C4864C984D4BC3E15CC39CE22299FC0C7CCD94DE1ACF6B610D234A430532E4D703C4E5CBB482D38AF560923BCCA41442D288F430E4D724F31BFF3B72151BF3EDAC0E3C6CCE29F404B4C56DAF159CD5DFC304D297DA4F02E88569E426FC90BD6D93D71458F39B9ACCAC74CD1181473D77846C64DF6CC551937D1BDBF0D1622D800D522C7E14F9857CE5AA5516B3A55C1CB519EC2C948CEC4B9C25480F34F13CC3059FEC0DD346F8FE64E684A88D81C523E335DB40354D654DC49793DCA2FA240B6C73C4CF9543D5B6DAC8ECE44CFBDD1CBD1A85B3D3C3080F32811DFB1C85F4778D153C8063943C828BF79BCE8ADCD5335447158165718D0CCD7FBB40346D04BA020F914F120C5582E453D43B1541BC80442C86291383D3C91D6744CB044274381589A3A9053B9ACA4A354C44CD307BE36CF7948D997D35FB3DC4A301ED455B7C9CF634817B49D40B0CB03BDC6C878D73352733C5D3B1BC4BA3AC12363BC3E35AE3C69B494BD91CE375C27C4BF43CCD01BC55048DE267537744471B832C08FB724528043732DB23D0ECD6EDB58CD6A38D1D6003F7FC45D1C253898D91ED0BE51BAB1AA41CF593EB92428BC56D944044F134C22CC36018DCC35C9EC55F24695CC59CB8F503AB9E8C1CE5C594F3242E642373204B3E459DDC085A2ABBDD54486D767DADA484C534754D9514748EBD1171DDAD44EB19540044018D0BC5617CD6F3311D821D4AE4D20428B509BD1F340275383C03133554DB9B8E13CA1C83E5755C1D0CBB3B61AC07FC7D1D0AE24C742FE5E38BBE8BF70CAEB47914A9A46F3B4642B35400BAB3DB773CB43441F44FC5C16432D28EE536BC9C04127BBB3C49748F1D9F8C66FA5AFB852C60FD4BC3B5D3B2B4F8BBF760D504D1F476F57EDBA5AD05DBCA14878AEA4527EC0104647B5812DB4CF314B6B47B9CEA5CFE5C64EB78BD703D4E2355FD10E4764CC6ACB60D4DEE2F2BAABB35330C2D0F780AAA854CB7ECDB5D1DA1C13C549C65748D138E1D4AF328B2CB7CD37D47E61BA527C4F604F944BF0D84340CCCDC202FEC62690B8D147BA7AD11F504C4ED3BC0CBC892CB94155BD5A4EE0AE07CEFDCE7AC42D447345FB51BA4C11C97F471AD067D50FDA61D13DC206D4BD4B624C579847CF49D258B9D0548B1730C828D82738D251B73788C669BCEE97CC59AB3158D1B129E21C74407BCDB54CE85085BADAD87A45883BC3E3FF55471ABC529F53D532683EEF4F72D5EAD695CA22CC24CF28D2F2D776C9F6428743C3BC96CF8BD0C3CDC54CCF4067C10000493BCC487E9C1E5CAE54855506BAAB5520435558704A6048A93992A2212DF6C21BC8239E3AD8FDBBF89637D0B01475C117297D51DE4A1C1CAE4DBFC47FDF09219F41AAC03FBE05C4A25699ACF14478A71FC40280FECFB1B042A790D5783ACCD77DC423BD5DBCD9DBB3563E4D3844FADF6CC1E8B1E94EA24CC6513985426396AB64D9803AC94FABBD4C51895016AC2E4F4952C3CD85D3C4BE902FF1D95131AAA39D48AC5A3B62A4BC462A3FBE022117D6D33CCCD615C924C8061D96C1C84A79A409D327C34F47F6573150FE46344892B40BDB044165450ED8213C754A"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}
