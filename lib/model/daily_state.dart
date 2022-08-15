import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:perthle/bloc/daily_cubit.dart';
import 'package:perthle/model/game_mode_state.dart';

/// Immutable state containing today's perthle's number, word, and game mode.
/// Statically holds the lists that words are taken from.
@immutable
class DailyState extends Equatable {
  // Constructor

  const DailyState({
    required this.gameNum,
    required this.word,
    required this.gameMode,
  });

  DailyState.fromJson(final Map<String, dynamic> json)
      : this(
          gameNum: json['gameNum'],
          word: json['word'],
          gameMode: GameModeState.fromIndex(json['gameMode']),
        );

  // State & immutable access

  final int gameNum;
  final String word;
  final GameModeState gameMode;

  // Serialization

  Map<String, dynamic> toJson() {
    return {
      'gameNum': gameNum,
      'word': word,
      'gameMode': gameMode.index,
    };
  }

  // Equatable implementation

  @override
  List<Object?> get props => [gameNum, word, gameMode];

  // The answers

  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS
  //  ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------
  // SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS ------ SPOILERS

  static Set<String> get allAnswers =>
      perthle.map((final daily) => daily.word).toSet();

  static DailyState _dailyState(
    final int gameNum,
    final String word,
    final GameModeState gameMode,
  ) {
    return DailyState(gameNum: gameNum, word: word, gameMode: gameMode);
  }

