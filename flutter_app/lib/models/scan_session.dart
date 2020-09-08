class Session {
  int id;
  String name;
  int timestamp;
  bool deleted;
  bool sent;
  int userId;
  List<String> scannedCodes;

  Session() {
    scannedCodes = [];
    deleted = false;
    sent = false;
  }

  bool addCode(String code) {
    if (scannedCodes.any((element) => element == code)) {
      return false;
    } else {
      scannedCodes.add(code);
      return true;
    }
  }
}
