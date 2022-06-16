import 'package:flutter/material.dart';
import 'package:wordle_clone/wordle/wordle.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wordle App Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: WordleScreen(),
      // home: const WordleScreen(),
    );
  }
}
