import 'package:flutter/material.dart';
import 'package:quiz_app/const.dart';
import 'package:quiz_app/play_quiz_screen.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Start Quiz'),
          centerTitle: true,
          backgroundColor: foregroundColor,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Quiz App',
                style: TextStyle(
                    backgroundColor: foregroundColor,
                    fontSize: 45,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 0,
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayQuizScreen()));
                  },
                  style: ElevatedButton.styleFrom(primary: foregroundColor),
                  child: Text(
                    "Start Quiz",
                    style: TextStyle(color: backgroundColor),
                  )),
            ],
          ),
        ));
  }
}
