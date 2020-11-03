bool isLastMessageLeft(dynamic listMessage,int index, String id) {
  if ((index > 0 &&
      listMessage != null &&
      listMessage[index - 1]['idFrom'] == id) ||
      index == 0) {
    return true;
  } else {
    return false;
  }
}


bool isLastMessageRight(dynamic listMessage,int index, String id) {
  if ((index > 0 &&
      listMessage != null &&
      listMessage[index - 1]['idFrom'] != id) ||
      index == 0) {
    return true;
  } else {
    return false;
  }
}

