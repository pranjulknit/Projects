import 'package:flutter/material.dart';
import 'package:quiz_app/const.dart';
import 'package:quiz_app/play_quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  int correctAnswer, wrongAnswers;
  ResultScreen({Key? key, required this.correctAnswer, this.wrongAnswers = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: foregroundColor,
        iconTheme: IconThemeData(color: backgroundColor),
        centerTitle: true,
        title: Text(
          "Result",
          style: TextStyle(color: backgroundColor),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              answerTab("Correct Answer", correctAnswer),
              answerTab("Wrong Answer", wrongAnswers),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PlayQuizScreen()),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(primary: foregroundColor),
              child: Text(
                "Reset Quiz",
                style: TextStyle(color: backgroundColor),
              )),
        ]),
      ),
    );
  }

  Widget answerTab(String title, int value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          "$value",
          style: TextStyle(
              color: foregroundColor,
              fontSize: 60,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
