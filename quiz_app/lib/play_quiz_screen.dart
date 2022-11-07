import 'package:flutter/material.dart';
import 'package:quiz_app/const.dart';
import 'package:quiz_app/quiz_question_model.dart';

import 'result_screen.dart';

class PlayQuizScreen extends StatefulWidget {
  PlayQuizScreen({Key? key}) : super(key: key);

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  final PageController pageController = PageController();
  bool isAnswered = false;
  int currentIndex = 0, correctAns = 0, wrongAns = 0;
  String correctAnswer = "";
  String selcetedAnswer = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: backgroundColor),
        backgroundColor: foregroundColor,
        title: Text(
          'Play Quiz',
          style: TextStyle(color: backgroundColor),
        ),
      ),
      body: PageView.builder(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: quizQuestion.length,
          itemBuilder: (context, index) {
            QuizQuestionModel model = quizQuestion[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      model.question,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: List.generate(
                      model.options.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isAnswered = true;
                              selcetedAnswer = model.options[index];
                              correctAnswer = model.answer;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: foregroundColor),
                                borderRadius: BorderRadius.circular(10),
                                color: selcetedAnswer == model.options[index]
                                    ? foregroundColor
                                    : backgroundColor),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              model.options[index],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (isAnswered) {
            if (selcetedAnswer == correctAnswer) {
              correctAns++;
            } else {
              wrongAns++;
            }

            currentIndex++;
            if (currentIndex != quizQuestion.length) {
              pageController.jumpToPage(currentIndex);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      correctAnswer: correctAns,
                      wrongAnswers: wrongAns,
                    ),
                  ));
            }
            pageController.jumpToPage(currentIndex);
            print("Corret Answers : $correctAns");
            print("Wrong Answers : $wrongAns");
          } else {
            print('please Select an answer');
          }
        },
        child: Container(
            height: 70,
            color: foregroundColor,
            alignment: Alignment.center,
            child: Text(
              'Next',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: backgroundColor),
            )),
      ),
    );
  }
}
