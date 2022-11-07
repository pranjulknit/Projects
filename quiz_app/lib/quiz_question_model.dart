class QuizQuestionModel {
  final String question;
  final String answer;
  final List<String> options;

  QuizQuestionModel(
      {required this.question, required this.answer, 
      required this.options});
}
