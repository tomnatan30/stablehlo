// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<8x4x3x3x4xf32>, tensor<4x8x3x4x2xf32>)
    %1 = call @expected() : () -> tensor<8x4x3x2xf32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0, 1], rhs_batching_dimensions = [1, 0], lhs_contracting_dimensions = [4, 3], rhs_contracting_dimensions = [3, 2]>} : (tensor<8x4x3x3x4xf32>, tensor<4x8x3x4x2xf32>) -> tensor<8x4x3x2xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<8x4x3x2xf32>, tensor<8x4x3x2xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<8x4x3x3x4xf32>, tensor<4x8x3x4x2xf32>) {
    %0 = stablehlo.constant dense<"0x1A31F0BFF04B5EC0DB291FC06608E6C0C04BE83EB03FAB40CDEA0B408F37C63F85E13A3FA267733F51C3643D9393253DEC0805407F4DEBBFB85D9440E4D84ABE94B0DF3F008F763EB65E33C0C94A0440197E50BF35309C3F4E04CFBF7EE9D33E61534B3F050FAC4038C0064046CD35404379E0C0F620003F373CF63DE770D7BF18FD24C0329075C09D8BDA3FCC6EDE3FAE96F23F7CE1473F665A3EC00CE016C09948263F3EFE9740A6388740416C9CC08163DBC023D4C5C02D5D4C3D3B0B1AC025576DC05BBECD4050AD24BFA4104AC0B6B6ED3FF26AEB3FD6A87C40AA1CD3BF5ACD17BFD2F5A73D3CF202C1E8528740D390B940CC714BC02B94C4C09FC98D40DC2589C04B576FC06B020A405EEA4FC09CF0CCBD1453B4BE0F530FBDCF9CB73F4BE74840DDFD69BF8F5E19405B3D104048EBFBBFFA8A9A40AC520140B1E869407CC32CC0920558C01665B23E169719C0EEF3E93FF1DD4EBE3E4494C0681FE8BEF8FF32408136C5BE7E098E3D3F182540DDDB3D3DCFB7D63FB3F72C3FB6CDA8BE9D518D3F69382AC0FBB0FABF188E393F0123A4404611023E13DC95C07D82CFBFA3A68DC04BF7F53FBF1F86BE7EAB5CC04CEAEBBFB9D60C407DED8FBF40E079C0283D91BF9B9133C0ED20903F2C98C0407B4CF73E2AE2B6BFF820234028C1813FC2B4BCBE90BBF33F411C2DC0A4DA3BBF45B820C0B92CC4BF28BBECBF3E5EF5BFE01960BF322DC03F6DBD7F408E4662C0B859F63F40141F40A091D2C0657787401BA9F93E7AB02FC04B259E401DE784C05F3B323E2AC0C4BFEF0A80C052E3493F238A24C030112CC06EECB73F26F01EC0FE318E3FD882CAC0D101BBBF358BE7C039F0DFBFCCF87F40F7EC07BF1DC6924011A5A3C013A53C40D4B58AC0E8DABEC0BA0FE3BEBB389CBF169E44C02E3EF43E4E959ABFA24DAEBF79D042C09A2F5EBF942E133EC6F87A406E9CCD3FE17726408C5586BF964ECC3F4871F53F8C5C653F1813943F88DCC0BF148EDA3F8E6ABEBE40F620403239B74054510A405EA8BABEF04862BF181D57BE490A3BBF1B263C3FD13465C09D63813F7935553F77A596BF4B9012BF576DA43F5D31B1BF55E8173D26DFA0BE70D4CE3F4BEF27C00B9E9CC0EAE5CF40900B01C0B42EF4403B251440003272BFE24DB33F6ADE5EBF020397401B6B9D3F7EFAFCBE47C182C046580DC0926D9FC0777ED14061C5A940B9969EBF6FBAC63F71B048409ABB61406418393FB1FC113F9373C7C0145209BFB1B506C01C54FBBF093C023F5C5A6DC0C801F03F3228ABC0181D4D40BE2FEC4089773540AD2A02BE8BEA1BC0918402401D1C4F40FDE980C04401FDBF5E9BC1C00EFA30BF66B019C0580B5C40BE586AC0319A81C04C701AC04B34D6BFD3109A3FB5C903C0DC932EC0EDB24EBFACCDFC3E2B8A9040CA8478BFFEAD2B40440046C03692BB3F82F391C049CE92C036F498C0CC6F8F3FC1DD9CC0079A2640A2CA6F3FE77FD2BFCA03ABBE26A645C0B4E281C050EB8C3F8BA42340D3E7B8401A99AABFC6B86ABF3E9A2940C9DB49BFE3EB06BF928A6740FD181C40AAF4164005D2803F45129A3F293359C001A92A3F5AA4943F809FA93FF8CD463E8A672840F12F244014ABA33FA52D34406EAD2B40AE0D643EAB26B2BF15D8D5C05F9988C04610CD402EEB423F633E13C1BCE2B03FA628573F2ACF98404C23D8BFAED4AD3F5BE4A03FE5E59ABF8209D5BFE190853F9F516F3DF5CB6E3F6AAED5BFF0E7A6C0A5C9A74090F040408972053F5D0A52C0EEF69A40699C16C0A161803F7C76F0C037960E400AA294BF1EDFB6BE617C5140991CCCBFF29CFA40822D793F8410CC3F793C2DBF8913EA3FEA75C13F6DC8293D06710240CBF9FAC00609DEC0955090BE67714A40B83C83401135D5BF006029402B3A424090223840267123C03A227A4053051440F33D91BF896E55C0C604E4BD95B189C0715958C0E63DBCBF0088E1C03BD78FC0C6689ABFB2A73D409E6030403A423F3E508E2A3E1AD5353F6F47334060A7AEC0F86783C072A061BF82888DC0A156BE40468A58BFB997ADC01560B7402AB60E40B21AD7BF48C56FC0E495583F71C67EC0339E2DC0B8FCBC3F5BD333C0AC9C70BF2B2F27C0B82B27C0028BD0BFB82482406C3021C0E90B57C09E383EC0A9A0BFBFA5CDF8BE65D772BF9CA97640790D833F0052003FAAC6AFBF20EB94BED6C4093FB77C623E65B644C08633CB3EBF6DD040D70307C06C5F9C3C373B8CBF86B420C002FA13C0D6AEADBE0077163FE32BDB3F42238CC0ABC0574088645BBF1F88D53F3E9DEF3FF8E18040883D25400FD901C0F1EA1BC04861DABE9C645EC06DEA40BF003A81BFD8C29AC0C8C93F40EC0EBE40A4750EBE834CD23F057994BF34EF40C0220F2A3F74178BBEF6C5E1BFEC760E40A4AF733F0774B94061940440CC4F34C0BAE846C001FE8340CAF5273FE27564C0C30AD74033DC8DBF63503FBF402728BE86B10D3F2275A940D0CF02BE2165BFBF5D4FFC40612033C0D98A8440F47C98408BC4453FDBA75AC09B91AF3FEAB4B13F842DA0BF1D4357BE99856CC0AC622DC0F76D12405325A53E2E8AC9BF7EAC5AC0370BF5BF3E807DC0FAC737406AA5C8BFA88B48C058A00440DDD5D83FC4BF01BF1E5802C00DBF53C087FA2B40C9C4BEBE60D9633FA2DA323F4C6FF03FD569013F37C34640C66D523FC90200BFA37153C068018C4048F964C020C0B83FC5FDC2BF0F1CC23E38C0AE402DDC5D401E1E10404341A33F55659540EB945AC0803162C078F383C04BA6B23F178852BFD4D34E3F47B587BF7E932C4076A22940465143BF601CF1BFBB25B53F7023B2BE3E040AC0B071313F821E4B40282992C04DE4863F4263243F5E48374011DB27BFF6F8BB40709C4CC02B5E3EC014D10E40071F06BF9715DE4017E5A1BF4CEB6B3F8FBA4ABF8A1C0AC0755A033F40B152BF4AB23AC024A673C0BF17FA3EC4EF393FD5679FC01D449940F6AF1C40BEF362BF1AAD42C0615B54C032AA35C0E4DB07C0F39760BF0EDB2340B15322C0DE178EC0F17353BF13AD733F86A50F4028AC573F66219340800D3BC080801CC0B4B2B940BD31E8BF247F6C406F0776BFD8E722C00F710C4081C94A4019FBCD3F60078D3FCACC993F6D8939C0106E3F403061403D8ACC34C0E1D507C0D52914BFB9E821BFF20D9DBF946E8FC01CBA9140BFCC87C087BE3B400E6DA3BF460D48BFE253803FAF7242BF1508E5BFD44AB54082C11C404BFAECBF34D9DEBF1639863F233EF0BF77C25240521B18C0F3404BC0FAD7AD3F6CC3314090D362C0EA4F72C0D4B29F400FF48840261C7EBF5D96174059E4B03E926F42BEBBE48540235F1740DB6115BFEDBBA5C02AE005C07CBF5C3D6F3F1AC0CF69973E38251A40D792A4403EFB2840FB73A53FCFCC3D3FF08674C0D194B0BFB15D773FBCD80A403E7810BFA196F2BF36DF313BE05B30400DA41B40C4F8AA40F0B1B540B4F9EA3F84C0DCBF26123340D3BECEBF33EB104076315F3D4C381C41C102DFBFFD5B3FBF8534AE404DC1C8C095B02D3F30619840F1C9B340D4EC62405E65A2C04F7E4DBCD44BCA3E1AD3A1C0DB1F4340DB5CCFBF56D5953D6E640D3FFB3187C0CE5498BFA5162CBEAC3C58405E95A9C080FFB7C08BB28EBF41A17EC00AEDA4BED5B35CBFD02FCBBD362CD4BF7F22FC3F2BDC12C07CE8353FC0FD57C08C4C2240C5355B3F31FC38BF58A25BC0BFAEB83E010F8ABFA532FB3D619181C0452819C043C42FC052B02F3E10CB83C06D8BB640EF0182403190BEBF4B9FC1C00F0A5940625D063F397038C02FE798C01984A43F700784C03486073F6F857440ECCD1DBF7492544046948DC06880FD402E9B4EBE89C8AF3FE57804C06D408EC00DE1D3C0D2A879BFCE0F9ABF551035405139E8BE9E063340A372F740D5BF1240859396C04F57DABEBDA4F2BE30EB06BFF410E0BFB48B14C1E8DA29C009CC6640EB3A81BF39B759BFA217BE40642A89C0ABF90CC061F43FC01C9144C043395B3FBE3DAC4040C6A93FDAE36AC08F3C15BFF2831C40829706BF29640A40AD542EBF0FC4453FEA92A73F7FE4743FA40D95BFAE43B33ECF3E13BF8A8E18BF379F2BBFC7FC88C0E343C840495906C08F3100C07785FC3E3474F23F92995E3C0E8B2E401A3C8CBF2965B3BF25FF9940A9F100C01073AEBF8092463F6B7DC63F083D4F40F35F3D3F71D5AF3EA4898DC006A067BF88812040502B81C05A884EBFB3E21FC00ECBF0BEF8D026C0AD57A53EBCF1643FBCD0163E0A02B3409A5F1640FA816D405F84EC3FAACA6E40AA2A8EC0138D0E3F2060C3C04398CDC057519BC0EC6616C05DE5F7C050661E4056A69DBFA9808A40469BC73EF99289C0C6E81DBF26B40BC07E95FCBF0824CBBFE72200C00B01E3BDEC6765BD47C90B405E7F8ABFFC9139C04B7E03C0CA6A7D40FF2A394045A66640A719D3BEB5366E3E79F09CC06BA53D4062C61CBFC567A6BFE806BD3F66E5C43EE03A4CC0BE729ABF96DC96BF74D6B5BF904D21C080FEE83F3A0891BFDD13B5BFBF7989BE565BD7BF70814240791A673F5F49AC3F86EC16C0FB6F14C0647D29BE75D921C0953AD43FA0219FBF2C05D3BFB70404BF0CAF114022895A3FB0DE0AC07E0ED03FA85D5FBF5C25C2C0396361BFED2299BFEF8BCF3ECB72E8BF9A3801C05020B9C0AE5D51C06C9F68403CBD6640DB5908C0291EC5BF8EFC6340978A3DC0BC39BE3FD129433FC81BABBF30BF38C038511A3F3DC39F4027FF48BEEFDD56BFD55EF93FA90A87BFE1F52FC0F6F30B40604E884017CD8ABFF7A7D33FF428D8BF3EC20BBF4887603F35BA233F65E0CFBF62D95F40EF1E8DC0BEF80040A975913FFCE70141B6355D40B4A88DC0204459BE69AFD93F32118FC068DE00BFA7471C40CE2D9EC0D62304BFF1BB043FCFBB95C0F29F88C082F056C0C2477940786112409968D7C0E9EABBBF695A27C0C22C4B406047D1BC96FC7840A34BD73F1DDCB0403A6634C00F992D3F6A8653BFDD2D2240A6E28A40A1A1C8BFEA8BCABF013CF03FD5CC583FE044B3C07270A7BEDA3FA33FCC8697400074DBBFE87832BEB74A36C0322AB2BFB82376C0076489C0D2F11CC02DEF563E9662DD3FFE397D40935A344072213EC0978488C0EB90563EF56787C0268C2CC0E3740BC02BAB3F40A0172A3FF7710640D11E63BFA4A1914052D320C08DCA58BE580A89BE96AF953F522050C040D8C2C07FA977BFB6E9684042C212BF27E238C028E0B5C02E9DEC3F3994B13FC65DE4408ECC56C0E649F33E3B9924BFC80BB6C0B84A6EBF013B3F40B35EFE3F89C5274053440240276A2EBF4F3187C0E94A063FE880F23D0FF1043F334604402B45B13F470AD53E061B183E7D1288C0F07D16C0A34E94BF05DEA63F9ABA1DC076E89C3F6694A4BFA2003EC059E93BC09D578B4047B2DFBEE23136C0E0A2D1BE20A708C04064E9401DEE593F2DB107BFE2F109BFBE5A0CC0D2BF79C04D724D400957FFBF883E4B404602E6BFF7D0453F0F7193C003FD7240935B09C01B4BE53D9E34D33F6570BC3F80A62640D4D71B407DA9CFC0CCB1B4C09055FEBFEC9681C0BC0F953FCD7CB53FA5D088BFB7175AC032E0C640211709BF36CBDABEAE3CC4BF08CE8840098CC3BFCC95A8BF2A872040E26E79C0416C8E3F84501340F30397400AB281C0094D81C0292E863D4D9885C0E4868BBD3AD0623FD1E1103D5A6A7EC006ADD5BEC61C4CC0DA0EAA3F9A4C6DBF81323BBFE7AF4E406AB1C3BD87AF80C028AABB40711B35BF1F85303F37271FC06F5ACEC06A25D33F337BA1BC7636B2BF4C6582407041A63EE0DF5DBF65D7DE3FDB567C402F1C98BFC297923FBDECC03FD8F3D83FAF23953CBA9504401A52A63F27D5CBC0FE8630404076284080178340529DB0BF75669C3F3C55B9BF6C77D9BF608AB240258A0A3FFCF503C05A5129BF4CAA25C0D37F233D71F170BF7BAC9FBF178ACB4066D7A73FE564C23E7DD6B0C0DDEB32C0ECA092C0720E764010BB5DBFCB60B9C0C36D00C017E605402C7585BF509F1CC0BA08D4BF28A2FB3EB0DCDCBF6CDA54BE955F82C09D6DC43F9B3D20C0E6E59A40F359A13FBB4813BE52891BBF8FCCECBFBCD3FBBFE1E47540A6AC863F584D85BF407AEABEE9359EBD5A116EBFA2C067C077731F409765343FBEB63E40E97101C0EEC1F83E0B617CBF8DDA1A400C457DBF354406403F6907C13B2A40BF284B2E4083F13EC00C76EDBF9437923D68111E40809A8BC04971C540E62159C04FFC80BE4224C9BEAC0E81BF3D9A61C09B0B3EC08026A33FDA06233FF989194032B76A400056C93F5940F93F8DE2CBBFDE2E30C0EFE8344019ECA23FD38CC0BF4416FBBF08737ABEF5F972C03EB30DC1648A59C07176A23FE50E6540A8CD813FC0C780C0D9EB4ABF2D77113FFBFBEA3F567B3A401317873F488C2DC08D059EBF9E5FC13F987B11BD1D8CF2BF426D0E4074CE903B5C024ABF082DA83FE4A075406C1A2A40400DF1C0870723BF2DEAEF3A400E393F4C65DB3F"> : tensor<8x4x3x3x4xf32>
    %1 = stablehlo.constant dense<"0xAF8F9FBFA5C5813F54C76BC07B4328BF14FF0CC06FF666C09AC176C081BB5AC0EDEB144005B726BFE3081540E76F2EBE4C2744C0563114C0AB67AC3F1AC459BF3C9584C0B5BEA4C0F7670B40BCDBDF3F86ECB1BF45E5BEBF2878384020511F4082864EC0689123C0F210FFC0D1B0C63F5F1201C0340E213F1CD291408D2AA03F2588E43ED2D045401D0C8D40D995793FE9FB7BC027880840373DB43ED0A4CDBF8F7C69C0E32E91BF68F557C00EAFEF3D5442BA4074759FBB8E8ECBBF26207ABF17EF5FC0AC495DC05CB6E6BE6C2C233FA43730BC98A3C73F5175933FE60EEABF33A0A63FCF1BCA40E15401404FDF8ABE6C7A72BF859B7B40815D36407A2544C0F4C958C0FBBE874028DC8FC0F97938BF437DF23F5F95E5407C7021C0D92A683EE4900BC006513A404BE61B3F00B5CE40E1A055BF91D260BEEADDBC3F8CB618C0B77A65C0FEBDF7BFE5C0A53F831924401DF8463F1D61B2BF0FABC4C06A4D4240407D0FC0D4FA484002A36F40F9EB2740D14B41BF64738F3F52DCB5BF7D242740AB23CBC05C88BABF7920413F77943B40035724BE32F041400451C5BFB11C3EC015BBABC0AA24C9BF3C805DBFC987C040CC0BB140B0A63E40F8716E3F7F37BBC049348A3F72EB6D3F98E3E0BF8A324D3F78EB1FC03728E23FD58E73BF8C8F2B403DBE1B4072BD6F3F77CE7E403FA71F40A6FC8F407B6A0AC08499F8BC3B473A407F422340F5472B3F196F1241CC58DABF1A9C2EBFEB085140F23A9540D961AA3F2C1AA340A59536C0455490BCE01AFC3FB13FD13EF8A1453FE5A1803F48925C4001B5544015912540864D9AC093EB73BF6A54583FE1EE3140AE9A50408B0D8E4077AB97C0BF0E664037A6A0BFE83DA1C0ACB17E3F5D7A4FC02E4FE4BEE8691FBFB1934B40CC4BAFC0A0426FC07A6825BFD047B9407020003F284E0F40403C5FC07C1BDDBF0770653F09D13540B4D40CC099185CBFC41DC140A438AB400B9207C0C6D15FC08A63F6C07633BCBE23094E3F3E3B6540A172B9C0816CC2BF1FFC523FE93F1341290AAA405D11CB40872C1240E177CEBE0A03A4403CB3894029C929C00C70A8C0B9F360C06CA3B6BF5EC3F13FB94B86BE6EE4944081A8E4401087254070241640FDBB6D40963865C004703540525415C0A53DADBE9D302CC03BA115C09C4D8DC03B2300BF79D61840853D09C0845A47C01128103E443ACAC0580EAC3F579009C083C197BFFD65F9BF37C37DC0FFF22C3F8B59B740C36A35408F0DD03F5F0F2CC0CA5C2E40094E5F40BCAB54C0E3543FC0F332C7BFF20BE1BF3EA35BBFBB85F13E2D2963C02989FFBF98B46CBF81BFFAC0CCDD6D40FC6DB5BF93D8AB3E7333A240E43842C0198A1F4053683FBF4DBD44C0F535B6401150203FD46FDEBFD10B5D3F870A96C0E30DE4BFCFD223BF68674440AC867EBE93B907C0AB9DA33E961A03C0D373A0C0997EB540954C45C0ABF2A73FEBEDC03FD15C27BF8A7DE1BE44B009BF4B192AC0C7655240EA256240F0B523C0F31B07C0185BE5C06285AF3E5D250DC00ABD6CBD8CBAA23F3F4990406B6EEABDA37A31BF220C0440F09CA4C06E1FE4BEEA80DF3E0FD01DC009DA22C0811D7CBEFD643ABFA8D1C13D438331BF29E433C0C0DFC03E3F7BD1BFC55659BFD22B55C0223608C034EB9940BEA0C2BF11D50F3F116282C0F1C17F402B599A3FA0BA113DCF8BE33FB2212340DF8B45BF302C6740906A033F495E1040B316C73FC8324C402C295740437F78C05EDF0C40462108C08A243F3EA9AD07C0B91534400BDA3440E639B0C07C67C0BF0991ED3DF2D4CA40ABBE0AC06FF9E6BD392A904088EA6540D305D7BFEDC06140C452C340EFEEB53F3B5403C0036DFFBF76E3F2402422B4C036BCF33F5F9397C06127B9BE4C3A14BF37944840B2E2C73F8B4464406CF8AEBF47E39F3E1207A4BF66888040D7F75240850CB7BF9F9B90401EA2984084C64D3E696D1840B548FF3FD4A580BFB9C580BF8AEC7240AC9EA5C0A92EB1BDEAC78D401A6ED63E0E28973F028FF13F35B88AC0502885C0D24A4C3F542213C0BCBA413BF18DBEBFAD27A0BEE335AF3F9E644BC0874110C0D980AE3E197EBEBF26092C4082C616402381AA3F80F52C3F22BDD6C0BB4F8340095D524051DCA4C09D4EC2BD72F0DC40ED7F43408EDFAD40D99CC5BE4ADF8DBD7A34A33EF77080BFD7955D3E5A386EC0A2F10A4152AC8FBF67D1894087AB214094F40D40130366BFE580DEBE3E2662C08F6D0740C070DFBF33E0C5BF705FDFBDFE6D1D3EE0D5B0BF8A7556BE5791923FE7289540E8A6ADBF93E62C3C3CB7B8404DA72B40C6B104C1A758A5BE0AB6C73F9C2101BF7F85D93F26D39C3F4906A13F5BEA29C0F1B33B405A5CD8BE684315BFF2A0DFBE43048B40D59C2740266B40403B9710401780A2C09610B7BF1F49993F96D3C0BCB18D12C0912046BE95479B3F6CDE2CBF740C2CC0B39A9A3E2C11C240949051C0E39913BE5BF47040857005C0A512113F42572D4048DE993FD8F45A3F067ECC40BD37B13E7666B53E2A8F2CBF37E562C09B918E3FB07A473FE4B47AC0818BF7BFF2DE3A401F307B408426553F531BD3C01D8FCA3E53AE35402021DE3F1B5684C076D8803F99B6C6BFA6B8AFC0F83D0E40EBD28A40D99091BFFF7F8DBF6CEE38BFB92D91BF12EC5BC01B59D03FA0D8D4C0E78C5940BECAC3C041A329BF9832CE3F3641BEBF1A5E97BFEAA7C5BF956E1E40E2D45340B92DA3C0657D0FC1D5D182408D5C3DC09F4164C0D8FCEB3FA677BDBC5B948F3F71DFB03FF05A1D40775616BEA6DC74407AB70CC0719E944067D46E3F0674F5BE177A3E3FDEBCB93F71CA9140F5E6D740A9601B40FAE0C03DB18208402278E83DAF715F408EFF803F80D8993D7563CF40B4B00DBF00A02240E45DCBBF236592402DC367C0DB8F9AC0DE01EFC002964FBFD4F84640966284C010668CC0E98BC13EF3F051409A7641C0C14CC5BFF4CCBBBFBDDB843E07E5914008C0D2BFE92A94404075B94011AC70C06A3E584087804CC1FCDA784059109640308E5F3E081CD13E432E35405D7E2B3F1D9571407CA440407301EBBFED33A1BF2A0175C06F7A6E3E2597F63F3FB2A5BE82A188C0141FE7404578A53FFD3286C0F3F4023F87B1B440005111BF28D206403E650FC004ED813E5AD833BF8470B83E09F93A4009718CC033516940B79B843EFF26E940BFB364C0A2898CBF069C11BDF9F3AD3F7D64C9BFD0542B40A4F196BF2E6938C0E23B8EBFB4B932BE741FA83F19E178C075DDBA3EB310C8C0694265C0CFF586BF157512409DFD1F3F7870B540FBD16C407B400340F273F0BFBD2F1440514C583FB42690C09644B63FFBA6473FDBC4B240F58CEFBF5EC9704033E8D63D336A7BBFAEB5D03E5CDCFC3F0391EFBFC86196C0C22C6CBF50C91640F7B83F40C5C1C9BF8F46374037B7E5BFD2DE4D3F343C8BC093A9B43E3786123F38DE19C078950FC0BF5E623F2D5E8D40AA280BBF6E820D40C8A5B63E88A918402E879BBF815D7FC03B0F1040D815A2C096D930C0A1BC13C16865D43E6FD257C08F3E39BFDDFE3740F88D0740C635B140691EA5BFBD881140536AEDBFCFA9004088A8BF3FF8924CC0C364ABBFA76720C096FA0E40A99AD33F1DC1A7407C61803FF6E2EEBFB04891C001CEA1BF7141893F7B1534C03FD48A3F2E43A23EF5D122C0F4E33CC0295F2B3FF6D9AD3F57EF8DC01F7B75C071D301C0C17A9DBF0446B83FA5C3F73F37D849BE3A96D040F0A49EC05109BDC0F3ED7BBE3C0898406CCD36C08C8C813FDA081BBFF67194BF864478BF2F4F0340AE4194BFF32BB63FBF6BE3C01F268FBF77948CC02EF42B40AFF87FC09A0CC740C93714409C94D0BE1A9EC4BFA45FDC3F23503C3FC02728BF471F60C05648ED3F834D2AC0EBA4A83FB06C92BFEC7DCCC059AE26BDA6D5FEBF84B55740CF8DD8BF2C4B28C0408CDDBF34B9AA3EFAB3A03FA433A140BAD511BEAF796340DB38823FC1A0993F93D8C03F4F957BBF28DF05BE7655743E2954094051F397C06C3579BFE2F004403A8B56408C849F4006FFB63FE99A4E40A542CDC0E68119C07D05D53FA32BA23F32C1FEBFFAD71CC00808CEBE10D90DBF1F51EE3E0DDDBCBFADB83F3CDBD5973FF3302A408BB36C401902D13F2A9DE43E2CB8F1BEE96B55C00AC89A3F37B6114083BD69401F56823E0BA419C070CFF9BF33DB6BC01DDDEFBF134FAC3EB37DA73E4EA279408F6A1D3FD5E5A4C0732C653E942B3A40320B114059ECA9BDD0C933C0D5DE3AC0FEE4B840D0F37540913D5F3CBD38A3BF18636E40D811EA3FAAF897BF3A0B07BED5BC35405941BD3D2E2B8FBF3B060E3E"> : tensor<4x8x3x4x2xf32>
    return %0, %1 : tensor<8x4x3x3x4xf32>, tensor<4x8x3x4x2xf32>
  }
  func.func private @expected() -> tensor<8x4x3x2xf32> {
    %0 = stablehlo.constant dense<"0xF14561422212C241E1A3A1410D0B153FBEE444C212DCC1C008900CC1916D634100BE8BC1083905429D469F4045C071C26096A041A4BFC7C1EFB0164129249B413C90854189FB2D42B1487AC03BF11DC268D7F441642815C1361DA1C16ACA8542836FD1C1921D7C40BAA1D0C12D72B4BED51946C1460B1D417052B1C187D11EBF189E0CC2015812C0394C00C2CBB62942F0A8D44150B657C28E981A400B2B2DC2D8959040E4D4ACC2994705C1324F613E32E2FCC1D04B0041BB133240E02273C0A3129BC105F960C20C76174299BA0142E4C06AC23BD17141205849422E8C8A41F7C0C8C041D70F42AA5A84C0672140C2D78D9DC14FA0AC423D8C3DC093FA3041C7B6BBBE7F62FFC157BE4041CD90DF3F5352EAC16E8E48C1C00B294160F71442463095C1875F1942893960415A214B4186311D424AA30D41A6A86741BCC647418F841641373C25426F5B5EC0C5C17E41BAA82942CBD0CAC14113F641909A68C03D708042C49DB4C1EA278BC118470AC1BB7F1DC19C8018C29B8AEDC1E26C66C2F646C83E164166422EE57AC2061DA6C1CE5E36C0E7B799C01D461D41A40EA0C0420B1B42AC51EFC10F2F9CC00FB4C93EA6FBE5C1E41A8DC12083F53DBBD736420FEC3EC177A719C1895833426BD3F9412ADE864207A293C1886B1EC2AF0DF0C1C8CB7241EEF8C9BEAE1C4E4166D64041BF9C01C284EC93C0D49561C2E5D21CC259FBDFC11F7F4CC058F02A418F653D42F1457FC0ECDF0DC0E60725417689D2C09AAECDBF8EC32D41BDD4AC41101E57C2ACB1CFC1BEEA3AC1BBD3AF3FB74A4E42A14364C218D0253FC1B19EC1B43C9B40A30504C28B120BC2EEF79F41176364C1923C3DC1529718C170F401C19930F640415B1F416B096EC10AB89C415705A640327487C1590494C2DD1FF6412C2E4742C23F9241844B8FC05DA62CC15B0578C177658FC20175F941715289414D9E17C29304B2418AD9344202EE1C4123205E429DBC66C28373CAC14C910EBE3CF03BC1C9ECBB403619A9C18056114104F9ED41A3DC7E40BEFF36C2643EC1C16DF0FF40CFFFB3BE6400BB41BE11154178E65541"> : tensor<8x4x3x2xf32>
    return %0 : tensor<8x4x3x2xf32>
  }
}

