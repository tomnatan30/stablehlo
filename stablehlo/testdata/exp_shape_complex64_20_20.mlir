// RUN-DISABLED(#1278): stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.exponential %0 : tensor<20x20xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x115F2FC0D77B163E7357A2C0EA59434047CF67C0BBC6113F8769864035E614BF99C36B3FE80B823EDACABD3F51D0933E2AE52B405BB320C0DF7F643FDE5AB93EF3E7F9BD4554B340C2C637C0F3B86D3FA91DB4C0A39C5BBF3F89933FC7E199C0A2AA11BF2287E3BFD429BDC06DB2F43F61F61AC074F26D3F0AE5F5BF0D89403FC0D09BC0A3AC684051FEF5BC71E46F3EB41D28C07F2C7C40F8B1D8BF138310C041FF09BFA4577EBFB63C1FBFA8FFE940235AA940A3EFB83F0F71A3BF3ACB46BD5E71AFBEEC08E0BF089D2DBF211FBC3DDBD157C0A7FD0EC07364903FCD2521C05A896CC045355AC0E1E61BC14BC66AC071AE1D400E64ACBFA1714640262080BF2C51A9BF7D5C8CC0E9412CC0A53D6A3F92F22140914087C0344F903F94D28BBFDC9282BF4D2A56BC95C508C00B2613C0ABE12DC04458203F4A820F40A44D853E05C929BFAE9E8CBE8F2B7340D17545409896C04057624040504379C06E3D07BFE2BCCDC02B376EC08F3B3440991BBABF664E00C0A92AFA40421996408C75E6BF151534C0F7F49ABFEFEED140B2FE71BF71A93340681C1A408AC6264053D49E40A6722D40C7706BBF868FAE3FBFED68C0C671A140B087F33F7BB9DF3C57667CBEE28407C0B03B0340D2D7A2403BD3AE405A0E64C09C5315405121B1BF38EB1C402DE7C1BF7878094103C7E5C0C0605640F866C03E62EFAAC03F969E3F100FC9BE909A4440E8DA99C04DC90C40BDC20E3FCCB6F6BE854C87BE38CFB6BF33BBFB3FE58334BF1299293E31B9653EB1453340930F2340FE4FDABED40402BFED0FE7C0E542F83F1FF94240595233BF6CBEAE409A50BEC0A1F9063F75512440F74984408C0D043F49C6E4BEB2AE2FC03FA7853F82DE8DBEE5E12C40A795F53F3D6A78C08E1F17C091D212404E445EC0CF77903FFC93D5C0D851BCC0460490C04D331540A5ECF33D341EE4BF8F8CABBF2583A43FB501DE3F053D3D3FF54FBFBFD80C58C0E16191C0EAA739C0FA6D2FC00266A640BF793E3F46CF0D40E7F800407EF6EEBF8488FA3F4B2ED1407340C2BECFF486BF61537440F315883F77158F40C4B702C06C5FA440CF0FA83D695E3FC0A73F793F26652540CEFAE0BFC5218DC07A3B2440CE3C3E4026AF86BEEDD8CE3FE3239DC0D5D1883F642292BF12C7BFBF2A819EC05CDACF3F35DB7BC0BB9711C0B0124C40B9D5413F3A6984BFE7C1F840C150B53EAAFAD8C052ED494041B5563FEA05813E4F2287C01A3939C0D33CA53F1708453F87B0634094B3C7BFD0ACB43EA5E040C0D768A0C05AF0A3C0747D4FBF4CE931402204A33EF9EE5640567710406A570CBF593E1D40319AE03F318B1D3F982720402C4C1D40B5809EBF17D416400C367C3CBEA23F404BDDEF3EC32A93C0A7C3E7402F2B6C3FC88EDD3F84B554C0AB4072403BEF1D40E4A2733D84351B40C3EC1A402DD80A41FB713B40B70D44C0460285BF7F2BAB409F62E1BF046962C01C4FB6BFE83C53C0B4B0CD3FD3CCE43FFA1D9AC04131E6BFFDAE4AC0472F8BBCDBA626BE82E453BE68D74B3FCE275840C6C7CB3FAE4C4AC0EB6881C022CADF3F4F139140DB7E1E406E0A343E807094C0A7E7ADC0CF2F30C0B70913C1671F31C0A23B8C407DB7B93EFB723F3FD9745440BDDFB340F6B54C40B668F93FADC9193F6323FCBFFA331040C23858C0B90AAEBFBD0AB9C0CA95523FF117D1BFCA863A40AA612C3FDE16BF3FD5CC8C3F8537BABEEAFD9FBF37CED9BE5DF1963D1D2D43C0DF908340D7D9074097F56840F0B445C0D3C2F3BF93BD8BC03D0C3BC057D7423EA11B6140A00E2DC05E49ABBFE1AAF4BF872F064004E094C003E76EBE04E693407433853F894B4BC0BD59B0C07EB31A3FE67D8A3F204FE13E70B676406D6D4F3FB07E04C0A00DCB3F5DA780BF0FF3524039D4144050C15BBF6053AAC08EE5B03EE0F676BFDD8D8840A0DAECC0298C34BFF86533C067E3A33F91AF853F2C19633F6374053C5DBF02400F1D7440D9FE83BF5C904B3F001CCEBFDE65A03D715ACC4019DBAEBF06C950BF7C6EB73F2DB0813E275AE83F7C75A4BFDBB137C0ED9B1CC0581A5AC08FF253C0B8251240A083B440984A163E8BAC53BFE2EDD1BF72508CBF5A54BBC0134252C0F8A17E3F930A1DC06DF8A7C0962556C00990673F4E6E05C04CC2923EAD500FBFE049863F070D7BC0E10F8AC08C84403F02B9C33F1BEB7DBE0B0CB4C00AD5EDBFEF79B03F6C5984BFEC595AC04FF4BD3F77947E40818923C0BC5B19C01C31593FA4429DC041DFC4BF9F7CA3C0285AD0BFA70DA63D1316373E1BF85D40FF070EC0B16AC1C0E79A2CBF50E493C00D3D9AC0DD0B2BC087927CBEBC6422C071BF9CBB839B0DBF14C15D407BF000C15C3817BFADEBD1BF9D8FCFBE7FD34E4021F69B409C199340BD4E2CC0661E41BF14F65FC0BA45BE40C50CA040B6363040216F4FC033E3F0BF2061A13F170670BF952F04BFEB7E193FB0D45440FEF25B40F63F7040E5B50940DC9CFC3ED2D587C0302C3BC0A24434C0DBEE914006A5C1BFD94A2840386527BF3FB2B23E8E8D3240F35A233F90DB84403C2400BFC644AFBF75D818416DAA2DC0596801402EE1B7C0364B9740F7F0DABF9678AF40F367744092BEB3C00DD3EABFF140B93F3C30E3BF12F25CBE443A8D40AA479340CB31F0C0A91220C095694AC0030C23408544AE3E479E1EC0D4112ABE2C2BC7BEE2B216BF89BA76BFD7A3C73F23F789BF188AC3BF9416F83FA82E2EBD08C10BBFBCACE2BF746BAA409872A93FF99E4A407B4B00BFC1CB46C0FD3C9B406887ADBFEF51C6BE7F8BE3BF96F9A13F546A4140BAC1793DA9F766C0BA109DBEFC464940FCF485C0FBD9D1400BA89BBF481A963ED76DA140BD677EBF2E19C7407F528EC004A13240629358C09AAAA4C0795A3B3FC39C25BF841D19C0F1DEE3BD615BB53F275F9E3FC3044BC04FFF2240046D923F17D19ABF2C1B3F408BD6033F871187C0F90790C0F61DFFBFB36651409A7BEFBF8924CB3E5E5D32C087A08ABFA1499DBF9AC78E401FA698BE5E35B03F7E6B5F3E823FA0BF9A7F2F400E43BB3F84A9EABE84C815C0740056C06F928CBE129F933F524C12C0AD6A934089832E3F2279DDBE69DE2040977DCEBF9CA3BDBF2A2EC6C056617A40CB4C114090A7C5C06237CF40CA607F406D6886405B0E6A401466C3C08207E7BFEA503DBF111292C073AC96C07A6DB7C00300DEC00999BABF3C4C6BBDBF7318409EE5BF3E764BD5BE6D8CC4BD6C8F4DBFB4FFEABF6F168D3F3E23933FD2E9703FFC9533C037438DBEF146C43E97D9EF3FB6C93B3FE88A7CC033B7A0C0F3688240A226403E09A48B3DDFE089BFE11C21BFC948863EC70B92C033D9373F4A6233C0B272F0BFA8411840C8BC4940B3EC1FC048D4E43F856211C088B2AE3FC1EA14C0E85426C0AC4EB4BF1663CBC023707CC08B92A63F3F7A6E406F566940D7D692BF1364A1BFC6497A4067394D3F11260340329E02C12DBA17C027F664C00A2458C0226953C00C34A03E673EA83F7BB193BF868F37C0788A90BFFB7DAABFE160A73ED7CC08408923B1407C32C4BFEF453ABD1B1CE33F360E5140FDF5163F56CD81C02FE33D4017CA0540A1B0DB3FD2958CC067231040675C0940638A6D3F04F238C0FD81D24045A45BC022F0D5BF80FA1FC075449F403A159A408BB715C08963C73F51DB0BC0B799AEC09700E1BF0FB4BCBE83E66CC0B1869540EE814640782B2B3F173A043E5DA0FDBFE91F9D3F502517405A8DA53F66C117417997E83E71BC3E40CDCC75BF3A58C0BFB2F6F940481D984051ADCE3FF5B99EBF37A3213F479475405B69CBBFE45D2C40F4301A4002FCC5C0674D6840DC55583F684E1A403EB5953E0F64BE40895158BF94DC7BC0658296C02409993F0A50823E1469253FFBFD52400909C5BE3F5BBABF836307C0BC78A93FF2070F40F1BE02C030AEB7BF34389ABF545C5FC0B40E8FC0356699BF925797BF472598BE264125400F65D43D7BBEF43F529215C06A05CB3F034D7ABF22062FBF2609A2C0DE6D06C020796BBFD826A73F0B7474C079D2553F71B02CC0C75D2840FD6E16C0FFB6EFBE3538BDBD1DF990BF09DEF0BEB7BC983FB49A343EACC4243FE9FEE4BE744A1CC0D71714BE4B6F66C08D6893BF6EBDCC3FD2753C401794EBBF9461D23FBA8B883F52EDFCBE3FA008404A148BBFA7E9A040517C7F3FFAE4E93FBB4EF740357F6640B7532640A94481BF12E82EBFBE0112C0F4C6484087A916C02FFFB9BF5EC5A43E96664DC03D1137400319F83F7AE4A03FBD7805C0999483BE76E686409915B53F4C1A0040C871BF3F325A15BFD32C9A402CF9E43FCE18E93F530ED43F4EB62C3EFA8FACBFDCCE9040D82D8DBFABD011C06E4C9EBFACFB80406A5997BF0D5F47C0ED2480BEC6003DBF7E0666400A1BA24029F175BF5B1681BF5247F33F6A2A2D406A6E81C08537BF3F628838C0FA9BD73DC60E9CBFE031BD3F86BE4540B598DD3E5BD49C3F4C87D3BE6D4DB83EBFD03AC0399B2240475786C0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x9FCA823DD4E11A3CB564CCBBCE4A123A9968B83CB41B6C3CC8F75E429F9A12C21D971B404491213FCD208740B787A03FF0943DC1196A0AC1631F1240905A5D3F3850303F65540EBF0AE40A3D79B1393DCF081A3B8D2532BBCF149C3EE8B64940E401EEBDC9D40DBF53626DBA594A273BB29D593D66BD913D0308DB3DF1E7CC3D5C8EDDBBBC996EBB16A4713F19AC663ED7A34EBDE12D54BDFC06EFBD35A211BE3FFCA23E6941FABE34AE8D3E548BEB3E28D3C7411E37454374A18E3EC6B05DBCB8C301BE4ECF32BFFF61013FC6B03E3DC41CADBC4B7ADDBC928320C0A1F6E6BFA01DC4BC5D57D73B26A954B8075BF7372B062740E04937C159BC3F41C6A095C1E5C5AEBD4C34813EA749293D92075C3DA4A1BBC0A6B231419DF4B53F386C2FC0D196B83ED36E9ABB38DFA0BD6457B4BD5E485B3D97A81E3D03911141531E1B40DBE3FD3E9B130FBE3D7032C237D720403192CBC37F2E5E42E9F88F3C250C28BC83D8B0BA26FE673AE658F93F24C984C17D0FA03BC0D4093E6B5CC6C1161DD4C2B72CAD3C11E765BD67D9CE439B320FC4DBD844C1057231414B4D57405FE551C103C21141984B3FC145E75BC07E14EF3F424C4AC251CC1243E1227F3F786280BEC37B63BD3FA0DA3DEC56DD424D2AEDC2D25DA0BC35E8A73C2AF845BEAF4D233E5F7217BE978D263E1A4143BAF9E224B9296A5B3F7CAD963FD81C4C40EF16A9BF27D5034071E1AB4169FEF44009CD984005A0183FFD3025BEC252BDBD6C82623EC67CF93EBBCFA63D15FF96BFA8F7D53E4A293A41AD21A9C0E655B63ED35BF8BE4892DDC00E26293F64EBAC3EB23ABABE39FA133BE64FAC3A39FBE3C05E9C2EC1C35AC13F394A39BF0844043DE87E633D83892FBFEB68A53E31FBA0C051F592400DA47FBD95C4903DFF80593CF9B9E53CAF95983AE75F003A78C5FABB02CD033CC00372BE2AFB8CBFE904973D779B803E5FFB8540C949744004725FBE763A553DE74929BC293A26BBF788F73C7F6869BD52F0A1BF2B41D73FE6190CC0329FE5C0904FDB40ED78E33F2600AD3ECB5318BF92EBB041C4071F4204FD1EC29BD99BC26B92294369255F419C9CE73C3E4E2A3D0C951DC0575F50C1630327BC0BAFD83B37F196419D97A2C0C1BF7D3FF5E59D4052189B3F267B29C09F675A3D45465E3E86A763C0C3726740B151D2BD2F709EBB38768B3F5D9AEABFB95A0B4553164E44C3D494BA14C380B713610F400CAA133FDECC68BC72476BBB551F2740FCF021400CE6BE3E8B500CC25DADB4BF39DB39BE1D0F2E3BB8DAC73B67EBD4BEBB20213E0FDFABBFBF6297BE6681024175629FC09C9208C0F48D37412F18BEBF554A8D3F46F7734062A030C146E02841CA63263EAE8E8E411F491041BA3FBD3BB8FF063C8C5CCDBE44F11E400511ECBC8316B1BC54653C414482333FB9DD07C1B7C1EE40D054B3C5CDF69A447914C23C91FD24BD0AF91EC2719F4EC3EF1C8B3B8FAEEBBC90A9AEBAA2E2163DD86D1E3FD627BE40857C29BE5573893B885C783F361F23BE9193113FBEC5143F5E431FBF644FEA41712BD7BC2743083DF7C582BF1EEAB4C0C2743B41DB350540DC71D13BF3C5ED3B49EA7DBD8E1273BC88CDA6BC346773BD5BE0863FFC377A3F7E75AE4138FE87C1C78E10C1042CB641E25D35BFC810D7BFA80814C188F10E4000A3663E765EFC3D5D2B12BE406711C063A166410CFC3741782E0140AECF7D40957B603EFADC28BFFED7263F201B453DBC72DBBC220E20BD8BCAEAC0B68E7FC0794E74BC923F30BD59F54ABC1FAA34BBC20690BFB13FE3BEA6D07C3C8B6485BDE90098BDB3F4023E590E183C518810BBDBAA4D427471AF4264E6F43CBB88EE3CD3FD5B3FB5CDCE3F904D96BF790D82BF0FD789BF31A7FCBFE79A274022FE83C04D0194C183659D41B6BA783E4DD4B13E92044E3FEA9D94BF0C63F941AD5080C2BA90EEBE7DF827BEEB60E73FC91947406C641B408E04A23C710DC1C076CA99C0B4A67F3E5159823EBA024C3EF515803CB453F142D04611C458CB783D8E5BE03EB3A39FBEDCFE9F3FFC7B88BEBEE497BDC202ABBD2091BA3C3B49C3BC50F0E13CF55D8B43BCD22442FF0AF8BC8F6CDFBEC0909B3EEB5D0E3EF60BA73C7C90003D430A343D974F973D5C56B23C69D7E23C933AF43DC6F90F3DF6C3913E799AFD3E2A48FBBBFF6F953C182AB53DEAA40740A1391E3FEDEFF33E8CEAF33CD0C71C3E6D75AFBE3F59C23D87343DC0FE7B51C072C869BD15C757BD17F2EF3E91751240D0EAA93DA1E14A3E466C483E054A823CF4F690BFEC76C4BE3D47D83DB4B5D23CD42E3DBD06E8013F51CDEBBB43F66EBB4BA024BF6C49E3BE9EC8583F94DA05BF7102D0C05872FAC14FE71CBDEE770DBFBDFC29BF34A075BD013D71C1D3F101C368244A3DC5F83DBDE596E93C38C623BCD19409C3501761423A3644BC548918BD2F9D0540FF0636C05C37FC3E5366AC3E59E1D4C14F6D01C15E6ABBC110BD0E4231F83CBF5425BB3F4C6650BD14658CBC4A37B1407EECBEC27F1D3041A1F706C1B25AAABF6D0DFA3E5ED280BFC734CDBF8F7BF83DC00B18BF753748C6E1B5B6C57BB1CF404E467740ACDC7BC1A2EBDFC2CD8F3BC3C4D216C30D7978BACB0366BB7D9E5CBF0F3A85C0671D73BE252945BFD20108422484BBC2A0E1A7BDE6C1E23A61B24041A37C88404E6AA93D883063BCEA4B103F28ACC0BE66D98A3BEA49C33E8B7E703C8E15AEBE8113DE40103197BEE7D2EBBD3F5811BFE1FF48423F4C4743445DA641B54436C105FCCA3BA99E35BD5266743E4768C7BD6E25503D9B13253EDAF8A341F62BA03FA680D33C90FE05BCB9983AC1589EA04147CA7443803825C44FE7DF3E3C38A2BFB32CBD3E60F6B9BCFB2434BCDEB9833BF159693C8A1DFC3C7D55D43F8563A0BF930BBA3D194A26BC46D0AC3F2F667940F4310EBDC561C03C69088E3F76EF3BC047E789417B161C4117F649BB53406B3C145C0ABE730C91BC3F6C113E00B8733D4D88EC3CBAEB5EBD889494BD9D2791BEC0A4123E826E3A3FDCA2C73EEC2E97BFBBC4D53FF3E276419247E1BE1987E8BEC22F0B3D4BD11CBC67F804C0711C19C0D88C9B42AE727C42FE6806BF942FC33E0478913CAE374BBE502BC0BA4690BABA940A1A41C6B7833F1E80D6C35687F3C3402268C2A98903C2B18D07BAE3170EBB03DA8FBD7EBDF13E98C0FB3BD8B89A3BB48BE53891D67CBA08472FBF736F263FB946AA3FF2B016BF148A213F8A5127BFBB7B933D8FB1113ED7F4ED3F5B46234096376E3DDDE386BCB62BE0BE893EB33F9FDEB8BFD906C03F806E80BBB78DADBBB90F9A3F4F55A83D67F58C3EA4444DBE27E044BE138EA43FCB91F7BF746F2EBFDC4BE2BD3233D83DF9C095C1004A60C16BA176C0B82792C040E52BC0C64C36C033A9443C064796BD94219EBA88B7A33A241944C099C601C09C027C41B0B80BC2BA8350BEB7D949BE3A5C83BF8F4EFD3FA43C56B91B1850B96D99DEBCF6C0D53B0D440F3D7466393CD7F5C03F0ED559C0A3DEC63CD25A52BD11FA7F3E7D97AD3D1AF4C6401E74B8C0D1E25C3E87D520BCCA34BBC0E9083CBF74D08CBF5CEAB63FEC671AC172F18641056DDFBFC20FA940CF96A5C03A42FF400CC31CC01C5421BFD1502CC49DEA4D43DB2D1ABE0683E6BD66F06D412D4A10C36024A53A1565C53D47F19B3D4B76A93D40B3243E4A6F7EBDD86780BAE70ECABC35948B41088B5C413992E8BEAA8885BF6F491BC0D89919409FDD68C0F0965FBEA0FCC6BF878B813E8E6BD53C608EC3BE4146CB4270261AC5AFEDD03FF91E98C0FBC1B8BFB13A9ABFD9563CBE3332B53D612F3141A5BE883F3F2EC841569DE14145C22A41A39C4D4054A37E43F9798FC3B2CF37B9CD0EA03CD5BC4C40A80E553F284FF1BF91FA96BEBEC69F3D5E132DBF3751F13CA876EF3DCCFE87C0AF2A05C14181AE3DF7AE63BE275CEFBBD196F23CF1FDE93D74F28EBEA03021BF35E3C93EFD14BEBE9BCC853F93D1C1BA69D6C53D064F953E934E73BE065A51BBE5CAB2BB90BDD53D95F5C43EAA2A713CEF3E853CF78A70BD03D3063DAF34AE3D9F3030BD5A12C63ED85A53BF1ED26B3EA5AA143F7647743FCC41373FC579FABE8AC7D2BEE89A46BF3747C43E46CE14BC98C9A13EBF03A2C03D8B92C129EB1F40DAF89040BB00A7BEE203043F90CFD63D362DA4BED43030BFC1F027408B79FEC4D11B7CC449EBE440B43436C17FA4A8BE3EFBC3BE7B0C82C16D9882C1CA29633EF279973D42E81EBD8B94373C403E0940D56FD3403919F63DFF5901BD74772841CAD38542F4380E3F5229EC409FDD703D0A0D0EBF5DA8BDBF827AB9406D5CA5409843613FC2EB45BDEBA782BE13E65CBE802281BE60543BBE97DD66BE6DE49CBEA5A704BC1D6B133F3F2506BFE07B4941398B08C258E2503E26BDA5BE3B10C2C0B6C534402B65B03AE60D8F3C6AE5633DDFA6C03B6C15E03C06A1963ED2909F410C7213410D95474077FBAEBFE9EEB2BF1D02A2BE5AB8C7C0C6C33041"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
