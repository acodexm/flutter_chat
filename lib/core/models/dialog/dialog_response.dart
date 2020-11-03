class DialogResponse {
  final Map<String, dynamic> answers;
  final bool confirmed;

  DialogResponse({
    this.answers,
    this.confirmed,
  });

  @override
  String toString() {
    return 'DialogResponse{answers: ${answers.toString()}, confirmed: $confirmed}';
  }
}
