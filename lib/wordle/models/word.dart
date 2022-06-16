import 'package:equatable/equatable.dart';
import 'package:wordle_clone/wordle/wordle.dart';

class Word extends Equatable {
  const Word({required this.letters});

  factory Word.fromString(String word) =>
      Word(letters: word.split('').map((e) => Letter(val: e)).toList());

  final List<Letter> letters;

  String get wordString => letters.map((e) => e.val).join();

  void addLetter(String val) {
    final current_index = letters.indexWhere((element) => element.val.isEmpty);
    if (current_index != -1) {
      letters[current_index] = Letter(val: val);
    }
  }

  void removeLetter() {
    final current_index =
        letters.lastIndexWhere((element) => element.val.isNotEmpty);
    if (current_index != -1) {
      letters[current_index] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}
