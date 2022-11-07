import 'package:flutter/material.dart';

import 'quiz_question_model.dart';

const backgroundColor = Color.fromRGBO(45, 27, 3, 1);
const foregroundColor = Color.fromRGBO(240, 140, 6, 1);

List<QuizQuestionModel> quizQuestion = [
  QuizQuestionModel(
    question: "The Homolographic projection has the correct representation of",
    answer: "2",
    options: ["shape", "area", "baring", "distance"],
  ),
  QuizQuestionModel(
    question: "The great Victoria Desert is located in",
    answer: "3",
    options: ["Canada", "West Africa", "Australia", "North America"],
  ),
  QuizQuestionModel(
    question: "The intersecting lines drawn on maps and globes are",
    answer: "3",
    options: [
      "latitudes",
      "longitudes",
      "geographic grids",
      "None of the above"
    ],
  )
];
