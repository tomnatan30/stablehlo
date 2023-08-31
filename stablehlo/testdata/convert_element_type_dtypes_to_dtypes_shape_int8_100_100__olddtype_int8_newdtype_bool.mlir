// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<100x100xi8>
    %1 = call @expected() : () -> tensor<100x100xi1>
    %2 = stablehlo.constant dense<0> : tensor<i8>
    %3 = stablehlo.broadcast_in_dim %2, dims = [] : (tensor<i8>) -> tensor<100x100xi8>
    %4 = stablehlo.compare  NE, %0, %3,  SIGNED : (tensor<100x100xi8>, tensor<100x100xi8>) -> tensor<100x100xi1>
    %5 = stablehlo.custom_call @check.eq(%4, %1) : (tensor<100x100xi1>, tensor<100x100xi1>) -> tensor<i1>
    return %5 : tensor<i1>
  }
  func.func private @inputs() -> tensor<100x100xi8> {
    %0 = stablehlo.constant dense<"0xFF04FFFF02FE01FFFE00FD000003030001FD000505030101FF00020000FFFFFB0001FFFBFEFEFF0007FFFE01FDFE00010405FBFF0202F8FD04FDFF0301030003FD01FE0000FD0002FFFD00FEFF000200FD040303040605F80602FCFD00000000FB02FEFF05FE0001FDFD000101FF03030300010202FCF8FEFFFFFB010000030100FEFFFEFDFD03000403020000020000FEFF010001FEFF01FF0104FF04FE04010205FFFC00FE0001FE01FF04FFFD00FE02000400020200FD02000103FFFCFBFC02FF02FF0000020100000001FEFE0000FF00FEFD010200FE00FF040004FFFCFCFF00040001FB02050000FAFB00FDFC06FD000001000000FE00FCFEFDFD0400FC02FC0001FD03FFFC01FFFF04FC00FCFE00FEFE000201FDFD000000FF0006060301FC0202020002FC00FF000000FE0003FFFE01FD0300030006FDFFFAFDFD02020004FB06FE0200FEFE010200FC02FE00FDFE00FEFF04FC0305000000FF0001000105FE00FE00030001FC00FAFDFAFF04FE020001010503FEFE05000008FE0502000003010002030003FF00020100FE00FEFF02010102FFFE00FEFFFCFF000000FF01010104FF01FEFEFE0300000000FFFD0303FEFB0600FE0608FFFEFF0000F7FEFA010001FA000002040203FE0002FF02FEFA0300FF0100F900F900FFFE01FF060300FE01000001FC010100FEFDFE0002000000F9FFFD020500F9010006FD0500FD00FC0400FCFB030100FFFF000101010303FE00FFFF0002FE0603FF05060504FC05FD030500FF00FF00000002FFFC020100FF0400FB030000FC0106000000020000FFFF02010000000000FDFE01FFFDFE0000FDFE000102000301FEFE0800FE0001FE0201FDFA00FE00FE05000105000300FEFF010204010006000204FFFEFC00FC00FDFB0202FF0002FFFE010100FFFD0003010300FF04000003030002000300FB0202FFFFFE0304FEFE010100FC010003FFFD02FDFD01FA03FAFF0300FAFC0607020402FCFB00FC01010102FEFE03060000FE04FF010000FD0301FD000003000301FF03FE00020301FF0200FDFBFCFFFFFBFFFFFE00FF0100000500FD00FD03FE000005FF03FD01FF00FD0000FF04FE030103010000FBFF0303FFFFFDFF00040001FC01010004FF0202050202010003FF04010106FB0000FF00FBFF000103FF00FE0000FF00FF000000FF0300FB000000010303FF03FF00FD0100FE01FD000102000400FEFCFEFE020000040100FC0200020100000400FEFFFF0202FDFD00FF0504FFFC0100000200FFFE04FD02FD02000300FF0000020100FE0100000002FE0302FEFE04FB000100F900010000030000000001FF02FD02FDFBFF01010301FDFB02040300010000FE00FE00FFFF00000000FEFA03FF020000FD02FDFDFF03FEFFFF000100FF00020100FCFE00FD00FD0002FF050004FE03FBFE03FF0200FCFE0102FD0000030300000102FEFC00FF02000003020107FCFF0401FF01FD000301FE030806FF03FFFF01000100FD05040000040004FF010000050006FB08FE020301030200FAFB010502FB01FFFE02FF010102010208FEFE0002FB020203F9FEFC00FEFF000303020003FC05FEFD01FE0000FD0104FF00FF000000FC02FF0001FF020103FF04FA03FEFDFD00FEFFFE00FBFAFFFEFD02FFFF0100FFFFFF00FFFD0300020007020000FB030001FA0200FFFDFD000000FE02030203FEFCFF030003FF04FFFF0600FEFF02FFFB000003FE00FF000000FE0402FB000200FEFA040003F902FE0405FFFF000406FE00020001FF00000003000000000000000400FC01FCFEFF01FD00FB00FFF8FD03FCFF02F9FAFAFEFE000000FF0500FAFF00040100FD0101FE01FF00FF010002FEFF00FEFA00FB01FE01FF01FEFE03000000FE00020200FF020101FF02FF0000FD01FD0100040002010000000701020000010200000000FE00FDFE00FF04030004FE0400050000FD0301FE000902FDFE02FEFE0400FB0302FF05000000030006FFFA050003FFFE0102FF000200FE01FFFF00FF00030301FE020303FF00050000040304FE02FA030301FF01FEFDFFFEFD0002FDFE0101FD00FE000200020000FD00080101F9FE00FE03FFFB0100000403000000FAFE00010002FFFFFD02FE01FF020103FC01FEFD04FD010300FDF9FC0301FE01FF00FE010104FC01FC000202FF03FD030202020002FC020000FCFD00030005FFFF030300FCFF03FE02000201FEFCFEFE0003FF000402FDFC0602FF02030102FDFEFE000002000400FBFC000003FD03020301050300060304FC0300000103FF01FFFF0001FF01FE0101000202FC01FEFFFBFFFEFFFE0000F803FCFF03FCFDFF00FF000301010100FC00FD000203FB06FF00FF00000306FD0100030000FF02000000000000FF0202FF0000FD040000FE04FE00FD00FF0100FD00FDFFFF0003040004FF0300FBFF02FE00FC02FF05010001000007FEFF01FFFC00FFFFFE010002FA05FE0000FC00040000FFFEFF000101020700040600FF05FE000206FB06020002000503FE0100000002FF00FB00FC030102020000FBFC03030003000003F8FB020000060004F802FF0100FE05FFFC00FC01030502FF000100FFFD030001F902FDFFFFFF00FF020000FE030103FE030302FD00000000FF0009000202FE0000FFFB01F9FB04FD05FCFEFDFD00FE0202FE0001FF02FA00FE0104FA01030101FF02FEFC00000101FE04FE00050000FDFF06FCFCFFFF020001020000000300FF0002000202FD00FF0002FD0205FFFE0400010503FEFF0001FBFC0302FD000500020000020000FC050200FF010501FAFF0005FDFD0003010007FFFFFD0803000001FF0500FC01000205030001FB0200FB020700FE0303030001000002FFFFFD00FF0000FE05FA0001FE03FE0000FA0100FEFF00FF0000FDFB030500FEFF02FE04FB02000204FEFE01FFFEFE00FF00FE01FE0700000002FE0003030000050000070000FEFE01FC000401020102FFFE02000004FDFCFE020003FE04FC03000001FF0600000005FEFFFF0400FE030600FB0200FF00FD0000FF01000001FC0001FBFEFB00050401FFFFFF070403010002FAFF000300FCFB0203FF02FD01FB0505FF0001030000FE060405FF00060201FF00FB00FE00010100FF000302FDFEFD0201FDFF0005FC030003FE06FEFC00000003FEFDFCFE00FEFEFE070102FEFE01000003FCFE0301FE050203FE0003FD00FFFEFFFD0006FB0405FC00FE04000000FB000200F9FEFE0100FEFE0002040000FCFF0200FF00020202FDFEFFFC00FF0301FE03FDFF040101FB03FD04FBFD000201FCFEFE0100FC05FC0101FFFF00FFFF00FF06FBFD02000400FEFF0000FFFEFF00FBFD0001F9010202FE0102020002FE00FF00FFFF030301FDFC02FC0200000001FE0002040607FFFF0102020300FD0000FD00FD00FD0308020100FF0002FD00FF020503000100FE00FFFCFF0004FA0202FD00020002FF0001FBFF000703FCFDFEFF00FE00FD02020000020002FFFCFFFBFE05FE0002FE00000804FE00010000FC01FFFEFF03FEFDFCFFFE02FF000002FC04FEFD000105FE07020000FE0002FF00FC0002FCFFFFFCFF00010204000101FFFD0200FD0201FCFEFF05FDFFFCFEFD020001FE02FEF900FE00FDFFFF0100FEFEFEFDFD03FCFE000402FBFF01010501FE01FC06FC000200FE01000301000000FDFFFF00FF00FF00FEFEFC0200FBFDFE0106FFFF01FBFF010200FF06FE0203FCFD01010001FA00FD0500FF00FDFDFE030001030101060003FA01020300FE02FF0104040001FB00FE000401FFFC000102FF00FCFCFD01FF04FF0502FFFDFE0001010100FD05FE0204FC05FF0501FF03FEFE0001FF04FD0400FB000402FF03FFFF0000FCFE000100FFFFFF0303FC0004FD00000502FC02040404FE000301FD000002020000FC0000000001FCFCFFFE00FF0100FC000103FA00000000FE030402FE0304010100FDFF000402FFFEFAF5010202020200FF01FE0202FC0003010600F9040104040502000300FF010100FDFF00FFFF0105FF000302FDFE04FEFCFEFAF900FEFB05FD04FE0200FC00FDFD000000FEFC0004FF0200FF0100FF03FF0000FD01FBFCFEFFFC0000FB00FEFC000004FF0001FFFD02000404FFF9000001F9FF020000FEFFFF010101020500010102FF0004FFFC01FC0400FE0002FD03FF0503FB0000010001FC05FC02FC05000100FC00FF00FF02FA02FE01FAFE010000FF00010102000301FFFF02FFFF03FFFEFE01FF000100000107000302FFFD00F9FB0401FE01FF0400020101010502FA00FF01010003000300FC04F8000106FE00FE01FE00FD010000FD0204FF000202FE0103040005FCFFFD00FD05FE06FE0003FE00000001020003FE000103FD00070300020102FEFB0004FC03FF0100FB010502FFFF00FFFF0304FE06FF040103FCFE00000302040300FF00FE010001FDFD03030002FF00FEFF0004FD020001FDFCFEFD0001FEFEFF01030103FFFC05FF0001FFFD0301FCFFFBFDFE000200FF0400FEFFFF01FFF8FDFF02FF00FFFF01FE0000000301FCFD00FFFFFC0701000004F902FE0304000202FFFC03FE0002FF00FFFFFF02FE05FE00010203FE00FCFCFD00FEFC00FFFF02FFFD03040003FE0104FDFC01030103FF06FF01030002020002FBFE0000000600FFFD06030103000002FF00FF0200FE05FD00010003FB010200FE0001FC0202FA02FDFD00000300FF000001010301FAFE0102FE02FF0101FDFE0202FF0200FF02FC00FC0404FE010002FEFF01FE0103FFFCFD020101FE00FE04FE01F701FE020402FE03FD04FB02FE000003FAFEFD04FD020002FF0100000300FD00F80302FC000004000402FE03FD0000000102FFFC0500FCFD02FD01FB0103000100FE0103FCFF03FE050001FF00020201FC0000010102FDFEFF0000FCFF0005FFFD030306FEFFFE010000FC0102FFF8F802030000FDFE00FC000100FFFEFF02FB010105FF0000FD0100FE0400010406F9010600000901FC020100FFFF01FD040004FD000403030300FFFDFC00FAFFFFFF01000202FFFFFFFFFF02FC0400FEFF0004FFFFFF00FE0201FEFD020400050202FEFCFD000003FF0400FEFE0000FC010000FFFC0001000200FF00FEFF03FC03040200FE0401F7FFFEFD04FD0000FDFEFBFD000201FF02FC00FE0007FA00000003FBFDFFFCFF04FE000200FD0008040003FF000206FB02000102050005020002FE000400FF00FEFE0100FCFE02FF03FB0500FDFF0002000102FEFFFC04FE03FE000700FEFA0004FE02FF000206000006FCFEFF03FE0201FD000000FEFE01FD00FEFF0000FE00FE01040003000000FD01FF00FE000002FF0000FD00FF04000000FDFDFFFF00050000FF02FD0200FEFA01000000FCFD000302FEFDFC0106FD03FE00FC02030003030205FEFE00FFFC00FD0302030101FBFD00FC000600FA00FFFF00000100FF070000FE02060000FDFEFE000201030000FEFDFD000504000200FFFDFD02030000FCFD0001F90400FB03020300000306FD0000010001030200FB02FD0300FD0000030002040107FD0000000000FCFFFE00FCFFFF000401000203030201FA03FE000000FD05FEFF0100030003FE0000FF01FF040002FB0607FE03FC070200FEFFFB0003060306FEFF0100FE00020801FC04000004FFFC000404FEFF01FE0203FFFC04FDFDFC00FD010001FF00030002FFFFFE0104FF0100FF000401010301FF0000FF0402010107FCFEFF01FF01FD000303FBFE00020000FE0501040404FDFFFF0202F90803FE05FF00FDFF01000000000200010300020005FDFEFFFE05000302FE00FFFEFF00000005FF010002040300FF0000000301000107F9FF0203010002FF0100FD0202FC0001000801FF00FE020000FFFB0300FFFE000502FD0302FFFE00020200000000020101FF0000FFFF0403FC01FE00FD0203FB010300000001030405010202FD00FBFDFF0200FF05020000FC000000FE000204FE02FF0002000008FFFC0100FF0603FDFCFE04FC01020000FC03FF00FE00FB02FEFF0001000100FF02FCFC040200010001FF0102000303020000FF010201FF010105FEFE02000100000602FEFCFEFAFEFDFB0100010301FDF90004FFFD030001FA0300070200FC00FEFEFD00FD0100FDFC000002FFFAFEFFFB00FC000100030600FD02FDFD00070002FC02FDFCFDFFFC04FD0100FC0000FD010300020001F901050200FE0002FE0000FEF9000000010601FF040005FB0403FCFF0201FCFDFE03FF000303FFFFFEFC0002FF03FD0202010002000202FC0002FFFFFDFCFDFF00FF01FD00040201FAFB0001020300FFFF0300FE0204FEFE01FFFE03010201040005FC02000003FCFF0203FFFE02FFFE02030505010005000300FB0000FF00010004FE000304FEFDFF00040402FEF902000402FE020401FC00020003FC0501F90502FE0403FE0104FB00FD0001FDFF0206FC03FC01010001FD02030300040100FE0303F902FE00FBFFFA0200000100FDFFFCFF0006000301FE0005FD01FEFE000804FD000400FF02FF01FD01FF0200040402FE0200FF02FD01FC0000FD03FE0204FCFDFEFF00020301FF03FFFCFF04FD00000101000502000100020100000202FFFE00FF01030000FD010500FF0402FFFEFE03FDFE0800FDFDFFFEFFFC00FFFC00FD0500FBFE01000102010500FE00FD0400FFFF01050202FCFC00FDFAFFFF0001010204FD0300FF010003FF0005FE01FB00FEFF00FDFEFE01FC000200FE03FCFC00FF01010001000102FE0301010206FA0105FC000002FF0103FE00FFFF010300FEFA01FD000202FDFC00FE020300FF000601FC000101010002FE00FBF90004FB0003FD010503FFFD00FD0201030301FE00FBFC0100FD00FF0000FB01FEFEFA010102030000FF03FEFF0203FEFFF90100FE000002050001FDFD000004FFFBFC0002FE000202FFF9FDFEFE0504010304000200FF03010203FE020000FFFCFFFDFE000001FE020200FF0502FE00040003FF020000FE02030000020001020005FDFB0102090305FDFE010602FD0100000200FFFD06000201FA01FEFB01000202FFFF0802FF0102FD0200FDFEFCFE00FD0103070400FDFE0002FAFFFC05FFFF0202FD02FD05000100FC010400020102010202010102000001FE0103FD03FD05FF040300FCFBFEFC0501000000FFFFFBFB000004000100FFFF010001FF010200FB00010201FEFD0003010008FE0002FFFA010000FF01F8FE04020000FD01FA02FD04000100FE02FDFD0002FD0500FDFC05FC0600000000030201000603FE05FEFC04FF07FFFDFDFDFCFE0004FE0100FDFE0004040201FA0100000103FB05FC00000200FB04FF0004FE00FF04FF0300FA01FC01FF0400040302FC0201FF0104FB000101000000FE0003FCFEFD000202FD020402FDFE01000001FF030203FFFEFFFE0002FA02FE0007000402FB00FEFEFD0100FB03FB0100FF03FE01020304040000FEFE0304FF00FEFC0102FF000002FE050102FD00FEFF01FEFBFFFF03FE01FB01010200FF0103FE0003FE0005FB0301FF0403FC0405030001FC0202FDFF0104030101FF00FF0300000002FFFC000201FDFDFEFE0401FE000300FE010000FD010400FD000101FF00FB0000FDFF07FE03FF00030000FDFF01FC0000FC00020502FDFFFEFF0200FC02FB00030104000203FFFF00FD0000FE03FDFD03000100FD000404FB0406010002FF0401000204FEFF04FD0301FF02FCFFFC01FFFE010001FA0005030301FF04FF000001FBFA0400FBFF01FFFB00030000000003FB00FFFF030301FEFE0402FFFFFF0404FE00000202010000FE0000FEFF05FC06FF03000002070000020104000402FE0600FBFC01FB04FE04FDFE010200050204FE0104FDFDFEFD04FFFFFEFD00F901000000FBFEFD00FD00FF03FD030100FFFF0000000104FE0003FEFE0002FD000200FD03FFFEFE02FD00030101020000020400010300FFFE00000100FD0002FE020200FD0302000004FC010303FD020000FC0002010001000002000002000102FDFFFF00FB02FD0000FF00FF06FD0000FFFF0001F9FF02FE020401FDFFFF02FAFEFFFFFF000003000103FF00FBFD0000FCFE020100FC020002F90100FD000600FCFC00FE0004040400FF0501FE0100FCFDFE000101000000FEFF04FFFCFE0000FD02FBFF04FD080100040100FEFC0003000502FFFDFD000301FB03F800040101FEFEFC0200FC050003060500FFFDFEFBFE00FFFB020201000000050101FF00FF05000002FFFD00FF000203030103000200FE01FD00FD000403FB02FFFF06FDFF00FAFD0003FFFE030104FD0305FF02FF040103FD000000FF060003FDFC01FD0007FD02040000FF0206FD0003000401000001FF030100FCFE010100FDFC01FE030400030001FF0004FF0502FB01000101FF01040003FE00000000000501FEFD01FFFFFF02FB000001010000FC05FF0303000004FAFEFE00000507FD0200FD0000020004FF0103FAFB0000060000FAFFFF00FF010002FEFEFD0002FFFE000002FFFEFFFC04FF000304FE0004000601FF00FF0000FE00000101FD0603000202FEFEFEFB00FBFEFCFEFC04000101FEFEFE02FA00F9FB0402FE00010103040000FEFF0000000103F8FF0000FDFFFE01030103FFFC02FF00FFFE000000FCFE00FFFFFE0000FEFE00FDFD0000FAFE0100FFFF00030001020000FE04FD00000002FCFF00000200FCFB010001FF060001010200010100FE00FC0300000200FDFE010000FE0000FC00000000000203FD000100FDFF03FA010003FD00FE000002FC0002FC0000FD010001FCFE00FDF700FD000002F800000001000701FFFF04FF0602FFFCF901000005020100FEFFFCFBFCFFFE030501FFFC0505FE00FF0303010005FF03F90301FB0301FFFE00FF00FEFE0504020403010204FF0403FF01020404FC0001FFFFFC00030003010300FD01FE030100030000030300FF0004000300FDFD00FB00FB020003020004FF00FD0205050300FCFDFDFD00000201050200FD01FF02FF01010000FC0001000100000200FEFEFF01020002FF02FDFD0104FCFC00FF0000FDFFFE00060103FFFE0304FDFDFF05FAFFFC03030001FD030001FEFE03FDFF0100FE01FF0300FEFBFDFC02FB0102FEFF01FDFC0001FEFF00030000FD000200FFFE0605FEFFFDFF0000000101FF01000200000002FFFD0000FC00040001000005000103FEFB04FC0000FF0000FAFC00020004FE0000FE03FF0403FE05FB05FA02FE000407FF000406050001FA0000F904FC0002010200FDFF00FF02FC00FF0301FF00000301FD040402FF06030000FE000103000106FEFC02FF0400FCFFFEFEFD0403000003FF0000FFFD00FB0003FDFD01000106FE01FC00FCFCFFFFFCFAFDFE01000303F90005FE0004000600FF0300FFFD0500FD0002FEFF010302010600FF00020000FF00FF0001FE0100FB0001FFFA0001010000FC040001030300020105FD0500000000FF03020001FF05000003000300010001FD02010200030002FD00FE000200020002020401F9FFFE01FD00FC03FC00FFFDFF0100040104FBFD0000FFFF030102FF0008FAFEF9FFFCFD020200FD0000FB0004FFFFFF0403FEFF03FDFE04FFFF0101FCFEFBFD00FF030403FEFDFFFC0002FB03FE000200FEFEFFFD0000F8FC00010100010200000401FF01FB01FCFF03FC0000FE02FBFCFE020602FD0304FFFD0202FB0200FA0103040200FC03000001010002FE07FF0001000001FDFC02FD0002030101FFFE0001FFFFFE0400F9020004FC050000FF04070000FDFEFD01010000FCFF05FD03FFFDFF00FEFF0003010001FDFFFEFBFF0200000000FD00F8FEFB000202FBFDFA020200FE000301020202040001FB04000302FEFA04010001000103000105FE0002FCFEFA0000030500FF01FE01000102FD00FF08FF00000406FF06FBFD0000FF000102FF0003FC00040002FF030207FB0101FDFE000502FE000003FDFEFF020106060001010501FAFE02FF0004FF020200FF00FD000000FF0402FFFAFEFEFE0003000501FD02030100FC04030002F9FFFCFFFF00FE00FB01000302010302FFFC000006FF01030000FB0001FF02050204030001FD0000FD00FF000001FF000200FDFB03FFFEFD00FE020000FE0103FD0007FD01FF00020500FE0200FEFCFB030401FE030200FEFD010001FA010001020002FDFC01000100FF03FC00010000000600FF00FFFEFC060304FE020000020001FF01FE01FFFD0002FE04020100020000FFFE0003FC07F9000500FEFA00FFFF0000FD070102000501000000FEFCFF04030000FF01000300FF010101FF00020204010004FF0101FDFC0000FA0000050203FBFD00050002FE00FBFF020000FE0102050200FBFC01000200050300FEF703FD02FFFE00FA000000FF010100FF020100FF00000003FEFDFEFA03FCFB020500FF00FD0309FF0001FE000007FCFEFFFD00FC00010502FD02020000FFFEFF0202FFFC01FE0400FB000004000004FF07FD030102FEFE07FF00010000FD0003FC0001000204FF000001FBFF00FA00FE010201FE0000FFFF03010200010403FEFBFFFD00FCFE0001FE02FA0000FFFD0101FDFF00FF030700FEFE0305FC000100FF03FA0300FD05000000000000020002FDFF0000050001FE01000305000000FC00FF0303FF0001FCFC0405FFFEFB00000200FD01010002FFFD0500FFFF02010201010001FCFE02FA0401FCFEFD0001FB0400040000FF03FD030402FF0005020200FDFE01FEFE020201030100020300FEFE00FC00FF000000FE010200040203010000FF0100FFFAFF020102FF01000200FFFDFF01FE03030300FFFB02030001FEFE0103FCFA06050704FF02FF0202FE06FBFE00FE0000000301FD02FF050302FC0005000003FF00FE030002000200FE00010002FFFEF9FC000000FA000003040203FEFD03FD0100FE0600FFFF010002FE010000000207FFFDFC02000100FD0005FF0002FE0700FD02FC010000000102FEFFFC03000003FF00FFFF040002FE0402FF0AFFFD000004F90002000500FDFD02FD0000FCFC0402000302040003000203FDFE0001FEFFFF000204000703FCFF0203020000FFFF02FE04FEFD050102FDFF0100FFFCFF0501FF0002010000FE020200FC00FD040101FE01FE000201FB00FFFCFEFE00000300FF00FD0000FFFFFF010002FFFE0400FCFEFEFFFE0000FE0205FB0302FFFF0600FF020000070000000004000003FCF90000FE02FFFF0000FF000200000106020102FE050003000404FE010202FE00FC05FEFB000200FFFF00FB070003FF00FFFE0401FF01000001FDFEF90001010300FC00FE02040400FF02FE03000202FF01FF0300000000FF0203030002FE02FC0000000000FBFB0300000104030407060300FFFE0000FC0404FCFF03FCFC00FF0501FEFE00020702FE03FE010100FCFF00FE020001FF01030002FF0604FDFE000002FC0400FE02FEFF0003000101FC00FFFEF900FE03FDFD0400FFFF0300FB01F900FFF6000502000004FE0000FEFD0202020000FF0301000101020301FF0602FC0005FF000300FE00000003FE03040000FEFD0502FF0000000300030100FD03040100010001FCFFFFFDFCFDFF00FEFF0001FD0001F90200FE0301FCFBFFFF000000FB00FF02FFFE01FC00FE0003030101000001000003FFFFFE000002FE0100FFFF00030000040001000000FE0000FD0502FEFFFC04F6000000050000FB0000FB07FD0003FA00010703FDFE000106000101FA0100FF000001FBFBFB03FE0000FB00F902FF03FEFC000303030100FFFF0000FDFE01FFFF03FDF80803FA00FFFCFF02FEF900FE00FD01FDFDFF00FFFFFE040400010400FDFC0501000000FA010000FC01FB02FBFF00FB03070405010300FD020100FAFB000000FF0501000005FD00040205FF02010000FA00FEFEFF030001FD03FFFF04FF02000002040405020000FD01FB01FEFE01FF01000000FFFD020000FE0302FD03FDFC0202000202FE07FDFEFE0200000400FCFC020102020200FD00FE0204010003FD02FC02FF010000FF000002010003010005FDFE010003030201FE0000FF030402FE0004010602FAFC02FD04FF0200FC0203040103FE000104040602FF04000000040002040200FFFF00020004FDFFFD0001FF00FE03FD04FD0003FA010303FC000100FCFC0102000503FF04FFFF00010004040000FEFEFD050201FD0201FDFFFE0002FDFE05FFFFFEFCFDFC0003FC01010100FDFC00FFFD010101040001FDFF020002FBFE010203FE00FCFDFD03FB0100FDFCFF01000001FE00FF00FDFDFD01FCFC04010006000003FE02FFFD0202FF03FD0600000103FC0302000403FCFD00FF04FA0100FCFE0302FBFFFF01FB00FDFF0303010300FFFBFE00FF0001FDFE000801010502000200FC0004000000FEFFFE0400FF0000FF02FF0004FDFD01050600FE0100FD0102000402FFFF0107FDFE02010000020000FE02000300FD020002FD00FC03000400FFFE01FD0003FFFFFEFF02FB000400FF0200FFFF0100FD0201020304FB0100FCFDF9FE00FC0000FF0002050200FF0000FCFD00FBFF01FF01FDFF01FA000000FFFD0200010101010000FA0600FB0200010303000101FF000200F5040000040004FC02030000FD01000501030002FC00FDFDFF03FF01FEFE0100FCFF020201FDFD01020000FCFC040000FCFF00FCFF01FDFCFDFA00000300FEFEFDFBFF000401FCFE00FDFA00FF020301FF03040000000001FFFFFCFB01030200000500FEFDFF04020000010001FEFEFB00020000FFFDFF0300FF05FB00FE0004FF0300FF01FEFFFD00FC01FEFF0000010001020000FFFE04FF00FE07FEFF02FE06FE0001000000FFFFFAF9030600FD0100000101FD05FF020301020802000100FF0006FD0305000001FF02FDF80000FFF9FF01020000F7050000FAFEFDFE01040000FC00FFFDFD0502020002FFFFFE040000FE0002FEFCFB000108FD01FFFE05F9020001010200FDFEFC0000FCFD020103010104010300040300FA0005FFFF0101020300FCFC0101FAFE000104000104FA01FF02FAFE00FF03FE0103FF00010300010300FA020203FFFDFE00FDFE000001000500000003FE00FFFF000100FD020000000201FEFE040401020101FF00FE000102000503FB0000FBFC00FFFA0103FE0200FF05020200040200FEFE0600000203020200FE0303FEFEF9FCFFFFFB000502FEFF04FFFFFEFB01FFFD01FE000100FCFC02020400000000FEFF00FD05FDFD01FEFE01FD02FF01FBFDFFFE0001FD01FC000100FC01020100FD010100FE01070101040300FD050000000002FCFE0105FB00FFFCF900FE0405FF00FD0104FDFA01FF0002000002020000FF030401FFFC050100000002FF04FDF9FD00000102090001000000000002FC0000040302FD0A02F8F70200FD05FF00030201FC0000FB00FD02FF00FEFF00020100FF030203000001000000FD000004FEFE0001FF0100FDFFFC01FD0000FB0002FDFD040500040003FD01020203FCFF0002FC02FE03FFFFFF010301FE0100FBFD0003040402030500F909FAFEFE05010000030100000102FD06FE03FCFD000102010003FB0300FF05FEFFFDFCFE0207FDFEFF00040004FD010403FF01FC0000FF02FB0200FAF70301050501FA00FD060401010003FEFC02FFFD0000010203FE000003020005010000FE01FCFC010200FC01FF04FF040004030105FF060000FEFF0200FF00000200FE0002020005000100FB0100FD00FDFA0105FFFBFFFE0100FD00FC00FF030000FCFE02040000FE00000000FCFBFE00FA0000FD00F9FF0202FF0205FFFEFE000105FF02FE03FF0103FC0207FE020000000200FF00FFFB03010001FE03FEFFFFFB0002010202FCFCFC0102030400010200FD040100000001FFFAFFFB030B0307FBFFFD00FD00FD02FE04FE00FE01FBFDFAFE04000004FF06FE03FF0302FE000302FFFF000004FC02FE0005010001FD00020002FDFF00FE020101040401FDFE000100FDFD02020100060504FC0000FCFF0200020102050102010205F806FF00FFFF09FFFD030103FB00010402010004FEFF01010201FEFEFFFD000400FEFE00FF02F9FF0702FFFEFF0005FE010A0200000000FE00FD"> : tensor<100x100xi8>
    return %0 : tensor<100x100xi8>
  }
  func.func private @expected() -> tensor<100x100xi1> {
    %0 = stablehlo.constant dense<"0xFF65FBE57EBFFFBFA75BFF0FBFFBFDCF7E27F7FFAFBFB5FDCF38BDF6F5EC89BEFBDFF6E8DFA25FFFBE77FB5157FBFBF36C5BFF1EFF87BF9F37DF6FF59B77F1EDDADB6FFFBFE2DB1C79F0B37DFDDAFAF5F57DBB59FDBFFDBFFFFEF33C7DDF7F53E7973FFF7AFFFEB44BB1F8EDD6679BFE7EFA2B1BFF2AE1FFBFD4F0F9AFB6BA7F9F79F37FFFD7E9F4DFFFFFFDDBFD7971FFEFFEBB6B76C77FBFCFE275FFAE11D05FFF8F6DBFDDFEA3FD798D33B4BBBC7F1FBD5FAF7FF9FFF7ABF47DC6FAFFBF7F7FFF9DF57DBFFDFFD4FCFBFC7EFFE75FAFBEBC0C3C73ADDBBD2FBFF7947BBBAFC7FABC3C7DEFD7FDCD7FA8F3FFDEFB7FBEFC1BD5F5F7FD4AEE77FBB9DDDDCBCB3D5BDEDFBF1E9BE4FDF37D8EEF5666EF7FD7FF9BEFD5FAEF3EBEFFFC6FEF1BF536D7DFFFBFDFDFBEE6F6DFFA1FFB5FEA6BAFEE6BF7EBF46F2EFF9FEFD3FADDF7FF7DBD7FFF5F1B57EFFFFDB7F5BEEFB7DEFDBFFBFF7DFDACDFFC3B13BE75F86FFFF7BBBF6EDFFFFE1ABB9D3FCDDEF3FC7BBFFEF457FDA7FBFFB2F7EFEFEAEEE6FDDE37B6DBF7FDFE9FD7BEEDBEFFF7BFF6BFC7FBFC7EFB7BB7BFFFBF1DFD6CD7EB9FF2FF7FF7FDFFFEFFF377EAE9E3FBD7BF3D3FFB9F7F56FFD97EBE6FEFBEFFEDFDFDDCCCAABFFFBCAFF1AFB6775BDDDFFAAFBDF98F375D5CA6F1F28EFDEF7EFB574D73EEDCFAEC9ED3BDF4C1DDFEF135EFBFFBEB73FFBFAD7FFDFC7F2FFFFF1D5ABF3BEE627FF7BAB9FD0DCFDF8F7FEF445FDEFF5CAF7EBDF37FF9DFF76EDDE6577BFD5FAEAF19DFFFF7FBEBFEEEBBFBFFCEFF5FA5F6FDFEFAFFF5BF6FBFA7D77DD7BFEFF3DFFF6CCD3BF7BFDF76AFFD7BBFEDEDEB5DFFCFF7DEBBEEB6FDFD5DF9CFFFB2F3F6FFFAF379AF73DAFF9FEEEFFFDEB7FFAFFBCFFFFD78EA5EDFF6FCFC7AF7E1FEFF6E3F9F6EEFF7BFD1FBCF7FAF7BEF9FEFF3FBFFBDFDDFFF1BF75F735D7E79FA77F7F2D5EFFDFFB73FEF0BFBFF73F267EEFDDFFFDFB8BE71B7FE9E6DEA9D3F2DE93B9DFDFFA79BB7AB75DF8D9F7F5BDFF7B7FB3EDE5C5FD77FFBFFC7BEE735EFFDDAEF1BFCCF7C9E977E727BE7EFBAE4FBFDFEBE673CFF377636B7E638DDDD9A4E82EB5B36BB65F4FFDCFFDFFBBFFEFFEF755F56AD6DDFF3FE54FAFECBFDFFBBBFF7FF5DEA1F2F4EA59FACF97F7773B77BFED3FEFECC7ADF7FB7DAF5AFD475B3FB70A7FA5AF5DFBDCFEFBFF4FFFFFEBD9E6DFEE7FFBF6FF6F2FDBE9DF3F9B7FDA1FBEB77BF76CFDE9D9F6EFDEFFCFBF78A7FFDEED7FE3CFD4D59BF796FFBEF6EAF8BFAA7BF2F7B6DDEF8ACEFFDE46BE7BBF61777F1BFDE7CFDFC2FF9BFB4CEF5F9FEF6FCEEEB0D74BAD1FBA77B7FFFBBFCDDFFB6E29EFDEBDFFBFF7FF15FB6AA8FFCB73B7EB57BFCECFE593DEF7A6F7FFEBFDF5C7FF754DEFBFC3721E7297FFDBDB6FDBCEBBD1FDE83F337FFBE7FDBFBB9D7DD77B799CFFDB7E2F968AF7FDBFDD1AF27CF2D45FE91DCBEBDFCF47BF37FBFBE6F8FF9FDDD38FBE9FDF3F98FF3DF3FFDF5FE647B9FEFFFFEFEE8D6DBF7EBFD9AFFF7BF6FBFF7F77BD6BFFC9FEFBDFF7ED77D152FF7DBFD4FD6B6DE5FBB7F2F5DF61FF76C774DCF6EFFFDE7EC4FDFDB1FFEE9D3CBBBEE7B9AF72F7EF37FF57C3EF3D3EFD3FBEFCEFFD6DF6FFF7EDBDF145BE3FFDAD9EFEDBCFFFDFFFAB0FF7FAF777FC3EFDE5FE61F3F17CC7FF774DB13B9FBF4F5EFFFDBEFCFFCBBFB7FFDF3FE7D3FCFE6F7FBB9D46AFD57F3844BFFFBFF51EFEFFF76FCBFBE3FFF3D6FEBFEEB7BEEFFFDF7FEAFFDF7A1"> : tensor<100x100xi1>
    return %0 : tensor<100x100xi1>
  }
}
