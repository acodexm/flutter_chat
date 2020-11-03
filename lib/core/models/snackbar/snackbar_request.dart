class SnackbarRequest {
  String title = '';
  String message = '';
  String actionButton;
  int duration = 3;

  SnackbarRequest({this.title, this.message, this.duration, this.actionButton});

  @override
  String toString() {
    return 'SnackbarRequest{title: $title, message: $message, actionButton: $actionButton, duration: $duration}';
  }
}
