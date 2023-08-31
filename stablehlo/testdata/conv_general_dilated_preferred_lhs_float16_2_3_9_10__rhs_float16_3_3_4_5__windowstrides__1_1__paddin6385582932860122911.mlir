// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) -> tensor<2x3x6x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf32>, tensor<2x3x6x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) {
    %0 = stablehlo.constant dense<"0x48C546C11444A54217BA4846DE43283F8643F53E31397B3FFA2B613D57C0C73BFB45CB4014C270BEBB43CFBF29C12F451142683927C369C41BBF803B1D3E243EBF4089C239BD63AE7A38603DABB766BC0AC049314DC16AC2C83F5BBC95C25BC47440B7B82143293C303604415AC013415C41364643C078C2EE3D67BEC4C342C339BA9AB750BCB7BB373F894582408FBFD4BA114063C37DC04733E1414BC2EF45D1C65742F2C10AC0253A5D3F9F44083DE3BEEA4076BDA043C6AFC73614C20E3916C580C14E399FC1AEB6E94197B8A83AB8C0F3BD7945B2ABA1BB4ABC413D0FC86542DB3A5C4430BD32BB2EBDD93FD4B64B4407C052C0A23FDA409CBD39BE03C0E94231B727B896B88928A43F733D8EBCB6466CC34FC540B8D0C6B33F443135B77C43B83B23B350C188C429323EC6DF3EB03521A8DBC0D242FE44083007422FC1C9C172AAD73544BEB8BDF1C423C39AB2CD444BC1FEC498C4CA39DEB3C940BF459CC013C54F448DBDA0B6463494C2E54369C0B1353A393132D04183C317BA1F47D5402AC567B0F0BED540DDC028BA22C407C4EE4079AAD7424FC1FFB4573F3242604007425B3645C44C43E33FB1456D402C44A5402AC4982CDC3D9B43E8C22DC0A8B261C5C536263F96C448BD934653B8303E4F3893416C38DBB619B878C498C247C3822EA73FAFAE89B26BBC553510C358B821BA8C3744C606C032C40F3A37BE7DBA7B3997B78F3F863C2A45E0C4ACC047C082C4ECB853C16444F84152C3E43E623F2444FAB72B462ABD22BCDAC2902CE9409DC0DBBF3528DBBF5040FCB9733F2444164320BD92C258C4742982B28ABF72BE60C4C13F8AC2303C663C59C65EBEC145993FC440EDBE92B451BBE43544B2E53DD3BA63BFEEBD393E26B31F3ADEBFCC3C123ED2B881B22E406DC044C5F5C411465F44A43C7B403144B2C1C041DD4146C18DBE584198C37DC55CC22D44E5B18DC282BC004126BFAD3C98BC5F3CFA396940FA4539C511B628474A47AC418442F23624C0A93F09C15F434A43684463BC153C253CC3BB3FC0143F0740544059412BC104C2EB43923E8436E43F81BAD23F7841D0B0A9C06C3236B93FC4932D3C44453E01C6A2C20A3F7C3DBBBD2B3FF9C0C1C267452ABF50B2B0C1EE3BB244CDC0B8C047C1284692C4043405C2D14395C055A95DC253408C3DEEC19C3429312AC090BCA0BD22C043401CC43F3B163CDCC4B3C353C12CB3713421428DBE36BFB4BF2DB00FBD41413E42C9BE4B4439BACFBE82B96FC2CF40F643BCC56CB85344ACC437B6F844613D85449E3898C6F6442BC35CBE48C052C17BC46841D83588446944DCB8463C8D4126458EAB3B435E3CBFC431462DC1D5BD26BD763867C4C1BD35C3693F9E3C93C55BC3D7309AC1FBB51BBBBABE34B7A5C3864493C4B6C5FC35F240B1419DBC7F44A3C3D2B69D3F013A49C511B8ED401EC3DD44D6B6EAC2F9C191467439E543C3C2ABC0B0429934AC29F0B93EC04841E2C6264125BFE741683B573C7A3C3645F5BF39C4"> : tensor<2x3x9x10xf16>
    %1 = stablehlo.constant dense<"0x54395A3C61C3A2B150415F37E7C5DA3401C3353928413046AF36F0302436A7BBCF40E33F5E347FC120BFF7BFB6C1F0B548BE49BFD3BD7B442430B6BE154477AF0EBED4BF3BB1ABC6BDBD13405740BDC18D3E41C09A473A3C74C33CBFA0C0FA35DFBC75BF92411F427D4004C104BF11BCBC40FDC2A338F4BFC540C1B7FB423DBF4DBDFAB7CCBC5DC3F1C5573C2BC053BC18C558BE6F4566BB003EBBC6CC4468C6CEC4B34030B01BB81046F9C254BC8C359C3B13C66D451940CB3DCC3F3B45B0C114B219B878481C4380423BB9D0BC6AC0AA431D32F841A540603A603D012FC14160B048C409BD523DB042EA40263CDAB992C2EAC0662EBE3954C293C3A13EE0B352C037447EC14143FB4461435144E52C37C27A4020BD37C30DACBFC7973A02BDBFB10A309DC236BEF7C1263FFC36D83E56C7EBC1E94226BB85BB9336034418BC29C40C34E4447BBADC44B6BF124309B95EBE98BC20B9EAC0C9B5EABCC7C3E234ABC40A4282BB9FBE"> : tensor<3x3x4x5xf16>
    return %0, %1 : tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xf32> {
    %0 = stablehlo.constant dense<"0xD04403C33E5F9D415843E5C026A97A41E4E7934163A95741971B09427ED119C1A8030AC2758EB7419ABB834150C747C1625A9D41743394C19661B4C2B04394C27A1196C1A4858C41F8622442864C884100E1774230620F427D3C334304425042966E95C29D9622420F6ACBC2C2B7BDC233FF11C19A1D21429C2DC042944F06C2900F59421F875A42B6233FC2D3D68FC254F1944180DB27BFBAD6B3C205C29CC22E6B3442165FB3410206F7C1E2190B42B8F2C83EFCBD7F418B5E0FC2EC8D8742F614734262C9E142E08FE342846AA141411E6CC2681DE4C1B6F6C94147B878C15418464206408942E47357418E303AC2491415C28E7BE5C196FD4F424AFD33C287D501C17BFB90C12721274386EC5EC1DE4180C2F5AD37C2011D17C3522705C178B227C1A9B21141C8E7B2C16EA987C2F02E80C23C335AC2D8B4F2C0569E09C3721C7AC23BC81CC2B018CF425C2DD7C24FE786412F3AACC1C808B4C1540DCEC278A9CDC1024DBE424EADB94220B620C1BFB701425DC1114295F91D42CC0883421F05A6C2D97E11C2D8F2164254BF92C2837DACC1EB6C3A423B34B5C2C259244268DD0B424E3200C270DD4C40CDEB1CC2D0B3B1C2FDA807C25CE483C1C2AD974274CFDBC13AD73541B3ECA242427790C268E927C12E2555C12646FE40F85119C2F552DEC2DCA51E42A0507341CEAA9741376FCAC29D11834248EA9F42A8B956C292361842B1C58A41B41DCA42A2CDCFC2006110BEF0183742F40760415B202942D36A8C4219405FC2581092428D9DC0C134EE95C2227899C2B69CAB42D3A6CEC086C5C840D5959841380FA5C2A26DBF42222874C2A0EA83C2EE864C42D8F90F41C4044942C482B0C1C087FDBFD238A7C15C952DC237DA1E42EA642BC2E4BF3C42F469DFC238B70AC0A24282C2F65A02C3A11797C2DFDE24C20E3748430237A241DDB7F7C283124E41D03A8E3F792F6A42285BDE3FCE774BC19A1C8441989404C3963A3F421E1884C2B0F5B4419087A8C2445AE7C2EF3101C328022D41BAA893C26895C2C1BA642FC2BA72534272A58E415C013142D834A340DE788341063859C2B8D7FC3F4827A7429CD5EB42B11A8341D4EC78C2525DF1C1A2B274C2680AFEC128059AC080860BC1D88C83C27E9C17C26FBD3F42BB268B41D0E3F1C1BB53AB4249E7C141590266C24A669E4289B79D428C9123C1710BE8C2706FDE41E47FB8C1"> : tensor<2x3x6x6xf32>
    return %0 : tensor<2x3x6x6xf32>
  }
}

