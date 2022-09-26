import 'package:equatable/equatable.dart';

class LibraryWordState extends Equatable {
  const LibraryWordState({
    required this.word,
    required this.lastUsed,
    required this.oneOff,
  });

  LibraryWordState.fromJson(final Map<String, dynamic> json)
      : this(
          word: json['word'],
          lastUsed: json['lastUsed'],
          oneOff: json['oneOff'],
        );

  final String word;
  final DateTime lastUsed;
  final bool oneOff;

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'lastUsed': lastUsed,
      'oneOff': oneOff,
    };
  }

  LibraryWordState copyWith({
    final String? word,
    final DateTime? lastUsed,
    final bool? oneOff,
  }) {
    return LibraryWordState(
      word: word ?? this.word,
      lastUsed: lastUsed ?? this.lastUsed,
      oneOff: oneOff ?? this.oneOff,
    );
  }

  @override
  List<Object?> get props => [word, lastUsed, oneOff];
}
