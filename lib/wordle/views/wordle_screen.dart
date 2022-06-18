import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle_clone/app/app_colors.dart';
import 'package:wordle_clone/wordle/utils/api_constants.dart';
import 'package:wordle_clone/wordle/wordle.dart';

enum GameStatus { playing, submitting, lost, won }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  final Set<Letter> _keyboard_letters = {};

  var _current_word_index = 0;

  Word? get _current_word =>
      _current_word_index < _board.length ? _board[_current_word_index] : null;

  // ignore: prefer_final_fields
  Word _solution = Word.fromString('WORDS');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ERICDLE',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 4),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board),
          const SizedBox(
            height: 80,
          ),
          Keyboard(
              onKeyTapped: _onKeyTapped,
              onDeleteTapped: _onDeleteTapped,
              onEnterTapped: _onEnterTapped,
              letters: _keyboard_letters)
        ],
      ),
    );
  }

  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _current_word?.addLetter(val));
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _current_word?.removeLetter());
    }
  }

  void _onEnterTapped() {
    if (_gameStatus == GameStatus.playing &&
        _current_word != null &&
        !_current_word!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;

      _evalWord();

      _checkIfWinOrLoss();
    }
  }

  void _evalWord() {
    for (var i = 0; i < _current_word!.letters.length; i++) {
      final currentWordLetter = _current_word!.letters[i];
      final currentSolutionLetter = _solution.letters[i];

      setState(() {
        if (currentWordLetter == currentSolutionLetter) {
          _current_word!.letters[i] =
              currentWordLetter.copyWith(status: LetterStatus.correct);
        } else if (_solution.letters.contains(currentWordLetter)) {
          _current_word!.letters[i] =
              currentWordLetter.copyWith(status: LetterStatus.in_word);
        } else {
          _current_word!.letters[i] =
              currentWordLetter.copyWith(status: LetterStatus.not_in_word);
        }
      });

      final letter = _keyboard_letters.firstWhere(
        (element) => element.val == currentWordLetter.val,
        orElse: () => Letter.empty(),
      );

      if (letter.status != LetterStatus.correct) {
        _keyboard_letters.removeWhere((e) => e.val == currentWordLetter.val);
        _keyboard_letters.add(_current_word!.letters[i]);
      }
    }
  }

  void _checkIfWinOrLoss() {
    if (_current_word!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.none,
        duration: const Duration(days: 1),
        backgroundColor: correct_color,
        content: const Text(
          'You Won!',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: _restart,
          textColor: Colors.white,
          label: 'New Game',
        ),
      ));
    } else if (_current_word_index + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.none,
        duration: const Duration(days: 1),
        backgroundColor: Colors.redAccent[200],
        content: Text(
          'You Lost! Solution: ${_solution.wordString}',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: _restart,
          textColor: Colors.white,
          label: 'New Game',
        ),
      ));
    } else {
      _gameStatus = GameStatus.playing;
    }
    _current_word_index += 1;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _current_word_index = 0;
      _board
        ..clear()
        ..addAll(List.generate(
            6, (_) => Word(letters: List.generate(5, (_) => Letter.empty()))));
      _getWord();
      _keyboard_letters.clear();
    });
  }

  _getWord() {
    fetchRandomFiveLetterWord().then((String value) {
      if (mounted) {
        setState(() {
          _solution = Word.fromString(value.toUpperCase());
        });
      }
    });
  }
}
