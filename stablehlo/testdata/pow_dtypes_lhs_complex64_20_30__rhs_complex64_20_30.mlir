// RUN-DISABLED(#1278): stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x30xcomplex<f32>>
    %2 = stablehlo.power %0#0, %0#1 : tensor<20x30xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x79892840397123C03721B94033A21FC09C19D4BFA2943640D89F8D3FAFCF8EC0E9E6AAC04CD305C093F1F8403F4ED6BF3A6DCFC0F8C0A64082F87340EB3806C1B3769B40F8202440609D0F3FE9A7F03FE75E0241196B65C088BA81C09A65DFBE615FA7BDBB2A9C3F8D382BBFF5725BBF6CBD0340B354903F6AD34E402341793FF03DC33E244D1DC06C78E4C0480556C0DAF6CAC0751B63403597584046D909BF4773543F8B397EBFD954C53FFED04DC0BC071840653B87BDC05F6FC0FDC4DA3E86ACD6BF51296E3F7776F13F3296C2C0DE4670C073E64B4041E912C032825F3F3772DDBFED8812C0FEA8DB3F04B33DC05B8C3EBE3218B3C0BF3E2DBF0A540740D1BF80C0EACCD4BCA7B302BF788B7640688D87BF7329A1C0FFFD853F38CC103F463E9DC0BCCC47403EAAF83FB326C7C0784DCD40E61C48BE8A4AB4BFFD740A3F60749EC04D8402BFD15C38C06BFD8DBFADC1C5BFF3E774BEF5A901408BD9CDC0E22B7BC0FB2056BE4221893FE7915B40D7DA5BBFB18D0840BB81B0C0E65B1B406442D63FE3E4913F07AE06401DE072405D31AB403AEE7E3F8ED166BF4FBB2EC077CFC63D622ECC3E6C6B9F3F0E7D2A403CABA7BF4F925CC0B4B88AC07DB325C0B2F5CD40188A51BF820532C0017A233F01C499BE6C27F53F350882C062AEFD3E29CF1FC04F423C3F2982BDC038FE9ABF644469C04DE2053FA01E8CBF604FAF3FAC02104083629B4089C306BFECB0E9BFDCAD93BE94DA0CC0603261BF2F1511406750B23E010054C0B2BBD1BFEE583F3F9A0B9D3E5EAD3440C4BD41C0CF7E8040BEE024C02249ABC0F597DBBF7DAA11C039A09BC0B2BF2AC089337FBF089538C018F291402352593F616840C0861A9CC00F29E4C0F7FFE7C057658A3F973C533FFD8D9340EE55BCC031240A403DBE3C40A06CA93F8CEDAF3F81D35CC069C0B2C0D886693FF1CA0DC073102F409C63B9BE483E9740AD28853FDEBB153FF5DC05C0C7ABF63FB5E4113FF3EEB63D86279A408997F5BF270760C03D0808C01FDC74C0D16984405027BD3EDA44E53E8BD5EA4025E71840196A74BF125FC9C03CADD53C614213BECF7C2E406F1D17BFF85A2F40BA5205C062B88FBFDB1B1FC0299EE23F3E755C406DC168BF1EB569BF2BEB95C080F4CF3FEC5E174054DD114024958EBE5F2B9840155E8BC0DE9DD64014389D3F8E8DF13F2DEA263F2B7518C0051D9DC06B8D33402AE21DC0DD35AC3FFFFF07407C225B4022D5833F9DA3673F4B9E264099A4803FD3DA253F9F48463F18FF2B3F32EE56402E79CEBF85CFCF3F8AF0A73F71102BC07EB409C0915825C00E44B840EFE60940DE6B74C08352653B525B51C048866A408069433BEBA6673DDF56703F308B9F40369CB63FD7DB9B3F4640B13FD86397409574F23F8EC422C02DB3044078647BBE130683403C2B28407A450D4037F71F40CE56563EE0296D40DDEBE43FFAEDAF3EB6D11B3F67E6113FE8600140F3995040D6B88540393AAA3F70A50140EAD96D3E38254040AA14F9BEEC6785BF345C1FC0E4768C40C15BBFBFACF8A83F644F0F40D58A99C00B8E2FBF6E0D11C07E0ADF3FA6B5D23DBEBCD7409FA715BF797E0EC0F43BB43FBFFE03C1A1B4A5C08449FEBFDAAB234091910FC08A8090BEEF6C69BF02777FC05081784094A364C001C1E23F785CEBBFF03248C00B3A26C079808AC00EB518405D7D2940E70D24400CCB8A4026EFAA40A4F194BE949D603D2D0152C015B49440AD8F71C094AD893F048E42403C7D88C00D9BD1BFC8EA5E40AC479BC0E558A3BF54B4784098F80D3FA8205D405377FCBE722482C091A83B3E1BA3A5401313BC3E73040B41C6AD1FC11501FD3FCA184740FD2A833F4F1E6A403F8D5B4073FDFBBFDBE7E43FA2B90740A13B75C0F8980F40778A0A40A6D6D43E111C153FBD09CBC0142B1940D837583FE4007E40D833F23F20DD7AC06C570FC0998017404D479EC031CD82C0B462BCBF9EB0AEBFF802693F301867BEB8030CC0E8F51840E0F938C0EB7D933E12CD0C3F84FD29C076937940A54636406B2750C0880DB13FD209FD3E602DD0BFD841093FC4742A406B804740D137D23FAA6FA3BF2FED66BEB0E3E43E52B4D03F4C9BAE3F2E2186BFE3EF0240ED9FA43FB5DAD2BFC5EAA9C08990883EF011DB3F422A5440B1C44040254915BF0981CFBFB01E9CC0F5A4604048627ABFBA27BDBF51D72AC025F9BEC059920D40750E8140E1C95C40F5BA243E9FA11AC04EF656403BA4AE401164FDBF13CE3EBE84C8D13D992AB43FFB141F40905202C01444793F07954AC083E523C0D7F992C08A1CFC3F1A48133F8D272CBF420589BFE50036C04676A64078E1B73FD0F905400324A5405AB124C06AEFAF4000BBC93F8E092640F2F13DC05B86993F1E382E401149B73F8D7B8AC0D957DABFB53632C01C8536C05DFCB7C06A56B03F66ECA0C065EAFFBE0A25D8BDC2CD82BD122C6FC02BD095C0DCD1AB3DBDF29CC0801A8ABF27859C40FF131740A53F71404186D6405C575E40132430C00188BE3F402E9CC0DF1A73BE9913B6BFEEE2ADBEC07CFEC0C37E7A3FD61061403E8638403B5A323F237F87BF2F8692BD27DA61403BEDCDC094842EC01B2DEBBFA1B32D3F242DC84056329F40E855B63F64AFC13D19C33240947966C036026740E358AF3E036A443E21023EBF00EA07411FBFD8BF596E8EC04A6553C019D043C0174DBE3E5A0F024083F25C3F661D084055B9D5BD5AC193403F2C763FFED36D4012905840828DECBFF2361DC0857C58C0EF8D88BF473D3140AFB003C0D751A24053D8DF40DD01894085D1BD3FC7F10A3F88E8403F1B31BABE510D96BF4F7EBA4037FDB2407E6EF7BFDAF9E63E4EEB3DC011B94940770F9E4040943FBF5B893C40F35169C088233840190D89C0B6931640D3C7723F94F05D40ABA3B83F5AE53C40241D663FC546CE3F8570DDBFBFEF0C40C0F81DC0993384BEC9C3C13ECB73FABE2E7C31C0757A78BF6DE705C0C00E3C40B2572A40FAA092C067A61EC08BD30040553B0CC045469A3D2506D4BF11725C3F40CD0FC0A68F653F51E61DC0F1E04D3F3E089F402C23C13FE24D5CBFB494413F086E25405AE4EBBF8A5A10405ADE4F40A0A994C0145A4F3F4F255C40D35FE93F16FBEFBE6D46D4BE1661AD3FA4A615C0F49E18401872A4BF2BF4703F46757840A38F344013B4B03F089C90C07267923F4B18DFBF432D1FC089F702409F56E23F4C71CFBE552724401AD6D6BF8A8F003FDDB565BE0485FEBFFEF73F3FAD09C83EB0D425C03CB8113FBB5E23BE6C718D409D23AEC0CFBFACC0926C0940A98F76C0C03748C0B8CAF93E6143AD400E2746404FDC953F4B4B52BF5C0516BED9ED25C0EDCB1D3EA39A04409BA9353EBDF3923F7099B9BFEEDBE0BF2C383C4071A688C0B72585C05320FFC0AD172A3FF3E14540ED1136C06CBA8EC0CEF59640655663BDFFB8603F57F4A4BDC1161FC07044253FD97BD9BE92D2B2BF11BC55C08DB0E9BF205EB0BE241323BF9F45BD3F22E16540CC1C4A40F7ADD4BF9CD61B40FAE4D3409920DC403C790BBF02F40CBD6C7FB9BF7689A43F3E7F29C0838784C0032513C013FEE9BF22C6853F0BB89B40F7B949BF4071C73FDF700140101B42C007BC69C0162531C09A68233E11EA853FBC4D39BFD2ABA440A6459DBFB92D89C00EAE68BFE5979CC0D398D33FD7AF0C40969691BF63BFEF404DFA36C0D5B7B2BFF0C0633F221768BF04C308C059494C3EBEDED8BE78915140EEFAAD3FF6E30440C324ACC08F7C594054AFEE3FF0AC8ABFC9D9AE40B02DF1BFA58FBCC012E92C4092CD02C05E852840E276C33FF9966AC005843BBFA3F448C0E71AFFBD728FC3BEDDA4F4BFD00F44406DD181C08BF5AE409D52C0BF7C8B7D40EB9324402A8DCD3FF3D649C02A0BE8BF2D3A6CC08BDB0BC0006F9A3FE35102BFF6973DC03644983FB2B2E6C0CADC60C0DF238ABF15BBDD3E35755340C6E3A8BFB70191BE7DE3D7BF2F4628C01B750D3F7830014051229840D17306C0B4D45540EFA6C93FEB6A82BF63361C40DF3583C0826E883F4C7058BF9A7E45C09CCF7D405978513E295E8AC035EA243F26AE6B401F079540EF1FC5BFEA308040325A48C0EE53BCBFE1DA85C06D7C79C0DC6C67405EB4BE3F86DE82BEAECE254098042BC054C30740ABC26C3F3AA28BC0740EC03F8FC920407EA6C9BFA19A60BE17F5A73ED3F739C0C39BBB3FEA580440867183402961FD3F9EBB6B3FC7007340182FFBBFB88A31C06D77D5C0E9F5B6402EDE65BF8DD12FBEEC3FA94075171040EED309BF4C56F5BF3F0E01C0F91B1AC047EC09C0F0553640EF67353F7C851A3FB887E3BF078307C06E6883402C725A408655843F90E6A1BF3C72CCBF50FC2040857EAB3EA64369BF7CB960C0BCC8673E02498BBFE1A87440E99767C0BD4446C06DDC55C0C70415C0E9CC9D3DCD099B3F79CAB1C00774CA3EC2158BBF93B8B8BEE29C3B402E604DBF808ECABFD8CFB93FC11D9CBFC06268C08AB714C0342EA0BF528A5DC0373C284076A7DB3FD8CE62C04ADFB7404BC9A0C04BECF93EB4CC4FBF848C5A4044BC85C00D115BC0C9DE84C0A00348BF1A4697C095660EC054F6E2BD54B97840CE8AA1C0C85EC93F3269B03FB58BD8BF0EDE03407D0CD0C03A3D61BFBEFD80BF30164F400D9512C0C566C2BF309A76C0DB175640E35418BF985A26406F50F23F0664ABC0C2D35F3EDFB83240316F7940658E14C0936783C0DB8D1E40FF7892C06A9B0FC07FA92AC0BF8AECBEE019313F9AEEC93F7ED279C02C9F2A40BB8EBE40A5CF81BE2C02863DCB1EE43FA98377C0871E38408380A3C0A61F0F407F00AE3F5A54A8C0896395BF10DBF2BFD37004C04FBBB5BF7A97723F04C216C0EC2282C022D08340912F92BF48FB98BC448B77C0E4CA22C0C489AFBEF59E4EC0A2D3804065D6E0BF49B05540D414E5BF3CE51A40A46440BE1870643E5EBE354041C306BD96712940D9BD823F4A5170C0B54CFC3F449885C09641B8BF2A3DAB406914BABF624AD640CC78D73E55F7963E76F6D93DE79362C0B18550BE47FEDA407F077EC0DB9CDD3F3A0FA940FEA9EE3FD9D368C0D32843BF0D96E4BF6436A440ABE431409F1820C0905901C0A6823C401BB7A83E0F26F7BF8AB999BF47DF8F40C15707C0A403CD3F37AFF1BF368280BD4CA35EC0B53871BF59BCB13F8BE295BF152811C06D8FBCBFEE1EF4C09793E2BF220B4DC01AFEA2C02CCB56BF27B4F3BF46411CBE318C81BF4EFE893F2CF57A4045D1F23FF08A4D40A8DD6DC013A64B4015AA883F81762C3F362D1F40BBE00FBF9798D53E391EEA3F2054E83FD17C5F402BE0AFC0DBB23EC07BC905C0501996BF6DDD9A40EAB9004110B6C7402DC18C3FC9AD12C0126E70BFEEA0AF4039F3CBBE19BD4E3FE8E87E3E920127C041BE5FBE32A1E0BE45CABA3F551B1DC03D8CA2BF5272B83EE13E82C0669AEC3F4D4B09417145E73E9CEFA53FEF60E83F0E7D7840A477B23D95CF89C029AD2FC098ECCA3EECD11AC0C92C993E43A715C0629E99402176DFBFB638CD3F595F383FE175A33F2BB50040EFE6D3BE94F7393F405D8F40E39E98C08DC7A23F38611C404C349B3C158D5FC01E8A88BFD08684BF8FBB1CC0E1EEDB3FAA177DC0090917BF4D056E401268FC3FABD174C00495B4BF0ECF8EC05A2619BF0B462DC0385B9DBFC30CBABFCF666FBFDFA1814092599E4007593840E4F107C07C85173FF6CB8BBF8A71073F48F70EBFAD48D7BDF239F83F19FF78BF017F98BF5D9DFCC04844763FD55069C014789ABF6C08C33EE21F993FEAA4D1BEB6014D404F3FA4BF12A93E40016D08C0ADED03BF8D54B5C03320FCBF60029ABF89AA4F3EBAB5D9BFFBBB474043167140CF28C2C07EA29D3E325244C0D1A28A3F087824C0FA23A0C0D5BC40BF6ACE9E4002D50E413B9A84C0B481993F48A6F7BF9D5F4F40B2573BC0657AF1BFBAD4D63EB90B3D403C1950405712434084B34C3F71D688403B82B73F4752F43E466B21C0C6C20BC0851AA2405C21E1BFCCAF7240DDBF16404C5189BD730D0BBE4DBEAE3E13A349BF4CAB79C0F28EDABF2D7BFAC05B4C5DC08F7C4440B30EFEBE178A564052F23DC01A10BCBEDEE2334089CF6840E75E0EC0F49F13401D886A3F1F8D6B3F6A17DBBE6A1E1CC0DEFD4C40437C2CC0B9E5FBBF93D99B40D091EFBF359A704052A422C09BF34B40F962873DE5112C4065DD04BFA8711ABF47CA4D3FD5F1D4BE22C71EBF1E44A1BD605EFF3F430C60BF440A8F40681523C0B65736401432FCBFB7BAB0BF8F376F40F77A0EBD33C9AFBFA3BC27BFD62DBEC06BF39140A4C0D7BF52A36A40E134B33FC021AFC03D59DABFFE412040DCD18ABFB013393F530F3AC0CB60ECC0ADE2B43F9267343F6CDE8FBFEF9BD63F805A68C063208B4075CB2140BE164B402C5235406347A0C0E158954042443AC06D89F33BF27DFD3F91A52A3FBE98193FCFBBE73F367FB03F305092402BB56BBEFE9F26BFA9C4BE404323EABFE6E5F6BFA922E2BF16D4ACBF48CD803E1F234F40AAAB9D401912A840DCF7F03F4486B9404C343940E07AAC3F395C9CC0D7CEE340305B383F153C9540FA8F8340870A8940B12A923FBDD8FCBF72CB4F403A2199BFD09072C0EFD18F4076ABBBC0466AF7BF6A161B40BA8808C08F375BBF565F2B3FEB9FB9BFFC80B7C0998546C08F371FC0F21193400401673F18FB0141F753EDBF356725C0C9D4113E6BCC2440CEDAE8BF89AAAABF9E748240B42FA93E425FD8400EE1B23E69E9073D1D1C4B40"> : tensor<20x30xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x67E78E406275873FE920D43F739930BF1FD2893F7D930B409DC224C090D28E3F39CED13F84F3814007DCA6BF684957402B755740154E08C082E958BFDB5DB2C014A44B40F844A940FFBE70C0220ADA3D562DA33F7BDEA43F12FEFEBE2D0611BF9DDB80BFBF6915C0BB653DBE641CC240DD94843F3DCEA93F13F40840CA04C4BF59D7A2BFC31F073E0297A2406152A73F4C5381BEF7A4D940AE74B63F3676D43EC15DB9BF955DBCBFB4BBEA3FCFB8D8BF58FF244064A371C04654A4BE7BA08B40B8C485BF9EF81F4081E0523F645E26C0101C6E3F7D4C1741E3EB9BBF941F9EC0161337BFF54FA9BFFAD6C63FB6B5694057ECE93FBB97B63FECC21DC08D4253406A75774057791840EBF633C02DE1ACC020C380409C07DE3FC6A4C43F04D5F2BDE5763E40E10643C0E6685BC0FC0895C009AAA1401A23B5BF3436294035F962C01676F1BF97129EBFD5DB01400F8F803F26644140CEEFD5C0D7B72FBFECCD7EBF5D110840BBCF9DC0B3249C40CAA9CAC0310373BE79B3D1405C809BBFB3F06040CF60F13E55D0A140B95EE8BEA854F0BC4CCE01BE558F80C05BEA1D4028CD953EB8DCD73FA080613FF32932C0FD268D3F03665CBF28B5C9C05669E7BE70D62D402BEC82C0F2292DC03C020DC01AAEBF40AB6391BFE948744084DF103F76484640E94A1B40A8BEBE3FF369CB3EA7D114C006DEB33E624C91C0FF76B640379E90404EE90BC0FA6190C0A9F7A0BF515BE53F358959C008E0CCBF47FA8CBF34AA0F40AFF605BF98A23740BF6E963F2F75BAC093792340798EEDBF84349640553763409CA660BF90AB65C042139E3E367E8BC0D0EEA840E0571C3F075B1BC0BED5A9BD6727633E7F4C3440BBC8973FFA983B3E7929DFBE84D81BC04EECF23FD25CA8BE4A418F3FA2F771C0274FCAC00250C3BF7BAF2340FAF2183F900722C0DDFEF23FE744143FE44F093E0F80993F09EE8A404A2BFFBED6F02B408428113E728942BF4AC5EE3F9FBDEB40CBD4053C5D5DD840B53129C0340C833F0F7B893F6156F1BF04447BBFE698F63F516335C0B94D3540AD106E40396E07BF515C0BC08501683F0108763FD4060EBF8955B44051BD82406E49773E2A8B87C08A46A8C0A8479AC060048AC02881693F8D90B1BFB86810C04CD7DFBE7460BDBFBBF44EC0C78330C0C7ED65BFF02193BFFFD3A1C031C220BF5D9C8BBFAF2E3141B6118DBF4FF903C02933213FB9E7833F6F700FC0472233C0424E30409398043F4134E23F86AF7A3F1AB60140D7BD70BFF6498B3F187493BF85B58740C229A7C06DA49B409677293F914A8E3E72649D3EB8C8CF3FAEA68040527D333F3B08DC3F66F7B3BFFA4B8140D8160DBF5E16733EA5D4863FE1CAEABFF18D47C0CCE363407E455EC004565A4075A6D7BF6C02DEC0EDD52D40AD6FABC015EC4C4000664340DE1C0141DCCC7640F60A86BFC05213C037F17E409C1F5EC0E944A9404EB638C0C46749C0865F33C0B5BEADBF227F0EC0B2DBB83E4C4F383F2F95A4C0D2BFBC3FBF8709C0E3A733BFFD0B04C0DA9193BF0477F7C03279B7C0BD6617BF71E5734043D8753E3BA580406DC16BC0F880A4BF40A422C0D748EBBEC3E51A40F23A95C042559D40D76D24BF23DCDE3FB236C6BF779789BFB20C79402534DEC06E4EACC02B9A8ABF68AA1EC0B9BA71C0456B07402002D8BFCC7A40C0FA791840BA9658C01AB130C0B162AF3FBF7E54C08EA20EC084036EBF3BB819C04443F9BF504F564009E1A1BE8E37A5BF9A7E4440810E2C40BD3116BF83B581C0109996C00C272EBF39B932BF6E066A4074C74A4031B0FE3F41B9FEBFDB4107BF64EE6DC06C2DDE3F5EE9AFC0AC06B1C0659361C0D1480640B203974004CB293F4F8CAFC0FC4B6D3FB19CFEC0DF699FC02F726D3FB9FC0740E17CAEC04B2B953F10D0373F215F34C0A3296F40549935C00A0EFDBF7F0209C032C0D33F8D79C1BECA2D0DC03C8E043F1ED56D404231A2BDB7AC3FC05FA47DC0C3564ABFCA7BDEBFB79353BFA97F21408923973E0D94D33EA6546A40F57B7D400679F03ED4504BBF94BDB83F9882C23F571C05C07F26F3BEF43856C0F5C4B4C06A707740252E0AC07B4171BF5C7732C0FB9FFB3F7E864A4067391D40EBE5E73FBB50FD400139BCBF5D57C840279230407F25443F4BC2873FC9468D3E6216FFBECA21CEBFAB9A80BF66DB9E409BCBE2BE90768FC030ECB2C0B0AFC9407E769740492CC5C0BA6DC1BF0E547C405681C0C01AE7063FD71046C0EB030D409CE6A53F1F0F504082B6223F53DFC3BF8008A5BF1F6AB63FF59A8140BF41B8C0F7062F3F56CD8DC065FB80400249AABF206A1ABF5CA154408B9CCCBFD17CA340FF3D1DBFFCF29F3FC2F0C1BE89EF5EBFCB21243FCE63414098FC943F02DFACBC0B2020C0FDA887BF77FB5640B2ADA13DB0AAEFC0E666DFC090AC854019BA73BF8A7B9F40BF6CB8BF9610833F70E4AD4098EB24406546C140BDE6A4C052659AC058ED6AC0315CAEC066BEE23E662780C023180E402ADD7B3F2939E63FAA514540F9C304C061C058BFC4F300C0CAF33CC0600705BE4A366240AFF11AC01269233F928FD43E0F271140C40410BFB9DF04BFC036CB3FCBBFA0BFCD543A40121A81BFDE6743C01A6254C064FBD1BEBF5EE43F812B0AC040250F41325EFC3FD1C1A5400C7157C064FD4BBD93CD13C0A9865BC0E510DDBF2F5EE3BF13867FBF5568DB3FDF41CB3D58D81940763B7F4066EE9A3F47979FBEB497E8BFF3DF23404AE54240A07199BF646BB83F176D863F52A14EBFFA7BB43F7ACBB8C06753B93FB4A0EFBFD64DA1C04BC47ABE210ACA3FBA75BCBE9A9E00C0A30E53C0F56D3AC02A5443C0540D67C019A3BFBF0178B1409E19D63D863B9ABF6BF6B63CB49165C0A29C70C01BFB81C0FB499DC0705A36C0037D8E3FE3EAA440B1CB4EC08971DF3E361FE03F17BB9B40FA7E9E40337BA2BFA2DF8D40F31515C053DDAA3EA86A1140B3D46FBF339CB9BFEB8AC0C02B2C8DC08B33D53F9DA986401BAA59406CFA3D409F6CFABD4BF27DBF21B502C1DCB781C00A8765BE3A3C873D31A086408B56A1C07809AC3E11536ABFF09EC8BFB4751CC026C52BBFAE9A61C0F85744BFC38435BF5D0C97404004A840487A38C0276398BDD2B20AC05B17F83F8D4A8AC063A7BCBF3AC78D402226D0BF61EA3F404178AA3EF33973C02DB80F3F81660BBF86D82440C0592F400A0FBB40CAD852C00A4EA6406DF3BEBE12C218BF766426C0E88A54BF1BEA02C0B3A172403A6E0940A0BF34BF234C83BF0146EFC0C913643FE73E50BFDC1D1040E7FDBAC06B4BF63E030248C00E896A3F5157713F514298C0C4D1A7BF5D3ECB4033CAF53E26AE254088956FBFDF81DC3FF40A0F3FDAE86E40959998BFB3895E4054EC1440D1BF3A40E2CD1EC00982403ECC6AE0BE188504C0B33566C0C86FE9BFE387E740772F8C3ED28AC43F973A903F7EAB90400364723F7B54D840BF7EB0BE617C813F3BECA63F376EBFBF20F5CDBF4374D43EF480B03EAF37D5BF820A2540C41288C02E882D40607A933F594CF83F4CFA35C0E07CE03FB06F94C0F26F5640469DBF40587AA03FB97960BEC1A376BF2CCA37C0050FD23FC4BCDB3EECF72240FE3413C0D8FCBB403A5F3440886EC3BE30C39ABF5CD7C0BD5AC261C067740DBFF6725AC0714E84BFFDBA6ABF8C47AEBFDAEC04BFE7FFD440744AF9BCF7567F4053C5903F576E81C05D6DD0BEE9A659BF8BEB00BFAE1A05C058618FC00980753FE484FBBE62C81A4081C480C045E1F73F312D123FB9C9DBBF55C9CFBF68D18540622C02C00DD95D3ED75C74404D5B8A3F3E4B64C0DB6DAA3F88DA6B40089852C0BC996CBF05B1C23E5D9537C012E39A409C3A273F27AC12404AA18640728FF2BF595779409B71B8C00D3F0140873F39407E5B773E99BFC5C04C0162400D3C3BC0397FB33FD2E0953EB068E13EE2F39BBFECBC2140B9E38140A798ACBEEEF2673FF3CFA63FC6C0014004E208BE44186B40C2AE28C09692193FB8F611C036E36AC0C8AB54C0A07992C0EF0E12C0FC618D408B4B6AC0A0629DC0D2A25A3FF06540C0C4583E3F6BBF1E3ECBC814C040C5A940E61A0BC0BE45A13FB205F4C056E89BBF337E993FFC55DA3F67622E401A8EA9407488F33FC215FABD7B8A02404A2F4C400369A03FB80AED3F230E35C08CDB82C03D4B8BBF1AE627400316E9BF77EECBBFDB0FC83BAE7E5E40CE460F405B6FAC3F3BA4FABFA89AA9BF98DDF53F952275C0DB2F8240293A72BF9C4B64402BC89DBF6CD88CC07DB224BFB08A8E40940DAB3FB8CB3FBF63B09A3F128E3B3F6242F43E8C739BBFCCCAACC03383494012FF43C05CE9B1BFF60C3EC0378F47BF75F49D40A404583D76BE8BBF863DD0BF6363ACBFEFB20BC0171C7540AC887B407A8FB33FBA9F4240075F6B409C9BA03FA0E1553FA4D938C0EE0E8A3EDFE08CBFAC26413C2D92ED40FCA5774097B35BC0AB5E0EC01EDC30BF4BDE6A3F9BE40740B91EAFBF4C5E8DBF6EB6BABFCA01E03FA0821640991F88C0B7F8C74051D3023F502E21BF0DADCA4059C96DC0E37987409DDCC5BF421E8BBF25FD6440A75E9ABEB36217C0AAAA7DBCB3634540353795BFCBB258C079AD893FCF655ABEF1E4F03E7FD92F409C1925C02BB12A40A60AC8C0920670C036003AC0EB2C7940B58E52C05575CB401389AA3F81569EBFBF38ED4052F88D3FB9120C3FB8A4E7409780A540543B2CBF4BE00B40305207403B48AFC0F8340B40BD6E2E3F6B36E9BF793B84C09F4C01C19CF1EABBD7B95FC0D4E17ABFEB836AC0F3C4DC3F8B4D4940FFD788BF1871DC3F658E0840845638C0BF492E402A67B83F249EDABF20E85DBF3339973FD82B8D408AC88F40F55D80404B78EBBDB07BD9BFA7F919406D2EEF3D70AF1E40E97D543FDE46B9BEDC306E40E208003F674F9440330055C025DCD1BF08FF5D4055E875BF5B167A40E862934078A03BBF82FA06400D0971C074260040B093A6C02128893F297E0A40F2323C3ED4320140C5722E40A48B83C038E703C063296940E4E06A40FE6EFABD302497C09C2C7EC0B8E4533E88886CBE05E36AC03F2D02C01DF21B4078C5084092337440A4DA9940AEC12EC0D2B738C055AFA8BBE71F7740736C384009BB2B40A041B9BE361644BD9CB4523E7BF4473FE369A13F66E998BF34D598BF7906313D649142BF387220BEFB462CBFFB0C9FC0A4539ABDD17AD740235395C08EBE3AC017E18DC081B54CBEA7B1AAC08DC010C0C93D22BF0856AE40F5A7813F3988A340264705C0F9FC9540EC2DEFBFABF116C08243DD3F775833C0DEE228407CCD0E41294B2240C608B43F946FE03F447BC2BF89826840C43AEC40482B1F406C61ADC0A64C794039C23740B8798EBEF59AA140F4A288BC4B9C23C09FC8D43F42020440659F07C0C21BCD3E542202BD2AFE9B406017AABFB64679401C0BF6BF05184CC0C7A9B33F57A931C0EE638F3FE5245BBFF1FF87BFD2DD4CC04B2FFFBF9B43F140EFC7D5BF2800D3C081345F4054B0E9C0E706AD400C1B8E3FF4868E40811CDF3F6FA27F40CA06444036ABD73F155AB4BFBAA63DC0E39890BF565EE3C07028C840FFBDBE3EB2C88B408DA5393F6B5B52C0377826C0399257C02F838CBF05A95FC065B5A2C07DDB9D4060516D3FC46188C04668A8BF55647B4014EC9A406B6AC63FE0167BBF2D6AF1BF64344EC088AD6EC015B1E83E0E2C0540CD5293C0C7BFD5BFBB53FFBFA43B91C0183F7A40905D63C08B7226C0A55801C053427A3F4F5B7C3EB53F3E40FE7381BE0E49A3BDD9905F3F3FE2AEBDD85E374085B6DA3E09EDC4BE351DB5C0E39A9FC05497CABF2F02DABFBCE8BEBFCA3F5EBFD2C6843F99A09340AB8DAE3F81BF93400112EC3F9F3659C09A88ABBFA01930BFF8C65E3E57007640FDE67CBEE4A5FE3F1BEC2EC0C35AB13FEFCE0AC0026145408081203F02E0ABBF373BA4C06C5DE93FF677B8BF2B5FD53F53879240409047C0E69A5DBF6250573F27F610C09EE1BD3F1E7F5EC021E82FC0DDC38CC014141D40703658C03E30A240CD8B97BC5B07913E683BDB3F82839BBD5577643FD1FF004161DD0FC002460240A5B5ABC0CB7811C03900DCC08CE3ADC07F1E7DC0A18258C00C7E6D3E36EB1240D97F9EC077CCE4BF76D3BCBF8A3491BF271F2DC00C573B40D436DE3D123356401B293A3E3B44A4401C1126C0149DAF3F1E39BEBFD6B15B3F4FDC34405DC246C077998B40D379E83F37022740DC4B6EBFE3A00D3FA0CEF83E31ADD5BF676492C0BE3CAF3EE07919BD71CC2E400A1E9ABFDEC3AD4019A15F3F53B86BC09D0FA3BE6E2F1540D3E035C0AB3094BFD994303F4F1BDBBE5EDC0CC0D5AC1D404F2C60BF32E932C018C6A1BFD217D33F9BF3C7BF8432AFBF84A5E23FA985C53F67CD813EAA6497BFF47B99C0F6C596C07F0335C0379DF940D684DA3F82046340EF7F36C0E786B33E05E09FC0D9D0F13E9CDE68C0BB1F0BC0E2CEDABE2130B840BA7A1AC00030353F85E2EEBE6CD21D402C1163BFEA0F3F40EAF9C0BF9A2DF440F148E93F0E9C8CBF5D2AB13F7D212340141FB73E6BDC924099DB0BC137162A40882A65BF0C50AB40EEE314C0ADDD383F8ED7944056AAAF3F8A616A40AA0F9BBE5C2A6E4024E796C06BD77940DA8A793DB7700640CF7790BCAC2951408B6B5A3EA68C623FCE5E79403D9D634074D3EEBFDF58B5C0AAF164405F3465C08C0DFBC0DC8B3140B62AF7C08701443FB7A31940C8C2FA3F494DE6BF92EBD7BF33BD7F3F33DBAE3F26B70C40DE880C40"> : tensor<20x30xcomplex<f32>>
    return %0, %1 : tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x7A30B1C3811025C4C13CBAC0059C6DC1AC41B53BC93217BD24D60C3D02DFA2BD1CE587C962773449C1169E3D1FCBE63D60ED39C8B47A0BC86FEAD938A56C78392F5EEBC0A2C27AC16F7A193B54838D3D418491C1B5F9A64168A7893D6B0C6F3DCA989BC14542FFC1349BDE48DA5D124991EDCBBDC3CE9E3FBEDFDD40F1C49FC10B8805BE3CC9B53E02BF49471E739649ADB82932AB03343151ACBD408C3CDF3F7BCAF53D04DC163EE20A3CBF6DA6AC3FEA8E03C1B14FD33F141C00345BA69FB56A6C9D39D23025BA34DC1D3EDDF08E3D9E22ED2D4923EBAF2EC70F468AA395C88C4EC93CED349C3BD8AD94C3B920A54273534C43849AD1C2D79FF7B8174486B93EB397C8644958C8B00F4443B357BB42F9CBC1C56B686546EBDF823F8B356F3F6E1F9DC8F9F0B0482889BEB542BC8B363B4D28C640E17AC5B02F4847FDA8ABC6AF2074BACE4E2ABAC0D108C243F91B438785EE31D83B9231CC21213D0E7986BDCF0A5B36A3D14BB6A40A02C942BBB5C9B82229350DD511B67ADF00B7FDFC9235C41853BDEED734BDA3A6EA3E644888BE87D5B83F44AE60BF6D2D04C1225EB041FE5BF53BB0438C3DD86AB3BB392357BC7C2ED53556E8F1B47501D7439C2FB8C3BC4370B84891AE39E8392F313795C9AF9C6E0F3AA53DB639DDAF4439A18225B8BCED8DBD7304023EF4ACAB3ADDF2E63ABC8A4048B0779C49C7B46BBA8B27B639D45D5FC054872240EBE139C1E43F82C0ADF06ABA57278CBB61399C3B492434BA9E5E87C14C0BFCC102E5594B093E54CA604D44C24178534345372EBF117EA0BE68FC61B7D0CC1B3940C63C38AC499E3875551D47AFEE52C69AB72ABC0C3B65BD8E5892BE685E49BF948DDBC00A8517C1DFA4DCB897419C3A23856F3FAFEE004099615BBEDAEC63BEC37C91B8929097BAF1371EC019E80440E10DDBBE8913613EBFE3D13FA97685BF6E342BC0942BABC07ACD0FBEE98359BEBA7D983E18DF94BEC726BA3E85C380BEE5C921B77FB1DCB7C507343E72D6FC3D203DED3C0FCABD3D298F3CBE32DFC63DD1CD2037A9EF4738831714C15D22CFC1D81DF339211A7A3AFF625E40AC58AE4041C1E2BC6429683EDA9BE5B663147E37B6B004447D49DB4295185FBBE924843B4D0D843AF383F7BA3CAF87BF12171BC0A89480BC77983CBD7BE5F63B0D02A3BDEC8915B84F8B73B88CACCD3B7C14243CABB3383A34F514BBA9DC3E402982724095B8863E2D6506402F8C42401BB1E4416EB4E4BF6BD683BD5A40AC3F4FE90340E475DB3F47ECCB3F3BBEA1C1389678C1E36F91C1EBC75DC1205C37402F7A67BF6B2016BB53FCCABB421A7CC0DB2C8741457DA2424F5E8C421378EE3ECAA4173EFD05FEBFAE7C6D41183D1E3AC9DF09BB50428C3B3CDAA3BB07573B3F83AC073F1B7F3F4B48D8744A69CF20BF3E9888BD3DAA48C43AE791C4D53C8CBEABF0BEBE06A0A6C4A733F8C1EB933F403DF4873FE54C68404E31E93E044A3A3E74B0433FE346BC3E90E5103FB9C1C2390CDDB338DC92B0BDB9E922BE72F8C73E1E09333DB8A477C54E5B4345A934A641D69297418F6009C5F7C78843D6F4A83D440FE4BD7B28C13B6D8F95BB51FC7DC8E41DD1495D0550C3E3E557C6E573E8C25B9F57434BC349472A4ED94539971F3037D670B101ADD2BC1B38963BC941453DB6181BBE29337838C66EABB65AA6534881707E48B722133CD3894DBB656CDF3BF0BE21BC67D966458E5B2444C2F704341D53BC371B80BAC153103EC1B9BEA942422902456784B744D4D909C44D499438F1A7D3B65B60303D0D8E66BE0EA5FAC1AE7B784277D9823EA9263BBEE654D9BAE253843A6DCCCCB13BC8883065765E3A001567BA9E012C43ABB31843618CF6B948443CBA95F79D3C54D4453CED56433C0B3F22BCBA562F3C4CC89FBAFF786F3DD5CBF038736D8441A3CEA6C2F5C6AEBD86FCDF3D89805F3FD2098D40819E27BDD0E315BCE0C0B0C2211726432131ADC5C8FE8044F557EF3C7DB4B4BAE521EFBFB46A1DC080C00C3F4EB28C3D8DD0383B94015F3DDCBD063C257281BF78BEF93E7468693F82DB9D3F1B97463EA67A1FBEEA55943F2E130EC049D05A40CEF90C44719E95404C36CBBE46678FBEC2103D3EE33D3E3DB8D811C2169EA4C21DCA2C400637CBC08A8E07BF3E382D3FE1D6813FBDFC35BFAFB4EC3A9CDA2C3C05FB3AC3A950FFC3D2DD82B3828092315765A53DB9F24E3EC066AC3836756BB81C537E3A2C57733B1AE3EE412DF15A42BEC253432229D142E1DCDE3E2FBE8CBFB6897E3D00E1F8BC82FE6CC485A9C742EC8783399F5C1E39551867BAB31E573CB6DB3ABE6C2EB33D2E4AC6C57CF4F6C5DF258AC29D3448C35A061B4017F6E2C0FC67F03D56EB0F3E21D1BD425D4B0DC3FD5882C16C25D6C0765D5441B6E8EC3F87F809B4CB7565B3E1F536BC98B6013A595F09C372BFCBC0BFB843C25641A4C1D2E415471D3A834726270AD0D4A3CBD1C6F24BB194611232C74130B791C1A8B8F5E7D8377A7401371F1FC8C0C435504131A8B240990E14C1A52C873CA60C733C7380C9B93A19E3BA20D67D43A6410C45334ABF3F0EA3833F49E11B3EDE5409BEAD0BD0BFCFAA87BF4BA7AD439CF20B43A27C16411D701DC10EC310B9F6FE9CBB4A9E15435AA8AC42D3955346F88A71C6B2AE1E3D468EA9BC2306504133071D420A5FF5B8DF91FBB8B9CDBFBB65BC1D3BAA7E15C0A953F53F11A2843D078A00BC7A3B9F3FFC5B2641F6FAC13A450C293B68D705C21EC353BD5F35F0C000689DC22D33DD3C7E3D5ABA950133B6EC80EFB5F59E3D3E84B57E3E2BCCD33EB3229C3E0ECABF3E128E5D3E17F8793C0103F83EFB0B5D3ADDA4853A185436C384B9EC437E71E2BFB99167C02EA2F2C3B386FC437C798DC2E8C443C1A6D8243EDF6B3D3F67EA7ABA7255A13B635A57BCF7483ABAACD10B3B9E3B87BCD9FA24C585346EC4825D41BDB92FC1BBD581963FC15CD5C0441E463BB6CEB23B81B4DE40CCEFD93DE4922E44C0AB89C40BD8D03C887DC4BC21F7FD40543A91C1D5B6424305835F436833143F6D21BABEC3C7624CE5A4694C11FDBB3E9CE50FC0981626C3642D7A43D40639BD645AD13C4CB6C9BD03D62EBF19AE84B9502E32B81DE7AE3A1D8CA8BC812EDFC287D68AC3E8663EBB1F8485396973E8C12E80B741184324C1560A1EC25575983B5B0A11BC95DB3FB91C973339A7FFC04AAE9A5A4AD84B67BA02A29839F2C02F3F7B83EBBFAC7F6EBD06D01EC069BB0B4305D1EEC17DD6CC3E61C5643FB44E32CE55D9534EB5E85841F9F943405CC5D2B67250D2383193FF3CAF09893DE1D608BE6AF2DDBD23AE5838DFB9A839CB162FC1ACB3E14033FF7C3F50781840BB27C1BF833A713EEA816C40CAB60BC11ADD464580918B4415460F417066CEC071D20A3ED48519BF543419410505F4C05D3C6EC89D946EC7E81690BFF0B3893F0E4A833F7D6E51BF70E104B299D02C311A2B40403FA29E40366C963D3DBCA73DF9417DC0193249BE838D4BC0AE322FC138E349408F119FBFC787124233B902C296AAD941433DA141134B6DB93750973ADA61D7C68E1D4346063E5DC0194CF33F7D042DC2141E6344406E56411121C0403295AF42BF997441D18493CAC81A27CAB8EEA7C1D9BA96C1E03EA63DAA89A8BD3901093EE672F33D7C23CCBA7960703CCBF943BC1D26EC3EF6E8CCC3BAEBD24119706D4509A79545114B0CBECC97B03EE704683DC211303ED0DFD73CE1E97DBC8F977D4040027DBFABA3F1BE28B28E3E1B5EE6BF381D23418843533F0D50D23E5F7BC141AA9915423C813EC0007272C182CFA7C1EC4CB340272A2C48681B6B481FBEA5BA63BFBB39DB24E1BBFD958BBB4F4190C52CDD9E446AAB1743872C814273F2B13A5906B2BBAB68B2BBBB9D523BC7298E42E3348642AF31953490EB22B44C92DC3E61BF223E00633E405260BE3F020A71434372F54282460F43487E20C323C618C293CF37C2ED6CD2BF142DEC40E7A3DFC3671E0A43915F2CBFAE1A4B3FADC30A3D106B3A3CA0F46B3EFC40813F0ACB024B4768A24B2AC453BCBACE13BC4CE5203CA1E23E3CA4EAA2C4F53668C35297574766608B47BFB235CBE8F92BCB4396C13E18E4B3C034CC21466DA1004697CEF4C1B43823C4417DAABB015DEE3CF03011C09EB62A3C6D7F9A3E43961CBEC1CCC33C752AF33C456132BC498216BCF3B000BE7D99073EE132F33F913A14C08A8754C1E26350C1461E093C7B921C3CC2AF3E4205693E42758D7537592F87B73B61D5B5D58304B655588C3CF2FA513DB43C1FBF7C67CEBDAAC7DAC042E09EC1F2E3BF417BAE4BC1C3E2CCBD82EAFE3DCC3DB63A4BE3A8BA0D993DBCC4672C3B24B387C0456F3041B144B2C0D54A0141E78920BC4EC2933D2F55BDB938BD1ABAF3FAB33CBF5A473C059C9C457B1186C5C3F70B3B082F79397AD4AD407617883FDACA092F0A74F62DA9952538F952CC38B4788D3DB29F46BC0B271DBC2772FFBBE6550F3C0C10903C30D59541002584C1BBB48F49BD22ECC8522E1146204406C3B4E39841E805914198CCABC2DC5B27C2CFA4CE3CEE5F4EBCB1A30CC3A1E919C3470B68BCE3E99DBC7D6F25BEB17D8E3EF5F4F33A82439ABBA1FF183F7924F03D61E086C50B691FC5341D263515B25EB5A4AA7ABFD87E0A40AD9A0D3CD503F4BB9C0FC543E7FC93C4CC542E344CF6F8B4642F454144BBADC0472633BF9BEEA1BE289481BF89F815BFD1751FCC29CFF9C9CAD48740E66D574334145D34DC054535F3694BBC9B2159BACFDDEFBC8BBB343D5F9DCABA2A9117B9507D76C179A1DEC1570F5E3C4300913D08928CB6AF342C347EF2BD3DADEC993F60DBB7C033A10840609F614A5C4E63CA6BBABC4071A910426D1F35394C0E2B38EC1D13451F19A6C27DDEA1BFCC4D21BFB85E1543E3DFDA4244924E43009FFCC2AE2ED03E5817F0BE1D3F08BF526065BE086BB6434D4482C20F453345421974C4F1A686BC7653903B62A1EFC172044D420834DCBC5616A8BCC2988DC837F3D5C61B7DBABE4B6A613E10CE984286CC1C42EA7369BDDE0902BDAEB11E40653B123F7AC00D3966036A3B8C6291C555633D46A6FF82BDE654A13CACEA48BA6BC551BBA79B3538A7D068B9A01138C336F66AC3B865ED3EE935D7BE9D18503DDCC52A3E48B0E8BAFDC35E3D0AC36BBE109EABBDD2EA033F08BE773EA57EC6B52CD4F43350A97D4B142A874D2DF903305AEEF5B488179ABCE658943CA5288DBCFBCEAE3BF3AC993918BD35393D23BC3AD4929A3CDF889DB4BDF49734AB4E99BD82181CC073962BC0E29DB9BE1EC900B874EB0637664DFBBD8B70DEC08A9F3F3EDBF7CFBE6C4CC1CF39D56FCD13DD85C71145214693454044ECDA6FC33CE5F448158A26C9566F8FBE26EA413FF188CE3E2C76793D093FBD3E5F7C793E7F8441B898B7D63879343445B8C1F345381229B8649D1ABAAFB0FEC3F2713E447F67E83FBABD6B402346EA40825B5140C23367436EE6CA457CFA334C20E1454C25F546D1335170D108835C449DBB5543E3CC293F39F486BE34A9E93D25AF0FBE03030A3FDEDB1DC00921523DA0B6AF3CC3BFC2A93C6F2D2ADC4179BFB8D46EBF46BC683982520CB7443BDFB7D574D038E6AB2FBB5F43113BD9481DB4855B44B4FE00AD3CF6E3F2BC4E1103C38ABF22439869C3440B9EC6C4CFDB7C3B9E8FCB3B1D7A693FAE920341BFE90CBF32ACFBBEF3189CBF74DB3AC0094A0548B0ABA145A93C49B6D07AC8343527483D9BF694BC495D9140828C2BC1AB8487C1D0F70342DEDCA83D9955DDBAFFC5F63F4D02D03FB39B963FE4DD5FBFECCEEFB79AB9AFB65D5B693B11B6A0BA22A7F7BC51BA0034489046448FED9244F6A0C0BD04DBF03D4A295F4930E5C8C84B5852BE4B23B33F37396B45853FA7C366CCA7BCBC6DFA3B572DA1BA1B9158BBCB38DB3DB28D76C0F7B137BF6D431BBFBF8065382D1B23B9982D113C71D6E63CA3D89DC37E648FC3D97AE93DE7AC303E966C28BE46F367BF8B7FA83ECD46023F50B8FE361C3C3B3799738CBCB4DB7BBD1B850E3F87C33CBE4AFD14C1E2A742BD7D2F17CB2FE5AE4AEF0626B9831335B9213A743D94411E3D5320DAAD49EE0B2EAC1F2BBD561503BD5EC9C7BB5934EDB9EDECC1BE530C873FD9C2783A6082143D9CBC213E092B03BD114AC43AB27360BA39069736EEED1E3828A365BA8C59573A3719F33B24ED77BD3BEBC43989346F3933037CBF92AC97BF9259EE3BDA7884BCFA0BEE3F3D9C8F3E1E0FBB3B52C206BBA951B93FE825C0BED34EC7C354CF40C336BE38C186939BC15FD7263A793F02BA713F0541A9C03F417CD90D3E5AB7A23D91E550BA449EEBB9C88624C06B44FCC023CFC2BBA427D03B0107CDC325882D45165DA0BF5BA177401166EF3F70C832C177F769BF3C05CEBF2125333B69F004BC3C3858C7BF943545C5CB9AC7AF1AA2488907BFC0049B2D408FE7BFC13C81FCC2006B61BD60B08D3C913370BA9AC0413A0B41C53F25F131C0400B903F5FF918BFC62CD4C226D943439CFECBC6703BEEC744A220BDD6E2AE3D6490D9C10DE1BE42CBCFA43BE9A59BBC60007C41A3C84BC3736BAC4706E40AC7C19E163FF6C8243F789D2439CB552F3B257F14448F87C2C30FD82A3B07CE9EBA90B3FEBB4115B93B900DEDC52F483945ABD23E406248043F3C3573CB23BA044B04BD8945398256C55E385FC8187B79C8DEAE6839102B4D3D3D0B50B6911D5A392FEB85C3D7C16644138797BD2D5958BD6AFEB2C027243940F56AC83E154303BE"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
}