  static List<DailyState> perthle = [
    _dailyState(1, 'COOPS', GameModeState.perthle),
    _dailyState(2, 'BLAHAJ', GameModeState.perthle),
    _dailyState(3, 'SPOONS', GameModeState.perthle),
    _dailyState(4, 'SEAN', GameModeState.perthle),
    _dailyState(5, 'JAMP', GameModeState.perthle),
    _dailyState(6, 'JAMES', GameModeState.perthle),
    _dailyState(7, 'ALBANY', GameModeState.perthle),
    _dailyState(8, 'ETHAN', GameModeState.perthle),
    _dailyState(9, 'MARINA', GameModeState.perthle),
    _dailyState(10, 'WORDLE', GameModeState.perthle),
    _dailyState(11, 'CYRUS', GameModeState.perthle),
    _dailyState(12, 'JERMA', GameModeState.perthle),
    _dailyState(13, 'HANNES', GameModeState.perthle),
    _dailyState(14, 'WISEAU', GameModeState.perthle),
    _dailyState(15, 'ANKHA', GameModeState.perthle),
    _dailyState(16, 'NICK', GameModeState.perthle),
    _dailyState(17, 'TOMMY', GameModeState.perthle),
    _dailyState(18, 'TIKTOK', GameModeState.perthle),
    _dailyState(19, 'LGBT', GameModeState.perthle),
    _dailyState(20, 'PERTH', GameModeState.perthle),
    _dailyState(21, 'WING', GameModeState.perthle),
    _dailyState(22, 'SALMON', GameModeState.perthle),
    _dailyState(23, 'GRILLD', GameModeState.perthle),
    _dailyState(24, 'ALEC', GameModeState.perthle),
    _dailyState(25, 'BESTIE', GameModeState.perthle),
    _dailyState(26, 'TAYLOR', GameModeState.perthle),
    _dailyState(27, 'MARTO', GameModeState.perthle),
    _dailyState(28, 'ORCA', GameModeState.perthle),
    _dailyState(29, 'HOYTS', GameModeState.perthle),
    _dailyState(30, 'KOTLIN', GameModeState.perthle),
    _dailyState(31, 'GRIMES', GameModeState.perthle),
    _dailyState(32, 'CURTIN', GameModeState.perthle),
    _dailyState(33, 'FARM', GameModeState.perthle),
    _dailyState(34, 'SUBARU', GameModeState.perthle),
    _dailyState(35, 'SAAB', GameModeState.perthle),
    _dailyState(36, 'HENSMAN', GameModeState.perthlonger),
    _dailyState(37, 'BUSSY', GameModeState.special),
    _dailyState(38, 'BESTIE', GameModeState.perthle),
    _dailyState(39, 'NICK', GameModeState.perthle),
    _dailyState(40, 'CRONCH', GameModeState.perthle),
    _dailyState(41, 'GRILLD', GameModeState.perthle),
    _dailyState(42, 'SEAN', GameModeState.perthle),
    _dailyState(43, 'BANKWEST', GameModeState.perthlonger),
    _dailyState(44, 'WUSSY', GameModeState.special),
    _dailyState(45, 'CURTIN', GameModeState.perthle),
    _dailyState(46, 'COOPS', GameModeState.perthle),
    _dailyState(47, 'MARTO', GameModeState.perthle),
    _dailyState(48, 'SALMON', GameModeState.perthle),
    _dailyState(49, 'KOTLIN', GameModeState.perthle),
    _dailyState(50, 'DISCORD', GameModeState.perthlonger),
    _dailyState(51, 'TUSSY', GameModeState.special),
    _dailyState(52, 'SUNSET', GameModeState.perthle),
    _dailyState(53, 'HANNES', GameModeState.perthle),
    _dailyState(54, 'HOYTS', GameModeState.perthle),
    _dailyState(55, 'CYRUS', GameModeState.perthle),
    _dailyState(56, 'GRIMES', GameModeState.perthle),
    _dailyState(57, 'VERITAS', GameModeState.perthlonger),
    _dailyState(58, 'RUSSY', GameModeState.special),
    _dailyState(59, 'MARINA', GameModeState.perthle),
    _dailyState(60, 'JAMES', GameModeState.perthle),
    _dailyState(61, 'MARTIN', GameModeState.perthle),
    _dailyState(62, 'WINC', GameModeState.perthle),
    _dailyState(63, 'ETHAN', GameModeState.perthle),
    _dailyState(64, 'PERTHLE', GameModeState.perthlonger),
    _dailyState(65, 'GRUSSY', GameModeState.special),
    _dailyState(66, 'PERTH', GameModeState.perthle),
    _dailyState(67, 'ALEC', GameModeState.perthle),
    _dailyState(68, 'SYDNEY', GameModeState.perthle),
    _dailyState(69, 'TIKTOK', GameModeState.perthle),
    _dailyState(70, 'TOMMY', GameModeState.perthle),
    _dailyState(71, 'NERVOUS', GameModeState.perthlonger),
    _dailyState(72, 'LUSSY', GameModeState.special),
    _dailyState(73, 'ORCA', GameModeState.perthle),
    _dailyState(74, 'PEARS', GameModeState.perthle),
    _dailyState(75, 'HOYTS', GameModeState.perthle),
    _dailyState(76, 'HANNES', GameModeState.perthle),
    _dailyState(77, 'SAAB', GameModeState.perthle),
    _dailyState(78, 'GENETICS', GameModeState.perthlonger),
    _dailyState(79, 'SUSSY', GameModeState.special),
    _dailyState(80, 'TIKTOK', GameModeState.perthle),
    _dailyState(81, 'KOTLIN', GameModeState.perthle),
    _dailyState(82, 'BESTIE', GameModeState.perthle),
    _dailyState(83, 'CRONCH', GameModeState.perthle),
    _dailyState(84, 'FARM', GameModeState.perthle),
    _dailyState(85, 'PERTHGANG', GameModeState.perthlonger),
    _dailyState(86, 'KUSSY', GameModeState.special),
    _dailyState(87, 'ETHEL', GameModeState.perthle),
    _dailyState(88, 'GRILLD', GameModeState.perthle),
    _dailyState(89, 'CSBP', GameModeState.perthle),
    _dailyState(90, 'WORDLE', GameModeState.perthle),
    _dailyState(91, 'SYDNEY', GameModeState.perthle),
    _dailyState(92, 'AUSTRALIA', GameModeState.perthlonger),
    _dailyState(93, 'GUSSY', GameModeState.special),
    _dailyState(94, 'MARINA', GameModeState.perthle),
    _dailyState(95, 'CYRUS', GameModeState.perthle),
    _dailyState(96, 'ETHAN', GameModeState.perthle),
    _dailyState(97, 'SEAN', GameModeState.perthle),
    _dailyState(98, 'MARTO', GameModeState.perthle),
    _dailyState(99, 'MCGOWAN', GameModeState.perthlonger),
    _dailyState(100, 'MARTOMILK', GameModeState.martoperthle),
    _dailyState(101, 'CRONCH', GameModeState.perthle),
    _dailyState(102, 'SAAB', GameModeState.perthle),
    _dailyState(103, 'ETHAN', GameModeState.perthle),
    _dailyState(104, 'PERTH', GameModeState.perthle),
    _dailyState(105, 'JAMES', GameModeState.perthle),
    _dailyState(106, 'GAY', GameModeState.perthshorter),
    _dailyState(107, 'SNAPCHAT', GameModeState.perthlonger),
    _dailyState(108, 'FARM', GameModeState.perthle),
    _dailyState(109, 'ALEC', GameModeState.perthle),
    _dailyState(110, 'SALMON', GameModeState.perthle),
    _dailyState(111, 'MARINA', GameModeState.perthle),
    _dailyState(112, 'ANKHA', GameModeState.perthle),
    _dailyState(113, 'CHUSSY', GameModeState.special),
    _dailyState(114, 'GEOGRAPHY', GameModeState.perthlonger),
    _dailyState(115, 'YUMI', GameModeState.perthle),
    _dailyState(116, 'WINC', GameModeState.perthle),
    _dailyState(117, 'FRAMED', GameModeState.perthle),
    _dailyState(118, 'WORDLE', GameModeState.perthle),
    _dailyState(119, 'HOMMUS', GameModeState.perthle),
    _dailyState(120, 'MARTOMORNING', GameModeState.martoperthle),
    _dailyState(121, 'IMPREZA', GameModeState.perthlonger),
    _dailyState(122, 'CURTIN', GameModeState.perthle),
    _dailyState(123, 'FRUITY', GameModeState.perthle),
    _dailyState(124, 'NICK', GameModeState.perthle),
    _dailyState(125, 'WING', GameModeState.perthle),
    _dailyState(126, 'BESTIE', GameModeState.perthle),
    _dailyState(127, 'CITRUSSY', GameModeState.special),
    _dailyState(128, 'HILLARYS', GameModeState.perthlonger),
    _dailyState(129, 'PEARS', GameModeState.perthle),
    _dailyState(130, 'KOTLIN', GameModeState.perthle),
    _dailyState(131, 'SEAN', GameModeState.perthle),
    _dailyState(132, 'GRILLD', GameModeState.perthle),
    _dailyState(133, 'SIGMA', GameModeState.perthle),
    _dailyState(134, 'GRINDSET', GameModeState.perthlonger),
    _dailyState(135, 'UWA', GameModeState.perthshorter),
    _dailyState(136, 'CSBP', GameModeState.perthle),
    _dailyState(137, 'THOR', GameModeState.perthle),
    _dailyState(138, 'ETHEL', GameModeState.perthle),
    _dailyState(139, 'SCOUTS', GameModeState.perthle),
    _dailyState(140, 'SUNSET', GameModeState.perthle),
    _dailyState(141, 'OVERWATCH', GameModeState.perthlonger),
    _dailyState(142, 'BURRITO', GameModeState.perthlonger),
    _dailyState(143, 'SYDNEY', GameModeState.perthle),
    _dailyState(144, 'COOPS', GameModeState.perthle),
    _dailyState(145, 'MARTIN', GameModeState.perthle),
    _dailyState(146, 'ORCA', GameModeState.perthle),
    _dailyState(147, 'BEEMIT', GameModeState.perthle),
    _dailyState(148, 'FORKLIFT', GameModeState.perthlonger),
    _dailyState(149, 'MARTOSICK', GameModeState.martoperthle),
    _dailyState(150, 'LGBT', GameModeState.perthle),
    _dailyState(151, 'ALBANY', GameModeState.perthle),
    _dailyState(152, 'JAMP', GameModeState.perthle),
    _dailyState(153, 'BEREAL', GameModeState.perthle),
    _dailyState(154, 'SUBARU', GameModeState.perthle),
    _dailyState(155, 'JACKBOX', GameModeState.perthlonger),
    _dailyState(156, 'HEARDLE', GameModeState.perthlonger),
    _dailyState(157, 'TAYLOR', GameModeState.perthle),
    _dailyState(158, 'GARTIC', GameModeState.perthle),
    _dailyState(159, 'ETHEL', GameModeState.perthle),
    _dailyState(160, 'GRILLD', GameModeState.perthle),
    _dailyState(161, 'HOMMUS', GameModeState.perthle),
    _dailyState(162, 'TIMEZONE', GameModeState.perthlonger),
    _dailyState(163, 'ALBANUSSY', GameModeState.special),
    _dailyState(164, 'PEARS', GameModeState.perthle),
    _dailyState(165, 'SYDNEY', GameModeState.perthle),
    _dailyState(166, 'NICK', GameModeState.perthle),
    _dailyState(167, 'MURDOCH', GameModeState.perthlonger),
    _dailyState(168, 'FRUITY', GameModeState.perthle),
    _dailyState(169, 'MARTOTOMATO', GameModeState.martoperthle),
    _dailyState(170, 'SHREKUSSY', GameModeState.special),
    _dailyState(171, 'BESTIE', GameModeState.perthle),
    _dailyState(172, 'SEAN', GameModeState.perthle),
    _dailyState(173, 'HUGS', GameModeState.perthle),
    _dailyState(174, 'FARM', GameModeState.perthle),
    _dailyState(175, 'JAMP', GameModeState.perthle),
    _dailyState(176, 'JIMOLEUM', GameModeState.perthlonger),
    _dailyState(177, 'BANKWUSSY', GameModeState.special),
    _dailyState(178, 'JAMES', GameModeState.perthle),
    _dailyState(179, 'PERTH', GameModeState.perthle),
    _dailyState(180, 'SUNSET', GameModeState.perthle),
    _dailyState(181, 'SCRUM', GameModeState.perthle),
    _dailyState(182, 'FRAMED', GameModeState.perthle),
    _dailyState(183, 'MINECRAFT', GameModeState.perthlonger),
    _dailyState(184, 'MARTOGNOME', GameModeState.martoperthle),
    _dailyState(185, 'SAAB', GameModeState.perthle),
    _dailyState(186, 'LGBT', GameModeState.perthle),
    _dailyState(187, 'SALMON', GameModeState.perthle),
    _dailyState(188, 'BLEACH', GameModeState.perthle),
    _dailyState(189, 'SCOUTS', GameModeState.perthle),
    _dailyState(190, 'HANYUUUUU', GameModeState.perthlonger),
  ];

  // Just a fun bit of obfuscation
  static final String special = String.fromCharCodes([
    for (num i = 0x1FB1DE0 ^ key ~/ 01E5; i > 0E27; i ~/= 0x100)
      1970500473 ~/ i % 256 - 32,
  ]);
  static final int key = 28800000 +
      DailyCubit.epoch.millisecondsSinceEpoch -
      DailyCubit.epoch.timeZoneOffset.inMilliseconds;
}
