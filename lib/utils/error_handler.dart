String mapErrorToMessage(Object error) {
  final errorStr = error.toString();
  if (errorStr.contains("SocketException")) {
    return "No internet connection .Please check your network  ";
  } else if (errorStr.contains("TimeoutException")) {
    return "Request time out! try again later";
  } else if (errorStr.contains("FormatException")) {
    return "Bad response from server";
  } else {
    return "Something went wrong:$error";
  }
}
